***************************************
Question:  
Is there a correlation between hospital level ED 30-day outpatient mortality and 30-day inpatient mortality?

Year: 2014 (have 11 months to work with since we’re looking for 30-day mortality)
Study group: Hospitals that have an ED
Outcome: Adjusted hospital-level 30-day mortality (O/E) adjusting for patient characteristics 
(age, sex, HCC, race, Medicaid eligibility) for diagnoses determined above (we can discuss)

*Note in this analysis, do not exclude patients who died in the ED, just count that in the 30-day mortality

Two clean cohorts
1)	Outpatient ED visit
2)	Inpatient admission WITHOUT AN ED VISIT

O/E at hospital level 

Get overall correlation coefficient and then stratified by hospital characteristics (size, profit status, region, teaching status)
********************************************;


libname denom 'C:\data\Data\Medicare\Denominator';
libname MedPar 'C:\data\Data\Medicare\MedPAR';
libname IP 'C:\data\Data\Medicare\Inpatient'; 
libname op 'C:\data\Data\Medicare\Outpatient';
 libname data 'C:\data\Projects\ED Xiner\Data';

***************************************************
Step 1: Prepare Dataset
**************************************************;

*Population: 65+ FFS Medicare benes, years 2009-2014, 2009-2010 5% op, 2011-2014 20% op;
%macro bene(yr= );

data bene&yr.; 
set denom.dnmntr&yr.;   
*age, sex, Medicaid eligibility, race;
if BUYIN_MO>0 then Medicaid=1;else Medicaid=0;
if age>=65;
keep BENE_ID Age Race Sex DEATH_DT Medicaid sample; 
run;  
 
%mend bene;
%bene(yr=2014);

* OP ED visit;
data data.Op2014;
set data.Q1;
if type="Outpatient" and year=2014;
run;
 


* IP not ED;
proc sql;
create table temp1 as
select bene_id, clm_id, ADMTG_DGNS_CD as diag length=7, STUS_CD, Provider length=10, ADMSN_DT as Date1 label="Admission Date", DSCHRGDT as Date2 label="Discharge Date", FROM_DT, THRU_DT
from ip.Inptclms2014
where clm_id not in (select clm_id from ip.Inptrev2014 where REV_CNTR in ('0450','0451','0452','0456','0459','0981')) ;
quit;
proc sql;
create table temp2 as
select a.*,b.*
from temp1 a inner join bene2014 b
on a.bene_id=b.bene_id;
quit;
*CCS;
proc import datafile="C:\data\Projects\ED Xiner\Program\HCUP-CCS single level diagnoses.csv" 
dbms=csv out=CCS replace;getnames=yes;run;
proc import datafile="C:\data\Projects\ED Xiner\Program\CCSlabel.csv" 
dbms=csv out=CCSlabel replace;getnames=yes;run;
proc sql;
create table temp3 as
select a.*,b.*
from temp2 a left join CCS b
on a.diag=b.ICD_9_CM_CODE;
quit;
proc sql;
create table temp4 as
select *
from temp3 
where ccs_category in (select ccs_category from data.Ccswithlabel);
quit;

* link AHA;
libname aha 'C:\data\Data\Hospital\AHA\Annual_Survey\Data';
 
 
proc sql;
create table temp5 as
select a.*,b.hospsize, b.hosp_reg4, b.teaching, b.profit2, b.teaching 
from temp4 a left join Aha.aha13  b
on a.provider=b.provider;
quit;

* link HCC;
 
libname hcc 'C:\data\Data\Medicare\HCC\HCC using 2014 Algorithm';
 
proc sql;
create table data.iP2014 as
select a.*,
b.HCC1,b.HCC2,b.HCC6,b.HCC8,b.HCC9,b.HCC10,b.HCC11,b.HCC12,b.HCC17,b.HCC18,b.HCC19,
b.HCC21,b.HCC22,b.HCC23, b.HCC27,b.HCC28,b.HCC29,b.HCC33,b.HCC34,b.HCC35,b.HCC39,
b.HCC40,b.HCC46,b.HCC47, b.HCC48,b.HCC54,b.HCC55,b.HCC57,b.HCC58,
b.HCC70,b.HCC71,b.HCC72,b.HCC73,b.HCC74,b.HCC75,b.HCC76,b.HCC77,b.HCC78,b.HCC79,
b.HCC80,b.HCC82,b.HCC83,b.HCC84,b.HCC85,b.HCC86,b.HCC87,b.HCC88,b.HCC96,b.HCC99,
b.HCC100,b.HCC103,b.HCC104,b.HCC106,b.HCC107,b.HCC108,b.HCC110,b.HCC111,b.HCC112,b.HCC114,b.HCC115,
b.HCC122,b.HCC124,b.HCC134,b.HCC135,b.HCC136,b.HCC137,
b.HCC157,b.HCC158,
b.HCC161,b.HCC162,b.HCC166,b.HCC167,b.HCC169,b.HCC170,b.HCC173,b.HCC176,
b.HCC186,b.HCC188,b.HCC189
from temp5 a left join hcc.hcc_ip_2014 b
on a.bene_id=b.bene_id ;
quit;

*hosp has ed;
proc sql;
create table ip2014 as
select *
from data.IP2014
where provider in (select provider from data.op2014);
quit;

* IP;
data temp;
set IP2014;
if month(Date1)<12;
if 0<=DEATH_DT-Date1<=30 then Mort30=1; 
 else mort30=0;
run;
*risk model;
proc genmod data=temp  descending;
Title "3-condition Logistic Regression: Predicted Probability of 30 -day Readmission,Adjusting for HCC,Age,Race,Sex, AMI, CHF, PN";
	class mort30 race  sex   hcc1--hcc189 CCS_CATEGORY;
	model mort30 =  age race  sex hcc1--hcc48 hcc57--hcc189 CCS_CATEGORY/dist=bin link=logit type3;
	output out=IPpmort  pred=pmort ;	
run;
 

data IPpmort;
set IPpmort;
proc sort;by provider;
run;

proc sql;
create table temp1 as
select provider,hospsize,hosp_reg4, teaching, profit2, teaching, 
count(*) as N   , 
mean(mort30) as rawMort30 ,
sum(mort30) as Obs  ,
sum(pmort) as Exp  ,
calculated obs/calculated exp as OtoE  
from IPpmort
group by provider;
quit;
proc sort data=temp1 nodupkey;by provider;run;

proc means data=IPpmort;
var pmort;
run;

data IPMort30;
set temp1;
AdjMort30=OtoE*0.0590173;
run;
 



 
* oP;
data temp;
set data.oP2014;
if month(FROM_DT)<12;
if 0<=DEATH_DT-FROM_DT<=30 then Mort30=1; 
  else mort30=0;
run;
*risk model;
proc genmod data=temp  descending;
Title "3-condition Logistic Regression: Predicted Probability of 30 -day Readmission,Adjusting for HCC,Age,Race,Sex, AMI, CHF, PN";
	class mort30 race  sex   hcc1--hcc189 CCS_CATEGORY;
	model mort30 =  age race  sex hcc1--hcc48 hcc57--hcc189 CCS_CATEGORY/dist=bin link=logit type3;
	output out=OPpmort  pred=pmort ;	
run;

data OPpmort;
set OPpmort;
proc sort;by provider;
run;

proc sql;
create table temp1 as
select provider,hospsize, hosp_reg4, teaching, profit2, teaching, 
count(*) as N   , 
mean(mort30) as rawMort30 ,
sum(mort30) as Obs  ,
sum(pmort) as Exp  ,
calculated obs/calculated exp as OtoE  
from OPpmort
group by provider;
quit;
proc sort data=temp1 nodupkey;by provider;run;

proc means data=OPpmort;
var pmort;
run;

data OPMort30;
set temp1;
AdjMort30=OtoE*0.0219628;
run;


* correlation;
proc sql;
create table corr as
select b.*,a.N as Nip,a.rawMort30 as rawMort30ip, a.Obs as Obsip, a.Exp as Expip, a.OtoE as OtoEip, a.AdjMort30 as AdjMort30ip
from IPmort30 a inner join OPmort30 b
on a.provider=b.provider;
quit;

proc corr data=corr;
title 'Get overall correlation coefficient ';
var AdjMort30 AdjMort30ip;
run;

proc corr data=corr;
title "stratefied by size=small";
where hospsize=1;
var AdjMort30 AdjMort30ip;
run;
proc corr data=corr;
title "stratefied by size=medium";
where hospsize=2;
var AdjMort30 AdjMort30ip;
run;
proc corr data=corr;
title "stratefied by size=large";
where hospsize=3;
var AdjMort30 AdjMort30ip;
run;

proc corr data=corr;
title "stratefied by NE";
where hosp_reg4=1;
var AdjMort30 AdjMort30ip;
run;
proc corr data=corr;
title "stratefied by MW";
where hosp_reg4=2;
var AdjMort30 AdjMort30ip;
run;
proc corr data=corr;
title "stratefied by S";
where hosp_reg4=3;
var AdjMort30 AdjMort30ip;
run;
proc corr data=corr;
title "stratefied by W";
where hosp_reg4=4;
var AdjMort30 AdjMort30ip;
run;

proc corr data=corr;
title "stratefied by Major teaching";
where teaching=1;
var AdjMort30 AdjMort30ip;
run;
proc corr data=corr;
title "stratefied by Minor teaching";
where teaching=2;
var AdjMort30 AdjMort30ip;
run;
proc corr data=corr;
title "stratefied by Non-teaching";
where teaching=3;
var AdjMort30 AdjMort30ip;
run;

proc corr data=corr;
title "stratefied by for-profit";
where profit2=1;
var AdjMort30 AdjMort30ip;
run;
proc corr data=corr;
title "stratefied by non-for-profit";
where profit2=2;
var AdjMort30 AdjMort30ip;
run;
proc corr data=corr;
title "stratefied by gov non-for-profit";
where profit2=3;
var AdjMort30 AdjMort30ip;
run;
  
