-- USER COUNTRY
SELECT
  adaptive_month,
  adaptive_level,
  user_country as country,
  product,
  product_group,
  objective,
  objective_group,
  historical_service_model_old,
  historical_sub_service_model_old,
  historical_team_old,
  account,
  amount,
  (
    CASE WHEN historical_channel LIKE '%Field' THEN 'Field'
         WHEN historical_channel LIKE '%Mid-Market' THEN 'Mid-Market'
         WHEN historical_channel LIKE '%SMB' THEN 'SMB'
         WHEN historical_service_model_old = 'Field' THEN 'Field'
         WHEN historical_service_model_old = 'Growth'
            AND historical_sub_service_model_old = 'Growth - Managed'
            THEN 'Mid-Market'
          /*mid-market*/ 
         WHEN historical_sub_service_model_old = 'Growth - SMB'
            AND (historical_team_old = 'Growth - Marketstar'
                OR historical_team_old = 'Growth - Accenture')
            THEN 'SMB'
          /*part of SMB, but it's just outsourced*/
         WHEN historical_sub_service_model_old = 'Growth - SMB'
            AND historical_team_old = 'Growth - Self Service' THEN 'SMB'
          /*part of SMB, but it's just self-served*/
         ELSE 'Check'
          /*this is just Tina's Check*/
    END) AS channel,
  (
    --Tina's case statement from Q1'21
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
          CAST(adv_stat.year AS varchar),
          '-',
          CAST(adv_stat.month AS varchar),
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
      --AND historical_service_model_old <> 'NA'
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
          CAST(adv_stat.year AS varchar),
          '-',
          CAST(adv_stat.month AS varchar),
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
      --AND historical_service_model_old <> 'NA'
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
