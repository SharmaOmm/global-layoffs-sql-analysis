-- ===============================================================
-- Exploratory Data Analysis (EDA)
-- Dataset: World Layoffs
-- Purpose: Identify patterns, concentration, and trends in layoffs
-- ================================================================

-- -----------------------------------------------------
-- 1. Identifying Companies That Fully Shut Down
-- -----------------------------------------------------

select * from layoffs_staging2
where percentage_laid_off = 1;

-- ------------------------------------------------
-- 2. Total layoffs analysis over different aspects
-- ------------------------------------------------

-- 2.a. Country-wise total layoffs
select country, sum(total_laid_off) as layoffs 
from layoffs_staging2
group by country
order by layoffs desc;

-- 2.b. Industry-wise total layoffs
select industry, sum(total_laid_off) as layoffs 
from layoffs_staging2
group by industry
order by layoffs desc;

-- ---------------------------------------
-- 3. Rolling Total of Layoffs over months
-- ---------------------------------------

select month,
sum(monthly_layoffs) over (order by month) as rolling_total_layoffs
from (
	select substring(`date`, 1, 7) as month,
    sum(total_laid_off) as monthly_layoffs
    from layoffs_staging2
    group by month) as t
order by month;

-- -------------------------------------------------
-- 4. Layoff Concentration: Top 10 companies Vs Rest
-- -------------------------------------------------

-- 4.a. Data of Top 10 Companies by total layoffs
select company, sum(total_laid_off) as layoffs
from layoffs_staging2
group by company 
order by layoffs desc 
limit 10;

-- 4.b. Total number of companies in this dataset
select count(distinct company) as number_of_companies
from layoffs_staging2;

-- 4.c. Comparison between the cumulative layoff of Top 10 companies Vs Rest
with top_10 as (
select company, sum(total_laid_off) as layoffs
from layoffs_staging2
group by company
order by layoffs desc
limit 10)
select 
	case
		when company in (select company from top_10)
			then 'Top 10 Companies'
        else 'All Other Companies'
        end as company_group,
        sum(total_laid_off) as layoffs 
        from layoffs_staging2
        group by company_group
        order by layoffs desc;
        
-- ------------------------------------------------------
-- 5.Layoff Intensity vs Frequency (Company Level)
-- Frequency: Number of layoff events occured per company
-- Intensity: Average employees laid off per event
-- ------------------------------------------------------

select
    company,
    count(*) as layoff_frequency,
    sum(total_laid_off) as total_layoffs,
    round(avg(total_laid_off), 2) as avg_layoff_intensity
from layoffs_staging2
where total_laid_off is not null
group by company
order by layoff_frequency desc;

-- End of EDA
-- Refer to KEY_FINDINGS.md for insights and conclusions

