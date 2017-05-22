********************
Third Round Analysis
Xiner Zhou
8/3/2015
*******************;

libname data 'C:\data\Projects\P4P\Data';
/*
Here are my notes from yesterday's call. Let me know if I missed anything or your notes say something different.

Main takeaway: We want to be able to present both first-year only results as well as the time trend data. 
Right now, we are focusing on getting solid results together for the comparison of P4P practices relative to control...
our attention on the effects of other structural characteristics (size, proportion of sick patients in the practice) is on-hold for now.
 
To dos:
1. Re-run estimates in 1st year only model for PCP and specialist visits, dropping the first (log) part of the model and just running the poisson part.
Julia:I think only for PCP visits. Specialists were high enough zero to keep current modeling approach. 

2.Rerun all models (first year only as well as time trend, but only need to do the fully-adjusted Model 3), now using 3 categories of PGIP participation: none (control), partial and full. 

This sounds good. I was originally envisioning one set of results with partial as control and a second set with none as control - which is easier to interpret? Probably doesn't matter. 
We can see what's going on either way. 

3. Generate two graphs per outcome. First, a graph that shows percent of individuals by year with a value of 0. 
Second, a time-trend graph where you plot the regression but anchor it in the baseline year with the actual value.

I think what we want here is two graphs - the first showing likelihood of any utilization over time for pgip vs non-pgip, and the second showing amount (conditional on any) over time for pgip vs non pgip. Both are anchored in real year 1 pgip values. 
Let's do separate graphs for all outcomes for now and then think about how to combine. 

We might even be able to combine all of the different outcomes on to the same graph? So, one graph with %0s for all outcomes, and 1 time-trend graph for all outcomes. This may end up looking too crowded...I'd say do whatever you think looks best...
We talked about making "Proportion of sick patients" a categorical variable, but my understanding is that is on-hold for right now. In these new models above, you should keep this variable continuous.

*/


***Do:Patient Selection for 1st Year Baseline Models;
* Unhealthy patient only,Remove patients assigned to pgip and non-pgip; 
data data1 data2;
set data.data;
where datapoint=1 and Unhealthy=1 and trt_max=1;
if max=1 then output data1;else output data2;
run;

*randomly select those assigned to more than 1 practice;
proc sort data=data2;by patient_id practice_id;run;
proc sort data=data2 nodupkey;by patient_id ;run;

data Year1;
set data1 data2;
run;

proc freq data=Year1;
	title 'Number of Patients in Treatment and Control';
	tables pgip ;
run;
***End;
 
***Do: 1st Year Baseline Model for PCP visits;
*Model 1;
proc genmod data=Year1  order=data;
	class  pgip  ;
	model pcpvisits=pgip/ dist=Poisson  SCALE=PEARSON;
	ods output ParameterEstimates=Model1;
run;
*Model 2;
proc genmod data=Year1 order=data ;
	class  pgip   gender;
	model pcpvisits=pgip ageinyears gender/dist=Poisson  SCALE=PEARSON;
	ods output ParameterEstimates=Model2;
run;
*Model 3;
proc genmod data=Year1 order=data ;
	class  pgip  gender practicesize ;
	model pcpvisits=pgip ageinyears gender
					practicesize pcpmembers_perpcp proportion_male meanage propsick/dist=Poisson  SCALE=PEARSON;
	ods output ParameterEstimates=Model3;
run;

data Model;
	length model $50.;
	set Model1(in=in1) Model2(in=in2) Model3(in=in3);
	if in1 then Model="Model1";
	if in2 then Model="Model2";
	if in3 then Model="Model3";
	exp=exp(Estimate);
proc print;
run;
***End;

***Do: 1st Year Fully/Partial/None PGIP 3-Group Comparison;

* Unhealthy patient only,Remove patients assigned to pgip and non-pgip; 
data None0 Partial0 Full0;
set data.data;
where datapoint=1 and Unhealthy=1 ;
monthsin=avg_monthsinpgip*1;
if pgip=0 and monthsin=0 then do;PGIPgroup='None';group=2;output None0;end;
else if pgip=0 and monthsin>0 then do;PGIPgroup='Partial';group=1;output Partial0;end;
else if pgip=1 then do;PGIPgroup='Full' ;group=0;output Full0;end;
run;

proc sql;
create table temp1 as 
select * 
from None0 
where patient_id not in (select patient_id from Partial0) and patient_id not in (select patient_id from  Full0) ;
quit;

proc sql;
create table temp2 as 
select * 
from Partial0 
where patient_id not in (select patient_id from None0) and patient_id not in (select patient_id from  Full0) ;
quit;

proc sql;
create table temp3 as 
select * 
from Full0 
where patient_id not in (select patient_id from None0) and patient_id not in (select patient_id from  Partial0) ;
quit;

*randomly select those assigned to more than 1 practice;
proc sort data=temp1 nodupkey;by patient_id ;run;
proc sort data=temp2 nodupkey;by patient_id ;run;
proc sort data=temp3 nodupkey;by patient_id ;run;

data Year1;
set temp1 temp2 temp3;
proc sort;by descending group  descending practicesize gender;
run;

proc freq data=Year1;
	title 'Number of Patients in Full/Partial/None PGIP';
	tables pgipgroup ;
run;

*Normal and Log-normal for MedSurgCost 1st Only ;
proc genmod data=Year1 order=data ; 
	class  group gender practicesize ;
	model MedSurgCost=group ageinyears gender
					practicesize pcpmembers_perpcp proportion_male meanage propsick/dist=Normal link=identity  ;
	ods output ParameterEstimates=MedSurgCostModel;
run;
proc print data=MedSurgCostModel;run;

proc genmod data=Year1 order=data ;
	class  group gender practicesize ;
	model MedSurgCost=group ageinyears gender
					practicesize pcpmembers_perpcp proportion_male meanage propsick/dist=Normal link=log  ;
	ods output ParameterEstimates=MedSurgCostModel;
run;
data MedSurgCostModel;set MedSurgCostModel;exp=exp(Estimate);run;
proc print data=MedSurgCostModel;run;




* Poisson for PCP visits 1st only;
proc genmod data=Year1 order=data ;
	class  group gender practicesize ;
	model PCPvisits=group ageinyears gender
					practicesize pcpmembers_perpcp proportion_male meanage propsick/dist=Poisson scale=pearson ;
	ods output ParameterEstimates=PCPvisitsModel;
run;
data PCPvisitsModel;set PCPvisitsModel;exp=exp(Estimate);run;
proc print data=PCPvisitsModel;run;

*DO: Jointly Modeling Binary and Outcome Data;
%macro model(y=,type=);

data &y.;
length dist $30.;
set Year1;

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

keep  patient_id  group response dist ageinyears gender practicesize pcpmembers_perpcp proportion_male meanage propsick;
proc sort;by descending group ;run;

*Model 3;
proc glimmix data=&y.   order=data ;
	class  dist group  gender practicesize ;
	model response(event='1')=dist dist*group dist*ageinyears dist*gender
						 dist*practicesize dist*pcpmembers_perpcp dist*proportion_male dist*meanage dist*propsick/s dist=byobs(dist) noint;
	ods output ParameterEstimates=&y.Model;
run;

data &y.Model;
set &y.Model;
exp=exp(Estimate);drop DF tValue;
proc sort;by descending dist;
proc print;
run;

%mend model;
%model(y=totalipdischarges_enc,type=2);
%model(y=totaledvisits_enc,type=2);
%model(y=readmission30,type=2);
%model(y=readmission90,type=2);
%model(y=specvisits,type=2);
 
***End;































***Do: Over Time Fully/Partial/None PGIP 3-Group Comparison;

* Unhealthy patient only,Remove patients assigned to pgip and non-pgip; 
data None0 Partial0 Full0;
set data.data;
where Unhealthy=1 ;
monthsin=avg_monthsinpgip*1;
if pgip=0 and monthsin=0 then do;PGIPgroup='None';group=2;output None0;end;
else if pgip=0 and monthsin>0 then do;PGIPgroup='Partial';group=1;output Partial0;end;
else if pgip=1 then do;PGIPgroup='Full' ;group=0;output Full0;end;
run;

proc sql;
create table temp1 as 
select * 
from None0 
where patient_id not in (select patient_id from Partial0) and patient_id not in (select patient_id from  Full0) ;
quit;

proc sql;
create table temp2 as 
select * 
from Partial0 
where patient_id not in (select patient_id from None0) and patient_id not in (select patient_id from  Full0) ;
quit;

proc sql;
create table temp3 as 
select * 
from Full0 
where patient_id not in (select patient_id from None0) and patient_id not in (select patient_id from  Partial0) ;
quit;

proc sort data=temp1 ;by patient_id datapoint practice_id ;run;
proc sort data=temp1 nodupkey;by patient_id datapoint;run;
proc sort data=temp2 ;by patient_id datapoint practice_id ;run;
proc sort data=temp2 nodupkey;by patient_id datapoint;run;
proc sort data=temp3 ;by patient_id datapoint practice_id ;run;
proc sort data=temp3 nodupkey;by patient_id datapoint;run;

data Year1;
set temp1 temp2 temp3;
proc sort;by descending group  descending practicesize gender;
run;

proc freq data=Year1;
	title 'Number of Patients in Full/Partial/None PGIP';
	tables pgipgroup*datapoint ;
run;


*Normal and Log-normal for MedSurgCost ;

 
proc genmod data=Year1 order=data ;
	class  group gender practicesize patient_id;
	model MedSurgCost=group datapoint  datapoint*group ageinyears gender 
					practicesize pcpmembers_perpcp proportion_male meanage propsick/ dist=Normal link=identity;
	repeated subject=patient_id/type=un covb corrw ;
	estimate 'Change per year for Fully GPIP' datapoint 1 datapoint*group 0 0 1;
	estimate 'Change per year for Partial GPIP' datapoint 1 datapoint*group 0 1 0;
	estimate 'Change per year for None GPIP' datapoint 1 datapoint*group 1 0 0;

	ods output  GEEEmpPEst=MedSurgCostModel;
run;
proc print data=MedSurgCostModel;run;


proc genmod data=Year1 order=data  ;
	class  group gender practicesize patient_id;
	model MedSurgCost=group datapoint  datapoint*group ageinyears gender 
					practicesize pcpmembers_perpcp proportion_male meanage propsick/ dist=Normal link=log  ;
	repeated subject=patient_id/type=un covb corrw ;
	estimate 'Change per year for Fully GPIP' datapoint 1 datapoint*group 0 0 1/exp;
	estimate 'Change per year for Partial GPIP' datapoint 1 datapoint*group 0 1 0/exp;
	estimate 'Change per year for None GPIP' datapoint 1 datapoint*group 1 0 0/exp;

	ods output  GEEEmpPEst=MedSurgCostModel;
run;
data MedSurgCostModel;set MedSurgCostModel;exp=exp(Estimate);
proc print ;run;


%macro model(y=);

data &y.;
length dist $30.;
set Year1;

	response=(&y.>0);
	dist='Binary';
	output;

	response=&y.;
	dist='Poisson';
	output;

proc sort;by descending group;
run;

* Poisson & Binary together, but no individual slope ;
proc glimmix data=&y.  method=quad(Qpoints=100) inititer=200 order=data ;
	class  dist group patient_id practice_id gender practicesize ;
	model response(event='1')=dist dist*datapoint dist*group dist*datapoint*group dist*ageinyears dist*gender 
						 dist*practicesize dist*pcpmembers_perpcp dist*proportion_male dist*meanage dist*propsick/s dist=byobs(dist) noint;
	*random int  /subject=patient_id  ;
	ods output ParameterEstimates=Model1;
	estimate 'Change per year for Full  GPIP' dist*datapoint 0 1 dist*datapoint*group 0 0 0 0 0 1/exp;
	estimate 'Change per year for Partial GPIP' dist*datapoint 0 1 dist*datapoint*group 0 0 0 0 1 0/exp;
	estimate 'Change per year for None GPIP' dist*datapoint 0 1 dist*datapoint*group 0 0 0 1 0 0/exp;

		estimate 'Binary: Change per year for Full  GPIP' dist*datapoint 1 0 dist*datapoint*group  0 0 1 0 0 0/exp;
	estimate 'Binary: Change per year for Partial GPIP' dist*datapoint 1 0  dist*datapoint*group  0 1 0 0 0 0/exp;
	estimate 'Binary: Change per year for None GPIP' dist*datapoint 1 0 dist*datapoint*group  1 0 0 0 0 0/exp;
run;
data Model1;
set Model1;
exp=exp(Estimate);
proc sort;by dist;
proc print;
run;

/*get slope for Poisson ;
proc glimmix data=Year1 order=data ;
	class  group patient_id practice_id gender practicesize ;
	model &y.=group datapoint  datapoint*group ageinyears gender 
			practicesize pcpmembers_perpcp proportion_male meanage propsick/s dist=Poisson;
ods output ParameterEstimates=Model2;
	estimate 'Change per year for None GPIP' datapoint 1 datapoint*group 0 0 1;
	estimate 'Change per year for Partial GPIP' datapoint 1 datapoint*group 0 1 0;
	estimate 'Change per year for Full GPIP' datapoint 1 datapoint*group 1 0 0;

	random int  /subject=patient_id  ;
	random _residual_;
	
run;

data Model2;
set Model2;
exp=exp(Estimate);
proc print;
run;
*/

%mend model;
%model(y=totalipdischarges_enc);
 
%model(y=readmission30);

%model(y=readmission90);

%model(y=specvisits);


*PCP visits ;
proc glimmix data=Year1 order=data ;
	class  group patient_id practice_id gender practicesize ;
	model PCPvisits=group datapoint  datapoint*group ageinyears gender 
					practicesize pcpmembers_perpcp proportion_male meanage propsick/s dist=Poisson  ;
	random int  /subject=patient_id  ;
	random _residual_;
	estimate 'Change per year for Fully GPIP' datapoint 1 datapoint*group 0 0 1/exp;
	estimate 'Change per year for Partial GPIP' datapoint 1 datapoint*group 0 1 0/exp;
	estimate 'Change per year for None GPIP' datapoint 1 datapoint*group 1 0 0/exp;
	ods output ParameterEstimates=PCPvisitsModel;
run;
data PCPvisitsModel;set PCPvisitsModel;exp=exp(Estimate);
proc print;run;

 















****plots with starting point for PGIP and projected line;

* Unhealthy patient only,Remove patients assigned to pgip and non-pgip; 
data data1 data2;
set data.data;
where Unhealthy=1 and trt_max=1;
if max=1 then output data1;else output data2;
run;

*randomly select those assigned to more than 1 practice;
proc sort data=data2;by patient_id datapoint practice_id;run;
proc sort data=data2 nodupkey;by patient_id datapoint ;run;

data data;
set data1 data2;
run;

proc freq data=data;
	title 'Number of Patients in Treatment and Control';
	tables pgip*datapoint ;
run;


data graph0;
input year;
cards;
1 
2
3
4
;
run;

%macro plot(title=,var=,probplot=,initialdiff=,finitialdiff=,slope1PGIP=,slope1nonePGIP=,slope2PGIP=,slope2nonePGIP=);

proc means data=data;
where datapoint=1 and pgip=1;
var &var.;
output out=&var. mean=mean;
run;

data _null_;
set &var.;
call symput("initialPGIP",mean);
run;


data outcome;
set graph0;
log_PGIP=log(&initialPGIP.)+(&slope1PGIP.)*(year-1);
log_nonPGIP=log(&initialPGIP.)+(&initialdiff.)+(&slope1nonePGIP.)*(year-1);
run;

ods listing gpath="C:\data\Projects\P4P";
proc sgplot data=outcome;
title "Predicted Number of 90-day Readmission, Conditional on Any (log)";
series X=year  y=log_PGIP/lineattrs=(color=red ) LEGENDLABEL ="PGIP"  ;
series X=year  y=log_nonPGIP/ lineattrs=(color=black pattern=dash) LEGENDLABEL ="None PGIP" ;
xaxis label='Year' values=(1 to 4 by 1);
yaxis label="Log &title.";
run;

%if  &probplot.=1 %then %do;

*Probablity;
data data;
set data;
f=(&var. >0);
run;
proc means data=data;
where datapoint=1 and pgip=1;
var f ;
output out=f&var. mean=mean;
run;

data _null_;
set f&var.;
call symput("initialPGIP",mean);
run;


data outcome;
set graph0;
logod_PGIP=log(&initialPGIP./(1-&initialPGIP.))+(&slope2PGIP.)*(year-1);
logod_nonPGIP=log(&initialPGIP./(1-&initialPGIP.))+(&finitialdiff.)+(&slope2nonePGIP.)*(year-1);
run;

ods listing gpath="C:\data\Projects\P4P";
proc sgplot data=outcome;
title "Log Odds of having any 90-day Readmission";
series X=year  y=logod_PGIP/lineattrs=(color=red  ) LEGENDLABEL ="PGIP "  ;
series X=year  y=logod_nonPGIP/ lineattrs=(color=black pattern=dash) LEGENDLABEL ="None PGIP " ;
xaxis label='Year' values=(1 to 4 by 1);
yaxis label="Log Odds of having any &title.";
run;

%end;

%mend plot;
%plot(title=Medical-Surgical Cost,var=MedSurgCost,probplot=0,initialdiff=-0.0028,slope1PGIP=-0.087665,slope1nonePGIP=-0.08997,slope2PGIP=-0.5253,slope2nonePGIP=-0.7738);

%plot(title=IP Discharge,var=totalipdischarges_enc,probplot=1,initialdiff=0.03872,finitialdiff=-0.09798,slope1PGIP=0.04527,slope1nonePGIP=0.0643,slope2PGIP=-0.21963,slope2nonePGIP=-0.1737);

%plot(title=ED visits,var=totaledvisits_enc,probplot=1,initialdiff=-0.01903,finitialdiff=-0.01774,slope1PGIP=0.05112,slope1nonePGIP=0.03165,slope2PGIP=0.006,slope2nonePGIP=0.1197);

%plot(title=Readmision30,var=readmission30,probplot=1,initialdiff=0.4817,finitialdiff=-0.01045,slope1PGIP=-0.5069,slope1nonePGIP=-0.2854,slope2PGIP=-0.5697,slope2nonePGIP=-0.1416);

%plot(title=Readmision90,var=readmission90,probplot=1,initialdiff=0.2979,finitialdiff=-0.05106,slope1PGIP=-0.4921,slope1nonePGIP=-0.1707,slope2PGIP=-0.5703,slope2nonePGIP=-0.1047);

%plot(title=PCP Visits,var=pcpvisits,probplot=0,initialdiff=0.049,slope1PGIP=-0.05916,slope1nonePGIP=-0.06401,slope2PGIP=-0.4033,slope2nonePGIP=-0.5986);

%plot(title=Specialty Visits,var=specvisits,probplot=1,initialdiff=-0.1199,finitialdiff=-0.1465,slope1PGIP=-0.01146,slope1nonePGIP=-0.00926,slope2PGIP=-0.07355,slope2nonePGIP=-0.0364);
