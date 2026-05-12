
SELECT *
FROM layoffs;

-- first remove duplicates
-- standerdize the data
-- look for null or blank values
-- remove any columns and rows that are not neccessary


CREATE TABLE layoffs_staging1
LIKE layoffs;

SELECT *
FROM layoffs_staging1;

INSERT layoffs_staging1
SELECT *
FROM layoffs;


-- Removing Duplicates
SELECT *
FROM layoffs_staging1;


WITH duplicate_find AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY  company, location, industry,total_laid_off,percentage_laid_off,
`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging1
)
SELECT * 
FROM duplicate_find
WHERE row_num >1;
;

SELECT *
FROM layoffs_staging1
WHERE company= 'Casper';



CREATE TABLE `layoffs_staging_f` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging_f;

INSERT INTO layoffs_staging_f
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY  company, location, industry,total_laid_off,percentage_laid_off,
`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging1;

SELECT *
FROM layoffs_staging_f
WHERE row_num > 1;
;
-- Turn off safe mode
SET SQL_SAFE_UPDATES = 0;

DELETE 
FROM layoffs_staging_f
WHERE row_num >1;
;
SET SQL_SAFE_UPDATES = 1;




-- STANDARDIZING DATA --
SELECT *
FROM layoffs_staging_f;

SELECT company, TRIM(company)
FROM layoffs_staging_f;

SET SQL_SAFE_UPDATES = 0;
UPDATE layoffs_staging_f
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging_f
ORDER BY 1
;
SELECT * 
FROM layoffs_staging_f
WHERE industry
LIKE 'Crypto%';

SET SQL_SAFE_UPDATES = 0;

UPDATE layoffs_staging_f
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';



SELECT DISTINCT location
FROM layoffs_staging_f
ORDER BY 1
;

SELECT DISTINCT country
FROM layoffs_staging_f
ORDER BY 1
;

SELECT * 
FROM layoffs_staging_f
WHERE TRIM(country) = 'United States.';

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging_f
ORDER BY 1;

SET SQL_SAFE_UPDATES = 0;
UPDATE layoffs_staging_f
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT DISTINCT country
FROM layoffs_staging_f
ORDER BY 1
;

SELECT `date`,
str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_staging_f
;

SET SQL_SAFE_UPDATES = 0;

UPDATE layoffs_staging_f
SET `date` = str_to_date(`date`, '%m/%d/%Y')
;

ALTER TABLE layoffs_staging_f
MODIFY COLUMN `date` DATE;

SELECT * FROM layoffs_staging_f;


-- NULLS AND BLANKS --


SELECT *
FROM layoffs_staging_f
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL OR ' ';

SELECT DISTINCT industry
FROM layoffs_staging_f
ORDER BY industry;

SELECT *
FROM layoffs_staging_f
WHERE industry IS NULL
OR industry = ''
;

SELECT *
FROM layoffs_staging_f
WHERE company LIKE 'Bally%';


SET SQL_SAFE_UPDATES = 0;

UPDATE layoffs_staging_f
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoffs_staging_f T1
JOIN layoffs_staging_f T2
	ON T1.company = T2.company
	AND T1.location = T2.location
WHERE (T1.industry IS NULL)
AND T2.industry IS NOT NULL;


SET SQL_SAFE_UPDATES = 0;

UPDATE layoffs_staging_f T1
JOIN layoffs_staging_f T2
    ON T1.company = T2.company         --  Match same company
    AND T1.location = T2.location      --  Match same location
SET T1.industry = T2.industry
WHERE (T1.industry IS NULL OR T1.industry = '')
AND T2.industry IS NOT NULL;


SELECT *
FROM layoffs_staging_f
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL OR ' ';

DELETE 
FROM layoffs_staging_f
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging_f;

ALTER TABLE layoffs_staging_f
DROP COLUMN row_num;

