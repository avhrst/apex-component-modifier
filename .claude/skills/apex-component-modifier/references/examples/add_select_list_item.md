# Example: Add a Select List Item to a Page

Complete patching flow from export to import for adding a new `P10_STATUS` select list item.

---

## Before (original export snippet from `page_00010.sql`)

The page has one region ("Details", ID `4937364850118364`) with one existing item.

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

## Patch (unified diff)

```diff
--- a/f113/application/pages/page_00010.sql
+++ b/f113/application/pages/page_00010.sql
@@ manifest section — add new item to the list @@
+--   ...   P10_STATUS
@@ after the P10_NAME create_page_item end;/ block @@
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

## Key decisions in this patch

| Decision | Reasoning |
|----------|-----------|
| ID `4937365100000001` | Max existing ID was `4937365012648365`; picked a value above it |
| `p_item_sequence=>20` | Existing item is at 10; next logical gap |
| `p_item_plug_id` matches region | Same region `4937364850118364` as the existing item |
| `p_named_lov=>'STATUS_LOV'` | References LOV by name (string), not by ID |
| `p_field_template` reuses existing | Same label template as other items on the page |
| `p_display_as=>'NATIVE_SELECT_LIST'` | Valid value from `valid_values.md` |

## After import

Verify by re-exporting page 10 and confirming P10_STATUS appears with correct attributes.
