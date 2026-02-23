# Patching Guidelines

Rules and strategies for safely modifying APEX export files before re-import.

---

## Core Principles

1. **Minimal changes** — only touch what the user requested; do not reformat or rewrite unrelated sections
2. **Stable anchors** — use unique identifiers (component IDs, names) as anchors for edits, not line numbers
3. **Preserve structure** — maintain the exact `begin...end;` / `/` block boundaries
4. **Validate after every patch** — run through `templates/validation_checklist.md`

---

## Edit Strategies

### Strategy 1: Modify Existing Parameter Value

**Use when:** changing a label, condition, source, display sequence, template option, or other parameter on an existing component.

**Approach:** Find the unique `create_*` call by its `p_id` or `p_name`, then replace the specific parameter line.

**Example — change a page item label:**

```
Old: ,p_prompt=>'Employee Name'
New: ,p_prompt=>'Full Name'
```

**Anchor:** use the `p_id` or `p_name` of the component to locate the correct block.

### Strategy 2: Add a New Component

**Use when:** adding a new region, item, button, process, DA, validation, or computation to a page.

**Approach:**
1. Determine the correct section in the file (see component ordering in `apex_imp.md` sections 6.2–6.3)
2. Pick a new unique ID (see ID generation below)
3. Insert a complete `begin...end;` / `/` block with the `create_*` call
4. Update the manifest comment block at the top of the file
5. Set appropriate sequence numbers that don't collide

**Example — add a new page item after existing items:**

```sql
begin
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(<NEW_ID>)
,p_name=>'P10_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30                                -- after existing 10, 20
,p_item_plug_id=>wwv_flow_imp.id(<REGION_ID>)      -- parent region
,p_item_source_plug_id=>wwv_flow_imp.id(<REGION_ID>)
,p_prompt=>'Status'
,p_source=>'STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>wwv_flow_imp.id(<LOV_ID>)
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select -'
,p_cHeight=>1
,p_field_template=>wwv_flow_imp.id(<LABEL_TEMPLATE_ID>)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'Y'
,p_protection_level=>'S'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
end;
/
```

### Strategy 3: Remove a Component

**Use when:** deleting a region, item, button, etc.

**Approach:**
1. Find the entire `begin...end;` / `/` block for the component
2. Remove the entire block (including the `begin`, `end;`, and `/` lines)
3. Update the manifest comment block
4. Check for orphaned cross-references (other components referencing this ID)

### Strategy 4: Add a New Shared Component

**Use when:** creating a new LOV, authorization scheme, list, etc. that doesn't exist yet.

**Approach:**
1. Create a new file under the appropriate `shared_components/` subdirectory
2. Include `component_begin`/`component_end` wrappers
3. Add the `create_*` call(s)
4. Add a `@@` reference in `install_component.sql` (before the page files that depend on it)

---

## ID Generation Rules

### Finding a safe new ID

1. **Scan existing IDs** in the target file(s) — collect all numeric values inside `wwv_flow_imp.id(...)`
2. **Pick a new ID** that is:
   - Not already used in the export
   - Sufficiently large to avoid collision with system-generated IDs
3. **Recommended approach:** find the maximum ID in the file, add 1 (or use a consistent offset like +100)
4. **Never use random IDs** — they risk colliding with IDs in the target database after offset is applied

### Cross-reference consistency

When a new component references another:
- Use the **raw ID** (as it appears in the export, pre-offset)
- Wrap in `wwv_flow_imp.id(...)` — the offset is applied uniformly at import time

### IDs that are NOT wrapped in `wwv_flow_imp.id()`

- `p_id` in `create_page` — this is the raw page number (e.g., `10`)
- `p_internal_uid` in some process calls — uses the raw numeric ID

---

## Sequence Number Rules

- `p_plug_display_sequence` (regions): controls visual order, typically increments by 10
- `p_item_sequence` (items): controls item order within a region
- `p_button_sequence` (buttons): controls button order
- `p_process_sequence` (processes): controls execution order
- `p_event_sequence` (DA events): controls DA evaluation order
- `p_action_sequence` (DA actions): controls action order within an event
- `p_validation_sequence` (validations): controls validation order
- `p_computation_sequence` (computations): controls computation order
- `p_branch_sequence` (branches): controls branch evaluation order

**Tip:** use gaps (10, 20, 30...) to allow future insertions. When inserting between 10 and 20, use 15.

---

## Multi-Line String Handling

When a value needs to span multiple lines (SQL queries, PL/SQL blocks, HTML), use:

```sql
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'line 1',
'line 2',
'line 3'))
```

Rules:
- Each line is a separate VARCHAR2 literal
- Lines are joined with newline characters by `wwv_flow_string.join`
- Single quotes within lines must be doubled: `'it''s'`
- Keep individual lines under ~4000 characters

---

## Common Pitfalls

| Pitfall | Prevention |
|---------|------------|
| Missing `/` terminator | Always include `/` on its own line after `end;` |
| Unbalanced `begin`/`end;` | Count blocks before and after patch |
| ID collision | Scan all existing IDs in the file first |
| Orphaned cross-reference | Search the file for the old ID before removing a component |
| Wrong section | Follow the ordering rules in `apex_imp.md` sections 6.2–6.3 |
| Corrupted `component_begin`/`component_end` | Never modify the wrapper blocks |
| Missing manifest entry | Update the manifest comment when adding/removing components |
| Broken `wwv_flow_string.join` | Ensure all lines end with `',` (except the last which ends with `'))` |
