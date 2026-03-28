# Data Operations Template

Common data workflows via SQLcl MCP.

## Load CSV Data

### Step 1: Verify target table exists
```sql
-- run-sql
SELECT column_name, data_type, data_length, nullable
FROM user_tab_columns WHERE table_name = UPPER('<table_name>')
ORDER BY column_id;
```

### Step 2: Load
```
-- run-sqlcl
LOAD <table_name> <file_path>
```

### Step 3: Verify
```sql
-- run-sql
SELECT COUNT(*) FROM <table_name>;
SELECT * FROM <table_name> FETCH FIRST 5 ROWS ONLY;
```

## Export Data as CSV

### Step 1: Set format
```
-- run-sqlcl
SET SQLFORMAT csv
```

### Step 2: Query
```sql
-- run-sql
SELECT * FROM <table_name> WHERE <conditions>;
```

## Export as INSERT Statements

```sql
-- run-sql (inline hint)
SELECT /*insert*/ * FROM <table_name> WHERE <conditions>;
```

## Bulk Data Copy Between Tables

```sql
-- run-sql
INSERT INTO target_table (col1, col2, col3)
SELECT col1, col2, col3 FROM source_table
WHERE <conditions>;
COMMIT;
```

## Data Pump Export

### Step 1: Check directory
```sql
-- run-sql
SELECT directory_name, directory_path FROM all_directories WHERE directory_name = 'DATA_PUMP_DIR';
```

### Step 2: Export
```
-- run-sqlcl
DATAPUMP EXPORT -schemas <schema> -directory DATA_PUMP_DIR -dumpfile <name>.dmp -logfile <name>.log
```

## Data Pump Import

```
-- run-sqlcl
DATAPUMP IMPORT -schemas <schema> -directory DATA_PUMP_DIR -dumpfile <name>.dmp -logfile <name>.log
```

## Truncate and Reload

```sql
-- run-sql
TRUNCATE TABLE <table_name>;
```

Then LOAD from CSV.

## Row Count Audit

```sql
-- run-sql (run SET SERVEROUTPUT ON via run-sqlcl first)
DECLARE
  v_cnt NUMBER;
BEGIN
  FOR r IN (SELECT table_name FROM user_tables ORDER BY table_name) LOOP
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || r.table_name INTO v_cnt;
    DBMS_OUTPUT.PUT_LINE(RPAD(r.table_name, 30) || ' : ' || v_cnt);
  END LOOP;
END;
```
