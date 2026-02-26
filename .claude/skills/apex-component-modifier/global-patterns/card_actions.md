# Card Actions (`create_card_action`)

Define clickable behaviors: full-card links, buttons, title links.

## Action Types

### FULL_CARD (entire card clickable)
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

### BUTTON
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

Variants: `p_is_hot=>true` for hot button; `p_position=>'SECONDARY'` for secondary area; `p_button_display_type=>'ICON'` for icon-only; `p_button_display_type=>'TEXT'` for text-only.

### Conditional Button
```sql
,p_condition_type=>'EXPRESSION'
,p_condition_expr1=>':JOB = ''DEVEOPER'' or :DEPTNO = 10'
,p_condition_expr2=>'PLSQL'
,p_exec_cond_for_each_row=>true
```

### TITLE (title text clickable)
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

**Action types:** `FULL_CARD`, `BUTTON`, `TITLE`

**Button positions:** `PRIMARY`, `SECONDARY`

**Button display types:** `TEXT_WITH_ICON`, `TEXT`, `ICON`

**Link target types:** `REDIRECT_PAGE` (`f?p=&APP_ID.:PAGE:&SESSION.::&DEBUG.:CLEAR:ITEMS:VALUES`), `REDIRECT_URL` (static or substitution URL)

## Multiple Actions Per Card

A card can have multiple actions at different positions:
1. PRIMARY button (hot, text-only)
2. SECONDARY button (icon-only, e.g. `fa-heart-o`)
3. SECONDARY button (icon-only, e.g. `fa-share-alt`)
