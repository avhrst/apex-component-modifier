# APEX Commands Reference (run-sqlcl)

All commands in this file use the `run-sqlcl` MCP tool.

## APEX Version

```
apex version
```

Returns APEX version installed on the database.

## APEX List

List components in an application:

```
apex list -applicationid 113
```

Returns exportable component types and their IDs. Use to discover component IDs for targeted exports.

## APEX Export

### Full Application Export (split)

```
apex export -applicationid 113 -split
```

Creates a directory tree under `f113/` with separate files per component. **Always use `-split` for readable, diffable exports.**

### Full Export to Single File

```
apex export -applicationid 113
```

Produces a single `f113.sql` file. Useful for quick backup but harder to read/diff.

### Partial Export (specific components)

```
apex export -applicationid 113 -split -expComponents "PAGE:1 PAGE:2"
apex export -applicationid 113 -split -expComponents "PAGE:5 AUTHORIZATION:12345"
```

Creates partial export with only specified components. Produces `install_component.sql` instead of `install.sql`.

### Export to Specific Directory

```
apex export -applicationid 113 -split -dir /path/to/output
```

### Export Options

| Flag | Alias | Description |
|------|-------|-------------|
| `-applicationid` | `-ai` | Application ID (required) |
| `-split` | `-sp` | Split into multiple files |
| `-expComponents` | | Component selector(s): `TYPE:ID` |
| `-dir` | | Output directory |
| `-skipExportDate` | `-sked` | Exclude timestamp (cleaner diffs) |
| `-nochecksum` | `-noch` | Overwrite even if unchanged |
| `-workspaceid` | `-woi` | Workspace ID |
| `-expWorkspace` | | Export workspace definition |
| `-expMinimal` | | Minimal workspace (users, groups only) |
| `-expFiles` | | Include workspace static files |

### Component Selector Syntax

Format: `TYPE:ID`

| Type | Example | Targets |
|------|---------|---------|
| `PAGE` | `PAGE:10` | Page by page number |
| `AUTHORIZATION` | `AUTHORIZATION:12345678` | Authorization scheme by ID |
| `LOV` | `LOV:12345678` | List of Values by ID |
| `LIST` | `LIST:12345678` | Navigation list by ID |
| `PLUGIN` | `PLUGIN:12345678` | Plugin by ID |
| `TEMPLATE` | `TEMPLATE:12345678` | Template by ID |

Multiple components: space-separated in quotes: `"PAGE:1 PAGE:2 LOV:123"`

## APEX Export Aliases

| Command | Alias | Description |
|---------|-------|-------------|
| `apex export` | `apex ex` | Standard export |
| `apex export-application` | `apex exa` | Export all or parts of an app |
| `apex export-all-applications` | `apex exaa` | All apps in a workspace |
| `apex export-all-workspaces` | `apex exaw` | All workspaces |
| `apex export-components` | `apex excom` | Specific components only |
| `apex export-feedback` | `apex exf` | Workspace feedback |
| `apex export-workspace` | `apex exw` | Workspace structure (no apps) |
| `apex list` | `apex ls` | List components |
| `apex log` | `apex lo` | Application usage log |
| `apex version` | `apex ve` | APEX version |

## APEX Import

Import is done by running the exported SQL install scripts:

### Same Environment
```
@f113/install.sql                  -- full app
@f113/install_component.sql        -- partial (component export)
```

**Note:** At restriction level 4 (default MCP), `@` script execution is blocked. Use restriction level ≤ 1 for imports, or run the install script content directly via `run-sql`.

### Different Environment (pre-import config)

Before running install, set the target environment context:

```sql
-- Via run-sql
BEGIN
  apex_application_install.set_workspace_id(12345678);
  apex_application_install.set_application_id(200);
  apex_application_install.set_schema('NEW_SCHEMA');
  apex_application_install.generate_offset;
END;
```

Then run install script.

## Split Export Directory Structure

After `apex export -applicationid 113 -split`:

```
f113/
├── install.sql                    -- master install script
├── install_component.sql          -- partial install (if -expComponents)
├── application/
│   ├── create_application.sql
│   ├── set_environment.sql
│   ├── delete_application.sql
│   ├── pages/
│   │   ├── page_00000.sql         -- Global Page (Page 0)
│   │   ├── page_00001.sql         -- Page 1
│   │   └── page_groups.sql
│   ├── shared_components/
│   │   ├── security/
│   │   │   ├── authentication/
│   │   │   └── authorizations/
│   │   ├── navigation/
│   │   │   ├── lists/
│   │   │   ├── breadcrumbs/
│   │   │   └── tabs/
│   │   ├── user_interface/
│   │   │   ├── lovs/
│   │   │   ├── templates/
│   │   │   └── themes/
│   │   ├── logic/
│   │   │   ├── application_items.sql
│   │   │   ├── application_processes.sql
│   │   │   ├── application_computations.sql
│   │   │   └── build_options.sql
│   │   ├── plugins/
│   │   └── globalization/
│   └── end_environment.sql
```

## Useful APEX Dictionary Views (via run-sql)

```sql
-- All apps in workspace
SELECT application_id, application_name, pages, owner
FROM apex_applications ORDER BY application_id;

-- Pages in an app
SELECT page_id, page_name, page_mode, page_group
FROM apex_application_pages WHERE application_id = 113
ORDER BY page_id;

-- Regions on a page
SELECT region_id, region_name, source_type, template
FROM apex_application_page_regions
WHERE application_id = 113 AND page_id = 10
ORDER BY display_sequence;

-- Items on a page
SELECT item_id, item_name, display_as, region
FROM apex_application_page_items
WHERE application_id = 113 AND page_id = 10
ORDER BY display_sequence;

-- LOVs
SELECT lov_id, list_of_values_name, lov_type
FROM apex_application_lovs WHERE application_id = 113;

-- Auth schemes
SELECT authorization_scheme_id, authorization_scheme_name, scheme_type
FROM apex_application_authorization WHERE application_id = 113;

-- APEX workspace log (recent activity)
SELECT * FROM apex_workspace_log_summary
WHERE application_id = 113
ORDER BY timestamp_tz DESC FETCH FIRST 20 ROWS ONLY;
```
