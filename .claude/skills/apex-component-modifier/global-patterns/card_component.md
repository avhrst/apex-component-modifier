# Card Component (`create_card`)

Each `NATIVE_CARDS` region has one `create_card` call defining layout, content mapping, and formatting.

## Layout Types

### GRID (most common)
```sql
-- Page 3: Basic grid, no column count (auto)
wwv_flow_imp_page.create_card(
 p_id=>wwv_flow_imp.id(10750863586718589216)
,p_region_id=>wwv_flow_imp.id(10750863068661589215)
,p_layout_type=>'GRID'
,p_title_adv_formatting=>false
,p_title_column_name=>'ENAME'
,p_sub_title_adv_formatting=>false
,p_sub_title_column_name=>'JOB'
,p_body_adv_formatting=>false
,p_second_body_adv_formatting=>false
,p_icon_source_type=>'INITIALS'
,p_icon_class_column_name=>'ENAME'
,p_icon_position=>'TOP'
,p_media_adv_formatting=>false
);
```

```sql
-- Page 2: Grid with explicit column count
wwv_flow_imp_page.create_card(
 p_id=>wwv_flow_imp.id(11343092678586913229)
,p_region_id=>wwv_flow_imp.id(11343092219359913229)
,p_layout_type=>'GRID'
,p_grid_column_count=>5
...
);
```

### ROW (horizontal)
```sql
-- Page 8: Horizontal layout
wwv_flow_imp_page.create_card(
 p_id=>wwv_flow_imp.id(6044454869807692303)
,p_region_id=>wwv_flow_imp.id(6044454793644692302)
,p_layout_type=>'ROW'
,p_title_adv_formatting=>true
,p_title_html_expr=>'<h3 class="a-CardView-title ">What is Oracle APEX?</h3>'
,p_sub_title_adv_formatting=>false
,p_body_adv_formatting=>true
,p_body_html_expr=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Oracle Application Express (APEX) is a low-code development platform...</p>'))
,p_second_body_adv_formatting=>false
,p_icon_source_type=>'DYNAMIC_CLASS'
,p_icon_class_column_name=>'ICON_CLASS'
,p_icon_css_classes=>'fa'
,p_icon_position=>'START'
,p_media_adv_formatting=>false
,p_media_source_type=>'DYNAMIC_URL'
,p_media_url_column_name=>'IMAGE_URL'
,p_media_display_position=>'FIRST'
,p_media_appearance=>'WIDESCREEN'
,p_media_sizing=>'COVER'
,p_media_description=>'Redwood Mountain'
);
```

### FLOAT
```sql
-- Page 8: Float layout with custom CSS
wwv_flow_imp_page.create_card(
 p_id=>wwv_flow_imp.id(6044454323857692297)
,p_region_id=>wwv_flow_imp.id(6044454233691692296)
,p_layout_type=>'FLOAT'
,p_card_css_classes=>'urlImages'
,p_title_adv_formatting=>true
,p_title_html_expr=>'<h3 class="a-CardView-title ">What is Oracle APEX?</h3>'
,p_title_css_classes=>'a-CardView-title'
,p_sub_title_adv_formatting=>false
,p_body_adv_formatting=>true
,p_body_html_expr=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Oracle Application Express (APEX) is a low-code development platform...</p>'))
,p_second_body_adv_formatting=>false
,p_icon_source_type=>'DYNAMIC_CLASS'
,p_icon_class_column_name=>'ICON_CLASS'
,p_icon_css_classes=>'fa'
,p_icon_position=>'START'
,p_media_adv_formatting=>false
,p_media_source_type=>'STATIC_URL'
,p_media_url=>'&IMAGE_URL!ATTR.'
,p_media_display_position=>'FIRST'
,p_media_appearance=>'WIDESCREEN'
,p_media_sizing=>'COVER'
,p_media_description=>'Redwood Mountain'
);
```

## Content Columns

| Parameter | Purpose | Example |
|-----------|---------|---------|
| `p_title_column_name` | Card title | `'ENAME'` |
| `p_sub_title_column_name` | Card subtitle | `'JOB'` |
| `p_body_column_name` | Card body text | `'JOB'`, `'OVERVIEW'` |
| `p_second_body_column_name` | Secondary body | `'MEDIA_TYPE'` |
| `p_badge_column_name` | Badge value | `'VOTE_AVERAGE'`, `'DEPTNO_L$2'` |
| `p_badge_label` | Badge label prefix | `'Rating:'`, `'Department: '` |

## Advanced Formatting

When `p_*_adv_formatting=>true`, use `p_*_html_expr` for custom HTML with substitutions:

```sql
-- Page 6: Advanced subtitle with multi-line HTML
,p_sub_title_adv_formatting=>true
,p_sub_title_html_expr=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Total Videos: &ITEMCOUNT. <br />',
'Published: &PUBLISHEDAT.'))
```

```sql
-- Page 11: Advanced title
,p_title_adv_formatting=>true
,p_title_html_expr=>'<strong>&LICENSE_PLATE.</strong> '
```

```sql
-- Page 9: Template directives in body
,p_body_adv_formatting=>true
,p_body_html_expr=>wwv_flow_string.join(wwv_flow_t_varchar2(
'{if TAGS/}',
'    <ul class="a-tags">',
'    {loop "," TAGS/}',
' 	    <li class="a-tag">&APEX$ITEM.</li>',
'    {endloop/}',
'    </ul>',
'{endif/}'))
```

## Card CSS Classes

Dynamic per-card styling via `p_card_css_classes`:

```sql
-- Page 18: Color-coded cards using column substitution
,p_card_css_classes=>'&CARD_COLOR!ATTR.'
```

```sql
-- Page 8: Static CSS class
,p_card_css_classes=>'urlImages'
```

## Badge

```sql
-- Page 7: Movie rating badge
,p_badge_column_name=>'VOTE_AVERAGE'
,p_badge_label=>'Rating:'
```

```sql
-- Page 12: Department badge (from LOV lookup)
,p_badge_column_name=>'DEPTNO_L$2'
```

```sql
-- Page 16: Department badge with label
,p_badge_column_name=>'DEPTNO'
,p_badge_label=>'Department: '
```

## Complete Example: Rich Card (page 7)

```sql
wwv_flow_imp_page.create_card(
 p_id=>wwv_flow_imp.id(11391855668307653944)
,p_region_id=>wwv_flow_imp.id(11391855357475653941)
,p_layout_type=>'GRID'
,p_title_adv_formatting=>false
,p_title_column_name=>'TITLE'
,p_sub_title_adv_formatting=>false
,p_sub_title_column_name=>'RELEASE_DATE'
,p_body_adv_formatting=>false
,p_body_column_name=>'OVERVIEW'
,p_second_body_adv_formatting=>false
,p_second_body_column_name=>'MEDIA_TYPE'
,p_icon_source_type=>'URL'
,p_icon_image_url=>'https://image.tmdb.org/t/p/w500&POSTER_PATH.'
,p_icon_position=>'TOP'
,p_icon_description=>'&TITLE!ATTR.'
,p_badge_column_name=>'VOTE_AVERAGE'
,p_badge_label=>'Rating:'
,p_media_adv_formatting=>false
,p_media_source_type=>'STATIC_URL'
,p_media_url=>'https://image.tmdb.org/t/p/w500&POSTER_PATH.'
,p_media_display_position=>'BACKGROUND'
,p_media_sizing=>'COVER'
,p_media_description=>'&TITLE!ATTR.'
);
```
