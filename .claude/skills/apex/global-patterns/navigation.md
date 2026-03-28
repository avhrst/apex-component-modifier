# Navigation (Lists, Menus, Breadcrumbs, Icon Bar)

Patterns from APEX 24.2 exports. Navigation components live in `shared_components/navigation/`.

## API Calls (ordered)

1. `wwv_flow_imp_shared.create_list(...)` — define a list
2. `wwv_flow_imp_shared.create_list_item(...)` — add items to a list
3. `wwv_flow_imp_shared.create_menu(...)` — define a breadcrumb menu
4. `wwv_flow_imp_shared.create_menu_option(...)` — add entries to a breadcrumb menu
5. `wwv_flow_imp_shared.create_icon_bar_item(...)` — legacy navigation bar items (pre-UT)

## File Locations

| Component | File |
|-----------|------|
| Lists | `lists/<list_name>.sql` |
| Breadcrumb menus | `breadcrumbs/breadcrumb.sql` |
| Breadcrumb entries (page-level) | `breadcrumbentry.sql` |
| Legacy icon bar | `navigation_bar.sql` |
| Tabs (legacy) | `tabs/parent.sql`, `tabs/standard.sql` |

---

## Lists

### create_list — Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `p_id` | ID | List ID |
| `p_name` | VARCHAR2 | List name (e.g. `'Navigation Menu'`, `'Navigation Bar'`) |
| `p_list_status` | VARCHAR2 | Always `'PUBLIC'` |

### create_list — Optional Parameters

| Parameter | Type | Typical Values | Default |
|-----------|------|---------------|---------|
| `p_list_type` | VARCHAR2 | `'SQL_QUERY'` | (static — omitted) |
| `p_list_query` | VARCHAR2 | SQL returning level, label, target, is_current, image, ... | — |
| `p_version_scn` | NUMBER | SCN value | — |

### create_list_item — Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `p_id` | ID | List item ID |
| `p_list_item_display_sequence` | NUMBER | Display order (10, 20, 30...) |
| `p_list_item_link_text` | VARCHAR2 | Label text (supports `&APP_USER.` substitutions) |
| `p_list_item_link_target` | VARCHAR2 | URL target (`f?p=...`, `&LOGOUT_URL.`, `#`, `#action$...`, `separator`) |
| `p_list_item_current_type` | VARCHAR2 | How "current" is determined |

### create_list_item — Common Optional Parameters

| Parameter | Type | Typical Values |
|-----------|------|---------------|
| `p_list_item_icon` | VARCHAR2 | Font Awesome class: `'fa-home'`, `'fa-user'`, `'fa-gear'`, `'fa-sign-out'` |
| `p_parent_list_item_id` | ID | Parent item for hierarchy (sub-menu items) |
| `p_list_item_current_for_pages` | VARCHAR2 | Colon-delimited page list: `'10000,10011,10020'` |
| `p_list_item_disp_cond_type` | VARCHAR2 | Display condition type |
| `p_list_item_disp_condition` | VARCHAR2 | Condition expression |
| `p_list_item_disp_condition2` | VARCHAR2 | Second condition expression |
| `p_security_scheme` | VARCHAR2/ID | `'MUST_NOT_BE_PUBLIC_USER'` or `wwv_flow_imp.id(...)` |
| `p_required_patch` | ID | Build option ID |
| `p_list_text_01` | VARCHAR2 | Badge value / extra text |
| `p_list_text_02` | VARCHAR2 | CSS class for `<li>`: `'has-username'`, `'a-pwaInstall'` |
| `p_list_text_03` | VARCHAR2 | Additional attribute |
| `p_list_text_06` | VARCHAR2 | Additional attribute |
| `p_translate_list_text_y_n` | VARCHAR2 | `'Y'` / `'N'` |
| `p_sub_list_id` | ID | Sub-list reference |

### p_list_item_current_type Values

| Value | Usage | Notes |
|-------|-------|-------|
| `'TARGET_PAGE'` | 1173 occurrences | Current when on target page |
| `'COLON_DELIMITED_PAGE_LIST'` | 341 | Current when page in `p_list_item_current_for_pages` |
| `'NEVER'` | 20 | Never highlighted as current |
| `'EXPRESSION'` | 7 | Custom PL/SQL expression |
| `'ALWAYS'` | 5 | Always highlighted |

### p_list_item_disp_cond_type Values

| Value | Count | Notes |
|-------|-------|-------|
| `'EXISTS'` | 38 | SQL query returns rows |
| `'USER_IS_NOT_PUBLIC_USER'` | 28 | Authenticated users only |
| `'EXPRESSION'` | 24 | PL/SQL expression |
| `'NEVER'` | 13 | Hidden |
| `'CURRENT_PAGE_NOT_IN_CONDITION'` | 8 | Hide on listed pages |
| `'FUNCTION_BODY'` | 3 | PL/SQL function returning boolean |
| `'USER_IS_PUBLIC_USER'` | 2 | Public/anonymous users only |
| `'ITEM_IS_NOT_NULL'` | 1 | Item has a value |

---

## Breadcrumb Menus

### create_menu — Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `p_id` | ID | Menu ID |
| `p_name` | VARCHAR2 | Menu name (typically `' Breadcrumb'`) |

### create_menu_option — Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `p_id` | ID | Menu option ID |
| `p_short_name` | VARCHAR2 | Breadcrumb label (e.g. `'Home'`, `'Projects'`) |
| `p_link` | VARCHAR2 | URL: `'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::'` |
| `p_page_id` | NUMBER | Page ID this breadcrumb entry represents |

### create_menu_option — Optional Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `p_parent_id` | ID | Parent breadcrumb for hierarchy |
| `p_option_sequence` | NUMBER | Display sequence (10, 20, 30...) |
| `p_security_scheme` | ID | Authorization scheme |

---

## Legacy Icon Bar

### create_icon_bar_item — Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `p_id` | ID | Icon bar item ID |
| `p_icon_sequence` | NUMBER | Display order |
| `p_icon_subtext` | VARCHAR2 | Label text |
| `p_icon_target` | VARCHAR2 | URL target |
| `p_icon_image_alt` | VARCHAR2 | Alt text |
| `p_icon_height` / `p_icon_width` | NUMBER | Icon dimensions |
| `p_icon_height2` / `p_icon_width2` | NUMBER | Small icon dimensions |
| `p_nav_entry_is_feedback_yn` | VARCHAR2 | `'N'` (always observed) |
| `p_icon_bar_disp_cond_type` | VARCHAR2 | `'NEVER'` to hide |
| `p_begins_on_new_line` | VARCHAR2 | `'NO'` |
| `p_cell_colspan` | NUMBER | `1` |

> **Note:** Modern APEX apps (Universal Theme) use lists for the navigation bar instead of icon bar items. The icon bar is legacy.

---

## Variations

### Variation A: Static Navigation Menu (Side Menu)

The primary app navigation — a hierarchical list used by the side navigation menu.

```sql
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(48318217496977606045)
,p_name=>'Navigation Menu'
,p_list_status=>'PUBLIC'
,p_version_scn=>37167711506896
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(48318914613255606182)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Home'
,p_list_item_link_target=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-home'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(16202888173937192053)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Protected Page'
,p_list_item_link_target=>'f?p=&APP_ID.:100:&SESSION.::&DEBUG.::::'
,p_security_scheme=>'MUST_NOT_BE_PUBLIC_USER'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(48319044486661606653)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Administration'
,p_list_item_link_target=>'f?p=&APP_ID.:10000:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-user-wrench'
,p_list_item_disp_cond_type=>'USER_IS_NOT_PUBLIC_USER'
,p_security_scheme=>wwv_flow_imp.id(48318906626310606175)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'10000,10011,10020,10021,10022,10023,10024,10026,10031,10035,10037,10050,10051'
);
```

### Variation B: Navigation Bar (User Menu with Hierarchy)

Top-right user menu with sub-items (sign-out, separator). Uses `p_parent_list_item_id` for dropdown items and conditions to hide from public users.

```sql
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(19806603120413868739)
,p_name=>'Navigation Bar'
,p_list_status=>'PUBLIC'
,p_version_scn=>45421137299825
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(19806615174191868776)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'&APP_USER.'
,p_list_item_link_target=>'#'
,p_list_item_icon=>'fa-user'
,p_list_item_disp_cond_type=>'USER_IS_NOT_PUBLIC_USER'
,p_list_text_02=>'has-username'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(19806615593619868777)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'---'
,p_list_item_link_target=>'separator'
,p_list_item_disp_cond_type=>'USER_IS_NOT_PUBLIC_USER'
,p_parent_list_item_id=>wwv_flow_imp.id(19806615174191868776)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(19806616003576868778)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Sign Out'
,p_list_item_link_target=>'&LOGOUT_URL.'
,p_list_item_icon=>'fa-sign-out'
,p_list_item_disp_cond_type=>'USER_IS_NOT_PUBLIC_USER'
,p_parent_list_item_id=>wwv_flow_imp.id(19806615174191868776)
,p_list_item_current_type=>'TARGET_PAGE'
);
```

### Variation C: Navigation Bar with PWA Install Action

Adds an "Install App" entry using the `#action$a-pwa-install` target and `a-pwaInstall` CSS class.

```sql
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(37168059109837451379)
,p_name=>'Navigation Bar'
,p_list_status=>'PUBLIC'
,p_version_scn=>37167692709710
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(38962201853961930808)
,p_list_item_display_sequence=>1
,p_list_item_link_text=>'Install App'
,p_list_item_link_target=>'#action$a-pwa-install'
,p_list_item_icon=>'fa-cloud-download'
,p_list_text_02=>'a-pwaInstall'
,p_list_item_current_type=>'NEVER'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(37168059688361451380)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'&APP_USER.'
,p_list_item_link_target=>'#'
,p_list_item_icon=>'a-Icon icon-user'
,p_list_text_02=>'has-username'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(37168060103448451381)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Sign Out'
,p_list_item_link_target=>'&LOGOUT_URL.'
,p_parent_list_item_id=>wwv_flow_imp.id(37168059688361451380)
,p_list_item_current_type=>'TARGET_PAGE'
);
```

### Variation D: SQL Query-Based List

Dynamic list populated from a SQL query. The query must return columns in order: level, label, target, is_current_list_entry, image, image_attribute, image_alt_attribute, attribute1..attribute10.

```sql
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(43018562383678275337)
,p_name=>'Recent Projects'
,p_list_type=>'SQL_QUERY'
,p_list_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select the_level,',
'       label, ',
'       target, ',
'       is_current_list_entry,',
'       image,',
'       image_attribute,',
'       image_alt_attribute,',
'       attribute1,',
'       attribute2,',
'       attribute3,',
'       attribute4,',
'       attribute5,',
'       attribute6,',
'       attribute7,',
'       attribute8,',
'       attribute9,',
'       attribute10',
'  from (',
'with recent_projects as (',
'    select l.project_id, ',
'           max(page_rendered) page_rendered ',
'    from SP_PROJ_INTERACTIONS_LOG l,',
'         sp_projects p',
'    where l.app_user = lower(:APP_USER) and',
'          l.project_id = p.id and',
'          p.ARCHIVED_YN = ''N'' and',
'          p.DUPLICATE_OF_PROJECT_ID is null and',
'          l.page_rendered is not null',
'    group by project_id, l.app_user',
'    order by 2 desc',
'    fetch first 10 rows only)',
'select distinct ',
'       1 as the_level,',
'       decode(',
'         greatest(length(project),70), ',
'         70, ',
'         project,',
'         substr(project,1,80)||''...'') as label, ',
'       apex_page.get_url(p_page => 3, p_items => ''fi'', p_clear_cache => ''3'', p_values => p.friendly_identifier) as target, ',
'       null    is_current_list_entry,',
'       ''fa-pie-chart-''||PCT_COMPLETE as image,',
'       null    image_attribute,',
'       null    image_alt_attribute,',
'       null    attribute1,',
'       null    attribute2,',
'       null    attribute3,',
'       null    attribute4,',
'       null    attribute5,',
'       null    attribute6,',
'       null    attribute7,',
'       null    attribute8,',
'       null    attribute9,',
'       null    attribute10,',
'       l.page_rendered',
'from  sp_projects p,',
'      recent_projects l',
'where p.id = l.project_id ',
')',
'order by page_rendered desc'))
,p_list_status=>'PUBLIC'
,p_version_scn=>44534598357828
);
```

### Variation E: Breadcrumb Menu with Hierarchy

Breadcrumb entries use `p_parent_id` to build the trail. Each entry maps to a page via `p_page_id`.

```sql
wwv_flow_imp_shared.create_menu(
 p_id=>wwv_flow_imp.id(14809767041324651977)
,p_name=>' Breadcrumb'
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(14809767453172651980)
,p_short_name=>'Home'
,p_link=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::'
,p_page_id=>1
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(3256539949223145797)
,p_short_name=>'Administration'
,p_link=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:::'
,p_page_id=>7
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(2142498156306451608)
,p_parent_id=>wwv_flow_imp.id(3256539949223145797)
,p_short_name=>'Application Theme Style'
,p_link=>'f?p=&APP_ID.:6:&SESSION.'
,p_page_id=>6
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(3256544737926177069)
,p_parent_id=>wwv_flow_imp.id(3256539949223145797)
,p_short_name=>'Manage Sample Data'
,p_link=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.:::'
,p_page_id=>10
);
```

### Variation F: Legacy Icon Bar Items

Pre-Universal Theme navigation bar. Modern apps use lists instead.

```sql
wwv_flow_imp_shared.create_icon_bar_item(
 p_id=>wwv_flow_imp.id(41358424742643075610)
,p_icon_sequence=>10
,p_icon_subtext=>'Administration'
,p_icon_target=>'f?p=&APP_ID.:settings:&SESSION.::&DEBUG.::::'
,p_nav_entry_is_feedback_yn=>'N'
,p_icon_bar_disp_cond_type=>'NEVER'
,p_begins_on_new_line=>'NO'
,p_cell_colspan=>1
);
wwv_flow_imp_shared.create_icon_bar_item(
 p_id=>wwv_flow_imp.id(44430980902450298353)
,p_icon_sequence=>20
,p_icon_subtext=>'Logout'
,p_icon_target=>'&LOGOUT_URL.'
,p_icon_image_alt=>'Logout'
,p_icon_height=>32
,p_icon_width=>32
,p_icon_height2=>24
,p_icon_width2=>24
,p_nav_entry_is_feedback_yn=>'N'
,p_begins_on_new_line=>'NO'
,p_cell_colspan=>1
);
```

---

## Separator Pattern

Use `p_list_item_link_text=>'---'` with `p_list_item_link_target=>'separator'` to add a visual divider in dropdown menus:

```sql
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(19806615593619868777)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'---'
,p_list_item_link_target=>'separator'
,p_parent_list_item_id=>wwv_flow_imp.id(19806615174191868776)
,p_list_item_current_type=>'TARGET_PAGE'
);
```

---

## Relationships

- **Lists → Regions**: Lists are rendered by regions with `p_plug_source_type=>'NATIVE_LIST'` and a `p_list_id` reference
- **Navigation Menu list** → Used by the application's side navigation (configured at app level)
- **Navigation Bar list** → Used by the top navigation bar (configured at app level)
- **Breadcrumb menus → Regions**: Rendered by breadcrumb regions with `p_menu_id` reference
- **List items → Authorization**: `p_security_scheme` controls visibility per user role
- **List items → Build Options**: `p_required_patch` ties visibility to build option on/off state
