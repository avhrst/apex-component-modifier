# Amazon Inventory Module — Design Spec

**App:** 130 (Customers) | **Schema:** DVC | **Workspace:** DVC
**Date:** 2026-03-29
**Approach:** Module with integration bridges (Approach 3)

---

## Overview

Add an Amazon product tracking and inventory management module to the existing Customers app (130). The module:

- Scrapes Amazon Best Sellers page for product data (name, ASIN, price, image, rank)
- Stores Amazon products in dedicated tables with optional links to existing internal products
- Tracks inventory via simple transactions (IN/OUT/ADJUST)
- Provides a dashboard with metric cards and an Interactive Report showing stock balances
- Integrates with existing app security, navigation, and dashboard

This demonstrates **deterministic vibe coding** — an AI agent building a production-ready module through Oracle APEX's API layer, fitting seamlessly into an existing complex application.

---

## 1. Data Model

### 1.1 New Tables

#### `EBA_CUST_AMZN_PRODUCTS`

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| `ID` | NUMBER | PK, GENERATED ALWAYS AS IDENTITY | |
| `ASIN` | VARCHAR2(20) | UNIQUE, NOT NULL | Amazon Standard Identification Number |
| `PRODUCT_NAME` | VARCHAR2(500) | NOT NULL | |
| `DESCRIPTION` | VARCHAR2(4000) | | From Amazon or web search |
| `IMAGE_URL` | VARCHAR2(1000) | | Product image URL |
| `AMAZON_PRICE` | NUMBER(10,2) | | Current Amazon price |
| `AMAZON_RANK` | NUMBER | | Best seller rank |
| `CATEGORY` | VARCHAR2(255) | | Amazon category |
| `AMAZON_URL` | VARCHAR2(1000) | | Direct link to Amazon product page |
| `PRODUCT_ID` | NUMBER | FK → `EBA_CUST_PRODUCTS.ID` | Optional link to internal product |
| `IS_ACTIVE` | VARCHAR2(1) | DEFAULT 'Y', CHECK IN ('Y','N') | |
| `LAST_SYNCED` | TIMESTAMP WITH TIME ZONE | | Last scrape timestamp |
| `CREATED` | TIMESTAMP(6) WITH TIME ZONE | NOT NULL, DEFAULT SYSTIMESTAMP | |
| `CREATED_BY` | VARCHAR2(255) | NOT NULL | |
| `UPDATED` | TIMESTAMP(6) WITH TIME ZONE | | |
| `UPDATED_BY` | VARCHAR2(255) | | |

Indexes: unique on `ASIN`, FK index on `PRODUCT_ID`.

#### `EBA_CUST_AMZN_INVENTORY`

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| `ID` | NUMBER | PK, GENERATED ALWAYS AS IDENTITY | |
| `AMZN_PRODUCT_ID` | NUMBER | FK → `EBA_CUST_AMZN_PRODUCTS.ID`, NOT NULL | |
| `TXN_TYPE` | VARCHAR2(10) | NOT NULL, CHECK IN ('IN','OUT','ADJUST') | |
| `QUANTITY` | NUMBER | NOT NULL | Always stored positive. Sign is determined by TXN_TYPE: IN adds, OUT subtracts, ADJUST can add or subtract. Balance view applies sign logic. |
| `UNIT_PRICE` | NUMBER(10,2) | | Price at time of transaction |
| `TXN_DATE` | DATE | NOT NULL, DEFAULT SYSDATE | |
| `NOTES` | VARCHAR2(4000) | | |
| `CREATED` | TIMESTAMP(6) WITH TIME ZONE | NOT NULL, DEFAULT SYSTIMESTAMP | |
| `CREATED_BY` | VARCHAR2(255) | NOT NULL | |

Indexes: FK index on `AMZN_PRODUCT_ID`, index on `TXN_DATE`.

#### `EBA_CUST_AMZN_SYNC_LOG`

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| `ID` | NUMBER | PK, GENERATED ALWAYS AS IDENTITY | |
| `SYNC_DATE` | TIMESTAMP WITH TIME ZONE | NOT NULL, DEFAULT SYSTIMESTAMP | |
| `PRODUCTS_FOUND` | NUMBER | | |
| `PRODUCTS_UPDATED` | NUMBER | | |
| `STATUS` | VARCHAR2(20) | CHECK IN ('SUCCESS','PARTIAL','FAILED') | |
| `ERROR_MESSAGE` | VARCHAR2(4000) | | |
| `CREATED_BY` | VARCHAR2(255) | NOT NULL | |

### 1.2 Views

#### `EBA_CUST_AMZN_BALANCE_V`

Stock balance per product:

```sql
SELECT p.ID,
       p.ASIN,
       p.PRODUCT_NAME,
       p.IMAGE_URL,
       p.AMAZON_PRICE,
       p.CATEGORY,
       p.IS_ACTIVE,
       NVL(SUM(CASE WHEN i.TXN_TYPE = 'OUT' THEN -i.QUANTITY ELSE i.QUANTITY END), 0) AS QTY_ON_HAND,
       NVL(SUM(CASE WHEN i.TXN_TYPE = 'OUT' THEN -i.QUANTITY ELSE i.QUANTITY END), 0) * p.AMAZON_PRICE AS TOTAL_VALUE
FROM   EBA_CUST_AMZN_PRODUCTS p
       LEFT JOIN EBA_CUST_AMZN_INVENTORY i ON i.AMZN_PRODUCT_ID = p.ID
WHERE  p.IS_ACTIVE = 'Y'
GROUP BY p.ID, p.ASIN, p.PRODUCT_NAME, p.IMAGE_URL,
         p.AMAZON_PRICE, p.CATEGORY, p.IS_ACTIVE
```

---

## 2. PL/SQL Package

### `EBA_CUST_AMZN_PKG`

#### `SYNC_BESTSELLERS`

```
PROCEDURE SYNC_BESTSELLERS (
    p_url         IN  VARCHAR2 DEFAULT 'https://www.amazon.com/bestsellers',
    p_found       OUT NUMBER,
    p_updated     OUT NUMBER,
    p_status      OUT VARCHAR2,
    p_error_msg   OUT VARCHAR2
)
```

Logic:
1. Call `APEX_WEB_SERVICE.MAKE_REST_REQUEST` to fetch Amazon Best Sellers HTML
2. Parse HTML to extract product entries (name, ASIN, price, image URL, rank, category)
3. MERGE into `EBA_CUST_AMZN_PRODUCTS` — update existing ASINs, insert new ones
4. Set `LAST_SYNCED` to SYSTIMESTAMP for all touched records
5. Log to `EBA_CUST_AMZN_SYNC_LOG`
6. Return counts and status via OUT parameters

Uses `APEX_WEB_SERVICE` for HTTP requests. No ACL changes needed (already configured).

#### `GET_PRODUCT_DETAILS`

```
PROCEDURE GET_PRODUCT_DETAILS (
    p_amzn_product_id IN NUMBER
)
```

Fetches individual product page for extended description and higher-res image. Updates the product record.

#### `CALC_BALANCE`

```
FUNCTION CALC_BALANCE (
    p_amzn_product_id IN NUMBER
) RETURN NUMBER
```

Returns current quantity on hand for a given product.

---

## 3. APEX Pages

All new pages in page group **Inventory**.

### Page 200 — Inventory Dashboard (Normal)

**Region 1: Metric Cards** (Static Content / Cards)
- Total Products: `SELECT COUNT(*) FROM EBA_CUST_AMZN_PRODUCTS WHERE IS_ACTIVE = 'Y'`
- Total Stock Value: `SELECT TO_CHAR(NVL(SUM(QTY_ON_HAND * AMAZON_PRICE), 0), 'FML999G999G990D00') FROM EBA_CUST_AMZN_BALANCE_V`
- Low Stock (< 5): `SELECT COUNT(*) FROM EBA_CUST_AMZN_BALANCE_V WHERE QTY_ON_HAND < 5`

**Region 2: Stock Balances** (Interactive Report)
- Source: `EBA_CUST_AMZN_BALANCE_V`
- Columns: Product Name, ASIN, Category, Amazon Price, Qty on Hand, Total Value
- Link column on Product Name → page 202

Authorization: CONTRIBUTION RIGHTS

### Page 201 — Amazon Products (Normal)

**Region: Products** (Cards)
- Source: `EBA_CUST_AMZN_PRODUCTS`
- Card layout: image (IMAGE_URL), title (PRODUCT_NAME), subtitle (ASIN), body (CATEGORY, AMAZON_PRICE, AMAZON_RANK)
- Click → page 202

**Button: Sync from Amazon**
- Position: Right of region header
- Action: Submit page → page process calls `EBA_CUST_AMZN_PKG.SYNC_BESTSELLERS`
- Authorization: ADMINISTRATION RIGHTS
- Success message: "Synced {n} products from Amazon"

**Button: View Sync Log**
- Opens page 205 as modal

Authorization: CONTRIBUTION RIGHTS

### Page 202 — Amazon Product Detail (Modal Dialog)

**Region: Product Form** (Form on `EBA_CUST_AMZN_PRODUCTS`)
- Items: PRODUCT_NAME (text), ASIN (text, read-only after create), DESCRIPTION (textarea), AMAZON_PRICE (number), CATEGORY (text), AMAZON_URL (URL), IMAGE_URL (URL with preview), IS_ACTIVE (switch)
- Item: PRODUCT_ID — Select List, LOV: `SELECT PRODUCT_NAME d, ID r FROM EBA_CUST_PRODUCTS WHERE IS_ACTIVE = 'Y' ORDER BY 1` (optional link to internal product)

Standard DML process (insert/update/delete).
Authorization: CONTRIBUTION RIGHTS

### Page 203 — Inventory Transactions (Normal)

**Region: Transactions** (Interactive Report)
- Source: `EBA_CUST_AMZN_INVENTORY i JOIN EBA_CUST_AMZN_PRODUCTS p ON p.ID = i.AMZN_PRODUCT_ID`
- Columns: TXN_DATE, Product Name, TXN_TYPE, QUANTITY, UNIT_PRICE, NOTES, CREATED_BY
- Default sort: TXN_DATE DESC

**Button: Add Transaction**
- Opens page 204 as modal

Authorization: CONTRIBUTION RIGHTS

### Page 204 — Add Transaction (Modal Dialog)

**Region: Transaction Form** (Form on `EBA_CUST_AMZN_INVENTORY`)
- Items:
  - AMZN_PRODUCT_ID — Select List, LOV: `SELECT PRODUCT_NAME || ' (' || ASIN || ')' d, ID r FROM EBA_CUST_AMZN_PRODUCTS WHERE IS_ACTIVE = 'Y' ORDER BY 1`
  - TXN_TYPE — Select List, static LOV: IN=Receiving, OUT=Sale/Write-off, ADJUST=Adjustment
  - QUANTITY — Number field
  - UNIT_PRICE — Number field
  - TXN_DATE — Date Picker, default SYSDATE
  - NOTES — Textarea

Standard DML process (insert only — transactions are immutable).
Authorization: CONTRIBUTION RIGHTS

### Page 205 — Sync Log (Modal Dialog)

**Region: Sync History** (Interactive Report)
- Source: `EBA_CUST_AMZN_SYNC_LOG`
- Columns: SYNC_DATE, PRODUCTS_FOUND, PRODUCTS_UPDATED, STATUS, ERROR_MESSAGE, CREATED_BY
- Default sort: SYNC_DATE DESC

Authorization: ADMINISTRATION RIGHTS

---

## 4. Navigation

Add to **Application Navigation** list:

| Entry Text | Target | Display Seq | Parent |
|------------|--------|-------------|--------|
| Inventory | — (non-clickable) | 45 | Top-level |
| Dashboard | Page 200 | 46 | Inventory |
| Amazon Products | Page 201 | 47 | Inventory |
| Transactions | Page 203 | 48 | Inventory |

---

## 5. Dashboard Integration (Page 1)

Add a new region to the existing Dashboard:
- Type: Static Content with PL/SQL source
- Title: "Inventory Summary"
- Content: Renders summary (total products, total value, low stock count) with a link to page 200
- Position: After existing regions
- Authorization: CONTRIBUTION RIGHTS

---

## 6. Authorization

| Action | Scheme |
|--------|--------|
| View Inventory pages (200-204) | CONTRIBUTION RIGHTS |
| Sync from Amazon (button on 201) | ADMINISTRATION RIGHTS |
| View Sync Log (205) | ADMINISTRATION RIGHTS |
| Add/edit transactions | CONTRIBUTION RIGHTS |
| Edit Amazon product details | CONTRIBUTION RIGHTS |

---

## 7. Implementation Order

1. DDL — Create tables, view, indexes, FK constraints
2. PL/SQL — Create `EBA_CUST_AMZN_PKG` package (spec + body)
3. APEX Pages — Build pages 200-205 via export/patch/import
4. Navigation — Add Inventory entries to Application Navigation list
5. Dashboard — Add Inventory Summary region to page 1
6. Validation — Compile check, test sync, test transactions, verify balances

---

## 8. Limitations & Notes

- Amazon HTML parsing is brittle — structure may change. The PL/SQL parser handles the current bestsellers page format.
- No JavaScript rendering in PL/SQL — works because the bestsellers page is server-rendered HTML.
- Sync is manual (button press), no automated scheduling in this version.
- Transaction quantities: always entered as positive numbers. Sign logic is in the balance view (OUT subtracts, IN/ADJUST add).
- No approval workflow — transactions are immediate and immutable.
