*******************************
APCD Outpatient claim lines
Xiner Zhou
2/23/2016
******************************;
libname APCD 'C:\data\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';

 
/*
Bill Type Code
011X Hospital Inpatient (Part A)
012X Hospital Inpatient Part B
013X Hospital Outpatient
014X Hospital Other Part B
018X Hospital Swing Bed
021X SNF Inpatient
022X SNF Inpatient Part B
023X SNF Outpatient
028X SNF Swing Bed
032X Home Health
033X Home Health
034X Home Health (Part B Only)
041X Religious Nonmedical Health Care
Institutions
071X Clinical Rural Health
072X Clinic ESRD
073X Federally Qualified Health Centers
074X Clinic OPT
075X Clinic CORF
076X Community Mental Health Centers
081X Nonhospital based hospice
082X Hospital based hospice
083X Hospital Outpatient (ASC)
085X Critical Access Hospital 
*/


/* Inpatient 
11 41 -- Hospital inpatient, Religious Nonmedical (Hospital) inpatient
*/

/* Outpatient 
12--Services Provided By Hospitals to Inpatients without Part A Coverage or With Exhausted Part A Coverage 

13--Hospital Outpatient Prospective Payment System

14--Services Provided By Hospitals to 哲on-Patients・


71 73 --Rural Health Clinic (RHC) or Federally Qualified Health Center (FQHC) 
74 75--Comprehensive Outpatient Rehabilitation Facility (CORF) and Outpatient Rehabilitation Facility (ORF) 
76--Clinic-Community Mental Health Center (CMHC)
 
72--Renal Dialysis Facility 
83 --Other Claim Type 40 Services 
85-Critical Access Hospital ・Hospital Outpatient Services

*/

/*SNF
18 --Hospital Swing Beds
21 -- SNF inpatient
22 --for beneficiaries without Part A or who have exhausted their coverage
23 --outpatient services provided by SNFs
28 -- SNF Swing Beds
*/

/* HHA
32 33 - HHA under Part B, HHA outpatient

34 -- HHA's Other health service (diagnostic clinical laboratory services)
*/

/*Hospice
81 82 -- Hospice hospital-based and non-hosital based
*/




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
from APCD.Medical(encoding='asciiany') 
where TypeOfClaimCleaned='002' and TypeofBillOnFacilityClaims in ('12','13','14','71','72','73','74','75','76','83','85');
quit;

***End;


***DO:Keep the latest line version;

data temp2;
	set temp1;
	if memberlinkeid ne .;	
     
proc sort;by PayerClaimControlNumber LineCounter descending VersionNumber;
run;
proc sort data=temp2 out=APCD.OPoriginal nodupkey;by PayerClaimControlNumber LineCounter ;
run;
***End;


***DO: Calculate claim spending, delete denied claims lines, define outpatient types, FY/CY;

* claim type;
data temp1;
length type $100.;
set APCD.OPoriginal ;

  if Paid =. then Paid=0;
	if Copay =. then Copay=0;
	if Coinsurance=. then Coinsurance=0;
	if Deductible=. then Deductible=0;
	if Allowed=. then Allowed=0;

	
    *use spending not allowed, allowed would *100; 
	spending=Paid +Copay +Coinsurance +Deductible ;

	if DeniedFlag ne '1' and claimlinetype not in ('B','V') AND allowed>=0 and paid>=0 and deductible>=0 and copay>=0 and coinsurance>=0 ;
	if quantity=. or quantity>=0;

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
		else if date2>='01oct2009'd and date2<='30sep2010'd then FY=2010;

		if date1>='01jan2011'd and date1<='31dec2011'd then CY=2011;
		else if date1>='01jan2012'd and date1<='31dec2012'd then CY=2012;
		else if date1>='01jan2013'd and date1<='31dec2013'd then CY=2013;
		else if date2>='01jan2010'd and date2<='31dec2010'd then CY=2010;
    end;
	if CY in (2012) ;
     
if TypeofBill in ('12') then  type='Services Provided By Hospitals to Inpatients'; 
else if TypeofBill in ('13') then  type='Hospital Outpatient'; 
else if TypeofBill in ('14') then  type='Services Provided By Hospitals to Non-Patients';  
else if TypeofBill in ('71','73') then  type='Rural Health Clinic (RHC) or Federally Qualified Health Center (FQHC)';  
else if TypeofBill in ('72') then type='Renal Dialysis Facility';  
else if TypeofBill in ('74','75') then  type='Comprehensive Outpatient Rehabilitation Facility (CORF) and Outpatient Rehabilitation Facility (ORF)';  
else if TypeofBill in ('76')  then  type='Community Mental Health Center (CMHC)'; 
else if TypeofBill in ('83') then  type='Other Outpatient';  
else if TypeofBill in ('85') then  type='Critical Access Hospital ・Hospital Outpatient Services';  

if Modifier1='TC' or Modifier2='TC' or Modifier3='TC' or Modifier4='TC' then Modifier='TC';
else if Modifier1='26' or Modifier2='26' or Modifier3='26' or Modifier4='26' then Modifier='26';
else Modifier='';
drop Modifier1 Modifier2 Modifier3 Modifier4;


run;
***End;

***Import Fee Schedules;
* import APC;
proc import datafile="C:\data\Projects\APCD High Cost\Archieve\APC" dbms=xls out=APC replace;getnames=yes;run;

data APCpart HCPCSpart;
set APC;
if HCPCS='' then output APCpart;
else output HCPCSpart;
run;

data APCpart;
set APCpart;
keep APC  APCTitle SI rate weight national_unadj_copay min_unadj_copay CY;
run;
data HCPCSpart;
set HCPCSpart;
keep HCPCS HCPCSTitle APC CY;
run;
proc sql;
create table APC as
select a.*,b.*
from HCPCSpart a left join APCpart b
on a.APC=b.APC and a.CY=b.CY;
quit;

* import LABFS;
proc import datafile="C:\data\Projects\APCD High Cost\Archieve\LabFS" dbms=xlsx out=LabFS replace;getnames=yes;run;
* Import PhysicianFS;
proc import datafile="C:\data\Projects\APCD High Cost\Archieve\PhysicianFS" dbms=xlsx out=PhysicianFS replace;getnames=yes;run;
* Import AnesthesiaFS;
proc import datafile="C:\data\Projects\APCD High Cost\Archieve\AnesthesiaFS" dbms=xlsx out=AnesthesiaFS replace;getnames=yes;run;
* import AmbulanceFS;
proc import datafile="C:\data\Projects\APCD High Cost\Archieve\AmbulanceFS" dbms=xlsx out=AmbulanceFS replace;getnames=yes;run;
* import DMEPOS;
proc import datafile="C:\data\Projects\APCD High Cost\Archieve\DMEPOSFS" dbms=xlsx out=DMEPOSFS replace;getnames=yes;run;
proc sort data=DMEPOSFS nodupkey;by HCPCS CY;run;

 
***End;

 
/*

***DO:Merge with AHA to get ServiceProvider and BillProvider's ProviderNumber and ZIP;
proc sql;
create table temp2 as
select a.*,b.provider as ServiceProviderNumber,b.ZIP as ServiceProviderZIPAHA
from Data7173 a left join apcd.npi b
on a.ServiceProviderNPI=b.NPI;
quit;

proc sql;
create table temp3 as
select a.*,b.provider as BillProviderNumber,b.ZIP as BillProviderZIPAHA
from temp2 a left join apcd.npi b
on a.BillNPI=b.NPI;
quit;

proc sql;drop table temp2;quit;
***End;


***DO: Define final providerZIP sources above;
data temp4;
set temp3;
if ServiceProviderZIPAHA ne '' then ZIP=ServiceProviderZIPAHA;
else if BillProviderZIPAHA ne '' then ZIP=BillProviderZIPAHA;
else ZIP=ServiceProviderZIP;
label ZIP='Service Provider ZIP from ProviderFile or AHA or ClaimSelf';
drop  BillProviderZIPAHA ServiceProviderZIPAHA  ServiceProviderZIP;
run;

proc sql;drop table temp3;quit;
***End;


***Do: Wage Index is defined by CBSA;
* CBSA;
proc import datafile="C:\data\Projects\APCD High Cost\Archieve\ZIPtoCBSAFY2011" dbms=xlsx out=ZIPtoCBSAFY2011 replace;getnames=yes;run;
proc import datafile="C:\data\Projects\APCD High Cost\Archieve\ZIPtoCBSAFY2012" dbms=xlsx out=ZIPtoCBSAFY2012 replace;getnames=yes;run;
proc import datafile="C:\data\Projects\APCD High Cost\Archieve\ZIPtoCBSAFY2013" dbms=xlsx out=ZIPtoCBSAFY2013 replace;getnames=yes;run;
data ZIPtoCBSA;
set ZIPtoCBSAFY2011(in=in2011) ZIPtoCBSAFY2012(in=in2012) ZIPtoCBSAFY2013(in=in2013);
if in2011 then FY=2011;
if in2012 then FY=2012;
if in2013 then FY=2013;
run; 
proc sql;
create table temp5 as
select a.*,b.CBSA
from temp4 a left join ZIPtoCBSA b
on a.ZIP=b.ZIP and a.FY=b.FY;
quit;

proc sql;drop table temp4;quit;

*Wage index;
proc import datafile="C:\data\Projects\APCD High Cost\Archieve\IPPSWageIndexUrban" dbms=xlsx out=OPPSWageIndexUrban replace;getnames=yes;run;
proc import datafile="C:\data\Projects\APCD High Cost\Archieve\IPPSWageIndexRural" dbms=xlsx out=OPPSWageIndexRural replace;getnames=yes;run;

proc sql;
create table temp6 as
select a.*,b.WI as WI1
from temp5 a left join OPPSWageIndexUrban b
on a.FY=b.FY and a.CBSA=b.CBSA ;
quit;

proc sql;drop table temp5;quit;

data temp7;
set temp6;
temp=substr(CBSA,1,2);
run;

proc sql;drop table temp6;quit;

proc sql;
create table temp8 as
select a.*,b.WI as WI2
from temp7 a left join OPPSWageIndexRural b
on a.FY=b.FY and a.temp=b.CBSA  ;
quit;

proc sql;drop table temp7;quit;

data temp9;
set temp8;
if WI1 ne . then WI=WI1;else if WI2 ne . then WI=WI2;else WI=1;
drop WI1 WI2 temp;
run;
proc sql;drop table temp8;quit;
*/

* Unit issue: Medically Unlikely Edits (MUEs);
proc import datafile="C:\data\Projects\APCD High Cost\Archieve\OutpatientHospitalMUE" dbms=xlsx out=MUE replace;getnames=yes;run;
proc sql;
create table temp2 as
select a.*,b.MUE
from temp1 a left join MUE b
on a.HCPCS=b.HCPCS ;
quit;
proc sql;drop table temp1;quit;



***End;

***DO: Standardization for Hospital Outpatient Prospective Payment System ;

* link APC(OPPS) to claims;

proc sql;
create table temp3 as
select a.*, b.rate as APCrate 
from temp2 a left join APC b
on a.HCPCS=b.HCPCS and a.CY=b.CY;
quit;

proc sql;drop table temp2;quit;

* link other fee scheules to claims;
proc sql;
create table temp4 as
select a.*,b.Labrate
from temp3 a left join LabFS b
on a.HCPCS=b.HCPCS and a.CY=b.CY;
quit;
proc sql;drop table temp3;quit;

proc sql;
create table temp5 as
select a.*,b.Facilityrate,b.nonFacilityrate
from temp4 a left join PhysicianFS b
on a.HCPCS=b.HCPCS and a.CY=b.CY and a.Modifier=b.Modifier;
quit;
proc sql;drop table temp4;quit;

proc sql;
create table temp6 as
select a.*,b.BaseUnit
from temp5 a left join AnesthesiaFS b
on a.HCPCS=b.HCPCS and a.CY=b.CY;
quit;
proc sql;drop table temp5;quit;

proc sql;
create table temp7 as
select a.*,b.AmbulanceRate
from temp6 a left join AmbulanceFS b
on a.HCPCS=b.HCPCS and a.CY=b.CY;
quit;
proc sql;drop table temp6;quit;

proc sql;
create table temp8 as
select a.*,b.DMEPOSRate
from temp7 a left join DMEPOSFS b
on a.HCPCS=b.HCPCS and a.CY=b.CY ;
quit;
proc sql;drop table temp7;quit;




data APCD.OPstdcostCY2012;
set temp8;

if MUE=. then unit=quantity; else unit=min(MUE,quantity);


if type in ('Rural Health Clinic (RHC) or Federally Qualified Health Center (FQHC)') then do;
 	stdcost=spending;
end;


if type in ('Comprehensive Outpatient Rehabilitation Facility (CORF) and Outpatient Rehabilitation Facility (ORF)') then do;
 	if facilityrate ne . then stdcost=facilityrate*unit;
	else stdcost=spending;
end;


if type in ('Renal Dialysis Facility') then do;
 stdcost=spending;
end;



if type in ('Hospital Outpatient','Community Mental Health Center (CMHC)','Critical Access Hospital ・Hospital Outpatient Services','Services Provided By Hospitals to Inpatients') then do;


if APC ne '' then stdcost=APCrate*unit;


else if BaseUnit ne . then do;
		if modifier in ('AD') then baseunit=min(baseunit,4);
		if CY=2011 or CY=2010 then CF=21.0971;
		if CY=2012 then CF=21.5200;
		if CY=2013 then CF=21.9243;

		if Modifier in ('QK','QX','QY') then stdcost=CF*(baseunit+unit)*0.5;
		else stdcost=CF*(baseunit+unit);
end;

else if Facilityrate ne . then  stdcost=Facilityrate*unit;
	 
else if  Labrate ne . then do;
		if HCPCS in ('82040', '82247', '82248', '82310', '82330','82374', '82435', '82465', '82550', '82565', '82947', '82977', '83165', '84075', '84100',
				'84132', '84155', '84295', '84450', '84460', '84478', '84520', '84550', '80047', '80048','80051', '80053','80061', '80069', '80076') then stdcost=allowed;
		else stdcost=Labrate*unit;
end;
	 
else if AmbulanceRate ne . then stdcost=AmbulanceRate;
	 
else if DMEPOSRate ne . then stdcost=DMEPOSRate*unit;
	 
else stdcost=spending;


end;
 
if type in ('Services Provided By Hospitals to Non-Patients') then do;
 	if LabRate ne . then stdcost=Labrate*unit;
	else stdcost=spending;
end;

 
if type in ('Other Outpatient') then do;
 stdcost=spending;
end;

if quantity=. or quantity=0 then stdcost=spending;

diff=spending-stdcost;

drop MUE APCrate CF Labrate Facilityrate nonFacilityrate BaseUnit AmbulanceRate DMEPOSRate;
run;

***End;
 
