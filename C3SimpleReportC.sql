
--VERSION 1 REPORT 1 top 5 Sum of rent for each feature type and property scale
SELECT *
FROM
(SELECT FEATURE_TYPE_ID,PROPERTY_SCALE_ID,sum(SUM_OF_RENT) as RENTS,
RANK() OVER (ORDER BY  sum(SUM_OF_RENT)  DESC ) AS RANK
FROM rent_fact_v1
GROUP BY FEATURE_TYPE_ID,PROPERTY_SCALE_ID
having sum(SUM_OF_RENT) > 0
order by FEATURE_TYPE_ID)
WHERE RANK <= 5;



--VERSION 1 REPORT 2 top 5% sales in each location and time period 


SELECT *
FROM (
SELECT
l.suburb as SUBURB,
t.Month as MONTH, sum(f.no_of_sales) AS SALES,
percent_rank() over
(order by sum(f.no_of_sales) desc) as PercentRank
FROM sale_fact_v1 f ,time_dim_v1 t, location_dim_v1 l
WHERE f.month_year_id = t.month_year_id and
f.postcode = l.postcode 
GROUP BY l.suburb ,t.Month
having sum(f.no_of_sales) > 0
order by l.suburb
) WHERE PercentRank < 0.1;

select * from property_visit_fact_v1;

--VERSION 1 REPORT 3 number of visits in each season in each day
select SEASON,VISIT_DAY_ID, sum(no_of_visits) as sum_of_visits
from property_visit_fact_v1
group by SEASON,VISIT_DAY_ID
order by season,VISIT_DAY_ID;



--VERSION 2 REPORT 1 top 5 Sum of rent for each feature type and property scale
SELECT *
FROM
(SELECT FEATURE_TYPE_ID,PROPERTY_SCALE_ID,sum(SUM_OF_RENT) as RENTS,
RANK() OVER (ORDER BY  sum(SUM_OF_RENT)  DESC ) AS RANK
FROM rent_fact_v2
GROUP BY FEATURE_TYPE_ID,PROPERTY_SCALE_ID
having sum(SUM_OF_RENT) > 0
order by FEATURE_TYPE_ID)
WHERE RANK <= 5;



--VERSION 2 REPORT 2 top 5% sales in each location and time period 


SELECT *
FROM (
SELECT
a.suburb as SUBURB,
to_char(p.property_date_added,'mm') as MONTH, sum(f.no_of_sales) AS SALES,
percent_rank() over
(order by sum(f.no_of_sales) desc) as PercentRank
FROM sale_fact_v2 f ,property_dim_v2 p, address_dim_v2 a
WHERE f.postcode = a.postcode and
f.property_id = p.property_id 
GROUP BY a.suburb ,to_char(p.property_date_added,'mm')
having sum(f.no_of_sales) > 0
order by a.suburb
) WHERE PercentRank < 0.1;



--VERSION 2 REPORT 3 number of visits in each season in each day
select f.SEASON,v.VISIT_DAY, sum(f.no_of_visits) as sum_of_visits
from property_visit_fact_v2 f, visit_dim_v2 v
where f.client_person_id = v.client_person_id and
f.agent_person_id = v.agent_person_id and
f.visit_date = v.visit_date and 
f.property_id = v.property_id
group by f.SEASON,v.VISIT_DAY
order by f.season,v.VISIT_DAY;
