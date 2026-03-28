# Post-Patch Validation Checklist

Run after patching, before importing.

## File Integrity
- [ ] Every `begin` has matching `end;`
- [ ] Every PL/SQL block terminated with `/` on own line
- [ ] No orphaned `/` terminators
- [ ] `set define off` present at top of each file
- [ ] `prompt --application/...` directives intact, not duplicated

## Component Wrapper (split exports)
- [ ] `wwv_flow_imp.component_begin(...)` at top
- [ ] `wwv_flow_imp.component_end` at bottom
- [ ] `component_begin` params unchanged (version, workspace, app, offset, owner)

## ID Consistency
- [ ] Every new component has unique ID
- [ ] All IDs wrapped in `wwv_flow_imp.id(...)` (except `p_id` in `create_page` = raw page number)
- [ ] Cross-references match:
  - `p_item_plug_id` / `p_item_source_plug_id` / `p_button_plug_id` -> region `p_id`
  - `p_event_id` in DA action -> DA event `p_id`
  - `p_process_when_button_id` -> button `p_id`
  - `p_named_lov` -> LOV `p_id`
  - `p_associated_item` -> item `p_id`
  - `p_affected_region_id` -> region `p_id`
  - `p_field_template` -> label template `p_id`
  - `p_plug_template` -> region template `p_id`
  - `p_button_template_id` -> button template `p_id`

## Ordering
- [ ] New components in correct section (regions with regions, items with items, etc.)
- [ ] Sequence numbers don't collide with existing
- [ ] Manifest comment block lists all components including new ones

## String Formatting
- [ ] Single quotes properly escaped (doubled: `''`)
- [ ] Multi-line strings use `wwv_flow_string.join(wwv_flow_t_varchar2(...))`
- [ ] No unescaped `&` in string literals (`set define off` must be set)
- [ ] Comma-first style preserved (`,p_name=>'...'`)

## Functional
- [ ] Referenced DB objects exist (tables, views, packages, LOVs)
- [ ] Column names in `p_source`, `p_query_table`, `p_plug_source` match actual columns
- [ ] Page item names follow `P<page>_<name>` convention
- [ ] `p_source_type` matches data binding (e.g., `REGION_SOURCE_COLUMN` for form items)

## Import Readiness
- [ ] Install script correctly references all patched files
- [ ] If different environment, `apex_application_install` overrides prepared
- [ ] No syntax errors
