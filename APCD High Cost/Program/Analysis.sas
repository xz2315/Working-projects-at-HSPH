********************************
Demographic & Spending & Utilization
Xiner Zhou
9/1/2015
*********************************;
libname APCD 'C:\data\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';


%let byyear=2012;
%let bymoney=spending;
%let pct=10;

%let byyear=2012;
%let bymoney=cost;
%let pct=10;
*All, exclude MA and >65;
*By Payer;


*Create total cost and utilization for patients having multiple insurances;
proc sort data=APCD.dataV21;by MemberLinkEID Year;run;
proc sql;
create table temp as 
select *,
sum(IPstay1) as total_IPstay1,sum(IPstay2) as total_IPstay2,sum(IPstay3) as total_IPstay3,sum(IPstay4) as total_IPstay4,sum(IPstay5) as total_IPstay5,sum(IPstay6) as total_IPstay6,
sum(ipLOS1) as total_ipLOS1,sum(ipLOS2) as total_ipLOS2,sum(ipLOS3) as total_ipLOS3,sum(ipLOS4) as total_ipLOS4,sum(ipLOS5) as total_ipLOS5,sum(ipLOS6) as total_ipLOS6,
sum(ipcost1) as total_ipcost1,sum(ipcost2) as total_ipcost2, sum(ipcost3) as total_ipcost3, sum(ipcost4) as total_ipcost4, sum(ipcost5) as total_ipcost5, sum(ipcost6) as total_ipcost6, 
sum(ipspending1) as total_ipspending1,sum(ipspending2) as total_ipspending2,sum(ipspending3) as total_ipspending3,sum(ipspending4) as total_ipspending4,sum(ipspending5) as total_ipspending5,sum(ipspending6) as total_ipspending6,

sum(opvisit) as total_opvisit, sum(opcost) as total_opcost, sum(opspending) as total_opspending, 

sum(PhysicianEvent1) as total_PhysicianEvent1,sum(PhysicianEvent2) as total_PhysicianEvent2,sum(PhysicianEvent3) as total_PhysicianEvent3,sum(PhysicianEvent4) as total_PhysicianEvent4,
sum(PhysicianEvent5) as total_PhysicianEvent5,sum(PhysicianEvent6) as total_PhysicianEvent6,sum(PhysicianEvent7) as total_PhysicianEvent7,sum(PhysicianEvent8) as total_PhysicianEvent8,
sum(PhysicianEvent9) as total_PhysicianEvent9,sum(PhysicianEvent10) as total_PhysicianEvent10,sum(PhysicianEvent11) as total_PhysicianEvent11,sum(PhysicianEvent12) as total_PhysicianEvent12,
sum(PhysicianEvent13) as total_PhysicianEvent13,sum(PhysicianEvent14) as total_PhysicianEvent14, 

sum(PhysicianCost1) as total_PhysicianCost1,sum(PhysicianCost2) as total_PhysicianCost2,sum(PhysicianCost3) as total_PhysicianCost3,sum(PhysicianCost4) as total_PhysicianCost4,
sum(PhysicianCost5) as total_PhysicianCost5,sum(PhysicianCost6) as total_PhysicianCost6,sum(PhysicianCost7) as total_PhysicianCost7,sum(PhysicianCost8) as total_PhysicianCost8,
sum(PhysicianCost9) as total_PhysicianCost9,sum(PhysicianCost10) as total_PhysicianCost10,sum(PhysicianCost11) as total_PhysicianCost11,sum(PhysicianCost12) as total_PhysicianCost12,
sum(PhysicianCost13) as total_PhysicianCost13,sum(PhysicianCost14) as total_PhysicianCost14,
 
sum(PhysicianSpending1) as total_PhysicianSpending1,sum(PhysicianSpending2) as total_PhysicianSpending2,sum(PhysicianSpending3) as total_PhysicianSpending3,sum(PhysicianSpending4) as total_PhysicianSpending4,
sum(PhysicianSpending5) as total_PhysicianSpending5,sum(PhysicianSpending6) as total_PhysicianSpending6,sum(PhysicianSpending7) as total_PhysicianSpending7,sum(PhysicianSpending8) as total_PhysicianSpending8,
sum(PhysicianSpending9) as total_PhysicianSpending9,sum(PhysicianSpending10) as total_PhysicianSpending10,sum(PhysicianSpending11) as total_PhysicianSpending11,sum(PhysicianSpending12) as total_PhysicianSpending12,
sum(PhysicianSpending13) as total_PhysicianSpending13,sum(PhysicianSpending14) as total_PhysicianSpending14,
 
sum(PhysicianEvent) as total_PhysicianEvent, sum(PhysicianCost) as total_PhysicianCost, sum(PhysicianSpending) as total_PhysicianSpending,

sum(HHAEvent) as total_HHAEvent, sum(HHALOS) as total_HHALOS,sum(HHAcost) as total_HHAcost, sum(HHAspending) as total_HHAspending,

sum(HospiceEvent) as total_HospiceEvent, sum(HospiceLOS) as total_HospiceLOS,sum(Hospicecost) as total_Hospicecost, sum(Hospicespending) as total_Hospicespending,

sum(SNFEvent) as total_SNFEvent, sum(SNFLOS) as total_SNFLOS,sum(SNFcost) as total_SNFcost, sum(SNFspending) as total_SNFspending,

sum(total_cost) as total_total_cost, sum(total_spending) as total_total_spending,

total_cost/(calculated total_total_cost) as CostRatio,
total_spending/(calculated total_total_spending) as spendingRatio

from APCD.dataV21
where Year=2012 
 
and Switcher not in ("Medicaid, Medicare Advantage","Medicaid Managed Care, Medicare Advantage","Medicare Advantage, Private",
"Medicaid, Medicaid Managed Care, Medicare Advantage","Medicaid, Medicare Advantage, Private","Medicaid Managed Care, Medicare Advantage, Private",
"Medicaid, Medicaid Managed Care, Medicare Advantage, Private","Only Medicare Advantage")
 
/*
and Switcher in ("Only Medicaid","Only Medicaid Managed Care","Only Private")
 */
and Age <65
group by MemberLinkEID;
quit;

proc sort data=temp;by MemberLinkEID descending &bymoney.ratio;run;
data temp;
length type $30.;
set temp;
by MemberLinkEID descending &bymoney.ratio;
if first.MemberLinkEID=1 then Concentration=1;else Concentration=0;

if Payer='3156' and (Plan1='MC' or Plan2='MC' or Plan3='MC' or Plan4='MC') then type="Medicaid"; 
else if Payer ne '3156' and (Plan1 in ('MC','MO') or Plan2 in ('MC','MO') or Plan3 in ('MC','MO')  or Plan4 in ('MC','MO') )  then  type ="Medicaid Managed Care";
else  type="Private"; 
proc freq ;tables type/missing;
proc means ;
class Concentration;
var &bymoney.ratio;
run;

 
  

data temp1;
length AgeGroup $30. CountyState $30.;
set temp ;

*Only concentration;
if Concentration=1;

*age group;
if age<18 then AgeGroup="Age<18";
else if 18<=Age<25 then AgeGroup="18<=Age<25";
else if 25<=Age<35 then AgeGroup="25<=Age<35";
else if 35<=Age<45 then AgeGroup="35<=Age<45";
else if 45<=Age<55 then AgeGroup="45<=Age<55";
else if 55<=Age<65 then AgeGroup="55<=Age<65";
else if 65<=Age<75 then AgeGroup="65<=Age<75";
else if 75<=Age<85 then AgeGroup="75<=Age<85";
else AgeGroup="Age>=85";

/*Pediatric;
if 0<=age<=1 then AgeGroup="Infancy: <=1";
else if 1<Age<=2  then AgeGroup="Toddler:1-2";
else if 2<Age<=5 then AgeGroup="Early childhood:2-5";
else if 5<Age<=11 then AgeGroup="Middle childhood:6-11";
else if 11<Age<=18 then AgeGroup="Early adolescence:12-18";
*/
if gender in ('F','M');

if StateName='MA';
CountyState= trim(CountyName)||','||StateName;

* IP sum;
total_IPStay=total_IPStay1+total_IPStay2+total_IPStay3+total_IPStay4+total_IPStay5+total_IPStay6;
total_IPLOS=total_IPLOS1+total_IPLOS2+total_IPLOS3+total_IPLOS4+total_IPLOS5+total_IPLOS6;
total_IPCost=total_IPCost1+total_IPCost2+total_IPCost3+total_IPCost4+total_IPCost5+total_IPCost6;
total_IPSpending=total_IPSpending1+total_IPSpending2+total_IPSpending3+total_IPSpending4+total_IPSpending5+total_IPSpending6;
run;

*Identity 10% High Cost in a year;
*reverses the order of the ranks so that the highest value receives the rank of 1;
* ties assigns the best possible rank to tied values;
proc rank data=temp1 out=temp2 percent descending ;
var total_total_&bymoney.;
ranks rank_total_&bymoney.;
run;

proc sort data=temp2;by rank_total_&bymoney.;run;

data HighCost&pct.&bymoney.&byyear.;
set temp2;
if rank_total_&bymoney.<=&pct. then highCost=1;
else  highCost=0;


*Individual Payer;
if type="Private";
*if type="Medicaid";
*if type="Medicaid Managed Care";


proc means ;class highcost;var total_total_&bymoney.;
run;
 

***********************************Make Demographic table 1;
proc freq data=HighCost&pct.&bymoney.&byyear.;
tables highCost/out=N0 outpct;
run;
proc transpose data=N0 out=N1;
var count ;
id highCost;
run;

data N1;
length var $30.;
set N1;keep var _0 _1;
var="Number of Beneficiaries during &byyear.";
proc print;
run;

%macro freqtable(var=,num=);
proc freq data=HighCost&pct.&bymoney.&byyear.;
tables &var.*highCost/out=&var.0 outpct;
run;
proc transpose data=&var.0 out=&var.1;
by &var.;
var count pct_col pct_row;
id highCost;
run;
%if &num. =1 %then %do;
data &var.1;set &var.1;where &var. ne .;run;
%end;

%else %do;
data &var.1;set &var.1;where &var. ne '';run;
%end;

data &var.1;
length var $30.;
set &var.1;
keep var &var. _0 _1 _label_;
var="&var.";
rename &var.=group;
proc print;
run;

%mend freqtable;
%freqtable(var=AgeGroup,num=0);
%freqtable(var=gender,num=0);
%freqtable(var=type,num=0);
%freqtable(var=OrgID,num=0);
data OrgID1;
set OrgID1;
format group orgid_.;
proc print;
run;
%freqtable(var=CountyState,num=0);
%freqtable(var=mental,num=1);
%freqtable(var=Alcohol_Drug,num=1);









proc means data=HighCost&pct.&bymoney.&byyear. noprint;
class HighCost;
var MajorCC;
output out=MajorCC min=min max=max mean=mean median=median;
run;
proc transpose data=MajorCC out=MajorCC1;
var min max mean median;
id highCost;
run;
proc print data=MajorCC1;run;


proc means data=HighCost&pct.&bymoney.&byyear. noprint;
class HighCost;
var MinorCC;
output out=MinorCC min=min max=max mean=mean median=median;
run;
proc transpose data=MinorCC out=MinorCC1;
var min max mean median;
id highCost;
run;
proc print data=MinorCC1;run;

proc means data=HighCost&pct.&bymoney.&byyear. noprint;
class HighCost;
var Frailty_num;
output out=Frailty_num min=min max=max mean=mean median=median;
run;
proc transpose data=Frailty_num out=Frailty_num1;
var min max mean median;
id highCost;
run;
proc print data=Frailty_num1;run;

*CCW prevelance table;
%macro CCW(cond=,title=,i=);
proc freq data=HighCost&pct.&bymoney.&byyear.;where HighCost=1;
tables &cond./out=HCYes&i.;
run;
data HCYes&i.;length CCW $50.;set HCYes&i.;keep CCW percent;CCW=&title.;where &cond.=1;run;

proc freq data=HighCost&pct.&bymoney.&byyear.;where HighCost=0;
tables &cond./out=HCNo&i.;
run;
data HCNo&i.;length CCW $50.;set HCNo&i.;keep CCW percent;CCW=&title.;where &cond.=1;run;
%mend CCW;
%CCW(cond=CCW_Anemia,title="Anemia",i=1);
%CCW(cond=CCW_Asthma ,title="Asthma",i=2 );
%CCW(cond=CCW_Atrial_fibrillation ,title="Atrial fibrillation",i=3 );
%CCW(cond=CCW_COPD ,title="Chronic obstructive pulmonary disease and bronchiectasis",i=4 );
%CCW(cond=CCW_Cataract ,title="Cataract",i=5 );
%CCW(cond=CCW_Chronic_kidney_disease ,title="Chronic kidney disease",i=6 );
%CCW(cond=CCW_Colorectal_cancer ,title="Colorectal cancer",i=7 );
%CCW(cond=CCW_Depression ,title="Depression",i=8 );
%CCW(cond=CCW_Diabetes ,title="Diabetes",i=9 );
%CCW(cond=CCW_Endometrial_cancer ,title="Endometrial cancer",i=10 );
%CCW(cond=CCW_Female_male_breast_cancer ,title="Female/male breast cancer",i=11 );
%CCW(cond=CCW_Glaucoma ,title="Glaucoma",i=12 );
%CCW(cond=CCW_Heart_failure ,title="Heart failure",i=13 );
%CCW(cond=CCW_Hip_pelvic_fracture ,title="Hip/pelvic fracture",i=14 );
%CCW(cond=CCW_Hypertension ,title="Hypertension",i=15 );
%CCW(cond=CCW_Ischemic_heart_disease ,title="Ischemic heart disease",i=16 );
%CCW(cond=CCW_Lung_cancer ,title="Lung cancer",i=17 );
%CCW(cond=CCW_Osteoporosis ,title="Osteoporosis",i=18 );
%CCW(cond=CCW_Prostate_cancer ,title="Prostate cancer",i=19 );
%CCW(cond=CCW_Rheumatoid ,title="Rheumatoid arthritis/osteoarthritis",i=20 );
%CCW(cond=CCW_Stroke  ,title="Stroke/transient ischemic attack",i=21 );
%CCW(cond=CCW_acquired_hypothyroidism ,title="acquired hypothyroidism",i=22 );
%CCW(cond=CCW_acute_myocardial_infarction ,title="acute myocardial infarction",i=23 );
%CCW(cond=CCW_alzheimers ,title="alzheimers disease",i=24 );
%CCW(cond=CCW_alzheimers_disease ,title="alzheimers disease and Rltd Disorders or Senile Dementia",i=25 );
%CCW(cond=CCW_benign_prostatic_hyperplasia ,title="benign prostatic hyperplasia",i=26 );
%CCW(cond=CCW_hyperlipidemia ,title="hyperlipidemia",i=27 );

data HCYes;set HCyes1 HCyes2 HCyes3 HCyes4 HCyes5 HCyes6 HCyes7 HCyes8 HCyes9 HCyes10 HCyes11 HCyes12 HCyes13 HCyes14 HCyes15 HCyes16 HCyes17 HCyes18 HCyes19 HCyes20 HCyes21 HCyes22 HCyes23 HCyes24 HCyes25 HCyes26 HCyes27;proc sort ;by descending percent;proc print;run;

data HCNO;set HCNO1 HCNO2 HCNO3 HCNO4 HCNO5 HCNO6 HCNO7 HCNO8 HCNO9 HCNO10 HCNO11 HCNO12 HCNO13 HCNO14 HCNO15 HCNO16 HCNO17 HCNO18 HCNO19 HCNO20 HCNO21 HCNO22 HCNO23 HCNO24 HCNO25 HCNO26 HCNO27;proc sort ;by descending percent;proc print;run;

*Rob's ;
%CCW(cond=amiihd,title='Acute MI / Ischemic Heart Disease',i=1);
%CCW(cond=amputat ,title='Amputation Status',i=2 );
%CCW(cond=arthrit,title='Arthritis and Other Inflammatory Tissue Disease',i=3 );
%CCW(cond=artopen ,title='Artificial Openings',i=4 );
%CCW(cond=bph,title='Benign Prostatic Hyperplasia',i=5 );
%CCW(cond=cancer ,title='Cancer',i=6 );
%CCW(cond=chrkid,title='Chronic Kidney Disease',i=7 );
%CCW(cond=chf,title='Congestive Heart Failure',i=8 );
%CCW(cond=cystfib,title='Cystic Fibrosis',i=9 );
%CCW(cond=dementia,title='Dementia',i=10 );
%CCW(cond=diabetes,title='Diabetes',i=11 );
%CCW(cond=endo,title='Endocrine And Metabolic Disorders',i=12 );
%CCW(cond=eyedis,title='Eye Disease',i=13 );
%CCW(cond=hemadis,title='Hematological Disease',i=14 );
%CCW(cond=hyperlip,title='Hyperlipidemia',i=15 );
%CCW(cond=hyperten ,title='Hypertension',i=16 );
%CCW(cond=immunedis,title='Immune Disorders',i=17 );
%CCW(cond=ibd,title='Inflammatory Bowel Disease',i=18 );
%CCW(cond=liver,title='Liver & Biliary Disease',i=19 );
%CCW(cond=lung,title='Lung Disease',i=20 );
%CCW(cond=neuromusc ,title='Neuromuscular Disease',i=21 );
%CCW(cond=osteo,title='Osteporosis',i=22 );
%CCW(cond=paralyt,title='Paralytic Diseases / Conditions',i=23 );
%CCW(cond=psydis,title='Psychiatric Disease',i=24 );
%CCW(cond=sknulc,title='Skin Ulcer',i=25 );
%CCW(cond=spchrtarr,title='Specified Heart Arrhythmias',i=26 );
%CCW(cond=strk,title='Stroke',i=27 );
 
%CCW(cond=sa ,title='Substance Abuse' ,i=28  );
%CCW(cond=thyroid ,title='Thyroid Disease' ,i=29  );
%CCW(cond=vascdis ,title='Vascular Disease' ,i=30  );
 
  
data HCYes;set HCyes1 HCyes2 HCyes3 HCyes4 HCyes5 HCyes6 HCyes7 HCyes8 HCyes9 HCyes10 HCyes11 HCyes12 HCyes13 HCyes14 HCyes15 HCyes16 HCyes17 HCyes18 HCyes19 HCyes20 HCyes21 HCyes22 HCyes23 HCyes24 HCyes25 HCyes26 HCyes27 HCyes28 HCyes29 HCyes30;proc sort ;by descending percent;proc print;run;

data HCNO;set HCNO1 HCNO2 HCNO3 HCNO4 HCNO5 HCNO6 HCNO7 HCNO8 HCNO9 HCNO10 HCNO11 HCNO12 HCNO13 HCNO14 HCNO15 HCNO16 HCNO17 HCNO18 HCNO19 HCNO20 HCNO21 HCNO22 HCNO23 HCNO24 HCNO25 HCNO26 HCNO27 HCNO28 HCNO29 HCNO30;proc sort ;by descending percent;proc print;run;

 
  


*Correspondence;
proc sql;
create table corr as
select a.MemberLinkEID, a.HighCost as HighcostCost,b.highcost as HighCostSpending
from HighCost10Cost2012 a full join HighCost10Spending2012 b
on a.Memberlinkeid=b.memberlinkeid;
quit;
proc freq data=corr;tables highcostcost*highcostspending;run;


************************Spending ;
%macro utilize(var=);
proc means data=HighCost&pct.&bymoney.&byyear. noprint;
class HighCost;
var &var.;
output out=&var.0 min=min max=max mean=mean median=median sum=sum;
run;
proc transpose data=&var.0 out=&var.1;
where highcost ne .;
id highcost;
var min max mean median sum;
run;

data &var.1;
length var $30.;
set &var.1;
var="&var.";
run;
%mend ;
%utilize(var=total_total_&bymoney.);
%utilize(var=total_ip&bymoney.);
%utilize(var=total_ip&bymoney.1);
%utilize(var=total_ip&bymoney.2);
%utilize(var=total_ip&bymoney.3);
%utilize(var=total_ip&bymoney.4);
%utilize(var=total_ip&bymoney.5);
%utilize(var=total_ip&bymoney.6);
%utilize(var=total_op&bymoney.);
%utilize(var=total_Physician&bymoney.);
%utilize(var=total_Physician&bymoney.1);
%utilize(var=total_Physician&bymoney.2);
%utilize(var=total_Physician&bymoney.3);
%utilize(var=total_Physician&bymoney.4);
%utilize(var=total_Physician&bymoney.5);
%utilize(var=total_Physician&bymoney.6);
%utilize(var=total_Physician&bymoney.7);
%utilize(var=total_Physician&bymoney.8);
%utilize(var=total_Physician&bymoney.9);
%utilize(var=total_Physician&bymoney.10);
%utilize(var=total_Physician&bymoney.11);
%utilize(var=total_Physician&bymoney.12);
%utilize(var=total_Physician&bymoney.13);
%utilize(var=total_Physician&bymoney.14);
%utilize(var=total_HHA&bymoney.);
%utilize(var=total_Hospice&bymoney.);
%utilize(var=total_SNF&bymoney.);

data spending;
set total_total_&bymoney.1 total_ip&bymoney.1 total_ip&bymoney.11 total_ip&bymoney.21 total_ip&bymoney.31 total_ip&bymoney.41 total_ip&bymoney.51
total_ip&bymoney.61 total_op&bymoney.1 total_Physician&bymoney.1 total_Physician&bymoney.11 total_Physician&bymoney.21 total_Physician&bymoney.31
total_Physician&bymoney.41 total_Physician&bymoney.51 total_Physician&bymoney.61 total_Physician&bymoney.71 total_Physician&bymoney.81
total_Physician&bymoney.91 total_Physician&bymoney.101
total_Physician&bymoney.111 total_Physician&bymoney.121 total_Physician&bymoney.131 total_Physician&bymoney.141
total_HHA&bymoney.1 total_Hospice&bymoney.1 total_SNF&bymoney.1;
if _Name_='sum' then do;all=_0+_1;ratio=_1/(_0+_1);end;
label ratio='Percentage of Total Cost due to High Cost Patients';
proc print;
run;
 
*summary;
data _null_;
set spending;
if _Name_='sum' and var="total_total_&bymoney." then call symput('tot',all);
run;
data summary;
length note $15.;
set spending;
if _Name_='sum';
sub_ratio=all/&tot.;
if var in ("total_total_&bymoney.","total_ip&bymoney.","total_op&bymoney.","total_Physician&bymoney.","total_SNF&bymoney.","total_Hospice&bymoney.","total_HHA&bymoney.");
if var="total_ip&bymoney." then note="IP";
if var="total_op&bymoney." then note="OP";
if var="total_Physician&bymoney." then note="Physician";
if var="total_SNF&bymoney." then note="SNF";
if var="total_Hospice&bymoney." then note="Hospice";
if var="total_HHA&bymoney." then note="HHA";
proc sort;by descending sub_ratio;
proc print;var note all sub_ratio ratio;run;

 
************************Utilization;
%macro utilize(var=);
proc means data=HighCost&pct.&bymoney.&byyear. noprint;
class HighCost;
var &var.;
output out=&var.0 min=min max=max mean=mean median=median sum=sum;
run;
proc transpose data=&var.0 out=&var.1;
where highcost ne .;
id highcost;
var min max mean median sum;
run;

data &var.1;
length var $30.;
set &var.1;
var="&var.";
run;
%mend ;
%utilize(var=total_ipStay);
%utilize(var=total_ipStay1);
%utilize(var=total_ipStay2);
%utilize(var=total_ipStay3);
%utilize(var=total_ipStay4);
%utilize(var=total_ipStay5);
%utilize(var=total_ipStay6);
%utilize(var=total_ipLOS);
%utilize(var=total_ipLOS1);
%utilize(var=total_ipLOS2);
%utilize(var=total_ipLOS3);
%utilize(var=total_ipLOS4);
%utilize(var=total_ipLOS5);
%utilize(var=total_ipLOS6);
%utilize(var=total_opvisit);
%utilize(var=total_PhysicianEvent);
%utilize(var=total_PhysicianEvent1);
%utilize(var=total_PhysicianEvent2);
%utilize(var=total_PhysicianEvent3);
%utilize(var=total_PhysicianEvent4);
%utilize(var=total_PhysicianEvent5);
%utilize(var=total_PhysicianEvent6);
%utilize(var=total_PhysicianEvent7);
%utilize(var=total_PhysicianEvent8);
%utilize(var=total_PhysicianEvent9);
%utilize(var=total_PhysicianEvent10);
%utilize(var=total_PhysicianEvent11);
%utilize(var=total_PhysicianEvent12);
%utilize(var=total_PhysicianEvent13);
%utilize(var=total_PhysicianEvent14);
%utilize(var=total_HHAEvent);
%utilize(var=total_HHALOS);
%utilize(var=total_HospiceEvent);
%utilize(var=total_HospiceLOS);
%utilize(var=total_SNFEvent);
%utilize(var=total_SNFLOS);

data spending;
set total_ipStay1 total_ipStay11 total_ipStay21 total_ipStay31 total_ipStay41 total_ipStay51 total_ipStay61
total_ipLOS1 total_ipLOS11 total_ipLOS21 total_ipLOS31 total_ipLOS41 total_ipLOS51 total_ipLOS61 
total_opvisit1
total_PhysicianEvent1 total_PhysicianEvent11 total_PhysicianEvent21 total_PhysicianEvent31 total_PhysicianEvent41 total_PhysicianEvent51 
total_PhysicianEvent61 total_PhysicianEvent71 total_PhysicianEvent81 total_PhysicianEvent91 total_PhysicianEvent101 total_PhysicianEvent111
total_PhysicianEvent121 total_PhysicianEvent131 total_PhysicianEvent141
total_HHAEvent1 total_HHALOS1 total_SNFEvent1 total_SNFLOS1;
proc print;
run;
 

