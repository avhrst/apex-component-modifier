# Data Commands Reference (run-sqlcl)

All commands in this file use the `run-sqlcl` MCP tool unless noted.

## LOAD — CSV Import

Load CSV/delimited files into a table.

```
LOAD employees employees.csv
LOAD employees /path/to/data.csv
```

**Requirements:**
- CSV must have a header row matching column names
- Processes in 50-row batches
- UTF-8 encoding

**Advanced options:**
```
LOAD employees data.csv
  NEW                              -- create table from CSV structure
  SHOW                             -- show the generated SQL without executing
  DELIMITER "|"                    -- custom delimiter
  ENCLOSURE '"'                    -- custom enclosure char
  ENCODING UTF-8                   -- specify encoding
```

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

## BRIDGE — External Data Sources

Query external data sources directly as SQL tables.

```
-- Query a CSV file
BRIDGE csv_data AS "SELECT * FROM EXTERNAL('/path/to/data.csv')";
SELECT * FROM csv_data WHERE amount > 1000;

-- Query Excel file
BRIDGE xls_data AS "SELECT * FROM EXTERNAL('/path/to/workbook.xlsx')";

-- Query another database via JDBC
BRIDGE pg_data AS "SELECT * FROM EXTERNAL('jdbc:postgresql://host/db','user','pass','SELECT * FROM orders')";
```

## DATAPUMP — Data Pump Export/Import

Wrapper over DBMS_DATAPUMP for schema and table-level operations.

### Export Schema
```
DATAPUMP EXPORT -schemas HR -directory DATA_PUMP_DIR -dumpfile hr_export.dmp -logfile hr_export.log
```

### Export Tables
```
DATAPUMP EXPORT -schemas HR -tables EMPLOYEES,DEPARTMENTS -directory DATA_PUMP_DIR -dumpfile tables.dmp
```

### Import Schema
```
DATAPUMP IMPORT -schemas HR -directory DATA_PUMP_DIR -dumpfile hr_export.dmp -logfile hr_import.log
```

### Import Tables
```
DATAPUMP IMPORT -schemas HR -tables EMPLOYEES -directory DATA_PUMP_DIR -dumpfile tables.dmp
```

### Common Parameters

| Parameter | Description |
|-----------|-------------|
| `-schemas` | Schema(s) to export/import |
| `-tables` | Specific table(s) |
| `-directory` | Oracle directory object for dump/log files |
| `-dumpfile` | Dump file name |
| `-logfile` | Log file name |
| `-jobname` | Data Pump job name |
| `-content` | `ALL`, `DATA_ONLY`, `METADATA_ONLY` |
| `-exclude` | Exclude object types (e.g., `STATISTICS`) |
| `-include` | Include only specified types |
| `-remap_schema` | Map source schema to target |
| `-remap_tablespace` | Map source tablespace to target |

### Check Data Pump directory
```sql
-- Via run-sql
SELECT directory_name, directory_path FROM all_directories WHERE directory_name = 'DATA_PUMP_DIR';
```

## SODA — JSON Document Store

Simple Oracle Document Access for JSON collections (requires Oracle 21c+ or SODA-enabled schema).

```
SODA list                          -- list collections
SODA create employees_json         -- create collection
SODA insert employees_json {"name":"John","dept":10}
SODA get employees_json            -- get all documents
SODA get employees_json -k <key>   -- get by key
SODA count employees_json          -- count documents
SODA drop employees_json           -- drop collection
SODA remove employees_json -f {"dept":10}  -- remove by filter
```

### SODA Query by Example (QBE)
```
SODA get employees_json -f {"dept":10}
SODA get employees_json -f {"salary":{"$gt":50000}}
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
