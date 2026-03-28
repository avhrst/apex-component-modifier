# APEX Skill Improvement from Examples — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Improve the APEX skill by mining 29 example apps to expand global-patterns, validate references, and build an examples index.

**Architecture:** Type-first targeted extraction — grep each `wwv_flow_imp_*` API call across all 29 apps, collect instances, synthesize patterns + parameter catalogs. Build index first (enables all other tasks), then process patterns and references in parallel.

**Tech Stack:** Bash (grep/jq for extraction), Markdown (patterns + references), JSON (catalog index)

---

## File Structure

**New files:**
- `examples/catalog.json` — API call index across all 29 apps
- `.claude/skills/apex/global-patterns/page_process.md`
- `.claude/skills/apex/global-patterns/page_validation.md`
- `.claude/skills/apex/global-patterns/page_computation.md`
- `.claude/skills/apex/global-patterns/page_branch.md`
- `.claude/skills/apex/global-patterns/navigation.md`
- `.claude/skills/apex/global-patterns/lov.md`
- `.claude/skills/apex/global-patterns/authorization.md`
- `.claude/skills/apex/global-patterns/web_source.md`
- `.claude/skills/apex/global-patterns/automation.md`
- `.claude/skills/apex/global-patterns/map_region.md`

**Modified files:**
- `.claude/skills/apex/global-patterns/cards_region.md`
- `.claude/skills/apex/global-patterns/card_component.md`
- `.claude/skills/apex/global-patterns/card_media.md`
- `.claude/skills/apex/global-patterns/card_actions.md`
- `.claude/skills/apex/global-patterns/card_icons.md`
- `.claude/skills/apex/global-patterns/interactive_report.md`
- `.claude/skills/apex/global-patterns/interactive_grid.md`
- `.claude/skills/apex/global-patterns/form_region.md`
- `.claude/skills/apex/global-patterns/classic_report.md`
- `.claude/skills/apex/global-patterns/jet_chart.md`
- `.claude/skills/apex/global-patterns/dynamic_actions.md`
- `.claude/skills/apex/global-patterns/faceted_search.md`
- `.claude/skills/apex/references/apex_imp/valid_values.md`
- `.claude/skills/apex/references/apex_imp/imp_page.md`
- `.claude/skills/apex/references/apex_imp/imp_shared.md`

---

## Task 1: Build examples catalog index

**Files:**
- Create: `examples/catalog.json`

This task enables ALL subsequent tasks. Must complete first.

- [ ] **Step 1: Extract all API calls and file paths**

Run this script from the repo root to produce a raw mapping of every `wwv_flow_imp_*` API call to its file path:

```bash
cd /Users/oleksii/Code/apex-component-modifier/examples
grep -rn "wwv_flow_imp[a-z_]*\.[a-z_]*" --include="*.sql" -o -h | sort | uniq -c | sort -rn > /tmp/apex_api_counts.txt
grep -rn "wwv_flow_imp[a-z_]*\.[a-z_]*" --include="*.sql" -h | sed 's/:.*//' | sort -u > /tmp/apex_api_files_raw.txt
```

- [ ] **Step 2: Generate catalog.json**

Build the JSON catalog programmatically. For each distinct API call, collect the count and all file paths (relative to `examples/`):

```bash
cd /Users/oleksii/Code/apex-component-modifier/examples
python3 -c "
import json, subprocess, os, re
from collections import defaultdict
from datetime import datetime

result = subprocess.run(
    ['grep', '-rn', r'wwv_flow_imp[a-z_]*\.[a-z_]*', '--include=*.sql', '-o', '-H'],
    capture_output=True, text=True, cwd='.'
)

api_calls = defaultdict(lambda: {'count': 0, 'files': set()})
apps = set()

for line in result.stdout.strip().split('\n'):
    if ':' not in line:
        continue
    parts = line.split(':', 2)
    if len(parts) < 3:
        continue
    filepath = parts[0]
    api_call = parts[2].strip()
    api_calls[api_call]['count'] += 1
    api_calls[api_call]['files'].add(filepath)
    app_match = re.match(r'(f\d+)/', filepath)
    if app_match:
        apps.add(app_match.group(1))

catalog = {
    'generated': datetime.now().isoformat(),
    'apps': sorted(apps),
    'total_api_calls': len(api_calls),
    'api_calls': {}
}

for api_call in sorted(api_calls.keys()):
    catalog['api_calls'][api_call] = {
        'count': api_calls[api_call]['count'],
        'files': sorted(api_calls[api_call]['files'])
    }

with open('catalog.json', 'w') as f:
    json.dump(catalog, f, indent=2)

print(f'Catalog generated: {len(apps)} apps, {len(api_calls)} distinct API calls')
"
```

- [ ] **Step 3: Validate catalog**

```bash
cd /Users/oleksii/Code/apex-component-modifier/examples
python3 -c "
import json
with open('catalog.json') as f:
    c = json.load(f)
print(f'Apps: {len(c[\"apps\"])}')
print(f'API calls: {len(c[\"api_calls\"])}')
# Spot check key APIs exist
for api in ['wwv_flow_imp_page.create_page', 'wwv_flow_imp_page.create_page_plug',
            'wwv_flow_imp_page.create_page_item', 'wwv_flow_imp_page.create_page_process',
            'wwv_flow_imp_shared.create_list_of_values', 'wwv_flow_imp_shared.create_security_scheme']:
    if api in c['api_calls']:
        print(f'  {api}: {c[\"api_calls\"][api][\"count\"]} instances')
    else:
        print(f'  MISSING: {api}')
"
```

Expected: 29 apps, 90+ API calls, all spot-checked APIs present.

- [ ] **Step 4: Commit**

```bash
cd /Users/oleksii/Code/apex-component-modifier
git add examples/catalog.json
git commit -m "feat: add examples catalog index (29 apps, 90+ API calls)"
```

---

## Task 2: Create page_process.md pattern

**Files:**
- Create: `.claude/skills/apex/global-patterns/page_process.md`

**Depends on:** Task 1 (catalog.json)

- [ ] **Step 1: Extract representative process examples**

Use catalog.json to find files with `create_page_process`, then read 8-10 diverse examples covering: NATIVE_PLSQL, NATIVE_FORM_DML, NATIVE_FORM_FETCH, NATIVE_INVOKE_API, NATIVE_CLOSE_WINDOW, NATIVE_RESET_PAGINATION, NATIVE_SEND_EMAIL, NATIVE_IG_DML.

```bash
cd /Users/oleksii/Code/apex-component-modifier/examples
grep -l "create_page_process" f*/application/pages/*.sql | head -20
```

Read 8-10 files from different apps. For each, extract the full `create_page_process(...)` call block.

- [ ] **Step 2: Extract parameter value catalog**

Collect all distinct values for key parameters across all examples:

```bash
cd /Users/oleksii/Code/apex-component-modifier/examples
grep -A 30 "create_page_process" f*/application/pages/*.sql | grep "p_process_type=>" | sed "s/.*p_process_type=>'//;s/'.*//" | sort | uniq -c | sort -rn
grep -A 30 "create_page_process" f*/application/pages/*.sql | grep "p_process_point=>" | sed "s/.*p_process_point=>'//;s/'.*//" | sort | uniq -c | sort -rn
```

Repeat for: `p_process_type`, `p_process_point`, `p_process_when_type`, `p_process_when_button_id` patterns, `p_error_display_location`.

- [ ] **Step 3: Write page_process.md**

Follow the pattern file structure from the spec:
- `# Component: Page Process`
- `## API Calls` — `wwv_flow_imp_page.create_page_process`
- `## Required Parameters` — table with p_id, p_process_sequence, p_process_point, p_process_type, p_process_name
- `## Common Optional Parameters` — table with p_process_sql_clob, p_process_error_message, p_process_when_button_id, p_process_when_type, p_process_when, etc.
- `## Variations` — one code block per process type (NATIVE_PLSQL, NATIVE_FORM_DML, NATIVE_FORM_FETCH, NATIVE_INVOKE_API, NATIVE_CLOSE_WINDOW, NATIVE_RESET_PAGINATION, NATIVE_SEND_EMAIL)
- `## Parameter Value Catalog` — all observed values per parameter
- `## Relationships` — Parent: page | Depends on: buttons (for p_process_when_button_id), regions (for p_process_region_id)

Use real code blocks from examples with anonymized IDs (replace literal IDs with descriptive comments).

- [ ] **Step 4: Validate pattern file**

Read the written file and verify:
- All 7+ process type variations have code blocks
- Parameter tables have no empty cells
- All parameter values in the catalog match what grep found
- Code blocks are valid SQL/PL/SQL syntax

- [ ] **Step 5: Commit**

```bash
git add .claude/skills/apex/global-patterns/page_process.md
git commit -m "feat: add page_process global pattern (7 process types)"
```

---

## Task 3: Create page_validation.md pattern

**Files:**
- Create: `.claude/skills/apex/global-patterns/page_validation.md`

**Depends on:** Task 1

- [ ] **Step 1: Extract representative validation examples**

```bash
cd /Users/oleksii/Code/apex-component-modifier/examples
grep -l "create_page_validation" f*/application/pages/*.sql | head -20
```

Read 6-8 files covering: NOT_NULL, PLSQL_EXPRESSION, FUNC_BODY_RETURNING_BOOLEAN, FUNC_BODY_RETURNING_ERR_TEXT, SQL_EXPRESSION, ITEM_REQUIRED, ITEM_MATCHES_REGULAR_EXPRESSION.

- [ ] **Step 2: Extract parameter value catalog**

```bash
grep -A 20 "create_page_validation" f*/application/pages/*.sql | grep "p_validation_type=>" | sed "s/.*p_validation_type=>'//;s/'.*//" | sort | uniq -c | sort -rn
grep -A 20 "create_page_validation" f*/application/pages/*.sql | grep "p_validation_scope=>" | sed "s/.*p_validation_scope=>'//;s/'.*//" | sort | uniq -c | sort -rn
```

Repeat for: `p_validation_type`, `p_validation_scope`, `p_error_display_location`, `p_display_when_type`.

- [ ] **Step 3: Write page_validation.md**

Structure:
- `# Component: Page Validation`
- `## API Calls` — `wwv_flow_imp_page.create_page_validation`
- `## Required Parameters` — p_id, p_validation_name, p_validation_sequence, p_validation_type
- `## Common Optional Parameters` — p_validation, p_validation_expression, p_validation2, p_error_message, p_error_display_location, p_associated_item, p_validation_scope
- `## Variations` — one code block per validation type (6+ types)
- `## Parameter Value Catalog`
- `## Relationships` — Parent: page | Associated: items (for inline error display)

- [ ] **Step 4: Validate and commit**

```bash
git add .claude/skills/apex/global-patterns/page_validation.md
git commit -m "feat: add page_validation global pattern (6+ validation types)"
```

---

## Task 4: Create page_computation.md pattern

**Files:**
- Create: `.claude/skills/apex/global-patterns/page_computation.md`

**Depends on:** Task 1

- [ ] **Step 1: Extract representative computation examples**

```bash
cd /Users/oleksii/Code/apex-component-modifier/examples
grep -l "create_page_computation" f*/application/pages/*.sql | head -15
```

Read 5-6 files covering: static value, PL/SQL expression, PL/SQL function body, SQL query, item value.

- [ ] **Step 2: Extract parameter value catalog**

```bash
grep -A 15 "create_page_computation" f*/application/pages/*.sql | grep "p_computation_type=>" | sed "s/.*p_computation_type=>'//;s/'.*//" | sort | uniq -c | sort -rn
grep -A 15 "create_page_computation" f*/application/pages/*.sql | grep "p_compute_when=>\|p_computation_point=>" | sort | uniq -c | sort -rn
```

- [ ] **Step 3: Write page_computation.md**

Structure:
- `# Component: Page Computation`
- `## API Calls` — `wwv_flow_imp_page.create_page_computation`
- `## Required Parameters` — p_id, p_computation_sequence, p_computation_item, p_computation_point, p_computation_type
- `## Common Optional Parameters` — p_computation_processed, p_computation, p_compute_when_type, p_compute_when
- `## Variations` — one code block per computation type
- `## Parameter Value Catalog`
- `## Relationships` — Parent: page | Target: items (p_computation_item)

- [ ] **Step 4: Validate and commit**

```bash
git add .claude/skills/apex/global-patterns/page_computation.md
git commit -m "feat: add page_computation global pattern"
```

---

## Task 5: Create page_branch.md pattern

**Files:**
- Create: `.claude/skills/apex/global-patterns/page_branch.md`

**Depends on:** Task 1

- [ ] **Step 1: Extract representative branch examples**

```bash
cd /Users/oleksii/Code/apex-component-modifier/examples
grep -l "create_page_branch" f*/application/pages/*.sql | head -15
```

Read 5-6 files covering: REDIRECT_URL, BRANCH_TO_PAGE_ACCEPT, BRANCH_TO_PAGE_IDENT, PLSQL_PROCEDURE.

- [ ] **Step 2: Extract parameter value catalog**

```bash
grep -A 20 "create_page_branch" f*/application/pages/*.sql | grep "p_branch_type=>" | sed "s/.*p_branch_type=>'//;s/'.*//" | sort | uniq -c | sort -rn
grep -A 20 "create_page_branch" f*/application/pages/*.sql | grep "p_branch_point=>" | sed "s/.*p_branch_point=>'//;s/'.*//" | sort | uniq -c | sort -rn
```

- [ ] **Step 3: Write page_branch.md**

Structure:
- `# Component: Page Branch`
- `## API Calls` — `wwv_flow_imp_page.create_page_branch`
- `## Required Parameters` — p_id, p_branch_name, p_branch_sequence, p_branch_point, p_branch_type
- `## Common Optional Parameters` — p_branch_action, p_branch_when_button_id, p_branch_condition_type, p_branch_condition
- `## Variations` — one code block per branch type
- `## Parameter Value Catalog`
- `## Relationships` — Parent: page | Depends on: buttons (for p_branch_when_button_id)

- [ ] **Step 4: Validate and commit**

```bash
git add .claude/skills/apex/global-patterns/page_branch.md
git commit -m "feat: add page_branch global pattern"
```

---

## Task 6: Create navigation.md pattern

**Files:**
- Create: `.claude/skills/apex/global-patterns/navigation.md`

**Depends on:** Task 1

- [ ] **Step 1: Extract representative navigation examples**

```bash
cd /Users/oleksii/Code/apex-component-modifier/examples
grep -rl "create_list\b" f*/application/shared_components/navigation/*.sql | head -10
grep -rl "create_menu" f*/application/shared_components/navigation/*.sql | head -10
grep -rl "create_list_item" f*/application/shared_components/navigation/*.sql | head -10
```

Read 6-8 files covering: static lists, navigation menus, breadcrumb menus, list items with hierarchy.

- [ ] **Step 2: Extract parameter value catalog**

```bash
grep -A 15 "create_list(" f*/application/shared_components/navigation/*.sql | grep "p_list_type=>" | sort | uniq -c | sort -rn
grep -A 20 "create_list_item" f*/application/shared_components/navigation/*.sql | grep "p_list_item_type=>\|p_list_item_display_sequence" | sort | uniq -c | sort -rn
```

- [ ] **Step 3: Write navigation.md**

Structure:
- `# Component: Navigation`
- `## API Calls (ordered)` — `create_list`, `create_list_item`, `create_menu`, `create_menu_option`, `create_icon_bar_item`
- `## Lists` — required params, common optional params, variations (static, SQL)
- `## List Items` — required params, hierarchy via p_parent_list_item_id, conditions, authorization
- `## Menus & Breadcrumbs` — `create_menu`, `create_menu_option` patterns
- `## Parameter Value Catalog`
- `## Relationships` — Lists used by: regions (NATIVE_LIST), navigation bars | Menus used by: breadcrumb regions

- [ ] **Step 4: Validate and commit**

```bash
git add .claude/skills/apex/global-patterns/navigation.md
git commit -m "feat: add navigation global pattern (lists, menus, breadcrumbs)"
```

---

## Task 7: Create lov.md pattern

**Files:**
- Create: `.claude/skills/apex/global-patterns/lov.md`

**Depends on:** Task 1

- [ ] **Step 1: Extract representative LOV examples**

```bash
cd /Users/oleksii/Code/apex-component-modifier/examples
grep -rl "create_list_of_values\b" f*/application/shared_components/user_interface/lovs/*.sql | head -10
grep -rl "create_static_lov_data" f*/application/shared_components/user_interface/lovs/*.sql | head -10
```

Read 6-8 files covering: static LOVs (with `create_static_lov_data`), dynamic SQL LOVs, LOVs with extra columns (`create_list_of_values_cols`).

- [ ] **Step 2: Extract parameter value catalog**

```bash
grep -A 10 "create_list_of_values(" f*/application/shared_components/user_interface/lovs/*.sql | grep "p_lov_type=>\|p_source_type=>" | sort | uniq -c | sort -rn
```

- [ ] **Step 3: Write lov.md**

Structure:
- `# Component: List of Values (LOV)`
- `## API Calls (ordered)` — `create_list_of_values`, `create_list_of_values_cols`, `create_static_lov_data`
- `## Required Parameters` — p_id, p_lov_name, p_source_type
- `## Common Optional Parameters` — p_lov_query, p_return_column_name, p_display_column_name
- `## Variations` — Static LOV, Dynamic SQL LOV, LOV with extra columns, cascading LOV
- `## Parameter Value Catalog`
- `## Relationships` — Used by: page items (p_lov_id), IG columns, IR filter LOVs

- [ ] **Step 4: Validate and commit**

```bash
git add .claude/skills/apex/global-patterns/lov.md
git commit -m "feat: add LOV global pattern (static, dynamic, extra columns)"
```

---

## Task 8: Create authorization.md pattern

**Files:**
- Create: `.claude/skills/apex/global-patterns/authorization.md`

**Depends on:** Task 1

- [ ] **Step 1: Extract representative authorization examples**

```bash
cd /Users/oleksii/Code/apex-component-modifier/examples
grep -rl "create_security_scheme" f*/application/shared_components/security/*.sql | head -10
grep -rl "create_acl_role" f*/application/shared_components/security/*.sql | head -10
```

Read 5-6 files covering different scheme types.

- [ ] **Step 2: Extract parameter value catalog**

```bash
grep -A 15 "create_security_scheme" f*/application/shared_components/security/*.sql | grep "p_scheme_type=>" | sort | uniq -c | sort -rn
grep -A 15 "create_security_scheme" f*/application/shared_components/security/*.sql | grep "p_caching=>" | sort | uniq -c | sort -rn
```

- [ ] **Step 3: Write authorization.md**

Structure:
- `# Component: Authorization Schemes`
- `## API Calls` — `create_security_scheme`, `create_acl_role`
- `## Required Parameters` — p_id, p_name, p_scheme_type
- `## Common Optional Parameters` — p_attribute_01 (varies by type), p_error_message, p_caching, p_reference_id
- `## Variations` — PL/SQL function body, EXISTS SQL, Is In Role/Group, component availability
- `## Parameter Value Catalog`
- `## Relationships` — Used by: pages, regions, items, buttons, processes, list items, navigation

- [ ] **Step 4: Validate and commit**

```bash
git add .claude/skills/apex/global-patterns/authorization.md
git commit -m "feat: add authorization global pattern"
```

---

## Task 9: Create web_source.md pattern

**Files:**
- Create: `.claude/skills/apex/global-patterns/web_source.md`

**Depends on:** Task 1

- [ ] **Step 1: Extract representative web source examples**

```bash
cd /Users/oleksii/Code/apex-component-modifier/examples
grep -rl "create_web_source_module" f*/application/shared_components/web_sources/*.sql | head -10
grep -rl "create_data_profile" f*/application/shared_components/data_profiles/*.sql | head -10
```

Read 4-6 files covering: REST sources, with/without pagination, with data profiles.

- [ ] **Step 2: Extract parameter value catalog**

```bash
grep -A 20 "create_web_source_module" f*/application/shared_components/web_sources/*.sql | grep "p_web_source_type=>\|p_url_path_prefix=>" | sort | uniq -c | sort -rn
grep -A 15 "create_web_source_operation" f*/application/shared_components/web_sources/*.sql | grep "p_operation=>" | sort | uniq -c | sort -rn
```

- [ ] **Step 3: Write web_source.md**

Structure:
- `# Component: Web Source Modules`
- `## API Calls (ordered)` — `create_web_source_module`, `create_web_source_operation`, `create_web_source_param`, `create_web_source_comp_param`, `create_data_profile`, `create_data_profile_col`
- `## Module (required + optional params)`
- `## Operations` — GET/POST/PUT/DELETE patterns
- `## Parameters` — URL, header, query string parameter binding
- `## Data Profiles` — column mapping, data types
- `## Variations` — simple REST GET, CRUD REST, with authentication, with pagination
- `## Parameter Value Catalog`
- `## Relationships` — Used by: regions (p_location=>'WEB_SOURCE'), processes (NATIVE_WEB_SERVICE)

- [ ] **Step 4: Validate and commit**

```bash
git add .claude/skills/apex/global-patterns/web_source.md
git commit -m "feat: add web_source global pattern (REST, data profiles)"
```

---

## Task 10: Create automation.md pattern

**Files:**
- Create: `.claude/skills/apex/global-patterns/automation.md`

**Depends on:** Task 1

- [ ] **Step 1: Extract representative automation examples**

```bash
cd /Users/oleksii/Code/apex-component-modifier/examples
grep -rl "create_automation" f*/application/shared_components/automations/*.sql | head -10
```

Read 3-5 files covering: scheduled, on-demand, query-driven automations.

- [ ] **Step 2: Extract parameter value catalog**

```bash
grep -A 20 "create_automation(" f*/application/shared_components/automations/*.sql | grep "p_trigger_type=>\|p_polling_interval=>\|p_polling_status=>" | sort | uniq -c | sort -rn
grep -A 15 "create_automation_action" f*/application/shared_components/automations/*.sql | grep "p_action_type=>" | sort | uniq -c | sort -rn
```

- [ ] **Step 3: Write automation.md**

Structure:
- `# Component: Automations`
- `## API Calls (ordered)` — `create_automation`, `create_automation_action`
- `## Automation (required + optional params)` — trigger type, schedule, polling interval, source query
- `## Actions` — PL/SQL, send email, invoke API action types
- `## Variations` — scheduled polling, on-demand, query-driven with result columns
- `## Parameter Value Catalog`
- `## Relationships` — Standalone shared component | Actions reference: email templates, web sources

- [ ] **Step 4: Validate and commit**

```bash
git add .claude/skills/apex/global-patterns/automation.md
git commit -m "feat: add automation global pattern"
```

---

## Task 11: Create map_region.md pattern

**Files:**
- Create: `.claude/skills/apex/global-patterns/map_region.md`

**Depends on:** Task 1

- [ ] **Step 1: Extract representative map examples**

```bash
cd /Users/oleksii/Code/apex-component-modifier/examples
grep -l "create_map_region" f*/application/pages/*.sql | head -10
grep -l "create_map_region_layer" f*/application/pages/*.sql | head -10
```

Read 3-5 files covering: point layers, heat map layers, area layers.

- [ ] **Step 2: Extract parameter value catalog**

```bash
grep -A 30 "create_map_region_layer" f*/application/pages/*.sql | grep "p_layer_type=>\|p_display_as=>" | sort | uniq -c | sort -rn
```

- [ ] **Step 3: Write map_region.md**

Structure:
- `# Component: Map Region`
- `## API Calls (ordered)` — `create_map_region`, `create_map_region_layer`
- `## Map Region (required + optional params)` — background, height, zoom, center
- `## Layers` — type, source query, geometry column, tooltip, styling
- `## Variations` — point layer, heat map, area/line, multiple layers
- `## Parameter Value Catalog`
- `## Relationships` — Parent: page (via create_page_plug with NATIVE_MAP_REGION) | Layers: child of map region

- [ ] **Step 4: Validate and commit**

```bash
git add .claude/skills/apex/global-patterns/map_region.md
git commit -m "feat: add map_region global pattern"
```

---

## Task 12: Revise existing patterns — Cards (5 files)

**Files:**
- Modify: `.claude/skills/apex/global-patterns/cards_region.md`
- Modify: `.claude/skills/apex/global-patterns/card_component.md`
- Modify: `.claude/skills/apex/global-patterns/card_media.md`
- Modify: `.claude/skills/apex/global-patterns/card_actions.md`
- Modify: `.claude/skills/apex/global-patterns/card_icons.md`

**Depends on:** Task 1

- [ ] **Step 1: Find all card instances in examples**

```bash
cd /Users/oleksii/Code/apex-component-modifier/examples
grep -l "create_card\b" f*/application/pages/*.sql | wc -l
grep -l "create_card_action" f*/application/pages/*.sql | wc -l
```

- [ ] **Step 2: Read current pattern files**

Read all 5 card pattern files completely.

- [ ] **Step 3: Extract parameter values not in current patterns**

For each card API call, extract all parameter names and values from examples, compare against what the current pattern files document. Add any missing parameters or values.

```bash
grep -A 40 "create_card(" f*/application/pages/*.sql | grep "p_[a-z_]*=>" | sed 's/.*\(p_[a-z_]*\)=>.*/\1/' | sort -u
```

Compare this list against parameters documented in `card_component.md`.

- [ ] **Step 4: Add Parameter Value Catalog section to each file**

If not already present, add a `## Parameter Value Catalog` section to each card pattern file with all observed values from examples.

- [ ] **Step 5: Add missing variations**

If examples show card configurations not represented in the current patterns (e.g., different card layouts, media types, action configurations), add them as new variation sections.

- [ ] **Step 6: Validate and commit**

```bash
git add .claude/skills/apex/global-patterns/cards_region.md .claude/skills/apex/global-patterns/card_component.md .claude/skills/apex/global-patterns/card_media.md .claude/skills/apex/global-patterns/card_actions.md .claude/skills/apex/global-patterns/card_icons.md
git commit -m "fix: revise card patterns with real example data"
```

---

## Task 13: Revise existing patterns — IR + IG

**Files:**
- Modify: `.claude/skills/apex/global-patterns/interactive_report.md`
- Modify: `.claude/skills/apex/global-patterns/interactive_grid.md`

**Depends on:** Task 1

- [ ] **Step 1: Find all IR/IG instances in examples**

```bash
cd /Users/oleksii/Code/apex-component-modifier/examples
grep -l "create_worksheet\b" f*/application/pages/*.sql | wc -l
grep -l "create_interactive_grid" f*/application/pages/*.sql | wc -l
```

- [ ] **Step 2: Read current pattern files**

Read both IR and IG pattern files completely.

- [ ] **Step 3: Extract missing parameters and values**

For IR — check `create_worksheet`, `create_worksheet_column`, `create_worksheet_rpt`, `create_worksheet_condition`, `create_worksheet_computation`, `create_worksheet_group_by`, `create_worksheet_pivot`, `create_worksheet_col_group`.

For IG — check `create_interactive_grid`, `create_ig_report`, `create_ig_report_column`, `create_ig_report_view`, `create_ig_report_aggregate`, `create_ig_report_chart_col`, `create_region_column`, `create_region_column_group`.

```bash
grep -A 30 "create_worksheet_column" f*/application/pages/*.sql | grep "p_[a-z_]*=>" | sed 's/.*\(p_[a-z_]*\)=>.*/\1/' | sort -u
```

- [ ] **Step 4: Add Parameter Value Catalog and missing variations**

Add `## Parameter Value Catalog` sections. Add worksheet computation, pivot, group-by, and col-group examples if missing.

- [ ] **Step 5: Validate and commit**

```bash
git add .claude/skills/apex/global-patterns/interactive_report.md .claude/skills/apex/global-patterns/interactive_grid.md
git commit -m "fix: revise IR + IG patterns with real example data"
```

---

## Task 14: Revise existing patterns — Form, Classic Report, JET Chart, DAs, Faceted Search

**Files:**
- Modify: `.claude/skills/apex/global-patterns/form_region.md`
- Modify: `.claude/skills/apex/global-patterns/classic_report.md`
- Modify: `.claude/skills/apex/global-patterns/jet_chart.md`
- Modify: `.claude/skills/apex/global-patterns/dynamic_actions.md`
- Modify: `.claude/skills/apex/global-patterns/faceted_search.md`

**Depends on:** Task 1

- [ ] **Step 1: Read all 5 current pattern files**

Read each file completely to understand current coverage.

- [ ] **Step 2: For each file, extract missing parameters from examples**

For each component type, grep examples for the relevant API calls. Extract all parameter names and values. Compare against documented parameters.

Form: `create_page_plug` (NATIVE_FORM), `create_page_item`, `create_page_process` (NATIVE_FORM_DML, NATIVE_FORM_FETCH)
Classic Report: `create_page_plug` (NATIVE_SQL_REPORT), `create_report_columns`, `create_report_region`
JET Chart: `create_jet_chart`, `create_jet_chart_axis`, `create_jet_chart_series`
DAs: `create_page_da_event`, `create_page_da_action`
Faceted Search: `create_page_plug` (NATIVE_FACETED_SEARCH), `create_search_region_source`

- [ ] **Step 3: Add Parameter Value Catalog to each file**

Add observed values from all 29 example apps.

- [ ] **Step 4: Add missing variations**

Add code blocks for configurations not currently documented.

- [ ] **Step 5: Validate and commit**

```bash
git add .claude/skills/apex/global-patterns/form_region.md .claude/skills/apex/global-patterns/classic_report.md .claude/skills/apex/global-patterns/jet_chart.md .claude/skills/apex/global-patterns/dynamic_actions.md .claude/skills/apex/global-patterns/faceted_search.md
git commit -m "fix: revise form, classic report, chart, DA, faceted search patterns"
```

---

## Task 15: Update valid_values.md

**Files:**
- Modify: `.claude/skills/apex/references/apex_imp/valid_values.md`

**Depends on:** Task 1

- [ ] **Step 1: Read current valid_values.md**

Read the complete file.

- [ ] **Step 2: Extract all enum values from examples**

For every enum parameter in valid_values.md, grep the examples for all distinct values:

```bash
cd /Users/oleksii/Code/apex-component-modifier/examples
# Region types
grep -rh "p_plug_source_type=>" --include="*.sql" | sed "s/.*p_plug_source_type=>'//;s/'.*//" | sort -u
# Item types
grep -rh "p_display_as=>" --include="*.sql" | sed "s/.*p_display_as=>'//;s/'.*//" | sort -u
# Process types
grep -rh "p_process_type=>" --include="*.sql" | sed "s/.*p_process_type=>'//;s/'.*//" | sort -u
# DA action types
grep -rh ",p_action=>'NATIVE_" --include="*.sql" | sed "s/.*,p_action=>'//;s/'.*//" | sort -u
```

Repeat for ALL enum sections in valid_values.md.

- [ ] **Step 3: Diff and update**

For each enum section:
1. Compare documented values vs observed values
2. Add any values found in examples but not documented
3. Add a note next to values documented but never observed: `(not observed in examples)`
4. Keep existing documentation notes intact

- [ ] **Step 4: Validate completeness**

Verify every section was checked. Count values before vs after.

- [ ] **Step 5: Commit**

```bash
git add .claude/skills/apex/references/apex_imp/valid_values.md
git commit -m "fix: validate valid_values.md against 29 example apps"
```

---

## Task 16: Update imp_page.md

**Files:**
- Modify: `.claude/skills/apex/references/apex_imp/imp_page.md`

**Depends on:** Task 1

- [ ] **Step 1: Read current imp_page.md**

Read the complete file.

- [ ] **Step 2: Extract all page API signatures from examples**

For each `wwv_flow_imp_page.*` API call, extract all parameter names used across all examples:

```bash
cd /Users/oleksii/Code/apex-component-modifier/examples
for api in create_page create_page_plug create_page_item create_page_button create_page_process create_page_validation create_page_computation create_page_branch create_page_da_event create_page_da_action create_worksheet create_worksheet_column create_worksheet_rpt create_interactive_grid create_ig_report create_ig_report_column create_jet_chart create_jet_chart_axis create_jet_chart_series create_map_region create_map_region_layer create_card create_card_action create_report_columns create_region_column create_region_column_group create_component_action create_page_group create_search_region_source; do
  echo "=== $api ==="
  grep -A 60 "\\.$api(" f*/application/pages/*.sql | grep "p_[a-z_]*=>" | sed 's/.*\(p_[a-z_]*\)=>.*/\1/' | sort -u
done
```

- [ ] **Step 3: Compare against documented signatures**

For each API call documented in imp_page.md, identify:
- Parameters in examples but not documented → ADD
- Parameters documented but never observed → flag with note
- Default values that differ from documentation → CORRECT

- [ ] **Step 4: Add undocumented API calls**

Check if any `wwv_flow_imp_page.*` calls found in examples are missing from imp_page.md entirely (e.g., `create_page_group`, `create_page_meta_tag`, `create_comp_menu_entry`, `create_search_region_source`). Add them.

- [ ] **Step 5: Validate and commit**

```bash
git add .claude/skills/apex/references/apex_imp/imp_page.md
git commit -m "fix: validate imp_page.md API signatures against 29 example apps"
```

---

## Task 17: Update imp_shared.md

**Files:**
- Modify: `.claude/skills/apex/references/apex_imp/imp_shared.md`

**Depends on:** Task 1

- [ ] **Step 1: Read current imp_shared.md**

Read the complete file.

- [ ] **Step 2: Extract all shared API signatures from examples**

```bash
cd /Users/oleksii/Code/apex-component-modifier/examples
for api in create_list create_list_item create_list_of_values create_list_of_values_cols create_static_lov_data create_security_scheme create_acl_role create_authentication create_build_option create_app_setting create_plugin create_plugin_attribute create_plugin_event create_plugin_file create_plugin_setting create_plugin_std_attribute create_plugin_act_position create_plugin_act_template create_plugin_attr_group create_plugin_attr_value create_template create_template_option create_template_opt_group create_plug_template create_row_template create_web_source_module create_web_source_operation create_web_source_param create_web_source_comp_param create_data_profile create_data_profile_col create_automation create_automation_action create_workflow create_workflow_version create_workflow_activity create_workflow_transition create_workflow_variable create_workflow_participant create_workflow_comp_param create_email_template create_search_config create_task_def create_task_def_param create_task_def_action create_task_def_participant create_task_def_comp_param create_load_table create_load_table_lookup create_load_table_rule create_app_static_file create_shortcut create_message create_menu create_menu_option create_icon_bar_item create_flow_item create_flow_process create_flow_computation create_report_layout create_pwa_shortcut create_pwa_screenshot create_ai_config create_theme create_theme_style create_theme_file create_user_interface create_install create_install_script create_install_object create_install_check create_page_tmpl_display_point create_plug_tmpl_display_point create_invokeapi_comp_param; do
  count=$(grep -rl "\\.$api(" f*/application/shared_components/ 2>/dev/null | wc -l)
  if [ "$count" -gt 0 ]; then
    echo "=== $api ($count files) ==="
    grep -A 40 "\\.$api(" f*/application/shared_components/*.sql f*/application/shared_components/**/*.sql 2>/dev/null | grep "p_[a-z_]*=>" | sed 's/.*\(p_[a-z_]*\)=>.*/\1/' | sort -u
  fi
done
```

- [ ] **Step 3: Compare against documented signatures**

Same approach as Task 16: identify missing params, flag unobserved params, correct defaults.

- [ ] **Step 4: Add undocumented API calls**

Focus on APIs with significant usage: plugins (12+ calls), web sources (4 calls), automations (2 calls), workflows (6 calls), data loads (3 calls), templates.

- [ ] **Step 5: Validate and commit**

```bash
git add .claude/skills/apex/references/apex_imp/imp_shared.md
git commit -m "fix: validate imp_shared.md API signatures against 29 example apps"
```

---

## Task 18: Update SKILL.md pattern loading references

**Files:**
- Modify: `.claude/skills/apex/SKILL.md`

- [ ] **Step 1: Read current SKILL.md**

Read the complete file.

- [ ] **Step 2: Update step 4 (Load documentation and patterns)**

Add the new pattern files to the loading list in section `### 4) Load documentation and patterns`, item 5 (`global-patterns/`):

Add these mappings:
- Process -> `page_process.md`
- Validation -> `page_validation.md`
- Computation -> `page_computation.md`
- Branch -> `page_branch.md`
- Navigation (lists/menus/breadcrumbs) -> `navigation.md`
- LOV -> `lov.md`
- Authorization -> `authorization.md`
- Web Source -> `web_source.md`
- Automation -> `automation.md`
- Map -> `map_region.md`

- [ ] **Step 3: Validate and commit**

```bash
git add .claude/skills/apex/SKILL.md
git commit -m "fix: update SKILL.md to reference new global patterns"
```

---

## Task 19: Final validation pass

- [ ] **Step 1: Verify all new files exist**

```bash
ls -la .claude/skills/apex/global-patterns/*.md | wc -l
```

Expected: 22 files (12 existing + 10 new).

- [ ] **Step 2: Verify catalog.json is valid**

```bash
python3 -c "import json; c=json.load(open('examples/catalog.json')); print(f'{len(c[\"apps\"])} apps, {len(c[\"api_calls\"])} API calls')"
```

Expected: 29 apps, 90+ API calls.

- [ ] **Step 3: Spot-check pattern quality**

Read 3 new pattern files and 2 revised pattern files. Verify:
- Code blocks contain real example syntax
- Parameter tables are complete
- Parameter value catalogs have actual observed values
- No placeholder text or TODOs

- [ ] **Step 4: Final commit**

```bash
git add -A
git status
# If any unstaged changes remain, add them
git commit -m "chore: final validation — apex skill improvement complete"
```
