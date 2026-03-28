# SQLcl Skill Reference Index

Quick lookup for which reference file to consult.

## Reference Files

| File | Covers | When to Use |
|------|--------|-------------|
| `mcp_tools.md` | MCP server tools, connection management, restriction levels, auditing | Always — first thing to read for any SQLcl MCP interaction |
| `sql_plsql.md` | SQL queries, DML, DDL, PL/SQL blocks, bind variables, scripts | Any SQL or PL/SQL execution via `run-sql` |
| `schema_commands.md` | INFO, DDL, DESC, CTAS, OERR, CODESCAN, REST, ALIAS, SET options | Schema inspection, DDL generation, error lookup, code quality |
| `data_commands.md` | LOAD, SPOOL, BRIDGE, DATAPUMP, SODA, SET SQLFORMAT | Data loading, export, external data, JSON documents, output formatting |
| `apex_commands.md` | APEX export/import, component selectors, split exports, workspace mgmt | Any APEX application management |
| `liquibase_commands.md` | Liquibase schema capture, diff, update, rollback, status, tags | Schema versioning, migration, comparison |
| `project_commands.md` | PROJECT init/export/stage/release/deploy, CI/CD workflows | CI/CD pipeline, versioned releases, multi-environment deployments |

## Decision Tree

```
User request
├── SQL query / DML / DDL / PL/SQL → sql_plsql.md (use run-sql)
├── Schema info / DDL generation / describe → schema_commands.md (use run-sqlcl)
├── Load CSV / export data / JSON docs → data_commands.md (use run-sqlcl)
├── APEX app / page / component → apex_commands.md (use run-sqlcl)
├── Schema diff / migration / changelog → liquibase_commands.md (use run-sqlcl)
├── Data Pump export/import → data_commands.md (use run-sqlcl)
├── CI/CD project setup / deploy → project_commands.md (use run-sqlcl)
├── Error lookup (ORA/PLS codes) → schema_commands.md (use run-sqlcl: OERR)
├── Code quality scan → schema_commands.md (use run-sqlcl: CODESCAN)
├── REST / ORDS modules → schema_commands.md (use run-sqlcl: REST)
├── Output formatting → data_commands.md (use run-sqlcl: SET SQLFORMAT)
├── Monitoring / diagnostics → mcp_tools.md (use run-sql for V$ views)
└── Connection / MCP setup → mcp_tools.md
```
