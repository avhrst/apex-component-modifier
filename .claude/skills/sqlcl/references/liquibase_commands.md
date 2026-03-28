# Liquibase Commands Reference (run-sqlcl)

All commands in this file use the `run-sqlcl` MCP tool.

SQLcl integrates Oracle's enhanced Liquibase for schema versioning, comparison, and migration.

## Generate Schema Changelog

Capture the entire current schema to changelog files:

```
liquibase generate-schema
```

### Split by Object Type

```
liquibase generate-schema -split
```

Creates subdirectories per object type (tables, views, packages, etc.).

### Include Grants & Synonyms

```
liquibase generate-schema -split -grants -synonyms
```

### Output to Specific Directory

```
liquibase generate-schema -split -output-directory /path/to/changelogs
```

## Generate Single Object

Capture a specific database object:

```
liquibase generate-db-object -object-type TABLE -object-name EMPLOYEES
liquibase generate-db-object -object-type PACKAGE -object-name PKG_EMPLOYEES
liquibase generate-db-object -object-type VIEW -object-name V_ACTIVE_EMPLOYEES
```

### Object Types

`TABLE`, `VIEW`, `MATERIALIZED_VIEW`, `INDEX`, `SEQUENCE`, `TRIGGER`, `PACKAGE`, `PACKAGE_BODY`, `PROCEDURE`, `FUNCTION`, `TYPE`, `TYPE_BODY`, `SYNONYM`, `GRANT`

## Generate Control File

Create the master controller changelog:

```
liquibase generate-controlfile
```

## Schema Diff

Compare two schemas and generate a diff report or changelog.

### Diff Report

Connect to the **target** schema first, then specify the **reference** (source) in the command:

```
liquibase diff -referenceUrl jdbc:oracle:thin:@host:1521/service -referenceUsername HR_DEV -referencePassword pass
```

### Diff to Changelog

Generate a changelog of changes needed to make target match reference:

```
liquibase diff-changelog -changelog diff_changes.xml -referenceUrl jdbc:oracle:thin:@host:1521/service -referenceUsername HR_DEV -referencePassword pass
```

### Diff Using Saved Connections

```
liquibase diff -referenceUrl <connection_url_of_reference_schema>
```

## Apply Changes (Update)

Apply a changelog to the current database:

```
liquibase update -changelog controller.xml
```

### Dry Run (Preview SQL)

See what SQL would be executed without running it:

```
liquibase updatesql -changelog controller.xml
```

### Update to Specific Tag

```
liquibase update -changelog controller.xml -to-tag release_1.2
```

### Update Count

Apply only N changesets:

```
liquibase update-count -changelog controller.xml -count 5
```

## Check Status

List changesets that haven't been deployed:

```
liquibase status -changelog controller.xml
```

## Rollback

### Rollback by Count

```
liquibase rollback -changelog controller.xml -count 1
```

### Rollback to Tag

```
liquibase rollback -changelog controller.xml -tag release_1.1
```

### Rollback to Date

```
liquibase rollback -changelog controller.xml -date 2026-03-01
```

### Rollback SQL (Preview)

```
liquibase rollback-sql -changelog controller.xml -count 1
```

## Tags

Mark the current database state for rollback targets:

```
liquibase tag -tag release_1.2
```

## Validate

Validate a changelog for syntax errors:

```
liquibase validate -changelog controller.xml
```

## Lock Management

```
liquibase list-locks                -- show active locks
liquibase release-locks             -- force release all locks
```

## Checksums

```
liquibase clear-checksums           -- clear stored checksums (use after manual edits to changelogs)
```

## Sync (Mark as Deployed)

Mark all changesets as deployed without executing them (useful for baselining):

```
liquibase changelog-sync -changelog controller.xml
```

## Database Documentation

Generate HTML documentation:

```
liquibase db-doc -output-directory /path/to/docs
```

## Changelog Formats

SQLcl Liquibase supports:
- **XML** (default): `controller.xml`
- **YAML**: `controller.yaml`
- **JSON**: `controller.json`
- **SQL**: `controller.sql`

## Common Liquibase Workflows

### Initial Schema Capture
```
1. liquibase generate-schema -split
2. liquibase generate-controlfile
3. liquibase tag -tag baseline
```

### Compare DEV to STG
```
1. Connect to STG (target)
2. liquibase diff -referenceUrl <DEV_URL> -referenceUsername <DEV_USER> -referencePassword <DEV_PASS>
```

### Deploy Changes to Target
```
1. liquibase status -changelog controller.xml          -- check pending
2. liquibase updatesql -changelog controller.xml        -- preview
3. liquibase update -changelog controller.xml           -- apply
4. liquibase tag -tag release_1.2                       -- tag state
```

### Rollback Last Change
```
1. liquibase rollback-sql -changelog controller.xml -count 1   -- preview
2. liquibase rollback -changelog controller.xml -count 1       -- execute
```

## Tracking Tables

Liquibase creates these tracking tables in the schema:
- `DATABASECHANGELOG` — records applied changesets
- `DATABASECHANGELOGLOCK` — prevents concurrent updates
