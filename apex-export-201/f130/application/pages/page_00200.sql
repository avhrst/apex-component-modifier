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
,p_page_component_map=>'18'
);
end;
/
begin
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
end;
/
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(20000000000000000020)
,p_plug_name=>'Inventory Metrics'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>20
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_products NUMBER;',
'    l_value    NUMBER;',
'    l_low      NUMBER;',
'BEGIN',
'    SELECT COUNT(*) INTO l_products FROM eba_cust_amzn_products WHERE is_active = ''Y'';',
'    SELECT NVL(SUM(total_value), 0) INTO l_value FROM eba_cust_amzn_balance_v;',
'    SELECT COUNT(*) INTO l_low FROM eba_cust_amzn_balance_v WHERE qty_on_hand < 5;',
'    htp.p(''<div class="a-CardView" style="display:flex;gap:16px;flex-wrap:wrap;">'');',
'    htp.p(''<div class="t-Card" style="flex:1;min-width:200px;padding:16px;background:var(--ut-component-background-color);border-radius:8px;box-shadow:var(--ut-component-shadow);">'');',
'    htp.p(''<div class="t-Card-titleWrap"><h3 class="t-Card-title">Total Products</h3></div>'');',
'    htp.p(''<div class="t-Card-body"><span style="font-size:2rem;font-weight:bold;">'' || l_products || ''</span></div></div>'');',
'    htp.p(''<div class="t-Card" style="flex:1;min-width:200px;padding:16px;background:var(--ut-component-background-color);border-radius:8px;box-shadow:var(--ut-component-shadow);">'');',
'    htp.p(''<div class="t-Card-titleWrap"><h3 class="t-Card-title">Total Stock Value</h3></div>'');',
'    htp.p(''<div class="t-Card-body"><span style="font-size:2rem;font-weight:bold;">$'' || TO_CHAR(l_value, ''FM999,999,990.00'') || ''</span></div></div>'');',
'    htp.p(''<div class="t-Card" style="flex:1;min-width:200px;padding:16px;background:var(--ut-component-background-color);border-radius:8px;box-shadow:var(--ut-component-shadow);">'');',
'    htp.p(''<div class="t-Card-titleWrap"><h3 class="t-Card-title">Low Stock Alerts</h3></div>'');',
'    htp.p(''<div class="t-Card-body"><span style="font-size:2rem;font-weight:bold;'' || CASE WHEN l_low > 0 THEN ''color:var(--ut-palette-danger);'' END || ''>'' || l_low || ''</span></div></div>'');',
'    htp.p(''</div>'');',
'END;'))
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'execute_on_page_init', 'N')).to_clob
);
end;
/
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(20000000000000000030)
,p_plug_name=>'Stock Balances'
,p_region_name=>'STOCK_BALANCES'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>30
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT id, product_name, asin, category, amazon_price, qty_on_hand, total_value',
'  FROM eba_cust_amzn_balance_v',
' ORDER BY product_name'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_show_nulls_as=>' - '
,p_pagination_display_position=>'BOTTOM_RIGHT'
);
end;
/
begin
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(20000000000000000031)
,p_name=>'Stock Balances'
,p_max_row_count=>'10000'
,p_max_row_count_message=>'This query returns more than #MAX_ROW_COUNT# rows, please filter your data to ensure complete results.'
,p_no_data_found_message=>'No data found.'
,p_allow_save_rpt_public=>'Y'
,p_allow_report_categories=>'N'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_show_calendar=>'N'
,p_download_formats=>'CSV:HTML'
,p_enable_mail_download=>'Y'
,p_owner=>'DVC'
,p_internal_uid=>20000000000000000031
);
end;
/
begin
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20000000000000000032)
,p_db_column_name=>'ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
end;
/
begin
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20000000000000000033)
,p_db_column_name=>'PRODUCT_NAME'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Product Name'
,p_column_link=>'f?p=&APP_ID.:202:&SESSION.::&DEBUG.:202:P202_ID:#ID#'
,p_column_linktext=>'#PRODUCT_NAME#'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
end;
/
begin
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20000000000000000034)
,p_db_column_name=>'ASIN'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'ASIN'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
end;
/
begin
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20000000000000000035)
,p_db_column_name=>'CATEGORY'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Category'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
end;
/
begin
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20000000000000000036)
,p_db_column_name=>'AMAZON_PRICE'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Amazon Price'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999,999,990.00'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
end;
/
begin
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20000000000000000037)
,p_db_column_name=>'QTY_ON_HAND'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Qty On Hand'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
end;
/
begin
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20000000000000000038)
,p_db_column_name=>'TOTAL_VALUE'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Total Value'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999,999,990.00'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
end;
/
begin
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(20000000000000000039)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'20000000000000000039'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>15
,p_report_columns=>'PRODUCT_NAME:CATEGORY:QTY_ON_HAND:AMAZON_PRICE:TOTAL_VALUE'
,p_sort_column_1=>'PRODUCT_NAME'
,p_sort_direction_1=>'ASC'
);
end;
/
begin
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
end;
/
begin
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
end;
/
begin
wwv_flow_imp.component_end;
end;
/
