*************************************************************************
Objective:		Logistic Regression:
				EHR basic adoption=size+system
Written by:		Xiner Zhou
Date:			5/01/2014
************************************************************************;

libname HIT "C:\data\Data\Hospital\AHA\HIT\data";
libname impact "C:\data\Data\Hospital\Impact";
LIBNAME AHA 	"C:\data\Data\Hospital\AHA\Annual_Survey\data";

* Compare AHA all years dara;
/*
proc sort data=aha.aha12 out=aha12(keep=id);by id;run;
proc sort data=aha.aha11 out=aha11(keep=id);by id;run;
proc sort data=aha.aha10 out=aha10(keep=id);by id;run;
proc sort data=aha.aha09 out=aha09(keep=id);by id;run;
proc sort data=aha.aha08 out=aha08(keep=id);by id;run;
proc sort data=aha.aha07 out=aha07(keep=id);by id;run;
proc sort data=aha.aha06 out=aha06(keep=id);by id;run;
proc sort data=aha.aha05 out=aha05(keep=id);by id;run;
proc sort data=aha.aha04 out=aha04(keep=id);by id;run;
proc sort data=aha.aha03 out=aha03(keep=id);by id;run;
data allyear;
merge aha12(in=in12) aha11(in=in11) aha10(in=in10) aha09(in=in09)
aha08(in=in08) aha07(in=in07) aha06(in=in06) aha05(in=in05) aha04(in=in04) aha03(in=in03);
f12=in12;f11=in11;f10=in10;f09=in09;f08=in08;f07=in07;f06=in06;f05=in05;f04=in04;f03=in03;
by id;
run;
data allyear;
set allyear;
retain c12 0;retain c11 0;retain c10 0;retain c09 0;retain c08 0;
retain c07 0;retain c06 0;retain c05 0;retain c04 0;retain c03 0;
array flag {10} f12 f11 f10 f09 f08 f07 f06 f05 f04 f03;
array c {10} c12 c11 c10 c09 c08 c07 c06 c05 c04 c03;

do i=1 to 10;
	if flag{i}=1 then c{i}=c{i}+1;
end;
drop i;
run;
*/


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
proc sort data=hit.hit13 out=hit13(keep= q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 id);
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


data ahahit13;
	set ahahit13;
	 
	array basic {10}  q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3;
 	total=0;
	do i= 1 to dim(basic);
		if basic(i) in (1,2) then total=total+1;
	end;
	drop i;
		 
	if total=10 then basic_adopt=1;else basic_adopt=0;  

	wt=1/prob;
run;

data test1;
set ahahit13;
where ahag1=1 and hospsize=3;
run;
proc means data=test1 ;
var basic_adopt;
output out=test sum/N=unadj;
run;

 
%macro fun1(group=,year=);



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


proc genmod data=sub&group descending;
	weight wt;
	class sys hospsize;
	model basic_adopt=sys hospsize/dist=bin link=logit;
	lsmeans hospsize;
	ods output LSMeans=lsmeans_&year._&group.;
run;

data lsmeans_&year._&group.;
set lsmeans_&year._&group.;
EHRrate=exp(estimate)/(1+exp(estimate));
Run;

* unadjust;
%macro unadj(size=);
data temp;
set sub&group;
where hospsize=&size.;
run;


proc means data=temp noprint;
var basic_adopt;
output out=unadj_&year._&group._size&size. sum=N_adopt&year._&group._size&size. N=N_resp&year._&group._size&size.;
run;

data unadj_&year._&group._size&size.;
retain rate_unadj_&year._&group._size&size.;
set unadj_&year._&group._size&size.;
rate_unadj_&year._&group._size&size.=N_adopt&year._&group._size&size./N_resp&year._&group._size&size.;
keep rate_unadj_&year._&group._size&size. N_adopt&year._&group._size&size. N_resp&year._&group._size&size.;
run;
%mend unadj;
%unadj(size=1);
%unadj(size=2);
%unadj(size=3);

%mend fun1;

%fun1(group=ahag1,year=13)
%fun1(group=ahag2,year=13)
%fun1(group=ahag3,year=13)
%fun1(group=ahag4,year=13)

* Make a table for N_resp;
data ;


* Make a table for unadjusted adoption rate;








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




%macro fun1(group=,year=);



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
proc genmod data=sub&group descending;
	weight wt;
	class sys hospsize;
	model basic_adopt=sys hospsize/dist=bin link=logit;
	lsmeans hospsize;
	ods output LSMeans=lsmeans_&year._&group.;
run;

data lsmeans_&year._&group.;
set lsmeans_&year._&group.;
EHRrate=exp(estimate)/(1+exp(estimate));
Run;

%mend fun1;

%fun1(group=ahag1,year=1112)
%fun1(group=ahag2,year=1112)
%fun1(group=ahag3,year=1112)
%fun1(group=ahag4,year=1112)

 





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



%macro fun1(group=,year=);



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
proc genmod data=sub&group descending;
	weight wt;
	class sys hospsize;
	model basic_adopt=sys hospsize/dist=bin link=logit;
	lsmeans hospsize;
	ods output LSMeans=lsmeans_&year._&group.;
run;

data lsmeans_&year._&group.;
set lsmeans_&year._&group.;
EHRrate=exp(estimate)/(1+exp(estimate));
Run;

%mend fun1;

%fun1(group=ahag1,year=10)
%fun1(group=ahag2,year=10)
%fun1(group=ahag3,year=10)
%fun1(group=ahag4,year=10)

 




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


%macro fun1(group=,year=);



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

proc genmod data=sub&group descending;
	weight wt;
	class sys hospsize;
	model basic_adopt=sys hospsize/dist=bin link=logit;
	lsmeans hospsize;
	ods output LSMeans=lsmeans_&year._&group.;
run;

data lsmeans_&year._&group.;
set lsmeans_&year._&group.;
EHRrate=exp(estimate)/(1+exp(estimate));
Run;

%mend fun1;

%fun1(group=ahag1,year=09)
%fun1(group=ahag2,year=09)
%fun1(group=ahag3,year=09)
%fun1(group=ahag4,year=09)

 







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


%macro fun1(group=,year=);



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

proc genmod data=sub&group descending;
	weight wt;
	class sys hospsize;
	model basic_adopt=sys hospsize/dist=bin link=logit;
	lsmeans hospsize;
	ods output LSMeans=lsmeans_&year._&group.;
run;

data lsmeans_&year._&group.;
set lsmeans_&year._&group.;
EHRrate=exp(estimate)/(1+exp(estimate));
Run;

%mend fun1;

%fun1(group=ahag1,year=08)
%fun1(group=ahag2,year=08)
%fun1(group=ahag3,year=08)
%fun1(group=ahag4,year=08)

 











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


%macro fun1(group=,year=);



data sub&group;
set ahahit07;
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

proc genmod data=sub&group descending;
	weight wt;
	class sys hospsize;
	model basic_adopt=sys hospsize/dist=bin link=logit;
	lsmeans hospsize;
	ods output LSMeans=lsmeans_&year._&group.;
run;

data lsmeans_&year._&group.;
set lsmeans_&year._&group.;
EHRrate=exp(estimate)/(1+exp(estimate));
Run;

%mend fun1;

%fun1(group=ahag1,year=07)
%fun1(group=ahag2,year=07)
%fun1(group=ahag3,year=07)
%fun1(group=ahag4,year=07)

 


******************************************Merge All Year*********************
****************************************************************************;
%macro clean(file=);
proc transpose data=&file. out=&file.(drop=_name_);
var EHRrate;
run;
data &file. ;
set &file. ;
rename col1=Small;
rename col2=Median;
rename col3=Large;
run;
%mend clean;



*General Hospitals;
%clean(file=lsmeans_07_ahag4)
%clean(file=lsmeans_08_ahag4)
%clean(file=lsmeans_09_ahag4)
%clean(file=lsmeans_10_ahag4)
%clean(file=lsmeans_1112_ahag4)
%clean(file=lsmeans_13_ahag4)

data general;
retain year;
set lsmeans_07_ahag4 lsmeans_08_ahag4 lsmeans_09_ahag4 lsmeans_10_ahag4 lsmeans_1112_ahag4 lsmeans_13_ahag4;
a="2008 2009 2010 2011 2012 2013";
m=_n_;
year=substr(a,(m-1)*5+1,4);
/*
array group {4} ahag1 ahag2 ahag3 ahag4;
do i=1 to 4;
if group{i}=. then group{i}=0;
end;
*/
 
drop a m;
run;





* LTAC;
%clean(file=lsmeans_07_ahag1)
%clean(file=lsmeans_08_ahag1)
%clean(file=lsmeans_09_ahag1)
%clean(file=lsmeans_10_ahag1)
%clean(file=lsmeans_1112_ahag1)
%clean(file=lsmeans_13_ahag1)

data LTAC;
retain year;
set lsmeans_07_ahag1 lsmeans_08_ahag1 lsmeans_09_ahag1 lsmeans_10_ahag1 lsmeans_1112_ahag1 lsmeans_13_ahag1;
a="2008 2009 2010 2011 2012 2013";
m=_n_;
year=substr(a,(m-1)*5+1,4);
/*
array group {4} ahag1 ahag2 ahag3 ahag4;
do i=1 to 4;
if group{i}=. then group{i}=0;
end;
*/
 
drop a m;
run;






* Psychiatric;
%clean(file=lsmeans_07_ahag2)
%clean(file=lsmeans_08_ahag2)
%clean(file=lsmeans_09_ahag2)
%clean(file=lsmeans_10_ahag2)
%clean(file=lsmeans_1112_ahag2)
%clean(file=lsmeans_13_ahag2)

data Psychiatric;
retain year;
set lsmeans_07_ahag2 lsmeans_08_ahag2 lsmeans_09_ahag2 lsmeans_10_ahag2 lsmeans_1112_ahag2 lsmeans_13_ahag2;
a="2008 2009 2010 2011 2012 2013";
m=_n_;
year=substr(a,(m-1)*5+1,4);
/*
array group {4} ahag1 ahag2 ahag3 ahag4;
do i=1 to 4;
if group{i}=. then group{i}=0;
end;
*/
 
drop a m;
run;



* Rehab;
%clean(file=lsmeans_07_ahag3)
%clean(file=lsmeans_08_ahag3)
%clean(file=lsmeans_09_ahag3)
%clean(file=lsmeans_10_ahag3)
%clean(file=lsmeans_1112_ahag3)
%clean(file=lsmeans_13_ahag3)

data Rehab;
retain year;
set lsmeans_07_ahag3 lsmeans_08_ahag3 lsmeans_09_ahag3 lsmeans_10_ahag3 lsmeans_1112_ahag3 lsmeans_13_ahag3;
a="2008 2009 2010 2011 2012 2013";
m=_n_;
year=substr(a,(m-1)*5+1,4);
/*
array group {4} ahag1 ahag2 ahag3 ahag4;
do i=1 to 4;
if group{i}=. then group{i}=0;
end;
*/
 
drop a m;
run;







***************************************Plot by Size**********************
*****************************************************************;

*General;

proc sgplot data=general;
series X=year y=small/datalabel=small LEGENDLABEL="Small Hospitals" MARKERS LINEATTRS = (THICKNESS = 4 color=H09650FF); 
series X=year y=median /datalabel=median LEGENDLABEL="Median Hospitals" MARKERS LINEATTRS = (THICKNESS = 3 color=H12C80FF); 
series X=year y=large /datalabel=large LEGENDLABEL="Large Hospitals" MARKERS LINEATTRS = (THICKNESS = 2 color=H0DF45E6); 
 
format small percent8.2;
format median  percent8.2;
format large percent8.2;
 
label small="Rate" year="Year";
title "General Hospital";
run; 

*Long Term Acute Care;

proc sgplot data=LTAC;
series X=year y=small/datalabel=small LEGENDLABEL="Small Hospitals" MARKERS LINEATTRS = (THICKNESS = 4 color=H09650FF); 
series X=year y=median /datalabel=median LEGENDLABEL="Median Hospitals" MARKERS LINEATTRS = (THICKNESS = 3 color=H12C80FF); 
series X=year y=large /datalabel=large LEGENDLABEL="Large Hospitals" MARKERS LINEATTRS = (THICKNESS = 2 color=H0DF45E6); 
 
format small percent8.2;
format median  percent8.2;
format large percent8.2;
 
label small="Rate" year="Year";
title "Long Term Acute Care";
run; 

*Psychiatric;

proc sgplot data=Psychiatric;
series X=year y=small/datalabel=small LEGENDLABEL="Small Hospitals" MARKERS LINEATTRS = (THICKNESS = 4 color=H09650FF); 
series X=year y=median /datalabel=median LEGENDLABEL="Median Hospitals" MARKERS LINEATTRS = (THICKNESS = 3 color=H12C80FF); 
series X=year y=large /datalabel=large LEGENDLABEL="Large Hospitals" MARKERS LINEATTRS = (THICKNESS = 2 color=H0DF45E6); 
 
format small percent8.2;
format median  percent8.2;
format large percent8.2;
 
label small="Rate" year="Year";
title "Psychiatric";
run; 


*Rehab;

proc sgplot data=Rehab;
series X=year y=small/datalabel=small LEGENDLABEL="Small Hospitals" MARKERS LINEATTRS = (THICKNESS = 4 color=H09650FF); 
series X=year y=median /datalabel=median LEGENDLABEL="Median Hospitals" MARKERS LINEATTRS = (THICKNESS = 3 color=H12C80FF); 
series X=year y=large /datalabel=large LEGENDLABEL="Large Hospitals" MARKERS LINEATTRS = (THICKNESS = 2 color=H0DF45E6); 
 
format small percent8.2;
format median  percent8.2;
format large percent8.2;
 
label small="Rate" year="Year";
title "Rehab";
run; 







******************************Output to Excel*********************
******************************************************************;

ods _all_ close;
ods tagsets.ExcelXP path='C:\data\Projects\HIT EHR Adoption\output' file='Size.xml' style=Printer;
ods tagsets.ExcelXP options(embedded_titles='yes');

title 'General Hospitals';

 proc print data=general noobs style(Header)=[just=center];
	var year/ style(Column)=[background=#FFFFCC just=c];
	var small/style(Column)=[background=#ccccff just=c];	 
	var median/style(Column)=[background=#ccccff just=c];	 
	var large/ style(Column)=[background=#ccffff just=c] ;	 
run;
quit;

title 'Long Term Acute Care Hospitals';

 proc print data=ltac noobs style(Header)=[just=center];
	var year/ style(Column)=[background=#FFFFCC just=c];
	var small/style(Column)=[background=#ccccff just=c];	 
	var median/style(Column)=[background=#ccccff just=c];	 
	var large/ style(Column)=[background=#ccffff just=c] ;	 
run;
quit;

title 'Psychiatric';

 proc print data=Psychiatric noobs style(Header)=[just=center];
	var year/ style(Column)=[background=#FFFFCC just=c];
	var small/style(Column)=[background=#ccccff just=c];	 
	var median/style(Column)=[background=#ccccff just=c];	 
	var large/ style(Column)=[background=#ccffff just=c] ;	 
run;
quit;

title 'Rehab';

 proc print data=Rehab noobs style(Header)=[just=center];
	var year/ style(Column)=[background=#FFFFCC just=c];
	var small/style(Column)=[background=#ccccff just=c];	 
	var median/style(Column)=[background=#ccccff just=c];	 
	var large/ style(Column)=[background=#ccffff just=c] ;	 
run;
quit;

ods tagsets.ExcelXP close;
 
