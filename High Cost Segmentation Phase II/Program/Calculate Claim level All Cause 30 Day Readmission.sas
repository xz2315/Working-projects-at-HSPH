***************************************
Claim level All-Cause
30day Readmission/Mortality/Inpatient Death
Xiner Zhou
12/20/2016
***************************************;

libname data 'C:\data\Projects\High Cost Segmentation Phase II\Data';
libname denom 'C:\data\Data\Medicare\Denominator';
libname elix 'C:\data\Data\Medicare\HCUP_Elixhauser\Data';
 
  
*******************************************************
Extract IP claims with target conditions identified
*******************************************************;
%macro Elix11to14(yr=);
data temp&yr._0;
set  elix.Elixall&yr.;

* Rename variables; 
format  AdmissionDate DischargeDate mmddyy10.;

PrimaryDx=PRNCPAL_DGNS_CD;

AdmissionDate=ADMSN_DT;
DischargeDate=DSCHRGDT;
AdmissionSource=SRC_ADMS;
DischargeStatus=STUS_CD;
* acute care only;
i=substr(provider,3,2) ; 
if i in ('00','01','02','03','04','05','06','07','08','09','13' );
 
keep bene_id clm_id provider  AdmissionDate DischargeDate  AdmissionSource DischargeStatus  ;
proc sort ;by bene_id AdmissionDate DischargeDate provider ; 
proc sort nodupkey;by bene_id AdmissionDate DischargeDate  ;
run;
 
%mend Elix11to14;
%Elix11to14(yr=2012);
%Elix11to14(yr=2013);
%Elix11to14(yr=2014);


********************************************
30-Day Readmission
********************************************;
%macro indexAdmission(yr);

data temp&yr._1;
set temp&yr._0;
* Without in-hospital death, not transferred to another acute care facility, have more than 30-day post-discharge follow-up, not leave against medical advices;
if DischargeStatus not in ('20','02','05', '09','66','81','82','83','84','85','86','87','88','89','90','91','92','93','94','95','96','97','98','99')
and month(DischargeDate)<12 and DischargeStatus not in ('07');
proc sort nodupkey;by bene_id AdmissionDate DischargeDate  ; 
run;

run;

%mend indexAdmission;
%indexAdmission(yr=2012);
%indexAdmission(yr=2013);
%indexAdmission(yr=2014);

***************************************************
Identify 30-day readmission
***************************************************;
%macro readm(yr);
proc sql;
create table temp&yr._2 as
select a.*,b.AdmissionDate as date1, b.DischargeDate as date2
from temp&yr._1 a left join temp&yr._0 b
on a.bene_id=b.bene_id and a.AdmissionDate ne b.AdmissionDate and a.DischargeDate ne b.DischargeDate and a.DischargeDate<=b.AdmissionDate;
quit;

data temp&yr._3;
set temp&yr._2;
gap=date1-DischargeDate;
if gap>=0 and gap<=30 then readm=1;
else readm=0;
proc sort nodupkey;by bene_id AdmissionDate DischargeDate  ; 
run;
 

data Readm30clm&yr.;
set temp&yr._3 ;
keep bene_id clm_id Readm;
run;

proc sql;
create table data.Readm30clmAll&yr. as
select a.bene_id,a.clm_id,b.Readm
from  temp&yr._0 a left join Readm30clm&yr. b
on a.clm_id=b.clm_id;
quit;

proc freq data=data.Readm30clmAll&yr.;tables readm/missing;run;
proc means data=data.Readm30clm&yr.;
title "Overall Readmission Rates: &yr.";
var readm;
run;
%mend readm;
%readm(yr=2012);
%readm(yr=2013);
%readm(yr=2014);
 


********************************************
Identify 30-Day Mortality and Inpatient Mortality
********************************************;
%macro IdentityMort(yr);
 
data data.MortclmAll&yr.;
set  elix.Elixall&yr.;
  
format  AdmissionDate DischargeDate mmddyy10.;

PrimaryDx=PRNCPAL_DGNS_CD;

AdmissionDate=ADMSN_DT;
DischargeDate=DSCHRGDT;
AdmissionSource=SRC_ADMS;
DischargeStatus=STUS_CD;
 
i=substr(provider,3,2) ; 
if i in ('00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '13');
 
temp=DischargeDate-death_dt ;
if temp>=0 then MortIP=1;else MortIP=0;

 
temp1=death_dt-AdmissionDate;
if   temp1>=0 and temp1<=30 then Mort30=1; else Mort30=0;
if month(AdmissionDate)=12 then Mort30=.;

keep bene_id clm_id  MortIP Mort30;
run;
proc means data=data.MortclmAll&yr.;
var MortIP Mort30;
run;
 
%mend IdentityMort;
%IdentityMort(yr=2012);
%IdentityMort(yr=2013);
%IdentityMort(yr=2014);
 
