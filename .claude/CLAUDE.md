# CLAUDE.md (User-Level)

## Workflow — MANDATORY 4-Phase Protocol

**CRITICAL: For ANY non-trivial task (multi-file changes, new features, bug fixes, refactors), you MUST follow all 4 phases in order. Do NOT skip phases. Do NOT write code before Phase 3.**

| Phase | What | Skill | Gate |
|-------|------|-------|------|
| 1. Gather Context | Understand the problem | `systematic-debugging` (bugs) or `brainstorming` (features) | Interactive — user answers questions |
| 2. Plan | Write implementation plan | `writing-plans` | Blocks until user approves (unless "auto") |
| 3. Implement | Execute the plan | `subagent-driven-development` | None |
| 4. Review | Validate the work | `review-hats:review` | None — present findings to user |

**"Auto" mode:** If the user says "auto", "just go", or similar — skip gates on phases 2-4 and run straight through all phases without stopping.

**Trivial tasks** (typo fixes, single-line changes, research questions) are exempt.

### Red Flags — If You Think This, STOP

| Thought | What to do instead |
|---------|--------------------|
| "This is simple, I'll just write the code" | If it touches >1 file, it's not simple. Start Phase 1. |
| "I already understand the problem" | You haven't asked the user. Start Phase 1. |
| "Let me just explore the codebase first" | That IS Phase 1. Invoke the skill. |
| "I'll plan in my head and implement" | Plans go in documents. Start Phase 2. |
| "The plan is obvious, I'll skip to code" | Write it down anyway. Phase 2. |
| "I'll review my own work as I go" | Self-review is not review. Phase 4 uses review-hats. |
| "The user seems to want this fast" | Fast ≠ skip phases. Phases prevent rework. |

### Phase Verification

Before writing ANY implementation code, confirm:
1. Context gathered via skill (Phase 1 complete)
2. Plan document exists and is approved (Phase 2 complete)
3. Executing via subagent-driven-development (Phase 3)

After implementation, confirm:
4. review-hats:review ran on the completed work (Phase 4 complete)

## Git

- NEVER add `Co-Authored-By` lines to commit messages.

## Tools

- Use `gh` CLI for all GitHub operations (PRs, issues, releases, checks).
