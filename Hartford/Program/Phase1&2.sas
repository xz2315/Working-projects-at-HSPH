*****************************************************
Hartford Grant Phase 1 Analytics
Xiner Zhou
10/20/2015
****************************************************;
libname data 'C:\data\Projects\Hartford\Data';
 
********************************************
Number of Responders each year
*******************************************;
proc freq data=data.Hartford;
title "N. of HIT Survey Responders";
tables Respond2008/missing nopercent norow nocol out=FreqCount2008 outexpect;
run;
proc freq data=data.Hartford;
title "N. of HIT Survey Responders";
tables Respond2009/missing nopercent norow nocol out=FreqCount2009 outexpect;
run;
proc freq data=data.Hartford;
title "N. of HIT Survey Responders";
tables Respond2010/missing nopercent norow nocol out=FreqCount2010 outexpect;
run;
proc freq data=data.Hartford;
title "N. of HIT Survey Responders";
tables Respond2011/missing nopercent norow nocol out=FreqCount2011 outexpect;
run;
proc freq data=data.Hartford;
title "N. of HIT Survey Responders";
tables Respond2012/missing nopercent norow nocol out=FreqCount2012 outexpect;
run;
proc freq data=data.Hartford;
title "N. of HIT Survey Responders";
tables Respond2013/missing nopercent norow nocol out=FreqCount2013 outexpect;
run;

data freqCount;
set freqCount2008(where=(respond2008=1) in=in2008) freqCount2009(where=(respond2009=1) in=in2009) freqCount2010(where=(respond2010=1) in=in2010)
    freqCount2011(where=(respond2011=1) in=in2011) freqCount2012(where=(respond2012=1) in=in2012) freqCount2013(where=(respond2013=1) in=in2013);
	if in2008=1 then Year=2008;
	if in2009=1 then year=2009;
	if in2010=1 then year=2010;
	if in2011=1 then year=2011;
	if in2012=1 then year=2012;
	if in2013=1 then year=2013;
	keep year count;
	proc print;
run;

**************************************************************
Count Response Years
*************************************************************;
data hartford;
set data.hartford;
if respond2008=. then respond2008=0;if respond2009=. then respond2009=0;if respond2010=. then respond2010=0;
if respond2011=. then respond2011=0;if respond2012=. then respond2012=0;if respond2013=. then respond2013=0;
Nrespond=respond2008+respond2009+respond2010+respond2011+respond2012+respond2013;
proc freq;tables Nrespond;
proc sort;by provider;
run;
  


****************************************************************
Create Composite Score
****************************************************************;
 

data hartford;
set hartford;
array temp {2160} RawAMIReadm302008--Nhipfxmort902013;
do i=1 to 2160;
if temp{i}=. then temp{i}=0;
end;
run;

%macro comp(meas=,day=,yr=);
proc sql;
create table &meas.&day.&yr. as
select provider, 
sum(obsAMI&meas.&day.&yr.) as sumobsAMI&meas.&day.&yr., sum(obsCHF&meas.&day.&yr.) as sumobsCHF&meas.&day.&yr., sum(obsPN&meas.&day.&yr.) as sumobsPN&meas.&day.&yr., 

       sum(NAMI&meas.&day.&yr.) as sumNAMI&meas.&day.&yr., sum(NCHF&meas.&day.&yr.) as sumNCHF&meas.&day.&yr., sum(NPN&meas.&day.&yr.) as sumNPN&meas.&day.&yr.,

	   (calculated sumobsAMI&meas.&day.&yr. + calculated sumobsCHF&meas.&day.&yr. + calculated sumobsPN&meas.&day.&yr.)
       /(calculated sumNAMI&meas.&day.&yr. + calculated sumNCHF&meas.&day.&yr. + calculated sumNPN&meas.&day.&yr.) as overall3cond&meas.&day.&yr.,

       (obsAMI&meas.&day.&yr.+obsCHF&meas.&day.&yr.+obsPN&meas.&day.&yr.)/(expAMI&meas.&day.&yr.+expCHF&meas.&day.&yr.+expPN&meas.&day.&yr.) as ratio3cond,
      (calculated overall3cond&meas.&day.&yr.)*(calculated ratio3cond) as adj3cond&meas.&day.&yr.,

	    sum(obsAMI&meas.&day.&yr.) as sumobsAMI&meas.&day.&yr., sum(obsCHF&meas.&day.&yr.) as sumobsCHF&meas.&day.&yr., sum(obsPN&meas.&day.&yr.) as sumobsPN&meas.&day.&yr., 
		sum(obscopd&meas.&day.&yr.) as sumobsCOPD&meas.&day.&yr., sum(obsstroke&meas.&day.&yr.) as sumobsstroke&meas.&day.&yr., sum(obssepsis&meas.&day.&yr.) as sumobssepsis&meas.&day.&yr., 
		sum(obsesggas&meas.&day.&yr.) as sumobsesggas&meas.&day.&yr., sum(obsgib&meas.&day.&yr.) as sumobsgib&meas.&day.&yr., sum(obsuti&meas.&day.&yr.) as sumobsuti&meas.&day.&yr., 
		sum(obsmetdis&meas.&day.&yr.) as sumobsmetdis&meas.&day.&yr., sum(obsarrhy&meas.&day.&yr.) as sumobsarrhy&meas.&day.&yr., sum(obschest&meas.&day.&yr.) as sumobschest&meas.&day.&yr., 
		sum(obsrenalf&meas.&day.&yr.) as sumobsrenalf&meas.&day.&yr., sum(obsresp&meas.&day.&yr.) as sumobsresp&meas.&day.&yr., sum(obshipfx&meas.&day.&yr.) as sumobshipfx&meas.&day.&yr., 

       sum(NAMI&meas.&day.&yr.) as sumNAMI&meas.&day.&yr., sum(NCHF&meas.&day.&yr.) as sumNCHF&meas.&day.&yr., sum(NPN&meas.&day.&yr.) as sumNPN&meas.&day.&yr.,
	   sum(Ncopd&meas.&day.&yr.) as sumNcopd&meas.&day.&yr., sum(Nstroke&meas.&day.&yr.) as sumNstroke&meas.&day.&yr., sum(Nsepsis&meas.&day.&yr.) as sumNsepsis&meas.&day.&yr.,
	   sum(Nesggas&meas.&day.&yr.) as sumNesggas&meas.&day.&yr., sum(Ngib&meas.&day.&yr.) as sumNgib&meas.&day.&yr., sum(Nuti&meas.&day.&yr.) as sumNuti&meas.&day.&yr.,
	   sum(Nmetdis&meas.&day.&yr.) as sumNmetdis&meas.&day.&yr., sum(Narrhy&meas.&day.&yr.) as sumNarrhy&meas.&day.&yr., sum(Nchest&meas.&day.&yr.) as sumNchest&meas.&day.&yr.,
	   sum(Nrenalf&meas.&day.&yr.) as sumNrenalf&meas.&day.&yr., sum(Nresp&meas.&day.&yr.) as sumNresp&meas.&day.&yr., sum(Nhipfx&meas.&day.&yr.) as sumNhipfx&meas.&day.&yr.,

	   (calculated sumobsAMI&meas.&day.&yr. + calculated sumobsCHF&meas.&day.&yr. + calculated sumobsPN&meas.&day.&yr.
       +calculated sumobscopd&meas.&day.&yr. + calculated sumobsCHF&meas.&day.&yr. + calculated sumobsPN&meas.&day.&yr.
       +calculated sumobsAMI&meas.&day.&yr. + calculated sumobsCHF&meas.&day.&yr. + calculated sumobsPN&meas.&day.&yr.
       +calculated sumobsAMI&meas.&day.&yr. + calculated sumobsCHF&meas.&day.&yr. + calculated sumobsPN&meas.&day.&yr.
       +calculated sumobsAMI&meas.&day.&yr. + calculated sumobsCHF&meas.&day.&yr. + calculated sumobsPN&meas.&day.&yr.)
       /(calculated sumNAMI&meas.&day.&yr. + calculated sumNCHF&meas.&day.&yr. + calculated sumNPN&meas.&day.&yr.
        +calculated sumNcopd&meas.&day.&yr. + calculated sumNCHF&meas.&day.&yr. + calculated sumNPN&meas.&day.&yr.
		+calculated sumNAMI&meas.&day.&yr. + calculated sumNCHF&meas.&day.&yr. + calculated sumNPN&meas.&day.&yr.
		+calculated sumNAMI&meas.&day.&yr. + calculated sumNCHF&meas.&day.&yr. + calculated sumNPN&meas.&day.&yr.
		+calculated sumNAMI&meas.&day.&yr. + calculated sumNCHF&meas.&day.&yr. + calculated sumNPN&meas.&day.&yr.) as overall15cond&meas.&day.&yr.,

       (obsAMI&meas.&day.&yr.+obsCHF&meas.&day.&yr.+obsPN&meas.&day.&yr.
        +obscopd&meas.&day.&yr.+obsstroke&meas.&day.&yr.+obssepsis&meas.&day.&yr.
        +obsesggas&meas.&day.&yr.+obsgib&meas.&day.&yr.+obsUTI&meas.&day.&yr.
        +obsmetdis&meas.&day.&yr.+obsarrhy&meas.&day.&yr.+obschest&meas.&day.&yr.
        +obsrenalf&meas.&day.&yr.+obsresp&meas.&day.&yr.+obshipfx&meas.&day.&yr.)
       /(expAMI&meas.&day.&yr.+expCHF&meas.&day.&yr.+expPN&meas.&day.&yr.
        +expcopd&meas.&day.&yr.+expstroke&meas.&day.&yr.+expsepsis&meas.&day.&yr.
        +expesggas&meas.&day.&yr.+expgib&meas.&day.&yr.+exputi&meas.&day.&yr.
        +expmetdis&meas.&day.&yr.+exparrhy&meas.&day.&yr.+expchest&meas.&day.&yr.
        +exprenalf&meas.&day.&yr.+expresp&meas.&day.&yr.+exphipfx&meas.&day.&yr.) as ratio15cond,
      (calculated overall15cond&meas.&day.&yr.)*(calculated ratio15cond) as adj15cond&meas.&day.&yr.  

from Hartford;
quit;

proc sort data=&meas.&day.&yr. ;by provider;run;
%mend comp;
%comp(meas=readm,day=30,yr=2008);
%comp(meas=readm,day=30,yr=2009);
%comp(meas=readm,day=30,yr=2010);
%comp(meas=readm,day=30,yr=2011);
%comp(meas=readm,day=30,yr=2012);
%comp(meas=readm,day=30,yr=2013);

%comp(meas=readm,day=90,yr=2008);
%comp(meas=readm,day=90,yr=2009);
%comp(meas=readm,day=90,yr=2010);
%comp(meas=readm,day=90,yr=2011);
%comp(meas=readm,day=90,yr=2012);
%comp(meas=readm,day=90,yr=2013);

%comp(meas=mort,day=30,yr=2008);
%comp(meas=mort,day=30,yr=2009);
%comp(meas=mort,day=30,yr=2010);
%comp(meas=mort,day=30,yr=2011);
%comp(meas=mort,day=30,yr=2012);
%comp(meas=mort,day=30,yr=2013);

%comp(meas=mort,day=90,yr=2008);
%comp(meas=mort,day=90,yr=2009);
%comp(meas=mort,day=90,yr=2010);
%comp(meas=mort,day=90,yr=2011);
%comp(meas=mort,day=90,yr=2012);
%comp(meas=mort,day=90,yr=2013);
data data;
merge hartford(in=in1) 
readm302008(keep=provider adj3condreadm302008 adj15condreadm302008) readm302009(keep=provider adj3condreadm302009 adj15condreadm302009) readm302010(keep=provider adj3condreadm302010 adj15condreadm302010)
readm302011(keep=provider adj3condreadm302011 adj15condreadm302011) readm302012(keep=provider adj3condreadm302012 adj15condreadm302012) readm302013(keep=provider adj3condreadm302013 adj15condreadm302013) 

readm902008(keep=provider adj3condreadm902008 adj15condreadm902008) readm902009(keep=provider adj3condreadm902009 adj15condreadm902009) readm902010(keep=provider adj3condreadm902010 adj15condreadm902010)
readm902011(keep=provider adj3condreadm902011 adj15condreadm902011) readm902012(keep=provider adj3condreadm902012 adj15condreadm902012) readm902013(keep=provider adj3condreadm902013 adj15condreadm902013) 

mort302008(keep=provider adj3condmort302008 adj15condmort302008) mort302009(keep=provider adj3condmort302009 adj15condmort302009) mort302010(keep=provider adj3condmort302010 adj15condmort302010)
mort302011(keep=provider adj3condmort302011 adj15condmort302011) mort302012(keep=provider adj3condmort302012 adj15condmort302012) mort302013(keep=provider adj3condmort302013 adj15condmort302013) 

mort902008(keep=provider adj3condmort902008 adj15condmort902008) mort902009(keep=provider adj3condmort902009 adj15condmort902009) mort902010(keep=provider adj3condmort902010 adj15condmort902010)
mort902011(keep=provider adj3condmort902011 adj15condmort902011) mort902012(keep=provider adj3condmort902012 adj15condmort902012) mort902013(keep=provider adj3condmort902013 adj15condmort902013) 
;
by provider;
if in1=1;
run;
 
 

***************************************************************
Model 1: 
Hospitals with 3 or more data points only, Get hospital-specific starting point, 
growth trajectory, and the standard error of the growth trajectory,
of number of E-H-R functionalities, by using either pooled or single hospital linear regression model 
with time as independent variable (in this case, the two will have exactly the same results, 
in theory, because both models only use data from a single hospital)
***************************************************************;
data model1;
set data;
where Nrespond>=3;
NBasicEHR=NBasicEHR2008;year=0;output;
NBasicEHR=NBasicEHR2009;year=1;output;
NBasicEHR=NBasicEHR2010;year=2;output;
NBasicEHR=NBasicEHR2011;year=3;output;
NBasicEHR=NBasicEHR2012;year=4;output;
NBasicEHR=NBasicEHR2013;year=5;output;
keep provider NBasicEHR year NBasicEHR2008   NBasicEHR2009  NBasicEHR2010  NBasicEHR2011  NBasicEHR2012  NBasicEHR2013  ;
proc means ;where year=0;var NBasicEHR2008   NBasicEHR2009  NBasicEHR2010  NBasicEHR2011  NBasicEHR2012  NBasicEHR2013;
run;

data providerlist;set data; where Nrespond>=3;keep provider;run;
 

*3296 hospitals;
%macro model1;
%do i=1 %to 3296;
data temp;set providerlist;if _n_=&i. then call symput("provider",provider);run;
proc glm data=model1;
where provider=symget('provider');
model NBasicEHR= Year /solution;
ods output parameterEstimates=provider&i.;
run;

data provider&i.;set provider&i.;provider=symget('provider');N=&i.;run;
%end;
%mend model1;
%model1;

%macro output1;
data temp;set provider1;run;
%do i=2 %to 3311;
data temp;set temp provider&i.;run;
%end;
data data.Model1;set temp;proc print;run;
%mend output1;
%output1;

*How do the slope and intercept look like in general?;

proc means data=data.model1 mean min Q1 median Q3 max ;
where parameter="Intercept";
var Estimate;
run;
proc means data=data.model1 mean min Q1 median Q3 max ;
where parameter="year";
var Estimate;
run;
proc means data=data.model1 mean min Q1 median Q3 max ;
where parameter="year";
var Stderr;
run;
 


****************************************************************************
Model 2:
Regression model, using 30/90-day risk-adjusted readmission and mortality, Preventive Quality Indicator, and Medicare Spending (need decision), as outcome measures, 
look at how do the starting point and growth trajectory of number of E-H-R functionalities relate to performance measures over time, 
and weight by the inverse of standard errors from model 1 (giving less credibility to less stable hospitals). 

              Outcome = starting point + growth trajectory (drop if not meaningful) 
                     + Time + starting point* Time + growth trajectory * Time

Ideas: higher starting point might have better performance measure at the baseline,
       greater growth trajectory might have better performance measure improvement over time.

****************************************************************************;
%macro model2(cond=,meas=,day=,title=);
proc sql;
create table intercept as
select a.Nrespond,a.provider, 
a.adj&cond.&meas.&day.2008 , a.adj&cond.&meas.&day.2009 , a.adj&cond.&meas.&day.2010, a.adj&cond.&meas.&day.2011,a.adj&cond.&meas.&day.2012, a.adj&cond.&meas.&day.2013, 
b.Estimate as startpoint
from data a left join data.model1 b
on a.provider=b.provider
where a.Nrespond>=3 and b.parameter="Intercept";
quit;

proc sql;
create table slope as
select a.*,
b.Estimate as slope,b.StdErr as slopeStdErr
from intercept a left join data.model1 b
on a.provider=b.provider
where b.parameter="year";
quit;


data ldata;
set slope;
if slopeStdErr=0 or slopeStdErr=. then wt=1/0.04;else wt=1/slopeStdErr;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2008;year=0;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2009;year=1;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2010;year=2;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2011;year=3;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2012;year=4;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2013;year=5;output;
proc means;var adj&cond.&meas.&day.;
output out=outcome&cond.&meas.&day. mean=mean  min=min q1=q1  median=median  q3=q3  max=max  ;
run;
proc glimmix data=ldata NOCLPRINT;
title "&title.";
class provider;
weight wt;
model adj&cond.&meas.&day.=startpoint year startpoint*year slope*year  /s dist=normal  ;
random int  / subject=provider ;
ods output ParameterEstimates=est&cond.&meas.&day. ;
run;

data est&cond.&meas.&day.;
	length title $70.;
set est&cond.&meas.&day.;
	length Estimate1 $15.;
	title=&title.;
	if Probt<0.01 then do;
		Estimate1=Estimate||'***';output;
	end;
	else if Probt<0.05 then do;
		Estimate1=Estimate||'**';output;
	end;
	else if Probt<0.1 then do;
		Estimate1=Estimate||'*';output;
	end;
	else do;
		Estimate1=Estimate||'';output;
	end;
	Estimate1='('||StdErr||')';output;
keep Effect Estimate1 title  Probt;
PROC PRINT;	
run;

/*
data outcome&cond.&meas.&day.;
length title $70.;
set outcome&cond.&meas.&day.;
title=&title.;
run;
*/

%mend model2;
%model2(cond=AMI,meas=readm,day=30,title="Risk-adjusted Acute Myocardial Infarction 30-day Readmission Rate");
%model2(cond=chf,meas=readm,day=30,title="Risk-adjusted Congestive Heart Failure 30-day Readmission Rate");
%model2(cond=pn,meas=readm,day=30,title="Risk-adjusted Pneumonia 30-day Readmission Rate");
%model2(cond=3cond,meas=readm,day=30,title="Risk-adjusted AMI/CHF/PN-Composite 30-day Readmission Rate");
%model2(cond=copd,meas=readm,day=30,title="Risk-adjusted Chronic obstructive pulmonary disease 30-day Readmission Rate");
%model2(cond=stroke,meas=readm,day=30,title="Risk-adjusted Stroke 30-day Readmission Rate");
%model2(cond=sepsis,meas=readm,day=30,title="Risk-adjusted Sepsis 30-day Readmission Rate");
%model2(cond=esggas,meas=readm,day=30,title="Risk-adjusted Esophageal/Gastric Disease 30-day Readmission Rate");
%model2(cond=gib,meas=readm,day=30,title="Risk-adjusted GI Bleeding 30-day Readmission Rate");
%model2(cond=uti,meas=readm,day=30,title="Risk-adjusted Urinary Tract Infection 30-day Readmission Rate");
%model2(cond=metdis,meas=readm,day=30,title="Risk-adjusted Metabolic Disorder 30-day Readmission Rate");
%model2(cond=arrhy,meas=readm,day=30,title="Risk-adjusted Arrhythmia 30-day Readmission Rate");
%model2(cond=chest,meas=readm,day=30,title="Risk-adjusted Chest Pain 30-day Readmission Rate");
%model2(cond=renalf,meas=readm,day=30,title="Risk-adjusted Renal Failure 30-day Readmission Rate");
%model2(cond=resp,meas=readm,day=30,title="Risk-adjusted Respiratory Disease 30-day Readmission Rate");
%model2(cond=hipfx,meas=readm,day=30,title="Risk-adjusted Hip Fracture 30-day Readmission Rate");
%model2(cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");



%model2(cond=AMI,meas=readm,day=90,title="Risk-adjusted Acute Myocardial Infarction 90-day Readmission Rate");
%model2(cond=chf,meas=readm,day=90,title="Risk-adjusted Congestive Heart Failure 90-day Readmission Rate");
%model2(cond=pn,meas=readm,day=90,title="Risk-adjusted Pneumonia 90-day Readmission Rate");
%model2(cond=3cond,meas=readm,day=90,title="Risk-adjusted AMI/CHF/PN-Composite 90-day Readmission Rate");
%model2(cond=copd,meas=readm,day=90,title="Risk-adjusted Chronic obstructive pulmonary disease 90-day Readmission Rate");
%model2(cond=stroke,meas=readm,day=90,title="Risk-adjusted Stroke 90-day Readmission Rate");
%model2(cond=sepsis,meas=readm,day=90,title="Risk-adjusted Sepsis 90-day Readmission Rate");
%model2(cond=esggas,meas=readm,day=90,title="Risk-adjusted Esophageal/Gastric Disease 90-day Readmission Rate");
%model2(cond=gib,meas=readm,day=90,title="Risk-adjusted GI Bleeding 90-day Readmission Rate");
%model2(cond=uti,meas=readm,day=90,title="Risk-adjusted Urinary Tract Infection 90-day Readmission Rate");
%model2(cond=metdis,meas=readm,day=90,title="Risk-adjusted Metabolic Disorder 90-day Readmission Rate");
%model2(cond=arrhy,meas=readm,day=90,title="Risk-adjusted Arrhythmia 90-day Readmission Rate");
%model2(cond=chest,meas=readm,day=90,title="Risk-adjusted Chest Pain 90-day Readmission Rate");
%model2(cond=renalf,meas=readm,day=90,title="Risk-adjusted Renal Failure 90-day Readmission Rate");
%model2(cond=resp,meas=readm,day=90,title="Risk-adjusted Respiratory Disease 90-day Readmission Rate");
%model2(cond=hipfx,meas=readm,day=90,title="Risk-adjusted Hip Fracture 90-day Readmission Rate");
%model2(cond=15cond,meas=readm,day=90,title="Risk-adjusted 15-Composite 90-day Readmission Rate");

 
%model2(cond=AMI,meas=mort,day=30,title="Risk-adjusted Acute Myocardial Infarction 30-day Mortality Rate");
%model2(cond=chf,meas=mort,day=30,title="Risk-adjusted Congestive Heart Failure 30-day Mortality Rate");
%model2(cond=pn,meas=mort,day=30,title="Risk-adjusted Pneumonia 30-day Mortality Rate");
%model2(cond=3cond,meas=mort,day=30,title="Risk-adjusted AMI/CHF/PN-Composite 30-day Mortality Rate");
%model2(cond=copd,meas=mort,day=30,title="Risk-adjusted Chronic obstructive pulmonary disease 30-day Mortality Rate");
%model2(cond=stroke,meas=mort,day=30,title="Risk-adjusted Stroke 30-day Mortality Rate");
%model2(cond=sepsis,meas=mort,day=30,title="Risk-adjusted Sepsis 30-day Mortality Rate");
%model2(cond=esggas,meas=mort,day=30,title="Risk-adjusted Esophageal/Gastric Disease 30-day Mortality Rate");
%model2(cond=gib,meas=mort,day=30,title="Risk-adjusted GI Bleeding 30-day Mortality Rate");
%model2(cond=uti,meas=mort,day=30,title="Risk-adjusted Urinary Tract Infection 30-day Mortality Rate");
%model2(cond=metdis,meas=mort,day=30,title="Risk-adjusted Metabolic Disorder 30-day Mortality Rate");
%model2(cond=arrhy,meas=mort,day=30,title="Risk-adjusted Arrhythmia 30-day Mortality Rate");
%model2(cond=chest,meas=mort,day=30,title="Risk-adjusted Chest Pain 30-day Mortality Rate");
%model2(cond=renalf,meas=mort,day=30,title="Risk-adjusted Renal Failure 30-day Mortality Rate");
%model2(cond=resp,meas=mort,day=30,title="Risk-adjusted Respiratory Disease 30-day Mortality Rate");
%model2(cond=hipfx,meas=mort,day=30,title="Risk-adjusted Hip Fracture 30-day Mortality Rate");
%model2(cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
 


%model2(cond=AMI,meas=mort,day=90,title="Risk-adjusted Acute Myocardial Infarction 90-day Mortality Rate");
%model2(cond=chf,meas=mort,day=90,title="Risk-adjusted Congestive Heart Failure 90-day Mortality Rate");
%model2(cond=pn,meas=mort,day=90,title="Risk-adjusted Pneumonia 90-day Mortality Rate");
%model2(cond=3cond,meas=mort,day=90,title="Risk-adjusted AMI/CHF/PN-Composite 90-day Mortality Rate");
%model2(cond=copd,meas=mort,day=90,title="Risk-adjusted Chronic obstructive pulmonary disease 90-day Mortality Rate");
%model2(cond=stroke,meas=mort,day=90,title="Risk-adjusted Stroke 90-day Mortality Rate");
%model2(cond=sepsis,meas=mort,day=90,title="Risk-adjusted Sepsis 90-day Mortality Rate");
%model2(cond=esggas,meas=mort,day=90,title="Risk-adjusted Esophageal/Gastric Disease 90-day Mortality Rate");
%model2(cond=gib,meas=mort,day=90,title="Risk-adjusted GI Bleeding 90-day Mortality Rate");
%model2(cond=uti,meas=mort,day=90,title="Risk-adjusted Urinary Tract Infection 90-day Mortality Rate");
%model2(cond=metdis,meas=mort,day=90,title="Risk-adjusted Metabolic Disorder 90-day Mortality Rate");
%model2(cond=arrhy,meas=mort,day=90,title="Risk-adjusted Arrhythmia 90-day Mortality Rate");
%model2(cond=chest,meas=mort,day=90,title="Risk-adjusted Chest Pain 90-day Mortality Rate");
%model2(cond=renalf,meas=mort,day=90,title="Risk-adjusted Renal Failure 90-day Mortality Rate");
%model2(cond=resp,meas=mort,day=90,title="Risk-adjusted Respiratory Disease 90-day Mortality Rate");
%model2(cond=hipfx,meas=mort,day=90,title="Risk-adjusted Hip Fracture 90-day Mortality Rate");
%model2(cond=15cond,meas=mort,day=90,title="Risk-adjusted 15-Composite 90-day Mortality Rate");
 



%model2(cond=PQI,meas=adm,day=1yr,title="Preventive Quality Indicators per 1000 Discharges");
 

/* Version 2: SubGroup Analysis
1.	HIE outside of System
    HIEoutSystem_2013
 	Create a dummy variable = 1 if Q3A_X2 or Q3A_X4 == 1 from the AHA IT supplement where X is A through G (Total of 14 Variables)
 	This variable should = 1 if hospitals exchange any kind of patient data with hospitals or ambulatory providers outside of their systems
2.	Use of EHR data for performance measurement
    PerfMeas_2013
 	Create a dummy variable = 1 if Q18_1 or Q18_2 or Q18_3 == 1 from the AHA IT supplement
 	This variable should = 1 if hospitals use EHR data to measure organizational performance, unit-level performance, or individual provider performance
3.	Bed Size (6-99, 100-399, 400+)
    hospsize
 	Recode the AHA variable BSC (1 2 3 = Small) (4 5 6 = Medium) (7 8 = Large)
 	This variable should = Small if bed size is less than 100, medium if between 100 and 399 and large if over 400
4.	Urban/Rural
    Urban
 	Recode the AHA variable CBSATYPE (Micro & Rural = Rural) (Metro = Urban)
5.	Operational HIE in HSA
     hie_nostatewide
 	I believe Ifve sent this data to you already, please let me know if I havenft yet! 
 	This variable should  = 1 if there is an operational HIO in the hospitalfs HSA and 0 otherwise
6.	Above/Below Median average medicare spending in HSA
    SpendingAboveAve
 	Create a dummy variable for below or above the median avg Medicare spending per enrollee (price, age, sex and race adjusted )
*/

data data;
set data;
if CBSATYPE in ('Micro','Rural') then Urban=0;else if CBSATYPE in ('Metro') then Urban=1;
proc freq;
title "SubGroup Frequency";where  Nrespond>=3;tables 
HIEoutSystem_2008  HIEoutSystem_2009  HIEoutSystem_2010  HIEoutSystem_2011  HIEoutSystem_2012  HIEoutSystem_2013   
PerfMeas_2013 
hospsize Urban hie_nostatewide SpendingAboveAve/missing;
run;
  

%macro Model3G3(cond=,meas=,day=,group=,title=);
proc sql;
create table intercept as
select a.provider,  a.&group ,
a.adj&cond.&meas.&day.2008 , a.adj&cond.&meas.&day.2009 , a.adj&cond.&meas.&day.2010, a.adj&cond.&meas.&day.2011,a.adj&cond.&meas.&day.2012, a.adj&cond.&meas.&day.2013, 
b.Estimate as startpoint
from data a left join data.model1 b
on a.provider=b.provider
where a.Nrespond>=3 and b.parameter="Intercept";
quit;

proc sql;
create table slope as
select a.*,
b.Estimate as slope,b.StdErr as slopeStdErr
from intercept a left join data.model1 b
on a.provider=b.provider
where b.parameter="year";
quit;

*Average startpoint and slope for each group;
proc means data=slope;
class &group. ;
var slope;
output out=&group.slope mean=mean;
run;
data _null_;
	set &group.slope;
	if &group.=1 then call symput("slope&group.1",mean);
    else if &group.=2 then call symput("slope&group.2",mean);
	else if &group.=3 then call symput("slope&group.3",mean);
run;

proc means data=slope;
class &group. ;
var startpoint;
output out=&group.startpoint mean=mean;
run;
data _null_;
	set &group.startpoint;
	if &group.=1 then call symput("startpoint&group.1",mean);
    else if &group.=2 then call symput("startpoint&group.2",mean);
	else if &group.=3 then call symput("startpoint&group.3",mean);
run;


proc print data=&group.slope;title "slope";run;
proc print data=&group.startpoint;title "startpoint";run;

data ldata;
set slope;
 
if slopeStdErr=0 or slopeStdErr=. then wt=1/0.04;else wt=1/slopeStdErr;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2008;year=0;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2009;year=1;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2010;year=2;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2011;year=3;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2012;year=4;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2013;year=5;output;
proc means;var adj&cond.&meas.&day.;
output out=outcome&cond.&meas.&day. mean=mean  min=min q1=q1  median=median  q3=q3  max=max  ;
run;


data preddata;
set ldata;
if &group.=1 then do;
	startpoint=symget("startpoint&group.1")*1;
	slope=symget("slope&group.1")*1;
end;
else if &group.=2 then do;
	startpoint=symget("startpoint&group.2")*1;
	slope=symget("slope&group.2")*1;
end;
else if &group.=3 then do;
	startpoint=symget("startpoint&group.3")*1;
	slope=symget("slope&group.3")*1;
end;
run;



proc sort data=ldata;by descending &group ;run;
 
proc glimmix data=ldata NOCLPRINT order=data;
title &title. ;
class provider &group. ;
weight wt;
model adj&cond.&meas.&day.=startpoint year startpoint*year slope*year
                           &group. &group.*startpoint &group.*year &group.*startpoint*year &group.*slope*year/s dist=normal  ;
random int  / subject=provider ;

store sasuser.beta;
 

Estimate "Intercept &group.=1" intercept 1 &group. 0 0 1;
Estimate "startpoint &group.=1" startpoint 1 &group.*startpoint 0 0 1;
Estimate "year &group.=1" year 1 &group.*year 0 0 1;
Estimate "&group.*startpoint*year &group.=1" startpoint*year 1 &group.*startpoint*year 0 0 1;
Estimate "&group.*slope*year &group.=1" slope*year 1 &group.*slope*year 0 0 1;

Estimate "Intercept &group.=2" intercept 1 &group. 0 1 0;
Estimate "startpoint &group.=2" startpoint 1 &group.*startpoint 0 1 0;
Estimate "year &group.=2" year 1 &group.*year 0 1 0;
Estimate "&group.*startpoint*year &group.=2" startpoint*year 1 &group.*startpoint*year 0 1 0;
Estimate "&group.*slope*year &group.=2" slope*year 1 &group.*slope*year 0 1 0;

Estimate "Intercept &group.=3" intercept 1 &group. 1 0 0;
Estimate "startpoint &group.=3" startpoint 1 &group.*startpoint 1 0 0;
Estimate "year &group.=3" year 1 &group.*year 1 0 0;
Estimate "&group.*startpoint*year &group.=3" startpoint*year 1 &group.*startpoint*year 1 0 0;
Estimate "&group.*slope*year &group.=3" slope*year 1 &group.*slope*year 1 0 0;

ods output  Estimates=est1&cond.&meas.&day.   ParameterEstimates=est&cond.&meas.&day.  ;
run;
  
proc plm source=sasuser.beta ;
   score data=preddata out=projectdata predicted ;
run;


data G1&cond.&meas.&day. G2&cond.&meas.&day. G3&cond.&meas.&day.;
set est1&cond.&meas.&day.;
Group=scan(label,2,'=');
Effect=scan(label,1,'');
if Group=1 then output G1&cond.&meas.&day.;
else if Group=2 then output G2&cond.&meas.&day.;
else if Group=3 then output G3&cond.&meas.&day.;
keep  effect estimate StdErr probt;
run;



data G1&cond.&meas.&day.;
length  Effect1 $30.;
set G1&cond.&meas.&day.;
 
length EstimateGroup1 $30.  ;
if Probt<0.01 then do;EstimateGroup1=Estimate||'***';Effect1=Effect||"(Beta Coeffient)";output;end;
else if Probt<0.05 then do;EstimateGroup1=Estimate||'**';Effect1=Effect||"(Beta Coeffient)";output;end;
else if Probt<0.1 then do;EstimateGroup1=Estimate||'*';Effect1=Effect||"(Beta Coeffient)";output;end;
else do;EstimateGroup1=Estimate||'';Effect1=Effect||"(Beta Coeffient)";output;end;
EstimateGroup1='('||StdErr||')';Effect1=Effect||"(Std Err)";output;
keep Effect1 EstimateGroup1  ;
proc sort ;by Effect1;
run;


data G2&cond.&meas.&day.;
length   Effect1 $30.;
set G2&cond.&meas.&day.;
 
length EstimateGroup2 $30.  ;
if Probt<0.01 then do;EstimateGroup2=Estimate||'***';Effect1=Effect||"(Beta Coeffient)";output;end;
else if Probt<0.05 then do;EstimateGroup2=Estimate||'**';Effect1=Effect||"(Beta Coeffient)";output;end;
else if Probt<0.1 then do;EstimateGroup2=Estimate||'*';Effect1=Effect||"(Beta Coeffient)";output;end;
else do;EstimateGroup2=Estimate||'';Effect1=Effect||"(Beta Coeffient)";output;end;
EstimateGroup2='('||StdErr||')';Effect1=Effect||"(Std Err)";output;
keep Effect1 EstimateGroup2  ;
proc sort ;by Effect1;
run;


data G3&cond.&meas.&day.;
length   Effect1 $30.;
set G3&cond.&meas.&day.;
 
length EstimateGroup3 $30.  ;
if Probt<0.01 then do;EstimateGroup3=Estimate||'***';Effect1=Effect||"(Beta Coeffient)";output;end;
else if Probt<0.05 then do;EstimateGroup3=Estimate||'**';Effect1=Effect||"(Beta Coeffient)";output;end;
else if Probt<0.1 then do;EstimateGroup3=Estimate||'*';Effect1=Effect||"(Beta Coeffient)";output;end;
else do;EstimateGroup3=Estimate||'';Effect1=Effect||"(Beta Coeffient)";output;end;
EstimateGroup2='('||StdErr||')';Effect1=Effect||"(Std Err)";output;
keep Effect1 EstimateGroup3  ;
proc sort ;by Effect1;
run;
******Output Formated Tables;
data Out1&cond.&meas.&day.;
length title $50.;
merge G1&cond.&meas.&day. G2&cond.&meas.&day. G3&cond.&meas.&day.;
by Effect1;
title=&title.;
proc print;
run;

*****Project Regression lines by group;
data projectdata;set projectdata;year=2008+year;run;
proc means data=projectdata;
class year &group.;
var predicted;
output out=temp mean=mean;
run;

ods listing gpath="C:\data\Projects\Hartford";
proc sgplot data=temp;where year ne . and &group. ne .;
title &title. ;
%if &cond=PQI %then %do;
format mean 8.0 ;
%end;
%else   %do;
format mean percent7.2 ;
%end;
scatter X=year y=mean/markerattrs=(color=black symbol=STARFILLED); 
series X=year y=mean/group=&group. datalabel=mean ; 
xaxis label='Year' values=(2008 to 2013 by 1);
yaxis label=&title. ;
run;



%mend model3G3;
%model3G3(cond=15cond,meas=readm,day=30,group=hospsize, title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%model3G3(cond=15cond,meas=readm,day=90,group=hospsize, title="Risk-adjusted 15-Composite 90-day Readmission Rate");
%model3G3(cond=15cond,meas=mort,day=30,group=hospsize, title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%model3G3(cond=15cond,meas=mort,day=90,group=hospsize, title="Risk-adjusted 15-Composite 90-day Mortality Rate");
%model3G3(cond=PQI,meas=adm,day=1yr,group=hospsize,title="Preventive Quality Indicators per 1000 Discharges");


%macro Model3G2(cond=,meas=,day=,group=,title=);
proc sql;
create table intercept as
select a.provider,  a.&group ,
a.adj&cond.&meas.&day.2008 , a.adj&cond.&meas.&day.2009 , a.adj&cond.&meas.&day.2010, a.adj&cond.&meas.&day.2011,a.adj&cond.&meas.&day.2012, a.adj&cond.&meas.&day.2013, 
b.Estimate as startpoint
from data a left join data.model1 b
on a.provider=b.provider
where a.Nrespond>=3 and b.parameter="Intercept";
quit;

proc sql;
create table slope as
select a.*,
b.Estimate as slope,b.StdErr as slopeStdErr
from intercept a left join data.model1 b
on a.provider=b.provider
where b.parameter="year";
quit;


*Average startpoint and slope for each group;
proc means data=slope;
class &group. ;
var slope;
output out=&group.slope mean=mean;
run;
data _null_;
	set &group.slope;
	if &group.=0 then call symput("slope&group.0",mean);
    else if &group.=1 then call symput("slope&group.1",mean);
run;

proc means data=slope;
class &group. ;
var startpoint;
output out=&group.startpoint mean=mean;
run;
data _null_;
	set &group.startpoint;
	if &group.=0 then call symput("startpoint&group.0",mean);
    else if &group.=1 then call symput("startpoint&group.1",mean);
run;


proc print data=&group.slope;title "slope";run;
proc print data=&group.startpoint;title "startpoint";run;


data ldata;
set slope;
if slopeStdErr=0 or slopeStdErr=. then wt=1/0.04;else wt=1/slopeStdErr;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2008;year=0;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2009;year=1;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2010;year=2;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2011;year=3;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2012;year=4;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2013;year=5;output;
proc means;var adj&cond.&meas.&day.;
output out=outcome&cond.&meas.&day. mean=mean  min=min q1=q1  median=median  q3=q3  max=max  ;
run;


data preddata;
set ldata;
if &group.=0 then do;
	startpoint=symget("startpoint&group.0")*1;
	slope=symget("slope&group.0")*1;
end;
else if &group.=1 then do;
	startpoint=symget("startpoint&group.1")*1;
	slope=symget("slope&group.1")*1;
end;
run;

proc sort data=ldata;by descending &group ;run;
 

proc glimmix data=ldata NOCLPRINT order=data;
title "&title.";
class provider &group. ;
weight wt;
model adj&cond.&meas.&day.=startpoint year startpoint*year slope*year
                           &group. &group.*startpoint &group.*year &group.*startpoint*year &group.*slope*year/s dist=normal  ;
random int  / subject=provider ;
 

store sasuser.beta;
 
Estimate "Intercept &group.=0" intercept 1 &group.  0 1;
Estimate "startpoint &group.=0" startpoint 1 &group.*startpoint  0 1;
Estimate "year &group.=0" year 1 &group.*year  0 1;
Estimate "&group.*startpoint*year &group.=0" startpoint*year 1 &group.*startpoint*year  0 1;
Estimate "&group.*slope*year &group.=0" slope*year 1 &group.*slope*year  0 1;

Estimate "Intercept &group.=1" intercept 1 &group. 1 0;
Estimate "startpoint &group.=1" startpoint 1 &group.*startpoint 1 0;
Estimate "year &group.=1" year 1 &group.*year 1 0;
Estimate "&group.*startpoint*year &group.=1" startpoint*year 1 &group.*startpoint*year 1 0;
Estimate "&group.*slope*year &group.=1" slope*year 1 &group.*slope*year 1 0;
 
ods output  Estimates=est1&cond.&meas.&day.   ParameterEstimates=est&cond.&meas.&day.  ;
run;

 
proc plm source=sasuser.beta ;
   score data=preddata out=projectdata predicted ;
run;


data G0&cond.&meas.&day. G1&cond.&meas.&day.  ;
set est1&cond.&meas.&day.;
Group=scan(label,2,'=');
Effect=scan(label,1,'');
if Group=0 then output G0&cond.&meas.&day.;
else if Group=1 then output G1&cond.&meas.&day.;
keep  effect estimate StdErr probt;
run;



data G0&cond.&meas.&day.;
length  Effect1 $30.;
set G0&cond.&meas.&day.;
 
length EstimateGroup0 $30.  ;
if Probt<0.01 then do;EstimateGroup0=Estimate||'***';Effect1=Effect||"(Beta Coeffient)";output;end;
else if Probt<0.05 then do;EstimateGroup0=Estimate||'**';Effect1=Effect||"(Beta Coeffient)";output;end;
else if Probt<0.1 then do;EstimateGroup0=Estimate||'*';Effect1=Effect||"(Beta Coeffient)";output;end;
else do;EstimateGroup0=Estimate||'';Effect1=Effect||"(Beta Coeffient)";output;end;
EstimateGroup0='('||StdErr||')';Effect1=Effect||"(Std Err)";output;
keep Effect1 EstimateGroup0  ;
proc sort ;by Effect1;
run;


data G1&cond.&meas.&day.;
length   Effect1 $50.;
set G1&cond.&meas.&day.;
 
length EstimateGroup1 $30.  ;
if Probt<0.01 then do;EstimateGroup1=Estimate||'***';Effect1=Effect||"(Beta Coeffient)";output;end;
else if Probt<0.05 then do;EstimateGroup1=Estimate||'**';Effect1=Effect||"(Beta Coeffient)";output;end;
else if Probt<0.1 then do;EstimateGroup1=Estimate||'*';Effect1=Effect||"(Beta Coeffient)";output;end;
else do;EstimateGroup1=Estimate||'';Effect1=Effect||"(Beta Coeffient)";output;end;
EstimateGroup1='('||StdErr||')';Effect1=Effect||"(Std Err)";output;
keep Effect1 EstimateGroup1  ;
proc sort ;by Effect1;
run;

******Output Formated Tables;
data Out1&cond.&meas.&day.;
length title $50.;
merge G0&cond.&meas.&day. G1&cond.&meas.&day. ;
by Effect1;
title=&title.;
proc print;
run;

*****Project Regression lines by group;
data projectdata;set projectdata;year=2008+year;run;
proc means data=projectdata;
class year &group.;
var predicted;
output out=temp mean=mean;
run;

ods listing gpath="C:\data\Projects\Hartford";
proc sgplot data=temp;where year ne . and &group. ne .;
title &title. ;
%if &cond=PQI %then %do;
format mean 8.0 ;
%end;
%else   %do;
format mean percent7.2 ;
%end;
scatter X=year y=mean/markerattrs=(color=black symbol=STARFILLED); 
series X=year y=mean/group=&group. datalabel=mean ; 
xaxis label='Year' values=(2008 to 2013 by 1);
yaxis label=&title. ;
run;
%mend model3G2;
%model3G2(cond=15cond,meas=readm,day=30,group=urban, title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%model3G2(cond=15cond,meas=readm,day=90,group=urban, title="Risk-adjusted 15-Composite 90-day Readmission Rate");
%model3G2(cond=15cond,meas=mort,day=30,group=urban, title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%model3G2(cond=15cond,meas=mort,day=90,group=urban, title="Risk-adjusted 15-Composite 90-day Mortality Rate");
%model3G2(cond=PQI,meas=adm,day=1yr,group=urban,title="Preventive Quality Indicators per 1000 Discharges");

%model3G2(cond=15cond,meas=readm,day=30,group=hie_nostatewide, title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%model3G2(cond=15cond,meas=readm,day=90,group=hie_nostatewide, title="Risk-adjusted 15-Composite 90-day Readmission Rate");
%model3G2(cond=15cond,meas=mort,day=30,group=hie_nostatewide, title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%model3G2(cond=15cond,meas=mort,day=90,group=hie_nostatewide, title="Risk-adjusted 15-Composite 90-day Mortality Rate");
%model3G2(cond=PQI,meas=adm,day=1yr,group=hie_nostatewide,title="Preventive Quality Indicators per 1000 Discharges");


%model3G2(cond=15cond,meas=readm,day=30,group=SpendingAboveAve, title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%model3G2(cond=15cond,meas=readm,day=90,group=SpendingAboveAve, title="Risk-adjusted 15-Composite 90-day Readmission Rate");
%model3G2(cond=15cond,meas=mort,day=30,group=SpendingAboveAve, title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%model3G2(cond=15cond,meas=mort,day=90,group=SpendingAboveAve, title="Risk-adjusted 15-Composite 90-day Mortality Rate");
%model3G2(cond=PQI,meas=adm,day=1yr,group=SpendingAboveAve,title="Preventive Quality Indicators per 1000 Discharges");



%model3G2(cond=15cond,meas=readm,day=30,group=PerfMeas_2013, title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%model3G2(cond=15cond,meas=readm,day=90,group=PerfMeas_2013, title="Risk-adjusted 15-Composite 90-day Readmission Rate");
%model3G2(cond=15cond,meas=mort,day=30,group=PerfMeas_2013, title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%model3G2(cond=15cond,meas=mort,day=90,group=PerfMeas_2013, title="Risk-adjusted 15-Composite 90-day Mortality Rate");
%model3G2(cond=PQI,meas=adm,day=1yr,group=PerfMeas_2013,title="Preventive Quality Indicators per 1000 Discharges");





%macro Model3G2(cond=,meas=,day=,group=,title=);
proc sql;
create table intercept as
select a.provider,  a.HIEoutSystem_2008, a.HIEoutSystem_2009, a.HIEoutSystem_2010, a.HIEoutSystem_2011, a.HIEoutSystem_2012, a.HIEoutSystem_2013,
a.adj&cond.&meas.&day.2008 , a.adj&cond.&meas.&day.2009 , a.adj&cond.&meas.&day.2010, a.adj&cond.&meas.&day.2011,a.adj&cond.&meas.&day.2012, a.adj&cond.&meas.&day.2013, 
b.Estimate as startpoint
from data a left join data.model1 b
on a.provider=b.provider
where a.Nrespond>=3 and b.parameter="Intercept";
quit;

proc sql;
create table slope as
select a.*,
b.Estimate as slope,b.StdErr as slopeStdErr
from intercept a left join data.model1 b
on a.provider=b.provider
where b.parameter="year";
quit;


*Average startpoint and slope for each group;
proc means data=slope;
class  HIEoutSystem_2008 ;
var slope;
output out=&group.slope mean=mean;
run;
data _null_;
	set &group.slope;
	if HIEoutSystem_2008=0 then call symput("slope&group.0",mean);
    else if HIEoutSystem_2008=1 then call symput("slope&group.1",mean);
run;

proc means data=slope;
class HIEoutSystem_2008;
var startpoint;
output out=&group.startpoint mean=mean;
run;
data _null_;
	set &group.startpoint;
	if HIEoutSystem_2008=0 then call symput("startpoint&group.0",mean);
    else if HIEoutSystem_2008=1 then call symput("startpoint&group.1",mean);
run;


proc print data=&group.slope;title "slope";run;
proc print data=&group.startpoint;title "startpoint";run;


data ldata;
set slope;
if slopeStdErr=0 or slopeStdErr=. then wt=1/0.04;else wt=1/slopeStdErr;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2008; HIEoutSystem=HIEoutSystem_2008;year=0;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2009; HIEoutSystem=HIEoutSystem_2009;year=1;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2010; HIEoutSystem=HIEoutSystem_2010;year=2;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2011; HIEoutSystem=HIEoutSystem_2011;year=3;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2012; HIEoutSystem=HIEoutSystem_2012;year=4;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2013; HIEoutSystem=HIEoutSystem_2013;year=5;output;
proc means;var adj&cond.&meas.&day.;
output out=outcome&cond.&meas.&day. mean=mean  min=min q1=q1  median=median  q3=q3  max=max  ;
run;


data preddata;
set ldata;
if HIEoutSystem_2008=0 then do;
	startpoint=symget("startpoint&group.0")*1;
	slope=symget("slope&group.0")*1;
end;
else if HIEoutSystem_2008=1 then do;
	startpoint=symget("startpoint&group.1")*1;
	slope=symget("slope&group.1")*1;
end;
run;

proc sort data=ldata;by descending &group ;run;
 

proc glimmix data=ldata NOCLPRINT order=data;
title "&title.";
class provider &group. ;
weight wt;
model adj&cond.&meas.&day.=startpoint year startpoint*year slope*year
                           &group. &group.*startpoint &group.*year &group.*startpoint*year &group.*slope*year/s dist=normal  ;
random int  / subject=provider ;
 

store sasuser.beta;
 
Estimate "Intercept &group.=0" intercept 1 &group.  0 1;
Estimate "startpoint &group.=0" startpoint 1 &group.*startpoint  0 1;
Estimate "year &group.=0" year 1 &group.*year  0 1;
Estimate "&group.*startpoint*year &group.=0" startpoint*year 1 &group.*startpoint*year  0 1;
Estimate "&group.*slope*year &group.=0" slope*year 1 &group.*slope*year  0 1;

Estimate "Intercept &group.=1" intercept 1 &group. 1 0;
Estimate "startpoint &group.=1" startpoint 1 &group.*startpoint 1 0;
Estimate "year &group.=1" year 1 &group.*year 1 0;
Estimate "&group.*startpoint*year &group.=1" startpoint*year 1 &group.*startpoint*year 1 0;
Estimate "&group.*slope*year &group.=1" slope*year 1 &group.*slope*year 1 0;
 
ods output  Estimates=est1&cond.&meas.&day.   ParameterEstimates=est&cond.&meas.&day.  ;
run;

 
proc plm source=sasuser.beta ;
   score data=preddata out=projectdata predicted ;
run;


data G0&cond.&meas.&day. G1&cond.&meas.&day.  ;
set est1&cond.&meas.&day.;
Group=scan(label,2,'=');
Effect=scan(label,1,'');
if Group=0 then output G0&cond.&meas.&day.;
else if Group=1 then output G1&cond.&meas.&day.;
keep  effect estimate StdErr probt;
run;



data G0&cond.&meas.&day.;
length  Effect1 $30.;
set G0&cond.&meas.&day.;
 
length EstimateGroup0 $30.  ;
if Probt<0.01 then do;EstimateGroup0=Estimate||'***';Effect1=Effect||"(Beta Coeffient)";output;end;
else if Probt<0.05 then do;EstimateGroup0=Estimate||'**';Effect1=Effect||"(Beta Coeffient)";output;end;
else if Probt<0.1 then do;EstimateGroup0=Estimate||'*';Effect1=Effect||"(Beta Coeffient)";output;end;
else do;EstimateGroup0=Estimate||'';Effect1=Effect||"(Beta Coeffient)";output;end;
EstimateGroup0='('||StdErr||')';Effect1=Effect||"(Std Err)";output;
keep Effect1 EstimateGroup0  ;
proc sort ;by Effect1;
run;


data G1&cond.&meas.&day.;
length   Effect1 $50.;
set G1&cond.&meas.&day.;
 
length EstimateGroup1 $30.  ;
if Probt<0.01 then do;EstimateGroup1=Estimate||'***';Effect1=Effect||"(Beta Coeffient)";output;end;
else if Probt<0.05 then do;EstimateGroup1=Estimate||'**';Effect1=Effect||"(Beta Coeffient)";output;end;
else if Probt<0.1 then do;EstimateGroup1=Estimate||'*';Effect1=Effect||"(Beta Coeffient)";output;end;
else do;EstimateGroup1=Estimate||'';Effect1=Effect||"(Beta Coeffient)";output;end;
EstimateGroup1='('||StdErr||')';Effect1=Effect||"(Std Err)";output;
keep Effect1 EstimateGroup1  ;
proc sort ;by Effect1;
run;

******Output Formated Tables;
data Out1&cond.&meas.&day.;
length title $50.;
merge G0&cond.&meas.&day. G1&cond.&meas.&day. ;
by Effect1;
title=&title.;
proc print;
run;

*****Project Regression lines by group;
data projectdata;set projectdata;year=2008+year;run;
proc means data=projectdata;
class year &group.;
var predicted;
output out=temp mean=mean;
run;

ods listing gpath="C:\data\Projects\Hartford";
proc sgplot data=temp;where year ne . and &group. ne .;
title &title. ;
%if &cond=PQI %then %do;
format mean 8.0 ;
%end;
%else   %do;
format mean percent7.2 ;
%end;
scatter X=year y=mean/markerattrs=(color=black symbol=STARFILLED); 
series X=year y=mean/group=&group. datalabel=mean ; 
xaxis label='Year' values=(2008 to 2013 by 1);
yaxis label=&title. ;
run;
%mend model3G2;
%model3G2(cond=15cond,meas=readm,day=30,group=HIEoutSystem, title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%model3G2(cond=15cond,meas=readm,day=90,group=HIEoutSystem, title="Risk-adjusted 15-Composite 90-day Readmission Rate");
%model3G2(cond=15cond,meas=mort,day=30,group=HIEoutSystem, title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%model3G2(cond=15cond,meas=mort,day=90,group=HIEoutSystem, title="Risk-adjusted 15-Composite 90-day Mortality Rate");
%model3G2(cond=PQI,meas=adm,day=1yr,group=HIEoutSystem,title="Preventive Quality Indicators per 1000 Discharges");



****?         For hospital function characteristics which change over time, add as main effect into model;

%macro Model3MainEffect(cond=,meas=,day=,group=,title=);
proc sql;
create table intercept as
select a.provider,  a.HIEoutSystem_2008,a.HIEoutSystem_2009,a.HIEoutSystem_2010,a.HIEoutSystem_2011,a.HIEoutSystem_2012,a.HIEoutSystem_2013,a.PerfMeas_2013 ,
a.adj&cond.&meas.&day.2008 , a.adj&cond.&meas.&day.2009 , a.adj&cond.&meas.&day.2010, a.adj&cond.&meas.&day.2011,a.adj&cond.&meas.&day.2012, a.adj&cond.&meas.&day.2013, 
b.Estimate as startpoint
from data a left join data.model1 b
on a.provider=b.provider
where a.Nrespond>=3 and b.parameter="Intercept";
quit;

proc sql;
create table slope as
select a.*,
b.Estimate as slope,b.StdErr as slopeStdErr
from intercept a left join data.model1 b
on a.provider=b.provider
where b.parameter="year";
quit;
 
data ldata;
set slope;
if slopeStdErr=0 or slopeStdErr=. then wt=1/0.04;else wt=1/slopeStdErr;
HIEoutSystem=HIEoutSystem_2008;adj&cond.&meas.&day.=adj&cond.&meas.&day.2008;year=0;output;
HIEoutSystem=HIEoutSystem_2009;adj&cond.&meas.&day.=adj&cond.&meas.&day.2009;year=1;output;
HIEoutSystem=HIEoutSystem_2010;adj&cond.&meas.&day.=adj&cond.&meas.&day.2010;year=2;output;
HIEoutSystem=HIEoutSystem_2011;adj&cond.&meas.&day.=adj&cond.&meas.&day.2011;year=3;output;
HIEoutSystem=HIEoutSystem_2012;adj&cond.&meas.&day.=adj&cond.&meas.&day.2012;year=4;output;
HIEoutSystem=HIEoutSystem_2013;adj&cond.&meas.&day.=adj&cond.&meas.&day.2013;year=5;output;
proc means;var adj&cond.&meas.&day.;
output out=outcome&cond.&meas.&day. mean=mean  min=min q1=q1  median=median  q3=q3  max=max  ;
run;


proc sort data=ldata;by descending &group ;run;
 
proc glimmix data=ldata NOCLPRINT order=data;
title &title. ;
class provider &group. ;
weight wt;
model adj&cond.&meas.&day.=startpoint year startpoint*year slope*year
                           &group.  /s dist=normal  ;
random int  / subject=provider ;

ods output  ParameterEstimates=est&cond.&meas.&day.  ;
run;
  

%mend model3MainEffect;
%model3MainEffect(cond=15cond,meas=readm,day=30,group=HIEoutSystem, title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%model3MainEffect(cond=15cond,meas=readm,day=90,group=HIEoutSystem, title="Risk-adjusted 15-Composite 90-day Readmission Rate");
%model3MainEffect(cond=15cond,meas=mort,day=30,group=HIEoutSystem, title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%model3MainEffect(cond=15cond,meas=mort,day=90,group=HIEoutSystem, title="Risk-adjusted 15-Composite 90-day Mortality Rate");
%model3MainEffect(cond=PQI,meas=adm,day=1yr,group=HIEoutSystem,title="Preventive Quality Indicators per 1000 Discharges");


%model3MainEffect(cond=15cond,meas=readm,day=30,group=PerfMeas_2013, title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%model3MainEffect(cond=15cond,meas=readm,day=90,group=PerfMeas_2013, title="Risk-adjusted 15-Composite 90-day Readmission Rate");
%model3MainEffect(cond=15cond,meas=mort,day=30,group=PerfMeas_2013, title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%model3MainEffect(cond=15cond,meas=mort,day=90,group=PerfMeas_2013, title="Risk-adjusted 15-Composite 90-day Mortality Rate");
%model3MainEffect(cond=PQI,meas=adm,day=1yr,group=PerfMeas_2013,title="Preventive Quality Indicators per 1000 Discharges");



*****************************************************************************************************************
?Run hospital-specific regression, using readmission/mortality/PQI as outcomes, 
get intercept and slope, look at correlation among outcomes to see if they are consistent to represent performance

Julia:Can you look at both relationship between intercept and slope within measures, 
and relationship between intercepts and between slopes across measures?  
Then look at whether these relationships differ depending on which EHR adoption group the hospitals 
are in (i.e., start at 0-2 functions, start at 3-6 functions, start at 6-8 functions, start at 9-10 functions)?
*****************************************************************************************************************;
%macro Model3(cond= ,meas= ,day= );
data model3;
set data;
where Nrespond>=3;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2008;year=0;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2009;year=1;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2010;year=2;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2011;year=3;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2012;year=4;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2013;year=5;output;
keep provider adj&cond.&meas.&day. year   ;
run;

data providerlist;set data; where Nrespond>=3;keep provider;run;
 
 
%do i=1 %to 3296;
data temp;set providerlist;if _n_=&i. then call symput("provider",provider);run;
proc glm data=model3;
where provider=symget('provider');
model adj&cond.&meas.&day.= Year /solution;
ods output parameterEstimates=provider&i.;
run;

data provider&i.;set provider&i.;provider=symget('provider');N=&i.;run;
%end;
 
 
data temp&cond.&meas.&day.;set provider1;run;
%do i=2 %to 3296;
data temp&cond.&meas.&day.;set temp&cond.&meas.&day.  provider&i.;run;
%end;
data data.Model1&cond.&meas.&day.;set temp&cond.&meas.&day.;proc print;run;
 

*How do the slope and intercept look like in general?;

proc means data=data.Model1&cond.&meas.&day. mean min Q1 median Q3 max ;
where parameter="Intercept";
var Estimate;
run;
proc means data=data.Model1&cond.&meas.&day.  mean min Q1 median Q3 max ;
where parameter="year";
var Estimate;
run;
proc means data=data.Model1&cond.&meas.&day.  mean min Q1 median Q3 max ;
where parameter="year";
var Stderr;
run;
%mend Model3;
%Model3(cond=15cond,meas=readm,day=30);
%Model3(cond=15cond,meas=readm,day=90);
%Model3(cond=15cond,meas=mort,day=30);
%Model3(cond=15cond,meas=mort,day=90);
%Model3(cond=PQI,meas=adm,day=1yr);

%Model3(cond=AMI,meas=readm,day=30);
%Model3(cond=CHF,meas=readm,day=30);
%Model3(cond=PN,meas=readm,day=30);
%Model3(cond=COPD,meas=readm,day=30);
%Model3(cond=Stroke,meas=readm,day=30);
%Model3(cond=Sepsis,meas=readm,day=30);
%Model3(cond=Esggas,meas=readm,day=30);
%Model3(cond=Gib,meas=readm,day=30);
%Model3(cond=UTI,meas=readm,day=30);
%Model3(cond=Metdis,meas=readm,day=30);
%Model3(cond=Arrhy,meas=readm,day=30);
%Model3(cond=Chest,meas=readm,day=30);
%Model3(cond=Renalf,meas=readm,day=30);
%Model3(cond=Resp,meas=readm,day=30);
%Model3(cond=Hipfx,meas=readm,day=30);
%Model3(cond=3cond,meas=readm,day=30);
 
%Model3(cond=AMI,meas=readm,day=90);
%Model3(cond=CHF,meas=readm,day=90);
%Model3(cond=PN,meas=readm,day=90);
%Model3(cond=COPD,meas=readm,day=90);
%Model3(cond=Stroke,meas=readm,day=90);
%Model3(cond=Sepsis,meas=readm,day=90);
%Model3(cond=Esggas,meas=readm,day=90);
%Model3(cond=Gib,meas=readm,day=90);
%Model3(cond=UTI,meas=readm,day=90);
%Model3(cond=Metdis,meas=readm,day=90);
%Model3(cond=Arrhy,meas=readm,day=90);
%Model3(cond=Chest,meas=readm,day=90);
%Model3(cond=Renalf,meas=readm,day=90);
%Model3(cond=Resp,meas=readm,day=90);
%Model3(cond=Hipfx,meas=readm,day=90);
%Model3(cond=3cond,meas=readm,day=90);

%Model3(cond=AMI,meas=mort,day=30);
%Model3(cond=CHF,meas=mort,day=30);
%Model3(cond=PN,meas=mort,day=30);
%Model3(cond=COPD,meas=mort,day=30);
%Model3(cond=Stroke,meas=mort,day=30);
%Model3(cond=Sepsis,meas=mort,day=30);
%Model3(cond=Esggas,meas=mort,day=30);
%Model3(cond=Gib,meas=mort,day=30);
%Model3(cond=UTI,meas=mort,day=30);
%Model3(cond=Metdis,meas=mort,day=30);
%Model3(cond=Arrhy,meas=mort,day=30);
%Model3(cond=Chest,meas=mort,day=30);
%Model3(cond=Renalf,meas=mort,day=30);
%Model3(cond=Resp,meas=mort,day=30);
%Model3(cond=Hipfx,meas=mort,day=30);
%Model3(cond=3cond,meas=mort,day=30);
 
%Model3(cond=AMI,meas=mort,day=90);
%Model3(cond=CHF,meas=mort,day=90);
%Model3(cond=PN,meas=mort,day=90);
%Model3(cond=COPD,meas=mort,day=90);
%Model3(cond=Stroke,meas=mort,day=90);
%Model3(cond=Sepsis,meas=mort,day=90);
%Model3(cond=Esggas,meas=mort,day=90);
%Model3(cond=Gib,meas=mort,day=90);
%Model3(cond=UTI,meas=mort,day=90);
%Model3(cond=Metdis,meas=mort,day=90);
%Model3(cond=Arrhy,meas=mort,day=90);
%Model3(cond=Chest,meas=mort,day=90);
%Model3(cond=Renalf,meas=mort,day=90);
%Model3(cond=Resp,meas=mort,day=90);
%Model3(cond=Hipfx,meas=mort,day=90);
%Model3(cond=3cond,meas=mort,day=90);

proc sort data=data.Model115condreadm30 out=Model115condreadm30 ;by provider parameter;run;
data Model115condreadm30;set Model115condreadm30;rename  Estimate=Est1; run;
proc sort data=data.Model115condreadm90 out=Model115condreadm90;by provider parameter;run;
data Model115condreadm90;set Model115condreadm90;rename  Estimate=Est2; run;
proc sort data=data.Model115condmort30 out=Model115condmort30;by provider parameter;run;
data Model115condmort30;set Model115condmort30;rename  Estimate=Est3; run;
proc sort data=data.Model115condmort90 out=Model115condmort90;by provider parameter;run;
data Model115condmort90;set Model115condmort90;rename  Estimate=Est4; run;
proc sort data=data.Model1PQIadm1yr out=Model1PQIadm1yr;by provider parameter;run;
data Model1PQIadm1yr;set Model1PQIadm1yr;rename  Estimate=Est5; run;
data temp;
merge  Model115condreadm30  Model115condreadm90  Model115condmort30  Model115condmort90  Model1PQIadm1yr;
by provider parameter;
keep provider parameter est1 est2 est3 est4 est5;
run;
data Int slope;
set temp;
if parameter="Intercept" then output int;
if parameter="year" then output slope;
run;

proc sql;
create table temp2 as
select a.provider,a.Est1 as readm30Int,a.Est2 as readm90Int,a.Est3 as mort30Int,a.Est4 as mort90Int,a.Est5 as PQIInt,
b.Est1 as readm30Slope,b.Est2 as readm90Slope,b.Est3 as mort30Slope,b.Est4 as mort90Slope,b.Est5 as PQISlope
from Int a left join slope b
on a.provider=b.provider;
quit;

data Int1 slope1;
set data.model1;
if parameter="Intercept" then output int1;
if parameter="year" then output slope1;
run;
proc sql;
create table temp3 as 
select a.provider,a.Estimate as StartEHR,b.Estimate as ChangeEHR
from int1 a left join slope1 b
on a.provider=b.provider;
quit;

proc sql;
create table relation as 
select a.*,b.*
from temp2 a left join temp3 b
on a.provider=b.provider;
quit;

 

 
proc corr data=relation noprob nosimple;
   var readm30Int readm30Slope  ;
 run;
 ods graphics on;
 proc reg data=relation;model readm30Slope =readm30Int;run;

 proc corr data=relation noprob nosimple;
   var readm90Int readm90Slope;
 run;
  proc reg data=relation;model readm90Slope =readm90Int;run;

  proc corr data=relation noprob nosimple;
   var mort30Int mort30Slope;
 run;
  proc reg data=relation;model mort30Slope =mort30Int;run;

  proc corr data=relation noprob nosimple;
   var mort90Int mort90Slope;
 run;
  proc reg data=relation;model mort90Slope =mort90Int;run;


 
  proc corr data=relation noprob nosimple;
   var PQIint PQISlope;
 run;
  proc reg data=relation;model PQISlope =PQIInt;run;


proc corr data=relation;
var readm30int readm90int mort30int mort90int PQIint readm30slope readm90slope mort30slope mort90slope PQIslope;
run;
 

proc univariate data=relation;
var startEHR changeEHR;
run;
data relation;
set relation;
if startEHR<=2 then group=1;
else if startEHR<=6 then group=2;
else if startEHR<=8 then group=3;
else group=4;
proc means min mean max;class group;var startEHR;
run;

 %let g=4;
proc corr data=relation noprob nosimple; 
where group=&g.;
   var readm30Int readm30Slope  ;
 run;
 ods graphics on;
 proc reg data=relation;where group=&g.;model readm30Slope =readm30Int;run;

 proc corr data=relation noprob nosimple;
 where group=&g.;
   var readm90Int readm90Slope;
 run;
  proc reg data=relation;where group=&g.;model readm90Slope =readm90Int;run;

  proc corr data=relation noprob nosimple;
   where group=&g.;var mort30Int mort30Slope;
 run;
  proc reg data=relation;where group=&g.;model mort30Slope =mort30Int;run;

  proc corr data=relation noprob nosimple;
  where group=&g.; var mort90Int mort90Slope;
 run;
  proc reg data=relation;where group=&g.;model mort90Slope =mort90Int;run;

  proc corr data=relation noprob nosimple;
  where group=&g.; var PQIint PQISlope;
 run;
  proc reg data=relation;where group=&g.;model PQISlope =PQIInt;run;


proc corr data=relation;where group=&g.;
var readm30int readm90int mort30int mort90int PQIint readm30slope readm90slope mort30slope mort90slope PQIslope;
run;


******************************************
Z score for case study
*****************************************;
proc sort data=data.Model1 out=Model1   ;by provider parameter;run;
data Model1 ;set Model1 ;rename  Estimate=EstBasicEHR; proc sort;by provider parameter;run;
%macro loop(cond=,meas=,day=);
proc sort data=data.Model1&cond.&meas.&day.  out=Model1&cond.&meas.&day.  ;by provider parameter;run;
data Model1&cond.&meas.&day. ;set Model1&cond.&meas.&day. ;rename  Estimate=Est&cond.&meas.&day. ; proc sort;by provider parameter;run;
%mend loop;
%loop(cond=15cond,meas=readm,day=30);
%loop(cond=15cond,meas=Mort,day=30);
%loop(cond=15cond,meas=readm,day=90);
%loop(cond=15cond,meas=Mort,day=90);
%loop(cond=PQI,meas=adm,day=1yr);

data temp;
merge Model1 Model115condreadm30 Model115condreadm90     
        Model115condMort30 Model115condMort90 Model1PQIadm1yr;
by provider parameter;
keep provider parameter EstBasicEHR Est15condreadm30  Est15condMort30  Est15condreadm90  Est15condMort90  EstPQIadm1yr;
;
run;
data Int slope;
set temp;
if parameter="Intercept" then output int;
if parameter="year" then output slope;
run;

proc sql;
create table temp1 as
select a.provider,a.EstBasicEHR as IntBasicEHR, a.Est15condreadm30 as Int15condreadm30, a.Est15condMort30 as Int15condMort30,
                  a.Est15condreadm90 as Int15condreadm90, a.Est15condMort90 as Int15condMort90, 
                  a.EstPQIadm1yr as IntPQIadm1yr,
                  b.EstBasicEHR as SlopeBasicEHR, b.Est15condreadm30 as Slope15condreadm30, b.Est15condMort30 as Slope15condMort30,
                  b.Est15condreadm90 as Slope15condreadm90, b.Est15condMort90 as Slope15condMort90, 
                  b.EstPQIadm1yr as SlopePQIadm1yr
from Int a left join slope b
on a.provider=b.provider;
quit;
 

proc sql;
create table Zdata as
select a.*,b.*
from data a left join temp1 b
on a.provider=b.provider
where 	a.Nrespond>=3;
quit;




%macro std(var=);
proc means data=Zdata min mean std max;
var &var.  ;
output out=&var.   mean=mean std=std; 
run;
data _null_;
set &var.;
call symput("mean",mean);
call symput("std",std);
run;
data Zdata;
set Zdata;
mean =symget('mean')*1;std =symget('std')*1;
score&var.=(&var.-mean)/std;
proc means min max mean std;var score&var.;
run;
%mend std;
%std(var=Int15condMort30);
%std(var=Int15condReadm30);
%std(var=Int15condMort90);
%std(var=Int15condReadm90);
%std(var=IntPQIadm1yr);

%std(var=Slope15condMort30);
%std(var=Slope15condReadm30);
%std(var=Slope15condMort90);
%std(var=Slope15condReadm90);
%std(var=SlopePQIadm1yr);
 
data Zdata ;
set Zdata;
IntZscore=mean(scoreInt15condMort30,scoreInt15condReadm30,scoreInt15condMort90,scoreInt15condReadm90,scoreIntPQIadm1yr);
SlopeZscore=mean(scoreSlope15condMort30,scoreSlope15condReadm30,scoreSlope15condMort90,scoreSlope15condReadm90,scoreSlopePQIadm1yr);
proc means min max mean std;
var IntZscore SlopeZscore;
run;


data data.CaseStudy;
set Zdata;
keep type provider Mname Mstate HRR HRRname HSACode--Rural hosp_reg4 Nrespond IntBasicEHR SlopeBasicEHR 
Int15condMort30 Int15condReadm30 Int15condMort90 Int15condReadm90 IntPQIadm1yr
Slope15condMort30 Slope15condReadm30 Slope15condMort90 Slope15condReadm90 SlopePQIadm1yr IntZscore SlopeZscore;
run;
proc print data=data.CaseStudy;var provider Mname type Mstate HRR HRRname  HSACode--Rural Nrespond IntBasicEHR SlopeBasicEHR 
Int15condMort30 Slope15condMort30 
Int15condMort90 Slope15condMort90
Int15condReadm30 Slope15condReadm30 
Int15condReadm90 Slope15condReadm90
IntPQIadm1yr SlopePQIadm1yr
IntZscore SlopeZscore;
run;

proc sql;
create table temp as
select a.provider,b.NBasicEHR2008,b.NBasicEHR2009,b.NBasicEHR2010,b.NBasicEHR2011,b.NBasicEHR2012,b.NBasicEHR2013
from data.casestudy a left join data.hartford b
 on a.provider=b.provider;
 quit;
 libname AHA 'C:\data\Data\Hospital\AHA\Annual_Survey\Data';
 proc sql;
create table temp1 as
select a.*,
b.MNAME as Hospital_Name,b.MADMIN as Administrator, b.MLOCADDR as Address,b.MLOCCITY as City,b.MLOCZIP as ZIP,b.MSTATE as State
from temp a left join AHA.AHA13 b
 on a.provider=b.provider;
 quit;
 proc print data=temp1;run;



/***********************************
Case Study
************************************;
proc sql;
create table intercept as
select a.provider, a.Mname, a.Mstate,
b.Estimate as startpoint
from data a left join data.model1 b
on a.provider=b.provider
where a.Nrespond>=3 and b.parameter="Intercept";
quit;

proc sql;
create table slope as
select a.*,b.Estimate as slope 
from intercept a left join data.model1 b
on a.provider=b.provider
where b.parameter="year";
quit;
proc print data=slope;run;

proc sgplot data=slope;title "Selecting Hospital for Case Study";
scatter x=startpoint y=slope;
xaxis label="Starting No. EHR Functionalities";
yaxis label="Avg Change in No. of EHR Functionalities per Year" ;
run;

*/
