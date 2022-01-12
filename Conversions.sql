-- For JSON Conversion
-- {"sql":"
SET hive.mapred.mode=nonstrict;
SELECT
  adaptive_month,
  Level,
  Account,
  amount
FROM
  epm.conversions
-- JSON Conversion
-- /*Standard Sheet*/"}

-- DataHub schedule
-- https://querybook.pinadmin.com/data/datadoc/179821/conversions-table/
