# CLAUDE.md (User-Level)

## Workflow

- **Planning and implementation are separate phases.** When asked to brainstorm or plan, do NOT write code. Use brainstorming and writing-plans skills to produce a design/plan document first.
- **Default to subagent-driven-development** for executing implementation plans. Fresh subagent per task with spec and code quality reviews.
- **Run review-hats:review after completing a feature** to catch quality issues before finishing the branch.
- **Verify which plan** before starting execution — confirm the correct plan file with the user.

## Tools

- Use `gh` CLI for all GitHub operations (PRs, issues, releases, checks).
