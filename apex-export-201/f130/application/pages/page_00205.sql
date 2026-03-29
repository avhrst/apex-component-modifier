prompt --application/pages/page_00205
begin
--   Manifest
--     PAGE: 00205
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
 p_id=>205
,p_name=>'Sync Log'
,p_alias=>'SYNC-LOG'
,p_page_mode=>'MODAL'
,p_step_title=>'Sync Log'
,p_reload_on_submit=>'A'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'ON'
,p_group_id=>wwv_flow_imp.id(20100000000000000001)
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(15701195745323504847)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
end;
/
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(20500000000000000010)
,p_plug_name=>'Sync History'
,p_region_name=>'SYNC_HISTORY'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>10
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT id, sync_date, products_found, products_updated, status, error_message, created_by',
'  FROM eba_cust_amzn_sync_log',
' ORDER BY sync_date DESC'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_show_nulls_as=>' - '
,p_pagination_display_position=>'BOTTOM_RIGHT'
);
end;
/
begin
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(20500000000000000011)
,p_name=>'Sync History'
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
,p_internal_uid=>20500000000000000011
);
end;
/
begin
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20500000000000000012)
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
 p_id=>wwv_flow_imp.id(20500000000000000013)
,p_db_column_name=>'SYNC_DATE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Sync Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY HH24:MI:SS'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
end;
/
begin
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20500000000000000014)
,p_db_column_name=>'PRODUCTS_FOUND'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Products Found'
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
 p_id=>wwv_flow_imp.id(20500000000000000015)
,p_db_column_name=>'PRODUCTS_UPDATED'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Products Updated'
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
 p_id=>wwv_flow_imp.id(20500000000000000016)
,p_db_column_name=>'STATUS'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
end;
/
begin
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20500000000000000017)
,p_db_column_name=>'ERROR_MESSAGE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Error Message'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
end;
/
begin
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20500000000000000018)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
end;
/
begin
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(20500000000000000019)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'20500000000000000019'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>15
,p_report_columns=>'SYNC_DATE:PRODUCTS_FOUND:PRODUCTS_UPDATED:STATUS:ERROR_MESSAGE:CREATED_BY'
,p_sort_column_1=>'SYNC_DATE'
,p_sort_direction_1=>'DESC'
);
end;
/
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(20500000000000000020)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_03'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
end;
/
begin
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(20500000000000000021)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(20500000000000000020)
,p_button_name=>'CLOSE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Close'
,p_button_position=>'CLOSE'
,p_warn_on_unsaved_changes=>null
);
end;
/
begin
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(20500000000000000030)
,p_name=>'Close Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(20500000000000000021)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
end;
/
begin
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(20500000000000000031)
,p_event_id=>wwv_flow_imp.id(20500000000000000030)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
end;
/
begin
wwv_flow_imp.component_end;
end;
/
