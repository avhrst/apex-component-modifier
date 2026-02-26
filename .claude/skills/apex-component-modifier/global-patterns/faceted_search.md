# Faceted Search (`NATIVE_FACETED_SEARCH`)

Faceted search regions use `create_page_plug` with `p_plug_source_type=>'NATIVE_FACETED_SEARCH'`.
The search panel displays filter facets in a sidebar; a separate "filtered region" shows the results
(classic report, interactive report, cards, etc.). The two are linked by `p_filtered_region_id`.

Source: App 103 page 42 (`f103/application/pages/page_00042.sql`), App 100 page 12 (cards_region.md reference).

---

## Page Definition

```sql
-- Page-level: p_page_component_map=>'22' is the wizard-generated map for faceted search pages
wwv_flow_imp_page.create_page(
 p_id=>42
,p_name=>'Faceted Search'
,p_alias=>'FACETED-SEARCH'
,p_step_title=>'Faceted Search'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>2526643373347724467
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'22'
);
```

---

## Faceted Search Region (the search panel)

The faceted search region itself does NOT have a data source -- it is a pure UI container that
drives the filtered region. It uses `create_page_plug` (not `create_report_region`).

```sql
-- App 103, Page 42: Faceted search panel in left sidebar
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(624739719921135912)
,p_plug_name=>'Search'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader js-addHiddenHeadingRoleDesc:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>4
,p_plug_display_point=>'REGION_POSITION_02'
,p_plug_source_type=>'NATIVE_FACETED_SEARCH'
,p_filtered_region_id=>wwv_flow_imp.id(624739556134135912)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'batch_facet_search', 'N',
  'compact_numbers_threshold', '10000',
  'current_facets_selector', '#active_facets',
  'display_chart_for_top_n_values', '10',
  'show_charts', 'Y',
  'show_current_facets', 'E',
  'show_total_row_count', 'Y')).to_clob
);
```

### Key parameters

| Parameter | Value | Notes |
|-----------|-------|-------|
| `p_plug_source_type` | `'NATIVE_FACETED_SEARCH'` | Required -- identifies region as faceted search |
| `p_filtered_region_id` | `wwv_flow_imp.id(...)` | References the results region ID |
| `p_plug_display_point` | `'REGION_POSITION_02'` | Left sidebar position (standard for faceted search) |
| `p_plug_grid_column_span` | `4` | 4 of 12 grid columns for the search panel |

### Plugin attributes

| Attribute | Value | Purpose |
|-----------|-------|---------|
| `batch_facet_search` | `'N'` | `Y` = add Apply button; `N` = immediate refresh on facet change |
| `compact_numbers_threshold` | `'10000'` | Above this threshold, counts display as compact (e.g. "10K") |
| `current_facets_selector` | `'#active_facets'` | CSS selector for the "active facets" pill bar container |
| `display_chart_for_top_n_values` | `'10'` | Number of top values to show in facet charts |
| `show_charts` | `'Y'` | Show chart visualizations in facets |
| `show_current_facets` | `'E'` | Show current facets bar: `'E'` = show always, `'Y'` = when facets set, `'N'` = never |
| `show_total_row_count` | `'Y'` | Display total matching row count |

---

## Filtered Region (the results region)

The filtered region is a standard data region. In App 103 page 42 it is a classic report
created with `create_report_region`. It can also be a Cards region, Interactive Report, or
other data-displaying region type.

```sql
-- App 103, Page 42: Classic report as filtered region
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

### Cards as filtered region (App 100, Page 12)

```sql
-- App 100, Page 12: Cards region as the filtered target
-- (faceted search region references this via p_filtered_region_id)
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9825919996571872644)
 -- ... Cards region definition with p_plug_source_type=>'NATIVE_CARDS' ...
);

-- The faceted search panel pointing to the cards region
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9825920105389872644)
,p_plug_name=>'Search'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader js-addHiddenHeadingRoleDesc:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>4
,p_plug_display_point=>'REGION_POSITION_02'
,p_plug_source_type=>'NATIVE_FACETED_SEARCH'
,p_filtered_region_id=>wwv_flow_imp.id(9825919996571872644)
);
```

---

## Search Items (Facets)

All facet items use `create_page_item` with:
- `p_source_type=>'FACET_COLUMN'` -- marks the item as a facet
- `p_source=>'COLUMN_NAME'` -- the column from the filtered region's data source
- `p_item_plug_id` -- must reference the **faceted search region** (not the filtered region)

### Text search facet (`NATIVE_SEARCH`)

Searches across multiple columns. The `p_source` parameter is a comma-separated list of
column names to search.

```sql
-- App 103, Page 42: Full-text search across PROJECT, TASK_NAME, STATUS, ASSIGNED_TO
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(624740170239135916)
,p_name=>'P42_SEARCH'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(624739719921135912)
,p_prompt=>'Search'
,p_source=>'PROJECT,TASK_NAME,STATUS,ASSIGNED_TO'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_SEARCH'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'input_field', 'FACET',
  'search_type', 'ROW')).to_clob
,p_fc_show_chart=>false
);
```

**Search attributes:**

| Attribute | Value | Purpose |
|-----------|-------|---------|
| `input_field` | `'FACET'` | Render as a facet input field (vs. `'TOP'` for top-of-page) |
| `search_type` | `'ROW'` | Search within row data (vs. `'COLUMN'` for column-level) |

### Checkbox facet (`NATIVE_CHECKBOX`)

Multi-select facet for categorical data (VARCHAR2 columns). Most common facet type.

```sql
-- App 103, Page 42: Project name checkbox facet
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(624740627216135920)
,p_name=>'P42_PROJECT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(624739719921135912)
,p_prompt=>'Project'
,p_source=>'PROJECT'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov_sort_direction=>'ASC'
,p_fc_show_label=>true
,p_fc_collapsible=>true
,p_fc_initial_collapsed=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>5
,p_fc_filter_values=>false
,p_fc_sort_by_top_counts=>true
,p_fc_show_selected_first=>false
,p_fc_show_chart=>true
,p_fc_initial_chart=>false
,p_fc_actions_filter=>false
,p_fc_display_as=>'INLINE'
);
```

```sql
-- App 103, Page 42: Status checkbox facet (same pattern, different column)
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(624741348408135920)
,p_name=>'P42_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(624739719921135912)
,p_prompt=>'Status'
,p_source=>'STATUS'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov_sort_direction=>'ASC'
,p_fc_show_label=>true
,p_fc_collapsible=>true
,p_fc_initial_collapsed=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>5
,p_fc_filter_values=>false
,p_fc_sort_by_top_counts=>true
,p_fc_show_selected_first=>false
,p_fc_show_chart=>true
,p_fc_initial_chart=>false
,p_fc_actions_filter=>false
,p_fc_display_as=>'INLINE'
);
```

### Range facet (`NATIVE_RANGE`)

Used for numeric columns. Defines buckets via a static LOV with range boundaries.

```sql
-- App 103, Page 42: Cost range facet with defined buckets
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(624741815335135922)
,p_name=>'P42_COST'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(624739719921135912)
,p_prompt=>'Cost'
,p_source=>'COST'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_RANGE'
,p_lov=>'STATIC2:<100;|100,100 - 200;100|200,200 - 1#G#000;200|1000,>=1#G#000;1000|'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'manual_entry', 'N',
  'select_multiple', 'Y')).to_clob
,p_fc_show_label=>true
,p_fc_collapsible=>true
,p_fc_initial_collapsed=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>100
,p_fc_filter_values=>false
,p_fc_show_selected_first=>false
,p_fc_show_chart=>true
,p_fc_initial_chart=>false
,p_fc_actions_filter=>false
,p_fc_display_as=>'INLINE'
);
```

```sql
-- App 103, Page 42: Budget range facet with different buckets
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(624742211422135923)
,p_name=>'P42_BUDGET'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(624739719921135912)
,p_prompt=>'Budget'
,p_source=>'BUDGET'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_RANGE'
,p_lov=>'STATIC2:<200;|200,200 - 300;200|300,300 - 1#G#000;300|1000,1#G#000 - 2#G#000;1000|2000,>=2#G#000;2000|'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'manual_entry', 'N',
  'select_multiple', 'Y')).to_clob
,p_fc_show_label=>true
,p_fc_collapsible=>true
,p_fc_initial_collapsed=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>100
,p_fc_filter_values=>false
,p_fc_show_selected_first=>false
,p_fc_show_chart=>true
,p_fc_initial_chart=>false
,p_fc_actions_filter=>false
,p_fc_display_as=>'INLINE'
);
```

**Range LOV syntax:**
The `p_lov` uses `STATIC2:` format with `display;low_bound|high_bound` entries:
- `<100;|100` -- display "<100", no lower bound, upper bound 100
- `100 - 200;100|200` -- display "100 - 200", lower 100, upper 200
- `>=1#G#000;1000|` -- display ">=1,000" (using `#G#` as grouping separator), lower 1000, no upper bound

**Range attributes:**

| Attribute | Value | Purpose |
|-----------|-------|---------|
| `manual_entry` | `'N'` | Whether users can type custom ranges |
| `select_multiple` | `'Y'` | Allow selecting multiple range buckets simultaneously |

---

## Facet Item Parameters Reference (`p_fc_*`)

All facet items (checkbox, range, search) share these facet-configuration parameters:

| Parameter | Values | Purpose |
|-----------|--------|---------|
| `p_fc_show_label` | `true` / `false` | Show the facet label (prompt) |
| `p_fc_collapsible` | `true` / `false` | Allow facet section to be collapsed |
| `p_fc_initial_collapsed` | `true` / `false` | Start collapsed (useful for less-important facets) |
| `p_fc_compute_counts` | `true` / `false` | Compute occurrence counts for each value |
| `p_fc_show_counts` | `true` / `false` | Display occurrence counts next to values |
| `p_fc_zero_count_entries` | `'H'` / `'D'` / `'S'` | Handle zero-count values: **H**ide, **D**isable, **S**how |
| `p_fc_show_more_count` | integer | Number of values to show before "Show More" link |
| `p_fc_filter_values` | `true` / `false` | Show a search box within the facet to filter its values |
| `p_fc_sort_by_top_counts` | `true` / `false` | Sort values by count descending (vs. alphabetical) |
| `p_fc_show_selected_first` | `true` / `false` | Move selected values to top of facet list |
| `p_fc_show_chart` | `true` / `false` | Enable chart visualization for this facet |
| `p_fc_initial_chart` | `true` / `false` | Start with chart view open |
| `p_fc_actions_filter` | `true` / `false` | Show actions filter |
| `p_fc_display_as` | `'INLINE'` | Display mode: `'INLINE'` = inline in sidebar |

Note: `NATIVE_SEARCH` facets typically only set `p_fc_show_chart=>false` (charts are not meaningful for text search).

---

## Supporting Regions

### Active Facets Bar (Button Bar)

A static HTML region that provides the container for the "active facets" pill bar,
where currently applied filters are shown as removable pills.

```sql
-- App 103, Page 42: Active facets container + Reset button host
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(624742479488135925)
,p_plug_name=>'Button Bar'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noPadding:t-ButtonRegion--noUI'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>20
,p_plug_source=>'<div id="active_facets"></div>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML',
  'show_line_breaks', 'Y')).to_clob
);
```

The `<div id="active_facets"></div>` element is referenced by the faceted search region's
`current_facets_selector` attribute (`'#active_facets'`).

### Reset Button

```sql
-- App 103, Page 42: Reset facets button in the button bar
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(624743014822135926)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(624742479488135925)
,p_button_name=>'RESET'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Reset'
,p_button_position=>'NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:42:&SESSION.::&DEBUG.:RR,42::'
,p_icon_css_classes=>'fa-undo'
);
```

The reset URL pattern `f?p=&APP_ID.:<page>:&SESSION.::&DEBUG.:RR,<page>::` clears the cache
for the page and sets `RR` (Reset Report) in the clear-cache parameter.

---

## Dynamic Actions

A common pattern is to refresh the filtered region after a dialog closes (e.g., after
editing a record from the results).

```sql
-- App 103, Page 42: Refresh search results after dialog close
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(223926447329124450)
,p_name=>'Refresh on Edit'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(624739556134135912)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(223926517717124451)
,p_event_id=>wwv_flow_imp.id(223926447329124450)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(624739556134135912)
,p_attribute_01=>'N'
);
```

---

## Region Relationship

### ID linkage

The faceted search region's `p_filtered_region_id` must point to the results region's `p_id`.
In the export file, both regions use `wwv_flow_imp.id(...)` with the same offset-relative ID:

```
Faceted search: p_filtered_region_id=>wwv_flow_imp.id(624739556134135912)
Filtered region:            p_id=>wwv_flow_imp.id(624739556134135912)
```

### Placement pattern

| Region | `p_plug_display_point` | `p_plug_grid_column_span` | `p_plug_display_sequence` |
|--------|----------------------|--------------------------|--------------------------|
| Faceted search panel | `REGION_POSITION_02` (left sidebar) | `4` | `10` |
| Button bar / active facets | _(body, default)_ | _(default 12)_ | `20` |
| Filtered results region | _(body, default)_ | _(default, fills remaining 8)_ | `30` |

The standard layout is:
- Search panel in `REGION_POSITION_02` spanning 4 grid columns (left sidebar)
- Results in the body area, which automatically gets the remaining 8 grid columns
- Button bar between search and results at sequence 20 for the active facets pill display

### Facet items belong to the search region

All `create_page_item` calls for facets set `p_item_plug_id` to the **faceted search region** ID
(not the filtered region). The facets reference columns from the filtered region's data source
via `p_source=>'COLUMN_NAME'` with `p_source_type=>'FACET_COLUMN'`.

---

## Common Patterns

### Typical faceted search page structure (declaration order)

1. `create_report_region` or `create_page_plug` -- the **filtered results** region (sequence 30)
2. Report columns (if classic report) -- `create_report_columns` for each visible column
3. `create_page_plug` -- the **faceted search** region (sequence 10, `REGION_POSITION_02`)
4. `create_page_plug` -- the **button bar** region (sequence 20, body)
5. `create_page_plug` -- optional "About this page" info region
6. `create_page_plug` -- breadcrumb region (`REGION_POSITION_01`)
7. `create_page_button` -- Reset button in the button bar
8. `create_page_item` -- facet items (all attached to the faceted search region):
   - `NATIVE_SEARCH` (text search, sequence 10)
   - `NATIVE_CHECKBOX` (categorical facets, sequences 20-40)
   - `NATIVE_RANGE` (numeric facets, sequences 50-60)
9. `create_page_da_event` / `create_page_da_action` -- dialog refresh

### Filtered region types observed

| Type | API Call | Source |
|------|----------|--------|
| Classic Report | `create_report_region` with `p_source_type=>'NATIVE_SQL_REPORT'` | App 103 page 42 |
| Cards | `create_page_plug` with `p_plug_source_type=>'NATIVE_CARDS'` | App 100 page 12 |

Interactive Reports and Interactive Grids can also be used as filtered regions (set the
faceted search region's `p_filtered_region_id` to the IR/IG region ID).

### Facet type selection guide

| Column Type | Recommended Facet | Notes |
|-------------|-------------------|-------|
| VARCHAR2 (low cardinality) | `NATIVE_CHECKBOX` | Best for status, category, assignee |
| VARCHAR2 (high cardinality) | `NATIVE_CHECKBOX` with `p_fc_filter_values=>true` | Add search within facet |
| NUMBER | `NATIVE_RANGE` | Define meaningful buckets via `p_lov` |
| DATE | `NATIVE_RANGE` | Define date range buckets |
| Multiple text columns | `NATIVE_SEARCH` | Comma-separated column list in `p_source` |
