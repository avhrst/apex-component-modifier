---
description: Learn patterns from an existing APEX app — exports all components, analyzes them, and generates annotated pattern files for future patching
argument-hint: "[app-id]"
---

Learn the patterns of APEX application `$ARGUMENTS` (or `$APEX_APP_ID` if no argument given) by exporting and analyzing all its components. Generate annotated markdown pattern files that capture the app's conventions.

**Output directory:** `.claude/skills/apex-component-modifier/app-patterns/`

## Workflow

### 1. Connect and export

1. Connect to the database using `$SQLCL_CONNECTION`.
2. Determine the app ID: use `$ARGUMENTS` if provided, otherwise `$APEX_APP_ID`.
3. Run a full split export: `apex export -applicationid <APP_ID> -split`.
4. Confirm the export directory exists and list its contents.

### 2. Discover exported files

1. Find all page files: `application/pages/page_*.sql`
2. Find shared component files: `application/shared_components/**/*.sql`
3. Find the application-level files: `application/set_environment.sql`, `application/create_application.sql`
4. Report how many pages and shared component files were found.

### 3. Generate page pattern files

For **each page file**, read the full SQL and produce a markdown file named `page_NNNNN.md` in the `app-patterns/` directory. Each file must contain:

#### Header
```
# Page <N> — <Page Name>

**Mode:** <mode> | **Alias:** <alias> | **Group:** <group>
```

#### Regions table
| # | Name | Type | Template | Source | Seq |
|---|------|------|----------|--------|-----|

Extract from `wwv_flow_imp_page.create_page_plug(...)` calls:
- Name: `p_plug_name`
- Type: `p_plug_source_type` (e.g., `NATIVE_SQL_REPORT`, `NATIVE_FORM`)
- Template: `p_plug_template` — resolve the `wwv_flow_imp.id(...)` value and note the template name from context if available
- Source: `p_plug_source` or `p_query_table_name` or `p_region_source`
- Seq: `p_display_sequence`

#### Items table
| Name | Type | Region | Source Column | Display As | Template |
|------|------|--------|--------------|------------|----------|

Extract from `wwv_flow_imp_page.create_page_item(...)` calls:
- Name: `p_name`
- Type: `p_data_type`
- Region: `p_item_plug_id` — cross-reference to region name
- Source Column: `p_source` or `p_source_data_type` context
- Display As: `p_display_as` (e.g., `NATIVE_TEXT_FIELD`, `NATIVE_SELECT_LIST`)
- Template: `p_field_template` — note the `wwv_flow_imp.id(...)` value

#### Buttons table
| Name | Region | Action | Position | Seq |
|------|--------|--------|----------|-----|

Extract from `wwv_flow_imp_page.create_page_button(...)` calls.

#### Processes table
| Name | Type | Point | Seq | Condition |
|------|------|-------|-----|-----------|

Extract from `wwv_flow_imp_page.create_page_process(...)` calls.

#### Dynamic Actions table
| Event | Name | Condition | Actions |
|-------|------|-----------|---------|

Extract from `wwv_flow_imp_page.create_page_da_event(...)` and related `create_page_da_action(...)` calls.

#### Validations, Computations, Branches
Include these sections only if the page has them. Use similar tabular format.

#### Key Patterns section
Summarize the reusable conventions found on this page:
- Label template IDs with their resolved names (e.g., `wwv_flow_imp.id(1859094942498559411)` = "Optional - Floating")
- Region template IDs with names
- Item naming convention (e.g., `P<page>_<COLUMN_NAME>`)
- Sequence gap pattern (e.g., increments of 10)
- Any page-specific LOV references

#### Representative SQL Blocks
Include 1-2 representative `wwv_flow_imp_page.create_*` blocks verbatim (the most complex region and one item) so future patching can copy the exact style. Wrap in fenced SQL code blocks with a heading like `### Region: <name>`.

### 4. Generate shared_components.md

Read all files under `application/shared_components/` and produce a single `shared_components.md` in `app-patterns/`:

#### LOVs
| Name | Type | Query/Static Values (truncated) |
|------|------|---------------------------------|

#### Authorization Schemes
| Name | Scheme Type | Description |
|------|-------------|-------------|

#### Templates in Use
List region templates, label templates, button templates, and page templates found in the export — just the IDs and names:
| Category | ID (`wwv_flow_imp.id(...)`) | Name |
|----------|-----------------------------|------|

#### Authentication Scheme
Note the scheme name and type.

#### Navigation
Lists, breadcrumbs, navbar entries — name and target.

### 5. Generate catalog.md

Create `catalog.md` in `app-patterns/` as the master index:

```
# App Patterns Catalog — App <APP_ID>

**Generated:** <today's date> | **App:** <APP_ID> | **Workspace:** $APEX_WORKSPACE

## Pages

| File | Page | Name | Regions | Items | Buttons | Processes | DAs |
|------|------|------|---------|-------|---------|-----------|-----|
| page_00001.md | 1 | Home | 3 | 0 | 0 | 1 | 0 |
...

## Shared Components

| File | Contents |
|------|----------|
| shared_components.md | LOVs, auth schemes, templates, navigation |

## Common Patterns

Summarize the most frequently occurring patterns across all pages:
- Most common label template (ID + name)
- Most common region template (ID + name)
- Item naming convention
- Sequence numbering style
- Common LOV references
```

### 6. Report

Print a summary:
- Number of page pattern files generated
- Whether shared_components.md was generated
- Path to catalog.md
- Any pages that could not be parsed (with reason)

## Important rules

- This is a **read-only analysis** — do NOT modify any APEX components or database objects.
- Do NOT import anything back into APEX.
- Overwrite any previously generated pattern files in `app-patterns/` (treat each run as a fresh snapshot).
- If a page file is too large to read in one pass, read it in chunks.
- If the export fails, report the error and stop — do not attempt to generate patterns from stale/missing files.
- Clean up the export directory after pattern generation is complete.
