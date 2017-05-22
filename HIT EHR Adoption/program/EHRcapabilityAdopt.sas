*************************************************************************
Objective:		EHR Capability Implemented In At Least One Unit 2013  
				
Written by:		Xiner Zhou

Date:			5/6/2014
************************************************************************;


libname HIT "C:\data\Data\Hospital\AHA\HIT\data";
libname impact "C:\data\Data\Hospital\Impact";
LIBNAME AHA 	"C:\data\Data\Hospital\AHA\Annual_Survey\data";



* Use AHA 2012 for all years;
data aha12;
set aha.aha12;
type=0;
if serv=80 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then type=1; * Long-term Acute Care;
if serv=22 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then type=2; * Psychiatric;
if serv=46 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then type=3; * Rehab;
if serv=10 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then type=4;* General hospitals;

if cluster ^=. then sys=1; else sys=0;
if cicu=. then cicu=2;

keep id type hospsize hosp_reg4 profit2 teaching sys urban cicu;
run;


proc sort data=aha12 out=aha12;
by id;
run;

/**********************************

Medication list--q1e1
Computerized provider order entry-q1c3 
Drug allergy alerts--q1c4
Radiology images--q1c2
Lab reports--q1a2
Advance directives--q1g1
Discharge summary--q1f1

***************************************/


proc sort data=hit.hit13 out=hit13(keep= q1e1 q1c3 q1c4 q1c2 q1a2 q1g1 q1f1 id);
by id;
run;


data ahahit13;
merge aha12(in=in1) hit13(in=in2);
by id;
if in1;
respond=in2;  * respond =1 if respond to HIT Survey;
run;

* Use Logistic regression to estimate the probability of Responding to HIT Survey by:
	--Hospital size
	--Hospital Region
	--Government/For-profit
	--Teaching Status
	--Hospsys
	--Urban
	--CICU
;
proc logistic data=ahahit13;
	class respond(ref="0") hospsize(ref="1")  hosp_reg4(ref="1") profit2(ref="1") teaching(ref="3") sys(ref="1") urban(ref="1") cicu(ref="0")/param=ref;
	model respond  = hospsize hosp_reg4 profit2 teaching sys urban cicu; 
	output  out=ahahit13 p=prob;  
run;

* Now we have all the info in this dataset;
data ahahit13;
	set ahahit13;
	if q1e1 in (1,2) then cap1=1;else cap1=0;
	if q1c3 in (1,2) then cap2=1;else cap2=0;
	if q1c4 in (1,2) then cap3=1;else cap3=0;
	if q1c2 in (1,2) then cap4=1;else cap4=0;
    if q1a2 in (1,2) then cap5=1;else cap5=0;
	if q1g1 in (1,2) then cap6=1;else cap6=0;
	if q1f1 in (1,2) then cap7=1;else cap7=0;
	wt=1/prob;
	drop prob;
	if type in (1,2,3,4);
run;


%macro capability(cap=);

* Percentage Weighted/Unweighted;
proc means data=ahahit13;
class type;
var &cap.;
weight wt;
output out=&cap. mean=pct;
run;

data &cap.;
set &cap.;
if type ^=.;
keep type pct;
run;

proc transpose data=&cap. out=&cap.(drop=_NAME_);
var pct;
run;

data &cap.;
set &cap.;
rename col1=ltac;
rename col2=psy;
rename col3=rehab;
rename col4=gen;
run;


* p-value;
proc glm data=ahahit13;
class type;
model &cap.=type;
weight wt;
run;


%mend capability;

%capability(cap=cap1)
%capability(cap=cap2)
%capability(cap=cap3)
%capability(cap=cap4)
%capability(cap=cap5)
%capability(cap=cap6)
%capability(cap=cap7) 

data table;
set cap1 cap2 cap3 cap4 cap5 cap6 cap7;
run;




***************************
Step 4: Output to Excel
***************************;

ods _all_ close;
ods tagsets.ExcelXP path='C:\data\Projects\HIT EHR Adoption\output' file='EHR Adoption Rate.xml' style=Printer;
ods tagsets.ExcelXP options(embedded_titles='yes');

title 'Hospitals In Which Electronic Health Record Capabilities Have Been Implemented In At Least One Unit, 2013';

proc print data=table noobs style(Header)=[just=center];
	var ltac;var psy;var rehab; var gen;
run;
quit;

ods tagsets.ExcelXP close;
 
