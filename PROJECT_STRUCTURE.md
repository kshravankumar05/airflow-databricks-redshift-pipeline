# Project Structure - ServiceNow ETL Pipeline Portfolio

## 📁 Complete Folder Structure

```
servicenow-etl-pipeline-portfolio/
├── README.md                          # Main project README
├── PORTFOLIO_README.md                # Important security notice
├── PROJECT_STRUCTURE.md               # This file
├── GIT_COMMANDS.md                    # Git setup instructions
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
    ├── PROJECT_DOCUMENTATION.md       # Complete technical overview
    ├── DEPLOYMENT_GUIDE.md            # Deployment instructions
    ├── PROJECT_SUMMARY.md             # Executive summary
    └── ARCHITECTURE_DIAGRAM.md        # Architecture diagrams
```

## 📝 File Descriptions

### Root Files
- **README.md**: Main project overview and quick start
- **PORTFOLIO_README.md**: Security notice - all data sanitized
- **PROJECT_STRUCTURE.md**: This file - project structure guide
- **GIT_COMMANDS.md**: Step-by-step Git commands for pushing to GitHub
- **.gitignore**: Excludes sensitive files and local setup
- **.gitattributes**: Git file handling rules

### Airflow DAGs
- **servicenow_change_request.yaml**: Complete DAG configuration with all tasks
- **servicenow_change_request.py**: Python DAG factory implementation

### Databricks Notebooks
- **csv_to_parquet_notebook.py**: CSV to Parquet conversion with transformations

### SQL Scripts
- **databricks/servicenow_change_request_databricks_ddl.sql**: Databricks Delta table DDL
- **redshift/servicenow_change_request_redshift_ddl.sql**: Redshift table DDL
- **redshift/major_change_rs_sync.sql**: Redshift data synchronization script
- **verification/VERIFY_CDC_COLUMNS.sql**: CDC column verification queries

### Configuration
- **config/config.ini.example**: Example configuration file template

### Documentation
- **PROJECT_DOCUMENTATION.md**: Complete technical documentation
- **DEPLOYMENT_GUIDE.md**: Step-by-step deployment instructions
- **PROJECT_SUMMARY.md**: Executive summary
- **ARCHITECTURE_DIAGRAM.md**: System architecture and data flow

## 🔒 Security Notes

All files in this portfolio folder have been sanitized:
- ✅ No real credentials
- ✅ No real bucket names
- ✅ No real database names
- ✅ No real email addresses
- ✅ No company-specific data

All values are examples/dummy data safe for public sharing.

## 🚀 Next Steps

1. Review the project structure
2. Read `PORTFOLIO_README.md` for important security information
3. Follow `GIT_COMMANDS.md` to push to GitHub
4. Update your portfolio with the repository link

