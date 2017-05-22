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

* Patients selection;
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

***************************Jointly Modeling Binary and Outcome Data;
%macro model(y=,type=);

data &y.;
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
keep datapoint patient_id practice_id pgip response dist ageinyears gender practicesize pcpmembers_perpcp proportion_male meanage propsick;
run;

*Model 1;
proc glimmix data=&y.  method=quad(Qpoints=50) inititer=200  empirical;
	class  dist pgip patient_id practice_id gender;
	model response(event='1')=dist dist*datapoint dist*ageinyears dist*gender/s dist=byobs(dist) noint;
	 
	ods output ParameterEstimates=&y.Model1;
run;
*Model 2;
proc glimmix data=&y.  method=quad(Qpoints=50) inititer=200 empirical;
	class  dist pgip patient_id practice_id gender;
	model response(event='1')=dist dist*datapoint dist*pgip dist*datapoint*pgip dist*ageinyears dist*gender/s dist=byobs(dist) noint;
	 
	ods output ParameterEstimates=&y.Model2;
run;
*Model 3;
proc glimmix data=&y.  method=quad(Qpoints=50) inititer=200 empirical;
	class  dist pgip patient_id practice_id gender practicesize ;
	model response(event='1')=dist dist*datapoint dist*pgip dist*datapoint*pgip dist*ageinyears dist*gender 
						 dist*practicesize dist*pcpmembers_perpcp dist*proportion_male dist*meanage dist*propsick/s dist=byobs(dist) noint;
	 
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
 
%model(y=totaledvisits_enc,type=2);
%model(y=totalipdischarges_enc,type=2);
%model(y=total_los,type=2);
%model(y=readmission30,type=2);
%model(y=readmission90,type=2);
%model(y=pcpvisits,type=2);
%model(y=specvisits,type=2);
 

proc print data=specvisitsmodel;
run;



***********Check up;
data temp;
set data.data;
where datapoint=4 and readmission90=1;
proc freq ;tables trt_max*pgip;
run;

*cross tabulate ;
data temp;
set data.data;
a=(opcost>0);
b=(totaledvisits_enc>0 or pcpvisits>0 or specvisits>0);
proc freq;
tables datapoint*a*b/nocum nopercent nocol norow;
run;

data temp;
set data;
a=(opcost>0);
b=(totaledvisits_enc>0 or pcpvisits>0 or specvisits>0);
proc freq;
tables datapoint*a*b/nocum nopercent nocol norow;
run;

 



 
