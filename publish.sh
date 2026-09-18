#!/usr/bin/env bash
#
# Create and publish the bfs-audit-skill repository on GitHub.
#
# Usage:
#   OWNER=mahi05 ./publish.sh            # public (default)
#   OWNER=mahi05 VISIBILITY=private ./publish.sh
#
# Requires: git, gh (authenticated as $OWNER), run from the repo root.

set -euo pipefail

OWNER="${OWNER:?set OWNER, e.g. OWNER=mahi05}"
REPO="${REPO:-bfs-audit-skill}"
VISIBILITY="${VISIBILITY:-public}"
VERSION="${VERSION:-v1.0.0}"

if [ ! -f "./bfs-audit/SKILL.md" ]; then
  echo "error: run this from the repo root (bfs-audit/SKILL.md not found)" >&2
  exit 1
fi

if [ ! -f "./bfs-audit.skill" ]; then
  echo "error: ./bfs-audit.skill is missing — repackage it before publishing:" >&2
  echo "       zip -r bfs-audit.skill bfs-audit -x '*.DS_Store' -x '__MACOSX/*'" >&2
  exit 1
fi

echo "==> Creating $OWNER/$REPO ($VISIBILITY)"
gh repo create "$OWNER/$REPO" \
  --"$VISIBILITY" \
  --source=. \
  --remote=origin \
  --push \
  --description "Audit a Shopify app against Built for Shopify (BFS) requirements"

echo "==> Adding topics"
gh repo edit "$OWNER/$REPO" \
  --add-topic shopify,built-for-shopify,bfs,agent-skill,claude-skill,shopify-apps

echo "==> Tagging $VERSION"
git tag -a "$VERSION" -m "$VERSION"
git push origin "$VERSION"

echo "==> Creating release with the .skill asset"
gh release create "$VERSION" bfs-audit.skill \
  --title "$VERSION" \
  --notes "Initial release. See CHANGELOG.md."

echo
echo "Done: https://github.com/$OWNER/$REPO"
echo "Verify install: npx skills add $OWNER/$REPO@bfs-audit"
