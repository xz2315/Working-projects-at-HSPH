******************************************************************************
Filename:		Step3.sas
Purpose:        at least Basic EHR adoption rate Step3
Date:           07/09/2014
******************************************************************************;


/******************************************

3. Predictors of adoption among ineligible hospitals
- categorize each ineligible hospital based on basic EHR adoption status as follows:
(1) NEW ADOPTER: had at least a basic EHR in 2013 (and if they did not respond in 2013, then you can substitute 2012 data) and did NOT have a basic EHR in 2009 (and if they did not respond in 2009, then you can substitute 2008)
(2) ALWAYS ADOPTER: same as above but had at least a basic in 2009/2008 and continued to have one in 2013/2012
(3) NEVER ADOPTER: same as above but did not have at least a basic in 2009/2008 and continued NOT to have one in 2013/2012
Note -- there will be some hospitals that seem to go backwards -- have basic in 2009/2008 but not in 2013/2012; fine to exclude these but please make a note of how many there are for reference.


- cross these categories with key hospital characteristics including chi-square tests for differences across groups, including:
(1) the usual set -- size, teaching, region, system affiliation, ownership, etc.
(2) a measure of at least basic EHR adoption among ELIGIBLE hospitals in their HRR in 2013
(3) a measure in the CHANGE in basic EHR adoption among ELIGIBLE hospitals in their HRR between 2009 and 2013 (so if HRR 1 had 30% adoption in 2009 and 50% adoption in 2013, the value for that HRR would be 20%).
Let's leave MU functions as something to look at later...
 

********************************************/

* Step3 uses data sets from Step1 only;
proc sort data=final08(where=(eligibility=0)) out=final08_step3(keep=id zip basic_adopt rename=(basic_adopt=adopt08));by id;run;
proc sort data=final09(where=(eligibility=0)) out=final09_step3(keep=id zip basic_adopt rename=(basic_adopt=adopt09));by id;run;
proc sort data=final10(where=(eligibility=0)) out=final10_step3(keep=id zip basic_adopt rename=(basic_adopt=adopt10));by id;run;
proc sort data=final11(where=(eligibility=0)) out=final11_step3(keep=id zip basic_adopt rename=(basic_adopt=adopt11));by id;run;
proc sort data=final12(where=(eligibility=0)) out=final12_step3(keep=id zip basic_adopt rename=(basic_adopt=adopt12));by id;run;
proc sort data=final13(where=(eligibility=0)) out=final13_step3(keep=id zip basic_adopt rename=(basic_adopt=adopt13));by id;run;

data allyear_ine;
merge final08_step3 final09_step3 final10_step3 final11_step3 final12_step3 final13_step3;
by id;
run;


* 2-Always 1-New 0-Never;
data allyear_ine;
set allyear_ine;
if (adopt13=1 or (adopt13=. and adopt12=1) or (adopt13=. and adopt12=. and adopt11=1)) and (adopt08=1 or (adopt08=. and adopt09=1) or (adopt08=. and adopt09=. and adopt10=1)) then adopter=2;
if (adopt13=1 or (adopt13=. and adopt12=1) or (adopt13=. and adopt12=. and adopt11=1)) and (adopt08=0 or (adopt08=. and adopt09=0) or (adopt08=. and adopt09=. and adopt10=0)) then adopter=1;
if (adopt13=0 or (adopt13=. and adopt12=0) or (adopt13=. and adopt12=. and adopt11=0)) and (adopt08=0 or (adopt08=. and adopt09=0) or (adopt08=. and adopt09=. and adopt10=0)) then adopter=0;
if (adopt13=0 or (adopt13=. and adopt12=0) or (adopt13=. and adopt12=. and adopt11=0)) and (adopt08=1 or (adopt08=. and adopt09=1) or (adopt08=. and adopt09=. and adopt10=1))then adopter=-1;
run;

proc freq data=allyear_ine;tables adopter/missing out=adopter_freq;run;

data adopter;
set allyear_ine;
where adopter in (0,1);
zipcode=zip*1;
keep id zipcode adopter;
run;




* HRR-level Eligible hospitals EHR adoption rate, for 2009 and 2013 and diff-09-13;


libname xwalk 'C:\data\Data\Dartmouth_Atlas\ZIP_HSA_HRR_XWalk';

data hrrzip;
set xwalk.ziphsahrr11;
keep zipcode11 hrrnum hrrcity hrrstate;
run;

%macro HRRrate(year=);
data temp1;
set final&year.;
zipcode=zip*1;
keep eligibility id zipcode wt basic_adopt;
run;

* temp2 include all hospitals;
proc sql;
 create table temp2 as
 select * 
 from temp1 left join hrrzip
 on temp1.zipcode=hrrzip.zipcode11;
quit;

* temp4 HRR eligible rate ;
proc logistic data=temp2(where=(eligibility=1));
	class hrrnum;
	weight wt;
	model basic_adopt(event='1')=hrrnum;
	output out=temp3 p=prob_&year. ;
run;

proc sort data=temp3 out=temp4(keep= hrrnum prob_&year. ) nodupkey;by hrrnum;run;


* temp5 adopter with HRR;
* temp6 adopters with HRR eligible rate;

proc sql;
 create table temp5 as
 select a.id, a.adopter, b.hrrnum
 from adopter a left join hrrzip b
 on a.zipcode=b.zipcode11;
quit;


proc sql;
create table temp6_&year. as
select * 
from temp5 left join temp4 
on temp5.hrrnum=temp4.hrrnum;
quit;

%mend HRRrate;

%HRRrate(year=09)
%HRRrate(year=13)

* merge 09 and 13 data, calculate diff;
proc sql;
create table temp7 as
select temp6_09.id, temp6_09.adopter,temp6_09.prob_09 * 100 as measure09, temp6_13.prob_13 * 100 as measure13, calculated measure13- calculated measure09  as diff 
from temp6_09 join temp6_13 on temp6_09.id=temp6_13.id;
quit;

* Descriptive statistics for measure09 and diff;
proc sgplot data=temp7;
vbox diff/category=adopter;
run;




* Link each ineliglble adopters with usual hospital characteristics and HRR 2013 and HRR diff-09-13;

proc sql;
create table temp8 as
select *
from temp7 a left join hospital b
on a.id=b.id;
quit;


* Chi-square test for hospital characteristics;

* Q: To test that, the distribution of Adopter Types is different across Hospital Characteristics, i.e. is there an association between Adopter Types and Hospital Characteristics?;

proc freq data=temp8;
tables  hospsize*adopter hosp_reg4*adopter profit2*adopter teaching*adopter system*adopter  ruca_level*adopter/ chisq nopercent nocum norow;
run;






* ANOVA or T Test: HRR 2013 + HRR diff-09-13;
proc means data=temp8;
class adopter;
var measure13;
run;
proc anova data=temp8;
class adopter;
model measure13=adopter ;
run;
proc means data=temp8;
class adopter;
var diff;
run;
proc anova data=temp8;
class adopter;
model diff=adopter;
run;



