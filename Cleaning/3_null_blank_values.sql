-- ============================================================
-- STEP 4: HANDLE NULL AND BLANK VALUES
-- ============================================================


-- ── Industry Column ────────────────────────────────────────

-- Check distinct industries (look for NULLs / blanks)
SELECT DISTINCT industry
FROM layoffs_staging_f
ORDER BY industry;

-- Find rows where industry is NULL or blank
SELECT *
FROM layoffs_staging_f
WHERE industry IS NULL
   OR industry = '';

-- Spot check a specific company
SELECT *
FROM layoffs_staging_f
WHERE company LIKE 'Bally%';

-- Convert empty strings to NULL (for consistent handling)
SET SQL_SAFE_UPDATES = 0;
UPDATE layoffs_staging_f
SET industry = NULL
WHERE industry = '';

-- Find rows that can be filled using another row from same company
SELECT *
FROM layoffs_staging_f T1
JOIN layoffs_staging_f T2
    ON  T1.company  = T2.company
    AND T1.location = T2.location
WHERE T1.industry IS NULL
  AND T2.industry IS NOT NULL;

-- Populate missing industry values via self-join
SET SQL_SAFE_UPDATES = 0;
UPDATE layoffs_staging_f T1
JOIN layoffs_staging_f T2
    ON  T1.company  = T2.company
    AND T1.location = T2.location
SET T1.industry = T2.industry
WHERE T1.industry IS NULL
  AND T2.industry IS NOT NULL;


-- ── Total / Percentage Laid Off ────────────────────────────

-- Find rows where both key metrics are NULL (no useful data)
SELECT *
FROM layoffs_staging_f
WHERE total_laid_off      IS NULL
  AND percentage_laid_off IS NULL;

-- Delete rows with no layoff data at all
SET SQL_SAFE_UPDATES = 0;
DELETE FROM layoffs_staging_f
WHERE total_laid_off      IS NULL
  AND percentage_laid_off IS NULL;
SET SQL_SAFE_UPDATES = 1;

-- Confirm result
SELECT *
FROM layoffs_staging_f;
