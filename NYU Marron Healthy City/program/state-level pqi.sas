*****************************************
State-Level Health care quality ranking-- PQI
Xiner Zhou
7/28/2014
*****************************************;



libname aha 'C:\data\Data\Hospital\AHA\Annual_Survey\Data';
libname hcahps 'C:\data\Data\Hospital\Archive\HQA';
libname hrr 'C:\data\Data\Dartmouth_Atlas\ZIP_HSA_HRR_XWalk';* ZIP_HSA_HRR has city and state names;
libname PQI 'C:\data\Projects\Scorecard\data';
libname medicare 'C:\data\Data\Medicare\Denominator';
libname mort  'C:\data\Data\Hospital\Medicare_Inpt\Mortality\data';

/*
Strategy:

pqi_inptall2011 has every Medicare Inpatient/Discharge--Numerator
Denominator is total Medicare population in 2011
PQI is based on patient residence, not HRR, so just need the zip in pqi_inptall2011
just group zip by city

2011:pqi_inptall2011
2010:Pqi_medpar2010v45
2009:Pqi_medpar2009v45
2008:Pqi_medpar2008v45
2007:Pqi_medpar2007v45
2006:Pqi_medpar2006v45
2005:Pqi_medpar2005v45
*/


%macro pqi(year,file1,file2);

data temp1;
set pqi.&file1. ;
where bene_zip ~= '';
keep bene_id bene_zip tapq90 tapq91 tapq92;
run;
 
* merge pqi with state level zip;
proc sql;
create table temp2 as
select *
from temp1 a  inner join state50 b
on a.bene_zip =b.zip;
quit;
* Combines and displays only the rows from the first table that match rows from the second table ;
 


* Numerator by State;
proc sql;
create table numerator as
select distinct state, sum(tapq90) as overall, sum(tapq91) as acute, sum(tapq92) as chronic 
from temp2
group by state;
quit;

* Denominator by State;
data temp3;
set medicare.&file2.;
zip=substr(bene_zip,1,5) ;
keep bene_id zip;
run;

proc sql;
create table temp4 as
select *
from temp3 a  inner join state50 b
on a.zip =b.zip;
quit;

proc sql;
create table denominator as
select distinct state, name, region, count(bene_id) as denominator
from temp4
group by state;
quit;


* Merge numerator and denominator;
proc sql;
create table pqi&year. as
select a.state,b.name,b.region,b.denominator as Medicare_Population,round((a.overall/b.denominator)*100000,1) as overall&year.,round((a.acute/b.denominator)*100000,1) as acute&year.,
round((a.chronic/b.denominator)*100000,1) as chronic&year.
from numerator a inner join denominator b
on a.state=b.state;
quit;

%mend pqi;
%pqi(11,pqi_inptall2011,Dnmntr2011);
%pqi(10,Pqi_medpar2010v45,dnmntr2010);
%pqi(09,Pqi_medpar2009v45,dnmntr2009);
%pqi(08,Pqi_medpar2008v45,dnmntr2008);
%pqi(07,Pqi_medpar2007v45,dnmntr2007);
%pqi(06,Pqi_medpar2006v45,dnmntr2006);
%pqi(05,Pqi_medpar2005v45,dnmntr2005);

******** Longitudinal Output;
data overall_PQI;
merge pqi05 pqi06 pqi07 pqi08 pqi09 pqi10 pqi11 ;
by state;
score=(overall10+overall11)/2;
keep state name region overall05 overall06 overall07 overall08 overall09 overall10 overall11 score;
run;
data acute_PQI;
merge pqi05 pqi06 pqi07 pqi08 pqi09 pqi10 pqi11  ;
by state;
score=(acute10+acute11)/2;
keep state name region acute05 acute06 acute07 acute08 acute09 acute10 acute11 score;
run;
data chronic_PQI;
merge pqi05 pqi06 pqi07 pqi08 pqi09 pqi10 pqi11 ;
by state;
score=(chronic10+chronic11)/2;
keep state name region chronic05 chronic06 chronic07 chronic08 chronic09 chronic10 chronic11 score;
run;
 

* Rank;
proc rank data=overall_PQI out=overall_PQI_rank descending ties=low;
var score;
ranks score_rank;
run;
proc rank data=acute_PQI out=acute_PQI_rank descending ties=low;
var score;
ranks score_rank;
run;
proc rank data=chronic_PQI out=chronic_PQI_rank descending ties=low;
var score;
ranks score_rank;
run;







**********Graphical Display;
%macro graph(var);

data graph;
set &var._PQI;
&var.=&var.05;year=2005;output;
&var.=&var.06;year=2006;output;
&var.=&var.07;year=2007;output;
&var.=&var.08;year=2008;output;
&var.=&var.09;year=2009;output;
&var.=&var.10;year=2010;output;
&var.=&var.11;year=2011;output;
keep name state region &var. year;
run;

proc sgplot data=graph;
title "Northest Region States &var. PQI";
where region="Northeast";
series x=year y=&var./group=state ;
run;
proc sgplot data=graph;
title "Midwest Region States &var. PQI";
where region="Midwest";
series x=year y=&var./group=state ;
run;
proc sgplot data=graph;
title "South Region States &var. PQI";
where region="South";
series x=year y=&var./group=state ;
run;
proc sgplot data=graph;
title "West Region States &var. PQI";
where region="West";
series x=year y=&var./group=state ;
run;

%mend graph;
%graph(overall);
%graph(acute);
%graph(chronic);





 
