*******************************
Prepare Data for all Full Duals
Xiner Zhou
7/12/2016
*******************************;
libname MMleads 'D:\Data\MMLEADS\Data';
libname denom 'D:\Data\Medicare\Denominator';
libname data 'D:\Projects\Peterson\Data';

*****************************************
   Which Year?
*****************************************;

%let yr=2008;
%let yr=2009;
%let yr=2010;

******************************************
	Beneficiary Sample Selection: 

Step0: Start with everyone, keep certain vairables
Step1: For each year, keep full duals
Step2: full duals for 12 month,people died at December and had 12 month full coverage, include them (this will capture end-of-life cost) 
Step3: FFS or Managed Care ?
step4: Make a flow-chart for each year, and 3 year together's final sample size
******************************************;
 
* Select variabels in bene file;
proc sql;
create table temp0&yr. as
select bene_id, 
/* demographics */
D_STATE_CD,D_STATE_CD_01,D_STATE_CD_02,D_STATE_CD_03,D_STATE_CD_04,D_STATE_CD_05,D_STATE_CD_06,
D_STATE_CD_07,D_STATE_CD_08,D_STATE_CD_09,D_STATE_CD_10,D_STATE_CD_11,D_STATE_CD_12,
D_ZIP,D_COUNTY,
D_ALIVE_MOS,D_DIED,D_DOD,D_DOB,D_AGE,D_SEX,D_Medicare_Race, D_Medicaid_Race, 
/* Medicare and Medicaid Status */
E_MME_Type, E_MME_Type_01-E_MME_Type_12,  
E_BOE,	/* Most Recent Annual Medicaid Basis of Eligibility	*/	
E_MS_CD,	/* Medicare Status Code*/
E_MEDICAREFFS,
E_MEDICAREFFS_01,E_MEDICAREFFS_02,E_MEDICAREFFS_03,E_MEDICAREFFS_04,E_MEDICAREFFS_05,E_MEDICAREFFS_06,
E_MEDICAREFFS_07,E_MEDICAREFFS_08,E_MEDICAREFFS_09,E_MEDICAREFFS_10,E_MEDICAREFFS_11,E_MEDICAREFFS_12,	/*	Yearly Medicare FFS Indicator */
E_MEDICAIDFFS,
E_MEDICAIDFFS_01,E_MEDICAIDFFS_02,E_MEDICAIDFFS_03,E_MEDICAIDFFS_04,E_MEDICAIDFFS_05,E_MEDICAIDFFS_06,
E_MEDICAIDFFS_07,E_MEDICAIDFFS_08,E_MEDICAIDFFS_09,E_MEDICAIDFFS_10,E_MEDICAIDFFS_11,E_MEDICAIDFFS_12,	/*	Yearly Medicaid FFS Indicator */	
E_MEDICAREMA,
E_MEDICAREMA_01,E_MEDICAREMA_02,E_MEDICAREMA_03,E_MEDICAREMA_04,E_MEDICAREMA_05,E_MEDICAREMA_06,
E_MEDICAREMA_07,E_MEDICAREMA_08,E_MEDICAREMA_09,E_MEDICAREMA_10,E_MEDICAREMA_11,E_MEDICAREMA_12,	/*	Yearly Medicare MA Indicator */	
E_MEDICAIDPHP, /*	Yearly Medicaid MA Indicator */	
E_FD_MOS,	/* Months Full Dual During the Reference Year	*/
E_PD_MOS,	/* Months Partial Dual During the Reference Year	*/
E_QMB_MOS,	/* Months QMB Dual During the Reference Year*/	
E_MEDICAREONLY_MOS,	/* Months Medicare Only During the Reference Year	*/
E_MEDICAIDONLY_MOS,	/* Months Medicaid Only During the Reference Year*/	
E_OTHER_MOS, /* Months neither Medicare nor Medicaid During the Reference Year	*/
 
/* Medicare Spending */ 
S_Medicare_PMT, /*Annual Medicare FFS payments */
S_Medicare_Bene_PMT, /* Annual Medicare coinsurance and deductible FFS payments */

/* Medicaid Spending */
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
 
from MMleads.Mml_bene&yr.;
quit;

proc format;
value E_MME_Type_
1="Medicaid – with Disability non-dual"
2="Medicare-only (in Medicare data file) non-dual"
3="Partial Dual"
4="QMB-only Dual"
5="Full Dual"
;
run;

*Step1: For each year, keep full duals;
data temp1&yr.;
set temp0&yr.;
format E_MME_Type E_MME_Type_.;
if  E_MME_Type=5 ;
run;
  
*Step2: full duals for 12 month,people died at December and had 12 month full coverage, include them ;
data temp2&yr.;
set temp1&yr.;
if E_FD_MOS=12;
run;
*Step3: Had Medicare FFS + Medicaid FFS coverage all months alive during the year ;
data temp3&yr.;
set temp2&yr.;
if E_MEDICAREFFS =1 and E_MEDICAIDFFS =1;
run;
proc means data=temp0&yr. mean;
var S_Medicare_PMT S_Medicaid_PMT;
run;
proc means data=temp1&yr. mean;
var S_Medicare_PMT S_Medicaid_PMT;
run;
proc means data=temp2&yr. mean;
var S_Medicare_PMT S_Medicaid_PMT;
run;
proc means data=temp3&yr. mean;
var S_Medicare_PMT S_Medicaid_PMT;
run;
 
* Make a by-state flow-chart;
proc freq data=temp1&yr.;tables D_STATE_CD/missing;run;*full duals;
proc freq data=temp2&yr.;tables D_STATE_CD/missing;run;*full duals for 12 month;
data temp ;
set temp2&yr.;
*if E_MEDICAREFFS =0;
 if E_MEDICAIDFFS =0;
proc freq;tables D_STATE_CD/missing;
run;* Managed care specific number;
proc freq data=temp3&yr.;tables D_STATE_CD/missing;run;*Medicare FFS and Medicaid FFS;



* CCW; 
proc sql;
create table temp4&yr. as
select a.*,b.HYPTHY_COMBINED as HYPTHY&yr.,b.AMI_COMBINED as AMI&yr., 
b.ALZ_COMBINED as ALZ&yr., b.ANEMIA_COMBINED as ANEMIA&yr., 
b.ASTHMA_COMBINED as ASTHMA&yr., b.AFIB_COMBINED as AFIB&yr., b.HYPPLA_COMBINED as HYPPLA&yr., 
b.CAT_COMBINED as CAT&yr., b.CKD_COMBINED as CKD&yr., b.COPD_COMBINED as COPD&yr., 
b.CHF_COMBINED as CHF&yr., b.DEPR_COMBINED as DEPR&yr.,
b.DIAB_COMBINED as DIAB&yr.,b.GLCM_COMBINED as GLCM&yr.,b.HFRAC_COMBINED as HFRAC&yr.,
b.HYPLIP_COMBINED as HYPLIP&yr.,b.HYPTEN_COMBINED as HYPTEN&yr.,b.IHD_COMBINED as IHD&yr.,
b.OST_COMBINED as OST&yr.,b.RAOA_COMBINED as RAOA&yr.,
b.STRK_COMBINED as STRK&yr.,b.BRC_COMBINED as BRC&yr.,b.CRC_COMBINED as CRC&yr.,
b.LNGC_COMBINED as LNGC&yr.,b.PRC_COMBINED as PRC&yr.,
b.ENDC_COMBINED as ENDC&yr.,b.ACP_COMBINED as ACP&yr.,b.ANXI_COMBINED as ANXI&yr.,b.BIPL_COMBINED as BIPL&yr.,
b.DEPSN_COMBINED as DEPSN&yr.,b.PSDS_COMBINED as PSDS&yr.,b.PTRA_COMBINED as PTRA&yr.,b.SCHI_COMBINED as SCHI&yr.,
b.SCHIOT_COMBINED as SCHIOT&yr.,b.TOBA_COMBINED as TOBA&yr.,
b.AUTISM_COMBINED as AUTISM&yr.,b.BRAINJ_COMBINED as BRAINJ&yr.,b.CERPAL_COMBINED as CERPAL&yr.,
b.CYSFIB_COMBINED as CYSFIB&yr.,b.EPILEP_COMBINED as EPILEP&yr.,
b.HEARIM_COMBINED as HEARIM&yr.,b.INTDIS_COMBINED as INTDIS&yr.,b.LEADIS_COMBINED as LEADIS&yr.,
b.MOBIMP_COMBINED as MOBIMP&yr.,b.MULSCL_COMBINED as MULSCL&yr.,
b.MUSDYS_COMBINED as MUSDYS&yr.,b.SPIBIF_COMBINED as SPIBIF&yr.,b.SPIINJ_COMBINED as SPIINJ&yr.,
b.VISUAL_COMBINED as VISUAL&yr.,b.ALCO_COMBINED as ALCO&yr.,
b.DRUG_COMBINED as DRUG&yr.,b.FIBRO_COMBINED as FIBRO&yr.,b.HEPVIRAL_COMBINED as HEPVIRAL&yr.,
b.HEPB_ACT_COMBINED as HEPB_ACT&yr.,b.HEPB_CHR_COMBINED as HEPB_CHR&yr.,
b.HEPC_ACT_COMBINED as HEPC_ACT&yr.,b.HEPC_CHR_COMBINED as HEPC_CHR&yr.,b.HEPC_UNS_COMBINED as HEPC_UNS&yr.,
b.HEPD_COMBINED as HEPD&yr.,b.HEPE_COMBINED as HEPE&yr.,
b.HIVAIDS_1YR_COMBINED as HIVAIDS_1YR&yr.,b.HIVAIDS_COMBINED as HIVAIDS&yr.,b.HIVARV_COMBINED as HIVARV&yr.,
b.LEUKLYMPH_COMBINED as LEUKLYMPH&yr.,b.LIVER_COMBINED as LIVER&yr.,
b.MIGRAINE_COMBINED as MIGRAINE&yr.,b.OBESITY_COMBINED as OBESITY&yr.,
b.OTHDEL_COMBINED as OTHDEL&yr.,b.PVD_COMBINED as PVD&yr.,b.ULCERS_COMBINED as ULCERS&yr.
from temp3&yr. a left join mmleads.Mml_cond&yr. b
on a.bene_id=b.bene_id;
quit;
   
 

data temp5&yr.;
set temp4&yr.;

if S_Medicare_PMT<0 then S_Medicare_PMT=0;
if S_Medicaid_PMT<0 then S_Medicaid_PMT=0;
length AgeGroup $10.;
if D_Age<18 then AgeGroup="<18";
else if D_Age<25 then AgeGroup="18-24";
else if D_Age<35 then AgeGroup="25-34";
else if D_Age<45 then AgeGroup="35-44";
else if D_Age<55 then AgeGroup="45-54";
else if D_Age<65 then AgeGroup="55-64";
else if D_Age<75 then AgeGroup="65-74";
else if D_Age<85 then AgeGroup="75-85";
else if D_Age>=85 then AgeGroup=">=85";


length RaceGroup $10.;
if D_MEDICARE_RACE='1' then RaceGroup="White";
else if D_MEDICARE_RACE='2' then RaceGroup="Black";
else if D_MEDICARE_RACE='5' then RaceGroup="Hispanic";
else  RaceGroup="Other";

* HRSA regions: 
* https://mchdata.hrsa.gov/dgisreports/Abstract/HrsaRegionMap.htm ;
length Region $100.;
   
if D_STATE_CD='' then D_STATE_CD=D_STATE_CD_01; 
if D_STATE_CD in ('ME','NH','VT','MA','RI','CT') then region="HRSA Region 1:Maine, New Hampshire, Vermont, Massachusetts, Rhode Island, and Connecticut";
else if D_STATE_CD in ('NY','NJ') then region="HRSA Region 2:New York and New Jersey";
else if D_STATE_CD in ('PA','DC','MD','DE','VA','WV') then region="HRSA Region 3:Pennsylvania, District of Columbia, Maryland, Delaware, Virginia, and West Virginia";
else if D_STATE_CD in ('KY','TN','NC','SC','GA','FL','AL','MS') then region="HRSA Region 4:Kentucky, Tennessee, North Carolina, South Carolina, Georgia, Florida, Alabama, and Mississippi";
else if D_STATE_CD in ('MN','WI','IL','IN','MI','OH') then region="HRSA Region 5:Minnesota, Wisconsin, Illinois, Indiana, Michigan, and Ohio";
else if D_STATE_CD in ('NM','TX','OK','AR','LA') then region="HRSA Region 6:New Mexico, Texas, Oklahoma, Arkansas, and Louisiana";
else if D_STATE_CD in ('NE','KS','IA','MO') then region="HRSA Region 7:Nebraska, Kansas, Iowa, and Missouri";
else if D_STATE_CD in ('MT','ND','SD','WY','CO','UT') then region="HRSA Region 8:Montana, North Dakota, South Dakota, Wyoming, Colorado, and Utah";
else if D_STATE_CD in ('NV','CA','AZ','HI') then region="HRSA Region 9:Nevada, California, Arizona, and Hawaii";
else if D_STATE_CD in ('WA','OR','ID','AK')  then region="HRSA Region 10:Washington, Oregon, Idaho, and Alaska";

zip=D_zip*1;

S_PMT=S_Medicare_PMT+S_Medicaid_PMT;

* change number of claims to indicators;
array cond {70} 
HYPTHY&yr.  AMI&yr.  ALZ&yr.  ANEMIA&yr.  ASTHMA&yr. 
AFIB&yr.  HYPPLA&yr.  CAT&yr.  CKD&yr.  COPD&yr.  
CHF&yr.  DEPR&yr.  DIAB&yr.  GLCM&yr.  HFRAC&yr. 
HYPLIP&yr.  HYPTEN&yr.  IHD&yr.  OST&yr.  RAOA&yr.  
STRK&yr.  BRC&yr.  CRC&yr.  LNGC&yr.  PRC&yr. 
ENDC&yr.  ACP&yr.  ANXI&yr.  BIPL&yr.  DEPSN&yr. 
PSDS&yr. PTRA&yr. SCHI&yr.  SCHIOT&yr.  TOBA&yr. 
AUTISM&yr.  BRAINJ&yr.  CERPAL&yr. CYSFIB&yr. EPILEP&yr. 
HEARIM&yr.  INTDIS&yr.  LEADIS&yr.  MOBIMP&yr.  MULSCL&yr. 
MUSDYS&yr.  SPIBIF&yr. SPIINJ&yr.  VISUAL&yr.  ALCO&yr. 
DRUG&yr.  FIBRO&yr.  HEPVIRAL&yr.  HEPB_ACT&yr.  HEPB_CHR&yr. 
HEPC_ACT&yr.  HEPC_CHR&yr.  HEPC_UNS&yr. HEPD&yr.  HEPE&yr.  
HIVAIDS_1YR&yr.  HIVAIDS&yr.  HIVARV&yr. LEUKLYMPH&yr.  LIVER&yr. 
MIGRAINE&yr.  OBESITY&yr.  OTHDEL&yr.  PVD&yr.  ULCERS&yr. ;
do j=1 to 70;
if cond{j} in (1,3) then cond{j}=1;
else cond{j}=0;
end;
drop j;
proc freq;tables 
HYPTHY&yr.  AMI&yr.  ALZ&yr.  ANEMIA&yr.  ASTHMA&yr. 
AFIB&yr.  HYPPLA&yr.  CAT&yr.  CKD&yr.  COPD&yr.  
CHF&yr.  DEPR&yr.  DIAB&yr.  GLCM&yr.  HFRAC&yr. 
HYPLIP&yr.  HYPTEN&yr.  IHD&yr.  OST&yr.  RAOA&yr.  
STRK&yr.  BRC&yr.  CRC&yr.  LNGC&yr.  PRC&yr. 
ENDC&yr.  ACP&yr.  ANXI&yr.  BIPL&yr.  DEPSN&yr. 
PSDS&yr. PTRA&yr. SCHI&yr.  SCHIOT&yr.  TOBA&yr. 
AUTISM&yr.  BRAINJ&yr.  CERPAL&yr. CYSFIB&yr. EPILEP&yr. 
HEARIM&yr.  INTDIS&yr.  LEADIS&yr.  MOBIMP&yr.  MULSCL&yr. 
MUSDYS&yr.  SPIBIF&yr. SPIINJ&yr.  VISUAL&yr.  ALCO&yr. 
DRUG&yr.  FIBRO&yr.  HEPVIRAL&yr.  HEPB_ACT&yr.  HEPB_CHR&yr. 
HEPC_ACT&yr.  HEPC_CHR&yr.  HEPC_UNS&yr. HEPD&yr.  HEPE&yr.  
HIVAIDS_1YR&yr.  HIVAIDS&yr.  HIVARV&yr. LEUKLYMPH&yr.  LIVER&yr. 
MIGRAINE&yr.  OBESITY&yr.  OTHDEL&yr.  PVD&yr.  ULCERS&yr.
AgeGroup RaceGroup Region/missing nopercent nocol norow;
proc means;
var S_Medicare_PMT S_Medicaid_PMT S_PMT;
run;

*Stratify by Zip Code Median Income in Quartiles;
*Stratify by Zip Code Education-Level in Quartiles;
libname zipdata 'D:\Data\Census';
proc rank data=zipdata.National_zcta_extract out=temp1 groups=4;
var edu_college ;
ranks edu&yr.;
run;
proc rank data=temp1 out=temp2 groups=4;
var inchh_median ;
ranks mhi&yr. ;
run;
data Zip ;
set temp2 ;
MHI&yr. =MHI&yr. +1;
Edu&yr. =Edu&yr. +1; 
edu_college&yr. =edu_college;
inchh_median&yr.=inchh_median;
zip=zip5*1;
keep zip  edu_college&yr.  inchh_median&yr. mhi&yr. edu&yr.;
label MHI&yr. ="Quartiles:Medium House Income ";
label Edu&yr. ="Quartiles:% Persons with College";
proc freq ;tables MHI&yr. Edu&yr. /missing;
proc means;var edu_college&yr. inchh_median&yr.;
run;
proc sql;
create table data.Bene&yr. as
select a.*,b.*
from temp5&yr. a left join Zip  b
on a.zIP =b.zip  ;
quit;

 




















****************************************
Plan A: Alive 3 years
***************************************;
proc sql;
create table bene1 as
select  a.bene_id, a.S_PMT as S_PMT2008, b.S_PMT as S_PMT2009
from data.bene2008 a inner join data.bene2009 b
on a.bene_id=b.bene_id;
quit;
proc sql;
create table bene2 as
select  a.*, b.S_PMT as S_PMT2010
from bene1 a inner join data.bene2010 b
on a.bene_id=b.bene_id;
quit;
proc rank data=bene2 out=bene3 percent;
var S_PMT2008 S_PMT2009 S_PMT2010 ;
ranks pct_PMT2008 pct_PMT2009 pct_PMT2010 ;
run;

data data.PlanABene;
set bene3;
length group $30.;
if pct_PMT2008>=90 then HC2008 =1;else HC2008=0;
if pct_PMT2009>=90 then HC2009 =1;else HC2009=0;
if pct_PMT2010>=90 then HC2010 =1;else HC2010=0;

if HC2008=1 and HC2009=1 and HC2010=1 then group="HC HC HC";
else if HC2008=1 and HC2009=1 and HC2010=0 then group="HC HC nonHC";
else if HC2008=1 and HC2009=0 and HC2010=1 then group="HC nonHC HC";
else if HC2008=1 and HC2009=0 and HC2010=0 then group="HC nonHC nonHC";
else if HC2008=0 and HC2009=1 and HC2010=1 then group="nonHC HC HC";
else if HC2008=0 and HC2009=1 and HC2010=0 then group="nonHC HC nonHC";
else if HC2008=0 and HC2009=0 and HC2010=1 then group="nonHC nonHC HC";
else if HC2008=0 and HC2009=0 and HC2010=0 then group="nonHC nonHC nonHC";
proc freq;tables HC2008 HC2009 HC2010 group/missing;
run;

* Look at cut point;
proc means data=data.PlanABene min mean median max;
class HC2008;
var S_PMT2008;
run;

proc means data=data.PlanABene min mean median max;
class HC2009;
var S_PMT2009;
run;

proc means data=data.PlanABene min mean median max;
class HC2010;
var S_PMT2010;
run;

***************************************
Plan B: Alive 12 month in 2008, look at trajectory over time
***************************************;
proc rank data=data.bene2008 out=bene2008 percent;
var S_PMT  ;
ranks pct_PMT2008  ;
run;
proc rank data=data.bene2009 out=bene2009 percent;
var S_PMT  ;
ranks pct_PMT2009  ;
run;
proc rank data=data.bene2010 out=bene2010 percent;
var S_PMT  ;
ranks pct_PMT2010 ;
run;
proc sql;
create table bene1 as
select  a.bene_id, a.S_PMT as S_PMT2008, a.pct_PMT2008, b.S_PMT as S_PMT2009, b.pct_PMT2009
from  bene2008 a left join bene2009 b
on a.bene_id=b.bene_id;
quit;
proc sql;
create table bene2 as
select  a.*, b.S_PMT as S_PMT2010, b.pct_PMT2010
from bene1 a left join  bene2010 b
on a.bene_id=b.bene_id;
quit;

data data.PlanBBene;
set bene2;
length group $30.;

if pct_PMT2008>=90 then HC2008 =1;else if pct_PMT2008 ne . then HC2008=0;
if pct_PMT2009>=90 then HC2009 =1;else if pct_PMT2009 ne . then HC2009=0;
if pct_PMT2010>=90 then HC2010 =1;else if pct_PMT2010 ne . then HC2010=0;

if HC2008=1 and HC2009=1 and HC2010=1 then group="HC HC HC";
else if HC2008=1 and HC2009=1 and HC2010=0 then group="HC HC nonHC";
else if HC2008=1 and HC2009=1 and HC2010=. then group="HC HC missing";
else if HC2008=1 and HC2009=0 and HC2010=1 then group="HC nonHC HC";
else if HC2008=1 and HC2009=0 and HC2010=0 then group="HC nonHC nonHC";
else if HC2008=1 and HC2009=0 and HC2010=. then group="HC nonHC missing";
else if HC2008=1 and HC2009=. and HC2010=1 then group="HC missing HC";
else if HC2008=1 and HC2009=. and HC2010=0 then group="HC missing nonHC";
else if HC2008=1 and HC2009=. and HC2010=. then group="HC missing missing";

else if HC2008=0 and HC2009=1 and HC2010=1 then group="nonHC HC HC";
else if HC2008=0 and HC2009=1 and HC2010=0 then group="nonHC HC nonHC";
else if HC2008=0 and HC2009=1 and HC2010=. then group="nonHC HC missing";
else if HC2008=0 and HC2009=0 and HC2010=1 then group="nonHC nonHC HC";
else if HC2008=0 and HC2009=0 and HC2010=0 then group="nonHC nonHC nonHC";
else if HC2008=0 and HC2009=0 and HC2010=. then group="nonHC nonHC missing";
else if HC2008=0 and HC2009=. and HC2010=1 then group="nonHC missing HC";
else if HC2008=0 and HC2009=. and HC2010=0 then group="nonHC missing nonHC";
else if HC2008=0 and HC2009=. and HC2010=. then group="nonHC missing missing";
proc freq;tables HC2008 HC2009 HC2010 group/missing;
 
run;

 

* Look at cut point;
data bene2008;
set bene2008;
if pct_PMT2008>=90 then HC2008 =1;else  HC2008=0;
run;
data bene2009;
set bene2009;
if pct_PMT2009>=90 then HC2009 =1;else  HC2009=0;
run;
data bene2010;
set bene2010;
if pct_PMT2010>=90 then HC2010 =1;else  HC2010=0;
run;


proc means data=bene2008 min mean median max;
class HC2008;
var S_PMT;
run;

proc means data=bene2009 min mean median max;
class HC2009;
var S_PMT;
run;

proc means data=bene2010 min mean median max;
class HC2010;
var S_PMT;
run;



/*Preventable spending for 2010;
libname PQI 'D:\Projects\Peterson\Data';
%let yr=2010;
proc sql;
create table temp6&yr. as
select a.*,b.*
from temp5&yr. a left join data.Pqi&yr. b
on a.bene_id=b.bene_id;
quit;

data data.Bene&yr.;
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
 */
