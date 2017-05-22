***********************************
Revision for Health Affair
Xiner Zhou
2/22/2016
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

newcost2007=cost2007-DMEcost2007-HHcost2007;
newcost2008=cost2008-DMEcost2008-HHcost2008;
newcost2009=cost2009-DMEcost2009-HHcost2009;
newcost2010=cost2010-DMEcost2010-HHcost2010;
newcost2011=cost2011-DMEcost2011-HHcost2011;
newcost2012=cost2012-DMEcost2012-HHcost2012;
newcost2013=cost2013-DMEcost2013-HHcost2013;
newcost2014=cost2014-DMEcost2014-HHcost2014;

if hmo_penetration_07>0 then HMO2007=1;else HMO2007=0 ;label HMO2007="Presence of HMO at 2007 (Baseline)";
proc freq ;tables map2007rank mhirank physicianrank PCPrank hospbdrank/missing;
run;

**********************
Hi Xiner,

After meeting with Ashish, Jose and I (unfortunately) have a few more analytics that we need for the Medicare Advantage revision. CMS has published a new version of the spreadsheet that this entire analysis is based off of that includes 2014 data, and Ashish would like us to pull that data in. The file can be downloaded at: https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Geographic-Variation/Downloads/State_County_Table_All.zip  

So, can you re-do all the 2-year lagged models using 2014 data as well? This will involve adding a data point for each county, each will have the following predictors and outcomes:

Predictor Variable	Outcome Variable
2009-2007 MA penetration	2011-2009 FFS costs
2010-2008 MA penetration	2012-2010 FFS costs
2011-2009 MA penetration	2013-2011 FFS costs
2012-2010 MA penetration	2014-2012 FFS costs

This means we need the following models re-run including the 2014 data:
?         Main 2-year lagged model, stratified by quartile of baseline MAP
?         Main 2-year lagged model, stratified by quartile of total physicians
?         Main 2-year lagged model, stratified by quartile of primary care physicians
?         Main 2-year lagged model, stratified by quartile of hospital beds
?         Main 2-year lagged model, stratified by quartile of baseline MAP (exclude Minnesota)
?         Main 2-year lagged model, stratified by quartile of baseline MAP (subtract standardized home health and DME from FFS per capita costs)
?         HMO 2-year lagged model (see below for new information)

Using the attached HMO penetration as the predictor variable:

Re-do our main (2-year lagged) model, with all counties included 
o   Stratify by baseline HMO penetration

Re-do our main (2-year lagged) model, excluding all counties in Minnesota (these counties have 5-digit FIPS codes that begin with Åg27)
o   Stratify by baseline HMO penetration

Re-do our main (2-year lagged) model, subtracting risk-adjusted standardized durable medical equipment and home health expenditures from FFS standardized risk adjusted per capita costs (using the ratio of standardized/risk-adjusted standardized costs as a way to get risk-adjusted numbers for DME and home health)
o   Stratify by baseline HMO penetration


We would also like to slightly change how we do the HMO as a predictor model. 
IÅfm attaching a new file that includes 2014 data for HMO penetration. 
Rather than stratifying by baseline MAP as we had you do for the last version, can you stratify by baseline (2007) HMO presence? 
In other words, can you stratify into 2 groups (no HMO penetration in 2007 and some HMO penetration in 2007) 
and evaluate the effect of our 2?year lagged model separately for each group?
*************************;

%macro model(title, dvar,effect, M, Strat, svar, scat, i);
data ldata;
set  data;
%if &M.=1 %then %do;
	if state not in ('Minnesota'); 
%end;
 

%if &Strat.=1 %then %do;
	if &svar.=&scat.;
%end;

cost=cost2011-cost2009; newcost=newcost2011-newcost2009; MAP=(MAP2009-map2007)/10; HMO=(HMO_penetration_09-HMO_penetration_07)/10;
HCC=(HCC2007+HCC2008+HCC2009+HCC2010+HCC2011)/5; 
FFS=(FFS2007+FFS2008+FFS2009+FFS2010+FFS2011)/5;
age=(age2007+age2008+age2009+age2010+age2011)/5;
pop=(pop2007+pop2008+pop2009+pop2010+pop2011)/5;
MHI=(MHI2007+MHI2008+MHI2009+MHI2010+MHI2011)/5;
pov=(pov2007+pov2008+pov2009+pov2010+pov2011)/5; 
Physician=(Physician2007+Physician2008+Physician2009+Physician2010+Physician2011)/5;
PCP=(PrimaryCare2007+PrimaryCare2008+PrimaryCare2009+PrimaryCare2010+PrimaryCare2011)/5;
Specialty=(Specialty2007+Specialty2008+Specialty2009+Specialty2010+Specialty2011)/5;
hospbd=(hospbd2007+hospbd2008+hospbd2009+hospbd2010+hospbd2011)/5;
whitepct=(whitepct2007+whitepct2008+whitepct2009+whitepct2010+whitepct2011)/5;
blackpct=(blackpct2007+blackpct2008+blackpct2009+blackpct2010+blackpct2011)/5;
hisppct=(hisppct2007+hisppct2008+hisppct2009+hisppct2010+hisppct2011)/5;
otherpct=(otherpct2007+otherpct2008+otherpct2009+otherpct2010+otherpct2011)/5;
PayRate=(PayRate2007+PayRate2008+PayRate2009+PayRate2010+PayRate2011)/5;
time=1;year=1;output;

cost=cost2012-cost2010; newcost=newcost2012-newcost2010; MAP=(MAP2010-map2008)/10;HMO=(HMO_penetration_10-HMO_penetration_08)/10;
HCC=(HCC2008+HCC2009+HCC2010+HCC2011+HCC2012)/5; 
FFS=(FFS2008+FFS2009+FFS2010+FFS2011+FFS2012)/5;
age=(age2008+age2009+age2010+age2011+age2012)/5;
pop=(pop2008+pop2009+pop2010+pop2011+pop2012)/5;
MHI=(MHI2008+MHI2009+MHI2010+MHI2011+MHI2012)/5;
pov=(pov2008+pov2009+pov2010+pov2011+pov2012)/5; 
Physician=(Physician2008+Physician2009+Physician2010+Physician2011+Physician2012)/5;
PCP=(PrimaryCare2008+PrimaryCare2009+PrimaryCare2010+PrimaryCare2011+PrimaryCare2012)/5;
Specialty=(Specialty2008+Specialty2009+Specialty2010+Specialty2011+Specialty2012)/5;
hospbd=(hospbd2008+hospbd2009+hospbd2010+hospbd2011+hospbd2012)/5;
whitepct=(whitepct2008+whitepct2009+whitepct2010+whitepct2011+whitepct2012)/5;
blackpct=(blackpct2008+blackpct2009+blackpct2010+blackpct2011+blackpct2012)/5;
hisppct=(hisppct2008+hisppct2009+hisppct2010+hisppct2011+hisppct2012)/5;
otherpct=(otherpct2008+otherpct2009+otherpct2010+otherpct2011+otherpct2012)/5;
PayRate=(PayRate2008+PayRate2009+PayRate2010+PayRate2011+PayRate2012)/5;
time=2;year=2;output;


cost=cost2013-cost2011; newcost=newcost2013-newcost2011; MAP=(MAP2011-map2009)/10;HMO=(HMO_penetration_11-HMO_penetration_09)/10;
HCC=(HCC2009+HCC2010+HCC2011+HCC2012+HCC2013)/5; 
FFS=(FFS2009+FFS2010+FFS2011+FFS2012+FFS2013)/5;
age=(age2009+age2010+age2011+age2012+age2013)/5;
pop=(pop2009+pop2010+pop2011+pop2012+pop2013)/5;
MHI=(MHI2009+MHI2010+MHI2011+MHI2012+MHI2013)/5;
pov=(pov2009+pov2010+pov2011+pov2012+pov2013)/5; 
Physician=(Physician2009+Physician2010+Physician2011+Physician2012+Physician2013)/5;
PCP=(PrimaryCare2009+PrimaryCare2010+PrimaryCare2011+PrimaryCare2012+PrimaryCare2013)/5;
Specialty=(Specialty2009+Specialty2010+Specialty2011+Specialty2012+Specialty2013)/5;
hospbd=(hospbd2009+hospbd2010+hospbd2011+hospbd2012+hospbd2013)/5;
whitepct=(whitepct2009+whitepct2010+whitepct2011+whitepct2012+whitepct2013)/5;
blackpct=(blackpct2009+blackpct2010+blackpct2011+blackpct2012+blackpct2013)/5;
hisppct=(hisppct2009+hisppct2010+hisppct2011+hispoct2012+hisppct2013)/5;
otherpct=(otherpct2009+otherpct2010+otherpct2011+otherpct2012+otherpct2013)/5;
PayRate=(PayRate2009+PayRate2010+PayRate2011+PayRate2012+PayRate2013)/5;
time=3;year=3;output;

cost=cost2014-cost2012; newcost=newcost2014-newcost2012; MAP=(MAP2012-map2010)/10;HMO=(HMO_penetration_12-HMO_penetration_10)/10;
HCC=(HCC2010+HCC2011+HCC2012+HCC2013+HCC2014)/5; 
FFS=(FFS2010+FFS2011+FFS2012+FFS2013+FFS2014)/5;
age=(age2010+age2011+age2012+age2013+age2014)/5;
pop=(pop2010+pop2011+pop2012+pop2013+pop2014)/5;
MHI=(MHI2010+MHI2011+MHI2012+MHI2013+MHI2014)/5;
pov=(pov2010+pov2011+pov2012+pov2013+pov2014)/5; 
Physician=(Physician2010+Physician2011+Physician2012+Physician2013+Physician2014)/5;
PCP=(PrimaryCare2010+PrimaryCare2011+PrimaryCare2012+PrimaryCare2013+PrimaryCare2014)/5;
Specialty=(Specialty2010+Specialty2011+Specialty2012+Specialty2013+Specialty2014)/5;
hospbd=(hospbd2010+hospbd2011+hospbd2012+hospbd2013+hospbd2014)/5;
whitepct=(whitepct2010+whitepct2011+whitepct2012+whitepct2013+whitepct2014)/5;
blackpct=(blackpct2010+blackpct2011+blackpct2012+blackpct2013+blackpct2014)/5;
hisppct=(hisppct2010+hisppct2011+hisppct2012+hisppct2013+hisppct2014)/5;
otherpct=(otherpct2010+otherpct2011+otherpct2012+otherpct2013+otherpct2014)/5;
PayRate=(PayRate2010+PayRate2011+PayRate2012+PayRate2013+PayRate2014)/5;
time=4;year=4;output;
run;

*Un-adjusted;
proc mixed data=ldata empirical;
	class fips year;  
	model &dvar.= &effect. time /solution cl;
	random intercept /subject=fips;
	ods output solutionF=unadj;
run;
*Adjusted only for market characteristics (hospital beds, primary care doctors, specialists);
proc mixed data=ldata empirical;
	class fips year ;  
	model &dvar.=  &effect. time PCP specialty hospbd /solution cl;
	random intercept  /subject=fips;
	ods output solutionF=market;
run;
*Adjusted for demographics (% below federal poverty line, median household income, percent black, percent Hispanic, other percent, HCC, population, FFS, age);
proc mixed data=ldata empirical; 
	class fips year;  
	model &dvar.= &effect. time pov mhi blackpct hisppct otherpct hcc  age PayRate/solution cl;
	random intercept   /subject=fips;
	ods output solutionF=demog;
run;
* Fully adjusted;
proc mixed data=ldata empirical;
	class fips year ;  
	model &dvar.=  &effect. time   PCP specialty  hospbd  pov mhi blackpct hisppct otherpct hcc  age PayRate /solution cl;
	random intercept  /subject=fips;
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

data all&i.;
length title $200.;
set Unadj market demog full;
title=&title.;
run;

data temp&i.;
length title $200.;
set all&i.;
title=&title.;
where effect="&effect.";
run;

%mend model;
%model(title="Main 2-year lagged model, Not stratified", dvar=cost,effect=MAP, M=0, Strat=0, i=1 );

%model(title="Main 2-year lagged model, stratified by quartile of baseline MAP, &svar.=&scat.", dvar=cost,effect=MAP, M=0, Strat=1, svar=map2007rank, scat=1, i=2 );
%model(title="Main 2-year lagged model, stratified by quartile of baseline MAP, &svar.=&scat.", dvar=cost,effect=MAP, M=0, Strat=1, svar=map2007rank, scat=2, i=3 );
%model(title="Main 2-year lagged model, stratified by quartile of baseline MAP, &svar.=&scat.", dvar=cost,effect=MAP, M=0, Strat=1, svar=map2007rank, scat=3, i=4 );
%model(title="Main 2-year lagged model, stratified by quartile of baseline MAP, &svar.=&scat.", dvar=cost,effect=MAP, M=0, Strat=1, svar=map2007rank, scat=4, i=5 );

%model(title="Main 2-year lagged model, stratified by quartile of total Physicians, &svar.=&scat.", dvar=cost,effect=MAP, M=0, Strat=1, svar=Physicianrank, scat=1, i=6 );
%model(title="Main 2-year lagged model, stratified by quartile of total Physicians, &svar.=&scat.", dvar=cost,effect=MAP, M=0, Strat=1, svar=Physicianrank, scat=2, i=7 );
%model(title="Main 2-year lagged model, stratified by quartile of total Physicians, &svar.=&scat.", dvar=cost,effect=MAP, M=0, Strat=1, svar=Physicianrank, scat=3, i=8 );
%model(title="Main 2-year lagged model, stratified by quartile of total Physicians, &svar.=&scat.", dvar=cost,effect=MAP, M=0, Strat=1, svar=Physicianrank, scat=4, i=9 );

%model(title="Main 2-year lagged model, stratified by quartile of total Primary Care Physician, &svar.=&scat.", dvar=cost,effect=MAP, M=0, Strat=1, svar=PCPrank, scat=1, i=10 );
%model(title="Main 2-year lagged model, stratified by quartile of total Primary Care Physician, &svar.=&scat.", dvar=cost,effect=MAP, M=0, Strat=1, svar=PCPrank, scat=2, i=11 );
%model(title="Main 2-year lagged model, stratified by quartile of total Primary Care Physician, &svar.=&scat.", dvar=cost,effect=MAP, M=0, Strat=1, svar=PCPrank, scat=3, i=12 );
%model(title="Main 2-year lagged model, stratified by quartile of total Primary Care Physician, &svar.=&scat.", dvar=cost,effect=MAP, M=0, Strat=1, svar=PCPrank, scat=4, i=13 );


%model(title="Main 2-year lagged model, stratified by quartile of total Acute-care Hospital Beds, &svar.=&scat.", dvar=cost,effect=MAP, M=0, Strat=1, svar=hospbdrank, scat=1, i=14 );
%model(title="Main 2-year lagged model, stratified by quartile of total Acute-care Hospital Beds, &svar.=&scat.", dvar=cost,effect=MAP, M=0, Strat=1, svar=hospbdrank, scat=2, i=15 );
%model(title="Main 2-year lagged model, stratified by quartile of total Acute-care Hospital Beds, &svar.=&scat.", dvar=cost,effect=MAP, M=0, Strat=1, svar=hospbdrank, scat=3, i=16 );
%model(title="Main 2-year lagged model, stratified by quartile of total Acute-care Hospital Beds, &svar.=&scat.", dvar=cost,effect=MAP, M=0, Strat=1, svar=hospbdrank, scat=4, i=17 );

%model(title="Main 2-year lagged model(exclude Minnesota), Not stratified", dvar=cost,effect=MAP, M=1, Strat=0, i=18);

%model(title="Main 2-year lagged model, stratified by quartile of baseline MAP(exclude Minnesota), &svar.=&scat.", dvar=cost,effect=MAP, M=1, Strat=1, svar=map2007rank, scat=1, i=19 );
%model(title="Main 2-year lagged model, stratified by quartile of baseline MAP(exclude Minnesota), &svar.=&scat.", dvar=cost,effect=MAP, M=1, Strat=1, svar=map2007rank, scat=2, i=20 );
%model(title="Main 2-year lagged model, stratified by quartile of baseline MAP(exclude Minnesota), &svar.=&scat.", dvar=cost,effect=MAP, M=1, Strat=1, svar=map2007rank, scat=3, i=21 );
%model(title="Main 2-year lagged model, stratified by quartile of baseline MAP(exclude Minnesota), &svar.=&scat.", dvar=cost,effect=MAP, M=1, Strat=1, svar=map2007rank, scat=4, i=22 );

%model(title="Main 2-year lagged model(subtract standardized home health and DME from FFS per capita costs)", dvar=newcost,effect=MAP, M=0, Strat=0, i=23 );

%model(title="Main 2-year lagged model, stratified by quartile of baseline MAP (subtract standardized home health and DME from FFS per capita costs), &svar.=&scat.", dvar=newcost,effect=MAP, M=0, Strat=1, svar=map2007rank, scat=1, i=24 );
%model(title="Main 2-year lagged model, stratified by quartile of baseline MAP (subtract standardized home health and DME from FFS per capita costs), &svar.=&scat.", dvar=newcost,effect=MAP, M=0, Strat=1, svar=map2007rank, scat=2, i=25 );
%model(title="Main 2-year lagged model, stratified by quartile of baseline MAP (subtract standardized home health and DME from FFS per capita costs), &svar.=&scat.", dvar=newcost,effect=MAP, M=0, Strat=1, svar=map2007rank, scat=3, i=26 );
%model(title="Main 2-year lagged model, stratified by quartile of baseline MAP (subtract standardized home health and DME from FFS per capita costs), &svar.=&scat.", dvar=newcost,effect=MAP, M=0, Strat=1, svar=map2007rank, scat=4, i=27 );

* HMO;
%model(title="HMO 2-year lagged model, Not stratified", dvar=cost,effect=HMO, M=0, Strat=0, i=28 );

%model(title="HMO 2-year lagged model, stratified by Presence of HMO at 2007(baseline), &svar.=&scat.", dvar=cost,effect=HMO, M=0, Strat=1, svar=HMO2007, scat=0, i=29 );
%model(title="HMO 2-year lagged model, stratified by Presence of HMO at 2007(baseline), &svar.=&scat.", dvar=cost,effect=HMO, M=0, Strat=1, svar=HMO2007, scat=1, i=30 );

%model(title="HMO 2-year lagged model(exclude Minnesota)", dvar=cost,effect=HMO, M=1, Strat=0, i=31 );

%model(title="HMO 2-year lagged model(exclude Minnesota),stratified by Presence of HMO at 2007(baseline), &svar.=&scat.", dvar=cost,effect=HMO, M=1, Strat=1, svar=HMO2007, scat=0, i=32 );
%model(title="HMO 2-year lagged model(exclude Minnesota),stratified by Presence of HMO at 2007(baseline), &svar.=&scat.", dvar=cost,effect=HMO, M=1, Strat=1, svar=HMO2007, scat=1, i=33 );


%model(title="HMO 2-year lagged model(subtract standardized home health and DME from FFS per capita costs)", dvar=newcost,effect=HMO, M=0, Strat=0, i=34 );

%model(title="HMO 2-year lagged model(subtract standardized home health and DME from FFS per capita costs),stratified by Presence of HMO at 2007(baseline), &svar.=&scat.", dvar=newcost,effect=HMO, M=0, Strat=1, svar=HMO2007, scat=0, i=35 );
%model(title="HMO 2-year lagged model(subtract standardized home health and DME from FFS per capita costs),stratified by Presence of HMO at 2007(baseline), &svar.=&scat.", dvar=newcost,effect=HMO, M=0, Strat=1, svar=HMO2007, scat=1, i=36 );
 



data temp;
set temp1-temp36;
proc print;
run;
 

data All;
set All1-All36;
proc print;
run;
 





* Table 1;

data mapdiffTemp1;
set map.data;
 
newcost2007=cost2007-DMEcost2007-HHcost2007;
newcost2008=cost2008-DMEcost2008-HHcost2008;
newcost2009=cost2009-DMEcost2009-HHcost2009;
newcost2010=cost2010-DMEcost2010-HHcost2010;
newcost2011=cost2011-DMEcost2011-HHcost2011;
newcost2012=cost2012-DMEcost2012-HHcost2012;
newcost2013=cost2013-DMEcost2013-HHcost2013;
newcost2014=cost2014-DMEcost2014-HHcost2014;

mapdiff=map2014-map2007; 
HMOdiff=HMO_penetration_14-HMO_penetration_07; 
costdiff=cost2014-cost2007;
newcostdiff=newcost2014-newcost2007;
*Maket characteristics;
Physician=mean(Physician2007,Physician2008,Physician2009,Physician2010,Physician2011,Physician2012,Physician2013,Physician2014);
PrimaryCare=mean(PrimaryCare2007,PrimaryCare2008,PrimaryCare2009,PrimaryCare2010,PrimaryCare2011,PrimaryCare2012,PrimaryCare2013,PrimaryCare2014);
Specialty=mean(Specialty2007,Specialty2008,Specialty2009,Specialty2010,Specialty2011,Specialty2012,Specialty2013,Specialty2014);
hospbd=mean(hospbd2007,hospbd2008,hospbd2009,hospbd2010,hospbd2011,hospbd2012,hospbd2013,hospbd2014);
*Demographics;
pov=mean(pov2007,pov2008,pov2009,pov2010,pov2011,pov2012,pov2013,pov2014);
mhi=mean(mhi2007,mhi2008,mhi2009,mhi2010,mhi2011,mhi2012,mhi2013,mhi2014);
pop=mean(pop2007,pop2008,pop2009,pop2010,pop2011,pop2012,pop2013,pop2014);
FFS=mean(FFS2007,FFS2008,FFS2009,FFS2010,FFS2011,FFS2012,FFS2013,FFS2014);
age=mean(age2007,age2008,age2009,age2010,age2011,age2012,age2013,age2014);
 
whitepct=mean(whitepct12011,whitepct12012,whitepct12013,whitepct12014);
blackpct=mean(blackpct12011,blackpct12012,blackpct12013,blackpct12014);
hisppct=mean(hisppct12011,hisppct12012,hisppct12013,hisppct12014);
Otherpct=mean(Otherpct12011,Otherpct12012,Otherpct12013,Otherpct12014);
if mapdiff ne .;
run;

proc rank data=mapdiffTemp1 out=mapdiffTable1 group=4;
var mapdiff;
ranks mapdiffRank;
run;



data HMOdiffTemp1;
set map.data;
 
newcost2007=cost2007-DMEcost2007-HHcost2007;
newcost2008=cost2008-DMEcost2008-HHcost2008;
newcost2009=cost2009-DMEcost2009-HHcost2009;
newcost2010=cost2010-DMEcost2010-HHcost2010;
newcost2011=cost2011-DMEcost2011-HHcost2011;
newcost2012=cost2012-DMEcost2012-HHcost2012;
newcost2013=cost2013-DMEcost2013-HHcost2013;
newcost2014=cost2014-DMEcost2014-HHcost2014;

mapdiff=map2014-map2007; 
HMOdiff=HMO_penetration_14-HMO_penetration_07; 
costdiff=cost2014-cost2007;
newcostdiff=newcost2014-newcost2007;
*Maket characteristics;
Physician=mean(Physician2007,Physician2008,Physician2009,Physician2010,Physician2011,Physician2012,Physician2013,Physician2014);
PrimaryCare=mean(PrimaryCare2007,PrimaryCare2008,PrimaryCare2009,PrimaryCare2010,PrimaryCare2011,PrimaryCare2012,PrimaryCare2013,PrimaryCare2014);
Specialty=mean(Specialty2007,Specialty2008,Specialty2009,Specialty2010,Specialty2011,Specialty2012,Specialty2013,Specialty2014);
hospbd=mean(hospbd2007,hospbd2008,hospbd2009,hospbd2010,hospbd2011,hospbd2012,hospbd2013,hospbd2014);
*Demographics;
pov=mean(pov2007,pov2008,pov2009,pov2010,pov2011,pov2012,pov2013,pov2014);
mhi=mean(mhi2007,mhi2008,mhi2009,mhi2010,mhi2011,mhi2012,mhi2013,mhi2014);
pop=mean(pop2007,pop2008,pop2009,pop2010,pop2011,pop2012,pop2013,pop2014);
FFS=mean(FFS2007,FFS2008,FFS2009,FFS2010,FFS2011,FFS2012,FFS2013,FFS2014);
age=mean(age2007,age2008,age2009,age2010,age2011,age2012,age2013,age2014);
 
whitepct=mean(whitepct12011,whitepct12012,whitepct12013,whitepct12014);
blackpct=mean(blackpct12011,blackpct12012,blackpct12013,blackpct12014);
hisppct=mean(hisppct12011,hisppct12012,hisppct12013,hisppct12014);
Otherpct=mean(Otherpct12011,Otherpct12012,Otherpct12013,Otherpct12014);
if HMOdiff ne .;
run;

proc rank data=HMOdiffTemp1 out=HMOdiffTable1 group=4 ties=low;
var HMOdiff;
ranks HMOdiffRank;
run;
 



proc tabulate data=MAPdiffTable1;
weight FFS;
var map2007 MAPdiff cost2007 costdiff newcost2007 newcostdiff Physician PrimaryCare Specialty hospbd pov mhi pop FFS age whitepct blackpct hisppct Otherpct;
class MapdiffRank region;
tables MapdiffRank*N;
tables 
(map2007 MAPdiff cost2007 costdiff newcost2007 newcostdiff Physician PrimaryCare Specialty hospbd pov mhi pop FFS age whitepct blackpct hisppct Otherpct),MapdiffRank*(mean*f=7.4) ;
tables region,MapdiffRank*colpctn ;
run;

%macro pvalue(var=);
proc glm data=MAPdiffTable1;
weight FFS;
class MapdiffRank;
model &var.=MapdiffRank;
run;
%mend pvalue;
%pvalue(var=map2007);
%pvalue(var=MAPdiff);
%pvalue(var=cost2007);
%pvalue(var=costdiff);
%pvalue(var=newcost2007);
%pvalue(var=newcostdiff);
%pvalue(var=Physician);
%pvalue(var=PrimaryCare);
%pvalue(var=Specialty);
%pvalue(var=hospbd);
%pvalue(var=pov);
%pvalue(var=mhi);
%pvalue(var=pop);
%pvalue(var=FFS );
%pvalue(var=age );
%pvalue(var=whitepct );
%pvalue(var=blackpct );
%pvalue(var=hisppct );
%pvalue(var=Otherpct );
proc freq data=MAPdiffTable1;tables region*MapdiffRank/chisq;run;




proc tabulate data=HMOdiffTable1;
weight FFS;
var HMO_penetration_07 HMOdiff cost2007 costdiff newcost2007 newcostdiff Physician PrimaryCare Specialty hospbd pov mhi pop FFS age whitepct blackpct hisppct Otherpct;
class HMOdiffRank region;
tables HMOdiffRank*N;
tables 
(HMO_penetration_07 HMOdiff cost2007 costdiff newcost2007 newcostdiff Physician PrimaryCare Specialty hospbd pov mhi pop FFS age whitepct blackpct hisppct Otherpct),HMOdiffRank*(mean*f=7.4) ;
tables region,HMOdiffRank*colpctn ;
run;


%macro pvalue(var=);
proc glm data=HMOdiffTable1;
weight FFS;
class HMOdiffRank;
model &var.=HMOdiffRank;
run;
%mend pvalue;
%pvalue(var=HMO_penetration_07);
%pvalue(var=hmodiff);
%pvalue(var=cost2007);
%pvalue(var=costdiff);
%pvalue(var=newcost2007);
%pvalue(var=newcostdiff);
%pvalue(var=Physician);
%pvalue(var=PrimaryCare);
%pvalue(var=Specialty);
%pvalue(var=hospbd);
%pvalue(var=pov);
%pvalue(var=mhi);
%pvalue(var=pop);
%pvalue(var=FFS );
%pvalue(var=age );
%pvalue(var=whitepct );
%pvalue(var=blackpct );
%pvalue(var=hisppct );
%pvalue(var=Otherpct );
proc freq data=hmodiffTable1;tables region*hmodiffRank/chisq;run;
