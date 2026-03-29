# Deterministic Vibe Coding — Source Document for NotebookLM

## What is this document?

This is the source material for generating an audio overview (podcast-style clip) using Google NotebookLM. The topic is Deterministic Vibe Coding — a new approach to building production software by combining AI agents with low-code platforms. The clip will be used as the opening narration for a YouTube video that shows a live demo of this approach.

The tone should be conversational, enthusiastic but grounded, and accessible to developers who know what vibe coding is but may not be familiar with Oracle APEX. Think of two tech podcast hosts discussing a breakthrough they just witnessed.

---

## The Core Idea

There is a technology that is much more powerful than vibe coding. It is the combination of low-code platforms with AI coding agents. This combination produces something we call Deterministic Vibe Coding.

### The Problem with Vibe Coding

Vibe coding — where you describe what you want and an AI agent writes the code — is exciting but has serious problems when applied to real production systems.

The first problem is safety. The AI agent has access to the code and has enormous freedom in what it can generate. It can accidentally change authorization schemes, authentication settings, or security policies. The agent generates code within whatever context it has at that moment, and it simply does not understand the full business requirements of the system it is modifying.

The second problem is teamwork. In a large development team, different developers using AI agents will produce code in dramatically different styles. The code will not be uniform. One developer's AI-generated code can conflict with another's. This makes it extremely difficult to integrate AI-generated code into a large existing project.

The root cause of both problems is the same: vibe coding gives agents and developers too much freedom — unlimited access to code with no guardrails.

### What Low-Code Platforms Provide

Low-code platforms have been built over many years specifically to solve this kind of problem — but for human developers. They work by providing a programmatic API as an intermediary layer between the developer and the application. The developer does not write code directly. Instead, every action goes through this API layer, which strictly controls the rules.

Take Oracle APEX as an example. To create a table on a page, you specify a template name and provide a query. You can configure column display parameters at a high level. But you cannot affect the overall design of that table, you cannot change global security settings, and therefore, no matter which developer does this — no matter what context they have — they will never go beyond the boundaries of the application.

This is what makes it a deterministic application. The platform does not allow the developer to deviate. In Oracle APEX specifically, practically every action is described by thousands of API calls covering different use cases with different parameters. Oracle has been developing this platform for over 20 years, and it has an extremely large number of components covering a very wide range of business requirements.

### The Breakthrough: Combining Both

The breakthrough is giving the AI agent access not to the code directly, but to the API that the low-code platform provides. This allows AI-generated development to fit into existing complex projects. Regardless of the agent's style, settings, type, or context, the agent performs targeted tasks that fully integrate into the system immediately and are production-ready right away.

This is Deterministic Vibe Coding: the creative power of AI constrained by the discipline of a mature low-code platform.

---

## The Demo: What Was Built

To demonstrate this concept, we use an existing Oracle APEX application — a Customer Tracker application with 127 pages, its own design system, security rules, and user authorization settings. This application (Application 130) tracks customer data but has no module for tracking products.

### The Requirement

We need to add a completely new module to this existing system — without breaking any standards — that will:

1. Download top-selling products from Amazon's Best Sellers page
2. Search the internet for product descriptions and images
3. Store these products in local database tables
4. Allow users to browse products with images in a card-based layout
5. Track inventory through simple transactions — receiving products, selling or writing off products, and making inventory adjustments
6. Provide a dashboard showing product counts, total stock value, low stock alerts, and a chart of stock levels
7. Allow users to create, edit, and delete inventory transactions through popup modal dialogs

This module has never existed in this system. The AI agent must build it from scratch and integrate it seamlessly.

### What the AI Agent Built

The AI agent (Claude Code with custom APEX and SQLcl skills) built the entire module through the terminal using SQLcl CLI. The App Builder was never opened. Everything was done through the export-patch-import workflow.

#### Database Layer

Three new tables following the existing application's naming convention (EBA_CUST_AMZN prefix):

- EBA_CUST_AMZN_PRODUCTS — stores Amazon product data: ASIN, name, description, image URL, price, bestseller rank, category, and an optional link to the existing internal products table
- EBA_CUST_AMZN_INVENTORY — stores inventory transactions with type (receiving, sale/write-off, adjustment), quantity, unit price, date, and notes
- EBA_CUST_AMZN_SYNC_LOG — records every Amazon sync operation with timestamps, counts, status, and error messages

Three triggers following the existing application's exact pattern — using sys_guid() for ID generation (not identity columns), automatic audit columns (created, created_by, updated, updated_by), and row version number tracking.

One balance view (EBA_CUST_AMZN_BALANCE_V) that calculates stock on hand per product by summing transactions with sign logic — receiving adds, sales subtract, adjustments can do either.

One PL/SQL package (EBA_CUST_AMZN_PKG) with three programs:
- SYNC_BESTSELLERS — fetches the Amazon Best Sellers HTML page using APEX_WEB_SERVICE.MAKE_REST_REQUEST, parses product data from the HTML (ASIN, name, price, image, rank), and merges results into the products table
- GET_PRODUCT_DETAILS — fetches an individual product page for extended description and higher-resolution images
- CALC_BALANCE — returns current quantity on hand for a given product

#### APEX Pages

Six new pages in a new "Inventory" page group:

Page 200 — Inventory Dashboard. A proper dashboard following the existing application's patterns: Badge List region showing four KPI metrics (total products, total stock value, low stock alerts, last sync time), a horizontal bar chart showing top 10 products by stock quantity, and a Cards region displaying all products with images, prices, and quantity badges. Each card links to the product detail modal.

Page 201 — Amazon Products. A Cards region showing all synced Amazon products with images, names, ASINs, categories, prices, and bestseller ranks. Has a "Sync from Amazon" button (restricted to administrators) that triggers the live scraping process, and a "Sync Log" button to view sync history.

Page 202 — Amazon Product Detail. A modal dialog form for viewing and editing product information, including an optional dropdown to link Amazon products to existing internal products.

Page 203 — Inventory Transactions. An Interactive Report showing all inventory transactions with edit icons that open a modal dialog for each transaction.

Page 204 — Transaction. A modal dialog form for creating, editing, and deleting inventory transactions. Shows different buttons depending on whether it is a new record or an existing one.

Page 205 — Sync Log. A modal dialog with an Interactive Report showing the history of all Amazon sync operations.

#### Integration with Existing Application

The module was integrated into the existing 127-page application in four ways:

1. Navigation — An "Inventory" section was added to the sidebar menu with three sub-items: Dashboard, Amazon Products, and Transactions. Placed alongside the existing Products menu entry.

2. Dashboard — An "Inventory Summary" region was added to the existing application dashboard (Page 1), showing a compact summary of Amazon products tracked, total value, and low stock count, with a link to the full Inventory Dashboard.

3. Authorization — The module uses the same authorization schemes as the rest of the application: CONTRIBUTION RIGHTS for viewing and editing, ADMINISTRATION RIGHTS for the Amazon sync function.

4. Breadcrumb — A breadcrumb entry was added for the Inventory Dashboard so the page title displays correctly in the breadcrumb bar.

### Live Amazon Data

When the sync was first triggered, the agent's PL/SQL package successfully fetched and parsed 36 real products from Amazon's Best Sellers page. The data — product names, prices, images, bestseller ranks — was stored in the local database and immediately displayed in the Cards regions across the dashboard and product pages.

---

## Why This Is Significant

### For Enterprise Development

Traditional enterprise development is slow and expensive. Vibe coding is fast but dangerous for production systems. Deterministic Vibe Coding is both fast and safe — the AI agent can build complex modules in minutes, but the low-code platform ensures everything conforms to existing standards.

### For the AI Agent Workflow

The agent works through a strict pipeline: export the APEX component as a SQL file, read reference documentation about the APEX import API, patch the exported file following exact syntax rules (ID sequencing, block boundaries, parameter validation, template references), import the patched file back through SQLcl, and verify the result.

Each step is deterministic. The APEX import engine validates every parameter against strict constraints. Invalid parameter combinations are rejected with specific error codes. Wrong block nesting causes compilation errors. Missing references fail immediately. The agent cannot silently break things — the platform catches errors at import time.

### For the Demo Video

The video shows this entire process at high speed — from the initial brainstorming session where the AI agent analyzes the existing application, through the database layer creation, the incremental page building, the navigation and dashboard integration, to the final live Amazon sync with real products appearing in the application.

The key insight for the audience: the module that was built is indistinguishable from what a skilled APEX developer would create manually. Same templates, same authorization patterns, same trigger conventions, same navigation structure. The platform's deterministic API made this possible — not the AI agent's "understanding" of best practices.

---

## Technical Details for Context

### The Export-Patch-Import Workflow

APEX applications can be exported as SQL files using SQLcl. Each file contains a series of PL/SQL API calls (wwv_flow_imp_page.create_page, create_page_plug, create_page_item, etc.) that describe every component. The AI agent modifies these files — adding new API calls for new components, changing parameter values for modifications — and then imports them back through the same SQL engine.

The API has strict rules: every procedure call must be in its own begin/end block, IDs must be unique and sequential, cross-references must match, parameter values must come from defined enumerations, and templates must reference existing template IDs. These constraints make the process deterministic — there is only one correct way to define each component.

### Patterns Matched from the Existing Application

The AI agent studied the existing application before building the module:

- ID generation: sys_guid() converted to number (not identity columns)
- Audit columns: created/created_by/updated/updated_by via before-insert-or-update triggers
- Table naming: EBA_CUST_ prefix for all tables
- Package naming: EBA_CUST_ prefix for all packages
- Page templates: Universal Theme 42, left sidebar layout
- Authorization: PL/SQL function-returning-boolean schemes
- Navigation: Application Navigation list with parent/child hierarchy
- Dashboard pattern: Badge List plugin for KPI metrics, JET Charts for visualizations, Cards for product browsing

Every one of these patterns was discovered by querying the existing application's metadata and export files — not by guessing or using generic defaults.

### Real-World Challenges Encountered

During the build, the AI agent encountered and resolved several issues that demonstrate the deterministic layer's value:

- SQLERRM cannot be used directly in SQL DML statements — the agent captured it into a variable first
- Region authorization uses p_plug_required_role, not p_security_scheme — the import engine rejected the wrong parameter
- PL/SQL regions use NATIVE_PLSQL with htp.p() calls, not RETURN — the engine caught the invalid RETURN statement
- SET DEFINE OFF is required when SQL contains ampersand substitution strings — the engine would otherwise interpret them as bind variables
- Breadcrumb entries can only be added through a full application import — partial imports cannot modify the menu structure

Each of these errors was caught by the platform, not by the AI agent's "knowledge." The deterministic layer protected the application from every mistake.
