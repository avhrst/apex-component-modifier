# Cards Region (`NATIVE_CARDS`)

Cards regions use `create_page_plug` with `p_plug_source_type=>'NATIVE_CARDS'` and template ID `2072724515482255512`.

## Region Template Options (Styles)

| Style | Template Option | Used On |
|-------|----------------|---------|
| A | `#DEFAULT#:t-CardsRegion--styleA` | Pages 3, 4, 7 |
| B | `#DEFAULT#:t-CardsRegion--styleB` | Pages 2, 3, 5, 6, 8, 9, 12, 15, 16, 18 |
| C | `#DEFAULT#:t-CardsRegion--styleC` | Pages 3, 8 |
| None | `#DEFAULT#` | Pages 10, 11, 13, 17, 18 |

Additional CSS classes: `u-colors` (page 7, for color-coded cards)

## Data Sources

### TABLE source
```sql
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(10750863068661589215)
,p_plug_name=>'Style A'
,p_region_template_options=>'#DEFAULT#:t-CardsRegion--styleA'
,p_plug_template=>2072724515482255512
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_query_type=>'TABLE'
,p_query_table=>'EBA_DEMO_CARD_EMP'
,p_include_rowid_column=>false
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_CARDS'
,p_plug_query_num_rows_type=>'SCROLL'
,p_show_total_row_count=>true
,p_pagination_display_position=>'BOTTOM_RIGHT'
);
```

### SQL query source
```sql
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(12034914226196656426)
,p_plug_name=>'Media Image'
,p_region_css_classes=>'test'
,p_region_template_options=>'#DEFAULT#:t-CardsRegion--styleB'
,p_plug_template=>2072724515482255512
,p_plug_display_sequence=>30
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select EMPNO,',
'       ENAME,',
'       JOB,',
'       MGR,',
'       HIREDATE,',
'       SAL,',
'       COMM,',
'       DEPTNO,',
'       apex_page.get_url(',
'           p_request     => ''APPLICATION_PROCESS=GETIMAGE'',',
'           p_clear_cache => 5,',
'           p_items       => ''P5_EMPNO'',',
'           p_values      => EMPNO ) BLOB_URL,',
'       IMAGE_LAST_UPDATE,',
'       TAGS',
'  from EBA_DEMO_CARD_EMP'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_CARDS'
,p_plug_query_num_rows_type=>'SCROLL'
,p_show_total_row_count=>true
,p_pagination_display_position=>'BOTTOM_RIGHT'
);
```

### WEB_SOURCE (REST Data Source)
```sql
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(10751429346883814026)
,p_plug_name=>'APEX YouTube Channel'
,p_region_template_options=>'#DEFAULT#:t-CardsRegion--styleB'
,p_plug_template=>2072724515482255512
,p_plug_display_sequence=>20
,p_location=>'WEB_SOURCE'
,p_web_src_module_id=>wwv_flow_imp.id(10751415422371804704)
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_CARDS'
,p_plug_query_num_rows=>3
,p_plug_query_num_rows_type=>'SET'
,p_show_total_row_count=>false
,p_pagination_display_position=>'BOTTOM_RIGHT'
);
```

### WEB_SOURCE with post-processing SQL
```sql
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(6068545264014251059)
,p_plug_name=>'APEX Play List'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2072724515482255512
,p_plug_display_sequence=>20
,p_location=>'WEB_SOURCE'
,p_web_src_module_id=>wwv_flow_imp.id(10751426478689804728)
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       ETAG,',
'       KIND,',
'       TITLE,',
'       CHANNELID,',
'       PLAYLISTID,',
'       VIDEOID,',
'       URL,',
'       WIDTH,',
'       HEIGHT,',
'       DESCRIPTION,',
'       PUBLISHEDAT,',
'       VIDEOPUBLISHEDAT,',
'       eba_demo_card_pkg.get_video_duration( p_video_id => VIDEOID ) VIDEO_DURATION',
'  from #APEX$SOURCE_DATA#'))
,p_source_post_processing=>'SQL'
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_CARDS'
,p_plug_query_num_rows_type=>'SCROLL'
,p_show_total_row_count=>false
);
```

## Pagination

| Type | Parameter | Used On |
|------|-----------|---------|
| Scroll | `p_plug_query_num_rows_type=>'SCROLL'` | Most pages |
| Set (fixed count) | `p_plug_query_num_rows_type=>'SET'`, `p_plug_query_num_rows=>N` | Pages 2, 6, 7 |

## No Data Found

```sql
-- Custom message with icon (page 17)
,p_plug_query_no_data_found=>'No Employees Found'
,p_no_data_found_icon_classes=>'fa-warning fa-lg'
```

## Order By (item-driven)

```sql
-- Page 15: Order by select list
,p_query_order_by_type=>'ITEM'
,p_query_order_by=>'{"orderBys":[{"key":"ENAME","expr":"\"ENAME\" asc"},{"key":"JOB","expr":"\"JOB\" asc"}],"itemName":"P15_ORDER_BY"}'
```

## Color-Coded Cards (SQL with CASE)

```sql
-- Page 18: Dynamic color via SQL CASE + Universal Theme color modifiers
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select EMPNO,',
'       ENAME,',
'       JOB,',
'       DEPTNO,',
'       case when deptno = 10 then',
'           ''u-color-2''',
'       when deptno = 20 then',
'           ''u-color-3''',
'       when deptno = 30 then',
'           ''u-color-4''',
'       when deptno = 40 then',
'           ''u-color-5''',
'       end card_color',
'  from EBA_DEMO_CARD_EMP'))
```

## Faceted Search Integration

```sql
-- Page 12: Cards as filtered region of faceted search
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9825920105389872644)
,p_plug_name=>'Search'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader js-addHiddenHeadingRoleDesc:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>4
,p_plug_display_point=>'REGION_POSITION_02'
,p_plug_source_type=>'NATIVE_FACETED_SEARCH'
,p_filtered_region_id=>wwv_flow_imp.id(9825919996571872644)
);
```
