---
description: Export an APEX component without modification (read-only)
argument-hint: "[PAGE:10 | LOV:<id> | ...]"
---

Export the specified APEX component using SQLcl MCP without making any changes.

1. Connect to the database using `$SQLCL_CONNECTION`.
2. Run `apex export -applicationid $APEX_APP_ID -split -expComponents "$ARGUMENTS"`.
3. Report what files were exported and their locations.

Do NOT modify any files. This is a read-only operation.
