# APEX_EXPORT — Export API

Source: APEX 24.2. Public synonym: `APEX_EXPORT`. Invoker's rights.

---

## Export Type Constants

| Constant | Value | Description |
|----------|-------|-------------|
| `c_type_application_source` | `'APPLICATION_SOURCE'` | Standard application export |
| `c_type_embedded_code` | `'EMBEDDED_CODE'` | SQL/PL/SQL/JS code only |
| `c_type_checksum_sh256` | `'CHECKSUM-SH256'` | SHA-256 checksum (ID-independent) |
| `c_type_readable_yaml` | `'READABLE_YAML'` | Readable YAML format |

## Audit Type Constants

| Constant | Value |
|----------|-------|
| `c_audit_dates_only` | `'DATES_ONLY'` |
| `c_audit_names_dates` | `'NAMES_AND_DATES'` |

---

## get_application

```sql
function get_application (
    p_application_id          in number,
    p_type                    in t_export_type       default c_type_application_source,
    p_split                   in boolean             default false,
    p_with_date               in boolean             default false,
    p_with_ir_public_reports  in boolean             default false,
    p_with_ir_private_reports in boolean             default false,
    p_with_ir_notifications   in boolean             default false,
    p_with_translations       in boolean             default false,
    p_with_original_ids       in boolean             default false,
    p_with_no_subscriptions   in boolean             default false,
    p_with_comments           in boolean             default false,
    p_with_supporting_objects in varchar2             default null,
    p_with_acl_assignments    in boolean             default false,
    p_components              in wwv_flow_t_varchar2  default null,
    p_with_audit_info         in t_audit_type         default null,
    p_with_runtime_instances  in wwv_flow_t_varchar2  default null)
    return wwv_flow_t_export_files;
```

### Key parameters

| Parameter | Description |
|-----------|-------------|
| `p_split` | If `true`, splits into multiple files (directory structure) |
| `p_components` | Export only specific components: `apex_t_varchar2('PAGE:1', 'PAGE:10', 'LOV:%')` |
| `p_with_supporting_objects` | `'Y'`=export, `'I'`=auto-install, `'N'`=skip, `null`=use app default |
| `p_with_original_ids` | Export with IDs as they were at import time |
| `p_with_audit_info` | Include created/updated timestamps and/or user names |

### Component selector format

`<type>:<name>` — e.g., `PAGE:42`, `LOV:%` (wildcard), `LOV:DEPARTMENTS`

See view `APEX_APPL_EXPORT_COMPS` for all exportable component types.

---

## Examples

### Split export

```sql
declare
    l_files apex_t_export_files;
begin
    l_files := apex_export.get_application(
        p_application_id => 100,
        p_split          => true);
end;
```

### Component-only export

```sql
declare
    l_files apex_t_export_files;
begin
    l_files := apex_export.get_application(
        p_application_id => 100,
        p_components     => apex_t_varchar2('PAGE:1', 'PAGE:10'));
end;
```

### All LOVs

```sql
l_files := apex_export.get_application(
    p_application_id => 100,
    p_components     => apex_t_varchar2('LOV:%'));
```

---

## zip / unzip

```sql
function zip(
    p_source_files wwv_flow_t_export_files,
    p_extra_files  wwv_flow_t_export_files default wwv_flow_t_export_files())
    return blob;

function unzip(p_source_zip in blob)
    return wwv_flow_t_export_files;
```

---

## SQLcl `apex` commands (equivalent)

| PL/SQL API | SQLcl command |
|------------|---------------|
| `get_application(p_application_id => 100)` | `apex export -applicationid 100` |
| `get_application(..., p_split => true)` | `apex export -applicationid 100 -split` |
| `get_application(..., p_components => ...)` | `apex export -applicationid 100 -expComponents "PAGE:10 LOV:123"` |
| `apex list -applicationid 100` | Lists exportable components |

---

## Import Parser (`wwv_flow_imp_parser`)

Used internally to parse and install export files.

```sql
-- Get file info
function get_info(p_source in clob, p_full in boolean default false)
    return wwv_flow_application_install.t_file_info;

-- Install from source
procedure install(p_source in clob, p_overwrite_existing in boolean, p_need_parse in boolean);

-- Convert split files to single installable CLOB
function create_installable_sql(p_source in wwv_flow_t_export_files) return clob;
```

Key facts:
- Supports single file, split export, and ZIP formats
- UTF-8 encoding
- Handles schema remapping, app ID remapping, offset adjustment
