# Reviewer Prompt Template

Use this template when dispatching a reviewer subagent via the `Task` tool
with `subagent_type=superpowers:code-reviewer`. Replace all `{{placeholders}}`
with project-specific values.

---

## Standard Review

```markdown
## Review: {{TASK_ID}} — {{TASK_TITLE}}

You are reviewing the implementation of task {{TASK_ID}} from a phased
implementation plan.

### Spec

The task specification is at: `{{SPEC_FILE_PATH}}`

{{#if SPEC_SUMMARY}}
Summary: {{SPEC_SUMMARY}}
{{/if}}

### Files to Review

**New files:**
{{#each NEW_FILES}}
- `{{this}}`
{{/each}}

**Modified files:**
{{#each MODIFIED_FILES}}
- `{{this}}`
{{/each}}

IMPORTANT: Review ALL listed files. Do not skip any.

### Definition of Done

Verify each item and report pass/fail:

{{#each DOD_ITEMS}}
- [ ] {{this}}
{{/each}}

### Code Quality Checks

Verify each:
- [ ] No `@ts-ignore`, `@ts-expect-error`, `@ts-nocheck`, or `eslint-disable`
- [ ] No unused imports or variables
- [ ] Error handling is appropriate (not swallowed, not over-handled)
- [ ] Naming follows project conventions
- [ ] No hardcoded values that should be configurable
{{#each ADDITIONAL_QUALITY_CHECKS}}
- [ ] {{this}}
{{/each}}

### Registration & Integration Checks

CRITICAL — these catch the most common class of bugs:

- [ ] New modules/services are exported from their barrel files (index.ts)
- [ ] New routes are registered in the router
- [ ] New middleware is added to the middleware chain
- [ ] New types are exported from shared type packages
- [ ] New validation schemas are used at API boundaries
- [ ] New dependencies are listed in package.json
- [ ] New environment variables are documented
{{#each ADDITIONAL_INTEGRATION_CHECKS}}
- [ ] {{this}}
{{/each}}

### Quality Gate Results

All quality gates passed before this review:
{{#each GATE_RESULTS}}
- {{this.gate}}: {{this.result}}
{{/each}}

### Output Format

Produce a table:

| Check | Status | Notes |
|-------|--------|-------|
| DoD item 1 | PASS/FAIL | ... |
| DoD item 2 | PASS/FAIL | ... |
| ... | ... | ... |
| Code quality | PASS/FAIL | ... |
| Integration | PASS/FAIL | ... |

**Overall verdict: PASS / FAIL**

If FAIL, list each failure with:
1. File and line
2. What's wrong
3. Suggested fix
```

---

## Re-Review Variant

Use this when re-reviewing after a fix cycle.

```markdown
## Re-Review: {{TASK_ID}} — {{TASK_TITLE}} (Cycle {{CYCLE_NUMBER}}/3)

You are re-reviewing task {{TASK_ID}} after fix cycle {{CYCLE_NUMBER}}.

### Previous Failures

These issues were reported in the previous review:

{{#each PREVIOUS_FAILURES}}
{{@index}}. **{{this.file}}** — {{this.issue}}
{{/each}}

### Files Changed in Fix

{{#each FIX_CHANGED_FILES}}
- `{{this}}`
{{/each}}

### Review Scope

1. **Verify each previous failure is fixed** — check the specific file and line
2. **Check for regressions** — ensure fixes didn't break nearby code
3. **Re-run the full DoD checklist** — not just the failed items

### Definition of Done

{{#each DOD_ITEMS}}
- [ ] {{this}}
{{/each}}

### Registration & Integration Checks

{{#each INTEGRATION_CHECKS}}
- [ ] {{this}}
{{/each}}

### Output Format

Produce a table:

| Previous Issue | Fixed? | Notes |
|----------------|--------|-------|
| Issue 1 | YES/NO | ... |
| ... | ... | ... |

| DoD Item | Status | Notes |
|----------|--------|-------|
| ... | PASS/FAIL | ... |

**Overall verdict: PASS / FAIL**

If FAIL and this is cycle 3, recommend escalation with a summary of
persistent issues.
```
