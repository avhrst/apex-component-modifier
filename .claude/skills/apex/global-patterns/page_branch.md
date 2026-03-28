# Page Branch Patterns

Patterns from APEX 24.2 exports (Apps 101-112, 258 pages with branches, 305 branch calls total).

## API Call

```sql
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(...)
,p_branch_name=>'Go To Page 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(...)
,p_branch_sequence=>10
,p_save_state_before_branch_yn=>'Y'
,p_branch_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_branch_condition=>'P1_STATUS'
,p_branch_condition_text=>'Y'
,p_branch_comment=>'Created 13-SEP-2012 12:08 by ALLAN'
);
```

## Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `p_id` | ID | Unique branch identifier via `wwv_flow_imp.id(...)` |
| `p_branch_action` | VARCHAR2 | Target URL (`f?p=...`) or page number (for BRANCH_TO_STEP) |
| `p_branch_point` | VARCHAR2 | When the branch fires (see catalog below) |
| `p_branch_type` | VARCHAR2 | `REDIRECT_URL` or `BRANCH_TO_STEP` |
| `p_branch_sequence` | NUMBER | Evaluation order (10, 20, 30…) |

## Common Optional Parameters

| Parameter | Type | Typical Values | Default |
|-----------|------|----------------|---------|
| `p_branch_name` | VARCHAR2 | Descriptive label | (none) |
| `p_branch_when_button_id` | ID | Fire only when this button was pressed | (any submit) |
| `p_save_state_before_branch_yn` | VARCHAR2 | `Y` | `N` |
| `p_branch_condition_type` | VARCHAR2 | See condition catalog | (unconditional) |
| `p_branch_condition` | VARCHAR2 | Item name, expression, or PL/SQL block | — |
| `p_branch_condition_text` | VARCHAR2 | Comparison value or language (`PLSQL`) | — |
| `p_branch_comment` | VARCHAR2 | Developer comment | (none) |

## Variations

### Variation A: Simple Redirect After Processing (most common — 299 of 305)

Unconditional redirect to a fixed page after form submit.

```sql
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(38805504655799378500)
,p_branch_action=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_comment=>'Created 13-SEP-2012 12:08 by ALLAN'
);
```

### Variation B: Button-Conditional Redirect

Branch fires only when a specific button is pressed.

```sql
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(65628058865682097)
,p_branch_name=>'Go to Orders'
,p_branch_action=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(65613469148682084)
,p_branch_sequence=>10
);
```

### Variation C: Item Value Condition

Redirect depends on comparing an item value.

```sql
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(13918464231362794005)
,p_branch_name=>'stay if user not found'
,p_branch_action=>'f?p=&APP_ID.:9999:&SESSION.::&DEBUG.:9999:P9999_USERNAME:&P9999_USERNAME.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_branch_condition=>'P9999_VALID_USER_YN'
,p_branch_condition_text=>'N'
);
```

### Variation D: PL/SQL Expression Condition

Branch fires when a PL/SQL expression evaluates to TRUE.

```sql
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(104332551451618145)
,p_branch_name=>'go welcome page '
,p_branch_action=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'BEFORE_HEADER'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'EXPRESSION'
,p_branch_condition=>'apex_app_setting.get_Value(''REMOTE_SERVER_INITIALIZED'') = ''NO'''
,p_branch_condition_text=>'PLSQL'
);
```

### Variation E: BEFORE_HEADER Redirect (Item Is Null Guard)

Redirect before page renders — typically a security/guard check.

```sql
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(10926729072226782310)
,p_branch_name=>'go to login if P9998_USERNAME is null'
,p_branch_action=>'f?p=&APP_ID.:9999:&SESSION.::&DEBUG.:9998,9999::'
,p_branch_point=>'BEFORE_HEADER'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'ITEM_IS_NULL'
,p_branch_condition=>'P9998_USERNAME'
);
```

### Variation F: BRANCH_TO_STEP (Legacy Page Redirect)

Redirects to a page by number without URL syntax. Less common (6 of 305).

```sql
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(8882911715950651793)
,p_branch_action=>'3'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'BRANCH_TO_STEP'
,p_branch_sequence=>10
);
```

### Variation G: Dynamic Target with Item Substitution

Branch target page comes from an item value (navigation pattern).

```sql
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(13966065668483098902)
,p_branch_name=>'branch to requested page'
,p_branch_action=>'f?p=&APP_ID.:&P45_NAVIGATION.:&SESSION.::&DEBUG.:RP,&P45_NAVIGATION.::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>40
);
```

### Variation H: Save State Before Branch

Saves session state before redirecting (e.g., fallback/catch-all branch).

```sql
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(17822194450527983623)
,p_branch_name=>'Go To Page 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>30
,p_save_state_before_branch_yn=>'Y'
);
```

### Variation I: Redirect with Item Values in URL

Pass item values to target page via the `f?p` URL.

```sql
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(2037019980454745268)
,p_branch_name=>'Go to Categories'
,p_branch_action=>'f?p=&APP_ID.:32:&SESSION.::&DEBUG.:RP:P32_CATEGORY,P32_GEO:&P1_CATEGORY.,&P1_GEO.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(13564721231128040746)
,p_branch_sequence=>20
);
```

## Parameter Value Catalog

| Parameter | All Observed Values |
|-----------|-------------------|
| `p_branch_type` | `REDIRECT_URL` (299), `BRANCH_TO_STEP` (6) |
| `p_branch_point` | `AFTER_PROCESSING` (274), `BEFORE_HEADER` (19), `BEFORE_COMPUTATION` (6), `BEFORE_VALIDATION` (5), `BEFORE_PROCESSING` (1) |
| `p_branch_condition_type` | `EXPRESSION` (19), `VAL_OF_ITEM_IN_COND_EQ_COND2` (12), `REQUEST_EQUALS_CONDITION` (2), `NEVER` (2), `ITEM_IS_NULL` (2), `FUNCTION_BODY` (1) |
| `p_branch_condition_text` | `PLSQL` (with EXPRESSION), `YES`/`NO`/`Y`/`N` (with VAL_OF_ITEM), request name (with REQUEST_EQUALS) |
| `p_save_state_before_branch_yn` | `Y` (19 occurrences — omit for default N) |

## f?p URL Format

The `p_branch_action` URL follows the standard APEX `f?p` format:

```
f?p=APP:PAGE:SESSION:REQUEST:DEBUG:CLEAR_CACHE:ITEMS:VALUES:PRINTER_FRIENDLY
```

Common patterns:
- `f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#` — basic redirect
- `f?p=&APP_ID.:32:&SESSION.::&DEBUG.:RP:P32_X:&P1_X.` — clear cache + pass items
- `f?p=&APP_ID.:&P1_NAV.:&SESSION.::&DEBUG.:RP,&P1_NAV.::` — dynamic page from item
- `f?p=&APP_ID.:9999:&SESSION.::&DEBUG.:9998,9999::` — clear multiple pages

## Relationships

- **Parent**: page (branches are page-level components)
- **Depends on**: buttons (`p_branch_when_button_id` references `create_page_button`)
- **Ordering**: `p_branch_sequence` controls evaluation order; first matching branch wins
- **Condition triplet**: `p_branch_condition_type` + `p_branch_condition` + `p_branch_condition_text` work together
