# Dynamic Actions (DA) Patterns

Patterns from APEX 24.2 exports (Apps 101-104, 119 pages with DAs).

## DA Event Structure

```sql
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(441310379441325900)
,p_name=>'Sort Ascending'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'   -- BUTTON | ITEM | REGION | COLUMN | JQUERY_SELECTOR | (omit for page-level)
,p_triggering_button_id=>wwv_flow_imp.id(441309972698325896)  -- For BUTTON triggers
,p_triggering_element=>'P3_STATUS'     -- For ITEM (name) / COLUMN (name) / JQUERY_SELECTOR (CSS selector)
,p_triggering_region_id=>wwv_flow_imp.id(2681613203969354879) -- For REGION / COLUMN triggers
,p_condition_element=>'P25_SKIP_GAP'   -- Optional: item to evaluate condition against
,p_triggering_condition_type=>'EQUALS' -- EQUALS | JAVASCRIPT_EXPRESSION | (omit = unconditional)
,p_triggering_expression=>'Y'          -- Value to compare or JS expression
,p_bind_type=>'bind'                   -- 'bind' (standard) | 'live' (event delegation)
,p_bind_delegate_to_selector=>'#myIRR' -- Required when bind_type='live'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'            -- click | change | ready | apexafterclosedialog | apexafterrefresh | keydown | custom | IG compound
,p_bind_event_type_custom=>'apexendrecordedit' -- Only when bind_event_type='custom'
,p_display_when_type=>'NEVER'          -- Optional: server-side suppression
);
```

## DA Action Structure

```sql
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(441310496688325901)
,p_event_id=>wwv_flow_imp.id(441310379441325900)
,p_event_result=>'TRUE'                -- TRUE | FALSE (which branch)
,p_action_sequence=>10
,p_execute_on_page_init=>'N'           -- Y = also run on page load
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'REGION'    -- REGION | ITEM | BUTTON | JQUERY_SELECTOR | (omit if N/A)
,p_affected_region_id=>wwv_flow_imp.id(440657661853405789)
,p_affected_elements=>'P4_PRODUCT_NAME'  -- For ITEM / JQUERY_SELECTOR (comma-separated for multiple)
,p_attribute_01=>'...'                 -- Action-specific
,p_server_condition_type=>'NEVER'      -- Optional: disable action server-side
,p_wait_for_result=>'Y'               -- For async actions (set value, PL/SQL)
);
```

## Triggering Element Types

### BUTTON Trigger

Button must have `p_button_action=>'DEFINED_BY_DA'`.

```sql
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(454937267045870444)
,p_name=>'Straight'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(454922971674870398)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
```

### ITEM Trigger

```sql
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(2148373988059376889)
,p_name=>'Refresh Report'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P3_STATUS'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
```

### REGION Trigger

Used for `apexafterclosedialog`, `apexafterrefresh`, and IG events.

```sql
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(223925996987124446)
,p_name=>'Refresh on Edit'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(2681613203969354879)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
```

### COLUMN Trigger (IG/IR)

Requires both `p_triggering_region_id` and `p_triggering_element` (column name).

```sql
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(747834166734545948)
,p_name=>'Validate SAL'
,p_event_sequence=>10
,p_triggering_element_type=>'COLUMN'
,p_triggering_region_id=>wwv_flow_imp.id(2153848615348890246)
,p_triggering_element=>'SAL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
```

### JQUERY_SELECTOR Trigger

```sql
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(15053902914143073551)
,p_name=>'Toggle Reference Type Checkboxes'
,p_event_sequence=>224
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'#reference_check_box'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'$(this.triggeringElement).text() === "Check All"'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
```

### Page Load (ready) Trigger

No triggering element type. Can have JS condition.

```sql
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(3265224296392205864)
,p_name=>'Set Focus'
,p_event_sequence=>10
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'( $v( "P101_USERNAME" ) === "" )'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
```

Variant with `live` binding: set `p_bind_type=>'live'` (no condition needed).

## Bind Event Types

- **click** -- BUTTON, JQUERY_SELECTOR triggers
- **change** -- ITEM, COLUMN, JQUERY_SELECTOR triggers
- **ready** -- Page load, no triggering element needed
- **apexafterclosedialog** -- Fires on parent region when modal child closes. REGION trigger.
- **apexafterrefresh** -- Fires after region AJAX refresh. REGION trigger.
- **keydown** -- Typically with JS condition for key filtering (e.g., Enter)
- **IG Selection Change** -- Format: `NATIVE_IG|REGION TYPE|interactivegridselectionchange`. REGION trigger.
- **custom** -- Requires `p_bind_event_type_custom` (e.g., `'apexendrecordedit'`)

## Bind Types

| `p_bind_type` | When to use |
|---|---|
| `'bind'` | Default. Element must exist at page load. |
| `'live'` | Event delegation for dynamic DOM. Requires `p_bind_delegate_to_selector`. |

```sql
-- Live binding example (checkboxes in paginated IR)
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'#selectUnselectAll'
,p_bind_type=>'live'
,p_bind_delegate_to_selector=>'#productsIRR'
```

## Event Conditions

### EQUALS Condition

```sql
,p_condition_element=>'P35_AC_ENABLED'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
```

When TRUE: `p_event_result=>'TRUE'` actions fire. When FALSE: `p_event_result=>'FALSE'` actions fire.

### JAVASCRIPT_EXPRESSION Condition

```sql
-- Simple
,p_triggering_expression=>'( $v( "P101_USERNAME" ) === "" )'

-- Enter key detection
,p_triggering_expression=>'this.browserEvent.which === 13'

-- Multi-line (single quotes escaped as '' in wwv_flow_string.join)
,p_triggering_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'($v(''P35_HIDDEN_AC_ENABLED'') !== $v(''P35_AC_ENABLED'') &&',
' $v(''P35_AC_ENABLED'') === ''Y'')',
''))

-- Triggering element text
,p_triggering_expression=>'$(this.triggeringElement).text() === "Check All"'
```

### No Condition (Always Fire)

Omit `p_triggering_condition_type`. Only TRUE actions execute.

## TRUE / FALSE Branching

When a condition is set, separate actions for TRUE and FALSE outcomes enable toggle behavior:

```sql
-- FALSE branch: hide
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15987801934005670033)
,p_event_id=>wwv_flow_imp.id(15987801604570670033)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P35_ACCESS_CONTROL_SCOPE'
,p_attribute_01=>'N'
);

-- TRUE branch: show
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15987802131077670034)
,p_event_id=>wwv_flow_imp.id(15987801604570670033)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P35_ACCESS_CONTROL_SCOPE'
,p_attribute_01=>'N'
);
```

Both TRUE and FALSE actions can use `p_execute_on_page_init=>'Y'` for correct initial state.

## Action Types

### NATIVE_JAVASCRIPT_CODE

```sql
-- Simple one-liner
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(440657661853405789)
,p_attribute_01=>'apex.region("donut1").widget().ojChart({sorting:''ascending''});'
```

```sql
-- Multi-line with wwv_flow_string.join
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'$(".reference_types_checkbox input[type=checkbox]").prop(''checked'',true);',
'$(this.triggeringElement).text(''Uncheck All'');'))
```

jQuery selector affected elements use `this.affectedElements`:
```sql
,p_affected_elements_type=>'JQUERY_SELECTOR'
,p_affected_elements=>'#P118_PAGE_ID_DISPLAY'
,p_attribute_01=>'this.affectedElements.html(this.affectedElements.html().replace(''&amp;APPLICATION_TITLE.'',''''));'
```

### NATIVE_REFRESH

```sql
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(814897255001983598)
,p_attribute_01=>'N'
```

Refresh multiple regions via jQuery selector:
```sql
,p_affected_elements_type=>'JQUERY_SELECTOR'
,p_affected_elements=>'#CARDS, #LOGOS, #CUSTOMERS'
,p_attribute_01=>'N'
```

`p_attribute_01`: `'N'` (standard) or `'Y'` (defer). Region must have `p_ajax_enabled=>'Y'`.

### NATIVE_SET_VALUE

**SQL_STATEMENT source:**
```sql
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_PRODUCT_NAME'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select product_name from eba_demo_chart_products',
'where product_id = :P4_PRODUCT_ID'))
,p_attribute_07=>'P4_PRODUCT_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
```

**STATIC_ASSIGNMENT source:**
```sql
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'PASTE'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
```

**JAVASCRIPT_EXPRESSION source:**
```sql
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>'$v(''P60_COPY_PASTE'')'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
```

Attribute reference:

| Attr | Purpose |
|---|---|
| `p_attribute_01` | Source type: `SQL_STATEMENT`, `STATIC_ASSIGNMENT`, `JAVASCRIPT_EXPRESSION`, `PLSQL_EXPRESSION`, `PLSQL_FUNCTION_BODY`, `DIALOG_RETURN_VALUE` |
| `p_attribute_02` | Static value |
| `p_attribute_03` | SQL query |
| `p_attribute_04` | PL/SQL expression or function body |
| `p_attribute_05` | JS expression |
| `p_attribute_07` | Items to submit (comma-separated) |
| `p_attribute_08` | Escape special characters (`Y`/`N`) |
| `p_attribute_09` | Suppress change event (`Y`=suppress, `N`=fire) |

### NATIVE_SHOW / NATIVE_HIDE

```sql
,p_action=>'NATIVE_SHOW'   -- or NATIVE_HIDE
,p_affected_elements_type=>'ITEM'   -- or REGION
,p_affected_elements=>'P60_COPY_PASTE'
,p_attribute_01=>'Y'   -- Y = include label (items); N = element container only
```

### NATIVE_SUBMIT_PAGE

```sql
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'APPLY_CHANGES_AC_ENABLED'  -- Request value (for process conditions)
,p_attribute_02=>'Y'                          -- Show processing indicator
```

### NATIVE_EXECUTE_PLSQL_CODE

**Push item to session state (null; pattern):**
```sql
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'null;'
,p_attribute_02=>'P117_SHOW_VIEWS'   -- items to submit
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
```

**Full PL/SQL with items to submit and return:**
```sql
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'for c1 in ( select nvl2(a.activity_date,''N'',''Y'') show_activity_date,',
'                nvl2(a.owner,''N'',''Y'') show_owner,',
'                nvl2(a.location,''N'',''Y'') show_location',
'            from eba_cust_activities a',
'            where a.id = :P150_ACTIVITY_ID ) loop',
'    :P150_SHOW_DATE := c1.show_activity_date;',
'    :P150_SHOW_OWNER := c1.show_owner;',
'    :P150_SHOW_LOCATION := c1.show_location;',
'end loop;'))
,p_attribute_02=>'P150_ACTIVITY_ID'
,p_attribute_03=>'P150_SHOW_DATE,P150_SHOW_OWNER,P150_SHOW_LOCATION'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
```

| Attr | Purpose |
|---|---|
| `p_attribute_01` | PL/SQL code block |
| `p_attribute_02` | Items to Submit (comma-separated) |
| `p_attribute_03` | Items to Return (comma-separated) |
| `p_attribute_04` | Suppress change event on returned items |
| `p_attribute_05` | `'PLSQL'` |

### NATIVE_CONFIRM

Shows browser confirm dialog. Cancel skips remaining actions.

```sql
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure you want to disable Access Control?'
```

### NATIVE_SET_FOCUS

```sql
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P101_USERNAME'
```

### NATIVE_CLEAR

```sql
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P59_SEARCH,P59_GEO,P59_INDUSTRY,P59_CATEGORY,P59_STATUS'
```

### NATIVE_CANCEL_EVENT

Prevents default browser action. No attributes needed.

### NATIVE_DIALOG_CANCEL

Closes modal dialog without returning values. No attributes.

### NATIVE_DIALOG_CLOSE

Closes dialog and returns values to parent (triggers `apexafterclosedialog`). No attributes (return items configured on dialog page properties).

## Affected Element Types

| Type | Target Parameter |
|---|---|
| `REGION` | `p_affected_region_id` |
| `ITEM` | `p_affected_elements` (comma-separated names) |
| `BUTTON` | `p_affected_button_id` |
| `JQUERY_SELECTOR` | `p_affected_elements` (CSS selector) |
| (omitted) | For DIALOG_CANCEL, DIALOG_CLOSE, CONFIRM, CANCEL_EVENT |

## Common Patterns

### Modal Dialog Cancel

Every modal form page: CANCEL button + DA + DIALOG_CANCEL.

```sql
-- Button
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(15866010771070444680)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(1678029143690386912)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'PREVIOUS'
,p_warn_on_unsaved_changes=>null
);

-- Event
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(1678028931148386910)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(15866010771070444680)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);

-- Action
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(1678029092320386911)
,p_event_id=>wwv_flow_imp.id(1678028931148386910)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
```

### Dialog Workflow (Parent + Child)

```
Parent page (Region with link)
  |-> Opens dialog page (modal)
       |-> Cancel button -> NATIVE_DIALOG_CANCEL
       |-> Save process  -> NATIVE_DIALOG_CLOSE (after submit)
  |<- apexafterclosedialog fires on parent region
       |-> NATIVE_REFRESH on the same region
```

Parent page refresh pattern:
```sql
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(223926222511124448)
,p_name=>'Refresh on Edit'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(2573278322369354707)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(223926281169124449)
,p_event_id=>wwv_flow_imp.id(223926222511124448)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(2573278322369354707)
,p_attribute_01=>'N'
);
```

### Show/Hide Toggle on Item Change

Uses TRUE/FALSE branching with `p_execute_on_page_init=>'Y'`:

```sql
-- Event: condition checks if value = 'PASTE'
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P60_IMPORT_FROM'
,p_condition_element=>'P60_IMPORT_FROM'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'PASTE'

-- TRUE: NATIVE_SHOW on P60_COPY_PASTE (p_execute_on_page_init=>'Y')
-- FALSE: NATIVE_HIDE on P60_COPY_PASTE (p_execute_on_page_init=>'Y')
```

### Conditional Show/Hide Driven by PL/SQL

Two-step: (1) PL/SQL computes flag items, (2) Change events on flags show/hide fields.

```
Event 1: Change on P150_ACTIVITY_ID
  Action: NATIVE_EXECUTE_PLSQL_CODE (submit: ID, return: SHOW_DATE, SHOW_OWNER, SHOW_LOCATION)

Event 2-4: Change on each SHOW_* flag (condition: EQUALS 'Y')
  TRUE:  NATIVE_SHOW target field
  FALSE: NATIVE_HIDE target field
```

### Report Refresh on Item Change

Region uses `p_ajax_items_to_submit`. DA on item change fires NATIVE_REFRESH.

### Search-on-Enter

```sql
-- keydown on search item, JS condition for Enter key
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'this.browserEvent.which === 13'
,p_bind_event_type=>'keydown'
-- Actions: NATIVE_REFRESH (seq 10, 20), NATIVE_CANCEL_EVENT (seq 30)
```

### PL/SQL Session State Sync

`null;` PL/SQL with items to submit pushes values to session state, followed by NATIVE_REFRESH.

### Confirm Then Submit

Seq 10: NATIVE_CONFIRM, Seq 20: NATIVE_SUBMIT_PAGE. If user cancels, submit is skipped.

### Multiple Actions Per Event

Actions execute in `p_action_sequence` order within same branch. Use `p_wait_for_result=>'Y'` on async actions.

### IG Column Validation

Column-level change with client-side JS:

```sql
-- Single field validation
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var sal = apex.item("cSal"),',
'    num = sal.getValue();',
'if ( num !== "" && (parseFloat(num) != num || num < 0 || num > 10000)) {',
'    sal.node.setCustomValidity("invalid number");',
'} else {',
'    sal.node.setCustomValidity("");',
'}'))
```

Cross-field via `apexendrecordedit` custom event:
```sql
,p_bind_event_type=>'custom'
,p_bind_event_type_custom=>'apexendrecordedit'
-- Action uses: ui.model.setValidity(validity, ui.recordId, null, message);
```
