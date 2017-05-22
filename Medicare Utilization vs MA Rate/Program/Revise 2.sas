***********************************
Revision for Health Affair
Xiner Zhou
5/26/2016
***********************************;
libname MAP 'C:\data\Projects\Medicare Utilization vs MA Rate\data';


data data;
set map.data;
ave1=(mhi2007rank+mhi2008rank+mhi2009rank+ mhi2010rank+ mhi2011rank+ mhi2012rank+ mhi2013rank+mhi2014rank)/7;
if ave1-int(ave1)<0.5 then  MHIrank=int(ave1);
else if ave1-int(ave1)>=0.5 then  MHIrank=int(ave1)+1;

ave2=(physician2007rank+physician2008rank+physician2009rank+ physician2010rank+ physician2011rank+ physician2012rank+ physician2013rank+ physician2014rank)/7;
if ave2-int(ave2)<0.5 then  physicianrank=int(ave2);
else if ave2-int(ave2)>=0.5 then  physicianrank=int(ave2)+1;
 

ave3=(PrimaryCare2007rank+PrimaryCare2008rank+PrimaryCare2009rank+PrimaryCare2010rank+PrimaryCare2011rank+PrimaryCare2012rank+PrimaryCare2013rank+PrimaryCare2014rank)/7;
if ave3-int(ave3)<0.5 then  PCPrank=int(ave3);
else if ave3-int(ave3)>=0.5 then  PCPrank=int(ave3)+1;

ave4=(hospbd2007rank+hospbd2008rank+hospbd2009rank+hospbd2010rank+hospbd2011rank+hospbd2012rank+hospbd2013rank+hospbd2014rank)/7;
if ave4-int(ave4)<0.5 then  hospbdrank=int(ave4);
else if ave4-int(ave4)>=0.5 then  hospbdrank=int(ave4)+1;

ave4=(specialty2007rank+specialty2008rank+specialty2009rank+specialty2010rank+specialty2011rank+specialty2012rank+specialty2013rank+specialty2014rank)/7;
if ave4-int(ave4)<0.5 then  specialtyrank=int(ave4);
else if ave4-int(ave4)>=0.5 then  specialtyrank=int(ave4)+1;

drop ave1 ave2 ave3 ave4 ave5;

map2007rank=map2007rank+1;
map2007rank1=map2007rank1+1;
MHIrank=MHIrank+1;
PhysicianRank=PhysicianRank+1;
PCPrank=PCPrank+1;
hospbdrank=hospbdrank+1;
specialtyrank=specialtyrank+1;

 
proc freq ;tables map2007rank mhirank physicianrank PCPrank hospbdrank  /missing;
run;


data ldata;
set data;
map=map2007/10;Year=2007;PCP=PrimaryCare2007;specialty=specialty2007;hospbd=hospbd2007;pov=pov2007;mhi=mhi2007;blackpct=blackpct2007;hisppct=hisppct2007;otherpct=otherpct2007;hcc=hcc2007; age=age2007;payrate=payrate2007;output;
map=map2008/10;Year=2008;PCP=PrimaryCare2008;specialty=specialty2008;hospbd=hospbd2008;pov=pov2008;mhi=mhi2008;blackpct=blackpct2008;hisppct=hisppct2008;otherpct=otherpct2008;hcc=hcc2008; age=age2008;payrate=payrate2008;output;
map=map2009/10;Year=2009;PCP=PrimaryCare2009;specialty=specialty2009;hospbd=hospbd2009;pov=pov2009;mhi=mhi2009;blackpct=blackpct2009;hisppct=hisppct2009;otherpct=otherpct2009;hcc=hcc2009; age=age2009;payrate=payrate2009;output;
map=map2010/10;Year=2010;PCP=PrimaryCare2010;specialty=specialty2010;hospbd=hospbd2010;pov=pov2010;mhi=mhi2010;blackpct=blackpct2010;hisppct=hisppct2010;otherpct=otherpct2010;hcc=hcc2010; age=age2010;payrate=payrate2010;output;
map=map2011/10;Year=2011;PCP=PrimaryCare2011;specialty=specialty2011;hospbd=hospbd2011;pov=pov2011;mhi=mhi2011;blackpct=blackpct2011;hisppct=hisppct2011;otherpct=otherpct2011;hcc=hcc2011; age=age2011;payrate=payrate2011;output;
map=map2012/10;Year=2012;PCP=PrimaryCare2012;specialty=specialty2012;hospbd=hospbd2012;pov=pov2012;mhi=mhi2012;blackpct=blackpct2012;hisppct=hisppct2012;otherpct=otherpct2012;hcc=hcc2012; age=age2012;payrate=payrate2012;output;
map=map2013/10;Year=2013;PCP=PrimaryCare2013;specialty=specialty2013;hospbd=hospbd2013;pov=pov2013;mhi=mhi2013;blackpct=blackpct2013;hisppct=hisppct2013;otherpct=otherpct2013;hcc=hcc2013; age=age2013;payrate=payrate2013;output;
keep fips cost map map2007 Year PCP  specialty hospbd pov mhi blackpct hisppct otherpct hcc age payrate;
run;
 
**********************************************************************************
Main Model: County Random Effects Model
**********************************************************************************;
*Un-adjusted;
proc mixed data=ldata empirical;
	class fips ;  
	model hcc=  map year /solution cl;
	random intercept map /subject=fips;
	ods output solutionF=unadj;
run;
*Adjusted only for market characteristics (hospital beds, primary care doctors, specialists);
proc mixed data=ldata empirical;
	class fips ;   
	model hcc=  map year PCP specialty hospbd /solution cl;
	random intercept map /subject=fips;
	ods output solutionF=market;
run;
*Adjusted for demographics (% below federal poverty line, median household income, percent black, percent Hispanic, other percent, HCC, population, FFS, age);
proc mixed data=ldata empirical;
	class fips ;  
	model hcc=  map year pov mhi blackpct hisppct otherpct age payrate /solution cl;
	random intercept map /subject=fips;
	ods output solutionF=demog;
run;
* Fully adjusted;
proc mixed data=ldata empirical;
	class fips ;  
	model hcc=  map year PCP  specialty hospbd pov mhi blackpct hisppct otherpct age payrate /solution cl;
	random intercept map /subject=fips;
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
title "FFS Risk Score: County Random Effects Model";
run;

proc print data=all;where effect='map';run;
 
