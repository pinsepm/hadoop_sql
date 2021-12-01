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
  'Total Pinterest' AS adaptive_level,
  CASE
    WHEN user_country = 'US' THEN 'c_US_Conversions'
    ELSE 'c_INTL_Conversions'
  END AS account,
  sum(conversions_checkouts_771) AS conversion_count
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
-- {"sql":"
-- /*Standard Sheet*/"}
