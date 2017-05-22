********************************
Adjusted Analyses --Method 3: Predicted Means or G-formula
Xiner Zhou
8/24/2016
*******************************;

libname data 'C:\data\Projects\Minority_Readmissions\Data';
/*
data temp;
set data.survey_analytic;provider1=put(provider,z6.);
keep provider1 Hospital_Name;
if substr(provider1,1,2)='22';
proc print;
run;*/

proc freq data=data.survey_analytic;tables SNH/missing;run;
proc means data=data.survey_analytic;class SNH;var DSHpct;run;

data SNH1;
set data.survey_analytic;
where SNH ne .;
SNH=1;
run;
data SNH0;
set data.survey_analytic;
where SNH ne .;
SNH=0;
run;
 

%macro question(y=,focus=);
	%macro model(modifier1=,modifier2=,row=);

	proc sort data=data.survey_analytic;by descending &y. descending SNH;run;

	proc genmod data=data.survey_analytic order=data;
	    where SNH ne .;weight wt;
		class SNH &y. &modifier1.;*Model event='1';
		model &y.=SNH &modifier1. &modifier2./ dist =normal ; 		
		contrast "SNH vs non-SNH" SNH 1 -1;
		 ods output ParameterEstimates=ct&y._r&row.   ;
		store sasuser.beta&y._r&row.;
	run;

proc plm source=sasuser.beta&y._r&row.;
   score data=SNH0 out=SNH0&y._r&row. predicted / ilink;
run;
proc plm source=sasuser.beta&y._r&row.;
   score data=SNH1 out=SNH1&y._r&row. predicted / ilink;
run;
 

	data ct&y._r&row.;
		length title $100.;
		set ct&y._r&row.;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
		where Parameter="SNH" and level1="1";
		keep title estimate ProbChiSq ;
	run;

	 
	%if &row.=1 %then %do;
 	proc means data=data.survey_analytic;
		weight wt;
		class snh;
		var &y.;
		output out=pred1&y._r&row. mean=mean;
	run;
	%end;

	%else %do;
    data temp&y._r&row.;
	set SNH0&y._r&row. SNH1&y._r&row.;
	keep SNH predicted wt;
	run;
	proc means data=temp&y._r&row.;
		weight wt;
		class SNH;
		var predicted;
		output out=pred1&y._r&row. mean=mean;
	run;
	%end;
    proc sort data=pred1&y._r&row.;by SNH;run;
	proc transpose data=pred1&y._r&row. out=predicted&y._r&row._t;
		id SNH;
		var mean;
	run;
	
    data predicted&y._r&row._t;
		length title $100.;
		set predicted&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
	 
		label _0="non SNH";
		label _1="Safety-net Hospital";
		keep title _0 _1;
	run;

	
	%mend model;
	%model(modifier1=,modifier2=,row=1);
	%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level MICU ,modifier2=,row=2);
	*%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level MICU,modifier2=propblk,row=3);
	*%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level MICU,modifier2=total_margin,row=4);

	data predicted&y.;
	set predicted&y._r1_t predicted&y._r2_t  ;
	run;
	data ct&y.;
	set ct&y._r1 ct&y._r2 ;
	run;
  
	data &y.;
	merge predicted&y. ct&y. ;
	format _0 _1 estimate percent7.2 ;
	run;


%mend question;

%question(y=y2A,focus=Yes); 
%question(y=y2B,focus=Yes); 
%question(y=y2C,focus=Yes); 
 
%question(y=y3A,focus=Yes); 
%question(y=y3B,focus=Yes); 
%question(y=y3C,focus=Yes); 
%question(y=y3D,focus=Yes); 
%question(y=y3E,focus=Yes); 
 
%question(y=y4A,focus=Yes); 
%question(y=y4B,focus=Yes); 
%question(y=y4C,focus=Yes); 
%question(y=y4D,focus=Yes);

%question(y=y5,focus=Higher then average);
 
%question(y=y6,focus=Yes); 

%question(y=y7A,focus=always or usual); 
%question(y=y7b,focus=always or usual); 
%question(y=y7c,focus=always or usual); 
%question(y=y7d,focus=always or usual); 
%question(y=y7e,focus=always or usual); 
%question(y=y7f,focus=always or usual); 
%question(y=y7g,focus=always or usual); 
%question(y=y7h,focus=always or usual); 
%question(y=y7i,focus=always or usual); 
%question(y=y7j,focus=always or usual); 
%question(y=y7k,focus=always or usual); 
%question(y=y7l,focus=always or usual); 
%question(y=y7m,focus=always or usual); 

%question(y=y8A,focus=Yes); 
%question(y=y8b,focus=Yes); 
%question(y=y8c,focus=Yes); 
%question(y=y8d,focus=Yes); 
%question(y=y8e,focus=Yes); 
%question(y=y8f,focus=Yes); 
%question(y=y8g,focus=Yes); 
%question(y=y8h,focus=Yes); 
%question(y=y8i,focus=Yes); 
%question(y=y8j,focus=Yes); 
%question(y=y8k,focus=Yes); 
%question(y=y8l,focus=Yes); 
%question(y=y8m,focus=Yes); 

%question(y=y10,focus=Yes);  
  
%question(y=y11A,focus=Yes); ****Based on Q10;
%question(y=y11b,focus=Yes); 
%question(y=y11c,focus=Yes); 
%question(y=y11d,focus=Yes); 

%question(y=y12A,focus=4+great challenge); 
%question(y=y12b,focus=4+great challenge); 
%question(y=y12c,focus=4+great challenge); 
%question(y=y12d,focus=4+great challenge); 
%question(y=y12e,focus=4+great challenge); 
%question(y=y12f,focus=4+great challenge); 
%question(y=y12g,focus=4+great challenge); 
%question(y=y12h,focus=4+great challenge); 

%question(y=y13A,focus=4+great challenge); 
%question(y=y13b,focus=4+great challenge); 

%question(y=y14A,focus=4+great challenge); 
%question(y=y14b,focus=4+great challenge); 
%question(y=y14c,focus=4+great challenge); 
%question(y=y14d,focus=4+great challenge); 
  
%question(y=y15A,focus=4+great challenge); 
%question(y=y15b,focus=4+great challenge); 
%question(y=y15c,focus=4+great challenge); 
%question(y=y15d,focus=4+great challenge); 

%question(y=y16,focus=Yes);
 
%question(y=y18A,focus=4+Great Impact); 
%question(y=y18b,focus=4+Great Impact); 
%question(y=y18c,focus=4+Great Impact); 
 
%question(y=y19A,focus=Extremely Likely); 
%question(y=y19b,focus=Extremely Likely); 

%question(y=y20,focus=Much Too Large); 

%question(y=y21,focus=CARE WILL IMPROVE SOMEWHAT or CARE WILL IMPROVE A GREAT DEAL); 

%question(y=y22A,focus=Agree Strongly); 
%question(y=y22b,focus=Agree Strongly); 
%question(y=y22c,focus=Agree Strongly); 
%question(y=y22d,focus=Agree Strongly); 
%question(y=y22e,focus=Agree Strongly); 
%question(y=y22f,focus=Agree Strongly); 

%question(y=y23a,focus=9+Highest Priority); 
%question(y=y23b,focus=9+Highest Priority); 
%question(y=y23c,focus=9+Highest Priority); 
%question(y=y23d,focus=9+Highest Priority); 
%question(y=y23e,focus=9+Highest Priority); 
%question(y=y23f,focus=9+Highest Priority); 

%question(y=y24a1,focus=Yes);
%question(y=y24b1,focus=Yes);
%question(y=y24a2,focus=Yes);
%question(y=y24b2,focus=Yes);
%question(y=y24c2,focus=Yes);
 
%question(y=y25A1,focus=Yes);
%question(y=y25A2,focus=Yes);
%question(y=y25B1,focus=Yes);
%question(y=y25B2,focus=Yes);
%question(y=y25C1,focus=Yes);
%question(y=y25C2,focus=Yes);
%question(y=y25D1,focus=Yes);
%question(y=y25D2,focus=Yes);
 


data compare_SNH;
set 
 
y2A y2B y2C
y3A y3B y3C y3D y3E 
y4a y4b y4c y4d
y5
y6
y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m
y8a y8b y8c y8d y8e y8f y8g y8h y8i y8j y8k y8l y8m
y10
y11A y11b y11c y11d 
y12a y12b y12c y12d y12e y12f y12g y12h
y13a y13b
y14a y14b y14c y14d
y15a y15b y15c y15d
y16
y18a y18b y18c
y19a y19b
y20
y21
y22a y22b y22c y22d y22e y22f
y23a y23b y23c y23d y23e y23f
y24a1 y24b1 y24a2 y24b2 y24c2
y25A1 y25A2 y25B1 y25B2 y25C1 y25C2 y25D1 y25D2;
proc print;
run;



*******************************************************Compare Quality(Readmission) among Safety-Net Hospitals;
data temp;
set data.survey_analytic;
if SNH=1 and readm ne .;
proc sort;by readm;
proc freq;title "Number of SNH with valid 2012 3-conditions composite Readmission";
tables SNH;
proc means min Q1 median Q3 max;title "Distribution of Readmission among SNH";
var readm;
run;

proc rank data=temp out=temp1 group=4;
var readm;
ranks SNH_readm_Rank;
run;

data temp2;
set temp1;
if SNH_readm_Rank in (0,3);
if SNH_readm_Rank=0 then SNH_quality_Good=1;
else SNH_quality_Good=0;
proc freq;tables SNH_quality_Good/missing;
proc means min mean max;
class SNH_quality_Good;var readm;
run;

data SNH_quality_Good;
set temp2;
SNH_quality_Good=1;
run;

data SNH_quality_Bad;
set temp2;
SNH_quality_Good=0;
run;


%macro question(y=,focus=);
	%macro model(modifier1=,modifier2=,row=);

	proc sort data=temp2;by descending &y. descending SNH_quality_Good;run;

	proc genmod data=temp2 order=data;
		weight wt;
		class SNH_quality_Good &y. &modifier1.;
		model &y.=SNH_quality_Good &modifier1. &modifier2./ dist = normal ; 		
		contrast "Q1 vs Q2-4" SNH_quality_Good 1 -1;		 
		ods output ParameterEstimates=ct&y._r&row.   ;
	   store sasuser.beta&y._r&row.;
	 run;

proc plm source=sasuser.beta&y._r&row.;
   score data=SNH_quality_Good out=SNH_quality_Good&y._r&row. predicted  ;
run;
proc plm source=sasuser.beta&y._r&row.;
   score data=SNH_quality_Bad out=SNH_quality_Bad&y._r&row. predicted  ;
run;

	data ct&y._r&row.;
		length title $100.;
		set ct&y._r&row.;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
		where Parameter="SNH_quality_Good" and level1="1";
		keep title estimate ProbChiSq ;
	run;

  
	 
	%if &row.=1 %then %do;
	proc means data=temp2;
		weight wt;
		class SNH_quality_Good;
		var &y.;
		output out=pred1&y._r&row. mean=mean;
	run;
	%end;

	%else %do;
	
    data temp&y._r&row.;
	set SNH_quality_Good&y._r&row. SNH_quality_Bad&y._r&row.  ;
	keep SNH_quality_Good predicted wt;
	run;
	proc means data=temp&y._r&row.;
		weight wt;
		class SNH_quality_Good;
		var predicted;
		output out=pred1&y._r&row. mean=mean;
	run;
	%end;
    proc sort data=pred1&y._r&row.;by SNH_quality_Good;run;
	proc transpose data=pred1&y._r&row. out=predicted&y._r&row._t;
		id SNH_quality_Good;
		var mean;
	run;
	
    data predicted&y._r&row._t;
		length title $100.;
		set predicted&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
	 
		label _1="Q1";
		label _0="Q2-4";
	 
		keep title _1 _0;
	run;
    

	%mend model;
	%model(modifier1=,modifier2=,row=1);
	%model(modifier1=teaching profit2 hospsize MICU ,modifier2=,row=2);
	*%model(modifier1=SNH teaching profit2 hospsize hosp_reg4 ruca_level micu,modifier2=propblk,row=3);
 
	data predicted&y.;
	set predicted&y._r1_t predicted&y._r2_t  ;
	run;
	data ct&y.;
	set ct&y._r1  ct&y._r2   ;
	run;
   
	data &y.;
	merge predicted&y. ct&y. ;
	format _1 _0 Estimate percent7.2 ;
	run;


%mend question;

%question(y=y2A,focus=Yes); 
%question(y=y2B,focus=Yes); 
%question(y=y2C,focus=Yes); 
 
%question(y=y3A,focus=Yes); 
%question(y=y3B,focus=Yes); 
%question(y=y3C,focus=Yes); 
%question(y=y3D,focus=Yes); 
%question(y=y3E,focus=Yes); 
 
%question(y=y4A,focus=Yes); 
%question(y=y4B,focus=Yes); 
%question(y=y4C,focus=Yes); 
%question(y=y4D,focus=Yes);

%question(y=y5,focus=Higher then average);
 
%question(y=y6,focus=Yes); 

%question(y=y7A,focus=always or usual); 
%question(y=y7b,focus=always or usual); 
%question(y=y7c,focus=always or usual); 
%question(y=y7d,focus=always or usual); 
%question(y=y7e,focus=always or usual); 
%question(y=y7f,focus=always or usual); 
%question(y=y7g,focus=always or usual); 
%question(y=y7h,focus=always or usual); 
%question(y=y7i,focus=always or usual); 
%question(y=y7j,focus=always or usual); 
%question(y=y7k,focus=always or usual); 
%question(y=y7l,focus=always or usual); 
%question(y=y7m,focus=always or usual); 

%question(y=y8A,focus=Yes); 
%question(y=y8b,focus=Yes); 
%question(y=y8c,focus=Yes); 
%question(y=y8d,focus=Yes); 
%question(y=y8e,focus=Yes); 
%question(y=y8f,focus=Yes); 
%question(y=y8g,focus=Yes); 
%question(y=y8h,focus=Yes); 
%question(y=y8i,focus=Yes); 
%question(y=y8j,focus=Yes); 
%question(y=y8k,focus=Yes); 
%question(y=y8l,focus=Yes); 
%question(y=y8m,focus=Yes); 

%question(y=y10,focus=Yes);  
  
%question(y=y11A,focus=Yes); ****Based on Q10;
%question(y=y11b,focus=Yes); 
%question(y=y11c,focus=Yes); 
%question(y=y11d,focus=Yes); 

%question(y=y12A,focus=4+great challenge); 
%question(y=y12b,focus=4+great challenge); 
%question(y=y12c,focus=4+great challenge); 
%question(y=y12d,focus=4+great challenge); 
%question(y=y12e,focus=4+great challenge); 
%question(y=y12f,focus=4+great challenge); 
%question(y=y12g,focus=4+great challenge); 
%question(y=y12h,focus=4+great challenge); 

%question(y=y13A,focus=4+great challenge); 
%question(y=y13b,focus=4+great challenge); 

%question(y=y14A,focus=4+great challenge); 
%question(y=y14b,focus=4+great challenge); 
%question(y=y14c,focus=4+great challenge); 
%question(y=y14d,focus=4+great challenge); 
  
%question(y=y15A,focus=4+great challenge); 
%question(y=y15b,focus=4+great challenge); 
%question(y=y15c,focus=4+great challenge); 
%question(y=y15d,focus=4+great challenge); 

%question(y=y16,focus=Yes);
 
%question(y=y18A,focus=4+Great Impact); 
%question(y=y18b,focus=4+Great Impact); 
%question(y=y18c,focus=4+Great Impact); 
 
%question(y=y19A,focus=Extremely Likely); 
%question(y=y19b,focus=Extremely Likely); 

%question(y=y20,focus=Much Too Large); 

%question(y=y21,focus=CARE WILL IMPROVE SOMEWHAT or CARE WILL IMPROVE A GREAT DEAL); 

%question(y=y22A,focus=Agree Strongly); 
%question(y=y22b,focus=Agree Strongly); 
%question(y=y22c,focus=Agree Strongly); 
%question(y=y22d,focus=Agree Strongly); 
%question(y=y22e,focus=Agree Strongly); 
%question(y=y22f,focus=Agree Strongly); 

%question(y=y23a,focus=9+Highest Priority); 
%question(y=y23b,focus=9+Highest Priority); 
%question(y=y23c,focus=9+Highest Priority); 
%question(y=y23d,focus=9+Highest Priority); 
%question(y=y23e,focus=9+Highest Priority); 
%question(y=y23f,focus=9+Highest Priority); 

%question(y=y24a1,focus=Yes);
%question(y=y24b1,focus=Yes);
%question(y=y24a2,focus=Yes);
%question(y=y24b2,focus=Yes);
%question(y=y24c2,focus=Yes);
 
%question(y=y25A1,focus=Yes);
%question(y=y25A2,focus=Yes);
%question(y=y25B1,focus=Yes);
%question(y=y25B2,focus=Yes);
%question(y=y25C1,focus=Yes);
%question(y=y25C2,focus=Yes);
%question(y=y25D1,focus=Yes);
%question(y=y25D2,focus=Yes);
 


data compare_quality;
set 
 
y2A y2B y2C
y3A y3B y3C y3D y3E 
y4a y4b y4c y4d
y5
y6
y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m
y8a y8b y8c y8d y8e y8f y8g y8h y8i y8j y8k y8l y8m
y10
y11A y11b y11c y11d 
y12a y12b y12c y12d y12e y12f y12g y12h
y13a y13b
y14a y14b y14c y14d
y15a y15b y15c y15d
y16
y18a y18b y18c
y19a y19b
y20
y21
y22a y22b y22c y22d y22e y22f
y23a y23b y23c y23d y23e y23f
y24a1 y24b1 y24a2 y24b2 y24c2
y25A1 y25A2 y25B1 y25B2 y25C1 y25C2 y25D1 y25D2;
proc print;
run;












**********************************Penalty;
data group_num0;
set data.survey_analytic;
penaltygroup=0;
run;
data group_num1;
set data.survey_analytic;
penaltygroup=1;
run;
data group_num2;
set data.survey_analytic;
penaltygroup=2;
run;
 
%macro question(y=,focus=);
	%macro model(modifier1=,modifier2=,row=);

	proc sort data=data.survey_analytic;by descending &y. descending penaltygroup;run;

	proc genmod data=data.survey_analytic order=data;
		class penaltygroup &y. &modifier1.;
		model &y.=penaltygroup &modifier1. &modifier2./ dist = bin link = logit  ;  
		weight wt;
		contrast "Global Test" penaltygroup 1 -1 0, penaltygroup 0 1 -1;
		contrast "Max Penalty vs no Penalty" penaltygroup 1 0 -1;
		contrast "Min Penalty vs no Penalty" penaltygroup 0 1 -1;
		contrast "Max Penalty vs Min Penalty" penaltygroup 1 -1 0;
		estimate "Max Penalty vs no Penalty" penaltygroup 1 0 -1/ exp;
		estimate "Min Penalty vs no Penalty" penaltygroup 0 1 -1/ exp;
		estimate "Max Penalty vs Min Penalty" penaltygroup 1 -1 0/ exp;
		ods output   contrasts=ct&y._r&row. estimates=or&y._r&row. ;
		store sasuser.beta&y._r&row.;
	run;

proc plm source=sasuser.beta&y._r&row.;
   score data=group_num0 out=group0&y._r&row. predicted / ilink;
run;
proc plm source=sasuser.beta&y._r&row.;
   score data=group_num1 out=group1&y._r&row. predicted / ilink;
run;
proc plm source=sasuser.beta&y._r&row.;
   score data=group_num2 out=group2&y._r&row. predicted / ilink;
run;

	proc transpose data=ct&y._r&row. out=ct&y._r&row._t;
		id contrast;
		var ProbChiSq;
	run;
	data ct&y._r&row._t;
		length title $100.;
		set ct&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
		label Global_Test="Max Penalty vs Min Penalty vs No Penalty";
		label Max_Penalty_vs_no_Penalty="Max Penalty vs no Penalty";
		label Min_Penalty_vs_no_Penalty="Min Penalty vs no Penalty";
		label Max_Penalty_vs_Min_Penalty="Max Penalty vs Min Penalty";
		keep title Global_Test Max_Penalty_vs_no_Penalty Min_Penalty_vs_no_Penalty Max_Penalty_vs_Min_Penalty;
	run;

     

	data or&y._r&row. ;
	set or&y._r&row. ;
	if _n_ in (2,4,6);
	keep label LBetaEstimate;
	run;
    proc transpose data=or&y._r&row. out=or&y._r&row._t;
		id label;
		var LBetaEstimate;
	run;
	data or&y._r&row._t;
		length title $100.;
		set or&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
	 
		label Exp_Max_Penalty_vs_no_Penalty_="Odds Ratio:Max Penalty vs no Penalty";
		label Exp_Min_Penalty_vs_no_Penalty_="Odds Ratio:Min Penalty vs no Penalty";
		label Exp_Max_Penalty_vs_Min_Penalty_="Odds Ratio:Max Penalty vs Min Penalty";
		keep title Exp_Max_Penalty_vs_no_Penalty_ Exp_Min_Penalty_vs_no_Penalty_ Exp_Max_Penalty_vs_Min_Penalty_;
	run;

	 
	%if &row.=1 %then %do;
 	proc means data=data.survey_analytic;
	weight wt;
	class penaltygroup;
	var &y.;
	output out=pred1&y._r&row. mean=mean;
	run;
	%end;

	%else %do;
	
    data temp&y._r&row.;
	set group0&y._r&row. group1&y._r&row. group2&y._r&row.;
	keep penaltygroup predicted wt;
	run;
	proc means data=temp&y._r&row.;
	weight wt;
	class penaltygroup;
	var predicted;
	output out=pred1&y._r&row. mean=mean;
	run;
	%end;
    proc sort data=pred1&y._r&row.;by penaltygroup;run;
	proc transpose data=pred1&y._r&row. out=predicted&y._r&row._t;
		id penaltygroup;
		var mean;
	run;
	
    data predicted&y._r&row._t;
		length title $100.;
		set predicted&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
	 
		label _0="No Penalty";
		label _1="Min Penalty";
		label _2="Max Penalty";
		keep title _0 _1 _2;
	run;

	%mend model;
	%model(modifier1=,modifier2=,row=1);
	%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level micu ,modifier2=,row=2);
	%model(modifier1=SNH  teaching profit2 hospsize hosp_reg4 ruca_level micu,modifier2=propblk,row=3);
 

	 
	data ct&y.;
	set ct&y._r1_t ct&y._r2_t ct&y._r3_t  ;
	run;
    data or&y.;
	set or&y._r1_t or&y._r2_t or&y._r3_t  ;
	run;
	data predicted&y.;
	set predicted&y._r1_t predicted&y._r2_t predicted&y._r3_t  ;
	data &y.;
	merge predicted&y. or&y. ct&y. ;
	format _0 _1 _2 percent7.2 ;
	run;


%mend question;

%question(y=y2A,focus=Yes); 
%question(y=y2B,focus=Yes); 
%question(y=y2C,focus=Yes); 
 
%question(y=y3A,focus=Yes); 
%question(y=y3B,focus=Yes); 
%question(y=y3C,focus=Yes); 
%question(y=y3D,focus=Yes); 
%question(y=y3E,focus=Yes); 
 
%question(y=y4A,focus=Yes); 
%question(y=y4B,focus=Yes); 
%question(y=y4C,focus=Yes); 
%question(y=y4D,focus=Yes);

%question(y=y5,focus=Higher then average);
 
%question(y=y6,focus=Yes); 

%question(y=y7A,focus=always or usual); 
%question(y=y7b,focus=always or usual); 
%question(y=y7c,focus=always or usual); 
%question(y=y7d,focus=always or usual); 
%question(y=y7e,focus=always or usual); 
%question(y=y7f,focus=always or usual); 
%question(y=y7g,focus=always or usual); 
%question(y=y7h,focus=always or usual); 
%question(y=y7i,focus=always or usual); 
%question(y=y7j,focus=always or usual); 
%question(y=y7k,focus=always or usual); 
%question(y=y7l,focus=always or usual); 
%question(y=y7m,focus=always or usual); 

%question(y=y8A,focus=Yes); 
%question(y=y8b,focus=Yes); 
%question(y=y8c,focus=Yes); 
%question(y=y8d,focus=Yes); 
%question(y=y8e,focus=Yes); 
%question(y=y8f,focus=Yes); 
%question(y=y8g,focus=Yes); 
%question(y=y8h,focus=Yes); 
%question(y=y8i,focus=Yes); 
%question(y=y8j,focus=Yes); 
%question(y=y8k,focus=Yes); 
%question(y=y8l,focus=Yes); 
%question(y=y8m,focus=Yes); 

%question(y=y10,focus=Yes);  
  
%question(y=y11A,focus=Yes); ****Based on Q10;
%question(y=y11b,focus=Yes); 
%question(y=y11c,focus=Yes); 
%question(y=y11d,focus=Yes); 

%question(y=y12A,focus=4+great challenge); 
%question(y=y12b,focus=4+great challenge); 
%question(y=y12c,focus=4+great challenge); 
%question(y=y12d,focus=4+great challenge); 
%question(y=y12e,focus=4+great challenge); 
%question(y=y12f,focus=4+great challenge); 
%question(y=y12g,focus=4+great challenge); 
%question(y=y12h,focus=4+great challenge); 

%question(y=y13A,focus=4+great challenge); 
%question(y=y13b,focus=4+great challenge); 

%question(y=y14A,focus=4+great challenge); 
%question(y=y14b,focus=4+great challenge); 
%question(y=y14c,focus=4+great challenge); 
%question(y=y14d,focus=4+great challenge); 
  
%question(y=y15A,focus=4+great challenge); 
%question(y=y15b,focus=4+great challenge); 
%question(y=y15c,focus=4+great challenge); 
%question(y=y15d,focus=4+great challenge); 

%question(y=y16,focus=Yes);
 
%question(y=y18A,focus=4+Great Impact); 
%question(y=y18b,focus=4+Great Impact); 
%question(y=y18c,focus=4+Great Impact); 
 
%question(y=y19A,focus=Extremely Likely); 
%question(y=y19b,focus=Extremely Likely); 

%question(y=y20,focus=Much Too Large); 

%question(y=y21,focus=CARE WILL IMPROVE SOMEWHAT or CARE WILL IMPROVE A GREAT DEAL); 

%question(y=y22A,focus=Agree Strongly); 
%question(y=y22b,focus=Agree Strongly); 
%question(y=y22c,focus=Agree Strongly); 
%question(y=y22d,focus=Agree Strongly); 
%question(y=y22e,focus=Agree Strongly); 
%question(y=y22f,focus=Agree Strongly); 

%question(y=y23a,focus=9+Highest Priority); 
%question(y=y23b,focus=9+Highest Priority); 
%question(y=y23c,focus=9+Highest Priority); 
%question(y=y23d,focus=9+Highest Priority); 
%question(y=y23e,focus=9+Highest Priority); 
%question(y=y23f,focus=9+Highest Priority); 

%question(y=y24a1,focus=Yes);
%question(y=y24b1,focus=Yes);
%question(y=y24a2,focus=Yes);
%question(y=y24b2,focus=Yes);
%question(y=y24c2,focus=Yes);
 
%question(y=y25A1,focus=Yes);
%question(y=y25A2,focus=Yes);
%question(y=y25B1,focus=Yes);
%question(y=y25B2,focus=Yes);
%question(y=y25C1,focus=Yes);
%question(y=y25C2,focus=Yes);
%question(y=y25D1,focus=Yes);
%question(y=y25D2,focus=Yes);
 


data compare_MSH;
set 
 
y2A y2B y2C
y3A y3B y3C y3D y3E 
y4a y4b y4c y4d
y5
y6
y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m
y8a y8b y8c y8d y8e y8f y8g y8h y8i y8j y8k y8l y8m
y10
y11A y11b y11c y11d 
y12a y12b y12c y12d y12e y12f y12g y12h
y13a y13b
y14a y14b y14c y14d
y15a y15b y15c y15d
y16
y18a y18b y18c
y19a y19b
y20
y21
y22a y22b y22c y22d y22e y22f
y23a y23b y23c y23d y23e y23f
y24a1 y24b1 y24a2 y24b2 y24c2
y25A1 y25A2 y25B1 y25B2 y25C1 y25C2 y25D1 y25D2;
proc print;
run;


**********************************3-group MSH;
data group_num1;
set data.survey_analytic;
group_num=1;
run;
data group_num2;
set data.survey_analytic;
group_num=2;
run;
data group_num3;
set data.survey_analytic;
group_num=3;
run;
 
%macro question(y=,focus=);
	%macro model(modifier1=,modifier2=,row=);

	proc sort data=data.survey_analytic;by descending &y. group_num;run;

	proc genmod data=data.survey_analytic order=data;
		class group_num &y. &modifier1.;
		model &y.=group_num &modifier1. &modifier2./ dist = bin link = logit  ;  
		weight wt;
		contrast "Global Test" group_num 1 -1 0, group_num 0 1 -1;
		contrast "Major MSH vs Minor MSH" group_num 1 -1 0;
		contrast "Major MSH vs non-MSH" group_num 1 0 -1;
		contrast "Minor MSH vs non-MSH" group_num 0 1 -1;
		estimate 'Major MSH vs Minor MSH' group_num 1 -1 0/ exp;
		estimate "Major MSH vs non-MSH" group_num 1 0 -1/ exp;
		estimate "Minor MSH vs non-MSH" group_num 0 1 -1/ exp;
		ods output   contrasts=ct&y._r&row. estimate=or&y._r&row. ;
		store sasuser.beta&y._r&row.;
	run;

proc plm source=sasuser.beta&y._r&row.;
   score data=group_num1 out=group1&y._r&row. predicted / ilink;
run;
proc plm source=sasuser.beta&y._r&row.;
   score data=group_num2 out=group2&y._r&row. predicted / ilink;
run;
proc plm source=sasuser.beta&y._r&row.;
   score data=group_num3 out=group3&y._r&row. predicted / ilink;
run;

	proc transpose data=ct&y._r&row. out=ct&y._r&row._t;
		id contrast;
		var ProbChiSq;
	run;
	data ct&y._r&row._t;
		length title $100.;
		set ct&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
		label Global_Test="Major MSH vs Minor MSH vs non-MSH";
		label Major_MSH_vs_Minor_MSH="Major MSH vs Minor MSH";
		label Major_MSH_vs_non_MSH="Major MSH vs non-MSH";
		label Minor_MSH_vs_non_MSH="Minor MSH vs non-MSH";
		keep title Global_Test Major_MSH_vs_Minor_MSH Major_MSH_vs_non_MSH Minor_MSH_vs_non_MSH;
	run;

     

	data or&y._r&row. ;
	set or&y._r&row. ;
	if _n_ in (2,4,6);
	keep label LBetaEstimate;
	run;
    proc transpose data=or&y._r&row. out=or&y._r&row._t;
		id label;
		var LBetaEstimate;
	run;
	data or&y._r&row._t;
		length title $100.;
		set or&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
	 
		label Exp_Major_MSH_vs_Minor_MSH_="Odds Ratio:Major MSH vs Minor MSH";
		label Exp_Major_MSH_vs_non_MSH_="Odds Ratio:Major MSH vs non-MSH";
		label Exp_Minor_MSH_vs_non_MSH_="Odds Ratio:Minor MSH vs non-MSH";
		keep title Exp_Major_MSH_vs_Minor_MSH_ Exp_Major_MSH_vs_non_MSH_ Exp_Minor_MSH_vs_non_MSH_;
	run;

	 
	%if &row.=1 %then %do;
 	proc means data=data.survey_analytic;
	weight wt;
	class group_num;
	var &y.;
	output out=pred1&y._r&row. mean=mean;
	run;
	%end;

	%else %do;
	
    data temp&y._r&row.;
	set group1&y._r&row. group2&y._r&row. group3&y._r&row.;
	keep group_num predicted wt;
	run;
	proc means data=temp&y._r&row.;
	weight wt;
	class group_num;
	var predicted;
	output out=pred1&y._r&row. mean=mean;
	run;
	%end;
    proc sort data=pred1&y._r&row.;by group_num;run;
	proc transpose data=pred1&y._r&row. out=predicted&y._r&row._t;
		id group_num;
		var mean;
	run;
	
    data predicted&y._r&row._t;
		length title $100.;
		set predicted&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
	 
		label _1="Major MSH";
		label _2="Minor MSH";
		label _3="non-MSH";
		keep title _1 _2 _3;
	run;

	%mend model;
	%model(modifier1=,modifier2=,row=1);
	%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level micu ,modifier2=,row=2);
	%model(modifier1=SNH teaching profit2 hospsize hosp_reg4 ruca_level micu,modifier2=,row=3);
	%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level micu,modifier2=total_margin,row=4);

	 
	data ct&y.;
	set ct&y._r1_t ct&y._r2_t ct&y._r3_t ct&y._r4_t;
	run;
    data or&y.;
	set or&y._r1_t or&y._r2_t or&y._r3_t or&y._r4_t;
	run;
	data predicted&y.;
	set predicted&y._r1_t predicted&y._r2_t predicted&y._r3_t predicted&y._r4_t;
	data &y.;
	merge predicted&y. or&y. ct&y. ;
	format _1 _2 _3 percent7.2 ;
	run;


%mend question;

%question(y=y2A,focus=Yes); 
%question(y=y2B,focus=Yes); 
%question(y=y2C,focus=Yes); 
 
%question(y=y3A,focus=Yes); 
%question(y=y3B,focus=Yes); 
%question(y=y3C,focus=Yes); 
%question(y=y3D,focus=Yes); 
%question(y=y3E,focus=Yes); 
 
%question(y=y4A,focus=Yes); 
%question(y=y4B,focus=Yes); 
%question(y=y4C,focus=Yes); 
%question(y=y4D,focus=Yes);

%question(y=y5,focus=Higher then average);
 
%question(y=y6,focus=Yes); 

%question(y=y7A,focus=always or usual); 
%question(y=y7b,focus=always or usual); 
%question(y=y7c,focus=always or usual); 
%question(y=y7d,focus=always or usual); 
%question(y=y7e,focus=always or usual); 
%question(y=y7f,focus=always or usual); 
%question(y=y7g,focus=always or usual); 
%question(y=y7h,focus=always or usual); 
%question(y=y7i,focus=always or usual); 
%question(y=y7j,focus=always or usual); 
%question(y=y7k,focus=always or usual); 
%question(y=y7l,focus=always or usual); 
%question(y=y7m,focus=always or usual); 

%question(y=y8A,focus=Yes); 
%question(y=y8b,focus=Yes); 
%question(y=y8c,focus=Yes); 
%question(y=y8d,focus=Yes); 
%question(y=y8e,focus=Yes); 
%question(y=y8f,focus=Yes); 
%question(y=y8g,focus=Yes); 
%question(y=y8h,focus=Yes); 
%question(y=y8i,focus=Yes); 
%question(y=y8j,focus=Yes); 
%question(y=y8k,focus=Yes); 
%question(y=y8l,focus=Yes); 
%question(y=y8m,focus=Yes); 

%question(y=y10,focus=Yes);  
  
%question(y=y11A,focus=Yes); ****Based on Q10;
%question(y=y11b,focus=Yes); 
%question(y=y11c,focus=Yes); 
%question(y=y11d,focus=Yes); 

%question(y=y12A,focus=4+great challenge); 
%question(y=y12b,focus=4+great challenge); 
%question(y=y12c,focus=4+great challenge); 
%question(y=y12d,focus=4+great challenge); 
%question(y=y12e,focus=4+great challenge); 
%question(y=y12f,focus=4+great challenge); 
%question(y=y12g,focus=4+great challenge); 
%question(y=y12h,focus=4+great challenge); 

%question(y=y13A,focus=4+great challenge); 
%question(y=y13b,focus=4+great challenge); 

%question(y=y14A,focus=4+great challenge); 
%question(y=y14b,focus=4+great challenge); 
%question(y=y14c,focus=4+great challenge); 
%question(y=y14d,focus=4+great challenge); 
  
%question(y=y15A,focus=4+great challenge); 
%question(y=y15b,focus=4+great challenge); 
%question(y=y15c,focus=4+great challenge); 
%question(y=y15d,focus=4+great challenge); 

%question(y=y16,focus=Yes);
 
%question(y=y18A,focus=4+Great Impact); 
%question(y=y18b,focus=4+Great Impact); 
%question(y=y18c,focus=4+Great Impact); 
 
%question(y=y19A,focus=Extremely Likely); 
%question(y=y19b,focus=Extremely Likely); 

%question(y=y20,focus=Much Too Large); 

%question(y=y21,focus=CARE WILL IMPROVE SOMEWHAT or CARE WILL IMPROVE A GREAT DEAL); 

%question(y=y22A,focus=Agree Strongly); 
%question(y=y22b,focus=Agree Strongly); 
%question(y=y22c,focus=Agree Strongly); 
%question(y=y22d,focus=Agree Strongly); 
%question(y=y22e,focus=Agree Strongly); 
%question(y=y22f,focus=Agree Strongly); 

%question(y=y23a,focus=9+Highest Priority); 
%question(y=y23b,focus=9+Highest Priority); 
%question(y=y23c,focus=9+Highest Priority); 
%question(y=y23d,focus=9+Highest Priority); 
%question(y=y23e,focus=9+Highest Priority); 
%question(y=y23f,focus=9+Highest Priority); 

%question(y=y24a1,focus=Yes);
%question(y=y24b1,focus=Yes);
%question(y=y24a2,focus=Yes);
%question(y=y24b2,focus=Yes);
%question(y=y24c2,focus=Yes);
 
%question(y=y25A1,focus=Yes);
%question(y=y25A2,focus=Yes);
%question(y=y25B1,focus=Yes);
%question(y=y25B2,focus=Yes);
%question(y=y25C1,focus=Yes);
%question(y=y25C2,focus=Yes);
%question(y=y25D1,focus=Yes);
%question(y=y25D2,focus=Yes);
 


data compare_MSH;
set 
 
y2A y2B y2C
y3A y3B y3C y3D y3E 
y4a y4b y4c y4d
y5
y6
y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m
y8a y8b y8c y8d y8e y8f y8g y8h y8i y8j y8k y8l y8m
y10
y11A y11b y11c y11d 
y12a y12b y12c y12d y12e y12f y12g y12h
y13a y13b
y14a y14b y14c y14d
y15a y15b y15c y15d
y16
y18a y18b y18c
y19a y19b
y20
y21
y22a y22b y22c y22d y22e y22f
y23a y23b y23c y23d y23e y23f
y24a1 y24b1 y24a2 y24b2 y24c2
y25A1 y25A2 y25B1 y25B2 y25C1 y25C2 y25D1 y25D2;
proc print;
run;
 









libname data 'C:\data\Projects\Minority_Readmissions\Data';

data group_num01;
set data.survey_analytic;
group_num0=1;
run;
data group_num00;
set data.survey_analytic;
group_num0=0;
run;

 
%macro question(y=,focus=);
	%macro model(modifier1=,modifier2=,row=);

	proc sort data=data.survey_analytic;by descending &y. descending group_num0;run;

	proc genmod data=data.survey_analytic order=data;
		class group_num0 &y. &modifier1.;
		model &y.=group_num0 &modifier1. &modifier2./ dist = bin link = logit  ;  
		weight wt;
	
		contrast "MSH vs non-MSH" group_num0 1 -1;
	
		estimate 'MSH vs non-MSH' group_num0 1 -1 / exp;
	 
		ods output   contrasts=ct&y._r&row. estimate=or&y._r&row. ;
		store sasuser.beta&y._r&row.;
	run;

proc plm source=sasuser.beta&y._r&row.;
   score data=group_num00 out=group0&y._r&row. predicted / ilink;
run;
proc plm source=sasuser.beta&y._r&row.;
   score data=group_num01 out=group1&y._r&row. predicted / ilink;
run;


	proc transpose data=ct&y._r&row. out=ct&y._r&row._t;
		id contrast;
		var ProbChiSq;
	run;
	data ct&y._r&row._t;
		length title $100.;
		set ct&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
		label MSH_vs_non_MSH="MSH vs non-MSH";
		keep title MSH_vs_non_MSH;
	run;

     

	data or&y._r&row. ;
	set or&y._r&row. ;
	if _n_ in (2,4,6);
	keep label LBetaEstimate;
	run;
    proc transpose data=or&y._r&row. out=or&y._r&row._t;
		id label;
		var LBetaEstimate;
	run;
	data or&y._r&row._t;
		length title $100.;
		set or&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
	 
		label Exp_MSH_vs_non_MSH_="Odds Ratio:MSH vs non-MSH";
	
		keep title Exp_MSH_vs_non_MSH_;
	run;

	 
	%if &row.=1 %then %do;
 	proc means data=data.survey_analytic;
	weight wt;
	class group_num0;
	var &y.;
	output out=pred1&y._r&row. mean=mean;
	run;
	%end;

	%else %do;
	
    data temp&y._r&row.;
	set group0&y._r&row. group1&y._r&row. ;
	keep group_num0 predicted wt;
	run;
	proc means data=temp&y._r&row.;
	weight wt;
	class group_num0;
	var predicted;
	output out=pred1&y._r&row. mean=mean;
	run;
	%end;
    proc sort data=pred1&y._r&row.;by group_num0;run;
	proc transpose data=pred1&y._r&row. out=predicted&y._r&row._t;
		id group_num0;
		var mean;
	run;
	
    data predicted&y._r&row._t;
		length title $100.;
		set predicted&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
	 
		label _0="non-MSH";
		label _1="MSH";
	
		keep title _0 _1;
	run;

	%mend model;
	%model(modifier1=,modifier2=,row=1);
	%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level micu ,modifier2=,row=2);
	%model(modifier1=SNH teaching profit2 hospsize hosp_reg4 ruca_level micu,modifier2=,row=3);
	%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level micu,modifier2=total_margin,row=4);

	 
	data ct&y.;
	set ct&y._r1_t ct&y._r2_t ct&y._r3_t ct&y._r4_t;
	run;
    data or&y.;
	set or&y._r1_t or&y._r2_t or&y._r3_t or&y._r4_t;
	run;
	data predicted&y.;
	set predicted&y._r1_t predicted&y._r2_t predicted&y._r3_t predicted&y._r4_t;
	data &y.;
	merge predicted&y. or&y. ct&y. ;
	format _1 _0 percent7.2 ;
	run;


%mend question;

%question(y=y2A,focus=Yes); 
%question(y=y2B,focus=Yes); 
%question(y=y2C,focus=Yes); 
 
%question(y=y3A,focus=Yes); 
%question(y=y3B,focus=Yes); 
%question(y=y3C,focus=Yes); 
%question(y=y3D,focus=Yes); 
%question(y=y3E,focus=Yes); 
 
%question(y=y4A,focus=Yes); 
%question(y=y4B,focus=Yes); 
%question(y=y4C,focus=Yes); 
%question(y=y4D,focus=Yes);

%question(y=y5,focus=Higher then average);
 
%question(y=y6,focus=Yes); 

%question(y=y7A,focus=always or usual); 
%question(y=y7b,focus=always or usual); 
%question(y=y7c,focus=always or usual); 
%question(y=y7d,focus=always or usual); 
%question(y=y7e,focus=always or usual); 
%question(y=y7f,focus=always or usual); 
%question(y=y7g,focus=always or usual); 
%question(y=y7h,focus=always or usual); 
%question(y=y7i,focus=always or usual); 
%question(y=y7j,focus=always or usual); 
%question(y=y7k,focus=always or usual); 
%question(y=y7l,focus=always or usual); 
%question(y=y7m,focus=always or usual); 

%question(y=y8A,focus=Yes); 
%question(y=y8b,focus=Yes); 
%question(y=y8c,focus=Yes); 
%question(y=y8d,focus=Yes); 
%question(y=y8e,focus=Yes); 
%question(y=y8f,focus=Yes); 
%question(y=y8g,focus=Yes); 
%question(y=y8h,focus=Yes); 
%question(y=y8i,focus=Yes); 
%question(y=y8j,focus=Yes); 
%question(y=y8k,focus=Yes); 
%question(y=y8l,focus=Yes); 
%question(y=y8m,focus=Yes); 

%question(y=y10,focus=Yes);  
  
%question(y=y11A,focus=Yes); ****Based on Q10;
%question(y=y11b,focus=Yes); 
%question(y=y11c,focus=Yes); 
%question(y=y11d,focus=Yes); 

%question(y=y12A,focus=4+great challenge); 
%question(y=y12b,focus=4+great challenge); 
%question(y=y12c,focus=4+great challenge); 
%question(y=y12d,focus=4+great challenge); 
%question(y=y12e,focus=4+great challenge); 
%question(y=y12f,focus=4+great challenge); 
%question(y=y12g,focus=4+great challenge); 
%question(y=y12h,focus=4+great challenge); 

%question(y=y13A,focus=4+great challenge); 
%question(y=y13b,focus=4+great challenge); 

%question(y=y14A,focus=4+great challenge); 
%question(y=y14b,focus=4+great challenge); 
%question(y=y14c,focus=4+great challenge); 
%question(y=y14d,focus=4+great challenge); 
  
%question(y=y15A,focus=4+great challenge); 
%question(y=y15b,focus=4+great challenge); 
%question(y=y15c,focus=4+great challenge); 
%question(y=y15d,focus=4+great challenge); 

%question(y=y16,focus=Yes);
 
%question(y=y18A,focus=4+Great Impact); 
%question(y=y18b,focus=4+Great Impact); 
%question(y=y18c,focus=4+Great Impact); 
 
%question(y=y19A,focus=Extremely Likely); 
%question(y=y19b,focus=Extremely Likely); 

%question(y=y20,focus=Much Too Large); 

%question(y=y21,focus=CARE WILL IMPROVE SOMEWHAT or CARE WILL IMPROVE A GREAT DEAL); 

%question(y=y22A,focus=Agree Strongly); 
%question(y=y22b,focus=Agree Strongly); 
%question(y=y22c,focus=Agree Strongly); 
%question(y=y22d,focus=Agree Strongly); 
%question(y=y22e,focus=Agree Strongly); 
%question(y=y22f,focus=Agree Strongly); 

%question(y=y23a,focus=9+Highest Priority); 
%question(y=y23b,focus=9+Highest Priority); 
%question(y=y23c,focus=9+Highest Priority); 
%question(y=y23d,focus=9+Highest Priority); 
%question(y=y23e,focus=9+Highest Priority); 
%question(y=y23f,focus=9+Highest Priority); 

%question(y=y24a1,focus=Yes);
%question(y=y24b1,focus=Yes);
%question(y=y24a2,focus=Yes);
%question(y=y24b2,focus=Yes);
%question(y=y24c2,focus=Yes);
 
%question(y=y25A1,focus=Yes);
%question(y=y25A2,focus=Yes);
%question(y=y25B1,focus=Yes);
%question(y=y25B2,focus=Yes);
%question(y=y25C1,focus=Yes);
%question(y=y25C2,focus=Yes);
%question(y=y25D1,focus=Yes);
%question(y=y25D2,focus=Yes);
 


data compare_MSH;
set 
 
y2A y2B y2C
y3A y3B y3C y3D y3E 
y4a y4b y4c y4d
y5
y6
y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m
y8a y8b y8c y8d y8e y8f y8g y8h y8i y8j y8k y8l y8m
y10
y11A y11b y11c y11d 
y12a y12b y12c y12d y12e y12f y12g y12h
y13a y13b
y14a y14b y14c y14d
y15a y15b y15c y15d
y16
y18a y18b y18c
y19a y19b
y20
y21
y22a y22b y22c y22d y22e y22f
y23a y23b y23c y23d y23e y23f
y24a1 y24b1 y24a2 y24b2 y24c2
y25A1 y25A2 y25B1 y25B2 y25C1 y25C2 y25D1 y25D2;
proc print;
run;





















proc freq data=data.survey_analytic;tables SNH/missing;run;
proc means data=data.survey_analytic;class SNH;var DSHpct;run;

data SNH1;
set data.survey_analytic;
where SNH ne .;
SNH=1;
run;
data SNH0;
set data.survey_analytic;
where SNH ne .;
SNH=0;
run;
 

%macro question(y=,focus=);
	%macro model(modifier1=,modifier2=,row=);

	proc sort data=data.survey_analytic;by descending &y. descending SNH;run;

	proc genmod data=data.survey_analytic order=data;
	    where SNH ne .;
		class SNH &y. &modifier1.;*Model event='1';
		model &y.=SNH &modifier1. &modifier2./ dist = bin link = logit  ; 
		*weight wt;
		contrast "SNH vs non-SNH" SNH 1 -1;
		estimate 'SNH vs non-SNH' SNH 1 -1/ exp;
		ods output   contrasts=ct&y._r&row. estimate=or&y._r&row. ;
		store sasuser.beta&y._r&row.;
	run;

proc plm source=sasuser.beta&y._r&row.;
   score data=SNH0 out=SNH0&y._r&row. predicted / ilink;
run;
proc plm source=sasuser.beta&y._r&row.;
   score data=SNH1 out=SNH1&y._r&row. predicted / ilink;
run;
 

	proc transpose data=ct&y._r&row. out=ct&y._r&row._t;
		id contrast;
		var ProbChiSq;
	run;
	data ct&y._r&row._t;
		length title $100.;
		set ct&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
		label SNH_vs_non_SNH="SNH vs non-SNH";
		keep title SNH_vs_non_SNH;
	run;

  

	data or&y._r&row. ;
	set or&y._r&row. ;
	if _n_ in (2);
	keep label LBetaEstimate;
	run;
    proc transpose data=or&y._r&row. out=or&y._r&row._t;
		id label;
		var LBetaEstimate;
	run;
	data or&y._r&row._t;
		length title $100.;
		set or&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
	 
		label Exp_SNH_vs_non_SNH_="Odds Ratio:SNH vs non-SNH";
	
		keep title Exp_SNH_vs_non_SNH_;
	run;

	 
	%if &row.=1 %then %do;
 	proc means data=data.survey_analytic;
	*weight wt;
	class snh;
	var &y.;
	output out=pred1&y._r&row. mean=mean;
	run;
	%end;

	%else %do;
	 

	   data temp&y._r&row.;
	set SNH0&y._r&row. SNH1&y._r&row.;
	keep SNH predicted wt;
	run;
	proc means data=temp&y._r&row.;
	*weight wt;
	class SNH;
	var predicted;
	output out=pred1&y._r&row. mean=mean;
	run;
	%end;
    proc sort data=pred1&y._r&row.;by SNH;run;
	proc transpose data=pred1&y._r&row. out=predicted&y._r&row._t;
		id SNH;
		var mean;
	run;
	
    data predicted&y._r&row._t;
		length title $100.;
		set predicted&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
	 
		label _0="non SNH";
		label _1="Safety-net Hospital";
		keep title _0 _1;
	run;

	
	%mend model;
	%model(modifier1=,modifier2=,row=1);
	%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level MICU ,modifier2=,row=2);
	*%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level MICU,modifier2=propblk,row=3);
	*%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level MICU,modifier2=total_margin,row=4);

	data predicted&y.;
	set predicted&y._r1_t predicted&y._r2_t  ;
	run;
	data ct&y.;
	set ct&y._r1_t ct&y._r2_t ;
	run;
    data or&y.;
	set or&y._r1_t or&y._r2_t ;
	run;
	data &y.;
	merge predicted&y. or&y. ct&y. ;
	format _0 _1 percent7.2 ;
	run;


%mend question;

%question(y=y2A,focus=Yes); 
%question(y=y2B,focus=Yes); 
%question(y=y2C,focus=Yes); 
 
%question(y=y3A,focus=Yes); 
%question(y=y3B,focus=Yes); 
%question(y=y3C,focus=Yes); 
%question(y=y3D,focus=Yes); 
%question(y=y3E,focus=Yes); 
 
%question(y=y4A,focus=Yes); 
%question(y=y4B,focus=Yes); 
%question(y=y4C,focus=Yes); 
%question(y=y4D,focus=Yes);

%question(y=y5,focus=Higher then average);
 
%question(y=y6,focus=Yes); 

%question(y=y7A,focus=always or usual); 
%question(y=y7b,focus=always or usual); 
%question(y=y7c,focus=always or usual); 
%question(y=y7d,focus=always or usual); 
%question(y=y7e,focus=always or usual); 
%question(y=y7f,focus=always or usual); 
%question(y=y7g,focus=always or usual); 
%question(y=y7h,focus=always or usual); 
%question(y=y7i,focus=always or usual); 
%question(y=y7j,focus=always or usual); 
%question(y=y7k,focus=always or usual); 
%question(y=y7l,focus=always or usual); 
%question(y=y7m,focus=always or usual); 

%question(y=y8A,focus=Yes); 
%question(y=y8b,focus=Yes); 
%question(y=y8c,focus=Yes); 
%question(y=y8d,focus=Yes); 
%question(y=y8e,focus=Yes); 
%question(y=y8f,focus=Yes); 
%question(y=y8g,focus=Yes); 
%question(y=y8h,focus=Yes); 
%question(y=y8i,focus=Yes); 
%question(y=y8j,focus=Yes); 
%question(y=y8k,focus=Yes); 
%question(y=y8l,focus=Yes); 
%question(y=y8m,focus=Yes); 

%question(y=y10,focus=Yes);  
  
%question(y=y11A,focus=Yes); ****Based on Q10;
%question(y=y11b,focus=Yes); 
%question(y=y11c,focus=Yes); 
%question(y=y11d,focus=Yes); 

%question(y=y12A,focus=4+great challenge); 
%question(y=y12b,focus=4+great challenge); 
%question(y=y12c,focus=4+great challenge); 
%question(y=y12d,focus=4+great challenge); 
%question(y=y12e,focus=4+great challenge); 
%question(y=y12f,focus=4+great challenge); 
%question(y=y12g,focus=4+great challenge); 
%question(y=y12h,focus=4+great challenge); 

%question(y=y13A,focus=4+great challenge); 
%question(y=y13b,focus=4+great challenge); 

%question(y=y14A,focus=4+great challenge); 
%question(y=y14b,focus=4+great challenge); 
%question(y=y14c,focus=4+great challenge); 
%question(y=y14d,focus=4+great challenge); 
  
%question(y=y15A,focus=4+great challenge); 
%question(y=y15b,focus=4+great challenge); 
%question(y=y15c,focus=4+great challenge); 
%question(y=y15d,focus=4+great challenge); 

%question(y=y16,focus=Yes);
 
%question(y=y18A,focus=4+Great Impact); 
%question(y=y18b,focus=4+Great Impact); 
%question(y=y18c,focus=4+Great Impact); 
 
%question(y=y19A,focus=Extremely Likely); 
%question(y=y19b,focus=Extremely Likely); 

%question(y=y20,focus=Much Too Large); 

%question(y=y21,focus=CARE WILL IMPROVE SOMEWHAT or CARE WILL IMPROVE A GREAT DEAL); 

%question(y=y22A,focus=Agree Strongly); 
%question(y=y22b,focus=Agree Strongly); 
%question(y=y22c,focus=Agree Strongly); 
%question(y=y22d,focus=Agree Strongly); 
%question(y=y22e,focus=Agree Strongly); 
%question(y=y22f,focus=Agree Strongly); 

%question(y=y23a,focus=9+Highest Priority); 
%question(y=y23b,focus=9+Highest Priority); 
%question(y=y23c,focus=9+Highest Priority); 
%question(y=y23d,focus=9+Highest Priority); 
%question(y=y23e,focus=9+Highest Priority); 
%question(y=y23f,focus=9+Highest Priority); 

%question(y=y24a1,focus=Yes);
%question(y=y24b1,focus=Yes);
%question(y=y24a2,focus=Yes);
%question(y=y24b2,focus=Yes);
%question(y=y24c2,focus=Yes);
 
%question(y=y25A1,focus=Yes);
%question(y=y25A2,focus=Yes);
%question(y=y25B1,focus=Yes);
%question(y=y25B2,focus=Yes);
%question(y=y25C1,focus=Yes);
%question(y=y25C2,focus=Yes);
%question(y=y25D1,focus=Yes);
%question(y=y25D2,focus=Yes);
 


data compare_SNH;
set 
 
y2A y2B y2C
y3A y3B y3C y3D y3E 
y4a y4b y4c y4d
y5
y6
y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m
y8a y8b y8c y8d y8e y8f y8g y8h y8i y8j y8k y8l y8m
y10
y11A y11b y11c y11d 
y12a y12b y12c y12d y12e y12f y12g y12h
y13a y13b
y14a y14b y14c y14d
y15a y15b y15c y15d
y16
y18a y18b y18c
y19a y19b
y20
y21
y22a y22b y22c y22d y22e y22f
y23a y23b y23c y23d y23e y23f
y24a1 y24b1 y24a2 y24b2 y24c2
y25A1 y25A2 y25B1 y25B2 y25C1 y25C2 y25D1 y25D2;
proc print;
run;























data quality1;
set data.survey_analytic;
quality=1;
run;
data quality2;
set data.survey_analytic;
quality=2;
run;
data quality3;
set data.survey_analytic;
quality=3;
run;
%macro question(y=,focus=);
	%macro model(modifier1=,modifier2=,row=);

	proc sort data=data.survey_analytic;by descending &y. quality;run;

	proc genmod data=data.survey_analytic order=data;
		*where group_num in (1,2);
		class quality &y. &modifier1.;
		model &y.=quality &modifier1. &modifier2./ dist = bin link = logit  ; 
		weight wt;
		 
		contrast "Global Test" quality 1 -1 0, quality 0 1 -1;
		contrast "Q1 vs Q2-4" quality 1 -1 0;
		contrast "Q1 vs Q5" quality 1 0 -1;
		contrast "Q2-4 vs Q5" quality 0 1 -1;
	    estimate 'Q1 vs Q2-4' quality 1 -1 0/ exp;
		estimate "Q1 vs Q5" quality 1 0 -1/ exp;
		estimate "Q2-4 vs Q5" quality 0 1 -1/ exp;
		ods output   contrasts=ct&y._r&row. estimates=or&y._r&row. ;
	   store sasuser.beta&y._r&row.;
	 run;

proc plm source=sasuser.beta&y._r&row.;
   score data=quality1 out=quality1&y._r&row. predicted / ilink;
run;
proc plm source=sasuser.beta&y._r&row.;
   score data=quality2 out=quality2&y._r&row. predicted / ilink;
run;
proc plm source=sasuser.beta&y._r&row.;
   score data=quality3 out=quality3&y._r&row. predicted / ilink;
run;

	proc transpose data=ct&y._r&row. out=ct&y._r&row._t;
		id contrast;
		var ProbChiSq;
	run;
	data ct&y._r&row._t;
		length title $100.;
		set ct&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
		label Global_Test="Q1 vs Q2-4 vs Q5";
		label Q1_vs_Q2_4="Q1 vs Q2-4";
		label Q1_vs_Q5="Q1 vs Q5";
		label Q2_4_vs_Q5="Q2-4 vs Q5";
		keep title Global_Test Q1_vs_Q2_4 Q1_vs_Q5 Q2_4_vs_Q5;
	run;

 

	data or&y._r&row. ;
	set or&y._r&row. ;
	if _n_ in (2,4,6);
	keep label LBetaEstimate;
	run;
    proc transpose data=or&y._r&row. out=or&y._r&row._t;
		id label;
		var LBetaEstimate;
	run;
	data or&y._r&row._t;
		length title $100.;
		set or&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
	 
		label Exp_Q1_vs_Q2_4_="Odds Ratio:Q1 vs Q2-4";
		label Exp_Q1_vs_Q5_="Odds Ratio:Q1 vs Q5";
		label Exp_Q2_4_vs_Q5_="Odds Ratio:Q2-4 vs Q5";
		keep title Exp_Q1_vs_Q2_4_ Exp_Q1_vs_Q5_ Exp_Q2_4_vs_Q5_;
	run;

	 
	%if &row.=1 %then %do;
     
	proc means data=data.survey_analytic;
	weight wt;
	class quality;
	var &y.;
	output out=pred1&y._r&row. mean=mean;
	run;
	%end;

	%else %do;
	
    data temp&y._r&row.;
	set quality1&y._r&row. quality2&y._r&row. quality3&y._r&row.;
	keep quality predicted wt;
	run;
	proc means data=temp&y._r&row.;
	weight wt;
	class quality;
	var predicted;
	output out=pred1&y._r&row. mean=mean;
	run;
	%end;
    proc sort data=pred1&y._r&row.;by quality;run;
	proc transpose data=pred1&y._r&row. out=predicted&y._r&row._t;
		id quality;
		var mean;
	run;
	
    data predicted&y._r&row._t;
		length title $100.;
		set predicted&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
	 
		label _1="Q1";
		label _2="Q2-4";
		label _3="Q5";
		keep title _1 _2 _3;
	run;
    

	%mend model;
	%model(modifier1=,modifier2=,row=1);
	%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level micu ,modifier2=,row=2);
	%model(modifier1=SNH teaching profit2 hospsize hosp_reg4 ruca_level micu,modifier2=propblk,row=3);
 
	data predicted&y.;
	set predicted&y._r1_t predicted&y._r2_t predicted&y._r3_t ;
	run;
	data ct&y.;
	set ct&y._r1_t ct&y._r2_t ct&y._r3_t ;
	run;
    data or&y.;
	set or&y._r1_t or&y._r2_t or&y._r3_t ;
	run;
	data &y.;
	merge predicted&y. or&y. ct&y. ;
	format _1 _2 _3 percent7.2 ;
	run;


%mend question;

%question(y=y2A,focus=Yes); 
%question(y=y2B,focus=Yes); 
%question(y=y2C,focus=Yes); 
 
%question(y=y3A,focus=Yes); 
%question(y=y3B,focus=Yes); 
%question(y=y3C,focus=Yes); 
%question(y=y3D,focus=Yes); 
%question(y=y3E,focus=Yes); 
 
%question(y=y4A,focus=Yes); 
%question(y=y4B,focus=Yes); 
%question(y=y4C,focus=Yes); 
%question(y=y4D,focus=Yes);

%question(y=y5,focus=Higher then average);
 
%question(y=y6,focus=Yes); 

%question(y=y7A,focus=always or usual); 
%question(y=y7b,focus=always or usual); 
%question(y=y7c,focus=always or usual); 
%question(y=y7d,focus=always or usual); 
%question(y=y7e,focus=always or usual); 
%question(y=y7f,focus=always or usual); 
%question(y=y7g,focus=always or usual); 
%question(y=y7h,focus=always or usual); 
%question(y=y7i,focus=always or usual); 
%question(y=y7j,focus=always or usual); 
%question(y=y7k,focus=always or usual); 
%question(y=y7l,focus=always or usual); 
%question(y=y7m,focus=always or usual); 

%question(y=y8A,focus=Yes); 
%question(y=y8b,focus=Yes); 
%question(y=y8c,focus=Yes); 
%question(y=y8d,focus=Yes); 
%question(y=y8e,focus=Yes); 
%question(y=y8f,focus=Yes); 
%question(y=y8g,focus=Yes); 
%question(y=y8h,focus=Yes); 
%question(y=y8i,focus=Yes); 
%question(y=y8j,focus=Yes); 
%question(y=y8k,focus=Yes); 
%question(y=y8l,focus=Yes); 
%question(y=y8m,focus=Yes); 

%question(y=y10,focus=Yes);  
  
%question(y=y11A,focus=Yes); ****Based on Q10;
%question(y=y11b,focus=Yes); 
%question(y=y11c,focus=Yes); 
%question(y=y11d,focus=Yes); 

%question(y=y12A,focus=4+great challenge); 
%question(y=y12b,focus=4+great challenge); 
%question(y=y12c,focus=4+great challenge); 
%question(y=y12d,focus=4+great challenge); 
%question(y=y12e,focus=4+great challenge); 
%question(y=y12f,focus=4+great challenge); 
%question(y=y12g,focus=4+great challenge); 
%question(y=y12h,focus=4+great challenge); 

%question(y=y13A,focus=4+great challenge); 
%question(y=y13b,focus=4+great challenge); 

%question(y=y14A,focus=4+great challenge); 
%question(y=y14b,focus=4+great challenge); 
%question(y=y14c,focus=4+great challenge); 
%question(y=y14d,focus=4+great challenge); 
  
%question(y=y15A,focus=4+great challenge); 
%question(y=y15b,focus=4+great challenge); 
%question(y=y15c,focus=4+great challenge); 
%question(y=y15d,focus=4+great challenge); 

%question(y=y16,focus=Yes);
 
%question(y=y18A,focus=4+Great Impact); 
%question(y=y18b,focus=4+Great Impact); 
%question(y=y18c,focus=4+Great Impact); 
 
%question(y=y19A,focus=Extremely Likely); 
%question(y=y19b,focus=Extremely Likely); 

%question(y=y20,focus=Much Too Large); 

%question(y=y21,focus=CARE WILL IMPROVE SOMEWHAT or CARE WILL IMPROVE A GREAT DEAL); 

%question(y=y22A,focus=Agree Strongly); 
%question(y=y22b,focus=Agree Strongly); 
%question(y=y22c,focus=Agree Strongly); 
%question(y=y22d,focus=Agree Strongly); 
%question(y=y22e,focus=Agree Strongly); 
%question(y=y22f,focus=Agree Strongly); 

%question(y=y23a,focus=9+Highest Priority); 
%question(y=y23b,focus=9+Highest Priority); 
%question(y=y23c,focus=9+Highest Priority); 
%question(y=y23d,focus=9+Highest Priority); 
%question(y=y23e,focus=9+Highest Priority); 
%question(y=y23f,focus=9+Highest Priority); 

%question(y=y24a1,focus=Yes);
%question(y=y24b1,focus=Yes);
%question(y=y24a2,focus=Yes);
%question(y=y24b2,focus=Yes);
%question(y=y24c2,focus=Yes);
 
%question(y=y25A1,focus=Yes);
%question(y=y25A2,focus=Yes);
%question(y=y25B1,focus=Yes);
%question(y=y25B2,focus=Yes);
%question(y=y25C1,focus=Yes);
%question(y=y25C2,focus=Yes);
%question(y=y25D1,focus=Yes);
%question(y=y25D2,focus=Yes);
 


data compare_quality;
set 
 
y2A y2B y2C
y3A y3B y3C y3D y3E 
y4a y4b y4c y4d
y5
y6
y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m
y8a y8b y8c y8d y8e y8f y8g y8h y8i y8j y8k y8l y8m
y10
y11A y11b y11c y11d 
y12a y12b y12c y12d y12e y12f y12g y12h
y13a y13b
y14a y14b y14c y14d
y15a y15b y15c y15d
y16
y18a y18b y18c
y19a y19b
y20
y21
y22a y22b y22c y22d y22e y22f
y23a y23b y23c y23d y23e y23f
y24a1 y24b1 y24a2 y24b2 y24c2
y25A1 y25A2 y25B1 y25B2 y25C1 y25C2 y25D1 y25D2;
proc print;
run;
 


 








*********************
Compare Quality among MSH(Major and Minor Only):
IÅfm hoping to have the Quality Measure (MSH only Q1-Q4) done slightly different.  I only want the top 25% MSHs compared to other 3 quartiles (combining Q2-Q3 and Q4). 
********************;
data quality1;
set data.survey_analytic;
where group_num in (1,2);
quality=1;
run;
data quality2;
set data.survey_analytic;
where group_num in (1,2);
quality=2;
run;
 
%macro question(y=,focus=);
	%macro model(modifier1=,modifier2=,row=);

	proc sort data=data.survey_analytic;by descending &y. quality;run;

	proc genmod data=data.survey_analytic order=data;
		where group_num in (1,2);
		class quality &y. &modifier1.;
		model &y.=quality &modifier1. &modifier2./ dist = bin link = logit  ; 
		weight wt;
		 
		 
		contrast "Q1 vs Q2-4" quality 1 -1 0;
		 
	    estimate 'Q1 vs Q2-4' quality 1 -1 0/ exp;
		 
		ods output   contrasts=ct&y._r&row. estimates=or&y._r&row. ;
	   store sasuser.beta&y._r&row.;
	 run;

proc plm source=sasuser.beta&y._r&row.;
   score data=quality1 out=quality1&y._r&row. predicted / ilink;
run;
proc plm source=sasuser.beta&y._r&row.;
   score data=quality2 out=quality2&y._r&row. predicted / ilink;
run;
 

	proc transpose data=ct&y._r&row. out=ct&y._r&row._t;
		id contrast;
		var ProbChiSq;
	run;
	data ct&y._r&row._t;
		length title $100.;
		set ct&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
		 
		label Q1_vs_Q2_4="Q1 vs Q2-4";
		 
		keep title  Q1_vs_Q2_4;
	run;

 

	data or&y._r&row. ;
	set or&y._r&row. ;
	if _n_ in (2); 
	keep label LBetaEstimate;
	run;
    proc transpose data=or&y._r&row. out=or&y._r&row._t;
		id label;
		var LBetaEstimate;
	run;
	data or&y._r&row._t;
		length title $100.;
		set or&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
	     
		label Exp_Q1_vs_Q2_4_="Odds Ratio:Q1 vs Q2-4";
		 
		keep title Exp_Q1_vs_Q2_4_  ;
	run;

	 
	%if &row.=1 %then %do;
	proc means data=data.survey_analytic;
	where group_num in (1,2);
	weight wt;
	class quality;
	var &y.;
	output out=pred1&y._r&row. mean=mean;
	run;
	%end;

	%else %do;
	
    data temp&y._r&row.;
	set quality1&y._r&row. quality2&y._r&row.  ;
	keep quality predicted wt;
	run;
	proc means data=temp&y._r&row.;
	weight wt;
	class quality;
	var predicted;
	output out=pred1&y._r&row. mean=mean;
	run;
	%end;
    proc sort data=pred1&y._r&row.;by quality;run;
	proc transpose data=pred1&y._r&row. out=predicted&y._r&row._t;
		id quality;
		var mean;
	run;
	
    data predicted&y._r&row._t;
		length title $100.;
		set predicted&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
	 
		label _1="Q1";
		label _2="Q2-4";
		 
		keep title _1 _2  ;
	run;
    

	%mend model;
	%model(modifier1=,modifier2=,row=1);
	%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level micu ,modifier2=,row=2);
	%model(modifier1=SNH teaching profit2 hospsize hosp_reg4 ruca_level micu,modifier2=propblk,row=3);
 
	data predicted&y.;
	set predicted&y._r1_t predicted&y._r2_t predicted&y._r3_t ;
	run;
	data ct&y.;
	set ct&y._r1_t ct&y._r2_t ct&y._r3_t ;
	run;
    data or&y.;
	set or&y._r1_t or&y._r2_t or&y._r3_t ;
	run;
	data &y.;
	merge predicted&y. or&y. ct&y. ;
	format _1 _2   percent7.2 ;
	run;


%mend question;

%question(y=y2A,focus=Yes); 
%question(y=y2B,focus=Yes); 
%question(y=y2C,focus=Yes); 
 
%question(y=y3A,focus=Yes); 
%question(y=y3B,focus=Yes); 
%question(y=y3C,focus=Yes); 
%question(y=y3D,focus=Yes); 
%question(y=y3E,focus=Yes); 
 
%question(y=y4A,focus=Yes); 
%question(y=y4B,focus=Yes); 
%question(y=y4C,focus=Yes); 
%question(y=y4D,focus=Yes);

%question(y=y5,focus=Higher then average);
 
%question(y=y6,focus=Yes); 

%question(y=y7A,focus=always or usual); 
%question(y=y7b,focus=always or usual); 
%question(y=y7c,focus=always or usual); 
%question(y=y7d,focus=always or usual); 
%question(y=y7e,focus=always or usual); 
%question(y=y7f,focus=always or usual); 
%question(y=y7g,focus=always or usual); 
%question(y=y7h,focus=always or usual); 
%question(y=y7i,focus=always or usual); 
%question(y=y7j,focus=always or usual); 
%question(y=y7k,focus=always or usual); 
%question(y=y7l,focus=always or usual); 
%question(y=y7m,focus=always or usual); 

%question(y=y8A,focus=Yes); 
%question(y=y8b,focus=Yes); 
%question(y=y8c,focus=Yes); 
%question(y=y8d,focus=Yes); 
%question(y=y8e,focus=Yes); 
%question(y=y8f,focus=Yes); 
%question(y=y8g,focus=Yes); 
%question(y=y8h,focus=Yes); 
%question(y=y8i,focus=Yes); 
%question(y=y8j,focus=Yes); 
%question(y=y8k,focus=Yes); 
%question(y=y8l,focus=Yes); 
%question(y=y8m,focus=Yes); 

%question(y=y10,focus=Yes);  
  
%question(y=y11A,focus=Yes); ****Based on Q10;
%question(y=y11b,focus=Yes); 
%question(y=y11c,focus=Yes); 
%question(y=y11d,focus=Yes); 

%question(y=y12A,focus=4+great challenge); 
%question(y=y12b,focus=4+great challenge); 
%question(y=y12c,focus=4+great challenge); 
%question(y=y12d,focus=4+great challenge); 
%question(y=y12e,focus=4+great challenge); 
%question(y=y12f,focus=4+great challenge); 
%question(y=y12g,focus=4+great challenge); 
%question(y=y12h,focus=4+great challenge); 

%question(y=y13A,focus=4+great challenge); 
%question(y=y13b,focus=4+great challenge); 

%question(y=y14A,focus=4+great challenge); 
%question(y=y14b,focus=4+great challenge); 
%question(y=y14c,focus=4+great challenge); 
%question(y=y14d,focus=4+great challenge); 
  
%question(y=y15A,focus=4+great challenge); 
%question(y=y15b,focus=4+great challenge); 
%question(y=y15c,focus=4+great challenge); 
%question(y=y15d,focus=4+great challenge); 

%question(y=y16,focus=Yes);
 
%question(y=y18A,focus=4+Great Impact); 
%question(y=y18b,focus=4+Great Impact); 
%question(y=y18c,focus=4+Great Impact); 
 
%question(y=y19A,focus=Extremely Likely); 
%question(y=y19b,focus=Extremely Likely); 

%question(y=y20,focus=Much Too Large); 

%question(y=y21,focus=CARE WILL IMPROVE SOMEWHAT or CARE WILL IMPROVE A GREAT DEAL); 

%question(y=y22A,focus=Agree Strongly); 
%question(y=y22b,focus=Agree Strongly); 
%question(y=y22c,focus=Agree Strongly); 
%question(y=y22d,focus=Agree Strongly); 
%question(y=y22e,focus=Agree Strongly); 
%question(y=y22f,focus=Agree Strongly); 

%question(y=y23a,focus=9+Highest Priority); 
%question(y=y23b,focus=9+Highest Priority); 
%question(y=y23c,focus=9+Highest Priority); 
%question(y=y23d,focus=9+Highest Priority); 
%question(y=y23e,focus=9+Highest Priority); 
%question(y=y23f,focus=9+Highest Priority); 

%question(y=y24a1,focus=Yes);
%question(y=y24b1,focus=Yes);
%question(y=y24a2,focus=Yes);
%question(y=y24b2,focus=Yes);
%question(y=y24c2,focus=Yes);
 
%question(y=y25A1,focus=Yes);
%question(y=y25A2,focus=Yes);
%question(y=y25B1,focus=Yes);
%question(y=y25B2,focus=Yes);
%question(y=y25C1,focus=Yes);
%question(y=y25C2,focus=Yes);
%question(y=y25D1,focus=Yes);
%question(y=y25D2,focus=Yes);
 


data compare_quality;
set 
 
y2A y2B y2C
y3A y3B y3C y3D y3E 
y4a y4b y4c y4d
y5
y6
y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m
y8a y8b y8c y8d y8e y8f y8g y8h y8i y8j y8k y8l y8m
y10
y11A y11b y11c y11d 
y12a y12b y12c y12d y12e y12f y12g y12h
y13a y13b
y14a y14b y14c y14d
y15a y15b y15c y15d
y16
y18a y18b y18c
y19a y19b
y20
y21
y22a y22b y22c y22d y22e y22f
y23a y23b y23c y23d y23e y23f
y24a1 y24b1 y24a2 y24b2 y24c2
y25A1 y25A2 y25B1 y25B2 y25C1 y25C2 y25D1 y25D2;
proc print;
run;
  


*******************************************************Compare Quality(Readmission) among Safety-Net Hospitals;
data temp;
set data.survey_analytic;
if SNH=1 and readm ne .;
proc sort;by readm;
proc freq;title "Number of SNH with valid 2012 3-conditions composite Readmission";
tables SNH;
proc means min Q1 median Q3 max;title "Distribution of Readmission among SNH";
var readm;
run;

proc rank data=temp out=temp1 group=3;
var readm;
ranks SNH_readm_Rank;
run;

data temp2;
set temp1;
if SNH_readm_Rank in (0,1,2);
if SNH_readm_Rank=0 then SNH_quality_Good=1;
else  SNH_quality_Good=0;
proc freq;tables SNH_quality_Good/missing;
proc means min mean max;
class SNH_quality_Good;var readm;
run;

data SNH_quality_Good;
set temp2;
SNH_quality_Good=1;
run;

data SNH_quality_Bad;
set temp2;
SNH_quality_Good=0;
run;


%macro question(y=,focus=);
	%macro model(modifier1=,modifier2=,row=);

	proc sort data=temp2;by descending &y. descending SNH_quality_Good;run;

	proc genmod data=temp2 order=data;
		where SNH=1;
		class SNH_quality_Good &y. &modifier1.;
		model &y.=SNH_quality_Good &modifier1. &modifier2./ dist = bin link = logit  ; 
		*weight wt;
		
		contrast "Q1 vs Q2-4" SNH_quality_Good 1 -1;
		estimate "Q1 vs Q2-4" SNH_quality_Good 1 -1/ exp;
		ods output   contrasts=ct&y._r&row. estimates=or&y._r&row. ;
	   store sasuser.beta&y._r&row.;
	 run;

proc plm source=sasuser.beta&y._r&row.;
   score data=SNH_quality_Good out=SNH_quality_Good&y._r&row. predicted / ilink;
run;
proc plm source=sasuser.beta&y._r&row.;
   score data=SNH_quality_Bad out=SNH_quality_Bad&y._r&row. predicted / ilink;
run;

	proc transpose data=ct&y._r&row. out=ct&y._r&row._t;
		id contrast;
		var ProbChiSq;
	run;
	data ct&y._r&row._t;
		length title $100.;
		set ct&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
		label Q1_vs_Q2_4="P-value: Q1 vs Q2-4";
		keep title Q1_vs_Q2_4;
	run;

 

	data or&y._r&row. ;
	set or&y._r&row. ;
	if _n_ in (2,4,6);
	keep label LBetaEstimate;
	run;
    proc transpose data=or&y._r&row. out=or&y._r&row._t;
		id label;
		var LBetaEstimate;
	run;
	data or&y._r&row._t;
		length title $100.;
		set or&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
	 
		label Exp_Q1_vs_Q2_4_="Odds Ratio:Q1 vs Q2-4";
	
		keep title Exp_Q1_vs_Q2_4_;
	run;

	 
	%if &row.=1 %then %do;
	proc means data=temp2;
	where SNH=1;
	*weight wt;
	class SNH_quality_Good;
	var &y.;
	output out=pred1&y._r&row. mean=mean;
	run;
	%end;

	%else %do;
	
    data temp&y._r&row.;
	set SNH_quality_Good&y._r&row. SNH_quality_Bad&y._r&row.  ;
	keep SNH_quality_Good predicted wt;
	run;
	proc means data=temp&y._r&row.;
	*weight wt;
	class SNH_quality_Good;
	var predicted;
	output out=pred1&y._r&row. mean=mean;
	run;
	%end;
    proc sort data=pred1&y._r&row.;by SNH_quality_Good;run;
	proc transpose data=pred1&y._r&row. out=predicted&y._r&row._t;
		id SNH_quality_Good;
		var mean;
	run;
	
    data predicted&y._r&row._t;
		length title $100.;
		set predicted&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
	 
		label _1="Q1";
		label _0="Q2-4";
	 
		keep title _1 _0;
	run;
    

	%mend model;
	%model(modifier1=,modifier2=,row=1);
	%model(modifier1=teaching profit2 hospsize MICU ,modifier2=,row=2);
	*%model(modifier1=SNH teaching profit2 hospsize hosp_reg4 ruca_level micu,modifier2=propblk,row=3);
 
	data predicted&y.;
	set predicted&y._r1_t predicted&y._r2_t  ;
	run;
	data ct&y.;
	set ct&y._r1_t ct&y._r2_t   ;
	run;
    data or&y.;
	set or&y._r1_t or&y._r2_t  ;
	run;
	data &y.;
	merge predicted&y. or&y. ct&y. ;
	format _1 _0 percent7.2 ;
	run;


%mend question;

%question(y=y2A,focus=Yes); 
%question(y=y2B,focus=Yes); 
%question(y=y2C,focus=Yes); 
 
%question(y=y3A,focus=Yes); 
%question(y=y3B,focus=Yes); 
%question(y=y3C,focus=Yes); 
%question(y=y3D,focus=Yes); 
%question(y=y3E,focus=Yes); 
 
%question(y=y4A,focus=Yes); 
%question(y=y4B,focus=Yes); 
%question(y=y4C,focus=Yes); 
%question(y=y4D,focus=Yes);

%question(y=y5,focus=Higher then average);
 
%question(y=y6,focus=Yes); 

%question(y=y7A,focus=always or usual); 
%question(y=y7b,focus=always or usual); 
%question(y=y7c,focus=always or usual); 
%question(y=y7d,focus=always or usual); 
%question(y=y7e,focus=always or usual); 
%question(y=y7f,focus=always or usual); 
%question(y=y7g,focus=always or usual); 
%question(y=y7h,focus=always or usual); 
%question(y=y7i,focus=always or usual); 
%question(y=y7j,focus=always or usual); 
%question(y=y7k,focus=always or usual); 
%question(y=y7l,focus=always or usual); 
%question(y=y7m,focus=always or usual); 

%question(y=y8A,focus=Yes); 
%question(y=y8b,focus=Yes); 
%question(y=y8c,focus=Yes); 
%question(y=y8d,focus=Yes); 
%question(y=y8e,focus=Yes); 
%question(y=y8f,focus=Yes); 
%question(y=y8g,focus=Yes); 
%question(y=y8h,focus=Yes); 
%question(y=y8i,focus=Yes); 
%question(y=y8j,focus=Yes); 
%question(y=y8k,focus=Yes); 
%question(y=y8l,focus=Yes); 
%question(y=y8m,focus=Yes); 

%question(y=y10,focus=Yes);  
  
%question(y=y11A,focus=Yes); ****Based on Q10;
%question(y=y11b,focus=Yes); 
%question(y=y11c,focus=Yes); 
%question(y=y11d,focus=Yes); 

%question(y=y12A,focus=4+great challenge); 
%question(y=y12b,focus=4+great challenge); 
%question(y=y12c,focus=4+great challenge); 
%question(y=y12d,focus=4+great challenge); 
%question(y=y12e,focus=4+great challenge); 
%question(y=y12f,focus=4+great challenge); 
%question(y=y12g,focus=4+great challenge); 
%question(y=y12h,focus=4+great challenge); 

%question(y=y13A,focus=4+great challenge); 
%question(y=y13b,focus=4+great challenge); 

%question(y=y14A,focus=4+great challenge); 
%question(y=y14b,focus=4+great challenge); 
%question(y=y14c,focus=4+great challenge); 
%question(y=y14d,focus=4+great challenge); 
  
%question(y=y15A,focus=4+great challenge); 
%question(y=y15b,focus=4+great challenge); 
%question(y=y15c,focus=4+great challenge); 
%question(y=y15d,focus=4+great challenge); 

%question(y=y16,focus=Yes);
 
%question(y=y18A,focus=4+Great Impact); 
%question(y=y18b,focus=4+Great Impact); 
%question(y=y18c,focus=4+Great Impact); 
 
%question(y=y19A,focus=Extremely Likely); 
%question(y=y19b,focus=Extremely Likely); 

%question(y=y20,focus=Much Too Large); 

%question(y=y21,focus=CARE WILL IMPROVE SOMEWHAT or CARE WILL IMPROVE A GREAT DEAL); 

%question(y=y22A,focus=Agree Strongly); 
%question(y=y22b,focus=Agree Strongly); 
%question(y=y22c,focus=Agree Strongly); 
%question(y=y22d,focus=Agree Strongly); 
%question(y=y22e,focus=Agree Strongly); 
%question(y=y22f,focus=Agree Strongly); 

%question(y=y23a,focus=9+Highest Priority); 
%question(y=y23b,focus=9+Highest Priority); 
%question(y=y23c,focus=9+Highest Priority); 
%question(y=y23d,focus=9+Highest Priority); 
%question(y=y23e,focus=9+Highest Priority); 
%question(y=y23f,focus=9+Highest Priority); 

%question(y=y24a1,focus=Yes);
%question(y=y24b1,focus=Yes);
%question(y=y24a2,focus=Yes);
%question(y=y24b2,focus=Yes);
%question(y=y24c2,focus=Yes);
 
%question(y=y25A1,focus=Yes);
%question(y=y25A2,focus=Yes);
%question(y=y25B1,focus=Yes);
%question(y=y25B2,focus=Yes);
%question(y=y25C1,focus=Yes);
%question(y=y25C2,focus=Yes);
%question(y=y25D1,focus=Yes);
%question(y=y25D2,focus=Yes);
 


data compare_quality;
set 
 
y2A y2B y2C
y3A y3B y3C y3D y3E 
y4a y4b y4c y4d
y5
y6
y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m
y8a y8b y8c y8d y8e y8f y8g y8h y8i y8j y8k y8l y8m
y10
y11A y11b y11c y11d 
y12a y12b y12c y12d y12e y12f y12g y12h
y13a y13b
y14a y14b y14c y14d
y15a y15b y15c y15d
y16
y18a y18b y18c
y19a y19b
y20
y21
y22a y22b y22c y22d y22e y22f
y23a y23b y23c y23d y23e y23f
y24a1 y24b1 y24a2 y24b2 y24c2
y25A1 y25A2 y25B1 y25B2 y25C1 y25C2 y25D1 y25D2;
proc print;
run;

 
*************************************************************************
MSH top 25% vs. other MSHs (just two groups)
a.	Unadjusted and adjusted by hosp char
************************************************************************;
data temp;
set data.survey_analytic ;
if MSH2="Others" then g=0;
else if MSH2 ne "" then g=1;
proc freq;tables MSH2/missing;
proc means ;class MSH2;var propblk;
run;

data MSH;
set temp;
g=1;
run;

data nonMSH;
set temp;
g=0;
run;


%macro question(y=,focus=);
	%macro model(modifier1=,modifier2=,row=);

	proc sort data=temp;by descending &y. descending g;run;

	proc genmod data=temp order=data;
		class g &y. &modifier1.;
		model &y.=g &modifier1. &modifier2./ dist = bin link = logit  ; 
		*weight wt;
		
		contrast "Q4 vs Q1-3" g 1 -1;
		estimate "Q4 vs Q1-3" g 1 -1/ exp;
		ods output   contrasts=ct&y._r&row. estimates=or&y._r&row. ;
	   store sasuser.beta&y._r&row.;
	 run;

proc plm source=sasuser.beta&y._r&row.;
   score data=MSH out=MSH&y._r&row. predicted / ilink;
run;
proc plm source=sasuser.beta&y._r&row.;
   score data=nonMSH out=nonMSH&y._r&row. predicted / ilink;
run;

	proc transpose data=ct&y._r&row. out=ct&y._r&row._t;
		id contrast;
		var ProbChiSq;
	run;
	data ct&y._r&row._t;
		length title $100.;
		set ct&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
		label Q4_vs_Q1_3="P-value: Q4 vs Q1-3";
		keep title Q4_vs_Q1_3;
	run;

 

	data or&y._r&row. ;
	set or&y._r&row. ;
	if _n_ in (2,4,6);
	keep label LBetaEstimate;
	run;
    proc transpose data=or&y._r&row. out=or&y._r&row._t;
		id label;
		var LBetaEstimate;
	run;
	data or&y._r&row._t;
		length title $100.;
		set or&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
	 
		label Exp_Q4_vs_Q1_3_="Odds Ratio:Q4 vs Q1-3";
	
		keep title Exp_Q4_vs_Q1_3_;
	run;

	 
	%if &row.=1 %then %do;
	proc means data=temp;
	*weight wt;
	class g;
	var &y.;
	output out=pred1&y._r&row. mean=mean;
	run;
	%end;

	%else %do;
	
    data temp&y._r&row.;
	set MSH&y._r&row. nonMSH&y._r&row.  ;
	keep g predicted wt;
	run;
	proc means data=temp&y._r&row.;
	*weight wt;
	class g;
	var predicted;
	output out=pred1&y._r&row. mean=mean;
	run;
	%end;
    proc sort data=pred1&y._r&row.;by g;run;
	proc transpose data=pred1&y._r&row. out=predicted&y._r&row._t;
		id g;
		var mean;
	run;
	
    data predicted&y._r&row._t;
		length title $100.;
		set predicted&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
	 
		label _1="Q4";
		label _0="Q1-3";
	 
		keep title _1 _0;
	run;
    

	%mend model;
	%model(modifier1=,modifier2=,row=1);
	%model(modifier1=teaching profit2 hospsize MICU ,modifier2=,row=2);
	*%model(modifier1=SNH teaching profit2 hospsize hosp_reg4 ruca_level micu,modifier2=propblk,row=3);
 
	data predicted&y.;
	set predicted&y._r1_t predicted&y._r2_t  ;
	run;
	data ct&y.;
	set ct&y._r1_t ct&y._r2_t   ;
	run;
    data or&y.;
	set or&y._r1_t or&y._r2_t  ;
	run;
	data &y.;
	merge predicted&y. or&y. ct&y. ;
	format _1 _0 percent7.2 ;
	run;


%mend question;

%question(y=y2A,focus=Yes); 
%question(y=y2B,focus=Yes); 
%question(y=y2C,focus=Yes); 
 
%question(y=y3A,focus=Yes); 
%question(y=y3B,focus=Yes); 
%question(y=y3C,focus=Yes); 
%question(y=y3D,focus=Yes); 
%question(y=y3E,focus=Yes); 
 
%question(y=y4A,focus=Yes); 
%question(y=y4B,focus=Yes); 
%question(y=y4C,focus=Yes); 
%question(y=y4D,focus=Yes);

%question(y=y5,focus=Higher then average);
 
%question(y=y6,focus=Yes); 

%question(y=y7A,focus=always or usual); 
%question(y=y7b,focus=always or usual); 
%question(y=y7c,focus=always or usual); 
%question(y=y7d,focus=always or usual); 
%question(y=y7e,focus=always or usual); 
%question(y=y7f,focus=always or usual); 
%question(y=y7g,focus=always or usual); 
%question(y=y7h,focus=always or usual); 
%question(y=y7i,focus=always or usual); 
%question(y=y7j,focus=always or usual); 
%question(y=y7k,focus=always or usual); 
%question(y=y7l,focus=always or usual); 
%question(y=y7m,focus=always or usual); 

%question(y=y8A,focus=Yes); 
%question(y=y8b,focus=Yes); 
%question(y=y8c,focus=Yes); 
%question(y=y8d,focus=Yes); 
%question(y=y8e,focus=Yes); 
%question(y=y8f,focus=Yes); 
%question(y=y8g,focus=Yes); 
%question(y=y8h,focus=Yes); 
%question(y=y8i,focus=Yes); 
%question(y=y8j,focus=Yes); 
%question(y=y8k,focus=Yes); 
%question(y=y8l,focus=Yes); 
%question(y=y8m,focus=Yes); 

%question(y=y10,focus=Yes);  
  
%question(y=y11A,focus=Yes); ****Based on Q10;
%question(y=y11b,focus=Yes); 
%question(y=y11c,focus=Yes); 
%question(y=y11d,focus=Yes); 

%question(y=y12A,focus=4+great challenge); 
%question(y=y12b,focus=4+great challenge); 
%question(y=y12c,focus=4+great challenge); 
%question(y=y12d,focus=4+great challenge); 
%question(y=y12e,focus=4+great challenge); 
%question(y=y12f,focus=4+great challenge); 
%question(y=y12g,focus=4+great challenge); 
%question(y=y12h,focus=4+great challenge); 

%question(y=y13A,focus=4+great challenge); 
%question(y=y13b,focus=4+great challenge); 

%question(y=y14A,focus=4+great challenge); 
%question(y=y14b,focus=4+great challenge); 
%question(y=y14c,focus=4+great challenge); 
%question(y=y14d,focus=4+great challenge); 
  
%question(y=y15A,focus=4+great challenge); 
%question(y=y15b,focus=4+great challenge); 
%question(y=y15c,focus=4+great challenge); 
%question(y=y15d,focus=4+great challenge); 

%question(y=y16,focus=Yes);
 
%question(y=y18A,focus=4+Great Impact); 
%question(y=y18b,focus=4+Great Impact); 
%question(y=y18c,focus=4+Great Impact); 
 
%question(y=y19A,focus=Extremely Likely); 
%question(y=y19b,focus=Extremely Likely); 

%question(y=y20,focus=Much Too Large); 

%question(y=y21,focus=CARE WILL IMPROVE SOMEWHAT or CARE WILL IMPROVE A GREAT DEAL); 

%question(y=y22A,focus=Agree Strongly); 
%question(y=y22b,focus=Agree Strongly); 
%question(y=y22c,focus=Agree Strongly); 
%question(y=y22d,focus=Agree Strongly); 
%question(y=y22e,focus=Agree Strongly); 
%question(y=y22f,focus=Agree Strongly); 

%question(y=y23a,focus=9+Highest Priority); 
%question(y=y23b,focus=9+Highest Priority); 
%question(y=y23c,focus=9+Highest Priority); 
%question(y=y23d,focus=9+Highest Priority); 
%question(y=y23e,focus=9+Highest Priority); 
%question(y=y23f,focus=9+Highest Priority); 

%question(y=y24a1,focus=Yes);
%question(y=y24b1,focus=Yes);
%question(y=y24a2,focus=Yes);
%question(y=y24b2,focus=Yes);
%question(y=y24c2,focus=Yes);
 
%question(y=y25A1,focus=Yes);
%question(y=y25A2,focus=Yes);
%question(y=y25B1,focus=Yes);
%question(y=y25B2,focus=Yes);
%question(y=y25C1,focus=Yes);
%question(y=y25C2,focus=Yes);
%question(y=y25D1,focus=Yes);
%question(y=y25D2,focus=Yes);
 


data compare_quality;
set 
 
y2A y2B y2C
y3A y3B y3C y3D y3E 
y4a y4b y4c y4d
y5
y6
y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m
y8a y8b y8c y8d y8e y8f y8g y8h y8i y8j y8k y8l y8m
y10
y11A y11b y11c y11d 
y12a y12b y12c y12d y12e y12f y12g y12h
y13a y13b
y14a y14b y14c y14d
y15a y15b y15c y15d
y16
y18a y18b y18c
y19a y19b
y20
y21
y22a y22b y22c y22d y22e y22f
y23a y23b y23c y23d y23e y23f
y24a1 y24b1 y24a2 y24b2 y24c2
y25A1 y25A2 y25B1 y25B2 y25C1 y25C2 y25D1 y25D2;
proc print;
run;

**********************************************************************************
By Quality:
a.	Top 25% of hospitals with lowest readmission rates compared to everyone else.
b.	Unadjusted and adjusted by hosp char
*********************************************************************************;
proc rank data= data.survey_analytic out=temp group=4;
var readm;
ranks readm_rank;
run;

data temp;
set temp;
if readm_rank=0 then do;
	Readm2="Top25% Lowest Readmission Rate";
	g=1;
end;
else if readm ne . and readm_rank ne 0 then do;
	Readm2="Others";
	g=0;
end;
else do;
    Readm2="";
	g=.;
end;

proc freq;tables readm2/missing;
proc means;class readm2;var readm;
run;


data LowReadm;
set temp;
where Readm2 ne "";
g=1;
run;

data HighReadm;
set temp;
where Readm2 ne "";
g=0;
run;


%macro question(y=,focus=);
	%macro model(modifier1=,modifier2=,row=);

	proc sort data=temp;by descending &y. descending g;run;

	proc genmod data=temp order=data;
		class g &y. &modifier1.;
		model &y.=g &modifier1. &modifier2./ dist = bin link = logit  ; 
		*weight wt;
		
		contrast "Q1 vs Q2-4" g 1 -1;
		estimate "Q1 vs Q2-4" g 1 -1/ exp;
		ods output   contrasts=ct&y._r&row. estimates=or&y._r&row. ;
	   store sasuser.beta&y._r&row.;
	 run;

proc plm source=sasuser.beta&y._r&row.;
   score data=LowReadm out=LowReadm&y._r&row. predicted / ilink;
run;
proc plm source=sasuser.beta&y._r&row.;
   score data=HighReadm out=HighReadm&y._r&row. predicted / ilink;
run;

	proc transpose data=ct&y._r&row. out=ct&y._r&row._t;
		id contrast;
		var ProbChiSq;
	run;
	data ct&y._r&row._t;
		length title $100.;
		set ct&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
		label Q1_vs_Q2_4="P-value: Q1 vs Q2-4";
		keep title Q1_vs_Q2_4;
	run;

 

	data or&y._r&row. ;
	set or&y._r&row. ;
	if _n_ in (2,4,6);
	keep label LBetaEstimate;
	run;
    proc transpose data=or&y._r&row. out=or&y._r&row._t;
		id label;
		var LBetaEstimate;
	run;
	data or&y._r&row._t;
		length title $100.;
		set or&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
	 
		label Exp_Q1_vs_Q2_4_="Odds Ratio:Q1 vs Q2-4";
	
		keep title Exp_Q1_vs_Q2_4_;
	run;

	 
	%if &row.=1 %then %do;
	proc means data=temp;
	*weight wt;
	class g;
	var &y.;
	output out=pred1&y._r&row. mean=mean;
	run;
	%end;

	%else %do;
	
    data temp&y._r&row.;
	set LowReadm&y._r&row. HighReadm&y._r&row.  ;
	keep g predicted wt;
	run;
	proc means data=temp&y._r&row.;
	*weight wt;
	class g;
	var predicted;
	output out=pred1&y._r&row. mean=mean;
	run;
	%end;
    proc sort data=pred1&y._r&row.;by g;run;
	proc transpose data=pred1&y._r&row. out=predicted&y._r&row._t;
		id g;
		var mean;
	run;
	
    data predicted&y._r&row._t;
		length title $100.;
		set predicted&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
	 
		label _1="Q1";
		label _0="Q2-4";
	 
		keep title _1 _0;
	run;
    

	%mend model;
	%model(modifier1=,modifier2=,row=1);
	%model(modifier1=teaching profit2 hospsize MICU ,modifier2=,row=2);
	*%model(modifier1=SNH teaching profit2 hospsize hosp_reg4 ruca_level micu,modifier2=propblk,row=3);
 
	data predicted&y.;
	set predicted&y._r1_t predicted&y._r2_t  ;
	run;
	data ct&y.;
	set ct&y._r1_t ct&y._r2_t   ;
	run;
    data or&y.;
	set or&y._r1_t or&y._r2_t  ;
	run;
	data &y.;
	merge predicted&y. or&y. ct&y. ;
	format _1 _0 percent7.2 ;
	run;


%mend question;

%question(y=y2A,focus=Yes); 
%question(y=y2B,focus=Yes); 
%question(y=y2C,focus=Yes); 
 
%question(y=y3A,focus=Yes); 
%question(y=y3B,focus=Yes); 
%question(y=y3C,focus=Yes); 
%question(y=y3D,focus=Yes); 
%question(y=y3E,focus=Yes); 
 
%question(y=y4A,focus=Yes); 
%question(y=y4B,focus=Yes); 
%question(y=y4C,focus=Yes); 
%question(y=y4D,focus=Yes);

%question(y=y5,focus=Higher then average);
 
%question(y=y6,focus=Yes); 

%question(y=y7A,focus=always or usual); 
%question(y=y7b,focus=always or usual); 
%question(y=y7c,focus=always or usual); 
%question(y=y7d,focus=always or usual); 
%question(y=y7e,focus=always or usual); 
%question(y=y7f,focus=always or usual); 
%question(y=y7g,focus=always or usual); 
%question(y=y7h,focus=always or usual); 
%question(y=y7i,focus=always or usual); 
%question(y=y7j,focus=always or usual); 
%question(y=y7k,focus=always or usual); 
%question(y=y7l,focus=always or usual); 
%question(y=y7m,focus=always or usual); 

%question(y=y8A,focus=Yes); 
%question(y=y8b,focus=Yes); 
%question(y=y8c,focus=Yes); 
%question(y=y8d,focus=Yes); 
%question(y=y8e,focus=Yes); 
%question(y=y8f,focus=Yes); 
%question(y=y8g,focus=Yes); 
%question(y=y8h,focus=Yes); 
%question(y=y8i,focus=Yes); 
%question(y=y8j,focus=Yes); 
%question(y=y8k,focus=Yes); 
%question(y=y8l,focus=Yes); 
%question(y=y8m,focus=Yes); 

%question(y=y10,focus=Yes);  
  
%question(y=y11A,focus=Yes); ****Based on Q10;
%question(y=y11b,focus=Yes); 
%question(y=y11c,focus=Yes); 
%question(y=y11d,focus=Yes); 

%question(y=y12A,focus=4+great challenge); 
%question(y=y12b,focus=4+great challenge); 
%question(y=y12c,focus=4+great challenge); 
%question(y=y12d,focus=4+great challenge); 
%question(y=y12e,focus=4+great challenge); 
%question(y=y12f,focus=4+great challenge); 
%question(y=y12g,focus=4+great challenge); 
%question(y=y12h,focus=4+great challenge); 

%question(y=y13A,focus=4+great challenge); 
%question(y=y13b,focus=4+great challenge); 

%question(y=y14A,focus=4+great challenge); 
%question(y=y14b,focus=4+great challenge); 
%question(y=y14c,focus=4+great challenge); 
%question(y=y14d,focus=4+great challenge); 
  
%question(y=y15A,focus=4+great challenge); 
%question(y=y15b,focus=4+great challenge); 
%question(y=y15c,focus=4+great challenge); 
%question(y=y15d,focus=4+great challenge); 

%question(y=y16,focus=Yes);
 
%question(y=y18A,focus=4+Great Impact); 
%question(y=y18b,focus=4+Great Impact); 
%question(y=y18c,focus=4+Great Impact); 
 
%question(y=y19A,focus=Extremely Likely); 
%question(y=y19b,focus=Extremely Likely); 

%question(y=y20,focus=Much Too Large); 

%question(y=y21,focus=CARE WILL IMPROVE SOMEWHAT or CARE WILL IMPROVE A GREAT DEAL); 

%question(y=y22A,focus=Agree Strongly); 
%question(y=y22b,focus=Agree Strongly); 
%question(y=y22c,focus=Agree Strongly); 
%question(y=y22d,focus=Agree Strongly); 
%question(y=y22e,focus=Agree Strongly); 
%question(y=y22f,focus=Agree Strongly); 

%question(y=y23a,focus=9+Highest Priority); 
%question(y=y23b,focus=9+Highest Priority); 
%question(y=y23c,focus=9+Highest Priority); 
%question(y=y23d,focus=9+Highest Priority); 
%question(y=y23e,focus=9+Highest Priority); 
%question(y=y23f,focus=9+Highest Priority); 

%question(y=y24a1,focus=Yes);
%question(y=y24b1,focus=Yes);
%question(y=y24a2,focus=Yes);
%question(y=y24b2,focus=Yes);
%question(y=y24c2,focus=Yes);
 
%question(y=y25A1,focus=Yes);
%question(y=y25A2,focus=Yes);
%question(y=y25B1,focus=Yes);
%question(y=y25B2,focus=Yes);
%question(y=y25C1,focus=Yes);
%question(y=y25C2,focus=Yes);
%question(y=y25D1,focus=Yes);
%question(y=y25D2,focus=Yes);
 


data compare_quality;
set 
 
y2A y2B y2C
y3A y3B y3C y3D y3E 
y4a y4b y4c y4d
y5
y6
y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m
y8a y8b y8c y8d y8e y8f y8g y8h y8i y8j y8k y8l y8m
y10
y11A y11b y11c y11d 
y12a y12b y12c y12d y12e y12f y12g y12h
y13a y13b
y14a y14b y14c y14d
y15a y15b y15c y15d
y16
y18a y18b y18c
y19a y19b
y20
y21
y22a y22b y22c y22d y22e y22f
y23a y23b y23c y23d y23e y23f
y24a1 y24b1 y24a2 y24b2 y24c2
y25A1 y25A2 y25B1 y25B2 y25C1 y25C2 y25D1 y25D2;
proc print;
run;
