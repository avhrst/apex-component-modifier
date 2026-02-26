# Faceted Search (`NATIVE_FACETED_SEARCH`)

Faceted search uses `create_page_plug` with `p_plug_source_type=>'NATIVE_FACETED_SEARCH'`.
Search panel displays filter facets in a sidebar; a separate "filtered region" shows results.
Linked by `p_filtered_region_id`. Source: App 103 p42, App 100 p12.

## Page Definition

```sql
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

## Faceted Search Region (search panel)

No data source -- pure UI container driving the filtered region.

```sql
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

**Key params:** `p_plug_source_type=>'NATIVE_FACETED_SEARCH'` (required), `p_filtered_region_id` references results region, `p_plug_display_point=>'REGION_POSITION_02'` (left sidebar), `p_plug_grid_column_span=>4`.

### Plugin attributes

| Attribute | Values | Purpose |
|-----------|--------|---------|
| `batch_facet_search` | `Y`/`N` | `Y`=Apply button; `N`=immediate refresh |
| `compact_numbers_threshold` | number | Above this, counts show compact (e.g. "10K") |
| `current_facets_selector` | CSS sel | Container for active facets pill bar |
| `display_chart_for_top_n_values` | number | Top N values for facet charts |
| `show_charts` | `Y`/`N` | Chart visualizations in facets |
| `show_current_facets` | `E`/`Y`/`N` | `E`=always, `Y`=when set, `N`=never |
| `show_total_row_count` | `Y`/`N` | Display total matching count |

## Filtered Region (results)

Standard data region. Can be classic report, Cards, IR, or IG.

```sql
-- Classic report as filtered region
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

Cards as filtered region: use `create_page_plug` with `p_plug_source_type=>'NATIVE_CARDS'` and point `p_filtered_region_id` to it.

## Search Items (Facets)

All facets use `create_page_item` with `p_source_type=>'FACET_COLUMN'`, `p_source=>'COLUMN_NAME'`, `p_item_plug_id` referencing the **faceted search region** (not filtered region).

### Text search (`NATIVE_SEARCH`)

```sql
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

Search attrs: `input_field` = `FACET` (facet input) or `TOP` (top-of-page); `search_type` = `ROW` or `COLUMN`.

### Checkbox facet (`NATIVE_CHECKBOX`)

Multi-select for categorical data (VARCHAR2). Most common facet type.

```sql
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

Other checkbox facets (STATUS, ASSIGNED_TO) use identical `p_fc_*` params, only changing `p_name`, `p_source`, `p_item_sequence`, `p_prompt`.

### Range facet (`NATIVE_RANGE`)

For numeric columns. Defines buckets via static LOV.

```sql
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

**Range LOV syntax** (`STATIC2:`): `display;low_bound|high_bound` -- `<100;|100` (no lower), `100 - 200;100|200`, `>=1#G#000;1000|` (no upper, `#G#` = grouping separator).

**Range attrs:** `manual_entry` `Y`/`N` (custom ranges), `select_multiple` `Y`/`N` (multi-select buckets).

## Facet Parameters Reference (`p_fc_*`)

All facet types share these:

| Parameter | Values | Purpose |
|-----------|--------|---------|
| `p_fc_show_label` | `true`/`false` | Show facet label |
| `p_fc_collapsible` | `true`/`false` | Allow collapse |
| `p_fc_initial_collapsed` | `true`/`false` | Start collapsed |
| `p_fc_compute_counts` | `true`/`false` | Compute occurrence counts |
| `p_fc_show_counts` | `true`/`false` | Display counts |
| `p_fc_zero_count_entries` | `H`/`D`/`S` | **H**ide, **D**isable, **S**how zero-count values |
| `p_fc_show_more_count` | integer | Values before "Show More" |
| `p_fc_filter_values` | `true`/`false` | Search box within facet |
| `p_fc_sort_by_top_counts` | `true`/`false` | Sort by count desc (vs alpha) |
| `p_fc_show_selected_first` | `true`/`false` | Selected values at top |
| `p_fc_show_chart` | `true`/`false` | Chart visualization |
| `p_fc_initial_chart` | `true`/`false` | Start with chart open |
| `p_fc_actions_filter` | `true`/`false` | Actions filter |
| `p_fc_display_as` | `INLINE` | Display mode |

Note: `NATIVE_SEARCH` typically only sets `p_fc_show_chart=>false`.

## Supporting Regions

### Active Facets Bar

Static HTML region providing the active facets pill bar container:

```sql
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

The `<div id="active_facets"></div>` is referenced by `current_facets_selector=>'#active_facets'`.

### Reset Button

```sql
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

Reset URL pattern: `f?p=&APP_ID.:<page>:&SESSION.::&DEBUG.:RR,<page>::` clears cache + sets RR (Reset Report).

## Dynamic Actions

Refresh filtered region after dialog close:

```sql
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

## Region Relationship

`p_filtered_region_id` must match the results region `p_id` (both use `wwv_flow_imp.id(...)` with same offset-relative ID).

### Placement pattern

| Region | `p_plug_display_point` | `p_plug_grid_column_span` | Seq |
|--------|----------------------|--------------------------|-----|
| Faceted search panel | `REGION_POSITION_02` | `4` | 10 |
| Button bar / active facets | _(body)_ | _(12)_ | 20 |
| Filtered results | _(body)_ | _(remaining 8)_ | 30 |

Facet items: all `create_page_item` set `p_item_plug_id` to the **faceted search region** ID, reference filtered region columns via `p_source=>'COLUMN_NAME'` + `p_source_type=>'FACET_COLUMN'`.

## Declaration Order

1. `create_report_region`/`create_page_plug` -- filtered results (seq 30)
2. Report columns (if classic report)
3. `create_page_plug` -- faceted search (seq 10, `REGION_POSITION_02`)
4. `create_page_plug` -- button bar (seq 20)
5. `create_page_button` -- Reset
6. `create_page_item` -- facets: `NATIVE_SEARCH` (seq 10), `NATIVE_CHECKBOX` (seq 20-40), `NATIVE_RANGE` (seq 50-60)
7. `create_page_da_event`/`create_page_da_action` -- dialog refresh

## Facet Type Selection

| Column Type | Facet | Notes |
|-------------|-------|-------|
| VARCHAR2 (low cardinality) | `NATIVE_CHECKBOX` | Status, category, assignee |
| VARCHAR2 (high cardinality) | `NATIVE_CHECKBOX` + `p_fc_filter_values=>true` | Search within facet |
| NUMBER | `NATIVE_RANGE` | Define buckets via `p_lov` |
| DATE | `NATIVE_RANGE` | Date range buckets |
| Multiple text columns | `NATIVE_SEARCH` | Comma-separated `p_source` |
