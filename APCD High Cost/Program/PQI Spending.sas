***************************************
Preventable Spending
Xiner Zhou
6/14/2016
***************************************;

libname APCD 'C:\data\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';
libname grouper 'C:\data\Data\MSDRG_Software';

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
proc sort data=temp2 out=temp3 nodupkey;by PayerClaimControlNumber LineCounter ;
run;

***End;
 



***Do: Prepare input dataset that meets the requirement of the DRGGrouper software;

*select 1 line per claim, since all the info for ip is the same(except payments);
proc sort data=temp3  out=temp4 nodupkey;by PayerClaimControlNumber ;run;
 
*choose the right admission and discharge dates;
data temp5;
set temp4;   
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
proc freq;tables FY;
run;

*Merge with original claim lines;
proc sql;
create table temp6 as
select a.*,b.*
from temp3  a inner join temp5 b
on a.payerclaimcontrolnumber=b.payerclaimcontrolnumber;
quit;

*Merge with AHA data to get ProviderNumber and ZIPcode for both ServiceProvider and BillProvider;
proc sql;
create table temp7 as
select a.*,b.provider as ServiceProviderNumber,b.ZIP as ServiceProvideZIPAHA
from temp6 a left join apcd.npi b
on a.ServiceProviderNPI=b.NPI;
quit;

proc sql;
create table temp8 as
select a.*,b.provider as BillProviderNumber,b.ZIP as BillProvideZIPAHA
from temp7 a left join apcd.npi b
on a.BillNPI=b.NPI;
quit;

*Merge with member file to get MemberZIPCode and DOB;
proc sql;
create table temp9 as
select memberlinkeid, Standardized_MemberZIPCode, MemberDateofBirth
from apcd.Member 
where memberlinkeid ne .;
quit;
proc sort data=temp9 nodupkey;by memberlinkeid;run;

proc sql;
create table temp10 as
select a.*,b.*
from temp8 a left join temp9 b
on a.memberlinkeid=b.memberlinkeid;
quit;

*select MA patients only, clean MemberZIP/DOB/Age;
data temp11;
set temp10;

if MemberState in ('MA');

if MemberZIP = '' then MemberZIP=Standardized_MemberZIPCode;
if DOB=. then DOB=MemberDateOfBirth;
age=floor(yrdif(datepart(DOB), discharge, 'AGE'));

drop Standardized_MemberZIPCode MemberDateOfBirth;
run;
 

proc sort data=temp11 out=temp12 nodupkey;by PayerClaimControlNumber;run; 
 
* get Sex;
proc sql;
create table sex   as
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
create table temp13 as
select a.*,b.*
from temp12 a left join sex b
on a.MemberLinkEID=b.MemberLinkEID;
quit;

data temp14;
set temp13;
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
set temp14;
 
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
MDC=Final_MDC;
keep Medical_record_number Final_DRG Software_Version MDC;
run;

proc sql;
create table temp15 as
select a.*,b.*
from temp14 a left join output b
on a.Medical_record_number=b.Medical_record_number;
quit;

data temp16;
set temp15;
keep MemberLinkEID PayerClaimControlNumber final_DRG Software_Version MDC;
run;
 

proc sql;
create table ipline as
select a.*,b.*
from temp11 a left join temp16 b
on a.PayerClaimControlNumber=b.PayerClaimControlNumber;
quit;

***End;


*** DO: Prepare Data for PQI Software;

* Keep the first line of each claim, make a claim level dataset;
proc sort data=ipline ;by MemberLinkEID PayerClaimControlNumber LineCounter;run;
proc sort data=ipline out=ipclaim nodupkey;by MemberLinkEID PayerClaimControlNumber  ;run;

* Identify transfer;
proc sort data=ipclaim;by MemberLinkEID DateofServiceFrom DateofServiceTo; run; 
data temp18;
set ipclaim;
L_BENE_ID=lag(MemberLinkEID);
L_DSCHRGDT=lag(DateofServiceTo);
if L_BENE_ID=MemberLinkEID and DateofServiceFrom=L_DSCHRGDT then xfer=1;else xfer=0;
* Make all people white American;
race=1;
run;

  

data APCD.preparePQI;
set temp18 (rename=(race=Bene_race_cd gender=Bene_sex_ident_cd));
    sdate=datepart(DOB);
    if submissionYear=2011 then edate='31dec2011'd;
	else  if submissionYear=2012 then edate='31dec2012'd;
  	age=floor(yrdif(sdate, edate, 'AGE')); 
   	KEY +1;  
	AGEDAY = . ; 
 	RACE = .;
		if BENE_RACE_CD = '1' then RACE = 1; 
		else if BENE_RACE_CD = '2' then RACE = 2; 
		else if BENE_RACE_CD = '5' then RACE = 3; 
		else if BENE_RACE_CD = '4' then RACE = 4; 
		else if BENE_RACE_CD = '6' then RACE = 5; 
		else if BENE_RACE_CD NOTIN ('0','1','2','5','4','6', ' ') then RACE = 6;  
	SEX = input(BENE_SEX_IDENT_CD,3.);
		if BENE_SEX_IDENT_CD = '0' then SEX = .; 
	PAY1 = 1; 
	PAY2 = .; 
	PSTCO = 22090;
	HOSPID = "01000" ; 
	ATYPE = .; 
	ASOURCE = .; 
		 if AdmissionSource = '7' then ASOURCE = 1; 
		 if AdmissionSource = '4' then ASOURCE = 2; 
		 if xfer = 1 then ASOURCE = 2; 
		 if AdmissionSource  IN ('5','6') then ASOURCE = 3; 
		 if AdmissionSource  = '8' then ASOURCE = 4; 
		 if AdmissionSource  IN ('1','2','3') then ASOURCE = 5;
	DRG = input(Final_DRG, 3.);               
	DRGVER = substr(Software_Version,1,2)*1;  
	DISCWT = 1;

	format dx1 - dx13 $7. PR1-PR7 $7.;
	array dgn(20) 	PrincipalDx SecondaryDx1  SecondaryDx2 SecondaryDx3 SecondaryDx4 SecondaryDx5 SecondaryDx6
                    SecondaryDx7 SecondaryDx8 SecondaryDx9 SecondaryDx10 SecondaryDx11 SecondaryDx12
                    ICD9Procedure OtherICD9Procedure1 OtherICD9Procedure2 OtherICD9Procedure3 OtherICD9Procedure4 OtherICD9Procedure5 OtherICD9Procedure6;
					 
	array dx (20)   dx1 - dx13 PR14-PR20;
		do i = 1 to 13;
			dx(i) = substr(dgn(i), 1, 5);
		end;
		do i = 14 to 20;
			dx(i) =substr(dgn(i), 1, 4);
		end;
	drop i;

	POINTOFORIGINUB04 = " "; 
		if AdmissionSource = '4' then POINTOFORIGINUB04 = '4'; 
		if xfer = 1 then POINTOFORIGINUB04 = '4'; 
		if AdmissionSource = '5' then POINTOFORIGINUB04 = '5'; 
		if AdmissionSource = '6' then POINTOFORIGINUB04 = '6'; 
    YEAR = year(date4);   
    DQTR = . ; 
    	if month(date4) in (1,2,3) then DQTR = 1; 
		if month(date4) in (4,5,6) then DQTR = 2; 
		if month(date4) in (7,8,9) then DQTR = 3; 
		if month(date4) in (10,11,12) then DQTR = 4;  

run;

  

*** End;


*** Do: Create a dataset with PQI indicator and claim id and member id;
proc sql;
create table apcd.PQI as
select a.*,b.*
from out1.pqi a left join apcd.PreparePQI b
on a.key=b.key;
quit;


*** End;


*** Do: Post 30-day Spending;

proc sort data=APCD.PQI out=PQI ;where TAPQ90=1 ;by MemberLinkEID DateOfServiceFrom DateOfServiceTo LineCounter ;run;
data PQI;set PQI;discharge=datepart(DateofServiceTo);if discharge>='01jan2012'd and discharge<='31dec2012'd;run;
proc sort data=PQI nodupkey;by MemberLinkEID DateOfServiceFrom DateOfServiceTo ;run;
* calculate number of PQI;

proc sql;
create table NPQI as
select MemberLinkEID, count(*) as N
from PQI
group by MemberLinkEID;
quit;
proc sort data=NPQI nodupkey;by MemberLinkEID;run;

*IP;
proc sort data=APCD.Ipstdcost out=Ipstdcost ;where stdcost ne 0 or clm_spending ne 0;by MemberLinkEID DateOfServiceFrom DateOfServiceTo  ;run;
proc sort data=Ipstdcost nodupkey;by MemberLinkEID DateOfServiceFrom DateOfServiceTo;run;

proc sql;
create table ip as
select a.MemberLinkEID, a.key, a.TAPQ90 as PQI, datepart(a.DateOfServiceFrom) as PQIdate1  , datepart(a.DateOfServiceTo) as PQIdate2, 
		"IP" as clm,
     datepart(b.DateOfServiceFROM)as date1, datepart(b.DateOfServiceTo) as date2, b.stdcost as clm_stdcost,b.clm_spending  
    from PQI a left join Ipstdcost b
on a.MemberLinkEID=b.MemberLinkEID
where a.TAPQ90=1;
quit;

data ip;
set ip;
temp1=date1-PQIdate1;temp2=date1-PQIdate2;
if temp1>=0 and temp2<=30;drop temp1 temp2;format PQIdate1 PQIdate2 date1 date2 ddmmyy10.;
run;
 
proc sort data=ip nodupkey;by MemberLinkEID date1 date2 ;run;

    
* OP;
proc sql;
create table op as
select a.MemberLinkEID, a.key, a.TAPQ90 as PQI, datepart(a.DateOfServiceFrom) as PQIdate1  , datepart(a.DateOfServiceTo) as PQIdate2, 
		"Outpatient" as clm,
     datepart(b.DateOfServiceFROM)as date1, datepart(b.DateOfServiceTo) as date2, b.stdcost as clm_stdcost,b.spending as clm_spending,b.PayerClaimControlNumber,b.LineCounter
    from PQI a left join APCD.Opstdcostcy2012 b
on a.MemberLinkEID=b.MemberLinkEID
where a.TAPQ90=1;
quit;

data op;
set op;
temp1=date1-PQIdate1;temp2=date1-PQIdate2;
if temp1>=0 and temp2<=30 and temp2>=0;drop temp1 temp2;format PQIdate1 PQIdate2 date1 date2 ddmmyy10.;
run;
 
proc sort data=op	 nodupkey;by PayerClaimControlNumber LineCounter ;run; 


*  Carrier  ;
proc sql;
create table car as
select a.MemberLinkEID, a.key, a.TAPQ90 as PQI, datepart(a.DateOfServiceFrom) as PQIdate1  , datepart(a.DateOfServiceTo) as PQIdate2, 
		"Carrier" as clm,
     datepart(b.DateOfServiceFROM)as date1, datepart(b.DateOfServiceTo) as date2, b.stdcost as clm_stdcost,b.spending as clm_spending,b.PayerClaimControlNumber,b.LineCounter
    from PQI a left join APCD.Carrierstdcostcy2012 b
on a.MemberLinkEID=b.MemberLinkEID
where a.TAPQ90=1;
quit;

data car;
set car;
temp1=date1-PQIdate1;temp2=date1-PQIdate2;
if temp1>=0 and temp2<=30 and temp2>=0;drop temp1 temp2;format PQIdate1 PQIdate2 date1 date2 ddmmyy10.;
run;
 
proc sort data=car	 nodupkey;by PayerClaimControlNumber LineCounter ;run; 

*  HHA ;
proc sql;
create table HHA as
select a.MemberLinkEID, a.key, a.TAPQ90 as PQI, datepart(a.DateOfServiceFrom) as PQIdate1  , datepart(a.DateOfServiceTo) as PQIdate2, 
		"Home Health" as clm,
     datepart(b.DateOfServiceFROM)as date1, datepart(b.DateOfServiceTo) as date2, b.stdcost as clm_stdcost,b.spending as clm_spending,b.PayerClaimControlNumber,b.LineCounter
    from PQI a left join APCD.HHAstdcost b
on a.MemberLinkEID=b.MemberLinkEID
where a.TAPQ90=1;
quit;

data HHA;
set HHA;
temp1=date1-PQIdate1;temp2=date1-PQIdate2;
if temp1>=0 and temp2<=30 and temp2>=0;drop temp1 temp2;format PQIdate1 PQIdate2 date1 date2 ddmmyy10.;
run;
 
proc sort data=HHA nodupkey;by PayerClaimControlNumber LineCounter ;run; 


*  SNF ;
proc sql;
create table SNF as
select a.MemberLinkEID, a.key, a.TAPQ90 as PQI, datepart(a.DateOfServiceFrom) as PQIdate1  , datepart(a.DateOfServiceTo) as PQIdate2, 
		"Skilled Nursing Facility" as clm,
     datepart(b.DateOfServiceFROM)as date1, datepart(b.DateOfServiceTo) as date2, b.spending as clm_stdcost,b.spending as clm_spending,b.PayerClaimControlNumber,b.LineCounter
    from PQI a left join APCD.SNFstdcost b
on a.MemberLinkEID=b.MemberLinkEID
where a.TAPQ90=1;
quit;

data SNF;
set SNF;
temp1=date1-PQIdate1;temp2=date1-PQIdate2;
if temp1>=0 and temp2<=30 and temp2>=0;drop temp1 temp2;format PQIdate1 PQIdate2 date1 date2 ddmmyy10.;
run;
 
proc sort data=SNF nodupkey;by PayerClaimControlNumber LineCounter ;run; 
 


*  Hospice;
proc sql;
create table Hospice as
select a.MemberLinkEID, a.key, a.TAPQ90 as PQI, datepart(a.DateOfServiceFrom) as PQIdate1  , datepart(a.DateOfServiceTo) as PQIdate2, 
		"Hospice" as clm,
     datepart(b.DateOfServiceFROM)as date1, datepart(b.DateOfServiceTo) as date2, b.stdcost as clm_stdcost,b.spending as clm_spending,b.PayerClaimControlNumber,b.LineCounter
    from PQI a left join APCD.Hospicestdcost b
on a.MemberLinkEID=b.MemberLinkEID
where a.TAPQ90=1;
quit;

data Hospice;
set Hospice;
temp1=date1-PQIdate1;temp2=date1-PQIdate2;
if temp1>=0 and temp2<=30 and temp2>=0;drop temp1 temp2;format PQIdate1 PQIdate2 date1 date2 ddmmyy10.;
run;
 
proc sort data=Hospice nodupkey;by PayerClaimControlNumber LineCounter ;run; 
 

 
data all;
length  clm $20.;
set ip op car hha snf  hospice  ;
proc sort;by MemberLinkEID PQIdate1 PQIdate2  ;
run;

* bene level cost;
proc sort data=all;by MemberLinkEID;run;
proc sql;
create table temp as
select MemberLinkEID, clm, sum(clm_stdcost) as stdcost, sum(clm_spending) as spending
from all
group by MemberLinkEID, clm;
quit;
proc sort data=temp nodupkey;by MemberLinkEID clm;run;
 
* Mege all;
proc transpose data=temp out=temp1 prefix=PQIstdcost;
    by MemberLinkEID;
    id clm;
    var stdcost;
run;

proc transpose data=temp out=temp2 prefix=PQIspending;
    by MemberLinkEID;
    id clm;
    var spending;
run;

proc sort data=temp1;by MemberLinkEID;run;
proc sort data=temp2;by MemberLinkEID;run;
proc sort data=NPQI;by MemberLinkEID;run;

data APCD.PQIspending;
merge NPQI(in=in1) temp1(drop=_Name_) temp2(drop=_Name_);
by MemberLinkEID;
if in1=1;
array temp{12} PQIstdcostCarrier--PQIspendingHospice;
do i=1 to 12;
   if temp{i}=. then temp{i}=0;
end;

PQIstdcost30=temp{1}+temp{2}+temp{3}+temp{4}+temp{5}+temp{6};
PQISpending30=temp{7}+temp{8}+temp{9}+temp{10}+temp{11}+temp{12};
drop i;

rename PQIstdcostOutpatient=PQIstdcostOp;
rename PQIstdcostHome_Health=PQIstdcostHHA;
rename PQIstdcostSkilled_Nursing_Faci=PQIstdcostSNF;

rename PQIspendingOutpatient=PQIspendingOp;
rename PQIspendingHome_Health=PQIspendingHHA;
rename PQIspendingSkilled_Nursing_Faci=PQIspendingSNF;
run;



******************************
 PQI spending by condition
*****************************;
proc sort data=APCD.IPstdcost out=IPstdcost ;by PayerClaimControlNumber LineCounter;run;
proc sort data=IPstdcost nodupkey;by PayerClaimControlNumber ;run; 

proc sql;
create table temp as
select a.MemberLinkEID, a.PayerClaimControlNumber, 
a.TAPQ01, a.TAPQ02, a.TAPQ03, a.TAPQ05, a.TAPQ07, a.TAPQ08, a.TAPQ10, a.TAPQ11, a.TAPQ12, a.TAPQ13, a.TAPQ14, a.TAPQ15, a.TAPQ16, 
a.TAPQ90,a.TAPQ91, a.TAPQ92,
b.stdcost as PQIstdcost, b.clm_spending as PQIspending
from PQI a left join IPstdcost b
on a.PayerClaimControlNumber=b.PayerClaimControlNumber and a.MemberLinkEID=b.MemberLinkEID;
quit;

data temp;
set temp;
array try {18}  TAPQ01 TAPQ02 TAPQ03 TAPQ05 TAPQ07 TAPQ08 TAPQ10 TAPQ11 TAPQ12 TAPQ13 TAPQ14 TAPQ15 TAPQ16  
TAPQ90 TAPQ91 TAPQ92  PQIstdcost PQIspending;
do i=1 to 18;
if try{i}=. then try{i}=0;
end;
drop i;
proc contents;
run;

%macro PQI(var,label1,label2,label3);
data temp1;set temp;where &var.=1;proc sort;by MemberLinkEID;run;
proc sql;
create table &var. as
select MemberLinkEID, count(*) as N_&var. , sum(PQIstdcost) as &var.stdcost, sum(PQIspending) as &var.spending
from temp1
group by MemberLinkEID;
quit;

data APCD.&var.;
set &var.;
label N_&var.=&label1.;
label &var.stdcost=&label2.;
label &var.spending=&label3.;
proc sort nodupkey;by MemberLinkEID;
run;
%mend PQI;
%PQI(var=TAPQ01,label1="N. of Diabetes Short-Term Complications Admission",label2="Standard Cost of Diabetes Short-Term Complications Admission",label3="Actual Spending of Diabetes Short-Term Complications Admission");
%PQI(var=TAPQ02,label1="N. of Perforated Appendix Admission",label2="Standard Cost of Perforated Appendix Admission",label3="Actual Spending of Perforated Appendix Admission");
%PQI(var=TAPQ03,label1="N. of Diabetes Long-Term Complications Admission",label2="Standard Cost of Diabetes Long-Term Complications Admission",label3="Actual Spending of Diabetes Long-Term Complications Admission");
%PQI(var=TAPQ05,label1="N. of Chronic Obstructive Pulmonary Disease (COPD) or Asthma in Older Adults Admission",label2="Standard Cost of Chronic Obstructive Pulmonary Disease (COPD) or Asthma in Older Adults Admission",label3="Actual Spending of Chronic Obstructive Pulmonary Disease (COPD) or Asthma in Older Adults Admission");
%PQI(var=TAPQ07,label1="N. of Hypertension Admission",label2="Standard Cost of Hypertension Admission",label3="Actual Spending of Hypertension Admission");
%PQI(var=TAPQ08,label1="N. of Heart Failure Admission",label2="Standard Cost of Heart Failure Admission",label3="Actual Spending of Heart Failure Admission");
%PQI(var=TAPQ10,label1="N. of Dehydration Admission",label2="Standard Cost of Dehydration Admission",label3="Actual Spending of Dehydration Admission");
%PQI(var=TAPQ11,label1="N. of Bacterial Pneumonia Admission",label2="Standard Cost of Bacterial Pneumonia Admission",label3="Actual Spending of Bacterial Pneumonia Admission");
%PQI(var=TAPQ12,label1="N. of Urinary Tract Infection Admission",label2="Standard Cost of Urinary Tract Infection Admission",label3="Actual Spending of Urinary Tract Infection Admission");
%PQI(var=TAPQ13,label1="N. of Angina Without Procedure Admission",label2="Standard Cost of Angina Without Procedure Admission",label3="Actual Spending of Angina Without Procedure Admission");
%PQI(var=TAPQ14,label1="N. of Uncontrolled Diabetes Admission",label2="Standard Cost of Uncontrolled Diabetes Admission",label3="Actual Spending of Uncontrolled Diabetes Admission");
%PQI(var=TAPQ15,label1="N. of Asthma in Younger Adults Admission",label2="Standard Cost of Asthma in Younger Adults Admission",label3="Actual Spending of Asthma in Younger Adults Admission");
%PQI(var=TAPQ16,label1="N. of Lower-Extremity Amputation among Patients with Diabetes",label2="Standard Cost of Lower-Extremity Amputation among Patients with Diabetes",label3="Actual Spending of Lower-Extremity Amputation among Patients with Diabetes");
%PQI(var=TAPQ90,label1="N. of Prevention Quality Overall",label2="Standard Cost of Prevention Quality Overall",label3="Actual Spending of Prevention Quality Overall");
%PQI(var=TAPQ91,label1="N. of Prevention Quality Acute",label2="Standard Cost of Prevention Quality Acute",label3="Actual Spending of Prevention Quality Acute");
%PQI(var=TAPQ92,label1="N. of Prevention Quality Chronic",label2="Standard Cost of Prevention Quality Chronic",label3="Actual Spending of Prevention Quality Chronic");
 
 




 



  
