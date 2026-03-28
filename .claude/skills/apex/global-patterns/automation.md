# Automations

Patterns from APEX 24.2 exports. Automations are shared components that run background tasks on a schedule or on demand.

## API Calls (ordered)

1. `wwv_flow_imp_shared.create_automation(...)` — define the automation
2. `wwv_flow_imp_shared.create_automation_action(...)` — add one or more actions

## File Location

`application/shared_components/automations/<static_id>.sql`

## Automation Definition

```sql
wwv_flow_imp_shared.create_automation(
 p_id=>wwv_flow_imp.id(70021238017754767)
,p_name=>'Session orders cleanup'
,p_static_id=>'session-orders-cleanup'
,p_trigger_type=>'POLLING'                                        -- POLLING | ON_DEMAND
,p_polling_interval=>'FREQ=DAILY;INTERVAL=1;BYHOUR=0;BYMINUTE=0' -- iCalendar RRULE (only when POLLING)
,p_polling_status=>'DISABLED'                                     -- DISABLED | ACTIVE
,p_result_type=>'ALWAYS'                                          -- ALWAYS | ROWS
,p_use_local_sync_table=>false
,p_include_rowid_column=>false
,p_commit_each_row=>false
,p_error_handling_type=>'IGNORE'                                  -- IGNORE | STOP
);
```

### Required Parameters

| Parameter | Description |
|-----------|-------------|
| `p_id` | Unique component ID |
| `p_name` | Display name |
| `p_static_id` | URL-safe identifier |
| `p_trigger_type` | `POLLING` (scheduled) or `ON_DEMAND` |
| `p_result_type` | `ALWAYS` (run regardless) or `ROWS` (run only when query returns rows) |

### Common Optional Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `p_polling_interval` | iCalendar RRULE schedule string (required when `POLLING`) | — |
| `p_polling_status` | `DISABLED` or `ACTIVE` | `DISABLED` |
| `p_location` | `LOCAL` or `REMOTE` (REST data source) | `LOCAL` |
| `p_query_type` | `TABLE` or `SQL` (when `p_result_type=>'ROWS'`) | — |
| `p_query_table` | Table name (when `p_query_type=>'TABLE'`) | — |
| `p_use_local_sync_table` | `true` / `false` | `false` |
| `p_include_rowid_column` | `true` / `false` | `false` |
| `p_commit_each_row` | `true` / `false` | `false` |
| `p_error_handling_type` | `IGNORE` or `STOP` | `IGNORE` |

## Automation Action

```sql
wwv_flow_imp_shared.create_automation_action(
 p_id=>wwv_flow_imp.id(70021601329754770)
,p_automation_id=>wwv_flow_imp.id(70021238017754767)  -- FK to parent automation
,p_name=>'Delete Orders'
,p_execution_sequence=>10
,p_action_type=>'NATIVE_PLSQL'
,p_action_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'delete sample_restaurant_order_items',
' where order_id in (',
'       select order_id',
'         from sample_restaurant_orders',
'        where session_id is not null );',
'',
'delete sample_restaurant_orders',
' where session_id is not null;',
''))
,p_action_clob_language=>'PLSQL'
,p_location=>'LOCAL'
,p_stop_execution_on_error=>true
);
```

### Required Parameters

| Parameter | Description |
|-----------|-------------|
| `p_id` | Unique component ID |
| `p_automation_id` | FK to parent `create_automation` |
| `p_name` | Action display name |
| `p_execution_sequence` | Order of execution (10, 20, ...) |
| `p_action_type` | See action types below |

### Action Types

| Value | Description |
|-------|-------------|
| `NATIVE_PLSQL` | Execute PL/SQL code block |
| `NATIVE_SEND_EMAIL` | Send email (uses email templates) |
| `NATIVE_INVOKE_API` | Invoke REST API (uses web source modules) |

### Action Parameters by Type

**NATIVE_PLSQL:**
| Parameter | Description |
|-----------|-------------|
| `p_action_clob` | PL/SQL code (use `wwv_flow_string.join(wwv_flow_t_varchar2(...))` for multi-line) |
| `p_action_clob_language` | `'PLSQL'` |
| `p_location` | `'LOCAL'` |
| `p_stop_execution_on_error` | `true` / `false` |

## Variations

### Variation A: Scheduled Polling — Run Always

Runs on schedule regardless of data. Good for cleanup/maintenance tasks.

```sql
-- From f101: Session orders cleanup (daily scheduled)
wwv_flow_imp_shared.create_automation(
 p_id=>wwv_flow_imp.id(70021238017754767)
,p_name=>'Session orders cleanup'
,p_static_id=>'session-orders-cleanup'
,p_trigger_type=>'POLLING'
,p_polling_interval=>'FREQ=DAILY;INTERVAL=1;BYHOUR=0;BYMINUTE=0'
,p_polling_status=>'DISABLED'
,p_result_type=>'ALWAYS'
,p_use_local_sync_table=>false
,p_include_rowid_column=>false
,p_commit_each_row=>false
,p_error_handling_type=>'IGNORE'
);
wwv_flow_imp_shared.create_automation_action(
 p_id=>wwv_flow_imp.id(70021601329754770)
,p_automation_id=>wwv_flow_imp.id(70021238017754767)
,p_name=>'Delete Orders'
,p_execution_sequence=>10
,p_action_type=>'NATIVE_PLSQL'
,p_action_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'delete sample_restaurant_order_items',
' where order_id in (',
'       select order_id',
'         from sample_restaurant_orders',
'        where session_id is not null );',
'',
'delete sample_restaurant_orders',
' where session_id is not null;',
''))
,p_action_clob_language=>'PLSQL'
,p_location=>'LOCAL'
,p_stop_execution_on_error=>true
);
```

### Variation B: Scheduled Polling — Query-Driven with Table Source

Runs on schedule but only when the query returns rows. Actions execute per-row.

```sql
-- From f111: Load Employee Data (hourly, table-driven)
wwv_flow_imp_shared.create_automation(
 p_id=>wwv_flow_imp.id(3334675917899140790)
,p_name=>'Load Employee Data'
,p_static_id=>'load-employee-data'
,p_trigger_type=>'POLLING'
,p_polling_interval=>'FREQ=HOURLY;INTERVAL=1;BYMINUTE=0'
,p_polling_status=>'DISABLED'
,p_result_type=>'ROWS'
,p_location=>'LOCAL'
,p_use_local_sync_table=>false
,p_query_type=>'TABLE'
,p_query_table=>'EBA_DEMO_LOAD_EMP'
,p_include_rowid_column=>false
,p_commit_each_row=>false
,p_error_handling_type=>'IGNORE'
);
wwv_flow_imp_shared.create_automation_action(
 p_id=>wwv_flow_imp.id(3334676173691140835)
,p_automation_id=>wwv_flow_imp.id(3334675917899140790)
,p_name=>'New Action'
,p_execution_sequence=>10
,p_action_type=>'NATIVE_PLSQL'
,p_action_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    null;',
'end;'))
,p_action_clob_language=>'PLSQL'
,p_location=>'LOCAL'
,p_stop_execution_on_error=>true
);
```

## Polling Interval Patterns

Uses iCalendar RRULE format:

| Schedule | RRULE Value |
|----------|-------------|
| Daily at midnight | `FREQ=DAILY;INTERVAL=1;BYHOUR=0;BYMINUTE=0` |
| Hourly on the hour | `FREQ=HOURLY;INTERVAL=1;BYMINUTE=0` |
| Every 5 minutes | `FREQ=MINUTELY;INTERVAL=5` |
| Weekly on Monday at 6am | `FREQ=WEEKLY;INTERVAL=1;BYDAY=MO;BYHOUR=6;BYMINUTE=0` |

## Parameter Value Catalog

| Parameter | Observed Values |
|-----------|----------------|
| `p_trigger_type` | `POLLING`, `ON_DEMAND` |
| `p_polling_status` | `DISABLED`, `ACTIVE` |
| `p_result_type` | `ALWAYS`, `ROWS` |
| `p_query_type` | `TABLE`, `SQL` |
| `p_location` | `LOCAL`, `REMOTE` |
| `p_error_handling_type` | `IGNORE`, `STOP` |
| `p_action_type` | `NATIVE_PLSQL`, `NATIVE_SEND_EMAIL`, `NATIVE_INVOKE_API` |
| `p_action_clob_language` | `PLSQL` |

## Relationships

- Standalone shared component (not page-level)
- Parent `create_automation` → child `create_automation_action` (via `p_automation_id`)
- Actions may reference: email templates (`NATIVE_SEND_EMAIL`), web source modules (`NATIVE_INVOKE_API`)
- Wrapped in `wwv_flow_imp.component_begin` / `component_end` block
