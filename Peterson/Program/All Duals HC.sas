**********************************
All DUALs HC
Xiner Zhou
7/14/2016
**********************************;
libname MMleads 'C:\data\Data\MMLEADS\Data';

/*
Analytical Plan in Dual Population:

1.	HC Duals by Age group:
　	<18		 
　	18-25
　	26-35
　	36-45
　	46-55
　	56-64
　	65-75
　	75-85
　	>86

2.	HC Duals by Income 
　	Stratify by Zip Code Median Income in Quartiles
　	Stratify by Zip Code Median Income in Quintiles

 
3.	HC Duals by Education-Level 
　	Stratify by Zip Code Median Income in Quartiles
　	Stratify by Zip Code Median Income in Quintiles

7.	Proportion of Patients who are HC( 5% 10% 25%) in Medicare and HC in Medicaid as well,  in year 2010 only
*/
proc freq data= mmleads.data2010;tables  HC10_PMT*HC10_Medicare_PMT HC10_PMT*HC10_Medicaid_PMT HC10_Medicare_PMT*HC10_Medicaid_PMT/nopercent;run;
proc freq data= mmleads.data2010;tables  HC5_PMT*HC5_Medicare_PMT HC5_PMT*HC5_Medicaid_PMT HC5_Medicare_PMT*HC5_Medicaid_PMT/nopercent;run;
proc freq data= mmleads.data2010;tables  HC25_PMT*HC25_Medicare_PMT HC25_PMT*HC25_Medicaid_PMT HC25_Medicare_PMT*HC25_Medicaid_PMT/nopercent;run;



data data2010;
length trt $50.;
set mmleads.data2010;
if HC10_Medicare_PMT=1 and  HC10_Medicaid_PMT=1 then trt="HC Medicare + HC Medicaid (10%)";
else if HC10_Medicare_PMT=0 and  HC10_Medicaid_PMT=0 then trt="non-HC Medicare + non-HC Medicaid(10%)";
else if HC10_Medicare_PMT=1 and  HC10_Medicaid_PMT=0 then trt="HC Medicare + non-HC Medicaid(10%)";
else if HC10_Medicare_PMT=0 and  HC10_Medicaid_PMT=1 then trt="non-HC Medicare + HC Medicaid(10%)";
proc freq;tables trt trt*seg/missing;
run;

 
proc tabulate data=data2010  noseps  ;
class trt D_sex D_MEDICARE_RACE AgeGroup E_MS_CD E_BOE  edu mhi; 
var 
HYPTHY_COMBINED AMI_COMBINED ALZ_COMBINED ANEMIA_COMBINED ASTHMA_COMBINED AFIB_COMBINED HYPPLA_COMBINED 
CAT_COMBINED CKD_COMBINED COPD_COMBINED CHF_COMBINED DEPR_COMBINED DIAB_COMBINED GLCM_COMBINED HFRAC_COMBINED 
HYPLIP_COMBINED HYPTEN_COMBINED IHD_COMBINED OST_COMBINED RAOA_COMBINED STRK_COMBINED BRC_COMBINED CRC_COMBINED 
LNGC_COMBINED PRC_COMBINED ENDC_COMBINED ACP_COMBINED ANXI_COMBINED BIPL_COMBINED DEPSN_COMBINED PSDS_COMBINED 
PTRA_COMBINED SCHI_COMBINED SCHIOT_COMBINED TOBA_COMBINED AUTISM_COMBINED BRAINJ_COMBINED CERPAL_COMBINED 
CYSFIB_COMBINED EPILEP_COMBINED HEARIM_COMBINED INTDIS_COMBINED LEADIS_COMBINED MOBIMP_COMBINED MULSCL_COMBINED 
MUSDYS_COMBINED SPIBIF_COMBINED SPIINJ_COMBINED VISUAL_COMBINED ALCO_COMBINED DRUG_COMBINED FIBRO_COMBINED 
HEPVIRAL_COMBINED HEPB_ACT_COMBINED HEPB_CHR_COMBINED HEPC_ACT_COMBINED HEPC_CHR_COMBINED HEPC_UNS_COMBINED 
HEPD_COMBINED HEPE_COMBINED  HIVAIDS_COMBINED 
LEUKLYMPH_COMBINED LIVER_COMBINED MIGRAINE_COMBINED 
OBESITY_COMBINED OTHDEL_COMBINED PVD_COMBINED ULCERS_COMBINED;
   
table (D_sex="Gender" D_MEDICARE_RACE="Race"  AgeGroup="Age" E_MS_CD="Medicare status code" E_BOE="Medicaid Basis of Eligibility"
edu="Stratify by Zip Code Prop. College Education Degree in Quartiles" mhi="Stratify by Zip Code Median Income in Quartiles"
),(trt="Persistent vs. Transience in HC duals"*(n colpctn)  all*(n colpctn))/RTS=25;

table (
HYPTHY_COMBINED AMI_COMBINED ALZ_COMBINED ANEMIA_COMBINED ASTHMA_COMBINED AFIB_COMBINED HYPPLA_COMBINED 
CAT_COMBINED CKD_COMBINED COPD_COMBINED CHF_COMBINED DEPR_COMBINED DIAB_COMBINED GLCM_COMBINED HFRAC_COMBINED 
HYPLIP_COMBINED HYPTEN_COMBINED IHD_COMBINED OST_COMBINED RAOA_COMBINED STRK_COMBINED BRC_COMBINED CRC_COMBINED 
LNGC_COMBINED PRC_COMBINED ENDC_COMBINED ACP_COMBINED ANXI_COMBINED BIPL_COMBINED DEPSN_COMBINED PSDS_COMBINED 
PTRA_COMBINED SCHI_COMBINED SCHIOT_COMBINED TOBA_COMBINED AUTISM_COMBINED BRAINJ_COMBINED CERPAL_COMBINED 
CYSFIB_COMBINED EPILEP_COMBINED HEARIM_COMBINED INTDIS_COMBINED LEADIS_COMBINED MOBIMP_COMBINED MULSCL_COMBINED 
MUSDYS_COMBINED SPIBIF_COMBINED SPIINJ_COMBINED VISUAL_COMBINED ALCO_COMBINED DRUG_COMBINED FIBRO_COMBINED 
HEPVIRAL_COMBINED HEPB_ACT_COMBINED HEPB_CHR_COMBINED HEPC_ACT_COMBINED HEPC_CHR_COMBINED HEPC_UNS_COMBINED 
HEPD_COMBINED HEPE_COMBINED HIVAIDS_COMBINED 
LEUKLYMPH_COMBINED LIVER_COMBINED MIGRAINE_COMBINED 
OBESITY_COMBINED OTHDEL_COMBINED PVD_COMBINED ULCERS_COMBINED),
(trt="HC Groups"*(mean*f=7.4  sum*f=7.4)  all*(mean*f=7.4  sum*f=7.4))/RTS=25;
 
 Keylabel all="All Dual Eligible"
         N="Number of Beneficiary"
		 colpctn="Column Percent";
 
format  D_MEDICARE_RACE $race_. E_MS_CD $E_MS_CD_. E_BOE $E_BOE_.; 


run;
 

* Tabulate PQI;

proc tabulate data=data2010  noseps  ;
class trt; 
var 
N_TAPQ01 TAPQ01Spending 
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
IPSpending OPSpending CarSpending HHASpending SNFSpending HspcSpending  DMESpending TotSpending;


table 
(N_TAPQ01 
N_TAPQ02 
N_TAPQ03 
N_TAPQ05 
N_TAPQ07 
N_TAPQ08 
N_TAPQ10 
N_TAPQ11  
N_TAPQ12  
N_TAPQ13 
N_TAPQ14  
N_TAPQ15 
N_TAPQ16 
N_TAPQ90  
N_TAPQ91  
N_TAPQ92  ),
trt*(mean*f=7.4  sum*f=7.4 ) All*(mean*f=7.4 sum*f=7.4  )  ;
table 
TAPQ01spending 
TAPQ02spending 
TAPQ03spending 
TAPQ05spending 
TAPQ07spending 
TAPQ08spending 
TAPQ10spending 
TAPQ11spending 
TAPQ12spending 
TAPQ13spending 
TAPQ14spending 
TAPQ15spending 
TAPQ16spending 
TAPQ90spending 
TAPQ91spending 
TAPQ92spending
,trt*(mean*f=dollar12.  sum*f=dollar12. ) 
All*(mean*f=7.4  sum*f=7.4  );

table 
TotSpending="Total Within 30-day Post PQI  Spending"
IPSpending="Within 30-day Post PQI Actual Spending:Inpatient"
OPSpending="Within 30-day Post PQI Actual Spending:Outpatient"
CarSpending="Within 30-day Post PQI Actual Spending:Carrier/Physician" 
HHASpending="Within 30-day Post PQI Actual Spending:Home Health Agency" 
SNFSpending="Within 30-day Post PQI Actual Spending:Skilled Nursing Facility" 
HspcSpending="Within 30-day Post PQI Actual Spending:Hospice"  
DMESpending="Within 30-day Post PQI Actual Spending:DME" 
,trt*(mean*f=dollar12.  sum*f=dollar12. ) 
All*(mean*f=7.4  sum*f=7.4  );

 
Keylabel all="All Beneficiary" 
         ;
run;


/*
4.	Segments: 
a.	Under 65 by Median Income Quartiles
b.	Over 65 by Median Income Quartlies
c.	Under 65 by Median Income Quintiles
d.	Over 65 by Median Income Quintiles

6.	Preventable spending in Duals
　	Segment preventable spending by PQIs + 30day spending after PQI admission  [similar to Medicare study] for:
o	Segments

*/

 
* Tabulate Demographics;
proc tabulate data=data2010  noseps  ;
where qualify_seg=1;
class seg D_sex D_MEDICARE_RACE AgeGroup E_MS_CD E_BOE  edu mhi; 
var 
HYPTHY_COMBINED AMI_COMBINED ALZ_COMBINED ANEMIA_COMBINED ASTHMA_COMBINED AFIB_COMBINED HYPPLA_COMBINED 
CAT_COMBINED CKD_COMBINED COPD_COMBINED CHF_COMBINED DEPR_COMBINED DIAB_COMBINED GLCM_COMBINED HFRAC_COMBINED 
HYPLIP_COMBINED HYPTEN_COMBINED IHD_COMBINED OST_COMBINED RAOA_COMBINED STRK_COMBINED BRC_COMBINED CRC_COMBINED 
LNGC_COMBINED PRC_COMBINED ENDC_COMBINED ACP_COMBINED ANXI_COMBINED BIPL_COMBINED DEPSN_COMBINED PSDS_COMBINED 
PTRA_COMBINED SCHI_COMBINED SCHIOT_COMBINED TOBA_COMBINED AUTISM_COMBINED BRAINJ_COMBINED CERPAL_COMBINED 
CYSFIB_COMBINED EPILEP_COMBINED HEARIM_COMBINED INTDIS_COMBINED LEADIS_COMBINED MOBIMP_COMBINED MULSCL_COMBINED 
MUSDYS_COMBINED SPIBIF_COMBINED SPIINJ_COMBINED VISUAL_COMBINED ALCO_COMBINED DRUG_COMBINED FIBRO_COMBINED 
HEPVIRAL_COMBINED HEPB_ACT_COMBINED HEPB_CHR_COMBINED HEPC_ACT_COMBINED HEPC_CHR_COMBINED HEPC_UNS_COMBINED 
HEPD_COMBINED HEPE_COMBINED HIVAIDS_1YR_COMBINED HIVAIDS_COMBINED HIVARV_COMBINED 
LEUKLYMPH_COMBINED LIVER_COMBINED MIGRAINE_COMBINED 
OBESITY_COMBINED OTHDEL_COMBINED PVD_COMBINED ULCERS_COMBINED;
   
table (D_sex="Gender" D_MEDICARE_RACE="Race"  AgeGroup="Age" E_MS_CD="Medicare status code" E_BOE="Medicaid Basis of Eligibility"
edu="Stratify by Zip Code Prop. College Education Degree in Quartiles" mhi="Stratify by Zip Code Median Income in Quartiles"
),(seg*(n colpctn)  all*(n colpctn))/RTS=25;

table (
HYPTHY_COMBINED AMI_COMBINED ALZ_COMBINED ANEMIA_COMBINED ASTHMA_COMBINED AFIB_COMBINED HYPPLA_COMBINED 
CAT_COMBINED CKD_COMBINED COPD_COMBINED CHF_COMBINED DEPR_COMBINED DIAB_COMBINED GLCM_COMBINED HFRAC_COMBINED 
HYPLIP_COMBINED HYPTEN_COMBINED IHD_COMBINED OST_COMBINED RAOA_COMBINED STRK_COMBINED BRC_COMBINED CRC_COMBINED 
LNGC_COMBINED PRC_COMBINED ENDC_COMBINED ACP_COMBINED ANXI_COMBINED BIPL_COMBINED DEPSN_COMBINED PSDS_COMBINED 
PTRA_COMBINED SCHI_COMBINED SCHIOT_COMBINED TOBA_COMBINED AUTISM_COMBINED BRAINJ_COMBINED CERPAL_COMBINED 
CYSFIB_COMBINED EPILEP_COMBINED HEARIM_COMBINED INTDIS_COMBINED LEADIS_COMBINED MOBIMP_COMBINED MULSCL_COMBINED 
MUSDYS_COMBINED SPIBIF_COMBINED SPIINJ_COMBINED VISUAL_COMBINED ALCO_COMBINED DRUG_COMBINED FIBRO_COMBINED 
HEPVIRAL_COMBINED HEPB_ACT_COMBINED HEPB_CHR_COMBINED HEPC_ACT_COMBINED HEPC_CHR_COMBINED HEPC_UNS_COMBINED 
HEPD_COMBINED HEPE_COMBINED HIVAIDS_COMBINED  
LEUKLYMPH_COMBINED LIVER_COMBINED MIGRAINE_COMBINED 
OBESITY_COMBINED OTHDEL_COMBINED PVD_COMBINED ULCERS_COMBINED),
(seg*(mean*f=7.4  sum*f=7.4)  all*(mean*f=7.4  sum*f=7.4))/RTS=25;
 
 Keylabel all="All Dual Eligible"
         N="Number of Beneficiary"
		 colpctn="Column Percent";
 
format  D_MEDICARE_RACE $race_. E_MS_CD $E_MS_CD_. E_BOE $E_BOE_.; 


run;
 

* Tabulate PQI;

proc tabulate data=data2010  noseps  ;
where qualify_seg=1;
class seg; 
var 
N_TAPQ01 TAPQ01Spending 
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
IPSpending OPSpending CarSpending HHASpending SNFSpending HspcSpending  DMESpending TotSpending;


table 
(N_TAPQ01 
N_TAPQ02 
N_TAPQ03 
N_TAPQ05 
N_TAPQ07 
N_TAPQ08 
N_TAPQ10 
N_TAPQ11  
N_TAPQ12  
N_TAPQ13 
N_TAPQ14  
N_TAPQ15 
N_TAPQ16 
N_TAPQ90  
N_TAPQ91  
N_TAPQ92  ),
seg*(mean*f=7.4  sum*f=7.4 ) All*(mean*f=7.4 sum*f=7.4  )  ;
table 
TAPQ01spending 
TAPQ02spending 
TAPQ03spending 
TAPQ05spending 
TAPQ07spending 
TAPQ08spending 
TAPQ10spending 
TAPQ11spending 
TAPQ12spending 
TAPQ13spending 
TAPQ14spending 
TAPQ15spending 
TAPQ16spending 
TAPQ90spending 
TAPQ91spending 
TAPQ92spending
,seg*(mean*f=dollar12.  sum*f=dollar12. ) 
All*(mean*f=7.4  sum*f=7.4  );

table 
TotSpending="Total Within 30-day Post PQI  Spending"
IPSpending="Within 30-day Post PQI Actual Spending:Inpatient"
OPSpending="Within 30-day Post PQI Actual Spending:Outpatient"
CarSpending="Within 30-day Post PQI Actual Spending:Carrier/Physician" 
HHASpending="Within 30-day Post PQI Actual Spending:Home Health Agency" 
SNFSpending="Within 30-day Post PQI Actual Spending:Skilled Nursing Facility" 
HspcSpending="Within 30-day Post PQI Actual Spending:Hospice"  
DMESpending="Within 30-day Post PQI Actual Spending:DME" 
,seg*(mean*f=dollar12.  sum*f=dollar12. ) 
All*(mean*f=7.4  sum*f=7.4  );

 
Keylabel all="All Beneficiary" 
         ;
run;
