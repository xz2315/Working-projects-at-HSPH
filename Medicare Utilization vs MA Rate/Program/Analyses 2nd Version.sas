**************************
2nd Version Analyses
Xiner Zhou
4/30/2015
**************************;

libname MAP 'C:\data\Projects\Medicare Utilization vs MA Rate';


%macro trans(yr=);
cost=cost&yr.;MAP=MAP&yr.;
HCC=HCC&yr.; FFS=FFS&yr.;MHI=MHI&yr.;pov=pov&yr.;pop=pop&yr.;
Physician=Physician&yr.;PrimaryCare=PrimaryCare&yr.;Specialty=Specialty&yr.;
hospbd=hospbd&yr.;whitepct=whitepct&yr.;blackpct=blackpct&yr.;hisppct=hisppct&yr.;otherpct=otherpct&yr.;
time=&yr.-2007;  year=&yr.; output;
%mend trans;

data data1;
	set map.data;
	mapdiff=map2013-map2007;
	lagmap=map2010-map2007;
	lagcost=cost2013-cost2010;
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
	symbol3 color=orange interpol=join value=triangle;
	symbol4 color=red interpol=join value=triangle;
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
	symbol3 color=orange interpol=join value=triangle;
	symbol4 color=red interpol=join value=triangle;
	plot mean*year=mapdiffrank;
	title 'Average COST for each MAP Change Quartile';
run;

* how map changes;
proc mixed data=ldata empirical ;
	class fips mapdiffrank;
	model map= mapdiffrank time mapdiffrank*time pop ffs pov mhi physician specialty hospbd hcc /solution;
	random intercept time/subject=fips  ;

estimate "Starting MAP for Q1" intercept 1 mapdiffrank 1 0 0 0 ;
estimate "Starting MAP for Q2" intercept 1 mapdiffrank 0 1 0 0 ;
estimate "Starting MAP for Q3" intercept 1 mapdiffrank 0 0 1 0 ;
estimate "Starting MAP for Q4" intercept 1 mapdiffrank 0 0 0 1 ;

estimate "MAP Change Rate for Q1" time 1 mapdiffrank*time 1 0 0 0 ;
estimate "MAP Change Rate for Q2" time 1 mapdiffrank*time 0 1 0 0 ;
estimate "MAP Change Rate for Q3" time 1 mapdiffrank*time 0 0 1 0 ;
estimate "MAP Change Rate for Q4" time 1 mapdiffrank*time 0 0 0 1 ;
run;

* how cost change ;
proc mixed data=ldata empirical ;
class fips mapdiffrank;
model cost= mapdiffrank time mapdiffrank*time pop ffs pov mhi physician specialty hospbd hcc /solution;
random intercept time/subject=fips  ;
estimate "Starting cost for Q1" intercept 1 mapdiffrank 1 0 0 0 ;
estimate "Starting cost for Q2" intercept 1 mapdiffrank 0 1 0 0 ;
estimate "Starting cost for Q3" intercept 1 mapdiffrank 0 0 1 0 ;
estimate "Starting cost for Q4" intercept 1 mapdiffrank 0 0 0 1 ;

estimate "cost Change Rate for Q1" time 1 mapdiffrank*time 1 0 0 0 ;
estimate "cost Change Rate for Q2" time 1 mapdiffrank*time 0 1 0 0 ;
estimate "cost Change Rate for Q3" time 1 mapdiffrank*time 0 0 1 0 ;
estimate "cost Change Rate for Q4" time 1 mapdiffrank*time 0 0 0 1 ;
run;


* Model2 ;
proc mixed data=ldata empirical ;
class fips mapdiffrank;
model cost= map time pop ffs pov mhi physician specialty hospbd hcc /solution;
random intercept time/subject=fips  ;
run;
 






























proc format ;
value region_
1='Northeast'
2='Midwest'
3='South'
4='West'
;
run;
proc format ;
value q_
0='Q1:Smallest value'
1='Q2'
2='Q3'
3='Q4:Largest value';
run;
 

data ldata;
set map.data;
 
%trans(yr=2007);
%trans(yr=2008);
%trans(yr=2009);
%trans(yr=2010);
%trans(yr=2011);
%trans(yr=2012);
%trans(yr=2013);

keep state county fips cost mapchange map map2007  hcc ffs  otherpct whitepct blackpct hisppct blktowhite hisptowhite othertowhite  
whitetoblk hisptoblk othertoblk whitetohisp blktohisp othertohisp pop
mhi povrank physician primarycare specialty hospbd PCr spr time year maprank hospbdrank physicianrank Specialtyrank MHIrank region pop;
run;


* Plot county-level profiles;
%macro profile(var=,title=);
proc gplot data=ldata(where=(county='Middlesex' and state='Massachusett'));
symbol1 interpol=join value=triangle;
plot &var.*year=fips;
title "Middlesex: &title. ";
run;
%mend profile;
%profile(var=cost,title=Standardized Risk-Adjusted Per Capita Costs);
%profile(var=MAP,title=MA Participation Rate);
 
 
*Plot Mean Response Profiels;
%macro mean(var=,title=);
 
proc sort data=ldata;by time;run; 
proc means data=ldata noprint;                                                                                                           
   by year;                                                                                                                             
   var &var.;                                                                                                                            
   output out=plotdata(drop=_freq_ _type_) mean=mean;    
	proc print noobs; 
run;  
                                                                                                  
goptions reset=all cback=white border htext=10pt htitle=12pt;                                                                           
                                                                                                              
                                                                                            
proc gplot data=plotdata;  
   title1 "National Mean Profile of &title. ";
axis1 label=(a=90 "&title."); 
   symbol1 interpol=hiloctj color=blue line=2;                                                                                          
   symbol2 interpol=none color=blue value=dot height=1.5;
	plot mean*year/ overlay vaxis=axis1;     
run;   
%mend mean;
%mean(var=cost,title=Standardized Risk-Adjusted Per Capita Costs);
%mean(var=MAP,title=MA Participation Rate);
 



proc mixed data=ldata empirical;
format region region_.;format maprank q_.;format pov2010rank q_.;format mhi2010rank q_.;format hospbd2010rank q_.;format physician2010rank q_.;
class year fips region maprank povrank mhirank hospbdrank physicianrank specialtyrank ;
model cost= maprank mapchange maprank*mapchange year mhirank hospbdrank  physicianrank specialtyrank  povrank region whitepct blackpct hisppct/solution ;
repeated year/type=un subject=fips  ;
	estimate 'effect of MAP: BaseMAP Q1' mapchange 1 maprank*mapchange 1 0 0 0;
	estimate 'effect of MAP: BaseMAP Q2' mapchange 1 maprank*mapchange 0 1 0 0;
	estimate 'effect of MAP: BaseMAP Q3' mapchange 1 maprank*mapchange 0 0 1 0;
	estimate 'effect of MAP: BaseMAP Q4' mapchange 1 maprank*mapchange 0 0 0 1;

    estimate 'effect of Income on cost: Income Q1 versus Q4' mhirank 1 0 0 -1;
	estimate 'effect of Income on cost: IncomeQ2 versus Q4' mhirank 0 1 0 -1;
	estimate 'effect of Income on cost: Income Q3 versus Q4' mhirank 0 0 1 -1;
 
  estimate 'effect of AcuteCare Hospital Beds on cost:  Q1 versus Q4' hospbdrank  1 0 0 -1;
	estimate 'effect of AcuteCare Hospital Beds on cost:  Q2 versus Q4' hospbdrank  0 1 0 -1;
	estimate 'effect of AcuteCare Hospital Beds on cost:  Q3 versus Q4' hospbdrank  0 0 1 -1;

	
  estimate 'effect of Total number of Physicians on cost:  Q1 versus Q4' physicianrank  1 0 0 -1;
	estimate 'effect of Total number of Physicians on cost:  Q2 versus Q4' physicianrank  0 1 0 -1;
	estimate 'effect of Total number of Physicians on cost:  Q3 versus Q4' physicianrank  0 0 1 -1;

		
  estimate 'effect of Total number of Specialty on cost:  Q1 versus Q4' Specialtyrank  1 0 0 -1;
	estimate 'effect of Total number of Specialty on cost:  Q2 versus Q4' Specialtyrank  0 1 0 -1;
	estimate 'effect of Total number of Specialty on cost:  Q3 versus Q4' Specialtyrank  0 0 1 -1;

	  estimate 'effect of %poverty on cost:  Q1 versus Q4' povrank  1 0 0 -1;
	estimate 'effect of %poverty on cost:  Q2 versus Q4' povrank  0 1 0 -1;
	estimate 'effect of %poverty on cost:  Q3 versus Q4' povrank  0 0 1 -1;

	  estimate 'effect of Regional Difference on cost:  Midwest versus West' povrank  1 0 0 -1;
	estimate 'effect of Regional Difference on cost:  Northeast versus West' povrank  0 1 0 -1;
	estimate 'effect of Regional Difference on cost: South versus West' povrank  0 0 1 -1;

	estimate 'National average TM cost 2007' intercept 1 year 1 0 0 0 0 0 0;
	estimate 'National average TM cost 2008' intercept 1 year 0 1 0 0 0 0 0;
	estimate 'National average TM cost 2009' intercept 1 year 0 0 1 0 0 0 0;
	estimate 'National average TM cost 2010' intercept 1 year 0 0 0 1 0 0 0;
	estimate 'National average TM cost 2011' intercept 1 year 0 0 0 0 1 0 0;
	estimate 'National average TM cost 2012' intercept 1 year 0 0 0 0 0 1 0;
	estimate 'National average TM cost 2013' intercept 1 year 0 0 0 0 0 0 1;

		estimate 'Black versus White' blackpct 1 whitepct -1;
	estimate 'Hispanic versus White' hisppct 1 whitepct -1;
run;
 














/*
MOdel 1:
rate2009-rate2007 predict cost2011-cost2009
rate2010-rate2008 predict cost2012-cost2010
rate2011-rate2009 predict cost2013-cost2012
*/

data temp;
set map.data;
mapdiff1=map2009-map2007;
mapdiff2=map2010-map2008;
mapdiff3=map2011-map2009;
costdiff1=cost2011-cost2009;
costdiff2=cost2012-cost2010;
costdiff3=cost2013-cost2011;
run;


* transpose from wide format to long format;
data ldata;
set temp;
cost=costdiff1;MAP=MAPdiff1;baseline=cost2009;HCC=HCC2008; 
HMO=HMO2008;nonHMO=nonHMO2008; FFS=FFS2008;
MHI=MHI2008;pov=pov2008;MD=MDr2008;GP=GPr2008;Card=cardr2008;pulm=pulmr2008;bed=bedr2008;intbed=intbedr2008;year=0;
output;
cost=costdiff2;MAP=MAPdiff2;baseline=cost2010;HCC=HCC2009; 
HMO=HMO2009;nonHMO=nonHMO2009; FFS=FFS2009;
MHI=MHI2009;pov=pov2009;MD=MDr2009;GP=GPr2009;Card=cardr2009;pulm=pulmr2009;bed=bedr2009;intbed=intbedr2009;year=1;
output;
cost=costdiff3;MAP=MAPdiff3;baseline=cost2011;HCC=HCC2010; 
HMO=HMO2010;nonHMO=nonHMO2010; FFS=FFS2010;
MHI=MHI2010;pov=pov2010;MD=MDr2010;GP=GPr2010;Card=cardr2010;pulm=pulmr2010;bed=bedr2010;intbed=intbedr2010;year=2;
output;
keep state  county fips cost map baseline year  
run;
 



proc sort data=ldata;by descending year;run;
proc mixed data=ldata  order=data;
	class fips  year;
	weight ffs; 
	model cost= map  /solution chisq cl;
	repeated year/type=un subject=fips r rcorr ;
run;
proc mixed data=ldata  order=data;
	class fips  year;
	weight ffs; 
	model cost= map mhi pov gp card pulm bed intbed/solution chisq cl;
	repeated year/type=un subject=fips r rcorr ;
run;
proc mixed data=ldata  order=data;
	class fips  year;
	weight ffs; 
	model cost= map hcc  mhi pov gp card pulm bed intbed/solution chisq cl;
	repeated year/type=un subject=fips r rcorr ;
run;

proc mixed data=ldata  order=data;
	class fips  year;
	weight ffs; 
	model cost= map hcc md white black hispanic native mhi pov  gp card pulm bed intbed/solution chisq cl;
	repeated year/type=un subject=fips r rcorr ;
run;


*adjust for baseline;
proc mixed data=ldata  order=data;
	class fips  year;
	weight ffs; 
	model cost= map baseline  /solution chisq cl;
	repeated year/type=un subject=fips r rcorr ;
run;
