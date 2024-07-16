SELECT report_year,
       principal_diagnosis,
       COUNT(*) AS count
  FROM analytics.rds_smd_events_ehealth_2022   
 WHERE is_correct
   AND report_year IN (2021, 2022)
   AND packet_number = '6'
 GROUP BY report_year, principal_diagnosis  




