************************************************
Question 1:
Has there been a decrease in 30-day mortality for Medicare beneficiaries seen in the ED?

Population: 65+ FFS Medicare benes, years 2009-2014
-Create a dataset of all ED visits by finding outpatient and inpatient files with codes 0450-0459 and 0981
--Exclude all outpatient visits with an observation code
-Identify principal discharge diagnosis for outpatient visits and principal admission diagnosis for inpatient visits
-Run those through HCUP-CCS single level diagnoses
-Identify the top diagnoses that account for ~80% of combined inpatient+outpatient visits diagnoses
-Limit analyses to these diagnoses

Three categories of disposition: 
1)	Died in the ED (discharged destination of died or death date on the same day as the visit)
2)	Discharged from the ED alive- Top 40 Diagnoses 
3)	Admitted from the ED (have a revenue center code of 0450-0459, 0981)- Principal Admission Diagnoses

-Linear regression
-Random effects for hospital
-Adjust for age, sex, HCC, Medicaid eligibility, race

-Exclude pts with >12 hours observation?
-control for time trend in observation or not?

Outcome: in ED mortality, 30-day outpatient mortality, 30-day inpatient mortality
Predictor: Time 
****************************************************; 

libname denom 'C:\data\Data\Medicare\Denominator';
libname MedPar 'C:\data\Data\Medicare\MedPAR';
libname IP 'C:\data\Data\Medicare\Inpatient'; 
libname op 'C:\data\Data\Medicare\Outpatient';
libname HCC '';

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
%if &yr.=2009 %then %do;
if FIVEPCT="Y"; sample=FIVEPCT;
%end;
%else %if &yr.=2010 %then %do;
if STRCTFLG="05"; sample=STRCTFLG;
%end;
%else %do;
if STRCTFLG in ('15','05'); sample=STRCTFLG;
%end;
keep BENE_ID Age Race Sex DEATH_DT Medicaid sample; 
run;  
 
%mend bene;
%bene(yr=2009);
%bene(yr=2010);
%bene(yr=2011);
%bene(yr=2012);
%bene(yr=2013);
%bene(yr=2014);

* All ED visits by finding outpatient and inpatient files with codes 0450-0459 and 0981;
* Exclude all outpatient visits with an observation code;
/*revenue center code: 
0450 = Emergency room-general classification
0451 = Emergency room-emtala emergency medical screening services (eff 10/96)
0452 = Emergency room-ER beyond emtala screening (eff 10/96)
0456 = Emergency room-urgent care (eff 10/96)
0459 = Emergency room-other
0981 = Professional fees-emergency room

0762 = observation room (eff 9/93)
*/

proc import datafile="C:\data\Projects\ED Xiner\Program\HCUP-CCS single level diagnoses.csv" 
dbms=csv out=CCS replace;getnames=yes;run;
proc import datafile="C:\data\Projects\ED Xiner\Program\CCSlabel.csv" 
dbms=csv out=CCSlabel replace;getnames=yes;run;
%macro claim(yr);
%if &yr.=2009 or &yr.=2010 %then %do;
proc sql;
create table ip&yr. as
select bene_id, MEDPARID as clm_id, AD_DGNS as diag length=7, DSTNTNCD as STUS_CD, PRVDRNUM as Provider length=10, ADMSNDT as Date1 label="Admission Date", DSCHRGDT as Date2 label="Discharge Date"
from Medpar.Medparsl&yr.
where ER_AMT>0 and SSLSSNF in ('S','L');
quit;
%end;
%else %do;
proc sql;
create table ip&yr. as
select bene_id, clm_id, ADMTG_DGNS_CD as diag length=7, STUS_CD, Provider length=10, ADMSN_DT as Date1 label="Admission Date", DSCHRGDT as Date2 label="Discharge Date", FROM_DT, THRU_DT
from ip.Inptclms&yr.
where clm_id in (select clm_id from ip.Inptrev&yr. where REV_CNTR in ('0450','0451','0452','0456','0459','0981'));
quit;
%end;
 
 

data op&yr.0 ;
length diag $7. provider $10.;
set op.Otptclms&yr.;
%if &yr.=2009  %then %do;
diag=DGNSCD1; 
%end;
%else  %do;
diag=PRNCPAL_DGNS_CD;
%end;
keep bene_id clm_id diag STUS_CD provider FROM_DT THRU_DT;
run;
proc sql;
create table op&yr. as
select *
from op&yr.0
where clm_id in (select clm_id from op.Otptrev&yr. where REV_CNTR in ('0450','0451','0452','0456','0459','0981'))
and clm_id not in (select clm_id from op.Otptrev&yr. where REV_CNTR in ('0762'));
quit;

data clm&yr.00;
length type $15.;
set ip&yr.(in=in1) op&yr.(in=in2);
if in1 then type="Inpatient";
else if in2 then type="Outpatient";
run;
proc sql;
create table clm&yr.0 as
select a.*,b.*
from clm&yr.00 a inner join bene&yr. b
on a.bene_id=b.bene_id;
quit;

*CCS;
proc sql;
create table clm&yr. as
select a.*,b.*
from clm&yr.0 a left join CCS b
on a.diag=b.ICD_9_CM_CODE;
quit;
%mend claim;
%claim(yr=2009);
%claim(yr=2010);
%claim(yr=2011);
%claim(yr=2012);
%claim(yr=2013);
%claim(yr=2014);

* Put all years together;
data clm;
set clm2009(in=in1) clm2010(in=in2) clm2011(in=in3) clm2012(in=in4) clm2013(in=in5) clm2014(in=in6) ;
if in1 then year=2009;
if in2 then year=2010;
if in3 then year=2011;
if in4 then year=2012;
if in5 then year=2013;
if in6 then year=2014;

* acute care and CAH only;
if substr(provider,3,2) in ('00','01','02','03','04','05','06','07','08','09','13') ;
* exclude 0 (I assume missing diagnosis) and 259 (unclassified);
if CCS_CATEGORY not in ('0','259');
run;

proc freq data=clm;
tables CCS_CATEGORY /missing out=ccs;
run;
data ccs;set ccs;CCS_Category1=CCS_Category*1;run;
proc sql;
create table CCSwithlabel as 
select a.*,b.* 
from ccs a left join CCSlabel b 
on a.CCS_Category1=b.CCS_Category;quit;
proc sort data=CCSwithlabel;by descending percent ;run;
proc print data=CCSwithlabel;run;

 

data CCSwithlabel;
set CCSwithlabel;
if _n_<=40;
run;
* top 40 only;
proc sql;
create table temp0 as
select *
from clm
where CCS_Category in (select CCS_Category from CCSwithlabel);
quit;

* link AHA;
libname aha 'C:\data\Data\Hospital\AHA\Annual_Survey\Data';
data Aha13;
set aha.aha13;
if substr(provider,3,2) in ('00','01','02','03','04','05','06','07','08','09','13') ;
run;
proc rank data=Aha13 out=Aha group=4;
var dshpct2012;
ranks DSHQuartile;
run;
 
proc sql;
create table temp1 as
select a.*,b.hospsize, b.hosp_reg4, b.teaching, b.profit2, b.teaching, b.dshpct2012, b.DSHQuartile
from temp0 a left join Aha  b
on a.provider=b.provider;
quit;

* link HCC;
libname data 'C:\data\Projects\ED Xiner\Data';
libname hcc 'C:\data\Data\Medicare\HCC\HCC using 2014 Algorithm';
 
proc sql;
create table temp2 as
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
from temp1 a left join hcc.hcc_ipop_2009 b
on a.bene_id=b.bene_id 
where a.year=2009;
quit;

proc sql;
create table temp3 as
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
from temp1 a left join hcc.hcc_ipop_2010 b
on a.bene_id=b.bene_id 
where a.year=2010;
quit;

proc sql;
create table temp4 as
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
from temp1 a left join hcc.hcc_ipop_2011 b
on a.bene_id=b.bene_id 
where a.year=2011;
quit;

proc sql;
create table temp5 as
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
from temp1 a left join hcc.hcc_ipop_2012 b
on a.bene_id=b.bene_id 
where a.year=2012;
quit;

proc sql;
create table temp6 as
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
from temp1 a left join hcc.hcc_ipop_2013 b
on a.bene_id=b.bene_id 
where a.year=2013;
quit;

proc sql;
create table temp7 as
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
from temp1 a left join hcc.hcc_ipop_2014 b
on a.bene_id=b.bene_id 
where a.year=2014;
quit;

/*
Three categories of disposition: 
1)	Died in the ED (discharged destination of died or death date on the same day as the visit)
2)	Discharged from the ED alive- Top 40 Diagnoses 
3)	Admitted from the ED (have a revenue center code of 0450-0459, 0981)- Principal Admission Diagnoses

IP and OP are mutually exclusive almost, so IP claims with ED component can be vied as admitted through ED
OP can be categorized into two mutually exclusive categories: died or discharged alive
*/

data data.Q1;
length dispose $20.;
set temp2 temp3 temp4 temp5 temp6 temp7;
 
if type="Outpatient" then do;
	if  STUS_CD in ('20','40','41','42') or (THRU_DT=Death_dt and Death_dt ne .) then do;dispose="Died in the ED";dispose1=1;end;
    else do;dispose="Discharged from the ED alive";dispose1=2;end;
end;

if type="Inpatient" then do;dispose="Admitted from the ED";dispose1=3;end;
 
run;


/*
Outcome: in ED mortality, 30-day outpatient mortality, 30-day inpatient mortality
*/
data inEDmort;
set data.Q1;
if hosp_reg4 ne 5;
if type="Outpatient";
if dispose1=1 then inEDmort=1;else inEDmort=0;
time=year-2009;
proc means ;
class year;
var inEDmort;
run;
 

data IPOPmort;
set data.Q1;
*inpatient use date1 and date2;
*outpatient use from_dt and thru_dt;
if hosp_reg4 ne 5;
if type="Inpatient" then do;
	if   0<=DEATH_DT-Date1<=30 then Mort30=1; 
	else Mort30=0;
end;
if type="Outpatient" then do;
    if dispose1 ne 1;
	if   0<=DEATH_DT-From_dt<=30 then Mort30=1; 
	else Mort30=0;
end;
time=year-2009;
proc means ;
class year type;
var Mort30;
run;


***************************************************
Step 2: Linear Regressions
**************************************************;

proc glimmix data=inEDmort;
Title "in ED mortality Trend";
 class race  sex Medicaid provider   ;
model inEDmort=time /s dist=normal cl ;
random int  / subject=provider ;
 
run;
proc glimmix data=IPOPmort;
Title "30-day outpatient mortality Trend";
where type="Outpatient";
 class race  sex Medicaid provider   ;
model Mort30=time   /s dist=normal cl ;
random int  / subject=provider ;
 
run;

proc glimmix data=IPOPmort ;
Title "30-day inpatient mortality Trend";
where type="Inpatient" ;
 class race  sex Medicaid provider   ;
model Mort30=time   /s dist=normal cl ;
random int  / subject=provider ;
run; 


proc glimmix data=inEDmort;
Title "in ED mortality Trend";
 class race  sex Medicaid provider   ;
model inEDmort=time age race sex  /s dist=normal cl ;
random int  / subject=provider ;
run;
 

proc glimmix data=IPOPmort;
Title "30-day outpatient mortality Trend";
where type="Outpatient";
 class race  sex Medicaid provider   ;
model Mort30=time age race sex  /s dist=normal cl ;
random int  / subject=provider ;
run;

proc glimmix data=IPOPmort ;
Title "30-day inpatient mortality Trend";
where type="Inpatient" ;
 class race  sex Medicaid provider  ;
model Mort30=time  age race sex   /s dist=normal cl ;
random int  / subject=provider ;
run; 


proc glimmix data=inEDmort;
Title "in ED mortality Trend";
 class race  sex Medicaid provider   ;
model inEDmort=time age race sex Medicaid  /s dist=normal cl ;
random int  / subject=provider ;
run;
 

proc glimmix data=IPOPmort;
Title "30-day outpatient mortality Trend";
where type="Outpatient";
 class race  sex Medicaid provider   ;
model Mort30=time age race sex Medicaid /s dist=normal cl ;
random int  / subject=provider ;
run;

proc glimmix data=IPOPmort ;
Title "30-day inpatient mortality Trend";
where type="Inpatient" ;
 class race  sex Medicaid provider  ;
model Mort30=time  age race sex Medicaid  /s dist=normal cl ;
random int  / subject=provider ;
run; 

proc glimmix data=inEDmort;
Title "in ED mortality Trend";
 class race  sex Medicaid provider   CCS_CATEGORY;
model inEDmort=time age race sex Medicaid  CCS_CATEGORY /s dist=normal cl ;
random int  / subject=provider ;
 
run;
 

proc glimmix data=IPOPmort;
Title "30-day outpatient mortality Trend";
where type="Outpatient";
 class race  sex Medicaid provider  CCS_CATEGORY;
model Mort30=time age race sex Medicaid    CCS_CATEGORY /s dist=normal cl ;
random int  / subject=provider ;
run;


proc glimmix data=IPOPmort ;
Title "30-day inpatient mortality Trend";
where type="Inpatient" ;
 class race  sex Medicaid provider   CCS_CATEGORY;
model Mort30=time  age race sex Medicaid  CCS_CATEGORY /s dist=normal cl ;
random int  / subject=provider ;
run; 
 
***********************************
Q2: Hosp char trend difference
**********************************;
proc glimmix data=inEDmort;
Title "in ED mortality Trend";
 class race  sex Medicaid provider hcc1--hcc189 hospsize hosp_reg4 teaching profit2 CCS_CATEGORY;
model inEDmort=time hospsize time*hospsize age race sex Medicaid  CCS_CATEGORY/s dist=normal cl ;
random int  / subject=provider ;
run;
 
proc glimmix data=inEDmort;
Title "in ED mortality Trend";
 class race  sex Medicaid provider hcc1--hcc189 hospsize hosp_reg4 teaching profit2 CCS_CATEGORY;
model inEDmort=time teaching time*teaching age race sex Medicaid  CCS_CATEGORY/s dist=normal cl ;
random int  / subject=provider ;
run;

proc glimmix data=IPOPmort;
Title "30-day outpatient mortality Trend";
where type="Outpatient" ; 
 class race  sex Medicaid provider hcc1--hcc189 hospsize hosp_reg4 teaching profit2 CCS_CATEGORY;
model Mort30=time hospsize time*hospsize age race sex Medicaid  CCS_CATEGORY/s dist=normal cl ;
random int  / subject=provider ;
run;
proc glimmix data=IPOPmort;
Title "30-day outpatient mortality Trend";
where type="Outpatient"  ; 
 class race  sex Medicaid provider hcc1--hcc189 hospsize hosp_reg4 teaching profit2 CCS_CATEGORY;
model Mort30=time teaching time*teaching age race sex Medicaid  CCS_CATEGORY/s dist=normal cl ;
random int  / subject=provider ;
run;


proc glimmix data=IPOPmort;
Title "30-day inpatient mortality Trend";
where type="Inpatient" ; 
 class race  sex Medicaid provider hcc1--hcc189 hospsize hosp_reg4 teaching profit2 CCS_CATEGORY;
model Mort30=time hospsize time*hospsize age race sex Medicaid  CCS_CATEGORY/s dist=normal cl ;
random int  / subject=provider ;
run;
proc glimmix data=IPOPmort;
Title "30-day inpatient mortality Trend";
where type="Inpatient"  ; 
 class race  sex Medicaid provider hcc1--hcc189 hospsize hosp_reg4 teaching profit2 CCS_CATEGORY;
model Mort30=time teaching time*teaching age race sex Medicaid  CCS_CATEGORY/s dist=normal cl ;
random int  / subject=provider ;
run;
 
