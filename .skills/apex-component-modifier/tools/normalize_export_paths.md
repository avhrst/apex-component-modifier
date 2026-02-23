# Normalize Export Paths

Guidelines for mapping APEX component selectors to their file paths in a split export.

---

## Path Resolution Rules

Given a working directory `<workdir>/f<APP_ID>/`, resolve component selectors to file paths:

### Pages

| Selector | File Path |
|----------|-----------|
| `PAGE:1` | `application/pages/page_00001.sql` |
| `PAGE:10` | `application/pages/page_00010.sql` |
| `PAGE:100` | `application/pages/page_00100.sql` |
| `PAGE:0` (Global Page) | `application/pages/page_00000.sql` |

**Rule:** zero-pad the page number to 5 digits: `page_%05d.sql`

### Shared Components — LOVs

| Selector | File Path |
|----------|-----------|
| `LOV:<id>` | `application/shared_components/user_interface/lovs/<lov_name>.sql` |

LOV files are named by the LOV name (lowercased, spaces → underscores). Use `Glob` to find the exact file if the name is unknown.

### Shared Components — Authorization Schemes

| Selector | File Path |
|----------|-----------|
| `AUTHORIZATION:<id>` | `application/shared_components/security/authorizations/<name>.sql` |

### Shared Components — Lists (Navigation)

| Selector | File Path |
|----------|-----------|
| `LIST:<id>` | `application/shared_components/navigation/lists/<name>.sql` |

### Shared Components — Templates

| Selector | File Path |
|----------|-----------|
| `TEMPLATE:<id>` | `application/shared_components/user_interface/templates/<type>/<name>.sql` |

Template types: `region/`, `page/`, `button/`, `label/`, `list/`, `report/`, `popup_lov/`, `calendar/`, `breadcrumb/`

### Shared Components — Plugins

| Selector | File Path |
|----------|-----------|
| `PLUGIN:<id>` | `application/shared_components/plugins/<plugin_type>_<name>.sql` |

### Shared Components — Other

| Category | Directory |
|----------|-----------|
| Application Items | `application/shared_components/logic/application_items.sql` |
| Application Processes | `application/shared_components/logic/application_processes.sql` |
| Application Computations | `application/shared_components/logic/application_computations.sql` |
| Application Settings | `application/shared_components/logic/application_settings.sql` |
| Build Options | `application/shared_components/logic/build_options.sql` |
| Authentication | `application/shared_components/security/authentication/authentication.sql` |
| Breadcrumbs | `application/shared_components/navigation/breadcrumbs/breadcrumb.sql` |
| Shortcuts | `application/shared_components/user_interface/shortcuts/<name>.sql` |
| Themes | `application/shared_components/user_interface/themes/theme_<n>.sql` |
| Messages | `application/shared_components/globalization/messages.sql` |
| Web Sources | `application/shared_components/web_sources/<name>.sql` |

---

## Discovery Commands

When the exact file name is unknown, use these approaches:

```
# Find all LOV files
Glob: application/shared_components/user_interface/lovs/*.sql

# Find a specific page
Glob: application/pages/page_00010.sql

# Search for a component by name
Grep: "p_name=>'STATUS_LOV'" in application/shared_components/

# List all pages
Glob: application/pages/page_*.sql
```

---

## Install Script References

After patching, verify the install script references the correct files:

- **Full export:** `install.sql` uses `@@application/pages/page_00010.sql`
- **Partial export:** `install_component.sql` references only the exported component files

If you added a **new** shared component file that wasn't in the original export, you must also add a corresponding `@@` line to the install script.
