# Normalize Export Paths

Map APEX component selectors to file paths in a split export (`<workdir>/f<APP_ID>/`).

---

## Pages

`PAGE:<N>` → `application/pages/page_%05d.sql` (zero-padded to 5 digits)

| Selector | File |
|----------|------|
| `PAGE:0` | `application/pages/page_00000.sql` (Global Page) |
| `PAGE:1` | `application/pages/page_00001.sql` |
| `PAGE:10` | `application/pages/page_00010.sql` |

## Shared Components

| Selector | Path |
|----------|------|
| `LOV:<id>` | `application/shared_components/user_interface/lovs/<lov_name>.sql` |
| `AUTHORIZATION:<id>` | `application/shared_components/security/authorizations/<name>.sql` |
| `LIST:<id>` | `application/shared_components/navigation/lists/<name>.sql` |
| `TEMPLATE:<id>` | `application/shared_components/user_interface/templates/<type>/<name>.sql` |
| `PLUGIN:<id>` | `application/shared_components/plugins/<plugin_type>_<name>.sql` |

Template types: `region/`, `page/`, `button/`, `label/`, `list/`, `report/`, `popup_lov/`, `calendar/`, `breadcrumb/`

LOV files are named by LOV name (lowercased, spaces → underscores). Use `Glob` if name is unknown.

## Fixed-Path Components

| Category | File |
|----------|------|
| Application Items | `shared_components/logic/application_items.sql` |
| Application Processes | `shared_components/logic/application_processes.sql` |
| Application Computations | `shared_components/logic/application_computations.sql` |
| Application Settings | `shared_components/logic/application_settings.sql` |
| Build Options | `shared_components/logic/build_options.sql` |
| Authentication | `shared_components/security/authentication/authentication.sql` |
| Breadcrumbs | `shared_components/navigation/breadcrumbs/breadcrumb.sql` |
| Themes | `shared_components/user_interface/themes/theme_<n>.sql` |
| Messages | `shared_components/globalization/messages.sql` |

All paths relative to `application/`.

## Discovery

When exact file name is unknown: `Glob: application/shared_components/user_interface/lovs/*.sql` or `Grep: "p_name=>'STATUS_LOV'" in application/shared_components/`

## Install Script

- Full export: `install.sql` uses `@@application/pages/page_00010.sql`
- Partial: `install_component.sql` references only exported files
- New shared component files must be added as `@@` lines in the install script before dependent pages
