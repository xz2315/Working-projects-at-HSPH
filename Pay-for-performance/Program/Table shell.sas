************************************
Table Shells from Dori and Julia
Xiner Zhou
6/11/2015
************************************;
libname data 'C:\data\Projects\P4P\Data';

data sick;
set data.data;
where Unhealthy=1 ;
if Adultquality_denom=0 then quality=0;
else quality=Adultquality_numer/Adultquality_denom;
 
if med_mgmt_pers_meddenom=0 then medication=0;
else medication=med_mgmt_pers_mednumer/med_mgmt_pers_meddenom;
 
proc sort nodupkey;by patient_id datapoint;
proc freq;tables datapoint;
run;

data healthy;
set data.data;
where Unhealthy=0 ;
if Adultquality_denom=0 then quality=0;
else quality=Adultquality_numer/Adultquality_denom;
 
if med_mgmt_pers_meddenom=0 then medication=0;
else medication=med_mgmt_pers_mednumer/med_mgmt_pers_meddenom;
proc sort nodupkey;by patient_id datapoint;
proc freq;tables datapoint;
run;

proc means data=sick mean std median min max  ;
var MedSurgCost IPcost EDcost OPcost DrugCost  quality medication;
run;
proc means data=healthy mean std median min max;
var MedSurgCost IPcost EDcost OPcost DrugCost quality medication;
run;





***DO: Patients selection;
data data1 data2;
set data.data;
where Unhealthy=1 and trt_max=1;
if max=1 then output data1;else output data2;
run;

proc sort data=data1;by patient_id datapoint;run;
proc sort data=data2;by patient_id datapoint practice_id;run;
proc sort data=data2 nodupkey;by patient_id datapoint ;run;

data data;
set data1 data2;
run;

proc freq data=data;
	title 'Number of Patients in Treatment and Control';
	tables pgip*datapoint/norow nocol nopercent nocum;
run;

***End;



***DO: Table1: patient demographic data;

*Number of Unique Patients;
data patient;
set data;
where datapoint=1;
proc freq;tables pgip;
run;

*Age at baseline;
proc means data=patient mean std;
class pgip;
var ageinyears ;
run;

proc anova data=patient;
class pgip;
model ageinyears=pgip;
run;

* %Male;
proc freq data=patient;
tables pgip*gender/chisq;
run;

* Average number of comorbidity;
proc means data=patient mean std;
class pgip;
var comorbcount1;
run;

proc anova data=patient;
class pgip;
model comorbcount1=pgip;
run;

*Most common comorb;

%macro comorb(comorb=);
%do i=1 %to 24;
	%let t=%scan(&comorb.,&i.);
	proc means data=patient;
		class pgip;
		var &t.;
		output out=&t. mean=mean;
	run;

data &t.;
length comorb $20.;
	set &t.;
	keep pgip comorb mean;
	comorb="&t.";
	if pgip ne .;
run;
	 
%end;
%mend comorb;
%comorb(comorb=AMI CHF PVD CVD COPD Asthma Dementia Paralysis Diabetes1 Diabetes2 Renal Liver1 Liver2 Ulcer Rheum Aids Malignancy Metastatic DrugPsychosis DrugDependence Schizo DepressionBipolar reactivePsychoses Personality);
 
data all;
set AMI CHF PVD CVD COPD Asthma Dementia Paralysis Diabetes1 Diabetes2 Renal 
Liver1 Liver2 Ulcer Rheum Aids Malignancy Metastatic DrugPsychosis DrugDependence 
Schizo DepressionBipolar reactivePsychoses Personality ;
run;

proc sort data=all;by pgip descending mean;run;

proc print data=all;run;

*Cost Measures;
proc means data=data median mean std;
class pgip;
var MedSurgCost IPcost EDcost OPcost DrugCost;
run;
 proc anova data=data;class pgip;model MedSurgCost=pgip;run;
 proc anova data=data;class pgip;model IPcost=pgip;run;
  proc anova data=data;class pgip;model EDcost=pgip;run;
   proc anova data=data;class pgip;model OPcost=pgip;run;
    proc anova data=data;class pgip;model DrugCost=pgip;run;
*Uitilization Measures;
proc means data=data  mean std;
class pgip;
var totaledvisits_enc totalipdischarges_enc total_los pcpvisits specvisits readmission30 readmission90;
run;

proc anova data=data;class pgip;model totaledvisits_enc=pgip;run;
proc anova data=data;class pgip;model totalipdischarges_enc=pgip;run;
proc anova data=data;class pgip;model total_los=pgip;run;
proc anova data=data;class pgip;model pcpvisits=pgip;run;
proc anova data=data;class pgip;model specvisits=pgip;run;
proc anova data=data;class pgip;model readmission30=pgip;run;
proc anova data=data;class pgip;model readmission90=pgip;run;


*************************************************total Population not restricted by comorbidity;
proc sort data=data.data out=data1 nodupkey;by datapoint patient_id;run;
 
proc freq data=data1;
	title 'Number of Patients  ';
	tables datapoint/norow nocol nopercent nocum;
run;

data patient1;
set data1;
where datapoint=1;
run;
*Age at baseline;
proc means data=patient1 mean std;
var ageinyears ;
run;

* %Male;
proc freq data=patient1;
tables gender ;
run;

* Average number of comorbidity;
proc means data=patient1 mean std;class unhealthy;
var comorbcount1;
run;
 

*Most common comorb;

%macro comorb(comorb=);
%do i=1 %to 24;
	%let t=%scan(&comorb.,&i.);
	proc means data=patient1;
		var &t.;
		output out=&t. mean=mean;
	run;

data &t.;
length comorb $20.;
	set &t.;
	keep comorb mean;
	comorb="&t.";
run;
	 
%end;
%mend comorb;
%comorb(comorb=AMI CHF PVD CVD COPD Asthma Dementia Paralysis Diabetes1 Diabetes2 Renal Liver1 Liver2 Ulcer Rheum Aids Malignancy Metastatic DrugPsychosis DrugDependence Schizo DepressionBipolar reactivePsychoses Personality);
 
data all;
set AMI CHF PVD CVD COPD Asthma Dementia Paralysis Diabetes1 Diabetes2 Renal 
Liver1 Liver2 Ulcer Rheum Aids Malignancy Metastatic DrugPsychosis DrugDependence 
Schizo DepressionBipolar reactivePsychoses Personality ;
run;

proc sort data=all;by descending mean;run;

proc print data=all;run;


*Cost Measures;
proc means data=data1 median mean std;
var MedSurgCost IPcost EDcost OPcost DrugCost;
run;
 
*Uitilization Measures;
proc means data=data1  mean std;
var totaledvisits_enc totalipdischarges_enc total_los pcpvisits specvisits readmission30 readmission90;
run;





*******************************
*******************************
******************************* Provider Demographics;

********PCP level;
proc sort data=patient out=PCP nodupkey;by provider_id;run;

*Number of unique PCPs;
proc freq data=PCP;
tables pgip;
run;

***************************
***************************
*************************** Table 2: Practice level;
data data1 data2;
set data.data;
where Unhealthy=1 and trt_max=1 ;
if max=1 then output data1;else output data2;
run;

proc sort data=data1;by patient_id datapoint;run;
proc sort data=data2;by patient_id datapoint practice_id;run;
proc sort data=data2 nodupkey;by patient_id datapoint ;run;

data practice;
set data1 data2;
if datapoint=1;
proc sort nodupkey;by practice_id;
run;

proc freq data=practice;
	title 'Number of Unique Practices';
	tables pgip/norow nocol nopercent nocum;
run;
*PGIP participation;


*Practice size;
proc freq data=practice;tables pgip*practicesize/chisq;run;

*Member per PCP;
proc means data=practice mean std;
class pgip;
var pcpmembers_perpcp;
run;
proc anova data=practice;class pgip;model pcpmembers_perpcp=pgip;run;

*proportion of sick;
proc means data=practice mean std;
class pgip;
var propsick;
run;
proc anova data=practice;class pgip;model propsick=pgip;run;



*************************************************total Population not restricted by comorbidity;



********PCP level;
 proc sort data=data.data(where=(datapoint=1)) out=PCP nodupkey;by provider_id;run;



**********Practice level;
 proc sort data=data.data(where=(datapoint=1)) out=practice nodupkey;by practice_id;run;
 

*Average PCP age;
proc means data=practice mean std;
var meanage;
run;
 
*Percent of Male PCPs;
proc means data=practice mean std;
var proportion_male;
run;
 
*Practice size;
proc freq data=practice;tables practicesize;run;

*Member per PCP;
proc means data=practice mean std;
var pcpmembers_perpcp;
run;
 

*proportion of sick;
proc means data=practice mean std;
var propsick;
run; 
