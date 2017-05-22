*****************************
Lag Model
Xiner Zhou
5/13/2015
*****************************;

libname MAP 'C:\data\Projects\Medicare Utilization vs MA Rate';
 

data ldata;
set map.data;
cost=cost2011-cost2009; MAP=MAP2009-map2007;HCC=HCC2009; FFS=FFS2009;age=age2009;pop=pop2009;MHI=MHI2009;pov=pov2009; 
Physician=Physician2009;PrimaryCare=PrimaryCare2009;Specialty=Specialty2009;
hospbd=hospbd2009;whitepct=whitepct2009;blackpct=blackpct2009;hisppct=hisppct2009;otherpct=otherpct2009;time=1;output;

cost=cost2012-cost2010; MAP=MAP2010-map2008;HCC=HCC2010; FFS=FFS2010;age=age2010;pop=pop2010;MHI=MHI2010;pov=pov2010; 
Physician=Physician2010;PrimaryCare=PrimaryCare2010;Specialty=Specialty2010;
hospbd=hospbd2010;whitepct=whitepct2010;blackpct=blackpct2010;hisppct=hisppct2010;otherpct=otherpct2010;time=2;output;

cost=cost2013-cost2011; MAP=MAP2011-map2009;HCC=HCC2011; FFS=FFS2011;age=age2011;pop=pop2011;MHI=MHI2011;pov=pov2011; 
Physician=Physician2011;PrimaryCare=PrimaryCare2011;Specialty=Specialty2011;
hospbd=hospbd2011;whitepct=whitepct2011;blackpct=blackpct2011;hisppct=hisppct2011;otherpct=otherpct2011;time=3;output;
run;

*Un-adjusted;
proc mixed data=ldata empirical;
	class fips ;
	model cost=  map time /solution cl;
	random intercept /subject=fips;
	ods output solutionF=unadj;
run;
*Adjusted only for market characteristics (hospital beds, primary care doctors, specialists);
proc mixed data=ldata empirical;
	class fips ;
	model cost=  map  primarycare specialty hospbd /solution cl;
	random intercept  /subject=fips;
	ods output solutionF=market;
run;
*Adjusted for demographics (% below federal poverty line, median household income, percent black, percent Hispanic, other percent, HCC, population, FFS, age);
proc mixed data=ldata empirical;
	class fips;
	model cost=  map  pov mhi blackpct hisppct otherpct hcc pop ffs age/solution cl;
	random intercept  /subject=fips;
	ods output solutionF=demog;
run;
* Fully adjusted;
proc mixed data=ldata empirical;
	class fips ;
	model cost=  map  primarycare specialty hospbd pov mhi blackpct hisppct otherpct hcc pop ffs age/solution cl;
	random intercept /subject=fips;
	ods output solutionF=full;
run;
 
