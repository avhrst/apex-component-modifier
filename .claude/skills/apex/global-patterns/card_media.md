# Card Media

Media parameters on `create_card` control the image/video display area.

## Media Source Types

### BLOB
```sql
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

BLOB requires: `p_pk1_column_name`, `p_mime_type_column_name`. Optional: `p_last_updated_column_name` (browser caching). Variant: add `p_media_appearance=>'WIDESCREEN'` for widescreen.

### DYNAMIC_URL (column provides URL)
```sql
,p_media_adv_formatting=>false
,p_media_source_type=>'DYNAMIC_URL'
,p_media_url_column_name=>'DOWNLOAD_URL'
,p_media_display_position=>'FIRST'
,p_media_appearance=>'WIDESCREEN'
,p_media_sizing=>'COVER'
,p_media_description=>'&AUTHOR. Photo'
,p_pk1_column_name=>'ID'
```

Variant: `p_media_display_position=>'BACKGROUND'` for background image.

### STATIC_URL (URL with substitution)
```sql
,p_media_adv_formatting=>false
,p_media_source_type=>'STATIC_URL'
,p_media_url=>'https://image.tmdb.org/t/p/w500&POSTER_PATH.'
,p_media_display_position=>'BACKGROUND'
,p_media_sizing=>'COVER'
,p_media_description=>'&TITLE!ATTR.'
```

Also accepts substitution from column: `p_media_url=>'&IMAGE_URL!ATTR.'`.

## Advanced HTML Media (`p_media_adv_formatting=>true`)

```sql
-- Custom img tag for BLOB URL
,p_media_adv_formatting=>true
,p_media_html_expr=>'<img src="&BLOB_URL!ATTR." alt="&ENAME!ATTR." style="width:128px;height:128px;">'
,p_media_display_position=>'FIRST'
,p_pk1_column_name=>'EMPNO'

-- YouTube iframe embed
,p_media_adv_formatting=>true
,p_media_html_expr=>'<iframe src="https://www.youtube.com/embed/playlist?list=&ID." title="&TITLE." allowfullscreen></iframe>'
,p_media_display_position=>'FIRST'
,p_media_css_classes=>'a-CardView-media--cover a-CardView-media--widescreen'

-- Video thumbnail + duration overlay
,p_media_adv_formatting=>true
,p_media_html_expr=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<img class="a-CardView-mediaImg" src="&URL!ATTR." alt="&TITLE!ATTR." />',
'<span class="a-CardView-videoLength"><span class="fa fa-play"></span> &VIDEO_DURATION!HTML.</span>'))
,p_media_display_position=>'FIRST'
,p_media_css_classes=>'a-CardView-media--cover a-CardView-media--widescreen'

-- Oracle JET gauge in BODY position
,p_media_adv_formatting=>true
,p_media_html_expr=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<oj-status-meter-gauge id="vehichle_speed" angle-extent=250 start-angle=215',
'    min="0" max="&MAX_VAL!ATTR." value="&OVER_SPEED!ATTR."',
'    thresholds=''[{"max": 5, "color": "yellow"},{"max": 19, "color": "orange"},{"max": 40, "color": "red"}]''',
'    label.text="mph over" orientation="circular" class="speedometer" readonly>',
'</oj-status-meter-gauge>'))
,p_media_display_position=>'BODY'
```

## Valid Values

**Display positions:** `FIRST` (above content), `BACKGROUND` (behind content), `BODY` (within body area)

**Appearance:** `WIDESCREEN` (wide aspect ratio), *(not set)* = default square

**Sizing:** `FIT` (fit within container), `COVER` (fill, may crop)

**CSS classes** (with adv formatting): `a-CardView-media--cover a-CardView-media--widescreen`
