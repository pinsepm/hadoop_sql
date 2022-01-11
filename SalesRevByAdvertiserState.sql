-- For JSON Conversion
-- {"sql":"
SET hive.mapred.mode=nonstrict;
SELECT
  adaptive_month,
  Level,
  Advertiser_State,
  Location_User_Growth,
  Sales_Channel,
  Sales_Sub0Service,
  Sales_Sub0Sector,
  Account,
  amount
FROM
  epm.SalesbyState
-- JSON Conversion
-- /*Sales Revenue by Adv State (Archive)*/"}

-- DataHub schedule
-- https://querybook.pinadmin.com/data/datadoc/179823/salesbystate-table/
