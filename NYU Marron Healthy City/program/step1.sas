*****************************

Marron Institute
7/10/2014
Xiner Zhou

******************************;


libname marron 'C:\data\Projects\Marron\Archive';
libname aha 'C:\data\Data\Hospital\AHA\Annual_Survey\Data';


****************************
Import Urbanized Areas list
****************************;
proc import datafile='C:\data\Projects\Marron\Archive\ua_list_ua.xls'
dbms=xls out=temp replace;
getnames=yes;
run;

data temp;
set temp;
ua=uace*1;
run;



*********************************
Import zip code database
*********************************;
proc import datafile='C:\data\Projects\Marron\Archive\zip_code_database.xls'
dbms=xls out=marron.zip replace;
getnames=yes;
run;



*******************************************
Import:
Urban Area and Zip Relationship File
Urban Area and County Relationship File
Urban Area and CountySubdivision Relationship File
Urban Area and Place Relationship File
Urban Area and Metropolitan Relationship FIle
*******************************************;
proc import datafile="C:\data\Projects\Marron\Archive\ua_zcta_rel_10.txt"
            dbms=dlm
            out=marron.ua_zip
            replace;
     delimiter=',';
     getnames=yes;
run;
proc import datafile="C:\data\Projects\Marron\Archive\ua_county_rel_10.txt"
            dbms=dlm
            out=marron.ua_county
            replace;
     delimiter=',';
     getnames=yes;
run;
proc import datafile="C:\data\Projects\Marron\Archive\ua_cousub_rel_10.txt"
            dbms=dlm
            out=marron.ua_cousub
            replace;
     delimiter=',';
     getnames=yes;
run;
proc import datafile="C:\data\Projects\Marron\Archive\ua_place_rel_10.txt"
            dbms=dlm
            out=marron.ua_place
            replace;
     delimiter=',';
     getnames=yes;
run;
proc import datafile="C:\data\Projects\Marron\Archive\ua_cbsa_rel_10.txt"
            dbms=dlm
            out=marron.ua_cbsa
            replace;
     delimiter=',';
     getnames=yes;
run;
proc import datafile="C:\data\Projects\Marron\Archive\zcta_cbsa_rel_10.txt"
            dbms=dlm
            out=marron.zcta_cbsa
            replace;
     delimiter=',';
     getnames=yes;
run;
proc import datafile="C:\data\Projects\Marron\Archive\zcta_county_rel_10.txt"
            dbms=dlm
            out=marron.zcta_county 
            replace;
     delimiter=',';
     getnames=yes;
run;
proc import datafile="C:\data\Projects\Marron\Archive\zcta_cousub_rel_10.txt"
            dbms=dlm
            out=marron.zcta_cousub 
            replace;
     delimiter=',';
     getnames=yes;
run;
proc import datafile="C:\data\Projects\Marron\Archive\zcta_place_rel_10.txt"
            dbms=dlm
            out=marron.zcta_place 
            replace;
     delimiter=',';
     getnames=yes;
run;
 
* How many zipcode areas each urban area contains?;

proc sql;
create table num_zip as
select distinct ua, count(ua) as num_zip_1ua
from marron.zip
where zcta5 ~= 99999
group by ua
;
quit;


proc sql;
create table marron.ua as
select *
from temp a left join num_zip b
on a.ua=b.ua;
quit;

 
*******************************************************************************************
PQI(Prevention Quality Indicators): Medicare population
Patient-level and only include those have potentially preventable hospitalizations related to 
conditions for which good outpatient care can likely prevent hospitalization
********************************************************************************************;

libname PQI 'C:\data\Projects\Scorecard\data';

data PQI;
set pqi.pqi_inptall2011 ;
zip=bene_zip*1;
where tapq90~=. or  tapq91~=. or tapq92~=.;
keep bene_id  zip tapq90 tapq91 tapq92;
run;

proc sql;
create table temp1 as
select a.bene_id, a.zip, a.tapq90, a.tapq91, a.tapq92, b.zcta5, b.uaname, b.ua 
from PQI A left join marron.zip B
on a.zip=b.zcta5;
quit;

***** Calculate Numerator for each Urban Area(including Urban Clusters which we don't care);
proc sql;
create table temp2 as
select distinct ua, uaname, count(tapq90) as overall, count(tapq91) as acute, count(tapq92) as chronic 
from temp1
group by ua;
quit;
 


***** Calculated Denominator for each urbanized Area, Medicare population, compare it to total population;
libname medicare 'C:\data\Data\Medicare\Denominator';
data mc;
set medicare.Dnmntr2011;
zip=substr(bene_zip,1,5)*1;
keep zip bene_id;
run;

 

* medicare population by urban area , some urban area may not have record in this file temp4 ;
proc sql;
create table temp3 as
select a.zip, a.bene_id, b.zcta5, b.uaname, b.ua
from mc A left join marron.zip B
on a.zip=b.zcta5;
quit;

proc sql;
create table temp4 as
select distinct ua, uaname, count(ua) as mcpop  
from temp3  
group by ua;
quit;
 

 
* combine both medicare pop and total pop, definitely use medicare population, since medicare population > population;

proc sql;
create table temp6 as
select *, b.mcpop/a.pop as mcrate
from marron.ua a left join temp4 b
on a.ua=b.ua;
quit;
 
***** PQI rate = Numerator / Denominator ;

proc sql;
create table final_PQI as
select *, b.overall/a.mcpop as overall_rate, b.acute/a.mcpop as acute_rate, b.chronic/a.mcpop as chronic_rate  
from temp6 a left join temp2 b
on a.ua=b.ua;
quit;


****************************************************************************
Mortality Indicators:

Hospital Level: 30-day all-cause AMI mortality rate and Stroke mortality rate
****************************************************************************;

libname mort  'C:\data\Data\Hospital\Medicare_Inpt\Mortality\data';

data temp7;
set mort.adjmort40meas30day11;
keep provider NDmortmeas_amiAll rawmortmeas_amiAll30day NDmortmeas_strokeAll rawmortmeas_strokeAll30day;
run;

data temp8;
set aha.aha03(keep=provider mloczip) aha.aha04(keep=provider mloczip) aha.aha05(keep=provider mloczip) 
aha.aha06(keep=provider mloczip) aha.aha07(keep=provider mloczip) aha.aha08(keep=provider mloczip) aha.aha09(keep=provider mloczip)
aha.aha12(keep=provider mloczip) aha.aha11(keep=provider mloczip) aha.aha10(keep=provider mloczip)  ;
zip=scan(mloczip,1,'-')*1;
keep provider zip;
run;
proc sort data=temp8 nodupkey;by provider;run;

proc sql;
create table temp9 as
select *
from temp7 a left join temp8 b
on a.provider=b.provider;
quit;

 


* link hospital to Urbanized Area;
proc sql;
create table temp10 as
select *
from temp9 a left join marron.zip B
on a.zip=b.zcta5;
quit;

data temp11;
set temp10;
if zip ne .;
AMI=NDmortmeas_amiAll* rawmortmeas_amiAll30day;
stroke=NDmortmeas_strokeAll* rawmortmeas_strokeAll30day;
keep provider NDmortmeas_amiAll AMI NDmortmeas_strokeAll Stroke zip ua;
run;

* Calculate aggregated mortality for each Urban Areas including Urban Clusters--temp12;
proc sql;
create table temp12 as
select distinct ua, sum(AMI)/sum(NDmortmeas_amiAll) as AMI_mortality_rate , sum(Stroke)/sum(NDmortmeas_strokeAll) as Stroke_mortality_rate 
from temp11
group by ua;
quit;


* Link with Urban Area File;
proc sql;
create table final_PQI_Mort as
select *  
from final_PQI a left join temp12 b
on a.ua=b.ua;
quit;


 

************************************************************************
HCAHPS HOspital Consumer Assessment of Healthcare Providers and Sysytems
************************************************************************;

libname hcahps 'C:\data\Data\Hospital\Archive\HQA';

data temp13;
set hcahps.hcahps2011;
keep provider hosprate3;
run;

* link to AHA;
data temp14;
set aha.aha11;
zip1=zip*1;
keep provider zip1 dsg_tot11;
run;

 


proc sql;
create table temp15 as
select *
from temp13 a left join temp14 b
on a.provider=b.provider
where b.zip1 ~= .;
quit;

 
* link hospital to Urbanized Area;
proc sql;
create table temp16 as
select a.provider, a.hosprate3, a.zip1, a.dsg_tot11, b.ua
from temp15 a left join marron.zip B
on a.zip1=b.zcta5;
quit;


* Weighted by number of Discharge ;

proc means data=temp16;
weight dsg_tot11;
class ua;
var hosprate3;
output out=HCAHPS mean=hopsrate;
run;

* Link with other indicators;
proc sql;
create table final_PQI_Mort_HCAHPS as
select a.*, b.hopsrate
from final_PQI_Mort a left join HCAHPS b
on a.ua=b.ua;
quit;


proc sort data=final_PQI_Mort_HCAHPS;by descending pop;run;

  






ods _all_ close;
ods tagsets.ExcelXP path='C:\data\Projects\Marron\output' file='step1.xml' style=Printer;

proc print data=final_PQI_Mort_HCAHPS ;
	var uaname pop overall_rate acute_rate chronic_rate AMI_mortality_rate Stroke_mortality_rate hopsrate;
run;
quit;

 
 

ods tagsets.ExcelXP close;

