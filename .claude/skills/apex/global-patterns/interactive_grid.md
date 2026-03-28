# Interactive Grid (`NATIVE_IG`)

IG regions use `create_page_plug` with `p_plug_source_type=>'NATIVE_IG'`.

## IG Region

### Read-only IG

```sql
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1363185235505649269)
,p_plug_name=>'Basic Reporting'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>30
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select EMPNO,',
'       ENAME,',
'       JOB,',
'       MGR,',
'       HIREDATE,',
'       SAL,',
'       COMM,',
'       DEPTNO',
'  from EBA_DEMO_IG_EMP'))
,p_plug_source_type=>'NATIVE_IG'
);
```

Editable IG uses the same `create_page_plug`; the editable flag is set in `create_interactive_grid`.

Variant -- sub-region: add `p_parent_plug_id`, `p_plug_display_point=>'SUB_REGIONS'`, `p_plug_new_grid_row=>false`.

**TABLE query type** (alternative to SQL):
```sql
,p_query_type=>'TABLE'
,p_query_table=>'EBA_DEMO_IG_EMP'
,p_query_order_by_type=>'STATIC'
,p_query_order_by=>'ENAME ASC'
```

## Interactive Grid Settings (`create_interactive_grid`)

### Read-only IG

```sql
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(1363189780377649278)
,p_internal_uid=>645872463517057873
,p_is_editable=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_max_row_count=>100000
,p_show_nulls_as=>'-'
,p_select_first_row=>true
,p_fixed_row_height=>true
,p_pagination_type=>'SCROLL'
,p_show_total_row_count=>false
,p_show_toolbar=>true
,p_enable_save_public_report=>false
,p_enable_subscriptions=>true
,p_enable_flashback=>true
,p_define_chart_view=>true
,p_enable_download=>true
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>true
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
);
```

### Editable IG

Adds these parameters to the read-only pattern:

```sql
,p_is_editable=>true
,p_edit_operations=>'i:u:d'           -- insert, update, delete (can omit any)
,p_lost_update_check_type=>'VALUES'   -- optimistic locking
,p_add_row_if_empty=>true
,p_submit_checked_rows=>false         -- only submit changed rows
```

**Operation variants**:
- Full CRUD: `p_edit_operations=>'i:u:d'` (78%)
- Update + delete: `p_edit_operations=>'u:d'` (7%)
- Update only: `p_edit_operations=>'u'` (7%)
- Delete only: `p_edit_operations=>'d'` (5%)

**Row-level operation control**: `p_edit_row_operations_column=>'ALLOWED_OPERATIONS'` (column returns `'i:u:d'` per row)

**Authorization on operations**:
```sql
,p_add_authorization_scheme=>wwv_flow_imp.id(NNN)
,p_update_authorization_scheme=>wwv_flow_imp.id(NNN)
,p_delete_authorization_scheme=>wwv_flow_imp.id(NNN)
```

### IG with Icon View, Detail View, and JavaScript

```sql
,p_fixed_header=>'REGION'
,p_fixed_header_max_height=>518
,p_show_icon_view=>true
,p_icon_view_use_custom=>true
,p_icon_view_custom=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<li class="t-Cards-item" data-id=''&APEX$ROW_ID.''>',
'    <div class="t-Card">',
'        <div class="t-Card-wrap">',
'            <div class="t-Card-icon u-color"><span class="t-Icon &ICON."></span></div>',
'            <div class="t-Card-titleWrap"><h3 class="t-Card-title">&NAME.</h3></div>',
'            <div class="t-Card-body">',
'                <div class="t-Card-desc">Country: &COUNTRY.<br>Age: &AGE.</div>',
'                <div class="t-Card-info">&DISPLAY_CATEGORY.</div>',
'            </div>',
'        </div>',
'    </div>',
'</li>'))
,p_show_detail_view=>true
,p_detail_view_before_rows=>'<ul class="t-MediaList ...">'
,p_detail_view_for_each_row=>'<li class="t-MediaList-item">...row template...</li>'
,p_detail_view_after_rows=>'</ul>'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function(config) {',
'    config.defaultGridViewOptions = { rowHeader: "sequence" };',
'    config.defaultIconViewOptions = { collectionClasses: "t-Cards t-Cards--5cols ..." };',
'    return config;',
'}'))
```

**Icon view (non-custom)** -- uses CSS icon class column:
```sql
,p_show_icon_view=>true
,p_icon_view_use_custom=>false
,p_icon_view_icon_type=>'CSS_CLASSES'
,p_icon_view_icon_column=>'ICON'
,p_icon_view_label_column=>'NAME'
,p_icon_view_link_target=>'f?p=&APP_ID.:50:&SESSION.::&DEBUG.::P50_ID:&ID.'
```

### Other settings

- Custom toolbar: `p_toolbar_buttons=>'SEARCH_COLUMN:SEARCH_FIELD:ACTIONS_MENU:RESET'` (77%), or `'SEARCH_COLUMN:SEARCH_FIELD:ACTIONS_MENU'` (14%), or `'SEARCH_COLUMN:SEARCH_FIELD:ACTIONS_MENU:SAVE'` (5%)
- Custom add-row label: `p_add_button_label=>'Add Employee'`
- Region fixed header: `p_fixed_header=>'REGION'`, `p_fixed_header_max_height=>280` (vs `'PAGE'` for sticky to page, vs `'NONE'`)
- No data message: `p_no_data_found_message=>'No Departments found.'`
- Pagination: `'SCROLL'` (71%) or `'SET'` (29%) (with `p_rows_per_page`)
- Oracle Text search: `p_oracle_text_index_column=>'NAME'`

### Full create_interactive_grid parameters

| Parameter | Purpose | Values |
|---|---|---|
| `p_internal_uid` | Internal unique ID | Large integer |
| `p_is_editable` | Editable mode | `true` (59%), `false` (41%) |
| `p_edit_operations` | Allowed operations | `'i:u:d'`, `'u:d'`, `'u'`, `'d'` |
| `p_edit_row_operations_column` | Per-row operation control | Column name |
| `p_lost_update_check_type` | Optimistic locking | `'VALUES'` (always when editable) |
| `p_add_row_if_empty` | Auto add empty row | `true` |
| `p_submit_checked_rows` | Submit only changed | `false` |
| `p_lazy_loading` | Lazy load | `false` |
| `p_requires_filter` | Require filter before load | `false` |
| `p_max_row_count` | Max rows | `100000` |
| `p_show_nulls_as` | NULL display | `'-'` |
| `p_select_first_row` | Auto-select first row | `true` |
| `p_fixed_row_height` | Fixed row height | `true` |
| `p_pagination_type` | Pagination | `'SCROLL'` (71%), `'SET'` (29%) |
| `p_show_total_row_count` | Show total count | `true`, `false` |
| `p_show_toolbar` | Show toolbar | `true` |
| `p_toolbar_buttons` | Toolbar items | Colon-separated list |
| `p_enable_save_public_report` | Public reports | `true`, `false` |
| `p_enable_subscriptions` | Subscriptions | `true` |
| `p_enable_flashback` | Flashback | `true` |
| `p_define_chart_view` | Chart view | `true` |
| `p_enable_download` | Download | `true` |
| `p_download_formats` | Download formats | `'CSV:HTML:XLSX:PDF'` (77%), `'CSV:HTML'` (14%) |
| `p_enable_mail_download` | Email download | `true` |
| `p_fixed_header` | Fixed header mode | `'PAGE'` (84%), `'REGION'` (14%), `'NONE'` (1%) |
| `p_fixed_header_max_height` | Max region height | `280`, `518` |
| `p_show_icon_view` | Icon view | `true`, `false` |
| `p_icon_view_use_custom` | Custom icon template | `true`, `false` |
| `p_icon_view_custom` | Custom HTML template | `wwv_flow_string.join(...)` |
| `p_icon_view_icon_type` | Icon type | `'CSS_CLASSES'` |
| `p_icon_view_icon_column` | Icon column | Column name |
| `p_icon_view_label_column` | Label column | Column name |
| `p_icon_view_link_target` | Icon click URL | `'f?p=...'` |
| `p_show_detail_view` | Detail view | `true`, `false` |
| `p_detail_view_before_rows` | Detail header HTML | HTML string |
| `p_detail_view_for_each_row` | Detail row template | HTML string |
| `p_detail_view_after_rows` | Detail footer HTML | HTML string |
| `p_no_data_found_message` | No data message | Display text |
| `p_add_button_label` | Custom add row label | Display text |
| `p_javascript_code` | JS config function | `function(config) {...}` |
| `p_oracle_text_index_column` | Oracle Text column | Column name |
| `p_add_authorization_scheme` | Add row auth | auth scheme ID |
| `p_update_authorization_scheme` | Update auth | auth scheme ID |
| `p_delete_authorization_scheme` | Delete auth | auth scheme ID |
| `p_rows_per_page` | Rows per page (SET) | `5`, `10`, `15` |

## Region Columns (`create_region_column`)

### Hidden column (PK)

```sql
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(729545506765413699)
,p_name=>'EMPNO'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'EMPNO'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>30
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>true
,p_duplicate_value=>true
,p_include_in_export=>true
);
```

### Text Field column

```sql
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(729546016109413699)
,p_name=>'ENAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ENAME'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>40
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'text_case', 'UPPER',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>60
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
```

Text field with link: add `p_link_target=>'f?p=&APP_ID.:400:&SESSION.::&DEBUG.:RP:P400_EMPNO:&EMPNO.'`

With link text: `p_link_text=>'#ENAME#'`

With placeholder: `p_placeholder=>'Enter name...'`

### Number Field column

Same structure as text field but: `p_item_type=>'NATIVE_NUMBER_FIELD'`, `p_heading_alignment=>'RIGHT'`, `p_value_alignment=>'RIGHT'`, attributes: `'number_alignment','right'`, `'virtual_keyboard','text'`.

### Date Picker column

`p_item_type=>'NATIVE_DATE_PICKER'`, attributes: `'show'` (`'button'`/`'focus'`), `'navigation_list_for'` (`'NONE'`/`'MONTH'`/`'YEAR'`), `'show_other_months','N'`. Add `p_filter_date_ranges=>'ALL'`.

**APEX Date Picker** (newer): `p_item_type=>'NATIVE_DATE_PICKER_APEX'`

### Select List column

**SQL LOV:**
```sql
,p_item_type=>'NATIVE_SELECT_LIST'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
,p_lov_type=>'SQL_QUERY'
,p_lov_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ename, empno ',
'from eba_demo_ig_emp'))
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_filter_lov_type=>'LOV'
```

**Shared LOV:** `p_lov_type=>'SHARED'`, `p_lov_id=>wwv_flow_imp.id(NNN)`
**Static LOV:** `p_lov_type=>'STATIC'`, `p_lov_source=>'STATIC:Display1;Value1,...'`

**With null text**: `p_lov_null_text=>'- Select -'`

### Popup LOV column

```sql
,p_item_type=>'NATIVE_POPUP_LOV'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'case_sensitive', 'N',
  'display_as', 'DIALOG',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'match_type', 'CONTAINS',
  'min_chars', '0')).to_clob
,p_lov_type=>'SQL_QUERY'
,p_lov_source=>'select ENAME as d, EMPNO as r from EBA_DEMO_IG_EMP where JOB = ''MANAGER'' order by 1'
```

### Display Only column

`p_item_type=>'NATIVE_DISPLAY_ONLY'`, attributes: `'based_on'` (`'LOV'`/`'VALUE'`), `'format'` (`'PLAIN'`/`'HTML'`), `'send_on_page_submit'`, `'show_line_breaks'`. With format mask: add `p_format_mask=>'DD-MON-YYYY'`.

### Other column types

- **Radiogroup**: `NATIVE_RADIOGROUP`, attrs: `'number_of_columns','1'`, `'page_action_on_selection','NONE'`
- **Yes/No**: `NATIVE_YES_NO`, attrs: `'use_defaults','Y'`
- **Single Checkbox**: `NATIVE_SINGLE_CHECKBOX`, attrs: `'use_defaults','Y'`, optional `p_default_type=>'STATIC'`, `p_default_expression=>'N'`
- **Textarea**: `NATIVE_TEXTAREA`, attrs: `'auto_height','N'`, `'character_counter','N'`, `'resizable','Y'`, `'trim_spaces','BOTH'`, `p_item_width=>60`, `p_item_height=>4`
- **Password**: `NATIVE_PASSWORD`, attrs: `'submit_when_enter_pressed','Y'`
- **Color Picker**: `NATIVE_COLOR_PICKER`, optional default
- **Shuttle**: `NATIVE_SHUTTLE`, attrs: `'show_controls','ALL'`, uses static LOV
- **HTML Expression**: `NATIVE_HTML_EXPRESSION`, `p_is_query_only=>true`, uses `p_label` instead of `p_heading`, attrs: `'html_expression','<span ...>'`
- **Link**: `NATIVE_LINK`, `p_link_target=>'f?p=...'`, `p_link_target_type=>'REDIRECT_PAGE'`
- **Checkbox (multi-value)**: `NATIVE_CHECKBOX`, static LOV

### Pseudo-columns (editable IGs only)

```sql
-- Row Selector (display_sequence 10)
,p_name=>'APEX$ROW_SELECTOR'
,p_item_type=>'NATIVE_ROW_SELECTOR'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'enable_multi_select', 'Y',
  'hide_control', 'N',
  'show_select_all', 'Y')).to_clob

-- Row Action (display_sequence 20)
,p_name=>'APEX$ROW_ACTION'
,p_item_type=>'NATIVE_ROW_ACTION'
,p_label=>'Actions'
```

### Conditional display

```sql
,p_display_when_type=>'EXISTS'
,p_display_when_cond=>'select 1 from ...'
```

### Column with default value

```sql
,p_default_type=>'STATIC'
,p_default_expression=>'N'
```

### Full region column parameters

| Parameter | Purpose | Values |
|---|---|---|
| `p_name` | Column name (UPPER) | `'EMPNO'`, `'ENAME'` |
| `p_source_type` | Source | `'DB_COLUMN'` (99%), `'NONE'` (<1%) |
| `p_source_expression` | DB column name | Same as `p_name` |
| `p_data_type` | DB data type | `'VARCHAR2'` (55%), `'NUMBER'` (32%), `'DATE'` (9%), `'TIMESTAMP_TZ'`, `'TIMESTAMP_LTZ'`, `'ROWID'`, `'BLOB'`, `'TIMESTAMP'` |
| `p_session_state_data_type` | Session type | `'VARCHAR2'` |
| `p_is_query_only` | Read-only column | `true`, `false` |
| `p_item_type` | Column item type | See Item Type Catalog below |
| `p_heading` | Column heading | Display text |
| `p_heading_alignment` | Header align | `'LEFT'`, `'RIGHT'`, `'CENTER'` |
| `p_display_sequence` | Column order | `10`, `20`, `30` ... |
| `p_value_alignment` | Data align | `'LEFT'`, `'RIGHT'`, `'CENTER'` |
| `p_attributes` | Plugin attributes | `wwv_flow_t_plugin_attributes(...)` |
| `p_is_required` | Required field | `true`, `false` |
| `p_max_length` | Max input length | `60`, `255`, `4000` |
| `p_format_mask` | Display format | `'DD-MON-YYYY'`, `'999G990'` |
| `p_placeholder` | Input placeholder | Display text |
| `p_link_target` | Column link URL | `'f?p=...'` |
| `p_link_target_type` | Link type | `'REDIRECT_PAGE'` |
| `p_link_text` | Link text | `'#COL#'` |
| `p_label` | Label (HTML Expression) | Display text |
| `p_enable_filter` | Filterable | `true`, `false` |
| `p_filter_operators` | Filter operators | `'C:S:CASE_INSENSITIVE:REGEXP'` (always for text) |
| `p_filter_is_required` | Filter required | `true`, `false` |
| `p_filter_text_case` | Filter case | `'MIXED'` |
| `p_filter_exact_match` | Exact match | `true`, `false` |
| `p_filter_lov_type` | Filter LOV | `'DISTINCT'` (65%), `'LOV'` (20%), `'NONE'` (12%) |
| `p_filter_date_ranges` | Date range filter | `'ALL'` |
| `p_use_as_row_header` | Row header | `true`, `false` |
| `p_enable_sort_group` | Sortable/groupable | `true`, `false` |
| `p_enable_control_break` | Control break | `true`, `false` |
| `p_enable_hide` | Hideable | `true`, `false` |
| `p_enable_pivot` | Pivotable | `true`, `false` |
| `p_is_primary_key` | Primary key | `true`, `false` |
| `p_is_visible` | Visible (hidden vs display) | `true`, `false` |
| `p_duplicate_value` | Copy on duplicate | `true`, `false` |
| `p_include_in_export` | Include in downloads | `true`, `false` |
| `p_default_type` | Default type | `'STATIC'` |
| `p_default_expression` | Default value | `'N'`, `'SYSDATE'` |
| `p_lov_type` | LOV type | `'SHARED'` (48%), `'SQL_QUERY'` (44%), `'STATIC'` (8%) |
| `p_lov_id` | Shared LOV ID | LOV ID |
| `p_lov_source` | LOV query/static | SQL or `'STATIC:...'` |
| `p_lov_display_extra` | Show extra value | `true`, `false` |
| `p_lov_display_null` | Show null option | `true`, `false` |
| `p_lov_null_text` | Null display text | `'- Select -'` |
| `p_group_id` | Column group ref | column_group ID |
| `p_use_group_for` | Group usage | `'BOTH'` (85%), `'HEADING'` (15%) |
| `p_parent_column_id` | Master-detail FK | parent column ID |
| `p_item_width` | Input width | `60` |
| `p_item_height` | Textarea height | `4` |
| `p_restricted_characters` | Input restriction | Character class |
| `p_encrypt_session_state_yn` | Encrypt state | `'N'` |
| `p_display_when_type` | Conditional | Condition type |
| `p_display_when_cond` | Condition expr | SQL / expression |
| `p_required_patch` | Build option | build option ID |
| `p_security_scheme` | Column auth | auth scheme ID (via `p_protection_level`) |

### Default alignment conventions

- VARCHAR2: LEFT/LEFT
- NUMBER: RIGHT/RIGHT
- DATE: LEFT/LEFT
- Checkbox/boolean: CENTER/CENTER

## Column Groups (`create_region_column_group`)

```sql
wwv_flow_imp_page.create_region_column_group(
 p_id=>wwv_flow_imp.id(1367137129177438834)
,p_heading=>'<span class="key">Identity</span>'
,p_label=>'Identity'    -- plain-text alt when heading has HTML
);
```

Columns reference via `p_group_id` and `p_use_group_for=>'BOTH'` (`'HEADING'`, `'SINGLE_ROW_VIEW'`).

| Parameter | Purpose | Values |
|---|---|---|
| `p_heading` | Group heading (can be HTML) | Display text or HTML |
| `p_label` | Plain-text label | Display text |
| `p_display_sequence` | Group order | `10`, `20` |

## Master-Detail Configuration

Detail region references master via `p_master_region_id`. Detail FK column uses `p_parent_column_id`. Both need separate NATIVE_IG_DML processes.

## IG Reports (`create_ig_report`)

```sql
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(1363190214230649279)
,p_interactive_grid_id=>wwv_flow_imp.id(1363189780377649278)
,p_static_id=>'14437'
,p_type=>'PRIMARY'          -- or 'ALTERNATIVE' (with p_name)
,p_default_view=>'GRID'     -- 'GRID' | 'ICON' | 'DETAIL' | 'CHART'
,p_rows_per_page=>5          -- only for SET pagination
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
```

**Alternative report**:
```sql
,p_type=>'ALTERNATIVE'
,p_name=>'Summary View'
```

**With authorization**: `p_authorization_scheme=>wwv_flow_imp.id(NNN)`

| Parameter | Purpose | Values |
|---|---|---|
| `p_interactive_grid_id` | Parent IG | IG settings ID |
| `p_static_id` | Static ID for URL | Numeric string |
| `p_type` | Report type | `'PRIMARY'` (91%), `'ALTERNATIVE'` (9%) |
| `p_name` | Display name (ALTERNATIVE) | Display text |
| `p_default_view` | Default view | `'GRID'` (91%), `'ICON'` (4%), `'DETAIL'` (4%), `'CHART'` (1%) |
| `p_rows_per_page` | Rows (SET pagination) | `5`, `10`, `15` |
| `p_show_row_number` | Row numbers | `true`, `false` |
| `p_settings_area_expanded` | Settings panel | `true`, `false` |
| `p_authorization_scheme` | Report auth | auth scheme ID |

## IG Report Views (`create_ig_report_view`)

```sql
-- GRID view
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false

-- CHART view
,p_view_type=>'CHART'
,p_chart_type=>'bar'
,p_chart_orientation=>'vertical'
,p_chart_stack=>'off'
```

**Chart with axis labels**:
```sql
,p_axis_label=>'Category'
,p_axis_value=>'Amount'
```

**ICON view**: `p_view_type=>'ICON'`
**DETAIL view**: `p_view_type=>'DETAIL'`

| Parameter | Purpose | Values |
|---|---|---|
| `p_report_id` | Parent report | report ID |
| `p_view_type` | View type | `'GRID'` (89%), `'CHART'` (8%), `'ICON'` (2%), `'DETAIL'` (1%) |
| `p_stretch_columns` | Stretch columns | `true` (97%), `false` (3%) |
| `p_srv_exclude_null_values` | Exclude nulls | `true`, `false` |
| `p_srv_only_display_columns` | Only visible cols | `true`, `false` |
| `p_edit_mode` | Start in edit mode | `true`, `false` |
| `p_chart_type` | Chart type | `'bar'` (always) |
| `p_chart_orientation` | Chart direction | `'vertical'` (always) |
| `p_chart_stack` | Chart stacking | `'off'` (always) |
| `p_axis_label` | X-axis label | Display text |
| `p_axis_value` | Y-axis label | Display text |

## IG Report Columns (`create_ig_report_column`)

```sql
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(717317385844591405)
,p_view_id=>wwv_flow_imp.id(1363190260979649279)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(1363185757720649273)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>90
);
```

With sort: add `p_sort_order=>1`, `p_sort_direction=>'ASC'` (`'DESC'`), `p_sort_nulls=>'LAST'` (`'FIRST'`).
With control break: add `p_break_order=>1`, `p_break_is_enabled=>true`, `p_break_sort_direction=>'ASC'`, `p_break_sort_nulls=>'LAST'`.
Hidden: `p_is_visible=>false`.

**With aggregate function**: `p_function=>'SUM'` (inline aggregate)

| Parameter | Purpose | Values |
|---|---|---|
| `p_view_id` | Parent view | view ID |
| `p_display_seq` | Column order | Sequential integers |
| `p_column_id` | Source region column | region column ID |
| `p_is_visible` | Visible | `true`, `false` |
| `p_is_frozen` | Frozen column | `true`, `false` |
| `p_width` | Column width (px) | `90`, `120`, `200` |
| `p_sort_order` | Sort priority | `1`, `2`, `3` |
| `p_sort_direction` | Sort direction | `'ASC'`, `'DESC'` |
| `p_sort_nulls` | Null sort | `'LAST'` (84%), `'FIRST'` (16%) |
| `p_break_order` | Break priority | `1`, `2` |
| `p_break_is_enabled` | Break active | `true` |
| `p_break_sort_direction` | Break sort | `'ASC'`, `'DESC'` |
| `p_break_sort_nulls` | Break null sort | `'LAST'`, `'FIRST'` |
| `p_function` | Inline aggregate | `'SUM'`, `'AVG'`, `'COUNT'`, `'MIN'`, `'MAX'` |
| `p_include_rowid_column` | Include ROWID | `true`, `false` |
| `p_authorization_scheme` | Column auth | auth scheme ID |

## IG Report Aggregates (`create_ig_report_aggregate`)

```sql
wwv_flow_imp_page.create_ig_report_aggregate(
 p_id=>wwv_flow_imp.id(1373990063572102727)
,p_view_id=>wwv_flow_imp.id(3978988269881465258)
,p_tooltip=>'Average'
,p_function=>'AVG'          -- AVG | SUM | COUNT | MIN | MAX
,p_column_id=>wwv_flow_imp.id(3322313630523957063)
,p_show_grand_total=>true
,p_is_enabled=>true
);
```

| Parameter | Purpose | Values |
|---|---|---|
| `p_view_id` | Parent view | view ID |
| `p_tooltip` | Aggregate tooltip | `'Average'`, `'Total'` |
| `p_function` | Aggregate function | `'AVG'`, `'SUM'`, `'COUNT'`, `'MIN'`, `'MAX'` |
| `p_column_id` | Target column | region column ID |
| `p_show_grand_total` | Grand total row | `true`, `false` |
| `p_is_enabled` | Active | `true` |

## IG Report Chart Columns (`create_ig_report_chart_col`)

```sql
-- Label (x-axis)
,p_column_type=>'LABEL'
,p_column_id=>wwv_flow_imp.id(729546016109413699)

-- Value (y-axis with aggregation)
,p_column_type=>'VALUE'
,p_column_id=>wwv_flow_imp.id(729547991180413701)
,p_function=>'SUM'

-- Series name (multi-series)
,p_column_type=>'SERIES_NAME'
,p_column_id=>wwv_flow_imp.id(NNN)
```

| Parameter | Purpose | Values |
|---|---|---|
| `p_view_id` | Parent chart view | view ID |
| `p_column_type` | Chart role | `'LABEL'` (46%), `'VALUE'` (46%), `'SERIES_NAME'` (8%) |
| `p_column_id` | Source column | region column ID |
| `p_function` | Aggregate (VALUE only) | `'SUM'` (83%), `'AVG'` (17%) |

## IG Save Process (`NATIVE_IG_DML`)

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(729551207605413707)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(729544022795413693)
,p_process_type=>'NATIVE_IG_DML'
,p_process_name=>' - Save Interactive Grid Data'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'       -- return PK after insert
,p_attribute_06=>'Y'       -- lock row before update
,p_attribute_08=>'Y'       -- return DML count
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>701151416339605522
);
```

For master-detail: two separate DML processes with distinct sequences.

## Parameter Value Catalog

### Item types (`p_item_type`) by frequency
`NATIVE_TEXT_FIELD` (20%) · `NATIVE_HIDDEN` (17%) · `NATIVE_NUMBER_FIELD` (12%) · `NATIVE_SELECT_LIST` (10%) · `NATIVE_DISPLAY_ONLY` (8%) · `NATIVE_DATE_PICKER` (7%) · `NATIVE_ROW_SELECTOR` (6%) · `NATIVE_ROW_ACTION` (5%) · `NATIVE_TEXTAREA` (5%) · `NATIVE_YES_NO` (3%) · `NATIVE_LINK` (2%) · `NATIVE_SINGLE_CHECKBOX` (1%) · `NATIVE_RADIOGROUP` (1%) · `NATIVE_HTML_EXPRESSION` (1%) · `NATIVE_DATE_PICKER_APEX` (<1%) · `NATIVE_PASSWORD` (<1%) · `NATIVE_COLOR_PICKER` (<1%) · `NATIVE_POPUP_LOV` (<1%) · `NATIVE_CHECKBOX` (<1%) · `NATIVE_SHUTTLE` (<1%)

### Data types (`p_data_type`) by frequency
`VARCHAR2` (55%) · `NUMBER` (32%) · `DATE` (9%) · `TIMESTAMP_TZ` (2%) · `TIMESTAMP_LTZ` (2%) · `ROWID` (<1%) · `BLOB` (<1%) · `TIMESTAMP` (<1%)

### LOV types (`p_lov_type`)
`SHARED` (48%) · `SQL_QUERY` (44%) · `STATIC` (8%)

### Filter LOV types (`p_filter_lov_type`)
`DISTINCT` (65%) · `LOV` (20%) · `NONE` (12%)

### Pagination types (`p_pagination_type`)
`SCROLL` (71%) · `SET` (29%)

### Fixed header (`p_fixed_header`)
`PAGE` (84%) · `REGION` (14%) · `NONE` (1%)

### Download formats (`p_download_formats`)
`CSV:HTML:XLSX:PDF` (77%) · `CSV:HTML` (14%) · `CSV:HTML:PDF` (5%)

### Edit operations (`p_edit_operations`)
`i:u:d` (78%) · `u:d` (7%) · `u` (7%) · `d` (5%)

### IG report default views (`p_default_view`)
`GRID` (91%) · `ICON` (4%) · `DETAIL` (4%) · `CHART` (1%)

### Chart aggregate functions
`SUM` (83%) · `AVG` (17%)

## Call Order in Export Files

1. `create_page(...)` -- page
2. `create_page_plug(...)` -- IG region
3. `create_region_column_group(...)` -- column groups
4. `create_region_column(...)` -- all columns
5. `create_interactive_grid(...)` -- IG settings
6. `create_ig_report(...)` -- reports
7. `create_ig_report_view(...)` -- views
8. `create_ig_report_column(...)` -- report columns
9. `create_ig_report_aggregate(...)` -- aggregates
10. `create_ig_report_chart_col(...)` -- chart columns
11. Other regions, buttons, items, DAs, validations, processes
