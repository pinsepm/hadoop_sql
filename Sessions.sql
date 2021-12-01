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
  'Total Pinterest' AS adaptive_level,
  --country,
  --'c_Session_Count' AS account,
  CASE WHEN country = 'US' THEN 'c_US_Sessions' ELSE 'c_INTL_Sessions' END AS account,
  COUNT(unified_session_id) AS session_count
FROM
  data.attributed_sessions_base
WHERE
  is_dau = TRUE
  AND CAST(substring(dt, 1, 4) AS int) >= 2019
GROUP BY
  CASE WHEN country = 'US' THEN 'c_US_Sessions' ELSE 'c_INTL_Sessions' END,
  date(
    concat(
      substring(dt, 1, 4),
      '-',
      substring(dt, 6, 2),
      '-01'
    )
  )
-- JSON Conversion
-- {"sql":"
--  /*Standard Sheet*/"}
