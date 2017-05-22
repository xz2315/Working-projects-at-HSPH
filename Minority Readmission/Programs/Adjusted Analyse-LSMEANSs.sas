********************************
Adjusted Analyses --Method1: LS-Means
Xiner Zhou
2/24/2014
*******************************;

libname data 'C:\data\Projects\Minority_Readmissions\Data';

  
%macro question(y=,focus=);
 
proc genmod data=data.survey_analytic order=data;
class group_num &y.  ;
		model &y.=group_num  / dist = bin link = logit  ; 
		weight wt; 
effectplot / at(group_num=all)  ;
*effectplot slicefit(sliceby=g  ) / noobs; 
run;
 


	%macro model(modifier1=,modifier2=,row=);

	proc sort data=data.survey_analytic;by descending &y. group_num;run;

	proc genmod data=data.survey_analytic order=data;
		class group_num &y. &modifier1.;
		model &y.=group_num &modifier1. &modifier2./ dist = bin link = logit  ; 
		weight wt;
		lsmeans group_num/ilink om=data.survey_analytic ;
		contrast "Global Test" group_num 1 -1 0, group_num 0 1 -1;
		contrast "Major MSH vs Minor MSH" group_num 1 -1 0;
		contrast "Major MSH vs non-MSH" group_num 1 0 -1;
		contrast "Minor MSH vs non-MSH" group_num 0 1 -1;
		ods output lsmeans=ls&y._r&row. contrasts=ct&y._r&row.  ;
		 
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

	proc transpose data=ls&y._r&row. out=ls&y._r&row._t;
		id group_num;
		var mu;
	run;
	data ls&y._r&row._t;
		length title $100.;
		set ls&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
		label _1="Major MSH";
		label _2="Minor MSH";
		label _3="non-MSH";
	keep title _1 _2 _3;
	run;
	%mend model;
	%model(modifier1=,modifier2=,row=1);
	%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level CICU ,modifier2=,row=2);
	%model(modifier1=SNH teaching profit2 hospsize hosp_reg4 ruca_level CICU,modifier2=,row=3);
	%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level CICU,modifier2=total_margin,row=4);

	data ls&y.;
	set ls&y._r1_t ls&y._r2_t ls&y._r3_t ls&y._r4_t;
	run;
	data ct&y.;
	set ct&y._r1_t ct&y._r2_t ct&y._r3_t ct&y._r4_t;
	run;
	data &y.;
	merge ls&y. ct&y.;
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

	proc sort data=data.survey_analytic;by descending &y. SNH;run;

	proc genmod data=data.survey_analytic order=data;
		class SNH &y. &modifier1.;
		model &y.=SNH &modifier1. &modifier2./ dist = bin link = logit  ; 
		weight wt;
		lsmeans SNH/ilink om=data.survey_analytic ;	 
		contrast "SNH vs non-SNH" SNH 1 -1;
		ods output lsmeans=ls&y._r&row. contrasts=ct&y._r&row.;
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

	proc transpose data=ls&y._r&row. out=ls&y._r&row._t;
		id SNH;
		var mu;
	run;
	data ls&y._r&row._t;
		length title $100.;
		set ls&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
		label _1="SNH";
		label _0="non-SNH";
 
	keep title _0 _1 ;
	run;
	%mend model;
	%model(modifier1=,modifier2=,row=1);
	%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level CICU ,modifier2=,row=2);
	%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level CICU,modifier2=propblk,row=3);
	%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level CICU,modifier2=total_margin,row=4);

	data ls&y.;
	set ls&y._r1_t ls&y._r2_t ls&y._r3_t ls&y._r4_t;
	run;
	data ct&y.;
	set ct&y._r1_t ct&y._r2_t ct&y._r3_t ct&y._r4_t;
	run;
	data &y.;
	merge ls&y. ct&y.;
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

	proc sort data=data.survey_analytic;by descending &y.;run;

	proc genmod data=data.survey_analytic order=data;
		class group_num0 &y. &modifier1.;
		model &y.=group_num0 &modifier1. &modifier2./ dist = bin link = logit  ; 
		weight wt;
		lsmeans group_num0/ilink om=data.survey_analytic ;
		contrast "MSH vs non-MSH" group_num0 1 -1;
		ods output lsmeans=ls&y._r&row. contrasts=ct&y._r&row.;
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

	proc transpose data=ls&y._r&row. out=ls&y._r&row._t;
		id group_num0;
		var mu;
	run;
	data ls&y._r&row._t;
		length title $100.;
		set ls&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
		label _1="MSH";
		label _0="non-MSH";
	keep title _0 _1;
	run;
	%mend model;
	%model(modifier1=,modifier2=,row=1);
	%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level CICU ,modifier2=,row=2);
	%model(modifier1=SNH teaching profit2 hospsize hosp_reg4 ruca_level CICU,modifier2=,row=3);
	%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level CICU,modifier2=total_margin,row=4);

	data ls&y.;
	set ls&y._r1_t ls&y._r2_t ls&y._r3_t ls&y._r4_t;
	run;
	data ct&y.;
	set ct&y._r1_t ct&y._r2_t ct&y._r3_t ct&y._r4_t;
	run;
	data &y.;
	merge ls&y. ct&y.;
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

	proc sort data=data.survey_analytic;by descending &y. quality;run;

	proc genmod data=data.survey_analytic order=data;
		where group_num in (1,2);
		class quality &y. &modifier1.;
		model &y.=quality &modifier1. &modifier2./ dist = bin link = logit  ; 
		weight wt;
		lsmeans quality/ilink om=data.survey_analytic    ;
		contrast "Global Test" quality 1 -1 0, quality 0 1 -1;
		contrast "Q1 vs Q2-4" quality 1 -1 0;
		contrast "Q1 vs Q5" quality 1 0 -1;
		contrast "Q2-4 vs Q5" quality 0 1 -1;
		ods output lsmeans=ls&y._r&row. contrasts=ct&y._r&row.;
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

	proc transpose data=ls&y._r&row. out=ls&y._r&row._t;
		id quality;
		var mu;
	run;
	data ls&y._r&row._t;
		length title $100.;
		set ls&y._r&row._t;
		title="&y. %(&focus.) Adjusted for &modifier2 &modifier1 ";
		label _1="Q1";
		label _2="Q2-4";
		label _3="Q5";
	keep title _1 _2 _3;
	run;
	%mend model;
	%model(modifier1=,modifier2=,row=1);
	%model(modifier1=teaching profit2 hospsize hosp_reg4 ruca_level CICU ,modifier2=,row=2);
	%model(modifier1=SNH teaching profit2 hospsize hosp_reg4 ruca_level CICU,modifier2=propblk,row=3);
 
	data ls&y.;
	set ls&y._r1_t ls&y._r2_t ls&y._r3_t  ;
	run;
	data ct&y.;
	set ct&y._r1_t ct&y._r2_t ct&y._r3_t  ;
	run;
	data &y.;
	merge ls&y. ct&y.;
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
 


 
