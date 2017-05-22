**********************************
Top diagnoses/Admission Reasons + Top Drugs
Xiner Zhou
4/28/2017
*********************************;
libname data 'D:\Projects\High Cost Segmentation Phase II\Data';
libname ip 'D:\data\Medicare\Inpatient';
libname partD 'D:\data\Medicare\PartD';
libname stdcost 'D:\Data\Medicare\StdCost\Data';

***********************
Rank admission reasons
***********************;
data ip;
set stdcost.Ipclmsstdcost2012(in=in1) stdcost.Ipclmsstdcost2013(in=in2) stdcost.Ipclmsstdcost2014(in=in3);
if in1 then year=2012;
if in2 then year=2013;
if in3 then year=2014;
keep bene_id DRG_CD stdcost year;
run;

proc sql;
create table temp1 as
select a.bene_id, a.group, b.*
from data.PlanABene a inner join ip  b
on a.bene_id=b.bene_id;
quit;

proc import datafile="D:\Projects\APCD High Cost\Archieve\DRG" 
dbms=xls  out=DRG replace;getnames=yes;run;

proc sql;
create table temp2 as
select a.*, b.*
from temp1 a left join DRG  b
on a.DRG_CD=b.MSDRG;
quit;

%macro DRG(group, yr);
proc sort data=temp2 out=temp3; 
where group=&group. and year=&yr. ;
by DRG_CD;
run;

proc sql;
create table temp4 as
select count(*) as totN
from temp3;
quit;

data _null_;
set temp4;
call symput("totN",totN);
run;


proc sql;
create table temp4 as
select DRG_CD, Title, sum(stdcost) as totcost, mean(stdcost) as aveCost, count(*) as N,  symget('totN')  as totN
from temp3 
group by DRG_CD;
quit;

proc sort data=temp4 nodupkey; by DRG_CD;run;

data temp5;
set temp4;
pct=N/totN*1;
if DRG_CD ne '';
drop N totN;
proc sort;
by descending pct;
run;

data temp5;set temp5;if _n_<=15;run;

proc print data=temp5;
title &group.;  
var Title pct aveCost TotCost;
run;
%mend DRG;


ODS Listing CLOSE;
ODS html file="D:\Projects\High Cost Segmentation Phase II\Output\DRG by freq 2012.xls" style=minimal;
%DRG(group="HC HC HC", yr=2012);
%DRG(group="HC HC nonHC", yr=2012);
%DRG(group="HC nonHC HC", yr=2012);
%DRG(group="HC nonHC nonHC", yr=2012);
%DRG(group="nonHC HC HC", yr=2012);
%DRG(group="nonHC HC nonHC", yr=2012);
%DRG(group="nonHC nonHC HC", yr=2012);
%DRG(group="nonHC nonHC nonHC", yr=2012);
 ODS html close;
ODS Listing; 

ODS Listing CLOSE;
ODS html file="D:\Projects\High Cost Segmentation Phase II\Output\DRG by freq 2013.xls" style=minimal;
%DRG(group="HC HC HC", yr=2013);
%DRG(group="HC HC nonHC", yr=2013);
%DRG(group="HC nonHC HC", yr=2013);
%DRG(group="HC nonHC nonHC", yr=2013);
%DRG(group="nonHC HC HC", yr=2013);
%DRG(group="nonHC HC nonHC", yr=2013);
%DRG(group="nonHC nonHC HC", yr=2013);
%DRG(group="nonHC nonHC nonHC", yr=2013);
 ODS html close;
ODS Listing; 

ODS Listing CLOSE;
ODS html file="D:\Projects\High Cost Segmentation Phase II\Output\DRG by freq 2014.xls" style=minimal;
%DRG(group="HC HC HC", yr=2014);
%DRG(group="HC HC nonHC", yr=2014);
%DRG(group="HC nonHC HC", yr=2014);
%DRG(group="HC nonHC nonHC", yr=2014);
%DRG(group="nonHC HC HC", yr=2014);
%DRG(group="nonHC HC nonHC", yr=2014);
%DRG(group="nonHC nonHC HC", yr=2014);
%DRG(group="nonHC nonHC nonHC", yr=2014);
 ODS html close;
ODS Listing; 

%macro DRG(group );
proc sort data=temp2 out=temp3; 
where group=&group.   ;
by DRG_CD;
run;

proc sql;
create table temp4 as
select count(*) as totN
from temp3;
quit;

data _null_;
set temp4;
call symput("totN",totN);
run;


proc sql;
create table temp4 as
select DRG_CD, Title, sum(stdcost) as totcost, mean(stdcost) as aveCost, count(*) as N,  symget('totN')  as totN
from temp3 
group by DRG_CD;
quit;

proc sort data=temp4 nodupkey; by DRG_CD;run;

data temp5;
set temp4;
pct=N/totN*1;
if DRG_CD ne '';
drop N totN;
proc sort;
by descending pct;
run;

data temp5;set temp5;if _n_<=15;run;

proc print data=temp5;
title &group.;  
var Title pct aveCost TotCost;
run;
%mend DRG;


ODS Listing CLOSE;
ODS html file="D:\Projects\High Cost Segmentation Phase II\Output\DRG by freq 3yr.xls" style=minimal;
%DRG(group="HC HC HC" );
%DRG(group="HC HC nonHC" );
%DRG(group="HC nonHC HC" );
%DRG(group="HC nonHC nonHC" );
%DRG(group="nonHC HC HC" );
%DRG(group="nonHC HC nonHC" );
%DRG(group="nonHC nonHC HC" );
%DRG(group="nonHC nonHC nonHC" );
 ODS html close;
ODS Listing; 

















%macro DRG(group, yr);
proc sort data=temp2 out=temp3; 
where group=&group. and year=&yr. ;
by DRG_CD;
run;

proc sql;
create table temp4 as
select sum(stdcost) as tot 
from temp3;
quit;

data _null_;
set temp4;
call symput("tot",tot);
run;


proc sql;
create table temp4 as
select DRG_CD, Title, sum(stdcost) as totcost, mean(stdcost) as aveCost, symget('tot')  as tot
from temp3 
group by DRG_CD;
quit;

proc sort data=temp4 nodupkey; by DRG_CD;run;

data temp5;
set temp4;
costpct=totcost/tot*1;
if DRG_CD ne '';
drop  tot ;
proc sort;
by descending costpct;
run;

data temp5;set temp5;if _n_<=15;run;

proc print data=temp5;
title &group.;  
var Title costpct aveCost TotCost;
run;
%mend DRG;


ODS Listing CLOSE;
ODS html file="D:\Projects\High Cost Segmentation Phase II\Output\DRG by pct 2012.xls" style=minimal;
%DRG(group="HC HC HC", yr=2012);
%DRG(group="HC HC nonHC", yr=2012);
%DRG(group="HC nonHC HC", yr=2012);
%DRG(group="HC nonHC nonHC", yr=2012);
%DRG(group="nonHC HC HC", yr=2012);
%DRG(group="nonHC HC nonHC", yr=2012);
%DRG(group="nonHC nonHC HC", yr=2012);
%DRG(group="nonHC nonHC nonHC", yr=2012);
 ODS html close;
ODS Listing; 

ODS Listing CLOSE;
ODS html file="D:\Projects\High Cost Segmentation Phase II\Output\DRG by pct 2013.xls" style=minimal;
%DRG(group="HC HC HC", yr=2013);
%DRG(group="HC HC nonHC", yr=2013);
%DRG(group="HC nonHC HC", yr=2013);
%DRG(group="HC nonHC nonHC", yr=2013);
%DRG(group="nonHC HC HC", yr=2013);
%DRG(group="nonHC HC nonHC", yr=2013);
%DRG(group="nonHC nonHC HC", yr=2013);
%DRG(group="nonHC nonHC nonHC", yr=2013);
 ODS html close;
ODS Listing; 

ODS Listing CLOSE;
ODS html file="D:\Projects\High Cost Segmentation Phase II\Output\DRG by pct 2014.xls" style=minimal;
%DRG(group="HC HC HC", yr=2014);
%DRG(group="HC HC nonHC", yr=2014);
%DRG(group="HC nonHC HC", yr=2014);
%DRG(group="HC nonHC nonHC", yr=2014);
%DRG(group="nonHC HC HC", yr=2014);
%DRG(group="nonHC HC nonHC", yr=2014);
%DRG(group="nonHC nonHC HC", yr=2014);
%DRG(group="nonHC nonHC nonHC", yr=2014);
 ODS html close;
ODS Listing; 



%macro DRG(group );
proc sort data=temp2 out=temp3; 
where group=&group.  ;
by DRG_CD;
run;

proc sql;
create table temp4 as
select sum(stdcost) as tot 
from temp3;
quit;

data _null_;
set temp4;
call symput("tot",tot);
run;


proc sql;
create table temp4 as
select DRG_CD, Title, sum(stdcost) as totcost, mean(stdcost) as aveCost, symget('tot')  as tot
from temp3 
group by DRG_CD;
quit;

proc sort data=temp4 nodupkey; by DRG_CD;run;

data temp5;
set temp4;
costpct=totcost/tot*1;
if DRG_CD ne '';
drop  tot ;
proc sort;
by descending costpct;
run;

data temp5;set temp5;if _n_<=15;run;

proc print data=temp5;
title &group.;  
var Title costpct aveCost TotCost;
run;
%mend DRG;
ODS Listing CLOSE;
ODS html file="D:\Projects\High Cost Segmentation Phase II\Output\DRG by pct 3yr.xls" style=minimal;
%DRG(group="HC HC HC" );
%DRG(group="HC HC nonHC" );
%DRG(group="HC nonHC HC" );
%DRG(group="HC nonHC nonHC" );
%DRG(group="nonHC HC HC" );
%DRG(group="nonHC HC nonHC" );
%DRG(group="nonHC nonHC HC");
%DRG(group="nonHC nonHC nonHC" );
 ODS html close;
ODS Listing; 























 



***********************
Rank Drug
***********************;
data partD;
set partD.Pdesaf2012(in=in1) partD.Pdesaf2013(in=in2) partD.Pdesaf2014(in=in3);
if in1 then year=2012;
if in2 then year=2013;
if in3 then year=2014;
rename PRDSRVID=NDC;rename TOTALCST=stdcost;
keep bene_id PRDSRVID TOTALCST year;
run;

proc sql;
create table temp1 as
select a.bene_id, a.group, b.*
from data.PlanABene a inner join partD  b
on a.bene_id=b.bene_id;
quit;

data temp1;
set temp1;
NDC1=NDC*1;
run;

proc import datafile="D:\Projects\APCD High Cost\NDC" 
dbms=xlsx  out=NDC replace;getnames=yes;run;

proc sql;
create table temp2 as
select a.*, b.*
from temp1 a left join NDC  b
on a.NDC1=b.NDC;
quit;

%macro Drug(group, yr);
proc sort data=temp2 out=temp3; 
where group=&group. and year=&yr. ;
by VA_class;
run;

proc sql;
create table temp4 as
select count(*) as totN
from temp3;
quit;

data _null_;
set temp4;
call symput("totN",totN);
run;


proc sql;
create table temp4 as
select VA_class, sum(stdcost) as totcost, mean(stdcost) as aveCost, count(*) as N,  symget('totN')  as totN
from temp3 
group by VA_class;
quit;

proc sort data=temp4 nodupkey; by VA_class;run;

data temp5;
set temp4;
pct=N/totN*1;
if VA_class ne '';
drop N totN;
proc sort;
by descending pct;
run;

data temp5;set temp5;if _n_<=15;run;

proc print data=temp5;
title &group.;  
var VA_class pct aveCost TotCost;
run;
%mend Drug;


ODS Listing CLOSE;
ODS html file="D:\Projects\High Cost Segmentation Phase II\Output\Drug by freq 2012.xls" style=minimal;
%Drug(group="HC HC HC", yr=2012);
%Drug(group="HC HC nonHC", yr=2012);
%Drug(group="HC nonHC HC", yr=2012);
%Drug(group="HC nonHC nonHC", yr=2012);
%Drug(group="nonHC HC HC", yr=2012);
%Drug(group="nonHC HC nonHC", yr=2012);
%Drug(group="nonHC nonHC HC", yr=2012);
%Drug(group="nonHC nonHC nonHC", yr=2012);
 ODS html close;
ODS Listing; 

ODS Listing CLOSE;
ODS html file="D:\Projects\High Cost Segmentation Phase II\Output\Drug by freq 2013.xls" style=minimal;
%Drug(group="HC HC HC", yr=2013);
%Drug(group="HC HC nonHC", yr=2013);
%Drug(group="HC nonHC HC", yr=2013);
%Drug(group="HC nonHC nonHC", yr=2013);
%Drug(group="nonHC HC HC", yr=2013);
%Drug(group="nonHC HC nonHC", yr=2013);
%Drug(group="nonHC nonHC HC", yr=2013);
%Drug(group="nonHC nonHC nonHC", yr=2013);
 ODS html close;
ODS Listing; 

ODS Listing CLOSE;
ODS html file="D:\Projects\High Cost Segmentation Phase II\Output\Drug by freq 2014.xls" style=minimal;
%Drug(group="HC HC HC", yr=2014);
%Drug(group="HC HC nonHC", yr=2014);
%Drug(group="HC nonHC HC", yr=2014);
%Drug(group="HC nonHC nonHC", yr=2014);
%Drug(group="nonHC HC HC", yr=2014);
%Drug(group="nonHC HC nonHC", yr=2014);
%Drug(group="nonHC nonHC HC", yr=2014);
%Drug(group="nonHC nonHC nonHC", yr=2014);
 ODS html close;
ODS Listing; 

%macro Drug(group );
proc sort data=temp2 out=temp3; 
where group=&group.   ;
by VA_Class;
run;

proc sql;
create table temp4 as
select count(*) as totN
from temp3;
quit;

data _null_;
set temp4;
call symput("totN",totN);
run;


proc sql;
create table temp4 as
select VA_Class,  sum(stdcost) as totcost, mean(stdcost) as aveCost, count(*) as N,  symget('totN')  as totN
from temp3 
group by VA_Class;
quit;

proc sort data=temp4 nodupkey; by VA_Class;run;

data temp5;
set temp4;
pct=N/totN*1;
if VA_Class ne '';
drop N totN;
proc sort;
by descending pct;
run;

data temp5;set temp5;if _n_<=15;run;

proc print data=temp5;
title &group.;  
var VA_Class pct aveCost TotCost;
run;
%mend Drug;


ODS Listing CLOSE;
ODS html file="D:\Projects\High Cost Segmentation Phase II\Output\Drug by freq 3yr.xls" style=minimal;
%Drug(group="HC HC HC" );
%Drug(group="HC HC nonHC" );
%Drug(group="HC nonHC HC" );
%Drug(group="HC nonHC nonHC" );
%Drug(group="nonHC HC HC" );
%Drug(group="nonHC HC nonHC" );
%Drug(group="nonHC nonHC HC" );
%Drug(group="nonHC nonHC nonHC" );
 ODS html close;
ODS Listing; 

















%macro Drug(group, yr);
proc sort data=temp2 out=temp3; 
where group=&group. and year=&yr. ;
by VA_class;
run;

proc sql;
create table temp4 as
select sum(stdcost) as tot 
from temp3;
quit;

data _null_;
set temp4;
call symput("tot",tot);
run;


proc sql;
create table temp4 as
select VA_class, sum(stdcost) as totcost, mean(stdcost) as aveCost, symget('tot')  as tot
from temp3 
group by VA_class;
quit;

proc sort data=temp4 nodupkey; by VA_class;run;

data temp5;
set temp4;
costpct=totcost/tot*1;
if VA_class ne '';
drop  tot ;
proc sort;
by descending costpct;
run;

data temp5;set temp5;if _n_<=15;run;

proc print data=temp5;
title &group.;  
var VA_class costpct aveCost TotCost;
run;
%mend Drug;


ODS Listing CLOSE;
ODS html file="D:\Projects\High Cost Segmentation Phase II\Output\Drug by pct 2012.xls" style=minimal;
%Drug(group="HC HC HC", yr=2012);
%Drug(group="HC HC nonHC", yr=2012);
%Drug(group="HC nonHC HC", yr=2012);
%Drug(group="HC nonHC nonHC", yr=2012);
%Drug(group="nonHC HC HC", yr=2012);
%Drug(group="nonHC HC nonHC", yr=2012);
%Drug(group="nonHC nonHC HC", yr=2012);
%Drug(group="nonHC nonHC nonHC", yr=2012);
 ODS html close;
ODS Listing; 

ODS Listing CLOSE;
ODS html file="D:\Projects\High Cost Segmentation Phase II\Output\Drug by pct 2013.xls" style=minimal;
%Drug(group="HC HC HC", yr=2013);
%Drug(group="HC HC nonHC", yr=2013);
%Drug(group="HC nonHC HC", yr=2013);
%Drug(group="HC nonHC nonHC", yr=2013);
%Drug(group="nonHC HC HC", yr=2013);
%Drug(group="nonHC HC nonHC", yr=2013);
%Drug(group="nonHC nonHC HC", yr=2013);
%Drug(group="nonHC nonHC nonHC", yr=2013);
 ODS html close;
ODS Listing; 

ODS Listing CLOSE;
ODS html file="D:\Projects\High Cost Segmentation Phase II\Output\Drug by pct 2014.xls" style=minimal;
%Drug(group="HC HC HC", yr=2014);
%Drug(group="HC HC nonHC", yr=2014);
%Drug(group="HC nonHC HC", yr=2014);
%Drug(group="HC nonHC nonHC", yr=2014);
%Drug(group="nonHC HC HC", yr=2014);
%Drug(group="nonHC HC nonHC", yr=2014);
%Drug(group="nonHC nonHC HC", yr=2014);
%Drug(group="nonHC nonHC nonHC", yr=2014);
 ODS html close;
ODS Listing; 



%macro Drug(group );
proc sort data=temp2 out=temp3; 
where group=&group.  ;
by VA_class;
run;

proc sql;
create table temp4 as
select sum(stdcost) as tot 
from temp3;
quit;

data _null_;
set temp4;
call symput("tot",tot);
run;


proc sql;
create table temp4 as
select VA_class, sum(stdcost) as totcost, mean(stdcost) as aveCost, symget('tot')  as tot
from temp3 
group by VA_class;
quit;

proc sort data=temp4 nodupkey; by VA_class;run;

data temp5;
set temp4;
costpct=totcost/tot*1;
if VA_class ne '';
drop  tot ;
proc sort;
by descending costpct;
run;

data temp5;set temp5;if _n_<=15;run;

proc print data=temp5;
title &group.;  
var VA_class costpct aveCost TotCost;
run;
%mend Drug;
ODS Listing CLOSE;
ODS html file="D:\Projects\High Cost Segmentation Phase II\Output\Drug by pct 3yr.xls" style=minimal;
%Drug(group="HC HC HC" );
%Drug(group="HC HC nonHC" );
%Drug(group="HC nonHC HC" );
%Drug(group="HC nonHC nonHC" );
%Drug(group="nonHC HC HC" );
%Drug(group="nonHC HC nonHC" );
%Drug(group="nonHC nonHC HC");
%Drug(group="nonHC nonHC nonHC" );
 ODS html close;
ODS Listing; 
