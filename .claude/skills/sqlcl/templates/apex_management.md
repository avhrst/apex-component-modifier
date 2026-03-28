# APEX Management Template

Common APEX operations via SQLcl MCP.

## Check APEX Environment

```
-- run-sqlcl
apex version
```

```sql
-- run-sql
-- Note: APEX_WORKSPACES uses column WORKSPACE (not WORKSPACE_NAME).
-- The SCHEMAS column returns the count of schemas, not schema names.
-- For schema names, query APEX_WORKSPACE_SCHEMAS instead.
SELECT workspace_id, workspace, schemas
FROM apex_workspaces ORDER BY workspace;
```

## List Workspace Schemas

```sql
-- run-sql
SELECT workspace_name, schema
FROM apex_workspace_schemas
ORDER BY workspace_name, schema;
```

## List Applications

```sql
-- run-sql
-- Note: column names may vary by APEX version (e.g., pages vs page_count, owner vs application_owner).
-- Run DESC apex_applications to verify available columns in your APEX version.
SELECT application_id, application_name, pages, owner, last_updated_on
FROM apex_applications
ORDER BY application_id;
```

## List Components in App

```
-- run-sqlcl
apex list -applicationid <APP_ID>
```

## Export Full Application

```
-- run-sqlcl
apex export -applicationid <APP_ID> -split -skipExportDate
```

## Export Specific Pages

```
-- run-sqlcl
apex export -applicationid <APP_ID> -split -expComponents "PAGE:<N>"
```

## Export Multiple Components

```
-- run-sqlcl
apex export -applicationid <APP_ID> -split -expComponents "PAGE:1 PAGE:2 LOV:<ID>"
```

## Page Summary

```sql
-- run-sql
SELECT page_id, page_name, page_mode, page_group,
       (SELECT COUNT(*) FROM apex_application_page_regions r WHERE r.application_id = p.application_id AND r.page_id = p.page_id) regions,
       (SELECT COUNT(*) FROM apex_application_page_items i WHERE i.application_id = p.application_id AND i.page_id = p.page_id) items,
       (SELECT COUNT(*) FROM apex_application_page_buttons b WHERE b.application_id = p.application_id AND b.page_id = p.page_id) buttons
FROM apex_application_pages p
WHERE application_id = <APP_ID>
ORDER BY page_id;
```

## Check APEX Session Activity

```sql
-- run-sql
-- Note: timestamp column name may vary by APEX version (timestamp_tz, view_date, or time_stamp)
SELECT * FROM apex_workspace_activity_log
WHERE application_id = <APP_ID>
ORDER BY timestamp_tz DESC
FETCH FIRST 20 ROWS ONLY;
```

## APEX Application Static Files

```sql
-- run-sql
SELECT file_name, mime_type, file_size, last_updated_on
FROM apex_application_static_files
WHERE application_id = <APP_ID>
ORDER BY file_name;
```

## APEX Workspace Static Files

```sql
-- run-sql
SELECT file_name, mime_type, file_size
FROM apex_workspace_static_files
ORDER BY file_name;
```

## Supporting Objects / Build Options

```sql
-- run-sql
SELECT build_option_name, build_option_status, build_option_comment
FROM apex_application_build_options
WHERE application_id = <APP_ID>;
```

## Import (Same Environment)

At restriction level <= 1:
```
-- run-sqlcl
@f<APP_ID>/install.sql
@f<APP_ID>/install_component.sql
```

> **Note:** At restriction level 4 (default MCP), `@` script execution is blocked. Use restriction level <= 1 for imports, or run install script content directly via `run-sql`.

## Import (Different Environment)

```sql
-- run-sql: set install context first
BEGIN
  apex_application_install.set_workspace_id(<WORKSPACE_ID>);
  apex_application_install.set_application_id(<NEW_APP_ID>);
  apex_application_install.set_schema('<SCHEMA>');
  apex_application_install.generate_offset;
END;
```

Then run install script.
