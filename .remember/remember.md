# Handoff

## State
I completed a full review of all 14 SQLcl skill files (`.claude/skills/sqlcl/`). 61 issues found and fixed across references, templates, and SKILL.md. Committed as `5f0eadd` and pushed to `main`. Findings in `docs/review/`. Created global `~/.claude/CLAUDE.md` with subagent behavior learnings.

## Next
1. Unstaged deletions: old `.claude/skills/apex-component-modifier/` directory is deleted locally but not committed — decide whether to commit the removal
2. Untracked `.claude/skills/apex/` directory exists — this is the new APEX skill location, may need committing
3. APEX skill has not been reviewed yet — same review process could be applied

## Context
- Background agents cannot edit files even with `bypassPermissions` — use them for research only, apply edits from main session
- Team agents (`TeamCreate`) don't work with OCI proxy — always use regular background agents
- The template-reviewer corrected one of the fixer's changes: `APEX_WORKSPACES` uses column `workspace` not `workspace_name`
