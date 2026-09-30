# Engineering Principles

Use these principles alongside a project's own requirements, tooling, and review rules. They do not prescribe a change-approval workflow.

## Scope and design

- Make each new behavior, defensive measure, abstraction, and permanent test answer a real requirement or an explicit quality rule. A hypothetical edge case alone does not justify extra code; weigh its credible trigger, impact, simpler alternatives, and cost before adding handling.
- Separate responsibilities where they actually differ. Keep interfaces small and private by default. Avoid traits, forwarding layers, or architectural templates for a single concrete implementation.
- Extract repeated logic when it represents the same rule, not just to move lines between files. Do not fragment code merely to satisfy a size limit.
- Represent expected input, parsing, filesystem, locking, and persistence failures explicitly. Report failures instead of treating corrupt data as empty or claiming success.
- Claim platform support only where the behavior has been verified in that platform's environment. Reassess path-security assumptions when untrusted users can modify the working directory.

## Tests and evidence

- Give unit, real-filesystem integration, and real-CLI end-to-end tests distinct responsibilities: domain rules, persistence and concurrency, and user-visible commands respectively. Use the layers that match the system under test; do not duplicate one scenario across them.
- Keep a permanent test when it catches a distinct, user-relevant regression at its chosen seam. Assert contract-level outcomes; use implementation-specific observations only when needed to establish an invariant. Avoid mock echoes, private implementation assertions, and test-only reimplementations.
- Make concurrency tests create genuine overlap. Sequential invocations do not establish correct locking.
- Exercise changed behavior in the running program as well as running focused checks. Report exactly which checks ran and what happened; never present unrun checks as passing.

## Dependencies and documentation

- Explain added or upgraded dependencies and review changes to dependency manifests and lockfiles. Use reproducible dependency resolution for established checks.
- Keep proposed behavior, user-facing setup instructions, and command help in the documents or interfaces that own them. Avoid copying feature requirements or tool configuration into agent instructions where those copies can become stale.
