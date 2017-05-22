*******************************
APCD Inpatient claim lines
Xiner Zhou
2/23/2016
******************************;
libname APCD 'C:\data\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';
libname grouper 'C:\data\Data\MSDRG_Software';

 
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
12 13 14 -- Hospital based/ip/HH visits under Part B, Outpatient, Other health service (diagnostic clinical laboratory services)
22 23 -- SNF under Part B, SNF outpatient
34 -- HHA's Other health service (diagnostic clinical laboratory services)
71 72 73 74 75 76 77 --Clinic or hospital-based renal dialysis facility (except Free-standing provider based federally qualified health center)
83 85 --Ambulatory surgical center in hospital outpatient department, Critical Access Hospital 
*/

/*SNF
18 --Hospital Swing Beds
21 -- SNF inpatient
28 -- SNF Swing Beds
*/

/* HHA
32 33 - HHA under Part B, HHA outpatient
*/

/*Hospice
81 82 -- Hospice hospital-based and non-hosital based
*/



***Do: Select institutional inpatient claims with patientID, and keep the highest line version;

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
where TypeOfClaimCleaned='002' and TypeofBillOnFacilityClaims in ('11','41');
quit;

data temp2;
	set temp1;
	if memberlinkeid ne .;	
    
proc sort;by PayerClaimControlNumber LineCounter descending VersionNumber;
run;
proc sort data=temp2 out=APCD.IPoriginal nodupkey;by PayerClaimControlNumber LineCounter ;
run;

***End;


***Do: Prepare input dataset that meets the requirement of the DRGGrouper software;

*select 1 line per claim, since all the info for ip is the same(except payments);
proc sort data=APCD.IPoriginal  out=temp1 nodupkey;by PayerClaimControlNumber ;run;
 
*choose the right admission and discharge dates;
data temp2;
set temp1;   
	date1=datepart(AdmissionDate);date2=datepart(DischargeDate);los1=max(date2-date1,1);
	date3=datepart(DateOfServiceFrom);date4=datepart(DateOfServiceTo);los2=max(date4-date3,1);
    
	CoveredDays=abs(CoveredDays);
	losdiff1=abs(CoveredDays-LOS1);
	losdiff2=abs(CoveredDays-LOS2);

	if losdiff1<=losdiff2 then do;Admission=date1;Discharge=date2;end;
	else do;admission=date3;Discharge=date4;end;
	 
 	if discharge>='01oct2010'd and discharge<='30sep2011'd then FY=2011;
	else if discharge>='01oct2011'd and discharge<='30sep2012'd then FY=2012;
	else if discharge>='01oct2012'd and discharge<='30sep2013'd then FY=2013;

	if discharge>='01jan2011'd and discharge<='31dec2011'd then CY=2011;
		else if discharge>='01jan2012'd and discharge<='31dec2012'd then CY=2012;
		else if discharge>='01jan2013'd and discharge<='31dec2013'd then CY=2013;
		else if discharge>='01jan2010'd and discharge<='31dec2010'd then CY=2010;
    
	if FY in (2011,2012,2013);

	format Admission mmddyy10. Discharge mmddyy10. date1 mmddyy10. date2 mmddyy10. date3 mmddyy10. date4 mmddyy10.;
    keep FY Admission Discharge Date1 Date2 Date3 Date4 PayerClaimControlNumber;
run;

*Merge with original claim lines;
proc sql;
create table temp3 as
select a.*,b.*
from APCD.IPoriginal  a inner join temp2 b
on a.payerclaimcontrolnumber=b.payerclaimcontrolnumber;
quit;

*Merge with AHA data to get ProviderNumber and ZIPcode for both ServiceProvider and BillProvider;
proc sql;
create table temp4 as
select a.*,b.provider as ServiceProviderNumber,b.ZIP as ServiceProvideZIPAHA
from temp3 a left join apcd.npi b
on a.ServiceProviderNPI=b.NPI;
quit;

proc sql;
create table temp5 as
select a.*,b.provider as BillProviderNumber,b.ZIP as BillProvideZIPAHA
from temp4 a left join apcd.npi b
on a.BillNPI=b.NPI;
quit;

*Merge with member file to get MemberZIPCode and DOB;
proc sql;
create table temp6 as
select memberlinkeid, Standardized_MemberZIPCode, MemberDateofBirth
from apcd.Member 
where memberlinkeid ne .;
quit;
proc sort data=temp6 nodupkey;by memberlinkeid;run;

proc sql;
create table temp7 as
select a.*,b.*
from temp5 a left join temp6 b
on a.memberlinkeid=b.memberlinkeid;
quit;

*select MA patients only, clean MemberZIP/DOB/Age;
data apcd.IPFY3;
set temp7;

if MemberState in ('MA');

if MemberZIP = '' then MemberZIP=Standardized_MemberZIPCode;
if DOB=. then DOB=MemberDateOfBirth;
age=floor(yrdif(datepart(DOB), discharge, 'AGE'));

drop Standardized_MemberZIPCode MemberDateOfBirth;
run;
 

proc sort data=apcd.IPFY3 out=temp nodupkey;by PayerClaimControlNumber;run; 
 
* get Sex;
proc sql;
create table sex as
select MemberLinkEID, MemberGenderCleaned 
from APCD.Member 
where MemberLinkEID ne . ;
quit;
proc sort data=sex nodupkey;by MemberLinkEID;run;
data sex;
set sex;
if MemberGenderCleaned ='F' then sex=2;
else if MemberGenderCleaned ='M' then sex=1;
else sex=0;
run;

proc sql;
create table temp1 as
select a.*,b.*
from temp a left join sex b
on a.MemberLinkEID=b.MemberLinkEID;
quit;

data temp1;
set temp1;
Medical_record_number=left(_n_);
run;

data software;
format Patient_name $31. Medical_record_number $13. Account_number $17. Admit_date  mmddyy10. Discharge_date  mmddyy10.
Discharge_status $2. Primary_payer $2. LOS $5. Birth_date  mmddyy10.  Sex 1. Admit_diagnosis $7. Principal_diagnosis $8.
Secondary_diagnosis1 $8. Secondary_diagnosis2 $8. Secondary_diagnosis3 $8. Secondary_diagnosis4 $8. Secondary_diagnosis5 $8.
Secondary_diagnosis6 $8. Secondary_diagnosis7 $8. Secondary_diagnosis8 $8. Secondary_diagnosis9 $8. Secondary_diagnosis10 $8.
Secondary_diagnosis11 $8. Secondary_diagnosis12 $8.
Principal_Procedure $7. Secondary_Procedure1 $7. Secondary_Procedure2 $7. Secondary_Procedure3 $7. Secondary_Procedure4 $7.
Secondary_Procedure5 $7. Secondary_Procedure6 $7.
Procedure_date $10. Apply_HAC_logic $1. UNUSED $1.
Optional_information $72. Filler $25.;
set temp1;
 
LOS=max(1,discharge-admission);

Patient_name=left(MemberLinkEID);

Admit_date=Admission;format Admit_date mmddyy10.;
Discharge_date=Discharge;format Discharge_date mmddyy10.;

Primary_payer='01';
Birth_date=datepart(DOB);format Birth_date mmddyy10.;
sex=sex;
Admit_diagnosis=left(AdmissionDx);
Principal_diagnosis =left(PrincipalDX);
Secondary_diagnosis1=left(SecondaryDX1);
Secondary_diagnosis2=left(SecondaryDX2);
Secondary_diagnosis3=left(SecondaryDX3);
Secondary_diagnosis4=left(SecondaryDX4);
Secondary_diagnosis5=left(SecondaryDX5);
Secondary_diagnosis6=left(SecondaryDX6);
Secondary_diagnosis7=left(SecondaryDX7);
Secondary_diagnosis8=left(SecondaryDX8);
Secondary_diagnosis9=left(SecondaryDX9);
Secondary_diagnosis10=left(SecondaryDX10);
Secondary_diagnosis11=left(SecondaryDX11);
Secondary_diagnosis12=left(SecondaryDX12);


Principal_Procedure=left(ICD9Procedure);
Secondary_Procedure1=left(OtherICD9Procedure1);
Secondary_Procedure2=left(OtherICD9Procedure2);
Secondary_Procedure3=left(OtherICD9Procedure3);
Secondary_Procedure4=left(OtherICD9Procedure4);
Secondary_Procedure5=left(OtherICD9Procedure5);
Secondary_Procedure6=left(OtherICD9Procedure6);

Apply_HAC_logic='X';
if Dischargestatus in ('1','01','') then temp='01';
else if Dischargestatus in ('2','02') then temp='02';
else if Dischargestatus in ('3','03') then temp='03';
else if Dischargestatus in ('4','04') then temp='04';
else if Dischargestatus in ('5','05') then temp='05';
else if Dischargestatus in ('6','06') then temp='06';
else if Dischargestatus in ('7','07') then temp='07';
else if Dischargestatus in ('8','08') then temp='08';
else if Dischargestatus in ('9','09') then temp='09';
else temp=DischargeStatus;
/*
if temp not in ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','20',
'21','30','43','50','51','61','62','63','64','65','66','69','70','71','72','81','82','83','84','85','86','87','88','89',
'90','91','92','93','94','95');
*/
discharge_status=right(temp);
drop temp;
run;


 






data _null_;
set software;
file 'C:\data\Data\MSDRG_Software\ip.txt' LRECL=835 ;
put Patient_name 1-31 Medical_record_number 32-44 Account_number 45-61 Admit_date mmddyy10. Discharge_date mmddyy10.
Discharge_status 82-83 Primary_payer 84-85 LOS 86-90 Birth_date mmddyy10. Age 101-103 Sex 104-104 Admit_diagnosis 105-111 
Principal_diagnosis 112-119 Secondary_diagnosis1 120-127 Secondary_diagnosis2 128-135 Secondary_diagnosis3 136-143 
Secondary_diagnosis4 144-151 Secondary_diagnosis5 152-159 Secondary_diagnosis6 160-167 Secondary_diagnosis7 168-175
Secondary_diagnosis8 176-183 Secondary_diagnosis9 184-191 Secondary_diagnosis10 192-199 Secondary_diagnosis11 200-207 Secondary_diagnosis12 208-215
Principal_Procedure 312-318 Secondary_Procedure1 319-325  Secondary_Procedure2 326-332  Secondary_Procedure3 333-339  Secondary_Procedure4 340-346 
Secondary_Procedure5 347-353  Secondary_Procedure6 354-360 
Procedure_date 487-736 Apply_HAC_logic 737-737 UNUSED 738-738
Optional_information 739-810 Filler 811-835;
 
run;
***End;


***Do: Run software and output;
/*
mce -i "C:\data\Data\MSDRG_Software\ip.txt" -o "C:\data\Data\MSDRG_Software\output.txt"
mce -i "C:\data\Data\MSDRG_Software\ip.txt" -u "C:\data\Data\MSDRG_Software\upload.txt"

*/

data output;
  %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
  infile 'C:\data\Data\MSDRG_Software\upload.txt' MISSOVER  lrecl=1905 firstobs=1;

informat Patient_name $31.;
informat Medical_record_number $13.;
informat Account_number $17.;
informat Admit_date  mmddyy10. ;
informat Discharge_date  mmddyy10.;
informat Discharge_status $2. ;
informat Primary_payer $2.;
informat LOS best5. ;
informat Birth_date  mmddyy10.;
informat Age $3. ;
informat Sex 1.;
informat Admit_diagnosis $7. ;
informat Principal_diagnosis $8.;
informat Secondary_diagnosis1 $8. ;informat Secondary_diagnosis2 $8. ;informat Secondary_diagnosis3 $8. ;informat Secondary_diagnosis4 $8. ;informat Secondary_diagnosis5 $8. ;
informat Secondary_diagnosis6 $8. ;informat Secondary_diagnosis7 $8. ;informat Secondary_diagnosis8 $8. ;informat Secondary_diagnosis9 $8. ;informat Secondary_diagnosis10 $8. ;
informat Secondary_diagnosis11 $8. ;informat Secondary_diagnosis12 $8. ;
informat Principal_Procedure $7. ;
informat Secondary_Procedure1 $7.;informat Secondary_Procedure2 $7.;informat Secondary_Procedure3 $7.;
informat Secondary_Procedure4 $7.;informat Secondary_Procedure5 $7.;informat Secondary_Procedure6 $7.;
informat Procedure_date $10.;
informat Apply_HAC_logic $1. ;
informat UNUSED $1.;
informat Optional_information $72.;
informat Filler $25.;
informat Software_Version $3.;
informat Initial_DRG $3.;
informat Initial_SurgicalMedical $1.;
informat Final_MDC $2.;
informat Final_DRG $3.;
informat Final_SurgicalMedical $1.;
informat Note $2.;
informat Return_Code $4.;
informat Dx_Count $2.;
informat Proc_Count  $2.;
informat dx1_note1 $2.;
informat dx1_note2 $2.;
informat dx1_note3 $2.;
informat dx1_note4 $2.;
informat dx1_HAC_c1  $2.;
informat dx1_HAC_c2  $2.;
informat dx1_HAC_c3  $2.;
informat dx1_HAC_c4  $2.;
informat dx1_HAC_c5  $2.;
informat dx1_HAC_u1  $2.;
informat dx1_HAC_u2  $2.;
informat dx1_HAC_u3  $2.;
informat dx1_HAC_u4  $2.;
informat dx1_HAC_u5  $2.;

informat dx2_note1   $2.;
informat dx2_note2   $2.;
informat dx2_note3   $2.;
informat dx2_note4   $2.;
informat dx2_HAC_c1 $2.;
informat dx2_HAC_c2 $2.;
informat dx2_HAC_c3 $2.;
informat dx2_HAC_c4 $2.;
informat dx2_HAC_c5 $2.;
informat dx2_HAC_u1 $1.;
informat dx2_HAC_u2 $1.;
informat dx2_HAC_u3 $1.;
informat dx2_HAC_u4 $1.;
informat dx2_HAC_u5 $1.;
informat Proc_note1 $2.;
informat Proc_note2 $2.;
informat Proc_note3 $2.;
informat Proc_note4 $2.;
informat Proc_HAC_c1  $2.;
informat Proc_HAC_c2  $2.;
informat Proc_HAC_c3  $2.;
informat Proc_HAC_c4  $2.;
informat Proc_HAC_c5  $2.;
informat Initial_DRG $4.;
informat Final_DRG $4.;
informat Final_DRG_CCMCC $1.;
informat Initial_DRG_CCMCC $1.;
informat Num_HAC $2.;
informat HAC_Status $1.;
informat Cost_Wt $7.;
informat NewLine $2.;
	 




format Admit_date  mmddyy10. ;
format Discharge_date  mmddyy10.;
format Birth_date  mmddyy10.;

input Patient_name 1-31 
	  Medical_record_number 32-44
      Account_number 45-61 
      Admit_date mmddyy10. 
      Discharge_date mmddyy10.
      Discharge_status 82-83 
      Primary_payer 84-85 
      LOS 86-90 
      Birth_date mmddyy10. 
      Age 101-103 
      Sex 104-104 
      Admit_diagnosis 105-111 
Principal_diagnosis 112-119 
Secondary_diagnosis1 120-127 
Secondary_diagnosis2 128-135 
Secondary_diagnosis3 136-143 
Secondary_diagnosis4 144-151 
Secondary_diagnosis5 152-159 
Secondary_diagnosis6 160-167 
Secondary_diagnosis7 168-175
Secondary_diagnosis8 176-183 
Secondary_diagnosis9 184-191 
Secondary_diagnosis10 192-199 
Secondary_diagnosis11 200-207 
Secondary_diagnosis12 208-215
Principal_Procedure 312-318 
Secondary_Procedure1 319-325  
Secondary_Procedure2 326-332  
Secondary_Procedure3 333-339  
Secondary_Procedure4 340-346 
Secondary_Procedure5 347-353  
Secondary_Procedure6 354-360 
      Procedure_date 487-736 
      Apply_HAC_logic 737-737 
      UNUSED 738-738
      Optional_information 739-810 
      Filler 811-835
	  Software_Version 836-838
	  Initial_DRG 839-841
      Initial_SurgicalMedical 842-842 
	  Final_MDC 843-844
	  Final_DRG 845-847
	  Final_SurgicalMedical 848-848
	  Note 849-850
	  Return_Code 851-854
	  Dx_Count 855-856
	  Proc_Count 857-858
	  dx1_note1 859-860
	  dx1_note2 861-862
	  dx1_note3 863-864
	  dx1_note4 865-866
	  dx1_HAC_c1 867-868
	  dx1_HAC_c2 869-870
	  dx1_HAC_c3 871-872
	  dx1_HAC_c4 873-874
	  dx1_HAC_c5 875-876
	  dx1_HAC_u1 877-877
	  dx1_HAC_u2 878-878
	  dx1_HAC_u3 879-879
	  dx1_HAC_u4 880-880
	  dx1_HAC_u5 881-881
	  dx2_note1   882-883
	  dx2_note2   884-885
	  dx2_note3   886-887
	  dx2_note4   888-889
      dx2_HAC_c1  1074-1075
	  dx2_HAC_c2  1076-1077
	  dx2_HAC_c3  1078-1079
	  dx2_HAC_c4  1080-1081
	  dx2_HAC_c5  1082-1083
	  dx2_HAC_u1  1314-1314
	  dx2_HAC_u2  1315-1315
	  dx2_HAC_u3  1316-1316
	  dx2_HAC_u4  1317-1317
	  dx2_HAC_u5  1318-1318
      Proc_note1 1434-1435
	  Proc_note2 1436-1437
	  Proc_note3 1438-1439
	  Proc_note4 1440-1441
      Proc_HAC_c1  1634-1635
	  Proc_HAC_c2  1636-1637
	  Proc_HAC_c3  1638-1639
	  Proc_HAC_c4  1640-1641
	  Proc_HAC_c5  1642-1643
	  Initial_DRG 1884-1887
	  Final_DRG 1888-1891
      Final_DRG_CCMCC 1892-1892
	  Initial_DRG_CCMCC 1893-1893
      Num_HAC 1894-1895
	  HAC_Status 1896-1896
	  Cost_Wt 1897-1903
      NewLine 1904-1905
	  ;

  if _ERROR_ then call symputx('_EFIERR_',1);  /*set ERROR detection macro variable*/
run;


data output;
set output;
keep Medical_record_number Final_DRG;
run;

proc sql;
create table temp2 as
select a.*,b.*
from temp1 a left join output b
on a.Medical_record_number=b.Medical_record_number;
quit;

data temp3;
set temp2;
keep MemberLinkEID PayerClaimControlNumber final_DRG;
run;

proc sql;
create table APCD.IPFY3DRG as
select a.*,b.*
from apcd.IPFY3 a left join temp3 b
on a.PayerClaimControlNumber=b.PayerClaimControlNumber;
quit;

***End;


***Do:Classification of hospital types, Delete Denied claims defined by negative payment or Void/Back out;

*Merge with Provider file;
data temp1;
set apcd.ipfy3DRG;
if BillProviderLink ne '' then link=BillProviderLink*1;
else link=ServiceProviderLink*1;
run;

proc sort data=APCD.provider  out=temp2 nodupkey;by orgid linkingproviderid;run;
data temp2;set temp2;orgidnum=orgid*1;run;

proc sql;
create table temp3 as
select a.*,b.taxonomy, b.Standardized_ZIPCode   
from temp1 a left join temp2 b
on a.orgid=b.orgidnum and a.Link=b.LinkingProviderID;
quit;

data temp30;
set temp3;
if Standardized_ZIPCode ne '' then ZIP=Standardized_ZIPCode ;
else if BillProvideZIPAHA ne '' then ZIP=BillProvideZIPAHA;
else if ServiceProvideZIPAHA ne '' then ZIP=ServiceProvideZIPAHA;
else ZIP=ServiceProviderZIP;label ZIP='Service Provider ZIP from ProviderFile or AHA or ClaimSelf';
drop Standardized_ZIPCode BillProvideZIPAHA ServiceProvideZIPAHA  ServiceProviderZIP;
run;

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
create table temp3 as
select a.*,b.CBSA
from temp30 a left join ZIPtoCBSA b
on a.ZIP=b.ZIP and a.FY=b.FY;
quit;


data temp4;
length type1 type2 type $50.;
set temp3;

if BillProviderNumber ne '' then provider=BillProviderNumber;
else provider=ServiceProviderNumber;

 /*define types of claims*/

  if substr(provider,3,1)='0' 
    then type1='Inpatient Hospital (Acute Hospital)';

  else if substr(provider,3,2)='13'
    then type1='Critical Access Hospital (CAH) - Inpatient Services';

  else if substr(provider,3,2) in ('40','41','42','43','44') or substr(provider,3,1) in ('M','S') 
    then type1='Inpatient Psychiatric Facility (IPF)';

  else if substr(provider,3,2) in ('20','21','22')
    then type1='Long-Term Care Hospital (LTCH)';

  else if '3025'<= substr(provider,3,4) <= '3099' or substr(provider,3,1) in ('R','T') 
    then type1='Inpatient Rehabilitation Facility (IRF)';

  else type1='Other Inpatient';

  if Taxonomy='282N00000X' then type2='Inpatient Hospital (Acute Hospital)';
  else if Taxonomy in('282NC0060X','261QC0050X') then type2='Critical Access Hospital (CAH) - Inpatient Services';
  else if  Taxonomy in ('283Q00000X','273R00000X') then type2='Inpatient Psychiatric Facility (IPF)';
  else if  Taxonomy='282E00000X' then type2='Long-Term Care Hospital (LTCH)';
  else if  Taxonomy in ('283X00000X','273Y00000X') then type2='Inpatient Rehabilitation Facility (IRF)';
  else type2='Other Inpatient';
   
  if type1 ne 'Other Inpatient' then type=type1;
  else  type=type2;


   if Paid =. then Paid=0;
	if Copay =. then Copay=0;
	if Coinsurance=. then Coinsurance=0;
	if Deductible=. then Deductible=0;
	if Allowed=. then Allowed=0;

	spending=Paid +Copay +Coinsurance +Deductible ;
	if DeniedFlag ne '1' and claimlinetype not in ('B','V') AND allowed>=0 and paid>=0 and deductible>=0 and copay>=0 and coinsurance>=0 ;
	 

	LOS=max(discharge-admission,1);
drop link  type1 type2  ; 
proc freq;tables  type;
run;

***End;

*****repetitive deductible;
proc sort data=temp4;by PayerClaimControlNumber LineCounter;run;
data All;
set temp4;
retain temp 0;
by PayerClaimControlNumber LineCounter;
if first.PayerClaimControlNumber=1 then temp=Deductible;
else do;
	if deductible=temp then deductible=0;
end;
drop temp;
run;


***Do: Standardization for Acute Hospital and CAH;
 
proc import datafile="C:\data\Projects\APCD High Cost\Archieve\AcuteCareDRG" dbms=xlsx out=DRG replace;
getnames=yes;
run;
 
proc sql;
create table temp1 as
select a.*,b.*
from All  a left join DRG  b
on a.final_drg=b.DRG and a.FY=b.FY
where type in ('Inpatient Hospital (Acute Hospital)','Critical Access Hospital (CAH) - Inpatient Service');
quit;
 

* Calculate standard allowed;
data temp2;
set temp1;

if final_drg ne '999' then do;

	*short-stay transfer;
 	if (los+1)<GMLOS and dischargestatus in ('02','2','66') and final_DRG ne '789' then do;
     		if FY=2011 then stdcost=min((420.01+5164.11)*weight,(420.01+5164.11)*weight*(LOS+1)/GMLOS);
		 	else if FY=2012 then stdcost=min((421.42+5209.74)*weight,(421.42+5209.74)*weight*(LOS+1)/GMLOS);
     		else if FY=2013 then stdcost=min((425.49+5348.76)*weight,(425.49+5348.76)*weight*(LOS+1)/GMLOS);
	  

 	end;

 	* short-stay PAC discharge;
 	else if (los+1)<GMLOS and dischargestatus in ('03','3','05','5','06','6','62','63','65') and PostAcute='Yes' then do;
      		 

			if specialpay='No' then do;*NO special pay;
     			if FY=2011 then stdcost=min((420.01+5164.11)*weight,(420.01+5164.11)*weight*(LOS+1)/GMLOS);
		 		else if FY=2012 then stdcost=min((421.42+5209.74)*weight,(421.42+5209.74)*weight*(LOS+1)/GMLOS);
     			else if FY=2013 then stdcost=min((425.49+5348.76)*weight,(425.49+5348.76)*weight*(LOS+1)/GMLOS);
	   		end;
	   		else	 do;*DRG special pay;
	        	ratio=0.5*(1+(LOS+1)/GMLOS);
     			if FY=2011 then stdcost=min((420.01+5164.11)*weight,(420.01+5164.11)*weight*ratio);
		 		else if FY=2012 then stdcost=min((421.42+5209.74)*weight,(421.42+5209.74)*weight*ratio);
     			else if FY=2013 then stdcost=min((425.49+5348.76)*weight,(425.49+5348.76)*weight*ratio);
	   		end;
     drop ratio;		 

 	end;

 	* normal;
 	else do;
		if FY=2011 then stdcost=(420.01+5164.11)*weight;
		else if FY=2012 then stdcost=(421.42+5209.74)*weight;
    	else if FY=2013 then stdcost=(425.49+5348.76)*weight;
	end;
end;

else stdcost=allowed;
 
*drop weight GMLOS SpecialPay PostAcute;
proc sort;by PayerClaimControlNumber LineCounter;
run;

data AcuteCare;
set temp2;
by PayerClaimControlNumber LineCounter;
if first.PayerClaimControlNumber=0 and final_drg ne '999' then stdcost=0;
run;

***End;


***Do: Standardization for LTCH;

* LTCH Wage Index;
proc import datafile="C:\data\Projects\APCD High Cost\Archieve\LTCHWageIndexUrban" dbms=xls out=LTCHWageIndexUrban replace;getnames=yes;run;
proc import datafile="C:\data\Projects\APCD High Cost\Archieve\LTCHWageIndexRural" dbms=xls out=LTCHWageIndexRural replace;getnames=yes;run;

proc sql;
create table tempLTCH1 as
select a.*,b.WI as WI1
from All a left join LTCHWageIndexUrban b
on a.FY=b.FY and a.CBSA=b.CBSA 
where a.type='Long-Term Care Hospital (LTCH)';
quit;

data tempLTCH1;
set tempLTCH1;
temp=substr(CBSA,1,2);
run;


proc sql;
create table tempLTCH2 as
select a.*,b.WI as WI2
from tempLTCH1 a left join LTCHWageIndexRural b
on a.FY=b.FY and a.temp=b.CBSA  ;
quit;

data temp2;
set tempLTCH2; 
DRGnum=final_DRG*1;
drop temp WI1 WI2;
if WI1 ne . then WI=WI1;else if WI2 ne . then WI=WI2;else WI=1;
run;

* DRG weight;
proc import datafile="C:\data\Projects\APCD High Cost\Archieve\LTCHDRG" dbms=xlsx out=LTCHDRG replace;getnames=yes;run;
proc sql;
create table temp3 as
select a.*,b.*
from temp2 a left join LTCHDRG  b
on a.DRGnum=b.DRG and a.FY=b.FY;
quit;



* Calculate standard allowed;
/*
FY2011 $39,599.95  75.271%
FY2012 $40,082.61  70.334%
FY2013 $40,397.96  63.096%

*/
data temp4;
set temp3;

 	* short-stay ;
 	if los<=(GMLOS*5/6)  then do;
		if FY=2011 then stdcost=spending/(0.75271*WI+(1-0.75271)); 
		else if FY=2012 then stdcost=spending/(0.70334*WI+(1-0.70334)); 
    	else if FY=2013 then stdcost=spending/(0.63096*WI+(1-0.63096)); 
	end;

	else do;
   		if FY=2011 then stdcost=39599.95*weight; 
		else if FY=2012 then stdcost=40222.05*weight; 
    	else if FY=2013 then stdcost=40397.96*weight; 
	end;

  
drop weight GMLOS DRGnum WI;
proc sort;by PayerClaimControlNumber LineCounter;
run;

data LTCH;
set temp4;
by PayerClaimControlNumber LineCounter;
if first.PayerClaimControlNumber=0 then stdcost=0;
run;
 

***End;


***Do:Standardization for Inpatient Psychiatric Facility (IPF);
data temp1;
set All ;

if  type ='Inpatient Psychiatric Facility (IPF)' ;

	perdayfactor1=1.19;perdayfactor2=1.12;perdayfactor3=1.08;perdayfactor4=1.05;perdayfactor5=1.04;
	perdayfactor6=1.02;perdayfactor7=1.01;perdayfactor8=1.01;perdayfactor9=1.00;perdayfactor10=1.00;
	perdayfactor11=0.99;perdayfactor12=0.99;perdayfactor13=0.99;perdayfactor14=0.99;perdayfactor15=0.98;
	perdayfactor16=0.97;perdayfactor17=0.97;perdayfactor18=0.96;perdayfactor19=0.95;perdayfactor20=0.95;
	perdayfactor21=0.95;perdayfactor22=0.92;

	array perdayfactor{22} perdayfactor1 perdayfactor2 perdayfactor3 perdayfactor4 perdayfactor5 
                       perdayfactor6 perdayfactor7 perdayfactor8 perdayfactor9 perdayfactor10 
					   perdayfactor11 perdayfactor12 perdayfactor13 perdayfactor14 perdayfactor15
					   perdayfactor16 perdayfactor17 perdayfactor18 perdayfactor19 perdayfactor20 
					   perdayfactor21 perdayfactor22  ;
	perday=0;
	do i=1 to LOS;
		if i>=22 then temp=perdayfactor{22};else temp=perdayfactor{i};
		perday=perday+temp;
	end;
 

	if final_drg ='056' then DRGfactor=1.05;
	else if final_drg ='080' then DRGfactor=1.07;
	else if final_drg ='876' then DRGfactor=1.22;
	else if final_drg ='880' then DRGfactor=1.05;
	else if final_drg ='881' then DRGfactor=0.99;
	else if final_drg ='882' then DRGfactor=1.02;
	else if final_drg ='883' then DRGfactor=1.02;
	else if final_drg ='884' then DRGfactor=1.03;
	else if final_drg ='885' then DRGfactor=1.00;
	else if final_drg ='886' then DRGfactor=0.99;
	else if final_drg ='887' then DRGfactor=0.92;
	else if final_drg ='894' then DRGfactor=0.97;
	else if final_drg ='895' then DRGfactor=1.02;
	else if final_drg ='896' then DRGfactor=0.98;
	else if final_drg ='897' then DRGfactor=0.98;
	else DRGfactor=1.00;

	if age<45 then agefactor=1.00;
	else if age>=45 and age<50 then agefactor=1.01;
	else if age>=50 and age<55 then agefactor=1.02;
	else if age>=55 and age<60 then agefactor=1.04;
	else if age>=60 and age<65 then agefactor=1.07;
	else if age>=65 and age<70 then agefactor=1.10;
	else if age>=70 and age<75 then agefactor=1.13;
	else if age>=75 and age<80 then agefactor=1.15;
	else if age>=80 then agefactor=1.17;

	array dx{14} $ PrincipalDx SecondaryDX1 SecondaryDX2 SecondaryDX3 SecondaryDX4 SecondaryDX5 SecondaryDX6 SecondaryDX7 SecondaryDX8 SecondaryDX9 SecondaryDX10 SecondaryDX11 SecondaryDX12 DischargeDX;
 
	array comorb{17} comorb1 comorb2 comorb3 comorb4 comorb5 comorb6 comorb7 comorb8 comorb9 comorb10 comorb11 comorb12 comorb13 comorb14 comorb15 comorb16 comorb17;

	do i=1 to 17;
		comorb{i}=1;
	end;

	do i=1 to 14;
		if dx{i} in ('317','3180','3181','3182','319') then comorb1=1.04;
		if dx{i} in ('2860','2861','2862','2863','2864') then comorb2=1.13;
		if dx{i} in ('51900','51901','51902','51903','51904','51905','51906','51907','51908','51909','V440') 
     	  	then comorb3=1.06;
		if dx{i} in ('5845','5846','5847','5848','5849','63630','63631','63632','63730','63731','63732','6383','6393','66932','66934','9585') 
			then comorb4=1.11; 
		if dx{i} in ('40301', '40311', '40391', '40402', '40412', '40413', '40492', '40493', '5853', '5854', '5855', '5856', '5859','586', 'V4511', 'V4512', 'V560', 'V561','V562') 
			then comorb5=1.11; 
		if dx{i}>='1400' and dx{i}<='2399' then comorb6=1.07; 
		if dx{i} in ('25002', '25003', '25012', '25013', '25022', '25023', '25032', '25033', '25042', '25043', '25052', '25053', '25062', '25063', '25072', '25073', 
               '25082', '25083', '25092','25093') 
			then comorb7=1.05; 
		if dx{i} in ('260','261','262') then comorb8=1.13; 
		if dx{i} in ('3071', '30750', '31203', '31233','31234') then comorb9=1.12; 
		if  '01000'<=dx{i}<='04110' or  dx{i}='042' or '04500'<=dx{i}<='05319' or '05440'<=dx{i}<='05449' or '0550'<=dx{i}<='0770' or '0782'<=dx{i}<='07889' 
			or '07950'<=dx{i}<='07959' 
			then comorb10=1.07; 
		if dx{i} in ('2910', '2920', '29212', '2922', '30300', '30400') then comorb11=1.03; 
		if dx{i} in ('3910', '3911', '3912', '40201', '40403', '4160', '4210', '4211', '4219') then comorb12=1.11; 
		if dx{i} in ('44024','7854') then comorb13=1.10;
		if dx{i} in ('49121', '4941', '5100', '51883', '51884', 'V4611', 'V4612', 'V4613','V4614') then comorb14=1.12;
		if dx{i} in ('56960','56961','56962','56963','56964','56965','56966','56967','56968','56969','9975','V441','V442','V443','V444','V445','V446') then comorb15=1.08;
		if dx{i} in ('6960','7100', '73000','73001','73002','73003','73004','73005','73006','73007','73008','73009','73010',
                 '73011','73012','73013','73014','73015','73016','73017','73018','73019','73020','73021','73022','73023',
                 '73024','73025','73026','73027','73028','73029') 
			then comorb16=1.09;
		if dx{i} in ('96500','96501','96502','96503','96504','96505','96506','96507','96508','96509', '9654') or 
                 '9670'<=dx{i}<='9699' or dx{i}='9770' or '9800'<=dx{i}<='9809' or '9830'<=dx{i}<='9839' or dx{i}='986' or '9890'<=dx{i}<='9897'  
			then comorb17=1.11;
	end;

	comorbidfactor=comorb1*comorb2*comorb3*comorb4*comorb5*comorb6*comorb7*comorb8*comorb9*comorb10*comorb11*comorb12*comorb13*comorb14*comorb15*comorb16*comorb17;

	*search federal per diem base rate on regulation;
	if FY=2011 then stdcost=665.71*DRGfactor*AgeFactor*comorbidfactor*perday;
	if FY=2012 then stdcost=685.01*DRGfactor*AgeFactor*comorbidfactor*perday;
	if FY=2013 then stdcost=698.51*DRGfactor*AgeFactor*comorbidfactor*perday;

	drop temp i 
	perdayfactor1 perdayfactor2 perdayfactor3 perdayfactor4 perdayfactor5 
	perdayfactor6 perdayfactor7 perdayfactor8 perdayfactor9 perdayfactor10 
	perdayfactor11 perdayfactor12 perdayfactor13 perdayfactor14 perdayfactor15
	perdayfactor16 perdayfactor17 perdayfactor18 perdayfactor19 perdayfactor20 
	perdayfactor21 perdayfactor22
	comorb1 comorb2 comorb3 comorb4 comorb5 comorb6 comorb7 comorb8 comorb9 
	comorb10 comorb11 comorb12 comorb13 comorb14 comorb15 comorb16 comorb17 

 DRGfactor AgeFactor comorbidfactor perday;
 
proc sort;by PayerClaimControlNumber LineCounter;
run;

data IPF;
set temp1;
by PayerClaimControlNumber LineCounter;
if first.PayerClaimControlNumber=0 then stdcost=0;
run;

***End;


***Do: Standardization for Inpatient Rehabilitation Facility (IRF) ;
data temp1;
set All;
if  type ='Inpatient Rehabilitation Facility (IRF)';
proc sort;by PayerClaimControlNumber Linecounter;
run;


*claim total spending;
proc sql;
create table temp2 as
select *,sum(spending) as tempspending 
from temp1
group by PayerClaimControlNumber;
quit;

data temp3;
set temp2;
stdcost=tempspending;
drop tempspending;
proc sort;by PayerClaimControlNumber LineCounter;
run;

data IRF;
set temp3;
by PayerClaimControlNumber LineCounter;
if first.PayerClaimControlNumber=0 then stdcost=0;
run;

***End;




***Do: Standardization for Other inpatient;
data temp1;
set All;

if  type ='Other Inpatient';

proc sort;by PayerClaimControlNumber Linecounter;
run;


*claim total spending;
proc sql;
create table temp11 as
select *,sum(spending) as tempspending 
from temp1
group by PayerClaimControlNumber;
quit;
   
* Wage Index;
proc import datafile="C:\data\Projects\APCD High Cost\Archieve\IPPSWageIndexUrban" dbms=xlsx out=IPPSWageIndexUrban replace;getnames=yes;run;
proc import datafile="C:\data\Projects\APCD High Cost\Archieve\IPPSWageIndexRural" dbms=xlsx out=IPPSWageIndexRural replace;getnames=yes;run;

proc sql;
create table temp2 as
select a.*,b.WI as WI1
from temp11 a left join IPPSWageIndexUrban b
on a.FY=b.FY and a.CBSA=b.CBSA ;
quit;

data temp2;
set temp2;
temp=substr(CBSA,1,2);
run;


proc sql;
create table temp3 as
select a.*,b.WI as WI2
from temp2 a left join IPPSWageIndexRural b
on a.FY=b.FY and a.temp=b.CBSA  ;
quit;

/*

*2011;
%let capital_2011 = 420.01 ;
%let operating_2011 = 5164.11 ;

%let lowwi_op_labor_2011 = 3552.91 ;
%let lowwi_op_nonlabor_2011 = 1611.20 ;

%let hiwi_op_labor_2011 = 3201.75 ;
%let hiwi_op_nonlabor_2011 = 1962.36 ;

*2012;
%let capital_2012 = 421.42 ;
%let operating_2012 = 5209.74 ;

%let lowwi_op_labor_2012 = 3230.04 ;
%let lowwi_op_nonlabor_2012 = 1979.7 ;

%let hiwi_op_labor_2012 = 3584.30 ;
%let hiwi_op_nonlabor_2012 = 1625.44 ;

*2013;
%let capital_2013 = 425.49 ;
%let operating_2013 = 5348.76 ;

%let lowwi_op_labor_2013 = 3316.23 ;
%let lowwi_op_nonlabor_2013 = 2032.53 ;

%let hiwi_op_labor_2013 = 3679.95 ;
%let hiwi_op_nonlabor_2013 = 1668.81 ;
*/
data temp4;
set temp3; 
drop temp WI WI1 WI2;
if WI1 ne . then WI=WI1;else if WI2 ne . then WI=WI2;else WI=1;

if FY=2011 then do;
	if WI<1 then laborratio=3552.91/(3552.91+1979.7);
	else laborratio=3201.75/(3201.75+1962.36);
end;
if FY=2012 then do;
	if WI<1 then laborratio=3230.04/(3230.04+1611.20);
	else laborratio=3584.30/(3584.30+1625.44);
end;
if FY=2013 then do;
	if WI<1 then laborratio=3316.23/(3316.23+2032.53);
	else laborratio=3679.95/(3679.95+1668.81);
end;

stdcost=tempspending/(laborratio*WI+(1-laborratio));
drop tempspending laborratio;
proc sort;by PayerClaimControlNumber LineCounter;
run;

data Other;
set temp4;
by PayerClaimControlNumber LineCounter;
if first.PayerClaimControlNumber=0 then stdcost=0;
run;

***End;



***Do: Append ALL IP together and calculate claim total spending, final stdcpst file will be: first line has claim total spending and stdcost, other lines all $0;

data All;
set AcuteCare LTCH IPF IRF Other;
*if PayerClaimControlNumber='2013087300378' and LineCounter ne 1 then deductible=0;
proc sort ;by PayerClaimControlNumber LineCounter;
run;
 
*claim total spending;
proc sql;
create table temp1 as
select *,sum(spending) as clm_spending 
from All
group by PayerClaimControlNumber;
quit;

data temp2;
set temp1;
if clm_spending=0 then stdcost=0;
proc sort ;by PayerClaimControlNumber LineCounter;
run;

data APCD.IPstdcost;
set temp2;
by PayerClaimControlNumber LineCounter;
if first.PayerClaimControlNumber=0 then clm_spending=0;
run;
 
***End; 

