***********************
Table 1
Xiner Zhou
5/12/2015
**********************;

libname MAP 'C:\data\Projects\Medicare Utilization vs MA Rate\Data';

data temp1;
set map.data;
 
mapdiff=map2013-map2007; 
costdiff=cost2013-cost2007;
hccdiff=hcc2013-hcc2007;

pop=mean(pop2007,pop2008,pop2009,pop2010,pop2011,pop2012,pop2013);
FFS=mean(FFS2007,FFS2008,FFS2009,FFS2010,FFS2011,FFS2012,FFS2013);
age=mean(age2007,age2008,age2009,age2010,age2011,age2012,age2013);
 
whitepct=mean(whitepct12011,whitepct12012,whitepct12013);
blackpct=mean(blackpct12011,blackpct12012,blackpct12013);
hisppct=mean(hisppct12011,hisppct12012,hisppct12013);
Otherpct=mean(Otherpct12011,Otherpct12012,Otherpct12013);
pov=mean(pov2007,pov2008,pov2009,pov2010,pov2011,pov2012,pov2013);
mhi=mean(mhi2007,mhi2008,mhi2009,mhi2010,mhi2011,mhi2012,mhi2013);
Physician=mean(Physician2007,Physician2008,Physician2009,Physician2010,Physician2011,Physician2012,Physician2013);
PrimaryCare=mean(PrimaryCare2007,PrimaryCare2008,PrimaryCare2009,PrimaryCare2010,PrimaryCare2011,PrimaryCare2012,PrimaryCare2013);
Specialty=mean(Specialty2007,Specialty2008,Specialty2009,Specialty2010,Specialty2011,Specialty2012,Specialty2013);
hospbd=mean(hospbd2007,hospbd2008,hospbd2009,hospbd2010,hospbd2011,hospbd2012,hospbd2013);

if mapdiff ne . then do;
if mapdiff<-5 then mapdiffrank=1;
else if -5<=mapdiff<=5 then mapdiffrank=2;
else if 5<mapdiff<=15 then mapdiffrank=3;
else if mapdiff>15 then mapdiffrank=4;
end;
proc freq;tables region*mapdiffrank mapdiffrank/nocum norow nopercent   chisq;

run;

proc means data=temp1 min max;
class mapdiffrank;
var mapdiff;
run;

/*
proc rank data=temp1 out=temp2 group=4;
var mapdiff;
ranks mapdiffrank;
run;

proc freq data=temp2; tables region*mapdiffrank mapdiffrank/nocum norow nopercent chisq;
run;
*/

%macro table(y=);

ods output "Estimates"=mean&y. "Type 3 Tests of Fixed Effects"=p&y.;
	proc mixed data=temp1;
		class mapdiffrank;
		model &y.=mapdiffrank /solution;
		estimate "mapdiffrank Q1" intercept 1 mapdiffrank 1 0 0 0;
		estimate "mapdiffrank Q2" intercept 1 mapdiffrank 0 1 0 0;
		estimate "mapdiffrank Q3" intercept 1 mapdiffrank 0 0 1 0;
		estimate "mapdiffrank Q4" intercept 1 mapdiffrank 0 0 0 1;
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
%table(y=mapdiff);
%table(y=map2007);
%table(y=Physician);
%table(y=PrimaryCare);
%table(y=Specialty);
%table(y=hospbd);

%table(y=pop);
%table(y=FFS);
%macro table1(y=);

ods output "Estimates"=mean&y. "Type 3 Tests of Fixed Effects"=p&y.;
	proc mixed data=temp1;
		class mapdiffrank;
		weight FFS;
		model &y.=mapdiffrank /solution;
		estimate "mapdiffrank Q1" intercept 1 mapdiffrank 1 0 0 0;
		estimate "mapdiffrank Q2" intercept 1 mapdiffrank 0 1 0 0;
		estimate "mapdiffrank Q3" intercept 1 mapdiffrank 0 0 1 0;
		estimate "mapdiffrank Q4" intercept 1 mapdiffrank 0 0 0 1;
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

%mend table1;
%table1(y=costdiff);
%table1(y=cost2007);
%table1(y=HCCdiff);

%table1(y=Age);

%table1(y=whitepct);
%table1(y=blackpct);
%table1(y=hisppct);
%table1(y=otherpct);
 
%macro table2(y=);

ods output "Estimates"=mean&y. "Type 3 Tests of Fixed Effects"=p&y.;
	proc mixed data=temp1;
		class mapdiffrank;
		weight pop;
		model &y.=mapdiffrank /solution;
		estimate "mapdiffrank Q1" intercept 1 mapdiffrank 1 0 0 0;
		estimate "mapdiffrank Q2" intercept 1 mapdiffrank 0 1 0 0;
		estimate "mapdiffrank Q3" intercept 1 mapdiffrank 0 0 1 0;
		estimate "mapdiffrank Q4" intercept 1 mapdiffrank 0 0 0 1;
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

%mend table2;
%table2(y=pov);
%table2(y=mhi);

data all;
set mapdiff map2007 costdiff cost2007 hccdiff Physician Primarycare specialty hospbd pov mhi whitepct blackpct hisppct otherpct
 pop ffs age  ;
proc print;var effect mapdiffrank_Q1 mapdiffrank_Q2 mapdiffrank_Q3 mapdiffrank_Q4 probf;
run;

 
