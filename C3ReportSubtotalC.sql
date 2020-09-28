


--VERSION 1 REPORT 4
--the sub-total and total rental fees from each suburb, time period, and property type using cube
SELECT l.suburb, f.month_year_id ,f.property_type , NVL(SUM(sum_of_rent),0)
as RENT
FROM rent_fact_v1 f,location_dim_v1 l
WHERE f.postcode = l.postcode
GROUP BY CUBE(l.suburb, f.month_year_id ,f.property_type)
order by l.suburb;

--VERSION 1 REPORT 5
----the sub-total and total rental fees from each suburb, time period, and property type using partial cube

SELECT l.suburb, f.month_year_id ,f.property_type , NVL(SUM(sum_of_rent),0)
as RENT
FROM rent_fact_v1 f,location_dim_v1 l
WHERE f.postcode = l.postcode
GROUP BY l.suburb , CUBE(f.month_year_id ,f.property_type)
order by l.suburb;


--VERSION 1 REPORT 6
--total number of sales from each suburb, time period and advertisement type using rollup
SELECT l.suburb, f.month_year_id ,a.advert_name , SUM(no_of_sales)
as SALES_COUNT
FROM sale_fact_v1 f,location_dim_v1 l, advert_dim_v1 a
WHERE f.postcode = l.postcode and
f.advert_id = a.advert_id
GROUP BY ROLLUP(l.suburb, f.month_year_id ,a.advert_name)
order by l.suburb;


--VERSION 1 REPORT 7
--total number of sales from each suburb, time period and advertisement type using partial rollup
SELECT l.suburb, f.month_year_id ,a.advert_name , SUM(no_of_sales)
as SALES_COUNT
FROM sale_fact_v1 f,location_dim_v1 l, advert_dim_v1 a
WHERE f.postcode = l.postcode and
f.advert_id = a.advert_id
GROUP BY l.suburb, ROLLUP(f.month_year_id ,a.advert_name)
order by l.suburb;








--VERSION 2 REPORT 4
--the sub-total and total rental fees from each suburb, time period, and property type using cube
SELECT a.suburb, to_char(r.rent_start_date,'mm') || to_char(r.rent_start_date,'yy') as month_year_id ,p.property_type , NVL(SUM(f.sum_of_rent),0)
as RENT
FROM rent_fact_v2 f,address_dim_v2  a, rent_dim_v2 r, property_dim_v2 p
WHERE f.postcode = a.postcode and
f.property_id = p.property_id and
f.rent_id = r.rent_id
GROUP BY CUBE(a.suburb, to_char(r.rent_start_date,'mm') || to_char(r.rent_start_date,'yy') ,p.property_type)
order by a.suburb;

--VERSION 2 REPORT 5
----the sub-total and total rental fees from each suburb, time period, and property type using partial cube

SELECT a.suburb, to_char(r.rent_start_date,'mm') || to_char(r.rent_start_date,'yy') as month_year_id ,p.property_type , NVL(SUM(sum_of_rent),0)
as RENT
FROM rent_fact_v2 f,rent_dim_v2 r , property_dim_v2 p, address_dim_v2 a
WHERE f.postcode = a.postcode and
f.rent_id = r.rent_id and
f.property_id = p.property_id
GROUP BY a.suburb , CUBE(to_char(r.rent_start_date,'mm') || to_char(r.rent_start_date,'yy') ,p.property_type)
order by a.suburb;






--VERSION 2 REPORT 6
--total number of sales from each suburb, time period and advertisement type using rollup
SELECT a.suburb, to_char(p.property_date_added,'mm') || to_char(p.property_date_added,'yy') as month_year_id ,ad.advert_name , SUM(f.no_of_sales)
as SALES_COUNT
FROM sale_fact_v2 f,address_dim_v2 a, advert_dim_v2 ad, property_dim_v2 p
WHERE f.postcode = a.postcode and
f.advert_id = ad.advert_id and
f.property_id = p.property_id
GROUP BY ROLLUP(a.suburb, to_char(p.property_date_added,'mm') || to_char(p.property_date_added,'yy'),ad.advert_name)
order by a.suburb;


--VERSION 2 REPORT 7
--total number of sales from each suburb, time period and advertisement type using partial rollup
SELECT a.suburb, to_char(p.property_date_added,'mm') || to_char(p.property_date_added,'yy') as month_year_id ,ad.advert_name ,  SUM(no_of_sales)
as SALES_COUNT
FROM sale_fact_v2 f,address_dim_v2 a, advert_dim_v2 ad, property_dim_v2 p
WHERE f.postcode = a.postcode and
f.advert_id = ad.advert_id and
f.property_id = p.property_id
GROUP BY a.suburb, ROLLUP(to_char(p.property_date_added,'mm') || to_char(p.property_date_added,'yy'),ad.advert_name)
order by a.suburb;




