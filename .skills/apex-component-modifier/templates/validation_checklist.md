# Post-Patch Validation Checklist

Run through this checklist after patching export files and before importing.

---

## File Integrity

- [ ] Every `begin` has a matching `end;`
- [ ] Every PL/SQL block is terminated with `/` on its own line
- [ ] No orphaned `/` terminators (would execute empty blocks)
- [ ] `set define off` is present at the top of each file
- [ ] `prompt --application/...` directives are intact and not duplicated

## Component Wrapper (split exports)

- [ ] `wwv_flow_imp.component_begin(...)` is present at the top of each component file
- [ ] `wwv_flow_imp.component_end` is present at the bottom
- [ ] Parameters in `component_begin` are unchanged (version, workspace, app, offset, owner)

## ID Consistency

- [ ] Every new component has a unique ID (not reused from another component in the same file)
- [ ] All IDs are wrapped in `wwv_flow_imp.id(...)` (except `p_id` in `create_page` which is the raw page number)
- [ ] Cross-references use matching IDs:
  - `p_item_plug_id` → matches a region's `p_id`
  - `p_item_source_plug_id` → matches a region's `p_id`
  - `p_button_plug_id` → matches a region's `p_id`
  - `p_event_id` in `create_page_da_action` → matches a `create_page_da_event` `p_id`
  - `p_process_when_button_id` → matches a button's `p_id`
  - `p_named_lov` → matches an LOV's `p_id`
  - `p_associated_item` → matches an item's `p_id`
  - `p_affected_region_id` → matches a region's `p_id`
  - `p_field_template` → matches a label template `p_id`
  - `p_plug_template` → matches a region template `p_id`
  - `p_button_template_id` → matches a button template `p_id`

## Ordering

- [ ] New components are inserted in the correct section (regions with regions, items with items, etc.)
- [ ] Sequence numbers (`p_plug_display_sequence`, `p_item_sequence`, etc.) don't collide with existing ones
- [ ] Manifest comment block at the top of the page file lists all components (including new ones)

## String Formatting

- [ ] Single quotes are properly escaped (doubled: `''`)
- [ ] Multi-line strings use `wwv_flow_string.join(wwv_flow_t_varchar2(...))`
- [ ] No unescaped `&` characters in string literals (ensure `set define off` is set)
- [ ] Comma-first parameter style is preserved (`,p_name=>'...'`)

## Functional

- [ ] DB objects referenced by APEX components exist (tables, views, packages, LOVs)
- [ ] Column names in `p_source`, `p_query_table`, `p_plug_source` match actual DB columns
- [ ] Page item names follow the `P<page>_<name>` convention
- [ ] `p_source_type` matches the item's data binding (e.g., `REGION_SOURCE_COLUMN` for form items)

## Import Readiness

- [ ] `install_component.sql` (or `install.sql`) correctly references all patched files
- [ ] If importing to a different environment, `apex_application_install` overrides are prepared
- [ ] No syntax errors (ideally validated by running through a SQL parser or dry-run)
