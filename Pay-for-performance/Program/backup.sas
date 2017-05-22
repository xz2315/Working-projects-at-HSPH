************************************
1st Round Analyses
Xiner Zhou
7/7/2015
************************************;
libname data 'C:\data\Projects\P4P\Data';

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
05/21/2015 Julia

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

***DO: Descriptive Stat;
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

***End;


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
where Unhealthy=1 and trt_max=1;
if max=1 then output data1;else output data2;
run;

proc sort data=data1;by patient_id datapoint;run;

*randomly select those assigned to more than 1 practice;
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



/*
*table 1 comparing practice characteristics;

* How many practices in original;
* How many practices in sample;
proc sort data=data out=temp1 nodupkey;by practice_id pgip ;run;

proc freq data=temp1;
 format practicesize practicesize_.;
 tables practicesize*pgip/norow  nopercent nocum chisq;
run;


%macro table(y=);

ods output "Estimates"=mean&y. "Type 3 Tests of Fixed Effects"=p&y.;
	proc mixed data=temp1;
		class pgip;
		model &y.=pgip/solution;
		estimate "pgip=0" intercept 1 pgip 1 0 ;
		estimate "pgip=1" intercept 1 pgip 0 1 ;
	run;
ods output close;

proc transpose data=mean&y. out=outmean&y.(drop=_name_);
	var estimate;
	id label;
run;

data &y.;
	merge outmean&y. p&y.(keep=ProbF);
	Effect="&y.";
run;

%mend table;
%table(y=pcpmembers_perpcp);
%table(y=proportion_male);
%table(y=meanage);
%table(y=propsick);

data all;
set pcpmembers_perpcp proportion_male meanage propsick;
proc print;var effect pgip_0 pgip_1 probf;
run;


* Summary stats for outcomes – in each of four years, % non-zero and average among non-zero;
%macro mean(var=);

data temp1;
	set data;
	if &var.>0 then f=1;else f=0;
proc freq;tables pgip*f*datapoint f*datapoint/nocum norow nopercent;
run;

proc means data=temp1 N mean nway;
	where f=1;class pgip datapoint;
	var &var.;
output out=mean mean=mean;
run;

proc means data=temp1 N mean ;
	where f=1;class datapoint;
	var &var.;
run;

proc sgplot data=mean;
title "&var.";
series X=datapoint Y=mean/group=pgip;
run;

%mend mean;
%mean(var=medsurgcost);
%mean(var=ipcost);
%mean(var=opcost);
%mean(var=edcost);
%mean(var=drugcost);
%mean(var=totaledvisits_enc);
%mean(var=totalipdischarges_enc);
%mean(var=total_los);
%mean(var=readmission30);
%mean(var=readmission90);
%mean(var=pcpvisits);
%mean(var=specvisits);
 

*/

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

keep datapoint patient_id practice_id pgip response dist ageinyears gender practicesize pcpmembers_perpcp proportion_male meanage propsick;
proc sort;by descending pgip ;run;

*Model 1;
proc glimmix data=&y.  method=quad(Qpoints=50) inititer=200   order=data;
	class  dist pgip patient_id practice_id gender;
	model response(event='1')=dist dist*datapoint dist*ageinyears dist*gender/s dist=byobs(dist) noint;
	random int  /subject=patient_id ;
	ods output ParameterEstimates=&y.Model1;
run;
*Model 2;
proc glimmix data=&y.  method=quad(Qpoints=50) inititer=200 order=data ;
	class  dist pgip patient_id practice_id gender;
	model response(event='1')=dist dist*datapoint dist*pgip dist*datapoint*pgip dist*ageinyears dist*gender/s dist=byobs(dist) noint;
	random int  /subject=patient_id  ;
	ods output ParameterEstimates=&y.Model2;
run;
*Model 3;
proc glimmix data=&y.  method=quad(Qpoints=50) inititer=200 order=data ;
	class  dist pgip patient_id practice_id gender practicesize ;
	model response(event='1')=dist dist*datapoint dist*pgip dist*datapoint*pgip dist*ageinyears dist*gender 
						 dist*practicesize dist*pcpmembers_perpcp dist*proportion_male dist*meanage dist*propsick/s dist=byobs(dist) noint;
	random int  /subject=patient_id  ;
	ods output ParameterEstimates=&y.Model3;
run;

data &y.Model;
	length model $50.;
	set &y.Model1(in=in1) &y.Model2(in=in2) &y.Model3(in=in3);
	if in1 then Model="&y. Model1";
	if in2 then Model="&y. Model2";
	if in3 then Model="&y. Model3";
run;

%mend model;
%model(y=medsurgcost,type=1);
%model(y=ipcost,type=1);
%model(y=opcost,type=1);
%model(y=edcost,type=1);
%model(y=drugcost,type=1);

%model(y=medsurgcost,type=3);
%model(y=ipcost,type=3);
%model(y=opcost,type=3);
%model(y=edcost,type=3);
%model(y=drugcost,type=3);

%model(y=totaledvisits_enc,type=2);
%model(y=totalipdischarges_enc,type=2);
%model(y=total_los,type=2);
%model(y=readmission30,type=2);
%model(y=readmission90,type=2);
%model(y=pcpvisits,type=2);
%model(y=specvisits,type=2);
 
  
proc print data=medsurgcostModel2;
run;

***End;

 
