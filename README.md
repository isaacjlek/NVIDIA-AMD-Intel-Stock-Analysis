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
- Tableau - Data visualization and analysis


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

Involved exploring the company data to answer key questions, such as:

- What are the overall trends in stock prices for NVIDIA, AMD, and Intel over the given period?
- Which company has shown the most volatility, and how does it compare to its competitors?
- What is the volatility pattern for each company's stock? Are there periods of high or low volatility?
- What are the trends in trading volume for each company?
- Based on historical data, which company appears to be the most resilient during market downturns?

Data Quality Considerations:

- Are there any data inconsistencies or outliers that need further investigation?
- How does the quality of the data impact the conclusions that can be drawn from this analysis?

Some interesting code I worked with:

Compared the average closing prices of NVIDIA to AMD and Intel over monthly periods

```sql
SELECT nv.Year, 
       nv.Month,
       nv.Avg_Nvidia_Close,
       amd.Avg_AMD_Close,
       intel.Avg_Intel_Close,
       (nv.Avg_Nvidia_Close - amd.Avg_AMD_Close) AS Nvidia_vs_AMD_Price_Difference,
       (nv.Avg_Nvidia_Close - intel.Avg_Intel_Close) AS Nvidia_vs_Intel_Price_Difference
FROM (
    SELECT YEAR(`Date`) AS Year, 
           MONTH(`Date`) AS Month,
           AVG(`Close`) AS Avg_Nvidia_Close
    FROM nvidia_staging
    GROUP BY Year, Month
) nv
JOIN (
    SELECT YEAR(`Date`) AS Year, 
           MONTH(`Date`) AS Month,
           AVG(`Close`) AS Avg_AMD_Close
    FROM amdintel_staging
    WHERE Company = 'AMD'
    GROUP BY Year, Month
) amd ON nv.Year = amd.Year AND nv.Month = amd.Month
JOIN (
    SELECT YEAR(`Date`) AS Year, 
           MONTH(`Date`) AS Month,
           AVG(`Close`) AS Avg_Intel_Close
    FROM amdintel_staging
    WHERE Company = 'Intel'
    GROUP BY Year, Month
) intel ON nv.Year = intel.Year AND nv.Month = intel.Month
ORDER BY nv.Year, nv.Month;
```

### Results/ Findings

SQL - https://shorturl.at/apPWl

Tableau Dashboards - 

![Screenshot 2024-07-15 231126](https://github.com/user-attachments/assets/106da0fb-5984-49c5-860d-1d08ec0c8b97)
Interactive Dashboard 1: https://public.tableau.com/app/profile/isaac.leksrisawat/viz/layoffs_dashboard1/Dashboard1

![Screenshot 2024-07-15 231340](https://github.com/user-attachments/assets/b66ed4f7-0957-4acd-801c-dec23178aaa9)
Interactive Dashboard 2: https://public.tableau.com/app/profile/isaac.leksrisawat/viz/layoffs_dashboard2/Dashboard2
&nbsp;
