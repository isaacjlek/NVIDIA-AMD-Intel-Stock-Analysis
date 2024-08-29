# NVIDIA-AMD-Intel-Stock-Analysis

### Project Overview

This project analyzes stock data for NVIDIA, AMD, and Intel from May 2020 to May 2024. Using SQL, the data was cleaned, standardized, and joined to enable a detailed comparative analysis of trends and volatility across the three companies. The results are presented in an interactive Tableau dashboard, which features embedded navigation links for easy access to each company's specific visualizations. These include candlestick charts, positive/negative percentage change bar charts, and volume-over-time line charts, all equipped with customizable time filters. This tool provides valuable insights for investors and analysts looking to compare stock performance and make informed decisions.

### Data Sources

The data sets used for this analysis are:<br>
NVIDIA - https://www.kaggle.com/datasets/amirhoseinmousavian/nvidia-corporation-nvda-stock-price<br>
AMD/ Intel - https://www.kaggle.com/datasets/ranatalha71/weekly-historical-stock-data-for-intel-and-amd<br>
S&P 500 - https://www.kaggle.com/datasets/arashnic/time-series-forecasting-with-yahoo-stock-price<br>

### Tools

- MySQL - Data cleaning and analysis
- Tableau - Data visualization and analysis


### Data Cleaning

In the initial data preparation phase, I performed the following in SQL:

1. Removed duplicates
2. Standardized the data
3. Organized null and blank values
4. Removed unnecessary columns
5. Joined the data sets on date
6. EDA, trend analysis, volatility analysis
8. Comparitive analysis of the three stocks using the S&P 500 as a baseline for the stock market

After this initial preparation and analysis in SQL I transported the data to tableau and executed the following:
1. Joined the data sets on date
2. Created unique and functional visualizations using calculated fields, parameters, custom formatting, tooltips, and annotations, to create charts such as:
   - Candlestick Charts: Detailed daily stock price movements for each company
   - Positive/Negative Percentage Change Bar Chart: Visual representation of stock performance over various periods, 
     highlighting gains and losses
   - Volume-Over-Time Continuous Line Chart: Track and compare the trading volume trends over time
3. Developed an interactive Tableau dashboard using the visualizations, including embedded navigation links allowing users to switch between company-specific dashboards
4. Incorporated customizable time bars for dynamic filtering, allowing users to analyze data over selected periods

### Data Analysis

Involved exploring the company data to answer potential key questions, such as:

- What are the overall trends in stock prices for NVIDIA, AMD, and Intel over the given period?
- Which company has shown the most volatility, and how does it compare to its competitors?
- What is the volatility pattern for each company's stock? Are there periods of high or low volatility?
- What are the trends in trading volume for each company?

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

SQL Code - https://github.com/isaacjlek/NVIDIA-AMD-Intel-Stock-Analysis/blob/main/NVIDIA-AMD-Intel-Stock.sql

Tableau Dashboard Preview: 

![Screenshot 2024-08-29 001421](https://github.com/user-attachments/assets/97bceb7d-8a5b-45f0-8ba3-f27b834c8b8c)
![Screenshot 2024-08-29 001730](https://github.com/user-attachments/assets/71cd9070-9190-41df-9de6-3bd23624aceb)

Interactive Dashboard Directory: https://public.tableau.com/app/profile/isaac.leksrisawat/viz/NVIDIAAMDIntelStockAnalysis/NVIDIADashboard#1

## Considerations:

### 1. Overall Trends in Stock Prices:
#### NVIDIA: 
The stock price of NVIDIA has shown a general upward trend over the period from May 2020 to May 2024, with several fluctuations. This aligns with its strong performance driven by increased demand for GPUs in gaming, AI, and data centers.
#### AMD: 
AMD's stock price has also trended upward, reflecting its competitive position in the CPU and GPU markets. However, its growth appears to be more volatile than NVIDIA's.
#### Intel: 
Intel's stock price shows less upward movement compared to NVIDIA and AMD, with more periods of stability and some declines. This could reflect challenges in maintaining market share against rising competitors like AMD.
### 2. Company Showing the Most Volatility:
AMD appears to be the most volatile among the three. This is evident from the candlestick chart and the sharp spikes in the volume chart. The company has seen more frequent and significant swings in stock price, possibly due to competitive pressures and market perceptions regarding its product releases.
### 3. Volatility Patterns:
#### NVIDIA: 
The volatility for NVIDIA shows periods of higher volatility during the tech boom and in response to market events, such as product launches or earnings reports.
#### AMD: 
AMD's volatility is more pronounced, with sharp peaks and troughs, suggesting rapid changes in market sentiment. These periods may correspond with earnings announcements or industry developments affecting AMD's competitive position.
#### Intel: 
Intel's volatility is relatively lower, with fewer sharp movements in stock price. The company has periods of stability, particularly when compared to NVIDIA and AMD, but it also experiences occasional declines due to competitive pressures.
### 4. Trends in Trading Volume:
#### NVIDIA: 
The trading volume for NVIDIA shows periodic spikes, often coinciding with price increases or decreases. These spikes indicate heightened investor interest, likely tied to earnings reports or other significant company events.
#### AMD: 
AMD exhibits the highest spikes in trading volume, particularly around periods of high volatility. This aligns with the stock's price movements, indicating strong reactions from the market to news or developments related to the company.
#### Intel: 
Intel's trading volume shows a more consistent pattern with fewer extreme spikes. This suggests a more stable investor base with less reactionary trading behavior.

## Events and Potential Impacts:

### NVIDIA
Mid-2020 to Early 2021:

Event: The significant upward trend in NVIDIA's stock price during this period likely corresponds to the increased demand for GPUs driven by the COVID-19 pandemic, which fueled gaming, data centers, and cryptocurrency mining.
Impact: Stock prices surged as NVIDIA's products were in high demand, leading to record earnings.
Late 2021 to Early 2022:

Event: The peak around late 2021 aligns with the announcement of new product launches, such as the NVIDIA RTX 30 series GPUs, and the positive response from investors regarding NVIDIA's advancements in AI and data centers.
Impact: The stock reached its highest point, reflecting strong investor confidence.

Mid-2022 to Late 2022:

Event: The sharp decline in the stock price during this period can be attributed to the global chip shortage, potential overvaluation concerns, and macroeconomic factors such as rising interest rates.
Impact: The stock experienced significant volatility, with a notable drop in value.

2023 to Early 2024:

Event: The partial recovery in early 2023 may be linked to NVIDIA's AI developments and partnerships, along with the easing of supply chain issues.
Impact: Stock prices began to stabilize and recover, although not to previous highs.

### AMD
Mid-2020 to Early 2021:

Event: AMD's stock saw growth as it gained market share from Intel, especially in the CPU market, and released competitive products like the Ryzen 5000 series.
Impact: Stock prices increased as AMD's performance and market position strengthened.

Late 2021 to Early 2022:

Event: The peak in late 2021 corresponds to AMD's successful acquisition of Xilinx, which was seen as a strategic move to expand its data center and AI capabilities.
Impact: Investors reacted positively, pushing the stock to new highs.

Mid-2022 to Late 2022:

Event: The decline during this period may be due to the broader tech sell-off and concerns about slowing growth in the semiconductor industry.
Impact: AMD's stock price dropped, reflecting market uncertainties.

2023 to Early 2024:

Event: A recovery trend is seen in early 2023, likely due to the launch of new products and improved financial performance, coupled with optimism about the AI and data center markets.
Impact: Stock prices began to rise, albeit with some fluctuations.

### Intel
Mid-2020 to Early 2021:

Event: Intel's relatively stable performance during this time can be linked to its continued dominance in the data center market, though it faced increasing competition from AMD and NVIDIA.
Impact: The stock price remained steady with minor fluctuations.

Late 2021 to Early 2022:

Event: The gradual decline in Intel's stock price correlates with investor concerns over delays in its 7nm process technology and losing market share to AMD.
Impact: Stock prices started to decline, reflecting these challenges.

Mid-2022 to Late 2022:

Event: The significant drop in late 2022 aligns with the ongoing struggles in technology leadership, compounded by broader market downturns and supply chain issues.
Impact: Intel’s stock faced a steep decline as confidence waned.

2023 to Early 2024:

Event: The minor recovery in 2023 may be due to strategic changes, such as Intel’s focus on manufacturing (foundry services) and potential partnerships.
Impact: Stock prices saw some improvement but remained lower compared to earlier highs.

