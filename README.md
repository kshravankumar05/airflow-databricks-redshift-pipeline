# ServiceNow Change Request ETL Pipeline

## 📋 Project Overview

This project implements a complete **ETL (Extract, Transform, Load) pipeline** for processing ServiceNow Change Request data using **Apache Airflow**, **Databricks**, and **AWS Redshift**. The pipeline processes CSV files from S3, converts them to Parquet format, loads into Databricks Delta tables, and syncs to Redshift for analytics.

**Note**: This is a portfolio/demonstration project with example configurations. All sensitive data has been replaced with dummy values.

## 🎯 Project Objectives

- **Extract**: Read CSV files from S3 bucket
- **Transform**: Convert CSV to Parquet using PySpark in Databricks
- **Load**: Store processed data in Databricks Delta tables
- **Sync**: Replicate data to AWS Redshift for analytics
- **Orchestrate**: Manage entire workflow using Apache Airflow

## 🏗️ Architecture

```
┌─────────────┐
│   S3 Bucket │  (Raw CSV files)
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│  Apache Airflow │  (Orchestration)
└──────┬──────────┘
       │
       ├─────────────────┬──────────────────┐
       ▼                 ▼                  ▼
┌─────────────┐  ┌──────────────┐  ┌─────────────┐
│  Databricks │  │  Databricks  │  │  Redshift   │
│ CSV Parser  │→ │ Delta Tables │→ │   Tables    │
└─────────────┘  └──────────────┘  └─────────────┘
```

## 📁 Project Structure

```
.
├── README.md                          # This file
├── .gitignore                         # Git ignore rules
├── .gitattributes                     # Git attributes
│
├── airflow/                           # Apache Airflow DAGs
│   └── dags/
│       ├── servicenow_change_request.yaml
│       └── servicenow_change_request.py
│
├── databricks/                        # Databricks notebooks
│   └── notebooks/
│       └── csv_to_parquet_notebook.py
│
├── sql/                               # SQL scripts
│   ├── databricks/
│   │   └── servicenow_change_request_databricks_ddl.sql
│   ├── redshift/
│   │   ├── servicenow_change_request_redshift_ddl.sql
│   │   └── major_change_rs_sync.sql
│   └── verification/
│       └── VERIFY_CDC_COLUMNS.sql
│
├── config/                            # Configuration files
│   └── config.ini.example
│
└── docs/                              # Documentation
    ├── PROJECT_DOCUMENTATION.md
    ├── DEPLOYMENT_GUIDE.md
    ├── PROJECT_SUMMARY.md
    └── ARCHITECTURE_DIAGRAM.md
```

## 🚀 Key Features

- ✅ **Automated ETL Pipeline**: End-to-end automation using Airflow
- ✅ **Data Transformation**: CSV to Parquet conversion with schema validation
- ✅ **Delta Lake Integration**: Uses Databricks Delta tables for ACID transactions
- ✅ **Change Data Capture (CDC)**: Tracks inserts and updates
- ✅ **Redshift Sync**: Automated data replication to Redshift
- ✅ **Error Handling**: Comprehensive error handling and retry logic

## 🛠️ Technology Stack

| Component | Technology |
|-----------|-----------|
| **Orchestration** | Apache Airflow |
| **Data Processing** | Databricks (PySpark) |
| **Storage** | AWS S3, Databricks Delta Lake |
| **Data Warehouse** | AWS Redshift |
| **Configuration** | YAML, INI files |
| **Languages** | Python, SQL |

## 📊 Data Flow

1. **S3 Sensor**: Monitors S3 bucket for new CSV files
2. **CSV Parser**: Databricks notebook converts CSV to Parquet
3. **Staging Table**: Data loaded into Databricks staging table
4. **SCD1 Processing**: Slowly Changing Dimension Type 1 merge
5. **Export Runner**: Exports changed records to S3 as Parquet
6. **Redshift Sync**: COPY command loads data into Redshift
7. **Archive**: Raw files moved to archive location

## 📚 Documentation

- **[Project Documentation](docs/PROJECT_DOCUMENTATION.md)** - Complete project overview
- **[Deployment Guide](docs/DEPLOYMENT_GUIDE.md)** - Step-by-step deployment
- **[Architecture Diagram](docs/ARCHITECTURE_DIAGRAM.md)** - System architecture
- **[Project Summary](docs/PROJECT_SUMMARY.md)** - Executive summary

## 🔧 Setup & Installation

See [DEPLOYMENT_GUIDE.md](docs/DEPLOYMENT_GUIDE.md) for detailed setup instructions.

## ⚠️ Important Notes

- **This is a portfolio project**: All configurations use example/dummy values
- **No sensitive data**: All real credentials, bucket names, and paths have been replaced
- **For demonstration only**: This code is for showcasing skills and architecture

## 📝 Key Deliverables

- ✅ Airflow DAG configuration (YAML)
- ✅ Databricks notebooks for data processing
- ✅ Redshift DDL scripts
- ✅ SQL scripts for data synchronization
- ✅ Comprehensive documentation

## 🎓 Skills Demonstrated

- **ETL Pipeline Design**: Complete end-to-end pipeline architecture
- **Cloud Technologies**: AWS S3, Redshift, Databricks integration
- **Orchestration**: Apache Airflow DAG management
- **Data Processing**: PySpark for data transformation
- **Database Design**: Schema design for data warehousing
- **Error Handling**: Comprehensive error handling strategies
- **Documentation**: Technical documentation best practices

## 📄 License

This project is for portfolio/showcase purposes.

## 👤 Author

**Kshravan Kumar**

## 🔗 Quick Links

- [Project Documentation](docs/PROJECT_DOCUMENTATION.md)
- [Deployment Guide](docs/DEPLOYMENT_GUIDE.md)
- [Architecture Diagram](docs/ARCHITECTURE_DIAGRAM.md)

