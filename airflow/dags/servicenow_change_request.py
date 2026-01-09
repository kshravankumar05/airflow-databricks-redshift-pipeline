"""
ServiceNow Change Request ETL Pipeline - Airflow DAG
Portfolio/Demo Version
"""
from airflow import DAG
from dag_factory import dagfactory_v4 as dagfactory

# Configuration file path
config_file = "/usr/local/airflow/dags/servicenow/change_request/servicenow_change_request.yaml"

# Initialize DAG factory
example_dag_factory = dagfactory.DagFactory(config_file)

# Creating task dependencies
example_dag_factory.clean_dags(globals())
example_dag_factory.generate_dags(globals())

