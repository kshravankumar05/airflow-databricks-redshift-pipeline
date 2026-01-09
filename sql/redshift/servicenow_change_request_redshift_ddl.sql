-- ============================================================================
-- Redshift DDL for servicenow_change_request
-- Portfolio/Demo Version - Generic schema names
-- ============================================================================

-- Drop existing tables
-- ============================================================================
DROP TABLE IF EXISTS change_management.servicenow_change_request;
DROP TABLE IF EXISTS change_management.servicenow_change_request_temp;

-- ============================================================================
-- Main Table: servicenow_change_request
-- Column order and data types match Databricks table exactly
-- ============================================================================
CREATE TABLE change_management.servicenow_change_request
(
	request_number VARCHAR(50) NOT NULL   ENCODE lzo
	,request_start_dtml TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,request_end_dtml TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,request_short_description VARCHAR(5000)   ENCODE lzo
	,request_description VARCHAR(50000)   ENCODE lzo
	,current_request_state VARCHAR(5000)   ENCODE lzo
	,request_opened_dtml TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,request_priority VARCHAR(5000)   ENCODE lzo
	,app_ci VARCHAR(5000)   ENCODE lzo
	,application_service_name_key VARCHAR(5000)   ENCODE lzo
	,assignment_group VARCHAR(5000)   ENCODE lzo
	,assigned_to VARCHAR(5000)   ENCODE lzo
	,request_work_start_dtml TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,request_work_end_dtml TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,request_approval_status VARCHAR(5000)   ENCODE lzo
	,request_approval_history VARCHAR(5000)   ENCODE lzo
	,request_approval_dtml TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,change_advisory_board_approval_date DATE   ENCODE az64
	,is_change_advisory_board_decision_required BOOLEAN   ENCODE RAW
	,change_advisory_board_recommendation VARCHAR(5000)   ENCODE lzo
	,change_advisory_board_authorizer VARCHAR(5000)   ENCODE lzo
	,change_advisory_board_delegate VARCHAR(5000)   ENCODE lzo
	,request_closed_dtml TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,request_closed_by VARCHAR(5000)   ENCODE lzo
	,parent_task VARCHAR(5000)   ENCODE lzo
	,incident_number VARCHAR(5000)   ENCODE lzo
	,problem_number VARCHAR(5000)   ENCODE lzo
	,request_source VARCHAR(5000)   ENCODE lzo
	,request_category VARCHAR(5000)   ENCODE lzo
	,is_request_active BOOLEAN   ENCODE RAW
	,additional_assignee_list VARCHAR(5000)   ENCODE lzo
	,request_comment VARCHAR(5000)   ENCODE lzo
	,request_conflict_status VARCHAR(5000)   ENCODE lzo
	,request_execution_method VARCHAR(5000)   ENCODE lzo
	,request_impact_category VARCHAR(5000)   ENCODE lzo
	,request_type VARCHAR(5000)   ENCODE lzo
	,closing_comment_and_work_note VARCHAR(50000)   ENCODE lzo
	,configuration_item_type VARCHAR(5000)   ENCODE lzo
	,is_conflict_warning_accepted BOOLEAN   ENCODE RAW
	,conflict_last_run_dtml TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,conflict_status VARCHAR(5000)   ENCODE lzo
	,record_create_dtml TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,record_created_by VARCHAR(5000)   ENCODE lzo
	,request_implementation_timeline VARCHAR(5000)   ENCODE lzo
	,request_emergency_deployment_justification VARCHAR(5000)   ENCODE lzo
	,end_user_impact VARCHAR(5000)   ENCODE lzo
	,request_fallback_duration INTEGER   ENCODE az64
	,request_backout_plan VARCHAR(5000)   ENCODE lzo
	,request_impact VARCHAR(5000)   ENCODE lzo
	,request_impact_description VARCHAR(5000)   ENCODE lzo
	,impacted_service VARCHAR(5000)   ENCODE lzo
	,request_impacted_location VARCHAR(5000)   ENCODE lzo
	,request_implementation_group VARCHAR(5000)   ENCODE lzo
	,request_implementation_plan VARCHAR(5000)   ENCODE lzo
	,request_implementation_result VARCHAR(5000)   ENCODE lzo
	,is_knowledge_article_found BOOLEAN   ENCODE RAW
	,knowledge_of_other_impacted_app_ci VARCHAR(5000)   ENCODE lzo
	,request_duration INTEGER   ENCODE az64
	,application_location VARCHAR(5000)   ENCODE lzo
	,is_sla_met BOOLEAN   ENCODE RAW
	,request_opened_by VARCHAR(5000)   ENCODE lzo
	,outage_summary VARCHAR(5000)   ENCODE lzo
	,is_request_post_implementation_review_required BOOLEAN   ENCODE RAW
	,request_post_implementation_review_owner VARCHAR(5000)   ENCODE lzo
	,request_post_implementation_review_date DATE   ENCODE az64
	,request_post_implementation_review_result VARCHAR(5000)   ENCODE lzo
	,request_post_implementation_review_reason VARCHAR(5000)   ENCODE lzo
	,planned_outage_type VARCHAR(5000)   ENCODE lzo
	,is_request_for_production_environment BOOLEAN   ENCODE RAW
	,plan_plus_project_name VARCHAR(5000)   ENCODE lzo
	,request_justification VARCHAR(5000)   ENCODE lzo
	,emergency_request_justification VARCHAR(5000)   ENCODE lzo
	,is_there_a_failover_plan BOOLEAN   ENCODE RAW
	,requested_by VARCHAR(5000)   ENCODE lzo
	,request_resolution_notes VARCHAR(5000)   ENCODE lzo
	,request_review_comment VARCHAR(5000)   ENCODE lzo
	,request_risk_category VARCHAR(5000)   ENCODE lzo
	,request_risk_impact VARCHAR(5000)   ENCODE lzo
	,request_risk_value INTEGER   ENCODE az64
	,standard_change_template_version VARCHAR(5000)   ENCODE lzo
	,standard_change_template_name VARCHAR(5000)   ENCODE lzo
	,system_record_id VARCHAR(5000)   ENCODE lzo
	,system_record_tag_list VARCHAR(5000)   ENCODE lzo
	,pre_release_test_plan VARCHAR(5000)   ENCODE lzo
	,is_pre_release_test_required BOOLEAN   ENCODE RAW
	,pre_release_test_result VARCHAR(5000)   ENCODE lzo
	,is_request_unauthorized BOOLEAN   ENCODE RAW
	,request_validation_plan VARCHAR(5000)   ENCODE lzo
	,third_party_company VARCHAR(5000)   ENCODE lzo
	,watch_list VARCHAR(5000)   ENCODE lzo
	,task_work_notes VARCHAR(5000)   ENCODE lzo
	,request_resolution_category VARCHAR(5000)   ENCODE lzo
	,ucloud_ingestion_date DATE   ENCODE az64
	,feed_id INTEGER   ENCODE az64
	,feed_version INTEGER   ENCODE az64
	,ingestion_id INTEGER   ENCODE az64
	,ingestion_timestamp TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
)
DISTSTYLE KEY
DISTKEY(system_record_id)
SORTKEY (record_create_dtml, system_record_id);

-- ============================================================================
-- Temp Table: servicenow_change_request_temp
-- Includes CDC columns (_change_type, _commit_version, _commit_timestamp)
-- Column order matches main table + CDC columns at the end
-- ============================================================================
CREATE TABLE change_management.servicenow_change_request_temp
(
	request_number VARCHAR(50) NOT NULL   ENCODE lzo
	,request_start_dtml TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,request_end_dtml TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,request_short_description VARCHAR(5000)   ENCODE lzo
	,request_description VARCHAR(50000)   ENCODE lzo
	,current_request_state VARCHAR(5000)   ENCODE lzo
	,request_opened_dtml TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,request_priority VARCHAR(5000)   ENCODE lzo
	,app_ci VARCHAR(5000)   ENCODE lzo
	,application_service_name_key VARCHAR(5000)   ENCODE lzo
	,assignment_group VARCHAR(5000)   ENCODE lzo
	,assigned_to VARCHAR(5000)   ENCODE lzo
	,request_work_start_dtml TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,request_work_end_dtml TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,request_approval_status VARCHAR(5000)   ENCODE lzo
	,request_approval_history VARCHAR(5000)   ENCODE lzo
	,request_approval_dtml TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,change_advisory_board_approval_date DATE   ENCODE az64
	,is_change_advisory_board_decision_required BOOLEAN   ENCODE RAW
	,change_advisory_board_recommendation VARCHAR(5000)   ENCODE lzo
	,change_advisory_board_authorizer VARCHAR(5000)   ENCODE lzo
	,change_advisory_board_delegate VARCHAR(5000)   ENCODE lzo
	,request_closed_dtml TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,request_closed_by VARCHAR(5000)   ENCODE lzo
	,parent_task VARCHAR(5000)   ENCODE lzo
	,incident_number VARCHAR(5000)   ENCODE lzo
	,problem_number VARCHAR(5000)   ENCODE lzo
	,request_source VARCHAR(5000)   ENCODE lzo
	,request_category VARCHAR(5000)   ENCODE lzo
	,is_request_active BOOLEAN   ENCODE RAW
	,additional_assignee_list VARCHAR(5000)   ENCODE lzo
	,request_comment VARCHAR(5000)   ENCODE lzo
	,request_conflict_status VARCHAR(5000)   ENCODE lzo
	,request_execution_method VARCHAR(5000)   ENCODE lzo
	,request_impact_category VARCHAR(5000)   ENCODE lzo
	,request_type VARCHAR(5000)   ENCODE lzo
	,closing_comment_and_work_note VARCHAR(50000)   ENCODE lzo
	,configuration_item_type VARCHAR(5000)   ENCODE lzo
	,is_conflict_warning_accepted BOOLEAN   ENCODE RAW
	,conflict_last_run_dtml TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,conflict_status VARCHAR(5000)   ENCODE lzo
	,record_create_dtml TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,record_created_by VARCHAR(5000)   ENCODE lzo
	,request_implementation_timeline VARCHAR(5000)   ENCODE lzo
	,request_emergency_deployment_justification VARCHAR(5000)   ENCODE lzo
	,end_user_impact VARCHAR(5000)   ENCODE lzo
	,request_fallback_duration INTEGER   ENCODE az64
	,request_backout_plan VARCHAR(5000)   ENCODE lzo
	,request_impact VARCHAR(5000)   ENCODE lzo
	,request_impact_description VARCHAR(5000)   ENCODE lzo
	,impacted_service VARCHAR(5000)   ENCODE lzo
	,request_impacted_location VARCHAR(5000)   ENCODE lzo
	,request_implementation_group VARCHAR(5000)   ENCODE lzo
	,request_implementation_plan VARCHAR(5000)   ENCODE lzo
	,request_implementation_result VARCHAR(5000)   ENCODE lzo
	,is_knowledge_article_found BOOLEAN   ENCODE RAW
	,knowledge_of_other_impacted_app_ci VARCHAR(5000)   ENCODE lzo
	,request_duration INTEGER   ENCODE az64
	,application_location VARCHAR(5000)   ENCODE lzo
	,is_sla_met BOOLEAN   ENCODE RAW
	,request_opened_by VARCHAR(5000)   ENCODE lzo
	,outage_summary VARCHAR(5000)   ENCODE lzo
	,is_request_post_implementation_review_required BOOLEAN   ENCODE RAW
	,request_post_implementation_review_owner VARCHAR(5000)   ENCODE lzo
	,request_post_implementation_review_date DATE   ENCODE az64
	,request_post_implementation_review_result VARCHAR(5000)   ENCODE lzo
	,request_post_implementation_review_reason VARCHAR(5000)   ENCODE lzo
	,planned_outage_type VARCHAR(5000)   ENCODE lzo
	,is_request_for_production_environment BOOLEAN   ENCODE RAW
	,plan_plus_project_name VARCHAR(5000)   ENCODE lzo
	,request_justification VARCHAR(5000)   ENCODE lzo
	,emergency_request_justification VARCHAR(5000)   ENCODE lzo
	,is_there_a_failover_plan BOOLEAN   ENCODE RAW
	,requested_by VARCHAR(5000)   ENCODE lzo
	,request_resolution_notes VARCHAR(5000)   ENCODE lzo
	,request_review_comment VARCHAR(5000)   ENCODE lzo
	,request_risk_category VARCHAR(5000)   ENCODE lzo
	,request_risk_impact VARCHAR(5000)   ENCODE lzo
	,request_risk_value INTEGER   ENCODE az64
	,standard_change_template_version VARCHAR(5000)   ENCODE lzo
	,standard_change_template_name VARCHAR(5000)   ENCODE lzo
	,system_record_id VARCHAR(5000)   ENCODE lzo
	,system_record_tag_list VARCHAR(5000)   ENCODE lzo
	,pre_release_test_plan VARCHAR(5000)   ENCODE lzo
	,is_pre_release_test_required BOOLEAN   ENCODE RAW
	,pre_release_test_result VARCHAR(5000)   ENCODE lzo
	,is_request_unauthorized BOOLEAN   ENCODE RAW
	,request_validation_plan VARCHAR(5000)   ENCODE lzo
	,third_party_company VARCHAR(5000)   ENCODE lzo
	,watch_list VARCHAR(5000)   ENCODE lzo
	,task_work_notes VARCHAR(5000)   ENCODE lzo
	,request_resolution_category VARCHAR(5000)   ENCODE lzo
	,ucloud_ingestion_date DATE   ENCODE az64
	,feed_id INTEGER   ENCODE az64
	,feed_version INTEGER   ENCODE az64
	,ingestion_id INTEGER   ENCODE az64
	,ingestion_timestamp TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
	,_change_type VARCHAR(50)   ENCODE lzo
	,_commit_version BIGINT   ENCODE az64
	,_commit_timestamp TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
)
DISTSTYLE KEY
DISTKEY(system_record_id)
SORTKEY (record_create_dtml, system_record_id);

