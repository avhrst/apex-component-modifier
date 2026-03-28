# Valid Parameter Values Reference

APEX 24.2 source. All valid enumerated parameter values.
Cross-checked against 29 example apps (2026-03-28).

## Region Types (`p_plug_source_type`)

| Value | Notes |
|-------|-------|
| `NATIVE_STATIC` | |
| `NATIVE_PLSQL` | |
| `NATIVE_DYNAMIC_CONTENT` | |
| `NATIVE_SQL_REPORT` | Classic Report |
| `NATIVE_IR` | Interactive Report |
| `NATIVE_IG` | Interactive Grid |
| `NATIVE_FORM` | |
| `NATIVE_CARDS` | |
| `NATIVE_JET_CHART` | |
| `NATIVE_MAP_REGION` | |
| `NATIVE_CSS_CALENDAR` | |
| `NATIVE_FACETED_SEARCH` | |
| `NATIVE_SMART_FILTERS` | |
| `NATIVE_SEARCH_REGION` | |
| `NATIVE_LIST` | |
| `NATIVE_BREADCRUMB` | |
| `NATIVE_JSTREE` | Tree |
| `NATIVE_DISPLAY_SELECTOR` | |
| `NATIVE_URL` | |
| `NATIVE_HELP_TEXT` | |
| `NATIVE_WORKFLOW_DIAGRAM` | |
| `NATIVE_JQM_COLUMN_TOGGLE` | jQuery Mobile — legacy |
| `NATIVE_JQM_LIST_VIEW` | jQuery Mobile — legacy |
| `NATIVE_JQM_REFLOW` | jQuery Mobile — legacy |

> Plugin regions use `PLUGIN_<name>` prefix (e.g. `PLUGIN_COM.ORACLE.APEX.BADGE_LIST`).
> Template component regions use `TMPL_<name>` prefix (e.g. `TMPL_THEME_42$CONTENT_ROW`).

## Item Types (`p_display_as`)

| Value | Notes |
|-------|-------|
| `NATIVE_TEXT_FIELD` | |
| `NATIVE_TEXTAREA` | |
| `NATIVE_NUMBER_FIELD` | |
| `NATIVE_PASSWORD` | |
| `NATIVE_HIDDEN` | |
| `NATIVE_DISPLAY_ONLY` | |
| `NATIVE_SELECT_LIST` | |
| `NATIVE_CHECKBOX` | Checkbox group |
| `NATIVE_SINGLE_CHECKBOX` | |
| `NATIVE_RADIOGROUP` | |
| `NATIVE_POPUP_LOV` | |
| `NATIVE_SHUTTLE` | |
| `NATIVE_DATE_PICKER_APEX` | Current |
| `NATIVE_DATE_PICKER` | Deprecated 21.1 |
| `NATIVE_FILE` | File browse |
| `NATIVE_IMAGE_UPLOAD` | |
| `NATIVE_RICH_TEXT_EDITOR` | |
| `NATIVE_MARKDOWN_EDITOR` | |
| `NATIVE_COLOR_PICKER` | |
| `NATIVE_AUTO_COMPLETE` | |
| `NATIVE_LIST_MANAGER` | |
| `NATIVE_RANGE` | Range slider |
| `NATIVE_YES_NO` | Yes/No switch |
| `NATIVE_STAR_RATING` | |
| `NATIVE_PCT_GRAPH` | Percent graph |
| `NATIVE_DISPLAY_IMAGE` | |
| `NATIVE_LINK` | |
| `NATIVE_HTML_EXPRESSION` | |
| `NATIVE_QRCODE` | |
| `NATIVE_GEOCODED_ADDRESS` | |
| `NATIVE_DISPLAY_MAP` | |
| `NATIVE_COMBOBOX` | |
| `NATIVE_SELECT_ONE` | |
| `NATIVE_SELECT_MANY` | |
| `NATIVE_INPUT` | Generic |
| `NATIVE_SEARCH` | |
| `NATIVE_ROW_ACTION` | IG only |
| `NATIVE_ROW_SELECTOR` | IG only |
| `NATIVE_STOP_AND_START_HTML_TABLE` | Legacy layout control |

> Legacy display types: `TEXT_FROM_LOV_ESC`, `WITHOUT_MODIFICATION` (pre-NATIVE_ era).
> Plugin items use `PLUGIN_<name>` prefix (e.g. `PLUGIN_COM.ORACLE.APEX.SLIDER`).

## Process Types (`p_process_type`)

| Value | Notes |
|-------|-------|
| `NATIVE_PLSQL` | |
| `NATIVE_FORM_FETCH` | Auto row fetch |
| `NATIVE_FORM_DML` | Auto Row Processing |
| `NATIVE_FORM_PROCESS` | Form DML (deprecated — use `NATIVE_FORM_DML`) |
| `NATIVE_FORM_INIT` | |
| `NATIVE_FORM_PAGINATION` | Form page navigation |
| `NATIVE_IG_DML` | |
| `NATIVE_INVOKE_API` | |
| `NATIVE_EXECUTION_CHAIN` | |
| `NATIVE_SEND_EMAIL` | |
| `NATIVE_SEND_PUSH_NOTIFICATION` | |
| `NATIVE_CREATE_TASK` | Human task |
| `NATIVE_MANAGE_TASK` | |
| `NATIVE_CLOSE_WINDOW` | Close dialog |
| `NATIVE_SESSION_STATE` | |
| `NATIVE_USER_PREFERENCES` | |
| `NATIVE_RESET_PAGINATION` | |
| `NATIVE_WEB_SERVICE` | |
| `NATIVE_DOWNLOAD` | |
| `NATIVE_GEOCODING` | |
| `NATIVE_PRINT_REPORT` | |
| `NATIVE_WORKFLOW` | |
| `NATIVE_INVOKE_WF` | |
| `NATIVE_DATA_LOADING` | Data loading |
| `NATIVE_LOAD_UPLOADED_DATA` | Load uploaded file data |
| `NATIVE_PARSE_UPLOADED_DATA` | Parse uploaded file |

> Plugin processes use `PLUGIN_<name>` prefix (e.g. `PLUGIN_COM.ORACLE.APEX.DOCGEN`).

## Dynamic Action Types (`p_action`)

| Value | Notes |
|-------|-------|
| `NATIVE_SHOW` | |
| `NATIVE_HIDE` | |
| `NATIVE_ENABLE` | |
| `NATIVE_DISABLE` | |
| `NATIVE_SET_VALUE` | |
| `NATIVE_CLEAR` | |
| `NATIVE_SET_FOCUS` | |
| `NATIVE_REFRESH` | |
| `NATIVE_SUBMIT_PAGE` | |
| `NATIVE_JAVASCRIPT_CODE` | Execute JS |
| `NATIVE_EXECUTE_PLSQL_CODE` | Execute PL/SQL |
| `NATIVE_ALERT` | |
| `NATIVE_CONFIRM` | |
| `NATIVE_DIALOG_CANCEL` | |
| `NATIVE_DIALOG_CLOSE` | |
| `NATIVE_ADD_CLASS` | CSS class |
| `NATIVE_REMOVE_CLASS` | CSS class |
| `NATIVE_SET_CSS` | |
| `NATIVE_CANCEL_EVENT` | |
| `NATIVE_OPEN_REGION` | Collapsible |
| `NATIVE_CLOSE_REGION` | Collapsible |
| `NATIVE_DOWNLOAD` | |
| `NATIVE_PRINT_REPORT` | |
| `NATIVE_OPEN_AI_ASSISTANT` | |
| `NATIVE_GENERATE_TEXT_AI` | |
| `NATIVE_GET_CURRENT_POSITION` | Geolocation |
| `NATIVE_SHARE` | Web Share API |
| `NATIVE_TREE_COLLAPSE` | Tree region |
| `NATIVE_TREE_EXPAND` | Tree region |

## DA Event Types (`p_bind_event_type`)

| Value | Notes |
|-------|-------|
| `change` | |
| `click` | |
| `dblclick` | |
| `keydown` / `keyup` / `keypress` | Keyboard |
| `focus` / `blur` | Non-bubbling |
| `focusin` / `focusout` | Bubbling equivalents of focus/blur |
| `mouseover` / `mouseout` | |
| `mouseenter` / `mouseleave` | |
| `input` | Fires on every keystroke/input change |
| `scroll` | |
| `ready` | Page load |
| `apexbeforerefresh` | Before AJAX refresh |
| `apexafterrefresh` | After AJAX refresh |
| `apexbeforepagesubmit` | |
| `apexafterpagesubmit` | |
| `apexafterclosedialog` | |
| `apexaftercanceldialog` | |
| `apexafterclosecanceldialog` | Either close or cancel |
| `apexwindowresized` | |
| `apexreadyend` | |
| `apexpan` | Mobile gesture |
| `apexpress` | Mobile gesture |
| `apexswipe` | Mobile gesture |
| `apextap` | Mobile gesture |
| `custom` | |

Component-specific events (set via region type binding):

| Value | Component |
|-------|-----------|
| `apexcalendardateselect` | Calendar |
| `apexcalendareventselect` | Calendar |
| `apexcalendarviewchange` | Calendar |
| `interactivegridselectionchange` | Interactive Grid |
| `treeviewselectionchange` | Tree |
| `spatialmapchanged` | Map Region |
| `spatialmapclick` | Map Region |
| `spatialmapobjectclick` | Map Region |

## DA Triggering Element Types (`p_triggering_element_type`)

`ITEM` | `REGION` | `BUTTON` | `JQUERY_SELECTOR` | `JAVASCRIPT_EXPRESSION` | `COLUMN` | `DOM_OBJECT` | `TRIGGERING_ELEMENT`

## Page Mode (`p_page_mode`)

`NORMAL` | `MODAL` | `NON-MODAL`

> Parameter omitted for normal pages (default). Exports show `MODAL` not `MODAL DIALOG`.

## Button Action (`p_button_action`)

`SUBMIT` | `REDIRECT_URL` | `REDIRECT_PAGE` | `DEFINED_BY_DA`

## Process Points (`p_process_point`)

| Value | Notes |
|-------|-------|
| `BEFORE_HEADER` | |
| `AFTER_HEADER` | |
| `BEFORE_BOX_BODY` | Before page body renders |
| `BEFORE_FOOTER` | |
| `ON_SUBMIT_BEFORE_COMPUTATION` | |
| `AFTER_SUBMIT` | |
| `ON_DEMAND` | AJAX callback |
| `AFTER_LOGIN` | Application-level |
| `ON_NEW_INSTANCE` | Application-level |

## Branch Points (`p_branch_point`)

`BEFORE_HEADER` | `BEFORE_COMPUTATION` | `BEFORE_PROCESSING` | `BEFORE_VALIDATION` | `AFTER_PROCESSING`

## Branch Types (`p_branch_type`)

`REDIRECT_URL` | `BRANCH_TO_PAGE_ACCEPT` | `BRANCH_TO_PAGE_IDENT` | `BRANCH_TO_STEP` | `PLSQL_PROCEDURE`

## Validation Types (`p_validation_type`)

| Value | Notes |
|-------|-------|
| `NOT_NULL` | |
| `ITEM_NOT_NULL` | Alias of NOT_NULL |
| `ITEM_REQUIRED` | |
| `ITEM_IS_DATE` | |
| `ITEM_IS_TIMESTAMP` | |
| `ITEM_IS_NUMERIC` | |
| `ITEM_IS_ALPHANUMERIC` | |
| `ITEM_MATCHES_REGULAR_EXPRESSION` | |
| `REGULAR_EXPRESSION` | Alias |
| `ITEM_IN_VALIDATION_CONTAINS_NO_SPACES` | |
| `SQL_EXPRESSION` | |
| `PLSQL_EXPRESSION` | |
| `PLSQL_ERROR` | |
| `EXISTS` | SQL returns rows |
| `NOT_EXISTS` | SQL returns no rows |
| `EXPRESSION` | PL/SQL expression |
| `FUNC_BODY_RETURNING_BOOLEAN` | |
| `FUNC_BODY_RETURNING_ERR_TEXT` | |

## Data Types (`p_data_type`)

`VARCHAR2` | `NUMBER` | `DATE` | `TIMESTAMP` | `TIMESTAMP_TZ` | `TIMESTAMP_LTZ` | `CLOB` | `BLOB` | `BOOLEAN` | `ROWID` | `SDO_GEOMETRY`

## Source Types (`p_source_type`)

| Value | Notes |
|-------|-------|
| `ALWAYS_NULL` | |
| `STATIC` | |
| `NONE` | No source |
| `ITEM` | |
| `SQL` | SQL query |
| `SQL_EXPRESSION` | |
| `PLSQL_EXPRESSION` | |
| `PLSQL_FUNCTION_BODY` | |
| `EXPRESSION` | Generic expression |
| `FUNCTION_BODY` | Generic function body |
| `QUERY` | Query source |
| `QUERY_COLON` | Query with colon-bind syntax |
| `DB_COLUMN` | |
| `REGION_SOURCE_COLUMN` | |
| `PREFERENCE` | |
| `REQUEST` | |
| `FACET_COLUMN` | |
| `TABLE` | Table/view source |
| `LEGACY_SQL` | Pre-NATIVE_ era |

## Query Types (`p_query_type`)

`SQL` | `TABLE` | `FUNC_BODY_RETURNING_SQL`

## Location (`p_location`)

`LOCAL` | `REMOTE` | `WEB_SOURCE` | `REGION_SOURCE` | `STATIC`

## Protection Level (`p_protection_level`)

| Value | Description |
|-------|-------------|
| `N` | Unrestricted |
| `I` | Arguments must have checksum (item level) |
| `B` | Arguments must have checksum |
| `C` | No arguments allowed |
| `D` | No URL access |
| `S` | Checksum required - session |
| `U` | Checksum required - user |
| `P` | Checksum required - application |

## Error Display Location (`p_error_display_location`)

`ON_ERROR_PAGE` | `INLINE_WITH_FIELD` | `INLINE_WITH_FIELD_AND_NOTIFICATION` | `INLINE_IN_NOTIFICATION`

## IG Edit Operations (`p_edit_operations`)

`i` | `u` | `d` | `i:u` | `u:d` | `i:u:d`

## Condition Types (`p_display_when_type`, `p_read_only_when_type`, `p_process_when_type`, etc.)

| Value | Notes |
|-------|-------|
| `NEVER` | Never display/execute |
| `ALWAYS` | Always display/execute |
| `REQUEST_EQUALS_CONDITION` | Request = value |
| `REQUEST_NOT_EQUAL_CONDITION` | Request != value |
| `REQUEST_IN_CONDITION` | Request in comma-separated list |
| `REQUEST_NOT_IN_CONDITION` | Request not in comma-separated list |
| `ITEM_IS_NULL` | Item value is null |
| `ITEM_IS_NOT_NULL` | Item value is not null |
| `ITEM_EQUALS_VALUE` | Item = value |
| `ITEM_NOT_EQUAL_VALUE` | Item != value |
| `ITEM_IN_LIST` | Item in comma-separated list |
| `EXISTS` | SQL query returns rows |
| `NOT_EXISTS` | SQL query returns no rows |
| `EXPRESSION` | PL/SQL expression returns true |
| `PLSQL_EXPRESSION` | PL/SQL expression |
| `SQL_EXPRESSION` | SQL expression |
| `FUNCTION_BODY` | PL/SQL function body returning boolean |
| `CURRENT_PAGE_EQUALS_CONDITION` | Current page = value |
| `CURRENT_PAGE_NOT_EQUAL_CONDITION` | Current page != value |
| `CURRENT_PAGE_IN_CONDITION` | Current page in list |
| `CURRENT_PAGE_NOT_IN_CONDITION` | Current page not in list |
| `VALUE_OF_ITEM_IN_CONDITION_EQUALS_COND2` | Item = second condition value |
| `VAL_OF_ITEM_IN_COND_EQ_COND2` | Short alias of above |
| `VAL_OF_ITEM_IN_COND_NOT_EQ_COND2` | Item != second condition value |
| `VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST` | Item in colon-delimited list |
| `VALUE_OF_ITEM_IN_CONDITION_NOT_IN_COLON_DELIMITED_LIST` | Item not in colon-delimited list |

## Authorization Caching (`p_caching`)

| Value | Notes |
|-------|-------|
| `BY_USER_BY_SESSION` | Once per user per session |
| `BY_USER_BY_PAGE_VIEW` | Every page view |
| `ALL_USERS` | Cached for all users |
| `NOCACHE` | No caching (evaluate every time) |

## Chart Types (`p_chart_type`)

`area` | `bar` | `boxPlot` | `bubble` | `combo` | `dial` | `donut` | `funnel` | `gantt` | `line` | `lineWithArea` | `pie` | `polar` | `pyramid` | `radar` | `range` | `scatter` | `stock` | `waterfall`
