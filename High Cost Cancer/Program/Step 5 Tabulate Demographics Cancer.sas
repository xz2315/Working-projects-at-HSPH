************************************************************************************
Persistent Medicare HC 2012-2014 -Jose
Demographics  
Xiner Zhou
12/19/2016
************************************************************************************;
libname data 'D:\Projects\High Cost Segmentation Phase II\Data';
libname denom 'D:\Data\Medicare\Denominator';
libname stdcost 'D:\Data\Medicare\StdCost\Data';
libname frail 'D:\Data\Medicare\Frailty Indicator';
libname cc 'D:\Data\Medicare\MBSF CC';
libname seg 'D:\Projects\High_Cost_Segmentation\Data';
libname icc 'D:\Data\Medicare\Chronic Condition';
libname aco 'D:\data\Medicare\ACO';

* Demographics: Dual status ;
proc sql;
create table temp1 as
select a.*,case when b.BUYIN_MO>0 then 1 else 0 end as Dual 
from data.CancerHCsample2014 a left join denom.dnmntr2014 b
on a.bene_id=b.bene_id;
quit;

* In-house Chronic Condition; 
proc sql;
create table temp2 as
select a.*,b.*
from temp1 a left join icc.CC2014 b
on a.bene_id=b.bene_id;
quit;
 
 
* CMS CCW;
proc sql;
create table temp3 as
select a.*, 
b.AMI,b.ALZH, b.ALZHDMTA, b.ATRIALFB, b.CATARACT, b.CHRNKIDN, b.COPD, b.CHF  as cc_CHF, b.DIABETES as cc_DIABETES, b.GLAUCOMA, b.HIPFRAC, b.ISCHMCHT,
b.DEPRESSN, b.OSTEOPRS,b.RA_OA, b.STRKETIA, b.CNCRBRST, b.CNCRCLRC, b.CNCRPRST,b.CNCRLUNG,b.CNCRENDM, b.ANEMIA,b.ASTHMA, b.HYPERL, b.HYPERP, b.HYPERT,b.HYPOTH  
from temp2 a left join cc.Mbsf_cc2014 b
on a.bene_id=b.bene_id;
quit;

* Frailty;
proc sql;
create table temp4 as
select a.*,b.*
from temp3 a left join Frail.Frailty2014 b
on a.bene_id=b.bene_id;
quit;
 
 
data temp5;
length ageC $15.;
set temp4;
 
if age<18 then ageC=1;
else if age>=18 and age<65 then ageC=2;
else if age>=65 and age<75 then ageC=3;
else if age>=75 and age<85 then ageC=4;
else if age>=85  then ageC=5;

zip=substr(bene_zip,5)*1;

if death_dt ne . then died=1;else died=0;

* cancer indicator;
if CancerH="NO Cancer" then CancerI=0;
else CancerI=1;

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
libname zipdata 'D:\Data\Census';
proc rank data=zipdata.National_zcta_extract out=temp6 groups=4;
var edu_college ;
ranks edu ;
run;
proc rank data=temp6 out=temp7 groups=4;
var inchh_median ;
ranks mhi ;
run;

data Zip ;
set temp7 ;
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
create table temp8 as
select a.*,b.*
from temp5 a left join Zip  b
on a.zip =b.zip  ;
quit;
 
*ACO;
proc sql;
create table temp9 as
select a.*,case when a.bene_id in (select bene_id from aco.bene_aco2014) then 1 else 0 end as ACO,
b.START_DATE as ACO_START_DATE, b.ACO_Name 
from temp8 a left join aco.bene_aco2014 b
on a.bene_id=b.bene_id;
quit;

 
******************************************
All 10%
******************************************;
ods excel file="D:\Projects\High Cost Cancer\table1.xlsx" style=minimal;
* Table 1: Number of Patients;
proc tabulate data=temp9 noseps;
class HC10  CancerH ;

table (cancerH
), (HC10 *(n colpctn) all*(n colpctn))/RTS=25;

Keylabel all="All Bene"
         N="Number of Bene"
		 colpctn="Column Percent";
run;
  ods excel close;
 

  * p-values: prevelence of cancer : hc vs non-hc;
%macro p(var);
data temp10;
set temp9;
if cancerH=&var. then temp=1;else temp=0;
run;
proc freq data=temp10;
tables temp*HC10/nopercent norow  chisq;
run;
%mend;
%p(var="Hierarchy 1 : Lung");
%p(var="Hierarchy 2 : Hematologic mali" );
%p(var="Hierarchy 3 : GI" );
%p(var="Hierarchy 4 : Breast" );
%p(var="Hierarchy 5 : GU" );
%p(var="Hierarchy 6 : Gyn");
%p(var="Hierarchy 7 : H and N" );
%p(var="Hierarchy 8 : Sarcoma" );
%p(var="Hierarchy 9 : Melanoma" );
%p(var="Hierarchy 10: CNS" );
%p(var="Hierarchy 11: Mets & Other" );
 

  ods excel file="D:\Projects\High Cost Cancer\table2.xlsx" style=minimal;

* Table 2: Demographics Tabulation;
proc tabulate data=temp9 noseps;
class  HC10  AgeC Sex Race Dual Died CancerI ACO;
var age;
table (n ), (HC10 CancerI*HC10  all);
table (ACO*n ), (HC10 CancerI*HC10  all);
table (Sex Race  Dual Died Died*ACO AgeC ), ( HC10*(n colpctn) CancerI*HC10*(n colpctn) all*(n colpctn))/RTS=25;
Keylabel all="All Bene"
         N="Number of Bene"
		 colpctn="Column Percent";

table (age),( HC10*(mean*f=15.5 median) CancerI*HC10*(mean*f=15.5 median)  all*(mean*f=15.5 median))/RTS=25;
run;
  ods excel close;

  * p-values;
 proc glm data=temp9;
where HC10=0;
class CancerI ;
model age=CancerI ;
run;

%macro p(var);
data temp10;
set temp9;
where HC10=0;
run;
proc freq data=temp10;
tables &var.*CancerI /nopercent norow  chisq;
run;
%mend;
%p(var=Sex);
%p(var=Race);
%p(var=Dual);
%p(var=Died );
%p(var=MHI);

%p(var=CHRNKIDN);
%p(var=cc_CHF);
%p(var=cc_DIABETES);
%p(var=ISCHMCHT );
%p(var=DEPRESSN);
%p(var=HYPERT );
 





* CMS CCW;
proc tabulate data=temp9 noseps;
class HC10 CancerI ;
var AMI ALZH ALZHDMTA ATRIALFB CATARACT CHRNKIDN COPD  cc_CHF cc_DIABETES GLAUCOMA HIPFRAC ISCHMCHT 
DEPRESSN OSTEOPRS RA_OA STRKETIA CNCRBRST CNCRCLRC CNCRPRST CNCRLUNG CNCRENDM ANEMIA ASTHMA HYPERL HYPERP HYPERT HYPOTH  ;
 
table (AMI ALZH ALZHDMTA ATRIALFB CATARACT CHRNKIDN COPD  cc_CHF cc_DIABETES GLAUCOMA HIPFRAC ISCHMCHT 
DEPRESSN OSTEOPRS RA_OA STRKETIA CNCRBRST CNCRCLRC CNCRPRST CNCRLUNG CNCRENDM ANEMIA ASTHMA HYPERL HYPERP HYPERT HYPOTH ), 
(HC10*(mean*f=15.5 ) CancerI*HC10*(mean*f=15.5 ) all*(mean*f=15.5 ))/RTS=25;
Keylabel all="All Bene";
run;

* ICC;
proc tabulate data=temp9 noseps;
class HC10  CancerI  ;
var
amiihd amputat arthrit artopen bph cancer chrkid chf cystfib dementia diabetes endo eyedis hemadis hyperlip hyperten 
immunedis ibd liver lung neuromusc osteo paralyt psydis sknulc spchrtarr strk sa thyroid  vascdis ;
 
table (amiihd amputat arthrit artopen bph cancer chrkid chf cystfib dementia diabetes endo eyedis hemadis hyperlip hyperten 
immunedis ibd liver lung neuromusc osteo paralyt psydis sknulc spchrtarr strk sa thyroid  vascdis ), 
( HC10*(mean*f=15.5 ) CancerI*HC10*(mean*f=15.5 ) all*(mean*f=15.5 ))/RTS=25;
Keylabel all="All Bene";
 
run;

* Frailty;
proc tabulate data=temp9noseps;
class HC10 CancerI;
var
Frailty1 Frailty2 Frailty3 Frailty4 Frailty5 Frailty6 Frailty7 Frailty8 Frailty9  Frailty10 Frailty11 Frailty12;
 
table (Frailty1 Frailty2 Frailty3 Frailty4 Frailty5 Frailty6 Frailty7 Frailty8 Frailty9  Frailty10 Frailty11 Frailty12), 
(HC10*(mean*f=15.5 ) CancerI*HC10*(mean*f=15.5 ) all*(mean*f=15.5 ))/RTS=25;
Keylabel all="All Bene";
 
run;

proc tabulate data=temp8 noseps;
class HC10  MHI Edu CancerI;
table (MHI Edu), 
(HC10*(n colpctn) CancerI*HC10*(n colpctn) all*(n colpctn))/RTS=25;
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
