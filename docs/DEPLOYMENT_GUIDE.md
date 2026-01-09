# Deployment Guide - ServiceNow Change Request Pipeline

## 📋 Pre-Deployment Checklist

Before deploying this pipeline, ensure you have:

- [ ] AWS Account access
- [ ] Databricks workspace access
- [ ] Redshift cluster access
- [ ] S3 bucket permissions
- [ ] Airflow environment (MWAA or local)

---

## 🚀 Deployment Steps

### Step 1: Prepare S3 Structure

Create the following S3 paths:

```bash
# Raw bucket (for input CSV files)
s3://demo-etl-s3-raw/servicenow/change_request/

# Staging bucket (for Parquet files)
s3://demo-etl-s3-staging/servicenow/change_request/

# Temp bucket (for Redshift export)
s3://demo-etl-s3-temp/servicenow/change_request/

# Config bucket (for config.ini)
s3://demo-config-bucket/config/servicenow/change_request/

# SQL scripts bucket
s3://demo-config-bucket/sql/redshift/
```

### Step 2: Upload Configuration Files

#### 2.1 Upload config.ini

```bash
aws s3 cp config/config.ini.example \
  s3://demo-config-bucket/config/servicenow/change_request/config.ini
```

**Note**: Update `config.ini.example` with your specific configuration before uploading.

#### 2.2 Upload SQL Script

```bash
aws s3 cp sql/redshift/major_change_rs_sync.sql \
  s3://demo-config-bucket/sql/redshift/major_change_rs_sync.sql
```

### Step 3: Create Databricks Tables

Run in Databricks:
```sql
-- File: sql/databricks/servicenow_change_request_databricks_ddl.sql
-- Creates staging and final Delta tables
```

### Step 4: Create Redshift Tables

Run in Redshift:
```sql
-- File: sql/redshift/servicenow_change_request_redshift_ddl.sql
-- Creates main and temp tables
```

**Important**: This will DROP existing tables. Backup data if needed.

### Step 5: Deploy Databricks Notebooks

#### 5.1 CSV to Parquet Notebook

**Path**: `/Workspace/Users/your-username/databricks_csv_to_parquet_notebook`

**Content**: Use `databricks/notebooks/csv_to_parquet_notebook.py` as reference

#### 5.2 SCD1 Postprocessor

**Path**: `/Workspace/Users/your-username/databricks_scd1_notebook`

**Functionality**: Merges staging to final table

### Step 6: Deploy Airflow DAG

#### 6.1 Upload YAML File

```bash
# For MWAA
aws s3 cp airflow/dags/servicenow_change_request.yaml \
  s3://demo-airflow-bucket/dags/servicenow/change_request/servicenow_change_request.yaml
```

#### 6.2 Upload Python File

```bash
aws s3 cp airflow/dags/servicenow_change_request.py \
  s3://demo-airflow-bucket/dags/servicenow/change_request/servicenow_change_request.py
```

### Step 7: Configure Airflow Variables

Set the following Airflow variables:

```python
# Environment
environment = "demo"

# Bucket names
raw_bucket_name = "demo-etl-s3-raw"
staging_bucket_name = "demo-etl-s3-staging"
temp_bucket_name = "demo-etl-s3-temp"
config_bucket_name = "demo-config-bucket"
logs_bucket_name = "demo-etl-s3-logs"

# Databricks
databricks_catalog = "demo_catalog"
databricks_schema = "demo_schema"
databricks_cluster_id = "your-cluster-id"
databricks_connection = "databricks_default"
budget_policy = "demo-budget-policy"

# Redshift
redshift_db_name = "demo_db"
redshift_iam_role_arn = "arn:aws:iam::account-id:role/your-redshift-role"
```

### Step 8: Test the Pipeline

#### 8.1 Upload Test CSV

```bash
aws s3 cp sample.csv \
  s3://demo-etl-s3-raw/servicenow/change_request/change_request_2024-01-01.csv
```

#### 8.2 Trigger DAG

1. Go to Airflow UI
2. Find DAG: `servicenow_change_request`
3. Click "Trigger DAG"
4. Monitor task execution

#### 8.3 Verify Results

**Check Databricks:**
```sql
SELECT COUNT(*) 
FROM demo_catalog.change_management_tbl.servicenow_change_request;
```

**Check Redshift:**
```sql
SELECT COUNT(*) 
FROM change_management.servicenow_change_request;
```

---

## ✅ Post-Deployment Verification

### Verification Checklist

- [ ] DAG appears in Airflow UI
- [ ] All tasks can be triggered
- [ ] CSV files are detected by S3 sensor
- [ ] Databricks notebooks execute successfully
- [ ] Data appears in Databricks tables
- [ ] Export files created in S3 temp bucket
- [ ] Redshift COPY command succeeds
- [ ] Data appears in Redshift tables
- [ ] Files are archived after processing

### Health Checks

**Daily Checks:**
- Monitor Airflow DAG runs
- Check for failed tasks
- Verify data counts in Redshift

**Weekly Checks:**
- Review error logs
- Verify data quality
- Check S3 storage usage

---

## 🔧 Maintenance

### Regular Tasks

1. **Monitor Logs**: Check Airflow and Databricks logs weekly
2. **Data Quality**: Verify row counts match between systems
3. **Storage**: Monitor S3 bucket sizes
4. **Performance**: Check task execution times

### Updates

When updating the pipeline:
1. Test changes in dev environment
2. Update documentation
3. Notify stakeholders
4. Deploy to production

---

## 📞 Support Contacts

- **Airflow Issues**: Check Airflow logs and documentation
- **Databricks Issues**: Check Databricks workspace
- **Redshift Issues**: See SQL scripts in `sql/redshift/`
- **Schema Issues**: See DDL scripts in `sql/` folders

---

## 📚 Additional Resources

- [Project Documentation](PROJECT_DOCUMENTATION.md)
- [Architecture Diagram](ARCHITECTURE_DIAGRAM.md)
- [Project Summary](PROJECT_SUMMARY.md)

