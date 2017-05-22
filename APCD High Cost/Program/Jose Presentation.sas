*******************************
APCD Presentation
Xiner Zhou
10/2/2016
******************************;
libname APCD 'D:\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';
 
 
proc sql;
create table claims2012 as
select MemberLinkEID, MemberDateofBirth as DOB, Standardized_MemberZIPCode as MemberZIP, Standardized_MemberZIPFirst3 as MemberZIP3,
MemberGenderCleaned as gender, Standardized_MemberStateorProvin as MemberState, Standardized_MemberCounty as MemberCounty, 

NationalServiceProviderIDCleaned as ServiceProviderNPI,ServiceProviderSpecialty, 
Standardized_ServiceProviderStat as ServiceProviderState, Standardized_ServiceProviderCoun as ServiceProviderCounty,Standardized_ServiceProviderCity as ServiceProviderCity,
Standardized_ServiceProviderZIPC as ServiceProviderZIP,
ServiceProviderNumber_Linkage_ID as ServiceProviderLink, ServiceProviderTaxIDNumber as ServiceProviderTaxID, PCPIndicator,

OrgID, MedicaidIndicator, ProductIDNumber_Linkage_ID as ProductLink,

TypeOfClaimCleaned as TypeOfClaim, TypeofBillOnFacilityClaims as TypeofBill, SiteofServiceOnNSFCMS1500ClaimsC as PlaceofService,
PayerClaimControlNumber,LineCounter,VersionNumber, VersionIndicator,VersionIndicator_1,HighestVersionDenied, ClaimStatus, ClaimLineType,

AdmissionDate,DischargeDate, DateofServiceFrom, DateofServiceTo, CoveredDays, NonCoveredDays, 
AdmissionType, AdmissionSource, DischargeStatus, 
RevenueCodeCleaned as RevenueCode,

ProcedureCodeCleaned as HCPCS, ProcedureCodeType, Quantity, ProcedureModifier1 as Modifier1, ProcedureModifier2 as Modifier2, ProcedureModifier3 as Modifier3,ProcedureModifier4 as Modifier4,
ICD9CMProcedureCodeCleaned as ICD9Procedure,OtherICD9CMProcedureCode1Cleaned as OtherICD9Procedure1, OtherICD9CMProcedureCode2Cleaned as OtherICD9Procedure2, 
OtherICD9CMProcedureCode3Cleaned as OtherICD9Procedure3, OtherICD9CMProcedureCode4Cleaned as OtherICD9Procedure4, 
OtherICD9CMProcedureCode5Cleaned as OtherICD9Procedure5, OtherICD9CMProcedureCode6Cleaned as OtherICD9Procedure6, 

DRG, DRGVersion,DRGLevel, APC, APCVersion, 
DiagnosticPointer,AdmittingDiagnosisCleaned as AdmissionDx, DischargeDiagnosisCleaned as DischargeDx, ECodeCleaned as ECode, 
PrincipalDiagnosisCleaned as PrincipalDx, 
OtherDiagnosis1Cleaned as SecondaryDx1, OtherDiagnosis2Cleaned as SecondaryDx2, OtherDiagnosis3Cleaned as SecondaryDx3, 
OtherDiagnosis4Cleaned as SecondaryDx4, OtherDiagnosis5Cleaned as SecondaryDx5, OtherDiagnosis6Cleaned as SecondaryDx6, 
OtherDiagnosis7Cleaned as SecondaryDx7, OtherDiagnosis8Cleaned as SecondaryDx8, OtherDiagnosis9Cleaned as SecondaryDx9, 
OtherDiagnosis10Cleaned as SecondaryDx10, OtherDiagnosis11Cleaned as SecondaryDx11, OtherDiagnosis12Cleaned as SecondaryDx12, 

PaymentArrangementTypeCleaned as PaymentType, CapitatedEncounterFlag as Capitation, GlobalPaymentFlag, DeniedFlag, 
CoordinationOfBenefitsTPLLiabili as CoordinationOfBenefits, 
InNetworkIndicator,ServiceClass,

ChargeAmountCleaned as Charge, AllowedAmountCleaned as Allowed, NonCoveredAmountCleaned as NonCovered, ExcludedExpensesCleaned as ExcludedExpenses,WithholdAmount,AuthorizationNeeded,
PaidAmountCleaned as Paid, OtherInsurancePaidAmountCleaned as OtherPaid, MedicarePaidAmountCleaned as MedicarePaid, 
PrepaidAmountCleaned as Prepaid, CopayAmountCleaned as Copay, CoinsuranceAmount as Coinsurance, DeductibleAmount as Deductible,

SubmissionMonth, SubmissionYear, 

BillingProviderNumber_Linkage_ID as BillProviderLink, NationalBillingProviderIDCleaned as BillNPI, BillingProviderLastNameOrOrganiz as BillName, 
ReferringProviderID_Linkage_ID as ReferProviderLink, ReferralIndicator,
AttendingProvider_Linkage_ID as AttendProviderLink
from APCD.Medical 
where year(datepart(DateOfServiceTo))=2012 and MemberLinkEID ne .;
quit;

proc sort data=claims2012;
by PayerClaimControlNumber LineCounter descending VersionNumber;
run;
proc sort data=claims2012 nodupkey;
by PayerClaimControlNumber LineCounter ;
run;

* Hospital admissions for -Stroke -type 1 or 2 diabetes -congestive heart failure -AMI -pneumonia -copd;
** source: https://www.cms.gov/Medicare/Quality-Initiatives-Patient-Assessment-Instruments/HospitalQualityInits/Downloads/HIQR-ICD9-to-ICD10-Tables.pdf

*admissions for mental-health related conditions 
 
* of admissions for traffic related injury;
* admissions/ED visits for violence-related injury;


proc sql;
create table temp as
select *,

case when TypeOfClaim='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('43301','43310','43311','43321','43331','43381','43391','43400','43401','43411','43491','436','430','431' ) or DischargeDx in ('43301','43310','43311','43321','43331','43381','43391','43400','43401','43411','43491','436','430','431' ) 
or SecondaryDx1 in ('43301','43310','43311','43321','43331','43381','43391','43400','43401','43411','43491','436','430','431' ) or SecondaryDx2 in ('43301','43310','43311','43321','43331','43381','43391','43400','43401','43411','43491','436','430','431' ) 
or SecondaryDx3 in ('43301','43310','43311','43321','43331','43381','43391','43400','43401','43411','43491','436','430','431' ) or SecondaryDx4 in ('43301','43310','43311','43321','43331','43381','43391','43400','43401','43411','43491','436','430','431' ) 
or SecondaryDx5 in ('43301','43310','43311','43321','43331','43381','43391','43400','43401','43411','43491','436','430','431' ) or SecondaryDx6 in ('43301','43310','43311','43321','43331','43381','43391','43400','43401','43411','43491','436','430','431' ) 
or SecondaryDx7 in ('43301','43310','43311','43321','43331','43381','43391','43400','43401','43411','43491','436','430','431' ) or SecondaryDx8 in ('43301','43310','43311','43321','43331','43381','43391','43400','43401','43411','43491','436','430','431' ) 
or SecondaryDx9 in ('43301','43310','43311','43321','43331','43381','43391','43400','43401','43411','43491','436','430','431' ) or SecondaryDx10 in ('43301','43310','43311','43321','43331','43381','43391','43400','43401','43411','43491','436','430','431' ) 
or SecondaryDx11 in ('43301','43310','43311','43321','43331','43381','43391','43400','43401','43411','43491','436','430','431' ) or SecondaryDx12 in ('43301','43310','43311','43321','43331','43381','43391','43400','43401','43411','43491','436','430','431' ) 

) then 1 else 0 end as Sroke label="hospital admissions: Stroke",

case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('25000','25001','25002','25003','25010','25011','25012','25013','25020','25021','25022','25023','25030','25031','25032','25033','25040','25041','25042','25043','25050','25051','25052','25053','25060','25061','25062','25063','25070','25071','25072','25073','25080','25081','25082','25083','25090','25091','25092','25093','3572','36201','36641','64800','64801','64802','64803','64804' ) or DischargeDx in ('25000','25001','25002','25003','25010','25011','25012','25013','25020','25021','25022','25023','25030','25031','25032','25033','25040','25041','25042','25043','25050','25051','25052','25053','25060','25061','25062','25063','25070','25071','25072','25073','25080','25081','25082','25083','25090','25091','25092','25093','3572','36201','36641','64800','64801','64802','64803','64804' ) 
or SecondaryDx1 in ('25000','25001','25002','25003','25010','25011','25012','25013','25020','25021','25022','25023','25030','25031','25032','25033','25040','25041','25042','25043','25050','25051','25052','25053','25060','25061','25062','25063','25070','25071','25072','25073','25080','25081','25082','25083','25090','25091','25092','25093','3572','36201','36641','64800','64801','64802','64803','64804' ) or SecondaryDx2 in ('25000','25001','25002','25003','25010','25011','25012','25013','25020','25021','25022','25023','25030','25031','25032','25033','25040','25041','25042','25043','25050','25051','25052','25053','25060','25061','25062','25063','25070','25071','25072','25073','25080','25081','25082','25083','25090','25091','25092','25093','3572','36201','36641','64800','64801','64802','64803','64804' ) 
or SecondaryDx3 in ('25000','25001','25002','25003','25010','25011','25012','25013','25020','25021','25022','25023','25030','25031','25032','25033','25040','25041','25042','25043','25050','25051','25052','25053','25060','25061','25062','25063','25070','25071','25072','25073','25080','25081','25082','25083','25090','25091','25092','25093','3572','36201','36641','64800','64801','64802','64803','64804' ) or SecondaryDx4 in ('25000','25001','25002','25003','25010','25011','25012','25013','25020','25021','25022','25023','25030','25031','25032','25033','25040','25041','25042','25043','25050','25051','25052','25053','25060','25061','25062','25063','25070','25071','25072','25073','25080','25081','25082','25083','25090','25091','25092','25093','3572','36201','36641','64800','64801','64802','64803','64804' ) 
or SecondaryDx5 in ('25000','25001','25002','25003','25010','25011','25012','25013','25020','25021','25022','25023','25030','25031','25032','25033','25040','25041','25042','25043','25050','25051','25052','25053','25060','25061','25062','25063','25070','25071','25072','25073','25080','25081','25082','25083','25090','25091','25092','25093','3572','36201','36641','64800','64801','64802','64803','64804' ) or SecondaryDx6 in ('25000','25001','25002','25003','25010','25011','25012','25013','25020','25021','25022','25023','25030','25031','25032','25033','25040','25041','25042','25043','25050','25051','25052','25053','25060','25061','25062','25063','25070','25071','25072','25073','25080','25081','25082','25083','25090','25091','25092','25093','3572','36201','36641','64800','64801','64802','64803','64804' ) 
or SecondaryDx7 in ('25000','25001','25002','25003','25010','25011','25012','25013','25020','25021','25022','25023','25030','25031','25032','25033','25040','25041','25042','25043','25050','25051','25052','25053','25060','25061','25062','25063','25070','25071','25072','25073','25080','25081','25082','25083','25090','25091','25092','25093','3572','36201','36641','64800','64801','64802','64803','64804' ) or SecondaryDx8 in ('25000','25001','25002','25003','25010','25011','25012','25013','25020','25021','25022','25023','25030','25031','25032','25033','25040','25041','25042','25043','25050','25051','25052','25053','25060','25061','25062','25063','25070','25071','25072','25073','25080','25081','25082','25083','25090','25091','25092','25093','3572','36201','36641','64800','64801','64802','64803','64804' ) 
or SecondaryDx9 in ('25000','25001','25002','25003','25010','25011','25012','25013','25020','25021','25022','25023','25030','25031','25032','25033','25040','25041','25042','25043','25050','25051','25052','25053','25060','25061','25062','25063','25070','25071','25072','25073','25080','25081','25082','25083','25090','25091','25092','25093','3572','36201','36641','64800','64801','64802','64803','64804' ) or SecondaryDx10 in ('25000','25001','25002','25003','25010','25011','25012','25013','25020','25021','25022','25023','25030','25031','25032','25033','25040','25041','25042','25043','25050','25051','25052','25053','25060','25061','25062','25063','25070','25071','25072','25073','25080','25081','25082','25083','25090','25091','25092','25093','3572','36201','36641','64800','64801','64802','64803','64804' ) 
or SecondaryDx11 in ('25000','25001','25002','25003','25010','25011','25012','25013','25020','25021','25022','25023','25030','25031','25032','25033','25040','25041','25042','25043','25050','25051','25052','25053','25060','25061','25062','25063','25070','25071','25072','25073','25080','25081','25082','25083','25090','25091','25092','25093','3572','36201','36641','64800','64801','64802','64803','64804' ) or SecondaryDx12 in ('25000','25001','25002','25003','25010','25011','25012','25013','25020','25021','25022','25023','25030','25031','25032','25033','25040','25041','25042','25043','25050','25051','25052','25053','25060','25061','25062','25063','25070','25071','25072','25073','25080','25081','25082','25083','25090','25091','25092','25093','3572','36201','36641','64800','64801','64802','64803','64804' ) 

) then 1 else 0 end as Diabetes label="hospital admissions: Type 1 or 2 Diabetes",
  
case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('40201','40211','40291','40401','40403','40411','40413','40491','40493','4280','4281','42820','42821','42822','42823','42830','42831','42832','42833','42840','42841','42842','42843','4289') or DischargeDx in ('40201','40211','40291','40401','40403','40411','40413','40491','40493','4280','4281','42820','42821','42822','42823','42830','42831','42832','42833','42840','42841','42842','42843','4289') 
or SecondaryDx1 in ('40201','40211','40291','40401','40403','40411','40413','40491','40493','4280','4281','42820','42821','42822','42823','42830','42831','42832','42833','42840','42841','42842','42843','4289') or SecondaryDx2 in ('40201','40211','40291','40401','40403','40411','40413','40491','40493','4280','4281','42820','42821','42822','42823','42830','42831','42832','42833','42840','42841','42842','42843','4289') 
or SecondaryDx3 in ('40201','40211','40291','40401','40403','40411','40413','40491','40493','4280','4281','42820','42821','42822','42823','42830','42831','42832','42833','42840','42841','42842','42843','4289') or SecondaryDx4 in ('40201','40211','40291','40401','40403','40411','40413','40491','40493','4280','4281','42820','42821','42822','42823','42830','42831','42832','42833','42840','42841','42842','42843','4289') 
or SecondaryDx5 in ('40201','40211','40291','40401','40403','40411','40413','40491','40493','4280','4281','42820','42821','42822','42823','42830','42831','42832','42833','42840','42841','42842','42843','4289') or SecondaryDx6 in ('40201','40211','40291','40401','40403','40411','40413','40491','40493','4280','4281','42820','42821','42822','42823','42830','42831','42832','42833','42840','42841','42842','42843','4289') 
or SecondaryDx7 in ('40201','40211','40291','40401','40403','40411','40413','40491','40493','4280','4281','42820','42821','42822','42823','42830','42831','42832','42833','42840','42841','42842','42843','4289') or SecondaryDx8 in ('40201','40211','40291','40401','40403','40411','40413','40491','40493','4280','4281','42820','42821','42822','42823','42830','42831','42832','42833','42840','42841','42842','42843','4289') 
or SecondaryDx9 in ('40201','40211','40291','40401','40403','40411','40413','40491','40493','4280','4281','42820','42821','42822','42823','42830','42831','42832','42833','42840','42841','42842','42843','4289') or SecondaryDx10 in ('40201','40211','40291','40401','40403','40411','40413','40491','40493','4280','4281','42820','42821','42822','42823','42830','42831','42832','42833','42840','42841','42842','42843','4289') 
or SecondaryDx11 in ('40201','40211','40291','40401','40403','40411','40413','40491','40493','4280','4281','42820','42821','42822','42823','42830','42831','42832','42833','42840','42841','42842','42843','4289') or SecondaryDx12 in ('40201','40211','40291','40401','40403','40411','40413','40491','40493','4280','4281','42820','42821','42822','42823','42830','42831','42832','42833','42840','42841','42842','42843','4289') 

) then 1 else 0 end as HF label="hospital admissions: Heart Failure",
 
case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('41000','41001','41010','41011','41020','41021','41030','41031','41040','41041','41050','41051','41060','41061', '41070','41071','41080','41081','41090','41091') or DischargeDx in ('41000','41001','41010','41011','41020','41021','41030','41031','41040','41041','41050','41051','41060','41061', '41070','41071','41080','41081','41090','41091') 
or SecondaryDx1 in ('41000','41001','41010','41011','41020','41021','41030','41031','41040','41041','41050','41051','41060','41061', '41070','41071','41080','41081','41090','41091') or SecondaryDx2 in ('41000','41001','41010','41011','41020','41021','41030','41031','41040','41041','41050','41051','41060','41061', '41070','41071','41080','41081','41090','41091') 
or SecondaryDx3 in ('41000','41001','41010','41011','41020','41021','41030','41031','41040','41041','41050','41051','41060','41061', '41070','41071','41080','41081','41090','41091') or SecondaryDx4 in ('41000','41001','41010','41011','41020','41021','41030','41031','41040','41041','41050','41051','41060','41061', '41070','41071','41080','41081','41090','41091') 
or SecondaryDx5 in ('41000','41001','41010','41011','41020','41021','41030','41031','41040','41041','41050','41051','41060','41061', '41070','41071','41080','41081','41090','41091') or SecondaryDx6 in ('41000','41001','41010','41011','41020','41021','41030','41031','41040','41041','41050','41051','41060','41061', '41070','41071','41080','41081','41090','41091') 
or SecondaryDx7 in ('41000','41001','41010','41011','41020','41021','41030','41031','41040','41041','41050','41051','41060','41061', '41070','41071','41080','41081','41090','41091') or SecondaryDx8 in ('41000','41001','41010','41011','41020','41021','41030','41031','41040','41041','41050','41051','41060','41061', '41070','41071','41080','41081','41090','41091') 
or SecondaryDx9 in ('41000','41001','41010','41011','41020','41021','41030','41031','41040','41041','41050','41051','41060','41061', '41070','41071','41080','41081','41090','41091') or SecondaryDx10 in ('41000','41001','41010','41011','41020','41021','41030','41031','41040','41041','41050','41051','41060','41061', '41070','41071','41080','41081','41090','41091') 
or SecondaryDx11 in ('41000','41001','41010','41011','41020','41021','41030','41031','41040','41041','41050','41051','41060','41061', '41070','41071','41080','41081','41090','41091') or SecondaryDx12 in ('41000','41001','41010','41011','41020','41021','41030','41031','41040','41041','41050','41051','41060','41061', '41070','41071','41080','41081','41090','41091') 

) then 1 else 0 end as AMI label="hospital admissions: AMI",
 

case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('481','4820','4821','4822','48230','48231','48232','48239','48240','48241','48242','48249','48282','48283','48284','48289','4829','4830','4831','4838','485','486' ) or DischargeDx in ('481','4820','4821','4822','48230','48231','48232','48239','48240','48241','48242','48249','48282','48283','48284','48289','4829','4830','4831','4838','485','486' ) 
or SecondaryDx1 in ('481','4820','4821','4822','48230','48231','48232','48239','48240','48241','48242','48249','48282','48283','48284','48289','4829','4830','4831','4838','485','486' ) or SecondaryDx2 in ('481','4820','4821','4822','48230','48231','48232','48239','48240','48241','48242','48249','48282','48283','48284','48289','4829','4830','4831','4838','485','486' ) 
or SecondaryDx3 in ('481','4820','4821','4822','48230','48231','48232','48239','48240','48241','48242','48249','48282','48283','48284','48289','4829','4830','4831','4838','485','486' ) or SecondaryDx4 in ('481','4820','4821','4822','48230','48231','48232','48239','48240','48241','48242','48249','48282','48283','48284','48289','4829','4830','4831','4838','485','486' ) 
or SecondaryDx5 in ('481','4820','4821','4822','48230','48231','48232','48239','48240','48241','48242','48249','48282','48283','48284','48289','4829','4830','4831','4838','485','486' ) or SecondaryDx6 in ('481','4820','4821','4822','48230','48231','48232','48239','48240','48241','48242','48249','48282','48283','48284','48289','4829','4830','4831','4838','485','486' ) 
or SecondaryDx7 in ('481','4820','4821','4822','48230','48231','48232','48239','48240','48241','48242','48249','48282','48283','48284','48289','4829','4830','4831','4838','485','486' ) or SecondaryDx8 in ('481','4820','4821','4822','48230','48231','48232','48239','48240','48241','48242','48249','48282','48283','48284','48289','4829','4830','4831','4838','485','486' ) 
or SecondaryDx9 in ('481','4820','4821','4822','48230','48231','48232','48239','48240','48241','48242','48249','48282','48283','48284','48289','4829','4830','4831','4838','485','486' ) or SecondaryDx10 in ('481','4820','4821','4822','48230','48231','48232','48239','48240','48241','48242','48249','48282','48283','48284','48289','4829','4830','4831','4838','485','486' ) 
or SecondaryDx11 in ('481','4820','4821','4822','48230','48231','48232','48239','48240','48241','48242','48249','48282','48283','48284','48289','4829','4830','4831','4838','485','486' ) or SecondaryDx12 in ('481','4820','4821','4822','48230','48231','48232','48239','48240','48241','48242','48249','48282','48283','48284','48289','4829','4830','4831','4838','485','486' ) 

) then 1 else 0 end as PN label="hospital admissions: Pneumonia",
 

case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('4910','4911','49120','49121','49122','4918','4919','4920','4928','496' ) or DischargeDx in ('4910','4911','49120','49121','49122','4918','4919','4920','4928','496' ) 
or SecondaryDx1 in ('4910','4911','49120','49121','49122','4918','4919','4920','4928','496' ) or SecondaryDx2 in ('4910','4911','49120','49121','49122','4918','4919','4920','4928','496' ) 
or SecondaryDx3 in ('4910','4911','49120','49121','49122','4918','4919','4920','4928','496' ) or SecondaryDx4 in ('4910','4911','49120','49121','49122','4918','4919','4920','4928','496' ) 
or SecondaryDx5 in ('4910','4911','49120','49121','49122','4918','4919','4920','4928','496' ) or SecondaryDx6 in ('4910','4911','49120','49121','49122','4918','4919','4920','4928','496' ) 
or SecondaryDx7 in ('4910','4911','49120','49121','49122','4918','4919','4920','4928','496' ) or SecondaryDx8 in ('4910','4911','49120','49121','49122','4918','4919','4920','4928','496' ) 
or SecondaryDx9 in ('4910','4911','49120','49121','49122','4918','4919','4920','4928','496' ) or SecondaryDx10 in ('4910','4911','49120','49121','49122','4918','4919','4920','4928','496' ) 
or SecondaryDx11 in ('4910','4911','49120','49121','49122','4918','4919','4920','4928','496' ) or SecondaryDx12 in ('4910','4911','49120','49121','49122','4918','4919','4920','4928','496' ) 

) then 1 else 0 end as COPD label="hospital admissions: Chronic Obstructive Pulmonary Disease ",
 
 
case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('E810','E811','E812','E813','E814','E815','E816','E817','E818','E819','E820','E821','E822','E823','E824','E825','E826','E827','E828','E829' ) or DischargeDx in ('E810','E811','E812','E813','E814','E815','E816','E817','E818','E819','E820','E821','E822','E823','E824','E825','E826','E827','E828','E829' ) 
or SecondaryDx1 in ('E810','E811','E812','E813','E814','E815','E816','E817','E818','E819','E820','E821','E822','E823','E824','E825','E826','E827','E828','E829' ) or SecondaryDx2 in ('E810','E811','E812','E813','E814','E815','E816','E817','E818','E819','E820','E821','E822','E823','E824','E825','E826','E827','E828','E829' ) 
or SecondaryDx3 in ('E810','E811','E812','E813','E814','E815','E816','E817','E818','E819','E820','E821','E822','E823','E824','E825','E826','E827','E828','E829' ) or SecondaryDx4 in ('E810','E811','E812','E813','E814','E815','E816','E817','E818','E819','E820','E821','E822','E823','E824','E825','E826','E827','E828','E829' ) 
or SecondaryDx5 in ('E810','E811','E812','E813','E814','E815','E816','E817','E818','E819','E820','E821','E822','E823','E824','E825','E826','E827','E828','E829' ) or SecondaryDx6 in ('E810','E811','E812','E813','E814','E815','E816','E817','E818','E819','E820','E821','E822','E823','E824','E825','E826','E827','E828','E829' ) 
or SecondaryDx7 in ('E810','E811','E812','E813','E814','E815','E816','E817','E818','E819','E820','E821','E822','E823','E824','E825','E826','E827','E828','E829' ) or SecondaryDx8 in ('E810','E811','E812','E813','E814','E815','E816','E817','E818','E819','E820','E821','E822','E823','E824','E825','E826','E827','E828','E829' ) 
or SecondaryDx9 in ('E810','E811','E812','E813','E814','E815','E816','E817','E818','E819','E820','E821','E822','E823','E824','E825','E826','E827','E828','E829' ) or SecondaryDx10 in ('E810','E811','E812','E813','E814','E815','E816','E817','E818','E819','E820','E821','E822','E823','E824','E825','E826','E827','E828','E829' ) 
or SecondaryDx11 in ('E810','E811','E812','E813','E814','E815','E816','E817','E818','E819','E820','E821','E822','E823','E824','E825','E826','E827','E828','E829' ) or SecondaryDx12 in ('E810','E811','E812','E813','E814','E815','E816','E817','E818','E819','E820','E821','E822','E823','E824','E825','E826','E827','E828','E829' ) 
) then 1 else 0 end as traffic label="Admissions for Traffic Related Injury ",
 


case when ((TypeOfClaim ='002' and TypeofBill in ('11','41')) or PlaceOfService in ('23') )
and (
AdmissionDx in ('99580','99581','E960','E961','E962','E963','E964','E965','E966','E967','E968','E969' ) or DischargeDx in ('99580','99581','E960','E961','E962','E963','E964','E965','E966','E967','E968','E969' ) 
or SecondaryDx1 in ('99580','99581','E960','E961','E962','E963','E964','E965','E966','E967','E968','E969' ) or SecondaryDx2 in ('99580','99581','E960','E961','E962','E963','E964','E965','E966','E967','E968','E969' ) 
or SecondaryDx3 in ('99580','99581','E960','E961','E962','E963','E964','E965','E966','E967','E968','E969' ) or SecondaryDx4 in ('99580','99581','E960','E961','E962','E963','E964','E965','E966','E967','E968','E969' ) 
or SecondaryDx5 in ('99580','99581','E960','E961','E962','E963','E964','E965','E966','E967','E968','E969' ) or SecondaryDx6 in ('99580','99581','E960','E961','E962','E963','E964','E965','E966','E967','E968','E969' ) 
or SecondaryDx7 in ('99580','99581','E960','E961','E962','E963','E964','E965','E966','E967','E968','E969' ) or SecondaryDx8 in ('99580','99581','E960','E961','E962','E963','E964','E965','E966','E967','E968','E969' ) 
or SecondaryDx9 in ('99580','99581','E960','E961','E962','E963','E964','E965','E966','E967','E968','E969' ) or SecondaryDx10 in ('99580','99581','E960','E961','E962','E963','E964','E965','E966','E967','E968','E969' ) 
or SecondaryDx11 in ('99580','99581','E960','E961','E962','E963','E964','E965','E966','E967','E968','E969' ) or SecondaryDx12 in ('99580','99581','E960','E961','E962','E963','E964','E965','E966','E967','E968','E969' ) 

) then 1 else 0 end as violence label="Admissions/ED Visits for Violence-related Injury ",

  


case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('96500') or DischargeDx in ('96500') 
or SecondaryDx1 in ('96500') or SecondaryDx2 in ('96500') 
or SecondaryDx3 in ('96500') or SecondaryDx4 in ('96500') 
or SecondaryDx5 in ('96500') or SecondaryDx6 in ('96500') 
or SecondaryDx7 in ('96500') or SecondaryDx8 in ('96500') 
or SecondaryDx9 in ('96500') or SecondaryDx10 in ('96500') 
or SecondaryDx11 in ('96500') or SecondaryDx12 in ('96500') 

) then 1 else 0 end as abuse1 label="Admissions for Substance Abuse: Poisoning by opium (alkaloids)",

case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('96501') or DischargeDx in ('96501') 
or SecondaryDx1 in ('96501') or SecondaryDx2 in ('96501') 
or SecondaryDx3 in ('96501') or SecondaryDx4 in ('96501') 
or SecondaryDx5 in ('96501') or SecondaryDx6 in ('96501') 
or SecondaryDx7 in ('96501') or SecondaryDx8 in ('96501') 
or SecondaryDx9 in ('96501') or SecondaryDx10 in ('96501') 
or SecondaryDx11 in ('96501') or SecondaryDx12 in ('96501') 

) then 1 else 0 end as abuse2 label="Admissions for Substance Abuse: Poisoning by heroin Poisoning-heroin",

case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('96502') or DischargeDx in ('96502') 
or SecondaryDx1 in ('96502') or SecondaryDx2 in ('96502') 
or SecondaryDx3 in ('96502') or SecondaryDx4 in ('96502') 
or SecondaryDx5 in ('96502') or SecondaryDx6 in ('96502') 
or SecondaryDx7 in ('96502') or SecondaryDx8 in ('96502') 
or SecondaryDx9 in ('96502') or SecondaryDx10 in ('96502') 
or SecondaryDx11 in ('96502') or SecondaryDx12 in ('96502') 

) then 1 else 0 end as abuse3 label="Admissions for Substance Abuse: Poisoning by methadone Poisoning-methadone",
 
case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('96509') or DischargeDx in ('96509') 
or SecondaryDx1 in ('96509') or SecondaryDx2 in ('96509') 
or SecondaryDx3 in ('96509') or SecondaryDx4 in ('96509') 
or SecondaryDx5 in ('96509') or SecondaryDx6 in ('96509') 
or SecondaryDx7 in ('96509') or SecondaryDx8 in ('96509') 
or SecondaryDx9 in ('96509') or SecondaryDx10 in ('96509') 
or SecondaryDx11 in ('96509') or SecondaryDx12 in ('96509') 

) then 1 else 0 end as abuse4 label="Admissions for Substance Abuse: Poisoning by other opiates and related narcotics",
    

case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('E8500') or DischargeDx in ('E8500') 
or SecondaryDx1 in ('E8500') or SecondaryDx2 in ('E8500') 
or SecondaryDx3 in ('E8500') or SecondaryDx4 in ('E8500') 
or SecondaryDx5 in ('E8500') or SecondaryDx6 in ('E8500') 
or SecondaryDx7 in ('E8500') or SecondaryDx8 in ('E8500') 
or SecondaryDx9 in ('E8500') or SecondaryDx10 in ('E8500') 
or SecondaryDx11 in ('E8500') or SecondaryDx12 in ('E8500') 

) then 1 else 0 end as abuse5 label="Admissions for Substance Abuse: Accidental poisoning by heroin",
 

case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('E8501') or DischargeDx in ('E8501') 
or SecondaryDx1 in ('E8501') or SecondaryDx2 in ('E8501') 
or SecondaryDx3 in ('E8501') or SecondaryDx4 in ('E8501') 
or SecondaryDx5 in ('E8501') or SecondaryDx6 in ('E8501') 
or SecondaryDx7 in ('E8501') or SecondaryDx8 in ('E8501') 
or SecondaryDx9 in ('E8501') or SecondaryDx10 in ('E8501') 
or SecondaryDx11 in ('E8501') or SecondaryDx12 in ('E8501') 

) then 1 else 0 end as abuse6 label="Admissions for Substance Abuse: Accidental poisoning by methadone",
 

case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('E8502') or DischargeDx in ('E8502') 
or SecondaryDx1 in ('E8502') or SecondaryDx2 in ('E8502') 
or SecondaryDx3 in ('E8502') or SecondaryDx4 in ('E8502') 
or SecondaryDx5 in ('E8502') or SecondaryDx6 in ('E8502') 
or SecondaryDx7 in ('E8502') or SecondaryDx8 in ('E8502') 
or SecondaryDx9 in ('E8502') or SecondaryDx10 in ('E8502') 
or SecondaryDx11 in ('E8502') or SecondaryDx12 in ('E8502') 

) then 1 else 0 end as abuse7 label="Admissions for Substance Abuse: Accidental poisoning by other opiates and related narcotics",
 
case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('9773') or DischargeDx in ('9773') 
or SecondaryDx1 in ('9773') or SecondaryDx2 in ('9773') 
or SecondaryDx3 in ('9773') or SecondaryDx4 in ('9773') 
or SecondaryDx5 in ('9773') or SecondaryDx6 in ('9773') 
or SecondaryDx7 in ('9773') or SecondaryDx8 in ('9773') 
or SecondaryDx9 in ('9773') or SecondaryDx10 in ('9773') 
or SecondaryDx11 in ('9773') or SecondaryDx12 in ('9773') 

) then 1 else 0 end as abuse8 label="Admissions for Substance Abuse: Poisoning by alcohol deterrents",
 
case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('9800') or DischargeDx in ('9800') 
or SecondaryDx1 in ('9800') or SecondaryDx2 in ('9800') 
or SecondaryDx3 in ('9800') or SecondaryDx4 in ('9800') 
or SecondaryDx5 in ('9800') or SecondaryDx6 in ('9800') 
or SecondaryDx7 in ('9800') or SecondaryDx8 in ('9800') 
or SecondaryDx9 in ('9800') or SecondaryDx10 in ('9800') 
or SecondaryDx11 in ('9800') or SecondaryDx12 in ('9800') 

) then 1 else 0 end as abuse9 label="Admissions for Substance Abuse: Toxic effect of ethyl alcohol",
 
case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('9801') or DischargeDx in ('9801') 
or SecondaryDx1 in ('9801') or SecondaryDx2 in ('9801') 
or SecondaryDx3 in ('9801') or SecondaryDx4 in ('9801') 
or SecondaryDx5 in ('9801') or SecondaryDx6 in ('9801') 
or SecondaryDx7 in ('9801') or SecondaryDx8 in ('9801') 
or SecondaryDx9 in ('9801') or SecondaryDx10 in ('9801') 
or SecondaryDx11 in ('9801') or SecondaryDx12 in ('9801') 

) then 1 else 0 end as abuse10 label="Admissions for Substance Abuse: Toxic effect of methyl alcohol",
 
case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('9802') or DischargeDx in ('9802') 
or SecondaryDx1 in ('9802') or SecondaryDx2 in ('9802') 
or SecondaryDx3 in ('9802') or SecondaryDx4 in ('9802') 
or SecondaryDx5 in ('9802') or SecondaryDx6 in ('9802') 
or SecondaryDx7 in ('9802') or SecondaryDx8 in ('9802') 
or SecondaryDx9 in ('9802') or SecondaryDx10 in ('9802') 
or SecondaryDx11 in ('9802') or SecondaryDx12 in ('9802') 

) then 1 else 0 end as abuse11 label="Admissions for Substance Abuse: Toxic effect of isopropyl alcohol",
 
case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('9808') or DischargeDx in ('9808') 
or SecondaryDx1 in ('9808') or SecondaryDx2 in ('9808') 
or SecondaryDx3 in ('9808') or SecondaryDx4 in ('9808') 
or SecondaryDx5 in ('9808') or SecondaryDx6 in ('9808') 
or SecondaryDx7 in ('9808') or SecondaryDx8 in ('9808') 
or SecondaryDx9 in ('9808') or SecondaryDx10 in ('9808') 
or SecondaryDx11 in ('9808') or SecondaryDx12 in ('9808') 

) then 1 else 0 end as abuse12 label="Admissions for Substance Abuse: Toxic effect of other specified alcohols",
 
case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('9809') or DischargeDx in ('9809') 
or SecondaryDx1 in ('9809') or SecondaryDx2 in ('9809') 
or SecondaryDx3 in ('9809') or SecondaryDx4 in ('9809') 
or SecondaryDx5 in ('9809') or SecondaryDx6 in ('9809') 
or SecondaryDx7 in ('9809') or SecondaryDx8 in ('9809') 
or SecondaryDx9 in ('9809') or SecondaryDx10 in ('9809') 
or SecondaryDx11 in ('9809') or SecondaryDx12 in ('9809') 

) then 1 else 0 end as abuse13 label="Admissions for Substance Abuse: Toxic effect of unspecified alcohol",
 
case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('E8600') or DischargeDx in ('E8600') 
or SecondaryDx1 in ('E8600') or SecondaryDx2 in ('E8600') 
or SecondaryDx3 in ('E8600') or SecondaryDx4 in ('E8600') 
or SecondaryDx5 in ('E8600') or SecondaryDx6 in ('E8600') 
or SecondaryDx7 in ('E8600') or SecondaryDx8 in ('E8600') 
or SecondaryDx9 in ('E8600') or SecondaryDx10 in ('E8600') 
or SecondaryDx11 in ('E8600') or SecondaryDx12 in ('E8600') 

) then 1 else 0 end as abuse14 label="Admissions for Substance Abuse: Accidental poisoning by alcoholic beverages",
 
case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('E8601') or DischargeDx in ('E8601') 
or SecondaryDx1 in ('E8601') or SecondaryDx2 in ('E8601') 
or SecondaryDx3 in ('E8601') or SecondaryDx4 in ('E8601') 
or SecondaryDx5 in ('E8601') or SecondaryDx6 in ('E8601') 
or SecondaryDx7 in ('E8601') or SecondaryDx8 in ('E8601') 
or SecondaryDx9 in ('E8601') or SecondaryDx10 in ('E8601') 
or SecondaryDx11 in ('E8601') or SecondaryDx12 in ('E8601') 

) then 1 else 0 end as abuse15 label="Admissions for Substance Abuse: Accidental poisoning by other and unspecified ethyl alcohol and its products",
 
case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('E8602') or DischargeDx in ('E8602') 
or SecondaryDx1 in ('E8602') or SecondaryDx2 in ('E8602') 
or SecondaryDx3 in ('E8602') or SecondaryDx4 in ('E8602') 
or SecondaryDx5 in ('E8602') or SecondaryDx6 in ('E8602') 
or SecondaryDx7 in ('E8602') or SecondaryDx8 in ('E8602') 
or SecondaryDx9 in ('E8602') or SecondaryDx10 in ('E8602') 
or SecondaryDx11 in ('E8602') or SecondaryDx12 in ('E8602') 

) then 1 else 0 end as abuse16 label="Admissions for Substance Abuse: Accidental poisoning by methyl alcohol",
 
case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('E8603') or DischargeDx in ('E8603') 
or SecondaryDx1 in ('E8603') or SecondaryDx2 in ('E8603') 
or SecondaryDx3 in ('E8603') or SecondaryDx4 in ('E8603') 
or SecondaryDx5 in ('E8603') or SecondaryDx6 in ('E8603') 
or SecondaryDx7 in ('E8603') or SecondaryDx8 in ('E8603') 
or SecondaryDx9 in ('E8603') or SecondaryDx10 in ('E8603') 
or SecondaryDx11 in ('E8603') or SecondaryDx12 in ('E8603') 

) then 1 else 0 end as abuse17 label="Admissions for Substance Abuse: Accidental poisoning by isopropyl alcohol",
 
case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('E8608') or DischargeDx in ('E8608') 
or SecondaryDx1 in ('E8608') or SecondaryDx2 in ('E8608') 
or SecondaryDx3 in ('E8608') or SecondaryDx4 in ('E8608') 
or SecondaryDx5 in ('E8608') or SecondaryDx6 in ('E8608') 
or SecondaryDx7 in ('E8608') or SecondaryDx8 in ('E8608') 
or SecondaryDx9 in ('E8608') or SecondaryDx10 in ('E8608') 
or SecondaryDx11 in ('E8608') or SecondaryDx12 in ('E8608') 

) then 1 else 0 end as abuse18 label="Admissions for Substance Abuse: Accidental poisoning by other specified alcohols",
 
case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('E8609') or DischargeDx in ('E8609') 
or SecondaryDx1 in ('E8609') or SecondaryDx2 in ('E8609') 
or SecondaryDx3 in ('E8609') or SecondaryDx4 in ('E8609') 
or SecondaryDx5 in ('E8609') or SecondaryDx6 in ('E8609') 
or SecondaryDx7 in ('E8609') or SecondaryDx8 in ('E8609') 
or SecondaryDx9 in ('E8609') or SecondaryDx10 in ('E8609') 
or SecondaryDx11 in ('E8609') or SecondaryDx12 in ('E8609') 

) then 1 else 0 end as abuse19 label="Admissions for Substance Abuse: Accidental poisoning by unspecified alcohol",
 
case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('96500','96501', '96502', '96509', 'E8500', 'E8501', 'E8502' ) or DischargeDx in ('96500','96501', '96502', '96509', 'E8500', 'E8501', 'E8502' ) 
or SecondaryDx1 in ('96500','96501', '96502', '96509', 'E8500', 'E8501', 'E8502' ) or SecondaryDx2 in ('96500','96501', '96502', '96509', 'E8500', 'E8501', 'E8502' ) 
or SecondaryDx3 in ('96500','96501', '96502', '96509', 'E8500', 'E8501', 'E8502' ) or SecondaryDx4 in ('96500','96501', '96502', '96509', 'E8500', 'E8501', 'E8502' ) 
or SecondaryDx5 in ('96500','96501', '96502', '96509', 'E8500', 'E8501', 'E8502' ) or SecondaryDx6 in ('96500','96501', '96502', '96509', 'E8500', 'E8501', 'E8502' ) 
or SecondaryDx7 in ('96500','96501', '96502', '96509', 'E8500', 'E8501', 'E8502' ) or SecondaryDx8 in ('96500','96501', '96502', '96509', 'E8500', 'E8501', 'E8502' ) 
or SecondaryDx9 in ('96500','96501', '96502', '96509', 'E8500', 'E8501', 'E8502' ) or SecondaryDx10 in ('96500','96501', '96502', '96509', 'E8500', 'E8501', 'E8502' ) 
or SecondaryDx11 in ('96500','96501', '96502', '96509', 'E8500', 'E8501', 'E8502' ) or SecondaryDx12 in ('96500','96501', '96502', '96509', 'E8500', 'E8501', 'E8502' ) 
) then 1 else 0 end as opioid label="Admissions for Substance Abuse: All opioid abuse",
 
case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('9773','9800','9801','9802','9808','9809','E8600','E8601','E8602','E8603','E8608','E8609') or DischargeDx in ('9773','9800','9801','9802','9808','9809','E8600','E8601','E8602','E8603','E8608','E8609') 
or SecondaryDx1 in ('9773','9800','9801','9802','9808','9809','E8600','E8601','E8602','E8603','E8608','E8609') or SecondaryDx2 in ('9773','9800','9801','9802','9808','9809','E8600','E8601','E8602','E8603','E8608','E8609') 
or SecondaryDx3 in ('9773','9800','9801','9802','9808','9809','E8600','E8601','E8602','E8603','E8608','E8609') or SecondaryDx4 in ('9773','9800','9801','9802','9808','9809','E8600','E8601','E8602','E8603','E8608','E8609') 
or SecondaryDx5 in ('9773','9800','9801','9802','9808','9809','E8600','E8601','E8602','E8603','E8608','E8609') or SecondaryDx6 in ('9773','9800','9801','9802','9808','9809','E8600','E8601','E8602','E8603','E8608','E8609') 
or SecondaryDx7 in ('9773','9800','9801','9802','9808','9809','E8600','E8601','E8602','E8603','E8608','E8609') or SecondaryDx8 in ('9773','9800','9801','9802','9808','9809','E8600','E8601','E8602','E8603','E8608','E8609') 
or SecondaryDx9 in ('9773','9800','9801','9802','9808','9809','E8600','E8601','E8602','E8603','E8608','E8609') or SecondaryDx10 in ('9773','9800','9801','9802','9808','9809','E8600','E8601','E8602','E8603','E8608','E8609') 
or SecondaryDx11 in ('9773','9800','9801','9802','9808','9809','E8600','E8601','E8602','E8603','E8608','E8609') or SecondaryDx12 in ('9773','9800','9801','9802','9808','9809','E8600','E8601','E8602','E8603','E8608','E8609') 
) then 1 else 0 end as alcohol label="Admissions for Substance Abuse: All alcohol abuse",
 
  

case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
substr(AdmissionDx,1,3) in ('295') or substr(DischargeDx,1,3) in ('295') 
or substr(SecondaryDx1,1,3) in ('295') or substr(SecondaryDx2,1,3) in ('295') 
or substr(SecondaryDx3,1,3) in ('295') or substr(SecondaryDx4,1,3) in ('295') 
or substr(SecondaryDx5,1,3) in ('295') or substr(SecondaryDx6,1,3) in ('295') 
or substr(SecondaryDx7,1,3) in ('295') or substr(SecondaryDx8,1,3) in ('295') 
or substr(SecondaryDx9,1,3) in ('295') or substr(SecondaryDx10,1,3) in ('295') 
or substr(SecondaryDx11,1,3) in ('295') or substr(SecondaryDx12,1,3) in ('295') 

or AdmissionDx in ('2913','2915','2921','29211','29212') or DischargeDx in ('2913','2915','2921','29211','29212') 
or SecondaryDx1 in ('2913','2915','2921','29211','29212') or SecondaryDx2 in ('2913','2915','2921','29211','29212') 
or SecondaryDx3 in ('2913','2915','2921','29211','29212') or SecondaryDx4 in ('2913','2915','2921','29211','29212') 
or SecondaryDx5 in ('2913','2915','2921','29211','29212') or SecondaryDx6 in ('2913','2915','2921','29211','29212') 
or SecondaryDx7 in ('2913','2915','2921','29211','29212') or SecondaryDx8 in ('2913','2915','2921','29211','29212') 
or SecondaryDx9 in ('2913','2915','2921','29211','29212') or SecondaryDx10 in ('2913','2915','2921','29211','29212') 
or SecondaryDx11 in ('2913','2915','2921','29211','29212') or SecondaryDx12 in ('2913','2915','2921','29211','29212') 
) then 1 else 0 end as MH1  label="Admissions for Mental-Health Related Conditions: Schizophrenia/Psychotic Disease",
 


case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('2962', '2963', '2965', '2980', '311') or DischargeDx in ('2962', '2963', '2965', '2980', '311') 
or SecondaryDx1 in ('2962', '2963', '2965', '2980', '311') or SecondaryDx2 in ('2962', '2963', '2965', '2980', '311') 
or SecondaryDx3 in ('2962', '2963', '2965', '2980', '311') or SecondaryDx4 in ('2962', '2963', '2965', '2980', '311') 
or SecondaryDx5 in ('2962', '2963', '2965', '2980', '311') or SecondaryDx6 in ('2962', '2963', '2965', '2980', '311') 
or SecondaryDx7 in ('2962', '2963', '2965', '2980', '311') or SecondaryDx8 in ('2962', '2963', '2965', '2980', '311') 
or SecondaryDx9 in ('2962', '2963', '2965', '2980', '311') or SecondaryDx10 in ('2962', '2963', '2965', '2980', '311') 
or SecondaryDx11 in ('2962', '2963', '2965', '2980', '311') or SecondaryDx12 in ('2962', '2963', '2965', '2980', '311') 

) then 1 else 0 end as MH2 label="Admissions for Mental-Health Related Conditions: Depression",

 


case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('2964','2965','2966','2967') or DischargeDx in ('2964','2965','2966','2967') 
or SecondaryDx1 in ('2964','2965','2966','2967') or SecondaryDx2 in ('2964','2965','2966','2967') 
or SecondaryDx3 in ('2964','2965','2966','2967') or SecondaryDx4 in ('2964','2965','2966','2967') 
or SecondaryDx5 in ('2964','2965','2966','2967') or SecondaryDx6 in ('2964','2965','2966','2967') 
or SecondaryDx7 in ('2964','2965','2966','2967') or SecondaryDx8 in ('2964','2965','2966','2967') 
or SecondaryDx9 in ('2964','2965','2966','2967') or SecondaryDx10 in ('2964','2965','2966','2967') 
or SecondaryDx11 in ('2964','2965','2966','2967') or SecondaryDx12 in ('2964','2965','2966','2967') 

) then 1 else 0 end as MH3  label="Admissions for Mental-Health Related Conditions: Bipolar disease",


case when TypeOfClaim ='002' and TypeofBill in ('11','41') 
and (
AdmissionDx in ('E950','E9500','E9501','E9502','E9503','E9504','E9505','E9506','E9507','E9508', 'V6282') or DischargeDx in ('E950','E9500','E9501','E9502','E9503','E9504','E9505','E9506','E9507','E9508', 'V6282') 
or SecondaryDx1 in ('E950','E9500','E9501','E9502','E9503','E9504','E9505','E9506','E9507','E9508', 'V6282') or SecondaryDx2 in ('E950','E9500','E9501','E9502','E9503','E9504','E9505','E9506','E9507','E9508', 'V6282') 
or SecondaryDx3 in ('E950','E9500','E9501','E9502','E9503','E9504','E9505','E9506','E9507','E9508', 'V6282') or SecondaryDx4 in ('E950','E9500','E9501','E9502','E9503','E9504','E9505','E9506','E9507','E9508', 'V6282') 
or SecondaryDx5 in ('E950','E9500','E9501','E9502','E9503','E9504','E9505','E9506','E9507','E9508', 'V6282') or SecondaryDx6 in ('E950','E9500','E9501','E9502','E9503','E9504','E9505','E9506','E9507','E9508', 'V6282') 
or SecondaryDx7 in ('E950','E9500','E9501','E9502','E9503','E9504','E9505','E9506','E9507','E9508', 'V6282') or SecondaryDx8 in ('E950','E9500','E9501','E9502','E9503','E9504','E9505','E9506','E9507','E9508', 'V6282') 
or SecondaryDx9 in ('E950','E9500','E9501','E9502','E9503','E9504','E9505','E9506','E9507','E9508', 'V6282') or SecondaryDx10 in ('E950','E9500','E9501','E9502','E9503','E9504','E9505','E9506','E9507','E9508', 'V6282') 
or SecondaryDx11 in ('E950','E9500','E9501','E9502','E9503','E9504','E9505','E9506','E9507','E9508', 'V6282') or SecondaryDx12 in ('E950','E9500','E9501','E9502','E9503','E9504','E9505','E9506','E9507','E9508', 'V6282') 

) then 1 else 0 end as MH4 label="Admissions for Mental-Health Related Conditions: Suicide attempt or ideation"
from Claims2012;
quit;
 

* Number of Admissions for each patients;
proc sort data=temp; by MemberLinkEID;run;

proc sql;
create table temp1 as
select MemberLinkEID, sum(Sroke) as Stroke,
sum(Diabetes) as adm_Diabetes,
sum(HF) as HF,
sum(AMI) as AMI,
sum(PN) as PN,
sum(COPD)as COPD,
sum(traffic) as traffic,
sum(violence) as violence,
sum(abuse1) as abuse1,sum(abuse2) as abuse2,sum(abuse3) as abuse3,sum(abuse4) as abuse4,sum(abuse5) as abuse5,sum(abuse6) as abuse6,
sum(abuse7) as abuse7,sum(abuse8) as abuse8,sum(abuse9) as abuse9,sum(abuse10) as abuse10,sum(abuse11) as abuse11,sum(abuse12) as abuse12,
sum(abuse13) as abuse13,sum(abuse14) as abuse14,sum(abuse15) as abuse15,sum(abuse16) as abuse16,sum(abuse17) as abuse17,sum(abuse18) as abuse18,sum(abuse19) as abuse19,
sum(opioid) as opioid,
sum(alcohol) as alcohol,
sum(MH1)as MH1,sum(MH2)as MH2,sum(MH3)as MH3,sum(MH4)as MH4
from temp
group by MemberlinkEID;
quit;

* get bene informaiton;
data adult;
set APCD.AnalyticDataCost;
keep MemberLinkEID CountyName StateName ZIP CostwDrug CostwoDrug age;
run;
data Kid;
set APCD.AnalyticDataKidCost;
keep MemberLinkEID CountyName StateName ZIP CostwDrug CostwoDrug age;
run;

data bene;
set adult kid;
run;

 
proc sql;
create table bene1 as
select a.*,b.*
from bene a left join temp1 b
on a.MemberLinkEID=b.MemberLinkEID;
quit;
proc sql;
create table bene2 as
select a.*,b.*
from bene1 a left join APCD.CC2012 b
on a.MemberLinkEID=b.MemberLinkEID;
quit;
 
data APCD.bene2;
set bene2;
run;
 
 

data  bene3;
length AgeG NCCg $20.;
set APCD.bene2;
if statename ne '' and age ne .;

*chronic conditions;
array cc{30} amiihd amputat arthrit  artopen  bph  
cancer  chrkid  chf  cystfib  dementia  
diabetes  endo  eyedis hemadis  hyperlip  
hyperten  immunedis  ibd liver  lung   
neuromusc  osteo  paralyt  psydis  sknulc 
spchrtarr  strk sa  thyroid  vascdis;
do i=1 to 30;
if cc{i}>0 then cc{i}=1;
if cc{i}=. then cc{i}=0;
end;

NCC=amiihd+amputat+arthrit+artopen+bph+cancer+chrkid+chf+cystfib+dementia+ diabetes+endo+eyedis+hemadis+hyperlip+hyperten+immunedis+ibd+liver+lung+neuromusc+osteo+paralyt+psydis+sknulc+spchrtarr+strk+sa+thyroid+vascdis;
if NCC=0 then NCCg1=1;else NCCg1=0;
if NCC=1 then NCCg2=1;else NCCg2=0;
if NCC in (2,3) then NCCg3=1;else NCCg3=0;
if NCC in (4,5,6) then NCCg4=1;else NCCg4=0;
if NCC in (7,8,9) then NCCg5=1;else NCCg5=0;
if NCC>=10 then NCCg6=1;else NCCg6=0;

 
array cc1 {30} amiihd amputat arthrit  artopen  bph  
cancer  chrkid  chf  cystfib  dementia  
diabetes  endo  eyedis hemadis  hyperlip  
hyperten  immunedis  ibd liver  lung   
neuromusc  osteo  paralyt  psydis  sknulc 
spchrtarr  strk sa  thyroid  vascdis;
do i=1 to 30;
cc1{i}=cc1{i}*1000;
end;
 

*Age group;
if age<0 then age=0;
if age>=0 and age<=9 then AgeG="0-9";
else if age>=10 and age<18 then AgeG="10 to <18";
else if age>=18 and age<=24 then AgeG="18-24";
else if age>=25 and age<=34 then AgeG="25-34";
else if age>=35 and age<=44 then AgeG="35-44"; 
else if age>=45 and age<=54 then AgeG="45-54"; 
else if age>=55 and age<=64 then AgeG="55-64"; 
else if age>=65 and age<=74 then AgeG="65-74"; 
else if age>=75  then AgeG=">=75"; 
 
*Prevalence of hospital admissions ;
array adm{6} Stroke  HF AMI PN COPD adm_diabetes;
do i=1 to 6;
if adm{i}>0 then adm{i}=1;
if adm{i}=. then adm{i}=0;
adm{i}=adm{i}*1000;
end;



*mental-health related conditions ;
array mh{4} MH1 MH2 MH3 MH4;
do i=1 to 4;
if mh{i}>0 then mh{i}=1;
if mh{i}=. then mh{i}=0;
mh{i}=mh{i}*1000;
end;

* traffic, violence, substance abuse ;
array other{23} abuse1 abuse2 abuse3 abuse4 abuse5 abuse6 abuse7 abuse8 abuse9 abuse10 abuse11 abuse12 abuse13 abuse14 abuse15 abuse16 abuse17 abuse18 abuse19 
traffic violence opioid alcohol;
do i=1 to 23;
if other{i}>0 then other{i}=1;
if other{i}=. then other{i}=0;
other{i}=other{i}*1000;
end;
proc freq;tables AgeG zip countyname/missing;
proc means;
var Stroke Diabetes HF AMI PN COPD
amiihd amputat arthrit  artopen  bph  
cancer  chrkid  chf  cystfib  dementia  
diabetes  endo  eyedis hemadis  hyperlip  
hyperten  immunedis  ibd liver  lung   
neuromusc  osteo  paralyt  psydis  sknulc 
spchrtarr  strk sa  thyroid  vascdis
NCC NCCg1 NCCg2 NCCg3 NCCg4 NCCg5 NCCg6
MH1 MH2 MH3 MH4
abuse1 abuse2 abuse3 abuse4 abuse5 abuse6 abuse7 abuse8 abuse9 abuse10 abuse11 abuse12 abuse13 abuse14 abuse15 abuse16 abuse17 abuse18 abuse19 
traffic violence opioid alcohol;
run;

 

/*
Using APCD Data Year 2012:

1. Total standardized costs overall and by age group for each zip code in Massachusetts 

Age group: 
0-9
10 to <18
18-24
25-34
35-44
45-54
55-64
65-74
>75
*/
proc tabulate data=bene3 noseps  ;
class AgeG ZIP  ; 
var   CostwDrug CostwoDrug  ;
table ZIP all, 
      AgeG*CostwDrug="Total Standard Cost, Medical+Pharmacy"*(mean*f=dollar12.  sum*f=dollar12.) all*CostwDrug="Total Standard Cost, Medical+Pharmacy"*(mean*f=dollar12.  sum*f=dollar12.);
table ZIP all, 
      AgeG*CostwoDrug="Total Standard Cost, Medical Only"*(mean*f=dollar12.  sum*f=dollar12.) all*CostwoDrug="Total Standard Cost, Medical Only"*(mean*f=dollar12.  sum*f=dollar12.);
keylabel all="All People";
run;
/*
2. Prevalence of hospital admissions overall and by age group for each zip code (per 1000): 
-Stroke
-type 1 or 2 diabetes
-congestive heart failure
-AMI
-pneumonia
-copd
*/
proc tabulate data=bene3 noseps  ;
class AgeG ZIP  ; 
var   Stroke adm_Diabetes HF AMI PN COPD;
table Zip all, AgeG*(Stroke="Stroke" adm_Diabetes="type 1 or 2 diabetes" HF="congestive heart failure" AMI="AMI" PN="pneumonia" COPD="COPD")*(mean*f=7.6) All*(Stroke="Stroke" adm_Diabetes="type 1 or 2 diabetes" HF="congestive heart failure" AMI="AMI" PN="pneumonia" COPD="COPD")*(mean*f=7.6);
keylabel all="All People";
run;
/*
3. Proportion of patients overall and by age group of each zip code with chronic conditions:
-0 conditions
-1 condition
2-3 conditions
4-6 conditions
7-9 conditions
10 or greater conditions
Mean & Median # conditions

Proportion of patients overall and by age group of each zip code with prevalence of each chronic conditions (CCW)
*/
proc tabulate data=bene3 noseps  ;
class AgeG ZIP ; 
var    NCCg1 NCCg2 NCCg3 NCCg4 NCCg5 NCCg6;
table Zip all, AgeG*(NCCg1="0 conditions"*mean*f=percent7.2 NCCg2="1 condition"*mean*f=percent7.2 NCCg3="2-3 conditions"*mean*f=percent7.2 NCCg4="4-6 conditions"*mean*f=percent7.2 NCCg5="7-9 conditions"*mean*f=percent7.2 NCCg6="10 or greater conditions"*mean*f=percent7.2)
all*(NCCg1="0 conditions"*mean*f=percent7.2 NCCg2="1 condition"*mean*f=percent7.2 NCCg3="2-3 conditions"*mean*f=percent7.2 NCCg4="4-6 conditions"*mean*f=percent7.2 NCCg5="7-9 conditions"*mean*f=percent7.2 NCCg6="10 or greater conditions"*mean*f=percent7.2);
keylabel all="All People";
run;

proc tabulate data=bene3 noseps  ;
class AgeG ZIP ; 
var    NCC ;
table Zip all, AgeG*NCC ="Number of Chronic Conditions"*(mean*f=7.4 median)
all*NCC ="Number of Chronic Conditions"*(mean*f=7.4 median);
keylabel all="All People";
run;

proc tabulate data=bene3 noseps  ;
class AgeG ZIP ; 
var  amiihd amputat arthrit  artopen  bph  
cancer  chrkid  chf  cystfib  dementia  
diabetes  endo  eyedis hemadis  hyperlip  
hyperten  immunedis  ibd liver  lung   
neuromusc  osteo  paralyt  psydis  sknulc 
spchrtarr  strk sa  thyroid  vascdis;
table Zip all, AgeG*(amiihd*mean*f=7.6 amputat*mean*f=7.6 arthrit*mean*f=7.6  artopen*mean*f=7.6  bph*mean*f=7.6  
cancer*mean*f=7.6  chrkid*mean*f=7.6  chf*mean*f=7.6  cystfib*mean*f=7.6  dementia*mean*f=7.6  
diabetes*mean*f=7.6  endo*mean*f=7.6  eyedis*mean*f=7.6 hemadis*mean*f=7.6  hyperlip*mean*f=7.6  
hyperten*mean*f=7.6  immunedis*mean*f=7.6  ibd*mean*f=7.6 liver*mean*f=7.6  lung*mean*f=7.6   
neuromusc*mean*f=7.6  osteo*mean*f=7.6  paralyt*mean*f=7.6  psydis*mean*f=7.6  sknulc*mean*f=7.6 
spchrtarr*mean*f=7.6  strk*mean*f=7.6 sa*mean*f=7.6  thyroid*mean*f=7.6  vascdis*mean*f=7.6)
all*(amiihd*mean*f=7.6 amputat*mean*f=7.6 arthrit*mean*f=7.6  artopen*mean*f=7.6  bph*mean*f=7.6  
cancer*mean*f=7.6  chrkid*mean*f=7.6  chf*mean*f=7.6  cystfib*mean*f=7.6  dementia*mean*f=7.6  
diabetes*mean*f=7.6  endo*mean*f=7.6  eyedis*mean*f=7.6 hemadis*mean*f=7.6  hyperlip*mean*f=7.6  
hyperten*mean*f=7.6  immunedis*mean*f=7.6  ibd*mean*f=7.6 liver*mean*f=7.6  lung*mean*f=7.6   
neuromusc*mean*f=7.6  osteo*mean*f=7.6  paralyt*mean*f=7.6  psydis*mean*f=7.6  sknulc*mean*f=7.6 
spchrtarr*mean*f=7.6  strk*mean*f=7.6 sa*mean*f=7.6  thyroid*mean*f=7.6  vascdis*mean*f=7.6);
keylabel all="All People";
run;

/*
 
5. Number of admissions for mental-health related conditions by age group (per 1000)
-Schizophrenia/Psychotic Disease
-Depression
-Bipolar disease    
-Suicide attempt or ideation
*/
proc tabulate data=bene3 noseps  ;
class AgeG ZIP ; 
var  MH1 MH2 MH3 MH4;
table Zip all, AgeG*(MH1*mean*f=7.6 MH2*mean*f=7.6 MH3*mean*f=7.6 MH4*mean*f=7.6)
all*(MH1*mean*f=7.6 MH2*mean*f=7.6 MH3*mean*f=7.6 MH4*mean*f=7.6);
keylabel all="All People";
run;

/*
6. 5. Number of admissions for traffic related injury overall and by age group (per 1000) for each zip code
Note: group the following codes together
E810 Motor vehicle traffic accident involving collision with train
E811 Motor vehicle traffic accident involving re-entrant collision with another motor vehicle
E812 Other motor vehicle traffic accident involving collision with motor vehicle
E813 Motor vehicle traffic accident involving collision with other vehicle
E814 Motor vehicle traffic accident involving collision with pedestrian
E815 Other motor vehicle traffic accident involving collision on the highway
E816 Motor vehicle traffic accident due to loss of control without collision on the highway
E817 Noncollision motor vehicle traffic accident while boarding or alighting
E818 Other noncollision motor vehicle traffic accident
E819 Motor vehicle traffic accident of unspecified nature
E820 Nontraffic accident involving motor-driven snow vehicle
E821 Nontraffic accident involving other off-road motor vehicle
E822 Other motor vehicle nontraffic accident involving collision with moving object
E823 Other motor vehicle nontraffic accident involving collision with stationary object
E824 Other motor vehicle nontraffic accident while boarding and alighting
E825 Other motor vehicle nontraffic accident of other and unspecified nature
E826 Pedal cycle accident
E827 Animal-drawn vehicle accident
E828 Accident involving animal being ridden
E829 Other road vehicle accidents
*/
proc tabulate data=bene3 noseps  ;
class AgeG ZIP ; 
var  traffic;
table Zip all, AgeG*traffic*mean*f=7.6
all* traffic;
keylabel all="All People";
run;

/*
6. Number of admissions/ED visits for violence-related injury overall and by age group (per 1000) for each zip code
995.80 Adult Maltreatment, unspecified
995.81 Adult physical abuse
E960-E969 
E960 Fight brawl rape
E961 Assault by corrosive or caustic substance, except poisoning
E962 Assault by poisoning
E963 Assault by hanging and strangulation
E964 Assault by submersion [drowning]
E965 Assault by firearms and explosives
E966 Assault by cutting and piercing instrument
E967 Perpetrator of child and adult abuse
E968 Assault by other and unspecified means
E969 Late effects of injury purposely inflicted by other person
*/
proc tabulate data=bene3 noseps  ;
class AgeG ZIP ; 
var violence;
table Zip all, AgeG*violence*mean*f=7.6
all*violence*mean*f=7.6;
keylabel all="All People";
run;
/*
7. Number of admissions for substance abuse claims overall and by age group (per 1000) for each zip code 

Each of the following codes separately

96500	Poisoning by opium (alkaloids), unspecified	Poisoning-opium NOS
96501	Poisoning by heroin	Poisoning-heroin
96502	Poisoning by methadone	Poisoning-methadone
96509	Poisoning by other opiates and related narcotics	Poisoning-opiates NEC
E8500	Accidental poisoning by heroin	Acc poison-heroin
E8501	Accidental poisoning by methadone	Acc poison-methadone
E8502	Accidental poisoning by other opiates and related narcotics	Acc poison-opiates NEC
9773	Poisoning by alcohol deterrents	Poison-alcohol deterrent
9800	Toxic effect of ethyl alcohol	Toxic eff ethyl alcohol
9801	Toxic effect of methyl alcohol	Toxic eff methyl alcohol
9802	Toxic effect of isopropyl alcohol	Toxic eff isopropyl alc
9808	Toxic effect of other specified alcohols	Toxic effect alcohol NEC
9809	Toxic effect of unspecified alcohol	Toxic effect alcohol NOS
E8600	Accidental poisoning by alcoholic beverages	Acc poisn-alcohol bevrag
E8601	Accidental poisoning by other and unspecified ethyl alcohol and its products	Acc poison-ethyl alcohol
E8602	Accidental poisoning by methyl alcohol	Acc poisn-methyl alcohol
E8603	Accidental poisoning by isopropyl alcohol	Acc poisn-isopropyl alc
E8608	Accidental poisoning by other specified alcohols	Acc poison-alcohol NEC
E8609	Accidental poisoning by unspecified alcohol	Acc poison-alcohol NOS

Then combine group 1 with the following and call it �gall opioid abuse�h:
96500	Poisoning by opium (alkaloids), unspecified	Poisoning-opium NOS
96501	Poisoning by heroin	Poisoning-heroin
96502	Poisoning by methadone	Poisoning-methadone
96509	Poisoning by other opiates and related narcotics	Poisoning-opiates NEC
E8500	Accidental poisoning by heroin	Acc poison-heroin
E8501	Accidental poisoning by methadone	Acc poison-methadone
E8502	Accidental poisoning by other opiates and related narcotics	Acc poison-opiates NEC


Then combine group 2 with the following and call it �gall alcohol abuse�h: 
9773	Poisoning by alcohol deterrents	Poison-alcohol deterrent
9800	Toxic effect of ethyl alcohol	Toxic eff ethyl alcohol
9801	Toxic effect of methyl alcohol	Toxic eff methyl alcohol
9802	Toxic effect of isopropyl alcohol	Toxic eff isopropyl alc
9808	Toxic effect of other specified alcohols	Toxic effect alcohol NEC
9809	Toxic effect of unspecified alcohol	Toxic effect alcohol NOS
E8600	Accidental poisoning by alcoholic beverages	Acc poisn-alcohol bevrag
E8601	Accidental poisoning by other and unspecified ethyl alcohol and its products	Acc poison-ethyl alcohol
E8602	Accidental poisoning by methyl alcohol	Acc poisn-methyl alcohol
E8603	Accidental poisoning by isopropyl alcohol	Acc poisn-isopropyl alc
E8608	Accidental poisoning by other specified alcohols	Acc poison-alcohol NEC
E8609	Accidental poisoning by unspecified alcohol	Acc poison-alcohol NOS


*/

proc tabulate data=bene3 noseps  ;
class AgeG ZIP ; 
var abuse1 abuse2 abuse3 abuse4 abuse5 abuse6 abuse7 abuse8 abuse9 abuse10 abuse11 abuse12 abuse13 abuse14 abuse15 abuse16 abuse17 abuse18 abuse19 ;
table Zip all, AgeG*(abuse1 abuse2 abuse3 abuse4 abuse5 abuse6 abuse7 abuse8 abuse9 abuse10 abuse11 abuse12 abuse13 abuse14 abuse15 abuse16 abuse17 abuse18 abuse19)*mean*f=7.6
all*(abuse1 abuse2 abuse3 abuse4 abuse5 abuse6 abuse7 abuse8 abuse9 abuse10 abuse11 abuse12 abuse13 abuse14 abuse15 abuse16 abuse17 abuse18 abuse19 )*mean*f=7.6;
keylabel all="All People";
run;

proc tabulate data=bene3 noseps  ;
class AgeG ZIP ; 
var opioid alcohol;
table Zip all, AgeG*(opioid alcohol)*mean*f=7.6
all*(opioid alcohol)*mean*f=7.6;
keylabel all="All People";
run;
