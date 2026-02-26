---
description: Describe an APEX page or component by reading its export
argument-hint: "[PAGE:10 | LOV:<id> | ...]"
---

Export and describe the specified APEX component.

1. Connect using `$SQLCL_CONNECTION`.
2. Export: `apex export -applicationid $APEX_APP_ID -split -expComponents "$ARGUMENTS"`.
3. Read exported file(s).
4. Structured summary: component type/name, regions (name, type, source), items (name, type, region), buttons, processes, DAs, validations, key settings/conditions.

Read-only -- do NOT modify files.
