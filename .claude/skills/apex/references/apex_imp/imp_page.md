# WWV_FLOW_IMP_PAGE -- Page Component Procedures

Source: APEX 24.2 (`APEX_240200`).  Validated against 29 example app exports.

## Page

### create_page
```sql
procedure create_page (
    p_id                          in number,              -- raw page number (NOT wwv_flow_imp.id())
    p_flow_id                     in number   default wwv_flow.g_flow_id,
    p_name                        in varchar2 default null,
    p_alias                       in varchar2 default null,
    p_step_title                  in varchar2 default null,
    p_page_mode                   in varchar2 default 'NORMAL',    -- NORMAL | MODAL DIALOG | NON-MODAL DIALOG
    p_step_template               in number   default null,        -- page template ID
    p_page_template_options       in varchar2 default null,
    p_required_role               in varchar2 default null,        -- authorization scheme
    p_required_patch              in number   default null,        -- build option
    p_reload_on_submit            in varchar2 default 'S',         -- S=Smart, A=Always, N=Never
    p_warn_on_unsaved_changes     in varchar2 default 'Y',
    p_autocomplete_on_off         in varchar2 default null,
    p_javascript_code             in varchar2 default null,
    p_javascript_code_onload      in varchar2 default null,
    p_javascript_file_urls        in varchar2 default null,
    p_css_file_urls               in varchar2 default null,
    p_inline_css                  in varchar2 default null,
    p_page_css_classes            in varchar2 default null,
    p_page_is_public_y_n          in varchar2 default 'N',
    p_protection_level            in varchar2 default 'N',
    p_group_id                    in number   default null,
    p_browser_cache               in varchar2 default null,
    p_deep_linking                in varchar2 default null,
    p_rejoin_existing_sessions    in varchar2 default null,
    p_page_component_map          in varchar2 default null,
    p_first_item                  in varchar2 default null,
    p_allow_duplicate_submissions in varchar2 default null,
    p_read_only_when_type         in varchar2 default null,
    p_read_only_when              in varchar2 default null,
    p_read_only_when2             in varchar2 default null
    -- also: p_help_text, p_error_handling_function, p_page_comment,
    -- p_dialog_height, p_dialog_width, p_dialog_chained, p_dialog_css_classes,
    -- p_dialog_resizable, p_html_page_header,
    -- p_navigation_list_id, p_navigation_list_position,
    -- p_navigation_list_template_id, p_nav_list_template_options,
    -- p_overwrite_navigation_list, p_tab_set,
    -- p_last_updated_by, p_last_upd_yyyymmddhh24miss
    );
```

### create_page_group
```sql
procedure create_page_group (
    p_id         in number,
    p_flow_id    in number   default wwv_flow.g_flow_id,
    p_group_name in varchar2,
    p_group_desc in varchar2 default null);
```

### update_page / remove_page
```sql
procedure update_page (p_id in number default null, ...);
procedure remove_page (p_flow_id in number, p_page_id in number);
```

## Regions

### create_page_plug
```sql
procedure create_page_plug (
    p_id                          in number   default null,
    p_page_id                     in number   default current_page_id,
    p_plug_name                   in varchar2 default null,
    p_plug_display_sequence       in number   default null,
    p_plug_display_point          in varchar2 default 'BODY',
    p_plug_template               in number   default null,        -- region template ID
    p_region_template_options     in varchar2 default null,        -- #DEFAULT#:t-Region--scrollBody
    p_component_template_options  in varchar2 default null,        -- template component options
    p_attributes                  in varchar2 default null,        -- region-type attributes
    p_plug_source_type            in varchar2 default 'NATIVE_STATIC',
    p_plug_source                 in varchar2 default null,        -- SQL query or static content
    p_location                    in varchar2 default 'LOCAL',     -- LOCAL | REMOTE | WEB_SOURCE
    p_query_type                  in varchar2 default null,        -- SQL | TABLE | FUNC_BODY_RETURNING_SQL
    p_query_table                 in varchar2 default null,        -- table name (query_type=TABLE)
    p_query_order_by              in varchar2 default null,
    p_query_order_by_type         in varchar2 default null,
    p_include_rowid_column        in boolean  default null,
    p_is_editable                 in boolean  default null,
    p_edit_operations             in varchar2 default null,        -- i:u:d
    p_lost_update_check_type      in varchar2 default null,
    p_parent_plug_id              in number   default null,
    p_menu_id                     in number   default null,        -- breadcrumb menu ID
    p_menu_template_id            in number   default null,
    p_list_id                     in number   default null,        -- list region source
    p_list_template_id            in number   default null,
    p_plug_query_num_rows         in number   default null,
    p_plug_query_num_rows_type    in varchar2 default null,
    p_plug_query_show_nulls_as    in varchar2 default null,
    p_plug_query_headings_type    in varchar2 default null,
    p_plug_query_no_data_found    in varchar2 default null,
    p_include_in_reg_disp_sel_yn  in varchar2 default null,
    p_pagination_display_position in varchar2 default null,
    p_plug_new_grid_row           in boolean  default true,
    p_plug_new_grid_column        in boolean  default true,
    p_plug_grid_column_span       in number   default null,        -- 1-12 grid columns
    p_plug_grid_column_css_classes in varchar2 default null,
    p_lazy_loading                in boolean  default null,
    p_ai_enabled                  in varchar2 default null,
    p_landmark_type               in varchar2 default null,
    p_landmark_label              in varchar2 default null,
    p_icon_css_classes            in varchar2 default null,
    p_region_css_classes          in varchar2 default null,
    p_region_name                 in varchar2 default null,
    p_region_image                in varchar2 default null,
    p_translate_title             in varchar2 default null,
    p_show_total_row_count        in boolean  default null,
    p_ajax_items_to_submit        in varchar2 default null,
    p_escape_on_http_output       in varchar2 default null,
    p_plug_display_condition_type in varchar2 default null,
    p_plug_display_when_condition in varchar2 default null,
    p_plug_display_when_cond2     in varchar2 default null,
    p_plug_required_role          in varchar2 default null,
    p_required_patch              in number   default null,
    p_template_component_type     in varchar2 default null,
    p_static_id                   in varchar2 default null,
    p_web_src_module_id           in number   default null,
    p_filtered_region_id          in number   default null,        -- faceted search target
    p_function_body_language      in varchar2 default null,
    p_master_region_id            in number   default null
    -- also: p_flow_id, p_title, p_region_sub_css_classes, p_region_attributes,
    -- p_plug_header, p_plug_footer, p_plug_comment, p_plug_column_width,
    -- p_plug_item_display_point, p_plug_read_only_when/_when2/_when_type,
    -- p_plug_grid_row_css_classes, p_plug_customized,
    -- p_plugin_init_javascript_code, p_optimizer_hint,
    -- p_entity_title_singular, p_entity_title_plural,
    -- p_source_post_processing, p_no_data_found_icon_classes,
    -- p_add_authorization_scheme, p_update_authorization_scheme,
    -- p_delete_authorization_scheme, p_build_option_name,
    -- p_prn_* (print/PDF output settings), p_query_where,
    -- p_use_local_sync_table
    );
```
Sets `current_region_id` after creation.

### create_report_region
```sql
procedure create_report_region (
    p_id                          in number,
    p_name                        in varchar2 default null,
    p_region_name                 in varchar2 default null,
    p_display_sequence            in number   default null,
    p_display_point               in varchar2 default null,
    p_source                      in varchar2 default null,
    p_source_type                 in varchar2 default null,
    p_query_type                  in varchar2 default null,
    p_query_table                 in varchar2 default null,
    p_query_where                 in varchar2 default null,
    p_query_order_by              in varchar2 default null,
    p_query_order_by_type         in varchar2 default null,
    p_query_headings_type         in varchar2 default null,
    p_query_num_rows              in number   default null,
    p_query_num_rows_type         in varchar2 default null,
    p_query_show_nulls_as         in varchar2 default null,
    p_query_no_data_found         in varchar2 default null,
    p_query_row_template          in number   default null,
    p_query_options               in varchar2 default null,
    p_region_template_options     in varchar2 default null,
    p_component_template_options  in varchar2 default null,
    p_parent_plug_id              in number   default null,
    p_new_grid_row                in boolean  default null,
    p_new_grid_column             in boolean  default null,
    p_grid_column_span            in number   default null,
    p_pagination_display_position in varchar2 default null,
    p_lazy_loading                in boolean  default null,
    p_location                    in varchar2 default null,
    p_include_rowid_column        in boolean  default null,
    p_required_role               in varchar2 default null,
    p_required_patch              in number   default null,
    p_ajax_enabled                in varchar2 default null,
    p_ajax_items_to_submit        in varchar2 default null,
    p_sort_null                   in varchar2 default null,
    p_icon_css_classes            in varchar2 default null,
    p_region_css_classes          in varchar2 default null
    -- also: p_flow_id, p_page_id, p_title, p_translate_title,
    -- p_header, p_footer, p_region_image,
    -- p_item_display_point, p_include_in_reg_disp_sel_yn,
    -- p_display_condition_type, p_display_when_condition/_cond2,
    -- p_prn_* (print/PDF settings), p_fixed_header,
    -- p_csv_output, p_csv_output_link_text, p_csv_enclosed,
    -- p_query_break_cols, p_report_total_text_format,
    -- p_query_asc_image/_attr, p_query_desc_image/_attr,
    -- p_ignore_pagination, p_plug_query_strip_html,
    -- p_web_src_module_id, p_xlsx_sheet_name,
    -- p_store_profile_to_collection, p_break_type_flag,
    -- p_add_headers_row
    );
```
Legacy region creation API; newer exports use `create_page_plug`. Observed in 29 example apps.

### create_report_columns (Classic Report)
```sql
procedure create_report_columns (
    p_id                          in number,
    p_region_id                   in number   default current_region_id,
    p_query_column_id             in number   default null,
    p_column_alias                in varchar2,
    p_column_display_sequence     in number,
    p_column_heading              in varchar2 default null,
    p_heading_alignment           in varchar2 default 'LEFT',
    p_column_alignment            in varchar2 default 'LEFT',
    p_column_format               in varchar2 default null,
    p_hidden_column               in varchar2 default 'N',
    p_display_as                  in varchar2 default 'ESCAPE_SC',
    p_column_html_expression      in varchar2 default null,
    p_column_link                 in varchar2 default null,
    p_column_linktext             in varchar2 default null,
    p_column_link_attr            in varchar2 default null,
    p_default_sort_column_sequence in number  default null,
    p_default_sort_dir            in varchar2 default null,
    p_disable_sort_column         in varchar2 default null,
    p_derived_column              in varchar2 default null,
    p_include_in_export           in varchar2 default null,
    p_use_as_row_header           in varchar2 default null
    -- also: p_flow_id, p_page_id, p_column_comment,
    -- p_display_when_cond_type, p_display_when_condition/_condition2,
    -- p_named_lov, p_inline_lov, p_lov_display_extra, p_lov_show_nulls,
    -- p_report_column_required_role, p_report_column_width,
    -- p_required_patch, p_build_option_name, p_sum_column
    );
```

### create_region_column (IG / Cards / Modern)
```sql
procedure create_region_column (
    p_id                     in number,
    p_region_id              in number   default current_region_id,
    p_name                   in varchar2,
    p_display_sequence       in number,
    p_source_type            in varchar2 default null,
    p_source_expression      in varchar2 default null,
    p_data_type              in varchar2 default null,
    p_session_state_data_type in varchar2 default null,
    p_item_type              in varchar2 default null,
    p_heading                in varchar2 default null,
    p_heading_alignment      in varchar2 default null,
    p_value_alignment        in varchar2 default null,
    p_is_visible             in boolean  default null,
    p_is_primary_key         in boolean  default null,
    p_is_required            in boolean  default null,
    p_is_query_only          in boolean  default null,
    p_duplicate_value        in boolean  default null,
    p_include_in_export      in boolean  default null,
    p_enable_filter          in boolean  default null,
    p_enable_sort_group      in boolean  default null,
    p_enable_control_break   in boolean  default null,
    p_enable_hide            in boolean  default null,
    p_enable_pivot           in boolean  default null,
    p_filter_is_required     in boolean  default null,
    p_filter_operators       in varchar2 default null,
    p_filter_text_case       in varchar2 default null,
    p_filter_exact_match     in boolean  default null,
    p_filter_date_ranges     in varchar2 default null,
    p_filter_lov_type        in varchar2 default null,
    p_format_mask            in varchar2 default null,
    p_escape_on_http_output  in boolean  default null,
    p_use_as_row_header      in varchar2 default null,
    p_attributes             in varchar2 default null,
    p_default_type           in varchar2 default null,
    p_default_expression     in varchar2 default null,
    p_lov_type               in varchar2 default null,
    p_lov_id                 in number   default null,
    p_lov_source             in varchar2 default null,
    p_lov_display_null       in boolean  default null,
    p_lov_null_text          in varchar2 default null,
    p_lov_display_extra      in boolean  default null,
    p_link_target            in varchar2 default null,
    p_link_text              in varchar2 default null,
    p_static_id              in varchar2 default null,
    p_label                  in varchar2 default null,
    p_group_id               in number   default null,
    p_is_group               in boolean  default null,
    p_use_group_for          in varchar2 default null,
    p_parent_column_id       in number   default null,
    p_required_patch         in number   default null
    -- also: p_flow_id, p_page_id, p_max_length,
    -- p_item_height, p_item_width, p_item_attributes,
    -- p_multi_value_type, p_multi_value_separator,
    -- p_readonly_condition_type, p_readonly_for_each_row,
    -- p_javascript_code
    );
```

### create_region_column_group
```sql
procedure create_region_column_group (
    p_id      in number,
    p_heading in varchar2 default null,
    p_label   in varchar2 default null);
```

## Page Items

### create_page_item
```sql
procedure create_page_item (
    p_id                       in number   default null,
    p_name                     in varchar2 default null,           -- P<page>_<name>
    p_item_sequence            in number   default null,
    p_item_plug_id             in number   default null,           -- parent region ID
    p_display_as               in varchar2 default null,           -- NATIVE_TEXT_FIELD, NATIVE_SELECT_LIST, etc.
    p_attributes               in varchar2 default null,           -- replaces p_attribute_01..25 in modern exports
    p_prompt                   in varchar2 default null,           -- label text
    p_field_template           in varchar2 default null,           -- label template ID
    p_item_template_options    in varchar2 default null,
    p_protection_level         in varchar2 default null,
    p_source                   in varchar2 default null,           -- column name or expression
    p_source_type              in varchar2 default 'ALWAYS_NULL', -- DB_COLUMN, STATIC, REGION_SOURCE_COLUMN, etc.
    p_source_data_type         in varchar2 default null,
    p_data_type                in varchar2 default 'VARCHAR2',
    p_is_required              in boolean  default false,
    p_is_primary_key           in boolean  default null,
    p_is_persistent            in varchar2 default null,
    p_lov                      in varchar2 default null,           -- inline LOV query
    p_named_lov                in varchar2 default null,           -- shared LOV ID or name
    p_lov_display_extra         in varchar2 default null,
    p_lov_display_null         in varchar2 default 'NO',
    p_lov_null_text            in varchar2 default null,
    p_lov_null_value           in varchar2 default null,
    p_lov_sort_direction       in varchar2 default null,
    p_lov_cascade_parent_items in varchar2 default null,
    p_item_default             in varchar2 default null,
    p_item_default_type        in varchar2 default null,
    p_item_default_language    in varchar2 default null,
    p_use_cache_before_default in varchar2 default null,
    p_placeholder              in varchar2 default null,
    p_format_mask              in varchar2 default null,
    p_restricted_characters    in varchar2 default null,
    p_encrypt_session_state_yn in varchar2 default null,
    p_item_source_plug_id      in number   default null,
    p_begin_on_new_line        in varchar2 default null,
    p_grid_label_column_span   in number   default null,
    p_colspan                  in number   default null,
    p_help_text                in varchar2 default null,
    p_inline_help_text         in varchar2 default null,
    p_item_icon_css_classes    in varchar2 default null,
    p_item_css_classes         in varchar2 default null,
    p_display_when             in varchar2 default null,
    p_display_when_type        in varchar2 default null,
    p_display_when2            in varchar2 default null,
    p_read_only_when           in varchar2 default null,
    p_read_only_when_type      in varchar2 default null,
    p_read_only_when2          in varchar2 default null,
    p_warn_on_unsaved_changes  in varchar2 default null,
    p_security_scheme          in varchar2 default null,
    p_required_patch           in number   default null,
    p_ai_enabled               in varchar2 default null,
    p_multi_value_type         in varchar2 default null,
    p_multi_value_separator    in varchar2 default null,
    p_multi_value_trim_space   in varchar2 default null,
    p_tag_css_classes          in varchar2 default null,
    p_tag_attributes           in varchar2 default null,
    p_suggestions_type         in varchar2 default null
    -- also: p_flow_id, p_flow_step_id, p_label_alignment, p_field_alignment,
    -- p_post_element_text, p_pre_element_text, p_item_comment,
    -- p_source_language, p_source_post_computation,
    -- p_escape_on_http_input, p_escape_on_http_output,
    -- p_plugin_init_javascript_code, p_ajax_optimize_refresh,
    -- p_item_display_point, p_begin_on_new_field,
    -- p_grid_column, p_grid_column_css_classes, p_grid_row_css_classes,
    -- p_show_quick_picks, p_quick_pick_label_01..05, p_quick_pick_value_01..05,
    -- p_fc_* (faceted search params: p_fc_show_chart, p_fc_show_label,
    --   p_fc_compute_counts, p_fc_show_counts, p_fc_zero_count_entries,
    --   p_fc_filter_values, p_fc_sort_by_top_counts, p_fc_display_as,
    --   p_fc_show_selected_first, p_fc_show_more_count, p_fc_actions_filter,
    --   p_fc_collapsible, p_fc_initial_chart, p_fc_initial_collapsed,
    --   p_fc_filter_combination, p_fc_max_height),
    -- p_lov_language, p_is_query_only, p_build_option_name
    );
```
Item naming: `P<page_id>_<name>` (e.g., `P10_EMPNO`).

## Buttons

### create_page_button
```sql
procedure create_page_button (
    p_id                         in number   default null,
    p_button_sequence            in number   default null,
    p_button_plug_id             in number   default null,          -- parent region
    p_button_name                in varchar2 default null,          -- REQUEST value
    p_button_position            in varchar2 default 'BODY',
    p_button_template_id         in number   default null,
    p_button_template_options    in varchar2 default null,
    p_button_is_hot              in varchar2 default 'N',
    p_button_image_alt           in varchar2 default null,          -- label text
    p_button_action              in varchar2 default null,          -- SUBMIT | REDIRECT_URL | REDIRECT_PAGE | DEFINED_BY_DA
    p_button_redirect_url        in varchar2 default null,
    p_button_execute_validations in varchar2 default 'Y',
    p_button_condition           in varchar2 default null,
    p_button_condition_type      in varchar2 default null,
    p_button_condition2          in varchar2 default null,
    p_database_action            in varchar2 default null,          -- INSERT | UPDATE | DELETE
    p_icon_css_classes           in varchar2 default null,
    p_button_css_classes         in varchar2 default null,
    p_button_static_id           in varchar2 default null,
    p_button_cattributes         in varchar2 default null,
    p_button_alignment           in varchar2 default null,
    p_confirm_message            in varchar2 default null,
    p_confirm_style              in varchar2 default null,
    p_security_scheme            in varchar2 default null,
    p_required_patch             in number   default null,
    p_warn_on_unsaved_changes    in varchar2 default null,
    p_show_processing            in varchar2 default null,
    p_request_source             in varchar2 default null,
    p_request_source_type        in varchar2 default null
    -- also: p_flow_id, p_flow_step_id, p_button_comment,
    -- p_grid_new_row, p_grid_new_column, p_grid_column_span,
    -- p_grid_column, p_grid_column_css_classes, p_grid_row_css_classes,
    -- p_authorization_name, p_button_display_type
    );
```

## Processes

### create_page_process
```sql
procedure create_page_process (
    p_id                      in number   default null,
    p_process_sequence        in number   default null,
    p_process_point           in varchar2 default null,        -- BEFORE_HEADER | AFTER_SUBMIT | ON_DEMAND
    p_process_type            in varchar2 default 'PLSQL',    -- NATIVE_PLSQL | NATIVE_FORM_DML | ...
    p_process_name            in varchar2 default null,
    p_region_id               in number   default null,
    p_process_sql_clob        in varchar2 default null,
    p_process_clob_language   in varchar2 default null,        -- PLSQL | JAVASCRIPT
    p_attribute_01 .. p_attribute_13 in varchar2 default null,
    p_process_error_message   in varchar2 default null,
    p_process_success_message in varchar2 default null,
    p_error_display_location  in varchar2 default 'ON_ERROR_PAGE',
    p_process_when_button_id  in number   default null,
    p_process_when            in varchar2 default null,
    p_process_when_type       in varchar2 default null,
    p_process_when2           in varchar2 default null,
    p_security_scheme         in varchar2 default null,
    p_required_patch          in number   default null,
    p_static_id               in varchar2 default null,
    p_internal_uid            in number   default null,
    p_return_key_into_item1   in varchar2 default null
    -- also: p_flow_id, p_flow_step_id, p_location,
    -- p_process_comment, p_parent_process_id,
    -- p_web_src_module_id, p_web_src_operation_id,
    -- p_run_in_background
    );
```

## Validations

### create_page_validation
```sql
procedure create_page_validation (
    p_id                         in number,
    p_validation_name            in varchar2,
    p_validation_sequence        in number,
    p_validation                 in varchar2,
    p_validation2                in varchar2 default null,
    p_validation_type            in varchar2,  -- ITEM_REQUIRED | FUNC_BODY_RETURNING_BOOLEAN | ...
    p_error_message              in varchar2,
    p_error_display_location     in varchar2 default 'ON_ERROR_PAGE',
    p_associated_item            in number   default null,
    p_associated_column          in number   default null,
    p_when_button_pressed        in number   default null,          -- button ID
    p_always_execute             in varchar2 default 'N',
    p_validation_condition       in varchar2 default null,
    p_validation_condition_type  in varchar2 default null,
    p_validation_condition2      in varchar2 default null,
    p_required_patch             in number   default null,
    p_tabular_form_region_id     in number   default null
    -- also: p_flow_id, p_flow_step_id, p_security_scheme
    );
```

## Computations

### create_page_computation
```sql
procedure create_page_computation (
    p_id                       in number,
    p_computation_sequence     in number,
    p_computation_item         in varchar2,
    p_computation_point        in varchar2 default 'AFTER_SUBMIT',
    p_computation_type         in varchar2 default 'SQL_EXPRESSION',
    p_computation              in varchar2,
    p_computation_language     in varchar2 default null,            -- PLSQL | JAVASCRIPT
    p_computation_error_message in varchar2 default null,
    p_compute_when             in varchar2 default null,
    p_compute_when_type        in varchar2 default null,
    p_compute_when_text        in varchar2 default null,
    p_required_patch           in number   default null,
    p_static_id                in varchar2 default null
    -- also: p_flow_id, p_flow_step_id, p_security_scheme
    );
```

## Branches

### create_page_branch
```sql
procedure create_page_branch (
    p_id                         in number,
    p_branch_name                in varchar2 default null,
    p_branch_action              in varchar2,
    p_branch_point               in varchar2,
    p_branch_type                in varchar2,  -- REDIRECT_URL | BRANCH_TO_PAGE_ACCEPT | ...
    p_branch_sequence            in number,
    p_branch_when_button_id      in number   default null,
    p_branch_condition_type      in varchar2 default null,
    p_branch_condition           in varchar2 default null,
    p_branch_condition_text      in varchar2 default null,
    p_branch_comment             in varchar2 default null,
    p_save_state_before_branch_yn in varchar2 default null,
    p_security_scheme            in varchar2 default null
    -- also: p_flow_id, p_flow_step_id
    );
```

## Dynamic Actions

### create_page_da_event
```sql
procedure create_page_da_event (
    p_id                        in number   default null,
    p_name                      in varchar2,
    p_event_sequence            in number,
    p_triggering_element_type   in varchar2 default null,    -- ITEM | REGION | BUTTON | JQUERY_SELECTOR
    p_triggering_region_id      in number   default null,
    p_triggering_button_id      in number   default null,
    p_triggering_element        in varchar2 default null,    -- item name or selector
    p_triggering_condition_type in varchar2 default null,
    p_triggering_expression     in varchar2 default null,
    p_bind_type                 in varchar2,                 -- bind | live
    p_bind_event_type           in varchar2,                 -- change | click | ready | custom | ...
    p_bind_event_type_custom    in varchar2 default null,
    p_bind_delegate_to_selector in varchar2 default null,
    p_execution_type            in varchar2 default null,    -- IMMEDIATE | DEBOUNCE | THROTTLE
    p_execution_immediate       in varchar2 default null,
    p_execution_time            in varchar2 default null,
    p_display_when_type         in varchar2 default null,
    p_display_when_cond         in varchar2 default null,
    p_display_when_cond2        in varchar2 default null,
    p_condition_element         in varchar2 default null,
    p_condition_element_type    in varchar2 default null,
    p_required_patch            in number   default null,
    p_security_scheme           in varchar2 default null
    -- also: p_flow_id, p_page_id, p_da_event_comment
    );
```

### create_page_da_action
```sql
procedure create_page_da_action (
    p_id                          in number   default null,
    p_event_id                    in number,                      -- must match parent DA event
    p_event_result                in varchar2,                    -- TRUE | FALSE
    p_action_sequence             in number,
    p_execute_on_page_init        in varchar2,                    -- Y | N
    p_action                      in varchar2,                    -- NATIVE_REFRESH | NATIVE_SET_VALUE | ...
    p_name                        in varchar2 default null,
    p_affected_elements_type      in varchar2 default null,       -- ITEM | REGION | BUTTON | JQUERY_SELECTOR
    p_affected_region_id          in number   default null,
    p_affected_elements           in varchar2 default null,
    p_affected_button_id          in number   default null,
    p_attribute_01 .. p_attribute_10 in varchar2 default null,
    p_wait_for_result             in varchar2 default null,
    p_client_condition_type       in varchar2 default null,
    p_client_condition_element    in varchar2 default null,
    p_client_condition_expression in varchar2 default null,
    p_server_condition_type       in varchar2 default null,
    p_server_condition_expr1      in varchar2 default null,
    p_security_scheme             in varchar2 default null
    -- also: p_flow_id, p_page_id, p_da_action_comment
    );
```

## Interactive Report

### create_worksheet
```sql
procedure create_worksheet (
    p_id                         in number,
    p_region_id                  in number   default current_region_id,
    p_name                       in varchar2 default null,
    p_max_row_count              in varchar2 default null,
    p_max_row_count_message      in varchar2 default null,
    p_no_data_found_message      in varchar2 default null,
    p_lazy_loading               in boolean  default false,
    p_pagination_type            in varchar2 default null,
    p_pagination_display_pos     in varchar2 default null,
    p_show_search_bar            in varchar2 default 'Y',
    p_show_actions_menu          in varchar2 default null,
    p_show_detail_link           in varchar2 default 'Y',
    p_show_download              in varchar2 default 'Y',
    p_download_formats           in varchar2 default null,
    p_download_filename          in varchar2 default null,
    p_download_auth_scheme       in varchar2 default null,
    p_show_display_row_count     in varchar2 default null,
    p_show_rows_per_page         in varchar2 default null,
    p_max_rows_per_page          in number   default null,
    p_show_filter                in varchar2 default null,
    p_show_control_break         in varchar2 default null,
    p_show_highlight             in varchar2 default null,
    p_show_computation           in varchar2 default null,
    p_show_aggregate             in varchar2 default null,
    p_show_chart                 in varchar2 default null,
    p_show_group_by              in varchar2 default null,
    p_show_pivot                 in varchar2 default null,
    p_show_calendar              in varchar2 default null,
    p_show_flashback             in varchar2 default null,
    p_show_notify                in varchar2 default null,
    p_show_nulls_as              in varchar2 default null,
    p_allow_report_saving        in varchar2 default null,
    p_allow_report_categories    in varchar2 default null,
    p_allow_save_rpt_public      in varchar2 default null,
    p_allow_exclude_null_values  in varchar2 default null,
    p_allow_hide_extra_columns   in varchar2 default null,
    p_save_rpt_public_auth_scheme in varchar2 default null,
    p_report_list_mode           in varchar2 default null,
    p_report_id_item             in varchar2 default null,
    p_fixed_header               in varchar2 default null,
    p_detail_link                in varchar2 default null,
    p_detail_link_text           in varchar2 default null,
    p_detail_link_attr           in varchar2 default null,
    p_detail_link_auth_scheme    in varchar2 default null,
    p_detail_link_cond           in varchar2 default null,
    p_detail_link_condition_type in varchar2 default null,
    p_detail_view_enabled_yn     in varchar2 default null,
    p_detail_view_for_each_row   in varchar2 default null,
    p_detail_view_before_rows    in varchar2 default null,
    p_detail_view_after_rows     in varchar2 default null,
    p_icon_view_columns_per_row  in number   default null,
    p_email_from                 in varchar2 default null,
    p_enable_mail_download       in varchar2 default null,
    p_owner                      in varchar2 default null,
    p_internal_uid               in number   default null
    -- also: p_flow_id, p_page_id, p_base_pk1
    );
```
Sets `current_worksheet_id`.

### create_worksheet_column
```sql
procedure create_worksheet_column (
    p_id                     in number,
    p_worksheet_id           in number   default current_worksheet_id,
    p_db_column_name         in varchar2,
    p_display_order          in number,
    p_column_identifier      in varchar2,  -- A, B, C...
    p_column_label           in varchar2,
    p_column_type            in varchar2,  -- STRING | NUMBER | DATE
    p_display_text_as        in varchar2 default 'ESCAPE_SC',
    p_heading_alignment      in varchar2 default null,
    p_column_alignment       in varchar2 default null,
    p_format_mask            in varchar2 default null,
    p_tz_dependent           in varchar2 default null,
    p_column_html_expression in varchar2 default null,
    p_column_link            in varchar2 default null,
    p_column_linktext        in varchar2 default null,
    p_column_link_attr       in varchar2 default null,
    p_column_comment         in varchar2 default null,
    p_group_id               in number   default null,
    p_use_as_row_header      in varchar2 default null,
    p_is_primary_key         in varchar2 default null,
    p_allow_sorting          in varchar2 default null,
    p_allow_filtering        in varchar2 default null,
    p_allow_ctrl_breaks      in varchar2 default null,
    p_allow_aggregations     in varchar2 default null,
    p_allow_computations     in varchar2 default null,
    p_allow_charting         in varchar2 default null,
    p_allow_group_by         in varchar2 default null,
    p_allow_highlighting     in varchar2 default null,
    p_allow_pivot            in varchar2 default null,
    p_allow_hide             in varchar2 default null,
    p_rpt_show_filter_lov    in varchar2 default null,
    p_rpt_lov                in varchar2 default null,
    p_rpt_named_lov          in varchar2 default null,
    p_security_scheme        in varchar2 default null,
    p_required_patch         in number   default null
    -- also: p_flow_id, p_page_id, p_display_condition/_condition2/_condition_type,
    -- p_attributes, p_build_option_name, p_help_text
    );
```

### create_worksheet_rpt
```sql
procedure create_worksheet_rpt (
    p_id                     in number,
    p_worksheet_id           in number   default current_worksheet_id,
    p_application_user       in varchar2 default null,
    p_name                   in varchar2 default null,
    p_is_default             in varchar2 default 'N',
    p_display_rows           in number   default 50,
    p_report_columns         in varchar2 default null,  -- colon-separated: EMPNO:ENAME:SAL
    p_report_alias           in varchar2 default null,
    p_report_seq             in number   default null,
    p_report_type            in varchar2 default null,
    p_status                 in varchar2 default null,
    p_view_mode              in varchar2 default null,
    p_sort_column_1          in varchar2 default null,
    p_sort_direction_1       in varchar2 default null,
    p_sort_column_2          in varchar2 default null,
    p_sort_direction_2       in varchar2 default null,
    p_sort_column_3          in varchar2 default null,
    p_sort_direction_3       in varchar2 default null,
    p_sort_column_4          in varchar2 default null,
    p_sort_direction_4       in varchar2 default null,
    p_sort_column_5          in varchar2 default null,
    p_sort_direction_5       in varchar2 default null,
    p_sort_column_6          in varchar2 default null,
    p_sort_direction_6       in varchar2 default null,
    p_break_on               in varchar2 default null,
    p_break_enabled_on       in varchar2 default null,
    p_sum_columns_on_break   in varchar2 default null,
    p_count_distnt_col_on_break in varchar2 default null,
    p_chart_type             in varchar2 default null,
    p_chart_label_column     in varchar2 default null,
    p_chart_value_column     in varchar2 default null,
    p_chart_aggregate        in varchar2 default null,
    p_chart_label_title      in varchar2 default null,
    p_chart_value_title      in varchar2 default null,
    p_chart_orientation      in varchar2 default null,
    p_chart_sorting          in varchar2 default null);
```

### create_worksheet_condition
```sql
procedure create_worksheet_condition (
    p_id                 in number,
    p_report_id          in number,
    p_name               in varchar2 default null,
    p_condition_type     in varchar2 default null,    -- FILTER | HIGHLIGHT
    p_allow_delete       in varchar2 default null,
    p_column_name        in varchar2 default null,
    p_operator           in varchar2 default null,
    p_expr               in varchar2 default null,
    p_expr2              in varchar2 default null,
    p_expr_type          in varchar2 default null,
    p_condition_sql      in varchar2 default null,
    p_condition_display  in varchar2 default null,
    p_enabled            in varchar2 default null,
    p_highlight_sequence in number   default null,
    p_column_bg_color    in varchar2 default null,
    p_row_bg_color       in varchar2 default null);
```

### create_worksheet_computation
```sql
procedure create_worksheet_computation (
    p_id               in number,
    p_report_id        in number,
    p_db_column_name   in varchar2 default null,
    p_column_identifier in varchar2 default null,
    p_column_label     in varchar2 default null,
    p_column_type      in varchar2 default null,
    p_computation_expr in varchar2 default null,
    p_format_mask      in varchar2 default null,
    p_report_label     in varchar2 default null);
```

### create_worksheet_group_by
```sql
procedure create_worksheet_group_by (
    p_id                          in number,
    p_report_id                   in number,
    p_group_by_columns            in varchar2 default null,
    p_function_01                 in varchar2 default null,
    p_function_column_01          in varchar2 default null,
    p_function_db_column_name_01  in varchar2 default null,
    p_function_format_mask_01     in varchar2 default null,
    p_function_sum_01             in varchar2 default null,
    p_function_02                 in varchar2 default null,
    p_function_column_02          in varchar2 default null,
    p_function_db_column_name_02  in varchar2 default null,
    p_function_format_mask_02     in varchar2 default null,
    p_function_sum_02             in varchar2 default null,
    p_function_03                 in varchar2 default null,
    p_function_column_03          in varchar2 default null,
    p_function_db_column_name_03  in varchar2 default null,
    p_function_format_mask_03     in varchar2 default null,
    p_function_sum_03             in varchar2 default null,
    p_sort_column_01              in varchar2 default null,
    p_sort_direction_01           in varchar2 default null);
```

### create_worksheet_pivot
```sql
procedure create_worksheet_pivot (
    p_id            in number,
    p_report_id     in number,
    p_pivot_columns in varchar2 default null,
    p_row_columns   in varchar2 default null);
```

### create_worksheet_col_group
```sql
procedure create_worksheet_col_group (
    p_id               in number,
    p_name             in varchar2 default null,
    p_display_sequence in number   default null);
```

## Interactive Grid

### create_interactive_grid
```sql
procedure create_interactive_grid (
    p_id                          in number,
    p_region_id                   in number   default current_region_id,
    p_is_editable                 in boolean  default false,
    p_edit_operations              in varchar2 default null,  -- i:u:d
    p_lost_update_check_type      in varchar2 default null,
    p_add_row_if_empty            in boolean  default null,
    p_add_button_label            in varchar2 default null,
    p_lazy_loading                in boolean  default false,
    p_pagination_type             in varchar2 default 'SCROLL',
    p_show_toolbar                in boolean  default true,
    p_toolbar_buttons             in varchar2 default 'SEARCH_COLUMN:SEARCH_FIELD:ACTIONS_MENU:RESET:SAVE',
    p_enable_download             in boolean  default true,
    p_download_formats            in varchar2 default 'CSV:HTML:PDF:XLSX',
    p_enable_mail_download        in boolean  default null,
    p_enable_save_public_report   in boolean  default null,
    p_enable_subscriptions        in boolean  default null,
    p_enable_flashback            in boolean  default null,
    p_show_total_row_count        in boolean  default null,
    p_show_nulls_as               in varchar2 default null,
    p_select_first_row            in boolean  default null,
    p_fixed_header                in varchar2 default null,
    p_fixed_header_max_height     in number   default null,
    p_fixed_row_height            in boolean  default null,
    p_max_row_count               in number   default null,
    p_no_data_found_message       in varchar2 default null,
    p_requires_filter             in boolean  default null,
    p_submit_checked_rows         in boolean  default null,
    p_javascript_code             in varchar2 default null,
    p_define_chart_view           in boolean  default null,
    p_show_detail_view            in boolean  default null,
    p_show_icon_view              in boolean  default null,
    p_add_authorization_scheme    in varchar2 default null,
    p_update_authorization_scheme in varchar2 default null,
    p_delete_authorization_scheme in varchar2 default null,
    p_edit_row_operations_column  in varchar2 default null,
    p_oracle_text_index_column    in varchar2 default null,
    p_internal_uid                in number   default null
    -- also: p_flow_id, p_page_id, p_detail_view_before_rows/_after_rows/_for_each_row,
    -- p_icon_view_use_custom, p_icon_view_custom, p_icon_view_icon_column,
    -- p_icon_view_icon_type, p_icon_view_label_column, p_icon_view_link_target,
    -- p_static_id
    );
```

### create_ig_report
```sql
procedure create_ig_report (
    p_id                    in number,
    p_interactive_grid_id   in number,
    p_name                  in varchar2,
    p_type                  in varchar2,
    p_default_view          in varchar2,
    p_rows_per_page         in number   default null,
    p_show_row_number       in boolean  default null,
    p_settings_area_expanded in boolean default null,
    p_authorization_scheme  in varchar2 default null,
    p_static_id             in varchar2 default null);
```

### create_ig_report_view
```sql
procedure create_ig_report_view (
    p_id                        in number,
    p_report_id                 in number,
    p_view_type                 in varchar2,
    p_stretch_columns           in boolean  default null,
    p_srv_exclude_null_values   in boolean  default null,
    p_srv_only_display_columns  in boolean  default null,
    p_edit_mode                 in varchar2 default null,
    p_chart_type                in varchar2 default null,
    p_chart_orientation         in varchar2 default null,
    p_chart_stack               in varchar2 default null,
    p_axis_label                in varchar2 default null,
    p_axis_value                in varchar2 default null);
```

### create_ig_report_column
```sql
procedure create_ig_report_column (
    p_id                  in number,
    p_view_id             in number,
    p_display_seq         in number,
    p_column_id           in number   default null,
    p_is_visible          in boolean  default true,
    p_is_frozen           in boolean  default false,
    p_width               in number   default null,
    p_sort_order          in number   default null,
    p_sort_direction      in varchar2 default null,
    p_sort_nulls          in varchar2 default null,
    p_break_is_enabled    in boolean  default null,
    p_break_order         in number   default null,
    p_break_sort_direction in varchar2 default null,
    p_break_sort_nulls    in varchar2 default null);
```

### create_ig_report_aggregate
```sql
procedure create_ig_report_aggregate (
    p_id              in number,
    p_view_id         in number,
    p_column_id       in number   default null,
    p_function        in varchar2 default null,   -- SUM | AVG | COUNT | MIN | MAX | MEDIAN
    p_is_enabled      in boolean  default null,
    p_show_grand_total in boolean default null,
    p_tooltip         in varchar2 default null);
```

### create_ig_report_chart_col
```sql
procedure create_ig_report_chart_col (
    p_id             in number,
    p_view_id        in number,
    p_column_id      in number   default null,
    p_column_type    in varchar2 default null,    -- LABEL | VALUE
    p_function       in varchar2 default null,
    p_sort_order     in number   default null,
    p_sort_direction in varchar2 default null,
    p_sort_nulls     in varchar2 default null);
```

## Charts

### create_jet_chart
```sql
procedure create_jet_chart (
    p_id                       in number,
    p_region_id                in number   default current_region_id,
    p_chart_type               in varchar2 default 'area',  -- area|bar|bubble|combo|dial|donut|funnel|gantt|line|pie|polar|pyramid|radar|range|scatter|stock|waterfall
    p_title                    in varchar2 default null,
    p_height                   in varchar2 default null,
    p_width                    in varchar2 default null,
    p_orientation              in varchar2 default null,
    p_stack                    in varchar2 default 'off',
    p_stack_label              in varchar2 default null,
    p_legend_rendered          in varchar2 default 'on',
    p_legend_position          in varchar2 default null,
    p_legend_title             in varchar2 default null,
    p_legend_font_family       in varchar2 default null,
    p_legend_font_size         in varchar2 default null,
    p_legend_font_style        in varchar2 default null,
    p_sorting                  in varchar2 default null,
    p_animation_on_display     in varchar2 default null,
    p_animation_on_data_change in varchar2 default null,
    p_data_cursor              in varchar2 default null,
    p_data_cursor_behavior     in varchar2 default null,
    p_hover_behavior           in varchar2 default null,
    p_hide_and_show_behavior   in varchar2 default null,
    p_horizontal_grid          in varchar2 default null,
    p_vertical_grid            in varchar2 default null,
    p_tooltip_rendered         in varchar2 default null,
    p_show_value               in varchar2 default null,
    p_show_label               in varchar2 default null,
    p_show_series_name         in varchar2 default null,
    p_show_group_name          in varchar2 default null,
    p_show_row                 in varchar2 default null,
    p_show_start               in varchar2 default null,
    p_show_end                 in varchar2 default null,
    p_show_progress            in varchar2 default null,
    p_show_baseline            in varchar2 default null,
    p_show_gauge_value         in varchar2 default null,
    p_value_position           in varchar2 default null,
    p_value_format_type        in varchar2 default null,
    p_value_format_scaling     in varchar2 default null,
    p_value_decimal_places     in number   default null,
    p_value_currency           in varchar2 default null,
    p_value_text_type          in varchar2 default null,
    p_no_data_found_message    in varchar2 default null,
    p_overview_rendered        in varchar2 default null,
    p_zoom_and_scroll          in varchar2 default null,
    p_initial_zooming          in varchar2 default null,
    p_time_axis_type           in varchar2 default null,
    p_spark_chart              in varchar2 default null,
    p_connect_nulls            in varchar2 default null,
    p_fill_multi_series_gaps   in varchar2 default null,
    p_row_axis_rendered        in varchar2 default null,
    p_javascript_code          in varchar2 default null
    -- also: p_pie_other_threshold, p_pie_selection_effect,
    -- p_stock_render_as, p_gauge_orientation, p_gauge_plot_area,
    -- p_gauge_angle_extent, p_gauge_start_angle,
    -- p_gauge_indicator_size, p_gauge_inner_radius,
    -- p_gantt_axis_position
    );
```

### create_jet_chart_axis
```sql
procedure create_jet_chart_axis (
    p_id                     in number,
    p_chart_id               in number,
    p_axis                   in varchar2,             -- x | y | y2
    p_title                  in varchar2 default null,
    p_is_rendered            in varchar2 default null,
    p_position               in varchar2 default null,
    p_format_type            in varchar2 default null,
    p_format_scaling         in varchar2 default null,
    p_decimal_places         in number   default null,
    p_currency               in varchar2 default null,
    p_numeric_pattern        in varchar2 default null,
    p_scaling                in varchar2 default null,
    p_axis_scale             in varchar2 default null,
    p_baseline_scaling       in varchar2 default null,
    p_min                    in number   default null,
    p_max                    in number   default null,
    p_step                   in number   default null,
    p_min_step               in number   default null,
    p_major_tick_rendered    in varchar2 default null,
    p_minor_tick_rendered    in varchar2 default null,
    p_tick_label_rendered    in varchar2 default null,
    p_tick_label_rotation    in varchar2 default null,
    p_tick_label_position    in varchar2 default null,
    p_tick_label_font_color  in varchar2 default null,
    p_tick_label_font_family in varchar2 default null,
    p_tick_label_font_size   in varchar2 default null,
    p_tick_label_font_style  in varchar2 default null,
    p_title_font_color       in varchar2 default null,
    p_title_font_family      in varchar2 default null,
    p_title_font_size        in varchar2 default null,
    p_title_font_style       in varchar2 default null,
    p_split_dual_y           in varchar2 default null,
    p_splitter_position      in number   default null
    -- also: p_zoom_order_seconds/_minutes/_hours/_days/_weeks/_months/_quarters/_years
    );
```

### create_jet_chart_series
```sql
procedure create_jet_chart_series (
    p_id                           in number,
    p_chart_id                     in number,
    p_seq                          in number,
    p_name                         in varchar2,
    p_data_source_type             in varchar2,
    p_data_source                  in varchar2 default null,
    p_location                     in varchar2 default null,
    p_ajax_items_to_submit         in varchar2 default null,
    p_max_row_count                in number   default null,
    p_items_value_column_name      in varchar2 default null,
    p_items_label_column_name      in varchar2 default null,
    p_items_x_column_name          in varchar2 default null,
    p_items_y_column_name          in varchar2 default null,
    p_items_z_column_name          in varchar2 default null,
    p_items_short_desc_column_name in varchar2 default null,
    p_items_target_value           in varchar2 default null,
    p_items_max_value              in varchar2 default null,
    p_items_open_column_name       in varchar2 default null,
    p_items_close_column_name      in varchar2 default null,
    p_items_high_column_name       in varchar2 default null,
    p_items_low_column_name        in varchar2 default null,
    p_items_volume_column_name     in varchar2 default null,
    p_items_label_rendered         in varchar2 default null,
    p_items_label_position         in varchar2 default null,
    p_items_label_display_as       in varchar2 default null,
    p_items_label_css_classes      in varchar2 default null,
    p_items_label_font_color       in varchar2 default null,
    p_items_label_font_family      in varchar2 default null,
    p_items_label_font_size        in varchar2 default null,
    p_series_type                  in varchar2 default null,
    p_series_name_column_name      in varchar2 default null,
    p_group_name_column_name       in varchar2 default null,
    p_group_short_desc_column_name in varchar2 default null,
    p_custom_column_name           in varchar2 default null,
    p_color                        in varchar2 default null,
    p_line_style                   in varchar2 default null,
    p_line_type                    in varchar2 default null,
    p_line_width                   in number   default null,
    p_marker_rendered              in varchar2 default null,
    p_marker_shape                 in varchar2 default null,
    p_assigned_to_y2               in varchar2 default null,
    p_link_target                  in varchar2 default null,
    p_link_target_type             in varchar2 default null,
    p_static_id                    in varchar2 default null,
    p_stack_category               in varchar2 default null,
    p_source_post_processing       in varchar2 default null,
    p_web_src_module_id            in number   default null
    -- also: p_gantt_start_date_column/_source, p_gantt_end_date_column/_source,
    -- p_gantt_row_id, p_gantt_row_name, p_gantt_task_id/_name/_start_date/_end_date,
    -- p_gantt_progress_column, p_gantt_progress_css_class, p_gantt_task_css_class,
    -- p_gantt_baseline_start_column/_end_column/_css_class,
    -- p_gantt_viewport_start_source/_item, p_gantt_viewport_end_source/_item,
    -- p_gauge_plot_area_color, p_q2_color, p_q3_color,
    -- p_task_label_position, p_threshold_values/_colors/_display,
    -- p_reference_line_values/_colors, p_fill_opacity,
    -- p_build_option_name, p_array_column_id
    );
```

## Map

### create_map_region
```sql
procedure create_map_region (
    p_id                          in number,
    p_region_id                   in number   default current_region_id,
    p_height                      in number,
    p_navigation_bar_type         in varchar2,
    p_navigation_bar_position     in varchar2 default null,
    p_init_position_zoom_type     in varchar2,
    p_init_position_lat_static    in varchar2 default null,
    p_init_position_lon_static    in varchar2 default null,
    p_init_position_lat_column    in varchar2 default null,
    p_init_position_lon_column    in varchar2 default null,
    p_init_position_from_browser  in varchar2 default null,
    p_init_position_geometry_type in varchar2 default null,
    p_init_position_zoom_source   in varchar2 default null,
    p_init_zoomlevel_static       in number   default null,
    p_init_zoomlevel_column       in varchar2 default null,
    p_features                    in varchar2 default null,
    p_custom_styles               in varchar2 default null,
    p_tilelayer_type              in varchar2 default null,
    p_tilelayer_name_default      in varchar2 default null,
    p_tilelayer_name_dark         in varchar2 default null,
    p_show_legend                 in varchar2 default null,
    p_legend_position             in varchar2 default null,
    p_layer_messages_position     in varchar2 default null,
    p_map_status_item             in varchar2 default null);
```

### create_map_region_layer
```sql
procedure create_map_region_layer (
    p_id                        in number,
    p_map_region_id             in number,
    p_name                      in varchar2,
    p_layer_type                in varchar2,
    p_display_sequence          in number,
    p_location                  in varchar2 default null,
    p_query_type                in varchar2 default null,
    p_layer_source              in varchar2 default null,
    p_table_name                in varchar2 default null,
    p_where_clause              in varchar2 default null,
    p_geometry_column_data_type in varchar2,
    p_geometry_column           in varchar2 default null,
    p_has_spatial_index         in varchar2 default null,
    p_latitude_column           in varchar2 default null,
    p_longitude_column          in varchar2 default null,
    p_pk_column                 in varchar2 default null,
    p_include_rowid_column      in boolean  default null,
    p_point_display_type        in varchar2 default null,
    p_point_svg_shape           in varchar2 default null,
    p_point_svg_shape_scale     in number   default null,
    p_fill_color                in varchar2 default null,
    p_fill_opacity              in varchar2 default null,
    p_fill_value_column         in varchar2 default null,
    p_fill_color_is_spectrum    in boolean  default null,
    p_fill_color_spectr_type    in varchar2 default null,
    p_fill_color_spectr_name    in varchar2 default null,
    p_stroke_color              in varchar2 default null,
    p_stroke_width              in number   default null,
    p_feature_clustering        in varchar2 default null,
    p_label                     in varchar2 default null,
    p_tooltip_adv_formatting    in varchar2 default null,
    p_tooltip_html_expr         in varchar2 default null,
    p_tooltip_column            in varchar2 default null,
    p_info_window_adv_formatting in varchar2 default null,
    p_info_window_html_expr     in varchar2 default null,
    p_no_data_found_message     in varchar2 default null,
    p_link_target               in varchar2 default null,
    p_link_target_type          in varchar2 default null,
    p_legend_icon_css_classes   in varchar2 default null,
    p_display_in_legend         in varchar2 default null,
    p_allow_hide                in varchar2 default null,
    p_items_to_submit           in varchar2 default null,
    p_apply_order_bys           in boolean  default null,
    p_web_src_module_id         in number   default null,
    p_search_expression         in varchar2 default null,
    p_search_static_ids         in varchar2 default null,
    p_row_assignment_column     in varchar2 default null,
    p_row_assignment_value      in varchar2 default null,
    p_visible_max_zoom_level    in number   default null,
    p_extrude_value_column      in varchar2 default null,
    p_extrude_unit              in varchar2 default null,
    p_condition_type            in varchar2 default null);
```

## Cards

### create_card
```sql
procedure create_card (
    p_id                        in number,
    p_region_id                 in number   default current_region_id,
    p_layout_type               in varchar2 default 'GRID',
    p_grid_column_count         in number   default null,
    p_title_adv_formatting      in varchar2 default null,
    p_title_column_name         in varchar2 default null,
    p_title_html_expr           in varchar2 default null,
    p_title_css_classes         in varchar2 default null,
    p_sub_title_adv_formatting  in varchar2 default null,
    p_sub_title_column_name     in varchar2 default null,
    p_sub_title_html_expr       in varchar2 default null,
    p_body_adv_formatting       in varchar2 default null,
    p_body_column_name          in varchar2 default null,
    p_body_html_expr            in varchar2 default null,
    p_second_body_adv_formatting in varchar2 default null,
    p_second_body_column_name   in varchar2 default null,
    p_second_body_html_expr     in varchar2 default null,
    p_badge_column_name         in varchar2 default null,
    p_badge_label               in varchar2 default null,
    p_badge_css_classes         in varchar2 default null,
    p_icon_source_type          in varchar2 default null,
    p_icon_css_classes          in varchar2 default null,
    p_icon_class_column_name    in varchar2 default null,
    p_icon_image_url            in varchar2 default null,
    p_icon_blob_column_name     in varchar2 default null,
    p_icon_position             in varchar2 default null,
    p_icon_description          in varchar2 default null,
    p_media_source_type         in varchar2 default null,
    p_media_url                 in varchar2 default null,
    p_media_url_column_name     in varchar2 default null,
    p_media_blob_column_name    in varchar2 default null,
    p_media_display_position    in varchar2 default null,
    p_media_appearance          in varchar2 default null,
    p_media_sizing              in varchar2 default null,
    p_media_css_classes         in varchar2 default null,
    p_media_adv_formatting      in varchar2 default null,
    p_media_html_expr           in varchar2 default null,
    p_media_description         in varchar2 default null,
    p_mime_type_column_name     in varchar2 default null,
    p_last_updated_column_name  in varchar2 default null,
    p_pk1_column_name           in varchar2 default null,
    p_card_css_classes          in varchar2 default null,
    p_component_css_classes     in varchar2 default null);
```

### create_card_action
```sql
procedure create_card_action (
    p_id                     in number,
    p_card_id                in number,
    p_action_type            in varchar2 default 'BUTTON',
    p_position               in varchar2,
    p_display_sequence       in number,
    p_label                  in varchar2 default null,
    p_link_target            in varchar2 default null,
    p_link_target_type       in varchar2 default null,
    p_link_attributes        in varchar2 default null,
    p_icon_css_classes       in varchar2 default null,
    p_action_css_classes     in varchar2 default null,
    p_is_hot                 in varchar2 default null,
    p_button_display_type    in varchar2 default null,
    p_authorization_scheme   in varchar2 default null,
    p_condition_type         in varchar2 default null,
    p_condition_expr1        in varchar2 default null,
    p_condition_expr2        in varchar2 default null,
    p_exec_cond_for_each_row in varchar2 default null);
```

## Component Actions

### create_component_action
```sql
procedure create_component_action (
    p_id                     in number,
    p_region_id              in number   default null,
    p_position_id            in varchar2 default null,
    p_display_sequence       in number   default null,
    p_label                  in varchar2 default null,
    p_link_target            in varchar2 default null,
    p_link_target_type       in varchar2 default null,
    p_link_attributes        in varchar2 default null,
    p_icon_css_classes       in varchar2 default null,
    p_action_css_classes     in varchar2 default null,
    p_is_hot                 in varchar2 default null,
    p_button_display_type    in varchar2 default null,
    p_template_id            in number   default null,
    p_show_as_disabled       in varchar2 default null,
    p_authorization_scheme   in varchar2 default null,
    p_condition_type         in varchar2 default null,
    p_condition_expr1        in varchar2 default null,
    p_condition_expr2        in varchar2 default null,
    p_exec_cond_for_each_row in varchar2 default null,
    p_operation              in varchar2 default null);
```

### create_comp_menu_entry
```sql
procedure create_comp_menu_entry (
    p_id                     in number,
    p_component_action_id    in number   default null,
    p_menu_entry_type        in varchar2 default null,
    p_display_sequence       in number   default null,
    p_label                  in varchar2 default null,
    p_link_target            in varchar2 default null,
    p_link_target_type       in varchar2 default null,
    p_link_attributes        in varchar2 default null,
    p_icon_css_classes       in varchar2 default null,
    p_operation              in varchar2 default null,
    p_authorization_scheme   in varchar2 default null,
    p_build_option_id        in number   default null,
    p_condition_type         in varchar2 default null,
    p_condition_expr1        in varchar2 default null,
    p_condition_expr2        in varchar2 default null,
    p_exec_cond_for_each_row in varchar2 default null);
```

## Search

### create_search_region_source
```sql
procedure create_search_region_source (
    p_id                    in number,
    p_region_id             in number   default null,
    p_search_config_id      in number   default null,
    p_name                  in varchar2 default null,
    p_display_sequence      in number   default null,
    p_max_results           in number   default null,
    p_use_as_initial_result in varchar2 default null,
    p_condition_type        in varchar2 default null,
    p_condition_expr1       in varchar2 default null,
    p_condition_expr2       in varchar2 default null);
```

## Page Meta Tags

### create_page_meta_tag
```sql
procedure create_page_meta_tag (
    p_id             in number,
    p_meta_tag_name  in varchar2,
    p_meta_tag_value in varchar2 default null);
```

## Utility

```sql
procedure set_calling_version(p_version in number);  -- use wwv_flow_imp.c_apex_24_2
procedure clear_ig_globals;
procedure load_igs(p_application_id in number, p_page_id in number default null);
procedure recreate_ig_rpt(p_application_id in number);
procedure load_irs(p_application_id in number);
procedure relink_ir(p_app_id in number);
procedure load_bg_executions(p_application_id in number);
procedure recreate_bg_executions(p_application_id in number);
```
