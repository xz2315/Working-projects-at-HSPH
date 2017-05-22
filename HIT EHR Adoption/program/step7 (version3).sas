******************************************************************************
Version III Analyses
Xiner Zhou
11/24/2014
******************************************************************************;



/****************************************************************************
Objective:
Stratified analyses of diff-in-diff model/graphs comparing eligibles to LTAC only; Psych only; and Rehab only (i.e., stratified by ineligible hospital type). 

What is an Eligible Hospital under the Medicare EHR Incentive Program?

>paid under the Inpatient Prospective Payment System (IPPS)
>Critical Access Hospitals (CAHs)
>Medicare Advantage (MA-Affiliated) Hospitals

What is an Eligible Hospital under the Medicaid EHR Incentive Program?

>Acute care hospitals (including CAHs and cancer hospitals) with at least 10% Medicaid patient volume
>Children's hospitals (no Medicaid patient volume requirements)



********************************************************************************/

libname HIT "C:\data\Data\Hospital\AHA\HIT\data";
libname impact "C:\data\Data\Hospital\Impact";
LIBNAME AHA 	"C:\data\Data\Hospital\AHA\Annual_Survey\data";
libname rural 'C:\data\Data\RUCA';

 
proc format ;
value type_
1='Acute Care Hospital'
2='Rehabilitation hospitals'
3='Psychiatric hospitals'
4='Long-term hospitals'
;
run;
* Make Hospital Characteristics Summary File;

%macro AHA(yr=);
data temp;
set aha.aha&yr.;

 
 
* Egilible Acute Care Hospitals (general medical and surgical ;
if serv=10 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=1; 
* Inegilible Rehabilitation ;
if serv=46 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=2;
* Inegilible Psychiatric ; 
if serv=22 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=3; 
* Inegilible Long-Term Acute Care ;
if serv=80 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=4;

 
if sysid ^='' then system=1; else system=0;
 
if type in (1,2,3,4);
keep provider id zip type hospsize hosp_reg4 profit2 teaching system p_medicaid ;
run;




* Add RUCA level from external file;
proc sql;
create table aha&yr. as
select a.*,b.ruca_level
from temp A left join rural.SAS_2006_RUCA B
on A.zip=B.ZIPA;
quit;

* Calculate how many hospitals in each category ;
proc freq data=aha&yr.;title "Hospital Type &yr.";tables type;run;
 
%mend AHA;
%AHA(yr=12);
%AHA(yr=11);
%AHA(yr=10);
%AHA(yr=09);
%AHA(yr=08);
 
/* 2012 has more comprehensive Data;
proc sql;
create table temp as
select a.id as id1, a.provider as provider1, a.zip as zip1, a.type as type1, a.hospsize as hospsize1, a.hosp_reg4 as hosp_reg4_1, a.profit2 as profit2_1, a.teaching as teaching1, a.system as system1, a.p_medicaid as p_medicaid1,
b.id as id2, b.provider as provider2, b.zip as zip2, b.type as type2, b.hospsize as hospsize2, b.hosp_reg4 as hosp_reg4_2, b.profit2 as profit2_2, b.teaching as teaching2, b.system as system2, b.p_medicaid as p_medicaid2

from aha08 a full join aha12 b
on a.provider=b.provider;
quit;
*/



*********************************
HIT responses
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

 





******* Raw Rates by Types and output tables and graphs;

%macro long(year=);
data temp1;
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
from aha12 A left join temp1 B
on A.id=B.id;
quit;

data temp4;
set temp3;
if basic_adopt ne . then respond=1;else respond=0;
if type=1 then eligibility=1;else eligibility=0;
run;

proc freq data=temp4;
title "Sample Size &year."; 
format type type_.;
where respond=1;
tables type;
run;


 

* Response rate stratified by Type/ Size / Type*Size ;
* Covariate: size;
* Stratum: Eligible hospitals vs Ineligible hospitals ;
 
proc logistic data=temp4;
title 'Response Rate Model';
	class respond(ref="0") hospsize(ref="1")  type(ref="1") hosp_reg4(ref="1") profit2(ref="1") teaching(ref="3") system(ref="1") ruca_level(ref="1")  /param=ref;
	model respond  = hospsize type hosp_reg4 profit2 teaching system ruca_level; 
	output  out=temp5 p=prob;  
run;



data final&year.;
set temp5;
if respond=1;
wt=1/prob;
year=20&year.;
run;

* Overall trend ;
proc means data=final&year. ;
class type ;
weight wt;
var basic_adopt;
output out=step1_&year._unadj(keep=type rate) mean=rate;
run;

 

%mend long;
%long(year=08);
%long(year=09);
%long(year=10);
%long(year=11);
%long(year=12);
%long(year=13);
 
 

* Plot Overall Trend;

data graph1;
set step1_08_unadj(in=in08) step1_09_unadj(in=in09) step1_10_unadj(in=in10) step1_11_unadj(in=in11) step1_12_unadj(in=in12) step1_13_unadj(in=in13);
where type ne .;
if in08 then year=2008; 
if in09 then year=2009; 
if in10 then year=2010; 
if in11 then year=2011; 
if in12 then year=2012; 
if in13 then year=2013; 
 
keep type rate year;
run;

proc sgplot data=graph1;
title "Raw Rates: Acute Care Hospitals vs Rehabilitation hospitals";
format type type_.;where type in (1,2);
series X=year y=rate/group=type datalabel=rate;
run;
proc sgplot data=graph1;
title "Raw Rates: Acute Care Hospitals vs Psychiatric hospitals";
format type type_.;where type in (1,3);
series X=year y=rate/group=type datalabel=rate;
run;
proc sgplot data=graph1;
title "Raw Rates: Acute Care Hospitals vs Long-term hospitals";
format type type_.;where type in (1,4);
series X=year y=rate/group=type datalabel=rate;
run;

 
*******************************************Models;


***************************
Diff-in-Diff in Slope/trend
***************************;
%macro model(type=,name=,fullname=);

data allyear_type12;
set final08 final09 final10 final11 final12 final13;
if year=2008 then do;year1=0; time=1;post=0; end;
else if year=2009 then do;year1=1; time=2;post=0; end;
else if year=2010 then do;year1=2; time=3;post=0; end;
else if year=2011 then do;year1=3; time=4;post=1; end;
else if year=2012 then do;year1=4;time=5;post=1; end;
else if year=2013 then do;year1=5;time=6;post=1; end;
year2=post*(year1-2);
where type in(1,&type.);
keep id type  year1 year2 time  basic_adopt wt post  ;
run;
proc sort data=allyear_type12;by id year1;run;

* Linear model;
proc genmod data=allyear_type12 descending  ;
weight wt;
class id type(ref="1") time(ref="1") post(ref="0")/param=ref;
model basic_adopt=type year1 post post*type type*year1 post*year2 post*year2*type/dist=normal link=identity corrb ;
repeated subject=id/withinsubject=time type=un;
output out=predict p=pro l=lower u=upper;
estimate "Beta 1+ 4" year1 1 type*year1 1 -1;
estimate "Beta 1+ 6" year1 1 post*year2 1 -1;
estimate "Beta 1+ 4+6+7" year1 1 type*year1 1 -1 post*year2 1 -1 post*year2*type 1 -1;
estimate "Beta 4+ 7"  type*year1 1 -1 post*year2*type 1 -1;
estimate "Beta 6+7" post*year2 1 -1 post*year2*type 1 -1;
run;

proc sort data=predict(keep=pro year1 type ) nodupkey;by year1 type;run;

data generate1 generate2 generate3 generate4;
set predict;
year=2008+year1;
if year <2011 and type=1 then do;pre_acute=pro;output generate1;end;
else if year <2011 and type=&type.  then do;pre_&name.=pro;output generate2;end;
else if year >2010 and type=1 then do;post_acute=pro;output generate3;end;
else if year >2010 and type=&type. then do;post_&name.=pro;output generate4;end;
run;

data generate0;
set graph1;
where type in (1,&type.);
keep year type rate;
run;

proc sort data=generate0;by year;run;

data graph2;
merge generate0 generate1(keep=year pre_acute) generate2(keep=year pre_&name.) generate3(keep=year post_acute) generate4(keep=year post_&name.);
by year;
run;



proc sgplot data=graph2;
title1 "Model Estimation: Acute Care Hospitals vs &fullname.";
scatter X=year y=rate/markerattrs=(symbol=STARFILLED) LEGENDLABEL ="True Rate";
series X=year  y=pre_acute/lineattrs=(color=blue) LEGENDLABEL ='Pre-period Acute Care Hospitals';
series X=year  y=pre_&name./lineattrs=(color=red)LEGENDLABEL ='Pre-period &fullname.';
series X=year  y=post_acute/lineattrs=(color=green) LEGENDLABEL ='Post-period Acute Care Hospitals';
series X=year  y=post_&name./lineattrs=(color=purple)LEGENDLABEL ='Post-period &fullname.';
xaxis label='Year' values=(2008 to 2013 by 1);
yaxis label='Adoption Rate';
run;
 

%mend model;
%model(type=2,name=Rehab,fullname=Rehabilitation hospitals);
%model(type=3,name=Psychiatric,fullname=Psychiatric hospitals);
%model(type=4,name=LTAC,fullname=Long-term hospitals);




 







/**************************************************************************************************************
(2) diff-in-diff model/graph for the subset of ineligible (all types) and eligible hospitals that, in the "pre" period, 
did not have any of the following basic EHR functions:

Electronic Clinical documentation 
b. Physician notes                                           -q1b1 
c. Nursing notes                                             -q1c1  
d. Problem lists                                             -q1d1
f.  Discharge summaries                                      -q1f1

Results Viewing 
d. Diagnostic test results (e.g. EKG report, Echo report)    -q1d2

Computerized Provider Order Entry 
c. Medications- CPOE                                         -q1c3                                   


Because these are part of the "basic" EHR definition, this will force the "pre-EHR adoption rate" to be zero in both years for both groups.  
I realize this also requires you to limit the analysis to the subset of hospitals that responded in at least 1 pre-period year and 1 post-period year (right?  
I think so...) basically we want to try to find the group of eligible and ineligible hospitals that had roughly equivalent EHR functions in the pre period.  

More generally, we are trying to make the "pre" period adoption rates look more similar in the two groups and 
so these are two ideas we had for how we might accomplish this.
************************************************************************************************************/
 


/*
So this could be no-no-no for 08-09-10 OR missing-no-no OR missing-missing-no OR no-missing-no OR ... but basically if they are ever a "yes" in the 2008-2010 
years, we should drop them and we should also drop if they are missing for all three pre years.  
*/

data temp08;
set hit08;
if q1b1 not in (1,2) and q1c1 not in (1,2) and q1d1 not in (1,2) and q1f1 not in (1,2) and q1d2 not in (1,2) and q1c3 not in (1,2) then f=0;else f=1;
keep id f ;
run; 
data temp09;
set hit09;
if q1b1 not in (1,2) and q1c1 not in (1,2) and q1d1 not in (1,2) and q1f1 not in (1,2) and q1d2 not in (1,2) and q1c3 not in (1,2) then f=0;else f=1;
keep id f ;
run; 
data temp10;
set hit10;
if q1b1 not in (1,2) and q1c1 not in (1,2) and q1d1 not in (1,2) and q1f1 not in (1,2) and q1d2 not in (1,2) and q1c3 not in (1,2) then f=0;else f=1;
keep id f;
run;  
 


proc sql;
create table temp1 as
select a.id, a.type, b.f as f08
from aha12 A left join temp08 B
on A.id=B.id;
quit;
proc sql;
create table temp2 as
select a.*, b.f as f09
from temp1 A left join temp09 B
on A.id=B.id;
quit;
proc sql;
create table temp3 as
select a.*, b.f as f10
from temp2 A left join temp10 B
on A.id=B.id;
quit;

 
 
* Sample Selection;
data sample;
set temp3;
if f08=. and f09=. and f10=. then drop=1;
if f08=1 or f09=1 or f10=1 then drop=1;
if drop ne 1;
run;
proc freq data=sample;
title 'Sample Size Part 2';
tables type;
run; 








******* Raw Rates by Types and output tables and graphs;

%macro long(year=);

proc sql;
create table temp as
select a.*
from hit&year. a
where a.id in (select id from sample);
quit;

data temp1;
set temp;
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
from aha12 A left join temp1 B
on A.id=B.id;
quit;

data temp4;
set temp3;
if basic_adopt ne . then respond=1;else respond=0;
if type=1 then eligibility=1;else eligibility=0;
run;

proc freq data=temp4;
title "Sample Size &year."; 
format type type_.;
where respond=1;
tables eligibility;
run;


 

* Response rate stratified by Type/ Size / Type*Size ;
* Covariate: size;
* Stratum: Eligible hospitals vs Ineligible hospitals ;
 
proc logistic data=temp4;
title 'Response Rate Model';
	class respond(ref="0") hospsize(ref="1")  type(ref="1") hosp_reg4(ref="1") profit2(ref="1") teaching(ref="3") system(ref="1") ruca_level(ref="1")  /param=ref;
	model respond  = hospsize type hosp_reg4 profit2 teaching system ruca_level; 
	output  out=temp5 p=prob;  
run;



data final&year.;
set temp5;
if respond=1;
wt=1/prob;
year=20&year.;
run;

* Overall trend ;
proc means data=final&year. ;
class eligibility ;
weight wt;
var basic_adopt;
output out=step1_&year._unadj(keep=eligibility rate) mean=rate;
run;

 

%mend long;
%long(year=08);
%long(year=09);
%long(year=10);
%long(year=11);
%long(year=12);
%long(year=13);
  


* Plot Overall Trend;

data graph1;
set step1_08_unadj(in=in08) step1_09_unadj(in=in09) step1_10_unadj(in=in10) step1_11_unadj(in=in11) step1_12_unadj(in=in12) step1_13_unadj(in=in13);
where eligibility ne .;
if in08 then year=2008; 
if in09 then year=2009; 
if in10 then year=2010; 
if in11 then year=2011; 
if in12 then year=2012; 
if in13 then year=2013; 
 
keep eligibility rate year;
run;

proc sgplot data=graph1;
title "Raw Rates: Acute Care Hospitals vs Rehabilitation hospitals";
series X=year y=rate/group=eligibility datalabel=rate;
run;
 




*******************************************Models;


***************************
Diff-in-Diff in Slope/trend
***************************;
 

data allyear;
set final11 final12 final13;
if year=2011 then do;year1=0;time=1;end;
else if year=2012 then do;year1=1;time=2; end;
else if year=2013 then do;year1=2; time=3; end;
 
keep id eligibility  year year1 time  basic_adopt wt  ;
run;
proc sort data=allyear;by id year1 ;run;

* Linear model;
proc genmod data=allyear descending  ;
weight wt;
class id eligibility(ref="1") time(ref="1")  /param=ref;
model basic_adopt=eligibility year1   eligibility*year1 /dist=normal link=identity corrb ;
repeated subject=id/withinsubject=time type=un;
output out=predict p=pro l=lower u=upper;
 estimate "Beta 1+ 3" year1 1 eligibility*year1 1 -1;
run;

proc sort data=predict(keep=pro year eligibility) nodupkey;by year eligibility;run;

data post_eligible post_ineligible;
set predict;
if  eligibility=1 then do;post_eligible=pro;output post_eligible;end;
else if   eligibility=0  then do;post_ineligible=pro;output post_ineligible;end;
run;

 proc sql;
 create table temp1 as
 select a.*,b.post_eligible
 from graph1 a left join post_eligible b
 on a.eligibility=b.eligibility and a.year=b.year;
 quit;
  proc sql;
 create table temp2 as
 select a.*,b.post_ineligible
 from temp1 a left join post_ineligible b
 on a.eligibility=b.eligibility and a.year=b.year;
 quit;


data graph2;
set temp2;
if year in (2008,2009,2010) then do;pre_eligible=0 ;pre_ineligible=0;end;
run;



proc sgplot data=graph2;
title1 "Model Estimation: Eligible vs In-Eligible";
scatter X=year y=rate/markerattrs=(symbol=STARFILLED) LEGENDLABEL ="True Rate";
series X=year  y=pre_eligible/lineattrs=(color=blue) LEGENDLABEL ='Pre-period Eligible Hospitals';
series X=year  y=pre_ineligible/lineattrs=(color=red)LEGENDLABEL ='Pre-period In-Eligible';
series X=year  y=post_eligible/lineattrs=(color=green) LEGENDLABEL ='Post-period Eligible Hospitals';
series X=year  y=post_ineligible/lineattrs=(color=purple)LEGENDLABEL ='Post-period In-Eligible';
xaxis label='Year' values=(2008 to 2013 by 1);
yaxis label='Adoption Rate';
run;
 
 






































 
