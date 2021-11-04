SELECT
  adaptive_month,
  adaptive_level,
  historical_sales_country,
  historical_sub_service_model_old,
  historical_service_model_old,
  historical_team_old,
  account,
  advertiser_count,
  channel,
  sub_service
FROM
  (
    SELECT
      *,
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
           THEN 'SMB'
          ELSE 'Check'
          /*this is just Tina's Check*/
    END) AS channel,
      (
        CASE
          WHEN historical_channel LIKE '%Field' THEN 'Managed'
          WHEN historical_channel LIKE '%Mid-Market' THEN 'Managed'
          WHEN historical_channel LIKE '%SMB'
          AND historical_sub_sector LIKE '%Managed' THEN 'Managed'
          WHEN historical_channel LIKE '%SMB' THEN 'Self-Serve'
          WHEN historical_service_model_old = 'Field' THEN 'Managed'
          WHEN historical_service_model_old = 'Growth'
          AND historical_sub_service_model_old = 'Growth - Managed' THEN 'Managed'
          WHEN historical_service_model_old = 'Growth'
          AND historical_team_old = 'Growth - Accenture' THEN 'Managed'
          WHEN historical_service_model_old = 'Growth'
          AND historical_team_old = 'Growth - Marketstar' THEN 'Managed'
          ELSE 'Self-Serve'
        END
      ) AS sub_service
    FROM
      (
        --Annual
        SELECT
          date(concat(CAST(bill.year AS varchar), '-12-01')) AS adaptive_month,
          'Total Pinterest' AS adaptive_level,
          adv_mapping.historical_channel,
          adv_mapping.historical_sector,
          adv_mapping.historical_sub_sector,
          adv_mapping.historical_sales_country,
          adv_mapping.historical_sub_service_model_old,
          adv_mapping.historical_service_model_old,
          adv_mapping.historical_team_old,
          'Ad_Detail.Advertiser_Count_Annual' AS account,
          COUNT(DISTINCT bill.g_advertiser_id) AS advertiser_count
        FROM
          bi.ad_daily_billable_stats bill
          LEFT JOIN salesfinance.salesfinance_adv_mapping adv_mapping ON bill.year = adv_mapping.year
          AND bill.quarter = adv_mapping.quarter
          AND bill.g_advertiser_id = adv_mapping.g_advertiser_id
        WHERE
          bill.type = 'GROSS_BILLABLE'
        GROUP BY
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10
        UNION
          --Quarter
        SELECT
          date(
            concat(
              CAST(a.year AS varchar),
              '-',
              CAST(a.quarter * 3 AS varchar),
              '-01'
            )
          ) AS adaptive_month,
          'Total Pinterest' AS adaptive_level,
          a.historical_channel,
          a.historical_sector,
          a.historical_sub_sector,
          a.historical_sales_country,
          a.historical_sub_service_model_old,
          a.historical_service_model_old,
          a.historical_team_old,
          'Ad_Detail.Advertiser_Count_Quarter' AS account,
          COUNT(DISTINCT a.g_advertiser_id) AS advertiser_count
        FROM
          (
            SELECT
              partnerhealth.year AS year,
              partnerhealth.quarter AS quarter,
              partnerhealth.g_advertiser_id AS g_advertiser_id,
              adv_mapping.historical_channel,
              adv_mapping.historical_sector,
              adv_mapping.historical_sub_sector,
              adv_mapping.historical_sales_country,
              adv_mapping.historical_service_model_old,
              adv_mapping.historical_sub_service_model_old,
              adv_mapping.historical_team_old
            FROM
              salesfinance.partnerhealth_quarterly_billable_fx_v4 partnerhealth
              LEFT JOIN (
                SELECT
                  *
                FROM
                  salesfinance.salesfinance_adv_mapping
              ) adv_mapping ON CAST(partnerhealth.year AS bigint) = CAST(adv_mapping.year AS bigint)
              AND CAST(partnerhealth.quarter AS bigint) = CAST(adv_mapping.quarter AS bigint)
              AND partnerhealth.g_advertiser_id = adv_mapping.g_advertiser_id
            WHERE
              partnerhealth.qq_account_adv_state IN ('new', 'resurrected', 'retained')
            GROUP BY
              1,
              2,
              3,
              4,
              5,
              6,
              7,
              8,
              9,
              10
          ) a
        GROUP BY
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10
      )
    WHERE
      historical_sales_country <> 'null'
  )
--WHERE
--  channel <> 'Check'
--  AND sub_service <> 'Check'
