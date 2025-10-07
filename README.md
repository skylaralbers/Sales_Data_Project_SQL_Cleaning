# 🧾 Sales Data Analytics Dashboard (BigQuery)

## Project Overview
This project uses **Google BigQuery** to clean and prepare a sales dataset covering **Jan 1, 2019 through January 1, 2020** for visualization in **Google Looker Studio**.  
The dataset captures seven months of transaction activity across major U.S. cities, allowing trend analysis of sales, margins, and product performance leading into the new year.

🔗 **Live Dashboard:** [View on Looker Studio](https://lookerstudio.google.com/reporting/38e92f7a-6e6c-4cd4-8923-e8b01015def8)
Note: The dataset is large, so initial loading may take extra time. To improve performance, the default date range has been narrowed. You can adjust it using the date range picker on the dashboard.---

## Data Scope and Timeframe
- **Dataset Period:** June 1, 2019 – January 1, 2020  
- **Data Source:** Raw sales export (`sales_data.csv`) cleaned and formatted as `sales_data post sql clean.csv`  
- **Geographic Coverage:** U.S. metropolitan areas including Boston, Portland, San Francisco, and others  
- **Purpose:** To visualize late-year sales performance, profit margins, and city-level distribution of product demand

---

## Data Cleaning and Enrichment

**File:** `Sales_Data_Transform.sql`  
Executed in **BigQuery** to generate the cleaned dataset used for visualization.

| Transformation | Description |
|----------------|-------------|
| `Order Date Clean` | Reformatted combined timestamps (`6/1/2019 11:34` → `6/1/2019`) |
| `City`, `Purchase State` | Extracted from `Purchase Address` for mapping visualizations |
| `Quantity Ordered` | Converted from text to integer for aggregation |
| `Price Each`, `Cost price`, `turnover`, `margin` | Converted to numeric and formatted as USD currency |
| `Purchase Address` | Retained for traceability and location parsing |



