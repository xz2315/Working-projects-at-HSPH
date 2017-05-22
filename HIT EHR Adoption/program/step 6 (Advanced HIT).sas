****************************************************************************
How Advanced HIT adoption change the effect of Basic EHR adoption on Outcomes
8/22/2014
Xiner Zhou
*******************************************************************************;
 
libname HIT "C:\data\Data\Hospital\AHA\HIT\data" access=readonly;
libname impact "C:\data\Data\Hospital\Impact";
LIBNAME AHA 	"C:\data\Data\Hospital\AHA\Annual_Survey\data";
libname ruca 'C:\data\Data\RUCA';
/*
q18_Create_a_dashboard_with_meas
q18_Create_a_dashboard_with_mea0
q18_Create_individual_provider_p
q18_Create_an_approach_for_clini
q18_Assess_adherence_to_clinical
q18_Identify_care_gaps_for_speci
q18_Generate_reports_to_inform_s
q18_Maximize_quality_improvement
q18_Identify_high_risk_patients_
*/



/* Outcome Measures:
average payment, mortality, 30-day readmits COMBINED for the 15 conditions:
AMI, CHF, PN, COPD, Stroke, Sepsis, Esophageal/Gastric Disease, GI Bleeding, 
Urinary Tract Infection, Metabolic Disorder, Arrhythmia, Chest Pain, Renal Failure, Respiratory Disease, Hip Fracture
*/






***************************************** major predictors: Advanced HIT Measure in 2013;
data hit13; 
set hit.hit13;
*char to num, and rename;
q1=q18_Create_a_dashboard_with_meas*1;
q2=q18_Create_a_dashboard_with_mea0*1;
q3=q18_Create_individual_provider_p*1;
q4=q18_Create_an_approach_for_clini*1;
q5=q18_Assess_adherence_to_clinical*1;
q6=q18_Identify_care_gaps_for_speci*1;
q7=q18_Generate_reports_to_inform_s*1;
q8=q18_Maximize_quality_improvement*1;
if q18_Identify_high_risk_patients_ ='1' then q90=1;else if q18_Identify_high_risk_patients_ ='0' then q90=0;

* Perf_Measure: whether has one of the three ;
* Perf_Measure_Num: How many;
if q1=0 and q2=0 and q3=0 then Perf_Measure=0;else Perf_Measure=1;
Perf_Measure_Num=q1+q2+q3;
* Analytics_Measure: whether has one of the three ;
* Analytics_Measure_Num: How many;
if q5=0 and q6=0 and q90=0 then Analytics_Measure=0;else Analytics_Measure=1;
Analytics_Measure_Num=q5+q6+q90;


where q18_Create_a_dashboard_with_meas ne '.' 
and q18_Create_a_dashboard_with_mea0 ne '.' 
and q18_Create_individual_provider_p ne '.' 
and q18_Create_an_approach_for_clini ne '.' 
and q18_Assess_adherence_to_clinical ne '.' 
and q18_Identify_care_gaps_for_speci ne '.' 
and q18_Generate_reports_to_inform_s ne '.' 
and q18_Maximize_quality_improvement ne '.' 
and q18_Identify_high_risk_patients_ ne '.' ;
keep id q1 q2 q3 q4 q5 q6 q7 q8 q90 Perf_Measure Perf_Measure_Num Analytics_Measure Analytics_Measure_Num;
run;



*********************************************** Basic EHR Adoption in 2012;
 data basic13;
set hit.hit13(keep= q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 id);
array basic {10}  q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3;
total=0;
do i= 1 to 10;
	if basic(i) in (1,2) then total=total+1;
end;
drop i;
		 
if total=10 then basic_adopt=1;else basic_adopt=0; 

keep id basic_adopt;
run; 
*********************************************** Confounders: Hospital Characteristics;
proc sql;
create table aha12 as
select a.id,a.provider,a.zip,a.hospsize, a.hosp_reg4, a.profit2, a.teaching, a.sysid, b.ruca_level
from aha.aha12 a left join ruca.SAS_2006_RUCA b
on a.zip=b.zipa;
quit;
data aha12;
set aha12;
if sysid ne '' then system=1;else system=0;
drop sysid;
run;
  

************************************************** Outcome Measures: Average Payments, Readmission, Mortality ;
libname pay 'C:\data\Data\Hospital\Medicare_Inpt\Payments';
libname readm 'C:\data\Data\Hospital\Medicare_Inpt\Readmission\data';
libname mort 'C:\data\Data\Hospital\Medicare_Inpt\Mortality\data';

data pay12;
set pay.Hosppayment12;
keep provider avgallconditionpayment12;
run;
 
data readm12;
set readm.Adjreadm36meas30day2012;
array N{15} NDmeas_amiall  NDmeas_chfall NDmeas_pnall NDmeas_copdall NDmeas_strokeall NDmeas_sepsisall NDmeas_esggasall NDmeas_giball
NDmeas_utiall NDmeas_metdisall NDmeas_arrhyall NDmeas_chestall NDmeas_renalfall NDmeas_respall NDmeas_hipfxall;
array pct{15} rawreadmmeas_amiall30day rawreadmmeas_chfall30day rawreadmmeas_pnall30day rawreadmmeas_copdall30day rawreadmmeas_strokeall30day
rawreadmmeas_sepsisall30day rawreadmmeas_esggasall30day rawreadmmeas_giball30day rawreadmmeas_utiall30day rawreadmmeas_metdisall30day
rawreadmmeas_arrhyall30day rawreadmmeas_chestall30day rawreadmmeas_renalfall30day rawreadmmeas_respall30day rawreadmmeas_hipfxall30day;
com_readm=(N{1}*pct{1}+N{2}*pct{2}+N{3}*pct{3}+N{4}*pct{4}+N{5}*pct{5}+N{6}*pct{6}+N{7}*pct{7}+N{8}*pct{8}+N{9}*pct{9}+N{10}*pct{10}+N{11}*pct{11}+N{12}*pct{12}+N{13}*pct{13}+N{14}*pct{14}+N{15}*pct{15})/(N{1}+N{2}+N{3}+N{4}+N{5}+N{6}+N{7}+N{8}+N{9}+N{10}+N{11}+N{12}+N{13}+N{14}+N{15});
keep 
provider com_readm 
NDmeas_amiall  NDmeas_chfall NDmeas_pnall NDmeas_copdall NDmeas_strokeall NDmeas_sepsisall NDmeas_esggasall NDmeas_giball
NDmeas_utiall NDmeas_metdisall NDmeas_arrhyall NDmeas_chestall NDmeas_renalfall NDmeas_respall NDmeas_hipfxall
rawreadmmeas_amiall30day rawreadmmeas_chfall30day rawreadmmeas_pnall30day rawreadmmeas_copdall30day rawreadmmeas_strokeall30day
rawreadmmeas_sepsisall30day rawreadmmeas_esggasall30day rawreadmmeas_giball30day rawreadmmeas_utiall30day rawreadmmeas_metdisall30day
rawreadmmeas_arrhyall30day rawreadmmeas_chestall30day rawreadmmeas_renalfall30day rawreadmmeas_respall30day rawreadmmeas_hipfxall30day
;
run;
 
data mort12;
set mort.adjmort40meas30day12;
array N{15} NDmortmeas_amiALL NDmortmeas_chfALL NDmortmeas_pnALL NDmortmeas_copdALL NDmortmeas_strokeALL NDmortmeas_sepsisALL NDmortmeas_esggasALL NDmortmeas_gibALL
NDmortmeas_utiALL NDmortmeas_metdisALL NDmortmeas_arrhyALL NDmortmeas_chestALL NDmortmeas_renalfALL NDmortmeas_respALL NDmortmeas_hipfxALL;
array pct{15} rawmortmeas_amiALL30day rawmortmeas_chfALL30day rawmortmeas_pnALL30day rawmortmeas_copdALL30day rawmortmeas_strokeALL30day rawmortmeas_sepsisALL30day rawmortmeas_esggasALL30day rawmortmeas_gibALL30day
rawmortmeas_utiALL30day rawmortmeas_metdisALL30day rawmortmeas_arrhyALL30day rawmortmeas_chestALL30day rawmortmeas_renalfALL30day rawmortmeas_respALL30day rawmortmeas_hipfxALL30day ;
;
com_mort=(N{1}*pct{1}+N{2}*pct{2}+N{3}*pct{3}+N{4}*pct{4}+N{5}*pct{5}+N{6}*pct{6}+N{7}*pct{7}+N{8}*pct{8}+N{9}*pct{9}+N{10}*pct{10}+N{11}*pct{11}+N{12}*pct{12}+N{13}*pct{13}+N{14}*pct{14}+N{15}*pct{15})/(N{1}+N{2}+N{3}+N{4}+N{5}+N{6}+N{7}+N{8}+N{9}+N{10}+N{11}+N{12}+N{13}+N{14}+N{15});

keep provider com_mort 
NDmortmeas_amiALL NDmortmeas_chfALL NDmortmeas_pnALL NDmortmeas_copdALL NDmortmeas_strokeALL NDmortmeas_sepsisALL NDmortmeas_esggasALL NDmortmeas_gibALL
NDmortmeas_utiALL NDmortmeas_metdisALL NDmortmeas_arrhyALL NDmortmeas_chestALL NDmortmeas_renalfALL NDmortmeas_respALL NDmortmeas_hipfxALL 
rawmortmeas_amiALL30day rawmortmeas_chfALL30day rawmortmeas_pnALL30day rawmortmeas_copdALL30day rawmortmeas_strokeALL30day rawmortmeas_sepsisALL30day rawmortmeas_esggasALL30day rawmortmeas_gibALL30day
rawmortmeas_utiALL30day rawmortmeas_metdisALL30day rawmortmeas_arrhyALL30day rawmortmeas_chestALL30day rawmortmeas_renalfALL30day rawmortmeas_respALL30day rawmortmeas_hipfxALL30day ;
;
run;
 





***********************************Merge Outcome Measures = Predictors + Confounders;

* 2649-->2554;
proc sql;
create table temp1 as
select a.Perf_Measure, a.Perf_Measure_Num, a.Analytics_Measure, a.Analytics_Measure_Num, b.*
from hit13 a inner join aha12 b
on a.id=b.id;
quit;

* 2554-->2554;
proc sql;
create table temp2 as
select *
from temp1 a inner join basic13 b
on a.id=b.id;
quit;

data temp2 ;
set temp2;
if basic_adopt=0 and perf_measure=0 then perf_group=0;
else if basic_adopt=0 and perf_measure=1 then perf_group=.;
else if basic_adopt=1 and perf_measure=0 then perf_group=1;
else if basic_adopt=1 and perf_measure=1 then perf_group=2;
if basic_adopt=0 and analytics_measure=0 then analytics_group=0;
else if basic_adopt=0 and analytics_measure=1 then analytics_group=.;
else if basic_adopt=1 and analytics_measure=0 then analytics_group=1;
else if basic_adopt=1 and analytics_measure=1 then analytics_group=2;
if hosp_reg4 ne 5 and profit2 ne 4 and ruca_level ne .;
run;

*Pay: 2554-->2312;
proc sql;
create table pay as
select a.*,b.avgallconditionpayment12 as com_pay
from temp2 a inner join pay12 b
on a.provider =b.provider;
quit;

*readmission: 2554-->1749;
proc sql;
create table readm as
select a.*,b.com_readm 
from temp2 a inner join readm12 b
on a.provider =b.provider;
quit;


*Mortality: 2554-->2302;
proc sql;
create table mort as
select a.*,b.com_mort
from temp2 a inner join mort12 b
on a.provider =b.provider;
quit;


 
 
 







/*
how “Advanced use in 2013” change the effect of “Basic EHR adoption in 2012” on “Outcomes in 2012” (Mortality, Payment, readmission).  

1.	Outcome=Basic EHR + Hospital Characteristics (control for confounders)
2.	Outcome= Basic EHR + 4 Advanced Measures + Hospital Characteristics (control for confounders)
*/


/*
For Model 2, let's try some different combos of the advanced HIT measures:
(1) each advanced HIT measure separately
(2) two dichotomous HIT measures included in same model (Perf_Measure Analytics_Measure)
(3) two continuous HIT measures included in same model (Perf_measure_num Analytics_measure_num)
So six total models...
*/


%macro model(y=);

proc genmod data=&y.;
class basic_adopt(ref='0' param=ref) hospsize(ref='1' param=ref) hosp_reg4(ref='1' param=ref) profit2(ref='1' param=ref) teaching(ref='1' param=ref) 
system(ref='0' param=ref) ruca_level(ref='1' param=ref) ;
	model com_&y.=basic_adopt hospsize hosp_reg4 profit2 teaching system ruca_level/dist=normal link=identity type3;
run;

proc genmod data=&y.;
class Perf_Measure(ref='0' param=ref) basic_adopt(ref='0' param=ref) hospsize(ref='1' param=ref) hosp_reg4(ref='1' param=ref) profit2(ref='1' param=ref) teaching(ref='1' param=ref) 
system(ref='0' param=ref) ruca_level(ref='1' param=ref) ;
	model com_&y.=basic_adopt Perf_Measure hospsize hosp_reg4 profit2 teaching system ruca_level/dist=normal link=identity type3;
run;
proc genmod data=&y.;
class Analytics_Measure(ref='0' param=ref) basic_adopt(ref='0' param=ref) hospsize(ref='1' param=ref) hosp_reg4(ref='1' param=ref) profit2(ref='1' param=ref) teaching(ref='1' param=ref) 
system(ref='0' param=ref) ruca_level(ref='1' param=ref) ;
	model com_&y.=basic_adopt Analytics_Measure hospsize hosp_reg4 profit2 teaching system ruca_level/dist=normal link=identity type3;
run;
proc genmod data=&y.;
class  basic_adopt(ref='0' param=ref) hospsize(ref='1' param=ref) hosp_reg4(ref='1' param=ref) profit2(ref='1' param=ref) teaching(ref='1' param=ref) 
system(ref='0' param=ref) ruca_level(ref='1' param=ref) ;
	model com_&y.=basic_adopt Perf_measure_num hospsize hosp_reg4 profit2 teaching system ruca_level/dist=normal link=identity type3;
run;
proc genmod data=&y.;
class  basic_adopt(ref='0' param=ref) hospsize(ref='1' param=ref) hosp_reg4(ref='1' param=ref) profit2(ref='1' param=ref) teaching(ref='1' param=ref) 
system(ref='0' param=ref) ruca_level(ref='1' param=ref) ;
	model com_&y.=basic_adopt Analytics_measure_num hospsize hosp_reg4 profit2 teaching system ruca_level/dist=normal link=identity type3;
run;

proc genmod data=&y.;
class Perf_Measure(ref='0' param=ref) Analytics_Measure(ref='0' param=ref) basic_adopt(ref='0' param=ref) hospsize(ref='1' param=ref) hosp_reg4(ref='1' param=ref) profit2(ref='1' param=ref) teaching(ref='1' param=ref) 
system(ref='0' param=ref) ruca_level(ref='1' param=ref) ;
	model com_&y.=basic_adopt Perf_Measure Analytics_Measure hospsize hosp_reg4 profit2 teaching system ruca_level/dist=normal link=identity type3;
run;
proc genmod data=&y.;
class  basic_adopt(ref='0' param=ref) hospsize(ref='1' param=ref) hosp_reg4(ref='1' param=ref) profit2(ref='1' param=ref) teaching(ref='1' param=ref) 
system(ref='0' param=ref) ruca_level(ref='1' param=ref) ;
	model com_&y.=basic_adopt Perf_measure_num Analytics_measure_num hospsize hosp_reg4 profit2 teaching system ruca_level/dist=normal link=identity type3;
run;

%mend model;
%model(y=mort);
%model(y=readm);
%model(y=pay);



 










****************************************************************Second Iteration;

/*
Could you try the following: create three groups of hospitals-
(1) less than basic EHR 
(2) at least basic EHR and perf-measure =0
(3) at least basic EHR and perf-measure =1
 
And then run a model with a dummy for group (2) and a dummy for group (3)  with (1) as omitted group. 
 
Then repeat for analytics-measure. 
 
So total of 6 new models - and include hospital characteristics please:)
*/






* Hospital Characteristics Table;

proc freq data=temp2;tables basic_adopt*perf_measure basic_adopt*analytics_measure ;run;
%macro table1(var=);
* Hospsize;
proc freq data=temp2;
where &var. in (0,1,2);
table hospsize * &var./nocum norow chisq out=temp outpct ;
run;
data temp;
set temp;
num=count||' ('||trim(put(pct_col,5.2))||'%)';
drop count percent pct_row pct_col;
run;
proc transpose data=temp out=hospsize;
by hospsize;
var num;
run;


* region;
proc freq data=temp2;
where &var. in (0,1,2);
table hosp_reg4 * &var./nocum norow chisq out=temp outpct ;
run;
data temp;
set temp;
num=count||' ('||trim(put(pct_col,5.2))||'%)';
drop count percent pct_row pct_col;
run;
proc transpose data=temp out=hosp_reg4 ;
by hosp_reg4 ;
var num;
run;
 
* Teaching;
proc freq data=temp2;
where &var. in (0,1,2);
table Teaching * &var./nocum norow chisq out=temp outpct ;
run;
data temp;
set temp;
num=count||' ('||trim(put(pct_col,5.2))||'%)';
drop count percent pct_row pct_col;
run;
proc transpose data=temp out=Teaching ;
by Teaching ;
var num;
run;

* Profit;
proc freq data=temp2;
where &var. in (0,1,2);
table profit2 * &var./nocum norow chisq out=temp outpct ;
run;
data temp;
set temp;
num=count||' ('||trim(put(pct_col,5.2))||'%)';
drop count percent pct_row pct_col;
run;
proc transpose data=temp out=profit2;
by profit2;
var num;
run;

* Ruca_level;
proc freq data=temp2;
where &var. in (0,1,2);
table Ruca_level * &var./nocum norow chisq out=temp outpct ;
run;
data temp;
set temp;
num=count||' ('||trim(put(pct_col,5.2))||'%)';
drop count percent pct_row pct_col;
run;
proc transpose data=temp out=Ruca_level;
by Ruca_level;
var num;
run;

* System;
proc freq data=temp2;
where &var. in (0,1,2);
table System*&var./nocum norow chisq out=temp outpct ;
run;
data temp;
set temp;
num=count||' ('||trim(put(pct_col,5.2))||'%)';
drop count percent pct_row pct_col;
run;
proc transpose data=temp out=System;
by System;
var num;
run;
%mend table1;

%table1(var=perf_group);
%table1(var=analytics_group);

******output;

ods _all_ close;
ods tagsets.ExcelXP path='C:\data\Projects\HIT EHR Adoption' file='table1.xml' style=Printer;
proc print data=hospsize;run;
proc print data=hosp_reg4;run;
proc print data=teaching;run;
proc print data=profit2;run;
proc print data=Ruca_level;run;
proc print data=System;run;
ods tagsets.ExcelXP close;





 
%let var=hospsize hosp_reg4  teaching profit2 ruca_level system;
%macro model(x= ,y=);
* raw ;
proc means data=&y.;
where &x. in (0,1,2);
class &x.;
var com_&y.;
output out=raw_&y._perf mean=mean;
run;
%do i=1 %to 6;
proc means data=&y.;
where &x. in (0,1,2);
class %scan(&var.,&i.);
var com_&y.;
output out=raw_&y._%scan(&var.,&i.) mean=mean;
run;
%end;

*effect estimate;
proc genmod data=&y.;
where &x. in (0,1,2);
class &x.(ref='0' param=ref) hospsize(ref='1' param=ref) hosp_reg4(ref='1' param=ref) profit2(ref='1' param=ref) teaching(ref='1' param=ref) 
system(ref='0' param=ref) ruca_level(ref='1' param=ref) ;
	model com_&y.=&x. hospsize hosp_reg4 profit2 teaching system ruca_level/dist=normal link=identity type3;
run;

* LS-means;
proc genmod data=&y.;
where &x. in (0,1,2);
class &x. hospsize  hosp_reg4  profit2  teaching  system  ruca_level/param=glm ;
	model com_&y.=&x. hospsize hosp_reg4 profit2 teaching system ruca_level/dist=normal link=identity  ;
	lsmeans &x. hospsize  hosp_reg4  profit2  teaching  system  ruca_level;
run;
/*
%do i=1 %to 6;
proc genmod data=&y.;
class &x. hospsize  hosp_reg4  profit2  teaching  system  ruca_level/param=glm ;
	model com_&y.=&x. hospsize hosp_reg4 profit2 teaching system ruca_level/dist=normal link=identity  ;
	lsmeans %scan(&var.,&i.,'');
run;
%end;

*/

%mend model;
%model(x=perf_group,y=pay);
%model(x=analytics_group,y=pay);
%model(x=perf_group,y=mort);
%model(x=analytics_group,y=mort);
%model(x=perf_group,y=readm);
%model(x=analytics_group,y=readm);

proc means data=readm;
var com_readm;
run;
