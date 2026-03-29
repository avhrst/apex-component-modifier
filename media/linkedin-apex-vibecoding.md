Just built a full Bitcoin Dashboard in Oracle APEX without opening the App Builder once.

Using Claude Code + custom APEX & SQLcl CLI skills, I vibecoded an entire page from the terminal:

- 6 KPI cards (price, 24h change, market cap, volume, 90d high/low)
- Price history line chart with area fill
- OHLC candlestick stock chart
- Trading volume bar chart
- Market dominance donut chart
- Timeframe selector (7/14/30/60/90 days) with dynamic actions refreshing all charts via AJAX

The workflow: export -> patch -> import. All through SQLcl CLI. No clicks. No drag-and-drop. Just a prompt and a conversation.

The skill reads APEX export files, understands the PL/SQL API (wwv_flow_imp_page), patches components incrementally, and imports them back. It knows valid parameter values, ID sequencing rules, block boundaries, and error recovery patterns.

One prompt. One page. Six regions. Four chart types. Dynamic actions. Done.

APEX vibecoding is real.

#OracleAPEX #SQLcl #ClaudeCode #Vibecoding #LowCode #AI #OracleDatabase
