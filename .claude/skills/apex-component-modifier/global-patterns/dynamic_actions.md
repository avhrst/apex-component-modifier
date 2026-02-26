# Dynamic Actions (DA) -- Extracted Patterns

Patterns extracted from APEX 24.2 export files across Apps 101-104.

> Coverage: f101 (13 pages with DAs), f102 (8 pages), f103 (9 pages), f104 (89 pages) -- 119 pages total.

---

## Table of Contents

- [DA Event Structure](#da-event-structure)
- [DA Action Structure](#da-action-structure)
- [Triggering Element Types](#triggering-element-types)
  - [BUTTON Trigger](#button-trigger)
  - [ITEM Trigger](#item-trigger)
  - [REGION Trigger](#region-trigger)
  - [COLUMN Trigger (IG/IR)](#column-trigger-igir)
  - [JQUERY_SELECTOR Trigger](#jquery_selector-trigger)
  - [Page Load (ready) Trigger](#page-load-ready-trigger)
- [Bind Event Types](#bind-event-types)
  - [click](#click)
  - [change](#change)
  - [ready (Page Load)](#ready-page-load)
  - [apexafterclosedialog (Dialog Closed)](#apexafterclosedialog-dialog-closed)
  - [apexafterrefresh (After Refresh)](#apexafterrefresh-after-refresh)
  - [keydown](#keydown)
  - [IG Selection Change](#ig-selection-change)
  - [custom](#custom)
- [Bind Types](#bind-types)
- [Event Conditions](#event-conditions)
  - [EQUALS Condition](#equals-condition)
  - [JAVASCRIPT_EXPRESSION Condition](#javascript_expression-condition)
  - [No Condition (Always Fire)](#no-condition-always-fire)
- [TRUE / FALSE Branching](#true--false-branching)
- [Action Types](#action-types)
  - [NATIVE_JAVASCRIPT_CODE](#native_javascript_code)
  - [NATIVE_REFRESH](#native_refresh)
  - [NATIVE_SET_VALUE](#native_set_value)
  - [NATIVE_SHOW](#native_show)
  - [NATIVE_HIDE](#native_hide)
  - [NATIVE_SUBMIT_PAGE](#native_submit_page)
  - [NATIVE_EXECUTE_PLSQL_CODE](#native_execute_plsql_code)
  - [NATIVE_CONFIRM](#native_confirm)
  - [NATIVE_SET_FOCUS](#native_set_focus)
  - [NATIVE_CLEAR](#native_clear)
  - [NATIVE_CANCEL_EVENT](#native_cancel_event)
  - [NATIVE_DIALOG_CANCEL](#native_dialog_cancel)
  - [NATIVE_DIALOG_CLOSE](#native_dialog_close)
- [Server-side Conditions on Actions](#server-side-conditions-on-actions)
- [Display When Conditions on Events](#display-when-conditions-on-events)
- [Affected Element Types](#affected-element-types)
- [Multiple Actions Per Event](#multiple-actions-per-event)
- [Common Patterns](#common-patterns)
  - [Modal Dialog Cancel](#modal-dialog-cancel)
  - [Dialog Workflow (Parent + Child)](#dialog-workflow-parent--child)
  - [Show/Hide Toggle on Item Change](#showhide-toggle-on-item-change)
  - [Conditional Show/Hide Driven by PL/SQL](#conditional-showhide-driven-by-plsql)
  - [Chart JS Modification via Button](#chart-js-modification-via-button)
  - [Master-Detail Chart Refresh](#master-detail-chart-refresh)
  - [Report Refresh on Item Change](#report-refresh-on-item-change)
  - [Refresh on Dialog Close](#refresh-on-dialog-close)
  - [Search-on-Enter](#search-on-enter)
  - [PL/SQL Session State Sync](#plsql-session-state-sync)
  - [Confirm Then Submit](#confirm-then-submit)
  - [Set Value Then Execute PL/SQL Then Submit](#set-value-then-execute-plsql-then-submit)
  - [IG Column Validation](#ig-column-validation)

---

## DA Event Structure

Every Dynamic Action begins with `create_page_da_event`:

```sql
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(441310379441325900)
,p_name=>'Sort Ascending'              -- Display name (for dev reference)
,p_event_sequence=>10                  -- Order on the page (10, 20, 30, ...)
,p_triggering_element_type=>'BUTTON'   -- BUTTON | ITEM | REGION | COLUMN | JQUERY_SELECTOR | (omit for page-level)
,p_triggering_button_id=>wwv_flow_imp.id(441309972698325896)  -- For BUTTON triggers
-- OR --
,p_triggering_element=>'P3_STATUS'     -- For ITEM triggers (item name) / COLUMN (column name) / JQUERY_SELECTOR (CSS selector)
-- OR --
,p_triggering_region_id=>wwv_flow_imp.id(2681613203969354879) -- For REGION / COLUMN triggers
,p_condition_element=>'P25_SKIP_GAP'   -- Optional: item to evaluate condition against
,p_triggering_condition_type=>'EQUALS' -- Optional: EQUALS | JAVASCRIPT_EXPRESSION
,p_triggering_expression=>'Y'          -- Optional: value to compare or JS expression
,p_bind_type=>'bind'                   -- 'bind' (standard) or 'live' (event delegation)
,p_bind_delegate_to_selector=>'#myIRR' -- Required when bind_type='live' with a delegate container
,p_execution_type=>'IMMEDIATE'         -- Always 'IMMEDIATE' in observed patterns
,p_bind_event_type=>'click'            -- click | change | ready | apexafterclosedialog | apexafterrefresh | keydown | custom | IG compound types
,p_bind_event_type_custom=>'apexendrecordedit' -- Only when bind_event_type='custom'
,p_display_when_type=>'NEVER'          -- Optional: server-side condition to suppress entire event
);
```

### Key parameters

| Parameter | Values | Notes |
|-----------|--------|-------|
| `p_triggering_element_type` | `BUTTON`, `ITEM`, `REGION`, `COLUMN`, `JQUERY_SELECTOR` | Omit for page-level events (`ready`) |
| `p_bind_event_type` | `click`, `change`, `ready`, `apexafterclosedialog`, `apexafterrefresh`, `keydown`, `custom`, IG compound | Matches the trigger type |
| `p_bind_event_type_custom` | Any DOM event name string | Only set when `p_bind_event_type=>'custom'` |
| `p_triggering_condition_type` | `EQUALS`, `JAVASCRIPT_EXPRESSION` | Optional; omit for unconditional |
| `p_triggering_expression` | String value or JS expression | Required when condition_type is set |
| `p_bind_type` | `'bind'`, `'live'` | `'live'` for dynamic DOM / event delegation |
| `p_bind_delegate_to_selector` | CSS selector string | Required with `p_bind_type=>'live'` when delegating |
| `p_execution_type` | `IMMEDIATE` | Standard in all observed patterns |
| `p_display_when_type` | `NEVER`, `ITEM_IS_NOT_NULL`, etc. | Server-side; suppresses entire event |

---

## DA Action Structure

Each event has one or more actions via `create_page_da_action`:

```sql
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(441310496688325901)
,p_event_id=>wwv_flow_imp.id(441310379441325900)  -- Links to parent event
,p_event_result=>'TRUE'                -- TRUE | FALSE (which branch)
,p_action_sequence=>10                 -- Order within the branch (10, 20, 30, ...)
,p_execute_on_page_init=>'N'           -- Y = run on page load; N = only on event
,p_action=>'NATIVE_JAVASCRIPT_CODE'    -- Action type
,p_affected_elements_type=>'REGION'    -- REGION | ITEM | BUTTON | JQUERY_SELECTOR | (omit if not applicable)
,p_affected_region_id=>wwv_flow_imp.id(440657661853405789)  -- For REGION target
-- OR --
,p_affected_elements=>'P4_PRODUCT_NAME'  -- For ITEM / JQUERY_SELECTOR target (comma-separated for multiple items)
,p_attribute_01=>'...'                 -- Action-specific attributes (vary by type)
,p_attribute_02=>'...'
,p_attribute_03=>'...'
,p_server_condition_type=>'NEVER'      -- Optional: disable this action server-side
,p_da_action_comment=>'...'            -- Optional: developer comment
,p_wait_for_result=>'Y'               -- For async actions (set value, PL/SQL)
);
```

---

## Triggering Element Types

### BUTTON Trigger

Fires on button click. The button must have `p_button_action=>'DEFINED_BY_DA'`.

```sql
-- Button definition (required: action = DEFINED_BY_DA)
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(454922971674870398)
,p_button_name=>'Straight'
,p_button_action=>'DEFINED_BY_DA'            -- Required for DA-triggered buttons
,p_warn_on_unsaved_changes=>null              -- Typically null for DA buttons
);

-- DA event referencing the button
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

Fires on item value change. Most common for select lists, checkboxes, yes/no, and hidden items.

```sql
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(2148373988059376889)
,p_name=>'Refresh Report'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P3_STATUS'       -- Item name (not ID)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
```

### REGION Trigger

Fires on region-level events. Used for `apexafterclosedialog`, `apexafterrefresh`, and IG events.

```sql
-- Dialog close event on a region
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

```sql
-- After Refresh event on a region (f103/page_00011)
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(1321637501663555166)
,p_name=>'get chart data from IR result'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(1321202200449048756)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterrefresh'
);
```

### COLUMN Trigger (IG/IR)

Fires on value change of a specific column within an Interactive Grid. Requires both `p_triggering_region_id` and `p_triggering_element` (column name).

```sql
-- From f102/page_00051 (IG column validation)
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

Fires on any DOM element matching a CSS/jQuery selector. Used for non-standard APEX elements.

```sql
-- From f104/page_00059 (custom checkbox link)
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

Fires on page load. No triggering element type set; uses `p_bind_event_type=>'ready'`. Can have a JS expression condition.

```sql
-- From f101/page_00101 (login page -- conditional focus)
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

Page Load with `live` binding and no condition:

```sql
-- From f104/page_00118 (DOM manipulation on load)
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(18752644998673005355)
,p_name=>'Remove APP_TITLE from page titles'
,p_event_sequence=>10
,p_bind_type=>'live'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
```

---

## Bind Event Types

### click

Standard DOM click event. Used with BUTTON, JQUERY_SELECTOR triggers.

### change

DOM change event. Used with ITEM, COLUMN, JQUERY_SELECTOR triggers. Fires when the element's value changes.

### ready (Page Load)

Fires when the page DOM is ready. No triggering element needed. Equivalent to `$(document).ready()`.

### apexafterclosedialog (Dialog Closed)

APEX-specific event. Fires on a parent page region when a modal/dialog child page closes. Used with REGION triggers.

### apexafterrefresh (After Refresh)

APEX-specific event. Fires on a region after an AJAX refresh completes. Used to re-apply UI customizations after the DOM is rebuilt.

```sql
-- From f101/page_00046 (reapply chart converter after refresh)
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(23828489801764759)
,p_name=>'Set Custom y-axis Tick Label Converter'
,p_event_sequence=>50
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(695879223672124216)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterrefresh'
);
```

### keydown

DOM keydown event. Typically combined with a JS condition to filter for specific keys (e.g., Enter).

```sql
-- From f104/page_00059 (search on Enter key)
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(15699306750012280614)
,p_name=>'Perform Search on Enter'
,p_event_sequence=>60
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P59_SEARCH'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'this.browserEvent.which === 13'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'keydown'
,p_display_when_type=>'NEVER'
);
```

### IG Selection Change

IG-specific compound event type. Uses the format `NATIVE_IG|REGION TYPE|interactivegridselectionchange`.

```sql
-- From f102/page_00008 (IG selection drives chart refresh)
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(1367139036076438853)
,p_name=>'update chart'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(3968595404069103710)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'NATIVE_IG|REGION TYPE|interactivegridselectionchange'
);
```

### custom

Fires on an arbitrary custom DOM event. Requires `p_bind_event_type_custom` to specify the actual event name.

```sql
-- From f102/page_00051 (IG end-of-record-edit for cross-field validation)
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(747834766849545954)
,p_name=>'Validate comm limit'
,p_event_sequence=>30
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(2153848615348890246)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'custom'
,p_bind_event_type_custom=>'apexendrecordedit'
);
```

---

## Bind Types

| `p_bind_type` | Meaning | When to use |
|---------------|---------|-------------|
| `'bind'` | Standard event binding -- binds directly to the element | Default. Element must exist at page load. |
| `'live'` | Event delegation -- binds to a parent container, delegates to matching children | Use for dynamically created DOM elements (e.g., checkboxes inside paginated IR reports). Requires `p_bind_delegate_to_selector`. |

Live binding example:

```sql
-- From f104/page_00068 (select/unselect all checkboxes in paginated IR)
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12021491051696467777)
,p_name=>'Select/Unselect All Products'
,p_event_sequence=>30
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'#selectUnselectAll'
,p_bind_type=>'live'
,p_bind_delegate_to_selector=>'#productsIRR'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
```

---

## Event Conditions

### EQUALS Condition

Tests whether the condition element's value equals the expression. Used with ITEM triggers.

```sql
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(15987801604570670033)
,p_name=>'ENABLE ACCESS CONTROL CHANGED'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P35_AC_ENABLED'
,p_condition_element=>'P35_AC_ENABLED'          -- Item to evaluate
,p_triggering_condition_type=>'EQUALS'           -- Condition type
,p_triggering_expression=>'Y'                    -- Value to match
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
```

When condition is TRUE, `p_event_result=>'TRUE'` actions fire.
When condition is FALSE, `p_event_result=>'FALSE'` actions fire.

### JAVASCRIPT_EXPRESSION Condition

Evaluates a JavaScript expression that returns true/false. Used with any trigger type.

```sql
-- Simple expression (login page focus)
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'( $v( "P101_USERNAME" ) === "" )'

-- Checking browser event key (Enter key detection)
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'this.browserEvent.which === 13'

-- Complex multi-line expression (via wwv_flow_string.join)
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'($v(''P35_HIDDEN_AC_ENABLED'') !== $v(''P35_AC_ENABLED'') &&',
' $v(''P35_AC_ENABLED'') === ''Y'')',
''))

-- Checking triggering element text
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'$(this.triggeringElement).text() === "Check All"'
```

Note: Single quotes inside `wwv_flow_string.join` are escaped as `''`.

### No Condition (Always Fire)

When no `p_triggering_condition_type` is set, the event fires unconditionally on the specified event type. Only TRUE actions execute (there is no FALSE branch).

```sql
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(441311210080325908)
,p_name=>'Apply Other Threshold'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_OTHER'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
```

---

## TRUE / FALSE Branching

When a DA event has a condition (`p_triggering_condition_type`), it can have separate actions for TRUE and FALSE outcomes. This enables toggle behavior (show/hide, enable/disable) from a single event.

```sql
-- Event with EQUALS condition
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(15987801604570670033)
,p_name=>'ENABLE ACCESS CONTROL CHANGED'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P35_AC_ENABLED'
,p_condition_element=>'P35_AC_ENABLED'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);

-- FALSE branch: hide when condition is not met
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15987801934005670033)
,p_event_id=>wwv_flow_imp.id(15987801604570670033)
,p_event_result=>'FALSE'                    -- <<< FALSE branch
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P35_ACCESS_CONTROL_SCOPE'
,p_attribute_01=>'N'
);

-- TRUE branch: show when condition is met
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15987802131077670034)
,p_event_id=>wwv_flow_imp.id(15987801604570670033)
,p_event_result=>'TRUE'                     -- <<< TRUE branch
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P35_ACCESS_CONTROL_SCOPE'
,p_attribute_01=>'N'
);
```

Key points:
- Both TRUE and FALSE actions can have `p_execute_on_page_init=>'Y'` so the initial state is correct.
- Events without a condition only have TRUE actions (no FALSE branch exists).

---

## Action Types

### NATIVE_JAVASCRIPT_CODE

Executes arbitrary JavaScript. The most flexible action type.

**Simple one-liner:**
```sql
-- From f101/page_00004 (chart sorting)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(441310496688325901)
,p_event_id=>wwv_flow_imp.id(441310379441325900)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(440657661853405789)
,p_attribute_01=>'apex.region("donut1").widget().ojChart({sorting:''ascending''});'
);
```

**Multi-line JS with `wwv_flow_string.join`:**
```sql
-- From f104/page_00059 (toggle checkboxes + update label)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15053903029556073552)
,p_event_id=>wwv_flow_imp.id(15053902914143073551)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'$(".reference_types_checkbox input[type=checkbox]").prop(''checked'',true);',
'$(this.triggeringElement).text(''Uncheck All'');'))
);
```

**With `p_execute_on_page_init=>'Y'` (also runs on page load):**
```sql
-- From f104/page_00059 (set CSS classes based on select value)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15022243503516185666)
,p_event_id=>wwv_flow_imp.id(15022243432877185665)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P59_LOGO_SIZE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var logo_cards$ = $("#logo_region_cards");',
'var logo_select_val = $v(''P59_LOGO_SIZE'');',
'',
'if (logo_select_val === ''S'') {',
'  logo_cards$.addClass("small-logos");',
'  logo_cards$.removeClass("medium-logos large-logos"); ',
'} else if (logo_select_val === ''M'') {',
'  logo_cards$.addClass("medium-logos");',
'  logo_cards$.removeClass("small-logos large-logos");',
'} else {',
'  logo_cards$.addClass("large-logos");',
'  logo_cards$.removeClass("small-logos medium-logos");',
'}'))
);
```

**With jQuery selector affected elements:**
```sql
-- From f104/page_00118 (manipulate DOM via this.affectedElements)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(18752645584956005357)
,p_event_id=>wwv_flow_imp.id(18752644998673005355)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'JQUERY_SELECTOR'
,p_affected_elements=>'#P118_PAGE_ID_DISPLAY'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'this.affectedElements.html(this.affectedElements.html().replace(''&amp;APPLICATION_TITLE.'',''''));',
'//console.log(''Page Title = '' + this.affectedElements.html());'))
);
```

Attributes:
- `p_attribute_01` -- JavaScript code to execute

### NATIVE_REFRESH

Refreshes a region via AJAX (re-executes the region's SQL).

```sql
-- From f101/page_00004 (refresh chart when filter changes)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(814897934491983604)
,p_event_id=>wwv_flow_imp.id(814897770605983603)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(814897255001983598)
,p_attribute_01=>'N'
);
```

**Refresh multiple regions using jQuery selector:**
```sql
-- From f104/page_00059 (refresh cards, logos, customers regions)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15053903652550073558)
,p_event_id=>wwv_flow_imp.id(15053902914143073551)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'JQUERY_SELECTOR'
,p_affected_elements=>'#CARDS, #LOGOS, #CUSTOMERS'
,p_attribute_01=>'N'
);
```

Attributes:
- `p_attribute_01` -- `'N'` (standard refresh) or `'Y'` (defer refresh)

Prerequisite: The region must have `p_ajax_enabled=>'Y'` and typically `p_ajax_items_to_submit` set for bind variable items.

### NATIVE_SET_VALUE

Sets a page item's value. Multiple source types available.

**SQL_STATEMENT source:**
```sql
-- From f101/page_00004 (set product name from DB lookup)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(814898243313983608)
,p_event_id=>wwv_flow_imp.id(814898148045983607)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_PRODUCT_NAME'
,p_attribute_01=>'SQL_STATEMENT'           -- Source type
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select product_name from eba_demo_chart_products',
'where product_id = :P4_PRODUCT_ID'))
,p_attribute_07=>'P4_PRODUCT_ID'           -- Items to submit
,p_attribute_08=>'Y'                       -- Escape special chars
,p_attribute_09=>'N'                       -- Suppress change event
,p_wait_for_result=>'Y'
);
```

**STATIC_ASSIGNMENT source:**
```sql
-- From f104/page_00125 (set item to a literal value)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(18167283401034376559)
,p_event_id=>wwv_flow_imp.id(18167281580184376554)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P125_IMPORT_FROM'
,p_attribute_01=>'STATIC_ASSIGNMENT'       -- Source type
,p_attribute_02=>'PASTE'                   -- Static value
,p_attribute_09=>'N'                       -- Suppress change event
,p_wait_for_result=>'Y'
);
```

**JAVASCRIPT_EXPRESSION source:**
```sql
-- From f104/page_00060 (copy value from one item to another via JS)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(18167448642820435747)
,p_event_id=>wwv_flow_imp.id(18167448521688435746)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P60_ORIG_COPY_PASTE'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'   -- Source type
,p_attribute_05=>'$v(''P60_COPY_PASTE'')'  -- JS expression
,p_attribute_09=>'N'                       -- Suppress change event
,p_wait_for_result=>'Y'
);
```

Attribute reference for NATIVE_SET_VALUE:
| Attribute | Purpose |
|-----------|---------|
| `p_attribute_01` | Source type: `SQL_STATEMENT`, `STATIC_ASSIGNMENT`, `JAVASCRIPT_EXPRESSION`, `PLSQL_EXPRESSION`, `PLSQL_FUNCTION_BODY`, `DIALOG_RETURN_VALUE` |
| `p_attribute_02` | Static value (for `STATIC_ASSIGNMENT`) |
| `p_attribute_03` | SQL query (for `SQL_STATEMENT`) |
| `p_attribute_04` | PL/SQL expression or function body |
| `p_attribute_05` | JS expression (for `JAVASCRIPT_EXPRESSION`) |
| `p_attribute_07` | Items to submit (comma-separated) |
| `p_attribute_08` | Escape special characters (`Y`/`N`) |
| `p_attribute_09` | Suppress change event (`Y`/`N`) -- use `'N'` to fire, `'Y'` to suppress |
| `p_wait_for_result` | `'Y'` to wait before next action |

### NATIVE_SHOW

Shows a page element (item + label, region, button).

```sql
-- From f104/page_00060 (show copy-paste textarea)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15909617522917557843)
,p_event_id=>wwv_flow_imp.id(15909617212407557842)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'                -- Y to set correct initial state
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P60_COPY_PASTE'
,p_attribute_01=>'Y'                        -- Y = show label too; N = just element
);
```

Show a region:
```sql
-- From f104/page_00125 (show file upload region)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(18167450486321435765)
,p_event_id=>wwv_flow_imp.id(18156904074503326044)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(18157009107749286800)
,p_attribute_01=>'N'
);
```

### NATIVE_HIDE

Hides a page element (item + label, region, button).

```sql
-- From f104/page_00060 (hide copy-paste textarea)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15909617716650557844)
,p_event_id=>wwv_flow_imp.id(15909617212407557842)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P60_COPY_PASTE'
,p_attribute_01=>'Y'                        -- Y = hide label too; N = just element
);
```

Attributes for NATIVE_SHOW and NATIVE_HIDE:
- `p_attribute_01` -- `'Y'` = include label (for items); `'N'` = element container only

### NATIVE_SUBMIT_PAGE

Submits the page with a specified request value.

```sql
-- From f103/page_00005 (submit on filter change, show spinner)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(2687307709979693539)
,p_event_id=>wwv_flow_imp.id(2687307401064693538)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
```

Submit with specific request value (for branching/process conditions):
```sql
-- From f104/page_00035 (submit with request for server-side routing)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15987800930485670033)
,p_event_id=>wwv_flow_imp.id(15987800608119670033)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'APPLY_CHANGES_AC_ENABLED'
,p_attribute_02=>'N'
);
```

Attributes:
- `p_attribute_01` -- Request value (used in `p_process_when` conditions on server-side processes)
- `p_attribute_02` -- Show processing indicator (`'Y'`/`'N'`)

### NATIVE_EXECUTE_PLSQL_CODE

Executes PL/SQL on the server via AJAX. Used to push client-side item values to session state and/or return computed values.

**Minimal pattern (push item value to session state):**
```sql
-- From f104/page_00117 (submit session state, then refresh)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(17971604622411913945)
,p_event_id=>wwv_flow_imp.id(17971604100525913943)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'null;'
,p_attribute_02=>'P117_SHOW_VIEWS'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
```

**Full PL/SQL with items to submit and return:**
```sql
-- From f104/page_00150 (look up flags from DB, return to page items)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(18190840927668299667)
,p_event_id=>wwv_flow_imp.id(18190840837574299666)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
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
);
```

**Complex PL/SQL (APEX IR API + collections):**
```sql
-- From f103/page_00011 (build collection from IR query for chart)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(1321637799683555171)
,p_event_id=>wwv_flow_imp.id(1321637501663555166)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_report     apex_ir.t_report;',
'  q            varchar2(32767);',
'  l_name_list  apex_application_global.vc_arr2;',
'  l_value_list apex_application_global.vc_arr2;',
'  c_collection_name constant varchar2(100) := ''IR_RESULT_FROM_PAGE_11'';',
'  l_region_id  number;',
'begin',
'  select max(region_id) into l_region_id ',
'  from APEX_APPLICATION_PAGE_REGIONS ',
'  where application_id = :APP_ID and page_id = 11 and static_id = ''IR_EXAMPLE'';',
'  l_report := apex_ir.get_report (',
'    p_page_id        => 11,',
'    p_region_id      => l_region_id);',
'  q := ''select s.project, sum(s.cost) from (''||l_report.sql_query||'') s group by project'';',
'  for i in 1..l_report.binds.count loop',
'      l_name_list(l_name_list.count+1) := l_report.binds(i).name;',
'      l_value_list(l_value_list.count+1) := l_report.binds(i).value;',
'  end loop;',
'  if apex_collection.collection_exists( p_collection_name => c_collection_name ) then',
'      apex_collection.delete_collection( p_collection_name => c_collection_name );',
'  end if;',
'  apex_collection.create_collection_from_query_b(',
'        p_collection_name => c_collection_name,',
'        p_query           => q,',
'        p_names           => l_name_list,',
'        p_values          => l_value_list,',
'        p_max_row_count   => null);',
'end;'))
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
```

Attribute reference:
| Attribute | Purpose |
|-----------|---------|
| `p_attribute_01` | PL/SQL code block |
| `p_attribute_02` | Items to Submit (comma-separated, pushes to session state) |
| `p_attribute_03` | Items to Return (comma-separated, pulls back to browser) |
| `p_attribute_04` | Suppress change event on returned items (`'N'` = no) |
| `p_attribute_05` | Language: `'PLSQL'` |
| `p_wait_for_result` | `'Y'` = synchronous, blocks next action |

### NATIVE_CONFIRM

Shows a browser confirmation dialog. If user clicks Cancel, remaining actions in the sequence are skipped.

```sql
-- From f104/page_00035 (confirm before disabling access control)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15987801318728670033)
,p_event_id=>wwv_flow_imp.id(15987801017477670033)
,p_event_result=>'TRUE'
,p_action_sequence=>10                       -- Runs BEFORE the submit
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Disabling Access Control means that all application features are available to any user who can authenticate. Are you sure you want to disable Access Control?'
);
```

Attributes:
- `p_attribute_01` -- Confirmation message text

### NATIVE_SET_FOCUS

Sets browser focus to a page item.

```sql
-- From f101/page_00101 (login page -- focus username if empty)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(3265224572840205865)
,p_event_id=>wwv_flow_imp.id(3265224296392205864)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P101_USERNAME'
);

-- FALSE branch: focus password instead
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(3265224786147205865)
,p_event_id=>wwv_flow_imp.id(3265224296392205864)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P101_PASSWORD'
);
```

### NATIVE_CLEAR

Clears the value(s) of one or more page items.

```sql
-- From f104/page_00059 (reset multiple search filter items at once)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15022242671645185657)
,p_event_id=>wwv_flow_imp.id(15022242538304185656)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P59_SEARCH,P59_GEO,P59_INDUSTRY,P59_CATEGORY,P59_STATUS,P59_MAX_ROWS,P59_REFERENCE_TYPES,P59_LOGO_SIZE,P59_PRODUCT,P59_MARQUEE_CUST,P59_SCP_CUST,P59_TYPE,P59_USE_CASE,P59_REFERENCEABLE,P59_COUNTRY,P59_IMP_PARTNER,P59_COMPETITOR'
);
```

### NATIVE_CANCEL_EVENT

Prevents the default browser action (e.g., form submission on Enter key).

```sql
-- From f104/page_00117 (prevent Enter key from submitting form)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(17971603709051913943)
,p_event_id=>wwv_flow_imp.id(17971602289011913938)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CANCEL_EVENT'
);
```

No attributes needed.

### NATIVE_DIALOG_CANCEL

Closes a modal dialog without submitting or returning values. Used exclusively on Cancel buttons in modal pages.

```sql
-- From f104/page_00150 (cancel dialog button)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(18202919265639493754)
,p_event_id=>wwv_flow_imp.id(18202918425165493748)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
```

No attributes needed.

### NATIVE_DIALOG_CLOSE

Closes a dialog page and returns values to the parent page. Triggers `apexafterclosedialog` on the parent.

```sql
-- From f104/page_00192 (close dialog after add-to-collection)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(1185861772757143821)
,p_event_id=>wwv_flow_imp.id(1185861263700143821)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
```

No attributes needed. (Return items are configured on the dialog page properties, not on the action.)

---

## Server-side Conditions on Actions

Individual actions can be disabled or conditionally suppressed using `p_server_condition_type`.

```sql
-- Disable an action permanently (common for deprecated/replaced actions)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(1367139181891438854)
,p_event_id=>wwv_flow_imp.id(1367139036076438853)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var i, selectedIds = ":",',
'    model = this.data.model;',
'for ( i = 0; i < this.data.selectedRecords.length; i++ ) {',
'    selectedIds += model.getValue( this.data.selectedRecords[i], "EMPNO") + ":";',
'}',
'$s("P8_SELECTED", selectedIds);',
'apex.region("barchart").refresh();'))
,p_server_condition_type=>'NEVER'
,p_da_action_comment=>'Update for 24.1. This is the old way of gathering the select item ids. Now all that is needed is a Refresh action'
);
```

The action is still in the export but will never execute. Useful for preserving old code as reference.

---

## Display When Conditions on Events

Entire DA events can be suppressed server-side with `p_display_when_type`. The event and its actions will not render any JavaScript on the page.

```sql
-- From f104/page_00059 (disabled search-on-enter event)
,p_bind_event_type=>'keydown'
,p_display_when_type=>'NEVER'
```

---

## Affected Element Types

| `p_affected_elements_type` | Target Parameter | Notes |
|---------------------------|------------------|-------|
| `REGION` | `p_affected_region_id` | Region `wwv_flow_imp.id(...)` |
| `ITEM` | `p_affected_elements` | Item name string (e.g., `'P4_PRODUCT_NAME'`). Comma-separated for multiple: `'P59_SEARCH,P59_GEO'` |
| `BUTTON` | `p_affected_button_id` | Button `wwv_flow_imp.id(...)` |
| `JQUERY_SELECTOR` | `p_affected_elements` | CSS selector (e.g., `'#P118_PAGE_ID_DISPLAY'` or `'#CARDS, #LOGOS, #CUSTOMERS'`) |
| (omitted) | (none) | For actions that don't target elements (`DIALOG_CANCEL`, `DIALOG_CLOSE`, `CONFIRM`, `CANCEL_EVENT`) |

---

## Multiple Actions Per Event

A single event can have multiple sequential actions, differentiated by `p_action_sequence`. Actions execute in sequence order within the same branch (TRUE or FALSE).

```sql
-- Event: button click
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(18167448521688435746)
,p_name=>'Set orig cut paste value and submit'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(15909612510882557832)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);

-- Action 1: Set value via JS expression
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(18167448642820435747)
,p_event_id=>wwv_flow_imp.id(18167448521688435746)
,p_event_result=>'TRUE'
,p_action_sequence=>10                        -- First
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P60_ORIG_COPY_PASTE'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>'$v(''P60_COPY_PASTE'')'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);

-- Action 2: Execute PL/SQL (push to session state)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(18167448720053435748)
,p_event_id=>wwv_flow_imp.id(18167448521688435746)
,p_event_result=>'TRUE'
,p_action_sequence=>20                        -- Second
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'null;'
,p_attribute_02=>'P60_ORIG_COPY_PASTE'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);

-- Action 3: Execute JS (submit via widget)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(18167448888170435749)
,p_event_id=>wwv_flow_imp.id(18167448521688435746)
,p_event_result=>'TRUE'
,p_action_sequence=>30                        -- Third
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'apex.widget.textareaClob.upload(''P60_COPY_PASTE'', ''NEXT'');'))
);
```

Key points:
- Use `p_wait_for_result=>'Y'` on async actions (SET_VALUE, EXECUTE_PLSQL) to ensure sequential execution.
- Action sequences are typically 10, 20, 30, etc.
- Up to 6 actions observed on a single event in the sample apps.

---

## Common Patterns

### Modal Dialog Cancel

Found on every modal dialog form page. A CANCEL button + DA + DIALOG_CANCEL action.

```sql
-- Cancel button (in Buttons region, position PREVIOUS)
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

-- DA event: Cancel Dialog
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

-- DA action: close the dialog
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

Complete pattern for modal dialog pages:

1. **Parent page**: Region with link column/button opens dialog page.
2. **Dialog page**: Has `NATIVE_DIALOG_CANCEL` on Cancel button and/or `NATIVE_DIALOG_CLOSE` after successful processing.
3. **Parent page**: Has `apexafterclosedialog` event on the region, with `NATIVE_REFRESH` action to reload data.

```
Parent page (Region with link)
  |-> Opens dialog page (modal)
       |-> Cancel button -> NATIVE_DIALOG_CANCEL
       |-> Save process  -> NATIVE_DIALOG_CLOSE (after submit)
  |<- apexafterclosedialog fires on parent region
       |-> NATIVE_REFRESH on the same region
```

Parent page pattern:
```sql
-- From f103/page_00001
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

Dialog page close pattern:
```sql
-- From f104/page_00192
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(1185861263700143821)
,p_name=>'Close Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(1185856047108143816)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(1185861772757143821)
,p_event_id=>wwv_flow_imp.id(1185861263700143821)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
```

### Show/Hide Toggle on Item Change

Shows one element and hides another based on an item value. Uses TRUE/FALSE branching with `p_execute_on_page_init=>'Y'`.

```sql
-- Event: radio group changes, condition checks if value = 'PASTE'
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(15909617212407557842)
,p_name=>'Import From Copy and Paste'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P60_IMPORT_FROM'
,p_condition_element=>'P60_IMPORT_FROM'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'PASTE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);

-- TRUE: show copy-paste textarea
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15909617522917557843)
,p_event_id=>wwv_flow_imp.id(15909617212407557842)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P60_COPY_PASTE'
,p_attribute_01=>'Y'
);

-- FALSE: hide copy-paste textarea
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15909617716650557844)
,p_event_id=>wwv_flow_imp.id(15909617212407557842)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P60_COPY_PASTE'
,p_attribute_01=>'Y'
);
```

### Conditional Show/Hide Driven by PL/SQL

Two-step pattern: (1) Execute PL/SQL to compute flag items, (2) Use separate change events on those flag items to show/hide fields. This combines server-side logic with client-side UI behavior.

```
Event 1: Change on P150_ACTIVITY_ID
  Action: NATIVE_EXECUTE_PLSQL_CODE
    Submit: P150_ACTIVITY_ID
    Return: P150_SHOW_DATE, P150_SHOW_OWNER, P150_SHOW_LOCATION

Event 2: Change on P150_SHOW_DATE (condition: EQUALS 'Y')
  TRUE:  NATIVE_SHOW P150_ACTIVITY_DATE
  FALSE: NATIVE_HIDE P150_ACTIVITY_DATE

Event 3: Change on P150_SHOW_OWNER (condition: EQUALS 'Y')
  TRUE:  NATIVE_SHOW P150_OWNER
  FALSE: NATIVE_HIDE P150_OWNER

Event 4: Change on P150_SHOW_LOCATION (condition: EQUALS 'Y')
  TRUE:  NATIVE_SHOW P150_LOCATION
  FALSE: NATIVE_HIDE P150_LOCATION
```

The PL/SQL action:
```sql
-- From f104/page_00150
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(18190840927668299667)
,p_event_id=>wwv_flow_imp.id(18190840837574299666)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
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
);
```

### Chart JS Modification via Button

Multiple buttons each triggering a JS call to modify chart properties. Buttons use pill layout (pillStart / pill / pillEnd).

```sql
-- Buttons with pill template options for button group appearance
-- First:  p_button_template_options=>'#DEFAULT#:t-Button--pillStart'
-- Middle: p_button_template_options=>'#DEFAULT#:t-Button--pill'
-- Last:   p_button_template_options=>'#DEFAULT#:t-Button--pillEnd'

-- Each button has its own DA event + JS action
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
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(454937806749870444)
,p_event_id=>wwv_flow_imp.id(454937267045870444)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(454918957563870390)
,p_attribute_01=>'apex.region("combo1").widget().ojChart({styleDefaults:{lineType:''straight''}});'
);
```

JET chart modification patterns observed:
- `apex.region("name").widget().ojChart({sorting:'ascending'});`
- `apex.region("name").widget().ojChart({styleDefaults:{lineType:'curved'}});`
- `apex.region("name").widget().ojChart({legend:{size:'50%'}});`
- `$("#regionName_jet").ojChart({timeAxisType:'skipGaps'});`
- `$("#regionName_jet").ojChart({otherThreshold:num});`

### Master-Detail Chart Refresh

Master chart sets a hidden item value via link target; DA on hidden item change triggers detail chart refresh + set item value.

```sql
-- Master chart series has link_target that sets a hidden item:
-- ,p_link_target=>'javascript:$s(''P4_PRODUCT_ID'',&PRODUCT_ID.);'
-- ,p_link_target_type=>'REDIRECT_URL'

-- DA 1: Refresh detail chart when hidden item changes
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(814897770605983603)
,p_name=>'Refresh Orders Chart'
,p_event_sequence=>60
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_PRODUCT_ID'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(814897934491983604)
,p_event_id=>wwv_flow_imp.id(814897770605983603)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(814897255001983598)
,p_attribute_01=>'N'
);

-- DA 2: Set display item from SQL when hidden item changes
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(814898148045983607)
,p_name=>'Set Product Name'
,p_event_sequence=>70
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_PRODUCT_ID'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(814898243313983608)
,p_event_id=>wwv_flow_imp.id(814898148045983607)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
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
);
```

Detail chart must have `p_ajax_items_to_submit=>'P4_PRODUCT_ID'` on its series.

### Report Refresh on Item Change

A select list (or other item) change triggers region refresh. The region uses `p_ajax_items_to_submit` to bind the item.

```sql
-- Region: ajax-enabled with items to submit
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(2681613203969354879)
,p_name=>'Classic Report'
,p_region_name=>'classic_report'
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P3_STATUS'
-- ... SQL references :P3_STATUS ...
);

-- DA: refresh report when P3_STATUS changes
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
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(2148374082922376890)
,p_event_id=>wwv_flow_imp.id(2148373988059376889)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(2681613203969354879)
,p_attribute_01=>'N'
);
```

### Refresh on Dialog Close

When a modal dialog closes (after insert/update/delete), the parent page's report/region refreshes.

```sql
-- From f103/page_00003 (report page with modal edit)
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
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(223926137108124447)
,p_event_id=>wwv_flow_imp.id(223925996987124446)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(2681613203969354879)
,p_attribute_01=>'N'
);
```

The event triggers on the same region that contains the link opening the modal dialog. The `apexafterclosedialog` event is fired by APEX when the child dialog page executes a `NATIVE_CLOSE_WINDOW` process or `NATIVE_DIALOG_CLOSE` action.

### Search-on-Enter

Listen for keydown, check for Enter key (keycode 13), refresh regions, cancel the default form submit.

```sql
-- From f104/page_00117
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(17971602289011913938)
,p_name=>'Perform Search on Enter'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P117_SEARCH'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'this.browserEvent.which === 13'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'keydown'
);

-- Action 1: Refresh region 1
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(17971602758093913941)
,p_event_id=>wwv_flow_imp.id(17971602289011913938)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_attribute_01=>'N'
);

-- Action 2: Refresh region 2
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(17971603286604913942)
,p_event_id=>wwv_flow_imp.id(17971602289011913938)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_attribute_01=>'N'
);

-- Action 3: Cancel event (prevent form submit)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(17971603709051913943)
,p_event_id=>wwv_flow_imp.id(17971602289011913938)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CANCEL_EVENT'
);
```

### PL/SQL Session State Sync

Use `NATIVE_EXECUTE_PLSQL_CODE` with `null;` as the code and items to submit. This pushes client-side item values to server session state without any actual processing. Follow with a NATIVE_REFRESH to use the updated session state.

```sql
-- From f104/page_00117
-- Step 1: Push item to session state
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(17971604622411913945)
,p_event_id=>wwv_flow_imp.id(17971604100525913943)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'null;'
,p_attribute_02=>'P117_SHOW_VIEWS'   -- items to submit
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);

-- Step 2: Refresh region (now uses updated session state)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(17971605139436913946)
,p_event_id=>wwv_flow_imp.id(17971604100525913943)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(17971585885850913890)
,p_attribute_01=>'N'
);
```

### Confirm Then Submit

Shows a confirmation dialog, then submits the page with a specific request value.

```sql
-- Event: button click with JS expression condition
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(15987801017477670033)
,p_name=>'APPLY CHANGES WHEN AC DISABLED'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(15987797931153670020)
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'($v(''P35_HIDDEN_AC_ENABLED'') !== $v(''P35_AC_ENABLED'') &&',
' $v(''P35_AC_ENABLED'') === ''N'')',
''))
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);

-- Action 1 (seq 10): Confirm dialog
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15987801318728670033)
,p_event_id=>wwv_flow_imp.id(15987801017477670033)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure you want to disable Access Control?'
);

-- Action 2 (seq 20): Submit page (only runs if user confirms)
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15987801523524670033)
,p_event_id=>wwv_flow_imp.id(15987801017477670033)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'APPLY_CHANGES_AC_DISABLED'
,p_attribute_02=>'N'
);
```

### Set Value Then Execute PL/SQL Then Submit

Multi-step action chain: set values client-side, push to session state via PL/SQL, then submit/navigate.

```sql
-- Event: button click (6 sequential TRUE actions)
-- Action seq 10: Set P60_IMPORT_FROM = 'PASTE' (STATIC_ASSIGNMENT, page_init=Y)
-- Action seq 20: Set P60_COPY_PASTE = sample data (STATIC_ASSIGNMENT, page_init=N)
-- Action seq 30: Execute PL/SQL null; with items_to_submit P60_COPY_PASTE (push to session)
-- Action seq 40: Set P60_SEPARATOR = ',' (STATIC_ASSIGNMENT, page_init=N)
-- Action seq 50: Set P60_ENCLOSED_BY = '"' (STATIC_ASSIGNMENT, page_init=Y)
-- Action seq 60: Set P60_FIRST_ROW = 'Y' (STATIC_ASSIGNMENT, page_init=N)
```

All actions use `p_wait_for_result=>'Y'` to ensure order.

### IG Column Validation

Use column-level change events to validate individual IG cells with client-side JavaScript.

```sql
-- From f102/page_00051 (validate salary column)
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
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(747834312027545949)
,p_event_id=>wwv_flow_imp.id(747834166734545948)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var sal = apex.item("cSal"),',
'    num = sal.getValue();',
'if ( num !== "" && (parseFloat(num) != num || num < 0 || num > 10000)) {',
'    sal.node.setCustomValidity("invalid number");',
'} else {',
'    sal.node.setCustomValidity("");',
'}'))
);
```

Cross-field validation using custom event `apexendrecordedit`:
```sql
-- From f102/page_00051 (validate commission < 1.5 * salary)
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(747834766849545954)
,p_name=>'Validate comm limit'
,p_event_sequence=>30
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(2153848615348890246)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'custom'
,p_bind_event_type_custom=>'apexendrecordedit'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(747834952822545955)
,p_event_id=>wwv_flow_imp.id(747834766849545954)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var validity, message,',
'    ui = this.data,',
'    sal = $v("cSal"),',
'    comm = $v("cComm");',
'',
'if ( comm == "" || comm < 1.5 * sal ) {',
'    validity = "valid";',
'} else {',
'    validity = "error";',
'    message = "Commission must be less than 1.5 times the Salary";',
'}',
'ui.model.setValidity(validity, ui.recordId, null, message);',
''))
);
```
