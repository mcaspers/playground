#!/usr/bin/env bash
# teardown.sh — close out the engagement. Target-agnostic: the plugin does not
# own the target (it is the operator's authorized system), so teardown does NOT
# destroy the target. It invalidates the live-approval token and records the
# close-out. Any engagement-owned artifacts a specific catalog created (e.g. a
# throwaway account or test file) are the operator's to clean up per the plan.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$HERE/lib/roe.sh"

ENGAGEMENT=""
while [ $# -gt 0 ]; do case "$1" in
  --engagement) ENGAGEMENT="$2"; shift 2 ;;
  *) rt_die 1 "unknown arg: $1" ;;
esac; done
[ -n "$ENGAGEMENT" ] || rt_die 1 "usage: teardown.sh --engagement <dir>"

roe_require_engagement "$ENGAGEMENT"

# Invalidate any APPROVAL so it can never be reused for a future run.
if [ -f "$ENGAGEMENT/APPROVAL" ]; then
  mv "$ENGAGEMENT/APPROVAL" "$ENGAGEMENT/APPROVAL.consumed"
  rt_log "APPROVAL invalidated (moved to APPROVAL.consumed)"
fi

# Record the close-out timestamp.
printf 'closed_at=%s\nengagement_id=%s\n' "$(rt_now)" "${ROE_ENGAGEMENT_ID:-unknown}" > "$ENGAGEMENT/CLOSED"
rt_log "engagement ${ROE_ENGAGEMENT_ID:-?} closed. Evidence retained under $ENGAGEMENT (retention is manual — this is audit material)."
rt_log "Reminder: clean up any engagement-owned artifacts on the target per the plan; the target itself is not modified by teardown."
