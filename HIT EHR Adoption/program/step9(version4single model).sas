******************************************************************************
Version 4 Analyses
Xiner Zhou
12/03/2014
******************************************************************************;

/*
 
(2) again in the original model, to assess whether there is a different relationship (i.e., diff-in-diff) if we split the eligibles into MU (meaningful use) 
attesters and non-attesters.  have you merged the data with CMS data on MU attestation?  
let me know and if not, I can send you a file with hospital IDs and MU attestation status. 
in reality, this is just another flavor of (1) with the characteristic being MU attestation status.  the only difference is that this var is not in the AHA data.
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

  
 

******* Raw Rates ;

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

keep id basic_adopt;
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
var basic_adopt;
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
 
keep id eligibility year1 year2 time  basic_adopt wt post  ;
run;
proc sort data=allyear ;by id year1;run;

* Linear model;
proc genmod data=allyear  descending  ;
weight wt;
class id  eligibility(ref="1") time(ref="1") post(ref="0")/param=ref;
model basic_adopt=eligibility year1 eligibility*year1 post post*eligibility post*year2 post*year2*eligibility/dist=normal link=identity corrb ;
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
scatter X=year y=rate/markerattrs=(color=black symbol=STARFILLED) LEGENDLABEL ="True Rate" datalabel=rate;
series X=year  y=pre0 /lineattrs=(color=purple) LEGENDLABEL ='Pre-period In-eligible  '  ;
series X=year  y=pre1 /lineattrs=(color=purple)LEGENDLABEL ='Pre-period Eligible  '  ;
series X=year  y=post0  /lineattrs=(color=purple) LEGENDLABEL ='Post-period  In-Eligible '  ;
series X=year  y=post1  /lineattrs=(color=purple)LEGENDLABEL ='Post-period  Eligible '  ;

xaxis label='Year' values=(2008 to 2013 by 1);
yaxis label='Adoption Rate';
run;

 


 













 



 
