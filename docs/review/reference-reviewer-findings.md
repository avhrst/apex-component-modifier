# Reference Reviewer Findings

## Summary
Reviewed all 7 reference files in `.claude/skills/sqlcl/references/`. Found **28 issues** across correctness, completeness, and quality. All have been fixed directly. A prior "fixer" agent had already corrected some items (DBTOOLS$MCP_LOG columns, CODESCAN partial syntax, workspace activity log view name); this review builds on that work.

**Overall assessment:** Files were structurally sound but had scattered inaccuracies in command syntax, wrong parameter names, incomplete option lists, and a few code bugs. After fixes, all 7 files now accurately reflect Oracle SQLcl 25.x documentation.

---

## mcp_tools.md
### Issues Found & Fixed
- WRONG_PARAM: Restriction level table had "Scripts (@)" column header, missing `@@` and `START` -- FIXED (now `Scripts (@, @@, START)`)
- WRONG_PARAM: Restriction level table had "HOST" and "SPOOL" as column headers, not showing SAVE/EDIT/STORE are also blocked at level 2 -- FIXED (now `HOST / OS` and `SPOOL / SAVE / EDIT`)
- WRONG_PARAM: Level 3 listed as "Limited" scripts; actually scripts are fully blocked at level 3 -- FIXED (now `No`)
- MISSING_INFO: No explanation of what each restriction level actually blocks -- FIXED (added per-level descriptions)
- MISSING_INFO: No mention of `/* LLM in use ... */` query comment markers in V$SQL/ASH/AWR -- FIXED (added Query Identification section)
- MISSING_INFO: No maintenance note about DBTOOLS$MCP_LOG having no auto-cleanup -- FIXED

### Improvements Made
- Added detailed per-level restriction explanations (levels 0-4)
- Added query identification section documenting SQL comment markers
- Added maintenance warning for DBTOOLS$MCP_LOG cleanup

---

## sql_plsql.md
### Issues Found & Fixed
- WRONG_SYNTAX: `purge_old_logs` procedure used `SQL%ROWCOUNT` after `COMMIT`, which resets it to 0 -- FIXED (capture into variable before COMMIT)
- WRONG_SYNTAX: Recompile loop used `ALTER PACKAGE BODY x COMPILE` which is invalid; correct is `ALTER PACKAGE x COMPILE BODY` -- FIXED (added PACKAGE BODY and TYPE BODY special handling)

### Improvements Made
- Recompile loop now correctly handles PACKAGE BODY and TYPE BODY objects
- Added explanatory note about correct ALTER syntax for body compilation
- Added ORDER BY to recompile loop to process bodies after specs

---

## schema_commands.md
### Issues Found & Fixed
- WRONG_PARAM: INFO+ described as "Adds foreign keys, check constraints, and detailed column comments" -- actually INFO+ replaces column comments with column statistics -- FIXED
- WRONG_SYNTAX: CODESCAN section used `SET CODESCAN DIR /path` which is not valid syntax -- FIXED (was partially fixed by fixer agent; further expanded)
- WRONG_SYNTAX: REST section listed `REST list`, `REST enable-schema`, `REST disable-schema` as commands; actual commands are `REST export`, `REST modules`, `REST privileges`, `REST schemas` -- FIXED
- MISSING_INFO: INFO section had SET INFO INDEX/STATS options that are not standard SQLcl commands -- FIXED (removed, replaced with note about INFO+ and PL/SQL support)
- MISSING_INFO: DDL command missing `SAVE` option to write DDL to file -- FIXED
- MISSING_INFO: SET DDL options missing SQLTERMINATOR, PARTITIONING, SPECIFICATION, BODY, CONSTRAINTS_AS_ALTER, RESET -- FIXED
- MISSING_INFO: CODESCAN missing individual category toggles (SQLINJECTION, SQLPERFORMANCE, SQLBESTPRACTICE) and batch parameters table -- FIXED
- MISSING_INFO: REST section missing `REST export` (the primary REST command) and `REST schemas` -- FIXED

### Improvements Made
- Complete rewrite of CODESCAN section with interactive mode, directory scan mode, parameters table, and rule prefixes
- Complete rewrite of REST section with correct command list and PL/SQL example for enabling schema
- Added SHOW CODESCAN command
- Added comprehensive SET DDL options list including RESET
- Added DDL SAVE syntax

---

## data_commands.md
### Issues Found & Fixed
- WRONG_SYNTAX: LOAD command used `LOAD employees data.csv` syntax with options on separate lines; correct syntax is `LOAD TABLE employees data.csv NEW` -- FIXED
- WRONG_SYNTAX: LOAD options `DELIMITER`, `ENCLOSURE`, `ENCODING` were shown as inline options but are actually `SET LOADFORMAT` commands -- FIXED
- WRONG_SYNTAX: BRIDGE command used fabricated `SELECT * FROM EXTERNAL(...)` syntax; actual syntax is `BRIDGE <table> AS "<jdbcURL>"(<query>)` -- FIXED
- WRONG_PARAM: DATAPUMP parameters listed `-exclude`, `-include`, `-remap_schema`; actual short forms are `-excludeexpr`/`-ex`, `-excludelist`/`-el`; `-remap_schema` doesn't exist (use remap via other mechanisms) -- FIXED
- MISSING_INFO: DATAPUMP missing short-form aliases (`dp`, `-s`, `-f`, `-lf`, `-d`, `-j`) -- FIXED
- MISSING_INFO: DATAPUMP missing `-noexec`, `-verbose`, `-wait`, `-copycloud`, `-encryptionpassword` parameters -- FIXED
- MISSING_INFO: DATAPUMP missing defaults section (current schema, DATA_PUMP_DIR, auto job naming) -- FIXED
- MISSING_INFO: SET SQLFORMAT table missing `text` format -- FIXED
- MISSING_INFO: LOAD missing SET LOAD configuration commands (SCAN_ROWS, DATE_FORMAT, COLSIZE, CLEAN_NAMES, ERRORS) -- FIXED
- MISSING_INFO: LOAD missing 5000-row scan cap warning -- FIXED
- MISSING_INFO: SODA missing `replace` command, `-all` flag, `-klist` flag, count with QBE, case-sensitivity note, SODA_APP role prerequisite -- FIXED

### Improvements Made
- Complete rewrite of LOAD section with correct syntax, modes (NEW/SHOW/CREATE), SET LOADFORMAT/LOAD configuration
- Complete rewrite of BRIDGE section with correct JDBC URL syntax
- Expanded DATAPUMP section with short-form aliases, additional parameters, and defaults
- Expanded SODA section with all commands, flags, prerequisites, and case-sensitivity warning
- Added `text` format to SQLFORMAT table

---

## apex_commands.md
### Issues Found & Fixed
- WRONG_PARAM: Import note said "restriction level <= 1" for `@` script execution; actually `@` works at levels 0, 1, and 2 (blocked at level 3+) -- FIXED (now says level <= 2)
- MISSING_INFO: Export options table missing `-expOriginalIds`, `-expTranslations`, `-expPubReports`, `-expSavedReports`, `-expSupportingObjects`, `-expComments`, `-list`, `-changesSince`, `-changesBy` -- FIXED
- MISSING_INFO: Component selector table missing `AUTHENTICATION`, `BREADCRUMB`, `BREADCRUMB_ENTRY`, `PAGE_TEMPLATE`, `REGION_TEMPLATE` types -- FIXED
- MISSING_INFO: No mention of `apex export -list` to discover TYPE:ID values -- FIXED
- MISSING_INFO: No mention of `apex_appl_export_comps` dictionary view for ID lookup -- FIXED
- MISSING_INFO: No note about component import limitation (same app only) -- FIXED
- MISSING_INFO: No note about PAGE IDs using page numbers vs internal IDs for other types -- FIXED

### Improvements Made
- Expanded export options table from 10 to 19 options
- Expanded component selector table with additional types and ID format column
- Added discovery methods (-list flag, APEX_APPL_EXPORT_COMPS view)
- Added import limitation note
- Added PAGE vs internal ID clarification

---

## liquibase_commands.md
### Issues Found & Fixed
- MISSING_INFO: No mention that `lb` is a shorthand for `liquibase` -- FIXED
- MISSING_INFO: No mention of standalone SQLcl requirement and CREATE TABLE privilege need -- FIXED
- MISSING_INFO: generate-schema missing most options (-emit_schema, -fail, -replace, -runonchange, -runalways, -context, -label, -noreport) -- FIXED
- MISSING_INFO: generate-db-object missing `-change-type` parameter and output file naming convention -- FIXED
- MISSING_INFO: No mention of related generation commands (generate-apex-object, generate-ords-module, generate-ords-schema) -- FIXED
- MISSING_INFO: No mention of DATABASECHANGELOG_EXPORT temporary table created during schema capture -- FIXED

### Improvements Made
- Added `lb` shorthand note and prerequisite section
- Added comprehensive generate-schema options table (12 options)
- Added generate-db-object output naming convention
- Added related generation commands section
- Added DATABASECHANGELOG_EXPORT table note

---

## project_commands.md
### Issues Found & Fixed
- WRONG_SYNTAX: `project stage add-custom -file /path/to/custom_script.sql -description "..."` -- actual syntax is `project stage add-custom -file-name <name>` -- FIXED
- WRONG_PARAM: `project deploy -connection PROD` -- deploy takes `-file` (artifact ZIP path), not `-connection`; you connect to the target DB first -- FIXED
- WRONG_PARAM: Deploy options listed `-connection` and `-dry-run` -- corrected to `-file`, `-version`, `-debug` -- FIXED
- WRONG_PARAM: Directory structure showed `project.json`, `releases/`, `.liquibase/` -- actual structure uses `.dbtools/` for config and `dist/` for distributable scripts -- FIXED
- MISSING_INFO: Missing `project verify` and `project config` subcommands -- FIXED
- MISSING_INFO: Missing subcommand aliases table -- FIXED
- MISSING_INFO: Missing `-verbose` and `-debug` flag support note -- FIXED
- MISSING_INFO: Missing stateful vs stateless object deployment explanation -- FIXED
- MISSING_INFO: Missing notes about export creating new branches, roll-forward strategy on failures -- FIXED

### Improvements Made
- Added Additional Subcommands section (verify, config)
- Added complete subcommand aliases table
- Added stateful vs stateless objects section explaining deployment differences
- Fixed directory structure to show `.dbtools/` and `dist/` layout
- Fixed deployment workflow to use correct `deploy -file` syntax
- Added roll-forward strategy note
