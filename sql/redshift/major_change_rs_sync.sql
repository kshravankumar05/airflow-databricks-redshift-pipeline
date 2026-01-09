BEGIN;
 
-- Step 1: Truncate work table
DELETE FROM change_management.servicenow_change_request_temp;
 
-- Step 2: Load data from S3
-- Note: The Databricks notebook automatically adds LOAD_NAME subdirectory to S3_PATH_LOCATION
-- Final path structure: S3_PATH_LOCATION/LOAD_NAME/change_management_tbl.servicenow_change_request/
-- Note: MAXERROR is not supported for PARQUET format in Redshift COPY command
COPY change_management.servicenow_change_request_temp
FROM ':S3_PATH_LOCATION/change_management_tbl.servicenow_change_request/'
IAM_ROLE ':IAM_ROLE_ARN'
FORMAT AS PARQUET;

--STEP 3:Insert into  main table 
INSERT INTO change_management.servicenow_change_request (
    additional_assignee_list, app_ci, application_location, application_service_name_key, assigned_to, assignment_group, change_advisory_board_approval_date, change_advisory_board_authorizer, change_advisory_board_delegate, change_advisory_board_recommendation, closing_comment_and_work_note, configuration_item_type, conflict_last_run_dtml, conflict_status, current_request_state, emergency_request_justification, end_user_impact, impacted_service, incident_number, is_change_advisory_board_decision_required, is_conflict_warning_accepted, is_knowledge_article_found, is_pre_release_test_required, is_request_active, is_request_for_production_environment, is_request_post_implementation_review_required, is_request_unauthorized, is_sla_met, is_there_a_failover_plan, knowledge_of_other_impacted_app_ci, outage_summary, parent_task, planned_outage_type, plan_plus_project_name, pre_release_test_plan, pre_release_test_result, problem_number, record_created_by, record_create_dtml, request_approval_dtml, request_approval_history, request_approval_status, request_backout_plan, request_category, request_closed_by, request_closed_dtml, request_comment, request_conflict_status, request_description, request_duration, requested_by, request_emergency_deployment_justification, request_end_dtml, request_execution_method, request_fallback_duration, request_impact, request_impact_category, request_impact_description, request_impacted_location, request_implementation_group, request_implementation_plan, request_implementation_result, request_implementation_timeline, request_justification, request_number, request_opened_by, request_opened_dtml, request_post_implementation_review_date, request_post_implementation_review_owner, request_post_implementation_review_reason, request_post_implementation_review_result, request_priority, request_resolution_category, request_resolution_notes, request_review_comment, request_risk_category, request_risk_impact, request_risk_value, request_short_description, request_source, request_start_dtml, request_type, request_validation_plan, request_work_end_dtml, request_work_start_dtml, standard_change_template_name, standard_change_template_version, system_record_id, system_record_tag_list, task_work_notes, third_party_company, ucloud_ingestion_date, watch_list, feed_id, feed_version, ingestion_id, ingestion_timestamp
	)
SELECT distinct 
	additional_assignee_list, app_ci, application_location, application_service_name_key, assigned_to, assignment_group, change_advisory_board_approval_date, change_advisory_board_authorizer, change_advisory_board_delegate, change_advisory_board_recommendation, closing_comment_and_work_note, configuration_item_type, conflict_last_run_dtml, conflict_status, current_request_state, emergency_request_justification, end_user_impact, impacted_service, incident_number, is_change_advisory_board_decision_required, is_conflict_warning_accepted, is_knowledge_article_found, is_pre_release_test_required, is_request_active, is_request_for_production_environment, is_request_post_implementation_review_required, is_request_unauthorized, is_sla_met, is_there_a_failover_plan, knowledge_of_other_impacted_app_ci, outage_summary, parent_task, planned_outage_type, plan_plus_project_name, pre_release_test_plan, pre_release_test_result, problem_number, record_created_by, record_create_dtml, request_approval_dtml, request_approval_history, request_approval_status, request_backout_plan, request_category, request_closed_by, request_closed_dtml, request_comment, request_conflict_status, request_description, request_duration, requested_by, request_emergency_deployment_justification, request_end_dtml, request_execution_method, request_fallback_duration, request_impact, request_impact_category, request_impact_description, request_impacted_location, request_implementation_group, request_implementation_plan, request_implementation_result, request_implementation_timeline, request_justification, request_number, request_opened_by, request_opened_dtml, request_post_implementation_review_date, request_post_implementation_review_owner, request_post_implementation_review_reason, request_post_implementation_review_result, request_priority, request_resolution_category, request_resolution_notes, request_review_comment, request_risk_category, request_risk_impact, request_risk_value, request_short_description, request_source, request_start_dtml, request_type, request_validation_plan, request_work_end_dtml, request_work_start_dtml, standard_change_template_name, standard_change_template_version, system_record_id, system_record_tag_list, task_work_notes, third_party_company, ucloud_ingestion_date, watch_list, feed_id, feed_version, ingestion_id, ingestion_timestamp
from change_management.servicenow_change_request_temp
WHERE _change_type = 'insert';


-- Step 4: Update into main table
-- Column order matches Databricks table
UPDATE change_management.servicenow_change_request
SET
    request_number = temp.request_number,
    request_start_dtml = temp.request_start_dtml,
    request_end_dtml = temp.request_end_dtml,
    request_short_description = temp.request_short_description,
    request_description = temp.request_description,
    current_request_state = temp.current_request_state,
    request_opened_dtml = temp.request_opened_dtml,
    request_priority = temp.request_priority,
    app_ci = temp.app_ci,
    application_service_name_key = temp.application_service_name_key,
    assignment_group = temp.assignment_group,
    assigned_to = temp.assigned_to,
    request_work_start_dtml = temp.request_work_start_dtml,
    request_work_end_dtml = temp.request_work_end_dtml,
    request_approval_status = temp.request_approval_status,
    request_approval_history = temp.request_approval_history,
    request_approval_dtml = temp.request_approval_dtml,
    change_advisory_board_approval_date = temp.change_advisory_board_approval_date,
    is_change_advisory_board_decision_required = temp.is_change_advisory_board_decision_required,
    change_advisory_board_recommendation = temp.change_advisory_board_recommendation,
    change_advisory_board_authorizer = temp.change_advisory_board_authorizer,
    change_advisory_board_delegate = temp.change_advisory_board_delegate,
    request_closed_dtml = temp.request_closed_dtml,
    request_closed_by = temp.request_closed_by,
    parent_task = temp.parent_task,
    incident_number = temp.incident_number,
    problem_number = temp.problem_number,
    request_source = temp.request_source,
    request_category = temp.request_category,
    is_request_active = temp.is_request_active,
    additional_assignee_list = temp.additional_assignee_list,
    request_comment = temp.request_comment,
    request_conflict_status = temp.request_conflict_status,
    request_execution_method = temp.request_execution_method,
    request_impact_category = temp.request_impact_category,
    request_type = temp.request_type,
    closing_comment_and_work_note = temp.closing_comment_and_work_note,
    configuration_item_type = temp.configuration_item_type,
    is_conflict_warning_accepted = temp.is_conflict_warning_accepted,
    conflict_last_run_dtml = temp.conflict_last_run_dtml,
    conflict_status = temp.conflict_status,
    record_create_dtml = temp.record_create_dtml,
    record_created_by = temp.record_created_by,
    request_implementation_timeline = temp.request_implementation_timeline,
    request_emergency_deployment_justification = temp.request_emergency_deployment_justification,
    end_user_impact = temp.end_user_impact,
    request_fallback_duration = temp.request_fallback_duration,
    request_backout_plan = temp.request_backout_plan,
    request_impact = temp.request_impact,
    request_impact_description = temp.request_impact_description,
    impacted_service = temp.impacted_service,
    request_impacted_location = temp.request_impacted_location,
    request_implementation_group = temp.request_implementation_group,
    request_implementation_plan = temp.request_implementation_plan,
    request_implementation_result = temp.request_implementation_result,
    is_knowledge_article_found = temp.is_knowledge_article_found,
    knowledge_of_other_impacted_app_ci = temp.knowledge_of_other_impacted_app_ci,
    request_duration = temp.request_duration,
    application_location = temp.application_location,
    is_sla_met = temp.is_sla_met,
    request_opened_by = temp.request_opened_by,
    outage_summary = temp.outage_summary,
    is_request_post_implementation_review_required = temp.is_request_post_implementation_review_required,
    request_post_implementation_review_owner = temp.request_post_implementation_review_owner,
    request_post_implementation_review_date = temp.request_post_implementation_review_date,
    request_post_implementation_review_result = temp.request_post_implementation_review_result,
    request_post_implementation_review_reason = temp.request_post_implementation_review_reason,
    planned_outage_type = temp.planned_outage_type,
    is_request_for_production_environment = temp.is_request_for_production_environment,
    plan_plus_project_name = temp.plan_plus_project_name,
    request_justification = temp.request_justification,
    emergency_request_justification = temp.emergency_request_justification,
    is_there_a_failover_plan = temp.is_there_a_failover_plan,
    requested_by = temp.requested_by,
    request_resolution_notes = temp.request_resolution_notes,
    request_review_comment = temp.request_review_comment,
    request_risk_category = temp.request_risk_category,
    request_risk_impact = temp.request_risk_impact,
    request_risk_value = temp.request_risk_value,
    standard_change_template_version = temp.standard_change_template_version,
    standard_change_template_name = temp.standard_change_template_name,
    system_record_id = temp.system_record_id,
    system_record_tag_list = temp.system_record_tag_list,
    pre_release_test_plan = temp.pre_release_test_plan,
    is_pre_release_test_required = temp.is_pre_release_test_required,
    pre_release_test_result = temp.pre_release_test_result,
    is_request_unauthorized = temp.is_request_unauthorized,
    request_validation_plan = temp.request_validation_plan,
    third_party_company = temp.third_party_company,
    watch_list = temp.watch_list,
    task_work_notes = temp.task_work_notes,
    request_resolution_category = temp.request_resolution_category,
    ucloud_ingestion_date = temp.ucloud_ingestion_date,
    feed_id = temp.feed_id,
    feed_version = temp.feed_version,
    ingestion_id = temp.ingestion_id,
    ingestion_timestamp = temp.ingestion_timestamp
FROM change_management.servicenow_change_request_temp temp
WHERE temp._change_type = 'update_postimage'
  AND temp.system_record_id = change_management.servicenow_change_request.system_record_id;
 
END;
 
COMMIT;

