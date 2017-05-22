libname data 'C:\data\Projects\P4P\Data';

data temp;
set data.data;
monthsin=avg_monthsinpgip*1;where pgip=0;
keep pgip provider_id practice_id monthsin avg_monthsinpgip monthsin datapoint;
proc sort  ;by provider_id;
run;



***Do:Table 1. Patient Demographics & Descriptive Statistics for Selected Outcome Measures;
data temp1;
set data.data;
where datapoint=1;
proc freq ;tables unhealthy;
run;

proc sort data=temp1 out=temp2 nodupkey;by patient_id;run;
proc freq data=temp2;title 'No. of unique patients';tables unhealthy;run;

proc means data=temp2 mean std;
title 'Age at baseline';
class unhealthy;
var ageinyears;
run;

proc means data=temp2 mean  ;
title '% FeMale';
class unhealthy;
var gender;
run;

proc means data=temp2 mean std ;
title 'Avg. no. of comorbidities';
class unhealthy;
var comorbcount1;
run;


%macro comorb(comorb=);
%do i=1 %to 24;
	%let t=%scan(&comorb.,&i.);
	proc means data=temp2;
		class unhealthy;
		var &t.;
		output out=&t. mean=mean;
	run;

data &t.;
length comorb $20.;
	set &t.;
	keep unhealthy comorb mean;
	comorb="&t.";
	if unhealthy ne .;
run;
	 
%end;
%mend comorb;
%comorb(comorb=AMI CHF PVD CVD COPD Asthma Dementia Paralysis Diabetes1 Diabetes2 Renal Liver1 Liver2 Ulcer Rheum Aids Malignancy Metastatic DrugPsychosis DrugDependence Schizo DepressionBipolar reactivePsychoses Personality);
data all;
set AMI CHF PVD CVD COPD Asthma Dementia Paralysis Diabetes1 Diabetes2 Renal 
Liver1 Liver2 Ulcer Rheum Aids Malignancy Metastatic DrugPsychosis DrugDependence 
Schizo DepressionBipolar reactivePsychoses Personality ;
run;
proc sort data=all;by unhealthy descending mean;run;
proc print data=all;title 'Most prevalent comorbid conditions';run;

proc sort data=data.data out=temp3 nodupkey;by patient_id datapoint;run;
proc means data=temp3 mean std median ;
class unhealthy;
var MedSurgCost IPcost  totalipdischarges_enc readmission30 readmission90 totaledvisits_enc pcpvisits specvisits ;
run;

***End;

***DO: Table 2. Practice Characteristics;
data temp1;
set data.data;
where unhealthy=1 and datapoint=1;
proc sort nodupkey;by practice_id;
run;

proc freq data=temp1;title 'Number of Unique Practices ';tables pgip;run;

data temp2;
set temp1;
monthsin=avg_monthsinpgip*1;
if pgip=0 and monthsin=0 then PGIPgroup='None';
else if pgip=0 and monthsin>0 then PGIPgroup='Partial';
else if pgip=1 then PGIPgroup='Full';
proc freq ;title 'PGIP Participation';tables PGIPgroup; 
proc freq ;title 'Practice Size';tables practicesize;run;
 
proc means data=temp2 mean std;
title 'Number of Assigned Patients per PCP ';
var pcpmembers_perpcp;
run;

proc means data=temp2 mean std;
title 'Proportion of Patients with 2+ Comorbidities';
var propsick;
run;

proc freq data=temp2;
title 'Figure 1: Distribution of months of PGIP participation among practices that did NOT participate fully in 36 months of the program';
where pgip=0;tables monthsin; 
run;

proc univariate data=temp2;
title 'Figure 2: Distribution of proportion of patients with 2+ comorbidities, by practice (so we can decide if we want to make categories rather than keep this continuous';
histogram propsick /barlabel=percent midpoints=0 to 1 by 0.05;
run;
proc means data=temp2 min mean max Q1 median Q3;
var propsick;
run;

 

proc sort data=temp2 out=temp3 nodupkey;by practice_id;run;
proc sgplot data=temp3;
title 'Figure 3: Scatterplot (by practice) of number of high-need patients (2+ comorbidities) in a practice vs. proportion of that practice’s patients that have 2+ comorbidities';
scatter x=propsick y=numsick;
run;
 

***End;
 

***Do: Table 3. ;

***DO: Patient selection ;

/*
Notes from John’s call (May 29, 2015)
(1)	What measures did p4p program include?
(2)	Do providers or practices participate in pgip?  Could we have a control provider in a pgip practice?
(3)	Remove patients assigned to pgip and non-pgip; randomly select those assigned to more than 1 practice (All pgip / all control)
(4)	Create table 1 comparing practice characteristics – who is choosing to participate vs not participate?
(5)	Summary stats for outcomes – in each of four years, % non-zero and average among non-zero

*/

* Unhealthy patient only,Remove patients assigned to pgip and non-pgip; 
data data1 data2;
set data.data;
where datapoint=1 and Unhealthy=1 and trt_max=1;
if max=1 then output data1;else output data2;
run;

*randomly select those assigned to more than 1 practice;
proc sort data=data2;by patient_id practice_id;run;
proc sort data=data2 nodupkey;by patient_id ;run;

data data;
set data1 data2;
run;

proc freq data=data;
	title 'Number of Patients in Treatment and Control';
	tables pgip ;
run;

*descriptive Numbers at the 1st year for both groups;
proc means data=data;
class pgip;
var MedSurgCost totalipdischarges_enc readmission30 readmission90 totaledvisits_enc pcpvisits specvisits;
run;

data data;
set data;
if MedSurgCost>0 then fMedSurgCost=1;else fMedSurgCost=0;
if totalipdischarges_enc>0 then ftotalipdischarges_enc=1;else ftotalipdischarges_enc=0;
if readmission30>0 then freadmission30=1;else freadmission30=0;
if readmission90>0 then freadmission90=1;else freadmission90=0;
if totaledvisits_enc>0 then ftotaledvisits_enc=1;else ftotaledvisits_enc=0;
if pcpvisits>0 then fpcpvisits=1;else fpcpvisits=0;
if specvisits>0 then fspecvisits=1;else fspecvisits=0;
proc means mean;
class pgip;
var fMedSurgCost ftotalipdischarges_enc freadmission30 freadmission90 ftotaledvisits_enc fpcpvisits fspecvisits;
run;

***DO: Jointly Modeling Binary and Outcome Data;
%macro model(y=,type=);

data &y.;
length dist $30.;
set data;

if &type. =1 then do;
	response=(&y.>0);
	dist='Binary';
	output;

	response=&y.;
	dist='Normal';
	output;
end;

if &type. =2 then do;
	response=(&y.>0);
	dist='Binary';
	output;

	response=&y.;
	dist='Poisson';
	output;
end;

if &type. =3 then do;
	response=(&y.>0);
	dist='Binary';
	output;

	response=&y.;
	dist='Lognormal';
	output;
end;

keep  patient_id  pgip response dist ageinyears gender practicesize pcpmembers_perpcp proportion_male meanage propsick;
proc sort;by descending pgip ;run;

*Model 1;
proc glimmix data=&y.  order=data;
	class  dist pgip  gender;
	model response(event='1')=dist dist*pgip/s dist=byobs(dist) noint;
	ods output ParameterEstimates=&y.Model1;
run;
*Model 2;
proc glimmix data=&y.    order=data ;
	class  dist pgip   gender;
	model response(event='1')=dist dist*pgip dist*ageinyears dist*gender/s dist=byobs(dist) noint;
	ods output ParameterEstimates=&y.Model2;
run;
*Model 3;
proc glimmix data=&y.   order=data ;
	class  dist pgip  gender practicesize ;
	model response(event='1')=dist dist*pgip dist*ageinyears dist*gender
						 dist*practicesize dist*pcpmembers_perpcp dist*proportion_male dist*meanage dist*propsick/s dist=byobs(dist) noint;
	ods output ParameterEstimates=&y.Model3;
run;

data &y.Model;
	length model $50.;
	set &y.Model1(in=in1) &y.Model2(in=in2) &y.Model3(in=in3);
	if in1 then Model="&y. Model1";
	if in2 then Model="&y. Model2";
	if in3 then Model="&y. Model3";
	exp=exp(Estimate);
proc print;
run;

%mend model;
%model(y=medsurgcost,type=1);
%model(y=medsurgcost,type=3);

%model(y=totaledvisits_enc,type=2);
%model(y=totalipdischarges_enc,type=2);
%model(y=total_los,type=2);
%model(y=readmission30,type=2);
%model(y=readmission90,type=2);
%model(y=pcpvisits,type=2);
%model(y=specvisits,type=2);



%macro model(y=,dist=,link=);
proc genmod data=data  order=data;
	class  pgip gender;
	model &y.=pgip  / dist=&dist. link=&link. ;
	ods output ParameterEstimates=Model1;
run;
proc genmod data=data  order=data;
	class  pgip provider_id practice_id gender;
	model &y.=pgip ageinyears gender/ dist=&dist.  link=&link.  ;
	ods output ParameterEstimates=Model2;
run;
proc genmod data=data  order=data;
	class  pgip provider_id practice_id gender practicesize;
	model &y.=pgip ageinyears gender practicesize  pcpmembers_perpcp  proportion_male  meanage  propsick/ dist=&dist. link=&link.  ;
	ods output ParameterEstimates=Model3;
run;

data Model;
	length model $50.;
	set Model1(in=in1) Model2(in=in2) Model3(in=in3);
	if in1 then Model="Model 1:Un-adjusted";
	if in2 then Model="Model 2:adjusted for patient Age and Gender";
	if in3 then Model="Model 3:adjusted for patient Age and Gender, Practice Characteristics";
	if Parameter='pgip' then exp=exp(Estimate);
proc print;
run;
 
%mend model;
%model(y=MedSurgCost,dist=normal,link=identity);
%model(y=MedSurgCost,dist=normal,link=log);
%model(y=totalipdischarges_enc,dist=Poisson,link=log);
%model(y=readmission30,dist=Poisson,link=log);
%model(y=readmission90,dist=Poisson,link=log);
%model(y=totaledvisits_enc,dist=Poisson,link=log);
%model(y=pcpvisits,dist=Poisson,link=log);
%model(y=specvisits,dist=Poisson,link=log);

***End;
