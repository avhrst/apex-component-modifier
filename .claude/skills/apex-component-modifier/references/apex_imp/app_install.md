# APEX_APPLICATION_INSTALL — Pre-Import Configuration

Source: APEX 24.2. Since APEX 4.0. Override application attributes during command-line imports.

---

## Constants

| Constant | Value | Description |
|----------|-------|-------------|
| `c_file_type_app` | `2` | Application export |
| `c_file_type_workspace` | `1` | Workspace export |
| `c_file_type_plugin` | `4` | Plugin export |

App IDs 3000–8999 are reserved for internal APEX use.

---

## Setter Procedures

```sql
procedure set_workspace_id(p_workspace_id in number);
procedure set_workspace(p_workspace in varchar2);
procedure set_application_id(p_application_id in number);
procedure generate_application_id;
procedure set_offset(p_offset in number);
procedure generate_offset;                                    -- always generate/set offset for new installs
procedure set_schema(p_schema in varchar2);                   -- must exist and be mapped to workspace
procedure set_application_name(p_application_name in varchar2);
procedure set_application_alias(p_application_alias in varchar2);
procedure set_image_prefix(p_image_prefix in varchar2);
procedure set_proxy(p_proxy in varchar2, p_no_proxy_domains in varchar2 default null);
procedure set_auto_install_sup_obj(p_auto_install_sup_obj in boolean);
procedure set_keep_sessions(p_keep_sessions in boolean);
procedure set_authentication_scheme(p_name in varchar2);
procedure set_build_status(p_build_status in wwv_flow_application_admin_api.t_build_status);
procedure set_remote_server(p_static_id in varchar2, p_base_url in varchar2,
    p_https_host in varchar2 default null, p_default_database in varchar2 default null);
```

## Getter Functions

```sql
function get_workspace_id return number;
function get_application_id return number;
function get_offset return number;
function get_schema return varchar2;
function get_info(p_source in wwv_flow_t_export_files) return t_file_info;
```

## Install / Remove

```sql
procedure install(p_source in wwv_flow_t_export_files default null, p_overwrite_existing in boolean default false);
procedure remove_application(p_application_id in number);
procedure clear_all;
```

---

## Usage Examples

### Import with different app ID

```sql
begin
    apex_application_install.set_application_id(702);
    apex_application_install.generate_offset;
    apex_application_install.set_application_alias('F' || apex_application_install.get_application_id);
end;
/
@f645.sql
```

### Import to different workspace

```sql
begin
    apex_application_install.set_workspace('PROD_WS');
    apex_application_install.generate_offset;
    apex_application_install.set_schema('PROD_SCHEMA');
    apex_application_install.set_application_alias('PROD_APP');
end;
/
@f100/install.sql
```
