prompt --application/pages/page_00202
begin
--   Manifest
--     PAGE: 00202
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
 p_id=>202
,p_name=>'Amazon Product Detail'
,p_alias=>'AMAZON-PRODUCT-DETAIL'
,p_page_mode=>'MODAL'
,p_step_title=>'Amazon Product Detail'
,p_reload_on_submit=>'A'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'ON'
,p_group_id=>wwv_flow_imp.id(20100000000000000001)
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(15992123938373047193)
,p_protection_level=>'C'
,p_page_component_map=>'02'
);
end;
/
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(20200000000000000010)
,p_plug_name=>'Amazon Product'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'BELOW'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
end;
/
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(20200000000000000060)
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
 p_id=>wwv_flow_imp.id(20200000000000000061)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(20200000000000000060)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_warn_on_unsaved_changes=>null
);
end;
/
begin
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(20200000000000000062)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(20200000000000000060)
,p_button_name=>'DELETE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Delete'
,p_button_position=>'DELETE'
,p_button_condition=>'P202_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'DELETE'
);
end;
/
begin
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(20200000000000000063)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(20200000000000000060)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'NEXT'
,p_button_condition=>'P202_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
end;
/
begin
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(20200000000000000064)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(20200000000000000060)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'CREATE'
,p_button_condition=>'P202_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
end;
/
begin
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(20200000000000000011)
,p_name=>'P202_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(20200000000000000010)
,p_use_cache_before_default=>'NO'
,p_source=>'ID'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
end;
/
begin
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(20200000000000000012)
,p_name=>'P202_PRODUCT_NAME'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(20200000000000000010)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Product Name'
,p_source=>'PRODUCT_NAME'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>64
,p_cMaxlength=>255
,p_field_template=>2526760615038828570
,p_item_template_options=>'#DEFAULT#'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'NONE')).to_clob
);
end;
/
begin
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(20200000000000000013)
,p_name=>'P202_ASIN'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(20200000000000000010)
,p_use_cache_before_default=>'NO'
,p_prompt=>'ASIN'
,p_source=>'ASIN'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>64
,p_cMaxlength=>20
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_protection_level=>'S'
,p_display_when=>'P202_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'Y',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'NONE')).to_clob
);
end;
/
begin
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(20200000000000000014)
,p_name=>'P202_DESCRIPTION'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(20200000000000000010)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Description'
,p_source=>'DESCRIPTION'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>80
,p_cMaxlength=>4000
,p_cHeight=>4
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'NONE')).to_clob
);
end;
/
begin
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(20200000000000000015)
,p_name=>'P202_AMAZON_PRICE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(20200000000000000010)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Amazon Price'
,p_source=>'AMAZON_PRICE'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>20
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'right',
  'virtual_keyboard', 'decimal')).to_clob
);
end;
/
begin
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(20200000000000000016)
,p_name=>'P202_CATEGORY'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(20200000000000000010)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Category'
,p_source=>'CATEGORY'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>64
,p_cMaxlength=>100
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'NONE')).to_clob
);
end;
/
begin
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(20200000000000000017)
,p_name=>'P202_AMAZON_URL'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(20200000000000000010)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Amazon URL'
,p_source=>'AMAZON_URL'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>80
,p_cMaxlength=>1000
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'URL',
  'trim_spaces', 'NONE')).to_clob
);
end;
/
begin
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(20200000000000000018)
,p_name=>'P202_IMAGE_URL'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(20200000000000000010)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Image URL'
,p_source=>'IMAGE_URL'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>80
,p_cMaxlength=>1000
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'URL',
  'trim_spaces', 'NONE')).to_clob
);
end;
/
begin
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(20200000000000000019)
,p_name=>'P202_IS_ACTIVE'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(20200000000000000010)
,p_use_cache_before_default=>'NO'
,p_item_default=>'Y'
,p_prompt=>'Active'
,p_source=>'IS_ACTIVE'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
);
end;
/
begin
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(20200000000000000020)
,p_name=>'P202_PRODUCT_ID'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(20200000000000000010)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Link to Internal Product'
,p_source=>'PRODUCT_ID'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT product_name d, id r',
'  FROM eba_cust_products',
' WHERE is_active = ''Y''',
' ORDER BY 1'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-'
,p_cHeight=>1
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_protection_level=>'S'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
end;
/
begin
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(20200000000000000070)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(20200000000000000061)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
end;
/
begin
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(20200000000000000071)
,p_event_id=>wwv_flow_imp.id(20200000000000000070)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
end;
/
begin
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(20200000000000000080)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_FORM_FETCH'
,p_process_name=>'Fetch Row from EBA_CUST_AMZN_PRODUCTS'
,p_attribute_02=>'EBA_CUST_AMZN_PRODUCTS'
,p_attribute_03=>'P202_ID'
,p_attribute_04=>'ID'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>20200000000000000080
);
end;
/
begin
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(20200000000000000081)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_FORM_PROCESS'
,p_process_name=>'Process Row of EBA_CUST_AMZN_PRODUCTS'
,p_attribute_02=>'EBA_CUST_AMZN_PRODUCTS'
,p_attribute_03=>'P202_ID'
,p_attribute_04=>'ID'
,p_attribute_11=>'I:U:D'
,p_attribute_12=>'Y'
,p_process_error_message=>'#SQLERRM#'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Action Processed.'
,p_internal_uid=>20200000000000000081
);
end;
/
begin
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(20200000000000000082)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_SESSION_STATE'
,p_process_name=>'Clear Cache'
,p_attribute_01=>'CLEAR_CACHE_FOR_PAGES'
,p_attribute_02=>'202'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'DELETE'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_internal_uid=>20200000000000000082
);
end;
/
begin
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(20200000000000000083)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_01=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_internal_uid=>20200000000000000083
);
end;
/
begin
wwv_flow_imp.component_end;
end;
/
