*************************************************************************
Objective:		Adjusted EHR adoption rate by Size
				EHR basic adoption=size+system
Written by:		Xiner Zhou
Date:			5/5/2014
************************************************************************;

libname HIT "C:\data\Data\Hospital\AHA\HIT\data";
libname impact "C:\data\Data\Hospital\Impact";
LIBNAME AHA 	"C:\data\Data\Hospital\AHA\Annual_Survey\data";

* Check how many hospitals fall into each category;
data test;
set aha.aha12;
if serv=10 and hospsize=3;
run;








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
proc sort data=hit1112.Finalitfeb7 out=hit1112(keep=q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 id sr_name org_name);
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
proc sort data=hit.hit10 out=hit10(keep= q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_a2 q1_b2 q1_d2 q1_c3 id sr_name org_name);
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
proc sort data=hit.hit09 out=hit09(keep= q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 id sr_name org_name);
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
proc sort data=hit.hit08 out=hit08(keep= q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_a2 q1_b2 q1_d2 q1_c3 id sr_name org_name);
by id;
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
proc sort data=hit.hit07 out=hit07(keep= q1a1 q1b1 q1c1 q1d1 q1e1 q1f1 q1a2 q1b2 q1d2 q1c3 id sr_name org_name);
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



***************************
Step 2: Macro loop through years & type 
***************************;

%macro longitude(yr=,type=);


* subset by Hospital Type;
data sub_&type._&yr.;
set ahahit&yr.;
if &type.=1 and respond=1;
run;
 
* Unadjusted EHR Adoption Rate : Rate = Size (Linear Regression) and Report the p-value which is F-test for whether the means different by level;
 
proc genmod data=sub_&type._&yr.;
	weight wt;
	class basic_adopt hospsize;
	model basic_adopt=hospsize/dist=normal link=identity;
	output out=unadj_&type._&yr. p=pct ;
run;

proc means data=unadj_&type._&yr.;
class hospsize;
var pct;
output out=unadj_&type._&yr. Mean=mean_&yr.;
run;

data unadj_&type._&yr.;
retain type level N_&yr. mean_&yr.;
set unadj_&type._&yr.;
where _type_=1;
type="&type.";
level=hospsize;
N_&yr.=_freq_;
keep type level N_&yr. mean_&yr.; * mean is actual rate;
run;


* Adjusted EHR Adoption Rate ;
proc genmod data=sub_&type._&yr. descending;
	weight wt;
	class basic_adopt hospsize sys;
	model basic_adopt=hospsize sys/dist=bin link=logit;
	lsmeans hospsize;
	ods output LSMeans=lsmeans_&type._&yr.;
run;

data lsmeans_&type._&yr.;
set lsmeans_&type._&yr.;
prob_&yr.=exp(estimate)/(1+exp(estimate));
Run;
 
data lsmeans_&type._&yr.;
retain type level prob_&yr.;
set lsmeans_&type._&yr.;
type="&type.";
level=hospsize;
keep type level prob_&yr.; * prob is adjusted rate;
run;
 


* Merge Unadj and Adjusted;

data &type._&yr.;
merge unadj_&type._&yr. lsmeans_&type._&yr.;
run;

* Sort by level so that line up 1 2 3...;
proc sort data=&type._&yr.;
by level;
run;
%mend longitude;

%longitude(yr=13,type=gen)
%longitude(yr=12,type=gen)
%longitude(yr=11,type=gen)
%longitude(yr=10,type=gen)
%longitude(yr=09,type=gen)
%longitude(yr=08,type=gen)

%longitude(yr=13,type=ltac)
%longitude(yr=12,type=ltac)
%longitude(yr=11,type=ltac)
%longitude(yr=10,type=ltac)
%longitude(yr=09,type=ltac)
%longitude(yr=08,type=ltac)

%longitude(yr=13,type=rehab)
%longitude(yr=12,type=rehab)
%longitude(yr=11,type=rehab)
%longitude(yr=10,type=rehab)
%longitude(yr=09,type=rehab)
%longitude(yr=08,type=rehab)

%longitude(yr=13,type=psy)
%longitude(yr=12,type=psy)
%longitude(yr=11,type=psy)
%longitude(yr=10,type=psy)
%longitude(yr=09,type=psy)
%longitude(yr=08,type=psy)
 

* Longitudinal Data ;
libname mydata 'C:\data\Projects\HIT EHR Adoption\table';
data mydata.rehab;
merge rehab_08 rehab_09 rehab_10 rehab_11 rehab_12 rehab_13;
by level;
run;
data mydata.psy;
merge psy_08 psy_09 psy_10 psy_11 psy_12 psy_13;
by level;
run;
data mydata.ltac;
merge ltac_08 ltac_09 ltac_10 ltac_11 ltac_12 ltac_13;
by level;
run;
data mydata.gen;
merge gen_08 gen_09 gen_10 gen_11 gen_12 gen_13;
by level;
run;



***************************
Step 3: Make into One table 
***************************;

data mydata.table;
set mydata.gen mydata.ltac mydata.psy mydata.rehab;
run;




***************************
Step 4: Output to Excel
***************************;

ods _all_ close;
ods tagsets.ExcelXP path='C:\data\Projects\HIT EHR Adoption\output' file='EHR Adoption Rate.xml' style=Printer;
ods tagsets.ExcelXP options(embedded_titles='yes');

title 'At Least Basic EHR Adoption Rate';

 proc print data=mydata.table noobs style(Header)=[just=center];
	var type;var level; var N_08;var mean_08;var prob_08;
						var N_09;var mean_09;var prob_09;
	 					var N_10;var mean_10;var prob_10;
						var N_11;var mean_11;var prob_11;
						var N_12;var mean_12;var prob_12;
						var N_13;var mean_13;var prob_13;
run;
quit;

ods tagsets.ExcelXP close;
 
***************************
Step 5: Visualization
***************************;
data plotadj;
set mydata.table;
keep prob_08 prob_09 prob_10 prob_11 prob_12 prob_13;
run;

data plotunadj;
set mydata.table;
keep mean_08 mean_09 mean_10 mean_11 mean_12 mean_13;
run;


proc transpose data=plotadj out=mydata.plotadj;
var prob_08 prob_09 prob_10 prob_11 prob_12 prob_13;
run;

proc transpose data=plotunadj out=mydata.plotunadj;
var mean_08 mean_09 mean_10 mean_11 mean_12 mean_13;
run;

data mydata.plotadj;
retain year;
set mydata.plotadj;

a="2008 2009 2010 2011 2012 2013";
m=_n_;
year=substr(a,(m-1)*5+1,4);

keep year col1-col11;
run;

data mydata.plotunadj;
retain year;
set mydata.plotunadj;

a="2008 2009 2010 2011 2012 2013";
m=_n_;
year=substr(a,(m-1)*5+1,4);

keep year col1-col11;
run;

* Plot Small Hospitals ;

proc sgplot data=mydata.plotadj;
series X=year y=col1/datalabel=col1 LEGENDLABEL="General Hospital" MARKERS LINEATTRS = (THICKNESS = 4 color="BLUE"); 
series X=year y=col4 /datalabel=col4 LEGENDLABEL="Long-term Acute Care" MARKERS LINEATTRS = (THICKNESS = 3 color="PINK"); 
series X=year y=col7 /datalabel=col7 LEGENDLABEL="Psychiatric" MARKERS LINEATTRS = (THICKNESS = 2 color="PURPLE"); 
series X=year y=col10 /datalabel=col10 LEGENDLABEL="Rehab" MARKERS LINEATTRS = (THICKNESS = 6 color="STEEL"); 
 
format col1 percent8.2;
format col4  percent8.2;
format col7 percent8.2;
format col10 percent8.2;
 
label col1="Rate" year="Year";
title "Small Hospitals Adjusted Rate";
run; 



* Plot Medium Hospitals ;

proc sgplot data=mydata.plotadj;
series X=year y=col2/datalabel=col2 LEGENDLABEL="General Hospital" MARKERS LINEATTRS = (THICKNESS = 4 color="BLUE"); 
series X=year y=col5 /datalabel=col5 LEGENDLABEL="Long-term Acute Care" MARKERS LINEATTRS = (THICKNESS = 3 color="PINK"); 
series X=year y=col8 /datalabel=col8 LEGENDLABEL="Psychiatric" MARKERS LINEATTRS = (THICKNESS = 2 color="PURPLE"); 
series X=year y=col11 /datalabel=col11 LEGENDLABEL="Rehab" MARKERS LINEATTRS = (THICKNESS = 6 color="STEEL"); 
 
format col2 percent8.2;
format col5  percent8.2;
format col8 percent8.2;
format col11 percent8.2;
 
label col2="Rate" year="Year";
title "Medium  Hospitals Adjusted Rate";
run; 


* Plot Large Hospitals ;

proc sgplot data=mydata.plotadj;
series X=year y=col3/datalabel=col3 LEGENDLABEL="General Hospital" MARKERS LINEATTRS = (THICKNESS = 4 color="BLUE") ; 
series X=year y=col6 /datalabel=col6 LEGENDLABEL="Long-term Acute Care" MARKERS LINEATTRS = (THICKNESS = 3 color="PINK") ; 
series X=year y=col9 /datalabel=col9 LEGENDLABEL="Psychiatric" MARKERS LINEATTRS = (THICKNESS = 2 color="PURPLE") ; 
 
 
format col3 percent8.2;
format col6  percent8.2;
format col9 percent8.2;
 
 
label col3="Rate";
title "Large  Hospitals Adjusted Rate" ;
run; 

