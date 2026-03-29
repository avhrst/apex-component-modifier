# Amazon Inventory Module — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add an Amazon product tracking and inventory module to APEX app 130 (Customers), demonstrating deterministic vibe coding.

**Architecture:** New DB objects (3 tables, 1 view, 1 package, triggers) under DVC schema with `EBA_CUST_AMZN_*` prefix. 6 new APEX pages (200-205) in "Inventory" page group, built via the `/apex` skill (export/patch/import). Navigation and dashboard integration with existing app.

**Tech Stack:** Oracle Database 23ai, Oracle APEX (Universal Theme 42), SQLcl CLI (`sql -name dvc`), PL/SQL, `APEX_WEB_SERVICE` for HTTP requests.

**Spec:** `docs/superpowers/specs/2026-03-29-amazon-inventory-module-design.md`

**Connection:** `sql -name dvc` (schema DVC, localhost/freepdb1)

**APEX App:** 130 (Customers), Workspace DVC

---

## File Structure

All changes are database objects and APEX metadata — no local files are created. Work is done via SQLcl CLI commands.

| Object | Type | Purpose |
|--------|------|---------|
| `EBA_CUST_AMZN_PRODUCTS` | Table | Amazon product catalog |
| `EBA_CUST_AMZN_INVENTORY` | Table | Inventory transactions |
| `EBA_CUST_AMZN_SYNC_LOG` | Table | Scrape history |
| `BIU_EBA_CUST_AMZN_PRODUCTS` | Trigger | Audit columns for products |
| `BIU_EBA_CUST_AMZN_INVENTORY` | Trigger | Audit columns for inventory |
| `BIU_EBA_CUST_AMZN_SYNC_LOG` | Trigger | Audit columns for sync log |
| `EBA_CUST_AMZN_BALANCE_V` | View | Stock balance per product |
| `EBA_CUST_AMZN_PKG` | Package + Body | Sync, details, balance logic |
| APEX Pages 200-205 | APEX Metadata | Inventory module UI |
| Application Navigation list | APEX Metadata | Sidebar nav entries |
| Page 1 region | APEX Metadata | Dashboard integration |

---

## Task 1: Create Tables

- [ ] **Step 1: Create `EBA_CUST_AMZN_PRODUCTS` table**

```bash
sql -S -name dvc <<'SQL'
CREATE TABLE eba_cust_amzn_products (
    id                 NUMBER        NOT NULL,
    asin               VARCHAR2(20)  NOT NULL,
    product_name       VARCHAR2(500) NOT NULL,
    description        VARCHAR2(4000),
    image_url          VARCHAR2(1000),
    amazon_price       NUMBER(10,2),
    amazon_rank        NUMBER,
    category           VARCHAR2(255),
    amazon_url         VARCHAR2(1000),
    product_id         NUMBER,
    is_active          VARCHAR2(1)   DEFAULT 'Y' NOT NULL,
    last_synced        TIMESTAMP WITH TIME ZONE,
    row_version_number NUMBER,
    created            TIMESTAMP(6) WITH TIME ZONE NOT NULL,
    created_by         VARCHAR2(255) NOT NULL,
    updated            TIMESTAMP(6) WITH TIME ZONE,
    updated_by         VARCHAR2(255),
    CONSTRAINT eba_cust_amzn_prod_pk PRIMARY KEY (id),
    CONSTRAINT eba_cust_amzn_prod_asin_uk UNIQUE (asin),
    CONSTRAINT eba_cust_amzn_prod_active_ck CHECK (is_active IN ('Y','N')),
    CONSTRAINT eba_cust_amzn_prod_prod_fk FOREIGN KEY (product_id) REFERENCES eba_cust_products(id)
);

CREATE INDEX eba_cust_amzn_prod_prod_idx ON eba_cust_amzn_products(product_id);

COMMENT ON TABLE eba_cust_amzn_products IS 'Amazon marketplace products synced from Best Sellers';
SQL
```

Expected: `Table EBA_CUST_AMZN_PRODUCTS created.` + index + comment.

- [ ] **Step 2: Create `EBA_CUST_AMZN_INVENTORY` table**

```bash
sql -S -name dvc <<'SQL'
CREATE TABLE eba_cust_amzn_inventory (
    id                 NUMBER        NOT NULL,
    amzn_product_id    NUMBER        NOT NULL,
    txn_type           VARCHAR2(10)  NOT NULL,
    quantity           NUMBER        NOT NULL,
    unit_price         NUMBER(10,2),
    txn_date           DATE          DEFAULT SYSDATE NOT NULL,
    notes              VARCHAR2(4000),
    row_version_number NUMBER,
    created            TIMESTAMP(6) WITH TIME ZONE NOT NULL,
    created_by         VARCHAR2(255) NOT NULL,
    CONSTRAINT eba_cust_amzn_inv_pk PRIMARY KEY (id),
    CONSTRAINT eba_cust_amzn_inv_type_ck CHECK (txn_type IN ('IN','OUT','ADJUST')),
    CONSTRAINT eba_cust_amzn_inv_qty_ck CHECK (quantity > 0),
    CONSTRAINT eba_cust_amzn_inv_prod_fk FOREIGN KEY (amzn_product_id) REFERENCES eba_cust_amzn_products(id)
);

CREATE INDEX eba_cust_amzn_inv_prod_idx ON eba_cust_amzn_inventory(amzn_product_id);
CREATE INDEX eba_cust_amzn_inv_date_idx ON eba_cust_amzn_inventory(txn_date);

COMMENT ON TABLE eba_cust_amzn_inventory IS 'Inventory transactions for Amazon products (IN/OUT/ADJUST)';
SQL
```

Expected: Table + 2 indexes + comment created.

- [ ] **Step 3: Create `EBA_CUST_AMZN_SYNC_LOG` table**

```bash
sql -S -name dvc <<'SQL'
CREATE TABLE eba_cust_amzn_sync_log (
    id                 NUMBER        NOT NULL,
    sync_date          TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    products_found     NUMBER,
    products_updated   NUMBER,
    status             VARCHAR2(20),
    error_message      VARCHAR2(4000),
    row_version_number NUMBER,
    created_by         VARCHAR2(255) NOT NULL,
    CONSTRAINT eba_cust_amzn_sync_pk PRIMARY KEY (id),
    CONSTRAINT eba_cust_amzn_sync_sts_ck CHECK (status IN ('SUCCESS','PARTIAL','FAILED'))
);

COMMENT ON TABLE eba_cust_amzn_sync_log IS 'Log of Amazon Best Sellers sync operations';
SQL
```

Expected: Table + comment created.

- [ ] **Step 4: Verify all tables exist**

```bash
sql -S -name dvc <<'SQL'
SELECT table_name FROM user_tables WHERE table_name LIKE 'EBA_CUST_AMZN%' ORDER BY 1;
SQL
```

Expected output:
```
EBA_CUST_AMZN_INVENTORY
EBA_CUST_AMZN_PRODUCTS
EBA_CUST_AMZN_SYNC_LOG
```

---

## Task 2: Create BIU Triggers

Following the existing app pattern (see `BIU_EBA_CUST_ACTIVITIES`): ID via `sys_guid()`, audit columns via `v('APP_USER')`, `row_version_number` tracking.

- [ ] **Step 1: Create trigger for `EBA_CUST_AMZN_PRODUCTS`**

```bash
sql -S -name dvc <<'SQLEND'
CREATE OR REPLACE TRIGGER biu_eba_cust_amzn_products
    BEFORE INSERT OR UPDATE ON eba_cust_amzn_products
    FOR EACH ROW
BEGIN
    IF inserting THEN
        IF :new.id IS NULL THEN
            :new.id := to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
        END IF;
        :new.created    := current_timestamp;
        :new.created_by := nvl(v('APP_USER'), user);
        :new.row_version_number := 1;
    ELSE
        :new.row_version_number := nvl(:new.row_version_number, 0) + 1;
    END IF;
    :new.updated    := current_timestamp;
    :new.updated_by := nvl(v('APP_USER'), user);
END biu_eba_cust_amzn_products;
/
SQLEND
```

Expected: `Trigger BIU_EBA_CUST_AMZN_PRODUCTS compiled`

- [ ] **Step 2: Create trigger for `EBA_CUST_AMZN_INVENTORY`**

```bash
sql -S -name dvc <<'SQLEND'
CREATE OR REPLACE TRIGGER biu_eba_cust_amzn_inventory
    BEFORE INSERT OR UPDATE ON eba_cust_amzn_inventory
    FOR EACH ROW
BEGIN
    IF inserting THEN
        IF :new.id IS NULL THEN
            :new.id := to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
        END IF;
        :new.created    := current_timestamp;
        :new.created_by := nvl(v('APP_USER'), user);
        :new.row_version_number := 1;
    ELSE
        :new.row_version_number := nvl(:new.row_version_number, 0) + 1;
    END IF;
END biu_eba_cust_amzn_inventory;
/
SQLEND
```

Expected: `Trigger BIU_EBA_CUST_AMZN_INVENTORY compiled`

- [ ] **Step 3: Create trigger for `EBA_CUST_AMZN_SYNC_LOG`**

```bash
sql -S -name dvc <<'SQLEND'
CREATE OR REPLACE TRIGGER biu_eba_cust_amzn_sync_log
    BEFORE INSERT OR UPDATE ON eba_cust_amzn_sync_log
    FOR EACH ROW
BEGIN
    IF inserting THEN
        IF :new.id IS NULL THEN
            :new.id := to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
        END IF;
        :new.created_by := nvl(v('APP_USER'), user);
        :new.row_version_number := 1;
    ELSE
        :new.row_version_number := nvl(:new.row_version_number, 0) + 1;
    END IF;
END biu_eba_cust_amzn_sync_log;
/
SQLEND
```

Expected: `Trigger BIU_EBA_CUST_AMZN_SYNC_LOG compiled`

- [ ] **Step 4: Verify triggers are valid**

```bash
sql -S -name dvc <<'SQL'
SELECT trigger_name, status FROM user_triggers WHERE trigger_name LIKE 'BIU_EBA_CUST_AMZN%' ORDER BY 1;
SQL
```

Expected: all 3 triggers with status `ENABLED`.

---

## Task 3: Create Balance View

- [ ] **Step 1: Create `EBA_CUST_AMZN_BALANCE_V`**

```bash
sql -S -name dvc <<'SQLEND'
CREATE OR REPLACE VIEW eba_cust_amzn_balance_v AS
SELECT p.id,
       p.asin,
       p.product_name,
       p.image_url,
       p.amazon_price,
       p.category,
       p.is_active,
       NVL(SUM(CASE WHEN i.txn_type = 'OUT' THEN -i.quantity ELSE i.quantity END), 0) AS qty_on_hand,
       NVL(SUM(CASE WHEN i.txn_type = 'OUT' THEN -i.quantity ELSE i.quantity END), 0) * p.amazon_price AS total_value
FROM   eba_cust_amzn_products p
       LEFT JOIN eba_cust_amzn_inventory i ON i.amzn_product_id = p.id
WHERE  p.is_active = 'Y'
GROUP BY p.id, p.asin, p.product_name, p.image_url,
         p.amazon_price, p.category, p.is_active;
SQLEND
```

Expected: `View EBA_CUST_AMZN_BALANCE_V created.`

- [ ] **Step 2: Verify view compiles**

```bash
sql -S -name dvc <<'SQL'
SELECT object_name, status FROM user_objects WHERE object_name = 'EBA_CUST_AMZN_BALANCE_V';
SQL
```

Expected: status `VALID`.

---

## Task 4: Create PL/SQL Package

- [ ] **Step 1: Create package specification**

```bash
sql -S -name dvc <<'SQLEND'
CREATE OR REPLACE PACKAGE eba_cust_amzn_pkg AS

    PROCEDURE sync_bestsellers (
        p_url         IN  VARCHAR2 DEFAULT 'https://www.amazon.com/gp/bestsellers/',
        p_found       OUT NUMBER,
        p_updated     OUT NUMBER,
        p_status      OUT VARCHAR2,
        p_error_msg   OUT VARCHAR2
    );

    PROCEDURE get_product_details (
        p_amzn_product_id IN NUMBER
    );

    FUNCTION calc_balance (
        p_amzn_product_id IN NUMBER
    ) RETURN NUMBER;

END eba_cust_amzn_pkg;
/
SQLEND
```

Expected: `Package EBA_CUST_AMZN_PKG compiled`

- [ ] **Step 2: Create package body**

```bash
sql -S -name dvc <<'SQLEND'
CREATE OR REPLACE PACKAGE BODY eba_cust_amzn_pkg AS

    ----------------------------------------
    -- SYNC_BESTSELLERS
    -- Fetches Amazon Best Sellers HTML page,
    -- parses product entries, merges into local table.
    ----------------------------------------
    PROCEDURE sync_bestsellers (
        p_url         IN  VARCHAR2 DEFAULT 'https://www.amazon.com/gp/bestsellers/',
        p_found       OUT NUMBER,
        p_updated     OUT NUMBER,
        p_status      OUT VARCHAR2,
        p_error_msg   OUT VARCHAR2
    ) IS
        l_html       CLOB;
        l_chunk      VARCHAR2(32767);
        l_pos        NUMBER;
        l_end        NUMBER;
        l_asin       VARCHAR2(20);
        l_name       VARCHAR2(500);
        l_price_str  VARCHAR2(50);
        l_price      NUMBER(10,2);
        l_img        VARCHAR2(1000);
        l_rank       NUMBER := 0;
        l_found      NUMBER := 0;
        l_updated    NUMBER := 0;
    BEGIN
        -- Fetch the page
        l_html := apex_web_service.make_rest_request(
            p_url         => p_url,
            p_http_method => 'GET'
        );

        -- Parse product entries from HTML
        -- Amazon bestsellers use data-asin attribute on product containers
        l_pos := 1;
        LOOP
            -- Find next product ASIN
            l_pos := INSTR(l_html, 'data-asin="', l_pos);
            EXIT WHEN l_pos = 0 OR l_pos IS NULL;

            l_pos  := l_pos + LENGTH('data-asin="');
            l_end  := INSTR(l_html, '"', l_pos);
            l_asin := SUBSTR(l_html, l_pos, l_end - l_pos);

            -- Skip empty ASINs
            IF l_asin IS NOT NULL AND LENGTH(TRIM(l_asin)) > 0 THEN
                l_rank := l_rank + 1;

                -- Extract product name: look for class containing "p13n-sc-truncate" or similar title class
                l_name := NULL;
                DECLARE
                    l_name_start NUMBER;
                    l_name_end   NUMBER;
                    l_search_from NUMBER := l_pos;
                BEGIN
                    -- Look for the product title span within next 5000 chars
                    l_chunk := SUBSTR(l_html, l_search_from, 5000);

                    -- Try _cDEzb_p13n-sc-css-line-clamp-3 pattern (common in bestsellers)
                    l_name_start := INSTR(l_chunk, 'p13n-sc-truncate');
                    IF l_name_start > 0 THEN
                        l_name_start := INSTR(l_chunk, '>', l_name_start) + 1;
                        l_name_end   := INSTR(l_chunk, '<', l_name_start);
                        IF l_name_end > l_name_start THEN
                            l_name := TRIM(SUBSTR(l_chunk, l_name_start, l_name_end - l_name_start));
                        END IF;
                    END IF;

                    -- Fallback: try aria-label on link
                    IF l_name IS NULL THEN
                        l_name_start := INSTR(l_chunk, 'aria-label="');
                        IF l_name_start > 0 THEN
                            l_name_start := l_name_start + LENGTH('aria-label="');
                            l_name_end   := INSTR(l_chunk, '"', l_name_start);
                            IF l_name_end > l_name_start THEN
                                l_name := TRIM(SUBSTR(l_chunk, l_name_start, l_name_end - l_name_start));
                            END IF;
                        END IF;
                    END IF;

                    IF l_name IS NULL THEN
                        l_name := 'Amazon Product ' || l_asin;
                    END IF;
                    -- Truncate if too long
                    l_name := SUBSTR(l_name, 1, 500);
                END;

                -- Extract price
                l_price := NULL;
                DECLARE
                    l_price_start NUMBER;
                    l_price_end   NUMBER;
                BEGIN
                    l_chunk := SUBSTR(l_html, l_pos, 5000);
                    l_price_start := INSTR(l_chunk, '_cDEzb_p13n-sc-price');
                    IF l_price_start = 0 THEN
                        l_price_start := INSTR(l_chunk, 'a-price-whole');
                    END IF;
                    IF l_price_start > 0 THEN
                        l_price_start := INSTR(l_chunk, '$', l_price_start);
                        IF l_price_start > 0 THEN
                            l_price_str := REGEXP_SUBSTR(SUBSTR(l_chunk, l_price_start), '[0-9]+\.?[0-9]*');
                            BEGIN
                                l_price := TO_NUMBER(l_price_str);
                            EXCEPTION WHEN OTHERS THEN
                                l_price := NULL;
                            END;
                        END IF;
                    END IF;
                END;

                -- Extract image URL
                l_img := NULL;
                DECLARE
                    l_img_start NUMBER;
                    l_img_end   NUMBER;
                BEGIN
                    l_chunk := SUBSTR(l_html, l_pos, 5000);
                    l_img_start := INSTR(l_chunk, 'src="https://images-na.ssl-images-amazon.com');
                    IF l_img_start = 0 THEN
                        l_img_start := INSTR(l_chunk, 'src="https://m.media-amazon.com');
                    END IF;
                    IF l_img_start > 0 THEN
                        l_img_start := l_img_start + LENGTH('src="');
                        l_img_end   := INSTR(l_chunk, '"', l_img_start);
                        IF l_img_end > l_img_start THEN
                            l_img := SUBSTR(l_chunk, l_img_start, l_img_end - l_img_start);
                            l_img := SUBSTR(l_img, 1, 1000);
                        END IF;
                    END IF;
                END;

                -- MERGE into products table
                MERGE INTO eba_cust_amzn_products tgt
                USING (SELECT l_asin AS asin FROM dual) src
                ON (tgt.asin = src.asin)
                WHEN MATCHED THEN UPDATE SET
                    tgt.product_name = l_name,
                    tgt.amazon_price = NVL(l_price, tgt.amazon_price),
                    tgt.amazon_rank  = l_rank,
                    tgt.image_url    = NVL(l_img, tgt.image_url),
                    tgt.amazon_url   = 'https://www.amazon.com/dp/' || l_asin,
                    tgt.last_synced  = SYSTIMESTAMP
                WHEN NOT MATCHED THEN INSERT (
                    asin, product_name, amazon_price, amazon_rank,
                    image_url, amazon_url, is_active, last_synced
                ) VALUES (
                    l_asin, l_name, l_price, l_rank,
                    l_img, 'https://www.amazon.com/dp/' || l_asin, 'Y', SYSTIMESTAMP
                );

                l_found := l_found + 1;
                IF SQL%ROWCOUNT > 0 THEN
                    l_updated := l_updated + 1;
                END IF;
            END IF;

            l_pos := l_end + 1;
        END LOOP;

        COMMIT;

        p_found     := l_found;
        p_updated   := l_updated;
        p_status    := CASE WHEN l_found > 0 THEN 'SUCCESS' ELSE 'PARTIAL' END;
        p_error_msg := NULL;

        -- Log the sync
        INSERT INTO eba_cust_amzn_sync_log (sync_date, products_found, products_updated, status, created_by)
        VALUES (SYSTIMESTAMP, p_found, p_updated, p_status, NVL(v('APP_USER'), USER));
        COMMIT;

    EXCEPTION WHEN OTHERS THEN
        p_found     := 0;
        p_updated   := 0;
        p_status    := 'FAILED';
        p_error_msg := SQLERRM;

        INSERT INTO eba_cust_amzn_sync_log (sync_date, products_found, products_updated, status, error_message, created_by)
        VALUES (SYSTIMESTAMP, 0, 0, 'FAILED', SQLERRM, NVL(v('APP_USER'), USER));
        COMMIT;
    END sync_bestsellers;

    ----------------------------------------
    -- GET_PRODUCT_DETAILS
    -- Fetches individual Amazon product page
    -- for extended description and image.
    ----------------------------------------
    PROCEDURE get_product_details (
        p_amzn_product_id IN NUMBER
    ) IS
        l_url    VARCHAR2(1000);
        l_html   CLOB;
        l_desc   VARCHAR2(4000);
        l_img    VARCHAR2(1000);
        l_start  NUMBER;
        l_end    NUMBER;
        l_chunk  VARCHAR2(32767);
    BEGIN
        SELECT amazon_url INTO l_url
        FROM eba_cust_amzn_products
        WHERE id = p_amzn_product_id;

        IF l_url IS NULL THEN
            RETURN;
        END IF;

        l_html := apex_web_service.make_rest_request(
            p_url         => l_url,
            p_http_method => 'GET'
        );

        -- Extract product description from feature bullets
        l_chunk := SUBSTR(l_html, 1, 32767);
        l_start := INSTR(l_chunk, 'id="feature-bullets"');
        IF l_start > 0 THEN
            l_chunk := SUBSTR(l_html, l_start, 8000);
            -- Strip HTML tags for a plain-text description
            l_desc := REGEXP_REPLACE(l_chunk, '<[^>]+>', ' ');
            l_desc := REGEXP_REPLACE(l_desc, '\s+', ' ');
            l_desc := TRIM(SUBSTR(l_desc, 1, 4000));
        END IF;

        -- Extract higher-res main image
        l_chunk := SUBSTR(l_html, 1, 32767);
        l_start := INSTR(l_chunk, 'id="landingImage"');
        IF l_start > 0 THEN
            l_start := INSTR(l_chunk, 'src="', l_start) + LENGTH('src="');
            l_end   := INSTR(l_chunk, '"', l_start);
            IF l_end > l_start THEN
                l_img := SUBSTR(l_chunk, l_start, LEAST(l_end - l_start, 1000));
            END IF;
        END IF;

        UPDATE eba_cust_amzn_products
        SET    description = NVL(l_desc, description),
               image_url   = NVL(l_img, image_url),
               last_synced = SYSTIMESTAMP
        WHERE  id = p_amzn_product_id;

        COMMIT;

    EXCEPTION WHEN OTHERS THEN
        NULL; -- Silently fail on detail fetch; product still exists from sync
    END get_product_details;

    ----------------------------------------
    -- CALC_BALANCE
    -- Returns current quantity on hand.
    ----------------------------------------
    FUNCTION calc_balance (
        p_amzn_product_id IN NUMBER
    ) RETURN NUMBER IS
        l_balance NUMBER;
    BEGIN
        SELECT NVL(SUM(CASE WHEN txn_type = 'OUT' THEN -quantity ELSE quantity END), 0)
        INTO   l_balance
        FROM   eba_cust_amzn_inventory
        WHERE  amzn_product_id = p_amzn_product_id;

        RETURN l_balance;
    END calc_balance;

END eba_cust_amzn_pkg;
/
SQLEND
```

Expected: `Package Body EBA_CUST_AMZN_PKG compiled`

- [ ] **Step 3: Verify package is valid**

```bash
sql -S -name dvc <<'SQL'
SELECT object_name, object_type, status
FROM user_objects
WHERE object_name = 'EBA_CUST_AMZN_PKG'
ORDER BY object_type;
SQL
```

Expected: PACKAGE `VALID`, PACKAGE BODY `VALID`.

---

## Task 5: Test Database Layer

Insert test data to confirm tables, triggers, view, and package work together before building APEX pages.

- [ ] **Step 1: Insert test products**

```bash
sql -S -name dvc <<'SQL'
INSERT INTO eba_cust_amzn_products (asin, product_name, amazon_price, amazon_rank, category, is_active, amazon_url)
VALUES ('B0TEST00001', 'Test Wireless Earbuds', 29.99, 1, 'Electronics', 'Y', 'https://www.amazon.com/dp/B0TEST00001');

INSERT INTO eba_cust_amzn_products (asin, product_name, amazon_price, amazon_rank, category, is_active, amazon_url)
VALUES ('B0TEST00002', 'Test Phone Charger', 12.99, 2, 'Electronics', 'Y', 'https://www.amazon.com/dp/B0TEST00002');

COMMIT;

SELECT id, asin, product_name, created_by, row_version_number FROM eba_cust_amzn_products ORDER BY asin;
SQL
```

Expected: 2 rows with IDs generated by trigger, `created_by` populated, `row_version_number = 1`.

- [ ] **Step 2: Insert test inventory transactions**

```bash
sql -S -name dvc <<'SQL'
-- Receive 100 earbuds
INSERT INTO eba_cust_amzn_inventory (amzn_product_id, txn_type, quantity, unit_price, notes)
SELECT id, 'IN', 100, 29.99, 'Initial stock' FROM eba_cust_amzn_products WHERE asin = 'B0TEST00001';

-- Sell 30 earbuds
INSERT INTO eba_cust_amzn_inventory (amzn_product_id, txn_type, quantity, unit_price, notes)
SELECT id, 'OUT', 30, 34.99, 'Online sale' FROM eba_cust_amzn_products WHERE asin = 'B0TEST00001';

-- Receive 50 chargers
INSERT INTO eba_cust_amzn_inventory (amzn_product_id, txn_type, quantity, unit_price, notes)
SELECT id, 'IN', 50, 12.99, 'Initial stock' FROM eba_cust_amzn_products WHERE asin = 'B0TEST00002';

COMMIT;
SQL
```

Expected: 3 rows inserted.

- [ ] **Step 3: Verify balance view**

```bash
sql -S -name dvc <<'SQL'
SELECT product_name, qty_on_hand, total_value FROM eba_cust_amzn_balance_v ORDER BY product_name;
SQL
```

Expected:
```
Test Phone Charger    50    649.50
Test Wireless Earbuds 70   2099.30
```

- [ ] **Step 4: Verify calc_balance function**

```bash
sql -S -name dvc <<'SQL'
SELECT p.product_name, eba_cust_amzn_pkg.calc_balance(p.id) AS balance
FROM eba_cust_amzn_products p
ORDER BY p.product_name;
SQL
```

Expected: same balances as the view (50 and 70).

- [ ] **Step 5: Clean up test data**

```bash
sql -S -name dvc <<'SQL'
DELETE FROM eba_cust_amzn_inventory;
DELETE FROM eba_cust_amzn_products;
COMMIT;
SQL
```

Expected: rows deleted, clean slate for APEX pages.

---

## Task 6: Build APEX Page 201 — Amazon Products (Cards)

Use the `/apex` skill to export a reference page, patch it, and import.

- [ ] **Step 1: Export an existing cards-style page as reference**

Look at existing Products page (page 44) for patterns. Use the `/apex` skill:

```
/apex dvc 130 PAGE:44 -- export page 44 as a reference for cards layout
```

- [ ] **Step 2: Create page 201 (Amazon Products) using /apex skill**

```
/apex dvc 130 PAGE:201 -- create new page "Amazon Products" with Cards region on EBA_CUST_AMZN_PRODUCTS, "Sync from Amazon" button (ADMINISTRATION RIGHTS auth), "View Sync Log" button opening page 205 as modal. Cards show IMAGE_URL as media, PRODUCT_NAME as title, ASIN as subtitle, CATEGORY and AMAZON_PRICE in body. Card click links to page 202. Page group: Inventory. Page authorization: CONTRIBUTION RIGHTS.
```

- [ ] **Step 3: Add sync page process**

The page process should call `EBA_CUST_AMZN_PKG.SYNC_BESTSELLERS` when the Sync button is pressed. Use `/apex` to patch:

```
/apex dvc 130 PROCESS:201 -- add page process "Sync Amazon Products" on page 201, PL/SQL type, fires on SUBMIT when SYNC button pressed. Code:
DECLARE
    l_found NUMBER; l_updated NUMBER; l_status VARCHAR2(20); l_error VARCHAR2(4000);
BEGIN
    eba_cust_amzn_pkg.sync_bestsellers(p_found => l_found, p_updated => l_updated, p_status => l_status, p_error_msg => l_error);
    IF l_status = 'FAILED' THEN
        apex_error.add_error(p_message => 'Sync failed: ' || l_error, p_display_location => apex_error.c_on_error_page);
    ELSE
        apex_application.g_print_success_message := 'Synced ' || l_found || ' products (' || l_updated || ' updated)';
    END IF;
END;
```

- [ ] **Step 4: Verify page 201 exists**

```bash
sql -S -name dvc <<'SQL'
SELECT page_id, page_name, page_group FROM apex_application_pages WHERE application_id = 130 AND page_id = 201;
SQL
```

Expected: page 201, "Amazon Products", group "Inventory".

---

## Task 7: Build APEX Page 202 — Amazon Product Detail (Modal)

- [ ] **Step 1: Create page 202 using /apex skill**

```
/apex dvc 130 PAGE:202 -- create modal dialog page "Amazon Product Detail" with Form region on EBA_CUST_AMZN_PRODUCTS. Items: P202_ID (hidden PK), P202_PRODUCT_NAME (text), P202_ASIN (text, read-only when not inserting), P202_DESCRIPTION (textarea), P202_AMAZON_PRICE (number), P202_CATEGORY (text), P202_AMAZON_URL (URL), P202_IMAGE_URL (text with image preview), P202_IS_ACTIVE (switch Y/N), P202_PRODUCT_ID (select list, LOV: SELECT PRODUCT_NAME d, ID r FROM EBA_CUST_PRODUCTS WHERE IS_ACTIVE = 'Y' ORDER BY 1, nullable, label "Link to Internal Product"). Standard DML process (insert/update/delete). Page group: Inventory. Authorization: CONTRIBUTION RIGHTS.
```

- [ ] **Step 2: Verify page 202 exists**

```bash
sql -S -name dvc <<'SQL'
SELECT page_id, page_name, page_mode, page_group FROM apex_application_pages WHERE application_id = 130 AND page_id = 202;
SQL
```

Expected: page 202, "Amazon Product Detail", "Modal Dialog", "Inventory".

---

## Task 8: Build APEX Page 203 — Inventory Transactions (IR)

- [ ] **Step 1: Create page 203 using /apex skill**

```
/apex dvc 130 PAGE:203 -- create normal page "Inventory Transactions" with Interactive Report region. Source SQL:
SELECT i.id,
       i.txn_date,
       p.product_name,
       i.txn_type,
       i.quantity,
       i.unit_price,
       i.notes,
       i.created_by
FROM   eba_cust_amzn_inventory i
JOIN   eba_cust_amzn_products p ON p.id = i.amzn_product_id
ORDER BY i.txn_date DESC
-- "Add Transaction" button opens page 204 as modal dialog. Page group: Inventory. Authorization: CONTRIBUTION RIGHTS.
```

- [ ] **Step 2: Verify page 203 exists**

```bash
sql -S -name dvc <<'SQL'
SELECT page_id, page_name, page_group FROM apex_application_pages WHERE application_id = 130 AND page_id = 203;
SQL
```

Expected: page 203, "Inventory Transactions", "Inventory".

---

## Task 9: Build APEX Page 204 — Add Transaction (Modal Form)

- [ ] **Step 1: Create page 204 using /apex skill**

```
/apex dvc 130 PAGE:204 -- create modal dialog page "Add Transaction" with Form region on EBA_CUST_AMZN_INVENTORY. Items: P204_ID (hidden PK), P204_AMZN_PRODUCT_ID (select list, LOV: SELECT PRODUCT_NAME || ' (' || ASIN || ')' d, ID r FROM EBA_CUST_AMZN_PRODUCTS WHERE IS_ACTIVE = 'Y' ORDER BY 1, required), P204_TXN_TYPE (select list, static LOV: IN;Receiving,OUT;Sale / Write-off,ADJUST;Adjustment, required), P204_QUANTITY (number, required), P204_UNIT_PRICE (number), P204_TXN_DATE (date picker, default SYSDATE, required), P204_NOTES (textarea). DML process insert only (transactions are immutable, no update/delete). Page group: Inventory. Authorization: CONTRIBUTION RIGHTS.
```

- [ ] **Step 2: Verify page 204 exists**

```bash
sql -S -name dvc <<'SQL'
SELECT page_id, page_name, page_mode, page_group FROM apex_application_pages WHERE application_id = 130 AND page_id = 204;
SQL
```

Expected: page 204, "Add Transaction", "Modal Dialog", "Inventory".

---

## Task 10: Build APEX Page 200 — Inventory Dashboard

- [ ] **Step 1: Create page 200 using /apex skill**

```
/apex dvc 130 PAGE:200 -- create normal page "Inventory Dashboard" with two regions.

Region 1: "Inventory Metrics" — Static Content region with 3 cards using PL/SQL source:
DECLARE
    l_products NUMBER;
    l_value    NUMBER;
    l_low      NUMBER;
BEGIN
    SELECT COUNT(*) INTO l_products FROM eba_cust_amzn_products WHERE is_active = 'Y';
    SELECT NVL(SUM(total_value), 0) INTO l_value FROM eba_cust_amzn_balance_v;
    SELECT COUNT(*) INTO l_low FROM eba_cust_amzn_balance_v WHERE qty_on_hand < 5;
    htp.p('<div class="a-CardView" style="display:flex;gap:16px;flex-wrap:wrap;">');
    htp.p('<div class="t-Card" style="flex:1;min-width:200px;padding:16px;background:var(--ut-component-background-color);border-radius:8px;box-shadow:var(--ut-component-shadow);">');
    htp.p('<div class="t-Card-titleWrap"><h3 class="t-Card-title">Total Products</h3></div>');
    htp.p('<div class="t-Card-body"><span style="font-size:2rem;font-weight:bold;">' || l_products || '</span></div></div>');
    htp.p('<div class="t-Card" style="flex:1;min-width:200px;padding:16px;background:var(--ut-component-background-color);border-radius:8px;box-shadow:var(--ut-component-shadow);">');
    htp.p('<div class="t-Card-titleWrap"><h3 class="t-Card-title">Total Stock Value</h3></div>');
    htp.p('<div class="t-Card-body"><span style="font-size:2rem;font-weight:bold;">$' || TO_CHAR(l_value, 'FM999,999,990.00') || '</span></div></div>');
    htp.p('<div class="t-Card" style="flex:1;min-width:200px;padding:16px;background:var(--ut-component-background-color);border-radius:8px;box-shadow:var(--ut-component-shadow);">');
    htp.p('<div class="t-Card-titleWrap"><h3 class="t-Card-title">Low Stock Alerts</h3></div>');
    htp.p('<div class="t-Card-body"><span style="font-size:2rem;font-weight:bold;' || CASE WHEN l_low > 0 THEN 'color:var(--ut-palette-danger);' END || '">' || l_low || '</span></div></div>');
    htp.p('</div>');
END;

Region 2: "Stock Balances" — Interactive Report on EBA_CUST_AMZN_BALANCE_V. Columns: PRODUCT_NAME (link to page 202), ASIN, CATEGORY, AMAZON_PRICE (format FML999G999G990D00), QTY_ON_HAND, TOTAL_VALUE (format FML999G999G990D00). Default sort: PRODUCT_NAME ASC.

Page group: Inventory. Authorization: CONTRIBUTION RIGHTS.
```

- [ ] **Step 2: Verify page 200 exists**

```bash
sql -S -name dvc <<'SQL'
SELECT page_id, page_name, page_group FROM apex_application_pages WHERE application_id = 130 AND page_id = 200;
SQL
```

Expected: page 200, "Inventory Dashboard", "Inventory".

---

## Task 11: Build APEX Page 205 — Sync Log (Modal)

- [ ] **Step 1: Create page 205 using /apex skill**

```
/apex dvc 130 PAGE:205 -- create modal dialog page "Sync Log" with Interactive Report on EBA_CUST_AMZN_SYNC_LOG. Columns: SYNC_DATE, PRODUCTS_FOUND, PRODUCTS_UPDATED, STATUS, ERROR_MESSAGE, CREATED_BY. Default sort: SYNC_DATE DESC. Page group: Inventory. Authorization: ADMINISTRATION RIGHTS.
```

- [ ] **Step 2: Verify page 205 exists**

```bash
sql -S -name dvc <<'SQL'
SELECT page_id, page_name, page_mode, page_group FROM apex_application_pages WHERE application_id = 130 AND page_id = 205;
SQL
```

Expected: page 205, "Sync Log", "Modal Dialog", "Inventory".

---

## Task 12: Add Navigation Entries

- [ ] **Step 1: Add Inventory navigation section using /apex skill**

```
/apex dvc 130 NAV -- add navigation list entries to "Application Navigation" list:
1. "Inventory" — non-clickable parent, display_sequence 45, icon fa-boxes
2. "Dashboard" — target page 200, display_sequence 46, parent "Inventory"
3. "Amazon Products" — target page 201, display_sequence 47, parent "Inventory"
4. "Transactions" — target page 203, display_sequence 48, parent "Inventory"
All entries authorization: CONTRIBUTION RIGHTS.
```

- [ ] **Step 2: Verify navigation entries**

```bash
sql -S -name dvc <<'SQL'
SELECT entry_text, entry_target, display_sequence
FROM apex_application_list_entries
WHERE application_id = 130
AND list_name = 'Application Navigation'
AND display_sequence BETWEEN 45 AND 48
ORDER BY display_sequence;
SQL
```

Expected: 4 entries (Inventory, Dashboard, Amazon Products, Transactions).

---

## Task 13: Add Dashboard Integration (Page 1)

- [ ] **Step 1: Add Inventory Summary region to page 1 using /apex skill**

```
/apex dvc 130 REGION:1 -- add new region to page 1 "Dashboard". Region name: "Inventory Summary". Type: Static Content with PL/SQL source. Display sequence: 136. Position: Body. Authorization: CONTRIBUTION RIGHTS. Source:
DECLARE
    l_products NUMBER;
    l_value    NUMBER;
    l_low      NUMBER;
BEGIN
    SELECT COUNT(*) INTO l_products FROM eba_cust_amzn_products WHERE is_active = 'Y';
    SELECT NVL(SUM(total_value), 0) INTO l_value FROM eba_cust_amzn_balance_v;
    SELECT COUNT(*) INTO l_low FROM eba_cust_amzn_balance_v WHERE qty_on_hand < 5;
    htp.p('<div style="display:flex;gap:12px;align-items:center;">');
    htp.p('<span class="fa fa-boxes" style="font-size:2rem;color:var(--ut-palette-primary);"></span>');
    htp.p('<div>');
    htp.p('<strong>' || l_products || '</strong> Amazon products tracked, ');
    htp.p('<strong>$' || TO_CHAR(l_value, 'FM999,999,990.00') || '</strong> total value');
    IF l_low > 0 THEN
        htp.p(', <span style="color:var(--ut-palette-danger);"><strong>' || l_low || '</strong> low stock</span>');
    END IF;
    htp.p('</div>');
    htp.p('<a href="' || apex_page.get_url(p_page => 200) || '" class="t-Button t-Button--small t-Button--primary">View Inventory</a>');
    htp.p('</div>');
END;
```

- [ ] **Step 2: Verify region exists on page 1**

```bash
sql -S -name dvc <<'SQL'
SELECT region_name, source_type, display_sequence
FROM apex_application_page_regions
WHERE application_id = 130 AND page_id = 1 AND region_name = 'Inventory Summary';
SQL
```

Expected: "Inventory Summary" region on page 1.

---

## Task 14: End-to-End Validation

- [ ] **Step 1: Verify all DB objects are valid**

```bash
sql -S -name dvc <<'SQL'
SELECT object_name, object_type, status
FROM user_objects
WHERE object_name LIKE 'EBA_CUST_AMZN%'
ORDER BY object_type, object_name;
SQL
```

Expected: all objects status `VALID`.

- [ ] **Step 2: Verify all pages exist**

```bash
sql -S -name dvc <<'SQL'
SELECT page_id, page_name, page_mode, page_group
FROM apex_application_pages
WHERE application_id = 130 AND page_id BETWEEN 200 AND 205
ORDER BY page_id;
SQL
```

Expected: 6 pages (200-205) all in "Inventory" group.

- [ ] **Step 3: Verify navigation**

```bash
sql -S -name dvc <<'SQL'
SELECT entry_text, display_sequence
FROM apex_application_list_entries
WHERE application_id = 130
AND list_name = 'Application Navigation'
AND display_sequence BETWEEN 45 AND 48
ORDER BY display_sequence;
SQL
```

Expected: 4 navigation entries.

- [ ] **Step 4: Test sync (if network available)**

```bash
sql -S -name dvc <<'SQL'
SET SERVEROUTPUT ON
DECLARE
    l_found NUMBER; l_updated NUMBER; l_status VARCHAR2(20); l_error VARCHAR2(4000);
BEGIN
    eba_cust_amzn_pkg.sync_bestsellers(p_found => l_found, p_updated => l_updated, p_status => l_status, p_error_msg => l_error);
    dbms_output.put_line('Found: ' || l_found || ', Updated: ' || l_updated || ', Status: ' || l_status);
    IF l_error IS NOT NULL THEN
        dbms_output.put_line('Error: ' || l_error);
    END IF;
END;
/
SQL
```

Expected: Status SUCCESS or PARTIAL with products found > 0. If FAILED due to network, that's acceptable — the architecture is correct.

- [ ] **Step 5: Verify balance view with synced data**

```bash
sql -S -name dvc <<'SQL'
SELECT product_name, asin, amazon_price, qty_on_hand, total_value
FROM eba_cust_amzn_balance_v
ORDER BY amazon_rank
FETCH FIRST 10 ROWS ONLY;
SQL
```

Expected: synced products listed (qty_on_hand = 0 since no transactions yet, which is correct).

- [ ] **Step 6: Compile check — no invalid objects**

```bash
sql -S -name dvc <<'SQL'
SELECT object_name, object_type
FROM user_objects
WHERE object_name LIKE 'EBA_CUST_AMZN%' AND status != 'VALID';
SQL
```

Expected: no rows returned (all objects valid).
