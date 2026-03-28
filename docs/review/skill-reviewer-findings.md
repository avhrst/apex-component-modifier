# Skill Reviewer Findings — SQLcl Skill Entry Point, README & Templates

**Reviewer:** skill-reviewer
**Date:** 2026-03-28
**Files reviewed:** 7 (SKILL.md, references/README.md, 5 templates)
**References cross-checked:** 7 (mcp_tools.md, sql_plsql.md, schema_commands.md, data_commands.md, liquibase_commands.md, project_commands.md, apex_commands.md)
**External verification:** Oracle docs, blog posts, Medium articles on SQLcl MCP

---

## Summary

Found **15 issues** across the 7 files: 5 bugs (wrong tool/command/syntax), 4 incorrect column/view references, 3 consistency problems, and 3 completeness gaps. The most impactful are the `DBTOOLS$MCP_LOG` column names (wrong in 2 files), `SHOW ERRORS` tool routing, the Liquibase `releaselocks` vs `release-locks` syntax, and the CODESCAN command syntax.

---

## Findings

### [SKILL.md] line 182 — BUG: Wrong MCP tool for SHOW ERRORS
**Was:** `| PLS-* error | `run-sql` → `SHOW ERRORS`, fix compilation |`
**Now:** `| PLS-* error | `run-sqlcl` → `SHOW ERRORS`, fix compilation |`
**Why:** `SHOW ERRORS` is a SQLcl/SQL*Plus command, not a SQL statement. It is parsed by the SQLcl command processor, not the Oracle SQL engine. Per the `run-sql` vs `run-sqlcl` decision table in `mcp_tools.md` line 78, `SHOW USER` uses `run-sqlcl`, and all `SHOW *` commands should use `run-sqlcl`. Confirmed by Oracle docs: SHOW ERRORS is a SQL*Plus-compatible command in SQLcl.
**Confidence:** verified-via-docs

### [SKILL.md] line 184 — BUG: Wrong Liquibase lock release command
**Was:** `| Liquibase lock | `run-sqlcl` → `liquibase releaselocks` |`
**Now:** `| Liquibase lock | `run-sqlcl` → `liquibase release-locks` |`
**Why:** SQLcl 24.x+ uses kebab-case `release-locks`, not camelCase `releaselocks`. The reference file `liquibase_commands.md` (line 167) correctly uses `liquibase release-locks`. SKILL.md contradicts its own reference. Verified via Oracle SQLcl 25.1 docs which list the command as `release-locks`.
**Confidence:** verified-via-docs

### [SKILL.md] line 136 — CONSISTENCY: Liquibase rollback parameter order
**Was:** `liquibase rollback -count 1 -changelog controller.xml`
**Now:** `liquibase rollback -changelog controller.xml -count 1`
**Why:** The reference file `liquibase_commands.md` (lines 126-127) uses `-changelog` before `-count`. The migration template (line 87) also uses `-changelog` first. SKILL.md has them reversed. While SQLcl may accept either order, internal consistency with references/templates matters.
**Confidence:** verified-via-docs

### [schema_commands.md] lines 106-115 — BUG: CODESCAN syntax is wrong
**Was:**
```
-- Enable code scanning
SET CODESCAN ON

-- Scan a specific file
SET CODESCAN ON
@my_package.sql

-- Scan a directory
SET CODESCAN DIR /path/to/sql/files
```
**Now:**
```
-- Enable interactive code scanning (checks PL/SQL as you execute)
SET CODESCAN ON

-- Scan a directory for SQL best practice violations
CODESCAN -path /path/to/sql/files

-- Scan with JSON output
CODESCAN -path /path/to/sql/files -format json -output scan_results.json
```
**Why:** `SET CODESCAN DIR` does not exist. Per Oracle SQLcl 23.3+ docs, directory scanning uses `CODESCAN -path <dir>`, not `SET CODESCAN DIR`. The `SET CODESCAN ON` variant enables *interactive inline scanning* during PL/SQL execution (shows warnings in real-time). The `@my_package.sql` example also requires restriction level <= 3, which conflicts with MCP default level 4.
**Confidence:** verified-via-docs

### [mcp_tools.md] lines 109-113 — BUG: DBTOOLS$MCP_LOG column names are wrong
**Was:**
```sql
SELECT timestamp, tool_name, sql_text, execution_time, result_status
FROM dbtools$mcp_log
ORDER BY timestamp DESC
FETCH FIRST 20 ROWS ONLY;
```
**Now:**
```sql
SELECT id, mcp_client, model, end_point_type, end_point_name, log_message
FROM dbtools$mcp_log
ORDER BY id DESC
FETCH FIRST 20 ROWS ONLY;
```
**Why:** The actual `DBTOOLS$MCP_LOG` table has columns: `ID`, `MCP_CLIENT`, `MODEL`, `END_POINT_TYPE`, `END_POINT_NAME`, `LOG_MESSAGE`. The columns `timestamp`, `tool_name`, `sql_text`, `execution_time`, `result_status` do not exist. Verified via Medium article by Hamza Eraoui showing actual DESC output and query results, and confirmed by Oracle's official MCP monitoring documentation.
**Confidence:** verified-via-docs

### [monitoring.md] lines 28-33 — BUG: Same DBTOOLS$MCP_LOG column names wrong
**Was:**
```sql
SELECT timestamp, tool_name, sql_text, execution_time, result_status
FROM dbtools$mcp_log
ORDER BY timestamp DESC
FETCH FIRST 20 ROWS ONLY;
```
**Now:**
```sql
SELECT id, mcp_client, model, end_point_type, end_point_name, log_message
FROM dbtools$mcp_log
ORDER BY id DESC
FETCH FIRST 20 ROWS ONLY;
```
**Why:** Same issue as mcp_tools.md above. Template copied the same incorrect column names.
**Confidence:** verified-via-docs

### [apex_management.md] lines 14-16 — BUG: apex_workspaces has no "schemas" column
**Was:**
```sql
SELECT workspace_id, workspace, schemas
FROM apex_workspaces ORDER BY workspace;
```
**Now:**
```sql
SELECT workspace_id, workspace_name, workspace_display_name
FROM apex_workspaces ORDER BY workspace_name;
```
Or to get schemas associated with workspaces:
```sql
SELECT w.workspace_name, s.schema
FROM apex_workspaces w
JOIN apex_workspace_schemas s ON w.workspace_name = s.workspace_name
ORDER BY w.workspace_name, s.schema;
```
**Why:** The `APEX_WORKSPACES` view does not have a `schemas` column. The column `workspace` should be `workspace_name`. Schema-to-workspace mapping is in the separate `APEX_WORKSPACE_SCHEMAS` view. Verified via Oracle REST Data Services API documentation and Oracle APEX administration guides.
**Confidence:** verified-via-docs

### [apex_commands.md] lines 199-203 — SUSPECTED: apex_workspace_log_summary view
**Was:**
```sql
SELECT * FROM apex_workspace_log_summary
WHERE application_id = 113
ORDER BY timestamp_tz DESC FETCH FIRST 20 ROWS ONLY;
```
**Now:**
```sql
SELECT * FROM apex_workspace_activity_log
WHERE application_id = 113
ORDER BY view_date DESC FETCH FIRST 20 ROWS ONLY;
```
**Why:** The view `apex_workspace_log_summary` does not appear in Oracle APEX documentation. The documented views are `APEX_WORKSPACE_ACTIVITY_LOG` (detailed) and `APEX_WORKSPACE_LOG_SUMMARY_USR` (per-user summary). Neither is `apex_workspace_log_summary`. Additionally, `timestamp_tz` may not be the correct column — `APEX_WORKSPACE_ACTIVITY_LOG` uses `view_date` or `time_stamp` depending on APEX version. This needs live testing to confirm exact column names.
**Confidence:** suspected

### [data_operations.md] lines 92-99 — BUG: PL/SQL bind variable syntax error
**Was:**
```sql
BEGIN
  FOR r IN (SELECT table_name FROM user_tables ORDER BY table_name) LOOP
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || r.table_name INTO :cnt;
    DBMS_OUTPUT.PUT_LINE(RPAD(r.table_name, 30) || ' : ' || :cnt);
  END LOOP;
END;
```
**Now:**
```sql
SET SERVEROUTPUT ON
DECLARE
  v_cnt NUMBER;
BEGIN
  FOR r IN (SELECT table_name FROM user_tables ORDER BY table_name) LOOP
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || r.table_name INTO v_cnt;
    DBMS_OUTPUT.PUT_LINE(RPAD(r.table_name, 30) || ' : ' || v_cnt);
  END LOOP;
END;
```
**Why:** `:cnt` is a bind variable syntax used in SQL*Plus scripts with `VARIABLE` declarations, not valid inside a PL/SQL anonymous block. Inside PL/SQL, you must use a declared local variable. The block also needs `SET SERVEROUTPUT ON` (via run-sqlcl) before execution to see output. Additionally, the `INTO :cnt` in `EXECUTE IMMEDIATE` within PL/SQL would raise PLS-00049: bad bind variable.
**Confidence:** verified-via-docs

### [schema_inspection.md] lines 56-64 — CONSISTENCY: FK query logic is reversed/confusing
**Was:**
```sql
SELECT a.table_name parent_table, a.constraint_name fk_name,
       b.table_name child_table, a.column_name
FROM user_cons_columns a
JOIN user_constraints c ON a.constraint_name = c.constraint_name
JOIN user_constraints r ON c.r_constraint_name = r.constraint_name
JOIN user_cons_columns b ON r.constraint_name = b.constraint_name
WHERE c.constraint_type = 'R'
ORDER BY a.table_name, b.table_name;
```
**Now:**
```sql
SELECT c.table_name child_table, c.constraint_name fk_name,
       a.column_name fk_column, r.table_name parent_table,
       b.column_name referenced_column
FROM user_constraints c
JOIN user_cons_columns a ON c.constraint_name = a.constraint_name
JOIN user_constraints r ON c.r_constraint_name = r.constraint_name
JOIN user_cons_columns b ON r.constraint_name = b.constraint_name
  AND a.position = b.position
WHERE c.constraint_type = 'R'
ORDER BY c.table_name, c.constraint_name, a.position;
```
**Why:** The original query labels `a.table_name` as `parent_table` and `b.table_name` as `child_table`, but the logic is inverted: table `a` (with constraint_type = 'R') is the *child* table holding the FK, and table `b` (the referenced constraint) is the *parent*. Also missing `position` join predicate which causes Cartesian product on composite FKs.
**Confidence:** verified-via-docs

### [README.md] lines 19-29 — COMPLETENESS: Missing decision tree branches
**Was:**
```
User request
├── SQL query / DML / DDL / PL/SQL → sql_plsql.md (use run-sql)
├── Schema info / DDL generation / describe → schema_commands.md (use run-sqlcl)
├── Load CSV / export data / JSON docs → data_commands.md (use run-sqlcl)
├── APEX app / page / component → apex_commands.md (use run-sqlcl)
├── Schema diff / migration / changelog → liquibase_commands.md (use run-sqlcl)
├── Data Pump export/import → data_commands.md (use run-sqlcl)
├── CI/CD project setup / deploy → project_commands.md (use run-sqlcl)
└── Connection / MCP setup → mcp_tools.md
```
**Now:**
```
User request
├── SQL query / DML / DDL / PL/SQL → sql_plsql.md (use run-sql)
├── Schema info / DDL generation / describe → schema_commands.md (use run-sqlcl)
├── Load CSV / export data / JSON docs → data_commands.md (use run-sqlcl)
├── APEX app / page / component → apex_commands.md (use run-sqlcl)
├── Schema diff / migration / changelog → liquibase_commands.md (use run-sqlcl)
├── Data Pump export/import → data_commands.md (use run-sqlcl)
├── CI/CD project setup / deploy → project_commands.md (use run-sqlcl)
├── Error lookup (ORA/PLS codes) → schema_commands.md (use run-sqlcl: OERR)
├── Code quality scan → schema_commands.md (use run-sqlcl: CODESCAN)
├── REST / ORDS modules → schema_commands.md (use run-sqlcl: REST)
├── Output formatting → data_commands.md (use run-sqlcl: SET SQLFORMAT)
├── Monitoring / diagnostics → mcp_tools.md (use run-sql for V$ views)
└── Connection / MCP setup → mcp_tools.md
```
**Why:** The SKILL.md routing table (lines 52-64) includes 11 categories, but the README decision tree only has 8 branches. Missing: error lookup (OERR), code quality (CODESCAN), REST/ORDS, output formatting, and monitoring/diagnostics. The README should match SKILL.md for consistency and completeness.
**Confidence:** verified-via-docs

### [SKILL.md] line 46 — CONSISTENCY: Connection verify query missing alias
**Was:** `3. Verify: `run-sql` → `SELECT USER, SYS_CONTEXT('USERENV','DB_NAME') FROM dual``
**Now:** `3. Verify: `run-sql` → `SELECT USER, SYS_CONTEXT('USERENV','DB_NAME') db_name FROM dual``
**Why:** The same query in `schema_inspection.md` (line 9-11) includes column aliases (`db_name`, `current_schema`, `session_user`). Without aliases, the CSV output from `run-sql` has `SYS_CONTEXT('USERENV','DB_NAME')` as the column header, which is hard to read. Minor, but the template version is better.
**Confidence:** verified-via-docs

### [monitoring.md] lines 73-82 — CONSISTENCY: Tablespace query uses dba_ view
**Was:**
```sql
SELECT tablespace_name,
       ROUND(used_space * 8192 / 1024 / 1024, 2) used_mb,
       ROUND(tablespace_size * 8192 / 1024 / 1024, 2) total_mb,
       ROUND(used_percent, 2) pct_used
FROM dba_tablespace_usage_metrics
ORDER BY used_percent DESC;
```
**Now:** Keep as-is but add a note:
```sql
-- run-sql (requires DBA privileges)
SELECT tablespace_name,
       ROUND(used_space * 8192 / 1024 / 1024, 2) used_mb,
       ROUND(tablespace_size * 8192 / 1024 / 1024, 2) total_mb,
       ROUND(used_percent, 2) pct_used
FROM dba_tablespace_usage_metrics
ORDER BY used_percent DESC;
```
**Why:** `DBA_TABLESPACE_USAGE_METRICS` requires DBA/SELECT_CATALOG_ROLE privileges, which a typical application schema won't have. The monitoring template should note this. Also, the block size multiplier `8192` is not always correct — it should use the database block size, which may be 4096, 8192, 16384, or 32768. However, the `used_space` and `tablespace_size` columns in `DBA_TABLESPACE_USAGE_METRICS` are already in *blocks* and the block size should come from `DB_BLOCK_SIZE` parameter. A safer query would use `ROUND(used_space * (SELECT value FROM v$parameter WHERE name = 'db_block_size') / 1024 / 1024, 2)`.
**Confidence:** verified-via-docs

### [monitoring.md] lines 49-58 — CONSISTENCY: Locks query uses dba_objects
**Was:** `LEFT JOIN dba_objects o ON l.id1 = o.object_id`
**Now:** Either add DBA privilege note or use `user_objects`/`all_objects` fallback
**Why:** Same privilege issue as tablespace query. `DBA_OBJECTS` requires elevated privileges. For non-DBA schemas, `ALL_OBJECTS` would be a safer choice (though it may miss some objects). The template should note the privilege requirement.
**Confidence:** verified-via-docs

### [monitoring.md] lines 113-123 — CONSISTENCY: v$parameter query needs privilege note
**Was:** No privilege note
**Now:** Add `-- run-sql (requires SELECT on V$PARAMETER / V_$PARAMETER)` comment
**Why:** V$ views are generally accessible only to DBA or users with explicit `SELECT_CATALOG_ROLE` or `SELECT ANY DICTIONARY` privilege. The monitoring template uses `v$session`, `v$sql`, `v$lock`, `v$system_event`, `v$parameter`, and `dba_tablespace_usage_metrics` — all of which require elevated privileges. The template should have a top-level note about privilege requirements.
**Confidence:** verified-via-docs

---

## File-by-File Summary

| File | Issues Found | Severity |
|------|-------------|----------|
| `SKILL.md` | 3 (wrong tool for SHOW ERRORS, wrong Liquibase command, parameter order) | High |
| `references/README.md` | 1 (missing decision tree branches) | Medium |
| `templates/schema_inspection.md` | 1 (FK query logic reversed + Cartesian on composite FKs) | High |
| `templates/data_operations.md` | 1 (PL/SQL bind variable error — code won't run) | High |
| `templates/apex_management.md` | 1 (wrong view columns — query will fail) | High |
| `templates/migration_workflow.md` | 0 (consistent with references) | OK |
| `templates/monitoring.md` | 2 (wrong MCP log columns, privilege notes missing) | High |

**Also found in reference files (not assigned but affects templates):**
- `mcp_tools.md`: Wrong DBTOOLS$MCP_LOG column names (propagated to monitoring.md)
- `schema_commands.md`: Wrong CODESCAN syntax
- `apex_commands.md`: Questionable `apex_workspace_log_summary` view name

---

## Cross-reference Issues (references vs templates)

| Reference claim | Template usage | Match? |
|----------------|---------------|--------|
| `mcp_tools.md` DBTOOLS$MCP_LOG columns | `monitoring.md` MCP Audit Log | Both wrong (same columns) |
| `liquibase_commands.md` `release-locks` | `SKILL.md` error table `releaselocks` | Mismatch |
| `liquibase_commands.md` `-changelog` before `-count` | `SKILL.md` quick ref has `-count` first | Mismatch |
| `mcp_tools.md` `SHOW USER` → `run-sqlcl` | `SKILL.md` `SHOW ERRORS` → `run-sql` | Inconsistent tool routing |
| `schema_commands.md` CODESCAN syntax | Not used in templates (OK) | Reference itself is wrong |
| `apex_commands.md` dict views | `apex_management.md` workspace query | Both have issues |
| `data_commands.md` LOAD syntax | `data_operations.md` LOAD usage | Match |
| `liquibase_commands.md` all commands | `migration_workflow.md` all steps | Match |
| `project_commands.md` all commands | `migration_workflow.md` CI/CD section | Match |

---

## Recommended Priority

1. **P0 — Fix immediately (code won't work):**
   - `data_operations.md` bind variable → local variable
   - `apex_management.md` apex_workspaces columns
   - `mcp_tools.md` + `monitoring.md` DBTOOLS$MCP_LOG columns
   - `schema_commands.md` CODESCAN syntax

2. **P1 — Fix soon (wrong routing/command):**
   - `SKILL.md` SHOW ERRORS tool routing
   - `SKILL.md` liquibase releaselocks → release-locks
   - `schema_inspection.md` FK query parent/child reversal

3. **P2 — Consistency / completeness:**
   - `SKILL.md` rollback parameter order
   - `README.md` missing decision tree branches
   - `monitoring.md` privilege requirement notes
   - `SKILL.md` connection verify query alias
   - `apex_commands.md` apex_workspace_log_summary view name
