# apex_imp Reference Documentation

This directory contains reference documentation for the Oracle APEX internal import packages (`wwv_flow_imp`, `wwv_flow_imp_page`, `wwv_flow_imp_shared`) used in APEX export files.

The skill reads these files at workflow step 4 to guide safe modifications of exported APEX component files.

## Files

| File | Description |
|------|-------------|
| `README.md` | This overview |
| `apex_imp.md` | Complete API reference: packages, procedures, ID system, file format |

## Quick reference

- **`wwv_flow_imp`** — core import utilities (`import_begin`, `component_begin`, `id()`)
- **`wwv_flow_imp_page`** — page-level components (regions, items, buttons, processes, DAs)
- **`wwv_flow_imp_shared`** — shared components (LOVs, auth, lists, templates)
- **`apex_application_install`** — pre-import configuration (workspace, schema, offset overrides)

See `apex_imp.md` for full details.
