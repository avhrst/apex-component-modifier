# Interactive Report (`NATIVE_IR`)

IR regions use `create_page_plug` with `p_plug_source_type=>'NATIVE_IR'`.
Each IR requires tightly coupled layers:

1. **Region** (`create_page_plug`) -- SQL source and region placement
2. **Worksheet** (`create_worksheet`) -- pagination, downloads, search bar
3. **Column Groups** (`create_worksheet_col_group`) -- optional column grouping headers
4. **Columns** (`create_worksheet_column`) -- one per SELECT column
5. **Saved reports** (`create_worksheet_rpt`) -- at least one default required
6. **Conditions** (`create_worksheet_condition`) -- optional filters/highlights per saved report
7. **Computations** (`create_worksheet_computation`) -- calculated columns per saved report
8. **Group By** (`create_worksheet_group_by`) -- aggregation views per saved report
9. **Pivot** (`create_worksheet_pivot` + `create_worksheet_pivot_agg`) -- pivot views per saved report

## IR Region (`create_page_plug`)

```sql
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(2573278322369354707)
,p_plug_name=>'Projects'
,p_region_name=>'projects_report'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>20
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select	ROWID,',
'       ID,',
'       PROJECT,',
'       TASK_NAME,',
'       START_DATE,',
'       END_DATE,',
'       STATUS,',
'       ASSIGNED_TO,',
'       COST,',
'       BUDGET,',
'       budget - cost available_budget',
'from EBA_DEMO_IR_PROJECTS'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_show_nulls_as=>' - '
,p_pagination_display_position=>'BOTTOM_RIGHT'
);
```

**With bind variables and nesting**:
```sql
,p_parent_plug_id=>wwv_flow_imp.id(2198021503039156114)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders'
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ...',
'from EBA_DEMO_IR_PROJECTS',
'where NVL(:P15_PROJECT,''0'') = ''0'' or project = :P15_PROJECT',
'group by project'))
```

**With `p_ajax_items_to_submit`** (filter-driven refresh):
```sql
,p_ajax_items_to_submit=>'P59_DISPLAY_AS'
```

| Parameter | Purpose | Common values |
|---|---|---|
| `p_plug_source_type` | Must be `'NATIVE_IR'` | `'NATIVE_IR'` |
| `p_query_type` | Always SQL for IR | `'SQL'` |
| `p_plug_source` | SELECT statement | `wwv_flow_string.join(...)` |
| `p_region_name` | Static ID for URL/DA | e.g. `'projects_report'` |
| `p_plug_query_show_nulls_as` | NULL display | `' - '` |
| `p_pagination_display_position` | Pagination placement | `'BOTTOM_RIGHT'` |
| `p_ajax_items_to_submit` | Items submitted on AJAX refresh | `'P59_DISPLAY_AS'` |
| `p_parent_plug_id` | Nesting inside container | region ID |
| `p_plug_display_point` | When nested | `'SUB_REGIONS'` |

> IR regions do not support `p_query_type=>'TABLE'` -- only SQL.

## Worksheet (`create_worksheet`)

One per IR region.

```sql
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(2573278395828354707)
,p_name=>'Projects'
,p_max_row_count=>'100000'
,p_max_row_count_message=>'This query returns more than #MAX_ROW_COUNT# rows, please filter your data to ensure complete results.'
,p_no_data_found_message=>'No data found.'
,p_allow_save_rpt_public=>'Y'
,p_allow_report_categories=>'N'
,p_show_nulls_as=>'-'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_show_calendar=>'N'
,p_download_formats=>'CSV:HTML'
,p_enable_mail_download=>'Y'
,p_detail_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_ROWID:#ROWID#'
,p_detail_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="Edit">'
,p_owner=>'DPEAKE'
,p_internal_uid=>1908983501483820764
);
```

**With detail view**:
```sql
,p_detail_view_enabled_yn=>'Y'
,p_detail_view_before_rows=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<style>',
'table.apexir_WORKSHEET_CUSTOM { border: none !important; }',
'</style>',
'<table class="reportDetail">'))
,p_detail_view_for_each_row=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<tr><td colspan="4" class="separator"></td></tr>',
'<tr>',
'<td><strong><u>#PROJECT#</u></strong></td><td><i>#TASK_NAME#</i></td>',
'</tr>'))
,p_detail_view_after_rows=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<tr><td colspan="4" class="separator"></td></tr>',
'</table>'))
```

**Minimal worksheet** (modal): same structure, `p_show_detail_link=>'N'`.

**Extended downloads**: `p_download_formats=>'CSV:HTML:XLSX:PDF'`

**Single-view (no tabs)**: `p_report_list_mode=>'NONE'`

**Conditional detail link**:
```sql
,p_detail_link_condition_type=>'EXISTS'
,p_detail_link_cond=>'select 1 from ...'
```

**Detail link auth scheme**: `p_detail_link_auth_scheme=>wwv_flow_imp.id(NNN)`

**Download auth scheme**: `p_download_auth_scheme=>wwv_flow_imp.id(NNN)`

**Custom download filename**: `p_download_filename=>'projects_export'`

**Custom email from**: `p_email_from=>'noreply@example.com'`

### Full worksheet parameters

| Parameter | Purpose | Values |
|---|---|---|
| `p_max_row_count` | Max rows fetched | `'10000'`, `'100000'` |
| `p_max_row_count_message` | Overflow message | Template with `#MAX_ROW_COUNT#` |
| `p_no_data_found_message` | No data message | `'No data found.'` |
| `p_max_rows_per_page` | Max rows per page | `6`, `10`, `14`, `15` |
| `p_pagination_type` | Pagination style | `'ROWS_X_TO_Y'` (96%), `'ROWS_X_TO_Y_OF_Z'` (4%) |
| `p_pagination_display_pos` | Pagination location | `'BOTTOM_RIGHT'` |
| `p_report_list_mode` | Saved report tabs | `'TABS'` (98%), `'NONE'` (2%) |
| `p_show_detail_link` | Edit/detail link | `'N'` (66%), `'C'` (34%) -- never bare `'Y'` |
| `p_detail_link` | Row-level URL | `'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_ROWID:#ROWID#'` |
| `p_detail_link_text` | Link icon HTML | pencil icon |
| `p_detail_link_attr` | Link HTML attributes | custom class/style |
| `p_detail_link_condition_type` | Conditional link | `'EXISTS'` |
| `p_detail_link_cond` | Condition expression | SQL / expression |
| `p_detail_link_auth_scheme` | Link auth scheme | auth scheme ID |
| `p_download_formats` | Colon-separated | `'CSV:HTML:XLSX:PDF'` (52%), `'CSV:HTML'` (44%), `'CSV:HTML:PDF'` (3%) |
| `p_download_auth_scheme` | Download auth scheme | auth scheme ID |
| `p_download_filename` | Custom filename | `'projects_export'` |
| `p_lazy_loading` | Lazy load | `false` (always) |
| `p_fixed_header` | Fixed header mode | `'NONE'` (when set, rare) |
| `p_show_calendar` | Calendar view | `'N'` (when set; omit = default Y) |
| `p_show_notify` | Notification bar | `'Y'` |
| `p_show_search_bar` | Show search bar | `'N'` (when set; omit = default Y) |
| `p_show_actions_menu` | Actions menu | `'N'` (when set; omit = default Y) |
| `p_enable_mail_download` | Email download | `'Y'` |
| `p_email_from` | Email from address | email string |
| `p_allow_save_rpt_public` | Public saved reports | `'Y'`, `'N'` |
| `p_save_rpt_public_auth_scheme` | Auth for public save | auth scheme ID |
| `p_allow_report_categories` | Report categories | `'Y'`, `'N'` |
| `p_allow_report_saving` | Allow report saving | `'Y'`, `'N'` |
| `p_detail_view_enabled_yn` | Enable detail view | `'Y'`, `'N'` |
| `p_report_id_item` | Item holding report alias | page item name |
| `p_security_scheme` | Worksheet auth | auth scheme ID |
| `p_required_patch` | Build option | build option ID |

### Show/allow feature toggles

These parameters selectively disable features (default is enabled when omitted):

| Parameter | Controls |
|---|---|
| `p_show_aggregate` | Aggregate option |
| `p_show_chart` | Chart view |
| `p_show_computation` | Computation option |
| `p_show_control_break` | Control break option |
| `p_show_display_row_count` | Row count display |
| `p_show_download` | Download option |
| `p_show_filter` | Filter option |
| `p_show_flashback` | Flashback option |
| `p_show_highlight` | Highlight option |
| `p_show_pivot` | Pivot option |
| `p_show_rows_per_page` | Rows-per-page selector |
| `p_allow_aggregations` | Column aggregation |
| `p_allow_charting` | Charting on columns |
| `p_allow_computations` | Column computations |
| `p_allow_ctrl_breaks` | Control breaks |
| `p_allow_exclude_null_values` | Null exclusion filter |
| `p_allow_filtering` | Column filtering |
| `p_allow_hide` | Column hiding |
| `p_allow_hide_extra_columns` | Extra column hiding |
| `p_allow_highlighting` | Row/column highlighting |
| `p_allow_pivot` | Pivot |
| `p_allow_sorting` | Column sorting |

## Column Groups (`create_worksheet_col_group`)

Groups columns under a shared heading. Defined before columns, referenced via `p_group_id`.

```sql
wwv_flow_imp_page.create_worksheet_col_group(
 p_id=>wwv_flow_imp.id(8420852525209379575)
,p_name=>'Details'
,p_display_sequence=>10
);
wwv_flow_imp_page.create_worksheet_col_group(
 p_id=>wwv_flow_imp.id(8420852431789379569)
,p_name=>'Audit Info'
,p_display_sequence=>20
);
```

Columns reference the group:
```sql
wwv_flow_imp_page.create_worksheet_column(
 ...
,p_group_id=>wwv_flow_imp.id(8420852525209379575)
,p_db_column_name=>'EVENT_TYPE'
...
);
```

| Parameter | Purpose | Values |
|---|---|---|
| `p_name` | Group heading text | `'Details'`, `'Audit Info'` |
| `p_display_sequence` | Group order | `10`, `20` |

## Worksheet Columns (`create_worksheet_column`)

One per SELECT expression. `p_db_column_name` must match SQL alias (uppercase). Ordered by `p_display_order`, identified by `p_column_identifier` (A, B, ..., Z, AA, AB, ...).

### Text column

```sql
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(2573278700415354714)
,p_db_column_name=>'PROJECT'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Project'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
```

**Text with link**:
```sql
,p_column_link=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:RP,RIR,CIR:IR_PROJECT:#PROJECT#'
,p_column_linktext=>'#PROJECT#'
```

**Styled link (button-like)**:
```sql
,p_column_link=>'f?p=&APP_ID.:50:&SESSION.::&DEBUG.:50:P50_ID:#ID#'
,p_column_linktext=>'<span>#ROW_KEY#</span>'
,p_column_link_attr=>'class="t-Button t-Button--small t-Button--hot t-Button--simple t-Button--stretch"'
```

**HTML expression column** (computed display):
```sql
,p_column_html_expression=>'#SALES_TREND_PERCENTAGE#%'
```

### Number column

```sql
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(2573279312041354714)
,p_db_column_name=>'COST'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Cost'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G999G990'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
```

Currency: `p_format_mask=>'999G999G999G999G999G990D00'`

### Date column

```sql
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(2573278926710354714)
,p_db_column_name=>'START_DATE'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
```

**SINCE format**: `p_format_mask=>'SINCE'`
**Explicit format**: `p_format_mask=>'DD-MON-YYYY'`
**Timezone aware**: `p_tz_dependent=>'Y'`

### CLOB column

Same as STRING but `p_column_type=>'CLOB'`.

### LOV column (named LOV)

```sql
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(17163581381998874246)
,p_db_column_name=>'STRATEGIC_CUSTOMER_PROGRAM_YN'
,p_display_order=>91
,p_column_identifier=>'BC'
,p_column_label=>'SCP Customer'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_rpt_named_lov=>wwv_flow_imp.id(17824313924399776811)
,p_rpt_show_filter_lov=>'1'
,p_use_as_row_header=>'N'
);
```

**Inline filter LOV** (query-based):
```sql
,p_rpt_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select tag',
'  from eba_cust_tags_type_sum',
' where content_type = ''CUSTOMER''',
'   and tag_count > 0'))
,p_rpt_show_filter_lov=>'C'
```

### Hidden column

```sql
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(2573278622777354712)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
```

**ROWID column** (all features disabled):
```sql
,p_db_column_name=>'ROWID'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'OTHER'
,p_display_text_as=>'HIDDEN'
,p_rpt_show_filter_lov=>'N'
```

### Primary Key column

```sql
,p_is_primary_key=>'Y'
```

### Graph column

```sql
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_format_mask=>'PCT_GRAPH:CFDEF0:144485:150'
```

### Template display columns

```sql
,p_display_text_as=>'TMPL_THEME_42$BADGE'
-- or
,p_display_text_as=>'TMPL_THEME_42$AVATAR'
```

### Conditional display

```sql
,p_display_condition_type=>'EXPRESSION'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'APEX_UTIL.GET_BUILD_OPTION_STATUS(',
'    P_APPLICATION_ID => :APP_ID,',
'    P_BUILD_OPTION_NAME => ''Customer Referencability'') = ''INCLUDE'''))
,p_display_condition2=>'PLSQL'
```

### AI-enabled column

```sql
,p_ai_enabled=>false
```

### Key column parameters

| Parameter | Purpose | Values |
|---|---|---|
| `p_db_column_name` | Must match SQL alias (UPPER) | `'PROJECT'`, `'COST'` |
| `p_display_order` | Column position | Sequential integers |
| `p_column_identifier` | Letter ID (A-Z, AA...) | Unique per worksheet |
| `p_column_label` | Column heading | Display text |
| `p_column_type` | Data type | `'STRING'` (54%), `'NUMBER'` (30%), `'DATE'` (15%), `'OTHER'` (<1%), `'CLOB'` (<1%) |
| `p_display_text_as` | Display mode | `'HIDDEN'`, `'HIDDEN_ESCAPE_SC'`, `'LOV_ESCAPE_SC'`, `'WITHOUT_MODIFICATION'`, `'STRIP_HTML_ESCAPE_SC'`, `'TMPL_THEME_42$BADGE'`, `'TMPL_THEME_42$AVATAR'` |
| `p_heading_alignment` | Header align | `'LEFT'`, `'RIGHT'` |
| `p_column_alignment` | Data align | `'LEFT'`, `'RIGHT'` |
| `p_format_mask` | Format | `'999G999G999G999G999G990'`, `'SINCE'`, `'DD-MON-YYYY'`, `'PCT_GRAPH:...'` |
| `p_column_link` | Click URL | `'f?p=...'` |
| `p_column_linktext` | Link HTML | `'#PROJECT#'` |
| `p_column_link_attr` | Link attrs | `'class="t-Button ..."'` |
| `p_column_html_expression` | HTML expression | `'#COL1# (#COL2#)'` |
| `p_column_comment` | Developer comment | Free text |
| `p_tz_dependent` | Timezone | `'Y'`, `'N'` |
| `p_is_primary_key` | Primary key flag | `'Y'` |
| `p_ai_enabled` | AI features | `false` |
| `p_rpt_named_lov` | Named LOV ref | LOV ID |
| `p_rpt_lov` | Inline LOV query | SQL string |
| `p_rpt_show_filter_lov` | Filter LOV | `'1'` (55%), `'N'` (33%), `'C'` (7%), `'2'`, `'S'` |
| `p_group_id` | Column group ref | col_group ID |
| `p_allow_sorting` | Enable sort | `'Y'`, `'N'` |
| `p_allow_filtering` | Enable filter | `'Y'`, `'N'` |
| `p_allow_highlighting` | Enable highlight | `'Y'`, `'N'` |
| `p_allow_ctrl_breaks` | Enable break | `'Y'`, `'N'` |
| `p_allow_aggregations` | Enable aggregate | `'Y'`, `'N'` |
| `p_allow_computations` | Enable compute | `'Y'`, `'N'` |
| `p_allow_charting` | Enable chart | `'Y'`, `'N'` |
| `p_allow_group_by` | Enable group by | `'Y'`, `'N'` |
| `p_allow_pivot` | Enable pivot | `'Y'`, `'N'` |
| `p_allow_hide` | Enable hide | `'Y'`, `'N'` |
| `p_display_condition_type` | Conditional | `'EXPRESSION'` (61%), `'ITEM_IS_NOT_NULL'` (22%), `'EXISTS'` (12%), `'NEVER'`, `'FUNCTION_BODY'`, `'VAL_OF_ITEM_IN_COND_EQ_COND2'` |
| `p_display_condition` | Condition expr | PL/SQL / SQL / item name |
| `p_display_condition2` | Condition language | `'PLSQL'` |
| `p_security_scheme` | Column auth | auth scheme ID |
| `p_required_patch` | Build option | build option ID |
| `p_use_as_row_header` | Row header | `'Y'`, `'N'` |

## Saved Reports (`create_worksheet_rpt`)

Default report: `p_application_user=>'APXWS_DEFAULT'`.
Alternative: `p_application_user=>'APXWS_ALTERNATIVE'`.

### Default report

```sql
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(2573440809256379296)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_type=>'REPORT'
,p_report_alias=>'19091460'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>15
,p_view_mode=>'REPORT'
,p_report_columns=>'ID:PROJECT:TASK_NAME:START_DATE:END_DATE:STATUS:ASSIGNED_TO:COST:BUDGET:ROWID:AVAILABLE_BUDGET'
,p_sort_column_1=>'START_DATE'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'END_DATE'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'PROJECT'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
,p_sum_columns_on_break=>'COST:BUDGET'
);
```

### Alternative report (CHART type with break/computation)

```sql
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(2573520297922432804)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'Budget Review'
,p_report_seq=>10
,p_report_type=>'CHART'
,p_report_alias=>'19092255'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>15
,p_view_mode=>'REPORT'
,p_report_columns=>'PROJECT:TASK_NAME:STATUS:COST:BUDGET::APXWS_CC_001'
,p_break_on=>'PROJECT'
,p_break_enabled_on=>'PROJECT'
,p_sum_columns_on_break=>'APXWS_CC_001:COST:BUDGET'
,p_chart_type=>'bar'
,p_chart_label_column=>'PROJECT'
,p_chart_label_title=>'Project'
,p_chart_value_column=>'APXWS_CC_001'
,p_chart_aggregate=>'SUM'
,p_chart_value_title=>'Budget v Cost'
,p_chart_sorting=>'LABEL_ASC'
,p_chart_orientation=>'horizontal'
);
```

**Pivot type**: `p_report_type=>'PIVOT'`

**With distinct count on break**: `p_count_distnt_col_on_break=>'STATUS'`

| Parameter | Purpose | Values |
|---|---|---|
| `p_application_user` | Report ownership | `'APXWS_DEFAULT'`, `'APXWS_ALTERNATIVE'` |
| `p_name` | Display name (alternative only) | e.g. `'Budget Review'` |
| `p_report_seq` | Order | `10` |
| `p_report_type` | View type | `'REPORT'`, `'CHART'`, `'PIVOT'` |
| `p_report_alias` | Unique alias for URL | Numeric string |
| `p_status` | Visibility | `'PUBLIC'`, `'PRIVATE'` |
| `p_is_default` | Default for type | `'Y'` |
| `p_display_rows` | Rows per page | `5`, `15` |
| `p_view_mode` | Active view | `'REPORT'` (always) |
| `p_report_columns` | Colon-separated list | `'PROJECT:TASK_NAME:STATUS:COST'` |
| `p_sort_column_N` | Sort column (1-6) | Column name or `'0'` |
| `p_sort_direction_N` | Sort direction (1-6) | `'ASC'`, `'DESC'` |
| `p_sum_columns_on_break` | Aggregate columns | `'COST:BUDGET'` |
| `p_count_distnt_col_on_break` | Distinct count on break | Column name |
| `p_break_on` | Break column | Column name |
| `p_break_enabled_on` | Active break columns | Column name |
| `p_chart_type` | Chart type (CHART) | `'bar'` |
| `p_chart_label_column` | Chart label | Column name |
| `p_chart_label_title` | Label axis title | Display text |
| `p_chart_value_column` | Chart value | Column name |
| `p_chart_value_title` | Value axis title | Display text |
| `p_chart_aggregate` | Chart aggregate | `'SUM'` |
| `p_chart_sorting` | Chart sort | `'LABEL_ASC'` |
| `p_chart_orientation` | Chart direction | `'horizontal'`, `'vertical'` |
| `p_pivot_columns` | Pivot columns (PIVOT) | Column name |
| `p_sel_yn` | Selected flag | `'Y'` |
| `p_required_patch` | Build option | build option ID |
| `p_security_scheme` | Report auth | auth scheme ID |

## Conditions (`create_worksheet_condition`)

### FILTER

```sql
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(1341623723748318835)
,p_report_id=>wwv_flow_imp.id(1321203601142048986)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'AVAILABLE_BUDGET'
,p_operator=>'>'
,p_expr=>'0'
,p_condition_sql=>'"AVAILABLE_BUDGET" > to_number(#APXWS_EXPR#)'
,p_condition_display=>'#APXWS_COL_NAME# > #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
);
```

### HIGHLIGHT (row background)

```sql
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(2688377316428042831)
,p_report_id=>wwv_flow_imp.id(2688377120709042831)
,p_name=>'Over Budget'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'AVAILABLE_BUDGET'
,p_operator=>'<'
,p_expr=>'0'
,p_condition_sql=>' (case when ("AVAILABLE_BUDGET" < to_number(#APXWS_EXPR#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# < #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#FFFF99'
);
```

**Column-only highlight**: use `p_column_bg_color` instead of `p_row_bg_color`.

| Parameter | Purpose | Values |
|---|---|---|
| `p_report_id` | Parent saved report | report ID |
| `p_name` | Condition name (HIGHLIGHT) | Display text |
| `p_condition_type` | Rule type | `'FILTER'`, `'HIGHLIGHT'` |
| `p_allow_delete` | User can delete | `'Y'` |
| `p_column_name` | Target column | Column name |
| `p_operator` | Comparison | `'='` (52%), `'>'` (13%), `'!='` (11%), `'>='` (7%), `'is not null'`, `'<'`, `'is null'`, `'is in the last'`, `'in'` |
| `p_expr` | Comparison value | Literal value |
| `p_expr_type` | Expression type | `'ROW'`, `'VALUE'` |
| `p_condition_sql` | SQL condition | Generated SQL with `#APXWS_EXPR#` |
| `p_condition_display` | Display text | Human-readable with `#APXWS_COL_NAME#` |
| `p_enabled` | Active | `'Y'` |
| `p_highlight_sequence` | Highlight order | `10`, `20` |
| `p_row_bg_color` | Row background | `'#FFFF99'` |
| `p_column_bg_color` | Cell background | `'#FFFF99'` |

## Computations (`create_worksheet_computation`)

```sql
wwv_flow_imp_page.create_worksheet_computation(
 p_id=>wwv_flow_imp.id(2688377703525047381)
,p_report_id=>wwv_flow_imp.id(2573520297922432804)
,p_db_column_name=>'APXWS_CC_001'
,p_column_identifier=>'C01'
,p_computation_expr=>'I - H'                -- references column_identifiers
,p_format_mask=>'FML999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Budget v Cost'
,p_report_label=>'Budget v Cost'
);
```

| Parameter | Purpose | Values |
|---|---|---|
| `p_report_id` | Parent saved report | report ID |
| `p_db_column_name` | Virtual column name | `'APXWS_CC_001'`, `'APXWS_CC_002'` ... |
| `p_column_identifier` | Identifier | `'C01'`, `'C02'` ... |
| `p_computation_expr` | Expression | Column identifiers + math ops |
| `p_format_mask` | Format | `'FML999G999G999G999G990D00'` |
| `p_column_type` | Result type | `'NUMBER'` |
| `p_column_label` | Column heading | Display text |
| `p_report_label` | Report label | Display text |
| `p_by_columns` | Per-group computation | Column name |

## Group By (`create_worksheet_group_by`)

```sql
wwv_flow_imp_page.create_worksheet_group_by(
 p_id=>wwv_flow_imp.id(2688377806724047381)
,p_report_id=>wwv_flow_imp.id(2573520297922432804)
,p_group_by_columns=>'STATUS'
,p_function_01=>'SUM'
,p_function_column_01=>'COST'
,p_function_db_column_name_01=>'APXWS_GBFC_01'
,p_function_format_mask_01=>'FML999G999G999G999G990D00'
,p_function_sum_01=>'Y'
,p_function_02=>'SUM'
,p_function_column_02=>'BUDGET'
,p_function_db_column_name_02=>'APXWS_GBFC_02'
,p_function_format_mask_02=>'FML999G999G999G999G990D00'
,p_function_sum_02=>'Y'
,p_sort_column_01=>'STATUS'
,p_sort_direction_01=>'ASC'
);
```

| Parameter | Purpose | Values |
|---|---|---|
| `p_report_id` | Parent saved report | report ID |
| `p_group_by_columns` | Columns to group | Column name(s) |
| `p_function_NN` | Aggregate function | `'SUM'`, `'AVG'`, `'COUNT'`, `'MIN'`, `'MAX'` |
| `p_function_column_NN` | Source column | Column name |
| `p_function_db_column_name_NN` | Virtual column | `'APXWS_GBFC_01'` ... |
| `p_function_format_mask_NN` | Format | Number format mask |
| `p_function_sum_NN` | Show grand total | `'Y'`, `'N'` |
| `p_sort_column_NN` | Sort column | Column name |
| `p_sort_direction_NN` | Sort direction | `'ASC'`, `'DESC'` |

## Pivot (`create_worksheet_pivot` + `create_worksheet_pivot_agg`)

```sql
wwv_flow_imp_page.create_worksheet_pivot(
 p_id=>wwv_flow_imp.id(2208823641525891634)
,p_report_id=>wwv_flow_imp.id(2208823256981891629)
,p_pivot_columns=>'ASSIGNED_TO'
,p_row_columns=>'PROJECT'
);

wwv_flow_imp_page.create_worksheet_pivot_agg(
 p_id=>wwv_flow_imp.id(2208824026428891635)
,p_pivot_id=>wwv_flow_imp.id(2208823641525891634)
,p_display_seq=>1
,p_function_name=>'SUM'
,p_column_name=>'COST'
,p_db_column_name=>'PFC1'
,p_column_label=>'Total Cost'
,p_format_mask=>'999G999G999G999G990'
,p_display_sum=>'N'
);
```

| Parameter | Purpose | Values |
|---|---|---|
| **Pivot** | | |
| `p_report_id` | Parent saved report | report ID |
| `p_pivot_columns` | Pivot columns | Column name(s) |
| `p_row_columns` | Row columns | Column name(s) |
| **Pivot Agg** | | |
| `p_pivot_id` | Parent pivot | pivot ID |
| `p_display_seq` | Order | `1`, `2` |
| `p_function_name` | Aggregate | `'SUM'`, `'AVG'`, `'COUNT'`, `'MIN'`, `'MAX'` |
| `p_column_name` | Source column | Column name |
| `p_db_column_name` | Virtual column | `'PFC1'`, `'PFC2'` |
| `p_column_label` | Display label | `'Total Cost'` |
| `p_format_mask` | Format | Number format mask |
| `p_display_sum` | Grand total | `'Y'`, `'N'` |

## Search Bar Buttons

Position: `p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'`.

### Reset button

```sql
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(2666884304101194851)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(2573278322369354707)
,p_button_name=>'RESET_DATA'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>2349107722467437027
,p_button_image_alt=>'Reset'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:RP,1,RIR::'
,p_icon_css_classes=>'fa-undo-alt'
);
```

Reset URL: `f?p=&APP_ID.:<PAGE>:&SESSION.::&DEBUG.:RP,<PAGE>,RIR::` -- `RP` = Reset Pagination, `RIR` = Reset IR, `CIR` = Clear IR.

### Create button

```sql
,p_button_name=>'CREATE'
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Category'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:4::'
```

## Dynamic Actions for IR

### Refresh on dialog close

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

**With success message** (window-level trigger):
```sql
,p_triggering_element_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_element=>'window'
-- Second action:
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.message.showPageSuccess(''Action Processed.'');'
```

## Parameter Value Catalog

### Column types (`p_column_type`)
`'STRING'` (54%) · `'NUMBER'` (30%) · `'DATE'` (15%) · `'OTHER'` (<1%) · `'CLOB'` (<1%)

### Display modes (`p_display_text_as`)
`'HIDDEN'` (43%) · `'HIDDEN_ESCAPE_SC'` (37%) · `'LOV_ESCAPE_SC'` (12%) · `'WITHOUT_MODIFICATION'` (8%) · `'STRIP_HTML_ESCAPE_SC'` · `'TMPL_THEME_42$BADGE'` · `'TMPL_THEME_42$AVATAR'`

### Pagination types (`p_pagination_type`)
`'ROWS_X_TO_Y'` (96%) · `'ROWS_X_TO_Y_OF_Z'` (4%)

### Download formats (`p_download_formats`)
`'CSV:HTML:XLSX:PDF'` (52%) · `'CSV:HTML'` (44%) · `'CSV:HTML:PDF'` (3%) · `'HTML:CSV'` (<1%)

### Condition operators (`p_operator`)
`'='` · `'>'` · `'!='` · `'>='` · `'<'` · `'is not null'` · `'is null'` · `'is in the last'` · `'in'`

### Column display condition types (`p_display_condition_type`)
`'EXPRESSION'` · `'ITEM_IS_NOT_NULL'` · `'EXISTS'` · `'NEVER'` · `'FUNCTION_BODY'` · `'VAL_OF_ITEM_IN_COND_EQ_COND2'`

### Filter LOV modes (`p_rpt_show_filter_lov`)
`'1'` (show) · `'N'` (none) · `'C'` (custom query) · `'2'` · `'S'`

## Conventions

**Alignment**: STRING=LEFT, NUMBER=RIGHT (both heading+column), DATE=LEFT.
**Number formats**: Integer `999G999G999G999G999G990`, decimal `...D00`, currency `FML...D00`, graph `PCT_GRAPH:CFDEF0:144485:150`.
**Date formats**: `SINCE`, `DD-MON-YYYY`.
**Defaults**: `p_tz_dependent=>'N'`, `p_use_as_row_header=>'N'`.
**Pagination**: `p_pagination_type=>'ROWS_X_TO_Y'`, display `BOTTOM_RIGHT`, rows `15` (standard) or `5` (dense).
**Report list**: `'TABS'` (multiple reports) or `'NONE'` (single view).
**Column links**: Edit `f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_ROWID:#ROWID#`, IR filter `f?p=...:RP,RIR,CIR:IR_PROJECT:#PROJECT#`.
**Sort**: up to 6 slots, `'0'` = no sort, `'ASC'`/`'DESC'`.
**`p_report_columns`**: colon-separated, `::` = gap, omit = hidden.
**View mode**: `p_view_mode` is always `'REPORT'` in saved reports.
