*******************************************
	Revision 
******************************************;
libname APCD 'D:\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';

%let bymoney=Cost;

proc sql;
create table temp as
select a.*,b.*
from APCD.AnalyticData&bymoney. a inner join APCD.Drug2012 b
on a.MemberLinkeid=b.MemberLinkEID;
quit;


%macro drug(type, hc, num);
data temp1;
set temp;
where type="&type." and highcost=&hc.;
proc sort;by VA_class;run;

proc sql;
create table temp2 as
select VA_class, sum(charged) as cost
from temp1
group by VA_class;
quit;

proc sort data=temp2 out=table&num.;by descending cost;run;

%mend drug;
%drug(type=Private, hc=1, num=1);
%drug(type=Private, hc=0, num=2);
%drug(type=Medicaid, hc=1, num=3);
%drug(type=Medicaid, hc=0, num=4);
%drug(type=Medicaid Managed Care, hc=1, num=5);
%drug(type=Medicaid Managed Care, hc=0, num=6);


ODS Listing CLOSE;
ODS html file="D:\Projects\APCD High Cost\Procedure Documentation\Table1.xls" style=minimal;
proc print data=Table1;title "Private HC";run;
proc print data=Table2;title "Private non-HC";run;
proc print data=Table3;title "Medicaid HC";run;
proc print data=Table4;title "Medicaid non-HC";run;
proc print data=Table5;title "Medicaid Managed Care HC";run;
proc print data=Table6;title "Medicaid Managed Care non-HC";run;
ODS html close;
ODS Listing; 





proc sort data=APCD.AnalyticData&bymoney. out=bene; by type highcost;run;
proc sql;
create table numbene as 
select type, highcost, count(*) as nbene
from bene 
group by type, highcost;
quit;
%macro drug(type, hc, num);
data temp1;
set temp;
where type="&type." and highcost=&hc.;
proc sort;by VA_class;run;

proc sql;
create table temp2 as
select a.*,b.*
from temp1 a left join numbene  b
on a.type=b.type and a.highcost=b.highcost;
quit;

proc sort data=temp2;by VA_class;run;

proc sql;
create table tot as
select type, sum(charged) as totcost 
from temp2;
quit;
proc sort data=tot nodupkey;by type;run;
proc sql;
create table temp3 as
select a.*,b.*
from temp2 a left join tot b
on a.type=b.type;
quit;


proc sql;
create table temp4 as
select VA_class, sum(charged) as cost, sum(charged)/nbene as ave_cost, sum(charged)/totcost as percent
from temp3
group by VA_class;
quit;
proc sort data=temp4 nodupkey;by VA_class;run;
proc sort data=temp4 out=table&num.;by descending cost;run;

%mend drug;
%drug(type=Private, hc=1, num=1);
%drug(type=Private, hc=0, num=2);
%drug(type=Medicaid, hc=1, num=3);
%drug(type=Medicaid, hc=0, num=4);
%drug(type=Medicaid Managed Care, hc=1, num=5);
%drug(type=Medicaid Managed Care, hc=0, num=6);


ODS Listing CLOSE;
ODS html file="D:\Projects\APCD High Cost\Procedure Documentation\Drug Cost.xls" style=minimal;
proc print data=Table1;title "Private HC";run;
proc print data=Table2;title "Private non-HC";run;
proc print data=Table3;title "Medicaid HC";run;
proc print data=Table4;title "Medicaid non-HC";run;
proc print data=Table5;title "Medicaid Managed Care HC";run;
proc print data=Table6;title "Medicaid Managed Care non-HC";run;
ODS html close;
ODS Listing; 
