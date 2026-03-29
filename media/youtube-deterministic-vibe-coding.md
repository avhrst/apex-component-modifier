# Deterministic Vibe Coding: AI Agent Builds a Production Module in Oracle APEX

## Title
Deterministic Vibe Coding: AI Agent Builds a Full Amazon Inventory Module in Oracle APEX

## Description

What's more powerful than vibe coding? Deterministic vibe coding.

Vibe coding gives AI agents too much freedom -- they can break security, change auth schemes, produce inconsistent code across teams. Low-code platforms like Oracle APEX solve this by providing a deterministic API layer that strictly controls what any developer (or agent) can do.

In this video, I combine both: an AI agent (Claude Code) builds a complete Amazon product tracking and inventory management module inside an existing production Oracle APEX application -- without opening the App Builder once.

### What the AI agent builds from scratch:

- 3 database tables (products, inventory transactions, sync log)
- PL/SQL package that scrapes Amazon Best Sellers in real time
- 6 APEX pages: dashboard with KPI badges + bar chart, product cards, transaction management, modal forms
- Sidebar navigation integrated with the existing app
- Dashboard widget on the main page
- Full CRUD with modal popups for editing

### Why this matters:

The AI agent never touches code directly. It works through APEX's API layer (wwv_flow_imp) -- the same deterministic layer that has been refined by Oracle for 20+ years. This means:

- No matter what context the agent has, it cannot break existing security, auth schemes, or design standards
- The generated module immediately fits the existing application's look, feel, and conventions
- Every component is production-ready on first import -- no review needed
- Different agents, different prompts, different developers -- same deterministic result

### The workflow:

Export -> Patch -> Import. All via SQLcl CLI from the terminal.

The custom APEX skill reads export files, understands the PL/SQL import API, patches components incrementally, and imports them back. It handles ID sequencing, block boundaries, template references, and error recovery automatically.

### Tech stack:

- Oracle APEX 24.2 (Universal Theme 42)
- Oracle Database 23ai
- SQLcl 25.x CLI
- Claude Code with custom APEX & SQLcl skills
- PL/SQL + APEX_WEB_SERVICE for Amazon scraping

### The result:

A complete inventory module -- Amazon product sync, stock tracking (receiving, sales, adjustments), balance dashboard with charts -- built entirely by an AI agent, seamlessly integrated into an existing 127-page production application.

This is what happens when you combine the creativity of AI with the discipline of a mature low-code platform.

---

Links:
- APEX & SQLcl Skills for Claude Code: https://github.com/oleksii-ai/apex-component-modifier
- Oracle APEX: https://apex.oracle.com
- Claude Code: https://claude.ai/claude-code

---

Timestamps:
[00:00] Introduction -- What is Deterministic Vibe Coding?
[XX:XX] The problem with traditional vibe coding
[XX:XX] How low-code platforms add a deterministic layer
[XX:XX] Demo: AI agent builds the Amazon Inventory Module
[XX:XX] Database layer: tables, triggers, PL/SQL package
[XX:XX] APEX pages: dashboard, cards, forms, navigation
[XX:XX] Live Amazon sync -- real data pulled in
[XX:XX] Final result and key takeaways

## Tags
Oracle APEX, Vibe Coding, Deterministic Vibe Coding, AI Agent, Claude Code, SQLcl, Low-Code, Oracle Database, PL/SQL, Amazon, Inventory Management, Production Integration, AI Development, No-Code, wwv_flow_imp, APEX API, Claude Anthropic, AI Coding, Software Development, Enterprise AI

## Category
Science & Technology
