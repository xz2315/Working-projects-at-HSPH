*******************************
Second Paper: Robustness Check
Xiner Zhou
9/19/2016
******************************;
libname data 'C:\data\Projects\P4P\Data\Data';

* Socio-Economics variables;
proc import datafile="C:\data\Projects\P4P\Data\Data\ZipCode_DemographicData.xlsx" 
out=socio
dbms=xlsx
replace;
getnames=yes;
run;
data socio;
set socio;
rename VAR4=GeneralHealth;  
rename var5=BelowPovery;
rename __over_65__2010=over652010;
rename __over_65__2011=over652011;
rename __over_65__2012=over652012;
rename __over_65__2013=over652013;
run;

********************************************* 
Evaluate Effect of PropSick from panel data:
*********************************************;
data temp1;
set data.data;
 

* remove small practice;
if pcpmembers_perpcp >=100;

* Dichotomize propsick;
if propsick <=0.02 then propsickG=2;
else if propsick <0.1 then propsickG=1;
else if propsick >0.1 then propsickG=0;

Adultquality=Adultquality_numer/Adultquality_denom;
Adultpreventive=Adultpreventive_numer/Adultpreventive_denom;
med_mgmt=med_mgmt_pers_mednumer/med_mgmt_pers_meddenom;
year=datapoint;
rename Adultquality_numer=quality1;
rename Adultquality_denom=quality2;
rename Adultpreventive_numer=preventive1;
rename Adultpreventive_denom=preventive2;
rename med_mgmt_pers_mednumer=mgmt1;
rename med_mgmt_pers_meddenom=mgmt2;
rename totalipdischarges_enc=ipdischarge;
rename totaledvisits_enc=edvisit;
run;



*************************
Link Socio-Econ Variables through zip
*************************;
proc sql;
create table temp2 as 
select a.*,b.*
from temp1 a left join socio b
on a.business_zip=zip_code;
quit;
data data;
set temp2;
 
if datapoint=1 then over65=over652010;
else if datapoint=2 then over65=over652011;
else if datapoint=3 then over65=over652012;
else if datapoint=4 then over65=over652013;

binary_readmission30=(readmission30>0);
binary_readmission90=(readmission90>0);
run;
 
data NotHealth Health;
set data;
if Unhealthy=1 then output NotHealth;
else if Unhealthy=0 then output Health;
run;
 

%macro health(y,dist,link);
data temp;
set Health;
outcome=&y.;
yearc=year;
patient_practice_id=patient_id||practice_id;
proc sort;by patient_id yearc;
run;
 
proc genmod data=temp ;
title "Healthy Population, Outcome=&y., adjusted for practice + patient char + Comorbid";
	class pgip(ref="1") yearc  patient_id practice_id patient_practice_id gender_cd(ref="0. M") practicesize(ref="3") propsickG(ref="2") yearc
ami(ref="0") chf(ref="0") pvd(ref="0") cvd(ref="0") copd(ref="0") asthma(ref="0") dementia(ref="0") paralysis(ref="0") diabetes1(ref="0") diabetes2(ref="0") 
renal(ref="0") liver1(ref="0") liver2(ref="0") ulcer(ref="0") rheum(ref="0") aids(ref="0") malignancy(ref="0") metastatic(ref="0") drugpsychosis(ref="0") 
drugdependence(ref="0") schizo(ref="0") depressionbipolar(ref="0") reactivepsychoses(ref="0") personality(ref="0")/param=ref;
	model outcome= propsickG year pgip gender_cd ageinyears meanage pcpmembers_perpcp practicesize GeneralHealth Over65 
ami chf pvd cvd copd asthma dementia paralysis diabetes1 diabetes2 renal liver1 liver2 ulcer rheum aids malignancy metastatic drugpsychosis drugdependence schizo depressionbipolar reactivepsychoses personality
/ dist= &dist. link=&link. ;
	repeated subject=patient_practice_id /within=yearc  type=unstr corrw modelse;
run;
  
 
%mend health;
%health(y=MedSurgCost,dist=Normal, link=log );
%health(y=IPCost,dist=Normal, link=log );
%health(y=OPCost,dist=Normal, link=log );
%health(y=EDCost,dist=Normal, link=log );
%health(y=DrugCost,dist=Normal, link=log );
%health(y=ipdischarge,dist=poisson, link=log );
%health(y=edvisit,dist=poisson, link=log );
%health(y=readmission30,dist=poisson, link=log );
%health(y=binary_readmission30,dist=bin, link=logit );
%health(y=readmission90,dist=poisson, link=log );
%health(y=binary_readmission90,dist=bin, link=logit );
%health(y=pcpvisits,dist=poisson, link=log );
%health(y=specvisits,dist=poisson, link=log );
%health(y=Adultquality,dist=normal, link=identity );
%health(y=med_mgmt,dist=normal, link=identity );



%macro unhealth(y,dist,link);
data temp;
set NotHealth;
outcome=&y.;
yearc=year;
patient_practice_id=patient_id||practice_id;
proc sort;by patient_id yearc;
run;
 
proc genmod data=temp ;
title "Sick Population, Outcome=&y., adjusted for practice + patient char + Comorbid";
	class pgip(ref="1") yearc  patient_id practice_id patient_practice_id gender_cd(ref="0. M") practicesize(ref="3") propsickG(ref="2") yearc
ami(ref="0") chf(ref="0") pvd(ref="0") cvd(ref="0") copd(ref="0") asthma(ref="0") dementia(ref="0") paralysis(ref="0") diabetes1(ref="0") diabetes2(ref="0") 
renal(ref="0") liver1(ref="0") liver2(ref="0") ulcer(ref="0") rheum(ref="0") aids(ref="0") malignancy(ref="0") metastatic(ref="0") drugpsychosis(ref="0") 
drugdependence(ref="0") schizo(ref="0") depressionbipolar(ref="0") reactivepsychoses(ref="0") personality(ref="0")/param=ref;
	model outcome= propsickG year pgip gender_cd ageinyears meanage pcpmembers_perpcp practicesize GeneralHealth Over65 
ami chf pvd cvd copd asthma dementia paralysis diabetes1 diabetes2 renal liver1 liver2 ulcer rheum aids malignancy metastatic drugpsychosis drugdependence schizo depressionbipolar reactivepsychoses personality
 
/ dist= &dist. link=&link. ;
	repeated subject=patient_practice_id /within=yearc  type=unstr corrw modelse;
run;
  
 
%mend unhealth;
%unhealth(y=MedSurgCost,dist=Normal, link=log );
%unhealth(y=IPCost,dist=Normal, link=log );
%unhealth(y=OPCost,dist=Normal, link=log );
%unhealth(y=EDCost,dist=Normal, link=log );
%unhealth(y=DrugCost,dist=Normal, link=log );
%unhealth(y=ipdischarge,dist=poisson, link=log );
%unhealth(y=edvisit,dist=poisson, link=log );
%unhealth(y=readmission30,dist=poisson, link=log );
%unhealth(y=binary_readmission30,dist=bin, link=logit );
%unhealth(y=readmission90,dist=poisson, link=log );
%unhealth(y=binary_readmission90,dist=bin, link=logit );
%unhealth(y=pcpvisits,dist=poisson, link=log );
%unhealth(y=specvisits,dist=poisson, link=log );
%unhealth(y=Adultquality,dist=normal, link=identity );
%unhealth(y=med_mgmt,dist=normal, link=identity );
 
