*************************
Marron Institute City Project--other small city
7/16/2014
City Level Quality Indicators--HCAHPS
******************************;
 
libname marron 'C:\data\Projects\Marron\Archive';
libname aha 'C:\data\Data\Hospital\AHA\Annual_Survey\Data';
libname hcahps 'C:\data\Data\Hospital\Archive\HQA';
libname hrr 'C:\data\Data\Dartmouth_Atlas\ZIP_HSA_HRR_XWalk';* ZIP_HSA_HRR has city and state names;

/*
HCAHPS is hospital-level rating
assign hospital according to ZIP to City
just merge HCAHPS with AHA to get ZIP, and then merge with CITY_BY_ZIP
*/

* HCAHPS and ZIP;
proc sql;
create table temp1 as
select *
from (select provider, hosprate3 from hcahps.hcahps2011) a left join (select provider, zip, dsg_tot11 from aha.aha11) b
on a.provider=b.provider
where b.zip ~= '';
quit;
data temp1;set temp1;zipnum=zip*1;run;

data temp2;
set smallcity;
zipnum=zip*1;drop zip;
run;



proc sql;
create table temp2 as
select *
from temp1 a inner join temp2 b
on a.zipnum=b.zipnum;
quit;


proc sql;
create table hcahps as
select distinct city, round(sum(hosprate3*dsg_tot11)/(sum(dsg_tot11)*100),0.01)as Hospital_Overall_Rating format percent9.0
from temp2
group by city;
quit;
