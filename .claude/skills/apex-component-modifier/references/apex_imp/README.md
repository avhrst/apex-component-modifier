# apex_imp Reference Documentation

Reference documentation for the Oracle APEX internal import packages, derived from the APEX 24.2 source.

The skill reads these files at workflow step 4 to guide safe modifications of exported APEX component files.

## Files

| File | Description |
|------|-------------|
| `apex_imp.md` | Core import infrastructure: `wwv_flow_imp` (import_begin/end, component_begin/end, id()), split export directory structure, file format rules, ID offset system |
| `imp_page.md` | `wwv_flow_imp_page` — all page component procedures: create_page, create_page_plug (regions), create_page_item, create_page_button, create_page_process, create_page_da_event/action, create_page_validation, create_page_computation, create_page_branch, IR/IG/Chart/Map/Cards procedures |
| `imp_shared.md` | `wwv_flow_imp_shared` — shared component procedures: LOVs, authorization schemes, authentication, lists, templates, build options, static files |
| `valid_values.md` | Comprehensive enumeration of all valid parameter values: region types, item types, process types, DA action types, event types, data types, source types, protection levels, etc. |
| `app_install.md` | `apex_application_install` — pre-import configuration: set_workspace_id, set_application_id, set_schema, generate_offset, etc. |
| `export_api.md` | `apex_export` — export API: get_application (split, components, types), get_workspace, zip/unzip |

## Quick package reference

| Package | Internal Name | Purpose |
|---------|--------------|---------|
| Core import engine | `wwv_flow_imp` | `import_begin`, `import_end`, `component_begin`, `component_end`, `id()`, `set_version` |
| Page components | `wwv_flow_imp_page` | Pages, regions, items, buttons, processes, DAs, validations, computations, branches, IR, IG, charts, maps, cards |
| Shared components | `wwv_flow_imp_shared` | LOVs, auth schemes, authorization, lists, templates, build options, static files |
| String utilities | `wwv_flow_string` / `apex_string` | `join()` for concatenating `wwv_flow_t_varchar2` collections in export files |
| Pre-import config | `wwv_flow_application_install` / `apex_application_install` | Override workspace, app ID, schema, offset before import |
| Export API | `wwv_flow_export_api` / `apex_export` | `get_application` with split/component options |
| Import parser | `wwv_flow_imp_parser` | Parses export files, handles ZIP, creates installable SQL from split files |
| ID generation | `wwv_flow_id` | `next_val` — generates unique component IDs |

## Key facts

- **`wwv_flow_imp` is frozen as of APEX 21.2** — new components use `wwv_flow_imp_page` and `wwv_flow_imp_shared`
- The `id()` function applies `g_id_offset`: `id(N)` returns `N + g_id_offset`
- Current version constants: `c_release_date_str = '2024.11.30'`, `c_current = 20241130`
- Component creation order matters due to parent-child relationships (page → region → items/buttons)
- All export files are UTF-8 encoded with `set define off` at the top
