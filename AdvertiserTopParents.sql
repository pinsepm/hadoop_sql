-- JSON Conversion
-- {"sql":"
-- /*Standard Sheet*/"}
SELECT
  adaptive_month as adaptive_month,
  adaptive_level as Level,
  SUM(billable_rev_sales_geo_fixed) AS amount,
  rank_concentration as Account
FROM
(
SELECT
  adaptive_month,
  adaptive_level,
  billable_rev_sales_geo_fixed,
  CASE WHEN revenue_rank <= 10 THEN 'c_Top_10_Advert_Pct_Rev'
  WHEN revenue_rank <= 100 THEN 'c_11_100_Advert_Pct_Rev'
  WHEN revenue_rank <= 500 THEN 'c_101_500_Advert_Pct_Rev'
  ELSE 'c_501_Plus_Advert_Pct_Rev' END AS rank_concentration
FROM
  (
    SELECT
      date(concat(CAST(year AS string),'-',CAST(quarter * 3 AS string),'-01')) AS adaptive_month,
      'Total Pinterest' AS adaptive_level,
      advertiser_id,
      SUM(revenue_fixed_fx_by_year) AS billable_rev_sales_geo_fixed,
      rank () over (
        partition BY year,
        quarter
        ORDER BY
          SUM(revenue_fixed_fx_by_year) DESC
      ) revenue_rank
    FROM
      salesfinance.northstar_adstats_advertiser
    GROUP BY
      year,
      quarter,
      advertiser_id
  )
)
GROUP BY adaptive_month, adaptive_level, rank_concentration
ORDER BY adaptive_month, rank_concentration
-- JSON Conversion
-- {"sql":"
-- /*Standard Sheet*/"}
