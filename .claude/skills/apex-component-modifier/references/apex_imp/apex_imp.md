# WWV_FLOW_IMP — Core Import Infrastructure

Source: APEX 24.2 (`APEX_240200`). Frozen as of APEX 21.2 — new components use `wwv_flow_imp_page` and `wwv_flow_imp_shared`.

## Table of Contents

- [1. Package Overview](#1-package-overview) — package info, successor packages
- [2. Constants](#2-constants) — version constants, other constants
- [3. Global Variables](#3-global-variables) — `g_id_offset`, `g_mode`, `g_raise_errors`
- [4. Key Functions and Procedures](#4-key-functions-and-procedures) — `id()`, `set_version`, `import_begin`/`import_end`, `component_begin`/`component_end`, import modes
- [5. Split Export Directory Structure](#5-split-export-directory-structure) — full directory layout, page file naming
- [6. File Format Rules](#6-file-format-rules) — block structure, component ordering, manifest block, long strings, escaping
- [7. ID Management](#7-id-management) — export file patching IDs, programmatic creation IDs
- [8. Current Context Functions (`wwv_flow_imp_page`)](#8-current-context-functions-wwv_flow_imp_page) — `current_page_id`, `current_region_id`, `current_worksheet_id`
- [9. Execution Context Requirements](#9-execution-context-requirements) — workspace/application context setup

---

## 1. Package Overview

| Property | Value |
|----------|-------|
| Package | `WWV_FLOW_IMP` |
| Schema | `APEX_240200` |
| Purpose | Interface to create APEX attributes; core import engine |
| Status | **Frozen as of 21.2** — use `WWV_FLOW_IMP_PAGE` / `WWV_FLOW_IMP_SHARED` for new components |

### Successor packages

| Package | Purpose |
|---------|---------|
| `WWV_FLOW_IMP_PAGE` | Page and page component import (active) |
| `WWV_FLOW_IMP_SHARED` | Shared component import (active) |
| `WWV_IMP_WORKSPACE` | Workspace-level component import (active) |

---

## 2. Constants

### Version Constants

| Constant | Value | Description |
|----------|-------|-------------|
| `c_current` | `20241130` | Current APEX version |
| `c_release_date_str` | `'2024.11.30'` | Release date string |
| `c_apex_4_0` | `20100513` | APEX 4.0 |
| `c_apex_5_0` | `20130101` | APEX 5.0 |
| `c_apex_18_1` | `20180404` | APEX 18.1 |
| `c_apex_19_1` | `20190331` | APEX 19.1 |
| `c_apex_20_1` | `20200331` | APEX 20.1 |
| `c_apex_21_1` | `20210415` | APEX 21.1 |
| `c_apex_21_2` | `20211015` | APEX 21.2 |
| `c_apex_22_1` | `20220412` | APEX 22.1 |
| `c_apex_22_2` | `20221007` | APEX 22.2 |
| `c_apex_23_1` | `20230428` | APEX 23.1 |
| `c_apex_23_2` | `20231031` | APEX 23.2 |
| `c_apex_24_1` | `20240531` | APEX 24.1 |
| `c_apex_24_2` | `c_current` | APEX 24.2 (current) |

### Other Constants

| Constant | Value | Description |
|----------|-------|-------------|
| `c_default_query_row_count_max` | `500` | Default max rows per query |
| `c_y` / `c_n` | `'Y'` / `'N'` | Yes/No flags |

---

## 3. Global Variables

| Variable | Type | Description |
|----------|------|-------------|
| `g_id_offset` | `NUMBER` | ID offset applied by `id()` |
| `g_mode` | `VARCHAR2` | Import mode: `'CREATE'`, `'REMOVE'`, `'REPLACE'` |
| `g_raise_errors` | `BOOLEAN` | Raise errors flag |
| `g_is_compatable` | `BOOLEAN` | Version compatibility flag |
| `g_nls_numeric_chars` | `VARCHAR2` | NLS numeric characters |

---

## 4. Key Functions and Procedures

### 4.1 `id()` — ID Offset Function

```sql
function id(p_id in number) return number;
```

Returns `p_id + g_id_offset`. Every component ID in export files is wrapped with this function.

**Critical rules:**
- IDs in export files are "raw" (pre-offset) — only need to be unique within the export
- All cross-references must use matching raw IDs wrapped in `wwv_flow_imp.id()`
- `g_id_offset` is set by `p_default_id_offset` in `import_begin` or `component_begin`

### 4.2 `set_version`

```sql
procedure set_version(
    p_version_yyyy_mm_dd in varchar2,
    p_release            in varchar2 default null,
    p_debug              in varchar2 default 'YES');
```

Sets the import version for compatibility checking.

### 4.3 `import_begin` / `import_end` — Full Application Import

```sql
begin
    wwv_flow_imp.import_begin(
        p_version_yyyy_mm_dd     => '2024.11.30',
        p_release                => '24.2.0',
        p_default_workspace_id   => <workspace_id>,
        p_default_application_id => <app_id>,
        p_default_id_offset      => 0,
        p_default_owner          => '<schema_name>'
    );
    -- Create pages and components...
    wwv_flow_imp.import_end(
        p_auto_install_sup_obj => false,
        p_is_component_import  => false
    );
    commit;
end;
/
```

**What `import_begin` does:**
1. Sets `G_IMPORT_MODE` to `C_IMPORT_MODE_APP_BEGIN`
2. Clears Interactive Grid globals
3. Calls `component_begin` internally
4. Sets `G_IMPORT_MODE` to `C_IMPORT_MODE_APP`

**What `import_end` does:**
1. Migrates translations and shared query statements
2. Writes credential and remote server collections
3. Updates duplicate page aliases
4. Restores NLS settings
5. Resets import flags

### 4.4 `component_begin` / `component_end` — Component Import

For partial/component imports (e.g., single page):

```sql
begin
    wwv_flow_imp.component_begin(
        p_version_yyyy_mm_dd     => '2024.11.30',
        p_release                => '24.2.0',
        p_default_workspace_id   => <workspace_id>,
        p_default_application_id => <app_id>,
        p_default_id_offset      => <offset>,
        p_default_owner          => '<schema_name>'
    );
    -- Create/update components...
    wwv_flow_imp.component_end(
        p_auto_install_sup_obj => false,
        p_is_component_import  => true
    );
    commit;
end;
/
```

**What `component_begin` does:**
1. Sets `G_MODE` based on import type (`'CREATE'` for new apps, `'REPLACE'` for component imports)
2. Sets security context (`wwv_flow_security.g_security_group_id`)
3. Sets application context (`wwv_flow.g_flow_id`)
4. Configures NLS settings
5. Calculates ID offsets

### 4.5 Import Modes

| Mode | Constant | `G_MODE` | Behavior |
|------|----------|----------|----------|
| Component Import | `C_IMPORT_MODE_COMPONENT` | `'REPLACE'` | Replaces existing components |
| Application Begin | `C_IMPORT_MODE_APP_BEGIN` | `'CREATE'` | Creates new components |
| Application Import | `C_IMPORT_MODE_APP` | — | Normal import in progress |
| Application End | `C_IMPORT_MODE_APP_END` | — | Finalizing import |

### 4.6 `import_begin` / `component_begin` Parameters

| Parameter | Description |
|-----------|-------------|
| `p_version_yyyy_mm_dd` | APEX version date: `'YYYY.MM.DD'` (e.g., `'2024.11.30'`) |
| `p_release` | APEX release number (e.g., `'24.2.0'`) |
| `p_default_workspace_id` | Target workspace numeric ID |
| `p_default_application_id` | Target application ID |
| `p_default_id_offset` | Offset added to all component IDs via `id()` |
| `p_default_owner` | Parsing schema name |

---

## 5. Split Export Directory Structure

```
f<APP_ID>/
  install.sql                        -- master install script (full export)
  install_component.sql              -- partial/component export install
  application/
    set_environment.sql              -- import_begin call
    delete_application.sql           -- drops existing app before import
    create_application.sql           -- creates the application shell
    end_environment.sql              -- import_end call
    pages/
      page_00000.sql                 -- Global Page (Page 0)
      page_00001.sql                 -- Page 1
      page_00010.sql                 -- Page 10 (zero-padded to 5 digits)
      page_groups.sql
    shared_components/
      logic/
        application_items.sql
        application_computations.sql
        application_processes.sql
        application_settings.sql
        build_options.sql
      navigation/
        lists/
          <list_name>.sql
        breadcrumbs/
          breadcrumb.sql
      security/
        authentication/
          authentication.sql
        authorizations/
          <auth_scheme_name>.sql
      user_interface/
        lovs/
          <lov_name>.sql
        shortcuts/
          <shortcut_name>.sql
        templates/
          region/ | page/ | button/ | label/ | list/ | report/ | ...
        themes/
          theme_<n>.sql
      plugins/
        <plugin_type>_<plugin_name>.sql
      globalization/
        messages.sql
      web_sources/
        <web_source_name>.sql
    comments.sql
    supporting_objects/
      install.sql
      database_objects/
      grant/
      data/
```

**Page file naming:** zero-padded to 5 digits — `page_%05d.sql`.

---

## 6. File Format Rules

### 6.1 Block structure

Every procedure call is wrapped in `begin...end;` terminated by `/`:

```sql
begin
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12345)
,p_name=>'P10_ITEM'
...
);
end;
/
```

### 6.2 Component ordering within a page file

1. Manifest comment block (with `null;`)
2. `create_page` — page definition
3. `create_page_plug` — regions (by `p_plug_display_sequence`)
4. Report/worksheet columns (IR) or region columns (IG)
5. `create_page_button` — buttons
6. `create_page_branch` — branches
7. `create_page_item` — page items
8. `create_page_computation` — computations
9. `create_page_validation` — validations
10. `create_page_da_event` + `create_page_da_action` — dynamic actions
11. `create_page_process` — processes

### 6.3 Component hierarchy (creation order)

```
Application
└── Page (create_page)
    ├── Page Group (create_page_group)
    ├── Regions (create_page_plug)
    │   ├── Region Columns (create_region_column) [IG/Cards]
    │   ├── Report Columns (create_report_columns) [Classic Report]
    │   ├── Interactive Grid (create_interactive_grid)
    │   │   ├── IG Report (create_ig_report)
    │   │   │   ├── IG Report View (create_ig_report_view)
    │   │   │   ├── IG Report Column (create_ig_report_column)
    │   │   │   ├── IG Report Filter (create_ig_report_filter)
    │   │   │   └── IG Report Highlight (create_ig_report_highlight)
    │   ├── Worksheet/IR (create_worksheet)
    │   │   ├── Worksheet Column (create_worksheet_column)
    │   │   └── Worksheet Report (create_worksheet_rpt)
    │   ├── JET Chart (create_jet_chart)
    │   │   ├── Chart Axis (create_jet_chart_axis)
    │   │   └── Chart Series (create_jet_chart_series)
    │   ├── Map Region (create_map_region)
    │   │   └── Map Layer (create_map_region_layer)
    │   └── Cards (create_card)
    │       └── Card Action (create_card_action)
    ├── Page Items (create_page_item)
    ├── Buttons (create_page_button)
    ├── Processes (create_page_process)
    ├── Validations (create_page_validation)
    ├── Computations (create_page_computation)
    ├── Branches (create_page_branch)
    └── Dynamic Actions
        ├── DA Event (create_page_da_event)
        └── DA Action (create_page_da_action)
```

### 6.4 Manifest block

```sql
prompt --application/pages/page_00010
begin
--   Manifest
--   PAGE: Page 10
--   REGION: Region Name
--   PAGE ITEM: P10_ITEM
--   BUTTON: BTN_SUBMIT
null;
end;
/
```

### 6.5 Long strings

```sql
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select e.empno,',
'       e.ename',
'  from emp e'))
```

### 6.6 String escaping

Single quotes doubled: `'Employee''s name'`

### 6.7 `set define off`

Always at top of export files. Prevents `&` substitution.

### 6.8 `prompt` directives

```sql
prompt --application/pages/page_00010
```

In `install.sql`:
```sql
prompt --install/pages/page_00010
@@application/pages/page_00010.sql
```

### 6.9 Component file wrapper (split exports)

```sql
-- top of component file
begin
wwv_flow_imp.component_begin(
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.0'
,p_default_workspace_id=>...
,p_default_application_id=>...
,p_default_id_offset=>...
,p_default_owner=>'...'
);
end;
/

-- ... all create_* calls ...

begin
wwv_flow_imp.component_end;
end;
/
```

---

## 7. ID Management

### For export file patching

1. **Scan existing IDs** — collect all values inside `wwv_flow_imp.id(...)` in the file
2. **Pick new IDs** — find max existing ID + 1 (or +100 for spacing)
3. **Never use random IDs** — collision risk after offset
4. **Cross-references must match** — e.g., `p_item_plug_id` must use the same raw ID as the region's `p_id`

### IDs NOT wrapped in `wwv_flow_imp.id()`

- `p_id` in `create_page` — raw page number
- `p_internal_uid` in some process calls

### For programmatic creation (AI Builder)

- Use `wwv_flow_id.next_val` for auto-generated unique IDs
- Or pass `null` for `p_id` to auto-generate

---

## 8. Current Context Functions (`wwv_flow_imp_page`)

| Function | Returns | Use |
|----------|---------|-----|
| `current_page_id` | Last created page ID | Default for `p_page_id` parameters |
| `current_region_id` | Last created region ID | Default for `p_region_id`, `p_plug_id` |
| `current_worksheet_id` | Last created worksheet ID | Default for IR column/report creation |

---

## 9. Execution Context Requirements

Before calling any import procedure:

```sql
-- 1. Set workspace context (required)
wwv_flow_security.g_security_group_id := <workspace_id>;

-- 2. Set application context (required)
wwv_flow.g_flow_id := <application_id>;

-- 3. Set calling version (recommended)
wwv_flow_imp_page.set_calling_version(wwv_flow_imp.c_apex_24_2);
```

Or use `import_begin`/`component_begin` which sets all of these automatically.
