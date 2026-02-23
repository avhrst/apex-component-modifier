# Oracle APEX Component Modifier

A **Claude Code Skill** that exports an Oracle APEX component, modifies the exported files, applies DB changes, and imports the component back — using **Oracle SQLcl's MCP Server**.

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

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Skill not listed in Claude Code | Ensure `SKILL.md` is at `.claude/skills/apex-component-modifier/SKILL.md` |
| SQLcl MCP not connecting | Verify `sql` is on your PATH or use full path in `claude mcp add` |
| `No saved connection found` | Run `conn -save <alias> -savepwd` inside SQLcl |
| Java version errors | SQLcl 25.2+ requires Java 17 or 21 — check with `java -version` |
