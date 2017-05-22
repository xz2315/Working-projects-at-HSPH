*******************************
Summary Stdcost and Spending
Xiner Zhou
7/6/2015
******************************;
libname APCD 'C:\data\Data\APCD\Massachusetts\Data';
 

 

***Do: Inpatient;

*Those medical claims without valid plan info are those secondary plan, stdcost usually>>payment;
proc sql;
create table temp as 
select a.*,b.type1,b.type2
from APCD.IPstdcost a inner join APCd.denominator b
on a.SubmissionYear=b.SubmissionYear and a.Memberlinkeid=b.Memberlinkeid and a.orgid=b.orgid
where CY=2011;
quit;
 
proc sort data=temp ;by PayerClaimControlNumber LineCounter;run;
proc sort data=temp nodupkey;by PayerClaimControlNumber;run;

data temp1;
length t $30.;
set temp;

if type2='' then t=type1;
else if MedicaidIndicator='True' then do;
	if type1='Medicaid' or type2='Medicaid' then t='Medicaid';
	else if type1='Medicaid Managed Care' or type2='Medicaid Managed Care' then t='Medicaid Managed Care';
end;
else if type1='Medicare Advantage' or type2='Medicare Advantage' then t='Medicare Advantage';
else t='Other Private Plans';

if stdcost ne 0 then index=allowed/stdcost;
else if stdcost=0 then index=1;
run;
 
proc means data=temp1 ;
class t type;
var index;
output out=index1 N=N mean=mean1 std=std1 min=min1 Q1=Q11 median=median1 Q3=Q31 max=max1  ;
run;
data index1;
set index1;
where t ne '';
var='index';
proc sort;by t descending _freq_ type ;
run;

proc means data=temp1 ;
class t type;
var stdcost;
output out=stdcost N=N mean=mean std=std min=min Q1=Q1 median=median Q3=Q3 max=max sum=sum ;
run;
data stdcost;
set stdcost;
where t ne '';
var='standardized cost';
proc sort;by t descending _freq_ type ;
run;


proc means data=temp1 ;
class t type;
var allowed;
output out=allowed N=N mean=mean std=std min=min Q1=Q1 median=median Q3=Q3 max=max sum=sum;
run;
data allowed;
set allowed;
where t ne '';
var='actual cost';
proc sort;by t descending _freq_ type ;
run;


data temp;
set allowed stdcost ;
run;

proc sql;
create table all as
select a.*,b.*
from temp a left join index1 b
on a.t=b.t and a.type=b.type;
quit;

proc sort data=all;by t descending _freq_ var;run;
proc print data=all;run;
 
***Comment: Perfectly Done!







 



***Do: OP;
libname betos 'C:\data\Projects\APCD High Cost\Archieve';

data temp;
set APCD.opstdcostCY2012;
keep stdcost spending;
run;
proc univariate data=temp noprint;
   var stdcost spending;
   output out=winsor   pctlpts=99  pctlpre=_stdcost _spending;
run;
data _null_;
set winsor;
call symput('stdcost99',_stdcost99);
call symput('spending99',_spending99);
run;

proc sql;
create table temp as 
select a.*,b.type1,b.type2 
from APCD.opstdcostCY2012 a inner join APCd.denominator b
on a.SubmissionYear=b.SubmissionYear and a.Memberlinkeid=b.Memberlinkeid and a.orgid=b.orgid;
quit;

   
data temp2;
set temp;
if type2='' then t=type1;
else if MedicaidIndicator='True' then do;
	if type1='Medicaid' or type2='Medicaid' then t='Medicaid';
	else if type1='Medicaid Managed Care' or type2='Medicaid Managed Care' then t='Medicaid Managed Care';
end;
else if type1='Medicare Advantage' or type2='Medicare Advantage' then t='Medicare Advantage';
else t='Other Private Plans';

if stdcost>&stdcost99. then stdcost=&stdcost99.;
if spending>&spending99. then spending=&spending99.;
 
run;
 
proc means data=temp2 ;
class t type;
var stdcost;
output out=stdcost N=N mean=mean std=std min=min Q1=Q1 median=median Q3=Q3 max=max sum=sum ;
run;
data stdcost;
set stdcost;
where t ne '';
var='standardized cost';
proc sort;by t descending _freq_ type ;
run;


proc means data=temp2 ;
class t type;
var spending;
output out=allowed N=N mean=mean std=std min=min Q1=Q1 median=median Q3=Q3 max=max sum=sum;
run;
data allowed;
set allowed;
where t ne '';
var='actual cost';
proc sort;by t descending _freq_ type ;
run;


data all;
set allowed stdcost ;drop _type_;
proc sort;by t descending _freq_  ;
proc print;
run;


 


***End;




***Do: Carrier;
 libname betos 'C:\data\Projects\APCD High Cost\Archieve';
proc sql;
create table Carrier as 
select a.*,b.plan1,b.plan2,b.plan3,b.plan4,b.type1,b.type2,b.type3,b.type4 
from APCD.CarrierstdcostCY2011 a inner join APCd.denominator b
on a.SubmissionYear=b.SubmissionYear and a.Memberlinkeid=b.Memberlinkeid and a.orgid=b.orgid;
quit;


proc sql;
create table Carrier1 as
select a.*,b.*
from Carrier a left join betos.betos b
on a.hcpcs=b.hcpcs;
quit;


data Carrier2;
set Carrier1;

i=substr(betos,1,1);
if i='M' then category='Evaluation AND Management';
if i='P' then category='Procedures';
if i='I' then category='Imaging';
if i='T' then category='Tests';
if i='D' then category='Durable Medical Equipment';
if i='O' then do;
	if betos='O1A' then category='Ambulance';
	if betos='O1B' then category='Chiropractic';
	if betos='O1C' then category='Enteral and Parenteral';
	if betos='O1D' then category='Chemotherapy';
    if betos='O1E' then category='Other Drugs';
	if betos='O1F' then category='Vision,Hearing and Speech Services';
	if betos='O1G' then category='Influenza Immunization';
end;
if i in ('Y','Z') then category='Exceptions/Unclassfied';
if i='' then category='Missing HCPCS';
drop i;

if type2='' then t=type1;
else if MedicaidIndicator='True' then do;
	if type1='Medicaid' or type2='Medicaid' then t='Medicaid';
	else if type1='Medicaid Managed Care' or type2='Medicaid Managed Care' then t='Medicaid Managed Care';
end;
else if type1='Medicare Advantage' or type2='Medicare Advantage' then t='Medicare Advantage';
else t='Other Private Plans';
drop plan1 plan2 plan3 plan4 type3 type4; 


keep Memberlinkeid PayerClaimControlNumber allowed stdcost t category ;
 
run;
 

proc means data=Carrier2 ;
class t category;
var stdcost;
output out=stdcost N=N mean=mean std=std min=min Q1=Q1 median=median Q3=Q3 max=max sum=sum;
run;

data stdcost;
set stdcost;
where t ne '';
var='standardized cost';
proc sort;by t category descending _freq_;
run;


proc means data=Carrier2 ;
class t category;
var allowed;
output out=allowed N=N mean=mean std=std min=min Q1=Q1 median=median Q3=Q3 max=max sum=sum;
run;

data allowed;
set allowed;
where t ne '';
var='actual cost';
proc sort;by t category descending _freq_;
run;

data all;
set allowed stdcost;drop _type_;
proc sort;by t descending _freq_ var;
proc print;
run;

***End;


***Do: HH;

proc sql;
create table HHA as 
select a.*,b.type1,b.type2
from apcd.hhacost a inner join APCd.denominator b
on a.SubmissionYear=b.SubmissionYear and a.Memberlinkeid=b.Memberlinkeid and a.orgid=b.orgid
where CY=2011;
quit;
 

data temp;
set HHA;

if type2='' then t=type1;
else if MedicaidIndicator='True' then do;
	if type1='Medicaid' or type2='Medicaid' then t='Medicaid';
	else if type1='Medicaid Managed Care' or type2='Medicaid Managed Care' then t='Medicaid Managed Care';
end;
else if type1='Medicare Advantage' or type2='Medicare Advantage' then t='Medicare Advantage';
else t='Other Private Plans';

if t='Other Private Plans' then cat=3;
if t='Medicare Advantage' then cat=2;
if t='Medicaid Managed Care' then cat=1;
else cat=0;

run;
***End;



***Hospice;
proc sql;
create table temp as 
select a.*,b.type1,b.type2 
from APCD.Hospicestdcost a inner join APCd.denominator b
on a.SubmissionYear=b.SubmissionYear and a.Memberlinkeid=b.Memberlinkeid and a.orgid=b.orgid
where CY=2012;
quit;
   
data temp2;
set temp;
if type2='' then t=type1;
else if MedicaidIndicator='True' then do;
	if type1='Medicaid' or type2='Medicaid' then t='Medicaid';
	else if type1='Medicaid Managed Care' or type2='Medicaid Managed Care' then t='Medicaid Managed Care';
end;
else if type1='Medicare Advantage' or type2='Medicare Advantage' then t='Medicare Advantage';
else t='Other Private Plans';
 
run;
 
proc means data=temp2 ;
class t  ;
var spending;
output out=stdcost N=N mean=mean std=std min=min Q1=Q1 median=median Q3=Q3 max=max sum=sum ;
run;
data stdcost;
set stdcost;
where t ne '';
var='standardized cost';
proc sort;by t descending _freq_ ;
run;

proc means data=temp2 ;
class t  ;
var spending;
output out=allowed N=N mean=mean std=std min=min Q1=Q1 median=median Q3=Q3 max=max sum=sum;
run;
data allowed;
set allowed;
where t ne '';
var='actual cost';
proc sort;by t descending _freq_  ;
run;

data all;
set allowed stdcost ;drop _type_;
proc sort;by t descending _freq_  var;
proc print;
run;
***End;

 


***SNF;
proc sql;
create table temp as 
select a.*,b.type1,b.type2 
from APCD.SNFstdcost a inner join APCd.denominator b
on a.SubmissionYear=b.SubmissionYear and a.Memberlinkeid=b.Memberlinkeid and a.orgid=b.orgid
where CY=2012;
quit;
   
data temp2;
set temp;
if type2='' then t=type1;
else if MedicaidIndicator='True' then do;
	if type1='Medicaid' or type2='Medicaid' then t='Medicaid';
	else if type1='Medicaid Managed Care' or type2='Medicaid Managed Care' then t='Medicaid Managed Care';
end;
else if type1='Medicare Advantage' or type2='Medicare Advantage' then t='Medicare Advantage';
else t='Other Private Plans';
 
run;
 
proc means data=temp2 ;
class t  ;
var spending;
output out=stdcost N=N mean=mean std=std min=min Q1=Q1 median=median Q3=Q3 max=max sum=sum ;
run;
data stdcost;
set stdcost;
where t ne '';
var='standardized cost';
proc sort;by t descending _freq_ ;
run;

proc means data=temp2 ;
class t  ;
var spending;
output out=allowed N=N mean=mean std=std min=min Q1=Q1 median=median Q3=Q3 max=max sum=sum;
run;
data allowed;
set allowed;
where t ne '';
var='actual cost';
proc sort;by t descending _freq_  ;
run;

data all;
set allowed stdcost ;drop _type_;
proc sort;by t descending _freq_  var;
proc print;
run;
***End;

 
