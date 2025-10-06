-- Sales_Data_Transform.sql
-- BigQuery query that produced the uploaded CSV with exact column names and values

WITH base AS (
  SELECT
    -- parse original datetime
    SAFE.PARSE_DATETIME('%m/%d/%Y %H:%M', `Order Date`) AS odt,
    *
  FROM `project.dataset.dirty_sales_data_post_sql_clean`
)
SELECT
  -- Order Date Clean as M/D/YYYY (no leading zeros)
  CONCAT(
    CAST(EXTRACT(MONTH FROM DATE(odt)) AS STRING), '/',
    CAST(EXTRACT(DAY   FROM DATE(odt)) AS STRING), '/',
    CAST(EXTRACT(YEAR  FROM DATE(odt)) AS STRING)
  )                                               AS `Order Date Clean`,

  -- passthrough originals
  `Order Date`,
  `Order ID`,
  Product,

  -- derived location fields from Purchase Address
  TRIM(SPLIT(`Purchase Address`, ',')[OFFSET(1)])                               AS City,
  UPPER(TRIM(SPLIT(SPLIT(`Purchase Address`, ',')[OFFSET(2)], ' ')[OFFSET(0)])) AS `Purchase State`,

  -- passthrough
  `Purchase Address`,

  -- numeric normalization (kept numeric in output)
  SAFE_CAST(`Quantity Ordered` AS INT64)                                        AS `Quantity Ordered`,

  -- currency-formatted outputs (as strings with $)
  CONCAT('$', FORMAT('%.2f', SAFE_CAST(`Price Each` AS NUMERIC)))               AS ` Price Each `,
  CONCAT('$', FORMAT('%.2f', SAFE_CAST(`Cost price`  AS NUMERIC)))              AS ` Cost price `,
  CONCAT('$', FORMAT('%.2f', SAFE_CAST(`turnover`    AS NUMERIC)))              AS ` turnover `,
  CONCAT('$', FORMAT('%.2f', SAFE_CAST(`margin`      AS NUMERIC)))              AS ` margin `
FROM base;
