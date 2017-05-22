
proc format;
value E_MME_Type_
1="Medicaid – with Disability non-dual"
2="Medicare-only (in Medicare data file) non-dual"
3="Partial Dual"
4="QMB-only Dual"
5="Full Dual"
;
run;
proc format;
value region_
1="Region 1: Maine, New Hampshire, Vermont, Massachusetts, Rhode Island, and Connecticut"
2="Region 2: New York and New Jersey"
3="Region 3: Pennsylvania, Maryland, Delaware, Virginia, and West Virginia" 
4="Region 4: Kentucky, Tennessee, North Carolina, South Carolina, Georgia, Florida, Alabama, and Mississippi"
5="Region 5: Minnesota, Wisconsin, Illinois, Indiana, Michigan, and Ohio"
6="Region 6: New Mexico, Texas, Oklahoma, Arkansas, and Louisiana"
7="Region 7: Nebraska, Kansas, Iowa, and Missouri"
8="Region 8: Montana, North Dakota, South Dakota, Wyoming, Colorado, and Utah"
9="Region 9: Nevada, California, Arizona, and Hawaii"
10="Region 10: Washington, Oregon, Idaho, and Alaska"
11="DC"
;
run;
 
proc format;
value $Race_
'1'="Non-Hispanic white"
'2'="Black(or African American)"
'3'="Other"
'4'="Asian/Pacific Islander"
'5'="Hispanic"
'6'="American Indian/Alaska Native"
'7'="Unknown"
'0'="Unknown"
;
run;

proc format;
value $E_MS_CD_
'10'="Aged without ESRD"
'11'="Age with ESRD"
'20'="Disability without ESRD"
'21'="Disability with ESRD"
'31'="ESRD only"
;
run;

proc format;
value $E_BOE_
'0'="Not eligible for Medicaid"
'1'="Aged"
'2'="Blind/disabled"
'4'="Child"
'5'="Adult"
'6'="Child of unemployed adult"
'7'="Unemployed Adult"
'8'="Foster care child"
'A'="Covered under Breast and Cervical Cancer Prevention Act"
'9'="Unknown"
;
run;


proc format;
value N_MajorCC_C_ 
1="0"
2="1-2"
3="3-5"
4="6-8"
;
run;

proc format;
value N_MinorCC_C_ 
1="0"
2="1-3"
3="4-6"
4="7-10"
5="11+"
;
run;

proc format;
value N_MajorCC1_C_ 
1="0"
2="1-2"
3="3-5"
4="6-8"
;
run;

proc format;
value N_MinorCC1_C_ 
1="0"
2="1-3"
3="4-6"
4="7-10"
5="11+"
;
run;

proc format ;
value $MR_SRVC_1_
'MDCR_PTA'="Medicare Part A"
'MDCR_HOP'="Medicare Part B institutional-hospital outpatient"
'MDCR_PTB'="Medicare Part B non-institutional- Carrier/DME"
'MDCR_MC'="Medicare Managed Care Premiums"
'MDCR_PTD'="Medicare Part D Drugs"
;
run;

proc format ;
value $MR_SRVC_2_

'MDCR_IP'="Inpatient Acute Care Hospital (include CAH)"
'MDCR_IP_OTH'="Other Inpatient (Psych, other hospital)"
'MDCR_PAC_OTH'="Other post-acute care (Inpatient Rehab, long-term hospital)"
'MDCR_SNF'="Skilled Nursing Facility (SNF)"
'MDCR_HOSPICE'="Hospice"
'MDCR_HH'="Home Health (HH)"

'MDCR_OPD'="Outpatient Department Services"
'MDCR_ESRD'="End Stage Renal Disease (ESRD) Facility"
'MDCR_OSNF'="Other Skilled Nursing Facility"
'MDCR_FQHC'="Federally Qualified Health Center (FQHC)"
'MDCR_RHC'="Rural Health Center (Clinic)"
'MDCR_THRPY'="Outpatient Therapy (outpatient rehab and community outpatient rehab)"
'MDCR_CMHC'="Community Mental Health Center (CMHC)"
'MDCR_OTH40'="Other"

'MDCR_ASC'="Ambulatory Surgical Center (ASC)"
'MDCR_PTB_DRUG'="Part B Drug"
'MDCR_EM'="Physician Evaluation and Management"
'MDCR_PROC'="Procedures"
'MDCR_IMG'="Imaging"
'MDCR_LABTST'="Laboratory and Testing"
'MDCR_OTH'="Other Part B"
'MDCR_DME'="Durable Medical Equipment (DME)"

'MDCR_PTA'="Part A managed care premium"
'MDCR_PTB'="Part B managed care premium"

'MDCR_ANTIDOTE'="Antidotes, Deterrents and Poison Control"
'MDCR_ANTIHIST'="Antihistamines"
'MDCR_ANTIMICRO'="Antimicrobials"
'MDCR_ANTINEO'="Antineoplastics"
'MDCR_ANTIPARA'="Antiparasitics"
'MDCR_ANTISEPT'="Antiseptics,Disinfectants"
'MDCR_AUTONOM'="Autonomic Medications"
'MDCR_BLOOD'="Blood products/Modifiers/Volume Expanders"
'MDCR_CARDIO'="Cardiovascular Medications"
'MDCR_CNS'="Central Nervous System Medications"
'MDCR_DENTAL'="Dental and Oral Agents, Topical"
'MDCR_DERMA'="Dermatological Agents"
'MDCR_DIAG'="Diagnostic Agents"
'MDCR_DIALYSIS'="Irrigation/Dialysis Solutions"
'MDCR_GASTRO'="Gastrointestinal Medications"
'MDCR_GENITO'="Genitourinary Medications"
'MDCR_HERBS'="Herbs/Alternative Therapies"
'MDCR_HORMONE'="Hormones/Synthetics/Modifiers"
'MDCR_IMMUNO'="Immunological Agents"
'MDCR_MISC'="Miscellaneous Agents"
'MDCR_MUSCULO'="Musculoskeletal Medications"
'MDCR_NASAL'="Nasal and Throat Agents, Topical"
'MDCR_OPTH'="Ophthalmic Agents"
'MDCR_OTIC'="Otic Agents"
'MDCR_PROST'="Prosthetics/Supplies/Devices"
'MDCR_REAGENT'="Pharmaceutical Aids/Reagents"
'MDCR_RECTAL'="Rectal, Local"
'MDCR_RESP'="Respiratory Tract Medications"
'MDCR_THERAPU'="Theraputic Nutrients/Minerals/Electrolytes"
'MDCR_UNCLASS'="Unclassified"
'MDCR_VITA'="Vitamins"
;
run;

proc format;
value $MC_SRVC_2_

'MDCD_FFS_ACUTE'="Acute hospitalization, outpatient hospital, physician or other practitioner treatment, laboratory tests or imaging"
'MDCD_FFS_LTI'="Long term care ? institutional or facility_based"
'MDCD_FFS_LTN'="Long term care- non-institutional-based, including personal care servies and durable medical equipment"
'MDCD_FFS_Drug'="Drugs, which are not included in the per diem payments for facility care"
'MDCD_MC'="Managed Care"
;
run;




proc format ;
value $MC_SRVC_3_
'MDCD_FFS_ACUTE_IP'="Inpatient"
'MDCD_FFS_ACUTE_HOP'="Hospital Outpatient"
'MDCD_FFS_ACUTE_PHYS'="Physician"
'MDCD_FFS_ACUTE_OTH_OTHPRC'="Other Medicaid Services:Other practitioner"
'MDCD_FFS_ACUTE_OTH_CLINIC'="Other Medicaid Services:Clinic"
'MDCD_FFS_ACUTE_OTH_LABX'="Other Medicaid Services:Lab Xray"
'MDCD_FFS_ACUTE_OTH_MISC'="Other Medicaid Services:Other services"
'MDCD_FFS_ACUTE_OTH_STERL'="Other Medicaid Services:Sterilizations"
'MDCD_FFS_ACUTE_OTH_ABORT'="Other Medicaid Services:Abortions"
'MDCD_FFS_ACUTE_OTH_THERAP'="Other Medicaid Services:PT/OT/Speech/Hearing services"
'MDCD_FFS_ACUTE_OTH_NMW'="Other Medicaid Services:Nurse midwife services"
'MDCD_FFS_ACUTE_OTH_NP'="Other Medicaid Services:Nurse practitioner services"
'MDCD_FFS_ACUTE_OTH_PELIG'="Other Medicaid Services:Religious non-medical health care institutions"
'MDCD_FFS_ACUTE_OTH_PSYC'="Other Medicaid Services:Psychiatric services"
'MDCD_FFS_ACUTE_OTH_DENTAL'="Other Medicaid Services:Dental"
'MDCD_FFS_ACUTE_OTH_UNKW'="Other Medicaid Services:Unknown"
 
'MDCD_FFS_LTI_IMD'="Mental hospital services for the aged"
'MDCD_FFS_LTI_IPF'="Inpatient psychiatric facility for individuals under the age of 21"
'MDCD_FFS_LTI_ICF'="Intermediate care facility (ICF) for individuals with intellectual disabilities"
'MDCD_FFS_LTI_NFS'="Nursing facility services (NFS) ?all other"

 
'MDCD_FFS_LTN_REHAB'="Rehabilitative services" 
'MDCD_FFS_LTN_HH'="Home Health" 
'MDCD_FFS_LTN_HOS'="Hospice" 
'MDCD_FFS_LTN_DME'="Durable Medical Equipment"  
'MDCD_FFS_LTN_PCS'="Personal Care Services"  
'MDCD_FFS_LTN_RC'="Residential Care"  
'MDCD_FFS_LTN_ADC'="Adult Day Care"  
'MDCD_FFS_LTN_TS'="Transportation services" 
'MDCD_FFS_LTN_TCM'="Targeted Case Management"  
'MDCD_FFS_LTN_PDN'="Private Duty Nursing"  
  
'MDCD_MC_HMO'="Capitated payments to HMO or HIO plan"
'MDCD_MC_PHP'="Capitated payments to prepaid health plans (PHPs)"
'MDCD_MC_PCCM'="Capitated payments for primary care case management(PCCM)"
 

'MDCD_FFS_ANTIDOTE'="Antidotes, Deterrents and Poison Control"
'MDCD_FFS_ANTIHIST'="Antihistamines"
'MDCD_FFS_ANTIMICRO'="Antimicrobials"
'MDCD_FFS_ANTINEO'="Antineoplastics"
'MDCD_FFS_ANTIPARA'="Antiparasitics"
'MDCD_FFS_ANTISEPT'="Antiseptics,Disinfectants"
'MDCD_FFS_AUTONOM'="Autonomic Medications"
'MDCD_FFS_BLOOD'="Blood products/Modifiers/Volume Expanders"
'MDCD_FFS_CARDIO'="Cardiovascular Medications"
'MDCD_FFS_CNS'="Central Nervous System Medications"
'MDCD_FFS_DENTAL'="Dental and Oral Agents, Topical"
'MDCD_FFS_DERMA'="Dermatological Agents"
'MDCD_FFS_DIAG'="Diagnostic Agents"
'MDCD_FFS_DIALYSIS'="Irrigation/Dialysis Solutions"
'MDCD_FFS_GASTRO'="Gastrointestinal Medications"
'MDCD_FFS_GENITO'="Genitourinary Medications"
'MDCD_FFS_HERBS'="Herbs/Alternative Therapies"
'MDCD_FFS_HORMONE'="Hormones/Synthetics/Modifiers"
'MDCD_FFS_IMMUNO'="Immunological Agents"
'MDCD_FFS_MISC'="Miscellaneous Agents"
'MDCD_FFS_MUSCULO'="Musculoskeletal Medications"
'MDCD_FFS_NASAL'="Nasal and Throat Agents, Topical"
'MDCD_FFS_OPTH'="Ophthalmic Agents"
'MDCD_FFS_OTIC'="Otic Agents"
'MDCD_FFS_PROST'="Prosthetics/Supplies/Devices"
'MDCD_FFS_REAGENT'="Pharmaceutical Aids/Reagents"
'MDCD_FFS_RECTAL'="Rectal, Local"
'MDCD_FFS_RESP'="Respiratory Tract Medications"
'MDCD_FFS_THERAPU'="Theraputic Nutrients/Minerals/Electrolytes"
'MDCD_FFS_UNCLASS'="Unclassified"
'MDCD_FFS_VITA'="Vitamins"
;
run;
