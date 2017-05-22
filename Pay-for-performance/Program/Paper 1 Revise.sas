****************************************************
CommonWealth Sub P4P
Xiner Zhou
2/9/2016
*****************************************************;
libname data 'C:\data\Projects\P4P\Data';

**************************************  Email 1
1. Why didn't we include random effects for practices, in addition to patient-level random effects?

Approach: We tried before, model is too complex and won't converge with patient AND practice-level random effects. 
Instead, we are going to try to run the models with practice-level fixed effects. 
(if not, sell them on our decision to control for unobserved variation in patients and point out our use of available practice-level controls...
we may be able to add in some additional variables based on geographic location?)

2. Are our results robust to different distributional assumptions?

Approach: The first binary part of the model is logistic--this is appropriate, 
and doesn't require defense/testing of different assumptions. 
For the 2nd continuous part of the models---For utilization and quality measures: test negative binomial, 
rather than poisson. For cost measures: test gamma, rather than log normal

3. How do we take our results (reported in percentages), and transform them to "real-world" proportions? 
(i.e. Reduction of XX readmissions per 1,000 patients)

Approach: Because our result is a percentage, the number of avoided readmissions (or other utilization measures) 
is based on where we started from. We are going to run an LSV model (??), which will generate data points for year 1 and year 4, 
both for PGIP and non-PGIP practices. This will allow us to come up with an estimated number of decreased [admissions, ED visits, readmissions, etc.] 
per 1,000 patients over the time period of this study.

Xiner-We are going to use LS-Means, which will generate data points for year 1 and year 4, both for PGIP and non-PGIP practices, 
setting all other covariates in the model to their sample average, so it will represent hypothetical situations where an average 
patient in an average practice in PGIP or non-PGIP, in year 1 or year 4. This will allow us to come up with a projected number 
of decreased outcomes based on our models.

-Predicted Margin should be equal to non-zero utilizers, so compare sample average among non-zero utilizar with G-Formula from Rubins.
**************************************;
 

***************************************   Email 2
I also realized, in responding to reviewer comments, that we need a few additional descriptive statistics out of the data. 
I have listed them out below. If you have a chance to pull these numbers for me, that would be great!

1. mean and median proportion of high-need patients (at the practice-level) in the PGIP practices versus in the non-PGIP practices 
(with t-test for difference of means)

2. Across all 1,582 practices in sample, what is the average within-practice PCP age (w/SE)? 
And, what is the average within-practice % of PCPs that are male (w/SE)?

3. Can you rerun the figure attached to this email, changing the one label from "None PGIP" to "Non-PGIP", 
and making that line dashed instead of solid?
 
****************************************;

************** 
Data Wrangling
**************; 
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
if pgip=1 then group1=0;else group1=1; *group1=0 is P4P participants;
propsick1=propsick*10;* prop of sick is 10% scale;
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
 
************************************* 
Compare Group difference at Baseline: Practice Fixed Effect Model
*************************************;

%macro baseline(y=,ydist=,stratum=,out=,offset=);

%if &out.=1 %then %do;
data data&y.;
	set data; 
	if datapoint=1;
	outcome=&y.;
	
run;
/* create a dataset with 3 copies of each subject */  
data data&y.;
  set data&y.;
  
  interv = -1 ;    /* 1st copy: equal to original one */
  	output ; 
  interv = 0 ;     /* 2nd copy: treatment set to PGIP, outcome to missing */
  	group1 = 0 ;
  	outcome= . ;
  	output ;  
  interv = 1 ;     /* 3rd copy: treatment set to non-PGIP, outcome to missing*/
  	group1 = 1 ;
  	outcome= . ;
  	output ;    
run;

proc glimmix data=data&y.  method=quad(Qpoints=100)   inititer=200 empirical;
	class  patient_id practice_id gender practicesize &stratum.;
	title "y=&y.,ydist=&ydist.,stratum=&stratum.,out=&out.";
	model outcome=&stratum.  
	              ageinyears gender practicesize pcpmembers_perpcp proportion_male meanage propsick1 &offset. /s dist=&ydist.  ;				  
	random int  /subject=practice_id  ;   
	ods output ParameterEstimates=baselineModel&y.;
	lsmeans &stratum.  /  om ;
    output out = predicted_mean pred(noblup ilink)= meanY;
	run;
 
data baselineModel&y.;
set baselineModel&y.;
	exp=exp(Estimate);
	if effect not in ('Scale', 'practice_ID');
	drop DF tValue ;
proc print noobs;
*format exp percent7.2;
run;

* estimate mean outcome in each of the groups interv=0, and interv=1;
* this mean outcome is a weighted average of the mean outcomes in each combination 
	of values of treatment and confounders, that is, the standardized outcome;
proc tabulate data = predicted_mean   ;
    title "Parametric g-formula";
  class   interv ;
  var meanY ;
  tables  interv, meanY*mean;
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

/* create a dataset with 3 copies of each subject */  
data data&y.;
  set data&y.;
  
  interv = -1 ;    /* 1st copy: equal to original one */
  	output ; 
  interv = 0 ;     /* 2nd copy: treatment set to PGIP, outcome to missing */
  	group1 = 0 ;
  	outcome= . ;
  	output ;  
  interv = 1 ;     /* 3rd copy: treatment set to non-PGIP, outcome to missing*/
  	group1 = 1 ;
  	outcome= . ;
  	output ;    
run;


proc glimmix data=data&y.  method=quad(Qpoints=100)   inititer=200 empirical;
	class  dist patient_id practice_id gender practicesize &stratum.;
	title "y=&y.,ydist=&ydist.,stratum=&stratum.,out=&out.";
	model outcome(event='1')=dist dist*&stratum. 
                             dist*ageinyears dist*gender dist*practicesize dist*pcpmembers_perpcp dist*proportion_male dist*meanage dist*propsick1 /s dist=byobs(dist) noint;
	random int  /subject=practice_id  ;
    
    ods output ParameterEstimates=baselineModel&y.;
    
   lsmeans dist*&stratum.  /  om  ;
   output out = predicted_mean pred(noblup ilink)= meanY;
	run;
 
data baselineModel&y.;
set baselineModel&y.;
	exp=exp(Estimate);
	if effect not in ('Scale (Lognormal)','Scale (Poisson)', 'dist*practice_ID');
	drop DF tValue ;
proc sort;by dist;
proc print noobs;
*format exp percent7.2;
run;

* estimate mean outcome in each of the groups interv=0, and interv=1;
* this mean outcome is a weighted average of the mean outcomes in each combination 
	of values of treatment and confounders, that is, the standardized outcome;
proc tabulate data = predicted_mean   ;
    title "Parametric g-formula";
  class dist interv ;
  var meanY ;
  tables dist, interv*meanY*mean;
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

%baseline(y=quality1,ydist=Poisson,stratum=group1,out=1 );
%baseline(y=preventive1,ydist=Poisson,stratum=group1,out=1 );
%baseline(y=mgmt1,ydist=Poisson,stratum=group1,out=1 );

* alternative distributional assumption;
* GAMMA default link is log;
* NB default link is log;
%baseline(y=MedSurgCost,ydist=GAMMA,stratum=group1,out=1);
%baseline(y=IPCost,ydist=GAMMA,stratum=group1,out=2);
%baseline(y=OPCost,ydist=GAMMA,stratum=group1,out=1);
%baseline(y=EDCost,ydist=GAMMA,stratum=group1,out=2);
%baseline(y=DrugCost,ydist=GAMMA,stratum=group1,out=2);

%baseline(y=ipdischarge,ydist=NEGBINOMIAL,stratum=group1,out=2);
%baseline(y=edvisit,ydist=NEGBINOMIAL,stratum=group1,out=2);
%baseline(y=readmission30,ydist=NEGBINOMIAL,stratum=group1,out=2);
%baseline(y=readmission90,ydist=NEGBINOMIAL,stratum=group1,out=2);
%baseline(y=pcpvisits,ydist=NEGBINOMIAL,stratum=group1,out=1);
%baseline(y=specvisits,ydist=NEGBINOMIAL,stratum=group1,out=2);

%baseline(y=quality1,ydist=NEGBINOMIAL,stratum=group1,out=1 );
%baseline(y=preventive1,ydist=NEGBINOMIAL,stratum=group1,out=1 );
%baseline(y=mgmt1,ydist=NEGBINOMIAL,stratum=group1,out=1 );


********************************************************************************************
Compare Group difference over Time: 
********************************************************************************************;
%macro trend(y=,ydist=,stratum=,out=,offset=);

%if &out.=1 %then %do;
data data&y.;
	set data; 
	outcome=&y.;
run;

/* create a dataset with 3 copies of each subject */  
data data&y.;
  set data&y.;
  
  interv = -1 ;    /* 1st copy: equal to original one */
  	output ; 
  interv = 0 ;     /* 2nd copy: treatment set to PGIP, outcome to missing */
  	group1 = 0 ; datapoint=1;
  	outcome= . ;
  	output ;  
  interv = 0 ;     /* 2nd copy: treatment set to PGIP, outcome to missing */
  	group1 = 0 ; datapoint=4;
  	outcome= . ;
  	output ;  

  interv = 1 ;     /* 3rd copy: treatment set to non-PGIP, outcome to missing*/
  	group1 = 1 ;datapoint=1;
  	outcome= . ;
  	output ; 
  interv = 1 ;     /* 3rd copy: treatment set to non-PGIP, outcome to missing*/
  	group1 = 1 ;datapoint=4;
  	outcome= . ;
  	output ;  
run;


proc glimmix data=data&y.  initglm scoring=5 empirical;
	class  patient_id practice_id gender practicesize &stratum.;
	title "y=&y.,ydist=&ydist.,stratum=&stratum.,out=&out.";
	model outcome=datapoint &stratum. datapoint*&stratum.
	              ageinyears gender practicesize pcpmembers_perpcp proportion_male meanage propsick1 &offset./s dist=&ydist.  ;
	random _residual_ /subject=patient_id  type=cs;*repeated equivalent to random intercept model;
	* reference: http://support.sas.com/resources/papers/proceedings12/332-2012.pdf;
	*estimate "PGIP trend" penaltygroup 1 0 -1/ exp;

	lsmeans &stratum.  /  om at datapoint=1;
	lsmeans &stratum.  /  om at datapoint=4;
	ods output ParameterEstimates=trendModel&y.;
	output out = predicted_mean pred(noblup ilink)= meanY;
run;




data trendModel&y.;
set trendModel&y.;
	exp=exp(Estimate);
	drop DF tValue ;
proc print;format exp percent7.2;
run;

* estimate mean outcome in each of the groups interv=0, and interv=1;
* this mean outcome is a weighted average of the mean outcomes in each combination 
	of values of treatment and confounders, that is, the standardized outcome;
proc tabulate data = predicted_mean   ;
    title "Parametric g-formula";
  class interv datapoint;
  var meanY ;
  tables  interv,datapoint*meanY*mean;
run;
%end;

%else %if &out.=2 %then %do;
data data&y.;
	length dist $30.;
	set data;
	outcome=(&y.>0);dist="Binary";output;
	outcome=&y.;dist="&ydist.";output;
run;

/* create a dataset with 3 copies of each subject */  
data data&y.;
  set data&y.;
  
  interv = -1 ;    /* 1st copy: equal to original one */
  	output ; 
  interv = 0 ;     /* 2nd copy: treatment set to PGIP, outcome to missing */
  	group1 = 0 ; datapoint=1;
  	outcome= . ;
  	output ;  
  interv = 0 ;     /* 2nd copy: treatment set to PGIP, outcome to missing */
  	group1 = 0 ; datapoint=4;
  	outcome= . ;
  	output ;  

  interv = 1 ;     /* 3rd copy: treatment set to non-PGIP, outcome to missing*/
  	group1 = 1 ;datapoint=1;
  	outcome= . ;
  	output ; 
  interv = 1 ;     /* 3rd copy: treatment set to non-PGIP, outcome to missing*/
  	group1 = 1 ;datapoint=4;
  	outcome= . ;
  	output ;  
run;


proc glimmix data=data&y.  empirical ;
	class  dist patient_id practice_id gender practicesize &stratum.;
	title "y=&y.,ydist=&ydist.,stratum=&stratum.,out=&out.";
	model outcome(event='1')=dist dist*datapoint dist*&stratum. dist*datapoint*&stratum. 
                             dist*ageinyears dist*gender dist*practicesize dist*pcpmembers_perpcp dist*proportion_male dist*meanage dist*propsick1/s dist=byobs(dist) noint;
	random int  /subject=patient_id  ;
	lsmeans dist*&stratum.  /  om at datapoint=1;
	lsmeans dist*&stratum.  /  om at datapoint=4;
	ods output ParameterEstimates=trendModel&y.;
	output out = predicted_mean pred(noblup ilink)= meanY;
run;
data trendModel&y.;
set trendModel&y.;
	exp=exp(Estimate);
	drop DF tValue ;
proc sort;by dist;
proc print;format exp percent7.2;
run;


* estimate mean outcome in each of the groups interv=0, and interv=1;
* this mean outcome is a weighted average of the mean outcomes in each combination 
	of values of treatment and confounders, that is, the standardized outcome;
proc tabulate data = predicted_mean   ;
    title "Parametric g-formula";
  class dist interv datapoint;
  var meanY ;
  tables dist, interv*datapoint*meanY*mean;
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

 * alternative distributional assumption;
* GAMMA default link is log;
* NB default link is log;
%baseline(y=MedSurgCost,ydist=GAMMA,stratum=group1,out=1);
%baseline(y=IPCost,ydist=GAMMA,stratum=group1,out=2);
%baseline(y=OPCost,ydist=GAMMA,stratum=group1,out=1);
%baseline(y=EDCost,ydist=GAMMA,stratum=group1,out=2);
%baseline(y=DrugCost,ydist=GAMMA,stratum=group1,out=2);

%baseline(y=ipdischarge,ydist=NEGBINOMIAL,stratum=group1,out=2);
%baseline(y=edvisit,ydist=NEGBINOMIAL,stratum=group1,out=2);
%baseline(y=readmission30,ydist=NEGBINOMIAL,stratum=group1,out=2);
%baseline(y=readmission90,ydist=NEGBINOMIAL,stratum=group1,out=2);
%baseline(y=pcpvisits,ydist=NEGBINOMIAL,stratum=group1,out=1);
%baseline(y=specvisits,ydist=NEGBINOMIAL,stratum=group1,out=2);

%baseline(y=quality1,ydist=NEGBINOMIAL,stratum=group1,out=1 );
%baseline(y=preventive1,ydist=NEGBINOMIAL,stratum=group1,out=1 );
%baseline(y=mgmt1,ydist=NEGBINOMIAL,stratum=group1,out=1 );






































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
