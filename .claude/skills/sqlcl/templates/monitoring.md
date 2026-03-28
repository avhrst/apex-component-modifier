# Monitoring & Diagnostics Template

Database and session monitoring queries.

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
SELECT timestamp, tool_name, sql_text, execution_time, result_status
FROM dbtools$mcp_log
ORDER BY timestamp DESC
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
SELECT s.sid, s.serial#, s.username, l.type, l.lmode, l.request,
       o.object_name, s.blocking_session
FROM v$lock l
JOIN v$session s ON l.sid = s.sid
LEFT JOIN dba_objects o ON l.id1 = o.object_id
WHERE s.username IS NOT NULL AND (l.request > 0 OR l.lmode > 0)
ORDER BY s.blocking_session NULLS LAST;
```

## Wait Events

```sql
-- run-sql
SELECT event, total_waits, time_waited_micro/1000000 time_sec,
       average_wait_micro/1000 avg_ms
FROM v$system_event
WHERE wait_class != 'Idle'
ORDER BY time_waited_micro DESC
FETCH FIRST 20 ROWS ONLY;
```

## Tablespace Usage

```sql
-- run-sql
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

## Database Parameters

```sql
-- run-sql
SELECT name, value FROM v$parameter
WHERE name IN (
  'db_name','db_unique_name','open_mode','log_mode',
  'compatible','nls_characterset','nls_language','nls_territory',
  'processes','sessions','sga_target','pga_aggregate_target'
)
ORDER BY name;
```

## APEX Activity

```sql
-- run-sql
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
