🧾 Sales Data Analytics Dashboard
Project Overview

This project transforms a raw sales export into a clean, analysis-ready dataset and visualizes it using Google Looker Studio.
The objective was to standardize text-based data, derive key performance metrics, and enrich the dataset with location fields for geographical insights.

🔗 Live Dashboard: View on Looker Studio

Data Cleaning and Enrichment
1. Source Data

Files: Contained within the ZIP archive sales_data_project.zip

sales_data.csv – raw export

sales_data post sql clean.csv – cleaned and formatted dataset

The raw dataset contained:

Combined date-time strings

Full address fields stored as single strings

Numeric values stored as text

2. Cleaning and Transformation

File: Sales_Data.sql
Executed in Google BigQuery to produce the cleaned dataset used for visualization.

Transformation	Description
Order_Date_Clean	Parsed the timestamp into a date-only field for accurate time grouping.
Price_Each, Quantity_Ordered	Converted text fields to numeric using SAFE_CAST for valid aggregation.
Turnover	Computed as Price_Each * Quantity_Ordered to represent total sales revenue.
Cost_Price	Estimated using a fixed cost factor (0.85) multiplied by total sales.
Margin	Calculated as Turnover - Cost_Price to represent gross profit per order.
Purchase_City, Purchase_State	Extracted from Purchase_Address using SPLIT and TRIM functions.
*_usd fields	Formatted numeric columns as USD strings for dashboard display.

All transformations were written in BigQuery StandardSQL and run against the loaded table
project.dataset.dirty_sales_data_post_sql_clean.

---


