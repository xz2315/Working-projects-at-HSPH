***************************
Analyses
Xiner Zhou
3/24/2015
*****************************;

libname MAP 'C:\data\Projects\Medicare Utilization vs MA Rate';

/*
Fix the issue regarding the coefficients for MD GP CARD PULM BED INTBED:

Our Hypothese is that:
More MDs , Higher Cost per capita
More Beds, Higher Cost per capita
GP, CARD, PULM, ICUbeds should all be positively related to cost per capita
*/


%let yr=2007;
%let yr=2008;
%let yr=2009;
%let yr=2010;
%let yr=2011;
%let yr=2012;
%let yr=2013;

%let var=md;
%let var=gp;
%let var=card;
%let var=pulm;
%let var=intbed;
%let var=bed;

proc format;
value MHIRank_
0='Lowest House Income County'
1='2nd Lowest House Income County'
2='Middle House Income County'
3='2nd Highest House Income County'
4='Highest House Income County'
;
run;

proc corr data=map.data nosimple  ;
var md&yr. bed&yr. gp&yr. card&yr. pulm&yr. intbed&yr.;
run;
data temp;
set map.data;
r=&var.&yr./bed&yr.;
proc sort;by mhi&yr.rank;
run;
proc corr data=temp;var r bed&yr.;run;


proc glm data=temp order=data;
class mhi&yr.rank;
format mhi&yr.rank MHIRank_.;
model cost&yr.=map&yr. bed&yr. mhi&yr.rank mhi&yr.rank*map&yr.  /solution;
run;
proc glm data=temp order=data;
class mhi2007rank;
format mhi&yr.rank MHIRank_.;
model cost&yr.=map&yr. bed&yr. r mhi&yr.rank mhi&yr.rank*map&yr. /solution;
run;
proc glm data=temp order=data;
class mhi2007rank;
format mhi&yr.rank MHIRank_.;
model cost&yr.=map&yr. mhi&yr.rank mhi&yr.rank*map&yr. card&yr. /solution;
run;
proc glm data=temp order=data;
class mhi2007rank;
format mhi&yr.rank MHIRank_.;
model cost&yr.=map&yr. mhi&yr.rank mhi&yr.rank*map&yr. pulm&yr. /solution;
run;
proc glm data=temp order=data;
class mhi2007rank;
format mhi&yr.rank MHIRank_.;
model cost&yr.=map&yr. mhi&yr.rank mhi&yr.rank*map&yr. bed&yr. /solution;
run;
proc glm data=temp order=data;
class mhi2007rank;
format mhi&yr.rank MHIRank_.;
model cost&yr.=map&yr. mhi&yr.rank mhi&yr.rank*map&yr. intbed&yr. /solution;
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
keep state  FFS county fips cost map baseline hmo nonhmo hcc white black native hispanic mhi pov md gp card pulm bed intbed year;
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
proc mixed data=ldata  order=data;
	class fips  year;
	weight ffs; 
	model cost= map baseline  mhi pov  gp card pulm bed intbed/solution chisq cl;
	repeated year/type=un subject=fips r rcorr ;
run;
proc mixed data=ldata  order=data;
	class fips  year;
	weight ffs; 
	model cost= map baseline hcc  mhi pov  gp card pulm bed intbed/solution chisq cl;
	repeated year/type=un subject=fips r rcorr ;
run;
 
proc mixed data=ldata  order=data;
	class fips  year;
	weight ffs; 
	model cost= map baseline hcc md white black hispanic native mhi pov gp card pulm bed intbed/solution chisq cl;
	repeated year/type=un subject=fips r rcorr ;
run;
 
/*
MOdel 1.1:
rate2009-rate2007 predict cost2010-cost2008
rate2010-rate2008 predict cost2011-cost2009
rate2011-rate2009 predict cost2012-cost2010
rate2012-rate2010 predict cost2013-cost2011
*/

data temp;
set map.data;
mapdiff1=map2009-map2007;
mapdiff2=map2010-map2008;
mapdiff3=map2011-map2009;
mapdiff4=map2012-map2010;
costdiff1=cost2010-cost2008;
costdiff2=cost2011-cost2009;
costdiff3=cost2012-cost2010;
costdiff4=cost2013-cost2011;
run;


* transpose from wide format to long format;
data ldata;
set temp;
cost=costdiff1;MAP=MAPdiff1;HCC=HCC2008;baseline=cost2008; 
HMO=HMO2008;nonHMO=nonHMO2008; FFS=FFS2008;
MHI=MHI2008;pov=pov2008;MD=MDr2008;GP=GPr2008;Card=cardr2008;pulm=pulmr2008;bed=bedr2008;intbed=intbedr2008;year=0;
output;
cost=costdiff2;MAP=MAPdiff2;HCC=HCC2009; baseline=cost2009; 
HMO=HMO2009;nonHMO=nonHMO2009; FFS=FFS2009;
MHI=MHI2009;pov=pov2009;MD=MDr2009;GP=GPr2009;Card=cardr2009;pulm=pulmr2009;bed=bedr2009;intbed=intbedr2009;year=1;
output;
cost=costdiff3;MAP=MAPdiff3;HCC=HCC2010;baseline=cost2010;  
HMO=HMO2010;nonHMO=nonHMO2010; FFS=FFS2010;
MHI=MHI2010;pov=pov2010;MD=MDr2010;GP=GPr2010;Card=cardr2010;pulm=pulmr2010;bed=bedr2010;intbed=intbedr2010;year=2;
output;
cost=costdiff4;MAP=MAPdiff4;HCC=HCC2010; baseline=cost2011; 
HMO=HMO2010;nonHMO=nonHMO2010; FFS=FFS2010;
MHI=MHI2010;pov=pov2010;MD=MDr2010;GP=GPr2010;Card=cardr2010;pulm=pulmr2010;bed=bedr2010;intbed=intbedr2010;year=3;
output;
keep state  FFS county fips cost map baseline hmo nonhmo hcc white black native hispanic mhi pov md gp card pulm bed intbed year;
run;
 
proc sort data=ldata;by descending year;run;
proc mixed data=ldata  order=data;
	class fips  year;
	weight ffs;*weighted by MEdicare FFS population in that county;
	model cost= map hcc  white black hispanic native mhi pov md gp card pulm bed intbed/solution chisq cl;
	repeated year/type=un subject=fips r rcorr ;
run;
proc mixed data=ldata  order=data;
	class fips  year;
	weight ffs;*weighted by MEdicare FFS population in that county;
	model cost= map baseline hcc  white black hispanic native mhi pov md gp card pulm bed intbed/solution chisq cl;
	repeated year/type=un subject=fips r rcorr ;
run;

 

/*
MOdel 2:
rate2008-rate2007 predict cost2009-cost2008
rate2009-rate2008 predict cost2010-cost2009
rate2010-rate2009 predict cost2011-cost2010
rate2011-rate2010 predict cost2012-cost2011
rate2012-rate2011 predict cost2013-cost2012
*/

data temp;
set map.data;
mapdiff1=map2008-map2007;
mapdiff2=map2009-map2008;
mapdiff3=map2010-map2009;
mapdiff4=map2011-map2010;
mapdiff5=map2012-map2011;
 
costdiff1=cost2009-cost2008;
costdiff2=cost2010-cost2009;
costdiff3=cost2011-cost2010;
costdiff4=cost2012-cost2011;
costdiff5=cost2013-cost2012;
 
run;


* transpose from wide format to long format;
data ldata;
set temp;
cost=costdiff1;MAP=MAPdiff1;HCC=HCC2007; baseline=cost2008;
HMO=HMO2007;nonHMO=nonHMO2007; FFS=FFS2007;
MHI=MHI2007;pov=pov2007;MD=MDr2007;GP=GPr2007;Card=cardr2007;pulm=pulmr2007;bed=bedr2007;intbed=intbedr2007;year=0;
output;
cost=costdiff2;MAP=MAPdiff2;HCC=HCC2008; baseline=cost2009;
HMO=HMO2008;nonHMO=nonHMO2008; FFS=FFS2008;
MHI=MHI2008;pov=pov2008;MD=MDr2008;GP=GPr2008;Card=cardr2008;pulm=pulmr2008;bed=bedr2008;intbed=intbedr2008;year=1;
output;
cost=costdiff3;MAP=MAPdiff3;HCC=HCC2009; baseline=cost2010;
HMO=HMO2009;nonHMO=nonHMO2009; FFS=FFS2009;
MHI=MHI2009;pov=pov2009;MD=MDr2009;GP=GPr2009;Card=cardr2009;pulm=pulmr2009;bed=bedr2009;intbed=intbedr2009;year=2;
output;
cost=costdiff4;MAP=MAPdiff4;HCC=HCC2010; baseline=cost2011;
HMO=HMO2010;nonHMO=nonHMO2010; FFS=FFS2010;
MHI=MHI2010;pov=pov2010;MD=MDr2010;GP=GPr2010;Card=cardr2010;pulm=pulmr2010;bed=bedr2010;intbed=intbedr2010;year=3;
output;
cost=costdiff5;MAP=MAPdiff5;HCC=HCC2011; baseline=cost2012;
HMO=HMO2011;nonHMO=nonHMO2011; FFS=FFS2011;
MHI=MHI2011;pov=pov2011;MD=MDr2011;GP=GPr2011;Card=cardr2011;pulm=pulmr2011;bed=bedr2011;intbed=intbedr2011;year=4;
output;
 
keep state ffs county fips cost map baseline map2007 hmo nonhmo hcc white black hispanic native mhi pov md gp card pulm bed intbed year;
run;

proc sort data=ldata;by descending year;run;
proc mixed data=ldata  order=data;
	class fips  year;
	weight ffs; 
	model cost= map hcc  white black hispanic native mhi pov md gp card pulm bed intbed/solution chisq cl;
	repeated year/type=un subject=fips r rcorr ;
run;
proc mixed data=ldata  order=data;
	class fips  year;
	weight ffs; 
	model cost= map baseline  hcc  white black hispanic native mhi pov md gp card pulm bed intbed/solution chisq cl;
	repeated year/type=un subject=fips r rcorr ;
run;
 

/*
MOdel 3: Pre predict Post
rate2010-rate2007 predict cost2011-cost2010

rate2010-rate2007 predict cost2012-cost2010

rate2010-rate2007 predict cost2013-cost2010
*/

%let year=cost2011-cost2010;
%let year=cost2012-cost2010;
%let year=cost2013-cost2010;

data temp;
set map.data;
mapdiff =map2010-map2007;
costdiff=&year.;
run;


* transpose from wide format to long format;
data ldata;
set temp;
cost=costdiff;MAP=MAPdiff;HCC=HCC2008;baseline=cost2010;
HMO=HMO2008;nonHMO=nonHMO2008; FFS=FFS2008;
MHI=MHI2008;pov=pov2008;MD=MDr2008;GP=GPr2008;Card=cardr2008;pulm=pulmr2008;bed=bedr2008;intbed=intbedr2008; 
output;

keep state  FFS county fips cost map baseline hmo nonhmo hcc white black native hispanic mhi pov md gp card pulm bed intbed  ;
run;
 
proc reg data=ldata ;
	weight ffs; 
	model cost= map    ;	 
run;
proc reg data=ldata ;
	weight ffs; 
	model cost= map   mhi pov  gp card pulm bed intbed ;	 
run;
proc reg data=ldata ;
	weight ffs; 
	model cost= map  hcc    mhi pov  gp card pulm bed intbed ;	 
run;
proc reg data=ldata ;
	weight ffs; 
	model cost= map  hcc  md white black hispanic native mhi pov  gp card pulm bed intbed ;	 
run;
*Adjust for baseline;
proc reg data=ldata ;
	weight ffs; 
	model cost= map baseline  ;	 
run;
proc reg data=ldata ;
	weight ffs; 
	model cost= map baseline   mhi pov   gp card pulm bed intbed;	 
run;
proc reg data=ldata ;
	weight ffs; 
	model cost= map baseline hcc   mhi pov   gp card pulm bed intbed;	 
run;
proc reg data=ldata ;
	weight ffs; 
	model cost= map baseline hcc md white black hispanic native mhi pov  gp card pulm bed intbed;	 
run;
 







********************************************Natural Response;
* transpose from wide format to long format;
%macro trans(yr=);
cost=cost&yr.;MAP=MAP&yr.;MAPchange=MAP&yr.-MAP2007;HCC=HCC&yr.; 
HMO=HMO&yr.;nonHMO=nonHMO&yr.; FFS=FFS&yr.;
MHI=MHI&yr.;MHIRank=MHI&yr.Rank;pov=pov&yr.;MD=MD&yr.;GP=GP&yr.;Card=card&yr.;pulm=pulm&yr.;bed=bed&yr.;intbed=intbed&yr.;
time=&yr.-2007; year=&yr.;output;
%mend trans;
data ldata;
set map.data;
 
%trans(yr=2007);
%trans(yr=2008);
%trans(yr=2009);
%trans(yr=2010);
%trans(yr=2011);
%trans(yr=2012);
%trans(yr=2013);
label mapchange='MA Penetration Change from 2007';
keep state pop county fips cost mapchange map map2007  hmo nonhmo hcc ffs white black native hispanic mhi mhiRank pov md gp card pulm bed intbed time year;
run;
 
* Plot county-level profiles;
%macro profile(var=,title=);
proc gplot data=ldata(where=(state='Massachusett'));
symbol1 interpol=join value=triangle;
symbol2 interpol=join value=triangle;
symbol3 interpol=join value=triangle;
symbol4 interpol=join value=triangle;
symbol5 interpol=join value=triangle;
plot &var.*year=fips;
title "Massachusett County Profiles: &title. ";
run;
%mend profile;
%profile(var=cost,title=Standardized Risk-Adjusted Per Capita Costs);
%profile(var=MAP,title=MA Participation Rate);
%profile(var=hcc,title=Average HCC Score);
%profile(var=hmo,title=MA-HMO percentage);
%profile(var=nonhmo,title=MA-non HMO percentage);
%profile(var=md,title=MDs);
%profile(var=GP,title=GPs);
%profile(var=card,title=Cardio);
%profile(var=Pulm,title=Pulm);
%profile(var=Bed,title=Total Hospital Beds );
%profile(var=intbed,title=Intensiven Care Beds );
 
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
%mean(var=hcc,title=Average HCC Score);
 %mean(var=hmo,title=MA-HMO percentage);
 %mean(var=nonhmo,title=MA-non HMO percentage);

 * Does MA Penetration all go to wealthier counties, look at MHI Quintiles and MAPs each year;
 %let var=MHI;%let title=Median House Income; 

%let var=MAP;%let title=MA Penetration Rate;

%let var=MAPchange;%let title=MA Penetration Rate Change from 2007;

  %let var=cost;%let title=Medicare FFS Standard Cost per capita;

proc means data=ldata n mean  nway;
var &var. ;
class MHIRank year;
output out=meandata mean=mean;
proc print data=meandata;
run; 

* Plot mean over time for each quintiles;
proc format;
value MHIRank_
0='Lowest Median House Income County'
1='2nd Lowest Median House Income County'
2='Middle Median House Income County'
3='2nd Highest Median House Income County'
4='Highest Median House Income County'
;
run;
proc gplot data=meandata;
format MHIRank MHIRank_.;
symbol1 interpol=join value=triangle;
symbol2 interpol=join value=triangle;
symbol3 interpol=join value=triangle;
symbol4 interpol=join value=triangle;
symbol5 interpol=join value=triangle;
plot mean*year=MHIRank;
title "Average &title. by MedianHouseIncome Quintiles over year";
run;
  




proc sort data=ldata;by descending year descending mhirank;run;
*separate cross-sectional and longitudianl;
 
ods graphics on;
proc mixed data=ldata  order=data plots=vcirypanel(unpack) PLOTS(MAXPOINTS=100000) ;
 
	class fips  year mhirank;
	format MHIRank MHIRank_.;
	weight ffs;
	model cost= map2007 mapchange mhirank mapchange*mhirank year   /solution chisq cl outpm=fitted vciry ;
	repeated year/type=un subject=fips  ;
	estimate 'Within-county effect of MAP for Highest House Income County' mapchange 1 mapchange*mhirank 1 0 0 0 0;
	estimate 'Within-county effect of MAP for 2nd Highest House Income County' mapchange 1 mapchange*mhirank 0 1 0 0 0;
	estimate 'Within-county effect of MAP for Middle House Income County' mapchange 1 mapchange*mhirank 0 0 1 0 0;
	estimate 'Within-county effect of MAP for 2nd Highest House Income County' mapchange 1 mapchange*mhirank 0 0 0 1 0;
	estimate 'Within-county effect of MAP for Highest House Income County' mapchange 1 mapchange*mhirank 0 0 0 0 1;
run;
 ods graphics off;

proc mixed data=ldata  order=data method=REML;
	class fips  year mhirank;
	format MHIRank MHIRank_.;
	weight ffs;
	model cost= map2007 mapchange mhirank mapchange*mhirank year MD  /solution chisq cl;
	repeated year/type=un subject=fips  ;
	estimate 'Within-county effect of MAP for Highest House Income County' mapchange 1 mapchange*mhirank 1 0 0 0 0;
	estimate 'Within-county effect of MAP for 2nd Highest House Income County' mapchange 1 mapchange*mhirank 0 1 0 0 0;
	estimate 'Within-county effect of MAP for Middle House Income County' mapchange 1 mapchange*mhirank 0 0 1 0 0;
	estimate 'Within-county effect of MAP for 2nd Highest House Income County' mapchange 1 mapchange*mhirank 0 0 0 1 0;
	estimate 'Within-county effect of MAP for Highest House Income County' mapchange 1 mapchange*mhirank 0 0 0 0 1;
run;
 
 
*pov  gp card pulm bed intbed;
proc mixed data=ldata  order=data method=ML;
	class fips  year;
	weight ffs;
	model cost= map year hcc   mhi pov  gp card pulm bed intbed /solution chisq cl;
	repeated year/type=un subject=fips  ;
run;



proc mixed data=ldata  order=data ;
	class fips  year;
	weight ffs;
	model cost= map year  /solution chisq cl;
	repeated year/type=un subject=fips  ;
run;
proc mixed data=ldata  order=data ;
	class fips  year;
	weight ffs;
	model cost= map year   mhi pov  gp card pulm bed intbed/solution chisq cl;
	repeated year/type=un subject=fips  ;
run;
proc mixed data=ldata  order=data ;
	class fips  year;
	weight ffs;
	model cost= map year hcc   mhi pov  gp card pulm bed intbed/solution chisq cl;
	repeated year/type=un subject=fips  ;
run;
 
proc mixed data=ldata  order=data ;
	class fips  year;
	weight ffs;
	model cost= map year hcc md white black native hispanic mhi pov  gp card pulm bed intbed/solution chisq cl;
	repeated year/type=un subject=fips  ;
run;
 


*Table 1 and 2;
proc format;
value g_
1="Loss: MAP2013-MAP2007 <=-5"
2="No Change: -5<MAP2013-MAP2007 <=5"
3="Small Change: 5<MAP2013-MAP2007 <=15"
4="Big Change: MAP2013-MAP2007 >15"
;
quit;
data temp;
set map.data;
mapdiff=map2013-map2007;
costdiff=cost2013-cost2007;
if mapdiff<=-5 then g=1;
else if mapdiff<=5 then g=2;
else if mapdiff<=15 then g=3;
else g=4;
format g g_.;
HCC=(hcc2007+hcc2008+hcc2009+hcc2010+hcc2011+hcc2012+hcc2013)/7;
 
MHI=(MHI2007+MHI2008+MHI2009+MHI2010+MHI2011+MHI2012+MHI2013)/7;
pov=mean(pov2007,pov2008,pov2009,pov2010,pov2011,pov2012,pov2013)/100;
MDr=(MDr2007+MDr2008+MDr2009+MDr2010+MDr2011+MDr2012+MDr2013)/7;
GPr=(GPr2007+GPr2008+GPr2009+GPr2010+GPr2011+GPr2012+GPr2013)/7;
Cardr=(Cardr2007+Cardr2008+Cardr2009+Cardr2010+Cardr2011+Cardr2012+Cardr2013)/7;
pulmr=(pulmr2007+pulmr2008+pulmr2009+pulmr2010+pulmr2011+pulmr2012+pulmr2013)/7;
bedr=(bedr2007+bedr2008+bedr2009+bedr2010+bedr2011+bedr2012+bedr2013)/7;
intbedr=(intbedr2007+intbedr2008+intbedr2009+intbedr2010+intbedr2011+intbedr2012+intbedr2013)/7;
 white=white/100;
 black=black/100;
 native=native/100;
 hispanic=hispanic/100;

 proc sort data=temp;by  g;
 run;
 %macro effectplot(var=);
proc genmod data=temp order=data;
class g;
model costdiff=g &var.  ;  
effectplot / at(g=all)  ;
*effectplot slicefit(sliceby=g  ) / noobs; 
run;
%mend effectplot;
%effectplot(var= );
%effectplot(var=hcc);
%effectplot(var=mhi);
%effectplot(var=pov);
%effectplot(var=GPr);
%effectplot(var=pulmr);
%effectplot(var=bedr);
%effectplot(var=intbedr);
%effectplot(var=white);
%effectplot(var=black);
%effectplot(var=hispanic);
%effectplot(var=native);
%effectplot(var=mdr);
*keep  pop region county costdiff mapdiff map2007 g hcc white black native hispanic  mhi pov mdr gpr cardr pulmr bedr intbedr;
proc sort ;by g;
run;
 
proc freq data=temp ;tables g;run;

proc means data=temp nway mean;
class g;label mapdiff='Average MA Penetration Rate Change From 2007 to 2013';
var mapdiff;
proc anova data=temp;class g;model mapdiff=g;
run;

proc means data=temp nway mean;
class g;label map2007='Average MA Penetration Rate at 2007';
var map2007;
proc anova data=temp;class g;model map2007=g;
run;


proc means data=temp nway mean;
class g;label costdiff='Average Cost(Standardized Risk-Adjusted Per Capita) Change From 2007 to 2013';
var costdiff;
proc anova data=temp;class g;model costdiff=g;
run;


proc means data=temp nway mean;
class g;label mapdiff='Average Cost 2007';
var cost2007;run;
proc anova data=temp;class g;model cost2007=g;
run;


proc means data=temp nway mean;
class g;label hcc='Average HCC Score';
var hcc;
proc anova data=temp;class g;model hcc=g;
run;
 
proc means data=temp nway mean;
class g;label white='Average Percent White Population 2010';
var white;
proc anova data=temp;class g;model white=g;
run;

proc means data=temp nway mean;
class g;label Black='Average Percent Black/African Am Pop 2010';
var Black;
proc anova data=temp;class g;model black=g;
run;

proc means data=temp nway mean;
class g;label native='Average Percent Am Ind/Alaska Natve Pop 2010';
var native;
proc anova data=temp;class g;model native=g;
run;

proc means data=temp nway mean;
class g;label hispanic='Average Percent Hispanic/Latino Pop 2010';
var hispanic;
proc anova data=temp;class g;model hispanic=g;
run;

proc means data=temp nway mean;
class g;label mhi='Average Median Household Income';
var mhi;
proc anova data=temp;class g;model mhi=g;
run;

proc means data=temp nway mean;
class g;label pov='Average % Persons Below Poverty Level';
var pov;
proc anova data=temp;class g;model pov=g;
run;

proc means data=temp nway mean;
class g;label mdr='Average HRR-level Total Active MDs serving per 1000 county population';
var mdr;
proc anova data=temp;class g;model mdr=g;
run;

proc means data=temp nway mean;
class g;label gpr='Average HRR-level Total Active General Proctice MDs serving per 1000 county population';
var gpr;
proc anova data=temp;class g;model gpr=g;
run;

proc means data=temp nway mean;
class g;label cardr='Average HRR-level Total Active Cadiovas Dis(Specialty) MDs serving per 1000 county population';
var cardr;
proc anova data=temp;class g;model cardr=g;
run;

proc means data=temp nway mean;
class g;label pulmr='Average HRR-level Total Active Pulmonary Dis(Specialty) MDs serving per 1000 county population';
var pulmr;
proc anova data=temp;class g;model pulmr=g;
run;

proc means data=temp nway mean;
class g;label bedr='Average HRR-level Total Hospital Beds serving per 1000 county population';
var bedr;
proc anova data=temp;class g;model bedr=g;
run;

proc means data=temp nway mean;
class g;label intbedr='Average HRR-level Total Intensiven Care Beds serving per 1000 county population';
var intbedr;
proc anova data=temp;class g;model intbedr=g;
run;

proc freq data=temp;tables region*g/nocum nopercent chisq;run;


proc means data=temp nway mean;
class g; Label pop='Average County Population 2010 Census';
var pop;
proc anova data=temp;class g;model pop=g;
run;
 
