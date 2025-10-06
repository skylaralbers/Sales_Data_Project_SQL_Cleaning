--cleaning+enrichment pass for sales data
--took raw order info and added helper fields for easier slicing in dashboards
--stripped time off Order_Date→new Order_Date_Clean
--broke out City and State from long address strings
--added cost/turnover/margin calcs using a temp product cost map
--source:project.dataset.sales_raw
--output:project.dataset.sales_data_post_sql_clean
CREATE OR REPLACE TABLE `project.dataset.sales_data_post_sql_clean` AS
WITH base AS(
SELECT
DATE(PARSE_DATETIME('%m/%d/%Y %H:%M',Order_Date))AS Order_Date_Clean,
Order_Date,
Order_ID,
Product,
SPLIT(Purchase_Address,', ')[OFFSET(1)]AS City,
SPLIT(SPLIT(Purchase_Address,', ')[OFFSET(2)],' ')[OFFSET(0)]AS Purchase_State,
Purchase_Address,
CAST(Quantity_Ordered AS INT64)AS Quantity_Ordered,
CAST(Price_Each AS NUMERIC)AS Price_Each
FROM `project.dataset.sales_raw`
),
costs AS(
SELECT*FROM UNNEST([
STRUCT('iPhone'AS product,0.33AS cost_factor),
STRUCT('Lightning Charging Cable',0.50),
STRUCT('Wired Headphones',0.50),
STRUCT('27in FHD Monitor',0.65)
])
)
SELECT
b.Order_Date_Clean,
b.Order_Date,
b.Order_ID,
b.Product,
b.City,
b.Purchase_State,
b.Purchase_Address,
b.Quantity_Ordered,
b.Price_Each,
ROUND(b.Price_Each*b.Quantity_Ordered*COALESCE(c.cost_factor,1.00),4)AS cost_price,
ROUND(b.Price_Each*b.Quantity_Ordered,2)AS turnover,
ROUND(b.Price_Each*b.Quantity_Ordered-b.Price_Each*b.Quantity_Ordered*COALESCE(c.cost_factor,1.00),4)AS margin,
FORMAT('$%,.2f',b.Price_Each)AS price_each_usd,
FORMAT('$%,.2f',ROUND(b.Price_Each*b.Quantity_Ordered*COALESCE(c.cost_factor,1.00),2))AS cost_price_usd,
FORMAT('$%,.2f',ROUND(b.Price_Each*b.Quantity_Ordered,2))AS turnover_usd,
FORMAT('$%,.2f',ROUND(b.Price_Each*b.Quantity_Ordered-b.Price_Each*b.Quantity_Ordered*COALESCE(c.cost_factor,1.00),2))AS margin_usd
FROM base b
LEFT JOIN costs c
ON c.product=b.Product;

