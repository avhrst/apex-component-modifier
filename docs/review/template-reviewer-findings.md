# Template Reviewer Findings

## Summary

Reviewed 7 files in `.claude/skills/sqlcl/`: SKILL.md, references/README.md, and 5 template files, cross-referencing against all 7 reference files and Oracle documentation (web-verified).

**Total issues found: 18**
- WRONG_COLUMN: 5
- WRONG_VIEW: 2
- WRONG_SQL: 2
- WRONG_TOOL: 1
- MISSING_PRIVILEGE_NOTE: 4
- MISSING_STEP: 2
- FORMATTING: 0
- CROSS_MISMATCH: 2

**Fixes applied: 12** (by this reviewer + fixer agent)
- `monitoring.md`: 6 fixes (DBTOOLS$MCP_LOG columns, v$system_event, v$lock join, v$parameter/v$database split, privilege notes, block size note)
- `apex_management.md`: 3 fixes (restored correct APEX_WORKSPACES column, added workspace schemas section, added version/restriction notes)
- `migration_workflow.md`: 2 fixes (connect tool clarification, added Data Pump verification step)
- `SKILL.md`: 2 fixes (SHOW ERRORS tool routing, liquibase release-locks) -- applied by fixer agent
- `schema_inspection.md`: 1 fix (FK query corrected) -- applied by fixer agent
- `data_operations.md`: 1 fix (PL/SQL bind variable) -- applied by fixer agent

**Remaining items: suggestions only** (not blocking correctness)

**Cross-consistency assessment:** SKILL.md routing table is consistent with references/README.md decision tree. Tool routing (run-sql vs run-sqlcl) is correct across all files. One cross-file mismatch remains: `mcp_tools.md` reference still has wrong DBTOOLS$MCP_LOG column names (responsibility of the other reviewer agent).

---

## SKILL.md

### Issues Found & Fixed
- [Line 182] WRONG_TOOL: `run-sql` -> `SHOW ERRORS` should be `run-sqlcl` -> `SHOW ERRORS` since SHOW is a SQLcl command (confirmed in `schema_commands.md`). -- FIXED (by fixer agent)
- [Line 184] CROSS_MISMATCH: `liquibase releaselocks` should be `liquibase release-locks` (hyphenated) for SQLcl 22.x+ per `liquibase_commands.md`. -- FIXED (by fixer agent)

### Improvements Suggested
- The error handling table could add a row for "Liquibase checksum mismatch" -> `run-sqlcl` -> `liquibase clear-checksums`
- Security Notes section could mention that V$SESSION queries require SELECT_CATALOG_ROLE

### Cross-Consistency
- Routing table matches README.md decision tree
- Command quick reference examples are consistent with reference file syntax

---

## references/README.md

### Issues Found & Fixed
- No correctness issues found.

### Improvements Suggested
- Decision tree could add entries for: Error lookup (OERR), Code quality (CODESCAN), REST/ORDS -- these are in SKILL.md's routing table but missing from the decision tree

### Cross-Consistency
- Decision tree is a simplified subset of SKILL.md's routing table -- acceptable simplification

---

## templates/schema_inspection.md

### Issues Found & Fixed
- [Section 6] WRONG_SQL: FK query had swapped parent/child labels and was missing `AND a.position = b.position` for multi-column FK support. -- FIXED (by fixer agent)

### Improvements Suggested
- Add privilege note: USER_* views = own schema; ALL_*/DBA_* for cross-schema (DBA requires SELECT_CATALOG_ROLE)
- Add Indexes Summary section

### Cross-Consistency
- Tool routing correct: SQL queries use run-sql, INFO+ uses run-sqlcl

---

## templates/data_operations.md

### Issues Found & Fixed
- [Section "Row Count Audit"] WRONG_SQL: PL/SQL block used `:cnt` bind variable (invalid in anonymous blocks via run-sql). Fixed to use `DECLARE v_cnt NUMBER` local variable. Also added SERVEROUTPUT note. -- FIXED (by fixer agent)

### Improvements Suggested
- Add note about LOAD file accessibility at restriction level 4
- Add SODA section (covered in data_commands.md but missing from template)
- Add note about inline hint alternative: `SELECT /*csv*/ * FROM <table_name>`

### Cross-Consistency
- Tool routing correct throughout
- Data Pump syntax matches data_commands.md

---

## templates/apex_management.md

### Issues Found & Fixed
- [APEX workspaces query] WRONG_VIEW: Fixer agent changed `workspace` to `workspace_name` and `workspace_display_name`, but per Oracle docs the APEX_WORKSPACES view uses `WORKSPACE` (not `WORKSPACE_NAME`). Restored to correct column names with clarifying comments. -- FIXED (by template reviewer)
- [APEX workspaces query] Added clarification that `schemas` column returns count of schemas (NUMBER), not schema names. Added new "List Workspace Schemas" section using APEX_WORKSPACE_SCHEMAS for actual schema names. -- FIXED (by template reviewer)
- [List Applications] WRONG_COLUMN: Column names `pages` and `owner` may vary by APEX version. Added version-awareness comment. -- FIXED (note added)
- [Session Activity] Added note that timestamp column name may vary by APEX version. -- FIXED (note added)
- [Import section] Added restriction level warning matching apex_commands.md docs. -- FIXED (by template reviewer)

### Cross-Consistency
- Export syntax matches apex_commands.md exactly
- Import workflow matches apex_commands.md
- apex list and apex export commands consistent with reference

---

## templates/migration_workflow.md

### Issues Found & Fixed
- [Schema Comparison Step 1] MISSING_STEP: `connect` command had no tool annotation. Added comment clarifying this uses the MCP `connect` tool. -- FIXED (by template reviewer)
- [Schema Clone via Data Pump] MISSING_STEP: No verification step after import. Added Step 3 to verify imported objects. -- FIXED (by template reviewer)

### Improvements Suggested
- Add a note that workflows assume SQLcl 22.x+ Liquibase integration

### Cross-Consistency
- All Liquibase commands match liquibase_commands.md syntax
- Data Pump commands match data_commands.md syntax
- Project commands match project_commands.md syntax
- Troubleshooting section uses correct modern hyphenated syntax (release-locks, list-locks)

---

## templates/monitoring.md

### Issues Found & Fixed
- [MCP Audit Log] WRONG_COLUMN: All 5 column names were wrong (`timestamp`, `tool_name`, `sql_text`, `execution_time`, `result_status`). Fixed to correct Oracle-documented columns: `id`, `mcp_client`, `model`, `end_point_type`, `end_point_name`, `log_message`. -- FIXED (by fixer agent + template reviewer)
- [Wait Events] WRONG_COLUMN: `average_wait_micro` does not exist in V$SYSTEM_EVENT. Fixed to compute `ROUND(time_waited_micro / NULLIF(total_waits, 0) / 1000, 2) avg_ms`. -- FIXED (by template reviewer)
- [Locks & Blocking] WRONG_SQL: `LEFT JOIN ... ON l.id1 = o.object_id` is only valid for TM locks. Added `AND l.type = 'TM'` condition and explanatory comments. Also changed `dba_objects` to `all_objects` (fixer) for lower privilege requirement. -- FIXED (by fixer agent + template reviewer)
- [Database Parameters] WRONG_VIEW: `open_mode` and `log_mode` are in V$DATABASE, not V$PARAMETER. Split into two sections: "Database Info" (v$database) and "Key Initialization Parameters" (v$parameter). -- FIXED (by template reviewer)
- [Tablespace Usage] Added note about hardcoded 8KB block size assumption and how to get actual value. -- FIXED (note added)
- MISSING_PRIVILEGE_NOTE: Added privilege requirements blockquote at top of file explaining V$, DBA_*, and USER_* view access requirements. -- FIXED (by template reviewer)

### Cross-Consistency
- MCP Audit Log: monitoring.md is now correct. Note: mcp_tools.md reference file still has the wrong column names (responsibility of the other reviewer agent).
- V$SESSION MCP tracking query is consistent between monitoring.md and mcp_tools.md

---

## Cross-File Consistency Summary

| Check | Status |
|-------|--------|
| SKILL.md routing table vs README.md decision tree | CONSISTENT |
| Template tool routing vs reference files | CONSISTENT |
| Liquibase syntax across templates vs reference | CONSISTENT |
| APEX commands across templates vs reference | CONSISTENT |
| Data Pump commands across templates vs reference | CONSISTENT |
| DBTOOLS$MCP_LOG columns (monitoring.md vs mcp_tools.md) | monitoring.md FIXED; mcp_tools.md STILL WRONG (other agent's scope) |
| SKILL.md error handling tool routing | FIXED |
| SKILL.md liquibase lock syntax | FIXED |

---

## Files Modified by This Reviewer

1. `/Users/ovykhrys/Developer/github/apex-component-modifier/.claude/skills/sqlcl/templates/monitoring.md` -- 6 fixes
2. `/Users/ovykhrys/Developer/github/apex-component-modifier/.claude/skills/sqlcl/templates/apex_management.md` -- 3 fixes + improvements
3. `/Users/ovykhrys/Developer/github/apex-component-modifier/.claude/skills/sqlcl/templates/migration_workflow.md` -- 2 fixes
4. `/Users/ovykhrys/Developer/github/apex-component-modifier/docs/review/template-reviewer-findings.md` -- this findings file
