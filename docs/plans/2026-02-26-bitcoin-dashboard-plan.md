# Bitcoin Prices Dashboard Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a rich bitcoin prices dashboard on Page 1 of APEX app 105 with summary cards, two charts, and an interactive report — all backed by a static `BTC_PRICES` table.

**Architecture:** Single table `BTC_PRICES` seeded with 30 rows of demo data. Page 1 gets 4 summary card regions (row 1), a price line chart and volume bar chart side by side (row 2), and an Interactive Report (row 3). All regions use direct SQL against the table. No PL/SQL packages or views.

**Tech Stack:** Oracle APEX 24.2, Universal Theme (42), JET Charts, Interactive Report, SQLcl MCP for export/patch/import.

**Design doc:** `docs/plans/2026-02-26-bitcoin-dashboard-design.md`

**Skill:** `apex-component-modifier` (export -> patch -> import via SQLcl MCP)

**Connection:** `ai` | **App ID:** `105` | **Workspace:** `ai`

---

### Task 1: Create BTC_PRICES table and seed data

**Purpose:** Set up the database object before any APEX changes.

**Step 1: Create the table via SQLcl MCP**

Run via `mcp__sqlcl__run-sql`:

```sql
CREATE TABLE btc_prices (
    price_date  DATE           NOT NULL,
    open_price  NUMBER(12,2)   NOT NULL,
    high_price  NUMBER(12,2)   NOT NULL,
    low_price   NUMBER(12,2)   NOT NULL,
    close_price NUMBER(12,2)   NOT NULL,
    volume      NUMBER(18,2)   NOT NULL,
    CONSTRAINT btc_prices_pk PRIMARY KEY (price_date)
);
```

Expected: `Table BTC_PRICES created.`

**Step 2: Seed 30 rows of demo data**

Run via `mcp__sqlcl__run-sql`:

```sql
INSERT ALL
  INTO btc_prices VALUES (DATE '2026-01-28', 87250.00, 88900.50, 86100.00, 88450.75, 28500000000.00)
  INTO btc_prices VALUES (DATE '2026-01-29', 88450.75, 89200.00, 87800.00, 88100.25, 25800000000.00)
  INTO btc_prices VALUES (DATE '2026-01-30', 88100.25, 90500.00, 87950.00, 90250.50, 32100000000.00)
  INTO btc_prices VALUES (DATE '2026-01-31', 90250.50, 91800.00, 89700.00, 91500.00, 35600000000.00)
  INTO btc_prices VALUES (DATE '2026-02-01', 91500.00, 93200.00, 91100.00, 92800.25, 38200000000.00)
  INTO btc_prices VALUES (DATE '2026-02-02', 92800.25, 93500.00, 91500.00, 91900.50, 29400000000.00)
  INTO btc_prices VALUES (DATE '2026-02-03', 91900.50, 92100.00, 89800.00, 90200.00, 27100000000.00)
  INTO btc_prices VALUES (DATE '2026-02-04', 90200.00, 91500.00, 89500.00, 91200.75, 26800000000.00)
  INTO btc_prices VALUES (DATE '2026-02-05', 91200.75, 94100.00, 91000.00, 93800.50, 41200000000.00)
  INTO btc_prices VALUES (DATE '2026-02-06', 93800.50, 95200.00, 93100.00, 94500.25, 39800000000.00)
  INTO btc_prices VALUES (DATE '2026-02-07', 94500.25, 96800.00, 94200.00, 96200.00, 44500000000.00)
  INTO btc_prices VALUES (DATE '2026-02-08', 96200.00, 97100.00, 94800.00, 95100.50, 36200000000.00)
  INTO btc_prices VALUES (DATE '2026-02-09', 95100.50, 95800.00, 93200.00, 93800.75, 31500000000.00)
  INTO btc_prices VALUES (DATE '2026-02-10', 93800.75, 94500.00, 92100.00, 92500.00, 28900000000.00)
  INTO btc_prices VALUES (DATE '2026-02-11', 92500.00, 93800.00, 91800.00, 93500.25, 30200000000.00)
  INTO btc_prices VALUES (DATE '2026-02-12', 93500.25, 95800.00, 93200.00, 95500.50, 37800000000.00)
  INTO btc_prices VALUES (DATE '2026-02-13', 95500.50, 97500.00, 95100.00, 97100.00, 42100000000.00)
  INTO btc_prices VALUES (DATE '2026-02-14', 97100.00, 99200.00, 96800.00, 98800.25, 48500000000.00)
  INTO btc_prices VALUES (DATE '2026-02-15', 98800.25, 100500.00, 98200.00, 99900.50, 52300000000.00)
  INTO btc_prices VALUES (DATE '2026-02-16', 99900.50, 100800.00, 97500.00, 98100.00, 45100000000.00)
  INTO btc_prices VALUES (DATE '2026-02-17', 98100.00, 98500.00, 95200.00, 95800.75, 38700000000.00)
  INTO btc_prices VALUES (DATE '2026-02-18', 95800.75, 96200.00, 94100.00, 94500.50, 33200000000.00)
  INTO btc_prices VALUES (DATE '2026-02-19', 94500.50, 96500.00, 94200.00, 96100.25, 35800000000.00)
  INTO btc_prices VALUES (DATE '2026-02-20', 96100.25, 97800.00, 95800.00, 97500.00, 39200000000.00)
  INTO btc_prices VALUES (DATE '2026-02-21', 97500.00, 98500.00, 96200.00, 96800.50, 36500000000.00)
  INTO btc_prices VALUES (DATE '2026-02-22', 96800.50, 97200.00, 95100.00, 95500.25, 32100000000.00)
  INTO btc_prices VALUES (DATE '2026-02-23', 95500.25, 96800.00, 94800.00, 96500.00, 34800000000.00)
  INTO btc_prices VALUES (DATE '2026-02-24', 96500.00, 98200.00, 96100.00, 97800.75, 40100000000.00)
  INTO btc_prices VALUES (DATE '2026-02-25', 97800.75, 99500.00, 97200.00, 99100.50, 43500000000.00)
  INTO btc_prices VALUES (DATE '2026-02-26', 99100.50, 99800.00, 97800.00, 98500.25, 37900000000.00)
SELECT 1 FROM dual;
```

Expected: `30 rows inserted.`

**Step 3: Commit and validate**

```sql
COMMIT;
SELECT COUNT(*) AS row_count, MIN(price_date) AS min_date, MAX(price_date) AS max_date FROM btc_prices;
```

Expected: `30, 28-JAN-26, 26-FEB-26`

---

### Task 2: Export Page 1

**Purpose:** Get the current page export to use as the baseline for patching.

**Step 1: Create working directory**

```bash
mkdir -p /home/oleksii/Code/apex-component-modifier/workdir_btc_$(date +%Y%m%d_%H%M%S)
```

Note the actual directory name created — use it in all subsequent steps as `<workdir>`.

**Step 2: Export page 1 via SQLcl MCP**

Run via `mcp__sqlcl__run-sqlcl`:

```
apex export -applicationid 105 -split -dir <workdir>/f105 -expComponents "PAGE:1"
```

Expected: Export completes, creates `<workdir>/f105/` directory tree.

**Step 3: Verify export files exist**

```bash
ls <workdir>/f105/application/pages/page_00001.sql
ls <workdir>/f105/install_component.sql
```

Expected: Both files exist.

**Step 4: Create git baseline commit**

```bash
git add <workdir>/ && git commit -m "chore: baseline export of page 1 for bitcoin dashboard"
```

---

### Task 3: Load reference docs and read the exported page

**Purpose:** Understand the exported file structure, existing IDs, and template IDs before patching.

**Step 1: Read the exported page file**

Read `<workdir>/f105/application/pages/page_00001.sql` to understand:
- The `component_begin` / `component_end` wrapper
- The existing `create_page` call and its parameters
- Any existing regions (should be none based on our query)
- Max existing ID values (scan all `wwv_flow_imp.id(...)` calls)

**Step 2: Load skill reference docs**

Read the following files from `.claude/skills/apex-component-modifier/`:
- `references/apex_imp/README.md` + `apex_imp.md` (core engine, ID system)
- `references/apex_imp/imp_page.md` (create_page_plug, create_jet_chart, create_worksheet, etc.)
- `references/apex_imp/valid_values.md` (valid parameter values for region types, chart types)
- `tools/patching_guidelines.md` (patching rules, ID rules)
- `global-patterns/interactive_report.md` (IR pattern, if it exists)
- `global-patterns/jet_chart.md` (chart pattern, if it exists)

**Step 3: Identify template IDs**

Query APEX metadata to find Universal Theme template IDs needed for patching:

```sql
-- Region templates
SELECT template_id, template_name FROM apex_application_temp_region
WHERE application_id = 105 AND template_name IN ('Standard', 'Cards Container', 'Content Block', 'Blank with Attributes')
ORDER BY template_name;

-- Page template
SELECT template_id, template_name FROM apex_application_temp_page
WHERE application_id = 105 AND template_name = 'Standard';

-- Label template
SELECT template_id, template_name FROM apex_application_temp_label
WHERE application_id = 105;
```

Record the template IDs — they're needed for `p_plug_template` and `p_field_template` params.

---

### Task 4: Patch the page — Add summary card regions (Row 1)

**Purpose:** Add 4 static content regions showing key BTC metrics at the top of the page.

**Files:** `<workdir>/f105/application/pages/page_00001.sql`

**Step 1: Plan IDs**

Scan existing `wwv_flow_imp.id(N)` values in the file. Assign new IDs starting from max + 100 with spacing of 100:
- Cards container region: `<max+100>`
- Current Price region: `<max+200>`
- 24h Change region: `<max+300>`
- 30-Day High region: `<max+400>`
- 30-Day Low region: `<max+500>`

**Step 2: Add the container region (display_sequence 10)**

Insert after the `create_page` block, before `component_end`. Use region type `NATIVE_STATIC` with a Cards Container template:

```sql
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(<CARDS_CONTAINER_ID>)
,p_plug_name=>'Summary'
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_STATIC'
,p_plug_template=>wwv_flow_imp.id(<CARDS_CONTAINER_TEMPLATE_ID>)
,p_plug_template_options=>'#DEFAULT#'
);
end;
/
```

**Step 3: Add 4 card sub-regions**

Each card is a child region (`p_parent_plug_id` -> container) with `NATIVE_STATIC` type. The content is HTML with an embedded PL/SQL computation or inline static HTML referencing a hidden item. However, for simplicity, use `p_plug_source_type => 'NATIVE_DYNAMIC_CONTENT'` or `NATIVE_STATIC` with SQL source.

Better approach: use 4 separate `NATIVE_SQL` regions with SQL returning a single formatted value, each as a child of the container:

**Current Price:**
```sql
SELECT TO_CHAR(close_price, 'FML999G999G999G999D00') AS value_text
FROM btc_prices WHERE price_date = (SELECT MAX(price_date) FROM btc_prices)
```

**24h Change:**
```sql
SELECT CASE WHEN change_amt >= 0 THEN
  '<span style="color:green">+' || TO_CHAR(change_amt,'FM999G999D00') || ' (+' || TO_CHAR(change_pct,'FM990.0') || '%)</span>'
ELSE
  '<span style="color:red">' || TO_CHAR(change_amt,'FM999G999D00') || ' (' || TO_CHAR(change_pct,'FM990.0') || '%)</span>'
END AS value_text
FROM (
  SELECT curr.close_price - prev.close_price AS change_amt,
         ((curr.close_price - prev.close_price)/prev.close_price)*100 AS change_pct
  FROM (SELECT close_price FROM btc_prices WHERE price_date = (SELECT MAX(price_date) FROM btc_prices)) curr,
       (SELECT close_price FROM btc_prices WHERE price_date = (SELECT MAX(price_date) - 1 FROM btc_prices)) prev
)
```

**30-Day High:**
```sql
SELECT TO_CHAR(MAX(high_price), 'FML999G999G999G999D00') AS value_text FROM btc_prices
```

**30-Day Low:**
```sql
SELECT TO_CHAR(MIN(low_price), 'FML999G999G999G999D00') AS value_text FROM btc_prices
```

Each sub-region uses `p_plug_source_type => 'NATIVE_STATIC'` with the SQL result rendered via a before-header process, OR use `p_plug_source_type` with query. The simplest APEX-native approach is to use Static Content regions with `&P1_xxx.` substitutions backed by hidden items + before-header computations. However, since we want minimal components, the cleanest approach is:

**Use Static Content regions with HTML + Before Header PL/SQL processes** that set page items, OR simply use the region's own source as static HTML with `&ITEM.` substitutions.

**Recommended simplest approach:** 4 Static Content regions each with hardcoded HTML that uses `&P1_CURRENT_PRICE.` etc., plus 4 hidden page items, plus a single Before Header process that populates all 4 items.

Insert into the page file:
1. The 4 hidden page items (`P1_CURRENT_PRICE`, `P1_24H_CHANGE`, `P1_30D_HIGH`, `P1_30D_LOW`)
2. A Before Header process to populate them
3. The 4 Static Content sub-regions with HTML referencing the items

**Step 4: Run validation checklist**

Per `templates/validation_checklist.md`: verify `begin/end;/` blocks, ID uniqueness, cross-references, string escaping.

---

### Task 5: Patch the page — Add price line chart (Row 2, left)

**Purpose:** Add a JET line chart showing BTC close price over time.

**Files:** `<workdir>/f105/application/pages/page_00001.sql`

**Step 1: Assign new IDs**

Continue from max ID after Task 4:
- Chart region: `<next_id>`
- JET chart: `<next_id+100>`
- Chart X axis: `<next_id+200>`
- Chart Y axis: `<next_id+300>`
- Chart series: `<next_id+400>`

**Step 2: Add chart region (display_sequence 20)**

```sql
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(<PRICE_CHART_REGION_ID>)
,p_plug_name=>'BTC Price (30 Days)'
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_template=>wwv_flow_imp.id(<STANDARD_REGION_TEMPLATE_ID>)
,p_plug_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
end;
/
```

**Step 3: Add JET chart, axes, and series**

```sql
begin
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(<JET_CHART_ID>)
,p_region_id=>wwv_flow_imp.id(<PRICE_CHART_REGION_ID>)
,p_chart_type=>'lineWithArea'
,p_height=>'400'
,p_legend_rendered=>'off'
);
end;
/
begin
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(<X_AXIS_ID>)
,p_chart_id=>wwv_flow_imp.id(<JET_CHART_ID>)
,p_axis=>'x'
,p_title=>'Date'
);
end;
/
begin
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(<Y_AXIS_ID>)
,p_chart_id=>wwv_flow_imp.id(<JET_CHART_ID>)
,p_axis=>'y'
,p_title=>'Price (USD)'
);
end;
/
begin
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(<SERIES_ID>)
,p_chart_id=>wwv_flow_imp.id(<JET_CHART_ID>)
,p_seq=>10
,p_name=>'Close Price'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT price_date, close_price',
'FROM btc_prices',
'ORDER BY price_date'))
,p_items_value_column_name=>'CLOSE_PRICE'
,p_items_label_column_name=>'PRICE_DATE'
);
end;
/
```

**Step 4: Set layout to 50% width**

Use `p_plug_template_options` or grid column settings to place this in the left half. In Universal Theme, use `p_plug_new_grid_row => true` and `p_plug_new_grid_column => true` with grid column span attributes. The exact parameter is `p_plug_grid_column_span => 6` (6 of 12 columns).

**Step 5: Validate**

Check all IDs, cross-references, `begin/end;/` structure.

---

### Task 6: Patch the page — Add volume bar chart (Row 2, right)

**Purpose:** Add a JET bar chart showing daily trading volume, displayed beside the price chart.

**Files:** `<workdir>/f105/application/pages/page_00001.sql`

**Step 1: Assign new IDs** (continue from max after Task 5)

- Volume chart region: `<next_id>`
- JET chart: `<next_id+100>`
- X axis: `<next_id+200>`
- Y axis: `<next_id+300>`
- Series: `<next_id+400>`

**Step 2: Add chart region (display_sequence 30)**

Same structure as Task 5 but:
- `p_plug_name => 'Trading Volume (30 Days)'`
- `p_chart_type => 'bar'`
- Series SQL: `SELECT price_date, volume FROM btc_prices ORDER BY price_date`
- `p_items_value_column_name => 'VOLUME'`
- `p_plug_new_grid_row => false` (same row as price chart)
- `p_plug_grid_column_span => 6`

**Step 3: Validate**

---

### Task 7: Patch the page — Add Interactive Report (Row 3)

**Purpose:** Add an IR showing the full BTC_PRICES data table.

**Files:** `<workdir>/f105/application/pages/page_00001.sql`

**Step 1: Assign new IDs** (continue from max)

- IR region: `<next_id>`
- Worksheet: `<next_id+100>`
- 6 worksheet columns: `<next_id+200>` through `<next_id+700>`
- Default report: `<next_id+800>`

**Step 2: Add IR region (display_sequence 40)**

```sql
begin
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(<IR_REGION_ID>)
,p_plug_name=>'Price History'
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_IR'
,p_plug_template=>wwv_flow_imp.id(<STANDARD_REGION_TEMPLATE_ID>)
,p_plug_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT price_date,',
'       open_price,',
'       high_price,',
'       low_price,',
'       close_price,',
'       volume',
'FROM btc_prices'))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
end;
/
```

**Step 3: Add worksheet**

```sql
begin
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(<WORKSHEET_ID>)
,p_region_id=>wwv_flow_imp.id(<IR_REGION_ID>)
,p_name=>'Price History'
,p_max_row_count=>'100'
,p_no_data_found_message=>'No price data found.'
,p_show_search_bar=>'Y'
);
end;
/
```

**Step 4: Add 6 worksheet columns**

One `create_worksheet_column` per column: PRICE_DATE (DATE), OPEN_PRICE (NUMBER), HIGH_PRICE (NUMBER), LOW_PRICE (NUMBER), CLOSE_PRICE (NUMBER), VOLUME (NUMBER). Column identifiers: A through F.

**Step 5: Add default report**

```sql
begin
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(<RPT_ID>)
,p_worksheet_id=>wwv_flow_imp.id(<WORKSHEET_ID>)
,p_name=>'Primary'
,p_is_default=>'Y'
,p_display_rows=>50
,p_report_columns=>'PRICE_DATE:OPEN_PRICE:HIGH_PRICE:LOW_PRICE:CLOSE_PRICE:VOLUME'
,p_sort_column_1=>'PRICE_DATE'
,p_sort_direction_1=>'DESC'
);
end;
/
```

**Step 6: Validate**

Run full validation checklist. All IDs unique, cross-refs correct, `begin/end;/` intact.

---

### Task 8: Final validation and import

**Purpose:** Validate the complete patched file and import it back into APEX.

**Step 1: Run the validation checklist**

Go through every item in `templates/validation_checklist.md`:
- File integrity (begin/end, terminators, set define off)
- Component wrappers (component_begin/end intact)
- ID consistency (all unique, cross-refs match)
- Ordering (correct sections, no sequence collisions)
- String formatting (quotes escaped, multi-line strings correct)
- Functional (table/column names match, item naming P1_xxx)

**Step 2: Import via SQLcl MCP**

Run via `mcp__sqlcl__run-sqlcl`:

```
@<workdir>/f105/install_component.sql
```

Expected: Import completes without errors.

**Step 3: Check for compilation errors**

```sql
SELECT object_name, object_type, status FROM user_objects WHERE status = 'INVALID';
```

Expected: No invalid objects (or none related to our changes).

**Step 4: Re-export and diff**

```
apex export -applicationid 105 -split -dir <workdir>/f105_verify -expComponents "PAGE:1"
```

Compare the re-exported file against the patched file to confirm APEX accepted all changes cleanly.

**Step 5: Commit final state**

```bash
git add <workdir>/ && git commit -m "feat: add bitcoin prices dashboard to page 1"
```

---

### Task 9: Verify in browser (manual)

**Purpose:** Confirm the dashboard renders correctly.

**Step 1: Provide the user with the APEX URL**

```
https://<apex-host>/ords/f?p=105:1
```

**Step 2: Checklist for visual verification**

- [ ] 4 summary cards visible at top with correct values
- [ ] Price line chart renders with area fill
- [ ] Volume bar chart renders beside price chart
- [ ] Interactive Report shows 30 rows sorted by date descending
- [ ] No JavaScript console errors
