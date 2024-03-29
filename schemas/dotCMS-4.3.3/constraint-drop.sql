 ALTER TABLE "public"."analytic_summary" DROP CONSTRAINT "fk9e1a7f4b7b46300";
 ALTER TABLE "public"."analytic_summary_404" DROP CONSTRAINT "fk7050866db7b46300";
 ALTER TABLE "public"."analytic_summary_content" DROP CONSTRAINT "fk53cb4f2eed30e054";
 ALTER TABLE "public"."analytic_summary_pages" DROP CONSTRAINT "fka1ad33b9ed30e054";
 ALTER TABLE "public"."analytic_summary_referer" DROP CONSTRAINT "fk5bc0f3e2ed30e054";
 ALTER TABLE "public"."analytic_summary_visits" DROP CONSTRAINT "fk9eac9733b7b46300";
 ALTER TABLE "public"."broken_link" DROP CONSTRAINT "fk_brokenl_content";
 ALTER TABLE "public"."broken_link" DROP CONSTRAINT "fk_brokenl_field";
 ALTER TABLE "public"."campaign" DROP CONSTRAINT "fkf7a901105fb51eb";
 ALTER TABLE "public"."category" DROP CONSTRAINT "fk302bcfe5fb51eb";
 ALTER TABLE "public"."chain_state" DROP CONSTRAINT "fk_state_chain";
 ALTER TABLE "public"."chain_state" DROP CONSTRAINT "fk_state_code";
 ALTER TABLE "public"."chain_state_parameter" DROP CONSTRAINT "fk_parameter_state";
 ALTER TABLE "public"."click" DROP CONSTRAINT "fk5a5c5885fb51eb";
 ALTER TABLE "public"."cluster_server" DROP CONSTRAINT "fk_cluster_id";
 ALTER TABLE "public"."cluster_server_uptime" DROP CONSTRAINT "cluster_server_uptime_server_id_fkey";
 ALTER TABLE "public"."cluster_server_uptime" DROP CONSTRAINT "fk_cluster_server_id";
 ALTER TABLE "public"."cms_layouts_portlets" DROP CONSTRAINT "fkcms_layouts_portlets";
 ALTER TABLE "public"."cms_role" DROP CONSTRAINT "fkcms_role_parent";
 ALTER TABLE "public"."cms_roles_ir" DROP CONSTRAINT "fk_cms_roles_ir_ep";
 ALTER TABLE "public"."communication" DROP CONSTRAINT "fkc24acfd65fb51eb";
 ALTER TABLE "public"."container_structures" DROP CONSTRAINT "fk_cs_container_id";
 ALTER TABLE "public"."container_structures" DROP CONSTRAINT "fk_cs_inode";
 ALTER TABLE "public"."container_version_info" DROP CONSTRAINT "fk_container_version_info_identifier";
 ALTER TABLE "public"."container_version_info" DROP CONSTRAINT "fk_container_version_info_live";
 ALTER TABLE "public"."container_version_info" DROP CONSTRAINT "fk_container_version_info_working";
 ALTER TABLE "public"."container_version_info" DROP CONSTRAINT "fk_tainer_ver_info_lockedby";
 ALTER TABLE "public"."contentlet" DROP CONSTRAINT "content_identifier_fk";
 ALTER TABLE "public"."contentlet" DROP CONSTRAINT "fk_contentlet_lang";
 ALTER TABLE "public"."contentlet" DROP CONSTRAINT "fk_structure_inode";
 ALTER TABLE "public"."contentlet" DROP CONSTRAINT "fk_user_contentlet";
 ALTER TABLE "public"."contentlet" DROP CONSTRAINT "fkfc4ef025fb51eb";
 ALTER TABLE "public"."contentlet_version_info" DROP CONSTRAINT "fk_con_ver_lockedby";
 ALTER TABLE "public"."contentlet_version_info" DROP CONSTRAINT "fk_contentlet_version_info_identifier";
 ALTER TABLE "public"."contentlet_version_info" DROP CONSTRAINT "fk_contentlet_version_info_lang";
 ALTER TABLE "public"."contentlet_version_info" DROP CONSTRAINT "fk_contentlet_version_info_live";
 ALTER TABLE "public"."contentlet_version_info" DROP CONSTRAINT "fk_contentlet_version_info_working";
 ALTER TABLE "public"."dashboard_user_preferences" DROP CONSTRAINT "fk496242cfd12c0c3b";
 ALTER TABLE "public"."dot_containers" DROP CONSTRAINT "containers_identifier_fk";
 ALTER TABLE "public"."dot_containers" DROP CONSTRAINT "fk8a844125fb51eb";
 ALTER TABLE "public"."dot_containers" DROP CONSTRAINT "fk_user_containers";
 ALTER TABLE "public"."field" DROP CONSTRAINT "fk5cea0fa5fb51eb";
 ALTER TABLE "public"."fileassets_ir" DROP CONSTRAINT "fk_file_ir_ep";
 ALTER TABLE "public"."folder" DROP CONSTRAINT "fk_folder_file_structure_type";
 ALTER TABLE "public"."folder" DROP CONSTRAINT "fkb45d1c6e5fb51eb";
 ALTER TABLE "public"."folder" DROP CONSTRAINT "folder_identifier_fk";
 ALTER TABLE "public"."folders_ir" DROP CONSTRAINT "fk_folder_ir_ep";
 ALTER TABLE "public"."htmlpages_ir" DROP CONSTRAINT "fk_page_ir_ep";
 ALTER TABLE "public"."layouts_cms_roles" DROP CONSTRAINT "fklayouts_cms_roles1";
 ALTER TABLE "public"."layouts_cms_roles" DROP CONSTRAINT "fklayouts_cms_roles2";
 ALTER TABLE "public"."link_version_info" DROP CONSTRAINT "fk_link_ver_info_lockedby";
 ALTER TABLE "public"."link_version_info" DROP CONSTRAINT "fk_link_version_info_identifier";
 ALTER TABLE "public"."link_version_info" DROP CONSTRAINT "fk_link_version_info_live";
 ALTER TABLE "public"."link_version_info" DROP CONSTRAINT "fk_link_version_info_working";
 ALTER TABLE "public"."links" DROP CONSTRAINT "fk6234fb95fb51eb";
 ALTER TABLE "public"."links" DROP CONSTRAINT "fk_user_links";
 ALTER TABLE "public"."links" DROP CONSTRAINT "links_identifier_fk";
 ALTER TABLE "public"."mailing_list" DROP CONSTRAINT "fk7bc2cd925fb51eb";
 ALTER TABLE "public"."permission" DROP CONSTRAINT "permission_role_fk";
 ALTER TABLE "public"."plugin_property" DROP CONSTRAINT "fk_plugin_plugin_property";
 ALTER TABLE "public"."publishing_bundle" DROP CONSTRAINT "fk_publishing_bundle_owner";
 ALTER TABLE "public"."publishing_bundle_environment" DROP CONSTRAINT "fk_bundle_id";
 ALTER TABLE "public"."publishing_bundle_environment" DROP CONSTRAINT "fk_environment_id";
 ALTER TABLE "public"."qrtz_blob_triggers" DROP CONSTRAINT "qrtz_blob_triggers_trigger_name_fkey";
 ALTER TABLE "public"."qrtz_cron_triggers" DROP CONSTRAINT "qrtz_cron_triggers_trigger_name_fkey";
 ALTER TABLE "public"."qrtz_excl_blob_triggers" DROP CONSTRAINT "qrtz_excl_blob_triggers_trigger_name_fkey";
 ALTER TABLE "public"."qrtz_excl_cron_triggers" DROP CONSTRAINT "qrtz_excl_cron_triggers_trigger_name_fkey";
 ALTER TABLE "public"."qrtz_excl_job_listeners" DROP CONSTRAINT "qrtz_excl_job_listeners_job_name_fkey";
 ALTER TABLE "public"."qrtz_excl_simple_triggers" DROP CONSTRAINT "qrtz_excl_simple_triggers_trigger_name_fkey";
 ALTER TABLE "public"."qrtz_excl_trigger_listeners" DROP CONSTRAINT "qrtz_excl_trigger_listeners_trigger_name_fkey";
 ALTER TABLE "public"."qrtz_excl_triggers" DROP CONSTRAINT "qrtz_excl_triggers_job_name_fkey";
 ALTER TABLE "public"."qrtz_job_listeners" DROP CONSTRAINT "qrtz_job_listeners_job_name_fkey";
 ALTER TABLE "public"."qrtz_simple_triggers" DROP CONSTRAINT "qrtz_simple_triggers_trigger_name_fkey";
 ALTER TABLE "public"."qrtz_trigger_listeners" DROP CONSTRAINT "qrtz_trigger_listeners_trigger_name_fkey";
 ALTER TABLE "public"."qrtz_triggers" DROP CONSTRAINT "qrtz_triggers_job_name_fkey";
 ALTER TABLE "public"."recipient" DROP CONSTRAINT "fk30e172195fb51eb";
 ALTER TABLE "public"."relationship" DROP CONSTRAINT "fkf06476385fb51eb";
 ALTER TABLE "public"."report_asset" DROP CONSTRAINT "fk3765ec255fb51eb";
 ALTER TABLE "public"."report_parameter" DROP CONSTRAINT "fk22da125e5fb51eb";
 ALTER TABLE "public"."rule_action" DROP CONSTRAINT "rule_action_rule_id_fkey";
 ALTER TABLE "public"."rule_action_pars" DROP CONSTRAINT "rule_action_pars_rule_action_id_fkey";
 ALTER TABLE "public"."rule_condition" DROP CONSTRAINT "rule_condition_condition_group_fkey";
 ALTER TABLE "public"."rule_condition_group" DROP CONSTRAINT "rule_condition_group_rule_id_fkey";
 ALTER TABLE "public"."rule_condition_value" DROP CONSTRAINT "rule_condition_value_condition_id_fkey";
 ALTER TABLE "public"."schemes_ir" DROP CONSTRAINT "fk_scheme_ir_ep";
 ALTER TABLE "public"."structure" DROP CONSTRAINT "fk89d2d735fb51eb";
 ALTER TABLE "public"."structure" DROP CONSTRAINT "fk_structure_folder";
 ALTER TABLE "public"."structure" DROP CONSTRAINT "fk_structure_host";
 ALTER TABLE "public"."structures_ir" DROP CONSTRAINT "fk_structure_ir_ep";
 ALTER TABLE "public"."tag_inode" DROP CONSTRAINT "fk_tag_inode_tagid";
 ALTER TABLE "public"."template" DROP CONSTRAINT "fk_user_template";
 ALTER TABLE "public"."template" DROP CONSTRAINT "fkb13acc7a5fb51eb";
 ALTER TABLE "public"."template" DROP CONSTRAINT "template_identifier_fk";
 ALTER TABLE "public"."template_containers" DROP CONSTRAINT "fk_container_id";
 ALTER TABLE "public"."template_containers" DROP CONSTRAINT "fk_template_id";
 ALTER TABLE "public"."template_version_info" DROP CONSTRAINT "fk_temp_ver_info_lockedby";
 ALTER TABLE "public"."template_version_info" DROP CONSTRAINT "fk_template_version_info_identifier";
 ALTER TABLE "public"."template_version_info" DROP CONSTRAINT "fk_template_version_info_live";
 ALTER TABLE "public"."template_version_info" DROP CONSTRAINT "fk_template_version_info_working";
 ALTER TABLE "public"."user_comments" DROP CONSTRAINT "fkdf1b37e85fb51eb";
 ALTER TABLE "public"."user_filter" DROP CONSTRAINT "fke042126c5fb51eb";
 ALTER TABLE "public"."user_proxy" DROP CONSTRAINT "fk7327d4fa5fb51eb";
 ALTER TABLE "public"."users_cms_roles" DROP CONSTRAINT "fkusers_cms_roles1";
 ALTER TABLE "public"."users_cms_roles" DROP CONSTRAINT "fkusers_cms_roles2";
 ALTER TABLE "public"."workflow_action" DROP CONSTRAINT "workflow_action_next_assign_fkey";
 ALTER TABLE "public"."workflow_action" DROP CONSTRAINT "workflow_action_next_step_id_fkey";
 ALTER TABLE "public"."workflow_action" DROP CONSTRAINT "workflow_action_step_id_fkey";
 ALTER TABLE "public"."workflow_action_class" DROP CONSTRAINT "workflow_action_class_action_id_fkey";
 ALTER TABLE "public"."workflow_action_class_pars" DROP CONSTRAINT "workflow_action_class_pars_workflow_action_class_id_fkey";
 ALTER TABLE "public"."workflow_comment" DROP CONSTRAINT "workflowtask_id_comment_fk";
 ALTER TABLE "public"."workflow_history" DROP CONSTRAINT "workflowtask_id_history_fk";
 ALTER TABLE "public"."workflow_scheme_x_structure" DROP CONSTRAINT "workflow_scheme_x_structure_scheme_id_fkey";
 ALTER TABLE "public"."workflow_scheme_x_structure" DROP CONSTRAINT "workflow_scheme_x_structure_structure_id_fkey";
 ALTER TABLE "public"."workflow_step" DROP CONSTRAINT "fk_escalation_action";
 ALTER TABLE "public"."workflow_step" DROP CONSTRAINT "workflow_step_scheme_id_fkey";
 ALTER TABLE "public"."workflow_task" DROP CONSTRAINT "fk_workflow_assign";
 ALTER TABLE "public"."workflow_task" DROP CONSTRAINT "fk_workflow_step";
 ALTER TABLE "public"."workflow_task" DROP CONSTRAINT "fk_workflow_task_asset";
 ALTER TABLE "public"."workflowtask_files" DROP CONSTRAINT "fk_workflow_id";
 ALTER TABLE "public"."address" DROP CONSTRAINT "address_pkey";
 ALTER TABLE "public"."adminconfig" DROP CONSTRAINT "adminconfig_pkey";
 ALTER TABLE "public"."analytic_summary" DROP CONSTRAINT "analytic_summary_pkey";
 ALTER TABLE "public"."analytic_summary_404" DROP CONSTRAINT "analytic_summary_404_pkey";
 ALTER TABLE "public"."analytic_summary_content" DROP CONSTRAINT "analytic_summary_content_pkey";
 ALTER TABLE "public"."analytic_summary_pages" DROP CONSTRAINT "analytic_summary_pages_pkey";
 ALTER TABLE "public"."analytic_summary_period" DROP CONSTRAINT "analytic_summary_period_pkey";
 ALTER TABLE "public"."analytic_summary_referer" DROP CONSTRAINT "analytic_summary_referer_pkey";
 ALTER TABLE "public"."analytic_summary_visits" DROP CONSTRAINT "analytic_summary_visits_pkey";
 ALTER TABLE "public"."analytic_summary_workstream" DROP CONSTRAINT "analytic_summary_workstream_pkey";
 ALTER TABLE "public"."broken_link" DROP CONSTRAINT "broken_link_pkey";
 ALTER TABLE "public"."calendar_reminder" DROP CONSTRAINT "calendar_reminder_pkey";
 ALTER TABLE "public"."campaign" DROP CONSTRAINT "campaign_pkey";
 ALTER TABLE "public"."category" DROP CONSTRAINT "category_pkey";
 ALTER TABLE "public"."chain" DROP CONSTRAINT "chain_pkey";
 ALTER TABLE "public"."chain_link_code" DROP CONSTRAINT "chain_link_code_pkey";
 ALTER TABLE "public"."chain_state" DROP CONSTRAINT "chain_state_pkey";
 ALTER TABLE "public"."chain_state_parameter" DROP CONSTRAINT "chain_state_parameter_pkey";
 ALTER TABLE "public"."challenge_question" DROP CONSTRAINT "challenge_question_pkey";
 ALTER TABLE "public"."click" DROP CONSTRAINT "click_pkey";
 ALTER TABLE "public"."clickstream" DROP CONSTRAINT "clickstream_pkey";
 ALTER TABLE "public"."clickstream_404" DROP CONSTRAINT "clickstream_404_pkey";
 ALTER TABLE "public"."clickstream_request" DROP CONSTRAINT "clickstream_request_pkey";
 ALTER TABLE "public"."cluster_server" DROP CONSTRAINT "cluster_server_pkey";
 ALTER TABLE "public"."cluster_server_action" DROP CONSTRAINT "cluster_server_action_pkey";
 ALTER TABLE "public"."cluster_server_uptime" DROP CONSTRAINT "cluster_server_uptime_pkey";
 ALTER TABLE "public"."cms_layout" DROP CONSTRAINT "cms_layout_pkey";
 ALTER TABLE "public"."cms_layouts_portlets" DROP CONSTRAINT "cms_layouts_portlets_pkey";
 ALTER TABLE "public"."cms_role" DROP CONSTRAINT "cms_role_pkey";
 ALTER TABLE "public"."cms_roles_ir" DROP CONSTRAINT "cms_roles_ir_pkey";
 ALTER TABLE "public"."communication" DROP CONSTRAINT "communication_pkey";
 ALTER TABLE "public"."company" DROP CONSTRAINT "company_pkey";
 ALTER TABLE "public"."container_structures" DROP CONSTRAINT "container_structures_pkey";
 ALTER TABLE "public"."container_version_info" DROP CONSTRAINT "container_version_info_pkey";
 ALTER TABLE "public"."content_rating" DROP CONSTRAINT "content_rating_pkey";
 ALTER TABLE "public"."contentlet" DROP CONSTRAINT "contentlet_pkey";
 ALTER TABLE "public"."contentlet_version_info" DROP CONSTRAINT "contentlet_version_info_pkey";
 ALTER TABLE "public"."counter" DROP CONSTRAINT "counter_pkey";
 ALTER TABLE "public"."dashboard_user_preferences" DROP CONSTRAINT "dashboard_user_preferences_pkey";
 ALTER TABLE "public"."db_version" DROP CONSTRAINT "db_version_pkey";
 ALTER TABLE "public"."dist_journal" DROP CONSTRAINT "dist_journal_pkey";
 ALTER TABLE "public"."dist_process" DROP CONSTRAINT "dist_process_pkey";
 ALTER TABLE "public"."dist_reindex_journal" DROP CONSTRAINT "dist_reindex_journal_pkey";
 ALTER TABLE "public"."dot_cluster" DROP CONSTRAINT "dot_cluster_pkey";
 ALTER TABLE "public"."dot_containers" DROP CONSTRAINT "dot_containers_pkey";
 ALTER TABLE "public"."dot_rule" DROP CONSTRAINT "dot_rule_pkey";
 ALTER TABLE "public"."field" DROP CONSTRAINT "field_pkey";
 ALTER TABLE "public"."field_variable" DROP CONSTRAINT "field_variable_pkey";
 ALTER TABLE "public"."fileassets_ir" DROP CONSTRAINT "fileassets_ir_pkey";
 ALTER TABLE "public"."fixes_audit" DROP CONSTRAINT "fixes_audit_pkey";
 ALTER TABLE "public"."folder" DROP CONSTRAINT "folder_pkey";
 ALTER TABLE "public"."folders_ir" DROP CONSTRAINT "folders_ir_pkey";
 ALTER TABLE "public"."host_variable" DROP CONSTRAINT "host_variable_pkey";
 ALTER TABLE "public"."htmlpages_ir" DROP CONSTRAINT "htmlpages_ir_pkey";
 ALTER TABLE "public"."identifier" DROP CONSTRAINT "identifier_pkey";
 ALTER TABLE "public"."image" DROP CONSTRAINT "image_pkey";
 ALTER TABLE "public"."import_audit" DROP CONSTRAINT "import_audit_pkey";
 ALTER TABLE "public"."indicies" DROP CONSTRAINT "indicies_pkey";
 ALTER TABLE "public"."inode" DROP CONSTRAINT "inode_pkey";
 ALTER TABLE "public"."language" DROP CONSTRAINT "language_pkey";
 ALTER TABLE "public"."layouts_cms_roles" DROP CONSTRAINT "layouts_cms_roles_pkey";
 ALTER TABLE "public"."link_version_info" DROP CONSTRAINT "link_version_info_pkey";
 ALTER TABLE "public"."links" DROP CONSTRAINT "links_pkey";
 ALTER TABLE "public"."log_mapper" DROP CONSTRAINT "log_mapper_pkey";
 ALTER TABLE "public"."mailing_list" DROP CONSTRAINT "mailing_list_pkey";
 ALTER TABLE "public"."multi_tree" DROP CONSTRAINT "multi_tree_pkey";
 ALTER TABLE "public"."notification" DROP CONSTRAINT "pk_notification";
 ALTER TABLE "public"."passwordtracker" DROP CONSTRAINT "passwordtracker_pkey";
 ALTER TABLE "public"."permission" DROP CONSTRAINT "permission_pkey";
 ALTER TABLE "public"."permission_reference" DROP CONSTRAINT "permission_reference_pkey";
 ALTER TABLE "public"."plugin" DROP CONSTRAINT "plugin_pkey";
 ALTER TABLE "public"."plugin_property" DROP CONSTRAINT "plugin_property_pkey";
 ALTER TABLE "public"."pollschoice" DROP CONSTRAINT "pollschoice_pkey";
 ALTER TABLE "public"."pollsdisplay" DROP CONSTRAINT "pollsdisplay_pkey";
 ALTER TABLE "public"."pollsquestion" DROP CONSTRAINT "pollsquestion_pkey";
 ALTER TABLE "public"."pollsvote" DROP CONSTRAINT "pollsvote_pkey";
 ALTER TABLE "public"."portlet" DROP CONSTRAINT "portlet_pkey";
 ALTER TABLE "public"."portletpreferences" DROP CONSTRAINT "portletpreferences_pkey";
 ALTER TABLE "public"."publishing_bundle" DROP CONSTRAINT "publishing_bundle_pkey";
 ALTER TABLE "public"."publishing_bundle_environment" DROP CONSTRAINT "publishing_bundle_environment_pkey";
 ALTER TABLE "public"."publishing_end_point" DROP CONSTRAINT "publishing_end_point_pkey";
 ALTER TABLE "public"."publishing_environment" DROP CONSTRAINT "publishing_environment_pkey";
 ALTER TABLE "public"."publishing_queue" DROP CONSTRAINT "publishing_queue_pkey";
 ALTER TABLE "public"."publishing_queue_audit" DROP CONSTRAINT "publishing_queue_audit_pkey";
 ALTER TABLE "public"."qrtz_blob_triggers" DROP CONSTRAINT "qrtz_blob_triggers_pkey";
 ALTER TABLE "public"."qrtz_calendars" DROP CONSTRAINT "qrtz_calendars_pkey";
 ALTER TABLE "public"."qrtz_cron_triggers" DROP CONSTRAINT "qrtz_cron_triggers_pkey";
 ALTER TABLE "public"."qrtz_excl_blob_triggers" DROP CONSTRAINT "qrtz_excl_blob_triggers_pkey";
 ALTER TABLE "public"."qrtz_excl_calendars" DROP CONSTRAINT "qrtz_excl_calendars_pkey";
 ALTER TABLE "public"."qrtz_excl_cron_triggers" DROP CONSTRAINT "qrtz_excl_cron_triggers_pkey";
 ALTER TABLE "public"."qrtz_excl_fired_triggers" DROP CONSTRAINT "qrtz_excl_fired_triggers_pkey";
 ALTER TABLE "public"."qrtz_excl_job_details" DROP CONSTRAINT "qrtz_excl_job_details_pkey";
 ALTER TABLE "public"."qrtz_excl_job_listeners" DROP CONSTRAINT "qrtz_excl_job_listeners_pkey";
 ALTER TABLE "public"."qrtz_excl_locks" DROP CONSTRAINT "qrtz_excl_locks_pkey";
 ALTER TABLE "public"."qrtz_excl_paused_trigger_grps" DROP CONSTRAINT "qrtz_excl_paused_trigger_grps_pkey";
 ALTER TABLE "public"."qrtz_excl_scheduler_state" DROP CONSTRAINT "qrtz_excl_scheduler_state_pkey";
 ALTER TABLE "public"."qrtz_excl_simple_triggers" DROP CONSTRAINT "qrtz_excl_simple_triggers_pkey";
 ALTER TABLE "public"."qrtz_excl_trigger_listeners" DROP CONSTRAINT "qrtz_excl_trigger_listeners_pkey";
 ALTER TABLE "public"."qrtz_excl_triggers" DROP CONSTRAINT "qrtz_excl_triggers_pkey";
 ALTER TABLE "public"."qrtz_fired_triggers" DROP CONSTRAINT "qrtz_fired_triggers_pkey";
 ALTER TABLE "public"."qrtz_job_details" DROP CONSTRAINT "qrtz_job_details_pkey";
 ALTER TABLE "public"."qrtz_job_listeners" DROP CONSTRAINT "qrtz_job_listeners_pkey";
 ALTER TABLE "public"."qrtz_locks" DROP CONSTRAINT "qrtz_locks_pkey";
 ALTER TABLE "public"."qrtz_paused_trigger_grps" DROP CONSTRAINT "qrtz_paused_trigger_grps_pkey";
 ALTER TABLE "public"."qrtz_scheduler_state" DROP CONSTRAINT "qrtz_scheduler_state_pkey";
 ALTER TABLE "public"."qrtz_simple_triggers" DROP CONSTRAINT "qrtz_simple_triggers_pkey";
 ALTER TABLE "public"."qrtz_trigger_listeners" DROP CONSTRAINT "qrtz_trigger_listeners_pkey";
 ALTER TABLE "public"."qrtz_triggers" DROP CONSTRAINT "qrtz_triggers_pkey";
 ALTER TABLE "public"."quartz_log" DROP CONSTRAINT "quartz_log_pkey";
 ALTER TABLE "public"."recipient" DROP CONSTRAINT "recipient_pkey";
 ALTER TABLE "public"."relationship" DROP CONSTRAINT "relationship_pkey";
 ALTER TABLE "public"."release_" DROP CONSTRAINT "release__pkey";
 ALTER TABLE "public"."report_asset" DROP CONSTRAINT "report_asset_pkey";
 ALTER TABLE "public"."report_parameter" DROP CONSTRAINT "report_parameter_pkey";
 ALTER TABLE "public"."rule_action" DROP CONSTRAINT "rule_action_pkey";
 ALTER TABLE "public"."rule_action_pars" DROP CONSTRAINT "rule_action_pars_pkey";
 ALTER TABLE "public"."rule_condition" DROP CONSTRAINT "rule_condition_pkey";
 ALTER TABLE "public"."rule_condition_group" DROP CONSTRAINT "rule_condition_group_pkey";
 ALTER TABLE "public"."rule_condition_value" DROP CONSTRAINT "rule_condition_value_pkey";
 ALTER TABLE "public"."schemes_ir" DROP CONSTRAINT "schemes_ir_pkey";
 ALTER TABLE "public"."sitelic" DROP CONSTRAINT "sitelic_pkey";
 ALTER TABLE "public"."sitesearch_audit" DROP CONSTRAINT "sitesearch_audit_pkey";
 ALTER TABLE "public"."structure" DROP CONSTRAINT "structure_pkey";
 ALTER TABLE "public"."structures_ir" DROP CONSTRAINT "structures_ir_pkey";
 ALTER TABLE "public"."system_event" DROP CONSTRAINT "pk_system_event";
 ALTER TABLE "public"."tag" DROP CONSTRAINT "tag_pkey";
 ALTER TABLE "public"."tag_inode" DROP CONSTRAINT "tag_inode_pkey";
 ALTER TABLE "public"."template" DROP CONSTRAINT "template_pkey";
 ALTER TABLE "public"."template_containers" DROP CONSTRAINT "template_containers_pkey";
 ALTER TABLE "public"."template_version_info" DROP CONSTRAINT "template_version_info_pkey";
 ALTER TABLE "public"."trackback" DROP CONSTRAINT "trackback_pkey";
 ALTER TABLE "public"."tree" DROP CONSTRAINT "tree_pkey";
 ALTER TABLE "public"."user_" DROP CONSTRAINT "user__pkey";
 ALTER TABLE "public"."user_comments" DROP CONSTRAINT "user_comments_pkey";
 ALTER TABLE "public"."user_filter" DROP CONSTRAINT "user_filter_pkey";
 ALTER TABLE "public"."user_preferences" DROP CONSTRAINT "user_preferences_pkey";
 ALTER TABLE "public"."user_proxy" DROP CONSTRAINT "user_proxy_pkey";
 ALTER TABLE "public"."users_cms_roles" DROP CONSTRAINT "users_cms_roles_pkey";
 ALTER TABLE "public"."users_to_delete" DROP CONSTRAINT "users_to_delete_pkey";
 ALTER TABLE "public"."usertracker" DROP CONSTRAINT "usertracker_pkey";
 ALTER TABLE "public"."usertrackerpath" DROP CONSTRAINT "usertrackerpath_pkey";
 ALTER TABLE "public"."web_form" DROP CONSTRAINT "web_form_pkey";
 ALTER TABLE "public"."workflow_action" DROP CONSTRAINT "workflow_action_pkey";
 ALTER TABLE "public"."workflow_action_class" DROP CONSTRAINT "workflow_action_class_pkey";
 ALTER TABLE "public"."workflow_action_class_pars" DROP CONSTRAINT "workflow_action_class_pars_pkey";
 ALTER TABLE "public"."workflow_comment" DROP CONSTRAINT "workflow_comment_pkey";
 ALTER TABLE "public"."workflow_history" DROP CONSTRAINT "workflow_history_pkey";
 ALTER TABLE "public"."workflow_scheme" DROP CONSTRAINT "workflow_scheme_pkey";
 ALTER TABLE "public"."workflow_scheme_x_structure" DROP CONSTRAINT "workflow_scheme_x_structure_pkey";
 ALTER TABLE "public"."workflow_step" DROP CONSTRAINT "workflow_step_pkey";
 ALTER TABLE "public"."workflow_task" DROP CONSTRAINT "workflow_task_pkey";
 ALTER TABLE "public"."workflowtask_files" DROP CONSTRAINT "workflowtask_files_pkey";
 ALTER TABLE "public"."analytic_summary" DROP CONSTRAINT "analytic_summary_summary_period_id_host_id_key";
 ALTER TABLE "public"."analytic_summary_period" DROP CONSTRAINT "analytic_summary_period_full_date_key";
 ALTER TABLE "public"."chain" DROP CONSTRAINT "chain_key_name_key";
 ALTER TABLE "public"."chain_link_code" DROP CONSTRAINT "chain_link_code_class_name_key";
 ALTER TABLE "public"."cms_layout" DROP CONSTRAINT "cms_layout_name_parent";
 ALTER TABLE "public"."cms_layouts_portlets" DROP CONSTRAINT "cms_layouts_portlets_parent1";
 ALTER TABLE "public"."cms_role" DROP CONSTRAINT "cms_role_name_db_fqn";
 ALTER TABLE "public"."cms_role" DROP CONSTRAINT "cms_role_name_role_key";
 ALTER TABLE "public"."dist_journal" DROP CONSTRAINT "dist_journal_object_to_index_key";
 ALTER TABLE "public"."identifier" DROP CONSTRAINT "identifier_parent_path_asset_name_host_inode_key";
 ALTER TABLE "public"."indicies" DROP CONSTRAINT "indicies_index_type_key";
 ALTER TABLE "public"."layouts_cms_roles" DROP CONSTRAINT "layouts_cms_roles_parent1";
 ALTER TABLE "public"."permission" DROP CONSTRAINT "permission_permission_type_inode_id_roleid_key";
 ALTER TABLE "public"."permission_reference" DROP CONSTRAINT "permission_reference_asset_id_key";
 ALTER TABLE "public"."portlet" DROP CONSTRAINT "portlet_role_key";
 ALTER TABLE "public"."publishing_end_point" DROP CONSTRAINT "publishing_end_point_server_name_key";
 ALTER TABLE "public"."publishing_environment" DROP CONSTRAINT "publishing_environment_name_key";
 ALTER TABLE "public"."report_parameter" DROP CONSTRAINT "report_parameter_report_inode_parameter_name_key";
 ALTER TABLE "public"."structure" DROP CONSTRAINT "unique_struct_vel_var_name";
 ALTER TABLE "public"."tag" DROP CONSTRAINT "tag_tagname_host";
 ALTER TABLE "public"."user_proxy" DROP CONSTRAINT "user_proxy_user_id_key";
 ALTER TABLE "public"."users_cms_roles" DROP CONSTRAINT "users_cms_roles_parent1";
 ALTER TABLE "public"."workflow_scheme" DROP CONSTRAINT "unique_workflow_scheme_name";
