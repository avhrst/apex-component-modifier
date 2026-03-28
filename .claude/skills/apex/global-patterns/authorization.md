# Authorization Schemes & ACL Roles

Patterns from APEX 24.2 exports (Apps 100-128, 44 authorization schemes, 14 ACL roles).

## API Calls (ordered)

1. `wwv_flow_imp_shared.create_acl_role(...)` — define application roles (optional, for ACL-based apps)
2. `wwv_flow_imp_shared.create_security_scheme(...)` — define authorization schemes

## Security Scheme Structure

```sql
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(173923801248312857)
,p_name=>'Administration Rights'
,p_scheme_type=>'NATIVE_FUNCTION_BODY'    -- see Variations below
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
 'if eba_qpoll.get_access_role (',
 '      p_app_id   => :APP_ID,',
 '      p_username => :APP_USER ) = ''ADMINISTRATOR'' then',
 'return TRUE;',
 'else return FALSE;',
 'end if;'))
,p_error_message=>'Insufficient privileges, user is not an Administrator'
,p_version_scn=>1089050995
,p_caching=>'BY_USER_BY_PAGE_VIEW'
);
```

## Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `p_id` | number | Unique ID via `wwv_flow_imp.id()` |
| `p_name` | varchar2 | Display name of the authorization scheme |
| `p_scheme_type` | varchar2 | Evaluation method (see Parameter Value Catalog) |
| `p_attribute_01` | varchar2/clob | Scheme body — SQL query, PL/SQL block, or role name(s) depending on `p_scheme_type` |
| `p_error_message` | varchar2 | Message shown when authorization fails |
| `p_caching` | varchar2 | Result caching strategy |

## Common Optional Parameters

| Parameter | Type | Typical Values | Description |
|-----------|------|----------------|-------------|
| `p_attribute_02` | varchar2 | `'A'` | For `NATIVE_IS_IN_GROUP`: `'A'` = user has ANY listed role |
| `p_version_scn` | number | `1089050995` | Internal version tracking |

## Variations

### Variation A: PL/SQL Function Body (`NATIVE_FUNCTION_BODY`)

Most common type (30 of 44 observed). The PL/SQL block must return `TRUE` or `FALSE`.

**Simple one-liner:**
```sql
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(1184321920023117158)
,p_name=>'Oracle Text is available'
,p_scheme_type=>'NATIVE_FUNCTION_BODY'
,p_attribute_01=>'return eba_demo_ig_text_pkg.text_is_available;'
,p_error_message=>'Oracle Text is not available in this workspace.'
,p_version_scn=>1089079761
,p_caching=>'BY_USER_BY_SESSION'
);
```

**Multi-line with ACL check:**
```sql
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(176228800631250021975)
,p_name=>'Reader Rights'
,p_scheme_type=>'NATIVE_FUNCTION_BODY'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
 'if nvl(apex_app_setting.get_value(',
 '   p_name => ''ACCESS_CONTROL_SCOPE''),''x'') = ''ALL_USERS'' then',
 '    -- allow user not in the ACL to access the application',
 '    return true;',
 'else',
 '    -- require user to have at least one role',
 '    return apex_acl.has_user_any_roles (',
 '        p_application_id => :APP_ID, ',
 '        p_user_name      => :APP_USER);',
 'end if;'))
,p_error_message=>'You not been granted access to this application.'
,p_version_scn=>44863178641987
,p_caching=>'BY_USER_BY_SESSION'
);
```

**Feature-level check:**
```sql
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(1382419807356287202)
,p_name=>'View Competitors'
,p_scheme_type=>'NATIVE_FUNCTION_BODY'
,p_attribute_01=>'return eba_cust.get_feature_level(:APP_USER, ''VIEW_COMPETITORS'');'
,p_error_message=>'Insufficient privileges, user is not allowed to view competitors.'
,p_version_scn=>1089051550
,p_caching=>'BY_USER_BY_SESSION'
);
```

### Variation B: EXISTS SQL Query (`NATIVE_EXISTS`)

Returns authorized if the query returns at least one row. 7 of 44 observed.

**Simple privilege check:**
```sql
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(3344719039867630860)
,p_name=>'CREATE JOB priv available'
,p_scheme_type=>'NATIVE_EXISTS'
,p_attribute_01=>'select 1 from session_privs where privilege = ''CREATE JOB'''
,p_error_message=>'CREATE JOB privilege is not available.'
,p_version_scn=>1089079098
,p_caching=>'BY_USER_BY_SESSION'
);
```

**Team membership lookup:**
```sql
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(27407243262383087377)
,p_name=>'Team Members'
,p_scheme_type=>'NATIVE_EXISTS'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
 'select 1',
 'from eba_demo_md_team_members',
 'where upper(username) = upper(:APP_USER)'))
,p_error_message=>'You must be a team member to use this application.'
,p_version_scn=>1089079371
,p_caching=>'BY_USER_BY_SESSION'
);
```

**Role-qualified data check:**
```sql
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(13978140407947599350)
,p_name=>'Can Delete Test Data'
,p_scheme_type=>'NATIVE_EXISTS'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
 'select 1',
 '  from eba_qpoll_results',
 ' where poll_id = :POLL_ID',
 '   and nvl(is_valid_yn,''Y'') = ''Y''',
 '   and preactive_yn = ''Y''',
 '   and eba_qpoll.get_access_role (',
 '           p_app_id   => :APP_ID,',
 '           p_username => :APP_USER) in (''CONTRIBUTOR'',''ADMINISTRATOR'')'))
,p_error_message=>'There is no test data for this poll.'
,p_version_scn=>1089050995
,p_caching=>'BY_USER_BY_PAGE_VIEW'
);
```

### Variation C: NOT EXISTS SQL Query (`NATIVE_NOT_EXISTS`)

Returns authorized if the query returns **no** rows. 1 of 44 observed.

```sql
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(2476185709622839982)
,p_name=>'Web Credentials not provided'
,p_scheme_type=>'NATIVE_NOT_EXISTS'
,p_attribute_01=>'select * from eba_demo_search_web_creds where credential_static_id = ''tmdb_api_key'''
,p_error_message=>'Required web credentials are not provided.'
,p_version_scn=>1089051718
,p_caching=>'BY_USER_BY_PAGE_VIEW'
);
```

### Variation D: Is In Role/Group (`NATIVE_IS_IN_GROUP`)

Checks APEX Access Control roles. `p_attribute_01` is a comma-separated list of role names; `p_attribute_02=>'A'` means user must have ANY of them. 6 of 44 observed.

**Single role:**
```sql
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(176228800578950021975)
,p_name=>'Administration Rights'
,p_scheme_type=>'NATIVE_IS_IN_GROUP'
,p_attribute_01=>'Administrator'
,p_attribute_02=>'A'
,p_error_message=>'Insufficient privileges, user is not an Administrator'
,p_version_scn=>1
,p_caching=>'BY_USER_BY_PAGE_VIEW'
);
```

**Multiple roles (any match):**
```sql
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(48327611941238013850)
,p_name=>'Host'
,p_scheme_type=>'NATIVE_IS_IN_GROUP'
,p_attribute_01=>'Administrator,Host'
,p_attribute_02=>'A'
,p_error_message=>'Insufficient privileges, user is not a Host'
,p_version_scn=>37167711609130
,p_caching=>'BY_USER_BY_PAGE_VIEW'
);
```

## ACL Role Structure

ACL roles define application-level roles used by `NATIVE_IS_IN_GROUP` schemes. Exported to `shared_components/security/app_access_control/`.

```sql
wwv_flow_imp_shared.create_acl_role(
 p_id=>wwv_flow_imp.id(173923392351312851)
,p_static_id=>'ADMINISTRATOR'
,p_name=>'Administrator'
,p_description=>'Role assigned to application administrators.'
,p_version_scn=>37166093786642
);
```

### ACL Role Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `p_id` | number | Unique ID via `wwv_flow_imp.id()` |
| `p_static_id` | varchar2 | Uppercase identifier (e.g., `'ADMINISTRATOR'`, `'CONTRIBUTOR'`, `'READER'`) |
| `p_name` | varchar2 | Display name |
| `p_description` | varchar2 | Role description |
| `p_version_scn` | number | Internal version tracking |

### Common ACL Role Patterns

Typical three-tier setup:
```sql
-- Role 1: Administrator
wwv_flow_imp_shared.create_acl_role(
 p_id=>wwv_flow_imp.id(173923392351312851)
,p_static_id=>'ADMINISTRATOR'
,p_name=>'Administrator'
,p_description=>'Role assigned to application administrators.'
);

-- Role 2: Contributor
wwv_flow_imp_shared.create_acl_role(
 p_id=>wwv_flow_imp.id(173923630409312856)
,p_static_id=>'CONTRIBUTOR'
,p_name=>'Contributor'
,p_description=>'Role assigned to application contributors.'
);

-- Role 3: Reader
wwv_flow_imp_shared.create_acl_role(
 p_id=>wwv_flow_imp.id(173923673092312856)
,p_static_id=>'READER'
,p_name=>'Reader'
,p_description=>'Role assigned to application readers.'
);
```

## Parameter Value Catalog

| Parameter | All Observed Values |
|-----------|-------------------|
| `p_scheme_type` | `NATIVE_FUNCTION_BODY` (30), `NATIVE_EXISTS` (7), `NATIVE_IS_IN_GROUP` (6), `NATIVE_NOT_EXISTS` (1) |
| `p_caching` | `BY_USER_BY_PAGE_VIEW` (26), `BY_USER_BY_SESSION` (18) |
| `p_attribute_02` | `'A'` (all `NATIVE_IS_IN_GROUP` instances — "user has Any listed role") |

## Relationships

- **Used by**: pages (`p_security_scheme`), regions (`p_security_scheme`), items (`p_security_scheme`), buttons (`p_security_scheme`), processes (`p_security_scheme`), dynamic actions, list items, navigation bar entries, build options
- **ACL roles** are referenced by `NATIVE_IS_IN_GROUP` schemes via `p_attribute_01`
- **Authentication schemes** (separate component) control login; authorization schemes control access after login
- **File paths**: `shared_components/security/authorizations/` (schemes), `shared_components/security/app_access_control/` (ACL roles)

## Caching Guidelines

| Caching Value | Use When |
|---------------|----------|
| `BY_USER_BY_PAGE_VIEW` | Result may change between page views (data-dependent checks, page-specific conditions) |
| `BY_USER_BY_SESSION` | Result is stable for the session (role membership, privilege checks, feature flags) |
