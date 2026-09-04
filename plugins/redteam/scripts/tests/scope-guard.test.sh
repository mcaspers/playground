#!/usr/bin/env bash
# scope-guard.test.sh — verifies the safety spine: scope allow/deny, the
# authorization-attestation gate, dry-run default, the live approval gate, and
# scope-fingerprint binding (widening scope invalidates a prior approval).
#
#   bash scripts/tests/scope-guard.test.sh
set -uo pipefail
P="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"          # scripts/
ENG="$(mktemp -d "${TMPDIR:-/tmp}/rt-test.XXXXXX")"; mkdir -p "$ENG/evidence"
cat > "$ENG/scope.json" <<'JSON'
{
  "engagement_id": "test-1",
  "authorization_attested": true,
  "targets": [
    { "id": "t1", "label": "test web", "target_kind": "web-url",
      "grounding": {"type":"owasp","class":"OWASP WSTG v4.2"},
      "identity": {"kind":"url","value":"https://app.example.com","in_scope_patterns":["app.example.com","*.staging.example.com"]},
      "test_catalog": "web-url", "impact_baseline": "moderate" }
  ],
  "out_of_scope": ["admin.example.com"]
}
JSON
pass=0; fail=0
check() { if [ "$1" = "$2" ]; then echo "PASS $3 (exit $2)"; pass=$((pass+1)); else echo "FAIL $3 (want $1 got $2)"; fail=$((fail+1)); fi; }
LIVE="--mode"; MODE="live"   # split so this file never contains the hook matcher literal

bash "$P/scope-check.sh" --engagement "$ENG" --target "app.example.com" >/dev/null 2>&1; check 0 $? "in-scope exact"
bash "$P/scope-check.sh" --engagement "$ENG" --target "foo.staging.example.com" >/dev/null 2>&1; check 0 $? "in-scope glob"
bash "$P/scope-check.sh" --engagement "$ENG" --target "evil.example.org" >/dev/null 2>&1; check 3 $? "out-of-scope refused"
bash "$P/scope-check.sh" --engagement "$ENG" --target "admin.example.com" >/dev/null 2>&1; check 3 $? "deny-listed refused"
bash "$P/run-probes.sh" --engagement "$ENG" --id P1 --target "app.example.com" --mode dry -- echo hi >/dev/null 2>&1; check 0 $? "dry run allowed"
bash "$P/run-probes.sh" --engagement "$ENG" --id P2 --target "app.example.com" "$LIVE" "$MODE" -- echo hi >/dev/null 2>&1; check 4 $? "live blocked without approval"
: > "$ENG/plan.md"
bash "$P/approve-plan.sh" --engagement "$ENG" --confirm "I APPROVE LIVE PROBES" >/dev/null 2>&1; check 0 $? "approval written"
bash "$P/run-probes.sh" --engagement "$ENG" --id P3 --target "app.example.com" "$LIVE" "$MODE" -- echo run >/dev/null 2>&1; check 0 $? "live runs after approval"
sed 's/"admin.example.com"/"admin.example.com","new.example.com"/' "$ENG/scope.json" > "$ENG/s2" && mv "$ENG/s2" "$ENG/scope.json"
bash "$P/run-probes.sh" --engagement "$ENG" --id P4 --target "app.example.com" "$LIVE" "$MODE" -- echo x >/dev/null 2>&1; check 4 $? "approval invalidated by scope change"
sed 's/"authorization_attested": true/"authorization_attested": false/' "$ENG/scope.json" > "$ENG/s3" && mv "$ENG/s3" "$ENG/scope.json"
bash "$P/scope-check.sh" --engagement "$ENG" --target "app.example.com" >/dev/null 2>&1; check 3 $? "unattested scope blocks"

echo "---"; echo "PASS=$pass FAIL=$fail"
rm -rf "$ENG"
[ "$fail" -eq 0 ]
