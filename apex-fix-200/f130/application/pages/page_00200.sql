prompt --application/pages/page_00200
begin
--   Manifest
--     PAGE: 00200
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.0'
,p_default_workspace_id=>11463542144185047
,p_default_application_id=>130
,p_default_id_offset=>11464758831189420
,p_default_owner=>'DVC'
);
wwv_flow_imp_page.create_page(
 p_id=>200
,p_name=>'Inventory Dashboard'
,p_alias=>'INVENTORY-DASHBOARD'
,p_step_title=>'Inventory Dashboard'
,p_reload_on_submit=>'A'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'ON'
,p_group_id=>wwv_flow_imp.id(20100000000000000001)
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(15992123938373047193)
,p_protection_level=>'C'
,p_page_component_map=>'25'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(20000000000000000010)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(17865586300496079727)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(20000000000000000020)
,p_plug_name=>'Inventory Summary'
,p_region_name=>'INV_SUMMARY'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader js-addHiddenHeadingRoleDesc:t-Region--hiddenOverflow'
,p_escape_on_http_output=>'Y'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT label, value, url FROM (',
'SELECT 1 AS display_order,',
'       ''Total Products'' AS label,',
'       TO_CHAR(COUNT(*)) AS value,',
'       apex_page.get_url(p_page => 201) AS url',
'  FROM eba_cust_amzn_products',
' WHERE is_active = ''Y''',
'UNION ALL',
'SELECT 2,',
'       ''Total Stock Value'',',
'       ''$'' || TO_CHAR(NVL(SUM(qty_on_hand * amazon_price), 0), ''FM999,999,990.00''),',
'       apex_page.get_url(p_page => 203)',
'  FROM eba_cust_amzn_balance_v',
'UNION ALL',
'SELECT 3,',
'       ''Low Stock (< 5)'',',
'       TO_CHAR(COUNT(*)),',
'       apex_page.get_url(p_page => 203)',
'  FROM eba_cust_amzn_balance_v',
' WHERE qty_on_hand < 5',
'UNION ALL',
'SELECT 4,',
'       ''Last Sync'',',
'       NVL(TO_CHAR(MAX(sync_date), ''DD-MON HH24:MI''), ''Never''),',
'       NULL',
'  FROM eba_cust_amzn_sync_log',
' WHERE status = ''SUCCESS''',
') ORDER BY display_order'))
,p_plug_source_type=>'PLUGIN_COM.ORACLE.APEX.BADGE_LIST'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'attribute_01', 'LABEL',
  'attribute_02', 'VALUE',
  'attribute_04', '&URL.',
  'attribute_05', '4',
  'attribute_07', 'BOX',
  'attribute_08', 'N')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(20000000000000000030)
,p_plug_name=>'Products'
,p_region_name=>'STOCK_BALANCES'
,p_region_template_options=>'#DEFAULT#:t-CardsRegion--styleA'
,p_plug_template=>2072724515482255512
,p_plug_display_sequence=>40
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT id,',
'       product_name,',
'       asin,',
'       category,',
'       image_url,',
'       ''$'' || TO_CHAR(amazon_price, ''FM999,990.00'') AS price_display,',
'       qty_on_hand,',
'       ''$'' || TO_CHAR(total_value, ''FM999,990.00'') AS value_display',
'  FROM eba_cust_amzn_balance_v',
' ORDER BY amazon_rank NULLS LAST'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_CARDS'
,p_plug_query_num_rows_type=>'SCROLL'
,p_plug_query_no_data_found=>'No products synced yet. Use Amazon Products page to sync.'
,p_no_data_found_icon_classes=>'fa-warning fa-lg'
,p_show_total_row_count=>true
,p_pagination_display_position=>'BOTTOM_RIGHT'
);
wwv_flow_imp_page.create_card(
 p_id=>wwv_flow_imp.id(20000000000000000060)
,p_region_id=>wwv_flow_imp.id(20000000000000000030)
,p_layout_type=>'GRID'
,p_title_adv_formatting=>false
,p_title_column_name=>'PRODUCT_NAME'
,p_sub_title_adv_formatting=>false
,p_sub_title_column_name=>'ASIN'
,p_body_adv_formatting=>true
,p_body_html_expr=>wwv_flow_string.join(wwv_flow_t_varchar2(
'{if CATEGORY/}&CATEGORY!HTML.<br/>{endif/}',
'&PRICE_DISPLAY!HTML.',
'{if VALUE_DISPLAY/} &bull; Value: &VALUE_DISPLAY!HTML.{endif/}'))
,p_second_body_adv_formatting=>false
,p_icon_source_type=>'INITIALS'
,p_icon_class_column_name=>'PRODUCT_NAME'
,p_icon_position=>'TOP'
,p_badge_column_name=>'QTY_ON_HAND'
,p_badge_label=>'Qty: '
,p_media_adv_formatting=>false
,p_media_source_type=>'STATIC_URL'
,p_media_url=>'&IMAGE_URL!ATTR.'
,p_media_display_position=>'FIRST'
,p_media_appearance=>'WIDESCREEN'
,p_media_sizing=>'FIT'
,p_media_description=>'&PRODUCT_NAME!ATTR.'
);
wwv_flow_imp_page.create_card_action(
 p_id=>wwv_flow_imp.id(20000000000000000061)
,p_card_id=>wwv_flow_imp.id(20000000000000000060)
,p_action_type=>'FULL_CARD'
,p_display_sequence=>10
,p_link_target_type=>'REDIRECT_PAGE'
,p_link_target=>'f?p=&APP_ID.:202:&SESSION.::&DEBUG.:202:P202_ID:&ID.'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(20000000000000000070)
,p_plug_name=>'Stock by Product'
,p_region_name=>'STOCK_CHART'
,p_region_css_classes=>'scrollable-region'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:i-h320:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>30
,p_location=>null
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(20000000000000000071)
,p_region_id=>wwv_flow_imp.id(20000000000000000070)
,p_chart_type=>'bar'
,p_animation_on_display=>'none'
,p_animation_on_data_change=>'none'
,p_orientation=>'horizontal'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'none'
,p_stack=>'off'
,p_stack_label=>'off'
,p_spark_chart=>'N'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
,p_sorting=>'value-desc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>false
,p_show_group_name=>true
,p_show_value=>true
,p_show_label=>true
,p_show_row=>true
,p_show_start=>true
,p_show_end=>true
,p_show_progress=>true
,p_show_baseline=>true
,p_legend_rendered=>'off'
,p_legend_position=>'auto'
,p_overview_rendered=>'off'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(20000000000000000072)
,p_chart_id=>wwv_flow_imp.id(20000000000000000071)
,p_seq=>10
,p_name=>'Stock'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT SUBSTR(product_name, 1, 30) AS product_label,',
'       qty_on_hand',
'  FROM eba_cust_amzn_balance_v',
' ORDER BY qty_on_hand DESC',
' FETCH FIRST 10 ROWS ONLY'))
,p_items_value_column_name=>'QTY_ON_HAND'
,p_items_label_column_name=>'PRODUCT_LABEL'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(20000000000000000073)
,p_chart_id=>wwv_flow_imp.id(20000000000000000071)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_title=>'Quantity'
,p_format_scaling=>'none'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(20000000000000000074)
,p_chart_id=>wwv_flow_imp.id(20000000000000000071)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'on'
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
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(20000000000000000050)
,p_name=>'Refresh on Dialog Close'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(20000000000000000030)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(20000000000000000051)
,p_event_id=>wwv_flow_imp.id(20000000000000000050)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(20000000000000000030)
);
wwv_flow_imp.component_end;
end;
/
