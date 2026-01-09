# Git Commands - Quick Reference

## 🚀 Quick Setup

### Step 1: Create GitHub Repository

1. Go to https://github.com
2. Click "New repository"
3. Name: `servicenow-change-request-etl-pipeline`
4. Description: "ETL Pipeline for ServiceNow Change Request data using Apache Airflow, Databricks, and AWS Redshift"
5. Choose: **Public** (for portfolio)
6. Click "Create repository"

### Step 2: Initialize and Push

```powershell
# Navigate to portfolio project folder
cd "D:\KshravanKumar\POC's\Apache Airflow Local Setup + Run DAG\servicenow-etl-pipeline-portfolio"

# Initialize Git
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: ServiceNow Change Request ETL Pipeline

- Complete ETL pipeline implementation
- Airflow DAG configuration
- Databricks notebooks
- Redshift DDL and sync scripts
- Comprehensive documentation
- All sensitive data replaced with dummy values"

# Add remote (REPLACE YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/servicenow-change-request-etl-pipeline.git

# Rename branch to main
git branch -M main

# Push to GitHub
git push -u origin main
```

## 📋 Repository Structure

After pushing, your repository will have:

```
servicenow-change-request-etl-pipeline/
├── README.md
├── .gitignore
├── .gitattributes
├── airflow/
│   └── dags/
├── databricks/
│   └── notebooks/
├── sql/
│   ├── databricks/
│   ├── redshift/
│   └── verification/
├── config/
└── docs/
```

## 🎨 GitHub Repository Settings

After pushing, configure:

### Topics (for discoverability):
- `etl-pipeline`
- `apache-airflow`
- `databricks`
- `aws-redshift`
- `pyspark`
- `data-engineering`
- `python`
- `sql`

### Description:
"ETL Pipeline for ServiceNow Change Request data using Apache Airflow, Databricks, and AWS Redshift. Portfolio project with comprehensive documentation."

## ✅ Pre-Push Checklist

- [x] Code organized in proper structure
- [x] Documentation complete
- [x] .gitignore configured
- [x] README.md updated
- [x] All sensitive data replaced with dummy values
- [ ] Create GitHub repository
- [ ] Run Git commands
- [ ] Add repository topics

## 🔗 Next Steps

1. **Create GitHub Repository** (if not done)
2. **Run Git Commands** (see above)
3. **Add Repository Topics** (for discoverability)
4. **Update Portfolio** (add link to repository)
5. **Share on LinkedIn** (showcase your work!)

