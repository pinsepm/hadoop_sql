-- For JSON Conversion
-- {"sql":"
SELECT
  date AS adaptive_month,
  'Total Pinterest' AS Level,
  country AS Location_User_Growth,
  'User_Growth.Monthly_Active_Users' AS Account,
  mau_30 AS amount
FROM
  salesfinance.northstar_user_metrics_reporting
WHERE
  date = date_max_in_month
ORDER BY
  date,
  country
-- JSON Conversion
-- /*User Growth & Engagement (Archive)*/"}
