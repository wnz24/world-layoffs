-- ============================================================
-- STEP 3: STANDARDIZE DATA
-- ============================================================

-- Preview current state
SELECT *
FROM layoffs_staging_f;


-- ── Company ────────────────────────────────────────────────

-- Check for leading/trailing whitespace
SELECT company, TRIM(company)
FROM layoffs_staging_f;

-- Remove whitespace from company names
SET SQL_SAFE_UPDATES = 0;
UPDATE layoffs_staging_f
SET company = TRIM(company);


-- ── Industry ───────────────────────────────────────────────

-- Check distinct industries for inconsistencies
SELECT DISTINCT industry
FROM layoffs_staging_f
ORDER BY 1;

-- Spot check Crypto variations
SELECT *
FROM layoffs_staging_f
WHERE industry LIKE 'Crypto%';

-- Unify all Crypto variants → 'Crypto'
SET SQL_SAFE_UPDATES = 0;
UPDATE layoffs_staging_f
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


-- ── Location & Country ─────────────────────────────────────

-- Check distinct locations
SELECT DISTINCT location
FROM layoffs_staging_f
ORDER BY 1;

-- Check distinct countries for trailing punctuation
SELECT DISTINCT country
FROM layoffs_staging_f
ORDER BY 1;

-- Spot check "United States."
SELECT *
FROM layoffs_staging_f
WHERE TRIM(country) = 'United States.';

-- Preview the fix
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging_f
ORDER BY 1;

-- Remove trailing period from country names
SET SQL_SAFE_UPDATES = 0;
UPDATE layoffs_staging_f
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Confirm fix
SELECT DISTINCT country
FROM layoffs_staging_f
ORDER BY 1;


-- ── Date Format ────────────────────────────────────────────

-- Preview date conversion from text to DATE
SELECT `date`,
       STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging_f;

-- Convert date column from text to proper DATE format
SET SQL_SAFE_UPDATES = 0;
UPDATE layoffs_staging_f
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Change column type to DATE
ALTER TABLE layoffs_staging_f
MODIFY COLUMN `date` DATE;

-- Confirm final state
SELECT *
FROM layoffs_staging_f;
