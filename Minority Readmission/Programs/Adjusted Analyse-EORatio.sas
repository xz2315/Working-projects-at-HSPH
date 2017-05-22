********************************
Adjusted Analyses --Method 2: Standardized Incidence Ratios : Observed /Expected
Xiner Zhou
4/1/2015
*******************************;

libname data 'C:\data\Projects\Minority_Readmissions\Data';
 

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
	    output out=pred&y._r&row. p=predicted  ;
		 
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
	
 	 proc sort data=pred&y._r&row.;by group_num;run;
	%if &row.=1 %then %do;
    proc sql;
	create table pred1&y._r&row. as
	select group_num, mean(&y.) as oe
	from pred&y._r&row. 
	group by group_num;
	quit;
	%end;

	%else %do;

	proc sql;
	select  mean(&y.) into :overall
	from pred&y._r&row. ;
	quit;

    
    proc sql;
	create table pred1&y._r&row. as
	select group_num,mean(predicted) as expected, mean(&y.) as observed, (calculated expected)/(calculated observed) as ratio, (calculated ratio)*&overall. as oe
	from pred&y._r&row. 
    group by group_num;
	quit;

    %end;

	proc transpose data=pred1&y._r&row. out=oe&y._r&row._t;
		id group_num;
		var oe;
	run;
	data oe&y._r&row._t;
		length title $100.;
		set oe&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
		label _1="Major MSH";
		label _2="MInor MSH";
		label _3="non-MSH";
	keep title _1 _2 _3;
	run;

	%mend model;
	%model(modifier1=,modifier2=,row=1);
	%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level CICU ,modifier2=,row=2);
	%model(modifier1=SNH teaching profit2 hospsize hosp_reg4 ruca_level CICU,modifier2=,row=3);
	%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level CICU,modifier2=total_margin,row=4);

	 
	data ct&y.;
	set ct&y._r1_t ct&y._r2_t ct&y._r3_t ct&y._r4_t;
	run;
    data or&y.;
	set or&y._r1_t or&y._r2_t or&y._r3_t or&y._r4_t;
	run;
	data oe&y.;
	set oe&y._r1_t oe&y._r2_t oe&y._r3_t oe&y._r4_t;
	data &y.;
	merge oe&y. or&y. ct&y. ;
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
 



















%macro question(y=,focus=);
	%macro model(modifier1=,modifier2=,row=);

	proc sort data=data.survey_analytic;by descending &y. descending SNH;run;

	proc genmod data=data.survey_analytic order=data;
		class SNH &y. &modifier1.;
		model &y.=SNH &modifier1. &modifier2./ dist = bin link = logit  ; 
		weight wt;
		contrast "SNH vs non-SNH" SNH 1 -1;
		estimate 'SNH vs non-SNH' SNH 1 -1/ exp;
		ods output   contrasts=ct&y._r&row. estimate=or&y._r&row. ;
		 output out=pred&y._r&row. p=predicted  ;
		 
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

   proc sort data=pred&y._r&row.;by SNH;run;
	%if &row.=1 %then %do;
    proc sql;
	create table pred1&y._r&row. as
	select  SNH, mean(&y.) as oe
	from pred&y._r&row. 
	group by SNH;
	quit;
	%end;

	%else %do;

	proc sql;
	select  mean(&y.) into :overall
	from pred&y._r&row. ;
	quit;

    
    proc sql;
	create table pred1&y._r&row. as
	select SNH,mean(predicted) as expected, mean(&y.) as observed, (calculated expected)/(calculated observed) as ratio, (calculated ratio)*&overall. as oe
	from pred&y._r&row. 
    group by SNH;
	quit;

    %end;

	proc transpose data=pred1&y._r&row. out=oe&y._r&row._t;
		id SNH;
		var oe;
	run;
	data oe&y._r&row._t;
		length title $100.;
		set oe&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
		label _1="SNH";
		label _0="non-SNH";
 
	keep title _0 _1 ;
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
	
	%mend model;
	%model(modifier1=,modifier2=,row=1);
	%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level CICU ,modifier2=,row=2);
	%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level CICU,modifier2=propblk,row=3);
	%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level CICU,modifier2=total_margin,row=4);

	data oe&y.;
	set oe&y._r1_t oe&y._r2_t oe&y._r3_t oe&y._r4_t;
	run;
	data ct&y.;
	set ct&y._r1_t ct&y._r2_t ct&y._r3_t ct&y._r4_t;
	run;
    data or&y.;
	set or&y._r1_t or&y._r2_t or&y._r3_t or&y._r4_t;
	run;
	data &y.;
	merge oe&y. or&y. ct&y. ;
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
























%macro question(y=,focus=);
	%macro model(modifier1=,modifier2=,row=);

	proc sort data=data.survey_analytic;by descending &y. quality;run;

	proc genmod data=data.survey_analytic order=data;
	 
		class quality &y. &modifier1.;
		model &y.=quality &modifier1. &modifier2./ dist = bin link = logit  ; 
		weight wt;
		 
		contrast "Global Test" quality 1 -1 0, quality 0 1 -1;
		contrast "Q1 vs Q2-3" quality 1 -1 0;
		contrast "Q1 vs Q4" quality 1 0 -1;
		contrast "Q2-3 vs Q4" quality 0 1 -1;
	    estimate 'Q1 vs Q2-3' quality 1 -1 0/ exp;
		estimate "Q1 vs Q4" quality 1 0 -1/ exp;
		estimate "Q2-3 vs Q4" quality 0 1 -1/ exp;
		ods output   contrasts=ct&y._r&row. estimates=or&y._r&row. ;
		 output out=pred&y._r&row. p=predicted  ;
		 	 
	run;

	proc transpose data=ct&y._r&row. out=ct&y._r&row._t;
		id contrast;
		var ProbChiSq;
	run;
	data ct&y._r&row._t;
		length title $100.;
		set ct&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
		label Global_Test="Q1 vs Q2-3 vs Q4";
		label Q1_vs_Q2_3="Q1 vs Q2-3";
		label Q1_vs_Q4="Q1 vs Q4";
		label Q2_3_vs_Q4="Q2-3 vs Q4";
		keep title Global_Test Q1_vs_Q2_3 Q1_vs_Q4 Q2_3_vs_Q4;
	run;

	 proc sort data=pred&y._r&row.;by quality;run;
	%if &row.=1 %then %do;
	 
    proc sql;
	create table pred1&y._r&row. as
	select quality, mean(&y.) as oe
	from pred&y._r&row.
    group by quality
	;
	
	quit;
	%end;

	%else %do;
    
	proc sql;
	select  mean(&y.) into :overall
	from pred&y._r&row. ;
	quit;

    
    proc sql;
	create table pred1&y._r&row. as
	select quality,mean(predicted) as expected, mean(&y.) as observed, (calculated expected)/(calculated observed) as ratio, (calculated ratio)*&overall. as oe
	from pred&y._r&row. 
    group by quality;
	quit;

    %end;

	proc transpose data=pred1&y._r&row. out=oe&y._r&row._t;
		id quality;
		var oe;
	run;
	data oe&y._r&row._t;
		length title $100.;
		set oe&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
		label _1="Q1";
		label _2="Q2-3";
		label _3="Q4";
	keep title _1 _2 _3;
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
	 
		label Exp_Q1_vs_Q2_3_="Odds Ratio:Q1 vs Q2-3";
		label Exp_Q1_vs_Q4_="Odds Ratio:Q1 vs Q4";
		label Exp_Q2_3_vs_Q4_="Odds Ratio:Q2-3 vs Q4";
		keep title Exp_Q1_vs_Q2_3_ Exp_Q1_vs_Q4_ Exp_Q2_3_vs_Q4_;
	run;
	%mend model;
	%model(modifier1=,modifier2=,row=1);
	%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level CICU ,modifier2=,row=2);
	%model(modifier1=SNH teaching profit2 hospsize hosp_reg4 ruca_level CICU,modifier2=propblk,row=3);
 
	data oe&y.;
	set oe&y._r1_t oe&y._r2_t oe&y._r3_t ;
	run;
	data ct&y.;
	set ct&y._r1_t ct&y._r2_t ct&y._r3_t ;
	run;
    data or&y.;
	set or&y._r1_t or&y._r2_t or&y._r3_t ;
	run;
	data &y.;
	merge oe&y. or&y. ct&y. ;
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
 


 










%macro question(y=,focus=);
	%macro model(modifier1=,modifier2=,row=);

	proc sort data=data.survey_analytic;by descending &y. quality;run;

	proc genmod data=data.survey_analytic order=data;
		where group_num in (1,2);
		class quality &y. &modifier1.;
		model &y.=quality &modifier1. &modifier2./ dist = bin link = logit  ; 
		weight wt;
		 
		contrast "Global Test" quality 1 -1 0, quality 0 1 -1;
		contrast "Q1 vs Q2-3" quality 1 -1 0;
		contrast "Q1 vs Q4" quality 1 0 -1;
		contrast "Q2-3 vs Q4" quality 0 1 -1;
	    estimate 'Q1 vs Q2-3' quality 1 -1 0/ exp;
		estimate "Q1 vs Q4" quality 1 0 -1/ exp;
		estimate "Q2-3 vs Q4" quality 0 1 -1/ exp;
		ods output   contrasts=ct&y._r&row. estimates=or&y._r&row. ;
		 output out=pred&y._r&row. p=predicted  ;
		 	 
	run;

	proc transpose data=ct&y._r&row. out=ct&y._r&row._t;
		id contrast;
		var ProbChiSq;
	run;
	data ct&y._r&row._t;
		length title $100.;
		set ct&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
		label Global_Test="Q1 vs Q2-3 vs Q4";
		label Q1_vs_Q2_3="Q1 vs Q2-3";
		label Q1_vs_Q4="Q1 vs Q4";
		label Q2_3_vs_Q4="Q2-3 vs Q4";
		keep title Global_Test Q1_vs_Q2_3 Q1_vs_Q4 Q2_3_vs_Q4;
	run;

	 proc sort data=pred&y._r&row.;by quality;run;
	%if &row.=1 %then %do;
	 
    proc sql;
	create table pred1&y._r&row. as
	select quality, mean(&y.) as oe
	from pred&y._r&row.
    group by quality
	;
	
	quit;
	%end;

	%else %do;
    
	proc sql;
	select  mean(&y.) into :overall
	from pred&y._r&row. ;
	quit;

    
    proc sql;
	create table pred1&y._r&row. as
	select quality,mean(predicted) as expected, mean(&y.) as observed, (calculated expected)/(calculated observed) as ratio, (calculated ratio)*&overall. as oe
	from pred&y._r&row. 
    group by quality;
	quit;

    %end;

	proc transpose data=pred1&y._r&row. out=oe&y._r&row._t;
		id quality;
		var oe;
	run;
	data oe&y._r&row._t;
		length title $100.;
		set oe&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
		label _1="Q1";
		label _2="Q2-3";
		label _3="Q4";
	keep title _1 _2 _3;
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
	 
		label Exp_Q1_vs_Q2_3_="Odds Ratio:Q1 vs Q2-3";
		label Exp_Q1_vs_Q4_="Odds Ratio:Q1 vs Q4";
		label Exp_Q2_3_vs_Q4_="Odds Ratio:Q2-3 vs Q4";
		keep title Exp_Q1_vs_Q2_3_ Exp_Q1_vs_Q4_ Exp_Q2_3_vs_Q4_;
	run;
	%mend model;
	%model(modifier1=,modifier2=,row=1);
	%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level CICU ,modifier2=,row=2);
	%model(modifier1=SNH teaching profit2 hospsize hosp_reg4 ruca_level CICU,modifier2=propblk,row=3);
 
	data oe&y.;
	set oe&y._r1_t oe&y._r2_t oe&y._r3_t ;
	run;
	data ct&y.;
	set ct&y._r1_t ct&y._r2_t ct&y._r3_t ;
	run;
    data or&y.;
	set or&y._r1_t or&y._r2_t or&y._r3_t ;
	run;
	data &y.;
	merge oe&y. or&y. ct&y. ;
	format _1 _2 _3 percent7.4 ;
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
 
