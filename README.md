# Oracle APEX Component Modifier

A **Claude Code Skill** that exports an Oracle APEX component, modifies the exported files, optionally applies related DB changes, and imports the component back — using **Oracle SQLcl's built-in MCP Server**.

## Prerequisites

- **Claude Code** CLI installed ([instructions](https://docs.anthropic.com/en/docs/claude-code/overview))
- **SQLcl 25.2.0+** with MCP server mode (`sql -mcp`)
- **Java 17 or 21**
- A saved SQLcl connection in `~/.dbtools` (created with `conn -save <alias> -savepwd`)

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/AhmedVHRS/apex-component-modifier.git
cd apex-component-modifier
```

### 2. Create a saved SQLcl database connection

If you don't already have one, open SQLcl and save a connection:

```sql
conn -save DEV -savepwd -user YOUR_USER/YOUR_PASS@host:port/service
```

This stores the connection in `~/.dbtools` so the MCP server can use it.

### 3. Configure the SQLcl MCP server

Edit `.mcp.json` in the project root and set the `command` path to your SQLcl binary:

```json
{
  "mcpServers": {
    "sqlcl": {
      "command": "/path/to/sqlcl/bin/sql",
      "args": ["-R", "1", "-mcp"],
      "env": {}
    }
  }
}
```

| OS      | Typical path                              |
|---------|-------------------------------------------|
| Windows | `C:\\Users\\<you>\\Oracle\\sqlcl\\bin\\sql` |
| macOS   | `/usr/local/bin/sql` or `~/Oracle/sqlcl/bin/sql` |
| Linux   | `/opt/sqlcl/bin/sql` or `~/sqlcl/bin/sql` |

The `-R 1` flag sets the SQLcl restriction level (1 = least restrictive). Adjust to your security requirements (`-R 4` is most restrictive).

### 4. Install the skill into your project

The skill files are already in `.claude/skills/apex-component-modifier/` which is the standard Claude Code project skills directory. When you open this project in Claude Code, the skill is automatically available.

**To install the skill in a different project**, copy the `.claude/skills/apex-component-modifier/` folder and `.mcp.json` into that project:

```bash
# From the target project root
cp -r /path/to/apex-component-modifier/.claude/skills/apex-component-modifier .claude/skills/
cp /path/to/apex-component-modifier/.mcp.json .mcp.json
# Edit .mcp.json to set your SQLcl path
```

### 5. Verify the installation

Open Claude Code in the project directory and run:

```
/apex-component-modifier DEV 100 PAGE:1 -- Describe page 1
```

If everything is configured correctly, Claude will connect to your database via SQLcl MCP and begin the export/analysis workflow.

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
apex-component-modifier/
├── .claude/
│   └── skills/
│       └── apex-component-modifier/       -- Skill directory (auto-detected by Claude Code)
│           ├── SKILL.md                   -- Skill definition (workflow + instructions)
│           ├── references/apex_imp/
│           │   ├── README.md              -- Reference index & quick lookup table
│           │   ├── apex_imp.md            -- wwv_flow_imp core (import engine, ID system, file format)
│           │   ├── imp_page.md            -- Pages, regions, items, buttons, DAs, IR/IG, charts, maps, cards
│           │   ├── imp_shared.md          -- LOVs, auth, lists, templates, build options
│           │   ├── valid_values.md        -- All enumerated parameter values
│           │   ├── app_install.md         -- apex_application_install (pre-import configuration)
│           │   └── export_api.md          -- apex_export & SQLcl export commands
│           ├── templates/
│           │   ├── patch_plan.md          -- Change plan template
│           │   └── validation_checklist.md -- Post-patch validation checklist
│           └── tools/
│               ├── normalize_export_paths.md  -- Component selector → file path mapping
│               └── patching_guidelines.md     -- Safe patching strategies & rules
├── .mcp.json                              -- SQLcl MCP server configuration
├── CLAUDE.md                              -- Project instructions for Claude Code
└── README.md                              -- This file
```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `Skill apex-component-modifier cannot be used with Skill tool due to disable-model-invocation` | Set `disable-model-invocation: false` in `.claude/skills/apex-component-modifier/SKILL.md` |
| Skill not listed in Claude Code | Ensure the `SKILL.md` file is in `.claude/skills/apex-component-modifier/` (not `skills/`) |
| SQLcl MCP server not connecting | Verify the `command` path in `.mcp.json` points to your actual `sql` binary |
| `No saved connection found` | Create one with `conn -save <alias> -savepwd` inside SQLcl |
| Java version errors | SQLcl 25.2+ requires Java 17 or 21 — check with `java -version` |
