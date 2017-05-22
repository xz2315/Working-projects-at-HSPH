*************************
Marron Institute City Project
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
set citybyzip;
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
 


/* BY UA:

data  temp1;set  temp1;zipnum=zip*1;run;

* HCAHPS + ZIP + HSA + HRR;
proc sql;
create table temp2 as
select *
from temp1 a left join hrr.Ziphsahrr11 b
on a.zipnum =b.zipcode11
where a.hosprate3 ~= . and b.zipcode11 ~=.;
quit; 



* Make a list of Urbanized Area and ZIP;
data ua;set ua;ua=uace*1;run;
proc sql;
create table temp3 as
select a.ua,a.name,b.zcta5
from ua a left join ua_zip b
on a.ua=b.ua;
quit;
data temp3;set temp3;zipnum=zcta5*1;run;





* HCAHPS +ZIP + HSA + HRR + UA ;
proc sql;
create table temp4 as
select *
from temp2 a left join temp3 b
on a.zipnum=b.zipnum;
quit;

* HCAHPS +ZIP + HSA + HRR + UA + USPS ZIP;
data zip;set zip;zipnum=zip*1;run;
proc sql;
create table hcahps as
select a.*,b.primary_city,b.county,b.state
from temp4 a left join zip b
on a.zipnum=b.zipnum;
quit;

  
* Aggregate to HRR City level Weighted by number of Discharge ;

proc means data=hcahps;
weight dsg_tot11;
class hrrnum;
var hosprate3;
output out=temp5 mean=hopsrate;
run;

proc sort data=hrr.Ziphsahrr11 out=temp6(keep=hrrnum hrrcity hrrstate) nodupkey;by hrrnum;run;
proc sql;
create table hcahps_by_hrr as
select a.hrrnum,a.hopsrate,b.hrrcity,b.hrrstate
from temp5 a left join temp6 b
on a.hrrnum=b.hrrnum
where a.hrrnum ~=.;
quit;
 

proc sort data=hcahps_by_hrr out=test;by descending hopsrate;run;
data test;
set test;
where find(hrrcity,"Boston") or find(hrrstate,"NY") or find(hrrcity,"Chicago") or find(hrrcity,"Philadelphia")
or find(hrrcity,"Houston") or find(hrrcity,"Phoenix") or find(hrrcity,"San Antonio")
or find(hrrcity,"San Diego") or find(hrrcity,"Dallas") or find(hrrcity,"San Jose");
run;
proc sgplot data=test;
scatter x=hrrcity y=hopsrate/group=hrrstate;
run;


*/
