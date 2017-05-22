*******************************************
	APCD Demographics Tabulation
******************************************;
libname APCD 'C:\data\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';


%let bymoney=Cost;
%let bymoney=Spending;


data temp;
length N_CC_C1 $5. N_CC_C2 $5. N_CC_C3 $5.;
set APCD.AnalyticData&bymoney.;


N_CC=amiihd+ chrkid+ chf+ dementia+ lung+ psydis+ strk+ spchrtarr 
     +amputat+ arthrit+ artopen+ bph+ cancer+ diabetes+ endo+ eyedis +
                 hemadis+ hyperlip+ hyperten+ immunedis+ ibd+ liver+ neuromusc+ osteo+ 
                 paralyt+ sknulc+ sa+ thyroid+ vascdis;
if N_MajorCC=0 then N_MajorCC_C=1;
else if N_MajorCC in (1,2) then N_MajorCC_C=2;
else if N_MajorCC in (3,4,5) then N_MajorCC_C=3;
else if N_MajorCC in (6,7,8) then N_MajorCC_C=4;

if N_MinorCC=0 then N_MinorCC_C=1;
else if N_MinorCC in (1,2,3) then N_MinorCC_C=2;
else if N_MinorCC in (4,5,6) then N_MinorCC_C=3;
else if N_MinorCC in (7,8,9,10) then N_MinorCC_C=4;
else if N_MinorCC>=11 then N_MinorCC_C=5;
 
if N_CC in (0) then N_CC_C1='0';
else if N_CC in (1,2) then N_CC_C1='1-2';
else if N_CC in (3,4) then N_CC_C1='3-4';
else if N_CC in (5,6) then N_CC_C1='5-6';
else if N_CC in (7,8) then N_CC_C1='7-8';
else if N_CC in (9,10) then N_CC_C1='9-10';
else N_CC_C1='>10';
 
if N_CC in (0) then N_CC_C2='0';
else if N_CC in (1,2,3) then N_CC_C2='1-3';
else if N_CC in (4,5,6) then N_CC_C2='4-6';
else if N_CC in (7,8,9) then N_CC_C2='7-9';
else if N_CC in (10,11,12) then N_CC_C2='10-12';
else N_CC_C2='>=12';

if N_CC in (0) then N_CC_C3='0';
else if N_CC in (1,2,3,4) then N_CC_C3='1-4';
else if N_CC in (5,6,7,8) then N_CC_C3='5-8';
else if N_CC in (9,10,11,12) then N_CC_C3='9-12';
else N_CC_C3='>=12';

run;



 *******************High Cost**************************;

proc tabulate data=temp noseps  ;
class highcost Seg2011 gender race ethnicity hispanic Type OrgID AgeGroup IncomeRank; 

table (gender="Gender" Race="Race" Ethnicity="Ethnicity" Hispanic="Hispanic" Type="Medicaid/Medicaid Managed Care/Private" OrgID="Payer" AgeGroup="Age Group" 
IncomeRank="Income Rank based on 2012 County Median House Income"
),(highcost="10% High Cost Patients"*(n colpctn)  highcost="10% High Cost Patients"*Type*(n colpctn) Type*(n colpctn) 
   /*Seg2011="Segments"*(n colpctn)  Seg2011="Segments"*Type*(n colpctn) Seg2011="Segments"*highcost="10% High Cost Patients"*(n colpctn)*/
   all*(n colpctn))/RTS=25;

Keylabel all="All Beneficiary"
         N="Number of Beneficiary"
		 colpctn="Column Percent";

format IncomeRank IncomeRank_. OrgID OrgID_. AgeGroup AgeGroup_.; 
run;




proc tabulate data=temp noseps;
class highcost Seg2011 Type;
var Age N_Frailty N_CC ;  
table (Age="Age" N_Frailty="N.of Frailty Indicators" N_CC="N.of Chronic Conditions"),
      (highcost="10% High Cost Patients"*(mean*f=15.5 median)  highcost="10% High Cost Patients"*Type*(mean*f=15.5 median) Type*(mean*f=15.5 median) 
       /*Seg2011="Segments"*(mean*f=15.5 median)  Seg2011="Segments"*Type*(mean*f=15.5 median) Seg2011="Segments"*highcost="10% High Cost Patients"*(mean*f=15.5 median) */
      all*(mean*f=15.5 median) )/RTS=25;
	  Keylabel all="All Beneficiary"
         N="Number of Beneficiary"
		 colpctn="Column Percent";
run;

*Major CC and Minor CC Category;
proc tabulate data=temp noseps;
class highcost Seg2011 Type N_CC_C1 N_CC_C2 N_CC_C3 ;

table (N_CC_C1 N_CC_C2 N_CC_C3
),(highcost="10% High Cost Patients"*(n colpctn)  highcost="10% High Cost Patients"*Type*(n colpctn) Type*(n colpctn) 
/*Seg2011="Segments"*(n colpctn)  Seg2011="Segments"*Type*(n colpctn) Seg2011="Segments"*highcost="10% High Cost Patients"*(n colpctn)*/
all*(n colpctn))/RTS=25;

Keylabel all="All Beneficiary"
         N="Number of Beneficiary"
		 colpctn="Column Percent";
 
run;

*Frailty;
proc tabulate data=temp noseps  ;
class highcost Seg2011 Type Frailty1 Frailty2 Frailty3 Frailty4 Frailty5 Frailty6 Frailty7 Frailty8 Frailty9 Frailty10 Frailty11 Frailty12;

table (Frailty1 Frailty2 Frailty3 Frailty4 Frailty5 Frailty6 Frailty7 Frailty8 Frailty9 Frailty10 Frailty11 Frailty12
),(highcost="10% High Cost Patients"*(n colpctn)   highcost="10% High Cost Patients"*Type*(n colpctn) Type*(n colpctn) 
/*Seg2011="Segments"*(n colpctn)  Seg2011="Segments"*Type*(n colpctn) Seg2011="Segments"*highcost="10% High Cost Patients"*(n colpctn)*/
all*(n colpctn))/RTS=25;
Keylabel all="All Beneficiary"
         N="Number of Beneficiary"
		 colpctn="Column Percent";

run;
*CC;
proc tabulate data=temp noseps  ;
class highcost Seg2011 Type
amiihd  chrkid  chf  dementia  lung  psydis  strk  spchrtarr 
amputat  arthrit  artopen  bph  cancer  diabetes  endo  eyedis  
hemadis  hyperlip  hyperten  immunedis  ibd  liver  neuromusc  osteo  
paralyt  sknulc  sa  thyroid  vascdis;

table ( 
amiihd  chrkid  chf  dementia  lung  psydis  strk  spchrtarr 
amputat  arthrit  artopen  bph  cancer  diabetes  endo  eyedis  
hemadis  hyperlip  hyperten  immunedis  ibd  liver  neuromusc  osteo  
paralyt  sknulc  sa  thyroid  vascdis
),(highcost="10% High Cost Patients"*(n colpctn)  highcost="10% High Cost Patients"*Type*(n colpctn) Type*(n colpctn) 
/*Seg2011="Segments"*(n colpctn)  Seg2011="Segments"*Type*(n colpctn) Seg2011="Segments"*highcost="10% High Cost Patients"*(n colpctn)*/
all*(n colpctn))/RTS=25;

Keylabel all="All Beneficiary"
         N="Number of Beneficiary"
		 colpctn="Column Percent";

run;


/*******************Segment**************************;

proc tabulate data=temp noseps  ;
class highcost Seg2011 gender Type OrgID AgeGroup; 

table (gender="Gender"  Type="Medicaid/Medicaid Managed Care/Private" OrgID="Payer" AgeGroup="Age Group" 
),(Seg2011="Segments"*(n colpctn)  Seg2011="Segments"*Type*(n colpctn) Seg2011="Segments"*highcost="10% High Cost Patients"*(n colpctn)  
Seg2011="Segments"*(n colpctn)  Seg2011="Segments"*Type*(n colpctn) Seg2011="Segments"*highcost="10% High Cost Patients"*(n colpctn)
all*(n colpctn) )/RTS=25;

Keylabel all="All Beneficiary"
         N="Number of Beneficiary"
		 colpctn="Column Percent";

format OrgID OrgID_. AgeGroup AgeGroup_.; 
run;




proc tabulate data=temp noseps;
class highcost Seg2011 Type;
var Age N_Frailty N_CC ;  
table (Age="Age" N_Frailty="N.of Frailty Indicators" N_CC="N.of Chronic Conditions"),
      (Seg2011="Segments"*(mean*f=15.5 median)  Seg2011="Segments"*Type*(mean*f=15.5 median) Seg2011="Segments"*highcost="10% High Cost Patients"*(mean*f=15.5 median) all*(mean*f=15.5 median) )/RTS=25;
	  Keylabel all="All Beneficiary"
         N="Number of Beneficiary"
		 colpctn="Column Percent";
run;

*Major CC and Minor CC Category;
proc tabulate data=temp noseps;
class highcost Seg2011 Type N_MajorCC_C N_MinorCC_C;

table (N_MajorCC_C="N.of Major Chronic Condition" N_MinorCC_C="N.of Minor Chronic Condition"
),(Seg2011="Segments"*(n colpctn)  Seg2011="Segments"*Type*(n colpctn) Seg2011="Segments"*highcost="10% High Cost Patients"*(n colpctn) 
Seg2011="Segments"*(n colpctn)  Seg2011="Segments"*Type*(n colpctn) Seg2011="Segments"*highcost="10% High Cost Patients"*(n colpctn)
all*(n colpctn))/RTS=25;

Keylabel all="All Beneficiary"
         N="Number of Beneficiary"
		 colpctn="Column Percent";
format N_MajorCC_C N_MajorCC_C_.  N_MinorCC_C N_MinorCC_C_.;
run;

*Frailty;
proc tabulate data=temp noseps   ;
class highcost Seg2011 Type Frailty1 Frailty2 Frailty3 Frailty4 Frailty5 Frailty6 Frailty7 Frailty8 Frailty9 Frailty10 Frailty11 Frailty12;

table (Frailty1 Frailty2 Frailty3 Frailty4 Frailty5 Frailty6 Frailty7 Frailty8 Frailty9 Frailty10 Frailty11 Frailty12
),(Seg2011="Segments"*(n colpctn)   Seg2011="Segments"*Type*(n colpctn) Seg2011="Segments"*highcost="10% High Cost Patients"*(n colpctn) 
Seg2011="Segments"*(n colpctn)  Seg2011="Segments"*Type*(n colpctn) Seg2011="Segments"*highcost="10% High Cost Patients"*(n colpctn)
all*(n colpctn))/RTS=25;
Keylabel all="All Beneficiary"
         N="Number of Beneficiary"
		 colpctn="Column Percent";

run;
*CC;
proc tabulate data=temp noseps   ;
class highcost Seg2011 Type
amiihd  chrkid  chf  dementia  lung  psydis  strk  spchrtarr 
amputat  arthrit  artopen  bph  cancer  diabetes  endo  eyedis  
hemadis  hyperlip  hyperten  immunedis  ibd  liver  neuromusc  osteo  
paralyt  sknulc  sa  thyroid  vascdis;

table ( 
amiihd  chrkid  chf  dementia  lung  psydis  strk  spchrtarr 
amputat  arthrit  artopen  bph  cancer  diabetes  endo  eyedis  
hemadis  hyperlip  hyperten  immunedis  ibd  liver  neuromusc  osteo  
paralyt  sknulc  sa  thyroid  vascdis
),(Seg2011="Segments"*(n colpctn)  Seg2011="Segments"*Type*(n colpctn) Seg2011="Segments"*highcost="10% High Cost Patients"*(n colpctn) 
Seg2011="Segments"*(n colpctn)  Seg2011="Segments"*Type*(n colpctn) Seg2011="Segments"*highcost="10% High Cost Patients"*(n colpctn)
all*(n colpctn))/RTS=25;

Keylabel all="All Beneficiary"
         N="Number of Beneficiary"
		 colpctn="Column Percent";

run;
*/
