-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

-- Looking at Percentage to see how big these layoffs were
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;  

-- Which companies had 1 which is basically 100 percent of they company laid off
-- if we order by funcs_raised_millions we can see how big some of these companies were
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Companies with the biggest single Layoff
SELECT company, total_laid_off
FROM layoffs_staging2
ORDER BY 2 DESC;

-- Companies with the most Total Layoffs
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Lets check date 
SELECT MIN(`date`), Max(`date`)
FROM layoffs_staging2;

-- lets look at data by industry
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- lets have a look at data by country
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Lets break it down by Year 
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- Lets see by stage as well to see if we find something insightful
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 1 DESC;

-- Percenatge_laid_off is of not much ue as we dot have the number of people that got laid off

-- Progression of layoff or Rolling sum
SELECT substring(`date`,1,7) AS `Month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC;	


WITH Rolling_Total AS
(
SELECT substring(`date`,1,7) AS `Month`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,
 SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

-- Lets take a look at companies laying off per year
SELECT company,`date`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, `date`
ORDER BY 3 DESC;

WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;
;












