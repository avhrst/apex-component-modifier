# Interactive Grid (`NATIVE_IG`)

IG regions use `create_page_plug` with `p_plug_source_type=>'NATIVE_IG'`.

Source: Oracle APEX App 102 (Sample Interactive Grids), 38 pages analyzed.

---

## Table of Contents

- [IG Region](#ig-region)
- [Interactive Grid Settings (`create_interactive_grid`)](#interactive-grid-settings-create_interactive_grid)
- [Region Columns (`create_region_column`)](#region-columns-create_region_column)
- [Column Groups (`create_region_column_group`)](#column-groups-create_region_column_group)
- [Master-Detail Configuration](#master-detail-configuration)
- [IG Reports (`create_ig_report`)](#ig-reports-create_ig_report)
- [IG Report Views (`create_ig_report_view`)](#ig-report-views-create_ig_report_view)
- [IG Report Columns (`create_ig_report_column`)](#ig-report-columns-create_ig_report_column)
- [IG Report Aggregates (`create_ig_report_aggregate`)](#ig-report-aggregates-create_ig_report_aggregate)
- [IG Report Chart Columns (`create_ig_report_chart_col`)](#ig-report-chart-columns-create_ig_report_chart_col)
- [IG Save Process (`NATIVE_IG_DML`)](#ig-save-process-native_ig_dml)
- [Common Patterns](#common-patterns)

---

## IG Region

### Read-only IG (SQL query source)

From page 3 ("Basic Reporting"):

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

### Editable IG (SQL query source)

From page 30 ("Basic Editing") -- editable IGs use the same `create_page_plug` pattern; the editable flag is set in `create_interactive_grid`:

```sql
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(729544022795413693)
,p_plug_name=>'Basic Editing'
,p_region_name=>'emp'
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
'       ONLEAVE,',
'       NOTES,',
'       DEPTNO',
'  from EBA_DEMO_IG_EMP'))
,p_plug_source_type=>'NATIVE_IG'
);
```

### IG with complex SQL query source (computed columns)

From page 2 ("Progressive Scroll"):

```sql
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(6926981750055065840)
,p_plug_name=>'Progressive Scroll'
,p_region_name=>'people'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>30
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID, RATING, NAME, COUNTRY, FROM_YR,',
'        TO_YR,',
'        LINK, CATEGORY,',
'        coalesce( to_yr, extract(year from sysdate) ) - FROM_YR as AGE,',
'        case CATEGORY',
'            when ''S_T'' then ''fa fa-rocket''',
'            when ''P'' then ''fa fa-university''',
'            when ''A'' then ''fa fa-paint-brush''',
'            when ''S'' then ''fa fa-bicycle''',
'            when ''B_L'' then ''fa fa-money''',
'            else ''fa fa-question''',
'        end as ICON,',
'        case CATEGORY',
'            when ''S_T'' then ''Science & Technology''',
'            when ''P'' then ''Politics''',
'            when ''A'' then ''Art''',
'            when ''S'' then ''Sports''',
'            when ''B_L'' then ''Business & Law''',
'            else ''Undefined''',
'        end as DISPLAY_CATEGORY,',
'        GENDER',
'    from EBA_DEMO_IG_PEOPLE',
''))
,p_plug_source_type=>'NATIVE_IG'
);
```

### IG as sub-region (nested inside parent)

From page 15 ("Linking to Interactive Grids") -- IG embedded as child of a container region:

```sql
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(3391145037274480892)
,p_plug_name=>'Interactive Grid'
,p_parent_plug_id=>wwv_flow_imp.id(4267604488326566957)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>40
,p_plug_new_grid_row=>false
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select EMPNO,',
'       ENAME,',
'       JOB,',
'       ...'))
,p_plug_source_type=>'NATIVE_IG'
);
```

Key parameters: `p_parent_plug_id`, `p_plug_display_point=>'SUB_REGIONS'`, `p_plug_new_grid_row=>false`.

---

## Interactive Grid Settings (`create_interactive_grid`)

### Read-only IG

From page 3:

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

From page 30:

```sql
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(729550489337413705)
,p_internal_uid=>698639828695926179
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_add_row_if_empty=>true
,p_submit_checked_rows=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_max_row_count=>100000
,p_show_nulls_as=>'-'
,p_select_first_row=>true
,p_fixed_row_height=>true
,p_pagination_type=>'SET'
,p_show_total_row_count=>true
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

Key edit-mode parameters:
- `p_is_editable=>true` -- enables editing
- `p_edit_operations=>'i:u:d'` -- insert, update, delete (can omit any)
- `p_lost_update_check_type=>'VALUES'` -- optimistic locking by column values
- `p_add_row_if_empty=>true` -- show empty row if no data
- `p_submit_checked_rows=>false` -- only submit changed rows

### IG with Icon View, Detail View, and JavaScript

From page 2 ("Progressive Scroll"):

```sql
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(6926986294927065849)
,p_internal_uid=>6896075634285578323
,p_is_editable=>false
,p_lazy_loading=>false
,p_requires_filter=>false
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
,p_detail_view_before_rows=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<ul class="t-MediaList t-MediaList--showDesc t-MediaList--showIcons t-MediaList--showBadges">',
''))
,p_detail_view_for_each_row=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<li class="t-MediaList-item  ">',
'    <div class="t-MediaList-itemWrap">',
'        ...row template...',
'    </div>',
'</li>'))
,p_detail_view_after_rows=>'</ul>'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function(config) {',
'    config.defaultGridViewOptions = {',
'        rowHeader: "sequence"',
'    };',
'    config.defaultIconViewOptions = {',
'        collectionClasses: "t-Cards t-Cards--5cols ..."',
'    };',
'    return config;',
'}'))
);
```

### IG with Custom Toolbar Buttons

From page 35 (Master Detail):

```sql
,p_toolbar_buttons=>'SEARCH_COLUMN:SEARCH_FIELD:ACTIONS_MENU:RESET'
```

Default toolbar (when omitted) includes all standard buttons. Custom toolbar reduces to only listed items.

### IG with Region Fixed Header

From page 35:

```sql
,p_fixed_header=>'REGION'
,p_fixed_header_max_height=>280
```

Options: `'PAGE'` (sticky to page), `'REGION'` (sticky within region, requires `p_fixed_header_max_height`).

### IG with No Data Found Message

From page 35:

```sql
,p_no_data_found_message=>'No Departments found.'
```

### Pagination types observed

- `p_pagination_type=>'SCROLL'` -- progressive/virtual scroll (most common, 35+ pages)
- `p_pagination_type=>'SET'` -- page-set pagination with `p_rows_per_page`

---

## Region Columns (`create_region_column`)

### Hidden column (PK)

From page 30:

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

Key: `p_is_primary_key=>true`, `p_include_in_export=>false` (or `true`), `p_attributes` with `'value_protected', 'Y'`.

### Text Field column

From page 30:

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

Text field attributes: `'subtype', 'TEXT'`, `'trim_spaces', 'BOTH'`, optional `'text_case', 'UPPER'`, `'disabled', 'N'`.

### Text Field with link

From page 5 -- a text field column can have a link target:

```sql
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Name'
...
,p_link_target=>'f?p=&APP_ID.:400:&SESSION.::&DEBUG.:RP:P400_EMPNO:&EMPNO.'
```

### Number Field column

From page 3:

```sql
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(1363185757720649273)
,p_name=>'EMPNO'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'EMPNO'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Empno'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>10
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'right',
  'virtual_keyboard', 'text')).to_clob
,p_is_required=>true
,p_enable_filter=>true
,p_filter_is_required=>false
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

Number columns typically use `p_heading_alignment=>'RIGHT'` and `p_value_alignment=>'RIGHT'`.

### Date Picker column

From page 3:

```sql
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(1363187754968649275)
,p_name=>'HIREDATE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'HIREDATE'
,p_data_type=>'DATE'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER'
,p_heading=>'Hiredate'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>50
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'navigation_list_for', 'NONE',
  'show', 'button',
  'show_other_months', 'N')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
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

Date picker attributes: `'show'` can be `'button'` or `'focus'`; `'navigation_list_for'` can be `'NONE'`, `'MONTH'`, `'YEAR'`.

### Select List column (SQL LOV)

From page 5:

```sql
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(2665328672150787487)
,p_name=>'MGR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MGR'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Manager'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>40
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
,p_is_required=>false
,p_lov_type=>'SQL_QUERY'
,p_lov_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ename, empno ',
'from eba_demo_ig_emp'))
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
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

### Select List column (Shared LOV)

From page 36:

```sql
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Job'
...
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_imp.id(729561381234572547)
,p_lov_display_extra=>true
,p_lov_display_null=>false
```

### Select List column (Static LOV)

From page 36:

```sql
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Avatar'
...
,p_lov_type=>'STATIC'
,p_lov_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'STATIC:Ambulance;fa-ambulance,Bicycle;fa-bicycle,...'))
,p_lov_display_extra=>true
,p_lov_display_null=>true
```

### Popup LOV column

From page 36:

```sql
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(2147450658464438851)
,p_name=>'MGR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MGR'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_POPUP_LOV'
,p_heading=>'Manager'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>70
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'case_sensitive', 'N',
  'display_as', 'DIALOG',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'match_type', 'CONTAINS',
  'min_chars', '0')).to_clob
,p_is_required=>false
,p_lov_type=>'SQL_QUERY'
,p_lov_source=>'select ENAME as d, EMPNO as r from EBA_DEMO_IG_EMP where JOB = ''MANAGER'' or JOB = ''PRESIDENT'' order by 1'
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'LOV'
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

### Display Only column

From page 2:

```sql
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(2263045778982291127)
,p_name=>'GENDER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'GENDER'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Gender'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>120
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'LOV',
  'format', 'PLAIN',
  'send_on_page_submit', 'N',
  'show_line_breaks', 'N')).to_clob
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_imp.id(747815456556467421)
,p_lov_display_extra=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
```

Display only `'based_on'` can be `'LOV'` or `'VALUE'`; `'format'` can be `'PLAIN'` or `'HTML'`.

### Display Only with format mask

From page 35 (master-detail):

```sql
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Hire Date'
...
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
,p_format_mask=>'DD-MON-YYYY'
```

### Radiogroup column

From page 30:

```sql
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(729546551298413700)
,p_name=>'JOB'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'JOB'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_RADIOGROUP'
,p_heading=>'Job'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>50
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1',
  'page_action_on_selection', 'NONE')).to_clob
,p_is_required=>false
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_imp.id(729561381234572547)
,p_lov_display_extra=>true
,p_lov_display_null=>false
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_escape_on_http_output=>true
);
```

### Yes/No column

From page 5:

```sql
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(2018261478467860431)
,p_name=>'ONLEAVE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ONLEAVE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_YES_NO'
,p_heading=>'On Leave'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>90
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
,p_is_required=>true
...
);
```

### Single Checkbox column

From page 30:

```sql
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(729548992657413702)
,p_name=>'ONLEAVE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ONLEAVE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SINGLE_CHECKBOX'
,p_heading=>'On Leave'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>100
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
,p_is_required=>false
...
,p_default_type=>'STATIC'
,p_default_expression=>'N'
);
```

### Textarea column

From page 30:

```sql
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(729549487634413702)
,p_name=>'NOTES'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'NOTES'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Notes'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>110
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_item_width=>60
,p_item_height=>4
,p_is_required=>false
,p_max_length=>1000
...
);
```

### Password column

From page 36:

```sql
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(1442090330897096028)
,p_name=>'PIN'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PIN'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_PASSWORD'
,p_heading=>'PIN'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>140
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'submit_when_enter_pressed', 'Y')).to_clob
,p_is_required=>false
,p_max_length=>1000
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_control_break=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>false
,p_include_in_export=>true
);
```

### Color Picker column

From page 36:

```sql
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(1442090523608096030)
,p_name=>'COLOR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COLOR'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_COLOR_PICKER'
,p_heading=>'Avatar Color'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>160
,p_value_alignment=>'LEFT'
,p_is_required=>false
,p_max_length=>1000
...
,p_default_type=>'STATIC'
,p_default_expression=>'#0000AA'
);
```

### Shuttle column

From page 36:

```sql
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(1442090624162096031)
,p_name=>'TAGS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TAGS'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SHUTTLE'
,p_heading=>'Tags'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>170
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'show_controls', 'ALL')).to_clob
,p_item_height=>5
,p_is_required=>false
,p_lov_type=>'STATIC'
,p_lov_source=>'STATIC:Punctual,Innovative,Motivated,Resourceful,Knowledgeable'
,p_lov_display_extra=>true
...
,p_static_id=>'C_TAGS'
);
```

### HTML Expression column (query-only)

From page 36:

```sql
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(1442091228517096037)
,p_name=>'ICON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ICON'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_HTML_EXPRESSION'
,p_label=>'Avatar'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>40
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'html_expression', '<span class="fa &ICON." style="color: &COLOR.;"></span>')).to_clob
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_control_break=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_include_in_export=>true
);
```

Note: uses `p_label` instead of `p_heading` for HTML expression columns. `p_is_query_only=>true`.

### Link column

From page 54:

```sql
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(1869111986998663868)
,p_name=>'DNAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DNAME'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_LINK'
,p_heading=>'Department Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>30
,p_value_alignment=>'LEFT'
,p_link_target=>'f?p=&APP_ID.:55:&SESSION.::&DEBUG.:RP:P55_DEPTNO:&DEPTNO.'
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_escape_on_http_output=>true
);
```

### Checkbox column (multi-value)

From page 33 (NATIVE_CHECKBOX, not SINGLE_CHECKBOX):

```sql
,p_item_type=>'NATIVE_CHECKBOX'
,p_heading=>'Tags'
...
,p_lov_type=>'STATIC'
,p_lov_source=>'STATIC:Punctual,Innovative,Motivated,Resourceful,Knowledgeable'
```

### Row Selector pseudo-column

From page 30:

```sql
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(729544503921413697)
,p_name=>'APEX$ROW_SELECTOR'
,p_session_state_data_type=>'VARCHAR2'
,p_item_type=>'NATIVE_ROW_SELECTOR'
,p_display_sequence=>10
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'enable_multi_select', 'Y',
  'hide_control', 'N',
  'show_select_all', 'Y')).to_clob
,p_use_as_row_header=>false
,p_enable_hide=>true
,p_is_primary_key=>false
);
```

Row selector attributes: `'enable_multi_select'` (`'Y'`/`'N'`), `'hide_control'` (`'Y'`/`'N'`), `'show_select_all'` (`'Y'`/`'N'`).

### Row Action pseudo-column

From page 30:

```sql
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(729545004779413697)
,p_name=>'APEX$ROW_ACTION'
,p_session_state_data_type=>'VARCHAR2'
,p_item_type=>'NATIVE_ROW_ACTION'
,p_label=>'Actions'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>20
,p_value_alignment=>'CENTER'
,p_use_as_row_header=>false
,p_enable_hide=>true
);
```

Row Selector and Row Action are automatically added for editable IGs. They are positioned first (`p_display_sequence=>10` and `20`).

---

## Column Groups (`create_region_column_group`)

From page 4 ("Column Groups"):

```sql
-- Define column groups
wwv_flow_imp_page.create_region_column_group(
 p_id=>wwv_flow_imp.id(1367137129177438834)
,p_heading=>'<span class="key">Identity</span>'
,p_label=>'Identity'
);
wwv_flow_imp_page.create_region_column_group(
 p_id=>wwv_flow_imp.id(1367137295590438835)
,p_heading=>'Compensation'
);
wwv_flow_imp_page.create_region_column_group(
 p_id=>wwv_flow_imp.id(1367137411827438836)
,p_heading=>'Notes'
);
```

Then columns reference a group via `p_group_id` and `p_use_group_for`:

```sql
wwv_flow_imp_page.create_region_column(
 ...
,p_name=>'ENAME'
...
,p_group_id=>wwv_flow_imp.id(1367137129177438834)
,p_use_group_for=>'BOTH'
...
);
```

`p_use_group_for` values: `'BOTH'` (heading and single row view), can also be `'HEADING'` or `'SINGLE_ROW_VIEW'`.

When `p_heading` contains HTML markup, set `p_label` to the plain-text alternative for dialogs/menus.

---

## Master-Detail Configuration

From page 35 ("Master Detail"):

The master region is a normal IG:
```sql
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(727558198450089851)
,p_plug_name=>'Departments'
,p_region_name=>'dept'
...
,p_plug_source_type=>'NATIVE_IG'
);
```

The detail region references the master via `p_master_region_id`:
```sql
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(727558839439089857)
,p_plug_name=>'Employees'
,p_region_name=>'emp'
...
,p_plug_source_type=>'NATIVE_IG'
,p_master_region_id=>wwv_flow_imp.id(727558198450089851)
);
```

The detail's foreign key column links to the master PK via `p_parent_column_id`:
```sql
wwv_flow_imp_page.create_region_column(
 ...
,p_name=>'DEPTNO'
...
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>130
...
,p_parent_column_id=>wwv_flow_imp.id(727558371533089853)
,p_include_in_export=>false
);
```

For master-detail, both regions need separate `NATIVE_IG_DML` processes, and the detail grid's toolbar save button should be disabled (use a shared Save button on the master).

---

## IG Reports (`create_ig_report`)

### Primary report

From page 3:

```sql
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(1363190214230649279)
,p_interactive_grid_id=>wwv_flow_imp.id(1363189780377649278)
,p_static_id=>'14437'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
```

### Primary report with SET pagination

From page 30:

```sql
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(729550948901413706)
,p_interactive_grid_id=>wwv_flow_imp.id(729550489337413705)
,p_static_id=>'14475'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_rows_per_page=>5
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
```

### Alternative (saved) report

From page 30:

```sql
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(2554718943904490786)
,p_interactive_grid_id=>wwv_flow_imp.id(729550489337413705)
,p_name=>'aaa'
,p_static_id=>'aaa'
,p_type=>'ALTERNATIVE'
,p_default_view=>'GRID'
,p_rows_per_page=>5
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
```

### Report with ICON default view

From page 54:

```sql
wwv_flow_imp_page.create_ig_report(
 ...
,p_type=>'PRIMARY'
,p_default_view=>'ICON'
,p_rows_per_page=>5
...
);
```

### Report with DETAIL default view

From page 2:

```sql
wwv_flow_imp_page.create_ig_report(
 ...
,p_type=>'PRIMARY'
,p_default_view=>'DETAIL'
...
);
```

Observed `p_default_view` values: `'GRID'`, `'ICON'`, `'DETAIL'`, `'CHART'`.

---

## IG Report Views (`create_ig_report_view`)

### GRID view

```sql
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(1363190260979649279)
,p_report_id=>wwv_flow_imp.id(1363190214230649279)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
```

### CHART view

```sql
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(30910857218487527)
,p_report_id=>wwv_flow_imp.id(1363190214230649279)
,p_view_type=>'CHART'
);
```

Chart views with configuration:

```sql
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(30910736635487527)
,p_report_id=>wwv_flow_imp.id(729550948901413706)
,p_view_type=>'CHART'
,p_chart_type=>'bar'
,p_chart_orientation=>'vertical'
,p_chart_stack=>'off'
);
```

---

## IG Report Columns (`create_ig_report_column`)

### Basic visible column

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

### Column with sort

```sql
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(717317624517591406)
,p_view_id=>wwv_flow_imp.id(1363190260979649279)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(1363186808781649274)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>133
,p_sort_order=>1
,p_sort_direction=>'ASC'
,p_sort_nulls=>'LAST'
);
```

Sort direction: `'ASC'` or `'DESC'`. Null handling: `'FIRST'` or `'LAST'`.

### Frozen column

```sql
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(717317385844591405)
,p_view_id=>wwv_flow_imp.id(1363190260979649279)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(1363185757720649273)
,p_is_visible=>true
,p_is_frozen=>true
,p_width=>90
);
```

### Hidden column in report

```sql
,p_is_visible=>false
,p_is_frozen=>false
```

### Column with control break

From page 15 (saved report "Roles"):

```sql
wwv_flow_imp_page.create_ig_report_column(
 ...
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(1059830328479277295)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>96.69999999999999
,p_break_order=>1
,p_break_is_enabled=>true
,p_break_sort_direction=>'ASC'
);
```

---

## IG Report Aggregates (`create_ig_report_aggregate`)

From page 9:

```sql
wwv_flow_imp_page.create_ig_report_aggregate(
 p_id=>wwv_flow_imp.id(1373990063572102727)
,p_view_id=>wwv_flow_imp.id(3978988269881465258)
,p_tooltip=>'Average'
,p_function=>'AVG'
,p_column_id=>wwv_flow_imp.id(3322313630523957063)
,p_show_grand_total=>true
,p_is_enabled=>true
);
```

Aggregate functions: `'AVG'`, `'SUM'`, `'COUNT'`, `'MIN'`, `'MAX'`, etc.

---

## IG Report Chart Columns (`create_ig_report_chart_col`)

From page 30:

```sql
wwv_flow_imp_page.create_ig_report_chart_col(
 p_id=>wwv_flow_imp.id(30910815450487527)
,p_view_id=>wwv_flow_imp.id(30910736635487527)
,p_column_type=>'LABEL'
,p_column_id=>wwv_flow_imp.id(729546016109413699)
);
wwv_flow_imp_page.create_ig_report_chart_col(
 p_id=>wwv_flow_imp.id(30910847650487527)
,p_view_id=>wwv_flow_imp.id(30910736635487527)
,p_column_type=>'VALUE'
,p_column_id=>wwv_flow_imp.id(729547991180413701)
,p_function=>'SUM'
);
```

Chart column types: `'LABEL'` (x-axis), `'VALUE'` (y-axis with aggregation function).

---

## IG Save Process (`NATIVE_IG_DML`)

From page 30:

```sql
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(729551207605413707)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(729544022795413693)
,p_process_type=>'NATIVE_IG_DML'
,p_process_name=>' - Save Interactive Grid Data'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>701151416339605522
);
```

Key attributes:
- `p_process_type=>'NATIVE_IG_DML'`
- `p_attribute_01=>'REGION_SOURCE'` -- uses the region's SQL source for DML target
- `p_attribute_05=>'Y'` -- return primary key value after insert
- `p_attribute_06=>'Y'` -- lock row before update
- `p_attribute_08=>'Y'` -- return DML count

For master-detail, use two separate DML processes with distinct `p_process_sequence` values:

```sql
-- Master (sequence 20)
wwv_flow_imp_page.create_page_process(
 ...
,p_process_sequence=>20
,p_region_id=>wwv_flow_imp.id(727558198450089851)  -- Departments region
,p_process_type=>'NATIVE_IG_DML'
,p_process_name=>'Departments - Save Interactive Grid Data'
...
);

-- Detail (sequence 30)
wwv_flow_imp_page.create_page_process(
 ...
,p_process_sequence=>30
,p_region_id=>wwv_flow_imp.id(727558839439089857)  -- Employees region
,p_process_type=>'NATIVE_IG_DML'
,p_process_name=>'Employees - Save Interactive Grid Data'
...
);
```

---

## Common Patterns

### Column type distribution (across 38 IG pages)

| Column Type | Occurrences | Notes |
|-------------|-------------|-------|
| `NATIVE_TEXT_FIELD` | Most common | Default for VARCHAR2 columns |
| `NATIVE_HIDDEN` | Very common | Used for PK columns, FK columns, helper data |
| `NATIVE_NUMBER_FIELD` | Very common | Used for all numeric display/edit |
| `NATIVE_SELECT_LIST` | Common | LOV-driven columns (SQL, SHARED, STATIC) |
| `NATIVE_DATE_PICKER` | Common | All DATE columns |
| `NATIVE_DISPLAY_ONLY` | Common | Read-only columns, often LOV-based |
| `NATIVE_ROW_SELECTOR` | Common | Pseudo-column, present in all editable IGs |
| `NATIVE_ROW_ACTION` | Common | Pseudo-column, present in all editable IGs |
| `NATIVE_YES_NO` | Moderate | Boolean toggle (Y/N values) |
| `NATIVE_SINGLE_CHECKBOX` | Moderate | Alternative boolean display |
| `NATIVE_RADIOGROUP` | Moderate | LOV-driven, renders inline radio buttons |
| `NATIVE_TEXTAREA` | Moderate | Multi-line text, often with `resizable=>'Y'` |
| `NATIVE_POPUP_LOV` | Rare | Dialog-style LOV picker |
| `NATIVE_HTML_EXPRESSION` | Rare | Custom HTML rendering, `p_is_query_only=>true` |
| `NATIVE_LINK` | Rare | Clickable link column |
| `NATIVE_PASSWORD` | Rare | Masked input |
| `NATIVE_COLOR_PICKER` | Rare | Color selection |
| `NATIVE_SHUTTLE` | Rare | Multi-select between lists |
| `NATIVE_CHECKBOX` | Rare | Multi-value checkbox (vs SINGLE_CHECKBOX) |
| `PLUGIN_*` | Rare | Custom plugin columns (e.g., star rating) |

### Default alignment conventions

- VARCHAR2 columns: `p_heading_alignment=>'LEFT'`, `p_value_alignment=>'LEFT'`
- NUMBER columns: `p_heading_alignment=>'RIGHT'`, `p_value_alignment=>'RIGHT'`
- DATE columns: `p_heading_alignment=>'LEFT'`, `p_value_alignment=>'LEFT'`
- Checkbox/boolean columns: `p_heading_alignment=>'CENTER'`, `p_value_alignment=>'CENTER'`

### LOV integration patterns

Three LOV source types:
1. **SQL_QUERY**: `p_lov_type=>'SQL_QUERY'`, `p_lov_source=>'select display, return from ...'`
2. **SHARED**: `p_lov_type=>'SHARED'`, `p_lov_id=>wwv_flow_imp.id(...)`
3. **STATIC**: `p_lov_type=>'STATIC'`, `p_lov_source=>'STATIC:Display1;Return1,...'`

Common LOV-related parameters:
- `p_lov_display_extra=>true` -- show stored value even if not in LOV
- `p_lov_display_null=>true` -- show blank/null option
- `p_filter_lov_type=>'LOV'` -- filter using LOV values (vs `'DISTINCT'` for raw data)

### Edit mode configuration

- `p_is_editable=>true` on `create_interactive_grid` enables editing
- `p_edit_operations=>'i:u:d'` -- colon-separated insert/update/delete flags
- Editable IGs always have `APEX$ROW_SELECTOR` and `APEX$ROW_ACTION` pseudo-columns
- PK column is typically `NATIVE_HIDDEN` with `p_is_primary_key=>true`
- A `NATIVE_IG_DML` process is required for persistence

### Attribute format (24.2+)

All column attributes use the new 24.2 `wwv_flow_t_plugin_attributes` format:

```sql
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'key1', 'value1',
  'key2', 'value2')).to_clob
```

This replaces the older `p_attribute_01`, `p_attribute_02`, etc. format used in pre-24.2 exports.

### Default column defaults

For editable columns that need a default value on new rows:

```sql
,p_default_type=>'STATIC'
,p_default_expression=>'N'
```

### Call order in export files

The standard order of API calls within a page export is:
1. `create_page(...)` -- page definition
2. `create_page_plug(...)` -- IG region
3. `create_region_column_group(...)` -- column groups (if any)
4. `create_region_column(...)` -- all region columns
5. `create_interactive_grid(...)` -- IG settings
6. `create_ig_report(...)` -- report definitions
7. `create_ig_report_view(...)` -- view settings per report
8. `create_ig_report_column(...)` -- column settings per view
9. `create_ig_report_aggregate(...)` -- aggregates (if any)
10. `create_ig_report_chart_col(...)` -- chart columns (if chart view defined)
11. Other regions (overview text, breadcrumbs)
12. `create_page_button(...)` -- buttons
13. `create_page_item(...)` -- page items (if any)
14. `create_page_da_event(...)` / `create_page_da_action(...)` -- dynamic actions (if any)
15. `create_page_validation(...)` -- validations (if any)
16. `create_page_process(...)` -- processes (NATIVE_IG_DML)
