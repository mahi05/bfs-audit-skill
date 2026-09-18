# Built for Shopify (BFS) Requirements — Full Checklist

Source: https://shopify.dev/docs/apps/launch/built-for-shopify/requirements
(Re-check the live page periodically — Shopify updates these requirements; see the BFS changelog at https://shopify.dev/changelog?filter=built_for_shopify)

> **Attribution & disclaimer.** This checklist summarizes requirements published by
> Shopify Inc. at the source URL above. It is an independent, unofficial summary —
> not affiliated with, endorsed by, or sponsored by Shopify Inc. "Shopify" and
> "Built for Shopify" are trademarks of Shopify Inc. Always confirm against the
> canonical source before relying on it.
>
> **Last verified against Shopify docs:** 2026-09-18

Use this as the ground truth when auditing an app. Every item below has an ID (matches the doc's numbering) — reference IDs in the audit report so findings are traceable.

---

## 1. Prerequisites

### 1.1 General
- **1.1.1 Meet App Store requirements** — App must continue to meet Shopify App Store distribution requirements (checklist: https://shopify.dev/docs/apps/launch/app-requirements-checklist). Audited when applying for BFS.
- **1.1.2 Good Partner standing** — Must comply with the Partner Program Agreement and API License/Terms of Use. No active/outstanding infractions on the Partner account.

### 1.2 Merchant utility
- **1.2.1 Minimum installs** — ≥50 net installs from active shops on paid plans.
- **1.2.2 Minimum reviews** — ≥5 reviews.
- **1.2.3 Minimum app rating** — Must meet a minimum recent rating threshold on the Shopify App Store.

*(1.2.x are business/traction metrics, not code — flag as "not code-auditable, verify in Partner Dashboard".)*

---

## 2. Performance

### 2.1 Admin performance
Requires latest App Bridge to enable Web Vitals collection. Measured at 75th percentile over the last 28 days (min. 100 calls each):
- **2.1.1 LCP (Largest Contentful Paint)** ≤ 2.5s
- **2.1.2 CLS (Cumulative Layout Shift)** ≤ 0.1
- **2.1.3 INP (Interaction to Next Paint)** ≤ 200ms

Code signals to check: lazy-loading/code-splitting, image sizing, avoiding layout-shifting late-loading content, minimizing blocking JS, using App Bridge's loading APIs.

### 2.2 Storefront performance
- **2.2.1** App must not reduce storefront Lighthouse performance score by more than 10 points. Check: theme app extension script size/defer/async loading, number of storefront network requests, unnecessary third-party scripts injected into theme.

### 2.3 Checkout performance
- **2.3.1** Carrier-rate fetching/caching must be optimized (see https://shopify.dev/docs/apps/build/performance/checkout). Needs ≥1000 requests/28 days to assess; p95 ≤500ms with ≤0.1% failure rate.

---

## 3. Integration

### 3.1 Embedded apps
- **3.1.1 Embed in Shopify admin** — Use latest Shopify App Bridge (`app-bridge.js` in `<head>` of every doc). Use ID token authentication. Don't embed an external website that mirrors the app's own marketing site.
- **3.1.2 Keep primary workflows within Shopify** — Merchants shouldn't need to leave the embedded admin to complete a primary workflow. Exceptions exist for apps needing a standalone surface (e.g., messaging inbox apps) — see https://shopify.dev/docs/apps/build/integrating-with-shopify#exceptions.
- **3.1.3 Seamless sign-up via Shopify credentials** — No extra login/signup step after install. B2B/contract-based apps get an exception but must still offer Shopify-credential-based connection as onboarding's first step; if both self-serve and B2B signup exist, self-serve via Shopify credentials must be offered.
- **3.1.4 Simplified monitoring/reporting** — Key metrics surfaced on the app home page; if full reporting lives externally, a simplified version must exist in-admin.
- **3.1.5 Third-party connection settings stay in Shopify** — Connect/disconnect of any third-party integration must be manageable from the embedded admin UI.

### 3.2 Installation and asset management
- **3.2.1 Clean uninstall** — Online-store-facing elements must use theme app extensions (not legacy code injection) so blocks are automatically removed on uninstall.
- **3.2.2 No Asset API misuse** — Don't create/modify/delete a merchant's theme files via the Asset API. Exceptions: page builder apps replacing layout/template files, backup/restore apps, SEO/content-locking/dev-tooling apps. Reading via Asset API is fine.

---

## 4. Design

### 4.1 Familiar
- **4.1.1 Follow UX best practices** — Match Shopify admin look/feel (Polaris-like cards, button styles/colors, font, body text size, background color, spacing, WCAG 2.1 AA contrast). No UI flicker/jank. Tab interaction shouldn't alter content above the tabs. Consistent icon usage within a list. Sub-pages need a back button.
- **4.1.2 Mobile-friendly** — Fully responsive: no horizontal scroll, no inaccessible/collapsed content without an expand mechanism, multi-column layouts stack on mobile instead of staying condensed.
- **4.1.3 Concise app name** — Must not truncate in the pinned Shopify nav menu.
- **4.1.4 Use the nav menu** — Use App Bridge `s-app-nav` for primary navigation instead of a custom nav. Sub-page navigation must highlight the correct parent item. App name (not a separate nav item) should link to the app's homepage (Partner Dashboard > Configuration > URLs > App URL). No emojis in the nav menu.
- **4.1.5 Contextual save bar (CSB)** — Use App Bridge's Contextual Save Bar for form saves where reasonable. Merchant must not be able to navigate away from an unsaved form without the CSB Save/Discard prompt.
- **4.1.6 Modals used appropriately** — Use `s-modal`'s `heading`, `primary-action`, `secondary-actions` slots properly (not custom-positioned buttons). Don't use the deprecated Polaris Fullscreen bar.

### 4.2 Helpful
- **4.2.1 Spelling, grammar, phrasing** — No prominent errors in headings/nav/CTAs. Labels/CTAs must have enough context (e.g., a "Time" field must state its unit).
- **4.2.2 Helpful onboarding** — Concise, easy to find (not collapsed/out of view), actually guides merchants to completion. Must not imply installing another app is required. Any info requested from merchants needs a stated reason. Must be dismissible/removable once complete.
- **4.2.3 Helpful homepage** — Must indicate setup/working status. Must surface relevant status for any app blocks/embeds via `app.extensions()`. Must show real metrics/analytics where an app category obviously has them (e.g., email app → open/engagement rates). After dismissing banners, homepage can't be purely static links/welcome text.
- **4.2.4 Helpful error messages** — Red, persistent (not auto-dismissing toasts), shown next to the relevant field, never shown before any merchant interaction, must guide toward a fix.
- **4.2.5 Guide merchants to logical actions** — In a button group, the primary/logical action must be visually dominant, not tied with or subordinate to other actions.
- **4.2.6 Visible previews** — Visual customization must have a live preview, viewable simultaneously with the editor on desktop (no toggling/scrolling required).

### 4.3 User-friendly (no dark patterns)
- **4.3.1 Don't make false claims** — No guaranteed/implied merchant outcomes (e.g., "increase sales by 18%"); no misrepresenting another app's rating in cross-promotion.
- **4.3.2 Don't pressure merchants** — No countdown timers pushing upgrades, no guilt/shame-inducing copy, no rewards conditioned on 5-star reviews.
- **4.3.3 Don't distract merchants** — No modals/popovers that appear automatically on load/timer/unrelated action; no large elements dramatically animating in; no animation to draw attention unrelated to a merchant action; red reserved for errors/destructive actions only.
- **4.3.4 Don't overwhelm merchants** — Break large forms into logical groups; no 2+ banners in close proximity; no multi-paragraph text walls where concise/scannable copy would do.
- **4.3.5 Don't impersonate Shopify** — App icon must not resemble a first-party Shopify app icon; don't reuse Shopify's Sidekick icon or "magic purple" for AI features.
- **4.3.6 Dismissible ads** — All promo content must be dismissible and must not resurface after dismissal.
- **4.3.7 Label and disable premium features** — Plan-gated features must be visually AND functionally disabled until unlocked, clearly labeled with the required tier; Shopify Plus-exclusive features must be hidden entirely from non-Plus merchants.

---

## 5. Category-specific requirements

Only applicable if the app falls into one of these categories. Ask the user (or infer from the app's function) which apply before auditing this section.

| Category | Key requirements |
|---|---|
| **5.1 Ads apps** | Use Web Pixel extensions (not script tags) for attribution/audience/analytics/retargeting (5.1.1). Support Shopify-admin-defined segments via a customer segment action extension (5.1.2). |
| **5.2 Affiliate program apps** | Use Web Pixel extensions, not script tags (5.2.1). |
| **5.3 Analytics apps** | Use Web Pixel extensions, not script tags (5.3.1). |
| **5.4 Carrier services apps** | Rate endpoint: p95 <500ms (5.4.1), ≥99.9% success rate (5.4.2), over last 28 days (min 1000 requests to assess). |
| **5.5 Discount apps** | Use discount functions or native discount APIs — not ad hoc logic (5.5.1). Don't use draft orders for custom discounts (5.5.2). Use `discountRedeemCodeBulkAdd` for multi-code discounts (5.5.3). Links from the Discounts page must land on a compliant in-app discount-creation page (5.5.4). |
| **5.6 Email marketing apps** | Web Pixel extensions for automation/segmentation/analytics/pixels (5.6.1). Sync customer data per API Terms (5.6.2). Support Shopify segments via action extension (5.6.3). Use the Visitors API to log identifying info from Online Store (5.6.4). |
| **5.7 Forms apps** | Support Shopify segments via action extension (5.7.1). Use Visitors API (5.7.2). Sync customer data per API Terms (5.7.3). |
| **5.8 Fulfillment services apps** | ≥100 fulfillment orders/28 days active (5.8.1). ≥97% completion rate (5.8.2). ≥99% successful callback responses (5.8.3). Only fulfill after merchant request (5.8.4). ≥80% of fulfillments get tracking info added within 1hr (5.8.5). ≥95% of fulfillment requests responded to within 24hr (5.8.6). ≥99% of cancellation requests responded to within 24hr (5.8.7). |
| **5.9 Invoices/receipts apps** | Use an admin print action extension for per-order and bulk printing from the Orders pages (5.9.1). |
| **5.10 Product bundles apps** | Use GraphQL Admin API static bundles or `cartTransform` for customized bundles; other methods only for unsupported use cases (subscriptions, unsupported channels, post-purchase edits) (5.10.1). |
| **5.11 Product reviews apps** | Provide a Flow trigger on new review collected (5.11.1). Provide an admin block extension on customer detail pages showing that customer's reviews (5.11.2). |
| **5.12 Returns/exchanges apps** | Sync all return lifecycle events via the proper mutations — create/ship/restock/remove-item/cancel/close/refund (5.12.1). Create/remove exchange line items correctly (5.12.2). Add shipping/restocking fees when applicable (5.12.3). Use Customer Account API for auth (5.12.4). |
| **5.13 SMS marketing apps** | Web Pixel extensions for automation/segmentation/analytics/pixels (5.13.1). Sync customer data per API Terms (5.13.2). Support Shopify segments via action extension (5.13.3). Use Visitors API (5.13.4). |
| **5.14 Subscription apps** | Use Selling Plan API, Subscription Contract API, Customer Payment Method API (5.14.1). Add subscriptions to PDP via an Online Store 2.0-compatible theme app block (5.14.2). Follow subscriptions UX guidelines — price/savings clearly shown on product/cart/order pages, auto-match theme styling (5.14.3). Use Customer Account UI extensions for merchants... customers to view/manage subscriptions (5.14.4). Use Customer Account API for auth (5.14.5). |

---

## Notes on auditing a mobile-app-adjacent architecture

Many BFS requirements (Sections 3 and 4, App Bridge, Polaris web components, theme app extensions, Contextual Save Bar) are written for the **embedded Shopify Admin web app** surface — typically a Remix/Node/Rails app rendered inside an iframe in the Shopify admin. If the project under audit is a **Flutter/native mobile app** that talks to Shopify APIs but is not itself the embedded admin surface:

- Sections 1, 2.2, 2.3, and 5 (category-specific API/data usage) still apply directly — they're about API usage, data sync, and storefront/checkout performance, not the specific UI framework.
- Section 2.1 (Web Vitals) and most of Sections 3 and 4 assume there IS an embedded admin web app. If the merchant-facing companion is a separate embedded web app (even a thin one), audit that surface against 2.1/3/4. If there's no embedded admin surface at all, flag those requirements as **N/A — no embedded admin surface to evaluate** rather than fail, and note this is worth confirming with Shopify's BFS program directly since a pure external/mobile app model may itself be a gap against 3.1.1–3.1.2.
