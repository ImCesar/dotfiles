# Implementer Prompt Template

Use this template when dispatching an implementer subagent via the `Task` tool
with `subagent_type=general-purpose`. Replace all `{{placeholders}}` with
project-specific values.

---

## Standard Dispatch

```markdown
## Task: {{TASK_ID}} — {{TASK_TITLE}}

You are implementing a task from a phased implementation plan.

### Spec

Read the task specification at: `{{SPEC_FILE_PATH}}`

{{#if SPEC_SUMMARY}}
Summary: {{SPEC_SUMMARY}}
{{/if}}

### Project Context

Repository root: `{{REPO_ROOT}}`

Relevant file tree:
```
{{FILE_TREE}}
```

### Key Details

{{TASK_DETAILS}}

### Reference Files for Conventions

Read these files to understand the project's patterns before writing code:
{{#each REFERENCE_FILES}}
- `{{this}}` — {{description}}
{{/each}}

### Code Quality Rules

- Never use `@ts-ignore`, `@ts-expect-error`, `@ts-nocheck`, or `eslint-disable`
- Fix underlying type/lint issues instead of suppressing them
- Prefix unused but required parameters with `_`
- Follow existing patterns in reference files
{{#each ADDITIONAL_QUALITY_RULES}}
- {{this}}
{{/each}}

### Files to Create

{{#each FILES_TO_CREATE}}
- `{{this.path}}` — {{this.description}}
{{/each}}

### Files to Modify

{{#each FILES_TO_MODIFY}}
- `{{this.path}}` — {{this.description}}
{{/each}}

### Verification

After implementation, run these commands and fix any issues:

{{#each VERIFICATION_COMMANDS}}
```bash
{{this.command}}
# Expected: {{this.expected}}
```
{{/each}}

### Definition of Done

{{#each DOD_ITEMS}}
- [ ] {{this}}
{{/each}}

Do NOT skip any verification step. Fix all errors before finishing.
```

---

## Fix-Cycle Variant

Use this when re-dispatching an implementer to fix issues found by the reviewer
or quality gates.

```markdown
## Fix Task: {{TASK_ID}} — {{TASK_TITLE}} (Fix Cycle {{CYCLE_NUMBER}}/3)

You are fixing issues found during review of task {{TASK_ID}}.

### Issues to Fix

{{#each FIX_ITEMS}}
{{@index}}. **{{this.file}}** — {{this.issue}}
   {{#if this.suggestion}}Suggestion: {{this.suggestion}}{{/if}}
{{/each}}

### Context

Repository root: `{{REPO_ROOT}}`

Files you may need to read for context:
{{#each CONTEXT_FILES}}
- `{{this}}`
{{/each}}

### Code Quality Rules

- Never use `@ts-ignore`, `@ts-expect-error`, `@ts-nocheck`, or `eslint-disable`
- Fix underlying type/lint issues instead of suppressing them
- Prefix unused but required parameters with `_`
{{#each ADDITIONAL_QUALITY_RULES}}
- {{this}}
{{/each}}

### Verification

After fixing, run these commands and confirm all pass:

{{#each VERIFICATION_COMMANDS}}
```bash
{{this.command}}
# Expected: {{this.expected}}
```
{{/each}}

Fix ONLY the listed issues. Do not refactor unrelated code. Do not add features
beyond what is needed to resolve the issues.
```
