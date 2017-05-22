**********************************
Top diagnoses/Admission Reasons + Top Drugs
Xiner Zhou
4/28/2017
*********************************;
libname data 'D:\Projects\Peterson\Data';
libname ip 'D:\data\Medicare\Inpatient';
libname medpar 'D:\data\Medicare\MedPAR';
libname stdcost 'D:\Data\Medicare\StdCost\Data';

***********************
Rank admission reasons
***********************;
data Medparsl2008;
set medpar.Medparsl2008 ;
where SSLSSNF in ('L','S');
rename PMT_AMT=stdcost;
keep bene_id DRG_CD PMT_AMT  ;
run;

data ip;
set Medparsl2008(in=in1) stdcost.Ipclmsstdcost2009(in=in2) stdcost.Ipclmsstdcost2010(in=in3);
if in1 then year=2008;
if in2 then year=2009;
if in3 then year=2010;
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
ODS html file="D:\Projects\Peterson\DRG by freq 2008.xls" style=minimal;
%DRG(group="HC HC HC", yr=2008);
%DRG(group="HC HC nonHC", yr=2008);
%DRG(group="HC nonHC HC", yr=2008);
%DRG(group="HC nonHC nonHC", yr=2008);
%DRG(group="nonHC HC HC", yr=2008);
%DRG(group="nonHC HC nonHC", yr=2008);
%DRG(group="nonHC nonHC HC", yr=2008);
%DRG(group="nonHC nonHC nonHC", yr=2008);
 ODS html close;
ODS Listing; 

ODS Listing CLOSE;
ODS html file="D:\Projects\Peterson\DRG by freq 2009.xls" style=minimal;
%DRG(group="HC HC HC", yr=2009);
%DRG(group="HC HC nonHC", yr=2009);
%DRG(group="HC nonHC HC", yr=2009);
%DRG(group="HC nonHC nonHC", yr=2009);
%DRG(group="nonHC HC HC", yr=2009);
%DRG(group="nonHC HC nonHC", yr=2009);
%DRG(group="nonHC nonHC HC", yr=2009);
%DRG(group="nonHC nonHC nonHC", yr=2009);
 ODS html close;
ODS Listing; 

ODS Listing CLOSE;
ODS html file="D:\Projects\Peterson\DRG by freq 2010.xls" style=minimal;
%DRG(group="HC HC HC", yr=2010);
%DRG(group="HC HC nonHC", yr=2010);
%DRG(group="HC nonHC HC", yr=2010);
%DRG(group="HC nonHC nonHC", yr=2010);
%DRG(group="nonHC HC HC", yr=2010);
%DRG(group="nonHC HC nonHC", yr=2010);
%DRG(group="nonHC nonHC HC", yr=2010);
%DRG(group="nonHC nonHC nonHC", yr=2010);
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
ODS html file="D:\Projects\Peterson\DRG by freq 3yr.xls" style=minimal;
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
ODS html file="D:\Projects\Peterson\DRG by pct 2008.xls" style=minimal;
%DRG(group="HC HC HC", yr=2008);
%DRG(group="HC HC nonHC", yr=2008);
%DRG(group="HC nonHC HC", yr=2008);
%DRG(group="HC nonHC nonHC", yr=2008);
%DRG(group="nonHC HC HC", yr=2008);
%DRG(group="nonHC HC nonHC", yr=2008);
%DRG(group="nonHC nonHC HC", yr=2008);
%DRG(group="nonHC nonHC nonHC", yr=2008);
 ODS html close;
ODS Listing; 

ODS Listing CLOSE;
ODS html file="D:\Projects\Peterson\DRG by pct 2009.xls" style=minimal;
%DRG(group="HC HC HC", yr=2009);
%DRG(group="HC HC nonHC", yr=2009);
%DRG(group="HC nonHC HC", yr=2009);
%DRG(group="HC nonHC nonHC", yr=2009);
%DRG(group="nonHC HC HC", yr=2009);
%DRG(group="nonHC HC nonHC", yr=2009);
%DRG(group="nonHC nonHC HC", yr=2009);
%DRG(group="nonHC nonHC nonHC", yr=2009);
 ODS html close;
ODS Listing; 

ODS Listing CLOSE;
ODS html file="D:\Projects\Peterson\DRG by pct 2010.xls" style=minimal;
%DRG(group="HC HC HC", yr=2010);
%DRG(group="HC HC nonHC", yr=2010);
%DRG(group="HC nonHC HC", yr=2010);
%DRG(group="HC nonHC nonHC", yr=2010);
%DRG(group="nonHC HC HC", yr=2010);
%DRG(group="nonHC HC nonHC", yr=2010);
%DRG(group="nonHC nonHC HC", yr=2010);
%DRG(group="nonHC nonHC nonHC", yr=2010);
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
ODS html file="D:\Projects\Peterson\DRG by pct 3yr.xls" style=minimal;
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
data MR;
set data.Planamedicareservice2008(in=in1) data.Planamedicareservice2009(in=in2) data.Planamedicareservice2010(in=in3);
if in1 then year=2008;
if in2 then year=2009;
if in3 then year=2010;

if level>=25;
stdcost=MEDICARE_PMT+MEDICARE_BENE_PMT;
CLM_CNT=Medicare_CLM_CNT;
drug=put(SRVC_2, MR_SRVC_2_.);
keep bene_id group drug   CLM_CNT stdcost year;
run;

data MC;
set data.Planamedicaidservice2008(in=in1) data.Planamedicaidservice2009(in=in2) data.Planamedicaidservice2010(in=in3);
if in1 then year=2008;
if in2 then year=2009;
if in3 then year=2010;

if level>=44;
stdcost=MEDICAID_PMT+MEDICAID_COIN_PMT+MEDICAID_DED_PMT;
CLM_CNT=Medicaid_CLM_CNT;
drug=put(SRVC_3, MC_SRVC_3_.);
keep bene_id group drug CLM_CNT stdcost year;
run;

data partd;
set MR MC;
proc freq;tables drug/missing;
run;



%macro Drug(group, yr);
proc sort data=partD out=temp3; 
where group=&group. and year=&yr. ;
by drug;
run;

proc sql;
create table temp4 as
select sum(CLM_CNT) as totN
from temp3;
quit;

data _null_;
set temp4;
call symput("totN",totN);
run;


proc sql;
create table temp4 as
select drug, sum(stdcost) as totcost, mean(stdcost) as aveCost, sum(CLM_CNT) as N,  symget('totN')  as totN
from temp3 
group by drug;
quit;

proc sort data=temp4 nodupkey; by drug;run;

data temp5;
set temp4;
pct=N/totN*1;
*if drug ne 'Unclassified';
drop N totN;
proc sort;
by descending pct;
run;

/*
data temp5;set temp5;if _n_<=16;run;
*/
proc print data=temp5;
title &group.;  
var drug pct aveCost TotCost;
run;
%mend Drug;


ODS Listing CLOSE;
ODS html file="D:\Projects\Peterson\Drug by freq 2008.xls" style=minimal;
%Drug(group="HC HC HC", yr=2008);
%Drug(group="HC HC nonHC", yr=2008);
%Drug(group="HC nonHC HC", yr=2008);
%Drug(group="HC nonHC nonHC", yr=2008);
%Drug(group="nonHC HC HC", yr=2008);
%Drug(group="nonHC HC nonHC", yr=2008);
%Drug(group="nonHC nonHC HC", yr=2008);
%Drug(group="nonHC nonHC nonHC", yr=2008);
 ODS html close;
ODS Listing; 

ODS Listing CLOSE;
ODS html file="D:\Projects\Peterson\Drug by freq 2009.xls" style=minimal;
%Drug(group="HC HC HC", yr=2009);
%Drug(group="HC HC nonHC", yr=2009);
%Drug(group="HC nonHC HC", yr=2009);
%Drug(group="HC nonHC nonHC", yr=2009);
%Drug(group="nonHC HC HC", yr=2009);
%Drug(group="nonHC HC nonHC", yr=2009);
%Drug(group="nonHC nonHC HC", yr=2009);
%Drug(group="nonHC nonHC nonHC", yr=2009);
 ODS html close;
ODS Listing; 

ODS Listing CLOSE;
ODS html file="D:\Projects\Peterson\Drug by freq 2010.xls" style=minimal;
%Drug(group="HC HC HC", yr=2010);
%Drug(group="HC HC nonHC", yr=2010);
%Drug(group="HC nonHC HC", yr=2010);
%Drug(group="HC nonHC nonHC", yr=2010);
%Drug(group="nonHC HC HC", yr=2010);
%Drug(group="nonHC HC nonHC", yr=2010);
%Drug(group="nonHC nonHC HC", yr=2010);
%Drug(group="nonHC nonHC nonHC", yr=2010);
 ODS html close;
ODS Listing; 

%macro Drug(group, yr);
proc sort data=partD out=temp3; 
where group=&group.   ;
by drug;
run;

proc sql;
create table temp4 as
select sum(CLM_CNT) as totN
from temp3;
quit;

data _null_;
set temp4;
call symput("totN",totN);
run;


proc sql;
create table temp4 as
select drug, sum(stdcost) as totcost, mean(stdcost) as aveCost, sum(CLM_CNT) as N,  symget('totN')  as totN
from temp3 
group by drug;
quit;

proc sort data=temp4 nodupkey; by drug;run;

data temp5;
set temp4;
pct=N/totN*1;
drop N totN;
proc sort;
by descending pct;
run;

 

proc print data=temp5;
title &group.;  
var drug pct aveCost TotCost;
run;
%mend Drug;


ODS Listing CLOSE;
ODS html file="D:\Projects\Peterson\Drug by freq 3yr.xls" style=minimal;
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
proc sort data=PartD out=temp3; 
where group=&group. and year=&yr. ;
by drug;
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
select drug, sum(stdcost) as totcost, mean(stdcost) as aveCost, symget('tot')  as tot
from temp3 
group by drug;
quit;

proc sort data=temp4 nodupkey; by drug;run;

data temp5;
set temp4;
costpct=totcost/tot*1;
drop  tot ;
proc sort;
by descending costpct;
run;

 

proc print data=temp5;
title &group.;  
var drug costpct aveCost TotCost;
run;
%mend Drug;


ODS Listing CLOSE;
ODS html file="D:\Projects\Peterson\Drug by pct 2008.xls" style=minimal;
%Drug(group="HC HC HC", yr=2008);
%Drug(group="HC HC nonHC", yr=2008);
%Drug(group="HC nonHC HC", yr=2008);
%Drug(group="HC nonHC nonHC", yr=2008);
%Drug(group="nonHC HC HC", yr=2008);
%Drug(group="nonHC HC nonHC", yr=2008);
%Drug(group="nonHC nonHC HC", yr=2008);
%Drug(group="nonHC nonHC nonHC", yr=2008);
 ODS html close;
ODS Listing; 

ODS Listing CLOSE;
ODS html file="D:\Projects\Peterson\Drug by pct 2009.xls" style=minimal;
%Drug(group="HC HC HC", yr=2009);
%Drug(group="HC HC nonHC", yr=2009);
%Drug(group="HC nonHC HC", yr=2009);
%Drug(group="HC nonHC nonHC", yr=2009);
%Drug(group="nonHC HC HC", yr=2009);
%Drug(group="nonHC HC nonHC", yr=2009);
%Drug(group="nonHC nonHC HC", yr=2009);
%Drug(group="nonHC nonHC nonHC", yr=2009);
 ODS html close;
ODS Listing; 

ODS Listing CLOSE;
ODS html file="D:\Projects\Peterson\Drug by pct 2010.xls" style=minimal;
%Drug(group="HC HC HC", yr=2010);
%Drug(group="HC HC nonHC", yr=2010);
%Drug(group="HC nonHC HC", yr=2010);
%Drug(group="HC nonHC nonHC", yr=2010);
%Drug(group="nonHC HC HC", yr=2010);
%Drug(group="nonHC HC nonHC", yr=2010);
%Drug(group="nonHC nonHC HC", yr=2010);
%Drug(group="nonHC nonHC nonHC", yr=2010);
 ODS html close;
ODS Listing; 



%macro Drug(group, yr);
proc sort data=PartD out=temp3; 
where group=&group.  ;
by drug;
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
select drug, sum(stdcost) as totcost, mean(stdcost) as aveCost, symget('tot')  as tot
from temp3 
group by drug;
quit;

proc sort data=temp4 nodupkey; by drug;run;

data temp5;
set temp4;
costpct=totcost/tot*1;
drop  tot ;
proc sort;
by descending costpct;
run;

 

proc print data=temp5;
title &group.;  
var drug costpct aveCost TotCost;
run;
%mend Drug;

ODS Listing CLOSE;
ODS html file="D:\Projects\Peterson\Drug by pct 3yr.xls" style=minimal;
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
