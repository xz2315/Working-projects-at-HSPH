******************************************************************************
Filename:		Step1.sas
Purpose:        at least Basic EHR adoption rate Step1
Date:           06/30/2014
******************************************************************************;



/****************************************************************************
(1) Overall trend
- group together ineligible hospitals (LTAC, psych, rehab) and compare at least basic EHR adoption rate 2008-2015
- use cross-sectional data from each year (i.e., we don't need a panel); adjust for non-response by producing weighted adoption rates
- i believe that this is just an aggregation of what you have already done, but to the extent that it is not, please also re-run by type of hospital (eligible, LTAC, psych, rehab), by size, and by type-size.
- we were a bit surprised that the number of rehab hospitals is so low, and so if you can confirm that we are not losing anyone, that would be great
- ashish thought that you had already run by system-affiliation (yes/no); if so, can you send that to us to take a look at?
********************************************************************************/

libname HIT "C:\data\Data\Hospital\AHA\HIT\data";
libname impact "C:\data\Data\Hospital\Impact";
LIBNAME AHA 	"C:\data\Data\Hospital\AHA\Annual_Survey\data";
libname rural 'C:\data\Data\RUCA';

 

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
keep id zip type hospsize hosp_reg4 profit2 teaching system p_medicaid ruca_level ;
proc freq data=temp1;tables type hospsize hosp_reg4 profit2 teaching system ruca_level/ missing;
run;
 
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

* 2014;
PROC IMPORT OUT=hit14 DATAFILE= "C:\data\Data\Hospital\AHA\HIT\Data\HIT14.xlsx" 
            DBMS=xlsx REPLACE;
     GETNAMES=YES;
RUN;
data hit14;
set hit14;
rename q1_a1=q1a1;rename q1_b1=q1b1;
rename q1_c1=q1c1;rename q1_d1=q1d1;
rename q1_e1=q1e1;rename q1_f1=q1f1;
rename q1_a2=q1a2;rename q1_b2=q1b2;
rename q1_d2=q1d2;rename q1_c3=q1c3;
keep id q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_a2 q1_b2 q1_d2 q1_c3;
run;
* 2015;
PROC IMPORT OUT=hit15 DATAFILE= "C:\data\Data\Hospital\AHA\HIT\Data\HIT15.xlsx" 
            DBMS=xlsx REPLACE;
     GETNAMES=YES;
RUN;
data hit15;
set hit15;
rename q1_a1=q1a1;rename q1_b1=q1b1;
rename q1_c1=q1c1;rename q1_d1=q1d1;
rename q1_e1=q1e1;rename q1_f1=q1f1;
rename q1_a2=q1a2;rename q1_b2=q1b2;
rename q1_d2=q1d2;rename q1_c3=q1c3;rename AHA_ID=ID;
keep AHA_ID q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_a2 q1_b2 q1_d2 q1_c3;
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

* Response rate ;
proc logistic data=temp4;
	class respond(ref="0") hospsize(ref="1")  type(ref="1") hosp_reg4(ref="1") profit2(ref="1") teaching(ref="3") system(ref="1") ruca_level(ref="1")  /param=ref;
	model respond= hospsize type hosp_reg4 profit2 teaching system ruca_level; 
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
output out=step1_&year._unadj(keep=eligibility rate_20&year.) mean=rate_20&year.;
run;

* By each year, cross-sectional-data, stratify by size, report the adjusted rates for : 
*		Stratum=Large: rates for Eligible hospital and Ineligible hospital
*		Stratum=Medium: rates for Eligible hospital and Ineligible hospital;
proc genmod data=final&year. descending   ;
	weight wt;
	class hospsize eligibility /param=effect;
	model basic_adopt=hospsize eligibility eligibility*hospsize/dist=binomial link=logit;
 	output out=temp6 p=rate_20&year.;
run;

proc sort data=temp6(keep= hospsize eligibility rate_20&year.) out=step1_&year._size nodupkey;by hospsize eligibility;run;


* By each year, cross-sectional-data, stratify by system-affiliation, report the adjusted rates for : 
*		Stratum=Affiliation: rates for Eligible hospital and Ineligible hospital
*		Stratum=No-Affiliation: rates for Eligible hospital and Ineligible hospital;
proc genmod data=final&year. descending   ;
	weight wt;
	class system eligibility /param=effect;
	model basic_adopt=system eligibility eligibility*system/dist=binomial link=logit;
 	output out=temp7 p=rate_20&year.;
run;

proc sort data=temp7(keep= system eligibility rate_20&year.) out=step1_&year._system nodupkey;by system eligibility;run;

%mend long;
%long(year=08);
%long(year=09);
%long(year=10);
%long(year=11);
%long(year=12);
%long(year=13);
%long(year=14);
%long(year=15);

* Overall trend for ineligible and eligible hospitals;
/*
data step1_allyear_ineligible_graph;
merge step1_08_unadj step1_09_unadj step1_10_unadj step1_11_unadj step1_12_unadj step1_13_unadj step1_14_unadj step1_15_unadj;
where eligibility in (0,1);
rate=rate_2008;year=2008;output;
rate=rate_2009;year=2009;output;
rate=rate_2010;year=2010;output;
rate=rate_2011;year=2011;output;
rate=rate_2012;year=2012;output;
rate=rate_2013;year=2013;output;
rate=rate_2014;year=2014;output;
rate=rate_2015;year=2015;output;
keep eligibility rate year;
proc print;
run;

proc sgplot data=step1_allyear_ineligible_graph;
title "Overall Trend of Basic EHR Adoption Rates, Ineligible vs Eligible";
series X=year y=rate/group=eligibility datalabel=rate;
run;
*/
data step1_allyear_ineligible_output;
merge step1_08_unadj step1_09_unadj step1_10_unadj step1_11_unadj step1_12_unadj step1_13_unadj step1_14_unadj step1_15_unadj;
where eligibility in (0,1);
proc print;
run;


* By size;
data step1_allyear_size_output;
merge step1_08_size step1_09_size step1_10_size step1_11_size step1_12_size step1_13_size step1_14_size step1_15_size;
by hospsize eligibility;
proc print;
run;
/*
data step1_08;set step1_08;year=2008;run;
data step1_09;set step1_09;year=2009;run;
data step1_10;set step1_10;year=2010;run;
data step1_11;set step1_11;year=2011;run;
data step1_12;set step1_12;year=2012;run;
data step1_13;set step1_13;year=2013;run;
data step1_allyear_graph;
set step1_08(rename=(rate_2008=rate) ) step1_09(rename=(rate_2009=rate)) step1_10(rename=(rate_2010=rate)) step1_11(rename=(rate_2011=rate)) step1_12(rename=(rate_2012=rate)) step1_13(rename=(rate_2013=rate));
run;

proc sgpanel data=step1_allyear_graph  ;
title1 "EHR Adoption Rates Trend Stratified by Hospital Size";
title2 "Stratum 1=Small(beds<100) Stratum 2=Medium(beds>=100-399) Stratum 3=Large(beds>=400)";
panelby hospsize /layout=COLUMNLATTICE novarname spacing=5  ;
series X=year y=rate/ group=eligibility datalabel=rate  ;
colaxis label="Year"  ;
rowaxis label="Rate" grid;
run;
*/


* By system-affiliation;

data step1_allyear_output_system;
merge step1_08_system step1_09_system step1_10_system step1_11_system step1_12_system step1_13_system step1_14_system step1_15_system;
by system eligibility;
proc print;
run;
/*
data step1_08_system;set step1_08_system;year=2008;run;
data step1_09_system;set step1_09_system;year=2009;run;
data step1_10_system;set step1_10_system;year=2010;run;
data step1_11_system;set step1_11_system;year=2011;run;
data step1_12_system;set step1_12_system;year=2012;run;
data step1_13_system;set step1_13_system;year=2013;run;
data step1_allyear_graph_system;
set step1_08_system(rename=(rate_2008=rate) ) step1_09_system(rename=(rate_2009=rate)) step1_10_system(rename=(rate_2010=rate)) step1_11_system(rename=(rate_2011=rate)) step1_12_system(rename=(rate_2012=rate)) step1_13_system(rename=(rate_2013=rate));
run;

proc sgpanel data=step1_allyear_graph_system  ;
title1 "EHR Adoption Rates Trend Stratified by System-Affiliation";
title2 "Stratum 0=No-Affiliation Stratum 1=System-Affliation";
panelby system /layout=COLUMNLATTICE novarname spacing=5  ;
series X=year y=rate/ group=eligibility datalabel=rate  ;
colaxis label="Year"  ;
rowaxis label="Rate" grid;
run;
*/

 







