-- Quick look at the full dataset
SELECT *
FROM layoffs_staging_f;

-- Companies that shut down completely, sorted by size of layoff
SELECT * 
FROM layoffs_staging_f
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- Same but which ones had the most funding before going under
SELECT * 
FROM layoffs_staging_f
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Total layoffs per company
SELECT company, SUM(total_laid_off)
FROM layoffs_staging_f
GROUP BY company
ORDER BY 2 DESC;

-- How far back does this data go?
SELECT MIN(`date`) , MAX(`date`)
FROM layoffs_staging_f;

-- Which industries were hit the hardest
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging_f
GROUP BY industry
ORDER BY 2 DESC;

-- Layoffs by country
SELECT country, SUM(total_laid_off)
FROM layoffs_staging_f
GROUP BY country
ORDER BY 2 DESC;

-- Which year had the most layoffs
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging_f
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- Layoffs by company funding stage
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging_f
GROUP BY stage
ORDER BY 2 DESC;

-- Monthly layoff totals
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging_f
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

-- Rolling total to see how layoffs accumulated over time
WITH rolling_total AS(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS tlo
FROM layoffs_staging_f
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, tlo, SUM(tlo)
OVER(ORDER BY `MONTH`) AS rolling_total
FROM rolling_total;

-- Layoffs per company broken down by year
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging_f
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- Top 5 companies with most layoffs each year
WITH company_year AS ( 
SELECT company, YEAR(`date`) Years, SUM(total_laid_off) total_laid_off
FROM layoffs_staging_f
GROUP BY company, YEAR(`date`)
),company_year_rank AS (
SELECT *,
DENSE_RANK() OVER(PARTITION BY Years ORDER BY total_laid_off DESC) AS ranking
FROM company_year
WHERE Years IS NOT NULL
)
SELECT *
FROM company_year_rank
WHERE ranking <= 5;

-- Top 10 industries with most layoffs each year
WITH industry_year AS ( 
SELECT industry, YEAR(`date`) Years, SUM(total_laid_off) total_laid_off
FROM layoffs_staging_f
GROUP BY industry, YEAR(`date`)
),industry_year_rank AS (
SELECT *,
DENSE_RANK() OVER(PARTITION BY Years ORDER BY total_laid_off DESC) AS ranking
FROM industry_year
WHERE Years IS NOT NULL
)
SELECT *
FROM industry_year_rank
WHERE ranking <= 10;

-- Top 10 stages with most layoffs each year
WITH stage_year AS ( 
SELECT stage, YEAR(`date`) Years, SUM(total_laid_off) total_laid_off
FROM layoffs_staging_f
GROUP BY stage, YEAR(`date`)
),stage_year_rank AS (
SELECT *,
DENSE_RANK() OVER(PARTITION BY Years ORDER BY total_laid_off DESC) AS ranking
FROM stage_year
WHERE Years IS NOT NULL
)
SELECT *
FROM stage_year_rank
WHERE ranking <= 10
ORDER BY Years, ranking;

-- Checking if higher funding meant more layoffs
SELECT company, total_laid_off, funds_raised_millions
FROM layoffs_staging_f
WHERE funds_raised_millions IS NOT NULL
GROUP BY company, funds_raised_millions, total_laid_off
ORDER BY funds_raised_millions DESC;