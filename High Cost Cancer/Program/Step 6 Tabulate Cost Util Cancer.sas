************************************************************************************
Persistent Medicare HC 2012-2014 -Jose
Cost and Util  
Xiner Zhou
3/16/2017
************************************************************************************;
libname data 'D:\Projects\High Cost Segmentation Phase II\Data';
libname denom 'D:\Data\Medicare\Denominator';
libname stdcost 'D:\Data\Medicare\StdCost\Data';
libname frail 'D:\Projects\Medicare\Frailty Indicator';
libname cc 'D:\Data\Medicare\MBSF CC';
libname seg 'D:\Projects\High_Cost_Segmentation\Data';
libname icc 'D:\Data\Medicare\Chronic Condition';

*********************************************
Table 3: Among Solid Cancers only, top10%
*********************************************;
* IP;
proc sql;
create table temp1 as
select a.*,b.LOS as LOSIP1, b.numclm as numclmIP1
from data.CancerHCsample2014  a left join (select * from data.Utilip2014 where  clm1='Inpatient Hospital (Acute Hospital)') b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp2 as
select a.*,b.LOS as LOSIP2, b.numclm as numclmIP2
from temp1 a left join (select * from data.Utilip2014 where clm1="Critical Access Hospital (CAH) - Inpatient Services") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp3 as
select a.*,b.LOS as LOSIP3, b.numclm as numclmIP3
from temp2 a left join (select * from data.Utilip2014 where  clm1='Inpatient Psychiatric Facility (IPF)') b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp4 as
select a.*, b.LOS as LOSIP4, b.numclm as numclmIP4
from temp3 a left join (select * from data.Utilip2014 where clm1='Long-Term Care Hospital (LTCH)') b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp5 as
select a.*,b.LOS as LOSIP5, b.numclm as numclmIP5
from temp4 a left join (select * from data.Utilip2014 where clm1='Inpatient Rehabilitation Facility (IRF)') b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp6 as
select a.*,b.LOS as LOSIP6, b.numclm as numclmIP6
from temp5 a left join (select * from data.Utilip2014 where clm1="Other Inpatient") b
on a.bene_id=b.bene_id
;
quit;

* OP;
proc sql;
create table temp7 as
select a.*,b.numclm as numclmOP
from temp6 a left join  data.Utilop2014  b
on a.bene_id=b.bene_id
;
quit;
 
* carrier;
proc sql;
create table temp8 as
select a.*,b.stdcost as stdcostCar1,b.actual as actualCar1,b.numclm as numclmcar1
from temp7 a left join (select * from data.Utilcarrier2014Cancer where clm1="Evaluation AND Management") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp9 as
select a.*,b.stdcost as stdcostCar2,b.actual as actualCar2, b.numclm as numclmcar2
from temp8 a left join (select * from data.Utilcarrier2014Cancer where clm1="Procedures") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp10 as
select a.*,b.stdcost as stdcostCar3,b.actual as actualCar3, b.numclm as numclmcar3
from temp9 a left join (select * from data.Utilcarrier2014Cancer where clm1="Imaging") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp11 as
select a.*,b.stdcost as stdcostCar4,b.actual as actualCar4, b.numclm as numclmcar4
from temp10 a left join (select * from data.Utilcarrier2014Cancer where clm1="Tests") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp12 as
select a.*,b.stdcost as stdcostCar5,b.actual as actualCar5,b.numclm as numclmcar5
from temp11 a left join (select * from data.Utilcarrier2014Cancer where clm1="Durable Medical Equipment") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp13 as
select a.*,b.stdcost as stdcostCar6,b.actual as actualCar6, b.numclm as numclmcar6
from temp12 a left join (select * from data.Utilcarrier2014Cancer where clm1="Other Services") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp14 as
select a.*,b.stdcost as stdcostCar7,b.actual as actualCar7,b.numclm as numclmcar7
from temp13 a left join (select * from data.Utilcarrier2014Cancer where clm1="Unclassified") b
on a.bene_id=b.bene_id
;
quit;
 
proc sql;
create table temp15 as
select a.*,b.stdcost as stdcostCar8,b.actual as actualCar8,b.numclm as numclmcar8
from temp14 a left join (select * from data.Utilcarrier2014Cancer where clm1="Oncology-Radiation Therapy") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp16 as
select a.*,b.stdcost as stdcostCar9,b.actual as actualCar9,b.numclm as numclmcar9
from temp15 a left join (select * from data.Utilcarrier2014Cancer where clm1="Oncology-Other") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp17 as
select a.*,b.stdcost as stdcostCar10,b.actual as actualCar10,b.numclm as numclmcar10
from temp16 a left join (select * from data.Utilcarrier2014Cancer where clm1="Chemotherapy") b
on a.bene_id=b.bene_id
;
quit;
 

* HHA;
proc sql;
create table temp18 as
select a.*,b.LOS as LOSHHA, b.numclm as numclmHHA, b.HHAvisit
from temp17 a left join  data.UtilHHA2014  b
on a.bene_id=b.bene_id;
quit;
 
* SNF;
proc sql;
create table temp19 as
select a.*, b.LOS as LOSSNF, b.numclm as numclmSNF
from temp18 a left join  data.UtilSNF2014  b
on a.bene_id=b.bene_id
;
quit;


* Hospice;
proc sql;
create table temp20 as
select a.*, b.LOS as LOSHospice, b.numclm as numclmHospice
from temp19 a left join  data.UtilHospice2014  b
on a.bene_id=b.bene_id
;
quit;

* DME;
proc sql;
create table temp21 as
select a.*,b.numclm as numclmDME
from temp20 a left join  data.UtilDME2014  b
on a.bene_id=b.bene_id
;
quit;
 
data temp22 ;
set temp21 ;
* cancer indicator;
if CancerH="NO Cancer" then CancerI=0;
else CancerI=1;

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

array temp2 {24}
stdcostIP stdcostIP1 stdcostIP2 stdcostIP3 stdcostIP4 stdcostIP5 stdcostIP6 
stdcostOp 
stdcostCar stdcostCar1 stdcostCar2 stdcostCar3 stdcostCar4 stdcostCar5 stdcostCar6 stdcostCar7 stdcostCar8 stdcostCar9 stdcostCar10 
stdcostHHA stdcostSNF stdcostHospice stdcostDME stdcostPartD;

array temp3 {24}
stdcostIPpct stdcostIP1pct stdcostIP2pct stdcostIP3pct stdcostIP4pct stdcostIP5pct stdcostIP6pct 
stdcostOppct 
stdcostCarpct stdcostCar1pct stdcostCar2pct stdcostCar3pct stdcostCar4pct stdcostCar5pct stdcostCar6pct stdcostCar7pct stdcostCar8pct stdcostCar9pct stdcostCar10pct 
stdcostHHApct stdcostSNFpct stdcostHospicepct stdcostDMEpct stdcostPartDpct;
do i=1 to 24;
if stdcost=0 then temp3{i}=0;
else temp3{i}=temp2{i}/stdcost;
end;drop i;

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
 


******************************************
All 10%
******************************************;
* Table 3;
%macro util(yr);
 
proc tabulate data=temp22 noseps QMETHOD=P2
;
class   HC10  CancerI ;
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
( HC10*(mean median sum) CancerI*HC10*(mean median sum) all*(mean median sum))/RTS=25;

 
table (
LOSIP LOSIP1 LOSIP2 LOSIP3 LOSIP4 LOSIP5 LOSIP6 LOSHHA LOSSNF LOSHospice), 
(HC10*(mean*f=15.4 median sum) CancerI*HC10*(mean*f=15.4 median sum) all*(mean*f=15.4 median sum))/RTS=25;

table ( 
numclmIP numclmIP1 numclmIP2 numclmIP3 numclmIP4 numclmIP5 numclmIP6 
numclmOp 
numclmCar numclmCar1 numclmCar2 numclmCar3 numclmCar4 numclmCar5 numclmCar6 numclmCar7 numclmCar8 numclmCar9 numclmCar10 
numclmHHA HHAvisit numclmSNF numclmHospice numclmDME), 
(HC10*(mean*f=15.4 median sum) CancerI*HC10*(mean*f=15.4 median  sum) all*(mean*f=15.4 median  sum))/RTS=25;
Keylabel all="All Bene";
 
run;
 

%mend util;
%util(yr=2014);

* Table 3a : %of total cost and p-value fopr compare HC cancer and HC noncancer;

proc tabulate data=temp22 noseps QMETHOD=P2
;
where HC10=1;
class     CancerI ;
var  
 
stdcostIPpct stdcostIP1pct stdcostIP2pct stdcostIP3pct stdcostIP4pct stdcostIP5pct stdcostIP6pct 
stdcostOppct 
stdcostCarpct stdcostCar1pct stdcostCar2pct stdcostCar3pct stdcostCar4pct stdcostCar5pct stdcostCar6pct stdcostCar7pct
stdcostCar8pct stdcostCar9pct stdcostCar10pct  
stdcostHHApct stdcostSNFpct stdcostHospicepct stdcostDMEpct stdcostPartDpct

  ;

table (
stdcostIPpct stdcostIP1pct stdcostIP2pct stdcostIP3pct stdcostIP4pct stdcostIP5pct stdcostIP6pct 
stdcostOppct 
stdcostCarpct stdcostCar1pct stdcostCar2pct stdcostCar3pct stdcostCar4pct stdcostCar5pct stdcostCar6pct stdcostCar7pct
stdcostCar8pct stdcostCar9pct stdcostCar10pct  
stdcostHHApct stdcostSNFpct stdcostHospicepct stdcostDMEpct stdcostPartDpct
), 
(  CancerI*(mean  ) )/RTS=25;

  
Keylabel all="All Bene";
 
run;
 
  * p-values: prevelence of cancer : hc vs non-hc;
%macro p(var);
 
proc anova data=temp22;
class CancerI;
model &var.=CancerI;
run;
%mend;
%p(var=stdcost );
%p(var=stdcostOppct  );
%p(var=stdcostPartDpct);
%p(var=stdcostIPpct);
%p(var=stdcostSNFpct);
%p(var=stdcostHHApct);
%p(var=stdcostHospicepct);
%p(var=stdcostDMEpct);
%p(var=LOSIP1);
%p(var=LOSHHA);
%p(var=LOSSNF );
%p(var=LOSHospice);



%macro peruser(var );

data temp23;
set temp22;
if &var. ne 0;
run;

proc tabulate data=temp23 noseps QMETHOD=P2 ;
class HC10  CancerI; 
var &var.;

table &var. ,
(HC10*(mean*f=15.4 median sum) CancerI*HC10*(mean*f=15.4 median  sum) all*(mean*f=15.4 median sum))/RTS=25;
 
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
 
proc tabulate data=temp262014 noseps;
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
