---
name: apex-component-modifier
description: Export/patch/import Oracle APEX components via SQLcl MCP. Covers pages, regions, items, buttons, processes, DAs, validations, LOVs, auth schemes, templates, IR, IG, charts, maps, cards, and all shared components.
argument-hint: "[conn|env] [app-id] [component] -- <change request>"
disable-model-invocation: false
---

# Oracle APEX Component Modifier (SQLcl MCP)

Export -> patch -> import APEX components via SQLcl MCP. Real side effects (DB + APEX).

## Settings

Env vars in `.claude/settings.json` (override in `.claude/settings.local.json`):
`SQLCL_CONNECTION`, `APEX_APP_ID`, `APEX_WORKSPACE` -- see CLAUDE.md.

## Inputs

- `$0`: connection alias (fallback: `$SQLCL_CONNECTION`)
- `$1`: app-id (fallback: `$APEX_APP_ID`)
- `$2`: component selector -- `PAGE:10`, `LOV:<id>`, `REGION:<id>`, or free-form
- Remaining args: change request

If inputs incomplete after defaults, resolve via `apex list` or APEX views.

## Preconditions

- SQLcl MCP server available (apex commands + SQL/PLSQL)
- `references/apex_imp/` docs present
- Filesystem write access

## Workflow

### 0) MCP tool discovery
Confirm SQLcl MCP tools available for: apex commands, ad-hoc SQL, script execution.

### 1) Create safe working area
Timestamped working folder. If git repo: branch + baseline commit.

### 2) Identify target component
Normalize selector (e.g., "page 10" -> `PAGE:10`). For named shared components, use `apex list` to resolve IDs. Build `-expComponents` string if multiple.

### 3) Export (`-split` + `-expComponents`)
```
apex export -applicationid <APP_ID> -split -dir <workdir>/f<APP_ID> -expComponents "<...>"
```
Confirm `install_component.sql` (partial) or `install.sql` (full) exists.

### 4) Load documentation and app patterns
1. `references/apex_imp/README.md` + `apex_imp.md` (always)
2. `imp_page.md` (page components) or `imp_shared.md` (shared) -- as needed
3. `tools/patching_guidelines.md` + `valid_values.md` (always)
4. `app_install.md` (if importing to different environment)
5. `app-patterns/catalog.md` -- if present, load relevant component pattern files to match app conventions

### 5) Plan the change set
Split into DB changes (DDL/DML/PLSQL) and APEX patches. Use `templates/patch_plan.md`. Order: DB first -> patch export -> import.

### 6) Apply DB changes
Generate idempotent scripts. Execute via SQLcl MCP. Validate compilation.

### 7) Patch exported file(s)
**Principle:** minimal changes, stable anchors, preserve `begin...end;`/`/` structure.
1. Resolve file paths via `tools/normalize_export_paths.md`
2. Apply patches per `tools/patching_guidelines.md`
3. Follow `apex_imp` ID generation rules -- never use random IDs
4. Run `templates/validation_checklist.md` + `bash tools/validate_export.sh <file>`

### 8) Import via SQLcl MCP
- Same environment: `@<workdir>/f<APP_ID>/install_component.sql`
- Different environment: prepend `apex_application_install` context block first
- Capture install log

### 9) Verify and deliver
Re-export + diff. Deliver: change summary, modified files, patch diff, import log.

## Error Handling

**Before changes:** git baseline commit + export snapshot.

| Failure | Recovery |
|---------|----------|
| Export missing files | Verify `-dir`, permissions, APP_ID, connection |
| DB script fails | Fix + re-run; reverse with DROP/ALTER |
| Invalid patched file | `git checkout -- <file>`, re-patch |
| Import ID collision | Revisit ID/offset guidance; regenerate |
| Import compilation error | `show errors`; fix DB objects; re-import |
| Component broken | Re-import baseline export |
| Unknown state | Re-export from APEX; diff against patched file |

**Rollback:** git baseline -> `git checkout` + re-import. No git -> re-export from APEX. DB reversal -> idempotent DROP/ALTER scripts.

## Examples

- `/apex-component-modifier PAGE:10 -- Add item P10_STATUS (select list) based on LOV STATUS_LOV, create table APP_STATUS if missing.`
- `/apex-component-modifier DEV 113 PAGE:10 -- Add item P10_STATUS (select list) based on LOV STATUS_LOV.`
- `/apex-component-modifier STG 113 LOV:23618973754424510000 -- Rename LOV display column and update dependent items on Page 3.`
