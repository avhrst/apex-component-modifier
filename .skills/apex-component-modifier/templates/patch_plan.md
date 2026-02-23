# Patch Plan Template

Use this template to document the change plan before modifying any files.

---

## Change Request
<!-- Paste the user's original request here -->


## Target
- **Connection/Environment:** `<conn>`
- **Application ID:** `<app_id>`
- **Component(s):** `<component_selector>` (e.g., `PAGE:10`, `LOV:12345`)

## Database Changes

| # | Object Type | Object Name | Action | Idempotent? | Script |
|---|-------------|-------------|--------|-------------|--------|
| 1 | TABLE       | APP_STATUS  | CREATE | Yes (dict check) | `01_create_table.sql` |
| 2 | PACKAGE     | PKG_STATUS  | CREATE OR REPLACE | Yes | `02_create_pkg.sql` |

**Execution order:** 1 → 2

## APEX Component Changes

| # | File | Component Type | Action | Details |
|---|------|----------------|--------|---------|
| 1 | `page_00010.sql` | REGION | ADD | New region "Status" after region "Details" |
| 2 | `page_00010.sql` | PAGE ITEM | ADD | P10_STATUS (select list, LOV: STATUS_LOV) |
| 3 | `page_00010.sql` | PROCESS | MODIFY | Add P10_STATUS to DML process |

**New IDs required:**
- Region: `<new_id_1>` (derived from existing max + offset)
- Page item: `<new_id_2>`

## Ordering
1. Apply DB changes (scripts 1, 2)
2. Validate compilation
3. Patch export file(s)
4. Import via `install_component.sql`
5. Re-export + diff to verify

## Risks / Notes
<!-- Any concerns, edge cases, or rollback notes -->
