---
description: Export an APEX component without modification (read-only)
argument-hint: "[PAGE:10 | LOV:<id> | ...]"
---

Export the specified APEX component using SQLcl MCP.

1. Connect using `$SQLCL_CONNECTION`.
2. Run `apex export -applicationid $APEX_APP_ID -split -expComponents "$ARGUMENTS"`.
3. Report exported files and locations.

Read-only -- do NOT modify files.
