prompt --application/pages/page_00203
begin
--   Manifest
--     PAGE: 00203
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
 p_id=>203
,p_name=>'Inventory Transactions'
,p_alias=>'INVENTORY-TRANSACTIONS'
,p_step_title=>'Inventory Transactions'
,p_reload_on_submit=>'A'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'ON'
,p_group_id=>wwv_flow_imp.id(20100000000000000001)
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#:t-PageBody--noContentPadding'
,p_required_role=>wwv_flow_imp.id(15992123938373047193)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(20300000000000000010)
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
 p_id=>wwv_flow_imp.id(20300000000000000020)
,p_plug_name=>'Inventory Transactions'
,p_region_name=>'INVENTORY_TRANSACTIONS'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>20
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT i.id, i.txn_date, p.product_name, i.txn_type, i.quantity, i.unit_price, i.notes, i.created_by',
'  FROM eba_cust_amzn_inventory i',
'  JOIN eba_cust_amzn_products p ON p.id = i.amzn_product_id',
' ORDER BY i.txn_date DESC'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_show_nulls_as=>' - '
,p_pagination_display_position=>'BOTTOM_RIGHT'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(20300000000000000021)
,p_name=>'Inventory Transactions'
,p_max_row_count=>'10000'
,p_max_row_count_message=>'This query returns more than #MAX_ROW_COUNT# rows, please filter your data to ensure complete results.'
,p_no_data_found_message=>'No data found.'
,p_allow_save_rpt_public=>'Y'
,p_allow_report_categories=>'N'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'Y'
,p_detail_link=>'f?p=&APP_ID.:204:&SESSION.::&DEBUG.:204:P204_ID:#ID#'
,p_detail_link_text=>'<span class="fa fa-edit" aria-hidden="true"></span>'
,p_show_notify=>'Y'
,p_show_calendar=>'N'
,p_download_formats=>'CSV:HTML'
,p_enable_mail_download=>'Y'
,p_owner=>'DVC'
,p_internal_uid=>20300000000000000021
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20300000000000000022)
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
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20300000000000000023)
,p_db_column_name=>'TXN_DATE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Transaction Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20300000000000000024)
,p_db_column_name=>'PRODUCT_NAME'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Product Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20300000000000000025)
,p_db_column_name=>'TXN_TYPE'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20300000000000000026)
,p_db_column_name=>'QUANTITY'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Quantity'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20300000000000000027)
,p_db_column_name=>'UNIT_PRICE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Unit Price'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'FM999,999,990.00'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20300000000000000028)
,p_db_column_name=>'NOTES'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Notes'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20300000000000000029)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(20300000000000000030)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'20300000000000000030'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>15
,p_report_columns=>'TXN_DATE:PRODUCT_NAME:TXN_TYPE:QUANTITY:UNIT_PRICE:NOTES'
,p_sort_column_1=>'TXN_DATE'
,p_sort_direction_1=>'DESC'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(20300000000000000040)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(20300000000000000010)
,p_button_name=>'ADD_TXN'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Transaction'
,p_button_position=>'CREATE'
,p_button_redirect_url=>'f?p=&APP_ID.:204:&SESSION.::&DEBUG.:204::'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(20300000000000000050)
,p_name=>'Refresh on Dialog Close'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(20300000000000000020)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(20300000000000000051)
,p_event_id=>wwv_flow_imp.id(20300000000000000050)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(20300000000000000020)
);
wwv_flow_imp.component_end;
end;
/
