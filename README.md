# openspec-tickets-flow

Reusable add-on package for the **OpenSpec + Matt skills** spec-driven workflow,
extracted from a completed end-to-end exercise. It adds three bridge skills that
connect Matt Pocock's general methods to OpenSpec's change/ticket structure,
plus a one-time per-repo setup skill.

Upstream tools are installed as-is from their own sources; this package only
adds the custom layer.

## What it installs

| Skill | Purpose |
| --- | --- |
| `setup-openspec-tickets` | One-time per-repo setup: check the OpenSpec CLI and upstream skills, then propose config rules and a repository agent-instruction section for approval |
| `tasks-to-tickets` | Turn one approved OpenSpec change's tasks into reviewable local tickets under `<changeRoot>/tickets/`, one per review cycle |
| `implement-openspec-ticket` | Implement one approved ticket with scoped TDD, real checks, CLI smoke, then stop for review |
| `review-openspec-ticket` | Independent two-axis review (Standards + Spec) with a YAGNI traced-to-requirement gate |

## Prerequisites

- Install Node.js 20.19.0+ and the OpenSpec CLI (`npm i -g @fission-ai/openspec@latest` or `brew install openspec`).
- Run `openspec init` in the target repo before using `install.sh`; OpenSpec owns the generated tool commands and skills.
- The script installs Matt Pocock's `grilling`, `tdd`, and `to-tickets` skills from their upstream source, then the four skills in this package.

## Install

Run from the target project root:

```bash
/path/to/openspec-tickets-flow/install.sh
```

Or manually, inside the target repo:

```bash
# 1. Make sure openspec CLI is available and the repo is initialized
openspec --version && openspec init

# 2. Install upstream skills (pick the three the flow needs)
npx skills@latest add mattpocock/skills -s grilling -y
npx skills@latest add mattpocock/skills -s tdd -y
npx skills@latest add mattpocock/skills -s to-tickets -y

# 3. Install this package's skills
npx skills@latest add /path/to/openspec-tickets-flow -s setup-openspec-tickets -y
npx skills@latest add /path/to/openspec-tickets-flow -s tasks-to-tickets -y
npx skills@latest add /path/to/openspec-tickets-flow -s implement-openspec-ticket -y
npx skills@latest add /path/to/openspec-tickets-flow -s review-openspec-ticket -y
```

After publication, clone `showgp/openspec-tickets-flow` and run its `install.sh` from the target repo. To install individual skills without cloning, replace the local path above with `showgp/openspec-tickets-flow`; the installer itself needs a local checkout.

## Workflow (per change)

```text
grilling → approved proposal → approved spec → approved design → approved tasks
  → tasks-to-tickets (publish one ticket per review cycle)
  → implement-openspec-ticket (scoped TDD → checks → CLI smoke → review)
  → review-openspec-ticket (Standards + Spec axes, YAGNI gate)
  → human scope decisions → task reconciliation → next ticket
  → sync durable specs → archive  (each separately approved)
```

Key rules carried over from the exercise:

- OpenSpec is the sole source of behavioral requirements; tickets and tests are
  evidence, not authority. Red tests and review findings cannot promote new
  edge-case guarantees into a spec by themselves.
- `tasks.md` puts each checkbox, full description, and verification criterion
  on **one physical line**; `openspec instructions apply --json` exposes only
  that line as the task description.
- Reporting progress is not permission to continue. Stop after each ticket.

## Scope boundaries

This package does **not** include:

- OpenSpec itself or its generated tool commands and skills (owned by `openspec init` / `openspec update`)
- Project-specific quality rules; each target project owns those in its own agent instructions
- Retrospective material from the source project
