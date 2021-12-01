-- For JSON Conversion
-- {"sql":"
SELECT
  adaptive_month as adaptive_month,
  adaptive_level as Level,
  user_country as Location_User_Growth,
  product as Sales_Product,
  product_group as product_group,
  objective as objective,
  objective_group as objective_group,
  historical_service_model_old as historical_service_model_old,
  historical_sub_service_model_old as historical_sub_service_model_old,
  historical_team_old as historical_team_old,
  account as Account,
  amount as amount,
  (
    CASE WHEN historical_channel LIKE '%Field' THEN 'Field'
         WHEN historical_channel LIKE '%Mid-Market' THEN 'Mid-Market'
         WHEN historical_channel LIKE '%SMB' THEN 'SMB'
         WHEN historical_service_model_old = 'Field' THEN 'Field'
         WHEN historical_service_model_old = 'Growth'
            AND historical_sub_service_model_old = 'Growth - Managed'
            THEN 'Mid-Market'
         WHEN historical_sub_service_model_old = 'Growth - SMB'
            AND (historical_team_old = 'Growth - Marketstar'
                OR historical_team_old = 'Growth - Accenture')
            THEN 'SMB'
         WHEN historical_sub_service_model_old = 'Growth - SMB'
            AND historical_team_old = 'Growth - Self Service' THEN 'SMB'
         ELSE 'Check'
    END) AS Sales_Channel,
  (
    CASE
      WHEN historical_channel LIKE '%Field'
      AND user_country <> 'US' THEN 'Managed'
      WHEN historical_channel LIKE '%Field'
      AND user_country = 'US'
      THEN 'Managed'
      WHEN historical_channel LIKE '%Mid-Market' THEN 'Managed'
      WHEN historical_channel LIKE '%SMB'
      AND historical_sub_sector LIKE '%Managed' THEN 'Managed'
      WHEN historical_channel LIKE '%SMB' THEN 'Self-Serve'
      WHEN historical_service_model_old = 'Field'
      AND user_country <> 'US' THEN 'Managed'
      WHEN historical_service_model_old = 'Field'
      AND user_country = 'US'
      AND historical_sub_service_model_old = 'Field - Upper Funnel' THEN 'Managed'
      WHEN historical_service_model_old = 'Field'
      AND user_country = 'US'
      AND historical_sub_service_model_old = 'Field - Lower Funnel' THEN 'Managed'
      WHEN historical_service_model_old = 'Growth'
      AND historical_sub_service_model_old = 'Growth - Managed' THEN 'Managed'
      WHEN historical_service_model_old = 'Growth'
      AND historical_team_old = 'Growth - Accenture' THEN 'Managed'
      WHEN historical_service_model_old = 'Growth'
      AND historical_team_old = 'Growth - Marketstar' THEN 'Managed'
      ELSE 'Self-Serve'
    END
  ) AS Sales_Sub0Service
FROM
  (
    SELECT
      date(
        concat(
          CAST(adv_stat.year AS string),
          '-',
          CAST(adv_stat.month AS string),
          '-01'
        )
      ) AS adaptive_month,
      'Total Pinterest' AS adaptive_level,
      adv_stat.user_country,
      adv_stat.product,
      adv_stat.product_group,
      adv_stat.objective,
      adv_stat.objective_group,
      adv_mapping.historical_channel,
      adv_mapping.historical_sector,
      adv_mapping.historical_sub_sector,
      adv_mapping.historical_service_model_old,
      adv_mapping.historical_sub_service_model_old,
      adv_mapping.historical_team_old,
      'Billable Revenue - User Geo - Fixed FX' AS account,
      SUM(revenue_fixed_fx_by_year) AS amount
    FROM
      salesfinance.northstar_adstats_advertiser adv_stat
      LEFT JOIN salesfinance.salesfinance_adv_mapping adv_mapping ON adv_stat.advertiser_id = adv_mapping.g_advertiser_id
      AND adv_stat.year = adv_mapping.year
      AND adv_stat.quarter = adv_mapping.quarter
    WHERE
      revenue_fixed_fx_by_year IS NOT NULL
    GROUP BY
      adv_stat.year,
      adv_stat.month,
      adv_stat.user_country,
      adv_stat.product,
      adv_stat.product_group,
      adv_stat.objective,
      adv_stat.objective_group,
      adv_mapping.historical_channel,
      adv_mapping.historical_sector,
      adv_mapping.historical_sub_sector,
      adv_mapping.historical_service_model_old,
      adv_mapping.historical_sub_service_model_old,
      adv_mapping.historical_team_old
    UNION
    SELECT
      date(
        concat(
          CAST(adv_stat.year AS string),
          '-',
          CAST(adv_stat.month AS string),
          '-01'
        )
      ) AS adaptive_month,
      'Total Pinterest' AS adaptive_level,
      adv_stat.user_country,
      adv_stat.product,
      adv_stat.product_group,
      adv_stat.objective,
      adv_stat.objective_group,
      adv_mapping.historical_channel,
      adv_mapping.historical_sector,
      adv_mapping.historical_sub_sector,
      adv_mapping.historical_service_model_old,
      adv_mapping.historical_sub_service_model_old,
      adv_mapping.historical_team_old,
      'Ad Impressions - User Geo' AS account,
      SUM(ad_impressions) AS amount
    FROM
      salesfinance.northstar_adstats_advertiser adv_stat
      LEFT JOIN salesfinance.salesfinance_adv_mapping adv_mapping 
        ON adv_stat.advertiser_id = adv_mapping.g_advertiser_id
        AND adv_stat.year = adv_mapping.year
        AND adv_stat.quarter = adv_mapping.quarter
    WHERE
      ad_impressions IS NOT NULL
    GROUP BY
      adv_stat.year,
      adv_stat.month,
      adv_stat.user_country,
      adv_stat.product,
      adv_stat.product_group,
      adv_stat.objective,
      adv_stat.objective_group,
      adv_mapping.historical_channel,
      adv_mapping.historical_sector,
      adv_mapping.historical_sub_sector,
      adv_mapping.historical_service_model_old,
      adv_mapping.historical_sub_service_model_old,
      adv_mapping.historical_team_old
  )
-- JSON Conversion
-- /*Sales Metric Detail*/"}
