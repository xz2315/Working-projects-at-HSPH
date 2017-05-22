************************************************************************************
Persistent Medicare HC 2012-2014 -Jose
Cost and Util  
Xiner Zhou
12/19/2016
************************************************************************************;
libname data 'I:\Projects\High Cost Segmentation Phase II\Data';
libname denom 'C:\data\Data\Medicare\Denominator';
libname stdcost 'C:\data\Data\Medicare\StdCost\Data';
libname frail 'I:\Data\Medicare\Frailty Indicator';
libname cc 'C:\data\Data\Medicare\MBSF CC';
libname seg 'C:\data\Projects\High_Cost_Segmentation\Data';
libname icc 'C:\data\Data\Medicare\Chronic Condition';
libname pqi 'I:\Projects\Scorecard\data';

%macro bene(yr);
 
* Select 20% Sample;
data Patienttotalcost&yr. ;
set stdcost.Patienttotalcost&yr.;
if death_dt ne . then died=1;else died=0;
if fullAB =1 and HMO =0 and State_CD*1 ne 40 and State_CD*1>=1 and State_CD*1<=53 then keep=1;else keep=0;
if STRCTFLG ne '' and keep=1;
run;
 
* Define HC (5% 10% 25%);
proc rank data=Patienttotalcost&yr. out=Patienttotalcost&yr._r  percent;
var actual stdcost;
ranks pct_actual pct_stdcost;
run;

data Patienttotalcost&yr._r;
set Patienttotalcost&yr._r;
 if pct_actual>=95  then HC5_actual=1;else HC5_actual=0;
 if pct_actual>=90  then HC10_actual=1;else HC10_actual=0;
 if pct_actual>=75  then HC25_actual=1;else HC25_actual=0;

 if pct_stdcost>=95  then HC5_stdcost=1;else HC5_stdcost=0;
 if pct_stdcost>=90  then HC10_stdcost=1;else HC10_stdcost=0;
 if pct_stdcost>=75  then HC25_stdcost=1;else HC25_stdcost=0; 
proc freq;
tables HC5_actual HC10_actual HC25_actual HC5_stdcost HC10_stdcost HC25_stdcost/missing;
run;
 
* Readmission;
proc sort data=data.Readm30clmall&yr.;by bene_id;run;
proc sql;
create table readm&yr. as
select bene_id, count(*) as n_adm_readm label="Number of All-Cause Admissions", sum(readm) as n_readm label="Number of 30-Day Readmission"
from data.Readm30clmall&yr.  
where readm in (0,1)
group by bene_id
;
quit;
proc sort data=readm&yr. nodupkey;by bene_id;run;

* Inpatinet Mortality;
proc sort data=data.Mortclmall&yr.;by bene_id;run;
proc sql;
create table mortip&yr. as
select bene_id, count(*) as n_adm_mortip label="Number of All-Cause Admissions", sum(mortip) as n_mortip label="Number of Inpatient Death"
from data.Mortclmall&yr.
where MOrtIP in (0,1)
group by bene_id
;
quit;
proc sort data=mortip&yr. nodupkey;by bene_id;run;

* 30-day Mortality;
proc sql;
create table mort30&yr. as
select bene_id, count(*) as n_adm_mort30 label="Number of All-Cause Admissions", sum(mort30) as n_mort30 label="Number of 30-day Death"
from data.Mortclmall&yr.
where MOrt30 in (0,1)
group by bene_id
;
quit;
proc sort data=mort30&yr. nodupkey;by bene_id;run;

* PQI;
data Pqi_medpar&yr.v45 ;
set pqi.Pqi_medpar&yr.v45 ;
if TAPQ90=. then TAPQ90=0;
keep bene_id TAPQ90;
proc sort;by bene_id;run;
run;

proc sql;
create table pqi&yr. as
select bene_id, count(*) as n_adm_pqi label="Number of Admissions", sum(TAPQ90) as n_pqi label="Number of Preventable Admissions(PQI)"
from Pqi_medpar&yr.v45
group by bene_id;
quit;
proc sort data=pqi&yr. nodupkey;by bene_id;run;

proc sql;
create table temp1&yr. as
select a.*,b.*
from Patienttotalcost&yr._r a left join readm&yr. b
on a.bene_id=b.bene_id;
quit;

proc sql;
create table temp2&yr. as
select a.*,b.*
from temp1&yr. a left join mortip&yr. b
on a.bene_id=b.bene_id;
quit;

proc sql;
create table temp3&yr. as
select a.*,b.*
from temp2&yr. a left join mort30&yr. b
on a.bene_id=b.bene_id;
quit;

proc sql;
create table temp4&yr. as
select a.*,b.*
from temp3&yr. a left join pqi&yr. b
on a.bene_id=b.bene_id;
quit;

data temp5&yr. ;
set temp4&yr. ;

array temp {8} n_adm_readm n_readm n_adm_mortip n_mortip n_adm_mort30 n_mort30 n_adm_pqi n_pqi;

do i=1 to 8;
 if temp{i}=. then temp{i}=0;
end;drop i;
keep bene_id n_adm_readm n_readm n_adm_mortip n_mortip n_adm_mort30 n_mort30 n_adm_pqi n_pqi STRCTFLG keep HC5_actual HC10_actual HC25_actual HC5_stdcost HC10_stdcost HC25_stdcost ;
run;

proc means data=temp5&yr. ;
where STRCTFLG ne '' and keep=1;
var n_adm_readm n_readm n_adm_mortip n_mortip n_adm_mort30 n_mort30 n_adm_pqi n_pqi  ;
run;
%mend bene;
%bene(yr=2012);
%bene(yr=2013);
%bene(yr=2014);





%macro outcome(yr);
 
proc tabulate data=temp5&yr. noseps;
where  STRCTFLG ne '' and keep=1;
class HC5_actual HC10_actual HC25_actual HC5_stdcost HC10_stdcost HC25_stdcost  ;
var n_adm_readm n_readm n_adm_mortip n_mortip n_adm_mort30 n_mort30 n_adm_pqi n_pqi  ;

table (n_adm_readm n_readm n_adm_mortip n_mortip n_adm_mort30 n_mort30 n_adm_pqi n_pqi), 
(HC5_actual*(sum) HC10_actual*(sum) HC25_actual*(sum) HC5_stdcost*(sum) HC10_stdcost*(sum) HC25_stdcost*(sum) all*(sum))/RTS=25;

Keylabel all="All Bene";
 
run;
 

%mend outcome;
%outcome(yr=2012);
%outcome(yr=2013);
%outcome(yr=2014);






* Persistent;
proc sql;
create table temp62014 as
select a.*,b.HC10_stdcost as HC10_stdcost2013
from temp52014 a inner join temp52013 b
on a.bene_id=b.bene_id
where a.STRCTFLG ne '' and a.keep=1 and b.STRCTFLG ne '' and b.keep=1;
quit;
proc sql;
create table temp72014 as
select a.*,b.HC10_stdcost as HC10_stdcost2012
from temp62014 a inner join temp52012 b
on a.bene_id=b.bene_id
where a.STRCTFLG ne '' and a.keep=1 and b.STRCTFLG ne '' and b.keep=1;
quit;

data temp82014;
set temp72014;
if HC10_stdcost=1 and HC10_stdcost2012=1 and HC10_stdcost2013=1 then persist=1;
else if HC10_stdcost=0 and HC10_stdcost2012=0 and HC10_stdcost2013=0 then persist=0;
if STRCTFLG ne '' and keep=1 and persist in (0,1);
label persist="HC/non-HC in 3 yrs";
run;

proc tabulate data=temp82014 noseps;
class persist  ;
var n_adm_readm n_readm n_adm_mortip n_mortip n_adm_mort30 n_mort30 n_adm_pqi n_pqi  ;

table (n_adm_readm n_readm n_adm_mortip n_mortip n_adm_mort30 n_mort30 n_adm_pqi n_pqi), 
(persist*(sum)  all*(sum))/RTS=25;

Keylabel all="All Bene";
 
run;
