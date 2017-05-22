****************************
Preventive Spending by PQIs + 30day Spending After PQI admission in 2008 2009 2010 
Xiner Zhou
7/8/2016
****************************;
libname PQI 'C:\data\Projects\Scorecard\data';
libname MedPar 'C:\data\Data\Medicare\MedPAR';
libname mmleads 'C:\data\Data\MMLEADS\Data';

****************************
Preventive Spending by PQIs 2008 2009 2010
*****************************;

%macro ByCond(yr=);
* Link PQI back to claims, and take actual spending;
proc sql;
create table temp1 as 
select c.*,d.ADMSNDT, d.DSCHRGDT, d.PMT_AMT 
from
(select a.bene_id, 
a.TAPQ01, a.TAPQ02, a.TAPQ03, a.TAPQ05, a.TAPQ07, a.TAPQ08, a.TAPQ10, a.TAPQ11, a.TAPQ12, a.TAPQ13, a.TAPQ14, a.TAPQ15, a.TAPQ16, 
a.TAPQ90,a.TAPQ91, a.TAPQ92,
b.MEDPARID
from PQI.Pqi_medpar&yr.v45 a left join PQI.Prepare_for_pqi_medpar&yr. b
on a.key=b.key) c 
left join 
MedPar.Medparsl&yr. d
on c.MEDPARID=d.MEDPARID;
quit;


* Summarize at bene level, total N PQI & spending, and separetely for each condition;
data temp1;
set temp1;
array try {16}  TAPQ01 TAPQ02 TAPQ03 TAPQ05 TAPQ07 TAPQ08 TAPQ10 TAPQ11 TAPQ12 TAPQ13 TAPQ14 TAPQ15 TAPQ16  
TAPQ90 TAPQ91 TAPQ92  ;
do i=1 to 16;
if try{i}=. then try{i}=0;
end;
drop i;
run;
 


%macro PQI(var,label1,label2);
data temp2;set temp1;where &var.=1;proc sort;by bene_id;run;
proc sql;
create table &var. as
select bene_id, count(*) as N_&var. , sum(PMT_AMT ) as &var.spending 
from temp2
group by bene_id;
quit;

data &var.;
set &var.;
label N_&var.=&label1.;
label &var.stdcost=&label2.;
proc sort nodupkey;by bene_id;
run;
%mend PQI;
%PQI(var=TAPQ01,label1="N. of Diabetes Short-Term Complications Admission",label2="Spending of Diabetes Short-Term Complications Admission");
%PQI(var=TAPQ02,label1="N. of Perforated Appendix Admission",label2="Spending of Perforated Appendix Admission");
%PQI(var=TAPQ03,label1="N. of Diabetes Long-Term Complications Admission",label2="Spending of Diabetes Long-Term Complications Admission");
%PQI(var=TAPQ05,label1="N. of Chronic Obstructive Pulmonary Disease (COPD) or Asthma in Older Adults Admission",label2="Spending of Chronic Obstructive Pulmonary Disease (COPD) or Asthma in Older Adults Admission");
%PQI(var=TAPQ07,label1="N. of Hypertension Admission",label2="Spending of Hypertension Admission");
%PQI(var=TAPQ08,label1="N. of Heart Failure Admission",label2="Spending of Heart Failure Admission");
%PQI(var=TAPQ10,label1="N. of Dehydration Admission",label2="Spending of Dehydration Admission");
%PQI(var=TAPQ11,label1="N. of Bacterial Pneumonia Admission",label2="Spending of Bacterial Pneumonia Admission");
%PQI(var=TAPQ12,label1="N. of Urinary Tract Infection Admission",label2="Spending of Urinary Tract Infection Admission");
%PQI(var=TAPQ13,label1="N. of Angina Without Procedure Admission",label2="Spending of Angina Without Procedure Admission");
%PQI(var=TAPQ14,label1="N. of Uncontrolled Diabetes Admission",label2="Spending of Uncontrolled Diabetes Admission");
%PQI(var=TAPQ15,label1="N. of Asthma in Younger Adults Admission",label2="Spending of Asthma in Younger Adults Admission");
%PQI(var=TAPQ16,label1="N. of Lower-Extremity Amputation among Patients with Diabetes",label2="Spending of Lower-Extremity Amputation among Patients with Diabetes");
%PQI(var=TAPQ90,label1="N. of Prevention Quality Overall",label2="Spending of Prevention Quality Overall");
%PQI(var=TAPQ91,label1="N. of Prevention Quality Acute",label2="Spending of Prevention Quality Acute");
%PQI(var=TAPQ92,label1="N. of Prevention Quality Chronic",label2="Spending of Prevention Quality Chronic");
  
data benePQI&yr.;
merge TAPQ90(in=in1) TAPQ91 TAPQ92 TAPQ01 TAPQ02 TAPQ03 TAPQ05 TAPQ07 TAPQ08 TAPQ10 TAPQ11 TAPQ12 TAPQ13 TAPQ14 TAPQ15 TAPQ16 ;
by bene_id;
if in1=1;
run;

%mend ByCond;
%ByCond(yr=2008);
%ByCond(yr=2009);
%ByCond(yr=2010);







***************************
30day Spending After PQI admission in 2008 2009 2010 
***************************;

* Use DUALs; 
 
