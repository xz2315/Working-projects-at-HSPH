**************************
4 Groups Analyses
Xiner Zhou
5/14/2015
**************************;

libname MAP 'C:\data\Projects\Medicare Utilization vs MA Rate\Data';

data temp1;
set map.data;
mapdiff=map2013-map2007;
costdiff=cost2013-cost2007;
run;
 proc rank data=temp1 out=temp2 group=4;
 var mapdiff;
 ranks mapdiffrank;
 run;

 
data ldata;
set temp2;

where state not in ('','Guam','Puerto Rico','US Virgin Is');

cost=cost2007; stdcost=stdcost2007;ip=ip2007;MAP=MAP2007;HCC=HCC2007; FFS=FFS2007;age=age2007;pop=pop2007;MHI=MHI2007;pov=pov2007; 
Physician=Physician2007;PrimaryCare=PrimaryCare2007;Specialty=Specialty2007;
hospbd=hospbd2007;whitepct=whitepct2007;blackpct=blackpct2007;hisppct=hisppct2007;otherpct=otherpct2007;time=2007;Year=-3;YearSquared=9;output;

cost=cost2008; stdcost=stdcost2008;ip=ip2008;MAP=MAP2008;HCC=HCC2008; FFS=FFS2008;age=age2008;pop=pop2008;MHI=MHI2008;pov=pov2008; 
Physician=Physician2008; PrimaryCare=PrimaryCare2008;Specialty=Specialty2008;
hospbd=hospbd2008;whitepct=whitepct2008;blackpct=blackpct2008;hisppct=hisppct2008;otherpct=otherpct2008;time=2008;Year=-2;YearSquared=4; output;

cost=cost2009;stdcost=stdcost2009;ip=ip2009;MAP=MAP2009;HCC=HCC2009; FFS=FFS2009;age=age2009;pop=pop2009;MHI=MHI2009;pov=pov2009; 
Physician=Physician2009;Physicianrank=Physician2009rank;
PrimaryCare=PrimaryCare2009;Specialty=Specialty2009;PrimaryCareRank=PrimaryCare2009rank;SpecialtyRank=Specialty2009rank;
hospbd=hospbd2009;whitepct=whitepct2009;blackpct=blackpct2009;hisppct=hisppct2009;otherpct=otherpct2009;time=2009;Year=-1; YearSquared=1;output;

cost=cost2010;stdcost=stdcost2010;ip=ip2010;MAP=MAP2010;HCC=HCC2010; FFS=FFS2010;age=age2010;pop=pop2010;MHI=MHI2010;pov=pov2010; Physician=Physician2010;
PrimaryCare=PrimaryCare2010;Specialty=Specialty2010;
hospbd=hospbd2010;whitepct=whitepct2010;blackpct=blackpct2010;hisppct=hisppct2010;otherpct=otherpct2010;time=2010;Year=0;YearSquared=0; output;

cost=cost2011;stdcost=stdcost2011;ip=ip2011;MAP=MAP2011;HCC=HCC2011; FFS=FFS2011;age=age2011;pop=pop2011;MHI=MHI2011;pov=pov2011; 
Physician=Physician2011;PrimaryCare=PrimaryCare2011;Specialty=Specialty2011;
hospbd=hospbd2011;whitepct=whitepct2011;blackpct=blackpct2011;hisppct=hisppct2011;otherpct=otherpct2011;time=2011;Year=1;YearSquared=1; output;

cost=cost2012;stdcost=stdcost2012;ip=ip2012;MAP=MAP2012;HCC=HCC2012; FFS=FFS2012;age=age2012;pop=pop2012;MHI=MHI2012;pov=pov2012; 
Physician=Physician2012; PrimaryCare=PrimaryCare2012;Specialty=Specialty2012; 
hospbd=hospbd2012;whitepct=whitepct2012;blackpct=blackpct2012;hisppct=hisppct2012;otherpct=otherpct2012;time=2012;Year=2; YearSquared=4;output;

cost=cost2013;stdcost=stdcost2013;ip=ip2013;MAP=MAP2013;HCC=HCC2013; FFS=FFS2013;age=age2013;pop=pop2013;MHI=MHI2013;pov=pov2013; 
Physician=Physician2013; PrimaryCare=PrimaryCare2013;Specialty=Specialty2013;
hospbd=hospbd2013;whitepct=whitepct2013;blackpct=blackpct2013;hisppct=hisppct2013;otherpct=otherpct2013;time=2013;Year=3; YearSquared=9;output;
run;

* how map changes;
proc mixed data=ldata;
class fips mapdiffrank;
model map= mapdiffrank time mapdiffrank*time/solution outpm=pred;
random intercept time/subject=fips solution  ;
estimate "Starting cost for Q1" intercept 1 mapdiffrank 1 0 0 0  ;
estimate "Starting cost for Q2" intercept 1 mapdiffrank 0 1 0 0 ;
estimate "Starting cost for Q3" intercept 1 mapdiffrank 0 0 1 0 ;
estimate "Starting cost for Q4" intercept 1 mapdiffrank 0 0 0 1 ;

estimate "cost Change Rate for Q1" time 1 mapdiffrank*time 1 0 0 0 ;
estimate "cost Change Rate for Q2" time 1 mapdiffrank*time 0 1 0 0 ;
estimate "cost Change Rate for Q3" time 1 mapdiffrank*time 0 0 1 0 ;
estimate "cost Change Rate for Q4" time 1 mapdiffrank*time 0 0 0 1 ;
run;

data pred; 
set pred;
where mapdiffrank ne .;
if mapdiffrank=0 then do;
	group=1;pred1=pred;
end;
else if mapdiffrank=1 then do;
	group=2;pred2=pred;
end;
else if mapdiffrank=2 then do;
	group=3;pred3=pred;
end;
else if mapdiffrank=3 then do;
	group=4;pred4=pred;
end;
keep group pred1 pred2 pred3 pred4 time;run;
proc sort data=pred nodupkey;
by group time;
run;


proc sgplot data=pred;
series y=pred1 x=time/legendlabel="MAP Change Q1" markers lineattrs=(thickness=2);
series y=pred2 x=time/legendlabel="MAP Change Q2" markers lineattrs=(thickness=2);
series y=pred3 x=time/legendlabel="MAP Change Q3" markers lineattrs=(thickness=2);
series y=pred4 x=time/legendlabel="MAP Change Q4" markers lineattrs=(thickness=2);
yaxis label="Medicare Advantage Penetration Rate";
title 'Average MAP';
run;


proc means data=ldata noprint;
var map;
class mapdiffrank time;
output out=mean mean=mean;
run;

data mean; 
set mean;
where mapdiffrank ne .;
if mapdiffrank=0 then do;
	group=1;mean1=mean;
end;
else if mapdiffrank=1 then do;
	group=2;mean2=mean;
end;
else if mapdiffrank=2 then do;
	group=3;mean3=mean;
end;
else if mapdiffrank=3 then do;
	group=4;mean4=mean;
end;
keep group mean1 mean2 mean3 mean4 time;run;
proc sort data=mean nodupkey;
by group time;
run;

proc sgplot data=mean;
series y=mean1 x=time/legendlabel="MAP Change Q1" markers lineattrs=(thickness=2);
series y=mean2 x=time/legendlabel="MAP Change Q2" markers lineattrs=(thickness=2);
series y=mean3 x=time/legendlabel="MAP Change Q3" markers lineattrs=(thickness=2);
series y=mean4 x=time/legendlabel="MAP Change Q4" markers lineattrs=(thickness=2);
yaxis label="Medicare Advantage Penetration Rate";
title 'Average MAP';
run;



* how cost change ;
proc mixed data=ldata;
class fips mapdiffrank;
model cost= mapdiffrank Year YearSquared mapdiffrank*Year mapdiffrank*YearSquared
/solution outpm=pred;
random intercept Year YearSquared/subject=fips solution  ;
run;

*primarycare specialty hospbd pov mhi blackpct hisppct otherpct hcc pop ffs age;
data pred; 
set pred;
where mapdiffrank ne .;
if mapdiffrank=0 then do;
	group=1;pred1=pred;
end;
else if mapdiffrank=1 then do;
	group=2;pred2=pred;
end;
else if mapdiffrank=2 then do;
	group=3;pred3=pred;
end;
else if mapdiffrank=3 then do;
	group=4;pred4=pred;
end;
keep group pred1 pred2 pred3 pred4 time;run;
proc sort data=pred nodupkey;
by group time;
run;


proc sgplot data=pred;
series y=pred1 x=time/legendlabel="MAP Change Q1" markers lineattrs=(thickness=2);
series y=pred2 x=time/legendlabel="MAP Change Q2" markers lineattrs=(thickness=2);
series y=pred3 x=time/legendlabel="MAP Change Q3" markers lineattrs=(thickness=2);
series y=pred4 x=time/legendlabel="MAP Change Q4" markers lineattrs=(thickness=2);
yaxis label="TM Cost";
title 'Average Risk-Adjust Standard Cost';
run;


proc means data=ldata noprint;
weight ffs;
var cost;
class mapdiffrank time;
output out=mean mean=mean;
run;
data mean; 
set mean;
where mapdiffrank ne .;
if mapdiffrank=0 then do;
	group=1;mean1=mean;
end;
else if mapdiffrank=1 then do;
	group=2;mean2=mean;
end;
else if mapdiffrank=2 then do;
	group=3;mean3=mean;
end;
else if mapdiffrank=3 then do;
	group=4;mean4=mean;
end;
keep group mean1 mean2 mean3 mean4 time;run;
proc sort data=mean nodupkey;
by group time;
run;

proc sgplot data=mean;
series y=mean1 x=time/legendlabel="MAP Change Q1" markers lineattrs=(thickness=2);
series y=mean2 x=time/legendlabel="MAP Change Q2" markers lineattrs=(thickness=2);
series y=mean3 x=time/legendlabel="MAP Change Q3" markers lineattrs=(thickness=2);
series y=mean4 x=time/legendlabel="MAP Change Q4" markers lineattrs=(thickness=2);
yaxis label="TM Cost";
title 'Weighted Average Risk-Adjust Standard Cost';
run;

 

* how HCC scores change ;
proc mixed data=ldata;
class fips mapdiffrank;
model hcc= mapdiffrank time mapdiffrank*time/solution outpm=pred;
random intercept time/subject=fips solution  ;
estimate "Starting Cost for Q1" intercept 1 mapdiffrank 1 0 0 0  ;
estimate "Starting Cost for Q2" intercept 1 mapdiffrank 0 1 0 0 ;
estimate "Starting Cost for Q3" intercept 1 mapdiffrank 0 0 1 0 ;
estimate "Starting Cost for Q4" intercept 1 mapdiffrank 0 0 0 1 ;

estimate "Cost Change per year for Q1" time 1 mapdiffrank*time 1 0 0 0 ;
estimate "Cost Change per year for Q2" time 1 mapdiffrank*time 0 1 0 0 ;
estimate "Cost Change per year for Q3" time 1 mapdiffrank*time 0 0 1 0 ;
estimate "Cost Change per year for Q4" time 1 mapdiffrank*time 0 0 0 1 ;
run;

data pred; 
set pred;
where mapdiffrank ne .;
if mapdiffrank=0 then do;
	group=1;pred1=pred;
end;
else if mapdiffrank=1 then do;
	group=2;pred2=pred;
end;
else if mapdiffrank=2 then do;
	group=3;pred3=pred;
end;
else if mapdiffrank=3 then do;
	group=4;pred4=pred;
end;
keep group pred1 pred2 pred3 pred4 year;run;
proc sort data=pred nodupkey;
by group year;
run;


proc sgplot data=pred;
series y=pred1 x=year/legendlabel="MAP Change Q1" markers lineattrs=(thickness=2);
series y=pred2 x=year/legendlabel="MAP Change Q2" markers lineattrs=(thickness=2);
series y=pred3 x=year/legendlabel="MAP Change Q3" markers lineattrs=(thickness=2);
series y=pred4 x=year/legendlabel="MAP Change Q4" markers lineattrs=(thickness=2);
yaxis label="TM Cost";
title 'Average Risk-Adjust Standard Cost';
run;


 


proc means data=ldata noprint;
var hcc;
class mapdiffrank year;
output out=mean mean=mean;
run;
data mean; 
set mean;
where mapdiffrank ne .;
if mapdiffrank=0 then do;
	group=1;mean1=mean;
end;
else if mapdiffrank=1 then do;
	group=2;mean2=mean;
end;
else if mapdiffrank=2 then do;
	group=3;mean3=mean;
end;
else if mapdiffrank=3 then do;
	group=4;mean4=mean;
end;
keep group mean1 mean2 mean3 mean4 year;run;
proc sort data=mean nodupkey;
by group year;
run;

proc sgplot data=mean;
series y=mean1 x=year/legendlabel="MAP Change Q1" markers lineattrs=(thickness=2);
series y=mean2 x=year/legendlabel="MAP Change Q2" markers lineattrs=(thickness=2);
series y=mean3 x=year/legendlabel="MAP Change Q3" markers lineattrs=(thickness=2);
series y=mean4 x=year/legendlabel="MAP Change Q4" markers lineattrs=(thickness=2);
yaxis label="HCC score";
title 'Average HCC scores';
run;

 
