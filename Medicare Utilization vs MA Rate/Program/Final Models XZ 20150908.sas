****************************************************************
Medicare Advantage Final Models
Xiner Zhou
10/14/2015
***************************************************************;
libname MAP 'C:\data\Projects\Medicare Utilization vs MA Rate\Data';

************************************************************************************
Create a State Flag for State Fixed Effects Model
************************************************************************************;
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

data data;
set data;
ave1=(mhi2007rank+mhi2008rank+mhi2009rank+ mhi2010rank+ mhi2011rank+ mhi2012rank+ mhi2013rank)/7;
if ave1-int(ave1)<0.5 then  MHIrank=int(ave1);
else if ave1-int(ave1)>=0.5 then  MHIrank=int(ave1)+1;

ave2=(physician2007rank+physician2008rank+physician2009rank+ physician2010rank+ physician2011rank+ physician2012rank+ physician2013rank)/7;
if ave2-int(ave2)<0.5 then  physicianrank=int(ave2);
else if ave2-int(ave2)>=0.5 then  physicianrank=int(ave2)+1;
 

ave3=(PrimaryCare2007rank+PrimaryCare2008rank+PrimaryCare2009rank+PrimaryCare2010rank+PrimaryCare2011rank+PrimaryCare2012rank+PrimaryCare2013rank)/7;
if ave3-int(ave3)<0.5 then  PCPrank=int(ave3);
else if ave3-int(ave3)>=0.5 then  PCPrank=int(ave3)+1;

ave4=(hospbd2007rank+hospbd2008rank+hospbd2009rank+hospbd2010rank+hospbd2011rank+hospbd2012rank+hospbd2013rank)/7;
if ave4-int(ave4)<0.5 then  hospbdrank=int(ave4);
else if ave4-int(ave4)>=0.5 then  hospbdrank=int(ave4)+1;

drop ave1 ave2 ave3 ave4;

map2007rank=map2007rank+1;
MHIrank=MHIrank+1;
PhysicianRank=PhysicianRank+1;
PCPrank=PCPrank+1;
hospbdrank=hospbdrank+1;

proc freq ;tables map2007rank mhirank physicianrank PCPrank hospbdrank/missing;
run;
 
/*
title "Distribution of Baseline MAP";
proc univariate data=data;
histogram MAP2007/ 
midpoints=2.5 5 7.5 10 12.5 15 17.5 20 22.5 25 27.5 30 32.5 35 37.5 40 42.5 45 47.5 50 52.5 55 57.5 
60 62.5  65 67.5 70 72.5 75 77.5 80 82.5 85 87.5 90 92.5 95 97.5 100;
run;
*/
************************************************************************************
Transport from wide to long format
************************************************************************************;
 
data ldata;
set data;

ave_MAP=(MAP2007+MAP2008+MAP2009+MAP2010+MAP2011+MAP2012+MAP2013)/7;

cost=cost2007; MAP=MAP2007;HCC=HCC2007; FFS=FFS2007;age=age2007;pop=pop2007;MHI=MHI2007; pov=pov2007; 
Physician=Physician2007;PCP=PrimaryCare2007;Specialty=Specialty2007;
hospbd=hospbd2007;whitepct=whitepct2007;blackpct=blackpct2007;hisppct=hisppct2007;otherpct=otherpct2007;
EmployRate=EmployRate2007;  Payrate=PayRate2007;Year=-3;YearSquared=9;output;

cost=cost2008; MAP=MAP2008;HCC=HCC2008; FFS=FFS2008;age=age2008;pop=pop2008;MHI=MHI2008; pov=pov2008; 
Physician=Physician2008; PCP=PrimaryCare2008;Specialty=Specialty2008;
hospbd=hospbd2008;whitepct=whitepct2008;blackpct=blackpct2008;hisppct=hisppct2008;otherpct=otherpct2008;
EmployRate=EmployRate2008;  Payrate=PayRate2008;Year=-2;YearSquared=4; output;

cost=cost2009;MAP=MAP2009;HCC=HCC2009; FFS=FFS2009;age=age2009;pop=pop2009;MHI=MHI2009; pov=pov2009; 
Physician=Physician2009;PCP=PrimaryCare2009;Specialty=Specialty2009;
hospbd=hospbd2009;whitepct=whitepct2009;blackpct=blackpct2009;hisppct=hisppct2009;otherpct=otherpct2009;
EmployRate=EmployRate2009;  Payrate=PayRate2009;Year=-1; YearSquared=1;output;

cost=cost2010;MAP=MAP2010;HCC=HCC2010; FFS=FFS2010;age=age2010;pop=pop2010;MHI=MHI2010; pov=pov2010; 
Physician=Physician2010;PCP=PrimaryCare2010;Specialty=Specialty2010;
hospbd=hospbd2010;whitepct=whitepct2010;blackpct=blackpct2010;hisppct=hisppct2010;otherpct=otherpct2010;
EmployRate=EmployRate2010; Payrate=PayRate2010;Year=0;YearSquared=0; output;

cost=cost2011;MAP=MAP2011;HCC=HCC2011; FFS=FFS2011;age=age2011;pop=pop2011;MHI=MHI2011; pov=pov2011; 
Physician=Physician2011;PCP=PrimaryCare2011;Specialty=Specialty2011;
hospbd=hospbd2011;whitepct=whitepct2011;blackpct=blackpct2011;hisppct=hisppct2011;otherpct=otherpct2011;
EmployRate=EmployRate2011;  Payrate=PayRate2011;Year=1;YearSquared=1; output;

cost=cost2012;MAP=MAP2012;HCC=HCC2012; FFS=FFS2012;age=age2012;pop=pop2012;MHI=MHI2012; pov=pov2012; 
Physician=Physician2012; PCP=PrimaryCare2012;Specialty=Specialty2012; 
hospbd=hospbd2012;whitepct=whitepct2012;blackpct=blackpct2012;hisppct=hisppct2012;otherpct=otherpct2012;
EmployRate=EmployRate2012;  Payrate=PayRate2012;Year=2; YearSquared=4;output;

cost=cost2013;MAP=MAP2013;HCC=HCC2013; FFS=FFS2013;age=age2013;pop=pop2013;MHI=MHI2013; pov=pov2013; 
Physician=Physician2013; PCP=PrimaryCare2013;Specialty=Specialty2013;
hospbd=hospbd2013;whitepct=whitepct2013;blackpct=blackpct2013;hisppct=hisppct2013;otherpct=otherpct2013;
EmployRate=EmployRate2013;  Payrate=PayRate2013;Year=3; YearSquared=9;output;


run;
 
/*
proc reg data=ldata;
model Physician=PCP  ;
run;
*/
 


**********************************************************************************
Main Model: County Random Effects Model
**********************************************************************************;
*Un-adjusted;
proc mixed data=ldata empirical;
	class fips ; *weight ffs;  where PCPrank=4;
	model cost=  map MAP2007 Year YearSquared/solution cl;
	random intercept MAP /subject=fips;
	ods output solutionF=unadj;
run;
*Adjusted only for market characteristics (hospital beds, primary care doctors, specialists);
proc mixed data=ldata empirical;
	class fips ;  * weight ffs;  where PCPrank=4;
	model cost=  map MAP2007 Year YearSquared  PCP specialty hospbd /solution cl;
	random intercept MAP/subject=fips;
	ods output solutionF=market;
run;
*Adjusted for demographics (% below federal poverty line, median household income, percent black, percent Hispanic, other percent, HCC, population, FFS, age);
proc mixed data=ldata empirical;
	class fips ; * weight ffs;  where PCPrank=4;
	model cost=  map MAP2007 Year YearSquared pov mhi blackpct hisppct otherpct hcc age payrate /solution cl;
	random intercept MAP/subject=fips;
	ods output solutionF=demog;
run;
* Fully adjusted;
proc mixed data=ldata empirical;
	class fips ; * weight ffs;  where PCPrank=4;
	model cost=  map MAP2007 Year YearSquared PCP  specialty hospbd pov mhi blackpct hisppct otherpct hcc age payrate /solution cl;
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
title "Main Model: County Random Effects Model";
run;

proc print data=all;where effect='MAP';run;

proc univariate data=ldata;
var PCP;
run;

**********************************************************************************
Stratefied  Main Model: County Random Effects Model
**********************************************************************************;
*Un-adjusted;
proc mixed data=ldata empirical;
	class fips ; *weight ffs;   where PCPrank=4;
	model cost=  map ave_map  Year YearSquared/solution cl;
	random intercept MAP /subject=fips;
	ods output solutionF=unadj;
run;
*Adjusted only for market characteristics (hospital beds, primary care doctors, specialists);
proc mixed data=ldata empirical;
	class fips ;  * weight ffs;   where PCPrank=4;
	model cost=  map ave_map Year YearSquared  specialty hospbd /solution cl;
	random intercept MAP/subject=fips;
	ods output solutionF=market;
run;
*Adjusted for demographics (% below federal poverty line, median household income, percent black, percent Hispanic, other percent, HCC, population, FFS, age);
proc mixed data=ldata empirical;
	class fips ; * weight ffs;   where PCPrank=4; 
	model cost=  map ave_map Year YearSquared pov mhi blackpct hisppct otherpct hcc age payrate /solution cl;
	random intercept MAP/subject=fips;
	ods output solutionF=demog;
run;
* Fully adjusted;
proc mixed data=ldata empirical;
	class fips   ; * weight ffs;  where PCPrank=4;   
	model cost=  map ave_map Year YearSquared  specialty hospbd pov mhi blackpct hisppct otherpct hcc age payrate /solution cl;
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
title "Main Model: County Random Effects Model";
run;

proc print data=all;where effect='MAP';run;

 




**************************************************************************************************** 
Sensitivity Analysis I: County Fixed Effects Model weighted by FFS population
****************************************************************************************************;
proc genmod data=ldata;
class fips;
weight ffs;
model cost=map Year YearSquared fips /dist=normal  cl;
ods output ParameterEstimates=unadj;
run;
proc genmod data=ldata;
class fips;
weight ffs;
model cost=map Year YearSquared fips Physician specialty hospbd /dist=normal cl ;
ods output ParameterEstimates=market;
run;
proc genmod data=ldata;
class fips;
weight ffs;
model cost=map Year YearSquared fips pov mhi blackpct hisppct otherpct hcc age payrate /dist=normal cl ;
ods output ParameterEstimates=demog;
run;
proc genmod data=ldata;
class fips;
weight ffs;
model cost=map Year YearSquared fips Physician specialty hospbd pov mhi blackpct hisppct otherpct hcc age payrate /dist=normal cl;
ods output ParameterEstimates=full;
run;
 
data Unadj;
	length model $80.;
	set Unadj;
	model='Unadjusted';if Parameter ne 'FIPS';keep model parameter estimate stderr LowerWaldCL UpperWaldCL ProbChiSq;
run;
data market;
	length model $80.;
	set market;
	model='Adjusted only for market characteristics';
if Parameter ne 'FIPS';keep model parameter estimate stderr LowerWaldCL UpperWaldCL ProbChiSq;
run;
data demog;
	length model $80.;
	set demog;
	model='Adjusted only for Demographics';
if Parameter ne 'FIPS';keep model parameter estimate stderr LowerWaldCL UpperWaldCL ProbChiSq;
run;
data full;
	length model $80.;
	set full;
	model='Fully adjusted';
if Parameter ne 'FIPS';keep model parameter estimate stderr LowerWaldCL UpperWaldCL ProbChiSq;
run;

data all;
set Unadj market demog full;
proc print;
title "Sensitivity Analysis I: County Fixed Effects Model weighted by FFS population";
run;
proc print data=all;where Parameter='MAP';run;

****************************************************************************************************
Sensitivity Analysis II: State Fixed Effects Model
****************************************************************************************************;
proc genmod data=ldata;
class stateflag;
weight ffs;
model cost=map Year YearSquared stateflag /dist=normal  cl;
ods output ParameterEstimates=unadj;
run;
proc genmod data=ldata;
class stateflag;
weight ffs;
model cost=map Year YearSquared stateflag Physician specialty hospbd /dist=normal cl ;
ods output ParameterEstimates=market;
run;
proc genmod data=ldata;
class stateflag;
weight ffs;
model cost=map Year YearSquared stateflag pov mhi blackpct hisppct otherpct hcc age payrate/dist=normal cl ;
ods output ParameterEstimates=demog;
run;
proc genmod data=ldata;
class stateflag;
weight ffs;
model cost=map Year YearSquared stateflag Physician specialty hospbd pov mhi blackpct hisppct otherpct hcc age payrate /dist=normal cl;
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
title "Sensitivity Analysis II: State Fixed Effects Model";
run;
proc print data=all;where Parameter='MAP';run;

***************************************************************************************************
Interaction of Baseline MAP with MAP
**************************************************************************************************;
* County Fixed: Stratified Analysis by baseline MAP Quantiles;
proc genmod data=ldata  ;
title "County Fixed: Interaction of Baseline MAP with MAP";
class fips map2007rank;
weight ffs;
model cost=map map2007rank map*map2007rank Year YearSquared fips Physician specialty hospbd pov mhi blackpct hisppct otherpct hcc age payrate /dist=normal cl type3;
	estimate "Baseline (2007) MAP Q1" map 1 map*map2007rank 1 0 0 0;
	estimate "Baseline (2007) MAP Q2" map 1 map*map2007rank 0 1 0 0;
	estimate "Baseline (2007) MAP Q3" map 1 map*map2007rank 0 0 1 0;
	estimate "Baseline (2007) MAP Q4" map 1 map*map2007rank 0 0 0 0;
	ods output ParameterEstimates=inter1;
	ods output Estimates=Est1;
	ods output type3=typ31;
run;
proc print data=inter1;where parameter ne 'FIPS';run;
proc print data=Est1;run;
proc print data=typ31;run;


* County Random: Stratified Analysis by baseline MAP Quantiles;
proc mixed data=ldata empirical;
    where map2007rank in (1,2,3,4);
    title "County Random:Interaction of Baseline MAP with MAP";
	class fips map2007rank ; 
	model cost=  map  map2007rank map*map2007rank  Year YearSquared Physician specialty hospbd pov mhi blackpct hisppct otherpct hcc age payrate/ solution cl;
	random intercept MAP /subject=fips;
	ods output solutionF=baseMAP;
	estimate "Baseline (2007) MAP Q1" map 1 map*map2007rank 1 0 0 0;
	estimate "Baseline (2007) MAP Q2" map 1 map*map2007rank 0 1 0 0;
	estimate "Baseline (2007) MAP Q3" map 1 map*map2007rank 0 0 1 0;
	estimate "Baseline (2007) MAP Q4" map 1 map*map2007rank 0 0 0 1;
run;



* State Fixed: Stratified Analysis by baseline MAP Quantiles;
proc genmod data=ldata  ;
title "State Fixed: Interaction of Baseline MAP with MAP";
class stateflag map2007rank;
weight ffs;
model cost=map map2007rank map*map2007rank Year YearSquared stateflag Physician specialty hospbd pov mhi blackpct hisppct otherpct hcc age payrate /dist=normal cl type3;
	estimate "Baseline (2007) MAP Q1" map 1 map*map2007rank 1 0 0 0;
	estimate "Baseline (2007) MAP Q2" map 1 map*map2007rank 0 1 0 0;
	estimate "Baseline (2007) MAP Q3" map 1 map*map2007rank 0 0 1 0;
	estimate "Baseline (2007) MAP Q4" map 1 map*map2007rank 0 0 0 0;
	ods output ParameterEstimates=inter1;
	ods output Estimates=Est1;
	ods output type3=typ31;
run;
proc print data=inter1;where parameter ne 'stateflag';run;
proc print data=Est1;run;
proc print data=type31;run;

***************************************************************************************************
Interaction of Median HouseIncome with MAP
**************************************************************************************************;
* County Fixed: Stratified Analysis by MHI Quantiles;
proc genmod data=ldata;
title "County Fixed: Interaction of MedianHouseIncome with MAP";
weight ffs;
class fips MHIrank; 
	model cost=  map MHIrank map*MHIrank Year YearSquared fips Physician specialty hospbd pov blackpct hisppct otherpct hcc age payrate /dist=normal cl type3;
	estimate "MHI Q1" map 1 map*MHIrank 1 0 0 0 ;
	estimate "MHI Q2" map 1 map*MHIrank 0 1 0 0 ;
	estimate "MHI Q3" map 1 map*MHIrank 0 0 1 0 ;
	estimate "MHI Q4" map 1 map*MHIrank 0 0 0 0 ;
	ods output ParameterEstimates=inter2;
	ods output Estimates=Est2;
	ods output type3=type32;
run;
proc print data=inter2;where parameter ne 'FIPS';run;
proc print data=Est2;run;
proc print data=type32;run;

* County Random: Stratified Analysis by MHI Quantiles;
proc mixed data=ldata empirical;
    title "Interaction of MedianHouseIncome with MAP";where MHIrank in (1,2,3,4);
	class fips MHIrank; 
	model cost=  map  MHIrank map*MHIrank  Year YearSquared Physician specialty hospbd pov blackpct hisppct otherpct hcc age payrate /solution cl;
	random intercept map /subject=fips;
	estimate "MHI Q1(Lowest Income)" map 1 map*MHIrank 1 0 0 0 ;
	estimate "MHI Q2" map 1 map*MHIrank 0 1 0 0 ;
	estimate "MHI Q3" map 1 map*MHIrank 0 0 1 0 ;
	estimate "MHI Q4(Highest Income)" map 1 map*MHIrank 0 0 0 1 ;
run;

* State Fixed: Stratified Analysis by MHI Quantiles;
proc genmod data=ldata;
title "State Fixed: Interaction of MedianHouseIncome with MAP";
weight ffs;
class stateflag MHIrank; 
	model cost=  map MHIrank map*MHIrank Year YearSquared stateflag Physician specialty hospbd pov blackpct hisppct otherpct hcc age payrate /dist=normal cl type3;
	estimate "MHI Q1" map 1 map*MHIrank 1 0 0 0 ;
	estimate "MHI Q2" map 1 map*MHIrank 0 1 0 0 ;
	estimate "MHI Q3" map 1 map*MHIrank 0 0 1 0 ;
	estimate "MHI Q4" map 1 map*MHIrank 0 0 0 0 ;
	ods output ParameterEstimates=inter2;
	ods output Estimates=Est2;
	ods output type3=type32;
run;
proc print data=inter2;where parameter ne 'stateflag';run;
proc print data=Est2;run;
proc print data=type32;run;
 
***************************************************************************************************
Interaction of Total Physician with MAP
**************************************************************************************************;
* State Fixed: SStratified Analysis by PCP Quartiles;
proc genmod data=ldata;
title "County Fixed: Interaction of Total Physician per 1,000 people with MAP";
weight ffs;
class fips Physicianrank; 
	model cost=  map Physicianrank map*Physicianrank Year YearSquared fips specialty hospbd pov mhi blackpct hisppct otherpct hcc age payrate /dist=normal cl type3;
    estimate "Total Physician Q1" map 1 map*Physicianrank 1 0 0 0;
	estimate "Total Physician Q2" map 1 map*Physicianrank 0 1 0 0;
	estimate "Total Physician Q3" map 1 map*Physicianrank 0 0 1 0;
	estimate "Total Physician Q4" map 1 map*Physicianrank 0 0 0 0;
    ods output ParameterEstimates=inter3;
	ods output Estimates=Est3;
	ods output type3=type33;
run;
proc print data=inter3;where parameter ne 'FIPS';run;
proc print data=Est3;run;
proc print data=type33;run;


* County Random: Stratified Analysis by PCP Quartiles;
proc mixed data=ldata empirical;
    title "Interaction of Total Physician per 1,000 people with MAP";where Physicianrank in (1,2,3,4);
	class fips Physicianrank; 
	model cost=  map   Physicianrank map*Physicianrank Year YearSquared specialty hospbd pov mhi blackpct hisppct otherpct hcc age payrate /solution cl;
	random intercept MAP /subject=fips;
	ods output solutionF=baseMAP;
	estimate "Total Physician Q1" map 1 map*Physicianrank 1 0 0 0;
	estimate "Total Physician Q2" map 1 map*Physicianrank 0 1 0 0;
	estimate "Total Physician Q3" map 1 map*Physicianrank 0 0 1 0;
	estimate "Total Physician Q4" map 1 map*Physicianrank 0 0 0 1;
run;

* State Fixed: SStratified Analysis by PCP Quartiles;
proc genmod data=ldata;
title "State Fixed: Interaction of Total Physician per 1,000 people with MAP";
weight ffs;
class stateflag Physicianrank; 
	model cost=  map Physicianrank map*Physicianrank Year YearSquared stateflag specialty hospbd pov mhi blackpct hisppct otherpct hcc age payrate /dist=normal cl type3;
    estimate "Total Physician Q1" map 1 map*Physicianrank 1 0 0 0;
	estimate "Total Physician Q2" map 1 map*Physicianrank 0 1 0 0;
	estimate "Total Physician Q3" map 1 map*Physicianrank 0 0 1 0;
	estimate "Total Physician Q4" map 1 map*Physicianrank 0 0 0 0;
    ods output ParameterEstimates=inter3;
	ods output Estimates=Est3;
	ods output type3=type33;
run;
proc print data=inter3;where parameter ne 'stateflag';run;
proc print data=Est3;run;
proc print data=type33;run;

******************************************************************************************************
1-Year Lag Model
******************************************************************************************************;
data ldata;
set data;
cost=cost2009-cost2008; MAP=MAP2008-map2007;HCC=HCC2008; FFS=FFS2008;age=age2008;pop=pop2008;MHI=MHI2008;pov=pov2008; 
Physician=Physician2008;PCP=PrimaryCare2008;Specialty=Specialty2008;
hospbd=hospbd2008;whitepct=whitepct2008;blackpct=blackpct2008;hisppct=hisppct2008;otherpct=otherpct2008;PayRate=PayRate2008;time=1;year=1;output;

cost=cost2010-cost2009; MAP=MAP2009-map2008;HCC=HCC2009; FFS=FFS2009;age=age2009;pop=pop2009;MHI=MHI2009;pov=pov2009; 
Physician=Physician2009;PCP=PrimaryCare2009;Specialty=Specialty2009;
hospbd=hospbd2009;whitepct=whitepct2009;blackpct=blackpct2009;hisppct=hisppct2009;otherpct=otherpct2009;PayRate=PayRate2009;time=2;year=2;output;

cost=cost2011-cost2010; MAP=MAP2010-map2009;HCC=HCC2010; FFS=FFS2010;age=age2010;pop=pop2010;MHI=MHI2010;pov=pov2010; 
Physician=Physician2010;PCP=PrimaryCare2010;Specialty=Specialty2010;
hospbd=hospbd2010;whitepct=whitepct2010;blackpct=blackpct2010;hisppct=hisppct2010;otherpct=otherpct2010;PayRate=PayRate2010;time=3;year=3;output;

cost=cost2012-cost2011; MAP=MAP2011-map2010;HCC=HCC2011; FFS=FFS2011;age=age2011;pop=pop2011;MHI=MHI2011;pov=pov2011; 
Physician=Physician2011;PCP=PrimaryCare2011;Specialty=Specialty2011;
hospbd=hospbd2011;whitepct=whitepct2011;blackpct=blackpct2011;hisppct=hisppct2011;otherpct=otherpct2011;PayRate=PayRate2011;time=4;year=4;output;

cost=cost2013-cost2012; MAP=MAP2012-map2011;HCC=HCC2012; FFS=FFS2012;age=age2012;pop=pop2012;MHI=MHI2012;pov=pov2012; 
Physician=Physician2012;PCP=PrimaryCare2012;Specialty=Specialty2012;
hospbd=hospbd2012;whitepct=whitepct2012;blackpct=blackpct2012;hisppct=hisppct2012;otherpct=otherpct2012;PayRate=PayRate2012;time=5;year=5;output;

run;
 

*Un-adjusted;
proc mixed data=ldata empirical;
	class fips year;   where hospbdrank=4;
	model cost=  map time /solution cl;
	random intercept /subject=fips;
	*repeated year/type=un subject=fips;
	ods output solutionF=unadj;
run;
*Adjusted only for market characteristics (hospital beds, primary care doctors, specialists);
proc mixed data=ldata empirical;
	class fips year;   where hospbdrank=4;
	model cost=  map time  PCP specialty /solution cl;
	random intercept /subject=fips;
	*repeated year/type=un subject=fips;
	ods output solutionF=market;
run;
*Adjusted for demographics (% below federal poverty line, median household income, percent black, percent Hispanic, other percent, HCC, population, FFS, age);
proc mixed data=ldata empirical; 
	class fips year; where hospbdrank=4;
	model cost=  map time pov mhi blackpct hisppct otherpct hcc  age PayRate/solution cl;
	random intercept  /subject=fips;
	*repeated year/type=un subject=fips;
	ods output solutionF=demog;
run;
* Fully adjusted;
proc mixed data=ldata empirical;
	class fips year;where hospbdrank=4;
	model cost=  map time PCP specialty   pov mhi blackpct hisppct otherpct hcc  age PayRate /solution cl;
	random intercept /subject=fips;
	*repeated year/type=un subject=fips;
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
title "1-Year Lag Model";
run;
proc print data=all;where effect='MAP';run;

*County fixed;
proc genmod data=ldata;
class fips;
weight ffs;
model cost=map time fips /dist=normal  cl;
ods output ParameterEstimates=unadj;
run;
proc genmod data=ldata;
class fips;
weight ffs;
model cost=map time fips Physician specialty hospbd /dist=normal cl ;
ods output ParameterEstimates=market;
run;
proc genmod data=ldata;
class fips;
weight ffs;
model cost=map time fips pov mhi blackpct hisppct otherpct hcc age payrate /dist=normal cl ;
ods output ParameterEstimates=demog;
run;
proc genmod data=ldata;
class fips;
weight ffs;
model cost=map time fips Physician specialty hospbd pov mhi blackpct hisppct otherpct hcc age payrate /dist=normal cl;
ods output ParameterEstimates=full;
run;
 
data Unadj;
	length model $80.;
	set Unadj;
	model='Unadjusted';if Parameter ne 'FIPS';keep model parameter estimate stderr LowerWaldCL UpperWaldCL ProbChiSq;
run;
data market;
	length model $80.;
	set market;
	model='Adjusted only for market characteristics';
if Parameter ne 'FIPS';keep model parameter estimate stderr LowerWaldCL UpperWaldCL ProbChiSq;
run;
data demog;
	length model $80.;
	set demog;
	model='Adjusted only for Demographics';
if Parameter ne 'FIPS';keep model parameter estimate stderr LowerWaldCL UpperWaldCL ProbChiSq;
run;
data full;
	length model $80.;
	set full;
	model='Fully adjusted';
if Parameter ne 'FIPS';keep model parameter estimate stderr LowerWaldCL UpperWaldCL ProbChiSq;
run;

data all;
set Unadj market demog full;
proc print;
title "1-Year Lag Model: County Fixed Effects Model weighted by FFS population";
run;
proc print data=all;where Parameter='MAP';run;

******************************************************************************************************
2-Year Lag Model
******************************************************************************************************;
data ldata;
set  data;
cost=cost2010-cost2008; MAP=MAP2008-map2007;HCC=HCC2008; FFS=FFS2008;age=age2008;pop=pop2008;MHI=MHI2008;pov=pov2008; 
Physician=Physician2008;PCP=PrimaryCare2008;Specialty=Specialty2008;
hospbd=hospbd2008;whitepct=whitepct2008;blackpct=blackpct2008;hisppct=hisppct2008;otherpct=otherpct2008;PayRate=PayRate2008;time=1;year=1;output;

cost=cost2011-cost2009; MAP=MAP2009-map2008;HCC=HCC2009; FFS=FFS2009;age=age2009;pop=pop2009;MHI=MHI2009;pov=pov2009; 
Physician=Physician2009;PCP=PrimaryCare2009;Specialty=Specialty2009;
hospbd=hospbd2009;whitepct=whitepct2009;blackpct=blackpct2009;hisppct=hisppct2009;otherpct=otherpct2009;PayRate=PayRate2009;time=2;year=2;output;

cost=cost2012-cost2010; MAP=MAP2010-map2009;HCC=HCC2010; FFS=FFS2010;age=age2010;pop=pop2010;MHI=MHI2010;pov=pov2010; 
Physician=Physician2010;PCP=PrimaryCare2010;Specialty=Specialty2010;
hospbd=hospbd2010;whitepct=whitepct2010;blackpct=blackpct2010;hisppct=hisppct2010;otherpct=otherpct2010;PayRate=PayRate2010;time=3;year=3;output;

cost=cost2013-cost2011; MAP=MAP2011-map2010;HCC=HCC2011; FFS=FFS2011;age=age2011;pop=pop2011;MHI=MHI2011;pov=pov2011; 
Physician=Physician2011;PCP=PrimaryCare2011;Specialty=Specialty2011;
hospbd=hospbd2011;whitepct=whitepct2011;blackpct=blackpct2011;hisppct=hisppct2011;otherpct=otherpct2011;PayRate=PayRate2011;time=4;year=4;output;

run;

data ldata;
set  data;
cost=cost2011-cost2009; MAP=MAP2009-map2007;HCC=HCC2008; FFS=FFS2008;age=age2008;pop=pop2008;MHI=MHI2008;pov=pov2008; 
Physician=Physician2008;PCP=PrimaryCare2008;Specialty=Specialty2008;
hospbd=hospbd2008;whitepct=whitepct2008;blackpct=blackpct2008;hisppct=hisppct2008;otherpct=otherpct2008;PayRate=PayRate2008;time=1;year=1;output;

cost=cost2012-cost2010; MAP=MAP2010-map2008;HCC=HCC2009; FFS=FFS2009;age=age2009;pop=pop2009;MHI=MHI2009;pov=pov2009; 
Physician=Physician2009;PCP=PrimaryCare2009;Specialty=Specialty2009;
hospbd=hospbd2009;whitepct=whitepct2009;blackpct=blackpct2009;hisppct=hisppct2009;otherpct=otherpct2009;PayRate=PayRate2009;time=2;year=2;output;

cost=cost2013-cost2011; MAP=MAP2011-map2009;HCC=HCC2010; FFS=FFS2010;age=age2010;pop=pop2010;MHI=MHI2010;pov=pov2010; 
Physician=Physician2010;PCP=PrimaryCare2010;Specialty=Specialty2010;
hospbd=hospbd2010;whitepct=whitepct2010;blackpct=blackpct2010;hisppct=hisppct2010;otherpct=otherpct2010;PayRate=PayRate2010;time=3;year=3;output;

run;
*Un-adjusted;
proc mixed data=ldata empirical;
	class fips year;where hospbdrank=4;
	model cost=  map time /solution cl;
	random intercept /subject=fips;
	*repeated year/type=un subject=fips;
	ods output solutionF=unadj;
run;
*Adjusted only for market characteristics (hospital beds, primary care doctors, specialists);
proc mixed data=ldata empirical;
	class fips year;where hospbdrank=4;
	model cost=  map time PCP specialty /solution cl;
	random intercept  /subject=fips;
	*repeated year/type=un subject=fips;
	ods output solutionF=market;
run;
*Adjusted for demographics (% below federal poverty line, median household income, percent black, percent Hispanic, other percent, HCC, population, FFS, age);
proc mixed data=ldata empirical; 
	class fips year;where hospbdrank=4;
	model cost= map time pov mhi blackpct hisppct otherpct hcc  age PayRate/solution cl;
	random intercept   /subject=fips;
	*repeated year/type=un subject=fips;
	ods output solutionF=demog;
run;
* Fully adjusted;
proc mixed data=ldata empirical;
	class fips year;where hospbdrank=4;
	model cost=  map time   PCP specialty pov mhi blackpct hisppct otherpct hcc  age PayRate /solution cl;
	random intercept  /subject=fips;
	*repeated year/type=un subject=fips;
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
title "2-Year Lag Model";
run;

proc print data=all;where effect='MAP';run;


data ldata;
set  data;
cost=cost2011-cost2009; MAP=MAP2009-map2007;HCC=HCC2008; FFS=FFS2008;age=age2008;pop=pop2008;MHI=MHI2008;pov=pov2008; 
Physician=Physician2008;PCP=PrimaryCare2008;Specialty=Specialty2008;
hospbd=hospbd2008;whitepct=whitepct2008;blackpct=blackpct2008;hisppct=hisppct2008;otherpct=otherpct2008;PayRate=PayRate2008;time=1;year=1;output;
 
cost=cost2013-cost2011; MAP=MAP2011-map2009;HCC=HCC2010; FFS=FFS2010;age=age2010;pop=pop2010;MHI=MHI2010;pov=pov2010; 
Physician=Physician2010;PCP=PrimaryCare2010;Specialty=Specialty2010;
hospbd=hospbd2010;whitepct=whitepct2010;blackpct=blackpct2010;hisppct=hisppct2010;otherpct=otherpct2010;PayRate=PayRate2010;time=3;year=3;output;

run;
*Un-adjusted;
proc mixed data=ldata empirical;
	class fips year;
	model cost=  map time /solution cl;
	random intercept /subject=fips;
	*repeated year/type=un subject=fips;
	ods output solutionF=unadj;
run;
*Adjusted only for market characteristics (hospital beds, primary care doctors, specialists);
proc mixed data=ldata empirical;
	class fips year;
	model cost=  map time Physician specialty hospbd /solution cl;
	random intercept  /subject=fips;
	*repeated year/type=un subject=fips;
	ods output solutionF=market;
run;
*Adjusted for demographics (% below federal poverty line, median household income, percent black, percent Hispanic, other percent, HCC, population, FFS, age);
proc mixed data=ldata empirical; 
	class fips year;
	model cost= map time pov mhi blackpct hisppct otherpct hcc  age PayRate/solution cl;
	random intercept   /subject=fips;
	*repeated year/type=un subject=fips;
	ods output solutionF=demog;
run;
* Fully adjusted;
proc mixed data=ldata empirical;
	class fips year;
	model cost=  map time Physician specialty hospbd pov mhi blackpct hisppct otherpct hcc  age PayRate /solution cl;
	random intercept  /subject=fips;
	*repeated year/type=un subject=fips;
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
title "2-Year Lag Model";
run;

proc print data=all;where effect='MAP';run;



*County fixed;
proc genmod data=ldata;
class fips;
weight ffs;
model cost=map time fips /dist=normal  cl;
ods output ParameterEstimates=unadj;
run;
proc genmod data=ldata;
class fips;
weight ffs;
model cost=map time fips Physician specialty hospbd /dist=normal cl ;
ods output ParameterEstimates=market;
run;
proc genmod data=ldata;
class fips;
weight ffs;
model cost=map time fips pov mhi blackpct hisppct otherpct hcc age payrate /dist=normal cl ;
ods output ParameterEstimates=demog;
run;
proc genmod data=ldata;
class fips;
weight ffs;
model cost=map time fips Physician specialty hospbd pov mhi blackpct hisppct otherpct hcc age payrate /dist=normal cl;
ods output ParameterEstimates=full;
run;
 
data Unadj;
	length model $80.;
	set Unadj;
	model='Unadjusted';if Parameter ne 'FIPS';keep model parameter estimate stderr LowerWaldCL UpperWaldCL ProbChiSq;
run;
data market;
	length model $80.;
	set market;
	model='Adjusted only for market characteristics';
if Parameter ne 'FIPS';keep model parameter estimate stderr LowerWaldCL UpperWaldCL ProbChiSq;
run;
data demog;
	length model $80.;
	set demog;
	model='Adjusted only for Demographics';
if Parameter ne 'FIPS';keep model parameter estimate stderr LowerWaldCL UpperWaldCL ProbChiSq;
run;
data full;
	length model $80.;
	set full;
	model='Fully adjusted';
if Parameter ne 'FIPS';keep model parameter estimate stderr LowerWaldCL UpperWaldCL ProbChiSq;
run;

data all;
set Unadj market demog full;
proc print;
title "2-Year Lag Model: County Fixed Effects Model weighted by FFS population";
run;
proc print data=all;where Parameter='MAP';run;
  
*********************************************************************
Characteristics Table 1
********************************************************************;
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
PayRate=mean(PayRate2007,PayRate2008,PayRate2009,PayRate2010,PayRate2011,PayRate2012,PayRate2013);
Physician=mean(Physician2007,Physician2008,Physician2009,Physician2010,Physician2011,Physician2012,Physician2013);
PrimaryCare=mean(PrimaryCare2007,PrimaryCare2008,PrimaryCare2009,PrimaryCare2010,PrimaryCare2011,PrimaryCare2012,PrimaryCare2013);
Specialty=mean(Specialty2007,Specialty2008,Specialty2009,Specialty2010,Specialty2011,Specialty2012,Specialty2013);
hospbd=mean(hospbd2007,hospbd2008,hospbd2009,hospbd2010,hospbd2011,hospbd2012,hospbd2013);

if mapdiff ne .;
if mapdiff<-5 then MAPGL=1;
else if -5<=mapdiff<=5 then MAPGL=2;
else if 5<mapdiff<=15 then MAPGL=3;
else if mapdiff>15 then MAPGL=4;
 

run;

proc rank data=temp1 out=temp2 group=4;
var mapdiff;
ranks mapdiffrank;
run;

proc freq data=temp2;
title "Table 1.1 Region";
tables region*MAPdiffRank/nocum norow nopercent  chisq;
run;
proc means data=temp2 min max;
title "Table 1.1 MAP Change Rankge";
class mapdiffrank;
var mapdiff;
run;

proc freq data=temp2;
title "Table 1.2 Region";
tables region*MAPGL/nocum norow nopercent  chisq;
run;
proc means data=temp2 min max;
title "Table 1.2 MAP Change Rankge";
class MAPGL;
var mapdiff;
run;

%macro byTable(byvar=);

%macro table(y=);

ods output "Estimates"=mean&y. "Type 3 Tests of Fixed Effects"=p&y.;
	proc mixed data=temp2;
		class &byvar.;
		model &y.=&byvar. /solution;
		estimate "&byvar. Q1" intercept 1 &byvar. 1 0 0 0;
		estimate "&byvar. Q2" intercept 1 &byvar. 0 1 0 0;
		estimate "&byvar. Q3" intercept 1 &byvar. 0 0 1 0;
		estimate "&byvar. Q4" intercept 1 &byvar. 0 0 0 1;
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
	proc mixed data=temp2;
		class &byvar.;
		weight FFS;
		model &y.=&byvar. /solution;
		estimate "&byvar. Q1" intercept 1 &byvar. 1 0 0 0;
		estimate "&byvar. Q2" intercept 1 &byvar. 0 1 0 0;
		estimate "&byvar. Q3" intercept 1 &byvar. 0 0 1 0;
		estimate "&byvar. Q4" intercept 1 &byvar. 0 0 0 1;
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
 %table1(y=Payrate);
%macro table2(y=);

ods output "Estimates"=mean&y. "Type 3 Tests of Fixed Effects"=p&y.;
	proc mixed data=temp2;
		class &byvar.;
		weight pop;
		model &y.=&byvar. /solution;
		estimate "&byvar. Q1" intercept 1 &byvar. 1 0 0 0;
		estimate "&byvar. Q2" intercept 1 &byvar. 0 1 0 0;
		estimate "&byvar. Q3" intercept 1 &byvar. 0 0 1 0;
		estimate "&byvar. Q4" intercept 1 &byvar. 0 0 0 1;
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
set mapdiff map2007 costdiff cost2007 hccdiff Physician Primarycare specialty hospbd PayRate pov mhi whitepct blackpct hisppct otherpct
 pop ffs age  ;
proc print;var effect &byvar._Q1 &byvar._Q2 &byvar._Q3 &byvar._Q4 probf;
run;

 
%mend byTable;
%byTable(byvar=MAPGL);

%byTable(byvar=MAPdiffRANK);





**********************************************************************
regression to answer what kinds of counties have high penetration 
at 2007 and 2013, and what kinds of counties have high growth from 2007 to 2013
***********************************************************************;
data data1;
set map.data;
if region=0 then region1="Northeast";
else if region=1 then region1="Midwest";
else if region=2 then region1="South";
else if region=3 then region1="West";
run;

%let yr=2007;
%let yr=2013;

*Continuous;
proc means data=data1 min q1 median mean q3 max;
var map&yr. Physician&yr. specialty&yr. hospbd&yr. pov&yr. mhi&yr. blackpct&yr. hisppct&yr. otherpct&yr. hcc&yr. age&yr. payrate&yr.;
run;
proc glm data= data1;
    class region1;
	model map&yr.= Physician&yr. specialty&yr. hospbd&yr. pov&yr. mhi&yr. blackpct&yr. hisppct&yr. otherpct&yr. hcc&yr. age&yr. payrate&yr. region1/solution ;
run;
* Quartiles;
proc rank data=data1 out=data2 group=4;
var  Physician&yr. specialty&yr. hospbd&yr. pov&yr. mhi&yr. blackpct&yr. hisppct&yr. otherpct&yr. hcc&yr. age&yr. payrate&yr.;
ranks  Physician&yr.rank specialty&yr.rank hospbd&yr.rank pov&yr.rank mhi&yr.rank blackpct&yr.rank hisppct&yr.rank otherpct&yr.rank hcc&yr.rank age&yr.rank payrate&yr.rank;
run;
proc glm data= data2 ;
    class  Physician&yr.rank specialty&yr.rank hospbd&yr.rank  
                   pov&yr.rank  mhi&yr.rank  blackpct&yr.rank hisppct&yr.rank otherpct&yr.rank hcc&yr.rank  age&yr.rank  payrate&yr.rank region1;
	model map&yr. = Physician&yr.rank specialty&yr.rank hospbd&yr.rank  
                   pov&yr.rank  mhi&yr.rank  blackpct&yr.rank hisppct&yr.rank otherpct&yr.rank hcc&yr.rank  age&yr.rank  payrate&yr.rank region1/solution ;
	title "LS-Means at &yr.";
 
	lsmeans Physician&yr.rank ;
	lsmeans specialty&yr.rank;
	lsmeans hospbd&yr.rank ;
	lsmeans pov&yr.rank;
	lsmeans mhi&yr.rank;
	lsmeans blackpct&yr.rank;
	lsmeans hisppct&yr.rank;
	lsmeans otherpct&yr.rank;
	lsmeans hcc&yr.rank;
	lsmeans age&yr.rank;
	lsmeans payrate&yr.rank;
	lsmeans region1;
run;

%macro table(var=);
proc means data=data2  ; 
class Physician&yr.rank;
var Physician&yr.;
output out=Physician min=min mean=mean max=max;
run;
%mend table;
%table(var=Physician);
%table(var=specialty );
%table(var=hospbd );
%table(var=pov );
%table(var=mhi );
%table(var=blackpct );
%table(var=hisppct );
%table(var=otherpct );
%table(var=hcc );
%table(var=age );
%table(var=payrate );
 


 
*MAP change;
data data1;
set map.data;
if region=0 then region1="Northeast";
else if region=1 then region1="Midwest";
else if region=2 then region1="South";
else if region=3 then region1="West";
mapchange=map2013-map2007;
run;

proc rank data=data1 out=data2 group=4;
var  Physician2007 specialty2007 hospbd2007 pov2007 mhi2007 blackpct2007 hisppct2007 otherpct2007 hcc2007 age2007 payrate2007 
     Physician2008 specialty2008 hospbd2008 pov2008 mhi2008 blackpct2008 hisppct2008 otherpct2008 hcc2008 age2008 payrate2008 
     Physician2009 specialty2009 hospbd2009 pov2009 mhi2009 blackpct2009 hisppct2009 otherpct2009 hcc2009 age2009 payrate2009 
     Physician2010 specialty2010 hospbd2010 pov2010 mhi2010 blackpct2010 hisppct2010 otherpct2010 hcc2010 age2010 payrate2010 
     Physician2011 specialty2011 hospbd2011 pov2011 mhi2011 blackpct2011 hisppct2011 otherpct2011 hcc2011 age2011 payrate2011
     Physician2012 specialty2012 hospbd2012 pov2012 mhi2012 blackpct2012 hisppct2012 otherpct2012 hcc2012 age2012 payrate2012
     Physician2013 specialty2013 hospbd2013 pov2013 mhi2013 blackpct2013 hisppct2013 otherpct2013 hcc2013 age2013 payrate2013 
;
ranks  
     Physician2007rank specialty2007rank hospbd2007rank pov2007rank mhi2007rank blackpct2007rank hisppct2007rank otherpct2007rank hcc2007rank age2007rank payrate2007rank 
     Physician2008rank specialty2008rank hospbd2008rank pov2008rank mhi2008rank blackpct2008rank hisppct2008rank otherpct2008rank hcc2008rank age2008rank payrate2008rank 
     Physician2009rank specialty2009rank hospbd2009rank pov2009rank mhi2009rank blackpct2009rank hisppct2009rank otherpct2009rank hcc2009rank age2009rank payrate2009rank 
     Physician2010rank specialty2010rank hospbd2010rank pov2010rank mhi2010rank blackpct2010rank hisppct2010rank otherpct2010rank hcc2010rank age2010rank payrate2010rank 
     Physician2011rank specialty2011rank hospbd2011rank pov2011rank mhi2011rank blackpct2011rank hisppct2011rank otherpct2011rank hcc2011rank age2011rank payrate2011rank
     Physician2012rank specialty2012rank hospbd2012rank pov2012rank mhi2012rank blackpct2012rank hisppct2012rank otherpct2012rank hcc2012rank age2012rank payrate2012rank
     Physician2013rank specialty2013rank hospbd2013rank pov2013rank mhi2013rank blackpct2013rank hisppct2013rank otherpct2013rank hcc2013rank age2013rank payrate2013rank ;
run;

%macro rank(var=);
ave =(&var.2007rank+&var.2008rank+&var.2009rank+ &var.2010rank+ &var.2011rank+ &var.2012rank+ &var.2013rank)/7;
if ave -int(ave)<0.5 then  &var.rank=int(ave );
else if ave -int(ave)>=0.5 then  &var.rank=int(ave)+1;
drop ave;
%mend rank;

data data3;
set data2;
%rank(var=Physician);
%rank(var=specialty);
%rank(var=hospbd);
%rank(var=pov);
%rank(var=mhi);
%rank(var=blackpct);
%rank(var=hisppct);
%rank(var=otherpct);
%rank(var=hcc);
%rank(var=age);
%rank(var=payrate);
run;

 proc glm data= data3 ;
    class  Physicianrank specialtyrank hospbdrank  
           povrank  mhirank  blackpctrank hisppctrank otherpctrank hccrank  agerank  payraterank region1;
	model mapchange = Physicianrank specialtyrank hospbdrank  
           povrank  mhirank  blackpctrank hisppctrank otherpctrank hccrank  agerank  payraterank region1/solution ;
	title "LS-Means MAP Change from 2007 to 2013";
	lsmeans Physicianrank ;
	lsmeans specialtyrank;
	lsmeans hospbdrank ;
	lsmeans povrank;
	lsmeans mhirank;
	lsmeans blackpctrank;
	lsmeans hisppctrank;
	lsmeans otherpctrank;
	lsmeans hccrank;
	lsmeans agerank;
	lsmeans payraterank;
	lsmeans region1;
run;




***************************************************************************************
color maps
***************************************************************************************;
data temp;
set map.data;
keep state county fips map2007 map2013;
proc means min q1 median q3 max;
var map2007 map2013;
run;

data temp1;
set temp;
/*
if map2007 ne . and map2007<=5.6900000 then map2007rank=1;
else if map2007>5.6900000 and map2007<=10.3000000 then map2007rank=2;
else if map2007>10.3000000 and map2007<=17.1200000 then map2007rank=3;
else if map2007>17.1200000  then map2007rank=4;

if map2013 ne . and map2013<=5.6900000 then map2013rank=1;
else if map2013>5.6900000 and map2013<=10.3000000 then map2013rank=2;
else if map2013>10.3000000 and map2013<=17.1200000 then map2013rank=3;
else if map2013>17.1200000  then map2013rank=4;
*/
 
length map2007rank $30. map2013rank $30.;
if map2007 ne . and map2007<=5.6900000 then map2007rank="Q1 (0.58%, 5.69%)";
else if map2007>5.6900000 and map2007<=10.3000000 then map2007rank="Q2 (5.69%, 10.3%)";
else if map2007>10.3000000 and map2007<=17.1200000 then map2007rank="Q3 (10.3%, 17.12%)";
else if map2007>17.1200000  then map2007rank="Q4 (17.12%, 64.98%)";

if map2013 ne . and map2013<=5.6900000 then map2013rank="Q1 (0.72%, 5.69%)";
else if map2013>5.6900000 and map2013<=10.3000000 then map2013rank="Q2 (5.69%, 10.3%)";
else if map2013>10.3000000 and map2013<=17.1200000 then map2013rank="Q3 (10.3%, 17.12%)";
else if map2013>17.1200000  then map2013rank="Q4 (17.12%, 68.7%)";
 
proc print;
where map2013rank ne '';var county state map2013rank;
run;









***********************************************************************************
Stratified Models: Baseline MAP, Physician, Income
***********************************************************************************;
%macro model(byvar=, covar=);
%do i=1 %to 4;
proc mixed data=ldata empirical;
    where &byvar.=&i. ;
	class fips ;  
	model cost=  map ave_MAP Year YearSquared Physician specialty hospbd pov mhi blackpct hisppct otherpct hcc age payrate /solution cl;
	random intercept MAP/subject=fips;
	ods output solutionF=&byvar.&i. ;
run;
data &byvar.&i.;
	length model $30.;
	set &byvar.&i.;
	model=" &byvar. &i. ";drop DF tValue Alpha  ;
run;
%end;

data all;
set &byvar.1 &byvar.2 &byvar.3 &byvar.4;
proc print;
title "Stratified by Baseline MAP";
run;
proc print data=all;where effect='MAP';run;

%mend model;
%model(byvar=map2007rank,covar=map ave_MAP Year YearSquared Physician specialty hospbd pov mhi blackpct hisppct otherpct hcc age payrate);
%model(byvar=MHIrank,covar=map ave_MAP Year YearSquared Physician specialty hospbd pov blackpct hisppct otherpct hcc age payrate);
%model(byvar=Physicianrank,covar=map ave_MAP Year YearSquared specialty hospbd pov mhi blackpct hisppct otherpct hcc age payrate);



