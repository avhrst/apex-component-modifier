# Monitoring & Diagnostics Template

Database and session monitoring queries.

> **Privilege note:** Queries against `V$` views (`v$session`, `v$sql`, `v$lock`, `v$system_event`, `v$parameter`, `v$database`) require `SELECT_CATALOG_ROLE` or `SELECT ANY DICTIONARY` privilege. `DBA_*` views require DBA role or `SELECT_CATALOG_ROLE`. `USER_*` views and `DBTOOLS$MCP_LOG` are accessible without elevated privileges.

## Session Info

```sql
-- run-sql
SELECT sid, serial#, username, status, machine, program, module, action,
       sql_id, last_call_et, logon_time
FROM v$session
WHERE type = 'USER' AND username IS NOT NULL
ORDER BY last_call_et DESC;
```

## MCP Session Tracking

```sql
-- run-sql
SELECT sid, serial#, username, module, action, program
FROM v$session
WHERE program LIKE '%SQLcl-MCP%';
```

## MCP Audit Log

```sql
-- run-sql
-- DBTOOLS$MCP_LOG is auto-created in your schema on first MCP connection
SELECT id, mcp_client, model, end_point_type, end_point_name, log_message
FROM dbtools$mcp_log
ORDER BY id DESC
FETCH FIRST 20 ROWS ONLY;
```

## Active SQL

```sql
-- run-sql
SELECT s.sid, s.serial#, s.username, sq.sql_text,
       s.last_call_et elapsed_sec, s.status
FROM v$session s
JOIN v$sql sq ON s.sql_id = sq.sql_id
WHERE s.status = 'ACTIVE' AND s.type = 'USER'
ORDER BY s.last_call_et DESC;
```

## Locks & Blocking

```sql
-- run-sql
-- Note: v$lock.id1 maps to object_id only for TM (DML) locks.
-- For TX (transaction) locks, id1 contains rollback segment info.
-- For comprehensive lock info, also query v$locked_object.
SELECT s.sid, s.serial#, s.username, l.type, l.lmode, l.request,
       o.object_name, s.blocking_session
FROM v$lock l
JOIN v$session s ON l.sid = s.sid
LEFT JOIN all_objects o ON l.id1 = o.object_id AND l.type = 'TM'
WHERE s.username IS NOT NULL AND (l.request > 0 OR l.lmode > 0)
ORDER BY s.blocking_session NULLS LAST;
```

## Wait Events

```sql
-- run-sql
-- Note: v$system_event has no average_wait_micro column; derive from time_waited_micro / total_waits
SELECT event, total_waits, time_waited_micro/1000000 time_sec,
       ROUND(time_waited_micro / NULLIF(total_waits, 0) / 1000, 2) avg_ms
FROM v$system_event
WHERE wait_class != 'Idle'
ORDER BY time_waited_micro DESC
FETCH FIRST 20 ROWS ONLY;
```

## Tablespace Usage

```sql
-- run-sql (requires DBA privileges: SELECT on DBA_TABLESPACE_USAGE_METRICS)
-- Note: used_space and tablespace_size are in DB blocks; assumes 8KB block size.
-- For exact block size: SELECT value FROM v$parameter WHERE name = 'db_block_size'
SELECT tablespace_name,
       ROUND(used_space * 8192 / 1024 / 1024, 2) used_mb,
       ROUND(tablespace_size * 8192 / 1024 / 1024, 2) total_mb,
       ROUND(used_percent, 2) pct_used
FROM dba_tablespace_usage_metrics
ORDER BY used_percent DESC;
```

## Invalid Objects Check

```sql
-- run-sql
SELECT object_name, object_type, status, last_ddl_time
FROM user_objects WHERE status = 'INVALID'
ORDER BY object_type, object_name;
```

## Compilation Errors

```sql
-- run-sql
SELECT name, type, line, position, text
FROM user_errors
ORDER BY name, type, sequence;
```

## Recent DDL Changes

```sql
-- run-sql
SELECT object_name, object_type, last_ddl_time, status
FROM user_objects
WHERE last_ddl_time > SYSDATE - 1
ORDER BY last_ddl_time DESC;
```

## Database Info

```sql
-- run-sql (open_mode and log_mode are columns of v$database, not v$parameter)
SELECT name db_name, db_unique_name, open_mode, log_mode
FROM v$database;
```

## Key Initialization Parameters

```sql
-- run-sql (requires SELECT on V$PARAMETER or SELECT_CATALOG_ROLE)
SELECT name, value FROM v$parameter
WHERE name IN (
  'db_name','db_unique_name','compatible',
  'nls_characterset','nls_language','nls_territory',
  'processes','sessions','sga_target','pga_aggregate_target'
)
ORDER BY name;
```

## APEX Activity

```sql
-- run-sql
-- Note: timestamp column name may vary by APEX version (timestamp_tz, view_date, or time_stamp)
SELECT application_id, page_id, COUNT(*) views,
       MIN(timestamp_tz) first_view, MAX(timestamp_tz) last_view
FROM apex_workspace_activity_log
WHERE timestamp_tz > SYSTIMESTAMP - INTERVAL '24' HOUR
GROUP BY application_id, page_id
ORDER BY views DESC;
```

## Error Lookup

```
-- run-sqlcl
OERR ORA <number>
OERR PLS <number>
```
