# Global Layoffs – SQL Analysis

## Project Overview
This project analyzes global layoff data using SQL to uncover patterns, concentration, and trends across companies, industries, and countries.

## How to Navigate This Repository
Start with this README for project context, explore the SQL scripts for implementation details, and refer to KEY_FINDINGS.md for summarized insights.
The focus of this project is analytical depth rather than visualization.

## Dataset: 
- Global layoffs dataset covering multiple industries and countries
- Includes company, industry, country, layoff count, and dates

## Tools Used
- MySQL
- SQL (Window Functions, CTEs, Aggregations)

## Project Structure
README.md
sql/
 ├── 01_Data_Cleaning.sql
 └── 02_Eda.sql
KEY_FINDINGS.md

## Analysis Highlights
- Identified duplicate records and standardized raw data
- Analyzed layoffs by country and industry
- Tracked rolling monthly layoffs to identify layoff waves
- Compared top 10 companies vs rest to study concentration
- Evaluated layoff frequency vs intensity at company level

## Key Insights
Refer to [KEY_FINDINGS.md](KEY_FINDINGS.md) for summarized insights.
