# Schema Inspection Template

Standard workflow for inspecting a database schema.

## 1. Connection Check

```
-- run-sql
SELECT USER, SYS_CONTEXT('USERENV','DB_NAME') db_name,
       SYS_CONTEXT('USERENV','CURRENT_SCHEMA') current_schema,
       SYS_CONTEXT('USERENV','SESSION_USER') session_user
FROM dual;
```

## 2. Schema Overview

```sql
-- run-sql: object counts by type
SELECT object_type, COUNT(*) cnt, SUM(CASE WHEN status = 'INVALID' THEN 1 ELSE 0 END) invalid
FROM user_objects
GROUP BY object_type
ORDER BY cnt DESC;
```

## 3. Tables Summary

```sql
-- run-sql
SELECT table_name, num_rows, last_analyzed,
       ROUND(bytes/1024/1024,2) size_mb
FROM user_tables t
LEFT JOIN (SELECT segment_name, bytes FROM user_segments WHERE segment_type = 'TABLE') s
  ON t.table_name = s.segment_name
ORDER BY num_rows DESC NULLS LAST;
```

## 4. Detailed Table Info

```
-- run-sqlcl (per table)
INFO+ <table_name>
```

## 5. Invalid Objects

```sql
-- run-sql
SELECT object_name, object_type, status
FROM user_objects WHERE status = 'INVALID'
ORDER BY object_type, object_name;
```

## 6. Foreign Key Map

```sql
-- run-sql
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

## 7. PL/SQL Code Summary

```sql
-- run-sql
SELECT name, type, COUNT(DISTINCT line) lines
FROM user_source
GROUP BY name, type
ORDER BY type, name;
```

## 8. Privileges

```sql
-- run-sql
SELECT privilege FROM session_privs ORDER BY 1;
SELECT grantee, table_name, privilege FROM user_tab_privs_made ORDER BY 1,2;
```
