***********************
Hospital Characteristics
Xiner Zhou
2/4/2015
*********************;


libname data 'C:\data\Projects\Minority_Readmissions\Data';
libname aha 'C:\data\Data\Hospital\AHA\Annual_Survey\Data';


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
if designation in('Non-MSH Q1','Q1') and add=. then swt=200/304;
if designation in('Non-MSH Q2-4','Q2-4') and add=. then swt=201/1038;
if designation in('Non-MSH Q5','Q5') and add=. then swt=200/313;
run;

*Change Medicare_id from numeric to character, but remember Medicare_ID in survey are not reliable;
data denominator0;
set denominator;
if length(trim(medicare_id))=5 then medicare_id='0'||medicare_id;
drop urban teaching hospsize cicu hosp_reg4 profit2;
run;

*Get hosptial characteristics from AHA annual survey, if most recent year 2012 missing then go back as far as we can;
proc sql;
create table denominator12 as
select a.*,b.ruca_level as ruca_level12,b.teaching as teaching12,b.hospsize as hospsize12,b.cicu as cicu12,b.hosp_reg4 as hosp_reg412,b.profit2 as profit212
from denominator0 a left join aha.aha12 b
on a.medicare_id=b.provider;
quit;
proc sql;
create table denominator11 as
select a.*,b.ruca_level as ruca_level11,b.teaching as teaching11,b.hospsize as hospsize11,b.cicu as cicu11,b.hosp_reg4 as hosp_reg411,b.profit2 as profit211
from denominator12 a left join aha.aha11 b
on a.medicare_id=b.provider;
quit;
proc sql;
create table denominator10 as
select a.*,b.ruca_level as ruca_level10,b.teaching as teaching10,b.hospsize as hospsize10,b.cicu as cicu10,b.hosp_reg4 as hosp_reg410,b.profit2 as profit210
from denominator11 a left join aha.aha10 b
on a.medicare_id=b.provider;
quit;
proc sql;
create table denominator09 as
select a.*,b.ruca_level as ruca_level09,b.teaching as teaching09,b.hospsize as hospsize09,b.cicu as cicu09,b.hosp_reg4 as hosp_reg409,b.profit2 as profit209
from denominator10 a left join aha.aha09 b
on a.medicare_id=b.provider;
quit;
proc sql;
create table denominator08 as
select a.*,b.ruca_level as ruca_level08,b.teaching as teaching08,b.hospsize as hospsize08,b.hosp_reg4 as hosp_reg408,b.profit2 as profit208
from denominator09 a left join aha.aha08 b
on a.medicare_id=b.provider;
quit;
proc sql;
create table denominator07 as
select a.*,b.ruca_level as ruca_level07,b.teaching as teaching07,b.hospsize as hospsize07,b.cicu as cicu07,b.hosp_reg4 as hosp_reg407,b.profit2 as profit207
from denominator08 a left join aha.aha07 b
on a.medicare_id=b.provider;
quit;
proc sql;
create table denominator06 as
select a.*,b.ruca_level as ruca_level06,b.teaching as teaching06,b.hospsize as hospsize06,b.cicu as cicu06,b.hosp_reg4 as hosp_reg406,b.profit2 as profit206
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

if cicu12 ne . then cicu=cicu12;
else if cicu12=. and cicu11 ne . then cicu=cicu11;
else if cicu12=. and cicu11= . and cicu10 ne . then cicu=cicu10;
else if cicu12=. and cicu11= . and cicu10= .  and cicu09 ne . then cicu=cicu09;
else if cicu12=. and cicu11= . and cicu10= .  and cicu09= . and cicu07 ne . then cicu=cicu07;
else if cicu12=. and cicu11= . and cicu10= .  and cicu09= . and cicu07= . and cicu06 ne . then cicu=cicu06;

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


drop ruca_level12 ruca_level11 ruca_level10 ruca_level09 ruca_level08 ruca_level07 ruca_level06
     teaching12 teaching11 teaching10 teaching09 teaching08 teaching07 teaching06
     hospsize12 hospsize11 hospsize10 hospsize09 hospsize08 hospsize07 hospsize06
     ruca_level12 ruca_level11 ruca_level10 ruca_level09 ruca_level08 ruca_level07 ruca_level06
     cicu12 cicu11 cicu10 cicu09  cicu07 cicu06 
     hosp_reg412 hosp_reg411 hosp_reg410 hosp_reg409 hosp_reg408 hosp_reg407 hosp_reg406
     profit212 profit211 profit210 profit209 profit208 profit207 profit206;
run;

* denominator1: Delete critical, LTAC, children's from the denominator;
data deletethem denominator1;
set denominator;
if substr(medicare_id,3,2) in ('13','20','21','22','33') then output deletethem;
else output denominator1;
run;

* survey1: contains whose should be deleted hospitals but also responded to our survey;
proc sql;
create table survey1 as
select *
from survey
where hsph_id not in (select hsph_id from deletethem);
quit;


* Divide original MSH into Major MSH and Minor MSH: Link with 2010 AHA, rank MSHs by %black, let 360(I think should be 356) be top 10%;
data MSH nonMSH;
set denominator;
if designation='MSH' then output MSH;else output nonMSH;
run;

proc sql;
create table MSHAHA10 as
select a.*,b.propblk10 
from MSH a left join aha.aha10 b
on a.medicare_id=b.provider;
quit;
data try MSHAHA;
set mshaha10;
if propblk10 =. then output try;else output MSHAHA;
run;

proc sql;
create table try1 as
select a.*,b.propblk12
from try a left join aha.aha12 b
on a.medicare_id=b.provider;
quit;
proc sql;
create table try2 as
select a.*,b.propblk11
from try1 a left join aha.aha11 b
on a.medicare_id=b.provider;
quit;
proc sql;
create table try3 as
select a.*,b.propblk10
from try2 a left join aha.aha10 b
on a.medicare_id=b.provider;
quit;
proc sql;
create table try4 as
select a.*,b.propblk09
from try3 a left join aha.aha09 b
on a.medicare_id=b.provider;
quit;
 
data try;
set try4;
if propblk11 ne . then propblk10=propblk11;
else if propblk12 ne . then propblk10=propblk12;
else if propblk09 ne . then propblk10=propblk09;
run;


data MSH;
set MSHAHA try;
drop propblk11 propblk12 propblk09;
run;





proc sort data=MSH;by descending propblk10;run;

data MSH;
length group $30.;
set MSH;
if _n_<=356 then group='Top 10%';
else group='Top 10-25%';
run;

data nonMSH;
length group $30.;
set nonMSH;
group='non-MSH';
run;

data denominator;
set MSH nonMSH;
run;


***************************************** Clean ;
data survey;
set survey1;
if var3='Non-MSH Q1' then var3='Q1';
if var3='Non-MSH Q2-4' then var3='Q2-4';
if var3='Non-MSH Q5' then var3='Q5';
if q16=. then q16=9;
if q18a=. then q18a=9;
if medid='140234' then hsph_id='R00211a';
rename var3=designation;
drop a AHA_ID var5 DSID__Datastat_only_ MAIL_STAT__Datastat_only_;
run;
  
**************************************Sampling weight;
/*
Sapling Methodology:

MSH--899 Sampled all of them
non-MSH: 
1th round sample (Q1-200/531 Q2to4-201/1595 Q5-200/531)
3rd round sample (Q1-33/304 Q2to4-33/1038 Q5-34/313)
*/


proc sql;
create table temp as
select a.medicare_id,a.add, a.swt, a.group,a.Hospital_Name,a.ruca_level,a.profit2,a.teaching, a.hospsize, a.hosp_reg4, a.CICU, a.mhsmemb, b.*
from denominator a full join survey  b
on a.hsph_id=b.hsph_id;
quit;
data temp;
set temp;
if Q1_1=. then respond=0;else respond=1;
if mhsmemb=. then mhsmemb=3;
if cicu=. then cicu=3;
run; 

 
/*********************************** Non-response weight;

proc logistic data=temp   ;
title 'Response Rate Model';
	class respond(ref="0") ruca_level(ref="1")  profit2(ref="1") teaching(ref="3") hosp_reg4(ref="1") CICU(ref="1") mhsmemb(ref="1")  /param=ref ;
	model respond  = ruca_level profit2 teaching hosp_reg4 CICU mhsmemb ; 
	output  out=temp1 p=prob;  
run;
*/
************************************Final weight;
/*data temp2;
set temp1;
if prob=. then prob=0.6247655;
wt=1/(swt*prob);
run;
*/
data temp2;
set temp;
prob=0.62;wt=1/(swt*prob);
run;

proc sql;
select sum(wt),mean(wt)
from temp2
where respond=1;
quit;

* Get %black, p_medicare, p_medicaid;

proc sql;
create table temp3 as
select a.*,b.prophisp10,b.propblk10,b.p_medicare as p_medicare10,b.p_medicaid as p_medicaid10
from temp2 a left join aha.aha10 b
on a.medicare_id=b.provider;
quit;

proc sql;
create table temp4 as
select a.*,b.prophisp12,b.propblk12,b.p_medicare as p_medicare12,b.p_medicaid as p_medicaid12
from temp3 a left join aha.aha12 b
on a.medicare_id=b.provider;
quit;
proc sql;
create table temp5 as
select a.*,b.prophisp11,b.propblk11,b.p_medicare as p_medicare11,b.p_medicaid as p_medicaid11
from temp4 a left join aha.aha11 b
on a.medicare_id=b.provider;
quit;

proc sql;
create table temp6 as
select a.*,b.prophisp09,b.propblk09,b.p_medicare as p_medicare09,b.p_medicaid as p_medicaid09
from temp5 a left join aha.aha09 b
on a.medicare_id=b.provider;
quit;
 
data denominator;
set temp6;
if propblk10 ne . then black=propblk10;
else if propblk10=. and propblk11 ne . then black=propblk11;
else if propblk10=. and propblk11=. and propblk12 ne . then black=propblk12;
else if propblk10=. and propblk11=. and propblk12=. and propblk09 ne . then black=propblk09;

if prophisp10 ne . then hisp=prophisp10;
else if prophisp10=. and prophisp11 ne . then hisp=prophisp11;
else if prophisp10=. and prophisp11=. and prophisp12 ne . then hisp=prophisp12;
else if prophisp10=. and prophisp11=. and prophisp12=. and prophisp09 ne . then hisp=prophisp09;

if p_medicare10 ne . then p_medicare=p_medicare10;
else if p_medicare10=. and p_medicare11 ne . then p_medicare=p_medicare11;
else if p_medicare10=. and p_medicare11=. and p_medicare12 ne . then p_medicare=p_medicare12;
else if p_medicare10=. and p_medicare11=. and p_medicare12=. and p_medicare09 ne . then p_medicare=p_medicare09;

if p_medicaid10 ne . then p_medicaid=p_medicaid10;
else if p_medicaid10=. and p_medicaid11 ne . then p_medicaid=p_medicaid11;
else if p_medicaid10=. and p_medicaid11=. and p_medicaid12 ne . then p_medicaid=p_medicaid12;
else if p_medicaid10=. and p_medicaid11=. and p_medicaid12=. and p_medicaid09 ne . then p_medicaid=p_medicaid09;


t=substr(medicare_id,3,4)*1;
if t>=1 and t<=879 then type='Short-term (general and specialty) hospitals';
if t>=1300 and t<=1399 then type='Critical Access Hospitals (CAH)';
if t>=1500 and t<=1799 then type='Hospices';
if t>=2000 and t<=2299 then type='Long-term hospitals';
if t>=3025 and t<=3099 then type='Rehabilitation hospitals';
if t>=3300 and t<=3399 then type='Children hospitals';
if t>=4000 and t<=4499 then type='Psychiatric hospitals';
if t>=5000 and t<=6499 then type='Skilled Nursing Facilities';
if t>=7000 and t<=7299 then type='Home Health Agencies';
run;
proc freq data=denominator;tables type;run;
 

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
data impact2013;
set impact.impact2013;
provider=provider_number*1;
rename provider=provider_number;rename dshpct=dshpct2013;
keep provider  dshpct;
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

proc format;
value $serv_
10='General medical and surgical'
11='Hospital unit of an institution (prison hospital, college infirmary, etc.)'
12='Hospital unit within an institution for the mentally retarded'
13='Surgical'
22='Psychiatric'
33='Tuberculosis and other respiratory diseases'
41='Cancer'
42='Heart'
44='Obstetrics and gynecology'
45='Eye, ear, nose and throat'
46='Rehabilitation'
47='Orthopedic'
48='Chronic disease'
49='Other specialty'
50='Children general'
51='Children hospital unit of an institution'
52='Children psychiatric'
53='Children tuberculosis and other respiratory diseases'
55='Children eye, ear, nose and throat'
56='Children rehabilitation'
57='Children orthopedic'
58='Children chronic disease'
59='Children other specialty'
62='Institution for mental retardation'
80='Acute Long-Term Care'
82='Alcoholism and other chemical dependency'
90='Children acute long-term'
;
run;

* Acute Care hospitals only;
data aha12;
set aha.aha12;
t=substr(provider,3,4)*1;
if t>=1 and t<=879 then type='Short-term (general and specialty) hospitals';
if t>=1300 and t<=1399 then type='Critical Access Hospitals (CAH)';
if t>=1500 and t<=1799 then type='Hospices';
if t>=2000 and t<=2299 then type='Long-term hospitals';
if t>=3025 and t<=3099 then type='Rehabilitation hospitals';
if t>=3300 and t<=3399 then type='Children hospitals';
if t>=4000 and t<=4499 then type='Psychiatric hospitals';
if t>=5000 and t<=6499 then type='Skilled Nursing Facilities';
if t>=7000 and t<=7299 then type='Home Health Agencies';

if hosp_reg4 ne '5' and profit2 ne '4';
provider_number=provider*1;
keep provider provider_number serv t type dshpct2012;
run;

proc freq data=aha12;format serv $serv_.;tables type*serv;run;

data GA;
set aha12;
if type='Short-term (general and specialty) hospitals';
run;

proc sql;
create table temp as
select a.*,b.DSHpct2008
from GA a left join impact2008 b
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
create table temp5 as
select a.*,b.DSHpct2013
from temp4 a left join impact2013 b
on a.provider_number=b.provider_number;
quit;
proc sql;
create table temp6 as
select a.*,b.DSHpct2014
from temp5 a left join impact2014 b
on a.provider_number=b.provider_number;
quit;
proc sql;
create table temp7 as
select a.*,b.DSHpct2015
from temp6 a left join impact2015 b
on a.provider_number=b.provider_number;
quit;


proc sql;
create table temp8 as
select a.*,b.DSHpct2012 as ahadshpct
from temp7 a left join aha12 b
on a.provider_number=b.provider_number;
quit;

data temp9;
set temp8;
if dshpct2015 ne . then dshpct=dshpct2015;
else if dshpct2015=. and dshpct2014 ne . then dshpct=dshpct2014;
else if dshpct2015=. and dshpct2014=. and dshpct2013 ne . then dshpct=dshpct2013;
else if dshpct2015=. and dshpct2014=. and dshpct2013=. and dshpct2012 ne . then dshpct=dshpct2012;
else if dshpct2015=. and dshpct2014=. and dshpct2013=. and dshpct2012= . and dshpct2011 ne . then dshpct=dshpct2011;
else if dshpct2015=. and dshpct2014=. and dshpct2013=. and dshpct2012= . and dshpct2011=. and dshpct2010 ne . then dshpct=dshpct2010;
else if dshpct2015=. and dshpct2014=. and dshpct2013=. and dshpct2012= . and dshpct2011=. and dshpct2010=. and dshpct2009 ne . then dshpct=dshpct2009;
else if dshpct2015=. and dshpct2014=. and dshpct2013=. and dshpct2012= . and dshpct2011=. and dshpct2010=. and dshpct2009=. and dshpct2008 ne . then dshpct=dshpct2008;
run;
 
 
*******************Get the cutpoint of top25%;
proc means data=temp9 min q1 median mean q3 max;var dshpct;run;

** cut-point: 0.3559600;

*Rank 3200 general acute hospitals by DSHpct, top 25% as Safety Net hospitals;
proc rank data=temp9 out=AHA_DSH_rank   percent;
var DSHpct;
ranks DSHpct_Rank;
run;

proc sort data=AHA_DSH_rank ;by descending DSHpct_Rank;run;

data AHA_DSH_rank;
set AHA_DSH_rank;
if DSHpct_Rank>=75 then SNH=1;else SNH=0;
run;

 


***********Merge Survey sample to General Acute Care hospitals with corresponding HSDpct 2012;
proc sql;
create table denominator_char as
select a.*,b.dshpct,b.SNH
from denominator a left join AHA_DSH_rank b
on a.medicare_id=b.provider;
quit;

proc freq data=denominator_char;tables SNH;run;

data denominator_char;
set denominator_char;
if cicu='3' then cicu='';
run;












 


*************************Output Char Tables;
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
value $CICU_
1='Hospital has CICU'
0='Hospital has NO CICU'
;
run;
proc format ;
value SNH_
1='Safety Net Hospital'
0='Not'
;
run;

proc freq data=denominator_char;
where respond=1;format teaching teaching_.;
tables teaching*group/chisq norow nopercent;
run;
proc freq data=denominator_char;
where respond=1;format profit2 profit2_.;
tables profit2*group/chisq norow nopercent;
run;
proc freq data=denominator_char;
where respond=1;format hospsize hospsize_.;
tables hospsize*group/chisq norow nopercent;
run;
proc freq data=denominator_char;
where respond=1;format hosp_reg4 hosp_reg4_.;
tables hosp_reg4*group/chisq norow nopercent;
run;
proc freq data=denominator_char;
where respond=1;format ruca_level ruca_level_.;
tables ruca_level*group/chisq norow nopercent;
run;
proc freq data=denominator_char;
where respond=1;format CICU $CICU_.;
tables CICU*group/chisq norow nopercent;
run;
proc freq data=denominator_char;
where respond=1;format SNH SNH_.;
tables SNH*group/chisq norow nopercent;
run;


proc means data=denominator_char;
where respond=1;
class group;
var black  ;
run;
proc anova data=denominator_char;
where respond=1;
class group;
model black=group;
run;
proc means data=denominator_char;
where respond=1;
class group;
var  hisp  ;
run;
proc anova data=denominator_char;
where respond=1;
class group;
model hisp=group;
run;
proc means data=denominator_char;
where respond=1;
class group;
var p_medicare;
run;
proc anova data=denominator_char;
where respond=1;
class group;
model p_medicare=group;
run;
proc means data=denominator_char;
where respond=1;
class group;
var p_medicaid;
run;
proc anova data=denominator_char;
where respond=1;
class group;
model p_medicaid=group;
run;

proc freq data=denominator_char;where respond=1;tables group;run;








*Responder vs non-Responder;
proc freq data=denominator_char;tables respond;run;
  

proc freq data=denominator_char;
format teaching teaching_.;
tables teaching*respond/chisq norow nopercent;
run;
proc freq data=denominator_char;
format profit2 profit2_.;
tables profit2*respond/chisq norow nopercent;
run;
proc freq data=denominator_char;
format hospsize hospsize_.;
tables hospsize*respond/chisq norow nopercent;
run;
proc freq data=denominator_char;
format hosp_reg4 hosp_reg4_.;
tables hosp_reg4*respond/chisq norow nopercent;
run;
proc freq data=denominator_char;
format ruca_level ruca_level_.;
tables ruca_level*respond/chisq norow nopercent;
run;
proc freq data=denominator_char;
format CICU $CICU_.;
tables CICU*respond/chisq norow nopercent;
run;
proc freq data=denominator_char;
format SNH SNH_.;
tables SNH*respond/chisq norow nopercent;
run;


proc means data=denominator_char;
class respond;
var black  ;
run;
proc anova data=denominator_char;
class respond;
model black=respond;
run;
proc means data=denominator_char;
class respond;
var  hisp  ;
run;
proc anova data=denominator_char;
class respond;
model hisp=respond;
run;
proc means data=denominator_char;
class respond;
var p_medicare;
run;
proc anova data=denominator_char;
class respond;
model p_medicare=respond;
run;
proc means data=denominator_char;
class respond;
var p_medicaid;
run;
proc anova data=denominator_char;
class respond;
model p_medicaid=respond;
run;












**************************Compare SNH;
proc freq data=denominator_char;
where respond=1;
tables SNH;
run;

%macro Q7(q=);

data temp3;
set denominator_char;
where respond=1;
if &q. in (1,2) then temp='Always or Usual';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*SNH/chisq norow nopercent;run;
 
%mend Q7;
%Q7(q=q7a);
%Q7(q=q7b);
%Q7(q=q7c);
%Q7(q=q7d);
%Q7(q=q7e);
%Q7(q=q7f);
%Q7(q=q7g);
%Q7(q=q7h);
%Q7(q=q7i);
%Q7(q=q7j);
%Q7(q=q7k);
%Q7(q=q7l);
%Q7(q=q7m);


%macro Q12(q=);

data temp3;
set  denominator_char;
if &q. in (4,5) then temp='4+Great challenge';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*SNH/chisq norow nopercent;run;

%mend Q12;
%Q12(q=q12a);
%Q12(q=q12b);
%Q12(q=q12c);
%Q12(q=q12d);
%Q12(q=q12e);
%Q12(q=q12f);
%Q12(q=q12g);
%Q12(q=q12h);

%macro Q13(q=);

data temp3;
set  denominator_char;
if &q. in (4,5) then temp='4+Great challenge';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*SNH/chisq norow nopercent;run;

%mend Q13;
%Q13(q=q13a);
%Q13(q=q13b);

%macro Q14(q=);
data temp3;
set  denominator_char;
if &q. in (4,5) then temp='4+Great challenge';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*SNH/chisq norow nopercent;run;
%mend Q14;
%Q14(q=q14a);
%Q14(q=q14b);
%Q14(q=q14c);
%Q14(q=q14d);

%macro Q15(q=);
data temp3;
set  denominator_char;
if &q. in (4,5) then temp='4+Great challenge';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*SNH/chisq norow nopercent;run;
%mend Q15;
%Q15(q=q15a);
%Q15(q=q15b);
%Q15(q=q15c);
%Q15(q=q15d);


%macro Q18(q=);
data temp3;
set  denominator_char;
if &q. in (4,5) then temp='4+Great Impact';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*SNH/chisq norow nopercent;run;

%mend Q18;
%Q18(q=q18a);
%Q18(q=q18b);
%Q18(q=q18c);















*************%Hispanic;
proc sort data=denominator_char;by descending hisp;run;

data denominator_char;
set denominator_char;
if _n_<=360 then hisp_group="Top Hispanic";
else hisp_group="Others";
run;

proc means data=denominator_char min max mean;class hisp_group;var hisp;run;
proc freq data=denominator_char;tables respond*hisp_group/norow nopercent;run;

%macro Q12(q=);

data temp3;
set  denominator_char;
if &q. ne .;
if &q. in (4,5) then temp='4+Great challenge';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*hisp_group/chisq norow nopercent;run;

%mend Q12;
%Q12(q=q12a);
%Q12(q=q12b);
%Q12(q=q12c);
%Q12(q=q12d);
%Q12(q=q12e);
%Q12(q=q12f);
%Q12(q=q12g);
%Q12(q=q12h);

%macro Q13(q=);

data temp3;
set  denominator_char;
if &q. ne .;
if &q. in (4,5) then temp='4+Great challenge';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*hisp_group/chisq norow nopercent;run;

%mend Q13;
%Q13(q=q13a);
%Q13(q=q13b);

%macro Q14(q=);
data temp3;
set  denominator_char;
if &q. ne .;
if &q. in (4,5) then temp='4+Great challenge';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*hisp_group/chisq norow nopercent;run;
%mend Q14;
%Q14(q=q14a);
%Q14(q=q14b);
%Q14(q=q14c);
%Q14(q=q14d);

%macro Q15(q=);
data temp3;
set  denominator_char;
if &q. ne .;
if &q. in (4,5) then temp='4+Great challenge';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*hisp_group/chisq norow nopercent;run;
%mend Q15;
%Q15(q=q15a);
%Q15(q=q15b);
%Q15(q=q15c);
%Q15(q=q15d);


%macro Q7(q=);

data temp3;
set denominator_char;
where respond=1;
if &q. in (1,2) then temp='Always or Usual';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*hisp_group/chisq norow nopercent;run;
 
%mend Q7;
%Q7(q=q7a);
%Q7(q=q7b);
%Q7(q=q7c);
%Q7(q=q7d);
%Q7(q=q7e);
%Q7(q=q7f);
%Q7(q=q7g);
%Q7(q=q7h);
%Q7(q=q7i);
%Q7(q=q7j);
%Q7(q=q7k);
%Q7(q=q7l);
%Q7(q=q7m);

 









 
