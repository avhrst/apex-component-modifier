# CLAUDE.md — Oracle APEX Component Modifier Skill (via Oracle SQLcl MCP)

This repo defines a **Claude Code Skill** that can **export an Oracle APEX component (e.g., Page)**, **modify the exported files**, optionally **apply related DB changes**, and then **import the component back** — using **Oracle SQLcl’s built-in MCP Server**.

## What you’re building

A repeatable workflow:

1. **Export** an APEX component (page / shared component / partial component set) using **SQLcl MCP**.
2. **Read local docs** for `apex_imp` (bundled in this skill directory) to guide safe modifications.
3. **Apply DB changes** (create/alter tables, packages, views, grants) via **SQLcl MCP**.
4. **Patch the exported component file(s)** in the export directory.
5. **Import** (run install scripts) via **SQLcl MCP**.
6. **Validate** (compile, sanity queries, optional APEX metadata checks).

> APEX exports/installs via SQLcl are supported by Oracle APEX Administration Guide; exporting/importing via SQLcl is supported in SQLcl release 22.1+ and later. :contentReference[oaicite:0]{index=0}

---

## Key upstream facts (so you don’t reinvent the wheel)

### Claude Code Skills
- Project skills live in `.claude/skills/` and can be committed to version control. :contentReference[oaicite:1]{index=1}
- `disable-model-invocation: true` means **only the user** can invoke the skill (useful for side-effect workflows like import/deploy). :contentReference[oaicite:2]{index=2}

### Claude Code MCP
- Project-scoped MCP servers are stored in a `.mcp.json` at repo root. :contentReference[oaicite:3]{index=3}
- You can add a local stdio server with `claude mcp add --transport stdio ...`. :contentReference[oaicite:4]{index=4}
- `.mcp.json` supports environment variable expansion like `${VAR}` and `${VAR:-default}`. :contentReference[oaicite:5]{index=5}

### Oracle SQLcl MCP Server
- SQLcl ships an MCP server mode: configure MCP clients to run `sql` with `args: ["-mcp"]`. :contentReference[oaicite:6]{index=6}
- Requires **SQLcl 25.2.0+** and **Java 17 or 21**. :contentReference[oaicite:7]{index=7}
- Uses saved connections in `~/.dbtools`; create one with `conn -save ... -savepwd ...`. :contentReference[oaicite:8]{index=8}
- Exposes MCP tools: `list-connections`, `connect`, `disconnect`, `run-sql`, `run-sqlcl`. :contentReference[oaicite:9]{index=9}
- Security + auditing features: recommends least privilege; avoids prod; logs to `DBTOOLS$MCP_LOG` and marks sessions in `V$SESSION`. :contentReference[oaicite:10]{index=10}
- Restrict levels: defaults to **level 4** (most restrictive); you can pass `-R <level>` to allow more capabilities. :contentReference[oaicite:11]{index=11}

---

## Repository layout

```
apex-component-modifier/
├── .mcp.json                                    -- SQLcl MCP server config
├── CLAUDE.md                                    -- Project instructions (this file)
├── README.md                                    -- Project overview & setup guide
└── skills/
    └── apex-component-modifier/
        ├── SKILL.md                             -- Skill definition (workflow + instructions)
        ├── references/
        │   └── apex_imp/
        │       ├── README.md                    -- Reference index & quick lookup table
        │       ├── apex_imp.md                  -- wwv_flow_imp core (import engine, ID system, file format)
        │       ├── imp_page.md                  -- wwv_flow_imp_page (pages, regions, items, buttons, DAs, IR/IG, charts, maps, cards)
        │       ├── imp_shared.md                -- wwv_flow_imp_shared (LOVs, auth, lists, templates, build options)
        │       ├── valid_values.md              -- All enumerated parameter values (region/item/process types, etc.)
        │       ├── app_install.md               -- apex_application_install (pre-import configuration)
        │       └── export_api.md                -- apex_export & SQLcl export commands
        ├── templates/
        │   ├── patch_plan.md                    -- Change plan template
        │   └── validation_checklist.md          -- Post-patch validation checklist
        └── tools/
            ├── normalize_export_paths.md        -- Component selector → file path mapping
            └── patching_guidelines.md           -- Safe patching strategies & rules
```

