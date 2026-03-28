# Migration & Schema Comparison Template

Workflows for comparing and migrating schemas using Liquibase and Data Pump.

## Schema Comparison (Liquibase Diff)

### Step 1: Connect to target (what you want to update)
```
-- Use the MCP "connect" tool (not run-sql or run-sqlcl)
connect <TARGET_CONNECTION>
```

### Step 2: Run diff against reference (source of truth)
```
-- run-sqlcl
liquibase diff -referenceUrl jdbc:oracle:thin:@<host>:<port>/<service> -referenceUsername <user> -referencePassword <pass>
```

### Step 3: Generate diff changelog (optional)
```
-- run-sqlcl
liquibase diff-changelog -changelog diff_changes.xml -referenceUrl jdbc:oracle:thin:@<host>:<port>/<service> -referenceUsername <user> -referencePassword <pass>
```

## Initial Schema Baseline

### Step 1: Capture current schema
```
-- run-sqlcl
liquibase generate-schema -split -grants -synonyms
```

### Step 2: Generate control file
```
-- run-sqlcl
liquibase generate-controlfile
```

### Step 3: Tag baseline
```
-- run-sqlcl
liquibase tag -tag baseline
```

### Step 4: Verify
```
-- run-sqlcl
liquibase status -changelog controller.xml
```

## Deploy Changes to Target

### Step 1: Check pending changes
```
-- run-sqlcl
liquibase status -changelog controller.xml
```

### Step 2: Preview SQL
```
-- run-sqlcl
liquibase updatesql -changelog controller.xml
```

### Step 3: Apply
```
-- run-sqlcl
liquibase update -changelog controller.xml
```

### Step 4: Tag release
```
-- run-sqlcl
liquibase tag -tag <release_version>
```

## Rollback

### Preview rollback
```
-- run-sqlcl
liquibase rollback-sql -changelog controller.xml -count 1
```

### Execute rollback
```
-- run-sqlcl
liquibase rollback -changelog controller.xml -count 1
```

## Schema Clone via Data Pump

### Step 1: Export source
```
-- run-sqlcl (connected to source)
DATAPUMP EXPORT -schemas <SCHEMA> -directory DATA_PUMP_DIR -dumpfile schema_clone.dmp -content METADATA_ONLY
```

### Step 2: Import to target (with remap)
```
-- run-sqlcl (connected to target)
DATAPUMP IMPORT -schemas <SOURCE_SCHEMA> -remap_schema <SOURCE_SCHEMA>:<TARGET_SCHEMA> -directory DATA_PUMP_DIR -dumpfile schema_clone.dmp
```

### Step 3: Verify imported objects
```sql
-- run-sql (connected to target)
SELECT object_type, COUNT(*) cnt, SUM(CASE WHEN status = 'INVALID' THEN 1 ELSE 0 END) invalid
FROM user_objects
GROUP BY object_type
ORDER BY cnt DESC;
```

## Full Project CI/CD Workflow

### Setup
```
-- run-sqlcl
project init -name <project> -schemas <schemas> -apex-ids <app_ids>
project export
```

### Development Cycle
```
-- After making changes in DB/APEX Builder:
project export
-- Review diffs in git
project stage
project release -version <version>
project gen-artifact
```

### Deployment
```
-- run-sqlcl
project deploy -connection <TARGET> -dry-run    -- preview
project deploy -connection <TARGET>             -- execute
```

## Troubleshooting

### Liquibase lock stuck
```
-- run-sqlcl
liquibase list-locks
liquibase release-locks
```

### Checksum mismatch
```
-- run-sqlcl
liquibase clear-checksums
```

### Validate changelog
```
-- run-sqlcl
liquibase validate -changelog controller.xml
```
