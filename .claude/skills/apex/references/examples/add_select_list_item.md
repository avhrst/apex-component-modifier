# Example: Add a Select List Item to a Page

Complete patching flow for adding `P10_STATUS` select list item.

## Before (original from `page_00010.sql`)

Page has region "Details" (ID `4937364850118364`) with one existing item.

```sql
begin
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(4937365012648365)
,p_name=>'P10_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(4937364850118364)
,p_item_source_plug_id=>wwv_flow_imp.id(4937364850118364)
,p_prompt=>'Name'
,p_source=>'NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cMaxlength=>255
,p_field_template=>wwv_flow_imp.id(1859094942498559411)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'Y'
,p_protection_level=>'S'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
);
end;
/
```

## Patch (diff)

```diff
--- a/f113/application/pages/page_00010.sql
+++ b/f113/application/pages/page_00010.sql
@@ manifest section -- add new item @@
+--   ...   P10_STATUS
@@ after P10_NAME block @@
+begin
+wwv_flow_imp_page.create_page_item(
+ p_id=>wwv_flow_imp.id(4937365100000001)
+,p_name=>'P10_STATUS'
+,p_source_data_type=>'VARCHAR2'
+,p_item_sequence=>20
+,p_item_plug_id=>wwv_flow_imp.id(4937364850118364)
+,p_item_source_plug_id=>wwv_flow_imp.id(4937364850118364)
+,p_prompt=>'Status'
+,p_source=>'STATUS'
+,p_source_type=>'REGION_SOURCE_COLUMN'
+,p_display_as=>'NATIVE_SELECT_LIST'
+,p_named_lov=>'STATUS_LOV'
+,p_lov_display_null=>'YES'
+,p_lov_null_text=>'- Select -'
+,p_cHeight=>1
+,p_field_template=>wwv_flow_imp.id(1859094942498559411)
+,p_item_template_options=>'#DEFAULT#'
+,p_is_persistent=>'Y'
+,p_protection_level=>'S'
+,p_attribute_01=>'NONE'
+,p_attribute_02=>'N'
+);
+end;
+/
```

## Key decisions

| Decision | Reasoning |
|----------|-----------|
| ID `4937365100000001` | Max existing was `4937365012648365`; picked above it |
| `p_item_sequence=>20` | Existing at 10; next logical gap |
| `p_item_plug_id` matches region | Same region `4937364850118364` |
| `p_named_lov=>'STATUS_LOV'` | References LOV by name (string), not ID |
| `p_field_template` reused | Same label template as other items |
| `p_display_as=>'NATIVE_SELECT_LIST'` | Valid value from `valid_values.md` |

## After import

Re-export page 10, confirm P10_STATUS appears with correct attributes.
