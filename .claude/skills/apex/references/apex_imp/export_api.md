# APEX_EXPORT -- Export API

Source: APEX 24.2. Invoker's rights.

## Export Type Constants

| Constant | Value |
|----------|-------|
| `c_type_application_source` | `'APPLICATION_SOURCE'` (standard) |
| `c_type_embedded_code` | `'EMBEDDED_CODE'` (SQL/PL/SQL/JS only) |
| `c_type_readable_yaml` | `'READABLE_YAML'` |

## get_application
```sql
function get_application (
    p_application_id          in number,
    p_split                   in boolean             default false,
    p_components              in wwv_flow_t_varchar2  default null,
    p_with_supporting_objects in varchar2             default null,  -- Y|I|N|null
    p_with_original_ids       in boolean             default false,
    p_with_audit_info         in t_audit_type         default null
    -- also: p_type, p_with_date, p_with_ir_public_reports, p_with_ir_private_reports,
    -- p_with_ir_notifications, p_with_translations, p_with_no_subscriptions,
    -- p_with_comments, p_with_acl_assignments, p_with_runtime_instances
    ) return wwv_flow_t_export_files;
```

Component selector format: `<type>:<name>` -- e.g., `PAGE:42`, `LOV:%` (wildcard), `LOV:DEPARTMENTS`. See `APEX_APPL_EXPORT_COMPS` view for all types.

## Examples
```sql
-- Split export
l_files := apex_export.get_application(p_application_id => 100, p_split => true);

-- Component-only
l_files := apex_export.get_application(
    p_application_id => 100, p_components => apex_t_varchar2('PAGE:1', 'PAGE:10'));

-- All LOVs
l_files := apex_export.get_application(
    p_application_id => 100, p_components => apex_t_varchar2('LOV:%'));
```

## SQLcl Equivalents

| PL/SQL API | SQLcl command |
|------------|---------------|
| `get_application(100)` | `apex export -applicationid 100` |
| `get_application(100, p_split=>true)` | `apex export -applicationid 100 -split` |
| `get_application(100, p_components=>...)` | `apex export -applicationid 100 -expComponents "PAGE:10"` |
| -- | `apex list -applicationid 100` |

## Import Parser (`wwv_flow_imp_parser`)
```sql
function get_info(p_source in clob, p_full in boolean default false) return t_file_info;
procedure install(p_source in clob, p_overwrite_existing in boolean, p_need_parse in boolean);
function create_installable_sql(p_source in wwv_flow_t_export_files) return clob;
```
Supports single file, split, and ZIP formats. UTF-8. Handles schema/app ID remapping.
