prompt --application/pages/page_00044
begin
--   Manifest
--     PAGE: 00044
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
 p_id=>44
,p_name=>'Products'
,p_alias=>'PRODUCTS3'
,p_step_title=>'Products'
,p_reload_on_submit=>'A'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'ON'
,p_group_id=>wwv_flow_imp.id(14745622740247147540)
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#'
,p_required_patch=>wwv_flow_imp.id(14981637646130466838)
,p_protection_level=>'C'
,p_help_text=>'<p>This page summarizes product use by customer.  Each customer can use zero or more products.  Click the <strong>product name</strong> column to drill-down to a report of customer products.  Products can be managed for each customer from the custome'
||'r details page.</p>'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(17830472078912225930)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>30
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(17865586300496079727)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(17830472679427341090)
,p_plug_name=>'Customer Product Usage'
,p_region_name=>'PRODUCTS'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>20
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select product_name, ',
'    description, ',
'    id, ',
'    created created,',
'    lower(created_by) created_by, ',
'    updated updated, ',
'    lower(updated_by) updated_by ,',
'    (select name from eba_cust_product_families f where f.id = p.product_family_id) family,',
'    (   select count(*)',
'        from eba_cust_product_uses u',
'        where u.product_id = p.id ) customer_uses,',
'    tags',
'from eba_cust_products p'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_show_nulls_as=>' - '
,p_pagination_display_position=>'BOTTOM_RIGHT'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(17830472770560341090)
,p_name=>'Customer Product Usage'
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
,p_owner=>'MIKE'
,p_internal_uid=>3739519839538772940
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(17830472954104341094)
,p_db_column_name=>'PRODUCT_NAME'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'Product / Service Name'
,p_column_link=>'f?p=&APP_ID.:19:&SESSION.::&DEBUG.:RP,19,RIR,CIR:IR_PRODUCT_NAME:#PRODUCT_NAME#'
,p_column_linktext=>'#PRODUCT_NAME#'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(17830473053898341094)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Description'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(17830473180300341095)
,p_db_column_name=>'ID'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(17830473255917341095)
,p_db_column_name=>'CREATED'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(17830473376509341095)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(17830473470954341096)
,p_db_column_name=>'UPDATED'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(17830473572203341096)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(17830473668270341097)
,p_db_column_name=>'CUSTOMER_USES'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Customer Uses'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(17834953358970554069)
,p_db_column_name=>'TAGS'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>'Tags'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_rpt_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select tag',
'  from eba_cust_tags_type_sum',
' where content_type = ''PRODUCT''',
'   and tag_count > 0'))
,p_rpt_show_filter_lov=>'C'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(17811499136119610259)
,p_db_column_name=>'FAMILY'
,p_display_order=>31
,p_column_identifier=>'AE'
,p_column_label=>'Family'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_display_condition_type=>'EXISTS'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select null',
'from eba_cust_product_families'))
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(17830473767030341356)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'9117208'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>15
,p_report_columns=>'PRODUCT_NAME:FAMILY:CUSTOMER_USES:UPDATED'
,p_sort_column_1=>'CUSTOMER_USES'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'UPDATED'
,p_sort_direction_2=>'DESC'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(2040591413499755084)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(17830472078912225930)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CREATE'
,p_button_redirect_url=>'f?p=&APP_ID.:&LAST_VIEW.:&SESSION.::&DEBUG.:RP::'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(16620338733803403705)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(17830472679427341090)
,p_button_name=>'RESET_REPORT'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>2349107722467437027
,p_button_image_alt=>'Reset'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:44:&SESSION.::&DEBUG.:RP,RIR::'
,p_icon_css_classes=>'fa-undo-alt'
);
wwv_flow_imp.component_end;
end;
/
