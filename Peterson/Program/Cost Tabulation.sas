*****************************************
Cost Per User Tabulation
Xiner Zhou
1/6/2016
*****************************************;
libname MMleads 'C:\data\Data\MMLEADS\Data';
libname data 'C:\data\Projects\Peterson\Data-XZ';
libname denom 'C:\data\Data\Medicare\Denominator';

 
data sample2010;
set data.sample2010;
S_FFS_MRBene=S_Medicare_PMT+S_Medicare_Bene_PMT;
S_FFS_MCBene= S_Medicaid_FFS_PMT+S_Medicaid_Bene_PMT;
run;
proc tabulate data=Sample2010 noseps  ;
class HC Seg ; 
var S_FFS_MRMCBene S_FFS_MRBene S_Medicare_PMT S_Medicare_Bene_PMT S_FFS_MCBene  S_Medicaid_FFS_PMT S_Medicaid_Bene_PMT;


table S_FFS_MRMCBene="Medicare-paid+Beneficiary Out-of-Pocket, Medicaid-paid+Beneficiary Out-of-Pocket"
      S_FFS_MRBene="Medicare-paid+Beneficiary Out-of-Pocket"
      S_Medicare_PMT="Medicare-paid" 
      S_Medicare_Bene_PMT="Medicare Beneficiary Out-of-Pocket" 
	  S_FFS_MCBene="Medicaid-paid+Beneficiary Out-of-Pocket" 
	  S_Medicaid_FFS_PMT="Medicaid-paid" 
	  S_Medicaid_Bene_PMT="Medicaid Beneficiary Out-of-Pocket" 
      ,HC="10% High Cost Patients"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.) Seg="Segmentation"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)
	  Seg="Segmentation"*HC*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)
      All*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)  ;
 
 
Keylabel all="All Dual Eligible" 
         ;
run;




data MR2010;
set data.MR2010;
PMT=Medicare_PMT+Medicare_Bene_PMT;
run;

proc tabulate data=MR2010 noseps   ;
class HC SRVC_1 Seg SRVC_2 ; 
var PMT Medicare_PMT Medicare_Bene_PMT;


table SRVC_1,SRVC_2,HC="10% High Cost Patients"*(PMT="Medicare-paid+Beneficiary Out-of-Pocket"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)  
                        Medicare_PMT="Medicare-paid"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)  
                        medicare_Bene_PMT="Medicare Beneficiary Out-of-Pocket"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.))
                    seg*(PMT="Medicare-paid+Beneficiary Out-of-Pocket"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)  
                         Medicare_PMT="Medicare-paid"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)  
                         medicare_Bene_PMT="Medicare Beneficiary Out-of-Pocket"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.))
					seg*HC*(PMT="Medicare-paid+Beneficiary Out-of-Pocket"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)  
                         Medicare_PMT="Medicare-paid"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)  
                         medicare_Bene_PMT="Medicare Beneficiary Out-of-Pocket"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.))
                    All*(PMT="Medicare-paid+Beneficiary Out-of-Pocket"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)  
                         Medicare_PMT="Medicare-paid"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)  
                         medicare_Bene_PMT="Medicare Beneficiary Out-of-Pocket"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)) ;
 
 
Keylabel all="All Dual Eligible"
         ;
 format SRVC_1 $MR_SRVC_1_. SRVC_2 $MR_SRVC_2_. ;
 
run;




data temp; 
set data.MC2010;
PMT=Medicaid_PMT+Medicaid_COIN_PMT;
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
create table MC2010 as
select *,sum(PMT) as PMT1,sum(Medicaid_PMT) as  Medicaid_PMT1, sum(Medicaid_COIN_PMT) as  Medicaid_COIN_PMT1
from temp
group by bene_id, SRVC_3;
quit;
proc sort data=MC2010 nodupkey;by   bene_id SRVC_3;
run;

proc tabulate data=MC2010 noseps   ;
class HC seg  SRVC_2 SRVC_3; 
var PMT1 Medicaid_PMT1 Medicaid_coin_PMT1;


table SRVC_2, SRVC_3,
HC="10% High Cost Patients"*(PMT1="Medicaid-paid+Beneficiary Out-of-Pocket"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)  
Medicaid_PMT1="Medicaid-paid"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)  
medicaid_COIN_PMT1="Medicaid Beneficiary Out-of-Pocket"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.))

seg*(PMT1="Medicaid-paid+Beneficiary Out-of-Pocket"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)  
Medicaid_PMT1="Medicaid-paid"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)  
medicaid_COIN_PMT1="Medicaid Beneficiary Out-of-Pocket"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.))

seg*HC*(PMT1="Medicaid-paid+Beneficiary Out-of-Pocket"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)  
Medicaid_PMT1="Medicaid-paid"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)  
medicaid_COIN_PMT1="Medicaid Beneficiary Out-of-Pocket"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.))

All*(PMT1="Medicaid-paid+Beneficiary Out-of-Pocket"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)  
Medicaid_PMT1="Medicaid-paid"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)  
medicaid_COIN_PMT1="Medicaid Beneficiary Out-of-Pocket"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.));
 
 
Keylabel all="All Dual Eligible"
         ;
 format SRVC_3 $MC_SRVC_3_. SRVC_2 $MC_SRVC_2_.;
 
run;


 
