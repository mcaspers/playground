#!/usr/bin/env bash
# run-probes.sh — the generic, guarded probe executor.
#
# The plugin ships NO fixed probe library. A probe is whatever the planner/operator
# constructs from the selected test catalog (OWASP WSTG, NIST SP 800-115 techniques,
# CIS checks, etc.) for THIS engagement's authorized target. This script is the safe
# way to run one: it enforces scope, gates live execution, and captures evidence.
#
#   run-probes.sh --engagement <dir> --id <probe-id> --target <candidate>
#                 [--technique <ATT&CK id>] [--expected "<secure oracle>"]
#                 --mode <dry|live> -- <command ...>
#
# Contract:
#   * --target is asserted IN SCOPE (scope.json) before anything runs. Out-of-scope
#     or unauthorized targets are refused (exit 3).
#   * dry mode DESCRIBES the command; it never executes it.
#   * live mode requires <dir>/APPROVAL (mode=live, fingerprint == current scope).
#     The PreToolUse hook is a redundant second barrier. Only a human writes APPROVAL.
#   * The command after `--` is executed verbatim in live mode; its stdout+stderr are
#     captured under evidence/<id>.log and one JSON result line is emitted.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$HERE/lib/roe.sh"

ENGAGEMENT=""; ID=""; TARGET=""; TECHNIQUE="n/a"; EXPECTED="n/a"; MODE="dry"
CMD=()
while [ $# -gt 0 ]; do case "$1" in
  --engagement) ENGAGEMENT="$2"; shift 2 ;;
  --id) ID="$2"; shift 2 ;;
  --target) TARGET="$2"; shift 2 ;;
  --technique) TECHNIQUE="$2"; shift 2 ;;
  --expected) EXPECTED="$2"; shift 2 ;;
  --mode) MODE="$2"; shift 2 ;;
  --live) MODE="live"; shift ;;
  --) shift; CMD=("$@"); break ;;
  *) rt_die 1 "unknown arg: $1" ;;
esac; done

[ -n "$ENGAGEMENT" ] || rt_die 1 "usage: run-probes.sh --engagement <dir> --id <id> --target <candidate> --mode <dry|live> -- <command ...>"
[ -n "$ID" ]     || rt_die 1 "a --id is required (a stable probe identifier)"
[ -n "$TARGET" ] || rt_die 1 "a --target is required (the host/URL/IP the probe acts on) so scope can be enforced"
[ "$MODE" = "dry" ] || [ "$MODE" = "live" ] || rt_die 1 "mode must be dry|live"

roe_require_engagement "$ENGAGEMENT"     # loads scope, enforces authorization attestation
roe_assert_in_scope "$TARGET"            # exits 3 if target is not authorized

EV="$ENGAGEMENT/evidence"; mkdir -p "$EV"
LOG="$EV/$ID.log"
RESULTS="$ENGAGEMENT/results.jsonl"

if [ "$MODE" = "dry" ]; then
  {
    echo "# DRY RUN — probe $ID"
    echo "# target:    $TARGET (verified in-scope)"
    echo "# technique: $TECHNIQUE"
    echo "# expected:  $EXPECTED"
    echo "# would run: ${CMD[*]:-<no command supplied>}"
  } > "$LOG"
  rt_result "$ID" "$TECHNIQUE" "dry" "$EXPECTED" "described only (dry-run)" "not-run" "evidence/$ID.log" >> "$RESULTS"
  cat "$LOG"
  exit 0
fi

# --- live ---
[ "${#CMD[@]}" -gt 0 ] || rt_die 1 "live run needs a command after --"
roe_guard_live "$ENGAGEMENT"             # exits 4 if not authorized for this scope
rt_log "LIVE probe $ID authorized (scope fingerprint $ROE_FINGERPRINT)"

{
  echo "# LIVE — probe $ID against $TARGET at $(rt_now)"
  echo "# command: ${CMD[*]}"
  echo "# ---"
} > "$LOG"
if "${CMD[@]}" >>"$LOG" 2>&1; then
  rt_result "$ID" "$TECHNIQUE" "live" "$EXPECTED" "executed; see evidence/$ID.log" "candidate-finding" "evidence/$ID.log" >> "$RESULTS"
else
  code=$?
  echo "# (command exited $code)" >> "$LOG"
  rt_result "$ID" "$TECHNIQUE" "live" "$EXPECTED" "command exited $code; see evidence/$ID.log" "blocked" "evidence/$ID.log" >> "$RESULTS"
fi
cat "$LOG"
echo
echo "result appended -> $RESULTS"
