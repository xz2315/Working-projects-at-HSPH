*******************************
Denominator 
Xiner Zhou
11/29/2015
******************************;
 
libname data 'C:\data\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';
 libname APCD 'C:\data\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';
 
proc sql;
create table temp as
select *
from data.Member 
where MemberLinkEID ne . and SubmissionYear in (2011,2012) and MedicalCoverage='1' and  Standardized_MemberStateorProvin='MA' and PrimaryInsuranceIndicator='1';
quit;

data temp;
length type $80.;
set temp;
MC=0;MCO=0;MA=0;Private=0;
if InsuranceTypeCodeProduct='MC' then do;type="Medicaid";MC=1;end;
else if InsuranceTypeCodeProduct='MO' then do;type ="Medicaid Managed Care";MCO=1;end;
else if InsuranceTypeCodeProduct in ('16','20','21','HN') then do;type ="Medicare Advantage"; MA=1;end; 
else if InsuranceTypeCodeProduct ne '' then do;type="Private";Private=1;end;
proc sort nodupkey;by MemberLinkEID  SubmissionYear OrgID InsuranceTypeCodeProduct;
run;
 
*Flag MC/MCO/MA/Private Swirchers;
proc sort data=temp out=temp1 nodupkey;by MemberLinkEID  SubmissionYear type;run;
proc sql;
create table temp2 as 
select MemberLinkEID,  SubmissionYear, sum(MC) as tot_MC, sum(MCO) as tot_MCO, sum(MA) as tot_MA, sum(Private) as tot_Private
from temp1
group by MemberLinkEID, SubmissionYear;
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
by Memberlinkeid submissionyear  orgid ;
var InsuranceTypeCodeProduct ;
run;
 
proc sort data=temp  out=temp5 nodupkey;by MemberLinkEID  SubmissionYear OrgID ;run;
proc sql;
create table temp6 as
select a.*,b.col1 as Plan1,b.col2 as Plan2,b.col3 as Plan3,b.col4 as Plan4 
from temp5 a left join temp4 b
on a.Memberlinkeid=b.Memberlinkeid and  a.submissionyear=b.submissionyear and  a.orgid=b.orgid;
quit;
*Link switcher;
proc sql;
create table temp7 as
select a.*,b.switcher
from temp6 a left join temp3 b
on a.Memberlinkeid=b.Memberlinkeid and  a.submissionyear=b.submissionyear;
quit;
data temp7;set temp7;drop MC MCO MA Private type;run;
***End; 

***Do: Flag MA/Medicaid/MedicaidManagedCare for Plan1/Plan2/Plan3/Plan4, final denominator will be as:Patient-Year-OrgID-Plan(s) ;
data APCD.Denominator;
set temp7;
length type1 type2 type3 type4 $30.;
array plan {4} $ plan1 plan2 plan3 plan4;
array type {4} $ type1 type2 type3 type4;
do i=1 to 4;
	if plan{i}='MC' then type{i}="Medicaid";
	else if plan{i}='MO' then type{i}="Medicaid Managed Care";
	else if plan{i} in ('16','20','21','HN') then type{i}="Medicare Advantage";  
	else if plan{i} ne '' then type{i}="Private";
end;
drop i; 
run;
***End;
  

/***Do: Tabulate Denominator;

* Number of  bene in APCD;
data temp;
set APCD.Denominator;
where submissionYear=2012 ;
proc sort nodupkey;by memberlinkeid;
run;

* Number of Medicaid;
data temp;
set APCD.Denominator;
where submissionYear=2012;
if type1="Medicaid" or type2="Medicaid" or type3="Medicaid" or type4="Medicaid";
proc sort nodupkey;by memberlinkeid;
run;

* Number of Medicaid Managed Care;
data temp;
set APCD.Denominator;
where submissionYear=2012;
if type1="Medicaid Managed Care" or type2="Medicaid Managed Care" or type3="Medicaid Managed Care" or type4="Medicaid Managed Care";
proc sort nodupkey;by memberlinkeid;
run;

* Number of MA as Primary Payer;
data temp;
set APCD.Denominator;
where submissionYear=2012;
if type1="Medicare Advantage" or type2="Medicare Advantage" or type3="Medicare Advantage" or type4="Medicare Advantage";
proc sort nodupkey;by memberlinkeid;
run;

* Number of Other Private Plans;
data temp;
set APCD.Denominator;
where submissionYear=2012;
if type1="Other Private Plans" or type2="Other Private Plans" or type3="Other Private Plans" or type4="Other Private Plans";
proc sort nodupkey;by memberlinkeid;
run;

***End;

***Comment: Perfectly Done, compared with Kaiser Family Foundation;



***Do: Tabulate CCW;
proc sql;
create table temp as
select a.*,b.*
from apcd.Denominator a left join apcd.ChronicCondition b
on a.MemberLinkEid=b.MemberLinkEID
where SubmissionYear=2012;
quit;

*Medicaid;
data temp1;
set temp;
if type1="Medicaid" or type2="Medicaid" or type3="Medicaid" or type4="Medicaid";
array comorb {30} amiihd amputat arthrit artopen bph cancer chrkid chf cystfib dementia
diabetes endo eyedis hemadis hyperlip hyperten immunedis ibd liver lung
neuromusc osteo paralyt psydis sknulc spchrtarr strk sa thyroid vascdis;
do i=1 to 30;
	if comorb{i}=. then comorb{i}=0;
end;
drop i;

proc sort nodupkey;by memberlinkeid;
run;

proc means data=temp1 noprint;
var amiihd amputat arthrit artopen bph cancer chrkid chf cystfib dementia
diabetes endo eyedis hemadis hyperlip hyperten immunedis ibd liver lung
neuromusc osteo paralyt psydis sknulc spchrtarr strk sa thyroid vascdis;

output out=Medicaid mean(amiihd amputat arthrit artopen bph cancer chrkid chf cystfib dementia
diabetes endo eyedis hemadis hyperlip hyperten immunedis ibd liver lung
neuromusc osteo paralyt psydis sknulc spchrtarr strk sa thyroid vascdis)=/autoname;
run;

proc print data=Medicaid label;run;


*Medicaid Managed Care;
data temp1;
set temp;
if type1="Medicaid Managed Care" or type2="Medicaid Managed Care" or type3="Medicaid Managed Care" or type4="Medicaid Managed Care";

array comorb {30} amiihd amputat arthrit artopen bph cancer chrkid chf cystfib dementia
diabetes endo eyedis hemadis hyperlip hyperten immunedis ibd liver lung
neuromusc osteo paralyt psydis sknulc spchrtarr strk sa thyroid vascdis;
do i=1 to 30;
	if comorb{i}=. then comorb{i}=0;
end;
drop i;

proc sort nodupkey;by memberlinkeid;
run;

proc means data=temp1 noprint;
var amiihd amputat arthrit artopen bph cancer chrkid chf cystfib dementia
diabetes endo eyedis hemadis hyperlip hyperten immunedis ibd liver lung
neuromusc osteo paralyt psydis sknulc spchrtarr strk sa thyroid vascdis;

output out=MMC mean(amiihd amputat arthrit artopen bph cancer chrkid chf cystfib dementia
diabetes endo eyedis hemadis hyperlip hyperten immunedis ibd liver lung
neuromusc osteo paralyt psydis sknulc spchrtarr strk sa thyroid vascdis)=/autoname;
run;

proc print data=MMC label;run;


*MA;
data temp1;
set temp;
if type1="Medicare Advantage" or type2="Medicare Advantage" or type3="Medicare Advantage" or type4="Medicare Advantage";
array comorb {30} amiihd amputat arthrit artopen bph cancer chrkid chf cystfib dementia
diabetes endo eyedis hemadis hyperlip hyperten immunedis ibd liver lung
neuromusc osteo paralyt psydis sknulc spchrtarr strk sa thyroid vascdis;
do i=1 to 30;
	if comorb{i}=. then comorb{i}=0;
end;
drop i;

proc sort nodupkey;by memberlinkeid;
run;

proc means data=temp1 noprint;
var amiihd amputat arthrit artopen bph cancer chrkid chf cystfib dementia
diabetes endo eyedis hemadis hyperlip hyperten immunedis ibd liver lung
neuromusc osteo paralyt psydis sknulc spchrtarr strk sa thyroid vascdis;

output out=MA mean(amiihd amputat arthrit artopen bph cancer chrkid chf cystfib dementia
diabetes endo eyedis hemadis hyperlip hyperten immunedis ibd liver lung
neuromusc osteo paralyt psydis sknulc spchrtarr strk sa thyroid vascdis)=/autoname;
run;

proc print data=MA label;run;



*private;
data temp1;
set temp;
if type1="Other Private Plans" or type2="Other Private Plans" or type3="Other Private Plans" or type4="Other Private Plans";
array comorb {30} amiihd amputat arthrit artopen bph cancer chrkid chf cystfib dementia
diabetes endo eyedis hemadis hyperlip hyperten immunedis ibd liver lung
neuromusc osteo paralyt psydis sknulc spchrtarr strk sa thyroid vascdis;
do i=1 to 30;
	if comorb{i}=. then comorb{i}=0;
end;
drop i;

proc sort nodupkey;by memberlinkeid;
run;

proc means data=temp1 noprint;
var amiihd amputat arthrit artopen bph cancer chrkid chf cystfib dementia
diabetes endo eyedis hemadis hyperlip hyperten immunedis ibd liver lung
neuromusc osteo paralyt psydis sknulc spchrtarr strk sa thyroid vascdis;

output out=private mean(amiihd amputat arthrit artopen bph cancer chrkid chf cystfib dementia
diabetes endo eyedis hemadis hyperlip hyperten immunedis ibd liver lung
neuromusc osteo paralyt psydis sknulc spchrtarr strk sa thyroid vascdis)=/autoname;
run;

proc print data=private  label;run;

***End;
*/
