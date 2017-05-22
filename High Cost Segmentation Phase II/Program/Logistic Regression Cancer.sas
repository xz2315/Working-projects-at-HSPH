****************************************************************************
Logistic regression model: does cancer diagnosis drive high cost?
The model is :
HC(Yes/No)=Any Cancers(Yes/No)+ patients characteristics + inhouse CC, right?

Xiner Zhou
1/9/2017
****************************************************************************;

libname data 'I:\Projects\High Cost Segmentation Phase II\Data';
libname denom 'C:\data\Data\Medicare\Denominator';
libname stdcost 'C:\data\Data\Medicare\StdCost\Data';
libname frail 'I:\Data\Medicare\Frailty Indicator';
libname cc 'C:\data\Data\Medicare\MBSF CC';
libname seg 'C:\data\Projects\High_Cost_Segmentation\Data';
libname icc 'C:\data\Data\Medicare\Chronic Condition';
 

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

 
* Demographics: Dual status ;
proc sql;
create table temp2&yr. as
select a.*,case when b.BUYIN_MO>0 then 1 else 0 end as Dual 
from temp1&yr. a left join denom.dnmntr&yr. b
on a.bene_id=b.bene_id;
quit;

* In-house Chronic Condition; 
proc sql;
create table temp3&yr. as
select a.*,b.*
from temp2&yr. a left join icc.CC&yr. b
on a.bene_id=b.bene_id;
quit;


data temp4&yr.;
set temp3&yr.;
 
array temp {30}  
amiihd amputat arthrit artopen bph 
cancer chrkid chf cystfib dementia 
diabetes endo eyedis hemadis hyperlip 
hyperten immunedis ibd liver lung 
neuromusc osteo paralyt psydis sknulc 
spchrtarr strk sa thyroid  vascdis  ;
do i=1 to 30;
if temp{i}=. then temp{i}=0;
end;
drop i j;

run;



%mend bene;
%bene(yr=2014);

proc genmod data=temp42014 descending;
where race ne '0' and sex ne '0';
class HC10_stdcost Solid(ref='0') 
amiihd(ref='0') amputat(ref='0') arthrit(ref='0') artopen(ref='0') bph(ref='0') 
cancer(ref='0') chrkid(ref='0') chf(ref='0') cystfib(ref='0') dementia(ref='0') 
diabetes(ref='0') endo(ref='0') eyedis(ref='0') hemadis(ref='0') hyperlip(ref='0') 
hyperten(ref='0') immunedis(ref='0') ibd(ref='0') liver(ref='0') lung(ref='0') 
neuromusc(ref='0') osteo(ref='0') paralyt(ref='0') psydis(ref='0') sknulc(ref='0') 
spchrtarr(ref='0') strk(ref='0') sa(ref='0') thyroid(ref='0')  vascdis(ref='0')
sex(ref='1') race(ref='1') dual(ref='0')
;
model HC10_stdcost=Solid age sex race dual
amiihd amputat arthrit artopen bph 
cancer chrkid chf cystfib dementia 
diabetes endo eyedis hemadis hyperlip 
hyperten immunedis ibd liver lung 
neuromusc osteo paralyt psydis sknulc 
spchrtarr strk sa thyroid  vascdis  /   dist = bin
                           link = logit
                           lrci;
estimate "O.R. Cancer1-10 vs No" Solid 1 -1 / exp;
run;

