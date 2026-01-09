# Quick Git Push Guide

## 📦 Repository Name Suggestion

**Recommended Repository Name:**
```
servicenow-etl-pipeline
```

**Alternative Names:**
- `servicenow-change-request-etl`
- `etl-pipeline-databricks-redshift`
- `airflow-databricks-redshift-pipeline`
- `servicenow-data-pipeline`

---

## 🚀 Git Commands (Step-by-Step)

### Step 1: Navigate to Portfolio Folder

```powershell
cd "D:\KshravanKumar\POC's\Apache Airflow Local Setup + Run DAG\servicenow-etl-pipeline-portfolio"
```

### Step 2: Initialize Git Repository

```powershell
git init
```

### Step 3: Add All Files

```powershell
git add .
```

### Step 4: Create Initial Commit

```powershell
git commit -m "Initial commit: ServiceNow Change Request ETL Pipeline

- Complete ETL pipeline implementation
- Airflow DAG configuration
- Databricks notebooks for CSV to Parquet conversion
- Redshift DDL and sync scripts
- Comprehensive documentation
- All sensitive data replaced with dummy values for portfolio"
```

### Step 5: Create GitHub Repository

1. Go to https://github.com
2. Click **"New repository"** (or **"+"** → **"New repository"**)
3. **Repository name**: `servicenow-etl-pipeline`
4. **Description**: `ETL Pipeline for ServiceNow Change Request data using Apache Airflow, Databricks, and AWS Redshift. Complete implementation with comprehensive documentation.`
5. Choose: **Public** (for portfolio showcase)
6. **DO NOT** initialize with README, .gitignore, or license (we already have these)
7. Click **"Create repository"**

### Step 6: Add Remote and Push

```powershell
# Add remote (REPLACE YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/servicenow-etl-pipeline.git

# Rename branch to main
git branch -M main

# Push to GitHub
git push -u origin main
```

---

## 📋 Complete Command Sequence (Copy & Paste)

**Replace `YOUR_USERNAME` with your actual GitHub username:**

```powershell
cd "D:\KshravanKumar\POC's\Apache Airflow Local Setup + Run DAG\servicenow-etl-pipeline-portfolio"
git init
git add .
git commit -m "Initial commit: ServiceNow Change Request ETL Pipeline - Complete implementation with Airflow, Databricks, and Redshift"
git remote add origin https://github.com/YOUR_USERNAME/servicenow-etl-pipeline.git
git branch -M main
git push -u origin main
```

---

## 🔐 Authentication

If you're prompted for credentials:

**Option 1: Personal Access Token (Recommended)**
1. Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token with `repo` scope
3. Use token as password when prompted

**Option 2: GitHub CLI**
```powershell
gh auth login
```

---

## ✅ After Pushing

### Add Repository Topics (for discoverability)

Go to your repository on GitHub → Settings → Topics → Add:
- `etl-pipeline`
- `apache-airflow`
- `databricks`
- `aws-redshift`
- `pyspark`
- `data-engineering`
- `python`
- `sql`
- `portfolio`

### Update Repository Description

```
ETL Pipeline for ServiceNow Change Request data using Apache Airflow, Databricks, and AWS Redshift. 
Portfolio project demonstrating end-to-end data pipeline implementation with comprehensive documentation.
```

---

## 🎯 Quick Reference

**Repository Name:** `servicenow-etl-pipeline`

**Repository URL:** `https://github.com/YOUR_USERNAME/servicenow-etl-pipeline`

**Folder Path:** `servicenow-etl-pipeline-portfolio/`

---

## ❓ Troubleshooting

### If you get "remote origin already exists":
```powershell
git remote remove origin
git remote add origin https://github.com/YOUR_USERNAME/servicenow-etl-pipeline.git
```

### If you need to update and push again:
```powershell
git add .
git commit -m "Update: [describe your changes]"
git push
```

### If you want to check status:
```powershell
git status
```

