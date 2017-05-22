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

*********************************************
Table 3: Among Solid Cancers only, top10%
*********************************************;



%macro bene(yr);

* Select 20% Sample;
data Patienttotalcost&yr. ;
set stdcost.Patienttotalcost&yr.;
if death_dt ne . then died=1;else died=0;
if fullAB =1 and HMO =0 and State_CD*1 ne 40 and State_CD*1>=1 and State_CD*1<=53 then keep=1;else keep=0;
if STRCTFLG ne '' and keep=1  ;
run;
 
* Define HC (5% 10% 25%);
proc rank data=Patienttotalcost&yr. out=Patienttotalcost&yr._r  percent;
var actual stdcost;
ranks pct_actual pct_stdcost;
run;

data Patienttotalcost&yr._r;
set Patienttotalcost&yr._r;

 if pct_stdcost>=90  then HC10_stdcost=1;else HC10_stdcost=0;

proc freq;
tables HC10_stdcost /missing;
run;

* cancer;
proc sql;
create table temp1&yr. as
select a.*,b.*
from Patienttotalcost&yr._r a left join data.Cancerbene2014 b
on a.bene_id =b.bene_id  ;
quit;

data temp1&yr.;
set temp1&yr.;
array temp {37} Site_Specific_1 Site_Specific_2 Site_Specific_3 Site_Specific_4 Site_Specific_5 Site_Specific_6 Site_Specific_7
Site_Specific_8 Site_Specific_9 Site_Specific_10 Site_Specific_11 Site_Specific_12 Site_Specific_13 Site_Specific_14 Site_Specific_15
Site_Specific_3_1 Site_Specific_3_2 Site_Specific_3_3 Site_Specific_3_4 Site_Specific_3_5 Site_Specific_3_6 Site_Specific_3_7 Site_Specific_3_8
Site_Specific_4_1 Site_Specific_4_2 Site_Specific_4_3 Site_Specific_4_4 Site_Specific_4_5 Site_Specific_4_6 Site_Specific_4_7
Site_Specific_5_1 Site_Specific_5_2 Site_Specific_5_3 Site_Specific_5_4
Site_Specific_9_1 Site_Specific_9_2 N_Cancer;

do i=1 to 37;
if temp{i}=. then temp{i}=0;
end;drop i;

if Site_Specific_1=1 or Site_Specific_2=1 or Site_Specific_3=1 or Site_Specific_4=1 or Site_Specific_5=1 or Site_Specific_6=1 or Site_Specific_7=1 or Site_Specific_8=1 or Site_Specific_9=1 or Site_Specific_10=1
then Solid=1;else Solid=0;
if Site_Specific_11=1 or Site_Specific_12=1 or Site_Specific_13=1 or Site_Specific_14=1 or Site_Specific_15=1 
then nonSolid=1;else nonSolid=0;

if Solid=1 then CancerGroup=1;
else if nonSolid=1 then CancerGroup=2;
else CancerGroup=3;
run;

* IP;
proc sql;
create table temp2&yr. as
select a.*,b.LOS as LOSIP1, b.numclm as numclmIP1
from temp1&yr. a left join (select * from data.Utilip&yr. where  clm1='Inpatient Hospital (Acute Hospital)') b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp3&yr. as
select a.*,b.LOS as LOSIP2, b.numclm as numclmIP2
from temp2&yr. a left join (select * from data.Utilip&yr. where clm1="Critical Access Hospital (CAH) - Inpatient Services") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp4&yr. as
select a.*,b.LOS as LOSIP3, b.numclm as numclmIP3
from temp3&yr. a left join (select * from data.Utilip&yr. where  clm1='Inpatient Psychiatric Facility (IPF)') b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp5&yr. as
select a.*, b.LOS as LOSIP4, b.numclm as numclmIP4
from temp4&yr. a left join (select * from data.Utilip&yr. where clm1='Long-Term Care Hospital (LTCH)') b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp6&yr. as
select a.*,b.LOS as LOSIP5, b.numclm as numclmIP5
from temp5&yr. a left join (select * from data.Utilip&yr. where clm1='Inpatient Rehabilitation Facility (IRF)') b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp7&yr. as
select a.*,b.LOS as LOSIP6, b.numclm as numclmIP6
from temp6&yr. a left join (select * from data.Utilip&yr. where clm1="Other Inpatient") b
on a.bene_id=b.bene_id
;
quit;

* OP;
proc sql;
create table temp8&yr. as
select a.*,b.numclm as numclmOP
from temp7&yr. a left join  data.Utilop&yr.  b
on a.bene_id=b.bene_id
;
quit;
*/
* carrier;
proc sql;
create table temp9&yr. as
select a.*,b.stdcost as stdcostCar1,b.actual as actualCar1,b.numclm as numclmcar1
from temp8&yr. a left join (select * from data.Utilcarrier&yr.Cancer where clm1="Evaluation AND Management") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp10&yr. as
select a.*,b.stdcost as stdcostCar2,b.actual as actualCar2, b.numclm as numclmcar2
from temp9&yr. a left join (select * from data.Utilcarrier&yr.Cancer where clm1="Procedures") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp11&yr. as
select a.*,b.stdcost as stdcostCar3,b.actual as actualCar3, b.numclm as numclmcar3
from temp10&yr. a left join (select * from data.Utilcarrier&yr.Cancer where clm1="Imaging") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp12&yr. as
select a.*,b.stdcost as stdcostCar4,b.actual as actualCar4, b.numclm as numclmcar4
from temp11&yr. a left join (select * from data.Utilcarrier&yr.Cancer where clm1="Tests") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp13&yr. as
select a.*,b.stdcost as stdcostCar5,b.actual as actualCar5,b.numclm as numclmcar5
from temp12&yr. a left join (select * from data.Utilcarrier&yr.Cancer where clm1="Durable Medical Equipment") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp14&yr. as
select a.*,b.stdcost as stdcostCar6,b.actual as actualCar6, b.numclm as numclmcar6
from temp13&yr. a left join (select * from data.Utilcarrier&yr.Cancer where clm1="Other Services") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp15&yr. as
select a.*,b.stdcost as stdcostCar7,b.actual as actualCar7,b.numclm as numclmcar7
from temp14&yr. a left join (select * from data.Utilcarrier&yr.Cancer where clm1="Unclassified") b
on a.bene_id=b.bene_id
;
quit;
 
proc sql;
create table temp16&yr. as
select a.*,b.stdcost as stdcostCar8,b.actual as actualCar8,b.numclm as numclmcar8
from temp15&yr. a left join (select * from data.Utilcarrier&yr.Cancer where clm1="Oncology-Radiation Therapy") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp17&yr. as
select a.*,b.stdcost as stdcostCar9,b.actual as actualCar9,b.numclm as numclmcar9
from temp16&yr. a left join (select * from data.Utilcarrier&yr.Cancer where clm1="Oncology-Other") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp18&yr. as
select a.*,b.stdcost as stdcostCar10,b.actual as actualCar10,b.numclm as numclmcar10
from temp17&yr. a left join (select * from data.Utilcarrier&yr.Cancer where clm1="Chemotherapy") b
on a.bene_id=b.bene_id
;
quit;
 

* HHA;
proc sql;
create table temp19&yr. as
select a.*,b.LOS as LOSHHA, b.numclm as numclmHHA, b.HHAvisit
from temp18&yr. a left join  data.UtilHHA&yr.  b
on a.bene_id=b.bene_id;
quit;
 
* SNF;
proc sql;
create table temp20&yr. as
select a.*, b.LOS as LOSSNF, b.numclm as numclmSNF
from temp19&yr. a left join  data.UtilSNF&yr.  b
on a.bene_id=b.bene_id
;
quit;


* Hospice;
proc sql;
create table temp21&yr. as
select a.*, b.LOS as LOSHospice, b.numclm as numclmHospice
from temp20&yr. a left join  data.UtilHospice&yr.  b
on a.bene_id=b.bene_id
;
quit;

* DME;
proc sql;
create table temp22&yr. as
select a.*,b.numclm as numclmDME
from temp21&yr. a left join  data.UtilDME&yr.  b
on a.bene_id=b.bene_id
;
quit;
 
data temp23&yr. ;
set temp22&yr. ;

array temp {37} 
LOSIP1 LOSIP2 LOSIP3 LOSIP4 LOSIP5 LOSIP6 LOSHHA LOSSNF LOSHospice 
HHAvisit
numclmIP1 numclmIP2 numclmIP3 numclmIP4 numclmIP5 numclmIP6 
numclmOp numclmCar1 numclmCar2 numclmCar3 numclmCar4 numclmCar5 numclmCar6 numclmCar7  numclmCar8 numclmCar9 numclmCar10 
stdcostCar8 stdcostCar9 stdcostCar10 
actualCar8 actualCar9 actualCar10 
numclmHHA numclmSNF numclmHospice numclmDME ;

do i=1 to 37;
 if temp{i}=. then temp{i}=0;
end;drop i;
 

stdcostIP=stdcostIP1+stdcostIP2+stdcostIP3+stdcostIP4+stdcostIP5+stdcostIP6;
actualIP=actualIP1+actualIP2+actualIP3+actualIP4+actualIP5+actualIP6;

stdcostCar=stdcostCar1+stdcostCar2+stdcostCar3+stdcostCar4+stdcostCar5+stdcostCar6+stdcostCar7+stdcostCar8+stdcostCar9+stdcostCar10;
actualCar=actualCar1+actualCar2+actualCar3+actualCar4+actualCar5+actualCar6+actualCar7+actualCar8+actualCar9+actualCar10;

LOSIP=LOSIP1+LOSIP2+LOSIP3+LOSIP4+LOSIP5+LOSIP6;

numclmIP=numclmIP1+numclmIP2+numclmIP3+numclmIP4+numclmIP5+numclmIP6;

numclmCar=numclmCar1+numclmCar2+numclmCar3+numclmCar4+numclmCar5+numclmCar6+numclmCar7+numclmCar8+numclmCar9+numclmCar10;

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
label numclmCar8="Oncology-Radiation Therapy";  
label numclmCar9="Oncology-Other";  
label numclmCar10="Chemotherapy";  
label stdcostCar8="Oncology-Radiation Therapy";  
label stdcostCar9="Oncology-Other";  
label stdcostCar10="Chemotherapy"; 
label actualCar8="Oncology-Radiation Therapy";  
label actualCar9="Oncology-Other";  
label actualCar10="Chemotherapy"; 

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
%bene(yr=2014);



******************************************
All 10%
******************************************;
* Table 3;
%macro util(yr);
 
proc tabulate data=temp23&yr. noseps QMETHOD=P2
;
class   HC10_stdcost  CancerGroup ;
var  
stdcost
stdcostIP stdcostIP1 stdcostIP2 stdcostIP3 stdcostIP4 stdcostIP5 stdcostIP6 
stdcostOp 
stdcostCar stdcostCar1 stdcostCar2 stdcostCar3 stdcostCar4 stdcostCar5 stdcostCar6 stdcostCar7 stdcostCar8 stdcostCar9 stdcostCar10  
stdcostHHA stdcostSNF stdcostHospice stdcostDME stdcostPartD

LOSIP LOSIP1 LOSIP2 LOSIP3 LOSIP4 LOSIP5 LOSIP6 LOSHHA LOSSNF LOSHospice 
HHAvisit
numclmIP numclmIP1 numclmIP2 numclmIP3 numclmIP4 numclmIP5 numclmIP6 
numclmOp 
numclmCar numclmCar1 numclmCar2 numclmCar3 numclmCar4 numclmCar5 numclmCar6 numclmCar7 numclmCar8 numclmCar9 numclmCar10  
numclmHHA numclmSNF numclmHospice numclmDME ;

table (
stdcost
stdcostIP stdcostIP1 stdcostIP2 stdcostIP3 stdcostIP4 stdcostIP5 stdcostIP6 
stdcostOp 
stdcostCar stdcostCar1 stdcostCar2 stdcostCar3 stdcostCar4 stdcostCar5 stdcostCar6 stdcostCar7 stdcostCar8 stdcostCar9 stdcostCar10 
stdcostHHA stdcostSNF stdcostHospice stdcostDME stdcostPartD), 
( HC10_stdcost*(mean median sum) CancerGroup*HC10_stdcost*(mean median sum) all*(mean median sum))/RTS=25;

 
table (
LOSIP LOSIP1 LOSIP2 LOSIP3 LOSIP4 LOSIP5 LOSIP6 LOSHHA LOSSNF LOSHospice), 
(HC10_stdcost*(mean*f=15.4 median sum) CancerGroup*HC10_stdcost*(mean*f=15.4 median sum) all*(mean*f=15.4 median sum))/RTS=25;

table ( 
numclmIP numclmIP1 numclmIP2 numclmIP3 numclmIP4 numclmIP5 numclmIP6 
numclmOp 
numclmCar numclmCar1 numclmCar2 numclmCar3 numclmCar4 numclmCar5 numclmCar6 numclmCar7 numclmCar8 numclmCar9 numclmCar10 
numclmHHA HHAvisit numclmSNF numclmHospice numclmDME), 
(HC10_stdcost*(mean*f=15.4 median sum) CancerGroup*HC10_stdcost*(mean*f=15.4 median  sum) all*(mean*f=15.4 median  sum))/RTS=25;
Keylabel all="All Bene";
 
run;
 

%mend util;
%util(yr=2014);



%macro peruser(var );

data temp242014;
set temp232014;
if &var. ne 0;
run;

proc tabulate data=temp242014 noseps QMETHOD=P2 ;
class HC10_stdcost CancerGroup; 
var &var.;

table &var. ,
(HC10_stdcost*(mean*f=15.4 median sum) CancerGroup*HC10_stdcost*(mean*f=15.4 median  sum) all*(mean*f=15.4 median sum))/RTS=25;
 
Keylabel all="All Beneficiary" 
         ;
run;
%mend peruser;
%peruser(var=stdcostHHA);
%peruser(var=stdcostSNF);
%peruser(var=stdcostHospice);

%peruser(var=LosHHA);
%peruser(var=LosSNF);
%peruser(var=LosHospice);
 
%peruser(var=numclmHHA);
%peruser(var=HHAvisit);
%peruser(var=numclmSNF);
%peruser(var=numclmHospice);



*********************************************
Among Solid Cancers only, top10%
*********************************************;
proc rank data=temp232014 out=temp252014 percent;
where STRCTFLG ne '' and keep=1 and solid=1;
var stdcost;
ranks stdcost_r;
run;

data temp262014;
set temp252014;
if stdcost_r>=90 then HC10_stdcost=1;else HC10_stdcost=0;
proc freq;tables HC10_stdcost/missing;
run;
* Table 3;
%macro util(yr);
 
proc tabulate data=temp26&yr. noseps;
class   HC10_stdcost   ;
var  
stdcost
stdcostIP stdcostIP1 stdcostIP2 stdcostIP3 stdcostIP4 stdcostIP5 stdcostIP6 
stdcostOp 
stdcostCar stdcostCar1 stdcostCar2 stdcostCar3 stdcostCar4 stdcostCar5 stdcostCar6 stdcostCar7 stdcostCar8 stdcostCar9 stdcostCar10  
stdcostHHA stdcostSNF stdcostHospice stdcostDME stdcostPartD

LOSIP LOSIP1 LOSIP2 LOSIP3 LOSIP4 LOSIP5 LOSIP6 LOSHHA LOSSNF LOSHospice 
HHAvisit
numclmIP numclmIP1 numclmIP2 numclmIP3 numclmIP4 numclmIP5 numclmIP6 
numclmOp 
numclmCar numclmCar1 numclmCar2 numclmCar3 numclmCar4 numclmCar5 numclmCar6 numclmCar7 numclmCar8 numclmCar9 numclmCar10  
numclmHHA numclmSNF numclmHospice numclmDME ;

table (
stdcost
stdcostIP stdcostIP1 stdcostIP2 stdcostIP3 stdcostIP4 stdcostIP5 stdcostIP6 
stdcostOp 
stdcostCar stdcostCar1 stdcostCar2 stdcostCar3 stdcostCar4 stdcostCar5 stdcostCar6 stdcostCar7 stdcostCar8 stdcostCar9 stdcostCar10 
stdcostHHA stdcostSNF stdcostHospice stdcostDME stdcostPartD), 
( HC10_stdcost*(mean median sum)  all*(mean median sum))/RTS=25;

 
table (
LOSIP LOSIP1 LOSIP2 LOSIP3 LOSIP4 LOSIP5 LOSIP6 LOSHHA LOSSNF LOSHospice), 
(HC10_stdcost*(mean*f=15.4 median sum) all*(mean*f=15.4 median sum))/RTS=25;

table ( 
numclmIP numclmIP1 numclmIP2 numclmIP3 numclmIP4 numclmIP5 numclmIP6 
numclmOp 
numclmCar numclmCar1 numclmCar2 numclmCar3 numclmCar4 numclmCar5 numclmCar6 numclmCar7 numclmCar8 numclmCar9 numclmCar10 
numclmHHA HHAvisit numclmSNF numclmHospice numclmDME), 
(HC10_stdcost*(mean*f=15.4 median sum) all*(mean*f=15.4 median  sum))/RTS=25;
Keylabel all="All Bene";
 
run;
 

%mend util;
%util(yr=2014);



%macro peruser(var );

data temp272014;
set temp262014;
if &var. ne 0;
run;

proc tabulate data=temp272014 noseps  ;
class HC10_stdcost ; 
var &var.;

table &var. ,
(HC10_stdcost*(mean*f=15.4 median sum) all*(mean*f=15.4 median sum))/RTS=25;
 
Keylabel all="All Beneficiary" 
         ;
run;
%mend peruser;
%peruser(var=stdcostHHA);
%peruser(var=stdcostSNF);
%peruser(var=stdcostHospice);

%peruser(var=LosHHA);
%peruser(var=LosSNF);
%peruser(var=LosHospice);
 
%peruser(var=numclmHHA);
%peruser(var=HHAvisit);
%peruser(var=numclmSNF);
%peruser(var=numclmHospice);
