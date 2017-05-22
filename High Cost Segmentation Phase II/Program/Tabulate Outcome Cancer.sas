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
libname pqi 'I:\Projects\Scorecard\data';

* cancer;
proc sql;
create table temp1 as
select a.*,b.*
from stdcost.Patienttotalcost2014 a left join data.Cancerbene2014 b
on a.bene_id =b.bene_id  ;
quit;

data temp2;
set temp1;
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


if death_dt ne . then died=1;else died=0;
if fullAB =1 and HMO =0 and State_CD*1 ne 40 and State_CD*1>=1 and State_CD*1<=53 then keep=1;else keep=0;
if STRCTFLG ne '' and keep=1 and solid=1 ;

run;

proc rank data=temp2 out=temp3 percent;
var stdcost;
ranks stdcost_r;
run;

data temp4;
set temp3;
if stdcost_r>=90 then HC10_stdcost=1;else HC10_stdcost=0;
proc freq;tables HC10_stdcost/missing;
run;


