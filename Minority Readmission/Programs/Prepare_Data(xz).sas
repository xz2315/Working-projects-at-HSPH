*****************************************
Prepare Analytic Data for : Final Papers
Xiner Zhou
2/23/2015
*****************************************;

libname data 'C:\data\Projects\Minority_Readmissions\Data';
libname aha 'C:\data\Data\Hospital\AHA\Annual_Survey\Data';
libname readm 'C:\data\Data\Hospital\Medicare_Inpt\Readmission\data';



**************************************Step 1:Import final survey and denominator, third round sampling added hospitals ;
%macro imp_xls(file=,out=);
proc import datafile="&file." dbms=xls out=&out. replace;
getnames=yes;
run;
%mend imp_xls;

%imp_xls(file=C:\data\Projects\Minority_Readmissions\Data\MRsurvey.xls,out=survey)
%imp_xls(file=C:\data\Projects\Minority_Readmissions\Data\denominator.xls,out=denominator0)
%imp_xls(file=C:\data\Projects\Minority_Readmissions\Data\add.xls,out=add)
data add;
set add;
add=1;
run;
proc sql;
create table denominator as
select a.*,b.add
from denominator0 a left join add b
on a.medicare_id=b.aha_id;
quit;
proc freq data=denominator;tables add*designation;run;

* Assign Sampling Weights to all sampled hospitals in denominator;
data denominator;
set denominator;
if designation='MSH' then swt=1;
if designation in('Non-MSH Q1','Q1') and add=1 then swt=33/304;
if designation in('Non-MSH Q2-4','Q2-4') and add=1 then swt=333/1038;
if designation in('Non-MSH Q5','Q5') and add=1 then swt=34/313;
if designation in('Non-MSH Q1','Q1') and add=. then swt=200/531;
if designation in('Non-MSH Q2-4','Q2-4') and add=. then swt=201/1595;
if designation in('Non-MSH Q5','Q5') and add=. then swt=200/531;
prob=0.62;wt=1/(swt*prob);
run;

*Change Medicare_id from numeric to character, but remember Medicare_ID in survey are not reliable;
data denominator0;
set denominator;
if length(trim(medicare_id))=5 then medicare_id='0'||medicare_id;
drop urban teaching hospsize cicu hosp_reg4 profit2;
run;

**************************************Step 2:Get hosptial characteristics from AHA annual survey, if most recent year 2012 missing then go back as far as we can;
proc sql;
create table denominator12 as
select a.*,b.ruca_level as ruca_level12,b.teaching as teaching12,b.hospsize as hospsize12,b.micu as micu12,b.hosp_reg4 as hosp_reg412,b.profit2 as profit212,
b.prophisp12,b.propblk12,b.p_medicare as p_medicare12,b.p_medicaid as p_medicaid12
from denominator0 a left join aha.aha12 b
on a.medicare_id=b.provider;
quit;
proc sql;
create table denominator11 as
select a.*,b.ruca_level as ruca_level11,b.teaching as teaching11,b.hospsize as hospsize11,b.micu as micu11,b.hosp_reg4 as hosp_reg411,b.profit2 as profit211,
b.prophisp11,b.propblk11,b.p_medicare as p_medicare11,b.p_medicaid as p_medicaid11
from denominator12 a left join aha.aha11 b
on a.medicare_id=b.provider;
quit;
proc sql;
create table denominator10 as
select a.*,b.ruca_level as ruca_level10,b.teaching as teaching10,b.hospsize as hospsize10,b.micu as micu10,b.hosp_reg4 as hosp_reg410,b.profit2 as profit210,
b.prophisp10,b.propblk10,b.p_medicare as p_medicare10,b.p_medicaid as p_medicaid10
from denominator11 a left join aha.aha10 b
on a.medicare_id=b.provider;
quit;
proc sql;
create table denominator09 as
select a.*,b.ruca_level as ruca_level09,b.teaching as teaching09,b.hospsize as hospsize09,b.micu as micu09,b.hosp_reg4 as hosp_reg409,b.profit2 as profit209,
b.prophisp09,b.propblk09,b.p_medicare as p_medicare09,b.p_medicaid as p_medicaid09
from denominator10 a left join aha.aha09 b
on a.medicare_id=b.provider;
quit;
proc sql;
create table denominator08 as
select a.*,b.ruca_level as ruca_level08,b.teaching as teaching08,b.hospsize as hospsize08,b.hosp_reg4 as hosp_reg408,b.profit2 as profit208,
b.prophisp08,b.propblk08,b.p_medicare as p_medicare08,b.p_medicaid as p_medicaid08
from denominator09 a left join aha.aha08 b
on a.medicare_id=b.provider;
quit;
proc sql;
create table denominator07 as
select a.*,b.ruca_level as ruca_level07,b.teaching as teaching07,b.hospsize as hospsize07,b.micu as micu07,b.hosp_reg4 as hosp_reg407,b.profit2 as profit207,
b.prophisp07,b.propblk07,b.p_medicare as p_medicare07,b.p_medicaid as p_medicaid07
from denominator08 a left join aha.aha07 b
on a.medicare_id=b.provider;
quit;
proc sql;
create table denominator06 as
select a.*,b.ruca_level as ruca_level06,b.teaching as teaching06,b.hospsize as hospsize06,b.micu as micu06,b.hosp_reg4 as hosp_reg406,b.profit2 as profit206,
b.prophisp06,b.propblk06,b.p_medicare as p_medicare06,b.p_medicaid as p_medicaid06
from denominator07 a left join aha.aha06 b
on a.medicare_id=b.provider;
quit;

data denominator;
set denominator06;

if ruca_level12 ne . then ruca_level=ruca_level12;
else if ruca_level12=. and ruca_level11 ne . then ruca_level=ruca_level11;
else if ruca_level12=. and ruca_level11= . and ruca_level10 ne . then ruca_level=ruca_level10;
else if ruca_level12=. and ruca_level11= . and ruca_level10= .  and ruca_level09 ne . then ruca_level=ruca_level09;
else if ruca_level12=. and ruca_level11= . and ruca_level10= .  and ruca_level09= . and ruca_level08 ne . then ruca_level=ruca_level08;
else if ruca_level12=. and ruca_level11= . and ruca_level10= .  and ruca_level09= . and ruca_level08= . and ruca_level07 ne . then ruca_level=ruca_level07;
else if ruca_level12=. and ruca_level11= . and ruca_level10= .  and ruca_level09= . and ruca_level08= . and ruca_level07= . and ruca_level06 ne . then ruca_level=ruca_level06;

if teaching12 ne . then teaching=teaching12;
else if teaching12=. and teaching11 ne . then teaching=teaching11;
else if teaching12=. and teaching11= . and teaching10 ne . then teaching=teaching10;
else if teaching12=. and teaching11= . and teaching10= .  and teaching09 ne . then teaching=teaching09;
else if teaching12=. and teaching11= . and teaching10= .  and teaching09= . and teaching08 ne . then teaching=teaching08;
else if teaching12=. and teaching11= . and teaching10= .  and teaching09= . and teaching08= . and teaching07 ne . then teaching=teaching07;
else if teaching12=. and teaching11= . and teaching10= .  and teaching09= . and teaching08= . and teaching07= . and teaching06 ne . then teaching=teaching06;

if hospsize12 ne . then hospsize=hospsize12;
else if hospsize12=. and hospsize11 ne . then hospsize=hospsize11;
else if hospsize12=. and hospsize11= . and hospsize10 ne . then hospsize=hospsize10;
else if hospsize12=. and hospsize11= . and hospsize10= .  and hospsize09 ne . then hospsize=hospsize09;
else if hospsize12=. and hospsize11= . and hospsize10= .  and hospsize09= . and hospsize08 ne . then hospsize=hospsize08;
else if hospsize12=. and hospsize11= . and hospsize10= .  and hospsize09= . and hospsize08= . and hospsize07 ne . then hospsize=hospsize07;
else if hospsize12=. and hospsize11= . and hospsize10= .  and hospsize09= . and hospsize08= . and hospsize07= . and hospsize06 ne . then hospsize=hospsize06;

if ruca_level12 ne . then ruca_level=ruca_level12;
else if ruca_level12=. and ruca_level11 ne . then ruca_level=ruca_level11;
else if ruca_level12=. and ruca_level11= . and ruca_level10 ne . then ruca_level=ruca_level10;
else if ruca_level12=. and ruca_level11= . and ruca_level10= .  and ruca_level09 ne . then ruca_level=ruca_level09;
else if ruca_level12=. and ruca_level11= . and ruca_level10= .  and ruca_level09= . and ruca_level08 ne . then ruca_level=ruca_level08;
else if ruca_level12=. and ruca_level11= . and ruca_level10= .  and ruca_level09= . and ruca_level08= . and ruca_level07 ne . then ruca_level=ruca_level07;
else if ruca_level12=. and ruca_level11= . and ruca_level10= .  and ruca_level09= . and ruca_level08= . and ruca_level07= . and ruca_level06 ne . then ruca_level=ruca_level06;

if micu12 ne . then micu=micu12;
else if micu12=. and micu11 ne . then micu=micu11;
else if micu12=. and micu11= . and micu10 ne . then micu=micu10;
else if micu12=. and micu11= . and micu10= .  and micu09 ne . then micu=micu09;
else if micu12=. and micu11= . and micu10= .  and micu09= . and micu07 ne . then micu=micu07;
else if micu12=. and micu11= . and micu10= .  and micu09= . and micu07= . and micu06 ne . then micu=micu06;

if hosp_reg412 ne . then hosp_reg4=hosp_reg412;
else if hosp_reg412=. and hosp_reg411 ne . then hosp_reg4=hosp_reg411;
else if hosp_reg412=. and hosp_reg411= . and hosp_reg410 ne . then hosp_reg4=hosp_reg410;
else if hosp_reg412=. and hosp_reg411= . and hosp_reg410= .  and hosp_reg409 ne . then hosp_reg4=hosp_reg409;
else if hosp_reg412=. and hosp_reg411= . and hosp_reg410= .  and hosp_reg409= . and hosp_reg408 ne . then hosp_reg4=hosp_reg408;
else if hosp_reg412=. and hosp_reg411= . and hosp_reg410= .  and hosp_reg409= . and hosp_reg408= . and hosp_reg407 ne . then hosp_reg4=hosp_reg407;
else if hosp_reg412=. and hosp_reg411= . and hosp_reg410= .  and hosp_reg409= . and hosp_reg408= . and hosp_reg407= . and hosp_reg406 ne . then hosp_reg4=hosp_reg406;


if profit212 ne . then profit2=profit212;
else if profit212=. and profit211 ne . then profit2=profit211;
else if profit212=. and profit211= . and profit210 ne . then profit2=profit210;
else if profit212=. and profit211= . and profit210= .  and profit209 ne . then profit2=profit209;
else if profit212=. and profit211= . and profit210= .  and profit209= . and profit208 ne . then profit2=profit208;
else if profit212=. and profit211= . and profit210= .  and profit209= . and profit208= . and profit207 ne . then profit2=profit207;
else if profit212=. and profit211= . and profit210= .  and profit209= . and profit208= . and profit207= . and profit206 ne . then profit2=profit206;


if prophisp12 ne . then prophisp=prophisp12;
else if prophisp12=. and prophisp11 ne . then prophisp=prophisp11;
else if prophisp12=. and prophisp11= . and prophisp10 ne . then prophisp=prophisp10;
else if prophisp12=. and prophisp11= . and prophisp10= .  and prophisp09 ne . then prophisp=prophisp09;
else if prophisp12=. and prophisp11= . and prophisp10= .  and prophisp09= . and prophisp08 ne . then prophisp=prophisp08;
else if prophisp12=. and prophisp11= . and prophisp10= .  and prophisp09= . and prophisp08= . and prophisp07 ne . then prophisp=prophisp07;
else if prophisp12=. and prophisp11= . and prophisp10= .  and prophisp09= . and prophisp08= . and prophisp07= . and prophisp06 ne . then prophisp=prophisp06;


if propblk12 ne . then propblk=propblk12;
else if propblk12=. and propblk11 ne . then propblk=propblk11;
else if propblk12=. and propblk11= . and propblk10 ne . then propblk=propblk10;
else if propblk12=. and propblk11= . and propblk10= .  and propblk09 ne . then propblk=propblk09;
else if propblk12=. and propblk11= . and propblk10= .  and propblk09= . and propblk08 ne . then propblk=propblk08;
else if propblk12=. and propblk11= . and propblk10= .  and propblk09= . and propblk08= . and propblk07 ne . then propblk=propblk07;
else if propblk12=. and propblk11= . and propblk10= .  and propblk09= . and propblk08= . and propblk07= . and propblk06 ne . then propblk=propblk06;


if p_medicare12 ne . then p_medicare=p_medicare12;
else if p_medicare12=. and p_medicare11 ne . then p_medicare=p_medicare11;
else if p_medicare12=. and p_medicare11= . and p_medicare10 ne . then p_medicare=p_medicare10;
else if p_medicare12=. and p_medicare11= . and p_medicare10= .  and p_medicare09 ne . then p_medicare=p_medicare09;
else if p_medicare12=. and p_medicare11= . and p_medicare10= .  and p_medicare09= . and p_medicare08 ne . then p_medicare=p_medicare08;
else if p_medicare12=. and p_medicare11= . and p_medicare10= .  and p_medicare09= . and p_medicare08= . and p_medicare07 ne . then p_medicare=p_medicare07;
else if p_medicare12=. and p_medicare11= . and p_medicare10= .  and p_medicare09= . and p_medicare08= . and p_medicare07= . and p_medicare06 ne . then p_medicare=p_medicare06;


if p_medicaid12 ne . then p_medicaid=p_medicaid12;
else if p_medicaid12=. and p_medicaid11 ne . then p_medicaid=p_medicaid11;
else if p_medicaid12=. and p_medicaid11= . and p_medicaid10 ne . then p_medicaid=p_medicaid10;
else if p_medicaid12=. and p_medicaid11= . and p_medicaid10= .  and p_medicaid09 ne . then p_medicaid=p_medicaid09;
else if p_medicaid12=. and p_medicaid11= . and p_medicaid10= .  and p_medicaid09= . and p_medicaid08 ne . then p_medicaid=p_medicaid08;
else if p_medicaid12=. and p_medicaid11= . and p_medicaid10= .  and p_medicaid09= . and p_medicaid08= . and p_medicaid07 ne . then p_medicaid=p_medicaid07;
else if p_medicaid12=. and p_medicaid11= . and p_medicaid10= .  and p_medicaid09= . and p_medicaid08= . and p_medicaid07= . and p_medicaid06 ne . then p_medicaid=p_medicaid06;




drop ruca_level12 ruca_level11 ruca_level10 ruca_level09 ruca_level08 ruca_level07 ruca_level06
     teaching12 teaching11 teaching10 teaching09 teaching08 teaching07 teaching06
     hospsize12 hospsize11 hospsize10 hospsize09 hospsize08 hospsize07 hospsize06
     ruca_level12 ruca_level11 ruca_level10 ruca_level09 ruca_level08 ruca_level07 ruca_level06
     micu12 micu11 micu10 micu09  micu07 micu06 
     hosp_reg412 hosp_reg411 hosp_reg410 hosp_reg409 hosp_reg408 hosp_reg407 hosp_reg406
     profit212 profit211 profit210 profit209 profit208 profit207 profit206 
	 propblk12 propblk11 propblk10 propblk09 propblk08 propblk07 propblk06
	 prophisp12 prophisp11 prophisp10 prophisp09 prophisp08 prophisp07 prophisp06
	 p_medicare12 p_medicare11 p_medicare10 p_medicare09 p_medicare08 p_medicare07 p_medicare06
     p_medicaid12 p_medicaid11 p_medicaid10 p_medicaid09 p_medicaid08 p_medicaid07 p_medicaid06;
run;

******************************************************************Step 3: Safty-net;
** Get Safety Net Status or DSH percentage;
%macro imp_xls(file=,out=);
proc import datafile="&file." dbms=xls out=&out. replace;
getnames=yes;
run;
%mend imp_xls;

%imp_xls(file=C:\data\Data\Hospital\Impact\Archive\impact2015import.xls,out=impact2015);
%imp_xls(file=C:\data\Data\Hospital\Impact\Archive\impact2014import.xls,out=impact2014);
libname impact 'C:\data\Data\Hospital\Impact';
data impact2008;
set impact.impact2008;
provider_number=provider;
keep provider_number dshpct2008  ;
run;
data impact2009;
set impact.impact2009;
provider_number=provider;
keep provider_number dshpct2009  ;
run;
data impact2010;
set impact.impact2010;
provider_number=provider;
keep provider_number dshpct2010  ;
run;
data impact2011;
set impact.impact2011;
provider_number=provider;
keep provider_number dshpct2011  ;
run;
data impact2012;
set impact.impact2012;
provider_number=provider;
keep provider_number dshpct2012  ;
run;
 

data impact2014;
set impact2014;
provider=provider_number*1;
rename provider=provider_number;
rename dshpct=dshpct2014;
keep provider dshpct;
run;
data impact2015;
set impact2015;
provider=provider_number*1;
rename provider=provider_number;
rename dshpct=dshpct2015;
keep provider dshpct;
run;


* Acute Care hospitals only;
data AcuteCare;
set aha.aha12;
t=substr(provider,3,2) ; 
	if t in ('00','01','02','03','04','05','06','07','08') then type='Acute Care Hospitals';*3398;
	if t in ('13') then type='Critical Access Hospitals'; *1235;
     
if t in ('00','01','02','03','04','05','06','07','08');

if hosp_reg4 ne '5' and profit2 ne '4';
provider_number=provider*1;
keep provider provider_number  t type dshpct2012;
run;
 
proc sql;
create table temp as
select a.*,b.DSHpct2008
from AcuteCare a left join impact2008 b
on a.provider_number=b.provider_number;
quit;
proc sql;
create table temp1 as
select a.*,b.DSHpct2009
from temp a left join impact2009 b
on a.provider_number=b.provider_number;
quit;
proc sql;
create table temp2 as
select a.*,b.DSHpct2010
from temp1 a left join impact2010 b
on a.provider_number=b.provider_number;
quit;
proc sql;
create table temp3 as
select a.*,b.DSHpct2011
from temp2 a left join impact2011 b
on a.provider_number=b.provider_number;
quit;
proc sql;
create table temp4 as
select a.*,b.DSHpct2012
from temp3 a left join impact2012 b
on a.provider_number=b.provider_number;
quit;
proc sql;
create table temp6 as
select a.*,b.DSHpct2014
from temp4 a left join impact2014 b
on a.provider_number=b.provider_number;
quit;
proc sql;
create table temp7 as
select a.*,b.DSHpct2015
from temp6 a left join impact2015 b
on a.provider_number=b.provider_number;
quit;

 

data temp9;
set temp7;
if dshpct2015 ne . then dshpct=dshpct2015;
else if dshpct2015=. and dshpct2014 ne . then dshpct=dshpct2014;
else if dshpct2015=. and dshpct2014=. and dshpct2012 ne . then dshpct=dshpct2012;
else if dshpct2015=. and dshpct2014=. and dshpct2012= . and dshpct2011 ne . then dshpct=dshpct2011;
else if dshpct2015=. and dshpct2014=. and dshpct2012= . and dshpct2011=. and dshpct2010 ne . then dshpct=dshpct2010;
else if dshpct2015=. and dshpct2014=. and dshpct2012= . and dshpct2011=. and dshpct2010=. and dshpct2009 ne . then dshpct=dshpct2009;
else if dshpct2015=. and dshpct2014=. and dshpct2012= . and dshpct2011=. and dshpct2010=. and dshpct2009=. and dshpct2008 ne . then dshpct=dshpct2008;
run;



*******************Among 3368 Acute Care Hospitals from AHA2012, Get the cutpoint of top25%;
proc means data=temp9 min q1 median mean q3 max;var dshpct;run;

** cut-point: 0.3556750  ;
proc rank data=temp9 out=AHA_DSH_rank  group=4;
var DSHpct;
ranks DSHpct_Rank;
run;
proc sort data=AHA_DSH_rank ;by descending DSHpct_Rank;run;
data AHA_DSH_rank;
set AHA_DSH_rank;
if DSHpct_Rank=3 then SNH=1;else if DSHpct_Rank ne . then SNH=0;
run;


***********Merge denominator to General Acute Care hospitals with corresponding HSDpct 2012;
proc sql;
create table denominator1 as
select a.*,b.dshpct,b.SNH
from denominator a left join AHA_DSH_rank b
on a.medicare_id=b.provider;
quit;

proc freq data=denominator1;tables SNH/missing;run;




******************************************Step 4: Get cost margin from cost reports;
libname cr 'C:\data\Data\Hospital\Cost Reports';
*total_margin=net_income/sum(net_pat_rev,tot_oth_inc); 
*net income / total revenues :Total margin ratio examines an organization's revenue as a function of its expenses. ;
data cost_reports_2013;
set cr.cost_reports_2013;
total_margin=net_income/sum(net_pat_rev,tot_oth_inc);
run;
*the Cost Report data may have more than one entry for each hospital, the following code dedups the hospital entries and ensures that the latest, most complete entry is used;
proc sort data=cost_reports_2013;
  by ccn descending rpt_rec_num;
proc sort data=cost_reports_2013 nodupkey;
  by ccn;
run;

proc sql;
create table denominator2 as
select a.*,b.total_margin 
from denominator1 a left join cost_reports_2013 b
on a.medicare_id=b.prvdr_num;
quit;










*****************************************Step 5: Quality Meaure (Readmission Rate);
* All hospital Number of Admission & NUmber of readm & hospital condition-specific number of readmission;
data Adjreadm36meas30day2012;
set readm.Adjreadm36meas30day2012;
array temp {9}  
NDmeas_amiall  NDmeas_chfall NDmeas_pnall
preadmmeas_amiall30day preadmmeas_CHFall30day preadmmeas_PNall30day
rawreadmmeas_amiall30day rawreadmmeas_CHFall30day rawreadmmeas_PNall30day;
do i=1 to 9;
if temp{i}=. then temp{i}=0;
end;

run ;


proc sql;
create table temp2012 as
select provider, 
 
preadmmeas_amiall30day*NDmeas_amiall as pNreadm_AMI, 
preadmmeas_chfall30day*NDmeas_chfall as pNreadm_CHF, 
preadmmeas_pnall30day*NDmeas_pnall as pNreadm_PN,
NDmeas_amiall*rawreadmmeas_amiall30day as obsNreadm_AMI,
NDmeas_CHFall*rawreadmmeas_CHFall30day as obsNreadm_CHF,
NDmeas_PNall*rawreadmmeas_PNall30day as obsNreadm_PN,
 
NDmeas_amiall,  NDmeas_chfall, NDmeas_pnall,

(calculated obsNreadm_AMI) + (calculated obsNreadm_CHF) + (calculated obsNreadm_PN) as obs,
(calculated pNreadm_AMI) + (calculated pNreadm_CHF) + (calculated pNreadm_PN) as p,
NDmeas_amiall+NDmeas_CHFall+NDmeas_PNall  as N,

sum(calculated obs) as Nation_obs, sum(calculated N) as Nation_N,

(calculated Nation_obs)/ (calculated Nation_N) as OverallRate,

(calculated obs)/(calculated p) as ratio,

(calculated ratio)*(calculated OverallRate) as Readm
from Adjreadm36meas30day2012;
quit;

proc sql;
create table temp13 as
select a.*,b.readm
from AcuteCare a left join temp2012 b
on a.provider=b.provider;
quit;
 


proc rank data=temp13 out=AHA_Readm_rank group=4 ;
var readm;
ranks readm_Rank;
run;

proc sql;
create table denominator3 as
select a.*,b.readm,b.readm_rank
from denominator2 a left join AHA_readm_rank b
on a.medicare_id=b.provider;
quit;

 

data denominator4;
set denominator3 ; 
if readm_rank=0 then quality=1;
else if readm_rank in (1,2,3) then quality=2;
*else if readm_rank=4 then quality=3;
proc means;class quality;var readm;
run;




**********************************Step6: Redefine MSH groups and delete non-acure care;;
*denominator1: Delete critical, LTAC, children's from the denominator;
data deletethem denominator3;
set denominator4;
if substr(medicare_id,3,2) in ('13','20','21','22','33') then output deletethem;
else output denominator3;
run;

* Divide original MSH into Major MSH and Minor MSH: Link with 2010 AHA, rank MSHs by %black, let 360(I think should be 356) be top 10%;
data MSH nonMSH;
set denominator3;
if designation='MSH' then output MSH;else output nonMSH;
run;

proc sort data=MSH;by descending propblk;run;

data MSH;
length group $30.;
set MSH;
if _n_<=356 then do;group='Top 10%';group_num=1;group_num0=1;end;
else do;group='Top 10-25%';group_num=2;group_num0=1;end;
run;

data nonMSH;
length group $30.;
set nonMSH;
group='non-MSH';group_num=3;group_num0=0; 
run;

data denominator5;
set MSH nonMSH;
run;

*Two Group MSH;

proc rank data=denominator3 out=temp group=4;
var propblk;
ranks propblk_rank;
run;

data temp;
set temp;
if propblk_rank=3 then MSH2="Top 25% Minority Serving Hospital";
else if propblk ne . then MSH2="Others";
else MSH2="";
keep Medicare_ID MSH2;
run;

proc sql;
create table denominator6 as
select a.*,b.*
from denominator5 a left join temp b
on a.Medicare_id=b.Medicare_id;
quit;


****************************************Step 7: Link Survey with denominator and other cleaning;
* survey1: contains whose should be deleted hospitals but also responded to our survey;
proc sql;
create table survey1 as
select *
from survey
where hsph_id not in (select hsph_id from deletethem);
quit;

***************************************** Clean ;
data survey2;
set survey1;
if var3='Non-MSH Q1' then var3='Q1';
if var3='Non-MSH Q2-4' then var3='Q2-4';
if var3='Non-MSH Q5' then var3='Q5';
if q16=. then q16=9;
if q18a=. then q18a=9;
if medid='140234' then hsph_id='R00211a';
rename var3=designation;
drop  AHA_ID var5 DSID__Datastat_only_ MAIL_STAT__Datastat_only_;
run;

proc sql;
create table temp as
select a.medicare_id,a.add, a.wt, a.group,a.Hospital_Name,
a.ruca_level,a.profit2,a.teaching, a.hospsize, a.hosp_reg4, a.MICU, a.mhsmemb, a.propblk, a.prophisp, a.p_medicare, a.p_medicaid, 
a.dshpct,a.snh,a.total_margin,a.group,a.group_num,a.group_num0,a.quality,a.readm,a.MSH2, b.*
from denominator6 a full join survey2  b
on a.hsph_id=b.hsph_id;
quit;

***************************************Step 8: Dichotomize each question;

/*
Q1_1 Q1_2 Q1_3 Q1_4 Q1_5  
Q2A Q2B Q2C
Q3A Q3B Q3C Q3D Q3E 
Q4a Q4b Q4c Q4d
Q5
Q6
Q7a Q7b Q7c Q7d Q7e Q7f Q7g Q7h Q7i Q7j Q7k Q7l Q7m
Q8a Q8b Q8c Q8d Q8e Q8f Q8g Q8h Q8i Q8j Q8k Q8l Q8m
Q10
Q11A Q11b Q11c Q11d-bsed on q10
q12a q12b q12c q12d q12e q12f q12g q12h
q13a q13b
q14a q14b q14c q14d
q15a q15b q15c q15d
q16
q18a q18b q18c
q19a q19b
q20
q21
q22a q22b q22c q22d q22e q22f
q23a q23b q23c q23d q23e q23f
q24a1 q24b1 q24a2 q24b2 q24c2
Q25A1 Q25A2 Q25B1 Q25B2 Q25C1 Q25C2 Q25D1 Q25D2
*/

data temp1;
set temp;
*yes;
if Q1_1=1 then y1_1=1;else y1_1=0; 
if Q1_2=1 then y1_2=1;else y1_2=0; 
if Q1_3=1 then y1_3=1;else y1_3=0; 
if Q1_4=1 then y1_4=1;else y1_4=0; 
if Q1_5=1 then y1_5=1;else y1_5=0; 
*yes;
if Q2a=1 then y2a=1;else y2a=0; 
if Q2b=1 then y2b=1;else y2b=0; 
if Q2c=1 then y2c=1;else y2c=0; 
 *yes;
if Q3A=1 then y3A=1;else y3A=0; 
if Q3b=1 then y3b=1;else y3b=0; 
if Q3c=1 then y3c=1;else y3c=0; 
if Q3d=1 then y3d=1;else y3d=0; 
if Q3e=1 then y3e=1;else y3e=0; 

*yes;
if Q4A=1 then y4A=1;else y4A=0; 
if Q4b=1 then y4b=1;else y4b=0; 
if Q4c=1 then y4c=1;else y4c=0; 
if Q4d=1 then y4d=1;else y4d=0;

* Higher then average;
if Q5=3 then y5=1;else y5=0;
* Improved Significant;
if Q6=1 then y6=1;else y6=0;

* always or usual;
if q7a in (1,2) then y7a=1;else y7a=0;
if q7b in (1,2) then y7b=1;else y7b=0;
if q7c in (1,2) then y7c=1;else y7c=0;
if q7d in (1,2) then y7d=1;else y7d=0;
if q7e in (1,2) then y7e=1;else y7e=0;
if q7f in (1,2) then y7f=1;else y7f=0;
if q7g in (1,2) then y7g=1;else y7g=0;
if q7h in (1,2) then y7h=1;else y7h=0;
if q7i in (1,2) then y7i=1;else y7i=0;
if q7j in (1,2) then y7j=1;else y7j=0;
if q7k in (1,2) then y7k=1;else y7k=0;
if q7l in (1,2) then y7l=1;else y7l=0;
if q7m in (1,2) then y7m=1;else y7m=0;

* yes;
if q8a =1 then y8a=1;else y8a=0;
if q8b =1 then y8b=1;else y8b=0;
if q8c =1 then y8c=1;else y8c=0;
if q8d =1 then y8d=1;else y8d=0;
if q8e =1 then y8e=1;else y8e=0;
if q8f =1 then y8f=1;else y8f=0;
if q8g =1 then y8g=1;else y8g=0;
if q8h =1 then y8h=1;else y8h=0;
if q8i =1 then y8i=1;else y8i=0;
if q8j =1 then y8j=1;else y8j=0;
if q8k =1 then y8k=1;else y8k=0;
if q8l =1 then y8l=1;else y8l=0;
if q8m =1 then y8m=1;else y8m=0;

*yes;
if q10 =1 then y10=1;else y10=0;

*yes;
if q10=2 then do;
	if q11a =1 then y11a=1;else y11a=0;
	if q11b =1 then y11b=1;else y11b=0;
	if q11c =1 then y11c=1;else y11c=0;
	if q11d =1 then y11d=1;else y11d=0;
end;

* 4+Great challenge;
if q12a in (4,5) then y12a=1;else y12a=0;
if q12b in (4,5) then y12b=1;else y12b=0;
if q12c in (4,5) then y12c=1;else y12c=0;
if q12d in (4,5) then y12d=1;else y12d=0;
if q12e in (4,5) then y12e=1;else y12e=0;
if q12f in (4,5) then y12f=1;else y12f=0;
if q12g in (4,5) then y12g=1;else y12g=0;
if q12h in (4,5) then y12h=1;else y12h=0;

* 4+Great challenge;
if q13a in (4,5) then y13a=1;else y13a=0;
if q13b in (4,5) then y13b=1;else y13b=0;
* 4+Great challenge;
if q14a in (4,5) then y14a=1;else y14a=0;
if q14b in (4,5) then y14b=1;else y14b=0;
if q14c in (4,5) then y14c=1;else y14c=0;
if q14d in (4,5) then y14d=1;else y14d=0;
* 4+Great challenge;
if q15a in (4,5) then y15a=1;else y15a=0;
if q15b in (4,5) then y15b=1;else y15b=0;
if q15c in (4,5) then y15c=1;else y15c=0;
if q15d in (4,5) then y15d=1;else y15d=0;

*yes;
if q16 =1 then y16=1;else y16=0;
* 4+Great Impact;
if q18a in (4,5) then y18a=1;else y18a=0;
if q18b in (4,5) then y18b=1;else y18b=0;
if q18c in (4,5) then y18c=1;else y18c=0;
 
*4 or EXTREMELY LIKELY;
if q19a in (4,5) then y19a=1;else y19a=0;
if q19b in (4,5) then y19b=1;else y19b=0;

*Much Too Large;
if q20 in (4,5) then y20=1;else y20=0;
 
*CARE WILL IMPROVE SOMEWHAT or CARE WILL IMPROVE A GREAT DEAL;
if q21 in (4,5) then y21=1;else y21=0;

*Agree Strongly;
if q22a in (4,5) then y22a=1;else y22a=0;
if q22b in (4,5) then y22b=1;else y22b=0;
if q22c in (4,5) then y22c=1;else y22c=0;
if q22d in (4,5) then y22d=1;else y22d=0;
if q22e in (4,5) then y22e=1;else y22e=0;
if q22f in (4,5) then y22f=1;else y22f=0;

* 9+Highest Priority;
if q23a in (9,10) then y23a=1;else y23a=0;
if q23b in (9,10) then y23b=1;else y23b=0;
if q23c in (9,10) then y23c=1;else y23c=0;
if q23d in (9,10) then y23d=1;else y23d=0;
if q23e in (9,10) then y23e=1;else y23e=0;
if q23f in (9,10) then y23f=1;else y23f=0;


*yes;
if q24a1 =1 then y24a1=1;else y24a1=0;
if q24b1 =1 then y24b1=1;else y24b1=0;
if q24a2 =1 then y24a2=1;else y24a2=0;
if q24b2 =1 then y24b2=1;else y24b2=0;
if q24c2 =1 then y24c2=1;else y24c2=0;

*yes;
if q25A1 =1 then y25A1=1;else y25A1=0;
if q25A2 =1 then y25A2=1;else y25A2=0;
if q25B1 =1 then y25B1=1;else y25B1=0;
if q25B2 =1 then y25B2=1;else y25B2=0;
if q25C1 =1 then y25C1=1;else y25C1=0;
if q25C2 =1 then y25C2=1;else y25C2=0;
if q25D1 =1 then y25D1=1;else y25D1=0;
if q25D2 =1 then y25D2=1;else y25D2=0;
run;


************************************Step9: Make a final analytic dataset that contains all information about survey responders ;
data temp2;
set temp1;
if Q1_1 ne .;
provider=medicare_id*1;
*if mhsmemb=. then mhsmemb=3;
*if cicu=. then cicu=3;
run; 
data data.denominator;
set temp1;
*if mhsmemb=. then mhsmemb=3;
*if cicu=. then cicu=3;
run; 

**************************************Step10: FY2014 Readmission Penalty;
proc import datafile="C:\data\Projects\Jha_Requests\Data\Readmissions YEAR 3 Penalties Data-2014-10-01xlsx.xlsx" dbms=xlsx out=penalty replace;getnames=yes;run;

data nopenalty haspenalty;
set penalty;
provider=provider_id*1;
Penalty=FY2014_Readmission_Penalty*1;
if penalty =0 then output nopenalty;
else if penalty>0 then output haspenalty;
run;

proc rank data=haspenalty out=temp3 group=2;
var penalty;
ranks penaltyrank;
run;


proc sql;
create table temp4 as
select a.*,b.penalty,b.penaltyrank
from temp2 a left join temp3 b
on a.provider=b.provider;
quit;

proc sql;
create table temp5 as
select a.*,b.penalty as penalty0
from temp4 a left join nopenalty b
on a.provider=b.provider;
quit;

data temp6;
set temp5;
if penalty0=0 then penaltygroup=0;
else if penaltyrank=0 then penaltygroup=1;
else if penaltyrank=1 then penaltygroup=2;

proc freq ;tables penaltygroup/missing;
run;
/*
proc import datafile="C:\data\Projects\Minority_Readmissions\Data\Penalty.xlsx" dbms=xlsx out=penalty replace;getnames=yes;run;

data penalty;
set penalty;
Penalty=ReadmissionPenaltyFY2014*1;
run;

proc rank data=penalty out=temp3 group=2;
var penalty;
ranks penaltyrank;
run;


proc sql;
create table temp4 as
select a.*,b.*
from temp2 a left join temp3 b
on a.provider=b.provider;
quit;


data temp5;
set temp4;
if penaltyrank=. then penaltygroup=0;
else if penaltyrank=0 then penaltygroup=1;
else if penaltyrank=1 then penaltygroup=2;
proc freq ;tables penaltygroup;
run;
*/

***************************************Step11: Dummy coding for hospital characteristics;
data data.survey_analytic;
set temp6;

teaching2=0;teaching3=0;
profit2_2=0;profit2_3=0;profit2_4=0;
hospsize2=0;hospsize3=0;
hosp_reg4_2=0;hosp_reg4_3=0;hosp_reg4_4=0;
ruca_level_2=0;ruca_level_3=0;ruca_level_4=0;
if teaching=2 then teaching2=1;else if teaching=3 then teaching3=1;
if profit2=2 then profit2_2=1;else if profit2=3 then profit2_3=1;else if profit2=4 then profit2_4=1;
if hospsize=2 then hospsize2=1;else if hospsize=3 then hospsize3=1;
if hosp_reg4=2 then hosp_reg4_2=1;else if hosp_reg4=3 then hosp_reg4_3=1;else if hosp_reg4=4 then hosp_reg4_4=1;
if ruca_level=2 then ruca_level_2=1;else if ruca_level=3 then ruca_level_3=1;else if ruca_level=4 then ruca_level_4=1;
run;
 
proc format;
value teaching_
1='Major teaching'
2='Minor teaching'
3='Non-Teaching'
;
run;
proc format;
value profit2_
1='Investor Owned, For-Profit'
2='Non-Government, Not-For-Profit'
3='Government, Non-Federal'
4='Government, Federal'
;
run;
proc format ;
value hospsize_
1='Small [1-99 beds]'
2='Medium [100-399 beds]'
3='Large [400+ beds]'
;
run;
proc format;
value hosp_reg4_
1='North East'
2='Midwest'
3='South'
4='West'
;
run;
*Rural-Urban Commuting Area (RUCA) ;
proc format;
value ruca_level_
1='Urban'
2='Suburban'
3='Large Rural Town'
4='Small Town/Isolated Rural'
;
run;
proc format ;
value $MICU_
1='Hospital has MICU'
0='Hospital has NO MICU'
;
run;
proc format ;
value SNH_
1='Safety Net Hospital'
0='Not'
;
run;
proc format ;
value quality_
1='Q1(Lowest Readmission)'
2='Q2-4'
3='Q5(Highest Readmission)';
run;
 

