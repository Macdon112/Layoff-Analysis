-- Exploratory Data Analysis


select *
from layoffs_staging2;

-- the max layoff by percentage

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

-- sum of total layoff by companies
select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

-- MinMax of layoff by Date
select min(`date`), max(`date`)
from layoffs_staging2;

-- industry that layoff 

 -- total_laid_off by industry
select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

select *
from layoffs_staging2;

 -- sum of total_laid_off by countries
select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

-- laid_off by date
select `date`, sum(total_laid_off)
from layoffs_staging2
group by `date`
order by 1 desc;

-- sum of total_laid_off by Year
select YEAR(`date`), sum(total_laid_off)
from layoffs_staging2
group by YEAR(`date`) 
order by 1 desc;

-- Stage of total_laid_off 
select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;


-- rolling sum of the laid off, 

select substring(`date`,1,7) AS `MONTH`, sum(total_laid_off)
from layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
group by `MONTH`
ORDER BY 1 ASC;

-- total sum of the Laid_off using CTE
WITH Rolling_Total AS
(
select substring(`date`,1,7) AS `MONTH`, sum(total_laid_off) AS total_off
from layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
group by `MONTH`
ORDER BY 1 ASC
)
select `MONTH`, total_off
,sum(total_off) over(order by `MONTH`) as rolling_total
from Rolling_Total;

-- check lay_off of companies per year

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

-- checking total_laid_off by company by year
select company, YEAR(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, YEAR(`date`)
order by 3 desc;


-- Ranking the total_laid_off from company yearly

WITH Company_Year  (company, years, total_laid_off) AS
(
select company, YEAR(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, YEAR(`date`)
), Company_Year_Rank AS
(select*, 
dense_rank() over(partition by years order by total_laid_off desc) as Ranking
from Company_Year
where years is not NULL
)
select*
from Company_Year_Rank
where ranking <= 5
;
