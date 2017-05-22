*****************************************
State-Level Health care quality ranking-- HCAHPS
Xiner Zhou
7/28/2014
*****************************************;


libname marron 'C:\data\Projects\Marron\Archive';
libname aha 'C:\data\Data\Hospital\AHA\Annual_Survey\Data';
libname hcahps 'C:\data\Data\Hospital\Archive\HQA';
libname hrr 'C:\data\Data\Dartmouth_Atlas\ZIP_HSA_HRR_XWalk';* ZIP_HSA_HRR has city and state names;
 
/*
HCAHPS is hospital-level rating
assign hospital according to ZIP to City
just merge HCAHPS with AHA to get ZIP, and then merge with CITY_BY_ZIP
*/

* HCAHPS has more accurate State than Zip;

%macro hcahps(year);
proc sql;
create table temp1 as
select *
from (select provider, hosprate3,state from hcahps.hcahps20&year.) a left join (select provider, dsg_tot&year.  from aha.aha&year.) b
on a.provider=b.provider 
where hosprate3 ne . ; 
quit;

proc sql;
create table temp&year. as
select distinct state, round(sum(hosprate3*dsg_tot&year.)/(sum(dsg_tot&year.)*100),0.01)as hcahps&year. format percent9.1
from temp1
group by state;
quit;

%mend hcahps;
%hcahps(11);
%hcahps(10);
%hcahps(09);

* 2008;
proc sql;
create table temp1 as
select *
from (select provider, hosprate3 from hcahps.hcahps2008) a left join (select provider, dsg_tot08, mstate from aha.aha08) b
on a.provider=b.provider 
where hosprate3 ne . ; 
quit;

proc sql;
create table temp08 as
select distinct mstate, round(sum(hosprate3*dsg_tot08)/(sum(dsg_tot08)*100),0.01)as hcahps08 format percent9.1
from temp1
group by mstate;
quit;


* 2007;
proc sql;
create table temp1 as
select *
from (select provider, hosprate3 from hcahps.hcahps2007) a left join (select provider, dsg_tot07, mstate from aha.aha07) b
on a.provider=b.provider 
where hosprate3 ne . ; 
quit;

proc sql;
create table temp07 as
select distinct mstate, round(sum(hosprate3*dsg_tot07)/(sum(dsg_tot07)*100),0.01)as hcahps07 format percent9.1
from temp1
group by mstate;
quit;

proc sql;
create table temp1 as
select *
from temp07 a join temp08 b
on a.mstate=b.mstate;
quit;
proc sql;
create table temp2 as
select a.hcahps07, a.hcahps08, b.*
from temp1 a join temp09 b
on a.mstate=b.state;
quit;
proc sql;
create table temp3 as
select *
from temp2 a join temp10 b
on a.state=b.state;
quit;
proc sql;
create table hcahps as
select *
from temp3 a join temp11 b
on a.state=b.state;
quit;


** Longitudinal table output;
proc sql;
create table out as
select a.name,a.state,a.region,b.hcahps07,b.hcahps08,b.hcahps09,b.hcahps10,b.hcahps11
from statelist a left join hcahps b
on a.state=b.state;
quit;



** Longitudinal Graphical Display;
data graph;
set out;
hcahps=hcahps07;year=2007;output;
hcahps=hcahps08;year=2008;output;
hcahps=hcahps09;year=2009;output;
hcahps=hcahps10;year=2010;output;
hcahps=hcahps11;year=2011;output;
keep name state region hcahps year;
run;

proc sgplot data=graph;
title "Northest Region States HCAHPS";
where region="Northeast";
series x=year y=hcahps/group=state ;
run;
proc sgplot data=graph;
title "Midwest Region States HCAHPS";
where region="Midwest";
series x=year y=hcahps/group=state ;
run;
proc sgplot data=graph;
title "South Region States HCAHPS";
where region="South";
series x=year y=hcahps/group=state ;
run;
proc sgplot data=graph;
title "West Region States HCAHPS";
where region="West";
series x=year y=hcahps/group=state ;
run;


****************Two years composite/combined scores;
data out;
set out;
score=(hcahps11+hcahps10)/2;
format score percent9.1;
label score="2010&2011 Average HCAHPS";
run;


* Ranking;
proc rank data=out out=out_rank descending ties=low;
var score;
ranks score_rank;
run;
 


 
