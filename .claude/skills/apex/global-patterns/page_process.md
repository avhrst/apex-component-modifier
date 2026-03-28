# Component: Page Process

Patterns from APEX 24.2 exports (29 apps, 1554 processes across 16 process types).

## API Calls (ordered)

- Primary: `wwv_flow_imp_page.create_page_process(...)`
- Companion (Invoke API params): `wwv_flow_imp_shared.create_invokeapi_comp_param(...)`
- Companion (Workflow params): `wwv_flow_imp_shared.create_workflow_comp_param(...)`

## Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `p_id` | `wwv_flow_imp.id(N)` | Unique process ID |
| `p_process_sequence` | number | Execution order within the process point (10, 20, 30…) |
| `p_process_point` | varchar2 | When the process runs (see Process Points below) |
| `p_process_type` | varchar2 | Process type plug-in name (see Variations) |
| `p_process_name` | varchar2 | Display name |
| `p_internal_uid` | number | Internal unique identifier |

## Common Optional Parameters

| Parameter | Type | Typical Values | Default |
|-----------|------|---------------|---------|
| `p_region_id` | `wwv_flow_imp.id(N)` | Region reference (required for Form Init/DML, IG DML) | — |
| `p_parent_process_id` | `wwv_flow_imp.id(N)` | Parent execution chain process | — |
| `p_process_sql_clob` | varchar2/clob | PL/SQL code block (for NATIVE_PLSQL) | — |
| `p_process_clob_language` | varchar2 | `'PLSQL'` | — |
| `p_error_display_location` | varchar2 | `'INLINE_IN_NOTIFICATION'`, `'INLINE_WITH_FIELD_AND_NOTIFICATION'`, `'INLINE_WITH_FIELD'` | — |
| `p_process_error_message` | varchar2 | Custom error text, supports `#SQLERRM#`, `#SQLERRM_TEXT#` | — |
| `p_process_success_message` | varchar2 | Success notification text | — |
| `p_process_when` | varchar2 | Condition expression (request names, item name, PL/SQL, SQL) | — |
| `p_process_when_type` | varchar2 | Condition type (see Condition Types below) | — |
| `p_process_when2` | varchar2 | Second condition operand (`'PLSQL'` for EXPRESSION type, value for EQ comparisons) | — |
| `p_process_when_button_id` | `wwv_flow_imp.id(N)` | Fire only when this button is pressed | — |
| `p_return_key_into_item1` | varchar2 | Item to receive PK after insert (legacy form process) | — |
| `p_attribute_01`–`p_attribute_12` | varchar2 | Type-specific attributes (see each variation) | — |

## Process Points

| Value | When | Typical Use |
|-------|------|-------------|
| `'AFTER_SUBMIT'` | After page submit, validations pass | DML, PL/SQL logic, close dialog (74% of processes) |
| `'BEFORE_HEADER'` | Before page renders | Form init, pre-computation, populate items (14%) |
| `'AFTER_HEADER'` | After header, before body | Legacy form fetch (10%) |
| `'ON_SUBMIT_BEFORE_COMPUTATION'` | After submit, before computations/validations | Early request routing |
| `'BEFORE_BOX_BODY'` | Before region rendering | Region-scoped pre-processing |
| `'ON_DEMAND'` | AJAX callback | Called via `apex.server.process()` from JS |

## Variations

### Variation A: PL/SQL Process (NATIVE_PLSQL)

Most common (607 instances). Executes arbitrary PL/SQL.

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(65584797262671839)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Add Item'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if sample_restaurant_manage_orders.item_quantity( p_item_id => :P7_ITEM_ID ) = 0 then',
'    sample_restaurant_manage_orders.add_item( p_item_id  => :P7_ITEM_ID,',
'                                              p_quantity => :P7_QUANTITY,',
'                                              p_utensils => :P7_UTENSILS,',
'                                              p_note     => :P7_NOTE );',
'end if;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(65577974112671830)
,p_internal_uid=>46387968857646736
);
```

**BEFORE_HEADER variant** (pre-computation, no error display):

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(65802841882374974)
,p_process_sequence=>80
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Calculate Shopping Cart Items'
,p_process_sql_clob=>':P8_SHOPPING_CART_ITEMS := sample_restaurant_manage_orders.get_quantity;'
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>46606013477349871
);
```

**ON_DEMAND variant** (AJAX callback, no error display, no button condition):

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(65618206130682088)
,p_process_sequence=>60
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'edit_cart'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if sample_restaurant_manage_orders.item_quantity( p_item_id => apex_application.g_x01 ) > 0 then',
'    sample_restaurant_manage_orders.remove_item( p_item_id => apex_application.g_x01 );',
'    sample_restaurant_manage_orders.add_item( p_item_id  => apex_application.g_x01,',
'                                              p_quantity => apex_application.g_x02,',
'                                              p_utensils => apex_application.g_x03,',
'                                              p_note     => apex_application.g_x04 );',
'end if;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>46421377725656985
);
```

### Variation B: Form Initialization (NATIVE_FORM_INIT)

Modern form pattern (96 instances). Runs at BEFORE_HEADER, references a form region.

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(4123717638862126579)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(4123700207492126564)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Movie Details'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>4100478565179998571
);
```

No attributes needed — the region's source definition provides table/column mapping.

### Variation C: Form DML (NATIVE_FORM_DML)

Modern form save (81 instances). Runs at AFTER_SUBMIT, references a form region.

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(4932455095498607818)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(4932454632760607814)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Customer Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>4097080700079311440
);
```

| Attribute | Purpose |
|-----------|---------|
| `p_attribute_01` | `'REGION_SOURCE'` (use region's source) |
| `p_attribute_05` | `'Y'` = return PK into item |
| `p_attribute_06` | `'Y'` = include ROWID |
| `p_attribute_08` | `'Y'` = lock row before update |

**Conditional variant** (multi-form page):

```sql
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Product Details'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P304_CONFIG'
,p_process_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_process_when2=>'Product Search Configuration'
```

### Variation D: Legacy Form Fetch (NATIVE_FORM_FETCH)

Pre-24.1 pattern (119 instances). Runs at AFTER_HEADER, specifies table/PK directly.

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(38803019855456461073)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_FORM_FETCH'
,p_process_name=>'Fetch Row from OOW_DEMO_STORES'
,p_attribute_02=>'OOW_DEMO_STORES'
,p_attribute_03=>'P7_ID'
,p_attribute_04=>'ID'
,p_attribute_11=>'I:U:D'
,p_internal_uid=>16574553282555984965
);
```

| Attribute | Purpose |
|-----------|---------|
| `p_attribute_02` | Table/view name |
| `p_attribute_03` | Item holding PK value |
| `p_attribute_04` | PK column name |
| `p_attribute_11` | Allowed operations (`'I:U:D'`) |

### Variation E: Legacy Form Process (NATIVE_FORM_PROCESS)

Pre-24.1 DML (118 instances). Runs at AFTER_SUBMIT, specifies table/PK directly.

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(38803020062939461074)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_FORM_PROCESS'
,p_process_name=>'Process Row of OOW_DEMO_STORES'
,p_attribute_02=>'OOW_DEMO_STORES'
,p_attribute_03=>'P7_ID'
,p_attribute_04=>'ID'
,p_attribute_09=>'P7_ID'
,p_attribute_11=>'I:U:D'
,p_attribute_12=>'Y'
,p_process_error_message=>'#SQLERRM#'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_process_success_message=>'Action Processed.'
,p_return_key_into_item1=>'P7_ID'
,p_internal_uid=>16574553490038984966
);
```

| Attribute | Purpose |
|-----------|---------|
| `p_attribute_02` | Table/view name |
| `p_attribute_03` | PK item |
| `p_attribute_04` | PK column |
| `p_attribute_09` | Return key item |
| `p_attribute_11` | Allowed operations |
| `p_attribute_12` | `'Y'` = use ROWID for update/delete |

### Variation F: Close Dialog (NATIVE_CLOSE_WINDOW)

Closes modal dialog (234 instances). Returns items to parent page.

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(65586372409671840)
,p_process_sequence=>60
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_01=>'P7_SHOPPING_CART_ITEMS'
,p_attribute_02=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>46389544004646737
);
```

| Attribute | Purpose |
|-----------|---------|
| `p_attribute_01` | Items to return (comma-separated) — triggers `apexafterclosedialog` on parent |
| `p_attribute_02` | `'Y'` = show success message on parent, `'N'` = silent |

**Conditional close** (after DML requests only):

```sql
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_02=>'N'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
```

### Variation G: Interactive Grid DML (NATIVE_IG_DML)

Saves IG edits (39 instances). Runs at AFTER_SUBMIT, references IG region.

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1058056317204485655)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(3389370047790689242)
,p_process_type=>'NATIVE_IG_DML'
,p_process_name=>'Interactive Grid - Save Interactive Grid Data'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>1031431515422469120
);
```

Attributes match NATIVE_FORM_DML (01=source, 05=return key, 06=ROWID, 08=lock row).

### Variation H: Session State (NATIVE_SESSION_STATE)

Clears page cache (154 instances). Typically after delete or reset button.

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(38803020268840461074)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_SESSION_STATE'
,p_process_name=>'reset page'
,p_attribute_01=>'CLEAR_CACHE_CURRENT_PAGE'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(38803016065360461053)
,p_internal_uid=>16574553695939984966
);
```

| Attribute | Purpose |
|-----------|---------|
| `p_attribute_01` | `'CLEAR_CACHE_CURRENT_PAGE'` (only observed value) |

### Variation I: Invoke API (NATIVE_INVOKE_API)

Calls a PL/SQL package procedure (30 instances). Parameters defined via companion API.

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(65614810996682085)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_INVOKE_API'
,p_process_name=>'Send Notification'
,p_attribute_01=>'PLSQL_PACKAGE'
,p_attribute_03=>'APEX_PWA'
,p_attribute_04=>'SEND_PUSH_NOTIFICATION'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(65613469148682084)
,p_process_when=>'apex_pwa.has_push_subscription'
,p_process_when_type=>'EXPRESSION'
,p_process_when2=>'PLSQL'
,p_internal_uid=>46417982591656982
);
```

| Attribute | Purpose |
|-----------|---------|
| `p_attribute_01` | `'PLSQL_PACKAGE'` |
| `p_attribute_03` | Package name |
| `p_attribute_04` | Procedure/function name |

**Companion parameter definitions:**

```sql
wwv_flow_imp_shared.create_invokeapi_comp_param(
 p_id=>wwv_flow_imp.id(65615303012682086)
,p_page_process_id=>wwv_flow_imp.id(65614810996682085)
,p_page_id=>8
,p_name=>'p_application_id'
,p_direction=>'IN'
,p_data_type=>'NUMBER'
,p_has_default=>true
,p_display_sequence=>10
,p_value_type=>'API_DEFAULT'
);
wwv_flow_imp_shared.create_invokeapi_comp_param(
 p_id=>wwv_flow_imp.id(65615809437682086)
,p_page_process_id=>wwv_flow_imp.id(65614810996682085)
,p_page_id=>8
,p_name=>'p_user_name'
,p_direction=>'IN'
,p_data_type=>'VARCHAR2'
,p_has_default=>false
,p_display_sequence=>20
,p_value_type=>'ITEM'
,p_value=>'APP_USER'
);
wwv_flow_imp_shared.create_invokeapi_comp_param(
 p_id=>wwv_flow_imp.id(65616231197682087)
,p_page_process_id=>wwv_flow_imp.id(65614810996682085)
,p_page_id=>8
,p_name=>'p_title'
,p_direction=>'IN'
,p_data_type=>'VARCHAR2'
,p_has_default=>false
,p_display_sequence=>30
,p_value_type=>'STATIC'
,p_value=>'We are preparing your order.'
);
```

| Param Attribute | Values |
|-----------------|--------|
| `p_direction` | `'IN'`, `'OUT'` |
| `p_data_type` | `'VARCHAR2'`, `'NUMBER'`, `'CLOB'`, `'BOOLEAN'` |
| `p_value_type` | `'API_DEFAULT'`, `'ITEM'`, `'STATIC'`, `'EXPRESSION'` |

### Variation J: Reset Pagination (NATIVE_RESET_PAGINATION)

Resets IR/IG pagination (6 instances).

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(17822194232786983617)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_RESET_PAGINATION'
,p_process_name=>'Reset Pagination'
,p_process_sql_clob=>'reset_pagination'
,p_attribute_01=>'THIS_PAGE'
,p_process_error_message=>'Unable to reset pagination.'
,p_process_when=>'Go,P1_REPORT_SEARCH,RESET'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_internal_uid=>17798794559773218133
);
```

| Attribute | Purpose |
|-----------|---------|
| `p_attribute_01` | `'THIS_PAGE'` (reset pagination on current page) |

### Variation K: Manage Task (NATIVE_MANAGE_TASK)

Approval workflow task operations (37 instances). Each action type uses different attributes.

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(17830447096186045)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_MANAGE_TASK'
,p_process_name=>'Approve'
,p_attribute_01=>'APPROVE_TASK'
,p_attribute_02=>'P2_TASK_ID'
,p_process_error_message=>'#SQLERRM_TEXT#'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(17807680557186026)
,p_process_success_message=>'Task approved'
,p_internal_uid=>3887832473497925
);
```

| Attribute | Purpose |
|-----------|---------|
| `p_attribute_01` | Action: `APPROVE_TASK`, `REJECT_TASK`, `CLAIM_TASK`, `RELEASE_TASK`, `DELEGATE_TASK`, `CANCEL_TASK`, `RENEW_TASK`, `SET_TASK_PRIORITY`, `SET_DUE_DATE`, `REQUEST_INFO`, `SUBMIT_INFO`, `ADD_TASK_POTENTIAL_OWNER`, `REMOVE_POTENTIAL_OWNER`, `SET_TASK_PARAMS`, `ADD_TASK_COMMENT` |
| `p_attribute_02` | Task ID item |
| `p_attribute_03` | Comment/info text (for REQUEST_INFO, SUBMIT_INFO, ADD_TASK_COMMENT) |
| `p_attribute_04` | User item (for DELEGATE_TASK, ADD/REMOVE_POTENTIAL_OWNER) |
| `p_attribute_05` | Priority item (for SET_TASK_PRIORITY) |
| `p_attribute_06` | Due date item (for SET_DUE_DATE) |
| `p_attribute_10` | Parameter static ID item (for SET_TASK_PARAMS) |
| `p_attribute_11` | Parameter value item (for SET_TASK_PARAMS) |

### Variation L: Workflow (NATIVE_WORKFLOW)

Starts/manages APEX workflows (16 instances).

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(106479975373449645)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_WORKFLOW'
,p_process_name=>'Start a new workflow'
,p_attribute_01=>'START'
,p_attribute_02=>wwv_flow_imp.id(106434975918567266)
,p_attribute_04=>'P407_WF_ID'
,p_process_error_message=>'Error'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Workflow started'
,p_internal_uid=>7716596994107023
);
```

| Attribute | Purpose |
|-----------|---------|
| `p_attribute_01` | Action: `'START'` |
| `p_attribute_02` | Workflow definition ID |
| `p_attribute_04` | Item to receive workflow instance ID |

**Companion parameter definitions:**

```sql
wwv_flow_imp_shared.create_workflow_comp_param(
 p_id=>wwv_flow_imp.id(106480029961449646)
,p_page_process_id=>wwv_flow_imp.id(106479975373449645)
,p_workflow_variable_id=>wwv_flow_imp.id(106477877692449624)
,p_page_id=>407
,p_value_type=>'ITEM'
,p_value=>'P407_PRODUCT_ID'
);
```

### Variation M: Data Loading (NATIVE_DATA_LOADING)

Loads file/text/SQL data into a table (6 instances). Often a child of NATIVE_EXECUTION_CHAIN.

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(3334176026331226943)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_DATA_LOADING'
,p_process_name=>'Load File Data'
,p_attribute_01=>wwv_flow_imp.id(3342179718735824423)
,p_attribute_02=>'FILE'
,p_attribute_03=>'P11_FILE'
,p_attribute_08=>'P11_FILE_ERROR_ROW_COUNT'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(3334176944389226944)
,p_process_when=>'P11_FILE'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>1658647059508735399
);
```

| Attribute | Purpose |
|-----------|---------|
| `p_attribute_01` | Data load definition ID |
| `p_attribute_02` | Source: `'FILE'`, `'TEXT'`, `'SQL_QUERY'` |
| `p_attribute_03` | File browse item (when FILE) |
| `p_attribute_04` | Text item (when TEXT) |
| `p_attribute_05` | SQL query (when SQL_QUERY) |
| `p_attribute_07` | Item for processed row count |
| `p_attribute_08` | Item for error row count |

### Variation N: Execution Chain (NATIVE_EXECUTION_CHAIN)

Groups child processes, optionally runs in background (4 instances).

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1831687245623324467)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_EXECUTION_CHAIN'
,p_process_name=>'Load Data Background'
,p_attribute_01=>'Y'
,p_attribute_02=>'Y'
,p_attribute_03=>'P17_LOAD_EXEC_ID'
,p_attribute_04=>'MOVE'
,p_attribute_05=>'P17_FILE'
,p_attribute_06=>'1'
,p_attribute_08=>'WAIT'
,p_attribute_09=>'Y'
,p_process_error_message=>'Only one file can be loaded at a time.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(3337481622096421835)
,p_process_when=>'P17_FILE'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_process_success_message=>'Data Loading task kicked off for execution.'
,p_internal_uid=>156156947944832923
);
```

Child processes use `p_parent_process_id` to reference the chain:

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1831687380093324469)
,p_process_sequence=>10
,p_parent_process_id=>wwv_flow_imp.id(1831687312358324468)
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Unpack ZIP Archive'
...
);
```

| Attribute | Purpose |
|-----------|---------|
| `p_attribute_01` | `'Y'` = run in background, `'N'` = synchronous |
| `p_attribute_02` | `'Y'` = show progress, `'N'` = silent |
| `p_attribute_03` | Item for execution ID |
| `p_attribute_04` | File handling: `'MOVE'`, `'IGNORE'` |
| `p_attribute_05` | File item |
| `p_attribute_06` | Max concurrent executions |
| `p_attribute_08` | Duplicate policy: `'WAIT'` |
| `p_attribute_09` | `'Y'` = auto-purge completed |

## Condition Types (p_process_when_type)

| Value | p_process_when | p_process_when2 | Description |
|-------|---------------|-----------------|-------------|
| `REQUEST_IN_CONDITION` | `'CREATE,SAVE,DELETE'` | — | Request matches any in comma list (125 uses) |
| `REQUEST_EQUALS_CONDITION` | `'RENEW'` | — | Request exactly equals value (36) |
| `EXPRESSION` | PL/SQL expression | `'PLSQL'` | Boolean PL/SQL expression (28) |
| `ITEM_IS_NOT_NULL` | `'P11_FILE'` | — | Item has a value (20) |
| `VAL_OF_ITEM_IN_COND_EQ_COND2` | `'P304_CONFIG'` | `'Product Search...'` | Item value equals literal (16) |
| `REQUEST_NOT_IN_CONDITION` | `'CLAIM,SET_PRIORITY,...'` | — | Request NOT in comma list (5) |
| `REQUEST_NOT_EQUAL_CONDITION` | `'DELETE'` | — | Request does not equal value (5) |
| `FUNCTION_BODY` | PL/SQL function body | — | Returns boolean (6) |
| `EXISTS` | SQL query | — | Query returns at least one row (4) |
| `ITEM_IS_NULL` | `'P5_ID'` | — | Item has no value (2) |
| `NEVER` | — | — | Process disabled (2) |
| `NOT_EXISTS` | SQL query | — | Query returns no rows (1) |
| `VAL_OF_ITEM_IN_COND_NOT_EQ_COND2` | item | value | Item value does not equal literal (1) |
| *(button only)* | — | — | Use `p_process_when_button_id` alone (most common for simple button triggers) |

## Parameter Value Catalog

| Parameter | All Observed Values |
|-----------|-------------------|
| `p_process_type` | `NATIVE_PLSQL` (607), `NATIVE_CLOSE_WINDOW` (234), `NATIVE_SESSION_STATE` (154), `NATIVE_FORM_FETCH` (119), `NATIVE_FORM_PROCESS` (118), `NATIVE_FORM_INIT` (96), `NATIVE_FORM_DML` (81), `NATIVE_IG_DML` (39), `NATIVE_MANAGE_TASK` (37), `NATIVE_INVOKE_API` (30), `NATIVE_WORKFLOW` (16), `NATIVE_RESET_PAGINATION` (6), `NATIVE_DATA_LOADING` (6), `NATIVE_PARSE_UPLOADED_DATA` (5), `NATIVE_LOAD_UPLOADED_DATA` (5), `NATIVE_EXECUTION_CHAIN` (4), `PLUGIN_COM.ORACLE.APEX.DOCGEN` (3), `NATIVE_CREATE_TASK` (3), `NATIVE_FORM_PAGINATION` (1) |
| `p_process_point` | `AFTER_SUBMIT` (1148), `BEFORE_HEADER` (222), `AFTER_HEADER` (162), `ON_SUBMIT_BEFORE_COMPUTATION` (11), `BEFORE_BOX_BODY` (8), `ON_DEMAND` (3) |
| `p_process_when_type` | `REQUEST_IN_CONDITION` (125), `REQUEST_EQUALS_CONDITION` (36), `EXPRESSION` (28), `ITEM_IS_NOT_NULL` (20), `VAL_OF_ITEM_IN_COND_EQ_COND2` (16), `FUNCTION_BODY` (6), `REQUEST_NOT_IN_CONDITION` (5), `REQUEST_NOT_EQUAL_CONDITION` (5), `EXISTS` (4), `NEVER` (2), `ITEM_IS_NULL` (2), `VAL_OF_ITEM_IN_COND_NOT_EQ_COND2` (1), `NOT_EXISTS` (1) |
| `p_error_display_location` | `INLINE_IN_NOTIFICATION` (1189), `INLINE_WITH_FIELD_AND_NOTIFICATION` (276), `INLINE_WITH_FIELD` (18) |

## Common Page Patterns

### Modal Form Page (modern)

Standard sequence for a dialog form page:

```
Seq 10  BEFORE_HEADER   NATIVE_FORM_INIT     — Initialize form from region source
Seq 20  AFTER_SUBMIT    NATIVE_FORM_DML      — Insert/update/delete
Seq 50  AFTER_SUBMIT    NATIVE_CLOSE_WINDOW  — Close dialog (when CREATE,SAVE,DELETE)
```

### Modal Form Page (legacy)

```
Seq 10  AFTER_HEADER    NATIVE_FORM_FETCH    — Fetch row from table
Seq 20  AFTER_SUBMIT    NATIVE_FORM_PROCESS  — Process DML (when CREATE,SAVE,DELETE)
Seq 30  AFTER_SUBMIT    NATIVE_SESSION_STATE — Clear cache (on delete button)
Seq 40  AFTER_SUBMIT    NATIVE_CLOSE_WINDOW  — Close dialog
```

### IG Edit Page

```
Seq 10  AFTER_SUBMIT    NATIVE_IG_DML        — Save grid changes (region_id required)
```

### Task Management Page

```
Seq 10-150  AFTER_SUBMIT  NATIVE_MANAGE_TASK — One process per action (claim, approve, reject, delegate, etc.)
Seq 160     AFTER_SUBMIT  NATIVE_CLOSE_WINDOW — Close dialog (exclude non-closing actions)
```

## Relationships

- **Parent**: page
- **Depends on**: buttons (`p_process_when_button_id`), regions (`p_region_id` for form/IG), other processes (`p_parent_process_id` for execution chains)
- **Companion APIs**: `create_invokeapi_comp_param` (for NATIVE_INVOKE_API), `create_workflow_comp_param` (for NATIVE_WORKFLOW)
- **Triggers**: `apexafterclosedialog` on parent page (from NATIVE_CLOSE_WINDOW with return items)
