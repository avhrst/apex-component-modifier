# Bitcoin Prices Dashboard — Design

**App:** 105 | **Page:** 1 (Home) | **Theme:** Universal Theme (42)

## Data Model

Single table `BTC_PRICES`:

| Column | Type | Notes |
|--------|------|-------|
| `PRICE_DATE` | `DATE` | PK, one row per day |
| `OPEN_PRICE` | `NUMBER(12,2)` | Opening price USD |
| `HIGH_PRICE` | `NUMBER(12,2)` | Daily high |
| `LOW_PRICE` | `NUMBER(12,2)` | Daily low |
| `CLOSE_PRICE` | `NUMBER(12,2)` | Closing price USD |
| `VOLUME` | `NUMBER(18,2)` | 24h trading volume USD |

Seeded with 30 rows of realistic BTC data (late Jan – late Feb 2026, ~$85K–$100K range).

## Page Layout

### Row 1 — Summary Cards (4 across)

| Card | SQL | Format |
|------|-----|--------|
| Current Price | Latest `CLOSE_PRICE` | `$XX,XXX.XX` |
| 24h Change | Difference between last 2 days' close | `+$X,XXX (+X.X%)` green/red |
| 30-Day High | `MAX(HIGH_PRICE)` | `$XX,XXX.XX` |
| 30-Day Low | `MIN(LOW_PRICE)` | `$XX,XXX.XX` |

### Row 2 — Charts (50/50 side by side)

- **Left:** Price Line Chart — `PRICE_DATE` vs `CLOSE_PRICE`, line with area fill
- **Right:** Volume Bar Chart — `PRICE_DATE` vs `VOLUME`, vertical bars

### Row 3 — Price History Table

Interactive Report on `BTC_PRICES` sorted by `PRICE_DATE DESC`. Columns: Date, Open, High, Low, Close, Volume.

## Approach

- All SQL-based, no PL/SQL packages or views
- Static demo data via `INSERT ALL`
- APEX native JET Charts for visualization
- Interactive Report for the data table

## Decisions

- **Static data** chosen over live API or scheduled jobs (prototype/demo focus)
- **30-day range** with daily granularity (~30 rows)
- **Single table** — simplest path, easy to swap for live data later
