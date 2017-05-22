********************************
Mental Health Diagnosis/Alcohol or substantce abuse diagnosis for MA APCD Patients
Xiner Zhou
8/25/2015
********************************;
libname APCD 'C:\data\Data\APCD\Massachusetts\Data';

/*
"7812" Abnormality of gait
"7832" Limb length proc-humerus (Limb lengthening procedures, humerus)
"7837" Failure to thrive-adult (Adult failure to thrive)
"7994" Cachexia
"7993" Debility
"7197" Difficulty in walking
"V1588" Personal history of fall
"7807" Bone graft-tibia/fibula
"7282" Muscular wasting and disuse atrophy
"72887" Muscle weakness-general
"7070","7072" Pressure ulcer
"797" Senility without mention of psychosis
("E0100","E0105","E0130","E0135","E0140","E0141","E0143","E0144","E0147","E0148",
                   "E0149","E0160","E0161","E0162","E0163","E0164","E0165","E0166","E0167","E0168",
                   "E0169","E0170","E0171")
("T1000","T1001","T1002","T1003","T1004","T1005","T1019","T1020","T1021","T1022",
                   "T1030","T1031")
*/
proc sql;
create table temp1 as
select MemberLinkEID, 
PayerClaimControlNumber,

AdmittingDiagnosisCleaned as AdmissionDx, DischargeDiagnosisCleaned as DischargeDx, 
PrincipalDiagnosisCleaned as PrincipalDx, 
OtherDiagnosis1Cleaned as SecondaryDx1, OtherDiagnosis2Cleaned as SecondaryDx2, OtherDiagnosis3Cleaned as SecondaryDx3, 
OtherDiagnosis4Cleaned as SecondaryDx4, OtherDiagnosis5Cleaned as SecondaryDx5, OtherDiagnosis6Cleaned as SecondaryDx6, 
OtherDiagnosis7Cleaned as SecondaryDx7, OtherDiagnosis8Cleaned as SecondaryDx8, OtherDiagnosis9Cleaned as SecondaryDx9, 
OtherDiagnosis10Cleaned as SecondaryDx10, OtherDiagnosis11Cleaned as SecondaryDx11, OtherDiagnosis12Cleaned as SecondaryDx12 
 
from APCD.Medical_MA_New  
where memberlinkeid ne . ;
quit;
