-- For JSON Conversion
-- {"sql":"
-- SET hive.mapred.mode=nonstrict;
SELECT
  DATE(
    concat(
      CAST(YEAR AS varchar),
      '-',
      CAST(MONTH AS varchar),
      '-01'
    )
  ) AS adaptive_month,
  cost_center_number AS Level,
  historical_sales_country AS Location_User_Growth,
  SUBSTRING(
    historical_channel_edited,
    strpos(historical_channel_edited, ' ') + 1
  ) AS Sales_Channel,
  job_type_2 AS Seller_Type,
  'FrontLine.Count' AS Account,
  COUNT AS amount
FROM
  finops.sales_headcount
WHERE
  COUNT > 0
  AND data_type = 'Actual'
  AND (
    job_type_2 = 'Account Manager'
    OR job_type_2 = 'Partner Manager'
  )
-- JSON Conversion
-- /*Front Line sellers (Archive)*/"}
