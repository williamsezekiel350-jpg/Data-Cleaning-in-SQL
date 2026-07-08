#Data Cleaning


select *
from layoffs;

#Remove Duplicates
#Standardize
#Null or Blank Values
#Remove Any columns or Rows


CREATE TABLE layoffs_staging
LIKE layoffs;

select *
from layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

select *
from layoffs_staging;

select *,
row_number () over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`,stage, country, funds_raised_millions) as row_num
from layoffs_staging;
with duplicate_cte as
(select *,
row_number () over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`,stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
select *
from duplicate_cte
where row_num > 1;

select *
from layoffs_staging
where company ='Casper';

with duplicate_cte as
(
select *,
row_number () over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`,stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
delete
from duplicate_cte
where row_num > 1;

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

select *
from layoffs_staging2
where row_num = 2;

INSERT INTO layoffs_staging2
select *,
row_number () over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`,stage, country, funds_raised_millions) as row_num
from layoffs_staging;



SET SQL_SAFE_UPDATES = 0;

delete
from layoffs_staging2
where row_num > 1;

select *
from layoffs_staging2
where row_num > 1;

SET SQL_SAFE_UPDATES = 1;

select *
from layoffs_staging2;

#STANDARDIZE DATA
select company, TRIM(company)
from layoffs_staging2;

SET SQL_SAFE_UPDATES = 0;
UPDATE layoffs_staging2
SET company = TRIM(company);



select *
from layoffs_staging2
where industry like 'Crypto%';

select distinct location
from layoffs_staging2;

select distinct country
from layoffs_staging2
order by 1;

select distinct country, TRIM(TRAILING '.' FROM country)
from layoffs_staging2
order by 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
where country like 'United States%';

select `date`
from layoffs_staging2;

update layoffs_staging2
set`date` = str_to_date(`date`, '%m/%d/%Y');

alter table layoffs_staging2
modify column `date` date;

select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

select *
from layoffs_staging2
where industry is null
or industry = '';

select *
from layoffs_staging2
where company = 'Airbnb';

select *
from layoffs_staging2 t1
join layoffs_staging2 t2
        on t1.company = t2.company
        and t1.location = t2.location
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;


select t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
        on t1.company = t2.company
        and t1.location = t2.location
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

update layoffs_staging2 t1
join layoffs_staging2 t2
    on t1.company = t2.company
set t1.industry = t2.industry
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

update layoffs_staging2
set industry = null
where industry ='';

select *
from layoffs_staging2;

select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

select *
from layoffs_staging2;

alter table layoffs_staging2
drop column row_num;
