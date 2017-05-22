*****************************************
Util Per Bene and Per User Tabulation
Xiner Zhou
3/10/2017
*****************************************;
libname MMleads 'D:\Data\MMLEADS\Data';
libname denom 'D:\Data\Medicare\Denominator';
libname data 'D:\Projects\Peterson\Data';

*********Medicare service level;
%let yr=2008;
%let yr=2009;
%let yr=2010;
data PlanAMedicareService&yr.;
set data.PlanAMedicareService&yr.;
Medicare_CLM_CNT=Medicare_CLM_CNT_01+Medicare_CLM_CNT_02+Medicare_CLM_CNT_03+Medicare_CLM_CNT_04
                +Medicare_CLM_CNT_05+Medicare_CLM_CNT_06+Medicare_CLM_CNT_07+Medicare_CLM_CNT_08
                +Medicare_CLM_CNT_09+Medicare_CLM_CNT_10+Medicare_CLM_CNT_11+Medicare_CLM_CNT_12;
Medicare_day_CNT=Medicare_day_CNT_01+Medicare_day_CNT_02+Medicare_day_CNT_03+Medicare_day_CNT_04
                +Medicare_day_CNT_05+Medicare_day_CNT_06+Medicare_day_CNT_07+Medicare_day_CNT_08
                +Medicare_day_CNT_09+Medicare_day_CNT_10+Medicare_day_CNT_11+Medicare_day_CNT_12;
 
run; 
 
proc sql;
create table temp1 as
select a.bene_id, a.group, a.level, a.SRVC_1, a.SRVC_2, 
a.Medicare_CLM_CNT as Medicare_CLM_CNT2008,a.Medicare_day_CNT as Medicare_day_CNT2008 ,
b.Medicare_CLM_CNT as Medicare_CLM_CNT2009,b.Medicare_day_CNT as Medicare_day_CNT2009  
 
from  PlanAMedicareService2008 a left join  PlanAMedicareService2009 b
on a.bene_id=b.bene_id and a.level=b.level;
quit;
proc sql;
create table temp2 as
select a.*,b.Medicare_CLM_CNT as Medicare_CLM_CNT2010,b.Medicare_day_CNT as Medicare_day_CNT2010 
from temp1 a left join  PlanAMedicareService2010 b
on a.bene_id=b.bene_id and a.level=b.level;
quit;

*level 1 sum cost;
proc sort data=temp2;by bene_id SRVC_1 SRVC_2;run;
proc sql;
create table temp3 as
select bene_id, group, SRVC_1, "Total" as SRVC_2, 
sum(Medicare_CLM_CNT2008) as Medicare_CLM_CNT2008,
sum(Medicare_CLM_CNT2009) as Medicare_CLM_CNT2009,
sum(Medicare_CLM_CNT2010) as Medicare_CLM_CNT2010,

sum(Medicare_day_CNT2008) as Medicare_day_CNT2008,
sum(Medicare_day_CNT2009) as Medicare_day_CNT2009,
sum(Medicare_day_CNT2010) as Medicare_day_CNT2010 


from temp2
group by bene_id, SRVC_1 ;
quit;

proc sort data=temp3 nodupkey;by bene_id  SRVC_1;run;

* append ;
data temp4;
set temp2 temp3;
ave_Medicare_CLM_CNT=(Medicare_CLM_CNT2008+Medicare_CLM_CNT2009+Medicare_CLM_CNT2010)/3;
ave_Medicare_day_CNT=(Medicare_day_CNT2008+Medicare_day_CNT2009+Medicare_day_CNT2010)/3;
proc sort ;by bene_id SRVC_1 SRVC_2;
run;
 
* 3yr average;
proc tabulate data= temp4 noseps  QMETHOD=P2;
class group SRVC_1 SRVC_2 ; 
var ave_Medicare_CLM_CNT ave_Medicare_day_CNT;

table SRVC_1,SRVC_2,group*(ave_Medicare_CLM_CNT="Count of FFS claims 3-year average"*(mean*f=15.5 median*f=7. sum*f=15.)  
                           ave_Medicare_day_CNT="FFS Days 3-year average"*(mean*f=15.5 median*f=7. sum*f=15.))
            
All*(ave_Medicare_CLM_CNT="Count of FFS claims 3-year average"*(mean*f=15.5 median*f=7. sum*f=15.)  
     ave_Medicare_day_CNT="FFS Days 3-year average"*(mean*f=15.5 median*f=7. sum*f=15.));

Keylabel all="All Dual Eligible";
 format SRVC_1 $MR_SRVC_1_. SRVC_2 $MR_SRVC_2_. ;
run;

%macro maketable(yr,perbene);
ods excel file="D:\Projects\Peterson\temp.xlsx" style=minimal;
proc tabulate data= temp4 noseps  QMETHOD=P2;
%if &perbene.=0 %then %do;
where Medicare_PMT&yr. ne 0;
%end;
class group SRVC_1 SRVC_2 ; 
var Medicare_CLM_CNT&yr. Medicare_day_CNT&yr.  ;

table SRVC_1,SRVC_2,group*(Medicare_CLM_CNT&yr.="Count of FFS claims &yr."*(mean*f=15.5 median*f=7. sum*f=15.)  
                           Medicare_day_CNT&yr.="FFS Days &yr."*(mean*f=15.5 median*f=7. sum*f=15.))
            
All*(Medicare_CLM_CNT&yr.="Count of FFS claims &yr."*(mean*f=15.5 median*f=7. sum*f=15.)  
     Medicare_day_CNT&yr.="FFS Days &yr."*(mean*f=15.5 median*f=7. sum*f=15.));

Keylabel all="All Dual Eligible";
 format SRVC_1 $MR_SRVC_1_. SRVC_2 $MR_SRVC_2_. ;
run;
  ods excel close;

%mend maketable;
%maketable(yr=2008,perbene=1);
%maketable(yr=2009,perbene=1);
%maketable(yr=2010,perbene=1);
%maketable(yr=2008,perbene=0);
%maketable(yr=2009,perbene=0);
%maketable(yr=2010,perbene=0);



*********Medicaid service level;
%let yr=2008;
%let yr=2009;
%let yr=2010;
data temp&yr.; 
set data.PlanAMedicaidService&yr.;
 
if SRVC_3='MDCD_FFS_LTN_REHAB_W' then SRVC_3='MDCD_FFS_LTN_REHAB';
if SRVC_3='MDCD_FFS_LTN_REHAB_NW' then SRVC_3='MDCD_FFS_LTN_REHAB';
if SRVC_3='MDCD_FFS_LTN_HH_W' then SRVC_3='MDCD_FFS_LTN_HH';
if SRVC_3='MDCD_FFS_LTN_HH_NW' then SRVC_3='MDCD_FFS_LTN_HH';
if SRVC_3='MDCD_FFS_LTN_HOS_W' then SRVC_3='MDCD_FFS_LTN_HOS';
if SRVC_3='MDCD_FFS_LTN_HOS_NW' then SRVC_3='MDCD_FFS_LTN_HOS';
if SRVC_3='MDCD_FFS_LTN_DME_W' then SRVC_3='MDCD_FFS_LTN_DME';
if SRVC_3='MDCD_FFS_LTN_DME_NW' then SRVC_3='MDCD_FFS_LTN_DME';
if SRVC_3='MDCD_FFS_LTN_PCS_W' then SRVC_3='MDCD_FFS_LTN_PCS';
if SRVC_3='MDCD_FFS_LTN_PCS_NW' then SRVC_3='MDCD_FFS_LTN_PCS';
if SRVC_3='MDCD_FFS_LTN_RC_W' then SRVC_3='MDCD_FFS_LTN_RC';
if SRVC_3='MDCD_FFS_LTN_RC_NW' then SRVC_3='MDCD_FFS_LTN_RC';
if SRVC_3='MDCD_FFS_LTN_ADC_W' then SRVC_3='MDCD_FFS_LTN_ADC';
if SRVC_3='MDCD_FFS_LTN_ADC_NW' then SRVC_3='MDCD_FFS_LTN_ADC';
if SRVC_3='MDCD_FFS_LTN_TS_W' then SRVC_3='MDCD_FFS_LTN_TS';
if SRVC_3='MDCD_FFS_LTN_TS_NW' then SRVC_3='MDCD_FFS_LTN_TS';
if SRVC_3='MDCD_FFS_LTN_TCM_W' then SRVC_3='MDCD_FFS_LTN_TCM';
if SRVC_3='MDCD_FFS_LTN_TCM_NW' then SRVC_3='MDCD_FFS_LTN_TCM';
if SRVC_3='MDCD_FFS_LTN_PDN_W' then SRVC_3='MDCD_FFS_LTN_PDN';
if SRVC_3='MDCD_FFS_LTN_PDN_NW' then SRVC_3='MDCD_FFS_LTN_PDN';
Medicaid_CLM_CNT=Medicaid_CLM_CNT_01+Medicaid_CLM_CNT_02+Medicaid_CLM_CNT_03+Medicaid_CLM_CNT_04
                +Medicaid_CLM_CNT_05+Medicaid_CLM_CNT_06+Medicaid_CLM_CNT_07+Medicaid_CLM_CNT_08
                +Medicaid_CLM_CNT_09+Medicaid_CLM_CNT_10+Medicaid_CLM_CNT_11+Medicaid_CLM_CNT_12;
Medicaid_day_CNT=Medicaid_day_CNT_01+Medicaid_day_CNT_02+Medicaid_day_CNT_03+Medicaid_day_CNT_04
                +Medicaid_day_CNT_05+Medicaid_day_CNT_06+Medicaid_day_CNT_07+Medicaid_day_CNT_08
                +Medicaid_day_CNT_09+Medicaid_day_CNT_10+Medicaid_day_CNT_11+Medicaid_day_CNT_12;
 
proc sort;by bene_id SRVC_3;
run;
proc sql;
create table PlanAMedicaidService&yr. as
select bene_id, group, level, SRVC_2, SRVC_3,
sum(Medicaid_CLM_CNT ) as Medicaid_CLM_CNT&yr.,sum(Medicaid_day_CNT ) as Medicaid_day_CNT&yr.
from temp&yr.
group by bene_id, SRVC_3;
quit;
proc sort data=PlanAMedicaidService&yr. nodupkey;by   bene_id SRVC_3;
run;

proc sql;
create table temp1 as
select a.*,b.*
from  PlanAMedicaidService2008 a left join  PlanAMedicaidService2009 b
on a.bene_id=b.bene_id and a.level=b.level;
quit;
proc sql;
create table temp2 as
select a.*,b.*
from temp1 a left join  PlanAMedicaidService2010 b
on a.bene_id=b.bene_id and a.level=b.level;
quit;

*level 1 sum cost;
proc sort data=temp2;by bene_id SRVC_2 SRVC_3;run;
proc sql;
create table temp3 as
select bene_id, group, SRVC_2, "Total" as SRVC_3, 
sum(Medicaid_CLM_CNT2008) as Medicaid_CLM_CNT2008,
sum(Medicaid_CLM_CNT2009) as Medicaid_CLM_CNT2009,
sum(Medicaid_CLM_CNT2010) as Medicaid_CLM_CNT2010,

sum(Medicaid_day_CNT2008) as Medicaid_day_CNT2008,
sum(Medicaid_day_CNT2009) as Medicaid_day_CNT2009,
sum(Medicaid_day_CNT2010) as Medicaid_day_CNT2010 


from temp2
group by bene_id, SRVC_2 ;
quit;

proc sort data=temp3 nodupkey;by bene_id  SRVC_2;run;

* append ;
data temp4;
set temp2 temp3;
ave_Medicaid_CLM_CNT=(Medicaid_CLM_CNT2008+Medicaid_CLM_CNT2009+Medicaid_CLM_CNT2010)/3;
ave_Medicaid_day_CNT=(Medicaid_day_CNT2008+Medicaid_day_CNT2009+Medicaid_day_CNT2010)/3;
proc sort ;by bene_id SRVC_2 SRVC_3;
run;
 

* 3yr average;
proc tabulate data= temp4 noseps  QMETHOD=P2;
class group SRVC_2 SRVC_3 ; 
var ave_Medicaid_CLM_CNT ave_Medicaid_day_CNT;

table SRVC_2,SRVC_3,group*(ave_Medicaid_CLM_CNT="Count of FFS claims 3-year average"*(mean*f=15.5 median*f=7. sum*f=15.)  
                           ave_Medicaid_day_CNT="FFS Days 3-year average"*(mean*f=15.5 median*f=7. sum*f=15.))
            
All*(ave_Medicaid_CLM_CNT="Count of FFS claims 3-year average"*(mean*f=15.5 median*f=7. sum*f=15.)  
     ave_Medicaid_day_CNT="FFS Days 3-year average"*(mean*f=15.5 median*f=7. sum*f=15.));

Keylabel all="All Dual Eligible";
 format SRVC_3 $MC_SRVC_3_. SRVC_2 $MC_SRVC_2_.;
run;


%macro maketable(yr,perbene);
 
proc tabulate data=temp4 noseps   ;
class group  SRVC_2 SRVC_3; 
var  Medicaid_CLM_CNT&yr. Medicaid_day_CNT&yr.;


table SRVC_2, SRVC_3,group*(Medicaid_CLM_CNT&yr.="Count of FFS claims &yr."*(mean*f=15.5 median*f=7. sum*f=15.)  
                           Medicaid_day_CNT&yr.="FFS Days &yr."*(mean*f=15.5 median*f=7. sum*f=15.))

All*(Medicaid_CLM_CNT&yr.="Count of FFS claims &yr."*(mean*f=15.5 median*f=7. sum*f=15.)  
                           Medicaid_day_CNT&yr.="FFS Days &yr."*(mean*f=15.5 median*f=7. sum*f=15.))
;
 
 
Keylabel all="All Dual Eligible"
         ;
 format SRVC_3 $MC_SRVC_3_. SRVC_2 $MC_SRVC_2_.;
 
run;
 ods excel close;
%mend maketable;
%maketable(yr=2008,perbene=1);
%maketable(yr=2009,perbene=1);
%maketable(yr=2010,perbene=1);
%maketable(yr=2008,perbene=0);
%maketable(yr=2009,perbene=0);
%maketable(yr=2010,perbene=0);

 
