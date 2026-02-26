# WWV_FLOW_IMP_SHARED -- Shared Component Procedures

Source: APEX 24.2 (`APEX_240200`).

Note: Some shared components (LOVs, lists, shortcuts, app processes) still use frozen `wwv_flow_imp`. Newer ones (build options, auth, UI, static files) use `wwv_flow_imp_shared`. All IDs wrapped in `wwv_flow_imp.id()`.

## State Functions
```sql
function current_lov_id return number;
function current_menu_id return number;
function current_list_id return number;
function current_component_group_id return number;
function current_ai_config_id return number;
```

## Build Options
```sql
procedure create_build_option (
    p_id in number, p_build_option_name in varchar2,
    p_build_option_status in varchar2,     -- INCLUDE | EXCLUDE
    p_build_option_comment in varchar2 default null,
    p_default_on_export in varchar2 default null,
    p_on_upgrade_keep_status in boolean default false,
    p_feature_identifier in varchar2 default null);

procedure set_build_option(p_id in number, p_build_option_status in varchar2);
function get_build_option_status(p_application_id in number, p_id in number) return varchar2;
```

## User Interface
```sql
procedure create_user_interface (
    p_id in number, p_theme_id in number,
    p_home_url in varchar2 default null, p_login_url in varchar2 default null,
    p_global_page_id in number default null,
    p_navigation_list_id in number default null,
    p_navigation_list_position in varchar2 default null,
    p_navigation_list_template_id in number default null,
    p_nav_bar_type in varchar2 default 'NAVBAR',
    p_nav_bar_list_id in number default null);
```

## Lists of Values (LOVs)

SQL-based (via `wwv_flow_imp`, frozen):
```sql
wwv_flow_imp.create_list_of_values(
    p_id=>wwv_flow_imp.id(<id>), p_flow_id=>wwv_flow.g_flow_id,
    p_lov_name=>'DEPARTMENTS',
    p_lov_query=>'select dname d, deptno r from dept order by 1');
```

Static (via `wwv_flow_imp_shared`):
```sql
wwv_flow_imp_shared.create_list_of_values(
    p_id=>wwv_flow_imp.id(<id>), p_lov_name=>'YES_NO',
    p_lov_query=>'.', p_source_type=>'STATIC', p_location=>'LOCAL');
wwv_flow_imp_shared.create_static_lov_data(
    p_id=>wwv_flow_imp.id(<id>), p_lov_id=>wwv_flow_imp.id(<lov_id>),
    p_lov_disp_sequence=>1, p_lov_disp_value=>'Yes', p_lov_return_value=>'Y');
```

## Navigation Lists
```sql
wwv_flow_imp.create_list(
    p_id=>wwv_flow_imp.id(<id>), p_name=>'Desktop Navigation Menu', p_list_type=>'STATIC');
wwv_flow_imp.create_list_item(
    p_list_id=><list_id>, p_list_item_type=>'LINK',
    p_list_item_name=>'Home', p_list_item_link_text=>'Home',
    p_list_item_link_target=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::',
    p_list_item_icon=>'fa-home', p_list_item_sequence=>10);
```

## Security

### Authorization
```sql
wwv_flow_imp_shared.create_security_scheme(
    p_id=>wwv_flow_imp.id(<id>), p_name=>'Administration Rights',
    p_scheme_type=>'NATIVE_IS_IN_GROUP', p_attribute_01=>'ADMIN',
    p_error_message=>'Insufficient privileges', p_caching=>'BY_USER_BY_PAGE_VIEW');
```

### Authentication
```sql
wwv_flow_imp_shared.create_authentication(
    p_id=>wwv_flow_imp.id(<id>), p_name=>'APEX Accounts',
    p_scheme_type=>'NATIVE_APEX_ACCOUNTS', p_invalid_session_type=>'LOGIN',
    p_cookie_name=>'ORA_WWV_APP_&APP_ID.', p_use_secure_cookie_yn=>'N');
```

## Static Files
```sql
function create_static_file (
    p_scope in wwv_flow_file_api.t_file_scope, p_file_name in varchar2,
    p_mime_type in varchar2, p_file_content in blob) return number;
```

## Application Processes (via wwv_flow_imp)
```sql
wwv_flow_imp.create_flow_process(
    p_id=>wwv_flow_id.next_val, p_flow_id=>wwv_flow.g_flow_id,
    p_process_name=>'Set Global Variables', p_process_sequence=>10,
    p_process_point=>'BEFORE_HEADER', p_process=>'begin null; end;');
```

## Utility
```sql
procedure set_calling_version(p_version in number);
procedure load_build_options(p_application_id in number);
procedure clear_build_options;
procedure load_app_settings(p_application_id in number);
```
