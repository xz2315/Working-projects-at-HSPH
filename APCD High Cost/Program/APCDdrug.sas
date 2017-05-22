******************************************
Drug Cost
Xiner Zhou
4/3/2017
*****************************************;

libname V21 'D:\Data\APCD\Massachusetts\Data\Version 2.1 for Readmission Project';
libname V20 'D:\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';
libname APCD 'D:\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';

*V2.0;
proc sql;
create table temp as 
select MemberLinkEID,  PayerClaimControlNumber, ChargeAmountCleaned as Charged,
datepart(DatePrescriptionFilled) as Date format=mmddyy10., 
year(calculated Date) as Year 
from APCD.Pharmacy;
quit;
proc sort data=temp out=temp1;
where year=2012;
by MemberLinkEID  ;
run;
proc sql;
create table APCD.DrugStdCost2012 as
select MemberLinkEID, sum(charged) as Cost_Drug, sum(charged) as Spending_Drug, count(*) as CLM_Drug
from temp1 
group by MemberLinkEID  ;
quit;
proc sort data=APCD.DrugStdCost2012 nodupkey;by MemberLinkEID  ;run;





* by NDC;
proc import datafile="D:\Projects\APCD High Cost\NDC" dbms=xlsx out=NDC replace ;getnames=yes;run;
data NDC;
set NDC;
NDC1=put(NDC,z11.);drop NDC;rename NDC1=NDC;
run;

*V2.0;
proc sql;
create table temp as 
select MemberLinkEID, OrgID, PayerClaimControlNumber, LineCounter, 
DrugCode, DrugName, QuantityDispensed, DaysSupply, ChargeAmountCleaned as Charged,
datepart(DatePrescriptionFilled) as Date format=mmddyy10., 
year(calculated Date) as Year 
from V20.Pharmacy
where MemberLinkEID ne  .;
quit;
 
proc sql;
create table temp1 as
select a.*,b.*
from temp a left join NDC b
on a.DrugCode=b.NDC
where a.Year in (2012) and a.Charged>=0;
quit;

proc sort data=temp1 ;by VA_class GENERIC memberLinkEID ;run;

data APCD.Drug2012;
set temp1;
if charged>0;
if DaysSupply ne . then
costperday=Charged/DaysSupply;
else costperday=Charged;
proc means mean min max;
class VA_class;
var costperday Charged;
proc sort;by memberLinkEID VA_class;
run;
 
* summarize at patient level by VAclass;
proc sort data=NDC out=VA nodupkey;by VA_class;run;
data VA;
set VA;
VA=_n_;
keep VA_class VA;
run;
proc sql;
create table temp2 as
select a.*,b.*
from APCD.Drug2012 a left join VA b
on a.VA_class=b.VA_class;
quit;

proc sql;
create table temp3 as
select memberlinkEID,VA, VA_class,sum(Charged) as Charged, count(PayerClaimControlNumber) as CLM_DRUG
from temp2
group by memberLinkEID,VA ;
quit;
proc sort data=temp3 out=temp4 nodupkey;by  memberLinkEID VA ;run;
 
 * all cost;
proc sql;
create table temp5 as
select memberlinkEID,"All Drugs" as VA_class, 0 as VA, sum(Charged) as Charged, count(CLM_DRUG) as CLM_DRUG
from temp4
group by memberLinkEID ;
quit;

* long format;
data temp6; 
set temp4 temp5;
if VA_class='' then do;VA_class="Missing";VA=397;end;
proc sort ;by memberlinkeid VA ;
run;
*wode format;
proc transpose data=temp6 out=temp7 prefix=Drug;
by memberLinkEID;
id VA ;
var charged;
run;

data APCD.VAdrug2012;
set temp7;
array temp {313} Drug0--Drug9;
do i=1 to 313;
if temp{i}=. then temp{i}=0;
end;
drop i;
run;

 







































 

*V2.1;
proc sql;
create table temp as 
select PayerClaimControlNumber,LineCounter, MemberLinkEID, Payer, datepart(DatePrescriptionFilled) as Date format=mmddyy10., year(calculated Date) as Year, 
DrugCode, DrugName,ChargeAmount  as Charged
from V21.Pharmacy
where MemberLinkEID ne  .;
quit;
 
proc sql;
create table temp1 as
select a.*,b.*
from temp a left join NDC b
on a.DrugCode=b.NDC
where a.Year in (2012) and a.Charged>=0;
quit;

proc sort data=temp1 ;by memberLinkEID PayerClaimControlNumber ;run;
proc sql;
create table temp2 as
select memberlinkEID,PayerClaimControlNumber,sum(Charged) as T_Charged 
from temp1
group by memberLinkEID,PayerClaimControlNumber;
quit;
proc sort data=temp2   nodupkey;by  memberLinkEID PayerClaimControlNumber;run;


proc sort data=temp2 ;by memberLinkEID ;run;
proc sql;
create table temp3 as
select memberlinkEID,sum(T_Charged) as Cost_Drug,sum(T_Charged) as Spending_Drug,count(PayerClaimControlNumber) as CLM_DRUG
from temp2
group by memberLinkEID;
quit;
proc sort data=temp3 out=V21.DrugStdCost2012 nodupkey;by  memberLinkEID ;run;
  
 

 

