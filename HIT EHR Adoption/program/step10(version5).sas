******************************************************************************
Version 5 Analyses
Xiner Zhou
12/17/2014
******************************************************************************;

/*
Chatted with Ashish tonight.  We want to continue to play with the MU results.  Here is what we'd like:
(1) can you re-run the MU and non-MU (broad) results LIMITED TO functions with <50% adoption in both groups of hospitals in 2008?
--So look at individual function , select those having <50% adoption in both groups in 2008 as a new set of functions for “MU or non-MU (broad)”. 
*/

/*

- the MU function mapping to AHA IT survey measures is in attached; 

1. Patient Demographics --> q1a1
2. Patient Problem Lists -->q1d1
3. Patient Medication Lists -->q1e1
4. CPOE for Medications --> q1c3 
5. Discharge Summaries --> q1f1
6. Implement one clinical decision support rule: 
   CDS for guidelines, reminders, allergies, drug interactions, lab interactions, or dosing support --> q1a4 --q1f4
7. Drug-drug and drug-allergy interaction checking --> q1c4 and q1d4

-->q1a1 q1d1 q1e1 q1c3 q1f1 q1a4--q1f4 

--all other AHA IT functions under 
"Clinical Doc"                             q1a1---q1g1
"Results Viewing"                          q1a2---q1f2
"CPOE"                                     q1a3---q1e3
and "CDS"                                  q1a4---q1f4
remaining after taking out the MU ones.
-->      q1b1 q1c1                q1g1 
    q1a2 q1b2 q1c2 q1d2 q1e2 q1f2
    q1a3 q1b3      q1d3 q1e3
*/



















/*
Chatted with Ashish tonight.  We want to continue to play with the MU results.  Here is what we'd like:
(1) can you re-run the MU and non-MU (broad) results LIMITED TO functions with <50% adoption in both groups of hospitals in 2008?
(2) can you run the "standard" model looking at adoption of the following functionalities (i.e., binary dependent variable -- one model for each outcome below):
- medication CPOE
- discharge summaries
- patient problem list
- patient medication list
- drug-drug interaction checking
- drug-allergy interaction checking
- drug dosing support
- drug lab interaction checking
- clinical guidelines
- clinical reminders

*/






/*
One more question/request:) how many eligible hospitals are in Puerto Rico, Guam, and other territories? Do we count them as eligible? 
They apparently didn't get incentives and so we should pull them out if they are in. And I would love an analysis that compares short term acute care 
in US vs territories if there are enough of them. Thx!!

Currently, there remain a total of fifteen territories of the United States, five of which are inhabited: Puerto Rico, Guam, Northern Marianas, 
U. S. Virgin Islands and American Samoa. The remaining ten territories are the following small islands, atolls and reefs, spread across the Caribbean 
or the Pacific Ocean, with no native or permanent populations: Palmyra Atoll, Baker Island, Howland Island, Jarvis Island, Johnston Atoll, Kingman Reef, 
Wake Island, Midway Islands, Navassa Island and Serranilla Bank.

*/

libname HIT "C:\data\Data\Hospital\AHA\HIT\data";
libname impact "C:\data\Data\Hospital\Impact";
LIBNAME AHA 	"C:\data\Data\Hospital\AHA\Annual_Survey\data";
libname rural 'C:\data\Data\RUCA';

%macro MU(var=);

data temp;
set aha.aha12;

if profit2 ^=4;
* Egilible Acute Care Hospitals (general medical and surgical ;
if serv=10 then type=1; 
* Inegilible Rehabilitation ;
if serv=46  then type=2;
* Inegilible Psychiatric ; 
if serv=22  then type=3; 
* Inegilible Long-Term Acute Care ;
if serv=80 then type=4;

if sysid ^='' then system=1; else system=0;
 
if type in (1,2,3,4);
if type=1 then eligibility=1;else eligibility=0;
keep provider id zip type eligibility hospsize hosp_reg4 profit2 teaching system p_medicare p_medicaid nurse_ratio ;
run;
 
* Add RUCA level from external file;
proc sql;
create table temp1 as
select a.*,b.ruca_level
from temp A left join rural.SAS_2006_RUCA B
on A.zip=B.ZIPA;
quit;

%macro imp_xls(file=,out=);
proc import datafile="&file." dbms=xls out=&out. replace;
getnames=yes;
run;
%mend imp_xls;

%imp_xls(file=C:\data\Projects\Marron\Archive\zip_code_database.xls,out=zip);

proc sql;
create table temp2 as
select a.*,b.state
from temp1 a left join zip b
on a.zip=b.zip;
quit;

data aha12;
set temp2;
if state not in ('AS','GU','MP','PR','VI') ;
run;

 


 
*********************************
HIT responses
*********************************;
*2008;
proc sort data=hit.hit07 out=hit08(keep= q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4 id  );
by id;
run;
data hit08;
set hit08;
array a {24} $ q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4;
array b {24} a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
do i=1 to 24;
b{i}=a{i}*1;
end;
keep id a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
run;

*2009;
proc sort data=hit.hit08 out=hit09(keep= q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_g1 q1_a2 q1_b2 q1_c2 q1_d2 q1_e2 q1_f2 q1_a3 q1_b3 q1_c3 q1_d3 q1_e3 q1_a4 q1_b4 q1_c4 q1_d4 q1_e4 q1_f4  id it_response );
by id;
run;
data hit09;
set hit09;
if it_response='Yes';
run;
data hit09;
set hit09;
rename q1_a1=q1a1;rename q1_b1=q1b1;rename q1_c1=q1c1;rename q1_d1=q1d1;rename q1_e1=q1e1;rename q1_f1=q1f1;rename q1_g1=q1g1;
rename q1_a2=q1a2;rename q1_b2=q1b2;rename q1_c2=q1c2;rename q1_d2=q1d2;rename q1_e2=q1e2;rename q1_f2=q1f2; 
rename q1_a3=q1a3;rename q1_b3=q1b3;rename q1_c3=q1c3;rename q1_d3=q1d3;rename q1_e3=q1e3; 
rename q1_a4=q1a4;rename q1_b4=q1b4;rename q1_c4=q1c4;rename q1_d4=q1d4;rename q1_e4=q1e4;rename q1_f4=q1f4; 
run;
data hit09;
set hit09;
array a  {24} q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4;
array b {24} a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
do i=1 to 24;
b{i}=a{i}*1;end;
keep a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4 id;
run;

 
*2010;
proc sort data=hit.hit09 out=hit10(keep=q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4 id  );
by id;
run;
data hit10;
set hit10;
array a {24} $ q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4;
array b {24} a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
do i=1 to 24;
b{i}=a{i}*1;
end;
keep id a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
run;


*2011;
proc sort data=hit.hit10 out=hit11(keep= q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_g1 q1_a2 q1_b2 q1_c2 q1_d2 q1_e2 q1_f2 q1_a3 q1_b3 q1_c3 q1_d3 q1_e3 q1_a4 q1_b4 q1_c4 q1_d4 q1_e4 q1_f4 id );
by id;
run;
data hit11;
set hit11;
rename q1_a1=q1a1;rename q1_b1=q1b1;rename q1_c1=q1c1;rename q1_d1=q1d1;rename q1_e1=q1e1;rename q1_f1=q1f1;rename q1_g1=q1g1;
rename q1_a2=q1a2;rename q1_b2=q1b2;rename q1_c2=q1c2;rename q1_d2=q1d2;rename q1_e2=q1e2;rename q1_f2=q1f2; 
rename q1_a3=q1a3;rename q1_b3=q1b3;rename q1_c3=q1c3;rename q1_d3=q1d3;rename q1_e3=q1e3; 
rename q1_a4=q1a4;rename q1_b4=q1b4;rename q1_c4=q1c4;rename q1_d4=q1d4;rename q1_e4=q1e4;rename q1_f4=q1f4; 
run;
data hit11;
set hit11;
array a  {24} q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4;
array b {24} a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
do i=1 to 24;
b{i}=a{i}*1;
end;

keep a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4 id;
run;


* 2012;
libname HIT1112 "C:\data\Data\Hospital\AHA\HIT\Data\fromshare_Projects-HIT2012-data-stata";
proc sort data=hit1112.Finalitfeb7 out=hit12(keep=q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4 id );
by id;
run;
data hit12;
set hit12;
array a  {24} q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4;
array b {24} a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
do i=1 to 24;
b{i}=a{i}*1;
end;
keep a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4 id;
run;


* 2013;
proc sort data=hit.hit13 out=hit13(keep=q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4 id);
by id;
run;
data hit13;
set hit13;
array a  {24} $ q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4;
array b {24} a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
do i=1 to 24;
b{i}=a{i}*1;end;
keep id a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
run;
  

* Raw response-weighted Rates for 6 years;

%macro long(year=);
data temp1;
set hit&year.;
array a {24} a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
array b {24} a1f b1f c1f d1f e1f f1f g1f a2f b2f c2f d2f e2f f2f a3f b3f c3f d3f e3f a4f b4f c4f d4f e4f f4f;
do i=1 to 24;
if a{i} in (1,2) then b{i}=1;else b{i}=0;
end;

run; 

proc sql;
create table temp2 as
select *
from aha12 A left join temp1 B
on A.id=B.id;
quit;

data temp3;
set temp2;
if a1 ne . then respond=1;else respond=0;
run;
  
proc logistic data=temp3;
title 'Response Rate Model';
	class respond(ref="0") hospsize(ref="1")  type(ref="1") hosp_reg4(ref="1") profit2(ref="1") teaching(ref="3") system(ref="1") ruca_level(ref="1")  /param=ref;
	model respond  = hospsize type hosp_reg4 profit2 teaching system ruca_level p_medicare p_medicaid nurse_ratio ; 
	output  out=temp4 p=prob;  
run;

data final&year.;
set temp4;
if respond=1;
wt=1/prob;
year=20&year.;
* Mu and MU percentage;
array a {6} d1f c3f a4f b4f e4f f4f;array b {7} b1f g1f e2f a3f b3f d3f e3f;
MU=(d1f + c3f + a4f + b4f + e4f + f4f)/6;nonMU=(b1f + g1f + e2f + a3f + b3f + d3f + e3f)/7;
run;
 

* Overall trend ;
proc means data=final&year. ;
class eligibility ;
weight wt;
var &var.;
output out=step1_&year._unadj(keep=eligibility rate) mean=rate;
run;

%mend long;
%long(year=08);
%long(year=09);
%long(year=10);
%long(year=11);
%long(year=12);
%long(year=13);
  

* Display Raw Rates;
data raw;
set step1_08_unadj(in=in08) step1_09_unadj(in=in09) step1_10_unadj(in=in10) step1_11_unadj(in=in11) step1_12_unadj(in=in12) step1_13_unadj(in=in13);
where eligibility ne . ;
if in08 then  year=2008;  
if in09 then year=2009;  
if in10 then  year=2010;  
if in11 then year=2011;  
if in12 then  year=2012;  
if in13 then  year=2013;  
keep eligibility rate year;
format rate percent9.2 ;
run;

*******************************************Models;


***************************
Diff-in-Diff in Slope/trend
***************************;


data allyear ;
set final08 final09 final10 final11 final12 final13;
if year=2008 then do;year1=0; time=1;post=0; end;
else if year=2009 then do;year1=1; time=2;post=0; end;
else if year=2010 then do;year1=2; time=3;post=0; end;
else if year=2011 then do;year1=3; time=4;post=1; end;
else if year=2012 then do;year1=4;time=5;post=1; end;
else if year=2013 then do;year1=5;time=6;post=1; end;
year2=post*(year1-2);
 
keep id eligibility year1 year2 time  &var. wt post  ;
run;
proc sort data=allyear ;by id year1;run;

* Linear model;
proc genmod data=allyear  descending  ;
weight wt;
class id  eligibility(ref="1") time(ref="1") post(ref="0")/param=ref;
model &var.=eligibility year1 eligibility*year1 post post*eligibility post*year2 post*year2*eligibility/dist=normal link=identity corrb ;
repeated subject=id/withinsubject=time type=un;
output out=predict p=pro l=lower u=upper;

estimate "Pre Eligible 'year1' " year1 1 ;
estimate "Post Eligible 'year1+Post*Year2' " year1 1 post*year2 1 ;
estimate "Pre In-Eligible 'year1+year1*eligibility' " year1 1 eligibility*year1 1 ;
estimate "Post In-Eligible 'year1+year1*eligibility+Post*Year2+post*year2*eligibility' " year1 1 eligibility*year1 1  post*year2 1 0 post*year2*eligibility 1 ;
 
estimate "Eligible Diff post*year2" post*year2 1 ;
estimate "In-Eligible Diff post*year2+post*year2*eligibility" post*year2 1  post*year2*eligibility 1 ;
estimate "Pre Diff year1*eligibility" year1*eligibility 1 ;
estimate "Post Diff year1*eligibility+post*year2*eligibility" eligibility*year1 1   post*year2*eligibility 1 ;
estimate "Diff-in-Diff post*year2*eligibility " post*year2*eligibility 1 ;

run;


proc sort data=predict(keep=pro year1 eligibility ) nodupkey;by year1 eligibility ;run;

data pre0 pre1 post0 post1 ;
set predict;
year=2008+year1;
if year <2011 and eligibility=0  then do;pre0=pro;output pre0;end;
else if year <2011 and eligibility=1  then do;pre1=pro;output pre1;end;
else if year >=2011 and eligibility=0  then do;post0=pro;output post0;end;
else if year >=2011 and eligibility=1  then do;post1=pro;output post1;end;
run;

proc sort data=raw;by year;run;

data graph;
merge raw pre0(keep=year eligibility pre0) pre1(keep=year eligibility pre1) post0(keep=year eligibility post0) post1(keep=year eligibility post1);
by year eligibility  ;
format rate percent9.2 ;
format pre0 percent9.2 ;
format pre1 percent9.2 ;
format post0 percent9.2 ;
format post1 percent9.2 ;
run;


proc sgplot data=graph;
title1 "Model Estimation: Diff-in-Diff   ";
scatter X=year y=rate/markerattrs=(color=black symbol=STARFILLED) LEGENDLABEL ="Average Percentage of &var. Functions" datalabel=rate;
series X=year  y=pre0 /lineattrs=(color=purple) LEGENDLABEL ='Pre-period In-eligible  '  ;
series X=year  y=pre1 /lineattrs=(color=purple)LEGENDLABEL ='Pre-period Eligible  '  ;
series X=year  y=post0  /lineattrs=(color=purple) LEGENDLABEL ='Post-period  In-Eligible '  ;
series X=year  y=post1  /lineattrs=(color=purple)LEGENDLABEL ='Post-period  Eligible '  ;

xaxis label='Year' values=(2008 to 2013 by 1);
yaxis label="&var. ";
run;

%mend MU;

%MU(var=MU);
%MU(var=nonMU);


proc means data=final08 mean;class eligibility;weight wt;var a1f b1f c1f d1f e1f f1f g1f a2f b2f c2f d2f e2f f2f a3f b3f c3f d3f e3f a4f b4f c4f d4f e4f f4f;run;
 


 
/*
(2) can you run the "standard" model looking at adoption of the following functionalities (i.e., binary dependent variable -- one model for each outcome below):
c3f- medication CPOE                     
f1f- discharge summaries
d1f- patient problem list
e1f- patient medication list
d4f- drug-drug interaction checking
c4f- drug-allergy interaction checking
f4f- drug dosing support
e4f- drug lab interaction checking
a4f- clinical guidelines
b4f- clinical reminders

*/

libname HIT "C:\data\Data\Hospital\AHA\HIT\data";
libname impact "C:\data\Data\Hospital\Impact";
LIBNAME AHA 	"C:\data\Data\Hospital\AHA\Annual_Survey\data";
libname rural 'C:\data\Data\RUCA';

%macro MU(var=);

data temp;
set aha.aha12;

if profit2 ^=4;
* Egilible Acute Care Hospitals (general medical and surgical ;
if serv=10 then type=1; 
* Inegilible Rehabilitation ;
if serv=46  then type=2;
* Inegilible Psychiatric ; 
if serv=22  then type=3; 
* Inegilible Long-Term Acute Care ;
if serv=80 then type=4;

if sysid ^='' then system=1; else system=0;
 
if type in (1,2,3,4);
if type=1 then eligibility=1;else eligibility=0;
keep provider id zip type eligibility hospsize hosp_reg4 profit2 teaching system p_medicare p_medicaid nurse_ratio ;
run;
 
* Add RUCA level from external file;
proc sql;
create table temp1 as
select a.*,b.ruca_level
from temp A left join rural.SAS_2006_RUCA B
on A.zip=B.ZIPA;
quit;

%macro imp_xls(file=,out=);
proc import datafile="&file." dbms=xls out=&out. replace;
getnames=yes;
run;
%mend imp_xls;

%imp_xls(file=C:\data\Projects\Marron\Archive\zip_code_database.xls,out=zip);

proc sql;
create table temp2 as
select a.*,b.state
from temp1 a left join zip b
on a.zip=b.zip;
quit;

data aha12;
set temp2;
if state not in ('AS','GU','MP','PR','VI') ;
run;

 


 
*********************************
HIT responses
*********************************;
*2008;
proc sort data=hit.hit07 out=hit08(keep= q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4 id  );
by id;
run;
data hit08;
set hit08;
array a {24} $ q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4;
array b {24} a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
do i=1 to 24;
b{i}=a{i}*1;
end;
keep id a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
run;

*2009;
proc sort data=hit.hit08 out=hit09(keep= q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_g1 q1_a2 q1_b2 q1_c2 q1_d2 q1_e2 q1_f2 q1_a3 q1_b3 q1_c3 q1_d3 q1_e3 q1_a4 q1_b4 q1_c4 q1_d4 q1_e4 q1_f4  id it_response );
by id;
run;
data hit09;
set hit09;
if it_response='Yes';
run;
data hit09;
set hit09;
rename q1_a1=q1a1;rename q1_b1=q1b1;rename q1_c1=q1c1;rename q1_d1=q1d1;rename q1_e1=q1e1;rename q1_f1=q1f1;rename q1_g1=q1g1;
rename q1_a2=q1a2;rename q1_b2=q1b2;rename q1_c2=q1c2;rename q1_d2=q1d2;rename q1_e2=q1e2;rename q1_f2=q1f2; 
rename q1_a3=q1a3;rename q1_b3=q1b3;rename q1_c3=q1c3;rename q1_d3=q1d3;rename q1_e3=q1e3; 
rename q1_a4=q1a4;rename q1_b4=q1b4;rename q1_c4=q1c4;rename q1_d4=q1d4;rename q1_e4=q1e4;rename q1_f4=q1f4; 
run;
data hit09;
set hit09;
array a  {24} q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4;
array b {24} a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
do i=1 to 24;
b{i}=a{i}*1;end;
keep a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4 id;
run;

 
*2010;
proc sort data=hit.hit09 out=hit10(keep=q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4 id  );
by id;
run;
data hit10;
set hit10;
array a {24} $ q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4;
array b {24} a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
do i=1 to 24;
b{i}=a{i}*1;
end;
keep id a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
run;


*2011;
proc sort data=hit.hit10 out=hit11(keep= q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_g1 q1_a2 q1_b2 q1_c2 q1_d2 q1_e2 q1_f2 q1_a3 q1_b3 q1_c3 q1_d3 q1_e3 q1_a4 q1_b4 q1_c4 q1_d4 q1_e4 q1_f4 id );
by id;
run;
data hit11;
set hit11;
rename q1_a1=q1a1;rename q1_b1=q1b1;rename q1_c1=q1c1;rename q1_d1=q1d1;rename q1_e1=q1e1;rename q1_f1=q1f1;rename q1_g1=q1g1;
rename q1_a2=q1a2;rename q1_b2=q1b2;rename q1_c2=q1c2;rename q1_d2=q1d2;rename q1_e2=q1e2;rename q1_f2=q1f2; 
rename q1_a3=q1a3;rename q1_b3=q1b3;rename q1_c3=q1c3;rename q1_d3=q1d3;rename q1_e3=q1e3; 
rename q1_a4=q1a4;rename q1_b4=q1b4;rename q1_c4=q1c4;rename q1_d4=q1d4;rename q1_e4=q1e4;rename q1_f4=q1f4; 
run;
data hit11;
set hit11;
array a  {24} q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4;
array b {24} a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
do i=1 to 24;
b{i}=a{i}*1;
end;

keep a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4 id;
run;


* 2012;
libname HIT1112 "C:\data\Data\Hospital\AHA\HIT\Data\fromshare_Projects-HIT2012-data-stata";
proc sort data=hit1112.Finalitfeb7 out=hit12(keep=q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4 id );
by id;
run;
data hit12;
set hit12;
array a  {24} q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4;
array b {24} a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
do i=1 to 24;
b{i}=a{i}*1;
end;
keep a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4 id;
run;


* 2013;
proc sort data=hit.hit13 out=hit13(keep=q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4 id);
by id;
run;
data hit13;
set hit13;
array a  {24} $ q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4;
array b {24} a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
do i=1 to 24;
b{i}=a{i}*1;end;
keep id a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
run;
  

* Raw response-weighted Rates for 6 years;

%macro long(year=);
data temp1;
set hit&year.;
array a {24} a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
array b {24} a1f b1f c1f d1f e1f f1f g1f a2f b2f c2f d2f e2f f2f a3f b3f c3f d3f e3f a4f b4f c4f d4f e4f f4f;
do i=1 to 24;
if a{i} in (1,2) then b{i}=1;else b{i}=0;
end;

run; 

proc sql;
create table temp2 as
select *
from aha12 A left join temp1 B
on A.id=B.id;
quit;

data temp3;
set temp2;
if a1 ne . then respond=1;else respond=0;
run;
  
proc logistic data=temp3;
title 'Response Rate Model';
	class respond(ref="0") hospsize(ref="1")  type(ref="1") hosp_reg4(ref="1") profit2(ref="1") teaching(ref="3") system(ref="1") ruca_level(ref="1")  /param=ref;
	model respond  = hospsize type hosp_reg4 profit2 teaching system ruca_level p_medicare p_medicaid nurse_ratio ; 
	output  out=temp4 p=prob;  
run;

data final&year.;
set temp4;
if respond=1;
wt=1/prob;
year=20&year.;
run;
 

* Overall trend ;
proc means data=final&year. ;
class eligibility ;
weight wt;
var &var.;
output out=step1_&year._unadj(keep=eligibility rate) mean=rate;
run;

%mend long;
%long(year=08);
%long(year=09);
%long(year=10);
%long(year=11);
%long(year=12);
%long(year=13);
  

* Display Raw Rates;
data raw;
set step1_08_unadj(in=in08) step1_09_unadj(in=in09) step1_10_unadj(in=in10) step1_11_unadj(in=in11) step1_12_unadj(in=in12) step1_13_unadj(in=in13);
where eligibility ne . ;
if in08 then  year=2008;  
if in09 then year=2009;  
if in10 then  year=2010;  
if in11 then year=2011;  
if in12 then  year=2012;  
if in13 then  year=2013;  
keep eligibility rate year;
format rate percent9.2 ;
run;

*******************************************Models;


***************************
Diff-in-Diff in Slope/trend
***************************;


data allyear ;
set final08 final09 final10 final11 final12 final13;
if year=2008 then do;year1=0; time=1;post=0; end;
else if year=2009 then do;year1=1; time=2;post=0; end;
else if year=2010 then do;year1=2; time=3;post=0; end;
else if year=2011 then do;year1=3; time=4;post=1; end;
else if year=2012 then do;year1=4;time=5;post=1; end;
else if year=2013 then do;year1=5;time=6;post=1; end;
year2=post*(year1-2);
 
keep id eligibility year1 year2 time  &var. wt post  ;
run;
proc sort data=allyear ;by id year1;run;

* Linear model;
proc genmod data=allyear  descending  ;
weight wt;
class id  eligibility(ref="1") time(ref="1") post(ref="0")/param=ref;
model &var.=eligibility year1 eligibility*year1 post post*eligibility post*year2 post*year2*eligibility/dist=normal link=identity corrb ;
repeated subject=id/withinsubject=time type=un;
output out=predict p=pro l=lower u=upper;

estimate "Pre Eligible 'year1' " year1 1 ;
estimate "Post Eligible 'year1+Post*Year2' " year1 1 post*year2 1 ;
estimate "Pre In-Eligible 'year1+year1*eligibility' " year1 1 eligibility*year1 1 ;
estimate "Post In-Eligible 'year1+year1*eligibility+Post*Year2+post*year2*eligibility' " year1 1 eligibility*year1 1  post*year2 1 0 post*year2*eligibility 1 ;
 
estimate "Eligible Diff post*year2" post*year2 1 ;
estimate "In-Eligible Diff post*year2+post*year2*eligibility" post*year2 1  post*year2*eligibility 1 ;
estimate "Pre Diff year1*eligibility" year1*eligibility 1 ;
estimate "Post Diff year1*eligibility+post*year2*eligibility" eligibility*year1 1   post*year2*eligibility 1 ;
estimate "Diff-in-Diff post*year2*eligibility " post*year2*eligibility 1 ;

run;


proc sort data=predict(keep=pro year1 eligibility ) nodupkey;by year1 eligibility ;run;

data pre0 pre1 post0 post1 ;
set predict;
year=2008+year1;
if year <2011 and eligibility=0  then do;pre0=pro;output pre0;end;
else if year <2011 and eligibility=1  then do;pre1=pro;output pre1;end;
else if year >=2011 and eligibility=0  then do;post0=pro;output post0;end;
else if year >=2011 and eligibility=1  then do;post1=pro;output post1;end;
run;

proc sort data=raw;by year;run;

data graph;
merge raw pre0(keep=year eligibility pre0) pre1(keep=year eligibility pre1) post0(keep=year eligibility post0) post1(keep=year eligibility post1);
by year eligibility  ;
format rate percent9.2 ;
format pre0 percent9.2 ;
format pre1 percent9.2 ;
format post0 percent9.2 ;
format post1 percent9.2 ;
run;


proc sgplot data=graph;
title1 "Model Estimation: Diff-in-Diff   ";
scatter X=year y=rate/markerattrs=(color=black symbol=STARFILLED) LEGENDLABEL ="Adoption Rate of &var. Function" datalabel=rate;
series X=year  y=pre0 /lineattrs=(color=purple) LEGENDLABEL ='Pre-period In-eligible  '  ;
series X=year  y=pre1 /lineattrs=(color=purple)LEGENDLABEL ='Pre-period Eligible  '  ;
series X=year  y=post0  /lineattrs=(color=purple) LEGENDLABEL ='Post-period  In-Eligible '  ;
series X=year  y=post1  /lineattrs=(color=purple)LEGENDLABEL ='Post-period  Eligible '  ;

xaxis label='Year' values=(2008 to 2013 by 1);
yaxis label="&var. ";
run;

%mend MU;
%MU(var=c3f);
%MU(var=f1f);
%MU(var=d1f);
%MU(var=e1f);
%MU(var=d4f);
%MU(var=c4f);
%MU(var=f4f);
%MU(var=e4f);
%MU(var=a4f);
%MU(var=b4f);
 










/*
One more question/request:) how many eligible hospitals are in Puerto Rico, Guam, and other territories? Do we count them as eligible? 
They apparently didn't get incentives and so we should pull them out if they are in. And I would love an analysis that compares short term acute care 
in US vs territories if there are enough of them. Thx!!

Currently, there remain a total of fifteen territories of the United States, five of which are inhabited: Puerto Rico, Guam, Northern Marianas, 
U. S. Virgin Islands and American Samoa. The remaining ten territories are the following small islands, atolls and reefs, spread across the Caribbean 
or the Pacific Ocean, with no native or permanent populations: Palmyra Atoll, Baker Island, Howland Island, Jarvis Island, Johnston Atoll, Kingman Reef, 
Wake Island, Midway Islands, Navassa Island and Serranilla Bank.

*/

libname HIT "C:\data\Data\Hospital\AHA\HIT\data";
libname impact "C:\data\Data\Hospital\Impact";
LIBNAME AHA 	"C:\data\Data\Hospital\AHA\Annual_Survey\data";
libname rural 'C:\data\Data\RUCA';


data temp;
set aha.aha12;

if profit2 ^=4;
* Egilible Acute Care Hospitals (general medical and surgical ;
if serv=10 then type=1; 
* Inegilible Rehabilitation ;
if serv=46  then type=2;
* Inegilible Psychiatric ; 
if serv=22  then type=3; 
* Inegilible Long-Term Acute Care ;
if serv=80 then type=4;

if sysid ^='' then system=1; else system=0;
 
if type in (1,2,3,4);
if type=1 then eligibility=1;else eligibility=0;
keep provider id zip type eligibility hospsize hosp_reg4 profit2 teaching system p_medicare p_medicaid nurse_ratio ;
run;
 
* Add RUCA level from external file;
proc sql;
create table temp1 as
select a.*,b.ruca_level
from temp A left join rural.SAS_2006_RUCA B
on A.zip=B.ZIPA;
quit;

%macro imp_xls(file=,out=);
proc import datafile="&file." dbms=xls out=&out. replace;
getnames=yes;
run;
%mend imp_xls;

%imp_xls(file=C:\data\Projects\Marron\Archive\zip_code_database.xls,out=zip);

proc sql;
create table temp2 as
select a.*,b.state
from temp1 a left join zip b
on a.zip=b.zip;
quit;

data aha12;
set temp2;
if state in ('AS','GU','MP','PR','VI') then terri=1;else terri=0 ;
run;


 


 
*********************************
HIT responses
*********************************;
*2008;
proc sort data=hit.hit07 out=hit08(keep= q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4 id  );
by id;
run;
data hit08;
set hit08;
array a {24} $ q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4;
array b {24} a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
do i=1 to 24;
b{i}=a{i}*1;
end;
keep id a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
run;

*2009;
proc sort data=hit.hit08 out=hit09(keep= q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_g1 q1_a2 q1_b2 q1_c2 q1_d2 q1_e2 q1_f2 q1_a3 q1_b3 q1_c3 q1_d3 q1_e3 q1_a4 q1_b4 q1_c4 q1_d4 q1_e4 q1_f4  id it_response );
by id;
run;
data hit09;
set hit09;
if it_response='Yes';
run;
data hit09;
set hit09;
rename q1_a1=q1a1;rename q1_b1=q1b1;rename q1_c1=q1c1;rename q1_d1=q1d1;rename q1_e1=q1e1;rename q1_f1=q1f1;rename q1_g1=q1g1;
rename q1_a2=q1a2;rename q1_b2=q1b2;rename q1_c2=q1c2;rename q1_d2=q1d2;rename q1_e2=q1e2;rename q1_f2=q1f2; 
rename q1_a3=q1a3;rename q1_b3=q1b3;rename q1_c3=q1c3;rename q1_d3=q1d3;rename q1_e3=q1e3; 
rename q1_a4=q1a4;rename q1_b4=q1b4;rename q1_c4=q1c4;rename q1_d4=q1d4;rename q1_e4=q1e4;rename q1_f4=q1f4; 
run;
data hit09;
set hit09;
array a  {24} q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4;
array b {24} a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
do i=1 to 24;
b{i}=a{i}*1;end;
keep a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4 id;
run;

 
*2010;
proc sort data=hit.hit09 out=hit10(keep=q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4 id  );
by id;
run;
data hit10;
set hit10;
array a {24} $ q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4;
array b {24} a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
do i=1 to 24;
b{i}=a{i}*1;
end;
keep id a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
run;


*2011;
proc sort data=hit.hit10 out=hit11(keep= q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_g1 q1_a2 q1_b2 q1_c2 q1_d2 q1_e2 q1_f2 q1_a3 q1_b3 q1_c3 q1_d3 q1_e3 q1_a4 q1_b4 q1_c4 q1_d4 q1_e4 q1_f4 id );
by id;
run;
data hit11;
set hit11;
rename q1_a1=q1a1;rename q1_b1=q1b1;rename q1_c1=q1c1;rename q1_d1=q1d1;rename q1_e1=q1e1;rename q1_f1=q1f1;rename q1_g1=q1g1;
rename q1_a2=q1a2;rename q1_b2=q1b2;rename q1_c2=q1c2;rename q1_d2=q1d2;rename q1_e2=q1e2;rename q1_f2=q1f2; 
rename q1_a3=q1a3;rename q1_b3=q1b3;rename q1_c3=q1c3;rename q1_d3=q1d3;rename q1_e3=q1e3; 
rename q1_a4=q1a4;rename q1_b4=q1b4;rename q1_c4=q1c4;rename q1_d4=q1d4;rename q1_e4=q1e4;rename q1_f4=q1f4; 
run;
data hit11;
set hit11;
array a  {24} q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4;
array b {24} a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
do i=1 to 24;
b{i}=a{i}*1;
end;

keep a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4 id;
run;


* 2012;
libname HIT1112 "C:\data\Data\Hospital\AHA\HIT\Data\fromshare_Projects-HIT2012-data-stata";
proc sort data=hit1112.Finalitfeb7 out=hit12(keep=q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4 id );
by id;
run;
data hit12;
set hit12;
array a  {24} q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4;
array b {24} a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
do i=1 to 24;
b{i}=a{i}*1;
end;
keep a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4 id;
run;


* 2013;
proc sort data=hit.hit13 out=hit13(keep=q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4 id);
by id;
run;
data hit13;
set hit13;
array a  {24} $ q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4;
array b {24} a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
do i=1 to 24;
b{i}=a{i}*1;end;
keep id a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
run;
  

* Raw response-weighted Rates for 6 years;

%macro long(year=);
data temp1;
set hit&year.;
array a {24} a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4;
array b {24} a1f b1f c1f d1f e1f f1f g1f a2f b2f c2f d2f e2f f2f a3f b3f c3f d3f e3f a4f b4f c4f d4f e4f f4f;
do i=1 to 24;
if a{i} in (1,2) then b{i}=1;else b{i}=0;
end;

run; 

proc sql;
create table temp2 as
select *
from aha12 A left join temp1 B
on A.id=B.id;
quit;

data temp3;
set temp2;
if a1 ne . then respond=1;else respond=0;
run;
  
proc logistic data=temp3;
title 'Response Rate Model';
	class respond(ref="0") hospsize(ref="1")  type(ref="1") hosp_reg4(ref="1") profit2(ref="1") teaching(ref="3") system(ref="1") ruca_level(ref="1")  /param=ref;
	model respond  = hospsize type hosp_reg4 profit2 teaching system ruca_level p_medicare p_medicaid nurse_ratio ; 
	output  out=temp4 p=prob;  
run;

data final&year.;
set temp4;
if respond=1;
wt=1/prob;
year=20&year.;
* Mu and MU percentage;
array a {6} d1f c3f a4f b4f e4f f4f;array b {7} b1f g1f e2f a3f b3f d3f e3f;
MU=(d1f + c3f + a4f + b4f + e4f + f4f)/6;nonMU=(b1f + g1f + e2f + a3f + b3f + d3f + e3f)/7;
run;
 

* Overall trend ;
proc means data=final&year. ;
class eligibility ;
weight wt;
var &var.;
output out=step1_&year._unadj(keep=eligibility rate) mean=rate;
run;

%mend long;
%long(year=08);
%long(year=09);
%long(year=10);
%long(year=11);
%long(year=12);
%long(year=13);
  

 
