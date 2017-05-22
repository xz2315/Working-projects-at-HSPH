******************************************************************************
Version 6 Analyses
Xiner Zhou
6/11/2015
******************************************************************************;
libname HIT "C:\data\Data\Hospital\AHA\HIT\data";
libname impact "C:\data\Data\Hospital\Impact";
LIBNAME AHA 	"C:\data\Data\Hospital\AHA\Annual_Survey\data";
libname rural 'C:\data\Data\RUCA';


/*
Xiner -- Sorry to ask this of you, but as I'm going back to this paper, I'm hoping that you can run a couple more "single function" results to present at Academy Health.  Same set-up as other single function results, but the following new ones:
(1) nursing notes --q1c1
(2) Lab CPOE -- q1a3
(3) Rad CPOE -- q1b3
(4) Nursing orders CPOE --q1e3
(5) Bar coding medication administration --q1a5

Earlier:
medication CPOE  --q1c3                   
discharge summaries --q1f1
patient problem list --q1d1
patient medication list --q1e1
drug-drug interaction checking --q1d4
drug-allergy interaction checking --q1c4
drug dosing support --q1f4
drug lab interaction checking --q1e4
clinical guidelines --q1a4
clinical reminders --q1b4
*/


%let keep1=q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4 q1a5 q1b5 q1c5 q1d5 q1a6 q1b6 q1c6;
%let keep2=q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_g1 q1_a2 q1_b2 q1_c2 q1_d2 q1_e2 q1_f2 q1_a3 q1_b3 q1_c3 q1_d3 q1_e3 q1_a4 q1_b4 q1_c4 q1_d4 q1_e4 q1_f4 q1_a5 q1_b5 q1_c5 q1_d5 q1_a6 q1_b6 q1_c6;
 
*********************************
HIT responses
*********************************;

*2008;
proc sort data=hit.hit07 out=hit08(keep=id &keep1.);
by id;
run;
data hit08;
set hit08;
q1_a1=q1a1*1;q1_b1=q1b1*1;q1_c1=q1c1*1;q1_d1=q1d1*1;q1_e1=q1e1*1;q1_f1=q1f1*1;q1_g1=q1g1*1;
q1_a2=q1a2*1;q1_b2=q1b2*1;q1_c2=q1c2*1;q1_d2=q1d2*1;q1_e2=q1e2*1;q1_f2=q1f2*1;
q1_a3=q1a3*1;q1_b3=q1b3*1;q1_c3=q1c3*1;q1_d3=q1d3*1;q1_e3=q1e3*1;
q1_a4=q1a4*1;q1_b4=q1b4*1;q1_c4=q1c4*1;q1_d4=q1d4*1;q1_e4=q1e4*1;q1_f4=q1f4*1;
q1_a5=q1a5*1; q1_b5=q1b5*1;q1_c5=q1c5*1;q1_d5=q1d5*1;
q1_a6=q1a6*1;q1_b6=q1b6*1;q1_c6=q1c6*1;
drop &keep1.;
run;
data HIT08;
set HIT08;
rename q1_a1=q1a1;rename q1_b1=q1b1;rename q1_c1=q1c1 ;rename q1_d1=q1d1;rename q1_e1=q1e1;rename q1_f1=q1f1;rename q1_g1=q1g1;
rename q1_a2=q1a2;rename q1_b2=q1b2;rename q1_c2=q1c2;rename q1_d2=q1d2;rename q1_e2=q1e2;rename q1_f2=q1f2;
rename q1_a3=q1a3;rename q1_b3=q1b3;rename q1_c3=q1c3;rename q1_d3=q1d3;rename q1_e3=q1e3;
rename q1_a4=q1a4;rename q1_b4=q1b4;rename q1_c4=q1c4;rename q1_d4=q1d4;rename q1_e4=q1e4;rename q1_f4=q1f4;
rename q1_a5=q1a5;rename q1_b5=q1b5;rename q1_c5=q1c5;rename q1_d5=q1d5;
rename q1_a6=q1a6;rename q1_b6=q1b6;rename q1_c6=q1c6;
run;

*2009;
proc sort data=hit.hit08 out=hit09(keep=id &keep2. it_response );
by id;
run;
data hit09;
set hit09;
if it_response='Yes';
run;
data hit09;
set hit09;
rename q1_a1=q1a1;rename q1_b1=q1b1;rename q1_c1=q1c1 ;rename q1_d1=q1d1;rename q1_e1=q1e1;rename q1_f1=q1f1;rename q1_g1=q1g1;
rename q1_a2=q1a2;rename q1_b2=q1b2;rename q1_c2=q1c2;rename q1_d2=q1d2;rename q1_e2=q1e2;rename q1_f2=q1f2;
rename q1_a3=q1a3;rename q1_b3=q1b3;rename q1_c3=q1c3;rename q1_d3=q1d3;rename q1_e3=q1e3;
rename q1_a4=q1a4;rename q1_b4=q1b4;rename q1_c4=q1c4;rename q1_d4=q1d4;rename q1_e4=q1e4;rename q1_f4=q1f4;
rename q1_a5=q1a5;rename q1_b5=q1b5;rename q1_c5=q1c5;rename q1_d5=q1d5;
rename q1_a6=q1a6;rename q1_b6=q1b6;rename q1_c6=q1c6;
run;
 
*2010;
proc sort data=hit.hit09 out=hit10(keep=id &keep1.);
by id;
run;
data hit10;
set hit10;
q1_a1=q1a1*1;q1_b1=q1b1*1;q1_c1=q1c1*1;q1_d1=q1d1*1;q1_e1=q1e1*1;q1_f1=q1f1*1;q1_g1=q1g1*1;
q1_a2=q1a2*1;q1_b2=q1b2*1;q1_c2=q1c2*1;q1_d2=q1d2*1;q1_e2=q1e2*1;q1_f2=q1f2*1;
q1_a3=q1a3*1;q1_b3=q1b3*1;q1_c3=q1c3*1;q1_d3=q1d3*1;q1_e3=q1e3*1;
q1_a4=q1a4*1;q1_b4=q1b4*1;q1_c4=q1c4*1;q1_d4=q1d4*1;q1_e4=q1e4*1;q1_f4=q1f4*1;
q1_a5=q1a5*1; q1_b5=q1b5*1;q1_c5=q1c5*1;q1_d5=q1d5*1;
q1_a6=q1a6*1;q1_b6=q1b6*1;q1_c6=q1c6*1;
drop &keep1.;
run;
data HIT10;
set HIT10;
rename q1_a1=q1a1;rename q1_b1=q1b1;rename q1_c1=q1c1 ;rename q1_d1=q1d1;rename q1_e1=q1e1;rename q1_f1=q1f1;rename q1_g1=q1g1;
rename q1_a2=q1a2;rename q1_b2=q1b2;rename q1_c2=q1c2;rename q1_d2=q1d2;rename q1_e2=q1e2;rename q1_f2=q1f2;
rename q1_a3=q1a3;rename q1_b3=q1b3;rename q1_c3=q1c3;rename q1_d3=q1d3;rename q1_e3=q1e3;
rename q1_a4=q1a4;rename q1_b4=q1b4;rename q1_c4=q1c4;rename q1_d4=q1d4;rename q1_e4=q1e4;rename q1_f4=q1f4;
rename q1_a5=q1a5;rename q1_b5=q1b5;rename q1_c5=q1c5;rename q1_d5=q1d5;
rename q1_a6=q1a6;rename q1_b6=q1b6;rename q1_c6=q1c6;
run;

*2011;
data hit11;
set hit.hit10(keep=id &keep2.);
proc sort;
by id;
run;
data hit11;
set hit11;
rename q1_a1=q1a1;rename q1_b1=q1b1;rename q1_c1=q1c1 ;rename q1_d1=q1d1;rename q1_e1=q1e1;rename q1_f1=q1f1;rename q1_g1=q1g1;
rename q1_a2=q1a2;rename q1_b2=q1b2;rename q1_c2=q1c2;rename q1_d2=q1d2;rename q1_e2=q1e2;rename q1_f2=q1f2;
rename q1_a3=q1a3;rename q1_b3=q1b3;rename q1_c3=q1c3;rename q1_d3=q1d3;rename q1_e3=q1e3;
rename q1_a4=q1a4;rename q1_b4=q1b4;rename q1_c4=q1c4;rename q1_d4=q1d4;rename q1_e4=q1e4;rename q1_f4=q1f4;
rename q1_a5=q1a5;rename q1_b5=q1b5;rename q1_c5=q1c5;rename q1_d5=q1d5;
rename q1_a6=q1a6;rename q1_b6=q1b6;rename q1_c6=q1c6;
run;
* 2012;
libname HIT1112 "C:\data\Data\Hospital\AHA\HIT\Data\fromshare_Projects-HIT2012-data-stata";
proc sort data=hit1112.Finalitfeb7 out=hit12(keep=id &keep1.);
by id;
run;

* 2013;

proc import datafile="C:\data\Data\Hospital\AHA\HIT\Data\origdata\2013 IT DATA" dbms=xls out=HIT13 replace;
getnames=yes;
run;

proc sort data= hit13 out=hit13(keep=id &keep1.);
by id;
run;
data hit13;
set hit13;
q1_a1=q1a1*1;q1_b1=q1b1*1;q1_c1=q1c1*1;q1_d1=q1d1*1;q1_e1=q1e1*1;q1_f1=q1f1*1;q1_g1=q1g1*1;
q1_a2=q1a2*1;q1_b2=q1b2*1;q1_c2=q1c2*1;q1_d2=q1d2*1;q1_e2=q1e2*1;q1_f2=q1f2*1;
q1_a3=q1a3*1;q1_b3=q1b3*1;q1_c3=q1c3*1;q1_d3=q1d3*1;q1_e3=q1e3*1;
q1_a4=q1a4*1;q1_b4=q1b4*1;q1_c4=q1c4*1;q1_d4=q1d4*1;q1_e4=q1e4*1;q1_f4=q1f4*1;
q1_a5=q1a5*1; q1_b5=q1b5*1;q1_c5=q1c5*1;q1_d5=q1d5*1;
q1_a6=q1a6*1;q1_b6=q1b6*1;q1_c6=q1c6*1;
drop &keep1.;
run;
data HIT13;
set HIT13;
rename q1_a1=q1a1;rename q1_b1=q1b1;rename q1_c1=q1c1 ;rename q1_d1=q1d1;rename q1_e1=q1e1;rename q1_f1=q1f1;rename q1_g1=q1g1;
rename q1_a2=q1a2;rename q1_b2=q1b2;rename q1_c2=q1c2;rename q1_d2=q1d2;rename q1_e2=q1e2;rename q1_f2=q1f2;
rename q1_a3=q1a3;rename q1_b3=q1b3;rename q1_c3=q1c3;rename q1_d3=q1d3;rename q1_e3=q1e3;
rename q1_a4=q1a4;rename q1_b4=q1b4;rename q1_c4=q1c4;rename q1_d4=q1d4;rename q1_e4=q1e4;rename q1_f4=q1f4;
rename q1_a5=q1a5;rename q1_b5=q1b5;rename q1_c5=q1c5;rename q1_d5=q1d5;
rename q1_a6=q1a6;rename q1_b6=q1b6;rename q1_c6=q1c6;
run;


%macro label(yr=);


data HIT&yr.;
set HIT&yr.;

label q1a1='Electronic Clinical documentation: Patient demographics ';
label q1b1='Electronic Clinical documentation: Physician notes';
label q1c1='Electronic Clinical documentation: Nursing notes';
label q1d1='Electronic Clinical documentation: Problem lists';
label q1e1='Electronic Clinical documentation: Medication lists';
label q1f1='Electronic Clinical documentation: Discharge summaries';
label q1g1='Electronic Clinical documentation: Advanced directives (e.g. DNR)';
 	
label q1a2='Results Viewing: Laboratory reports';
label q1b2='Results Viewing: Radiology reports';
label q1c2='Results Viewing: Radiology images';
label q1d2='Results Viewing: Diagnostic test results (e.g.EKG report, Echo report)';
label q1e2='Results Viewing: Diagnostic test images (e.g.EKG tracing)';
label q1f2='Results Viewing: Consultant reports';
 
label q1a3='Computerized Provider Order Entry: Laboratory tests';
label q1b3='Computerized Provider Order Entry: Radiology tests';
label q1c3='Computerized Provider Order Entry: Medications';
label q1d3='Computerized Provider Order Entry: Consultation requests';
label q1e3='Computerized Provider Order Entry: Nursing orders';

label q1a4='Decision Support: Clinical guidelines (e.g. Beta blockers post-MI, ASA in CAD)';
label q1b4='Decision Support: Clinical reminders (e.g.pneumovax)';
label q1c4='Decision Support: Drug allergy alerts';
label q1d4='Decision Support: Drug-drug interaction alerts';
label q1e4='Decision Support: Drug-lab interaction alerts';
label q1f4='Decision Support: Drug dosing support (e.g. renal dose guidance)';
 
label q1a5='Bar Coding or Radio Frequency Identification (RFID) for Closed-loop Medication Tracking: Medication administration';
label q1b5='Bar Coding or Radio Frequency Identification (RFID) for Closed-loop Medication Tracking: Patient verification';
label q1c5='Bar Coding or Radio Frequency Identification (RFID) for Closed-loop Medication Tracking: Caregiver verification';
label q1d5='Bar Coding or Radio Frequency Identification (RFID) for Closed-loop Medication Tracking: Pharmacy verification';

label q1a6='Other Functionalities: Bar coding or Radio Frequency (RFID) for supply chain management';
label q1b6='Other Functionalities: Telehealth';
label q1c6='Other Functionalities: Ability to connect mobile devices(tablet, smart phone, etc.) to EHR';
/*Meaningful Use Functionalities; 
label q2a='Electronic Clinical Documentation: Record gender/sex and date of birth';
label q2b='Electronic Clinical Documentation: Record race and ethnicity';
label q2c='Electronic Clinical Documentation: Record time and preliminary cause of death when applicable';
label q2d='Electronic Clinical Documentation: Record preferred language for communication with providers of care';
label q2e='Electronic Clinical Documentation: Vital signs (height, weight, blood pressure, BMI, growth charts)';
label q2f='Electronic Clinical Documentation: Record smoking status using standard format ';
label q2g='Electronic Clinical Documentation: Record and maintain medication allergy lists';
label q2h='Electronic Clinical Documentation: Record patient family health history as structured data';
label q2i='Electronic Clinical Documentation: Incorporate as structured data lab results for more than 40 percent of patients admitted to inpatient or emergency departments';
 
label q2a2='Population Health Management: Generate lists of patients by condition';
label q2b2='Population Health Management: Identify and provide patient-specific education resources';

label q2a3='Medication Management: Compare a patient’s inpatient and preadmission medication lists';
label q2b3='Medication Management: Provide an updated medication list at time of discharge';
label q2c3='Medication Management: Check inpatient prescriptions against an internal formulary';
label q2d3='Medication Management: Automatically track medications with an electronic medication administration record (eMAR)';
label q2e3='Medication Management: Electronic prescribing (eRx) of discharge medication orders';

label q2a4='Discharge Instructions and Care Summary Documents: Provide patients an electronic copy of their discharge instructions upon request';
label q2b4='Discharge Instructions and Care Summary Documents: Provide patients an electronic copy of their record upon request within 3 business days';
label q2c4='Discharge Instructions and Care Summary Documents: Generate summary of care record for relevant transitions of care';
label q2d4='Discharge Instructions and Care Summary Documents: Include care teams and plan of care in care summary record';
label q2e4='Discharge Instructions and Care Summary Documents: Electronically exchange key clinical information with providers';
label q2f4='Discharge Instructions and Care Summary Documents: Send transition of care summaries to an unaffiliated organization using a different certified electronic health record vendor';

label q2a5='Automated Quality Reporting: Automatically generate hospital-specific meaningful use quality measures by extracting data from an electronic record without additional manual processes';
label q2b5='Automated Quality Reporting: Automatically generate Medicare Inpatient Quality Reporting program measures for a full Medicare inpatient update';
label q2c5='Automated Quality Reporting: Automatically generate physician-specific meaningful use quality measures calculated directly from the electronic health record (EHR) without additional manual processes';
 
label q2a6='Public Health Reporting: Submit electronic data to immunization registries/information systems per meaningful use standards';
label q2b6='Public Health Reporting: Submit electronic data on reportable lab results to public health agencies per meaningful use standards';
label q2c6='Public Health Reporting: Submit electronic syndromic surveillance data to public health agencies per meaningful use standards';

label q2a7='Other Functionalities: Implement at least 5 Clinical Decision Support interventions related to 4 or more clinical quality measures';
label q2b7='Other Functionalities: Conduct or review a security risk analysis and implement security updates as necessary';
*/
run;

%mend label;
%label(yr=08);
%label(yr=09);
%label(yr=10);
%label(yr=11);
%label(yr=12);
%label(yr=13);







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
keep provider id zip type hospsize hosp_reg4 profit2 teaching system p_medicaid IPDTOT MCRIPD;
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

 
%macro model(q=,title=);

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

array a {31} q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4 q1a5 q1b5 q1c5 q1d5 q1a6 q1b6 q1c6;
array b {31} a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4 a5 b5 c5 d5 a6 b6 c6;
do i=1 to 31;
if a{i} in (1,2) then b{i}=1;else b{i}=0;
end;


*keep id basic_adopt;
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
class eligibility ;
weight wt;
var &q.;
output out=step1_&year._unadj(keep=eligibility rate) mean=rate;
run;

 

%mend long;
%long(year=08);
%long(year=09);
%long(year=10);
%long(year=11);
%long(year=12);
%long(year=13);
 
* Display Raw Rates;
data raw;
set step1_08_unadj(in=in08) step1_09_unadj(in=in09) step1_10_unadj(in=in10) step1_11_unadj(in=in11) step1_12_unadj(in=in12) step1_13_unadj(in=in13);
where eligibility ne . ;
if in08 then  year=2008;  
if in09 then year=2009;  
if in10 then  year=2010;  
if in11 then year=2011;  
if in12 then  year=2012;  
if in13 then  year=2013;  
keep eligibility rate year;
format rate percent9.2 ;
run;
 

* Plot Overall Trend;

data graph1;
set step1_08_unadj(in=in08) step1_09_unadj(in=in09) step1_10_unadj(in=in10) step1_11_unadj(in=in11) step1_12_unadj(in=in12) step1_13_unadj(in=in13);
where eligibility ne . ;
if in08 then year=2008; 
if in09 then year=2009; 
if in10 then year=2010; 
if in11 then year=2011; 
if in12 then year=2012; 
if in13 then year=2013; 
 
keep type rate year;
run;

proc sgplot data=graph1;
title "Raw Rates: Eligible Hospitals vs In-Eligible Hospitals";
series X=year y=rate/group=eligibility datalabel=rate;
run;
 

*****************Single Functionality;

***************************
Diff-in-Diff in Slope/trend
***************************;
data allyear ;
set final08 final09 final10 final11 final12 final13;
Time=Year-2008;TimeC=Time;
Time_2011=max(Year-2011,0);
run;
proc sort data=allyear ;by id Time;run;


* Linear model;
proc genmod data=allyear  descending  ;
title "&Title.";
weight wt;
class id  eligibility(ref="0") TimeC/param=ref;
model &q.=eligibility Time Time_2011 eligibility*Time eligibility*Time_2011/dist=normal link=identity corrb ;
repeated subject=id/withinsubject=TimeC type=un;
output out=predict p=pro l=lower u=upper;

estimate "Pre(2008-2010) Eligible Hospitals" Time 1 eligibility*Time 1 0;
estimate "Post(2011-2013) Eligible Hospitals" Time 1 eligibility*Time 1 0 Time_2011 1 0 eligibility*Time_2011 1 0;
estimate "Pre(2008-2010) In-Eligible Hospitals" Time 1;
estimate "Post(2011-2013) In-Eligible Hospitals" Time 1 Time_2011 1 0 ;

estimate "Eligible Hospitals Post(2011-2013) vs Pre(2008-2010)" Time_2011 1 0 eligibility*Time_2011 1 0;
estimate "In-Eligible Hospitals Post(2011-2013) vs Pre(2008-2010)" Time_2011 1 0 ;
estimate "Eligible vs In-Eligible Hosptials in Pre(2008-2010)" eligibility*Time 1 0;
estimate "Eligible vs In-Eligible Hosptials in Post(2011-2013)" eligibility*Time 1 0 eligibility*Time_2011 1 0;
estimate "Diff-in-Diff" eligibility*Time_2011 1 0;

run;


proc sort data=predict(keep=pro year eligibility ) nodupkey;by year eligibility ;run;

data pre0 pre1 post0 post1 ;
set predict;
 
if year <2011 and eligibility=0  then do;pre0=pro;output pre0;end;
else if year <2011 and eligibility=1  then do;pre1=pro;output pre1;end;
else if year >=2011 and eligibility=0  then do;post0=pro;output post0;end;
else if year >=2011 and eligibility=1  then do;post1=pro;output post1;end;
run;

proc sort data=raw;by year;run;

data graph;
merge raw pre0(keep=year eligibility pre0) pre1(keep=year eligibility pre1) post0(keep=year eligibility post0) post1(keep=year eligibility post1);
by year eligibility  ;
format rate percent9.2 ;
format pre0 percent9.2 ;
format pre1 percent9.2 ;
format post0 percent9.2 ;
format post1 percent9.2 ;
run;


proc sgplot data=graph;
title1 "&title. %";
scatter X=year y=rate/markerattrs=(color=black symbol=STARFILLED) LEGENDLABEL ="Adoption Rate of Single Functionality" datalabel=rate;
series X=year  y=pre0 /lineattrs=(color=purple) LEGENDLABEL ='Pre-period In-eligible  '  ;
series X=year  y=pre1 /lineattrs=(color=purple)LEGENDLABEL ='Pre-period Eligible  '  ;
series X=year  y=post0  /lineattrs=(color=purple) LEGENDLABEL ='Post-period  In-Eligible '  ;
series X=year  y=post1  /lineattrs=(color=purple)LEGENDLABEL ='Post-period  Eligible '  ;

xaxis label='Year' values=(2008 to 2013 by 1);
yaxis label="&q. ";
run;

%mend model;
%model(q=a1,title=Electronic Clinical documentation: Patient demographics);
%model(q=b1,title=Electronic Clinical documentation: Physician notes);
%model(q=c1,title=Electronic Clinical documentation: Nursing notes);
%model(q=d1,title=Electronic Clinical documentation: Problem lists);
%model(q=e1,title=Electronic Clinical documentation: Medication lists);
%model(q=f1,title=Electronic Clinical documentation: Discharge summaries);
%model(q=g1,title=Electronic Clinical documentation: Advanced directives );

%model(q=a2,title=Results Viewing: Laboratory reports);
%model(q=b2,title=Results Viewing: Radiology reports);
%model(q=c2,title=Results Viewing: Radiology images);
%model(q=d2,title=Results Viewing: Diagnostic test results (e.g.EKG report, Echo report));
%model(q=e2,title=Results Viewing: Diagnostic test images (e.g.EKG tracing));
%model(q=f2,title=Results Viewing: Consultant reports);

%model(q=a3,title=Computerized Provider Order Entry: Laboratory tests);
%model(q=b3,title=Computerized Provider Order Entry: Radiology tests);
%model(q=c3,title=Computerized Provider Order Entry: Medications);
%model(q=d3,title=Computerized Provider Order Entry: Consultation requests);
%model(q=e3,title=Computerized Provider Order Entry: Nursing orders);

%model(q=a4,title=Decision Support: Clinical guidelines (e.g. Beta blockers post-MI, ASA in CAD));
%model(q=b4,title=Decision Support: Clinical reminders (e.g.pneumovax));
%model(q=c4,title=Decision Support: Drug allergy alerts);
%model(q=d4,title=Decision Support: Drug-drug interaction alerts);
%model(q=e4,title=Decision Support: Drug-lab interaction alerts);
%model(q=f4,title=Decision Support: Drug dosing support (e.g. renal dose guidance));

%model(q=a5,title=Bar Coding or Radio Frequency Identification (RFID) for Closed-loop Medication Tracking: Medication administration);
%model(q=b5,title=Bar Coding or Radio Frequency Identification (RFID) for Closed-loop Medication Tracking: Patient verification);
%model(q=c5,title=Bar Coding or Radio Frequency Identification (RFID) for Closed-loop Medication Tracking: Caregiver verification);
%model(q=d5,title=Bar Coding or Radio Frequency Identification (RFID) for Closed-loop Medication Tracking: Pharmacy verification);

%model(q=a6,title=Other Functionalities: Bar coding or Radio Frequency (RFID) for supply chain management);
%model(q=b6,title=Other Functionalities: Telehealth);
%model(q=c6,title=Other Functionalities: Ability to connect mobile devices to EHR);
  
