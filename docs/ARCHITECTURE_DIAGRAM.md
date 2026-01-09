# Architecture Diagram - ServiceNow Change Request Pipeline

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    Apache Airflow (MWAA)                         │
│              Orchestration & Workflow Management                 │
│                                                                  │
│  DAG: servicenow_change_request                                  │
└───────────────────────┬─────────────────────────────────────────┘
                        │
        ┌───────────────┼───────────────┐
        │               │               │
        ▼               ▼               ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│   AWS S3     │ │  Databricks  │ │   Redshift   │
│              │ │              │ │              │
│ Raw Bucket  │ │  Workspace   │ │   Cluster    │
│ Staging     │ │  Notebooks   │ │   Database   │
│ Temp        │ │  Delta Lake  │ │   Tables     │
└──────────────┘ └──────────────┘ └──────────────┘
```

## 📊 Detailed Data Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                         DATA PIPELINE FLOW                           │
└─────────────────────────────────────────────────────────────────────┘

1. INPUT
   ┌─────────────┐
   │ S3 Raw      │  CSV File: change_request_2024-01-01.csv
   │ Bucket      │  Location: servicenow/change_request/
   └──────┬──────┘
          │
          ▼
2. DETECTION
   ┌─────────────┐
   │ Airflow     │  S3KeySensor detects new file
   │ S3 Sensor   │
   └──────┬──────┘
          │
          ▼
3. VALIDATION
   ┌─────────────┐
   │ Airflow     │  Check if file is empty
   │ File Check  │
   └──────┬──────┘
          │
          ▼
4. TRANSFORMATION
   ┌─────────────┐
   │ Databricks  │  CSV → Parquet conversion
   │ Notebook    │  - Read config.ini
   │             │  - Apply transformations
   │             │  - Write Parquet to staging
   └──────┬──────┘
          │
          ▼
5. STAGING
   ┌─────────────┐
   │ Databricks  │  staging_change_management
   │ Staging     │  .servicenow_change_request
   │ Table       │
   └──────┬──────┘
          │
          ▼
6. PROCESSING
   ┌─────────────┐
   │ Databricks  │  SCD1 Merge
   │ SCD1        │  - Insert new records
   │ Notebook    │  - Update existing records
   └──────┬──────┘
          │
          ▼
7. FINAL TABLE
   ┌─────────────┐
   │ Databricks  │  change_management_tbl
   │ Delta Table │  .servicenow_change_request
   │             │  (Delta Lake format)
   └──────┬──────┘
          │
          ▼
8. EXPORT
   ┌─────────────┐
   │ Databricks  │  Export changed records
   │ Export      │  - Filter: insert, update_postimage
   │ Runner      │  - Write Parquet to S3 temp
   └──────┬──────┘
          │
          ▼
9. SYNC
   ┌─────────────┐
   │ Redshift    │  COPY from S3
   │ COPY        │  - Load to temp table
   │ Command     │  - Insert/Update main table
   └──────┬──────┘
          │
          ▼
10. ANALYTICS
   ┌─────────────┐
   │ Redshift    │  Data ready for analytics
   │ Tables      │  - BI tools
   │             │  - Reporting
   └─────────────┘
```

## 🔄 Task Dependencies

```
get_feed_date
    │
    ├──> insert_run_control
    │       │
    │       └──> s3_sensor_major_change
    │               │
    │               └──> check_if_empty_file
    │                       │
    │                       └──> major_change_raw_csv_parser
    │                               │
    │                               ├──> feed_id_sequence_major_change
    │                               │       │
    │                               │       └──> meta_file_creation_major_change
    │                               │               │
    │                               │               └──> poll_major_change
    │                               │                       │
    │                               │                       └──> postprocessor_scd1
    │                               │                               │
    │                               │                               └──> databricks_export_runner
    │                               │                                       │
    │                               │                                       └──> redshift_sync
    │                               │                                               │
    │                               │                                               └──> check_redshift_sync_status
    │                               │                                                       │
    │                               │                                                       └──> raw_file_mover
    │                               │                                                               │
    │                               │                                                               └──> update_feed_date
    │                               │                                                                       │
    │                               │                                                                       └──> update_run_control
```

## 🗄️ Database Schema Overview

### Databricks Schema
```
demo_catalog
└── staging_change_management
    └── servicenow_change_request (staging)
└── change_management_tbl
    └── servicenow_change_request (final)
```

### Redshift Schema
```
demo_db
└── change_management
    ├── servicenow_change_request (main - 95 columns)
    └── servicenow_change_request_temp (temp - 98 columns)
        └── Includes: _change_type, _commit_version, _commit_timestamp
```

## 📦 S3 Bucket Structure

```
demo-etl-s3-raw/
└── servicenow/change_request/
    └── change_request_2024-01-01.csv (input)

demo-etl-s3-staging/
└── servicenow/change_request/
    └── *.parquet (intermediate)

demo-etl-s3-temp/
└── servicenow/change_request/
    └── change_management_tbl.servicenow_change_request/
        └── *.snappy.parquet (for Redshift)

demo-config-bucket/
├── config/servicenow/change_request/config.ini
└── sql/redshift/major_change_rs_sync.sql
```

## 🔐 IAM & Permissions

### Required Permissions

**Airflow (MWAA)**:
- S3 read/write access
- Databricks API access
- Redshift connection

**Databricks**:
- S3 read/write access
- Service Principal authentication

**Redshift**:
- S3 read access (via IAM role)
- IAM Role: `arn:aws:iam::account-id:role/your-redshift-role`

## 📈 Performance Considerations

- **Parallel Processing**: Databricks Spark for parallel CSV processing
- **Partitioning**: Delta Lake partitioning on ingestion_timestamp
- **Distribution**: Redshift KEY distribution on system_record_id
- **Sort Keys**: Optimized for time-based queries

