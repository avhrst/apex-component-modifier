# Form Region Patterns

> Extracted from App 102 (page 400) and App 104 (pages 2, 4, 20, 36, 43, 54, 68).
> All examples use real SQL from APEX 24.2 exports (release 24.2.0, version 2024.11.30).

---

## Table of Contents

- [Overview](#overview)
- [Page Structure](#page-structure)
- [Region Layout](#region-layout)
- [Page Items](#page-items)
- [Form Buttons](#form-buttons)
- [Validations](#validations)
- [Form Processes](#form-processes)
- [Branches](#branches)
- [Modal Dialog Cancel DA](#modal-dialog-cancel-da-pattern)
- [Computations](#computations)
- [Process Sequence Summary](#process-sequence-summary)
- [Common Patterns Reference](#common-patterns-reference)

---

## Overview

All form pages in these apps use the **legacy form pattern** with `NATIVE_FORM_FETCH` and `NATIVE_FORM_PROCESS` processes. None use the newer `NATIVE_FORM` plug source type (available in APEX 21.1+). This is the pattern found in production apps built before or migrated through APEX 24.2.

---

## Page Structure

Form pages use `p_page_component_map=>'02'` in `create_page()`.

### Modal Dialog Form Page

```sql
wwv_flow_imp_page.create_page(
 p_id=>400
,p_name=>'Employee'
,p_alias=>'EMPLOYEE'
,p_page_mode=>'MODAL'
,p_step_title=>'Employee'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_help_text=>'No help is available for this page.'
,p_page_component_map=>'02'
);
```

### Modal Dialog with Chaining Disabled

```sql
wwv_flow_imp_page.create_page(
 p_id=>36
,p_name=>'Notification'
,p_alias=>'NOTIFICATION'
,p_page_mode=>'MODAL'
,p_step_title=>'Notification'
,p_warn_on_unsaved_changes=>'N'
,p_first_item=>'AUTO_FIRST_ITEM'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_imp.id(14742036429788915758)
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(15697610216295277199)
,p_dialog_chained=>'N'
,p_protection_level=>'C'
,p_help_text=>'No help is available for this page.'
,p_page_component_map=>'02'
);
```

### Normal (Non-Modal) Form Page

```sql
wwv_flow_imp_page.create_page(
 p_id=>2
,p_name=>'Customer Details'
,p_alias=>'CUSTOMER-DETAILS'
,p_step_title=>'Customer Details'
,p_reload_on_submit=>'A'
,p_warn_on_unsaved_changes=>'N'
,p_first_item=>'AUTO_FIRST_ITEM'
,p_autocomplete_on_off=>'OFF'
,p_group_id=>wwv_flow_imp.id(14742037007755918886)
,p_html_page_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<script language="JavaScript" type="text/javascript">',
'<!--',
'',
' htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';',
'',
'//-->',
'</script>'))
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(15988538409344819545)
,p_protection_level=>'C'
,p_help_text=>'No help is available for this page.'
,p_page_component_map=>'02'
);
```

### Page Mode Variants

| Mode | Use Case | Key Parameters |
|------|----------|----------------|
| Normal (omit `p_page_mode`) | Full-page forms | `p_step_template`, breadcrumb region, branches |
| `'MODAL'` | Dialog forms | `p_dialog_chained=>'N'`, Buttons in `REGION_POSITION_03`, `NATIVE_CLOSE_WINDOW` |

**Key indicators:**
- `p_page_mode=>'MODAL'` makes a modal dialog page
- `p_dialog_chained=>'N'` prevents dialog stacking
- `p_page_component_map=>'02'` is the standard form page component map
- `p_javascript_code` includes `htmldb_delete_message` for delete confirmation
- Modal pages use `NATIVE_CLOSE_WINDOW` process; normal pages use branches

---

## Region Layout

### Modal Dialog: Main Form Region (Blank template)

```sql
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1368480259420476341)
,p_plug_name=>'Employee'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'TEXT',
  'show_line_breaks', 'Y')).to_clob
);
```

### Modal Dialog: Buttons Container (REGION_POSITION_03)

```sql
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1368481013552476344)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_03'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'TEXT',
  'show_line_breaks', 'Y')).to_clob
);
```

### Normal Page: Form Region with Template Options

```sql
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(17822181801675765900)
,p_plug_name=>'Customer Details'
,p_region_name=>'CUSTOMERS'
,p_region_template_options=>'#DEFAULT#:t-Region--hideHeader js-addHiddenHeadingRoleDesc:t-Region--scrollBody:t-Form--stretchInputs'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML',
  'show_line_breaks', 'N')).to_clob
);
```

### Collapsible Sub-Region (for address/social sections)

```sql
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(14871501416559249184)
,p_plug_name=>'Address / Country'
,p_parent_plug_id=>wwv_flow_imp.id(17827691076280914224)
,p_region_template_options=>'#DEFAULT#:is-collapsed:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>2664334895415463485
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_new_grid_column=>false
,p_plug_display_point=>'SUB_REGIONS'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML',
  'show_line_breaks', 'N')).to_clob
);
```

**Key template IDs (workspace-specific):**
- `4501440665235496320` -- Blank with Attributes (modal form content)
- `2126429139436695430` -- Buttons Container
- `4072358936313175081` -- Standard Region (normal page forms)
- `2664334895415463485` -- Collapsible Region
- `2531463326621247859` -- Breadcrumb Region

---

## Page Items

### Hidden (Primary Key)

Every form has a hidden PK item, typically the lowest `p_item_sequence`.

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1368484024524476357)
,p_name=>'P400_EMPNO'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(1368480259420476341)
,p_use_cache_before_default=>'NO'
,p_source=>'EMPNO'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
```

### Hidden (Non-DB, from session state)

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(17850401275578379414)
,p_name=>'P2_REQUEST'
,p_item_sequence=>420
,p_item_plug_id=>wwv_flow_imp.id(17822186980286765975)
,p_use_cache_before_default=>'NO'
,p_source=>'P2_REQUEST'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
```

### Text Field (basic)

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1368484509574476391)
,p_name=>'P400_ENAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(1368480259420476341)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Name'
,p_source=>'ENAME'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>60
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'NONE')).to_clob
);
```

### Text Field (required, with restricted characters)

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(17822182590799765917)
,p_name=>'P2_CUSTOMER_NAME'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(17822181801675765900)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Customer Name'
,p_source=>'CUSTOMER_NAME'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>64
,p_cMaxlength=>4000
,p_field_template=>2526760615038828570
,p_item_template_options=>'#DEFAULT#'
,p_protection_level=>'S'
,p_restricted_characters=>'WEB_SAFE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
```

**Note:** Required items use `p_is_required=>true` and the "Required" label template (`2526760615038828570`) instead of the "Optional" template (`2318601014859922299`).

### Text Field (URL subtype)

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(16634238126539232503)
,p_name=>'P2_LINKEDIN'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_imp.id(17815701237486094668)
,p_use_cache_before_default=>'NO'
,p_prompt=>'LinkedIn'
,p_source=>'LINKEDIN'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>80
,p_cMaxlength=>4000
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'URL',
  'trim_spaces', 'BOTH')).to_clob
);
```

### Select List (inline SQL LOV)

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1368485184577476396)
,p_name=>'P400_MGR'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(1368480259420476341)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Manager'
,p_source=>'MGR'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select ename,empno ',
'from eba_demo_ig_emp ',
'where job = ''MANAGER'' ',
'or job = ''PRESIDENT'''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
```

### Select List (named LOV, with null text)

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(16672426315156522432)
,p_name=>'P2_MARQUEE_CUSTOMER_YN'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(17822181801675765900)
,p_use_cache_before_default=>'NO'
,p_item_default=>'N'
,p_prompt=>'Marquee Customer'
,p_source=>'MARQUEE_CUSTOMER_YN'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'MARQUEE'
,p_lov=>'.'||wwv_flow_imp.id(14780692329566730807)||'.'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select -'
,p_cHeight=>1
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
```

**Key pattern:** Named LOVs use `p_named_lov=>'LOV_NAME'` plus `p_lov=>'.'||wwv_flow_imp.id(NNN)||'.'` (dot-delimited ID reference).

### Select List (cascading LOV)

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(16910751016407969488)
,p_name=>'P2_COUNTRY_ID'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(17822181801675765900)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Country'
,p_source=>'COUNTRY_ID'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'COUNTRIES_P2'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select country_name as d,',
'       id as r',
'  from EBA_CUST_COUNTRIES',
' where display_yn = ''Y''',
'   and region_id = :P2_GEOGRAPHY_ID',
' order by 1'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select -'
,p_lov_cascade_parent_items=>'P2_GEOGRAPHY_ID'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_grid_label_column_span=>1
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
```

**Cascading LOV parameters:**
- `p_lov_cascade_parent_items=>'P2_GEOGRAPHY_ID'`
- `p_ajax_optimize_refresh=>'Y'`
- LOV query references the parent item: `region_id = :P2_GEOGRAPHY_ID`

### Popup LOV (DIALOG mode)

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(18482284023816827280)
,p_name=>'P2_PARENT_CUSTOMER_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(17822181801675765900)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Parent'
,p_source=>'PARENT_CUSTOMER_ID'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'CUSTOMERS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select customer_name d, id r ',
'from EBA_CUST_CUSTOMERS',
'order by upper(customer_name)'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- No Parent -'
,p_cSize=>30
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'DIALOG',
  'initial_fetch', 'FIRST_ROWSET')).to_clob
);
```

### Popup LOV (POPUP mode, for tags)

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(17817909742606051270)
,p_name=>'P2_TAGS'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_imp.id(17735496386361364811)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Tags'
,p_source=>'TAGS'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select tag',
'  from eba_cust_tags_type_sum',
' where content_type = ''CUSTOMER''',
' order by 1',
''))
,p_lov_display_null=>'YES'
,p_cSize=>64
,p_cMaxlength=>4000
,p_begin_on_new_line=>'N'
,p_grid_label_column_span=>1
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_protection_level=>'S'
,p_help_text=>'Provide tags for this particular customers'
,p_inline_help_text=>'Enter tags separated by commas'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'initial_fetch', 'FIRST_ROWSET')).to_clob
);
```

**Popup LOV attribute variants:**
- `display_as => 'DIALOG'` -- opens a search dialog
- `display_as => 'POPUP'` -- inline popup/dropdown
- `initial_fetch => 'FIRST_ROWSET'` -- common for both

### Date Picker (APEX native)

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1368485591157476396)
,p_name=>'P400_HIREDATE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(1368480259420476341)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Hire Date'
,p_source=>'HIREDATE'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
);
```

### Date Picker (with format mask)

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(16368964113398490682)
,p_name=>'P36_DISPLAY_FROM'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(16368961932770490675)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Display From'
,p_format_mask=>'DD-MON-YYYY HH24:MI:SS'
,p_source=>'DISPLAY_FROM'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>64
,p_cMaxlength=>255
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
);
```

### Textarea

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1368487120595476398)
,p_name=>'P400_NOTES'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(1368480259420476341)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Notes'
,p_source=>'NOTES'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>1000
,p_cHeight=>4
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
```

### Number Field

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1368485918130476397)
,p_name=>'P400_SAL'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(1368480259420476341)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Salary'
,p_source=>'SAL'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'right',
  'virtual_keyboard', 'text')).to_clob
);
```

### Number Field (with min/max and suffix)

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1007428416486170618)
,p_name=>'P2_DISCOUNT_LEVEL'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_imp.id(17822181801675765900)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Discount'
,p_post_element_text=>'%'
,p_source=>'DISCOUNT_LEVEL'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--postTextBlock'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'max_value', '100',
  'min_value', '0',
  'number_alignment', 'right',
  'virtual_keyboard', 'text')).to_clob
);
```

### Yes/No (Switch)

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1368486759262476398)
,p_name=>'P400_ONLEAVE'
,p_is_required=>true
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(1368480259420476341)
,p_use_cache_before_default=>'NO'
,p_prompt=>'On Leave'
,p_source=>'ONLEAVE'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>2526760615038828570
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
);
```

### Checkbox (from named LOV)

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(17826471038403850160)
,p_name=>'P43_IS_ACTIVE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(17826469031394850128)
,p_use_cache_before_default=>'NO'
,p_item_default=>'Y'
,p_prompt=>'Is Active'
,p_source=>'IS_ACTIVE'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_named_lov=>'IS ACTIVE'
,p_lov=>'.'||wwv_flow_imp.id(14309933207192760444)||'.'
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
);
```

### Checkbox (inline SQL LOV, multi-value with QUERY_COLON source)

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(83883253195953158)
,p_name=>'P2_REFERENCE_TYPES'
,p_item_sequence=>480
,p_item_plug_id=>wwv_flow_imp.id(17822181801675765900)
,p_prompt=>'Reference Types'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select listagg(rt.id,'':'') within group (order by rt.reference_type) types',
'from eba_cust_reference_types rt,',
'    eba_cust_customer_reftype_ref ref',
'where rt.id = ref.reference_type_id',
'    and ref.customer_id = :P2_ID'))
,p_source_type=>'QUERY_COLON'
,p_display_as=>'NATIVE_CHECKBOX'
,p_named_lov=>'REFERENCE_TYPES'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select reference_type d, id r',
'from eba_cust_reference_types',
'where is_active = ''Y''',
'order by upper(reference_type)'))
,p_begin_on_new_line=>'N'
,p_display_when=>'P2_ID'
,p_display_when_type=>'ITEM_IS_NULL'
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
);
```

**Note:** `p_source_type=>'QUERY_COLON'` returns colon-delimited values for multi-value items.

### Display Only (value-based)

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(17816715621403446470)
,p_name=>'P2_ROW_KEY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(17822181801675765900)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Customer Unique ID:'
,p_source=>'ROW_KEY'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P2_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
```

### Display Only (LOV-based, shows display value)

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13867521926019155392)
,p_name=>'P68_PRODUCT_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(16615869431337082972)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Product'
,p_source=>'PRODUCT_ID'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_named_lov=>'P68_PRODUCT'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select product_name d, id r',
'from   eba_cust_products',
'where id = :P68_PRODUCT_ID',
'order by 1'))
,p_display_when=>'P68_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'LOV',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
```

**Variants:** `based_on => 'VALUE'` (raw value) vs `based_on => 'LOV'` (display value from LOV)

### File Upload (BLOB)

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(14488354984247663539)
,p_name=>'P2_LOGO_BLOB'
,p_item_sequence=>450
,p_item_plug_id=>wwv_flow_imp.id(14299734423974217185)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Image/File'
,p_source=>'LOGO_BLOB'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_FILE'
,p_cSize=>64
,p_cMaxlength=>255
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_protection_level=>'S'
,p_inline_help_text=>'Attachments must be under 15M in size.'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'blob_last_updated_column', 'LOGO_LASTUPD',
  'character_set_column', 'LOGO_CHARSET',
  'content_disposition', 'attachment',
  'display_as', 'INLINE',
  'display_download_link', 'Y',
  'filename_column', 'LOGO_NAME',
  'mime_type_column', 'LOGO_MIMETYPE',
  'storage_type', 'DB_COLUMN')).to_clob
);
```

### Display Image (BLOB)

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(14299734552845217186)
,p_name=>'P2_LOGO'
,p_item_sequence=>460
,p_item_plug_id=>wwv_flow_imp.id(14299734423974217185)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Logo'
,p_source=>'LOGO_BLOB'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_IMAGE'
,p_tag_attributes=>'style="max-width:500px;max-height:250px;"'
,p_display_when=>'P2_LOGO_NAME'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'DB_COLUMN',
  'blob_last_updated_column', 'LOGO_LASTUPD',
  'filename_column', 'LOGO_NAME')).to_clob
);
```

### Item Type Summary

| Display Type | p_display_as | Key Attributes |
|-------------|--------------|----------------|
| Hidden | `NATIVE_HIDDEN` | `value_protected => 'Y'` |
| Text Field | `NATIVE_TEXT_FIELD` | `subtype` ('TEXT', 'URL'), `trim_spaces`, `disabled` |
| Textarea | `NATIVE_TEXTAREA` | `auto_height`, `character_counter`, `resizable`, `trim_spaces` |
| Number | `NATIVE_NUMBER_FIELD` | `number_alignment`, `virtual_keyboard`, `min_value`, `max_value` |
| Select List | `NATIVE_SELECT_LIST` | `page_action_on_selection` |
| Popup LOV | `NATIVE_POPUP_LOV` | `display_as` ('DIALOG', 'POPUP'), `initial_fetch` |
| Date Picker | `NATIVE_DATE_PICKER_APEX` | `display_as`, `show_time`, `min_date`, `max_date`, `use_defaults` |
| Checkbox | `NATIVE_CHECKBOX` | `number_of_columns` |
| Yes/No | `NATIVE_YES_NO` | `use_defaults` |
| Display Only | `NATIVE_DISPLAY_ONLY` | `based_on` ('VALUE', 'LOV'), `format`, `send_on_page_submit` |
| Display Image | `NATIVE_DISPLAY_IMAGE` | `based_on`, `filename_column`, `blob_last_updated_column` |
| File Upload | `NATIVE_FILE` | `storage_type`, `filename_column`, `mime_type_column`, `display_as` |

---

## Form Buttons

### Cancel Button (DEFINED_BY_DA -- modal dialog)

```sql
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1368481387998476344)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(1368481013552476344)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
);
```

### Cancel Button (REDIRECT_PAGE -- normal page)

```sql
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(17822181886488765901)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(17822186980286765975)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:&LAST_VIEW.:&SESSION.::&DEBUG.:RP::'
);
```

### Delete Button

```sql
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1368480853333476344)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(1368481013552476344)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Delete'
,p_button_position=>'DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition=>'P400_EMPNO'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'DELETE'
);
```

### Delete Button (with danger styling)

```sql
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(17822182004345765901)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(17822186980286765975)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--simple:t-Button--danger'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Delete'
,p_button_position=>'DELETE'
,p_button_redirect_url=>'javascript:apex.confirm(htmldb_delete_message,''DELETE'');'
,p_button_execute_validations=>'N'
,p_button_condition=>'P2_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_security_scheme=>wwv_flow_imp.id(15988538409344819545)
,p_database_action=>'DELETE'
);
```

### Save Button (Apply Changes)

```sql
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1368480768938476344)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(1368481013552476344)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'NEXT'
,p_button_condition=>'P400_EMPNO'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
```

### Create Button

```sql
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(1368480704608476344)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(1368481013552476344)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'NEXT'
,p_button_condition=>'P400_EMPNO'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
```

### Button Pattern Summary

| Button | Action | Position | Condition | Hot | DB Action |
|--------|--------|----------|-----------|-----|-----------|
| CANCEL | DEFINED_BY_DA (modal) or REDIRECT_PAGE | CLOSE or PREVIOUS | none | N | none |
| DELETE | REDIRECT_URL (js confirm) | DELETE or PREVIOUS | PK IS_NOT_NULL | N | DELETE |
| SAVE | SUBMIT | NEXT or CREATE | PK IS_NOT_NULL | Y | UPDATE |
| CREATE | SUBMIT | NEXT or CREATE | PK IS_NULL | Y | INSERT |

**Delete button constants:**
- `p_button_action=>'REDIRECT_URL'` with `javascript:apex.confirm(htmldb_delete_message,''DELETE'');`
- `p_button_execute_validations=>'N'` (skip validations for delete)
- `p_button_condition_type=>'ITEM_IS_NOT_NULL'` (only show when editing)
- Requires page-level JS: `var htmldb_delete_message='"DELETE_CONFIRM_MSG"';`

**Position values observed:** `CLOSE`, `DELETE`, `NEXT`, `CREATE`, `PREVIOUS`, `EDIT`

---

## Validations

### ITEM_IS_NUMERIC

```sql
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(17822183007861765934)
,p_validation_name=>'P2_CATEGORY_ID must be number'
,p_validation_sequence=>10
,p_validation=>'P2_CATEGORY_ID'
,p_validation_type=>'ITEM_IS_NUMERIC'
,p_error_message=>'Category Id must be number.'
,p_when_button_pressed=>wwv_flow_imp.id(17822182090214765901)
,p_associated_item=>wwv_flow_imp.id(17822182791508765931)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
```

### ITEM_IS_TIMESTAMP

```sql
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(16368965302619490687)
,p_validation_name=>'P36_DISPLAY_FROM must be timestamp'
,p_validation_sequence=>10
,p_validation=>'P36_DISPLAY_FROM'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_imp.id(16368964113398490682)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
```

### ITEM_NOT_NULL (with condition)

```sql
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(14299731671197217157)
,p_validation_name=>'New Contact is not null'
,p_validation_sequence=>20
,p_validation=>'P68_NEW_CONTACT'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'#LABEL# must have some value.'
,p_validation_condition=>'P68_CUSTOMER_CONTACT_ID'
,p_validation_condition2=>'-1'
,p_validation_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_associated_item=>wwv_flow_imp.id(14299731178685217152)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
```

### NOT_EXISTS (uniqueness check)

```sql
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(18482284218295827282)
,p_validation_name=>'Unique Account Number'
,p_validation_sequence=>30
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select null',
'from eba_cust_customers',
'where id <> :P2_ID',
'    and customer_account_number = :P2_CUSTOMER_ACCOUNT_NUMBER'))
,p_validation_type=>'NOT_EXISTS'
,p_error_message=>'#LABEL# already associated with another customer.'
,p_associated_item=>wwv_flow_imp.id(18482284192327827281)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
```

### NOT_EXISTS (cycle/hierarchy detection)

```sql
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(18482284297292827283)
,p_validation_name=>'No Customer Cycles'
,p_validation_sequence=>40
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select null',
'from (  select c.id',
'        from eba_cust_customers c',
'        start with c.id = :P2_PARENT_CUSTOMER_ID',
'        connect by prior parent_customer_id = id',
'    ) x',
'where x.id = :P2_ID'))
,p_validation_type=>'NOT_EXISTS'
,p_error_message=>'#LABEL# cannot be circular'
,p_associated_item=>wwv_flow_imp.id(18482284023816827280)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
```

### PL/SQL EXPRESSION (regexp validation)

```sql
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(297207826787477768)
,p_validation_name=>'Valid Characters in Tags'
,p_validation_sequence=>50
,p_validation=>'not regexp_like( :P2_TAGS, ''[:;#\/\\\?\&]'' )'
,p_validation2=>'PLSQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>'Tags may not contain the following characters: : ; \ / ? &'
,p_validation_condition=>'CREATE,SAVE'
,p_validation_condition_type=>'REQUEST_IN_CONDITION'
,p_associated_item=>wwv_flow_imp.id(17817909742606051270)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
```

### PL/SQL EXPRESSION (URL validation)

```sql
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(488448156578179864)
,p_validation_name=>'Website Must Be a URL starting with http'
,p_validation_sequence=>60
,p_validation=>'substr(:P2_WEB_SITE, 1, 4) = ''http'''
,p_validation2=>'PLSQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>'Please provide a URL that begins with, "http".'
,p_validation_condition=>'P2_WEB_SITE'
,p_validation_condition_type=>'ITEM_IS_NOT_NULL'
,p_associated_item=>wwv_flow_imp.id(17822183781731765940)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
```

### FUNC_BODY_RETURNING_BOOLEAN (date comparison)

```sql
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(15001804130484994188)
,p_validation_name=>'End after Beginning'
,p_validation_sequence=>30
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P36_DISPLAY_FROM is not null and :P36_DISPLAY_UNTIL is not null then',
'    return to_timestamp(:P36_DISPLAY_FROM,''DD-MON-YYYY HH24:MI:SS'') < to_timestamp(:P36_DISPLAY_UNTIL,''DD-MON-YYYY HH24:MI:SS'');',
'else',
'    return true;',
'end if;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'Display From and To dates must be in proper chronological order.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
```

### FUNC_BODY_RETURNING_BOOLEAN (not-null with trim)

```sql
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(14947122109576604930)
,p_validation_name=>'P20_NAME Not Null'
,p_validation_sequence=>10
,p_validation=>'return trim(:P20_NAME) is not null'
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'#LABEL# must have some value.'
,p_validation_condition=>'CREATE,SAVE'
,p_validation_condition_type=>'REQUEST_IN_CONDITION'
,p_associated_item=>wwv_flow_imp.id(17827695584321914232)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
```

### FUNC_BODY_RETURNING_BOOLEAN (array/checkbox validation)

```sql
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(13867521594748155389)
,p_validation_name=>'Product Must Be Selected'
,p_validation_sequence=>10
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    l_product_id number;',
'begin',
'    for i in 1..apex_application.g_f01.count',
'    loop',
'        l_product_id := to_number(APEX_APPLICATION.G_F01(i));',
'        if l_product_id > 0 then',
'            return true;',
'        end if;',
'    end loop;',
'    return false;',
'end;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'At least one product must be selected.'
,p_when_button_pressed=>wwv_flow_imp.id(16615869627929082977)
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
```

### Validation Type Reference

| Type | p_validation_type | p_validation2 | p_validation contains |
|------|-------------------|---------------|----------------------|
| Item is numeric | `ITEM_IS_NUMERIC` | (none) | Item name |
| Item is timestamp | `ITEM_IS_TIMESTAMP` | (none) | Item name |
| Item not null | `ITEM_NOT_NULL` | (none) | Item name |
| SQL NOT EXISTS | `NOT_EXISTS` | (none) | SQL query |
| PL/SQL expression | `EXPRESSION` | `PLSQL` | PL/SQL expression |
| PL/SQL function body | `FUNC_BODY_RETURNING_BOOLEAN` | `PLSQL` | PL/SQL block |

**Error display locations:** `INLINE_WITH_FIELD_AND_NOTIFICATION` or `INLINE_IN_NOTIFICATION`

**Condition types used:**
- `p_validation_condition_type=>'REQUEST_IN_CONDITION'` with `p_validation_condition=>'CREATE,SAVE'`
- `p_validation_condition_type=>'ITEM_IS_NOT_NULL'` with `p_validation_condition=>'ITEM_NAME'`
- `p_validation_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'`
- `p_when_button_pressed=>wwv_flow_imp.id(NNN)`

---

## Form Processes

### Fetch Row (NATIVE_FORM_FETCH) -- AFTER_HEADER

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1368488361825476406)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_FORM_FETCH'
,p_process_name=>'Fetch Row from EBA_DEMO_IG_EMP'
,p_attribute_02=>'EBA_DEMO_IG_EMP'
,p_attribute_03=>'P400_EMPNO'
,p_attribute_04=>'EMPNO'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>1340088570559668221
);
```

### Fetch Row (with allowed operations)

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(17822186596776765968)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_FORM_FETCH'
,p_process_name=>'Fetch Row from EBA_CUST_CUSTOMERS'
,p_attribute_02=>'EBA_CUST_CUSTOMERS'
,p_attribute_03=>'P2_ID'
,p_attribute_04=>'ID'
,p_attribute_11=>'I:U:D'
,p_process_error_message=>'Unable to fetch row.'
,p_internal_uid=>17798800069712218306
);
```

### Fetch Row (BEFORE_HEADER, conditional)

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(13867521795022155391)
,p_process_sequence=>40
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_FORM_FETCH'
,p_process_name=>'Fetch Row EBA_CUST_PRODUCT_USES'
,p_attribute_02=>'EBA_CUST_PRODUCT_USES'
,p_attribute_03=>'P68_ID'
,p_attribute_04=>'ID'
,p_attribute_05=>'P68_PRODUCT_ID'
,p_attribute_06=>'PRODUCT_ID'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P68_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>13844135267957607729
);
```

### NATIVE_FORM_FETCH Attribute Map

| Attribute | Purpose | Example |
|-----------|---------|---------|
| `p_attribute_02` | Table name | `'EBA_DEMO_IG_EMP'` |
| `p_attribute_03` | PK item name | `'P400_EMPNO'` |
| `p_attribute_04` | PK column name | `'EMPNO'` |
| `p_attribute_05` | Secondary column item (optional) | `'P68_PRODUCT_ID'` |
| `p_attribute_06` | Secondary column name (optional) | `'PRODUCT_ID'` |
| `p_attribute_11` | Allowed operations | `'I:U:D'` |

### DML Process (NATIVE_FORM_PROCESS) -- AFTER_SUBMIT

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1368488753527476406)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_FORM_PROCESS'
,p_process_name=>'Process Row of EBA_DEMO_IG_EMP'
,p_attribute_02=>'EBA_DEMO_IG_EMP'
,p_attribute_03=>'P400_EMPNO'
,p_attribute_04=>'EMPNO'
,p_attribute_11=>'I:U:D'
,p_attribute_12=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Action Processed.'
,p_internal_uid=>1340088962261668221
);
```

### DML Process (with return key and security)

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(17822186697295765968)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_FORM_PROCESS'
,p_process_name=>'Process Row of EBA_CUST_CUSTOMERS'
,p_attribute_02=>'EBA_CUST_CUSTOMERS'
,p_attribute_03=>'P2_ID'
,p_attribute_04=>'ID'
,p_attribute_09=>'P2_ID'
,p_attribute_11=>'I:U:D'
,p_attribute_12=>'Y'
,p_process_error_message=>'Unable to process row of table EBA_CUST_CUSTOMERS.'
,p_process_success_message=>'Action Processed.'
,p_security_scheme=>wwv_flow_imp.id(15988538409344819545)
,p_return_key_into_item1=>'P2_ID'
,p_internal_uid=>17798800170231218306
);
```

### DML Process (limited operations, conditional)

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(14299730373744217144)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_FORM_PROCESS'
,p_process_name=>'Process Rows for EBA_CUST_PRODUCT_USES'
,p_attribute_02=>'EBA_CUST_PRODUCT_USES'
,p_attribute_03=>'P68_ID'
,p_attribute_04=>'ID'
,p_attribute_05=>'P68_PRODUCT_ID'
,p_attribute_06=>'PRODUCT_ID'
,p_attribute_11=>'U:D'
,p_attribute_12=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'DELETE_PRODUCT, UPDATE_PRODUCT'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_internal_uid=>14276343846679669482
);
```

### NATIVE_FORM_PROCESS Attribute Map

| Attribute | Purpose | Example |
|-----------|---------|---------|
| `p_attribute_02` | Table name | `'EBA_DEMO_IG_EMP'` |
| `p_attribute_03` | PK item name | `'P400_EMPNO'` |
| `p_attribute_04` | PK column name | `'EMPNO'` |
| `p_attribute_05` | Secondary column item (optional) | `'P68_PRODUCT_ID'` |
| `p_attribute_06` | Secondary column name (optional) | `'PRODUCT_ID'` |
| `p_attribute_09` | Return PK item (for inserts) | `'P2_ID'` |
| `p_attribute_11` | Allowed operations | `'I:U:D'` or `'U:D'` |
| `p_attribute_12` | Return primary key value | `'Y'` |

### PL/SQL Process (custom insert logic)

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(16615894013696379319)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'add products'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_ref_types     eba_cust_product_uses.reference_type_ids%type;',
'  l_ref_status_id eba_cust_product_uses.reference_status_id%type;',
'begin',
'    for i in 1..apex_application.g_f01.count',
'    loop',
'        insert into eba_cust_product_uses',
'        (customer_id, product_id, reference_type_ids, reference_status_id, internal_contact,',
'         customer_contact_id, valid_from, valid_to, comments)',
'        values',
'        (:P68_CUSTOMER_ID, to_number(APEX_APPLICATION.G_F01(i)), l_ref_types, l_ref_status_id,',
'         :P68_INTERNAL_CONTACT, :P68_CUSTOMER_CONTACT_ID,',
'         to_timestamp(:P68_VALID_FROM, ''DD-MON-YYYY HH:MI.SS AM''),',
'         to_timestamp(:P68_VALID_TO, ''DD-MON-YYYY HH:MI.SS AM''), :P68_COMMENTS);',
'    end loop;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(16615869627929082977)
,p_internal_uid=>16592507486631831657
);
```

### Clear Cache (NATIVE_SESSION_STATE -- current page)

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1368489197291476406)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_SESSION_STATE'
,p_process_name=>'reset page'
,p_attribute_01=>'CLEAR_CACHE_CURRENT_PAGE'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(1368480853333476344)
,p_internal_uid=>1340089406025668221
);
```

### Clear Cache (NATIVE_SESSION_STATE -- specific pages)

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(16368966032569490689)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_SESSION_STATE'
,p_process_name=>'reset page'
,p_attribute_01=>'CLEAR_CACHE_FOR_PAGES'
,p_attribute_04=>'31'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(16368962505464490677)
,p_internal_uid=>16345579505504943027
);
```

### Close Dialog (NATIVE_CLOSE_WINDOW -- conditional)

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1368489603977476407)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_02=>'N'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_process_success_message=>'Success'
,p_internal_uid=>1340089812711668222
);
```

### Close Dialog (NATIVE_CLOSE_WINDOW -- unconditional)

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1678029540672386916)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_02=>'N'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>1654643013607839254
);
```

### PL/SQL Process (BEFORE_HEADER setup)

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(17849298480746526385)
,p_process_sequence=>40
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load Data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :REQUEST = ''CONTACTS'' then',
'   eba_cust.eba_cust_add_views_log(''CON'',:P20_ID);',
'end if ;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>17825911953681978723
);
```

---

## Branches

Branches are only used on **normal (non-modal) pages**. Modal pages use `NATIVE_CLOSE_WINDOW`.

### After Delete -- redirect to list page

```sql
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(14931702029207481651)
,p_branch_name=>'Go To CUSTOMERS after delete'
,p_branch_action=>'f?p=&APP_ID.:CUSTOMERS:&SESSION.::&DEBUG.:::'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(17822182004345765901)
,p_branch_sequence=>10
);
```

### After Create -- redirect to related page with PK

```sql
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(15089859507606532522)
,p_branch_name=>'goto edit customer on create'
,p_branch_action=>'f?p=&APP_ID.:50:&SESSION.::&DEBUG.:RP,50:P50_ID:&P2_ID.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(17822182184650765901)
,p_branch_sequence=>20
);
```

### Default branch (catch-all)

```sql
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(17822182405314765917)
,p_branch_action=>'f?p=&APP_ID.:&LAST_VIEW.:&SESSION.:&P2_REQUEST.:&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>30
,p_save_state_before_branch_yn=>'Y'
);
```

### Simple redirect branch

```sql
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(17827705187681914246)
,p_branch_action=>'f?p=&APP_ID.:18:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_save_state_before_branch_yn=>'Y'
);
```

---

## Modal Dialog Cancel DA Pattern

Every modal dialog form includes this Dynamic Action pair:

### DA Event

```sql
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(1368481438300476344)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(1368481387998476344)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
```

### DA Action

```sql
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(1368482312962476348)
,p_event_id=>wwv_flow_imp.id(1368481438300476344)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
```

---

## Computations

### Checkbox NVL default (pre-submit)

```sql
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(12021490319236467770)
,p_computation_sequence=>10
,p_computation_item=>'P43_IS_ACTIVE'
,p_computation_type=>'EXPRESSION'
,p_computation_language=>'PLSQL'
,p_computation=>'nvl(:P43_IS_ACTIVE,''N'')'
);
```

Used for checkbox items to default null to 'N' before submit.

---

## Process Sequence Summary

### Modal Dialog Form

| Seq | Process Point | Type | Purpose |
|-----|---------------|------|---------|
| 10 | AFTER_HEADER | NATIVE_FORM_FETCH | Load row into items |
| 20 | AFTER_SUBMIT | NATIVE_FORM_PROCESS | Insert/Update/Delete |
| 30 | AFTER_SUBMIT | NATIVE_SESSION_STATE | Clear cache on delete |
| 40-50 | AFTER_SUBMIT | NATIVE_CLOSE_WINDOW | Close dialog |

### Normal Page Form

| Seq | Process Point | Type | Purpose |
|-----|---------------|------|---------|
| (opt) | BEFORE_HEADER | NATIVE_PLSQL | Setup (e.g., set LAST_VIEW) |
| 10 | AFTER_HEADER | NATIVE_FORM_FETCH | Load row into items |
| 20 | AFTER_SUBMIT | NATIVE_FORM_PROCESS | Insert/Update/Delete |
| 30 | AFTER_SUBMIT | NATIVE_SESSION_STATE | Clear cache on delete |
| -- | AFTER_PROCESSING | Branches | Delete redirect, create redirect, default |

---

## Common Patterns Reference

### Item Naming Convention
- Format: `P{page_number}_{COLUMN_NAME}` (e.g., `P400_EMPNO`, `P2_CUSTOMER_NAME`)
- PK item is always first (lowest sequence): `P{n}_ID` or `P{n}_{PK_COLUMN}`

### Field Template IDs (workspace-specific)

| Template ID | Usage |
|-------------|-------|
| `2318601014859922299` | Optional label (most common) |
| `2526760615038828570` | Required label (with `p_is_required=>true`) |
| `1609121967514267634` | Optional - Above |
| `1609122147107268652` | Required - Above |
| `2040785906935475274` | Hidden label |
| `3031561666792084173` | Left label with above help |

### Button Template
- All buttons use the same template: `4072362960822175091` (Text button)

### Sequence Numbering
- Items: increments of 10 (10, 20, 30, ...) with occasional fractional sequences (5, 192)
- Buttons: increments of 10 (10, 20, 30, 40)
- Processes: increments of 10 (10, 20, 30, 40)
- Validations: increments of 10 (10, 20, 30, ...)
- Branches: increments of 10 (10, 20, 30)

### Common Item Parameters
- `p_use_cache_before_default=>'NO'` -- present on virtually all DB-sourced items
- `p_source_type=>'DB_COLUMN'` -- items sourced from a table column
- `p_protection_level=>'S'` -- Session State Protection on sensitive items (PK, hidden, etc.)
- `p_item_template_options=>'#DEFAULT#'` -- standard on all items
- `p_attributes` uses the `wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(...))` format (APEX 24.2)

### Grid Layout Controls
- `p_begin_on_new_line=>'N'` -- place item on same row as previous
- `p_colspan=>N` -- number of grid columns the item spans (1-12)
- `p_grid_label_column_span=>N` -- label width in grid columns
- `p_grid_column=>N` -- explicit grid column placement
- `p_post_element_text=>'%'` -- suffix text after input

### Conditional Display
- `p_display_when=>'P2_ID'` + `p_display_when_type=>'ITEM_IS_NOT_NULL'` -- show only when editing
- `p_display_when=>'P2_ID'` + `p_display_when_type=>'ITEM_IS_NULL'` -- show only when creating
- `p_display_when_type=>'EXISTS'` with SQL query -- show based on data existence
- `p_required_patch=>wwv_flow_imp.id(NNN)` -- controlled by build option

### Build Options and Security
- `p_required_patch=>wwv_flow_imp.id(NNN)` -- feature toggle (build option)
- `p_security_scheme=>wwv_flow_imp.id(NNN)` -- authorization scheme on buttons/processes
- `p_required_role=>wwv_flow_imp.id(NNN)` -- page-level authorization

### ID References
- `wwv_flow_imp.id(NNN)` -- always used for component cross-references
- IDs are workspace-specific absolute numbers; they shift when exported with different `p_default_id_offset`
