*****************************************
Utilization Per User Tabulation
Xiner Zhou
1/7/2016
*****************************************;
libname MMleads 'C:\data\Data\MMLEADS\Data';
libname data 'C:\data\Projects\Peterson\Data-XZ';
libname denom 'C:\data\Data\Medicaid\Denominator';

  


data MR2010;
set data.MR2010;
Medicare_CLM_CNT=Medicare_CLM_CNT_01+Medicare_CLM_CNT_02+Medicare_CLM_CNT_03+Medicare_CLM_CNT_04
                +Medicare_CLM_CNT_05+Medicare_CLM_CNT_06+Medicare_CLM_CNT_07+Medicare_CLM_CNT_08
                +Medicare_CLM_CNT_09+Medicare_CLM_CNT_10+Medicare_CLM_CNT_11+Medicare_CLM_CNT_12;
Medicare_day_CNT=Medicare_day_CNT_01+Medicare_day_CNT_02+Medicare_day_CNT_03+Medicare_day_CNT_04
                +Medicare_day_CNT_05+Medicare_day_CNT_06+Medicare_day_CNT_07+Medicare_day_CNT_08
                +Medicare_day_CNT_09+Medicare_day_CNT_10+Medicare_day_CNT_11+Medicare_day_CNT_12;
Medicare_cov_day_CNT=Medicare_cov_day_CNT_01+Medicare_cov_day_CNT_02+Medicare_cov_day_CNT_03+Medicare_cov_day_CNT_04
                +Medicare_cov_day_CNT_05+Medicare_cov_day_CNT_06+Medicare_cov_day_CNT_07+Medicare_cov_day_CNT_08
                +Medicare_cov_day_CNT_09+Medicare_cov_day_CNT_10+Medicare_cov_day_CNT_11+Medicare_cov_day_CNT_12;
 
run;

proc tabulate data=MR2010 noseps   ;
class HC SRVC_1 Seg SRVC_2 ; 
var Medicare_CLM_CNT Medicare_day_CNT Medicare_cov_day_CNT;


table SRVC_1,SRVC_2,HC="10% High Cost Patients"*(Medicare_CLM_CNT="Count of FFS claims"*(mean*f=15.5 median*f=7. sum*f=15.)  
                        Medicare_day_CNT="FFS Covered & non-Covered Days"*(mean*f=15.5 median*f=7. sum*f=15.)  
                        Medicare_cov_day_CNT="FFS Covered Days"*(mean*f=7.2 median*f=15.5 sum*f=15.))

                    seg="Segmentation"*(Medicare_CLM_CNT="Count of FFS claims"*(mean*f=15.5 median*f=7. sum*f=15.)  
                        Medicare_day_CNT="FFS Covered & non-Covered Days"*(mean*f=15.5 median*f=7. sum*f=15.)  
                        Medicare_cov_day_CNT="FFS Covered Days"*(mean*f=15.5 median*f=7. sum*f=15.))
					seg="Segmentation"*HC*(Medicare_CLM_CNT="Count of FFS claims"*(mean*f=15.5 median*f=7. sum*f=15.)  
                        Medicare_day_CNT="FFS Covered & non-Covered Days"*(mean*f=15.5 median*f=7. sum*f=15.)  
                        Medicare_cov_day_CNT="FFS Covered Days"*(mean*f=15.5 median*f=7. sum*f=15.))
                        
                    All*(Medicare_CLM_CNT="Count of FFS claims"*(mean*f=15.5 median*f=7. sum*f=15.)  
                        Medicare_day_CNT="FFS Covered & non-Covered Days"*(mean*f=15.5 median*f=7. sum*f=15.)  
                        Medicare_cov_day_CNT="FFS Covered Days"*(mean*f=15.5 median*f=7. sum*f=15.));
 
 
Keylabel all="All Dual Eligible"
         ;
 format SRVC_1 $MR_SRVC_1_. SRVC_2 $MR_SRVC_2_. ;
 
run;




data temp; 
set data.MC2010;
 
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
Medicaid_cov_day_CNT=Medicaid_cov_day_CNT_01+Medicaid_cov_day_CNT_02+Medicaid_cov_day_CNT_03+Medicaid_cov_day_CNT_04
                +Medicaid_cov_day_CNT_05+Medicaid_cov_day_CNT_06+Medicaid_cov_day_CNT_07+Medicaid_cov_day_CNT_08
                +Medicaid_cov_day_CNT_09+Medicaid_cov_day_CNT_10+Medicaid_cov_day_CNT_11+Medicaid_cov_day_CNT_12;
 
proc sort;by bene_id SRVC_3;
run;
proc sql;
create table MC2010 as
select *,sum(Medicaid_CLM_CNT) as Medicaid_CLM_CNT1,sum(Medicaid_day_CNT) as  Medicaid_day_CNT1, sum(Medicaid_cov_day_CNT) as  Medicaid_cov_day_CNT1
from temp
group by bene_id, SRVC_3;
quit;
proc sort data=MC2010 nodupkey;by   bene_id SRVC_3;
run;

proc tabulate data=MC2010 noseps   ;
class HC seg  SRVC_2 SRVC_3; 
var Medicaid_CLM_CNT1 Medicaid_day_CNT1 Medicaid_cov_day_CNT1;


table SRVC_2, SRVC_3,HC="10% High Cost Patients"*(Medicaid_CLM_CNT1="Count of FFS claims"*(mean*f=15.5 median*f=7. sum*f=15.)  
                        Medicaid_day_CNT1="FFS Covered & non-Covered Days"*(mean*f=15.5 median*f=7. sum*f=15.)  
                        Medicaid_cov_day_CNT1="FFS Covered Days"*(mean*f=15.5 median*f=7. sum*f=15.))

seg="Segmentation"*(Medicaid_CLM_CNT1="Count of FFS claims"*(mean*f=15.5 median*f=7. sum*f=15.)  
                        Medicaid_day_CNT1="FFS Covered & non-Covered Days"*(mean*f=15.5 median*f=7. sum*f=15.)  
                        Medicaid_cov_day_CNT1="FFS Covered Days"*(mean*f=15.5 median*f=7. sum*f=15.))

seg="Segmentation"*HC*(Medicaid_CLM_CNT1="Count of FFS claims"*(mean*f=15.5 median*f=7. sum*f=15.)  
                        Medicaid_day_CNT1="FFS Covered & non-Covered Days"*(mean*f=15.5 median*f=7. sum*f=15.)  
                        Medicaid_cov_day_CNT1="FFS Covered Days"*(mean*f=15.5 median*f=7. sum*f=15.))
All*(Medicaid_CLM_CNT1="Count of FFS claims"*(mean*f=15.5 median*f=7. sum*f=15.)  
                        Medicaid_day_CNT1="FFS Covered & non-Covered Days"*(mean*f=15.5 median*f=7. sum*f=15.)  
                        Medicaid_cov_day_CNT1="FFS Covered Days"*(mean*f=15.5 median*f=7. sum*f=15.))
;
 
 
Keylabel all="All Dual Eligible"
         ;
 format SRVC_3 $MC_SRVC_3_. SRVC_2 $MC_SRVC_2_.;
 
run;


 
