---
description: Learn patterns from an existing APEX app -- exports all components, analyzes conventions, generates pattern files for future patching
argument-hint: "[app-id]"
---

Learn patterns of APEX application `$ARGUMENTS` (or `$APEX_APP_ID`) by exporting and analyzing all components. Generate pattern files in `.claude/skills/apex-component-modifier/app-patterns/`.

## Before you start

1. Check `global-patterns/` -- these are reusable cross-app patterns. App-patterns should capture app-specific conventions only.
2. If `app-patterns/` exists, this run overwrites it (fresh snapshot).

## Workflow

### 1. Connect and export

1. Connect using `$SQLCL_CONNECTION`.
2. App ID: `$ARGUMENTS` if provided, else `$APEX_APP_ID`.
3. Run: `apex export -applicationid <APP_ID> -split`.
4. Confirm export directory exists, list top-level structure.

### 2. Build template ID map

Read template files under `application/shared_components/user_interface/templates/` (region, label, button, page, report, list). Extract name + `wwv_flow_imp.id(...)` value. Store mapping for resolving template references.

### 3. Scan all pages

Read every `application/pages/page_*.sql`. Collect (don't generate files yet):
- Page number, name, mode, alias, group
- Component counts: regions, items, buttons, processes, DAs, validations, branches
- Region types, template IDs (resolve to names), item naming pattern
- Sequence gap pattern, LOV references, process types, DA event/action types

### 4. Generate conventions.md

Consolidate step 3 into:

```
# App <APP_ID> Conventions

## Template IDs
### Region Templates
| ID | Name | Usage Count |
|----|------|-------------|

### Label Templates
| ID | Name | Usage Count |
|----|------|-------------|

### Button Templates
| ID | Name | Usage Count |
|----|------|-------------|

### Page Templates
| ID | Name | Usage Count |
|----|------|-------------|

## Naming Conventions
- Items: `P<page>_<COLUMN_NAME>` (confirmed across N pages)
- Buttons: <pattern>
- Regions: <pattern>

## Sequence Style
- Increment by: <most common>
- Exceptions: <deviations>

## Common LOV References
| LOV Name | Used On Pages | Type |
|----------|---------------|------|

## Process Patterns
- Form fetch/DML/Custom PL/SQL: <patterns>

## Dynamic Action Patterns
- Frequent events, action types, combos: <with counts>

## Condition Patterns
- Common types and expressions
```

### 5. Generate shared_components.md

Read `application/shared_components/` and produce tables for:
- **LOVs:** Name, Type, Query (truncated)
- **Authorization Schemes:** Name, Type, Description
- **Authentication:** Scheme name and type
- **Navigation:** Lists, breadcrumbs, navbar -- name and target
- **Build Options:** Name, Status, Description

### 6. Generate representative page patterns

Pick **2-5 pages** for diversity (form, report, cards/chart/map; prefer pages with DAs, processes, validations, most variety).

For each, generate `pages/page_NNNNN.md` with:
- Header: page number, name, mode, alias, group, selection reason
- Component tables (regions, items, buttons, processes, DAs) with resolved template names
- Validations/Computations/Branches (only if present)
- Key patterns: notable template choices, conditions, DA combos, deviations
- 1-2 representative `wwv_flow_imp_page.create_*` SQL blocks verbatim

### 7. Generate catalog.md

```
# App Patterns Catalog -- App <APP_ID>
**Generated:** <date> | **Workspace:** $APEX_WORKSPACE | **Total Pages:** <N>

## Page Inventory
| Page | Name | Regions | Items | Buttons | Procs | DAs | Region Types |
|------|------|---------|-------|---------|-------|-----|--------------|

## Detailed Page Patterns
| File | Page | Why Selected |
|------|------|--------------|

## App Pattern Files
| File | Contents |
|------|----------|
| conventions.md | Template IDs, naming, sequences, LOVs, process/DA patterns |
| shared_components.md | LOVs, auth schemes, navigation, build options |

## Applicable Global Patterns
| Global Pattern File | Relevant Because |
|---------------------|------------------|

If component types have NO global-patterns coverage, list under "## Suggested Global Patterns".
```

### 8. Report

Print: pages scanned, page files generated, path to catalog.md, global-pattern matches, uncovered component types, unparseable pages.

## Rules

- **Read-only** -- do NOT modify APEX components or DB objects, do NOT import.
- Overwrite `app-patterns/` each run.
- Read large page files in chunks if needed.
- If export fails, report error and stop.
- Always resolve template IDs to names.
- Keep export directory after generation.
