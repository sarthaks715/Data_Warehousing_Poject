--VERSION 1 REPORT 8

--VERSION 1 REPORT 9
--total number of rents and cumulative aggregate number of rents in melbourne for each month
SELECT l.suburb, t.month,
TO_CHAR (SUM(f.no_of_rent), '9,999,999,999') AS RENTS,
TO_CHAR (SUM(SUM(f.no_of_rent)) OVER
(ORDER BY l.suburb, t.month
ROWS UNBOUNDED PRECEDING),
'9,999,999,999') AS CUM_RENTS
FROM rent_fact_v1 f, location_dim_v1 l, time_dim_v1 t
WHERE f.postcode = l.postcode
AND f.month_year_id = t.month_year_id
AND l.suburb = 'Melbourne'
GROUP BY l.suburb, t.month
order by l.suburb; 


--VERSION 1 REPORT 10
--total number of rents and moving aggregate number of rents for houses for each month
SELECT p.property_type, t.month,
TO_CHAR (SUM(f.no_of_rent)) AS RENTS,
TO_CHAR (AVG(SUM(f.no_of_rent)) OVER
(ORDER BY p.property_type, t.month
ROWS 2 PRECEDING)) AS MOVING_3_YEAR_AVG
FROM rent_fact_v1 f, property_type_dim_v1 p, time_dim_v1 t
WHERE f.property_type = p.property_type
AND f.month_year_id = t.month_year_id
AND p.property_type = 'House'
GROUP BY p.property_type, t.month
order by p.property_type; 





--VERSION 2 REPORT 8

--VERSION 2 REPORT 9
--total number of rents and cumulative aggregate number of rents in melbourne for each month
SELECT a.suburb, to_char(r.rent_start_date,'mm') as month,
TO_CHAR (SUM(f.no_of_rent), '9,999,999,999') AS RENTS,
TO_CHAR (SUM(SUM(f.no_of_rent)) OVER
(ORDER BY a.suburb, to_char(r.rent_start_date,'mm')
ROWS UNBOUNDED PRECEDING),
'9,999,999,999') AS CUM_RENTS
FROM rent_fact_v2 f, address_dim_v2 a, rent_dim_v2 r
WHERE f.postcode = a.postcode
AND f.rent_id = r.rent_id
AND a.suburb = 'Melbourne' and
to_char(r.rent_start_date,'mm') is not null
GROUP BY a.suburb, to_char(r.rent_start_date,'mm')
order by a.suburb; 


--VERSION 2 REPORT 10
--total number of rents and moving aggregate number of rents for houses for each month
SELECT p.property_type, to_char(r.rent_start_date,'mm'),
TO_CHAR (SUM(f.no_of_rent)) AS RENTS,
TO_CHAR (AVG(SUM(f.no_of_rent)) OVER
(ORDER BY p.property_type,to_char(r.rent_start_date,'mm')
ROWS 2 PRECEDING)) AS MOVING_3_YEAR_AVG
FROM rent_fact_v2 f, property_dim_v2 p, rent_dim_v2 r
WHERE f.property_id = p.property_id
AND f.rent_id = r.rent_id
AND p.property_type = 'House' and
to_char(r.rent_start_date,'mm') is not null
GROUP BY p.property_type, to_char(r.rent_start_date,'mm')
order by p.property_type; 
