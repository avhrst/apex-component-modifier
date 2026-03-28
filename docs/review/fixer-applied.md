# Fixer Applied — 15 Known Fixes

**Applied by:** main session (agents blocked by permissions)
**Date:** 2026-03-28
**Source:** `docs/review/skill-reviewer-findings.md`

## P0 — Code Won't Work (5 fixes)

| # | File | Fix | Status |
|---|------|-----|--------|
| 1 | `templates/data_operations.md` | `:cnt` bind var → `v_cnt` local var, added DECLARE block + SET SERVEROUTPUT ON note | APPLIED |
| 2 | `templates/apex_management.md` | `workspace` → `workspace_name`, added `workspace_display_name`, removed `schemas` | APPLIED |
| 3 | `references/mcp_tools.md` | DBTOOLS$MCP_LOG columns: timestamp,tool_name,... → id,mcp_client,model,... | APPLIED |
| 4 | `templates/monitoring.md` | Same DBTOOLS$MCP_LOG column fix | APPLIED |
| 5 | `references/schema_commands.md` | CODESCAN syntax: `SET CODESCAN DIR` → `CODESCAN -path`, added JSON output example | APPLIED |

## P1 — Wrong Routing/Command (3 fixes)

| # | File | Fix | Status |
|---|------|-----|--------|
| 6 | `SKILL.md` line 182 | SHOW ERRORS: `run-sql` → `run-sqlcl` | APPLIED |
| 7 | `SKILL.md` line 184 | `liquibase releaselocks` → `liquibase release-locks` | APPLIED |
| 8 | `templates/schema_inspection.md` | FK query: swapped parent/child labels, added position join predicate | APPLIED |

## P2 — Consistency/Completeness (7 fixes)

| # | File | Fix | Status |
|---|------|-----|--------|
| 9 | `SKILL.md` line 136 | Rollback param order: `-changelog` before `-count` | APPLIED |
| 10 | `references/README.md` | Added 5 missing decision tree branches (OERR, CODESCAN, REST, SQLFORMAT, monitoring) | APPLIED |
| 11 | `templates/monitoring.md` | Added DBA privilege note to tablespace query | APPLIED |
| 12 | `SKILL.md` line 46 | Added `db_name` alias to connection verify query | APPLIED |
| 13 | `references/apex_commands.md` | `apex_workspace_log_summary` → `apex_workspace_activity_log`, `timestamp_tz` → `view_date` | APPLIED |
| 14 | `templates/monitoring.md` | Added privilege note to V$PARAMETER query | APPLIED |
| 15 | `templates/monitoring.md` | Changed `dba_objects` → `all_objects` in locks query (privilege compatibility) | APPLIED |
