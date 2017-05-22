*******************************
Make Final Analytic Data 
Xiner Zhou
8/25/2015
******************************;
libname APCD 'C:\data\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';
  

*Denominator;
 
data bene2012 bene2011;
set apcd.Denominator;
    sdate=datepart(MemberDateofBirth);
	if  SubmissionYear=2011 then edate='31dec2011'd;
	else  if  SubmissionYear=2012 then edate='31dec2012'd;
  	age=floor(yrdif(sdate, edate, 'AGE')); 

	*age group;
if age<18 then AgeGroup=1;
else if 18<=Age<25 then AgeGroup=2;
else if 25<=Age<35 then AgeGroup=3;
else if 35<=Age<45 then AgeGroup=4;
else if 45<=Age<55 then AgeGroup=5;
else if 55<=Age<65 then AgeGroup=6;
else if 65<=Age<75 then AgeGroup=7;
else if 75<=Age<85 then AgeGroup=8;
else AgeGroup=9;


    if Submissionyear=2011 then output bene2011;else if Submissionyear=2012 then output bene2012; 
	drop sdate edate;
	rename MemberGenderCleaned=Gender;
	rename Standardized_MemberStateorProvin= State;
	rename Standardized_MemberZIPCode  = ZIP;
	keep MemberLinkEID SubmissionYear orgid MedicaidIndicator MedicareCode MemberDateofBirth MemberGenderCleaned  
    Standardized_MemberStateorProvin  Standardized_MemberZIPCode  
    Plan1 Plan2 Plan3 Plan4 Type1 Type2 Type3 Type4 Age AgeGroup switcher; 
	 
run;
  
proc freq data=bene2012;tables AgeGroup;run;

 
* County / State ;
proc import datafile="C:\data\Projects\APCD High Cost\ZIP_COUNTY_092015" dbms=xlsx out=ZIP  replace;getnames=yes;run;
proc import datafile='C:\data\Projects\APCD High Cost\county_to_zip_census2010.xlsx' out=County dbms=xlsx replace;getnames=yes;run;
proc sort data=county nodupkey;by county;run;
proc sql;
create table ziptocounty as 
select a.zip,a.county,a.res_ratio,scan(b.cntyname,1 ) as CountyName, scan(b.cntyname,2 ) as StateName
from zip a left join County b
on a.county=b.county;
quit;
 proc sort data=ziptocounty;where StateName="MA";by zip descending res_ratio;run;
 proc sort data=ziptocounty nodupkey; by zip  ;run;
proc sql;
create table temp1 as
select a.*,b.*
from bene2012 a left join ziptocounty b
on a.ZIP=b.ZIP;
quit;
 
                       

libname ARF 'C:\data\Projects\Medicare Utilization vs MA Rate';
data temp1;
set temp1;
code1=substr(county,1,2);code2=substr(county,3,4);
run;

proc sql;
create table temp2 as
select a.*,b.f00008,b.f00010,b.f00011,b.f00012,b.f1322612
from temp1 a left join ARF.Ahrf b
on a.code1=b.f00011 and a.code2=b.f00012;
quit;
 
proc rank data=temp2 out=temp3 group=4;
var f1322612;
ranks incomerank;
run;
data denom;
set temp3;
incomerank=IncomeRank+1;label IncomeRank="Income Rank based on 2012 County Median House Income";
run;



 
/*******************Chronic Condition and Frailty, Segmentation;
*Chronic Conditioin;
proc sql;
create table temp4 as
select a.*,b.*
from temp3 a left join apcd.CC2011 b
on a.MemberLinkEid=b.MemberLinkEID ;
quit;

proc sql;
create table temp5 as
select a.*,b.*
from temp4 a left join apcd.Frailty2011 b
on a.MemberLinkEid=b.MemberLinkEID ;
quit;
 
data temp5;
set temp5;
array f{12} frailty1 frailty2 frailty3 frailty4 frailty5 frailty6 frailty7 frailty8 frailty9 frailty10 frailty11 frailty12;
array CC{30} 
amiihd amputat arthrit  artopen  bph  
cancer  chrkid  chf  cystfib  dementia  
diabetes  endo  eyedis hemadis  hyperlip  
hyperten  immunedis  ibd liver  lung   
neuromusc  osteo  paralyt  psydis  sknulc 
spchrtarr  strk sa  thyroid  vascdis;
do i=1 to 12 ;
if f{i}=. then f{i}=0;
end;
do j=1 to 30;
if CC{j}=. then CC{j}=0;
end;
drop i j;

N_Frailty=frailty1+ frailty2+ frailty3+ frailty4+ frailty5+ frailty6+ frailty7+ frailty8+ frailty9+ frailty10+ frailty11+ frailty12;
N_MajorCC=amiihd+ chrkid+ chf+ dementia+ lung+ psydis+ strk+ spchrtarr;
N_MinorCC=amputat+ arthrit+ artopen+ bph+ cancer+ diabetes+ endo+ eyedis +
                 hemadis+ hyperlip+ hyperten+ immunedis+ ibd+ liver+ neuromusc+ osteo+ 
                 paralyt+ sknulc+ sa+ thyroid+ vascdis;
N_CC=N_MajorCC+N_MinorCC;

*if Age<65 then seg=1;
if N_Frailty>=2 then seg2011=2;
else if N_MajorCC>=3 then seg2011=3;
else if N_MajorCC=1 or N_MajorCC=2 then seg2011=4;
else if N_MinorCC>0 then seg2011=5;
else if N_MinorCC=0 then seg2011=6;
label seg2011="Segmentation Defined By 2011 CC and Frailty";
 
run;

 


*CCW patient-year;
proc sql;
create table temp6 as
select a.*,
b.Anemia as CCW_Anemia label="Anemia" ,
b.Asthma as CCW_Asthma label="Asthma" ,
b.Atrial_fibrillation as CCW_Atrial_fibrillation label="Atrial fibrillation" ,
b.COPD as CCW_COPD label ="Chronic obstructive pulmonary disease and bronchiectasis", 
b.Cataract as CCW_Cataract label="Cataract" , 
b.Chronic_kidney_disease as CCW_Chronic_kidney_disease label="Chronic kidney disease" ,   
b.Colorectal_cancer as CCW_Colorectal_cancer label ="Colorectal cancer",
b.Depression as CCW_Depression label ="Depression" , 
b.Diabetes as CCW_Diabetes label ="Diabetes" , 
b.Endometrial_cancer as CCW_Endometrial_cancer label ="Endometrial cancer" , 
b.Female_male_breast_cancer  as CCW_Female_male_breast_cancer label ="Female/male breast cancer" ,
b.Glaucoma  as CCW_Glaucoma label="Glaucoma" , 
b.Heart_failure  as CCW_Heart_failure label ="Heart failure" , 
b.Hip_pelvic_fracture  as CCW_Hip_pelvic_fracture label ="Hip/pelvic fracture",
b.Hypertension  as CCW_Hypertension label ="Hypertension", 
b.Ischemic_heart_disease  as CCW_Ischemic_heart_disease label ="Ischemic heart disease",
b.Lung_cancer  as CCW_Lung_cancer label ="Lung cancer",
b.Osteoporosis  as CCW_Osteoporosis label ="Osteoporosis", 
b.Prostate_cancer as CCW_Prostate_cancer label  ="Prostate cancer", 
b.Rheumatoid as CCW_Rheumatoid label ="Rheumatoid arthritis/osteoarthritis",  
b.Stroke_transient_ischemic_attack  as CCW_Stroke  label ="Stroke/transient ischemic attack", 
b.acquired_hypothyroidism as CCW_acquired_hypothyroidism label ="acquired hypothyroidism",  
b.acute_myocardial_infarction  as CCW_acute_myocardial_infarction label ="acute myocardial infarction",
b.alzheimers  as CCW_alzheimers label ="alzheimers disease",
b.alzheimers_disease  as CCW_alzheimers_disease label ="alzheimers disease and Rltd Disorders or Senile Dementia",
b.benign_prostatic_hyperplasia  as CCW_benign_prostatic_hyperplasia label ="benign prostatic hyperplasia",
b.hyperlipidemia as CCW_hyperlipidemia  label ="hyperlipidemia"
from temp5 a left join APCD.BeneCCW b
on a.MemberLinkEID=b.MemberLinkEID and a.Year=b.Year;
quit;

 
data denom;
set temp6;
array mod{27} CCW_Anemia--CCW_hyperlipidemia;
do i=1 to 27;if mod{i}=. then mod{i}=0;end;drop i;
run;
*/

**********************************************************************************************************************
Medicare Part A
Home Health (HH)
Hospice
Inpatient Acute Care Hospital (include CAH)
Other Inpatient (Psych, other hospital)
Other post-acute care (Inpatient Rehab, long-term hospital)
Skilled Nursing Facility (SNF)


************************************************************************************************************************;
data temp;
set apcd.Ipstdcost;
if discharge>='01jan2011'd and discharge<='31dec2011'd then CY=2011;
		else if discharge>='01jan2012'd and discharge<='31dec2012'd then CY=2012;
		else if discharge>='01jan2013'd and discharge<='31dec2013'd then CY=2013;
		else if discharge>='01jan2010'd and discharge<='31dec2010'd then CY=2010;
if CY=2012;
keep PayerClaimControlNumber LineCounter MemberLinkEID ORGID LOS stdcost clm_spending Type;
proc sort;by PayerClaimControlNumber LineCounter;
proc sort nodupkey;by PayerClaimControlNumber ;
proc sort;by MemberLinkEID ORGID Type;
run;

%macro ip(name=,type=,str1=,str2=);
proc sql;
create table temp&name. as
select  MemberLinkEID, ORGID, count(PayerClaimControlNumber) as CLM_&name. label="N.of Claims: &type.", sum(LOS) as LOS_&name. label="LOS: &type.", 
sum(stdcost) as cost_&name. label="Standard Cost: &type.", sum(clm_spending) as Spending_&name. label="Spending: &type."
from temp
where Type in (&str1. , &str2.) 
group by  MemberLinkEID, ORGID
;
quit;

proc sort data=temp&name. nodupkey;by  MemberLinkEID  ORGID;run;
%mend;
%ip(name=IP, type=Inpatient Acute Care Hospital (include CAH), str1="Inpatient Hospital (Acute Hospital)",str2="Critical Access Hospital (CAH) - Inpatient Service");
%ip(name=IP_OTH, type=Other Inpatient (Psych/other hospital), str1="Inpatient Psychiatric Facility (IPF)",str2="Other Inpatient");
%ip(name=PAC_OTH, type=Other post-acute care (Inpatient Rehab, long-term hospital), str1="Inpatient Rehabilitation Facility (IRF)",str2="Long-Term Care Hospital (LTCH)");
 
*HHA;
data temp;
set apcd.HHAstdcost;where CY=2012;
keep PayerClaimControlNumber LineCounter MemberLinkEID ORGID  LOS stdcost spending ;
proc sort;by PayerClaimControlNumber ;
run;

proc sql;
create table temp1 as
select *,sum(stdcost) as clm_stdcost, sum(spending) as clm_spending
from temp
group by PayerClaimControlNumber ;
quit;

proc sort data=temp1 nodupkey;by PayerClaimControlNumber ;run;
proc sort data=temp1  ;by  MemberLinkEID ORGID;run;
proc sql;
create table tempHH as
select  MemberLinkEID, ORGID, count(PayerClaimControlNumber) as clm_hh label="N.of Claims: Home Health (HH)", sum(LOS) as LOS_HH label="LOS: Home Health (HH)", 
sum(clm_stdcost) as Cost_HH label="Standard Cost: Home Health (HH)", sum(clm_spending) as Spending_HH label="Spending: Home Health (HH)"
from temp1
group by  MemberLinkEID, ORGID
;
quit;

proc sort data=tempHH  nodupkey;by  MemberLinkEID ORGID;run;
 

*Hospice;
data temp;
set apcd.Hospicestdcost;where CY=2012;
keep PayerClaimControlNumber LineCounter MemberLinkEID ORGID  LOS spending ;
proc sort;by PayerClaimControlNumber ;
run;

proc sql;
create table temp1 as
select *,sum(spending) as clm_stdcost, sum(spending) as clm_spending
from temp
group by PayerClaimControlNumber ;
quit;

proc sort data=temp1 nodupkey;by PayerClaimControlNumber ;run;
proc sort data=temp1  ;by  MemberLinkEID ORGID;run;
proc sql;
create table tempHospice as
select  MemberLinkEID, ORGID, count(PayerClaimControlNumber) as clm_Hospice label="N.of Claims: Hospice", sum(LOS) as LOS_Hospice label="LOS: Hospice", 
sum(clm_stdcost) as Cost_Hospice label="Standard Cost: Hospice", sum(clm_spending) as Spending_Hospice label="Spending: Hospice"
from temp1
group by  MemberLinkEID, ORGID
;
quit;

proc sort data=tempHospice nodupkey; by MemberLinkEID ORGID;run;
 

* SNF;
data temp;
set apcd.SNFstdcost(keep=DateOfServiceFrom DateOfServiceTo PayerClaimControlNumber LineCounter MemberLinkEID ORGID CY spending);
where CY=2012;
date1=datepart(DateOfServiceFrom);date2=datepart(DateOfServiceTo);
los=max(date2-date1,1);
drop date1 date2;
proc sort;by PayerClaimControlNumber ;
run;

proc sql;
create table temp1 as
select *,sum(spending) as clm_stdcost, sum(spending) as clm_spending
from temp
group by PayerClaimControlNumber ;
quit;

proc sort data=temp1 nodupkey;by PayerClaimControlNumber ;run;
proc sort data=temp1  ;by  MemberLinkEID ORGID;run;
proc sql;
create table tempSNF as
select MemberLinkEID, ORGID, count(PayerClaimControlNumber) as CLM_SNF label="N.of Claims: Skilled Nursing Facility (SNF)", sum(LOS) as LOS_SNF label="LOS: Skilled Nursing Facility (SNF)", 
sum(clm_stdcost) as cost_SNF label="Standard Cost: Skilled Nursing Facility (SNF)", sum(clm_spending) as Spending_SNF label="Spending: Skilled Nursing Facility (SNF)"
from temp1
group by  MemberLinkEID, ORGID
;
quit;

proc sort data=tempSNF nodupkey; by  MemberLinkEID ORGID;run;
  

****************************************************************************
Medicare Part B institutional -- hospital outpatient:
 


if TypeofBill in ('12') then  type='Services Provided By Hospitals to Inpatients' 
else if TypeofBill in ('13') then  type='Hospital Outpatient' 
else if TypeofBill in ('14') then  type='Services Provided By Hospitals to Non-Patients' 
else if TypeofBill in ('71','73') then  type='Rural Health Clinic (RHC) or Federally Qualified Health Center (FQHC)' 
else if TypeofBill in ('72') then type='Renal Dialysis Facility'  
else if TypeofBill in ('74','75') then  type='Comprehensive Outpatient Rehabilitation Facility (CORF) and Outpatient Rehabilitation Facility (ORF)'  
else if TypeofBill in ('76')  then  type='Community Mental Health Center (CMHC)' 
else if TypeofBill in ('83') then  type='Other Outpatient' 
else if TypeofBill in ('85') then  type='Critical Access Hospital �EHospital Outpatient Services' 


'MDCR_OPD'="Outpatient Department Services" TypeofBill in ('13','85') 
'MDCR_ESRD'="End Stage Renal Disease (ESRD) Facility" TypeofBill in ('72')
'MDCR_OSNF'="Other Skilled Nursing Facility"
'MDCR_FQHC'="Federally Qualified Health Center (FQHC)" TypeofBill in ('73')
'MDCR_RHC'="Rural Health Center (Clinic)" TypeofBill in ('71')
'MDCR_THRPY'="Outpatient Therapy (outpatient rehab and community outpatient rehab)" TypeofBill in ('74','75')
'MDCR_CMHC'="Community Mental Health Center (CMHC)" TypeofBill in ('76') 
'MDCR_OTH40'="Other" TypeofBill in ('12','14','83') 
*******************************************************************************;
data temp;
set 
apcd.OPstdcostCY2012(keep=TypeofBill PayerClaimControlNumber LineCounter MemberLinkEID ORGID  stdcost spending );
proc sort;by PayerClaimControlNumber;run;

proc sql;
create table temp1 as
select *,sum(stdcost) as clm_stdcost,sum(spending) as clm_spending
from temp
group by PayerClaimControlNumber;
quit;

proc sort data=temp1 nodupkey;by PayerClaimControlNumber;run;
proc sort data=temp1;by  MemberLinkEID ORGID ;
run;

%macro op(name=,type=,str1=,str2=,str3=);
proc sql;
create table temp&name. as
select  MemberLinkEID, ORGID, count(PayerClaimControlNumber) as CLM_&name. label="N.of Claims: &type.", 
sum(clm_stdcost) as Cost_&name. label="Standard Cost: &type.", sum(clm_spending) as Spending_&name. label="Spending: &type."
from temp1
where TypeofBill in (&str1. , &str2. , &str3. )
group by  MemberLinkEID, ORGID
;
quit;
proc sort data=temp&name. nodupkey;by  MemberLinkEID ORGID ;run;
%mend op;
%op(name=OPD,type=Outpatient Department Services,str1='13',str2='85', str3='85');
%op(name=ESRD,type=End Stage Renal Disease (ESRD) Facility,str1='72',str2='72', str3='72');
%op(name=FQHC,type=Federally Qualified Health Center (FQHC),str1='73',str2='73', str3='73');
%op(name=RHC,type=Rural Health Center (Clinic),str1='71',str2='71', str3='71');
%op(name=THRPY,type=Outpatient Therapy (outpatient rehab and community outpatient rehab),str1='74',str2='75', str3='75');
%op(name=CMHC,type=Community Mental Health Center (CMHC),str1='76',str2='76', str3='76');
%op(name=OTH40,type=Other,str1='12',str2='14', str3='83');
 

 





*******************************************************************************
Medicare Part B non-institutional- Carrier/DME

Ambulatory Surgical Center (ASC) -24='Ambulatory Surgical Center'
Durable Medical Equipment (DME) -if i='D' then category='Durable Medical Equipment'
Physician Evaluation and Management  -if i='M' then category='Evaluation AND Management' 
Imaging -if i='I' then category='Imaging'
Tests -if i='T' then category='Tests'
Other Part B
Procedures -if i='P' then category='Procedures'
Part B Drug -if betos='O1E' then category='Part B Drug'

'MDCR_ASC'="Ambulatory Surgical Center (ASC)"
'MDCR_PTB_DRUG'="Part B Drug"
'MDCR_EM'="Physician Evaluation and Management"
'MDCR_PROC'="Procedures"
'MDCR_IMG'="Imaging"
'MDCR_LABTST'="Laboratory and Testing"
'MDCR_OTH'="Other Part B"
'MDCR_DME'="Durable Medical Equipment (DME)"

******************************************************************************;
libname betos 'C:\data\Projects\APCD High Cost\Archieve';
data temp;
set  
apcd.CarrierstdcostCY2012(keep=PlaceofService PayerClaimControlNumber LineCounter MemberLinkEID ORGID   stdcost spending HCPCS);
run;

proc sql;
create table temp1 as
select a.*,b.*
from temp a left join betos.betos b
on a.HCPCS=b.HCPCS;
quit;

data temp2;
set temp1;

i=substr(betos,1,1);

if PlaceofService='24' then type="Ambulatory Surgical Center (ASC)";
else do;
  if i='D' then Type="Durable Medical Equipment (DME)";
  else if i='M' then Type="Physician Evaluation and Management";
  else if i='I' then Type="Imaging";
  else if i='T' then Type='Tests';
  else if i='P' then Type="Procedures";
  else if i='O' and betos='O1E' then Type="Part B Drug";
  else type="Other Part B";
end;
 
drop i;
proc sort nodupkey;by PayerClaimControlNumber LineCounter;
run;

proc sort data=temp2;by MemberLinkEID ORGID ;
run;

%macro carrier(name=,type=,str= );
proc sql;
create table temp&name. as
select  MemberLinkEID, ORGID, count(PayerClaimControlNumber) as CLM_&name. label="N.of Claims: &type.", 
sum(stdcost) as Cost_&name. label="Standard Cost: &type.", sum(spending) as Spending_&name. label="Spending: &type."
from temp2
where Type   in (&str. )
group by  MemberLinkEID, ORGID
;
quit;
proc sort data=temp&name. nodupkey;by  MemberLinkEID ORGID ;run;
%mend carrier;
%carrier(name=ASC,type=Ambulatory Surgical Center (ASC),str="Ambulatory Surgical Center (ASC)");
%carrier(name=PTB_DRUG,type=Part B Drug,str="Part B Drug");
%carrier(name=EM,type=Physician Evaluation and Management,str="Physician Evaluation and Management");
%carrier(name=PROC,type=Procedures,str="Procedures");
%carrier(name=IMG,type=Imaging,str="Imaging");
%carrier(name=TESTS,type=Tests,str="Tests");
%carrier(name=OTH,type=Other Part B,str="Other Part B");
%carrier(name=DME,type=Durable Medical Equipment (DME),str="Durable Medical Equipment (DME)");








**********************Link Bene with Cost & Utilization;
 
proc sort data=denom;by MemberLinkEID ORGID;run;
 
data DataV21;
merge denom(in=in1) tempIP tempIP_OTH tempPAC_OTH tempHH tempHospice tempSNF
tempOPD tempESRD tempFQHC tempRHC tempTHRPY tempCMHC tempOTH40
tempASC tempPTB_DRUG tempEM tempPROC tempIMG tempTESTS tempOTH tempDME;
by MemberLinkEID ORGID;
if in1=1;

array temp1 {21} Cost_IP Cost_IP_OTH Cost_PAC_OTH Cost_HH Cost_Hospice Cost_SNF
Cost_OPD Cost_ESRD Cost_FQHC Cost_RHC Cost_THRPY Cost_CMHC Cost_OTH40
Cost_ASC Cost_PTB_DRUG Cost_EM Cost_PROC Cost_IMG Cost_TESTS Cost_OTH Cost_DME;


array temp2 {21} Spending_IP Spending_IP_OTH Spending_PAC_OTH Spending_HH Spending_Hospice Spending_SNF
Spending_OPD Spending_ESRD Spending_FQHC Spending_RHC Spending_THRPY Spending_CMHC Spending_OTH40
Spending_ASC Spending_PTB_DRUG Spending_EM Spending_PROC Spending_IMG Spending_TESTS Spending_OTH Spending_DME;

array temp3 {21} CLM_IP CLM_IP_OTH CLM_PAC_OTH CLM_HH CLM_Hospice CLM_SNF
CLM_OPD CLM_ESRD CLM_FQHC CLM_RHC CLM_THRPY CLM_CMHC CLM_OTH40
CLM_ASC CLM_PTB_DRUG CLM_EM CLM_PROC CLM_IMG CLM_TESTS CLM_OTH CLM_DME;

array temp4 {6} LOS_IP LOS_IP_OTH LOS_PAC_OTH LOS_HH LOS_Hospice LOS_SNF;


do i=1 to 21;
if temp1{i}=. then temp1{i}=0;
if temp2{i}=. then temp2{i}=0;
if temp3{i}=. then temp3{i}=0;
end;
do j=1 to 6;
if temp4{j}=. then temp4{j}=0;
end;

drop i j;
Cost=Cost_IP+ Cost_IP_OTH+ Cost_PAC_OTH+ Cost_HH+ Cost_Hospice+ Cost_SNF+
Cost_OPD+ Cost_ESRD+ Cost_FQHC+ Cost_RHC+ Cost_THRPY+ Cost_CMHC+ Cost_OTH40+
Cost_ASC+ Cost_PTB_DRUG+ Cost_EM+ Cost_PROC+ Cost_IMG+ Cost_TESTS+ Cost_OTH+ Cost_DME;

Spending=Spending_IP+ Spending_IP_OTH+ Spending_PAC_OTH+ Spending_HH+ Spending_Hospice+ Spending_SNF+
Spending_OPD+ Spending_ESRD+ Spending_FQHC+ Spending_RHC+ Spending_THRPY+ Spending_CMHC+ Spending_OTH40+
Spending_ASC+ Spending_PTB_DRUG+ Spending_EM+ Spending_PROC+ Spending_IMG+ Spending_TESTS+ Spending_OTH+ Spending_DME;

PTA_Cost=Cost_IP+ Cost_IP_OTH+ Cost_PAC_OTH+ Cost_HH+ Cost_Hospice+ Cost_SNF;
PTBI_Cost=Cost_OPD+ Cost_ESRD+ Cost_FQHC+ Cost_RHC+ Cost_THRPY+ Cost_CMHC+ Cost_OTH40;
PTBNI_Cost=Cost_ASC+ Cost_PTB_DRUG+ Cost_EM+ Cost_PROC+ Cost_IMG+ Cost_TESTS+ Cost_OTH+ Cost_DME;

PTA_Spending=Spending_IP+ Spending_IP_OTH+ Spending_PAC_OTH+ Spending_HH+ Spending_Hospice+ Spending_SNF;
PTBI_Spending=Spending_OPD+ Spending_ESRD+ Spending_FQHC+ Spending_RHC+ Spending_THRPY+ Spending_CMHC+ Spending_OTH40;
PTBNI_Spending=Spending_ASC+ Spending_PTB_DRUG+ Spending_EM+ Spending_PROC+ Spending_IMG+ Spending_TESTS+ Spending_OTH+ Spending_DME;
proc sort;by MemberLinkEID;
run;
  

data DataV21;
set  DataV21;

step1=0;step2=0;step3=0; 
 

if Age <18  then step1=1;
 
if Age <18 and Switcher not in ("Medicaid, Medicare Advantage","Medicaid Managed Care, Medicare Advantage","Medicare Advantage, Private",
"Medicaid, Medicaid Managed Care, Medicare Advantage","Medicaid, Medicare Advantage, Private","Medicaid Managed Care, Medicare Advantage, Private",
"Medicaid, Medicaid Managed Care, Medicare Advantage, Private","Only Medicare Advantage") then step2=1;
 
if Age <18 and Switcher in ("Only Medicaid","Only Medicaid Managed Care","Only Private")  then step3=1;

proc freq;
table step1 step2 step3  ;

run;



****************************************************************
	Define HC based on Standard Cost or Spending, before Tabulations
    * Sign highest payer as primary payer for each bene
*******************************************************************;
%let bymoney=Cost;
%let bymoney=Spending;

proc sql;
create table temp as
select *,sum(Cost_IP) as T_Cost_IP ,sum(Cost_IP_OTH) as T_Cost_IP_OTH ,sum(Cost_PAC_OTH) as T_Cost_PAC_OTH ,sum(Cost_HH) as T_Cost_HH ,sum(Cost_Hospice) as T_Cost_Hospice ,sum(Cost_SNF) as T_Cost_SNF ,
sum(Cost_OPD) as T_Cost_OPD ,sum(Cost_ESRD) as T_Cost_ESRD ,sum(Cost_FQHC) as T_Cost_FQHC ,sum(Cost_RHC) as T_Cost_RHC ,sum(Cost_THRPY) as T_Cost_THRPY ,sum(Cost_CMHC) as T_Cost_CMHC ,sum(Cost_OTH40) as T_Cost_OTH40 ,
sum(Cost_ASC) as T_Cost_ASC ,sum(Cost_PTB_DRUG) as T_Cost_PTB_DRUG ,sum(Cost_EM) as T_Cost_EM ,sum(Cost_PROC) as T_Cost_PROC ,sum(Cost_IMG) as T_Cost_IMG ,sum(Cost_TESTS) as T_Cost_TESTS ,sum(Cost_OTH) as T_Cost_OTH ,sum(Cost_DME) as T_Cost_DME ,
 
sum(Spending_IP) as T_Spending_IP ,sum(Spending_IP_OTH) as T_Spending_IP_OTH ,sum(Spending_PAC_OTH) as T_Spending_PAC_OTH ,sum(Spending_HH) as T_Spending_HH ,sum(Spending_Hospice) as T_Spending_Hospice ,sum(Spending_SNF) as T_Spending_SNF ,
sum(Spending_OPD) as T_Spending_OPD ,sum(Spending_ESRD) as T_Spending_ESRD ,sum(Spending_FQHC) as T_Spending_FQHC ,sum(Spending_RHC) as T_Spending_RHC ,sum(Spending_THRPY) as T_Spending_THRPY ,sum(Spending_CMHC) as T_Spending_CMHC ,sum(Spending_OTH40) as T_Spending_OTH40 ,
sum(Spending_ASC) as T_Spending_ASC ,sum(Spending_PTB_DRUG) as T_Spending_PTB_DRUG ,sum(Spending_EM) as T_Spending_EM ,sum(Spending_PROC) as T_Spending_PROC ,sum(Spending_IMG) as T_Spending_IMG ,sum(Spending_TESTS) as T_Spending_TESTS ,sum(Spending_OTH) as T_Spending_OTH ,sum(Spending_DME) as T_Spending_DME ,
 
sum(CLM_IP) as T_CLM_IP ,sum(CLM_IP_OTH) as T_CLM_IP_OTH ,sum(CLM_PAC_OTH) as T_CLM_PAC_OTH ,sum(CLM_HH) as T_CLM_HH ,sum(CLM_Hospice) as T_CLM_Hospice ,sum(CLM_SNF) as T_CLM_SNF ,
sum(CLM_OPD) as T_CLM_OPD ,sum(CLM_ESRD) as T_CLM_ESRD ,sum(CLM_FQHC) as T_CLM_FQHC ,sum(CLM_RHC) as T_CLM_RHC ,sum(CLM_THRPY) as T_CLM_THRPY ,sum(CLM_CMHC) as T_CLM_CMHC ,sum(CLM_OTH40) as T_CLM_OTH40 ,
sum(CLM_ASC) as T_CLM_ASC ,sum(CLM_PTB_DRUG) as T_CLM_PTB_DRUG ,sum(CLM_EM) as T_CLM_EM ,sum(CLM_PROC) as T_CLM_PROC ,sum(CLM_IMG) as T_CLM_IMG ,sum(CLM_TESTS) as T_CLM_TESTS ,sum(CLM_OTH) as T_CLM_OTH ,sum(CLM_DME) as T_CLM_DME ,
 
sum(LOS_IP) as T_LOS_IP ,sum(LOS_IP_OTH) as T_LOS_IP_OTH ,sum(LOS_PAC_OTH) as T_LOS_PAC_OTH ,sum(LOS_HH) as T_LOS_HH ,sum(LOS_Hospice) as T_LOS_Hospice ,sum(LOS_SNF) as T_LOS_SNF ,


sum(PTA_Cost) as T_PTA_Cost, sum(PTBI_Cost) as T_PTBI_Cost,sum(PTBNI_Cost) as T_PTBNI_Cost,
sum(PTA_Spending) as T_PTA_Spending, sum(PTBI_Spending) as T_PTBI_Spending,sum(PTBNI_Spending) as T_PTBNI_Spending,

sum(Cost) as T_Cost, sum(Spending) as T_Spending, Cost/(calculated T_Cost) as CostRatio, Spending/(calculated T_Spending) as SpendingRatio  
from DataV21
group by MemberLinkEID;
quit;

 

proc sort data=temp;by MemberLinkEID descending &bymoney.ratio;run;
data temp;
length type $30.;
set temp;
by MemberLinkEID descending &bymoney.ratio;
if first.MemberLinkEID=1;

* Sample Selection Step!!! No Medicare Advantage Enrollees;
if step1=1;

if Plan1='MC' or Plan2='MC' or Plan3='MC' or Plan4='MC' then type="Medicaid"; 
else if Plan1 in ('MO') or Plan2 in ('MO') or Plan3 in ('MO')  or Plan4 in ('MO')    then  type ="Medicaid Managed Care";
else  type="Private"; 
proc freq ;tables type /missing;
run;

proc sql;
create table temp1 as
select a.*,b.*
from temp a left join APCD.DrugStdCost2012 b
on a.MemberLinkEID=b.MemberLINKEID;
quit;

data temp1;
set temp1;
if Cost_Drug=. then Cost_Drug=0;
if Spending_Drug=. then  Spending_Drug=0;
if CLM_Drug=. then CLM_Drug=0;

&bymoney.wDrug=T_&bymoney.+ Cost_DRUG;
&bymoney.woDrug=T_&bymoney.;
run;

 
proc rank data=temp1 out=temp2 percent descending ;
var &bymoney.wDrug;
ranks r ;
run;
  
* get race;
proc sort data=apcd.Denominator  out=temp3 nodupkey;where Submissionyear=2012;by MemberLinkEID  ;run;
data temp3;
length race $30. ethnicity $30. hispanic $30.;
set temp3;

* recode Race/Ethnicity Hispanic;
if Race1Cleaned in ('R1') then Race="American Indian/Alaska Native";
else if Race1Cleaned in ('R2') then Race="Asian";
else if Race1Cleaned in ('R3') then Race="Black/African American";
else if Race1Cleaned in ('R4') then Race="Native Hawaiian or other Pacific Islander";
else if Race1Cleaned in ('R5') then Race="White";
else if Race1Cleaned in ('R9') then Race="Other Race";
else Race="Unkown/Missing";

if Ethnicity1Cleaned in ('AMERCN') then Ethnicity="American";
else if Ethnicity1Cleaned in ('BRAZIL') then Ethnicity="Brazilian";
else if Ethnicity1Cleaned in ('CVERDN') then Ethnicity="Cape Verdean";
else if Ethnicity1Cleaned in ('CARIBI') then Ethnicity="Caribbean Island";
else if Ethnicity1Cleaned in ('PORTUG') then Ethnicity="Portuguese";
else if Ethnicity1Cleaned in ('RUSSIA') then Ethnicity="Russian";
else if Ethnicity1Cleaned in ('EASTEU') then Ethnicity="Eastern European";
else if Ethnicity1Cleaned in ('OTHER') then Ethnicity="Other Ethnicity";
else Ethnicity="Unkown/Missing";
 
if HispanicIndicator in ('1') then Hispanic='Hispanic';
else if HispanicIndicator in ('2') then Hispanic='Not Hispanic';
else Hispanic='Unkown/Missing';

keep race ethnicity hispanic memberlinkeid  ;
run;

proc sql;
create table temp4 as
select a.*,b.*
from temp2 a left join temp3 b
on a.MemberLinkeid=b.MemberLinkEID;
quit;

proc sql;
create table temp5 as
select a.*,b.*
from temp4 a left join apcd.PQIspending b
on a.MemberLinkeid=b.MemberLinkEID;
quit;

data APCD.AnalyticDataKid&bymoney.;
set temp5;
if r <=10 then highCost=1;
else  highCost=0;
proc freq;tables  HighCost/missing;
run;

***************************
Link PQI Spending;
**************************;
proc sort data=APCD.AnalyticDataKidCost out=AnalyticDataKidCost;by MemberLinkEID;run;
data APCD.AnalyticDataKidCost ;
merge AnalyticDataKidCost(in=in1) APCD.Tapq01 APCD.Tapq02 APCD.Tapq03 APCD.Tapq05 APCD.Tapq07 
APCD.Tapq08 APCD.Tapq10 APCD.Tapq11 APCD.Tapq12 APCD.Tapq13 APCD.Tapq14 APCD.Tapq15 APCD.Tapq16
APCD.Tapq90 APCD.Tapq91 APCD.Tapq92;
by MemberLinkEID;
if in1=1;

array try {48} N_TAPQ01 TAPQ01stdcost TAPQ01spending N_TAPQ02 TAPQ02stdcost TAPQ02spending N_TAPQ03 TAPQ03stdcost TAPQ03spending
             N_TAPQ05 TAPQ05stdcost TAPQ05spending N_TAPQ07 TAPQ07stdcost TAPQ07spending N_TAPQ08 TAPQ08stdcost TAPQ08spending
			 N_TAPQ10 TAPQ10stdcost TAPQ10spending N_TAPQ11 TAPQ11stdcost TAPQ11spending N_TAPQ12 TAPQ12stdcost TAPQ12spending
			 N_TAPQ13 TAPQ13stdcost TAPQ13spending N_TAPQ14 TAPQ14stdcost TAPQ14spending N_TAPQ15 TAPQ15stdcost TAPQ15spending
			 N_TAPQ16 TAPQ16stdcost TAPQ16spending N_TAPQ90 TAPQ90stdcost TAPQ90spending N_TAPQ91 TAPQ91stdcost TAPQ91spending
			 N_TAPQ92 TAPQ92stdcost TAPQ92spending;
do i=1 to 48;
if try{i}=. then try{i}=0;
end;
drop i;
run;

proc sort data=APCD.AnalyticDataKidSpending out=AnalyticDataKidSpending;by MemberLinkEID;run;
data APCD.AnalyticDataKidSpending;
merge AnalyticDataKidSpending(in=in1) APCD.Tapq01 APCD.Tapq02 APCD.Tapq03 APCD.Tapq05 APCD.Tapq07 
APCD.Tapq08 APCD.Tapq10 APCD.Tapq11 APCD.Tapq12 APCD.Tapq13 APCD.Tapq14 APCD.Tapq15 APCD.Tapq16
APCD.Tapq90 APCD.Tapq91 APCD.Tapq92;
by MemberLinkEID;
if in1=1;

array try {48} N_TAPQ01 TAPQ01stdcost TAPQ01spending N_TAPQ02 TAPQ02stdcost TAPQ02spending N_TAPQ03 TAPQ03stdcost TAPQ03spending
             N_TAPQ05 TAPQ05stdcost TAPQ05spending N_TAPQ07 TAPQ07stdcost TAPQ07spending N_TAPQ08 TAPQ08stdcost TAPQ08spending
			 N_TAPQ10 TAPQ10stdcost TAPQ10spending N_TAPQ11 TAPQ11stdcost TAPQ11spending N_TAPQ12 TAPQ12stdcost TAPQ12spending
			 N_TAPQ13 TAPQ13stdcost TAPQ13spending N_TAPQ14 TAPQ14stdcost TAPQ14spending N_TAPQ15 TAPQ15stdcost TAPQ15spending
			 N_TAPQ16 TAPQ16stdcost TAPQ16spending N_TAPQ90 TAPQ90stdcost TAPQ90spending N_TAPQ91 TAPQ91stdcost TAPQ91spending
			 N_TAPQ92 TAPQ92stdcost TAPQ92spending;
do i=1 to 48;
if try{i}=. then try{i}=0;
end;
drop i;
run;
