# Changelog

All notable changes to this skill are documented here.
This format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] — 2026-09-18

### Added
- Initial public release of the `bfs-audit` skill.
- Full Built for Shopify requirements checklist (`references/bfs-requirements.md`),
  covering sections 1.1–1.2 (prerequisites), 2.1–2.3 (performance), 3.1–3.2
  (integration), 4.1–4.3 (design), and 5.1–5.14 (category-specific).
- Attribution and trademark disclaimer for the summarized Shopify material.
- `examples/bfs-audit-report-example.md` showing the report format.
- `publish.sh` helper for creating and pushing the GitHub repository.

### Notes
- Requirements are summarized from Shopify's public documentation and can change;
  `SKILL.md` instructs the agent to re-fetch the canonical page when the bundled
  checklist may be stale.
