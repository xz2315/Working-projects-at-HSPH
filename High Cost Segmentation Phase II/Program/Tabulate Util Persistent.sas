************************************************************************************
Persistent Medicare HC 2012-2014 -Jose
Cost and Util  
Xiner Zhou
12/19/2016
************************************************************************************;
libname data 'I:\Projects\High Cost Segmentation Phase II\Data';
libname denom 'C:\data\Data\Medicare\Denominator';
libname stdcost 'C:\data\Data\Medicare\StdCost\Data';
libname frail 'I:\Data\Medicare\Frailty Indicator';
libname cc 'C:\data\Data\Medicare\MBSF CC';
libname seg 'C:\data\Projects\High_Cost_Segmentation\Data';
libname icc 'C:\data\Data\Medicare\Chronic Condition';

%macro bene(yr);
 
* Select 20% Sample;
data Patienttotalcost&yr.  ;
set stdcost.Patienttotalcost&yr.;
if death_dt ne . then died=1;else died=0;
if fullAB =1 and HMO =0 and State_CD*1 ne 40 and State_CD*1>=1 and State_CD*1<=53 then keep=1;else keep=0;
if STRCTFLG ne '' and keep=1 ;
run;
 
* Define HC (5% 10% 25%);
proc rank data=Patienttotalcost&yr. out=Patienttotalcost&yr._r  percent;
var actual stdcost;
ranks pct_actual pct_stdcost;
run;

data Patienttotalcost&yr._r;
set Patienttotalcost&yr._r;
 if pct_actual>=95  then HC5_actual=1;else HC5_actual=0;
 if pct_actual>=90  then HC10_actual=1;else HC10_actual=0;
 if pct_actual>=75  then HC25_actual=1;else HC25_actual=0;

 if pct_stdcost>=95  then HC5_stdcost=1;else HC5_stdcost=0;
 if pct_stdcost>=90  then HC10_stdcost=1;else HC10_stdcost=0;
 if pct_stdcost>=75  then HC25_stdcost=1;else HC25_stdcost=0; 
proc freq;
tables HC5_actual HC10_actual HC25_actual HC5_stdcost HC10_stdcost HC25_stdcost/missing;
run;
 
* IP;
proc sql;
create table temp1&yr. as
select a.*,b.LOS as LOSIP1, b.numclm as numclmIP1
from Patienttotalcost&yr._r a left join (select * from data.Utilip&yr. where  clm1='Inpatient Hospital (Acute Hospital)') b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp2&yr. as
select a.*,b.LOS as LOSIP2, b.numclm as numclmIP2
from temp1&yr. a left join (select * from data.Utilip&yr. where clm1="Critical Access Hospital (CAH) - Inpatient Services") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp3&yr. as
select a.*,b.LOS as LOSIP3, b.numclm as numclmIP3
from temp2&yr. a left join (select * from data.Utilip&yr. where  clm1='Inpatient Psychiatric Facility (IPF)') b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp4&yr. as
select a.*, b.LOS as LOSIP4, b.numclm as numclmIP4
from temp3&yr. a left join (select * from data.Utilip&yr. where clm1='Long-Term Care Hospital (LTCH)') b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp5&yr. as
select a.*,b.LOS as LOSIP5, b.numclm as numclmIP5
from temp4&yr. a left join (select * from data.Utilip&yr. where clm1='Inpatient Rehabilitation Facility (IRF)') b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp6&yr. as
select a.*,b.LOS as LOSIP6, b.numclm as numclmIP6
from temp5&yr. a left join (select * from data.Utilip&yr. where clm1="Other Inpatient") b
on a.bene_id=b.bene_id
;
quit;

* OP;
proc sql;
create table temp7&yr. as
select a.*,b.numclm as numclmOP
from temp6&yr. a left join  data.Utilop&yr.  b
on a.bene_id=b.bene_id
;
quit;

* carrier;
proc sql;
create table temp8&yr. as
select a.*,b.numclm as numclmcar1
from temp7&yr. a left join (select * from data.Utilcarrier&yr. where clm1="Evaluation AND Management") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp9&yr. as
select a.*,b.numclm as numclmcar2
from temp8&yr. a left join (select * from data.Utilcarrier&yr. where clm1="Procedures") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp10&yr. as
select a.*, b.numclm as numclmcar3
from temp9&yr. a left join (select * from data.Utilcarrier&yr. where clm1="Imaging") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp11&yr. as
select a.*, b.numclm as numclmcar4
from temp10&yr. a left join (select * from data.Utilcarrier&yr. where clm1="Tests") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp12&yr. as
select a.*,b.numclm as numclmcar5
from temp11&yr. a left join (select * from data.Utilcarrier&yr. where clm1="Durable Medical Equipment") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp13&yr. as
select a.*, b.numclm as numclmcar6
from temp12&yr. a left join (select * from data.Utilcarrier&yr. where clm1="Other Services") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp14&yr. as
select a.*,b.numclm as numclmcar7
from temp13&yr. a left join (select * from data.Utilcarrier&yr. where clm1="Unclassified") b
on a.bene_id=b.bene_id
;
quit;
 
* HHA;
proc sql;
create table temp15&yr. as
select a.*,b.LOS as LOSHHA, b.numclm as numclmHHA, b.HHAvisit
from temp14&yr. a left join  data.UtilHHA&yr.  b
on a.bene_id=b.bene_id;
quit;
 
* SNF;
proc sql;
create table temp16&yr. as
select a.*, b.LOS as LOSSNF, b.numclm as numclmSNF
from temp15&yr. a left join  data.UtilSNF&yr.  b
on a.bene_id=b.bene_id
;
quit;


* Hospice;
proc sql;
create table temp17&yr. as
select a.*, b.LOS as LOSHospice, b.numclm as numclmHospice
from temp16&yr. a left join  data.UtilHospice&yr.  b
on a.bene_id=b.bene_id
;
quit;

* DME;
proc sql;
create table temp18&yr. as
select a.*,b.numclm as numclmDME
from temp17&yr. a left join  data.UtilDME&yr.  b
on a.bene_id=b.bene_id
;
quit;
 
data temp19&yr. ;
set temp18&yr. ;

array temp {28} 
LOSIP1 LOSIP2 LOSIP3 LOSIP4 LOSIP5 LOSIP6 LOSHHA LOSSNF LOSHospice 
HHAvisit
numclmIP1 numclmIP2 numclmIP3 numclmIP4 numclmIP5 numclmIP6 
numclmOp numclmCar1 numclmCar2 numclmCar3 numclmCar4 numclmCar5 numclmCar6 numclmCar7  
numclmHHA numclmSNF numclmHospice numclmDME ;

do i=1 to 28;
 if temp{i}=. then temp{i}=0;
end;drop i;
 

stdcostIP=stdcostIP1+stdcostIP2+stdcostIP3+stdcostIP4+stdcostIP5+stdcostIP6;
actualIP=actualIP1+actualIP2+actualIP3+actualIP4+actualIP5+actualIP6;

stdcostCar=stdcostCar1+stdcostCar2+stdcostCar3+stdcostCar4+stdcostCar5+stdcostCar6+stdcostCar7;
actualCar=actualCar1+actualCar2+actualCar3+actualCar4+actualCar5+actualCar6+actualCar7;

LOSIP=LOSIP1+LOSIP2+LOSIP3+LOSIP4+LOSIP5+LOSIP6;

numclmIP=numclmIP1+numclmIP2+numclmIP3+numclmIP4+numclmIP5+numclmIP6;

numclmCar=numclmCar1+numclmCar2+numclmCar3+numclmCar4+numclmCar5+numclmCar6+numclmCar7;

array temp1 {7}  stdcostIP actualIP stdcostCar actualCar numclmIP numclmCar LOSIp;
do j=1 to 7;
if temp1{j}=. then temp1{j}=0;
end;drop j;



label LOSIP1="Inpatient Hospital (Acute Hospital)"; 
label LOSIP2="Critical Access Hospital (CAH) - Inpatient Services";   
label LOSIP3='Inpatient Psychiatric Facility (IPF)';  
label LOSIP4='Long-Term Care Hospital (LTCH)';  
label LOSIP5='Inpatient Rehabilitation Facility (IRF)'; 
label LOSIP6="Other Inpatient";  
label LOSHHA="Home Health Agency";  
label LOSSNF="Skilled Nursing Facility";   
label LOSHospice="Hospice"; 

label HHAvisit="Number of HHA Visits";

label numclmIP1="Inpatient Hospital (Acute Hospital)";  
label numclmIP2="Critical Access Hospital (CAH) - Inpatient Services";  
label numclmIP3='Inpatient Psychiatric Facility (IPF)';  
label numclmIP4='Long-Term Care Hospital (LTCH)';   
label numclmIP5='Inpatient Rehabilitation Facility (IRF)';  
label numclmIP6="Other Inpatient";   
label numclmOp="Outpatient";   
label numclmCar1="Evaluation AND Management";  
label numclmCar2="Procedures";   
label numclmCar3="Imaging";   
label numclmCar4="Tests";   
label numclmCar5="Durable Medical Equipment";  
label numclmCar6="Other Services";  
label numclmCar7="Unclassified";    
label numclmHHA="Home Health Agency";  
label numclmSNF="Skilled Nursing Facility";   
label numclmHospice="Hospice";   
label numclmDME="Durable Medical Equipment"; 

label stdcostIP="Total Inpatient";
label actualIP="Total Inpatient"; 
label stdcostCar="Total Carrier"; 
label actualCar="Total Carrier";  
label numclmIP="Total Inpatient";
label numclmCar="Total Carrier"; 
label LOSIp="Total Inpatient";
run;


%mend bene;
%bene(yr=2012);
%bene(yr=2013);
%bene(yr=2014);





%macro util(yr);
 
proc tabulate data=temp19&yr. noseps;
where  STRCTFLG ne '' and keep=1;
class HC5_actual HC10_actual HC25_actual HC5_stdcost HC10_stdcost HC25_stdcost  ;
var  
stdcost
stdcostIP stdcostIP1 stdcostIP2 stdcostIP3 stdcostIP4 stdcostIP5 stdcostIP6 
stdcostOp 
stdcostCar stdcostCar1 stdcostCar2 stdcostCar3 stdcostCar4 stdcostCar5 stdcostCar6 stdcostCar7  
stdcostHHA stdcostSNF stdcostHospice stdcostDME stdcostPartD
actual
actualIP actualIP1 actualIP2 actualIP3 actualIP4 actualIP5 actualIP6 
actualOp 
actualCar actualCar1 actualCar2 actualCar3 actualCar4 actualCar5 actualCar6 actualCar7  
actualHHA actualSNF actualHospice actualDME actualPartD

LOSIP LOSIP1 LOSIP2 LOSIP3 LOSIP4 LOSIP5 LOSIP6 LOSHHA LOSSNF LOSHospice 
HHAvisit
numclmIP numclmIP1 numclmIP2 numclmIP3 numclmIP4 numclmIP5 numclmIP6 
numclmOp 
numclmCar numclmCar1 numclmCar2 numclmCar3 numclmCar4 numclmCar5 numclmCar6 numclmCar7  
numclmHHA numclmSNF numclmHospice numclmDME ;

table (
stdcost
stdcostIP stdcostIP1 stdcostIP2 stdcostIP3 stdcostIP4 stdcostIP5 stdcostIP6 
stdcostOp 
stdcostCar stdcostCar1 stdcostCar2 stdcostCar3 stdcostCar4 stdcostCar5 stdcostCar6 stdcostCar7  
stdcostHHA stdcostSNF stdcostHospice stdcostDME stdcostPartD), 
(HC5_actual*(mean  sum) HC10_actual*(mean  sum) HC25_actual*(mean  sum) HC5_stdcost*(mean  sum) HC10_stdcost*(mean  sum) HC25_stdcost*(mean  sum) all*(mean  sum))/RTS=25;

table ( 
actual
actualIP actualIP1 actualIP2 actualIP3 actualIP4 actualIP5 actualIP6 
actualOp 
actualCar actualCar1 actualCar2 actualCar3 actualCar4 actualCar5 actualCar6 actualCar7  
actualHHA actualSNF actualHospice actualDME actualPartD), 
(HC5_actual*(mean    sum) HC10_actual*(mean  sum) HC25_actual*(mean  sum) HC5_stdcost*(mean  sum) HC10_stdcost*(mean  sum) HC25_stdcost*(mean  sum) all*(mean  sum))/RTS=25;

table (
LOSIP LOSIP1 LOSIP2 LOSIP3 LOSIP4 LOSIP5 LOSIP6 LOSHHA LOSSNF LOSHospice), 
(HC5_actual*(mean*f=15.4  sum) HC10_actual*(mean*f=15.4  sum) HC25_actual*(mean*f=15.4  sum) HC5_stdcost*(mean*f=15.4  sum) HC10_stdcost*(mean*f=15.4  sum) HC25_stdcost*(mean*f=15.4  sum) all*(mean*f=15.4  sum))/RTS=25;

table ( 
numclmIP numclmIP1 numclmIP2 numclmIP3 numclmIP4 numclmIP5 numclmIP6 
numclmOp 
numclmCar numclmCar1 numclmCar2 numclmCar3 numclmCar4 numclmCar5 numclmCar6 numclmCar7  
numclmHHA HHAvisit numclmSNF numclmHospice numclmDME), 
(HC5_actual*(mean*f=15.4  sum) HC10_actual*(mean*f=15.4  sum) HC25_actual*(mean*f=15.4  sum) HC5_stdcost*(mean*f=15.4  sum) HC10_stdcost*(mean*f=15.4  sum) HC25_stdcost*(mean*f=15.4  sum) all*(mean*f=15.4  sum))/RTS=25;
Keylabel all="All Bene";
 
run;
 

%mend util;
%util(yr=2012);
%util(yr=2013);
%util(yr=2014);



* Persistent;
proc sql;
create table temp202014 as
select a.*,b.HC10_stdcost as HC10_stdcost2013
from temp192014 a inner join temp192013 b
on a.bene_id=b.bene_id
where a.STRCTFLG ne '' and a.keep=1 and b.STRCTFLG ne '' and b.keep=1;
quit;
proc sql;
create table temp212014 as
select a.*,b.HC10_stdcost as HC10_stdcost2012
from temp202014 a inner join temp192012 b
on a.bene_id=b.bene_id
where a.STRCTFLG ne '' and a.keep=1 and b.STRCTFLG ne '' and b.keep=1;
quit;
