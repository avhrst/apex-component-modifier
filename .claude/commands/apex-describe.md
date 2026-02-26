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
