*******************************
Prepare Data for all Full Duals
Xiner Zhou
7/12/2016
*******************************;
libname MMleads 'C:\data\Data\MMLEADS\Data';
libname data 'C:\data\Projects\Peterson\Data-XZ';
libname denom 'C:\data\Data\Medicare\Denominator';
libname PQI  'C:\data\Projects\Peterson\Data';


*****************************************
   Which Year?
*****************************************;

%let yr=2010;

******************************************
	Beneficiary Sample Selection
******************************************;

* Select variabels in bene file;
proc sql;
create table temp1&yr. as
select bene_id, 
/* demographics */
D_Died, D_Age, D_Sex, D_Medicare_Race, D_Medicaid_Race, D_ZIP, D_State_CD, D_COUNTY, D_Disability_CD, D_Disability_Primary_CD, D_Disability_Secondary_CD,
E_MME_Type, E_MedicaidFFS,	E_MedicaidPHP, E_MedicareFFS, E_MS_CD,  E_BOE, 

/* Total Medicare Spending */ 
S_Medicare_PMT, /*Annual Medicare FFS payments */
S_Medicare_Bene_PMT, /* Annual Medicare coinsurance and deductible FFS payments */

/* Total Medicaid Spending */
S_Medicaid_PMT, /* Annual Medicaid Managed Care and FFS payments */
S_Medicaid_Bene_PMT, /* Annual Medicaid coinsurance and deductible payments. */
S_Medicaid_FFS_PMT, /* Annual Medicaid FFS payments */


/* Medicare Utilization */
U_Medicare_Admits, U_Medicare_Readmits, 
U_Acute_Cov_Day_CNT_01,U_Acute_Cov_Day_CNT_02,U_Acute_Cov_Day_CNT_03,U_Acute_Cov_Day_CNT_04,U_Acute_Cov_Day_CNT_05,U_Acute_Cov_Day_CNT_06,U_Acute_Cov_Day_CNT_07,U_Acute_Cov_Day_CNT_08,U_Acute_Cov_Day_CNT_09,U_Acute_Cov_Day_CNT_10,U_Acute_Cov_Day_CNT_11,U_Acute_Cov_Day_CNT_12,
U_SNF_Day_CNT_01,U_SNF_Day_CNT_02,U_SNF_Day_CNT_03,U_SNF_Day_CNT_04,U_SNF_Day_CNT_05,U_SNF_Day_CNT_06,U_SNF_Day_CNT_07,U_SNF_Day_CNT_08,U_SNF_Day_CNT_09,U_SNF_Day_CNT_10,U_SNF_Day_CNT_11,U_SNF_Day_CNT_12,
U_PAC_OTH_Day_CNT_01,U_PAC_OTH_Day_CNT_02,U_PAC_OTH_Day_CNT_03,U_PAC_OTH_Day_CNT_04,U_PAC_OTH_Day_CNT_05,U_PAC_OTH_Day_CNT_06,U_PAC_OTH_Day_CNT_07,U_PAC_OTH_Day_CNT_08,U_PAC_OTH_Day_CNT_09,U_PAC_OTH_Day_CNT_10,U_PAC_OTH_Day_CNT_11,U_PAC_OTH_Day_CNT_12,
U_Hospice_Day_CNT_01,U_Hospice_Day_CNT_02,U_Hospice_Day_CNT_03,U_Hospice_Day_CNT_04,U_Hospice_Day_CNT_05,U_Hospice_Day_CNT_06,U_Hospice_Day_CNT_07,U_Hospice_Day_CNT_08,U_Hospice_Day_CNT_09,U_Hospice_Day_CNT_10,U_Hospice_Day_CNT_11,U_Hospice_Day_CNT_12,
U_Medicare_HH_VST_CNT_01,U_Medicare_HH_VST_CNT_02,U_Medicare_HH_VST_CNT_03,U_Medicare_HH_VST_CNT_04,U_Medicare_HH_VST_CNT_05,U_Medicare_HH_VST_CNT_06,U_Medicare_HH_VST_CNT_07,U_Medicare_HH_VST_CNT_08,U_Medicare_HH_VST_CNT_09,U_Medicare_HH_VST_CNT_10,U_Medicare_HH_VST_CNT_11,U_Medicare_HH_VST_CNT_12,
U_Medicare_IER_CNT_01,U_Medicare_IER_CNT_02,U_Medicare_IER_CNT_03,U_Medicare_IER_CNT_04,U_Medicare_IER_CNT_05,U_Medicare_IER_CNT_06,U_Medicare_IER_CNT_07,U_Medicare_IER_CNT_08,U_Medicare_IER_CNT_09,U_Medicare_IER_CNT_10,U_Medicare_IER_CNT_11,U_Medicare_IER_CNT_12,
U_Medicare_OER_CNT_01,U_Medicare_OER_CNT_02,U_Medicare_OER_CNT_03,U_Medicare_OER_CNT_04,U_Medicare_OER_CNT_05,U_Medicare_OER_CNT_06,U_Medicare_OER_CNT_07,U_Medicare_OER_CNT_08,U_Medicare_OER_CNT_09,U_Medicare_OER_CNT_10,U_Medicare_OER_CNT_11,U_Medicare_OER_CNT_12,
U_Phys_Vst_01,U_Phys_Vst_02,U_Phys_Vst_03,U_Phys_Vst_04,U_Phys_Vst_05,U_Phys_Vst_06,U_Phys_Vst_07,U_Phys_Vst_08,U_Phys_Vst_09,U_Phys_Vst_10,U_Phys_Vst_11,U_Phys_Vst_12,
U_DME_Vst_01,U_DME_Vst_02,U_DME_Vst_03,U_DME_Vst_04,U_DME_Vst_05,U_DME_Vst_06,U_DME_Vst_07,U_DME_Vst_08,U_DME_Vst_09,U_DME_Vst_10,U_DME_Vst_11,U_DME_Vst_12,
U_Drug_PTD_01,U_Drug_PTD_02,U_Drug_PTD_03,U_Drug_PTD_04,U_Drug_PTD_05,U_Drug_PTD_06,U_Drug_PTD_07,U_Drug_PTD_08,U_Drug_PTD_09,U_Drug_PTD_10,U_Drug_PTD_11,U_Drug_PTD_12,
/* Medicaid Utilization */
U_Medicaid_Admits,U_Medicaid_Readmits,
U_Medicaid_IP_Days_FFS_01,U_Medicaid_IP_Days_FFS_02,U_Medicaid_IP_Days_FFS_03,U_Medicaid_IP_Days_FFS_04,U_Medicaid_IP_Days_FFS_05,U_Medicaid_IP_Days_FFS_06,U_Medicaid_IP_Days_FFS_07,U_Medicaid_IP_Days_FFS_08,U_Medicaid_IP_Days_FFS_09,U_Medicaid_IP_Days_FFS_10,U_Medicaid_IP_Days_FFS_11,U_Medicaid_IP_Days_FFS_12,
U_Medicaid_Nurs_FAC_FFS_01,U_Medicaid_Nurs_FAC_FFS_02,U_Medicaid_Nurs_FAC_FFS_03,U_Medicaid_Nurs_FAC_FFS_04,U_Medicaid_Nurs_FAC_FFS_05,U_Medicaid_Nurs_FAC_FFS_06,U_Medicaid_Nurs_FAC_FFS_07,U_Medicaid_Nurs_FAC_FFS_08,U_Medicaid_Nurs_FAC_FFS_09,U_Medicaid_Nurs_FAC_FFS_10,U_Medicaid_Nurs_FAC_FFS_11,U_Medicaid_Nurs_FAC_FFS_12,
U_Medicaid_HH_Vst_FFS_01,U_Medicaid_HH_Vst_FFS_02,U_Medicaid_HH_Vst_FFS_03,U_Medicaid_HH_Vst_FFS_04,U_Medicaid_HH_Vst_FFS_05,U_Medicaid_HH_Vst_FFS_06,U_Medicaid_HH_Vst_FFS_07,U_Medicaid_HH_Vst_FFS_08,U_Medicaid_HH_Vst_FFS_09,U_Medicaid_HH_Vst_FFS_10,U_Medicaid_HH_Vst_FFS_11,U_Medicaid_HH_Vst_FFS_12,
U_Medicaid_IER_Vst_01,U_Medicaid_IER_Vst_02,U_Medicaid_IER_Vst_03,U_Medicaid_IER_Vst_04,U_Medicaid_IER_Vst_05,U_Medicaid_IER_Vst_06,U_Medicaid_IER_Vst_07,U_Medicaid_IER_Vst_08,U_Medicaid_IER_Vst_09,U_Medicaid_IER_Vst_10,U_Medicaid_IER_Vst_11,U_Medicaid_IER_Vst_12,
U_Medicaid_OER_Vst_01,U_Medicaid_OER_Vst_02,U_Medicaid_OER_Vst_03,U_Medicaid_OER_Vst_04,U_Medicaid_OER_Vst_05,U_Medicaid_OER_Vst_06,U_Medicaid_OER_Vst_07,U_Medicaid_OER_Vst_08,U_Medicaid_OER_Vst_09,U_Medicaid_OER_Vst_10,U_Medicaid_OER_Vst_11,U_Medicaid_OER_Vst_12,
U_Medicaid_Drug_RX_FFS_01,U_Medicaid_Drug_RX_FFS_02,U_Medicaid_Drug_RX_FFS_03,U_Medicaid_Drug_RX_FFS_04,U_Medicaid_Drug_RX_FFS_05,U_Medicaid_Drug_RX_FFS_06,U_Medicaid_Drug_RX_FFS_07,U_Medicaid_Drug_RX_FFS_08,U_Medicaid_Drug_RX_FFS_09,U_Medicaid_Drug_RX_FFS_10,U_Medicaid_Drug_RX_FFS_11,U_Medicaid_Drug_RX_FFS_12,


/* Medicare and Medicaid Utilization */
U_COMM_MH_CNT, /* Number of Community Mental Health Days */
U_RES_MH_CNT  /* Number of Residential Mental Health Days */


from MMleads.Mml_bene&yr.
where  E_MME_Type in (5) ;
quit;

* CCW; 
proc sql;
create table temp2&yr. as
select a.*,b.HYPTHY_COMBINED,b.AMI_COMBINED,b.ALZ_COMBINED,b.ANEMIA_COMBINED,b.ASTHMA_COMBINED,b.AFIB_COMBINED,b.HYPPLA_COMBINED,
b.CAT_COMBINED,b.CKD_COMBINED,b.COPD_COMBINED,b.CHF_COMBINED,b.DEPR_COMBINED,b.DIAB_COMBINED,b.GLCM_COMBINED,b.HFRAC_COMBINED,
b.HYPLIP_COMBINED,b.HYPTEN_COMBINED,b.IHD_COMBINED,b.OST_COMBINED,b.RAOA_COMBINED,b.STRK_COMBINED,b.BRC_COMBINED,b.CRC_COMBINED,
b.LNGC_COMBINED,b.PRC_COMBINED,b.ENDC_COMBINED,b.ACP_COMBINED,b.ANXI_COMBINED,b.BIPL_COMBINED,b.DEPSN_COMBINED,b.PSDS_COMBINED,
b.PTRA_COMBINED,b.SCHI_COMBINED,b.SCHIOT_COMBINED,b.TOBA_COMBINED,b.AUTISM_COMBINED,b.BRAINJ_COMBINED,b.CERPAL_COMBINED,
b.CYSFIB_COMBINED,b.EPILEP_COMBINED,b.HEARIM_COMBINED,b.INTDIS_COMBINED,b.LEADIS_COMBINED,b.MOBIMP_COMBINED,b.MULSCL_COMBINED,
b.MUSDYS_COMBINED,b.SPIBIF_COMBINED,b.SPIINJ_COMBINED,b.VISUAL_COMBINED,b.ALCO_COMBINED,b.DRUG_COMBINED,b.FIBRO_COMBINED,
b.HEPVIRAL_COMBINED,b.HEPB_ACT_COMBINED,b.HEPB_CHR_COMBINED,b.HEPC_ACT_COMBINED,b.HEPC_CHR_COMBINED,b.HEPC_UNS_COMBINED,
b.HEPD_COMBINED,b.HEPE_COMBINED,b.HIVAIDS_1YR_COMBINED,b.HIVAIDS_COMBINED,b.HIVARV_COMBINED,
b.LEUKLYMPH_COMBINED,b.LIVER_COMBINED,b.MIGRAINE_COMBINED,
b.OBESITY_COMBINED,b.OTHDEL_COMBINED,b.PVD_COMBINED,b.ULCERS_COMBINED
from temp1&yr. a left join mmleads.Mml_cond&yr. b
on a.bene_id=b.bene_id;
quit;
  
 


* Delete died in the year becaue of incomplete cost data;
data temp2&yr.;
set temp2&yr.;

if D_Died=0;

length AgeGroup $10.;
if D_Age<18 then AgeGroup="<18";
else if D_Age<=25 then AgeGroup="18-25";
else if D_Age<=35 then AgeGroup="26-35";
else if D_Age<=45 then AgeGroup="36-45";
else if D_Age<=55 then AgeGroup="46-55";
else if D_Age<=65 then AgeGroup="56-65";
else if D_Age<=75 then AgeGroup="66-75";
else if D_Age<=85 then AgeGroup="76-85";
else if D_Age>=86 then AgeGroup=">=86";
 
zip=D_zip*1;

S_PMT=S_Medicare_PMT+S_Medicaid_PMT;
proc freq ;tables AgeGroup/missing;
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
create table temp3&yr. as
select a.*,b.*
from temp2&yr. a left join Zip  b
on a.zIP =b.zip  ;
quit;

* Define HC (5% 10% 25%);
proc rank data=temp3&yr. out=temp4&yr. percent;
var S_PMT S_Medicare_PMT S_Medicaid_PMT;
ranks pct_PMT pct_Medicare_PMT pct_Medicaid_PMT ;
run;

data temp5&yr.;
set temp4&yr.;
if pct_PMT>=95 then HC5_PMT=1;else HC5_PMT=0;
if pct_PMT>=90 then HC10_PMT=1;else HC10_PMT=0;
if pct_PMT>=75 then HC25_PMT=1;else HC25_PMT=0;

if pct_Medicare_PMT>=95 then HC5_Medicare_PMT=1;else HC5_Medicare_PMT=0;
if pct_Medicare_PMT>=90 then HC10_Medicare_PMT=1;else HC10_Medicare_PMT=0;
if pct_Medicare_PMT>=75 then HC25_Medicare_PMT=1;else HC25_Medicare_PMT=0;

if pct_Medicaid_PMT>=95 then HC5_Medicaid_PMT=1;else HC5_Medicaid_PMT=0;
if pct_Medicaid_PMT>=90 then HC10_Medicaid_PMT=1;else HC10_Medicaid_PMT=0;
if pct_Medicaid_PMT>=75 then HC25_Medicaid_PMT=1;else HC25_Medicaid_PMT=0;
run;


* Preventable spending;
proc sql;
create table temp6&yr. as
select a.*,b.*
from temp5&yr. a left join PQI.Pqi2010 b
on a.bene_id=b.bene_id;
quit;

data temp7&yr.;
set temp6&yr.;
 
array try {39} N_TAPQ01 TAPQ01Spending 
               N_TAPQ02 TAPQ02Spending 
               N_TAPQ03 TAPQ03Spending 
			   N_TAPQ05 TAPQ05Spending 
			   N_TAPQ07 TAPQ07Spending 
			   N_TAPQ08 TAPQ08Spending 
			   N_TAPQ10 TAPQ10Spending 
			   N_TAPQ11 TAPQ11Spending 
               N_TAPQ12 TAPQ12Spending
               N_TAPQ13 TAPQ13Spending 
               N_TAPQ14 TAPQ14Spending 
               N_TAPQ15 TAPQ15Spending 
               N_TAPQ16 TAPQ16Spending 
               N_TAPQ90 TAPQ90Spending 
               N_TAPQ91 TAPQ91Spending
               N_TAPQ92 TAPQ92Spending 
IPSpending OPSpending CarSpending HHASpending SNFSpending HspcSpending  DMESpending;
do i=1 to 39;
if try{i}<0 then try{i}=0;
end;
drop i;

TotSpending=IPSpending+OPSpending+CarSpending+HHASpending+SNFSpending+HspcSpending+DMESpending;
run;




* Segmentation;
proc sql;
create table temp8&yr. as
select *,
case when bene_id in (select bene_id from denom.dnmntr2009 where FIVEPCT='Y') then 1 else 0 end as FIVEPCT2009,
case when bene_id in (select bene_id from MMleads.Mml_bene2009 where E_MedicareFFS=1) then 1 else 0 end as E_MedicareFFS2009 
from temp7&yr. ;
quit;

proc sql;
create table temp9&yr. as
select a.*,b.*
from temp8&yr. a left join data.Frailty2009 b
on a.bene_id=b.bene_id ;
quit;
 
proc sql;
create table temp10&yr. as
select a.*,b.*
from temp9&yr. a left join data.CC2009 b
on a.bene_id=b.bene_id ;
quit;

 
*****************Segmentation Definition:
Seg 1: Age <65 
Seg 2: Frailty Indicator total 12 >=2 
Seg 3: Major CC >=3
Seg 4: Major CC 1 or 2 (>0 & <3)
Seg 5: Major CC=0 and Minor CC >0
Seg 6: Major CC=0 and Minor CC=0

Major CC: amiihd chrkid chf dementia lung psydis strk spchrtarr
Minior CC: amputat arthrit artopen bph cancer diabetes endo eyedis 
                 hemadis hyperlip hyperten immunedis ibd liver neuromusc osteo 
                 paralyt sknulc sa thyroid vascdis 
*************************************************************************************************;
data MMleads.Data&yr.;
length seg $50.;
set temp10&yr.;

* Only <5% bene qualify seg definition;
if E_MedicareFFS=1 and E_MedicaidFFS=1 and E_MedicareFFS2009=1 and FIVEPCT2009=1 then qualify_seg=1;else qualify_seg=0;

*E_MedicareFFS=1 and E_MedicaidFFS=1 and E_MEDICAIDPHP=0 and;

array f{12} frailty1 frailty2 frailty3 frailty4 frailty5 frailty6 frailty7 frailty8 frailty9 frailty10 frailty11 frailty12;
array CC{30} 
amiihd amputat arthrit  artopen  bph  
cancer  chrkid  chf  cystfib  dementia  
diabetes  endo  eyedis hemadis  hyperlip  
hyperten  immunedis  ibd liver  lung   
neuromusc  osteo  paralyt  psydis  sknulc 
spchrtarr  strk sa  thyroid  vascdis;
do i=1 to 12 ;
if f{i}=. then f{i}=0;
end;
do j=1 to 30;
if CC{j}=. then CC{j}=0;
end;
drop i j;

N_Frailty=frailty1+ frailty2+ frailty3+ frailty4+ frailty5+ frailty6+ frailty7+ frailty8+ frailty9+ frailty10+ frailty11+ frailty12;
N_MajorCC=amiihd+ chrkid+ chf+ dementia+ lung+ psydis+ strk+ spchrtarr;
N_MinorCC=amputat+ arthrit+ artopen+ bph+ cancer+ diabetes+ endo+ eyedis +
                 hemadis+ hyperlip+ hyperten+ immunedis+ ibd+ liver+ neuromusc+ osteo+ 
                 paralyt+ sknulc+ sa+ thyroid+ vascdis;

* Segmentation  ;
if qualify_seg=1 then do;

* Segmentation for <65 only;
if D_Age<65 then do;
	if N_Frailty>=2 then seg ="1.1 Under 65,2 or more frailty";
	else if N_MajorCC>=3 then seg ="1.2 Under 65,less than 2 frailty,3 or more major CC";
	else if N_MajorCC=1 or N_MajorCC=2 then seg ="1.3 Under 65,less than 2 frailty,1 or 2 major CC";
	else if N_MajorCC=0 and N_MinorCC>0 then seg ="1.4 Under 65,less than 2 frailty,no major CC,some minor CC";
	else if N_MinorCC=0 then seg ="1.5 Under 65,less than 2 frailty,no major CC,no minor CC";
end;

else if D_Age>=65 then do;
	if N_Frailty>=2 then seg="2.1 Over 65,2 or more frailty";
	else if N_MajorCC>=3 then seg="2.2 Over 65,less than 2 frailty,3 or more major CC";
	else if N_MajorCC=1 or N_MajorCC=2 then seg="2.3 Over 65,less than 2 frailty,1 or 2 major CC";
	else if N_MinorCC>0 then seg="2.4 Over 65,less than 2 frailty,no major CC,some minor CC";
	else if N_MinorCC=0 then seg="2.5 Over 65,less than 2 frailty,no major CC,no minor CC";
end;

end;
label seg="Segmentation ";

* change number of claims to indicators;
array cond {70} 
HYPTHY_COMBINED AMI_COMBINED ALZ_COMBINED ANEMIA_COMBINED ASTHMA_COMBINED 
AFIB_COMBINED HYPPLA_COMBINED CAT_COMBINED CKD_COMBINED COPD_COMBINED 
CHF_COMBINED DEPR_COMBINED DIAB_COMBINED GLCM_COMBINED HFRAC_COMBINED 
HYPLIP_COMBINED HYPTEN_COMBINED IHD_COMBINED OST_COMBINED RAOA_COMBINED 
STRK_COMBINED BRC_COMBINED CRC_COMBINED LNGC_COMBINED PRC_COMBINED 
ENDC_COMBINED ACP_COMBINED ANXI_COMBINED BIPL_COMBINED DEPSN_COMBINED 
PSDS_COMBINED PTRA_COMBINED SCHI_COMBINED SCHIOT_COMBINED TOBA_COMBINED 
AUTISM_COMBINED BRAINJ_COMBINED CERPAL_COMBINED CYSFIB_COMBINED EPILEP_COMBINED 
HEARIM_COMBINED INTDIS_COMBINED LEADIS_COMBINED MOBIMP_COMBINED MULSCL_COMBINED 
MUSDYS_COMBINED SPIBIF_COMBINED SPIINJ_COMBINED VISUAL_COMBINED ALCO_COMBINED 
DRUG_COMBINED FIBRO_COMBINED HEPVIRAL_COMBINED HEPB_ACT_COMBINED HEPB_CHR_COMBINED 
HEPC_ACT_COMBINED HEPC_CHR_COMBINED HEPC_UNS_COMBINED HEPD_COMBINED HEPE_COMBINED 
HIVAIDS_1YR_COMBINED HIVAIDS_COMBINED HIVARV_COMBINED LEUKLYMPH_COMBINED LIVER_COMBINED 
MIGRAINE_COMBINED OBESITY_COMBINED OTHDEL_COMBINED PVD_COMBINED ULCERS_COMBINED;
do j=1 to 70;
if cond{j} in (1,3) then cond{j}=1;
else cond{j}=0;
end;
drop j;
proc freq; 
table seg qualify_seg seg*qualify_seg
HYPTHY_COMBINED AMI_COMBINED ALZ_COMBINED ANEMIA_COMBINED ASTHMA_COMBINED 
AFIB_COMBINED HYPPLA_COMBINED CAT_COMBINED CKD_COMBINED COPD_COMBINED 
CHF_COMBINED DEPR_COMBINED DIAB_COMBINED GLCM_COMBINED HFRAC_COMBINED 
HYPLIP_COMBINED HYPTEN_COMBINED IHD_COMBINED OST_COMBINED RAOA_COMBINED 
STRK_COMBINED BRC_COMBINED CRC_COMBINED LNGC_COMBINED PRC_COMBINED 
ENDC_COMBINED ACP_COMBINED ANXI_COMBINED BIPL_COMBINED DEPSN_COMBINED 
PSDS_COMBINED PTRA_COMBINED SCHI_COMBINED SCHIOT_COMBINED TOBA_COMBINED 
AUTISM_COMBINED BRAINJ_COMBINED CERPAL_COMBINED CYSFIB_COMBINED EPILEP_COMBINED 
HEARIM_COMBINED INTDIS_COMBINED LEADIS_COMBINED MOBIMP_COMBINED MULSCL_COMBINED 
MUSDYS_COMBINED SPIBIF_COMBINED SPIINJ_COMBINED VISUAL_COMBINED ALCO_COMBINED 
DRUG_COMBINED FIBRO_COMBINED HEPVIRAL_COMBINED HEPB_ACT_COMBINED HEPB_CHR_COMBINED 
HEPC_ACT_COMBINED HEPC_CHR_COMBINED HEPC_UNS_COMBINED HEPD_COMBINED HEPE_COMBINED 
HIVAIDS_1YR_COMBINED HIVAIDS_COMBINED HIVARV_COMBINED LEUKLYMPH_COMBINED LIVER_COMBINED 
MIGRAINE_COMBINED OBESITY_COMBINED OTHDEL_COMBINED PVD_COMBINED ULCERS_COMBINED/missing;
run;
 
*****************************************
   Which Year?
*****************************************;

%let yr=2009;

******************************************
	Beneficiary Sample Selection
******************************************;

* Select variabels in bene file;
proc sql;
create table temp1&yr. as
select bene_id, 
/* demographics */
D_Died, D_Age, D_Sex, D_Medicare_Race, D_Medicaid_Race, D_ZIP, D_State_CD, D_COUNTY, D_Disability_CD, D_Disability_Primary_CD, D_Disability_Secondary_CD,
E_MME_Type, E_MedicaidFFS,	E_MedicaidPHP, E_MedicareFFS, E_MS_CD,  E_BOE, 

/* Total Medicare Spending */ 
S_Medicare_PMT, /*Annual Medicare FFS payments */
S_Medicare_Bene_PMT, /* Annual Medicare coinsurance and deductible FFS payments */

/* Total Medicaid Spending */
S_Medicaid_PMT, /* Annual Medicaid Managed Care and FFS payments */
S_Medicaid_Bene_PMT, /* Annual Medicaid coinsurance and deductible payments. */
S_Medicaid_FFS_PMT, /* Annual Medicaid FFS payments */


/* Medicare Utilization */
U_Medicare_Admits, U_Medicare_Readmits, 
U_Acute_Cov_Day_CNT_01,U_Acute_Cov_Day_CNT_02,U_Acute_Cov_Day_CNT_03,U_Acute_Cov_Day_CNT_04,U_Acute_Cov_Day_CNT_05,U_Acute_Cov_Day_CNT_06,U_Acute_Cov_Day_CNT_07,U_Acute_Cov_Day_CNT_08,U_Acute_Cov_Day_CNT_09,U_Acute_Cov_Day_CNT_10,U_Acute_Cov_Day_CNT_11,U_Acute_Cov_Day_CNT_12,
U_SNF_Day_CNT_01,U_SNF_Day_CNT_02,U_SNF_Day_CNT_03,U_SNF_Day_CNT_04,U_SNF_Day_CNT_05,U_SNF_Day_CNT_06,U_SNF_Day_CNT_07,U_SNF_Day_CNT_08,U_SNF_Day_CNT_09,U_SNF_Day_CNT_10,U_SNF_Day_CNT_11,U_SNF_Day_CNT_12,
U_PAC_OTH_Day_CNT_01,U_PAC_OTH_Day_CNT_02,U_PAC_OTH_Day_CNT_03,U_PAC_OTH_Day_CNT_04,U_PAC_OTH_Day_CNT_05,U_PAC_OTH_Day_CNT_06,U_PAC_OTH_Day_CNT_07,U_PAC_OTH_Day_CNT_08,U_PAC_OTH_Day_CNT_09,U_PAC_OTH_Day_CNT_10,U_PAC_OTH_Day_CNT_11,U_PAC_OTH_Day_CNT_12,
U_Hospice_Day_CNT_01,U_Hospice_Day_CNT_02,U_Hospice_Day_CNT_03,U_Hospice_Day_CNT_04,U_Hospice_Day_CNT_05,U_Hospice_Day_CNT_06,U_Hospice_Day_CNT_07,U_Hospice_Day_CNT_08,U_Hospice_Day_CNT_09,U_Hospice_Day_CNT_10,U_Hospice_Day_CNT_11,U_Hospice_Day_CNT_12,
U_Medicare_HH_VST_CNT_01,U_Medicare_HH_VST_CNT_02,U_Medicare_HH_VST_CNT_03,U_Medicare_HH_VST_CNT_04,U_Medicare_HH_VST_CNT_05,U_Medicare_HH_VST_CNT_06,U_Medicare_HH_VST_CNT_07,U_Medicare_HH_VST_CNT_08,U_Medicare_HH_VST_CNT_09,U_Medicare_HH_VST_CNT_10,U_Medicare_HH_VST_CNT_11,U_Medicare_HH_VST_CNT_12,
U_Medicare_IER_CNT_01,U_Medicare_IER_CNT_02,U_Medicare_IER_CNT_03,U_Medicare_IER_CNT_04,U_Medicare_IER_CNT_05,U_Medicare_IER_CNT_06,U_Medicare_IER_CNT_07,U_Medicare_IER_CNT_08,U_Medicare_IER_CNT_09,U_Medicare_IER_CNT_10,U_Medicare_IER_CNT_11,U_Medicare_IER_CNT_12,
U_Medicare_OER_CNT_01,U_Medicare_OER_CNT_02,U_Medicare_OER_CNT_03,U_Medicare_OER_CNT_04,U_Medicare_OER_CNT_05,U_Medicare_OER_CNT_06,U_Medicare_OER_CNT_07,U_Medicare_OER_CNT_08,U_Medicare_OER_CNT_09,U_Medicare_OER_CNT_10,U_Medicare_OER_CNT_11,U_Medicare_OER_CNT_12,
U_Phys_Vst_01,U_Phys_Vst_02,U_Phys_Vst_03,U_Phys_Vst_04,U_Phys_Vst_05,U_Phys_Vst_06,U_Phys_Vst_07,U_Phys_Vst_08,U_Phys_Vst_09,U_Phys_Vst_10,U_Phys_Vst_11,U_Phys_Vst_12,
U_DME_Vst_01,U_DME_Vst_02,U_DME_Vst_03,U_DME_Vst_04,U_DME_Vst_05,U_DME_Vst_06,U_DME_Vst_07,U_DME_Vst_08,U_DME_Vst_09,U_DME_Vst_10,U_DME_Vst_11,U_DME_Vst_12,
U_Drug_PTD_01,U_Drug_PTD_02,U_Drug_PTD_03,U_Drug_PTD_04,U_Drug_PTD_05,U_Drug_PTD_06,U_Drug_PTD_07,U_Drug_PTD_08,U_Drug_PTD_09,U_Drug_PTD_10,U_Drug_PTD_11,U_Drug_PTD_12,
/* Medicaid Utilization */
U_Medicaid_Admits,U_Medicaid_Readmits,
U_Medicaid_IP_Days_FFS_01,U_Medicaid_IP_Days_FFS_02,U_Medicaid_IP_Days_FFS_03,U_Medicaid_IP_Days_FFS_04,U_Medicaid_IP_Days_FFS_05,U_Medicaid_IP_Days_FFS_06,U_Medicaid_IP_Days_FFS_07,U_Medicaid_IP_Days_FFS_08,U_Medicaid_IP_Days_FFS_09,U_Medicaid_IP_Days_FFS_10,U_Medicaid_IP_Days_FFS_11,U_Medicaid_IP_Days_FFS_12,
U_Medicaid_Nurs_FAC_FFS_01,U_Medicaid_Nurs_FAC_FFS_02,U_Medicaid_Nurs_FAC_FFS_03,U_Medicaid_Nurs_FAC_FFS_04,U_Medicaid_Nurs_FAC_FFS_05,U_Medicaid_Nurs_FAC_FFS_06,U_Medicaid_Nurs_FAC_FFS_07,U_Medicaid_Nurs_FAC_FFS_08,U_Medicaid_Nurs_FAC_FFS_09,U_Medicaid_Nurs_FAC_FFS_10,U_Medicaid_Nurs_FAC_FFS_11,U_Medicaid_Nurs_FAC_FFS_12,
U_Medicaid_HH_Vst_FFS_01,U_Medicaid_HH_Vst_FFS_02,U_Medicaid_HH_Vst_FFS_03,U_Medicaid_HH_Vst_FFS_04,U_Medicaid_HH_Vst_FFS_05,U_Medicaid_HH_Vst_FFS_06,U_Medicaid_HH_Vst_FFS_07,U_Medicaid_HH_Vst_FFS_08,U_Medicaid_HH_Vst_FFS_09,U_Medicaid_HH_Vst_FFS_10,U_Medicaid_HH_Vst_FFS_11,U_Medicaid_HH_Vst_FFS_12,
U_Medicaid_IER_Vst_01,U_Medicaid_IER_Vst_02,U_Medicaid_IER_Vst_03,U_Medicaid_IER_Vst_04,U_Medicaid_IER_Vst_05,U_Medicaid_IER_Vst_06,U_Medicaid_IER_Vst_07,U_Medicaid_IER_Vst_08,U_Medicaid_IER_Vst_09,U_Medicaid_IER_Vst_10,U_Medicaid_IER_Vst_11,U_Medicaid_IER_Vst_12,
U_Medicaid_OER_Vst_01,U_Medicaid_OER_Vst_02,U_Medicaid_OER_Vst_03,U_Medicaid_OER_Vst_04,U_Medicaid_OER_Vst_05,U_Medicaid_OER_Vst_06,U_Medicaid_OER_Vst_07,U_Medicaid_OER_Vst_08,U_Medicaid_OER_Vst_09,U_Medicaid_OER_Vst_10,U_Medicaid_OER_Vst_11,U_Medicaid_OER_Vst_12,
U_Medicaid_Drug_RX_FFS_01,U_Medicaid_Drug_RX_FFS_02,U_Medicaid_Drug_RX_FFS_03,U_Medicaid_Drug_RX_FFS_04,U_Medicaid_Drug_RX_FFS_05,U_Medicaid_Drug_RX_FFS_06,U_Medicaid_Drug_RX_FFS_07,U_Medicaid_Drug_RX_FFS_08,U_Medicaid_Drug_RX_FFS_09,U_Medicaid_Drug_RX_FFS_10,U_Medicaid_Drug_RX_FFS_11,U_Medicaid_Drug_RX_FFS_12,


/* Medicare and Medicaid Utilization */
U_COMM_MH_CNT, /* Number of Community Mental Health Days */
U_RES_MH_CNT  /* Number of Residential Mental Health Days */


from MMleads.Mml_bene&yr.
where  E_MME_Type in (5) ;
quit;

* CCW; 
proc sql;
create table temp2&yr. as
select a.*,b.HYPTHY_COMBINED,b.AMI_COMBINED,b.ALZ_COMBINED,b.ANEMIA_COMBINED,b.ASTHMA_COMBINED,b.AFIB_COMBINED,b.HYPPLA_COMBINED,
b.CAT_COMBINED,b.CKD_COMBINED,b.COPD_COMBINED,b.CHF_COMBINED,b.DEPR_COMBINED,b.DIAB_COMBINED,b.GLCM_COMBINED,b.HFRAC_COMBINED,
b.HYPLIP_COMBINED,b.HYPTEN_COMBINED,b.IHD_COMBINED,b.OST_COMBINED,b.RAOA_COMBINED,b.STRK_COMBINED,b.BRC_COMBINED,b.CRC_COMBINED,
b.LNGC_COMBINED,b.PRC_COMBINED,b.ENDC_COMBINED,b.ACP_COMBINED,b.ANXI_COMBINED,b.BIPL_COMBINED,b.DEPSN_COMBINED,b.PSDS_COMBINED,
b.PTRA_COMBINED,b.SCHI_COMBINED,b.SCHIOT_COMBINED,b.TOBA_COMBINED,b.AUTISM_COMBINED,b.BRAINJ_COMBINED,b.CERPAL_COMBINED,
b.CYSFIB_COMBINED,b.EPILEP_COMBINED,b.HEARIM_COMBINED,b.INTDIS_COMBINED,b.LEADIS_COMBINED,b.MOBIMP_COMBINED,b.MULSCL_COMBINED,
b.MUSDYS_COMBINED,b.SPIBIF_COMBINED,b.SPIINJ_COMBINED,b.VISUAL_COMBINED,b.ALCO_COMBINED,b.DRUG_COMBINED,b.FIBRO_COMBINED,
b.HEPVIRAL_COMBINED,b.HEPB_ACT_COMBINED,b.HEPB_CHR_COMBINED,b.HEPC_ACT_COMBINED,b.HEPC_CHR_COMBINED,b.HEPC_UNS_COMBINED,
b.HEPD_COMBINED,b.HEPE_COMBINED,b.HIVAIDS_1YR_COMBINED,b.HIVAIDS_COMBINED,b.HIVARV_COMBINED,
b.HIVTSTNG_CAT1,b.HIVTSTNG_CAT2,b.HIVTSTNG_CAT3,b.HIVTSTNG_CAT4,b.LEUKLYMPH_COMBINED,b.LIVER_COMBINED,b.MIGRAINE_COMBINED,
b.OBESITY_COMBINED,b.OTHDEL_COMBINED,b.PVD_COMBINED,b.ULCERS_COMBINED
from temp1&yr. a left join mmleads.Mml_cond&yr. b
on a.bene_id=b.bene_id;
quit;
* Delete died in the year becaue of incomplete cost data;
data temp2&yr.;
set temp2&yr.;

if D_Died=0;

length AgeGroup $10.;
if D_Age<18 then AgeGroup="<18";
else if D_Age<=25 then AgeGroup="18-25";
else if D_Age<=35 then AgeGroup="26-35";
else if D_Age<=45 then AgeGroup="36-45";
else if D_Age<=55 then AgeGroup="46-55";
else if D_Age<=65 then AgeGroup="56-65";
else if D_Age<=75 then AgeGroup="66-75";
else if D_Age<=85 then AgeGroup="76-85";
else if D_Age>=86 then AgeGroup=">=86";
 
zip=D_zip*1;

S_PMT=S_Medicare_PMT+S_Medicaid_PMT;
proc freq ;tables AgeGroup/missing;
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
create table temp3&yr. as
select a.*,b.*
from temp2&yr. a left join Zip  b
on a.zIP =b.zip  ;
quit;

* Define HC (5% 10% 25%);
proc rank data=temp3&yr. out=temp4&yr. percent;
var S_PMT S_Medicare_PMT S_Medicaid_PMT;
ranks pct_PMT pct_Medicare_PMT pct_Medicaid_PMT ;
run;

data temp5&yr.;
set temp4&yr.;
if pct_PMT>=95 then HC5_PMT=1;else HC5_PMT=0;
if pct_PMT>=90 then HC10_PMT=1;else HC10_PMT=0;
if pct_PMT>=75 then HC25_PMT=1;else HC25_PMT=0;

if pct_Medicare_PMT>=95 then HC5_Medicare_PMT=1;else HC5_Medicare_PMT=0;
if pct_Medicare_PMT>=90 then HC10_Medicare_PMT=1;else HC10_Medicare_PMT=0;
if pct_Medicare_PMT>=75 then HC25_Medicare_PMT=1;else HC25_Medicare_PMT=0;

if pct_Medicaid_PMT>=95 then HC5_Medicaid_PMT=1;else HC5_Medicaid_PMT=0;
if pct_Medicaid_PMT>=90 then HC10_Medicaid_PMT=1;else HC10_Medicaid_PMT=0;
if pct_Medicaid_PMT>=75 then HC25_Medicaid_PMT=1;else HC25_Medicaid_PMT=0;
run;


* Preventable spending;
proc sql;
create table temp6&yr. as
select a.*,b.*
from temp5&yr. a left join PQI.Pqi2010 b
on a.bene_id=b.bene_id;
quit;

data MMLeads.data&yr.;
set temp6&yr.;
 
array try {39} N_TAPQ01 TAPQ01Spending 
               N_TAPQ02 TAPQ02Spending 
               N_TAPQ03 TAPQ03Spending 
			   N_TAPQ05 TAPQ05Spending 
			   N_TAPQ07 TAPQ07Spending 
			   N_TAPQ08 TAPQ08Spending 
			   N_TAPQ10 TAPQ10Spending 
			   N_TAPQ11 TAPQ11Spending 
               N_TAPQ12 TAPQ12Spending
               N_TAPQ13 TAPQ13Spending 
               N_TAPQ14 TAPQ14Spending 
               N_TAPQ15 TAPQ15Spending 
               N_TAPQ16 TAPQ16Spending 
               N_TAPQ90 TAPQ90Spending 
               N_TAPQ91 TAPQ91Spending
               N_TAPQ92 TAPQ92Spending 
IPSpending OPSpending CarSpending HHASpending SNFSpending HspcSpending  DMESpending;
do i=1 to 39;
if try{i}<0 then try{i}=0;
end;
drop i;

TotSpending=IPSpending+OPSpending+CarSpending+HHASpending+SNFSpending+HspcSpending+DMESpending;
run;




*****************************************
   Which Year?
*****************************************;

%let yr=2008;

******************************************
	Beneficiary Sample Selection
******************************************;

* Select variabels in bene file;
proc sql;
create table temp1&yr. as
select bene_id, 
/* demographics */
D_Died, D_Age, D_Sex, D_Medicare_Race, D_Medicaid_Race, D_ZIP, D_State_CD, D_COUNTY, D_Disability_CD, D_Disability_Primary_CD, D_Disability_Secondary_CD,
E_MME_Type, E_MedicaidFFS,	E_MedicaidPHP, E_MedicareFFS, E_MS_CD,  E_BOE, 

/* Total Medicare Spending */ 
S_Medicare_PMT, /*Annual Medicare FFS payments */
S_Medicare_Bene_PMT, /* Annual Medicare coinsurance and deductible FFS payments */

/* Total Medicaid Spending */
S_Medicaid_PMT, /* Annual Medicaid Managed Care and FFS payments */
S_Medicaid_Bene_PMT, /* Annual Medicaid coinsurance and deductible payments. */
S_Medicaid_FFS_PMT, /* Annual Medicaid FFS payments */


/* Medicare Utilization */
U_Medicare_Admits, U_Medicare_Readmits, 
U_Acute_Cov_Day_CNT_01,U_Acute_Cov_Day_CNT_02,U_Acute_Cov_Day_CNT_03,U_Acute_Cov_Day_CNT_04,U_Acute_Cov_Day_CNT_05,U_Acute_Cov_Day_CNT_06,U_Acute_Cov_Day_CNT_07,U_Acute_Cov_Day_CNT_08,U_Acute_Cov_Day_CNT_09,U_Acute_Cov_Day_CNT_10,U_Acute_Cov_Day_CNT_11,U_Acute_Cov_Day_CNT_12,
U_SNF_Day_CNT_01,U_SNF_Day_CNT_02,U_SNF_Day_CNT_03,U_SNF_Day_CNT_04,U_SNF_Day_CNT_05,U_SNF_Day_CNT_06,U_SNF_Day_CNT_07,U_SNF_Day_CNT_08,U_SNF_Day_CNT_09,U_SNF_Day_CNT_10,U_SNF_Day_CNT_11,U_SNF_Day_CNT_12,
U_PAC_OTH_Day_CNT_01,U_PAC_OTH_Day_CNT_02,U_PAC_OTH_Day_CNT_03,U_PAC_OTH_Day_CNT_04,U_PAC_OTH_Day_CNT_05,U_PAC_OTH_Day_CNT_06,U_PAC_OTH_Day_CNT_07,U_PAC_OTH_Day_CNT_08,U_PAC_OTH_Day_CNT_09,U_PAC_OTH_Day_CNT_10,U_PAC_OTH_Day_CNT_11,U_PAC_OTH_Day_CNT_12,
U_Hospice_Day_CNT_01,U_Hospice_Day_CNT_02,U_Hospice_Day_CNT_03,U_Hospice_Day_CNT_04,U_Hospice_Day_CNT_05,U_Hospice_Day_CNT_06,U_Hospice_Day_CNT_07,U_Hospice_Day_CNT_08,U_Hospice_Day_CNT_09,U_Hospice_Day_CNT_10,U_Hospice_Day_CNT_11,U_Hospice_Day_CNT_12,
U_Medicare_HH_VST_CNT_01,U_Medicare_HH_VST_CNT_02,U_Medicare_HH_VST_CNT_03,U_Medicare_HH_VST_CNT_04,U_Medicare_HH_VST_CNT_05,U_Medicare_HH_VST_CNT_06,U_Medicare_HH_VST_CNT_07,U_Medicare_HH_VST_CNT_08,U_Medicare_HH_VST_CNT_09,U_Medicare_HH_VST_CNT_10,U_Medicare_HH_VST_CNT_11,U_Medicare_HH_VST_CNT_12,
U_Medicare_IER_CNT_01,U_Medicare_IER_CNT_02,U_Medicare_IER_CNT_03,U_Medicare_IER_CNT_04,U_Medicare_IER_CNT_05,U_Medicare_IER_CNT_06,U_Medicare_IER_CNT_07,U_Medicare_IER_CNT_08,U_Medicare_IER_CNT_09,U_Medicare_IER_CNT_10,U_Medicare_IER_CNT_11,U_Medicare_IER_CNT_12,
U_Medicare_OER_CNT_01,U_Medicare_OER_CNT_02,U_Medicare_OER_CNT_03,U_Medicare_OER_CNT_04,U_Medicare_OER_CNT_05,U_Medicare_OER_CNT_06,U_Medicare_OER_CNT_07,U_Medicare_OER_CNT_08,U_Medicare_OER_CNT_09,U_Medicare_OER_CNT_10,U_Medicare_OER_CNT_11,U_Medicare_OER_CNT_12,
U_Phys_Vst_01,U_Phys_Vst_02,U_Phys_Vst_03,U_Phys_Vst_04,U_Phys_Vst_05,U_Phys_Vst_06,U_Phys_Vst_07,U_Phys_Vst_08,U_Phys_Vst_09,U_Phys_Vst_10,U_Phys_Vst_11,U_Phys_Vst_12,
U_DME_Vst_01,U_DME_Vst_02,U_DME_Vst_03,U_DME_Vst_04,U_DME_Vst_05,U_DME_Vst_06,U_DME_Vst_07,U_DME_Vst_08,U_DME_Vst_09,U_DME_Vst_10,U_DME_Vst_11,U_DME_Vst_12,
U_Drug_PTD_01,U_Drug_PTD_02,U_Drug_PTD_03,U_Drug_PTD_04,U_Drug_PTD_05,U_Drug_PTD_06,U_Drug_PTD_07,U_Drug_PTD_08,U_Drug_PTD_09,U_Drug_PTD_10,U_Drug_PTD_11,U_Drug_PTD_12,
/* Medicaid Utilization */
U_Medicaid_Admits,U_Medicaid_Readmits,
U_Medicaid_IP_Days_FFS_01,U_Medicaid_IP_Days_FFS_02,U_Medicaid_IP_Days_FFS_03,U_Medicaid_IP_Days_FFS_04,U_Medicaid_IP_Days_FFS_05,U_Medicaid_IP_Days_FFS_06,U_Medicaid_IP_Days_FFS_07,U_Medicaid_IP_Days_FFS_08,U_Medicaid_IP_Days_FFS_09,U_Medicaid_IP_Days_FFS_10,U_Medicaid_IP_Days_FFS_11,U_Medicaid_IP_Days_FFS_12,
U_Medicaid_Nurs_FAC_FFS_01,U_Medicaid_Nurs_FAC_FFS_02,U_Medicaid_Nurs_FAC_FFS_03,U_Medicaid_Nurs_FAC_FFS_04,U_Medicaid_Nurs_FAC_FFS_05,U_Medicaid_Nurs_FAC_FFS_06,U_Medicaid_Nurs_FAC_FFS_07,U_Medicaid_Nurs_FAC_FFS_08,U_Medicaid_Nurs_FAC_FFS_09,U_Medicaid_Nurs_FAC_FFS_10,U_Medicaid_Nurs_FAC_FFS_11,U_Medicaid_Nurs_FAC_FFS_12,
U_Medicaid_HH_Vst_FFS_01,U_Medicaid_HH_Vst_FFS_02,U_Medicaid_HH_Vst_FFS_03,U_Medicaid_HH_Vst_FFS_04,U_Medicaid_HH_Vst_FFS_05,U_Medicaid_HH_Vst_FFS_06,U_Medicaid_HH_Vst_FFS_07,U_Medicaid_HH_Vst_FFS_08,U_Medicaid_HH_Vst_FFS_09,U_Medicaid_HH_Vst_FFS_10,U_Medicaid_HH_Vst_FFS_11,U_Medicaid_HH_Vst_FFS_12,
U_Medicaid_IER_Vst_01,U_Medicaid_IER_Vst_02,U_Medicaid_IER_Vst_03,U_Medicaid_IER_Vst_04,U_Medicaid_IER_Vst_05,U_Medicaid_IER_Vst_06,U_Medicaid_IER_Vst_07,U_Medicaid_IER_Vst_08,U_Medicaid_IER_Vst_09,U_Medicaid_IER_Vst_10,U_Medicaid_IER_Vst_11,U_Medicaid_IER_Vst_12,
U_Medicaid_OER_Vst_01,U_Medicaid_OER_Vst_02,U_Medicaid_OER_Vst_03,U_Medicaid_OER_Vst_04,U_Medicaid_OER_Vst_05,U_Medicaid_OER_Vst_06,U_Medicaid_OER_Vst_07,U_Medicaid_OER_Vst_08,U_Medicaid_OER_Vst_09,U_Medicaid_OER_Vst_10,U_Medicaid_OER_Vst_11,U_Medicaid_OER_Vst_12,
U_Medicaid_Drug_RX_FFS_01,U_Medicaid_Drug_RX_FFS_02,U_Medicaid_Drug_RX_FFS_03,U_Medicaid_Drug_RX_FFS_04,U_Medicaid_Drug_RX_FFS_05,U_Medicaid_Drug_RX_FFS_06,U_Medicaid_Drug_RX_FFS_07,U_Medicaid_Drug_RX_FFS_08,U_Medicaid_Drug_RX_FFS_09,U_Medicaid_Drug_RX_FFS_10,U_Medicaid_Drug_RX_FFS_11,U_Medicaid_Drug_RX_FFS_12,


/* Medicare and Medicaid Utilization */
U_COMM_MH_CNT, /* Number of Community Mental Health Days */
U_RES_MH_CNT  /* Number of Residential Mental Health Days */


from MMleads.Mml_bene&yr.
where  E_MME_Type in (5) ;
quit;

* CCW; 
proc sql;
create table temp2&yr. as
select a.*,b.HYPTHY_COMBINED,b.AMI_COMBINED,b.ALZ_COMBINED,b.ANEMIA_COMBINED,b.ASTHMA_COMBINED,b.AFIB_COMBINED,b.HYPPLA_COMBINED,
b.CAT_COMBINED,b.CKD_COMBINED,b.COPD_COMBINED,b.CHF_COMBINED,b.DEPR_COMBINED,b.DIAB_COMBINED,b.GLCM_COMBINED,b.HFRAC_COMBINED,
b.HYPLIP_COMBINED,b.HYPTEN_COMBINED,b.IHD_COMBINED,b.OST_COMBINED,b.RAOA_COMBINED,b.STRK_COMBINED,b.BRC_COMBINED,b.CRC_COMBINED,
b.LNGC_COMBINED,b.PRC_COMBINED,b.ENDC_COMBINED,b.ACP_COMBINED,b.ANXI_COMBINED,b.BIPL_COMBINED,b.DEPSN_COMBINED,b.PSDS_COMBINED,
b.PTRA_COMBINED,b.SCHI_COMBINED,b.SCHIOT_COMBINED,b.TOBA_COMBINED,b.AUTISM_COMBINED,b.BRAINJ_COMBINED,b.CERPAL_COMBINED,
b.CYSFIB_COMBINED,b.EPILEP_COMBINED,b.HEARIM_COMBINED,b.INTDIS_COMBINED,b.LEADIS_COMBINED,b.MOBIMP_COMBINED,b.MULSCL_COMBINED,
b.MUSDYS_COMBINED,b.SPIBIF_COMBINED,b.SPIINJ_COMBINED,b.VISUAL_COMBINED,b.ALCO_COMBINED,b.DRUG_COMBINED,b.FIBRO_COMBINED,
b.HEPVIRAL_COMBINED,b.HEPB_ACT_COMBINED,b.HEPB_CHR_COMBINED,b.HEPC_ACT_COMBINED,b.HEPC_CHR_COMBINED,b.HEPC_UNS_COMBINED,
b.HEPD_COMBINED,b.HEPE_COMBINED,b.HIVAIDS_1YR_COMBINED,b.HIVAIDS_COMBINED,b.HIVARV_COMBINED,
b.HIVTSTNG_CAT1,b.HIVTSTNG_CAT2,b.HIVTSTNG_CAT3,b.HIVTSTNG_CAT4,b.LEUKLYMP_COMBINED,b.LIVER_COMBINED,b.MIGRAINE_COMBINED,
b.OBESITY_COMBINED,b.OTHDEL_COMBINED,b.PVD_COMBINED,b.ULCERS_COMBINED
from temp1&yr. a left join mmleads.Mml_cond&yr. b
on a.bene_id=b.bene_id;
quit;
* Delete died in the year becaue of incomplete cost data;
data temp2&yr.;
set temp2&yr.;

if D_Died=0;

length AgeGroup $10.;
if D_Age<18 then AgeGroup="<18";
else if D_Age<=25 then AgeGroup="18-25";
else if D_Age<=35 then AgeGroup="26-35";
else if D_Age<=45 then AgeGroup="36-45";
else if D_Age<=55 then AgeGroup="46-55";
else if D_Age<=65 then AgeGroup="56-65";
else if D_Age<=75 then AgeGroup="66-75";
else if D_Age<=85 then AgeGroup="76-85";
else if D_Age>=86 then AgeGroup=">=86";
 
zip=D_zip*1;

S_PMT=S_Medicare_PMT+S_Medicaid_PMT;
proc freq ;tables AgeGroup/missing;
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
create table temp3&yr. as
select a.*,b.*
from temp2&yr. a left join Zip  b
on a.zIP =b.zip  ;
quit;

* Define HC (5% 10% 25%);
proc rank data=temp3&yr. out=temp4&yr. percent;
var S_PMT S_Medicare_PMT S_Medicaid_PMT;
ranks pct_PMT pct_Medicare_PMT pct_Medicaid_PMT ;
run;

data MMLeads.data&yr.;
set temp4&yr.;
if pct_PMT>=95 then HC5_PMT=1;else HC5_PMT=0;
if pct_PMT>=90 then HC10_PMT=1;else HC10_PMT=0;
if pct_PMT>=75 then HC25_PMT=1;else HC25_PMT=0;

if pct_Medicare_PMT>=95 then HC5_Medicare_PMT=1;else HC5_Medicare_PMT=0;
if pct_Medicare_PMT>=90 then HC10_Medicare_PMT=1;else HC10_Medicare_PMT=0;
if pct_Medicare_PMT>=75 then HC25_Medicare_PMT=1;else HC25_Medicare_PMT=0;

if pct_Medicaid_PMT>=95 then HC5_Medicaid_PMT=1;else HC5_Medicaid_PMT=0;
if pct_Medicaid_PMT>=90 then HC10_Medicaid_PMT=1;else HC10_Medicaid_PMT=0;
if pct_Medicaid_PMT>=75 then HC25_Medicaid_PMT=1;else HC25_Medicaid_PMT=0;
run;
