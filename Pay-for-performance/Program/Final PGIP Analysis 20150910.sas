****************************************************
CommonWealth P4P
Xiner Zhou
9/12/2015
*****************************************************;
libname data 'C:\data\Projects\P4P\Data';

**********************************************************************************************
Sample Selection
**********************************************************************************************;
* Unhealthy patient only,Remove patients assigned to pgip and non-pgip; 
data data1 data2;
set data.data;
where Unhealthy=1 and trt_max=1;
if max=1 then output data1;else output data2;
run;

*randomly select those assigned to more than 1 practice;
proc sort data=data2;by patient_id datapoint practice_id;run;
proc sort data=data2 nodupkey;by patient_id datapoint ;run;

data data;set data1 data2;run;

proc freq data=data;
	title 'Number of Patients in Treatment and Control';
	tables pgip*datapoint ;
run;

data data;
set data;
if pgip=1 then group1=0;else group1=1;
propsick1=propsick*10;
rename Adultquality_numer=quality1;
rename Adultquality_denom=quality2;
rename Adultpreventive_numer=preventive1;
rename Adultpreventive_denom=preventive2;
rename med_mgmt_pers_mednumer=mgmt1;
rename med_mgmt_pers_meddenom=mgmt2;
rename totalipdischarges_enc=ipdischarge;
rename totaledvisits_enc=edvisit;
proc means min median mean max;var propsick1;
proc freq;tables pgip*group1;
run;

********************************************************************************************
Compare Group difference at Baseline
********************************************************************************************;
%macro baseline(y=,ydist=,stratum=,out=,offset=);

%if &out.=1 %then %do;
data data&y.;
	set data; 
	if datapoint=1;
	outcome=&y.;
run;
proc glimmix data=data&y.  ;
	class  patient_id practice_id gender practicesize &stratum.;
	title "y=&y.,ydist=&ydist.,stratum=&stratum.,out=&out.";
	model outcome=&stratum.  
	              ageinyears gender practicesize pcpmembers_perpcp proportion_male meanage propsick1 &offset./s dist=&ydist.  ;
	ods output ParameterEstimates=baselineModel&y.;
run;
data baselineModel&y.;
set baselineModel&y.;
	exp=exp(Estimate);
	drop DF tValue ;
proc print;format exp percent7.2;
run;
%end;

%else %if &out.=2 %then %do;
data data&y.;
	length dist $30.;
	set data;
	if datapoint=1;
	outcome=(&y.>0);dist="Binary";output;
	outcome=&y.;dist="&ydist.";output;
proc sort;by descending &stratum.;
run;
proc glimmix data=data&y.  method=quad(Qpoints=100)   inititer=200 ;
	class  dist patient_id practice_id gender practicesize &stratum.;
	title "y=&y.,ydist=&ydist.,stratum=&stratum.,out=&out.";
	model outcome(event='1')=dist dist*&stratum. 
                             dist*ageinyears dist*gender dist*practicesize dist*pcpmembers_perpcp dist*proportion_male dist*meanage dist*propsick1 dist/s dist=byobs(dist) noint;
	ods output ParameterEstimates=baselineModel&y.;
run;
data baselineModel&y.;
set baselineModel&y.;
	exp=exp(Estimate);
	drop DF tValue ;
proc sort;by dist;
proc print;format exp percent7.2;
run;
%end;

%mend baseline;
%baseline(y=MedSurgCost,ydist=Lognormal,stratum=group1,out=1);
%baseline(y=IPCost,ydist=Lognormal,stratum=group1,out=2);
%baseline(y=OPCost,ydist=Lognormal,stratum=group1,out=1);
%baseline(y=EDCost,ydist=Lognormal,stratum=group1,out=2);
%baseline(y=DrugCost,ydist=Lognormal,stratum=group1,out=2);

%baseline(y=ipdischarge,ydist=Poisson,stratum=group1,out=2);
%baseline(y=edvisit,ydist=Poisson,stratum=group1,out=2);
%baseline(y=readmission30,ydist=Poisson,stratum=group1,out=2);
%baseline(y=readmission90,ydist=Poisson,stratum=group1,out=2);
%baseline(y=pcpvisits,ydist=Poisson,stratum=group1,out=1);
%baseline(y=specvisits,ydist=Poisson,stratum=group1,out=2);

%baseline(y=quality1,ydist=Poisson,stratum=group1,out=1,offset=quality2);
%baseline(y=preventive1,ydist=Poisson,stratum=group1,out=1,offset=preventive2);
%baseline(y=mgmt1,ydist=Poisson,stratum=group1,out=1,offset=mgmt2);


********************************************************************************************
Compare Group difference over Time: 
********************************************************************************************;
%macro trend(y=,ydist=,stratum=,out=,offset=);

%if &out.=1 %then %do;
data data&y.;
	set data; 
	outcome=&y.;
run;
proc glimmix data=data&y.   method=quad(Qpoints=100)   inititer=200 ;
	class  patient_id practice_id gender practicesize &stratum.;
	title "y=&y.,ydist=&ydist.,stratum=&stratum.,out=&out.";
	model outcome=datapoint &stratum. datapoint*&stratum.
	              ageinyears gender practicesize pcpmembers_perpcp proportion_male meanage propsick1 &offset./s dist=&ydist.  ;
	random int  /subject=practice_id  ;  
	ods output ParameterEstimates=trendModel&y.;
run;
data trendModel&y.;
set trendModel&y.;
	exp=exp(Estimate);
	drop DF tValue ;
proc print;format exp percent7.2;
run;
%end;

%else %if &out.=2 %then %do;
data data&y.;
	length dist $30.;
	set data;
	outcome=(&y.>0);dist="Binary";output;
	outcome=&y.;dist="&ydist.";output;
proc sort;by descending &stratum.;
run;
proc glimmix data=data&y.   method=quad(Qpoints=100)   inititer=200  ;
	class  dist patient_id practice_id gender practicesize &stratum.;
	title "y=&y.,ydist=&ydist.,stratum=&stratum.,out=&out.";
	model outcome(event='1')=dist dist*datapoint dist*&stratum. dist*datapoint*&stratum. 
                             dist*ageinyears dist*gender dist*practicesize dist*pcpmembers_perpcp dist*proportion_male dist*meanage dist*propsick1/s dist=byobs(dist) noint;
	random int  /subject=patient_id  ;
	ods output ParameterEstimates=trendModel&y.;
run;
data trendModel&y.;
set trendModel&y.;
	exp=exp(Estimate);
	drop DF tValue ;
proc sort;by dist;
proc print;format exp percent7.2;
run;
%end;


%mend trend;
%trend(y=MedSurgCost,ydist=Lognormal,stratum=group1,out=1);
%trend(y=IPCost,ydist=Lognormal,stratum=group1,out=2);
%trend(y=OPCost,ydist=Lognormal,stratum=group1,out=1);
%trend(y=EDCost,ydist=Lognormal,stratum=group1,out=2);
%trend(y=DrugCost,ydist=Lognormal,stratum=group1,out=2);

%trend(y=ipdischarge,ydist=Poisson,stratum=group1,out=2);
%trend(y=edvisit,ydist=Poisson,stratum=group1,out=2);
%trend(y=readmission30,ydist=Poisson,stratum=group1,out=2);
%trend(y=readmission90,ydist=Poisson,stratum=group1,out=2);
%trend(y=pcpvisits,ydist=Poisson,stratum=group1,out=1);
%trend(y=specvisits,ydist=Poisson,stratum=group1,out=2);

%trend(y=quality1,ydist=Poisson,stratum=group1,out=1,offset=quality2);
%trend(y=preventive1,ydist=Poisson,stratum=group1,out=1,offset=preventive2);
%trend(y=mgmt1,ydist=Poisson,stratum=group1,out=1,offset=mgmt2);

 
********************************************************************************************
Compare PropSick(Continuous) difference over Time: 
********************************************************************************************;
%macro trend1(y=,ydist=,stratum=,out=,offset=);

%if &out.=1 %then %do;
data data&y.;
	set data; 
	outcome=&y.;
run;
proc glimmix data=data&y.  ;
	class  group1 patient_id practice_id gender practicesize ;
	title "y=&y.,ydist=&ydist.,stratum=&stratum.,out=&out.";
	model outcome=datapoint &stratum. datapoint*&stratum.
	              ageinyears gender practicesize pcpmembers_perpcp proportion_male meanage group1 &offset./s dist=&ydist.  ;
	random _residual_ /subject=patient_id  type=cs;*repeated equivalent to random intercept model;
	* reference: http://support.sas.com/resources/papers/proceedings12/332-2012.pdf;
	ods output ParameterEstimates=trend1Model&y.;
run;
data trend1Model&y.;
set trend1Model&y.;
	exp=exp(Estimate);
	drop DF tValue ;
proc print;format exp percent7.2;
run;
%end;

%else %if &out.=2 %then %do;
data data&y.;
	length dist $30.;
	set data;
	outcome=(&y.>0);dist="Binary";output;
	outcome=&y.;dist="&ydist.";output;
proc sort;by descending &stratum.;
run;
proc glimmix data=data&y.  method=quad(Qpoints=100)   inititer=200 ;
	class  group1 dist patient_id practice_id gender practicesize ;
	title "y=&y.,ydist=&ydist.,stratum=&stratum.,out=&out.";
	model outcome(event='1')=dist dist*datapoint dist*&stratum. dist*datapoint*&stratum. 
                             dist*ageinyears dist*gender dist*practicesize dist*pcpmembers_perpcp dist*proportion_male dist*meanage dist*group1/s dist=byobs(dist) noint;
	random int  /subject=patient_id  ;
	ods output ParameterEstimates=trend1Model&y.;
run;
data trend1Model&y.;
set trend1Model&y.;
	exp=exp(Estimate);
	drop DF tValue ;
proc sort;by dist;
proc print;format exp percent7.2;
run;
%end;


%mend trend1;
%trend1(y=MedSurgCost,ydist=Lognormal,stratum=propsick1,out=1);
%trend1(y=IPCost,ydist=Lognormal,stratum=propsick1,out=2);
%trend1(y=OPCost,ydist=Lognormal,stratum=propsick1,out=1);
%trend1(y=EDCost,ydist=Lognormal,stratum=propsick1,out=2);
%trend1(y=DrugCost,ydist=Lognormal,stratum=propsick1,out=2);

%trend1(y=ipdischarge,ydist=Poisson,stratum=propsick1,out=2);
%trend1(y=edvisit,ydist=Poisson,stratum=propsick1,out=2);
%trend1(y=readmission30,ydist=Poisson,stratum=propsick1,out=2);
%trend1(y=readmission90,ydist=Poisson,stratum=propsick1,out=2);
%trend1(y=pcpvisits,ydist=Poisson,stratum=propsick1,out=1);
%trend1(y=specvisits,ydist=Poisson,stratum=propsick1,out=2);

%trend1(y=quality1,ydist=Poisson,stratum=propsick1,out=1,offset=quality2);
%trend1(y=preventive1,ydist=Poisson,stratum=propsick1,out=1,offset=preventive2);
%trend1(y=mgmt1,ydist=Poisson,stratum=propsick1,out=1,offset=mgmt2);

*%trend1(y=readmission30,ydist=Poisson,stratum=propsick1,out=1,offset=ipdischarge);
*%trend1(y=readmission90,ydist=Poisson,stratum=propsick1,out=1,offset=ipdischarge);

*****************************************************************************
Readmission 2 Outcomes Graphs-PGIP vs non-PGIP 
*****************************************************************************;
data graph0;
input year pgip $;
cards;
2010 PGIP
2011 PGIP
2012 PGIP
2013 PGIP
2010 Non-PGIP
2011 Non-PGIP
2012 Non-PGIP
2013 Non-PGIP
;
run;

%macro readmPart1(var=);

proc means data=data;
where datapoint=1 and pgip=1;
var &var.;
output out=yr1PGIP mean=mean;
run;

data _null_;
set yr1PGIP;
call symput("yr1PGIP",mean);*1st year raw PGIP average;
run;

data _Null_;
set baselineModel&var.;
if dist="Poisson" and effect="dist*group1" and group1="0" then call symput("yr1diff",exp);*1st year diff from model adjustment;
run;
data _null_;
set trendModel&var.;

if dist="Poisson" and effect="datapoint*dist" then do;
	call symput("trendnonpgip",exp);*exp trend for non-PGIP;
	call symput("temp1",Estimate);* beta trend for non-PGIP, use to calcualte PGIP exp trend;
end;

if dist="Poisson" and effect="datapoin*dist*group1" and group1="0" then call symput("temp2",Estimate);* exp trend for PGIP;
run;

data graph;
set graph0;
trendnonPGIP=symget('trendnonpgip')*1;
temp1=symget('temp1')*1;temp2=symget('temp2')*1;trendPGIP=exp(temp1+temp2)*1;
if year=2010 and pgip='PGIP' then rate=symget('yr1PGIP')*1;
if year=2010 and pgip='Non-PGIP' then rate=symget('yr1PGIP')/symget('yr1diff')*1; 
if year=2011 and pgip='PGIP' then rate=symget('yr1PGIP')*trendPGIP*1;
if year=2011 and pgip='Non-PGIP' then rate=symget('yr1PGIP')/symget('yr1diff')*trendnonPGIP*1; 
if year=2012 and pgip='PGIP' then rate=symget('yr1PGIP')*trendPGIP*trendPGIP*1;
if year=2012 and pgip='Non-PGIP' then rate=symget('yr1PGIP')/symget('yr1diff')*trendnonPGIP*trendnonPGIP*1;  
if year=2013 and pgip='PGIP' then rate=symget('yr1PGIP')*trendPGIP*trendPGIP*trendPGIP*1;
if year=2013 and pgip='Non-PGIP' then rate=symget('yr1PGIP')/symget('yr1diff')*trendnonPGIP*trendnonPGIP*trendnonPGIP*1;  
run;

ods listing gpath="C:\data\Projects\P4P";
proc sgplot data=graph;
title "Annually Number of &var. ";
format rate 7.4;
scatter X=year y=rate/markerattrs=(color=black symbol=STARFILLED); 
series X=year y=rate/group=pgip datalabel=rate lineattrs=(pattern=dash) ; 
xaxis label='Year' values=(2010 to 2013 by 1);
yaxis label="Annually Number of &var.";
run;

%mend readmPart1;
%readmPart1(var=readmission30);
%readmPart1(var=readmission90);


%macro readmPart2(var=);

proc means data=data&var.;
where dist="Binary" and datapoint=1 and pgip=1;
var outcome;
output out=yr1PGIP mean=mean;
run;

data _null_;
set yr1PGIP;
call symput("yr1PGIP",mean);*1st year raw PGIP average;
run;

data _Null_;
set baselineModel&var.;
if dist="Binary" and effect="dist*group1" and group1="0" then call symput("yr1diff",exp);*1st year diff from model adjustment;
run;

data _null_;
set trendModel&var.;
if dist="Binary" and effect="datapoint*dist" then do;
	call symput("trendnonpgip",exp);*exp trend for non-PGIP;
	call symput("temp1",Estimate);* beta trend for non-PGIP, use to calcualte PGIP exp trend;
end;
if dist="Binary" and effect="datapoin*dist*group1" and group1="0" then call symput("temp2",Estimate);* exp trend for PGIP;
run;

data graph;
set graph0;
trendnonPGIP=symget('trendnonpgip')*1;
temp1=symget('temp1')*1;temp2=symget('temp2')*1;trendPGIP=exp(temp1+temp2)*1;
*odds to prob;


if year=2010 and pgip='PGIP' then rate=symget('yr1PGIP')*1;
if year=2010 and pgip='Non-PGIP' then do;
	odds=symget('yr1PGIP')*1/(1-symget('yr1PGIP')*1)/symget('yr1diff')*1;
	rate=odds/(1+odds); 
end;

if year=2011 and pgip='PGIP' then do;
    odds=trendPGIP*1*symget('yr1PGIP')*1/(1-symget('yr1PGIP')*1);
	rate=odds/(1+odds); 
end;
if year=2011 and pgip='Non-PGIP' then do;
     odds=trendnonPGIP*1*symget('yr1PGIP')*1/(1-symget('yr1PGIP')*1)/symget('yr1diff')*1;
	rate=odds/(1+odds); 
end;

if year=2012 and pgip='PGIP' then do;
	 odds=trendPGIP*1*trendPGIP*1*symget('yr1PGIP')*1/(1-symget('yr1PGIP')*1);
	rate=odds/(1+odds); 
end;
if year=2012 and pgip='Non-PGIP' then do;
    odds=trendnonPGIP*1*trendnonPGIP*1*symget('yr1PGIP')*1/(1-symget('yr1PGIP')*1)/symget('yr1diff')*1;
	rate=odds/(1+odds); 
end;

if year=2013 and pgip='PGIP' then do;
	 odds=trendPGIP*1*trendPGIP*1*trendPGIP*1*symget('yr1PGIP')*1/(1-symget('yr1PGIP')*1);
	rate=odds/(1+odds); 
end;
if year=2013 and pgip='Non-PGIP' then do;
    odds=trendnonPGIP*1*trendnonPGIP*1*trendnonPGIP*1*symget('yr1PGIP')*1/(1-symget('yr1PGIP')*1)/symget('yr1diff')*1;
	rate=odds/(1+odds); 
end; 
run;

ods listing gpath="C:\data\Projects\P4P";
proc sgplot data=graph;
title "Probability of Having Any &var. ";
format rate 7.4;
scatter X=year y=rate/markerattrs=(color=black symbol=STARFILLED); 
series X=year y=rate/group=pgip datalabel=rate lineattrs=(pattern=dash)  ; 
xaxis label='Year' values=(2010 to 2013 by 1);
yaxis label="Probability of Having Any &var.";
run;

%mend readmPart2;
%readmPart2(var=readmission30);
%readmPart2(var=readmission90);




*****************************************************************************
Readmission 2 Outcomes Graphs- Proportion of Sick Patients
*****************************************************************************;
proc means data=data;
where datapoint=1;
var propsick1;
output out=propsick ;
run;



data graph0;
input year pgip $;
cards;
2010 PGIP
2011 PGIP
2012 PGIP
2013 PGIP
2010 Non-PGIP
2011 Non-PGIP
2012 Non-PGIP
2013 Non-PGIP
;
run;

%macro readmPart1(var=);

proc means data=data;
where datapoint=1 ;
var &var.;
output out=yr1 mean=mean;
run;

data _null_;
set yr1;
call symput("yr1",mean);*1st year raw average;
run;

data _Null_;
set baselineModel&var.;
if dist="Poisson" and effect="dist*group1" and group1="0" then call symput("yr1diff",exp);*1st year diff from model adjustment;
run;
data _null_;
set trendModel&var.;

if dist="Poisson" and effect="datapoint*dist" then do;
	call symput("trendnonpgip",exp);*exp trend for non-PGIP;
	call symput("temp1",Estimate);* beta trend for non-PGIP, use to calcualte PGIP exp trend;
end;

if dist="Poisson" and effect="datapoin*dist*group1" and group1="0" then call symput("temp2",Estimate);* exp trend for PGIP;
run;

data graph;
set graph0;
trendnonPGIP=symget('trendnonpgip')*1;
temp1=symget('temp1')*1;temp2=symget('temp2')*1;trendPGIP=exp(temp1+temp2)*1;
if year=2010 and pgip='PGIP' then rate=symget('yr1PGIP')*1;
if year=2010 and pgip='Non-PGIP' then rate=symget('yr1PGIP')/symget('yr1diff')*1; 
if year=2011 and pgip='PGIP' then rate=symget('yr1PGIP')*trendPGIP*1;
if year=2011 and pgip='Non-PGIP' then rate=symget('yr1PGIP')/symget('yr1diff')*trendnonPGIP*1; 
if year=2012 and pgip='PGIP' then rate=symget('yr1PGIP')*trendPGIP*trendPGIP*1;
if year=2012 and pgip='Non-PGIP' then rate=symget('yr1PGIP')/symget('yr1diff')*trendnonPGIP*trendnonPGIP*1;  
if year=2013 and pgip='PGIP' then rate=symget('yr1PGIP')*trendPGIP*trendPGIP*trendPGIP*1;
if year=2013 and pgip='Non-PGIP' then rate=symget('yr1PGIP')/symget('yr1diff')*trendnonPGIP*trendnonPGIP*trendnonPGIP*1;  
run;

ods listing gpath="C:\data\Projects\P4P";
proc sgplot data=graph;
title "Annually Number of &var. ";
format rate 7.4;
scatter X=year y=rate/markerattrs=(color=black symbol=STARFILLED); 
series X=year y=rate/group=pgip datalabel=rate  ; 
xaxis label='Year' values=(2010 to 2013 by 1);
yaxis label="Annually Number of &var.";
run;

%mend readmPart1;
%readmPart1(var=readmission30);
%readmPart1(var=readmission90);














