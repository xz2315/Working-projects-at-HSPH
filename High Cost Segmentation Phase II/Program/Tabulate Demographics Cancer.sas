************************************************************************************
Persistent Medicare HC 2012-2014 -Jose
Demographics  
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
data Patienttotalcost&yr.;
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

data temp1&yr. ;
set Patienttotalcost&yr._r;
 if pct_stdcost>=90  then HC10_stdcost=1;else HC10_stdcost=0;
proc freq;
tables HC10_stdcost /missing;
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
 
 
* CMS CCW;
proc sql;
create table temp4&yr. as
select a.*, 
b.AMI,b.ALZH, b.ALZHDMTA, b.ATRIALFB, b.CATARACT, b.CHRNKIDN, b.COPD, b.CHF  as cc_CHF, b.DIABETES as cc_DIABETES, b.GLAUCOMA, b.HIPFRAC, b.ISCHMCHT,
b.DEPRESSN, b.OSTEOPRS,b.RA_OA, b.STRKETIA, b.CNCRBRST, b.CNCRCLRC, b.CNCRPRST,b.CNCRLUNG,b.CNCRENDM, b.ANEMIA,b.ASTHMA, b.HYPERL, b.HYPERP, b.HYPERT,b.HYPOTH  
from temp3&yr. a left join cc.Mbsf_cc&yr. b
on a.bene_id=b.bene_id;
quit;

* Frailty;
proc sql;
create table temp5&yr. as
select a.*,b.*
from temp4&yr. a left join Frail.Frailty&yr. b
on a.bene_id=b.bene_id;
quit;
 

data temp6&yr.;
length ageC $15.;
set temp5&yr.;
if age<18 then ageC=1;
else if age>=18 and age<65 then ageC=2;
else if age>=65 and age<75 then ageC=3;
else if age>=75 and age<85 then ageC=4;
else if age>=85  then ageC=5;

zip=substr(bene_zip,5)*1;

/* CCW  
0 = Beneficiary did not meet claims criteria or have sufficient FFS coverage
1 = Beneficiary met claims criteria but did not have sufficient FFS coverage
2 = Beneficiary did not meet claims criteria but had sufficient FFS coverage
3 = Beneficiary met claims criteria and had sufficient FFS coverage
*/
array CCW {27}
AMI ALZH ALZHDMTA ATRIALFB CATARACT CHRNKIDN COPD  cc_CHF cc_DIABETES GLAUCOMA HIPFRAC ISCHMCHT 
DEPRESSN OSTEOPRS RA_OA STRKETIA CNCRBRST CNCRCLRC CNCRPRST CNCRLUNG CNCRENDM ANEMIA ASTHMA HYPERL HYPERP HYPERT HYPOTH  
;
do j=1 to 27;
	if ccw{j} in (1,3) then  ccw{j}=1;
	else if ccw{j} in (0,2) then  ccw{j}=0;
end;

array temp {69}  
amiihd amputat arthrit artopen bph cancer chrkid chf cystfib dementia diabetes endo eyedis hemadis hyperlip hyperten 
immunedis ibd liver lung neuromusc osteo paralyt psydis sknulc spchrtarr strk sa thyroid  vascdis  
AMI ALZH ALZHDMTA ATRIALFB CATARACT CHRNKIDN COPD  cc_CHF cc_DIABETES GLAUCOMA HIPFRAC ISCHMCHT 
DEPRESSN OSTEOPRS RA_OA STRKETIA CNCRBRST CNCRCLRC CNCRPRST CNCRLUNG CNCRENDM ANEMIA ASTHMA HYPERL HYPERP HYPERT HYPOTH 
Frailty1 Frailty2 Frailty3 Frailty4 Frailty5 
Frailty6 Frailty7 Frailty8 Frailty9  Frailty10 
Frailty11 Frailty12 ;
do i=1 to 69;
if temp{i}=. then temp{i}=0;
end;
drop i j;

run;
 *Stratify by Zip Code Median Income in Quartiles;
*Stratify by Zip Code Education-Level in Quartiles;
libname zipdata 'C:\data\Data\Census';
proc rank data=zipdata.National_zcta_extract out=temp1 groups=4;
var edu_college ;
ranks edu ;
run;
proc rank data=temp1 out=temp2 groups=4;
var inchh_median ;
ranks mhi ;
run;

data Zip ;
set temp2 ;
MHI =MHI +1;
Edu =Edu +1; 
zip=zip5*1;
keep zip  edu_college inchh_median mhi edu;
label MHI ="Quartiles:Medium House Income";
label Edu ="Quartiles:% Persons with College";
proc freq ;tables MHI Edu /missing;
proc means;var edu_college inchh_median;
run;

proc sql;
create table temp7&yr. as
select a.*,b.*
from temp6&yr. a left join Zip  b
on a.zip =b.zip  ;
quit;

* cancer;
proc sql;
create table temp8&yr. as
select a.*,b.*
from temp7&yr. a left join data.Cancerbene&yr. b
on a.bene_id =b.bene_id  ;
quit;

data temp9&yr.;
set temp8&yr.;
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


%mend bene;
%bene(yr=2014);
 

******************************************
All 10%
******************************************;
* Table 1: Number of Patients;
proc tabulate data=temp92014 noseps;
where  STRCTFLG ne '' and keep=1;
class HC10_stdcost CancerGroup
Site_Specific_1 Site_Specific_2 Site_Specific_3 Site_Specific_4 Site_Specific_5 Site_Specific_6 Site_Specific_7
Site_Specific_8 Site_Specific_9 Site_Specific_10 Site_Specific_11 Site_Specific_12 Site_Specific_13 Site_Specific_14 Site_Specific_15
Site_Specific_3_1 Site_Specific_3_2 Site_Specific_3_3 Site_Specific_3_4 Site_Specific_3_5 Site_Specific_3_6 Site_Specific_3_7 Site_Specific_3_8
Site_Specific_4_1 Site_Specific_4_2 Site_Specific_4_3 Site_Specific_4_4 Site_Specific_4_5 Site_Specific_4_6 Site_Specific_4_7
Site_Specific_5_1 Site_Specific_5_2 Site_Specific_5_3 Site_Specific_5_4
Site_Specific_9_1 Site_Specific_9_2 Solid nonSolid;

table (
Site_Specific_1 Site_Specific_2 Site_Specific_3 Site_Specific_4 Site_Specific_5 Site_Specific_6 Site_Specific_7 Site_Specific_8 Site_Specific_9 
Site_Specific_10 Site_Specific_11 Site_Specific_12 Site_Specific_13 Site_Specific_14 Site_Specific_15
Solid nonSolid
), (HC10_stdcost*(n colpctn) all*(n colpctn))/RTS=25;

Keylabel all="All Bene"
         N="Number of Bene"
		 colpctn="Column Percent";
run;

* Table 2: Demographics Tabulation;
proc tabulate data=temp92014 noseps;
where  STRCTFLG ne '' and keep=1;
class  HC10_stdcost  AgeC Sex Race Dual Died CancerGroup;
var age;
table (n ), (HC10_stdcost CancerGroup*HC10_stdcost  all);

table (Sex Race  Dual Died AgeC ), ( HC10_stdcost*(n colpctn) CancerGroup*HC10_stdcost*(n colpctn) all*(n colpctn))/RTS=25;
Keylabel all="All Bene"
         N="Number of Bene"
		 colpctn="Column Percent";

table (age),( HC10_stdcost*(mean*f=15.5 median) CancerGroup*HC10_stdcost*(mean*f=15.5 median)  all*(mean*f=15.5 median))/RTS=25;

run;
 

* CMS CCW;
proc tabulate data=temp92014 noseps;
where  STRCTFLG ne '' and keep=1;
class HC10_stdcost CancerGroup ;
var AMI ALZH ALZHDMTA ATRIALFB CATARACT CHRNKIDN COPD  cc_CHF cc_DIABETES GLAUCOMA HIPFRAC ISCHMCHT 
DEPRESSN OSTEOPRS RA_OA STRKETIA CNCRBRST CNCRCLRC CNCRPRST CNCRLUNG CNCRENDM ANEMIA ASTHMA HYPERL HYPERP HYPERT HYPOTH  ;
 
table (AMI ALZH ALZHDMTA ATRIALFB CATARACT CHRNKIDN COPD  cc_CHF cc_DIABETES GLAUCOMA HIPFRAC ISCHMCHT 
DEPRESSN OSTEOPRS RA_OA STRKETIA CNCRBRST CNCRCLRC CNCRPRST CNCRLUNG CNCRENDM ANEMIA ASTHMA HYPERL HYPERP HYPERT HYPOTH ), 
(HC10_stdcost*(mean*f=15.5 ) CancerGroup*HC10_stdcost*(mean*f=15.5 ) all*(mean*f=15.5 ))/RTS=25;
Keylabel all="All Bene";
 
run;

* ICC;
proc tabulate data=temp92014 noseps;
where  STRCTFLG ne '' and keep=1;
class HC10_stdcost CancerGroup ;
var
amiihd amputat arthrit artopen bph cancer chrkid chf cystfib dementia diabetes endo eyedis hemadis hyperlip hyperten 
immunedis ibd liver lung neuromusc osteo paralyt psydis sknulc spchrtarr strk sa thyroid  vascdis ;
 
table (amiihd amputat arthrit artopen bph cancer chrkid chf cystfib dementia diabetes endo eyedis hemadis hyperlip hyperten 
immunedis ibd liver lung neuromusc osteo paralyt psydis sknulc spchrtarr strk sa thyroid  vascdis ), 
( HC10_stdcost*(mean*f=15.5 ) CancerGroup*HC10_stdcost*(mean*f=15.5 ) all*(mean*f=15.5 ))/RTS=25;
Keylabel all="All Bene";
 
run;

* Frailty;
proc tabulate data=temp92014 noseps;
where  STRCTFLG ne '' and keep=1;
class HC10_stdcost  CancerGroup;
var
Frailty1 Frailty2 Frailty3 Frailty4 Frailty5 Frailty6 Frailty7 Frailty8 Frailty9  Frailty10 Frailty11 Frailty12;
 
table (Frailty1 Frailty2 Frailty3 Frailty4 Frailty5 Frailty6 Frailty7 Frailty8 Frailty9  Frailty10 Frailty11 Frailty12), 
(HC10_stdcost*(mean*f=15.5 ) CancerGroup*HC10_stdcost*(mean*f=15.5 ) all*(mean*f=15.5 ))/RTS=25;
Keylabel all="All Bene";
 
run;

proc tabulate data=temp92014 noseps;
where  STRCTFLG ne '' and keep=1;
class HC10_stdcost  MHI Edu CancerGroup;
table (MHI Edu), 
(HC10_stdcost*(n colpctn) CancerGroup*HC10_stdcost*(n colpctn) all*(n colpctn))/RTS=25;
Keylabel all="All Bene"
         N="Number of Bene"
		 colpctn="Column Percent";
run;



*********************************************
Among Solid Cancers only, top10%
*********************************************;
proc rank data=temp92014 out=temp102014 percent;
where STRCTFLG ne '' and keep=1 and solid=1;
var stdcost;
ranks stdcost_r;
run;

data temp112014;
set temp102014;
if stdcost_r>=90 then HC10_stdcost=1;else HC10_stdcost=0;
proc freq;tables HC10_stdcost/missing;
run;
 
* Table 1: Number of Patients;
proc tabulate data=temp112014 noseps;
class HC10_stdcost CancerGroup
Site_Specific_1 Site_Specific_2 Site_Specific_3 Site_Specific_4 Site_Specific_5 Site_Specific_6 Site_Specific_7
Site_Specific_8 Site_Specific_9 Site_Specific_10 Site_Specific_11 Site_Specific_12 Site_Specific_13 Site_Specific_14 Site_Specific_15
Site_Specific_3_1 Site_Specific_3_2 Site_Specific_3_3 Site_Specific_3_4 Site_Specific_3_5 Site_Specific_3_6 Site_Specific_3_7 Site_Specific_3_8
Site_Specific_4_1 Site_Specific_4_2 Site_Specific_4_3 Site_Specific_4_4 Site_Specific_4_5 Site_Specific_4_6 Site_Specific_4_7
Site_Specific_5_1 Site_Specific_5_2 Site_Specific_5_3 Site_Specific_5_4
Site_Specific_9_1 Site_Specific_9_2 Solid nonSolid;

table (
Site_Specific_1 Site_Specific_2 Site_Specific_3 Site_Specific_4 Site_Specific_5 Site_Specific_6 Site_Specific_7 Site_Specific_8 Site_Specific_9 
Site_Specific_10 Site_Specific_11 Site_Specific_12 Site_Specific_13 Site_Specific_14 Site_Specific_15
Solid nonSolid
), (HC10_stdcost*(n colpctn) all*(n colpctn))/RTS=25;

Keylabel all="All Bene"
         N="Number of Bene"
		 colpctn="Column Percent";
run;

* Table 2: Demographics Tabulation;
proc tabulate data=temp112014 noseps;
class  HC10_stdcost  AgeC Sex Race Dual Died ;
var age;
table (n ), (HC10_stdcost all);

table (Sex Race  Dual Died AgeC ), ( HC10_stdcost*(n colpctn)  all*(n colpctn))/RTS=25;
Keylabel all="All Bene"
         N="Number of Bene"
		 colpctn="Column Percent";

table (age),( HC10_stdcost*(mean*f=15.5 median) all*(mean*f=15.5 median))/RTS=25;

run;
 

* CMS CCW;
proc tabulate data=temp112014 noseps;
class HC10_stdcost CancerGroup ;
var AMI ALZH ALZHDMTA ATRIALFB CATARACT CHRNKIDN COPD  cc_CHF cc_DIABETES GLAUCOMA HIPFRAC ISCHMCHT 
DEPRESSN OSTEOPRS RA_OA STRKETIA CNCRBRST CNCRCLRC CNCRPRST CNCRLUNG CNCRENDM ANEMIA ASTHMA HYPERL HYPERP HYPERT HYPOTH  ;
 
table (AMI ALZH ALZHDMTA ATRIALFB CATARACT CHRNKIDN COPD  cc_CHF cc_DIABETES GLAUCOMA HIPFRAC ISCHMCHT 
DEPRESSN OSTEOPRS RA_OA STRKETIA CNCRBRST CNCRCLRC CNCRPRST CNCRLUNG CNCRENDM ANEMIA ASTHMA HYPERL HYPERP HYPERT HYPOTH ), 
(HC10_stdcost*(mean*f=15.5 ) all*(mean*f=15.5 ))/RTS=25;
Keylabel all="All Bene";
 
run;

* ICC;
proc tabulate data=temp112014 noseps;
class HC10_stdcost CancerGroup ;
var
amiihd amputat arthrit artopen bph cancer chrkid chf cystfib dementia diabetes endo eyedis hemadis hyperlip hyperten 
immunedis ibd liver lung neuromusc osteo paralyt psydis sknulc spchrtarr strk sa thyroid  vascdis ;
 
table (amiihd amputat arthrit artopen bph cancer chrkid chf cystfib dementia diabetes endo eyedis hemadis hyperlip hyperten 
immunedis ibd liver lung neuromusc osteo paralyt psydis sknulc spchrtarr strk sa thyroid  vascdis ), 
( HC10_stdcost*(mean*f=15.5 ) all*(mean*f=15.5 ))/RTS=25;
Keylabel all="All Bene";
 
run;

* Frailty;
proc tabulate data=temp112014 noseps;
class HC10_stdcost  CancerGroup;
var
Frailty1 Frailty2 Frailty3 Frailty4 Frailty5 Frailty6 Frailty7 Frailty8 Frailty9  Frailty10 Frailty11 Frailty12;
 
table (Frailty1 Frailty2 Frailty3 Frailty4 Frailty5 Frailty6 Frailty7 Frailty8 Frailty9  Frailty10 Frailty11 Frailty12), 
(HC10_stdcost*(mean*f=15.5 ) all*(mean*f=15.5 ))/RTS=25;
Keylabel all="All Bene";
 
run;

proc tabulate data=temp112014 noseps;

class HC10_stdcost  MHI Edu CancerGroup;
table (MHI Edu), 
(HC10_stdcost*(n colpctn) all*(n colpctn))/RTS=25;
Keylabel all="All Bene"
         N="Number of Bene"
		 colpctn="Column Percent";
run;
