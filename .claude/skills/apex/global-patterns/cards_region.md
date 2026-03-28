# Cards Region (`NATIVE_CARDS`)

Uses `create_page_plug` with `p_plug_source_type=>'NATIVE_CARDS'` and template ID `2072724515482255512`.

## Region Template Options (Styles)

| Style | Template Option |
|-------|----------------|
| A | `#DEFAULT#:t-CardsRegion--styleA` |
| B | `#DEFAULT#:t-CardsRegion--styleB` |
| C | `#DEFAULT#:t-CardsRegion--styleC` |
| None | `#DEFAULT#` |

Additional CSS classes: `u-colors` (for color-coded cards)

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

Uses `p_location=>'WEB_SOURCE'` + `p_web_src_module_id`. For post-processing, add `p_plug_source` with SQL referencing `#APEX$SOURCE_DATA#` and `p_source_post_processing=>'SQL'`.

```sql
-- Basic WEB_SOURCE
,p_location=>'WEB_SOURCE'
,p_web_src_module_id=>wwv_flow_imp.id(10751415422371804704)
,p_plug_source_type=>'NATIVE_CARDS'
,p_plug_query_num_rows=>3
,p_plug_query_num_rows_type=>'SET'

-- With post-processing SQL
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID, TITLE, VIDEOID,',
'       eba_demo_card_pkg.get_video_duration( p_video_id => VIDEOID ) VIDEO_DURATION',
'  from #APEX$SOURCE_DATA#'))
,p_source_post_processing=>'SQL'
```

## Pagination

| Type | Parameters |
|------|-----------|
| Scroll | `p_plug_query_num_rows_type=>'SCROLL'` |
| Fixed count | `p_plug_query_num_rows_type=>'SET'`, `p_plug_query_num_rows=>N` |

## No Data Found

```sql
,p_plug_query_no_data_found=>'No Employees Found'
,p_no_data_found_icon_classes=>'fa-warning fa-lg'
```

## Order By (item-driven)

```sql
,p_query_order_by_type=>'ITEM'
,p_query_order_by=>'{"orderBys":[{"key":"ENAME","expr":"\"ENAME\" asc"},{"key":"JOB","expr":"\"JOB\" asc"}],"itemName":"P15_ORDER_BY"}'
```

## Color-Coded Cards

Use SQL CASE + Universal Theme color modifiers (`u-color-2` through `u-color-5`):
```sql
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select EMPNO, ENAME, JOB, DEPTNO,',
'       case when deptno = 10 then ''u-color-2''',
'            when deptno = 20 then ''u-color-3''',
'            when deptno = 30 then ''u-color-4''',
'            when deptno = 40 then ''u-color-5''',
'       end card_color',
'  from EBA_DEMO_CARD_EMP'))
```

## Faceted Search Integration

Cards as filtered region: faceted search panel points `p_filtered_region_id` to the cards region ID. See `faceted_search.md`.
