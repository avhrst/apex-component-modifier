# Patching Guidelines

Rules for safely modifying APEX export files before re-import.

---

## Core Principles

1. **Minimal changes** — only touch what the user requested; don't reformat unrelated sections
2. **Stable anchors** — locate edits by component IDs/names, not line numbers
3. **Preserve structure** — maintain `begin...end;` / `/` block boundaries
4. **Validate** — run `templates/validation_checklist.md` after every patch

---

## Edit Strategies

### Strategy 1: Modify Existing Parameter

Find the `create_*` call by `p_id` or `p_name`, replace the specific parameter line.

```
Old: ,p_prompt=>'Employee Name'
New: ,p_prompt=>'Full Name'
```

### Strategy 2: Add New Component

1. Determine correct section (see ordering in `apex_imp.md`)
2. Pick a new unique ID (see ID rules below)
3. Insert a complete `begin...end;` / `/` block
4. Update the manifest comment block at top of file
5. Use non-colliding sequence numbers

Example — new page item:
```sql
begin
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(<NEW_ID>)
,p_name=>'P10_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(<REGION_ID>)
,p_prompt=>'Status'
,p_source=>'STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>wwv_flow_imp.id(<LOV_ID>)
,p_field_template=>wwv_flow_imp.id(<LABEL_TEMPLATE_ID>)
,p_item_template_options=>'#DEFAULT#'
);
end;
/
```

### Strategy 3: Remove Component

Remove the entire `begin...end;` / `/` block. Update manifest. Check for orphaned cross-references.

### Strategy 4: Add New Shared Component

Create file under `shared_components/` with `component_begin`/`component_end` wrappers. Add `@@` reference in `install_component.sql` before dependent page files.

---

## ID Rules

1. Scan all `wwv_flow_imp.id(...)` values in the file
2. New ID = max existing + 1 (or +100 for spacing)
3. Never use random IDs — collision risk after offset
4. Cross-references must use matching raw IDs wrapped in `wwv_flow_imp.id(...)`
5. `p_id` in `create_page` is a raw page number (NOT wrapped)
6. `p_internal_uid` is also NOT wrapped

See `apex_imp.md` § ID Management for full details.

---

## Sequence Numbers

All sequence params (`p_plug_display_sequence`, `p_item_sequence`, `p_button_sequence`, `p_process_sequence`, `p_event_sequence`, `p_action_sequence`, `p_validation_sequence`, `p_computation_sequence`, `p_branch_sequence`) control ordering. Use gaps of 10. When inserting between 10 and 20, use 15.

---

## Multi-Line Strings

```sql
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'line 1',
'line 2',
'line 3'))
```

Quotes doubled inside: `'it''s'`. Keep lines under ~4000 chars.

---

## Common Pitfalls

| Pitfall | Prevention |
|---------|------------|
| Missing `/` terminator | Always `/` on own line after `end;` |
| ID collision | Scan existing IDs first |
| Orphaned cross-reference | Search for old ID before removing component |
| Wrong section | Follow ordering in `apex_imp.md` |
| Corrupted wrappers | Never modify `component_begin`/`component_end` blocks |
| Missing manifest entry | Update manifest when adding/removing components |
| Broken `wwv_flow_string.join` | Lines end with `',` except last: `'))` |
