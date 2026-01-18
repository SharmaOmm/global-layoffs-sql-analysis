-- ==================================================
-- Data Cleaning
-- Dataset: World Layoffs
-- Goal: Clean raw data for accurate analysis and EDA
-- ===================================================

-- ----------------
-- 0. Initial Setup
-- ----------------

-- 0.a. Creating a database
create database world_layoffs;
use world_layoffs;

-- 0.b. Imported dataset in a table (layoffs)
select * from layoffs;

-- 0.c. Create Staging Table (Preserve Raw Data)
create table layoffs_staging
like layoffs;

insert layoffs_staging
select * from layoffs;

-- ---------------------------
-- 1. Remove Duplicate Records
-- ---------------------------

-- Using ROW_NUMBER() over all identifying columns
select *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, stage, country, funds_raised, `date`) as row_num
from layoffs_staging;

-- Identifying Duplicates
with dup_cte as
(select *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, stage, country, funds_raised, `date`) as row_num
from layoffs_staging
)
select * from dup_cte
where row_num>1;

-- Identified duplicate entries for the company Cars24
select * from layoffs 
where company = 'Cars24';

-- Creating a second staging table to safely remove duplicates
-- (CTEs cannot be used directly for DELETE operations)
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `total_laid_off` text,
  `date` text,
  `percentage_laid_off` text,
  `industry` text,
  `source` text,
  `stage` text,
  `funds_raised` int DEFAULT NULL,
  `country` text,
  `date_added` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into layoffs_staging2
select *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, stage, country, funds_raised, `date`) as row_num
from layoffs_staging;

-- Disabling safe updates to allow DELETE operation
SET SQL_SAFE_UPDATES = 0;

-- Removing duplicate rows
delete from layoffs_staging2
where row_num >1;

-- ======================
-- 2. Standardizing Data
-- ======================

-- Trimming whitespace from company and location names
update layoffs_staging2
set company = trim(company);

update layoffs_staging2
set location = trim(location);

-- Checking if there are any inconsistencies in naming countries and locations
select distinct location from layoffs_staging2
order by 1;

select distinct country from layoffs_staging2
order by 1;

-- --------------------
-- Date Standardization
-- --------------------

select date,
str_to_date(`date`, '%m/%d/%Y') 
from layoffs_staging2;

-- Formatting date to YYYY-MM-DD
update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

-- Typecasting datatype of date from text to date
alter table layoffs_staging2
modify column `date` date;

-- =================================
-- 3. Handling NULL and Blank Values
-- =================================

select * from layoffs_staging2
where total_laid_off is null or total_laid_off = '';

-- converting blanks to null
update layoffs_staging2
set total_laid_off = null
where total_laid_off = '';

update layoffs_staging2
set percentage_laid_off = null
where percentage_laid_off= '';

update layoffs_staging2 
set industry = null where
industry = '';

-- Identifying rows with no meaningful layoff data
select * from layoffs_staging2
where total_laid_off is null and
percentage_laid_off is null;

-- Removing rows without layoff records
delete from layoffs_staging2
where total_laid_off is null or
percentage_laid_off is null;

-- ====================
-- 4. Column Reordering
-- ====================

alter table layoffs_staging2
modify column percentage_laid_off text after total_laid_off;

alter table layoffs_staging2
modify column country text after company;

-- ==========================================
-- 5. Removing Irrelevant Columns
-- Dropping columns not required for analysis
-- ==========================================

alter table layoffs_staging2
drop column date_added;

alter table layoffs_staging2
drop column source;

alter table layoffs_staging2
drop column row_num;

-- End of Data Cleaning 
-- EDA on layoffs_staging2 table can be found on the following file
















