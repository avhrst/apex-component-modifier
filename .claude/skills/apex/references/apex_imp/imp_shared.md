# WWV_FLOW_IMP_SHARED -- Shared Component Procedures

Source: APEX 24.2 (`APEX_240200`), validated against 29 example app exports.

Note: All IDs wrapped in `wwv_flow_imp.id()`. Parameters marked _(observed)_ appear in real exports; those marked _(not observed)_ are in the PL/SQL spec but not seen in any export.

---

## State Functions
```sql
function current_lov_id return number;
function current_menu_id return number;
function current_list_id return number;
function current_component_group_id return number;
function current_ai_config_id return number;
```

## Utility
```sql
procedure set_calling_version(p_version in number);
procedure load_build_options(p_application_id in number);
procedure clear_build_options;
procedure load_app_settings(p_application_id in number);
```

---

## Build Options
```sql
procedure create_build_option (
    p_id                     in number,
    p_build_option_name      in varchar2,
    p_build_option_status    in varchar2,      -- INCLUDE | EXCLUDE
    p_build_option_comment   in varchar2 default null,
    p_default_on_export      in varchar2 default null,
    p_on_upgrade_keep_status in boolean  default false,  -- not observed
    p_feature_identifier     in varchar2 default null,
    p_version_scn            in number   default null);
```

## App Settings
```sql
procedure create_app_setting (
    p_id             in number,
    p_name           in varchar2,
    p_value          in varchar2 default null,
    p_is_required    in varchar2 default null,   -- Y | N
    p_valid_values   in varchar2 default null,
    p_required_patch in number   default null,   -- build option ID
    p_comments       in varchar2 default null,
    p_version_scn    in number   default null);
```

---

## User Interface
```sql
procedure create_user_interface (
    p_id                            in number,
    p_theme_id                      in number,
    p_home_url                      in varchar2 default null,
    p_login_url                     in varchar2 default null,
    p_theme_style_by_user_pref      in boolean  default null,
    p_global_page_id                in number   default null,
    p_navigation_list_id            in number   default null,
    p_navigation_list_position      in varchar2 default null,  -- SIDE | TOP
    p_navigation_list_template_id   in number   default null,
    p_nav_list_template_options     in varchar2 default null,
    p_nav_bar_type                  in varchar2 default 'LIST', -- LIST | NAVBAR
    p_nav_bar_list_id               in number   default null,
    p_nav_bar_list_template_id      in number   default null,
    p_nav_bar_template_options      in varchar2 default null);
```

---

## Lists of Values (LOVs)

### Shared LOV definition (SQL or static)
```sql
procedure create_list_of_values (
    p_id                      in number,
    p_lov_name                in varchar2,
    p_lov_query               in varchar2 default null,  -- SQL text or '.' for static
    p_source_type             in varchar2 default null,   -- STATIC | TABLE | SQL_QUERY
    p_location                in varchar2 default null,   -- LOCAL | REMOTE
    p_query_table             in varchar2 default null,
    p_query_owner             in varchar2 default null,
    p_return_column_name      in varchar2 default null,
    p_display_column_name     in varchar2 default null,
    p_default_sort_column_name in varchar2 default null,
    p_default_sort_direction  in varchar2 default null,
    p_reference_id            in number   default null,
    p_use_local_sync_table    in boolean  default null,
    p_version_scn             in number   default null);
```

### LOV columns (for table-based LOVs)
```sql
procedure create_list_of_values_cols (
    p_id               in number,
    p_query_column_name in varchar2,
    p_display_sequence in number,
    p_data_type        in varchar2 default null,
    p_heading          in varchar2 default null,
    p_format_mask      in varchar2 default null,
    p_is_visible       in varchar2 default null,  -- Y | N
    p_is_searchable    in varchar2 default null);  -- Y | N
```

### Static LOV entries
```sql
procedure create_static_lov_data (
    p_id             in number,
    p_lov_disp_sequence in number default null, -- legacy alias for p_sequence
    p_lov_disp_value in varchar2 default null,  -- legacy alias for p_value
    p_lov_return_value in varchar2 default null,
    p_lov_template   in varchar2 default null,
    p_sequence       in number   default null,
    p_value          in varchar2 default null,   -- display value (new style)
    p_cond_type      in varchar2 default null,
    p_cond           in varchar2 default null,
    p_required_patch in number   default null);
```

---

## Navigation Lists
```sql
procedure create_list (
    p_id                in number,
    p_name              in varchar2,
    p_list_status       in varchar2 default null,   -- PUBLIC
    p_list_type         in varchar2 default null,   -- STATIC | SQL_QUERY
    p_list_query        in varchar2 default null,
    p_translate_list_text_y_n in varchar2 default null,
    p_version_scn       in number   default null);

procedure create_list_item (
    p_id                          in number,
    p_list_item_display_sequence  in number,
    p_list_item_link_text         in varchar2,
    p_list_item_link_target       in varchar2 default null,
    p_list_item_icon              in varchar2 default null,
    p_list_item_icon_attributes   in varchar2 default null,
    p_list_item_current_type      in varchar2 default null,  -- TARGET_PAGE | COLON_DELIMITED_PAGE_LIST
    p_list_item_current_for_pages in varchar2 default null,
    p_list_item_current_language  in varchar2 default null,
    p_parent_list_item_id         in number   default null,
    p_sub_list_id                 in number   default null,
    p_security_scheme             in number   default null,
    p_required_patch              in number   default null,  -- build option ID
    p_cond_type                   in varchar2 default null,
    p_condition                   in varchar2 default null,
    p_translate_list_text_y_n     in varchar2 default null);
```

---

## Menus (legacy breadcrumb menus)
```sql
procedure create_menu (
    p_id   in number,
    p_name in varchar2);

procedure create_menu_option (
    p_id              in number,
    p_short_name      in varchar2,
    p_link            in varchar2 default null,
    p_page_id         in number   default null,
    p_option_sequence in number   default null,
    p_parent_id       in number   default null,
    p_security_scheme in number   default null);
```

---

## Security

### Authorization Schemes
```sql
procedure create_security_scheme (
    p_id            in number,
    p_name          in varchar2,
    p_scheme_type   in varchar2,          -- NATIVE_FUNCTION_BODY | NATIVE_IS_IN_GROUP | NATIVE_EXISTS | ...
    p_attribute_01  in varchar2 default null,  -- scheme-type-specific
    p_attribute_02  in varchar2 default null,
    p_error_message in varchar2 default null,
    p_caching       in varchar2 default null,  -- BY_USER_BY_PAGE_VIEW | BY_USER_BY_SESSION
    p_version_scn   in number   default null);
```

### ACL Roles
```sql
procedure create_acl_role (
    p_id          in number,
    p_static_id   in varchar2,
    p_name        in varchar2,
    p_description in varchar2 default null,
    p_version_scn in number   default null);
```

### Authentication Schemes
```sql
procedure create_authentication (
    p_id                   in number,
    p_name                 in varchar2,
    p_scheme_type          in varchar2,          -- NATIVE_APEX_ACCOUNTS | NATIVE_CUSTOM | ...
    p_invalid_session_type in varchar2 default null,  -- LOGIN | URL
    p_invalid_session_url  in varchar2 default null,
    p_cookie_name          in varchar2 default null,
    p_use_secure_cookie_yn in varchar2 default null,  -- Y | N
    p_ras_mode             in number   default null,
    p_plsql_code           in varchar2 default null,
    p_logout_url           in varchar2 default null,
    p_attribute_01         in varchar2 default null,
    p_attribute_02         in varchar2 default null,
    p_attribute_03         in varchar2 default null,  -- function name (custom auth)
    p_attribute_05         in varchar2 default null,
    p_comments             in varchar2 default null,
    p_version_scn          in number   default null);
```

---

## Static Files
```sql
procedure create_app_static_file (
    p_id           in number,
    p_file_name    in varchar2,
    p_mime_type    in varchar2,
    p_file_charset in varchar2 default null);
-- Note: file content blob written separately by the import engine
```

---

## Shortcuts
```sql
procedure create_shortcut (
    p_id               in number,
    p_shortcut_name    in varchar2,
    p_shortcut_type    in varchar2,   -- TEXT_ESCAPE_JS | FUNCTION_BODY | HTML_TEXT
    p_shortcut         in varchar2 default null,
    p_shortcut_language in varchar2 default null,
    p_version_scn      in number   default null);
```

## Messages (translatable text)
```sql
procedure create_message (
    p_id              in number,
    p_name            in varchar2,
    p_message_text    in varchar2,
    p_message_language in varchar2 default null,
    p_is_js_message   in varchar2 default null,  -- Y | N
    p_version_scn     in number   default null);
```

---

## Application Items
```sql
procedure create_flow_item (
    p_id               in number,
    p_name             in varchar2,
    p_protection_level in varchar2 default null,  -- S | I | U | N
    p_item_comment     in varchar2 default null,
    p_required_patch   in number   default null,
    p_output           in varchar2 default null,
    p_version_scn      in number   default null);
```

## Application Processes
```sql
procedure create_flow_process (
    p_id                    in number,
    p_process_name          in varchar2,
    p_process_sequence      in number,
    p_process_point         in varchar2,          -- BEFORE_HEADER | AFTER_HEADER | BEFORE_FOOTER | ON_NEW_INSTANCE
    p_process_type          in varchar2 default null,  -- NATIVE_PLSQL
    p_process_sql_clob      in varchar2 default null,
    p_process_clob_language in varchar2 default null,  -- PLSQL
    p_process_error_message in varchar2 default null,
    p_error_display_location in varchar2 default null,
    p_process_when          in varchar2 default null,
    p_process_when_type     in varchar2 default null,
    p_security_scheme       in number   default null,
    p_version_scn           in number   default null);
```

## Application Computations
```sql
procedure create_flow_computation (
    p_id                        in number,
    p_computation_item          in varchar2,
    p_computation_sequence      in number,
    p_computation_point         in varchar2,       -- BEFORE_HEADER | AFTER_HEADER | ...
    p_computation_type          in varchar2,       -- STATIC_ASSIGNMENT | QUERY | PLSQL_EXPRESSION | FUNCTION_BODY
    p_computation               in varchar2 default null,
    p_computation_language      in varchar2 default null,
    p_computation_processed     in varchar2 default null,
    p_computation_error_message in varchar2 default null,
    p_compute_when              in varchar2 default null,
    p_compute_when_text         in varchar2 default null,
    p_compute_when_type         in varchar2 default null,
    p_required_patch            in number   default null,
    p_version_scn               in number   default null);
```

---

## Icon Bar Items (legacy nav bar)
```sql
procedure create_icon_bar_item (
    p_id                     in number,
    p_icon_sequence           in number,
    p_icon_image              in varchar2 default null,
    p_icon_image_alt          in varchar2 default null,
    p_icon_subtext            in varchar2 default null,
    p_icon_target             in varchar2 default null,
    p_icon_height             in number   default null,
    p_icon_width              in number   default null,
    p_nav_entry_is_feedback_yn in varchar2 default null,
    p_begins_on_new_line      in varchar2 default null,
    p_cell_colspan            in number   default null,
    p_cond_type               in varchar2 default null,
    p_cond                    in varchar2 default null);
```

---

## Themes
```sql
procedure create_theme (
    p_id                           in number,
    p_theme_id                     in number,
    p_theme_name                   in varchar2,
    p_theme_internal_name          in varchar2,
    p_navigation_type              in varchar2 default null,  -- L (list)
    p_nav_bar_type                 in varchar2 default null,
    p_default_nav_list_position    in varchar2 default null,
    p_is_locked                    in boolean  default null,
    p_icon_library                 in varchar2 default null,  -- FONT_APEX_3
    p_files_version                in number   default null,
    p_javascript_file_urls         in varchar2 default null,
    p_css_file_urls                in varchar2 default null,
    p_reference_id                 in number   default null,
    p_version_identifier           in varchar2 default null,
    p_current_theme_style_id       in number   default null,
    -- default template IDs (one per component type):
    p_default_page_template        in number default null,
    p_default_region_template      in number default null,
    p_default_report_template      in number default null,
    p_default_list_template        in number default null,
    p_default_label_template       in number default null,
    p_default_button_template      in number default null,
    p_default_menu_template        in number default null,
    p_default_calendar_template    in number default null,
    p_default_chart_template       in number default null,
    p_default_form_template        in number default null,
    p_default_wizard_template      in number default null,
    p_default_dialog_template      in number default null,
    p_default_irr_template         in number default null,
    p_default_tabform_template     in number default null,
    p_default_option_label         in number default null,
    p_default_required_label       in number default null,
    p_default_reportr_template     in number default null,
    p_default_listr_template       in number default null,
    p_default_menur_template       in number default null,
    p_default_dialogr_template     in number default null,
    p_default_dialogbtnr_template  in number default null,
    p_default_navbar_list_template in number default null,
    p_default_nav_list_template    in number default null,
    p_default_side_nav_list_temp   in number default null,
    p_default_header_template      in number default null,
    p_default_footer_template      in number default null,
    p_login_template               in number default null,
    p_error_template               in number default null,
    p_printer_friendly_template    in number default null,
    p_breadcrumb_display_point     in varchar2 default null,
    p_sidebar_display_point        in varchar2 default null,
    p_nav_list_temp                in number default null);

procedure create_theme_style (
    p_id                           in number,
    p_theme_id                     in number,
    p_name                         in varchar2,
    p_is_public                    in boolean  default null,
    p_is_accessible                in boolean  default null,
    p_css_classes                  in varchar2 default null,
    p_css_file_urls                in varchar2 default null,
    p_theme_roller_input_file_urls in varchar2 default null,
    p_theme_roller_output_file_url in varchar2 default null,
    p_theme_roller_config          in varchar2 default null,
    p_theme_roller_read_only       in boolean  default null);

procedure create_theme_file (
    p_id           in number,
    p_theme_id     in number,
    p_file_name    in varchar2,
    p_mime_type    in varchar2,
    p_file_charset in varchar2 default null);
```

---

## Templates

### Page Templates
```sql
procedure create_template (
    p_id                   in number,
    p_theme_id             in number,
    p_name                 in varchar2,
    p_internal_name        in varchar2 default null,
    p_is_popup             in boolean  default null,
    p_header_template      in varchar2 default null,
    p_box                  in varchar2 default null,
    p_footer_template      in varchar2 default null,
    p_success_message      in varchar2 default null,
    p_notification_message in varchar2 default null);
```

### Page Template Display Points
```sql
procedure create_page_tmpl_display_point (
    p_id                  in number,
    p_page_template_id    in number,
    p_name                in varchar2,
    p_placeholder         in varchar2,
    p_has_grid_support    in boolean default null,
    p_has_region_support  in boolean default null,
    p_has_item_support    in boolean default null,
    p_has_button_support  in boolean default null,
    p_glv_new_row         in boolean default null,
    p_max_fixed_grid_columns in number default null);
```

### Region (Plug) Templates
```sql
procedure create_plug_template (
    p_id                       in number,
    p_theme_id                 in number,
    p_name                     in varchar2 default null,
    p_page_plug_template_name  in varchar2 default null,  -- legacy alias
    p_internal_name            in varchar2 default null,
    p_layout                   in varchar2 default null,
    p_template                 in varchar2 default null,
    p_theme_class_id           in number   default null,
    p_default_label_alignment  in varchar2 default null,
    p_default_field_alignment  in varchar2 default null,
    p_translate_this_template  in varchar2 default null);

procedure create_plug_tmpl_display_point (
    p_id                 in number,
    p_plug_template_id   in number,
    p_name               in varchar2,
    p_placeholder        in varchar2,
    p_has_grid_support   in boolean default null,
    p_has_region_support in boolean default null,
    p_has_item_support   in boolean default null,
    p_has_button_support in boolean default null,
    p_glv_new_row        in boolean default null);
```

### Report (Row) Templates
```sql
procedure create_row_template (
    p_id                        in number,
    p_theme_id                  in number,
    p_row_template_name         in varchar2,
    p_internal_name             in varchar2 default null,
    p_row_template_type         in varchar2 default null,
    p_row_template_before_rows  in varchar2 default null,
    p_row_template_after_rows   in varchar2 default null,
    p_column_heading_template   in varchar2 default null,
    p_theme_class_id            in number   default null,
    p_translate_this_template   in varchar2 default null,
    p_next_page_template        in varchar2 default null,
    p_previous_page_template    in varchar2 default null,
    p_next_set_template         in varchar2 default null,
    p_previous_set_template     in varchar2 default null,
    p_pagination_template       in varchar2 default null);
```

### Template Options & Groups
```sql
procedure create_template_opt_group (
    p_id               in number,
    p_theme_id         in number,
    p_name             in varchar2,
    p_display_name     in varchar2 default null,
    p_display_sequence in number   default null,
    p_template_types   in varchar2 default null,  -- REGION | BUTTON | REPORT | LIST | ...
    p_is_advanced      in varchar2 default null,   -- Y | N
    p_null_text        in varchar2 default null);

procedure create_template_option (
    p_id                in number,
    p_theme_id          in number,
    p_name              in varchar2,
    p_display_name      in varchar2,
    p_display_sequence  in number   default null,
    p_css_classes       in varchar2 default null,
    p_template_types    in varchar2 default null,
    p_page_template_id  in number   default null,
    p_text              in varchar2 default null);
```

---

## Plugins

### Plugin Definition
```sql
procedure create_plugin (
    p_id                        in number,
    p_plugin_type               in varchar2,  -- REGION TYPE | ITEM TYPE | DYNAMIC ACTION | PROCESS TYPE | TEMPLATE COMPONENT | WEB SOURCE TYPE
    p_name                      in varchar2,  -- reverse-DNS name
    p_display_name              in varchar2,
    p_image_prefix              in varchar2 default null,
    p_api_version               in number   default null,
    p_render_function           in varchar2 default null,
    p_ajax_function             in varchar2 default null,
    p_plsql_code                in varchar2 default null,
    p_css_file_urls             in varchar2 default null,
    p_javascript_file_urls      in varchar2 default null,
    p_standard_attributes       in varchar2 default null,
    p_substitute_attributes     in boolean  default null,
    p_subscribe_plugin_settings in boolean  default null,
    p_supported_component_types in varchar2 default null,
    p_default_escape_mode       in varchar2 default null,
    p_files_version             in number   default null,
    p_reference_id              in number   default null,
    p_static_id                 in varchar2 default null,
    p_version_scn               in number   default null,
    -- template component specific:
    p_partial_template          in varchar2 default null,
    p_report_row_template       in varchar2 default null,
    p_report_body_template      in varchar2 default null,
    p_report_placeholder_count  in number   default null,
    p_translate_this_template   in varchar2 default null,
    p_theme_id                  in number   default null);
```

### Plugin Attribute
```sql
procedure create_plugin_attribute (
    p_id                        in number,
    p_plugin_id                 in number,
    p_attribute_scope           in varchar2,  -- COMPONENT | APPLICATION
    p_attribute_sequence        in number,
    p_display_sequence          in number,
    p_static_id                 in varchar2 default null,
    p_prompt                    in varchar2 default null,
    p_attribute_type            in varchar2 default null,  -- TEXT | TEXTAREA | NUMBER | SELECT LIST | PAGE ITEM | ...
    p_is_required               in boolean  default null,
    p_is_translatable           in boolean  default null,
    p_is_common                 in boolean  default null,
    p_show_in_wizard            in boolean  default null,
    p_default_value             in varchar2 default null,
    p_demo_value                in varchar2 default null,
    p_display_length            in number   default null,
    p_max_length                in number   default null,
    p_lov_type                  in varchar2 default null,     -- STATIC
    p_escape_mode               in varchar2 default null,
    p_column_data_types         in varchar2 default null,
    p_sql_min_column_count      in number   default null,
    p_sql_max_column_count      in number   default null,
    p_null_text                 in varchar2 default null,
    p_depending_on_attribute_id in number   default null,
    p_depending_on_has_to_exist in boolean  default null,
    p_depending_on_condition_type in varchar2 default null,
    p_depending_on_expression   in varchar2 default null,
    p_supported_component_types in varchar2 default null,
    p_reference_scope           in varchar2 default null);
```

### Plugin Attribute Value (LOV entries for plugin attributes)
```sql
procedure create_plugin_attr_value (
    p_id                  in number,
    p_plugin_attribute_id in number,
    p_display_sequence    in number,
    p_display_value       in varchar2,
    p_return_value        in varchar2);
```

### Plugin Attribute Group
```sql
procedure create_plugin_attr_group (
    p_id               in number,
    p_plugin_id        in number,
    p_title            in varchar2,
    p_display_sequence in number default null);
```

### Plugin Standard Attribute
```sql
procedure create_plugin_std_attribute (
    p_id                        in number,
    p_plugin_id                 in number,
    p_name                      in varchar2 default null,
    p_display_name              in varchar2 default null,
    p_is_required               in boolean  default null,
    p_default_value             in varchar2 default null,
    p_examples                  in varchar2 default null,
    p_sql_min_column_count      in number   default null,
    p_sql_max_column_count      in number   default null,
    p_depending_on_has_to_exist in boolean  default null);
```

### Plugin Event
```sql
procedure create_plugin_event (
    p_id        in number,
    p_plugin_id in number,
    p_name      in varchar2,
    p_display_name in varchar2 default null);
```

### Plugin File
```sql
procedure create_plugin_file (
    p_id           in number,
    p_plugin_id    in number,
    p_file_name    in varchar2,
    p_mime_type    in varchar2,
    p_file_charset in varchar2 default null,
    p_file_content in blob     default null);
```

### Plugin Action Position (template component slots)
```sql
procedure create_plugin_act_position (
    p_id               in number,
    p_plugin_id        in number,
    p_name             in varchar2,
    p_static_id        in varchar2,
    p_display_sequence in number,
    p_type             in varchar2);  -- LINK | TEMPLATE
```

### Plugin Action Template (template component action rendering)
```sql
procedure create_plugin_act_template (
    p_id               in number,
    p_plugin_id        in number,
    p_name             in varchar2,
    p_type             in varchar2,       -- BUTTON | MENU
    p_template         in varchar2 default null,
    p_display_sequence in number   default null);
```

---

## Web Sources

### Module
```sql
procedure create_web_source_module (
    p_id                       in number,
    p_name                     in varchar2,
    p_static_id                in varchar2 default null,
    p_web_source_type          in varchar2,          -- NATIVE_HTTP | NATIVE_ORDS | plugin name
    p_data_profile_id          in number   default null,
    p_remote_server_id         in number   default null,
    p_url_path_prefix          in varchar2 default null,
    p_credential_id            in number   default null,
    p_pass_ecid                in boolean  default null,
    p_allow_fetch_all_rows     in boolean  default null,
    p_legacy_ords_fixed_page_size in boolean default null,
    p_sync_type                in varchar2 default null,
    p_sync_table_name          in varchar2 default null,
    p_caching                  in varchar2 default null,
    p_invalidate_when          in varchar2 default null,
    p_attribute_05             in varchar2 default null,
    p_attribute_08             in varchar2 default null,
    p_attribute_10             in varchar2 default null,
    p_attribute_11             in varchar2 default null,
    p_version_scn              in number   default null);
```

### Operation
```sql
procedure create_web_source_operation (
    p_id                   in number,
    p_web_src_module_id    in number,
    p_operation            in varchar2,           -- GET | POST | PUT | DELETE
    p_database_operation   in varchar2,           -- FETCH_COLLECTION | FETCH_SINGLE_ROW | INSERT | UPDATE | DELETE
    p_url_pattern          in varchar2 default null,
    p_request_body_template in varchar2 default null,
    p_force_error_for_http_404 in boolean default null,
    p_allow_fetch_all_rows in boolean  default null);
```

### Parameter
```sql
procedure create_web_source_param (
    p_id                  in number,
    p_web_src_module_id   in number,
    p_web_src_operation_id in number default null,
    p_name                in varchar2,
    p_param_type          in varchar2 default null,  -- URL_PATTERN | QUERY_STRING | HEADER
    p_data_type           in varchar2 default null,
    p_is_required         in boolean  default null,
    p_is_static           in boolean  default null,
    p_is_query_param      in boolean  default null,
    p_direction           in varchar2 default null,
    p_value               in varchar2 default null);
```

### Component Parameter (web source → search config binding)
```sql
procedure create_web_source_comp_param (
    p_id                   in number,
    p_web_src_module_id    in number,
    p_web_src_operation_id in number   default null,
    p_web_src_param_id     in number   default null,
    p_search_config_id     in number   default null,
    p_value_type           in varchar2 default null,
    p_value                in varchar2 default null);
```

---

## Data Profiles (used by web sources and data loads)
```sql
procedure create_data_profile (
    p_id                      in number,
    p_name                    in varchar2,
    p_format                  in varchar2,          -- JSON | CSV | XML | XLSX
    p_encoding                in varchar2 default null,
    p_row_selector            in varchar2 default null,
    p_is_single_row           in boolean  default null,
    p_has_header_row          in boolean  default null,
    p_csv_separator           in varchar2 default null,
    p_csv_enclosed            in varchar2 default null,
    p_decimal_char            in varchar2 default null,
    p_default_xlsx_sheet_name in varchar2 default null,
    p_use_raw_json_selectors  in boolean  default null);

procedure create_data_profile_col (
    p_id               in number,
    p_data_profile_id  in number,
    p_name             in varchar2,
    p_sequence         in number,
    p_column_type      in varchar2 default null,  -- DATA | DERIVED | TRANSFORMATIONS
    p_data_type        in varchar2 default null,  -- VARCHAR2 | NUMBER | DATE | TIMESTAMP | CLOB | BLOB
    p_max_length       in number   default null,
    p_format_mask      in varchar2 default null,
    p_has_time_zone    in boolean  default null,
    p_is_primary_key   in boolean  default null,
    p_is_hidden        in boolean  default null,
    p_is_filterable    in boolean  default null,
    p_selector_type    in varchar2 default null,   -- NAME | INDEX | PATH
    p_selector         in varchar2 default null,
    p_remote_data_type in varchar2 default null,
    p_transform_type   in varchar2 default null,
    p_parent_column_id in number   default null);
```

---

## Data Loads
```sql
procedure create_load_table (
    p_id                  in number,
    p_name                in varchar2,
    p_static_id           in varchar2 default null,
    p_target_type         in varchar2 default null,  -- TABLE | SQL_QUERY
    p_table_name          in varchar2 default null,
    p_owner               in varchar2 default null,
    p_data_profile_id     in number   default null,
    p_loading_method      in varchar2 default null,  -- REPLACE | MERGE | APPEND
    p_commit_interval     in number   default null,
    p_error_handling      in varchar2 default null,  -- ABORT | SKIP_ROW
    p_error_collection_name in varchar2 default null,
    p_column_names_lov_id in number   default null,
    p_skip_validation     in varchar2 default null,  -- Y | N
    p_version_scn         in number   default null);

procedure create_load_table_lookup (
    p_id                 in number,
    p_load_table_id      in number,
    p_load_column_name   in varchar2,
    p_lookup_owner       in varchar2 default null,  -- #OWNER#
    p_lookup_table_name  in varchar2 default null,
    p_key_column         in varchar2 default null,
    p_display_column     in varchar2 default null,
    p_insert_new_value   in varchar2 default null);  -- Y | N

procedure create_load_table_rule (
    p_id               in number,
    p_load_table_id    in number,
    p_load_column_name in varchar2 default null,
    p_rule_name        in varchar2 default null,
    p_rule_sequence    in number   default null,
    p_rule_type        in varchar2 default null);
```

---

## Automations
```sql
procedure create_automation (
    p_id                    in number,
    p_name                  in varchar2,
    p_static_id             in varchar2 default null,
    p_trigger_type          in varchar2,             -- POLLING | API
    p_polling_interval      in varchar2 default null,
    p_polling_status        in varchar2 default null, -- DISABLED | ACTIVE
    p_result_type           in varchar2 default null, -- ALWAYS | ROWS_FOUND | NO_ROWS_FOUND
    p_query_type            in varchar2 default null,
    p_query_table           in varchar2 default null,
    p_location              in varchar2 default null,
    p_include_rowid_column  in boolean  default null,
    p_use_local_sync_table  in boolean  default null,
    p_commit_each_row       in boolean  default null,
    p_error_handling_type   in varchar2 default null); -- IGNORE | STOP

procedure create_automation_action (
    p_id                 in number,
    p_automation_id      in number,
    p_name               in varchar2,
    p_execution_sequence in number,
    p_action_type        in varchar2,           -- NATIVE_PLSQL | NATIVE_EXECUTE_CODE | ...
    p_action_clob        in varchar2 default null,
    p_action_clob_language in varchar2 default null,
    p_location           in varchar2 default null,
    p_execution_on_error in varchar2 default null);
```

---

## Workflows
```sql
procedure create_workflow (
    p_id        in number,
    p_name      in varchar2,
    p_static_id in varchar2 default null,
    p_title     in varchar2 default null);

procedure create_workflow_version (
    p_id                in number,
    p_workflow_id       in number,
    p_version           in varchar2,
    p_state             in varchar2,            -- DEVELOPMENT | ACTIVE | INACTIVE
    p_query_type        in varchar2 default null,  -- SQL | TABLE
    p_query_source      in varchar2 default null,
    p_query_table       in varchar2 default null,
    p_pk_column         in varchar2 default null,
    p_diagram           in varchar2 default null,   -- layout hint
    p_comment           in varchar2 default null);

procedure create_workflow_variable (
    p_id                    in number,
    p_workflow_id           in number   default null,   -- top-level variable
    p_workflow_version_id   in number   default null,   -- version-level variable
    p_label                 in varchar2,
    p_static_id             in varchar2 default null,
    p_direction             in varchar2,                 -- IN | OUT | VARIABLE
    p_data_type             in varchar2,                 -- VARCHAR2 | NUMBER | DATE
    p_is_required           in boolean  default null,
    p_value_type            in varchar2 default null,    -- NULL | STATIC | EXPRESSION
    p_value                 in varchar2 default null,
    p_value_language        in varchar2 default null);

procedure create_workflow_activity (
    p_id                    in number,
    p_workflow_version_id   in number,
    p_name                  in varchar2,
    p_static_id             in varchar2 default null,
    p_display_sequence      in number,
    p_activity_type         in varchar2,            -- NATIVE_WORKFLOW_START | NATIVE_WORKFLOW_END | NATIVE_CREATE_TASK | NATIVE_INVOKE_API | NATIVE_SWITCH
    p_attribute_01          in varchar2 default null,   -- task_def_id (for CREATE_TASK), package owner, etc.
    p_attribute_03          in varchar2 default null,
    p_attribute_04          in varchar2 default null,
    p_attribute_05          in varchar2 default null,
    p_attribute_10          in varchar2 default null,
    p_due_on_type           in varchar2 default null,   -- EXPRESSION | INTERVAL
    p_due_on_language       in varchar2 default null,
    p_due_on_value          in varchar2 default null,
    p_diagram               in varchar2 default null,
    p_comment               in varchar2 default null);

procedure create_workflow_transition (
    p_id                  in number,
    p_workflow_version_id in number default null,
    p_name                in varchar2,
    p_transition_type     in varchar2,             -- NORMAL | TIMEOUT | ERROR
    p_from_activity_id    in number,
    p_to_activity_id      in number,
    p_condition_type      in varchar2 default null,
    p_diagram             in varchar2 default null);

procedure create_workflow_participant (
    p_id                  in number,
    p_workflow_version_id in number,
    p_participant_type    in varchar2,              -- OWNER | ADMIN | CONTRIBUTOR
    p_name                in varchar2,
    p_identity_type       in varchar2 default null, -- USER | GROUP
    p_value_type          in varchar2 default null, -- STATIC | EXPRESSION
    p_value_language      in varchar2 default null,
    p_value               in varchar2 default null);

procedure create_workflow_comp_param (
    p_id                    in number,
    p_workflow_version_id   in number   default null,
    p_workflow_activity_id  in number   default null,
    p_name                  in varchar2,
    p_static_id             in varchar2 default null,
    p_direction             in varchar2 default null,   -- IN | OUT
    p_data_type             in varchar2 default null,
    p_display_sequence      in number   default null,
    p_has_default           in boolean  default null,
    p_value_type            in varchar2 default null,
    p_value                 in varchar2 default null,
    p_ignore_output         in boolean  default null);

procedure create_invokeapi_comp_param (
    p_id                   in number,
    p_workflow_activity_id in number,
    p_name                 in varchar2,
    p_direction            in varchar2,           -- IN | OUT
    p_data_type            in varchar2,
    p_has_default          in boolean  default null,
    p_display_sequence     in number   default null,
    p_value_type           in varchar2 default null, -- ITEM | STATIC | EXPRESSION
    p_value                in varchar2 default null);
```

---

## Task Definitions (Human Tasks)
```sql
procedure create_task_def (
    p_id                    in number,
    p_name                  in varchar2,
    p_static_id             in varchar2 default null,
    p_subject               in varchar2 default null,
    p_task_type             in varchar2 default null,   -- ACTION | APPROVAL
    p_priority              in number   default null,
    p_expiration_policy     in varchar2 default null,   -- NONE | EXPIRE | RENEW
    p_max_renewal_count     in number   default null,
    p_before_expire_interval in varchar2 default null,
    p_due_on_type           in varchar2 default null,
    p_due_on_interval       in varchar2 default null,
    p_details_link_target   in varchar2 default null,
    p_initiator_can_complete in boolean default null,
    p_actions_sql_query     in varchar2 default null,
    p_vacation_rule_procedure in varchar2 default null);

procedure create_task_def_param (
    p_id          in number,
    p_task_def_id in number,
    p_label       in varchar2,
    p_static_id   in varchar2 default null,
    p_data_type   in varchar2 default null,  -- VARCHAR2 | NUMBER | DATE
    p_is_required in boolean  default null,
    p_is_visible  in boolean  default null);

procedure create_task_def_action (
    p_id                    in number,
    p_task_def_id           in number,
    p_name                  in varchar2,
    p_execution_sequence    in number,
    p_outcome               in varchar2 default null,    -- APPROVED | REJECTED
    p_on_event              in varchar2 default null,    -- COMPLETE | EXPIRE
    p_action_type           in varchar2 default null,    -- NATIVE_PLSQL | NATIVE_EXECUTE_CODE
    p_action_clob           in varchar2 default null,
    p_action_clob_language  in varchar2 default null,
    p_location              in varchar2 default null,
    p_success_message       in varchar2 default null,
    p_stop_execution_on_error in boolean default null,
    p_condition_type        in varchar2 default null,
    p_execution_on_error    in varchar2 default null,
    p_log_message_type      in varchar2 default null);

procedure create_task_def_participant (
    p_id               in number,
    p_task_def_id      in number,
    p_participant_type in varchar2,           -- POTENTIAL_OWNER | BUSINESS_ADMIN
    p_identity_type    in varchar2 default null,  -- USER | GROUP
    p_value_type       in varchar2 default null,  -- STATIC | EXPRESSION
    p_value_language   in varchar2 default null,
    p_value            in varchar2 default null);

procedure create_task_def_comp_param (
    p_id                    in number,
    p_workflow_version_id   in number   default null,
    p_workflow_activity_id  in number   default null,
    p_task_def_param_id     in number   default null,
    p_name                  in varchar2 default null,
    p_static_id             in varchar2 default null,
    p_direction             in varchar2 default null,
    p_data_type             in varchar2 default null,
    p_display_sequence      in number   default null,
    p_has_default           in boolean  default null,
    p_value_type            in varchar2 default null,
    p_value                 in varchar2 default null,
    p_location              in varchar2 default null,
    p_activity_type         in varchar2 default null,
    p_activity_code         in varchar2 default null,
    p_activity_code_language in varchar2 default null,
    p_comment               in varchar2 default null,
    p_diagram               in varchar2 default null);
```

---

## Email Templates
```sql
procedure create_email_template (
    p_id             in number,
    p_name           in varchar2,
    p_static_id      in varchar2 default null,
    p_subject        in varchar2 default null,
    p_html_body      in varchar2 default null,
    p_html_header    in varchar2 default null,
    p_html_footer    in varchar2 default null,
    p_html_template  in varchar2 default null,
    p_text_template  in varchar2 default null,
    p_version_number in number   default null,
    p_version_scn    in number   default null);
```

---

## Search Configurations
```sql
procedure create_search_config (
    p_id                        in number,
    p_label                     in varchar2,
    p_static_id                 in varchar2 default null,
    p_search_type               in varchar2,          -- SIMPLE | ORACLE_TEXT | VECTOR
    p_location                  in varchar2 default null,   -- LOCAL | REMOTE
    p_query_type                in varchar2 default null,   -- SQL | TABLE
    p_query_source              in varchar2 default null,
    p_query_table               in varchar2 default null,
    p_query_where               in varchar2 default null,
    p_query_order_by            in varchar2 default null,
    p_searchable_columns        in varchar2 default null,   -- colon-separated
    p_pk_column_name            in varchar2 default null,
    p_title_column_name         in varchar2 default null,
    p_subtitle_column_name      in varchar2 default null,
    p_description_column_name   in varchar2 default null,
    p_badge_column_name         in varchar2 default null,
    p_last_modified_column_name in varchar2 default null,
    p_link_target               in varchar2 default null,
    p_link_target_type          in varchar2 default null,
    p_icon_source_type          in varchar2 default null,   -- STATIC_CLASS | INITIALS | BLOB
    p_icon_css_classes          in varchar2 default null,
    p_icon_class_column_name    in varchar2 default null,
    p_icon_image_url            in varchar2 default null,
    p_icon_blob_column_name     in varchar2 default null,
    p_icon_mimetype_column_name in varchar2 default null,
    p_default_row_html_expr     in varchar2 default null,
    p_return_max_results        in number   default null,
    p_search_prefix             in varchar2 default null,
    p_function_body_language    in varchar2 default null,
    -- Oracle Text specific:
    p_oratext_function_type     in varchar2 default null,
    p_oratext_function          in varchar2 default null,
    p_oratext_index_column_name in varchar2 default null,
    -- Vector search specific:
    p_vector_search_type        in varchar2 default null,
    p_vector_distance_metric    in varchar2 default null,
    -- Remote web source:
    p_web_src_module_id         in number   default null,
    p_web_src_param_id          in number   default null,
    p_version_scn               in number   default null);
```

---

## PWA (Progressive Web App)
```sql
procedure create_pwa_shortcut (
    p_id                  in number,
    p_name                in varchar2,
    p_target_url          in varchar2 default null,
    p_description         in varchar2 default null,
    p_icon_url            in varchar2 default null,
    p_display_sequence    in number   default null,
    p_pwa_shortcut_comment in varchar2 default null);

procedure create_pwa_screenshot (
    p_id               in number,
    p_screenshot_url   in varchar2,
    p_label            in varchar2 default null,
    p_display_sequence in number   default null);
```

---

## AI Configuration
```sql
procedure create_ai_config (
    p_id               in number,
    p_name             in varchar2,
    p_static_id        in varchar2 default null,
    p_remote_server_id in number   default null,
    p_config_comment   in varchar2 default null,
    p_version_scn      in number   default null);
```

---

## Report Layouts
```sql
procedure create_report_layout (
    p_id                  in number,
    p_report_layout_name  in varchar2,
    p_report_layout_type  in varchar2 default null,
    p_static_id           in varchar2 default null);
```
