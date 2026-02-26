---
name: apex-component-modifier
description: Export/patch/import Oracle APEX components (pages/shared components) via SQLcl over MCP. Uses local apex_imp package docs to plan safe modifications, applies required DB changes, patches exported component files, then re-imports through SQLcl. Use whenever the user asks to add, modify, remove, inspect, or describe any Oracle APEX page component such as regions, items, buttons, processes, dynamic actions, validations, computations, branches, LOVs, or authorization schemes. Also use when the user mentions APEX pages, APEX components, APEX export/import, APEX patching, SQLcl APEX commands, or wants to change anything in an APEX application. Covers page items, interactive reports, interactive grids, charts, maps, cards, lists, templates, build options, authentication, and static files.
argument-hint: "[conn|env] [app-id] [component] -- <change request>"
disable-model-invocation: false
---

# Oracle APEX Component Modifier (SQLcl MCP)

## Purpose
Use this skill to **modify an Oracle APEX component** (most commonly a Page or Shared Component) using a controlled workflow driven by **SQLcl via MCP**:

1) Export the APEX component via SQLcl MCP
2) Read the **local** documentation of package `apex_imp` (files included in this skill directory)
3) Analyze the user request and derive a safe change plan
4) Apply **database changes** (DDL/DML/PLSQL) through SQLcl MCP
5) Patch the exported component file(s)
6) Import the modified component back into APEX via SQLcl MCP
7) Validate (optional but recommended): re-export and diff

> This workflow has real side effects (DB + APEX). The skill can be invoked by both the user and the model (`disable-model-invocation: false`).

## Settings (env vars)

These defaults are configured in `.claude/settings.json` and can be overridden per-user in `.claude/settings.local.json`:

| Env var | Purpose | Example |
|---------|---------|---------|
| `SQLCL_CONNECTION` | SQLcl saved connection alias (in `~/.dbtools`) | `DEV` |
| `APEX_APP_ID` | Default APEX application ID | `113` |
| `APEX_WORKSPACE` | APEX workspace name | `DEV_WORKSPACE` |

## Inputs

Recommended argument structure (free-form is fine, but this is preferred):
- `$0`: environment/connection alias (e.g., `DEV`, `STG`, `PRD` or a SQLcl connect alias)
- `$1`: `app-id` (numeric)
- `$2`: component selector (e.g., `PAGE:10`, `LOV:<id>`, `REGION:<id>`, or "page 10", "shared LOV TAGS_LOV")
- Remaining args: user change request (what to change and why)

**Fallback defaults:** When arguments are omitted, the skill uses the env var settings:
- No connection arg → uses `$SQLCL_CONNECTION`
- No app-id arg → uses `$APEX_APP_ID`
- `$APEX_WORKSPACE` is used during import when the target workspace needs to be specified

If inputs are still incomplete after applying defaults, resolve missing details using `apex list` and/or queries against APEX views.

## Preconditions / Assumptions
- A configured SQLcl MCP server that can:
  - run SQLcl `apex` commands (`apex list`, `apex export`)
  - execute SQL/PLSQL, including `@script.sql`
- The skill directory contains `references/apex_imp/` with `apex_imp` documentation files
- The agent has filesystem write access to a working directory (preferably under version control)

## Canonical SQLcl commands (reference)
- List components: `apex list -applicationid <APP_ID>`
- Export split: `apex export -applicationid <APP_ID> -split`
- Export only selected components:
  - `apex export -applicationid <APP_ID> -expComponents "PAGE:3 LOV:<id> ..."`
  - With `-split`, a partial export typically produces `install_component.sql`
- Import/install:
  - For full split export: run `@f<APP_ID>/install.sql`
  - For partial + split export: run `@f<APP_ID>/install_component.sql`
- For non-identical target environments (workspace/schema/app id/alias changes), use `apex_application_install.*` before running install scripts.

(Keep these as guidance; exact behavior may vary by SQLcl/APEX versions and your environment.)

## Workflow (follow every time)

### 0) MCP tool discovery
1. Confirm the SQLcl MCP server is available in Claude Code.
2. Identify which MCP tools map to:
   - running an `apex` command
   - running ad-hoc SQL
   - running a SQL script file
3. Record the tool names/usage in your working notes if needed.

### 1) Create a safe working area
1. Create a dedicated working folder using a timestamp or `${CLAUDE_SESSION_ID}`.
2. If in a git repo: create a new branch and commit a baseline export before changes.

### 2) Identify the target component precisely
1. Parse `$2` and normalize:
   - `PAGE:<n>` is explicit
   - "page 10" → `PAGE:10`
   - "shared LOV TAGS_LOV" → use `apex list` to find the numeric id and convert to `LOV:<id>`
2. If multiple components are involved, build a single `-expComponents` string:
   - `"PAGE:10 LOV:123456 REGION:..."`

### 3) Export only what you need (prefer `-split` + `-expComponents`)
1. Run export via SQLcl MCP. Recommended:
   - `apex export -applicationid <APP_ID> -split -dir <workdir>/f<APP_ID> -expComponents "<...>"`
2. Confirm expected outputs exist:
   - `install_component.sql` (partial+split) or `install.sql` (full split)
   - component SQL files (e.g., `application/pages/page_00010.sql`)

### 4) Load local `apex_imp` documentation (progressive disclosure)
1. **Always read first:** `references/apex_imp/README.md` (quick reference index).
2. **Always read:** `references/apex_imp/apex_imp.md` (core import engine, ID system, file format).
3. **Read conditionally based on the component type:**
   - Page items, regions, buttons, DAs, processes, IR, IG, charts, maps, cards → read `references/apex_imp/imp_page.md`
   - LOVs, authorization schemes, authentication, lists, templates, build options, static files → read `references/apex_imp/imp_shared.md`
4. **Always read:** `tools/patching_guidelines.md` for patch strategy rules.
5. **Always read:** `references/apex_imp/valid_values.md` for parameter choices.
6. **Read if importing to a different environment:** `references/apex_imp/app_install.md`.
7. **Read if needing export API details:** `references/apex_imp/export_api.md`.

### 5) Plan the change set (DB + APEX export patch)
1. Split the user request into:
   - **Database changes** (DDL/DML/PLSQL): tables, views, packages, grants, seed data
   - **APEX component changes**: regions, items, processes, dynamic actions, LOVs, authorization, navigation, templates
2. Use `templates/patch_plan.md` as a template for documenting the plan.
3. Determine ordering:
   - Apply DB changes first (so APEX references exist)
   - Patch export files
   - Import into APEX

### 6) Apply database changes via SQLcl MCP
1. Generate **idempotent** scripts where possible:
   - avoid failures on re-run (dictionary checks or controlled exception handling)
2. Execute via SQLcl MCP (single script or staged scripts).
3. Validate:
   - compilation status / `show errors`
   - required grants/synonyms if applicable

### 7) Patch exported APEX component file(s)
**Principle:** minimal textual changes, stable anchors, avoid rewriting unrelated sections.

1. Identify which files to patch using `tools/normalize_export_paths.md`.
2. Patch strategy (details in `tools/patching_guidelines.md`):
   - For simple edits (label/source/condition/setting): update existing parameter values in the relevant `wwv_flow_imp_*` calls.
   - For adding new objects: insert a new `wwv_flow_imp_*.create_*` block in the appropriate logical section.
3. ID management:
   - When creating new components, follow `apex_imp` rules for ID generation/offsets.
   - Do not invent random IDs (collision risk on import).
4. Run through `templates/validation_checklist.md` after patching.
5. Run automated validation: `bash tools/validate_export.sh <patched_file.sql>`

### 8) Import back into APEX (SQLcl MCP)
1. If the target environment matches the source (same app/workspace schema expectations):
   - run `@<workdir>/f<APP_ID>/install.sql` or `@.../install_component.sql`
2. If it differs (workspace/schema/app id/alias):
   - prepend an installation context block using `apex_application_install` then run the install script.
3. Capture and summarize the install log:
   - errors/warnings
   - which components were created/updated

### 9) Verify and produce deliverables
1. Recommended: re-export the same component(s) and produce a diff for verification.
2. Deliver to the user:
   - concise summary of DB changes and APEX changes
   - list of modified files
   - patch diff (unified diff preferred)
   - import log summary (success/failure, key warnings)

## Error handling playbook

### Before any changes — create a baseline
- **Git baseline (mandatory if in a git repo):**
  ```
  git add -A && git commit -m "baseline: pre-modification snapshot"
  ```
- Record the current APEX component state by exporting before changes.

### Recovery procedures

| Failure | Recovery |
|---------|----------|
| **Export missing files** | Verify `-dir`, permissions, correct APP_ID, and connection/workspace context. |
| **DB script fails** | Fix the script. If partially applied, reverse with `DROP`/`ALTER` or restore from version control. Re-run after fix. |
| **Patch produces invalid file** | `git checkout -- <file>` to restore the exported original. Re-patch from clean state. |
| **Import fails — ID collision** | Revisit `apex_imp` ID/offset guidance. Ensure `apex_application_install` context is correct. Regenerate IDs if needed. |
| **Import fails — compilation error** | Check `show errors` via SQLcl MCP. Fix DB objects first, then re-import. |
| **Import succeeds but component is broken** | Re-import the original baseline export: `@<workdir>/f<APP_ID>/install_component.sql` from the pre-change export. |
| **Unknown state after failed import** | Re-export the component from APEX (it still holds the last successful import). Diff against your patched file to see what was applied. |

### Logging
- Save all SQLcl import output to a log file in the working directory (e.g., `import_log.txt`).
- On failure, present the log to the user before attempting recovery.

### Rollback decision tree
1. Is the git baseline available? → `git checkout -- <files>` and re-import original.
2. No git? → Re-export the same component from APEX (APEX retains the pre-import state on failure).
3. DB changes need reversal? → Run explicit `DROP`/`ALTER` scripts (idempotent).

## Examples
- `/apex-component-modifier PAGE:10 -- Add item P10_STATUS (select list) based on LOV STATUS_LOV, and create table APP_STATUS if missing.`
  (uses `$SQLCL_CONNECTION` and `$APEX_APP_ID` from settings)
- `/apex-component-modifier DEV 113 PAGE:10 -- Add item P10_STATUS (select list) based on LOV STATUS_LOV, and create table APP_STATUS if missing.`
  (explicit connection and app-id override settings)
- `/apex-component-modifier STG 113 LOV:23618973754424510000 -- Rename LOV display column and update dependent items on Page 3.`
