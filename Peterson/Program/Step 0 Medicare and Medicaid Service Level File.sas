*****************************************
Medicare Service level file 
Medicaid Service level file
For Persistent HC PlanA and PlanB

Xiner Zhou
2/21/2017
*******************************Medicare Service-level file;
libname MMleads 'D:\Data\MMLEADS\Data';
libname denom 'D:\Data\Medicare\Denominator';
libname data 'D:\Projects\Peterson\Data';

%let yr=2008;
%let yr=2009;
%let yr=2010;

proc import datafile="D:\Projects\Peterson\Program-XZ\Medicare Service Level" dbms=xlsx out=level replace;getnames=yes;run;
data level;
set level;
level=_n_; 
run;
data temp&yr.1;
set data.PlanAbene;
do i=1 to 55;
 level=i;output;
end;
drop i;
run;
proc sql;
create table temp&yr.2 as
select a.*,b.SRVC_1 as SRVC_1_1,b.SRVC_2 as SRVC_2_1
from temp&yr.1 a left join level b
on a.level=b.level;
quit;



proc sql;
create table temp&yr.3 as
select a.*,
b.Bene_CNT,b.USER1_CNT,b.USER2_CNT,b.SRVC_1,b.SRVC_2,b.Medicare_PMT,b.Medicare_Bene_PMT,
b.Medicare_CLM_CNT_01,b.Medicare_CLM_CNT_02,b.Medicare_CLM_CNT_03,b.Medicare_CLM_CNT_04,b.Medicare_CLM_CNT_05,b.Medicare_CLM_CNT_06,b.Medicare_CLM_CNT_07,b.Medicare_CLM_CNT_08,b.Medicare_CLM_CNT_09,b.Medicare_CLM_CNT_10,b.Medicare_CLM_CNT_11,b.Medicare_CLM_CNT_12,
b.Medicare_Day_CNT_01,b.Medicare_Day_CNT_02,b.Medicare_Day_CNT_03,b.Medicare_Day_CNT_04,b.Medicare_Day_CNT_05,b.Medicare_Day_CNT_06,b.Medicare_Day_CNT_07,b.Medicare_Day_CNT_08,b.Medicare_Day_CNT_09,b.Medicare_Day_CNT_10,b.Medicare_Day_CNT_11,b.Medicare_Day_CNT_12,
b.Medicare_Cov_Day_CNT_01,b.Medicare_Cov_Day_CNT_02,b.Medicare_Cov_Day_CNT_03,b.Medicare_Cov_Day_CNT_04,b.Medicare_Cov_Day_CNT_05,b.Medicare_Cov_Day_CNT_06,b.Medicare_Cov_Day_CNT_07,b.Medicare_Cov_Day_CNT_08,b.Medicare_Cov_Day_CNT_09,b.Medicare_Cov_Day_CNT_10,b.Medicare_Cov_Day_CNT_11,b.Medicare_Cov_Day_CNT_12

from temp&yr.2 a left join MMLEADS.Mml_mrse&yr. b
on a.bene_id=b.bene_id and a.SRVC_1_1=b.SRVC_1 and a.SRVC_2_1=b.SRVC_2;
quit;


data data.PlanAMedicareService&yr.;
set temp&yr.3;
if SRVC_1='' then SRVC_1=SRVC_1_1;
if SRVC_2='' then SRVC_2=SRVC_2_1;

drop SRVC_1_1 SRVC_2_1;
 
array temp {38}
Medicare_PMT Medicare_Bene_PMT 
Medicare_CLM_CNT_01 Medicare_CLM_CNT_02 Medicare_CLM_CNT_03 Medicare_CLM_CNT_04 Medicare_CLM_CNT_05 Medicare_CLM_CNT_06 Medicare_CLM_CNT_07 Medicare_CLM_CNT_08 Medicare_CLM_CNT_09 Medicare_CLM_CNT_10 Medicare_CLM_CNT_11 Medicare_CLM_CNT_12 
Medicare_Day_CNT_01 Medicare_Day_CNT_02 Medicare_Day_CNT_03 Medicare_Day_CNT_04 Medicare_Day_CNT_05 Medicare_Day_CNT_06 Medicare_Day_CNT_07 Medicare_Day_CNT_08 Medicare_Day_CNT_09 Medicare_Day_CNT_10 Medicare_Day_CNT_11 Medicare_Day_CNT_12 
Medicare_Cov_Day_CNT_01 Medicare_Cov_Day_CNT_02 Medicare_Cov_Day_CNT_03 Medicare_Cov_Day_CNT_04 Medicare_Cov_Day_CNT_05 Medicare_Cov_Day_CNT_06 Medicare_Cov_Day_CNT_07 Medicare_Cov_Day_CNT_08 Medicare_Cov_Day_CNT_09 Medicare_Cov_Day_CNT_10 Medicare_Cov_Day_CNT_11 Medicare_Cov_Day_CNT_12
;
do i=1 to 38;
if temp{i}=. then temp{i}=0;
end;
Medicare_CLM_CNT=Medicare_CLM_CNT_01+ Medicare_CLM_CNT_02+  Medicare_CLM_CNT_03+  Medicare_CLM_CNT_04+  Medicare_CLM_CNT_05+  Medicare_CLM_CNT_06
+ Medicare_CLM_CNT_07+  Medicare_CLM_CNT_08+  Medicare_CLM_CNT_09+  Medicare_CLM_CNT_10+  Medicare_CLM_CNT_11+  Medicare_CLM_CNT_12 ;

Medicare_Day_CNT=Medicare_Day_CNT_01+ Medicare_Day_CNT_02+ Medicare_Day_CNT_03+ Medicare_Day_CNT_04+ Medicare_Day_CNT_05+ Medicare_Day_CNT_06 
+Medicare_Day_CNT_07+ Medicare_Day_CNT_08+ Medicare_Day_CNT_09+ Medicare_Day_CNT_10+ Medicare_Day_CNT_11+ Medicare_Day_CNT_12;
 
Medicare_Cov_Day_CNT=Medicare_Cov_Day_CNT_01+ Medicare_Cov_Day_CNT_02+ Medicare_Cov_Day_CNT_03+ Medicare_Cov_Day_CNT_04+ Medicare_Cov_Day_CNT_05
+ Medicare_Cov_Day_CNT_06+ Medicare_Cov_Day_CNT_07+ Medicare_Cov_Day_CNT_08+ Medicare_Cov_Day_CNT_09+ Medicare_Cov_Day_CNT_10+ Medicare_Cov_Day_CNT_11+ Medicare_Cov_Day_CNT_12;
 
drop i;
 
run;
 

********************************Medicaid Service-level file;

%let yr=2008;
%let yr=2009;
%let yr=2010;
proc import datafile="D:\Projects\Peterson\Program-XZ\Medicaid Service Level" dbms=xlsx out=level replace;getnames=yes;run;
data level;
set level;
level=_n_; 
run;
data temp&yr.1;
set data.PlanAbene;
do i=1 to 74;
 level=i;output;
end;
drop i;
run;
proc sql;
create table temp&yr.2 as
select a.*,b.SRVC_1 as SRVC_1_1,b.SRVC_2 as SRVC_2_1,b.SRVC_3 as SRVC_3_1
from temp&yr.1 a left join level b
on a.level=b.level;
quit;
 

proc sql;
create table temp&yr.3 as
select a.*,
b.Bene_CNT,b.USER1_CNT,b.USER2_CNT,b.USER3_CNT,b.SRVC_1,b.SRVC_2,b.SRVC_3,b.Medicaid_PMT,b.Medicaid_coin_PMT,b.Medicaid_DED_PMT,
b.Medicaid_CLM_CNT_01,b.Medicaid_CLM_CNT_02,b.Medicaid_CLM_CNT_03,b.Medicaid_CLM_CNT_04,b.Medicaid_CLM_CNT_05,b.Medicaid_CLM_CNT_06,b.Medicaid_CLM_CNT_07,b.Medicaid_CLM_CNT_08,b.Medicaid_CLM_CNT_09,b.Medicaid_CLM_CNT_10,b.Medicaid_CLM_CNT_11,b.Medicaid_CLM_CNT_12,
b.Medicaid_Day_CNT_01,b.Medicaid_Day_CNT_02,b.Medicaid_Day_CNT_03,b.Medicaid_Day_CNT_04,b.Medicaid_Day_CNT_05,b.Medicaid_Day_CNT_06,b.Medicaid_Day_CNT_07,b.Medicaid_Day_CNT_08,b.Medicaid_Day_CNT_09,b.Medicaid_Day_CNT_10,b.Medicaid_Day_CNT_11,b.Medicaid_Day_CNT_12,
b.Medicaid_Cov_Day_CNT_01,b.Medicaid_Cov_Day_CNT_02,b.Medicaid_Cov_Day_CNT_03,b.Medicaid_Cov_Day_CNT_04,b.Medicaid_Cov_Day_CNT_05,b.Medicaid_Cov_Day_CNT_06,b.Medicaid_Cov_Day_CNT_07,b.Medicaid_Cov_Day_CNT_08,b.Medicaid_Cov_Day_CNT_09,b.Medicaid_Cov_Day_CNT_10,b.Medicaid_Cov_Day_CNT_11,b.Medicaid_Cov_Day_CNT_12

from temp&yr.2 a left join MMLEADS.Mml_mdse&yr. b
on a.bene_id=b.bene_id and a.SRVC_1_1=b.SRVC_1 and a.SRVC_2_1=b.SRVC_2 and a.SRVC_3_1=b.SRVC_3 ;
quit;

data data.PlanAMedicaidService&yr.;
set temp&yr.3;
if SRVC_1='' then SRVC_1=SRVC_1_1;
if SRVC_2='' then SRVC_2=SRVC_2_1;
if SRVC_3='' then SRVC_3=SRVC_3_1;
drop SRVC_1_1 SRVC_2_1 SRVC_3_1;

array temp {39}
Medicaid_PMT Medicaid_coin_PMT Medicaid_DED_PMT 
Medicaid_CLM_CNT_01 Medicaid_CLM_CNT_02 Medicaid_CLM_CNT_03 Medicaid_CLM_CNT_04 Medicaid_CLM_CNT_05 Medicaid_CLM_CNT_06 Medicaid_CLM_CNT_07 Medicaid_CLM_CNT_08 Medicaid_CLM_CNT_09 Medicaid_CLM_CNT_10 Medicaid_CLM_CNT_11 Medicaid_CLM_CNT_12 
Medicaid_Day_CNT_01 Medicaid_Day_CNT_02 Medicaid_Day_CNT_03 Medicaid_Day_CNT_04 Medicaid_Day_CNT_05 Medicaid_Day_CNT_06 Medicaid_Day_CNT_07 Medicaid_Day_CNT_08 Medicaid_Day_CNT_09 Medicaid_Day_CNT_10 Medicaid_Day_CNT_11 Medicaid_Day_CNT_12 
Medicaid_Cov_Day_CNT_01 Medicaid_Cov_Day_CNT_02 Medicaid_Cov_Day_CNT_03 Medicaid_Cov_Day_CNT_04 Medicaid_Cov_Day_CNT_05 Medicaid_Cov_Day_CNT_06 Medicaid_Cov_Day_CNT_07 Medicaid_Cov_Day_CNT_08 Medicaid_Cov_Day_CNT_09 Medicaid_Cov_Day_CNT_10 Medicaid_Cov_Day_CNT_11 Medicaid_Cov_Day_CNT_12
;
do i=1 to 39;
if temp{i}=. then temp{i}=0;
end;
Medicaid_CLM_CNT=Medicaid_CLM_CNT_01+ Medicaid_CLM_CNT_02+  Medicaid_CLM_CNT_03+  Medicaid_CLM_CNT_04+  Medicaid_CLM_CNT_05+  Medicaid_CLM_CNT_06
+ Medicaid_CLM_CNT_07+  Medicaid_CLM_CNT_08+  Medicaid_CLM_CNT_09+ Medicaid_CLM_CNT_10+  Medicaid_CLM_CNT_11+  Medicaid_CLM_CNT_12 ;

Medicaid_Day_CNT=Medicaid_Day_CNT_01+ Medicaid_Day_CNT_02+ Medicaid_Day_CNT_03+ Medicaid_Day_CNT_04+ Medicaid_Day_CNT_05+ Medicaid_Day_CNT_06 
+Medicaid_Day_CNT_07+ Medicaid_Day_CNT_08+ Medicaid_Day_CNT_09+ Medicaid_Day_CNT_10+ Medicaid_Day_CNT_11+ Medicaid_Day_CNT_12;
 
Medicaid_Cov_Day_CNT=Medicaid_Cov_Day_CNT_01+ Medicaid_Cov_Day_CNT_02+ Medicaid_Cov_Day_CNT_03+ Medicaid_Cov_Day_CNT_04+ Medicaid_Cov_Day_CNT_05
+ Medicaid_Cov_Day_CNT_06+ Medicaid_Cov_Day_CNT_07+ Medicaid_Cov_Day_CNT_08+ Medicaid_Cov_Day_CNT_09+ Medicaid_Cov_Day_CNT_10+ Medicaid_Cov_Day_CNT_11+ Medicaid_Cov_Day_CNT_12;

Medicaid_Bene_PMT=Medicaid_coin_PMT+Medicaid_DED_PMT ;
 
drop i;
run;
 
