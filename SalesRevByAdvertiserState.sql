-- For JSON Conversion
-- {"sql":"
SELECT
  date(
    concat(
      CAST(new.year AS varchar),
      '-',
      CAST(new.quarter * 3 AS varchar),
      '-01'
    )
  ) AS adaptive_month,
  'Total Pinterest' AS Level,
  new.YY_ACCOUNT_ADV_STATE AS Advertiser_State,
  previous_quarter_sales_country AS Location_User_Growth,
  previous_quarter_service_model AS Sales_Channel,
  previous_quarter_sub_service_model AS Sales_Sub0Service,
  previous_quarter_sub_sector AS Sales_Sub0Sector,
  'Sales_Rev_State.Revenue_LTM_Current' AS Account,
  sum(new.revenue_ltm_current_period) AS amount
FROM
  (
    SELECT
      year,
      quarter,
      g_advertiser_id,
      YY_ACCOUNT_ADV_STATE,
      sum(revenue) AS revenue,
      sum(sum(revenue)) over (
        partition BY g_advertiser_id
        ORDER BY
          year,
          quarter rows BETWEEN 7 preceding
          AND 4 preceding
      ) AS revenue_ltm_previous_period,
      sum(sum(revenue)) over (
        partition BY g_advertiser_id
        ORDER BY
          year,
          quarter rows BETWEEN 3 preceding
          AND current row
      ) AS revenue_ltm_current_period,
      sum(sum(revenue)) over (
        partition BY g_advertiser_id
        ORDER BY
          year,
          quarter rows BETWEEN unbounded preceding
          AND current row
      ) AS revenue_ltd
    FROM
      salesfinance.partnerhealth_quarterly_billable_fx_v4
    GROUP BY
      1,
      2,
      3,
      4
  ) new
  LEFT JOIN (
    SELECT
      g_advertiser_id,
      previous_quarter_sales_country,
      previous_quarter_service_model,
      previous_quarter_sub_service_model,
      previous_quarter_sub_sector
    FROM
      salesfinance.salesfinance_adv_mapping
    GROUP BY
      1,
      2,
      3,
      4,
      5
  ) adv ON new.g_advertiser_id = adv.g_advertiser_id
GROUP BY
  1,
  2,
  3,
  4,
  5,
  6,
  7
UNION
SELECT
  date(
    concat(
      CAST(new.year AS varchar),
      '-',
      CAST(new.quarter * 3 AS varchar),
      '-01'
    )
  ) AS adaptive_month,
  'Total Pinterest' AS Level,
  new.YY_ACCOUNT_ADV_STATE AS Advertiser_State,
  previous_quarter_sales_country AS Location_User_Growth,
  previous_quarter_service_model AS Sales_Channel,
  previous_quarter_sub_service_model AS Sales_Sub0Service,
  previous_quarter_sub_sector AS Sales_Sub0Sector,
  'Sales_Rev_State.Revenue_LTM_Previous' AS Account,
  sum(new.revenue_ltm_previous_period) AS amount
FROM
  (
    SELECT
      year,
      quarter,
      g_advertiser_id,
      YY_ACCOUNT_ADV_STATE,
      sum(revenue) AS revenue,
      sum(sum(revenue)) over (
        partition BY g_advertiser_id
        ORDER BY
          year,
          quarter rows BETWEEN 7 preceding
          AND 4 preceding
      ) AS revenue_ltm_previous_period,
      sum(sum(revenue)) over (
        partition BY g_advertiser_id
        ORDER BY
          year,
          quarter rows BETWEEN 3 preceding
          AND current row
      ) AS revenue_ltm_current_period,
      sum(sum(revenue)) over (
        partition BY g_advertiser_id
        ORDER BY
          year,
          quarter rows BETWEEN unbounded preceding
          AND current row
      ) AS revenue_ltd
    FROM
      salesfinance.partnerhealth_quarterly_billable_fx_v4
    GROUP BY
      1,
      2,
      3,
      4
  ) new
  LEFT JOIN (
    SELECT
      g_advertiser_id,
      previous_quarter_sales_country,
      previous_quarter_service_model,
      previous_quarter_sub_service_model,
      previous_quarter_sub_sector
    FROM
      salesfinance.salesfinance_adv_mapping
    GROUP BY
      1,
      2,
      3,
      4,
      5
  ) adv ON new.g_advertiser_id = adv.g_advertiser_id
GROUP BY
  1,
  2,
  3,
  4,
  5,
  6,
  7
UNION
SELECT
  date(concat(CAST(a.year AS varchar), '-12-01')) AS adaptive_month,
  'Total Pinterest' AS Level,
  a.ACCOUNT_ADV_STATE AS Advertiser_State,
  a.previous_quarter_sales_country AS Location_User_Growth,
  a.previous_quarter_service_model AS Sales_Channel,
  a.previous_quarter_sub_service_model AS Sales_Sub0Service,
  a.previous_quarter_sub_sector AS Sales_Sub0Sector,
  'Sales_Rev_State.Revenue_Annual' AS Account,
  SUM(a.revenue) AS amount
FROM
  (
    SELECT
      partnerhealth.year AS year,
      partnerhealth.g_advertiser_id AS g_advertiser_id,
      adv_mapping.previous_quarter_sales_country AS previous_quarter_sales_country,
      adv_mapping.previous_quarter_service_model AS previous_quarter_service_model,
      adv_mapping.previous_quarter_sub_service_model AS previous_quarter_sub_service_model,
      adv_mapping.previous_quarter_sub_sector AS previous_quarter_sub_sector,
      partnerhealth.ACCOUNT_ADV_STATE AS account_adv_state,
      SUM(partnerhealth.revenue_ly) AS revenue_ly,
      SUM(partnerhealth.revenue) AS revenue
    FROM
      salesfinance.partnerhealth_annually_billable_fx partnerhealth
      LEFT JOIN (
        SELECT
          G_ADVERTISER_ID,
          previous_quarter_sales_country,
          previous_quarter_service_model,
          previous_quarter_sub_service_model,
          previous_quarter_sub_sector
        FROM
          salesfinance.salesfinance_adv_mapping
        GROUP BY
          1,
          2,
          3,
          4,
          5
      ) adv_mapping ON partnerhealth.g_advertiser_id = adv_mapping.g_advertiser_id
    GROUP BY
      1,
      2,
      3,
      4,
      5,
      6,
      7
  ) a
GROUP BY
  1,
  2,
  3,
  4,
  5,
  6,
  7
UNION
SELECT
  date(concat(CAST(a.year AS varchar), '-12-01')) AS adaptive_month,
  'Total Pinterest' AS Level,
  a.ACCOUNT_ADV_STATE AS Advertiser_State,
  a.previous_quarter_sales_country AS Location_User_Growth,
  a.previous_quarter_service_model AS Sales_Channel,
  a.previous_quarter_sub_service_model AS Sales_Sub0Service,
  a.previous_quarter_sub_sector AS Sales_Sub0Sector,
  'Sales_Rev_State.Revenue_LY_Annual' AS Account,
  SUM(a.revenue_ly) AS amount
FROM
  (
    SELECT
      partnerhealth.year AS year,
      partnerhealth.g_advertiser_id AS g_advertiser_id,
      adv_mapping.previous_quarter_sales_country AS previous_quarter_sales_country,
      adv_mapping.previous_quarter_service_model AS previous_quarter_service_model,
      adv_mapping.previous_quarter_sub_service_model AS previous_quarter_sub_service_model,
      adv_mapping.previous_quarter_sub_sector AS previous_quarter_sub_sector,
      partnerhealth.ACCOUNT_ADV_STATE AS account_adv_state,
      SUM(partnerhealth.revenue_ly) AS revenue_ly,
      SUM(partnerhealth.revenue) AS revenue
    FROM
      salesfinance.partnerhealth_annually_billable_fx partnerhealth
      LEFT JOIN (
        SELECT
          G_ADVERTISER_ID,
          previous_quarter_sales_country,
          previous_quarter_service_model,
          previous_quarter_sub_service_model,
          previous_quarter_sub_sector
        FROM
          salesfinance.salesfinance_adv_mapping
        GROUP BY
          1,
          2,
          3,
          4,
          5
      ) adv_mapping ON partnerhealth.g_advertiser_id = adv_mapping.g_advertiser_id
    GROUP BY
      1,
      2,
      3,
      4,
      5,
      6,
      7
  ) a
GROUP BY
  1,
  2,
  3,
  4,
  5,
  6,
  7
UNION
SELECT
  date(
    concat(
      CAST(main.year AS varchar),
      '-',
      CAST(main.quarter * 3 AS varchar),
      '-01'
    )
  ) AS adaptive_month,
  'Total Pinterest' AS Level,
  new.YY_ACCOUNT_ADV_STATE AS Advertiser_State,
  previous_quarter_sales_country AS Location_User_Growth,
  previous_quarter_service_model AS Sales_Channel,
  previous_quarter_sub_service_model AS Sales_Sub0Service,
  previous_quarter_sub_sector AS Sales_Sub0Sector,
  'Sales_Rev_State.Revenue_Quarter' AS Account,
  sum(new.revenue) AS amount
FROM
  (
    SELECT
      year,
      quarter,
      YY_ACCOUNT_ADV_STATE,
      g_advertiser_id,
      sum(revenue) AS revenue,
      sum(revenue_lq) AS revenue_lq,
      sum(revenue_ly) AS revenue_ly,
      sum(sum(revenue)) over (
        partition BY g_advertiser_id
        ORDER BY
          year,
          quarter rows BETWEEN unbounded preceding
          AND current row
      ) AS revenue_ltd
    FROM
      salesfinance.partnerhealth_quarterly_billable_fx_v4
    GROUP BY
      1,
      2,
      3,
      4
  ) main
  JOIN (
    SELECT
      year,
      quarter,
      YY_ACCOUNT_ADV_STATE,
      g_advertiser_id,
      sum(revenue) AS revenue,
      sum(revenue_through_ly) AS revenue_through_ly,
      sum(revenue_lq) AS revenue_lq,
      sum(revenue_ly) AS revenue_ly,
      sum(sum(revenue)) over (
        partition BY g_advertiser_id
        ORDER BY
          year,
          quarter rows BETWEEN unbounded preceding
          AND current row
      ) AS revenue_ltd
    FROM
      salesfinance.partnerhealth_quarterly_billable_fx_v2
    GROUP BY
      1,
      2,
      3,
      4
  ) new ON main.year = new.year
  AND main.quarter = new.quarter
  AND main.g_advertiser_id = new.g_advertiser_id
  LEFT JOIN (
    SELECT
      g_advertiser_id,
      previous_quarter_sales_country,
      previous_quarter_service_model,
      previous_quarter_sub_service_model,
      previous_quarter_sub_sector
    FROM
      salesfinance.salesfinance_adv_mapping
    GROUP BY
      1,
      2,
      3,
      4,
      5
  ) adv ON main.g_advertiser_id = adv.g_advertiser_id
GROUP BY
  1,
  2,
  3,
  4,
  5,
  6,
  7
UNION
SELECT
  date(
    concat(
      CAST(main.year AS varchar),
      '-',
      CAST(main.quarter * 3 AS varchar),
      '-01'
    )
  ) AS adaptive_month,
  'Total Pinterest' AS Level,
  new.YY_ACCOUNT_ADV_STATE AS Advertiser_State,
  previous_quarter_sales_country AS Location_User_Growth,
  previous_quarter_service_model AS Sales_Channel,
  previous_quarter_sub_service_model AS Sales_Sub0Service,
  previous_quarter_sub_sector AS Sales_Sub0Sector,
  'Sales_Rev_State.Revenue_LY_Quarter' AS Account,
  sum(new.revenue_ly) AS amount
FROM
  (
    SELECT
      year,
      quarter,
      YY_ACCOUNT_ADV_STATE,
      g_advertiser_id,
      sum(revenue) AS revenue,
      sum(revenue_lq) AS revenue_lq,
      sum(revenue_ly) AS revenue_ly,
      sum(sum(revenue)) over (
        partition BY g_advertiser_id
        ORDER BY
          year,
          quarter rows BETWEEN unbounded preceding
          AND current row
      ) AS revenue_ltd
    FROM
      salesfinance.partnerhealth_quarterly_billable_fx_v4
    GROUP BY
      1,
      2,
      3,
      4
  ) main
  JOIN (
    SELECT
      year,
      quarter,
      YY_ACCOUNT_ADV_STATE,
      g_advertiser_id,
      sum(revenue) AS revenue,
      sum(revenue_through_ly) AS revenue_through_ly,
      sum(revenue_lq) AS revenue_lq,
      sum(revenue_ly) AS revenue_ly,
      sum(sum(revenue)) over (
        partition BY g_advertiser_id
        ORDER BY
          year,
          quarter rows BETWEEN unbounded preceding
          AND current row
      ) AS revenue_ltd
    FROM
      salesfinance.partnerhealth_quarterly_billable_fx_v2
    GROUP BY
      1,
      2,
      3,
      4
  ) new ON main.year = new.year
  AND main.quarter = new.quarter
  AND main.g_advertiser_id = new.g_advertiser_id
  LEFT JOIN (
    SELECT
      g_advertiser_id,
      previous_quarter_sales_country,
      previous_quarter_service_model,
      previous_quarter_sub_service_model,
      previous_quarter_sub_sector
    FROM
      salesfinance.salesfinance_adv_mapping
    GROUP BY
      1,
      2,
      3,
      4,
      5
  ) adv ON main.g_advertiser_id = adv.g_advertiser_id
GROUP BY
  1,
  2,
  3,
  4,
  5,
  6,
  7
-- JSON Conversion
-- /*Sales Revenue by Adv State (Archive)*/"}
