prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
--     REGION: Bitcoin Dashboard Tabs
--     REGION: Overview
--     REGION: Bitcoin Metrics
--     REGION: Period Selector
--     REGION: Candlestick Chart
--     REGION: Volume Chart (90 Days)
--     REGION: Technical
--     REGION: Period Selector
--     REGION: Price & Moving Averages
--     REGION: History
--     REGION: Price History
--     PAGE ITEM: P1_PERIOD
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.0'
,p_default_workspace_id=>5891473009157754
,p_default_application_id=>129
,p_default_id_offset=>0
,p_default_owner=>'AI'
);
wwv_flow_imp_page.create_page(
 p_id=>1
,p_name=>'Bitcoin Dashboard'
,p_alias=>'HOME'
,p_step_title=>'Bitcoin Dashboard'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'13'
);
end;
/
-- Tabs Container
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(8510074730755100)
,p_plug_name=>'Bitcoin Dashboard Tabs'
,p_region_template_options=>'#DEFAULT#:js-useLocalStorage:t-TabsRegion-mod--pill'
,p_plug_template=>3223171818405608528
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_source_type=>'NATIVE_DISPLAY_SELECTOR'
,p_plug_query_num_rows=>15
);
end;
/
-- Tab 1: Overview
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(8510074730755200)
,p_plug_name=>'Overview'
,p_parent_plug_id=>wwv_flow_imp.id(8510074730755100)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_query_num_rows=>15
);
end;
/
-- Tab 1 > Cards region
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(8510074730755210)
,p_plug_name=>'Bitcoin Metrics'
,p_parent_plug_id=>wwv_flow_imp.id(8510074730755200)
,p_region_template_options=>'#DEFAULT#:t-CardsRegion--styleA'
,p_plug_template=>2072724515482255512
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'  TO_CHAR(curr.close_price, ''FML999G999G999D00'') AS current_price,',
'  TO_CHAR(curr.close_price - prev.close_price, ''FML999G999G999D00'') AS price_change,',
'  ROUND((curr.close_price - prev.close_price) / prev.close_price * 100, 2) AS pct_change,',
'  CASE WHEN curr.close_price >= prev.close_price THEN ''u-color-9'' ELSE ''u-color-31'' END AS change_css,',
'  ''$'' || TO_CHAR(curr.market_cap / 1e12, ''FM0D00'') || ''T'' AS market_cap_fmt,',
'  ''$'' || TO_CHAR(curr.volume / 1e9, ''FM990D00'') || ''B'' AS volume_fmt',
'FROM btc_price_history curr',
'JOIN btc_price_history prev ON prev.price_date = (',
'  SELECT MAX(price_date) FROM btc_price_history WHERE price_date < curr.price_date',
')',
'WHERE curr.price_date = (SELECT MAX(price_date) FROM btc_price_history)'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_CARDS'
,p_plug_query_num_rows_type=>'SCROLL'
,p_show_total_row_count=>true
);
end;
/
begin
wwv_flow_imp_page.create_card(
 p_id=>wwv_flow_imp.id(8510074730755211)
,p_region_id=>wwv_flow_imp.id(8510074730755210)
,p_layout_type=>'GRID'
,p_grid_column_count=>4
,p_title_adv_formatting=>true
,p_title_html_expr=>'&CURRENT_PRICE.'
,p_sub_title_adv_formatting=>true
,p_sub_title_html_expr=>'<span class="&CHANGE_CSS.">Change: &PRICE_CHANGE. (&PCT_CHANGE.%)</span>'
,p_body_adv_formatting=>true
,p_body_html_expr=>'Market Cap: &MARKET_CAP_FMT.'
,p_second_body_adv_formatting=>true
,p_second_body_html_expr=>'Volume: &VOLUME_FMT.'
,p_media_adv_formatting=>false
);
end;
/
-- Tab 1 > Period Selector
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(8510074730755220)
,p_plug_name=>'Period Selector'
,p_parent_plug_id=>wwv_flow_imp.id(8510074730755200)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-ButtonRegion" style="margin-bottom:8px;">',
'  <button class="t-Button t-Button--small js-period-btn" data-period="7">7D</button>',
'  <button class="t-Button t-Button--small js-period-btn" data-period="30">30D</button>',
'  <button class="t-Button t-Button--small t-Button--hot js-period-btn" data-period="90">90D</button>',
'  <button class="t-Button t-Button--small js-period-btn" data-period="365">1Y</button>',
'  <button class="t-Button t-Button--small js-period-btn" data-period="ALL">ALL</button>',
'</div>'))
,p_plug_query_num_rows=>15
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML',
  'show_line_breaks', 'Y')).to_clob
);
end;
/
-- Tab 1 > Candlestick Chart
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(8510074730755230)
,p_plug_name=>'Candlestick Chart'
,p_parent_plug_id=>wwv_flow_imp.id(8510074730755200)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>30
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_ajax_items_to_submit=>'P1_PERIOD'
);
end;
/
begin
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(8510074730755231)
,p_region_id=>wwv_flow_imp.id(8510074730755230)
,p_chart_type=>'stock'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_data_cursor=>'on'
,p_data_cursor_behavior=>'smooth'
,p_hover_behavior=>'dim'
,p_stock_render_as=>'candlestick'
,p_zoom_and_scroll=>'delayed'
,p_initial_zooming=>'first'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_show_label=>true
,p_legend_rendered=>'off'
,p_overview_rendered=>'off'
,p_time_axis_type=>'enabled'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
);
end;
/
begin
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(8510074730755232)
,p_chart_id=>wwv_flow_imp.id(8510074730755231)
,p_seq=>10
,p_name=>'BTC'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT NULL link, price_date label,',
'       open_price, low_price, high_price, close_price, volume',
'FROM btc_price_history',
'WHERE (:P1_PERIOD = ''ALL'' OR price_date >= SYSDATE - TO_NUMBER(DECODE(:P1_PERIOD, ''ALL'', ''99999'', :P1_PERIOD)))',
'ORDER BY price_date'))
,p_items_low_column_name=>'LOW_PRICE'
,p_items_high_column_name=>'HIGH_PRICE'
,p_items_open_column_name=>'OPEN_PRICE'
,p_items_close_column_name=>'CLOSE_PRICE'
,p_items_volume_column_name=>'VOLUME'
,p_items_label_column_name=>'LABEL'
);
end;
/
begin
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(8510074730755233)
,p_chart_id=>wwv_flow_imp.id(8510074730755231)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_format_type=>'datetime-short'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_tick_label_rotation=>'auto'
,p_tick_label_position=>'outside'
);
end;
/
begin
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(8510074730755234)
,p_chart_id=>wwv_flow_imp.id(8510074730755231)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_title=>'Price (USD)'
,p_format_type=>'currency'
,p_decimal_places=>0
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'min'
,p_position=>'auto'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
);
end;
/
-- Tab 1 > Volume Bar Chart
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(8510074730755240)
,p_plug_name=>'Volume Chart (90 Days)'
,p_parent_plug_id=>wwv_flow_imp.id(8510074730755200)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>40
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_ajax_items_to_submit=>'P1_PERIOD'
);
end;
/
begin
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(8510074730755241)
,p_region_id=>wwv_flow_imp.id(8510074730755240)
,p_chart_type=>'bar'
,p_height=>'250'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_connect_nulls=>'Y'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'delayed'
,p_initial_zooming=>'first'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_show_label=>true
,p_legend_rendered=>'off'
,p_overview_rendered=>'off'
,p_time_axis_type=>'enabled'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
);
end;
/
begin
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(8510074730755242)
,p_chart_id=>wwv_flow_imp.id(8510074730755241)
,p_seq=>10
,p_name=>'Volume'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT price_date, volume',
'FROM btc_price_history',
'WHERE (:P1_PERIOD = ''ALL'' OR price_date >= SYSDATE - TO_NUMBER(DECODE(:P1_PERIOD, ''ALL'', ''99999'', :P1_PERIOD)))',
'ORDER BY price_date'))
,p_items_value_column_name=>'VOLUME'
,p_items_label_column_name=>'PRICE_DATE'
,p_color=>'#4A90D9'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
end;
/
begin
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(8510074730755243)
,p_chart_id=>wwv_flow_imp.id(8510074730755241)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_format_type=>'datetime-short'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_tick_label_rotation=>'auto'
,p_tick_label_position=>'outside'
);
end;
/
begin
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(8510074730755244)
,p_chart_id=>wwv_flow_imp.id(8510074730755241)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_title=>'Volume (USD)'
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
end;
/
-- Tab 2: Technical
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(8510074730755300)
,p_plug_name=>'Technical'
,p_parent_plug_id=>wwv_flow_imp.id(8510074730755100)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_query_num_rows=>15
);
end;
/
-- Tab 2 > Period Selector
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(8510074730755310)
,p_plug_name=>'Period Selector'
,p_parent_plug_id=>wwv_flow_imp.id(8510074730755300)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-ButtonRegion" style="margin-bottom:8px;">',
'  <button class="t-Button t-Button--small js-period-btn" data-period="7">7D</button>',
'  <button class="t-Button t-Button--small js-period-btn" data-period="30">30D</button>',
'  <button class="t-Button t-Button--small t-Button--hot js-period-btn" data-period="90">90D</button>',
'  <button class="t-Button t-Button--small js-period-btn" data-period="365">1Y</button>',
'  <button class="t-Button t-Button--small js-period-btn" data-period="ALL">ALL</button>',
'</div>'))
,p_plug_query_num_rows=>15
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML',
  'show_line_breaks', 'Y')).to_clob
);
end;
/
-- Tab 2 > MA Line Chart
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(8510074730755320)
,p_plug_name=>'Price & Moving Averages'
,p_parent_plug_id=>wwv_flow_imp.id(8510074730755300)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_ajax_items_to_submit=>'P1_PERIOD'
);
end;
/
begin
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(8510074730755321)
,p_region_id=>wwv_flow_imp.id(8510074730755320)
,p_chart_type=>'line'
,p_height=>'450'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_connect_nulls=>'Y'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'delayed'
,p_initial_zooming=>'first'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_show_label=>true
,p_legend_rendered=>'on'
,p_legend_position=>'top'
,p_overview_rendered=>'off'
,p_time_axis_type=>'enabled'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
);
end;
/
begin
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(8510074730755322)
,p_chart_id=>wwv_flow_imp.id(8510074730755321)
,p_seq=>10
,p_name=>'Close Price'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT price_date, close_price',
'FROM v_btc_moving_averages',
'WHERE (:P1_PERIOD = ''ALL'' OR price_date >= SYSDATE - TO_NUMBER(DECODE(:P1_PERIOD, ''ALL'', ''99999'', :P1_PERIOD)))',
'ORDER BY price_date'))
,p_items_value_column_name=>'CLOSE_PRICE'
,p_items_label_column_name=>'PRICE_DATE'
,p_color=>'#F7931A'
,p_line_style=>'solid'
,p_line_type=>'auto'
,p_marker_rendered=>'off'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
end;
/
begin
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(8510074730755323)
,p_chart_id=>wwv_flow_imp.id(8510074730755321)
,p_seq=>20
,p_name=>'MA-7'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT price_date, ma_7',
'FROM v_btc_moving_averages',
'WHERE (:P1_PERIOD = ''ALL'' OR price_date >= SYSDATE - TO_NUMBER(DECODE(:P1_PERIOD, ''ALL'', ''99999'', :P1_PERIOD)))',
'ORDER BY price_date'))
,p_items_value_column_name=>'MA_7'
,p_items_label_column_name=>'PRICE_DATE'
,p_color=>'#2ECC71'
,p_line_style=>'dashed'
,p_line_type=>'auto'
,p_marker_rendered=>'off'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
end;
/
begin
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(8510074730755324)
,p_chart_id=>wwv_flow_imp.id(8510074730755321)
,p_seq=>30
,p_name=>'MA-30'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT price_date, ma_30',
'FROM v_btc_moving_averages',
'WHERE (:P1_PERIOD = ''ALL'' OR price_date >= SYSDATE - TO_NUMBER(DECODE(:P1_PERIOD, ''ALL'', ''99999'', :P1_PERIOD)))',
'ORDER BY price_date'))
,p_items_value_column_name=>'MA_30'
,p_items_label_column_name=>'PRICE_DATE'
,p_color=>'#E74C3C'
,p_line_style=>'dashed'
,p_line_type=>'auto'
,p_marker_rendered=>'off'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
end;
/
begin
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(8510074730755325)
,p_chart_id=>wwv_flow_imp.id(8510074730755321)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_format_type=>'datetime-short'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_tick_label_rotation=>'auto'
,p_tick_label_position=>'outside'
);
end;
/
begin
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(8510074730755326)
,p_chart_id=>wwv_flow_imp.id(8510074730755321)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_title=>'Price (USD)'
,p_format_type=>'currency'
,p_decimal_places=>0
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'min'
,p_position=>'auto'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
);
end;
/
-- Tab 3: History
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(8510074730755400)
,p_plug_name=>'History'
,p_parent_plug_id=>wwv_flow_imp.id(8510074730755100)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>30
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_query_num_rows=>15
);
end;
/
-- Tab 3 > IR
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(8510074730755410)
,p_plug_name=>'Price History'
,p_parent_plug_id=>wwv_flow_imp.id(8510074730755400)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT id, price_date, open_price, high_price, low_price, close_price, volume, market_cap',
'FROM btc_price_history',
'ORDER BY price_date DESC'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_show_nulls_as=>' - '
,p_pagination_display_position=>'BOTTOM_RIGHT'
);
end;
/
begin
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(8510074730755411)
,p_name=>'Price History'
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
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_show_calendar=>'N'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'AI'
,p_internal_uid=>8510074730755411
);
end;
/
begin
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(8510074730755412)
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
end;
/
begin
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(8510074730755413)
,p_db_column_name=>'PRICE_DATE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
end;
/
begin
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(8510074730755414)
,p_db_column_name=>'OPEN_PRICE'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Open'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
end;
/
begin
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(8510074730755415)
,p_db_column_name=>'HIGH_PRICE'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'High'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
end;
/
begin
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(8510074730755416)
,p_db_column_name=>'LOW_PRICE'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Low'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
end;
/
begin
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(8510074730755417)
,p_db_column_name=>'CLOSE_PRICE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Close'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
end;
/
begin
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(8510074730755418)
,p_db_column_name=>'VOLUME'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Volume'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
end;
/
begin
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(8510074730755419)
,p_db_column_name=>'MARKET_CAP'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Market Cap'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G990D00'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
end;
/
begin
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(8510074730755420)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_type=>'REPORT'
,p_report_alias=>'85100755'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>15
,p_view_mode=>'REPORT'
,p_report_columns=>'PRICE_DATE:OPEN_PRICE:HIGH_PRICE:LOW_PRICE:CLOSE_PRICE:VOLUME:MARKET_CAP'
,p_sort_column_1=>'PRICE_DATE'
,p_sort_direction_1=>'DESC'
);
end;
/
-- Hidden item: P1_PERIOD
begin
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(8510074730755000)
,p_name=>'P1_PERIOD'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(8510074730755100)
,p_item_default=>'90'
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
end;
/
-- DA: Period Button Click
begin
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(8510074730755500)
,p_name=>'Period Button Click'
,p_event_sequence=>10
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.js-period-btn'
,p_bind_type=>'live'
,p_bind_delegate_to_selector=>'body'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
end;
/
-- DA Action 1: Execute JS (set item + toggle active)
begin
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(8510074730755501)
,p_event_id=>wwv_flow_imp.id(8510074730755500)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var val = $(this.triggeringElement).data(''period'').toString();',
'$s(''P1_PERIOD'', val);',
'$(''.js-period-btn'').removeClass(''t-Button--hot'');',
'$(this.triggeringElement).addClass(''t-Button--hot'');'))
);
end;
/
-- DA Action 2: Refresh candlestick chart
begin
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(8510074730755502)
,p_event_id=>wwv_flow_imp.id(8510074730755500)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(8510074730755230)
,p_attribute_01=>'N'
);
end;
/
-- DA Action 3: Refresh volume chart
begin
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(8510074730755503)
,p_event_id=>wwv_flow_imp.id(8510074730755500)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(8510074730755240)
,p_attribute_01=>'N'
);
end;
/
-- DA Action 4: Refresh MA chart
begin
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(8510074730755504)
,p_event_id=>wwv_flow_imp.id(8510074730755500)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(8510074730755320)
,p_attribute_01=>'N'
);
end;
/
begin
wwv_flow_imp.component_end;
end;
/
