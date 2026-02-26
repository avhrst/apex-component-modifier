prompt --application/pages/delete_00001
begin
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.0'
,p_default_workspace_id=>7059346057325215
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'AI'
);
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>1);
wwv_flow_imp.component_end;
end;
/
