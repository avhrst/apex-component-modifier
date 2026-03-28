# Card Actions (`create_card_action`)

Define clickable behaviors: full-card links, buttons, title links.

## Action Types

### FULL_CARD (entire card clickable — 19 examples)
```sql
-- Navigate to modal dialog
wwv_flow_imp_page.create_card_action(
 p_id=>wwv_flow_imp.id(6065643145669132161)
,p_card_id=>wwv_flow_imp.id(6065642975841132160)
,p_action_type=>'FULL_CARD'
,p_display_sequence=>10
,p_link_target_type=>'REDIRECT_PAGE'
,p_link_target=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.:14:P14_EMPNO:&EMPNO.'
);
```

Variant: external URL with `p_link_target_type=>'REDIRECT_URL'`, `p_link_target=>'https://...'`, `p_link_attributes=>'target="_blank"'`.

### BUTTON (20 examples)
```sql
-- Text + icon button
wwv_flow_imp_page.create_card_action(
 p_id=>wwv_flow_imp.id(11220651425807406645)
,p_card_id=>wwv_flow_imp.id(11343092678586913229)
,p_action_type=>'BUTTON'
,p_position=>'PRIMARY'
,p_display_sequence=>10
,p_label=>'Edit'
,p_link_target_type=>'REDIRECT_PAGE'
,p_link_target=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.:14:P14_EMPNO:&EMPNO.'
,p_button_display_type=>'TEXT_WITH_ICON'
,p_icon_css_classes=>'fa-file-o'
,p_is_hot=>false
);
```

Variants:
- `p_is_hot=>true` for hot (primary) button
- `p_position=>'SECONDARY'` for secondary area
- `p_button_display_type=>'ICON'` for icon-only
- `p_button_display_type=>'TEXT'` for text-only
- `p_show_as_disabled=>false` (observed on all button examples)

### BUTTON with CSS Classes
```sql
-- Compact icon button with custom CSS
,p_action_type=>'BUTTON'
,p_position=>'PRIMARY'
,p_button_display_type=>'ICON'
,p_icon_css_classes=>'fa-plus'
,p_action_css_classes=>'padding-sm t-Button--tiny'
,p_is_hot=>true
,p_show_as_disabled=>false

-- No-UI style button (borderless)
,p_action_type=>'BUTTON'
,p_button_display_type=>'ICON'
,p_icon_css_classes=>'fa-ellipsis-v'
,p_action_css_classes=>'t-Button--noUI'
,p_is_hot=>false
,p_show_as_disabled=>false
```

### Conditional Button
```sql
,p_condition_type=>'EXPRESSION'
,p_condition_expr1=>':JOB = ''DEVEOPER'' or :DEPTNO = 10'
,p_condition_expr2=>'PLSQL'
,p_exec_cond_for_each_row=>true
```

Condition types observed: `EXPRESSION` (with `p_condition_expr2=>'PLSQL'`), `ITEM_IS_NOT_NULL`, `NEVER`.

### TITLE (title text clickable — 4 examples)
```sql
wwv_flow_imp_page.create_card_action(
 p_id=>wwv_flow_imp.id(6044454364451692298)
,p_card_id=>wwv_flow_imp.id(6044454323857692297)
,p_action_type=>'TITLE'
,p_display_sequence=>10
,p_link_target_type=>'REDIRECT_URL'
,p_link_target=>'https://apex.oracle.com'
,p_link_attributes=>'target="_blank"'
);
```

Variant: `p_link_target_type=>'REDIRECT_PAGE'` with `p_authorization_scheme=>wwv_flow_imp.id(...)`.

## Valid Values

**Action types:** `BUTTON` (20), `FULL_CARD` (19), `TITLE` (4)

**Button positions:** `PRIMARY` (14), `SECONDARY` (6)

**Button display types:** `ICON` (71), `TEXT_WITH_ICON` (38), `TEXT` (13)

**Link target types:** `REDIRECT_PAGE` (`f?p=&APP_ID.:PAGE:&SESSION.::&DEBUG.:CLEAR:ITEMS:VALUES`), `REDIRECT_URL` (static or substitution URL)

**Action CSS classes:** `'padding-sm t-Button--tiny'`, `'padding-sm'`, `'t-Button--noUI'`, `'t-Button--small'`, `'fa-lg'`, `'w140'`

**Condition types:** `EXPRESSION`, `ITEM_IS_NOT_NULL`, `NEVER`

## Multiple Actions Per Card

A card can have multiple actions at different positions:
1. PRIMARY button (hot, text-only)
2. SECONDARY button (icon-only, e.g. `fa-heart-o`)
3. SECONDARY button (icon-only, e.g. `fa-share-alt`)

## Parameter Value Catalog

| Parameter | Observed Values |
|-----------|----------------|
| `p_action_type` | `BUTTON` (20), `FULL_CARD` (19), `TITLE` (4) |
| `p_position` | `PRIMARY` (14), `SECONDARY` (6) |
| `p_button_display_type` | `ICON` (71), `TEXT_WITH_ICON` (38), `TEXT` (13) |
| `p_link_target_type` | `REDIRECT_PAGE`, `REDIRECT_URL` |
| `p_is_hot` | `true`, `false` |
| `p_show_as_disabled` | `false` |
| `p_action_css_classes` | `'padding-sm t-Button--tiny'`, `'padding-sm'`, `'t-Button--noUI'`, `'t-Button--small'`, `'fa-lg'`, `'w140'`, `'approve'`, `'claim'`, `'reject'`, `'terminate'` |
| `p_link_attributes` | `'target="_blank"'`, `'aria-label="&NAME."'` |
| `p_condition_type` | `EXPRESSION`, `ITEM_IS_NOT_NULL`, `NEVER` |
| `p_condition_expr2` | `'PLSQL'` |
| `p_exec_cond_for_each_row` | `true` |
| `p_authorization_scheme` | `wwv_flow_imp.id(...)` |
