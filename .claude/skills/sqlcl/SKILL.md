---
name: sqlcl
description: "Work with Oracle Database and APEX via SQLcl MCP. Run SQL/PLSQL, inspect schemas, manage data, export/import APEX apps, run Liquibase migrations, use Data Pump, manage projects, and more — all through the SQLcl MCP server."
argument-hint: "<command-or-question>"
disable-model-invocation: false
---

# Oracle SQLcl CLI Skill (via SQLcl MCP)

Interact with Oracle Database and APEX through the SQLcl MCP server. Covers all SQLcl capabilities: SQL/PLSQL execution, schema inspection, data operations, APEX management, Liquibase migrations, Data Pump, CI/CD projects, and diagnostics.

## Settings

Env vars in `.claude/settings.json` (override in `.claude/settings.local.json`):

| Var | Purpose | Example |
|-----|---------|---------|
| `SQLCL_CONNECTION` | Saved connection alias | `DEV` |
| `APEX_APP_ID` | Default APEX app ID | `113` |
| `APEX_WORKSPACE` | APEX workspace name | `DEV_WORKSPACE` |

## MCP Tools Available

SQLcl MCP exposes 5 tools. **Always use the correct tool:**

| Tool | Use For | Examples |
|------|---------|---------|
| `list-connections` | List saved DB connections | Discovery, connection verification |
| `connect` | Establish DB connection | `connect` with `connection_name` param |
| `disconnect` | Drop current connection | Cleanup, switch connections |
| `run-sql` | Standard SQL and PL/SQL | SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, DROP, anonymous blocks |
| `run-sqlcl` | SQLcl-specific commands | DDL, INFO, APEX, LIQUIBASE, LOAD, CTAS, DATAPUMP, CODESCAN, SODA, REST, PROJECT |

**Critical distinction:**
- `run-sql` → SQL statements and PL/SQL blocks (parsed by Oracle SQL engine)
- `run-sqlcl` → SQLcl proprietary commands (parsed by SQLcl command processor)

## Workflow

### 0) Connect

Always verify connection first:

1. `list-connections` — find available saved connections
2. `connect` with `connection_name` = `$SQLCL_CONNECTION` (or user-specified)
3. Verify: `run-sql` → `SELECT USER, SYS_CONTEXT('USERENV','DB_NAME') db_name FROM dual`

### 1) Understand the request

Classify into category:

| Category | Tool | Reference |
|----------|------|-----------|
| **Query/DML** | `run-sql` | `references/sql_plsql.md` |
| **Schema inspection** | `run-sqlcl` (INFO/DDL/DESC) | `references/schema_commands.md` |
| **Data load/export** | `run-sqlcl` (LOAD/SPOOL/BRIDGE) | `references/data_commands.md` |
| **APEX operations** | `run-sqlcl` (APEX *) | `references/apex_commands.md` |
| **Schema migration** | `run-sqlcl` (LIQUIBASE *) | `references/liquibase_commands.md` |
| **Data Pump** | `run-sqlcl` (DATAPUMP *) | `references/data_commands.md` |
| **CI/CD projects** | `run-sqlcl` (PROJECT *) | `references/project_commands.md` |
| **Error lookup** | `run-sqlcl` (OERR) | `references/schema_commands.md` |
| **Code quality** | `run-sqlcl` (CODESCAN) | `references/schema_commands.md` |
| **ORDS/REST** | `run-sqlcl` (REST *) | `references/schema_commands.md` |
| **JSON documents** | `run-sqlcl` (SODA *) | `references/data_commands.md` |

### 2) Load relevant references

Read the appropriate reference file(s) from `references/` before executing. This ensures correct syntax and parameters.

### 3) Execute

Use the classified tool with correct syntax. For multi-step operations, execute sequentially and validate each step.

### 4) Format and report results

- For queries: present results in markdown tables when small, note row counts for large sets
- For DDL/DML: confirm success, report rows affected
- For errors: look up with OERR, diagnose, suggest fix
- For APEX: confirm export/import paths, report component counts

## Command Quick Reference

### SQL / PL/SQL (`run-sql`)

```sql
-- Queries
SELECT * FROM employees WHERE department_id = 10;

-- DML
INSERT INTO employees (id, name) VALUES (1, 'John');
UPDATE employees SET salary = salary * 1.1 WHERE department_id = 10;
DELETE FROM employees WHERE id = 1;

-- DDL
CREATE TABLE app_config (key VARCHAR2(100) PRIMARY KEY, value VARCHAR2(4000));
ALTER TABLE employees ADD (email VARCHAR2(255));
CREATE OR REPLACE PACKAGE pkg_util AS ... END pkg_util;

-- PL/SQL anonymous block
BEGIN
  DBMS_OUTPUT.PUT_LINE('Hello');
  FOR r IN (SELECT table_name FROM user_tables) LOOP
    DBMS_OUTPUT.PUT_LINE(r.table_name);
  END LOOP;
END;
```

### Schema Inspection (`run-sqlcl`)

```
INFO employees              -- table structure, PKs, indexes, stats
INFO+ employees             -- above + FKs, comments, column details
DDL employees               -- full CREATE TABLE DDL via DBMS_METADATA
DDL HR.PKG_UTIL             -- package DDL
DESC employees              -- classic describe
CTAS employees              -- CREATE TABLE AS SELECT DDL
OERR ORA 01722              -- look up error ORA-01722
```

### APEX (`run-sqlcl`)

```
apex version                                        -- APEX version
apex list -applicationid 113                        -- list components
apex export -applicationid 113 -split               -- full split export
apex export -applicationid 113 -split -expComponents "PAGE:1 PAGE:2"  -- partial
```

### Liquibase (`run-sqlcl`)

```
liquibase generate-schema -split                    -- capture schema
liquibase diff -referenceUrl jdbc:oracle:...        -- compare schemas
liquibase update -changelog controller.xml          -- apply changes
liquibase status -changelog controller.xml          -- check pending
liquibase rollback -changelog controller.xml -count 1
```

### Data (`run-sqlcl`)

```
LOAD employees employees.csv                        -- load CSV
SET SQLFORMAT csv                                   -- output as CSV
SET SQLFORMAT json                                  -- output as JSON
DATAPUMP EXPORT -schemas HR -directory DATA_DIR     -- Data Pump export
DATAPUMP IMPORT -schemas HR -directory DATA_DIR     -- Data Pump import
```

### Projects (`run-sqlcl`)

```
project init -name myapp -schemas HR,APEX_APP       -- init project
project export                                      -- export DB objects
project stage                                       -- generate changelogs
project release                                     -- create release
project deploy -connection PROD                     -- deploy to target
```

### Output Formatting (`run-sqlcl`)

```
SET SQLFORMAT ansiconsole    -- pretty terminal table
SET SQLFORMAT csv            -- comma-separated
SET SQLFORMAT json           -- JSON
SET SQLFORMAT json-formatted -- pretty JSON
SET SQLFORMAT html           -- HTML table
SET SQLFORMAT xml            -- XML
SET SQLFORMAT insert         -- INSERT statements
SET SQLFORMAT loader         -- SQL*Loader format
SET SQLFORMAT delimited      -- pipe-delimited
SET SQLFORMAT default        -- reset
```

Or use inline hints: `SELECT /*csv*/ * FROM employees`

## Error Handling

| Problem | Action |
|---------|--------|
| Connection refused | `list-connections`, verify alias, retry |
| ORA-* error | `run-sqlcl` → `OERR ORA <number>`, diagnose, fix |
| PLS-* error | `run-sqlcl` → `SHOW ERRORS`, fix compilation |
| APEX export empty | Verify APP_ID, workspace, connection privileges |
| Liquibase lock | `run-sqlcl` → `liquibase release-locks` |
| Permission denied | Check user privileges: `SELECT * FROM session_privs` |
| Unknown command | Check `references/` for correct syntax |

## Security Notes

- Default restriction level is 4 (most restrictive) — no HOST, SPOOL, or script execution
- All operations logged to `DBTOOLS$MCP_LOG`
- Sessions marked in `V$SESSION` (MODULE = MCP client, PROGRAM = SQLcl-MCP)
- Never hardcode credentials — use saved connections in `~/.dbtools`
- Prefer least-privilege: read-only for inspection, DML only when needed

## Examples

```
/sqlcl show me all tables in the current schema
/sqlcl describe the EMPLOYEES table with indexes and constraints
/sqlcl export APEX app 113 page 5
/sqlcl generate DDL for package PKG_REPORTS
/sqlcl load data.csv into the STAGING table
/sqlcl compare DEV schema to STG schema
/sqlcl find all invalid objects and recompile them
/sqlcl what does ORA-01722 mean?
/sqlcl show APEX version and list all apps in workspace
/sqlcl create a liquibase changelog for the HR schema
/sqlcl run a code quality scan on the current schema
```
