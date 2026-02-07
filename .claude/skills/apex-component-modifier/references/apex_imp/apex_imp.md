# APEX Import Packages — Complete Reference

Reference for the internal Oracle APEX import packages used in export files.
Applies to APEX 22.1+ with the `wwv_flow_imp*` package naming (older versions used `wwv_flow_api`).

---

## 1. Package Overview

| Package | Purpose |
|---------|---------|
| `wwv_flow_imp` | Core import engine: `import_begin`, `import_end`, `component_begin`, `component_end`, `id()` function |
| `wwv_flow_imp_page` | Page-level components: pages, regions, items, buttons, processes, dynamic actions, validations, computations, branches |
| `wwv_flow_imp_shared` | Shared/application-level components: LOVs, lists, auth schemes, authorization schemes, templates, shortcuts, plugins, web sources |
| `wwv_flow_string` | String utility: `join()` for concatenating `wwv_flow_t_varchar2` collections |
| `apex_application_install` | Pre-import configuration: `set_workspace_id`, `set_application_id`, `set_schema`, `generate_offset` |

---

## 2. Core Import Infrastructure (`wwv_flow_imp`)

### 2.1 `import_begin` — Initialize Full Import

Called once at the top of a full (non-split) export or in the `set_environment.sql` of a split export.

```sql
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2024.06.15'
,p_release=>'24.1.0'
,p_default_workspace_id=>9876543210
,p_default_application_id=>100
,p_default_id_offset=>33344455566677788
,p_default_owner=>'MYSCHEMA'
);
end;
/
```

| Parameter | Description |
|-----------|-------------|
| `p_version_yyyy_mm_dd` | APEX patch date of the exporting instance |
| `p_release` | APEX version string (e.g., `'24.1.0'`) |
| `p_default_workspace_id` | Source workspace numeric ID |
| `p_default_application_id` | Application ID |
| `p_default_id_offset` | ID offset applied by `wwv_flow_imp.id()` |
| `p_default_owner` | Parsing schema |

### 2.2 `component_begin` / `component_end` — Component Scope

In split exports, each component file is wrapped with these calls to establish/finalize component context:

```sql
-- Top of component file
begin
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.06.15'
,p_release=>'24.1.0'
,p_default_workspace_id=>9876543210
,p_default_application_id=>100
,p_default_id_offset=>33344455566677788
,p_default_owner=>'MYSCHEMA'
);
end;
/

-- ... component create_* calls ...

-- Bottom of component file
begin
wwv_flow_imp.component_end;
end;
/
```

### 2.3 `id()` — ID Offset Function

Every component ID in export files is wrapped with `wwv_flow_imp.id()`:

```sql
,p_id=>wwv_flow_imp.id(45678901234567890)
```

At import time: `id(N)` returns `N + g_id_offset`.

**Critical rules:**
- IDs in the export are "raw" (pre-offset) — they only need to be unique within the export
- All cross-references between components must use matching raw IDs wrapped in `wwv_flow_imp.id()`
- When adding new components, pick IDs that don't collide with existing ones in the same export
- The offset is set by `p_default_id_offset` in `import_begin` or `component_begin`

---

## 3. Split Export Directory Structure

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
        tabs/
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
          region/
          page/
          button/
          label/
          list/
          report/
          popup_lov/
          calendar/
          breadcrumb/
        themes/
          theme_<n>.sql
      plugins/
        <plugin_type>_<plugin_name>.sql
      globalization/
        messages.sql
        language_identification.sql
      web_sources/
        <web_source_name>.sql
    comments.sql
    supporting_objects/
      install.sql
      database_objects/
      grant/
      data/
```

**Page file naming:** zero-padded to 5 digits — `page_00001.sql`, `page_00010.sql`, `page_00100.sql`.

---

## 4. Page Component Procedures (`wwv_flow_imp_page`)

### 4.1 `create_page`

```sql
wwv_flow_imp_page.create_page(
 p_id=>10
,p_name=>'Employee Form'
,p_alias=>'EMP-FORM'
,p_step_title=>'Employee Form'
,p_warn_on_unsaved_changes=>'Y'
,p_first_item=>'AUTO_FIRST_ITEM'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_imp.id(98765432109876543)
,p_javascript_code_onload=>''
,p_javascript_code=>''
,p_css_inline=>''
,p_page_template_options=>'#DEFAULT#:t-PageBody--scrollLeftRight'
,p_required_role=>wwv_flow_imp.id(11111111111111111)
,p_protection_level=>'C'
,p_browser_cache=>'N'
,p_help_text=>'...'
,p_page_component_map=>'03'
,p_last_updated_by=>'ADMIN'
,p_last_upd_yyyymmddhh24miss=>'20240610153045'
);
```

Note: `p_id` uses the raw page number (not wrapped in `wwv_flow_imp.id()`).

### 4.2 `create_region`

```sql
wwv_flow_imp_page.create_region(
 p_id=>wwv_flow_imp.id(23456789012345678)
,p_name=>'Employee Details'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(55555555555555555)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'EMP'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
```

For SQL-sourced regions (IR/IG), the query uses `wwv_flow_string.join`:

```sql
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select EMPNO,',
'       ENAME,',
'       JOB',
'  from EMP'))
,p_plug_source_type=>'NATIVE_IR'
```

### 4.3 `create_page_item`

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(45678901234567890)
,p_name=>'P10_ENAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(23456789012345678)    -- parent region
,p_item_source_plug_id=>wwv_flow_imp.id(23456789012345678)
,p_prompt=>'Employee Name'
,p_source=>'ENAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>100
,p_field_template=>wwv_flow_imp.id(66666666666666666)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'Y'
,p_protection_level=>'S'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
```

**Select list with LOV:**

```sql
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>wwv_flow_imp.id(77777777777777777)   -- LOV component ID
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select -'
```

### 4.4 `create_page_button`

```sql
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(67890123456789012)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(23456789012345678)  -- parent region
,p_button_name=>'BTN_SUBMIT'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(88888888888888888)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Submit'
,p_button_position=>'CHANGE'
,p_button_condition=>'P10_EMPNO'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
```

### 4.5 `create_page_process`

**Form DML:**

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(78901234567890123)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Employee Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(67890123456789012)
,p_internal_uid=>78901234567890123
);
```

**PL/SQL process:**

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(89012345678901234)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Send Notification'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'  pkg_notifications.send(',
'    p_emp_id => :P10_EMPNO,',
'    p_action => ''UPDATE''',
'  );',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(67890123456789012)
,p_process_success_message=>'Notification sent.'
);
```

### 4.6 `create_page_da_event` / `create_page_da_action`

Dynamic actions require two calls — the event, then one or more actions.

**Event:**

```sql
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(90123456789012345)
,p_name=>'On Change P10_DEPTNO'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_DEPTNO'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
```

**Action (refresh):**

```sql
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(01234567890123456)
,p_event_id=>wwv_flow_imp.id(90123456789012345)  -- must match event
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Report'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(34567890123456789)
);
```

**Action (set value):**

```sql
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(11234567890123456)
,p_event_id=>wwv_flow_imp.id(90123456789012345)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'Set Status'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_STATUS'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'ACTIVE'
,p_wait_for_result=>'Y'
);
```

### 4.7 `create_page_validation`

**Item required:**

```sql
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(12345678901234500)
,p_validation_name=>'P10_ENAME must be entered'
,p_validation_sequence=>10
,p_validation=>'P10_ENAME'
,p_validation_type=>'ITEM_REQUIRED'
,p_error_message=>'#LABEL# must have some value.'
,p_associated_item=>wwv_flow_imp.id(45678901234567890)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
```

**PL/SQL function body:**

```sql
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(12345678901234501)
,p_validation_name=>'Salary must be positive'
,p_validation_sequence=>20
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return :P10_SAL > 0;'))
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_validation2=>'PLSQL'
,p_error_message=>'Salary must be a positive number.'
,p_associated_item=>wwv_flow_imp.id(45678901234567891)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
```

### 4.8 `create_page_computation`

**Static assignment:**

```sql
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(12345678901234502)
,p_computation_sequence=>10
,p_computation_point=>'BEFORE_HEADER'
,p_computation_type=>'STATIC_ASSIGNMENT'
,p_computation_item=>'P10_CURRENT_USER'
,p_computation=>':APP_USER'
);
```

**SQL query:**

```sql
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(12345678901234503)
,p_computation_sequence=>20
,p_computation_point=>'BEFORE_HEADER'
,p_computation_type=>'QUERY'
,p_computation_item=>'P10_DEPT_NAME'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DNAME',
'  from DEPT',
' where DEPTNO = :P10_DEPTNO'))
);
```

### 4.9 `create_page_branch`

```sql
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(12345678901234504)
,p_branch_name=>'Go To Page 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.::::'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_when_button_id=>wwv_flow_imp.id(67890123456789012)
);
```

### 4.10 Interactive Report / Interactive Grid

For IR regions, additional calls follow the region:

```sql
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(...)
,p_name=>'Report 1'
,p_max_row_count_message=>'...'
,p_show_nulls_as=>'-'
...
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(...)
,p_db_column_name=>'EMPNO'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Empno'
,p_column_type=>'NUMBER'
...
);
```

For IG: `create_ig_report`, `create_ig_report_column`.

---

## 5. Shared Component Procedures (`wwv_flow_imp_shared`)

### 5.1 `create_list_of_values` — LOV

**SQL-based:**

```sql
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(77777777777777777)
,p_lov_name=>'DEPARTMENTS'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DNAME as d,',
'       DEPTNO as r',
'  from DEPT',
' order by 1'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'R'
,p_display_column_name=>'D'
);
```

**Static LOV with entries:**

```sql
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(77777777777777778)
,p_lov_name=>'YES_NO'
,p_lov_query=>'.'
,p_source_type=>'STATIC'
,p_location=>'LOCAL'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(77777777777777779)
,p_lov_id=>wwv_flow_imp.id(77777777777777778)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Yes'
,p_lov_return_value=>'Y'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(77777777777777780)
,p_lov_id=>wwv_flow_imp.id(77777777777777778)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'No'
,p_lov_return_value=>'N'
);
```

### 5.2 `create_security_scheme` — Authorization

```sql
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(11111111111111111)
,p_name=>'Administration Rights'
,p_scheme_type=>'NATIVE_IS_IN_GROUP'
,p_attribute_01=>'ADMIN'
,p_attribute_02=>'A'
,p_error_message=>'Insufficient privileges'
,p_caching=>'BY_USER_BY_PAGE_VIEW'
);
```

### 5.3 `create_list` / `create_list_item` — Navigation Lists

```sql
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(22222222222222222)
,p_name=>'Desktop Navigation Menu'
,p_list_status=>'PUBLIC'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(22222222222222223)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Home'
,p_list_item_link_target=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-home'
,p_list_item_current_type=>'TARGET_PAGE'
);
```

### 5.4 `create_authentication` — Authentication Scheme

```sql
wwv_flow_imp_shared.create_authentication(
 p_id=>wwv_flow_imp.id(33333333333333333)
,p_name=>'APEX Accounts'
,p_scheme_type=>'NATIVE_APEX_ACCOUNTS'
,p_invalid_session_type=>'LOGIN'
,p_logout_url=>'f?p=&APP_ID.:&LOGOUT_URL.:&SESSION.'
,p_cookie_name=>'ORA_WWV_APP_&APP_ID.'
,p_use_secure_cookie_yn=>'N'
,p_ras_mode=>0
);
```

---

## 6. Pre-Import Configuration (`apex_application_install`)

Override defaults before running an install script when importing into a different environment:

```sql
begin
    apex_application_install.set_workspace_id(l_workspace_id);
    apex_application_install.set_application_id(200);    -- install as app 200
    apex_application_install.set_schema('OTHER_SCHEMA');
    apex_application_install.set_application_alias('MY_APP');
    apex_application_install.generate_offset;            -- auto-generate new offset
end;
/
@f100/install.sql
```

| Procedure | Purpose |
|-----------|---------|
| `set_workspace_id(id)` | Target workspace |
| `set_application_id(id)` | Target app ID |
| `set_schema(name)` | Parsing schema |
| `set_application_alias(alias)` | App alias |
| `generate_offset` | Auto-generate a new ID offset to avoid collisions |

---

## 7. File Format Rules

### 7.1 Block structure

Every procedure call is wrapped in an anonymous PL/SQL block terminated by `/`:

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

Multiple related calls may share a single `begin...end;` block.

### 7.2 Manifest block

Each page file starts with a comment-only manifest listing all components:

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

### 7.3 Long strings

Use `wwv_flow_string.join(wwv_flow_t_varchar2(...))` for multi-line values:

```sql
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select e.empno,',
'       e.ename',
'  from emp e',
' where e.sal > :P10_MIN_SAL'))
```

Each line is a separate VARCHAR2 literal. `join()` concatenates with newlines. This avoids the 32K PL/SQL literal limit.

### 7.4 String escaping

Single quotes inside strings are doubled (standard Oracle PL/SQL):

```sql
,p_error_message=>'Employee''s name is required.'
```

### 7.5 `set define off`

Always present at the top of export files. Prevents SQL*Plus/SQLcl from treating `&` as substitution variables (which would break `&APP_ID.`, `&SESSION.` references).

### 7.6 `prompt` directives

Mark component boundaries and drive progress output during import:

```sql
prompt --application/pages/page_00010
```

In `install.sql`, paired with `@@` to include files:

```sql
prompt --install/pages/page_00010
@@application/pages/page_00010.sql
```

### 7.7 Component ordering within a page file

Components appear in this order:
1. Manifest (comment block with `null;`)
2. `create_page` — page definition
3. `create_region` — regions (by `p_plug_display_sequence`)
4. Report/worksheet columns (for IR/IG regions)
5. `create_page_button` — buttons
6. `create_page_branch` — branches
7. `create_page_item` — page items
8. `create_page_computation` — computations
9. `create_page_validation` — validations
10. `create_page_da_event` + `create_page_da_action` — dynamic actions
11. `create_page_process` — processes

### 7.8 Conditional display parameters

Many components support conditions:

```sql
,p_condition_type=>'ITEM_IS_NOT_NULL'
,p_condition_expression1=>'P10_EMPNO'
```

```sql
,p_condition_type=>'PLSQL_EXPRESSION'
,p_condition_expression1=>':P10_STATUS = ''ACTIVE'''
```

---

## 8. Special Files

### 8.1 Global Page (`page_00000.sql`)

Page 0 is the "Global Page". Components here appear on every page. Identical file structure to other pages.

### 8.2 `install.sql` (master)

Orchestrates the full import in order: environment setup, delete old app, create app shell, shared components, pages, finalization.

### 8.3 `install_component.sql` (partial export)

Only includes the exported component files, wrapped in `component_begin`/`component_end`.

### 8.4 `set_environment.sql` / `end_environment.sql`

Setup (`import_begin`) and teardown (`import_end`) for the import session.

---

## 9. Template ID References

Templates are referenced by ID. To find the correct template ID for a region, button, label, etc., look in:

```
application/shared_components/user_interface/templates/<type>/<template_name>.sql
```

The `p_id` in the template's `create_*_template` call is the ID to reference via `wwv_flow_imp.id()`.

---

## 10. Encoding and Environment

- Export files are **UTF-8** encoded
- `set define off` and `set verify off` at file top ensure clean execution
- Components within each file are ordered by sequence numbers, making exports deterministic for version control
