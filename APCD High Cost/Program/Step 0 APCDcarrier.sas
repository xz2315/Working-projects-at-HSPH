*******************************
APCD Professional Claims
Xiner Zhou
2/23/2016
******************************;
libname APCD 'C:\data\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';


***DO: select professional claims;
proc sql;
create table temp1 as
select MemberLinkEID, MemberDateofBirth as DOB, Standardized_MemberZIPCode as MemberZIP, Standardized_MemberZIPFirst3 as MemberZIP3,
MemberGenderCleaned as gender, Standardized_MemberStateorProvin as MemberState, Standardized_MemberCounty as MemberCounty, 

NationalServiceProviderIDCleaned as ServiceProviderNPI,ServiceProviderSpecialty, 
Standardized_ServiceProviderStat as ServiceProviderState, Standardized_ServiceProviderCoun as ServiceProviderCounty,Standardized_ServiceProviderCity as ServiceProviderCity,
Standardized_ServiceProviderZIPC as ServiceProviderZIP,
ServiceProviderNumber_Linkage_ID as ServiceProviderLink, ServiceProviderTaxIDNumber as ServiceProviderTaxID, PCPIndicator,

OrgID, MedicaidIndicator, 

TypeOfClaimCleaned as TypeOfClaim, TypeofBillOnFacilityClaims as TypeofBill, SiteofServiceOnNSFCMS1500ClaimsC as PlaceofService,
PayerClaimControlNumber,LineCounter,VersionNumber, ClaimStatus, ClaimLineType,

AdmissionDate,DischargeDate, DateofServiceFrom,DateofServiceTo, CoveredDays, NonCoveredDays, 
AdmissionType, AdmissionSource, DischargeStatus, 
RevenueCodeCleaned as RevenueCode,

ProcedureCodeCleaned as HCPCS, ProcedureCodeType, Quantity, ProcedureModifier1 as Modifier1, ProcedureModifier2 as Modifier2, ProcedureModifier3 as Modifier3,ProcedureModifier4 as Modifier4,
ICD9CMProcedureCodeCleaned as ICD9Procedure,OtherICD9CMProcedureCode1Cleaned as OtherICD9Procedure1, OtherICD9CMProcedureCode2Cleaned as OtherICD9Procedure2, 
OtherICD9CMProcedureCode3Cleaned as OtherICD9Procedure3, OtherICD9CMProcedureCode4Cleaned as OtherICD9Procedure4, 
OtherICD9CMProcedureCode5Cleaned as OtherICD9Procedure5, OtherICD9CMProcedureCode6Cleaned as OtherICD9Procedure6, 

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
where TypeOfClaimCleaned='001' ;
quit;

***End;


***DO:Keep the latest line version;

data temp2;
	set temp1;
	if memberlinkeid ne .;	
     
proc sort;by PayerClaimControlNumber LineCounter descending VersionNumber;
run;
proc sort data=temp2 out=APCD.Carrieroriginal nodupkey;by PayerClaimControlNumber LineCounter ;
run;
***End;



***DO: Calculate claim spending, delete denied claims lines, FY/CY;

* claim type;
data temp1;
set APCD.Carrieroriginal ;

    if Paid =. then Paid=0;
	if Copay =. then Copay=0;
	if Coinsurance=. then Coinsurance=0;
	if Deductible=. then Deductible=0;
	if Allowed=. then Allowed=0;

	spending=Paid +Copay +Coinsurance +Deductible ;

	if DeniedFlag ne '1' and claimlinetype not in ('B','V') AND Allowed>=0 and paid>=0 and deductible>=0 and copay>=0 and coinsurance>=0 ;
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


if Modifier1='TC' or Modifier2='TC' or Modifier3='TC' or Modifier4='TC' then Modifier='TC';
else if Modifier1='26' or Modifier2='26' or Modifier3='26' or Modifier4='26' then Modifier='26';
else Modifier='';

run;

***End;
 
/*
***DO:Merge with AHA to get ServiceProvider and BillProvider's ProviderNumber and ZIP;
proc sql;
create table temp2 as
select a.*,b.provider as ServiceProviderNumber,b.ZIP as ServiceProviderZIPAHA
from temp1 a left join apcd.npi b
on a.ServiceProviderNPI=b.NPI;
quit;
proc sql;drop table temp1;quit;

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
create table temp6 as
select a.*,b.CBSA
from temp4 a left join ZIPtoCBSA b
on a.ZIP=b.ZIP and a.FY=b.FY;
quit;
proc sql;drop table temp4;quit;

*Wage index;
proc import datafile="C:\data\Projects\APCD High Cost\Archieve\IPPSWageIndexUrban" dbms=xlsx out=OPPSWageIndexUrban replace;getnames=yes;run;
proc import datafile="C:\data\Projects\APCD High Cost\Archieve\IPPSWageIndexRural" dbms=xlsx out=OPPSWageIndexRural replace;getnames=yes;run;

proc sql;
create table temp7 as
select a.*,b.WI as WI1
from temp6 a left join OPPSWageIndexUrban b
on a.FY=b.FY and a.CBSA=b.CBSA ;
quit;
proc sql;drop table temp6;quit;

data temp8;
set temp7;
temp=substr(CBSA,1,2);
run;
proc sql;drop table temp7;quit;

proc sql;
create table temp9 as
select a.*,b.WI as WI2
from temp8 a left join OPPSWageIndexRural b
on a.FY=b.FY and a.temp=b.CBSA  ;
quit;
proc sql;drop table temp8;quit;

data temp10;
set temp9;
if WI1 ne . then WI=WI1;else if WI2 ne . then WI=WI2;else WI=1;
drop WI1 WI2 temp;
run;
proc sql;drop table temp9;quit;
***End;
*/


***Import Fee Schedules;

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

 
***Do: link other fee scheules to claims;
proc sql;
create table temp11 as
select a.*,b.Labrate
from temp1 a left join LabFS b
on a.HCPCS=b.HCPCS and a.CY=b.CY;
quit;
proc sql;drop table temp1;quit;

proc sql;
create table temp12 as
select a.*,b.Facilityrate,b.nonFacilityrate
from temp11 a left join PhysicianFS b
on a.HCPCS=b.HCPCS and a.CY=b.CY  and a.Modifier=b.Modifier;
quit;
proc sql;drop table temp11;quit;

proc sql;
create table temp13 as
select a.*,b.BaseUnit
from temp12 a left join AnesthesiaFS b
on a.HCPCS=b.HCPCS and a.CY=b.CY;
quit;
proc sql;drop table temp12;quit;

proc sql;
create table temp14 as
select a.*,b.AmbulanceRate
from temp13 a left join AmbulanceFS b
on a.HCPCS=b.HCPCS and a.CY=b.CY;
quit;
proc sql;drop table temp13;quit;

proc sql;
create table temp15 as
select a.*,b.DMEPOSRate
from temp14 a left join DMEPOSFS b
on a.HCPCS=b.HCPCS and a.CY=b.CY ;
quit;
proc sql;drop table temp14;quit;
 

* Unit issue: Medically Unlikely Edits (MUEs);
proc import datafile="C:\data\Projects\APCD High Cost\Archieve\PractitionerMUE" dbms=xlsx out=MUE replace;getnames=yes;run;
proc sql;
create table temp16 as
select a.*,b.MUE
from temp15 a left join MUE b
on a.HCPCS=b.HCPCS ;
quit;
proc sql;drop table temp15;quit;




data APCD.CarrierstdcostCY2012;
length method $30.;
set temp16;

if MUE=. then unit=quantity; else unit=min(MUE,quantity);
 
if  BaseUnit ne . then do;
	method="Anesthesia services";
    if modifier1 in ('AD') then baseunit=min(baseunit,4);
	if CY=2011 or CY=2010 then CF=21.0971;
	if CY=2012 then CF=21.5200;
	if CY=2013 then CF=21.9243;
	if Modifier1 in ('QK','QX','QY') then stdcost=CF*(baseunit+unit)*0.5;
	else stdcost=CF*(baseunit+unit);

end;
 
else if Facilityrate ne . then  do;
	method="Physician Services";
	if PlaceofService in ('21','22','23','24','26','31','34','41','42','51','52','53','56','61') then stdcost=Facilityrate*unit;
	else stdcost=nonFacilityrate*unit;
end;

else if  Labrate ne . then do;
	method='Clinical Lab Services';
	if HCPCS in ('82040', '82247', '82248', '82310', '82330','82374', '82435', '82465', '82550', '82565', '82947', '82977', '83165', '84075', '84100',
				'84132', '84155', '84295', '84450', '84460', '84478', '84520', '84550', '80047', '80048','80051', '80053','80061', '80069', '80076') then stdcost=allowed;
	else stdcost=Labrate*unit;
end;

else if DMEPOSRate ne . then do;
	method="DMEPOS";
	stdcost=DMEPOSRate;
end;

else if AmbulanceRate ne . then do;
	method="Ambulance";
	stdcost=AmbulanceRate;
end;

else do;
	method="Other non-institutional claims";
	stdcost=spending;
end;

diff=spending-stdcost;

drop MUE CF Labrate Facilityrate nonFacilityrate BaseUnit AmbulanceRate DMEPOSRate;
run;
 

***End;
  
