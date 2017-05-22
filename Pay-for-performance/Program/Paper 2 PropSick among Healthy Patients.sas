*******************************
Second Paper: Prop Sick Patients
Xiner Zhou
3/14/2016
******************************;
libname data 'C:\data\Projects\P4P\Data';
 

******************************************
Hey Xiner-
 
This is great..thank you! For the revised models, instead of using quartiles of sick patients, can we now run a model that splits 
practices for this variable in to 2 categories: below 10% and above 10%? In terms of data cleaning, Let's still remove practices 
with values fewer than 100 for the "'members per pcp" variable, but no longer cut off the top 5% of practices. 
 
Let me know if you have any questions..thank you! We may ultimately run another set of models with cut points at 5, 10 and 20%, 
but we can start with just what I laid out above (over or under 10%)
 
Thanks so much!
Dori

******************************************;

******************************************
These last results are great, but we want to make a few changes:

1. Can we go back to running this as a pooled cross-sectional analysis? 
Because practice size and "proportion of sick patients" don't change over time, we just want to keep it pooled 
(i.e. don't interact proportion of sick patients with year)

2. Our funders were interested in adding some market-level descriptors for these practices as additional controls. 
There should be a variable in the data set for the practice's zip code....I am attaching an Excel spreadsheet that 
has zip-code level data for three new variables: 
(1) percent of the county population in fair or poor health (2011-2013 avg) 

(2) percent of the county population below the poverty line (2009-2013 avg) 

(3) % of county population over 65 
(annual data, 2010-2013). Can you add these as covariates in to the model?

******************************************;

* Socio-Economics variables;
proc import datafile="C:\data\Projects\P4P\Data\ZipCode_DemographicData.xlsx" 
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
if Unhealthy=0;

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



%macro propsick(y=,ydist=, out=,offset=);
 

%if &out.=1 %then %do;
 
data data&y.;
	set data; 
	outcome=&y.;
run;

/* create a dataset with 9 copies of each subject */  
data data&y.;
length interv $30.;
  set data&y.;
  /* 1st copy: equal to original one */
   interv = "original one";interv_n=1;
  output ; 
  /* 2nd copy: small practice with low sick, outcome to missing */
  interv ="small practice with low sick";interv_n=2;
  practicesize=1;propsickG=2;
  	outcome= . ;
  	output ; 
  /* 2nd copy: small practice with medium sick, outcome to missing */
	interv ="small practice with medium sick";interv_n=3;
 practicesize=1;propsickG=1;
  	outcome= . ;
  	output ;
  /* 2nd copy: small practice with high sick, outcome to missing */
	interv ="small practice with high sick";interv_n=4;
 practicesize=1;propsickG=0;
  	outcome= . ;
  	output ;

	  /* 2nd copy: medium practice with low sick, outcome to missing */
	interv ="medium practice with low sick";interv_n=5;
 practicesize=2;propsickG=2;
  	outcome= . ;
  	output ; 
  /* 2nd copy: medium practice with medium sick, outcome to missing */
	interv ="medium practice with medium sick";interv_n=6;
 practicesize=2;propsickG=1;
  	outcome= . ;
  	output ;
  /* 2nd copy: medium practice with high sick, outcome to missing */
	interv ="medium practice with high sick";interv_n=7;
 practicesize=2;propsickG=0;
  	outcome= . ;
  	output ;

	  /* 2nd copy: large practice with low sick, outcome to missing */
	interv ="large practice with low sick";interv_n=8;
 practicesize=3;propsickG=2;
  	outcome= . ;
  	output ; 
  /* 2nd copy: large practice with medium sick, outcome to missing */
	interv ="large practice with medium sick";interv_n=9;
 practicesize=3;propsickG=1;
  	outcome= . ;
  	output ;
  /* 2nd copy: large practice with high sick, outcome to missing */
	interv ="large practice with high sick";interv_n=10;
 practicesize=3;propsickG=0;
  	outcome= . ;
  	output ;

	proc sort;by interv_n;
run;

proc glimmix data=data&y.  ;
	class pgip  patient_id practice_id gender_cd practicesize propsickG;
	title "y=&y.,ydist=&ydist.,out=&out.";
	model outcome=pgip gender_cd ageinyears meanage pcpmembers_perpcp practicesize GeneralHealth Over65 propsickG year  &offset./s dist=&ydist.  ;
	random int/subject=patient_id  type=cs;*repeated equivalent to random intercept model;
	* reference: http://support.sas.com/resources/papers/proceedings12/332-2012.pdf;
	 
	output out = predicted_mean pred(noblup ilink)= meanY ;
    ods output ParameterEstimates=propsickModel&y.;
run;
data propsickModel&y.;
set propsickModel&y.;
	exp=exp(Estimate);
	drop DF tValue ;
proc print;format exp percent7.2;
run;

* estimate mean outcome in each of the groups interv=0, and interv=1;
* this mean outcome is a weighted average of the mean outcomes in each combination 
	of values of treatment and confounders, that is, the standardized outcome;
proc tabulate data = predicted_mean  out=PM&y.&ydist. ;
    title "Parametric g-formula";
  class  interv_n ;
  var meanY ;
  tables  interv_n,meanY*(mean*f=12.8 p5*f=12.8 p95*f=12.8  );
run;

%end;

%else %if &out.=2 %then %do;
data data&y.;
	length dist $30.;
	set data;
	outcome=(&y.>0);dist="Binary";output;
	outcome=&y.;dist="&ydist.";output;
run;

/* create a dataset with 9 copies of each subject */  
data data&y.;
length interv $30.;
  set data&y.;
  /* 1st copy: equal to original one */
   interv = "original one";interv_n=1;
  output ; 
  /* 2nd copy: small practice with low sick, outcome to missing */
  interv ="small practice with low sick";interv_n=2;
  practicesize=1;propsickG=2;
  	outcome= . ;
  	output ; 
  /* 2nd copy: small practice with medium sick, outcome to missing */
	interv ="small practice with medium sick";interv_n=3;
 practicesize=1;propsickG=1;
  	outcome= . ;
  	output ;
  /* 2nd copy: small practice with high sick, outcome to missing */
	interv ="small practice with high sick";interv_n=4;
 practicesize=1;propsickG=0;
  	outcome= . ;
  	output ;

	  /* 2nd copy: medium practice with low sick, outcome to missing */
	interv ="medium practice with low sick";interv_n=5;
 practicesize=2;propsickG=2;
  	outcome= . ;
  	output ; 
  /* 2nd copy: medium practice with medium sick, outcome to missing */
	interv ="medium practice with medium sick";interv_n=6;
 practicesize=2;propsickG=1;
  	outcome= . ;
  	output ;
  /* 2nd copy: medium practice with high sick, outcome to missing */
	interv ="medium practice with high sick";interv_n=7;
 practicesize=2;propsickG=0;
  	outcome= . ;
  	output ;

	  /* 2nd copy: large practice with low sick, outcome to missing */
	interv ="large practice with low sick";interv_n=8;
 practicesize=3;propsickG=2;
  	outcome= . ;
  	output ; 
  /* 2nd copy: large practice with medium sick, outcome to missing */
	interv ="large practice with medium sick";interv_n=9;
 practicesize=3;propsickG=1;
  	outcome= . ;
  	output ;
  /* 2nd copy: large practice with high sick, outcome to missing */
	interv ="large practice with high sick";interv_n=10;
 practicesize=3;propsickG=0;
  	outcome= . ;
  	output ;

	proc sort;by interv_n;
run;

proc glimmix data=data&y.  method=quad(Qpoints=200)   inititer=400 ;
	class pgip dist patient_id practice_id gender_cd practicesize propsickG;
	title "y=&y.,ydist=&ydist., out=&out.";
	model outcome(event='1')=dist dist*pgip dist*gender_cd dist*ageinyears dist*meanage dist*pcpmembers_perpcp dist*practicesize dist*GeneralHealth dist*Over65 dist*propsickG dist*year /s dist=byobs(dist) noint;
	random int  /subject=patient_id  ;
	 
	output out = predicted_mean pred(noblup ilink)= meanY ;
ods output ParameterEstimates=propsickModel&y.;
run;
data propsickModel&y.;
set propsickModel&y.;
	exp=exp(Estimate);
	drop DF tValue ;
proc sort;by dist;
proc print;format exp percent7.2;
run;

* estimate mean outcome in each of the groups interv=0, and interv=1;
* this mean outcome is a weighted average of the mean outcomes in each combination 
	of values of treatment and confounders, that is, the standardized outcome;
proc tabulate data = predicted_mean  out=PM&y.&ydist. ;
    title "Parametric g-formula";
  class dist interv_n ;
  var meanY ;
  tables dist, interv_n*meanY*(mean*f=12.8 p5*f=12.8 p95*f=12.8 );
run;

%end;


%mend propsick;
%propsick(y=MedSurgCost,ydist=Lognormal, out=1);
*%propsick(y=MedSurgCost,ydist=GAMMA, out=1);
*%propsick(y=MedSurgCost,ydist=Normal, out=1);

%propsick(y=IPCost,ydist=Lognormal, out=1);
*%propsick(y=IPCost,ydist=GAMMA, out=2);
*%propsick(y=IPCost,ydist=Normal, out=2);

%propsick(y=OPCost,ydist=Lognormal, out=1);
*%propsick(y=OPCost,ydist=GAMMA, out=1);
*%propsick(y=OPCost,ydist=Normal, out=1);

%propsick(y=EDCost,ydist=Lognormal, out=1);
*%propsick(y=EDCost,ydist=GAMMA, out=2);
*%propsick(y=EDCost,ydist=Normal, out=2);

%propsick(y=DrugCost,ydist=Lognormal, out=1);
*%propsick(y=DrugCost,ydist=GAMMA, out=2);
*%propsick(y=DrugCost,ydist=Normal, out=2);

%propsick(y=ipdischarge,ydist=Poisson, out=1);
*%propsick(y=ipdischarge,ydist=NEGBINOMIAL, out=2);
*%propsick(y=ipdischarge,ydist=Normal, out=2);

%propsick(y=edvisit,ydist=Poisson, out=1);
*%propsick(y=edvisit,ydist=NEGBINOMIAL, out=2);
*%propsick(y=edvisit,ydist=Normal, out=2);

%propsick(y=readmission30,ydist=Poisson, out=1);
*%propsick(y=readmission30,ydist=NEGBINOMIAL, out=2);
*%propsick(y=readmission30,ydist=Normal, out=2);
 
%propsick(y=pcpvisits,ydist=Poisson, out=1);
*%propsick(y=pcpvisits,ydist=NEGBINOMIAL, out=1);
*%propsick(y=pcpvisits,ydist=Normal, out=1);

%propsick(y=specvisits,ydist=Poisson, out=1);
*%propsick(y=specvisits,ydist=NEGBINOMIAL, out=2);
*%propsick(y=specvisits,ydist=Normal, out=2);

%propsick(y=quality1,ydist=Poisson,out=1);
*%propsick(y=quality1,ydist=NEGBINOMIAL,out=2);
*%propsick(y=quality1,ydist=Normal,out=2);
 
%propsick(y=mgmt1,ydist=Poisson, out=1);
*%propsick(y=mgmt1,ydist=NEGBINOMIAL, out=2);
*%propsick(y=mgmt1,ydist=Normal, out=2);

/*
%macro export(y,ydist);
PROC EXPORT DATA= WORK.PM&y.&ydist.
            OUTFILE= "C:\data\Projects\P4P\PM&y.&ydist..csv" 
            DBMS=CSV REPLACE;
     PUTNAMES=YES;
RUN;
%mend export;
%export(y=MedSurgCost,ydist=Lognormal );
%export(y=IPCost,ydist=Lognormal );
%export(y=OPCost,ydist=Lognormal );
%export(y=EDCost,ydist=Lognormal );
%export(y=DrugCost,ydist=Lognormal );
%export(y=ipdischarge,ydist=Poisson );
%export(y=edvisit,ydist=Poisson );
%export(y=readmission30,ydist=Poisson );
%export(y=pcpvisits,ydist=Poisson );
%export(y=specvisits,ydist=Poisson );
%export(y=quality1,ydist=Poisson );
%export(y=mgmt1,ydist=Poisson ); 
*/
