# Classic Report (`NATIVE_SQL_REPORT`)

Classic reports use `create_report_region` (wrapper around `create_page_plug`) with `p_source_type=>'NATIVE_SQL_REPORT'`. Each column is declared via `create_report_columns`.

## Report Region

### SQL query source

```sql
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(2681613203969354879)
,p_name=>'Classic Report'
,p_region_name=>'classic_report'
,p_template=>4072358936313175081
,p_display_sequence=>30
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody:t-Region--noBorder:t-Region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select rowid,',
'       ID,',
'       PROJECT,',
'       TASK_NAME,',
'       START_DATE,',
'       END_DATE,',
'       STATUS,',
'       ASSIGNED_TO,',
'       COST,',
'       BUDGET',
'from EBA_DEMO_IR_PROJECTS',
'where (nvl(:P3_STATUS,''0'') = ''0'' or :P3_STATUS = status)'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P3_STATUS'
,p_fixed_header=>'NONE'
,p_lazy_loading=>false
,p_query_row_template=>2538654340625403440
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No data found.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_query_row_count_max=>500
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_query_asc_image=>'apex/builder/dup.gif'
,p_query_asc_image_attr=>'width="16" height="16" alt="" '
,p_query_desc_image=>'apex/builder/ddown.gif'
,p_query_desc_image_attr=>'width="16" height="16" alt="" '
,p_plug_query_strip_html=>'Y'
);
```

| Parameter | Purpose | Values |
|---|---|---|
| `p_source_type` | Region type | `'NATIVE_SQL_REPORT'` |
| `p_query_type` | Source mode | `'SQL'` or `'TABLE'` |
| `p_source` | SQL query (when SQL) | `wwv_flow_string.join(...)` |
| `p_query_row_template` | Row template ID | Controls tabular vs non-tabular |
| `p_query_num_rows` | Rows per page | `4`, `15`, `50`, `150` |
| `p_query_options` | Column derivation | `'DERIVED_REPORT_COLUMNS'` |
| `p_query_no_data_found` | Empty message | `'No data found.'` |
| `p_query_show_nulls_as` | NULL display | `' - '` |
| `p_ajax_enabled` | Partial refresh | `'Y'` |
| `p_ajax_items_to_submit` | Items on AJAX | `'P3_STATUS'` |
| `p_lazy_loading` | Deferred load | `false` |
| `p_fixed_header` | Fixed header | `'NONE'` |
| `p_csv_output` | CSV download | `'N'`, `'Y'` |
| `p_prn_output` | Print output | `'N'`, `'Y'` |
| `p_sort_null` | Nulls sort | `'L'` (last) |
| `p_plug_query_strip_html` | Strip HTML | `'Y'` |
| `p_query_row_count_max` | Max row count | `500`, `5000`, `100000` |
| `p_region_name` | Static ID for DAs | `'classic_report'` |

### TABLE source

```sql
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(624739556134135912)
,p_name=>'Search Results'
,p_template=>4072358936313175081
,p_display_sequence=>30
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader js-addHiddenHeadingRoleDesc:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--staticRowColors:t-Report--rowHighlight:t-Report--inline:t-Report--hideNoPagination'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'EBA_DEMO_IR_PROJECTS'
,p_include_rowid_column=>true
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>2538654340625403440
,p_query_num_rows=>50
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_query_row_count_max=>100000
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_prn_format=>'PDF'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
```

TABLE-specific: `p_query_table` (table/view name), `p_include_rowid_column` (`true`/`false`).

## Report Columns (`create_report_columns`)

Each column gets its own call. `p_query_column_id` = ordinal position in SELECT (1-based).

### Text column

```sql
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(2681613722113354887)
,p_query_column_id=>3
,p_column_alias=>'PROJECT'
,p_column_display_sequence=>2
,p_column_heading=>'Project'
,p_heading_alignment=>'LEFT'
,p_default_sort_column_sequence=>1
,p_disable_sort_column=>'N'
);
```

| Parameter | Purpose | Values |
|---|---|---|
| `p_query_column_id` | SELECT ordinal (1-based) | Integer |
| `p_column_alias` | Must match SQL alias | `'PROJECT'` |
| `p_column_display_sequence` | Display order | Integer |
| `p_column_heading` | Header text | String |
| `p_heading_alignment` | Header align | `'LEFT'`, `'CENTER'`, `'RIGHT'` |
| `p_column_alignment` | Data align | `'LEFT'`, `'CENTER'`, `'RIGHT'` |
| `p_default_sort_column_sequence` | Sort priority | Integer |
| `p_disable_sort_column` | Disable sort | `'N'`, `'Y'` |
| `p_hidden_column` | Hide column | `'Y'` |
| `p_derived_column` | Non-DB column | `'N'` |
| `p_include_in_export` | In CSV/PDF | `'Y'`, `'N'` |

### Number column

```sql
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(2681614297399354887)
,p_query_column_id=>9
,p_column_alias=>'COST'
,p_column_display_sequence=>8
,p_column_heading=>'Cost'
,p_column_format=>'999G999G999G999G999G990'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_lov_show_nulls=>'NO'
,p_lov_display_extra=>'YES'
,p_include_in_export=>'Y'
);
```

Formats: `999G999G999G999G999G990` (int), `999G999G999G990D00` (decimal), `FML999G999G999G990D00` (currency).

### Date column

```sql
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(14955849022329317368)
,p_query_column_id=>3
,p_column_alias=>'VALIDATION_DATE'
,p_column_display_sequence=>3
,p_column_heading=>'Validation Date'
,p_column_format=>'DD-MON-YYYY'
,p_heading_alignment=>'LEFT'
,p_lov_show_nulls=>'NO'
,p_lov_display_extra=>'YES'
,p_include_in_export=>'Y'
);
```

Formats: `DD-MON-YYYY`, `DD-MON-YYYY HH24:MI`, `YYYY-MM-DD`.

**SINCE format** with HTML expression:
```sql
,p_column_format=>'SINCE'
,p_column_html_expression=>'#CREATED# &middot; #CREATED_BY#'
```

### Link column

```sql
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(2681613812041354887)
,p_query_column_id=>4
,p_column_alias=>'TASK_NAME'
,p_column_display_sequence=>3
,p_column_heading=>'Task'
,p_column_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_ROWID:#ROWID#'
,p_column_linktext=>'#TASK_NAME#'
,p_heading_alignment=>'LEFT'
,p_default_sort_column_sequence=>2
,p_disable_sort_column=>'N'
,p_lov_show_nulls=>'NO'
,p_lov_display_extra=>'YES'
,p_include_in_export=>'Y'
);
```

URL format: `f?p=&APP_ID.:PAGE:&SESSION.::&DEBUG.:CLEAR_CACHE:ITEM_NAMES:ITEM_VALUES`
`#COLUMN_ALIAS#` substitutes column values.

### Edit-pencil icon link

```sql
,p_column_link=>'f?p=&APP_ID.:129:&SESSION.::&DEBUG.:129:P129_ID:#ID#'
,p_column_linktext=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="Edit #NAME#">'
```

**Visually-hidden heading**: `p_column_heading=>'<span class="u-VisuallyHidden">Edit</span>'`

### External link

```sql
,p_column_link=>'#WEBSITE#'
,p_column_linktext=>'#WEBSITE#'
,p_column_link_attr=>'target="_blank"'
```

### Hidden column

```sql
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(2685233496526389435)
,p_query_column_id=>1
,p_column_alias=>'ROWID'
,p_column_display_sequence=>10
,p_column_heading=>'ROWID'
,p_heading_alignment=>'LEFT'
,p_hidden_column=>'Y'
);
```

Conditionally hidden: `p_display_when_cond_type=>'NEVER'`

### LOV display (`TEXT_FROM_LOV_ESC`)

```sql
,p_display_as=>'TEXT_FROM_LOV_ESC'
,p_named_lov=>wwv_flow_imp.id(14886691626023863631)
```

### Unescaped HTML (`WITHOUT_MODIFICATION`)

```sql
,p_display_as=>'WITHOUT_MODIFICATION'
```

### HTML expression

```sql
,p_column_html_expression=>'#CREATED# &middot; #CREATED_BY#'
,p_column_html_expression=>'<a href="#PROFILE_URL#">#USER_NAME#</a>'
,p_column_html_expression=>'u-Color-#ICON_MODIFIER#-BG--txt u-Color-#ICON_MODIFIER#-FG--bg'
```

### Conditional display

```sql
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select null',
'from eba_cust_customers c',
'where c.id = :P50_ID',
'    and c.parent_customer_id is not null'))
```

Values: `'EXISTS'` (SQL returns rows), `'NEVER'` (always hidden).

### Column width

```sql
,p_report_column_width=>16
```

## Pagination

Default: `p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'`, `p_pagination_display_position=>'BOTTOM_RIGHT'`.

**Dynamic rows via item**: `p_query_num_rows_item=>'P5_ROWS'`

**Large results**: `p_query_num_rows=>150`, `p_query_row_count_max=>5000`

## Region Template Options

| Option | Effect |
|---|---|
| `t-Region--noPadding` | No padding |
| `t-Region--scrollBody` | Scrollable body |
| `t-Region--noBorder` | No border |
| `t-Region--hideHeader js-addHiddenHeadingRoleDesc` | Hidden header with ARIA |
| `t-Region--hiddenOverflow` | Clip overflow |
| `js-showMaximizeButton` | Maximize button |

## Component (Report) Template Options

| Option | Effect |
|---|---|
| `t-Report--stretch` | Full width |
| `t-Report--altRowsDefault` | Alternating rows |
| `t-Report--rowHighlight` | Hover highlight |
| `t-Report--staticRowColors` | No alternating |
| `t-Report--noBorders` | No cell borders |
| `t-Report--inline` | Compact display |
| `t-Report--hideNoPagination` | Hide single-page pagination |

AVP List: `t-AVPList--leftAligned`, `t-AVPList--fixedLabelSmall:t-AVPList--leftAligned`
Comments: `t-Comments--chat`

## Non-Tabular Report Templates

### Comments / Chat Template

Column aliases must match template slots: `COMMENT_TEXT`, `USER_NAME`, `COMMENT_DATE`, `ATTRIBUTE_1`..`4`, `ICON_MODIFIER`, `USER_ICON`, `ACTIONS`, `COMMENT_MODIFIERS`.

```sql
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(3174551915918794885)
,p_name=>'Comment Bubbles'
,p_region_name=>'comment_bubbles'
,p_template=>4072358936313175081
,p_display_sequence=>30
,p_region_template_options=>'#DEFAULT#:t-Region--hideHeader js-addHiddenHeadingRoleDesc:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Comments--chat'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select null class,',
'    ''fa fa-user'' icon_modifier,',
'    null user_icon,',
'    ''Project: ''||PROJECT comment_text,',
'    ''<br>Task: ''||apex_escape.html(TASK_NAME) attribute_1,',
'    ''<br>Status: ''||apex_escape.html(Status) attribute_2,',
'    null attribute_3,',
'    null attribute_4,',
'    ASSIGNED_TO user_name,',
'    apex_util.get_since(START_DATE) as comment_date,',
'    null actions',
'from EBA_DEMO_IR_PROJECTS',
'where (nvl(:P13_STATUS,''0'') = ''0'' or :P13_STATUS = status)'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>2613168815517880001
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No data found.'
,p_query_num_rows_item=>'P13_ROWS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'Y'
);
```

Columns with embedded HTML use `p_display_as=>'WITHOUT_MODIFICATION'`.

### AVP List

```sql
,p_component_template_options=>'#DEFAULT#:t-AVPList--leftAligned'
,p_query_row_template=>2100515439059797523
```

## Conditional Region Display

**EXISTS**: `p_display_condition_type=>'EXISTS'`, `p_display_when_condition=>'select null from ... where ...'`
**Item value**: `p_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'`, `p_display_when_condition=>'P27_FUNCTION'`, `p_display_when_cond2=>'SUBSTR'`
**Build option**: `p_required_patch=>wwv_flow_imp.id(...)`

## AJAX / Partial Page Refresh

Enable: `p_ajax_enabled=>'Y'`
Submit items: `p_ajax_items_to_submit=>'P3_STATUS'`

### Refresh via DA (item change)

```sql
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(2148373988059376889)
,p_name=>'Refresh Report'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P3_STATUS'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(2148374082922376890)
,p_event_id=>wwv_flow_imp.id(2148373988059376889)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(2681613203969354879)
,p_attribute_01=>'N'
);
```

### Refresh after dialog close

```sql
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(223925996987124446)
,p_name=>'Refresh on Edit'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(2681613203969354879)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
```

## Required Parameters

**`create_report_region`**: `p_id`, `p_name`, `p_source_type` (`'NATIVE_SQL_REPORT'`), `p_query_type`, `p_source` or `p_query_table`, `p_template`, `p_display_sequence`, `p_query_row_template`, `p_query_options` (`'DERIVED_REPORT_COLUMNS'`).

**`create_report_columns`**: `p_id`, `p_query_column_id`, `p_column_alias`, `p_column_display_sequence`.
