#!/usr/bin/env bash
# new-engagement.sh — create a fresh engagement directory under the Red Team home
# and print its path. Thin CLI over rt_new_engagement so the methodology can be
# run by hand without inlining the library call.
#
#   ENG="$(scripts/new-engagement.sh)"
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$HERE/lib/common.sh"
rt_new_engagement "${1:-}"
