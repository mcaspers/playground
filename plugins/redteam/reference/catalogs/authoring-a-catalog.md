# Authoring a test catalog for a new target kind

The shipped catalogs (`web-url`, `host-network`, `isolation-boundary`) don't cover
every target. When intake derives a `target_kind` with no shipped catalog, author
one — it's a markdown methodology file, not code. This is the intended extension
point; new target kinds never require a change to the engine or the safety model.

## Steps
1. **Ground the kind.** Cite a maintained, offense-oriented class for it (a MITRE
   ATT&CK platform/domain, or an OSSTMM channel for physical/human planes). If
   nothing external fits, mark it `first-party` and say why in one line. See
   [`../target-kinds.md`](../target-kinds.md).
2. **Pick the backing methodology.** Prefer a published per-target standard as the
   test source and, where one exists, a matching verification/oracle standard:
   - web → OWASP WSTG (tests) + ASVS (oracle)
   - host/network → NIST SP 800-115 §3–5 + the platform's CIS Benchmark
   - mobile → OWASP MASVS / MASTG
   - ICS/OT → NIST SP 800-82
   - physical/badging → OSSTMM Physical/Human channel + NIST SP 800-53 PE / SP
     800-116 as the oracle (attack catalog stays hand-curated; mark experimental)
   - anything bespoke → first-party, built on 800-115 + ATT&CK + 800-53
3. **Write the selection menu** as a table: `item · control/objective · probe idea
   (non-destructive by default) · expected-secure oracle`. Keep probes phrased as
   *observable behaviour*.
4. **Map** each item to ATT&CK technique id(s) and NIST SP 800-53 control(s);
   preserve `(analogy)` marks. Note any **design-by-intent non-claims** with a
   "finding only if" clause.
5. **Cite sources** (doc, section, URL) at the bottom, and note version freshness
   for anything that drifts (ATT&CK platforms, CIS benchmark versions, WSTG).

## Rules that keep it safe and honest
- Every probe acts only on in-scope targets — the guard enforces this regardless of
  the catalog.
- Default to non-destructive; anything data-touching or intrusive is called out as
  requiring explicit RoE authorization + human approval.
- Don't overstate a standard's authority. "No clean public catalog exists here,
  this is first-party" is an acceptable and often correct statement.
- Reference the catalog file from `scope.json`'s `test_catalog` field so the planner
  and adjudicator pick it up.
