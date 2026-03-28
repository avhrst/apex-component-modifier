# Data Commands Reference (run-sqlcl)

All commands in this file use the `run-sqlcl` MCP tool unless noted.

## LOAD — CSV Import

Load CSV/delimited files into a table.

```
LOAD TABLE employees employees.csv
LOAD TABLE employees /path/to/data.csv
```

### Load Modes
```
LOAD TABLE employees data.csv              -- load into existing table
LOAD TABLE employees data.csv NEW          -- create table AND load data
LOAD TABLE employees data.csv SHOW         -- preview DDL without executing
LOAD TABLE employees data.csv CREATE       -- create table only, no data load
```

### Configuration (SET before LOAD)
```
SET LOADFORMAT csv                         -- set input format
SET LOADFORMAT DELIMITER "|"               -- custom field delimiter
SET LOADFORMAT ENCLOSURES '"'              -- custom enclosure character
SET LOAD SCAN_ROWS 500                     -- rows to scan for DDL (max 5000)
SET LOAD DATE_FORMAT DD-MM-YYYY            -- date format for DATE columns
SET LOAD COLSIZE ROUND                     -- column sizing: ACTUAL | ROUND | MAX
SET LOAD CLEAN_NAMES TRANSFORM             -- auto-sanitize column names
SET LOAD ERRORS UNLIMITED                  -- don't abort on row errors
```

**Requirements:**
- CSV must have a header row matching column names
- If AUTOCOMMIT is set, commits every 10 batches
- Load terminates after 50 errors by default
- Scan caps at 5000 rows for DDL generation (wide values after that may cause ORA-12899)

## SET SQLFORMAT — Output Formatting

Control query output format. Use before running queries via `run-sql`.

| Format | Command | Use Case |
|--------|---------|----------|
| Default table | `SET SQLFORMAT default` | Standard display |
| Pretty terminal | `SET SQLFORMAT ansiconsole` | Readable terminal output |
| CSV | `SET SQLFORMAT csv` | Data export, spreadsheets |
| JSON | `SET SQLFORMAT json` | API responses |
| Pretty JSON | `SET SQLFORMAT json-formatted` | Readable JSON |
| HTML | `SET SQLFORMAT html` | Web display |
| XML | `SET SQLFORMAT xml` | XML integration |
| INSERT statements | `SET SQLFORMAT insert` | Data migration scripts |
| SQL*Loader | `SET SQLFORMAT loader` | SQL*Loader control files |
| Pipe-delimited | `SET SQLFORMAT delimited` | Generic delimited |
| Fixed width | `SET SQLFORMAT fixed` | Fixed-width files |
| Tab-separated | `SET SQLFORMAT text` | Text export with tab delimiters |

### Inline format hints

Skip SET command — embed format in the query (use via `run-sql`):

```sql
SELECT /*csv*/ * FROM employees;
SELECT /*json*/ * FROM employees WHERE department_id = 10;
SELECT /*insert*/ * FROM employees WHERE id = 100;
SELECT /*html*/ * FROM employees;
```

## SPOOL — Output to File

Redirect output to a file (requires restriction level ≤ 1):

```
SPOOL /tmp/output.csv
SELECT /*csv*/ * FROM employees;
SPOOL OFF
```

## BRIDGE — Cross-Database Data Movement

Move data between databases via JDBC without database links.

Syntax: `BRIDGE <targetTable> AS "<jdbcURL>"(<sqlQuery>);`

```
-- Create local table from remote Oracle query
BRIDGE remote_emps AS "jdbc:oracle:thin:user/pass@host:1521/service"(SELECT * FROM employees);

-- Insert into existing local table from remote
BRIDGE INSERT INTO local_emps AS "jdbc:oracle:thin:user/pass@host:1521/service"(SELECT * FROM employees);

-- Copy from another database (e.g., PostgreSQL)
BRIDGE pg_orders AS "jdbc:postgresql://host/db"(SELECT * FROM orders);
```

**Note:** Requires appropriate JDBC drivers on the classpath. Also supports LONG columns.

## DATAPUMP — Data Pump Export/Import

Wrapper over DBMS_DATAPUMP for schema and table-level operations. Can also use `dp` as shorthand.

### Export Schema
```
DATAPUMP EXPORT -schemas HR -directory DATA_PUMP_DIR -dumpfile hr_export.dmp -logfile hr_export.log
dp export -s HR -d DATA_PUMP_DIR -f hr_export.dmp -lf hr_export.log
```

### Export Tables
```
dp export -s HR -tables EMPLOYEES,DEPARTMENTS -d DATA_PUMP_DIR -f tables.dmp
```

### Import Schema
```
dp import -s HR -d DATA_PUMP_DIR -f hr_export.dmp -lf hr_import.log
```

### Import with Remap
```
dp import -s HR -d DATA_PUMP_DIR -f hr_export.dmp -remaptablespace USERS=DATA
```

### Common Parameters

| Long Form | Short | Description |
|-----------|-------|-------------|
| `-schemas` | `-s` | Schema(s) to export/import |
| `-tables` | | Specific table(s) (22.1+) |
| `-directory` | `-d` | Oracle directory object for dump/log files |
| `-dumpfile` | `-f` | Dump file name |
| `-logfile` | `-lf` | Log file name |
| `-jobname` | `-j` | Data Pump job name |
| `-noexec` | `-ne` | Preview only — show PL/SQL without executing |
| `-verbose` | | Additional diagnostic info |
| `-wait` | | Wait for completion, log to console |
| `-excludeexpr` | `-ex` | Exclude object types (e.g., `"IN ('GRANT','INDEX')"`) |
| `-excludelist` | `-el` | Exclude specific objects |
| `-remaptablespace` | `-rt` | Map source tablespace to target |
| `-encryptionpassword` | `-enp` | Encrypt/decrypt dump files |
| `-copycloud` | `-cc` | Copy dumpfile to/from Oracle Object Store |

### Defaults
- If no schema specified, exports the current schema
- If no directory specified, uses `DATA_PUMP_DIR`
- Job name defaults to `isql_<n>`; dump/log files default to `<jobname>.DMP/.LOG`

### Check Data Pump directory
```sql
-- Via run-sql
SELECT directory_name, directory_path FROM all_directories WHERE directory_name = 'DATA_PUMP_DIR';
```

## SODA — JSON Document Store

Simple Oracle Document Access for JSON collections. Requires `SODA_APP` role plus `CREATE SESSION` and `CREATE TABLE` privileges.

**Note:** SODA commands are case-sensitive (use lowercase `soda`).

```
soda list                          -- list collections
soda create employees_json         -- create collection
soda insert employees_json {"name":"John","dept":10}
soda get employees_json -all       -- list keys of all documents
soda get employees_json -k <key>   -- get document by key
soda get employees_json -klist <k1> <k2>  -- get by multiple keys
soda get employees_json -f {"dept":10}    -- get by QBE filter
soda count employees_json          -- count all documents
soda count employees_json {"dept":10}     -- count matching filter
soda replace employees_json <key> {"name":"Jane","dept":20}  -- replace document
soda remove employees_json -k <key>       -- remove by key
soda remove employees_json -f {"dept":10} -- remove by filter
soda drop employees_json           -- drop collection (commit writes first)
```

### SODA Query by Example (QBE)
```
soda get employees_json -f {"dept":10}
soda get employees_json -f {"salary":{"$gt":50000}}
soda get employees_json -f {"name":{"$startsWith":"A"}}
```

## Common Data Workflows

### Export table to CSV
```
-- Set format first (run-sqlcl)
SET SQLFORMAT csv

-- Then query (run-sql)
SELECT * FROM employees;
```

### Generate INSERT statements for migration
```
-- Via run-sql with inline hint
SELECT /*insert*/ * FROM config_data;
```

### Quick row count for all tables
```sql
-- Via run-sql
SELECT table_name, num_rows, last_analyzed
FROM user_tables
ORDER BY num_rows DESC NULLS LAST;
```

### Fresh row counts (may be slow for large schemas)
```sql
-- Via run-sql
BEGIN
  DBMS_STATS.GATHER_SCHEMA_STATS(USER);
END;
```
