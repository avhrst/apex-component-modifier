# Project Commands Reference (run-sqlcl)

All commands in this file use the `run-sqlcl` MCP tool.

SQLcl Projects (24.3+) provide Oracle's recommended CI/CD approach for database and APEX applications.

## Overview

Projects manage the full lifecycle: export DB objects + APEX apps → version in Git → stage changes → create releases → deploy to environments.

## Initialize Project

```
project init -name myapp -schemas HR,APEX_APP
```

Creates a project directory structure:

```
myapp/
├── project.json                   -- project configuration
├── src/                           -- source files (exported objects)
│   ├── database/
│   │   ├── HR/
│   │   │   ├── tables/
│   │   │   ├── views/
│   │   │   ├── packages/
│   │   │   └── ...
│   │   └── APEX_APP/
│   └── apex/
│       └── f113/
├── releases/                      -- versioned releases
├── artifacts/                     -- deployable ZIPs
└── .liquibase/                    -- Liquibase tracking
```

### Init Options

| Parameter | Description |
|-----------|-------------|
| `-name` | Project name |
| `-schemas` | Comma-separated schema list |
| `-apex-ids` | APEX application IDs to include |
| `-directory` | Base directory (default: current) |

## Export Project

Export all database objects, PL/SQL, REST APIs, and APEX apps to `src/`:

```
project export
```

This captures the current state of all schemas and APEX apps defined in `project.json`.

### Export Options

```
project export -schemas HR           -- export only specific schema
project export -apex-ids 113         -- export only specific APEX app
```

## Stage Changes

Generate Liquibase changelogs by comparing the current branch state to the base branch:

```
project stage
```

This:
1. Compares `src/` to the previous committed state
2. Generates changelogs for all detected changes
3. Places them in the staging area

### Add Custom Changesets

For changes that can't be auto-detected (DML scripts, data fixes, grants):

```
project stage add-custom -file /path/to/custom_script.sql -description "Load seed data"
```

## Create Release

Finalize staged changes into a versioned release:

```
project release
```

Creates a release directory under `releases/` with version number, changelogs, and metadata.

### Release Options

```
project release -version 1.2.0      -- specify version
project release -description "Sprint 5 features"
```

## Generate Artifact

Create a deployable artifact (ZIP file):

```
project gen-artifact
```

Produces a self-contained ZIP in `artifacts/` that can be deployed to any target environment.

### Artifact Options

```
project gen-artifact -version 1.2.0
project gen-artifact -output /path/to/artifacts
```

## Deploy

Deploy an artifact to a target environment:

```
project deploy -connection PROD
project deploy -connection STG -version 1.2.0
```

### Deploy Options

| Parameter | Description |
|-----------|-------------|
| `-connection` | Target connection alias |
| `-version` | Specific version to deploy |
| `-dry-run` | Preview without executing |

## Project Configuration (project.json)

```json
{
  "name": "myapp",
  "schemas": ["HR", "APEX_APP"],
  "apex": {
    "applications": [113],
    "workspace": "DEV_WORKSPACE"
  },
  "options": {
    "split-apex": true,
    "skip-export-date": true
  }
}
```

## Common Project Workflows

### Initial Setup
```
1. project init -name myapp -schemas HR -apex-ids 113
2. project export
3. git add . && git commit -m "Initial project baseline"
4. project release -version 1.0.0
```

### Development Cycle
```
1. Make changes in DEV database / APEX Builder
2. project export                    -- capture changes to src/
3. git diff                          -- review what changed
4. git add . && git commit
5. project stage                     -- generate changelogs
6. project stage add-custom -file seed_data.sql  -- if needed
7. project release -version 1.1.0
8. project gen-artifact
```

### Deployment
```
1. project deploy -connection STG -dry-run    -- preview
2. project deploy -connection STG             -- deploy to staging
3. (test and validate)
4. project deploy -connection PROD            -- deploy to production
```

### Version Upgrades

Projects support upgrading from any version to any later version. If production is at v1.0 and development is at v1.3, deploying v1.3 to production will apply all changes from v1.0 → v1.1 → v1.2 → v1.3 in order.

## Integration with Git

Projects are designed to be Git-friendly:
- `src/` contains split exports (one file per object)
- `-skip-export-date` eliminates noisy timestamp diffs
- `project stage` uses Git diff to detect changes
- Releases are immutable snapshots
- Artifacts are portable and self-contained
