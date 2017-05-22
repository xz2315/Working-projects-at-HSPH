*************************************************************************
Objective:		EHR Adoption Rate for 3 types of Non-general Hospitals
				not stratified by SYS
Written by:		Xiner Zhou
Date:			4/30/2014
************************************************************************;

libname HIT "C:\data\Data\Hospital\AHA\HIT\data";
libname impact "C:\data\Data\Hospital\Impact";
LIBNAME AHA 	"C:\data\Data\Hospital\AHA\Annual_Survey\data";

 

****************************************************************************************************
***************************************Year 2013****************************************************
****************************************************************************************************

* Check Data frequencies first;
/*
proc contents data=aha.aha12;run;
ods html;
proc freq data=aha.aha12;tables serv hospsize hosp_reg4 profit2 teaching urban cicu;run;
*/


data aha12;
set aha.aha12;

if serv=80 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then ahag1=1;else ahag1=0; * Long-term Acute Care;
if serv=22 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then ahag2=1;else ahag2=0; * Psychiatric;
if serv=46 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then ahag3=1;else ahag3=0; * Rehab;
if serv=10 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then ahag4=1;else ahag4=0;* General hospitals;

if cluster ^=. then sys=1; else sys=0;
if cicu=. then cicu=2;

keep id ahag1 ahag2 ahag3 ahag4 hospsize hosp_reg4 profit2 teaching sys urban cicu;
run;


proc sort data=aha12 out=aha12;
by id;
run;
proc sort data=hit.hit13 out=hit13(keep= q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 id sr_name org_name);
by id;
run;


data ahahit13;
merge aha12(in=in1) hit13(in=in2);
by id;
if in1;
respond=in2;
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



%macro fun1(group=);



data sub&group;
set ahahit13;
if &group=1 and respond=1;
run;
 

data sub&group;
	set sub&group;
	 
	array basic {10}  q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3;
 	total=0;
	do i= 1 to dim(basic);
		if basic(i) in (1,2) then total=total+1;
	end;
	drop i;
		 
	if total=10 then basic_adopt=1;else basic_adopt=0;  

	wt=1/prob;
run;

proc means data=sub&group noprint;
var basic_adopt;
weight wt;
output out=out_&group mean=rate;

var respond;
output out=count_&group N=samplesize;
run;

data out_&group;
retain type;
set out_&group;
type="&group.";
keep rate type;
run;

data count_&group;
retain type;
set count_&group;
type="&group.";
keep samplesize type;
run;

data out_&group;
merge out_&group count_&group;
by type;
run;
 

%mend fun1;

%fun1(group=ahag1)
%fun1(group=ahag2)
%fun1(group=ahag3)
%fun1(group=ahag4)

data out13;
set out_ahag1 out_ahag2 out_ahag3 out_ahag4;
run;
 
 








****************************************************************************************************
***************************************Year 2011-12****************************************************
****************************************************************************************************;

libname HIT1112 "C:\data\Data\Hospital\AHA\HIT\Data\fromshare_Projects-HIT2012-data-stata";
/*
* Check Data frequencies first;
proc sort data=hit1112.Finalitfeb7 out=data2(keep=q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 id sr_name org_name);by id;run;
proc sort data=hit1112.Finalitfeb4 out=data1(keep=q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 id sr_name org_name);by id;run;


proc sort data=aha.aha12 out=aha(keep=id serv);by id;run;

data test;
merge aha(in=in1) data2(in=in2);
a=in1;
b=in2;

run;

data test;
set test;
if serv=46 and b=1;
run;


proc contents data=aha.aha12;run;
ods html;
proc freq data=aha.aha12;tables serv hospsize hosp_reg4 profit2 teaching urban cicu;run;
*/

data aha12;
set aha.aha12;

if serv=80 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then ahag1=1;else ahag1=0; * Long-term Acute Care;
if serv=22 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then ahag2=1;else ahag2=0; * Psychiatric;
if serv=46 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then ahag3=1;else ahag3=0; * Rehab;
if serv=10 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then ahag4=1;else ahag4=0;* General hospitals;

if cluster ^=. then sys=1; else sys=0;
if cicu=. then cicu=2;

keep id ahag1 ahag2 ahag3 ahag4 hospsize hosp_reg4 profit2 teaching sys urban cicu;
run;


proc sort data=aha12 out=aha12;
by id;
run;
proc sort data=hit1112.Finalitfeb7 out=hit1112(keep=q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 id sr_name org_name);
by id;
run;


data ahahit1112;
merge aha12(in=in1) hit1112(in=in2);
by id;
if in1;
respond=in2;
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
proc logistic data=ahahit1112;
	class respond(ref="0") hospsize(ref="1")  hosp_reg4(ref="1") profit2(ref="1") teaching(ref="3") sys(ref="1") urban(ref="1") cicu(ref="0")/param=ref;
	model respond  = hospsize hosp_reg4 profit2 teaching sys urban cicu; 
	output  out=ahahit1112 p=prob;  
run;




%macro fun1(group=);



data sub&group;
set ahahit1112;
if &group=1 and respond=1;
run;
 

data sub&group;
	set sub&group;
	 
	array basic {10}  q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3;
 	total=0;
	do i= 1 to dim(basic);
		if basic(i) in (1,2) then total=total+1;
	end;
	drop i;
		 
	if total=10 then basic_adopt=1;else basic_adopt=0;  

	wt=1/prob;
run;

proc means data=sub&group noprint;
var basic_adopt;
weight wt;
output out=out_&group mean=rate;

var respond;
output out=count_&group N=samplesize;
run;

data out_&group;
retain type;
set out_&group;
type="&group.";
keep rate type;
run;

data count_&group;
retain type;
set count_&group;
type="&group.";
keep samplesize type;
run;

data out_&group;
merge out_&group count_&group;
by type;
run;
 

%mend fun1;

%fun1(group=ahag1)
%fun1(group=ahag2)
%fun1(group=ahag3)
%fun1(group=ahag4)


data out1112;
set out_ahag1 out_ahag2 out_ahag3 out_ahag4;
run;

 







****************************************************************************************************
***************************************Year 2010****************************************************
****************************************************************************************************

* Check Data frequencies first;
/*
proc contents data=aha.aha11;run;
ods html;
proc freq data=aha.aha11;tables serv hospsize hosp_reg4 profit2 teaching urban cicu;run;
*/
 

data aha11;
set aha.aha11;

if serv=80 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then ahag1=1;else ahag1=0; * Long-term Acute Care;
if serv=22 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then ahag2=1;else ahag2=0; * Psychiatric;
if serv=46 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then ahag3=1;else ahag3=0; * Rehab;
if serv=10 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then ahag4=1;else ahag4=0;* General hospitals;

if cluster ^=. then sys=1; else sys=0;
if cicu=. then cicu=2;
 
keep id ahag1 ahag2 ahag3 ahag4 hospsize hosp_reg4 profit2 teaching sys urban cicu;
run;


proc sort data=aha11 out=aha11;
by id;
run;
proc sort data=hit.hit10 out=hit10(keep= q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_a2 q1_b2 q1_d2 q1_c3 id sr_name org_name);
by id;
run;


data ahahit10;
merge aha11(in=in1) hit10(in=in2);
by id;
if in1;
respond=in2;
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
proc logistic data=ahahit10;
	class respond(ref="0") hospsize(ref="1")  hosp_reg4(ref="1") profit2(ref="1") teaching(ref="3") sys(ref="1") urban(ref="1") cicu(ref="0")/param=ref;
	model respond  = hospsize hosp_reg4 profit2 teaching sys urban cicu; 
	output  out=ahahit10 p=prob;  
run;



%macro fun1(group=);



data sub&group;
set ahahit10;
if &group=1 and respond=1;
run;
 

data sub&group;
	set sub&group;
	 
	array basic {10}  q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_a2 q1_b2 q1_d2 q1_c3;
 	total=0;
	do i= 1 to dim(basic);
		if basic(i) in (1,2) then total=total+1;
	end;
	drop i;
		 
	if total=10 then basic_adopt=1;else basic_adopt=0;  

	wt=1/prob;
run;

proc means data=sub&group noprint;
var basic_adopt;
weight wt;
output out=out_&group mean=rate;

var respond;
output out=count_&group N=samplesize;
run;

data out_&group;
retain type;
set out_&group;
type="&group.";
keep rate type;
run;

data count_&group;
retain type;
set count_&group;
type="&group.";
keep samplesize type;
run;

data out_&group;
merge out_&group count_&group;
by type;
run;
 

%mend fun1;
%fun1(group=ahag1)
%fun1(group=ahag2)
%fun1(group=ahag3)
%fun1(group=ahag4)

 
data out10;
set out_ahag1 out_ahag2 out_ahag3 out_ahag4;
run;







****************************************************************************************************
***************************************Year 2009****************************************************
****************************************************************************************************

* Check Data frequencies first;
/*
proc contents data=aha.aha10;run;
ods html;
proc freq data=aha.aha10;tables serv hospsize hosp_reg4 profit2 teaching urban cicu;run;
*/

data aha10;
set aha.aha10;

if serv=80 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then ahag1=1;else ahag1=0; * Long-term Acute Care;
if serv=22 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then ahag2=1;else ahag2=0; * Psychiatric;
if serv=46 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then ahag3=1;else ahag3=0; * Rehab;
if serv=10 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then ahag4=1;else ahag4=0;* General hospitals;

if cluster ^=. then sys=1; else sys=0;
if cicu=. then cicu=2;
if hospsize ^=. ;
keep id ahag1 ahag2 ahag3 ahag4 hospsize hosp_reg4 profit2 teaching sys urban cicu;
run;


proc sort data=aha10 out=aha10;
by id;
run;
proc sort data=hit.hit09 out=hit09(keep= q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 id sr_name org_name);
by id;
run;


data ahahit09;
merge aha10(in=in1) hit09(in=in2);
by id;
if in1;
respond=in2;
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
proc logistic data=ahahit09;
	class respond(ref="0") hospsize(ref="1")  hosp_reg4(ref="1") profit2(ref="1") teaching(ref="3") sys(ref="1") urban(ref="1") cicu(ref="0")/param=ref;
	model respond  = hospsize hosp_reg4 profit2 teaching sys urban cicu; 
	output  out=ahahit09 p=prob;  
run;



%macro fun1(group=);



data sub&group;
set ahahit09;
if &group=1 and respond=1;
run;
 

data sub&group;
	set sub&group;
	 
	array basic {10}  q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3;
 	total=0;
	do i= 1 to dim(basic);
		if basic(i) in (1,2) then total=total+1;
	end;
	drop i;
		 
	if total=10 then basic_adopt=1;else basic_adopt=0;  

	wt=1/prob;
run;

proc means data=sub&group noprint;
var basic_adopt;
weight wt;
output out=out_&group mean=rate;

var respond;
output out=count_&group N=samplesize;
run;

data out_&group;
retain type;
set out_&group;
type="&group.";
keep rate type;
run;

data count_&group;
retain type;
set count_&group;
type="&group.";
keep samplesize type;
run;

data out_&group;
merge out_&group count_&group;
by type;
run;
 

%mend fun1;



%fun1(group=ahag1)
%fun1(group=ahag2)
%fun1(group=ahag3)
%fun1(group=ahag4)

 
data out09;
set out_ahag1 out_ahag2 out_ahag3 out_ahag4;
run;



























****************************************************************************************************
***************************************Year 2008****************************************************
****************************************************************************************************

* Check Data frequencies first;
/*
proc contents data=aha.aha09;run;
ods html;
proc freq data=aha.aha09;tables serv hospsize hosp_reg4 profit2 teaching urban cicu;run;
*/

data aha09;
set aha.aha09;

if serv=80 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then ahag1=1;else ahag1=0; * Long-term Acute Care;
if serv=22 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then ahag2=1;else ahag2=0; * Psychiatric;
if serv=46 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then ahag3=1;else ahag3=0; * Rehab;
if serv=10 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then ahag4=1;else ahag4=0;* General hospitals;

if cluster ^=. then sys=1; else sys=0;
if cicu=. then cicu=2;
if profit2 ^=. ;
keep id ahag1 ahag2 ahag3 ahag4 hospsize hosp_reg4 profit2 teaching sys urban cicu;
run;


proc sort data=aha09 out=aha09;
by id;
run;
proc sort data=hit.hit08 out=hit08(keep= q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_a2 q1_b2 q1_d2 q1_c3 id sr_name org_name);
by id;
run;


data ahahit08;
merge aha09(in=in1) hit08(in=in2);
by id;
if in1;
respond=in2;
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
proc logistic data=ahahit08;
	class respond(ref="0") hospsize(ref="1")  hosp_reg4(ref="1") profit2(ref="1") teaching(ref="3") sys(ref="1") urban(ref="1") cicu(ref="0")/param=ref;
	model respond  = hospsize hosp_reg4 profit2 teaching sys urban cicu; 
	output  out=ahahit08 p=prob;  
run;



%macro fun1(group=);



data sub&group;
set ahahit08;
if &group=1 and respond=1;
run;
 

data sub&group;
	set sub&group;
	 
	array basic {10}  q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_a2 q1_b2 q1_d2 q1_c3;
 	total=0;
	do i= 1 to dim(basic);
		if basic(i) in (1,2) then total=total+1;
	end;
	drop i;
		 
	if total=10 then basic_adopt=1;else basic_adopt=0;  

	wt=1/prob;
run;

proc means data=sub&group noprint;
var basic_adopt;
weight wt;
output out=out_&group mean=rate;

var respond;
output out=count_&group N=samplesize;
run;

data out_&group;
retain type;
set out_&group;
type="&group.";
keep rate type;
run;

data count_&group;
retain type;
set count_&group;
type="&group.";
keep samplesize type;
run;

data out_&group;
merge out_&group count_&group;
by type;
run;
 

%mend fun1;

%fun1(group=ahag1)
%fun1(group=ahag2)
%fun1(group=ahag3)
%fun1(group=ahag4)

 

data out08;
set out_ahag1 out_ahag2 out_ahag3 out_ahag4;
run;






















****************************************************************************************************
***************************************Year 2007****************************************************
****************************************************************************************************

* Check Data frequencies first;
/*
proc contents data=aha.aha09;run;
ods html;
proc freq data=aha.aha09;tables serv hospsize hosp_reg4 profit2 teaching urban cicu;run;
*/

data aha09;
set aha.aha09;

if serv=80 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then ahag1=1;else ahag1=0; * Long-term Acute Care;
if serv=22 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then ahag2=1;else ahag2=0; * Psychiatric;
if serv=46 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then ahag3=1;else ahag3=0; * Rehab;
if serv=10 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then ahag4=1;else ahag4=0;* General hospitals;

if cluster ^=. then sys=1; else sys=0;
if cicu=. then cicu=2;
if profit2 ^=. ;
keep id ahag1 ahag2 ahag3 ahag4 hospsize hosp_reg4 profit2 teaching sys urban cicu;
run;


proc sort data=aha09 out=aha09;
by id;
run;
proc sort data=hit.hit07 out=hit07(keep= q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 id sr_name org_name);
by id;
run;


data ahahit07;
merge aha09(in=in1) hit07(in=in2);
by id;
if in1;
respond=in2;
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
proc logistic data=ahahit07;
	class respond(ref="0") hospsize(ref="1")  hosp_reg4(ref="1") profit2(ref="1") teaching(ref="3") sys(ref="1") urban(ref="1") cicu(ref="0")/param=ref;
	model respond  = hospsize hosp_reg4 profit2 teaching sys urban cicu; 
	output  out=ahahit07 p=prob;  
run;



%macro fun1(group=);



data sub&group;
set ahahit07;
if &group=1 and respond=1;
run;
 

data sub&group;
	set sub&group;
	 
	array basic {10}  q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 ;
 	total=0;
	do i= 1 to dim(basic);
		if basic(i) in (1,2) then total=total+1;
	end;
	drop i;
		 
	if total=10 then basic_adopt=1;else basic_adopt=0;  

	wt=1/prob;
run;

proc means data=sub&group noprint;
var basic_adopt;
weight wt;
output out=out_&group mean=rate;

var respond;
output out=count_&group N=samplesize;
run;

data out_&group;
retain type;
set out_&group;
type="&group.";
keep rate type;
run;

data count_&group;
retain type;
set count_&group;
type="&group.";
keep samplesize type;
run;

data out_&group;
merge out_&group count_&group;
by type;
run;
 

%mend fun1;

%fun1(group=ahag1)
%fun1(group=ahag2)
%fun1(group=ahag3)
%fun1(group=ahag4)

 
data out07;
set out_ahag1 out_ahag2 out_ahag3 out_ahag4;
run;





******************************************Merge All YEar*********************
****************************************************************************;
data out07;set out07;rename rate=adopt07;rename samplesize=N07;run;
data out08;set out08;rename rate=adopt08;rename samplesize=N08;run;
data out09;set out09;rename rate=adopt09;rename samplesize=N09;run;
data out10;set out10;rename rate=adopt10;rename samplesize=N10;run;
data out1112;set out1112;rename rate=adopt1112;rename samplesize=N1112;run;
data out13;set out13;rename rate=adopt13;rename samplesize=N13;run;
proc sort data=out07;by type;run;
proc sort data=out08;by type;run;
proc sort data=out09;by type;run;
proc sort data=out10;by type;run;
proc sort data=out1112;by type;run;
proc sort data=out13;by type;run;

* Dataset for output;
data out;
merge out07 out08 out09 out10 out1112 out13;
by type;
run;


* Dataset for plot;
proc transpose data=out(keep=type adopt07 adopt08 adopt09 adopt10 adopt1112 adopt13) out=out1;
var adopt07 adopt08 adopt09 adopt10 adopt1112 adopt13;
id type;
run;


data out1;
set out1;
a="2008 2009 2010 2011 2012 2013";
m=_n_;
year=substr(a,(m-1)*5+1,4);
/*
array group {4} ahag1 ahag2 ahag3 ahag4;
do i=1 to 4;
if group{i}=. then group{i}=0;
end;
*/
 
drop _name_ a m;
run;





******************************Output to Excel*********************
******************************************************************;

ods _all_ close;
ods tagsets.ExcelXP path='C:\data\Projects\HIT EHR Adoption\output' file='NotStratify.xml' style=Printer;
ods tagsets.ExcelXP options(embedded_titles='yes');

title 'At Least Basic EHR Adoption Rate 2008-2013';
title 'Not Stratify by SYS';

 proc print data=out noobs style(Header)=[just=center];
	var type/ style(Column)=[background=#FFFFCC just=c];
	var adopt07/style(Column)=[background=#ccccff just=c];
	var N07/style(Column)=[background=#ccccff just=c];
	var adopt08/style(Column)=[background=#ccccff just=c];
	var N08/style(Column)=[background=#ccccff just=c];
	var adopt09/ style(Column)=[background=#ccffff just=c] ;
	var N09/style(Column)=[background=#ccccff just=c];
	var adopt10/ style(Column)=[background=#ccccff just=c] ;
	var N10/style(Column)=[background=#ccccff just=c];
	var adopt1112/ style(Column)=[background=#ccccff just=c] ;
	var N1112/style(Column)=[background=#ccccff just=c];
	var adopt13/ style(Column)=[background=#ccccff just=c] ;
	var N13/style(Column)=[background=#ccccff just=c];
run;
quit;


ods tagsets.ExcelXP close;
 

***************************************Plot**********************
*****************************************************************;
proc sgplot data=out1;

series X=year y=ahag4 /datalabel=ahag4 LEGENDLABEL="Genral Hospitals" MARKERS LINEATTRS = (THICKNESS = 4 color=H09650FF); 
series X=year y=ahag3 /datalabel=ahag3 LEGENDLABEL="Rehab" MARKERS LINEATTRS = (THICKNESS = 3 color=H12C80FF); 
series X=year y=ahag2 /datalabel=ahag2 LEGENDLABEL="Psychiatric" MARKERS LINEATTRS = (THICKNESS = 2 color=H0DF45E6); 
series X=year y=ahag1 /datalabel=ahag1 LEGENDLABEL="Long-term Acute Care " MARKERS LINEATTRS = (THICKNESS = 1 color=H06480FF);
format ahag4 percent8.2;
format ahag3 percent8.2;
format ahag2 percent8.2;
format ahag1 percent8.2;
label ahag4="Adoption Rate" year="Year";
run; 




proc sgplot data=out1;
xaxis type=discrete;

series X=year y=ahag1 /datalabel=ahag1 MARKERS LINEATTRS = (THICKNESS = 1 color=H06480FF); 
 
format ahag1 percent8.2;
 
label ahag1="Rate" year="Year";
title "At Least Basic EHR Adoption Rate for Long-term Acute Care Hospitals";
run; 

proc sgplot data=out1;
xaxis type=discrete;
series X=year y=ahag2 /datalabel=ahag2 MARKERS LINEATTRS = (THICKNESS = 2 color=H0DF45E6); 
 
format ahag2 percent8.2;
 
label ahag2="Rate" year="Year";
title "At Least Basic EHR Adoption Rate for Psychiatric Hospitals";
run; 

proc sgplot data=out1;
xaxis type=discrete;
series X=year y=ahag3 /datalabel=ahag3 MARKERS LINEATTRS = (THICKNESS = 3 color=H12C80FF) ; 
 
format ahag3 percent8.2;
 
label ahag3="Rate" year="Year";
title "At Least Basic EHR Adoption Rate for Rehab Hospitals";
run; 


proc sgplot data=out1;
xaxis type=discrete;
 
series X=year y=ahag4 /datalabel=ahag4 MARKERS LINEATTRS = (THICKNESS = 4 color=H09650FF);  
 
format ahag4 percent8.2;
 
label ahag4="Rate" year="Year";
title "At Least Basic EHR Adoption Rate for Genral Hospitals";
run; 
