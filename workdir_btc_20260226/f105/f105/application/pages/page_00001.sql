prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
--     REGION: Summary Cards Container
--     REGION: Current Price
--     REGION: 24h Change
--     REGION: 30-Day High
--     REGION: 30-Day Low
--     REGION: BTC Price (30 Days)
--     REGION: Trading Volume (30 Days)
--     REGION: Price History
--     PAGE ITEM: P1_CURRENT_PRICE
--     PAGE ITEM: P1_24H_CHANGE
--     PAGE ITEM: P1_30D_HIGH
--     PAGE ITEM: P1_30D_LOW
--     PAGE PROCESS: Load Summary Metrics
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.0'
,p_default_workspace_id=>7059346057325215
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'AI'
);
end;
/
begin
wwv_flow_imp_page.create_page(
 p_id=>1
,p_name=>'Home'
,p_alias=>'HOME'
,p_step_title=>'test-ai'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'13'
);
end;
/
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(100)
,p_plug_name=>'Summary Cards Container'
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_STATIC'
,p_plug_template=>wwv_flow_imp.id(2072724515482255512)
,p_region_template_options=>'#DEFAULT#'
);
end;
/
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(200)
,p_plug_name=>'Current Price'
,p_parent_plug_id=>wwv_flow_imp.id(100)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_source_type=>'NATIVE_STATIC'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-ContentBlock">',
'<h3 class="t-ContentBlock-title">Current Price</h3>',
'<div class="t-ContentBlock-body" style="font-size:24px;font-weight:bold">&P1_CURRENT_PRICE.</div>',
'</div>'))
,p_plug_template=>wwv_flow_imp.id(4501440665235496320)
,p_region_template_options=>'#DEFAULT#'
);
end;
/
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(300)
,p_plug_name=>'24h Change'
,p_parent_plug_id=>wwv_flow_imp.id(100)
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_source_type=>'NATIVE_STATIC'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-ContentBlock">',
'<h3 class="t-ContentBlock-title">24h Change</h3>',
'<div class="t-ContentBlock-body" style="font-size:24px;font-weight:bold">&P1_24H_CHANGE.</div>',
'</div>'))
,p_plug_template=>wwv_flow_imp.id(4501440665235496320)
,p_region_template_options=>'#DEFAULT#'
);
end;
/
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(400)
,p_plug_name=>'30-Day High'
,p_parent_plug_id=>wwv_flow_imp.id(100)
,p_plug_display_sequence=>30
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_source_type=>'NATIVE_STATIC'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-ContentBlock">',
'<h3 class="t-ContentBlock-title">30-Day High</h3>',
'<div class="t-ContentBlock-body" style="font-size:24px;font-weight:bold">&P1_30D_HIGH.</div>',
'</div>'))
,p_plug_template=>wwv_flow_imp.id(4501440665235496320)
,p_region_template_options=>'#DEFAULT#'
);
end;
/
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(500)
,p_plug_name=>'30-Day Low'
,p_parent_plug_id=>wwv_flow_imp.id(100)
,p_plug_display_sequence=>40
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_source_type=>'NATIVE_STATIC'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-ContentBlock">',
'<h3 class="t-ContentBlock-title">30-Day Low</h3>',
'<div class="t-ContentBlock-body" style="font-size:24px;font-weight:bold">&P1_30D_LOW.</div>',
'</div>'))
,p_plug_template=>wwv_flow_imp.id(4501440665235496320)
,p_region_template_options=>'#DEFAULT#'
);
end;
/
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1100)
,p_plug_name=>'BTC Price (30 Days)'
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_template=>wwv_flow_imp.id(4072358936313175081)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_new_grid_row=>true
,p_plug_grid_column_span=>6
);
end;
/
begin
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(1200)
,p_region_id=>wwv_flow_imp.id(1100)
,p_chart_type=>'lineWithArea'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_connect_nulls=>'Y'
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_show_label=>true
,p_legend_rendered=>'off'
);
end;
/
begin
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(1300)
,p_chart_id=>wwv_flow_imp.id(1200)
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
);
end;
/
begin
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(1400)
,p_chart_id=>wwv_flow_imp.id(1200)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_title=>'Price (USD)'
,p_format_type=>'decimal'
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
begin
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(1500)
,p_chart_id=>wwv_flow_imp.id(1200)
,p_seq=>10
,p_name=>'Close Price'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT price_date, close_price',
'FROM btc_prices',
'ORDER BY price_date'))
,p_items_value_column_name=>'CLOSE_PRICE'
,p_items_label_column_name=>'PRICE_DATE'
);
end;
/
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1600)
,p_plug_name=>'Trading Volume (30 Days)'
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_template=>wwv_flow_imp.id(4072358936313175081)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>6
);
end;
/
begin
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(1700)
,p_region_id=>wwv_flow_imp.id(1600)
,p_chart_type=>'bar'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_connect_nulls=>'Y'
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_show_label=>true
,p_legend_rendered=>'off'
);
end;
/
begin
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(1800)
,p_chart_id=>wwv_flow_imp.id(1700)
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
);
end;
/
begin
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(1900)
,p_chart_id=>wwv_flow_imp.id(1700)
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
begin
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(2000)
,p_chart_id=>wwv_flow_imp.id(1700)
,p_seq=>10
,p_name=>'Volume'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT price_date, volume',
'FROM btc_prices',
'ORDER BY price_date'))
,p_items_value_column_name=>'VOLUME'
,p_items_label_column_name=>'PRICE_DATE'
);
end;
/
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(2100)
,p_plug_name=>'Price History'
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_IR'
,p_plug_template=>wwv_flow_imp.id(4072358936313175081)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT price_date,',
'       open_price,',
'       high_price,',
'       low_price,',
'       close_price,',
'       volume',
'FROM btc_prices'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_query_show_nulls_as=>' - '
);
end;
/
begin
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(2200)
,p_name=>'Price History'
,p_max_row_count=>'100'
,p_no_data_found_message=>'No price data found.'
,p_show_search_bar=>'Y'
,p_show_detail_link=>'N'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'NONE'
,p_lazy_loading=>false
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML'
);
end;
/
begin
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(2300)
,p_db_column_name=>'PRICE_DATE'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
end;
/
begin
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(2400)
,p_db_column_name=>'OPEN_PRICE'
,p_display_order=>20
,p_column_identifier=>'B'
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
 p_id=>wwv_flow_imp.id(2500)
,p_db_column_name=>'HIGH_PRICE'
,p_display_order=>30
,p_column_identifier=>'C'
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
 p_id=>wwv_flow_imp.id(2600)
,p_db_column_name=>'LOW_PRICE'
,p_display_order=>40
,p_column_identifier=>'D'
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
 p_id=>wwv_flow_imp.id(2700)
,p_db_column_name=>'CLOSE_PRICE'
,p_display_order=>50
,p_column_identifier=>'E'
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
 p_id=>wwv_flow_imp.id(2800)
,p_db_column_name=>'VOLUME'
,p_display_order=>60
,p_column_identifier=>'F'
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
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(2900)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_type=>'REPORT'
,p_report_alias=>'29001'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>50
,p_view_mode=>'REPORT'
,p_report_columns=>'PRICE_DATE:OPEN_PRICE:HIGH_PRICE:LOW_PRICE:CLOSE_PRICE:VOLUME'
,p_sort_column_1=>'PRICE_DATE'
,p_sort_direction_1=>'DESC'
);
end;
/
begin
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(600)
,p_name=>'P1_CURRENT_PRICE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(100)
,p_display_as=>'NATIVE_HIDDEN'
,p_field_template=>wwv_flow_imp.id(2040785906935475274)
,p_item_template_options=>'#DEFAULT#'
,p_source_type=>'ALWAYS_NULL'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
end;
/
begin
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(700)
,p_name=>'P1_24H_CHANGE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(100)
,p_display_as=>'NATIVE_HIDDEN'
,p_field_template=>wwv_flow_imp.id(2040785906935475274)
,p_item_template_options=>'#DEFAULT#'
,p_source_type=>'ALWAYS_NULL'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
end;
/
begin
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(800)
,p_name=>'P1_30D_HIGH'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(100)
,p_display_as=>'NATIVE_HIDDEN'
,p_field_template=>wwv_flow_imp.id(2040785906935475274)
,p_item_template_options=>'#DEFAULT#'
,p_source_type=>'ALWAYS_NULL'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
end;
/
begin
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(900)
,p_name=>'P1_30D_LOW'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(100)
,p_display_as=>'NATIVE_HIDDEN'
,p_field_template=>wwv_flow_imp.id(2040785906935475274)
,p_item_template_options=>'#DEFAULT#'
,p_source_type=>'ALWAYS_NULL'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
end;
/
begin
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(1000)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load Summary Metrics'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_curr NUMBER;',
'  l_prev NUMBER;',
'  l_change NUMBER;',
'  l_pct NUMBER;',
'BEGIN',
'  SELECT close_price INTO l_curr FROM btc_prices WHERE price_date = (SELECT MAX(price_date) FROM btc_prices);',
'  BEGIN',
'    SELECT close_price INTO l_prev FROM btc_prices WHERE price_date = (SELECT MAX(price_date) - 1 FROM btc_prices);',
'  EXCEPTION WHEN NO_DATA_FOUND THEN l_prev := l_curr;',
'  END;',
'  l_change := l_curr - l_prev;',
'  l_pct := CASE WHEN l_prev != 0 THEN (l_change / l_prev) * 100 ELSE 0 END;',
'  :P1_CURRENT_PRICE := TO_CHAR(l_curr, ''FML999G999G999G999D00'');',
'  IF l_change >= 0 THEN',
'    :P1_24H_CHANGE := ''<span style="color:green">+'' || TO_CHAR(l_change,''FM999G999D00'') || '' (+'' || TO_CHAR(l_pct,''FM990.0'') || ''%)</span>'';',
'  ELSE',
'    :P1_24H_CHANGE := ''<span style="color:red">'' || TO_CHAR(l_change,''FM999G999D00'') || '' ('' || TO_CHAR(l_pct,''FM990.0'') || ''%)</span>'';',
'  END IF;',
'  SELECT TO_CHAR(MAX(high_price), ''FML999G999G999G999D00'') INTO :P1_30D_HIGH FROM btc_prices;',
'  SELECT TO_CHAR(MIN(low_price), ''FML999G999G999G999D00'') INTO :P1_30D_LOW FROM btc_prices;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
end;
/
begin
wwv_flow_imp.component_end;
end;
/
