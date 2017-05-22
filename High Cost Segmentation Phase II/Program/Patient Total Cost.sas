*******************************
Phase II of High-Need, High Cost Patient Segmentation: 
Understanding Who Becomes and Remains High-Cost/High Need Over Time 
and the Association with Mental Health Conditions
3/16/2017
*******************************;
libname denom 'D:\Data\Medicare\Denominator';
libname stdcost 'D:\Data\Medicare\StdCost\Data';
libname partD 'D:\Data\Medicare\PartD';
libname denom1 'D:\Data\Medicare\Denominator';
 

%macro sumcost(yr);

data bene&yr.; 
set denom.dnmntr&yr.;   
* test enrollment for enrollees who died during year ;
death_month=month(death_DT);
if death_month ne . then do ;
fullAB = (A_MO_CNT >= death_month and B_MO_CNT >= death_month) ;
end;
* test enrollment for those who aged in during year ;
else if age =65 then do ;
aged_in_month = min((12 - month(BENE_DOB)+1), 1) ;
fullAB = (A_MO_CNT >= aged_in_month and B_MO_CNT >= aged_in_month) ;
end;
* all else ;
else do ;
fullAB = (A_MO_CNT = 12 and B_MO_CNT = 12) ;
end;

 
if hmo_mo=0 then HMO=0;else HMO =1;

/*
if fullAB =1 and HMO =0 and DEATH_DT=. and State_CD*1 ne 40 and State_CD*1>=1 and State_CD*1<=53 then keep=1;else keep=0; 
*/
keep BENE_ID State_CD CNTY_CD BENE_ZIP Age BENE_DOB Race Sex  A_MO_CNT B_MO_CNT fullAB hmo_mo HMO  STRCTFLG DEATH_DT; 
 
run;  

* IP;
data IP&yr._1;
length clm clm2 $150.;
set stdcost.Ipclmsstdcost&yr.;
 
clm="Inpatient Claims";
if clm_type in ('60','61') and substr(provider,3,1)='0'  then clm2='Inpatient Hospital (Acute Hospital)';
else if clm_type in ('60','61') and substr(provider,3,2)='13' then clm2="Critical Access Hospital (CAH) - Inpatient Services"; 
else if clm_type in ('60','61') and (substr(provider,3,2) in ('40','41','42','43','44') or substr(provider,3,1) in ('M','S')) then clm2='Inpatient Psychiatric Facility (IPF)';
else if clm_type in ('60','61') and substr(provider,3,2) in ('20','21','22') then clm2='Long-Term Care Hospital (LTCH)';
else if clm_type in ('60','61') and substr(provider,3,4)*1>=3025 and substr(provider,3,4)*1<=3099 then clm2='Inpatient Rehabilitation Facility (IRF)';
else clm2="Other Inpatient";

if actual<=0 then do;stdcost=0;actual=0;end;

keep bene_id clm clm2 actual stdcost;
proc sort ;by bene_id clm2;
run;

proc sql;
create table IP&yr._2 as
select bene_id, clm, clm2, sum(actual) as actual, sum(stdcost) as stdcost
from IP&yr._1 
group by bene_id, clm2;
quit;

proc sort data=IP&yr._2 nodupkey;by bene_id clm2;run;

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

keep bene_id clm  actual stdcost;
proc sort ;by bene_id  ;
run;

proc sql;
create table OP&yr._2 as
select bene_id, clm,  sum(actual) as actual, sum(stdcost) as stdcost
from OP&yr._1 
group by bene_id ;
quit;

proc sort data=OP&yr._2 nodupkey;by bene_id  ;run;

* Car;
data car&yr._1;
length clm clm2 $150.;
set stdcost.Carrclmslinesstdcost&yr.;
 
clm="Carrier Claims";

if substr(BETOS,1,2) in ("M1","M2","M3","M4","M5","M6") then clm2="Evaluation AND Management";
else if substr(BETOS,1,2) in ("P1","P2","P3","P4","P5","P6","P7","P8","P9") then clm2="Procedures";
else if substr(BETOS,1,2) in ("I1","I2","I3","I4") then clm2="Imaging";
else if substr(BETOS,1,2) in ("T1","T2") then clm2="Tests";
else if substr(BETOS,1,2)="D1" then clm2="Durable Medical Equipment";
else if substr(BETOS,1,2)="O1" then clm2="Other Services";
else  clm2="Unclassified";
 
 
if actual<=0 then do;stdcost=0;actual=0;end;

keep bene_id clm clm2 actual stdcost;
proc sort ;by bene_id clm2;
run;

proc sql;
create table car&yr._2 as
select bene_id, clm, clm2, sum(actual) as actual, sum(stdcost) as stdcost
from car&yr._1 
group by bene_id, clm2;
quit;

proc sort data=car&yr._2 nodupkey;by bene_id clm2;run;

* HHA;
data HHA&yr._1;
length clm  $150.;
set stdcost.Hhaclmsstdcost&yr.;
 
clm="HHA Claims";
 
if actual<=0 then do;stdcost=0;actual=0;end;

keep bene_id clm  actual stdcost;
proc sort ;by bene_id  ;
run;

proc sql;
create table HHA&yr._2 as
select bene_id, clm,  sum(actual) as actual, sum(stdcost) as stdcost
from HHA&yr._1 
group by bene_id ;
quit;

proc sort data=HHA&yr._2 nodupkey;by bene_id  ;run;

* SNF;
data SNF&yr._1;
length clm  $150.;
set stdcost.Snfclmsstdcost&yr.;
 
clm="SNF Claims";
 
if actual<=0 then do;stdcost=0;actual=0;end;

keep bene_id clm  actual stdcost;
proc sort ;by bene_id  ;
run;

proc sql;
create table SNF&yr._2 as
select bene_id, clm,  sum(actual) as actual, sum(stdcost) as stdcost
from SNF&yr._1 
group by bene_id;
quit;

proc sort data=SNF&yr._2 nodupkey;by bene_id  ;run;

 
* Hospice;
data Hospice&yr._1;
length clm  $150.;
%if &yr.=2014 %then %do;
set stdcost.Hspclmslinesstdcost&yr.;
%end;
%else %do;
set stdcost.Hspclmsstdcost&yr.;
%end;
 
 
clm="Hospice Claims";
 
if actual<=0 then do;stdcost=0;actual=0;end;

keep bene_id clm  actual stdcost;
proc sort ;by bene_id ;
run;

proc sql;
create table Hospice&yr._2 as
select bene_id, clm,  sum(actual) as actual, sum(stdcost) as stdcost
from Hospice&yr._1 
group by bene_id ;
quit;

proc sort data=Hospice&yr._2 nodupkey;by bene_id ;run;

* DME;
data DME&yr._1;
length clm  $150.;
%if &yr.=2014 %then %do;
set stdcost.DMEclmslinesstdcost&yr.;
%end;
%else %do;
set stdcost.DMEclmsstdcost&yr.;
%end;
 
 
clm="SNF Claims";
 
if actual<=0 then do;stdcost=0;actual=0;end;

keep bene_id clm  actual stdcost;
proc sort ;by bene_id  ;
run;

proc sql;
create table DME&yr._2 as
select bene_id, clm,  sum(actual) as actual, sum(stdcost) as stdcost
from DME&yr._1 
group by bene_id ;
quit;

proc sort data=DME&yr._2 nodupkey;by bene_id ;run;
 
* PartD;

data PartD&yr._1;
length clm $150.;
set partd.Pdesaf&yr. ;

clm="Part D Drugs";
stdcost=TOTALCST;actual=TOTALCST;
keep bene_id clm actual stdcost;
proc sort;by bene_id;
run;

proc sql;
create table PartD&yr._2 as
select bene_id, clm,  sum(actual) as actual, sum(stdcost) as stdcost
from PartD&yr._1
group by bene_id;
quit;
proc sort data=PartD&yr._2 nodupkey;by bene_id;run;


* Total cost;
proc sql;
create table temp1&yr. as
select a.*,b.stdcost as stdcostIP1, b.actual as actualIP1
from bene&yr. a left join (select * from IP&yr._2 where  clm2='Inpatient Hospital (Acute Hospital)') b
on a.bene_id=b.bene_id
;
quit;
proc means data= temp1&yr. mean ;var stdcostIP1 actualIP1;run;

proc sql;
create table temp2&yr. as
select a.*,b.stdcost as stdcostIP2, b.actual as actualIP2
from temp1&yr. a left join (select * from IP&yr._2 where  clm2="Critical Access Hospital (CAH) - Inpatient Services") b
on a.bene_id=b.bene_id
;
quit;
proc means data= temp2&yr. mean ;var stdcostIP2 actualIP2;run;

proc sql;
create table temp3&yr. as
select a.*,b.stdcost as stdcostIP3, b.actual as actualIP3
from temp2&yr. a left join (select * from IP&yr._2 where  clm2='Inpatient Psychiatric Facility (IPF)') b
on a.bene_id=b.bene_id
;
quit;
proc means data= temp3&yr. mean ;var stdcostIP3 actualIP3;run;

proc sql;
create table temp4&yr. as
select a.*,b.stdcost as stdcostIP4, b.actual as actualIP4
from temp3&yr. a left join (select * from IP&yr._2 where  clm2='Long-Term Care Hospital (LTCH)') b
on a.bene_id=b.bene_id
;
quit;
proc means data= temp4&yr. mean ;var stdcostIP4 actualIP4;run;

proc sql;
create table temp5&yr. as
select a.*,b.stdcost as stdcostIP5, b.actual as actualIP5
from temp4&yr. a left join (select * from IP&yr._2 where  clm2='Inpatient Rehabilitation Facility (IRF)') b
on a.bene_id=b.bene_id
;
quit;
proc means data= temp5&yr. mean ;var stdcostIP5 actualIP5;run;


proc sql;
create table temp6&yr. as
select a.*,b.stdcost as stdcostIP6, b.actual as actualIP6
from temp5&yr. a left join (select * from IP&yr._2 where  clm2="Other Inpatient") b
on a.bene_id=b.bene_id
;
quit;
proc means data= temp6&yr. mean ;var stdcostIP6 actualIP6;run;
 
proc sql;
create table temp7&yr. as
select a.*,b.stdcost as stdcostOP , b.actual as actualOP 
from temp6&yr. a left join OP&yr._2 b
on a.bene_id=b.bene_id;
quit;
proc means data= temp7&yr. mean ;var stdcostOP actualOP;run;
 

proc sql;
create table temp8&yr. as
select a.*,b.stdcost as stdcostcar1 , b.actual as actualcar1
from temp7&yr. a left join (select * from car&yr._2 where clm2="Evaluation AND Management") b
on a.bene_id=b.bene_id
;
quit;
proc means data= temp8&yr. mean ;var stdcostcar1 actualcar1;run;


proc sql;
create table temp9&yr. as
select a.*,b.stdcost as stdcostcar2 , b.actual as actualcar2 
from temp8&yr. a left join (select * from car&yr._2 where clm2="Procedures") b
on a.bene_id=b.bene_id
;
quit;
proc means data= temp9&yr. mean ;var stdcostcar2 actualcar2;run;


proc sql;
create table temp10&yr. as
select a.*,b.stdcost as stdcostcar3 , b.actual as actualcar3
from temp9&yr. a left join (select * from car&yr._2 where clm2="Imaging") b
on a.bene_id=b.bene_id
;
quit;
proc means data= temp10&yr. mean ;var stdcostcar3 actualcar3;run;

proc sql;
create table temp11&yr. as
select a.*,b.stdcost as stdcostcar4 , b.actual as actualcar4 
from temp10&yr. a left join (select * from car&yr._2 where clm2="Tests") b
on a.bene_id=b.bene_id
;
quit;
proc means data= temp11&yr. mean ;var stdcostcar4 actualcar4;run;

proc sql;
create table temp12&yr. as
select a.*,b.stdcost as stdcostcar5 , b.actual as actualcar5 
from temp11&yr. a left join (select * from car&yr._2 where clm2="Durable Medical Equipment") b
on a.bene_id=b.bene_id
;
quit;
proc means data= temp12&yr. mean ;var stdcostcar5 actualcar5;run;

proc sql;
create table temp13&yr. as
select a.*,b.stdcost as stdcostcar6 , b.actual as actualcar6 
from temp12&yr. a left join (select * from car&yr._2 where clm2="Other Services") b
on a.bene_id=b.bene_id
;
quit;
proc means data= temp13&yr. mean ;var stdcostcar6 actualcar6;run;

proc sql;
create table temp14&yr. as
select a.*,b.stdcost as stdcostcar7 , b.actual as actualcar7 
from temp13&yr. a left join (select * from car&yr._2 where clm2="Unclassified") b
on a.bene_id=b.bene_id
;
quit;
proc means data= temp14&yr. mean ;var stdcostcar7 actualcar7;run;

proc sql;
create table temp15&yr. as
select a.*,b.stdcost as stdcostHHA , b.actual as actualHHA
from temp14&yr. a left join HHA&yr._2 b
on a.bene_id=b.bene_id;
quit;
proc means data= temp15&yr. mean ;var stdcostHHA actualHHA;run;

proc sql;
create table temp16&yr. as
select a.*,b.stdcost as stdcostSNF , b.actual as actualSNF
from temp15&yr. a left join SNF&yr._2 b
on a.bene_id=b.bene_id;
quit;
proc means data= temp16&yr. mean ;var stdcostSNF actualSNF;run;

proc sql;
create table temp17&yr. as
select a.*,b.stdcost as stdcostHospice , b.actual as actualHospice
from temp16&yr. a left join Hospice&yr._2 b
on a.bene_id=b.bene_id;
quit;
proc means data= temp17&yr. mean ;var stdcostHospice actualHospice;run;

proc sql;
create table temp18&yr. as
select a.*,b.stdcost as stdcostDME , b.actual as actualDME
from temp17&yr. a left join DME&yr._2 b
on a.bene_id=b.bene_id;
quit;
proc means data= temp18&yr. mean ;var stdcostDME actualDME;run;

proc sql;
create table temp19&yr. as
select a.*,b.stdcost as stdcostPartd , b.actual as actualPartd
from temp18&yr. a left join PartD&yr._2 b
on a.bene_id=b.bene_id;
quit;
proc means data= temp19&yr. mean ;var stdcostPartd actualPartd;run;


data stdcost.PatientTotalCost&yr.;
set temp19&yr.;

array stdcostarray {19} stdcostIP1 stdcostIP2 stdcostIP3 stdcostIP4 stdcostIP5 stdcostIP6 
                 stdcostOP
				 stdcostcar1 stdcostcar2 stdcostcar3 stdcostcar4 stdcostcar5 stdcostcar6 stdcostcar7
                 stdcostHHA
				 stdcostSNF
				 stdcostHospice
				 stdcostDME
                 stdcostPartD;

array actualarray {19} actualIP1 actualIP2 actualIP3 actualIP4 actualIP5 actualIP6 
                 actualOP
				 actualcar1 actualcar2 actualcar3 actualcar4 actualcar5 actualcar6 actualcar7
                 actualHHA
				 actualSNF
				 actualHospice
				 actualDME
                 actualPartD;
do i=1 to 19;
if stdcostarray{i}=. then stdcostarray{i}=0;
if actualarray{i}=. then actualarray{i}=0;
end;
drop i;

stdcostIP=stdcostIP1+stdcostIP2+stdcostIP3+stdcostIP4+stdcostIP5+stdcostIP6;
stdcostcar=stdcostcar1+stdcostcar2+stdcostcar3+stdcostcar4+stdcostcar5+stdcostcar6+stdcostcar7;
actualIP=actualIP1+actualIP2+actualIP3+actualIP4+actualIP5+actualIP6;
actualcar=actualcar1+actualcar2+actualcar3+actualcar4+actualcar5+actualcar6+actualcar7;

stdcost=stdcostIP+stdcostOP+stdcostcar+stdcostHHA+stdcostSNF+stdcostHospice+stdcostDME+stdcostPartD;
actual=actualIP+actualOP+actualcar+actualHHA+actualSNF+actualHospice+actualDME+actualPartD;
 
label stdcostIP1="Inpatient Hospital (Acute Hospital)";
label stdcostIP2="Critical Access Hospital (CAH) - Inpatient Services"; 
label stdcostIP3='Inpatient Psychiatric Facility (IPF)';
label stdcostIP4='Long-Term Care Hospital (LTCH)'; 
label stdcostIP5='Inpatient Rehabilitation Facility (IRF)'; 
label stdcostIP6="Other Inpatient"; 
 

label stdcostcar1="Evaluation AND Management"; 
label stdcostcar2="Procedures"; 
label stdcostcar3="Imaging"; 
label stdcostcar4="Tests"; 
label stdcostcar5="Durable Medical Equipment"; 
label stdcostcar6="Other Services"; 
label stdcostcar7="Unclassified";

label stdcostIP="Total Inpatient Standard Cost";
label stdcostOP="Total Outpatient Standard Cost"; 
label stdcostcar="Total Carrier Standard Cost"; 
label stdcostHHA="Total HHA Standard Cost";
label stdcostSNF="Total SNF Standard Cost";
label stdcostHospice="Total Hospice Standard Cost";
label stdcostDME="Total DME Standard Cost";
label stdcostPartD="Total Part D Drug Standard Cost";

label stdcost="Total Standard Cost";


label actualIP1="Inpatient Hospital (Acute Hospital)";
label actualIP2="Critical Access Hospital (CAH) - Inpatient Services"; 
label actualIP3='Inpatient Psychiatric Facility (IPF)';
label actualIP4='Long-Term Care Hospital (LTCH)'; 
label actualIP5='Inpatient Rehabilitation Facility (IRF)'; 
label actualIP6="Other Inpatient"; 
 

label actualcar1="Evaluation AND Management"; 
label actualcar2="Procedures"; 
label actualcar3="Imaging"; 
label actualcar4="Tests"; 
label actualcar5="Durable Medical Equipment"; 
label actualcar6="Other Services"; 
label actualcar7="Unclassified";

label actualIP="Total Inpatient Actual Cost";
label actualOP="Total Outpatient Actual Cost"; 
label actualcar="Total Carrier Actual Cost"; 
label actualHHA="Total HHA Actual Cost";
label actualSNF="Total SNF Actual Cost";
label actualHospice="Total Hospice Actual Cost";
label actualDME="Total DME Actual Cost";
label actualPartD="Total Part D Drug Actual Cost";

label actual="Total Actual Cost";
run;
* all;
proc means data=stdcost.PatientTotalCost&yr.;   
var stdcost stdcostIP stdcostOP stdcostCar stdcostHHA stdcostSNF stdcostHospice stdcostDME stdcostPartD
    actual actualIP actualOP actualCar actualHHA actualSNF actualHospice actualDME actualPartD;
run;
* ideal sample;
proc means data=stdcost.PatientTotalCost&yr.;   
where  STRCTFLG ne '' and fullAB=1;
var stdcost stdcostIP stdcostOP stdcostCar stdcostHHA stdcostSNF stdcostHospice stdcostDME stdcostPartD
    actual actualIP actualOP actualCar actualHHA actualSNF actualHospice actualDME actualPartD;
run;
* 20% sample;
proc means data=stdcost.PatientTotalCost&yr.;   
where  STRCTFLG ne ''  ;
var stdcost stdcostIP stdcostOP stdcostCar stdcostHHA stdcostSNF stdcostHospice stdcostDME stdcostPartD
    actual actualIP actualOP actualCar actualHHA actualSNF actualHospice actualDME actualPartD;
run;
* full coverage but not 20% sample;
proc means data=stdcost.PatientTotalCost&yr.; 
where  fullAB=1;
var stdcost stdcostIP stdcostOP stdcostCar stdcostHHA stdcostSNF stdcostHospice stdcostDME stdcostPartD
    actual actualIP actualOP actualCar actualHHA actualSNF actualHospice actualDME actualPartD;
run;
* not 20% sample;
proc means data=stdcost.PatientTotalCost&yr.; 
where   STRCTFLG='';
var stdcost stdcostIP stdcostOP stdcostCar stdcostHHA stdcostSNF stdcostHospice stdcostDME stdcostPartD
    actual actualIP actualOP actualCar actualHHA actualSNF actualHospice actualDME actualPartD;
run;
 
%mend sumcost;
%sumcost(yr=2012);
%sumcost(yr=2013);
%sumcost(yr=2014);
 
