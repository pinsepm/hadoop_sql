SELECT
  date(
    concat(CAST(year AS varchar)||'-'||CAST(month AS varchar)||'-01') AS adaptive_month,
  'Total Pinterest' AS Level,
  user_country as user_country,
  sum(conversions_checkouts_771) AS amount
FROM
  Finops.conversion_metrics
WHERE
  year >= 2019
GROUP BY
  year,
  month,
  user_country
