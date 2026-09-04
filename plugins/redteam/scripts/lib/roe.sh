#!/usr/bin/env bash
# roe.sh — Rules-of-Engagement scope guard. Sourced by the engine and every probe.
#
# This is the safety spine of a target-agnostic engagement. It self-refuses
# (exit 3) any target that is not inside the AUTHORIZED SCOPE the operator
# declared at intake (scope.json), and refuses (exit 4) any live run without a
# human-written APPROVAL bound to that exact scope. It is the last-line,
# per-probe barrier that holds even if the PreToolUse hook is absent.
#
# The authorized scope is data the operator attested to — never inferred, never
# widened by the agent. "localhost" is not special: a local target is simply a
# scope whose in_scope_patterns include localhost. There is no hard-coded target.

_ROE_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
. "$_ROE_LIB_DIR/common.sh"

# roe_require_engagement <engagement-dir> — sets ROE_* globals from scope.json.
# Requires an authorization attestation before any downstream action is allowed.
roe_require_engagement() {
  local dir="$1"
  [ -n "$dir" ] && [ -d "$dir" ] || rt_die "$RT_EXIT_SCOPE" "engagement dir missing: $dir"
  ROE_DIR="$dir"
  ROE_SCOPE_JSON="$dir/scope.json"
  [ -f "$ROE_SCOPE_JSON" ] || rt_die "$RT_EXIT_SCOPE" "no scope.json in $dir — run intake (Phase 0) first; nothing runs before scope is declared and authorized"

  # HARD GATE: the operator must have attested authorization for the scope.
  local attested; attested="$(rt_json_get "$ROE_SCOPE_JSON" authorization_attested)"
  [ "$attested" = "true" ] || rt_die "$RT_EXIT_SCOPE" "scope.json authorization is not attested — a human must confirm authorization at intake before any phase runs"

  ROE_ENGAGEMENT_ID="$(rt_json_get "$ROE_SCOPE_JSON" engagement_id)"
  ROE_FINGERPRINT="$(rt_scope_fingerprint "$ROE_SCOPE_JSON")"

  # Cache the allow/deny pattern sets for fast repeated matching.
  ROE_ALLOW="$(rt_scope_allow "$ROE_SCOPE_JSON")"
  ROE_DENY="$(rt_json_array "$ROE_SCOPE_JSON" out_of_scope)"
  [ -n "$ROE_ALLOW" ] || rt_die "$RT_EXIT_SCOPE" "scope.json declares no in_scope_patterns on any target — refusing (an empty allow-list means nothing is authorized)"
}

# _roe_matches <candidate> <patterns-newline-list> — true if candidate equals or
# glob-matches any pattern. Patterns are exact strings or shell globs
# (e.g. "app.example.com", "*.example.com", "10.0.0.0/24", "localhost").
_roe_matches() {
  local candidate="$1" patterns="$2" p
  while IFS= read -r p; do
    [ -n "$p" ] || continue
    # shellcheck disable=SC2254  # intentional glob match
    case "$candidate" in $p) return 0 ;; esac
    [ "$candidate" = "$p" ] && return 0
  done <<EOF
$patterns
EOF
  return 1
}

# roe_assert_in_scope <candidate> — the candidate target (host/URL/IP/label a
# probe is about to act on) MUST match the authorized allow-list and MUST NOT
# match the out-of-scope deny-list. This is the barrier that makes "point it at
# anything" safe: only what the operator authorized is ever touched.
roe_assert_in_scope() {
  local candidate="$1"
  [ -n "$candidate" ] || rt_die "$RT_EXIT_SCOPE" "empty target — refusing"
  if _roe_matches "$candidate" "$ROE_DENY"; then
    rt_die "$RT_EXIT_SCOPE" "target '$candidate' matches an out_of_scope pattern — refusing"
  fi
  if _roe_matches "$candidate" "$ROE_ALLOW"; then
    return 0
  fi
  rt_die "$RT_EXIT_SCOPE" "target '$candidate' is not in the authorized scope for engagement ${ROE_ENGAGEMENT_ID:-?} — refusing"
}

# roe_guard_live <engagement-dir> — primary approval barrier for live probes.
# Requires <dir>/APPROVAL with mode=live and a fingerprint matching the CURRENT
# scope fingerprint (so a widened scope invalidates a prior approval).
roe_guard_live() {
  local dir="$1" approval="$1/APPROVAL"
  [ -f "$approval" ] || rt_die "$RT_EXIT_APPROVAL" "live run requires approval token $approval (dry-run is the default)"
  local amode afp
  amode="$(sed -n 's/^mode=//p' "$approval" | head -n1)"
  afp="$(sed -n 's/^fingerprint=//p' "$approval" | head -n1)"
  [ "$amode" = "live" ] || rt_die "$RT_EXIT_APPROVAL" "APPROVAL does not authorize live mode (mode=$amode)"
  local want; want="$(rt_scope_fingerprint "$dir/scope.json")"
  [ -n "$want" ] && [ "$afp" = "$want" ] || rt_die "$RT_EXIT_APPROVAL" "APPROVAL fingerprint does not match the current authorized scope — refusing (scope changed since approval?)"
  return 0
}
