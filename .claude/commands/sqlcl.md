---
description: "Work with Oracle Database and APEX via SQLcl MCP — SQL, schema inspection, data ops, APEX, Liquibase, Data Pump, projects"
argument-hint: "<command or question>"
---

Execute SQLcl operations against Oracle Database via the SQLcl MCP server.

1. Connect using `$SQLCL_CONNECTION`.
2. Classify the request and load the appropriate reference from `.claude/skills/sqlcl/references/`:
   - SQL/PLSQL → `sql_plsql.md` (use `run-sql`)
   - Schema inspect (INFO/DDL/DESC) → `schema_commands.md` (use `run-sqlcl`)
   - Data (LOAD/SPOOL/BRIDGE/DATAPUMP/SODA) → `data_commands.md` (use `run-sqlcl`)
   - APEX → `apex_commands.md` (use `run-sqlcl`)
   - Liquibase → `liquibase_commands.md` (use `run-sqlcl`)
   - Projects → `project_commands.md` (use `run-sqlcl`)
   - MCP setup → `mcp_tools.md`
3. Load matching template from `.claude/skills/sqlcl/templates/` if applicable.
4. Execute the command(s) with the correct MCP tool (`run-sql` vs `run-sqlcl`).
5. Format and present results.

**Critical:** Use `run-sql` for SQL/PLSQL. Use `run-sqlcl` for SQLcl commands (INFO, DDL, APEX, LIQUIBASE, etc.).

Arguments: `$ARGUMENTS`
