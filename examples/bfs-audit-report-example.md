# BFS Audit Report — *Example App* (illustrative sample)

> This is a fabricated example showing the output format the `bfs-audit` skill produces.
> It is not a real audit. Your report will be written to `bfs-audit-report.md` in the
> root of the project being audited (or `audit-reports/bfs-audit-report.md`).

**Summary:** 12 pass · 6 fail · 9 need verification · 4 N/A — biggest blockers are **3.2.2** (Asset API writes to theme files), **4.1.3** (custom button colors instead of Polaris tokens), and **5.5.2** (draft orders used for discounts).

**Scope:** entire embedded admin app (Remix), commit `abc1234`. Categories audited: 5.5 Discounts only.
**Source of truth:** built-in checklist (`references/bfs-requirements.md`) + live page re-fetched 2026-09-18.

---

## 1. Prerequisites

- [ ] **1.1.1 — Meet App Store requirements** — Needs Verification — App Store requirements are evaluated by Shopify, not derivable from code. Confirm your listing passes the app requirements checklist.
- [ ] **1.1.2 — Good Partner standing** — Needs Verification — Partner account status lives in the Partner Dashboard. Confirm no active or outstanding infractions.
- [ ] **1.2.1 — Minimum installs (≥50 net on paid plans)** — Needs Verification — **Not code-auditable.** Pull net installs from Partner Dashboard.
- [ ] **1.2.2 — Minimum reviews (≥5)** — Needs Verification — **Not code-auditable.** Check the App Store listing.
- [ ] **1.2.3 — Minimum rating threshold** — Needs Verification — **Not code-auditable.** Check recent rating in Partner Dashboard.
- [x] **1.2.x (supporting)** — Pass — No code-level blockers found in this area.

## 2. Performance

- [ ] **2.1.1 — LCP ≤ 2.5s (p75, 28d)** — Needs Verification — Requires Web Vitals percentiles from Partner Dashboard. Code signal: hero chart is lazy-loaded (`React.lazy`), which is encouraging.
- [x] **2.1.2 — CLS ≤ 0.1** — Pass — Skeleton loaders in `app/routes/app._index.tsx` reserve layout space; no late-loading content shifts observed.
- [ ] **2.1.3 — INP ≤ 200ms** — Needs Verification — Needs live percentiles. Code signal: no blocking long tasks found, but this can't be asserted from static review.
- [ ] **2.2.1 — Storefront Lighthouse regression ≤ 10 pts** — Needs Verification — Requires a before/after Lighthouse run on a store with the app installed.
- [x] **2.3.1 — Checkout rate p95 ≤ 500ms** — N/A — App does not provide carrier rates.

## 3. Integration

- [x] **3.1.1 — Embed in Shopify admin** — Pass — `app-bridge.js` is loaded in `<head>` of every document (`app/root.tsx`), and authentication uses ID tokens via `authenticate.admin()`.
- [x] **3.1.2 — Primary workflows stay in Shopify** — Pass — Discount creation, listing, and editing all complete inside the embedded admin.
- [x] **3.1.3 — Seamless sign-up via Shopify credentials** — Pass — No additional login step after install.
- [x] **3.1.4 — Simplified monitoring/reporting** — Pass — Key metrics (active discounts, redemptions) are surfaced on the app home page.
- [x] **3.1.5 — Third-party connection settings in Shopify** — Pass — Connect/disconnect for the optional analytics provider is available in-app.
- [ ] **3.2.1 — Clean uninstall (theme app extensions)** — Fail — Storefront widget is injected via the Asset API rather than a theme app extension, so it won't be removed on uninstall. **Fix:** convert `assets/discount-banner.liquid` to a theme app extension block.
- [ ] **3.2.2 — No Asset API misuse** — **Fail (blocker)** — `app/services/theme.server.ts:41` calls `assetUpdate` to write `sections/header.liquid`. BFS prohibits creating/modifying/deleting theme files via the Asset API, and this app isn't a page builder or backup/restore app. **Fix:** remove the write path; render via a theme app extension.

## 4. Design

- [x] **4.1.1 — Uses Polaris web components** — Pass — `s-page`, `s-card`, `s-button` used throughout; no custom component library.
- [ ] **4.1.3 — Matches admin look and feel** — Fail — `app/components/SaveButton.tsx` overrides the primary button to `#0a5cff` instead of Polaris tokens. **Fix:** drop the custom color and use the default Polaris primary action.
- [x] **4.2.1 — Helpful error messages** — Pass — Validation errors render inline, in red, next to the offending field.
- [ ] **4.2.4 — Onboarding** — Needs Verification — An onboarding flow exists but its helpfulness is a judgement call; needs a manual click-through.
- [ ] **4.3.x — No dark patterns** — Needs Verification — No pressure tactics, guilt copy, or locked-but-visible premium features found in code, but promotional modals need manual review for dismissibility.

## 5. Category-specific (5.5 Discount apps)

- [x] **5.5.1 — Use discount functions or native APIs** — Pass — Uses native discount APIs.
- [ ] **5.5.2 — No draft orders for custom discounts** — **Fail (blocker)** — `app/routes/app.discounts.new.tsx:88` builds a draft order to apply a custom discount. BFS prohibits this. **Fix:** migrate to a discount function.
- [x] **5.5.3 — `discountRedeemCodeBulkAdd` for multi-code discounts** — Pass — Bulk code creation already uses this mutation.
- [ ] **5.5.4 — Discounts-page links land on a compliant page** — Needs Verification — Requires a manual click-through from the Discounts page.

---

## Top fixes

1. **3.2.2 — Stop writing theme files via the Asset API** *(blocks BFS eligibility)* — remove the `assetUpdate` call and render through a theme app extension.
2. **5.5.2 — Stop using draft orders for custom discounts** *(blocks eligibility)* — migrate to a discount function.
3. **3.2.1 — Move the storefront widget to a theme app extension** so uninstall is clean.
4. **4.1.3 — Use Polaris default button styling** — small change, visible review finding.
5. **Cheap verifications to clear:** pull Web Vitals percentiles (2.1.1, 2.1.3), run a Lighthouse diff (2.2.1), and click through onboarding + the Discounts-page link (4.2.4, 5.5.4).