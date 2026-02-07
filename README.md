# Oracle APEX Component Modifier

A **Claude Code Skill** that exports an Oracle APEX component, modifies the exported files, optionally applies related DB changes, and imports the component back — using **Oracle SQLcl's built-in MCP Server**.

## Prerequisites

- **SQLcl 25.2.0+** with MCP server mode (`sql -mcp`)
- **Java 17 or 21**
- A saved SQLcl connection in `~/.dbtools` (created with `conn -save <alias> -savepwd`)
- **Claude Code** with MCP support

## Setup

1. Clone this repo
2. Configure `.mcp.json` — set `SQLCL_PATH` env var if `sql` is not on PATH
3. Place any additional `apex_imp` documentation in `.claude/skills/apex-component-modifier/references/apex_imp/`

## Usage

Invoke the skill from Claude Code:

```
/apex-component-modifier DEV 113 PAGE:10 -- Add item P10_STATUS (select list) based on LOV STATUS_LOV
```

Arguments:
- **Connection/environment** — SQLcl connect alias (e.g., `DEV`, `STG`)
- **App ID** — numeric APEX application ID
- **Component** — selector like `PAGE:10`, `LOV:<id>`, `REGION:<id>`
- **Change request** — what to modify (after `--`)

## Workflow

1. Export the APEX component via SQLcl MCP
2. Read local `apex_imp` reference docs for safe modification patterns
3. Plan DB + APEX changes
4. Apply DB changes (idempotent scripts)
5. Patch exported component file(s)
6. Import back into APEX
7. Verify via re-export and diff

## Repository Structure

```
.claude/skills/apex-component-modifier/
  SKILL.md                          -- Skill definition (workflow + instructions)
  references/apex_imp/
    README.md                       -- Reference docs index
    apex_imp.md                     -- Full API reference for wwv_flow_imp* packages
  templates/
    patch_plan.md                   -- Change plan template
    validation_checklist.md         -- Post-patch validation checklist
  tools/
    normalize_export_paths.md       -- Component selector → file path mapping
    patching_guidelines.md          -- Safe patching strategies and rules
.mcp.json                          -- SQLcl MCP server configuration
CLAUDE.md                          -- Project instructions for Claude Code
```
