*******************************
APCD Hospice claim lines
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
where TypeOfClaimCleaned='002' and TypeofBillOnFacilityClaims in ('81','82');
quit;

***End;


***DO:Keep the latest line version;

data temp2;
	set temp1;
	if memberlinkeid ne .;	
     
proc sort;by PayerClaimControlNumber LineCounter descending VersionNumber;
run;
proc sort data=temp2 out=APCD.Hospiceoriginal nodupkey;by PayerClaimControlNumber LineCounter ;
run;
***End;


***DO: Calculate claim spending, delete denied claims lines, FY/CY;

* claim type;
data temp1;
set APCD.Hospiceoriginal ;

    if Paid =. then Paid=0;
	if Copay =. then Copay=0;
	if Coinsurance=. then Coinsurance=0;
	if Deductible=. then Deductible=0;
	if Allowed=. then Allowed=0;

	spending=Paid +Copay +Coinsurance +Deductible ;

	if DeniedFlag ne '1' and claimlinetype not in ('B','V') AND Allowed>=0 and paid>=0 and deductible>=0 and copay>=0 and coinsurance>=0 ;
	if spending>=0;

    date1=datepart(DateOfServiceFrom);date2=datepart(DateOfServiceTo);
	los=max(date2-date1,1);
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
		else if date1>='01oct2009'd and date1<='30sep2010'd then FY=2010;

		if date1>='01jan2011'd and date1<='31dec2011'd then CY=2011;
		else if date1>='01jan2012'd and date1<='31dec2012'd then CY=2012;
		else if date1>='01jan2013'd and date1<='31dec2013'd then CY=2013;
		else if date1>='01jan2010'd and date1<='31dec2010'd then CY=2010;
    end;
	if FY in (2011,2012,2013) ;
     

proc freq ;table FY CY RevenueCode /missing;
run;

***End;

*2010;
%let rhc_rate_2010 = 142.91 ; *p. 3, http://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNMattersArticles/Downloads/MM6606.pdf;
%let chc_rate_2010 =  34.75 ; *p. 3, http://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNMattersArticles/Downloads/MM6606.pdf;
%let irc_rate_2010 = 147.83 ; *p. 3, http://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNMattersArticles/Downloads/MM6606.pdf;
%let gic_rate_2010 = 635.74 ; *p. 3, http://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNMattersArticles/Downloads/MM6606.pdf;

*2011;
%let rhc_rate_2011 = 146.63 ; *p. 2, http://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNMattersArticles/Downloads/MM7077.pdf;
%let chc_rate_2011 =  35.66 ; *p. 2, http://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNMattersArticles/Downloads/MM7077.pdf;
%let irc_rate_2011 = 151.67 ; *p. 2, http://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNMattersArticles/Downloads/MM7077.pdf;
%let gic_rate_2011 = 652.27 ; *p. 2, http://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNMattersArticles/Downloads/MM7077.pdf;

*2012;
%let rhc_rate_2012 = 151.03 ; *p. 2, http://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNMattersArticles/Downloads/MM7518.pdf;
%let chc_rate_2012 =  36.73 ; *p. 2, http://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNMattersArticles/Downloads/MM7518.pdf;
%let irc_rate_2012 = 156.22 ; *p. 2, http://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNMattersArticles/Downloads/MM7518.pdf;
%let gic_rate_2012 = 671.84 ; *p. 2, http://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNMattersArticles/Downloads/MM7518.pdf;

*2013;
%let rhc_rate_2013 = 153.45 ; *p. 3, http://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNMattersArticles/Downloads/MM7857.pdf;
%let chc_rate_2013 =  37.32 ; *p. 3, http://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNMattersArticles/Downloads/MM7857.pdf;
%let irc_rate_2013 = 158.72 ; *p. 3, http://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNMattersArticles/Downloads/MM7857.pdf;
%let gic_rate_2013 = 682.59 ; *p. 3, http://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNMattersArticles/Downloads/MM7857.pdf;

* claim line is at day-level;
data apcd.Hospicestdcost;
length type $50.;
set temp1;

if revenuecode in ('0652') then do;
	type='continuous home care'; 
	if CY=2010 then stdcost=&chc_rate_2010.*quantity;
	else if CY=2011 then stdcost=&chc_rate_2011.*quantity;
    else if CY=2012 then stdcost=&chc_rate_2012.*quantity;
	else if CY=2013 then stdcost=&chc_rate_2013.*quantity;
	
end;
 
else if revenuecode in ('0651') then do;
	type='routine home care' ;
	if CY=2010 then stdcost=&rhc_rate_2010.*los;
	else if CY=2011 then stdcost=&rhc_rate_2011.*los;
    else if CY=2012 then stdcost=&rhc_rate_2012.*los;
	else if CY=2013 then stdcost=&rhc_rate_2013.*los;
end;
else if revenuecode in ('0655') then do;
	type='inpatient respite care';
	if CY=2010 then stdcost=&irc_rate_2010.*los;
	else if CY=2011 then stdcost=&irc_rate_2011.*los;
    else if CY=2012 then stdcost=&irc_rate_2012.*los;
	else if CY=2013 then stdcost=&irc_rate_2013.*los;
end;

else if revenuecode in ('0656') then do;
	type='general inpatient care';
	if CY=2010 then stdcost=&gic_rate_2010.*los;
	else if CY=2011 then stdcost=&gic_rate_2011.*los;
    else if CY=2012 then stdcost=&gic_rate_2012.*los;
	else if CY=2013 then stdcost=&gic_rate_2013.*los;
end;

else if revenuecode in ('0657') then do;
	type='services by physcian or nurse practitioner';
	stdcost=spending;
end;

else do;
type='Others';
stdcost=spending;
end;

 
run;

 
