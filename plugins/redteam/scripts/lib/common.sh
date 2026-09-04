#!/usr/bin/env bash
# common.sh — shared helpers for the Red Team engagement harness.
# Sourced, never executed directly. No side effects on source.
#
# This library is TARGET-AGNOSTIC. It knows nothing about any specific product,
# vendor, or technology — the target of an engagement is whatever the operator
# declares and authorizes at intake (see scope.json / roe.sh). Nothing here is
# hard-coded to a particular system under test.

# Exit-code taxonomy (stable; the engine and callers rely on it):
#   0  ok
#   2  hook block (guard only)
#   3  RoE scope violation (target not inside the authorized scope)
#   4  approval missing/invalid for a live run
#   5  environment not ready (e.g. target unreachable) — non-fatal for dry mode
RT_EXIT_SCOPE=3
RT_EXIT_APPROVAL=4
RT_EXIT_ENV=5

rt_now() { date -u +%Y-%m-%dT%H:%M:%SZ; }

rt_log() { printf '[redteam] %s\n' "$*" >&2; }

rt_die() { # <exit-code> <message>
  local code="$1"; shift
  rt_log "ERROR: $*"
  exit "$code"
}

# Portable read of a flat JSON string field: rt_json_get <file> <key>
# Tries jq, then python3, then a grep/sed fallback (flat objects only).
rt_json_get() {
  local file="$1" key="$2"
  [ -f "$file" ] || { echo ""; return 0; }
  if command -v jq >/dev/null 2>&1; then
    jq -r --arg k "$key" '.[$k] // empty' "$file"
  elif command -v python3 >/dev/null 2>&1; then
    python3 - "$file" "$key" <<'PY'
import json,sys
try:
    with open(sys.argv[1]) as f: d=json.load(f)
    v=d.get(sys.argv[2],"")
    print("" if v is None else v)
except Exception:
    print("")
PY
  else
    # Flat-object fallback: "key": "value"
    sed -n 's/.*"'"$key"'"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$file" | head -n1
  fi
}

# rt_json_array <file> <key> — print a top-level JSON array of strings, one per
# line (jq/python3 only; empty if neither is present). Used to read the scope
# allow/deny pattern lists out of scope.json.
rt_json_array() {
  local file="$1" key="$2"
  [ -f "$file" ] || return 0
  if command -v jq >/dev/null 2>&1; then
    jq -r --arg k "$key" '.[$k][]? // empty' "$file" 2>/dev/null
  elif command -v python3 >/dev/null 2>&1; then
    python3 - "$file" "$key" <<'PY'
import json,sys
try:
    with open(sys.argv[1]) as f: d=json.load(f)
    for v in (d.get(sys.argv[2]) or []):
        print(v)
except Exception:
    pass
PY
  fi
}

# Stable fingerprint tying an APPROVAL to one engagement scope. The input is the
# canonical scope material (the sorted in-scope pattern set), so an approval
# cannot be reused against a different or widened scope.
rt_fingerprint() { # <material...>
  local s="$*"
  if command -v shasum >/dev/null 2>&1; then
    printf '%s' "$s" | shasum -a 256 | awk '{print $1}'
  elif command -v sha256sum >/dev/null 2>&1; then
    printf '%s' "$s" | sha256sum | awk '{print $1}'
  else
    printf '%s' "$s" | cksum | awk '{print $1}'
  fi
}

# rt_scope_fingerprint <scope.json> — deterministic fingerprint of the authorized
# scope: the sorted union of every target's in_scope_patterns plus the
# out_of_scope list. Recomputed and compared on every live run so a hand-edit to
# widen scope invalidates a prior approval.
rt_scope_fingerprint() {
  local scope="$1" mat
  mat="$( { rt_scope_allow "$scope"; printf 'DENY\n'; rt_json_array "$scope" out_of_scope; } | LC_ALL=C sort | tr '\n' '|' )"
  rt_fingerprint "$mat"
}

# rt_scope_allow <scope.json> — print every in_scope pattern across all targets,
# one per line. jq/python3 only.
rt_scope_allow() {
  local scope="$1"
  [ -f "$scope" ] || return 0
  if command -v jq >/dev/null 2>&1; then
    jq -r '.targets[]?.identity.in_scope_patterns[]? // empty' "$scope" 2>/dev/null
  elif command -v python3 >/dev/null 2>&1; then
    python3 - "$scope" <<'PY'
import json,sys
try:
    with open(sys.argv[1]) as f: d=json.load(f)
    for t in (d.get("targets") or []):
        for p in ((t.get("identity") or {}).get("in_scope_patterns") or []):
            print(p)
except Exception:
    pass
PY
  fi
}

# Emit one JSON result line for a probe (stdout).
rt_result() { # <probe> <technique> <mode> <expected> <observed> <verdict> <evidence>
  printf '{"probe":"%s","technique":"%s","mode":"%s","expected_secure":"%s","observed":"%s","verdict":"%s","evidence":"%s","at":"%s"}\n' \
    "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$(rt_now)"
}

# --- Engagement root under the Red Team home ---------------------------------
#
# Engagement state (RoE, scope, probe evidence, APPROVAL tokens, report) is
# written under a per-user home directory, NOT inside the working tree. Keeping
# it out of any repo means an engagement never mutates a tracked file and never
# collides across projects or `git worktree`s, and it centralizes sensitive
# evidence in one owner-only place. HOME is the single knob.

# rt_path_hash <string> — a short, stable, zero-dependency digest of a string.
# Used only to disambiguate same-named workspaces; not security-sensitive.
rt_path_hash() {
  local s="$1"
  if command -v shasum >/dev/null 2>&1; then
    printf '%s' "$s" | shasum -a 256 | cut -c1-8
  elif command -v sha256sum >/dev/null 2>&1; then
    printf '%s' "$s" | sha256sum | cut -c1-8
  else
    printf '%08x' "$(printf '%s' "$s" | cksum | cut -d' ' -f1)"
  fi
}

# rt_engagement_key [workspace] — "<basename>-<shorthash(abspath)>" for the
# invoking workspace (default: the git worktree root of $PWD, else $PWD). Two
# worktrees of a same-named repo hash distinctly, so their engagement state
# lands under distinct keys and never collides.
rt_engagement_key() {
  local ws="${1:-}"
  if [ -z "$ws" ]; then
    ws="$(git -C "$PWD" rev-parse --show-toplevel 2>/dev/null || pwd -P)"
  fi
  ws="$(cd "$ws" 2>/dev/null && pwd -P || printf '%s' "$ws")"
  printf '%s-%s' "$(basename "$ws")" "$(rt_path_hash "$ws")"
}

# rt_engagement_root [workspace] — the home directory a NEW engagement's state
# belongs under: "$HOME/.redteam/engagements/<key>/<UTC-timestamp>". Pure path
# computation — creates nothing.
rt_engagement_root() {
  printf '%s/.redteam/engagements/%s/%s' \
    "$HOME" "$(rt_engagement_key "${1:-}")" "$(date -u +%Y%m%dT%H%M%SZ)"
}

# rt_new_engagement [workspace] — create the engagement directory (and its
# evidence/ subdir) owner-only and print its path. THE single seam for starting
# an engagement; the methodology and the /redteam command both call it. New dirs
# are 0700 (umask 077); an already-existing shared `~/.redteam` is left untouched.
rt_new_engagement() {
  local eng
  eng="$(rt_engagement_root "${1:-}")"
  ( umask 077; mkdir -p "$eng/evidence" )
  printf '%s' "$eng"
}
