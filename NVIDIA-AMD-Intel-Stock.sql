-- Data Cleaning

SELECT *
FROM nvidia_stock
ORDER By `Date` DESC;

SET SQL_SAFE_UPDATES = 0;

-- Creating staging table

CREATE TABLE nvidia_staging
LIKE nvidia_stock;

INSERT nvidia_staging
SELECT *
FROM nvidia_stock;

SELECT *
FROM nvidia_staging;

-- Checking for Duplicates

-- Partitioned the duplicates together and indicated them through a row number greater than 1 

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY `Date`, `Open`, High, Low,
`Close`, `Adj Close`, Volume) AS row_num
FROM nvidia_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Standardizing Data

-- Trimmed potential white space for all columns

UPDATE nvidia_staging
SET `Date` = TRIM(COALESCE(`Date`, '')),
`Open` = TRIM(COALESCE(`Open`, '')),
High = TRIM(COALESCE(High, '')),
Low = TRIM(COALESCE(Low, '')),
`Close` = TRIM(COALESCE(`Close`, '')),
`Adj Close` = TRIM(COALESCE(`Adj Close`, '')),
Volume = TRIM(COALESCE(Volume, ''));

-- Changed date column from a 'TEXT' data type to a 'DATE' data type 

ALTER TABLE nvidia_staging
MODIFY COLUMN `Date` DATE NULL;

-- Made sure there were no 'blank' values that needed to be replaced with 'NULLS'

UPDATE nvidia_staging
SET `Open` = NULL
WHERE `Open` = '';
UPDATE nvidia_staging
SET High = NULL
WHERE High = '';
UPDATE nvidia_staging
SET Low = NULL
WHERE Low = '';
UPDATE nvidia_staging
SET `Close` = NULL
WHERE `Close` = '';
UPDATE nvidia_staging
SET `Adj Close` = NULL
WHERE `Adj Close` = '';
UPDATE nvidia_staging
SET Volume = NULL
WHERE Volume = '';

-- Checked for NULL values 

SELECT `Open`
FROM nvidia_staging
WHERE `Open` IS NULL;

SELECT *
FROM nvidia_staging;

-- Trend Analysis
-- Average per month

SELECT
    DATE_FORMAT(`Date`, '%Y-%m') AS Month,
    AVG(`Open`) AS Avg_Open,
    AVG(`Close`) AS Avg_Close,
    AVG(High) AS Avg_High,
    AVG(Low) AS Avg_Low
FROM nvidia_staging
GROUP BY DATE_FORMAT(`Date`, '%Y-%m')
ORDER BY Month;

-- 30-day moving average of the closing price

WITH moving_avg AS (
    SELECT
        `Date`,
        AVG(`Close`) OVER (ORDER BY `Date` ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS Avg_Close_30D
    FROM nvidia_staging
)
SELECT `Date`, Avg_Close_30D
FROM moving_avg;


SELECT *
FROM nvidia_staging
ORDER BY `Date`;

-- Annual High and Lows

SELECT
    EXTRACT(year FROM `Date`) AS Year,
    MAX(`High`) AS Max_High,
    MIN(`Low`) AS Min_Low
FROM nvidia_staging
GROUP BY EXTRACT(year FROM `Date`)
ORDER BY Year;

-- Volatility Analysis
-- Daily Returns (Percentage change in closing price)

SELECT
    `Date`,
    (`Close` - LAG(`Close`) OVER (ORDER BY `Date`)) / LAG(`Close`) OVER (ORDER BY `Date`) AS Daily_Return
FROM nvidia_staging;

-- Rolling standard deviation of daily returns over a 30-day period

SELECT
    `Date`,
    STDDEV_POP(Daily_Return) OVER 
    (ORDER BY `Date` ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS Volatility_30D
FROM (
    SELECT
        `Date`,
        (`Close` - LAG(`Close`) OVER 
        (ORDER BY `Date`)) / LAG(`Close`) OVER (ORDER BY `Date`) AS Daily_Return
    FROM nvidia_staging
) AS returns;

-- Calculates average volume and closing prices for each week

SELECT
    DATE_FORMAT(`Date`, '%Y-%u') AS Year_Week,
    AVG(`Volume`) AS Avg_Volume,
    AVG(`Close`) AS Avg_Close
FROM nvidia_staging
GROUP BY DATE_FORMAT(`Date`, '%Y-%u')
ORDER BY Year_Week;

-- Calculates average volume and closing prices for each month

SELECT
    EXTRACT(month FROM `Date`) AS Month,
    AVG(`Close`) AS Avg_Close,
    AVG(`Volume`) AS Avg_Volume
FROM nvidia_staging
GROUP BY EXTRACT(month FROM `Date`)
ORDER BY Month;

-- Maximum Daily Price Fluctuations

SELECT `Date`, MAX(`High` - `Low`) AS Max_Daily_Price_Fluctuation
FROM nvidia_staging
GROUP BY `Date`
ORDER BY `Date`;

-- S&P 500, AMD, and Intel Comparative Analysis

-- Creating staging tables
-- S&P 500
CREATE TABLE sp500_staging
LIKE yahoo_stock;

INSERT sp500_staging
SELECT *
FROM yahoo_stock;

SELECT *
FROM sp500_staging;

-- AMD and Intel

CREATE TABLE amdintel_staging
LIKE amdintel_dataset;

INSERT amdintel_staging
SELECT *
FROM amdintel_dataset;

SELECT *
FROM amdintel_staging;

-- Changed date columns from a 'TEXT' data type to a 'DATE' data type 

ALTER TABLE sp500_staging
MODIFY COLUMN `Date` DATE NULL;

ALTER TABLE amdintel_staging
MODIFY COLUMN `Date` DATE NULL;

-- Compared average closing prices of NVIDIA to AMD and Intel over monthly periods

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

-- Daily returns for all stocks

CREATE OR REPLACE VIEW nvidia_returns AS
SELECT `Date`, 
       (Close - Open) / Open AS Daily_Return
FROM nvidia_staging;

CREATE OR REPLACE VIEW amd_returns AS
SELECT `Date`, 
       (Close - Open) / Open AS Daily_Return
FROM amdintel_staging
WHERE Company = 'AMD';

CREATE OR REPLACE VIEW intel_returns AS
SELECT `Date`, 
       (Close - Open) / Open AS Daily_Return
FROM amdintel_staging
WHERE Company = 'Intel';

CREATE OR REPLACE VIEW sp500_returns AS
SELECT `Date`, 
       (Close - Open) / Open AS Daily_Return
FROM sp500_staging;

-- Daily returns percentage difference of NVIDIA, AMD, and Intel compared to S&P 500

SELECT 
    n.`Date`,
    n.Daily_Return AS Nvidia_Daily_Return,
    a.Daily_Return AS AMD_Daily_Return,
    i.Daily_Return AS Intel_Daily_Return,
    s.Daily_Return AS SP500_Daily_Return,
    (n.Daily_Return - s.Daily_Return) * 100 AS Nvidia_vs_SP500_Percentage_Diff,
    (a.Daily_Return - s.Daily_Return) * 100 AS AMD_vs_SP500_Percentage_Diff,
    (i.Daily_Return - s.Daily_Return) * 100 AS Intel_vs_SP500_Percentage_Diff
FROM nvidia_returns n
LEFT JOIN amd_returns a ON n.`Date` = a.`Date`
LEFT JOIN intel_returns i ON n.`Date` = i.`Date`
LEFT JOIN sp500_returns s ON n.`Date` = s.`Date`
ORDER BY n.`Date`;

-- Annual High and Lows for all NVIDIA, AMD, Intel, and S&P 500

SELECT
    nv.Year,
    nv.Max_High AS Nvidia_Max_High,
    nv.Min_Low AS Nvidia_Min_Low,
    amd.Max_High AS AMD_Max_High,
    amd.Min_Low AS AMD_Min_Low,
    intel.Max_High AS Intel_Max_High,
    intel.Min_Low AS Intel_Min_Low,
    sp500.Max_High AS SP500_Max_High,
    sp500.Min_Low AS SP500_Min_Low
FROM (
    SELECT
        EXTRACT(YEAR FROM `Date`) AS Year,
        MAX(`High`) AS Max_High,
        MIN(`Low`) AS Min_Low
    FROM nvidia_staging
    GROUP BY EXTRACT(YEAR FROM `Date`)
) nv
JOIN (
    SELECT
        EXTRACT(YEAR FROM `Date`) AS Year,
        MAX(`High`) AS Max_High,
        MIN(`Low`) AS Min_Low
    FROM amdintel_staging
    WHERE `Company` = 'AMD'
    GROUP BY EXTRACT(YEAR FROM `Date`)
) amd ON nv.Year = amd.Year
JOIN (
    SELECT
        EXTRACT(YEAR FROM `Date`) AS Year,
        MAX(`High`) AS Max_High,
        MIN(`Low`) AS Min_Low
    FROM amdintel_staging
    WHERE `Company` = 'Intel'
    GROUP BY EXTRACT(YEAR FROM `Date`)
) intel ON nv.Year = intel.Year
JOIN (
    SELECT
        EXTRACT(YEAR FROM `Date`) AS Year,
        MAX(`High`) AS Max_High,
        MIN(`Low`) AS Min_Low
    FROM sp500_staging
    GROUP BY EXTRACT(YEAR FROM `Date`)
) sp500 ON nv.Year = sp500.Year
ORDER BY nv.Year;
