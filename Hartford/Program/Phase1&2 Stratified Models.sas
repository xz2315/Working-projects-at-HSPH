*****************************************************
Hartford Grant Phase 3 Stratified Analyses
Xiner Zhou
3/17/2016
****************************************************;
libname data 'C:\data\Projects\Hartford\Data';
libname cr 'C:\data\Data\Hospital\Cost Reports';

/*
1.	Add control for financial health for existing models (Size and urban/rural status)
2.	Add stratified analysis for teaching/non teaching
3.	Add stratified analysis for safety net/not safety net
4.	Add stratified analysis for level of adoption in year 


WeÅfd like one that stratifies hospitals with < 4 starting basic functionalities into:
 
1. 0 starting functionalities (n=1877)
2. starting functionalities in documentation and results only (a1_2008 b1_2008 c1_2008 d1_2008 e1_2008 f1_2008 a2_2008 b2_2008 d2_2008)- should be n=177
3. starting functionalities in documentation only (a1_2008 b1_2008 c1_2008 d1_2008 e1_2008 f1_2008)- should be n=124
4. starting functionalities in results only (a2_2008 b2_2008 d2_2008)- should be n=107


For this particular analysis, you can drop them. Julia wants to use this as a robustness test to support whatever findings we get from the stratified analyses with early, mid, and late adopters (#5 in this list). YouÅfll also end up throwing out ~19 hospitals that have CPOE functions
1. Size
2. Urban/Rural
3. Teaching/Non-Teaching
4. Safety Net/ Non Safety Net
5. Early/Mid/Late Adopters (< 4, 4-7, >8 Functionalities at Baseline)
5b. Stratified-Stratified Analysis: Of hospitals with < 4 Baseline functionalities, compare adopters of none, documentation and results viewing, documentation only, results only 
*/

* Add Operating Margin;
%macro Margin(yr=);
data margin&yr.;
set cr.Cost_reports_&yr. ;
keep totmargin&yr. opmargin&yr.  provider ; 
totmargin&yr. =  net_income/sum(net_pat_rev,tot_oth_inc); 
opmargin&yr.  =  (sum(net_pat_rev,tot_oth_inc)-tot_op_exps)/sum(net_pat_rev,tot_oth_inc); 
provider=prvdr_num ;
proc sort ;by provider;
run;
%mend Margin;
%Margin(yr=2008);
%Margin(yr=2009);
%Margin(yr=2010);
%Margin(yr=2011);
%Margin(yr=2012);
%Margin(yr=2013);

proc sort data=data.Hartford;by provider;run;
data Hartford;
merge data.Hartford(in=in1) margin2008 margin2009 margin2010 margin2011 margin2012 margin2013;
by provider;
if in1=1;
run;


**************************************************************
Count Response Years  
*************************************************************;
data hartford;
set hartford;
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
 


****************************************************************************
Overall Model:
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
select a.*, 
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
adj&cond.&meas.&day.=adj&cond.&meas.&day.2008;opmargin=opmargin2008;year=0;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2009;opmargin=opmargin2009;year=1;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2010;opmargin=opmargin2010;year=2;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2011;opmargin=opmargin2011;year=3;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2012;opmargin=opmargin2012;year=4;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2013;opmargin=opmargin2013;year=5;output;
proc means;var adj&cond.&meas.&day.;
output out=outcome&cond.&meas.&day. mean=mean  min=min q1=q1  median=median  q3=q3  max=max  ;
run;
proc glimmix data=ldata NOCLPRINT;
title "&title.";
class provider;
weight wt;
model adj&cond.&meas.&day.=startpoint opmargin year startpoint*year slope*year  /s dist=normal  ;
random int  / subject=provider ;
ods output ParameterEstimates=est&cond.&meas.&day. ;
store sasuser.beta&cond.&meas.&day. ;
run;

* projected ;
proc plm source=sasuser.beta&cond.&meas.&day.;
   score data=newdata out=prednewdata&cond.&meas.&day. predicted  ;
run;
proc print data=prednewdata&cond.&meas.&day.;
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
	Estimate1=StdErr;output;
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
%model2(cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");

%model2(cond=15cond,meas=readm,day=90,title="Risk-adjusted 15-Composite 90-day Readmission Rate");

%model2(cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
 
%model2(cond=15cond,meas=mort,day=90,title="Risk-adjusted 15-Composite 90-day Mortality Rate");
 
%model2(cond=PQI,meas=adm,day=1yr,title="Preventive Quality Indicators per 1000 Discharges");
 



/*  Stratified Analyses: 
1. Size
2. Urban/Rural
3. Teaching/Non-Teaching
4. Safety Net/ Non Safety Net
5. Early/Mid/Late Adopters (< 4, 4-7, >8 Functionalities at Baseline)
5b.Stratified-Stratified Analysis: Of hospitals with < 4 Baseline functionalities, compare adopters of none, 
   documentation and results viewing, documentation only, results only 
*/
 
data data;
set data;
if Nrespond>=3;
*Urban;
if CBSATYPE in ('Micro','Rural') then Urban=0;else if CBSATYPE in ('Metro') then Urban=1;
*teaching;
if teaching in (1,2) then teaching1=1;else if teaching=3 then teaching1=0;else if teaching=. then teaching1=.;
*SNH;
if SNH2008=4 then SNH2008_1=1;else if SNH2008 ne . then SNH2008_1=0;else if SNH2008=. then SNH2008_1=.;
if SNH2009=4 then SNH2009_1=1;else if SNH2009 ne . then SNH2009_1=0;else if SNH2009=. then SNH2009_1=.;
if SNH2010=4 then SNH2010_1=1;else if SNH2010 ne . then SNH2010_1=0;else if SNH2010=. then SNH2010_1=.;
if SNH2011=4 then SNH2011_1=1;else if SNH2011 ne . then SNH2011_1=0;else if SNH2011=. then SNH2011_1=.;
if SNH2012=4 then SNH2012_1=1;else if SNH2012 ne . then SNH2012_1=0;else if SNH2012=. then SNH2012_1=.;
if SNH2013=4 then SNH2013_1=1;else if SNH2013 ne . then SNH2013_1=0;else if SNH2013=. then SNH2013_1=.;
*Early/Mid/Late Adopters (< 4, 4-7, >8 Functionalities at Baseline);
if NBasicEHR2008 in (0,1,2,3) then Adopter=1;
else if NBasicEHR2008 in (4,5,6,7) then Adopter=2;
else if NBasicEHR2008 >=8 then Adopter=3;

if Adopter=1 then do;
  if a1_2008 not in (1,2) and b1_2008 not in (1,2) and c1_2008 not in (1,2) and d1_2008 not in (1,2) and e1_2008 not in (1,2) and f1_2008 not in (1,2) 
     and a2_2008 not in (1,2) and b2_2008 not in (1,2) and d2_2008 not in (1,2) and c3_2008 not in (1,2) then subgroup=0;
  else if (a1_2008 in (1,2) or b1_2008 in (1,2) or c1_2008 in (1,2) or d1_2008 in (1,2) or e1_2008 in (1,2) or f1_2008 in (1,2)) 
     and (a2_2008 not in (1,2) and b2_2008 not in (1,2) and d2_2008 not in (1,2)) then subgroup=1;
  else if (a1_2008 not in (1,2) and b1_2008 not in (1,2) and c1_2008 not in (1,2) and d1_2008 not in (1,2) and e1_2008 not in (1,2) and f1_2008 not in (1,2)) 
     and (a2_2008 in (1,2) or b2_2008 in (1,2) or d2_2008 in (1,2) ) then subgroup=2;
  else if a1_2008 in (1,2) or  b1_2008 in (1,2) or c1_2008 in (1,2) or d1_2008 in (1,2) or e1_2008 in (1,2) or f1_2008 in (1,2) or
     a2_2008 in (1,2) or b2_2008 in (1,2) or d2_2008 in (1,2)  then subgroup=3;

end;

drop SNH2008 SNH2009 SNH2010 SNH2011 SNH2012 SNH2013;
rename SNH2008_1=SNH2008 SNH2009_1=SNH2009 SNH2010_1=SNH2010 SNH2011_1=SNH2011 SNH2012_1=SNH2012 SNH2013_1=SNH2013 ;
run;
proc freq data=data; 
title "SubGroup Frequency";tables  
hospsize Urban SNH2008 SNH2009 SNH2010 SNH2011 SNH2009 SNH2009 Adopter subgroup/missing;
run;
 
 
data newdata1;set newdata;hospsize=1;Adopter=1;run;
data newdata2;set newdata;hospsize=2;Adopter=2;run;
data newdata3;set newdata;hospsize=3;Adopter=3;run;



%macro Model3G3(cond=,meas=,day=,group=,title=);
proc sql;
create table intercept as
select a.*,
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
adj&cond.&meas.&day.=adj&cond.&meas.&day.2008;year=0;opmargin=opmargin2008;SNH=SNH2008;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2009;year=1;opmargin=opmargin2009;SNH=SNH2009;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2010;year=2;opmargin=opmargin2010;SNH=SNH2010;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2011;year=3;opmargin=opmargin2011;SNH=SNH2011;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2012;year=4;opmargin=opmargin2012;SNH=SNH2012;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2013;year=5;opmargin=opmargin2013;SNH=SNH2013;output;
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
model adj&cond.&meas.&day.=startpoint opmargin year startpoint*year slope*year
                           &group. &group.*startpoint &group.*year &group.*startpoint*year &group.*slope*year/s dist=normal  ;
random int  / subject=provider ;

store sasuser.beta&cond.&meas.&day. ;
 

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
  
proc plm source=sasuser.beta&cond.&meas.&day. ;
   score data=preddata out=projectdata predicted ;
run;

proc plm source=sasuser.beta&cond.&meas.&day. ;
   score data=newdata1 out=prednewdata1 predicted ;
run;
proc plm source=sasuser.beta&cond.&meas.&day. ;
   score data=newdata2 out=prednewdata2 predicted ;
run;
proc plm source=sasuser.beta&cond.&meas.&day. ;
   score data=newdata3 out=prednewdata3 predicted ;
run;
proc print data=prednewdata1 ;run;
proc print data=prednewdata2 ;run;
proc print data=prednewdata3 ;run;

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
EstimateGroup1=StdErr;Effect1=Effect||"(Std Err)";output;
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
EstimateGroup2=StdErr;Effect1=Effect||"(Std Err)";output;
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
EstimateGroup3=StdErr;Effect1=Effect||"(Std Err)";output;
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

%model3G3(cond=15cond,meas=readm,day=30,group=Adopter, title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%model3G3(cond=15cond,meas=readm,day=90,group=Adopter, title="Risk-adjusted 15-Composite 90-day Readmission Rate");
%model3G3(cond=15cond,meas=mort,day=30,group=Adopter, title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%model3G3(cond=15cond,meas=mort,day=90,group=Adopter, title="Risk-adjusted 15-Composite 90-day Mortality Rate");
%model3G3(cond=PQI,meas=adm,day=1yr,group=Adopter,title="Preventive Quality Indicators per 1000 Discharges");


data newdata0;set newdata;Urban=0;teaching1=0;SNH=0;run;
data newdata1;set newdata;Urban=1;teaching1=1;SNH=1;run;

%macro Model3G2(cond=,meas=,day=,group=,title=);
proc sql;
create table intercept as
select a.*,
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
adj&cond.&meas.&day.=adj&cond.&meas.&day.2008;year=0;opmargin=opmargin2008;SNH=SNH2008;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2009;year=1;opmargin=opmargin2009;SNH=SNH2009;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2010;year=2;opmargin=opmargin2010;SNH=SNH2010;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2011;year=3;opmargin=opmargin2011;SNH=SNH2011;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2012;year=4;opmargin=opmargin2012;SNH=SNH2012;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2013;year=5;opmargin=opmargin2013;SNH=SNH2013;output;
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
model adj&cond.&meas.&day.=startpoint opmargin year startpoint*year slope*year
                           &group. &group.*startpoint &group.*year &group.*startpoint*year &group.*slope*year/s dist=normal  ;
random int  / subject=provider ;
 

store sasuser.beta&cond.&meas.&day. ;
 
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


proc plm source=sasuser.beta&cond.&meas.&day. ;
   score data=preddata out=projectdata predicted ;
run;

proc plm source=sasuser.beta&cond.&meas.&day. ;
   score data=newdata0 out=prednewdata0 predicted ;
run;
proc plm source=sasuser.beta&cond.&meas.&day. ;
   score data=newdata1 out=prednewdata1 predicted ;
run;
 
proc print data=prednewdata0 ;run;
proc print data=prednewdata1 ;run;
 


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
EstimateGroup0=StdErr;Effect1=Effect||"(Std Err)";output;
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
EstimateGroup1=StdErr;Effect1=Effect||"(Std Err)";output;
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

%model3G2(cond=15cond,meas=readm,day=30,group=teaching1, title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%model3G2(cond=15cond,meas=readm,day=90,group=teaching1, title="Risk-adjusted 15-Composite 90-day Readmission Rate");
%model3G2(cond=15cond,meas=mort,day=30,group=teaching1, title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%model3G2(cond=15cond,meas=mort,day=90,group=teaching1, title="Risk-adjusted 15-Composite 90-day Mortality Rate");
%model3G2(cond=PQI,meas=adm,day=1yr,group=teaching1,title="Preventive Quality Indicators per 1000 Discharges");
 
%model3G2(cond=15cond,meas=readm,day=30,group=SNH, title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%model3G2(cond=15cond,meas=readm,day=90,group=SNH, title="Risk-adjusted 15-Composite 90-day Readmission Rate");
%model3G2(cond=15cond,meas=mort,day=30,group=SNH, title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%model3G2(cond=15cond,meas=mort,day=90,group=SNH, title="Risk-adjusted 15-Composite 90-day Mortality Rate");
%model3G2(cond=PQI,meas=adm,day=1yr,group=SNH,title="Preventive Quality Indicators per 1000 Discharges");


data newdata0;set newdata;subgroup=0;run;
data newdata1;set newdata;subgroup=1;run;
data newdata2;set newdata;subgroup=2;run;
data newdata3;set newdata;subgroup=3;run;


%macro Model3G4(cond=,meas=,day=,group=,title=);
proc sql;
create table intercept as
select a.*,
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
	if &group.=0 then call symput("startpoint&group.0",mean);
    else if &group.=1 then call symput("startpoint&group.1",mean);
	else if &group.=2 then call symput("startpoint&group.2",mean);
	else if &group.=3 then call symput("startpoint&group.3",mean);
run;


proc print data=&group.slope;title "slope";run;
proc print data=&group.startpoint;title "startpoint";run;

data ldata;
set slope;
 
if slopeStdErr=0 or slopeStdErr=. then wt=1/0.04;else wt=1/slopeStdErr;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2008;year=0;opmargin=opmargin2008;SNH=SNH2008;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2009;year=1;opmargin=opmargin2009;SNH=SNH2009;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2010;year=2;opmargin=opmargin2010;SNH=SNH2010;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2011;year=3;opmargin=opmargin2011;SNH=SNH2011;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2012;year=4;opmargin=opmargin2012;SNH=SNH2012;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2013;year=5;opmargin=opmargin2013;SNH=SNH2013;output;
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
model adj&cond.&meas.&day.=startpoint opmargin year startpoint*year slope*year
                           &group. &group.*startpoint &group.*year &group.*startpoint*year &group.*slope*year/s dist=normal  ;
random int  / subject=provider ;

store sasuser.beta&cond.&meas.&day. ;
 
Estimate "Intercept &group.=0" intercept 1 &group. 0 0 0 1;
Estimate "startpoint &group.=0" startpoint 1 &group.*startpoint 0 0 0 1;
Estimate "year &group.=0" year 1 &group.*year 0 0 0 1;
Estimate "&group.*startpoint*year &group.=0" startpoint*year 1 &group.*startpoint*year 0 0 0 1;
Estimate "&group.*slope*year &group.=0" slope*year 1 &group.*slope*year 0 0 0 1;

Estimate "Intercept &group.=1" intercept 1 &group. 0 0 1 0;
Estimate "startpoint &group.=1" startpoint 1 &group.*startpoint 0 0 1 0;
Estimate "year &group.=1" year 1 &group.*year 0 0 1 0;
Estimate "&group.*startpoint*year &group.=1" startpoint*year 1 &group.*startpoint*year 0 0 1 0;
Estimate "&group.*slope*year &group.=1" slope*year 1 &group.*slope*year 0 0 1 0;

Estimate "Intercept &group.=2" intercept 1 &group. 0 1 0 0;
Estimate "startpoint &group.=2" startpoint 1 &group.*startpoint 0 1 0 0;
Estimate "year &group.=2" year 1 &group.*year 0 1 0 0;
Estimate "&group.*startpoint*year &group.=2" startpoint*year 1 &group.*startpoint*year 0 1 0 0;
Estimate "&group.*slope*year &group.=2" slope*year 1 &group.*slope*year 0 1 0 0;

Estimate "Intercept &group.=3" intercept 1 &group. 1 0 0 0;
Estimate "startpoint &group.=3" startpoint 1 &group.*startpoint 1 0 0 0;
Estimate "year &group.=3" year 1 &group.*year 1 0 0 0;
Estimate "&group.*startpoint*year &group.=3" startpoint*year 1 &group.*startpoint*year 1 0 0 0;
Estimate "&group.*slope*year &group.=3" slope*year 1 &group.*slope*year 1 0 0 0;

ods output  Estimates=est1&cond.&meas.&day.   ParameterEstimates=est&cond.&meas.&day.  ;
run;
  
proc plm source=sasuser.beta ;
   score data=preddata out=projectdata predicted ;
run;


proc plm source=sasuser.beta&cond.&meas.&day. ;
   score data=newdata0 out=prednewdata0 predicted ;
run;
proc plm source=sasuser.beta&cond.&meas.&day. ;
   score data=newdata1 out=prednewdata1 predicted ;
run;
proc plm source=sasuser.beta&cond.&meas.&day. ;
   score data=newdata2 out=prednewdata2 predicted ;
run;
proc plm source=sasuser.beta&cond.&meas.&day. ;
   score data=newdata3 out=prednewdata3 predicted ;
run;

proc print data=prednewdata0 ;run;
proc print data=prednewdata1 ;run;
proc print data=prednewdata2 ;run;
proc print data=prednewdata3 ;run;



data G0&cond.&meas.&day. G1&cond.&meas.&day. G2&cond.&meas.&day. G3&cond.&meas.&day.;
set est1&cond.&meas.&day.;
Group=scan(label,2,'=');
Effect=scan(label,1,'');
if Group=0 then output G0&cond.&meas.&day.;
else if Group=1 then output G1&cond.&meas.&day.;
else if Group=2 then output G2&cond.&meas.&day.;
else if Group=3 then output G3&cond.&meas.&day.;
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
EstimateGroup0=StdErr;Effect1=Effect||"(Std Err)";output;
keep Effect1 EstimateGroup0  ;
proc sort ;by Effect1;
run;

data G1&cond.&meas.&day.;
length  Effect1 $30.;
set G1&cond.&meas.&day.;
length EstimateGroup1 $30.  ;
if Probt<0.01 then do;EstimateGroup1=Estimate||'***';Effect1=Effect||"(Beta Coeffient)";output;end;
else if Probt<0.05 then do;EstimateGroup1=Estimate||'**';Effect1=Effect||"(Beta Coeffient)";output;end;
else if Probt<0.1 then do;EstimateGroup1=Estimate||'*';Effect1=Effect||"(Beta Coeffient)";output;end;
else do;EstimateGroup1=Estimate||'';Effect1=Effect||"(Beta Coeffient)";output;end;
EstimateGroup1=StdErr;Effect1=Effect||"(Std Err)";output;
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
EstimateGroup2=StdErr;Effect1=Effect||"(Std Err)";output;
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
EstimateGroup3=StdErr;Effect1=Effect||"(Std Err)";output;
keep Effect1 EstimateGroup3  ;
proc sort ;by Effect1;
run;
******Output Formated Tables;
data Out1&cond.&meas.&day.;
length title $50.;
merge G0&cond.&meas.&day. G1&cond.&meas.&day.  G2&cond.&meas.&day. G3&cond.&meas.&day.;
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



%mend model3G4;
%model3G4(cond=15cond,meas=readm,day=30,group=subgroup, title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%model3G4(cond=15cond,meas=readm,day=90,group=subgroup, title="Risk-adjusted 15-Composite 90-day Readmission Rate");
%model3G4(cond=15cond,meas=mort,day=30,group=subgroup, title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%model3G4(cond=15cond,meas=mort,day=90,group=subgroup, title="Risk-adjusted 15-Composite 90-day Mortality Rate");
%model3G4(cond=PQI,meas=adm,day=1yr,group=subgroup,title="Preventive Quality Indicators per 1000 Discharges");
