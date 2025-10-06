-- cleaning + enrichment pass for sales data
-- took raw order info and added a few helper fields so it’s easier to slice in dashboards
--  - stripped time off Order_Date → new Order_Date_Clean
--  - broke out City and State from long address strings
--  - added simple cost/turnover/margin calcs using a temp product cost map
-- source: project.dataset.sales_raw
-- output: project.dataset.sales_data_post_sql_clean

CREATE OR REPLACE TABLE `project.dataset.sales_data_post_sql_clean` AS
WITH base AS (
  SELECT
    -- stripped the time out of order date (ex: "1/22/2019 21:25" → "2019-01-22")
    DATE(PARSE_DATETIME('%m/%d/%Y %H:%M', Order_Date)) AS Order_Date_Clean,

    Order_Date,            -- keeping original just for reference
    Order_ID,
    Product,

    -- pulled city from the long purchase address (ex: "944 Walnut St, Boston, MA 02215" → "Boston")
    SPLIT(Purchase_Address, ', ')[OFFSET(1)] AS City,

    -- pulled state from that same address (ex: "944 Walnut St, Boston, MA 02215" → "MA")
    SPLIT(SPLIT(Purchase_Address, ', ')[OFFSET(2)], ' ')[OFFSET(0)] AS Purchase_State,
-- StandardSQL (BigQuery)
WITH base AS (
  SELECT
    -- stripped the time out of order date (ex: "1/22/2019 21:25" → "2019-01-22")
    DATE(PARSE_DATETIME('%m/%d/%Y %H:%M', Order_Date)) AS Order_Date_Clean,

    Order_Date,            -- keeping original just for reference
    Order_ID,
    Product,

    -- pulled city from the long purchase address (ex: "944 Walnut St, Boston, MA 02215" → "Boston")
    SPLIT(Purchase_Address, ', ')[OFFSET(1)] AS City,

    -- pulled state from that same address (ex: "944 Walnut St, Boston, MA 02215" → "MA")
    SPLIT(SPLIT(Purchase_Address, ', ')[OFFSET(2)], ' ')[OFFSET(0)] AS Purchase_State,

    -- left the full address just to keep it traceable
    Purchase_Address,

    -- fixed data types
    CAST(Quantity_Ordered AS INT64) AS Quantity_Ordered,
    CAST(Price_Each AS NUMERIC) AS Price_Each
  FROM `project.dataset.sales_raw`
),

-- quick product cost map just to calculate cost + margin (would normally join a cost table here)
costs AS (
  SELECT * FROM UNNEST([
    STRUCT('iPhone' AS product, 0.33 AS cost_factor),
    STRUCT('Lightning Charging Cable', 0.50),
    STRUCT('Wired Headphones', 0.50),
    STRUCT('27in FHD Monitor', 0.65)
  ])
)

SELECT
  b.Order_Date_Clean,  -- cleaned date (no time)
  b.Order_Date,        -- original date/time
  b.Order_ID,
  b.Product,
  b.City,              -- new column from address
  b.Purchase_State,    -- new column from address
  b.Purchase_Address,
  b.Quantity_Ordered,
  b.Price_Each,

  -- numeric amounts
  ROUND(b.Price_Each * b.Quantity_Ordered * COALESCE(c.cost_factor, 1.00), 4) AS cost_price,
  ROUND(b.Price_Each * b.Quantity_Ordered, 2) AS turnover,
  ROUND(
    b.Price_Each * b.Quantity_Ordered
    - b.Price_Each * b.Quantity_Ordered * COALESCE(c.cost_factor, 1.00), 4
  ) AS margin,

  -- USD-formatted display fields (STRING)
  FORMAT('$%,.2f', b.Price_Each) AS price_each_usd,
  FORMAT(
    '$%,.2f',
    ROUND(b.Price_Each * b.Quantity_Ordered * COALESCE(c.cost_factor, 1.00), 2)
  ) AS cost_price_usd,
  FORMAT('$%,.2f', ROUND(b.Price_Each * b.Quantity_Ordered, 2)) AS turnover_usd,
  FORMAT(
    '$%,.2f',
    ROUND(
      b.Price_Each * b.Quantity_Ordered
      - b.Price_Each * b.Quantity_Ordered * COALESCE(c.cost_factor, 1.00), 2
    )
  ) AS margin_usd

FROM base b
LEFT JOIN costs c
  ON c.product = b.Product;

