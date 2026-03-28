prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
--     REGION: Bitcoin Metrics
--     REGION: Price Chart (90 Days)
--     REGION: Volume Chart (90 Days)
--     REGION: Price History
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
-- Region 1: Key Metrics (Cards)
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(8510074730754300)
,p_plug_name=>'Bitcoin Metrics'
,p_region_template_options=>'#DEFAULT#:t-CardsRegion--styleA'
,p_plug_template=>2072724515482255512
,p_plug_display_sequence=>10
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
 p_id=>wwv_flow_imp.id(8510074730754301)
,p_region_id=>wwv_flow_imp.id(8510074730754300)
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
-- Region 2: Price Chart (JET Line)
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(8510074730754400)
,p_plug_name=>'Price Chart (90 Days)'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_location=>null
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
);
end;
/
begin
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(8510074730754401)
,p_region_id=>wwv_flow_imp.id(8510074730754400)
,p_chart_type=>'line'
,p_height=>'400'
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
 p_id=>wwv_flow_imp.id(8510074730754402)
,p_chart_id=>wwv_flow_imp.id(8510074730754401)
,p_seq=>10
,p_name=>'Close Price'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT price_date, close_price',
'FROM btc_price_history',
'WHERE price_date >= ADD_MONTHS(SYSDATE, -3)',
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
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(8510074730754403)
,p_chart_id=>wwv_flow_imp.id(8510074730754401)
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
 p_id=>wwv_flow_imp.id(8510074730754404)
,p_chart_id=>wwv_flow_imp.id(8510074730754401)
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
-- Region 3: Volume Chart (JET Bar)
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(8510074730754500)
,p_plug_name=>'Volume Chart (90 Days)'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>30
,p_location=>null
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
);
end;
/
begin
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(8510074730754501)
,p_region_id=>wwv_flow_imp.id(8510074730754500)
,p_chart_type=>'bar'
,p_height=>'300'
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
 p_id=>wwv_flow_imp.id(8510074730754502)
,p_chart_id=>wwv_flow_imp.id(8510074730754501)
,p_seq=>10
,p_name=>'Volume'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT price_date, volume',
'FROM btc_price_history',
'WHERE price_date >= ADD_MONTHS(SYSDATE, -3)',
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
 p_id=>wwv_flow_imp.id(8510074730754503)
,p_chart_id=>wwv_flow_imp.id(8510074730754501)
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
 p_id=>wwv_flow_imp.id(8510074730754504)
,p_chart_id=>wwv_flow_imp.id(8510074730754501)
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
-- Region 4: Price History (Interactive Report)
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(8510074730754600)
,p_plug_name=>'Price History'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>40
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
 p_id=>wwv_flow_imp.id(8510074730754601)
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
,p_internal_uid=>8510074730754601
);
end;
/
begin
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(8510074730754602)
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
 p_id=>wwv_flow_imp.id(8510074730754603)
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
 p_id=>wwv_flow_imp.id(8510074730754604)
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
 p_id=>wwv_flow_imp.id(8510074730754605)
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
 p_id=>wwv_flow_imp.id(8510074730754606)
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
 p_id=>wwv_flow_imp.id(8510074730754607)
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
 p_id=>wwv_flow_imp.id(8510074730754608)
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
 p_id=>wwv_flow_imp.id(8510074730754609)
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
 p_id=>wwv_flow_imp.id(8510074730754610)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_type=>'REPORT'
,p_report_alias=>'85100748'
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
wwv_flow_imp.component_end;
end;
/
