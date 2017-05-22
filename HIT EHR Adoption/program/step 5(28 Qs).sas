
/******************************************
8/21/2014
#28 EHR Questions related to Basic EHR, compare ineligible vs eligible for each quetsion,over 6 years
Xiner Zhou
********************************************/


libname HIT "C:\data\Data\Hospital\AHA\HIT\data";
libname impact "C:\data\Data\Hospital\Impact";
LIBNAME AHA 	"C:\data\Data\Hospital\AHA\Annual_Survey\data";
libname rural 'C:\data\Data\RUCA';


* Make Hospital Characteristics Summary File;
data temp1;
set aha.aha12;

 
* Inegilible Long-Term Acute Care ;
if serv=80 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=4;
* Inegilible Psychiatric ; 
if serv=22 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=3; 
* Inegilible Rehabilitation ;
if serv=46 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=2;
* Egilible Acute Care Hospitals (general medical and surgical ;
if serv=10 and (hosp_reg4 ^=5 and hosp_reg4 ^=.) and profit2 ^=4  then type=1; 

if type ne .;

if sysid ^='' then system=1; else system=0;

if hospsize=1;

keep id zip type hospsize hosp_reg4 profit2 teaching system  ;
run;



* Calculate how many hospitals in each category ;
proc freq data=temp1;tables type;run;


* Add RUCA level from external file;
proc sql;
create table temp2 as
select A.*,B.ruca_level
from temp1 A left join rural.SAS_2006_RUCA B
on A.zip=B.ZIPA;
quit;

*********************************
HIT responses
*********************************;

%let var1=q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4 q1a5 q1b5 q1c5 q1d5;
%let var2=q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_g1 q1_a2 q1_b2 q1_c2 q1_d2 q1_e2 q1_f2 q1_a3 q1_b3 q1_c3 q1_d3 q1_e3 q1_a4 q1_b4 q1_c4 q1_d4 q1_e4 q1_f4 q1_a5 q1_b5 q1_c5 q1_d5;
%macro name;
%do i=1 %to 28;
rename %scan(&var2.,&i.)=%scan(&var1.,&i.);
%end;
%mend;
*2008;
proc sort data=hit.hit07 out=hit08(keep=&var1. id  );
by id;
run;

*2009;
proc sort data=hit.hit08 out=hit09(keep=&var2. id it_response );
by id;
run;
data hit09;
set hit09;
if it_response='Yes';
run;
data hit09;
set hit09;
%name;
run;
 
*2010;
proc sort data=hit.hit09 out=hit10(keep=&var1. id  );
by id;
run;
*2011;
proc sort data=hit.hit10 out=hit11(keep=&var2. id );
by id;
run;
data hit11;
set hit11;
%name;
run;
* 2012;
libname HIT1112 "C:\data\Data\Hospital\AHA\HIT\Data\fromshare_Projects-HIT2012-data-stata";
proc sort data=hit1112.Finalitfeb7 out=hit12(keep=&var1. id );
by id;
run;

* 2013;
proc sort data=hit.hit13 out=hit13(keep=&var1. id);
by id;
run;

**************************
for each quetsion, Yes/No/Missing
************************************;
%macro adopt(year=);
data HIT&year.;
set HIT&year.;
array q{28} q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4 q1a5 q1b5 q1c5 q1d5;
array q0{28} a10 b10 c10 d10 e10 f10 g10 a20 b20 c20 d20 e20 f20 a30 b30 c30 d30 e30 a40 b40 c40 d40 e40 f40 a50 b50 c50 d50;
array q1{28} a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4 a5 b5 c5 d5;
	do i=1 to 28;
		q0{i}=q{i}*1;
		if q0{i} in (1,2) then q1{i}=1;else if q0{i} ne . then q1{i}=0;else if q0{i}=. then q1{i}=.;
	end;
drop i q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1g1 q1a2 q1b2 q1c2 q1d2 q1e2 q1f2 q1a3 q1b3 q1c3 q1d3 q1e3 q1a4 q1b4 q1c4 q1d4 q1e4 q1f4 q1a5 q1b5 q1c5 q1d5
a10 b10 c10 d10 e10 f10 g10 a20 b20 c20 d20 e20 f20 a30 b30 c30 d30 e30 a40 b40 c40 d40 e40 f40 a50 b50 c50 d50;
run;
%mend adopt;
%adopt(year=08);
%adopt(year=09);
%adopt(year=10);
%adopt(year=11);
%adopt(year=12);
%adopt(year=13);

********************************
Each Year & Question
*****************************;
%let question=a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 a3 b3 c3 d3 e3 a4 b4 c4 d4 e4 f4 a5 b5 c5 d5;
%let year=08 09 10 11 12 13;
%macro adjusted;
	%do i=1 %to 6;
		
		%do j=1 %to 28;

			proc sql;
				create table temp3 as
				select *
				from temp2 a left join HIT%scan(&year.,&i.) b
				on a.id=b.id;
			quit;

			data temp3;
				set temp3;
				if %scan(&question.,&j.) ne . then respond=1;else respond=0;
				if type=1 then eligibility=1;else eligibility=0;
			run;

			proc logistic data=temp3;
				class respond(ref="0") hospsize(ref="1")  type(ref="1") hosp_reg4(ref="1") profit2(ref="1") teaching(ref="3") system(ref="1") ruca_level(ref="1")  /param=ref;
				model respond  = hospsize type hosp_reg4 profit2 teaching system ruca_level; 
				output  out=temp4 p=prob;  
			run;

			data temp4;
				set temp4;
				if respond=1;
				wt=1/prob;
			run;

			proc means data=temp4;
				class eligibility ;
				weight wt;
				var %scan(&question.,&j.);
				output out=temp5(keep=eligibility rate) mean=rate;
			run;


			data ine%scan(&question.,&j.)_%scan(&year.,&i.) e%scan(&question.,&j.)_%scan(&year.,&i.);
				set temp5;
				if eligibility=0 then output ine%scan(&question.,&j.)_%scan(&year.,&i.); 
				if eligibility=1 then output e%scan(&question.,&j.)_%scan(&year.,&i.); 
				
			run;
		
		%end;
		
		data all_ine_%scan(&year.,&i.);
		set ine%scan(&question.,1)_%scan(&year.,&i.) ine%scan(&question.,2)_%scan(&year.,&i.) ine%scan(&question.,3)_%scan(&year.,&i.)
			ine%scan(&question.,4)_%scan(&year.,&i.) ine%scan(&question.,5)_%scan(&year.,&i.) ine%scan(&question.,6)_%scan(&year.,&i.)
			ine%scan(&question.,7)_%scan(&year.,&i.) ine%scan(&question.,8)_%scan(&year.,&i.) ine%scan(&question.,9)_%scan(&year.,&i.)
			ine%scan(&question.,10)_%scan(&year.,&i.) ine%scan(&question.,11)_%scan(&year.,&i.) ine%scan(&question.,12)_%scan(&year.,&i.)
			ine%scan(&question.,13)_%scan(&year.,&i.) ine%scan(&question.,14)_%scan(&year.,&i.) ine%scan(&question.,15)_%scan(&year.,&i.)
			ine%scan(&question.,16)_%scan(&year.,&i.) ine%scan(&question.,17)_%scan(&year.,&i.) ine%scan(&question.,18)_%scan(&year.,&i.)
			ine%scan(&question.,19)_%scan(&year.,&i.) ine%scan(&question.,20)_%scan(&year.,&i.) ine%scan(&question.,21)_%scan(&year.,&i.)
			ine%scan(&question.,22)_%scan(&year.,&i.) ine%scan(&question.,23)_%scan(&year.,&i.) ine%scan(&question.,24)_%scan(&year.,&i.)
			ine%scan(&question.,25)_%scan(&year.,&i.) ine%scan(&question.,26)_%scan(&year.,&i.) ine%scan(&question.,27)_%scan(&year.,&i.)
			ine%scan(&question.,28)_%scan(&year.,&i.);
			rename rate=rate%scan(&year.,&i.);
		run;
		data all_e_%scan(&year.,&i.);
		set e%scan(&question.,1)_%scan(&year.,&i.) e%scan(&question.,2)_%scan(&year.,&i.) e%scan(&question.,3)_%scan(&year.,&i.)
			e%scan(&question.,4)_%scan(&year.,&i.) e%scan(&question.,5)_%scan(&year.,&i.) e%scan(&question.,6)_%scan(&year.,&i.)
			e%scan(&question.,7)_%scan(&year.,&i.) e%scan(&question.,8)_%scan(&year.,&i.) e%scan(&question.,9)_%scan(&year.,&i.)
			e%scan(&question.,10)_%scan(&year.,&i.) e%scan(&question.,11)_%scan(&year.,&i.) e%scan(&question.,12)_%scan(&year.,&i.)
			e%scan(&question.,13)_%scan(&year.,&i.) e%scan(&question.,14)_%scan(&year.,&i.) e%scan(&question.,15)_%scan(&year.,&i.)
			e%scan(&question.,16)_%scan(&year.,&i.) e%scan(&question.,17)_%scan(&year.,&i.) e%scan(&question.,18)_%scan(&year.,&i.)
			e%scan(&question.,19)_%scan(&year.,&i.) e%scan(&question.,20)_%scan(&year.,&i.) e%scan(&question.,21)_%scan(&year.,&i.)
			e%scan(&question.,22)_%scan(&year.,&i.) e%scan(&question.,23)_%scan(&year.,&i.) e%scan(&question.,24)_%scan(&year.,&i.)
			e%scan(&question.,25)_%scan(&year.,&i.) e%scan(&question.,26)_%scan(&year.,&i.) e%scan(&question.,27)_%scan(&year.,&i.)
			e%scan(&question.,28)_%scan(&year.,&i.);
			rename rate=rate%scan(&year.,&i.);
		run;
	%end;

	data all_ine_adj;
	merge all_ine_08 all_ine_09 all_ine_10 all_ine_11 all_ine_12 all_ine_13;
	run;
	data all_e_adj;
	merge all_e_08 all_e_09 all_e_10 all_e_11 all_e_12 all_e_13;
	run;

%mend adjusted;

%adjusted;





%macro unadjusted;
	%do i=1 %to 6;
		
		%do j=1 %to 28;

			proc sql;
				create table temp3 as
				select *
				from temp2 a left join HIT%scan(&year.,&i.) b
				on a.id=b.id;
			quit;

			data temp3;
				set temp3;
				if %scan(&question.,&j.) ne . then respond=1;else respond=0;
				if type=1 then eligibility=1;else eligibility=0;
			run;


			data temp4;
				set temp3;
				if respond=1;
			run;

			proc means data=temp4;
				class eligibility ;
				var %scan(&question.,&j.);
				output out=temp5(keep=eligibility rate) mean=rate;
			run;

			data ine%scan(&question.,&j.)_%scan(&year.,&i.) e%scan(&question.,&j.)_%scan(&year.,&i.);
				set temp5;
				if eligibility=0 then output ine%scan(&question.,&j.)_%scan(&year.,&i.); 
				if eligibility=1 then output e%scan(&question.,&j.)_%scan(&year.,&i.); 
				
			run;
		
		%end;
		
		data all_ine_%scan(&year.,&i.);
		set ine%scan(&question.,1)_%scan(&year.,&i.) ine%scan(&question.,2)_%scan(&year.,&i.) ine%scan(&question.,3)_%scan(&year.,&i.)
			ine%scan(&question.,4)_%scan(&year.,&i.) ine%scan(&question.,5)_%scan(&year.,&i.) ine%scan(&question.,6)_%scan(&year.,&i.)
			ine%scan(&question.,7)_%scan(&year.,&i.) ine%scan(&question.,8)_%scan(&year.,&i.) ine%scan(&question.,9)_%scan(&year.,&i.)
			ine%scan(&question.,10)_%scan(&year.,&i.) ine%scan(&question.,11)_%scan(&year.,&i.) ine%scan(&question.,12)_%scan(&year.,&i.)
			ine%scan(&question.,13)_%scan(&year.,&i.) ine%scan(&question.,14)_%scan(&year.,&i.) ine%scan(&question.,15)_%scan(&year.,&i.)
			ine%scan(&question.,16)_%scan(&year.,&i.) ine%scan(&question.,17)_%scan(&year.,&i.) ine%scan(&question.,18)_%scan(&year.,&i.)
			ine%scan(&question.,19)_%scan(&year.,&i.) ine%scan(&question.,20)_%scan(&year.,&i.) ine%scan(&question.,21)_%scan(&year.,&i.)
			ine%scan(&question.,22)_%scan(&year.,&i.) ine%scan(&question.,23)_%scan(&year.,&i.) ine%scan(&question.,24)_%scan(&year.,&i.)
			ine%scan(&question.,25)_%scan(&year.,&i.) ine%scan(&question.,26)_%scan(&year.,&i.) ine%scan(&question.,27)_%scan(&year.,&i.)
			ine%scan(&question.,28)_%scan(&year.,&i.);
			rename rate=rate%scan(&year.,&i.);
		run;
		data all_e_%scan(&year.,&i.);
		set e%scan(&question.,1)_%scan(&year.,&i.) e%scan(&question.,2)_%scan(&year.,&i.) e%scan(&question.,3)_%scan(&year.,&i.)
			e%scan(&question.,4)_%scan(&year.,&i.) e%scan(&question.,5)_%scan(&year.,&i.) e%scan(&question.,6)_%scan(&year.,&i.)
			e%scan(&question.,7)_%scan(&year.,&i.) e%scan(&question.,8)_%scan(&year.,&i.) e%scan(&question.,9)_%scan(&year.,&i.)
			e%scan(&question.,10)_%scan(&year.,&i.) e%scan(&question.,11)_%scan(&year.,&i.) e%scan(&question.,12)_%scan(&year.,&i.)
			e%scan(&question.,13)_%scan(&year.,&i.) e%scan(&question.,14)_%scan(&year.,&i.) e%scan(&question.,15)_%scan(&year.,&i.)
			e%scan(&question.,16)_%scan(&year.,&i.) e%scan(&question.,17)_%scan(&year.,&i.) e%scan(&question.,18)_%scan(&year.,&i.)
			e%scan(&question.,19)_%scan(&year.,&i.) e%scan(&question.,20)_%scan(&year.,&i.) e%scan(&question.,21)_%scan(&year.,&i.)
			e%scan(&question.,22)_%scan(&year.,&i.) e%scan(&question.,23)_%scan(&year.,&i.) e%scan(&question.,24)_%scan(&year.,&i.)
			e%scan(&question.,25)_%scan(&year.,&i.) e%scan(&question.,26)_%scan(&year.,&i.) e%scan(&question.,27)_%scan(&year.,&i.)
			e%scan(&question.,28)_%scan(&year.,&i.);
			rename rate=rate%scan(&year.,&i.);
		run;
	%end;

	data all_ine_unadj;
	merge all_ine_08 all_ine_09 all_ine_10 all_ine_11 all_ine_12 all_ine_13;
	run;
	data all_e_unadj;
	merge all_e_08 all_e_09 all_e_10 all_e_11 all_e_12 all_e_13;
	run;

%mend unadjusted;

%unadjusted;






*******************P-values for 2013 Ineligible vs Eligible;
%macro adj_p();
%do j=1 %to 28;
proc sql;
	create table temp3 as
	select *
    from temp2 a left join HIT13 b
	on a.id=b.id;
quit;

data temp3;
	set temp3;
	if %scan(&question.,&j.) ne . then respond=1;else respond=0;
	if type=1 then eligibility=1;else eligibility=0;
run; 
data temp4;
	set temp3;
	if respond=1;
run;

 
proc logistic data=temp4 ;
	class %scan(&question.,&j.)(ref='0') eligibility(ref='0')/param=ref;
	model %scan(&question.,&j.)=eligibility;
run;

%end;

%mend adj_p;
%adj_p;

  








* Output;

ods Tagsets.ExcelxP body='C:\data\Projects\HIT EHR Adoption\temp.xml';

proc print data=All_e_adj;run;
proc print data=All_e_unadj;run;
proc print data=All_ine_adj;run;
proc print data=All_ine_unadj;run;


ods Tagsets.ExcelxP close;



 
