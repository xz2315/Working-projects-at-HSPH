*********************************
Top Diagnoses/Admission Reasons 
Xiner Zhou
4/18/2017
*******************************;
libname APCD 'D:\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';
libname ccs 'D:\data\Medicare\CCS\Data';

proc sql;
create table temp as
select a.*,b.*
from APCD.IPstdcost a left join ccs.Ccsicd92015 b
on a.PrincipalDx=b.icd9;
quit;


proc sql;
create table temp1 as
select a.PayerClaimControlNumber, a.LineCounter, a.MemberLinkEID, a.DRGTitle, a.dxdescription as CCS, a.Discharge, a.stdcost, b.highcost, b.Type
from temp a inner join APCD.AnalyticDataCost b
on a.MemberLinkEID=b.MemberLinkEID;
quit;

data temp2;
set temp1;
if year(Discharge)=2012;
proc sort ;by PayerClaimControlNumber LineCounter;
proc sort nodupkey;by PayerClaimControlNumber;
run;

ODS Listing CLOSE;
ODS html file="D:\Projects\APCD High Cost\Procedure Documentation\CCS.xls" style=minimal;

%macro CCS(type, hc, title);
proc sort data=temp2 out=temp3; 
where type=&type. and highcost=&hc.;
by CCS;
run;
proc sql;
create table temp4 as
select count(*) as totN
from temp3;
quit;

data _null_;set temp4;call symput("totN",totN);run;


proc sql;
create table temp4 as
select  CCS, sum(stdcost) as totcost, mean(stdcost) as aveCost, count(*) as N,  symget('totN')  as totN
from temp3 
group by CCS;
quit;

data temp5;
set temp4;
pct=N/totN*1;drop N totN;
proc sort;by descending pct;
run;

proc print data=temp5;
title &title.;
var CCS pct aveCost TotCost;run;
%mend CCS;

 
%CCS(type="Private",hc=1,title="Private HighCost");
%CCS(type="Private",hc=0,title="Private non-HighCost");

%CCS(type="Medicaid",hc=1,title="Medicaid HighCost");
%CCS(type="Medicaid",hc=0,title="Medicaid non-HighCost");

%CCS(type="Medicaid Managed Care",hc=1,title="Medicaid  Managed Care HighCost");
%CCS(type="Medicaid Managed Care",hc=0,title="Medicaid  Managed Care non-HighCost");


ODS html close;
ODS Listing;  












ODS Listing CLOSE;
ODS html file="D:\Projects\APCD High Cost\Procedure Documentation\DRG.xls" style=minimal;
%macro DRG(type, hc, title);
proc sort data=temp2 out=temp3; 
where type=&type. and highcost=&hc.;
by DRGTitle;
run;
proc sql;
create table temp4 as
select count(*) as totN
from temp3;
quit;

data _null_;set temp4;call symput("totN",totN);run;


proc sql;
create table temp4 as
select  DRGTitle, sum(stdcost) as totcost, mean(stdcost) as aveCost, count(*) as N,  symget('totN')  as totN
from temp3 
group by DRGTitle;
quit;

data temp5;
set temp4;
pct=N/totN*1;drop N totN;
proc sort;by descending totcost;
run;

data temp5;set temp5;if DRGTitle ne '';run;
data temp5;set temp5;if  _n_<=15;run;
proc print data=temp5;
title &title.;
var DRGTitle pct aveCost TotCost;run;
%mend DRG;

 
%DRG(type="Private",hc=1,title="Private HighCost");
%DRG(type="Private",hc=0,title="Private non-HighCost");

%DRG(type="Medicaid",hc=1,title="Medicaid HighCost");
%DRG(type="Medicaid",hc=0,title="Medicaid non-HighCost");

%DRG(type="Medicaid Managed Care",hc=1,title="Medicaid  Managed Care HighCost");
%DRG(type="Medicaid Managed Care",hc=0,title="Medicaid  Managed Care non-HighCost");


ODS html close;
ODS Listing;  
