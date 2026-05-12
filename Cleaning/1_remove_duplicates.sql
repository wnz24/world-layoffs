-- ============================================================
-- STEP 1: SETUP — Create staging tables from raw data
-- ============================================================

-- Preview raw data
SELECT *
FROM layoffs;

-- Create first staging table (same structure as original)
CREATE TABLE layoffs_staging1
LIKE layoffs;

-- Confirm structure
SELECT *
FROM layoffs_staging1;

-- Copy all data into staging table
INSERT INTO layoffs_staging1
SELECT *
FROM layoffs;


-- ============================================================
-- STEP 2: REMOVE DUPLICATES
-- ============================================================

-- Find duplicates using ROW_NUMBER()
WITH duplicate_find AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY company, location, industry,
                         total_laid_off, percentage_laid_off,
                         `date`, stage, country, funds_raised_millions
        ) AS row_num
    FROM layoffs_staging1
)
SELECT *
FROM duplicate_find
WHERE row_num > 1;

-- Spot check a specific company
SELECT *
FROM layoffs_staging1
WHERE company = 'Casper';

-- Create final staging table with row_num column
CREATE TABLE `layoffs_staging_f` (
    `company`               TEXT,
    `location`              TEXT,
    `industry`              TEXT,
    `total_laid_off`        INT DEFAULT NULL,
    `percentage_laid_off`   TEXT,
    `date`                  TEXT,
    `stage`                 TEXT,
    `country`               TEXT,
    `funds_raised_millions` INT DEFAULT NULL,
    `row_num`               INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insert data with row numbers
INSERT INTO layoffs_staging_f
SELECT *,
    ROW_NUMBER() OVER (
        PARTITION BY company, location, industry,
                     total_laid_off, percentage_laid_off,
                     `date`, stage, country, funds_raised_millions
    ) AS row_num
FROM layoffs_staging1;

-- Confirm duplicates found
SELECT *
FROM layoffs_staging_f
WHERE row_num > 1;

-- Delete duplicates
SET SQL_SAFE_UPDATES = 0;
DELETE FROM layoffs_staging_f
WHERE row_num > 1;
SET SQL_SAFE_UPDATES = 1;

-- Confirm duplicates removed
SELECT *
FROM layoffs_staging_f;
