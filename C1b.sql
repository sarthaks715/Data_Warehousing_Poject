drop table  clean_address;
drop table  clean_advertisement;
drop table  clean_agent; 
drop table  clean_agent_office; 
drop table  clean_client_wish;
drop table  clean_feature; 
drop table  clean_office;
drop table  clean_person ; 
drop table  clean_postcode;
drop table  clean_property; 
drop table  clean_property_advert;
drop table clean_property_feature;
drop table  clean_rent ; 
drop table  clean_sale  ;
drop table  clean_state;
drop table clean_visit ; 
drop table clean_client;




--Exploring all tables


----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
--Table - MonRE.address
--0 errors removed

--To check if an address_id is repeated twice SQL query used is - 
SELECT address_id , count(*)
FROM monre.address
GROUP BY address_id 
HAVING COUNT(*) > 1;
--no error seen

--To check if a street is repeated twice SQL query used is - 
SELECT street, suburb,postcode, count(*)
FROM monre.address
GROUP BY street,suburb,postcode
HAVING COUNT(*) > 1;
--no error seen

--To check for null values in each column and values that are filled as ‘null’ , SQL query used is -
select * from monre.address where address_id like 'null';     
select * from monre.address where address_id is null;

select * from monre.address where street like 'null';     
select * from monre.address where street is null;


select * from monre.address where suburb like 'null';     
select * from monre.address where suburb is null;


select * from monre.address where postcode like 'null';     
select * from monre.address where postcode is null;
--no error seen

--To check if the postcode written in the monre.address table rows actually exist in the monre.postcode table, SQL query used is -

select postcode from monre.address where postcode not in (select postcode from monre.postcode);
--no error seen


--To check out of range or invalid values in each column, the SQL query used is -

select * from monre.address order by address_id desc;
select * from monre.address order by address_id ;

select * from monre.address order by street desc;
select * from monre.address order by street;

select * from monre.address order by suburb desc;
select * from monre.address order by suburb;

select * from monre.address order by postcode desc;
select * from monre.address order by postcode ;
--no error seen

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

--Table - MonRE.agent
--2 errors removed

--To check if an person_id is repeated twice SQL query used is - 
SELECT person_id , count(*)
FROM monre.agent
GROUP BY person_id 
HAVING COUNT(*) > 1;

--no errors seen

--To check for null values in each column and values that are filled as ‘null’ , SQL query used is -
select * from monre.agent  where person_id like 'null';     
select * from monre.agent where person_id is null;

select * from monre.agent where salary like 'null';     
select * from monre.agent where salary is null;

--no errors seen

--To check if the person_id written in the monre.agent table rows actually exist in the monre.person table, SQL query used is -
select person_id from monre.agent where person_id not in (select person_id from monre.person);

--error seen
--removing error below
create table clean_agent as select * from monre.agent;
delete from clean_agent where person_id not in (select person_id from monre.person);

--To check out of range or invalid values in each column, the SQL query used is -

select * from monre.agent order by person_id desc;
select * from monre.agent order by person_id ;

select * from monre.agent order by salary desc;
select * from monre.agent order by salary;
--error seen
--removing error below
delete from clean_agent where salary <= 0;

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
--Table - MonRE.agent_office
--1 error removed

--To check if a person_id is repeated twice SQL query used is - 
SELECT person_id , count(*)
FROM monre.agent_office
GROUP BY person_id 
HAVING COUNT(*) > 1;
--no error seen

--To check if an office_id is repeated twice SQL query used is - 
SELECT office_id , count(*)
FROM monre.agent_office
GROUP BY office_id 
HAVING COUNT(*) > 1;
--no error seen

--To check for null values in each column and values that are filled as ‘null’ , SQL query used is -
select * from monre.agent_office  where person_id like 'null';     
select * from monre.agent_office where person_id is null;

select * from monre.agent_office where office_id like 'null';     
select * from monre.agent_office where office_id is null;
--no error seen

--To check if the person_id written in the monre.agent_office table rows actually exist in the monre.person table, SQL query used is -

select person_id from monre.agent_office where person_id not in (select person_id from monre.person);

--error seen
--error removed below
create table clean_agent_office as select * from monre.agent_office;
delete from clean_agent_office where person_id not in (select person_id from monre.person);

--To check if the office_id written in the monre.agent_office table rows actually exist in the monre.office table, SQL query used is -

select office_id from monre.agent_office where office_id not in (select office_id from monre.office);
--no error seen

--To check out of range or invalid values in each column, the SQL query used is -

select * from monre.agent_office order by person_id desc;
select * from monre.agent_office order by person_id ;

select * from monre.agent_office order by office_id desc;
select * from monre.agent_office order by office_id ;
--no error seen

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

--Table - MonRE.client
--3 error removed

--To check if a person_id is repeated twice SQL query used is - 
SELECT person_id , count(*)
FROM monre.client
GROUP BY person_id 
HAVING COUNT(*) > 1;
--no error seen

--To check for null values in each column and values that are filled as ‘null’ , SQL query used is -
select * from monre.client  where person_id like 'null';     
select * from monre.client where person_id is null;

select * from monre.client where max_budget like 'null';     
select * from monre.client where max_budget is null;

select * from monre.client where min_budget like 'null';     
select * from monre.client where min_budget is null;
--no error seen

--To check if the person_id written in the monre.client table rows actually exist in the monre.person table, SQL query used is -

select person_id from monre.client where person_id not in (select person_id from monre.person);
--error seen
--error removed below


create table clean_client as select * from monre.client;
delete from clean_client where person_id not in (select person_id from monre.person);

--To check out of range or invalid values in each column, the SQL query used is -

select * from monre.client order by person_id desc;
select * from monre.client order by person_id ;

select * from monre.client order by max_budget desc;
select * from monre.client order by max_budget ;

select * from monre.client order by min_budget desc;
select * from monre.client order by min_budget ;
--error seen
--error removed below

delete from clean_client where max_budget < 0 or min_budget < 0;

--For comparison of max_budget and min_budget, the SQL query used is -

select * from monre.client where max_budget < min_budget;
--error seen
--error removed below

delete from clean_client where max_budget < min_budget ;

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

--Table - MonRE.client_wish
--0 error removed

--To check if a feature_code is repeated twice SQL query used is - 
SELECT feature_code , count(*)
FROM monre.client_wish
GROUP BY feature_code 
HAVING COUNT(*) > 1;
--no error seen

--To check if a person_id is repeated twice SQL query used is - 
SELECT person_id , count(*)
FROM monre.client_wish
GROUP BY person_id 
HAVING COUNT(*) > 1;
--no error seen

--To check for null values in each column and values that are filled as ‘null’ , SQL query used is -
select * from monre.client_wish  where person_id like 'null';     
select * from monre.client_wish where person_id is null;

select * from monre.client_wish where feature_code like 'null';     
select * from monre.client_wish where feature_code is null;
--no error seen

--To check if the person_id written in the monre.client_wish table rows actually exist in the monre.person table, SQL query used is -

select person_id from monre.client_wish where person_id not in (select person_id from monre.person);
--no error seen

--To check if the feature_code written in the monre.client_wish table rows actually exist in the monre.feature table, SQL query used is -

select feature_code from monre.client_wish where feature_code not in (select feature_code from monre.feature);
--no error seen

--To check out of range or invalid values in each column, the SQL query used is -

select * from monre.client_wish order by person_id desc;
select * from monre.client_wish order by person_id ;

select * from monre.client_wish order by feature_code desc;
select * from monre.client_wish order by feature_code ;
--no error seen

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

--Table - MonRE.feature
--1 error removed

--To check if a feature_code is repeated twice SQL query used is - 
SELECT feature_code , count(*)
FROM monre.feature
GROUP BY feature_code 
HAVING COUNT(*) > 1;
--no error seen

--To check if a feature_description is repeated twice SQL query used is - 

SELECT feature_description , count(*)
FROM monre.feature
GROUP BY feature_description 
HAVING COUNT(*) > 1;
--no error seen

--To check for null values in each column and values that are filled as ‘null’ , SQL query used is -
select * from monre.feature  where feature_description like 'null';     
select * from monre.feature where feature_description is null;

select * from monre.feature where feature_code like 'null';     
select * from monre.feature where feature_code is null;
--no error seen


--To check out of range or invalid values in each column, the SQL query used is -

select * from monre.feature order by feature_description desc;
select * from monre.feature order by feature_description ;

select * from monre.feature order by feature_code desc;
select * from monre.feature order by feature_code ;

--error seen
--error removed below


create table clean_feature as select * from monre.feature;
delete from clean_feature where feature_code = 726 or feature_code = 420;

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

--Table - MonRE.office
--0 error removed

--To check if an office_id is repeated twice SQL query used is - 
SELECT office_id , count(*)
FROM monre.office
GROUP BY office_id 
HAVING COUNT(*) > 1;
--no error seen

--To check if an office_name is repeated twice SQL query used is - 
SELECT office_name , count(*)
FROM monre.office
GROUP BY office_name 
HAVING COUNT(*) > 1;
--no error seen


--To check for null values in each column and values that are filled as ‘null’ , SQL query used is -
select * from monre.office  where office_id like 'null';     
select * from monre.office where office_id is null;

select * from monre.office where office_name like 'null';     
select * from monre.office where office_name is null;
--no error seen

--To check out of range or invalid values in each column, the SQL query used is -

select * from monre.office order by office_id desc;
select * from monre.office order by office_id ;

select * from monre.office order by office_name desc;
select * from monre.office order by office_name;
--no error seen

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

--Table - MonRE.person
--2 error removed

--To check if a person_id is repeated twice SQL query used is - 
SELECT person_id , count(*)
FROM monre.person
GROUP BY person_id 
HAVING COUNT(*) > 1;
--error seen
--error removed below


create table clean_person as select distinct * from monre.person;

--To check if an address_id is repeated twice SQL query used is - 
SELECT address_id , count(*)
FROM monre.person
GROUP BY address_id 
HAVING COUNT(*) > 1;
--error seen which was removed above only

--To check if the gender lies within Male and Female values only,SQL query used is - 

select * from monre.person where gender not in ('Male','Female');
--no error seen

--To check if the titles of the names lies within Mr,Mrs,Ms and Dr,,SQL query used is - 

select * from monre.person where title not in ('Ms','Mrs','Mr','Dr');
--no error seen

--To check if the address_id written in the monre.person table rows actually exist in the monre.address table, SQL query used is -

select address_id from monre.person where address_id not in (select address_id from monre.address);
--error seen
--error removed below

delete from clean_person where address_id not in (select address_id from monre.address);

--To check for null values in each column and values that are filled as ‘null’ , SQL query used is -
select * from monre.person  where person_id like 'null';     
select * from monre.person where person_id  is null;

select * from monre.person  where title like 'null';     
select * from monre.person where title is null;

select * from monre.person  where first_name like 'null';     
select * from monre.person where first_name is null;

select * from monre.person  where last_name like 'null';     
select * from monre.person where last_name  is null;

select * from monre.person  where gender like 'null';     
select * from monre.person where gender is null;

select * from monre.person  where address_id like 'null';     
select * from monre.person where address_id is null;

select * from monre.person  where phone_no like 'null';     
select * from monre.person where phone_no is null;

select * from monre.person  where email like 'null';     
select * from monre.person where email is null;
--no error seen

--To check out of range or invalid values in each column, the SQL query used is -

select * from monre.person order by person_id desc;
select * from monre.person order by person_id ;

select * from monre.person  order by title desc;
select * from monre.person order by title;

select * from monre.person order by first_name desc;
select * from monre.person order by first_name ;

select * from monre.person  order by last_name desc;
select * from monre.person order by last_name;

select * from monre.person order by gender desc;
select * from monre.person order by gender ;

select * from monre.person  order by address_id desc;
select * from monre.person order by address_id;

select * from monre.person order by phone_no desc;
select * from monre.person order by phone_no ;

select * from monre.person  order by email desc;
select * from monre.person order by email;
--no error seen

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

--Table - MonRE.postcode
--0 error removed

--To check if a postcode is repeated twice SQL query used is - 
SELECT postcode , count(*)
FROM monre.postcode 
GROUP BY postcode 
HAVING COUNT(*) > 1;
--no error seen

--To check if an state_code is repeated twice SQL query used is - 
SELECT state_code , count(*)
FROM monre.postcode
GROUP BY state_code 
HAVING COUNT(*) > 1;

--no error seen

--To check if the state_code written in the monre.postcode table rows actually exist in the monre.state table, SQL query used is -

select state_code from monre.postcode where state_code not in (select state_code from monre.state);

--no error seen

--To check for null values in each column and values that are filled as ‘null’ , SQL query used is -
select * from monre.postcode  where postcode like 'null';     
select * from monre.postcode where postcode  is null;

select * from monre.postcode  where state_code like 'null';     
select * from monre.postcode where state_code is null;

--no error seen


--To check out of range or invalid values in each column, the SQL query used is -

select * from monre.postcode order by postcode desc;
select * from monre.postcode order by postcode ;

select * from monre.postcode  order by state_code desc;
select * from monre.postcode order by state_code;
--no error seen

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------


--Table - MonRE.property
--2 error removed

--To check if a property_id is repeated twice SQL query used is - 
SELECT property_id , count(*)
FROM monre.property
GROUP BY property_id 
HAVING COUNT(*) > 1;
--error seen
--error removed below

create table clean_property as select distinct * from monre.property;

--To check if an address_id is repeated twice SQL query used is - 
SELECT address_id , count(*)
FROM monre.property
GROUP BY address_id 
HAVING COUNT(*) > 1;
--error seen which is removed by removing the previous error

--To check if the address_id written in the monre.property table rows actually exist in the monre.address table, SQL query used is -

select address_id from monre.property where address_id not in (select address_id from monre.address);

--no error seen

--To check for null values in each column and values that are filled as ‘null’ , SQL query used is -
select * from monre.property  where property_id like 'null';     
select * from monre.property where property_id  is null;

select * from monre.property  where property_date_added like 'null';     
select * from monre.property where property_date_added is null;

select * from monre.property  where ADDRESS_ID like 'null';     
select * from monre.property where ADDRESS_ID is null;

select * from monre.property  where PROPERTY_TYPE like 'null';     
select * from monre.property where PROPERTY_TYPE  is null;

select * from monre.property  where PROPERTY_NO_OF_BEDROOMS like 'null';     
select * from monre.property where PROPERTY_NO_OF_BEDROOMS is null;

select * from monre.property  where PROPERTY_NO_OF_BATHROOMS like 'null';     
select * from monre.property where PROPERTY_NO_OF_BATHROOMS is null;

select * from monre.property  where PROPERTY_NO_OF_GARAGES like 'null';     
select * from monre.property where PROPERTY_NO_OF_GARAGES is null;

select * from monre.property  where PROPERTY_SIZE like 'null';     
select * from monre.property where PROPERTY_SIZE is null;

select * from monre.property  where PROPERTY_DESCRIPTION like 'null';     
select * from monre.property where PROPERTY_DESCRIPTION is null;

--no error seen

--To check out of range or invalid values in each column, the SQL query used is -

select * from monre.property order by property_id desc;
select * from monre.property order by property_id ;

select * from monre.property  order by property_date_added desc;
select * from monre.property order by property_date_added ;

select * from monre.property order by ADDRESS_ID desc;
select * from monre.property order by ADDRESS_ID ;

select * from monre.property  order by PROPERTY_TYPE desc;
select * from monre.property order by PROPERTY_TYPE ;

select * from monre.property order by PROPERTY_NO_OF_BEDROOMS desc;
select * from monre.property order by PROPERTY_NO_OF_BEDROOMS ;

select * from monre.property  order by PROPERTY_NO_OF_BATHROOMS desc;
select * from monre.property order by PROPERTY_NO_OF_BATHROOMS ;

select * from monre.property order by PROPERTY_NO_OF_GARAGES desc;
select * from monre.property order by PROPERTY_NO_OF_GARAGES ;

select * from monre.property  order by PROPERTY_SIZE desc;
select * from monre.property order by PROPERTY_SIZE ;

select * from monre.property  order by PROPERTY_DESCRIPTION desc;
select * from monre.property order by PROPERTY_DESCRIPTION ;
--no error seen

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------


--Table - MonRE.property_advert
--0 error removed

--To check if a property_id is repeated twice SQL query used is - 
SELECT property_id , count(*)
FROM monre.property_advert 
GROUP BY property_id 
HAVING COUNT(*) > 1;
--no error seen

--To check if an advert_id is repeated twice SQL query used is - 
SELECT advert_id, count(*)
FROM monre.property_advert
GROUP BY advert_id
HAVING COUNT(*) > 1;

--no error seen

--To check if an agent_person_id is repeated twice SQL query used is - 
SELECT agent_person_id , count(*)
FROM monre.property_advert
GROUP BY agent_person_id
HAVING COUNT(*) > 1;

--no error seen

--To check if the property_id written in the monre.property_advert table rows actually exist in the monre.property table, SQL query used is -

select property_id from monre.property_advert where property_id not in (select property_id from monre.property);
--no error seen

--To check if the advert_id written in the monre.property_advert table rows actually exist in the monre.advertisement table, SQL query used is -

select advert_id from monre.property_advert where advert_id not in (select advert_id from monre.advertisement);
--no error seen

--To check if the agent_person_id written in the monre.property_advert table rows actually exist in the monre.agent table, SQL query used is -

select agent_person_id from monre.property_advert where agent_person_id not in (select person_id from monre.agent);

--no error seen


--To check for null values in each column and values that are filled as ‘null’ , SQL query used is -
select * from monre.property_advert  where property_id like 'null';     
select * from monre.property_advert where property_id  is null;

select * from monre.property_advert  where advert_id like 'null';     
select * from monre.property_advert where advert_id is null;

select * from monre.property_advert  where agent_person_id like 'null';     
select * from monre.property_advert where agent_person_id is null;

select * from monre.property_advert  where cost like 'null';     
select * from monre.property_advert where cost is null;
--no error seen

--To check out of range or invalid values in each column, the SQL query used is -

select * from monre.property_advert order by property_id desc;
select * from monre.property_advert order by property_id ;

select * from monre.property_advert order by advert_id desc;
select * from monre.property_advert order by advert_id ;

select * from monre.property_advert  order by agent_person_id desc;
select * from monre.property_advert order by agent_person_id ;


select * from monre.property_advert order by cost desc;
select * from monre.property_advert order by cost;
--no error seen

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

--Table - MonRE.property_feature
--0 error removed
--To check if a property_id is repeated twice SQL query used is - 
SELECT property_id , count(*)
FROM monre.property_feature
GROUP BY property_id 
HAVING COUNT(*) > 1;
--no error seen 

--To check if a feature_code is repeated twice SQL query used is - 
SELECT feature_code , count(*)
FROM monre.property_feature
GROUP BY feature_code 
HAVING COUNT(*) > 1;
--no error seen

--To check if the property_id written in the monre.property_feature table rows actually exist in the monre.property table, SQL query used is -

select property_id from monre.property_feature where property_id not in (select property_id from monre.property);
--no error seen

--To check if the feature_code written in the monre.property_feature table rows actually exist in the monre.feature table, SQL query used is -

select feature_code from monre.property_feature where feature_code not in (select feature_code from monre.feature);
--no error seen

--To check for null values in each column and values that are filled as ‘null’ , SQL query used is -
select * from monre.property_feature  where property_id like 'null';     
select * from monre.property_feature where property_id  is null;

select * from monre.property_feature  where feature_code like 'null';     
select * from monre.property_feature where feature_code is null;

--no error seen

--To check out of range or invalid values in each column, the SQL query used is -

select * from monre.property_feature order by property_id desc;
select * from monre.property_feature order by property_id ;

select * from monre.property_feature order by feature_code desc;
select * from monre.property_feature order by feature_code ;

--no error seen


----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------


--Table - MonRE.rent
--3 error removed

--To check if a rent_id is repeated twice SQL query used is - 
SELECT rent_id , count(*)
FROM monre.rent
GROUP BY rent_id 
HAVING COUNT(*) > 1;
--no error seen

--To check if a agent_person_id is repeated twice SQL query used is - 
SELECT agent_person_id , count(*)
FROM monre.rent
GROUP BY agent_person_id 
HAVING COUNT(*) > 1;

--no error seen

--To check if a client_person_id is repeated twice SQL query used is - 
SELECT client_person_id , count(*)
FROM monre.rent
GROUP BY client_person_id
HAVING COUNT(*) > 1;
--no error seen

--To check if a property_id is repeated twice SQL query used is - 
SELECT property_id, count(*)
FROM monre.rent
GROUP BY property_id
HAVING COUNT(*) > 1;

--no error seen

--To check if the agent_person_id written in the monre.rent table rows actually exist in the monre.agent table, SQL query used is -

select agent_person_id from monre.rent where agent_person_id not in (select person_id from monre.agent);
--error seen
--error removed below
create table clean_rent as select * from monre.rent;
delete from clean_rent where agent_person_id not in (select person_id from monre.agent);

--To check if the client_person_id written in the monre.rent table rows actually exist in the monre.client table, SQL query used is -

select client_person_id from  monre.rent where client_person_id not in (select person_id from monre.client);
--error seen
--error removed below


delete from clean_rent where client_person_id not in (select person_id from monre.client);

--To check if the property_id written in the monre.rent table rows actually exist in the monre.property table, SQL query used is -

select property_id from monre.rent where property_id not in (select property_id from monre.property);
--no error seen

--To check for null values in each column and values that are filled as ‘null’ , SQL query used is -
select * from monre.rent  where rent_id like 'null';     
select * from monre.rent where rent_id  is null;

select * from monre.rent  where AGENT_PERSON_ID like 'null';     
select * from monre.rent where AGENT_PERSON_ID is null;

select * from monre.rent  where CLIENT_PERSON_ID like 'null';     
select * from monre.rent where CLIENT_PERSON_ID is null;

select * from monre.rent  where PROPERTY_ID like 'null';     
select * from monre.rent where PROPERTY_ID  is null;

select * from monre.rent  where RENT_START_DATE like 'null';     
select * from monre.rent where RENT_START_DATE is null;

select * from monre.rent  where RENT_END_DATE like 'null';     
select * from monre.rent where RENT_END_DATE 	  is null;

select * from monre.rent  where price like 'null';     
select * from monre.rent where price is null;
--no error seen

--To check out of range or invalid values in each column, the SQL query used is -

select * from monre.rent order by rent_id desc;
select * from monre.rent order by rent_id;

select * from monre.rent  order by AGENT_PERSON_ID desc;
select * from monre.rent order by AGENT_PERSON_ID;

select * from monre.rent order by CLIENT_PERSON_ID desc;
select * from monre.rent order by CLIENT_PERSON_ID;

select * from monre.rent  order by PROPERTY_ID desc;
select * from monre.rent order by PROPERTY_ID;

select * from monre.rent order by RENT_START_DATE desc;
select * from monre.rent order by RENT_START_DATE ;

select * from monre.rent  order by RENT_END_DATE desc;
select * from monre.rent order by RENT_END_DATE;

select * from monre.rent order by price desc;
select * from monre.rent order by price;
--no error seen

--To check out of range or invalid values in the date column, the SQL query used is -

select * from monre.rent where rent_end_date < rent_start_date;
--error seen
--error removed below

delete from clean_rent where  rent_end_date < rent_start_date;

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

--Table - MonRE.sale
--0 error removed

--To check if a sale_id is repeated twice SQL query used is - 
SELECT sale_id, count(*)
FROM monre.sale
GROUP BY sale_id
HAVING COUNT(*) > 1;

--no error seen

--To check if a agent_person_id is repeated twice SQL query used is - 
SELECT agent_person_id , count(*)
FROM monre.sale
GROUP BY agent_person_id 
HAVING COUNT(*) > 1;
--no error seen

--To check if a client_person_id is repeated twice SQL query used is - 
SELECT client_person_id , count(*)
FROM monre.sale
GROUP BY client_person_id
HAVING COUNT(*) > 1;
--no error seen

--To check if a property_id is repeated twice SQL query used is - 
SELECT property_id, count(*)
FROM monre.sale
GROUP BY property_id
HAVING COUNT(*) > 1;
--no error seen

--To check if the agent_person_id written in the monre.sale table rows actually exist in the monre.agent table, SQL query used is -

select agent_person_id from monre.sale  where agent_person_id not in (select person_id from monre.agent);
--no error seen

--To check if the client_person_id written in the monre.sale table rows actually exist in the monre.client table, SQL query used is -

select client_person_id from monre.sale where client_person_id not in (select person_id from monre.client);
--no error seen

--To check if the property_id written in the monre.sale table rows actually exist in the monre.property table, SQL query used is -

select property_id from monre.sale  where property_id not in (select property_id from monre.property);
--no error seen

--To check for null values in each column and values that are filled as ‘null’ , SQL query used is -
select * from monre.sale  where sale_id like 'null';     
select * from monre.sale where sale_id  is null;

select * from monre.sale  where AGENT_PERSON_ID like 'null';     
select * from monre.sale where AGENT_PERSON_ID is null;

select * from monre.sale  where CLIENT_PERSON_ID like 'null';     
select * from monre.sale where CLIENT_PERSON_ID is null;

select * from monre.sale  where PROPERTY_ID like 'null';     
select * from monre.sale where PROPERTY_ID  is null;

select * from monre.sale  where SALE_DATE like 'null';     
select * from monre.sale where SALE_DATE  is null;

select * from monre.sale  where price like 'null';     
select * from monre.sale where price is null;
--no error seen


--To check out of range or invalid values in each column, the SQL query used is -

select * from monre.sale order by sale_id desc;
select * from monre.sale order by sale_id;

select * from monre.sale  order by AGENT_PERSON_ID desc;
select * from monre.sale order by AGENT_PERSON_ID;

select * from monre.sale order by CLIENT_PERSON_ID desc;
select * from monre.sale order by CLIENT_PERSON_ID;

select * from monre.sale  order by PROPERTY_ID desc;
select * from monre.sale order by PROPERTY_ID;

select * from monre.sale order by SALE_DATE desc;
select * from monre.sale order by SALE_DATE ;

select * from monre.sale order by price desc;
select * from monre.sale order by price;
--no error seen

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

--Table - MonRE.state
--0 error removed

--To check if a state_code is repeated twice SQL query used is - 
SELECT state_code , count(*)
FROM monre.state
GROUP BY state_code 
HAVING COUNT(*) > 1;
--no error seen

--To check if a state_name is repeated twice SQL query used is - 
SELECT state_name, count(*)
FROM monre.state
GROUP BY state_name
HAVING COUNT(*) > 1;
--no error seen

--To check for null values in each column and values that are filled as ‘null’ , SQL query used is -
select * from monre.state  where state_code like 'null';     
select * from monre.state where state_code  is null;

select * from monre.state  where state_name like 'null';     
select * from monre.state where state_name  is null;
--no error seen

--To check out of range or invalid values in each column, the SQL query used is -

select * from monre.state order by state_code desc;
select * from monre.state order by state_code ;

select * from monre.state  order by state_name desc;
select * from monre.state order by state_name ;
--no error seen

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

--Table - MonRE.visit
--2 error removed

--To check if a agent_person_id is repeated twice SQL query used is - 
SELECT agent_person_id , count(*)
FROM monre.visit
GROUP BY agent_person_id 
HAVING COUNT(*) > 1;
--no error seen

--To check if a client_person_id is repeated twice SQL query used is - 
SELECT client_person_id , count(*)
FROM monre.visit
GROUP BY client_person_id
HAVING COUNT(*) > 1;

--no error seen

--To check if a property_id is repeated twice SQL query used is - 
SELECT property_id, count(*)
FROM monre.visit
GROUP BY property_id
HAVING COUNT(*) > 1;
--no error seen

--To check if the agent_person_id written in the monre.visit  table rows actually exist in the monre.agent table, SQL query used is -

select agent_person_id from monre.visit  where agent_person_id not in (select person_id from monre.agent);
--error seen
--error removed below

create table clean_visit as select * from monre.visit;
delete from clean_visit where agent_person_id not in (select person_id from monre.agent);

--To check if the client_person_id written in the monre.visit table rows actually exist in the monre.client table, SQL query used is -

select client_person_id from monre.visit where client_person_id not in (select person_id from monre.client);
--error seen
--error removed below
delete from clean_visit where client_person_id not in (select person_id from monre.client);

--To check if the property_id written in the monre.visit table rows actually exist in the monre.property table, SQL query used is -

select property_id from monre.visit  where property_id not in (select property_id from monre.property);
--no error seen

--To check for null values in each column and values that are filled as ‘null’ , SQL query used is -

select * from monre.visit  where AGENT_PERSON_ID like 'null';     
select * from monre.visit where AGENT_PERSON_ID is null;

select * from monre.visit  where CLIENT_PERSON_ID like 'null';     
select * from monre.visit where CLIENT_PERSON_ID is null;

select * from monre.visit  where PROPERTY_ID like 'null';     
select * from monre.visit where PROPERTY_ID  is null;

select * from monre.visit  where VISIT_DATE like 'null';     
select * from monre.visit where VISIT_DATE  is null;

select * from monre.visit  where duration like 'null';     
select * from monre.visit where duration is null;
--no error seen

--To check out of range or invalid values in each column, the SQL query used is -

select * from monre.visit  order by AGENT_PERSON_ID desc;
select * from monre.visit order by AGENT_PERSON_ID;

select * from monre.visit order by CLIENT_PERSON_ID desc;
select * from monre.visit order by CLIENT_PERSON_ID;

select * from monre.visit  order by PROPERTY_ID desc;
select * from monre.visit order by PROPERTY_ID;

select * from monre.visit order by VISIT_DATE desc;
select * from monre.visit order by VISIT_DATE ;

select * from monre.visit order by duration desc;
select * from monre.visit order by duration;
--no error seen


--Hence all errors removed

--Creating copies of rest tables with no errors

create table clean_address as select * from MonRE.address;
create table clean_advertisement as select * from MonRE.advertisement;
create table clean_client_wish as select * from MonRE.client_wish;
create table clean_office as select * from MonRE.office;
create table clean_postcode as select * from MonRE.postcode;
create table clean_property_advert as select * from MonRE.property_advert;
create table clean_property_feature as select * from MonRE.property_feature;
create table clean_sale as select * from MonRE.sale;
create table clean_state as select * from MonRE.state;


--Final tables with no errors are
--select * from clean_address;
--select * from clean_advertisement;
--select * from clean_agent; 
--select * from clean_agent_office; 
--select * from clean_client;
--select * from clean_client_wish;
--select * from clean_feature; 
--select * from clean_office;
--select * from clean_person ; 
--select * from clean_postcode;
--select * from clean_property; 
--select * from clean_property_advert;
--select * from clean_property_feature;
--select * from clean_rent ; 
--select * from clean_sale  ;
--select * fromclean_state;
--select * from clean_visit ; 
