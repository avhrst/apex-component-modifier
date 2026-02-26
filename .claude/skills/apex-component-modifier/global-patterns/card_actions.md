# Card Actions (`create_card_action`)

Card actions define clickable behaviors on cards — full-card links, buttons, and title links.

## Action Types

### FULL_CARD (entire card is clickable)

```sql
-- Page 2: Navigate to modal dialog
wwv_flow_imp_page.create_card_action(
 p_id=>wwv_flow_imp.id(6065643145669132161)
,p_card_id=>wwv_flow_imp.id(6065642975841132160)
,p_action_type=>'FULL_CARD'
,p_display_sequence=>10
,p_link_target_type=>'REDIRECT_PAGE'
,p_link_target=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.:14:P14_EMPNO:&EMPNO.'
);
```

```sql
-- Page 10: External URL with substitution
wwv_flow_imp_page.create_card_action(
 p_id=>wwv_flow_imp.id(6044452401305692278)
,p_card_id=>wwv_flow_imp.id(6068545766169251064)
,p_action_type=>'FULL_CARD'
,p_display_sequence=>10
,p_link_target_type=>'REDIRECT_URL'
,p_link_target=>'https://www.youtube.com/watch?v=&VIDEOID.'
,p_link_attributes=>'target="_blank"'
);
```

### BUTTON (action button on card)

```sql
-- Page 2: Text + icon button (not hot)
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

```sql
-- Page 6: Hot button with icon
wwv_flow_imp_page.create_card_action(
 p_id=>wwv_flow_imp.id(10746972030874612210)
,p_card_id=>wwv_flow_imp.id(10751431846610814030)
,p_action_type=>'BUTTON'
,p_position=>'PRIMARY'
,p_display_sequence=>10
,p_label=>'View All Videos'
,p_link_target_type=>'REDIRECT_PAGE'
,p_link_target=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.:10:P10_ID:&ID.'
,p_button_display_type=>'TEXT_WITH_ICON'
,p_icon_css_classes=>'fa-file-video-o'
,p_is_hot=>true
);
```

```sql
-- Page 7: Icon-only secondary buttons
wwv_flow_imp_page.create_card_action(
 p_id=>wwv_flow_imp.id(9828238275242997926)
,p_card_id=>wwv_flow_imp.id(11391855668307653944)
,p_action_type=>'BUTTON'
,p_position=>'SECONDARY'
,p_display_sequence=>20
,p_label=>'Add to Favorite'
,p_link_target_type=>'REDIRECT_URL'
,p_link_target=>'#'
,p_button_display_type=>'ICON'
,p_icon_css_classes=>'fa-heart-o'
,p_is_hot=>false
);
```

```sql
-- Page 16: Conditional button (per-row PL/SQL condition)
wwv_flow_imp_page.create_card_action(
 p_id=>wwv_flow_imp.id(10746972313072612213)
,p_card_id=>wwv_flow_imp.id(10751498383156039924)
,p_action_type=>'BUTTON'
,p_position=>'PRIMARY'
,p_display_sequence=>30
,p_label=>'Edit'
,p_link_target_type=>'REDIRECT_PAGE'
,p_link_target=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.:14:P14_EMPNO:&EMPNO.'
,p_button_display_type=>'TEXT_WITH_ICON'
,p_icon_css_classes=>'fa-file-o'
,p_is_hot=>true
,p_condition_type=>'EXPRESSION'
,p_condition_expr1=>':JOB = ''DEVEOPER'' or :DEPTNO = 10'
,p_condition_expr2=>'PLSQL'
,p_exec_cond_for_each_row=>true
);
```

### TITLE (title text is clickable)

```sql
-- Page 8: External URL title link
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

```sql
-- Page 16: Title link with authorization scheme
wwv_flow_imp_page.create_card_action(
 p_id=>wwv_flow_imp.id(10746972607283612216)
,p_card_id=>wwv_flow_imp.id(10751498383156039924)
,p_action_type=>'TITLE'
,p_display_sequence=>20
,p_link_target_type=>'REDIRECT_PAGE'
,p_link_target=>'f?p=&APP_ID.:16:&SESSION.::&DEBUG.:::'
,p_authorization_scheme=>wwv_flow_imp.id(11343081477445913174)
);
```

## Button Positions

| Position | Description | Used On |
|----------|-------------|---------|
| `PRIMARY` | Main action area | Pages 2, 6, 7, 16 |
| `SECONDARY` | Secondary action area | Page 7 |

## Button Display Types

| Type | Description | Used On |
|------|-------------|---------|
| `TEXT_WITH_ICON` | Label + icon | Pages 2, 6, 16 |
| `TEXT` | Label only | Page 7 (primary) |
| `ICON` | Icon only | Page 7 (secondary) |

## Link Target Types

| Type | Pattern | Used On |
|------|---------|---------|
| `REDIRECT_PAGE` | `f?p=&APP_ID.:PAGE:&SESSION.::&DEBUG.:CLEAR:ITEMS:VALUES` | Pages 2, 6, 15, 16 |
| `REDIRECT_URL` | Static or substitution URL | Pages 7, 8, 10 |

## Conditional Actions

Actions can display per-row based on PL/SQL conditions:
```sql
,p_condition_type=>'EXPRESSION'
,p_condition_expr1=>':JOB = ''DEVEOPER'' or :DEPTNO = 10'
,p_condition_expr2=>'PLSQL'
,p_exec_cond_for_each_row=>true
```

## Multiple Actions Per Card (page 7)

A single card can have multiple actions at different positions:
1. PRIMARY button: "Add to List" (hot, text-only)
2. SECONDARY button: "Add to Favorite" (icon-only, fa-heart-o)
3. SECONDARY button: "Share" (icon-only, fa-share-alt)
