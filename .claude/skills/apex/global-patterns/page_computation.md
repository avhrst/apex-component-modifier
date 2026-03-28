# Page Computation

Page computations set item values at specific page-rendering or page-processing points. Each computation targets a single page item via `p_computation_item`.

## API Call

```sql
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(...)
,p_computation_sequence=>10
,p_computation_item=>'P1_ITEM'
,p_computation_point=>'BEFORE_HEADER'
,p_computation_type=>'STATIC_ASSIGNMENT'
,p_computation=>'value or expression'
);
```

## Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `p_id` | ID | Unique computation ID via `wwv_flow_imp.id(...)` |
| `p_computation_sequence` | Number | Execution order (10, 20, 30...) |
| `p_computation_item` | VARCHAR2 | Target page item name (e.g. `'P7_QUANTITY'`) |
| `p_computation_type` | VARCHAR2 | Computation method (see catalog below) |
| `p_computation` | VARCHAR2/CLOB | The value, expression, query, or function body |

## Common Optional Parameters

| Parameter | Type | Typical Values | Default |
|-----------|------|----------------|---------|
| `p_computation_point` | VARCHAR2 | `'BEFORE_HEADER'`, `'AFTER_HEADER'`, `'BEFORE_BOX_BODY'`, `'AFTER_FOOTER'` | `'BEFORE_HEADER'` |
| `p_computation_language` | VARCHAR2 | `'PLSQL'`, `'SQL'` | Required for EXPRESSION and FUNCTION_BODY types |
| `p_computation_error_message` | VARCHAR2 | `'Unable to log view #SQLERRM#'` | (none) |
| `p_compute_when` | VARCHAR2 | Item name or PL/SQL expression | (none — always runs) |
| `p_compute_when_type` | VARCHAR2 | `'ITEM_IS_NULL'`, `'ITEM_IS_NOT_NULL'`, `'EXPRESSION'`, etc. | (none) |
| `p_compute_when_text` | VARCHAR2 | `'PLSQL'` | Used with `p_compute_when_type=>'EXPRESSION'` |
| `p_required_patch` | ID | Build option ID via `wwv_flow_imp.id(...)` | (none) |
| `p_security_scheme` | VARCHAR2 | Authorization scheme | (none) |

## Variations

### Variation A: Static Value

Assigns a literal string or substitution to the item.

```sql
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(40526680212573805734)
,p_computation_sequence=>10
,p_computation_item=>'LAST_VIEW'
,p_computation_point=>'BEFORE_HEADER'
,p_computation_type=>'STATIC_ASSIGNMENT'
,p_computation=>'&APP_PAGE_ID.'
);
```

### Variation B: SQL Query (single-row, single-column)

Returns one value; the most common computation type.

```sql
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(41383020319985990460)
,p_computation_sequence=>20
,p_computation_item=>'P10000_SYSTEM_NOTIFICATIONS'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>'select count(*) from SP_APPLICATION_NOTIFICATIONS where IS_ACTIVE_YN = ''Y'''
);
```

Multi-line query with bind variables:

```sql
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(39064856249850337095)
,p_computation_sequence=>10
,p_computation_item=>'P3_STORE_NAME'
,p_computation_point=>'BEFORE_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select store_name ||'' - ''||',
'STORE_ADDRESS || '' ''||',
'STORE_CITY||'', ''||',
'STORE_STATE ||'' ''||',
'STORE_ZIP x',
'from #OWNER#.oow_demo_stores s where s.id = :P3_ID'))
);
```

### Variation C: PL/SQL Expression

A single PL/SQL expression (no `begin/end` block). Requires `p_computation_language`.

```sql
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(13918464689777794009)
,p_computation_sequence=>20
,p_computation_item=>'P9998_IS_TOKEN_MAXED_YN'
,p_computation_point=>'BEFORE_HEADER'
,p_computation_type=>'EXPRESSION'
,p_computation_language=>'PLSQL'
,p_computation=>'eba_ema_util.is_token_maxed_yn (p_username => :P9998_USERNAME)'
);
```

SQL expression variant:

```sql
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(1264219302404622336)
,p_computation_sequence=>10
,p_computation_item=>'P22_MINIMUM_DATE'
,p_computation_point=>'BEFORE_HEADER'
,p_computation_type=>'EXPRESSION'
,p_computation_language=>'SQL'
,p_computation=>'lower(:P19_EMAIL_ADDRESS)'
);
```

### Variation D: PL/SQL Function Body

A full PL/SQL block that returns a value. Requires `p_computation_language=>'PLSQL'`.

Simple one-liner:

```sql
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(38346655267127641173)
,p_computation_sequence=>10
,p_computation_item=>'P36_LOG'
,p_computation_point=>'BEFORE_HEADER'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>'return sp_log.log_and_summarize(:P36_ID);'
,p_computation_error_message=>'Unable to log view #SQLERRM#'
);
```

Multi-line with conditional logic:

```sql
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(65821847076785546)
,p_computation_sequence=>10
,p_computation_item=>'P7_QUANTITY'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if sample_restaurant_manage_orders.item_quantity( p_item_id => :P7_ITEM_ID ) > 0 then',
'    return sample_restaurant_manage_orders.item_quantity( p_item_id => :P7_ITEM_ID );',
'else',
'    return 1;',
'end if;'))
);
```

Full declare block:

```sql
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(1898916610697887340)
,p_computation_sequence=>10
,p_computation_item=>'P1_PRIVS_MISSING_YN'
,p_computation_point=>'BEFORE_HEADER'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    l_priv_count pls_integer;',
'begin',
'    select sum(priv)',
'      into l_priv_count',
'      from (select 1 as priv',
'              from all_credentials',
'             where credential_name  = ''OCI$RESOURCE_PRINCIPAL''',
'             union all',
'            select 1',
'              from user_role_privs',
'             where granted_role  = ''DWROLE'');',
'    return case when nvl( l_priv_count, 0 ) < 2 then ''Y'' else ''N'' end;',
'end;'))
);
```

### Variation E: Item Value

Copies value from another item. `p_computation` holds the source item name (no colon prefix).

```sql
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(48376131088095727186)
,p_computation_sequence=>10
,p_computation_item=>'LAST_VIEW'
,p_computation_point=>'BEFORE_HEADER'
,p_computation_type=>'ITEM_VALUE'
,p_computation=>'APP_PAGE_ID'
);
```

## Conditional Execution

### Run only when item is null (common for defaults)

```sql
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(2051706069001051899)
,p_computation_sequence=>40
,p_computation_item=>'APPLICATION_TITLE'
,p_computation_point=>'BEFORE_HEADER'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    l_app_name varchar2(255);',
'begin',
'    select nvl(preference_value,:APP_NAME)',
'      into l_app_name',
'      from eba_cust_preferences',
'     where preference_name = ''APPLICATION_TITLE'';',
'    return l_app_name;',
'exception',
'    when others then',
'        return :APP_NAME;',
'end;'))
,p_compute_when=>'APPLICATION_TITLE'
,p_compute_when_type=>'ITEM_IS_NULL'
);
```

### Run only when item is not null

```sql
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(3335264345849219656)
,p_computation_sequence=>10
,p_computation_item=>'P16_FILE_TYPE'
,p_computation_type=>'EXPRESSION'
,p_computation_language=>'PLSQL'
,p_computation=>'apex_data_parser.get_file_type( p_file_name => :P16_FILE )'
,p_compute_when=>'P16_FILE'
,p_compute_when_type=>'ITEM_IS_NOT_NULL'
);
```

### With build option

```sql
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(40696956467897177099)
,p_computation_sequence=>10
,p_computation_item=>'P144_NOTIFICATION_PREF'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'STATIC_ASSIGNMENT'
,p_computation=>'APP:EMAIL'
,p_required_patch=>wwv_flow_imp.id(53735225865040647723)
,p_compute_when=>'P144_NOTIFICATION_PREF'
,p_compute_when_type=>'ITEM_IS_NULL'
);
```

### PL/SQL expression condition

```sql
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(3334238605163294024)
,p_computation_sequence=>10
,p_computation_item=>'P11_FILE_NAME'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select filename',
'  from apex_application_temp_files ',
' where name = :P11_FILE'))
,p_compute_when=>':P11_FILE is not null and :REQUEST = ''LOAD_FILE'''
,p_compute_when_text=>'PLSQL'
,p_compute_when_type=>'EXPRESSION'
);
```

## Parameter Value Catalog

| Parameter | All Observed Values |
|-----------|-------------------|
| `p_computation_type` | `QUERY` (147), `STATIC_ASSIGNMENT` (117), `FUNCTION_BODY` (46), `EXPRESSION` (43), `ITEM_VALUE` (16) |
| `p_computation_point` | `BEFORE_HEADER` (267), `AFTER_HEADER` (32), `BEFORE_BOX_BODY` (30), `AFTER_FOOTER` (3) |
| `p_computation_language` | `PLSQL` (79), `SQL` (10) — required for EXPRESSION and FUNCTION_BODY |
| `p_compute_when_type` | `ITEM_IS_NULL` (29), `ITEM_IS_NOT_NULL` (14), `EXPRESSION` (6), `REQUEST_EQUALS_CONDITION` (3), `VAL_OF_ITEM_IN_COND_EQ_COND2` (1), `USER_IS_PUBLIC_USER` (1), `NOT_EXISTS` (1), `ITEM_IS_NULL_OR_ZERO` (1) |

## Relationships

- **Parent**: page (computations belong to a page)
- **Target**: items (`p_computation_item` — the page or app item whose value is set)
- **Condition**: items (`p_compute_when` — optional item to check before executing)
- **Build option**: `p_required_patch` — ties computation to a build option
- **Ordering**: `p_computation_sequence` controls execution order within the same `p_computation_point`

## Key Rules

1. **QUERY** type: must return exactly one row, one column. No `p_computation_language` needed.
2. **EXPRESSION** and **FUNCTION_BODY** types: require `p_computation_language` (`'PLSQL'` or `'SQL'`).
3. **STATIC_ASSIGNMENT** and **ITEM_VALUE** types: no language parameter needed.
4. **FUNCTION_BODY**: must contain a `return` statement. Can optionally include a `declare` block.
5. Multi-line computations use `wwv_flow_string.join(wwv_flow_t_varchar2(...))`.
6. Strings inside computation text are escaped with doubled single quotes (`''`).
7. `p_computation_point` is omitted in some exports — defaults to `'BEFORE_HEADER'`.
