*********************************************************
The Impact of HITECH on Hospital EHR Adoption 2016 May 11 
Paper Revision
Xiner Zhou

R&R on 2/2/2017: 
- Look out for unweighted analysis
- Add total margins to models to adjust
- Look Ramping up instead of basic adoption rate
*********************************************************;

*********************************************************
Step 1: Prepare AHA IT Survey Data
********************************************************;

libname HIT "C:\data\Data\Hospital\AHA\HIT\data";
libname impact "C:\data\Data\Hospital\Impact";
LIBNAME AHA 	"C:\data\Data\Hospital\AHA\Annual_Survey\data";
libname rural 'C:\data\Data\RUCA';
libname cr 'C:\data\Data\Hospital\Cost Reports\Data';
 
* Make Hospital Characteristics Summary File;
data hospital;
set aha.aha12;
* Inegilible Long-Term Acute Care ;
if serv=80 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=4;
* Inegilible Psychiatric ; 
if serv=22 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=3; 
* Inegilible Rehabilitation ;
if serv=46 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=2;
* Egilible Acute Care Hospitals (general medical and surgical ;
if serv=10 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=1; 
if sysid ^='' then system=1; else system=0;
if type ne . and hosp_reg4 ne 5 and profit2 ne 4;
 if substr(provider,3,2) in ('13') then cah1=1;else cah1=0;
 
keep id provider zip type hospsize profit2 teaching system hosp_reg4 ruca_level CAH p_medicare p_medicaid CAH CAH1 Urban;
proc sort;by provider;
proc freq ;tables type hospsize profit2 teaching system hosp_reg4 ruca_level  CAH CAH1 Urban/ missing;
proc freq;tables type*CAH type*teaching/nopercent nocol norow missing;
run;
 

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
 
data hospital;
merge hospital(in=in1) margin2008 margin2009 margin2010 margin2011 margin2012 margin2013  margin2014  margin2015;
by provider;
if in1=1;
proc sort nodupkey;by provider;

proc corr ;
var totmargin2008 totmargin2009 totmargin2010 totmargin2011 totmargin2012 totmargin2013 totmargin2014 totmargin2015 ;
 
proc means ;
var totmargin2008 totmargin2009 totmargin2010 totmargin2011 totmargin2012 totmargin2013 totmargin2014 totmargin2015 ;
run;


*2008;
proc sort data=hit.hit07 out=hit08(keep= q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 Q1a5 id  );by id;run;
data HIT08;
set HIT08;
q1_a1=q1a1*1;rename q1_a1=q1a1;
q1_b1=q1b1*1;rename q1_b1=q1b1;
q1_c1=q1c1*1;rename q1_c1=q1c1;
q1_d1=q1d1*1;rename q1_d1=q1d1;
q1_e1=q1e1*1;rename q1_e1=q1e1;
q1_f1=q1f1*1;rename q1_f1=q1f1;
q1_a2=q1a2*1;rename q1_a2=q1a2;
q1_b2=q1b2*1;rename q1_b2=q1b2;
q1_d2=q1d2*1;rename q1_d2=q1d2;
q1_c3=q1c3*1;rename q1_c3=q1c3;
Q1_a5=Q1a5*1;rename Q1_a5=Q1a5;
drop q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 Q1a5;
run;
*2009;
proc sort data=hit.hit08 out=hit09(keep= q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_a2 q1_b2 q1_d2 q1_c3 Q1_a5 id it_response );by id;run;
data hit09;
set hit09;
if it_response='Yes';
rename q1_a1=q1a1;rename q1_b1=q1b1;
rename q1_c1=q1c1;rename q1_d1=q1d1;
rename q1_e1=q1e1;rename q1_f1=q1f1;
rename q1_a2=q1a2;rename q1_b2=q1b2;
rename q1_d2=q1d2;rename q1_c3=q1c3;rename Q1_a5=Q1a5;
run;
*2010;
proc sort data=hit.hit09 out=hit10(keep= q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 Q1a5 id  );by id;run;
data HIT10;
set HIT10;
q1_a1=q1a1*1;rename q1_a1=q1a1;
q1_b1=q1b1*1;rename q1_b1=q1b1;
q1_c1=q1c1*1;rename q1_c1=q1c1;
q1_d1=q1d1*1;rename q1_d1=q1d1;
q1_e1=q1e1*1;rename q1_e1=q1e1;
q1_f1=q1f1*1;rename q1_f1=q1f1;
q1_a2=q1a2*1;rename q1_a2=q1a2;
q1_b2=q1b2*1;rename q1_b2=q1b2;
q1_d2=q1d2*1;rename q1_d2=q1d2;
q1_c3=q1c3*1;rename q1_c3=q1c3;
Q1_a5=Q1a5*1;rename Q1_a5=Q1a5;
drop q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 Q1a5;
run;
*2011;
proc sort data=hit.hit10 out=hit11(keep= q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_a2 q1_b2 q1_d2 q1_c3 Q1_a5 id );by id;run;
data hit11;
set hit11;
rename q1_a1=q1a1;rename q1_b1=q1b1;
rename q1_c1=q1c1;rename q1_d1=q1d1;
rename q1_e1=q1e1;rename q1_f1=q1f1;
rename q1_a2=q1a2;rename q1_b2=q1b2;
rename q1_d2=q1d2;rename q1_c3=q1c3;rename Q1_a5=Q1a5;
run;
* 2012;
libname HIT1112 "C:\data\Data\Hospital\AHA\HIT\Data\fromshare_Projects-HIT2012-data-stata";
proc sort data=hit1112.Finalitfeb7 out=hit12(keep=q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 Q1a5 id );by id;run;
* 2013;
proc sort data=hit.hit13 out=hit13(keep= q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 Q1a5 id);by id;run;
data HIT13;
set HIT13;
q1_a1=q1a1*1;rename q1_a1=q1a1;
q1_b1=q1b1*1;rename q1_b1=q1b1;
q1_c1=q1c1*1;rename q1_c1=q1c1;
q1_d1=q1d1*1;rename q1_d1=q1d1;
q1_e1=q1e1*1;rename q1_e1=q1e1;
q1_f1=q1f1*1;rename q1_f1=q1f1;
q1_a2=q1a2*1;rename q1_a2=q1a2;
q1_b2=q1b2*1;rename q1_b2=q1b2;
q1_d2=q1d2*1;rename q1_d2=q1d2;
q1_c3=q1c3*1;rename q1_c3=q1c3;
Q1_a5=Q1a5*1;rename Q1_a5=Q1a5;
drop q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 Q1a5;
run;
* 2014;
PROC IMPORT OUT=hit14 DATAFILE= "C:\data\Data\Hospital\AHA\HIT\Data\HIT14.xlsx" DBMS=xlsx REPLACE;GETNAMES=YES;RUN;
data hit14;
set hit14;
rename q1_a1=q1a1;rename q1_b1=q1b1;
rename q1_c1=q1c1;rename q1_d1=q1d1;
rename q1_e1=q1e1;rename q1_f1=q1f1;
rename q1_a2=q1a2;rename q1_b2=q1b2;
rename q1_d2=q1d2;rename q1_c3=q1c3;rename Q1_a5=Q1a5;
keep id q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_a2 q1_b2 q1_d2 q1_c3 Q1_a5;
proc sort;by id;
run;
* 2015;
PROC IMPORT OUT=hit15 DATAFILE= "C:\data\Data\Hospital\AHA\HIT\Data\HIT15.xlsx" DBMS=xlsx REPLACE;GETNAMES=YES;RUN;
data hit15;
set hit15;
rename q1_a1=q1a1;rename q1_b1=q1b1;
rename q1_c1=q1c1;rename q1_d1=q1d1;
rename q1_e1=q1e1;rename q1_f1=q1f1;
rename q1_a2=q1a2;rename q1_b2=q1b2;
rename q1_d2=q1d2;rename q1_c3=q1c3;rename AHA_ID=ID;rename Q1_a5=Q1a5;
keep AHA_ID q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_a2 q1_b2 q1_d2 q1_c3 Q1_a5;
proc sort;by id;
run;
  


%macro wt(year=);
data hit&year.;
set hit&year.;
array basic {10}  q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3;
total=0;totalpre=0;
do i= 1 to 10;
	if basic(i) in (1,2) then  total=total+1; 
	* Ramping up to basic EHR;
	if basic(i) in (1,2,3,4) then  totalpre=totalpre+1; 
end;
drop i;	 
* basic EHR;
if total=10 then basic_adopt=1;else basic_adopt=0; 
* Ramping up to basic EHR;
if totalpre=10 then ramp=1;else ramp=0; 
if Q1a5 in (1,2) then Q1a5=1;else Q1a5=0;
if Q1c3 in (1,2) then Q1c3=1;else Q1c3=0;
if Q1c1 in (1,2) then Q1c1=1;else Q1c1=0;
keep id basic_adopt ramp q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 Q1a5;
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

* Response rate ;
proc logistic data=temp4;
	class respond(ref="0") type hospsize(ref="1") profit2(ref="1") teaching(ref="1") system(ref="1") hosp_reg4(ref="1") ruca_level(ref="1") CAH(ref="1")/param=ref;
	model respond= type hospsize profit2 teaching system hosp_reg4 ruca_level CAH ; 
	output  out=temp5 p=prob;  
run;

data final&year.;
set temp5;
if respond=1;
wt=1/prob;
year=20&year.;
proc means mean sum min max;
class type ;
var wt;
proc freq;
title "&year.";
tables respond;
proc freq;
tables respond*type/missing nopercent norow;
run;

proc freq data=final&year.;
title "Eligible types";
tables type /missing;
run;

* Check missing margins;
data temp;
set final&year.;
where totmargin20&year. =. ;
proc freq data=temp;
title "Missing margins";
tables type/missing;
run; 
%mend wt;
%wt(year=08);
%wt(year=09);
%wt(year=10);
%wt(year=11);
%wt(year=12);
%wt(year=13);
%wt(year=14);
%wt(year=15);
 


/*
Also, on first issue, can you calc how many hospitals have data for all years (8?), how many have 7 years, 6 years, etc to answer sample side questions. 
I think we are reporting how many hospitals have at least 1 year of data, right? If not any idea where that sample size came from?
 
proc sql;create table temp1 as select a.id,a.type,b.respond as r2008 from final08 a left join final09 b  on A.id=B.id;quit;
proc sql;create table temp2 as select a.*,b.respond as r2009 from temp1 a left join final09 b  on A.id=B.id;quit;
proc sql;create table temp3 as select a.*,b.respond as r2010 from temp2 a left join final10 b  on A.id=B.id;quit;
proc sql;create table temp4 as select a.*,b.respond as r2011 from temp3 a left join final11 b  on A.id=B.id;quit;
proc sql;create table temp5 as select a.*,b.respond as r2012 from temp4 a left join final12 b  on A.id=B.id;quit;
proc sql;create table temp6 as select a.*,b.respond as r2013 from temp5 a left join final13 b  on A.id=B.id;quit;
proc sql;create table temp7 as select a.*,b.respond as r2014 from temp6 a left join final14 b  on A.id=B.id;quit;
proc sql;create table temp8 as select a.*,b.respond as r2015 from temp7 a left join final15 b  on A.id=B.id;quit;
data temp8;
set temp8;
N=r2008+r2009+r2010+r2011+r2012+r2013+r2014+r2015;
proc freq;tables N N*type/missing nopercent norow nocol;
run;
*/


* Append all years together, get weighted raw rates;
data final;
set final08 final09 final10 final11 final12 final13 final14 final15;
if year=2008 then do;year=0; time=1;post=0;postyear=0;margin=totmargin2008;end;
else if year=2009 then do;year=1; time=2;post=0;postyear=0;margin=totmargin2009;end;
else if year=2010 then do;year=2; time=3;post=0;postyear=0;margin=totmargin2010;end;
else if year=2011 then do;year=3; time=4;post=1;postyear=0;margin=totmargin2011;end;
else if year=2012 then do;year=4; time=5;post=1;postyear=1;margin=totmargin2012;end;
else if year=2013 then do;year=5; time=6;post=1;postyear=2;margin=totmargin2013;end;
else if year=2014 then do;year=6; time=7;post=1;postyear=3;margin=totmargin2014;end;
else if year=2015 then do;year=7; time=8;post=1;postyear=4;margin=totmargin2015;end;
proc sort;by id time ;
run; 
 


* Main Model and Model projected rates;
proc genmod data=final descending  ;
weight wt;
class id eligibility(ref='0') time post(ref='0')/param=ref;
model basic_adopt=eligibility post year eligibility*year postyear eligibility*post eligibility*postyear  margin/dist=normal link=identity corrb;
repeated subject=id/withinsubject=time type=un  ;
output out=predict p=predict  ;

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
proc sort data=predict nodupkey;by year eligibility;run;
proc means data=predict mean;
Title "Predicted Rates";
class year eligibility;
var predict;
run;
proc means data=final mean;
Title "Observed Raw Rates";
weight wt;
class year eligibility;
var basic_adopt;
run;


* Robustness tests;

/*As a robustness test, we limited the ineligible hospital comparison group to only long-term acute care hospitals since psychiatric and rehabilitation hospitals 
are arguably less similar to general, acute-care hospitals. 
*/
* LTCH;
proc genmod data=final descending  ;
where type in (1,4);
weight wt;
class id eligibility(ref='0') time post(ref='0')/param=ref;
model basic_adopt=eligibility post year eligibility*year postyear eligibility*post eligibility*postyear margin/dist=normal link=identity corrb;
repeated subject=id/withinsubject=time type=un  ;
output out=predict p=predict  ;

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
proc sort data=predict nodupkey;by year eligibility;run;
proc means data=predict mean;
Title "Predicted Rates";
class year eligibility;
var predict;
run;
proc means data=final mean;
where type in (1,4);
Title "Observed Raw Rates";
*weight wt;
class year eligibility;
var basic_adopt;
run;

*Psychiatric;
proc genmod data=final descending  ;
where type in (1,3);
weight wt;
class id eligibility(ref='0') time post(ref='0')/param=ref;
model basic_adopt=eligibility post year eligibility*year postyear eligibility*post eligibility*postyear margin/dist=normal link=identity corrb;
repeated subject=id/withinsubject=time type=un  ;
output out=predict p=predict  ;

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
proc sort data=predict nodupkey;by year eligibility;run;
proc means data=predict mean;
Title "Predicted Rates";
class year eligibility;
var predict;
run;
proc means data=final mean;
where type in (1,3);
Title "Observed Raw Rates";
*weight wt;
class year eligibility;
var basic_adopt;
run;

*Rehab;
proc genmod data=final descending  ;
where type in (1,2);
weight wt;
class id eligibility(ref='0') time post(ref='0')/param=ref;
model basic_adopt=eligibility post year eligibility*year postyear eligibility*post eligibility*postyear margin/dist=normal link=identity corrb;
repeated subject=id/withinsubject=time type=un  ;
output out=predict p=predict  ;

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
proc sort data=predict nodupkey;by year eligibility;run;
proc means data=predict mean;
Title "Predicted Rates";
class year eligibility;
var predict;
run;
proc means data=final mean;
where type in (1,2);
Title "Observed Raw Rates";
*weight wt;
class year eligibility;
var basic_adopt;
run;

/*
As a second robustness test, we compared adoption among the subset of eligible and ineligible hospitals that did not have a basic EHR in the pre-HITECH period. 
We considered hospitals not to have a basic EHR if they lacked physician notes, nursing assessments, discharge summaries, patient problem lists, diagnostic 
test results, and order entry for medications because the remaining basic EHR functions were widely adopted in 2008.
*/

proc sql;
create table hosp as
select *
from hospital
where id in (select id from final where year=0 and basic_adopt=0) and
id in (select id from final where year=1 and basic_adopt=0) and
id in (select id from final where year=2 and basic_adopt=0);
quit;
 
proc freq data=hosp; tables type/missing;run;
/*
proc sort data=final;by id year;run;
proc sql;
create table temp as
select id, type, sum(basic_adopt) as temp
from final
where year in (0,1,2)
group by id;
quit;

proc sql;
create table hosp as
select *
from hospital
where id in (select id from temp where temp=0);
quit;
proc freq data=hosp; tables type/missing;run;
*/
proc sql;
create table robust as
select *
from final
where id in (select id from hosp);
quit;
proc sort data=robust;by id year;
run; 
 

proc genmod data=robust descending  ;
weight wt;
class id eligibility(ref='0') time post(ref='0')/param=ref;
model basic_adopt=eligibility post year eligibility*year postyear eligibility*post eligibility*postyear margin/dist=normal link=identity corrb;
repeated subject=id/withinsubject=time type=exc  ;
output out=predict p=predict  ;

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
proc sort data=predict nodupkey;by year eligibility;run;
proc means data=predict mean;
Title "Predicted Rates";
class year eligibility;
var predict;
run;
proc means data=robust mean;
Title "Observed Raw Rates";
*weight wt;
class year eligibility;
var basic_adopt;
run;


* Single functions;
proc genmod data=final descending  ;
Title "medication CPOE";
weight wt;
class id eligibility(ref='0') time post(ref='0')/param=ref;
model Q1c3=eligibility post year eligibility*year postyear eligibility*post eligibility*postyear margin/dist=normal link=identity corrb;
repeated subject=id/withinsubject=time type=un  ;
output out=predict p=predict  ;

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
proc sort data=predict nodupkey;by year eligibility;run;
proc means data=predict mean;
Title "Predicted Rates";
class year eligibility;
var predict;
run;
proc means data=final mean;
Title "Observed Raw Rates";
*weight wt;
class year eligibility;
var Q1c3;
run;

proc genmod data=final descending  ;
Title "bar-coded medication administration";
weight wt;
class id eligibility(ref='0') time post(ref='0')/param=ref;
model Q1a5=eligibility post year eligibility*year postyear eligibility*post eligibility*postyear margin/dist=normal link=identity corrb;
repeated subject=id/withinsubject=time type=un  ;
output out=predict p=predict  ;

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
proc sort data=predict nodupkey;by year eligibility;run;
proc means data=predict mean;
Title "Predicted Rates";
class year eligibility;
var predict;
run;
proc means data=final mean;
Title "Observed Raw Rates";
*eight wt;
class year eligibility;
var Q1a5;
run;

proc genmod data=final descending  ;
Title "Electronic Clinical documentation: Nursing Notes";
weight wt;
class id eligibility(ref='0') time post(ref='0')/param=ref;
model Q1c1=eligibility post year eligibility*year postyear eligibility*post eligibility*postyear margin/dist=normal link=identity corrb;
repeated subject=id/withinsubject=time type=un  ;
output out=predict p=predict  ;

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
proc sort data=predict nodupkey;by year eligibility;run;
proc means data=predict mean;
Title "Predicted Rates";
class year eligibility;
var predict;
run;
proc means data=final mean;
Title "Observed Raw Rates";
*weight wt;
class year eligibility;
var Q1c1;
run;

* Stratefied by hosp characteristics;
proc genmod data=final descending  ;
title "Stratefied by System Affiliation";
weight wt;
class id eligibility(ref='0') time post(ref='0') system(ref="0") /param=ref;
model basic_adopt=eligibility post year eligibility*year postyear eligibility*post eligibility*postyear
                  System System*eligibility System*post System*year System*eligibility*year System*postyear System*eligibility*post System*eligibility*postyear margin/dist=normal link=identity corrb;
repeated subject=id/withinsubject=time type=un  ;
output out=predict p=predict  ;
 
estimate "No System Affiliation, In-Elligible, Pre" year 1 ;
estimate "No System Affiliation, In-Elligible, Post"   year 1 postyear 1 ;
estimate "No System Affiliation, Elligible, Pre"  year 1 eligibility*year  1 ;
estimate "No System Affiliation, Elligible, Post"  year 1 eligibility*year 1 postyear 1 eligibility*postyear 1;

estimate "No System Affiliation, Diff In-Elligble Post vs Pre" postyear 1  ;
estimate "No System Affiliation, Diff Eligible Post vs Pre"  postyear 1 eligibility*postyear 1 ;
estimate "No System Affiliation, Diff Pre Eligible vs In-Elligble" eligibility*year  1  ;
estimate "No System Affiliation, Diff Post Eligible vs In-Elligble" eligibility*year 1  eligibility*postyear 1 ;

estimate "No System Affiliation, Diff-in-Diff"  eligibility*postyear 1 ;

estimate "Has System Affiliation, In-Elligible, Pre" year 1 System*year 1;
estimate "Has System Affiliation, In-Elligible, Post"   year 1 postyear 1 System*year 1 System*postyear 1;
estimate "Has System Affiliation, Elligible, Pre"  year 1 eligibility*year 1 System*year 1  System*eligibility*year 1;
estimate "Has System Affiliation, Elligible, Post"  year 1 eligibility*year 1 postyear 1 eligibility*postyear 1 System*year 1 System*eligibility*year 1 System*postyear 1 System*eligibility*postyear 1;

estimate "Has System Affiliation, Diff In-Elligble Post vs Pre" postyear 1  System*postyear 1 ;
estimate "Has System Affiliation, Diff Eligible Post vs Pre" postyear 1 eligibility*postyear 1  System*postyear 1 System*eligibility*postyear 1;
estimate "Has System Affiliation, Diff Pre Eligible vs In-Elligble" eligibility*year 1  System*eligibility*year 1;
estimate "Has System Affiliation, Diff Post Eligible vs In-Elligble"  eligibility*year 1   eligibility*postyear 1   System*eligibility*year 1  System*eligibility*postyear 1;

estimate "Has System Affiliation, Diff-in-Diff" eligibility*postyear 1  System*eligibility*postyear 1 ;

estimate "Diff-in-Diff: Affiliated vs non-Affiliated"  System*eligibility*postyear 1 ;

run;
proc sort data=predict nodupkey;by year eligibility System;run;
proc means data=predict mean;
Title "Predicted Rates";
class year eligibility System;
var predict;
run;
proc means data=final mean;
Title "Observed Raw Rates";
*weight wt;
class year eligibility System;
var basic_adopt;
run;




* Stratefied by ownership;
proc genmod data=final descending  ;
title "Stratefied by Ownership";
weight wt;
class id eligibility(ref='0') time post(ref='0') profit2(ref="3") /param=ref;
model basic_adopt=eligibility post year eligibility*year postyear eligibility*post eligibility*postyear
                  profit2 profit2*eligibility profit2*post profit2*year profit2*eligibility*year profit2*postyear profit2*eligibility*post profit2*eligibility*postyear margin/dist=normal link=identity corrb;
repeated subject=id/withinsubject=time type=un  ;
output out=predict p=predict  ;
 

*  Investor Owned ;
estimate "profit2=1, In-Elligible, Pre" year 1 profit2*year 1 0 -1;
estimate "profit2=1, In-Elligible, Post"   year 1 postyear 1 profit2*year 1 0 -1 profit2*postyear 1 0 -1;
estimate "profit2=1, Elligible, Pre"  year 1 eligibility*year 1 profit2*year 1 0 -1  profit2*eligibility*year 1 0 -1;
estimate "profit2=1, Elligible, Post"  year 1 eligibility*year 1 postyear 1 eligibility*postyear 1 profit2*year 1 0 -1 profit2*eligibility*year 1 0 -1 profit2*postyear 1 0 -1 profit2*eligibility*postyear 1 0 -1;

estimate "profit2=1, Diff In-Elligble Post vs Pre" postyear 1  profit2*postyear 1 0 -1 ;
estimate "profit2=1, Diff Eligible Post vs Pre" postyear 1 eligibility*postyear 1  profit2*postyear 1 0 -1 profit2*eligibility*postyear 1 0 -1;
estimate "profit2=1, Diff Pre Eligible vs In-Elligble" eligibility*year 1  profit2*eligibility*year 1 0 -1;
estimate "profit2=1, Diff Post Eligible vs In-Elligble"  eligibility*year 1   eligibility*postyear 1   profit2*eligibility*year 1 0 -1  profit2*eligibility*postyear 1 0 -1;

estimate "profit2=1, Diff-in-Diff" eligibility*postyear 1   profit2*eligibility*postyear 1 0 -1;
* Non-Government, Not-For-Profit;
estimate "profit2=2, In-Elligible, Pre" year 1 profit2*year 0 1 -1;
estimate "profit2=2, In-Elligible, Post"   year 1 postyear 1 profit2*year  0 1 -1 profit2*postyear  0 1 -1;
estimate "profit2=2, Elligible, Pre"  year 1 eligibility*year 1 profit2*year  0 1 -1  profit2*eligibility*year  0 1 -1;
estimate "profit2=2, Elligible, Post"  year 1 eligibility*year 1 postyear 1 eligibility*postyear 1 profit2*year  0 1 -1 profit2*eligibility*year  0 1 -1 profit2*postyear  0 1 -1 profit2*eligibility*postyear  0 1 -1;

estimate "profit2=2, Diff In-Elligble Post vs Pre" postyear 1  profit2*postyear  0 1 -1 ;
estimate "profit2=2, Diff Eligible Post vs Pre" postyear 1 eligibility*postyear 1  profit2*postyear  0 1 -1 profit2*eligibility*postyear  0 1 -1;
estimate "profit2=2, Diff Pre Eligible vs In-Elligble" eligibility*year 1  profit2*eligibility*year  0 1 -1;
estimate "profit2=2, Diff Post Eligible vs In-Elligble"  eligibility*year 1   eligibility*postyear 1   profit2*eligibility*year  0 1 -1  profit2*eligibility*postyear  0 1 -1;

estimate "profit2=2, Diff-in-Diff" eligibility*postyear 1   profit2*eligibility*postyear  0 1 -1;
* Government, Non-Federal;
estimate "profit2=3, In-Elligible, Pre" year 1 ;
estimate "profit2=3, In-Elligible, Post"   year 1 postyear 1 ;
estimate "profit2=3, Elligible, Pre"  year 1 eligibility*year  1 ;
estimate "profit2=3, Elligible, Post"  year 1 eligibility*year 1 postyear 1 eligibility*postyear 1;

estimate "profit2=3, Diff In-Elligble Post vs Pre" postyear 1  ;
estimate "profit2=3, Diff Eligible Post vs Pre"  postyear 1 eligibility*postyear 1 ;
estimate "profit2=3, Diff Pre Eligible vs In-Elligble" eligibility*year  1  ;
estimate "profit2=3, Diff Post Eligible vs In-Elligble" eligibility*year 1  eligibility*postyear 1 ;

estimate "profit2=3, Diff-in-Diff"  eligibility*postyear 1 ;
 
* Compare diff;

estimate "Diff-in-Diff: profit2=1 vs profit2=3" profit2*eligibility*postyear 1 0 -1 ;
estimate "Diff-in-Diff: profit2=2 vs profit2=3" profit2*eligibility*postyear  0 1 -1 ;
estimate "Diff-in-Diff: profit2=1 vs profit2=2" profit2*eligibility*postyear  1 -1 0;


run;
proc sort data=predict nodupkey;by year eligibility profit2;run;
proc means data=predict mean;
Title "Predicted Rates";
class year eligibility profit2;
var predict;
run;
proc means data=final mean;
Title "Observed Raw Rates";
*weight wt;
class year eligibility profit2;
var basic_adopt;
run;





* Stratefied by Size;
proc genmod data=final descending  ;
title "Stratefied by Size";
weight wt;
class id eligibility(ref='0') time post(ref='0') hospsize(ref="3") /param=ref;
model basic_adopt=eligibility post year eligibility*year postyear eligibility*post eligibility*postyear
                  hospsize hospsize*eligibility hospsize*post hospsize*year hospsize*eligibility*year hospsize*postyear hospsize*eligibility*post hospsize*eligibility*postyear margin/dist=normal link=identity corrb;
repeated subject=id/withinsubject=time type=un  ;
output out=predict p=predict  ;

* Small;
estimate "hospsize=1, In-Elligible, Pre" year 1 hospsize*year 1 0 -1;
estimate "hospsize=1, In-Elligible, Post"   year 1 postyear 1 hospsize*year 1 0 -1 hospsize*postyear 1 0 -1;
estimate "hospsize=1, Elligible, Pre"  year 1 eligibility*year 1 hospsize*year 1 0 -1  hospsize*eligibility*year 1 0 -1;
estimate "hospsize=1, Elligible, Post"  year 1 eligibility*year 1 postyear 1 eligibility*postyear 1 hospsize*year 1 0 -1 hospsize*eligibility*year 1 0 -1 hospsize*postyear 1 0 -1 hospsize*eligibility*postyear 1 0 -1;

estimate "hospsize=1, Diff In-Elligble Post vs Pre" postyear 1  hospsize*postyear 1 0 -1 ;
estimate "hospsize=1, Diff Eligible Post vs Pre" postyear 1 eligibility*postyear 1  hospsize*postyear 1 0 -1 hospsize*eligibility*postyear 1 0 -1;
estimate "hospsize=1, Diff Pre Eligible vs In-Elligble" eligibility*year 1  hospsize*eligibility*year 1 0 -1;
estimate "hospsize=1, Diff Post Eligible vs In-Elligble"  eligibility*year 1   eligibility*postyear 1   hospsize*eligibility*year 1 0 -1  hospsize*eligibility*postyear 1 0 -1;

estimate "hospsize=1, Diff-in-Diff" eligibility*postyear 1   hospsize*eligibility*postyear 1 0 -1;
* Medium;
estimate "hospsize=2, In-Elligible, Pre" year 1 hospsize*year 0 1 -1;
estimate "hospsize=2, In-Elligible, Post"   year 1 postyear 1 hospsize*year  0 1 -1 hospsize*postyear  0 1 -1;
estimate "hospsize=2, Elligible, Pre"  year 1 eligibility*year 1 hospsize*year  0 1 -1  hospsize*eligibility*year  0 1 -1;
estimate "hospsize=2, Elligible, Post"  year 1 eligibility*year 1 postyear 1 eligibility*postyear 1 hospsize*year  0 1 -1 hospsize*eligibility*year  0 1 -1 hospsize*postyear  0 1 -1 hospsize*eligibility*postyear  0 1 -1;

estimate "hospsize=2, Diff In-Elligble Post vs Pre" postyear 1  hospsize*postyear  0 1 -1 ;
estimate "hospsize=2, Diff Eligible Post vs Pre" postyear 1 eligibility*postyear 1  hospsize*postyear  0 1 -1 hospsize*eligibility*postyear  0 1 -1;
estimate "hospsize=2, Diff Pre Eligible vs In-Elligble" eligibility*year 1  hospsize*eligibility*year  0 1 -1;
estimate "hospsize=2, Diff Post Eligible vs In-Elligble"  eligibility*year 1   eligibility*postyear 1   hospsize*eligibility*year  0 1 -1  hospsize*eligibility*postyear  0 1 -1;

estimate "hospsize=2, Diff-in-Diff" eligibility*postyear 1   hospsize*eligibility*postyear  0 1 -1;
*  Large;
estimate "hospsize=3, In-Elligible, Pre" year 1 ;
estimate "hospsize=3, In-Elligible, Post"   year 1 postyear 1 ;
estimate "hospsize=3, Elligible, Pre"  year 1 eligibility*year  1 ;
estimate "hospsize=3, Elligible, Post"  year 1 eligibility*year 1 postyear 1 eligibility*postyear 1;

estimate "hospsize=3, Diff In-Elligble Post vs Pre" postyear 1  ;
estimate "hospsize=3, Diff Eligible Post vs Pre"  postyear 1 eligibility*postyear 1 ;
estimate "hospsize=3, Diff Pre Eligible vs In-Elligble" eligibility*year  1  ;
estimate "hospsize=3, Diff Post Eligible vs In-Elligble" eligibility*year 1  eligibility*postyear 1 ;

estimate "hospsize=3, Diff-in-Diff"  eligibility*postyear 1 ;
* Compare diff;

estimate "Diff-in-Diff: hospsize=1 vs hospsize=3" hospsize*eligibility*postyear 1 0 -1 ;
estimate "Diff-in-Diff: hospsize=2 vs hospsize=3" hospsize*eligibility*postyear  0 1 -1 ;
estimate "Diff-in-Diff: hospsize=1 vs hospsize=2" hospsize*eligibility*postyear  1 -1 0;


run;
proc sort data=predict nodupkey;by year eligibility hospsize;run;
proc means data=predict mean;
Title "Predicted Rates";
class year eligibility hospsize;
var predict;
run;
proc means data=final mean;
Title "Observed Raw Rates";
*weight wt;
class year eligibility hospsize;
var basic_adopt;
run;

 
 
* Stratefied by Teaching Status;
proc genmod data=final descending  ;
title "Stratefied by Teaching";
weight wt;
class id eligibility(ref='0') time post(ref='0') teaching(ref="3") /param=ref;
model basic_adopt=eligibility post year eligibility*year postyear eligibility*post eligibility*postyear
                  teaching teaching*eligibility teaching*post teaching*year teaching*eligibility*year teaching*postyear teaching*eligibility*post teaching*eligibility*postyear margin/dist=normal link=identity corrb;
repeated subject=id/withinsubject=time type=un  ;
output out=predict p=predict  ;
 

* 1=Major, 2=Minor, 3=Non-Teaching;
estimate "teaching=1, In-Elligible, Pre" year 1 teaching*year 1 0 -1;
estimate "teaching=1, In-Elligible, Post"   year 1 postyear 1 teaching*year 1 0 -1 teaching*postyear 1 0 -1;
estimate "teaching=1, Elligible, Pre"  year 1 eligibility*year 1 teaching*year 1 0 -1  teaching*eligibility*year 1 0 -1;
estimate "teaching=1, Elligible, Post"  year 1 eligibility*year 1 postyear 1 eligibility*postyear 1 teaching*year 1 0 -1 teaching*eligibility*year 1 0 -1 teaching*postyear 1 0 -1 teaching*eligibility*postyear 1 0 -1;

estimate "teaching=1, Diff In-Elligble Post vs Pre" postyear 1  teaching*postyear 1 0 -1 ;
estimate "teaching=1, Diff Eligible Post vs Pre" postyear 1 eligibility*postyear 1  teaching*postyear 1 0 -1 teaching*eligibility*postyear 1 0 -1;
estimate "teaching=1, Diff Pre Eligible vs In-Elligble" eligibility*year 1  teaching*eligibility*year 1 0 -1;
estimate "teaching=1, Diff Post Eligible vs In-Elligble"  eligibility*year 1   eligibility*postyear 1   teaching*eligibility*year 1 0 -1  teaching*eligibility*postyear 1 0 -1;

estimate "teaching=1, Diff-in-Diff" eligibility*postyear 1   teaching*eligibility*postyear 1 0 -1;
* 1=Major, 2=Minor, 3=Non-Teaching;
estimate "teaching=2, In-Elligible, Pre" year 1 teaching*year 0 1 -1;
estimate "teaching=2, In-Elligible, Post"   year 1 postyear 1 teaching*year  0 1 -1 teaching*postyear  0 1 -1;
estimate "teaching=2, Elligible, Pre"  year 1 eligibility*year 1 teaching*year  0 1 -1  teaching*eligibility*year  0 1 -1;
estimate "teaching=2, Elligible, Post"  year 1 eligibility*year 1 postyear 1 eligibility*postyear 1 teaching*year  0 1 -1 teaching*eligibility*year  0 1 -1 teaching*postyear  0 1 -1 teaching*eligibility*postyear  0 1 -1;

estimate "teaching=2, Diff In-Elligble Post vs Pre" postyear 1  teaching*postyear  0 1 -1 ;
estimate "teaching=2, Diff Eligible Post vs Pre" postyear 1 eligibility*postyear 1  teaching*postyear  0 1 -1 teaching*eligibility*postyear  0 1 -1;
estimate "teaching=2, Diff Pre Eligible vs In-Elligble" eligibility*year 1  teaching*eligibility*year  0 1 -1;
estimate "teaching=2, Diff Post Eligible vs In-Elligble"  eligibility*year 1   eligibility*postyear 1   teaching*eligibility*year  0 1 -1  teaching*eligibility*postyear  0 1 -1;

estimate "teaching=2, Diff-in-Diff" eligibility*postyear 1   teaching*eligibility*postyear  0 1 -1;
* 1=Major, 2=Minor, 3=Non-Teaching;
estimate "teaching=3, In-Elligible, Pre" year 1 ;
estimate "teaching=3, In-Elligible, Post"   year 1 postyear 1 ;
estimate "teaching=3, Elligible, Pre"  year 1 eligibility*year  1 ;
estimate "teaching=3, Elligible, Post"  year 1 eligibility*year 1 postyear 1 eligibility*postyear 1;

estimate "teaching=3, Diff In-Elligble Post vs Pre" postyear 1  ;
estimate "teaching=3, Diff Eligible Post vs Pre"  postyear 1 eligibility*postyear 1 ;
estimate "teaching=3, Diff Pre Eligible vs In-Elligble" eligibility*year  1  ;
estimate "teaching=3, Diff Post Eligible vs In-Elligble" eligibility*year 1  eligibility*postyear 1 ;

estimate "teaching=3, Diff-in-Diff"  eligibility*postyear 1 ;
* Compare diff;

estimate "Diff-in-Diff: teaching=1 vs teaching=3" teaching*eligibility*postyear 1 0 -1 ;
estimate "Diff-in-Diff: teaching=2 vs teaching=3" teaching*eligibility*postyear  0 1 -1 ;
estimate "Diff-in-Diff: teaching=1 vs teaching=2" teaching*eligibility*postyear  1 -1 0;


run;
proc sort data=predict nodupkey;by year eligibility teaching;run;
proc means data=predict mean;
Title "Predicted Rates";
class year eligibility teaching;
var predict;
run;
proc means data=final mean;
Title "Observed Raw Rates";
*weight wt;
class year eligibility teaching;
var basic_adopt;
run;

 

* Stratefied by Region;
proc genmod data=final descending  ;
title "Stratefied by Region";
weight wt;
class id eligibility(ref='0') time post(ref='0') hosp_reg4(ref="4") /param=ref;
model basic_adopt=eligibility post year eligibility*year postyear eligibility*post eligibility*postyear
                  hosp_reg4 hosp_reg4*eligibility hosp_reg4*post hosp_reg4*year hosp_reg4*eligibility*year hosp_reg4*postyear hosp_reg4*eligibility*post hosp_reg4*eligibility*postyear margin/dist=normal link=identity corrb;
repeated subject=id/withinsubject=time type=un  ;
output out=predict p=predict  ;
 
* 1=NE, 2=MW, 3=S, 4=W, 5=PR/OTH;
estimate "hosp_reg4=1, In-Elligible, Pre" year 1 hosp_reg4*year 1 0 0 -1;
estimate "hosp_reg4=1, In-Elligible, Post"   year 1 postyear 1 hosp_reg4*year 1 0 0 -1 hosp_reg4*postyear 1 0 0 -1;
estimate "hosp_reg4=1, Elligible, Pre"  year 1 eligibility*year 1 hosp_reg4*year 1 0 0 -1 hosp_reg4*eligibility*year 1 0 0 -1;
estimate "hosp_reg4=1, Elligible, Post"  year 1 eligibility*year 1 postyear 1 eligibility*postyear 1 hosp_reg4*year 1 0 0 -1 hosp_reg4*eligibility*year 1 0 0 -1 hosp_reg4*postyear 1 0 0 -1 hosp_reg4*eligibility*postyear 1 0 0 -1;

estimate "hosp_reg4=1, Diff In-Elligble Post vs Pre" postyear 1  hosp_reg4*postyear 1 0 0 -1 ;
estimate "hosp_reg4=1, Diff Eligible Post vs Pre" postyear 1 eligibility*postyear 1  hosp_reg4*postyear 1 0 0 -1 hosp_reg4*eligibility*postyear 1 0 0 -1;
estimate "hosp_reg4=1, Diff Pre Eligible vs In-Elligble" eligibility*year 1  hosp_reg4*eligibility*year 1 0 0 -1;
estimate "hosp_reg4=1, Diff Post Eligible vs In-Elligble"  eligibility*year 1   eligibility*postyear 1   hosp_reg4*eligibility*year 1 0 0 -1  hosp_reg4*eligibility*postyear 1 0 0 -1;

estimate "hosp_reg4=1, Diff-in-Diff" eligibility*postyear 1   hosp_reg4*eligibility*postyear 1 0 0 -1;
* 1=NE, 2=MW, 3=S, 4=W, 5=PR/OTH;
estimate "hosp_reg4=2, In-Elligible, Pre" year 1 hosp_reg4*year 0 1 0 -1;
estimate "hosp_reg4=2, In-Elligible, Post"   year 1 postyear 1 hosp_reg4*year  0 1 0 -1 hosp_reg4*postyear  0 1 0 -1;
estimate "hosp_reg4=2, Elligible, Pre"  year 1 eligibility*year 1 hosp_reg4*year  0 1 0 -1  hosp_reg4*eligibility*year  0 1 0 -1;
estimate "hosp_reg4=2, Elligible, Post"  year 1 eligibility*year 1 postyear 1 eligibility*postyear 1 hosp_reg4*year 0 1 0 -1 hosp_reg4*eligibility*year 0 1 0 -1 hosp_reg4*postyear 0 1 0 -1 hosp_reg4*eligibility*postyear 0 1 0 -1;

estimate "hosp_reg4=2, Diff In-Elligble Post vs Pre" postyear 1  hosp_reg4*postyear 0 1 0 -1;
estimate "hosp_reg4=2, Diff Eligible Post vs Pre" postyear 1 eligibility*postyear 1  hosp_reg4*postyear 0 1 0 -1 hosp_reg4*eligibility*postyear 0 1 0 -1;
estimate "hosp_reg4=2, Diff Pre Eligible vs In-Elligble" eligibility*year 1  hosp_reg4*eligibility*year 0 1 0 -1;
estimate "hosp_reg4=2, Diff Post Eligible vs In-Elligble"  eligibility*year 1   eligibility*postyear 1   hosp_reg4*eligibility*year 0 1 0 -1 hosp_reg4*eligibility*postyear 0 1 0 -1;

estimate "hosp_reg4=2, Diff-in-Diff" eligibility*postyear 1   hosp_reg4*eligibility*postyear 0 1 0 -1;

* 1=NE, 2=MW, 3=S, 4=W, 5=PR/OTH;
estimate "hosp_reg4=3, In-Elligible, Pre" year 1 hosp_reg4*year 0 0 1 -1;
estimate "hosp_reg4=3, In-Elligible, Post"   year 1 postyear 1 hosp_reg4*year  0 0 1 -1 hosp_reg4*postyear  0 0 1 -1;
estimate "hosp_reg4=3, Elligible, Pre"  year 1 eligibility*year 1 hosp_reg4*year  0 0 1 -1 hosp_reg4*eligibility*year 0 0 1 -1;
estimate "hosp_reg4=3, Elligible, Post"  year 1 eligibility*year 1 postyear 1 eligibility*postyear 1 hosp_reg4*year 0 0 1 -1 hosp_reg4*eligibility*year 0 0 1 -1 hosp_reg4*postyear 0 0 1 -1 hosp_reg4*eligibility*postyear 0 0 1 -1;

estimate "hosp_reg4=3, Diff In-Elligble Post vs Pre" postyear 1  hosp_reg4*postyear 0 0 1 -1;
estimate "hosp_reg4=3, Diff Eligible Post vs Pre" postyear 1 eligibility*postyear 1  hosp_reg4*postyear 0 0 1 -1 hosp_reg4*eligibility*postyear 0 0 1 -1;
estimate "hosp_reg4=3, Diff Pre Eligible vs In-Elligble" eligibility*year 1  hosp_reg4*eligibility*year 0 0 1 -1;
estimate "hosp_reg4=3, Diff Post Eligible vs In-Elligble"  eligibility*year 1   eligibility*postyear 1   hosp_reg4*eligibility*year 0 0 1 -1 hosp_reg4*eligibility*postyear 0 0 1 -1;

estimate "hosp_reg4=3, Diff-in-Diff" eligibility*postyear 1   hosp_reg4*eligibility*postyear 0 0 1 -1;


* 1=NE, 2=MW, 3=S, 4=W, 5=PR/OTH;
estimate "hosp_reg4=4, In-Elligible, Pre" year 1 ;
estimate "hosp_reg4=4, In-Elligible, Post"   year 1 postyear 1 ;
estimate "hosp_reg4=4, Elligible, Pre"  year 1 eligibility*year  1 ;
estimate "hosp_reg4=4, Elligible, Post"  year 1 eligibility*year 1 postyear 1 eligibility*postyear 1;

estimate "hosp_reg4=4, Diff In-Elligble Post vs Pre" postyear 1  ;
estimate "hosp_reg4=4, Diff Eligible Post vs Pre"  postyear 1 eligibility*postyear 1 ;
estimate "hosp_reg4=4, Diff Pre Eligible vs In-Elligble" eligibility*year  1  ;
estimate "hosp_reg4=4, Diff Post Eligible vs In-Elligble" eligibility*year 1  eligibility*postyear 1 ;

estimate "hosp_reg4=4, Diff-in-Diff"  eligibility*postyear 1 ;
* Compare diff;

estimate "Diff-in-Diff: hosp_reg4=1 vs hosp_reg4=4" hosp_reg4*eligibility*postyear 1 0 0 -1 ;
estimate "Diff-in-Diff: hosp_reg4=2 vs hosp_reg4=4" hosp_reg4*eligibility*postyear  0 1 0 -1 ;
estimate "Diff-in-Diff: hosp_reg4=3 vs hosp_reg4=4" hosp_reg4*eligibility*postyear  0 0 1 -1 ;
estimate "Diff-in-Diff: hosp_reg4=1 vs hosp_reg4=2" hosp_reg4*eligibility*postyear 1 -1 0 0;
estimate "Diff-in-Diff: hosp_reg4=1 vs hosp_reg4=3" hosp_reg4*eligibility*postyear 1 0  -1 0;
estimate "Diff-in-Diff: hosp_reg4=2 vs hosp_reg4=3" hosp_reg4*eligibility*postyear 0 1 -1 0  ;


run;
proc sort data=predict nodupkey;by year eligibility hosp_reg4;run;
proc means data=predict mean;
Title "Predicted Rates";
class year eligibility hosp_reg4;
var predict;
run;
proc means data=final mean;
Title "Observed Raw Rates";
*weight wt;
class year eligibility hosp_reg4;
var basic_adopt;
run;

* Stratefied by Urban;
proc genmod data=final descending  ;
title "Stratefied by Urban/Rual";
weight wt;
class id eligibility(ref='0') time post(ref='0') Urban(ref="0") /param=ref;
model basic_adopt=eligibility post year eligibility*year postyear eligibility*post eligibility*postyear
                  Urban Urban*eligibility Urban*post Urban*year Urban*eligibility*year Urban*postyear Urban*eligibility*post Urban*eligibility*postyear margin/dist=normal link=identity corrb;
repeated subject=id/withinsubject=time type=un  ;
output out=predict p=predict  ;
 
estimate "Rural, In-Elligible, Pre" year 1 ;
estimate "Rural, In-Elligible, Post"   year 1 postyear 1 ;
estimate "Rural, Elligible, Pre"  year 1 eligibility*year  1 ;
estimate "Rural, Elligible, Post"  year 1 eligibility*year 1 postyear 1 eligibility*postyear 1;

estimate "Rural, Diff In-Elligble Post vs Pre" postyear 1  ;
estimate "Rural, Diff Eligible Post vs Pre"  postyear 1 eligibility*postyear 1 ;
estimate "Rural, Diff Pre Eligible vs In-Elligble" eligibility*year  1  ;
estimate "Rural, Diff Post Eligible vs In-Elligble" eligibility*year 1  eligibility*postyear 1 ;

estimate "Rural, Diff-in-Diff"  eligibility*postyear 1 ;

estimate "Urban, In-Elligible, Pre" year 1 Urban*year 1;
estimate "Urban, In-Elligible, Post"   year 1 postyear 1 Urban*year 1 Urban*postyear 1;
estimate "Urban, Elligible, Pre"  year 1 eligibility*year 1 Urban*year 1  Urban*eligibility*year 1;
estimate "Urban, Elligible, Post"  year 1 eligibility*year 1 postyear 1 eligibility*postyear 1 Urban*year 1 Urban*eligibility*year 1 Urban*postyear 1 Urban*eligibility*postyear 1;

estimate "Urban, Diff In-Elligble Post vs Pre" postyear 1  Urban*postyear 1 ;
estimate "Urban, Diff Eligible Post vs Pre" postyear 1 eligibility*postyear 1  Urban*postyear 1 Urban*eligibility*postyear 1;
estimate "Urban, Diff Pre Eligible vs In-Elligble" eligibility*year 1  Urban*eligibility*year 1;
estimate "Urban, Diff Post Eligible vs In-Elligble"  eligibility*year 1   eligibility*postyear 1   Urban*eligibility*year 1  Urban*eligibility*postyear 1;

estimate "Urban, Diff-in-Diff" eligibility*postyear 1  Urban*eligibility*postyear 1 ;

estimate "Diff-in-Diff: Urban vs Rural"  Urban*eligibility*postyear 1 ;

run;
proc sort data=predict nodupkey;by year eligibility Urban;run;
proc means data=predict mean;
Title "Predicted Rates";
class year eligibility Urban;
var predict;
run;
proc means data=final mean;
Title "Observed Raw Rates";
*weight wt;
class year eligibility Urban;
var basic_adopt;
run;

* Stratefied by CAH;
proc genmod data=final descending  ;
title "Stratefied by CAH";
weight wt;
class id eligibility(ref='0') time post(ref='0') CAH(ref="0") /param=ref;
model basic_adopt=eligibility post year eligibility*year postyear eligibility*post eligibility*postyear
                  CAH CAH*eligibility CAH*post CAH*year CAH*eligibility*year CAH*postyear CAH*eligibility*post CAH*eligibility*postyear margin/dist=normal link=identity corrb;
repeated subject=id/withinsubject=time type=un  ;
output out=predict p=predict  ;
 
estimate "Non-CAH, In-Elligible, Pre" year 1 ;
estimate "Non-CAH, In-Elligible, Post"   year 1 postyear 1 ;
estimate "Non-CAH, Elligible, Pre"  year 1 eligibility*year  1 ;
estimate "Non-CAH, Elligible, Post"  year 1 eligibility*year 1 postyear 1 eligibility*postyear 1;

estimate "Non-CAH, Diff In-Elligble Post vs Pre" postyear 1  ;
estimate "Non-CAH, Diff Eligible Post vs Pre"  postyear 1 eligibility*postyear 1 ;
estimate "Non-CAH, Diff Pre Eligible vs In-Elligble" eligibility*year  1  ;
estimate "Non-CAH, Diff Post Eligible vs In-Elligble" eligibility*year 1  eligibility*postyear 1 ;

estimate "Non-CAH, Diff-in-Diff"  eligibility*postyear 1 ;

estimate "CAH, In-Elligible, Pre" year 1 CAH*year 1;
estimate "CAH, In-Elligible, Post"   year 1 postyear 1 CAH*year 1 CAH*postyear 1;
estimate "CAH, Elligible, Pre"  year 1 eligibility*year 1 CAH*year 1  CAH*eligibility*year 1;
estimate "CAH, Elligible, Post"  year 1 eligibility*year 1 postyear 1 eligibility*postyear 1 CAH*year 1 CAH*eligibility*year 1 CAH*postyear 1 CAH*eligibility*postyear 1;

estimate "CAH, Diff In-Elligble Post vs Pre" postyear 1  CAH*postyear 1 ;
estimate "CAH, Diff Eligible Post vs Pre" postyear 1 eligibility*postyear 1  CAH*postyear 1 CAH*eligibility*postyear 1;
estimate "CAH, Diff Pre Eligible vs In-Elligble" eligibility*year 1  CAH*eligibility*year 1;
estimate "CAH, Diff Post Eligible vs In-Elligble"  eligibility*year 1   eligibility*postyear 1   CAH*eligibility*year 1  CAH*eligibility*postyear 1;

estimate "CAH, Diff-in-Diff" eligibility*postyear 1  CAH*eligibility*postyear 1 ;

estimate "Diff-in-Diff: CAH vs Non-CAH"  CAH*eligibility*postyear 1 ;

run;
proc sort data=predict nodupkey;by year eligibility CAH;run;
proc means data=predict mean;
Title "Predicted Rates";
class year eligibility CAH;
var predict;
run;
proc means data=final mean;
Title "Observed Raw Rates";
*weight wt;
class year eligibility CAH;
var basic_adopt;
run;



*********************************
Ramp up compare to Basic EHR
********************************;
proc means data=final mean;
where eligibility=1;
*weight wt;
class year;
var ramp basic_adopt ;
run;

proc means data=final mean;
where eligibility=0;
*weight wt;
class year;
var ramp basic_adopt ;
run;
