# Research-Based Improvements Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Implement the 10 improvements from `research.md` to make the APEX Component Modifier skill more reliable, discoverable, and user-friendly.

**Architecture:** All changes are to skill metadata, documentation, and tooling files. No runtime code changes — the skill is a Claude Code Skill composed of markdown files. Changes improve triggering, progressive disclosure, error recovery, validation automation, and developer experience.

**Tech Stack:** Markdown, Bash (validation script), Claude Code Skill system

---

## Task 1: Improve skill description for better triggering

**Files:**
- Modify: `.claude/skills/apex-component-modifier/SKILL.md:1-7` (frontmatter)

**Step 1: Edit the SKILL.md frontmatter description**

Replace the current `description` field in the YAML frontmatter:

```yaml
---
name: apex-component-modifier
description: >-
  Export/patch/import Oracle APEX components (pages/shared components) via SQLcl over MCP.
  Uses local apex_imp package docs stored in this skill directory to plan safe modifications,
  applies required DB changes, patches exported component files, then re-imports through SQLcl.
  Use whenever the user asks to add, modify, remove, inspect, or describe any Oracle APEX page
  component such as regions, items, buttons, processes, dynamic actions, validations, computations,
  branches, LOVs, or authorization schemes. Also use when the user mentions APEX pages, APEX
  components, APEX export/import, APEX patching, SQLcl APEX commands, or wants to change anything
  in an APEX application. Covers page items, interactive reports, interactive grids, charts, maps,
  cards, lists, templates, build options, authentication, and static files.
argument-hint: "[conn|env] [app-id] [component] -- <change request>"
disable-model-invocation: false
allowed-tools: Read, Write, Edit, Grep, Glob, Bash(git *), MCP
---
```

Note: also removes `Bash(python *)` from allowed-tools since no Python scripts exist in the skill yet (will be added in Task 5).

**Step 2: Verify the frontmatter parses correctly**

Run: `head -15 .claude/skills/apex-component-modifier/SKILL.md`
Expected: valid YAML frontmatter with the expanded description

**Step 3: Commit**

```bash
git add .claude/skills/apex-component-modifier/SKILL.md
git commit -m "feat: expand skill description for better Claude triggering"
```

---

## Task 2: Add error recovery and rollback strategy

**Files:**
- Modify: `.claude/skills/apex-component-modifier/SKILL.md` (Error handling playbook section, ~line 154-160)

**Step 1: Replace the "Error handling playbook" section in SKILL.md**

Find the current section (3 bullet points at the end) and replace with:

```markdown
## Error handling playbook

### Before any changes — create a baseline
- **Git baseline (mandatory if in a git repo):**
  ```
  git add -A && git commit -m "baseline: pre-modification snapshot"
  ```
- Record the current APEX component state by exporting before changes.

### Recovery procedures

| Failure | Recovery |
|---------|----------|
| **Export missing files** | Verify `-dir`, permissions, correct APP_ID, and connection/workspace context. |
| **DB script fails** | Fix the script. If partially applied, reverse with `DROP`/`ALTER` or restore from version control. Re-run after fix. |
| **Patch produces invalid file** | `git checkout -- <file>` to restore the exported original. Re-patch from clean state. |
| **Import fails — ID collision** | Revisit `apex_imp` ID/offset guidance. Ensure `apex_application_install` context is correct. Regenerate IDs if needed. |
| **Import fails — compilation error** | Check `show errors` via SQLcl MCP. Fix DB objects first, then re-import. |
| **Import succeeds but component is broken** | Re-import the original baseline export: `@<workdir>/f<APP_ID>/install_component.sql` from the pre-change export. |
| **Unknown state after failed import** | Re-export the component from APEX (it still holds the last successful import). Diff against your patched file to see what was applied. |

### Logging
- Save all SQLcl import output to a log file in the working directory (e.g., `import_log.txt`).
- On failure, present the log to the user before attempting recovery.

### Rollback decision tree
1. Is the git baseline available? → `git checkout -- <files>` and re-import original.
2. No git? → Re-export the same component from APEX (APEX retains the pre-import state on failure).
3. DB changes need reversal? → Run explicit `DROP`/`ALTER` scripts (idempotent).
```

**Step 2: Verify the section reads correctly**

Run: `grep -n "Error handling" .claude/skills/apex-component-modifier/SKILL.md`
Expected: section header found with new content

**Step 3: Commit**

```bash
git add .claude/skills/apex-component-modifier/SKILL.md
git commit -m "feat: add detailed error recovery and rollback strategy"
```

---

## Task 3: Add TOC to large reference files and improve progressive disclosure

This task has three parts: add TOC to `imp_page.md` (586 lines), `apex_imp.md` (426 lines), and update SKILL.md step 4 with conditional reading guidance.

**Files:**
- Modify: `.claude/skills/apex-component-modifier/references/apex_imp/imp_page.md:1-5` (add TOC after line 5)
- Modify: `.claude/skills/apex-component-modifier/references/apex_imp/apex_imp.md:1-5` (add TOC after line 5)
- Modify: `.claude/skills/apex-component-modifier/SKILL.md:98-105` (step 4)

**Step 1: Add TOC to imp_page.md**

After the title line and initial description (before `---`), insert:

```markdown
## Table of Contents

- [Page](#page) — `create_page`
- [Regions](#regions-plugs) — `create_page_plug`, region source, chart series
- [Page Items](#page-items) — `create_page_item`, item attributes
- [Buttons](#buttons) — `create_page_button`
- [Processes](#processes) — `create_page_process`
- [Dynamic Actions](#dynamic-actions) — `create_page_da_event`, `create_page_da_action`
- [Validations](#validations) — `create_page_validation`
- [Computations](#computations) — `create_page_computation`
- [Branches](#branches) — `create_page_branch`
- [Interactive Reports (IR)](#interactive-reports) — `create_worksheet`, `create_worksheet_column`
- [Interactive Grids (IG)](#interactive-grids) — `create_ig`, `create_ig_report`, `create_ig_report_column`
- [Charts](#charts) — `create_jet_chart`, `create_jet_chart_series`, `create_jet_chart_axis`
- [Maps](#maps) — `create_map_region`, `create_map_region_layer`
- [Cards](#cards) — `create_card`
```

Read the actual file headings first to match the TOC anchors to real section names.

**Step 2: Add TOC to apex_imp.md**

After the title and initial table, insert a TOC matching its actual headings. Read the file first to get exact section names.

**Step 3: Update SKILL.md step 4 with conditional reading guidance**

Replace step 4 content:

```markdown
### 4) Load local `apex_imp` documentation (progressive disclosure)
1. **Always read first:** `references/apex_imp/README.md` (quick reference index).
2. **Always read:** `references/apex_imp/apex_imp.md` (core import engine, ID system, file format).
3. **Read conditionally based on the component type:**
   - Page items, regions, buttons, DAs, processes, IR, IG, charts, maps, cards → read `references/apex_imp/imp_page.md`
   - LOVs, authorization schemes, authentication, lists, templates, build options, static files → read `references/apex_imp/imp_shared.md`
4. **Always read:** `tools/patching_guidelines.md` for patch strategy rules.
5. **Always read:** `references/apex_imp/valid_values.md` for parameter choices.
6. **Read if importing to a different environment:** `references/apex_imp/app_install.md`.
7. **Read if needing export API details:** `references/apex_imp/export_api.md`.
```

**Step 4: Commit**

```bash
git add .claude/skills/apex-component-modifier/references/apex_imp/imp_page.md \
        .claude/skills/apex-component-modifier/references/apex_imp/apex_imp.md \
        .claude/skills/apex-component-modifier/SKILL.md
git commit -m "feat: add TOC to large ref files and improve progressive disclosure in step 4"
```

---

## Task 4: Add a real end-to-end patching example

**Files:**
- Create: `.claude/skills/apex-component-modifier/references/examples/add_select_list_item.md`

**Step 1: Create the examples directory and file**

```bash
mkdir -p .claude/skills/apex-component-modifier/references/examples
```

**Step 2: Write the example file**

The file should show a complete flow: a minimal "before" page export snippet, the patching diff, and the "after" result. Focus on the most common operation — adding a new page item (select list) to an existing region.

Content:

```markdown
# Example: Add a Select List Item to a Page

Complete patching flow from export to import for adding a new `P10_STATUS` select list item.

---

## Before (original export snippet from `page_00010.sql`)

The page has one region ("Details", ID `4937364850118364`) with one existing item.

```sql
begin
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(4937365012648365)
,p_name=>'P10_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(4937364850118364)
,p_item_source_plug_id=>wwv_flow_imp.id(4937364850118364)
,p_prompt=>'Name'
,p_source=>'NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cMaxlength=>255
,p_field_template=>wwv_flow_imp.id(1859094942498559411)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'Y'
,p_protection_level=>'S'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
);
end;
/
```

## Patch (unified diff)

```diff
--- a/f113/application/pages/page_00010.sql
+++ b/f113/application/pages/page_00010.sql
@@ manifest section — add new item to the list @@
+--   ...   P10_STATUS
@@ after the P10_NAME item block @@
+begin
+wwv_flow_imp_page.create_page_item(
+ p_id=>wwv_flow_imp.id(4937365100000001)
+,p_name=>'P10_STATUS'
+,p_source_data_type=>'VARCHAR2'
+,p_item_sequence=>20
+,p_item_plug_id=>wwv_flow_imp.id(4937364850118364)
+,p_item_source_plug_id=>wwv_flow_imp.id(4937364850118364)
+,p_prompt=>'Status'
+,p_source=>'STATUS'
+,p_source_type=>'REGION_SOURCE_COLUMN'
+,p_display_as=>'NATIVE_SELECT_LIST'
+,p_named_lov=>'STATUS_LOV'
+,p_lov_display_null=>'YES'
+,p_lov_null_text=>'- Select -'
+,p_cHeight=>1
+,p_field_template=>wwv_flow_imp.id(1859094942498559411)
+,p_item_template_options=>'#DEFAULT#'
+,p_is_persistent=>'Y'
+,p_protection_level=>'S'
+,p_attribute_01=>'NONE'
+,p_attribute_02=>'N'
+);
+end;
+/
```

## Key decisions in this patch

| Decision | Reasoning |
|----------|-----------|
| ID `4937365100000001` | Max existing ID was `4937365012648365`; picked a value above it |
| `p_item_sequence=>20` | Existing item is at 10; next logical gap |
| `p_item_plug_id` matches region | Same region `4937364850118364` as the existing item |
| `p_named_lov=>'STATUS_LOV'` | References LOV by name (string), not by ID |
| `p_field_template` reuses existing | Same label template as other items on the page |
| `p_display_as=>'NATIVE_SELECT_LIST'` | Valid value from `valid_values.md` |

## After import

Verify by re-exporting page 10 and confirming P10_STATUS appears with correct attributes.
```

**Step 3: Add reference to the examples in README.md**

In `references/apex_imp/README.md`, add a row to the Files table:

```
| `../examples/add_select_list_item.md` | Complete end-to-end patching example: adding a select list item |
```

**Step 4: Commit**

```bash
git add .claude/skills/apex-component-modifier/references/examples/
git add .claude/skills/apex-component-modifier/references/apex_imp/README.md
git commit -m "feat: add end-to-end patching example for adding a select list item"
```

---

## Task 5: Create a validation script

**Files:**
- Create: `.claude/skills/apex-component-modifier/tools/validate_export.sh`
- Modify: `.claude/skills/apex-component-modifier/SKILL.md` (step 7, mention running the script)

**Step 1: Write the validation script**

Create `tools/validate_export.sh` — a bash script that automates the checkable items from `templates/validation_checklist.md`:

```bash
#!/usr/bin/env bash
# validate_export.sh — Automated checks on patched APEX export files
# Usage: bash validate_export.sh <file.sql> [file2.sql ...]
#
# Checks:
#   1. begin/end balance
#   2. Every end; followed by /
#   3. set define off present
#   4. Unique IDs inside wwv_flow_imp.id(...)
#   5. Cross-reference IDs exist in file
#   6. wwv_flow_string.join syntax

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

errors=0
warnings=0

check_pass() { echo -e "  ${GREEN}PASS${NC} $1"; }
check_fail() { echo -e "  ${RED}FAIL${NC} $1"; ((errors++)); }
check_warn() { echo -e "  ${YELLOW}WARN${NC} $1"; ((warnings++)); }

for file in "$@"; do
  echo ""
  echo "=== Validating: $file ==="

  if [[ ! -f "$file" ]]; then
    check_fail "File not found: $file"
    continue
  fi

  # 1. begin/end balance
  begins=$(grep -c -w '^begin$' "$file" 2>/dev/null || echo 0)
  ends=$(grep -c '^end;$' "$file" 2>/dev/null || echo 0)
  if [[ "$begins" -eq "$ends" ]]; then
    check_pass "begin/end balanced ($begins blocks)"
  else
    check_fail "begin/end IMBALANCED: $begins begin vs $ends end;"
  fi

  # 2. Every end; should be followed by /
  terminators=$(grep -c '^/$' "$file" 2>/dev/null || echo 0)
  if [[ "$ends" -eq "$terminators" ]]; then
    check_pass "/ terminators match end; count ($terminators)"
  else
    check_warn "/ terminators ($terminators) != end; count ($ends) — check for orphaned or missing /"
  fi

  # 3. set define off
  if grep -q 'set define off' "$file"; then
    check_pass "set define off present"
  else
    check_warn "set define off not found (expected at top of file)"
  fi

  # 4. Unique IDs
  ids=$(grep -oP 'wwv_flow_imp\.id\(\K[0-9]+' "$file" | sort)
  unique_ids=$(echo "$ids" | sort -u)
  total=$(echo "$ids" | wc -w)
  unique_total=$(echo "$unique_ids" | wc -w)
  # IDs can repeat (cross-references), so check for IDs used in p_id that are duplicated
  pid_ids=$(grep -P 'p_id\s*=>\s*wwv_flow_imp\.id\(' "$file" | grep -oP 'wwv_flow_imp\.id\(\K[0-9]+' | sort)
  pid_dupes=$(echo "$pid_ids" | uniq -d)
  if [[ -z "$pid_dupes" ]]; then
    check_pass "All p_id values are unique ($unique_total distinct IDs, $total total references)"
  else
    check_fail "Duplicate p_id values: $pid_dupes"
  fi

  # 5. Cross-reference check: IDs used in non-p_id params should exist as p_id somewhere
  all_pid_ids=$(echo "$pid_ids" | sort -u)
  ref_ids=$(grep -P '(?<!p_id)\s*=>\s*wwv_flow_imp\.id\(' "$file" | grep -oP 'wwv_flow_imp\.id\(\K[0-9]+' | sort -u)
  missing=""
  for rid in $ref_ids; do
    if ! echo "$all_pid_ids" | grep -q "^${rid}$"; then
      # Could be a reference to a shared component (template, LOV) — warn, don't fail
      missing="$missing $rid"
    fi
  done
  if [[ -z "$missing" ]]; then
    check_pass "All cross-referenced IDs found in file (or are external shared components)"
  else
    check_warn "IDs referenced but not defined as p_id in this file (may be shared components):$missing"
  fi

  # 6. wwv_flow_string.join syntax check
  join_count=$(grep -c 'wwv_flow_string.join' "$file" 2>/dev/null || echo 0)
  if [[ "$join_count" -gt 0 ]]; then
    # Check that join has matching parens
    bad_joins=$(grep 'wwv_flow_string.join' "$file" | grep -v 'wwv_flow_t_varchar2' || true)
    if [[ -z "$bad_joins" ]]; then
      check_pass "wwv_flow_string.join calls use wwv_flow_t_varchar2 ($join_count occurrences)"
    else
      check_warn "wwv_flow_string.join without wwv_flow_t_varchar2 — check syntax"
    fi
  fi

done

echo ""
echo "=== Summary ==="
echo -e "Errors: ${RED}${errors}${NC}  Warnings: ${YELLOW}${warnings}${NC}"
if [[ "$errors" -gt 0 ]]; then
  exit 1
else
  exit 0
fi
```

**Step 3: Make script executable**

```bash
chmod +x .claude/skills/apex-component-modifier/tools/validate_export.sh
```

**Step 4: Add reference to SKILL.md step 7**

After the validation checklist mention in step 7, add:

```markdown
5. Run automated validation: `bash tools/validate_export.sh <patched_file.sql>`
```

**Step 5: Update allowed-tools in SKILL.md frontmatter**

Add `Bash(bash *)` to allowed-tools (if not already covered by existing Bash permissions), so the script can be run.

**Step 6: Commit**

```bash
git add .claude/skills/apex-component-modifier/tools/validate_export.sh
git add .claude/skills/apex-component-modifier/SKILL.md
git commit -m "feat: add automated validation script for patched export files"
```

---

## Task 6: Add APEX version compatibility note

**Files:**
- Modify: `.claude/skills/apex-component-modifier/references/apex_imp/README.md` (add compatibility section)

**Step 1: Add version compatibility section to README.md**

After the "Key facts" section, add:

```markdown
## Version Compatibility

This documentation is based on **APEX 24.2** (`APEX_240200`). Key compatibility notes:

| Feature / API | Introduced In | Notes |
|---------------|---------------|-------|
| `wwv_flow_imp_page` / `wwv_flow_imp_shared` | APEX 21.2 | Replaced frozen `wwv_flow_imp` for new components |
| `apex_string` (public synonym) | APEX 5.1 | Internal: `wwv_flow_string` |
| `apex_export.get_application` with `-split` | APEX 5.0 | SQLcl `apex export -split` |
| `-expComponents` flag | APEX 19.1+ (SQLcl 19.1) | Partial component export |
| AI Builder integration | APEX 24.1 | `p_ai_*` parameters in create procedures |
| Map regions | APEX 21.1 | `create_map_region`, `create_map_region_layer` |
| Cards regions | APEX 21.1 | `create_card` |

**If targeting APEX 23.x or earlier:**
- Ignore `p_ai_*` parameters (AI Builder) — they will be silently skipped on import.
- Map and Cards regions are available from 21.1+.
- Core patching workflow is identical; only parameter availability differs.
- When in doubt, export from the target APEX version first to see which parameters it produces.
```

**Step 2: Commit**

```bash
git add .claude/skills/apex-component-modifier/references/apex_imp/README.md
git commit -m "docs: add APEX version compatibility notes to reference README"
```

---

## Task 7: Clarify `.mcp_example.json` vs `.mcp.json` in README

**Files:**
- Delete: `.mcp_example.json` (redundant — identical to `.mcp.json`)
- Modify: `README.md` (add note about `.mcp.json`)

**Step 1: Check that `.mcp_example.json` and `.mcp.json` are identical**

```bash
diff .mcp_example.json .mcp.json
```

Expected: no differences (they are identical from the file reads).

**Step 2: Remove `.mcp_example.json`**

```bash
git rm .mcp_example.json
```

**Step 3: Add a note to README.md about `.mcp.json`**

After the "Add the SQLcl MCP server" section in README, add a note:

```markdown
> **Note:** This repo includes a `.mcp.json` file with the SQLcl MCP config. If you already have a `.mcp.json` in your project, merge the `sqlcl` entry into your existing config instead of overwriting it. The `${SQLCL_PATH:-sql}` syntax falls back to `sql` if `SQLCL_PATH` is not set.
```

**Step 4: Commit**

```bash
git add .mcp_example.json README.md
git commit -m "chore: remove redundant .mcp_example.json, clarify .mcp.json in README"
```

---

## Task 8: Add slash commands for common operations

**Files:**
- Create: `.claude/commands/apex-export.md`
- Create: `.claude/commands/apex-describe.md`

**Step 1: Create the commands directory**

```bash
mkdir -p .claude/commands
```

**Step 2: Create `apex-export.md`**

```markdown
---
description: Export an APEX component without modification (read-only)
argument-hint: "[PAGE:10 | LOV:<id> | ...]"
---

Export the specified APEX component using SQLcl MCP without making any changes.

1. Connect to the database using `$SQLCL_CONNECTION`.
2. Run `apex export -applicationid $APEX_APP_ID -split -expComponents "$ARGUMENTS"`.
3. Report what files were exported and their locations.

Do NOT modify any files. This is a read-only operation.
```

**Step 3: Create `apex-describe.md`**

```markdown
---
description: Describe an APEX page or component by reading its export
argument-hint: "[PAGE:10 | LOV:<id> | ...]"
---

Export and describe the specified APEX component.

1. Connect to the database using `$SQLCL_CONNECTION`.
2. Export the component: `apex export -applicationid $APEX_APP_ID -split -expComponents "$ARGUMENTS"`.
3. Read the exported file(s).
4. Provide a structured summary:
   - Component type and name
   - Regions (name, type, source)
   - Items (name, type, region)
   - Buttons, processes, dynamic actions, validations
   - Key settings and conditions

Do NOT modify any files. This is a read-only operation.
```

**Step 4: Commit**

```bash
git add .claude/commands/
git commit -m "feat: add /apex-export and /apex-describe slash commands"
```

---

## Task 9: Fix minor issues

**Files:**
- Modify: `.claude/skills/apex-component-modifier/SKILL.md:6` (allowed-tools)

**Step 1: Fix GitHub repo description typo**

This must be done manually via GitHub UI or API. The description says "Skill fo Claude code" — should be "Skill for Claude Code". Note this for the user.

```bash
# If gh CLI is available:
gh repo edit --description "Skill for Claude Code to export/patch/import Oracle APEX components via SQLcl MCP"
```

**Step 2: Commit any remaining changes**

```bash
git add -A
git commit -m "chore: fix minor issues (allowed-tools cleanup)"
```

---

## Task 10: Add evals scaffold

**Files:**
- Create: `.claude/skills/apex-component-modifier/evals/evals.json`

**Step 1: Create evals directory and file**

```bash
mkdir -p .claude/skills/apex-component-modifier/evals
```

**Step 2: Write evals.json with test prompts**

```json
[
  {
    "prompt": "Describe page 1 of my APEX app",
    "expected_skill": "apex-component-modifier",
    "expected_actions": ["export", "read"],
    "notes": "Should trigger the skill and export page 1 using default settings"
  },
  {
    "prompt": "Add a text field P5_EMAIL to page 5 in the Details region",
    "expected_skill": "apex-component-modifier",
    "expected_actions": ["export", "patch", "import"],
    "notes": "Full workflow: export page 5, add item, import back"
  },
  {
    "prompt": "Change the label of P10_NAME from 'Name' to 'Full Name'",
    "expected_skill": "apex-component-modifier",
    "expected_actions": ["export", "patch", "import"],
    "notes": "Simple parameter modification on existing component"
  },
  {
    "prompt": "Create a new LOV called PRIORITY_LOV with values High, Medium, Low",
    "expected_skill": "apex-component-modifier",
    "expected_actions": ["export", "patch", "import"],
    "notes": "Shared component creation — should create new file"
  },
  {
    "prompt": "Remove the P10_NOTES item from page 10",
    "expected_skill": "apex-component-modifier",
    "expected_actions": ["export", "patch", "import"],
    "notes": "Component removal — must check cross-references"
  }
]
```

**Step 3: Commit**

```bash
git add .claude/skills/apex-component-modifier/evals/
git commit -m "feat: add evals scaffold with test prompts for skill regression testing"
```

---

## Summary of all tasks

| # | Task | Priority | Impact |
|---|------|----------|--------|
| 1 | Expand skill description for better triggering | High | More reliable skill activation |
| 2 | Add error recovery / rollback strategy | High | Safer production use |
| 3 | Add TOC to large ref files + conditional reading | High | Less context window waste |
| 4 | Add end-to-end patching example | Medium | Better patch accuracy |
| 5 | Create automated validation script | High | Catch errors before import |
| 6 | Add APEX version compatibility notes | Medium | Broader version support |
| 7 | Clarify `.mcp_example.json` vs `.mcp.json` | Low | Less user confusion |
| 8 | Add slash commands | Medium | Better UX for common operations |
| 9 | Fix minor issues (typo, allowed-tools) | Low | Polish |
| 10 | Add evals scaffold | Medium | Regression testing capability |

## Not included (out of scope)

- **Item 6 from research (full multi-version support):** Adding complete reference docs for APEX 23.x/21.x would require access to those APEX versions. Task 6 adds a compatibility note instead.
- **Full CI pipeline:** Evals scaffold (Task 10) provides the structure; actual CI integration depends on the user's CI system.
