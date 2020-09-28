--VERSION 1 REPORT 11
--ranking of each property type based on the yearly total number of sales and the ranking of each state based on the yearly
--total number of sales.

SELECT p.property_type, s.state_name  AS STATE,
TO_CHAR(SUM(f.no_of_sales)) AS SALES,
RANK() OVER (PARTITION BY p.property_type
ORDER BY SUM(f.no_of_sales) DESC) AS RANK_BY_PROPERTY_TYPE,
RANK() OVER (PARTITION BY s.state_name
ORDER BY SUM(f.no_of_sales) DESC) AS RANK_BY_STATE
FROM sale_fact_v1 f, property_type_dim_v1 p, location_dim_v1 l, state_dim_v1 s
WHERE f.property_type = p.property_type
and f.postcode = l.postcode
and l.state_code = s.state_code
GROUP BY p.property_type, s.state_name
order by p.property_type;

--VERSION 1 REPORT 12
--ranking of each property scale based on the total number of rents and the ranking of each property type based on the
--total number of rents.
SELECT p.property_scale_id, pt.property_type  AS PROPERTY_TYPE,
TO_CHAR(SUM(f.no_of_rent)) AS RENTS,
RANK() OVER (PARTITION BY p.property_scale_id
ORDER BY SUM(f.no_of_rent) DESC) AS RANK_BY_PROPERTY_SCALE,
RANK() OVER (PARTITION BY pt.property_type
ORDER BY SUM(f.no_of_rent) DESC) AS RANK_BY_TYPE
FROM rent_fact_v1 f, property_scale_dim_v1 p,property_type_dim_v1 pt
WHERE f.property_scale_id = p.property_scale_id
and f.property_type = pt.property_type
GROUP BY p.property_scale_id, pt.property_type
order by p.property_scale_id;






--VERSION 2 REPORT 11
--ranking of each property type based on the yearly total number of sales and the ranking of each state based on the yearly
--total number of sales.

SELECT p.property_type, s.state_name  AS STATE,
TO_CHAR(SUM(f.no_of_sales)) AS SALES,
RANK() OVER (PARTITION BY p.property_type
ORDER BY SUM(f.no_of_sales) DESC) AS RANK_BY_PROPERTY_TYPE,
RANK() OVER (PARTITION BY s.state_name
ORDER BY SUM(f.no_of_sales) DESC) AS RANK_BY_STATE
FROM sale_fact_v2 f , property_dim_v2 p, address_dim_v2 s
WHERE f.property_id = p.property_id
and f.postcode = s.postcode
GROUP BY p.property_type, s.state_name
order by p.property_type;

--VERSION 2 REPORT 12
--ranking of each property scale based on the total number of rents and the ranking of each property type based on the
--total number of rents.
SELECT p.property_scale_id, pt.property_type  AS PROPERTY_TYPE,
TO_CHAR(SUM(f.no_of_rent)) AS RENTS,
RANK() OVER (PARTITION BY p.property_scale_id
ORDER BY SUM(f.no_of_rent) DESC) AS RANK_BY_PROPERTY_SCALE,
RANK() OVER (PARTITION BY pt.property_type
ORDER BY SUM(f.no_of_rent) DESC) AS RANK_BY_TYPE
FROM rent_fact_v2 f, property_scale_dim_v2 p,property_dim_v2 pt
WHERE f.property_scale_id = p.property_scale_id
and f.property_id = pt.property_id
GROUP BY p.property_scale_id, pt.property_type
order by p.property_scale_id;
