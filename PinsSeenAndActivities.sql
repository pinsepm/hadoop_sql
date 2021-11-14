--Pins Seen
SELECT
  date(
    concat(
      CAST(year AS STRING),
      '-',
      CAST(month AS STRING),
      '-01'
    )
  ) AS adaptive_month,
  'Total Pinterest' AS adaptive_level,
  CASE
    WHEN country IS NULL
    OR country = '' THEN 'null'
    ELSE country
  END AS user_country,
  CASE
    WHEN viewtpe = 'HOME_FEED' THEN 'Home Feed'
    WHEN viewtpe = 'SEARCH_PINS' THEN 'Search'
    WHEN viewtpe IN ('RELATED_PIN_FEED') THEN 'Related Pin'
    WHEN viewtpe = 'RELATED_PRODUCT_FEED' THEN 'Related Product'
    WHEN viewtpe = 'BOARD_FEED' THEN 'Board Feed'
    WHEN viewtpe IN ('BOARD_IDEAS_FEED', 'BOARD_SECTION_IDEAS_FEED') THEN 'Board Ideas'
    ELSE 'Other Feeds'
  END AS surface,
  'PinsActivity.Pins_Seen' AS account,
  sum(impressions) AS amount
FROM
  salesfinance.northstar_pins_seen_reporting
WHERE
  impressions IS NOT NULL
GROUP BY
  1,
  2,
  3,
  4
UNION
  -- Ad Impressions
SELECT
  date(
    concat(
      CAST(year AS STRING),
      '-',
      CAST(month AS STRING),
      '-01'
    )
  ) AS adaptive_month,
  'Total Pinterest' AS adaptive_level,
  CASE
    WHEN country IS NULL
    OR country = '' THEN 'null'
    ELSE country
  END AS user_country,
  CASE
    WHEN viewtpe = 'HOME_FEED' THEN 'Home Feed'
    WHEN viewtpe = 'SEARCH_PINS' THEN 'Search'
    WHEN viewtpe IN ('RELATED_PIN_FEED') THEN 'Related Pin'
    WHEN viewtpe = 'RELATED_PRODUCT_FEED' THEN 'Related Product'
    WHEN viewtpe = 'BOARD_FEED' THEN 'Board Feed'
    WHEN viewtpe IN ('BOARD_IDEAS_FEED', 'BOARD_SECTION_IDEAS_FEED') THEN 'Board Ideas'
    ELSE 'Other Feeds'
  END AS surface,
  'PinsActivity.Ad_Impressions' AS account,
  sum(ad_impressions) AS amount
FROM
  salesfinance.northstar_pins_seen_reporting
WHERE
  ad_impressions IS NOT NULL
GROUP BY
  1,
  2,
  3,
  4
UNION
  -- Total Clicks
SELECT
  date(
    concat(
      CAST(year AS STRING),
      '-',
      CAST(month AS STRING),
      '-01'
    )
  ) AS adaptive_month,
  'Total Pinterest' AS adaptive_level,
  CASE
    WHEN country IS NULL
    OR country = '' THEN 'null'
    ELSE country
  END AS user_country,
  CASE
    WHEN viewtpe = 'HOME_FEED' THEN 'Home Feed'
    WHEN viewtpe = 'SEARCH_PINS' THEN 'Search'
    WHEN viewtpe IN ('RELATED_PIN_FEED') THEN 'Related Pin'
    WHEN viewtpe = 'RELATED_PRODUCT_FEED' THEN 'Related Product'
    WHEN viewtpe = 'BOARD_FEED' THEN 'Board Feed'
    WHEN viewtpe IN ('BOARD_IDEAS_FEED', 'BOARD_SECTION_IDEAS_FEED') THEN 'Board Ideas'
    ELSE 'Other Feeds'
  END AS surface,
  'PinsActivity.Total_Clicks' AS account,
  sum(total_clicks) AS amount
FROM
  salesfinance.northstar_pins_seen_reporting
WHERE
  ad_impressions IS NOT NULL
GROUP BY
  1,
  2,
  3,
  4
UNION
  -- Total Repins
SELECT
  date(
    concat(
      CAST(year AS STRING),
      '-',
      CAST(month AS STRING),
      '-01'
    )
  ) AS adaptive_month,
  'Total Pinterest' AS adaptive_level,
  CASE
    WHEN country IS NULL
    OR country = '' THEN 'null'
    ELSE country
  END AS user_country,
  CASE
    WHEN viewtpe = 'HOME_FEED' THEN 'Home Feed'
    WHEN viewtpe = 'SEARCH_PINS' THEN 'Search'
    WHEN viewtpe IN ('RELATED_PIN_FEED') THEN 'Related Pin'
    WHEN viewtpe = 'RELATED_PRODUCT_FEED' THEN 'Related Product'
    WHEN viewtpe = 'BOARD_FEED' THEN 'Board Feed'
    WHEN viewtpe IN ('BOARD_IDEAS_FEED', 'BOARD_SECTION_IDEAS_FEED') THEN 'Board Ideas'
    ELSE 'Other Feeds'
  END AS surface,
  'PinsActivity.Total_Repins' AS account,
  sum(total_repins) AS amount
FROM
  salesfinance.northstar_pins_seen_reporting
WHERE
  ad_impressions IS NOT NULL
GROUP BY
  1,
  2,
  3,
  4
-- JSON Conversion
-- {"sql":"
-- /*Pins Activity*/"}
