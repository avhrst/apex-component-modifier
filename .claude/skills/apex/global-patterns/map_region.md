# Map Region (`NATIVE_MAP_REGION`)

Uses `create_page_plug` with `p_plug_source_type=>'NATIVE_MAP_REGION'`, then `create_map_region` for map settings, then one or more `create_map_region_layer` calls.

## API Calls (ordered)

1. `wwv_flow_imp_page.create_page_plug(...)` — parent region with `p_plug_source_type=>'NATIVE_MAP_REGION'`
2. `wwv_flow_imp_page.create_map_region(...)` — map configuration (height, zoom, features)
3. `wwv_flow_imp_page.create_map_region_layer(...)` — one per layer (point, polygon, heatmap, etc.)

## Parent Region (create_page_plug)

```sql
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(1562218724563753112)
,p_plug_name=>'US Airports'
,p_region_name=>'airport-map-region'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>3371237801798025892
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_location=>null
,p_lazy_loading=>true
,p_plug_source_type=>'NATIVE_MAP_REGION'
);
```

Key: `p_location=>null` and `p_lazy_loading=>true` are typical. Data source is defined on the layer, not the region (unless using `REGION_SOURCE`).

## Map Region (create_map_region)

### Required Parameters

| Parameter | Description |
|-----------|-------------|
| `p_id` | Map region ID |
| `p_region_id` | References the parent `create_page_plug` ID |
| `p_height` | Map height in pixels (observed: `240`, `360`, `640`) |
| `p_navigation_bar_type` | Navigation bar type (`'FULL'`) |
| `p_navigation_bar_position` | Navigation bar position (`'END'`) |
| `p_init_position_zoom_type` | How initial position/zoom is determined |
| `p_layer_messages_position` | Position for layer messages (`'BELOW'`) |

### Initial Position / Zoom

| Zoom Type | Additional Parameters |
|-----------|----------------------|
| `STATIC` | `p_init_position_lon_static`, `p_init_position_lat_static`, `p_init_zoomlevel_static` |
| `QUERY_RESULTS` | (none — auto-fits to data extent) |
| `SQL` | `p_init_position_zoom_source` (SQL query), `p_init_position_geometry_type`, `p_init_position_lon_column`, `p_init_position_lat_column`, `p_init_zoomlevel_column` |

#### STATIC example
```sql
,p_init_position_zoom_type=>'STATIC'
,p_init_position_lon_static=>'-90'
,p_init_position_lat_static=>'35'
,p_init_zoomlevel_static=>'3'
```

#### SQL example (zoom to specific record)
```sql
,p_init_position_zoom_type=>'SQL'
,p_init_position_zoom_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select longitude,',
'       latitude, ',
'       11 zoom ',
'  from eba_demo_search_stores ',
'where store_id = :P106_STORE_ID'))
,p_init_position_geometry_type=>'LONLAT_COLUMNS'
,p_init_position_lon_column=>'LONGITUDE'
,p_init_position_lat_column=>'LATITUDE'
,p_init_zoomlevel_column=>'ZOOM'
```

### Common Optional Parameters

| Parameter | Values / Notes |
|-----------|---------------|
| `p_legend_position` | `'END'` |
| `p_show_legend` | `false` (hides legend) |
| `p_features` | Colon-separated list (see Features below) |
| `p_init_position_from_browser` | `true` (request browser geolocation) |
| `p_tilelayer_type` | `'CUSTOM'` (for custom tile layer) |
| `p_tilelayer_name_default` | e.g. `'osm-bright'` |
| `p_tilelayer_name_dark` | e.g. `'osm-bright'` |
| `p_custom_styles` | JSON array of custom SVG marker definitions |

### Features (colon-separated in `p_features`)

| Feature | Description |
|---------|-------------|
| `SCALE_BAR` | Display scale bar |
| `INFINITE_MAP` | Infinite horizontal scrolling |
| `RECTANGLE_ZOOM` | Shift+drag to zoom to rectangle |
| `MOUSEWHEEL_ZOOM` | Zoom with mouse wheel |
| `BROWSER_LOCATION` | Show user's browser location |
| `CIRCLE_TOOL` | Draw circle tool |
| `DISTANCE_TOOL` | Measure distance tool |

## Map Region Layer (create_map_region_layer)

### Required Parameters

| Parameter | Description |
|-----------|-------------|
| `p_id` | Layer ID |
| `p_map_region_id` | References the `create_map_region` ID |
| `p_name` | Layer display name |
| `p_layer_type` | `'POINT'`, `'POLYGON'`, `'HEATMAP'`, `'POLYGON_3D'` |
| `p_display_sequence` | Rendering order (10, 20, ...) |
| `p_has_spatial_index` | `false` (most common) |
| `p_geometry_column_data_type` | `'SDO_GEOMETRY'` or `'LONLAT_COLUMNS'` |
| `p_allow_hide` | `true` (allow toggling in legend) |

### Data Source

| Location | Additional Parameters |
|----------|----------------------|
| `LOCAL` (own query) | `p_query_type` (`'SQL'` or `'TABLE'`), `p_layer_source` / `p_table_name` |
| `REGION_SOURCE` | Uses parent region's query; no `p_query_type` needed |

For `LONLAT_COLUMNS` geometry: add `p_longitude_column`, `p_latitude_column`.
For `SDO_GEOMETRY`: add `p_geometry_column` (e.g. `'GEOMETRY'`).

### Common Optional Parameters

| Parameter | Values / Notes |
|-----------|---------------|
| `p_pk_column` | Primary key column name |
| `p_where_clause` | WHERE filter (can use `:ITEM` bind variables) |
| `p_items_to_submit` | Comma-separated page items for bind variables |
| `p_no_data_found_message` | Message when query returns no rows |
| `p_include_rowid_column` | `false` |
| `p_location` | `'LOCAL'` or `'REGION_SOURCE'` |

### Styling — Points

| Parameter | Values / Notes |
|-----------|---------------|
| `p_fill_color` | Hex color (`'#ff3b30'`) or substitution (`'&MARKER_COLOR.'`) |
| `p_fill_opacity` | 0–1 (e.g. `.8`) |
| `p_stroke_color` | Hex color for outline |
| `p_stroke_width` | Outline width in pixels |
| `p_point_display_type` | `'SVG'` |
| `p_point_svg_shape` | Shape name or substitution (see catalog below) |
| `p_point_svg_shape_scale` | Scale factor (e.g. `'2'`) |
| `p_feature_clustering` | `false` (disable clustering) |

### Styling — Polygons / Spectrum Colors

| Parameter | Values / Notes |
|-----------|---------------|
| `p_stroke_color` | Hex color for polygon outline |
| `p_fill_color` | Solid hex color (mutually exclusive with spectrum) |
| `p_fill_color_is_spectrum` | `true` to use color spectrum |
| `p_fill_color_spectr_name` | `'BluYl'`, `'Sunset'`, `'Temps'` |
| `p_fill_color_spectr_type` | `'SEQUENTIAL'` or `'DIVERGING'` |
| `p_fill_value_column` | Column driving spectrum color |
| `p_fill_opacity` | 0–1 (e.g. `.7`) |

### Styling — 3D Polygons (POLYGON_3D)

| Parameter | Values / Notes |
|-----------|---------------|
| `p_extrude_value_column` | Column driving extrusion height |
| `p_extrude_unit` | `'M'` (meters) |

### Tooltips and Info Windows

| Parameter | Values / Notes |
|-----------|---------------|
| `p_tooltip_adv_formatting` | `false` = use `p_tooltip_column`; `true` = use `p_tooltip_html_expr` |
| `p_tooltip_column` | Column name for simple tooltip |
| `p_tooltip_html_expr` | HTML with `&COLUMN.` substitutions |
| `p_info_window_adv_formatting` | `false` = default; `true` = use `p_info_window_html_expr` |
| `p_info_window_html_expr` | HTML with `&COLUMN.` substitutions, `{if COL/}...{endif/}` conditionals |

### Links

| Parameter | Values / Notes |
|-----------|---------------|
| `p_link_target_type` | `'REDIRECT_PAGE'` |
| `p_link_target` | `'f?p=&APP_ID.:PAGE:&SESSION.::&DEBUG.:CLEAR:ITEMS:VALUES'` |

### Legend

| Parameter | Values / Notes |
|-----------|---------------|
| `p_display_in_legend` | `false` (hide this layer from legend) |
| `p_legend_icon_css_classes` | Font APEX icon class for legend |

## Variations

### Variation A: Point Layer (lon/lat columns)
```sql
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(37032715585969100813)
,p_plug_name=>'Store Locations'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>3371237801798025892
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_08'
,p_query_type=>'SQL'
,p_plug_source=>'select * from OOW_DEMO_STORES'
,p_lazy_loading=>true
,p_plug_source_type=>'NATIVE_MAP_REGION'
);
wwv_flow_imp_page.create_map_region(
 p_id=>wwv_flow_imp.id(37032715663745100814)
,p_region_id=>wwv_flow_imp.id(37032715585969100813)
,p_height=>640
,p_navigation_bar_type=>'FULL'
,p_navigation_bar_position=>'END'
,p_init_position_zoom_type=>'QUERY_RESULTS'
,p_layer_messages_position=>'BELOW'
,p_legend_position=>'END'
,p_features=>'RECTANGLE_ZOOM:SCALE_BAR'
);
wwv_flow_imp_page.create_map_region_layer(
 p_id=>wwv_flow_imp.id(37032715815954100815)
,p_map_region_id=>wwv_flow_imp.id(37032715663745100814)
,p_name=>'stores'
,p_layer_type=>'POINT'
,p_display_sequence=>10
,p_location=>'REGION_SOURCE'
,p_has_spatial_index=>false
,p_geometry_column_data_type=>'LONLAT_COLUMNS'
,p_longitude_column=>'STORE_LNG'
,p_latitude_column=>'STORE_LAT'
,p_stroke_color=>'#ffffff'
,p_stroke_width=>2
,p_fill_color=>'#ff3b30'
,p_point_display_type=>'SVG'
,p_point_svg_shape=>'Pin Circle'
,p_point_svg_shape_scale=>'2'
,p_feature_clustering=>false
,p_tooltip_adv_formatting=>false
,p_info_window_adv_formatting=>false
,p_display_in_legend=>false
);
```

### Variation B: Heat Map Layer
```sql
wwv_flow_imp_page.create_map_region_layer(
 p_id=>wwv_flow_imp.id(1562218935915753114)
,p_map_region_id=>wwv_flow_imp.id(1562218840720753113)
,p_name=>'Airports Density'
,p_layer_type=>'HEATMAP'
,p_display_sequence=>20
,p_location=>'LOCAL'
,p_query_type=>'TABLE'
,p_table_name=>'EBA_SAMPLE_MAP_AIRPORTS'
,p_where_clause=>wwv_flow_string.join(wwv_flow_t_varchar2(
'STATE_NAME = :P110_STATE or :P110_STATE IS NULL',
'and airport_type = ''HELIPORT'' '))
,p_include_rowid_column=>false
,p_items_to_submit=>'P110_STATE'
,p_has_spatial_index=>false
,p_pk_column=>'ID'
,p_geometry_column_data_type=>'SDO_GEOMETRY'
,p_geometry_column=>'GEOMETRY'
,p_fill_color_spectr_name=>'Sunset'
,p_fill_color_spectr_type=>'SEQUENTIAL'
,p_allow_hide=>true
);
```

### Variation C: Polygon with Spectrum Colors and Info Window
```sql
wwv_flow_imp_page.create_map_region_layer(
 p_id=>wwv_flow_imp.id(1562811960355103456)
,p_map_region_id=>wwv_flow_imp.id(1562811599864103371)
,p_name=>'US States'
,p_layer_type=>'POLYGON'
,p_display_sequence=>10
,p_location=>'LOCAL'
,p_query_type=>'SQL'
,p_layer_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       NAME,',
'       STATE_CODE,',
'       to_char(LAND_AREA / 1000000,''9G999G999G990D000'')  land_area,',
'       to_char(WATER_AREA / 1000000,''9G999G999G990D000'')  water_area,',
'       case when water_area > 50000000000 then 50000000000 else water_area end as water_area_color,',
'       geometry',
'  from EBA_SAMPLE_MAP_SIMPLE_STATES'))
,p_no_data_found_message=>'No States found.'
,p_has_spatial_index=>false
,p_pk_column=>'ID'
,p_geometry_column_data_type=>'SDO_GEOMETRY'
,p_geometry_column=>'GEOMETRY'
,p_stroke_color=>'#101010'
,p_fill_color_is_spectrum=>true
,p_fill_color_spectr_name=>'BluYl'
,p_fill_color_spectr_type=>'SEQUENTIAL'
,p_fill_value_column=>'WATER_AREA_COLOR'
,p_fill_opacity=>.7
,p_tooltip_adv_formatting=>false
,p_tooltip_column=>'NAME'
,p_info_window_adv_formatting=>true
,p_info_window_html_expr=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<strong>&NAME. (&STATE_CODE.)</strong><br>',
'Land Area: &LAND_AREA. km&sup2;<br>',
'Water Area: &WATER_AREA. km&sup2;<br>'))
,p_allow_hide=>true
);
```

### Variation D: 3D Extruded Polygon
```sql
wwv_flow_imp_page.create_map_region_layer(
 p_id=>wwv_flow_imp.id(1559031956590292911)
,p_map_region_id=>wwv_flow_imp.id(1559031443142292910)
,p_name=>'Water Area by State'
,p_layer_type=>'POLYGON_3D'
,p_display_sequence=>10
,p_location=>'LOCAL'
,p_query_type=>'SQL'
,p_layer_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID,',
'       NAME,',
'       STATE_CODE,',
'       to_char(LAND_AREA / 1000000,''9G999G999G990D000'')  land_area,',
'       to_char(WATER_AREA / 1000000,''9G999G999G990D000'')  water_area,',
'       case when water_area > 50000000000 then 2500000 else water_area / 20000 end as water_area_color,',
'       GEOMETRY',
'  from EBA_SAMPLE_MAP_SIMPLE_STATES'))
,p_no_data_found_message=>'No States found.'
,p_has_spatial_index=>false
,p_pk_column=>'ID'
,p_geometry_column_data_type=>'SDO_GEOMETRY'
,p_geometry_column=>'GEOMETRY'
,p_fill_color_is_spectrum=>true
,p_fill_color_spectr_name=>'BluYl'
,p_fill_color_spectr_type=>'SEQUENTIAL'
,p_fill_value_column=>'WATER_AREA_COLOR'
,p_fill_opacity=>.7
,p_extrude_value_column=>'WATER_AREA_COLOR'
,p_extrude_unit=>'M'
,p_tooltip_adv_formatting=>false
,p_tooltip_column=>'NAME'
,p_info_window_adv_formatting=>true
,p_info_window_html_expr=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<strong>&NAME. (&STATE_CODE.)</strong><br>',
'Land Area: &LAND_AREA. km&sup2;<br>',
'Water Area: &WATER_AREA. km&sup2;<br>'))
,p_allow_hide=>true
);
```

### Variation E: Multiple Layers (polygon + heatmap)
```sql
-- Map region with two layers on the same map
wwv_flow_imp_page.create_map_region(
 p_id=>wwv_flow_imp.id(1562218840720753113)
,p_region_id=>wwv_flow_imp.id(1562218724563753112)
,p_height=>640
,p_navigation_bar_type=>'FULL'
,p_navigation_bar_position=>'END'
,p_init_position_zoom_type=>'STATIC'
,p_init_position_lon_static=>'-90'
,p_init_position_lat_static=>'35'
,p_init_zoomlevel_static=>'3'
,p_layer_messages_position=>'BELOW'
,p_legend_position=>'END'
,p_features=>'SCALE_BAR:INFINITE_MAP:RECTANGLE_ZOOM'
);
-- Layer 1: Polygon (state boundaries)
wwv_flow_imp_page.create_map_region_layer(
 p_id=>wwv_flow_imp.id(1559019764850226582)
,p_map_region_id=>wwv_flow_imp.id(1562218840720753113)
,p_name=>'US State'
,p_layer_type=>'POLYGON'
,p_display_sequence=>10
,p_location=>'LOCAL'
,p_query_type=>'TABLE'
,p_table_name=>'EBA_SAMPLE_MAP_STATES'
,p_where_clause=>'upper(NAME) = :P110_STATE'
,p_include_rowid_column=>false
,p_items_to_submit=>'P110_STATE'
,p_has_spatial_index=>false
,p_geometry_column_data_type=>'SDO_GEOMETRY'
,p_geometry_column=>'GEOMETRY'
,p_stroke_color=>'#101010'
,p_fill_color=>'#808080'
,p_fill_color_is_spectrum=>false
,p_fill_opacity=>.3
,p_tooltip_adv_formatting=>false
,p_tooltip_column=>'NAME'
,p_info_window_adv_formatting=>false
,p_allow_hide=>true
);
-- Layer 2: Heatmap (density overlay)
wwv_flow_imp_page.create_map_region_layer(
 p_id=>wwv_flow_imp.id(1562218935915753114)
,p_map_region_id=>wwv_flow_imp.id(1562218840720753113)
,p_name=>'Airports Density'
,p_layer_type=>'HEATMAP'
,p_display_sequence=>20
,p_location=>'LOCAL'
,p_query_type=>'TABLE'
,p_table_name=>'EBA_SAMPLE_MAP_AIRPORTS'
,p_where_clause=>wwv_flow_string.join(wwv_flow_t_varchar2(
'STATE_NAME = :P110_STATE or :P110_STATE IS NULL',
'and airport_type = ''HELIPORT'' '))
,p_include_rowid_column=>false
,p_items_to_submit=>'P110_STATE'
,p_has_spatial_index=>false
,p_pk_column=>'ID'
,p_geometry_column_data_type=>'SDO_GEOMETRY'
,p_geometry_column=>'GEOMETRY'
,p_fill_color_spectr_name=>'Sunset'
,p_fill_color_spectr_type=>'SEQUENTIAL'
,p_allow_hide=>true
);
```

### Variation F: Custom SVG Markers (multiple point layers)
```sql
-- Map region with custom_styles for custom SVG markers
wwv_flow_imp_page.create_map_region(
 p_id=>wwv_flow_imp.id(1559018986908226574)
,p_region_id=>wwv_flow_imp.id(1559018872136226573)
,p_height=>640
,p_tilelayer_type=>'CUSTOM'
,p_tilelayer_name_default=>'osm-bright'
,p_tilelayer_name_dark=>'osm-bright'
,p_navigation_bar_type=>'FULL'
,p_navigation_bar_position=>'END'
,p_init_position_zoom_type=>'STATIC'
,p_init_position_lon_static=>'-90'
,p_init_position_lat_static=>'35'
,p_init_zoomlevel_static=>'3'
,p_layer_messages_position=>'BELOW'
,p_legend_position=>'END'
,p_features=>'SCALE_BAR:INFINITE_MAP:RECTANGLE_ZOOM'
,p_custom_styles=>wwv_flow_string.join(wwv_flow_t_varchar2(
'[',
'    {',
'        "name": "Airport",',
'        "width": 20,',
'        "height": 20,',
'        "paint-order": "stroke",',
'        "viewBox": "0 0 20 20",',
'        "elements": [',
'            { "type": "path", "d": "M10,2A6..." },',
'            { "type": "path", "d": "M12.9...", "fill":"#ffffff", "stroke": "none" }',
'        ]',
'    }',
']'))
);
-- Layer referencing custom marker by name
wwv_flow_imp_page.create_map_region_layer(
 p_id=>wwv_flow_imp.id(1559019078184226575)
,p_map_region_id=>wwv_flow_imp.id(1559018986908226574)
,p_name=>'Small Airports'
,p_layer_type=>'POINT'
,p_display_sequence=>10
,p_location=>'LOCAL'
,p_query_type=>'SQL'
,p_layer_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ID, IATA_CODE, initcap(AIRPORT_NAME) airport_name,',
'       case airport_type',
'           when ''HELIPORT'' then ''Heliport''',
'           else                 ''Small Airport'' end as marker_type,',
'       case airport_type',
'           when ''HELIPORT'' then ''#1e77b5''',
'           else                 ''#392423'' end as marker_color,',
'       GEOMETRY',
'  from EBA_SAMPLE_MAP_AIRPORTS',
' where COMMERCIAL_OPS between 0 and 100000'))
,p_has_spatial_index=>false
,p_pk_column=>'ID'
,p_geometry_column_data_type=>'SDO_GEOMETRY'
,p_geometry_column=>'GEOMETRY'
,p_fill_color=>'&MARKER_COLOR.'
,p_fill_opacity=>.8
,p_point_display_type=>'SVG'
,p_point_svg_shape=>'&MARKER_TYPE.'
,p_feature_clustering=>false
,p_tooltip_adv_formatting=>true
,p_tooltip_html_expr=>'&AIRPORT_NAME. (&IATA_CODE.)'
,p_info_window_adv_formatting=>true
,p_info_window_html_expr=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<strong>&AIRPORT_NAME. (&IATA_CODE.)</strong><br>',
'&CITY., &STATE_NAME.'))
,p_allow_hide=>true
);
```

## Parameter Value Catalog

| Parameter | All Observed Values |
|-----------|-------------------|
| `p_layer_type` | `'POINT'`, `'POLYGON'`, `'HEATMAP'`, `'POLYGON_3D'` |
| `p_init_position_zoom_type` | `'STATIC'`, `'QUERY_RESULTS'`, `'SQL'` |
| `p_geometry_column_data_type` | `'SDO_GEOMETRY'`, `'LONLAT_COLUMNS'` |
| `p_point_display_type` | `'SVG'` |
| `p_point_svg_shape` | `'Default'`, `'Pin Circle'`, `'Circle'`, `'Airport'`, `'Small Airport'`, `'Flag Pennant'`, `'Home'`, or `'&COL.'` substitution |
| `p_fill_color_spectr_name` | `'BluYl'`, `'Sunset'`, `'Temps'` |
| `p_fill_color_spectr_type` | `'SEQUENTIAL'`, `'DIVERGING'` |
| `p_navigation_bar_type` | `'FULL'` |
| `p_navigation_bar_position` | `'END'` |
| `p_layer_messages_position` | `'BELOW'` |
| `p_legend_position` | `'END'` |
| `p_location` (layer) | `'LOCAL'`, `'REGION_SOURCE'` |
| `p_query_type` (layer) | `'SQL'`, `'TABLE'` |
| `p_features` | `SCALE_BAR`, `INFINITE_MAP`, `RECTANGLE_ZOOM`, `MOUSEWHEEL_ZOOM`, `BROWSER_LOCATION`, `CIRCLE_TOOL`, `DISTANCE_TOOL` |
| `p_tilelayer_type` | `'CUSTOM'` |
| `p_extrude_unit` | `'M'` |
| `p_link_target_type` | `'REDIRECT_PAGE'` |

## Relationships

- **Parent**: page plug (`create_page_plug` with `NATIVE_MAP_REGION`)
- **Map region**: child of page plug (via `p_region_id`)
- **Layers**: children of map region (via `p_map_region_id`); one map can have multiple layers
- **Dynamic actions**: bind to region via `NATIVE_MAP_REGION|REGION TYPE|spatialmapobjectclick`
- **Faceted search**: map region can be a filtered region (via `p_filtered_region_id` on faceted search)
