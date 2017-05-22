*******************************
Update Carrier Spending and Cost
Xiner Zhou
3/4/2016
******************************;
libname APCD 'C:\data\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';

libname betos 'C:\data\Projects\APCD High Cost\Archieve';
data temp;
set  
apcd.CarrierstdcostCY2012(keep=PlaceofService PayerClaimControlNumber LineCounter MemberLinkEID ORGID   stdcost spending HCPCS);
run;

proc sql;
create table temp1 as
select a.*,b.*
from temp a left join betos.betos b
on a.HCPCS=b.HCPCS;
quit;

data temp2;
set temp1;

i=substr(betos,1,1);

if PlaceofService='24' then type="Ambulatory Surgical Center (ASC)";
else do;
  if i='D' then Type="Durable Medical Equipment (DME)";
  else if i='M' then Type="Physician Evaluation and Management";
  else if i='I' then Type="Imaging";
  else if i='T' then Type='Tests';
  else if i='P' then Type="Procedures";
  else if i='O' and betos='O1E' then Type="Part B Drug";
  else type="Other Part B";
end;
 
drop i;
proc sort nodupkey;by PayerClaimControlNumber LineCounter;
run;

proc sort data=temp2;by MemberLinkEID  ;
run;

%macro carrier(name=,type=,str= );
proc sql;
create table temp&name. as
select  MemberLinkEID, ORGID, count(PayerClaimControlNumber) as CLM_&name. label="N.of Claims: &type.", 
sum(stdcost) as Cost_&name. label="Standard Cost: &type.", sum(spending) as Spending_&name. label="Spending: &type."
from temp2
where Type   in (&str. )
group by  MemberLinkEID
;
quit;
proc sort data=temp&name. nodupkey;by  MemberLinkEID;run;
%mend carrier;
%carrier(name=EM,type=Physician Evaluation and Management,str="Physician Evaluation and Managem");








%let bymoney=Cost;
%let bymoney=Spending;

proc sql;
create table  temp1 as
select a.*,b.CLM_EM as CLM_EM1,b.Cost_EM as Cost_EM1,b.Spending_EM as Spending_EM1
from APCD.AnalyticData&bymoney. a left join tempEM b
on a.MemberlinkEID=b.MemberLinkEID;
quit;

data  temp2;
set  temp1 ;

if CLM_EM1 =. then CLM_EM1 =0;
if Cost_EM1=. then Cost_EM1=0;
if Spending_EM1=. then Spending_EM1=0;
 


T_CLM_EM =T_CLM_EM+CLM_EM1;
T_Cost_EM=T_Cost_EM+Cost_EM1;
T_Spending_EM=T_Spending_EM+Spending_EM1;

T_Cost=T_Cost+Cost_EM1;
T_Spending=T_Spending+Spending_EM1;

&bymoney.wDrug=&bymoney.wDrug+&bymoney._EM1;
&bymoney.woDrug=&bymoney.woDrug+&bymoney._EM1;

 run;
proc rank data=temp2 out=temp3 percent descending ;
var &bymoney.wDrug;
ranks r ;
run;


data  APCD.AnalyticData&bymoney.;
set temp3;
if r <=10 then highCost=1;
else  highCost=0;
proc freq;tables highCost/missing;
run;
