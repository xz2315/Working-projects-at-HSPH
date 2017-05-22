*******************************
Second Paper: Prop Sick Patients
Dori Cross
09/16/2016
******************************;
libname data 'C:\Users\dacross\Desktop';
 

* Socio-Economics variables;
proc import datafile="C:\Users\dacross\Documents\ZipCode_DemographicData.xlsx" 
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
if Unhealthy=1;

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
run;

*************************
Sample info
************************;
proc sort data=data out=sample nodupkey;by practice_id;run;
proc means data=sample min mean max ;
class propsickG;
var propsick;
run;
 
/*
if countpcps=1 then practicesize=1;
else if countpcps>=2 and countpcps<=5 then practicesize=2;
else if countpcps>=6 then practicesize=3;

* Dichotomize propsick;
if propsick <=0.02 then propsickG=2;
else if propsick <0.1 then propsickG=1;
else if propsick >0.1 then propsickG=0;
*/


*propsick is name of macro. y is outcome, ydist is distribution to use (normal, gamma), out is to tell program whether
*i want a 1 or 2 part model, and offset is if we need this for poisson, but we didnt use this - DAC 07/27/16;

*create 9 copies for post-estimation- want to know what happens in each group*
*if we don't care about practice size anymore, just need to create 3 groups then- take practice size out;

* model used to predict 3 lines for each cat of prop sick pts 
first line original, then 2-4th line comes out of this original models;


%macro propsick(y=,ydist=, out=,offset=);
 
*this whole thing is for running the one part models;

%if &out.=1 %then %do;
 
data data&y.;
	set data; 
	outcome=&y.;
run;

/* create a dataset with 7 copies of each subject */  
data data&y.;
length interv $30.;
  set data&y.;
  /* 1st copy: equal to original one */
   interv = "original one";interv_n=1;
  output ; 
  /* 2nd copy: low sick, outcome to missing */
  interv ="low sick";interv_n=2;
  propsickG=2;
  	outcome= . ;
  	output ; 
  /* 3rd copy: medium sick, outcome to missing */
	interv ="medium sick";interv_n=3;
  propsickG=1;
  	outcome= . ;
  	output ;
  /* 4th copy: high sick, outcome to missing */
	interv ="high sick";interv_n=4;
  propsickG=0;
  	outcome= . ;
  	output ;
  /* 5th copy: small practices, outcome to missing */
  interv ="small practices";interv_n=5;
  practicesize=1;
  	outcome= . ;
  	output ; 
  /* 6th copy: medium practices, outcome to missing */
	interv ="medium practices";interv_n=6;
  practicesize=2;
  	outcome= . ;
  	output ;
  /* 7th copy: large practices, outcome to missing */
	interv ="large practices";interv_n=7;
  practicesize=3;
  	outcome= . ;
  	output ;
	
	proc sort;by interv_n;
run;
 
*running the model*;

proc glimmix data=data&y. ;
	class pgip  patient_id practice_id gender_cd practicesize propsickG;
	title "y=&y.,ydist=&ydist.,out=&out.";
	model outcome=pgip gender_cd ageinyears meanage pcpmembers_perpcp practicesize 
    GeneralHealth Over65 propsickG ami chf pvd cvd copd asthma dementia paralysis diabetes1 diabetes2 
    renal liver1 liver2 ulcer rheum aids malignancy metastatic drugpsychosis drugdependence schizo depressionbipolar reactivepsychoses personality year  &offset./s dist=&ydist.  ;
	random int/subject=patient_id ;*repeated equivalent to random intercept model;
	* reference: http://support.sas.com/resources/papers/proceedings12/332-2012.pdf;

*output out- dataset name created for the predicted values for the 7 groups created, variable is meanY;
	output out = PM&y. pred(noblup ilink)= meanY ;
*below are model parameter ranges*;
    ods output ParameterEstimates=propsickModel&y.;
run;


*running model..using predicted output..calculating means across hypothetical grps;


*part below adds exponentiated variable*;

data propsickModel&y.;
set propsickModel&y.;
	exp=exp(Estimate);
	drop DF tValue ;
proc print;format exp percent7.2;
run;


* spits out the mean value for each hypoethetical group- for example, a $ amount for med surg costs across the 9 groups;

proc tabulate data = PM&y.  out=PM&y.&ydist. ;
    title "Parametric g-formula";
  class  interv_n ;
  var meanY ;
  tables  interv_n,meanY*(mean*f=12.8 p5*f=12.8 p95*f=12.8  );
run;


%end;

*thats the end of running the macros for the one part model*;
* one part models are for postestimation. patients with 0 given value close to 0, but not thrown out;

*this part below is for the 2-part models*- thi is the same, except there are 2 outcome lines- binary and continuuos;

*starting the 2 part models*;


%if &out.=2 %then %do;
data data&y.;
	length dist $30.;
	set data;
	outcome=(&y.>0);dist="Binary";output; *made a  second copy indicates whether there was ANY utilization*;
	outcome=&y.;dist="&ydist.";output;
run;


data data&y.;
length interv $30.;
  set data&y.;
  /* 1st copy: equal to original one */
   interv = "original one";interv_n=1;
  output ; 
  /* 2nd copy: low sick, outcome to missing */
  interv ="low sick";interv_n=2;
  propsickG=2;
  	outcome= . ;
  	output ; 
  /* 3rd copy: medium sick, outcome to missing */
	interv ="medium sick";interv_n=3;
  propsickG=1;
  	outcome= . ;
  	output ;
  /* 4th copy: high sick, outcome to missing */
	interv ="high sick";interv_n=4;
  propsickG=0;
  	outcome= . ;
  	output ;
  /* 5th copy: small practices, outcome to missing */
  interv ="low sick";interv_n=5;
  practicesize=1;
  	outcome= . ;
  	output ; 
  /* 6th copy: medium practices, outcome to missing */
	interv ="medium sick";interv_n=6;
  practicesize=2;
  	outcome= . ;
  	output ;
  /* 7th copy: large practices, outcome to missing */
	interv ="high sick";interv_n=7;
  practicesize=3;
  	outcome= . ;
  	output ;

 proc sort;by interv_n;
run;

proc glimmix data=data&y.  method=quad(Qpoints=200)   inititer=400 ;
	class pgip dist patient_id practice_id gender_cd practicesize propsickG;
	title "y=&y.,ydist=&ydist., out=&out.";
	model outcome(event='1')=dist dist*pgip dist*gender_cd dist*ageinyears dist*meanage dist*pcpmembers_perpcp dist*practicesize dist*GeneralHealth dist*Over65 dist*propsickG dist*year 
    dist*ami dist*chf dist*pvd dist*cvd dist*copd dist*asthma dist*dementia dist*paralysis dist*diabetes1 dist*diabetes2 
    dist*renal dist*liver1 dist*liver2 dist*ulcer dist*rheum dist*aids dist*malignancy dist*metastatic dist*drugpsychosis 
    dist*drugdependence dist*schizo dist*depressionbipolar dist*reactivepsychoses dist*personality /s dist=byobs(dist) noint;
	random int  /subject=patient_id  ;
	 
	output out = PM&y. pred(noblup ilink)= meanY ;
ods output ParameterEstimates=propsickModel&y.;
run;
data propsickModel&y.;
set propsickModel&y.;
	exp=exp(Estimate);
	drop DF tValue ;
proc sort;by dist;
proc print;format exp percent7.2;
run;

*ignore the statement just below. its actually running on all interval groups*;
* estimate mean outcome in each of the groups interv=0, and interv=1;
* this mean outcome is a weighted average of the mean outcomes in each combination 
	of values of treatment and confounders, that is, the standardized outcome;
proc tabulate data = PM&y.  out=PM&y.&ydist. ;
    title "Parametric g-formula";
  class dist interv_n ;
  var meanY ;
  tables dist, interv_n*meanY*(mean*f=12.8 p5*f=12.8 p95*f=12.8 );
run;

%end;
*/
*TO RUN THE 2-PART MODEL, I NEED TO CHANGE "OUT" TO EQUAL 2*;

%mend propsick;
*%propsick(y=MedSurgCost,ydist=Lognormal, out=1);
*%propsick(y=MedSurgCost,ydist=GAMMA, out=1);
*%propsick(y=MedSurgCost,ydist=Normal, out=1);

%propsick(y=IPCost,ydist=Lognormal, out=2);
*%propsick(y=IPCost,ydist=GAMMA, out=1);
*%propsick(y=IPCost,ydist=Normal, out=2);

%propsick(y=OPCost,ydist=Lognormal, out=1);
*%propsick(y=OPCost,ydist=GAMMA, out=1);
*%propsick(y=OPCost,ydist=Normal, out=1);

%propsick(y=EDCost,ydist=Lognormal, out=2);
*%propsick(y=EDCost,ydist=GAMMA, out=1);
*%propsick(y=EDCost,ydist=Normal, out=2);

%propsick(y=DrugCost,ydist=Lognormal, out=2);
*%propsick(y=DrugCost,ydist=GAMMA, out=1);
*%propsick(y=DrugCost,ydist=Normal, out=2);

%propsick(y=ipdischarge,ydist=Poisson, out=2);
*%propsick(y=ipdischarge,ydist=NEGBINOMIAL, out=2);
*%propsick(y=ipdischarge,ydist=Normal, out=2);

%propsick(y=edvisit,ydist=Poisson, out=2);
*%propsick(y=edvisit,ydist=NEGBINOMIAL, out=2);
*%propsick(y=edvisit,ydist=Normal, out=2);

*%propsick(y=readmission30,ydist=Binary, out=3);
*%propsick(y=readmission30,ydist=NEGBINOMIAL, out=2);
*%propsick(y=readmission30,ydist=Normal, out=2);

*%propsick(y=readmission90,ydist=Binary, out=3);

%propsick(y=pcpvisits,ydist=Poisson, out=1);
*%propsick(y=pcpvisits,ydist=NEGBINOMIAL, out=1);
*%propsick(y=pcpvisits,ydist=Normal, out=1);

%propsick(y=specvisits,ydist=Poisson, out=2);
*%propsick(y=specvisits,ydist=NEGBINOMIAL, out=2);
*%propsick(y=specvisits,ydist=Normal, out=2);

%propsick(y=Adultquality,ydist=normal,out=1);
*%propsick(y=quality1,ydist=NEGBINOMIAL,out=2);
*%propsick(y=quality1,ydist=Normal,out=2);
 
%propsick(y=med_mgmt,ydist=normal, out=1);
*%propsick(y=mgmt1,ydist=NEGBINOMIAL, out=2);
*%propsick(y=mgmt1,ydist=Normal, out=2);



/*
I spoke with Julia, and she's interested in rerunning the models that are NOT 2-part models 
(medsurg costs, outpatient costs, PCP visits and the quality measures) and doing the necessary post-estimation to 
get predictive margins and graphs for these. Since these take less time to run, we can start to look at this subset 
of outputs and how we might want to incorporate that information in to our manuscript. 
 
For predictive margins, we'd want values for all 9 potential practice types (3 size categories*3 prop sick pts categories). 
Ideally, there would then be 3 graphs (one each for small, med and large) and 3 lines on each graph (for minimum, medium and high prop sick pts).

*/

*creates the confidence intervals and the average- same as what we did above! but nicer to run together, so dont need to copy and paste*;


%macro PM(y);
proc means data=PM&y.;
class Interv_n;
var meanY;
output out=&y. N=n MEAN=mean STDERR=stderr min=min max=max LCLM=LCLM UCLM=UCLM;
run;

data &y.;
set &y.;
lower = mean - ( TINV ( 0.95 , n-1 ) * stderr ) ;
upper= mean + ( TINV ( 0.95 , n-1 ) * stderr ) ;
keep Interv_n  mean  stderr min max lower upper;
if Interv_n ne . ;

run;
%mend PM;
%PM(y=MedSurgCost);
%PM(y=IPCost);
%PM(y=OpCost);
%PM(y=EDCost);
%PM(y=DrugCost);
%PM(y=ipdischarge);
%PM(y=EDvisit);
*%PM(y=readmission30);
*%PM(y=readmission90);
%PM(y=pcpvisits );
%PM(y=specvisits);
%PM(y=Adultquality);
%PM(y=med_mgmt);

data mydata;
set MedSurgCost(in=in1)
    IPCost(in=in2)
	OPCost(in=in3)
	EDCost(in=in4)
	DrugCost(in=in5)
	ipdischarge(in=in6)
    edvisit(in=in7)
	/*readmission30(in=in8) */
	pcpvisits(in=in9)
	specvisits(in=in10)
	Adultquality(in=in11)
	med_mgmt(in=in12);length outcome group $40.;
	if in1 then outcome="Medical and Surgical Cost";
	if in2 then outcome="Inpatient Cost";
	if in3 then outcome="Outpatient Cost";
	if in4 then outcome="ED Cost";
	if in5 then outcome="Drug Cost";
	if in6 then outcome="Number of Inpatient Discharges";
	if in7 then outcome="Number of ED Visits";
	/*if in8 then outcome="Number of 30-day Readmission"; */
	if in9 then outcome="Number of PCP Visits";
	if in10 then outcome="Number of Specialty Visits";
	if in11 then outcome="Number of Quality Indicator";
	if in12 then outcome="Number of Management Indicator"; 
     
	if interv_n=1 then group="Orginal Data";
	if interv_n=2 then do;group="Low Proportion of Sick Patients"; end;
	if interv_n=3 then do;group="Medium Proportion of Sick Patients"; end;
	if interv_n=4 then do;group="High Proportion of Sick Patients"; end;
	if interv_n=5 then do;group="Small practices"; end;
	if interv_n=6 then do;group="Medium practices"; end;
	if interv_n=7 then do;group="Large practices"; end;
	
 

	proc print;
run;
 
PROC EXPORT DATA= mydata
            OUTFILE= "C:\Users\dacross\Desktop\New09.16.mht" 
            DBMS=CSV REPLACE;
     PUTNAMES=YES;
RUN;

 


























/*

data mydata;
set PMMedSurgCostLognormal(in=in1)
    PMIPCostLognormal(in=in2)
	PMOPCostLognormal(in=in3)
	PMEDCostLognormal(in=in4)
	PMDrugCostLognormal(in=in5)
	PMipdischargePoisson(in=in6)
    PMedvisitPoisson(in=in7)
	PMreadmission30Poisson(in=in8)
	PMpcpvisitsPoisson(in=in9)
	PMspecvisitsPoisson(in=in10)
	PMquality1Poisson(in=in11)
	PMmgmt1Poisson(in=in12);length outcome $30.;
	if in1 then outcome="Medical and Surgical Cost";
	if in2 then outcome="Inpatient Cost";
	if in3 then outcome="Outpatient Cost";
	if in4 then outcome="ED Cost";
	if in5 then outcome="Drug Cost";
	if in6 then outcome="Number of Inpatient Discharges";
	if in7 then outcome="Number of ED Visits";
	if in8 then outcome="Number of 30-day Readmission";
	if in9 then outcome="Number of PCP Visits";
	if in10 then outcome="Number of Specialty Visits";
	if in11 then outcome="Number of Quality Indicator";
	if in12 then outcome="Number of Management Indicator";

	if interv_n=2 then group="small practice with low sick";
	if interv_n=3 then group="small practice with medium sick";
	if interv_n=4 then group="small practice with high sick";
	if interv_n=5 then group="medium practice with low sick";
	if interv_n=6 then group="medium practice with medium sick";
	if interv_n=7 then group="medium practice with high sick";
	if interv_n=8 then group="high practice with low sick";
	if interv_n=9 then group="high practice with medium sick";
	if interv_n=10 then group="high practice with high sick";


	drop _TYPE_ _PAGE_ _TABLE_;

	proc print;
run;
 
PROC EXPORT DATA= mydata
            OUTFILE= "C:\data\Projects\P4P\mydata.csv" 
            DBMS=CSV REPLACE;
     PUTNAMES=YES;
RUN;
*/



**********************
Descriptive Tables
**********************;
proc sort data=data out=patient nodupkey ;where comorbcount ne .;by patient_id  ;run;

proc means data=patient N mean std;
var ageinyears  gender comorbcount ;
run;

%macro temp(var=);
proc means data=patient ;
var  &var.;
output out=&var. mean=mean;
run;

data &var.;
set &var.;
condition="&var.";
keep condition mean;
run;

%mend temp;
%temp(var=ami);
%temp(var=chf);
%temp(var=pvd);
%temp(var=cvd);
%temp(var=copd);
%temp(var=asthma);
%temp(var=dementia);
%temp(var=paralysis);
%temp(var=diabetes1);
%temp(var=diabetes2);
%temp(var=renal);
%temp(var=liver1);
%temp(var=liver2);
%temp(var=ulcer);
%temp(var=rheum);
%temp(var=aids);
%temp(var=malignancy);
%temp(var=metastatic);
%temp(var=drugpsychosis);
%temp(var=drugdependence);
%temp(var=schizo);
%temp(var=depressionbipolar);
%temp(var=reactivepsychoses);
%temp(var=personality);
 
data all;
length condition $10.;
set  ami 
chf
pvd
cvd
copd
asthma
dementia
paralysis
diabetes1
diabetes2
renal
liver1
liver2
ulcer
rheum
aids
malignancy
metastatic
drugpsychosis
drugdependence
schizo
depressionbipolar
reactivepsychoses
personality;
proc sort;by descending mean;
proc print;
run;

proc sort data=data out=patient nodupkey ;by patient_id  datapoint;run;

proc means data=patient N mean std median;
var MedSurgCost
IPCost
OpCost
EDCost
DrugCost
ipdischarge
EDvisit
readmission30 readmission90
pcpvisits
specvisits
quality1
mgmt1;
run;

proc sort data=data out=practice nodupkey ;by practice_id;run;
proc freq data=practice;
table practicesize propsickG PGIP/missing;
run;
proc means data=patient N mean std median;
var meanage members_sum;
run;




