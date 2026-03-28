# Component: List of Values (LOV)

Shared LOVs live in `shared_components/user_interface/lovs/`. They define reusable value lists referenced by page items (`p_lov_id`), IG columns, and IR filter LOVs.

## API Calls (ordered)

1. `wwv_flow_imp_shared.create_list_of_values(...)` — defines the LOV header
2. `wwv_flow_imp_shared.create_list_of_values_cols(...)` — column metadata (SQL/TABLE LOVs with extra columns only)
3. `wwv_flow_imp_shared.create_static_lov_data(...)` — static entries (STATIC LOVs only)

## Required Parameters — `create_list_of_values`

| Parameter | Type | Description |
|-----------|------|-------------|
| `p_id` | ID | Unique LOV ID via `wwv_flow_imp.id()` |
| `p_lov_name` | VARCHAR2 | LOV display name (uppercase by convention) |
| `p_location` | VARCHAR2 | `'STATIC'` or `'LOCAL'` |

### Additional required parameters by location

**STATIC LOVs** — `p_lov_query` is a self-referencing marker:
```
,p_lov_query=>'.'||wwv_flow_imp.id(<same_id>)||'.'
```

**LOCAL (dynamic) LOVs** — must include `p_source_type` plus query or table parameters (see variations below).

## Common Optional Parameters — `create_list_of_values`

| Parameter | Type | Observed Values | Notes |
|-----------|------|-----------------|-------|
| `p_source_type` | VARCHAR2 | `'LEGACY_SQL'`, `'SQL'`, `'TABLE'` | Required for LOCAL LOVs |
| `p_lov_query` | VARCHAR2/CLOB | SQL text or static marker | Use `wwv_flow_string.join()` for multiline SQL |
| `p_query_table` | VARCHAR2 | Table/view name | TABLE source type only |
| `p_return_column_name` | VARCHAR2 | Column name for return value | SQL/TABLE LOVs |
| `p_display_column_name` | VARCHAR2 | Column name for display value | SQL/TABLE LOVs |
| `p_query_owner` | VARCHAR2 | Schema name | Optional schema qualifier |
| `p_use_local_sync_table` | BOOLEAN | `false` | SQL LOVs — controls caching |
| `p_default_sort_column_name` | VARCHAR2 | Column name | TABLE LOVs |
| `p_default_sort_direction` | VARCHAR2 | `'ASC'` | Sort direction |
| `p_group_sort_direction` | VARCHAR2 | `'ASC'` | Group sort direction |
| `p_version_scn` | NUMBER | SCN value | Export metadata |

## Variations

### Variation A: Static LOV

Static LOVs use `p_location=>'STATIC'` with inline display/return value pairs. No SQL query needed.

```sql
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(16087692643833851302)
,p_lov_name=>'YES NO  (Y/N)'
,p_lov_query=>'.'||wwv_flow_imp.id(16087692643833851302)||'.'
,p_location=>'STATIC'
,p_version_scn=>1089050995
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(16087692949653851308)
,p_lov_disp_sequence=>10
,p_lov_disp_value=>'Yes'
,p_lov_return_value=>'Y'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(16087693150282851313)
,p_lov_disp_sequence=>20
,p_lov_disp_value=>'No'
,p_lov_return_value=>'N'
);
```

**`create_static_lov_data` parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `p_id` | ID | Unique entry ID |
| `p_lov_disp_sequence` | NUMBER | Display order (10, 20, 30…) |
| `p_lov_disp_value` | VARCHAR2 | Label shown to user |
| `p_lov_return_value` | VARCHAR2 | Value stored/submitted |

### Variation B: Dynamic SQL LOV (LEGACY_SQL)

Older-style SQL LOV. The query returns two columns aliased `d` (display) and `r` (return). No column metadata needed.

```sql
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(38802034438236186353)
,p_lov_name=>'ITEMS'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select item_name d, id r',
'from   OOW_DEMO_items ',
'order by 1'))
,p_source_type=>'LEGACY_SQL'
,p_location=>'LOCAL'
,p_version_scn=>37167692709758
);
```

### Variation C: Dynamic SQL LOV (SQL with named columns)

Modern SQL LOV with explicitly named return/display columns. Often paired with `create_list_of_values_cols`.

```sql
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(41209984734073518204)
,p_lov_name=>'DESKTOP THEME STYLES'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select s.name d,',
'       s.theme_style_id r',
'  from apex_application_theme_styles s,',
'       apex_application_themes t',
' where s.application_id = :app_id',
'   and t.application_id = s.application_id',
'   and t.theme_number   = s.theme_number',
'   and t.is_current     = ''Yes''',
' order by 1'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'R'
,p_display_column_name=>'D'
,p_version_scn=>37167692709758
);
```

### Variation D: TABLE Source LOV

Declarative table-based LOV — no SQL query, just table/column names.

```sql
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(27766945393426959531)
,p_lov_name=>'OOW_DEMO_STORES.STORE_NAME'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_query_table=>'OOW_DEMO_STORES'
,p_return_column_name=>'ID'
,p_display_column_name=>'STORE_NAME'
,p_default_sort_column_name=>'STORE_NAME'
,p_default_sort_direction=>'ASC'
,p_version_scn=>37167692709758
);
```

### Variation E: SQL LOV with Extra Columns (Popup LOV)

SQL LOVs can define additional visible/searchable columns for popup LOV display using `create_list_of_values_cols`.

```sql
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(23219133083924274)
,p_lov_name=>'EMPLOYEE_POPUP_LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ename as employee,',
'       empno as return_value,',
'       sal   as old_salary',
'  from eba_demo_rest_employee',
' order by ename',
''))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'RETURN_VALUE'
,p_display_column_name=>'EMPLOYEE'
,p_group_sort_direction=>'ASC'
,p_default_sort_direction=>'ASC'
,p_version_scn=>21437050
);
wwv_flow_imp_shared.create_list_of_values_cols(
 p_id=>wwv_flow_imp.id(23220168014928296)
,p_query_column_name=>'EMPLOYEE'
,p_heading=>'Employee'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
);
wwv_flow_imp_shared.create_list_of_values_cols(
 p_id=>wwv_flow_imp.id(23219755288928296)
,p_query_column_name=>'OLD_SALARY'
,p_heading=>'Old Salary'
,p_display_sequence=>20
,p_data_type=>'NUMBER'
);
wwv_flow_imp_shared.create_list_of_values_cols(
 p_id=>wwv_flow_imp.id(23220604103928296)
,p_query_column_name=>'RETURN_VALUE'
,p_display_sequence=>30
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
```

**`create_list_of_values_cols` parameters:**

| Parameter | Type | Observed Values | Description |
|-----------|------|-----------------|-------------|
| `p_id` | ID | | Unique column ID |
| `p_query_column_name` | VARCHAR2 | | Column alias from SQL query |
| `p_heading` | VARCHAR2 | | Column heading in popup |
| `p_display_sequence` | NUMBER | 10, 20, 30… | Column display order |
| `p_data_type` | VARCHAR2 | `'VARCHAR2'`, `'NUMBER'`, `'CLOB'` | Column data type |
| `p_is_visible` | VARCHAR2 | `'Y'` (default), `'N'` | Show column in popup |
| `p_is_searchable` | VARCHAR2 | `'Y'` (default), `'N'` | Include in type-ahead search |
| `p_format_mask` | VARCHAR2 | e.g. `'mon-yyyy'` | Display format |

## Parameter Value Catalog

| Parameter | All Observed Values |
|-----------|-------------------|
| `p_location` | `'STATIC'` (139), `'LOCAL'` (186) |
| `p_source_type` | `'LEGACY_SQL'` (136), `'SQL'` (30), `'TABLE'` (20) |
| `p_default_sort_direction` | `'ASC'` |
| `p_group_sort_direction` | `'ASC'` |
| `p_use_local_sync_table` | `false` |
| `p_data_type` (cols) | `'VARCHAR2'`, `'NUMBER'`, `'CLOB'` |

## Relationships

- **Used by**: page items (`p_lov_id`), IG columns (`p_lov_id`), IR filter LOVs
- **File location**: `shared_components/user_interface/lovs/<lov_name>.sql`
- **Wrapped by**: `wwv_flow_imp.component_begin` / `component_end`
