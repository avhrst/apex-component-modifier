prompt --application/pages/page_00201
begin
--   Manifest
--     PAGE: 00201
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
 p_id=>201
,p_name=>'Amazon Products'
,p_alias=>'AMAZON-PRODUCTS'
,p_step_title=>'Amazon Products'
,p_reload_on_submit=>'A'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'ON'
,p_group_id=>wwv_flow_imp.id(20100000000000000001)
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'23'
);
end;
/
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(20100000000000000010)
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
 p_id=>wwv_flow_imp.id(20100000000000000020)
,p_plug_name=>'Amazon Products'
,p_region_name=>'AMZN_PRODUCTS'
,p_region_template_options=>'#DEFAULT#:t-CardsRegion--styleA'
,p_plug_template=>2072724515482255512
,p_plug_display_sequence=>20
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT id,',
'       product_name,',
'       asin,',
'       category,',
'       ''$'' || TO_CHAR(amazon_price, ''FM999,990.00'') AS price_display,',
'       ''Rank #'' || amazon_rank AS rank_display,',
'       image_url,',
'       amazon_url',
'  FROM eba_cust_amzn_products',
' WHERE is_active = ''Y''',
' ORDER BY amazon_rank NULLS LAST'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_CARDS'
,p_plug_query_num_rows_type=>'SCROLL'
,p_show_total_row_count=>true
,p_pagination_display_position=>'BOTTOM_RIGHT'
);
end;
/
begin
wwv_flow_imp_page.create_card(
 p_id=>wwv_flow_imp.id(20100000000000000021)
,p_region_id=>wwv_flow_imp.id(20100000000000000020)
,p_layout_type=>'GRID'
,p_title_adv_formatting=>false
,p_title_column_name=>'PRODUCT_NAME'
,p_sub_title_adv_formatting=>false
,p_sub_title_column_name=>'ASIN'
,p_body_adv_formatting=>true
,p_body_html_expr=>wwv_flow_string.join(wwv_flow_t_varchar2(
'{if CATEGORY/}&CATEGORY!HTML.<br/>{endif/}',
'&PRICE_DISPLAY!HTML.',
'{if RANK_DISPLAY/} &bull; &RANK_DISPLAY!HTML.{endif/}'))
,p_second_body_adv_formatting=>false
,p_media_adv_formatting=>false
,p_media_source_type=>'STATIC_URL'
,p_media_url=>'&IMAGE_URL!ATTR.'
,p_media_display_position=>'FIRST'
,p_media_appearance=>'WIDESCREEN'
,p_media_sizing=>'COVER'
,p_media_description=>'&PRODUCT_NAME!ATTR.'
);
end;
/
begin
wwv_flow_imp_page.create_card_action(
 p_id=>wwv_flow_imp.id(20100000000000000022)
,p_card_id=>wwv_flow_imp.id(20100000000000000021)
,p_action_type=>'FULL_CARD'
,p_display_sequence=>10
,p_link_target_type=>'REDIRECT_PAGE'
,p_link_target=>'f?p=&APP_ID.:202:&SESSION.::&DEBUG.:202:P202_ID:&ID.'
);
end;
/
begin
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(20100000000000000030)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(20100000000000000020)
,p_button_name=>'SYNC'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960498175094
,p_button_image_alt=>'Sync from Amazon'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_css_classes=>'t-Button--hot'
,p_icon_css_classes=>'fa-refresh'
,p_security_scheme=>wwv_flow_imp.id(15701195745323504847)
);
end;
/
begin
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(20100000000000000031)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(20100000000000000020)
,p_button_name=>'SYNC_LOG'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960498175094
,p_button_image_alt=>'Sync Log'
,p_button_position=>'RIGHT_OF_TITLE'
,p_button_redirect_url=>'f?p=&APP_ID.:205:&SESSION.::&DEBUG.:205:::'
,p_icon_css_classes=>'fa-history'
,p_security_scheme=>wwv_flow_imp.id(15701195745323504847)
);
end;
/
begin
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(20100000000000000040)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Sync Amazon Products'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_found   NUMBER;',
'    l_updated NUMBER;',
'    l_status  VARCHAR2(20);',
'    l_error   VARCHAR2(4000);',
'BEGIN',
'    eba_cust_amzn_pkg.sync_bestsellers(',
'        p_found     => l_found,',
'        p_updated   => l_updated,',
'        p_status    => l_status,',
'        p_error_msg => l_error',
'    );',
'    IF l_status = ''FAILED'' THEN',
'        apex_error.add_error(',
'            p_message          => ''Sync failed: '' || l_error,',
'            p_display_location => apex_error.c_on_error_page',
'        );',
'    ELSE',
'        apex_application.g_print_success_message :=',
'            ''Synced '' || l_found || '' products ('' || l_updated || '' updated)'';',
'    END IF;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'SYNC'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_internal_uid=>20100000000000000040
);
end;
/
begin
wwv_flow_imp.component_end;
end;
/
