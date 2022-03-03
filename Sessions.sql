-- For JSON Conversion
-- {"sql":"
SELECT
  date(
    concat(
      substring(dt, 1, 4),
      '-',
      substring(dt, 6, 2),
      '-01'
    )
  ) AS adaptive_month,
  'Total Pinterest' AS Level,
  country,
  COUNT(unified_session_id) AS amount
FROM
  data.attributed_sessions_base
WHERE
  is_dau = TRUE
  AND CAST(substring(dt, 1, 4) AS int) >= 2019
GROUP BY
 country,
  date(
    concat(
      substring(dt, 1, 4),
      '-',
      substring(dt, 6, 2),
      '-01'
    )
  )
-- JSON Conversion
--  /*Standard Sheet*/"}
