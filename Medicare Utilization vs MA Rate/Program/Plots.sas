********************************
Plot trends over time for different outcomes
Xiner Zhou
5/6/2015
*******************************;

libname MAP 'C:\data\Projects\Medicare Utilization vs MA Rate';

%let y=cost;


proc format ;
value region_
0='Northeast'
1='Midwest'
2='South'
3='West'
;
run;


data data1;
set map.data;
mapdiff=map2013-map2007;
run;
proc rank data=data1 out=data2 group=4;
 var mapdiff;
 ranks mapdiffrank;
run;

data ldata;
set data2;
&y.=&y.2007;MAP=MAP2007;HCC=HCC2007; FFS=FFS2007;pop=pop2007;MHI=MHI2007;pov=pov2007; Physician=Physician2007;Physicianrank=Physician2007rank;PrimaryCare=PrimaryCare2007;Specialty=Specialty2007;
hospbd=hospbd2007;whitepct=whitepct2007;blackpct=blackpct2007;hisppct=hisppct2007;otherpct=otherpct2007;time=0; year=2007;output;

&y.=&y.2008;MAP=MAP2008;HCC=HCC2008; FFS=FFS2008;pop=pop2008;MHI=MHI2008;pov=pov2008; Physician=Physician2008;Physicianrank=Physician2008rank;PrimaryCare=PrimaryCare2008;Specialty=Specialty2008;
hospbd=hospbd2008;whitepct=whitepct2008;blackpct=blackpct2008;hisppct=hisppct2008;otherpct=otherpct2008;time=1; year=2008;output;

&y.=&y.2009;MAP=MAP2009;HCC=HCC2009; FFS=FFS2009;pop=pop2009;MHI=MHI2009;pov=pov2009; Physician=Physician2009;Physicianrank=Physician2009rank;PrimaryCare=PrimaryCare2009;Specialty=Specialty2009;
hospbd=hospbd2009;whitepct=whitepct2009;blackpct=blackpct2009;hisppct=hisppct2009;otherpct=otherpct2009;time=2; year=2009;output;

&y.=&y.2010;MAP=MAP2010;HCC=HCC2010; FFS=FFS2010;pop=pop2010;MHI=MHI2010;pov=pov2010; Physician=Physician2010;Physicianrank=Physician2010rank;PrimaryCare=PrimaryCare2010;Specialty=Specialty2010;
hospbd=hospbd2010;whitepct=whitepct2010;blackpct=blackpct2010;hisppct=hisppct2010;otherpct=otherpct2010;time=3; year=2010;output;

&y.=&y.2011;MAP=MAP2011;HCC=HCC2011; FFS=FFS2011;pop=pop2011;MHI=MHI2011;pov=pov2011; Physician=Physician2011;Physicianrank=Physician2011rank;PrimaryCare=PrimaryCare2011;Specialty=Specialty2011;
hospbd=hospbd2011;whitepct=whitepct2011;blackpct=blackpct2011;hisppct=hisppct2011;otherpct=otherpct2011;time=4; year=2011;output;

&y.=&y.2012;MAP=MAP2012;HCC=HCC2012; FFS=FFS2012;pop=pop2012;MHI=MHI2012;pov=pov2012; Physician=Physician2012;Physicianrank=Physician2012rank;PrimaryCare=PrimaryCare2012;Specialty=Specialty2012;
hospbd=hospbd2012;whitepct=whitepct2012;blackpct=blackpct2012;hisppct=hisppct2012;otherpct=otherpct2012;time=5; year=2012;output;

&y.=&y.2013;MAP=MAP2013;HCC=HCC2013; FFS=FFS2013;pop=pop2013;MHI=MHI2013;pov=pov2013; Physician=Physician2013;Physicianrank=Physician2013rank;PrimaryCare=PrimaryCare2013;Specialty=Specialty2013;
hospbd=hospbd2013;whitepct=whitepct2013;blackpct=blackpct2013;hisppct=hisppct2013;otherpct=otherpct2013;time=6; year=2013;output;
run;

proc means data=ldata noprint;
var map;
class mapdiffrank year;
output out=mean mean=mean;
run;

proc gplot data=mean;
where mean ne . and mapdiffrank ne .;
symbol1 color=blue interpol=join value=dot;
symbol2 color=green interpol=join value=triangle;
symbol3 color=orange interpol=join value=triangle;
symbol4 color=red interpol=join value=triangle;
plot mean*year=mapdiffrank;
title 'Average MAP for each MAP Change Quartile';
run;


proc means data=ldata noprint;
var &y.;
class mapdiffrank year;
output out=mean mean=mean;
run;

proc gplot data=mean;
where mean ne . and mapdiffrank ne .;
symbol1 color=blue interpol=join value=dot;
symbol2 color=green interpol=join value=triangle;
symbol3 color=orange interpol=join value=triangle;
symbol4 color=red interpol=join value=triangle;
plot mean*year=mapdiffrank;
title "Average &y. for each MAP Change Quartile";
run;

 
* how map changes;
proc mixed data=ldata  ;
class fips mapdiffrank;
model map= mapdiffrank year mapdiffrank*year/solution;
random intercept year/subject=fips  ;
estimate "Starting MAP for Q1" intercept 1 mapdiffrank 1 0 0 0 ;
estimate "Starting MAP for Q2" intercept 1 mapdiffrank 0 1 0 0 ;
estimate "Starting MAP for Q3" intercept 1 mapdiffrank 0 0 1 0 ;
estimate "Starting MAP for Q4" intercept 1 mapdiffrank 0 0 0 1 ;

estimate "MAP Change Rate for Q1" year 1 mapdiffrank*year 1 0 0 0 ;
estimate "MAP Change Rate for Q2" year 1 mapdiffrank*year 0 1 0 0 ;
estimate "MAP Change Rate for Q3" year 1 mapdiffrank*year 0 0 1 0 ;
estimate "MAP Change Rate for Q4" year 1 mapdiffrank*year 0 0 0 1 ;
run;

* how cost change ;
proc mixed data=ldata;
class fips mapdiffrank;
model &y. = mapdiffrank year mapdiffrank*year /solution;
random intercept year/subject=fips  ;
estimate "Starting cost for Q1" intercept 1 mapdiffrank 1 0 0 0 ;
estimate "Starting cost for Q2" intercept 1 mapdiffrank 0 1 0 0 ;
estimate "Starting cost for Q3" intercept 1 mapdiffrank 0 0 1 0 ;
estimate "Starting cost for Q4" intercept 1 mapdiffrank 0 0 0 1 ;

estimate "cost Change Rate for Q1" year 1 mapdiffrank*year 1 0 0 0 ;
estimate "cost Change Rate for Q2" year 1 mapdiffrank*year 0 1 0 0 ;
estimate "cost Change Rate for Q3" year 1 mapdiffrank*year 0 0 1 0 ;
estimate "cost Change Rate for Q4" year 1 mapdiffrank*year 0 0 0 1 ;
run;
