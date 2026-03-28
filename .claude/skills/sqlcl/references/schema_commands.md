# Schema Inspection Commands (run-sqlcl)

All commands in this file use the `run-sqlcl` MCP tool.

## INFO — Enhanced Describe

Shows table/view structure with PKs, stats, comments, and indexes.

```
INFO employees
```

Output includes: column names, types, nullable, default values, primary key, indexes, row count, last analyzed.

### INFO+ — Extended Info

Adds column statistics (instead of column comments shown in INFO).

```
INFO+ employees
```

**Note:** `INFO` shows column comments; `INFO+` replaces them with column-level statistics.

Also works with PL/SQL objects (procedures, functions) — shows a ready-to-use call template.

## DDL — Generate DDL

Generate CREATE statement for any database object using DBMS_METADATA.

```
DDL employees                     -- table
DDL v_active_employees            -- view
DDL pkg_employees                 -- package (spec + body)
DDL trg_emp_audit                 -- trigger
DDL idx_emp_dept                  -- index
DDL emp_seq                       -- sequence
DDL t_varchar2_tab                -- type
DDL employees SAVE emp.sql        -- save DDL to file (avoids SPOOL)
```

### DDL Options

```
SET DDL STORAGE OFF                -- exclude storage clauses
SET DDL TABLESPACE OFF             -- exclude tablespace
SET DDL SEGMENT_ATTRIBUTES OFF     -- exclude segment attrs (also disables STORAGE)
SET DDL CONSTRAINTS ON             -- include constraints (default ON)
SET DDL REF_CONSTRAINTS ON         -- include FK constraints (default ON)
SET DDL CONSTRAINTS_AS_ALTER ON    -- emit constraints as ALTER statements
SET DDL PRETTY ON                  -- formatted output
SET DDL SQLTERMINATOR ON           -- include ; or / terminators
SET DDL PARTITIONING ON            -- include partitioning clauses
SET DDL SPECIFICATION ON           -- include package spec
SET DDL BODY ON                    -- include package body
SET DDL RESET                      -- reset all options to defaults
```

### DDL for all objects of a type

```sql
-- Via run-sql: generate DDL for all tables
SELECT DBMS_METADATA.GET_DDL('TABLE', table_name) FROM user_tables;
```

## DESC — Classic Describe

Standard SQL*Plus DESCRIBE command:

```
DESC employees
DESC pkg_employees
```

## CTAS — Create Table As Select

Generate a `CREATE TABLE ... AS SELECT` statement for an existing table:

```
CTAS employees
```

Produces DDL that recreates the table structure with all data.

## OERR — Error Lookup

Look up Oracle error messages by code:

```
OERR ORA 01722         -- invalid number
OERR ORA 00001         -- unique constraint violation
OERR ORA 01403         -- no data found
OERR ORA 06550         -- PL/SQL compilation error
OERR PLS 00201         -- identifier must be declared
OERR PLS 00306         -- wrong number/types of arguments
OERR ORA 04091         -- mutating table
OERR ORA 01555         -- snapshot too old
OERR ORA 00054         -- resource busy
OERR ORA 12154         -- TNS could not resolve
```

## CODESCAN — Code Quality

Scan PL/SQL code for quality issues. Two modes:

### Interactive Mode (real-time feedback on compile)
```
SET CODESCAN ON                    -- enable all scan categories
SET CODESCAN OFF                   -- disable all
SET CODESCAN SQLINJECTION ON       -- enable only SQL injection checks
SET CODESCAN SQLPERFORMANCE ON     -- enable performance checks
SET CODESCAN SQLBESTPRACTICE ON    -- enable best practice checks
SHOW CODESCAN                      -- show current settings
```

### Directory Scan Mode (batch scan files)
```
CODESCAN -path /path/to/sql/files
CODESCAN -path /path/to/sql/files -format json -output scan_results.json
CODESCAN -path /path/to/sql/files -format text
CODESCAN -path /path/to/sql/files -ignore G-2180
```

### CODESCAN Parameters
| Parameter | Description |
|-----------|-------------|
| `-path` | Directory of SQL/PLS/PLB files to scan |
| `-format` | Output format: `json` or `text` |
| `-output` | Output file path |
| `-ignore` | Rule number to ignore |
| `-settings` | Custom settings file |

### Rule Prefixes
- `G-*` — Trivadis PL/SQL coding guidelines (e.g., G-2180: Never use quoted identifiers)
- `PSR-*` — Oracle-documented performance rules

## REST — ORDS Module Management

Export and inspect Oracle REST Data Services modules:

```
REST export                        -- export all module definitions
REST export <module_name>          -- export a specific module
REST export <module_prefix>        -- export by base path prefix
REST modules                       -- list available modules
REST privileges                    -- list existing privileges
REST schemas                       -- list REST-enabled schemas
```

**Note:** To enable a schema for REST, use PL/SQL via `run-sql`:
```sql
BEGIN
  ORDS.ENABLE_SCHEMA(p_enabled => TRUE, p_schema => 'MY_SCHEMA');
  COMMIT;
END;
```

## ALIAS — Saved Commands

Create reusable command aliases (parameterized):

```
ALIAS list                         -- show all aliases
ALIAS save my_aliases              -- save to file
ALIAS load my_aliases              -- load from file

-- Create alias with parameters
ALIAS tbl=SELECT table_name, num_rows FROM user_tables WHERE table_name LIKE UPPER(:name)||'%' ORDER BY 1;

-- Use alias
tbl emp
```

## SET — Key Configuration Options

```
SET SERVEROUTPUT ON               -- enable DBMS_OUTPUT
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200                   -- line width
SET PAGESIZE 50                    -- page size
SET TIMING ON                      -- show execution time
SET FEEDBACK ON                    -- show row counts
SET DEFINE OFF                     -- disable & substitution
SET ECHO ON                        -- echo commands
SET VERIFY OFF                     -- don't show substitution
```

## SHOW — Environment Info

```
SHOW ALL                           -- all settings
SHOW USER                          -- current user
SHOW CONNECTION                    -- current connection details
SHOW TNS                           -- TNS entries
SHOW ERRORS                        -- compilation errors
SHOW RECYCLEBIN                    -- dropped objects
SHOW SQLPATH                       -- script search paths
SHOW EDITION                       -- current edition
```

## Common Inspection Workflows

### Full table audit
```
INFO+ <table_name>
DDL <table_name>
```

### Find and fix invalid objects
```
-- Via run-sql:
SELECT object_name, object_type FROM user_objects WHERE status = 'INVALID';

-- Then compile via run-sql:
ALTER PACKAGE pkg_name COMPILE;
ALTER PACKAGE pkg_name COMPILE BODY;
ALTER VIEW v_name COMPILE;
ALTER TRIGGER trg_name COMPILE;
```

### Schema overview
```
-- Via run-sql:
SELECT object_type, COUNT(*) FROM user_objects GROUP BY object_type ORDER BY 2 DESC;
SELECT table_name, num_rows FROM user_tables ORDER BY num_rows DESC NULLS LAST;
```
