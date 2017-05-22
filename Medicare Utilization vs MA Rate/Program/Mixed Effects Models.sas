********************************
Mixed Effects Models
Xiner Zhou
5/6/2015
*******************************;

libname MAP 'C:\data\Projects\Medicare Utilization vs MA Rate\data';


******************No stratification;
 
data ldata;
set map.data;
cost=cost2007; MAP=MAP2007;HCC=HCC2007; FFS=FFS2007;age=age2007;pop=pop2007;MHI=MHI2007;MHIrank=MHI2007rank;pov=pov2007; 
Physician=Physician2007;PrimaryCare=PrimaryCare2007;Specialty=Specialty2007;
hospbd=hospbd2007;whitepct=whitepct2007;blackpct=blackpct2007;hisppct=hisppct2007;otherpct=otherpct2007;
EmployRate=EmployRate2007;PhysicianRank=physician2007rank;PCPrank=PrimaryCare2007rank;PayRate=PayRate2007;Year=-3;YearSquared=9;output;

cost=cost2008; MAP=MAP2008;HCC=HCC2008; FFS=FFS2008;age=age2008;pop=pop2008;MHI=MHI2008;MHIrank=MHI2008rank;pov=pov2008; 
Physician=Physician2008; PrimaryCare=PrimaryCare2008;Specialty=Specialty2008;
hospbd=hospbd2008;whitepct=whitepct2008;blackpct=blackpct2008;hisppct=hisppct2008;otherpct=otherpct2008;
EmployRate=EmployRate2008;PhysicianRank=physician2008rank;PCPrank=PrimaryCare2008rank;PayRate=PayRate2008;Year=-2;YearSquared=4; output;

cost=cost2009;MAP=MAP2009;HCC=HCC2009; FFS=FFS2009;age=age2009;pop=pop2009;MHI=MHI2009;MHIrank=MHI2009rank;pov=pov2009; 
Physician=Physician2009;PrimaryCare=PrimaryCare2009;Specialty=Specialty2009;
hospbd=hospbd2009;whitepct=whitepct2009;blackpct=blackpct2009;hisppct=hisppct2009;otherpct=otherpct2009;
EmployRate=EmployRate2009;PhysicianRank=physician2009rank;PCPrank=PrimaryCare2009rank;PayRate=PayRate2009;Year=-1; YearSquared=1;output;

cost=cost2010;MAP=MAP2010;HCC=HCC2010; FFS=FFS2010;age=age2010;pop=pop2010;MHI=MHI2010;MHIrank=MHI2010rank;pov=pov2010; 
Physician=Physician2010;PrimaryCare=PrimaryCare2010;Specialty=Specialty2010;
hospbd=hospbd2010;whitepct=whitepct2010;blackpct=blackpct2010;hisppct=hisppct2010;otherpct=otherpct2010;
EmployRate=EmployRate2010;PhysicianRank=physician2010rank;PCPrank=PrimaryCare2010rank;PayRate=PayRate2010;Year=0;YearSquared=0; output;

cost=cost2011;MAP=MAP2011;HCC=HCC2011; FFS=FFS2011;age=age2011;pop=pop2011;MHI=MHI2011;MHIrank=MHI2011rank;pov=pov2011; 
Physician=Physician2011;PrimaryCare=PrimaryCare2011;Specialty=Specialty2011;
hospbd=hospbd2011;whitepct=whitepct2011;blackpct=blackpct2011;hisppct=hisppct2011;otherpct=otherpct2011;
EmployRate=EmployRate2011;PhysicianRank=physician2011rank;PCPrank=PrimaryCare2011rank;PayRate=PayRate2011;Year=1;YearSquared=1; output;

cost=cost2012;MAP=MAP2012;HCC=HCC2012; FFS=FFS2012;age=age2012;pop=pop2012;MHI=MHI2012;MHIrank=MHI2012rank;pov=pov2012; 
Physician=Physician2012; PrimaryCare=PrimaryCare2012;Specialty=Specialty2012; 
hospbd=hospbd2012;whitepct=whitepct2012;blackpct=blackpct2012;hisppct=hisppct2012;otherpct=otherpct2012;
EmployRate=EmployRate2012;PhysicianRank=physician2012rank;PCPrank=PrimaryCare2012rank;PayRate=PayRate2012;Year=2; YearSquared=4;output;

cost=cost2013;MAP=MAP2013;HCC=HCC2013; FFS=FFS2013;age=age2013;pop=pop2013;MHI=MHI2013;MHIrank=MHI2013rank;pov=pov2013; 
Physician=Physician2013; PrimaryCare=PrimaryCare2013;Specialty=Specialty2013;
hospbd=hospbd2013;whitepct=whitepct2013;blackpct=blackpct2013;hisppct=hisppct2013;otherpct=otherpct2013;
EmployRate=EmployRate2013;PhysicianRank=physician2013rank;PCPrank=PrimaryCare2013rank;PayRate=PayRate2013;Year=3; YearSquared=9;output;
run;
/*
proc mixed data=ldata empirical;
	class fips ;  
	model cost=  map Year YearSquared/solution ;
	random intercept map/subject=fips type=un s cl vcorr v Gcorr;
	ods output solutionR=random;
run;

data random;
set random;
map=estimate-10.0585;
maplower=lower-10.0585;
mapupper=upper-10.0585;
if Effect='MAP';
keep fips map maplower mapupper Probt;
run;
 
proc glm data=ldata;
	class fips ;  
    model cost=  map Year YearSquared fips map*FIPS/solution CLparm  ;
    ods output ParameterEstimates=fixed ;
run;

data fixed;
set fixed;
if scan(Parameter,1,'')='MAP*FIPS' or Parameter='MAP';
MAP=estimate-17.5174;
MAPlower=LowerCL-17.5174;
MAPupper=UpperCL-17.5174;
if scan(Parameter,1,'')='MAP*FIPS' then FIPS=scan(Parameter,2,'')*1;
if scan(Parameter,1,'')='MAP*FIPS' and scan(Parameter,2,'')*1=56045 then delete;
if Parameter='MAP' then FIPS='56045';
keep fips map MAPlower MAPupper Probt;
run;

proc sql;
create table temp as
select a.fips,a.map as fixedmap,a.MAPlower as fixedMAPLower, a.MAPUpper as fixedMAPUpper,
b.map as randommap, b.MAPlower as randomMAPLower, b.MAPUpper as randomMAPUpper, b.Probt as randomP
from fixed a join random b
on a.fips=b.fips;
quit;

proc sql;
create table all as
select a.*,b.state,b.county,b.ffs2013
from temp a left join map.data b
on a.fips=b.fips;
quit;

proc sort data=all;by randommap;run;

proc means data=all mean min p1 p5 Q1 median  Q3 p95 p99 max      ;
var fixedmap randommap;
run;
proc sgplot data=all;
*density fixedmap/type=kernel ;
density randommap/type=kernel legendlabel='Random Coefficients of MAP for each county' ;
run;
proc sgplot data=all;
density fixedmap/type=kernel legendlabel='Fixed Coefficients of MAP for each county'  ;
*density randommap/type=kernel;
run;

proc sgplot data=temp;
title 'County-Specific Estimate Fixed vs random';
scatter x=randommap y=fixedmap  ;
run;
proc sgplot data=temp;
where randommap>=0 and fixedmap>=0;
title 'County-Specific Estimate Fixed vs random: Fixed>0 and Random>0 ';
scatter x=randommap y=fixedmap  ;
run;
proc sgplot data=temp;
where randommap<0 and fixedmap>=0;
title 'County-Specific Estimate Fixed vs random: Fixed>0 and Random<0 ';
scatter x=randommap y=fixedmap  ;
run;
proc sgplot data=temp;
where randommap>=0 and fixedmap<0;
title 'County-Specific Estimate Fixed vs random: Fixed<0 and Random>0 ';
scatter x=randommap y=fixedmap  ;
run;
proc sgplot data=temp;
where randommap<0 and fixedmap<0;
title 'County-Specific Estimate Fixed vs random: Fixed<0 and Random<0 ';
scatter x=randommap y=fixedmap  ;
run;

proc rank data=all out=temp ;
var randommap;
ranks r;
run;
proc sort data=temp;by r;run;
proc print data=temp;run;

 
%macro forest(var=,from=,to= );

data temp;
set temp;
DD="&var. MAP Estimate";
LCL='Lower CL';
UCL='Upper CL';
run;

  
   

ods listing close;                                                                                                                      
ods html image_dpi=100 path="C:\data\Projects" file='sgplotforest.html';                                                                               
ods graphics / reset width=800px height=1200px imagename="Forest_Plot" imagefmt=gif;                                              
                                                                                                                                        
title "County-Specific MAP Estimate from &var. Effects Model";                                                                                                                                                                                    
                                                                                                                                        
proc sgplot data=temp  noautolegend;   
 where &from. <r<= &to.; 
   *scatter y=value1 x=diffindiff / markerattrs=graphdata2(symbol=diamondfilled size=10);  * plot Overall;                                          
   scatter y=r x=&var.MAP / xerrorupper=&var.MAPupper xerrorlower=&var.MAPlower markerattrs=graphdata1(symbol=squarefilled size=8 color=red);  * plot all other ;           
   *vector x=upperCL y=value2 / xorigin=lowerCL yorigin=value lineattrs=graphdata1(thickness=1) noarrowheads;   * plot boxes in the middle;                           
   scatter y=r x=DD / markerchar=&var.MAP x2axis ; * in the second (right panel), plot OR column;                                                                            
   scatter y=r x=LCL/ markerchar=&var.MAPlower x2axis;                                                                              
   scatter y=r x=UCL / markerchar=&var.MAPupper x2axis;                                                                              
                                                                                
   *refline 0.0978  / axis=x;                                                                                                             
   refline 0 / axis=x lineattrs=(pattern=shortdash) transparency=0.5;                                                              
   *inset '        Less than overall'  / position=bottomleft;                                                                             
   *inset 'Larger than overall'  / position=bottom;                                                                                           
   xaxis   offsetmin=0 offsetmax=0.35  minor display=(nolabel) ;                                                 
   x2axis offsetmin=0.7 display=(noticks) label="&var. MAP";                                                                                      
   yaxis display=(noticks )   offsetmax=0.05 values=(&from.  to &to. by 1);                                              
run;                                                                                                                                    
                                                                                                                                        
ods html close;                                                                                                                         
ods listing;
%end;

%mend forest;
%forest(var=random,from=0,to=75 );
%forest(var=fixed,from=0,to=75 );
%forest(var=random,from=3030,to=3105 );
%forest(var=fixed,from=3030,to=3105 );

%forest(var=random,from=50,to=100 );
%forest(var=random,from=100,to=150 );
%forest(var=random,from=150,to=200 );
%forest(var=random,from=200,to=250 );
%forest(var=random,from=250,to=300 );
%forest(var=random,from=300,to=350 );
%forest(var=random,from=350,to=400 );
%forest(var=random,from=400,to=450 );
%forest(var=random,from=450,to=500 );
%forest(var=random,from=500,to=550 );
%forest(var=random,from=550,to=600 );
%forest(var=random,from=600,to=650 );
%forest(var=random,from=650,to=700 );
%forest(var=random,from=700,to=750 );
%forest(var=random,from=750,to=800 );
%forest(var=random,from=800,to=850 );
%forest(var=random,from=850,to=900 );
%forest(var=random,from=900,to=950 );
%forest(var=random,from=950,to=1000 );
%forest(var=random,from=1000,to=1050 );
%forest(var=random,from=1050,to=1100 );
%forest(var=random,from=1100,to=1150 );
%forest(var=random,from=1150,to=1200 );
%forest(var=random,from=1200,to=1250 );
%forest(var=random,from=1250,to=1300 );
%forest(var=random,from=1300,to=1350 );
%forest(var=random,from=1350,to=1400 );
%forest(var=random,from=1400,to=1450 );
%forest(var=random,from=1450,to=1500 );
%forest(var=random,from=1500,to=1550 );
%forest(var=random,from=1550,to=1600 );
%forest(var=random,from=1600,to=1650 );
%forest(var=random,from=1650,to=1700 );
%forest(var=random,from=1700,to=1750 );

%forest(var=fixed,from=0,to=70 );
 


*/


*Un-adjusted;
proc mixed data=ldata empirical;
	class fips ; weight ffs;  
	model cost=  map Year YearSquared/solution cl;
	random intercept MAP /subject=fips;
	ods output solutionF=unadj;
run;
*Adjusted only for market characteristics (hospital beds, primary care doctors, specialists);
proc mixed data=ldata empirical;
	class fips ;   weight ffs;  
	model cost=  map  Year YearSquared primarycare specialty hospbd /solution cl;
	random intercept MAP/subject=fips;
	ods output solutionF=market;
run;
*Adjusted for demographics (% below federal poverty line, median household income, percent black, percent Hispanic, other percent, HCC, population, FFS, age);
proc mixed data=ldata empirical;
	class fips ;  weight ffs;  
	model cost=  map  Year YearSquared pov mhi blackpct hisppct otherpct hcc age /solution cl;
	random intercept MAP/subject=fips;
	ods output solutionF=demog;
run;
* Fully adjusted;
proc mixed data=ldata empirical;
	class fips ;  weight ffs;  
	model cost=  map Year YearSquared primarycare specialty hospbd pov mhi blackpct hisppct otherpct hcc age  /solution cl;
	random intercept MAP/subject=fips;
	ods output solutionF=full;
run;

data Unadj;
	length model $80.;
	set Unadj;
	model='Unadjusted';drop DF tValue Alpha  ;
run;
data market;
	length model $80.;
	set market;
	model='Adjusted only for market characteristics';drop DF tValue Alpha ;
run;
data demog;
	length model $80.;
	set demog;
	model='Adjusted for demographics';drop DF tValue Alpha  ;
run;
data full;
	length model $80.;
	set full;
	model='Fully adjusted';drop DF tValue Alpha  ;
run;

data all;
set Unadj market demog full;
proc print;
run;

proc print data=all;where effect='MAP';run;



* Stratified Analysis by baseline MAP Quantiles;

proc mixed data=ldata empirical;
	class fips map2007rank;weight ffs;
	model cost=  map map2007rank map*map2007rank Year YearSquared primarycare specialty hospbd pov mhi blackpct hisppct otherpct hcc age/solution cl;
	random intercept MAP /subject=fips;
	ods output solutionF=baseMAP;
	estimate "Baseline (2007) MAP Q1" map 1 map*map2007rank 1 0 0 0;
	estimate "Baseline (2007) MAP Q2" map 1 map*map2007rank 0 1 0 0;
	estimate "Baseline (2007) MAP Q3" map 1 map*map2007rank 0 0 1 0;
	estimate "Baseline (2007) MAP Q4" map 1 map*map2007rank 0 0 0 1;
run;

* Stratified Analysis by MHI;
proc format;
value MHIRank_
0='Q1: Lowest Income'
1='Q2               '
2='Q3               '
3='Q4: Highest Income'
;
run;

proc means data=ldata n mean  nway;
var MAP;
class MHIRank year;
output out=meandata mean=mean;
run; 

proc sort data=meandata;by MHIrank year;run;
proc transpose data=meandata out=meandata1;
by MHIrank;
var mean;
run;
proc print data=meandata1;run;

proc gplot data=meandata;
format MHIRank MHIRank_.;
symbol1 interpol=join value=triangle;
symbol2 interpol=join value=triangle;
symbol3 interpol=join value=triangle;
symbol4 interpol=join value=triangle;
plot mean*year=MHIRank;
title "Average MAP by Income Quartiles";
run;

*TMcost;
proc means data=ldata n mean  nway;
var cost;
class MHIRank year;
output out=meandata mean=mean;
run; 

proc sort data=meandata;by MHIrank year;run;
proc transpose data=meandata out=meandata1;
by MHIrank;
var mean;
run;
proc print data=meandata1;run;

proc gplot data=meandata;
format MHIRank MHIRank_.;
symbol1 interpol=join value=triangle;
symbol2 interpol=join value=triangle;
symbol3 interpol=join value=triangle;
symbol4 interpol=join value=triangle;
plot mean*year=MHIRank;
title "Average TMcost by Income Quartiles";
run;

proc mixed data=ldata empirical;
	class fips MHIrank;weight ffs;
	model cost=  map MHIrank map*MHIrank Year YearSquared primarycare specialty hospbd pov blackpct hisppct otherpct hcc age/solution cl;
	random intercept map /subject=fips;
	estimate "MHI Q1" map 1 map*MHIrank 1 0 0 0 ;
	estimate "MHI Q2" map 1 map*MHIrank 0 1 0 0 ;
	estimate "MHI Q3" map 1 map*MHIrank 0 0 1 0 ;
	estimate "MHI Q4" map 1 map*MHIrank 0 0 0 1 ;
run;
 

* Stratified Analysis by PCP Quartiles;
proc mixed data=ldata empirical;
	class fips PCPrank;weight ffs;
	model cost=  map PCPrank map*PCPrank Year YearSquared primarycare specialty hospbd pov mhi blackpct hisppct otherpct hcc age/solution cl;
	random intercept MAP /subject=fips;
	ods output solutionF=baseMAP;
	estimate "Primary Care Physician Q1" map 1 map*PCPrank 1 0 0 0;
	estimate "Primary Care Physician Q2" map 1 map*PCPrank 0 1 0 0;
	estimate "Primary Care Physician Q3" map 1 map*PCPrank 0 0 1 0;
	estimate "Primary Care Physician Q4" map 1 map*PCPrank 0 0 0 1;
run;





*1 year Lag Models;

data ldata;
set map.data;
cost=cost2009-cost2008; MAP=MAP2008-map2007;HCC=HCC2008; FFS=FFS2008;age=age2008;pop=pop2008;MHI=MHI2008;pov=pov2008; 
Physician=Physician2008;PrimaryCare=PrimaryCare2008;Specialty=Specialty2008;
hospbd=hospbd2008;whitepct=whitepct2008;blackpct=blackpct2008;hisppct=hisppct2008;otherpct=otherpct2008;time=1;year=1;output;

cost=cost2010-cost2009; MAP=MAP2009-map2008;HCC=HCC2009; FFS=FFS2009;age=age2009;pop=pop2009;MHI=MHI2009;pov=pov2009; 
Physician=Physician2009;PrimaryCare=PrimaryCare2009;Specialty=Specialty2009;
hospbd=hospbd2009;whitepct=whitepct2009;blackpct=blackpct2009;hisppct=hisppct2009;otherpct=otherpct2009;time=2;year=2;output;

cost=cost2011-cost2010; MAP=MAP2010-map2009;HCC=HCC2010; FFS=FFS2010;age=age2010;pop=pop2010;MHI=MHI2010;pov=pov2010; 
Physician=Physician2010;PrimaryCare=PrimaryCare2010;Specialty=Specialty2010;
hospbd=hospbd2010;whitepct=whitepct2010;blackpct=blackpct2010;hisppct=hisppct2010;otherpct=otherpct2010;time=3;year=3;output;

cost=cost2012-cost2011; MAP=MAP2011-map2010;HCC=HCC2011; FFS=FFS2011;age=age2011;pop=pop2011;MHI=MHI2011;pov=pov2011; 
Physician=Physician2011;PrimaryCare=PrimaryCare2011;Specialty=Specialty2011;
hospbd=hospbd2011;whitepct=whitepct2011;blackpct=blackpct2011;hisppct=hisppct2011;otherpct=otherpct2011;time=4;year=4;output;

cost=cost2013-cost2012; MAP=MAP2012-map2011;HCC=HCC2012; FFS=FFS2012;age=age2012;pop=pop2012;MHI=MHI2012;pov=pov2012; 
Physician=Physician2012;PrimaryCare=PrimaryCare2012;Specialty=Specialty2012;
hospbd=hospbd2012;whitepct=whitepct2012;blackpct=blackpct2012;hisppct=hisppct2012;otherpct=otherpct2012;time=5;year=5;output;

run;

*Un-adjusted;
proc mixed data=ldata empirical;
	class fips year;weight ffs;
	model cost=  map time /solution cl;
	repeated year/type=un subject=fips;
	ods output solutionF=unadj;
run;
*Adjusted only for market characteristics (hospital beds, primary care doctors, specialists);
proc mixed data=ldata empirical;
	class fips year;weight ffs;
	model cost=  map time primarycare specialty hospbd /solution cl;
	repeated year/type=un subject=fips;
	ods output solutionF=market;
run;
*Adjusted for demographics (% below federal poverty line, median household income, percent black, percent Hispanic, other percent, HCC, population, FFS, age);
proc mixed data=ldata empirical; 
	class fips year;weight ffs;
	model cost=  map time pov mhi blackpct hisppct otherpct hcc  age/solution cl;
	repeated year/type=un subject=fips;
	ods output solutionF=demog;
run;
* Fully adjusted;
proc mixed data=ldata empirical;
	class fips year;weight ffs;
	model cost=  map time primarycare specialty hospbd pov mhi blackpct hisppct otherpct hcc  age/solution cl;
	repeated year/type=un subject=fips;
	ods output solutionF=full;
run;
 
data Unadj;
	length model $80.;
	set Unadj;
	model='Unadjusted';drop DF tValue Alpha stderr;
run;
data market;
	length model $80.;
	set market;
	model='Adjusted only for market characteristics';drop DF tValue Alpha stderr;
run;
data demog;
	length model $80.;
	set demog;
	model='Adjusted for demographics';drop DF tValue Alpha stderr;
run;
data full;
	length model $80.;
	set full;
	model='Fully adjusted';drop DF tValue Alpha stderr;
run;

data all;
set Unadj market demog full;
proc print;
run;

proc print data=all;where effect='MAP';run;

 
*2 year Lag Models;

data ldata;
set map.data;
cost=cost2011-cost2009; MAP=MAP2009-map2007;HCC=HCC2009; FFS=FFS2009;age=age2009;pop=pop2009;MHI=MHI2009;pov=pov2009; 
Physician=Physician2009;PrimaryCare=PrimaryCare2009;Specialty=Specialty2009;
hospbd=hospbd2009;whitepct=whitepct2009;blackpct=blackpct2009;hisppct=hisppct2009;otherpct=otherpct2009;time=1;year=1;output;

cost=cost2012-cost2010; MAP=MAP2010-map2008;HCC=HCC2010; FFS=FFS2010;age=age2010;pop=pop2010;MHI=MHI2010;pov=pov2010; 
Physician=Physician2010;PrimaryCare=PrimaryCare2010;Specialty=Specialty2010;
hospbd=hospbd2010;whitepct=whitepct2010;blackpct=blackpct2010;hisppct=hisppct2010;otherpct=otherpct2010;time=2;year=2;output;

cost=cost2013-cost2011; MAP=MAP2011-map2009;HCC=HCC2011; FFS=FFS2011;age=age2011;pop=pop2011;MHI=MHI2011;pov=pov2011; 
Physician=Physician2011;PrimaryCare=PrimaryCare2011;Specialty=Specialty2011;
hospbd=hospbd2011;whitepct=whitepct2011;blackpct=blackpct2011;hisppct=hisppct2011;otherpct=otherpct2011;time=3;year=3;output;
run;

*Un-adjusted;
proc mixed data=ldata empirical;
	class fips year;
	model cost=  map time /solution cl;
	repeated year/type=un subject=fips;
	ods output solutionF=unadj;
run;
*Adjusted only for market characteristics (hospital beds, primary care doctors, specialists);
proc mixed data=ldata empirical;
	class fips year;
	model cost=  map time primarycare specialty hospbd /solution cl;
	repeated year/type=un subject=fips;
	ods output solutionF=market;
run;
*Adjusted for demographics (% below federal poverty line, median household income, percent black, percent Hispanic, other percent, HCC, population, FFS, age);
proc mixed data=ldata empirical; 
	class fips year;
	model cost=  map time pov mhi blackpct hisppct otherpct hcc pop ffs age/solution cl;
	repeated year/type=un subject=fips;
	ods output solutionF=demog;
run;
* Fully adjusted;
proc mixed data=ldata empirical;
	class fips year;
	model cost=  map time primarycare specialty hospbd pov mhi blackpct hisppct otherpct hcc pop ffs age/solution cl;
	repeated year/type=un subject=fips;
	ods output solutionF=full;
run;
 
data Unadj;
	length model $80.;
	set Unadj;
	model='Unadjusted';drop DF tValue Alpha stderr;
run;
data market;
	length model $80.;
	set market;
	model='Adjusted only for market characteristics';drop DF tValue Alpha stderr;
run;
data demog;
	length model $80.;
	set demog;
	model='Adjusted for demographics';drop DF tValue Alpha stderr;
run;
data full;
	length model $80.;
	set full;
	model='Fully adjusted';drop DF tValue Alpha stderr;
run;

data all;
set Unadj market demog full;
proc print;
run;

proc print data=all;where effect='MAP';run;

  
