# Form Region Patterns

> Extracted from App 102 (page 400) and App 104 (pages 2, 4, 20, 36, 43, 54, 68).
> All examples use real SQL from APEX 24.2 exports.

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

Variant -- Modal with chaining disabled: add `,p_dialog_chained=>'N'`.
Variant -- Normal page: omit `p_page_mode` (defaults to non-modal).

## Region Layout

### Body Region (form items container)

```sql
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1368480259420476341)
,p_plug_name=>'Employee'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>1129549498498498584
,p_plug_display_sequence=>10
,p_query_type=>'TABLE'
,p_query_table=>'EBA_DEMO_IG_EMP'
,p_include_rowid_column=>false
,p_is_editable=>false
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
```

### Buttons Container Region

```sql
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1368481013552476344)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429664498676498
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
```

## Page Items

### Hidden (PK)

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1368482398754476349)
,p_name=>'P400_EMPNO'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(1368480259420476341)
,p_use_cache_before_default=>'NO'
,p_source=>'EMPNO'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
```

### Text Field

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1368483228709476389)
,p_name=>'P400_ENAME'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(1368480259420476341)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Name'
,p_source=>'ENAME'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>60
,p_field_template=>2526760615038828570
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
```

Attributes: `subtype` ('TEXT', 'URL'), `trim_spaces` ('BOTH', 'LEADING', 'TRAILING', 'NONE'), `disabled` ('Y'/'N').

### Textarea

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(17822184082850765943)
,p_name=>'P2_SUMMARY'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(17822181801675765900)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Summary'
,p_source=>'SUMMARY'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>70
,p_cMaxlength=>4000
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

### Select List (SQL LOV)

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1368485961159476394)
,p_name=>'P400_MGR'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(1368480259420476341)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Manager'
,p_source=>'MGR'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ename d, empno r',
'from eba_demo_ig_emp',
'order by 1'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select Manager -'
,p_cHeight=>1
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
```

Variant -- Named LOV: `p_named_lov=>'LOV_NAME'`, `p_lov=>'.'||wwv_flow_imp.id(NNN)||'.'`

### Popup LOV

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(18482284023816827280)
,p_name=>'P2_PARENT_CUSTOMER_ID'
,p_item_sequence=>340
,p_item_plug_id=>wwv_flow_imp.id(17822181801675765900)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Parent Customer'
,p_source=>'PARENT_CUSTOMER_ID'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select customer_name d, id r',
'from eba_cust_customers',
'where id <> nvl(:P2_ID,0)',
'order by upper(customer_name)'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- None -'
,p_cSize=>50
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'case_sensitive', 'N',
  'display_as', 'POPUP',
  'initial_fetch', 'NO_FETCH',
  'manual_entry', 'N',
  'match_type', 'CONTAINS',
  'min_chars', '0')).to_clob
);
```

### Date Picker

```sql
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(1368486369497476395)
,p_name=>'P400_HIREDATE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(1368480259420476341)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Hire date'
,p_format_mask=>'DD-MON-YYYY'
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

### Number Field

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
,p_display_as=>'NATIVE_YES_NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
```

### Checkbox

Named LOV: `p_display_as=>'NATIVE_CHECKBOX'`, `p_named_lov=>'IS ACTIVE'`, `p_lov=>'.'||wwv_flow_imp.id(NNN)||'.'`
Inline SQL LOV with `p_source_type=>'QUERY_COLON'` for multi-value (colon-delimited) items.

### Display Only

```sql
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',    -- 'VALUE' (raw) or 'LOV' (display value from LOV)
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
```

LOV-based variant adds `p_named_lov` and `p_lov`, uses `'based_on', 'LOV'`.

### File Upload (BLOB)

```sql
,p_display_as=>'NATIVE_FILE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'blob_last_updated_column', 'LOGO_LASTUPD',
  'character_set_column', 'LOGO_CHARSET',
  'content_disposition', 'attachment',
  'display_as', 'INLINE',
  'display_download_link', 'Y',
  'filename_column', 'LOGO_NAME',
  'mime_type_column', 'LOGO_MIMETYPE',
  'storage_type', 'DB_COLUMN')).to_clob
```

### Display Image (BLOB)

```sql
,p_display_as=>'NATIVE_DISPLAY_IMAGE'
,p_tag_attributes=>'style="max-width:500px;max-height:250px;"'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'DB_COLUMN',
  'blob_last_updated_column', 'LOGO_LASTUPD',
  'filename_column', 'LOGO_NAME')).to_clob
```

### Item Type Summary

| `p_display_as` | Key Attributes |
|---|---|
| `NATIVE_HIDDEN` | `value_protected` |
| `NATIVE_TEXT_FIELD` | `subtype` ('TEXT','URL'), `trim_spaces`, `disabled` |
| `NATIVE_TEXTAREA` | `auto_height`, `character_counter`, `resizable`, `trim_spaces` |
| `NATIVE_NUMBER_FIELD` | `number_alignment`, `virtual_keyboard`, `min_value`, `max_value` |
| `NATIVE_SELECT_LIST` | `page_action_on_selection` |
| `NATIVE_POPUP_LOV` | `display_as` ('DIALOG','POPUP'), `initial_fetch`, `match_type` |
| `NATIVE_DATE_PICKER_APEX` | `display_as`, `show_time`, `min_date`, `max_date`, `use_defaults` |
| `NATIVE_CHECKBOX` | `number_of_columns` |
| `NATIVE_YES_NO` | `use_defaults` |
| `NATIVE_DISPLAY_ONLY` | `based_on` ('VALUE','LOV'), `format`, `send_on_page_submit` |
| `NATIVE_DISPLAY_IMAGE` | `based_on`, `filename_column`, `blob_last_updated_column` |
| `NATIVE_FILE` | `storage_type`, `filename_column`, `mime_type_column`, `display_as` |

## Form Buttons

### Button Pattern Summary

| Button | Action | Position | Condition | Hot | DB Action |
|---|---|---|---|---|---|
| CANCEL | DEFINED_BY_DA (modal) or REDIRECT_PAGE | CLOSE/PREVIOUS | none | N | none |
| DELETE | REDIRECT_URL (js confirm) | DELETE/PREVIOUS | PK IS_NOT_NULL | N | DELETE |
| SAVE | SUBMIT | NEXT/CREATE | PK IS_NOT_NULL | Y | UPDATE |
| CREATE | SUBMIT | NEXT/CREATE | PK IS_NULL | Y | INSERT |

### Cancel Button (modal)

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

Variant -- normal page: `p_button_action=>'REDIRECT_PAGE'`, `p_button_redirect_url=>'f?p=&APP_ID.:&LAST_VIEW.:&SESSION.::&DEBUG.:RP::'`

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

Variant with danger styling: add `p_button_template_options=>'#DEFAULT#:t-Button--simple:t-Button--danger'`
Requires page-level JS: `var htmldb_delete_message='"DELETE_CONFIRM_MSG"';`

### Save Button

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

Create button is identical except: `p_button_name=>'CREATE'`, `p_button_image_alt=>'Create'`, `p_button_condition_type=>'ITEM_IS_NULL'`, `p_database_action=>'INSERT'`.

Position values: `CLOSE`, `DELETE`, `NEXT`, `CREATE`, `PREVIOUS`, `EDIT`

## Validations

### Validation Type Reference

| Type | `p_validation_type` | `p_validation` contains |
|---|---|---|
| Item is numeric | `ITEM_IS_NUMERIC` | Item name |
| Item is timestamp | `ITEM_IS_TIMESTAMP` | Item name |
| Item not null | `ITEM_NOT_NULL` | Item name |
| SQL NOT EXISTS | `NOT_EXISTS` | SQL query |
| PL/SQL expression | `EXPRESSION` (+ `p_validation2=>'PLSQL'`) | PL/SQL expression |
| PL/SQL function body | `FUNC_BODY_RETURNING_BOOLEAN` (+ `p_validation2=>'PLSQL'`) | PL/SQL block |

Error display: `INLINE_WITH_FIELD_AND_NOTIFICATION` or `INLINE_IN_NOTIFICATION`

Condition types: `REQUEST_IN_CONDITION` (`'CREATE,SAVE'`), `ITEM_IS_NOT_NULL`, `VAL_OF_ITEM_IN_COND_EQ_COND2`, `p_when_button_pressed`

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

### PL/SQL EXPRESSION

```sql
,p_validation=>'not regexp_like( :P2_TAGS, ''[:;#\/\\\?\&]'' )'
,p_validation2=>'PLSQL'
,p_validation_type=>'EXPRESSION'
,p_validation_condition=>'CREATE,SAVE'
,p_validation_condition_type=>'REQUEST_IN_CONDITION'
```

### FUNC_BODY_RETURNING_BOOLEAN

```sql
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P36_DISPLAY_FROM is not null and :P36_DISPLAY_UNTIL is not null then',
'    return to_timestamp(:P36_DISPLAY_FROM,''DD-MON-YYYY HH24:MI:SS'') < to_timestamp(:P36_DISPLAY_UNTIL,''DD-MON-YYYY HH24:MI:SS'');',
'else',
'    return true;',
'end if;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
```

## Form Processes

### NATIVE_FORM_FETCH (AFTER_HEADER)

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

| Attribute | Purpose |
|---|---|
| `p_attribute_02` | Table name |
| `p_attribute_03` | PK item name |
| `p_attribute_04` | PK column name |
| `p_attribute_05` | Secondary column item (optional) |
| `p_attribute_06` | Secondary column name (optional) |
| `p_attribute_11` | Allowed operations (`'I:U:D'`) |

### NATIVE_FORM_PROCESS (AFTER_SUBMIT)

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

Additional attrs: `p_attribute_09` (return PK item), `p_attribute_05/06` (secondary column), `p_security_scheme`, `p_return_key_into_item1`.

### NATIVE_SESSION_STATE (Clear Cache)

```sql
,p_process_type=>'NATIVE_SESSION_STATE'
,p_attribute_01=>'CLEAR_CACHE_CURRENT_PAGE'    -- or 'CLEAR_CACHE_FOR_PAGES' with p_attribute_04=>'31'
,p_process_when_button_id=>wwv_flow_imp.id(1368480853333476344)
```

### NATIVE_CLOSE_WINDOW (Close Dialog)

```sql
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_02=>'N'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
```

## Branches

Only used on normal (non-modal) pages. Modal pages use NATIVE_CLOSE_WINDOW.

```sql
-- After Delete: redirect to list page
,p_branch_action=>'f?p=&APP_ID.:CUSTOMERS:&SESSION.::&DEBUG.:::'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(17822182004345765901)

-- After Create: redirect with PK
,p_branch_action=>'f?p=&APP_ID.:50:&SESSION.::&DEBUG.:RP,50:P50_ID:&P2_ID.'

-- Default catch-all
,p_branch_action=>'f?p=&APP_ID.:&LAST_VIEW.:&SESSION.:&P2_REQUEST.:&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_save_state_before_branch_yn=>'Y'
```

## Process Sequence Summary

### Modal Dialog Form

| Seq | Process Point | Type | Purpose |
|---|---|---|---|
| 10 | AFTER_HEADER | NATIVE_FORM_FETCH | Load row into items |
| 20 | AFTER_SUBMIT | NATIVE_FORM_PROCESS | Insert/Update/Delete |
| 30 | AFTER_SUBMIT | NATIVE_SESSION_STATE | Clear cache on delete |
| 40-50 | AFTER_SUBMIT | NATIVE_CLOSE_WINDOW | Close dialog |

### Normal Page Form

| Seq | Process Point | Type | Purpose |
|---|---|---|---|
| (opt) | BEFORE_HEADER | NATIVE_PLSQL | Setup |
| 10 | AFTER_HEADER | NATIVE_FORM_FETCH | Load row |
| 20 | AFTER_SUBMIT | NATIVE_FORM_PROCESS | DML |
| 30 | AFTER_SUBMIT | NATIVE_SESSION_STATE | Clear cache |
| -- | AFTER_PROCESSING | Branches | Redirects |

## Common Patterns

- **Item naming**: `P{page}_{COLUMN_NAME}` (e.g., `P400_EMPNO`)
- **Common item params**: `p_use_cache_before_default=>'NO'`, `p_source_type=>'DB_COLUMN'`, `p_protection_level=>'S'` (sensitive items)
- **Attributes format (24.2)**: `wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2('key','value')).to_clob`
- **Grid layout**: `p_begin_on_new_line=>'N'`, `p_colspan=>N`, `p_grid_label_column_span=>N`
- **Conditional display**: `p_display_when=>'P2_ID'` + `p_display_when_type=>'ITEM_IS_NOT_NULL'` (edit only) or `'ITEM_IS_NULL'` (create only)
- **Build options / security**: `p_required_patch`, `p_security_scheme`
- **Sequence numbering**: increments of 10
- **All buttons** use template ID `4072362960822175091`
- **Checkbox NVL computation**: `nvl(:P43_IS_ACTIVE,''N'')` before submit
