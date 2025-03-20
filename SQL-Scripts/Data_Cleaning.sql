-- Data cleaning 

select*
from layoffs;

-- Processes to follow
-- 1. Remove Duplicates
-- 2. Standardise the data
-- 3. Null Values or blank values
-- 4. Remove any columns not required

-- let us create a staging table like the raw dataset table for our cleaning so that if we make a mistake we still have the raw database

create table layoffs_staging
like layoffs;

select *
from layoffs_staging;

insert layoffs_staging
select*
from layoffs;

select *
from layoffs_staging;

 -- remove duplicates
 select*,
 row_number() over(
 partition by company, 
 industry, 
 total_laid_off, 
 percentage_laid_off, 
 `date`) as row_num
 from layoffs_staging;

-- filter whether the row_num is greater than 2 and anyone  greater than 2 is a duplicate, we will create a cte for it


with duplicate_cte as
(
 select*,
 row_number() over(
 partition by company, 
 location, 
 industry, 
 total_laid_off, 
 percentage_laid_off, 
 `date`, 
 stage, 
 country, 
 funds_raised_millions) as row_num
 from layoffs_staging
)
select *
from duplicate_cte
where row_num > 1;

-- let us confirm duplicate using one of the company 

select *
from layoffs_staging
where company = 'Casper';

-- Deleting the duplicates. we will delete where the row_num is > 1

with duplicate_cte as
(
 select*,
 row_number() over(
 partition by company, location, 
 industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
 from layoffs_staging
)
Delete
from duplicate_cte
where row_num > 1;
 -- the above will not be able to delete the row_num > 1, so we have to create staging2 database
 
 select*,
 row_number() over(
 partition by company, location, 
 industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
 from layoffs_staging;
 
 
 CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
 `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

 
 select*
 from layoffs_staging2;
 
 insert layoffs_staging2
select*,
 row_number() over(
 partition by company, location, 
 industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
 from layoffs_staging;
 
  select*
 from layoffs_staging2
 where row_num >1;
 
  delete
 from layoffs_staging2
 where row_num >1;

 select*
 from layoffs_staging2;
 
 -- standardizing data
 
 select company, (trim(company))
 from layoffs_staging2;
 
 update layoffs_staging2
 set company = trim(company);
 
 -- let us work on the industry column
 
 select distinct industry
 from layoffs_staging2
 order by 1;
 
 -- going through you will find that we have crypto and cryptocurrency in the industry column which might 
 -- be the same. we have to double check very well before standardizing it 
 
 select *
 from layoffs_staging2
 where industry like 'crypto%';
 
 -- let us update the name all to crypto instead of having crypto and cryptocurrency
 
 update layoffs_staging2
 set industry = 'crypto'
 where industry like 'crypto%';
 
select *
from layoffs_staging2
where industry = 'crypto';

  select *
 from layoffs_staging2
 where industry like 'crypto%';
 
 select distinct industry
 from layoffs_staging2
 order by 1;
 
 -- let us check location
 
 select distinct location
from layoffs_staging2
order by 1;
 
 -- check the country 
  select distinct country
from layoffs_staging2
order by 1;
-- united states have some issue as there is a full stop in some of it and we have to remove it

  select distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United States%';

-- if we intent to run a time series we need to change the data from text to date field 

select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');
 
 select `date`
from layoffs_staging2;

-- check for null values
SELECT COUNT(*) AS NullCount
FROM layoffs_staging2
WHERE `date` IS NULL;

-- check for empty string
SELECT COUNT(*) AS EmptyStringCount
FROM layoffs_staging2
WHERE `date` = '';


-- modify the date column from text to date format

alter table layoffs_staging2
modify column `date` DATE;

select *
from layoffs_staging2;

-- step 3 Null Values or blank values
select *
from layoffs_staging2;

select *
from layoffs_staging2
where total_laid_off is NULL
and percentage_laid_off is NULL;

update layoffs_staging2
set industry = NULL 
where industry = '';


select company, location
from layoffs_staging2
where company = 'Juul';

select *
from layoffs_staging2
where industry is NULL
or industry ='';

select *
from layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company = t2.company
and t2.location = t2.location
where (t1.industry is NULL or t1.industry = '')
and t2.industry is not NULL;


update layoffs_staging2 t1
	join layoffs_staging2 t2
	on t1.company = t2.company
	set t1.industry = t2.industry
where t1.industry is NULL 
and t2.industry is not NULL;

select *
from layoffs_staging2
where company = 'Airbnb';

select *
from layoffs_staging2
where company like 'Bally%';

select *
from layoffs_staging2;


select *
from layoffs_staging2
where total_laid_off is NULL
and percentage_laid_off is NULL;

delete
from layoffs_staging2
where total_laid_off is NULL
and percentage_laid_off is NULL;


select *
from layoffs_staging2;

Alter table layoffs_staging2
drop column row_num;
