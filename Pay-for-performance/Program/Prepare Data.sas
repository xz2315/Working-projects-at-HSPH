************************************
Import and Prepare Data for Analysis
Xiner Zhou
5/13/2015
************************************;
libname data 'C:\data\Projects\P4P\Data\Data';

proc import datafile="C:\data\Projects\P4P\Data\Data\all_data_clean_combined_harvard.csv" 
out=data1
dbms=csv 
replace;
getnames=yes;
run;

proc import datafile="C:\data\Projects\P4P\Data\Data\data2.csv" 
out=data2 
dbms=csv 
replace;
getnames=yes;
run;

data data1;set data1;n=_n_;proc sort;by n;run;
data data2;set data2;n=_n_;proc sort;by n;run;
data data;merge data1 data2;by n;drop n;run;


data data;
set data;
label pgip='PayForPerformance Group: 1 Yes in Program, 0 No(At least patially not in)';
label max='Number of Practices 1 or 2';  
label provider_ID='BCBSofMichigan Derived Primary Care Physician ID'; 
label practice_ID='Ambulatory Practice ID'; 
label datapoint='Year(1-4)';  

label charlson='Charlson Risk Score';
label comorbcount='Number of Comorbidity';
label comorb1_bin='At least 1 Comorbidity';
label comorb2_bin='At least 2 Comorbidity'; 

* physical cormorbidity AMI-Metastatic;

* memtal health comor DrugPsychosis-Personality;

* patient demographics;
gender=substr(gender_cd,1,1)*1;
label gender_cd='Gender';
label ageinyears='Age-in years';
label memmos='Number of Months Insured at that Year'; 
label rxmos='Number of Months Covered for PrescriptionDrug at that Year'; 

*Three different risk scores maybe highly correlated:michiganresident/prospectiverisk/demographicriskcurrent;

* patient-level outcome ;
label medsurgcost='Medical and Surgical Cost';
label drugcost='Drug Cost';
label ipcost='InpatientCost';
label edcost='ED Cost';
label opcost='Outpatient Cost';

*utilization outcome : only use encounters totaledvisits_pm-totalcostchronicdisacscipdischar;
* acs-AmbulatoryCareSensitive pcs-PrimaryCareSensitive;


* patient-level measures: adultquality_denom-pedsimmunizations_numer;
* denom-Does the patient eligible for this measure?
* numer-Does the patient Yes/NO ;


* patient outcome;
label total_los='Total Number of Days Hospitalized'; 
label readmission30='Total Number of 30-day Readmissions';
label readmission90='Total Number of 90-day Readmissions';
label pcpvisits='Total Number of PrimaryCare Physician Visits';
label specvisits='Total Number of Specialty Visits';

drop cont_yr1 control prov_num_obs seq;

*practice demographics;
label countpcps='Number of PrimaryCare Physician(Practice Size)'; 
if countpcps in (1,2) then practicesize=1;
else if countpcps>=3 and countpcps<=5 then practicesize=2;
else if countpcps>=6 then practicesize=3;


label members_sum='Number of Members in the practice'; 
label pcpmembers_perpcp='Number of Members per PCP:Number of Members/Number of PCP';
label gender_missing='Number of PCP having missing gender';
label count_male='Number of Male PCP';
label proportion_male='Male PCP%:count_male/countpcps';
label meanage='Average PCP Age';
label specialty_type='Practice Specialty Type';

* only exost for control practice: specialty_code-over100specialists;
drop specialty_code max_specialtycount proportion_earlyend over100specialists;
 
label business_zip='Practice ZIP'; 
drop treat;
 proc sort;by patient_id provider_id datapoint;run;



* Number of comorbidities only exist for the 1st observation of each patient, if a patient has more than 1 practice then all his information is aggreagated the same for all practices;
data temp1;
set data;
if comorbcount ne .;
keep patient_id comorbcount;
proc sort nodupkey;by patient_id;
run;

proc sql;
create table temp2 as
select a.*,b.comorbcount as comorbcount1
from data a left join temp1 b
on a.patient_id=b.patient_id;
quit;
data temp2;
set temp2;
if comorbcount1>=2 then Unhealthy=1;
else Unhealthy=0;
run;

*Treatment Numbers: 2 practices doesn't mean 2 treatments;
proc sort data=data out=temp3 nodupkey; by patient_id pgip;run;
proc sql;
create table temp4 as
select *,count(pgip) as trt_max label='Number of Treatment 1=Only One 2=Both'
from temp3
group by patient_id;
quit;
proc sort data=temp4 nodupkey;by patient_id;run;
proc sql;
create table temp5 as
select a.*,b.trt_max 
from temp2 a left join temp4 b
on a.patient_id=b.patient_id;
quit;


*drop practices with <100 members/PCP  ;
data temp6;
set temp5;
*if pcpmembers_perpcp>=100 ;
run;





*calcuate proportion of sick patients ;
proc sort data=temp6 out=temp7 nodupkey;by practice_id patient_id;
run;
proc sql;
create table temp8 as
select practice_id, members_sum,sum(Unhealthy)/members_sum as propsick
from temp7
group by practice_id;
quit;
proc sort data=temp8 nodupkey;by practice_id;run;


*and removing practices with 0 sick patients;
data temp9;
set temp8;
*if propsick ne 0;
run;
proc rank data=temp9 out=temp10 percent;
var propsick;
ranks propsickPCT;
run;
*cut off the long tail of practices with really high proportion of sick pts;
data temp11;
set temp10;
*if propsickpct<=95;
run;

*Re-rank into Quartiles;
proc rank data=temp11 out=temp12 groups=4;
var propsick;
ranks propsickQ;
run;





proc sql;
create table data.Data as
select a.*,b.*
from temp6 a inner join temp12 b
on a.practice_id=b.practice_id;
quit;



****************************************************
Sample Descriptive Table
***************************************************;
*Practice leve;
proc sort data=data.data out=temp nodupkey;
by practice_id;
run;

proc tabulate data=temp;
title "Practice-level Descriptive Table";
class propsickQ practicesize;
var pgip members_sum propsick  pcpmembers_perpcp countpcps meanage ;
tables propsickQ="Quartiles, by proportion of sick pts in Practice", 
       (N="Number of Practice"
        members_sum="Number of Members in the practice"*(mean std) 
        propsick="proportion of sick pts in Practice"*(mean*f=7.4 std) 
        pcpmembers_perpcp="Number of Members per PCP"*(mean std) 
        countpcps="Number of PCPs in Practice"*(mean std));
tables  practicesize="Practice Size: Small (1-2 PCPs),Medium (3-5 PCPs),Large (5+ PCPs)", N="Number of Practices";
tables pgip*mean="Percent PGIP";
tables meanage*mean="Avg. physician age";
run;

*Patient level;
proc sort data=data.data out=temp nodupkey;
by patient_id;
run;

proc tabulate data=temp;
title "Patient-level Descriptive Table";
var ageinyears;class gender_cd;
tables ageinyears*mean="Ave Age" ;
tables gender_cd*pctn="Percent Female";
run;
