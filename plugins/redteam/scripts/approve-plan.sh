#!/usr/bin/env bash
# approve-plan.sh — write the live-execution APPROVAL token. This is the HUMAN
# gate: it is meant to be run by the operator (the person), not by the agent, and
# it requires an explicit typed confirmation phrase. The token binds to the exact
# AUTHORIZED SCOPE fingerprint, so it cannot be reused for a different or widened
# scope, and it is invalidated at teardown.
#
#   approve-plan.sh --engagement <dir> --confirm "I APPROVE LIVE PROBES"
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$HERE/lib/common.sh"

ENGAGEMENT=""; CONFIRM=""
while [ $# -gt 0 ]; do case "$1" in
  --engagement) ENGAGEMENT="$2"; shift 2 ;;
  --confirm) CONFIRM="$2"; shift 2 ;;
  *) rt_die 1 "unknown arg: $1" ;;
esac; done
[ -n "$ENGAGEMENT" ] || rt_die 1 "usage: approve-plan.sh --engagement <dir> --confirm \"I APPROVE LIVE PROBES\""
[ -f "$ENGAGEMENT/scope.json" ] || rt_die 1 "no scope.json — run intake (Phase 0) first"
[ -f "$ENGAGEMENT/plan.md" ]    || rt_die 1 "no plan.md — build and review the plan first"

ATTESTED="$(rt_json_get "$ENGAGEMENT/scope.json" authorization_attested)"
[ "$ATTESTED" = "true" ] || rt_die "$RT_EXIT_APPROVAL" "scope.json authorization is not attested — cannot approve live probes for an unauthorized scope"

if [ "$CONFIRM" != "I APPROVE LIVE PROBES" ]; then
  rt_die "$RT_EXIT_APPROVAL" "confirmation phrase not matched; live approval NOT granted. Re-run with --confirm \"I APPROVE LIVE PROBES\" only if you, the human operator, authorize live probes against the targets in scope.json."
fi

FP="$(rt_scope_fingerprint "$ENGAGEMENT/scope.json")"
EID="$(rt_json_get "$ENGAGEMENT/scope.json" engagement_id)"
cat > "$ENGAGEMENT/APPROVAL" <<TOK
mode=live
fingerprint=$FP
engagement_id=$EID
approved_at=$(rt_now)
approved_by=${USER:-unknown}
TOK
rt_log "APPROVAL written for engagement $EID (scope fingerprint $FP). Live probes are now authorized for THIS scope only."
