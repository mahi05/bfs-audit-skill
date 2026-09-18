# bfs-audit-skill

An agent skill that audits a Shopify app against the **Built for Shopify (BFS)** requirements and produces a findings report you can act on — pass/fail/needs-verification for every requirement, with evidence and fixes.

[![skills.sh](https://skills.sh/b/mahi05/bfs-audit-skill)](https://skills.sh/mahi05/bfs-audit-skill)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

---

> **Not affiliated with Shopify.** This is an independent, unofficial tool. "Shopify" and "Built for Shopify" are trademarks of Shopify Inc. The requirements it checks are summarized from Shopify's public documentation and can change. Always confirm against the canonical source: <https://shopify.dev/docs/apps/launch/built-for-shopify/requirements>

---

## Why

Meeting the Built for Shopify bar is the difference between being a listed app and a *recommended* one — but the requirements are long, spread across five sections, and easy to fail on details a code review would catch (Asset API writes, draft orders for discounts, custom button colors, missing theme app extensions).

This skill reads the checklist, greps your codebase for the signals that matter, and hands back a report that separates **things that block eligibility** from **things you can't determine from code** (install counts, Web Vitals percentiles, live SLAs) so you know exactly what to fix and what to go measure.

## What it checks

| Area | Coverage |
|---|---|
| **1. Prerequisites** | App Store requirements, Partner standing, installs, reviews, rating |
| **2. Performance** | Admin Web Vitals (LCP/CLS/INP at p75), storefront Lighthouse regression, checkout rate performance |
| **3. Integration** | Embedding & App Bridge, primary workflows in-admin, seamless sign-up, simplified reporting, clean uninstall, Asset API misuse |
| **4. Design** | Familiar (Polaris, tokens, navigation, contextual save bar), helpful (errors, onboarding, empty states), user-friendly (no dark patterns, premium feature handling) |
| **5. Category-specific** | 14 app categories — ads, affiliate, analytics, carrier services, discounts, email marketing, forms, fulfillment, invoices/receipts, bundles, product reviews, returns/exchanges, SMS marketing, subscriptions |

It is honest about the limits of static analysis: anything requiring live metrics or a visual judgement call is marked **Needs Verification** with a note on what evidence would settle it, rather than being guessed at.

## Install

### Recommended — the skills CLI

Works across Claude Code, Cursor, Codex, Gemini/Antigravity, Copilot, Windsurf, Cline and others:

```bash
npx skills add mahi05/bfs-audit-skill@bfs-audit
```

The `@bfs-audit` selector is required: this repo is named `bfs-audit-skill`, while the skill itself is `bfs-audit` (a skill's `name` must match its parent directory, per the [Agent Skills spec](https://agentskills.io/specification)).

You can also point directly at the skill folder:

```bash
npx skills add https://github.com/mahi05/bfs-audit-skill/tree/main/bfs-audit
```

### Manual install

Clone to a temporary location, then link the **inner** `bfs-audit/` directory. Keep the link named `bfs-audit` — renaming it to match the repo will break the name/directory match:

```bash
git clone --depth 1 https://github.com/mahi05/bfs-audit-skill.git /tmp/bfs-audit-skill

# Claude Code (personal)
ln -s /tmp/bfs-audit-skill/bfs-audit ~/.claude/skills/bfs-audit

# Shared agent directory (Gemini CLI / Antigravity alias, and other tools)
mkdir -p ~/.agents/skills
ln -s /tmp/bfs-audit-skill/bfs-audit ~/.agents/skills/bfs-audit

# Antigravity IDE
ln -s /tmp/bfs-audit-skill/bfs-audit ~/.gemini/config/skills/bfs-audit
```

Or copy instead of linking (`cp -R /tmp/bfs-audit-skill/bfs-audit ~/.claude/skills/bfs-audit`).

**Project-scoped install** — check it into the repo you want audited:

```bash
mkdir -p .claude/skills   # Claude Code
mkdir -p .agents/skills   # Gemini/Antigravity (alias also shared by other tools)
cp -R /path/to/bfs-audit-skill/bfs-audit .claude/skills/
```

**Gemini CLI** can install straight from the repo:

```bash
gemini skills install https://github.com/mahi05/bfs-audit-skill.git --path bfs-audit --consent
```

### Verify the install

```bash
npx skills-ref validate ~/.claude/skills/bfs-audit
# → Valid skill: /Users/you/.claude/skills/bfs-audit
```

## Usage

Once installed, the skill triggers automatically when you mention BFS or ask for an app to be checked. Some prompts that work:

```text
Audit this app against the Built for Shopify requirements.

Is my app BFS-ready? Start with section 3 (integration).

We're applying for BFS next month — what's blocking us?

Check my PR #412 against BFS requirements.

Just check onboarding against 4.2.2.

Will this pass BFS review? We're a subscription app.
```

The skill also fires when you ask for your app's UX, performance, or admin integration to be checked against Shopify's quality bar **without** naming Built for Shopify.

### What you get

A `bfs-audit-report.md` file written to the root of the project being audited (or `audit-reports/bfs-audit-report.md`), plus a short chat summary of the headline findings. Nothing is written into the skill's own directory.

The report is organized by checklist section, with one line per requirement:

```markdown
- [ ] **3.2.2 — No Asset API misuse** — Fail (blocker) — `app/services/theme.server.ts:41`
      calls `assetUpdate` to write `sections/header.liquid`. **Fix:** remove the write
      path; render via a theme app extension.
```

…followed by a prioritized **Top fixes** list. See [`examples/bfs-audit-report-example.md`](./examples/bfs-audit-report-example.md) for a full sample.

### Good to know

- **Not everything is decidable from code.** Install counts, review ratings, Web Vitals percentiles, and fulfillment SLAs live in the Partner Dashboard — the skill marks these **Needs Verification** and tells you what to pull.
- **Section 5 is conditional.** Only your app's category sections are audited; if none apply, 5.x is skipped entirely.
- **Mobile/native apps** get different treatment: most of Sections 3 and 4 assume an iframe-embedded admin surface, so the skill flags them accordingly rather than failing you on requirements that may not apply.
- **Requirements change.** The bundled checklist is a snapshot with a "last verified" date in its header; the skill re-fetches Shopify's page when it suspects drift.

## Repository layout

```text
bfs-audit.skill                  # packaged bundle (also attached to each release)
bfs-audit/
├── SKILL.md                     # skill instructions + frontmatter
└── references/
    └── bfs-requirements.md      # the full requirements checklist
examples/
└── bfs-audit-report-example.md  # what the output looks like
```

## Contributing

Issues and PRs are welcome — especially when a requirement has changed on Shopify's side. If you spot drift, please include the link or quote from the current docs so it can be verified.

When editing the skill, keep the frontmatter valid:

```bash
npx skills-ref validate ./bfs-audit
```

And repackage the bundle so it doesn't fall behind the source:

```bash
zip -r bfs-audit.skill bfs-audit -x '*.DS_Store' -x '__MACOSX/*'
```

## License

[MIT](./LICENSE) © 2026 Mahesh Babariya.

The checklist in `references/bfs-requirements.md` summarizes requirements published by Shopify Inc. That summarized material is included with attribution, remains the property of Shopify Inc., and is **not** covered by the MIT grant. "Shopify" and "Built for Shopify" are trademarks of Shopify Inc. This project is not affiliated with, endorsed by, or sponsored by Shopify Inc. See [`NOTICE`](./NOTICE) for the full third-party attribution.