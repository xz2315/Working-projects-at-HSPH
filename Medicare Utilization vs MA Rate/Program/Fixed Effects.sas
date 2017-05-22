***********************
Fix Effects
Xiner Zhou
8/10/2015
***********************;


libname MAP 'C:\data\Projects\Medicare Utilization vs MA Rate\data';

proc freq data=map.data;tables state/out=state;run;
data state;
set state;
stateflag=_n_;
run;

proc sql;
create table data as
select a.*,b.stateflag
from map.data a left join state b
on a.state=b.state;
quit;

 
data ldata;
set data;
cost=cost2007; MAP=MAP2007;HCC=HCC2007; FFS=FFS2007;age=age2007;pop=pop2007;MHI=MHI2007;MHIrank=MHI2007rank;pov=pov2007; 
Physician=Physician2007;PrimaryCare=PrimaryCare2007;Specialty=Specialty2007;
hospbd=hospbd2007;whitepct=whitepct2007;blackpct=blackpct2007;hisppct=hisppct2007;otherpct=otherpct2007;
EmployRate=EmployRate2007;PhysicianRank=physician2007rank;PCPrank=PrimaryCare2007rank;Year=-3;YearSquared=9;output;

cost=cost2008; MAP=MAP2008;HCC=HCC2008; FFS=FFS2008;age=age2008;pop=pop2008;MHI=MHI2008;MHIrank=MHI2008rank;pov=pov2008; 
Physician=Physician2008; PrimaryCare=PrimaryCare2008;Specialty=Specialty2008;
hospbd=hospbd2008;whitepct=whitepct2008;blackpct=blackpct2008;hisppct=hisppct2008;otherpct=otherpct2008;
EmployRate=EmployRate2008;PhysicianRank=physician2008rank;PCPrank=PrimaryCare2008rank;Year=-2;YearSquared=4; output;

cost=cost2009;MAP=MAP2009;HCC=HCC2009; FFS=FFS2009;age=age2009;pop=pop2009;MHI=MHI2009;MHIrank=MHI2009rank;pov=pov2009; 
Physician=Physician2009;PrimaryCare=PrimaryCare2009;Specialty=Specialty2009;
hospbd=hospbd2009;whitepct=whitepct2009;blackpct=blackpct2009;hisppct=hisppct2009;otherpct=otherpct2009;
EmployRate=EmployRate2009;PhysicianRank=physician2009rank;PCPrank=PrimaryCare2009rank;Year=-1; YearSquared=1;output;

cost=cost2010;MAP=MAP2010;HCC=HCC2010; FFS=FFS2010;age=age2010;pop=pop2010;MHI=MHI2010;MHIrank=MHI2010rank;pov=pov2010; 
Physician=Physician2010;PrimaryCare=PrimaryCare2010;Specialty=Specialty2010;
hospbd=hospbd2010;whitepct=whitepct2010;blackpct=blackpct2010;hisppct=hisppct2010;otherpct=otherpct2010;
EmployRate=EmployRate2010;PhysicianRank=physician2010rank;PCPrank=PrimaryCare2010rank;Year=0;YearSquared=0; output;

cost=cost2011;MAP=MAP2011;HCC=HCC2011; FFS=FFS2011;age=age2011;pop=pop2011;MHI=MHI2011;MHIrank=MHI2011rank;pov=pov2011; 
Physician=Physician2011;PrimaryCare=PrimaryCare2011;Specialty=Specialty2011;
hospbd=hospbd2011;whitepct=whitepct2011;blackpct=blackpct2011;hisppct=hisppct2011;otherpct=otherpct2011;
EmployRate=EmployRate2011;PhysicianRank=physician2011rank;PCPrank=PrimaryCare2011rank;Year=1;YearSquared=1; output;

cost=cost2012;MAP=MAP2012;HCC=HCC2012; FFS=FFS2012;age=age2012;pop=pop2012;MHI=MHI2012;MHIrank=MHI2012rank;pov=pov2012; 
Physician=Physician2012; PrimaryCare=PrimaryCare2012;Specialty=Specialty2012; 
hospbd=hospbd2012;whitepct=whitepct2012;blackpct=blackpct2012;hisppct=hisppct2012;otherpct=otherpct2012;
EmployRate=EmployRate2012;PhysicianRank=physician2012rank;PCPrank=PrimaryCare2012rank;Year=2; YearSquared=4;output;

cost=cost2013;MAP=MAP2013;HCC=HCC2013; FFS=FFS2013;age=age2013;pop=pop2013;MHI=MHI2013;MHIrank=MHI2013rank;pov=pov2013; 
Physician=Physician2013; PrimaryCare=PrimaryCare2013;Specialty=Specialty2013;
hospbd=hospbd2013;whitepct=whitepct2013;blackpct=blackpct2013;hisppct=hisppct2013;otherpct=otherpct2013;
EmployRate=EmployRate2013;PhysicianRank=physician2013rank;PCPrank=PrimaryCare2013rank;Year=3; YearSquared=9;output;
run;


proc genmod data=ldata;
class stateflag;
weight ffs;
model cost=map Year YearSquared stateflag /dist=normal  cl;
ods output ParameterEstimates=unadj;
run;
proc genmod data=ldata;
class stateflag;
weight ffs;
model cost=map Year YearSquared stateflag primarycare specialty hospbd /dist=normal cl ;
ods output ParameterEstimates=market;
run;
proc genmod data=ldata;
class stateflag;
weight ffs;
model cost=map Year YearSquared stateflag pov mhi blackpct hisppct otherpct hcc age /dist=normal cl ;
ods output ParameterEstimates=demog;
run;
proc genmod data=ldata;
class stateflag;
weight ffs;
model cost=map Year YearSquared stateflag primarycare specialty hospbd pov mhi blackpct hisppct otherpct hcc age/dist=normal cl;
ods output ParameterEstimates=full;
run;
 


data Unadj;
	length model $80.;
	set Unadj;
	model='Unadjusted';if Parameter ne 'stateflag';keep model parameter estimate stderr LowerWaldCL UpperWaldCL ProbChiSq;
run;
data market;
	length model $80.;
	set market;
	model='Adjusted only for market characteristics';
if Parameter ne 'stateflag';keep model parameter estimate stderr LowerWaldCL UpperWaldCL ProbChiSq;
run;
data demog;
	length model $80.;
	set demog;
	model='Adjusted only for Demographics';
if Parameter ne 'stateflag';keep model parameter estimate stderr LowerWaldCL UpperWaldCL ProbChiSq;
run;
data full;
	length model $80.;
	set full;
	model='Fully adjusted';
if Parameter ne 'stateflag';keep model parameter estimate stderr LowerWaldCL UpperWaldCL ProbChiSq;
run;



data all;
set Unadj market demog full;
proc print;
run;

proc print data=all;where Parameter='MAP';run;
