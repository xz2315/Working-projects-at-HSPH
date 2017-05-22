******************************************************************************
Filename:		Step2.sas
Purpose:        at least Basic EHR adoption rate Step2
Date:           07/08/2014
******************************************************************************;


/******************************************

(2) Difference-in-trend
- compare trend in at least basic EHR adoption for the years 2008-2010 versus 2011-2013 for eligible versus ineligible hospitals 
- if you have not run difference-in-trend models before, let me know (or better yet, ask Jie who has done many of them!)

********************************************/

/* longitudinal Trend Analysis;

***************
* Diff in Slope;
****************;
data allyear;
set final08 final09 final10 final11 final12 final13 final14 final15;
if year=2008 then time=1;
else if year=2009 then time=2;
else if year=2010 then time=3;
else if year=2011 then time=4;
else if year=2012 then time=5;
else if year=2013 then time=6;
else if year=2014 then time=7;
else if year=2015 then time=8;
keep id eligibility year time  basic_adopt wt;
run;

proc sort data=allyear;by id year;run;

 
proc genmod data=allyear descending ;
weight wt;
class id eligibility(ref="0") time(ref="1")  /param=ref;
model basic_adopt=eligibility year  eligibility*year  /dist=binomial link=logit;
repeated subject=id/withinsubject=time logor=exch  ;
run;



/* Plot the estimated logistic curve ;
options linesize=80;

data generate1;
do year1=2008 to 2013 by 0.01;
inelig=exp(-535.282+0.2649*year1)/(1+exp(-535.282+0.2649*year1));

output;
end;
run;

data generate2;
do year2=2008 to 2013 by 0.01;

elig=exp(-535.282-649.345+(0.2649+0.3237)*year2)/(1+exp(-535.282-649.345+(0.2649+0.3237)*year2));
output;
end;
run;
 
 

 
data generate;
merge generate1 generate2 step1_allyear_ineligible_graph;
run;


proc sgplot data=generate;
title "Estimated Logistic Regression Line of At Least Basic EHR Adoption";
scatter X=year y=rate/markerattrs=(symbol=STARFILLED) LEGENDLABEL ="True Rate";
series X=year1  y= inelig /lineattrs=(color=blue) LEGENDLABEL ='Ineligible Hospitals';
series X=year2  y= elig /lineattrs=(color=red)LEGENDLABEL ='Eligible hospitals';
 
xaxis label='Year' values=(2008 to 2013 by 1);
yaxis label='Adoption Rate';
run;
*/

*******************************
* Diff-in-Diff Model;
******************************;
data allyear;
set final08 final09 final10 final11 final12 final13;
if year=2008 then do;year=0; time=1;post=0;postyear=0;end;
else if year=2009 then do;year=1; time=2;post=0;postyear=0;end;
else if year=2010 then do;year=2; time=3;post=0;postyear=0;end;
else if year=2011 then do;year=3; time=4;post=1;postyear=1;end;
else if year=2012 then do;year=4; time=5;post=1;postyear=2;end;
else if year=2013 then do;year=5; time=6;post=1;postyear=3;end;
else if year=2014 then do;year=6; time=7;post=1;postyear=4;end;
else if year=2015 then do;year=7; time=8;post=1;postyear=5;end;
keep id eligibility  year  time  basic_adopt wt post postyear;
run;

proc sort data=allyear;by id year;run;

/*
proc genmod data=allyear descending ;
weight wt;
class id eligibility(ref="0") time(ref="1") post(ref="0")/param=ref;
model basic_adopt=eligibility post year1 eligibility*year1 post1 eligibility*post eligibility*post1/dist=binomial link=logit;
repeated subject=id/withinsubject=time logor=exch  ;
output out=predict p=pro l=lower u=upper;
* estimate "Post : Ineligible vs Eligible"  eligibility*year1  1  -1  eligibility*post*year1 1 -1/e; *Post : Ineligible vs Eligible;
* estimate "Eligible: Pre vs Post"  post*year1  1  -1  eligibility*post*year1 1 -1/e; * Eligible: Pre vs Post;
run;
*/
 
* Linear model;
proc genmod data=allyear descending  ;
weight wt;
class id eligibility(ref="0") time post(ref="0")/param=effect;
model basic_adopt=eligibility post year eligibility*year postyear eligibility*post eligibility*postyear/dist=normal link=identity corrb;
repeated subject=id/withinsubject=time type=un  ;
output out=predict p=pro l=lower u=upper;

estimate "In-Elligible Pre" year 1 ;
estimate "In-Elligible Post" year 1 postyear 1 ;

estimate "Eligible Pre" year 1 eligibility*year 1  ;
estimate "Eligible Post" year 1 eligibility*year 1  postyear 1  eligibility*postYear 1 ;

estimate "Diff In-Elligble Post vs Pre"  postYear 1 ;
estimate "Diff Eligible Post vs Pre" postYear 1  eligibility*postYear 1 ;

estimate "Diff Pre Eligible vs In-Elligble" eligibility*year  1;
estimate "Diff Post Eligible vs In-Elligble" eligibility*year  1 eligibility*postYear 1 ;

estimate "Diff-in-Diff" eligibility*postYear 1 ;
run;

/* Equivalent: Linear model;
proc genmod data=allyear descending ;
weight wt;
class id eligibility(ref="0") time(ref="1") post(ref="0")/param=ref;
model basic_adopt=eligibility post year1 eligibility*year1 post*year1 eligibility*post eligibility*post*year1/dist=normal link=identity;
repeated subject=id/withinsubject=time type=un  ;
output out=predict p=pro l=lower u=upper;
run;

* Linear Marginal Model Spline joint at 2010 with predicted mean;
proc mixed data=allyear;
weight wt;
class id eligibility time post;
model basic_adopt=eligibility  year1 eligibility*year1 post1  eligibility*post1/solution chisq outpred=yhat;
repeated time/subject=id  type=un R Rcorr ;
run;

proc sort data=yhat nodupkey;by pred ;run;
proc sort data=yhat  ;by year1 eligibility ;run;
proc sgplot data=yhat;
series X=year1 y=pred/group=eligibility;
run;


* Linear Mixed Model Spline joint at 2010 with predicted individual ;
 
proc mixed data=allyear ;
weight wt;
class id eligibility time post;
model basic_adopt=eligibility  year1 eligibility*year1 post1  eligibility*post1/solution chisq outpred=yhat;* individual estimate;
random intercept year1/subject=id solution type=un G V;
run;
 
/*
proc sort data=predict out=temp(keep=pro  year1 eligibility) nodupkey;by year1 eligibility pro  ;run;

ods _all_ close;
ods tagsets.ExcelXP path='C:\data\Projects\HIT EHR Adoption' file='step1.xml' style=Printer;

proc print data= step1_graph;run;
proc print data= predict;run;
ods tagsets.ExcelXP close;

*/

********************************************
Logistic Regression Plots and Interpretation
********************************************;

/* Plot the estimated regression line;
options linesize=80;

data generate1;
do year1=0 to 2 by 0.02;
pre_ineligible=0.0459+0.0008*year1;output;
end;
run;
data generate2;
do year2=0 to 2 by 0.02;
pre_eligible=0.0459+0.0402+(0.0008+0.0300)*year2;output;
end;
run;

data generate3;
do year3=3 to 5 by 0.02;
post_ineligible=0.0459-0.0083+0.0008*year3+0.0285*(year3-2) ;output;
end;
run;
data generate4;
do year4=3 to 5 by 0.02;
post_eligible=0.0459+ 0.0402-0.0083 -0.0344+(0.0008+0.0300)*year4+(0.0285+0.0978)*(year4-2) ;output;
end;
run;

 
data generate;
merge generate1 generate2 generate3 generate4 step1_allyear_ineligible_graph;
year=year-2008;
run;

 
proc sgplot data=generate;
title "Estimated Linear Regression Line of At Least Basic EHR Adoption";
scatter X=year y=rate/markerattrs=(symbol=STARFILLED) LEGENDLABEL ="True Rate";
series X=year1 y=pre_ineligible/lineattrs=(color=blue) LEGENDLABEL ='Pre-period Ineligible';
series X=year2 y=pre_eligible/lineattrs=(color=red)LEGENDLABEL ='Pre-period Eligible';
series X=year3 y=post_ineligible/lineattrs=(color=green) LEGENDLABEL ='Post-period Ineligible';
series X=year4 y=post_eligible/lineattrs=(color=purple)LEGENDLABEL ='Post-period Eligible';
xaxis label='Year' values=(0 to 5 by 1);
yaxis label='Adoption Rate';
run;
*/














 




