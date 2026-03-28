# CLAUDE.md — Oracle APEX & SQLcl Skills (via Oracle SQLcl MCP)

This repo defines **Claude Code Skills** for working with **Oracle Database and APEX** through **Oracle SQLcl’s built-in MCP Server**:

1. **apex-component-modifier** — Export/patch/import APEX components (pages, regions, items, etc.)
2. **sqlcl** — General-purpose Oracle DB & APEX operations (SQL, schema inspection, data ops, Liquibase, Data Pump, CI/CD projects)

## What you’re building

A repeatable workflow:

1. **Export** an APEX component (page / shared component / partial component set) using **SQLcl MCP**.
2. **Read local docs** for `apex_imp` (bundled in this skill directory) to guide safe modifications.
3. **Apply DB changes** (create/alter tables, packages, views, grants) via **SQLcl MCP**.
4. **Patch the exported component file(s)** in the export directory.
5. **Import** (run install scripts) via **SQLcl MCP**.
6. **Validate** (compile, sanity queries, optional APEX metadata checks).

> APEX exports/installs via SQLcl are supported by Oracle APEX Administration Guide; exporting/importing via SQLcl is supported in SQLcl release 22.1+ and later.

---

## Key upstream facts (so you don’t reinvent the wheel)

### Claude Code Skills
- Project skills live in `.claude/skills/` and can be committed to version control.
- `disable-model-invocation: true` means **only the user** can invoke the skill (useful for side-effect workflows like import/deploy).

### Claude Code MCP
- Project-scoped MCP servers are stored in a `.mcp.json` at repo root.
- You can add a local stdio server with `claude mcp add --transport stdio ...`.
- `.mcp.json` supports environment variable expansion like `${VAR}` and `${VAR:-default}`.

### Oracle SQLcl MCP Server
- SQLcl ships an MCP server mode: configure MCP clients to run `sql` with `args: ["-mcp"]`.
- Requires **SQLcl 25.2.0+** and **Java 17 or 21**.
- Uses saved connections in `~/.dbtools`; create one with `conn -save ... -savepwd ...`.
- Exposes MCP tools: `list-connections`, `connect`, `disconnect`, `run-sql`, `run-sqlcl`.
- Security + auditing features: recommends least privilege; avoids prod; logs to `DBTOOLS$MCP_LOG` and marks sessions in `V$SESSION`.
- Restrict levels: defaults to **level 4** (most restrictive); you can pass `-R <level>` to allow more capabilities.

---

## Skill settings

The skill uses environment variables defined in `.claude/settings.json` (shared, committed) with optional per-user overrides in `.claude/settings.local.json` (gitignored).

| Env var | Purpose | Example |
|---------|---------|---------|
| `SQLCL_CONNECTION` | SQLcl saved connection alias (in `~/.dbtools`) | `DEV` |
| `APEX_APP_ID` | Default APEX application ID | `113` |
| `APEX_WORKSPACE` | APEX workspace name | `DEV_WORKSPACE` |

**Override chain** (highest wins):
1. Inline skill arguments (`/apex-component-modifier STG 200 PAGE:5 -- ...`)
2. `.claude/settings.local.json` (per-user, gitignored)
3. `.claude/settings.json` (team defaults, committed)

To customize for your environment, create `.claude/settings.local.json`:
```json
{
  "env": {
    "SQLCL_CONNECTION": "MY_LOCAL_DEV",
    "APEX_APP_ID": "200",
    "APEX_WORKSPACE": "MY_WORKSPACE"
  }
}
```

---

## Repository layout

```
apex-component-modifier/
├── .claude/
│   ├── settings.json                            -- Shared skill settings (env vars)
│   ├── commands/
│   │   ├── apex-describe.md                     -- /apex-describe slash command
│   │   ├── apex-export.md                       -- /apex-export slash command
│   │   ├── apex-learn.md                        -- /apex-learn slash command
│   │   └── sqlcl.md                             -- /sqlcl slash command
│   └── skills/
│       ├── apex-component-modifier/
│       │   ├── SKILL.md                         -- APEX component patching skill
│       │   ├── references/
│       │   │   └── apex_imp/
│       │   │       ├── README.md                -- Reference index & quick lookup table
│       │   │       ├── apex_imp.md              -- wwv_flow_imp core (import engine, ID system, file format)
│       │   │       ├── imp_page.md              -- wwv_flow_imp_page (pages, regions, items, buttons, DAs, IR/IG, charts, maps, cards)
│       │   │       ├── imp_shared.md            -- wwv_flow_imp_shared (LOVs, auth, lists, templates, build options)
│       │   │       ├── valid_values.md          -- All enumerated parameter values (region/item/process types, etc.)
│       │   │       ├── app_install.md           -- apex_application_install (pre-import configuration)
│       │   │       └── export_api.md            -- apex_export & SQLcl export commands
│       │   ├── templates/
│       │   │   ├── patch_plan.md                -- Change plan template
│       │   │   └── validation_checklist.md      -- Post-patch validation checklist
│       │   └── tools/
│       │       ├── normalize_export_paths.md    -- Component selector → file path mapping
│       │       └── patching_guidelines.md       -- Safe patching strategies & rules
│       └── sqlcl/
│           ├── SKILL.md                         -- SQLcl general-purpose skill
│           ├── references/
│           │   ├── README.md                    -- Reference index & decision tree
│           │   ├── mcp_tools.md                 -- MCP server tools, connections, restriction levels
│           │   ├── sql_plsql.md                 -- SQL queries, DML, DDL, PL/SQL patterns
│           │   ├── schema_commands.md           -- INFO, DDL, DESC, CTAS, OERR, CODESCAN, REST
│           │   ├── data_commands.md             -- LOAD, SPOOL, BRIDGE, DATAPUMP, SODA, SQLFORMAT
│           │   ├── apex_commands.md             -- APEX export/import, component selectors, workspace
│           │   ├── liquibase_commands.md        -- Schema capture, diff, update, rollback, tags
│           │   └── project_commands.md          -- PROJECT init/export/stage/release/deploy (CI/CD)
│           └── templates/
│               ├── schema_inspection.md         -- Schema audit workflow
│               ├── data_operations.md           -- Load/export/copy data workflow
│               ├── apex_management.md           -- APEX app management workflow
│               ├── migration_workflow.md        -- Schema comparison & migration workflow
│               └── monitoring.md                -- Session & DB monitoring queries
├── .mcp.json                                    -- SQLcl MCP server config
├── CLAUDE.md                                    -- Project instructions (this file)
└── README.md                                    -- Project overview & setup guide
```

