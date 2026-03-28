# Component: Web Source Modules

Web source modules connect APEX to external REST APIs. Exported to `shared_components/web_sources/` with companion data profiles in `shared_components/data_profiles/`.

## API Calls (ordered)

1. `wwv_flow_imp_shared.create_data_profile(...)` — response shape definition
2. `wwv_flow_imp_shared.create_data_profile_col(...)` — one per column in profile
3. `wwv_flow_imp_shared.create_web_source_module(...)` — the REST source itself
4. `wwv_flow_imp_shared.create_web_source_operation(...)` — HTTP operations (GET/POST/PUT/DELETE)
5. `wwv_flow_imp_shared.create_web_source_param(...)` — URL, query, header, body params

## Module (`create_web_source_module`)

### Required Parameters
| Parameter | Description |
|-----------|-------------|
| `p_id` | Unique ID (`wwv_flow_imp.id(...)`) |
| `p_name` | Display name |
| `p_static_id` | Static identifier for binding |
| `p_web_source_type` | Source type (see catalog) |
| `p_data_profile_id` | Link to data profile |
| `p_remote_server_id` | Link to remote server definition |
| `p_url_path_prefix` | URL path appended to remote server base |

### Common Optional Parameters
| Parameter | Description |
|-----------|-------------|
| `p_credential_id` | Link to credential store |
| `p_pass_ecid` | Pass execution context ID (`true`/`false`) |
| `p_sync_max_http_requests` | Max requests for synchronization (e.g. `1000`) |
| `p_attribute_01` | Pagination type or ORDS flag (see catalog) |
| `p_attribute_04`..`p_attribute_11` | Pagination / connector-specific settings |
| `p_version_scn` | Version SCN for optimistic locking |

## Operations (`create_web_source_operation`)

Each operation maps an HTTP verb to a database operation.

### Required Parameters
| Parameter | Description |
|-----------|-------------|
| `p_id` | Unique ID |
| `p_web_src_module_id` | Parent module ID |
| `p_operation` | HTTP verb: `GET`, `POST`, `PUT`, `DELETE` |
| `p_database_operation` | Logical operation (see catalog) |
| `p_url_pattern` | URL pattern (`.` = base, `:param` = variable) |

### Common Optional Parameters
| Parameter | Description |
|-----------|-------------|
| `p_name` | Named operation (for custom operations) |
| `p_force_error_for_http_404` | Raise error on 404 (`true`/`false`) |
| `p_allow_fetch_all_rows` | Allow unbounded fetch (`true`/`false`) |
| `p_legacy_ords_fixed_page_size` | Fixed page size for pagination |
| `p_caching` | Cache policy: `ALL_USERS` |
| `p_invalidate_when` | Cache TTL in seconds (e.g. `3600`) |

### Standard Operation Patterns

| HTTP Verb | `p_database_operation` | `p_url_pattern` | Purpose |
|-----------|----------------------|-----------------|---------|
| `GET` | `FETCH_COLLECTION` | `.` | List / search |
| `GET` | `FETCH_SINGLE_ROW` | `:id` | Get one record |
| `POST` | `INSERT` | `.` | Create |
| `PUT` | `UPDATE` | `:id` | Update |
| `DELETE` | `DELETE` | `:id` | Delete |

## Parameters (`create_web_source_param`)

### Required Parameters
| Parameter | Description |
|-----------|-------------|
| `p_id` | Unique ID |
| `p_web_src_module_id` | Parent module ID |
| `p_name` | Parameter name |
| `p_param_type` | Binding type (see catalog) |
| `p_data_type` | Data type (usually `VARCHAR2`) |
| `p_is_required` | Required flag (`true`/`false`) |

### Common Optional Parameters
| Parameter | Description |
|-----------|-------------|
| `p_web_src_operation_id` | Scope to specific operation (omit = all operations) |
| `p_value` | Default/static value |
| `p_is_query_param` | Expose as query string param (`true`) |

## Data Profiles (`create_data_profile`)

### Required Parameters
| Parameter | Description |
|-----------|-------------|
| `p_id` | Unique ID |
| `p_name` | Profile name |
| `p_format` | Response format: `JSON` |

### Common Optional Parameters
| Parameter | Description |
|-----------|-------------|
| `p_row_selector` | JSON path to results array (e.g. `results`, `items`) |
| `p_use_raw_json_selectors` | Use raw JSON selectors (`true`/`false`) |

## Data Profile Columns (`create_data_profile_col`)

### Required Parameters
| Parameter | Description |
|-----------|-------------|
| `p_id` | Unique ID |
| `p_data_profile_id` | Parent profile ID |
| `p_name` | Column name (uppercase) |
| `p_sequence` | Display order |
| `p_column_type` | Column type (see catalog) |
| `p_data_type` | Data type (see catalog) |
| `p_has_time_zone` | Timezone flag (`true`/`false`) |

### Common Optional Parameters
| Parameter | Description |
|-----------|-------------|
| `p_max_length` | Max length for VARCHAR2 (e.g. `4000`) |
| `p_format_mask` | Date/timestamp format (e.g. `YYYY"-"MM"-"DD`) |
| `p_selector` | JSON field name in source response |

## Variations

### Variation A: Simple REST GET (read-only, with pagination)

From `f104 — Search Movie`: a single GET endpoint with query parameter and page-number pagination.

```sql
-- Data profile (in shared_components/data_profiles/moviedb.sql)
wwv_flow_imp_shared.create_data_profile(
 p_id=>wwv_flow_imp.id(4932370933276710767)
,p_name=>'MovieDB'
,p_format=>'JSON'
,p_row_selector=>'results'
,p_use_raw_json_selectors=>false
);
wwv_flow_imp_shared.create_data_profile_col(
 p_id=>wwv_flow_imp.id(4932371122907710770)
,p_data_profile_id=>wwv_flow_imp.id(4932370933276710767)
,p_name=>'ID'
,p_sequence=>1
,p_column_type=>'DATA'
,p_data_type=>'NUMBER'
,p_has_time_zone=>false
,p_selector=>'id'
);
wwv_flow_imp_shared.create_data_profile_col(
 p_id=>wwv_flow_imp.id(4932371408744710771)
,p_data_profile_id=>wwv_flow_imp.id(4932370933276710767)
,p_name=>'TITLE'
,p_sequence=>3
,p_column_type=>'DATA'
,p_data_type=>'VARCHAR2'
,p_max_length=>4000
,p_has_time_zone=>false
,p_selector=>'title'
);
wwv_flow_imp_shared.create_data_profile_col(
 p_id=>wwv_flow_imp.id(4932373512847710772)
,p_data_profile_id=>wwv_flow_imp.id(4932370933276710767)
,p_name=>'RELEASE_DATE'
,p_sequence=>9
,p_column_type=>'DATA'
,p_data_type=>'DATE'
,p_format_mask=>'YYYY"-"MM"-"DD'
,p_has_time_zone=>false
,p_selector=>'release_date'
);

-- Web source module (in shared_components/web_sources/search_movie.sql)
wwv_flow_imp_shared.create_web_source_module(
 p_id=>wwv_flow_imp.id(4932374960269710775)
,p_name=>'Search Movie'
,p_static_id=>'MovieDB'
,p_web_source_type=>'NATIVE_HTTP'
,p_data_profile_id=>wwv_flow_imp.id(4932370933276710767)
,p_remote_server_id=>wwv_flow_imp.id(2449266503043675887)
,p_url_path_prefix=>'/search/movie'
,p_credential_id=>wwv_flow_imp.id(2472887714501516654)
,p_pass_ecid=>true
,p_attribute_01=>'PAGE_NUMBER_FIXED_SIZE'
,p_attribute_04=>'page'
,p_attribute_05=>'1'
,p_attribute_06=>'20'
,p_attribute_08=>'OFFSET'
,p_attribute_10=>'EQUALS'
,p_attribute_11=>'true'
);
wwv_flow_imp_shared.create_web_source_param(
 p_id=>wwv_flow_imp.id(4932375630069710779)
,p_web_src_module_id=>wwv_flow_imp.id(4932374960269710775)
,p_name=>'query'
,p_param_type=>'QUERY_STRING'
,p_data_type=>'VARCHAR2'
,p_is_required=>false
,p_value=>'Jack+Reacher'
,p_is_query_param=>true
);
wwv_flow_imp_shared.create_web_source_operation(
 p_id=>wwv_flow_imp.id(4932375177142710777)
,p_web_src_module_id=>wwv_flow_imp.id(4932374960269710775)
,p_operation=>'GET'
,p_database_operation=>'FETCH_COLLECTION'
,p_url_pattern=>'.'
,p_legacy_ords_fixed_page_size=>20
,p_force_error_for_http_404=>false
,p_allow_fetch_all_rows=>false
);
```

### Variation B: Full CRUD REST Source (NATIVE_HTTP)

From `f118 — EBA_REST_DATA_EMPLOYEE`: five operations covering list, get-one, create, update, delete with operation-scoped parameters.

```sql
wwv_flow_imp_shared.create_web_source_module(
 p_id=>wwv_flow_imp.id(101218329416132908)
,p_name=>'EBA_REST_DATA_EMPLOYEE'
,p_static_id=>'Employee_ords_rest_source'
,p_web_source_type=>'NATIVE_HTTP'
,p_data_profile_id=>wwv_flow_imp.id(101215687906132907)
,p_remote_server_id=>wwv_flow_imp.id(25224818019563042)
,p_url_path_prefix=>'employee/'
,p_sync_max_http_requests=>1000
);
-- GET collection (list)
wwv_flow_imp_shared.create_web_source_operation(
 p_id=>wwv_flow_imp.id(101218524521132908)
,p_web_src_module_id=>wwv_flow_imp.id(101218329416132908)
,p_operation=>'GET'
,p_database_operation=>'FETCH_COLLECTION'
,p_url_pattern=>'.'
,p_force_error_for_http_404=>false
,p_allow_fetch_all_rows=>false
);
-- Operation-scoped query param (only for FETCH_COLLECTION)
wwv_flow_imp_shared.create_web_source_param(
 p_id=>wwv_flow_imp.id(103387632147977049)
,p_web_src_module_id=>wwv_flow_imp.id(101218329416132908)
,p_web_src_operation_id=>wwv_flow_imp.id(101218524521132908)
,p_name=>'query'
,p_param_type=>'QUERY_STRING'
,p_data_type=>'VARCHAR2'
,p_is_required=>false
);
-- GET single row
wwv_flow_imp_shared.create_web_source_operation(
 p_id=>wwv_flow_imp.id(101219683166132908)
,p_web_src_module_id=>wwv_flow_imp.id(101218329416132908)
,p_operation=>'GET'
,p_database_operation=>'FETCH_SINGLE_ROW'
,p_url_pattern=>':empno'
,p_force_error_for_http_404=>false
,p_allow_fetch_all_rows=>false
);
-- POST (insert)
wwv_flow_imp_shared.create_web_source_operation(
 p_id=>wwv_flow_imp.id(101218899684132908)
,p_web_src_module_id=>wwv_flow_imp.id(101218329416132908)
,p_operation=>'POST'
,p_database_operation=>'INSERT'
,p_url_pattern=>'.'
,p_allow_fetch_all_rows=>false
);
-- PUT (update)
wwv_flow_imp_shared.create_web_source_operation(
 p_id=>wwv_flow_imp.id(101220164652132908)
,p_web_src_module_id=>wwv_flow_imp.id(101218329416132908)
,p_operation=>'PUT'
,p_database_operation=>'UPDATE'
,p_url_pattern=>':empno'
,p_allow_fetch_all_rows=>false
);
-- DELETE
wwv_flow_imp_shared.create_web_source_operation(
 p_id=>wwv_flow_imp.id(101219286404132908)
,p_web_src_module_id=>wwv_flow_imp.id(101218329416132908)
,p_operation=>'DELETE'
,p_database_operation=>'DELETE'
,p_url_pattern=>':empno'
,p_allow_fetch_all_rows=>false
);
```

### Variation C: NATIVE_ORDS with Full CRUD

From `f118 — EBA_REST_DEPARTMENT`: ORDS-native source with auto-discovered operations.

```sql
wwv_flow_imp_shared.create_web_source_module(
 p_id=>wwv_flow_imp.id(103026320083143190)
,p_name=>'EBA_REST_DEPARTMENT'
,p_static_id=>'eba_rest_department'
,p_web_source_type=>'NATIVE_ORDS'
,p_data_profile_id=>wwv_flow_imp.id(103025256379143183)
,p_remote_server_id=>wwv_flow_imp.id(25224818019563042)
,p_url_path_prefix=>'departments/'
,p_sync_max_http_requests=>1000
,p_attribute_01=>'N'
,p_attribute_02=>'HIGHEST'
);
wwv_flow_imp_shared.create_web_source_operation(
 p_id=>wwv_flow_imp.id(103026486874143193)
,p_web_src_module_id=>wwv_flow_imp.id(103026320083143190)
,p_operation=>'GET'
,p_database_operation=>'FETCH_COLLECTION'
,p_url_pattern=>'.'
,p_force_error_for_http_404=>false
,p_allow_fetch_all_rows=>false
);
wwv_flow_imp_shared.create_web_source_operation(
 p_id=>wwv_flow_imp.id(103027770796143194)
,p_web_src_module_id=>wwv_flow_imp.id(103026320083143190)
,p_operation=>'GET'
,p_database_operation=>'FETCH_SINGLE_ROW'
,p_url_pattern=>':deptno'
,p_allow_fetch_all_rows=>false
);
wwv_flow_imp_shared.create_web_source_operation(
 p_id=>wwv_flow_imp.id(103026976156143194)
,p_web_src_module_id=>wwv_flow_imp.id(103026320083143190)
,p_operation=>'POST'
,p_database_operation=>'INSERT'
,p_url_pattern=>'.'
,p_allow_fetch_all_rows=>false
);
wwv_flow_imp_shared.create_web_source_operation(
 p_id=>wwv_flow_imp.id(103028116612143194)
,p_web_src_module_id=>wwv_flow_imp.id(103026320083143190)
,p_operation=>'PUT'
,p_database_operation=>'UPDATE'
,p_url_pattern=>':deptno'
,p_allow_fetch_all_rows=>false
);
wwv_flow_imp_shared.create_web_source_operation(
 p_id=>wwv_flow_imp.id(103027344637143194)
,p_web_src_module_id=>wwv_flow_imp.id(103026320083143190)
,p_operation=>'DELETE'
,p_database_operation=>'DELETE'
,p_url_pattern=>':deptno'
,p_allow_fetch_all_rows=>false
);
```

### Variation D: With Caching and Multiple Query Parameters

From `f106 — APEX YouTube Playlists`: cached responses with multiple query string parameters.

```sql
wwv_flow_imp_shared.create_web_source_module(
 p_id=>wwv_flow_imp.id(10750079109168629898)
,p_name=>'APEX YouTube Playlists'
,p_static_id=>'APEX_Youtube_Playlists'
,p_web_source_type=>'NATIVE_HTTP'
,p_data_profile_id=>wwv_flow_imp.id(10750070793083629877)
,p_remote_server_id=>wwv_flow_imp.id(1360466600656517170)
,p_url_path_prefix=>'/playlists'
,p_credential_id=>wwv_flow_imp.id(4431125020069946085)
,p_pass_ecid=>true
);
wwv_flow_imp_shared.create_web_source_param(
 p_id=>wwv_flow_imp.id(10750079706790629911)
,p_web_src_module_id=>wwv_flow_imp.id(10750079109168629898)
,p_name=>'channelId'
,p_param_type=>'QUERY_STRING'
,p_data_type=>'VARCHAR2'
,p_is_required=>false
,p_value=>'UCEpIXFjcQIztReQNLymvYrQ'
);
wwv_flow_imp_shared.create_web_source_param(
 p_id=>wwv_flow_imp.id(10750080458098629915)
,p_web_src_module_id=>wwv_flow_imp.id(10750079109168629898)
,p_name=>'maxResults'
,p_param_type=>'QUERY_STRING'
,p_data_type=>'VARCHAR2'
,p_is_required=>false
,p_value=>'25'
);
wwv_flow_imp_shared.create_web_source_param(
 p_id=>wwv_flow_imp.id(10750080874294629915)
,p_web_src_module_id=>wwv_flow_imp.id(10750079109168629898)
,p_name=>'part'
,p_param_type=>'QUERY_STRING'
,p_data_type=>'VARCHAR2'
,p_is_required=>false
,p_value=>'snippet,contentDetails,player'
);
wwv_flow_imp_shared.create_web_source_operation(
 p_id=>wwv_flow_imp.id(10750079337142629906)
,p_web_src_module_id=>wwv_flow_imp.id(10750079109168629898)
,p_operation=>'GET'
,p_database_operation=>'FETCH_COLLECTION'
,p_url_pattern=>'.'
,p_force_error_for_http_404=>false
,p_allow_fetch_all_rows=>false
,p_caching=>'ALL_USERS'
,p_invalidate_when=>'10080'
);
```

### Variation E: URL Pattern Parameters

From `f104 — Company Details`: URL path variable bound via `URL_PATTERN` param type.

```sql
wwv_flow_imp_shared.create_web_source_module(
 p_id=>wwv_flow_imp.id(4124192887554152992)
,p_name=>'Company Details'
,p_static_id=>'Company_Details'
,p_web_source_type=>'NATIVE_HTTP'
,p_data_profile_id=>wwv_flow_imp.id(4124190292554152990)
,p_remote_server_id=>wwv_flow_imp.id(2449266503043675887)
,p_url_path_prefix=>'company/{company_id}'
,p_credential_id=>wwv_flow_imp.id(2472887714501516654)
,p_pass_ecid=>true
);
wwv_flow_imp_shared.create_web_source_param(
 p_id=>wwv_flow_imp.id(4124193551816152993)
,p_web_src_module_id=>wwv_flow_imp.id(4124192887554152992)
,p_name=>'company_id'
,p_param_type=>'URL_PATTERN'
,p_data_type=>'VARCHAR2'
,p_is_required=>false
,p_value=>'1'
);
wwv_flow_imp_shared.create_web_source_operation(
 p_id=>wwv_flow_imp.id(4124193126519152992)
,p_web_src_module_id=>wwv_flow_imp.id(4124192887554152992)
,p_operation=>'GET'
,p_database_operation=>'FETCH_COLLECTION'
,p_url_pattern=>'.'
,p_force_error_for_http_404=>false
,p_allow_fetch_all_rows=>false
);
```

## Parameter Value Catalog

| Parameter | All Observed Values |
|-----------|-------------------|
| `p_web_source_type` | `NATIVE_HTTP` (13), `NATIVE_ORDS` (11), `NATIVE_ODATA` (1), `PLUGIN_COM.ORACLE.APEX.RESTSOURCE.FIXEDPAGESIZE` (1) |
| `p_operation` | `GET` (33), `PUT` (7), `POST` (6), `DELETE` (5) |
| `p_database_operation` | `FETCH_COLLECTION` (25), `FETCH_SINGLE_ROW` (7), `UPDATE` (7), `INSERT` (6), `DELETE` (5) |
| `p_param_type` | `QUERY_STRING` (16), `URL_PATTERN` (7), `BODY` (6), `DATA_PROFILE` (4), `HEADER` (3) |
| `p_format` (data profile) | `JSON` (26) |
| `p_column_type` | `DATA` (246), `SQL_EXPRESSION` (2) |
| `p_data_type` (profile col) | `VARCHAR2` (160), `NUMBER` (101), `DATE` (10), `TIMESTAMP WITH TIME ZONE` (9), `ARRAY` (7) |
| `p_caching` | `ALL_USERS` (4) |
| `p_attribute_01` (NATIVE_HTTP) | `PAGE_NUMBER_FIXED_SIZE`, `FLEXIBLE` — pagination type |
| `p_attribute_01` (NATIVE_ORDS) | `N` (11) — external filtering flag |
| `p_attribute_02` (NATIVE_ORDS) | `HIGHEST` — version negotiation |

## Relationships

- **Used by regions**: `p_location=>'WEB_SOURCE'` + `p_web_src_module_id=>...` in `create_page_plug`
- **Used by processes**: plug source type `NATIVE_WEB_SERVICE`
- **Depends on**: Remote Servers (`p_remote_server_id`), Credentials (`p_credential_id`), Data Profiles (`p_data_profile_id`)
- **File locations**: `shared_components/web_sources/*.sql`, `shared_components/data_profiles/*.sql`
