---
name: bfs-audit
description: Use this skill whenever the user wants to audit, review, check, or assess a Shopify app (the whole app, a specific feature, or a PR) against Shopify's "Built for Shopify" (BFS) program requirements — prerequisites, admin/storefront/checkout performance, Shopify admin integration (embedding, App Bridge, navigation, contextual save bar), UX/design guidelines (familiar, helpful, user-friendly / no dark patterns), and category-specific requirements (discounts, subscriptions, fulfillment, returns/exchanges, email/SMS marketing, ads, affiliate, analytics, forms, product reviews, invoices, bundles, carrier services). Trigger on mentions of "Built for Shopify", "BFS", "BFS audit", "BFS checklist", "BFS requirements", "is my app BFS-ready", "will this pass BFS review" — and also when the user asks for their Shopify app's UX/performance/integration to be checked against Shopify's own quality bar without naming "Built for Shopify" explicitly.
license: MIT
metadata:
  version: "1.0.0"
---

# Shopify Built for Shopify (BFS) Audit

Audits a Shopify app's codebase (and, where code can't tell the whole story, its stated behavior) against Shopify's official Built for Shopify requirements, and produces a findings report the user can act on.

## Reference

`references/bfs-requirements.md` holds the full requirements checklist (IDs 1.1.1 through 5.14.5), reorganized for auditing. Read it fully before starting an audit — don't rely on memory of Shopify's docs, since BFS requirements change.

If the user wants the very latest wording or you suspect the bundled checklist may be stale, re-fetch https://shopify.dev/docs/apps/launch/built-for-shopify/requirements (and https://shopify.dev/changelog?filter=built_for_shopify for recent changes) before auditing.

## Workflow

1. **Scope the audit.** Determine, from the conversation or by asking:
   - What's being audited — the whole app, a specific feature/PR, or a specific section (e.g., "just check onboarding against 4.2.2")?
   - Where the code lives — if it's not already open/uploaded, ask for the path or repo.
   - Which category-specific section (5.x) applies, based on what the app does (discounts, subscriptions, fulfillment, etc.) — skip 5.x entirely if none apply.
   - Whether there's a separate embedded Shopify Admin web surface (Remix/Node/etc.) versus a mobile/native companion app — this changes how Sections 2.1, 3, and 4 apply (see the "mobile-app-adjacent" note at the end of the reference file).

2. **Walk the checklist section by section** (1 → 2 → 3 → 4 → applicable 5.x). For each requirement:
   - Look for concrete evidence in the code: grep/view relevant files (App Bridge script tag and version, nav components, save/discard logic, form validation and error rendering, theme app extension usage vs. Asset API calls, discount/subscription/returns API calls used vs. hand-rolled logic, Web Pixel extension usage, etc.).
   - Classify each item: **Pass**, **Fail**, **Needs Verification** (can't be determined from code alone — e.g., install counts, Lighthouse scores, review ratings, live performance percentiles), or **N/A**.
   - For Fail and Needs Verification, note *why* and *what evidence would resolve it* (a metric to pull from Partner Dashboard, a manual click-through to check, etc.).

3. **Produce the report** as a markdown file (this is a structured deliverable the user will act on and likely share — always a file, not inline chat). Structure:
   - One-line summary up top: rough pass/fail/needs-verification counts.
   - A section per checklist area (1–5), each item as `- [ ] ID — requirement — status — evidence/reasoning — fix if failing`.
   - A short "Top fixes" list at the end, prioritized: outright Fails that block BFS eligibility first, then Needs Verification items that are cheap to resolve.

4. Save the report as `bfs-audit-report.md` in the root of the project you're auditing (or at a path the user specifies; to keep the project root clean, use `audit-reports/bfs-audit-report.md` inside it). Never write it into the skill's own directory. Then present it. Don't paste the full checklist into the chat response itself — the file is the deliverable; the chat reply should just summarize the headline findings (e.g., "14 pass, 6 fail, 9 need verification — biggest blockers are X, Y, Z") and point to the file.

## Notes

- Don't guess at things Sections 1.2, 2.1, 2.3, and 5.4/5.8 require live metrics for (install counts, Web Vitals percentiles, rate-endpoint latency, fulfillment SLAs) — these need Partner Dashboard / analytics data the user has, not the codebase. Mark them **Needs Verification** and say what to pull.
- Design requirements (Section 4) often need visual/manual verification (contrast, animation behavior, modal styling) that static code review can only partially confirm — say so rather than asserting Pass/Fail with false confidence.
- If the audited project is Flutter/native mobile rather than an embedded Shopify Admin web app, read the "mobile-app-adjacent architecture" note in the reference file before scoring Sections 2.1–4 — most of those requirements assume an iframe-embedded admin surface exists somewhere.
