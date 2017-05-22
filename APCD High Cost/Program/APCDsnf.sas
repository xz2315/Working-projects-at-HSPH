*******************************
APCD SNF claim lines
Xiner Zhou
2/23/2016
******************************;
libname APCD 'C:\data\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';

***DO: select institutional outpatient claims;
proc sql;
create table temp1 as
select MemberLinkEID, MemberDateofBirth as DOB, Standardized_MemberZIPCode as MemberZIP, Standardized_MemberZIPFirst3 as MemberZIP3,
MemberGenderCleaned as gender, Standardized_MemberStateorProvin as MemberState, Standardized_MemberCounty as MemberCounty, 

NationalServiceProviderIDCleaned as ServiceProviderNPI,ServiceProviderSpecialty, 
Standardized_ServiceProviderStat as ServiceProviderState, Standardized_ServiceProviderCoun as ServiceProviderCounty,Standardized_ServiceProviderCity as ServiceProviderCity,
Standardized_ServiceProviderZIPC as ServiceProviderZIP,
ServiceProviderNumber_Linkage_ID as ServiceProviderLink, ServiceProviderTaxIDNumber as ServiceProviderTaxID, PCPIndicator,


OrgID, MedicaidIndicator, ProductIDNumber_Linkage_ID as ProductLink,


TypeOfClaimCleaned as TypeOfClaim, TypeofBillOnFacilityClaims as TypeofBill, SiteofServiceOnNSFCMS1500ClaimsC as PlaceofService,
PayerClaimControlNumber,LineCounter,VersionNumber, VersionIndicator,VersionIndicator_1,HighestVersionDenied, ClaimStatus, ClaimLineType,


AdmissionDate,DischargeDate, DateofServiceFrom,DateofServiceTo, CoveredDays, NonCoveredDays, 
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
AttendingProvider_Linkage_ID as AttendProviderLink,  
HashCarrierSpecificUniqueMemberI as CarrierSpecificMemberID, HashCarrierSpecificUniqueSubscri as CarrierSpecificSubscriberID 
from APCD.Medical 
where TypeOfClaimCleaned='002' and TypeofBillOnFacilityClaims in ('18','21','22','23','28');
quit;

***End;


***DO:Keep the latest line version;

data temp2;
	set temp1;
	if memberlinkeid ne .;	
     
proc sort;by PayerClaimControlNumber LineCounter descending VersionNumber;
run;
proc sort data=temp2 out=SNForiginal nodupkey;by PayerClaimControlNumber LineCounter ;
run;
***End;


***DO: Calculate claim spending, delete denied claims lines, FY/CY;
 
data APCD.SNFstdcost;
set SNForiginal ;

    if Paid =. then Paid=0;
	if Copay =. then Copay=0;
	if Coinsurance=. then Coinsurance=0;
	if Deductible=. then Deductible=0;
	if Allowed=. then Allowed=0;

	spending=Paid +Copay +Coinsurance +Deductible ;

	if DeniedFlag ne '1' and claimlinetype not in ('B','V') AND Allowed>=0 and paid>=0 and deductible>=0 and copay>=0 and coinsurance>=0 ;
	if spending>=0;

    date1=datepart(DateOfServiceFrom);date2=datepart(DateOfServiceTo);
    if date2 ne . then do;
		if date2>='01oct2010'd and date2<='30sep2011'd then FY=2011;
		else if date2>='01oct2011'd and date2<='30sep2012'd then FY=2012;
		else if date2>='01oct2012'd and date2<='30sep2013'd then FY=2013;
		else if date2>='01oct2009'd and date2<='30sep2010'd then FY=2010;

		if date2>='01jan2011'd and date2<='31dec2011'd then CY=2011;
		else if date2>='01jan2012'd and date2<='31dec2012'd then CY=2012;
		else if date2>='01jan2013'd and date2<='31dec2013'd then CY=2013;
		else if date2>='01jan2010'd and date2<='31dec2010'd then CY=2010;
    end;

	else    if date1 ne . then do;
		if date1>='01oct2010'd and date1<='30sep2011'd then FY=2011;
		else if date1>='01oct2011'd and date1<='30sep2012'd then FY=2012;
		else if date1>='01oct2012'd and date1<='30sep2013'd then FY=2013;

		if date1>='01jan2011'd and date1<='31dec2011'd then CY=2011;
		else if date1>='01jan2012'd and date1<='31dec2012'd then CY=2012;
		else if date1>='01jan2013'd and date1<='31dec2013'd then CY=2013;
    end;
	if FY in (2011,2012,2013) ;

run;

***End;
