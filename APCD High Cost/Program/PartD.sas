*************************************
Drug Coverage 
Xiner Zhou
12/14/2015
*************************************;

libname V21 'C:\data\Data\APCD\Massachusetts\Data\Version 2.1 for Readmission Project';
libname V20 'C:\data\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';
 

proc sql;
create table temp as
select MemberLinkEID,Year,PrescriptionDrugCoverage,State,PrimaryInsuranceIndicator,Payer,InsuranceProduct 
from V21.Member 
where MemberLinkEID ne . and Year in (2011,2012) and PrescriptionDrugCoverage='1' and  State='MA' and PrimaryInsuranceIndicator='1'  ;
quit;

data temp;length type $80.;
set temp;
MC=0;MCO=0;MA=0;Private=0;
if Payer='3156' and InsuranceProduct='MC' then do;type="Medicaid";MC=1;end;
else if Payer ne '3156' and InsuranceProduct in ('MC','MO')  then do;type ="Medicaid Managed Care";MCO=1;end;
else if InsuranceProduct in ('16','20','21','HN') then do;type ="Medicare Advantage"; MA=1;end; 
else if InsuranceProduct ne '' then do;type="Private";Private=1;end;
proc sort nodupkey;by MemberLinkEID  Year Payer InsuranceProduct;
run;


*Flag MC/MCO/MA/Private Swirchers;
proc sort data=temp out=temp1 nodupkey;by MemberLinkEID  Year type;run;
proc sql;
create table temp2 as 
select MemberLinkEID,  Year, sum(MC) as tot_MC, sum(MCO) as tot_MCO, sum(MA) as tot_MA, sum(Private) as tot_Private
from temp1
group by MemberLinkEID, Year;
quit;
data temp3;
length switcher $80.;
set temp2;
if tot_MC>0 and tot_MCO=0 and tot_MA=0 and tot_Private=0 then switcher="Only Medicaid";
if tot_MC=0 and tot_MCO>0 and tot_MA=0 and tot_Private=0 then switcher="Only Medicaid Managed Care";
if tot_MC=0 and tot_MCO=0 and tot_MA>0 and tot_Private=0 then switcher="Only Medicare Advantage";
if tot_MC=0 and tot_MCO=0 and tot_MA=0 and tot_Private>0 then switcher="Only Private";
if tot_MC>0 and tot_MCO>0 and tot_MA=0 and tot_Private=0 then switcher="Medicaid, Medicaid Managed Care";
if tot_MC>0 and tot_MCO=0 and tot_MA>0 and tot_Private=0 then switcher="Medicaid, Medicare Advantage";
if tot_MC>0 and tot_MCO=0 and tot_MA=0 and tot_Private>0 then switcher="Medicaid, Private";
if tot_MC=0 and tot_MCO>0 and tot_MA>0 and tot_Private=0 then switcher="Medicaid Managed Care, Medicare Advantage";
if tot_MC=0 and tot_MCO>0 and tot_MA=0 and tot_Private>0 then switcher="Medicaid Managed Care, Private";
if tot_MC=0 and tot_MCO=0 and tot_MA>0 and tot_Private>0 then switcher="Medicare Advantage, Private";

if tot_MC>0 and tot_MCO>0 and tot_MA>0 and tot_Private=0 then switcher="Medicaid, Medicaid Managed Care, Medicare Advantage";
if tot_MC>0 and tot_MCO>0 and tot_MA=0 and tot_Private>0 then switcher="Medicaid, Medicaid Managed Care, Private";
if tot_MC>0 and tot_MCO=0 and tot_MA>0 and tot_Private>0 then switcher="Medicaid, Medicare Advantage, Private";
if tot_MC=0 and tot_MCO>0 and tot_MA>0 and tot_Private>0 then switcher="Medicaid Managed Care, Medicare Advantage, Private";

if tot_MC>0 and tot_MCO>0 and tot_MA>0 and tot_Private>0 then switcher="Medicaid, Medicaid Managed Care, Medicare Advantage, Private"; 
proc freq;tables switcher/missing;
run;

*Make Patient-Year-OrgID line;
proc transpose data=temp out=temp4;
by Memberlinkeid year Payer ;
var InsuranceProduct ;
run;
 
proc sort data=temp  out=temp5 nodupkey;by MemberLinkEID  Year Payer ;run;
proc sql;
create table temp6 as
select a.*,b.col1 as Plan1,b.col2 as Plan2,b.col3 as Plan3,b.col4 as Plan4 
from temp5 a left join temp4 b
on a.Memberlinkeid=b.Memberlinkeid and  a.year=b.year and  a.Payer=b.Payer;
quit;
*Link switcher;
proc sql;
create table temp7 as
select a.*,b.switcher
from temp6 a left join temp3 b
on a.Memberlinkeid=b.Memberlinkeid and  a.Year=b.Year;
quit;
data temp7;set temp7;drop MC MCO MA Private type;run;
***End; 


***Do: Flag MA/Medicaid/MedicaidManagedCare for Plan1/Plan2/Plan3/Plan4, final denominator will be as:Patient-Year-OrgID-Plan(s) ;
data V20.PartDDenominatorV21;
set temp7;
length type1 type2 type3 type4 $30.;
array plan {4} $ plan1 plan2 plan3 plan4;
array type {4} $ type1 type2 type3 type4;
do i=1 to 4;
	if Payer='3156' and plan{i}='MC' then type{i}="Medicaid";
	else if Payer ne '3156' and plan{i} in ('MC','MO')  then type{i}="Medicaid Managed Care";
	else if plan{i} in ('16','20','21','HN') then type{i}="Medicare Advantage";  
	else if plan{i} ne '' then type{i}="Private";
end;
drop i; 
OrgID=Payer*1;
run;
***End;
