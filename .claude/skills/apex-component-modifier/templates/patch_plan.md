# Patch Plan Template

Document the change plan before modifying any files.

## Change Request
<!-- User's original request -->

## Target
- **Connection:** `<conn>`
- **App ID:** `<app_id>`
- **Component(s):** `<selector>` (e.g., `PAGE:10`, `LOV:12345`)

## Database Changes

| # | Type | Name | Action | Idempotent? | Script |
|---|------|------|--------|-------------|--------|

**Execution order:** 1 -> 2

## APEX Component Changes

| # | File | Component | Action | Details |
|---|------|-----------|--------|---------|

**New IDs required:** (derived from existing max + offset)

## Ordering
1. Apply DB changes
2. Validate compilation
3. Patch export file(s)
4. Import via `install_component.sql`
5. Re-export + diff to verify

## Risks / Notes
<!-- Concerns, edge cases, rollback notes -->
