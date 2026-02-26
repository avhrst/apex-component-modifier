# WWV_FLOW_IMP_PAGE -- Page Component Procedures

Source: APEX 24.2 (`APEX_240200`).

## Page

### create_page
```sql
procedure create_page (
    p_id                          in number,              -- raw page number (NOT wwv_flow_imp.id())
    p_flow_id                     in number   default wwv_flow.g_flow_id,
    p_name                        in varchar2 default null,
    p_alias                       in varchar2 default null,
    p_page_mode                   in varchar2 default 'NORMAL',    -- NORMAL | MODAL DIALOG | NON-MODAL DIALOG
    p_step_title                  in varchar2 default null,
    p_step_template               in number   default null,        -- page template ID
    p_page_template_options       in varchar2 default null,
    p_required_role               in varchar2 default null,        -- authorization scheme
    p_required_patch              in number   default null,        -- build option
    p_reload_on_submit            in varchar2 default 'S',         -- S=Smart, A=Always, N=Never
    p_warn_on_unsaved_changes     in varchar2 default 'Y',
    p_javascript_code_onload      in varchar2 default null,
    p_inline_css                  in varchar2 default null,
    p_page_is_public_y_n          in varchar2 default 'N',
    p_protection_level            in varchar2 default 'N',
    p_group_id                    in number   default null
    -- also: p_help_text, p_page_css_classes, p_allow_duplicate_submissions,
    -- p_javascript_code, p_css_file_urls, p_dialog_title/height/width/chained,
    -- p_last_updated_by, p_last_upd_yyyymmddhh24miss
    );
```

### create_page_group
```sql
procedure create_page_group (
    p_id in number, p_flow_id in number default wwv_flow.g_flow_id,
    p_group_name in varchar2, p_group_desc in varchar2 default null);
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
    p_parent_plug_id              in number   default null,
    p_plug_display_point          in varchar2 default 'BODY',
    p_plug_template               in number   default null,        -- region template ID
    p_plug_display_sequence       in varchar2 default null,
    p_plug_source_type            in varchar2 default 'NATIVE_STATIC',
    p_location                    in varchar2 default 'LOCAL',     -- LOCAL | REMOTE | WEB_SOURCE
    p_query_type                  in varchar2 default null,        -- SQL | TABLE | FUNC_BODY_RETURNING_SQL
    p_plug_source                 in varchar2 default null,        -- SQL query or static content
    p_query_table                 in varchar2 default null,        -- table name (query_type=TABLE)
    p_is_editable                 in boolean  default null,
    p_edit_operations             in varchar2 default null,        -- i:u:d
    p_plug_template_options       in varchar2 default null,        -- #DEFAULT#:t-Region--scrollBody
    p_required_role               in varchar2 default null,
    p_required_patch              in number   default null
    -- also: p_flow_id, p_title, p_region_name, p_ajax_enabled, p_lazy_loading,
    -- p_lost_update_check_type, p_include_rowid_column, p_plug_query_options
    );
```
Sets `current_region_id` after creation.

### create_report_columns (Classic Report)
```sql
procedure create_report_columns (
    p_id in number, p_region_id in number default current_region_id,
    p_column_alias in varchar2, p_column_display_sequence in varchar2,
    p_column_heading in varchar2, p_column_alignment in varchar2 default 'LEFT',
    p_hidden_column in varchar2 default 'N', p_display_as in varchar2 default 'ESCAPE_SC',
    p_column_link in varchar2 default null, p_column_linktext in varchar2 default null);
```

### create_region_column (IG / Cards / Modern)
```sql
procedure create_region_column (
    p_id in number, p_region_id in number default current_region_id,
    p_name in varchar2, p_source_type in varchar2 default null,
    p_source_expression in varchar2 default null, p_data_type in varchar2 default null,
    p_item_type in varchar2 default null, p_is_visible in boolean default null,
    p_heading in varchar2 default null, p_display_sequence in number,
    p_is_primary_key in boolean default null, p_is_required in boolean default null
    -- also: p_flow_id, p_page_id, p_enable_filter, p_enable_sort_group
    );
```

## Page Items

### create_page_item
```sql
procedure create_page_item (
    p_id                    in number   default null,
    p_name                  in varchar2 default null,           -- P<page>_<name>
    p_data_type             in varchar2 default 'VARCHAR2',
    p_is_required           in boolean  default false,
    p_item_sequence         in number   default null,
    p_item_plug_id          in number   default null,           -- parent region ID
    p_prompt                in varchar2 default null,           -- label text
    p_source                in varchar2 default null,           -- column name or expression
    p_source_type           in varchar2 default 'ALWAYS_NULL', -- DB_COLUMN, STATIC, REGION_SOURCE_COLUMN, etc.
    p_display_as            in varchar2 default null,           -- NATIVE_TEXT_FIELD, NATIVE_SELECT_LIST, etc.
    p_named_lov             in varchar2 default null,           -- shared LOV ID or name
    p_lov                   in varchar2 default null,           -- inline LOV query
    p_lov_display_null      in varchar2 default 'NO',
    p_lov_null_text         in varchar2 default null,
    p_lov_cascade_parent_items in varchar2 default null,
    p_field_template        in varchar2 default null,           -- label template ID
    p_item_template_options in varchar2 default null,
    p_display_when          in varchar2 default null,
    p_display_when_type     in varchar2 default null,
    p_read_only_when        in varchar2 default null,
    p_read_only_when_type   in varchar2 default null,
    p_security_scheme       in varchar2 default null,
    p_attribute_01 .. p_attribute_25 in varchar2 default null  -- plugin/type-specific attrs
    -- also: p_flow_id, p_flow_step_id, p_is_primary_key, p_item_source_plug_id,
    -- p_placeholder, p_format_mask, p_source_data_type, p_cSize, p_cMaxlength,
    -- p_cHeight, p_help_text, p_is_persistent, p_protection_level,
    -- p_ai_enabled, p_ai_config_id
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
    p_button_position            in varchar2 default 'BODY',
    p_button_name                in varchar2 default null,          -- REQUEST value
    p_button_template_id         in number   default null,
    p_button_is_hot              in varchar2 default 'N',
    p_button_image_alt           in varchar2 default null,          -- label text
    p_button_action              in varchar2 default null,          -- SUBMIT | REDIRECT_URL | REDIRECT_PAGE | DEFINED_BY_DA
    p_button_execute_validations in varchar2 default 'Y',
    p_button_condition           in varchar2 default null,
    p_button_condition_type      in varchar2 default null,
    p_database_action            in varchar2 default null           -- INSERT | UPDATE | DELETE
    -- also: p_flow_id, p_flow_step_id, p_button_static_id, p_button_redirect_url,
    -- p_confirm_message, p_icon_css_classes, p_security_scheme
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
    p_process_sql             in varchar2 default null,
    p_process_sql_clob        in varchar2 default null,
    p_attribute_01 .. p_attribute_15 in varchar2 default null,
    p_process_error_message   in varchar2 default null,
    p_error_display_location  in varchar2 default 'ON_ERROR_PAGE',
    p_process_when_button_id  in number   default null,
    p_process_when            in varchar2 default null,
    p_process_when_type       in varchar2 default null,
    p_security_scheme         in varchar2 default null
    -- also: p_flow_id, p_flow_step_id, p_process_clob_language, p_location,
    -- p_process_success_message, p_internal_uid
    );
```

## Validations

### create_page_validation
```sql
procedure create_page_validation (
    p_id in number, p_validation_name in varchar2,
    p_validation_sequence in number, p_validation in varchar2,
    p_validation2 in varchar2 default null,
    p_validation_type in varchar2,  -- ITEM_REQUIRED | FUNC_BODY_RETURNING_BOOLEAN | ...
    p_error_message in varchar2, p_always_execute in varchar2 default 'N',
    p_when_button_pressed in varchar2 default null,
    p_associated_item in number default null,
    p_error_display_location in varchar2 default 'ON_ERROR_PAGE'
    -- also: p_flow_id, p_flow_step_id
    );
```

## Computations

### create_page_computation
```sql
procedure create_page_computation (
    p_id in number, p_computation_sequence in number,
    p_computation_item in varchar2,
    p_computation_point in varchar2 default 'AFTER_SUBMIT',
    p_computation_type in varchar2 default 'SQL_EXPRESSION',
    p_computation in varchar2,
    p_compute_when in varchar2 default null, p_compute_when_type in varchar2 default null
    -- also: p_flow_id, p_flow_step_id, p_security_scheme
    );
```

## Branches

### create_page_branch
```sql
procedure create_page_branch (
    p_id in number, p_branch_name in varchar2 default null,
    p_branch_action in varchar2, p_branch_point in varchar2,
    p_branch_type in varchar2,  -- REDIRECT_URL | BRANCH_TO_PAGE_ACCEPT | ...
    p_branch_when_button_id in number default null,
    p_branch_sequence in number, p_branch_condition_type in varchar2 default null,
    p_branch_condition in varchar2 default null
    -- also: p_flow_id, p_flow_step_id, p_save_state_before_branch_yn, p_security_scheme
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
    p_display_when_type         in varchar2 default null,
    p_display_when_cond         in varchar2 default null
    -- also: p_flow_id, p_page_id, p_security_scheme
    );
```

### create_page_da_action
```sql
procedure create_page_da_action (
    p_id                     in number   default null,
    p_event_id               in number,                      -- must match parent DA event
    p_event_result           in varchar2,                    -- TRUE | FALSE
    p_action_sequence        in number,
    p_execute_on_page_init   in varchar2,                    -- Y | N
    p_action                 in varchar2,                    -- NATIVE_REFRESH | NATIVE_SET_VALUE | ...
    p_affected_elements_type in varchar2 default null,       -- ITEM | REGION | BUTTON | JQUERY_SELECTOR
    p_affected_region_id     in number   default null,
    p_affected_elements      in varchar2 default null,
    p_attribute_01 .. p_attribute_15 in varchar2 default null
    -- also: p_flow_id, p_page_id, p_wait_for_result,
    -- p_client_condition_type, p_server_condition_type
    );
```

## Interactive Report

### create_worksheet
```sql
procedure create_worksheet (
    p_id in number, p_region_id in number default current_region_id,
    p_name in varchar2 default null, p_max_row_count in varchar2 default null,
    p_no_data_found_message in varchar2 default null,
    p_show_search_bar in varchar2 default 'Y', p_show_detail_link in varchar2 default 'Y',
    p_show_download in varchar2 default 'Y', p_lazy_loading in boolean default false
    -- also: p_flow_id, p_page_id, p_show_actions_menu, p_download_formats, p_internal_uid
    );
```
Sets `current_worksheet_id`.

### create_worksheet_column
```sql
procedure create_worksheet_column (
    p_id in number, p_worksheet_id in number default current_worksheet_id,
    p_db_column_name in varchar2, p_display_order in number,
    p_column_identifier in varchar2,  -- A, B, C...
    p_column_label in varchar2, p_column_type in varchar2,  -- STRING | NUMBER | DATE
    p_display_as in varchar2 default 'TEXT'
    -- also: p_heading_alignment, p_column_alignment, p_allow_sorting, p_allow_filtering, p_format_mask
    );
```

### create_worksheet_rpt
```sql
procedure create_worksheet_rpt (
    p_id in number, p_worksheet_id in number default current_worksheet_id,
    p_name in varchar2 default null, p_is_default in varchar2 default 'N',
    p_display_rows in number default 50,
    p_report_columns in varchar2 default null,  -- colon-separated: EMPNO:ENAME:SAL
    p_sort_column_1 in varchar2 default null, p_sort_direction_1 in varchar2 default null);
```

## Interactive Grid

### create_interactive_grid
```sql
procedure create_interactive_grid (
    p_id in number, p_region_id in number default current_region_id,
    p_is_editable in boolean default false, p_edit_operations in varchar2 default null,  -- i:u:d
    p_lost_update_check_type in varchar2 default null,
    p_add_row_if_empty in boolean default null,
    p_lazy_loading in boolean default false,
    p_pagination_type in varchar2 default 'SCROLL',
    p_show_toolbar in boolean default true,
    p_toolbar_buttons in varchar2 default 'SEARCH_COLUMN:SEARCH_FIELD:ACTIONS_MENU:RESET:SAVE',
    p_enable_download in boolean default true,
    p_download_formats in varchar2 default 'CSV:HTML:PDF:XLSX'
    -- also: p_flow_id, p_page_id, p_show_total_row_count, p_enable_save_public_report, p_internal_uid
    );
```

### create_ig_report / create_ig_report_view / create_ig_report_column
```sql
procedure create_ig_report (
    p_id in number, p_interactive_grid_id in number,
    p_name in varchar2, p_type in varchar2, p_default_view in varchar2,
    p_rows_per_page in number default null);

procedure create_ig_report_view (
    p_id in number, p_report_id in number, p_view_type in varchar2,
    p_stretch_columns in boolean default null);

procedure create_ig_report_column (
    p_id in number, p_view_id in number, p_display_seq in number,
    p_column_id in number default null, p_is_visible in boolean default true,
    p_is_frozen in boolean default false, p_width in number default null,
    p_sort_order in number default null, p_sort_direction in varchar2 default null);
```

## Charts

```sql
procedure create_jet_chart (
    p_id in number, p_region_id in number default current_region_id,
    p_chart_type in varchar2 default 'area',  -- area|bar|bubble|combo|dial|donut|funnel|gantt|line|pie|polar|pyramid|radar|range|scatter|stock|waterfall
    p_title in varchar2 default null, p_height in varchar2 default null,
    p_orientation in varchar2 default null, p_stack in varchar2 default 'off',
    p_legend_rendered in varchar2 default 'on');

procedure create_jet_chart_axis (
    p_id in number, p_chart_id in number, p_axis in varchar2, p_title in varchar2 default null);

procedure create_jet_chart_series (
    p_id in number, p_chart_id in number, p_seq in number, p_name in varchar2,
    p_data_source_type in varchar2, p_data_source in varchar2,
    p_items_value_column_name in varchar2, p_items_label_column_name in varchar2);
```

## Map / Cards / Tree / Search

```sql
procedure create_map_region (
    p_id in number, p_region_id in number default current_region_id,
    p_height in number, p_navigation_bar_type in varchar2,
    p_init_position_zoom_type in varchar2);

procedure create_map_region_layer (
    p_id in number, p_map_region_id in number, p_name in varchar2,
    p_layer_type in varchar2, p_display_sequence in number,
    p_geometry_column_data_type in varchar2);

procedure create_card (
    p_id in number, p_region_id in number default current_region_id,
    p_layout_type in varchar2 default 'GRID',
    p_title_column_name in varchar2, p_body_column_name in varchar2 default null,
    p_badge_column_name in varchar2 default null);

procedure create_card_action (
    p_id in number, p_card_id in number, p_action_type in varchar2 default 'BUTTON',
    p_position in varchar2, p_display_sequence in number,
    p_label in varchar2, p_link_target in varchar2 default null);
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
