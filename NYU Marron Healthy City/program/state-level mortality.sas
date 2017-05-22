*****************************************
State-Level Health care quality ranking--Mortalty
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
Hospital Level: 30-day all-cause AMI mortality rate and Stroke mortality rate
*/

%macro mort(year);
* ND: Number of Discharge;
proc sql;
create table temp1 as
select a.provider,b.zip, a.NDmortmeas_amiAll as Dis_AMI, a.NDmortmeas_strokeAll as Dis_Stroke,a.NDmortmeas_amiAll*a.rawmortmeas_amiAll30day as AMIdeath, a.NDmortmeas_strokeAll*a.rawmortmeas_strokeAll30day as Strokedeath
from (select provider, NDmortmeas_amiAll, rawmortmeas_amiAll30day, NDmortmeas_strokeAll, rawmortmeas_strokeAll30day from mort.adjmort37meas30day&year.) a inner join (select provider, zip  from aha.aha12) b
on a.provider=b.provider;
quit;

* Zip and 50 State Cross Walk;
proc sort data=zip(keep=zip state) nodupkey;by zip state;run;
proc sql;
create table state50 as
select a.*,b.name, b.region
from zip a inner join statelist b
on a.state=b.state;
quit;

* merge mortality with state level zip;
proc sql;
create table temp2 as
select *
from temp1 a inner join state50 b
on a.zip=b.zip;
quit;


* Aggregate mortality;
proc sql;
create table mortality&year. as
select distinct state, name,region, sum(AMIdeath)/sum(Dis_AMI) as AMI&year. format percent9.2, sum(Strokedeath)/sum(Dis_Stroke) as Stroke&year. format percent9.2
from temp2
group by state;
quit;
%mend mort;

%mort(02);
%mort(03);
%mort(04);
%mort(05);
%mort(06);
%mort(07);
%mort(08);
%mort(09);
%mort(10);
%mort(11);
%mort(12);

********* Longitudinal Output;

data ami;
merge mortality02 mortality03 mortality04 mortality05 mortality06  
      mortality07 mortality08 mortality09 mortality10 mortality11 mortality12 ;
	  by state;
	  keep state name region ami02 ami03 ami04 ami05 ami06 ami07 ami08 ami09 ami10 ami11 ami12;
run;
 

data stroke;
merge mortality02 mortality03 mortality04 mortality05 mortality06  
      mortality07 mortality08 mortality09 mortality10 mortality11 mortality12 ;
	  by state;
	  keep state name region stroke02 stroke03 stroke04 stroke05 stroke06 stroke07 stroke08 stroke09 stroke10 stroke11 stroke12;
run;
 
***** Two years composite/combined;
data ami;
set ami;
score=(ami11+ami12)/2;
format score percent9.2;
run;
data stroke;
set stroke;
score=(stroke11+stroke12)/2;
format score percent9.2;
run;

 

* Ranking;
proc rank data=ami out=ami_rank ;
var score;
ranks score_rank;
run;
proc rank data=stroke out=stroke_rank ;
var score;
ranks score_rank;
run;
 



**********Graphical Display;
data graph_ami;
set ami_rank;
ami=ami02;year=2002;output;
ami=ami03;year=2003;output;
ami=ami04;year=2004;output;
ami=ami05;year=2005;output;
ami=ami06;year=2006;output;
ami=ami07;year=2007;output;
ami=ami08;year=2008;output;
ami=ami09;year=2009;output;
ami=ami10;year=2010;output;
ami=ami11;year=2011;output;
ami=ami12;year=2012;output;
keep name state region ami year;
run;

proc sgplot data=graph_ami;
title "Northest Region States AMI Mortality";
where region="Northeast";
series x=year y=ami/group=state ;
run;
proc sgplot data=graph_ami;
title "Midwest Region States AMI Mortality";
where region="Midwest";
series x=year y=ami/group=state ;
run;
proc sgplot data=graph_ami;
title "South Region States AMI Mortality";
where region="South";
series x=year y=ami/group=state ;
run;
proc sgplot data=graph_ami;
title "West Region States AMI Mortality";
where region="West";
series x=year y=ami/group=state ;
run;


data graph_stroke;
set stroke_rank;
stroke=stroke02;year=2002;output;
stroke=stroke03;year=2003;output;
stroke=stroke04;year=2004;output;
stroke=stroke05;year=2005;output;
stroke=stroke06;year=2006;output;
stroke=stroke07;year=2007;output;
stroke=stroke08;year=2008;output;
stroke=stroke09;year=2009;output;
stroke=stroke10;year=2010;output;
stroke=stroke11;year=2011;output;
stroke=stroke12;year=2012;output;
keep name state region stroke year;
run;

proc sgplot data=graph_stroke;
title "Northest Region States Stroke Mortality";
where region="Northeast";
series x=year y=stroke/group=state ;
run;
proc sgplot data=graph_stroke;
title "Midwest Region States AMI Mortality";
where region="Midwest";
series x=year y=stroke/group=state ;
run;
proc sgplot data=graph_stroke;
title "South Region States AMI Mortality";
where region="South";
series x=year y=stroke/group=state ;
run;
proc sgplot data=graph_stroke;
title "West Region States AMI Mortality";
where region="West";
series x=year y=stroke/group=state ;
run;



 



 
