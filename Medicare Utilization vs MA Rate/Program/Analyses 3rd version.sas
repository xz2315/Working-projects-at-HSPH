**************************
3rd Version Analyses
Xiner Zhou
5/4/2015
**************************;

libname MAP 'C:\data\Projects\Medicare Utilization vs MA Rate';

%macro trans(yr=);
cost=cost&yr.;MAP=MAP&yr.;MAPchange=MAP&yr.-MAP2007;HCC=HCC&yr.; 
FFS=FFS&yr.;pop=pop&yr.;
MHI=MHI&yr.;pov=pov&yr.;pop=pop&yr.;
Physician=Physician&yr.;PrimaryCare=PrimaryCare&yr.;Specialty=Specialty&yr.;
hospbd=hospbd&yr.;whitepct=whitepct&yr.;blackpct=blackpct&yr.;hisppct=hisppct&yr.;
otherpct=otherpct&yr.;time=&yr.-2007; year=&yr.;
output;
%mend trans;

data data1;
set map.data;
mapdiff=map2013-map2007;
run;
 proc rank data=data1 out=data2 group=4;
 var mapdiff;
 ranks mapdiffrank;
 run;
proc means data=data2 N min mean max;
class mapdiffrank;
var mapdiff;
run;
 
data ldata;
set data2;
mapdiffrank=mapdiffrank+1;
%trans(yr=2007);
%trans(yr=2008);
%trans(yr=2009);
%trans(yr=2010);
%trans(yr=2011);
%trans(yr=2012);
%trans(yr=2013);

run;
proc sort data=ldata;by descending mapdiffrank;run;

* individual tragectory for each group and mean response profiles;
*MAP;
%macro plot(var=,q=);
proc gplot data=ldata;
symbol interpol=join value=triangle;
plot &var.*year=fips;
where mapdiffrank=&q. ;
title "&var. Quartile &q.";
run;
%mend plot;
%plot(var=map,q=1);
%plot(var=map,q=2);
%plot(var=map,q=3);
%plot(var=map,q=4);
proc means data=ldata n mean std nway;
var map;
class mapdiffrank year;
output out=meandata mean=mean;
proc print data=meandata;
run;

proc gplot data=meandata;
symbol1 color=blue interpol=join value=dot;
symbol2 color=green interpol=join value=triangle;
symbol2 color=orange interpol=join value=triangle;
symbol2 color=red interpol=join value=triangle;
plot mean*year=mapdiffrank;
title 'Average MAP for each MAP Change Quartile';
run;
*cost;
proc means data=ldata n mean std nway;
var cost;
class mapdiffrank year;
output out=meandata mean=mean;
proc print data=meandata;
run;
proc gplot data=meandata;
symbol1 color=blue interpol=join value=dot;
symbol2 color=green interpol=join value=triangle;
symbol2 color=orange interpol=join value=triangle;
symbol2 color=red interpol=join value=triangle;
plot mean*year=mapdiffrank;
title 'Average COST for each MAP Change Quartile';
run;




* how map changes;
proc mixed data=ldata  ;
class fips mapdiffrank;
model map= mapdiffrank year1 mapdiffrank*year1/solution;
random intercept year1/subject=fips  ;
estimate "Starting MAP for Q1" intercept 1 mapdiffrank 1 0 0 0 ;
estimate "Starting MAP for Q2" intercept 1 mapdiffrank 0 1 0 0 ;
estimate "Starting MAP for Q3" intercept 1 mapdiffrank 0 0 1 0 ;
estimate "Starting MAP for Q4" intercept 1 mapdiffrank 0 0 0 1 ;

estimate "MAP Change Rate for Q1" year1 1 mapdiffrank*year1 1 0 0 0 ;
estimate "MAP Change Rate for Q2" year1 1 mapdiffrank*year1 0 1 0 0 ;
estimate "MAP Change Rate for Q3" year1 1 mapdiffrank*year1 0 0 1 0 ;
estimate "MAP Change Rate for Q4" year1 1 mapdiffrank*year1 0 0 0 1 ;
run;

* how cost change ;
proc mixed data=ldata;
class fips mapdiffrank;
model cost= mapdiffrank year1 mapdiffrank*year1/solution;
random intercept year1/subject=fips  ;
estimate "Starting cost for Q1" intercept 1 mapdiffrank 1 0 0 0 ;
estimate "Starting cost for Q2" intercept 1 mapdiffrank 0 1 0 0 ;
estimate "Starting cost for Q3" intercept 1 mapdiffrank 0 0 1 0 ;
estimate "Starting cost for Q4" intercept 1 mapdiffrank 0 0 0 1 ;

estimate "cost Change Rate for Q1" year1 1 mapdiffrank*year1 1 0 0 0 ;
estimate "cost Change Rate for Q2" year1 1 mapdiffrank*year1 0 1 0 0 ;
estimate "cost Change Rate for Q3" year1 1 mapdiffrank*year1 0 0 1 0 ;
estimate "cost Change Rate for Q4" year1 1 mapdiffrank*year1 0 0 0 1 ;
run;
