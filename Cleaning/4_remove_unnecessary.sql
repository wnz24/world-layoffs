-- ============================================================
-- STEP 5: REMOVE UNNECESSARY COLUMNS
-- ============================================================

-- Drop the helper column used during deduplication
ALTER TABLE layoffs_staging_f
DROP COLUMN row_num;

-- Final clean dataset — ready for analysis
SELECT *
FROM layoffs_staging_f;
