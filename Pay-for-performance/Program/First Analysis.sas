************************************
1st Round Analyses
Xiner Zhou
5/19/2015
************************************;
libname data 'C:\data\Projects\Julia new project\Data';

proc format ;
value practicesize_
1='Small, countPCPs=1'
2='Medium, countPCPs 2-5'
3='Large, countPCPs 6+'
;
quit;

proc format ;
value pgip_
0='Control'
1='In PayForPerformance Program'
;
quit;

proc format ;
value gender_
0='Male'
1='Female'
;
quit;
/* 
Project Objective 1: Understand the characteristics of practice that do better at managing high need patietns ?

Step1: 
limit sample to unhealthy patients defined as having 2 or more comorbidities (look at how many are at least 1 meantal, and others) 

Step2:
performance over time adjusting for gender and age
performance measured by outcomes :
	all cost
	totaledvisits_enc
	totalipdischarges_enc
    total_los
	readmission30
	readmission90
 	pcpvisits
	specvisits

Model 1: over time, clusted within practice (repeated in practice)
Model 2: over tiem, clusted within practice, but add interaction with PayForPerformance or NOT
Model 3: Add practice demographics to Model 2
	     practice size :countpcps (1,2-5,6+)
		 pcpmembers_perpcp
		 proportion_male
		 meanage
		 proportion of unhealthy patietns


*/

************************Descriptive Stat;
*Number of Observations;
proc freq data=data.data;
	title 'Number of Observations';
	where unhealthy=1;
	tables pgip*datapoint/norow nocol nopercent nocum;
run;

*Number of Patients;
proc sort data=data.data out=temp1 nodupkey;by patient_id pgip datapoint;run; 
proc freq data=temp1;
	title 'Number of Patients';
	where unhealthy=1;
	tables pgip*datapoint/norow nocol nopercent nocum;
run;

* Cross-treatment patients;
proc sort data=data.data out=temp1 nodupkey;by patient_id;run;
proc freq data=temp1;
	title 'Number of Patients assigned to both groups';
	title1 'Because PCP cross-practiced in both PFP and control practices';
	where unhealthy=1;
	tables trt_max/norow nocol nopercent nocum;
run;

 
data data;
set data.data;
where Unhealthy=1;
ctime=datapoint;
if medsurgcost=0 then logmedsurgcost=log(0.01);else logmedsurgcost=log(medsurgcost);
if ipcost=0 then logipcost=log(0.01);else logipcost=log(ipcost);
if opcost=0 then logopcost=log(0.01);else logopcost=log(opcost);
if drugcost=0 then logdrugcost=log(0.01);else logdrugcost=log(drugcost);
if edcost=0 then logedcost=log(0.01);else logedcost=log(edcost);
 
proc sort;by patient_id datapoint practice_id;
run;

data data;
set data;
by patient_id datapoint practice_id;
if first.patient_id=0 and first.datapoint=0 and first.practice_id=1 then patient_id1=patient_id+1000000;
else patient_id1=patient_id;
run;

 


symbol v=plus;
ods select Histogram;
proc univariate data=data;	
	var logdrugcost;	 	
	histogram logdrugcost/normal  ;
	inset n mean(5.3) std='Std Dev'(5.3) skewness(5.3)/pos=ne header='Summary Statistics';
run;
 
 

 
%macro model(y=,dist=);

proc univariate data=data;
	var &y.; 
run;

proc means data=data n mean std nway;
	var &y.;
	class datapoint;
	output out=meandata mean=mean;
	proc print data=meandata;
run;

proc gplot data=meandata;
	symbol1 color=orange interpol=join value=dot;
	plot mean*datapoint;
	title " &y. ";
run;

*stratified;
proc means data=data n mean std nway;
	var &y.;
	class pgip datapoint;
	output out=meandata mean=mean;
	proc print data=meandata;
run;

proc gplot data=meandata;
	symbol1 color=orange interpol=join value=dot;
	symbol2 color=blue interpol=join value=dot;
	plot mean*datapoint=pgip;
	title "&y. by pgip";
run;

proc sort data=data;by pgip gender practicesize;run;
************************ Model 1;
 
proc genmod data=data;
	class ctime patient_id1 practice_id gender;
	format pgip pgip_.;format gender gender_.;format practicesize practicesize_.;
	model &y.=datapoint ageinyears gender/dist=&dist.  ;
	repeated subject= patient_id1 /withinsubject=ctime type=un ;
    
	ods output GEEEmpPEst=model1  ;
run;
 
************************ Model 2;

proc genmod data=data  order=data;
	class ctime patient_id1 practice_id gender pgip;
	format pgip pgip_.;format gender gender_.;format practicesize practicesize_.;
	model &y.=datapoint pgip datapoint*pgip ageinyears gender /dist=&dist.   ;
	repeated subject= patient_id1 /withinsubject=ctime type=un ;
 
	ods output GEEEmpPEst=model2;
run;

************************ Model 3;
proc genmod data=data  order=data;
	class ctime patient_id1 practice_id gender pgip practicesize;
	format pgip pgip_.;format gender gender_.;format practicesize practicesize_.;
	model &y.=datapoint pgip datapoint*pgip ageinyears gender 
						 practicesize pcpmembers_perpcp proportion_male meanage propsick/dist=&dist.   ;
	repeated subject= patient_id1 /withinsubject=ctime type=un ;
  
	ods output GEEEmpPEst=model3;
run;


data model1;
length model $50.; 
set model1;
model='GEE:Basic Model ';
run;
data model2;
length model $50.; 
set model2;
model='GEE:Interaction';
run;
data model3;
length model $50.; 
set model3;
model='GEE:Interaction Adjustment';
run;

data &y.;
length outcome $30.;

set model1 model2 model3;
outcome="&y.";
proc print;run;

%mend model;
%model(y=logmedsurgcost,dist=normal);
%model(y=logipcost,dist=normal);
%model(y=logopcost,dist=normal);
%model(y=logedcost,dist=normal);
%model(y=logdrugcost,dist=normal);




**************Zero Inflated Poisson;

 
%macro ZIP(y=,dist=,zero=);

proc univariate data=data;
	var &y.; 
run;

proc means data=data n mean std nway;
	var &y.;
	class datapoint;
	output out=meandata mean=mean;
	proc print data=meandata;
run;

proc gplot data=meandata;
	symbol1 color=orange interpol=join value=dot;
	plot mean*datapoint;
	title " &y. ";
run;

*stratified;
proc means data=data n mean std nway;
	var &y.;
	class pgip datapoint;
	output out=meandata mean=mean;
	proc print data=meandata;
run;

proc gplot data=meandata;
	symbol1 color=orange interpol=join value=dot;
	symbol2 color=blue interpol=join value=dot;
	plot mean*datapoint=pgip;
	title "&y. by pgip";
run;


proc sort data=data;by pgip gender practicesize;run;
************************ Model 1;
 
proc genmod data=data;
	class ctime gender;
	format pgip pgip_.;format gender gender_.;format practicesize practicesize_.;
	model &y.=datapoint ageinyears gender/dist=&dist.  ;
	zeromodel datapoint ageinyears gender  ;
	ods output ParameterEstimates=model1  ZeroParameterEstimates=zero1;
run;
 
************************ Model 2;

proc genmod data=data  order=data;
	class ctime gender pgip;
	format pgip pgip_.;format gender gender_.;format practicesize practicesize_.;
	model &y.=datapoint pgip datapoint*pgip ageinyears gender /dist=&dist.   ;
    zeromodel datapoint pgip datapoint*pgip ageinyears gender  ;
	ods output ParameterEstimates=model2 ZeroParameterEstimates=zero2; 
run;

************************ Model 3;
proc genmod data=data  order=data;
	class ctime gender pgip practicesize;
	format pgip pgip_.;format gender gender_.;format practicesize practicesize_.;
	model &y.=datapoint pgip datapoint*pgip ageinyears gender 
						 practicesize pcpmembers_perpcp proportion_male meanage propsick/dist=&dist.   ;
	zeromodel datapoint pgip datapoint*pgip ageinyears gender 
						 practicesize pcpmembers_perpcp proportion_male meanage propsick  ;
	ods output ParameterEstimates=model3 ZeroParameterEstimates=zero3;
run;


data model1;
	length model $50.; 
	set model1;
	model='GEE:Basic Model ';
run;

data model2;
	length model $50.; 
	set model2;
	model='GEE:Interaction';
run;

data model3;
	length model $50.; 
	set model3;
	model='GEE:Interaction Adjustment';
run;

data &y.;
	length outcome $30.;
	set model1 model2 model3;
	outcome="&y. Poisson Part";
proc print;run;

*zero part;

data zero1;
	length model $50.; 
	set zero1;
	model='GEE:Basic Model ';
run;

data zero2;
	length model $50.; 
	set zero2;
	model='GEE:Interaction';
run;

data zero3;
	length model $50.; 
	set zero3;
	model='GEE:Interaction Adjustment';
run;

data zero&y.;
	length outcome $30.;
	set zero1 zero2 zero3;
	outcome="&y. Zero part";
proc print;run;

%mend ZIP;
%ZIP(y=totaledvisits_enc,dist=zip );
%ZIP(y=totalipdischarges_enc,dist=zip );
%ZIP(y=total_los,dist=zip);
%ZIP(y=readmission30,dist=zip);
%ZIP(y=readmission90,dist=zip); 
%ZIP(y=pcpvisits,dist=zip); 
%ZIP(y=specvisits,dist=zip); 
  
 
