# JET Chart Patterns (NATIVE_JET_CHART)

## Chart Types

| `p_chart_type` | Axes | Series-specific params |
|---|---|---|
| `bar` | x, y, y2 | `p_orientation`, `p_stack_category`, `p_assigned_to_y2` |
| `line` | x, y, y2 | `p_line_style`, `p_line_type`, `p_marker_rendered`, `p_marker_shape` |
| `area` | x, y, y2 | `p_line_type`, `p_marker_rendered`, `p_marker_shape` |
| `combo` | x, y | `p_series_type` per series (bar/line/area), `p_line_width` |
| `pie` | (none) | `p_pie_other_threshold`, `p_pie_selection_effect` |
| `donut` | (none) | `p_pie_other_threshold`, `p_pie_selection_effect`, `p_value_format_type` |
| `scatter` | x, y | `p_items_x_column_name`, `p_items_y_column_name`, `p_marker_shape` |
| `bubble` | x, y | `p_items_x_column_name`, `p_items_y_column_name`, `p_items_z_column_name` |
| `stock` | x, y | `p_stock_render_as`, `p_items_low/high/open/close/volume_column_name` |
| `gantt` | major, minor | `p_gantt_*` columns, `p_row_axis_rendered`, `p_gantt_axis_position` |
| `dial` | (none) | `p_gauge_orientation`, `p_gauge_indicator_size`, `p_value_text_type` |
| `funnel` | (none) | `p_items_target_value`, `p_value_format_type` |
| `radar` | x, y | `p_series_type=>'line'` on each series |
| `polar` | x, y | `p_series_type=>'lineWithArea'` on each series, `p_group_name_column_name` |
| `range` | x, y | `p_series_type=>'barRange'` or `'areaRange'`, `p_items_low/high_column_name` |
| `lineWithArea` | x, y | same as line + area fill |
| `pyramid` | (none) | `p_animation_on_display=>'alphaFade'`, threeDEffect via JS |
| `boxPlot` | x, y | `p_series_type=>'boxPlot'`, `p_q2_color`, `p_q3_color`, `p_time_axis_type` |

## Chart Region Setup

Every JET chart lives inside `create_page_plug` with `p_plug_source_type=>'NATIVE_JET_CHART'`.

### Per-series SQL (most common)

SQL defined on each series. Region has `p_location=>null`.

```sql
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

### Region-level SQL (shared across series)

SQL on the region. Series uses `p_location=>'REGION_SOURCE'` + `p_series_name_column_name`.

```sql
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

## Bar Chart

```sql
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
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'none'
,p_stack=>'on'                              -- 'on' | 'off'
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
,p_overview_rendered=>'off'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
```

**Stack category** -- series-level param for grouping stacks:
```sql
,p_stack_category=>'stack1'   -- or 'stack2' for separate stack group
```

**Horizontal bar**: set `p_orientation=>'horizontal'` on chart.

### Line Chart

Same structure as bar. Key differences:
```sql
,p_chart_type=>'line'
```

**Time axis + zoom**:
```sql
,p_zoom_and_scroll=>'delayed'
,p_initial_zooming=>'first'
,p_time_axis_type=>'enabled'
```

**Reference object via JS**:
```sql
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function( options ) {',
'    var constantLineY = [ {text:"Reference Object", type: "line", value: 50, color: "#A0CEEC", displayInLegend: "on", lineWidth: 3, location: "back", lineStyle: "dashed", shortDesc: "Sample Reference Line"}];',
'    options.yAxis.referenceObjects = constantLineY;',
'    return options;',
'}'))
```

**Legend font** (chart-level):
```sql
,p_legend_font_family=>'Trebuchet MS'
,p_legend_font_style=>'italic'
,p_legend_font_size=>'12'
```

### Area Chart

Same structure as bar/line. Key differences:
```sql
,p_chart_type=>'area'
,p_spark_chart=>'N'    -- 'N' (normal) | 'Y' (spark mode)
```

**JS color customization**:
```sql
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
```

### Combo Chart

```sql
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(450571836235081215)
,p_region_id=>wwv_flow_imp.id(450571344670081214)
,p_chart_type=>'combo'
,p_orientation=>'horizontal'
,p_hover_behavior=>'dim'
,p_stack=>'off'
-- ... standard params
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
);

-- Line series:
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(450809736478807101)
,p_chart_id=>wwv_flow_imp.id(450571836235081215)
,p_seq=>20
,p_name=>'Average Budget'
,p_series_type=>'line'
,p_line_style=>'solid'
,p_line_width=>4
);
```

### Scatter Chart

```sql
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
,p_marker_shape=>'star'
);
```

### Bubble Chart

Like scatter but adds Z column for bubble size:
```sql
,p_items_x_column_name=>'EMPLOYEE'
,p_items_y_column_name=>'EMPLOYER'
,p_items_z_column_name=>'TOTAL'            -- bubble size
,p_items_label_rendered=>true
,p_items_label_position=>'center'
,p_link_target=>'javascript:$s("P11_POINT",''&COUNTRY.  Total Contributions: $&TOTAL.'');'
,p_link_target_type=>'REDIRECT_URL'
```

### Stock Chart

```sql
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(440683332704595849)
,p_region_id=>wwv_flow_imp.id(440682842203595846)
,p_chart_type=>'stock'
,p_data_cursor=>'on'
,p_data_cursor_behavior=>'smooth'
,p_hover_behavior=>'dim'
,p_stock_render_as=>'candlestick'
,p_zoom_and_scroll=>'delayed'
,p_initial_zooming=>'first'
,p_time_axis_type=>'auto'
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
);
```

### Gantt Chart

```sql
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(228015452571181249)
,p_region_id=>wwv_flow_imp.id(228015304285181248)
,p_chart_type=>'gantt'
,p_height=>'400'
,p_animation_on_display=>'none'
,p_horizontal_grid=>'visible'
,p_vertical_grid=>'visible'
,p_row_axis_rendered=>'on'
,p_gantt_axis_position=>'top'
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
,p_task_label_position=>'start'
);
```

**Gantt with baselines and viewports** -- additional series params:
```sql
,p_gantt_row_id=>'PARENT_TASK_ID'
,p_gantt_task_css_class=>'u-color-22'
,p_gantt_baseline_start_column=>'BASELINE_START'
,p_gantt_baseline_end_column=>'BASELINE_END'
,p_gantt_baseline_css_class=>'u-color-43'
,p_gantt_progress_css_class=>'u-color-11'
,p_gantt_viewport_start_source=>'ITEM'
,p_gantt_viewport_start_item=>'P3_START_DATE'
,p_gantt_viewport_end_source=>'ITEM'
,p_gantt_viewport_end_item=>'P3_END_DATE'
```

### Dial / Status Meter Gauge

```sql
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(43014841959174768)
,p_region_id=>wwv_flow_imp.id(43014735532174767)
,p_chart_type=>'dial'
,p_width=>'300'
,p_value_text_type=>'number'
,p_value_format_type=>'decimal'
,p_value_decimal_places=>0
,p_value_format_scaling=>'none'
,p_gauge_orientation=>'horizontal'         -- 'horizontal' | 'circular'
,p_gauge_indicator_size=>1
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
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
,p_items_max_value=>'MAX_VALUE'
,p_items_label_column_name=>'MY_LABEL'
,p_color=>'#FFFF00'
,p_gauge_plot_area_color=>'GRAY'
);
```

### Funnel Chart

```sql
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(250359702526247315)
,p_region_id=>wwv_flow_imp.id(250359459496247313)
,p_chart_type=>'funnel'
,p_width=>'500'
,p_height=>'400'
,p_value_format_type=>'decimal'
,p_value_decimal_places=>0
,p_value_format_scaling=>'auto'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function( options ){',
'    options.styleDefaults = { threeDEffect: "on" };',
'    return options;',
'}'))
);

-- Funnel with target value:
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
,p_items_target_value=>'TARGET_VAL'
,p_items_label_column_name=>'CUSTOMER'
,p_link_target=>'javascript:$s("P22_SERIES",''&CUSTOMER. Sales: $&QUANTITY., Target: $&TARGET_VAL.'');'
,p_link_target_type=>'REDIRECT_URL'
);
```

### Pyramid, Radar, Polar, Range, Box Plot

**Pyramid**: uses `p_chart_type=>'pyramid'`, `p_animation_on_display=>'alphaFade'`. 3D via JS: `options.styleDefaults = { threeDEffect: "on" };`

**Radar**: uses `p_chart_type=>'radar'`. Each series: `p_series_type=>'line'`.

**Polar**: uses `p_chart_type=>'polar'`, `p_stack=>'on'`. Each series: `p_series_type=>'lineWithArea'`, `p_group_name_column_name=>'PRODUCT_NAME'`, `p_line_type=>'curved'`.

**Range**: uses `p_chart_type=>'range'`. Series: `p_series_type=>'barRange'` or `'areaRange'`, `p_items_low_column_name`, `p_items_high_column_name`, `p_items_label_position=>'outsideBarEdge'`.

**Box Plot**: uses `p_chart_type=>'boxPlot'`. Series: `p_series_type=>'boxPlot'`, `p_items_value_column_name`. Optional: `p_q2_color`, `p_q3_color`, `p_time_axis_type=>'enabled'`.

## Series Parameters

| Parameter | Values | Notes |
|---|---|---|
| `p_data_source_type` | `'SQL'` | Always SQL |
| `p_location` | `null` or `'REGION_SOURCE'` | Per-series vs shared SQL |
| `p_series_name_column_name` | column name | Multi-series from single query |
| `p_items_value_column_name` | column name | Y / main value |
| `p_items_label_column_name` | column name | X-axis label |
| `p_items_short_desc_column_name` | column alias | Custom tooltip |
| `p_assigned_to_y2` | `'on'` / `'off'` | Secondary Y axis |
| `p_items_label_rendered` | `true` / `false` | Show data labels |
| `p_items_label_position` | `'auto'`, `'center'`, `'insideBarEdge'`, `'outsideBarEdge'`, `'aboveMarker'`, `'belowMarker'`, `'beforeMarker'`, `'afterMarker'`, `'none'` | Label position |
| `p_items_label_display_as` | `'PERCENT'`, `'LABEL'`, `'COMBO'`, `'ALL'` | Label content |
| `p_color` | hex color or `'&COLUMN_NAME.'` | Static or SQL-derived |
| `p_link_target` | URL or JS | Click action |
| `p_link_target_type` | `'REDIRECT_PAGE'`, `'REDIRECT_URL'` | Link type |

**Line-specific**: `p_line_style` (`solid`/`dotted`/`dashed`), `p_line_type` (`auto`/`straight`/`curved`/`stepped`/`centeredStepped`), `p_line_width` (int), `p_marker_rendered` (`on`/`off`/`auto`), `p_marker_shape` (`auto`/`star`/`plus`/`diamond`/`circle`).

**Label font**: `p_items_label_font_size`, `p_items_label_font_color`, `p_items_label_font_family`, `p_items_label_css_classes`.

**SQL-derived colors**: use `p_color=>'&COLORS.'` referencing a column alias from the query.

**Series with link**:
```sql
,p_link_target=>'f?p=&APP_ID.:29:&SESSION.:IG[emp]_emp_details:&DEBUG.:CR,:IG_DEPTNO:&DEPTNO.'
,p_link_target_type=>'REDIRECT_PAGE'
```

## Chart Axes

### Cartesian axes (x, y, y2)

```sql
-- X-axis:
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
,p_tick_label_rotation=>'auto'
,p_tick_label_position=>'outside'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);

-- Y-axis with title and formatting:
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(113186072521989760)
,p_chart_id=>wwv_flow_imp.id(113185588314989755)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_title=>'Y1 Axis Title'
,p_format_type=>'decimal'
,p_decimal_places=>0
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
);

-- Y2 axis (dual-Y):
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
,p_split_dual_y=>'on'
,p_splitter_position=>.7
);
```

**Axis font**: `p_title_font_family`, `p_title_font_style` (`normal`/`italic`/`oblique`), `p_title_font_size`, `p_title_font_color`, `p_tick_label_font_family`, `p_tick_label_font_style`, `p_tick_label_font_size`, `p_tick_label_font_color`.

**Stacked percent Y-axis**: `p_min=>0`, `p_max=>1`, `p_format_type=>'percent'`.

**Stock axes**: X uses `p_format_type=>'datetime-long'`. Y uses `p_format_type=>'currency'`, `p_baseline_scaling=>'min'`, `p_position=>'end'`.

**Y-axis with step**: `p_step=>1`, `p_min_step=>1`.

### Gantt axes (major/minor)

```sql
-- Major axis (months):
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(228015626718181251)
,p_chart_id=>wwv_flow_imp.id(228015452571181249)
,p_axis=>'major'
,p_is_rendered=>'on'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'auto'
,p_tick_label_rendered=>'on'
,p_axis_scale=>'months'
,p_zoom_order_days=>true
,p_zoom_order_weeks=>true
,p_zoom_order_months=>true
,p_zoom_order_quarters=>true
);

-- Minor axis (days):
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(228015758154181252)
,p_chart_id=>wwv_flow_imp.id(228015452571181249)
,p_axis=>'minor'
,p_baseline_scaling=>'zero'
,p_axis_scale=>'days'
,p_zoom_order_hours=>true
,p_zoom_order_days=>true
,p_zoom_order_weeks=>true
);
```

## JavaScript Customization (`p_javascript_code`)

All use chart-level `create_jet_chart`. Pattern: `function(options) { ... return options; }`

**Custom colors via dataFilter**:
```javascript
function( options ){
    options.dataFilter = function( data ) {
        data.series[ 0 ].items[0].color = "red";
        data.series[ 0 ].items[1].color = "blue";
        return data;
    };
    return options;
}
```

**3D effect** (funnel/pyramid):
```javascript
function( options ){
    options.styleDefaults = { threeDEffect: "on" };
    return options;
}
```

**Dynamic axis from page items**:
```javascript
function (options) {
    options.yAxis = { min: $v('P8_Y_MIN'), max: $v('P8_Y_MAX') };
    return options;
}
```

## Dynamic Actions on Charts

Change chart properties at runtime via `NATIVE_JAVASCRIPT_CODE`:
```javascript
// Toggle stack
apex.region("stackCategoryChart").widget().ojChart({stack: 'on'});
// Change orientation
apex.region("stackCategoryChart").widget().ojChart({orientation: 'horizontal'});
// Change chart type
apex.region("lineChart").widget().ojChart({type: 'bar'});
// Change line type
apex.region("area2").widget().ojChart({styleDefaults:{lineType:'curved'}});
// Toggle 3D
apex.region("pyramid1").widget().ojChart({styleDefaults: { 'threeDEffect': 'on' }});
```

## Tooltip Configuration

```sql
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
```

## Value Formatting (chart-level, funnel/pyramid/dial)

```sql
,p_value_format_type=>'decimal'     -- 'decimal' | 'currency' | 'percent'
,p_value_decimal_places=>0
,p_value_format_scaling=>'none'     -- 'none' | 'auto' | 'thousand' | 'million' | ...
```

## Enumerated Values

`p_chart_type`: `bar`, `line`, `area`, `combo`, `pie`, `donut`, `scatter`, `bubble`, `stock`, `gantt`, `dial`, `funnel`, `radar`, `polar`, `range`, `lineWithArea`, `pyramid`, `boxPlot`
`p_orientation`: `vertical`, `horizontal`
`p_animation_on_display`: `auto`, `none`, `alphaFade`
`p_animation_on_data_change`: `auto`, `none`
`p_data_cursor`: `auto`, `on`, `off`
`p_data_cursor_behavior`: `auto`, `smooth`
`p_hide_and_show_behavior`: `none`, `withRescale`, `withoutRescale`
`p_hover_behavior`: `none`, `dim`
`p_legend_position`: `auto`, `top`, `end`, `bottom`, `start`
`p_zoom_and_scroll`: `off`, `delayed`, `live`
`p_initial_zooming`: `none`, `first`, `last`
`p_time_axis_type`: `disabled`, `enabled`, `auto`
`p_sorting`: `label-asc`, `label-desc`
`p_stock_render_as`: `candlestick`
`p_format_type` (axis): `decimal`, `currency`, `percent`, `datetime-long`, `datetime-full`, `date-medium`
`p_format_scaling` (axis): `auto`, `none`, `thousand`, `million`, `billion`, `trillion`, `quadrillion`
`p_baseline_scaling` (axis): `zero`, `min`
`p_position` (axis): `auto`, `start`, `end`
`p_axis`: Cartesian: `x`, `y`, `y2` | Gantt: `major`, `minor`
`p_axis_scale` (gantt): `days`, `weeks`, `months`, `quarters`, `years`
`p_series_type`: `bar`, `line`, `area`, `lineWithArea`, `barRange`, `areaRange`, `boxPlot`
`p_line_style`: `solid`, `dotted`, `dashed`
`p_line_type`: `auto`, `straight`, `curved`, `stepped`, `centeredStepped`
`p_marker_rendered`: `auto`, `on`, `off`
`p_marker_shape`: `auto`, `star`, `plus`, `diamond`, `circle`
`p_items_label_position`: `auto`, `center`, `insideBarEdge`, `outsideBarEdge`, `aboveMarker`, `belowMarker`, `beforeMarker`, `afterMarker`, `none`
`p_items_label_display_as`: `PERCENT`, `LABEL`, `COMBO`, `ALL`
`p_gauge_orientation`: `horizontal`, `circular`
`p_value_text_type` (dial): `number`, `percent`
`p_task_label_position` (gantt): `start`, `innerStart`, `innerCenter`, `innerEnd`, `end`, `none`
`p_gantt_start_date_source` / `p_gantt_end_date_source`: `DB_COLUMN`, `ITEM`
`p_gantt_viewport_start_source` / `p_gantt_viewport_end_source`: `DB_COLUMN`, `ITEM`
