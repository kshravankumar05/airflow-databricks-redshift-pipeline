# ServiceNow Change Request ETL Pipeline - Complete Project Documentation

## 📖 Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture & Design](#architecture--design)
3. [Data Pipeline Flow](#data-pipeline-flow)
4. [Component Details](#component-details)
5. [Implementation Tasks](#implementation-tasks)
6. [Technical Specifications](#technical-specifications)
7. [Configuration Files](#configuration-files)
8. [Database Schemas](#database-schemas)
9. [Troubleshooting](#troubleshooting)

---

## 🎯 Project Overview

### Purpose
This project implements a production-ready ETL pipeline for processing ServiceNow Change Request data. The pipeline handles data ingestion, transformation, and loading into both Databricks Delta Lake and AWS Redshift.

**Note**: This is a portfolio/demonstration project. All configurations use example/dummy values.

### Business Value
- **Automated Data Processing**: Eliminates manual data processing
- **Data Quality**: Ensures data consistency and validation
- **Scalability**: Handles large volumes of change request data
- **Analytics Ready**: Data available in Redshift for business intelligence

### Scope
- CSV file ingestion from S3
- Data transformation (CSV → Parquet)
- Databricks Delta table management
- Redshift data synchronization
- Error handling and monitoring

---

## 🏗️ Architecture & Design

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Apache Airflow (MWAA)                     │
│                  Orchestration & Scheduling                   │
└───────────────────────┬─────────────────────────────────────┘
                        │
        ┌───────────────┼───────────────┐
        │               │               │
        ▼               ▼               ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│   AWS S3     │ │  Databricks  │ │   Redshift   │
│  (Storage)   │ │ (Processing)  │ │ (Datawarehouse)│
└──────────────┘ └──────────────┘ └──────────────┘
```

### Data Flow Architecture

```
1. S3 Raw Bucket (CSV files)
   ↓
2. Airflow S3 Sensor (detects new files)
   ↓
3. Databricks CSV Parser (CSV → Parquet)
   ↓
4. Databricks Staging Table
   ↓
5. SCD1 Postprocessor (merge logic)
   ↓
6. Databricks Final Table (Delta Lake)
   ↓
7. Export Runner (CDF - Change Data Feed)
   ↓
8. S3 Temp Bucket (Parquet files)
   ↓
9. Redshift COPY Command
   ↓
10. Redshift Tables (Analytics ready)
```

---

## 📊 Data Pipeline Flow

### Step-by-Step Process

#### **Step 1: File Detection**
- **Component**: Airflow S3KeySensor
- **Action**: Monitors S3 bucket for new CSV files
- **Pattern**: `servicenow/change_request/*.csv`

#### **Step 2: File Validation**
- **Component**: PythonOperator - `check_if_empty_file`
- **Action**: Validates file is not empty
- **Output**: Proceeds if file has data

#### **Step 3: CSV to Parquet Conversion**
- **Component**: Databricks Notebook
- **Action**: 
  - Reads CSV from S3
  - Applies transformations based on config.ini
  - Converts to Parquet format
  - Writes to staging S3 location
- **Technology**: PySpark

#### **Step 4: Metadata Registration**
- **Component**: Metadata Framework
- **Action**: Registers file metadata in audit tables
- **Purpose**: Track data lineage and processing status

#### **Step 5: SCD1 Processing**
- **Component**: Databricks SCD1 Notebook
- **Action**: 
  - Merges data from staging to final table
  - Handles inserts and updates
  - Uses `system_record_id` as unique key

#### **Step 6: Data Export**
- **Component**: Databricks Export Runner
- **Action**: 
  - Exports changed records (insert/update) to S3
  - Uses Change Data Feed (CDF)
  - Filters: `'insert','update_postimage'`

#### **Step 7: Redshift Sync**
- **Component**: Redshift COPY Command
- **Action**: 
  - Loads Parquet files from S3 to Redshift temp table
  - Inserts new records
  - Updates existing records

#### **Step 8: Archive**
- **Component**: PythonOperator - `raw_file_mover`
- **Action**: Moves processed CSV files to archive location

---

## 🔧 Component Details

### 1. Apache Airflow DAG

**File**: `airflow/dags/servicenow_change_request.yaml`

**Key Tasks**:
- `get_feed_date`: Calculates feed date
- `insert_run_control`: Inserts run control record
- `s3_sensor_major_change`: Detects new files
- `check_if_empty_file`: Validates file
- `major_change_raw_csv_parser`: CSV to Parquet conversion
- `feed_id_sequence_major_change`: Gets feed ID
- `meta_file_creation_major_change`: Creates metadata files
- `poll_major_change`: Polls for completion
- `postprocessor_scd1`: SCD1 merge
- `databricks_export_runner`: Exports to S3
- `redshift_sync`: Syncs to Redshift
- `check_redshift_sync_status`: Verifies sync
- `raw_file_mover`: Archives files

### 2. Databricks Notebooks

#### CSV to Parquet Converter
**File**: `databricks/notebooks/csv_to_parquet_notebook.py`

**Functionality**:
- Reads config.ini from S3
- Applies column mappings
- Handles data type conversions
- Writes Parquet files to staging

#### SCD1 Postprocessor
**Notebook Path**: `/Workspace/Users/demo@example.com/databricks_scd1_notebook`

**Functionality**:
- Merges staging data to final table
- Handles inserts and updates
- Uses Delta Lake merge operations

#### Export Runner
**Notebook Path**: `/Workspace/Users/demo@example.com/databricks_export_notebook`

**Functionality**:
- Exports changed records using CDF
- Filters for insert and update_postimage
- Writes Parquet files to S3 temp bucket

### 3. Redshift Tables

#### Main Table
- **Schema**: `change_management`
- **Table**: `servicenow_change_request`
- **Columns**: 95 columns
- **Distribution**: KEY (system_record_id)
- **Sort Key**: record_create_dtml, system_record_id

#### Temp Table
- **Schema**: `change_management`
- **Table**: `servicenow_change_request_temp`
- **Columns**: 98 columns (includes CDC columns)
- **CDC Columns**: `_change_type`, `_commit_version`, `_commit_timestamp`

### 4. SQL Scripts

#### Redshift Sync Script
**File**: `sql/redshift/major_change_rs_sync.sql`

**Operations**:
1. DELETE from temp table
2. COPY from S3 (Parquet files)
3. INSERT new records
4. UPDATE existing records

---

## 📋 Implementation Tasks

### Task 1: Initial Setup
- Created Airflow DAG files
- Configured YAML structure
- Set up task dependencies
- Created documentation

**Files**:
- `airflow/dags/servicenow_change_request.py`
- `airflow/dags/servicenow_change_request.yaml`

### Task 2: CSV to Parquet Conversion
- Developed Databricks notebooks
- Implemented config.ini parsing
- Created column mapping logic
- Fixed transformation errors
- Resolved Redshift sync issues

**Files**:
- `databricks/notebooks/csv_to_parquet_notebook.py`
- `airflow/dags/servicenow_change_request.yaml`
- `sql/redshift/major_change_rs_sync.sql`

### Task 3: Database DDL
- Created Databricks DDL scripts
- Created Redshift DDL scripts
- Verified schema compatibility
- Fixed data type mismatches

**Files**:
- `sql/databricks/servicenow_change_request_databricks_ddl.sql`
- `sql/redshift/servicenow_change_request_redshift_ddl.sql`

### Task 4: Schema Verification
- Verified external table schemas
- Compared Databricks and Redshift schemas
- Fixed data type mismatches
- Created verification scripts

**Files**:
- `sql/verification/VERIFY_CDC_COLUMNS.sql`

---

## 🔍 Technical Specifications

### Data Formats

#### Input Format
- **Type**: CSV
- **Location**: `s3://demo-etl-s3-raw/servicenow/change_request/`
- **Example**: `change_request_2024-01-01.csv`

#### Intermediate Format
- **Type**: Parquet (Snappy compression)
- **Location**: `s3://demo-etl-s3-staging/servicenow/change_request/`
- **Schema**: Defined in config.ini

#### Output Format
- **Databricks**: Delta Lake format
- **Redshift**: Columnar storage (Parquet via COPY)

### Data Types Mapping

| Databricks | Redshift | Notes |
|------------|----------|-------|
| STRING | VARCHAR(5000) | Text fields |
| INT | INTEGER | Numeric fields |
| BIGINT | BIGINT | Large integers |
| TIMESTAMP | TIMESTAMP WITHOUT TIME ZONE | Date/time |
| DATE | DATE | Date only |
| BOOLEAN | BOOLEAN | True/false |
| DECIMAL(10,2) | NUMERIC(10,2) | Decimal numbers |

### Key Columns

- **Primary Key**: `system_record_id` (VARCHAR)
- **CDC Columns**: `_change_type`, `_commit_version`, `_commit_timestamp`
- **Audit Columns**: `feed_id`, `feed_version`, `ingestion_id`, `ingestion_timestamp`

---

## 📝 Configuration Files

### 1. Airflow YAML Configuration
**File**: `airflow/dags/servicenow_change_request.yaml`

**Key Sections**:
- `default_args`: Retry logic, timezone
- `tasks`: Task definitions with dependencies
- `job_params`: Parameters for each task

### 2. Config.ini
**Location**: `s3://demo-config-bucket/config/servicenow/change_request/config.ini`

**Purpose**:
- Column mappings
- Data type definitions
- Transformation rules

### 3. SQL Scripts
**Location**: `s3://demo-config-bucket/sql/redshift/major_change_rs_sync.sql`

**Purpose**: Redshift data synchronization

---

## 🗄️ Database Schemas

### Databricks Schema

**Catalog**: `demo_catalog`
**Schema**: `change_management_tbl`
**Table**: `servicenow_change_request`

**Total Columns**: 95
**Format**: Delta Lake
**Location**: `s3://demo-lakehouse-bucket/change_management/servicenow_change_request`

### Redshift Schema

**Database**: `demo_db`
**Schema**: `change_management`
**Tables**: 
- `servicenow_change_request` (95 columns)
- `servicenow_change_request_temp` (98 columns)

---

## 🐛 Troubleshooting

### Common Issues

1. **Redshift Spectrum Error 15007**
   - **Cause**: Schema mismatch or missing files
   - **Solution**: Verify schema matches Databricks table

2. **CSV Parsing Errors**
   - **Cause**: Column mismatch or data type issues
   - **Solution**: Verify config.ini mappings

3. **Poll Timeout**
   - **Cause**: Databricks job taking too long
   - **Solution**: Increase timeout in YAML

4. **Schema Mismatch**
   - **Cause**: Databricks and Redshift schemas don't match
   - **Solution**: Run DDL scripts to update schema

---

## ✅ Project Completion Checklist

- [x] Airflow DAG configuration
- [x] Databricks notebooks
- [x] Redshift DDL scripts
- [x] SQL synchronization scripts
- [x] Error handling
- [x] Documentation
- [x] Schema verification
- [x] Data type fixes
- [x] CDC column handling

---

## 🎓 Learning Outcomes

This project demonstrates:
- **ETL Pipeline Design**: End-to-end data pipeline architecture
- **Cloud Technologies**: AWS S3, Redshift, Databricks integration
- **Orchestration**: Apache Airflow DAG management
- **Data Processing**: PySpark for data transformation
- **Database Design**: Schema design for data warehousing
- **Error Handling**: Comprehensive error handling strategies
- **Documentation**: Technical documentation best practices

