
--CREATING STAR SCHEMA VERSION 1 Level 2 Aggregation
drop table gender_dim_v1;
drop table budget_dim_v1;
drop table season_dim_v1;
drop table location_dim_v1;
drop table visit_day_dim_v1;
drop table state_dim_v1;
drop table office_size_dim_v1;
drop table feature_type_dim_v1;
drop table property_scale_dim_v1;
drop table property_type_dim_v1;
drop table property_dim_v1;
drop table property_feature_bridge_dim_v1;
drop table feature_dim_v1;
drop table property_advert_bridge_dim_v1;
drop table advert_dim_v1;
drop table client_dim_v1;
drop table client_feature_bridge_dim_v1;
drop table client_tempfact;
drop table client_fact_v1;
drop table time_dim_v1;
drop table property_visit_tempfact;
drop table property_visit_fact_v1;
drop table rent_tempfact;
drop table rent_fact_v1;
drop table sale_tempfact;
drop table sale_fact_v1;
drop table property_dim_v1;
drop table property_feature_bridge_dim_v1;
drop table feaure_dim_v1;
drop table agent_tempfact;
drop table agent_fact_v1;
drop table rental_period_dim_v1;
drop table rent_price_dim_v1;
drop table office_dim_v1;
drop table agent_dim_v1;
drop table agent_office_bridge_dim_v1;


--creating gender dim
create table gender_dim_v1
( gender_id varchar2(30));
  
--inserting values in gender dim  
insert into gender_dim_v1 values('male');
insert into gender_dim_v1 values('female');

--creating budget dim
create table budget_dim_v1
( budget_id varchar(30),
  budget_description varchar2(30));
  
--inserting values in budget dim  
insert into budget_dim_v1 values ('low','0 to 1000');
insert into budget_dim_v1 values ('medium','1001 to 100000');
insert into budget_dim_v1 values ('high','100001 to 10000000');


--creating season dim
create table season_dim_v1
( season varchar2(30),
  season_description varchar2(30));

--inserting values in season dim
insert into season_dim_v1 values('winter','june-july-august');
insert into season_dim_v1 values('summer','dec-jan-feb');
insert into season_dim_v1 values('autum','march-april-may');
insert into season_dim_v1 values('spring','sept-oct-nov');

--creating location dim
create table location_dim_v1 as select a.postcode,a.suburb,p.state_code
from clean_address a, clean_postcode p
where p.postcode=a.postcode;

--creating visit day dim
create table visit_day_dim_v1 
( visit_day_id varchar(30));

--inserting values in visit day dim  
insert into visit_day_dim_v1 values('monday');
insert into visit_day_dim_v1 values('tuesday');
insert into visit_day_dim_v1 values('wednesday');
insert into visit_day_dim_v1 values('thursday');
insert into visit_day_dim_v1 values('friday');
insert into visit_day_dim_v1 values('saturday');
insert into visit_day_dim_v1 values('sunday');

--creating state dim 
create table state_dim_v1 as select state_code,state_name
from clean_state;

--creating office size dim
create table office_size_dim_v1
( office_size_id varchar2(30),
  size_description varchar2(30));

--creating office size dim  
insert into office_size_dim_v1 values ('small','less than 4 employess');
insert into office_size_dim_v1 values ('medium','4 - 12 employess');
insert into office_size_dim_v1 values ('large','more than 12 employess');

--creating feature type dim
create table feature_type_dim_v1
( feature_type_id varchar2(30),
 feature_description varchar(30));

--inserting values in feature type dim 
insert into feature_type_dim_v1 values ('basic',' less than 10 features');
insert into feature_type_dim_v1 values ('standard ','10-20 features');
insert into feature_type_dim_v1 values ('luxurious',' more than 20 features');

--creating property scale dim
create table property_scale_dim_v1
( property_scale_id varchar2(30),
 property_scale_description varchar(30));

--inseting values in property scale dim 
insert into property_scale_dim_v1 values ('extra small',' <= 1 bedroom');
insert into property_scale_dim_v1 values ('small ','2-3 bedrooms');
insert into property_scale_dim_v1 values ('medium',' 3-6 bedrooms');
insert into property_scale_dim_v1 values ('large',' 6-10 bedrooms');
insert into property_scale_dim_v1 values ('extra large','> 10 bedrooms');

--creating table property type dim
create table property_type_dim_v1 as select distinct property_type,property_description
from clean_property;

--creating property_dim
create table property_dim_v1 as select distinct property_id from clean_property;

--creating property feature bridge dim
create table property_feature_bridge_dim_v1 as select * from clean_property_feature;


--creating feature dim
create table feature_dim_v1 as select distinct * from clean_feature;

--creating advert dim
create table advert_dim_v1 as select distinct * from clean_advertisement;

--creating client dim
create table client_dim_v1 as select person_id from clean_client;

--creating client feature bridge dim 
create table client_feature_bridge_dim_v1 as select FEATURE_CODE as feature_type_id, person_id from clean_client_wish;

--creating client tempfact
create table client_tempfact as select c.person_id, p.gender as gender_id,c.max_budget,c.min_budget from clean_person p , clean_client c
where p.person_id=c.person_id;

--adding columns to client temp fact
alter table client_tempfact add(budget_id varchar(30));

update client_tempfact set budget_id ='low' where max_budget <= 1000;
update client_tempfact set budget_id ='medium' where max_budget >1000 and max_budget<= 100000;
update client_tempfact set budget_id ='high' where max_budget >100000 and max_budget<=10000000;


--creating client fact
create table client_fact_v1 as select person_id,gender_id,budget_id, count(person_id) as no_of_clients from client_tempfact
group by gender_id,budget_id,person_id;

--creating time dim
create table time_dim_v1 as select distinct to_char(visit_date,'mm') || to_char(visit_date,'yy') as month_year_id,to_char(visit_date,'mm') as month,to_char(visit_date,'yy') as year from clean_visit
union select distinct to_char(rent_start_date,'mm') || to_char(rent_start_date,'yy') as month_year_id,to_char(rent_start_date,'mm') as month,to_char(rent_start_date,'yy') as year from clean_rent union
select distinct to_char(rent_end_date,'mm') || to_char(rent_end_date,'yy') as month_year_id,to_char(rent_end_date,'mm') as month,to_char(rent_end_date,'yy') as year from clean_rent union
select distinct  to_char(sale_date,'mm') || to_char(sale_date,'yy') as month_year_id,to_char(sale_date,'mm') as month,to_char(sale_date,'yy') as year  from clean_sale;


--creating property visit temp fact
create table property_visit_tempfact as select v.client_person_id,v.agent_person_id,
count(v.property_id) as no_of_visits,TO_date(v.visit_date,'dd-mon-yy') AS visit_date,a.postcode from clean_visit v,clean_property p,clean_address a
where p.property_id=v.property_id and a.address_id=p.address_id
group by v.client_person_id,v.agent_person_id,TO_date(v.visit_date,'dd-mon-yy'),a.postcode;

--altering the visit temp fat
alter table property_visit_tempfact add(season varchar(30), month_year_id varchar(30),visit_day_id varchar(30));

--updating the visit temp fact
update property_visit_tempfact 
set month_year_id =  to_char(visit_date,'mm') ||  to_char(visit_date,'yy');

UPDATE property_visit_tempfact
SET
season = 'summer'
WHERE
TO_CHAR(visit_date, 'mon') IN (
'dec',
'jan',
'feb'
);

UPDATE property_visit_tempfact
SET
season = 'winter'
WHERE
TO_CHAR(visit_date, 'mon') IN (
'jun',
'jul',
'aug'
);

UPDATE property_visit_tempfact
SET
season = 'spring'
WHERE
TO_CHAR(visit_date, 'mon') IN (
'sep',
'oct',
'nov'
);

UPDATE property_visit_tempfact
SET
season = 'autum'
WHERE
TO_CHAR(visit_date, 'mon') IN (
'mar',
'apr',
'may'
);

UPDATE property_visit_tempfact
SET
visit_day_id = 'monday'
WHERE
TO_CHAR(visit_date, 'DAY') like '%MONDAY%';

UPDATE property_visit_tempfact
SET
visit_day_id = 'tuesday'
WHERE
TO_CHAR(visit_date, 'DAY') like '%TUESDAY%';


UPDATE property_visit_tempfact
SET
visit_day_id = 'wednesday'
WHERE
TO_CHAR(visit_date, 'DAY') like '%WEDNESDAY%';

UPDATE property_visit_tempfact
SET
visit_day_id = 'thursday'
WHERE
TO_CHAR(visit_date, 'DAY') like '%THURSDAY%';

UPDATE property_visit_tempfact
SET
visit_day_id = 'friday'
WHERE
TO_CHAR(visit_date, 'DAY') like '%FRIDAY%';

UPDATE property_visit_tempfact
SET
visit_day_id = 'saturday'
WHERE
TO_CHAR(visit_date, 'DAY') like '%SATURDAY%';


UPDATE property_visit_tempfact
SET
visit_day_id = 'sunday'
WHERE
TO_CHAR(visit_date, 'DAY') like '%SUNDAY%';

--ceating property visit fact
create table property_visit_fact_v1 as select month_year_id,season,visit_day_id,no_of_visits,sum(no_of_visits) as sum_of_visits
from property_visit_tempfact 
group by month_year_id,season,visit_day_id,no_of_visits;

--creating rental period dim
create table rental_period_dim_v1 
( rental_period_type_id varchar2(30),
  rental_description varchar2(30));
  
--inserting values in rental period dim
insert into rental_period_dim_v1 values ('short','< 6 months');
insert into rental_period_dim_v1 values ('medium','6-12 months');
insert into rental_period_dim_v1 values ('large','> 12 months');

--creating rent temp fact
create table rent_tempfact as select t.rent_id, p.property_id, p.property_no_of_bedrooms,p.property_type,f.feature_code,t.price,a.postcode,to_date(t.rent_start_date,'dd-mm-yy') as start_date,to_date(t.rent_end_date,'dd-mm-yy') as end_date
from clean_rent t,
clean_property p,clean_property_feature f, clean_address a where 
p.property_id=t.property_id and
p.property_id=f.property_id and 
p.address_id=a.address_id;

--altering rent temp fact
alter table rent_tempfact add(feature_type_id varchar(30), property_scale_id varchar(30),calc_price number(20,2),month_year_id varchar(30),rental_period_type_id varchar(30));


--updating rent temp fact
update  rent_tempfact set feature_type_id ='very basic' where property_id in (select property_id from monre.property_feature group by property_id having count(*) < 10);
update  rent_tempfact set feature_type_id ='standard' where property_id in (select property_id from monre.property_feature group by property_id having count(*) between 11 and 20);
update  rent_tempfact set feature_type_id ='luxurious' where property_id in (select property_id from monre.property_feature group by property_id having count(*) > 20);

update rent_tempfact set property_scale_id ='extra small' where property_no_of_bedrooms <= 1;
update rent_tempfact set property_scale_id ='small' where property_no_of_bedrooms > 1 and property_no_of_bedrooms <=2;
update rent_tempfact set property_scale_id ='medium' where property_no_of_bedrooms > 2 and property_no_of_bedrooms <=6;
update rent_tempfact  set property_scale_id ='large' where property_no_of_bedrooms > 6 and property_no_of_bedrooms <=10;
update rent_tempfact  set property_scale_id ='extra large' where property_no_of_bedrooms > 10;


update rent_tempfact  set calc_price = (to_date(end_date,'dd-mon-yy') - to_date(start_date,'dd-mon-yy')) /7 * price;

update rent_tempfact set rental_period_type_id = 'short' where (to_date(end_date,'dd-mon-yy') - to_date(start_date,'dd-mon-yy'))/30 <= 6 ;
update rent_tempfact set rental_period_type_id = 'medium' where (to_date(end_date,'dd-mon-yy') - to_date(start_date,'dd-mon-yy'))/30 between 7 and 12 ;
update rent_tempfact set rental_period_type_id = 'large' where (to_date(end_date,'dd-mon-yy') - to_date(start_date,'dd-mon-yy'))/30 > 12 ;

update rent_tempfact 
set month_year_id =  to_char(start_date,'mm') ||  to_char(start_date,'yy');
--creating temporal dim (rent_price_dim) to store history price of properties being rented
create table rent_price_dim_v1 as select rent_id,to_date(rent_start_date,'dd-mm-yy') as rent_start_date,to_date(rent_end_date,'dd-mm-yy') as rent_end_date, price from clean_rent;

--creating rent fact
create table rent_fact_v1 as select month_year_id,postcode,rent_id, property_id, property_type , feature_type_id, property_scale_id,rental_period_type_id, count(rent_id) as no_of_rent,
sum(calc_price) as sum_of_rent from rent_tempfact
group by  month_year_id,postcode,rent_id, property_id, property_type , feature_type_id, property_scale_id,rental_period_type_id;

--creating table sale temp fact
create table sale_tempfact as select to_date(p.property_date_added,'dd-mm-yy') as advertised_date ,p.property_id,s.sale_id,
a.postcode,d.advert_id,p.property_type ,s.price,s.sale_date from 
clean_property p, clean_address a, clean_sale s , clean_property_advert d where 
p.property_id=s.property_id and
s.property_id=d.property_id and 
p.address_id=a.address_id;

alter table sale_tempfact add(month_year_id varchar(30));

update sale_tempfact set month_year_id = (to_char(advertised_date,'mm') || to_char(advertised_date,'yy'));

--creating sale fact
create table sale_fact_v1 as select month_year_id,postcode,property_id,property_type,advert_id,count(sale_id) as no_of_sales,sum(price) as sum_of_sale 
from sale_tempfact group by month_year_id,postcode,property_id,property_type,advert_id;

--creating feature dim
create table feaure_dim_v1 as select distinct * from clean_feature;

--creating office dim  dim
create table office_dim_v1 as select distinct * from clean_office;

--creating agent dim
create table agent_dim_v1 as select person_id as agent_id from clean_agent;

--creating agent office bridge dim
create table agent_office_bridge_dim_v1 as select person_id as agent_id , office_id from clean_agent_office;

--creating agent temp fact
create table agent_tempfact as select g.person_id as agent_id ,g.salary,a.postcode,o.office_id,p.gender as gender_id
from clean_agent g, clean_agent_office o,clean_person p, clean_address a
where p.person_id=o.person_id and
p.person_id=g.person_id and
p.address_id=a.address_id;


--altering the table agent temp fact
alter table agent_tempfact add(office_size_id varchar(30));

--updating the agent temp fact
update agent_tempfact set office_size_id ='small' where office_id in (select office_id from monre.agent_office group by office_id having count(*) <= 4 );
update agent_tempfact set office_size_id ='medium' where office_id in (select office_id from monre.agent_office group by office_id having count(*) between 5 and 12 );
update agent_tempfact set office_size_id ='large' where office_id in (select office_id from monre.agent_office group by office_id having  count(*) > 12);

--creating table agent fact
create table agent_fact_v1
as select postcode , agent_id , gender_id ,office_size_id , sum(salary) as sum_salary, count(agent_id) as no_of_agent
from agent_tempfact
group by postcode ,  agent_id ,gender_id , office_size_id ;



--CREATING STAR SCHEMA VERSION 2 LEVEL 0 AGGREGATION

drop table gender_dim_v2;
drop table season_dim_v2;
drop table property_visit_fact_v2;
drop table visit_dim_v2;
drop table address_dim_v2;
drop table client_feature_bridge_v2;
drop table feature_type_dim_v2;
drop table client_dim_v2;
drop table client_fact_v2;
drop table agent_fact_v2;
drop table rent_fact_v2;
drop table property_dim_v2;
drop table sale_fact_v2;
drop table sale_dim_v2;
drop table agent_dim_v2;
drop table rent_dim_v2;
drop table property_scale_dim_v2;
drop table property_feature_bridge_dim_v2;
drop table advert_dim_v2;
drop table agent_office_bridge_dim_v2;
drop table office_dim_v2;
drop table feature_dim_v2;
drop table visit_tempdim_v2;
drop table client_tempfact_v2;
drop table property_visit_tempfact_v2;
drop table rent_tempfact_v2;
drop table sale_tempfact_v2;
drop table agent_tempfact_v2;
drop table client_feature_bridge_dim_v2;
drop table agent_fact_dim_v2;




--creating gender dim
create table gender_dim_v2
( gender_id varchar2(30));

insert into gender_dim_v2 values('Male');
insert into gender_dim_v2 values('Female');

--creating client dim version 2
create table client_dim_v2 as select person_id,min_budget,max_budget from clean_client;


--creating visit temp dim
create table visit_tempdim_v2 as select client_person_id,agent_person_id,property_id,to_date(visit_date,'dd-mm-yy') as visit_date ,
duration from clean_visit;

--altering visit temp dim
alter table visit_tempdim_v2 add (visit_day varchar2(30));

--updating the visit temp dim
UPDATE visit_tempdim_v2
SET
visit_day = 'monday'
WHERE
TO_CHAR(visit_date, 'DAY') like '%MONDAY%';

UPDATE visit_tempdim_v2
SET
visit_day = 'tuesday'
WHERE
TO_CHAR(visit_date, 'DAY') like '%TUESDAY%';


UPDATE visit_tempdim_v2
SET
visit_day = 'wednesday'
WHERE
TO_CHAR(visit_date, 'DAY') like '%WEDNESDAY%';

UPDATE visit_tempdim_v2
SET
visit_day = 'thursday'
WHERE
TO_CHAR(visit_date, 'DAY') like '%THURSDAY%';

UPDATE visit_tempdim_v2
SET
visit_day = 'friday'
WHERE
TO_CHAR(visit_date, 'DAY') like '%FRIDAY%';

UPDATE visit_tempdim_v2
SET
visit_day = 'saturday'
WHERE
TO_CHAR(visit_date, 'DAY') like '%SATURDAY%';


UPDATE visit_tempdim_v2
SET
visit_day = 'sunday'
WHERE
TO_CHAR(visit_date, 'DAY') like '%SUNDAY%';

--creating visit dim version 2
create table visit_dim_v2 as select client_person_id,agent_person_id,property_id,visit_day,to_date(visit_date,'dd-mm-yy') as visit_date
from visit_tempdim_v2;

--creating address dim version 2
create table address_dim_v2 as select a.postcode, a.suburb,s.state_code,s.state_name
from clean_address a,clean_state s,clean_postcode p
where a.postcode=p.postcode and
s.state_code=p.state_code;

--creating agent dim version 2
create table agent_dim_v2 as select person_id as agent_id,salary from clean_agent;

--creating agent office bridge   dim version 2
create table agent_office_bridge_dim_v2 as select person_id as agent_id , office_id from clean_agent_office;

--creating office dim version 2
create table office_dim_v2 as select distinct o.office_id,office_name,count(person_id) as no_of_employees from clean_agent_office a,clean_office o
where o.office_id=a.office_id
group by o.office_id,office_name;

--creating rent dim version 2
create table rent_dim_v2 as select rent_id,agent_person_id,client_person_id,property_id,rent_start_date,rent_end_date,price
from clean_rent;

--creating property_dim version 2
create table property_dim_v2 as select property_id,address_id,property_type,property_no_of_bedrooms,property_no_of_bathrooms,property_no_of_garages,
property_size,property_description,property_date_added from clean_property;

--creating property feature bridge dim version 2
create table property_feature_bridge_dim_v2 as select * from clean_property_feature;


--creating feature dim version 2
create table feature_dim_v2 as select distinct * from clean_feature;

--creating advert dim
create table advert_dim_v2 as select distinct * from clean_advertisement;

--creating property scale dim version 2
create table property_scale_dim_v2
( property_scale_id varchar2(30),
 property_scale_description varchar(30));

--inseting values in property scale dim 
insert into property_scale_dim_v2 values ('extra small',' <= 1 bedroom');
insert into property_scale_dim_v2 values ('small ','2-3 bedrooms');
insert into property_scale_dim_v2 values ('medium',' 3-6 bedrooms');
insert into property_scale_dim_v2 values ('large',' 6-10 bedrooms');
insert into property_scale_dim_v2 values ('extra large','> 10 bedrooms');


create table season_dim_v2
( season varchar2(30),
  season_description varchar2(30));

--inserting values in season dim
insert into season_dim_v2 values('winter','june-july-august');
insert into season_dim_v2 values('summer','dec-jan-feb');
insert into season_dim_v2 values('autum','march-april-may');
insert into season_dim_v2 values('spring','sept-oct-nov');

--creating client tempfact version 2
create table client_tempfact_v2 as select c.person_id, p.gender as gender_id,c.max_budget,c.min_budget from clean_person p , clean_client c
where p.person_id=c.person_id;

--creating client fact version 2
create table client_fact_v2 as select person_id,gender_id,count(person_id) as no_of_clients from client_tempfact_v2
group by gender_id,person_id;

--creating property visit temp fact
create table property_visit_tempfact_v2 as select v.client_person_id,v.property_id,v.agent_person_id,a.postcode,
count(v.property_id) as no_of_visits,TO_date(v.visit_date,'dd-mon-yy') AS visit_date from clean_visit v,clean_property p,clean_address a
where p.property_id=v.property_id and a.address_id=p.address_id
group by v.client_person_id,v.property_id,v.agent_person_id,TO_date(v.visit_date,'dd-mon-yy'),a.postcode;

--altering the visit temp fact
alter table property_visit_tempfact_v2 add(season varchar(30));


UPDATE property_visit_tempfact_v2
SET
season = 'summer'
WHERE
TO_CHAR(visit_date, 'mon') IN (
'dec',
'jan',
'feb'
);

UPDATE property_visit_tempfact_v2
SET
season = 'winter'
WHERE
TO_CHAR(visit_date, 'mon') IN (
'jun',
'jul',
'aug'
);

UPDATE property_visit_tempfact_v2
SET
season = 'spring'
WHERE
TO_CHAR(visit_date, 'mon') IN (
'sep',
'oct',
'nov'
);

UPDATE property_visit_tempfact_v2
SET
season = 'autum'
WHERE
TO_CHAR(visit_date, 'mon') IN (
'mar',
'apr',
'may'
);


--ceating property visit fact
create table property_visit_fact_v2 as select postcode,property_id,client_person_id,agent_person_id,season,
to_date(visit_date,'dd-mm-yy') as visit_date,no_of_visits,sum(no_of_visits) as sum_of_visits
from property_visit_tempfact_v2 
group by  postcode,property_id,client_person_id,agent_person_id,season,
to_date(visit_date,'dd-mm-yy'),no_of_visits;

--creating rent temp fact
create table rent_tempfact_v2 as select t.rent_id, p.property_id, p.property_no_of_bedrooms,f.feature_code,a.postcode,t.price,to_date(t.rent_start_date,'dd-mm-yy') as start_date,to_date(t.rent_end_date,'dd-mm-yy') as end_date
from clean_rent t,
clean_property p,clean_property_feature f , clean_address a where 
p.property_id=t.property_id and
p.property_id=f.property_id and
p.address_id = a.address_id;

--altering rent temp fact
alter table rent_tempfact_v2 add(feature_type_id varchar(30), property_scale_id varchar(30),calc_price number(20,2));


--updating rent temp fact
update  rent_tempfact_v2 set feature_type_id ='very basic' where property_id in (select property_id from monre.property_feature group by property_id having count(*) < 10);
update  rent_tempfact_v2 set feature_type_id ='standard' where property_id in (select property_id from monre.property_feature group by property_id having count(*) between 11 and 20);
update  rent_tempfact_v2 set feature_type_id ='luxurious' where property_id in (select property_id from monre.property_feature group by property_id having count(*) > 20);

update rent_tempfact_v2 set property_scale_id ='extra small' where property_no_of_bedrooms <= 1;
update rent_tempfact_v2 set property_scale_id ='small' where property_no_of_bedrooms > 1 and property_no_of_bedrooms <=2;
update rent_tempfact_v2 set property_scale_id ='medium' where property_no_of_bedrooms > 2 and property_no_of_bedrooms <=6;
update rent_tempfact_v2 set property_scale_id ='large' where property_no_of_bedrooms > 6 and property_no_of_bedrooms <=10;
update rent_tempfact_v2 set property_scale_id ='extra large' where property_no_of_bedrooms > 10;


update rent_tempfact_v2  set calc_price = (to_date(end_date,'dd-mon-yy') - to_date(start_date,'dd-mon-yy')) /7 * price;

--creating rent fact
create table rent_fact_v2 as select postcode,rent_id, property_id, property_scale_id,feature_type_id, count(rent_id) as no_of_rent,
sum(calc_price) as sum_of_rent from rent_tempfact_v2
group by postcode,rent_id, property_id, property_scale_id,feature_type_id;


--creating table sale temp fact
create table sale_tempfact_v2 as select p.property_id,s.sale_id,
a.postcode,d.advert_id,s.price from 
clean_property p, clean_address a, clean_sale s , clean_property_advert d where 
p.property_id=s.property_id and
s.property_id=d.property_id and 
p.address_id=a.address_id;


--creating sale fact
create table sale_fact_v2 as select postcode,property_id,sale_id,advert_id,count(sale_id) as no_of_sales,sum(price) as sum_of_sale 
from sale_tempfact_v2 group by postcode,property_id,sale_id,advert_id;

--creating sale dim version 2
create table sale_dim_v2 as select * from clean_sale;

--creating agent tempfact version 2
create table agent_tempfact_v2 as select a.postcode,a.salary ,a.person_id as agent_id,gender as gender_id
from clean_agent a,clean_address a,clean_person p
where p.person_id=a.person_id and
a.address_id=p.address_id;

--creating agent fact dim 
create table agent_fact_v2 as select postcode,agent_id,gender_id,count(agent_id) as no_of_agent,sum(salary) as sum_salary
from agent_tempfact_v2 group by postcode,agent_id,gender_id;

--creating client feature bridge dim 
create table client_feature_bridge_dim_v2 as select FEATURE_CODE as feature_type_id, person_id from clean_client_wish;


--creating feature type dim
create table feature_type_dim_v2
( feature_type_id varchar2(30),
 feature_description varchar(30));

--inserting values in feature type dim 
insert into feature_type_dim_v2 values ('basic',' less than 4 features');
insert into feature_type_dim_v2 values ('standard ','10-20 features');
insert into feature_type_dim_v2 values ('luxurious',' more than 20 features');



COMMIT;


