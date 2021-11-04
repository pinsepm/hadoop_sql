SELECT
  date as adaptive_month,
  cost_center as Level,
  sales_country AS Location_User_Growth,
  SUBSTRING(channel, STRPOS(channel, ' ')+1) as Sales_Channel,
  type AS Seller_Type,
  'FrontLine.Count' AS Account,
  raw_count as amount
FROM
  salesfinance.partnerhistory_count
WHERE
  year >= 2020
  AND raw_count > 0
  AND version = 'Actual'
  AND (
    type = 'Account Manager'
    OR type = 'Partner Manager'
  )
