# Component: Page Validation

Patterns from APEX 24.2 exports (Apps 102-128, 320 validations across 9 types).

## API Calls (ordered)

- Primary: `wwv_flow_imp_page.create_page_validation(...)`

## Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `p_id` | `wwv_flow_imp.id(N)` | Unique validation ID |
| `p_validation_name` | `varchar2` | Display name for the validation |
| `p_validation_sequence` | `number` | Execution order (10, 20, 30…) |
| `p_validation_type` | `varchar2` | Validation method (see Variations below) |
| `p_error_message` | `varchar2` | Message shown on failure; supports `#LABEL#`, `#COLUMN_HEADER#` substitutions |
| `p_error_display_location` | `varchar2` | Where the error appears (see catalog below) |

## Common Optional Parameters

| Parameter | Type | Typical Values | Default |
|-----------|------|----------------|---------|
| `p_validation` | `varchar2` | Item name, SQL query, PL/SQL body, or expression — depends on `p_validation_type` | — |
| `p_validation2` | `varchar2` | Language/regex: `'PLSQL'`, `'SQL'`, or a regex pattern | — |
| `p_associated_item` | `wwv_flow_imp.id(N)` | Page item to attach inline error to | — |
| `p_when_button_pressed` | `wwv_flow_imp.id(N)` | Only fire when this button is pressed | — |
| `p_validation_condition` | `varchar2` | Condition expression / item name | — |
| `p_validation_condition2` | `varchar2` | Second condition operand | — |
| `p_validation_condition_type` | `varchar2` | Condition type (see catalog below) | — |
| `p_tabular_form_region_id` | `wwv_flow_imp.id(N)` | Region ID for tabular-form / IG column validations | — |
| `p_associated_column` | `varchar2` | Column name for IG/tabular validations | — |
| `p_display_when_type` | `varchar2` | Server-side display condition | — |
| `p_display_when_cond` | `varchar2` | Display-when condition value | — |

## Variations

### Variation A: ITEM_NOT_NULL (simple required field)

`p_validation` = item name. No `p_validation2`.

```sql
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(22490260601549846388)
,p_validation_name=>'Question required when adding question'
,p_validation_sequence=>10
,p_validation=>'P112_QUESTION'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Question must have some value.'
,p_when_button_pressed=>wwv_flow_imp.id(49638212582925284650)
,p_associated_item=>wwv_flow_imp.id(59161460835991764592)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
```

With server-side condition:

```sql
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(...)
,p_validation_name=>'P12_FILE_BLOB'
,p_validation_sequence=>10
,p_validation=>'P12_FILE_BLOB'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Please select a file to upload.'
,p_validation_condition=>'P12_ID'
,p_validation_condition_type=>'ITEM_IS_NULL'
,p_when_button_pressed=>wwv_flow_imp.id(3256566549476398570)
,p_associated_item=>wwv_flow_imp.id(3256568752143398600)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
```

### Variation B: EXPRESSION (PL/SQL expression returning boolean)

`p_validation` = PL/SQL or SQL expression. `p_validation2` = `'PLSQL'` or `'SQL'`.

```sql
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(1907418853212363548)
,p_validation_name=>'End Date later than start date'
,p_validation_sequence=>10
,p_validation=>'to_date(:P3_START_DATE,''DD-MON-YYYY'') <= to_date(:P3_END_DATE, ''DD-MON-YYYY'')'
,p_validation2=>'PLSQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>'End date must be later than the start date.'
,p_associated_item=>wwv_flow_imp.id(2586098187845822942)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
```

With function call and condition:

```sql
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(72655591700361790014)
,p_validation_name=>'check for FREEFORM, answer set or answer'
,p_validation_sequence=>20
,p_validation=>':P112_ANSWER_SET_ID is not null or :P112_ANSWERS is not null'
,p_validation2=>'PLSQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>'Answers must be provided'
,p_validation_condition=>'P112_ANSWER_TYPE'
,p_validation_condition2=>'FREEFORM'
,p_validation_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_when_button_pressed=>wwv_flow_imp.id(49638212582925284650)
,p_associated_item=>wwv_flow_imp.id(162338393653014475862)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
```

### Variation C: FUNC_BODY_RETURNING_BOOLEAN (PL/SQL function body)

`p_validation` = PL/SQL block returning boolean. `p_validation2` = `'PLSQL'`.

```sql
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(36925366252878790509)
,p_validation_name=>'P7_STORE_NAME Not Null'
,p_validation_sequence=>10
,p_validation=>'return trim(:P7_STORE_NAME) is not null'
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'#LABEL# must have some value.'
,p_validation_condition=>'CREATE,SAVE'
,p_validation_condition_type=>'REQUEST_IN_CONDITION'
,p_associated_item=>wwv_flow_imp.id(38803017259933461068)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
```

Multi-line function body with complex logic:

```sql
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(48319019648784606514)
,p_validation_name=>'Cannot remove yourself from administrator'
,p_validation_sequence=>10
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P10032_USER_NAME = :APP_USER and',
'    apex_acl.is_role_removed_from_user (',
'        p_application_id => :APP_ID,',
'        p_user_name      => :APP_USER,',
'        p_role_static_id => ''ADMINISTRATOR'',',
'        p_role_ids       => apex_string.split_numbers(',
'                                p_str => case when :REQUEST = ''DELETE'' then',
'                                             null',
'                                         else',
'                                             :P10032_ROLE_ID',
'                                         end,',
'                                p_sep => '':'') ) then',
'    return false;',
'else',
'    return true;',
'end if;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'You cannot remove administrator role from yourself.'
,p_when_button_pressed=>wwv_flow_imp.id(48319016417586606512)
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
```

### Variation D: FUNC_BODY_RETURNING_ERR_TEXT (PL/SQL returning error message)

`p_validation` = PL/SQL block; returns `NULL` on success or error text on failure. `p_validation2` = `'PLSQL'`.

```sql
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(49634813619493388237)
,p_validation_name=>'check for max open sessions'
,p_validation_sequence=>30
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'   l_max_open_sessions      number := qask_util.get_setting(''max_open_sessions'');',
'   l_open_session_for_user  number := qask_util.open_session_count_for_user(:APP_USER);',
'begin',
'',
'if l_open_session_for_user >= l_max_open_sessions then ',
'    return ''You have requested more sessions than permitted.  ''||',
'        ''Maximum permitted is ''||l_max_open_sessions||''.  ''||',
'        ''Please close some of your open sessions before starting a new one.'';',
'end if;',
'',
'end;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_ERR_TEXT'
,p_validation_condition=>'P111_LIVE_YN'
,p_validation_condition2=>'Y'
,p_validation_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
```

### Variation E: NOT_EXISTS (SQL query must return no rows)

`p_validation` = SQL SELECT. No `p_validation2`.

```sql
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(6369983341263926923)
,p_validation_name=>'user already exists'
,p_validation_sequence=>30
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1',
'  from apex_appl_acl_users ',
' where application_id = :APP_ID',
'   and user_name_lc = lower(:P10032_USER_NAME)'))
,p_validation_type=>'NOT_EXISTS'
,p_error_message=>'user already exists.'
,p_when_button_pressed=>wwv_flow_imp.id(48319016855597606512)
,p_associated_item=>wwv_flow_imp.id(48319017894459606512)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
```

### Variation F: EXISTS (SQL query must return at least one row)

`p_validation` = SQL SELECT. No `p_validation2`.

```sql
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(725782969319298198)
,p_validation_name=>'is manager'
,p_validation_sequence=>10
,p_validation=>'select ename from EBA_DEMO_IG_EMP where ENAME = :P34_AUTH and ( JOB = ''MANAGER'' or JOB = ''PRESIDENT'')'
,p_validation_type=>'EXISTS'
,p_error_message=>'Enter the name of a manager or president'
,p_associated_item=>wwv_flow_imp.id(725782842000298197)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
```

### Variation G: REGULAR_EXPRESSION (regex match)

`p_validation` = item name. `p_validation2` = regex pattern.

```sql
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(6887379769796367605)
,p_validation_name=>'email valid'
,p_validation_sequence=>20
,p_validation=>'P10032_USER_NAME'
,p_validation2=>'[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}'
,p_validation_type=>'REGULAR_EXPRESSION'
,p_error_message=>'Email is not valid'
,p_when_button_pressed=>wwv_flow_imp.id(48319016855597606512)
,p_associated_item=>wwv_flow_imp.id(48319017894459606512)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
```

### Variation H: ITEM_IS_NUMERIC (numeric check)

`p_validation` = item name. No `p_validation2`.

```sql
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(17822196232622983753)
,p_validation_name=>'P2_CATEGORY_ID must be number'
,p_validation_sequence=>10
,p_validation=>'P2_CATEGORY_ID'
,p_validation_type=>'ITEM_IS_NUMERIC'
,p_error_message=>'Category Id must be number.'
,p_when_button_pressed=>wwv_flow_imp.id(17822195236163983723)
,p_associated_item=>wwv_flow_imp.id(17822195937457983753)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
```

### Variation I: ITEM_IS_TIMESTAMP (timestamp format check)

`p_validation` = item name. No `p_validation2`.

```sql
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(16368978675797708509)
,p_validation_name=>'P36_DISPLAY_UNTIL must be timestamp'
,p_validation_sequence=>20
,p_validation=>'P36_DISPLAY_UNTIL'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_imp.id(16368977470464708504)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
```

### Tabular Form / IG Column Validation

Uses `p_tabular_form_region_id` and `p_associated_column` instead of `p_associated_item`.

```sql
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(725783102889298200)
,p_tabular_form_region_id=>wwv_flow_imp.id(1440996366984066153)
,p_validation_name=>'New'
,p_validation_sequence=>20
,p_validation=>':SAL < 6000'
,p_validation2=>'SQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>'#COLUMN_HEADER# must be less than 6000.'
,p_associated_column=>'SAL'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
```

## Parameter Value Catalog

| Parameter | All Observed Values |
|-----------|-------------------|
| `p_validation_type` | `EXPRESSION` (92), `ITEM_NOT_NULL` (90), `NOT_EXISTS` (70), `REGULAR_EXPRESSION` (27), `FUNC_BODY_RETURNING_BOOLEAN` (23), `ITEM_IS_TIMESTAMP` (8), `ITEM_IS_NUMERIC` (5), `EXISTS` (3), `FUNC_BODY_RETURNING_ERR_TEXT` (2) |
| `p_validation2` | `'PLSQL'` (107), `'SQL'` (11), regex pattern (for `REGULAR_EXPRESSION`), omitted (for item-type validations) |
| `p_error_display_location` | `'INLINE_WITH_FIELD_AND_NOTIFICATION'` (273), `'INLINE_IN_NOTIFICATION'` (28), `'INLINE_WITH_FIELD'` (17) |
| `p_validation_condition_type` | `'VAL_OF_ITEM_IN_COND_EQ_COND2'` (36), `'ITEM_IS_NOT_NULL'` (33), `'REQUEST_IN_CONDITION'` (27), `'EXPRESSION'` (25), `'EXISTS'` (6), `'VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST'` (4), `'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'` (3), `'NEVER'` (1), `'ITEM_IS_NULL'` (1) |
| `p_display_when_type` | `'REQUEST_EQUALS_CONDITION'` (2) |

## Relationships

- **Parent**: page (validations belong to a page, fired on submit)
- **Associated item**: `p_associated_item` links error display to a specific page item (for `INLINE_WITH_FIELD*` modes)
- **Button trigger**: `p_when_button_pressed` restricts validation to a specific submit button
- **Server-side condition**: `p_validation_condition` + `p_validation_condition_type` control when validation runs
- **IG/Tabular**: `p_tabular_form_region_id` + `p_associated_column` for grid-level validations
