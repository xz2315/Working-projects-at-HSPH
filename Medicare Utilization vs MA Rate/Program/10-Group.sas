**************************
4 Groups Analyses
Xiner Zhou
5/14/2015
**************************;

libname MAP 'C:\data\Projects\Medicare Utilization vs MA Rate';

data temp1;
set map.data;
mapdiff=map2013-map2007;
costdiff=cost2013-cost2007;
run;
 proc rank data=temp1 out=temp2 group=10;
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
else if mapdiffrank=4 then do;
	group=5;mean5=mean;
end;
else if mapdiffrank=5 then do;
	group=6;mean6=mean;
end;
else if mapdiffrank=6 then do;
	group=7;mean7=mean;
end;
else if mapdiffrank=7 then do;
	group=8;mean8=mean;
end;
else if mapdiffrank=8 then do;
	group=9;mean9=mean;
end;
else if mapdiffrank=9 then do;
	group=10;mean10=mean;
end;
keep group mean1 mean2 mean3 mean4 mean5 mean6 mean7 mean8 mean9 mean10 time;run;
proc sort data=mean nodupkey;
by group time;
run;

proc sgplot data=mean;
series y=mean1 x=time/legendlabel="MAP Change 1/10" markers lineattrs=(thickness=2);
series y=mean2 x=time/legendlabel="MAP Change 2/10" markers lineattrs=(thickness=2);
series y=mean3 x=time/legendlabel="MAP Change 3/10" markers lineattrs=(thickness=2);
series y=mean4 x=time/legendlabel="MAP Change 4/10" markers lineattrs=(thickness=2);
series y=mean5 x=time/legendlabel="MAP Change 5/10" markers lineattrs=(thickness=2);
series y=mean6 x=time/legendlabel="MAP Change 6/10" markers lineattrs=(thickness=2);
series y=mean7 x=time/legendlabel="MAP Change 7/10" markers lineattrs=(thickness=2);
series y=mean8 x=time/legendlabel="MAP Change 8/10" markers lineattrs=(thickness=2);
series y=mean9 x=time/legendlabel="MAP Change 9/10" markers lineattrs=(thickness=2);
series y=mean10 x=time/legendlabel="MAP Change 10/10" markers lineattrs=(thickness=2);
yaxis label="Medicare Advantage Penetration Rate";
title 'Average MAP';
run;



* how cost change ;

proc means data=ldata noprint;
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
else if mapdiffrank=4 then do;
	group=5;mean5=mean;
end;
else if mapdiffrank=5 then do;
	group=6;mean6=mean;
end;
else if mapdiffrank=6 then do;
	group=7;mean7=mean;
end;
else if mapdiffrank=7 then do;
	group=8;mean8=mean;
end;
else if mapdiffrank=8 then do;
	group=9;mean9=mean;
end;
else if mapdiffrank=9 then do;
	group=10;mean10=mean;
end;
keep group mean1 mean2 mean3 mean4 mean5 mean6 mean7 mean8 mean9 mean10 time;run;
proc sort data=mean nodupkey;
by group time;
run;

proc sgplot data=mean;
series y=mean1 x=time/legendlabel="MAP Change 1/10" markers lineattrs=(thickness=2);
series y=mean2 x=time/legendlabel="MAP Change 2/10" markers lineattrs=(thickness=2);
series y=mean3 x=time/legendlabel="MAP Change 3/10" markers lineattrs=(thickness=2);
series y=mean4 x=time/legendlabel="MAP Change 4/10" markers lineattrs=(thickness=2);
series y=mean5 x=time/legendlabel="MAP Change 5/10" markers lineattrs=(thickness=2);
series y=mean6 x=time/legendlabel="MAP Change 6/10" markers lineattrs=(thickness=2);
series y=mean7 x=time/legendlabel="MAP Change 7/10" markers lineattrs=(thickness=2);
series y=mean8 x=time/legendlabel="MAP Change 8/10" markers lineattrs=(thickness=2);
series y=mean9 x=time/legendlabel="MAP Change 9/10" markers lineattrs=(thickness=2);
series y=mean10 x=time/legendlabel="MAP Change 10/10" markers lineattrs=(thickness=2);
yaxis label="TM Cost";
title 'Average Risk-Adjust Standard Cost';
run;


* how HCC scores change ;

proc means data=ldata noprint;
var hcc;
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
else if mapdiffrank=4 then do;
	group=5;mean5=mean;
end;
else if mapdiffrank=5 then do;
	group=6;mean6=mean;
end;
else if mapdiffrank=6 then do;
	group=7;mean7=mean;
end;
else if mapdiffrank=7 then do;
	group=8;mean8=mean;
end;
else if mapdiffrank=8 then do;
	group=9;mean9=mean;
end;
else if mapdiffrank=9 then do;
	group=10;mean10=mean;
end;
keep group mean1 mean2 mean3 mean4 mean5 mean6 mean7 mean8 mean9 mean10 time;run;
proc sort data=mean nodupkey;
by group time;
run;

proc sgplot data=mean;
series y=mean1 x=time/legendlabel="MAP Change 1/10" markers lineattrs=(thickness=2);
series y=mean2 x=time/legendlabel="MAP Change 2/10" markers lineattrs=(thickness=2);
series y=mean3 x=time/legendlabel="MAP Change 3/10" markers lineattrs=(thickness=2);
series y=mean4 x=time/legendlabel="MAP Change 4/10" markers lineattrs=(thickness=2);
series y=mean5 x=time/legendlabel="MAP Change 5/10" markers lineattrs=(thickness=2);
series y=mean6 x=time/legendlabel="MAP Change 6/10" markers lineattrs=(thickness=2);
series y=mean7 x=time/legendlabel="MAP Change 7/10" markers lineattrs=(thickness=2);
series y=mean8 x=time/legendlabel="MAP Change 8/10" markers lineattrs=(thickness=2);
series y=mean9 x=time/legendlabel="MAP Change 9/10" markers lineattrs=(thickness=2);
series y=mean10 x=time/legendlabel="MAP Change 10/10" markers lineattrs=(thickness=2);
yaxis label="HCC score";
title 'Average HCC scores';
run;

 

*********************************Table1;

data temp1;
set map.data;
where state not in ('','Guam','Puerto Rico','US Virgin Is');
mapdiff=map2013-map2007;
costdiff=cost2013-cost2007;
hccdiff=hcc2013-hcc2007;

pop=mean(pop2007,pop2008,pop2009,pop2010,pop2011,pop2012,pop2013);
FFS=mean(FFS2007,FFS2008,FFS2009,FFS2010,FFS2011,FFS2012,FFS2013);
age=mean(age2007,age2008,age2009,age2010,age2011,age2012,age2013);
whitepct=mean(whitepct2007,whitepct2008,whitepct2009,whitepct2010,whitepct2011,whitepct2012,whitepct2013);
blackpct=mean(blackpct2007,blackpct2008,blackpct2009,blackpct2010,blackpct2011,blackpct2012,blackpct2013);
hisppct=mean(hisppct2007,hisppct2008,hisppct2009,hisppct2010,hisppct2011,hisppct2012,hisppct2013);
Otherpct=mean(Otherpct2007,Otherpct2008,Otherpct2009,Otherpct2010,Otherpct2011,Otherpct2012,Otherpct2013);
pov=mean(pov2007,pov2008,pov2009,pov2010,pov2011,pov2012,pov2013);
mhi=mean(mhi2007,mhi2008,mhi2009,mhi2010,mhi2011,mhi2012,mhi2013);
Physician=mean(Physician2007,Physician2008,Physician2009,Physician2010,Physician2011,Physician2012,Physician2013);
PrimaryCare=mean(PrimaryCare2007,PrimaryCare2008,PrimaryCare2009,PrimaryCare2010,PrimaryCare2011,PrimaryCare2012,PrimaryCare2013);
Specialty=mean(Specialty2007,Specialty2008,Specialty2009,Specialty2010,Specialty2011,Specialty2012,Specialty2013);
hospbd=mean(hospbd2007,hospbd2008,hospbd2009,hospbd2010,hospbd2011,hospbd2012,hospbd2013);
 
run;

proc rank data=temp1 out=temp2 group=10;
var mapdiff;
ranks mapdiffrank;
run;

%macro table(y=);

ods output "Estimates"=mean&y. "Type 3 Tests of Fixed Effects"=p&y.;
	proc mixed data=temp2  ;
		class mapdiffrank;
		model &y.=mapdiffrank /solution;
		estimate "mapdiffrank 1/10" intercept 1 mapdiffrank 1 0 0 0 0 0 0 0 0 0;
		estimate "mapdiffrank 2/10" intercept 1 mapdiffrank 0 1 0 0 0 0 0 0 0 0;
		estimate "mapdiffrank 3/10" intercept 1 mapdiffrank 0 0 1 0 0 0 0 0 0 0;
		estimate "mapdiffrank 4/10" intercept 1 mapdiffrank 0 0 0 1 0 0 0 0 0 0;
		estimate "mapdiffrank 5/10" intercept 1 mapdiffrank 0 0 0 0 1 0 0 0 0 0;
		estimate "mapdiffrank 6/10" intercept 1 mapdiffrank 0 0 0 0 0 1 0 0 0 0;
		estimate "mapdiffrank 7/10" intercept 1 mapdiffrank 0 0 0 0 0 0 1 0 0 0;
		estimate "mapdiffrank 8/10" intercept 1 mapdiffrank 0 0 0 0 0 0 0 1 0 0;
		estimate "mapdiffrank 9/10" intercept 1 mapdiffrank 0 0 0 0 0 0 0 0 1 0;
		estimate "mapdiffrank 10/10" intercept 1 mapdiffrank 0 0 0 0 0 0 0 0 0 1;
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
%table(y=costdiff);
%table(y=cost2007);
%table(y=Physician);
%table(y=PrimaryCare);
%table(y=Specialty);
%table(y=hospbd);
%table(y=pov);
%table(y=mhi);
%table(y=whitepct);
%table(y=blackpct);
%table(y=hisppct);
%table(y=otherpct);
%table(y=HCCdiff);
%table(y=Pop);
%table(y=FFS);
%table(y=Age);

data all;
set mapdiff map2007 costdiff cost2007 hccdiff Physician Primarycare specialty hospbd pov mhi whitepct blackpct hisppct otherpct
 pop ffs age;
proc print;var effect mapdiffrank_1_10  mapdiffrank_2_10 mapdiffrank_3_10
mapdiffrank_4_10 mapdiffrank_5_10 mapdiffrank_6_10 mapdiffrank_7_10 mapdiffrank_8_10 mapdiffrank_9_10 
mapdiffrank_10_10 probf;
run;



 
