**************************************************************
Chronic Condition WareHouse for APCD V21
Xiner Zhou
11/20/2015
**************************************************************;
libname APCD 'C:\data\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';

proc sql;
create table temp1 as
select MemberLinkEID, datepart(DateOfServiceFrom) as Date1, datepart(DateOfServiceTo) as Date2,
AdmittingDiagnosisCleaned as AdmissionDx, DischargeDiagnosisCleaned as DischargeDx, 
PrincipalDiagnosisCleaned as PrincipalDx, 
OtherDiagnosis1Cleaned as SecondaryDx1, OtherDiagnosis2Cleaned as SecondaryDx2, OtherDiagnosis3Cleaned as SecondaryDx3, 
OtherDiagnosis4Cleaned as SecondaryDx4, OtherDiagnosis5Cleaned as SecondaryDx5, OtherDiagnosis6Cleaned as SecondaryDx6, 
OtherDiagnosis7Cleaned as SecondaryDx7, OtherDiagnosis8Cleaned as SecondaryDx8, OtherDiagnosis9Cleaned as SecondaryDx9, 
OtherDiagnosis10Cleaned as SecondaryDx10, OtherDiagnosis11Cleaned as SecondaryDx11, OtherDiagnosis12Cleaned as SecondaryDx12 
 
from APCD.Medical 
where memberlinkeid ne  ;
quit;


proc import datafile='C:\data\Projects\High_Cost_Segmentation\Data\CCWs_ICD9s.xlsx' dbms=xlsx
            out=ccwicd9 (rename=(ICD9_code=icd9 Chronic_Condition_Warehouse_cate=CCW_condition ICD9_label__code_=ICD9_description))
            replace;
  getnames=yes;
run;
data ccwicd9;set ccwicd9;yes=1;run;
proc sort data=CCWICD9;by icd9;run;
proc transpose data=ccwicd9 out=wide;by icd9; var yes;id CCW_condition;  run;
data CCW;
set wide;drop _NAME_;
rename Chronic_obstructive_pulmonary_di=COPD;
rename Rheumatoid_arthritis_osteoarthri=Rheumatoid;
rename alzheimers_disease_and_Rltd_Diso=alzheimers;
label Anemia="Anemia";
label Asthma="Asthma";
label Atrial_fibrillation="Atrial fibrillation";
label Cataract="Cataract";
label Chronic_kidney_disease="Chronic kidney disease";
label Chronic_obstructive_pulmonary_di="Chronic obstructive pulmonary disease and bronchiectasis";
label Colorectal_cancer="Colorectal cancer";
label Depression="Depression";
label Diabetes="Diabetes";
label Endometrial_cancer="Endometrial cancer";
label Female_male_breast_cancer="Female/male breast cancer";
label Glaucoma="Glaucoma";
label Heart_failure="Heart failure";
label Hip_pelvic_fracture="Hip/pelvic fracture";
label Hypertension="Hypertension";
label Ischemic_heart_disease="Ischemic heart disease";
label Lung_cancer="Lung cancer";
label Osteoporosis="Osteoporosis";
label Prostate_cancer="Prostate cancer";
label Rheumatoid_arthritis_osteoarthri="Rheumatoid arthritis/osteoarthritis";
label Stroke_transient_ischemic_attack="Stroke/transient ischemic attack";
label acquired_hypothyroidism="acquired hypothyroidism";
label acute_myocardial_infarction="acute myocardial infarction";
label alzheimers_disease="alzheimers disease";
label alzheimers_disease_and_Rltd_Diso="alzheimers disease and Rltd Disorders or Senile Dementia";
label benign_prostatic_hyperplasia="benign prostatic hyperplasia";
label hyperlipidemia="hyperlipidemia";
run;

/*
Anemia
Asthma
Atrial_fibrillation  
COPD 
Cataract  
Chronic_kidney_disease  
Colorectal_cancer 
Depression   
Diabetes  
Endometrial_cancer  
Female_male_breast_cancer  
Glaucoma  
Heart_failure  
Hip_pelvic_fracture  
Hypertension  
Ischemic_heart_disease  
Lung_cancer  
Osteoporosis  
Prostate_cancer  
Rheumatoid  
Stroke_transient_ischemic_attack  
acquired_hypothyroidism  
acute_myocardial_infarction  
alzheimers  
alzheimers_disease  
benign_prostatic_hyperplasia  
hyperlipidemia 
*/ 
%macro CCW(cond=);
case when PrincipalDx in (select ICD9 from CCW where &cond.=1) or AdmissionDx in (select ICD9 from CCW where &cond.=1) or DischargeDx in (select ICD9 from CCW where &cond.=1)
       or SecondaryDx1 in (select ICD9 from CCW where &cond.=1) or SecondaryDx2 in (select ICD9 from CCW where &cond.=1)
       or SecondaryDx3 in (select ICD9 from CCW where &cond.=1) or SecondaryDx4 in (select ICD9 from CCW where &cond.=1)
	   or SecondaryDx5 in (select ICD9 from CCW where &cond.=1) or SecondaryDx6 in (select ICD9 from CCW where &cond.=1)
	   or SecondaryDx7 in (select ICD9 from CCW where &cond.=1) or SecondaryDx8 in (select ICD9 from CCW where &cond.=1)
	   or SecondaryDx9 in (select ICD9 from CCW where &cond.=1) or SecondaryDx10 in (select ICD9 from CCW where &cond.=1)
	   or SecondaryDx11 in (select ICD9 from CCW where &cond.=1) or SecondaryDx12 in (select ICD9 from CCW where &cond.=1)
then 1	else 0	end as &cond. 
%mend CCW;
 
proc sql;
create table temp2 as
select *, 
%CCW(cond=Anemia),
%CCW(cond=Asthma),
%CCW(cond=Atrial_fibrillation),
%CCW(cond=COPD),
%CCW(cond=Cataract),
%CCW(cond=Chronic_kidney_disease),
%CCW(cond=Colorectal_cancer),
%CCW(cond=Depression),
%CCW(cond=Diabetes),
%CCW(cond=Endometrial_cancer) 
from temp1;
quit;

proc sql;
create table temp3 as
select *, 
%CCW(cond=Female_male_breast_cancer),
%CCW(cond=Glaucoma),
%CCW(cond=Heart_failure),
%CCW(cond=Hip_pelvic_fracture),
%CCW(cond=Hypertension),
%CCW(cond=Ischemic_heart_disease),
%CCW(cond=Lung_cancer),
%CCW(cond=Osteoporosis),
%CCW(cond=Prostate_cancer),
%CCW(cond=Rheumatoid),
%CCW(cond=Stroke_transient_ischemic_attack),
%CCW(cond=acquired_hypothyroidism),
%CCW(cond=acute_myocardial_infarction),
%CCW(cond=alzheimers),
%CCW(cond=alzheimers_disease),
%CCW(cond=benign_prostatic_hyperplasia),
%CCW(cond=hyperlipidemia)
from temp2;
quit;

data temp4;
set temp3;
if date2 ne . then Year=year(date2);else Year=year(date1);
proc sort  ;by memberlinkeid Year;
run;


proc sql;
create table APCD.BeneCCW as
select memberlinkeid, Year, 
case when sum(Anemia)>0 then 1 else 0 end as Anemia label="Anemia" , 
case when sum(Asthma)>0 then 1 else 0 end as Asthma label="Asthma", 
case when sum(Atrial_fibrillation)>0 then 1 else 0 end as Atrial_fibrillation label="Atrial fibrillation" ,   
case when sum(COPD)>0 then 1 else 0 end as COPD label="Chronic obstructive pulmonary disease and bronchiectasis" ,  
case when sum(Cataract)>0 then 1 else 0 end as Cataract label ="Cataract",  
case when sum(Chronic_kidney_disease)>0 then 1 else 0 end as Chronic_kidney_disease label="Chronic kidney disease" ,   
case when sum(Colorectal_cancer)>0 then 1 else 0 end as Colorectal_cancer label="Colorectal cancer",  
case when sum(Depression)>0 then 1 else 0 end as Depression label ="Depression",    
case when sum(Diabetes)>0 then 1 else 0 end as Diabetes label="Diabetes" ,   
case when sum(Endometrial_cancer)>0 then 1 else 0 end as Endometrial_cancer label="Endometrial cancer",   
case when sum(Female_male_breast_cancer)>0 then 1 else 0 end as Female_male_breast_cancer label ="Female/male breast cancer" ,   
case when sum(Glaucoma)>0 then 1 else 0 end as Glaucoma label ="Glaucoma" ,   
case when sum(Heart_failure)>0 then 1 else 0 end as Heart_failure label ="Heart failure" ,   
case when sum(Hip_pelvic_fracture)>0 then 1 else 0 end as Hip_pelvic_fracture  label ="Hip/pelvic fracture" ,   
case when sum(Hypertension)>0 then 1 else 0 end as Hypertension label ="Hypertension" ,   
case when sum(Ischemic_heart_disease)>0 then 1 else 0 end as Ischemic_heart_disease  label ="Ischemic heart disease" ,   
case when sum(Lung_cancer)>0 then 1 else 0  end as Lung_cancer label ="Lung cancer",   
case when sum(Osteoporosis)>0 then 1 else 0 end as Osteoporosis label ="Osteoporosis" ,   
case when sum(Prostate_cancer)>0 then 1 else 0 end as Prostate_cancer label ="Prostate cancer" ,   
case when sum(Rheumatoid)>0 then 1 else 0 end as Rheumatoid  label ="Rheumatoid arthritis/osteoarthritis",   
case when sum(Stroke_transient_ischemic_attack)>0 then 1 else 0  end as Stroke_transient_ischemic_attack label ="Stroke/transient ischemic attack" ,   
case when sum(acquired_hypothyroidism)>0 then 1 else 0 end as acquired_hypothyroidism  label ="acquired hypothyroidism",  
case when sum(acute_myocardial_infarction)>0 then 1 else 0  end as acute_myocardial_infarction label ="acute myocardial infarction",  
case when sum(alzheimers)>0 then 1 else 0  end as alzheimers  label ="alzheimers disease",   
case when sum(alzheimers_disease)>0 then 1 else 0  end as alzheimers_disease label="alzheimers disease and Rltd Disorders or Senile Dementia",   
case when sum(benign_prostatic_hyperplasia)>0 then 1 else 0 end as benign_prostatic_hyperplasia label ="benign prostatic hyperplasia" ,   
case when sum(hyperlipidemia)>0 then 1 else 0  end as hyperlipidemia  label ="hyperlipidemia"
from temp4
group by memberlinkeid, Year;
quit;
 

























