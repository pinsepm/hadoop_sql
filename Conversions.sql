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
    WHEN user_country = 'US' THEN 'US'
    ELSE user_country
  END
  AS user_country,
  'c_Conversions' AS Account,
  sum(conversions_checkouts_771) AS amount
FROM
  Finops.conversion_metrics
WHERE
  year >= 2019
GROUP BY
  year,
  month,
  CASE
    WHEN user_country = 'US' THEN 'US'
    ELSE user_country
  END
-- JSON Conversion
-- /*Standard Sheet*/"}
