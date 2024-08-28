# NVIDIA-AMD-Intel-Stock-Analysis

### Project Overview

This project analyzes stock data for NVIDIA, AMD, and Intel from May 2020 to May 2024. Using SQL, the data was cleaned, standardized, and joined to enable a detailed comparative analysis of trends and volatility across the three companies. The results are presented in an interactive Tableau dashboard, which features embedded navigation links for easy access to each company's specific visualizations. These include candlestick charts, positive/negative percentage change bar charts, and volume-over-time line charts, all equipped with customizable time filters. This tool provides valuable insights for investors and analysts looking to compare stock performance and make informed decisions.

### Data Sources

The data sets used for this analysis is:<br>
NVIDIA - https://www.kaggle.com/datasets/amirhoseinmousavian/nvidia-corporation-nvda-stock-price<br>
AMD/ Intel - https://www.kaggle.com/datasets/ranatalha71/weekly-historical-stock-data-for-intel-and-amd<br>
S&P 500 - https://www.kaggle.com/datasets/arashnic/time-series-forecasting-with-yahoo-stock-price<br>

### Tools

- MySQL - Data cleaning and analysis
- Tableau - Data visualization


### Data Cleaning

In the initial data preparation phase, I performed the following in SQL:

1. Removed Duplicates
2. Standardized the Data
3. Organized Null and Blank Values
4. Removed Unnecessary Columns
5. Joined the Data sets on Date
6. EDA, Trend Analysis, Volatility Analysis
8. Comparitive Analysis of the three stocks using the S&P 500 as a baseline for the stock market

### Data Analysis

Involved exploring the layoffs data to answer key questions, such as:

- What companies contributed the most to that layoff count and how much did they layoff?
- What are the countries and cities with the most layoffs?
- Which industries had the most layoffs?
- Which month had the most layoffs?

Some interesting code I worked with:

Found the sum of each company's total layoffs in descending order by layoffs

```sql
WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;
```

### Results/ Findings

SQL - https://shorturl.at/apPWl

Tableau Dashboards - 

![Screenshot 2024-07-15 231126](https://github.com/user-attachments/assets/106da0fb-5984-49c5-860d-1d08ec0c8b97)
Interactive Dashboard 1: https://public.tableau.com/app/profile/isaac.leksrisawat/viz/layoffs_dashboard1/Dashboard1

![Screenshot 2024-07-15 231340](https://github.com/user-attachments/assets/b66ed4f7-0957-4acd-801c-dec23178aaa9)
Interactive Dashboard 2: https://public.tableau.com/app/profile/isaac.leksrisawat/viz/layoffs_dashboard2/Dashboard2
&nbsp;
