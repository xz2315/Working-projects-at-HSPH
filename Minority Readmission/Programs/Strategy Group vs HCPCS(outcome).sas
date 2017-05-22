********************************
High Strategy/Mid/Low vs Patient Experice
Xiner Zhou
7/29/2015
*******************************;

libname data 'C:\data\Projects\Minority_Readmissions\Data';
libname HCAHPS 'C:\data\Data\Hospital\Hospital Compare\data'; 
/*
10 Strategies Used:
How often is each strategy used in your hospital for the specified patient population? 
	y7A Use a dedicated discharge planner or discharge coordinator
	=Use Discharge Planner or Coordinator
    y7B Create a discharge summary prior to discharge and share this with the patient's outpatient provider
	=Create Discharge Summary Prior to D/C 
    y7E Schedule follow-up appointments for all patients prior to discharge
	=Schedule F/u appts prior to D/C
    y7F Use pharmacists to reconcile discharge medications with prior outpatient medications
	=Use Pharmacists to Reconcile Meds
    y7G Use electronic tools to reconcile discharge medications with prior outpatient medications
	=Use eTools to Reconcile Meds
    y7H Use a formal discharge checklist to document when all components of discharge protocol are complete
	=Use Formal D/C checklist
    y7I Contact patients by phone within 48 hours after discharge to monitor their progress
	=Call Patients 48hrs post-D/C
    y7J Use a transition coach to help patients manage medications and other self-care issues
	=Use Transition Coaches
    y7M Use mobile or web-based applications to support patients and families in carrying out post-discharge care plans
	=Use mobile/web-based tools 

y10 Does your hospital participate in any formal programs to reduce 30-day readmissions such as STAAR (STate Action on Avoidable Re-hospitalizations), Project BOOST (Better Outcomes for Older adults through Safer Transitions), CMS CCTP (Community-based Care Transitions Program), Project Re-Engineered Discharge (RED), The Care Transitions Program, etc.? 
	=Participate in Formal D/C Programs



Quartiles of Hospitals using the strategies:  0-10

Top 25%: High Strategy / Mid (Q2-Q3) / Low Strategy

D/C satisfaction
=H_COMP_7_SA
label 'Patients who "Strongly Agree" they understood their care when they left the hospital'

Communications about meds
=H_COMP_5_A_P
label 'Patients who reported that staff "Always" explained about medicines before giving it to them'

Recommend Hospital
=H_RECMND_DY 
label 'Patients who reported YES, they would definitely recommend the hospital'

Overall Rating 9/10
=H_HSP_RATING_9_10 
label 'Patients who gave their hospital a rating of 9 or 10 on a scale from 0 (lowest) to 10 (highest)'

Models to run:
Unadjusted
Adjusted by hospital
Adjusted by hospital + % black + SNH

Table 1:
3 groups: hospital char/ pt char / Medicaid/medicare %, etc.  
*/

proc sql;
create table data as
select a.*,
b.H_COMP_7_SA, b.H_COMP_5_A_P, b.H_RECMND_DY, b.H_HSP_RATING_9_10 
from data.survey_analytic a left join HCAHPS.HCAHPS2014 b
on a.Medicare_id=b.provider_id;
quit;

data data;
set data;
num_str=y7A+y7B+y7E+y7F+y7G+y7H+y7I+y7J+y7M+y10;
y1=H_COMP_7_SA*1;
y2=H_COMP_5_A_P*1;
y3=H_RECMND_DY*1;
y4=H_HSP_RATING_9_10*1;
proc means Q1 median mean Q3 min max;var num_str;
run;

proc rank data=data out=data1 group=4;
var num_str;
ranks strRank;
run;

data data2;
set data1;
if strRank=0 then group=1;
else if strrank in (1,2) then group=2;
else if strRank=3 then group=3;
run;

proc means data=data2 min mean max;
class group;
var num_str;
run;

*Raw stat;
proc means data=data2;
class group;
var y4;
run;

proc sort data=data2;by descending group;run;
proc genmod data=data2 order=data ;
	weight wt;
	class group;
	model y4=group / dist = normal   ;  		
	 ods output ParameterEstimates=Estimate1;
run;
proc genmod data=data2 order=data ;
	weight wt;
	class group teaching profit2 hospsize hosp_reg4 ruca_level CICU SNH;
	model y4=group teaching profit2 hospsize hosp_reg4 ruca_level CICU / dist = normal   ;  		
	 ods output ParameterEstimates=Estimate2;
run;
proc genmod data=data2 order=data ;
	weight wt;
	class group teaching profit2 hospsize hosp_reg4 ruca_level CICU SNH;
	model y4=group teaching profit2 hospsize hosp_reg4 ruca_level CICU  SNH propblk / dist = normal   ;  		
	 ods output ParameterEstimates=Estimate3;
run;

data all;
length model $30.;
set Estimate1(in=in1) Estimate2(in=in2) Estimate3(in=in3);
where parameter='group';
keep parameter model level1 estimate StdErr ProbChiSq;
if in1=1 then Model='Unadjusted';
if in2=1 then Model='Adjusted by hospital';
if in3=1 then Model='Adjusted by hospital + % black + SNH';
proc print;
run;
 



title "Table1: HCAPHS";

proc format;
value teaching_
1='Major teaching'
2='Minor teaching'
3='Non-Teaching'
;
run;
proc format;
value profit2_
1='Investor Owned, For-Profit'
2='Non-Government, Not-For-Profit'
3='Government, Non-Federal'
4='Government, Federal'
;
run;
proc format ;
value hospsize_
1='Small [1-99 beds]'
2='Medium [100-399 beds]'
3='Large [400+ beds]'
;
run;
proc format;
value hosp_reg4_
1='North East'
2='Midwest'
3='South'
4='West'
;
run;
*Rural-Urban Commuting Area (RUCA) ;
proc format;
value ruca_level_
1='Urban'
2='Suburban'
3='Large Rural Town'
4='Small Town/Isolated Rural'
;
run;
proc format ;
value $CICU_
1='Hospital has CICU'
0='Hospital has NO CICU'
;
run;
proc format ;
value SNH_
1='Safety Net Hospital'
0='Not'
;
run;
proc freq data=data2;
format teaching teaching_.;format profit2 profit2_.;format hospsize hospsize_.;format hosp_reg4 hosp_reg4_.;format ruca_level ruca_level_.;
format CICU $CICU_.;format SNH SNH_.; 
table teaching*group profit2*group hospsize*group hosp_reg4*group ruca_level*group cicu*group/ nocum norow nopercent  chisq ;
run;
 
%macro anova(var=);
proc means data=data2 mean std median min max;
class group;
var &var. ;
run;
proc anova data=data2;
class group;
model &var.=group;
run;
%mend anova;
%anova(var=propblk);
%anova(var=prophisp);
%anova(var=p_medicare);
%anova(var=p_medicaid);
%anova(var=dshpct);
 %anova(var=total_margin);
%anova(var=readm);
