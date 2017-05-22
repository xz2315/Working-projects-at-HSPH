*****************************************
Cost Per Bene and Per User Tabulation Yearly
Xiner Zhou
2/21/2017
*****************************************;
libname MMleads 'D:\Data\MMLEADS\Data';
libname denom 'D:\Data\Medicare\Denominator';
libname data 'D:\Projects\Peterson\Data';

*********Medicare + Medicaid total cost;
%let yr=2008;
%let yr=2009;
%let yr=2010;
proc tabulate data=data.PlanABene noseps   ;
class group   ; 
var  S_PMT&yr.;
table  
group*S_PMT&yr.="Medicare+Medicaid paid &yr."*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)   
All*S_PMT&yr.="Medicare+Medicaid paid &yr."*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.) ;
  
Keylabel all="All Dual Eligible";
run;




*********Medicare service level;
 
proc sql;
create table temp1 as
select a.bene_id, a.group, a.level, a.SRVC_1, a.SRVC_2, a.Medicare_PMT as Medicare_PMT2008,b.Medicare_PMT as Medicare_PMT2009  
from data.PlanAMedicareService2008 a left join data.PlanAMedicareService2009 b
on a.bene_id=b.bene_id and a.level=b.level;
quit;
proc sql;
create table temp2 as
select a.*,b.Medicare_PMT as Medicare_PMT2010  
from temp1 a left join data.PlanAMedicareService2010 b
on a.bene_id=b.bene_id and a.level=b.level;
quit;

*level 1 sum cost;
proc sort data=temp2;by bene_id SRVC_1 SRVC_2;run;
proc sql;
create table temp3 as
select bene_id, group, SRVC_1, "Total" as SRVC_2, sum(Medicare_PMT2008) as Medicare_PMT2008,
sum(Medicare_PMT2009) as Medicare_PMT2009,sum(Medicare_PMT2010) as Medicare_PMT2010
from temp2
group by bene_id, SRVC_1 ;
quit;

* append ;
data temp4;
set temp2 temp3;
proc sort ;by bene_id SRVC_1 SRVC_2;
run;





* level 2 per bene;
%macro maketable(yr,perbene);
ods excel file="D:\Projects\Peterson\Medicareperbene&perbene.&yr..xlsx" style=minimal;
proc tabulate data= temp4 noseps  QMETHOD=P2;
%if &perbene.=0 %then %do;
where Medicare_PMT&yr. ne 0;
%end;
class group SRVC_1 SRVC_2 ; 
var  Medicare_PMT&yr.;


table SRVC_1,SRVC_2,
group*Medicare_PMT&yr.="Medicare-paid &yr."*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)   
All*Medicare_PMT&yr.="Medicare-paid &yr."*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.) ;
  

Keylabel all="All Dual Eligible";
 format SRVC_1 $MR_SRVC_1_. SRVC_2 $MR_SRVC_2_. ;
run;
 ods excel close;
%mend maketable;
%maketable(yr=2008,perbene=1);
%maketable(yr=2009,perbene=1);
%maketable(yr=2010,perbene=1);
*%maketable(yr=2008,perbene=0);
*%maketable(yr=2009,perbene=0);
*%maketable(yr=2010,perbene=0);
 
* level 1 per bene;
%macro maketable(yr,perbene);
 
proc tabulate data= temp4 noseps  QMETHOD=P2;
where SRVC_2="Total";
%if &perbene.=0 %then %do;
where Medicare_PMT&yr. ne 0;
%end;
class group SRVC_1   ; 
var  Medicare_PMT&yr.;


table SRVC_1, 
group*Medicare_PMT&yr.="Medicare-paid &yr."*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)   
All*Medicare_PMT&yr.="Medicare-paid &yr."*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.) ;
  

Keylabel all="All Dual Eligible";
 format SRVC_1 $MR_SRVC_1_.  ;
run;
 
%mend maketable;
%maketable(yr=2008,perbene=1);
%maketable(yr=2009,perbene=1);
%maketable(yr=2010,perbene=1);



*********Medicaid service level;
%let yr=2008;
%let yr=2009;
%let yr=2010;

data temp1; 
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
proc sort;by bene_id SRVC_3;
run;
proc sql;
create table PlanAMedicaidService&yr. as
select *,sum(Medicaid_PMT) as  Medicaid_PMT1
from temp1
group by bene_id, SRVC_3;
quit;
proc sort data=PlanAMedicaidService&yr. nodupkey;by   bene_id SRVC_3;
run;


proc sql;
create table temp1 as
select a.bene_id, a.group, a.level, a.SRVC_2, a.SRVC_3, a.Medicaid_PMT1  as Medicaid_PMT2008,b.Medicaid_PMT1  as Medicaid_PMT2009  
from  PlanAMedicaidService2008 a left join  PlanAMedicaidService2009 b
on a.bene_id=b.bene_id and a.level=b.level;
quit;
proc sql;
create table temp2 as
select a.*,b.Medicaid_PMT1 as Medicaid_PMT2010  
from temp1 a left join  PlanAMedicaidService2010 b
on a.bene_id=b.bene_id and a.level=b.level;
quit;

*level 1 sum cost;
proc sort data=temp2;by bene_id SRVC_2 SRVC_3;run;
proc sql;
create table temp3 as
select bene_id, group, SRVC_2, "Total" as SRVC_3, sum(Medicaid_PMT2008) as Medicaid_PMT2008,
sum(Medicaid_PMT2009) as Medicaid_PMT2009,sum(Medicaid_PMT2010) as Medicaid_PMT2010
from temp2
group by bene_id, SRVC_2 ;
quit;
proc sort data=temp3 nodupkey;by bene_id SRVC_2;run;

* append ;
data temp4;
set temp2 temp3;
proc sort ;by bene_id SRVC_2 SRVC_3;
run;


* level 2 per bene;
%macro maketable(yr,perbene);
ods excel file="D:\Projects\Peterson\Medicaidperbene&perbene.&yr..xlsx" style=minimal;
proc tabulate data=temp2 out=table1 noseps   QMETHOD=P2;
%if &perbene.=0 %then %do;
where Medicaid_PMT&yr. ne 0;
%end;
class group SRVC_2 SRVC_3; 
var  Medicaid_PMT&yr.  ;


table SRVC_2, SRVC_3,
group*Medicaid_PMT&yr. ="Medicaid-paid &yr."*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)  
       
All*Medicaid_PMT&yr. ="Medicaid-paid &yr."*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)  ;

Keylabel all="All Dual Eligible"
         ;
 format SRVC_3 $MC_SRVC_3_. SRVC_2 $MC_SRVC_2_.;
 
run;
 ods excel close;
%mend maketable;
%maketable(yr=2008,perbene=1);
%maketable(yr=2009,perbene=1);
%maketable(yr=2010,perbene=1);
*%maketable(yr=2008,perbene=0);
*%maketable(yr=2009,perbene=0);
*%maketable(yr=2010,perbene=0);
 

* level 1 per bene;
%macro maketable(yr,perbene);
 
proc tabulate data=temp4 out=table1 noseps   QMETHOD=P2;
where SRVC_3="Total";
%if &perbene.=0 %then %do;
where Medicaid_PMT&yr. ne 0;
%end;
class group SRVC_2  ; 
var  Medicaid_PMT&yr.  ;


table SRVC_2,  
group*Medicaid_PMT&yr. ="Medicaid-paid &yr."*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)  
       
All*Medicaid_PMT&yr. ="Medicaid-paid &yr."*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)  ;

Keylabel all="All Dual Eligible"
         ;
 format  SRVC_2 $MC_SRVC_2_.;
 
run;
 
%mend maketable;
%maketable(yr=2008,perbene=1);
%maketable(yr=2009,perbene=1);
%maketable(yr=2010,perbene=1);
 
