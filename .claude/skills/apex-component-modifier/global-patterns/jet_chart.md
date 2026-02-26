# JET Chart Patterns (NATIVE_JET_CHART)

> Extracted from **App 101 (Sample Charts)**, APEX 24.2.0 export.
> Source: `f101/application/pages/page_000*.sql`

---

## Chart Types

| `p_chart_type` | Page(s) | Axes | Series-specific params |
|---|---|---|---|
| `bar` | 9, 13, 14, 4, 6, 26 | x, y, y2 | `p_orientation`, `p_stack_category`, `p_assigned_to_y2` |
| `line` | 15, 46 | x, y, y2 | `p_line_style`, `p_line_type`, `p_marker_rendered`, `p_marker_shape` |
| `area` | 2 | x, y, y2 | `p_line_type`, `p_marker_rendered`, `p_marker_shape` |
| `combo` | 2, 6, 20, 25 | x, y | `p_series_type` per series (bar/line/area), `p_line_width` |
| `pie` | 4, 24, 26 | (none) | `p_pie_other_threshold`, `p_pie_selection_effect` |
| `donut` | 4, 24 | (none) | `p_pie_other_threshold`, `p_pie_selection_effect`, `p_value_format_type` |
| `scatter` | 8 | x, y | `p_items_x_column_name`, `p_items_y_column_name`, `p_marker_shape` |
| `bubble` | 11 | x, y | `p_items_x_column_name`, `p_items_y_column_name`, `p_items_z_column_name` |
| `stock` | 7 | x, y | `p_stock_render_as`, `p_items_low/high/open/close/volume_column_name` |
| `gantt` | 3 | major, minor | `p_gantt_*` columns, `p_row_axis_rendered`, `p_gantt_axis_position` |
| `dial` | 5 | (none) | `p_gauge_orientation`, `p_gauge_indicator_size`, `p_value_text_type` |
| `funnel` | 22 | (none) | `p_items_target_value`, `p_value_format_type` |
| `radar` | 21 | x, y | `p_series_type=>'line'` on each series |
| `polar` | 19 | x, y | `p_series_type=>'lineWithArea'` on each series, `p_group_name_column_name` |
| `range` | 23 | x, y | `p_series_type=>'barRange'` or `'areaRange'`, `p_items_low/high_column_name` |
| `lineWithArea` | 18, 26 | x, y | same as line + area fill |
| `pyramid` | 43 | (none) | `p_animation_on_display=>'alphaFade'`, threeDEffect via JS |
| `boxPlot` | 41 | x, y | `p_series_type=>'boxPlot'`, `p_q2_color`, `p_q3_color`, `p_time_axis_type` |

---

## Chart Region Setup

Every JET chart lives inside a `create_page_plug` region with `p_plug_source_type=>'NATIVE_JET_CHART'`.

### Pattern: Per-series SQL (most common)

SQL is defined on each series individually. Region has `p_location=>null`.

```sql
-- From page 9: Bar Chart (Dual Y Axis) region
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(113185105385989750)
,p_plug_name=>'Bar Chart (Dual Y Axis with formatted Labels)'
,p_region_name=>'dualChart'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_location=>null
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
);
```

### Pattern: Region-level SQL (shared across series)

SQL is on the region itself. Series uses `p_location=>'REGION_SOURCE'` + `p_series_name_column_name`.

```sql
-- From page 9: Bar Chart (Stacked) with region-level SQL
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(440660098539405813)
,p_plug_name=>'Bar Chart (Stacked)'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>70
,p_include_in_reg_disp_sel_yn=>'Y'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select id,',
'       project as label,',
'       NVL((select sum(t.budget) from eba_demo_chart_tasks t where t.project =  p.id and t.budget > t.cost),0) as value,',
'       ''under budget'' as series ,',
'       ''green'' as color',
'  from eba_demo_chart_projects p',
'union all',
'select id,',
'       project as label,',
'       NVL((select sum(t.budget) from eba_demo_chart_tasks t where t.project =  p.id and t.budget <= t.cost),0) as value,',
'       ''over budget'' as series ,',
'       ''red'' as color',
'  from eba_demo_chart_projects p'))
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
);

-- Corresponding series using REGION_SOURCE:
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(440660318839405815)
,p_chart_id=>wwv_flow_imp.id(440660142601405814)
,p_seq=>10
,p_name=>'New'
,p_location=>'REGION_SOURCE'
,p_series_name_column_name=>'SERIES'
,p_items_value_column_name=>'VALUE'
,p_group_short_desc_column_name=>'LABEL'
,p_items_label_column_name=>'LABEL'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
```

---

## Chart Configuration by Type

### Bar Chart

```sql
-- From page 9: Bar Chart with Dual Y Axis, stacking, labels
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(113185588314989755)
,p_region_id=>wwv_flow_imp.id(113185105385989750)
,p_chart_type=>'bar'
,p_width=>'700'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'                  -- 'vertical' | 'horizontal'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'withRescale'    -- 'none' | 'withRescale' | 'withoutRescale'
,p_hover_behavior=>'none'                   -- 'none' | 'dim'
,p_stack=>'on'                              -- 'on' | 'off'
,p_stack_label=>'off'                       -- 'on' | 'off'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
,p_sorting=>'label-asc'                     -- 'label-asc' | 'label-desc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_show_label=>true
,p_show_row=>true
,p_show_start=>true
,p_show_end=>true
,p_show_progress=>true
,p_show_baseline=>true
,p_legend_rendered=>'on'                    -- 'on' | 'off'
,p_legend_position=>'top'                   -- 'auto' | 'top' | 'end' | 'bottom' | 'start'
,p_overview_rendered=>'off'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
```

**Stack label + stack category (page 9):**

```sql
-- Chart-level: p_stack_label=>'on'
-- Series-level: p_stack_category=>'stack1' or 'stack2'
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(440660659572405819)
,p_region_id=>wwv_flow_imp.id(440660609697405818)
,p_chart_type=>'bar'
,p_stack=>'on'
,p_stack_label=>'on'
-- ... other params
);

wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(440660818326405820)
,p_chart_id=>wwv_flow_imp.id(440660659572405819)
,p_seq=>10
,p_name=>'Store A'
,p_stack_category=>'stack1'
-- ...
);

wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(440661227165405824)
,p_chart_id=>wwv_flow_imp.id(440660659572405819)
,p_seq=>30
,p_name=>'Shop C'
,p_stack_category=>'stack2'
-- ...
);
```

**Horizontal bar with baseline=min (page 9):**

```sql
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(428904660370833021)
,p_region_id=>wwv_flow_imp.id(428904566706833020)
,p_chart_type=>'bar'
,p_height=>'340'
,p_orientation=>'horizontal'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_fill_multi_series_gaps=>false
,p_legend_rendered=>'off'
-- ...
);
```

### Line Chart

```sql
-- From page 15: Line Chart with font formatting, markers, line styles
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(198354016407634955)
,p_region_id=>wwv_flow_imp.id(139395821416406397)
,p_chart_type=>'line'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'none'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'none'
,p_stack=>'on'
,p_stack_label=>'off'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_show_label=>true
,p_show_row=>true
,p_show_start=>true
,p_show_end=>true
,p_show_progress=>true
,p_show_baseline=>true
,p_legend_rendered=>'on'
,p_legend_position=>'top'
,p_legend_font_family=>'Trebuchet MS'       -- legend font
,p_legend_font_style=>'italic'
,p_legend_font_size=>'12'
,p_overview_rendered=>'off'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
```

**Line chart with time axis and zoom (page 15):**

```sql
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(292866788226030835)
,p_region_id=>wwv_flow_imp.id(2070564784455589132)
,p_chart_type=>'line'
,p_height=>'420'
,p_data_cursor=>'on'
,p_data_cursor_behavior=>'smooth'
,p_zoom_and_scroll=>'delayed'              -- 'off' | 'delayed' | 'live'
,p_initial_zooming=>'first'                -- 'none' | 'first' | 'last'
,p_time_axis_type=>'enabled'               -- 'disabled' | 'enabled' | 'auto'
-- ...
);
```

**Line chart with reference object via JavaScript (page 15):**

```sql
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(716821378550164295)
,p_region_id=>wwv_flow_imp.id(716821130571164292)
,p_chart_type=>'line'
,p_width=>'500'
,p_height=>'450'
-- ...
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function( options ) {',
'',
'    // Define Reference Object line on Y Axis of chart',
'    var constantLineY = [ {text:"Reference Object", type: "line", value: 50, color: "#A0CEEC", displayInLegend: "on", lineWidth: 3, location: "back", lineStyle: "dashed", shortDesc: "Sample Reference Line"}];',
'    options.yAxis.referenceObjects = constantLineY;',
'    return options;',
'}'))
);
```

### Area Chart

```sql
-- From page 2: Area Chart (Stacked)
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(450573811384081218)
,p_region_id=>wwv_flow_imp.id(450573499983081218)
,p_chart_type=>'area'
,p_width=>'500'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'on'
,p_data_cursor_behavior=>'smooth'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'none'
,p_stack=>'on'
,p_stack_label=>'off'
,p_spark_chart=>'N'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
,p_sorting=>'label-desc'                   -- descending sort
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
-- tooltip show_* params ...
,p_legend_rendered=>'on'
,p_legend_position=>'top'
,p_overview_rendered=>'off'
-- ...
);
```

**Area chart with JavaScript color customization (page 2):**

```sql
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(692096424576917620)
-- ...
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function( options ) {',
'    options.dataFilter = function( data ) {',
'        data.series[ 0 ].color = "#309fdb";',
'        data.series[ 0 ].borderColor = "black";',
'        data.series[ 0 ].markerDisplayed = "on";',
'        data.series[ 0 ].markerShape = "plus";',
'        data.series[ 0 ].markerColor = "#309fdb";',
'        data.series[ 0 ].markerSize = 8;',
'        data.series[ 0 ].pattern = "smallChecker";',
'        return data;',
'    };',
'    return options;',
'}'))
);
```

### Combo Chart

```sql
-- From page 2: Combo chart (area + line series)
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(450571836235081215)
,p_region_id=>wwv_flow_imp.id(450571344670081214)
,p_chart_type=>'combo'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'none'
,p_orientation=>'horizontal'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'none'
,p_hover_behavior=>'dim'
,p_stack=>'off'
-- ...
);

-- Area series:
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(450573039032081216)
,p_chart_id=>wwv_flow_imp.id(450571836235081215)
,p_seq=>10
,p_name=>'Tasks By Budget/Cost'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select task_name, budget from eba_demo_chart_tasks where budget > 2000 order by 2,1'))
,p_series_type=>'area'                    -- 'bar' | 'line' | 'area'
,p_items_value_column_name=>'BUDGET'
,p_items_label_column_name=>'TASK_NAME'
-- ...
);

-- Line series (with line_width):
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(450809736478807101)
,p_chart_id=>wwv_flow_imp.id(450571836235081215)
,p_seq=>20
,p_name=>'Average Budget'
,p_series_type=>'line'
,p_line_style=>'solid'
,p_line_width=>4
-- ...
);
```

### Scatter Chart

```sql
-- From page 8: Scatter chart with X/Y columns
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(438128675321177109)
,p_region_id=>wwv_flow_imp.id(438128552654177108)
,p_chart_type=>'scatter'
,p_title=>'Dummy Corp Stock Value'
,p_height=>'400'
-- ...
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function (options) {',
'    options.yAxis = { ',
'        min: $v(''P8_Y_MIN''),',
'        max: $v(''P8_Y_MAX'')',
'    };    ',
'    return options;',
'}'))
);

wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(438128745681177110)
,p_chart_id=>wwv_flow_imp.id(438128675321177109)
,p_seq=>10
,p_name=>'Value'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT pricing_date LABEL, ',
'       OPENING_VAL X_VALUE, ',
'       CLOSING_VAL Y_VALUE',
'FROM EBA_DEMO_CHART_STOCKS'))
,p_items_x_column_name=>'X_VALUE'
,p_items_y_column_name=>'Y_VALUE'
,p_items_label_column_name=>'LABEL'
,p_marker_shape=>'star'                    -- 'auto' | 'star' | 'plus' | 'diamond' | 'circle' ...
-- ...
);
```

### Bubble Chart

```sql
-- From page 11: Bubble with 3D data (x, y, z)
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(441041928168161194)
,p_region_id=>wwv_flow_imp.id(441041766021161193)
,p_chart_type=>'bubble'
,p_title=>'OECD Members Pension Contribution Revenues, 2011'
,p_height=>'400'
,p_hover_behavior=>'dim'
-- ...
);

wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(441042009154161195)
,p_chart_id=>wwv_flow_imp.id(441041928168161194)
,p_seq=>10
,p_name=>'2011'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select country country, name, (employee/100) employee, (employer/100) employer, (total/100) total',
' from eba_demo_chart_stats'))
,p_items_x_column_name=>'EMPLOYEE'
,p_items_y_column_name=>'EMPLOYER'
,p_items_z_column_name=>'TOTAL'            -- bubble size
,p_items_label_column_name=>'COUNTRY'
,p_items_label_rendered=>true
,p_items_label_position=>'center'
,p_link_target=>'javascript:$s("P11_POINT",''&COUNTRY.  Total Contributions: $&TOTAL.'');'
,p_link_target_type=>'REDIRECT_URL'
-- ...
);
```

### Stock Chart

```sql
-- From page 7: Stock chart (candlestick)
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(440683332704595849)
,p_region_id=>wwv_flow_imp.id(440682842203595846)
,p_chart_type=>'stock'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_data_cursor=>'on'
,p_data_cursor_behavior=>'smooth'
,p_hover_behavior=>'dim'
,p_stock_render_as=>'candlestick'          -- stock-specific
,p_zoom_and_scroll=>'delayed'
,p_initial_zooming=>'first'
,p_time_axis_type=>'auto'
,p_overview_rendered=>'off'
-- ...
);

wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(440684450904595850)
,p_chart_id=>wwv_flow_imp.id(440683332704595849)
,p_seq=>10
,p_name=>'Series 1'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT null link , PRICING_DATE label , OPENING_VAL , LOW , HIGH , CLOSING_VAL, VOLUME',
'from eba_demo_chart_stocks',
'where stock_code = ''METR''',
'order by PRICING_DATE'))
,p_items_low_column_name=>'LOW'
,p_items_high_column_name=>'HIGH'
,p_items_open_column_name=>'OPENING_VAL'
,p_items_close_column_name=>'CLOSING_VAL'
,p_items_volume_column_name=>'VOLUME'
,p_items_label_column_name=>'LABEL'
-- ...
);
```

### Gantt Chart

```sql
-- From page 3: Gantt with reference object
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(228015452571181249)
,p_region_id=>wwv_flow_imp.id(228015304285181248)
,p_chart_type=>'gantt'
,p_height=>'400'
,p_animation_on_display=>'none'
,p_animation_on_data_change=>'none'
,p_horizontal_grid=>'visible'              -- gantt uses 'visible' not 'auto'
,p_vertical_grid=>'visible'
,p_row_axis_rendered=>'on'                 -- gantt-specific
,p_gantt_axis_position=>'top'              -- gantt-specific
-- ...
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function( options ) {',
'    var event = new Date();',
'    var constantLine = [ { value: event.toISOString() } ];',
'    options.referenceObjects = constantLine;',
'    return options;',
'}'))
);

wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(228015525483181250)
,p_chart_id=>wwv_flow_imp.id(228015452571181249)
,p_seq=>10
,p_name=>'Tasks'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'    select ASSIGNED_TO employee,',
'           task_name, id task_id, parent_task,',
'           start_date task_start_date, end_date task_end_date,',
'           decode(status,''Closed'',1,''Open'',0.6,''On-Hold'',0.1,''Pending'',0) status,',
'           (select min(start_date) from eba_demo_chart_tasks) gantt_start_date,',
'           (select max(end_date) from eba_demo_chart_tasks)  gantt_end_date',
'    from eba_demo_chart_tasks',
'    start with parent_task is null',
'    connect by prior id = parent_task',
'    order siblings by task_name'))
,p_gantt_start_date_source=>'DB_COLUMN'
,p_gantt_start_date_column=>'GANTT_START_DATE'
,p_gantt_end_date_source=>'DB_COLUMN'
,p_gantt_end_date_column=>'GANTT_END_DATE'
,p_gantt_row_name=>'EMPLOYEE'
,p_gantt_task_id=>'TASK_ID'
,p_gantt_task_name=>'TASK_NAME'
,p_gantt_task_start_date=>'TASK_START_DATE'
,p_gantt_task_end_date=>'TASK_END_DATE'
,p_gantt_progress_column=>'STATUS'
,p_task_label_position=>'start'            -- 'start' | 'innerStart' | 'innerCenter' | 'innerEnd' | 'end' | 'none'
-- ...
);

-- Gantt with baselines, viewports, CSS classes (page 3, second chart):
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(645499141436238614)
,p_chart_id=>wwv_flow_imp.id(645499100373238613)
-- ...
,p_gantt_row_id=>'PARENT_TASK_ID'
,p_gantt_row_name=>'TASK_NAME'
,p_gantt_task_id=>'TASK_ID'
,p_gantt_task_name=>'TASK_NAME'
,p_gantt_task_start_date=>'TASK_START_DATE'
,p_gantt_task_end_date=>'TASK_END_DATE'
,p_gantt_task_css_class=>'u-color-22'
,p_gantt_baseline_start_column=>'BASELINE_START'
,p_gantt_baseline_end_column=>'BASELINE_END'
,p_gantt_baseline_css_class=>'u-color-43'
,p_gantt_progress_column=>'STATUS'
,p_gantt_progress_css_class=>'u-color-11'
,p_gantt_viewport_start_source=>'ITEM'
,p_gantt_viewport_start_item=>'P3_START_DATE'
,p_gantt_viewport_end_source=>'ITEM'
,p_gantt_viewport_end_item=>'P3_END_DATE'
,p_task_label_position=>'innerStart'
-- ...
);
```

### Dial / Status Meter Gauge

```sql
-- From page 5: Horizontal gauge with value formatting
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(43014841959174768)
,p_region_id=>wwv_flow_imp.id(43014735532174767)
,p_chart_type=>'dial'
,p_width=>'300'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_value_text_type=>'number'               -- 'number' | 'percent'
,p_value_format_type=>'decimal'            -- 'decimal' | 'currency' | 'percent'
,p_value_decimal_places=>0
,p_value_format_scaling=>'none'
,p_gauge_orientation=>'horizontal'         -- 'horizontal' | 'circular'
,p_gauge_indicator_size=>1                 -- 0 to 1 (fraction)
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
-- ...
);

wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(43014905588174769)
,p_chart_id=>wwv_flow_imp.id(43014841959174768)
,p_seq=>10
,p_name=>'Commission'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT sum(case when COMM is null then 0 when COMM = 0 then 0 else 1 end) value,',
'       count(*) max_value,',
'       ''Sales'' as my_label',
'FROM   eba_demo_chart_emp'))
,p_items_value_column_name=>'VALUE'
,p_items_max_value=>'MAX_VALUE'            -- gauge-specific
,p_items_label_column_name=>'MY_LABEL'
,p_color=>'#FFFF00'
,p_gauge_plot_area_color=>'GRAY'           -- gauge-specific
-- ...
);
```

### Funnel Chart

```sql
-- From page 22: Funnel with 3D effect via JavaScript
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(250359702526247315)
,p_region_id=>wwv_flow_imp.id(250359459496247313)
,p_chart_type=>'funnel'
,p_width=>'500'
,p_height=>'400'
,p_value_format_type=>'decimal'
,p_value_decimal_places=>0
,p_value_format_scaling=>'auto'
-- ...
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function( options ){',
'    options.styleDefaults = { threeDEffect: "on" };',
'    return options;',
'}'))
);

-- Funnel with target value (page 22):
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(560975655284431846)
,p_chart_id=>wwv_flow_imp.id(560975307326431845)
,p_seq=>10
,p_name=>'Series 1'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select b.quantity, b.customer, 100 TARGET_VAL',
'from eba_demo_chart_products a, eba_demo_chart_orders b',
'where a.product_id = b.product_id',
'and a.product_id = 5'))
,p_items_value_column_name=>'QUANTITY'
,p_items_target_value=>'TARGET_VAL'        -- funnel-specific
,p_items_label_column_name=>'CUSTOMER'
,p_link_target=>'javascript:$s("P22_SERIES",''&CUSTOMER. Sales: $&QUANTITY., Target: $&TARGET_VAL.'');'
,p_link_target_type=>'REDIRECT_URL'
-- ...
);
```

### Pyramid Chart

```sql
-- From page 43: Pyramid with 2D/3D toggle
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(303604233412271670)
,p_region_id=>wwv_flow_imp.id(730325017445652670)
,p_chart_type=>'pyramid'
,p_width=>'500'
,p_height=>'400'
,p_animation_on_display=>'alphaFade'
,p_animation_on_data_change=>'auto'
,p_data_cursor=>'on'
,p_data_cursor_behavior=>'smooth'
,p_hide_and_show_behavior=>'withRescale'
-- ...
);
```

### Radar Chart

```sql
-- From page 21: Radar chart
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(521414281716183504)
,p_region_id=>wwv_flow_imp.id(521414236175183503)
,p_chart_type=>'radar'
,p_width=>'600'
,p_height=>'450'
,p_animation_on_display=>'none'
,p_animation_on_data_change=>'none'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
-- ...
);

-- Each series uses p_series_type=>'line':
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(521414349386183505)
,p_chart_id=>wwv_flow_imp.id(521414281716183504)
,p_seq=>10
,p_name=>'Store A'
,p_series_type=>'line'
-- ...
);
```

### Polar Chart

```sql
-- From page 19: Polar chart with stacking
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(521472744083965219)
,p_region_id=>wwv_flow_imp.id(521472378673965217)
,p_chart_type=>'polar'
,p_width=>'500'
,p_height=>'400'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'dim'
,p_stack=>'on'
,p_legend_position=>'top'
-- ...
);

-- Each series uses p_series_type=>'lineWithArea':
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(521473981908965224)
,p_chart_id=>wwv_flow_imp.id(521472744083965219)
,p_seq=>10
,p_name=>'Store A'
,p_series_type=>'lineWithArea'
,p_group_name_column_name=>'PRODUCT_NAME'  -- polar-specific
,p_items_label_column_name=>'PRODUCT_NAME'
,p_line_type=>'curved'
-- ...
);
```

### Range Chart

```sql
-- From page 23: Range chart (Bar Range)
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(633738374167626702)
,p_region_id=>wwv_flow_imp.id(633738320249626701)
,p_chart_type=>'range'
,p_width=>'600'
,p_height=>'450'
-- ...
);

wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(633738463210626703)
,p_chart_id=>wwv_flow_imp.id(633738374167626702)
,p_seq=>10
,p_name=>'Product Sales'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select b.product_name, min(a.quantity), max(a.quantity)',
'from eba_demo_chart_orders a, eba_demo_chart_products b',
'where a.product_id = b.product_id',
'group by a.product_id, b.product_name',
'order by b.product_name asc'))
,p_series_type=>'barRange'                 -- 'barRange' | 'areaRange'
,p_items_low_column_name=>'MIN(A.QUANTITY)'
,p_items_high_column_name=>'MAX(A.QUANTITY)'
,p_items_label_column_name=>'PRODUCT_NAME'
,p_items_label_rendered=>true
,p_items_label_position=>'outsideBarEdge'
-- ...
);
```

### Box Plot Chart

```sql
-- From page 41: Box Plot (normalised tables)
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(303257076009431889)
,p_region_id=>wwv_flow_imp.id(773680930546197547)
,p_chart_type=>'boxPlot'
,p_orientation=>'vertical'
-- ...
);

wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(303258812427431892)
,p_chart_id=>wwv_flow_imp.id(303257076009431889)
,p_seq=>10
,p_name=>'Survey '
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select b.sample_name, a.response',
'from eba_demo_chart_sample_data a, eba_demo_chart_sample_names b',
'where a.sample_id = b.id'))
,p_series_type=>'boxPlot'                  -- required for boxPlot
,p_items_value_column_name=>'RESPONSE'
,p_items_label_column_name=>'SAMPLE_NAME'
,p_color=>'#93F0B8'
-- ...
);

-- Box Plot with time axis and quartile colors (page 41):
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(303259678359431911)
,p_chart_type=>'boxPlot'
,p_time_axis_type=>'enabled'               -- enables time axis on boxPlot
-- ...
);

wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(303261405481431912)
,p_chart_id=>wwv_flow_imp.id(303259678359431911)
,p_series_type=>'boxPlot'
,p_color=>'#3589e3'
,p_q2_color=>'#b0dea6'                     -- 2nd quartile color
,p_q3_color=>'#edd976'                     -- 3rd quartile color
-- ...
);
```

---

## Chart Series Patterns

### Common series parameters

| Parameter | Values | Notes |
|---|---|---|
| `p_data_source_type` | `'SQL'` | Always SQL in these examples |
| `p_location` | `null` (per-series SQL) or `'REGION_SOURCE'` | When REGION_SOURCE, series reads region plug_source |
| `p_series_name_column_name` | column name | For multi-series from single query |
| `p_items_value_column_name` | column name | Y value / main value |
| `p_items_label_column_name` | column name | X-axis label |
| `p_items_short_desc_column_name` | column alias | Custom tooltip text |
| `p_group_short_desc_column_name` | column name | Group tooltip |
| `p_assigned_to_y2` | `'on'` / `'off'` | Assign series to secondary Y axis |
| `p_items_label_rendered` | `true` / `false` | Show data labels |
| `p_items_label_position` | `'auto'`, `'center'`, `'insideBarEdge'`, `'outsideBarEdge'`, `'aboveMarker'`, `'belowMarker'`, `'beforeMarker'`, `'afterMarker'`, `'none'` | Label position |
| `p_items_label_display_as` | `'PERCENT'`, `'LABEL'`, `'COMBO'`, `'ALL'` | What label shows |
| `p_threshold_display` | `'onIndicator'` | Always this value in examples |
| `p_color` | hex color or `'&COLUMN_NAME.'` | Static or SQL-derived |
| `p_static_id` | string | For JS targeting |
| `p_link_target` | URL or JS | Click action |
| `p_link_target_type` | `'REDIRECT_PAGE'`, `'REDIRECT_URL'` | Link type |

### Line-specific series params

| Parameter | Values |
|---|---|
| `p_line_style` | `'solid'`, `'dotted'`, `'dashed'` |
| `p_line_type` | `'auto'`, `'straight'`, `'curved'`, `'stepped'`, `'centeredStepped'` |
| `p_line_width` | integer (e.g. `4`) |
| `p_marker_rendered` | `'on'`, `'off'`, `'auto'` |
| `p_marker_shape` | `'auto'`, `'star'`, `'plus'`, `'diamond'`, `'circle'` |

### Label font params (series-level)

```sql
-- From page 9:
,p_items_label_font_size=>'14'
,p_items_label_font_color=>'WHITE'

-- From page 15:
,p_items_label_font_family=>'Comic Sans MS'
,p_items_label_font_color=>'#FA1238'

-- From page 9 (CSS classes alternative):
,p_items_label_css_classes=>'font-size:14px;color:white;'
```

### SQL-derived colors (page 9)

```sql
-- Series with dynamic color from SQL column:
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(907120769557378296)
-- ...
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select a.product_name, ',
'       b.quantity, ',
'       b.customer,',
'       case when b.quantity > 50 then ''gold''',
'            when b.quantity <= 30 then ''red'' ',
'         when b.quantity > 30 then ''green''',
'         else ''blue''',
'       end colors',
'from eba_demo_chart_products a, eba_demo_chart_orders b',
'where a.product_id = b.product_id',
'and customer = ''Store A''',
'order by a.product_name asc'))
,p_color=>'&COLORS.'                      -- references SQL column alias
-- ...
);
```

### Series with link (drill-down, page 9)

```sql
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(736928910964015602)
-- ...
,p_series_name_column_name=>'JOB'
,p_items_value_column_name=>'AVG_SAL'
,p_items_label_column_name=>'DEPTNO'
,p_link_target=>'f?p=&APP_ID.:29:&SESSION.:IG[emp]_emp_details:&DEBUG.:CR,:IG_DEPTNO:&DEPTNO.'
,p_link_target_type=>'REDIRECT_PAGE'
);
```

---

## Chart Axes Patterns

### Cartesian axes (x, y, y2)

```sql
-- X-axis (from page 9):
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(113186027929989759)
,p_chart_id=>wwv_flow_imp.id(113185588314989755)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_tick_label_rotation=>'auto'             -- 'auto' | 'none'
,p_tick_label_position=>'outside'          -- 'outside' | 'inside'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);

-- Y-axis with title and formatting (from page 9):
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(113186072521989760)
,p_chart_id=>wwv_flow_imp.id(113185588314989755)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_title=>'Y1 Axis Title'
,p_format_type=>'decimal'                  -- 'decimal' | 'currency' | 'percent' | 'datetime-long' | 'datetime-full' | 'date-medium'
,p_decimal_places=>0
,p_format_scaling=>'auto'                  -- 'auto' | 'none' | 'thousand' | 'million' | 'billion' | 'trillion' | 'quadrillion'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'                -- 'zero' | 'min'
,p_position=>'auto'                        -- 'auto' | 'start' | 'end'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_zoom_order_seconds=>false
-- ... zoom_order params
);

-- Y2 axis with dual-Y split (from page 9):
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(113186260374989761)
,p_chart_id=>wwv_flow_imp.id(113185588314989755)
,p_axis=>'y2'
,p_is_rendered=>'on'
,p_title=>'Y2 Axis Title'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_split_dual_y=>'on'                     -- split the Y axes
,p_splitter_position=>.7                   -- where to split (0-1)
-- ...
);
```

### Axis with font formatting (from page 15)

```sql
-- Y-axis with title font:
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(198354414332634959)
,p_chart_id=>wwv_flow_imp.id(198354016407634955)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_title=>'Y1 Axis Title'
,p_title_font_family=>'Times'
,p_title_font_style=>'italic'              -- 'normal' | 'italic' | 'oblique'
,p_title_font_size=>'14'
,p_title_font_color=>'GREEN'
,p_tick_label_font_family=>'Helvetica'
,p_tick_label_font_style=>'oblique'
,p_tick_label_font_size=>'14'
,p_tick_label_font_color=>'#F59D5A'
-- ...
);

-- X-axis with title font:
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(198354516342634960)
,p_chart_id=>wwv_flow_imp.id(198354016407634955)
,p_axis=>'x'
,p_title=>'X-Axis Title'
,p_title_font_family=>'Comic Sans MS'
,p_title_font_style=>'normal'
,p_title_font_size=>'16'
,p_title_font_color=>'#F544F5'
,p_tick_label_font_family=>'Courier'
,p_tick_label_font_style=>'normal'
,p_tick_label_font_color=>'#2323EB'
-- ...
);
```

### Stacked percent Y-axis (from page 9)

```sql
-- Y-axis for stacked percent bar chart:
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(673638951712289597)
,p_chart_id=>wwv_flow_imp.id(673638653503289594)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_min=>0                                  -- required for percent
,p_max=>1                                  -- 1 = 100%
,p_format_type=>'percent'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
-- ...
);
```

### Stock chart axes (from page 7)

```sql
-- X-axis with datetime format:
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(440683700564595850)
,p_chart_id=>wwv_flow_imp.id(440683332704595849)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_format_type=>'datetime-long'
-- ...
);

-- Y-axis with currency format:
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(440684122523595850)
,p_chart_id=>wwv_flow_imp.id(440683332704595849)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_format_type=>'currency'
,p_decimal_places=>0
,p_baseline_scaling=>'min'                 -- start at data minimum, not zero
,p_position=>'end'                         -- put axis on right side
-- ...
);
```

### Gantt axes (major/minor, from page 3)

```sql
-- Major axis (months):
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(228015626718181251)
,p_chart_id=>wwv_flow_imp.id(228015452571181249)
,p_axis=>'major'                           -- gantt uses 'major' not 'x'
,p_is_rendered=>'on'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'auto'
,p_tick_label_rendered=>'on'
,p_axis_scale=>'months'                    -- 'days' | 'weeks' | 'months' | 'quarters' | 'years'
,p_zoom_order_days=>true
,p_zoom_order_weeks=>true
,p_zoom_order_months=>true
,p_zoom_order_quarters=>true
);

-- Minor axis (days):
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(228015758154181252)
,p_chart_id=>wwv_flow_imp.id(228015452571181249)
,p_axis=>'minor'                           -- gantt uses 'minor' not 'y'
,p_baseline_scaling=>'zero'
,p_axis_scale=>'days'
,p_zoom_order_hours=>true
,p_zoom_order_days=>true
,p_zoom_order_weeks=>true
);
```

### Y-axis with step (from page 15)

```sql
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(716821936907164300)
,p_chart_id=>wwv_flow_imp.id(716821378550164295)
,p_axis=>'y'
,p_step=>1                                 -- force step increment
,p_min_step=>1                             -- minimum step size
-- ...
);
```

### Line chart with currency Y and datetime-full X (from page 15)

```sql
-- X-axis with datetime-full format:
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(292867003255030837)
,p_chart_id=>wwv_flow_imp.id(292866788226030835)
,p_axis=>'x'
,p_format_type=>'datetime-full'
,p_format_scaling=>'none'
-- ...
);

-- Y-axis with currency format and step:
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(292867072860030838)
,p_chart_id=>wwv_flow_imp.id(292866788226030835)
,p_axis=>'y'
,p_format_type=>'currency'
,p_decimal_places=>2
,p_step=>50
-- ...
);
```

---

## Common Patterns

### JavaScript customization via `p_javascript_code`

Used at chart level (`create_jet_chart`) for:

1. **Custom colors via dataFilter** (page 9):
```javascript
function( options ){
    options.dataFilter = function( data ) {
        data.series[ 0 ].items[0].color = "red";
        data.series[ 0 ].items[1].color = "blue";
        // ...
        return data;
    };
    return options;
}
```

2. **Reference objects** (page 15):
```javascript
function( options ) {
    var constantLineY = [ {text:"Reference Object", type: "line", value: 50, color: "#A0CEEC", displayInLegend: "on", lineWidth: 3, location: "back", lineStyle: "dashed", shortDesc: "Sample Reference Line"}];
    options.yAxis.referenceObjects = constantLineY;
    return options;
}
```

3. **3D effect** (pages 22, 43):
```javascript
function( options ){
    options.styleDefaults = { threeDEffect: "on" };
    return options;
}
```

4. **Custom legend icons** (page 2):
```javascript
function( options ) {
    options.dataFilter = function( data ) {
        data.legend = { sections:[{ items:[] }] }
        for ( var i = 0; i < data.series.length; i++ ) {
            data.legend.sections[ 0 ].items.push( {
                text: data.series[ i ].name,
                color: data.series[ i ].color,
                symbolType: "image",
                source: gAppImages + "legend/" + data.series[ i ].name + ".png"
            });
            data.series[ i ].displayInLegend = 'off';
        }
        return data;
    }
    return options;
}
```

5. **Dynamic axis min/max from page items** (page 8):
```javascript
function (options) {
    options.yAxis = {
        min: $v('P8_Y_MIN'),
        max: $v('P8_Y_MAX')
    };
    return options;
}
```

### Dynamic Actions on charts

Used to change chart properties at runtime via `NATIVE_JAVASCRIPT_CODE`:

```sql
-- Toggle stack (page 9):
apex.region("stackCategoryChart").widget().ojChart({stack: 'on'});
apex.region("stackCategoryChart").widget().ojChart({stack: 'off'});

-- Change orientation (page 9):
apex.region("stackCategoryChart").widget().ojChart({orientation: 'horizontal'});
apex.region("stackCategoryChart").widget().ojChart({orientation: 'vertical'});

-- Change chart type (page 15):
apex.region("lineChart").widget().ojChart({type: 'bar'});
apex.region("lineChart").widget().ojChart({type: 'area'});
apex.region("lineChart").widget().ojChart({type: 'line'});
apex.region("lineChart").widget().ojChart({type: 'lineWithArea'});
apex.region("lineChart").widget().ojChart({type: 'combo'});

-- Change line type (page 2):
apex.region("area2").widget().ojChart({styleDefaults:{lineType:'curved'}});
apex.region("area2").widget().ojChart({styleDefaults:{lineType:'stepped'}});
apex.region("area2").widget().ojChart({styleDefaults:{lineType:'straight'}});
apex.region("area2").widget().ojChart({styleDefaults:{lineType:'centeredSegmented'}});
apex.region("area2").widget().ojChart({styleDefaults:{lineType:'none'}});

-- Toggle 3D effect (page 43):
apex.region("pyramid1").widget().ojChart({styleDefaults: { 'threeDEffect': 'off' }});
apex.region("pyramid1").widget().ojChart({styleDefaults: { 'threeDEffect': 'on' }});
```

### Tooltip configuration

All charts include tooltip params. Common pattern:

```sql
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true    -- or false
,p_show_group_name=>true     -- or false
,p_show_value=>true
,p_show_label=>true          -- or false
,p_show_row=>true
,p_show_start=>true
,p_show_end=>true
,p_show_progress=>true
,p_show_baseline=>true       -- or false (gantt)
```

### Chart title

Set directly on `create_jet_chart`:

```sql
,p_title=>'Jobs By Department'    -- page 9
,p_title=>'OECD Members ...'      -- page 11
```

### Value formatting (chart-level, for funnel/pyramid/dial)

```sql
,p_value_format_type=>'decimal'     -- 'decimal' | 'currency' | 'percent'
,p_value_decimal_places=>0
,p_value_format_scaling=>'none'     -- 'none' | 'auto' | 'thousand' | 'million' | ...
```

### No data found message (gantt, page 3)

```sql
,p_no_data_found_message=>'Select a start and end date, to render the gantt chart'
```

### Spark chart mode

```sql
,p_spark_chart=>'N'                 -- 'N' (normal) | 'Y' (spark mode)
```

---

## Enumerated Values Reference

### `p_chart_type`
`bar`, `line`, `area`, `combo`, `pie`, `donut`, `scatter`, `bubble`, `stock`, `gantt`, `dial`, `funnel`, `radar`, `polar`, `range`, `lineWithArea`, `pyramid`, `boxPlot`

### `p_orientation`
`vertical`, `horizontal`

### `p_animation_on_display`
`auto`, `none`, `alphaFade`

### `p_animation_on_data_change`
`auto`, `none`

### `p_data_cursor`
`auto`, `on`, `off`

### `p_data_cursor_behavior`
`auto`, `smooth`

### `p_hide_and_show_behavior`
`none`, `withRescale`, `withoutRescale`

### `p_hover_behavior`
`none`, `dim`

### `p_legend_position`
`auto`, `top`, `end`, `bottom`, `start`

### `p_zoom_and_scroll`
`off`, `delayed`, `live`

### `p_initial_zooming`
`none`, `first`, `last`

### `p_time_axis_type`
`disabled`, `enabled`, `auto`

### `p_sorting`
`label-asc`, `label-desc`

### `p_stock_render_as`
`candlestick`

### `p_format_type` (axis)
`decimal`, `currency`, `percent`, `datetime-long`, `datetime-full`, `date-medium`

### `p_format_scaling` (axis)
`auto`, `none`, `thousand`, `million`, `billion`, `trillion`, `quadrillion`

### `p_baseline_scaling` (axis)
`zero`, `min`

### `p_position` (axis)
`auto`, `start`, `end`

### `p_axis` values
Cartesian: `x`, `y`, `y2`
Gantt: `major`, `minor`

### `p_axis_scale` (gantt)
`days`, `weeks`, `months`, `quarters`, `years`

### `p_series_type` (series)
`bar`, `line`, `area`, `lineWithArea`, `barRange`, `areaRange`, `boxPlot`

### `p_line_style`
`solid`, `dotted`, `dashed`

### `p_line_type`
`auto`, `straight`, `curved`, `stepped`, `centeredStepped`

### `p_marker_rendered`
`auto`, `on`, `off`

### `p_marker_shape`
`auto`, `star`, `plus`, `diamond`, `circle`

### `p_items_label_position`
`auto`, `center`, `insideBarEdge`, `outsideBarEdge`, `aboveMarker`, `belowMarker`, `beforeMarker`, `afterMarker`, `none`

### `p_items_label_display_as`
`PERCENT`, `LABEL`, `COMBO`, `ALL`

### `p_gauge_orientation`
`horizontal`, `circular`

### `p_value_text_type` (dial)
`number`, `percent`

### `p_task_label_position` (gantt)
`start`, `innerStart`, `innerCenter`, `innerEnd`, `end`, `none`

### `p_gantt_start_date_source` / `p_gantt_end_date_source`
`DB_COLUMN`, `ITEM`

### `p_gantt_viewport_start_source` / `p_gantt_viewport_end_source`
`DB_COLUMN`, `ITEM`
