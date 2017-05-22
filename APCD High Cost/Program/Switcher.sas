***************************
Switcher
Xiner Zhou
11/29/2015
****************************;
libname APCD 'C:\data\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';

*V2.0;
proc sort data=APCD.data out=data2012;where SubmissionYear=2012;by MemberLinkEID ;run;
 
proc sql;
create table temp as
select *, sum(total_spending) as tot, total_spending/calculated tot as ratio
from data2012
group by  MemberLinkEID 
;
quit;

proc sort data=APCD.data out=bene2012 nodupkey;where SubmissionYear=2012;by MemberLinkEID ;run;
proc freq data=bene2012;tables switcher;run;

%let s="Medicaid, Medicaid Managed Care";
%let s="Medicaid, Medicare Advantage";
%let s="Medicaid, Private";
%let s="Medicaid Managed Care, Medicare Advantage";
%let s="Medicaid Managed Care, Private";
%let s="Medicare Advantage, Private";
%let s="Medicaid, Medicaid Managed Care, Medicare Advantage";
%let s="Medicaid, Medicaid Managed Care, Private";
%let s="Medicaid, Medicare Advantage, Private";
%let s="Medicaid Managed Care, Medicare Advantage, Private";
%let s="Medicaid, Medicaid Managed Care, Medicare Advantage, Private"; 
 
data temp1;
set temp;
if switcher in (&s.);
proc means sum;class type1;var total_spending;
proc means min mean max;class type1;var ratio;
run;






*V2.0;
proc sort data=APCD.dataV21 out=dataV212012;where  Year=2012;by MemberLinkEID ;run;
 
proc sql;
create table temp as
select *, sum(total_spending) as tot, total_spending/calculated tot as ratio
from dataV212012
group by  MemberLinkEID 
;
quit;

proc sort data=APCD.dataV21 out=bene2012 nodupkey;where  Year=2012;by MemberLinkEID ;run;
proc freq data=bene2012;tables switcher;run;

%let s="Medicaid, Medicaid Managed Care";
%let s="Medicaid, Medicare Advantage";
%let s="Medicaid, Private";
%let s="Medicaid Managed Care, Medicare Advantage";
%let s="Medicaid Managed Care, Private";
%let s="Medicare Advantage, Private";
%let s="Medicaid, Medicaid Managed Care, Medicare Advantage";
%let s="Medicaid, Medicaid Managed Care, Private";
%let s="Medicaid, Medicare Advantage, Private";
%let s="Medicaid Managed Care, Medicare Advantage, Private";
%let s="Medicaid, Medicaid Managed Care, Medicare Advantage, Private"; 
 
data temp1;
set temp;
if switcher in (&s.);
proc means sum;class type1;var total_spending;
proc means min mean max;class type1;var ratio;
run;

 
