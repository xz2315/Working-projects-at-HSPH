*************************************************************************
Objective:		Respond Rate  
				
Written by:		Xiner Zhou

Date:			5/6/2014
************************************************************************;

libname HIT "C:\data\Data\Hospital\AHA\HIT\data";
libname impact "C:\data\Data\Hospital\Impact";
LIBNAME AHA 	"C:\data\Data\Hospital\AHA\Annual_Survey\data";
libname mydata 'C:\data\Projects\HIT EHR Adoption\table';

/* Check Data Layout ;
ods rtf file='C:\data\Projects\HIT EHR Adoption\table\temp.rtf';
proc contents data=hit.hit08;run;
ods rtf close;
     
*/

* Use AHA 2012 for all years;
data aha12;
set aha.aha12;

if serv=80 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then ltac=1;else ltac=0; * Long-term Acute Care;
if serv=22 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then psy=1;else psy=0; * Psychiatric;
if serv=46 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then rehab=1;else rehab=0; * Rehab;
if serv=10 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4 and mtype="Y" then gen=1;else gen=0;* General hospitals;

if cluster ^=. then sys=1; else sys=0;
if cicu=. then cicu=2;

keep id ltac psy rehab gen hospsize hosp_reg4 profit2 teaching sys urban cicu;
run;


proc sort data=aha12 out=aha12;
by id;
run;

* Number of Hospitals in each category;
%macro count(type=);
proc sql;
create table &type._count as
select hospsize, count(hospsize) as N
from aha12
where &type.=1
group by hospsize;
quit;


data &type._count;
retain size;
set &type._count;
a="Small Medium Large";
size=scan(a,_n_,' ');
keep size N;
run;
proc sort data=&type._count;by descending size;run;
%mend count;
%count(type=gen)
%count(type=ltac)
%count(type=psy)
%count(type=rehab)

 

 

*****************
* Step1: Prepare all years data
****************;




****************************************2013 Data***********************************************;
proc sort data=hit.hit13 out=hit13(keep= q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 id);
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
	 
	array basic {10}  q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3;
 	total=0;
	do i= 1 to dim(basic);
		if basic(i) in (1,2) then total=total+1;
	end;
	drop i;
		 
	if total=10 then basic_adopt=1;else basic_adopt=0;  

	wt=1/prob;
run;

****************************************2012 Data*******************************************;
libname HIT1112 "C:\data\Data\Hospital\AHA\HIT\Data\fromshare_Projects-HIT2012-data-stata";
proc sort data=hit1112.Finalitfeb7 out=hit1112(keep=q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 id);
by id;
run;


data ahahit12;
merge aha12(in=in1) hit1112(in=in2);
by id;
if in1;
respond=in2;
run;

 
proc logistic data=ahahit12;
	class respond(ref="0") hospsize(ref="1")  hosp_reg4(ref="1") profit2(ref="1") teaching(ref="3") sys(ref="1") urban(ref="1") cicu(ref="0")/param=ref;
	model respond  = hospsize hosp_reg4 profit2 teaching sys urban cicu; 
	output  out=ahahit12 p=prob;  
run;

* Now we have all the info in this dataset;
data ahahit12;
	set ahahit12;
	 
	array basic {10}  q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3;
 	total=0;
	do i= 1 to dim(basic);
		if basic(i) in (1,2) then total=total+1;
	end;
	drop i;
		 
	if total=10 then basic_adopt=1;else basic_adopt=0;  

	wt=1/prob;
run;

****************************************2011 Data*******************************************;
proc sort data=hit.hit10 out=hit10(keep= q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_a2 q1_b2 q1_d2 q1_c3 id);
by id;
run;


data ahahit11;
merge aha12(in=in1) hit10(in=in2);
by id;
if in1;
respond=in2;
run;

 
proc logistic data=ahahit11;
	class respond(ref="0") hospsize(ref="1")  hosp_reg4(ref="1") profit2(ref="1") teaching(ref="3") sys(ref="1") urban(ref="1") cicu(ref="0")/param=ref;
	model respond  = hospsize hosp_reg4 profit2 teaching sys urban cicu; 
	output  out=ahahit11 p=prob;  
run;

* Now we have all the info in this dataset;
data ahahit11;
	set ahahit11;
	 
	array basic {10}  q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_a2 q1_b2 q1_d2 q1_c3;
 	total=0;
	do i= 1 to dim(basic);
		if basic(i) in (1,2) then total=total+1;
	end;
	drop i;
		 
	if total=10 then basic_adopt=1;else basic_adopt=0;  

	wt=1/prob;
run;


****************************************2010 Data*******************************************;
proc sort data=hit.hit09 out=hit09(keep= q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 id);
by id;
run;


data ahahit10;
merge aha12(in=in1) hit09(in=in2);
by id;
if in1;
respond=in2;
run;
 
proc logistic data=ahahit10;
	class respond(ref="0") hospsize(ref="1")  hosp_reg4(ref="1") profit2(ref="1") teaching(ref="3") sys(ref="1") urban(ref="1") cicu(ref="0")/param=ref;
	model respond  = hospsize hosp_reg4 profit2 teaching sys urban cicu; 
	output  out=ahahit10 p=prob;  
run;

* Now we have all the info in this dataset;
data ahahit10;
	set ahahit10;
	 
	array basic {10}  q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3;
 	total=0;
	do i= 1 to dim(basic);
		if basic(i) in (1,2) then total=total+1;
	end;
	drop i;
		 
	if total=10 then basic_adopt=1;else basic_adopt=0;  

	wt=1/prob;
run;


****************************************2009 Data*******************************************;
proc sort data=hit.hit08 out=hit08(keep= it_response q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_a2 q1_b2 q1_d2 q1_c3 id );
by id;
run;

data hit08;
set hit08;
if it_response="Yes";
run;

data ahahit09;
merge aha12(in=in1) hit08(in=in2);
by id;
if in1;
respond=in2;
run;

 
proc logistic data=ahahit09;
	class respond(ref="0") hospsize(ref="1")  hosp_reg4(ref="1") profit2(ref="1") teaching(ref="3") sys(ref="1") urban(ref="1") cicu(ref="0")/param=ref;
	model respond  = hospsize hosp_reg4 profit2 teaching sys urban cicu; 
	output  out=ahahit09 p=prob;  
run;

* Now we have all the info in this dataset;
data ahahit09;
	set ahahit09;
	 
	array basic {10}  q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_a2 q1_b2 q1_d2 q1_c3;
 	total=0;
	do i= 1 to dim(basic);
		if basic(i) in (1,2) then total=total+1;
	end;
	drop i;
		 
	if total=10 then basic_adopt=1;else basic_adopt=0;  

	wt=1/prob;
run;


****************************************2008 Data*******************************************;
proc sort data=hit.hit07 out=hit07(keep= q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 id);
by id;
run;


data ahahit08;
merge aha12(in=in1) hit07(in=in2);
by id;
if in1;
respond=in2;
run;
 
proc logistic data=ahahit08;
	class respond(ref="0") hospsize(ref="1")  hosp_reg4(ref="1") profit2(ref="1") teaching(ref="3") sys(ref="1") urban(ref="1") cicu(ref="0")/param=ref;
	model respond  = hospsize hosp_reg4 profit2 teaching sys urban cicu; 
	output  out=ahahit08 p=prob;  
run;

* Now we have all the info in this dataset;
data ahahit08;
	set ahahit08;
	 
	array basic {10}  q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3;
 	total=0;
	do i= 1 to dim(basic);
		if basic(i) in (1,2) then total=total+1;
	end;
	drop i;
		 
	if total=10 then basic_adopt=1;else basic_adopt=0;  

	wt=1/prob;
run;

**************************
Step 2: Respond Number
**************************;

* Number of Hospitals in each category;
%macro count1(yr=,type=);
proc sql;
create table &type._&yr._count as
select hospsize, count(hospsize) as N_&yr.
from ahahit&yr.
where &type.=1 and respond=1
group by hospsize;
quit;


data &type._&yr._count;
retain size;
set &type._&yr._count;
a="Small Medium Large";
size=scan(a,_n_,' ');
keep size N_&yr.;
run;
proc sort data=&type._&yr._count;by descending size;run;

%mend count1;
%count1(yr=08,type=gen)
%count1(yr=09,type=gen)
%count1(yr=10,type=gen)
%count1(yr=11,type=gen)
%count1(yr=12,type=gen)
%count1(yr=13,type=gen)
%count1(yr=08,type=ltac)
%count1(yr=09,type=ltac)
%count1(yr=10,type=ltac)
%count1(yr=11,type=ltac)
%count1(yr=12,type=ltac)
%count1(yr=13,type=ltac)
%count1(yr=08,type=psy)
%count1(yr=09,type=psy)
%count1(yr=10,type=psy)
%count1(yr=11,type=psy)
%count1(yr=12,type=psy)
%count1(yr=13,type=psy)
%count1(yr=08,type=rehab)
%count1(yr=09,type=rehab)
%count1(yr=10,type=rehab)
%count1(yr=11,type=rehab)
%count1(yr=12,type=rehab)
%count1(yr=13,type=rehab)

data gen;
merge gen_count gen_08_count gen_09_count gen_10_count gen_11_count gen_12_count gen_13_count;
by descending size;
run;

data ltac;
merge ltac_count ltac_08_count ltac_09_count ltac_10_count ltac_11_count ltac_12_count ltac_13_count;
by descending size;
run;

data psy;
merge psy_count psy_08_count psy_09_count psy_10_count psy_11_count psy_12_count psy_13_count;
by descending size;
run;

data rehab;
merge rehab_count rehab_08_count rehab_09_count rehab_10_count rehab_11_count rehab_12_count rehab_13_count;
by descending size;
run;


data mydata.resp_rate;
retain size N N_08 rate_08 N_09 rate_09 N_10 rate_10 N_11 rate_11 N_12 rate_12 N_13 rate_13;
set gen ltac psy rehab;
array num {6} N_08-N_13;
array rate {6} rate_08-rate_13;
do i=1 to 6;
rate{i}=num{i}/N;
end;
drop i;
run;


***************************
Step 4: Output to Excel
***************************;

ods _all_ close;
ods tagsets.ExcelXP path='C:\data\Projects\HIT EHR Adoption\output' file='Respond Rate.xml' style=Printer;
ods tagsets.ExcelXP options(embedded_titles='yes');

title 'HIT Survey Respond Rate';

 proc print data=mydata.resp_rate noobs style(Header)=[just=center];
	var size;var N; var N_08;var rate_08; 
					var N_09;var rate_09; 
					var N_10;var rate_10; 
					var N_11;var rate_11; 
					var N_12;var rate_12; 
					var N_13;var rate_13; 
run;
quit;

ods tagsets.ExcelXP close;
 














