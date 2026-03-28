# apex_imp Reference Documentation

APEX 24.2 import package reference. Read at workflow step 4.

## Files

| File | Contents |
|------|----------|
| `apex_imp.md` | `wwv_flow_imp` core: import/component begin/end, `id()`, file format, ID offsets, directory structure |
| `imp_page.md` | `wwv_flow_imp_page`: regions, items, buttons, processes, DAs, validations, IR/IG/charts/maps/cards |
| `imp_shared.md` | `wwv_flow_imp_shared`: LOVs, auth, lists, templates, build options, static files |
| `valid_values.md` | All valid parameter values (region/item/process/DA types, data types, etc.) |
| `app_install.md` | `apex_application_install`: pre-import config (workspace, app ID, schema, offset) |
| `export_api.md` | `apex_export`: export API (split, components, types) |
| `../examples/add_select_list_item.md` | End-to-end patching example |

## Quick Package Reference

| Package | Purpose |
|---------|---------|
| `wwv_flow_imp` | Core engine (frozen 21.2): `import_begin/end`, `component_begin/end`, `id()` |
| `wwv_flow_imp_page` | Pages, regions, items, buttons, processes, DAs, validations, IR, IG, charts, maps, cards |
| `wwv_flow_imp_shared` | LOVs, auth, lists, templates, build options, static files |
| `wwv_flow_string` / `apex_string` | `join()` for multi-line strings |
| `apex_application_install` | Override workspace, app ID, schema, offset before import |
| `apex_export` | `get_application` with split/component options |
| `wwv_flow_imp_parser` | Parse/install export files (ZIP, split, single) |
| `wwv_flow_id` | `next_val` -- generate unique component IDs |

## Key Facts

- `wwv_flow_imp` frozen as of 21.2 -- new components use `wwv_flow_imp_page`/`wwv_flow_imp_shared`
- `id(N)` returns `N + g_id_offset`
- Current version: `c_current = 20241130`, `c_release_date_str = '2024.11.30'`
- Creation order matters: page -> region -> items/buttons (parent-child)
- Export files: UTF-8, `set define off` at top

## Version Compatibility

| Feature | Since |
|---------|-------|
| `wwv_flow_imp_page`/`wwv_flow_imp_shared` | 21.2 |
| `apex export -split` | 5.0 |
| `-expComponents` | 19.1 |
| AI Builder (`p_ai_*`) | 24.1 |
| Map/Cards regions | 21.1 |

When targeting older APEX: export from that version first to see which parameters it produces.
