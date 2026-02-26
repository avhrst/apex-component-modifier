# WWV_FLOW_IMP — Core Import Infrastructure

Source: APEX 24.2 (`APEX_240200`). **Frozen as of 21.2** — new components use `WWV_FLOW_IMP_PAGE` / `WWV_FLOW_IMP_SHARED`.

## Package Overview

| Package | Purpose |
|---------|---------|
| `WWV_FLOW_IMP` | Core import engine (frozen): `import_begin/end`, `component_begin/end`, `id()` |
| `WWV_FLOW_IMP_PAGE` | Page and page component import (active) |
| `WWV_FLOW_IMP_SHARED` | Shared component import (active) |
| `WWV_IMP_WORKSPACE` | Workspace-level component import (active) |

---

## Constants

### Version Constants

| Constant | Value | APEX Version |
|----------|-------|--------------|
| `c_current` / `c_apex_24_2` | `20241130` | 24.2 (current) |
| `c_apex_24_1` | `20240531` | 24.1 |
| `c_apex_23_2` | `20231031` | 23.2 |
| `c_apex_23_1` | `20230428` | 23.1 |
| `c_apex_22_2` | `20221007` | 22.2 |
| `c_apex_22_1` | `20220412` | 22.1 |
| `c_apex_21_2` | `20211015` | 21.2 |

Older: `c_apex_21_1`=20210415, `c_apex_20_1`=20200331, `c_apex_19_1`=20190331, `c_apex_18_1`=20180404, `c_apex_5_0`=20130101, `c_apex_4_0`=20100513.

`c_release_date_str` = `'2024.11.30'`, `c_default_query_row_count_max` = `500`.

---

## Global Variables

| Variable | Type | Description |
|----------|------|-------------|
| `g_id_offset` | `NUMBER` | ID offset applied by `id()` — the critical variable |
| `g_mode` | `VARCHAR2` | `'CREATE'`, `'REMOVE'`, or `'REPLACE'` |
| `g_raise_errors` | `BOOLEAN` | Raise errors flag |

---

## Key Functions and Procedures

### `id()` — ID Offset Function

```sql
function id(p_id in number) return number;
-- Returns p_id + g_id_offset
```

**Critical rules:**
- IDs in export files are "raw" (pre-offset) — only need to be unique within the export
- All cross-references must use matching raw IDs wrapped in `wwv_flow_imp.id()`
- `g_id_offset` is set by `p_default_id_offset` in `import_begin` or `component_begin`

### `import_begin` / `component_begin` — Import Context Setup

Both accept the same parameters and set workspace, app, NLS, and ID offset context:

| Parameter | Description |
|-----------|-------------|
| `p_version_yyyy_mm_dd` | APEX version date: `'2024.11.30'` |
| `p_release` | APEX release: `'24.2.0'` |
| `p_default_workspace_id` | Target workspace numeric ID |
| `p_default_application_id` | Target application ID |
| `p_default_id_offset` | Offset added to all component IDs via `id()` |
| `p_default_owner` | Parsing schema name |

**Difference:** `import_begin` is for full app imports (`G_MODE='CREATE'`). `component_begin` is for partial/component imports (`G_MODE='REPLACE'`).

**Full app import:**
```sql
begin
    wwv_flow_imp.import_begin(
        p_version_yyyy_mm_dd=>'2024.11.30', p_release=>'24.2.0',
        p_default_workspace_id=><ws_id>, p_default_application_id=><app_id>,
        p_default_id_offset=>0, p_default_owner=>'<schema>');
end;
/
-- ... create_* calls ...
begin
    wwv_flow_imp.import_end(p_auto_install_sup_obj=>false, p_is_component_import=>false);
    commit;
end;
/
```

**Component import (partial):**
```sql
begin
    wwv_flow_imp.component_begin(
        p_version_yyyy_mm_dd=>'2024.11.30', p_release=>'24.2.0',
        p_default_workspace_id=><ws_id>, p_default_application_id=><app_id>,
        p_default_id_offset=><offset>, p_default_owner=>'<schema>');
end;
/
-- ... create_* calls ...
begin
    wwv_flow_imp.component_end(p_auto_install_sup_obj=>false, p_is_component_import=>true);
    commit;
end;
/
```

### Import Modes

| Mode | `G_MODE` | Behavior |
|------|----------|----------|
| `C_IMPORT_MODE_COMPONENT` | `'REPLACE'` | Replaces existing components |
| `C_IMPORT_MODE_APP_BEGIN` | `'CREATE'` | Creates new components |

---

## Split Export Directory Structure

```
f<APP_ID>/
  install.sql                        -- master install (full export)
  install_component.sql              -- partial/component install
  application/
    set_environment.sql              -- import_begin call
    delete_application.sql           -- drops existing app
    create_application.sql           -- creates app shell
    end_environment.sql              -- import_end call
    pages/
      page_00000.sql                 -- Global Page (Page 0)
      page_00001.sql                 -- page files zero-padded to 5 digits
    shared_components/
      logic/                         -- application_items, computations, processes, settings, build_options
      navigation/lists/ | breadcrumbs/
      security/authentication/ | authorizations/
      user_interface/lovs/ | shortcuts/ | templates/{region,page,button,label,list,report}/ | themes/
      plugins/
      globalization/messages.sql
      web_sources/
    supporting_objects/install.sql | database_objects/ | grant/ | data/
```

---

## File Format Rules

### Block structure

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

### Component ordering within a page file

1. Manifest comment block (with `null;`)
2. `create_page`
3. `create_page_plug` — regions (by sequence)
4. Report/worksheet columns (IR) or region columns (IG)
5. `create_page_button`
6. `create_page_branch`
7. `create_page_item`
8. `create_page_computation`
9. `create_page_validation`
10. `create_page_da_event` + `create_page_da_action`
11. `create_page_process`

### Component hierarchy

```
Page (create_page)
├── Regions (create_page_plug)
│   ├── Region Columns [IG/Cards] | Report Columns [Classic]
│   ├── Interactive Grid → IG Report → IG Report View → IG Report Column
│   ├── Worksheet/IR → Worksheet Column → Worksheet Report
│   ├── JET Chart → Chart Axis + Chart Series
│   ├── Map Region → Map Layer
│   └── Cards → Card Action
├── Page Items, Buttons, Processes, Validations, Computations, Branches
└── Dynamic Actions (DA Event → DA Action)
```

### Manifest block

```sql
prompt --application/pages/page_00010
begin
--   Manifest
--   PAGE: Page 10
--   REGION: Region Name
--   PAGE ITEM: P10_ITEM
null;
end;
/
```

### Long strings

```sql
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select e.empno,',
'       e.ename',
'  from emp e'))
```

### Other rules

- String escaping: single quotes doubled (`'Employee''s name'`)
- `set define off` always at top (prevents `&` substitution)
- `prompt` directives: `prompt --application/pages/page_00010`
- Component files wrapped in `component_begin`/`component_end`

---

## ID Management

### For export file patching

1. **Scan existing IDs** — collect all values inside `wwv_flow_imp.id(...)` in the file
2. **Pick new IDs** — find max existing ID + 1 (or +100 for spacing)
3. **Never use random IDs** — collision risk after offset
4. **Cross-references must match** — e.g., `p_item_plug_id` must use the same raw ID as the region's `p_id`

### IDs NOT wrapped in `wwv_flow_imp.id()`

- `p_id` in `create_page` — raw page number
- `p_internal_uid` in some process calls

### For programmatic creation

Use `wwv_flow_id.next_val` or pass `null` for `p_id` to auto-generate.

---

## Current Context Functions (`wwv_flow_imp_page`)

| Function | Returns | Default for |
|----------|---------|-------------|
| `current_page_id` | Last created page ID | `p_page_id` params |
| `current_region_id` | Last created region ID | `p_region_id`, `p_plug_id` params |
| `current_worksheet_id` | Last created worksheet ID | IR column/report creation |

---

## Execution Context

Before calling import procedures, either use `import_begin`/`component_begin` (which sets everything automatically) or manually set:

```sql
wwv_flow_security.g_security_group_id := <workspace_id>;
wwv_flow.g_flow_id := <application_id>;
wwv_flow_imp_page.set_calling_version(wwv_flow_imp.c_apex_24_2);
```
