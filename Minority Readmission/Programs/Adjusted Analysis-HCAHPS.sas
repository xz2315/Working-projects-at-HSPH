********************************
HCAHPS
Xiner Zhou
7/29/2015
*******************************;

libname data 'C:\data\Projects\Minority_Readmissions\Data';
libname HCAHPS 'C:\data\Data\Hospital\Hospital Compare\data'; 
/*
Predictors: 
1.	Hospitals that responded “usually” or “always” for Q7a-Q7m compared to remaining hospitals (13 sets of analyses, one for each strategy)
2.	Hospitals that responded “yes” to Q10 compared to remaining hospitals
3.	Hospitals that responded 9 or 10 (highest priority) for Q23 (only for the “improving patient experience” question) compared to the remaining hospitals

Outcomes:
Composite scores for following measures: 
Best Rated Hospital -H_HSP_RATING_9_10
Recommend Hospital -H_RECMND_DY
Discharge Process -H_COMP_7_SA
Doctor communication -H_COMP_2_A_P
Nurse communication -H_COMP_1_A_P
Medication communication - H_COMP_5_A_P

Models:
1.	Unadjusted
2.	Adjust for patient characteristics and hospital characteristics
3.	Adjust for patient & hospital characteristics, SNH status, and proportion black


*/
 

proc sql;
create table data as
select a.*,
b.H_STAR_RATING, 
b.H_CLEAN_HSP_A_P, b.H_CLEAN_STAR_RATING,
b.H_COMP_1_A_P,b.H_COMP_1_STAR_RATING,
b.H_COMP_2_A_P, b.H_COMP_2_STAR_RATING,
b.H_COMP_3_A_P,  b.H_COMP_3_STAR_RATING,
b.H_COMP_4_A_P, b.H_COMP_4_STAR_RATING,
b.H_COMP_5_A_P,  b.H_COMP_5_STAR_RATING,
b.H_COMP_6_Y_P, b.H_COMP_6_STAR_RATING,
b.H_COMP_7_SA, b.H_COMP_7_STAR_RATING,
b.H_QUIET_HSP_A_P,  b.H_QUIET_STAR_RATING,
b.H_RECMND_DY,  b.H_RECMND_STAR_RATING,
b.H_HSP_RATING_9_10, b.H_HSP_RATING_STAR_RATI


from data.survey_analytic a left join HCAHPS.HCAHPS2014 b
on a.Medicare_id=b.provider_id;
quit;

%macro stat(var=,label=,allq=);

%do i=1 %to 15;

	%let q=%scan(&allq.,&i.);
	data temp;
		set data;
		y=&var.*1;
	run; 
 
	proc means data=temp;	
		weight wt;class &q.;var y;
		output out=&q.&var.(drop=_type_ _freq_) mean=&var. ;
	run;
	data &q.&var.;
		set &q.&var.;
		label &var.= "&label.";
		 if &q. ne .;
		 proc sort;by &q.;
	run;

%end;
%mend stat;
%stat(var=H_STAR_RATING,label=Summary Star Rating,allq=y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m y10 y23e);
%stat(var=H_CLEAN_HSP_A_P,label=Patients who reported that their room and bathroom were Always clean,allq=y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m y10 y23e);
%stat(var=H_COMP_1_A_P,label=Patients who reported that their nurses Always communicated well,allq=y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m y10 y23e);
%stat(var=H_COMP_2_A_P,label=Patients who reported that their doctors Always communicated well,allq=y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m y10 y23e);
%stat(var=H_COMP_3_A_P,label=Patients who reported that they Always received help as soon as they wanted,allq=y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m y10 y23e);
%stat(var=H_COMP_4_A_P,label=Patients who reported that their pain was Always well controlled,allq=y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m y10 y23e);
%stat(var=H_COMP_5_A_P,label=Patients who reported that staff Always explained about medicines before giving it to them,allq=y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m y10 y23e);
%stat(var=H_COMP_6_Y_P,label=they were given information about what to do during their recovery,allq=y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m y10 y23e);
%stat(var=H_COMP_7_SA,label=Patients who Strongly Agree they understood their care when they left the hospital,allq=y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m y10 y23e);
%stat(var=H_QUIET_HSP_A_P,label=Patients who reported that the area around their room was Always quiet at night,allq=y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m y10 y23e);
%stat(var=H_RECMND_DY,label=they would definitely recommend the hospital,allq=y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m y10 y23e);
%stat(var=H_HSP_RATING_9_10,label=Patients who gave their hospital a rating of 9 or 10,allq=y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m y10 y23e);


%stat(var=H_CLEAN_STAR_RATING,label=Room and Bathroom clean Star Rating,allq=y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m y10 y23e);
%stat(var=H_COMP_1_STAR_RATING,label=Nurse Communication Star Rating,allq=y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m y10 y23e);
%stat(var=H_COMP_2_STAR_RATING,label=Doctors Communication Star Rating,allq=y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m y10 y23e);
%stat(var=H_COMP_3_STAR_RATING,label=Receive Help Star Rating,allq=y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m y10 y23e);
%stat(var=H_COMP_4_STAR_RATING,label=Control Pain Star Rating,allq=y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m y10 y23e);
%stat(var=H_COMP_5_STAR_RATING,label=Staff Explained About Medicines Star Rating,allq=y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m y10 y23e);
%stat(var=H_COMP_6_STAR_RATING,label=Recovery Star Rating,allq=y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m y10 y23e);
%stat(var=H_COMP_7_STAR_RATING,label=Discharge Star Rating,allq=y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m y10 y23e);
%stat(var=H_QUIET_STAR_RATING,label=Quiet Star Rating,allq=y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m y10 y23e);
%stat(var=H_RECMND_STAR_RATING,label=Recommend Star Rating,allq=y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m y10 y23e);
%stat(var=H_HSP_RATING_STAR_RATI,label=Hospital Rating Star Rating,allq=y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m y10 y23e);

%macro all(q=);
 
 data &q.;
 length Question $10.;
 merge &q.H_STAR_RATING 
	&q.H_CLEAN_HSP_A_P &q.H_CLEAN_STAR_RATING 
    &q.H_COMP_1_A_P &q.H_COMP_1_STAR_RATING
	&q.H_COMP_2_A_P &q.H_COMP_2_STAR_RATING
	&q.H_COMP_3_A_P &q.H_COMP_3_STAR_RATING
	&q.H_COMP_4_A_P &q.H_COMP_4_STAR_RATING
	&q.H_COMP_5_A_P &q.H_COMP_5_STAR_RATING
	 &q.H_COMP_6_Y_P &q.H_COMP_6_STAR_RATING
	&q.H_COMP_7_SA &q.H_COMP_7_STAR_RATING
	&q.H_QUIET_HSP_A_P &q.H_QUIET_STAR_RATING
	&q.H_RECMND_DY &q.H_RECMND_STAR_RATING
	&q.H_HSP_RATING_9_10 &q.H_HSP_RATING_STAR_RATI
   ;
   by &q.;
   rename &q.=Answer;
   Question="&q.";
   
 run;
%mend all;
%all(q=y7a);
%all(q=y7b);
%all(q=y7c);
%all(q=y7d);
%all(q=y7e);
%all(q=y7f);
%all(q=y7g);
%all(q=y7h);
%all(q=y7i);
%all(q=y7j);
%all(q=y7k);
%all(q=y7l);
%all(q=y7m);

%all(q=y10);
%all(q=y23e);

data All;
set y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m y10 y23e;
proc print label;
run;

 





* Model;

data temp;
set data;
y=H_STAR_RATING*1;type=1;output;
y=H_CLEAN_HSP_A_P*1;type=2;output;


y=H_STAR_RATING*1;type=1;output; 
y=H_CLEAN_HSP_A_P*1;type=2;output; y=H_CLEAN_STAR_RATING*1;type=3;output;
y=H_COMP_1_A_P*1;type=4;output;y=H_COMP_1_STAR_RATING*1;type=5;output;
y=H_COMP_2_A_P*1;type=6;output;y=H_COMP_2_STAR_RATING*1;type=7;output;
y=H_COMP_3_A_P*1;type=8;output;y=H_COMP_3_STAR_RATING*1;type=9;output;
y=H_COMP_4_A_P*1;type=10;output;y=H_COMP_4_STAR_RATING*1;type=11;output;
y=H_COMP_5_A_P*1;type=12;output;y=H_COMP_5_STAR_RATING*1;type=13;output;
y=H_COMP_6_Y_P*1;type=14;output;y=H_COMP_6_STAR_RATING*1;type=15;output;
y=H_COMP_7_SA*1;type=16;output;y=H_COMP_7_STAR_RATING*1;type=17;output;
y=H_QUIET_HSP_A_P*1;type=18;output;y=H_QUIET_STAR_RATING*1;type=19;output;
y=H_RECMND_DY*1;type=20;output;y=H_RECMND_STAR_RATING*1;type=21;output;
y=H_HSP_RATING_9_10*1;type=22;output;y=H_HSP_RATING_STAR_RATI*1;type=23;output;

run;

%macro single(y=);
 
    proc sort data=temp;by descending &y.;run;
	proc genmod data=temp order=data ;
		where type in (4,6,12,16,20,22);
		weight wt;
		class &y. type Medicare_id teaching profit2 hospsize hosp_reg4 ruca_level CICU;
		model y=type  &y.*type  / dist = normal   ;  		
		repeated subject=Medicare_id/type=exch;
        ods output GEEEmpPEst=Estimate1;
	run;
    proc sort data=temp;by descending &y.;run;
	proc genmod data=temp order=data;
		where type in (4,6,12,16,20,22);
		weight wt;
		class &y. type Medicare_id teaching profit2 hospsize hosp_reg4 ruca_level CICU SNH;
		model y=type  &y.*type teaching profit2 hospsize hosp_reg4 ruca_level CICU  / dist = normal  ;  		 
		repeated subject=Medicare_id/type=exch;
		 ods output GEEEmpPEst=Estimate2;
	run;
    proc sort data=temp;by descending &y.;run;
	proc genmod data=temp order=data;
		where type in (4,6,12,16,20,22);
		weight wt;
		class &y. type Medicare_id teaching profit2 hospsize hosp_reg4 ruca_level CICU;
		model y=type  &y.*type teaching profit2 hospsize hosp_reg4 ruca_level CICU  SNH propblk/ dist = normal  ;  
		repeated subject=Medicare_id/type=exch;
		 ods output GEEEmpPEst=Estimate3;
	run;

data Estimate;
length model $50.;
set Estimate1(in=in1) Estimate2(in=in2) Estimate3(in=in3);
where Parm="&y.*type" and level1='1';
if in1 then Model="&y. Unadjusted";
if in2 then Model="&y. Adjusted For hospital characteristics ";
if in3 then Model="&y. Adjusted For hospital characteristics, SNH status, and proportion black";
keep model parm level2 estimate ProbZ;
proc print;
run;

%mend single;
%single(y=y7a);
%single(y=y7b);
%single(y=y7c);
%single(y=y7d);
%single(y=y7e);
%single(y=y7f);
%single(y=y7g);
%single(y=y7h);
%single(y=y7i);
%single(y=y7j);
%single(y=y7k);
%single(y=y7l);
%single(y=y7m);
%single(y=y10);
%single(y=y23e);






%macro composite(y=);
 
    proc sort data=temp;by descending &y.;run;
	proc genmod data=temp order=data ;
		where type in (4,6,12,16,20,22);
		weight wt;
		class &y. type Medicare_id teaching profit2 hospsize hosp_reg4 ruca_level CICU;
		model y=type   &y.  / dist = normal   ;  		
		repeated subject=Medicare_id/type=exch;
        ods output GEEEmpPEst=Estimate1;
	run;
    proc sort data=temp;by descending &y.;run;
	proc genmod data=temp order=data;
		where type in (4,6,12,16,20,22);
		weight wt;
		class &y. type Medicare_id teaching profit2 hospsize hosp_reg4 ruca_level CICU SNH;
		model y=type  &y.  teaching profit2 hospsize hosp_reg4 ruca_level CICU  / dist = normal  ;  		 
		repeated subject=Medicare_id/type=exch;
		 ods output GEEEmpPEst=Estimate2;
	run;
    proc sort data=temp;by descending &y.;run;
	proc genmod data=temp order=data;
		where type in (4,6,12,16,20,22);
		weight wt;
		class &y. type Medicare_id teaching profit2 hospsize hosp_reg4 ruca_level CICU;
		model y=type  &y.  teaching profit2 hospsize hosp_reg4 ruca_level CICU  SNH propblk/ dist = normal  ;  
		repeated subject=Medicare_id/type=exch;
		 ods output GEEEmpPEst=Estimate3;
	run;

data Estimate;
length model $50.;
set Estimate1(in=in1) Estimate2(in=in2) Estimate3(in=in3);
where Parm="&y." and level1='1';
if in1 then Model="&y. Unadjusted";
if in2 then Model="&y. Adjusted For hospital characteristics ";
if in3 then Model="&y. Adjusted For hospital characteristics, SNH status, and proportion black";
keep model parm level2 estimate ProbZ;
proc print;
run;

%mend composite;
%composite(y=y7a);
%composite(y=y7b);
%composite(y=y7c);
%composite(y=y7d);
%composite(y=y7e);
%composite(y=y7f);
%composite(y=y7g);
%composite(y=y7h);
%composite(y=y7i);
%composite(y=y7j);
%composite(y=y7k);
%composite(y=y7l);
%composite(y=y7m);
%composite(y=y10);
%composite(y=y23e);
