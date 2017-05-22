*****************************************************
Hartford Grant Phase 3 Analytics
Xiner Zhou
3/7/2016
****************************************************;
libname data 'C:\data\Projects\Hartford\Data';
libname cr 'C:\data\Data\Hospital\Cost Reports';

data cr08to13;
set cr.Cost_reports_2008(in=in2008) cr.Cost_reports_2009(in=in2009) cr.Cost_reports_2010(in=in2010) 
    cr.Cost_reports_2011(in=in2011) cr.Cost_reports_2012(in=in2012) cr.Cost_reports_2013(in=in2013) ;
keep totmargin opmargin  provider year ; 
 totmargin =  net_income/sum(net_pat_rev,tot_oth_inc); 
 opmargin  =  (sum(net_pat_rev,tot_oth_inc)-tot_op_exps)/sum(net_pat_rev,tot_oth_inc); 
 if in2008 then Year=2008;
 if in2009 then Year=2009;
 if in2010 then Year=2010;
 if in2011 then Year=2011;
 if in2012 then Year=2012;
 if in2013 then Year=2013;
 provider=prvdr_num ;
 if substr(provider,3,2) in ('00','01','02','03','04','05','06','07','08','09','13');
 proc sort;by year;
 proc corr ;
 by year;
 var totmargin opmargin ;
 proc means min p1 p5 p10 p25 median p75 p90 p95 p99 max mean;
 class year;
 var totmargin opmargin  ;
 proc reg;
 model totmargin=opmargin ;
 quit;

 * Compare Total Margin Across Year Within Hospital;
 proc sort data=cr08to13 nodupkey;by provider year;run;
proc transpose data=cr08to13 out=cr prefix=TotMargin;
id year;
by provider;
var totmargin;
run;

proc corr data=cr;
var TotMargin2008 TotMargin2009 TotMargin2010 TotMargin2011 TotMargin2012 TotMargin2013;
run;
   *Compare Operating Margin Across Year Within Hospital;
 proc sort data=cr08to13 nodupkey;by provider year;run;
proc transpose data=cr08to13 out=cr prefix=OPMargin;
id year;
by provider;
var opmargin;
run;

proc corr data=cr;
var opMargin2008 opMargin2009 opMargin2010 opMargin2011 opMargin2012 opMargin2013;
run;


 * ceiling effect of function adoption;
libname data 'C:\data\Projects\Hartford\Data';
proc transpose data=data.model1 out=model1;
by N;
id Parameter;
var Estimate;
run;

* those are estimated numbers, totoal function is between 0-10, reset;
data model1;
set model1;
if intercept>10 then intercept=10;
if intercept<0 then intercept=0;
drop _NAME_;

if year>0 then class="Increase Basic Functionality";
else if year<0 then class="Decrease Basic Functionality";
else if year=0 then class="Not change much";
run;
* plot growth versus baseline EHR adoption;
proc sgplot data=model1;
title "Basic EHR:starting # and correlation to increase over time";
title2 "Correlation= -0.70489";
scatter x=intercept y=year/group=class;
run;

* calculate correlation;
proc corr data=model1;
var intercept year;
run;


************************************
Look at each fucntion, when adopted
************************************;
data function;
set data.Hartford;
if respond2008=. then respond2008=0;if respond2009=. then respond2009=0;if respond2010=. then respond2010=0;
if respond2011=. then respond2011=0;if respond2012=. then respond2012=0;if respond2013=. then respond2013=0;
Nrespond=respond2008+respond2009+respond2010+respond2011+respond2012+respond2013;
if Nrespond>=3;
a1=a1_2008; b1=b1_2008; c1=c1_2008; d1=d1_2008; e1=e1_2008; f1=f1_2008; a2=a2_2008; b2=b2_2008; d2=d2_2008; c3=c3_2008; year=2008;output;
a1=a1_2009; b1=b1_2009; c1=c1_2009; d1=d1_2009; e1=e1_2009; f1=f1_2009; a2=a2_2009; b2=b2_2009; d2=d2_2009; c3=c3_2009; year=2009;output;
a1=a1_2010; b1=b1_2010; c1=c1_2010; d1=d1_2010; e1=e1_2010; f1=f1_2010; a2=a2_2010; b2=b2_2010; d2=d2_2010; c3=c3_2010; year=2010;output;
a1=a1_2011; b1=b1_2011; c1=c1_2011; d1=d1_2011; e1=e1_2011; f1=f1_2011; a2=a2_2011; b2=b2_2011; d2=d2_2011; c3=c3_2011; year=2011;output;
a1=a1_2012; b1=b1_2012; c1=c1_2012; d1=d1_2012; e1=e1_2012; f1=f1_2012; a2=a2_2012; b2=b2_2012; d2=d2_2012; c3=c3_2012; year=2012;output;
a1=a1_2013; b1=b1_2013; c1=c1_2013; d1=d1_2013; e1=e1_2013; f1=f1_2013; a2=a2_2013; b2=b2_2013; d2=d2_2013; c3=c3_2013; year=2013;output;
keep provider a1 b1 c1 d1 e1 f1 a2 b2 d2 c3 year;
run;
 
data function;
set function;

if a1 in (1,2) then a1_adopt=1;else if a1=. then a1_adopt=.;else a1_adopt=0;
if b1 in (1,2) then b1_adopt=1;else if b1=. then b1_adopt=.;else b1_adopt=0;
if c1 in (1,2) then c1_adopt=1;else if c1=. then c1_adopt=.;else c1_adopt=0;
if d1 in (1,2) then d1_adopt=1;else if d1=. then d1_adopt=.;else d1_adopt=0;
if e1 in (1,2) then e1_adopt=1;else if e1=. then e1_adopt=.;else e1_adopt=0;
if f1 in (1,2) then f1_adopt=1;else if f1=. then f1_adopt=.;else f1_adopt=0;
if a2 in (1,2) then a2_adopt=1;else if a2=. then a2_adopt=.;else a2_adopt=0;
if b2 in (1,2) then b2_adopt=1;else if b2=. then b2_adopt=.;else b2_adopt=0;
if d2 in (1,2) then d2_adopt=1;else if d2=. then d2_adopt=.;else d2_adopt=0;
if c3 in (1,2) then c3_adopt=1;else if c3=. then c3_adopt=.;else c3_adopt=0;

label a1_adopt ="Adoption of a Basic EHR:Patient Demographics  ";
label b1_adopt ="Adoption of a Basic EHR:Physician Notes ";
label c1_adopt ="Adoption of a Basic EHR:Nursing Notes ";
label d1_adopt ="Adoption of a Basic EHR:Problem Lists ";
label e1_adopt ="Adoption of a Basic EHR:Medication Lists ";
label f1_adopt ="Adoption of a Basic EHR:Discharge Summaries ";
label a2_adopt ="Adoption of a Basic EHR:View Laboratory Reports ";
label b2_adopt ="Adoption of a Basic EHR:View Radiology Reports ";
label d2_adopt ="Adoption of a Basic EHR:View Diagnostic Test Results ";
label c3_adopt ="Adoption of a Basic EHR:CPOE Medication ";

run;

%macro loop(q=);
proc means data=function;
class year;
var &q._adopt;
output out=&q. mean=&q.pct;
run;

data &q.;
set &q.;
keep year &q.pct;
if year ne .;
proc sort;by year;
run;
%mend loop;
%loop(q=a1);
%loop(q=b1);
%loop(q=c1);
%loop(q=d1);
%loop(q=e1);
%loop(q=f1);
%loop(q=a2);
%loop(q=b2);
%loop(q=d2);
%loop(q=c3);
data plot;
merge a1 b1 c1 d1 e1 f1 a2 b2 d2 c3;
by year;
run;

data lplot;
length question $100.;
set plot;
pct=a1pct;function="Patient Demographics  ";output;
pct=b1pct;function="Physician Notes ";output;
pct=c1pct;function="Nursing Notes ";output;
pct=d1pct;function="Problem Lists ";output;
pct=e1pct;function="Medication Lists";output;
pct=f1pct;function="ADischarge Summaries ";output;
pct=a2pct;function="View Laboratory Reports ";output;
pct=b2pct;function="View Radiology Reports ";output;
pct=d2pct;function="View Diagnostic Test Results ";output;
pct=c3pct;function="CPOE Medication ";output;
run;

 
proc sgpanel data=lplot;
title "Individual Basic Function";
panelby function/ columns=2;format pct percent7.2;
vline year/response=pct datalabel=pct ;
run;
 

 
/*
Here is my summary of Ashish's feedback on the Hartford results, and next steps (most of which are analytic)

(1) What are the right research questions?

Set up the fact that the literature has not consistently found benefits from EHR adoption on hospital outcomes.  
Raises the question of whether benefits take time.  In the paper, we examine time in a detailed way, by addressing 
the following questions:

- Does it take time to see benefits from EHR adoption, holding baseline performance constant?  
(Get at this with starting number and maturity measures).

- Does adding more EHR functions over time help or hurt?  E.g., it could be beneficial or distracting. 

- Do these relationships vary by hospital type, specifically for the speed of adding new functions?  
Specifically, examine safety-net hospitals (top DSH quartile vs others) because they may struggle with complexity of adding 
a lot quickly; examine size because large hospitals may be able to do a lot of change at once while small hospitals may have 
to substitute EHR adoption for other QI efforts; teaching (for similar reasons as size); and urban/rural (access to technology skills). 

(2) Empirically this means a few things:

- Add control for hospital financial health.  Ashish said that Jie has a spreadsheet with hospital total margins and operating margins.
Let's see how strongly correlated they are and then decide whether to add one or both.  
Also, are they annual or just available for a single year?  Please decide how best to add to models given these questions.

- We need to somehow factor in baseline level of function adoption because of ceiling effect 
(i.e., those that start with a lot can't add a lot over time).  
Ashish suggested running stratified analyses based on # of functions adopted at baseline.  
Sunny, would be great if you can do some thinking about how best to address this, 
and maybe look at distributions of starting # and correlation to increase over time to inform the best empirical approach. 

- specific functions adopted, once we look at prior issue, we need to think about what specific functions are adopted when.  
that is, starting at 4 CPOE functions is likely very different that starting at 4 clinical documentation functions.  
In a prior study, Jordan and I found that there is a typical sequence in which hospitals adopt EHR functions, 
but we may need to examine that in this study as well.  it may be as simple as looking at the heterogeneity in functions 
that are in place in year 1?  if not a lot of difference, we should be ok.  

- add in new results that stratify by safety net status, teaching status
 
(3) Presentation decision

- move 90-day measures to appendix as sensitivity analysis

- don't focus on presentation in next round; instead let's get results and story down, then decide how to present

Realize this is a lot in one email.  Sunny, if you can digest and then propose a plan to Xiner for the next set of models, that would be great.

Let me know what questions you have -- now and along the way!
*/





* Examine total margin and operating margin;
/* Operating Margin = (Total Operating Revenue - Total Operating Expenses)/Total Operating Revenue
   The operating margin is the most commonly used financial ratios to measure a hospital's financial performance.
   It compares a hospital's total operating revenue against total operating expenses, often referred to as net from operations.
   If total operating revenue exceeds total operating expenses, the hospital is operating at a profit and will have a positive 
   operating margin; whereas, if total operating revenue is less than total operating expenses, the hospital is operating at a loss
   and will have a negative operating margin.
   
   # total operating revenue : is the sum of net patient revenue and other operating revenue
      # Net patient revenue: is the amount received from third-party payers(insurers) and patients for hospital services provided.
      # Other operating revenue: is the amount received from non-patients for services related to hospital operatins. This inculdes items
                                 such as cafeteria sales, refunds on purchase, vending machine commissions, parking lot revenue... 
                                 Since other operating revenue typically comprises between 2% to 4% of a hospital's total operating revenue,
                                 it often determins if a hosptial's operating margin is "in the black"(profit) or "in the red"(loss).

   # total operating expenses: include all expenses associated with operating the hospital, such as salaries, employee benefits, purchased services,
                               supplies, professional fees, depreciation, rentals, interest, and insurance.
*/

/* Total Margin = Net Income/Total Operating Revenue
   The key difference from the operating margin is that the total margin factors in non-oeprating revenues and expenses, 
   the provision for income taxes, and any extraordinary items. Total margin may differ significantly from the opearting 
   margin if substantial amounts of non-operating revenue or expensese are reported. 

	  # net income (AKA "Bottom Line") is the excess of revenue over expenses. 
      # non-operating revenue: is the amount received from non-patients which do not related to hosptial care.
                               Examples of non-operating revenue include investment income, unrestricted contributions, medical 
                               office building revenue, gift shop revenue, and governmental appropriates (public hospital only)
      # non-operating expenses: include costs incurred related to producing non-operating revenue
*/



/* Sunny:
1.	Add control for financial health for existing models (Size and urban/rural status)
2.	Add stratified analysis for teaching/non teaching
3.	Add stratified analysis for safety net/not safety net
4.	Add stratified analysis for level of adoption in year 


WeÅfd like one that stratifies hospitals with < 4 starting basic functionalities into:
 
1. 0 starting functionalities (n=1877)
2. starting functionalities in documentation and results only (a1_2008 b1_2008 c1_2008 d1_2008 e1_2008 f1_2008 a2_2008 b2_2008 d2_2008)- should be n=177
3. starting functionalities in documentation only (a1_2008 b1_2008 c1_2008 d1_2008 e1_2008 f1_2008)- should be n=124
4. starting functionalities in results only (a2_2008 b2_2008 d2_2008)- should be n=107


For this particular analysis, you can drop them. Julia wants to use this as a robustness test to support whatever findings we get from the stratified analyses with early, mid, and late adopters (#5 in this list). YouÅfll also end up throwing out ~19 hospitals that have CPOE functions
1. Size
2. Urban/Rural
3. Teaching/Non-Teaching
4. Safety Net/ Non Safety Net
5. Early/Mid/Late Adopters (< 4, 4-7, >8 Functionalities at Baseline)
5b. Stratified-Stratified Analysis: Of hospitals with < 4 Baseline functionalities, compare adopters of none, documentation and results viewing, documentation only, results only 
