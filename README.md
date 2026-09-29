# openspec-tickets-flow

Add-on skills for a spec-driven workflow combining OpenSpec and Matt Pocock's
`grilling`, `tdd`, and `to-tickets`. OpenSpec owns the change artifacts and
generated commands; this package adds four skills for repo setup, local ticket
handoff, implementation, and independent review. It does not modify upstream
skills.

## What it installs

| Skill | Purpose |
| --- | --- |
| `setup-openspec-tickets` | One-time per-repo setup: inspect CLI, upstream skills and existing policies; propose config rules and agent instructions, writing only approved changes |
| `tasks-to-tickets` | Plan complete change coverage, then publish one local ticket per review cycle under `<changeRoot>/tickets/` |
| `implement-openspec-ticket` | Implement one approved ticket with scoped TDD, real checks and a CLI smoke; obtain independent review, reconcile tasks, then stop |
| `review-openspec-ticket` | Read-only two-axis review (Standards + Spec) with a YAGNI traced-to-requirement gate |

## Prerequisites

- Install Node.js 20.19.0+ and the OpenSpec CLI (`npm i -g @fission-ai/openspec@latest` or `brew install openspec`).
- Initialize the target repo with `openspec init` before using `install.sh`; OpenSpec owns its generated tool commands and skills.
- Run the installer from that repo's root with `npx` available. It installs Matt Pocock's `grilling`, `tdd`, and `to-tickets` skills from upstream (unless already present), then the four skills in this package.

## Install

From the target project root, in order:

```bash
# 1. Install the OpenSpec CLI (assumes Node.js 20.19+, https://nodejs.org)
npm i -g @fission-ai/openspec@latest     # or: brew install openspec

# 2. Initialize OpenSpec in the target project (skip if openspec/config.yaml already exists)
openspec init

# 3. Install upstream skills and this package's skills
bash <(curl -fsSL https://raw.githubusercontent.com/showgp/openspec-tickets-flow/master/install.sh)
```

If the target project already has `openspec/config.yaml` and the CLI is installed, step 3 alone is enough. After installation, ask your agent to run `setup-openspec-tickets`; review its proposed config and agent-instruction changes before it writes anything.

Or manually, inside the target repo:

```bash
# 1. Check the CLI; initialize only if openspec/config.yaml does not exist
openspec --version
test -f openspec/config.yaml || openspec init

# 2. Install upstream skills (pick the three the flow needs)
npx skills@latest add mattpocock/skills -s grilling -y
npx skills@latest add mattpocock/skills -s tdd -y
npx skills@latest add mattpocock/skills -s to-tickets -y

# 3. Install this package's skills
npx skills@latest add showgp/openspec-tickets-flow -s setup-openspec-tickets -y
npx skills@latest add showgp/openspec-tickets-flow -s tasks-to-tickets -y
npx skills@latest add showgp/openspec-tickets-flow -s implement-openspec-ticket -y
npx skills@latest add showgp/openspec-tickets-flow -s review-openspec-ticket -y
```

Both methods fetch this package from `showgp/openspec-tickets-flow`; no local checkout is required. Run the setup skill once after either method.

## Workflow (per change)

```text
grilling → approved proposal → approved spec → approved design → approved tasks
  → tasks-to-tickets (plan full coverage; publish one ticket)
  → approve ticket → implement-openspec-ticket (scoped TDD → checks → CLI smoke → independent review)
  → human scope decisions → task reconciliation → stop for review
  → approve publishing the next ticket → repeat until all tasks and spec requirements are covered
  → sync durable specs → archive  (each separately approved)
```

Key rules carried over from the exercise:

- OpenSpec is the sole source of behavioral requirements; tickets and tests are
  evidence, not authority. Red tests and review findings cannot promote new
  edge-case guarantees into a spec by themselves.
- `tasks.md` puts each checkbox, full description, and verification criterion
  on **one physical line**; `openspec instructions apply --json` exposes only
  that line as the task description.
- Reporting progress is not permission to continue. Future tickets may remain
  unpublished during implementation; do not check a task until all of its
  contributions, including planned future slices, are done and verified.

## Scope boundaries

This package does **not** include:

- OpenSpec itself or its generated tool commands and skills (owned by `openspec init` / `openspec update`)
- Project-specific quality rules; each target project owns those in its own agent instructions
- Retrospective material from the source project
