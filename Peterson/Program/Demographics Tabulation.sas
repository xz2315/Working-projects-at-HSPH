*****************************************
Demographics Tabulation
Xiner Zhou
1/6/2016
*****************************************;
libname MMleads 'C:\data\Data\MMLEADS\Data';
libname data 'C:\data\Projects\Peterson\Data-XZ';
libname denom 'C:\data\Data\Medicare\Denominator';

data Sample2010;
set data.Sample2010;
N_CC=N_MajorCC + N_MinorCC;
N_CC1=N_MajorCC1 + N_MinorCC;

if N_MajorCC in (0) then N_MajorCC_C=1;
else if N_MajorCC in (1,2) then N_MajorCC_C=2;
else if N_MajorCC in (3,4,5) then N_MajorCC_C=3;
else if N_MajorCC in (6,7,8) then N_MajorCC_C=4;

if N_MajorCC1 in (0) then N_MajorCC1_C=1;
else if N_MajorCC1 in (1,2) then N_MajorCC1_C=2;
else if N_MajorCC1 in (3,4,5) then N_MajorCC1_C=3;
else if N_MajorCC1 in (6,7) then N_MajorCC1_C=4;

if N_MinorCC in (0) then N_MinorCC_C=1;
else if N_MinorCC in (1,2,3) then N_MinorCC_C=2;
else if N_MinorCC in (4,5,6) then N_MinorCC_C=3;
else if N_MinorCC in (7,8,9,10) then N_MinorCC_C=4;
else if N_MinorCC >=11 then N_MinorCC_C=5;
 
run;


proc tabulate data=Sample2010 noseps  ;
class HC seg4 D_sex D_MEDICARE_RACE region DUAL  E_MS_CD E_BOE ; 

 
table (D_sex="Gender" D_MEDICARE_RACE="Race" region="Home state region" 
DUAL="Dual Status" E_MS_CD="Medicare status code" E_BOE="Medicaid Basis of Eligibility"
),(HC="10% High Cost Patients"*(n colpctn)  seg4="seg4mentation"*(n colpctn) seg4="seg4mentation"*HC*(n colpctn) all*(n colpctn))/RTS=25;

Keylabel all="All Dual Eligible"
         N="Number of Beneficiary"
		 colpctn="Column Percent";
/*
table  (step="Selection" D_sex="Gender"),(n colpctn) /RTS=25;*row, col; * var1 * var2: var2 nested in var1;
table step*FIVEPCT2009,D_Age*(mean*f=7.2 min*f=7.2 max);

keylabel all="total"
mean="average"
std="Standard Deviation";
*/
format region region_. D_MEDICARE_RACE $race_. E_MS_CD $E_MS_CD_. E_BOE $E_BOE_.; 
run;


proc tabulate data=sample2010 noseps;
class HC seg4;
var D_Age N_Frailty N_CC ;  
table (D_Age="Age" N_Frailty="N.of Frailty Indicators" N_CC="N.of Chronic Conditions"),
      (HC="10% High Cost Patients"*(mean*f=15.5 median)    seg4="seg4mentation"*(mean*f=15.5  median) seg4="seg4mentation"*HC*(mean*f=15.5  median) all*(mean*f=15.5  median) )/RTS=25;
run;

*Major CC and Minor CC Category;
proc tabulate data=sample2010 noseps;
class HC seg4 N_MajorCC_C N_MinorCC_C;

table (N_MajorCC_C="N.of Major Chronic Condition" N_MinorCC_C="N.of Minor Chronic Condition"
),(HC="10% High Cost Patients"*(n colpctn)   seg4="seg4mentation"*(n colpctn) seg4="seg4mentation"*HC*(n colpctn) all*(n colpctn))/RTS=25;

Keylabel all="All Dual Eligible"
         N="Number of Beneficiary"
		 colpctn="Column Percent";
format N_MajorCC_C N_MajorCC_C_.  N_MinorCC_C N_MinorCC_C_.;
run;

*Frailty;
proc tabulate data=sample2010 noseps   ;
class HC seg4 Frailty1 Frailty2 Frailty3 Frailty4 Frailty5 Frailty6 Frailty7 Frailty8 Frailty9 Frailty10 Frailty11 Frailty12;

table (Frailty1 Frailty2 Frailty3 Frailty4 Frailty5 Frailty6 Frailty7 Frailty8 Frailty9 Frailty10 Frailty11 Frailty12
),(HC="10% High Cost Patients"*(n colpctn)   seg4="seg4mentation"*(n colpctn) seg4="seg4mentation"*HC*(n colpctn) all*(n colpctn))/RTS=25;

Keylabel all="All Dual Eligible"
         N="Number of Beneficiary"
		 colpctn="Column Percent";

run;
*CC;
proc tabulate data=sample2010 noseps   ;
class HC seg4  
amiihd  chrkid  chf  dementia  lung  psydis  strk  spchrtarr 
amputat  arthrit  artopen  bph  cancer  diabetes  endo  eyedis  
hemadis  hyperlip  hyperten  immunedis  ibd  liver  neuromusc  osteo  
paralyt  sknulc  sa  thyroid  vascdis;

table ( 
amiihd  chrkid  chf  dementia  lung  psydis  strk  spchrtarr 
amputat  arthrit  artopen  bph  cancer  diabetes  endo  eyedis  
hemadis  hyperlip  hyperten  immunedis  ibd  liver  neuromusc  osteo  
paralyt  sknulc  sa  thyroid  vascdis
),(HC="10% High Cost Patients"*(n colpctn)   seg4="seg4mentation"*(n colpctn) seg4="seg4mentation"*HC*(n colpctn) all*(n colpctn))/RTS=25;

Keylabel all="All Dual Eligible"
         N="Number of Beneficiary"
		 colpctn="Column Percent";

run;


