-- JSON Conversion
-- {"sql":"
-- /*Standard Sheet*/"}
SELECT
  adaptive_month,
  adaptive_level,
  SUM(billable_rev_sales_geo_fixed) AS billable_rev_sales_geo_fixed,
  rank_concentration
FROM

(
SELECT
  adaptive_month,
  adaptive_level,
  billable_rev_sales_geo_fixed,
  CASE WHEN revenue_rank <= 10 THEN 'Top 10 Advertisers'
  WHEN revenue_rank <= 100 THEN 'Advertisers #11 - 100'
  WHEN revenue_rank <= 500 THEN 'Advertisers #101 - 500'
  ELSE 'Advertisers #501+' END AS rank_concentration
FROM
  (
    --Global
    SELECT
      date(concat(CAST(year AS varchar),'-',CAST(quarter * 3 AS varchar),'-01')) AS adaptive_month,
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
