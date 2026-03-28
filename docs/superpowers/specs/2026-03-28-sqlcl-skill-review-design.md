# SQLcl Skill Review & Improvement — Design Spec

**Date:** 2026-03-28
**Scope:** 14 files in `.claude/skills/sqlcl/`
**Goal:** Correctness + completeness + quality improvements

## Background

A prior review session (2026-03-28) ran 3 agents to review the SQLcl skill. Only the `skill-reviewer` produced output — 15 issues across 7 files documented in `docs/review/skill-reviewer-findings.md`. The `core-reviewer` and `data-reviewer` agents failed at startup due to a custom model endpoint issue with team agents. No fixes were applied.

## Constraints

- **No team agents** — `TeamCreate` spawns separate CLI processes that override `ANTHROPIC_MODEL` with the standard model ID, which the OCI LiteLLM proxy doesn't recognize. Must use regular background agents (`run_in_background: true`) which inherit the parent's model.
- **14 files total** — manageable for 3 parallel agents with ~5-7 files each.
- **Agents edit files directly** — fixes applied in-place via Edit tool. Changes reviewable via `git diff`.

## Agent Design

### Agent 1: `fixer`

**Purpose:** Apply 15 known fixes from prior findings.

**Input:** `docs/review/skill-reviewer-findings.md`

**Files touched (up to 9):**
- `.claude/skills/sqlcl/SKILL.md`
- `.claude/skills/sqlcl/references/README.md`
- `.claude/skills/sqlcl/references/mcp_tools.md`
- `.claude/skills/sqlcl/references/schema_commands.md`
- `.claude/skills/sqlcl/references/apex_commands.md`
- `.claude/skills/sqlcl/templates/schema_inspection.md`
- `.claude/skills/sqlcl/templates/data_operations.md`
- `.claude/skills/sqlcl/templates/apex_management.md`
- `.claude/skills/sqlcl/templates/monitoring.md`

**Process:**
1. Read the findings file
2. For each finding (P0 first, then P1, then P2):
   a. Read the target file
   b. Locate the exact text from "Was" section
   c. Apply the fix from "Now" section via Edit tool
3. Write summary to `docs/review/fixer-applied.md`

**No web search or MCP testing needed** — all fixes are pre-specified.

### Agent 2: `reference-reviewer`

**Purpose:** Deep review + improve the 7 reference files.

**Files assigned:**
1. `references/mcp_tools.md` — MCP tools, connections, restriction levels
2. `references/sql_plsql.md` — SQL queries, DML, DDL, PL/SQL patterns
3. `references/schema_commands.md` — INFO, DDL, DESC, CTAS, OERR, CODESCAN, REST
4. `references/data_commands.md` — LOAD, SPOOL, BRIDGE, DATAPUMP, SODA, SQLFORMAT
5. `references/apex_commands.md` — APEX export/import, component selectors
6. `references/liquibase_commands.md` — Schema capture, diff, update, rollback
7. `references/project_commands.md` — PROJECT init/export/stage/release/deploy

**Process per file:**
1. Read the file thoroughly
2. Web search "Oracle SQLcl 25 <topic>" to verify syntax, parameters, options
3. **Correctness:** Fix any wrong syntax, parameters, tool routing, examples
4. **Completeness:** Add missing options, common use cases, edge cases
5. **Quality:** Consistent Markdown formatting, clear section headers, useful code comments
6. Write all findings + changes to `docs/review/reference-reviewer-findings.md`

**Verification method:** Oracle docs via web search. No live MCP testing.

### Agent 3: `template-reviewer`

**Purpose:** Deep review + improve SKILL.md, README.md, and 5 templates. Cross-check with references.

**Files assigned:**
1. `SKILL.md` — Main skill entry point (routing table, quick reference, error handling)
2. `references/README.md` — Decision tree and reference index
3. `templates/schema_inspection.md` — Schema audit workflow
4. `templates/data_operations.md` — Load/export/copy data workflow
5. `templates/apex_management.md` — APEX app management workflow
6. `templates/migration_workflow.md` — Schema comparison & migration workflow
7. `templates/monitoring.md` — Session & DB monitoring queries

**Process per file:**
1. Read the file + read relevant reference files for cross-checking
2. Web search Oracle docs to verify SQL queries, view names, column names
3. **Correctness:** Fix wrong SQL, wrong view/column references, wrong tool routing
4. **Completeness:** Add missing workflow steps, missing privilege notes, missing examples
5. **Quality:** Consistent formatting, clear step numbering, actionable instructions
6. **Cross-consistency:** Ensure templates match reference file syntax; ensure README decision tree matches SKILL.md routing table
7. Write findings to `docs/review/template-reviewer-findings.md`

**Verification method:** Oracle docs via web search + cross-reference with skill reference files.

## Execution Plan

1. Launch all 3 agents as regular background agents simultaneously
2. Fixer completes first (~2 min), reviewers take longer (~5-10 min each)
3. After all agents complete, consolidate results:
   - Review `git diff` for all changes
   - Read the 3 findings files
   - Present summary to user

## Output Artifacts

| File | Purpose |
|------|---------|
| `docs/review/fixer-applied.md` | Log of 15 known fixes applied |
| `docs/review/reference-reviewer-findings.md` | New issues found + fixes in reference files |
| `docs/review/template-reviewer-findings.md` | New issues found + fixes in templates/SKILL.md |

## Success Criteria

- All 15 known issues from prior findings are applied
- Reference files verified against Oracle SQLcl 25.x docs
- Templates verified for correct SQL syntax and view/column names
- Cross-consistency between SKILL.md routing table, README decision tree, and template content
- All files have consistent Markdown formatting
- Privilege requirements noted where applicable
