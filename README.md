# Oracle APEX Component Modifier

A **Claude Code Skill** that exports Oracle APEX components, modifies the exported files, applies DB changes, and imports everything back — using **Oracle SQLcl's MCP Server**.

[![Installation Guide](https://img.youtube.com/vi/XRdzPfbtRwM/maxresdefault.jpg)](https://www.youtube.com/watch?v=XRdzPfbtRwM)

## What It Does

The skill gives Claude Code the ability to directly modify your Oracle APEX application by:

1. **Exporting** a component (page, region, LOV, etc.) via SQLcl split export
2. **Reading** bundled APEX 24.2 import-API reference docs to understand the export format
3. **Applying DB changes** (CREATE TABLE, ALTER, PL/SQL packages) via SQLcl
4. **Patching** the exported SQL files with the requested modifications
5. **Importing** the patched component back into APEX via SQLcl
6. **Validating** the result (compilation checks, re-export diff)

All steps run through the SQLcl MCP server — no manual SQL or file editing required.

## Supported Components

| Category | Components |
|----------|------------|
| **Page-level** | Pages, regions, page items, buttons, processes, computations, branches |
| **Dynamic actions** | Events, actions (full DA lifecycle) |
| **Validations** | Page and item-level validations |
| **Reports** | Interactive Reports (IR), Interactive Grids (IG), Classic Reports |
| **Visualizations** | JET Charts (bar, line, pie, etc.), Maps |
| **Cards** | Cards regions, card components, media, actions, icons |
| **Forms** | Form regions with DML processes |
| **Faceted Search** | Faceted search regions and facets |
| **Shared components** | LOVs, authorization schemes, list entries, templates, build options, static files |

## Companion Skills

This repo also provides read-only skills for inspection and pattern learning:

| Skill | Invocation | Purpose |
|-------|------------|---------|
| **apex-describe** | `/apex-describe PAGE:5` | Describe an APEX page or component by reading its export |
| **apex-export** | `/apex-export PAGE:5` | Export a component without modification (read-only) |
| **apex-learn** | `/apex-learn` | Export all components from an app, analyze conventions, and generate pattern files for future patching |

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code/overview) CLI installed
- [SQLcl 25.2.0+](https://www.oracle.com/database/sqldeveloper/technologies/sqlcl/) with Java 17 or 21

## Installation

### 1. Copy the skill into your project

```bash
cd your-project

# Clone the repo into a temp directory and copy the skill
git clone https://github.com/avhrst/apex-component-modifier.git /tmp/apex-skill
mkdir -p .claude/skills
cp -r /tmp/apex-skill/.claude/skills/apex-component-modifier .claude/skills/
rm -rf /tmp/apex-skill
```

### 2. Add the SQLcl MCP server

```bash
claude mcp add sqlcl -- sql -R 1 -mcp
```

> This registers SQLcl as an MCP server for Claude Code. The `-R 1` flag sets the restriction level (1 = least restrictive). Use `-R 4` for stricter environments.

If `sql` is not on your PATH, use the full path:

| OS      | Typical path                         |
|---------|--------------------------------------|
| Linux   | `/opt/sqlcl/bin/sql`                 |
| macOS   | `/usr/local/bin/sql`                 |
| Windows | `C:\Users\<you>\Oracle\sqlcl\bin\sql` |

> **Note:** This repo includes a `.mcp.json` file with the SQLcl MCP config. If you already have a `.mcp.json` in your project, merge the `sqlcl` entry into your existing config instead of overwriting it. The `${SQLCL_PATH:-sql}` syntax falls back to `sql` if `SQLCL_PATH` is not set.

### 3. Create a saved SQLcl connection

Open SQLcl and save a connection to your APEX database:

```sql
sql /nolog
conn -save DEV -savepwd -user YOUR_USER/YOUR_PASS@host:port/service
```

This stores the connection in `~/.dbtools` so the MCP server can use it without prompting for credentials.

### 4. Configure skill settings

Create `.claude/settings.json` in your project root with your APEX environment defaults:

```json
{
  "env": {
    "SQLCL_CONNECTION": "DEV",
    "APEX_APP_ID": "113",
    "APEX_WORKSPACE": "DEV_WORKSPACE"
  }
}
```

| Setting | Description |
|---------|-------------|
| `SQLCL_CONNECTION` | The saved connection alias from step 3 |
| `APEX_APP_ID` | Your APEX application ID |
| `APEX_WORKSPACE` | Your APEX workspace name |

For personal overrides (not committed to git), create `.claude/settings.local.json` with the same structure.

### 5. Verify

Open Claude Code in your project and run:

```
/apex-component-modifier PAGE:1 -- Describe page 1
```

## Usage

```
/apex-component-modifier PAGE:10 -- Add item P10_STATUS as a select list
```

The skill uses your configured defaults. Override them inline when needed:

```
/apex-component-modifier STG 200 PAGE:10 -- Add item P10_STATUS as a select list
```

Arguments:
- **Connection** (optional) — overrides `$SQLCL_CONNECTION`
- **App ID** (optional) — overrides `$APEX_APP_ID`
- **Component** — `PAGE:10`, `LOV:<id>`, `REGION:<id>`
- **Change request** — what to modify (after `--`)

### Workflow

When invoked, the skill follows a structured 9-step workflow:

1. **Discover MCP tools** — confirms SQLcl MCP connectivity
2. **Create working area** — timestamped folder; creates a git branch if in a repo
3. **Identify target** — normalizes the component selector, resolves IDs via `apex list`
4. **Export** — runs `apex export -split -expComponents` to get the component files
5. **Load references** — reads the bundled APEX 24.2 import-API docs and any app-specific patterns
6. **Plan** — splits work into DB changes and APEX file patches
7. **Apply DB changes** — runs idempotent DDL/DML scripts via SQLcl
8. **Patch export files** — modifies the SQL export using safe anchoring and ID rules
9. **Import + validate** — runs the install script via SQLcl, re-exports to diff

### Examples

```
# Add a new page item with supporting table
/apex-component-modifier PAGE:10 -- Add item P10_STATUS (select list) based on LOV STATUS_LOV, create table APP_STATUS if missing

# Modify a shared LOV and update dependent items
/apex-component-modifier LOV:23618973754424510000 -- Rename LOV display column and update dependent items on Page 3

# Use a specific connection and app
/apex-component-modifier STG 113 PAGE:10 -- Add item P10_STATUS (select list) based on LOV STATUS_LOV
```

## How It Works

### Bundled Reference Documentation

The skill includes comprehensive APEX 24.2 import-API reference docs under `references/apex_imp/`:

| File | Covers |
|------|--------|
| `apex_imp.md` | Core import engine, ID system, file format |
| `imp_page.md` | Pages, regions, items, buttons, DAs, IR/IG, charts, maps, cards |
| `imp_shared.md` | LOVs, auth schemes, lists, templates, build options |
| `valid_values.md` | All enumerated parameter values (region types, item types, etc.) |
| `app_install.md` | Pre-import configuration for cross-environment installs |
| `export_api.md` | Export API and SQLcl export commands |

### Global Component Patterns

Pre-built patterns under `global-patterns/` for common component types:

- Interactive Reports, Interactive Grids, Classic Reports
- Cards (regions, components, media, actions, icons)
- JET Charts, Form regions, Dynamic Actions, Faceted Search

### App-Specific Patterns

The `app-patterns/` directory (initially empty) stores conventions learned from your specific application via `/apex-learn`. These include template IDs, naming conventions, and layout patterns that the skill uses to generate consistent patches.

### Safety

- Creates a git baseline commit before any changes
- Uses idempotent DB scripts (safe to re-run)
- Validates patched files before import
- Provides rollback instructions for every failure scenario

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Skill not listed in Claude Code | Ensure `SKILL.md` is at `.claude/skills/apex-component-modifier/SKILL.md` |
| SQLcl MCP not connecting | Verify `sql` is on your PATH or use full path in `claude mcp add` |
| `No saved connection found` | Run `conn -save <alias> -savepwd` inside SQLcl |
| Java version errors | SQLcl 25.2+ requires Java 17 or 21 — check with `java -version` |
| Import ID collision | Re-export to get fresh IDs; check `apex_imp.md` ID rules |
| Component broken after import | Re-import the baseline export from the git branch |
