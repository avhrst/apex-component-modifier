# Valid Parameter Values Reference

Comprehensive enumeration of all valid parameter values from APEX 24.2 source.

---

## Region Types (`p_plug_source_type`)

| Value | Description |
|-------|-------------|
| `NATIVE_STATIC` | Static content |
| `NATIVE_PLSQL` | PL/SQL dynamic content |
| `NATIVE_DYNAMIC_CONTENT` | Dynamic content |
| `NATIVE_SQL_REPORT` | Classic Report |
| `NATIVE_IR` | Interactive Report |
| `NATIVE_IG` | Interactive Grid |
| `NATIVE_FORM` | Form region |
| `NATIVE_CARDS` | Cards |
| `NATIVE_JET_CHART` | JET Chart |
| `NATIVE_MAP_REGION` | Map |
| `NATIVE_CSS_CALENDAR` | Calendar |
| `NATIVE_FACETED_SEARCH` | Faceted Search |
| `NATIVE_SMART_FILTERS` | Smart Filters |
| `NATIVE_SEARCH_REGION` | Search region |
| `NATIVE_LIST` | List |
| `NATIVE_BREADCRUMB` | Breadcrumb |
| `NATIVE_JSTREE` | Tree (jsTree) |
| `NATIVE_DISPLAY_SELECTOR` | Region Display Selector |
| `NATIVE_URL` | URL region |
| `NATIVE_HELP_TEXT` | Help text |
| `NATIVE_WORKFLOW_DIAGRAM` | Workflow diagram |

---

## Item Types (`p_display_as`)

| Value | Description |
|-------|-------------|
| `NATIVE_TEXT_FIELD` | Text field |
| `NATIVE_TEXTAREA` | Text area |
| `NATIVE_NUMBER_FIELD` | Number field |
| `NATIVE_PASSWORD` | Password |
| `NATIVE_HIDDEN` | Hidden |
| `NATIVE_DISPLAY_ONLY` | Display only |
| `NATIVE_SELECT_LIST` | Select list |
| `NATIVE_CHECKBOX` | Checkbox group |
| `NATIVE_SINGLE_CHECKBOX` | Single checkbox |
| `NATIVE_RADIOGROUP` | Radio group |
| `NATIVE_POPUP_LOV` | Popup LOV |
| `NATIVE_SHUTTLE` | Shuttle |
| `NATIVE_DATE_PICKER_APEX` | Date picker (current) |
| `NATIVE_DATE_PICKER` | Date picker (deprecated 21.1) |
| `NATIVE_FILE` | File browse |
| `NATIVE_IMAGE_UPLOAD` | Image upload |
| `NATIVE_RICH_TEXT_EDITOR` | Rich text editor |
| `NATIVE_MARKDOWN_EDITOR` | Markdown editor |
| `NATIVE_COLOR_PICKER` | Color picker |
| `NATIVE_AUTO_COMPLETE` | Auto complete |
| `NATIVE_LIST_MANAGER` | List manager |
| `NATIVE_RANGE` | Range slider |
| `NATIVE_YES_NO` | Yes/No switch |
| `NATIVE_STAR_RATING` | Star rating |
| `NATIVE_PCT_GRAPH` | Percent graph |
| `NATIVE_DISPLAY_IMAGE` | Display image |
| `NATIVE_LINK` | Link |
| `NATIVE_HTML_EXPRESSION` | HTML expression |
| `NATIVE_QRCODE` | QR code |
| `NATIVE_GEOCODED_ADDRESS` | Geocoded address |
| `NATIVE_DISPLAY_MAP` | Display map |
| `NATIVE_COMBOBOX` | Combobox |
| `NATIVE_SELECT_ONE` | Select one |
| `NATIVE_SELECT_MANY` | Select many |
| `NATIVE_INPUT` | Generic input |
| `NATIVE_SEARCH` | Search item |
| `NATIVE_ROW_ACTION` | Row action (IG) |
| `NATIVE_ROW_SELECTOR` | Row selector (IG) |

---

## Process Types (`p_process_type`)

| Value | Description |
|-------|-------------|
| `NATIVE_PLSQL` | PL/SQL code |
| `NATIVE_FORM_FETCH` | Automatic row fetch |
| `NATIVE_FORM_DML` | Form - Automatic Row Processing (DML) |
| `NATIVE_FORM_PROCESS` | Form DML process |
| `NATIVE_FORM_INIT` | Form initialization |
| `NATIVE_IG_DML` | Interactive Grid DML |
| `NATIVE_INVOKE_API` | Invoke API |
| `NATIVE_EXECUTION_CHAIN` | Execution chain |
| `NATIVE_SEND_EMAIL` | Send email |
| `NATIVE_SEND_PUSH_NOTIFICATION` | Push notification |
| `NATIVE_CREATE_TASK` | Create human task |
| `NATIVE_MANAGE_TASK` | Manage human task |
| `NATIVE_CLOSE_WINDOW` | Close dialog |
| `NATIVE_SESSION_STATE` | Session state |
| `NATIVE_USER_PREFERENCES` | User preferences |
| `NATIVE_RESET_PAGINATION` | Reset pagination |
| `NATIVE_WEB_SERVICE` | Web service |
| `NATIVE_DOWNLOAD` | Download |
| `NATIVE_GEOCODING` | Geocoding |
| `NATIVE_PRINT_REPORT` | Print report |
| `NATIVE_WORKFLOW` | Workflow |
| `NATIVE_INVOKE_WF` | Invoke workflow |

---

## Dynamic Action Types (`p_action`)

| Value | Description |
|-------|-------------|
| `NATIVE_SHOW` | Show element |
| `NATIVE_HIDE` | Hide element |
| `NATIVE_ENABLE` | Enable |
| `NATIVE_DISABLE` | Disable |
| `NATIVE_SET_VALUE` | Set value |
| `NATIVE_CLEAR` | Clear value |
| `NATIVE_SET_FOCUS` | Set focus |
| `NATIVE_REFRESH` | Refresh region/item |
| `NATIVE_SUBMIT_PAGE` | Submit page |
| `NATIVE_JAVASCRIPT_CODE` | Execute JavaScript |
| `NATIVE_EXECUTE_PLSQL_CODE` | Execute PL/SQL |
| `NATIVE_ALERT` | Show alert |
| `NATIVE_CONFIRM` | Show confirmation |
| `NATIVE_DIALOG_CANCEL` | Cancel dialog |
| `NATIVE_DIALOG_CLOSE` | Close dialog |
| `NATIVE_ADD_CLASS` | Add CSS class |
| `NATIVE_REMOVE_CLASS` | Remove CSS class |
| `NATIVE_SET_CSS` | Set CSS |
| `NATIVE_CANCEL_EVENT` | Cancel event |
| `NATIVE_OPEN_REGION` | Open collapsible region |
| `NATIVE_CLOSE_REGION` | Close collapsible region |
| `NATIVE_DOWNLOAD` | Download file |
| `NATIVE_PRINT_REPORT` | Print report |
| `NATIVE_OPEN_AI_ASSISTANT` | Open AI Assistant |
| `NATIVE_GENERATE_TEXT_AI` | Generate text with AI |

---

## DA Event Types (`p_bind_event_type`)

| Value | Description |
|-------|-------------|
| `change` | Value change |
| `click` | Mouse click |
| `dblclick` | Double click |
| `keydown` / `keyup` / `keypress` | Keyboard events |
| `focus` / `blur` | Focus events |
| `mouseover` / `mouseout` | Mouse events |
| `mouseenter` / `mouseleave` | Mouse enter/leave |
| `ready` | Page ready (load) |
| `apexbeforerefresh` | Before AJAX refresh |
| `apexafterrefresh` | After AJAX refresh |
| `apexbeforepagesubmit` | Before page submit |
| `apexafterpagesubmit` | After page submit |
| `apexafterclose dialog` | After dialog close |
| `apexaftercanceldialog` | After dialog cancel |
| `apexwindowresized` | Window resized |
| `apexreadyend` | Page ready end |
| `custom` | Custom event |

---

## DA Triggering Element Types (`p_triggering_element_type`)

| Value | Description |
|-------|-------------|
| `ITEM` | Page item |
| `REGION` | Region |
| `BUTTON` | Button |
| `JQUERY_SELECTOR` | jQuery selector |
| `JAVASCRIPT_EXPRESSION` | JavaScript expression |
| `COLUMN` | Region column |
| `DOM_OBJECT` | DOM object |
| `TRIGGERING_ELEMENT` | (self) |

---

## Page Mode (`p_page_mode`)

| Value | Description |
|-------|-------------|
| `NORMAL` | Standard page |
| `MODAL DIALOG` | Modal dialog |
| `NON-MODAL DIALOG` | Non-modal dialog |

---

## Button Action (`p_button_action`)

| Value | Description |
|-------|-------------|
| `SUBMIT` | Submit page |
| `REDIRECT_URL` | Redirect to URL |
| `REDIRECT_PAGE` | Redirect to page |
| `DEFINED_BY_DA` | Defined by dynamic action |

---

## Process Points (`p_process_point`)

| Value | Description |
|-------|-------------|
| `BEFORE_HEADER` | Before page header |
| `AFTER_HEADER` | After page header |
| `BEFORE_FOOTER` | Before page footer |
| `ON_SUBMIT_BEFORE_COMPUTATION` | Before computations |
| `AFTER_SUBMIT` | After submit |
| `ON_DEMAND` | On demand (AJAX) |

---

## Branch Points (`p_branch_point`)

| Value | Description |
|-------|-------------|
| `BEFORE_HEADER` | Before header |
| `BEFORE_PROCESSING` | Before processing |
| `BEFORE_VALIDATION` | Before validations |
| `AFTER_PROCESSING` | After processing |

---

## Branch Types (`p_branch_type`)

| Value | Description |
|-------|-------------|
| `REDIRECT_URL` | Redirect to URL |
| `BRANCH_TO_PAGE_ACCEPT` | Branch to page (accept) |
| `BRANCH_TO_PAGE_IDENT` | Branch to page (identified) |
| `PLSQL_PROCEDURE` | PL/SQL procedure |

---

## Validation Types (`p_validation_type`)

| Value | Description |
|-------|-------------|
| `NOT_NULL` | Not null |
| `ITEM_IS_DATE` | Item is date |
| `ITEM_IS_NUMERIC` | Item is numeric |
| `ITEM_MATCHES_REGULAR_EXPRESSION` | Matches regex |
| `ITEM_IN_VALIDATION_CONTAINS_NO_SPACES` | No spaces |
| `ITEM_IS_ALPHANUMERIC` | Alphanumeric |
| `SQL_EXPRESSION` | SQL expression |
| `PLSQL_EXPRESSION` | PL/SQL expression |
| `PLSQL_ERROR` | PL/SQL error text |
| `FUNC_BODY_RETURNING_BOOLEAN` | Function body → boolean |
| `FUNC_BODY_RETURNING_ERR_TEXT` | Function body → error text |
| `ITEM_REQUIRED` | Item required |

---

## Data Types (`p_data_type`)

| Value | Description |
|-------|-------------|
| `VARCHAR2` | Character string |
| `NUMBER` | Numeric |
| `DATE` | Date |
| `TIMESTAMP` | Timestamp |
| `TIMESTAMP_TZ` | Timestamp with time zone |
| `TIMESTAMP_LTZ` | Timestamp with local time zone |
| `CLOB` | Character large object |
| `BLOB` | Binary large object |
| `SDO_GEOMETRY` | Spatial geometry |

---

## Source Types (`p_source_type`)

| Value | Description |
|-------|-------------|
| `ALWAYS_NULL` | Always null |
| `STATIC` | Static value |
| `ITEM` | Item value |
| `SQL_EXPRESSION` | SQL expression |
| `PLSQL_EXPRESSION` | PL/SQL expression |
| `PLSQL_FUNCTION_BODY` | PL/SQL function body |
| `DB_COLUMN` | Database column |
| `REGION_SOURCE_COLUMN` | Region source column |
| `PREFERENCE` | User preference |
| `REQUEST` | Request value |
| `FACET_COLUMN` | Faceted search column |

---

## Query Types (`p_query_type`)

| Value | Description |
|-------|-------------|
| `SQL` | SQL query |
| `TABLE` | Table/view |
| `FUNC_BODY_RETURNING_SQL` | Function returning SQL |

---

## Location (`p_location`)

| Value | Description |
|-------|-------------|
| `LOCAL` | Local database |
| `REMOTE` | Remote database |
| `WEB_SOURCE` | REST data source |

---

## Protection Level (`p_protection_level`)

| Value | Description |
|-------|-------------|
| `N` | Unrestricted |
| `B` | Arguments must have checksum |
| `C` | No arguments allowed |
| `D` | No URL access |
| `S` | Checksum required - session level |
| `U` | Checksum required - user level |
| `P` | Checksum required - application level |

---

## Error Display Location (`p_error_display_location`)

| Value | Description |
|-------|-------------|
| `ON_ERROR_PAGE` | On error page |
| `INLINE_WITH_FIELD` | Inline with field |
| `INLINE_WITH_FIELD_AND_NOTIFICATION` | Inline with field and notification |
| `INLINE_IN_NOTIFICATION` | Inline in notification |

---

## IG Edit Operations (`p_edit_operations`)

| Value | Description |
|-------|-------------|
| `i` | Insert |
| `u` | Update |
| `d` | Delete |
| `i:u` | Insert + Update |
| `i:u:d` | Insert + Update + Delete |

---

## Chart Types (`p_chart_type`)

`area` | `bar` | `bubble` | `combo` | `dial` | `donut` | `funnel` | `gantt` | `line` | `lineWithArea` | `pie` | `polar` | `pyramid` | `radar` | `range` | `scatter` | `stock` | `waterfall`
