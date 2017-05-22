********************************
Mixed Effects Models
Xiner Zhou
5/6/2015
*******************************;

libname MAP 'C:\data\Projects\Medicare Utilization vs MA Rate';

proc format ;
value region_
0='Northeast'
1='Midwest'
2='South'
3='West'
;
run;

data ldata;
set map.data;
cost=cost2007;MAP=MAP2007;HCC=HCC2007; FFS=FFS2007;pop=pop2007;MHI=MHI2007;pov=pov2007; Physician=Physician2007;Physicianrank=Physician2007rank;PrimaryCare=PrimaryCare2007;Specialty=Specialty2007;
hospbd=hospbd2007;whitepct=whitepct2007;blackpct=blackpct2007;hisppct=hisppct2007;otherpct=otherpct2007;time=0; year=2007;output;

cost=cost2008;MAP=MAP2008;HCC=HCC2008; FFS=FFS2008;pop=pop2008;MHI=MHI2008;pov=pov2008; Physician=Physician2008;Physicianrank=Physician2008rank;PrimaryCare=PrimaryCare2008;Specialty=Specialty2008;
hospbd=hospbd2008;whitepct=whitepct2008;blackpct=blackpct2008;hisppct=hisppct2008;otherpct=otherpct2008;time=1; year=2008;output;

cost=cost2009;MAP=MAP2007;HCC=HCC2009; FFS=FFS2009;pop=pop2009;MHI=MHI2009;pov=pov2009; Physician=Physician2009;Physicianrank=Physician2009rank;PrimaryCare=PrimaryCare2009;Specialty=Specialty2009;
hospbd=hospbd2009;whitepct=whitepct2009;blackpct=blackpct2009;hisppct=hisppct2009;otherpct=otherpct2009;time=2; year=2009;output;

cost=cost2010;MAP=MAP2010;HCC=HCC2010; FFS=FFS2010;pop=pop2010;MHI=MHI2010;pov=pov2010; Physician=Physician2010;Physicianrank=Physician2010rank;PrimaryCare=PrimaryCare2010;Specialty=Specialty2010;
hospbd=hospbd2010;whitepct=whitepct2010;blackpct=blackpct2010;hisppct=hisppct2010;otherpct=otherpct2010;time=3; year=2010;output;

cost=cost2011;MAP=MAP2011;HCC=HCC2011; FFS=FFS2011;pop=pop2011;MHI=MHI2011;pov=pov2011; Physician=Physician2011;Physicianrank=Physician2011rank;PrimaryCare=PrimaryCare2011;Specialty=Specialty2011;
hospbd=hospbd2011;whitepct=whitepct2011;blackpct=blackpct2011;hisppct=hisppct2011;otherpct=otherpct2011;time=4; year=2011;output;

cost=cost2012;MAP=MAP2012;HCC=HCC2012; FFS=FFS2012;pop=pop2012;MHI=MHI2012;pov=pov2012; Physician=Physician2012;Physicianrank=Physician2012rank;PrimaryCare=PrimaryCare2012;Specialty=Specialty2012;
hospbd=hospbd2012;whitepct=whitepct2012;blackpct=blackpct2012;hisppct=hisppct2012;otherpct=otherpct2012;time=5; year=2012;output;

cost=cost2013;MAP=MAP2013;HCC=HCC2013; FFS=FFS2013;pop=pop2013;MHI=MHI2013;pov=pov2013; Physician=Physician2013;Physicianrank=Physician2013rank;PrimaryCare=PrimaryCare2013;Specialty=Specialty2013;
hospbd=hospbd2013;whitepct=whitepct2013;blackpct=blackpct2013;hisppct=hisppct2013;otherpct=otherpct2013;time=6; year=2013;output;
run;



* County-specific Mixed Effects Model;
%let outcome=cost;%let stratum=map2007rank;
proc mixed data=ldata empirical;
class fips region;format region region_.; 
model cost =  map  time pov mhi physician hospbd hcc pop ffs /solution;
random intercept time/subject=fips;
ods output solutionF=overall;
run;
* Stratified Analyses;
proc mixed data=ldata empirical;
where map2007rank=0;
class fips region;format region region_.; 
model cost =  map  time pov mhi physician hospbd hcc pop ffs/solution;
random intercept time/subject=fips;
ods output solutionF=MAP2007Q1;
run;
proc mixed data=ldata empirical;
where map2007rank=1;
class fips region;format region region_.; 
model cost =  map  time pov mhi physician hospbd hcc pop ffs/solution;
random intercept time/subject=fips;
ods output solutionF=MAP2007Q2;
run;
proc mixed data=ldata empirical;
where map2007rank=2;
class fips region;format region region_.; 
model cost =  map  time pov mhi physician hospbd hcc pop ffs/solution;
random intercept time/subject=fips;
ods output solutionF=MAP2007Q3;
run;
proc mixed data=ldata empirical;
where map2007rank=3;
class fips region;format region region_.; 
model cost =  map  time pov mhi physician hospbd hcc pop ffs/solution;
random intercept time/subject=fips;
ods output solutionF=MAP2007Q4;
run;

data overall;
set overall;
n=_n_;
model0="Within-County MAP Effect on TMCost";
keep n model effect estimate probt;
rename effect=effect0;rename estimate=estimate0;rename probt=probt0;
run;
data MAP2007Q1;
set MAP2007Q1;
n=_n_;
model1="Stratified by Baseline MAP: Q1 Within-County MAP Effect on TMCost";
keep n model1 effect estimate probt;
rename effect=effect1;rename estimate=estimate1;rename probt=probt1;
run;
data MAP2007Q2;
set MAP2007Q2;
n=_n_;
model2="Stratified by Baseline MAP: Q2 Within-County MAP Effect on TMCost";
keep n model2 effect estimate probt;
rename effect=effect2;rename estimate=estimate2;rename probt=probt2;
run;
data MAP2007Q3;
set MAP2007Q3;
n=_n_;
model3="Stratified by Baseline MAP: Q3 Within-County MAP Effect on TMCost";
keep n model3 effect estimate probt;
rename effect=effect3;rename estimate=estimate3;rename probt=probt3;
run;
data MAP2007Q4;
set MAP2007Q4;
n=_n_;
model4="Stratified by Baseline MAP: Q4 Within-County MAP Effect on TMCost";
keep n model4 effect estimate probt;
rename effect=effect4;rename estimate=estimate4;rename probt=probt4;
run;
data all;
merge overall MAP2007Q1 MAP2007Q2 MAP2007Q3 MAP2007Q4;
run;

