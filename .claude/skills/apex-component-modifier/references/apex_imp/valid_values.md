# Valid Parameter Values Reference

APEX 24.2 source. All valid enumerated parameter values.

## Region Types (`p_plug_source_type`)

| Value |
|-------|
| `NATIVE_STATIC` |
| `NATIVE_PLSQL` |
| `NATIVE_DYNAMIC_CONTENT` |
| `NATIVE_SQL_REPORT` -- Classic Report |
| `NATIVE_IR` -- Interactive Report |
| `NATIVE_IG` -- Interactive Grid |
| `NATIVE_FORM` |
| `NATIVE_CARDS` |
| `NATIVE_JET_CHART` |
| `NATIVE_MAP_REGION` |
| `NATIVE_CSS_CALENDAR` |
| `NATIVE_FACETED_SEARCH` |
| `NATIVE_SMART_FILTERS` |
| `NATIVE_SEARCH_REGION` |
| `NATIVE_LIST` |
| `NATIVE_BREADCRUMB` |
| `NATIVE_JSTREE` -- Tree |
| `NATIVE_DISPLAY_SELECTOR` |
| `NATIVE_URL` |
| `NATIVE_HELP_TEXT` |
| `NATIVE_WORKFLOW_DIAGRAM` |

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

## Process Types (`p_process_type`)

| Value | Notes |
|-------|-------|
| `NATIVE_PLSQL` | |
| `NATIVE_FORM_FETCH` | Auto row fetch |
| `NATIVE_FORM_DML` | Auto Row Processing |
| `NATIVE_FORM_PROCESS` | Form DML |
| `NATIVE_FORM_INIT` | |
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

## DA Event Types (`p_bind_event_type`)

| Value | Notes |
|-------|-------|
| `change` | |
| `click` | |
| `dblclick` | |
| `keydown` / `keyup` / `keypress` | Keyboard |
| `focus` / `blur` | |
| `mouseover` / `mouseout` | |
| `mouseenter` / `mouseleave` | |
| `ready` | Page load |
| `apexbeforerefresh` | Before AJAX refresh |
| `apexafterrefresh` | After AJAX refresh |
| `apexbeforepagesubmit` | |
| `apexafterpagesubmit` | |
| `apexafterclose dialog` | |
| `apexaftercanceldialog` | |
| `apexwindowresized` | |
| `apexreadyend` | |
| `custom` | |

## DA Triggering Element Types (`p_triggering_element_type`)

`ITEM` | `REGION` | `BUTTON` | `JQUERY_SELECTOR` | `JAVASCRIPT_EXPRESSION` | `COLUMN` | `DOM_OBJECT` | `TRIGGERING_ELEMENT`

## Page Mode (`p_page_mode`)

`NORMAL` | `MODAL DIALOG` | `NON-MODAL DIALOG`

## Button Action (`p_button_action`)

`SUBMIT` | `REDIRECT_URL` | `REDIRECT_PAGE` | `DEFINED_BY_DA`

## Process Points (`p_process_point`)

| Value |
|-------|
| `BEFORE_HEADER` |
| `AFTER_HEADER` |
| `BEFORE_FOOTER` |
| `ON_SUBMIT_BEFORE_COMPUTATION` |
| `AFTER_SUBMIT` |
| `ON_DEMAND` -- AJAX |

## Branch Points (`p_branch_point`)

`BEFORE_HEADER` | `BEFORE_PROCESSING` | `BEFORE_VALIDATION` | `AFTER_PROCESSING`

## Branch Types (`p_branch_type`)

`REDIRECT_URL` | `BRANCH_TO_PAGE_ACCEPT` | `BRANCH_TO_PAGE_IDENT` | `PLSQL_PROCEDURE`

## Validation Types (`p_validation_type`)

| Value |
|-------|
| `NOT_NULL` |
| `ITEM_IS_DATE` |
| `ITEM_IS_NUMERIC` |
| `ITEM_MATCHES_REGULAR_EXPRESSION` |
| `ITEM_IN_VALIDATION_CONTAINS_NO_SPACES` |
| `ITEM_IS_ALPHANUMERIC` |
| `SQL_EXPRESSION` |
| `PLSQL_EXPRESSION` |
| `PLSQL_ERROR` |
| `FUNC_BODY_RETURNING_BOOLEAN` |
| `FUNC_BODY_RETURNING_ERR_TEXT` |
| `ITEM_REQUIRED` |

## Data Types (`p_data_type`)

`VARCHAR2` | `NUMBER` | `DATE` | `TIMESTAMP` | `TIMESTAMP_TZ` | `TIMESTAMP_LTZ` | `CLOB` | `BLOB` | `SDO_GEOMETRY`

## Source Types (`p_source_type`)

| Value |
|-------|
| `ALWAYS_NULL` |
| `STATIC` |
| `ITEM` |
| `SQL_EXPRESSION` |
| `PLSQL_EXPRESSION` |
| `PLSQL_FUNCTION_BODY` |
| `DB_COLUMN` |
| `REGION_SOURCE_COLUMN` |
| `PREFERENCE` |
| `REQUEST` |
| `FACET_COLUMN` |

## Query Types (`p_query_type`)

`SQL` | `TABLE` | `FUNC_BODY_RETURNING_SQL`

## Location (`p_location`)

`LOCAL` | `REMOTE` | `WEB_SOURCE`

## Protection Level (`p_protection_level`)

| Value | Description |
|-------|-------------|
| `N` | Unrestricted |
| `B` | Arguments must have checksum |
| `C` | No arguments allowed |
| `D` | No URL access |
| `S` | Checksum required - session |
| `U` | Checksum required - user |
| `P` | Checksum required - application |

## Error Display Location (`p_error_display_location`)

`ON_ERROR_PAGE` | `INLINE_WITH_FIELD` | `INLINE_WITH_FIELD_AND_NOTIFICATION` | `INLINE_IN_NOTIFICATION`

## IG Edit Operations (`p_edit_operations`)

`i` | `u` | `d` | `i:u` | `i:u:d`

## Chart Types (`p_chart_type`)

`area` | `bar` | `bubble` | `combo` | `dial` | `donut` | `funnel` | `gantt` | `line` | `lineWithArea` | `pie` | `polar` | `pyramid` | `radar` | `range` | `scatter` | `stock` | `waterfall`
