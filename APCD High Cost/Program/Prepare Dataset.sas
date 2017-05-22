*******************************
Make Final Analytic Data 
Xiner Zhou
8/25/2015
******************************;
libname APCD 'C:\data\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';

*Denominator;
* Age;
data temp;
set apcd.Denominator;
	sdate=datepart(MemberDateofBirth);
	if submissionYear=2011 then edate='31dec2011'd;
	else  if submissionYear=2012 then edate='31dec2012'd;
  	age=floor(yrdif(sdate, edate, 'AGE'));
	drop sdate edate;
	rename MemberGenderCleaned=Gender;
	rename Standardized_MemberStateorProvin=MemberState;
	rename Standardized_MemberZIPCode  =MemberZIP;
	keep MemberLinkEID SubmissionYear orgid MedicaidIndicator MedicareCode MemberDateofBirth MemberGenderCleaned  
    Standardized_MemberStateorProvin  Standardized_MemberZIPCode  
    Plan1 Plan2 Plan3 Plan4 Type1 Type2 Type3 Type4 Age switcher;
run;

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
 
proc sql;
create table temp1 as
select a.*,b.*
from temp a left join ziptocounty b
on a.MemberZIP=b.ZIP;
quit;

proc sort data=temp1;by MemberLinkEID SubmissionYear OrgID descending res_ratio;run;
proc sort data=temp1  nodupkey;by MemberLinkEID SubmissionYear OrgID ;run;


*Chronic Conditioin;
proc sql;
create table temp4 as
select a.*,b.*
from temp1 a left join apcd.ChronicCondition b
on a.MemberLinkEid=b.MemberLinkEID
where a.type1 ne '';
quit;

*Number of Major or Minor Chronic Conditions;
data temp5;
set temp4;
array major{9} amiihd chrkid chf dementia lung psydis spchrtarr strk  diabetes;
array minor{20} amputat arthrit artopen bph cancer cystfib endo eyedis hemadis hyperlip hyperten immunedis ibd liver neuromusc osteo paralyt sknulc sa thyroid;
MajorCC=0;MinorCC=0;
do i=1 to 9;
 MajorCC=MajorCC+major{i};
end;
do i=1 to 20;
 MinorCC=MinorCC+Minor{i};
end;
drop i;
label MajorCC='Number of Major Chronic Conditions';
label MinorCC='Number of Minor Chronic Conditions';
run;

*Frailty/Mental Health/Drug Abuse Bene-Year;
proc sql;
create table temp6 as
select a.*,b.*
from temp5 a left join apcd.Frailty_mental_ad b
on a.MemberLinkEid=b.MemberLinkEID and a.SubmissionYear=b.CY;
quit;

*CCW patient-year;
proc sql;
create table temp7 as
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
from temp6 a left join APCD.BeneCCW b
on a.MemberLinkEID=b.MemberLinkEID and a.SubmissionYear=b.Year;
quit;

 
data denom;
set temp7;
array mod{63} amiihd--CCW_hyperlipidemia;
do i=1 to 63;if mod{i}=. then mod{i}=0;end;drop i;
run;

/*county level ARF;
libname MAP 'C:\data\Projects\Medicare Utilization vs MA Rate\data';
data ARF;set MAP.AHRF;run;
proc contents data=ARF varnum out=varlist;run; proc sort data=varlist;by varnum;run;
proc print data=varlist;var name label;run;
data ARF;
set ARF;
FIPS=f00002;
CensusRegionName=f04448 ;
CensusDivisionName=f04449 ; 
CBSA=f1389213;
MetropolitanDivisionName=f1419413;
CombinedStatisticalAreaName=f1389413 ;
PCP1=f1467512;label PCP1="Phys,Primary Care, Patient Care 2012 ";
PCP1=f1467612;label PCP1="Phys,Primary Care, Hsp Resident 2012"; 
  
205 f0461012 MD's, Total Gen Pract, Total 2012 
 
236 f0994712 MD's, Gen Pract, Total 2012 
 
317 f0461812 Med Spec Tot, Total 2012 
    
3107 f1464612 Adv Practice Regist Nurse w/NPI 2012 
   
3117 f1464212 Nurse Practitioners w/NPI 2012 
   
3217 f0886811 Total Number Hospitals 2011 
 
3220 f0886911 # Short Term General Hosps 2011 
 
3223 f0887011 # Short Term Non-General Hosps 2011 
 



4123 f1198412 Population Estimate 2012 

5130 f1324912 Medicare Enrollment, Aged Tot 2012 
 

 
5747 f0978112 Per Capita Income 2012 

5775 f1434508 Median Household Income 2008-12 

5966 f1440808 % Persons Below Poverty Level 2008-12 

*/

*********************************Stdcost and Spending & Utilization IP: Stdcost/spending/number of stays and LOS by type ;
data temp;
set apcd.Ipstdcost;
keep PayerClaimControlNumber LineCounter MemberLinkEID ORGID CY LOS stdcost clm_spending Type;
proc sort;by PayerClaimControlNumber LineCounter;
proc sort nodupkey;by PayerClaimControlNumber ;
proc sort;by CY MemberLinkEID ORGID Type;
run;

%macro ip(type=,i=);
proc sql;
create table temp&i. as
select CY, MemberLinkEID, ORGID, count(PayerClaimControlNumber) as IPStay&i., sum(LOS) as IPLOS&i., sum(stdcost) as IPCost&i., sum(clm_spending) as IPSpending&i.
from temp
where Type=&type.
group by CY, MemberLinkEID, ORGID
;
quit;

proc sort data=temp&i. nodupkey;by CY  MemberLinkEID  ORGID;run;
%mend;
%ip(type='Inpatient Hospital (Acute Hospital)',i=1);
%ip(type='Critical Access Hospital (CAH) - Inpatient Service',i=2);
%ip(type='Inpatient Psychiatric Facility (IPF)',i=3);
%ip(type='Long-Term Care Hospital (LTCH)',i=4);
%ip(type='Inpatient Rehabilitation Facility (IRF)',i=5);
%ip(type='Other Inpatient',i=6);

%macro label(type=,i=);
label IPStay&i.="Number of Admissions: &type.";
label IPLOS&i.="LOS: &type."
label IPcost&i.="Standard Cost: &type."
label IPspending&i.="Actual Payment: &type."
%mend ;

data IP;
merge temp1 temp2 temp3 temp4 temp5 temp6;
by CY  MemberLinkEID  ORGID;

%label(type=Inpatient Hospital (Acute Hospital),i=1);
%label(type=Critical Access Hospital (CAH) - Inpatient Service,i=2);
%label(type=Inpatient Psychiatric Facility (IPF),i=3);
%label(type=Long-Term Care Hospital (LTCH),i=4);
%label(type=Inpatient Rehabilitation Facility (IRF),i=5);
%label(type=Other Inpatient,i=6);
/*
IPstay=IPstay1+IPstay2+IPstay3+IPstay4+IPstay5+IPstay6;
IPLOS=IPLOS1+IPLOS2+IPLOS3+IPLOS4+IPLOS5+IPLOS6;
IPcost=IPcost1+IPcost2+IPcost3+IPcost4+IPcost5+IPcost6;
IPspending=IPspending1+IPspending2+IPspending3+IPspending4+IPspending5+IPspending6;
*/
run;

*********************************Stdcost and Spending & Utilization OP;
data temp;
set apcd.OPstdcostCY2011(keep=PayerClaimControlNumber LineCounter MemberLinkEID ORGID CY stdcost spending )
apcd.OPstdcostCY2012(keep=PayerClaimControlNumber LineCounter MemberLinkEID ORGID CY stdcost spending );
proc sort;by PayerClaimControlNumber;run;

proc sql;
create table temp1 as
select *,sum(stdcost) as clm_stdcost,sum(spending) as clm_spending
from temp
group by PayerClaimControlNumber;
quit;

proc sort data=temp1 nodupkey;by PayerClaimControlNumber;run;
proc sort data=temp1;by CY MemberLinkEID ORGID ;
run;


proc sql;
create table temp2 as
select CY, MemberLinkEID, ORGID, count(PayerClaimControlNumber) as OPVisit, sum(clm_stdcost) as OPCost, sum(clm_spending) as OPSpending
from temp1
group by CY, MemberLinkEID, ORGID
;
quit;
proc sort data=temp2 nodupkey;by CY MemberLinkEID ORGID ;run;

data op;
set temp2;
label OPVisit="Number of OP visits";
label OPCost="Standard Cost: Outpatient";
label OPspending="Actual Payment: Outpatient";
run;





*********************************Stdcost and Spending & Utilization Carrier;
libname betos 'C:\data\Projects\APCD High Cost\Archieve';
data temp;
set apcd.CarrierstdcostCY2011(keep=PayerClaimControlNumber LineCounter MemberLinkEID ORGID CY stdcost spending HCPCS)
apcd.CarrierstdcostCY2012(keep=PayerClaimControlNumber LineCounter MemberLinkEID ORGID CY stdcost spending HCPCS);
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
if i='M' then category='Evaluation AND Management';
if i='P' then category='Procedures';
if i='I' then category='Imaging';
if i='T' then category='Tests';
if i='D' then category='Durable Medical Equipment';
if i='O' then do;
	if betos='O1A' then category='Ambulance';
	if betos='O1B' then category='Chiropractic';
	if betos='O1C' then category='Enteral and Parenteral';
	if betos='O1D' then category='Chemotherapy';
    if betos='O1E' then category='Other Drugs';
	if betos='O1F' then category='Vision,Hearing and Speech Services';
	if betos='O1G' then category='Influenza Immunization';
end;
if i in ('Y','Z') then category='Exceptions/Unclassfied';
if i='' then category='Missing HCPCS';
drop i;
run;

proc sort data=temp2;by CY MemberLinkEID ORGID ;
run;

%macro loop(cat=,i=);
proc sql;
create table physician&i. as
select CY, MemberLinkEID, ORGID, count(PayerClaimControlNumber) as PhysicianEvent&i., 
sum(stdcost) as PhysicianCost&i., sum(spending) as PhysicianSpending&i.
from temp2
where category=&cat.
group by CY, MemberLinkEID, ORGID
;
quit;
proc sort data=physician&i.  nodupkey;by CY  MemberLinkEID  ORGID;run;
%mend loop;
%loop(cat="Evaluation AND Management", i=1);
%loop(cat="Procedures", i=2);
%loop(cat="Imaging", i=3);
%loop(cat="Tests", i=4);
%loop(cat="Durable Medical Equipment", i=5);
%loop(cat="Ambulance", i=6);
%loop(cat="Chiropractic", i=7);
%loop(cat="Enteral and Parenteral", i=8);
%loop(cat="Chemotherapy", i=9);
%loop(cat="Other Drugs", i=10);
%loop(cat="Vision,Hearing and Speech Services", i=11);
%loop(cat="Influenza Immunization", i=12);
%loop(cat="Exceptions/Unclassfied", i=13);
%loop(cat="Missing HCPCS", i=14);

%macro loop(cat=,i=);
label PhysicianEvent&i.="Number of Events: &cat.";
label PhysicianCost&i.="Standard Cost: &cat.";
label PhysicianSpending&i.="Actual Payment: &cat.";
%mend;
data Physician;
merge Physician1 Physician2 Physician3 Physician4 Physician5 Physician6
Physician7 Physician8 Physician9 Physician10 Physician11 Physician12
Physician13 Physician14 ;
by CY  MemberLinkEID  ORGID;
%loop(cat=Evaluation AND Management, i=1);
%loop(cat=Procedures, i=2);
%loop(cat=Imaging, i=3);
%loop(cat=Tests, i=4);
%loop(cat=Durable Medical Equipment, i=5);
%loop(cat=Ambulance, i=6);
%loop(cat=Chiropractic, i=7);
%loop(cat=Enteral and Parenteral, i=8);
%loop(cat=Chemotherapy, i=9);
%loop(cat=Other Drugs, i=10);
%loop(cat=Vision/Hearing/Speech Services, i=11);
%loop(cat=Influenza Immunization, i=12);
%loop(cat=Exceptions/Unclassfied, i=13);
%loop(cat=Missing HCPCS, i=14);
run;


 
*********************HHA: stdcost spending los;
data temp;
set apcd.HHAstdcost;
keep PayerClaimControlNumber LineCounter MemberLinkEID ORGID CY LOS stdcost spending ;
proc sort;by PayerClaimControlNumber ;
run;

proc sql;
create table temp1 as
select *,sum(stdcost) as clm_stdcost, sum(spending) as clm_spending
from temp
group by PayerClaimControlNumber ;
quit;

proc sort data=temp1 nodupkey;by PayerClaimControlNumber ;run;
proc sort data=temp1  ;by CY MemberLinkEID ORGID;run;
proc sql;
create table temp2 as
select CY, MemberLinkEID, ORGID, count(PayerClaimControlNumber) as HHAevent, sum(LOS) as HHALOS, sum(clm_stdcost) as HHACost, sum(clm_spending) as HHASpending
from temp1
group by CY, MemberLinkEID, ORGID
;
quit;

proc sort data=temp2  nodupkey;by CY MemberLinkEID ORGID;run;

data HHA;
set temp2;
label HHAevent='Number of Home Health Episode';
label HHALOS='Home Health Covered Days';
label HHAcost='Standard Cost: Home Health';
label HHAspending='Actual Payment: Home Health';
run;



*********************Hospice: stdcost spending los;
data temp;
set apcd.Hospicestdcost;
keep PayerClaimControlNumber LineCounter MemberLinkEID ORGID CY LOS spending ;
proc sort;by PayerClaimControlNumber ;
run;

proc sql;
create table temp1 as
select *,sum(spending) as clm_stdcost, sum(spending) as clm_spending
from temp
group by PayerClaimControlNumber ;
quit;

proc sort data=temp1 nodupkey;by PayerClaimControlNumber ;run;
proc sort data=temp1  ;by CY MemberLinkEID ORGID;run;
proc sql;
create table temp2 as
select CY, MemberLinkEID, ORGID, count(PayerClaimControlNumber) as Hospiceevent, sum(LOS) as HospiceLOS, sum(clm_stdcost) as HospiceCost, sum(clm_spending) as HospiceSpending
from temp1
group by CY, MemberLinkEID, ORGID
;
quit;

proc sort data=temp2 nodupkey; by CY MemberLinkEID ORGID;run;
data Hospice;
set temp2;
label Hospiceevent='Number of Hospice Episode';
label HospiceLOS='Hospice Covered Days';
label Hospicecost='Standard Cost: Hospice';
label Hospicespending='Actual Payment: Hospice';
run;




*********************SNF: stdcost spending los;
data temp;
set apcd.SNFstdcost(keep=DateOfServiceFrom DateOfServiceTo PayerClaimControlNumber LineCounter MemberLinkEID ORGID CY spending);
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
proc sort data=temp1  ;by CY MemberLinkEID ORGID;run;
proc sql;
create table temp2 as
select CY, MemberLinkEID, ORGID, count(PayerClaimControlNumber) as SNFevent, sum(LOS) as SNFLOS, sum(clm_stdcost) as SNFCost, sum(clm_spending) as SNFSpending
from temp1
group by CY, MemberLinkEID, ORGID
;
quit;

proc sort data=temp2 nodupkey; by CY MemberLinkEID ORGID;run;
data SNF;
set temp2;
label SNFevent='Number of SNF Episode';
label SNFLOS='SNF Covered Days';
label SNFcost='Standard Cost: SNF';
label SNFspending='Actual Payment: SNF';
run;



**********************Link cost and utilization;
proc sql;
create table temp1 as
select a.*,b.*
from denom a left join ip b
on a.MemberLinkEID=b.MemberLinkEID and a.SubmissionYear=b.CY and a.OrgID=b.OrgID;
quit;

proc sql;
create table temp2 as
select a.*,b.*
from temp1 a left join op b
on a.MemberLinkEID=b.MemberLinkEID and a.SubmissionYear=b.CY and a.OrgID=b.OrgID;
quit;

proc sql;
create table temp3 as
select a.*,b.*
from temp2 a left join physician b
on a.MemberLinkEID=b.MemberLinkEID and a.SubmissionYear=b.CY and a.OrgID=b.OrgID;
quit;

proc sql;
create table temp4 as
select a.*,b.*
from temp3 a left join HHA b
on a.MemberLinkEID=b.MemberLinkEID and a.SubmissionYear=b.CY and a.OrgID=b.OrgID;
quit;

proc sql;
create table temp5 as
select a.*,b.*
from temp4 a left join SNF b
on a.MemberLinkEID=b.MemberLinkEID and a.SubmissionYear=b.CY and a.OrgID=b.OrgID;
quit;

proc sql;
create table temp6 as
select a.*,b.*
from temp5 a left join Hospice b
on a.MemberLinkEID=b.MemberLinkEID and a.SubmissionYear=b.CY and a.OrgID=b.OrgID;
quit;
 



data APCD.Data;
set temp6;
array a1 {32} MajorCC MinorCC amiihd amputat arthrit artopen bph cancer chrkid chf 
cystfib dementia diabetes endo eyedis hemadis hyperlip hyperten immunedis ibd 
liver lung neuromusc osteo paralyt psydis sknulc spchrtarr strk sa 
thyroid vascdis;
do i=1 to 32;
if a1{i}=. then a1{i}=0;
end;

array b1{3} frailty_num mental Alcohol_Drug;
do i=1 to 3;
if b1{i}=. then b1{i}=0;
end;

array ip{24} ipStay1 ipLOS1 ipcost1 ipspending1  ipStay2 ipLOS2 ipcost2 ipspending2  ipStay3 ipLOS3 ipcost3 ipspending3
 ipStay4 ipLOS4 ipcost4 ipspending4  ipStay5 ipLOS5 ipcost5 ipspending5  ipStay6 ipLOS6 ipcost6 ipspending6;
do i=1 to 24;
if ip{i}=. then ip{i}=0;
end;

array op {3} opvisit opcost opspending;
do i=1 to 3;
if op{i}=. then op{i}=0;
end;
 
array phys {42} PhysicianEvent1 PhysicianCost1 PhysicianSpending1 
              PhysicianEvent2 PhysicianCost2 PhysicianSpending2 
			  PhysicianEvent3 PhysicianCost3 PhysicianSpending3 
			  PhysicianEvent4 PhysicianCost4 PhysicianSpending4 
			  PhysicianEvent5 PhysicianCost5 PhysicianSpending5 
			  PhysicianEvent6 PhysicianCost6 PhysicianSpending6 
			  PhysicianEvent7 PhysicianCost7 PhysicianSpending7 
			  PhysicianEvent8 PhysicianCost8 PhysicianSpending8 
			  PhysicianEvent9 PhysicianCost9 PhysicianSpending9 
			  PhysicianEvent10 PhysicianCost10 PhysicianSpending10 
			  PhysicianEvent11 PhysicianCost11 PhysicianSpending11 
			  PhysicianEvent12 PhysicianCost12 PhysicianSpending12 
			  PhysicianEvent13 PhysicianCost13 PhysicianSpending13 
			  PhysicianEvent14 PhysicianCost14 PhysicianSpending14 ;

do i=1 to 42;
if phys{i}=. then  phys{i}=0;
end;

array hha {4} HHAEvent HHALOS HHAcost HHAspending;
do i=1 to 4;
if hha{i}=. then hha{i}=0;
end;

array hospice {4} hospiceEvent hospiceLOS hospicecost hospicespending;
do i=1 to 4;
if hospice{i}=. then hospice{i}=0;
end;

array SNF {4} SNFEvent SNFLOS SNFcost SNFspending;
do i=1 to 4;
if SNF{i}=. then SNF{i}=0;
end;

drop CY i;
IPStay=ipStay1+ipStay2+ipStay3+ipStay4+ipStay5+ipStay6;
ipLOS=ipLOS1+ipLOS2+ipLOS3+ipLOS4+ipLOS5+ipLOS6;
ipcost=ipcost1+ipcost2+ipcost3+ipcost4+ipcost5+ipcost6;
ipSpending=ipspending1+ipspending2+ipspending3+ipspending4+ipspending5+ipspending6;

PhysicianEvent=PhysicianEvent1+PhysicianEvent2+PhysicianEvent3+PhysicianEvent4+PhysicianEvent5+PhysicianEvent6+
PhysicianEvent7+PhysicianEvent8+PhysicianEvent9+PhysicianEvent10+PhysicianEvent11+PhysicianEvent12+
PhysicianEvent13+PhysicianEvent14;
PhysicianCost=PhysicianCost1+PhysicianCost2+PhysicianCost3+PhysicianCost4+PhysicianCost5+PhysicianCost6
+PhysicianCost7+PhysicianCost8+PhysicianCost9+PhysicianCost10+PhysicianCost11+PhysicianCost12+PhysicianCost13+PhysicianCost14;
PhysicianSpending=PhysicianSpending1+PhysicianSpending2+PhysicianSpending3+PhysicianSpending4+PhysicianSpending5
+PhysicianSpending6+PhysicianSpending7+PhysicianSpending8+PhysicianSpending9+PhysicianSpending10+PhysicianSpending11
+PhysicianSpending12+PhysicianSpending13+PhysicianSpending14;

total_cost=ipcost+opcost+physiciancost+HHAcost+SNFcost+Hospicecost;
total_spending=ipspending+opspending+physicianspending+HHAspending+SNFspending+Hospicespending;

run;
 
