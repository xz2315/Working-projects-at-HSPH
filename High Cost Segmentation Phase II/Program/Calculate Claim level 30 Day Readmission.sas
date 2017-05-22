***************************************
Claim level AMI/CHF/PN
30day Readmission/Mortality/Inpatient Death
Xiner Zhou
12/13/2016
***************************************;

************************************
Select bene:
Not HMO
at least 30-day post-discharge enrollment in Medicare
Within 52 states
Acute Care hospitals and Critical Access hospitals only
***********************************;
libname data 'C:\data\Projects\High Cost Segmentation Phase II\Data';
libname denom 'C:\data\Data\Medicare\Denominator';
libname elix 'C:\data\Data\Medicare\HCUP_Elixhauser\Data';
 
  
*******************************************************
Extract IP claims with target conditions identified
*******************************************************;
%macro Elix11to14(yr=);
data temp&yr._0;
set  elix.Elixall&yr.;
* Initializa conditions;
AMIDx=0;CHFDx=0;PNDx=0;
* Rename variables; 
format  AdmissionDate DischargeDate mmddyy10.;
%if &yr.=2009 %then %do;
PrimaryDx=DGNSCD1;
%end;
%else  %do;
PrimaryDx=PRNCPAL_DGNS_CD;
%end;
AdmissionDate=ADMSN_DT;
DischargeDate=DSCHRGDT;
AdmissionSource=SRC_ADMS;
DischargeStatus=STUS_CD;
* acute care only;
i=substr(provider,3,2) ; 
if i in ('00','01','02','03','04','05','06','07','08','09','13' );

* Look at incentivized conditions;
if PrimaryDx in ('41000','41001','41011','41020','41021','41030','41031','41040','41041','41050') or
PrimaryDx in ('41051','41060','41061','41070','41071','41080','41081','41090','41091')
then AMIDx=1; 
if PrimaryDx in ('40201','40211','40291','40401','40403','40411','40413','40491','40493','4280','4281') or
PrimaryDx in ('42820','42821','42822','42823','42830','42831','42832','42833','42840','42841','42842','42843','4289')
then  chfDx=1;
if PrimaryDx in ('4800','4801','4802','4803','4808','4809','481','4820','4821','4822','48230','48231','48232','48239') or
PrimaryDx in ('48240','48241','48249','48281','48282','48283','48284','48289','4829','4830','4831','4838','485','486','4870' )
then pnDx=1; 
 
keep bene_id clm_id provider  AdmissionDate DischargeDate  AdmissionSource DischargeStatus  amiDx chfDx pnDx ;
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
 
* AMI;
data temp&yr._1_AMI;
set temp&yr._0;
* Without in-hospital death, not transferred to another acute care facility, have more than 30-day post-discharge follow-up, not leave against medical advices;
if DischargeStatus not in ('20','02','05', '09','66','81','82','83','84','85','86','87','88','89','90','91','92','93','94','95','96','97','98','99')
and month(DischargeDate)<12 and DischargeStatus not in ('07') and AMIDx=1;
proc sort nodupkey;by bene_id AdmissionDate DischargeDate  ; 
run;
* clean-up within 30-day ;
data temp&yr._1_AMI;
set temp&yr._1_AMI;
retain index_date;
format index_date mmddyy10.;
by bene_id AdmissionDate DischargeDate ;
if first.bene_id=1 then do;
	index_date=DischargeDate;	 
End; 
else  do;
	Gap=AdmissionDate-index_date;  
	if gap>30 then index_date=DischargeDate;
	else if gap<=30 and gap>=0 then within30=1;
End;
if within30 ne 1;
*drop index_date gap within30;
run;

* CHF;
data temp&yr._1_CHF;
set temp&yr._0;
* Without in-hospital death, not transferred to another acute care facility, have more than 30-day post-discharge follow-up, not leave against medical advices;
if DischargeStatus not in ('20','02','05', '09','66','81','82','83','84','85','86','87','88','89','90','91','92','93','94','95','96','97','98','99')
and month(DischargeDate)<12 and DischargeStatus not in ('07') and CHFDx=1;
proc sort nodupkey;by bene_id AdmissionDate DischargeDate  ; 
run;
* clean-up within 30-day ;
data temp&yr._1_CHF;
set temp&yr._1_CHF;
retain index_date;
format index_date mmddyy10.;
by bene_id AdmissionDate DischargeDate ;
if first.bene_id=1 then do;
	index_date=DischargeDate;	 
End; 
else  do;
	Gap=AdmissionDate-index_date;  
	if gap>30 then index_date=DischargeDate;
	else if gap<=30 and gap>=0 then within30=1;
End;
if within30 ne 1;
drop index_date gap within30;
run;

* PN;
data temp&yr._1_PN;
set temp&yr._0;
* Without in-hospital death, not transferred to another acute care facility, have more than 30-day post-discharge follow-up, not leave against medical advices;
if DischargeStatus not in ('20','02','05', '09','66','81','82','83','84','85','86','87','88','89','90','91','92','93','94','95','96','97','98','99')
and month(DischargeDate)<12 and DischargeStatus not in ('07') and PNDx=1;
proc sort nodupkey;by bene_id AdmissionDate DischargeDate  ; 
run;
* clean-up within 30-day ;
data temp&yr._1_PN;
set temp&yr._1_PN;
retain index_date;
format index_date mmddyy10.;
by bene_id AdmissionDate DischargeDate ;
if first.bene_id=1 then do;
	index_date=DischargeDate;	 
End; 
else  do;
	Gap=AdmissionDate-index_date;  
	if gap>30 then index_date=DischargeDate;
	else if gap<=30 and gap>=0 then within30=1;
End;
if within30 ne 1;
drop index_date gap within30;
run;

data temp&yr._2;
set temp&yr._1_AMI temp&yr._1_CHF temp&yr._1_PN;
run;
%mend indexAdmission;
%indexAdmission(yr=2012);
%indexAdmission(yr=2013);
%indexAdmission(yr=2014);

***************************************************
Identify 30-day readmission for targeted conditions
***************************************************;
%macro readm(yr);
proc sql;
create table temp&yr._3 as
select a.*,b.AdmissionDate as date1, b.DischargeDate as date2, b.AMIDx as AMIDx1, b.CHFDx as CHFDx1, b.PNDx as PNDx1
from temp&yr._2 a left join temp&yr._0 b
on a.bene_id=b.bene_id and a.AdmissionDate ne b.AdmissionDate and a.DischargeDate ne b.DischargeDate and a.DischargeDate<=b.AdmissionDate;
quit;

data temp&yr._4;
set temp&yr._3;
gap=date1-DischargeDate;
if gap>=0 and gap<=30 then readm=1;
else readm=0;
proc sort nodupkey;by bene_id AdmissionDate DischargeDate  ; 
run;
 

data Readm30clm&yr.;
set temp&yr._4 ;
keep bene_id clm_id AMIDx CHFDx PNDx Readm;
run;

proc sql;
create table data.Readm30clm&yr. as
select a.bene_id,a.clm_id,a.AMIDx,a.CHFDx,a.PNDx,b.Readm
from  temp&yr._0 a left join Readm30clm&yr. b
on a.clm_id=b.clm_id;
quit;

proc freq data=data.Readm30clm&yr.;tables readm/missing;run;
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
 
data data.Mortclm&yr.;
set  elix.Elixall&yr.;
 
AMIDx=0;CHFDx=0;PNDx=0;
 
format  AdmissionDate DischargeDate mmddyy10.;

PrimaryDx=PRNCPAL_DGNS_CD;

AdmissionDate=ADMSN_DT;
DischargeDate=DSCHRGDT;
AdmissionSource=SRC_ADMS;
DischargeStatus=STUS_CD;
 
i=substr(provider,3,2) ; 
if i in ('00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '13');

 
if PrimaryDx in ('41000','41001','41011','41020','41021','41030','41031','41040','41041','41050') or 
PrimaryDx in ('41051','41060','41061','41070','41071','41080','41081','41090','41091')
then AMIDx=1; 
if PrimaryDx in ('40201','40211','40291','40401','40403','40411','40413','40491','40493','4280') or
PrimaryDx in ('4281','42820','42821','42822','42823','42830','42831','42832','42833','42840','42841','42842','42843','4289')
then  chfDx=1;
if PrimaryDx in ('4800','4801','4802','4803','4808','4809','481','4820','4821','4822','48230') or 
PrimaryDx in ('48231','48232','48239','48240','48241','48249','48281','48282','48283','48284','48289','4829','4830','4831','4838','485','486','4870')
then pnDx=1; 
 
temp=DischargeDate-death_dt ;
if temp>=0 then MortIP=1;else MortIP=0;

 
temp1=death_dt-AdmissionDate;
if   temp1>=0 and temp1<=30 then Mort30=1; else Mort30=0;
if month(AdmissionDate)=12 then Mort30=.;

keep bene_id clm_id AMIDx chfDx pnDx MortIP Mort30;
run;
proc means data=data.Mortclm&yr.;
var MortIP Mort30;
run;
 
%mend IdentityMort;
%IdentityMort(yr=2012);
%IdentityMort(yr=2013);
%IdentityMort(yr=2014);
 
