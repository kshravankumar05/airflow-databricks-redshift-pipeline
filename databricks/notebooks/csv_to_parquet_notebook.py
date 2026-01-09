# Databricks notebook source
# MAGIC %md
# MAGIC # ServiceNow Change Request - CSV to Parquet Converter
# MAGIC 
# MAGIC This notebook reads CSV files from S3, applies transformations based on config.ini, and converts to Parquet format.
# MAGIC 
# MAGIC **Portfolio/Demo Version** - Example implementation

# COMMAND ----------

# MAGIC %md
# MAGIC ## Step 1: Get Parameters from Airflow

# COMMAND ----------

# Get parameters passed from Airflow
s3_input_path = dbutils.widgets.get("s3_input_path")
s3_output_path = dbutils.widgets.get("s3_output_path")
s3_temp_path = dbutils.widgets.get("s3_temp_path")
pipeline_name = dbutils.widgets.get("pipeline_name")
run_date = dbutils.widgets.get("RUN_DATE")
config_ini_bucket = dbutils.widgets.get("CONFIG_INI_BUCKET")
config_ini_path = dbutils.widgets.get("CONFIG_INI_PATH")
catalog = dbutils.widgets.get("CATALOG")
schema = dbutils.widgets.get("SCHEMA")

print(f"s3_input_path: {s3_input_path}")
print(f"s3_output_path: {s3_output_path}")
print(f"pipeline_name: {pipeline_name}")
print(f"config_ini_bucket: {config_ini_bucket}")
print(f"config_ini_path: {config_ini_path}")

# COMMAND ----------

# MAGIC %md
# MAGIC ## Step 2: Read and Parse config.ini from S3

# COMMAND ----------

import configparser
import io
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, lit, current_timestamp, regexp_replace, when, isnan, isnull, trim
from pyspark.sql.types import StringType
import json

# Read config.ini from S3 using Spark (direct S3 access)
config_s3_path = f"s3://{config_ini_bucket}/{config_ini_path}"
print(f"Reading config from: {config_s3_path}")

try:
    # Read config file as text using Spark
    config_df = spark.read.text(config_s3_path)
    
    # Collect and join all lines
    config_lines = config_df.collect()
    config_content = '\n'.join([row.value for row in config_lines])
    
    # Parse config.ini
    config = configparser.ConfigParser()
    config.read_string(config_content)
    
    # Get pipeline section
    pipeline_section = config[pipeline_name]
    
    # Get output columns
    output_cols_str = pipeline_section.get('output_cols', '')
    output_cols = [col.strip() for col in output_cols_str.split(',') if col.strip()]
    print(f"Output columns: {output_cols}")
    
    # Get drop duplicate flag
    is_drop_duplicate = pipeline_section.get('is_drop_duplicate', 'N').upper() == 'Y'
    print(f"Drop duplicates: {is_drop_duplicate}")
    
    # Get renamed columns (JSON format)
    renamed_cols_str = pipeline_section.get('renamed_cols', '{}')
    renamed_cols = json.loads(renamed_cols_str) if renamed_cols_str else {}
    print(f"Renamed columns: {renamed_cols}")
    
except Exception as e:
    print(f"Error reading config.ini: {str(e)}")
    raise

# COMMAND ----------

# MAGIC %md
# MAGIC ## Step 3: Read CSV from S3

# COMMAND ----------

# Read CSV file from S3 using Spark (direct S3 access - no boto3 needed)
print(f"Reading CSV from: {s3_input_path}")

# Read CSV with proper handling of multiline fields
df = spark.read \
    .option("header", "true") \
    .option("inferSchema", "false") \
    .option("multiline", "true") \
    .option("quote", "\"") \
    .option("escape", "\"") \
    .option("ignoreLeadingWhiteSpace", "true") \
    .option("ignoreTrailingWhiteSpace", "true") \
    .csv(s3_input_path)

print(f"Total rows read: {df.count()}")
print(f"Total columns: {len(df.columns)}")
df.printSchema()

# COMMAND ----------

# MAGIC %md
# MAGIC ## Step 4: Apply Column Renaming

# COMMAND ----------

# Apply column renaming if specified in config.ini
if renamed_cols:
    for old_col, new_col in renamed_cols.items():
        if old_col in df.columns:
            df = df.withColumnRenamed(old_col, new_col)
            print(f"Renamed column: {old_col} -> {new_col}")
        else:
            print(f"Warning: Column {old_col} not found in CSV")

# COMMAND ----------

# MAGIC %md
# MAGIC ## Step 5: Select Output Columns and Handle Missing Columns

# COMMAND ----------

# Select only the columns specified in output_cols
# Handle missing columns by adding them as null
available_cols = df.columns
selected_cols = []

for col_name in output_cols:
    if col_name in available_cols:
        selected_cols.append(col(col_name))
    else:
        # Add missing column as null
        print(f"Warning: Column {col_name} not found, adding as null")
        selected_cols.append(lit(None).alias(col_name))

df_selected = df.select(selected_cols)

print(f"Selected {len(selected_cols)} columns")
df_selected.printSchema()

# COMMAND ----------

# MAGIC %md
# MAGIC ## Step 6: Add Metadata Columns

# COMMAND ----------

# Add metadata columns
from datetime import datetime
import uuid

# Generate ingestion metadata
ingestion_timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
ingestion_id = str(uuid.uuid4())
feed_id = "DEMO001"  # Demo feed ID
feed_version = "1.0"
ucloud_ingestion_date = run_date if run_date else datetime.now().strftime("%Y-%m-%d")

# Add metadata columns
df_final = df_selected \
    .withColumn("feed_id", lit(feed_id)) \
    .withColumn("feed_version", lit(feed_version)) \
    .withColumn("ingestion_id", lit(ingestion_id)) \
    .withColumn("ingestion_timestamp", lit(ingestion_timestamp)) \
    .withColumn("ucloud_ingestion_date", lit(ucloud_ingestion_date))

print("Added metadata columns:")
print(f"  - feed_id: {feed_id}")
print(f"  - feed_version: {feed_version}")
print(f"  - ingestion_id: {ingestion_id}")
print(f"  - ingestion_timestamp: {ingestion_timestamp}")
print(f"  - ucloud_ingestion_date: {ucloud_ingestion_date}")

# COMMAND ----------

# MAGIC %md
# MAGIC ## Step 7: Drop Duplicates (if configured)

# COMMAND ----------

# Drop duplicates if configured
if is_drop_duplicate:
    row_count_before = df_final.count()
    # Use system_record_id as primary key if available, otherwise use all columns
    if "system_record_id" in df_final.columns:
        df_final = df_final.dropDuplicates(["system_record_id"])
    else:
        df_final = df_final.dropDuplicates()
    row_count_after = df_final.count()
    print(f"Dropped {row_count_before - row_count_after} duplicate rows")
else:
    print("Skipping duplicate removal (is_drop_duplicate = N)")

# COMMAND ----------

# MAGIC %md
# MAGIC ## Step 8: Data Type Conversions and Cleanup

# COMMAND ----------

# Clean up string columns (trim whitespace, handle nulls)
string_cols = [field.name for field in df_final.schema.fields if field.dataType == StringType()]

for col_name in string_cols:
    df_final = df_final.withColumn(
        col_name,
        when(col(col_name).isNull(), lit(None))
        .otherwise(trim(col(col_name)))
    )

# Replace empty strings with null
for col_name in string_cols:
    df_final = df_final.withColumn(
        col_name,
        when((col(col_name) == "") | (col(col_name).isNull()), lit(None))
        .otherwise(col(col_name))
    )

print("Applied data cleanup (trim, null handling)")

# COMMAND ----------

# MAGIC %md
# MAGIC ## Step 9: Write to Parquet in Staging S3

# COMMAND ----------

# Generate output path with run_date
output_path = f"{s3_output_path.rstrip('/')}/{pipeline_name}/"
print(f"Writing Parquet to: {output_path}")

# Write to Parquet
df_final.write \
    .mode("overwrite") \
    .option("compression", "snappy") \
    .parquet(output_path)

print(f"Successfully wrote {df_final.count()} rows to Parquet format")
print(f"Output location: {output_path}")

# COMMAND ----------

# MAGIC %md
# MAGIC ## Step 10: Verify Output

# COMMAND ----------

# Verify the output by reading it back
df_verify = spark.read.parquet(output_path)
print(f"Verification - Rows in output: {df_verify.count()}")
print(f"Verification - Columns in output: {len(df_verify.columns)}")
print("\nSample data:")
df_verify.show(5, truncate=False)

# COMMAND ----------

# MAGIC %md
# MAGIC ## Summary

# COMMAND ----------

print("=" * 80)
print("CSV to Parquet Conversion Complete!")
print("=" * 80)
print(f"Input CSV: {s3_input_path}")
print(f"Output Parquet: {output_path}")
print(f"Total Rows Processed: {df_final.count()}")
print(f"Total Columns: {len(df_final.columns)}")
print("=" * 80)

