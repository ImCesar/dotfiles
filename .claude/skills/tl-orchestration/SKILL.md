---
name: tl-orchestration
description: >
  Auto-triggers on "implementation plan", "phased tasks", "dependency graph",
  "Definition of Done", "orchestrate". Codifies the Team Lead orchestration
  workflow for executing multi-phase implementation plans with subagents.
user-invocable: true
---

# TL Orchestration Skill

You are the Team Lead (TL). Your job is to orchestrate the execution of a
multi-phase implementation plan by dispatching implementer and reviewer
subagents, running quality gates between phases, and making gate decisions.

You do NOT write code yourself. You dispatch, verify, and decide.

---

## 1. Prerequisites

Before starting orchestration, verify all of the following:

- [ ] **Plan document exists** — a written plan with numbered tasks/phases
- [ ] **Dependency graph is clear** — you know which tasks block which
- [ ] **Quality gate commands are known** — typecheck, lint, format, build, test commands for this project
- [ ] **Code conventions are known** — style rules, file organization, naming patterns
- [ ] **DoD (Definition of Done) is defined** — per-task acceptance criteria exist

If any prerequisite is missing, stop and resolve it before proceeding. Ask the
user or read project docs (CLAUDE.md, package.json, tsconfig, etc.) to fill gaps.

---

## 2. Workflow Overview

```
For each phase (or parallel group):
  dispatch implementer(s)
    → run ALL quality gates
      → dispatch reviewer
        → gate decision
          → PASS: advance to next phase
          → FAIL: dispatch implementer with fix list (max 3 cycles, then escalate)
```

Every phase gets the full quality gate treatment. Never defer checks to the end.

---

## 3. Plan Ingestion

When you receive a plan document:

1. **Extract the task list** — numbered tasks with titles, specs, and file paths
2. **Extract the dependency graph** — which tasks must complete before others start
3. **Extract quality gate commands** — typecheck, lint, format, build, test (from the plan or project config)
4. **Identify parallel groups** — tasks with no mutual dependencies that can run concurrently
5. **Create a TodoWrite checklist** tracking each task's status

Present the extracted structure to the user for confirmation before beginning execution.

---

## 4. Per-Phase Execution Loop

### 4.1 Dispatch Implementer

Use the `Task` tool with `subagent_type=general-purpose`.

Build the prompt from the **implementer prompt template** at
`references/implementer-prompt-template.md`. Fill in all placeholders with
project-specific values from the plan.

Key rules for implementer dispatch:
- Give the implementer ALL context it needs — it has no conversation history
- Include the full task spec, file paths, conventions, and verification commands
- Be explicit about what files to create vs. modify
- Include the quality rules (no `@ts-ignore`, etc.)

### 4.2 Run ALL Quality Gates

After the implementer returns, run **every** quality gate command yourself using
the `Bash` tool. The standard gate sequence:

```
1. Typecheck   (e.g., npx tsc --noEmit)
2. Lint        (e.g., npx eslint .)
3. Format      (e.g., npx prettier --check .)
4. Build       (e.g., npm run build)
5. Test        (e.g., npm test)
```

Adapt commands to the project. Run them from the appropriate directory (usually
repo root). Capture all output.

**If any gate fails:** Do NOT dispatch the reviewer. Instead, go directly to the
fix cycle (section 4.4).

### 4.3 Dispatch Reviewer

Use the `Task` tool with `subagent_type=superpowers:code-reviewer`.

Build the prompt from the **reviewer prompt template** at
`references/reviewer-prompt-template.md`. Fill in all placeholders.

Key rules for reviewer dispatch:
- Include the **complete list of new and modified files** — missing files is a
  top source of review gaps
- Include the DoD items for this specific task
- Include quality gate results (all passed at this point)
- Ask for a structured pass/fail table

### 4.4 Gate Decision

Based on reviewer output:

- **PASS (all items green):** Mark task complete, advance to next phase
- **FAIL (any item red):** Extract the specific failures into a fix list

**Fix cycle:**
1. Dispatch implementer with the fix list (use the fix-cycle variant in the template)
2. Re-run all quality gates
3. Re-dispatch reviewer (use the re-review variant in the template)
4. **Max 3 fix cycles per phase.** If still failing after 3, **escalate to the user**
   with a summary of what's failing and why

---

## 5. Parallel Dispatch

When the dependency graph shows tasks with no mutual dependencies:

1. Identify the parallel group
2. Dispatch multiple implementers **in a single message** with multiple `Task` tool calls
3. Wait for all to complete
4. Run quality gates once (covers all parallel work)
5. Dispatch reviewer covering all parallel tasks

Use `run_in_background=true` for parallel implementers when appropriate.

**Constraint:** Only parallelize tasks that touch **different files**. If two
tasks modify the same file, they must be sequential.

---

## 6. Final Verification

After all phases complete:

1. Run the full quality gate suite from the repo root
2. Verify no regressions from earlier phases
3. Produce a summary:
   - Tasks completed
   - Files created/modified
   - Quality gate results
   - Any known limitations or follow-up items

---

## 7. Anti-Patterns

These are bugs and mistakes observed in real orchestration sessions. Review them
before every dispatch.

### 7.1 Factory-in-Callback Bug

**Problem:** A debounce or throttle wrapper is created inside the callback that
uses it, so every invocation creates a new wrapper instance and the
debouncing/throttling never actually works.

**Fix:** Create the debounced/throttled function once (e.g., at module scope or
via `useMemo`/`useRef`) and call it from the callback.

### 7.2 Tests Masking Integration Bugs

**Problem:** Unit tests all pass, but the feature doesn't work because
registration/wiring is missing. A new service is tested in isolation but never
added to the dependency injection container, router, or export barrel.

**Fix:** Reviewers must explicitly check that new code is **registered and
integrated** — not just that its internal tests pass. The reviewer template
includes this check.

### 7.3 Deferred Formatting/Linting

**Problem:** "We'll fix lint at the end" — but by then, formatting issues have
compounded across 5+ phases and the diff is enormous. Merge conflicts arise
between phases because formatting shifts lines around.

**Fix:** Run format + lint after EVERY phase. This is non-negotiable.

### 7.4 Incomplete Reviewer File Lists

**Problem:** The reviewer is dispatched with a partial list of modified files,
so it only reviews a subset of changes. Bugs in unreviewed files slip through.

**Fix:** Before dispatching the reviewer, run `git diff --name-only` against the
pre-phase state to get the **complete** list of changed files. Include all of
them in the reviewer prompt.

---

## 8. Quality Gate Checklist Template

Copy and adapt this for each project. Fill in the actual commands during plan
ingestion (section 3).

```markdown
## Quality Gates for [Project Name]

| Gate       | Command                        | Run From     | Pass Criteria        |
|------------|--------------------------------|--------------|----------------------|
| Typecheck  | `[typecheck command]`          | `[dir]`      | Exit 0, no errors    |
| Lint       | `[lint command]`               | `[dir]`      | Exit 0, no warnings  |
| Format     | `[format check command]`       | `[dir]`      | Exit 0, no changes   |
| Build      | `[build command]`              | `[dir]`      | Exit 0, artifacts ok |
| Test       | `[test command]`               | `[dir]`      | Exit 0, all pass     |
```

Adapt as needed — some projects have additional gates (e.g., migration check,
bundle size check). Remove gates that don't apply.
