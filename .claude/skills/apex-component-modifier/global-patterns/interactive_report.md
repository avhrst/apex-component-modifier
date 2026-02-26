# Interactive Report (`NATIVE_IR`)

IR regions use `create_page_plug` with `p_plug_source_type=>'NATIVE_IR'`.
Each IR region requires three tightly coupled layers:

1. **Region** (`create_page_plug`) -- defines SQL source and region placement
2. **Worksheet** (`create_worksheet`) -- controls pagination, download formats, detail view, search bar
3. **Columns** (`create_worksheet_column`) -- one per SELECT column, defines display type/format
4. **Saved reports** (`create_worksheet_rpt`) -- at least one default report required
5. **Conditions** (`create_worksheet_condition`) -- optional filters and highlights attached to a saved report

Sources: App 103 (Sample Reporting), App 104 (Customers) -- APEX 24.2.

---

## IR Region (`create_page_plug`)

### SQL query source (most common)

```sql
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(2573278322369354707)
,p_plug_name=>'Projects'
,p_region_name=>'projects_report'                    -- static ID for URL links and DA targeting
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379                -- IR region template ID
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

### SQL query source with bind variables

```sql
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1341921026707696089)
,p_plug_name=>'Projects'
,p_region_name=>'projects_report'
,p_parent_plug_id=>wwv_flow_imp.id(2198021503039156114)   -- nested inside container region
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select',
'       PROJECT,',
'       count(*) tasks,',
'       min(START_DATE) first_start_date,',
'       max(END_DATE) last_end_date,',
'       sum(decode(STATUS,''Open'',1,0)) open,',
'       sum(decode(STATUS,''Closed'',1,0)) closed,',
'       sum(decode(STATUS,''Pending'',1,0)) pending,',
'       sum(decode(STATUS,''On-Hold'',1,0)) on_hold,   ',
'       count(distinct ASSIGNED_TO) assignees,',
'       sum(COST) total_cost,',
'       sum(BUDGET) total_budget,',
'       sum(BUDGET) - sum(COST) cost_vs_budget',
'from EBA_DEMO_IR_PROJECTS',
'where NVL(:P15_PROJECT,''0'') = ''0'' or project = :P15_PROJECT',
'group by project'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_show_nulls_as=>' - '
,p_pagination_display_position=>'BOTTOM_RIGHT'
);
```

### IR with `p_ajax_items_to_submit` (filter-driven refresh)

When the IR query references page items that change without page submit, list them in
`p_ajax_items_to_submit` so the engine re-evaluates the bind on AJAX refresh:

```sql
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15775762253063505368)
,p_plug_name=>'Customer Report'
,p_region_name=>'report_region'
-- ... SQL with commented-out filter predicates and:
-- 'and NVL(:P59_DISPLAY_AS,''X'') = ''REPORT'''
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P59_DISPLAY_AS'
,p_plug_query_show_nulls_as=>' - '
,p_pagination_display_position=>'BOTTOM_RIGHT'
);
```

### Key region parameters

| Parameter | Purpose | Common values |
|-----------|---------|---------------|
| `p_plug_source_type` | Must be `'NATIVE_IR'` | `'NATIVE_IR'` |
| `p_query_type` | Source type | `'SQL'` (always SQL for IR) |
| `p_plug_source` | The SELECT statement | wrapped in `wwv_flow_string.join(...)` |
| `p_region_name` | Static ID for URL references and DAs | e.g. `'projects_report'` |
| `p_plug_query_show_nulls_as` | NULL display string | `' - '` |
| `p_pagination_display_position` | Pagination placement | `'BOTTOM_RIGHT'` |
| `p_ajax_items_to_submit` | Items to submit on AJAX refresh | `'P59_DISPLAY_AS'` |
| `p_parent_plug_id` | Nesting inside container region | region ID reference |
| `p_plug_display_point` | When nested | `'SUB_REGIONS'` |

> **Note:** IR regions do not support `p_query_type=>'TABLE'` -- only SQL query sources.

---

## Worksheet (`create_worksheet`)

One `create_worksheet` call per IR region. Controls overall worksheet behavior.

### Standard worksheet

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
,p_show_detail_link=>'C'                              -- C = conditional, N = no, Y = yes
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

### Worksheet with detail view

```sql
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(2573278395828354707)
-- ... standard parameters ...
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
'</tr>',
'<tr><td align="left"><strong>#STATUS_LABEL#:</strong></td><td>#STATUS#</td>',
'</tr>'))
,p_detail_view_after_rows=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<tr><td colspan="4" class="separator"></td></tr>',
'</table>'))
);
```

### Minimal worksheet (modal dialog pattern)

```sql
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(17828788626244373225)
,p_name=>'Categories'
,p_max_row_count=>'10000'
,p_max_row_count_message=>'This query returns more than #MAX_ROW_COUNT# rows, please filter your data to ensure complete results.'
,p_no_data_found_message=>'No data found.'
,p_allow_save_rpt_public=>'Y'
,p_allow_report_categories=>'N'
,p_show_nulls_as=>'-'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_show_calendar=>'N'
,p_download_formats=>'CSV:HTML'
,p_enable_mail_download=>'Y'
,p_owner=>'MIKE'
,p_internal_uid=>3741421224251032723
);
```

### Worksheet with extended download formats

```sql
,p_download_formats=>'CSV:HTML:XLSX:PDF'
```

### Worksheet with report list mode NONE (single-view IR)

```sql
,p_report_list_mode=>'NONE'     -- hides the saved report tabs
```

### Key worksheet parameters

| Parameter | Purpose | Common values |
|-----------|---------|---------------|
| `p_max_row_count` | Maximum rows fetched | `'10000'`, `'100000'`, `'1000000'` |
| `p_pagination_type` | Pagination style | `'ROWS_X_TO_Y'` |
| `p_pagination_display_pos` | Where pagination shows | `'BOTTOM_RIGHT'` |
| `p_report_list_mode` | Saved report tabs | `'TABS'`, `'NONE'` |
| `p_show_detail_link` | Show edit/detail link | `'Y'`, `'N'`, `'C'` (conditional) |
| `p_detail_link` | URL for row-level link | `'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_ROWID:#ROWID#'` |
| `p_detail_link_text` | HTML for link icon | pencil icon HTML |
| `p_download_formats` | Enabled downloads (colon-separated) | `'CSV:HTML'`, `'CSV:HTML:XLSX:PDF'` |
| `p_lazy_loading` | Lazy load data | `false` |
| `p_show_calendar` | Calendar view toggle | `'N'`, `'Y'` |
| `p_show_notify` | Notification bar | `'Y'` |
| `p_enable_mail_download` | Email download link | `'Y'` |
| `p_allow_save_rpt_public` | Users can save public reports | `'Y'`, `'N'` |
| `p_allow_report_categories` | Report category tabs | `'N'` |
| `p_allow_exclude_null_values` | Allow null exclusion filter | `'N'` |
| `p_allow_hide_extra_columns` | Allow hiding extra columns | `'N'` |
| `p_detail_view_enabled_yn` | Enable detail view | `'Y'`, `'N'` |

---

## Worksheet Columns (`create_worksheet_column`)

One `create_worksheet_column` per SELECT expression. The `p_db_column_name` must match
the alias in the SQL exactly (uppercase). Columns are ordered by `p_display_order`
and identified by `p_column_identifier` (A, B, C, ..., Z, AA, AB, ...).

### Text column (basic)

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

### Text column with link

```sql
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(2688317520315941471)
,p_db_column_name=>'PROJECT'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Project'
,p_column_link=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:RP,RIR,CIR:IR_PROJECT:#PROJECT#'
,p_column_linktext=>'#PROJECT#'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
```

### Text column with styled link (button-like)

```sql
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15775774067832505401)
,p_db_column_name=>'ROW_KEY'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'View'
,p_column_link=>'f?p=&APP_ID.:50:&SESSION.::&DEBUG.:50:P50_ID:#ID#'
,p_column_linktext=>'<span>#ROW_KEY#</span>'
,p_column_link_attr=>'class="t-Button t-Button--small t-Button--hot t-Button--simple t-Button--stretch"'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
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

### Number column with currency format

```sql
,p_format_mask=>'999G999G999G999G999G990D00'    -- includes 2 decimal places
```

### Date column (standard)

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

### Date column with SINCE format mask

```sql
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(3065080896984655798)
,p_db_column_name=>'START_DATE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'SINCE mask'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
```

### Date column with explicit format mask

```sql
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(3065080996714655798)
,p_db_column_name=>'END_DATE'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'DD-MON-YYYY mask'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
```

### Date column with timezone dependency

```sql
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(16910749277477969470)
,p_db_column_name=>'UPDATED'
,p_display_order=>15
,p_column_identifier=>'F'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'Y'                                  -- respects session timezone
,p_use_as_row_header=>'N'
);
```

### LOV column (named LOV)

Displays a stored value but shows a LOV display value. Uses `p_display_text_as=>'LOV_ESCAPE_SC'`
and references a named LOV via `p_rpt_named_lov`:

```sql
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(17163581381998874246)
,p_db_column_name=>'STRATEGIC_CUSTOMER_PROGRAM_YN'
,p_display_order=>91
,p_column_identifier=>'BC'
,p_column_label=>'SCP Customer'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'                   -- display from LOV, escape special chars
,p_heading_alignment=>'LEFT'
,p_rpt_named_lov=>wwv_flow_imp.id(17824313924399776811)  -- reference to shared LOV
,p_rpt_show_filter_lov=>'1'                            -- show LOV in filter
,p_use_as_row_header=>'N'
);
```

### LOV column (numeric value, named LOV)

```sql
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(18482284554807827285)
,p_db_column_name=>'PARENT_CUSTOMER_ID'
,p_display_order=>101
,p_column_identifier=>'BD'
,p_column_label=>'Parent'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_imp.id(16612806512673485470)
,p_rpt_show_filter_lov=>'1'
,p_use_as_row_header=>'N'
);
```

### Column with inline filter LOV (query-based)

The `p_rpt_lov` parameter provides a query whose results populate the filter dropdown
(distinct from named LOVs):

```sql
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15775773728643505399)
,p_db_column_name=>'TAGS'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_rpt_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select tag',
'  from eba_cust_tags_type_sum',
' where content_type = ''CUSTOMER''',
'   and tag_count > 0'))
,p_rpt_show_filter_lov=>'C'                            -- C = custom LOV for filter
,p_use_as_row_header=>'N'
);
```

### Hidden column (ID / ROWID)

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

### ROWID column (fully restricted)

ROWID columns disable all interactive features since ROWID is not a real data column:

```sql
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(2573321597912357032)
,p_db_column_name=>'ROWID'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Rowid'
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
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_rpt_show_filter_lov=>'N'
,p_use_as_row_header=>'N'
);
```

### Column with graph format mask

```sql
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(3065242823219700802)
,p_db_column_name=>'GRAPH'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'PCT_GRAPH mask'
,p_column_type=>'NUMBER'
,p_display_text_as=>'WITHOUT_MODIFICATION'             -- render raw HTML (bar graph)
,p_heading_alignment=>'LEFT'
,p_format_mask=>'PCT_GRAPH:CFDEF0:144485:150'          -- inline bar graph
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
```

### Column with build-option display condition

Conditionally show a column based on a build option:

```sql
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(15775771285869505395)
,p_db_column_name=>'REFERENCABLE'
,p_display_order=>3
,p_column_identifier=>'E'
,p_column_label=>'Publicly Referenceable'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_display_condition_type=>'EXPRESSION'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'APEX_UTIL.GET_BUILD_OPTION_STATUS(',
'    P_APPLICATION_ID => :APP_ID,',
'    P_BUILD_OPTION_NAME => ''Customer Referencability'') = ''INCLUDE'''))
,p_display_condition2=>'PLSQL'
,p_use_as_row_header=>'N'
);
```

### Key column parameters

| Parameter | Purpose | Common values |
|-----------|---------|---------------|
| `p_db_column_name` | Must match SQL alias (UPPER) | `'PROJECT'`, `'COST'`, `'ID'` |
| `p_display_order` | Column position | Sequential integers |
| `p_column_identifier` | Letter ID (A-Z, AA, AB...) | Must be unique per worksheet |
| `p_column_type` | Data type | `'STRING'`, `'NUMBER'`, `'DATE'`, `'OTHER'` |
| `p_display_text_as` | Display mode | `'HIDDEN'`, `'LOV_ESCAPE_SC'`, `'WITHOUT_MODIFICATION'` |
| `p_heading_alignment` | Header alignment | `'LEFT'`, `'RIGHT'` |
| `p_column_alignment` | Data alignment | `'LEFT'`, `'RIGHT'` (numbers use RIGHT) |
| `p_format_mask` | Oracle format mask | `'999G999G999G999G999G990'`, `'SINCE'`, `'DD-MON-YYYY'` |
| `p_column_link` | Click URL | `'f?p=&APP_ID.:50:&SESSION.::&DEBUG.:50:P50_ID:#ID#'` |
| `p_column_linktext` | Link display HTML | `'#PROJECT#'`, `'<img ...>'` |
| `p_column_link_attr` | Link HTML attributes | `'class="t-Button ..."'` |
| `p_tz_dependent` | Timezone aware | `'Y'`, `'N'` |
| `p_rpt_named_lov` | Named LOV reference | LOV ID |
| `p_rpt_lov` | Inline LOV query | SQL string |
| `p_rpt_show_filter_lov` | Filter LOV display | `'N'`, `'1'`, `'C'` |
| `p_allow_sorting` | Enable sort | `'Y'` (default), `'N'` |
| `p_allow_filtering` | Enable filter | `'Y'` (default), `'N'` |
| `p_display_condition_type` | Conditional display | `'EXPRESSION'`, `'FUNCTION_BODY'` |
| `p_display_condition` | Condition body | PL/SQL expression |
| `p_display_condition2` | Condition language | `'PLSQL'` |

---

## Saved Reports (`create_worksheet_rpt`)

Every IR needs at least one default report (`p_application_user=>'APXWS_DEFAULT'`).
Alternative/named reports use `p_application_user=>'APXWS_ALTERNATIVE'`.

### Default report (minimal)

```sql
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(17828789521693376779)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'9136221'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>15
,p_report_columns=>'ID:CATEGORY:DESCRIPTION:STATUS'
,p_sort_column_1=>'CATEGORY'
,p_sort_direction_1=>'ASC'
);
```

### Default report with sorting, aggregation, and display_rows

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

### Named saved report (alternative -- "Highlighted Over Budget")

```sql
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(2688377120709042831)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'Highlighted Over Budget'
,p_report_seq=>10
,p_report_type=>'REPORT'
,p_report_alias=>'20240823'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>15
,p_view_mode=>'REPORT'
,p_report_columns=>'PROJECT:TASK_NAME:START_DATE:END_DATE:STATUS:ASSIGNED_TO:COST:BUDGET:AVAILABLE_BUDGET:'
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

### Named saved report (alternative -- Pivot type)

```sql
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(2208823256981891629)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'Pivot Example'
,p_report_seq=>10
,p_report_type=>'PIVOT'
,p_report_alias=>'21844430'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>15
,p_view_mode=>'REPORT'
,p_report_columns=>'ID:PROJECT:TASK_NAME:START_DATE:END_DATE:STATUS:ASSIGNED_TO:COST:BUDGET:ROWID:AVAILABLE_BUDGET'
,p_sort_column_1=>'START_DATE'
,p_sort_direction_1=>'ASC'
,p_sum_columns_on_break=>'COST:BUDGET'
);
```

### Named saved report (alternative -- Chart type with break and computation)

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

### Named saved report (alternative -- "SORT_BY_UPD")

From a different app, showing a sort-by-updated pattern:

```sql
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(2068320823293009148)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'SORT_BY_UPD'
,p_report_seq=>10
,p_report_alias=>'20424235'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CUSTOMER_NAME:SUMMARY:REFERENCABLE:REFERENCABILITY:GEOGRAPHY_NAME:UPDATED::DISCOUNT_LEVEL:TOTAL_CONTRACT_VALUE:ACTIVITIES'
,p_sort_column_1=>'UPDATED'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'CUSTOMER_NAME'
,p_sort_direction_2=>'ASC'
);
```

### Key saved report parameters

| Parameter | Purpose | Common values |
|-----------|---------|---------------|
| `p_application_user` | Report ownership | `'APXWS_DEFAULT'`, `'APXWS_ALTERNATIVE'` |
| `p_name` | Display name (alternative only) | `'Budget Review'`, `'Highlighted Over Budget'` |
| `p_report_seq` | Display order | `10` |
| `p_report_type` | Report view type | `'REPORT'`, `'CHART'`, `'PIVOT'` |
| `p_report_alias` | Unique alias for URL reference | Numeric string, must be unique per app |
| `p_status` | Visibility | `'PUBLIC'`, `'PRIVATE'` |
| `p_is_default` | Default for its type | `'Y'` |
| `p_display_rows` | Rows per page | `5`, `15` |
| `p_view_mode` | Active view | `'REPORT'` |
| `p_report_columns` | Colon-separated column list | `'PROJECT:TASK_NAME:STATUS:COST'` |
| `p_sort_column_N` | Sort column (1-6) | Column name or `'0'` (none) |
| `p_sort_direction_N` | Sort direction (1-6) | `'ASC'`, `'DESC'` |
| `p_sum_columns_on_break` | Columns to aggregate on break | `'COST:BUDGET'` |
| `p_break_on` | Break column | Column name |
| `p_chart_type` | Chart type (when CHART) | `'bar'` |
| `p_chart_orientation` | Chart orientation | `'horizontal'`, `'vertical'` |

---

## Worksheet Conditions (`create_worksheet_condition`)

Conditions attach to a saved report and define either a filter or a highlight rule.

### FILTER condition (numeric comparison)

```sql
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(1341623723748318835)
,p_report_id=>wwv_flow_imp.id(1321203601142048986)   -- references a saved report
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

### FILTER condition (string equality)

```sql
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(1341623925400318835)
,p_report_id=>wwv_flow_imp.id(1321203601142048986)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS'
,p_operator=>'='
,p_expr=>'Closed'
,p_condition_sql=>'"STATUS" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''Closed''  '
,p_enabled=>'Y'
);
```

### HIGHLIGHT condition (row background color)

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
,p_row_bg_color=>'#FFFF99'                             -- yellow row background
);
```

### HIGHLIGHT condition (column background color)

```sql
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(2688340517986981378)
,p_report_id=>wwv_flow_imp.id(2688318719703941473)
,p_name=>'Expensive Projects'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'TOTAL_COST'
,p_operator=>'>'
,p_expr=>'5000'
,p_condition_sql=>' (case when ("TOTAL_COST" > to_number(#APXWS_EXPR#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# > #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFFF99'                          -- yellow column cell only
);
```

### Key condition parameters

| Parameter | Purpose | Values |
|-----------|---------|--------|
| `p_report_id` | Parent saved report | Must reference a `create_worksheet_rpt` ID |
| `p_condition_type` | Rule type | `'FILTER'`, `'HIGHLIGHT'` |
| `p_name` | Display name (highlights) | e.g. `'Over Budget'` |
| `p_column_name` | Target column (UPPER) | e.g. `'TOTAL_COST'` |
| `p_operator` | Comparison operator | `'>'`, `'<'`, `'='`, `'>='`, `'<='`, `'!='`, `'like'`, `'not like'` |
| `p_expr` | Comparison value | `'0'`, `'5000'`, `'Closed'` |
| `p_condition_sql` | Generated SQL (read-only pattern) | Uses `#APXWS_EXPR#`, `#APXWS_HL_ID#` |
| `p_condition_display` | UI display string | Uses `#APXWS_COL_NAME#`, `#APXWS_EXPR_NUMBER#` |
| `p_enabled` | Active state | `'Y'`, `'N'` |
| `p_highlight_sequence` | Order among highlights | `10`, `20`, ... |
| `p_row_bg_color` | Row background (highlight) | Hex color `'#FFFF99'`, `'#FF7755'` |
| `p_column_bg_color` | Column background (highlight) | Hex color `'#FFFF99'` |
| `p_allow_delete` | User can remove | `'Y'` |

---

## Worksheet Computations (`create_worksheet_computation`)

Computed columns are defined per-saved-report and reference column identifiers in formulas:

```sql
wwv_flow_imp_page.create_worksheet_computation(
 p_id=>wwv_flow_imp.id(2688377703525047381)
,p_report_id=>wwv_flow_imp.id(2573520297922432804)    -- parent saved report
,p_db_column_name=>'APXWS_CC_001'                     -- auto-generated name
,p_column_identifier=>'C01'
,p_computation_expr=>'I - H'                           -- I=Budget, H=Cost (by column_identifier)
,p_format_mask=>'FML999G999G999G999G990D00'
,p_column_type=>'NUMBER'
,p_column_label=>'Budget v Cost'
,p_report_label=>'Budget v Cost'
);
```

## Worksheet Group By (`create_worksheet_group_by`)

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

## Worksheet Pivot (`create_worksheet_pivot`)

```sql
wwv_flow_imp_page.create_worksheet_pivot(
 p_id=>wwv_flow_imp.id(2208823641525891634)
,p_report_id=>wwv_flow_imp.id(2208823256981891629)    -- parent pivot report
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

---

## Search Bar Configuration

The IR search bar is built into the region template. Buttons are placed using
`p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'`:

### Reset button (standard pattern)

```sql
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(2666884304101194851)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(2573278322369354707)  -- parent IR region
,p_button_name=>'RESET_DATA'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>2349107722467437027               -- icon-only button template
,p_button_image_alt=>'Reset'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:RP,1,RIR::'
,p_icon_css_classes=>'fa-undo-alt'
);
```

### Create button in search bar

```sql
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(17822239508262308645)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(17828788545707373225)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091               -- text button template
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Category'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:4::'
);
```

### Reset URL pattern

The reset URL uses APEX clear-cache notation:

```
f?p=&APP_ID.:<PAGE>:&SESSION.::&DEBUG.:RP,<PAGE>,RIR::
```

- `RP` -- Reset Pagination
- `RIR` -- Reset Interactive Report
- `CIR` -- Clear Interactive Report (used in column links)

---

## Common Dynamic Actions for IR

### Refresh on dialog close

```sql
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(223926222511124448)
,p_name=>'Refresh on Edit'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(2573278322369354707)  -- IR region
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

### Refresh on dialog close with success message (modal pattern)

```sql
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(1639518186362779826)
,p_name=>'Refresh Report'
,p_event_sequence=>10
,p_triggering_element_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_element=>'window'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(1639518524394779834)
-- ... NATIVE_REFRESH on region ...
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(1639519026177779834)
,p_event_id=>wwv_flow_imp.id(1639518186362779826)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.message.showPageSuccess(''Action Processed.'');'
);
```

---

## Common Patterns and Conventions

### Column alignment conventions
- **STRING** columns: `p_heading_alignment=>'LEFT'` (no `p_column_alignment` needed -- defaults LEFT)
- **NUMBER** columns: `p_heading_alignment=>'RIGHT'`, `p_column_alignment=>'RIGHT'`
- **DATE** columns: `p_heading_alignment=>'LEFT'`

### Standard number format masks
- Integer: `'999G999G999G999G999G990'`
- Decimal: `'999G999G999G999G999G990D00'`
- Currency: `'FML999G999G999G999G990D00'`
- Graph: `'PCT_GRAPH:CFDEF0:144485:150'`

### Standard date format masks
- Relative: `'SINCE'` (e.g. "3 days ago")
- Explicit: `'DD-MON-YYYY'`

### Default column settings
- `p_tz_dependent=>'N'` unless DATE with timezone awareness needed
- `p_use_as_row_header=>'N'` for all non-header columns
- `p_allow_report_categories=>'N'` (almost always disabled)

### Search bar buttons
- Position: `p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'`
- Reset button is nearly universal, uses icon-only template with `fa-undo-alt`
- Create/Add button is common on lookup/admin pages

### Pagination
- Default: `p_pagination_type=>'ROWS_X_TO_Y'`
- Display: `p_pagination_display_pos=>'BOTTOM_RIGHT'`
- Rows per page: `5` (dense pages), `15` (standard)

### Report list modes
- `'TABS'` -- show saved report tabs (when multiple reports exist)
- `'NONE'` -- hide tabs (when only one report or IR used in multi-view pages)

### p_report_columns order
The colon-separated list in `p_report_columns` controls which columns appear and in what order.
Use `::` (empty entry) to include a gap/separator. Omit a column name to hide it from the view.

### Sort columns
- Up to 6 sort columns (`p_sort_column_1` through `p_sort_column_6`)
- Use `'0'` as column name to indicate "no sort" for unused slots
- Direction is always `'ASC'` or `'DESC'`

### Column link URL patterns
- Edit link: `'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_ROWID:#ROWID#'`
- View link: `'f?p=&APP_ID.:50:&SESSION.::&DEBUG.:50:P50_ID:#ID#'`
- IR filter link: `'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:RP,RIR,CIR:IR_PROJECT:#PROJECT#'`
  - `IR_<COLUMN>` sets the IR filter for that column

### Nesting IR inside container regions
IRs are often nested inside a container region for layout:
- Parent: `p_plug_template=>4072358936313175081` (Standard Region)
- IR child uses `p_plug_display_point=>'SUB_REGIONS'`
- Parent options include `t-Region--noPadding:t-Region--removeHeader`
