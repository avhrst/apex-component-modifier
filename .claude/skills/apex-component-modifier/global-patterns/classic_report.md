# Classic Report (`NATIVE_SQL_REPORT`)

Classic report regions use `create_report_region` (a convenience wrapper around `create_page_plug`)
with `p_source_type=>'NATIVE_SQL_REPORT'`.  Each visible column is declared via a separate
`create_report_columns` call keyed to the same region.

> **Source apps**: App 103 (Sample Reporting) and App 104 (Customers).

---

## Table of Contents

- [Report Region](#report-region)
  - [SQL query source](#sql-query-source)
  - [TABLE source](#table-source)
- [Report Columns (`create_report_columns`)](#report-columns-create_report_columns)
  - [Text column](#text-column)
  - [Number column with format mask](#number-column-with-format-mask)
  - [Date column with format mask](#date-column-with-format-mask)
  - [Date column with SINCE format](#date-column-with-since-format)
  - [Link column](#link-column)
  - [Edit-pencil icon link column](#edit-pencil-icon-link-column)
  - [External link column](#external-link-column)
  - [Hidden column](#hidden-column)
  - [LOV display column (`TEXT_FROM_LOV_ESC`)](#lov-display-column-text_from_lov_esc)
  - [Unescaped HTML column (`WITHOUT_MODIFICATION`)](#unescaped-html-column-without_modification)
  - [Column with HTML expression](#column-with-html-expression)
  - [Column with conditional display](#column-with-conditional-display)
- [Column Formatting](#column-formatting)
- [Pagination](#pagination)
- [Region Template Options](#region-template-options)
- [Component (Report) Template Options](#component-report-template-options)
- [Non-Tabular Report Templates](#non-tabular-report-templates)
- [Conditional Region Display](#conditional-region-display)
- [AJAX / Partial Page Refresh](#ajax--partial-page-refresh)
- [Common Patterns](#common-patterns)

---

## Report Region

### SQL query source

The most common form.  `p_query_type=>'SQL'` with the query in `p_source`.

```sql
-- From App 103, Page 3 ("Classic Report")
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

**Key parameters:**

| Parameter | Purpose | Common values |
|-----------|---------|---------------|
| `p_source_type` | Region type | `'NATIVE_SQL_REPORT'` |
| `p_query_type` | How the query is provided | `'SQL'` or `'TABLE'` |
| `p_source` | The SQL query (when `p_query_type=>'SQL'`) | Wrapped in `wwv_flow_string.join(wwv_flow_t_varchar2(...))` |
| `p_query_row_template` | Row template ID (controls tabular vs non-tabular layout) | Numeric template ID |
| `p_query_num_rows` | Rows per page | `4`, `15`, `50`, `150` |
| `p_query_options` | Column derivation mode | `'DERIVED_REPORT_COLUMNS'` |
| `p_query_no_data_found` | Message when zero rows | `'No data found.'`, `'no data found'` |
| `p_query_show_nulls_as` | Display for NULL values | `' - '`, `'-'` |
| `p_ajax_enabled` | Enable partial page refresh | `'Y'` |
| `p_ajax_items_to_submit` | Page items sent on AJAX refresh | `'P3_STATUS'` |
| `p_lazy_loading` | Deferred loading | `false` |
| `p_fixed_header` | Fixed header mode | `'NONE'` |
| `p_csv_output` | Allow CSV download | `'N'`, `'Y'` |
| `p_prn_output` | Allow print output | `'N'`, `'Y'` |
| `p_sort_null` | Nulls sort position | `'L'` (last) |
| `p_plug_query_strip_html` | Strip HTML from column data | `'Y'` or `'N'` |
| `p_query_row_count_max` | Maximum row count for pagination | `500`, `5000`, `100000` |
| `p_region_name` | Static region ID (for DA targeting) | `'classic_report'` |

### TABLE source

When `p_query_type=>'TABLE'`, APEX generates the query from a table name.

```sql
-- From App 103, Page 42 ("Faceted Search" results)
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

**TABLE-specific parameters:**

| Parameter | Purpose |
|-----------|---------|
| `p_query_table` | Table or view name |
| `p_include_rowid_column` | Include ROWID as a column (`true`/`false`) |

---

## Report Columns (`create_report_columns`)

Each column in the report gets its own `create_report_columns` call.  The `p_query_column_id`
corresponds to the ordinal position of the column in the SELECT list (1-based).

### Text column

Basic visible text column with sorting enabled.

```sql
-- From App 103, Page 3
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

**Key column parameters:**

| Parameter | Purpose | Values |
|-----------|---------|--------|
| `p_query_column_id` | Ordinal position in SELECT (1-based) | Integer |
| `p_column_alias` | Column alias (must match SQL alias) | `'PROJECT'` |
| `p_column_display_sequence` | Display order in rendered report | Integer |
| `p_column_heading` | Column header text | Any string |
| `p_heading_alignment` | Header text alignment | `'LEFT'`, `'CENTER'`, `'RIGHT'` |
| `p_column_alignment` | Data cell alignment | `'LEFT'`, `'CENTER'`, `'RIGHT'` |
| `p_default_sort_column_sequence` | Default sort priority (1 = primary) | Integer |
| `p_disable_sort_column` | Disable user sorting | `'N'` (sortable), `'Y'` (not sortable) |
| `p_hidden_column` | Hide the column | `'Y'` |
| `p_derived_column` | Mark as derived (non-DB) column | `'N'` |
| `p_include_in_export` | Include in CSV/PDF export | `'Y'`, `'N'` |

### Number column with format mask

Right-aligned with a numeric format mask for thousands separators.

```sql
-- From App 103, Page 3
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

Common numeric format masks:
- `999G999G999G999G999G990` -- integer with grouping separators
- `999G999G999G990D00` -- decimal with 2 places
- `FML999G999G999G990D00` -- currency with locale symbol

### Date column with format mask

```sql
-- From App 104, Page 50 (Customer Validations)
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

Common date format masks:
- `DD-MON-YYYY` -- `26-FEB-2026`
- `DD-MON-YYYY HH24:MI` -- with time
- `YYYY-MM-DD` -- ISO format

### Date column with SINCE format

The special `SINCE` format mask renders dates as relative time ("3 hours ago", "2 days ago").

```sql
-- From App 104, Page 50 (Customer Validations)
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(14955909418430914937)
,p_query_column_id=>2
,p_column_alias=>'LAST_VALIDATED'
,p_column_display_sequence=>2
,p_column_heading=>'Last Validated'
,p_column_format=>'since'
,p_heading_alignment=>'LEFT'
,p_lov_show_nulls=>'NO'
,p_lov_display_extra=>'YES'
,p_include_in_export=>'Y'
);
```

SINCE format is often combined with an HTML expression to show "3 hours ago by jsmith":

```sql
-- From App 104, Page 50 (Attachments region)
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(16444540717708365838)
,p_query_column_id=>8
,p_column_alias=>'CREATED'
,p_column_display_sequence=>6
,p_column_heading=>'Added'
,p_column_format=>'SINCE'
,p_column_html_expression=>'#CREATED# &middot; #CREATED_BY#'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
```

### Link column

Column value rendered as a clickable link.  Uses `p_column_link` for the URL and
`p_column_linktext` for the displayed text.

```sql
-- From App 103, Page 3 (TASK_NAME links to edit page)
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

**Link URL format** (`f?p=` syntax):
```
f?p=&APP_ID.:PAGE:&SESSION.::&DEBUG.:CLEAR_CACHE:ITEM_NAMES:ITEM_VALUES
```
- `#COLUMN_ALIAS#` substitutes column values in the URL and link text.
- `&APP_ID.`, `&SESSION.`, `&DEBUG.` are standard APEX substitution strings.

### Edit-pencil icon link column

A common pattern uses an image icon as the link text for an edit action.

```sql
-- From App 104, Page 50 (Issues region - edit icon)
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(2336974666107137650)
,p_query_column_id=>1
,p_column_alias=>'ID'
,p_column_display_sequence=>1
,p_column_link=>'f?p=&APP_ID.:129:&SESSION.::&DEBUG.:129:P129_ID:#ID#'
,p_column_linktext=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="Edit #NAME#">'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
```

Visually-hidden heading variant:

```sql
-- From App 104, Page 50 (Partners region)
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(15670852303141287290)
,p_query_column_id=>1
,p_column_alias=>'ID'
,p_column_display_sequence=>3
,p_column_heading=>'<span class="u-VisuallyHidden">Edit</span>'
,p_column_link=>'f?p=&APP_ID.:110:&SESSION.::&DEBUG.:RP,110:P110_CUSTOMER_ID:&P50_ID.'
,p_column_linktext=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="Edit #PARTNER_NAME#">'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
```

### External link column

Open link in a new tab using `p_column_link_attr`.

```sql
-- From App 104, Page 50 (Partners - website link)
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(15670852494135287292)
,p_query_column_id=>3
,p_column_alias=>'WEBSITE'
,p_column_display_sequence=>5
,p_column_heading=>'Website'
,p_column_link=>'#WEBSITE#'
,p_column_linktext=>'#WEBSITE#'
,p_column_link_attr=>'target="_blank"'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
```

### Hidden column

Columns needed for link substitutions or conditional logic but not displayed to users.

```sql
-- From App 103, Page 3
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

Columns can also be conditionally hidden with `p_display_when_cond_type=>'NEVER'`:

```sql
-- From App 104, Page 50 (Partners - ADDED_BY hidden)
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(15670851533108287282)
,p_query_column_id=>6
,p_column_alias=>'ADDED_BY'
,p_column_display_sequence=>8
,p_column_heading=>'Added By'
,p_heading_alignment=>'LEFT'
,p_display_when_cond_type=>'NEVER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
```

### LOV display column (`TEXT_FROM_LOV_ESC`)

Displays the LOV display value instead of the stored ID.  The `p_named_lov` reference points
to a shared LOV component.

```sql
-- From App 104, Page 50 (Details region - STATUS_ID)
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1129251728330395615)
,p_query_column_id=>2
,p_column_alias=>'STATUS_ID'
,p_column_display_sequence=>1
,p_column_heading=>'Status'
,p_disable_sort_column=>'N'
,p_display_as=>'TEXT_FROM_LOV_ESC'
,p_named_lov=>wwv_flow_imp.id(14886691626023863631)
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
```

### Unescaped HTML column (`WITHOUT_MODIFICATION`)

When the SQL query constructs HTML (e.g., download links), use `p_display_as=>'WITHOUT_MODIFICATION'`
to render it unescaped.

```sql
-- From App 104, Page 50 (Attachments - FILE_NAME with embedded <a href>)
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(16444541206391365838)
,p_query_column_id=>2
,p_column_alias=>'FILE_NAME'
,p_column_display_sequence=>3
,p_column_heading=>'Name'
,p_heading_alignment=>'LEFT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_lov_show_nulls=>'NO'
,p_include_in_export=>'Y'
);
```

### Column with HTML expression

`p_column_html_expression` renders custom HTML with column substitution tokens.  The column
value is available as `#COLUMN_ALIAS#` and you can reference other columns from the same row.

```sql
-- From App 104, Page 50 (Issues - UPDATED combines timestamp + author)
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(2588031610321015805)
,p_query_column_id=>8
,p_column_alias=>'UPDATED'
,p_column_display_sequence=>9
,p_column_heading=>'Updated'
,p_column_format=>'SINCE'
,p_column_html_expression=>'#UPDATED# &bull; #UPDATED_BY#'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
```

```sql
-- From App 104, Page 117 (Change Log - ICON_MODIFIER for color-coded avatars)
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(17971599919782913915)
,p_query_column_id=>10
,p_column_alias=>'ICON_MODIFIER'
,p_column_display_sequence=>10
,p_column_heading=>'Icon Modifier'
,p_column_html_expression=>'u-Color-#ICON_MODIFIER#-BG--txt u-Color-#ICON_MODIFIER#-FG--bg'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
```

```sql
-- From App 104, Page 117 (Change Log - USER_NAME with profile link)
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(17971599100232913913)
,p_query_column_id=>8
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>8
,p_column_heading=>'User Name'
,p_column_html_expression=>'<a href="#PROFILE_URL#">#USER_NAME#</a>'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
```

### Column with conditional display

Columns can be conditionally displayed using `p_display_when_cond_type` and
`p_display_when_condition`.

```sql
-- From App 104, Page 50 (Details - PARENT_CUSTOMER_ID shown only when parent exists)
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(1171443864269198904)
,p_query_column_id=>3
,p_column_alias=>'PARENT_CUSTOMER_ID'
,p_column_display_sequence=>6
,p_column_heading=>'Parent'
,p_column_link=>'f?p=&APP_ID.:50:&SESSION.::&DEBUG.:RP,50:P50_ID:#PARENT_CUSTOMER_ID#'
,p_column_linktext=>'#PARENT_CUSTOMER#'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_display_when_cond_type=>'EXISTS'
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select null',
'from eba_cust_customers c',
'where c.id = :P50_ID',
'    and c.parent_customer_id is not null'))
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
```

Common `p_display_when_cond_type` values:
- `'EXISTS'` -- column shows when the SQL in `p_display_when_condition` returns rows
- `'NEVER'` -- column is unconditionally hidden (but still available for substitution)

---

## Column Formatting

### CSS classes

Applied via `p_region_css_classes` and `p_region_sub_css_classes` on the region:

```sql
-- Region-level CSS classes (from App 104, Page 50)
,p_region_css_classes=>'js-dynamicHideShowRegion'
,p_region_sub_css_classes=>'t-Report--cleanBorders'
```

### HTML expressions

The `p_column_html_expression` parameter accepts HTML with `#COLUMN_ALIAS#` substitution:

```sql
-- Combine SINCE-formatted date with user name
,p_column_html_expression=>'#CREATED# &middot; #CREATED_BY#'

-- Render file-type icon
,p_column_html_expression=>'<img src="#IMAGE_PREFIX#f_spacer.gif" alt="" class="#FILE_TYPE#" />'

-- Profile link with substitution
,p_column_html_expression=>'<a href="#PROFILE_URL#">#USER_NAME#</a>'
```

### Column alignment

```sql
-- Right-aligned numeric/date columns
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'

-- Left-aligned text (default)
,p_heading_alignment=>'LEFT'
```

### Column width

```sql
-- Fixed column width in pixels
,p_report_column_width=>16
```

### Static IDs

Region-level static IDs for JavaScript/Dynamic Action targeting:

```sql
,p_region_name=>'classic_report'     -- on the region
,p_region_name=>'rptIssues'          -- on the region
,p_region_name=>'projectChangeLog'   -- on the region
```

---

## Pagination

### NEXT_PREVIOUS_LINKS

The default pagination style.  Shows "Previous" / "Next" navigation.

```sql
,p_query_num_rows=>15
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_query_row_count_max=>500
,p_pagination_display_position=>'BOTTOM_RIGHT'
```

### Dynamic rows-per-page via page item

The `p_query_num_rows_item` parameter lets a page item control rows per page:

```sql
-- From App 103, Page 5 ("Filtering")
,p_query_num_rows_item=>'P5_ROWS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_query_row_count_max=>500
,p_pagination_display_position=>'BOTTOM_RIGHT'
```

### No explicit rows (non-tabular templates)

Non-tabular templates may use a hidden item for row count:

```sql
-- From App 103, Page 13 ("Comment Bubbles")
,p_query_num_rows_item=>'P13_ROWS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
```

### Large result sets

```sql
-- From App 104, Page 117 (Change Log - 150 rows, 5000 max)
,p_query_num_rows=>150
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_query_row_count_max=>5000

-- From App 103, Page 42 (Faceted Search - 50 rows, 100000 max)
,p_query_num_rows=>50
,p_query_row_count_max=>100000
```

---

## Region Template Options

Region template options control the outer region chrome (borders, headers, padding).

| Option | Effect |
|--------|--------|
| `t-Region--noPadding` | No padding inside region |
| `t-Region--scrollBody` | Scrollable region body |
| `t-Region--noBorder` | No visible border |
| `t-Region--hideHeader js-addHiddenHeadingRoleDesc` | Hidden header with ARIA role |
| `t-Region--hiddenOverflow` | Clip overflowing content |
| `js-showMaximizeButton` | Show maximize button |

Example combinations from real exports:

```sql
-- Borderless with no padding and hidden header
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody:t-Region--noBorder:t-Region--hideHeader js-addHiddenHeadingRoleDesc'

-- With maximize button and hidden overflow
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--hiddenOverflow'

-- Dialog region
,p_region_template_options=>'#DEFAULT#:js-dialog-size600x400'
```

---

## Component (Report) Template Options

Component template options control the report rows/cells appearance.

| Option | Effect |
|--------|--------|
| `t-Report--stretch` | Stretch report to full width |
| `t-Report--altRowsDefault` | Alternating row colors |
| `t-Report--rowHighlight` | Highlight row on hover |
| `t-Report--staticRowColors` | No alternating colors |
| `t-Report--noBorders` | No cell borders |
| `t-Report--inline` | Inline/compact display |
| `t-Report--hideNoPagination` | Hide pagination when single page |

Example combinations from real exports:

```sql
-- Stretch only
,p_component_template_options=>'#DEFAULT#:t-Report--stretch'

-- Full-featured table
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight'

-- Clean card-like rows
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--staticRowColors:t-Report--rowHighlight:t-Report--noBorders'

-- Faceted search results
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--staticRowColors:t-Report--rowHighlight:t-Report--inline:t-Report--hideNoPagination'

-- Attribute-Value Pair List (non-tabular)
,p_component_template_options=>'#DEFAULT#:t-AVPList--leftAligned'
,p_component_template_options=>'#DEFAULT#:t-AVPList--fixedLabelSmall:t-AVPList--leftAligned'

-- Comments / chat template
,p_component_template_options=>'#DEFAULT#:t-Comments--chat'
```

---

## Non-Tabular Report Templates

Classic reports can use non-tabular row templates (e.g., Comments, AVP List) by referencing
a different `p_query_row_template`.  The query must produce columns matching the template
placeholders.

### Comments / Chat Template

Column aliases must match the template slots: `COMMENT_TEXT`, `USER_NAME`, `COMMENT_DATE`,
`ATTRIBUTE_1`..`ATTRIBUTE_4`, `ICON_MODIFIER`, `USER_ICON`, `ACTIONS`, `COMMENT_MODIFIERS`.

```sql
-- From App 103, Page 13 ("Comment Bubbles")
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

For the Comments template, columns rendered with `WITHOUT_MODIFICATION` allow embedded HTML:

```sql
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(2145182227286324389)
,p_query_column_id=>5
,p_column_alias=>'ATTRIBUTE_1'
,p_column_display_sequence=>3
,p_column_heading=>'Attribute 1'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
```

### Attribute-Value Pair List (AVP)

Used for single-record detail displays.  Each column renders as a label/value pair.

```sql
-- From App 104, Page 50 (Customer details - AVP format)
wwv_flow_imp_page.create_report_region(
 ...
,p_component_template_options=>'#DEFAULT#:t-AVPList--leftAligned'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_row_template=>2100515439059797523
 ...
);
```

---

## Conditional Region Display

Regions can be conditionally displayed using `p_display_condition_type`.

### EXISTS condition

Region shows only when a SQL query returns rows:

```sql
-- From App 104, Page 50 (Issues region)
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select',
'    null',
'from',
'    eba_cust_issues',
'where',
'    customer_id = :P50_ID'))
,p_display_condition_type=>'EXISTS'
```

### Item value condition

Region shows when a page item matches a specific value:

```sql
-- From App 103, Page 27 (conditionally displayed function-specific reports)
,p_display_when_condition=>'P27_FUNCTION'
,p_display_when_cond2=>'SUBSTR'
,p_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
```

### Build option condition

Region visibility controlled by a build option:

```sql
-- From App 104, Page 50 (Issues region)
,p_required_patch=>wwv_flow_imp.id(2588080886301404475)
```

---

## AJAX / Partial Page Refresh

### Enable AJAX on the region

```sql
,p_ajax_enabled=>'Y'
```

### Submit page items with AJAX request

When the report query references page items, list them so their values are sent during refresh:

```sql
,p_ajax_items_to_submit=>'P3_STATUS'
```

### Refresh via Dynamic Action

A common pattern uses a DA on item change to refresh the report region:

```sql
-- DA event: "Refresh Report" on P3_STATUS change
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
-- DA action: NATIVE_REFRESH targeting the report region
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
-- DA event: refresh report when a modal dialog closes
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

---

## Common Patterns

### 1. Basic report with filter item

The most common classic report pattern: a SQL query with bind variables referencing page items,
plus a DA to refresh on filter change.

Key wiring:
- Report SQL uses `:P3_STATUS` bind variable
- `p_ajax_items_to_submit=>'P3_STATUS'` ensures the value is sent on refresh
- DA on `P3_STATUS` change fires `NATIVE_REFRESH` on the report region

### 2. Multi-column search

Filter across multiple text columns with `INSTR`/`UPPER`:

```sql
-- From App 103, Page 5
'where ... (:P5_SEARCH is null or ',
'     instr(upper(project) || ''//''||',
'     upper(TASK_NAME) || ''//''||',
'     upper(ASSIGNED_TO) || ''//''||',
'     upper(STATUS),upper(:P5_SEARCH) ) > 0)'
```

### 3. Detail page with multiple report tabs

App 104, Page 50 uses a Region Display Selector (`NATIVE_DISPLAY_SELECTOR`) to organize
many classic report regions (Details, Issues, Partners, Updates, Attachments, Links, Products)
as tabs.  Each sub-report region sets `p_include_in_reg_disp_sel_yn=>'Y'` and uses a
`p_region_name` static ID.

### 4. Hidden "helper" columns for link substitutions

A common pattern selects extra columns (IDs, URLs) as hidden columns, then references them
in `p_column_link`, `p_column_linktext`, or `p_column_html_expression` via `#COLUMN_ALIAS#`.

### 5. SINCE + author combined column

Select both `created` (date) and `lower(created_by)` (user), format date as `SINCE`, and
combine via HTML expression:

```sql
,p_column_format=>'SINCE'
,p_column_html_expression=>'#CREATED# &middot; #CREATED_BY#'
```

The `CREATED_BY` column is hidden (`p_display_when_cond_type=>'NEVER'`) but still available
for substitution.

### 6. Required parameters for `create_report_region`

Every `create_report_region` call must include:

| Parameter | Required | Notes |
|-----------|----------|-------|
| `p_id` | Yes | Unique region ID |
| `p_name` | Yes | Region title |
| `p_source_type` | Yes | `'NATIVE_SQL_REPORT'` |
| `p_query_type` | Yes | `'SQL'` or `'TABLE'` |
| `p_source` (SQL) or `p_query_table` (TABLE) | Yes | The data source |
| `p_template` | Yes | Region template ID |
| `p_display_sequence` | Yes | Rendering order |
| `p_query_row_template` | Yes | Row template ID |
| `p_query_options` | Yes | `'DERIVED_REPORT_COLUMNS'` |

### 7. Required parameters for `create_report_columns`

Every `create_report_columns` call must include:

| Parameter | Required | Notes |
|-----------|----------|-------|
| `p_id` | Yes | Unique column ID |
| `p_query_column_id` | Yes | Ordinal position in SELECT (1-based) |
| `p_column_alias` | Yes | Must match SQL column alias exactly |
| `p_column_display_sequence` | Yes | Display order |
