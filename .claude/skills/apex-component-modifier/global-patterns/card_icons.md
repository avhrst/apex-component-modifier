# Card Icons

Icon parameters on `create_card` control the small icon/avatar on each card.

## Icon Source Types

### INITIALS (letter avatar)
```sql
,p_icon_source_type=>'INITIALS'
,p_icon_class_column_name=>'ENAME'
,p_icon_position=>'TOP'
```
Variants: `p_icon_css_classes=>'star-shape'` (custom shape), `p_icon_css_classes=>'&CARD_COLOR!ATTR.'` (dynamic color from column).

### BLOB (image from table)
```sql
,p_icon_source_type=>'BLOB'
,p_icon_blob_column_name=>'PROFILE_IMAGE'
,p_icon_position=>'START'
,p_icon_description=>'&ENAME!ATTR.'
```
Shares PK/MIME params: `p_pk1_column_name`, `p_mime_type_column_name`, `p_last_updated_column_name`.

### URL (external image)
```sql
,p_icon_source_type=>'URL'
,p_icon_image_url=>'https://image.tmdb.org/t/p/w500&POSTER_PATH.'
,p_icon_position=>'TOP'
,p_icon_description=>'&TITLE!ATTR.'
```

### DYNAMIC_CLASS (Font APEX / custom icon class)
```sql
,p_icon_source_type=>'DYNAMIC_CLASS'
,p_icon_class_column_name=>'ICON_CLASS'
,p_icon_css_classes=>'fa'
,p_icon_position=>'START'
```

## Valid Values

**Icon positions:** `TOP` (above title), `START` (left of content), *(not set)* = default

**Icon CSS classes:** static (`'star-shape'`), dynamic column (`'&CARD_COLOR!ATTR.'`), font class (`'fa'`)

## Custom Icon Styling Example

```css
.star-shape {
    margin-right: 20px;
    width: 100px; height: 100px;
    background-color: #59d1f2;
    clip-path: polygon(50% 0%, 61% 35%, 98% 35%, 68% 57%, 79% 91%, 50% 70%, 21% 91%, 32% 57%, 2% 35%, 39% 35%);
    float: left;
}
```
