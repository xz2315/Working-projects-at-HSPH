******************************************************************************
Version 4 Analyses
Xiner Zhou
12/02/2014
******************************************************************************;

/*
(1) to go back to the original model that uses all eligibles vs. all ineligibles and look for differences based on various hospital characteristics.  
Basically, we want to figure out if the relationship we observe (the diff-in-diff) differs for different types of hospitals.  
This will involve three way interaction terms and so let me know if you'd like to talk through how best to model this.  
The initial vars that I'd like you to include are: 
(1) RUCA or rural/urban; 
(2) size (S/M/L); 
(3) system-affiliated; 
(4) teaching (Y/N); 
and (5) Ownership (FP/NP/Public)  
I realize that because some of these are categorical, this may get even more complicated.  
We should perhaps put this on the agenda for the next John meeting to figure out the best approach (unless you feel like you can take a first pass).
*/


/*
(1) Run 4-way interaction results for system-affiliation and ownership.  Create forest plot. diff in diff with center line at overall diff in diff  
Were you clear on what value(s) specifically we would plot?  I was thinking it would be the diff-in-diff for each value of each characteristic 
with the 95% CI around the diff-in-diff -- so there would be three lines for size, three for ownership, and two for system affiliation.  
*/


libname HIT "C:\data\Data\Hospital\AHA\HIT\data";
libname impact "C:\data\Data\Hospital\Impact";
LIBNAME AHA 	"C:\data\Data\Hospital\AHA\Annual_Survey\data";
libname rural 'C:\data\Data\RUCA';
 
 

 
proc import datafile="C:\data\Projects\HIT EHR Adoption\MU Attestation" dbms=xls out=MU replace;
getnames=NO;
run;
 
data MU;
length att $8. ;
set mu;
temp=scan(a,1,'"');id=substr(temp,1,7);
npi=scan(a,2,'"');
att=scan(a,3,'"');
if att ='' then do;att=npi;npi='';end;
att2013=substr(att,1,2);
att2012=substr(att,3,2);
att2011=substr(att,5,2);
noatt=substr(att,7,2);

keep id npi att2013 att2012 att2011 noatt;

run;
 
* Make Hospital Characteristics Summary File;

%macro AHA(yr=);
data temp;
set aha.aha&yr.;

 
 
* Egilible Acute Care Hospitals (general medical and surgical ;
if serv=10 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=1; 
* Inegilible Rehabilitation ;
if serv=46 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=2;
* Inegilible Psychiatric ; 
if serv=22 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=3; 
* Inegilible Long-Term Acute Care ;
if serv=80 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=4;

 
if sysid ^='' then system=1; else system=0;
 
if type in (1,2,3,4);
keep provider npinum id zip type hospsize hosp_reg4 profit2 teaching system p_medicaid ;
run;




* Add RUCA level from external file;
proc sql;
create table aha&yr. as
select a.*,b.ruca_level
from temp A left join rural.SAS_2006_RUCA B
on A.zip=B.ZIPA;
quit;

* Calculate how many hospitals in each category ;
proc freq data=aha&yr.;title "Hospital Type &yr.";tables type;run;
 
%mend AHA;
%AHA(yr=12);

proc sql;
create table aha as
select a.*,b.*
from aha12 a left join mu b
on a.id=b.id;
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

 

%macro char_analyses(var=,n=);

******* Raw Rates by Types*Characterisitcs and output tables and graphs;

%macro long(year=);
data temp1;
set hit&year.;
array basic {10}  q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3;
total=0;
do i= 1 to 10;
	if basic(i) in (1,2) then total=total+1;
end;
drop i;
		 
if total=10 then basic_adopt=1;else basic_adopt=0; 


run; 

proc sql;
create table temp3 as
select *
from aha A left join temp1 B
on A.id=B.id;
quit;

data temp4;
set temp3;
if basic_adopt ne . then respond=1;else respond=0;
if type=1 then eligibility=1;else eligibility=0;
run;

proc freq data=temp4;
title "Sample Size &var. at  &year."; 
where respond=1;
tables eligibility*&var.;
run;


 

* Response rate stratified by Type/ Size / Type*Size ;
* Covariate: size;
* Stratum: Eligible hospitals vs Ineligible hospitals ;
 
proc logistic data=temp4;
title 'Response Rate Model';
	class respond(ref="0") hospsize(ref="1")  type(ref="1") hosp_reg4(ref="1") profit2(ref="1") teaching(ref="3") system(ref="1") ruca_level(ref="1")  /param=ref;
	model respond  = hospsize type hosp_reg4 profit2 teaching system ruca_level; 
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
class eligibility &var.;
weight wt;
var basic_adopt;
output out=step1_&year._unadj(keep=eligibility &var. rate) mean=rate;
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
where eligibility ne . and  &var. ne .;
if in08 then  year=2008;  
if in09 then year=2009;  
if in10 then  year=2010;  
if in11 then year=2011;  
if in12 then  year=2012;  
if in13 then  year=2013;  
keep eligibility &var. rate year;
format rate percent9.2 ;
run;



proc sort data=raw;by eligibility &var.;run;
proc transpose data=raw out=&var. ;
by eligibility &var.;
var rate;
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
 
keep id eligibility &var. year1 year2 time  basic_adopt wt post  ;
run;
proc sort data=allyear ;by id year1;run;

%if &n.=3 %then %do;
* Linear model;
proc genmod data=allyear  descending  ;
weight wt;
class id &var.(ref="1") eligibility(ref="1") time(ref="1") post(ref="0")/param=ref;
model basic_adopt= eligibility &var. &var.*eligibility  
year1 year1*eligibility year1*&var. year1*&var.*eligibility 
post post*eligibility post*&var. post*&var.*eligibility 
post*year2 post*year2*eligibility post*year2*&var. post*year2*&var.*eligibility/dist=normal link=identity corrb ;
repeated subject=id/withinsubject=time type=un;
output out=predict p=pro l=lower u=upper;

estimate "&var. =1 Pre Eligible 'year1' " year1 1 ;
estimate "&var. =1 Post Eligible 'year1+Post*Year2' " year1 1 post*year2 1 ;
estimate "&var. =1 Pre In-Eligible 'year1+year1*eligibility' " year1 1 year1*eligibility 1 ;
estimate "&var. =1 Post In-Eligible 'year1+year1*eligibility+Post*Year2+post*year2*eligibility' " year1 1 year1*eligibility 1  post*year2 1 0 post*year2*eligibility 1 ;
 
estimate "Eligible Diff post*year2" post*year2 1 ;
estimate "In-Eligible Diff post*year2+post*year2*eligibility" post*year2 1  post*year2*eligibility 1 ;
estimate "Pre Diff year1*eligibility" year1*eligibility 1 ;
estimate "Post Diff year1*eligibility+post*year2*eligibility" year1*eligibility 1   post*year2*eligibility 1 ;
estimate "Diff-in-Diff post*year2*eligibility " post*year2*eligibility 1 ;



estimate "&var. =2 Pre Eligible  year1+year1*&var.   " year1 1 year1*&var. 1 0 ;
estimate "&var. =2 Post Eligible  year1+year1*&var. +Post*Year2 + post*year2*&var.  " year1 1 year1*&var. 1 0  post*year2 1  post*year2*&var. 1 0 ;
estimate "&var. =2 Pre In-Eligible year1+year1*eligibility+year1*&var. +year1*&var.*eligibility " year1 1 year1*eligibility 1  year1*&var. 1 0  year1*&var.*eligibility 1 0 ;
estimate "&var. =2 Post In-Eligible year1+year1*eligibility+year1*&var. +year1*&var.*eligibility+Post*Year2+post*year2*eligibility+post*year2*&var. +post*year2*&var.*eligibility " 
 year1 1 year1*eligibility 1  year1*&var.  1 0  year1*&var.*eligibility 1 0  Post*Year2 1  post*year2*eligibility 1  post*year2*&var. 1 0  post*year2*&var.*eligibility 1 0 ; 

 
estimate "Eligible Diff Post*Year2 + post*year2*&var." post*year2 1  post*year2*&var. 1 0 ;
estimate "In-Eligible Diff Post*Year2+post*year2*eligibility+post*year2*&var. +post*year2*&var.*eligibility" Post*Year2 1 post*year2*eligibility 1  post*year2*&var. 1 0  post*year2*&var.*eligibility 1 0 ; 
estimate "Pre Diff year1*eligibility +year1*&var.*eligibility " year1*eligibility 1 year1*&var.*eligibility 1 0 ;
estimate "Post Diff  year1*eligibility +year1*&var.*eligibility+post*year2*eligibility+post*year2*&var.*eligibility " 
year1*eligibility 1  year1*&var.*eligibility 1 0 post*year2*eligibility 1  post*year2*&var.*eligibility 1 0 ; 
estimate "Diff-in-Diff post*year2*eligibility+post*year2*&var.*eligibility" post*year2*eligibility 1  post*year2*&var.*eligibility 1 0 ;
 

 
estimate "&var. =3 Pre Eligible  year1+year1*&var.   " year1 1 year1*&var. 0 1 ;
estimate "&var. =3 Post Eligible  year1+year1*&var. +Post*Year2 + post*year2*&var.  " year1 1 year1*&var. 0 1  post*year2 1  post*year2*&var. 0 1;
estimate "&var. =3 Pre In-Eligible year1+year1*eligibility+year1*&var. +year1*&var.*eligibility " year1 1 year1*eligibility 1  year1*&var. 0 1  year1*&var.*eligibility 0 1;
estimate "&var. =3 Post In-Eligible year1+year1*eligibility+year1*&var. +year1*&var.*eligibility+Post*Year2+post*year2*eligibility+post*year2*&var. +post*year2*&var.*eligibility " 
 year1 1 year1*eligibility 1  year1*&var.  0 1  year1*&var.*eligibility 0 1 Post*Year2 1  post*year2*eligibility 1  post*year2*&var. 0 1 post*year2*&var.*eligibility  0 1; 
 

estimate "Eligible Diff Post*Year2 + post*year2*&var." post*year2 1  post*year2*&var. 0 1;
estimate "In-Eligible Diff Post*Year2+post*year2*eligibility+post*year2*&var. +post*year2*&var.*eligibility" Post*Year2 1 post*year2*eligibility 1  post*year2*&var. 0 1 post*year2*&var.*eligibility 0 1; 
estimate "Pre Diff year1*eligibility +year1*&var.*eligibility " year1*eligibility 1  year1*&var.*eligibility 0 1;
estimate "Post Diff  year1*eligibility +year1*&var.*eligibility+post*year2*eligibility+post*year2*&var.*eligibility " 
year1*eligibility 1  year1*&var.*eligibility 0 1 post*year2*eligibility 1  post*year2*&var.*eligibility 0 1; 
estimate "Diff-in-Diff post*year2*eligibility+post*year2*&var.*eligibility" post*year2*eligibility 1 post*year2*&var.*eligibility 0 1 ;
 


run;


proc sort data=predict(keep=pro year1 eligibility &var.) nodupkey;by year1 eligibility &var.;run;

data generate101 generate102 generate103 generate111 generate112 generate113 generate201 generate202 generate203 generate211 generate212 generate213;
set predict;
year=2008+year1;
if year <2011 and eligibility=0 and &var.=1 then do;pre01=pro;output generate101;end;
else if year <2011 and eligibility=0 and &var.=2 then do;pre02=pro;output generate102;end;
else if year <2011 and eligibility=0 and &var.=3 then do;pre03=pro;output generate103;end;
else if year <2011 and eligibility=1 and &var.=1 then do;pre11=pro;output generate111;end;
else if year <2011 and eligibility=1 and &var.=2 then do;pre12=pro;output generate112;end;
else if year <2011 and eligibility=1 and &var.=3 then do;pre13=pro;output generate113;end;

else if year >=2011 and eligibility=0 and &var.=1 then do;post01=pro;output generate201;end;
else if year >=2011 and eligibility=0 and &var.=2 then do;post02=pro;output generate202;end;
else if year >=2011 and eligibility=0 and &var.=3 then do;post03=pro;output generate203;end;
else if year >=2011 and eligibility=1 and &var.=1 then do;post11=pro;output generate211;end;
else if year >=2011 and eligibility=1 and &var.=2 then do;post12=pro;output generate212;end;
else if year >=2011 and eligibility=1 and &var.=3 then do;post13=pro;output generate213;end;
run;

proc sort data=raw;by year;run;

data graph;
merge raw generate101(keep=year eligibility &var. pre01) generate102(keep=year eligibility &var. pre02) generate103(keep=year eligibility &var. pre03)
generate111(keep=year eligibility &var. pre11) generate112(keep=year eligibility &var. pre12) generate113(keep=year eligibility &var. pre13)
generate201(keep=year eligibility &var. post01) generate202(keep=year eligibility &var. post02) generate203(keep=year eligibility &var. post03) 
generate211(keep=year eligibility &var. post11) generate212(keep=year eligibility &var. post12) generate213(keep=year eligibility &var. post13);
by year eligibility &var.;
format rate percent9.2 ;
format pre01 percent9.2 ;
format pre02 percent9.2 ;
format pre03 percent9.2 ;
format pre11 percent9.2 ;
format pre12 percent9.2 ;
format pre13 percent9.2 ;
format post01 percent9.2 ;
format post02 percent9.2 ;
format post03 percent9.2 ;
format post11 percent9.2 ;
format post12 percent9.2 ;
format post13 percent9.2 ;
run;

                                                         
           

%do i=1 %to 3;
proc sgplot data=graph;
title1 "Model Estimation: Diff-in-Diff for &var. = &i. ";
where &var.= &i.;
scatter X=year y=rate/markerattrs=(color=black symbol=STARFILLED) LEGENDLABEL ="True Rate" datalabel=rate;
series X=year  y=pre0&i. /lineattrs=(color=purple) LEGENDLABEL ='Pre-period In-eligible &var. =&i. '  ;
series X=year  y=pre1&i. /lineattrs=(color=purple)LEGENDLABEL ='Pre-period Eligible &var. =&i.'  ;
series X=year  y=post0&i. /lineattrs=(color=purple) LEGENDLABEL ='Post-period In-Eligible &var. =&i.'  ;
series X=year  y=post1&i. /lineattrs=(color=purple)LEGENDLABEL ='Post-period Eligible &var. =&i.'  ;
xaxis label='Year' values=(2008 to 2013 by 1);
yaxis label='Adoption Rate';
run;
%end;

%end;

%if &n.=2 %then %do;
* Linear model;
proc genmod data=allyear  descending  ;
weight wt;
class id &var.(ref="0") eligibility(ref="1") time(ref="1") post(ref="0")/param=ref;
model basic_adopt= eligibility &var. &var.*eligibility  
year1 year1*eligibility year1*&var. year1*&var.*eligibility 
post post*eligibility post*&var. post*&var.*eligibility 
post*year2 post*year2*eligibility post*year2*&var. post*year2*&var.*eligibility/dist=normal link=identity corrb ;
repeated subject=id/withinsubject=time type=un;
output out=predict p=pro l=lower u=upper;

estimate "&var. =0 Pre Eligible 'year1' " year1 1 ;
estimate "&var. =0 Post Eligible 'year1+Post*Year2' " year1 1 post*year2 1 ;
estimate "&var. =0 Pre In-Eligible 'year1+year1*eligibility' " year1 1 year1*eligibility 1 ;
estimate "&var. =0 Post In-Eligible 'year1+year1*eligibility+Post*Year2+post*year2*eligibility' " year1 1 year1*eligibility 1  post*year2 1 0 post*year2*eligibility 1 ;
 
estimate "Eligible Diff post*year2" post*year2 1 ;
estimate "In-Eligible Diff post*year2+post*year2*eligibility" post*year2 1  post*year2*eligibility 1 ;
estimate "Pre Diff year1*eligibility" year1*eligibility 1 ;
estimate "Post Diff year1*eligibility+post*year2*eligibility" year1*eligibility 1   post*year2*eligibility 1 ;
estimate "Diff-in-Diff post*year2*eligibility " post*year2*eligibility 1 ;



estimate "&var. =1 Pre Eligible  year1+year1*&var.   " year1 1 year1*&var. 1 ;
estimate "&var. =1 Post Eligible  year1+year1*&var. +Post*Year2 + post*year2*&var.  " year1 1 year1*&var. 1   post*year2 1  post*year2*&var. 1 ;
estimate "&var. =1 Pre In-Eligible year1+year1*eligibility+year1*&var. +year1*&var.*eligibility " year1 1 year1*eligibility 1  year1*&var. 1  year1*&var.*eligibility 1 ;
estimate "&var. =1 Post In-Eligible year1+year1*eligibility+year1*&var. +year1*&var.*eligibility+Post*Year2+post*year2*eligibility+post*year2*&var. +post*year2*&var.*eligibility " 
 year1 1 year1*eligibility 1  year1*&var.  1  year1*&var.*eligibility 1  Post*Year2 1  post*year2*eligibility 1  post*year2*&var. 1  post*year2*&var.*eligibility 1 ; 

 
estimate "Eligible Diff Post*Year2 + post*year2*&var." post*year2 1  post*year2*&var. 1  ;
estimate "In-Eligible Diff Post*Year2+post*year2*eligibility+post*year2*&var. +post*year2*&var.*eligibility" Post*Year2 1 post*year2*eligibility 1  post*year2*&var. 1  post*year2*&var.*eligibility 1 ; 
estimate "Pre Diff year1*eligibility +year1*&var.*eligibility " year1*eligibility 1 year1*&var.*eligibility 1 ;
estimate "Post Diff  year1*eligibility +year1*&var.*eligibility+post*year2*eligibility+post*year2*&var.*eligibility " 
year1*eligibility 1  year1*&var.*eligibility 1  post*year2*eligibility 1  post*year2*&var.*eligibility 1 ; 
estimate "Diff-in-Diff post*year2*eligibility+post*year2*&var.*eligibility" post*year2*eligibility 1  post*year2*&var.*eligibility 1 ;
 
 
run;


proc sort data=predict(keep=pro year1 eligibility &var.) nodupkey;by year1 eligibility &var.;run;

data generate100 generate101  generate110 generate111  generate200 generate201  generate210 generate211 ;
set predict;
year=2008+year1;
if year <2011 and eligibility=0 and &var.=0 then do;pre00=pro;output generate100;end;
else if year <2011 and eligibility=0 and &var.=1 then do;pre01=pro;output generate101;end;
else if year <2011 and eligibility=1 and &var.=0 then do;pre10=pro;output generate110;end;
else if year <2011 and eligibility=1 and &var.=1 then do;pre11=pro;output generate111;end;

else if year >=2011 and eligibility=0 and &var.=0 then do;post00=pro;output generate200;end;
else if year >=2011 and eligibility=0 and &var.=1 then do;post01=pro;output generate201;end;
else if year >=2011 and eligibility=1 and &var.=0 then do;post10=pro;output generate210;end;
else if year >=2011 and eligibility=1 and &var.=1 then do;post11=pro;output generate211;end;
run;

proc sort data=raw;by year;run;

data graph;
merge raw generate100(keep=year eligibility &var. pre00) generate101(keep=year eligibility &var. pre01) 
generate110(keep=year eligibility &var. pre10) generate111(keep=year eligibility &var. pre11)
generate200(keep=year eligibility &var. post00) generate201(keep=year eligibility &var. post01) 
generate210(keep=year eligibility &var. post10) generate211(keep=year eligibility &var. post11) ;
by year eligibility &var.;
format rate percent9.2 ;
format pre00 percent9.2 ;
format pre01 percent9.2 ;
format pre10 percent9.2 ;
format pre11 percent9.2 ;
format post00 percent9.2 ;
format post01 percent9.2 ;
format post10 percent9.2 ;
format post11 percent9.2 ;
run;

       

%do i=0 %to 1;
proc sgplot data=graph;
title1 "Model Estimation: Diff-in-Diff for &var. = &i. ";
where &var.= &i.;
scatter X=year y=rate/markerattrs=(color=black symbol=STARFILLED) LEGENDLABEL ="True Rate" datalabel=rate;
series X=year  y=pre0&i. /lineattrs=(color=purple) LEGENDLABEL ='Pre-period In-eligible &var. =&i. '  ;
series X=year  y=pre1&i. /lineattrs=(color=purple)LEGENDLABEL ='Pre-period Eligible &var. =&i.'  ;
series X=year  y=post0&i. /lineattrs=(color=purple) LEGENDLABEL ='Post-period In-Eligible &var. =&i.'  ;
series X=year  y=post1&i. /lineattrs=(color=purple)LEGENDLABEL ='Post-period Eligible &var. =&i.'  ;
xaxis label='Year' values=(2008 to 2013 by 1);
yaxis label='Adoption Rate';
run;
%end;

%end;

 


%mend char_analyses;

%char_analyses(var=hospsize,n=3);
%char_analyses(var=profit2,n=3);
%char_analyses(var=system,n=2);
 



/*
(2) Compare MU and non-MU functions

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


for non-MU functions, can we look at two groupings?  
the first is all basic EHR functions (q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3) remaining after taking out the MU ones;
-->  q1b1 q1c1 q1a2 q1b2 q1d2 

the second is all other AHA IT functions under 
"Clinical Doc"                             q1a1---q1g1
"Results Viewing"                          q1a2---q1f2
"CPOE"                                     q1a3---q1e3
and "CDS"                                  q1a4---q1f4
remaining after taking out the MU ones.
-->      q1b1 q1c1                q1g1 
    q1a2 q1b2 q1c2 q1d2 q1e2 q1f2
    q1a3 q1b3      q1d3 q1e3
     

-  I would begin by calculating each of these three measures for each hospital in each year as a proportion 
-- # of functions adopted in at least 1 unit/total functions for that measure. so there are 7 AHA IT functions that relate to MU 
-- so if a hospital had 3 in 2008 their score would be 3/7 and 4 in 2009 their score would be 4/7.  
We then will have a % measure for which we can apply our standard diff in diff model to assess change in adoption of these functions over time.  
So there should be 3 new models -- MU, non-MU narrow, non-MU broad.
*/


libname HIT "C:\data\Data\Hospital\AHA\HIT\data";
libname impact "C:\data\Data\Hospital\Impact";
LIBNAME AHA 	"C:\data\Data\Hospital\AHA\Annual_Survey\data";
libname rural 'C:\data\Data\RUCA';
 
%macro MUs(var=); 
* Make Hospital Characteristics Summary File;

%macro AHA(yr=);
data temp;
set aha.aha&yr.;

 
 
* Egilible Acute Care Hospitals (general medical and surgical ;
if serv=10 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=1; 
* Inegilible Rehabilitation ;
if serv=46 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=2;
* Inegilible Psychiatric ; 
if serv=22 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=3; 
* Inegilible Long-Term Acute Care ;
if serv=80 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=4;

 
if sysid ^='' then system=1; else system=0;
 
if type in (1,2,3,4);
keep provider npinum id zip type hospsize hosp_reg4 profit2 teaching system p_medicaid ;
run;




* Add RUCA level from external file;
proc sql;
create table aha&yr. as
select a.*,b.ruca_level
from temp A left join rural.SAS_2006_RUCA B
on A.zip=B.ZIPA;
quit;

* Calculate how many hospitals in each category ;
proc freq data=aha&yr.;title "Hospital Type &yr.";tables type;run;
 
%mend AHA;
%AHA(yr=12);
 
 
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
  
 

******* Raw Rates ;

%macro long(year=);
data temp1;
set hit&year.;
MU1=a1;MU2=d1;MU3=e1;MU4=c3;Mu5=f1;
if a4 in (1,2) or b4 in (1,2) or c4 in (1,2) or d4 in (1,2) or e4 in (1,2) or f4 in (1,2) then MU6=1;else MU6=0;
if c4 in (1,2) and d4 in (1,2) then MU7=1;else MU7=0;

array temp1 {7}  MU1 MU2 MU3 MU4 MU5 MU6 MU7;
array temp2 {5} b1 c1 a2 b2 d2;
array temp3 {13} b1 c1 g1 a2 b2 c2 d2 e2 f2 a3 b3 d3 e3;
tot1=0;
do i= 1 to 7;
	if temp1(i) in (1,2) then tot1=tot1+1;
end;
MU=tot1/7;

tot2=0;
do j= 1 to 5;
	if temp2(j) in (1,2) then tot2=tot2+1;
end;
noMUnarrow=tot2/5;

tot3=0;
do k= 1 to 13;
	if temp3(k) in (1,2) then tot3=tot3+1;
end;
noMUbroad=tot3/13;


run; 

proc sql;
create table temp3 as
select *
from aha12 A left join temp1 B
on A.id=B.id;
quit;

data temp4;
set temp3;
if MU ne . then respond=1;else respond=0;
if type=1 then eligibility=1;else eligibility=0;
 
run;

proc freq data=temp4;
title "Sample Size at  &year."; 
where respond=1;
tables eligibility;
run;


 

* Response rate stratified by Type/ Size / Type*Size ;
* Covariate: size;
* Stratum: Eligible hospitals vs Ineligible hospitals ;
 
proc logistic data=temp4;
title 'Response Rate Model';
	class respond(ref="0") hospsize(ref="1")  type(ref="1") hosp_reg4(ref="1") profit2(ref="1") teaching(ref="3") system(ref="1") ruca_level(ref="1")  /param=ref;
	model respond  = hospsize type hosp_reg4 profit2 teaching system ruca_level; 
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

%mend MUs;

%MUs(var=MU);
%MUs(var=noMUnarrow);
%MUs(var=noMUbroad);


 


 





 
