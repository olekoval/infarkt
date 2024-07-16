WITH Y21_22 AS (
SELECT registration_area,
       COUNT(DISTINCT patient_id) FILTER (WHERE report_year = 2021) AS count_uniq_patient_6_packet_2021,
	   COUNT(DISTINCT patient_id) FILTER (WHERE report_year = 2021 AND actions && ARRAY['38306-00', '38306-01', '38306-02', 
								         '38306-03', '38306-04', '38306-05']) AS count_uniq_patient_stent_2021,
	   COUNT(DISTINCT patient_id) FILTER (WHERE report_year = 2022) AS count_uniq_patient_6_packet_2022,
	   COUNT(DISTINCT patient_id) FILTER (WHERE report_year = 2022 AND actions && ARRAY['38306-00', '38306-01', '38306-02', 
								         '38306-03', '38306-04', '38306-05']) AS count_uniq_patient_stent_2022
  FROM analytics.rds_smd_events_ehealth_2022 AS e
       LEFT JOIN analytics.dwh_legal_entities_edrpou_view AS v ON e.edrpou = v.edrpou
 WHERE is_correct
   AND report_year IN (2021, 2022)
   AND packet_number = '6'  
 GROUP BY registration_area),
     Y23 AS (
SELECT registration_area,
       COUNT(DISTINCT patient_id) AS count_uniq_patient_6_packet_2023,
	   COUNT(DISTINCT patient_id) FILTER (WHERE actions && ARRAY['38306-00', '38306-01', '38306-02', 
								         '38306-03', '38306-04', '38306-05']) AS count_uniq_patient_stent_2023
  FROM analytics.rds_pmg_events_2023 AS e
       INNER JOIN analytics.rds_pmg_events_checks_2023 AS eсh ON e.id = eсh.id 
       LEFT JOIN analytics.dwh_legal_entities_edrpou_view AS v ON e.edrpou = v.edrpou
 WHERE is_correct	
   AND is_payment
   AND packet_number = '6'
 GROUP BY registration_area	)
 
 SELECT *
   FROM Y21_22
        LEFT JOIN Y23 USING(registration_area)
  ORDER BY registration_area		