# Card Media

Media parameters on `create_card` control the image/video display area of each card.

## Media Source Types

### BLOB
```sql
-- Page 2: BLOB image from table column
,p_media_adv_formatting=>false
,p_media_source_type=>'BLOB'
,p_media_blob_column_name=>'PROFILE_IMAGE'
,p_media_display_position=>'FIRST'
,p_media_sizing=>'FIT'
,p_media_description=>'&ENAME. - &JOB.'
,p_pk1_column_name=>'EMPNO'
,p_mime_type_column_name=>'MIMETYPE'
,p_last_updated_column_name=>'IMAGE_LAST_UPDATE'
```

BLOB requires: `p_pk1_column_name`, `p_mime_type_column_name`. Optional: `p_last_updated_column_name` (recommended for browser caching).

### BLOB with widescreen appearance
```sql
-- Page 9: BLOB media with widescreen
,p_media_adv_formatting=>false
,p_media_source_type=>'BLOB'
,p_media_blob_column_name=>'PROFILE_IMAGE'
,p_media_display_position=>'FIRST'
,p_media_appearance=>'WIDESCREEN'
,p_media_sizing=>'FIT'
,p_media_description=>'&ENAME. - &JOB.'
,p_pk1_column_name=>'EMPNO'
,p_mime_type_column_name=>'MIMETYPE'
,p_last_updated_column_name=>'IMAGE_LAST_UPDATE'
```

### DYNAMIC_URL (column provides the URL)
```sql
-- Page 4: Image URL from column
,p_media_adv_formatting=>false
,p_media_source_type=>'DYNAMIC_URL'
,p_media_url_column_name=>'DOWNLOAD_URL'
,p_media_display_position=>'FIRST'
,p_media_appearance=>'WIDESCREEN'
,p_media_sizing=>'COVER'
,p_media_description=>'&AUTHOR. Photo'
,p_pk1_column_name=>'ID'
```

### DYNAMIC_URL as background
```sql
-- Page 8: Background image from column
,p_media_adv_formatting=>false
,p_media_source_type=>'DYNAMIC_URL'
,p_media_url_column_name=>'IMAGE_URL'
,p_media_display_position=>'BACKGROUND'
,p_media_sizing=>'COVER'
,p_media_description=>'Redwood Mountain'
```

### STATIC_URL (URL with substitution)
```sql
-- Page 7: Movie poster background
,p_media_adv_formatting=>false
,p_media_source_type=>'STATIC_URL'
,p_media_url=>'https://image.tmdb.org/t/p/w500&POSTER_PATH.'
,p_media_display_position=>'BACKGROUND'
,p_media_sizing=>'COVER'
,p_media_description=>'&TITLE!ATTR.'
```

```sql
-- Page 8: Static URL with substitution from query column
,p_media_source_type=>'STATIC_URL'
,p_media_url=>'&IMAGE_URL!ATTR.'
,p_media_display_position=>'FIRST'
,p_media_appearance=>'WIDESCREEN'
,p_media_sizing=>'COVER'
```

## Advanced HTML Media

When `p_media_adv_formatting=>true`, use `p_media_html_expr` for custom HTML:

### BLOB as URL via HTML img tag
```sql
-- Page 5: Custom img tag referencing BLOB URL from SQL column
,p_media_adv_formatting=>true
,p_media_html_expr=>'<img src="&BLOB_URL!ATTR." alt="&ENAME!ATTR." style="width:128px;height:128px;">'
,p_media_display_position=>'FIRST'
,p_pk1_column_name=>'EMPNO'
```

### Embedded video (iframe)
```sql
-- Page 6: YouTube iframe embed
,p_media_adv_formatting=>true
,p_media_html_expr=>'<iframe src="https://www.youtube.com/embed/playlist?list=&ID." title="&TITLE." allowfullscreen></iframe>'
,p_media_display_position=>'FIRST'
,p_media_css_classes=>'a-CardView-media--cover a-CardView-media--widescreen'
```

### Video thumbnails with duration overlay
```sql
-- Page 10: Image + duration badge
,p_media_adv_formatting=>true
,p_media_html_expr=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<img class="a-CardView-mediaImg" src="&URL!ATTR." alt="&TITLE!ATTR." />',
'<span class="a-CardView-videoLength"><span class="fa fa-play"></span> &VIDEO_DURATION!HTML.</span>'))
,p_media_display_position=>'FIRST'
,p_media_css_classes=>'a-CardView-media--cover a-CardView-media--widescreen'
```

### Oracle JET gauge visualization
```sql
-- Page 11: JET status meter gauge in BODY position
,p_media_adv_formatting=>true
,p_media_html_expr=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<oj-status-meter-gauge',
'    id = "vehichle_speed"',
'    angle-extent = 250',
'    start-angle = 215',
'    min = "0"',
'    max = "&MAX_VAL!ATTR."',
'    labelled-by="readOnly"',
'    thresholds=''[{"max": 5, "color": "yellow"},{"max": 19, "color": "orange"},{"max": 40, "color": "red"}]''',
'    value = "&OVER_SPEED!ATTR."',
'    label.text ="mph over"',
'    orientation = "circular"',
'    class="speedometer" readonly>',
'</oj-status-meter-gauge>'))
,p_media_display_position=>'BODY'
,p_pk1_column_name=>'ID'
```

## Media Display Positions

| Position | Description | Used On |
|----------|-------------|---------|
| `FIRST` | Above card content | Pages 2, 4, 5, 8, 9, 10 |
| `BACKGROUND` | Behind card content | Pages 7, 8 |
| `BODY` | Within card body area | Page 11 |

## Media Appearance

| Appearance | Description | Used On |
|------------|-------------|---------|
| `WIDESCREEN` | Wide aspect ratio | Pages 4, 8, 9 |
| *(not set)* | Default square | Pages 2, 7 |

## Media Sizing

| Sizing | Description | Used On |
|--------|-------------|---------|
| `FIT` | Fit within container | Pages 2, 9 |
| `COVER` | Fill container, may crop | Pages 4, 7, 8 |

## Media CSS Classes

Used with advanced formatting to control media container:

```sql
-- Pages 6, 10: Cover + widescreen via CSS classes
,p_media_css_classes=>'a-CardView-media--cover a-CardView-media--widescreen'
```
