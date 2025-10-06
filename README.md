🧾 Sales Data Analytics Dashboard

📊 Project Overview

This project transforms a raw sales export into a clean, analysis-ready dataset and visualizes it using Google Looker Studio.
The goal was to simplify raw data into structured metrics that highlight product performance, sales trends, and profit margins across different U.S. cities.

🔗 Live Dashboard: View on Looker Studio

🧹 Data Cleaning and Enrichment
1. Source Data

Files: Contained within the ZIP archive sales_data_project.zip

sales_data.csv – raw export

sales_data post sql clean.csv – cleaned and formatted dataset

Raw data included combined date-time strings, single-line addresses, and untyped numeric values.

2. Cleaning and Transformation

File: Sales_Data.sql
Executed in Google BigQuery to create the cleaned dataset.

Transformation	Description
Order_Date_Clean	Extracted date only from timestamp (e.g., "1/22/2019 21:25" → "2019-01-22").
City	Extracted from Purchase_Address (e.g., "944 Walnut St, Boston, MA 02215" → "Boston").
Purchase_State	Parsed from Purchase_Address (e.g., "MA").
Quantity_Ordered, Price_Each	Converted from text to numeric values for analysis.
cost_price, turnover, margin	Derived using a temporary cost factor map per product.
*_usd fields	Added formatted USD versions of key numeric columns for dashboard display.

All transformations follow BigQuery StandardSQL and are documented in the .sql file.

📈 Dashboard Features

Turnover Trend: Daily revenue visualization across 2019.

Geographic View: Map of order counts by city.

Product Insights: Top-performing products by turnover and margin.

Interactive Filters: Date and city selectors for custom exploration.

🔗 Live Dashboard: View on Looker Studio

🧮 Example SQL Snippet
ROUND(b.Price_Each * b.Quantity_Ordered * COALESCE(c.cost_factor, 1.00), 4) AS cost_price,
ROUND(b.Price_Each * b.Quantity_Ordered, 2) AS turnover,
ROUND(
  b.Price_Each * b.Quantity_Ordered
  - b.Price_Each * b.Quantity_Ordered * COALESCE(c.cost_factor, 1.00), 4
) AS margin

📂 Repository Structure
├── Dashboard_Screenshot.PNG          # Looker Studio dashboard preview
├── Sales_Data.sql                    # BigQuery transformation script
├── README.md                         # Project documentation
└── sales_data_project.zip            # Compressed folder containing:
    ├── sales_data.csv                # Raw dataset
    └── sales_data post sql clean.csv # Cleaned dataset

🧠 Tools & Technologies

Google BigQuery – SQL cleaning and enrichment

Google Looker Studio – Visualization and reporting

CSV / ZIP – Dataset packaging and portability

🚀 Future Enhancements

Automate refreshes using BigQuery scheduled queries

Add regional profit visualizations and trend comparisons

Replace static cost mappings with a live reference table

Author: Skylar Albers
Role: Procurement Analyst / Data Analytics Enthusiast
Skills Demonstrated: SQL · Data Modeling · ETL · Visualization · BigQuery · Looker Studio