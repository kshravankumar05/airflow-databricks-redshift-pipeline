-- ============================================================================
-- Verification Script for CDC Columns in Redshift Temp Table
-- Portfolio/Demo Version - Generic schema names
-- Run this in Redshift to verify CDC columns are present and correct
-- ============================================================================

-- ============================================================================
-- Query 1: Check if CDC columns exist in temp table
-- ============================================================================
SELECT 
    column_name,
    data_type,
    character_maximum_length,
    is_nullable,
    ordinal_position
FROM information_schema.columns 
WHERE table_schema = 'change_management' 
  AND table_name = 'servicenow_change_request_temp'
  AND column_name IN ('_change_type', '_commit_version', '_commit_timestamp')
ORDER BY ordinal_position;

-- Expected Result:
-- _change_type | VARCHAR | 50 | YES | 96
-- _commit_version | BIGINT | NULL | YES | 97
-- _commit_timestamp | TIMESTAMP WITHOUT TIME ZONE | NULL | YES | 98

-- ============================================================================
-- Query 2: Verify all columns in temp table (should have 98 columns total)
-- ============================================================================
SELECT 
    COUNT(*) as total_columns,
    COUNT(CASE WHEN column_name = '_change_type' THEN 1 END) as has_change_type,
    COUNT(CASE WHEN column_name = '_commit_version' THEN 1 END) as has_commit_version,
    COUNT(CASE WHEN column_name = '_commit_timestamp' THEN 1 END) as has_commit_timestamp
FROM information_schema.columns 
WHERE table_schema = 'change_management' 
  AND table_name = 'servicenow_change_request_temp';

-- Expected Result:
-- total_columns: 98
-- has_change_type: 1
-- has_commit_version: 1
-- has_commit_timestamp: 1

-- ============================================================================
-- Query 3: Check data types of CDC columns
-- ============================================================================
SELECT 
    column_name,
    data_type,
    CASE 
        WHEN column_name = '_change_type' AND data_type = 'character varying' THEN '✅ CORRECT'
        WHEN column_name = '_commit_version' AND data_type = 'bigint' THEN '✅ CORRECT'
        WHEN column_name = '_commit_timestamp' AND data_type LIKE '%timestamp%' THEN '✅ CORRECT'
        ELSE '❌ WRONG - Expected different type'
    END as status
FROM information_schema.columns 
WHERE table_schema = 'change_management' 
  AND table_name = 'servicenow_change_request_temp'
  AND column_name IN ('_change_type', '_commit_version', '_commit_timestamp')
ORDER BY ordinal_position;

-- ============================================================================
-- Query 4: Compare column counts between main and temp table
-- ============================================================================
SELECT 
    'Main Table' as table_type,
    COUNT(*) as column_count
FROM information_schema.columns 
WHERE table_schema = 'change_management' 
  AND table_name = 'servicenow_change_request'
UNION ALL
SELECT 
    'Temp Table' as table_type,
    COUNT(*) as column_count
FROM information_schema.columns 
WHERE table_schema = 'change_management' 
  AND table_name = 'servicenow_change_request_temp';

-- Expected Result:
-- Main Table: 95 columns
-- Temp Table: 98 columns (95 + 3 CDC columns)

-- ============================================================================
-- Query 5: Verify CDC columns are at the end of temp table
-- ============================================================================
SELECT 
    column_name,
    ordinal_position
FROM information_schema.columns 
WHERE table_schema = 'change_management' 
  AND table_name = 'servicenow_change_request_temp'
ORDER BY ordinal_position DESC
LIMIT 5;

-- Expected Result (last 5 columns):
-- ingestion_timestamp | 95
-- _change_type | 96
-- _commit_version | 97
-- _commit_timestamp | 98

-- ============================================================================
-- Query 6: Check if request_risk_value is INTEGER (not VARCHAR)
-- ============================================================================
SELECT 
    column_name,
    data_type,
    CASE 
        WHEN column_name = 'request_risk_value' AND data_type = 'integer' THEN '✅ CORRECT - INTEGER'
        WHEN column_name = 'request_risk_value' AND data_type = 'character varying' THEN '❌ WRONG - Should be INTEGER'
        ELSE 'N/A'
    END as status
FROM information_schema.columns 
WHERE table_schema = 'change_management' 
  AND table_name IN ('servicenow_change_request', 'servicenow_change_request_temp')
  AND column_name = 'request_risk_value';

-- Expected Result:
-- request_risk_value | integer | ✅ CORRECT - INTEGER

