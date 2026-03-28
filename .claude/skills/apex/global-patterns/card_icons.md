# Card Icons

Icon parameters on `create_card` control the small icon/avatar on each card.

## Icon Source Types

### INITIALS (letter avatar — 8 examples)
```sql
,p_icon_source_type=>'INITIALS'
,p_icon_class_column_name=>'ENAME'
,p_icon_position=>'TOP'
```
Variants: `p_icon_css_classes=>'star-shape'` (custom shape), `p_icon_css_classes=>'&CARD_COLOR!ATTR.'` (dynamic color from column).

### DYNAMIC_CLASS (Font APEX / custom icon class — 9 examples, most common)
```sql
,p_icon_source_type=>'DYNAMIC_CLASS'
,p_icon_class_column_name=>'ICON_CLASS'
,p_icon_css_classes=>'fa'
,p_icon_position=>'START'
```

### BLOB (image from table — 5 examples)
```sql
,p_icon_source_type=>'BLOB'
,p_icon_blob_column_name=>'PROFILE_IMAGE'
,p_icon_position=>'START'
,p_icon_description=>'&ENAME!ATTR.'
```
Shares PK/MIME params: `p_pk1_column_name`, `p_mime_type_column_name`, `p_last_updated_column_name`.

### URL (external image — 5 examples)
```sql
,p_icon_source_type=>'URL'
,p_icon_image_url=>'https://image.tmdb.org/t/p/w500&POSTER_PATH.'
,p_icon_position=>'TOP'
,p_icon_description=>'&TITLE!ATTR.'
```

### STATIC_CLASS (fixed icon class — 2 examples)
```sql
,p_icon_source_type=>'STATIC_CLASS'
,p_icon_css_classes=>'fa-user fa-2x'
,p_icon_position=>'START'

-- Calendar user icon
,p_icon_source_type=>'STATIC_CLASS'
,p_icon_css_classes=>'fa-calendar-user'
,p_icon_position=>'START'
```

Unlike `DYNAMIC_CLASS`, the icon class is set directly in `p_icon_css_classes` rather than read from a column.

## Valid Values

**Icon source types:** `DYNAMIC_CLASS` (9), `INITIALS` (8), `URL` (5), `BLOB` (5), `STATIC_CLASS` (2)

**Icon positions:** `START` (20 — left of content), `TOP` (8 — above title), `END` (1 — right of content), *(not set)* = default

**Icon CSS classes:** static (`'star-shape'`, `'fa-user fa-2x'`, `'fa-calendar-user'`), dynamic column (`'&CARD_COLOR!ATTR.'`), font class (`'fa'`)

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

## Parameter Value Catalog

| Parameter | Observed Values |
|-----------|----------------|
| `p_icon_source_type` | `DYNAMIC_CLASS` (9), `INITIALS` (8), `URL` (5), `BLOB` (5), `STATIC_CLASS` (2) |
| `p_icon_position` | `START` (20), `TOP` (8), `END` (1) |
| `p_icon_class_column_name` | column name (for INITIALS, DYNAMIC_CLASS) |
| `p_icon_blob_column_name` | column name (for BLOB) |
| `p_icon_image_url` | URL with `&COL.` substitutions (for URL) |
| `p_icon_css_classes` | `'fa'`, `'star-shape'`, `'fa-user fa-2x'`, `'fa-calendar-user'`, `'&CARD_COLOR!ATTR.'` |
| `p_icon_description` | alt text with `&COL!ATTR.` substitutions |
