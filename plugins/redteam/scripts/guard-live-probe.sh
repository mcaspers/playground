#!/usr/bin/env bash
# guard-live-probe.sh — PreToolUse hook. Redundant second barrier that DENIES any
# Bash command which tries to run the probe executor in live mode unless a valid
# APPROVAL token exists for the referenced engagement, bound to the current
# authorized scope.
#
# Reads the hook JSON on stdin; extracts tool_input.command. Exit 2 + a deny
# decision blocks the tool call. Exit 0 defers to normal permission flow.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$HERE/lib/common.sh"

INPUT="$(cat)"
# Extract tool_input.command from the hook JSON on stdin.
if command -v jq >/dev/null 2>&1; then
  CMD="$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || true)"
elif command -v python3 >/dev/null 2>&1; then
  CMD="$(printf '%s' "$INPUT" | python3 -c 'import json,sys;print(json.load(sys.stdin).get("tool_input",{}).get("command",""))' 2>/dev/null || true)"
else
  CMD="$(printf '%s' "$INPUT" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\(.*\)".*/\1/p')"
fi

deny() { # <reason>
  local reason; reason="$(printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g')"
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' "$reason"
  exit 2
}

# Only concerned with live probe-executor invocations.
case "$CMD" in
  *run-probes.sh*) : ;;
  *) exit 0 ;;
esac
case "$CMD" in
  *"--mode live"*|*"--live"*) : ;;
  *) exit 0 ;;   # dry-run is always allowed
esac

# Extract --engagement <dir> from the command.
ENG="$(printf '%s' "$CMD" | sed -n 's/.*--engagement[= ]\{1,\}\([^ ]*\).*/\1/p' | head -n1)"
[ -n "$ENG" ] && [ -d "$ENG" ] || deny "live probe run has no resolvable --engagement dir; refusing"

SCOPE="$ENG/scope.json"
[ -f "$SCOPE" ] || deny "live probe blocked: no scope.json in $ENG (run intake first)"
[ "$(rt_json_get "$SCOPE" authorization_attested)" = "true" ] || deny "live probe blocked: scope authorization is not attested"

APPROVAL="$ENG/APPROVAL"
[ -f "$APPROVAL" ] || deny "live probe blocked: no APPROVAL token in $ENG (dry-run is the default; a human must approve the plan first)"
AMODE="$(sed -n 's/^mode=//p' "$APPROVAL" | head -n1)"
AFP="$(sed -n 's/^fingerprint=//p' "$APPROVAL" | head -n1)"
WANT="$(rt_scope_fingerprint "$SCOPE")"
[ "$AMODE" = "live" ] || deny "live probe blocked: APPROVAL does not set mode=live"
[ -n "$WANT" ] && [ "$AFP" = "$WANT" ] || deny "live probe blocked: APPROVAL fingerprint does not match the current authorized scope (scope changed since approval?)"

exit 0   # authorized
