
proc format;  
value st
1='AL'
2='AK'
3='AZ'
4='AR'
5='CA'
6='CO'
7='CT'
8='DE'
9='DC'
10='FL'
11='GA'
12='HI'
13='ID'
14='IL'
15='IN'
16='IA'
17='KS'
18='KY'
19='LA'
20='ME'
21='MD'
22='MA'
23='MI'
24='MN'
25='MS'
26='MO'
27='MT'
28='NE'
29='NV'
30='NH'
31='NJ'
32='NM'
33='NY'
34='NC'
35='ND'
36='OH'
37='OK'
38='OR'
39='PA'
40='xx'
41='RI'
42='SC'
43='SD'
44='TN'
45='TX'
46='UT'
47='VT'
48='xx'
49='VA'
50='WA'
51='WV'
52='WI'
53='WY'
54='xx'
55='xx'
56='xx'
57='xx'
58='xx'
59='xx'
60='xx'
61='xx'
62='xx'
63='xx'
64='xx'
65='xx'
66='xx'
68='xx'
75='xx'
0 ='xx'
. ='xx'
71='xx'
73='xx'
77='xx'
78='xx'
79='xx'
85='xx'
88='xx'
90='xx'
92='xx'
94='xx'
95='xx'
96='xx'
97='xx'
98='xx'
99='xx'
; 
run; 
proc format;  
value $SRC_ADMS_
0="ANOMALY: invalid value, if present, translate to '9'"
1="Non-Health Care Facility Point of Origin (Physician Referral) - The patient was admitted to this facility upon an order of a physician."
2="Clinic referral - The patient was admitted upon the recommendation of this facility's clinic physician."
3="HMO referral - Reserved for national Prior to 3/08, HMO referral - The patient was admitted upon the recommendation of an health maintenance organization (HMO) physician."
4="Transfer from hospital (Different Facility) - The patient was admitted to this facility as a hospital transfer from an acute care facility where he or she was an inpatient."
5="Transfer from a skilled nursing facility (SNF) or Intermediate Care Facility (ICF) - The patient was admitted to this facility as a transfer from a SNF or ICF where he or she was a resident."
6="Transfer from another health care facility - The patient was admitted to this facility as a transfer from another type of health care facility not defined elsewhere in this code list where he or she was an inpatient."
7="Emergency room - The patient was admitted to this facility after receiving services in this facility's emergency room department."
8="Court/law enforcement - The patient was admitted upon the direction of a court of law or upon the request of a law enforcement agency's representative."
9="Information not available - The means by which the patient was admitted is not known."
A="Reserved for National Assignment."
B="Transfer from Another Home Health Agency - The patient was admitted to this home health agency as a transfer from another home health agency.(Discontinued July 1,2010- See Condition Code 47)"
C="Readmission to Same Home Health Agency - The patient was readmitted to this home health agency within the same home health episode period. (Discontinued July 1,2010)"
D="Transfer from hospital inpatient in the same facility resulting in a separate claim to the payer - The patient was admitted to this facility as a transfer from hospital inpatient within this facility resulting in a separate claim to the payer."
E="Transfer from Ambulatory Surgical Center"
F="Transfer from hospice and is under a hospice plan of care or enrolled in hospice program"
;
run;
proc format;
value $TYPE_ADM_
0="Blank"
1="Emergency - The patient required immediate medical intervention as a result of severe, life threatening, or potentially disabling conditions. Generally, the patient was admitted through the emergency room."
2="Urgent - The patient required immediate attention for the care and treatment of a physical or mental disorder. Generally, the patient was admitted to the first available and suitable accommodation."
3="Elective - The patient's condition permitted adequate time to schedule the availability of suitable accommodations."
4="Newborn - Necessitates the use of special source of admission codes."
5="Trauma Center - visits to a trauma center/hospital as licensed or designated by the State or local government authority authorized to do so, or as verified by the American College of Surgeons and involving a trauma activation."
6="Reserved"
7="Reserved"
8="Reserved"
9="Unknown - Information not available."
;
run;
proc format;
value $stus_cd_
0="Unknown Value"
01="Discharged to home/self care (routine charge)."
02="Discharged/transferred to other short term general hospital for inpatient care."
03="Discharged/transferred to skilled nursing facility (SNF) with Medicare certification in anticipation of covered skilled care"
04="Discharged/transferred to intermediate care facility (ICF)."
05="Discharged/transferred to another type of institution for inpatient care (including distinct parts)."
06="Discharged/transferred to home care of organized home health service organization."
07="Left against medical advice or discontinued care."
08="Discharged/transferred to home under care of a home IV drug therapy provider."
09="Admitted as an inpatient to this hospital (effective 3/1/91). In situations where a patient is admitted before midnight of the third day following the day of an outpatient service, the outpatient services are considered inpatient."
20="Expired (did not recover - Christian Science patient)."
21="Discharged/transferred to Court/Law Enforcement"
30="Still patient"
40="Expired at home (hospice claims only)"
41="Expired in a medical facility such as hospital, SNF, ICF, or freestanding hospice. (Hospice claims only)"
42="Expired - place unknown (Hospice claims only)"
43="Discharged/transferred to a federal hospital"
50="Hospice - home "
51="Hospice - medical facility "
61="Discharged/transferred within this institution to a hospital-based Medicare approved swing bed"
62="Discharged/transferred to an inpatient rehabilitation facility including distinct parts units of a hospital."
63="Discharged/transferred to a long term care hospitals."
64="Discharged/transferred to a nursing facility certified under Medicaid but not under Medicare"
65="Discharged/Transferred to a psychiatric hospital or psychiatric distinct unit of a hospital"
66="Discharged/transferred to a Critical Access Hospital (CAH)"
69="Discharged/transferred to a designated disaster alternative care site"
70="Discharged/transferred to another type of health care institution not defined elsewhere in code list."
71="Discharged/transferred/referred to another institution for outpatient services as specified by the discharge plan of care "
72="Discharged/transferred/referred to this institution for outpatient services as specified by the discharge plan of care"
81="Discharged to home or self-care with a planned acute care hospital readmission"
82="Discharged/transferred to a short term general hospital for inpatient care with a planned acute care hospital inpatient readmission"
83="Discharged/transferred to a skilled nursing facility (SNF) with Medicare certification with a planned acute care hospital inpatient readmission"
84="Discharged/transferred to a facility that provides custodial or supportive care with a planned acute care hospital inpatient readmission"
85="Discharged/transferred to a designated cancer center or childrenÅfs hospital with a planned acute care hospital inpatient readmission"
86="Discharged/transferred to home under care of organized home health service organization with a planned acute care hospital inpatient readmission"
87="Discharged/transferred to court/law enforcement with a planned acute care hospital inpatient readmission"
88="Discharged/transferred to a federal health care facility with a planned acute care hospital inpatient readmission"
89="Discharged/transferred to a hospital-based Medicare approved swing bed with a planned acute care hospital inpatient readmission"
90="Discharged/transferred to an inpatient rehabilitation facility (IRF) including rehabilitation distinct part units of a hospital with a planned acute care hospital inpatient readmission"
91="Discharged/transferred to a Medicare certified long term care hospital (LTCH) with a planned acute care hospital inpatient readmission"
92="Discharged/transferred to nursing facility certified under Medicaid but not certified under Medicare with a planned acute care hospital inpatient readmission"
93="Discharged/transferred to a psychiatric hospital/distinct part unit of a hospital with a planned acute care hospital inpatient readmission"
94="Discharged/transferred to a critical access hospital (CAH) with a planned acute care hospital inpatient readmission"
95="Discharged/transferred to another type of health care institution not defined elsewhere in this code list with a planned acute care hospital inpatient readmission"
;
run;
