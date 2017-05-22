******************************************************************************
Filename:		BasicEHR.sas
Purpose:        at least Basic EHR adoption rate
Date:           06/30/2014
******************************************************************************;





/****************************************************************************
(1) Overall trend
- group together ineligible hospitals (LTAC, psych, rehab) and compare at least basic EHR adoption rate 2008-2013
- use cross-sectional data from each year (i.e., we don't need a panel); adjust for non-response by producing weighted adoption rates
- i believe that this is just an aggregation of what you have already done, but to the extent that it is not, please also re-run by type of hospital (eligible, LTAC, psych, rehab), by size, and by type-size.
- we were a bit surprised that the number of rehab hospitals is so low, and so if you can confirm that we are not losing anyone, that would be great
- ashish thought that you had already run by system-affiliation (yes/no); if so, can you send that to us to take a look at?

(2) Difference-in-trend
- compare trend in at least basic EHR adoption for the years 2008-2010 versus 2011-2013 for eligible versus ineligible hospitals 
- if you have not run difference-in-trend models before, let me know (or better yet, ask Jie who has done many of them!)


(3) Predictors of adoption among ineligible hospitals
- categorize each ineligible hospital based on basic EHR adoption status as follows:
(1) NEW ADOPTER: had at least a basic EHR in 2013 (and if they did not respond in 2013, then you can substitute 2012 data) and did NOT have a basic EHR in 2009 (and if they did not respond in 2009, then you can substitute 2008)
(2) ALWAYS ADOPTER: same as above but had at least a basic in 2009/2008 and continued to have one in 2013/2012
(3) NEVER ADOPTER: same as above but did not have at least a basic in 2009/2008 and continued NOT to have one in 2013/2012
Note -- there will be some hospitals that seem to go backwards -- have basic in 2009/2008 but not in 2013/2012; fine to exclude these but please make a note of how many there are for reference.

- cross these categories with key hospital characteristics including chi-square tests for differences across groups, including:
(1) the usual set -- size, teaching, region, system affiliation, ownership, etc.
(2) a measure of at least basic EHR adoption among ELIGIBLE hospitals in their HRR in 2013
(3) a measure in the CHANGE in basic EHR adoption among ELIGIBLE hospitals in their HRR between 2009 and 2013 (so if HRR 1 had 30% adoption in 2009 and 50% adoption in 2013, the value for that HRR would be 20%).
Let's leave MU functions as something to look at later...

********************************************************************************/

libname HIT "C:\data\Data\Hospital\AHA\HIT\data";
libname impact "C:\data\Data\Hospital\Impact";
LIBNAME AHA 	"C:\data\Data\Hospital\AHA\Annual_Survey\data";
libname rural 'C:\data\Data\RUCA';


* Make Hospital Characteristics Summary File;
data temp1;
set aha.aha12;

* Inegilible Long-Term Acute Care ;
if serv=80 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=4;
* Inegilible Psychiatric ; 
if serv=22 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=3; 
* Inegilible Rehabilitation ;
if serv=46 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=2;
* Egilible Acute Care Hospitals (general medical and surgical ;
if serv=10 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=1; 

if sysid ^='' then system=1; else system=0;
 

keep id zip type hospsize hosp_reg4 profit2 teaching system  ;
run;

* Calculate how many hospitals in each category ;
proc freq data=temp1;tables type/missing;run;

proc sql;
create table temp2 as
select *
from temp1 A left join rural.SAS_2006_RUCA B
on A.zip=B.ZIPA;
quit;

data hospital;
set temp2;
if type ne .;
keep id zip type hospsize hosp_reg4 profit2 teaching system  ruca_level;
run;


*********************************
Basic EHR Adoption, for each year 
*********************************;
*2008;
proc sort data=hit.hit07 out=hit08(keep= q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 id  );
by id;
run;

*2009;
proc sort data=hit.hit08 out=hit09(keep= q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_a2 q1_b2 q1_d2 q1_c3 id it_response );
by id;
run;
data hit09;
set hit09;
if it_response='Yes';
run;
data hit09;
set hit09;
rename q1_a1=q1a1;rename q1_b1=q1b1;
rename q1_c1=q1c1;rename q1_d1=q1d1;
rename q1_e1=q1e1;rename q1_f1=q1f1;
rename q1_a2=q1a2;rename q1_b2=q1b2;
rename q1_d2=q1d2;rename q1_c3=q1c3;
run;
 
*2010;
proc sort data=hit.hit09 out=hit10(keep= q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 id  );
by id;
run;
*2011;
proc sort data=hit.hit10 out=hit11(keep= q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_a2 q1_b2 q1_d2 q1_c3 id );
by id;
run;
data hit11;
set hit11;
rename q1_a1=q1a1;rename q1_b1=q1b1;
rename q1_c1=q1c1;rename q1_d1=q1d1;
rename q1_e1=q1e1;rename q1_f1=q1f1;
rename q1_a2=q1a2;rename q1_b2=q1b2;
rename q1_d2=q1d2;rename q1_c3=q1c3;
run;
* 2012;
libname HIT1112 "C:\data\Data\Hospital\AHA\HIT\Data\fromshare_Projects-HIT2012-data-stata";
proc sort data=hit1112.Finalitfeb7 out=hit12(keep=q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 id );
by id;
run;

* 2013;
proc sort data=hit.hit13 out=hit13(keep= q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 id);
by id;
run;










%macro long(year=);
data hit&year.;
set hit&year.;
array basic {10}  q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3;
total=0;
do i= 1 to 10;
	if basic(i) in (1,2) then total=total+1;
end;
drop i;
		 
if total=10 then basic_adopt=1;else basic_adopt=0; 

keep id basic_adopt;
run; 

proc sql;
create table temp3 as
select *
from hospital A left join hit&year. B
on A.id=B.id;
quit;

data temp4;
set temp3;
if basic_adopt ne . then respond=1;else respond=0;
run;

 

proc logistic data=temp4;
	class respond(ref="0") hospsize(ref="1")  type(ref="1") hosp_reg4(ref="1") profit2(ref="1") teaching(ref="3") system(ref="1") ruca_level(ref="1")  /param=ref;
	model respond  = hospsize type type*hospsize hosp_reg4 profit2 teaching system ruca_level; 
	output  out=temp5 p=prob;  
run;

data temp6;
set temp5;
if type=1 then elig=1;else elig=0;
wt=1/prob;
run;

data final&year.;
set temp6;
if respond=1;
year=20&year.;
keep id elig basic_adopt wt year;
run;

proc means data= final&year.;
class elig;
weight wt;
var basic_adopt;
output out=unadjust&year. mean=rate&year.;
run;

proc freq data=final&year.;tables elig;run;

%mend long;

%long(year=13);
%long(year=12);
%long(year=11);
%long(year=10);
%long(year=09);
%long(year=08);

data allyear;
set final08 final09 final10 final11 final12 final13;
if year=2008 then t=1;
else if year=2009 then t=2;
else if year=2010 then t=3;
else if year=2011 then t=4;
else if year=2012 then t=5;
else if year=2013 then t=6;
if year > 2010 then year_2010=1;else year_2010=0;
run;

proc sort data=allyear;by id year;run;

 

* longitudinal Trend Analysis;

 
proc genmod data=allyear descending   ;
weight wt;
class id elig t year_2010;
model basic_adopt=elig year year_2010 elig*year elig*year_2010/dist=binomial link=logit;
repeated subject=id/withinsubject=t logor=exch  ;
output out=est p=predict;
 
run;

 

proc sort data=est out=test nodupkey;by predict;run;
proc sort data=test;by year elig;run;

 



* Adopter Types;
proc transpose data=allyear out=all_w;
by id;
var basic_adopt;
run;

data all_w;
set all_w;
if (col6=1 or (col6=. and col5=1)) and (col2=0 or (col2=. and col1=0)) then new_adopt=1;
if (col6=1 or (col6=. and col5=1)) and (col2=1 or (col2=. and col1=1)) then new_adopt=2;
if (col6=0 or (col6=. and col5=0)) and (col2=0 or (col2=. and col1=0)) then new_adopt=0;
run;
proc sort data=all_w out=test nodupkey;by col1 col2 col3 col4 col5 col6;run;
proc freq data=all_w;tables new_adopt/missing;run;
