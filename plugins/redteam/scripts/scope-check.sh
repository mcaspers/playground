#!/usr/bin/env bash
# scope-check.sh — assert a candidate target is inside the authorized scope.
# Use this BEFORE any target contact (read-only discovery included), so every
# reach at the target is scope-guarded, not just live probes.
#
#   scope-check.sh --engagement <dir> --target <candidate>   # exit 0 in-scope, 3 out
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$HERE/lib/roe.sh"

ENGAGEMENT=""; TARGET=""
while [ $# -gt 0 ]; do case "$1" in
  --engagement) ENGAGEMENT="$2"; shift 2 ;;
  --target) TARGET="$2"; shift 2 ;;
  *) rt_die 1 "unknown arg: $1" ;;
esac; done
[ -n "$ENGAGEMENT" ] || rt_die 1 "usage: scope-check.sh --engagement <dir> --target <candidate>"
[ -n "$TARGET" ]     || rt_die 1 "a --target is required"

roe_require_engagement "$ENGAGEMENT"
roe_assert_in_scope "$TARGET"
rt_log "in scope: $TARGET (engagement ${ROE_ENGAGEMENT_ID:-?})"
