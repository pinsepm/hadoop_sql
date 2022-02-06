-- For JSON Conversion
-- {"sql":"
SELECT
  date(
    concat(
      CAST(year AS varchar),
      '-',
      CAST(month AS varchar),
      '-01'
    )
  ) AS adaptive_month,
  'Total Pinterest' AS Level,
  CASE
    WHEN user_country = 'US' THEN 'c_US_Conversions'
    ELSE 'c_INTL_Conversions'
  END AS Account,
  sum(conversions_checkouts_771) AS amount,
  1 as placeholder
FROM
  Finops.conversion_metrics
WHERE
  year >= 2019
GROUP BY
  year,
  month,
  CASE
    WHEN user_country = 'US' THEN 'c_US_Conversions'
    ELSE 'c_INTL_Conversions'
  END
-- JSON Conversion
-- /*Standard Sheet*/"}
