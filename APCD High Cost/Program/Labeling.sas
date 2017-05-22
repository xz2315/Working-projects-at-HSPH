*****************************
APCD Label and Format
Xiner Zhou
8/11/2014
*****************************;
proc format;
value IncomeRank_
1="Quartile 1:Lowest Median House Income"
2="Quartile 2"
3="Quartile 3"
4="Quartile 4:Highest Median House Income"
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
proc format ;
value AgeGroup_
1="Age<18"
2="18<=Age<25"
3="25<=Age<35"
4="35<=Age<45"
5="45<=Age<55"
6="55<=Age<65"
7="65<=Age<75"
8="75<=Age<85"
9="Age>=85"
;
run;

proc format;
value $PCP_
1='Yes'
2='No'
3='Unknown'
4='Other'
5='Not Applicable'
;
run;

 proc format;
 value $PaymentArrangementType_
'01'='Capitation'
'02'='Fee for Service'
'03'='Percent of Charges'
'04'='DRG'
'05'='Pay for Performance'
'06'='Global Payment'
'07'='Other'
'08'='Bundled Payment'
'09'='Payment Amount Per Episode (PAPE) (MassHealth)'
;
run;



proc format;
value $EntityCodeCleaned_
'01'= 'Academic Institution'
'02'= 'Adult Foster Care'
'03'= 'Ambulance Services'
'04'= 'Hospital Based Clinic'
'05'= 'Stand-Alone, Walk-In/Urgent Care Clinic'
'06'= 'Other Clinic'
'07'= 'Community Health Center ・General'
'08'= 'Community Health Center ・Urgent Care'
'09'= 'Government Agency'
'10'= 'Health Care Corporation'
'11'= 'Home Health Agency'
'12'= 'Acute Hospital'
'13'= 'Chronic Hospital'
'14'= 'Rehabilitation Hospital'
'15'= 'Psychiatric Hospital'
'16'= 'DPH Hospital'
'17'= 'State Hospital'
'18'= 'Veterans Hospital'
'19'= 'DMH Hospital'
'20'= 'Sub-Acute Hospital'
'21'= 'Licensed Hospital Satellite Emergency Facility'
'22'= 'Hospital Emergency Center'
'23'= 'Nursing Home'
'24'= 'Freestanding Ambulatory Surgery Center'
'25'= 'Hospital Licensed Ambulatory Surgery Center'
'26'= 'Non-Health Corporations'
'27'= 'School Based Health Center'
'28'= 'Rest Home'
'29'= 'Licensed Hospital Satellite Facility'
'30'= 'Hospital Licensed Health Center'
'31'= 'Other(Include Individual)'
;
run;


proc format ;
value $CoverageLevelCode_
'CHD'='Children Only'
'DEP'='Dependents Only'
'ECH'='Employee and Children'
'ELF'='Employee and Life Partner'
'EMP'='Employee Only'
'ESP'='Employee and Spouse=FAM'
'Family'='IND=Individual'
'SPC'='Spouse and Children'
'SPO'='Spouse Only'
'UNK'='Unknown'
;
run;

proc format;
value $coveragetype_
'ASW'='Self-funded plans that are administered by a third-party administrator, where the employer has purchased stop-loss, or group excess, insurance coverage'
'ASO'='Self-funded plans that are administered by a third-party administrator, where the employer has not purchased stop-loss, or group excess, insurance coverage'
'STN'='Short-term, non-renewable health insurance'
'UND'='Plans underwritten by the insurer'
'OTH'='Any other plan. Insurers using this code shall obtain prior approval'
;
run;

proc format;
value $maritalstatus_
'C'='Common Law Married'
'D'='Divorced'
'M'='Married'
'P'='Domestic Partnership'
'S'='Never Married'
'W'='Widowed'
'X'='Legally Separated'
'U'='Unknown'
;
run;

proc format ;
value $ Initial_SurgicalMedical_
'0' = 'Problem with initial DRG assignment' 
'1' = 'Medical DRG' 
'2' = 'Surgical DRG'
;
run;
proc format ;
value $ Final_SurgicalMedical_
'0' = 'Problem with Final DRG assignment' 
'1' = 'Medical DRG' 
'2' = 'Surgical DRG'
;
run;
proc format;
value $ note_
'00' = 'OK, DRG assigned'
'01' = 'Diagnosis code cannot be used as PDX'
'02' = 'Record does not meet criteria for any DRG'
'03' = 'Invalid age'
'04' = 'Invalid sex'
'05' = 'Invalid discharge status'
'10' = 'Illogical PDX'
'11' = 'Invalid PDX'
'12' = 'POA logic nonexempt - HAC-POA(s) invalid, missing, or 1 (batch only)'
'13' = 'POA logic invalid/missing - HAC-POA(s) are N, U (batch only)'
'14' = 'POA logic invalid/missing - HAC-POA(s) invalid/missing or 1 (batch only)'
'18' = 'POA logic invld/mssng - multiple distinct HAC-POAs not Y,W (batch only)'
;
run;
proc format;
value $ return_code_
'0000' = 'Medicare Code Editor - No errors found'
'0001' = 'Medicare Code Editor - Pre-payment error' 
'0002' = 'Medicare Code Editor - Post-payment error'
'0003' = 'Medicare Code Editor - Pre- and post-payment errors'
'0004' = 'Medicare Code Editor - Invalid discharge date'
;
run;

proc format ;
value $ dx1_note_
'00' = 'Diagnosis not used to assign DRG'
'01' = 'Invalid diagnosis code'
'02' = 'Sex conflict'
'03' = 'Not applicable for principal diagnosis'
'04'= 'Age conflict'
'05' = 'E-code as principal diagnosis'
'06' = 'Non-specific principal diagnosis (MCE versions 15.0・3.0 only)'
'07' = 'Manifestation code as principal diagnosis'
'08' = 'Questionable admission'
'09' = 'Unacceptable principal diagnosis'
'10' = 'Secondary diagnosis required'
'11' = 'Principal diagnosis is its own CC'
'12' = 'Diagnosis affected both initial and final DRG assignment'
'13' = 'MSP alert (MCE versions 15.0・7.0 only)'
'14' = 'Principal diagnosis is its own MCC'
'15' = 'Diagnosis affected the final DRG only'
'16' = 'Diagnosis affected the initial DRG only'
'17' = 'Diagnosis is a MCC for initial DRG and a Non-CC for final DRG'
'18' = 'Diagnosis is a CC for initial DRG and a Non-CC for final DRG'
'19' = 'Wrong Procedure Performed'
'21' = 'Diagnosis is a CC but not considered due to PDX/SDX exclusion'
'23' = 'Diagnosis is a MCC but not considered due to PDX/SDX exclusion'
'99' = 'Principal diagnosis part of HAC assignment criteria'
;
run;
proc format;
value $ HAC_c_
'00' = 'Criteria to be assigned as a HAC not met'
'11' = 'Infection after bariatric surgery'
'' = 'Diagnosis was not considered by grouper'
;
run;

proc format;
value $ dx1_HAC_u_
'0' = 'HAC not applicable'
'1' = 'HAC criteria met'
'2' = 'HAC criteria not met'
'3' = 'Dx on HAC list, but HAC not applicable due to PDX/SDX exclusion'
'4' = 'HAC not applicable, hospital is exempt from POA reporting'
'' = 'Diagnosis was not considered by grouper'
;
run;
 
proc format;
value $Proc_note_
'00' = 'Procedure did not affect DRG assignment'
'01' = 'Invalid procedure code'
'02' = 'Sex conflict'
'12' = 'Procedure affected both initial and final DRG assignment'
'15' = 'Procedure affected the final DRG assignment only'
'16' = 'Procedure affected the initial DRG assignment only'
'20' = 'Procedure is an OR procedure'
'21' = 'Non-specific OR procedure (MCE versions 15.0 - 23.0 only)'
'22' = 'Open biopsy check (MCE versions 2.0 - 27.0 only)'
'23' = 'Non-covered procedure'
'24' = 'Bilateral procedure'
'30' = 'Lung volume reduction surgery (LVRS) - limited coverage'
'31' = 'Lung transplant - limited coverage'
'32' = 'Combo heart/lung transplant - limited coverage'
'33' = 'Heart transplant - limited coverage'
'34' = 'Implantable hrt assist - limited coverage'
'35' = 'Intest/multi-visceral transplant - limited coverage'
;
run;


proc format;
value $ DRG_CCMCC_
'0' = 'DRG assigned is not based on the presence of CC or MCC'
'1' = 'DRG assigned is based on presence of MCC'
'2' = 'DRG assigned is based on presence of CC'
;
run;

proc format ;
value $ HAC_Status_
'0'='HAC Status: Not Applicable'
'1'='HAC Status: One or more HAC criteria met; Final DRG does not change'
'2'='HAC Status: One or more HAC criteria met; Final DRG changes'
'3'='HAC Status: One or more HAC criteria met; Final DRG changes to ungroupable'
;
run;

proc fomat;
value $ DRG_
'001'='MDC P,Heart transplant or implant of heart assist system w MCC'
'002'='MDC P,Heart transplant or implant of heart assist system w/o MCC'
'003'='MDC P,ECMO or trach w MV 96+ hrs or PDX exc face, mouth & neck w maj O.R.'
'004'='MDC P,Trach w MV 96+ hrs or PDX exc face, mouth & neck w/o maj O.R.'
'005'='MDC P,Liver transplant w MCC or intestinal transplant'
'006'='MDC P,Liver transplant w/o MCC'
'007'='MDC P,Lung transplant'
'008'='MDC P,Simultaneous pancreas/kidney transplant'
'010'='MDC P,Pancreas transplant'
'011'='MDC P,Tracheostomy for face,mouth & neck diagnoses w MCC'
'012'='MDC P,Tracheostomy for face,mouth & neck diagnoses w CC'
'013'='MDC P,Tracheostomy for face,mouth & neck diagnoses w/o CC/MCC'
'014'='MDC P,Allogeneic bone marrow transplant'
'016'='MDC P,Autologous bone marrow transplant w CC/MCC'
'017'='MDC P,Autologous bone marrow transplant w/o CC/MCC'
'020'='MDC 01P,Intracranial vascular procedures w PDX hemorrhage w MCC'
'021'='MDC 01P,Intracranial vascular procedures w PDX hemorrhage w CC'
'022'='MDC 01P,Intracranial vascular procedures w PDX hemorrhage w/o CC/MCC'
'023'='MDC 01P,Cranio w major dev impl/acute complex CNS PDX w MCC or chemo implant'
'024'='MDC 01P,Cranio w major dev impl/acute complex CNS PDX w/o MCC'
'025'='MDC 01P,Craniotomy & endovascular intracranial procedures w MCC'
'026'='MDC 01P,Craniotomy & endovascular intracranial procedures w CC'
'027'='MDC 01P,Craniotomy & endovascular intracranial procedures w/o CC/MCC'
'028'='MDC 01P,Spinal procedures w MCC'
'029'='MDC 01P,Spinal procedures w CC or spinal neurostimulators'
'030'='MDC 01P,Spinal procedures w/o CC/MCC'
'031'='MDC 01P,Ventricular shunt procedures w MCC'
'032'='MDC 01P,Ventricular shunt procedures w CC'
'033'='MDC 01P,Ventricular shunt procedures w/o CC/MCC'
'034'='MDC 01P,Carotid artery stent procedure w MCC'
'035'='MDC 01P,Carotid artery stent procedure w CC'
'036'='MDC 01P,Carotid artery stent procedure w/o CC/MCC'
'037'='MDC 01P,Extracranial procedures w MCC'
'038'='MDC 01P,Extracranial procedures w CC'
'039'='MDC 01P,Extracranial procedures w/o CC/MCC'
'040'='MDC 01P,Periph/cranial nerve & other nerv syst proc w MCC'
'041'='MDC 01P,Periph/cranial nerve & other nerv syst proc w CC or periph neurostim'
'042'='MDC 01P,Periph/cranial nerve & other nerv syst proc w/o CC/MCC'
'052'='MDC 01M,Spinal disorders & injuries w CC/MCC'
'053'='MDC 01M,Spinal disorders & injuries w/o CC/MCC'
'054'='MDC 01M,Nervous system neoplasms w MCC'
'055'='MDC 01M,Nervous system neoplasms w/o MCC'
'056'='MDC 01M,Degenerative nervous system disorders w MCC'
'057'='MDC 01M,Degenerative nervous system disorders w/o MCC'
'058'='MDC 01M,Multiple sclerosis & cerebellar ataxia w MCC'
'059'='MDC 01M,Multiple sclerosis & cerebellar ataxia w CC'
'060'='MDC 01M,Multiple sclerosis & cerebellar ataxia w/o CC/MCC'
'061'='MDC 01M,Acute ischemic stroke w use of thrombolytic agent w MCC'
'062'='MDC 01M,Acute ischemic stroke w use of thrombolytic agent w CC'
'063'='MDC 01M,Acute ischemic stroke w use of thrombolytic agent w/o CC/MCC'
'064'='MDC 01M,Intracranial hemorrhage or cerebral infarction w MCC'
'065'='MDC 01M,Intracranial hemorrhage or cerebral infarction w CC or tPA in 24 hrs'
'066'='MDC 01M,Intracranial hemorrhage or cerebral infarction w/o CC/MCC'
'067'='MDC 01M,Nonspecific cva & precerebral occlusion w/o infarct w MCC'
'068'='MDC 01M,Nonspecific cva & precerebral occlusion w/o infarct w/o MCC'
'069'='MDC 01M,Transient ischemia'
'070'='MDC 01M,Nonspecific cerebrovascular disorders w MCC'
'071'='MDC 01M,Nonspecific cerebrovascular disorders w CC'
'072'='MDC 01M,Nonspecific cerebrovascular disorders w/o CC/MCC'
'073'='MDC 01M,Cranial & peripheral nerve disorders w MCC'
'074'='MDC 01M,Cranial & peripheral nerve disorders w/o MCC'
'075'='MDC 01M,Viral meningitis w CC/MCC'
'076'='MDC 01M,Viral meningitis w/o CC/MCC'
'077'='MDC 01M,Hypertensive encephalopathy w MCC'
'078'='MDC 01M,Hypertensive encephalopathy w CC'
'079'='MDC 01M,Hypertensive encephalopathy w/o CC/MCC'
'080'='MDC 01M,Nontraumatic stupor & coma w MCC'
'081'='MDC 01M,Nontraumatic stupor & coma w/o MCC'
'082'='MDC 01M,Traumatic stupor & coma, coma >1 hr w MCC'
'083'='MDC 01M,Traumatic stupor & coma, coma >1 hr w CC'
'084'='MDC 01M,Traumatic stupor & coma, coma >1 hr w/o CC/MCC'
'085'='MDC 01M,Traumatic stupor & coma, coma <1 hr w MCC'
'086'='MDC 01M,Traumatic stupor & coma, coma <1 hr w CC'
'087'='MDC 01M,Traumatic stupor & coma, coma <1 hr w/o CC/MCC'
'088'='MDC 01M,Concussion w MCC'
'089'='MDC 01M,Concussion w CC'
'090'='MDC 01M,Concussion w/o CC/MCC'
'091'='MDC 01M,Other disorders of nervous system w MCC'
'092'='MDC 01M,Other disorders of nervous system w CC'
'093'='MDC 01M,Other disorders of nervous system w/o CC/MCC'
'094'='MDC 01M,Bacterial & tuberculous infections of nervous system w MCC'
'095'='MDC 01M,Bacterial & tuberculous infections of nervous system w CC'
'096'='MDC 01M,Bacterial & tuberculous infections of nervous system w/o CC/MCC'
'097'='MDC 01M,Non-bacterial infect of nervous sys exc viral meningitis w MCC'
'098'='MDC 01M,Non-bacterial infect of nervous sys exc viral meningitis w CC'
'099'='MDC 01M,Non-bacterial infect of nervous sys exc viral meningitis w/o CC/MCC'
'100'='MDC 01M,Seizures w MCC'
'101'='MDC 01M,Seizures w/o MCC'
'102'='MDC 01M,Headaches w MCC'
'103'='MDC 01M,Headaches w/o MCC'
'113'='MDC 02P,Orbital procedures w CC/MCC'
'114'='MDC 02P,Orbital procedures w/o CC/MCC'
'115'='MDC 02P,Extraocular procedures except orbit'
'116'='MDC 02P,Intraocular procedures w CC/MCC'
'117'='MDC 02P,Intraocular procedures w/o CC/MCC'
'121'='MDC 02M,Acute major eye infections w CC/MCC'
'122'='MDC 02M,Acute major eye infections w/o CC/MCC'
'123'='MDC 02M,Neurological eye disorders'
'124'='MDC 02M,Other disorders of the eye w MCC'
'125'='MDC 02M,Other disorders of the eye w/o MCC'
'129'='MDC 03P,Major head & neck procedures w CC/MCC or major device'
'130'='MDC 03P,Major head & neck procedures w/o CC/MCC'
'131'='MDC 03P,Cranial/facial procedures w CC/MCC'
'132'='MDC 03P,Cranial/facial procedures w/o CC/MCC'
'133'='MDC 03P,Other ear, nose, mouth & throat O.R. procedures w CC/MCC'
'134'='MDC 03P,Other ear, nose, mouth & throat O.R. procedures w/o CC/MCC'
'135'='MDC 03P,Sinus & mastoid procedures w CC/MCC'
'136'='MDC 03P,Sinus & mastoid procedures w/o CC/MCC'
'137'='MDC 03P,Mouth procedures w CC/MCC'
'138'='MDC 03P,Mouth procedures w/o CC/MCC'
'139'='MDC 03P,Salivary gland procedures'
'146'='MDC 03M,Ear, nose, mouth & throat malignancy w MCC'
'147'='MDC 03M,Ear, nose, mouth & throat malignancy w CC'
'148'='MDC 03M,Ear, nose, mouth & throat malignancy w/o CC/MCC'
'149'='MDC 03M,Dysequilibrium'
'150'='MDC 03M,Epistaxis w MCC'
'151'='MDC 03M,Epistaxis w/o MCC'
'152'='MDC 03M,Otitis media & URI w MCC'
'153'='MDC 03M,Otitis media & URI w/o MCC'
'154'='MDC 03M,Other ear, nose, mouth & throat diagnoses w MCC'
'155'='MDC 03M,Other ear, nose, mouth & throat diagnoses w CC'
'156'='MDC 03M,Other ear, nose, mouth & throat diagnoses w/o CC/MCC'
'157'='MDC 03M,Dental & Oral Diseases w MCC'
'158'='MDC 03M,Dental & Oral Diseases w CC'
'159'='MDC 03M,Dental & Oral Diseases w/o CC/MCC'
'163'='MDC 04P,Major chest procedures w MCC'
'164'='MDC 04P,Major chest procedures w CC'
'165'='MDC 04P,Major chest procedures w/o CC/MCC'
'166'='MDC 04P,Other resp system O.R. procedures w MCC'
'167'='MDC 04P,Other resp system O.R. procedures w CC'
'168'='MDC 04P,Other resp system O.R. procedures w/o CC/MCC'
'175'='MDC 04M,Pulmonary embolism w MCC'
'176'='MDC 04M,Pulmonary embolism w/o MCC'
'177'='MDC 04M,Respiratory infections & inflammations w MCC'
'178'='MDC 04M,Respiratory infections & inflammations w CC'
'179'='MDC 04M,Respiratory infections & inflammations w/o CC/MCC'
'180'='MDC 04M,Respiratory neoplasms w MCC'
'181'='MDC 04M,Respiratory neoplasms w CC'
'182'='MDC 04M,Respiratory neoplasms w/o CC/MCC'
'183'='MDC 04M,Major chest trauma w MCC'
'184'='MDC 04M,Major chest trauma w CC'
'185'='MDC 04M,Major chest trauma w/o CC/MCC'
'186'='MDC 04M,Pleural effusion w MCC'
'187'='MDC 04M,Pleural effusion w CC'
'188'='MDC 04M,Pleural effusion w/o CC/MCC'
'189'='MDC 04M,Pulmonary edema & respiratory failure'
'190'='MDC 04M,Chronic obstructive pulmonary disease w MCC'
'191'='MDC 04M,Chronic obstructive pulmonary disease w CC'
'192'='MDC 04M,Chronic obstructive pulmonary disease w/o CC/MCC'
'193'='MDC 04M,Simple pneumonia & pleurisy w MCC'
'194'='MDC 04M,Simple pneumonia & pleurisy w CC'
'195'='MDC 04M,Simple pneumonia & pleurisy w/o CC/MCC'
'196'='MDC 04M,Interstitial lung disease w MCC'
'197'='MDC 04M,Interstitial lung disease w CC'
'198'='MDC 04M,Interstitial lung disease w/o CC/MCC'
'199'='MDC 04M,Pneumothorax w MCC'
'200'='MDC 04M,Pneumothorax w CC'
'201'='MDC 04M,Pneumothorax w/o CC/MCC'
'202'='MDC 04M,Bronchitis & asthma w CC/MCC'
'203'='MDC 04M,Bronchitis & asthma w/o CC/MCC'
'204'='MDC 04M,Respiratory signs & symptoms'
'205'='MDC 04M,Other respiratory system diagnoses w MCC'
'206'='MDC 04M,Other respiratory system diagnoses w/o MCC'
'207'='MDC 04M,Respiratory system diagnosis w ventilator support 96+ hours'
'208'='MDC 04M,Respiratory system diagnosis w ventilator support <96 hours'
'215'='MDC 05P,Other heart assist system implant'
'216'='MDC 05P,Cardiac valve & oth maj cardiothoracic proc w card cath w MCC'
'217'='MDC 05P,Cardiac valve & oth maj cardiothoracic proc w card cath w CC'
'218'='MDC 05P,Cardiac valve & oth maj cardiothoracic proc w card cath w/o CC/MCC'
'219'='MDC 05P,Cardiac valve & oth maj cardiothoracic proc w/o card cath w MCC'
'220'='MDC 05P,Cardiac valve & oth maj cardiothoracic proc w/o card cath w CC'
'221'='MDC 05P,Cardiac valve & oth maj cardiothoracic proc w/o card cath w/o CC/MCC'
'222'='MDC 05P,Cardiac defib implant w cardiac cath w AMI/HF/shock w MCC'
'223'='MDC 05P,Cardiac defib implant w cardiac cath w AMI/HF/shock w/o MCC'
'224'='MDC 05P,Cardiac defib implant w cardiac cath w/o AMI/HF/shock w MCC'
'225'='MDC 05P,Cardiac defib implant w cardiac cath w/o AMI/HF/shock w/o MCC'
'226'='MDC 05P,Cardiac defibrillator implant w/o cardiac cath w MCC'
'227'='MDC 05P,Cardiac defibrillator implant w/o cardiac cath w/o MCC'
'228'='MDC 05P,Other cardiothoracic procedures w MCC'
 
;
run;

 






proc format;
value $ EntityCodeCleaned_
'01'= 'Academic Institution'
'02'= 'Adult Foster Care'
'03'= 'Ambulance Services'
'04'= 'Hospital Based Clinic'
'05'= 'Stand-Alone, Walk-In/Urgent Care Clinic'
'06'= 'Other Clinic'
'07'= 'Community Health Center ・General'
'08'= 'Community Health Center ・Urgent Care'
'09'= 'Government Agency'
'10'= 'Health Care Corporation'
'11'= 'Home Health Agency'
'12'= 'Acute Hospital'
'13'= 'Chronic Hospital'
'14'= 'Rehabilitation Hospital'
'15'= 'Psychiatric Hospital'
'16'= 'DPH Hospital'
'17'= 'State Hospital'
'18'= 'Veterans Hospital'
'19'= 'DMH Hospital'
'20'= 'Sub-Acute Hospital'
'21'= 'Licensed Hospital Satellite Emergency Facility'
'22'= 'Hospital Emergency Center'
'23'= 'Nursing Home'
'24'= 'Freestanding Ambulatory Surgery Center'
'25'= 'Hospital Licensed Ambulatory Surgery Center'
'26'= 'Non-Health Corporations'
'27'= 'School Based Health Center'
'28'= 'Rest Home'
'29'= 'Licensed Hospital Satellite Facility'
'30'= 'Hospital Licensed Health Center'
'31'= 'Other'
;
run;

proc format;
value $ ProviderIDCodeCleaned_
'1'= 'Person; physician, clinician, orthodontist, and any individual that is licensed/certified to perform health care services'
'2'='Facility; hospital, health center, long term care,rehabilitation and any building that is licensed to transact health care services'
'3'='Professional Group; collection of licensed/certified health care professionals that are practicing healthcare services under the same entity name and Federal Tax Identification Number'
'4'='Retail Site; brick-and-mortar licensed/certified place of transaction that is not solely a health care entity,i.e., pharmacies, independent laboratories, vision services'
'5'='E-Site; internet-based order/logistic system of health care services, typically in the form of durable medical equipment, pharmacy or vision services.Address assigned should be the address of the company delivering services or order fulfillment'
'6'='Financial Parent; financial governing body that does not perform health care services itself but directs and finances health care service entities, usually through a Board of Directors'
'7'='Transportation; any form of transport that conveys a patient to/from a healthcare provider'
'0'='Other; any type of entity not otherwise defined that performs health care services'
;
run;



proc format;
value $ DischargeStatus_
'01'='Discharged to home/self care (routine charge)'
'02'='Discharged/transferred to other short-term acute care hospital for inpatient care'
'03'='Discharged/transferred to skilled nursing facility (SNF) with Medicare certification in anticipation of covered skilled care'
'04'='Discharged/transferred to intermediate care facility (ICF)'
'05'=' Discharged/Transferred to a Designated Cancer Center or Children痴 Hospital '
'06'='Discharged/transferred to home care of organized home health service organization'
'07'='Left against medical advice or discontinued care'
'08'='Discharged/transferred to home under care of a home IV drug therapy provider'
'09'='Admitted as an inpatient to this hospital'

'10'='Reserved for National Assignment'
'11'='Reserved for National Assignment'
'12'='Reserved for National Assignment'
'13'='Reserved for National Assignment'
'14'='Reserved for National Assignment'
'15'='Reserved for National Assignment'
'16'='Reserved for National Assignment'
'17'='Reserved for National Assignment'
'18'='Reserved for National Assignment'
'19'='Reserved for National Assignment'

'20'='Expired'
'21'='Reserved for National Assignment'
'22'='Reserved for National Assignment'
'23'='Reserved for National Assignment'
'24'='Reserved for National Assignment'
'25'='Reserved for National Assignment'
'26'='Reserved for National Assignment'
'27'='Reserved for National Assignment'
'28'='Reserved for National Assignment'
'29'='Reserved for National Assignment'


'30'='Still Patient: Inpatient- leave of absence days or interim billing'
'31'='Reserved for National Assignment'
'32'='Reserved for National Assignment'
'33'='Reserved for National Assignment'
'34'='Reserved for National Assignment'
'35'='Reserved for National Assignment'
'36'='Reserved for National Assignment'
'37'='Reserved for National Assignment'
'38'='Reserved for National Assignment'
'39'='Reserved for National Assignment'




'40'='Hospice Patient--Expired at home'
'41'='Hospice Patient--Expired in a medical facility such as hospital, SNF, ICF, or freestanding hospice'
'42'='Hospice Patient--Expired - place unknown'
'43'='Discharged/transferred to a federal hospital'
'44'='Reserved for National Assignment'
'45'='Reserved for National Assignment'
'46'='Reserved for National Assignment'
'47'='Reserved for National Assignment'
'48'='Reserved for National Assignment'
'49'='Reserved for National Assignment'



'50'='Discharged/Transferred to Hospice - home'
'51'='Discharged/Transferred to Hospice - medical facility'
'52'='Reserved for National Assignment'
'53'='Reserved for National Assignment'
'54'='Reserved for National Assignment'
'55'='Reserved for National Assignment'
'56'='Reserved for National Assignment'
'57'='Reserved for National Assignment'
'58'='Reserved for National Assignment'
'59'='Reserved for National Assignment'
'60'='Reserved for National Assignment'


'61'='Discharged/transferred within this institution to a hospital-based Medicare approved swing bed'
'62'='Discharged/transferred to an inpatient rehabilitation facility including distinct parts units of a hospital'
'63'='Discharged/transferred to a long term care hospitals'
'64'='Discharged/transferred to a nursing facility certified under Medicaid but not under Medicare'
'65'='Discharged/Transferred to a psychiatric hospital or psychiatric distinct unit of a hospital'
'66'='Discharged/transferred to a Critical Access Hospital (CAH)'
'67'='Reserved for National Assignment'
'68'='Reserved for National Assignment'
'69'='Reserved for National Assignment'


'70'='Discharged/transferred to another type of health care institution not defined elsewhere in code list'
'71'='Discharged/transferred/referred to another institution for outpatient services as specified by the discharge plan of care'
'72'='Discharged/transferred/referred to this institution for outpatient services as specified by the discharge plan of care'
'73'='Reserved for National Assignment'
'74'='Reserved for National Assignment'
'75'='Reserved for National Assignment'
'76'='Reserved for National Assignment'
'77'='Reserved for National Assignment'
'78'='Reserved for National Assignment'
'79'='Reserved for National Assignment'
'80'='Reserved for National Assignment'
'81'='Reserved for National Assignment'
'82'='Reserved for National Assignment'
'83'='Reserved for National Assignment'
'84'='Reserved for National Assignment'
'85'='Reserved for National Assignment'
'86'='Reserved for National Assignment'
'87'='Reserved for National Assignment'
'88'='Reserved for National Assignment'
'89'='Reserved for National Assignment'
'90'='Reserved for National Assignment'
'91'='Reserved for National Assignment'
'92'='Reserved for National Assignment'
'93'='Reserved for National Assignment'
'94'='Reserved for National Assignment'
'95'='Reserved for National Assignment'
'96'='Reserved for National Assignment'
'97'='Reserved for National Assignment'
'98'='Reserved for National Assignment'
'99'='Reserved for National Assignment'


;
run;
 

proc format ;
	value $ InsuranceTypeCodeProduct_  
'09'='Self-pay'
'10'='Central Certification'
'11'='Other Non-Federal Programs'
'12'='Preferred Provider Organization (PPO)'
'13'='Point of Service (POS)'
'14'='Exclusive Provider Organization (EPO)'
'15'='Indemnity Insurance'
'16'='Health Maintenance Organization (HMO) Medicare Advantage'
'17'='Dental Maintenance Organization (DMO)'
'20'='Medicare Advantage PPO'
'21'='Medicare Advantage Private Fee for Service'
'AM'='Automobile Medical'
'BL'='Blue Cross / Blue Shield'
'CC'='Commonwealth Care'
'CE'='Commonwealth Choice'
'CH'='CHAMPUS'
'CI'='Commercial Insurance'
'DS'='Disability'
'HM'='Health Maintenance Organization'
'HN'='HMO Medicare Risk/Medicare Part C'
'LI'='Liability'
'LM'='Liability Medical'
'MA'='Medicare Part A'
'MB'='Medicare Part B'
'MC'='Medicaid'
'MD'='Medicare Part D'
'MO'='Medicaid Managed Care Organization'
'MP'='Medicare Primary'
'MS'='Medicare Secondary Plan'
'OF'='Other Federal Program (e.g. Black Lung)'
'QM'='Qualified Medicare Beneficiary'
'SC'='Senior Care Option'
'SP'='Supplemental Policy'
'TF'='HSN Trust Fund'
'TV'='Title V'
'VA'='Veterans Administration Plan'
'WC'='Workers Compensation'
'ZZ'='Other';
run;

proc format;
	value $ MedicareCode_
'1'='Part A Only'
'2'='Part B Only'
'3'='Part A and B'
'4'='Part C Only'
'5'='Advantage'
'6'='Part D Only'
'9'='Not Applicable'
'0'='No Medicare Coverage';
run;

/*

proc sort data=apcd.carrier out=temp(keep=OrgID OrganizationName) nodupkey;by OrgID OrganizationName;run;
ods rtf;
proc print data=temp noobs;run;
ods rtf;
*/
proc format;
value  OrgID_ 
290=' Aetna Health Inc. (PA) - Aetna Life Ins. Co. (ALIC)'  
291=' Blue Cross Blue Shield of Massachusetts ' 
293=' CIGNA HealthCare of Massachusetts, Inc. - Medical'  
295=' Connecticut General Life Insurance Company - Medical'  
296=' Fallon Community Health Plan'
299=' Guardian Life Insurance Company of America'  
300=' Harvard Pilgrim Health Care' 
301=' Health New England, Inc.'  
302=' Health Plans, Inc.'  
305=' Principal Life Insurance Company'  
310=' UniCare Life and Health Insurance Company'  
312=' United Healthcare Insurance Company'
313=' United Healthcare of New England, Inc.'  
3156=' MassHealth'  
3505=' Boston Medical Center HealthNet Plan'  
3735=' Neighborhood Health Plan'  
4933=' Altus Dental Insurance Company, Inc.'  
4962=' Network Health'  
6999=' Metropolitan Life Insurance Company'  
7041=' ConnectiCare of Massachusetts, Inc.'  
7221=' UMR, Inc.'  
7249=' American Heritage Life Insurance Company'  
7268=' Humana Insurance Company'  
7273=' Nationwide Life Insurance Company'  
7285=' Physicians Mutual Insurance Company'  
7397=' Blue Cross and Blue Shield of Alabama'  
7421=' HealthSmart Benefit Solutions, Inc.'  
7422=' CIGNA Behavioral Health, Inc.'  
7431=' EBS-RMSCO, Inc.'  
7610=' UltraBenefits, Inc.'  
7655=' Aetna Life Insurance Company - Strategic Resource Company'  
7789=' United Healthcare Student Resources'  
8026=' Fallon Health and Life Assurance Company'  
8647=' Tufts Health Plan'  
9891=' Beacon Health Strategies, LLC (Medicaid MCO)'  
9913=' Senior Whole Health'  
10353=' Aetna Life Insurance Company - Aetna Student Health'  
10441=' Aetna Life Insurance Company'  
10442=' Aetna Life Insurance Company - Self-Insured Health Plans'  
10444=' United Healthcare Insurance Company - Harvard Pilgrim Health Care Joint Venture'  
10447=' Connecticut General Life Insurance Company - Dental'  
10632=' WellPoint, Inc.'  
10647=' Aetna Health, Inc. - Aetna Health Insurance Company HMO and POS Business on the Automated Claims Adjudication System (ACAS)' 
10920=' Celticare of Massachusetts'  
10922=' Standard Insurance Company'  
10923=' Reliance Standard Life Insurance Company'  
10924=' Ameritas Life Insurance Corporation'  
10926=' United Healthcare Insurance Company - Medicare Advantage'  
10929=' Aetna Life Insurance Company - Medicare'  
10932=' United Healthcare Insurance Company - United Behavioral Health'  
10933=' United Healthcare Insurance Company - Physical Health'  
10935=' United Healthcare Insurance Company - OptumHealth Vision'  
10936=' The Lincoln National Life Insurance Company'  
10937=' Dearborn National Life Insurance Company - Dental Network of America, LLC'  
10939=' American General Life Companies' 
10948=' Delta Dental Plan of Michigan, Inc.'  
10949=' Renaissance Life & Health Insurance Company of America'  
10953=' Medco Health Services'  
10954=' Medco Containment Life Insurance Company'  
11065=' Dental Service of Massachusetts, Inc. (Denta Quest)'  
11215=' Connecticut General Life Insurance Company - FAC'  
11216=' Great-West Life & Annuity Insurance Company - FAC'  
11237=' First American Administrators, Inc.'  
11347=' Horizon Blue Cross and Blue Shield of NJ'  
11371=' Express Scripts Inc.'  
11377=' New England Dental Administrators' 
11426=' United Concordia Companies, Inc.'  
11446=' Davis Vision, Inc. ' 
11474=' CIGNA Health and Life Insurance Company (CHLIC)'  
11499=' CIGNA HealthCare - Voluntary Division'  
11541=' Health Safety Net (DHCFP)'  
11609=' QCC Insurance Company'  
11611=' Blue Cross Blue Shield of Tennessee'  
11701=' Blue Cross Blue Shield of Massachusetts SI'  
11726=' Cigna Health and Life Ins. Co. (EAST)'  
11869=' United Concordia Companies, Inc. - Sun Life of Canada'  
11939=' Key Benefit Administrators, Inc. - KBA';
run; 
proc format;
value  $Payer_ 
290=' Aetna Health Inc. (PA) - Aetna Life Ins. Co. (ALIC)'  
291=' Blue Cross Blue Shield of Massachusetts ' 
293=' CIGNA HealthCare of Massachusetts, Inc. - Medical'  
295=' Connecticut General Life Insurance Company - Medical'  
296=' Fallon Community Health Plan'
299=' Guardian Life Insurance Company of America'  
300=' Harvard Pilgrim Health Care' 
301=' Health New England, Inc.'  
302=' Health Plans, Inc.'  
305=' Principal Life Insurance Company'  
310=' UniCare Life and Health Insurance Company'  
312=' United Healthcare Insurance Company'
313=' United Healthcare of New England, Inc.'  
3156=' MassHealth'  
3505=' Boston Medical Center HealthNet Plan'  
3735=' Neighborhood Health Plan'  
4933=' Altus Dental Insurance Company, Inc.'  
4962=' Network Health'  
6999=' Metropolitan Life Insurance Company'  
7041=' ConnectiCare of Massachusetts, Inc.'  
7221=' UMR, Inc.'  
7249=' American Heritage Life Insurance Company'  
7268=' Humana Insurance Company'  
7273=' Nationwide Life Insurance Company'  
7285=' Physicians Mutual Insurance Company'  
7397=' Blue Cross and Blue Shield of Alabama'  
7421=' HealthSmart Benefit Solutions, Inc.'  
7422=' CIGNA Behavioral Health, Inc.'  
7431=' EBS-RMSCO, Inc.'  
7610=' UltraBenefits, Inc.'  
7655=' Aetna Life Insurance Company - Strategic Resource Company'  
7789=' United Healthcare Student Resources'  
8026=' Fallon Health and Life Assurance Company'  
8647=' Tufts Health Plan'  
9891=' Beacon Health Strategies, LLC (Medicaid MCO)'  
9913=' Senior Whole Health'  
10353=' Aetna Life Insurance Company - Aetna Student Health'  
10441=' Aetna Life Insurance Company'  
10442=' Aetna Life Insurance Company - Self-Insured Health Plans'  
10444=' United Healthcare Insurance Company - Harvard Pilgrim Health Care Joint Venture'  
10447=' Connecticut General Life Insurance Company - Dental'  
10632=' WellPoint, Inc.'  
10647=' Aetna Health, Inc. - Aetna Health Insurance Company HMO and POS Business on the Automated Claims Adjudication System (ACAS)' 
10920=' Celticare of Massachusetts'  
10922=' Standard Insurance Company'  
10923=' Reliance Standard Life Insurance Company'  
10924=' Ameritas Life Insurance Corporation'  
10926=' United Healthcare Insurance Company - Medicare Advantage'  
10929=' Aetna Life Insurance Company - Medicare'  
10932=' United Healthcare Insurance Company - United Behavioral Health'  
10933=' United Healthcare Insurance Company - Physical Health'  
10935=' United Healthcare Insurance Company - OptumHealth Vision'  
10936=' The Lincoln National Life Insurance Company'  
10937=' Dearborn National Life Insurance Company - Dental Network of America, LLC'  
10939=' American General Life Companies' 
10948=' Delta Dental Plan of Michigan, Inc.'  
10949=' Renaissance Life & Health Insurance Company of America'  
10953=' Medco Health Services'  
10954=' Medco Containment Life Insurance Company'  
11065=' Dental Service of Massachusetts, Inc. (Denta Quest)'  
11215=' Connecticut General Life Insurance Company - FAC'  
11216=' Great-West Life & Annuity Insurance Company - FAC'  
11237=' First American Administrators, Inc.'  
11347=' Horizon Blue Cross and Blue Shield of NJ'  
11371=' Express Scripts Inc.'  
11377=' New England Dental Administrators' 
11426=' United Concordia Companies, Inc.'  
11446=' Davis Vision, Inc. ' 
11474=' CIGNA Health and Life Insurance Company (CHLIC)'  
11499=' CIGNA HealthCare - Voluntary Division'  
11541=' Health Safety Net (DHCFP)'  
11609=' QCC Insurance Company'  
11611=' Blue Cross Blue Shield of Tennessee'  
11701=' Blue Cross Blue Shield of Massachusetts SI'  
11726=' Cigna Health and Life Ins. Co. (EAST)'  
11869=' United Concordia Companies, Inc. - Sun Life of Canada'  
11939=' Key Benefit Administrators, Inc. - KBA';
run; 

/* First Digit=type of facility
   Second Digit=Bill Classification
*/
proc format ;
value $TypeOfBillOnFacilityClaims_
11='Hospital Inpatient'
12='Hospital Inpatient(Medicare part B only)'
13='Hospital Outpatient'
14='Hospital:Outpatient Diagnostic Services'

18='Hospital:Swing Beds'
 
21='Skilled Nursing '
22='Skilled Nursing(Medicare part B only)'
23='Skilled Nursing Outpatient'
 

32='Home Health Inpatient(Not under a plan or treatment)'
33='Coordinated Home Health(A treatment plan including DME)'
34='Home Health Service(Not under a plan or treatment)'
 
41='Religious Non-Medical Healthcare Institution-Hospital inpatient'
 
43='Religious Non-Medical Healthcare Institution-Outpatient service'
 
51='Christian Science(Extended Care):Inpatient'
52='Christian Science(Extended Care):Inpatient'
53='Christian Science(Extended Care):Outpatient'
54='Christian Science(Extended Care):Referenced Diagnostic Services'
55='Christian Science(Extended Care):Intermediate Care-level I'
56='Christian Science(Extended Care):Intermediate Care-level III'
57='Christian Science(Extended Care):Subacute Inpatient'
58='Christian Science(Extended Care):Swing Beds'
59='Christian Science(Extended Care):Unclassified'

61='Intermediate Cate:Inpatient'
62='Intermediate Cate:Inpatient'
63='Intermediate Cate:Outpatient'
64='Intermediate Cate:Referenced Diagnostic Services'
65='Intermediate Cate:Intermediate Care-level I'
66='Intermediate Cate:Intermediate Care-level III'
67='Intermediate Cate:Subacute Inpatient'
68='Intermediate Cate:Swing Beds'
69='Intermediate Cate:Unclassified'
71='Clinic Rural Health'
72='Hospital Based or Independent Renal Dialysis Center'
73='Free Standing Clinic '
74='Clinic-Outpatient Rehabilitation Facility(ORF)'
75='Clinic-Comprehensive Outpatient Rehabilitation Facility(CORF) '
76='Clinic-Community Mental Health Center'
77='Clinic-Federally Qualified Health Center'
78='Licensed free standing emergency medical facility'
79='Clinic other'

81='Specialty Facility:Hospice(Non-Hospital Based)'
82='Specialty Facility:Hospice(Hospital Based)'
83='Specialty Facility:Ambulatory Surgery Center'
84='Specialty Facility:Free Standing Birthing Center'
85='Specialty Facility:Critical Access Hospital '
86='Specialty Facility:Residential Facility'
 
89='Specialty Facility:other'
;
run;

proc format;
value $ClaimLineType_
O='Original'
V='Void'
R='Replacement'
B='Back Out'
A='Amendment';
run;

proc format ;
value $DeniedFlag_
1='Denied'
2='Accepted'
;
run;

proc format;
value $ClaimStatus_
01='Processed as primary'
02='Processed as secondary'
03='Processed as tertiary'
04='Denied'
19='Processed as primary, forwarded to additional payer(s)'
20='Processed as secondary, forwarded to additional payer(s)'
21='Processed as tertiary, forwarded to additional payer(s)'
22='Reversal of previous payment'
23='Not our claim, forwarded to additional payer(s)'
25='Predetermination Pricing Only - no payment'
;
run;

proc format;
value $ProcedureCodeType_
1='CPT or HCPCS Level 1 Code'
2='HCPCS Level II Code'
3='HCPCS Level III Code (State Medicare code)'
4='American Dental Association (ADA) Procedure Code (Also referred to as CDT code.)'
5='State defined Procedure Code'
6='CPT Category II';
run;

proc format;
value OrgID_
290 ='Aetna Health Inc. (PA) - Aetna Life Ins. Co. (ALIC)'  
291 = 'Blue Cross Blue Shield of Massachusetts' 
293 ='CIGNA HealthCare of Massachusetts, Inc. - Medical' 
295 ='Connecticut General Life Insurance Company - Medical'  
296 ='Fallon Community Health Plan ' 
299 ='Guardian Life Insurance Company of America'  
300 ='Harvard Pilgrim Health Care'  
301 ='Health New England, Inc.'  
302 ='Health Plans, Inc.'  
305 ='Principal Life Insurance Company ' 
310 ='UniCare Life and Health Insurance Company'  
312 ='United Healthcare Insurance Company'  
313 ='United Healthcare of New England, Inc.'  
3156 ='MassHealth ' 
3505 ='Boston Medical Center HealthNet Plan'  
3735 ='Neighborhood Health Plan ' 
4933 ='Altus Dental Insurance Company, Inc.'  
4962 ='Network Health'  
6999 ='Metropolitan Life Insurance Company'  
7041 ='ConnectiCare of Massachusetts, Inc.'  
7221 ='UMR, Inc.'  
7249 ='American Heritage Life Insurance Company'  
7268 ='Humana Insurance Company'  
7273 ='Nationwide Life Insurance Company'  
7285 ='Physicians Mutual Insurance Company'  
7397 ='Blue Cross and Blue Shield of Alabama'  
7421 ='HealthSmart Benefit Solutions, Inc.'  
7422 ='CIGNA Behavioral Health, Inc.'  
7431 ='EBS-RMSCO, Inc.'  
7610 ='UltraBenefits, Inc. ' 
7655 ='Aetna Life Insurance Company - Strategic Resource Company'  
7789 ='United Healthcare Student Resources'  
8026 ='Fallon Health and Life Assurance Company'  
8647 ='Tufts Health Plan'  
9891 ='Beacon Health Strategies, LLC (Medicaid MCO)'  
9913 ='Senior Whole Health'  
10353 ='Aetna Life Insurance Company - Aetna Student Health'  
10435 ='Humana Dental Insurance Company'  
10441 ='Aetna Life Insurance Company'  
10442 ='Aetna Life Insurance Company - Self-Insured Health Plans'  
10444 ='United Healthcare Insurance Company - Harvard Pilgrim Health Care Joint Venture'  
10447 ='Connecticut General Life Insurance Company - Dental'  
10632 ='WellPoint, Inc.'  
10647 ='Aetna Health, Inc. - Aetna Health Insurance Company HMO and POS Business on the Automated Claims Adjudication System (ACAS)' 
10920 ='Celticare of Massachusetts'  
10922 ='Standard Insurance Company'  
10923 ='Reliance Standard Life Insurance Company'  
10924 ='Ameritas Life Insurance Corporation'  
10926 ='United Healthcare Insurance Company - Medicare Advantage'  
10929 ='Aetna Life Insurance Company - Medicare'  
10932 ='United Healthcare Insurance Company - United Behavioral Health'  
10933 ='United Healthcare Insurance Company - Physical Health'  
10935 ='United Healthcare Insurance Company - OptumHealth Vision'  
10936 ='The Lincoln National Life Insurance Company'  
10937 ='Dearborn National Life Insurance Company - Dental Network of America, LLC'  
10939 ='American General Life Companies'  
10948 ='Delta Dental Plan of Michigan, Inc. ' 
10949 ='Renaissance Life & Health Insurance Company of America'  
10953 ='Medco Health Services ' 
10954 ='Medco Containment Life Insurance Company'  
11065 ='Dental Service of Massachusetts, Inc. (Denta Quest)'  
11215 ='Connecticut General Life Insurance Company - FAC'  
11216 ='Great-West Life & Annuity Insurance Company - FAC'  
11237 ='First American Administrators, Inc.'  
11347 ='Horizon Blue Cross and Blue Shield of NJ'  
11371 ='Express Scripts Inc.'  
11377 ='New England Dental Administrators'  
11426 ='United Concordia Companies, Inc. ' 
11446 ='Davis Vision, Inc.'  
11474 ='CIGNA Health and Life Insurance Company (CHLIC)'  
11499 ='CIGNA HealthCare - Voluntary Division'  
11541 ='Health Safety Net (DHCFP)'  
11609 ='QCC Insurance Company'  
11611 ='Blue Cross Blue Shield of Tennessee'  
11701 ='Blue Cross Blue Shield of Massachusetts SI'  
11726 ='Cigna Health and Life Ins. Co. (EAST)'  
11869 ='United Concordia Companies, Inc. - Sun Life of Canada'  
11939 ='Key Benefit Administrators, Inc. - KBA ';
run; 

 

proc format;
value  $ DisabilityIndicatorFlag_
1='Yes'
2='No'
3='Unknown'
4='Other'
5='Not Applicable'
;
run;


proc format;
value $ ProcedureCodeType_
1='CPT or HCPCS Level 1 Code'
2='HCPCS Level II Code'
3='HCPCS Level III Code (State Medicare code)'
4='American Dental Association (ADA) Procedure Code (Also referred to as CDT code.)'
5='State defined Procedure Code'
6='CPT Category II'
;
run;


proc format;
value $ SiteOfServiceOnNSFCMS1500ClaimsC_
01='Pharmacy'

03='School'
04='Homeless Shelter'
05='Indian Health Service Free-standing Facility'
06='Indian Health Service Provider-based Facility'
07='Tribal 638 Free-standing Facility'
08='Tribal 638 Provider-based Facility'
09='Prison/Correctional Facility'

11='Office'
12='Home'
13='Assigned Living Facility'
14='Group Home'
15='Mobile Unit'
16='Temporary Lodging'
17='Walk-in Retail Health Clinic'
18='Place of Employment-Worksite'

20='Urgent Care Facility'
21='Inpatient Hospital'
22='Outpatient Hospital'
23='Emergency Room-Hospital'
24='Ambulatory Surgical Center'
25='Birthing Center'
26='Military Treatment Facility'

31='Skilled Nursing Facility'
32='Nursing Facility'
33='Custodial Care Facility'
34='Hospice'

41='Ambulance-Land'
42='Ambulance-Air or Water'

49='Independent Clinic'
50='Federally Qualified Health Center'
51='Inpatient Psychiatric Facility'
52='Psychiatric Facility-Partial Hospitalization'
53='Community Mental Health Center'
54='Intermediate Care Facility/Mentally Retarded'
55='Residential Substance Abuse Treatment Facility'
56='Psychiatric Residential Treatment Center'
57='Non-residential Substance Abuse Treatment Facility'

60='Mass Immunization Center'
61='Comprehensive Inpatient Rehabilitation Facility'
62='Comprehensive Outpatient Rehabilitaiton Facility'

65='End-Stage Renal Disease Treatment Facility'

71='Public Health Clinic'
72='Rural Health Clinic'

81='Independent Laboratory'

 ;
 run;
