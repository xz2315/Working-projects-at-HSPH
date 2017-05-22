********************************************
Patient Level Cost and Utilization 2012-2014
Xiner Zhou
12/5/2016
********************************************;
libname denom 'D:\Data\Medicare\Denominator';
libname stdcost 'D:\Data\Medicare\StdCost\Data';
libname hsp 'D:\Data\Medicare\Hospice';
libname data 'D:\Projects\High Cost Segmentation Phase II\Data';

%macro byclmtype(yr);
 
* IP;
data IP&yr._1;
length clm clm1 $150.;
set stdcost.Ipclmsstdcost&yr.;

clm="Inpatient Claims";
LOS=max(1,DSCHRGDT-ADMSN_DT);

if clm_type in ('60','61') and substr(provider,3,1)='0'  then clm1='Inpatient Hospital (Acute Hospital)';
else if clm_type in ('60','61') and substr(provider,3,2)='13' then clm1="Critical Access Hospital (CAH) - Inpatient Services"; 
else if clm_type in ('60','61') and (substr(provider,3,2) in ('40','41','42','43','44') or substr(provider,3,1) in ('M','S')) then clm1='Inpatient Psychiatric Facility (IPF)';
else if clm_type in ('60','61') and substr(provider,3,2) in ('20','21','22') then clm1='Long-Term Care Hospital (LTCH)';
else if clm_type in ('60','61') and substr(provider,3,4)*1>=3025 and substr(provider,3,4)*1<=3099 then clm1='Inpatient Rehabilitation Facility (IRF)';
else clm1="Other Inpatient";

if actual<=0 then do;stdcost=0;actual=0;end;

keep bene_id clm_id  clm clm1 actual stdcost LOS;
proc sort ;by bene_id clm  clm1;
run;

proc sql;
create table IP&yr._2 as
select bene_id, clm, clm1, sum(actual) as actual, sum(stdcost) as stdcost, sum(LOS) as LOS, count(distinct clm_id) as numclm
from IP&yr._1 
group by bene_id, clm, clm1;
quit;

proc sort data=IP&yr._2 out=data.UtilIP&yr. nodupkey;by bene_id clm clm1;run;

* OP;
data OP&yr._1;
length clm  $150.;
%if &yr.=2014 %then %do;
set stdcost.Opclmslinesstdcost&yr.;
%end;
%else %do;
set stdcost.Opclmsstdcost&yr.;
%end;

 
clm="Outpatient Claims";
 
if actual<=0 then do;stdcost=0;actual=0;end;

keep bene_id clm_id clm  actual stdcost;
proc sort ;by bene_id  clm;
run;

proc sql;
create table OP&yr._2 as
select bene_id, clm,  sum(actual) as actual, sum(stdcost) as stdcost,  count(distinct clm_id ) as numclm
from OP&yr._1 
group by bene_id, clm ;
quit;

proc sort data=OP&yr._2 out=data.UtilOP&yr. nodupkey;by bene_id clm ;run;

* Car;
data car&yr._1;
length clm clm1 $150.;
set stdcost.Carrclmslinesstdcost&yr.;
 
clm="Carrier Claims";

if substr(BETOS,1,2) in ("M1","M2","M3","M4","M5","M6") then clm1="Evaluation AND Management";
else if substr(BETOS,1,2) in ("P1","P2","P3","P4","P5","P6","P7","P8","P9") then clm1="Procedures";
else if substr(BETOS,1,2) in ("I1","I2","I3","I4") then clm1="Imaging";
else if substr(BETOS,1,2) in ("T1","T2") then clm1="Tests";
else if substr(BETOS,1,2)="D1" then clm1="Durable Medical Equipment";
else if substr(BETOS,1,2)="O1" then clm1="Other Services";
else  clm1="Unclassified";
 
 
if actual<=0 then do;stdcost=0;actual=0;end;

keep bene_id clm clm1 actual stdcost;
proc sort ;by bene_id clm clm1;
run;

proc sql;
create table car&yr._2 as
select bene_id, clm, clm1, sum(actual) as actual, sum(stdcost) as stdcost,  count(*) as numclm
from car&yr._1 
group by bene_id, clm, clm1;
quit;

proc sort data=car&yr._2 out=data.UtilCarrier&yr.  nodupkey;by bene_id clm clm1;run;

* HHA;
data HHA&yr._1;
length clm  $150.;
set stdcost.Hhaclmsstdcost&yr.;
 
clm="HHA Claims";
LOS=max(1,THRU_DT-FROM_DT);
if actual<=0 then do;stdcost=0;actual=0;end;

keep bene_id clm_id clm  actual stdcost LOS VISITCNT;
proc sort ;by bene_id clm ;
run;

proc sql;
create table HHA&yr._2 as
select bene_id, clm,  sum(actual) as actual, sum(stdcost) as stdcost, sum(LOS) as LOS, count(distinct clm_id) as numclm, sum(VISITCNT) as HHAvisit
from HHA&yr._1 
group by bene_id,clm ;
quit;

proc sort data=HHA&yr._2 out=data.UtilHha&yr. nodupkey;by bene_id clm ;run;

* SNF;
data SNF&yr._1;
length clm  $150.;
set stdcost.Snfclmsstdcost&yr.;
 
clm="SNF Claims";
 
if actual<=0 then do;stdcost=0;actual=0;end;

keep bene_id clm_id clm  actual stdcost UTIL_DAY;
proc sort ;by bene_id clm ;
run;

proc sql;
create table SNF&yr._2 as
select bene_id, clm,  sum(actual) as actual, sum(stdcost) as stdcost, sum(UTIL_DAY) as LOS, count(distinct clm_id) as numclm
from SNF&yr._1 
group by bene_id,clm;
quit;

proc sort data=SNF&yr._2 out=data.UtilSNF&yr. nodupkey;by bene_id clm ;run;

 
* Hospice;
%if &yr.=2014 %then %do;
proc sort data=stdcost.Hspclmslinesstdcost2014;by clm_id;run;
proc sql;
create table temp as
select clm_id, sum(stdcost) as stdcost, sum(actual) as actual
from stdcost.Hspclmslinesstdcost2014
group by clm_id;
quit;
proc sort data=temp nodupkey;by clm_id;run;
 
proc sql;
create table Hspclmsstdcost2014 as
select a.BENE_ID, a.CLM_ID,a.UTIL_DAY,b.*
from Hsp.Hspcclms2014 a left join temp b
on a.clm_id=b.clm_id;
quit;

%end;

data Hospice&yr._1;
length clm  $150.;
%if &yr.=2014 %then %do;
set Hspclmsstdcost2014;
%end;
%else %do;
set stdcost.Hspclmsstdcost&yr.;
%end;
 
 
clm="Hospice Claims";
 
if actual<=0 then do;stdcost=0;actual=0;end;
 
keep bene_id clm_id clm  actual stdcost UTIL_DAY;
proc sort ;by bene_id clm;
run;

proc sql;
create table Hospice&yr._2 as
select bene_id, clm,  sum(actual) as actual, sum(stdcost) as stdcost,sum(UTIL_DAY) as LOS, count(distinct clm_id) as numclm
from Hospice&yr._1 
group by bene_id,clm ;
quit;

proc sort data=Hospice&yr._2 out=data.UtilHospice&yr. nodupkey;by bene_id clm;run;

* DME;
data DME&yr._1;
length clm  $150.;
%if &yr.=2014 %then %do;
set stdcost.DMEclmslinesstdcost&yr.;
%end;
%else %do;
set stdcost.DMEclmsstdcost&yr.;
%end;
 
 
clm="DME Claims";
 
if actual<=0 then do;stdcost=0;actual=0;end;

keep bene_id clm_id clm  actual stdcost;
proc sort ;by bene_id clm ;
run;

proc sql;
create table DME&yr._2 as
select bene_id, clm,  sum(actual) as actual, sum(stdcost) as stdcost,count(distinct clm_id) as numclm
from DME&yr._1 
group by bene_id,clm ;
quit;

proc sort data=DME&yr._2  out=data.UtilDME&yr. nodupkey;by bene_id clm;run;
%mend byclmtype;
%byclmtype(yr=2012);
%byclmtype(yr=2013);
%byclmtype(yr=2014);

  
