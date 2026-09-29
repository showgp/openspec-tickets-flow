#!/usr/bin/env bash
# Install the OpenSpec + Matt-skills workflow into the current project.
# Usage: run from the target project root:
#   bash <(curl -fsSL https://raw.githubusercontent.com/showgp/openspec-tickets-flow/master/install.sh)
# or run a local checkout's install.sh the same way.
set -euo pipefail

say()  { printf '\n== %s ==\n' "$1"; }
fail() { printf 'ERROR: %s\n' "$1" >&2; exit 1; }

have() { command -v "$1" >/dev/null 2>&1; }

SKILLS_CLI=(npx skills@latest)
SKILLS_PKG="showgp/openspec-tickets-flow"

# ---------------------------------------------------------------- checks
say "Checking prerequisites"

have npx || fail "npx not found. Install Node.js 20.19+ first: https://nodejs.org"
if ! have openspec; then
  echo "openspec CLI not found."
  echo "Install it with:  npm install -g @fission-ai/openspec@latest"
  echo "or:               brew install openspec"
  fail "openspec CLI required"
fi
echo "openspec: $(openspec --version)"

if [ ! -f openspec/config.yaml ]; then
  fail "'openspec/config.yaml' not found here. Run 'openspec init' in the target repo first."
fi
echo "openspec/config.yaml found."

# ------------------------------------------------- upstream skills (as-is)
say "Installing upstream Matt skills (grilling, tdd, to-tickets)"

for skill in grilling tdd to-tickets; do
  if [ -f ".agents/skills/${skill}/SKILL.md" ] || [ -f ".claude/skills/${skill}/SKILL.md" ]; then
    echo "already installed: ${skill}"
  else
    "${SKILLS_CLI[@]}" add mattpocock/skills -s "${skill}" -y
  fi
done

# ------------------------------------------------ custom skills (this pkg)
say "Installing openspec-tickets-flow skills"

for skill in setup-openspec-tickets tasks-to-tickets implement-openspec-ticket review-openspec-ticket; do
  "${SKILLS_CLI[@]}" add "${SKILLS_PKG}" -s "${skill}" -y
done

# ------------------------------------------------------------------ finish
say "Done"

echo "Installed skills:"
"${SKILLS_CLI[@]}" ls 2>/dev/null | grep -E 'setup-openspec-tickets|tasks-to-tickets|implement-openspec-ticket|review-openspec-ticket' || true

cat <<'NEXT'

Next steps:
  1. Run the `setup-openspec-tickets` skill once in this repo (via your agent):
       "Use setup-openspec-tickets to configure this repo for the OpenSpec ticket flow."
     It verifies openspec init state, and writes the config-rules + AGENTS.md section.
  2. Start a change: discuss with grilling first, then create one OpenSpec change,
     approve proposal → spec → design → tasks one at a time.
  3. Publish tickets with tasks-to-tickets, one per review cycle.
NEXT
