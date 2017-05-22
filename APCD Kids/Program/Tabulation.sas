********************************************
Make Tables 
Xiner Zhou
1/4/2017
********************************************;

libname APCD 'D:\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';
libname data 'D:\Projects\APCD Kids\Data';

* PMCA;
proc sql;
create table temp1 as
select a.*,b.*
from APCD.Analyticdatakidcost a left join APCD.Results_pmca_v2_0 b
on a.MemberLinkEID=b.MemberLinkEID;
quit;

* Mental Health;
proc sql;
create table temp2 as
select a.*,b.*
from temp1 a left join APCD.Mental2012 b
on a.MemberLinkEID=b.MemberLinkEID;
quit;

/* CC;
proc sql;
create table temp3 as
select a.*,b.*
from temp2 a left join APCD.CC2012 b
on a.MemberLinkEID=b.MemberLinkEID;
quit;

proc sql;
create table temp4 as
select a.*,b.*
from temp3 a left join APCD.kidCCW2012 b
on a.MemberLinkEID=b.MemberLinkEID;
quit;
*/
* CCI and Mental health;
proc sql;
create table temp5 as
select a.*,b.*
from temp2 a left join data.CCI_MH b
on a.MemberLinkEID=b.MemberLinkEID;
quit;

* CCC;
proc sql;
create table temp6 as
select a.*, b.neuromusc_ccc,b.cvd_ccc,b.respiratory_ccc,b.renal_ccc,b.GI_ccc,b.hemato_immu_ccc,   
b.metabolic_ccc,b.congeni_genetic_ccc,b.malignancy_ccc,b.neonatal_ccc, b.tech_dep_ccc,
b.transplant_ccc,b.num_ccc,b.ccc_flag
from temp5 a left join data.CCC b
on a.MemberLinkEID=b.MemberLinkEID;
quit;

 
data temp6;set temp6;drop ccs_text;run;
data temp7;
set temp6;
length AgeKid $15.;
if cond_less='' then cond_less='1 Non-Chronic';
if cond_more='' then cond_more='1 Non-Chronic';

if mental=. then mental=0;if mental1=. then mental1=0;if mental2=. then mental2=0;if mental3=. then mental3=0;
if mental1=1 or mental2=1 then mental12=1;else mental12=0;

if incomerank=. then incomerank=0;
if Age<=1 then AgeKid="Infancy 0-1";
else if Age<=2 then AgeKid="Toddler 1-2";
else if Age<=5 then AgeKid="Early childhood 2-5";
else if Age<=11 then AgeKid="Middle childhood 5-11";
else if Age<18 then AgeKid="Early adolescence 11-18";

array cci {496} chronic_organ_sys_1--ADHD;
do j=1 to 496;
if cci{j}=. then cci{j}=0;
end;
drop j;
Ncci=sum(chronic_organ_sys_1--ADHD);
length Ncci_c $10.;
if Ncci=0 then Ncci_c="0";
else if Ncci in (1,2) then Ncci_c="1-2";
else if Ncci in (3,4) then Ncci_c="3-4";
else if Ncci in (5,6) then Ncci_c="5-6";
else if Ncci in (7,8) then Ncci_c="7-8";
else if Ncci in (9,10) then Ncci_c="9-10";
else if Ncci >10 then Ncci_c=">10";
 



array ccc {14} 
 neuromusc_ccc cvd_ccc respiratory_ccc renal_ccc GI_ccc hemato_immu_ccc   
 metabolic_ccc congeni_genetic_ccc malignancy_ccc neonatal_ccc tech_dep_ccc 
 transplant_ccc num_ccc ccc_flag;
 do k=1 to 14;
if ccc{k}=. then ccc{k}=0;
end;
drop k;

T_Cost_ip0=T_Cost_IP+T_Cost_IP_OTH+T_Cost_PAC_OTH;
proc contents order=varnum;
run;



***********************
Rank Drug
***********************;
proc sql;
create table temp as 
select MemberLinkEID,  DrugCode as NDC, ChargeAmountCleaned as stdcost,
datepart(DatePrescriptionFilled) as Date format=mmddyy10., 
year(calculated Date) as Year 
from APCD.Pharmacy;
quit;
data temp1 ;
set temp ;
NDC1=NDC*1;
where year=2012;
run;
proc import datafile="D:\Projects\APCD High Cost\NDC" 
dbms=xlsx  out=NDC replace;getnames=yes;run;

proc sql;
create table temp2 as
select a.*, b.*
from temp1 a left join NDC  b
on a.NDC1=b.NDC;
quit;



proc sql;
create table drug as
select a.MemberLinkEID, a.type, a.highcost, b.stdcost, b.VA_CLASS
from temp7 a inner join temp2  b
on a.MemberLinkEID=b.MemberLinkEID;
quit;
 

%macro Drug(type );
proc sort data=drug out=temp4; 
where type=&type. and highcost=1;
by VA_class;
run;

proc sql;
create table temp5 as
select sum(stdcost) as tot 
from temp4;
quit;

data _null_;
set temp5;
call symput("tot",tot);
run;


proc sql;
create table temp5 as
select VA_class, sum(stdcost) as totcost, mean(stdcost) as aveCost, symget('tot')  as tot
from temp4 
group by VA_class;
quit;

proc sort data=temp5 nodupkey; by VA_class;run;

data temp6;
set temp5;
costpct=totcost/tot*1;
if VA_class ne '';
drop  tot ;
proc sort;
by descending costpct;
run;

data temp7;set temp6;if _n_<=15;run;

proc print data=temp7;
title &type.;  
var VA_class costpct aveCost TotCost;
run;
%mend Drug;






******************************************
Demographic
*****************************************;

* Table 1;
ODS Listing CLOSE;
ODS html file="D:\Projects\APCD Kids\APCD Kids May02.xls";
proc tabulate data=temp7 noseps missing  ;
class highcost  gender race ethnicity hispanic Type OrgID AgeKid IncomeRank  cond_less ncci_c  
 
Mental Mental1 Mental2 Mental3 Mental12

chronic_organ_sys_1--ADHD
neuromusc_ccc cvd_ccc respiratory_ccc renal_ccc GI_ccc hemato_immu_ccc   
 metabolic_ccc congeni_genetic_ccc malignancy_ccc neonatal_ccc tech_dep_ccc 
 transplant_ccc num_ccc ccc_flag
;
title "Table 1: Patient characteristics of high cost and non-high cost kids in Massachusetts";

table  (n  pctn),(highcost="10% High Cost Patients" all);
table (
       gender="Gender" 
        AgeKid="Age Group" 
       Type="Payer" 
        IncomeRank="Income Rank based on 2012 County Median House Income" 
		Ncci_c="No. of Chronic Conditions (CCI)"

		chronic_organ_sys_1="Infection"
        chronic_organ_sys_2="Cancer"
        chronic_organ_sys_3="Endocrine" 
        chronic_organ_sys_4="Hematology"
        chronic_organ_sys_5="Mental" 
        chronic_organ_sys_6="Neuro" 
        chronic_organ_sys_7="Cardiac" 
        chronic_organ_sys_8="Respiratory" 
        chronic_organ_sys_9="Digestive" 
        chronic_organ_sys_10="Urogenital" 
        chronic_organ_sys_11="Pregnancy" 
        chronic_organ_sys_12="Skin" 
        chronic_organ_sys_13="Musculoskeletal" 
        chronic_organ_sys_14="Congential anomaly" 
        chronic_organ_sys_15="Perinatal" 
        chronic_organ_sys_16="Trauma/complications" 
        chronic_organ_sys_17="Aftercare/screening" 
        chronic_organ_sys_18="Residual codes; unclassified; all E codes [259. and 260.]" 
        chronic_organ_sys_19="Nutrition" 
        chronic_organ_sys_20="Immune" 
        chronic_organ_sys_21="Renal"
        chronic_organ_sys_22="Oral/dental" 
        chronic_organ_sys_23="Hearing/ear" 
        chronic_organ_sys_24="Vision/eye" 
        chronic_organ_sys_25="Genetic" 
        chronic_organ_sys_26="Metabolic" 

       cond_less="Complex Chronic Condisitons:PMCA"
	   neuromusc_ccc
cvd_ccc
respiratory_ccc
renal_ccc
GI_ccc
hemato_immu_ccc
metabolic_ccc
congeni_genetic_ccc
malignancy_ccc
neonatal_ccc
tech_dep_ccc
transplant_ccc


),(highcost="10% High Cost Patients"*(n colpctn) 
   all*(n colpctn))/RTS=25;

Keylabel all="All Beneficiary"
         N="Number of Beneficiary"
		 colpctn="Column Percent"
rowpctn="Row Percent";

format IncomeRank IncomeRank_. OrgID OrgID_.  ; 
run;



proc tabulate data=temp7 noseps missing  ;
where highcost=1;
class highcost  gender race ethnicity hispanic Type OrgID AgeKid IncomeRank  cond_less ncci_c  
 
Mental Mental1 Mental2 Mental3 Mental12

chronic_organ_sys_1--ADHD
neuromusc_ccc cvd_ccc respiratory_ccc renal_ccc GI_ccc hemato_immu_ccc   
 metabolic_ccc congeni_genetic_ccc malignancy_ccc neonatal_ccc tech_dep_ccc 
 transplant_ccc num_ccc ccc_flag
;
title "1.4	Table 2: Patient characteristics of high cost patients by major payer";

table  (n  pctn),(highcost="10% High Cost Patients" all);
table (
       gender="Gender" 
        AgeKid="Age Group" 
       
        IncomeRank="Income Rank based on 2012 County Median House Income" 
		Ncci_c="No. of Chronic Conditions (CCI)"

		chronic_organ_sys_1="Infection"
        chronic_organ_sys_2="Cancer"
        chronic_organ_sys_3="Endocrine" 
        chronic_organ_sys_4="Hematology"
        chronic_organ_sys_5="Mental" 
        chronic_organ_sys_6="Neuro" 
        chronic_organ_sys_7="Cardiac" 
        chronic_organ_sys_8="Respiratory" 
        chronic_organ_sys_9="Digestive" 
        chronic_organ_sys_10="Urogenital" 
        chronic_organ_sys_11="Pregnancy" 
        chronic_organ_sys_12="Skin" 
        chronic_organ_sys_13="Musculoskeletal" 
        chronic_organ_sys_14="Congential anomaly" 
        chronic_organ_sys_15="Perinatal" 
        chronic_organ_sys_16="Trauma/complications" 
        chronic_organ_sys_17="Aftercare/screening" 
        chronic_organ_sys_18="Residual codes; unclassified; all E codes [259. and 260.]" 
        chronic_organ_sys_19="Nutrition" 
        chronic_organ_sys_20="Immune" 
        chronic_organ_sys_21="Renal"
        chronic_organ_sys_22="Oral/dental" 
        chronic_organ_sys_23="Hearing/ear" 
        chronic_organ_sys_24="Vision/eye" 
        chronic_organ_sys_25="Genetic" 
        chronic_organ_sys_26="Metabolic" 

       cond_less="Complex Chronic Condisitons:PMCA"
	   neuromusc_ccc
cvd_ccc
respiratory_ccc
renal_ccc
GI_ccc
hemato_immu_ccc
metabolic_ccc
congeni_genetic_ccc
malignancy_ccc
neonatal_ccc
tech_dep_ccc
transplant_ccc


),(Type="Payer" *(n colpctn) 
   all*(n colpctn))/RTS=25;

Keylabel all="All Beneficiary"
         N="Number of Beneficiary"
		 colpctn="Column Percent"
rowpctn="Row Percent";

format IncomeRank IncomeRank_. OrgID OrgID_.  ; 
run;

proc tabulate data=temp7 noseps  ;
class highcost type; 
var  T_Cost_IP T_Cost_IP_OTH T_Cost_PAC_OTH T_Cost_HH T_Cost_Hospice T_Cost_SNF
T_Cost_OPD T_Cost_ESRD T_Cost_FQHC T_Cost_RHC T_Cost_THRPY T_Cost_CMHC T_Cost_OTH40
T_Cost_ASC T_Cost_PTB_DRUG T_Cost_EM T_Cost_PROC T_Cost_IMG T_Cost_TESTS  T_Cost_DME

T_PTA_Cost T_PTBI_Cost T_PTBNI_Cost Cost_Drug CostwoDrug CostwDrug
T_Cost_ip0
T_Cost_AMBULANCE  T_Cost_CHIROPRACTIC  T_Cost_ENTERAL T_Cost_CHEMOTHERAPY  T_Cost_DRUGS 
T_Cost_VISION T_Cost_INFLUENZA T_Cost_EXCEPTIONS  
;

title "Figure 2. Proportion of total spending of high cost patients by payer";
table  
      (Type="Payer" all),highcost="10% High Cost Patients"*CostwDrug="Total Cost"*(sum*f=dollar12. ) 
All*CostwDrug="Total Cost"*(sum*f=dollar12.  )  ;
 
 
Keylabel all="All Beneficiary" 
         ;
run;
 

proc tabulate data=temp7 noseps  ;
class highcost type; 
var  T_Cost_IP T_Cost_IP_OTH T_Cost_PAC_OTH T_Cost_HH T_Cost_Hospice T_Cost_SNF
T_Cost_OPD T_Cost_ESRD T_Cost_FQHC T_Cost_RHC T_Cost_THRPY T_Cost_CMHC T_Cost_OTH40
T_Cost_ASC T_Cost_PTB_DRUG T_Cost_EM T_Cost_PROC T_Cost_IMG T_Cost_TESTS   T_Cost_DME

T_PTA_Cost T_PTBI_Cost T_PTBNI_Cost Cost_Drug CostwoDrug CostwDrug
T_Cost_ip0
T_Cost_AMBULANCE  T_Cost_CHIROPRACTIC  T_Cost_ENTERAL T_Cost_CHEMOTHERAPY  T_Cost_DRUGS 
T_Cost_VISION T_Cost_INFLUENZA T_Cost_EXCEPTIONS  
;
title "Table 3. Mean type of spending per high cost patient by insurance coverage";

table CostwDrug="Total costs per patient"
       
	        T_Cost_ip0="Total Inpatient Costs"
			T_Cost_IP="Inpatient Acute Care Hospital (include CAH)" 
            T_Cost_IP_OTH="Other Inpatient (Psych, other hospital)"
			T_Cost_PAC_OTH="Other post-acute care (Inpatient Rehab, long-term hospital)"

         
	  T_PTBI_Cost="Total Outpatient Costs"
	  		T_Cost_OPD="Outpatient Department Services"
			T_Cost_ESRD="End Stage Renal Disease (ESRD) Facility"
			T_Cost_FQHC="Federally Qualified Health Center (FQHC)" 
			T_Cost_RHC="Rural Health Center (Clinic)" 
			T_Cost_THRPY="Outpatient Therapy (outpatient rehab and community outpatient rehab)"  
			T_Cost_CMHC="Community Mental Health Center (CMHC)"  
			T_Cost_OTH40="Other"  
      T_Cost_HH="Home Health (HH)" 
			T_Cost_Hospice="Hospice"
			T_Cost_SNF="Skilled Nursing Facility (SNF)"
      T_PTBNI_Cost="Total Physician & Service Costs "
			T_Cost_ASC="Ambulatory Surgical Center (ASC)" 
			T_Cost_PTB_DRUG="Part B Drug" 
			T_Cost_EM="Physician Evaluation and Management" 
			T_Cost_PROC="Procedures" 
			T_Cost_IMG="Imaging" 
			T_Cost_TESTS="Tests" 
			
			T_Cost_AMBULANCE ="AMBULANCE" 
		    T_Cost_CHIROPRACTIC ="CHIROPRACTIC" 
            T_Cost_ENTERAL="ENTERAL AND PARENTERAL" 
            T_Cost_CHEMOTHERAPY ="CHEMOTHERAPY" 
            T_Cost_DRUGS="OTHER DRUGS"  
            T_Cost_VISION ="VISION, HEARING AND SPEECH SERVICES" 
            T_Cost_INFLUENZA ="INFLUENZA IMMUNIZATION" 
            T_Cost_EXCEPTIONS ="EXCEPTIONS/UNCLASSIFIED" 
     Cost_Drug="Equivalent to Medicare Part D Drugs"
     T_Cost_DME="Durable Medical Equipment (DME)"
 
      ,highcost="10% High Cost Patients"*(mean*f=dollar12. median*f=dollar12.  sum*f=dollar12. ) 
All*(mean*f=dollar12. median*f=dollar12.  sum*f=dollar12.  )  ;
 
 
Keylabel all="All Beneficiary" 
         ;
run;


proc tabulate data=temp7 noseps missing  ;
where highcost=1;
class highcost  gender race ethnicity hispanic Type OrgID AgeKid IncomeRank  cond_less ncci_c  
 
Mental Mental1 Mental2 Mental3 Mental12
 Pure_psychiatry Developmental_broad  Developmental_small ADHD
chronic_organ_sys_1--ADHD
neuromusc_ccc cvd_ccc respiratory_ccc renal_ccc GI_ccc hemato_immu_ccc   
 metabolic_ccc congeni_genetic_ccc malignancy_ccc neonatal_ccc tech_dep_ccc 
 transplant_ccc num_ccc ccc_flag

;
title "Table 4: Mental health (high-cost patients)";
 
table (Mental    Pure_psychiatry Developmental_broad  Developmental_small ADHD


),(type="Payer"*(n colpctn) 
   all*(n colpctn))/RTS=25;

Keylabel all="All Beneficiary"
         N="Number of Beneficiary"
		 colpctn="Column Percent"
rowpctn="Row Percent";

format IncomeRank IncomeRank_. OrgID OrgID_.  ; 
run;





%drug(type="Medicaid");
%drug(type="Medicaid Managed Care");
%drug(type="Private");
 
 
 



 ODS html close;
ODS Listing; 
 

 


**************************************************
Clinical and health service use: Cost and Util(Ave and Per user)
**************************************************;
proc tabulate data=temp7 noseps  ;
class highcost type; 
var  T_Cost_IP T_Cost_IP_OTH T_Cost_PAC_OTH T_Cost_HH T_Cost_Hospice T_Cost_SNF
T_Cost_OPD T_Cost_ESRD T_Cost_FQHC T_Cost_RHC T_Cost_THRPY T_Cost_CMHC T_Cost_OTH40
T_Cost_ASC T_Cost_PTB_DRUG T_Cost_EM T_Cost_PROC T_Cost_IMG T_Cost_TESTS T_Cost_OTH T_Cost_DME

T_PTA_Cost T_PTBI_Cost T_PTBNI_Cost Cost_Drug CostwoDrug CostwDrug
;


table CostwDrug="Total Annual Medical+Drug Cost"
      CostwoDrug="Total Annual Medical Cost, without Drug"
	  T_PTA_Cost="Equivalent to Medicare Part A "
			T_Cost_IP="Inpatient Acute Care Hospital (include CAH)" 
            T_Cost_IP_OTH="Other Inpatient (Psych, other hospital)"
			T_Cost_PAC_OTH="Other post-acute care (Inpatient Rehab, long-term hospital)"
			T_Cost_HH="Home Health (HH)" 
			T_Cost_Hospice="Hospice"
			T_Cost_SNF="Skilled Nursing Facility (SNF)"
	  T_PTBI_Cost="Equivalent to Medicare Part B institutional ?hospital outpatient "
	  		T_Cost_OPD="Outpatient Department Services"
			T_Cost_ESRD="End Stage Renal Disease (ESRD) Facility"
			T_Cost_FQHC="Federally Qualified Health Center (FQHC)" 
			T_Cost_RHC="Rural Health Center (Clinic)" 
			T_Cost_THRPY="Outpatient Therapy (outpatient rehab and community outpatient rehab)"  
			T_Cost_CMHC="Community Mental Health Center (CMHC)"  
			T_Cost_OTH40="Other" 
      T_PTBNI_Cost="Equivalent to Medicare Part B Non-institutional- Carrier/DME"
			T_Cost_ASC="Ambulatory Surgical Center (ASC)" 
			T_Cost_PTB_DRUG="Part B Drug" 
			T_Cost_EM="Physician Evaluation and Management" 
			T_Cost_PROC="Procedures" 
			T_Cost_IMG="Imaging" 
			T_Cost_TESTS="Tests" 
			T_Cost_OTH="Other Part B" 
			T_Cost_DME="Durable Medical Equipment (DME)"
     Cost_Drug="Equivalent to Medicare Part D Drugs"

 
      ,highcost="10% High Cost Patients"*(mean*f=dollar12. median*f=dollar12. min*f=dollar12. Q1*f=dollar12. Q3*f=dollar12. max*f=dollar12. sum*f=dollar12. ) 
All*(mean*f=dollar12. median*f=dollar12. min*f=dollar12. Q1*f=dollar12. Q3*f=dollar12. max*f=dollar12. sum*f=dollar12.  )  ;
 
 
Keylabel all="All Beneficiary" 
         ;
run;

%macro peruser(var,label);

data temp5;
set temp4;
if &var. ne 0;
run;

proc tabulate data=temp5 noseps  ;
class highcost type; 
var &var.;

table &var.=&label.,
highcost="10% High Cost Patients"*(mean*f=dollar12. median*f=dollar12. min*f=dollar12. Q1*f=dollar12. Q3*f=dollar12. max*f=dollar12. sum*f=dollar12.  ) 
All*(mean*f=dollar12. median*f=dollar12. min*f=dollar12. Q1*f=dollar12. Q3*f=dollar12. max*f=dollar12. sum*f=dollar12.  )  ;
 
Keylabel all="All Beneficiary" 
         ;
run;
%mend peruser;
%peruser(var=CostwDrug,label="Total Annual Medical+Drug Cost");
%peruser(var=CostwoDrug,label="Total Annual Medical Cost, without Drug");
%peruser(var=T_PTA_Cost,label="Equivalent to Medicare Part A ");
%peruser(var=T_Cost_IP,label="Inpatient Acute Care Hospital (include CAH)" );
%peruser(var=T_Cost_IP_OTH,label="Other Inpatient (Psych, other hospital)");
%peruser(var=T_Cost_PAC_OTH,label="Other post-acute care (Inpatient Rehab, long-term hospital)");
%peruser(var=T_Cost_HH,label="Home Health (HH)" );
%peruser(var=T_Cost_Hospice,label="Hospice");
%peruser(var=T_Cost_SNF,label="Skilled Nursing Facility (SNF)");
%peruser(var=T_PTBI_Cost,label="Equivalent to Medicare Part B institutional-hospital outpatient ");
%peruser(var=T_Cost_OPD,label="Outpatient Department Services");
%peruser(var=T_Cost_ESRD,label="End Stage Renal Disease (ESRD) Facility");
%peruser(var=T_Cost_FQHC,label="Federally Qualified Health Center (FQHC)" );
%peruser(var=T_Cost_RHC,label="Rural Health Center (Clinic)" );
%peruser(var=T_Cost_THRPY,label="Outpatient Therapy (outpatient rehab and community outpatient rehab)" );
%peruser(var=T_Cost_CMHC,label="Community Mental Health Center (CMHC)"  );
%peruser(var=T_Cost_OTH40,label="Other" );
%peruser(var=T_PTBNI_Cost,label="Equivalent to Medicare Part B Non-institutional- Carrier/DME");
%peruser(var=T_Cost_ASC,label="Ambulatory Surgical Center (ASC)" );
%peruser(var=T_Cost_PTB_DRUG,label="Part B Drug" );
%peruser(var=T_Cost_EM,label="Physician Evaluation and Management" );
%peruser(var=T_Cost_PROC,label="Procedures" );
%peruser(var=T_Cost_IMG,label="Imaging" );
%peruser(var=T_Cost_TESTS,label="Tests" );
%peruser(var=T_Cost_OTH,label="Other Part B" );
%peruser(var=T_Cost_DME,label="Durable Medical Equipment (DME)");
%peruser(var=Cost_Drug,label="Equivalent to Medicare Part D Drugs");
 
		   
  





proc tabulate data=temp7 noseps  ;
class highcost  type; 
var  T_CLM_IP T_CLM_IP_OTH T_CLM_PAC_OTH T_CLM_HH T_CLM_Hospice T_CLM_SNF
T_CLM_OPD T_CLM_ESRD T_CLM_FQHC T_CLM_RHC T_CLM_THRPY T_CLM_CMHC T_CLM_OTH40
T_CLM_ASC T_CLM_PTB_DRUG T_CLM_EM T_CLM_PROC T_CLM_IMG T_CLM_TESTS T_CLM_OTH T_CLM_DME
CLM_DRUG

 T_LOS_IP T_LOS_IP_OTH T_LOS_PAC_OTH T_LOS_HH T_LOS_Hospice T_LOS_SNF 
;


table 
	 
			T_CLM_IP="N.of Claims:Inpatient Acute Care Hospital (include CAH)" 
			T_LOS_IP="LOS:Inpatient Acute Care Hospital (include CAH)" 
            T_CLM_IP_OTH="N.of Claims:Other Inpatient (Psych, other hospital)"
			T_LOS_IP_OTH="LOS:Other Inpatient (Psych, other hospital)"
			T_CLM_PAC_OTH="N.of Claims:Other post-acute care (Inpatient Rehab, long-term hospital)"
			T_LOS_PAC_OTH="LOS:Other post-acute care (Inpatient Rehab, long-term hospital)"
			T_CLM_HH="N.of Claims:Home Health (HH)" 
			T_LOS_HH="LOS:Home Health (HH)" 
			T_CLM_Hospice="N.of Claims:Hospice"
			T_LOS_Hospice="LOS:Hospice"
			T_CLM_SNF="N.of Claims:Skilled Nursing Facility (SNF)"
			T_LOS_SNF="LOS:Skilled Nursing Facility (SNF)"
	  
	  		T_CLM_OPD="N.of Claims:Outpatient Department Services"
			T_CLM_ESRD="N.of Claims:End Stage Renal Disease (ESRD) Facility"
			T_CLM_FQHC="N.of Claims:Federally Qualified Health Center (FQHC)" 
			T_CLM_RHC="N.of Claims:Rural Health Center (Clinic)" 
			T_CLM_THRPY="N.of Claims:Outpatient Therapy (outpatient rehab and community outpatient rehab)"  
			T_CLM_CMHC="N.of Claims:Community Mental Health Center (CMHC)"  
			T_CLM_OTH40="N.of Claims:Other" 
      
			T_CLM_ASC="N.of Claims:Ambulatory Surgical Center (ASC)" 
			T_CLM_PTB_DRUG="N.of Claims:Part B Drug" 
			T_CLM_EM="N.of Claims:Physician Evaluation and Management" 
			T_CLM_PROC="N.of Claims:Procedures" 
			T_CLM_IMG="N.of Claims:Imaging" 
			T_CLM_TESTS="N.of Claims:Tests" 
			T_CLM_OTH="N.of Claims:Other Part B" 
			T_CLM_DME="N.of Claims:Durable Medical Equipment (DME)"
      CLM_Drug="N.of Claims:Equivalent to Medicare Part D Drugs"

 
      ,highcost="10% High Cost Patients"*(mean*f=15.5 min*f=15.5 Q1*f=15.5 Q3*f=15.5 max*f=15.5 sum*f=20. )   
      All*(mean*f=15.5 min*f=15.5 Q1*f=15.5 Q3*f=15.5 max*f=15.5 sum*f=20. ) ;
 
 
Keylabel all="All Beneficiary" 
         ;
run;
%macro peruser(var,label);

data temp5;
set temp4;
if &var. ne 0;
run;

proc tabulate data=temp5 noseps  ;
class highcost type; 
var &var.;

table &var.=&label.,
highcost="10% High Cost Patients"*(mean*f=15.5 min*f=15.5 Q1*f=15.5 Q3*f=15.5 max*f=15.5 sum*f=20. ) 
All*(mean*f=15.5 min*f=15.5 Q1*f=15.5 Q3*f=15.5 max*f=15.5 sum*f=20.  )  ;
 
Keylabel all="All Beneficiary" 
         ;
run;
%mend peruser;
%peruser(var=T_CLM_IP ,label="N.of Claims:Inpatient Acute Care Hospital (include CAH)"  );
%peruser(var=T_LOS_IP ,label="LOS:Inpatient Acute Care Hospital (include CAH)"  );
%peruser(var=T_CLM_IP_OTH ,label="N.of Claims:Other Inpatient (Psych, other hospital)" );
%peruser(var=T_LOS_IP_OTH ,label="LOS:Other Inpatient (Psych, other hospital)" );
%peruser(var=T_CLM_PAC_OTH ,label="N.of Claims:Other post-acute care (Inpatient Rehab, long-term hospital)" );
%peruser(var=T_LOS_PAC_OTH ,label="LOS:Other post-acute care (Inpatient Rehab, long-term hospital)");
%peruser(var=T_CLM_HH ,label="N.of Claims:Home Health (HH)"  );
%peruser(var=T_LOS_HH ,label="LOS:Home Health (HH)"  );
%peruser(var=T_CLM_Hospice ,label="N.of Claims:Hospice" );
%peruser(var=T_LOS_Hospice ,label="LOS:Hospice" );
%peruser(var=T_CLM_SNF ,label="N.of Claims:Skilled Nursing Facility (SNF)" );
%peruser(var=T_LOS_SNF ,label="LOS:Skilled Nursing Facility (SNF)" );
%peruser(var=T_CLM_OPD ,label="N.of Claims:Outpatient Department Services" );
%peruser(var=T_CLM_ESRD ,label="N.of Claims:End Stage Renal Disease (ESRD) Facility" );
%peruser(var=T_CLM_FQHC ,label="N.of Claims:Federally Qualified Health Center (FQHC)"  );
%peruser(var=T_CLM_RHC ,label="N.of Claims:Rural Health Center (Clinic)"  );
%peruser(var=T_CLM_THRPY ,label="N.of Claims:Outpatient Therapy (outpatient rehab and community outpatient rehab)"  );
%peruser(var=T_CLM_CMHC ,label="N.of Claims:Community Mental Health Center (CMHC)"   );
%peruser(var=T_CLM_OTH40 ,label="N.of Claims:Other"  );
%peruser(var=T_CLM_ASC ,label="N.of Claims:Ambulatory Surgical Center (ASC)"  );
%peruser(var=T_CLM_PTB_DRUG ,label= "N.of Claims:Part B Drug" );
%peruser(var=T_CLM_EM ,label="N.of Claims:Physician Evaluation and Management"  );
%peruser(var=T_CLM_PROC ,label="N.of Claims:Procedures"  );
%peruser(var=T_CLM_IMG ,label="N.of Claims:Imaging"  );			 
%peruser(var=T_CLM_TESTS ,label="N.of Claims:Tests"  );
%peruser(var=T_CLM_OTH ,label="N.of Claims:Other Part B"  );
%peruser(var=T_CLM_DME ,label="N.of Claims:Durable Medical Equipment (DME)" );
%peruser(var=CLM_Drug ,label="N.of Claims:Equivalent to Medicare Part D Drugs" );
 
  
************************************************
Predicotor of HC: diagnosis
************************************************;
data temp;
set APCD.kid2012;
/*
dx=dx1;output;dx=dx2;output;dx=dx3;output;dx=dx4;output;dx=dx5;output;dx=dx6;output; 
dx=dx7;output;dx=dx8;output;dx=dx9;output;dx=dx10;output;dx=dx11;output;dx=dx12;output; dx=dx13;output; 
*/
keep MemberLinkEID PayerClaimControlNumber dx1;
proc sort nodupkey;by MemberLinkEID PayerClaimControlNumber dx1;
run;

libname ccs 'I:\Data\Medicare\CCS\Data';

proc sql;
create table temp1 as
select a.*,b.*
from temp a left join ccs.Ccsicd92015 b
on a.dx1=b.icd9
where a.dx1 not in ('','0','000','0000','00000');
quit;

proc sql;
create table temp2 as
select a.*,b.highcost
from temp1 a left join APCD.Analyticdatakidcost b
on a.MemberLinkEID=b.MemberLinkEID;
quit;


proc freq data=temp2;
where highcost=1;
tables dxdescription/out=temp3;
run;

proc sort data=temp3 ;by descending percent;run;
proc print data=temp3;run;








