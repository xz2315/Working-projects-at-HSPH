*************************************
Follow-up requests
Xiner Zhou
4/25/2016
************************************;
libname data 'C:\data\Projects\Hartford\Data\data';
libname cr 'C:\data\Data\Hospital\Cost Reports';
 
/*
1.	Correct the Label for Early, Mid, Late Adoption to  (>8, 4-7, 0-3) 
 
2.	Model is Random Intercept model, I plan on asking John about this tomorrow just to confirm this is the right model to use if we want to control for other factors such as size, geographic, etc. 
 
3.	RUCA- right now we are just doing urban/rural; Can we add suburban as a category as well? For this, the RUCA codes should be recoded as: 
urban (RUCA code 1), suburban (RUCA codes 2 through 6), and rural (RUCA codes 7 through 10)
 
4.	Teaching- we can keep teaching as 2 categories, as is, no need to change anything 

5.	Regarding PQI�fs- It sounds to me like Jie is recommending using state-level PQI�fs instead of hospital specific PQI�fs? can we do this at the HRR level? That is, can you run correlations between PQI�fs of hospitals in the same HRR; and ask Jie whether she thinks this is a good option? [Julia: do you have a  preference for HRR vs State level PQI?]
 
In Addition, we thought of a couple other things to ask you to do:
1.	Add Length of Stay as another outcome variable 
 
2.	Can you find out how many years of data we have for the EHR vendor question on the IT supplement? (Questions 14a and 14b on the 2014 Survey); we are interested in adding another stratification analysis, one that looks at hospitals who have the same EHR for both inpatient and outpatient.
?  Except the first 2 years (2008 and 2009) ,we have data for these, but it�fs free-text response, looks little messy, I attached one year�fs tabulation about answers, may need careful categorization.
SUNNY can you take a look and decide what you think makes sense? 

3.      Control for other QI initiatives (By merging the data from Ashish�fs NIH survey with our current dataset 
?  Yes, I have worked on this survey, here also attached the questionair in the survey, please let me know what is the definition of QI initiative.
 SUNNY can you take a look and decide what you think makes sense in terms of vars that detect strategies for reducing readmissions?  we may then want to look at correlations between them before selecting final measures.
 

Finally there are some things that we are looking into that might change the models
1.	Control for community SES [Confirm with Zoe how to do this]
 
2.	Add the following stratified analyses: [To confirm with Julia]
1.	CPOE & Physician Notes/ CPOE only/ PN only/ neither
2.	Had Medication CPOE and PN 2008-2010/ Adopted Medication CPOE and PN 2011-2013/ everyone else
?   For CPOE & Physicain Notes / CPOE only / PN only / neither, are we looking at 2008?
    For (1) we want to look at any point -- were those functions ever adopted over the entire time period.
*/




/*
As for the other stuff, here is a list of stuff that we need:
1.	Summary Statistics of QI Data Variables
2.	Add variable for vendor has same inpatient and outpatient vendor (use the variable from the 2014 data set Question 16b for now, if this is significant, we can create variables for the other years)
3.	Add LOS as an outcome variable
4.	Control for community SES
5.	Add the following stratified analyses:
	1.	CPOE & Physician Notes/ CPOE only/ PN only/ neither at any point adopted over the entire period
	2.	Had Medication CPOE and PN 2008-2010/ Adopted Medication CPOE and PN 2011-2013/ everyone else
*/





/*
From yesterday's meeting, we've discussed:

1. the concern about whether we have appropriately adjusting for hospital characteristics, if not, how to do it. 

Per John's suggestion, we couldn't do hospital fixed effect, because we have Starting N and Slope N which is hospital-level constant, 
even though they are interacting with time, the interactions are still constant because we fixed time. So FE is not going to run 
technically. The current overall and stratified models result do align to each other, if we compare effect estimates, overall effect 
is between stratified effects, which is what they are supposed to be. One thing we could do to improve, include all hospital 
structural characteristics that we subsequently do stratified analyses (about 7s), 
so our models are consistent and also adjust to our best. John expect the results will only have minor tweet. 

Please let me know if this approach address reviewers' concern.

2. As Sunny described below, could be one option, but we need more time to think about it. 
I'm not fully understand how to finally get the link between hospital E.H.R. to market PQI. 
Please let me know what might be the best option.

*/

/*
Hi Xiner!

I hope you had a wonderful vacation!

We spoked with John last week and looked over the models you sent us. They are definitely a step up from what we had before. We were a little concerned after 
looking at the overall model because we lost statistical significance on some of our main variables. We want to know whether this is due to an actual effect after
putting in the controls, or whether this is due to lost of power from a smaller number of observations. 

To figure this out, could you run the overall model adding each control in one by one and give us each model with the number observations for each model? 
We just need models for 30 day mortality, 30 day readmissions and LOS (from now on, we are going to drop 90 day mortality, 90 day readmissions and PQI, 
so you only have to run the models for 3 outcomes!)

So specifically, can you run these models for 30 day mort, 30 day read, and LOS and report estimated coefficients and number of observations:
1.	Regular model, no controls
2.	Add in op margin control
3.	Add in op margin and RUCA as control
4.	Add in op margin, RUCA, and teaching status as control
5.	Add in op margin, RUCA, teaching status, and size as control
6.	Add in op margin, RUCA, teaching status, size, and DSH pct as a control

Thanks!

-Sunny
*/

/*
Hi Xiner, on top of the below, could you send us the sample sizes for each stratified model as well? Actually- from now on, 
could you send us sample size with each model? That would help immensely. Thanks!!
*/

/*
Hi Xiner!

After you�fre done sending me the controls and getting observation sizes for the stratified models, could you calculate some p-values for us?

We want to create a difference in differences table for the results (see DD Tables tab in the attached workbook). 
The differences we are interested in 
1) difference between 0-5 year outcomes and 
2) difference in difference between 1 for average adopting hospitals (6.42 start, 0 slope) and non adopting (0 start, 0 slope) hospitals. 
I can do most of this in excel, but we�fd like to also obtain p-values for the differences in difference. 

Can you get those for us? The math to get the standard deviation for the differences in differences seems a little bit cumbersome to do in excel. 
I�fm wondering if SAS has something built in for that.

Thanks!

-Sunny
*/

/*
Post-Estimation:

Estimate Change score 0-5 Year Difference: Adopter vs Non-Adopter, Diff-in-Diff

Average hospital based on 6.42 starting EHR functions and slope of 0.5 per year
For urban, non-teaching,medium sized hospitals with OP margin of 0.03 and DSH of 0.4

Overall
Same Vendor/Different Vendor
CPOE and PN/CPOE Only/PN Only/Neither
Had CPOE and PN in 2008-2010/Had CPOE and PN in 2011-2013/Neither
Urban/Suburban/Rural
Small/Medium/Large
Teaching/Non Teaching
Safety/ Non Safety
Early/Mid/Late Adopters
Of Late Adopters: Documentation and Results at Baseline/Results Viewing at Baseline/Documentation at Baseline/Neither

 
*/





* Add Operating Margin;
%macro Margin(yr=);
data margin&yr.;
set cr.Cost_reports_&yr. ;
keep totmargin&yr. opmargin&yr.  provider ; 
totmargin&yr. =  net_income/sum(net_pat_rev,tot_oth_inc); 
opmargin&yr.  =  (sum(net_pat_rev,tot_oth_inc)-tot_op_exps)/sum(net_pat_rev,tot_oth_inc); 
provider=prvdr_num ;
proc sort nodupkey;by provider;
run;
%mend Margin;
%Margin(yr=2008);
%Margin(yr=2009);
%Margin(yr=2010);
%Margin(yr=2011);
%Margin(yr=2012);
%Margin(yr=2013);
%Margin(yr=2014);
%Margin(yr=2015);

proc sort data=data.Hartford;by provider;run;
data Hartford;
merge data.Hartford(in=in1) margin2008 margin2009 margin2010 margin2011 margin2012 margin2013;
by provider;
if in1=1;
proc sort nodupkey;by provider;
run;
 
* if condition-specific mortality/readmission/los is missing, then set to 0;
data hartford;
set hartford;
array temp {2436} RawAMIReadm302008--NLOShipfx2013;
do i=1 to 2436;
 if temp{i}=. then temp{i}=0;
end;
run;

 

*************************************************************
Count Response Years  
*************************************************************;
data hartford;
set hartford;
if respond2008=. then respond2008=0;if respond2009=. then respond2009=0;if respond2010=. then respond2010=0;
if respond2011=. then respond2011=0;if respond2012=. then respond2012=0;if respond2013=. then respond2013=0;
Nrespond=respond2008+respond2009+respond2010+respond2011+respond2012+respond2013;
proc freq;tables Nrespond;
proc sort;by provider;
run;
  


****************************************************************
Create Composite Score
****************************************************************;
data hartford;
set hartford;
array temp {2160} RawAMIReadm302008--Nhipfxmort902013;
do i=1 to 2160;
if temp{i}=. then temp{i}=0;
end;
run;

%macro comp(meas=,day=,yr=);
proc sql;
create table &meas.&day.&yr. as
select provider, 
sum(obsAMI&meas.&day.&yr.) as sumobsAMI&meas.&day.&yr., sum(obsCHF&meas.&day.&yr.) as sumobsCHF&meas.&day.&yr., sum(obsPN&meas.&day.&yr.) as sumobsPN&meas.&day.&yr., 

       sum(NAMI&meas.&day.&yr.) as sumNAMI&meas.&day.&yr., sum(NCHF&meas.&day.&yr.) as sumNCHF&meas.&day.&yr., sum(NPN&meas.&day.&yr.) as sumNPN&meas.&day.&yr.,

	   (calculated sumobsAMI&meas.&day.&yr. + calculated sumobsCHF&meas.&day.&yr. + calculated sumobsPN&meas.&day.&yr.)
       /(calculated sumNAMI&meas.&day.&yr. + calculated sumNCHF&meas.&day.&yr. + calculated sumNPN&meas.&day.&yr.) as overall3cond&meas.&day.&yr.,

       (obsAMI&meas.&day.&yr.+obsCHF&meas.&day.&yr.+obsPN&meas.&day.&yr.)/(expAMI&meas.&day.&yr.+expCHF&meas.&day.&yr.+expPN&meas.&day.&yr.) as ratio3cond,
      (calculated overall3cond&meas.&day.&yr.)*(calculated ratio3cond) as adj3cond&meas.&day.&yr.,

	    sum(obsAMI&meas.&day.&yr.) as sumobsAMI&meas.&day.&yr., sum(obsCHF&meas.&day.&yr.) as sumobsCHF&meas.&day.&yr., sum(obsPN&meas.&day.&yr.) as sumobsPN&meas.&day.&yr., 
		sum(obscopd&meas.&day.&yr.) as sumobsCOPD&meas.&day.&yr., sum(obsstroke&meas.&day.&yr.) as sumobsstroke&meas.&day.&yr., sum(obssepsis&meas.&day.&yr.) as sumobssepsis&meas.&day.&yr., 
		sum(obsesggas&meas.&day.&yr.) as sumobsesggas&meas.&day.&yr., sum(obsgib&meas.&day.&yr.) as sumobsgib&meas.&day.&yr., sum(obsuti&meas.&day.&yr.) as sumobsuti&meas.&day.&yr., 
		sum(obsmetdis&meas.&day.&yr.) as sumobsmetdis&meas.&day.&yr., sum(obsarrhy&meas.&day.&yr.) as sumobsarrhy&meas.&day.&yr., sum(obschest&meas.&day.&yr.) as sumobschest&meas.&day.&yr., 
		sum(obsrenalf&meas.&day.&yr.) as sumobsrenalf&meas.&day.&yr., sum(obsresp&meas.&day.&yr.) as sumobsresp&meas.&day.&yr., sum(obshipfx&meas.&day.&yr.) as sumobshipfx&meas.&day.&yr., 

       sum(NAMI&meas.&day.&yr.) as sumNAMI&meas.&day.&yr., sum(NCHF&meas.&day.&yr.) as sumNCHF&meas.&day.&yr., sum(NPN&meas.&day.&yr.) as sumNPN&meas.&day.&yr.,
	   sum(Ncopd&meas.&day.&yr.) as sumNcopd&meas.&day.&yr., sum(Nstroke&meas.&day.&yr.) as sumNstroke&meas.&day.&yr., sum(Nsepsis&meas.&day.&yr.) as sumNsepsis&meas.&day.&yr.,
	   sum(Nesggas&meas.&day.&yr.) as sumNesggas&meas.&day.&yr., sum(Ngib&meas.&day.&yr.) as sumNgib&meas.&day.&yr., sum(Nuti&meas.&day.&yr.) as sumNuti&meas.&day.&yr.,
	   sum(Nmetdis&meas.&day.&yr.) as sumNmetdis&meas.&day.&yr., sum(Narrhy&meas.&day.&yr.) as sumNarrhy&meas.&day.&yr., sum(Nchest&meas.&day.&yr.) as sumNchest&meas.&day.&yr.,
	   sum(Nrenalf&meas.&day.&yr.) as sumNrenalf&meas.&day.&yr., sum(Nresp&meas.&day.&yr.) as sumNresp&meas.&day.&yr., sum(Nhipfx&meas.&day.&yr.) as sumNhipfx&meas.&day.&yr.,

	   (calculated sumobsAMI&meas.&day.&yr. + calculated sumobsCHF&meas.&day.&yr. + calculated sumobsPN&meas.&day.&yr.
       +calculated sumobscopd&meas.&day.&yr. + calculated sumobsstroke&meas.&day.&yr. + calculated sumobssepsis&meas.&day.&yr.
       +calculated sumobsesggas&meas.&day.&yr. + calculated sumobsgib&meas.&day.&yr. + calculated sumobsuti&meas.&day.&yr.
       +calculated sumobsmetdis&meas.&day.&yr. + calculated sumobsarrhy&meas.&day.&yr. + calculated sumobschest&meas.&day.&yr.
       +calculated sumobsrenalf&meas.&day.&yr. + calculated sumobsresp&meas.&day.&yr. + calculated sumobshipfx&meas.&day.&yr.)
       /(calculated sumNAMI&meas.&day.&yr. + calculated sumNstroke&meas.&day.&yr. + calculated sumNPN&meas.&day.&yr.
        +calculated sumNcopd&meas.&day.&yr. + calculated sumNstroke&meas.&day.&yr. + calculated sumNsepsis&meas.&day.&yr.
		+calculated sumNesggas&meas.&day.&yr. + calculated sumNgib&meas.&day.&yr. + calculated sumNuti&meas.&day.&yr.
		+calculated sumNmetdis&meas.&day.&yr. + calculated sumNarrhy&meas.&day.&yr. + calculated sumNchest&meas.&day.&yr.
		+calculated sumNrenalf&meas.&day.&yr. + calculated sumNresp&meas.&day.&yr. + calculated sumNhipfx&meas.&day.&yr.) as overall15cond&meas.&day.&yr.,

       (obsAMI&meas.&day.&yr.+obsCHF&meas.&day.&yr.+obsPN&meas.&day.&yr.
        +obscopd&meas.&day.&yr.+obsstroke&meas.&day.&yr.+obssepsis&meas.&day.&yr.
        +obsesggas&meas.&day.&yr.+obsgib&meas.&day.&yr.+obsUTI&meas.&day.&yr.
        +obsmetdis&meas.&day.&yr.+obsarrhy&meas.&day.&yr.+obschest&meas.&day.&yr.
        +obsrenalf&meas.&day.&yr.+obsresp&meas.&day.&yr.+obshipfx&meas.&day.&yr.)
       /(expAMI&meas.&day.&yr.+expCHF&meas.&day.&yr.+expPN&meas.&day.&yr.
        +expcopd&meas.&day.&yr.+expstroke&meas.&day.&yr.+expsepsis&meas.&day.&yr.
        +expesggas&meas.&day.&yr.+expgib&meas.&day.&yr.+exputi&meas.&day.&yr.
        +expmetdis&meas.&day.&yr.+exparrhy&meas.&day.&yr.+expchest&meas.&day.&yr.
        +exprenalf&meas.&day.&yr.+expresp&meas.&day.&yr.+exphipfx&meas.&day.&yr.) as ratio15cond,
      (calculated overall15cond&meas.&day.&yr.)*(calculated ratio15cond) as adj15cond&meas.&day.&yr.  

from Hartford;
quit;

proc sort data=&meas.&day.&yr. nodupkey ;by provider;run;
%mend comp;
%comp(meas=readm,day=30,yr=2008);
%comp(meas=readm,day=30,yr=2009);
%comp(meas=readm,day=30,yr=2010);
%comp(meas=readm,day=30,yr=2011);
%comp(meas=readm,day=30,yr=2012);
%comp(meas=readm,day=30,yr=2013);
 

%comp(meas=mort,day=30,yr=2008);
%comp(meas=mort,day=30,yr=2009);
%comp(meas=mort,day=30,yr=2010);
%comp(meas=mort,day=30,yr=2011);
%comp(meas=mort,day=30,yr=2012);
%comp(meas=mort,day=30,yr=2013);
 

%macro comp(meas=,yr=);
proc sql;
create table &meas.&yr. as
select provider, 
sum(obs&meas.AMI&yr.) as sumobs&meas.AMI&yr., sum(obs&meas.CHF&yr.) as sumobs&meas.CHF&yr., sum(obs&meas.PN&yr.) as sumobs&meas.PN&yr., 

       sum(N&meas.AMI&yr.) as sumN&meas.AMI&yr., sum(N&meas.CHF&yr.) as sumN&meas.CHF&yr., sum(N&meas.PN&yr.) as sumN&meas.PN&yr.,

	   (calculated sumobs&meas.AMI&yr. + calculated sumobs&meas.CHF&yr. + calculated sumobs&meas.PN&yr.)
       /(calculated sumN&meas.AMI&yr. + calculated sumN&meas.CHF&yr. + calculated sumN&meas.PN&yr.) as overall&meas.3cond&yr.,

       (obs&meas.AMI&yr.+obs&meas.CHF&yr.+obs&meas.PN&yr.)/(exp&meas.AMI&yr.+exp&meas.CHF&yr.+exp&meas.PN&yr.) as ratio&meas.3cond,
      (calculated overall&meas.3cond&yr.)*(calculated ratio&meas.3cond) as adj&meas.3cond&yr.,

	    sum(obs&meas.AMI&yr.) as sumobs&meas.AMI&yr., sum(obs&meas.CHF&yr.) as sumobs&meas.CHF&yr., sum(obs&meas.PN&yr.) as sumobs&meas.PN&yr., 
		sum(obs&meas.copd&yr.) as sumobs&meas.COPD&yr., sum(obs&meas.stroke&yr.) as sumobs&meas.stroke&yr., sum(obs&meas.sepsis&yr.) as sumobs&meas.sepsis&yr., 
		sum(obs&meas.esggas&yr.) as sumobs&meas.esggas&yr., sum(obs&meas.gib&yr.) as sumobs&meas.gib&yr., sum(obs&meas.uti&yr.) as sumobs&meas.uti&yr., 
		sum(obs&meas.metdis&yr.) as sumobs&meas.metdis&yr., sum(obs&meas.arrhy&yr.) as sumobs&meas.arrhy&yr., sum(obs&meas.chest&yr.) as sumobs&meas.chest&yr., 
		sum(obs&meas.renalf&yr.) as sumobs&meas.renalf&yr., sum(obs&meas.resp&yr.) as sumobs&meas.resp&yr., sum(obs&meas.hipfx&yr.) as sumobs&meas.hipfx&yr., 

       sum(N&meas.AMI&yr.) as sumN&meas.AMI&yr., sum(N&meas.CHF&yr.) as sumN&meas.CHF&yr., sum(N&meas.PN&yr.) as sumN&meas.PN&yr.,
	   sum(N&meas.copd&yr.) as sumN&meas.copd&yr., sum(N&meas.stroke&yr.) as sumN&meas.stroke&yr., sum(N&meas.sepsis&yr.) as sumN&meas.sepsis&yr.,
	   sum(N&meas.esggas&yr.) as sumN&meas.esggas&yr., sum(N&meas.gib&yr.) as sumN&meas.gib&yr., sum(N&meas.uti&yr.) as sumN&meas.uti&yr.,
	   sum(N&meas.metdis&yr.) as sumN&meas.metdis&yr., sum(N&meas.arrhy&yr.) as sumN&meas.arrhy&yr., sum(N&meas.chest&yr.) as sumN&meas.chest&yr.,
	   sum(N&meas.renalf&yr.) as sumN&meas.renalf&yr., sum(N&meas.resp&yr.) as sumN&meas.resp&yr., sum(N&meas.hipfx&yr.) as sumN&meas.hipfx&yr.,

	   (calculated sumobs&meas.AMI&yr. + calculated sumobs&meas.CHF&yr. + calculated sumobs&meas.PN&yr.
       +calculated sumobs&meas.copd&yr. + calculated sumobs&meas.stroke&yr. + calculated sumobs&meas.sepsis&yr.
       +calculated sumobs&meas.esggas&yr. + calculated sumobs&meas.gib&yr. + calculated sumobs&meas.uti&yr.
       +calculated sumobs&meas.metdis&yr. + calculated sumobs&meas.arrhy&yr. + calculated sumobs&meas.chest&yr.
       +calculated sumobs&meas.renalf&yr. + calculated sumobs&meas.resp&yr. + calculated sumobs&meas.hipfx&yr.)
       /(calculated sumN&meas.AMI&yr. + calculated sumN&meas.CHF&yr. + calculated sumN&meas.PN&yr.
        +calculated sumN&meas.copd&yr. + calculated sumN&meas.stroke&yr. + calculated sumN&meas.sepsis&yr.
		+calculated sumN&meas.esggas&yr. + calculated sumN&meas.gib&yr. + calculated sumN&meas.uti&yr.
		+calculated sumN&meas.metdis&yr. + calculated sumN&meas.arrhy&yr. + calculated sumN&meas.chest&yr.
		+calculated sumN&meas.renalf&yr. + calculated sumN&meas.resp&yr. + calculated sumN&meas.hipfx&yr.) as overall&meas.15cond&yr.,

       (obs&meas.AMI&yr.+obs&meas.CHF&yr.+obs&meas.PN&yr.
        +obs&meas.copd&yr.+obs&meas.stroke&yr.+obs&meas.sepsis&yr.
        +obs&meas.esggas&yr.+obs&meas.gib&yr.+obs&meas.UTI&yr.
        +obs&meas.metdis&yr.+obs&meas.arrhy&yr.+obs&meas.chest&yr.
        +obs&meas.renalf&yr.+obs&meas.resp&yr.+obs&meas.hipfx&yr.)
       /(exp&meas.AMI&yr.+exp&meas.CHF&yr.+exp&meas.PN&yr.
        +exp&meas.copd&yr.+exp&meas.stroke&yr.+exp&meas.sepsis&yr.
        +exp&meas.esggas&yr.+exp&meas.gib&yr.+exp&meas.uti&yr.
        +exp&meas.metdis&yr.+exp&meas.arrhy&yr.+exp&meas.chest&yr.
        +exp&meas.renalf&yr.+exp&meas.resp&yr.+exp&meas.hipfx&yr.) as ratio&meas.15cond,
      (calculated overall&meas.15cond&yr.)*(calculated ratio&meas.15cond) as adj&meas.15cond&yr.  

from Hartford;
quit;

proc sort data=&meas.&yr. nodupkey;by provider;run;
%mend comp;
%comp(meas=LOS, yr=2008);
%comp(meas=LOS, yr=2009);
%comp(meas=LOS, yr=2010);
%comp(meas=LOS, yr=2011);
%comp(meas=LOS, yr=2012);
%comp(meas=LOS, yr=2013);


 
data data;
merge hartford(in=in1) 
readm302008(keep=provider adj3condreadm302008 adj15condreadm302008) readm302009(keep=provider adj3condreadm302009 adj15condreadm302009) readm302010(keep=provider adj3condreadm302010 adj15condreadm302010)
readm302011(keep=provider adj3condreadm302011 adj15condreadm302011) readm302012(keep=provider adj3condreadm302012 adj15condreadm302012) readm302013(keep=provider adj3condreadm302013 adj15condreadm302013) 

mort302008(keep=provider adj3condmort302008 adj15condmort302008) mort302009(keep=provider adj3condmort302009 adj15condmort302009) mort302010(keep=provider adj3condmort302010 adj15condmort302010)
mort302011(keep=provider adj3condmort302011 adj15condmort302011) mort302012(keep=provider adj3condmort302012 adj15condmort302012) mort302013(keep=provider adj3condmort302013 adj15condmort302013) 

LOS2008(keep=provider adjLOS15cond2008) LOS2009(keep=provider adjLOS15cond2009) LOS2010(keep=provider adjLOS15cond2010)
LOS2011(keep=provider adjLOS15cond2011) LOS2012(keep=provider adjLOS15cond2012) LOS2013(keep=provider adjLOS15cond2013);
by provider;
if in1=1;
proc sort nodupkey;by provider;
run;
 
 
************************************************************************
Add stratefication variables
************************************************************************;
/*  Stratified Analyses: 
1. Size
2. Urban/Rural
3. Teaching/Non-Teaching
4. Safety Net/ Non Safety Net
5. Early/Mid/Late Adopters (< 4, 4-7, >8 Functionalities at Baseline)
5b.Stratified-Stratified Analysis: Of hospitals with < 4 Baseline functionalities, compare adopters of none, 
   documentation and results viewing, documentation only, results only 
*/
* Vendor for ip and op;
proc import datafile="C:\data\Data\Hospital\AHA\HIT\Data\origdata\2013 IT DATA" dbms=xls out=HIT13 replace;
getnames=yes;
run;
data HIT13;set HIT13;if q14a_other ne '' then q14a=q14a_other;if q14b_other ne '' then q14b=q14b_other;run;

libname AHA 'C:\data\Data\Hospital\AHA\Annual_Survey\Data';
proc sql;create table temp as select a.id,a.q14a,a.q14b,b.provider from HIT13 a left join AHA.AHA13 b on a.id=b.id;quit;
proc sql;create table temp0 as select a.*,b.q14a,b.q14b from data a left join temp b on a.provider=b.provider;quit;

 


data data;
set temp0;
if Nrespond>=3;
 
 
* Had Medication CPOE c3 & Physician Note b1 / Medication CPOE only / Physician Note only / neither--were those functions ever adopted over the entire time period ;
if (c3_2008 in (1,2) or c3_2009 in (1,2) or c3_2010 in (1,2) or c3_2011 in (1,2) or c3_2012 in (1,2) or c3_2013 in (1,2)) 
and (b1_2008 in (1,2) or b1_2009 in (1,2) or b1_2010 in (1,2) or b1_2011 in (1,2) or b1_2012 in (1,2) or b1_2013 in (1,2))  then CPOE_PN=1;
else if 
((c3_2008 in (1,2) or c3_2009 in (1,2) or c3_2010 in (1,2) or c3_2011 in (1,2) or c3_2012 in (1,2) or c3_2013 in (1,2)) 
and (b1_2008 not in (1,2) and  b1_2009 not in (1,2) and b1_2010 not in (1,2) and b1_2011 not in (1,2) and b1_2012 not in (1,2) and b1_2013 not in (1,2)) ) then CPOE_PN=2;
else if 
((c3_2008 not in (1,2) and c3_2009 not in (1,2) and c3_2010 not in (1,2) and c3_2011 not in (1,2) and c3_2012 not in (1,2) and c3_2013 not in (1,2)) 
and (b1_2008 in (1,2) or b1_2009 in (1,2) or b1_2010 in (1,2) or b1_2011 in (1,2) or b1_2012 in (1,2) or b1_2013 in (1,2)) ) then CPOE_PN=3;
else if 
((c3_2008 not in (1,2) and c3_2009 not in (1,2) and c3_2010 not in (1,2) and c3_2011 not in (1,2) and c3_2012 not in (1,2) and c3_2013 not in (1,2)) 
and (b1_2008  not in (1,2)  and  b1_2009 not in (1,2)  and  b1_2010 not in (1,2)  and  b1_2011 not in (1,2)  and  b1_2012 not in (1,2)  and  b1_2013 not in (1,2)) ) then CPOE_PN=4;


* Had CPOE and PN during any point 2008-2010 / Adopted CPOE and PN during any point 2011-2013 / everyone else;
if (c3_2008 in (1,2) or c3_2009 in (1,2) or c3_2010 in (1,2)) and (b1_2008 in (1,2) or b1_2009 in (1,2) or b1_2010 in (1,2))  then CPOE_PN2=1;
else if (c3_2011 in (1,2) or c3_2012 in (1,2) or c3_2013 in (1,2)) and (b1_2011 in (1,2) or b1_2012 in (1,2) or b1_2013 in (1,2))  then CPOE_PN2=2;
else CPOE_PN2=3;

* same vendor;
if q14a ne '' and q14b ne '' then do;
   if q14a=q14b then SameVendor=1;
   else SameVendor=2;
end;

 
*Urban;
if ruca_level in (3,4) then ruca=2;  else if ruca_level in (1,2) then Ruca=1;


*teaching;
if teaching=3 then teaching1=2;else if teaching in (1,2) then teaching1=1;else if teaching=. then teaching1=.;
label teaching1="1=Teaching Hospital 2=Non-Teaching Hospital";
*SNH;
if SNH2012=4 then SNH=1;else if SNH2012 ne . then SNH=2;else if SNH2012=. then SNH=.;

*Late/Mid/Early Adopters (< 4, 4-7, >8 Functionalities at Baseline);
if NBasicEHR2008 in (0,1,2,3) then Adopter=3;
else if NBasicEHR2008 in (4,5,6,7) then Adopter=2;
else if NBasicEHR2008 >=8 then Adopter=1;

*5b.Stratified-Stratified Analysis: Of hospitals with < 4 Baseline functionalities, compare adopters of none,  documentation and results viewing, documentation only, results only ;
*documentation a1-f1 result reviewing a2-c3;
if Adopter=3 then do;
  if a1_2008 not in (1,2) and b1_2008 not in (1,2) and c1_2008 not in (1,2) and d1_2008 not in (1,2) and e1_2008 not in (1,2) and f1_2008 not in (1,2) 
     and a2_2008 not in (1,2) and b2_2008 not in (1,2) and d2_2008 not in (1,2) and c3_2008 not in (1,2) then subgroup=4;
  else if (a1_2008 in (1,2) or b1_2008 in (1,2) or c1_2008 in (1,2) or d1_2008 in (1,2) or e1_2008 in (1,2) or f1_2008 in (1,2)) 
     and (a2_2008 not in (1,2) and b2_2008 not in (1,2) and d2_2008 not in (1,2)) then subgroup=3;
  else if (a1_2008 not in (1,2) and b1_2008 not in (1,2) and c1_2008 not in (1,2) and d1_2008 not in (1,2) and e1_2008 not in (1,2) and f1_2008 not in (1,2)) 
     and (a2_2008 in (1,2) or b2_2008 in (1,2) or d2_2008 in (1,2) ) then subgroup=2;
  else if a1_2008 in (1,2) or  b1_2008 in (1,2) or c1_2008 in (1,2) or d1_2008 in (1,2) or e1_2008 in (1,2) or f1_2008 in (1,2) or
     a2_2008 in (1,2) or b2_2008 in (1,2) or d2_2008 in (1,2)  then subgroup=1;

end;

DSHpct=DSHpct2012;label DSHpct="DSH Percent (Adjusting for SES)";
rename adjLOS15cond2008=adj15condLOS2008 adjLOS15cond2009=adj15condLOS2009 adjLOS15cond2010=adj15condLOS2010 
       adjLOS15cond2011=adj15condLOS2011 adjLOS15cond2012=adj15condLOS2012 adjLOS15cond2013=adj15condLOS2013 ;
/*
We decided to add two control variables to supplement the DSH variable, that should help eliminate the missing data problem. 
The first is a binary variable for whether or not we have the DSH data (setting the DSH percentage data = 0 if t�fs missing). 
The other control would be percent Medicaid, which we should have for all hospitals. John said there should be no harm in adding 
both as long as we are not trying to interpret the coefficients, which we are not. 
*/
if Dshpct=. then do;Dshpct=0;missingDSH=1;end;
else missingDSH=0;
run;

 


proc freq data=data; 
title "SubGroup Frequency";tables  
CPOE_PN CPOE_PN2 SameVendor ruca teaching1 Adopter subgroup hospsize SNH profit2/missing;
proc means data=data N mean;
var opmargin ruca teaching hospsize Dshpct missingDSH p_medicaid;
run;

proc sort data=data nodupkey;by provider;run;
  
 
proc means data=slope N mean;
title "Overall";
var opmargin2013 ruca teaching hospsize Dshpct missingDSH p_medicaid;
run;
proc means data=slope N mean;
title "By Early/Mid/Late Adopter";
class Adopter; format Adopter Adopter_.;
var opmargin2013 ruca teaching hospsize Dshpct missingDSH p_medicaid;
run;
proc means data=slope N mean;
title "By Same Vendor";
class SameVendor; format SameVendor SameVendor_.;
var opmargin2013 ruca teaching hospsize Dshpct missingDSH p_medicaid;
run;
proc means data=slope N mean;
title "By speed";format speed speed_.;
class Speed; 
var opmargin2013 ruca teaching hospsize Dshpct missingDSH p_medicaid;
run;
 

****************************************************************************
Overall Model:
Regression model, using 30/90-day risk-adjusted readmission and mortality, Preventive Quality Indicator, and Medicare Spending (need decision), as outcome measures, 
look at how do the starting point and growth trajectory of number of E-H-R functionalities relate to performance measures over time, 
and weight by the inverse of standard errors from model 1 (giving less credibility to less stable hospitals). 

              Outcome = starting point + growth trajectory (drop if not meaningful) 
                     + Time + starting point* Time + growth trajectory * Time

Ideas: higher starting point might have better performance measure at the baseline,
       greater growth trajectory might have better performance measure improvement over time.

****************************************************************************;
%macro model2(cond=,meas=,day=,title=);

 
proc sql;
create table intercept as
select a.*, 
b.Estimate as startpoint
from data a left join data.model1 b
on a.provider=b.provider
where a.Nrespond>=3 and b.parameter="Intercept";
quit;

proc sql;
create table slope as
select a.*,
b.Estimate as slope,b.StdErr as slopeStdErr
from intercept a left join data.model1 b
on a.provider=b.provider
where b.parameter="year";
quit;


data ldata;
set slope;
if slopeStdErr=0 or slopeStdErr=. then wt=1/0.04;else wt=1/slopeStdErr;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2008;opmargin=opmargin2008;year=0;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2009;opmargin=opmargin2009;year=1;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2010;opmargin=opmargin2010;year=2;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2011;opmargin=opmargin2011;year=3;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2012;opmargin=opmargin2012;year=4;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2013;opmargin=opmargin2013;year=5;output;
proc means;var adj&cond.&meas.&day.;
output out=outcome&cond.&meas.&day. mean=mean  min=min q1=q1  median=median  q3=q3  max=max  ;
run;

 

proc glimmix data=ldata NOCLPRINT ;
	title "&title.";
	title1 "1.Regular model, no controls";
	class provider  ;
	weight wt; 
	model adj&cond.&meas.&day.=startpoint year startpoint*year slope*year /s dist=normal  ;
	random int  / subject=provider ;

	estimate "Change (0-5 Year) Non Adopter" year 5 /cl;
	estimate "Change (0-5 Year) Average Adopter" year 5 startpoint*year 25 slope*year 5/cl;
	estimate "Diff-in-Diff" startpoint*year 25 slope*year 5/cl;

	ods output ModelInfo=ModelInfo&cond.&meas.&day.1
	           NObs=NObs&cond.&meas.&day.1
			   Dimensions=Dimensions&cond.&meas.&day.1
               FitStatistics= FitStatistics&cond.&meas.&day.1
			   CovParms=CovParms&cond.&meas.&day.1
               ParameterEstimates= ParameterEstimates&cond.&meas.&day.1
               Tests3=Test3&cond.&meas.&day.1
               Estimates= Estimates&cond.&meas.&day.1;
 
run;

proc glimmix data=ldata NOCLPRINT ;
	title "&title.";
	title1 "2.Add in op margin control";
	class provider  ;
	weight wt; 
	model adj&cond.&meas.&day.=startpoint  year startpoint*year slope*year opmargin /s dist=normal  ;
	random int  / subject=provider ;
	ods output ModelInfo=ModelInfo&cond.&meas.&day.2
	           NObs=NObs&cond.&meas.&day.2
			   Dimensions=Dimensions&cond.&meas.&day.2
               FitStatistics= FitStatistics&cond.&meas.&day.2
			   CovParms=CovParms&cond.&meas.&day.2
               ParameterEstimates= ParameterEstimates&cond.&meas.&day.2
               Tests3=Test3&cond.&meas.&day.2
               Estimates= Estimates&cond.&meas.&day.2;

    estimate "Change (0-5 Year) Non Adopter" year 5 /cl;
	estimate "Change (0-5 Year) Average Adopter" year 5 startpoint*year 25 slope*year 5/cl;
	estimate "Diff-in-Diff" startpoint*year 25 slope*year 5/cl;
run;

proc glimmix data=ldata NOCLPRINT ;
	title "&title.";
	title1 "3.Add in op margin and RUCA as control";
	class provider ruca  ;
	weight wt; 
	model adj&cond.&meas.&day.=startpoint  year startpoint*year slope*year opmargin ruca/s dist=normal  ;
	random int  / subject=provider ;
	ods output ModelInfo=ModelInfo&cond.&meas.&day.3
	           NObs=NObs&cond.&meas.&day.3
			   Dimensions=Dimensions&cond.&meas.&day.3
               FitStatistics= FitStatistics&cond.&meas.&day.3
			   CovParms=CovParms&cond.&meas.&day.3
               ParameterEstimates= ParameterEstimates&cond.&meas.&day.3
               Tests3=Test3&cond.&meas.&day.3
               Estimates= Estimates&cond.&meas.&day.3;

	estimate "Change (0-5 Year) Non Adopter" year 5 /cl;
	estimate "Change (0-5 Year) Average Adopter" year 5 startpoint*year 25 slope*year 5/cl;
	estimate "Diff-in-Diff" startpoint*year 25 slope*year 5/cl;
run;

proc glimmix data=ldata NOCLPRINT ;
	title "&title.";
	title1 "4.Add in op margin, RUCA, and teaching status as control";
	class provider ruca teaching ;
	weight wt; 
	model adj&cond.&meas.&day.=startpoint  year startpoint*year slope*year opmargin ruca teaching /s dist=normal  ;
	random int  / subject=provider ;
	ods output ModelInfo=ModelInfo&cond.&meas.&day.4
	           NObs=NObs&cond.&meas.&day.4
			   Dimensions=Dimensions&cond.&meas.&day.4
               FitStatistics= FitStatistics&cond.&meas.&day.4
			   CovParms=CovParms&cond.&meas.&day.4
               ParameterEstimates= ParameterEstimates&cond.&meas.&day.4
               Tests3=Test3&cond.&meas.&day.4
Estimates= Estimates&cond.&meas.&day.4;

	estimate "Change (0-5 Year) Non Adopter" year 5 /cl;
	estimate "Change (0-5 Year) Average Adopter" year 5 startpoint*year 25 slope*year 5/cl;
	estimate "Diff-in-Diff" startpoint*year 25 slope*year 5/cl;
run;

proc glimmix data=ldata NOCLPRINT ;
	title "&title.";
	title1 "5.Add in op margin, RUCA, teaching status, and size as control";
	class provider ruca teaching hospsize;
	weight wt; 
	model adj&cond.&meas.&day.=startpoint  year startpoint*year slope*year opmargin ruca teaching hospsize/s dist=normal  ;
	random int  / subject=provider ;
	ods output ModelInfo=ModelInfo&cond.&meas.&day.5
	           NObs=NObs&cond.&meas.&day.5
			   Dimensions=Dimensions&cond.&meas.&day.5
               FitStatistics= FitStatistics&cond.&meas.&day.5
			   CovParms=CovParms&cond.&meas.&day.5
               ParameterEstimates= ParameterEstimates&cond.&meas.&day.5
               Tests3=Test3&cond.&meas.&day.5
               Estimates= Estimates&cond.&meas.&day.5;

	estimate "Change (0-5 Year) Non Adopter" year 5 /cl;
	estimate "Change (0-5 Year) Average Adopter" year 5 startpoint*year 25 slope*year 5/cl;
	estimate "Diff-in-Diff" startpoint*year 25 slope*year 5/cl;
run;

* Predicted Margin or G-Formula;
data newdata;
set ldata;
startpoint=5;
slope=1;
run;
proc glimmix data=ldata NOCLPRINT ;
	title "&title.";
	title1 "6.Add in op margin, RUCA, teaching status, size, and DSH pct as a control";
	class provider ruca teaching hospsize missingDSH;
	weight wt; 
	model adj&cond.&meas.&day.=startpoint  year startpoint*year slope*year opmargin ruca teaching hospsize Dshpct missingDSH p_medicaid/s dist=normal  ;
	random int  / subject=provider ;
	ods output ModelInfo=ModelInfo&cond.&meas.&day.6
	           NObs=NObs&cond.&meas.&day.6
			   Dimensions=Dimensions&cond.&meas.&day.6
               FitStatistics= FitStatistics&cond.&meas.&day.6
			   CovParms=CovParms&cond.&meas.&day.6
               ParameterEstimates= ParameterEstimates&cond.&meas.&day.6
               Tests3=Test3&cond.&meas.&day.6
               Estimates= Estimates&cond.&meas.&day.6;

	estimate "Change (0-5 Year) Non Adopter" year 5 /cl;
	estimate "Change (0-5 Year) Average Adopter" year 5 startpoint*year 25 slope*year 5/cl;
	estimate "Diff-in-Diff" startpoint*year 25 slope*year 5/cl;
store sasuser.betaoverall;
	run;

proc plm source=sasuser.betaoverall;
   score data=newdata out=newdataoverall predicted / ilink;
run;
proc means data=newdataoverall N mean std;
		class year;
		var predicted;
	run;  
 
%mend model2;
%model2(cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%model2(cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%model2(cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");


*********************************
 Table 1: Descriptive
  N=3249 
********************************;
proc sort data=ldata out=temp nodupkey;by provider;run;

proc freq data=temp;
where RUCA ne . and hospsize ne . and  teaching1 ne . and profit2 not in (.,4) ;
tables RUCA hospsize teaching1 SNH profit2/missing;
run;





**********************************
Stratefied Analyses
**********************************;
%macro strat(by=, stratum=, add1=, add2=,cond=,meas=,day=,title=);
proc sql;
create table intercept as
select a.*, 
b.Estimate as startpoint
from data a left join data.model1 b
on a.provider=b.provider
where a.Nrespond>=3 and b.parameter="Intercept";
quit;

proc sql;
create table slope as
select a.*,
b.Estimate as slope,b.StdErr as slopeStdErr
from intercept a left join data.model1 b
on a.provider=b.provider
where b.parameter="year";
quit;


data ldata;
set slope;
if slopeStdErr=0 or slopeStdErr=. then wt=1/0.04;else wt=1/slopeStdErr;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2008;opmargin=opmargin2008;year=0;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2009;opmargin=opmargin2009;year=1;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2010;opmargin=opmargin2010;year=2;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2011;opmargin=opmargin2011;year=3;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2012;opmargin=opmargin2012;year=4;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2013;opmargin=opmargin2013;year=5;output;
proc means;var adj&cond.&meas.&day.;
output out=outcome&cond.&meas.&day. mean=mean  min=min q1=q1  median=median  q3=q3  max=max  ;
run;

* Predicted Margin or G-Formula;
data newdata;
set ldata;
startpoint=5;
slope=1;
run;

proc glimmix data=ldata NOCLPRINT;
title &title.;
class provider &add1.;
weight wt;  
where &by.=&stratum.; * change this!!!!!;
model adj&cond.&meas.&day.=startpoint year startpoint*year slope*year opmargin  &add1. &add2./s dist=normal  ;
random int  / subject=provider ;

	estimate "Change (0-5 Year) Non Adopter" year 5 /cl;
	estimate "Change (0-5 Year) Average Adopter" year 5 startpoint*year 25 slope*year 5/cl;
	estimate "Diff-in-Diff" startpoint*year 25 slope*year 5/cl;
 

	ods output ModelInfo=ModelInfo&meas.&by.&stratum. 
	           NObs=NObs&meas.&by.&stratum. 
			   Dimensions=Dimensions&meas.&by.&stratum. 
               FitStatistics= FitStatistics&meas.&by.&stratum. 
			   CovParms=CovParms&meas.&by.&stratum. 
               ParameterEstimates= ParameterEstimates&meas.&by.&stratum. 
               Tests3=Test3&meas.&by.&stratum. 
               Estimates= Estimates&meas.&by.&stratum.;

store sasuser.beta&meas.&by.&stratum.;
	run;

proc plm source=sasuser.beta&meas.&by.&stratum.;
   score data=newdata out=newdata&meas.&by.&stratum. predicted / ilink;
run;
proc means data=newdata&meas.&by.&stratum. N mean std;
		class year;
		var predicted;
	run;  
%mend strat;

***********************************
Interaction Models
**********************************;

%macro interact(by=,  add1=, add2=,cond=,meas=,day=,title=);
proc sql;
create table intercept as
select a.*, 
b.Estimate as startpoint
from data a left join data.model1 b
on a.provider=b.provider
where a.Nrespond>=3 and b.parameter="Intercept";
quit;

proc sql;
create table slope as
select a.*,
b.Estimate as slope,b.StdErr as slopeStdErr
from intercept a left join data.model1 b
on a.provider=b.provider
where b.parameter="year";
quit;


data ldata;
set slope;
if slopeStdErr=0 or slopeStdErr=. then wt=1/0.04;else wt=1/slopeStdErr;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2008;opmargin=opmargin2008;year=0;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2009;opmargin=opmargin2009;year=1;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2010;opmargin=opmargin2010;year=2;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2011;opmargin=opmargin2011;year=3;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2012;opmargin=opmargin2012;year=4;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2013;opmargin=opmargin2013;year=5;output;
proc means;var adj&cond.&meas.&day.;
output out=outcome&cond.&meas.&day. mean=mean  min=min q1=q1  median=median  q3=q3  max=max  ;
run;
proc glimmix data=ldata NOCLPRINT;
title &title.; 
class provider &by. &add1.;
weight wt;  
model adj&cond.&meas.&day.=&by. startpoint startpoint*&by. year year*&by. startpoint*year startpoint*year*&by. slope*year slope*year*&by. opmargin &add1. &add2./s dist=normal  ;
random int  / subject=provider ;
	ods output ModelInfo=ModelInfo&meas.&by. 
	           NObs=NObs&meas.&by. 
			   Dimensions=Dimensions&meas.&by. 
               FitStatistics= FitStatistics&meas.&by. 
			   CovParms=CovParms&meas.&by. 
               ParameterEstimates= ParameterEstimates&meas.&by. 
               Tests3=Test3&meas.&by. ;
run;
  
%mend interact;
proc format;
value CPOE_PN_
1="Had Medication CPOE & Physician Note anytime during 2008-2013"
2="Medication CPOE only, no Physician Note anytime during 2008-2013"
3="Physician Note only, no Medication CPOE anytime during 2008-2013"
4="Neither anytime during 2008-2013"
;
run;


%strat(by=CPOE_PN,stratum=1,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=CPOE_PN,stratum=1,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=CPOE_PN,stratum=1,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

%strat(by=CPOE_PN,stratum=2,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=CPOE_PN,stratum=2,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=CPOE_PN,stratum=2,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

%strat(by=CPOE_PN,stratum=3,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=CPOE_PN,stratum=3,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=CPOE_PN,stratum=3,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

%strat(by=CPOE_PN,stratum=4,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=CPOE_PN,stratum=4,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=CPOE_PN,stratum=4,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

%interact(by=CPOE_PN, add1=ruca teaching1 hospsize missingDSH, add2=opmargin DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%interact(by=CPOE_PN, add1=ruca teaching1 hospsize missingDSH, add2=opmargin DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%interact(by=CPOE_PN, add1=ruca teaching1 hospsize missingDSH, add2=opmargin DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");
proc format;
value CPOE_PN2_
1="Had Medication CPOE and PN during any point 2008-2010 "
2="Had Medication CPOE and PN during any point 2011-2013 "
3="Neither"
;
run;
%strat(by=CPOE_PN2,stratum=1,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=CPOE_PN2,stratum=1,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=CPOE_PN2,stratum=1,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

%strat(by=CPOE_PN2,stratum=2,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=CPOE_PN2,stratum=2,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=CPOE_PN2,stratum=2,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

%strat(by=CPOE_PN2,stratum=3,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=CPOE_PN2,stratum=3,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=CPOE_PN2,stratum=3,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

%interact(by=CPOE_PN2, add1=ruca teaching1 hospsize missingDSH, add2=opmargin DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%interact(by=CPOE_PN2, add1=ruca teaching1 hospsize missingDSH, add2=opmargin DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%interact(by=CPOE_PN2, add1=ruca teaching1 hospsize missingDSH, add2=opmargin DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

proc format;
value SameVendor_
1="Same inpatient and outpatient vendor"
2="Not the same vendor"
;
run;
%strat(by=SameVendor,stratum=1,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=SameVendor,stratum=1,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=SameVendor,stratum=1,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

%strat(by=SameVendor,stratum=2,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=SameVendor,stratum=2,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=SameVendor,stratum=2,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

%interact(by=SameVendor, add1=ruca teaching1 hospsize missingDSH, add2=opmargin DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%interact(by=SameVendor, add1=ruca teaching1 hospsize missingDSH, add2=opmargin DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%interact(by=SameVendor, add1=ruca teaching1 hospsize missingDSH, add2=opmargin DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

proc format;
value ruca_
1="Urban or Suburban"
2="Rural"
;
run;
%strat(by=ruca,stratum=1,add1=teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=ruca,stratum=1,add1=teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=ruca,stratum=1,add1=teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

%strat(by=ruca,stratum=2,add1=teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=ruca,stratum=2,add1=teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=ruca,stratum=2,add1=teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

%interact(by=ruca, add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%interact(by=ruca, add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%interact(by=ruca, add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");


proc format;
value hospsize_
1="Small"
2="Medium"
3="Large"
;
run;
%strat(by=hospsize,stratum=1,add1=ruca teaching1 missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=hospsize,stratum=1,add1=ruca teaching1 missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=hospsize,stratum=1,add1=ruca teaching1 missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

%strat(by=hospsize,stratum=2,add1=ruca teaching1 missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=hospsize,stratum=2,add1=ruca teaching1 missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=hospsize,stratum=2,add1=ruca teaching1 missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

%strat(by=hospsize,stratum=3,add1=ruca teaching1 missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=hospsize,stratum=3,add1=ruca teaching1 missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=hospsize,stratum=3,add1=ruca teaching1 missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");


%interact(by=hospsize, add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%interact(by=hospsize, add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%interact(by=hospsize, add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");


proc format;
value teaching1_
1="Teaching Hospital"
2="Non-Teaching Hospital"
;
run;
%strat(by=teaching1,stratum=1,add1=ruca hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=teaching1,stratum=1,add1=ruca hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=teaching1,stratum=1,add1=ruca hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

%strat(by=teaching1,stratum=2,add1=ruca hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=teaching1,stratum=2,add1=ruca hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=teaching1,stratum=2,add1=ruca hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");


%interact(by=teaching1, add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%interact(by=teaching1, add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%interact(by=teaching1, add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

proc format;
value SNH_
1="Safety-Net Hospital (Top Quartile DSH%)"
2="Non-Safety-Net Hospital"
;
run;
%strat(by=SNH,stratum=1,add1=ruca teaching1 hospsize , cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=SNH,stratum=1,add1=ruca teaching1 hospsize , cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=SNH,stratum=1,add1=ruca teaching1 hospsize ,  cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

%strat(by=SNH,stratum=2,add1=ruca teaching1 hospsize ,  cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=SNH,stratum=2,add1=ruca teaching1 hospsize ,  cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=SNH,stratum=2,add1=ruca teaching1 hospsize ,  cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");


%interact(by=SNH, add1=ruca teaching1 hospsize , add2=DSHpct,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%interact(by=SNH, add1=ruca teaching1 hospsize , add2=DSHpct,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%interact(by=SNH, add1=ruca teaching1 hospsize , add2=DSHpct,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

proc format;
value Adopter_
1="Early Adopters:>8 Functionalities at Baseline"
2="Mid Adopters:4-7 Functionalities at Baseline"
3="Late Adopters:<4 Functionalities at Baseline"
;
run;
%strat(by=Adopter,stratum=1,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=Adopter,stratum=1,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=Adopter,stratum=1,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");
 
%strat(by=Adopter,stratum=2,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=Adopter,stratum=2,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=Adopter,stratum=2,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

%strat(by=Adopter,stratum=3,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=Adopter,stratum=3,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=Adopter,stratum=3,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

%interact(by=Adopter, add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%interact(by=Adopter, add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%interact(by=Adopter, add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");




proc format;
value subgroup_
1="Had Documentation and Results viewing at Baseline"
2="Had Results Viewing at Baseline, no Documentation"
3="Had Documentation at Baseline, no Results Viewing"
4="Neither"
;
run;
%strat(by=subgroup,stratum=1,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=subgroup,stratum=1,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=subgroup,stratum=1,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

%strat(by=subgroup,stratum=2,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=subgroup,stratum=2,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=subgroup,stratum=2,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

%strat(by=subgroup,stratum=3,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=subgroup,stratum=3,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=subgroup,stratum=3,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

%strat(by=subgroup,stratum=4,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=subgroup,stratum=4,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=subgroup,stratum=4,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

%interact(by=subgroup, add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%interact(by=subgroup, add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%interact(by=subgroup, add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");


 
%strat(by=profit2,stratum=1,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=profit2,stratum=1,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=profit2,stratum=1,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

%strat(by=profit2,stratum=2,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=profit2,stratum=2,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=profit2,stratum=2,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

%strat(by=profit2,stratum=3,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=profit2,stratum=3,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=profit2,stratum=3,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");
 
%interact(by=profit2, add1=ruca teaching1 hospsize missingDSH, add2=opmargin DSHpct p_medicaid,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%interact(by=profit2, add1=ruca teaching1 hospsize missingDSH, add2=opmargin DSHpct p_medicaid,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%interact(by=profit2, add1=ruca teaching1 hospsize missingDSH, add2=opmargin DSHpct p_medicaid,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");


%strat(by=speed,stratum=1,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid ,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=speed,stratum=1,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid ,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=speed,stratum=1,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid  ,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

%strat(by=speed,stratum=2,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid  ,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=speed,stratum=2,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid  ,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=speed,stratum=2,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid  ,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

%strat(by=speed,stratum=3,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid  ,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=speed,stratum=3,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid  ,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=speed,stratum=3,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid  ,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");


*******************************
Check model extrapolation
*******************************;
proc sql;
create table intercept as
select a.*, 
b.Estimate as startpoint
from data a left join data.model1 b
on a.provider=b.provider
where a.Nrespond>=3 and b.parameter="Intercept";
quit;

proc sql;
create table slope as
select a.*,
b.Estimate as slope 
from intercept a left join data.model1 b
on a.provider=b.provider
where b.parameter="year";
quit;

%macro check(var);
proc means data=slope N mean std;
where Nrespond>=3 and RUCA ne . and hospsize ne . and  teaching1 ne . and profit2 not in (.,4) ;
class &var.;
var startpoint slope;
run;

*p-value;
proc genmod data=slope ;
where Nrespond>=3 and RUCA ne . and hospsize ne . and  teaching1 ne . and profit2 not in (.,4) ;
class &var.;
model startpoint=&var. /type3;
run;
proc genmod data=slope ;
where Nrespond>=3 and RUCA ne . and hospsize ne . and  teaching1 ne . and profit2 not in (.,4) ;
class &var.;
model slope=&var./type3 ;
run;
 

%mend check;
%check(var=CPOE_PN);
%check(var=CPOE_PN2);
%check(var=SameVendor);
%check(var=RUCA);
%check(var=hospsize);
%check(var=teaching1);
%check(var=SNH );
%check(var=Adopter);
%check(var=Subgroup);
%check(var=profit2);
%check(var=speed);

* check outcomes;
%macro check(var);
proc means data=slope N mean std;
where Nrespond>=3 and RUCA ne . and hospsize ne . and  teaching1 ne . and profit2 not in (.,4) ;
var adj15condreadm302008 adj15condmort302008 adj15condLOS2008;
run;

proc means data=slope N mean std;
where Nrespond>=3 and RUCA ne . and hospsize ne . and  teaching1 ne . and profit2 not in (.,4) ;
class &var.;
var adj15condreadm302008 adj15condmort302008 adj15condLOS2008;
run;

*p-value;
proc genmod data=slope ;
where Nrespond>=3 and RUCA ne . and hospsize ne . and  teaching1 ne . and profit2 not in (.,4) ;
class &var.;
model adj15condreadm302008=&var. /type3;
run;
proc genmod data=slope ;
where Nrespond>=3 and RUCA ne . and hospsize ne . and  teaching1 ne . and profit2 not in (.,4) ;
class &var.;
model adj15condmort302008=&var./type3 ;
run;
proc genmod data=slope ;
where Nrespond>=3 and RUCA ne . and hospsize ne . and  teaching1 ne . and profit2 not in (.,4) ;
class &var.;
model adj15condLOS2008=&var./type3 ;
run; 

%mend check;
%check(var=CPOE_PN);
%check(var=CPOE_PN2);
%check(var=SameVendor);
%check(var=RUCA);
%check(var=hospsize);
%check(var=teaching1);
%check(var=SNH );
%check(var=Adopter);
%check(var=Subgroup);
%check(var=profit2);
%check(var=speed);


 
******************************************
Appendix 1. Difference in Differences Table 
in Predicted Outcomes After 5 years for Average 
Hospitals with Different Implementation Decisions
******************************************;
%macro pvalue(by,meas);
data Estimates&meas.&by.1;
set Estimates&meas.&by.1;
if statement=2;
rename estimate=estimate1;rename stderr=stderr1;
keep estimate  stderr ;
run;
data Estimates&meas.&by.2;
set Estimates&meas.&by.2;
if statement=2;
rename estimate=estimate2;rename stderr=stderr2;
keep estimate  stderr ;
run;
data Estimates&meas.&by.3;
set Estimates&meas.&by.3;
if statement=2;
rename estimate=estimate3;rename stderr=stderr3;
keep estimate  stderr ;
run;
data &meas.&by.;
merge Estimates&meas.&by.1 Estimates&meas.&by.2 Estimates&meas.&by.3;
t1vs2=(estimate1-estimate2)/sqrt(stderr1*stderr1+stderr2*stderr2);
lower1vs2=(estimate1-estimate2)-1.96*sqrt(stderr1*stderr1+stderr2*stderr2);
upper1vs2=(estimate1-estimate2)+1.96*sqrt(stderr1*stderr1+stderr2*stderr2);

p1vs2=(1-probt(abs(t1vs2),2517))*2;

t1vs3=(estimate1-estimate3)/sqrt(stderr1*stderr1+stderr3*stderr3);
lower1vs3=(estimate1-estimate3)-1.96*sqrt(stderr1*stderr1+stderr3*stderr3);
upper1vs3=(estimate1-estimate3)+1.96*sqrt(stderr1*stderr1+stderr3*stderr3);
p1vs3=(1-probt(abs(t1vs3),2517))*2;
proc print;
run;
%mend pvalue;
%pvalue(by=adopter,meas=readm);
%pvalue(by=adopter,meas=mort);
%pvalue(by=adopter,meas=los);


%macro pvalue(by,meas);
data Estimates&meas.&by.1;
set Estimates&meas.&by.1;
if statement=2;
rename estimate=estimate1;rename stderr=stderr1;
keep estimate  stderr ;
run;
data Estimates&meas.&by.2;
set Estimates&meas.&by.2;
if statement=2;
rename estimate=estimate2;rename stderr=stderr2;
keep estimate  stderr ;
run;
 
data &meas.&by.;
merge Estimates&meas.&by.1 Estimates&meas.&by.2 ;
t1vs2=(estimate1-estimate2)/sqrt(stderr1*stderr1+stderr2*stderr2);
lower1vs2=(estimate1-estimate2)-1.96*sqrt(stderr1*stderr1+stderr2*stderr2);
upper1vs2=(estimate1-estimate2)+1.96*sqrt(stderr1*stderr1+stderr2*stderr2);
p1vs2=(1-probt(abs(t1vs2),774))*2;
 
proc print;
run;
%mend pvalue;
%pvalue(by=SameVendor,meas=readm);
%pvalue(by=SameVendor,meas=mort);
%pvalue(by=SameVendor,meas=los);

%pvalue(by=Speed,meas=readm);
%pvalue(by=Speed,meas=mort);
%pvalue(by=Speed,meas=los);


/*
%macro pvalue(by,meas);
data Estimates&meas.&by.1;
set Estimates&meas.&by.1;
if statement=2;
rename estimate=estimate1;rename stderr=stderr1;
keep estimate  stderr ;
run;
data Estimates&meas.&by.3;
set Estimates&meas.&by.3;
if statement=2;
rename estimate=estimate3;rename stderr=stderr3;
keep estimate  stderr ;
run;
 
data &meas.&by.;
merge Estimates&meas.&by.1 Estimates&meas.&by.3 ;
t1vs3=(estimate1-estimate3)/sqrt(stderr1*stderr1+stderr3*stderr3);
p1vs3=(1-probt(abs(t1vs3),211))*2;
 
proc print;
run;
%mend pvalue;
%pvalue(by=Speed,meas=readm);
%pvalue(by=Speed,meas=mort);
%pvalue(by=Speed,meas=los);

*/







/*
Basically, we want to look at the largest jump between adoption in the data and run the model only for hospitals that 
had a max jump of 6 or more. 
 
Then stratify based on how long it took for them to do it. 3 groups: 1 year (fast), 2-3 years (neither fast nor slow), 
and 4+ years (slow). The same way we�fve been doing it before both with individual models and then again in one model 
with a dummy variable. 
*/
proc freq data=data;tables speed;run;
%macro model2(cond=,meas=,day=,title=);

 
proc sql;
create table intercept as
select a.*, 
b.Estimate as startpoint
from data a left join data.model1 b
on a.provider=b.provider
where a.speed in (1,2,3) and a.Nrespond>=3 and b.parameter="Intercept";
quit;

proc sql;
create table slope as
select a.*,
b.Estimate as slope,b.StdErr as slopeStdErr
from intercept a left join data.model1 b
on a.provider=b.provider
where b.parameter="year";
quit;


data ldata;
set slope;
if slopeStdErr=0 or slopeStdErr=. then wt=1/0.04;else wt=1/slopeStdErr;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2008;opmargin=opmargin2008;year=0;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2009;opmargin=opmargin2009;year=1;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2010;opmargin=opmargin2010;year=2;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2011;opmargin=opmargin2011;year=3;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2012;opmargin=opmargin2012;year=4;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2013;opmargin=opmargin2013;year=5;output;
proc means;var adj&cond.&meas.&day.;
output out=outcome&cond.&meas.&day. mean=mean  min=min q1=q1  median=median  q3=q3  max=max  ;
run;

ods trace on;

proc glimmix data=ldata NOCLPRINT ;
	title "&title.";
	title1 "1.Regular model, no controls";
	class provider  ;
	weight wt; 
	model adj&cond.&meas.&day.=startpoint year startpoint*year slope*year /s dist=normal  ;
	random int  / subject=provider ;

	estimate "Change (0-5 Year) Non Adopter" year 5 /cl;
	estimate "Change (0-5 Year) Average Adopter" year 5 startpoint*year 32.1 slope*year 2.5/cl;
	estimate "Diff-in-Diff" startpoint*year 32.1 slope*year 2.5/cl;

	ods output ModelInfo=ModelInfo&cond.&meas.&day.1
	           NObs=NObs&cond.&meas.&day.1
			   Dimensions=Dimensions&cond.&meas.&day.1
               FitStatistics= FitStatistics&cond.&meas.&day.1
			   CovParms=CovParms&cond.&meas.&day.1
               ParameterEstimates= ParameterEstimates&cond.&meas.&day.1
               Tests3=Test3&cond.&meas.&day.1;
 
run;

proc glimmix data=ldata NOCLPRINT ;
	title "&title.";
	title1 "2.Add in op margin control";
	class provider  ;
	weight wt; 
	model adj&cond.&meas.&day.=startpoint  year startpoint*year slope*year opmargin /s dist=normal  ;
	random int  / subject=provider ;
	ods output ModelInfo=ModelInfo&cond.&meas.&day.2
	           NObs=NObs&cond.&meas.&day.2
			   Dimensions=Dimensions&cond.&meas.&day.2
               FitStatistics= FitStatistics&cond.&meas.&day.2
			   CovParms=CovParms&cond.&meas.&day.2
               ParameterEstimates= ParameterEstimates&cond.&meas.&day.2
               Tests3=Test3&cond.&meas.&day.2;

    estimate "Change (0-5 Year) Non Adopter" year 5 /cl;
	estimate "Change (0-5 Year) Average Adopter" year 5 startpoint*year 32.1 slope*year 2.5/cl;
	estimate "Diff-in-Diff" startpoint*year 32.1 slope*year 2.5/cl;
run;

proc glimmix data=ldata NOCLPRINT ;
	title "&title.";
	title1 "3.Add in op margin and RUCA as control";
	class provider ruca  ;
	weight wt; 
	model adj&cond.&meas.&day.=startpoint  year startpoint*year slope*year opmargin ruca/s dist=normal  ;
	random int  / subject=provider ;
	ods output ModelInfo=ModelInfo&cond.&meas.&day.3
	           NObs=NObs&cond.&meas.&day.3
			   Dimensions=Dimensions&cond.&meas.&day.3
               FitStatistics= FitStatistics&cond.&meas.&day.3
			   CovParms=CovParms&cond.&meas.&day.3
               ParameterEstimates= ParameterEstimates&cond.&meas.&day.3
               Tests3=Test3&cond.&meas.&day.3;

	estimate "Change (0-5 Year) Non Adopter" year 5 /cl;
	estimate "Change (0-5 Year) Average Adopter" year 5 startpoint*year 32.1 slope*year 2.5/cl;
	estimate "Diff-in-Diff" startpoint*year 32.1 slope*year 2.5/cl;
run;

proc glimmix data=ldata NOCLPRINT ;
	title "&title.";
	title1 "4.Add in op margin, RUCA, and teaching status as control";
	class provider ruca teaching ;
	weight wt; 
	model adj&cond.&meas.&day.=startpoint  year startpoint*year slope*year opmargin ruca teaching /s dist=normal  ;
	random int  / subject=provider ;
	ods output ModelInfo=ModelInfo&cond.&meas.&day.4
	           NObs=NObs&cond.&meas.&day.4
			   Dimensions=Dimensions&cond.&meas.&day.4
               FitStatistics= FitStatistics&cond.&meas.&day.4
			   CovParms=CovParms&cond.&meas.&day.4
               ParameterEstimates= ParameterEstimates&cond.&meas.&day.4
               Tests3=Test3&cond.&meas.&day.4;

	estimate "Change (0-5 Year) Non Adopter" year 5 /cl;
	estimate "Change (0-5 Year) Average Adopter" year 5 startpoint*year 32.1 slope*year 2.5/cl;
	estimate "Diff-in-Diff" startpoint*year 32.1 slope*year 2.5/cl;
run;

proc glimmix data=ldata NOCLPRINT ;
	title "&title.";
	title1 "5.Add in op margin, RUCA, teaching status, and size as control";
	class provider ruca teaching hospsize;
	weight wt; 
	model adj&cond.&meas.&day.=startpoint  year startpoint*year slope*year opmargin ruca teaching hospsize/s dist=normal  ;
	random int  / subject=provider ;
	ods output ModelInfo=ModelInfo&cond.&meas.&day.5
	           NObs=NObs&cond.&meas.&day.5
			   Dimensions=Dimensions&cond.&meas.&day.5
               FitStatistics= FitStatistics&cond.&meas.&day.5
			   CovParms=CovParms&cond.&meas.&day.5
               ParameterEstimates= ParameterEstimates&cond.&meas.&day.5
               Tests3=Test3&cond.&meas.&day.5;

	estimate "Change (0-5 Year) Non Adopter" year 5 /cl;
	estimate "Change (0-5 Year) Average Adopter" year 5 startpoint*year 32.1 slope*year 2.5/cl;
	estimate "Diff-in-Diff" startpoint*year 32.1 slope*year 2.5/cl;
run;

proc glimmix data=ldata NOCLPRINT ;
	title "&title.";
	title1 "6.Add in op margin, RUCA, teaching status, size, and DSH pct as a control";
	class provider ruca teaching hospsize missingDSH;
	weight wt; 
	model adj&cond.&meas.&day.=startpoint  year startpoint*year slope*year opmargin ruca teaching hospsize Dshpct missingDSH p_medicaid/s dist=normal  ;
	random int  / subject=provider ;
	ods output ModelInfo=ModelInfo&cond.&meas.&day.6
	           NObs=NObs&cond.&meas.&day.6
			   Dimensions=Dimensions&cond.&meas.&day.6
               FitStatistics= FitStatistics&cond.&meas.&day.6
			   CovParms=CovParms&cond.&meas.&day.6
               ParameterEstimates= ParameterEstimates&cond.&meas.&day.6
               Tests3=Test3&cond.&meas.&day.6;

	estimate "Change (0-5 Year) Non Adopter" year 5 /cl;
	estimate "Change (0-5 Year) Average Adopter" year 5 startpoint*year 32.1 slope*year 2.5/cl;
	estimate "Diff-in-Diff" startpoint*year 32.1 slope*year 2.5/cl;
run;
ods trace off;  
%mend model2;
%model2(cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%model2(cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%model2(cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");



***********************************
Stratefied Analyses
**********************************;
%macro strat(by=, stratum=, add1=, add2=,cond=,meas=,day=,title=);
proc sql;
create table intercept as
select a.*, 
b.Estimate as startpoint
from data a left join data.model1 b
on a.provider=b.provider
where a.speed in (1,2,3) and a.Nrespond>=3 and b.parameter="Intercept";
quit;

proc sql;
create table slope as
select a.*,
b.Estimate as slope,b.StdErr as slopeStdErr
from intercept a left join data.model1 b
on a.provider=b.provider
where b.parameter="year";
quit;


data ldata;
set slope;
if slopeStdErr=0 or slopeStdErr=. then wt=1/0.04;else wt=1/slopeStdErr;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2008;opmargin=opmargin2008;year=0;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2009;opmargin=opmargin2009;year=1;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2010;opmargin=opmargin2010;year=2;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2011;opmargin=opmargin2011;year=3;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2012;opmargin=opmargin2012;year=4;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2013;opmargin=opmargin2013;year=5;output;
proc means;var adj&cond.&meas.&day.;
output out=outcome&cond.&meas.&day. mean=mean  min=min q1=q1  median=median  q3=q3  max=max  ;
run;
proc glimmix data=ldata NOCLPRINT;
title &title.;
class provider &add1.;
weight wt;  
where &by.=&stratum.; * change this!!!!!;
model adj&cond.&meas.&day.=startpoint opmargin year startpoint*year slope*year  &add1. &add2./s dist=normal  ;
random int  / subject=provider ;

	estimate "Change (0-5 Year) Non Adopter" year 5 /cl;
	estimate "Change (0-5 Year) Average Adopter" year 5 startpoint*year 32.1 slope*year 2.5/cl;
	estimate "Diff-in-Diff" startpoint*year 32.1 slope*year 2.5/cl;

	ods output ModelInfo=ModelInfo&meas.&by.&stratum. 
	           NObs=NObs&meas.&by.&stratum. 
			   Dimensions=Dimensions&meas.&by.&stratum. 
               FitStatistics= FitStatistics&meas.&by.&stratum. 
			   CovParms=CovParms&meas.&by.&stratum. 
               ParameterEstimates= ParameterEstimates&meas.&by.&stratum. 
               Tests3=Test3&meas.&by.&stratum. ;

run;
  
%mend strat;

***********************************
Interaction Models
**********************************;

%macro interact(by=,  add1=, add2=,cond=,meas=,day=,title=);
proc sql;
create table intercept as
select a.*, 
b.Estimate as startpoint
from data a left join data.model1 b
on a.provider=b.provider
where a.speed in (1,2,3) and a.Nrespond>=3 and b.parameter="Intercept";
quit;

proc sql;
create table slope as
select a.*,
b.Estimate as slope,b.StdErr as slopeStdErr
from intercept a left join data.model1 b
on a.provider=b.provider
where b.parameter="year";
quit;


data ldata;
set slope;
if slopeStdErr=0 or slopeStdErr=. then wt=1/0.04;else wt=1/slopeStdErr;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2008;opmargin=opmargin2008;year=0;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2009;opmargin=opmargin2009;year=1;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2010;opmargin=opmargin2010;year=2;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2011;opmargin=opmargin2011;year=3;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2012;opmargin=opmargin2012;year=4;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2013;opmargin=opmargin2013;year=5;output;
proc means;var adj&cond.&meas.&day.;
output out=outcome&cond.&meas.&day. mean=mean  min=min q1=q1  median=median  q3=q3  max=max  ;
run;
proc glimmix data=ldata NOCLPRINT;
title &title.; 
class provider &by. &add1.;
weight wt;  
model adj&cond.&meas.&day.=&by. startpoint startpoint*&by. year year*&by. startpoint*year startpoint*year*&by. slope*year slope*year*&by.  &add1. &add2./s dist=normal  ;
random int  / subject=provider ;
	ods output ModelInfo=ModelInfo&meas.&by. 
	           NObs=NObs&meas.&by. 
			   Dimensions=Dimensions&meas.&by. 
               FitStatistics= FitStatistics&meas.&by. 
			   CovParms=CovParms&meas.&by. 
               ParameterEstimates= ParameterEstimates&meas.&by. 
               Tests3=Test3&meas.&by. ;
run;
  
%mend interact;
proc format;
value speed_
1="fast"
2="neither fast nor slow"
3="slow"
;
run;   
%strat(by=speed,stratum=1,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid ,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=speed,stratum=1,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid ,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=speed,stratum=1,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid  ,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

%strat(by=speed,stratum=2,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid  ,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=speed,stratum=2,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid  ,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=speed,stratum=2,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid  ,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");

%strat(by=speed,stratum=3,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid  ,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%strat(by=speed,stratum=3,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid  ,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%strat(by=speed,stratum=3,add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid  ,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");


%interact(by=speed, add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid opmargin,cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate");
%interact(by=speed, add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid opmargin,cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate");
%interact(by=speed, add1=ruca teaching1 hospsize missingDSH, add2=DSHpct p_medicaid opmargin,cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay");
 
