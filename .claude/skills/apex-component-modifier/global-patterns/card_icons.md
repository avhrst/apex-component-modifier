# Card Icons

Icon parameters on `create_card` control the small icon/avatar displayed on each card.

## Icon Source Types

### INITIALS (letter avatar)
```sql
-- Page 3: Basic initials icon at TOP
,p_icon_source_type=>'INITIALS'
,p_icon_class_column_name=>'ENAME'
,p_icon_position=>'TOP'
```

```sql
-- Page 13: Initials with custom CSS shape (star)
,p_icon_source_type=>'INITIALS'
,p_icon_class_column_name=>'ENAME'
,p_icon_css_classes=>'star-shape'
,p_icon_position=>'START'
```

```sql
-- Page 18: Initials with dynamic color from column
,p_icon_source_type=>'INITIALS'
,p_icon_class_column_name=>'ENAME'
,p_icon_css_classes=>'&CARD_COLOR!ATTR.'
,p_icon_position=>'TOP'
```

### BLOB (image from table)
```sql
-- Page 2: BLOB icon at START position
,p_icon_source_type=>'BLOB'
,p_icon_blob_column_name=>'PROFILE_IMAGE'
,p_icon_position=>'START'
,p_icon_description=>'&ENAME!ATTR.'
```

BLOB icon shares PK/MIME/last-updated params with media BLOB:
```sql
,p_pk1_column_name=>'EMPNO'
,p_mime_type_column_name=>'MIMETYPE'
,p_last_updated_column_name=>'IMAGE_LAST_UPDATE'
```

### URL (external image)
```sql
-- Page 7: Movie poster URL as icon
,p_icon_source_type=>'URL'
,p_icon_image_url=>'https://image.tmdb.org/t/p/w500&POSTER_PATH.'
,p_icon_position=>'TOP'
,p_icon_description=>'&TITLE!ATTR.'
```

### DYNAMIC_CLASS (Font APEX / custom icon class)
```sql
-- Page 8: Dynamic icon class from column
,p_icon_source_type=>'DYNAMIC_CLASS'
,p_icon_class_column_name=>'ICON_CLASS'
,p_icon_css_classes=>'fa'
,p_icon_position=>'START'
```

## Icon Positions

| Position | Description | Used On |
|----------|-------------|---------|
| `TOP` | Above title | Pages 3, 7, 18 |
| `START` | Left of content | Pages 2, 8, 13 |
| *(not set)* | Default position | Pages 12, 15, 16 |

## Icon CSS Classes

Static or dynamic CSS classes applied to the icon container:

| Pattern | Example | Used On |
|---------|---------|---------|
| Static class | `'star-shape'` | Page 13 |
| Dynamic from column | `'&CARD_COLOR!ATTR.'` | Page 18 |
| Font class | `'fa'` | Page 8 |

## Custom Icon Styling (page 13)

Page inline CSS for star-shaped icons:
```css
.star-shape {
    margin-right: 20px;
    width: 100px;
    height: 100px;
    background-color: #59d1f2;
    shape-outside: polygon(50% 0%, 61% 35%, 98% 35%, 68% 57%, 79% 91%, 50% 70%, 21% 91%, 32% 57%, 2% 35%, 39% 35%);
    clip-path: polygon(50% 0%, 61% 35%, 98% 35%, 68% 57%, 79% 91%, 50% 70%, 21% 91%, 32% 57%, 2% 35%, 39% 35%);
    float: left;
}
```
