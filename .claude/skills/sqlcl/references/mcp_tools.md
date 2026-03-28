# SQLcl MCP Tools Reference

## The Five MCP Tools

### list-connections
List all saved Oracle Database connections on the local machine (`~/.dbtools`).

**Parameters:** `model` (optional), `mcp_client` (optional)

**Use:** Discovery — find what connections are available before connecting.

### connect
Establish a connection to a named saved connection. Case-sensitive.

**Parameters:** `connection_name` (required), `model` (optional), `mcp_client` (optional)

**Notes:**
- If already connected, switches connection (may prompt for confirmation)
- Connection must exist in `~/.dbtools` (created via `conn -save <name> -savepwd`)

### disconnect
Terminate the current active database connection.

**Parameters:** `model` (optional), `mcp_client` (optional)

### run-sql
Execute standard SQL queries and PL/SQL code blocks. Returns results in CSV format.

**Parameters:** `sql` (required), `model` (optional), `mcp_client` (optional)

**Supports:**
- SELECT, INSERT, UPDATE, DELETE, MERGE
- CREATE, ALTER, DROP (DDL)
- PL/SQL anonymous blocks (`BEGIN...END;`)
- CREATE OR REPLACE (packages, procedures, functions, triggers, views)

**Does NOT support:** SQLcl-specific commands (DDL, INFO, APEX, LIQUIBASE, etc.)

### run-sqlcl
Execute SQLcl-specific commands. Extends capabilities beyond standard SQL.

**Parameters:** `sql` (required), `model` (optional), `mcp_client` (optional)

**Supports:** All SQLcl proprietary commands:
- Schema: `INFO`, `DDL`, `DESC`, `CTAS`
- Data: `LOAD`, `SPOOL`, `BRIDGE`, `SET SQLFORMAT`
- APEX: `APEX EXPORT`, `APEX LIST`, `APEX VERSION`
- Migration: `LIQUIBASE *`
- Data Pump: `DATAPUMP *`
- Projects: `PROJECT *`
- Quality: `CODESCAN`
- Errors: `OERR`
- REST: `REST *`
- JSON: `SODA *`
- Config: `SET`, `SHOW`, `ALIAS`

## run-sql vs run-sqlcl Decision Table

| Command | Tool |
|---------|------|
| `SELECT * FROM ...` | `run-sql` |
| `INSERT INTO ...` | `run-sql` |
| `CREATE TABLE ...` | `run-sql` |
| `CREATE OR REPLACE PACKAGE ...` | `run-sql` |
| `BEGIN ... END;` | `run-sql` |
| `DECLARE ... BEGIN ... END;` | `run-sql` |
| `INFO employees` | `run-sqlcl` |
| `DDL employees` | `run-sqlcl` |
| `APEX EXPORT ...` | `run-sqlcl` |
| `LIQUIBASE ...` | `run-sqlcl` |
| `LOAD ...` | `run-sqlcl` |
| `SET SQLFORMAT ...` | `run-sqlcl` |
| `DATAPUMP ...` | `run-sqlcl` |
| `PROJECT ...` | `run-sqlcl` |
| `OERR ORA 01722` | `run-sqlcl` |
| `CODESCAN ...` | `run-sqlcl` |
| `SODA ...` | `run-sqlcl` |
| `SHOW USER` | `run-sqlcl` |

## Restriction Levels (-R)

The MCP server's `-R` flag controls capabilities. Default is **level 4** (most restrictive).

| Level | HOST / OS | SPOOL / SAVE / EDIT | Scripts (@, @@, START) | DML/DDL | Queries |
|-------|-----------|---------------------|------------------------|---------|---------|
| 0 | Yes | Yes | Yes | Yes | Yes |
| 1 | No | Yes | Yes | Yes | Yes |
| 2 | No | No | Yes | Yes | Yes |
| 3 | No | No | No | Yes | Yes |
| 4 | No | No | No | Yes | Yes |

**Level differences:**
- **Level 0** — Full access, no restrictions.
- **Level 1** — Blocks HOST, `!`, `$` (OS shell-out commands).
- **Level 2** — Also blocks SPOOL, SAVE, EDIT, STORE (file I/O).
- **Level 3** — Also blocks `@`, `@@`, START (script execution).
- **Level 4** — Most restrictive (MCP default). Blocks additional sensitive operations.

**Configuration in `.mcp.json`:**
```json
{
  "mcpServers": {
    "sqlcl": {
      "command": "/path/to/sql",
      "args": ["-R", "1", "-mcp"]
    }
  }
}
```

## Auditing & Monitoring

### DBTOOLS$MCP_LOG
Logs every MCP interaction:
```sql
SELECT id, mcp_client, model, end_point_type, end_point_name, log_message
FROM dbtools$mcp_log
ORDER BY id DESC
FETCH FIRST 20 ROWS ONLY;
```

### V$SESSION identification
```sql
SELECT sid, serial#, username, module, action, program
FROM v$session
WHERE program LIKE '%SQLcl-MCP%';
```

- **MODULE** = MCP client name
- **ACTION** = LLM model name
- **PROGRAM** = `SQLcl-MCP`

### Query Identification
All LLM-generated queries include a `/* LLM in use ... */` comment, visible in `V$SQL`, ASH, and AWR reports.

### Maintenance Note
`DBTOOLS$MCP_LOG` has no automatic cleanup. Regularly purge old records to avoid table growth.

## Connection Workflow

```
1. list-connections          → find available aliases
2. connect(connection_name)  → establish connection
3. run-sql / run-sqlcl       → execute commands
4. disconnect                → cleanup (optional — session ends on MCP shutdown)
```

## Environment Variables

| Var | Set By | Purpose |
|-----|--------|---------|
| `SQLCL_CONNECTION` | `.claude/settings.json` | Default connection alias |
| `APEX_APP_ID` | `.claude/settings.json` | Default APEX app ID |
| `APEX_WORKSPACE` | `.claude/settings.json` | Default APEX workspace |

Override in `.claude/settings.local.json` (gitignored) for per-user config.
