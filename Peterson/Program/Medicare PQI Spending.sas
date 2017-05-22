************************************
Medicare PQI Spending
Xiner Zhou
7/12/2016
************************************;
libname PQI 'C:\data\Projects\Scorecard\data';
libname MedPar 'C:\data\Data\Medicare\MedPAR';
libname op 'C:\data\Data\Medicare\Outpatient';
libname car 'C:\data\Data\Medicare\Carrier';
libname HHA 'C:\data\Data\Medicare\HHA';
libname hospice 'C:\data\Data\Medicare\Hospice';
libname DME 'C:\data\Data\Medicare\DME';
libname SNF 'C:\data\Data\Medicare\SNF';
libname mmleads 'C:\data\Projects\Peterson\Data';

**************************
Please Change macro yr to which year the analysis look at
**************************;
%let yr=2008;
%let yr1=2009;

%let yr=2009;
%let yr1=2010;

%let yr=2010;
%let yr1=2011;
****************************
Preventive Spending by PQIs 2008 2009 2010
*****************************;
 
* Link PQI back to claims, and take actual spending;
proc sql;
create table temp1 as 
select c.*,d.ADMSNDT as PQIdate1, d.DSCHRGDT as PQIdate2, d.PMT_AMT 
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


data temp1;
set temp1;
array try {16}  TAPQ01 TAPQ02 TAPQ03 TAPQ05 TAPQ07 TAPQ08 TAPQ10 TAPQ11 TAPQ12 TAPQ13 TAPQ14 TAPQ15 TAPQ16  
TAPQ90 TAPQ91 TAPQ92  ;
do i=1 to 16;
if try{i}=. then try{i}=0;
end;
drop i;
run;
 


* Summarize at bene level, total N PQI & spending, and separetely for each condition;
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
 


******************************
30day After PQI admision
******************************;
 
proc sql;
create table temp1 as 
select c.bene_id,d.ADMSNDT as PQIdate1, d.DSCHRGDT as PQIdate2 
from
(select a.bene_id, b.MEDPARID
from PQI.Pqi_medpar&yr.v45 a left join PQI.Prepare_for_pqi_medpar&yr. b
on a.key=b.key
where a.TAPQ90=1) c 
left join 
MedPar.Medparsl&yr. d
on c.MEDPARID=d.MEDPARID;
quit;


* Post 30-day Acute Care and Post Acute Care Hospitalization Spending (including PQI itself);
proc sql;
create table ip&yr. as
select a.*, 
       b.MEDPARID,
	   case when ('3025'<= substr(b.provider,3,4) <= '3099' or substr(b.provider,3,1) in ('R','T')) 
            then 'Inpatient Rehabilitation Facility(IRF)'
            when substr(b.provider,3,2) in ('00','01','02','03','04','05','06','07','08','09','13' )
            then  'Acute Care Hospital (include CAH)'
			when (substr(b.provider,3,2) in ('40','41','42','43','44') or substr(b.provider,3,1) in ('M','S'))
            then 'Inpatient Psychiatric Facility (IPF)'
			when substr(b.provider,3,2) in ('20','21','22')
            then 'Long-Term Care Hospital (LTCH)'	
        else 'Other inpatient'	
		end as Type,
		"IP" as clm,
    b.ADMSNDT as PostPQIdate1,b.DSCHRGDT as PostPQIdate2, b.PMT_AMT  

    from temp1 a 
     left join 
    (select  bene_id, MEDPARID, ADMSNDT, DSCHRGDT, PRVDRNUM as Provider, PMT_AMT   from MedPar.Medparsl&yr.) b

on a.bene_id=b.bene_id
where a.PQIdate1<=b.ADMSNDT and a.PQIdate2+30>=b.ADMSNDT ;
quit;

* Double -counting, attribute to the latest PQI admission;
proc sort data=ip&yr. ;by bene_id MEDPARID descending PQIdate1;run;
proc sort data=ip&yr. nodupkey;by bene_id MEDPARID;run;


* Post 30-day Outpatient Hospital Spending;
proc sql;
create table op&yr. as
select a.*, b.clm_id, 
	   case when  b.FAC_TYPE ='1'
            then  'Hospital Outpatient'
            when  b.FAC_TYPE ='2'
            then  'Skilled nursing facility (SNF)'
			when  b.FAC_TYPE ='3'
            then  'Home health agency (HHA)'
			when  b.FAC_TYPE ='7'
            then  'Clinic or hospital-based renal dialysis facility'
			when  b.FAC_TYPE ='8'
			then  'Special facility or ASC surgery'
		end as Type,
		"OP" as clm,
    b.FROM_DT as PostPQIdate1,b.THRU_DT as PostPQIdate2,b.PMT_AMT  

    from temp1 a 
     left join 
    (select  bene_id, clm_id,FROM_DT, THRU_DT, FAC_TYPE,  PRVDRPMT as PMT_AMT  from op.Otptclms&yr.
                                   outer union corr
     select bene_id, clm_id,FROM_DT, THRU_DT, FAC_TYPE,  PRVDRPMT as PMT_AMT from op.Otptclms&yr1.) b

on a.bene_id=b.bene_id
where  a.PQIdate1<=b.FROM_DT and a.PQIdate2+30>=b.FROM_DT ;
quit;

proc sort data=op&yr. ;by bene_id  clm_id descending PQIdate1;run;
proc sort data=op&yr. nodupkey;by bene_id  clm_id;run;





* Post 30-day Carrier Spending;
proc sql;
create table car&yr. as
select a.*, b.clm_id, 
		"Carrier/Physician" as clm,
    b.FROM_DT as PostPQIdate1,b.THRU_DT as PostPQIdate2,b.PMT_AMT  

    from temp1 a 
     left join 
    (select  bene_id, clm_id,FROM_DT, THRU_DT,   PROV_PMT as PMT_AMT  from car.bcarclms&yr.
                                   outer union corr
     select bene_id, clm_id,FROM_DT, THRU_DT,   PROV_PMT as PMT_AMT from car.bcarclms&yr1.) b

on a.bene_id=b.bene_id
where  a.PQIdate1<=b.FROM_DT and a.PQIdate2+30>=b.FROM_DT ;
quit;

proc sort data=car&yr. ;by bene_id  clm_id descending PQIdate1;run;
proc sort data=car&yr. nodupkey;by bene_id  clm_id;run;

 
* Post 30-day HHA Spending;
proc sql;
create table HHA&yr. as
select a.*, b.clm_id, 
       b.*, "Home Health " as clm
    from temp1 a 
     left join 
    (select  bene_id, clm_id,FROM_DT, THRU_DT, PMT_AMT from hha.Hhaclms&yr.
                                   outer union corr
     select bene_id, clm_id,FROM_DT, THRU_DT, PMT_AMT from hha.Hhaclms&yr1.) b

on a.bene_id=b.bene_id
where  a.PQIdate1<=b.FROM_DT and a.PQIdate2+30>=b.FROM_DT ;
quit;
proc sort data=hha&yr. ;by bene_id  clm_id descending PQIdate1;run;
proc sort data=hha&yr. nodupkey;by bene_id  clm_id;run;

* Post 30-day Hospice Spending;
proc sql;
create table Hspc&yr. as
select a.*, b.clm_id, 
       b.*, "Hospice " as clm
    from temp1 a 
     left join 
    (select  bene_id, clm_id,FROM_DT, THRU_DT, PMT_AMT from hospice.Hspcclms&yr.
                                   outer union corr
     select bene_id, clm_id,FROM_DT, THRU_DT, PMT_AMT from hospice.Hspcclms&yr1.) b

on a.bene_id=b.bene_id
where  a.PQIdate1<=b.FROM_DT and a.PQIdate2+30>=b.FROM_DT ;
quit;
proc sort data=Hspc&yr. ;by bene_id  clm_id descending PQIdate1;run;
proc sort data=Hspc&yr. nodupkey;by bene_id  clm_id;run;

* Post 30-day SNF Spending;
proc sql;
create table SNF&yr. as
select a.*, b.clm_id, 
       b.*, "SNF " as clm
    from temp1 a 
     left join 
    (select  bene_id, clm_id,FROM_DT, THRU_DT, PMT_AMT from SNF.Snfclms&yr.
                                   outer union corr
     select bene_id, clm_id,FROM_DT, THRU_DT, PMT_AMT from SNF.Snfclms&yr1.) b

on a.bene_id=b.bene_id
where  a.PQIdate1<=b.FROM_DT and a.PQIdate2+30>=b.FROM_DT ;
quit;
proc sort data=SNF&yr. ;by bene_id  clm_id descending PQIdate1;run;
proc sort data=SNF&yr. nodupkey;by bene_id  clm_id;run;



* Post 30-day DME Spending;
proc sql;
create table DME&yr. as
select a.*, b.clm_id, 
       b.*, "Durable Medical Equipment (DME) " as clm
    from temp1 a 
     left join 
    (select  bene_id, clm_id,FROM_DT, THRU_DT, PROV_PMT as PMT_AMT from dme.Dmeclms&yr.
                                   outer union corr
     select bene_id, clm_id,FROM_DT, THRU_DT, PROV_PMT as PMT_AMT from dme.Dmeclms&yr1.) b

on a.bene_id=b.bene_id
where  a.PQIdate1<=b.FROM_DT and a.PQIdate2+30>=b.FROM_DT ;
quit;
proc sort data=DME&yr. ;by bene_id  clm_id descending PQIdate1;run;
proc sort data=DME&yr. nodupkey;by bene_id  clm_id;run;




data allclm&yr.;
length type $100. clm $20.;
set ip&yr.(in=in1) op&yr.(in=in2) car&yr.(in=in3) hha&yr.(in=in4) snf&yr.(in=in5) hspc&yr.(in=in6) dme&yr.(in=in7);
if in1=1 then clm="Inpatient";
else if in2=1 then clm="Outpatient";
else if in3=1 then clm="Carrier";
else if in4=1 then clm="HHA";
else if in5=1 then clm="SNF";
else if in6=1 then clm="Hospice";
else if in7=1 then clm="DME";
proc sort;by bene_id clm ;
run;

* bene level cost;
proc sort data=allclm&yr.;by bene_id clm;run;
proc sql;
create table beneclm&yr. as
select bene_id, clm, sum(PMT_AMT) as PostPQISpending
from allclm&yr.
group by bene_id,clm;
quit;
proc sort data=beneclm&yr.  nodupkey;by bene_id clm;run;

* Merge back with PQI spending;
proc sql;
create table tempIP&yr. as
select a.*,b.PostPQISpending as IPSpending label="30-day Inpatient Preventive Spending"
from BenePQI&yr. a left join (select * from beneclm&yr. where  clm="Inpatient") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table tempOP&yr. as
select a.*,b.PostPQISpending as OPSpending label="30-day Outpatient Preventive Spending"
from tempIP&yr. a left join (select * from beneclm&yr. where  clm="Outpatient") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table tempCar&yr. as
select a.*,b.PostPQISpending as CarSpending label="30-day Carrier Preventive Spending"
from tempOP&yr. a left join (select * from beneclm&yr. where  clm="Carrier") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table tempHHA&yr. as
select a.*,b.PostPQISpending as HHASpending label="30-day Home Health Preventive Spending"
from tempCar&yr. a left join (select * from beneclm&yr. where  clm="HHA") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table tempSNF&yr. as
select a.*,b.PostPQISpending as SNFSpending label="30-day SNF Preventive Spending"
from tempHHA&yr.  a left join (select * from beneclm&yr. where  clm="SNF") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table tempHspc&yr. as
select a.*,b.PostPQISpending as HspcSpending label="30-day Hospice Preventive Spending"
from tempSNF&yr. a left join (select * from beneclm&yr. where  clm="Hospice") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table tempDME&yr. as
select a.*,b.PostPQISpending as DMESpending label="30-day DME Preventive Spending"
from tempHspc&yr. a left join (select * from beneclm&yr. where clm="DME") b
on a.bene_id=b.bene_id
;
quit;
 

data mmleads.PQI&yr.;
set tempDME&yr. ;
array try {39} N_TAPQ01 TAPQ01Spending 
               N_TAPQ02 TAPQ02Spending 
               N_TAPQ03 TAPQ03Spending 
			   N_TAPQ05 TAPQ05Spending 
			   N_TAPQ07 TAPQ07Spending 
			   N_TAPQ08 TAPQ08Spending 
			   N_TAPQ10 TAPQ10Spending 
			   N_TAPQ11 TAPQ11Spending 
               N_TAPQ12 TAPQ12Spending
               N_TAPQ13 TAPQ13Spending 
               N_TAPQ14 TAPQ14Spending 
               N_TAPQ15 TAPQ15Spending 
               N_TAPQ16 TAPQ16Spending 
               N_TAPQ90 TAPQ90Spending 
               N_TAPQ91 TAPQ91Spending
               N_TAPQ92 TAPQ92Spending 
IPSpending OPSpending CarSpending HHASpending SNFSpending HspcSpending  DMESpending;
do i=1 to 39;
if try{i}<0 then try{i}=0;
end;
drop i;

TotSpending=IPSpending+OPSpending+CarSpending+HHASpending+SNFSpending+HspcSpending+DMESpending;
proc means;
var TotSpending IPSpending OPSpending CarSpending HHASpending SNFSpending HspcSpending DMESpending
N_TAPQ01 TAPQ01Spending 
               N_TAPQ02 TAPQ02Spending 
               N_TAPQ03 TAPQ03Spending 
			   N_TAPQ05 TAPQ05Spending 
			   N_TAPQ07 TAPQ07Spending 
			   N_TAPQ08 TAPQ08Spending 
			   N_TAPQ10 TAPQ10Spending 
			   N_TAPQ11 TAPQ11Spending 
               N_TAPQ12 TAPQ12Spending
               N_TAPQ13 TAPQ13Spending 
               N_TAPQ14 TAPQ14Spending 
               N_TAPQ15 TAPQ15Spending 
               N_TAPQ16 TAPQ16Spending 
               N_TAPQ90 TAPQ90Spending 
               N_TAPQ91 TAPQ91Spending
               N_TAPQ92 TAPQ92Spending 
IPSpending OPSpending CarSpending HHASpending SNFSpending HspcSpending  DMESpending;
run;


 
