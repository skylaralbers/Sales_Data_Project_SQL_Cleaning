# 🧾 Sales Data Analytics Dashboard

## Project Overview
This project transforms a raw sales export into a clean, analysis-ready dataset and visualizes it using **Google Looker Studio**.  
The process involved loading the CSV into **BigQuery**, cleaning and standardizing the data with SQL, and deriving additional fields for visualization.

🔗 **Live Dashboard:** [View on Looker Studio](https://lookerstudio.google.com/reporting/38e92f7a-6e6c-4cd4-8923-e8b01015def8)

---

## Data Cleaning and Enrichment

### 1. Source Data
**Files:** Contained within the ZIP archive `sales_data_project.zip`

- `sales_data.csv` – raw export  
- `sales_data post sql clean.csv` – cleaned and formatted dataset  

The raw dataset contained:
- Combined date-time fields  
- Full address fields stored as single strings  
- Numeric values stored as text  

---

### 2. Cleaning and Transformation
**File:** `Sales_Data.sql`  
Executed in **Google BigQuery** to generate the final dataset for visualization.

| Transformation | Description |
|----------------|-------------|
| `Order_Date_Clean` | Extracted date from combined timestamp for consistent grouping. |
| `Price_Each`, `Quantity_Ordered` | Converted text values into numeric types using `SAFE_CAST`. |
| `Turnover` | Calculated as `Price_Each * Quantity_Ordered`. |
| `Cost_Price` | Derived using a fixed 0.85 cost factor. |
| `Margin` | Computed as `Turnover - Cost_Price` to represent profit. |
| `Purchase_City`, `Purchase_State` | Extracted from `Purchase_Address` via `SPLIT` and `TRIM` functions. |

---



