*************************
Marron Institute City Project--small city
7/17/2014
City Level Quality Indicators--PQI
******************************;

libname marron 'C:\data\Projects\Marron\Archive';
libname aha 'C:\data\Data\Hospital\AHA\Annual_Survey\Data';
libname hcahps 'C:\data\Data\Hospital\Archive\HQA';
libname hrr 'C:\data\Data\Dartmouth_Atlas\ZIP_HSA_HRR_XWalk';* ZIP_HSA_HRR has city and state names;
libname PQI 'C:\data\Projects\Scorecard\data';
libname medicare 'C:\data\Data\Medicare\Denominator';
 
/*
Strategy:
pqi_inptall2011 has every Medicare Inpatient/Discharge--Numerator
Denominator is total Medicare population in 2011
PQI is based on patient residence, not HRR, so just need the zip in pqi_inptall2011
just group zip by city
*/
data temp1;
set pqi.pqi_inptall2011 ;
zip=bene_zip*1;
where bene_zip ~= '';
keep bene_id  zip tapq90 tapq91 tapq92;
run;
 
data temp2;
set smallcity;
zipnum=zip*1;drop zip;
run;
proc sql;
create table temp3 as
select *
from temp2 a  inner join temp1 b
on a.zipnum=b.zip;
quit;
* Combines and displays only the rows from the first table that match rows from the second table ;
 


* Numerator by City;
proc sql;
create table numerator as
select distinct city, count(tapq90) as overall, count(tapq91) as acute, count(tapq92) as chronic 
from temp3
group by city;
quit;

* Denominator by City;
data temp4;
set medicare.dnmntr2011;
zip=substr(bene_zip,1,5)*1;
keep bene_id zip;
run;
proc sql;
create table temp5 as
select *
from temp2 a  inner join temp4 b
on a.zipnum=b.zip;
quit;

proc sql;
create table denominator as
select distinct city, count(bene_id) as denominator
from temp5
group by city;
quit;


* Merge numerator and denominator;
proc sql;
create table pqi as
select a.city,b.denominator as Medicare_Population,round((a.overall/b.denominator)*100000,1) as overall_pqi,round((a.acute/b.denominator)*100000,1) as acute_pqi,
round((a.chronic/b.denominator)*100000,1) as chronic_pqi
from numerator a inner join denominator b
on a.city=b.city;
quit;




 
