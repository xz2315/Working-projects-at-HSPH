
/******************************************
8/18/2014
(2) Difference-in-trend
- compare trend in at least basic EHR adoption for the years 2008-2010 versus 2011-2013 for eligible versus ineligible hospitals 
-Small Hospitals Only

Xiner Zhou
********************************************/


libname HIT "C:\data\Data\Hospital\AHA\HIT\data";
libname impact "C:\data\Data\Hospital\Impact";
LIBNAME AHA 	"C:\data\Data\Hospital\AHA\Annual_Survey\data";
libname rural 'C:\data\Data\RUCA';


* Make Hospital Characteristics Summary File;
data temp1;
set aha.aha12;

 
* Inegilible Long-Term Acute Care ;
if serv=80 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=4;
* Inegilible Psychiatric ; 
if serv=22 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=3; 
* Inegilible Rehabilitation ;
if serv=46 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=2;
* Egilible Acute Care Hospitals (general medical and surgical ;
if serv=10 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=1; 

if type ne .;

if sysid ^='' then system=1; else system=0;

if hospsize=1;

keep id zip type hospsize hosp_reg4 profit2 teaching system  ;
run;



* Calculate how many hospitals in each category ;
proc freq data=temp1;tables type;run;


* Add RUCA level from external file;
proc sql;
create table temp2 as
select A.*,B.ruca_level
from temp1 A left join rural.SAS_2006_RUCA B
on A.zip=B.ZIPA;
quit;

*********************************
HIT responses
*********************************;

*2008;
proc sort data=hit.hit07 out=hit08(keep= q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 id  );
by id;
run;

*2009;
proc sort data=hit.hit08 out=hit09(keep= q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_a2 q1_b2 q1_d2 q1_c3 id it_response );
by id;
run;
data hit09;
set hit09;
if it_response='Yes';
run;
data hit09;
set hit09;
rename q1_a1=q1a1;rename q1_b1=q1b1;
rename q1_c1=q1c1;rename q1_d1=q1d1;
rename q1_e1=q1e1;rename q1_f1=q1f1;
rename q1_a2=q1a2;rename q1_b2=q1b2;
rename q1_d2=q1d2;rename q1_c3=q1c3;
run;
 
*2010;
proc sort data=hit.hit09 out=hit10(keep= q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 id  );
by id;
run;
*2011;
proc sort data=hit.hit10 out=hit11(keep= q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_a2 q1_b2 q1_d2 q1_c3 id );
by id;
run;
data hit11;
set hit11;
rename q1_a1=q1a1;rename q1_b1=q1b1;
rename q1_c1=q1c1;rename q1_d1=q1d1;
rename q1_e1=q1e1;rename q1_f1=q1f1;
rename q1_a2=q1a2;rename q1_b2=q1b2;
rename q1_d2=q1d2;rename q1_c3=q1c3;
run;
* 2012;
libname HIT1112 "C:\data\Data\Hospital\AHA\HIT\Data\fromshare_Projects-HIT2012-data-stata";
proc sort data=hit1112.Finalitfeb7 out=hit12(keep=q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 id );
by id;
run;

* 2013;
proc sort data=hit.hit13 out=hit13(keep= q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 id);
by id;
run;




%macro long(year=);
data hit&year.;
set hit&year.;
array basic {10}  q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3;
total=0;
do i= 1 to 10;
	if basic(i) in (1,2) then total=total+1;
end;
drop i;
		 
if total=10 then basic_adopt=1;else basic_adopt=0; 

keep id basic_adopt;
run; 

proc sql;
create table temp3 as
select *
from hospital A left join hit&year. B
on A.id=B.id;
quit;

data temp4;
set temp3;
if basic_adopt ne . then respond=1;else respond=0;
if type=1 then eligibility=1;else eligibility=0;
run;

 
proc logistic data=temp4;
	class respond(ref="0") type(ref="1") hosp_reg4(ref="1") profit2(ref="1") teaching(ref="3") system(ref="1") ruca_level(ref="1")  /param=ref;
	model respond  = type hosp_reg4 profit2 teaching system ruca_level; 
	output  out=temp5 p=prob;  
run;



data final&year.;
set temp5;
if respond=1;
wt=1/prob;
year=20&year.;
run;

* Overall trend ;
proc means data=final&year. ;
class eligibility ;
weight wt;
var basic_adopt;
output out=step1_&year.(keep=eligibility rate_20&year.) mean=rate_20&year.;
run;

  
%mend long;


%long(year=08);
%long(year=09);
%long(year=10);
%long(year=11);
%long(year=12);
%long(year=13);


* Overall trend for Small ineligible and Small eligible hospitals;

data step1_graph;
merge step1_08  step1_09  step1_10  step1_11 step1_12 step1_13 ;
where eligibility in (0,1);
rate=rate_2008;year=2008;output;
rate=rate_2009;year=2009;output;
rate=rate_2010;year=2010;output;
rate=rate_2011;year=2011;output;
rate=rate_2012;year=2012;output;
rate=rate_2013;year=2013;output;
 
keep eligibility rate year;
run;

proc sgplot data=step1_graph;
title "At Least Basic EHR Adoption Rate, Small Ineligible vs Small Eligible";
series X=year y=rate/group=eligibility datalabel=rate;
run;
 



***************************
Diff-in-Diff in Slope/trend
***************************;
data allyear;
set final08 final09 final10 final11 final12 final13;
if year=2008 then do;year1=0; time=1;post=0; end;
else if year=2009 then do;year1=1; time=2;post=0; end;
else if year=2010 then do;year1=2; time=3;post=0; end;
else if year=2011 then do;year1=3; time=4;post=1; end;
else if year=2012 then do;year1=4;time=5;post=1; end;
else if year=2013 then do;year1=5;time=6;post=1; end;
year2=post*(year1-2);
keep id eligibility  year1 year2 time  basic_adopt wt post  ;
run;

proc sort data=allyear;by id year1;run;

 
 


* Linear model;
proc genmod data=allyear descending  ;
weight wt;
class id eligibility(ref="0") time(ref="1") post(ref="0")/param=ref;
model basic_adopt=eligibility year1 post post*eligibility eligibility*year1 post*year2 post*year2*eligibility/dist=normal link=identity corrb ;
repeated subject=id/withinsubject=time type=un;
output out=predict p=pro l=lower u=upper;
estimate "Beta 1+ 4" year1 1 eligibility*year1 1 -1;
estimate "Beta 1+ 6" year1 1 post*year2 1 -1;
estimate "Beta 1+ 4+6+7" year1 1 eligibility*year1 1 -1 post*year2 1 -1 post*year2*eligibility 1 -1;
estimate "Beta 4+ 7"  eligibility*year1 1 -1 post*year2*eligibility 1 -1;
estimate "Beta 6+7" post*year2 1 -1 post*year2*eligibility 1 -1;
run;

 


proc sort data=predict(keep=pro year1 eligibility ) nodupkey;by pro;run;
data generate1 generate2 generate3 generate4;
set predict;
year=2008+year1;
if year <2011 and eligibility=0 then do;pre_ineligible=pro;output generate1;end;
else if year <2011 and eligibility=1 then do;pre_eligible=pro;output generate2;end;
else if year >2010 and eligibility=0 then do;post_ineligible=pro;output generate3;end;
else if year >2010 and eligibility=1 then do;post_eligible=pro;output generate4;end;
run;

data generate0;
set step1_graph;
keep year rate;
run;
proc sort data=generate0;by year;run;
data step2_graph;
merge generate0 generate1(keep=year pre_ineligible) generate2(keep=year pre_eligible) generate3(keep=year post_ineligible) generate4(keep=year post_eligible);
by year;
run;

proc sql;
create table step2_graph as
select *
from step1_graph a join predict b
on a.year=b.year and a.eligibility=b.eligibility;
quit;


proc sgplot data=step2_graph;
title1 "Estimated Linear Regression Line of At Least Basic EHR Adoption";
title2 "Small Hospitals Only";
scatter X=year y=rate/markerattrs=(symbol=STARFILLED) LEGENDLABEL ="True Rate";
series X=year  y=pre_ineligible/lineattrs=(color=blue) LEGENDLABEL ='Pre-period Ineligible';
series X=year  y=pre_eligible/lineattrs=(color=red)LEGENDLABEL ='Pre-period Eligible';
series X=year  y=post_ineligible/lineattrs=(color=green) LEGENDLABEL ='Post-period Ineligible';
series X=year  y=post_eligible/lineattrs=(color=purple)LEGENDLABEL ='Post-period Eligible';
xaxis label='Year' values=(2008 to 2013 by 1);
yaxis label='Adoption Rate';
run;
 


