***************************************
Association between Standardized Risk-Adjusted Per Capita Costs and MA Participation Rate, Longitudinal Effect
Xiner Zhou
3/5/2015
***************************************;

libname data 'C:\data\Projects\APCD High Cost\Longitudinal';

proc import datafile="C:\data\Projects\APCD High Cost\Longitudinal\cost" dbms=xls out=cost replace;
getnames=yes;
run;

data cost;
set cost;
if zip ne '.' ;
if rate2013 ='*' then rate2013='';
if rate2012 ='*' then rate2012='';
if rate2011 ='*' then rate2011='';
if rate2010 ='*' then rate2010='';
if rate2009 ='*' then rate2009='';
if rate2008 ='*' then rate2008='';
if rate2007 ='*' then rate2007='';
if y2013 ='*' then y2013='';
if y2012 ='*' then y2012='';
if y2011 ='*' then y2011='';
if y2010 ='*' then y2010='';
if y2009 ='*' then y2009='';
if y2008 ='*' then y2008='';
if y2007 ='*' then y2007='';
x2013=rate2013*1;x2012=rate2012*1;x2011=rate2011*1;x2010=rate2010*1;x2009=rate2009*1;x2008=rate2008*1;x2007=rate2007*1;
cost2013=y2013*1;cost2012=y2012*1;cost2011=y2011*1;cost2010=y2010*1;cost2009=y2009*1;cost2008=y2008*1;cost2007=y2007*1;
id=_n_-2;
name=trim(county)||','||state;
drop zip rate2007 rate2008 rate2009 rate2010 rate2011 rate2012 rate2013 y2007 y2008 y2009 y2010 y2011 y2012 y2013;
run;

%macro year(yr=);
goptions reset=all;
axis1 label=(a=90 'Standardized Risk-Adjusted Per Capita Costs');
axis2 label=('MA Participation Rate');
SYMBOL1 V=star C=blue I=r;
PROC GPLOT DATA=cost;
     title "&yr. Standardized Risk-Adjusted Per Capita Costs vs MA Participation Rate";
     PLOT cost&yr.*x&yr. /vaxis=axis1 haxis=axis2;
	 
RUN;
proc reg data=cost;
model cost&yr.=x&yr.;
run;
proc corr data=cost;
var cost&yr. x&yr.;
run;
%mend year;
%year(yr=2013);
%year(yr=2012);
%year(yr=2011);
%year(yr=2010);
%year(yr=2009);
%year(yr=2008);
%year(yr=2007);

 

* transpose from wide format to long format;
data cost_l;
set cost;
y=cost2007;x=x2007;time=0;t=1;year=2007;output;
y=cost2008;x=x2008;time=1;t=2;year=2008;output;
y=cost2009;x=x2009;time=2;t=3;year=2009;output;
y=cost2010;x=x2010;time=3;t=4;year=2010;output;
y=cost2011;x=x2011;time=4;t=5;year=2011;output;
y=cost2012;x=x2012;time=5;t=6;year=2012;output;
y=cost2013;x=x2013;time=6;t=7;year=2013;output;
keep id name x y time t year;
run;
 
%macro stat(var=,title=);
*Descriptive stat: Mean & Stderr, then plot mean with error bar over time;
proc sort data=cost_l;by time;run; 
proc means data=cost_l noprint;                                                                                                           
   by year;                                                                                                                             
   var &var.;                                                                                                                            
   output out=Q2(drop=_freq_ _type_) mean=mean stderr=stderr;    
	proc print noobs; 
run;  
                                                                                                  
goptions reset=all cback=white border htext=10pt htitle=12pt;                                                                           
  
*Reshape the data to contain three Y values for each occasion: Mean and std error bar;                                                                                                                                                                      
data reshape;                                                                                                      
   set Q2;                                                                                                                        
   yplot=mean; output;                                                                                                                              
   yplot=mean-stderr; output;                                                                                                                         
   yplot=mean + stderr; output;                                                                                                                                                                                                                                                  
run;                                                                                                                                    
                                                                                            
proc gplot data=reshape;  
   title1 'Means with Standard Error Bars Year 2007-2013';
axis1 label=(a=90 "&title."); 
   symbol1 interpol=hiloctj color=blue line=2;                                                                                          
   symbol2 interpol=none color=blue value=dot height=1.5;
	plot yplot*year mean*year/ overlay vaxis=axis1;     
run;   
%mend stat;
%stat(var=y,title=Standardized Risk-Adjusted Per Capita Costs);
 %stat(var=x,title=MA Participation Rate);


 
*Obtain the variance-covariance and correlation matrices for the repeated measurements over time;
proc corr data=cost  nosimple noprob;
var x2007 x2008 x2009 x2010 x2011 x2012 x2013;
run; 
proc corr data=cost  nosimple noprob;
var cost2007 cost2008 cost2009 cost2010 cost2011 cost2012 cost2013;
run; 






/*
The goal of the analysis is to determine how changes in Standardized Risk-Adjusted Per Capita Costs
over 6 years (2008-2013) and how is the change related to MA Participation Rate
*/

* Saturated Model, Method=REML ;
proc sort data=cost_l;by descending time;
proc mixed data=cost_l method=REML order=data;
	class id time t;
	model y=time x/solution chisq;
	repeated t/type=cs subject=id R RCORR;
run;

* Linear trend, Method=REML ;
proc mixed data=cost_l method=REML order=data;
	class id  t;
	model y=time x/solution chisq;
	random intercept time /type=un subject=id solution G V;
run;

 
