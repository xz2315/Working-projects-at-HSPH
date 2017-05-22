********************************
Adjusted Analyses --Q9 and Q17
Xiner Zhou
4/2/2015
*******************************;

libname data 'C:\data\Projects\Minority_Readmissions\Data';
%let group=group_num0;
%let group=SNH;

/*
Q9:
Which strategy from the above list do you think has the most potential to reduce 30-day readmissions 
at your hospital? And what has the second most potential?   
*/

/*
Q17:
If Yes, please specify the two most important (challenges to reducing readmissions not mentioned above)   
*/
***********************************Q9.1;
proc format ;
value $ q9_
	A='Use a dedicated discharge planner or discharge coordinator'
	B='Create a discharge summary prior to discharge and share this with the patient outpatient provider'
	C='Communicate discharge plan verbally to primary care physician or next care provider at discharge'
	D='Use electronic tools to share discharge summaries or other care plans with outpatient providers'
	E='Schedule follow-up appointments for all patients prior to discharge'
	F='Use pharmacists to reconcile discharge medications with prior outpatient medications'
	G='Use electronic tools to reconcile discharge medications with prior outpatient medications'
	H='Use a formal discharge checklist to document when all components of discharge protocol are complete'
	I='Contact patients by phone within 48 hours after discharge to monitor their progress'
	J='Use a transition coach to help patients manage medications and other self-care issues'
	K='Enroll patients in a 30-day post-discharge care coordination or disease management program'
	L='Enroll patients in a post-discharge patient activation and engagement program'
	M='Use mobile or web-based applications to support patients and families in carrying out post-discharge care plans'
	N='Other'
	S='Medication reconciliation (may be inclusive of F/G)'
	T='Transition in care/Care coordination' 
	U='Combinations/Multiple options'
	V='Follow-up appointment within # days (less about when scheduled and more about when it occurs)'
	W='Discharge summary communicated (may  be inclusive of B/C/D)'
	X='Patient compliance issues including references to ensuring that patient’s follow-up appointments with primary care physician are kept' 
;
run;

*** Overall freq;
proc freq data=data.survey_analytic;
	where RECODE_Q9_1 in ('A','B','C','D','E','F','G','H','I','J','K','L','M','N');
	format RECODE_Q9_1 $Q9_.;
	weight wt;
	tables RECODE_Q9_1 / out=Q91all outpct nopercent nocum norow   ;
run;
data Q91all;
	set Q91all;	
	percent_all=percent/100;
	keep RECODE_Q9_1 percent_all;
proc sort;by descending percent_all;
proc print;
run;

*** Take >5% choices;
data temp;
	set data.survey_analytic ;
	where RECODE_Q9_1 in ('A','B','C','D','E','F','G','H','I','J','K','L','M','N');
	if RECODE_Q9_1 not in ('J','A','I','K','E','N')  then RECODE_Q9_1='O';
run;


proc freq data=temp;
	format RECODE_Q9_1 $Q9_.;
	weight wt;
	tables RECODE_Q9_1*&group. /out=Q91 outpct nopercent nocum norow  ;
run;

proc transpose data=Q91 out=Q91t;
	var PCT_COL;
	by RECODE_Q9_1;
	id &group.;
run;

data q91t;
	set q91t;
	drop _label_ _name_;
	_0=_0/100;_1=_1/100;
run;
 
%macro cmp(var=);

data temp;
	set temp;
	if RECODE_Q9_1="&var." then y=1;else y=0;
	proc sort;by descending &group. descending y;
run;

proc genmod data=temp order=data;
	class &group. y;
	weight wt;
	model y=&group.  / dist = bin link = logit  ; 
	contrast "Group1 vs Group2" &group. 1 -1;
	ods output    contrasts=p&var.;
run;


data p&var.;
	set p&var.;
	RECODE_Q9_1="&var.";
	keep ProbChiSq RECODE_Q9_1;
run;

%mend cmp;
%cmp(var=J);
%cmp(var=A);
%cmp(var=I);
%cmp(var=K);
%cmp(var=E);
%cmp(var=N);
%cmp(var=O);
data p;
	set pA pE pI pJ pK pN pO;
run;

proc sql;
	create table table2 as
	select a.*,b.*
	from Q91t a left join p b
	on a.RECODE_Q9_1=b.RECODE_Q9_1;
quit;
proc print;
	var RECODE_Q9_1 _0 _1 ProbChiSq;
run;

***********************************Q9.2; 
  proc format ;
value $ q9_
	A='Use a dedicated discharge planner or discharge coordinator'
	B='Create a discharge summary prior to discharge and share this with the patient outpatient provider'
	C='Communicate discharge plan verbally to primary care physician or next care provider at discharge'
	D='Use electronic tools to share discharge summaries or other care plans with outpatient providers'
	E='Schedule follow-up appointments for all patients prior to discharge'
	F='Use pharmacists to reconcile discharge medications with prior outpatient medications'
	G='Use electronic tools to reconcile discharge medications with prior outpatient medications'
	H='Use a formal discharge checklist to document when all components of discharge protocol are complete'
	I='Contact patients by phone within 48 hours after discharge to monitor their progress'
	J='Use a transition coach to help patients manage medications and other self-care issues'
	K='Enroll patients in a 30-day post-discharge care coordination or disease management program'
	L='Enroll patients in a post-discharge patient activation and engagement program'
	M='Use mobile or web-based applications to support patients and families in carrying out post-discharge care plans'
	N='Other'
	S='Medication reconciliation (may be inclusive of F/G)'
	T='Transition in care/Care coordination' 
	U='Combinations/Multiple options'
	V='Follow-up appointment within # days (less about when scheduled and more about when it occurs)'
	W='Discharge summary communicated (may  be inclusive of B/C/D)'
	X='Patient compliance issues including references to ensuring that patient’s follow-up appointments with primary care physician are kept' 
;
run;

*** Overall freq;
proc freq data=data.survey_analytic;
	where RECODE_Q9_2 in ('A','B','C','D','E','F','G','H','I','J','K','L','M','N');
	format RECODE_Q9_2 $Q9_.;
	weight wt;
	tables RECODE_Q9_2 / out=Q92all outpct nopercent nocum norow   ;
run;
data Q92all;
	set Q92all;	
	percent_all=percent/100;
	keep RECODE_Q9_2 percent_all;
proc sort;by descending percent_all;
proc print;
run;

*** Take >5% choices;
data temp;
	set data.survey_analytic ;
	where RECODE_Q9_2 in ('A','B','C','D','E','F','G','H','I','J','K','L','M','N');
	if RECODE_Q9_2 not in ('J','F','I','K','E','N')  then RECODE_Q9_2='O';
run;


proc freq data=temp;
	format RECODE_Q9_2 $Q9_.;
	weight wt;
	tables RECODE_Q9_2*&group. /out=Q92 outpct nopercent nocum norow  ;
run;

proc transpose data=Q92 out=Q92t;
	var PCT_COL;
	by RECODE_Q9_2;
	id &group.;
run;

data q92t;
	set q92t;
	drop _label_ _name_;
	_0=_0/100;_1=_1/100;
run;
 
%macro cmp(var=);

data temp;
	set temp;
	if RECODE_Q9_2="&var." then y=1;else y=0;
	proc sort;by descending &group. descending y;
run;

proc genmod data=temp order=data;
	class &group. y;
	weight wt;
	model y=&group. / dist = bin link = logit  ; 
	contrast "Group1 vs Group2" &group. 1 -1;
	ods output    contrasts=p&var.;
run;


data p&var.;
	set p&var.;
	RECODE_Q9_2="&var.";
	keep ProbChiSq RECODE_Q9_2;
run;

%mend cmp;
%cmp(var=J);
%cmp(var=F);
%cmp(var=I);
%cmp(var=K);
%cmp(var=E);
%cmp(var=N);
%cmp(var=O);
data p;
	set pF pE pI pJ pK pN pO;
run;

proc sql;
	create table table2 as
	select a.*,b.*
	from Q92t a left join p b
	on a.RECODE_Q9_2=b.RECODE_Q9_2;
quit;
proc print;
	var RECODE_Q9_2 _0 _1 ProbChiSq;
run;








*********************Combine;
  proc format ;
value $ q9_
	A='Use a dedicated discharge planner or discharge coordinator'
	B='Create a discharge summary prior to discharge and share this with the patient outpatient provider'
	C='Communicate discharge plan verbally to primary care physician or next care provider at discharge'
	D='Use electronic tools to share discharge summaries or other care plans with outpatient providers'
	E='Schedule follow-up appointments for all patients prior to discharge'
	F='Use pharmacists to reconcile discharge medications with prior outpatient medications'
	G='Use electronic tools to reconcile discharge medications with prior outpatient medications'
	H='Use a formal discharge checklist to document when all components of discharge protocol are complete'
	I='Contact patients by phone within 48 hours after discharge to monitor their progress'
	J='Use a transition coach to help patients manage medications and other self-care issues'
	K='Enroll patients in a 30-day post-discharge care coordination or disease management program'
	L='Enroll patients in a post-discharge patient activation and engagement program'
	M='Use mobile or web-based applications to support patients and families in carrying out post-discharge care plans'
	N='Other'
	S='Medication reconciliation (may be inclusive of F/G)'
	T='Transition in care/Care coordination' 
	U='Combinations/Multiple options'
	V='Follow-up appointment within # days (less about when scheduled and more about when it occurs)'
	W='Discharge summary communicated (may  be inclusive of B/C/D)'
	X='Patient compliance issues including references to ensuring that patient’s follow-up appointments with primary care physician are kept' 
;
run;

%macro bin(var=); 

data temp;
	set data.survey_analytic;
	where RECODE_Q9_2 in ('A','B','C','D','E','F','G','H','I','J','K','L','M','N') and RECODE_Q9_1 in ('A','B','C','D','E','F','G','H','I','J','K','L','M','N');
	if RECODE_Q9_1 not in ('J','A','I','K','E','N')  then RECODE_Q9_1='O';
	if RECODE_Q9_2 not in ('J','A','I','K','E','N')  then RECODE_Q9_2='O'; 
	if RECODE_Q9_1="&var." or RECODE_Q9_2="&var." then y=1;else y=0;
	proc sort;
	by descending &group.  descending y;
run;

proc means data=temp;
	weight wt;
	var y;
	output out=all&var. mean=percent;
run;
data all&var.;
	set all&var.;
	RECODE_Q9="&var.";
	keep RECODE_Q9 percent;
run;

proc means data=temp;
	weight wt;
	class &group. ;
	var y;
	output out=bygroup&var. mean=percent;
run;
data bygroup&var.;
	set bygroup&var.;
	keep &group.  percent;
run;

proc transpose data=bygroup&var. out=bygroup&var.t;
	var percent;
	id &group. ;
run;
data bygroup&var.t;
	length RECODE_Q9 $8.;
	set bygroup&var.t;
	drop _name_;
	RECODE_Q9="&var.";
run;

proc genmod data=temp order=data;
	class &group.  y;
	weight wt;
	model y=&group.  / dist = bin link = logit  ; 
	contrast "Group1 vs Group2" &group.  1 -1;
	ods output    contrasts=p&var.;
run;

data p&var.;
	set p&var.;
	RECODE_Q9="&var.";
	keep ProbChiSq RECODE_Q9;
run;

data &var.;
    length RECODE_Q9 $8.;
	merge all&var. bygroup&var.t p&var.;
run;

%mend bin;
%bin(var=A);
%bin(var=B);
%bin(var=C);
%bin(var=D);
%bin(var=E);
%bin(var=F);
%bin(var=G);
%bin(var=H);
%bin(var=I);
%bin(var=J);
%bin(var=K);
%bin(var=L);
%bin(var=M);
%bin(var=N);
%bin(var=O);
data Q9;
set a b c d e f g h i j k l m n o;
proc sort;by descending percent;
run;
proc print;format RECODE_Q9 $Q9_.;
run;

 




















**************************************Q17.1;
proc format ;
value $ q17_
'12A'='Obtaining sufficient staffing to implement programs to reduce readmissions'
'12B'='Ensuring adequacy of discharge processes'
'12C'='Ensuring adequacy of handoffs of care when patients transition from the inpatient to the outpatient setting'
'12D'='Obtaining evidence on  what works  to reduce readmissions'
'12E'='Obtaining buy-in from inpatient clinicians'
'12F'='Obtaining buy-in from outpatient clinicians'
'12G'='Obtaining buy-in from emergency department clinicians'
'12H'='Obtaining sufficient prioritization from hospital leadership'
'13A'='Availability of financial resources to implement new programs'
'13B'='Reducing readmissions may negatively impact hospital finances'
'14A'='Availability of primary care in the community'
'14B'='Availability of mental health and substance abuse services in the community'
'14C'='Availability of nursing home or rehabilitation care in the community'
'14D'='Availability of home health and visiting nurse services in the community'
'15A'='Homelessness'
'15B'='Language Barriers'
'15C'='Lack of transportation (to or from clinical appointments)'
'15D'='Mental health or substance abuse issues'
'A'='Patient noncompliance'
'B'='Limited resources for hospital'
'C'='Limited resources for patient'
'D'='Education'
'E'='Health literacy '
'F'='Family support'
'G'='PCP availability and contact information'
'H'='Contact info of patients'
'I'=' Transportation'
'J'='Lack of consistent EHR '
'K'='Med reconciliation (affordability, what to do with them, etc.) '
'L'='Misalignment of physicians and hospital payment incentives (or ED v hospitalists) '
'M'='Medical complexity'
'N'='Community health literacy programs'
'O'='Undocumented status, low resource availability'
'P'='Super utilizers/frequent flyers'
'R'='other';
run;
  

*** Overall freq;
proc freq data=data.survey_analytic;
	where q16=1 and RECODE_Q17_1 in ('12A','12B','12C','12D','12E','12F','12G','12H','13A','13B','14A','14B','14C','14D','15A','15B','15C','15D',
'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','R');
	format RECODE_Q17_1 $q17_.;
	weight wt;
	tables RECODE_Q17_1 / out=Q171all outpct nopercent nocum norow   ;
run;
data Q171all;
	set Q171all;	
	percent_all=percent/100;
	keep RECODE_Q17_1 percent_all;
proc sort;by descending percent_all;
proc print;
run;

*** Take >5% choices;
data temp;
	set data.survey_analytic ;
	where q16=1 and RECODE_Q17_1 in ('12A','12B','12C','12D','12E','12F','12G','12H','13A','13B','14A','14B','14C','14D','15A','15B','15C','15D',
'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','R');
	if RECODE_Q17_1 not in ('A','C','K','E','F','R') then RECODE_Q17_1='Z';
run;


proc freq data=temp;
	format RECODE_Q17_1 $Q17_.;
	weight wt;
	tables RECODE_Q17_1*&group. /out=Q171 outpct nopercent nocum norow  ;
run;

proc transpose data=Q171 out=Q171t;
	var PCT_COL;
	by RECODE_Q17_1;
	id &group. ;
run;

data q171t;
	set q171t;
	drop _label_ _name_;
	_0=_0/100;_1=_1/100;
run;
 
%macro cmp(var=);

data temp;
	set temp;
	if RECODE_Q17_1="&var." then y=1;else y=0;
	proc sort;by descending &group.  descending y;
run;

proc genmod data=temp order=data;
	class &group.  y;
	weight wt;
	model y=&group.  / dist = bin link = logit  ; 
	contrast "Group1 vs Group2" &group.  1 -1;
	ods output    contrasts=p&var.;
run;


data p&var.;
	set p&var.;
	RECODE_Q17_1="&var.";
	keep ProbChiSq RECODE_Q17_1;
run;

%mend cmp;
%cmp(var=A);
%cmp(var=C);
%cmp(var=K);
%cmp(var=E);
%cmp(var=F);
%cmp(var=R); 
%cmp(var=Z); 
data p;
	set pA pC pK pE pF pR pZ;
run;

proc sql;
	create table table2 as
	select a.*,b.*
	from Q171t a left join p b
	on a.RECODE_Q17_1=b.RECODE_Q17_1;
quit;
proc print;
	var RECODE_Q17_1 _0 _1 ProbChiSq;
run;















**************************************Q17.2;
proc format ;
value $ q17_
'12A'='Obtaining sufficient staffing to implement programs to reduce readmissions'
'12B'='Ensuring adequacy of discharge processes'
'12C'='Ensuring adequacy of handoffs of care when patients transition from the inpatient to the outpatient setting'
'12D'='Obtaining evidence on  what works  to reduce readmissions'
'12E'='Obtaining buy-in from inpatient clinicians'
'12F'='Obtaining buy-in from outpatient clinicians'
'12G'='Obtaining buy-in from emergency department clinicians'
'12H'='Obtaining sufficient prioritization from hospital leadership'
'13A'='Availability of financial resources to implement new programs'
'13B'='Reducing readmissions may negatively impact hospital finances'
'14A'='Availability of primary care in the community'
'14B'='Availability of mental health and substance abuse services in the community'
'14C'='Availability of nursing home or rehabilitation care in the community'
'14D'='Availability of home health and visiting nurse services in the community'
'15A'='Homelessness'
'15B'='Language Barriers'
'15C'='Lack of transportation (to or from clinical appointments)'
'15D'='Mental health or substance abuse issues'
'A'='Patient noncompliance'
'B'='Limited resources for hospital'
'C'='Limited resources for patient'
'D'='Education'
'E'='Health literacy '
'F'='Family support'
'G'='PCP availability and contact information'
'H'='Contact info of patients'
'I'=' Transportation'
'J'='Lack of consistent EHR '
'K'='Med reconciliation (affordability, what to do with them, etc.) '
'L'='Misalignment of physicians and hospital payment incentives (or ED v hospitalists) '
'M'='Medical complexity'
'N'='Community health literacy programs'
'O'='Undocumented status, low resource availability'
'P'='Super utilizers/frequent flyers'
'R'='other';
run;
  

*** Overall freq;
proc freq data=data.survey_analytic;
	where q16=1 and RECODE_Q17_2 in ('12A','12B','12C','12D','12E','12F','12G','12H','13A','13B','14A','14B','14C','14D','15A','15B','15C','15D',
'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','R');
	format RECODE_Q17_2 $q17_.;
	weight wt;
	tables RECODE_Q17_2 / out=Q172all outpct nopercent nocum norow   ;
run;
data Q172all;
	set Q172all;	
	percent_all=percent/100;
	keep RECODE_Q17_2 percent_all;
proc sort;by descending percent_all;
proc print;
run;

*** Take >5% choices;
data temp;
	set data.survey_analytic ;
	where q16=1 and RECODE_Q17_2 in ('12A','12B','12C','12D','12E','12F','12G','12H','13A','13B','14A','14B','14C','14D','15A','15B','15C','15D',
'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','R');
	if RECODE_Q17_2 not in ('C','A','F','E','K','R') then RECODE_Q17_2='Z';
run;


proc freq data=temp;
	format RECODE_Q17_2 $Q17_.;
	weight wt;
	tables RECODE_Q17_2*&group. /out=Q172 outpct nopercent nocum norow  ;
run;

proc transpose data=Q172 out=Q172t;
	var PCT_COL;
	by RECODE_Q17_2;
	id &group.;
run;

data q172t;
	set q172t;
	drop _label_ _name_;
	_0=_0/100;_1=_1/100;
run;
 
%macro cmp(var=);

data temp;
	set temp;
	if RECODE_Q17_2="&var." then y=1;else y=0;
	proc sort;by descending &group. descending y;
run;

proc genmod data=temp order=data;
	class &group. y;
	weight wt;
	model y=&group./ dist = bin link = logit  ; 
	contrast "MSH vs non-MSH" &group. 1 -1;
	ods output    contrasts=p&var.;
run;


data p&var.;
	set p&var.;
	RECODE_Q17_2="&var.";
	keep ProbChiSq RECODE_Q17_2;
run;

%mend cmp;
%cmp(var=C);
%cmp(var=A);
%cmp(var=F);
%cmp(var=E);
%cmp(var=K);
%cmp(var=R);  
%cmp(var=Z); 

data p;
	set pC pA pF pE pK pR pZ;
run;

proc sql;
	create table table2 as
	select a.*,b.*
	from Q172t a left join p b
	on a.RECODE_Q17_2=b.RECODE_Q17_2;
quit;
proc print;
	var RECODE_Q17_2 _0 _1 ProbChiSq;
run;



















*********************Combine;
proc format ;
value $ q17_
'12A'='Obtaining sufficient staffing to implement programs to reduce readmissions'
'12B'='Ensuring adequacy of discharge processes'
'12C'='Ensuring adequacy of handoffs of care when patients transition from the inpatient to the outpatient setting'
'12D'='Obtaining evidence on  what works  to reduce readmissions'
'12E'='Obtaining buy-in from inpatient clinicians'
'12F'='Obtaining buy-in from outpatient clinicians'
'12G'='Obtaining buy-in from emergency department clinicians'
'12H'='Obtaining sufficient prioritization from hospital leadership'
'13A'='Availability of financial resources to implement new programs'
'13B'='Reducing readmissions may negatively impact hospital finances'
'14A'='Availability of primary care in the community'
'14B'='Availability of mental health and substance abuse services in the community'
'14C'='Availability of nursing home or rehabilitation care in the community'
'14D'='Availability of home health and visiting nurse services in the community'
'15A'='Homelessness'
'15B'='Language Barriers'
'15C'='Lack of transportation (to or from clinical appointments)'
'15D'='Mental health or substance abuse issues'
'A'='Patient noncompliance'
'B'='Limited resources for hospital'
'C'='Limited resources for patient'
'D'='Education'
'E'='Health literacy '
'F'='Family support'
'G'='PCP availability and contact information'
'H'='Contact info of patients'
'I'=' Transportation'
'J'='Lack of consistent EHR '
'K'='Med reconciliation (affordability, what to do with them, etc.) '
'L'='Misalignment of physicians and hospital payment incentives (or ED v hospitalists) '
'M'='Medical complexity'
'N'='Community health literacy programs'
'O'='Undocumented status, low resource availability'
'P'='Super utilizers/frequent flyers'
'R'='other';
run;

%macro bin(var=);

data temp;
	set data.survey_analytic; 
	where q16=1 and RECODE_Q17_2 in ('12A','12B','12C','12D','12E','12F','12G','12H','13A','13B','14A','14B','14C','14D','15A','15B','15C','15D',
'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','R');
	if RECODE_Q17_1 not in ('C','A','F','E','K','R') then RECODE_Q17_1='Z';**if combine;
	if RECODE_Q17_2 not in ('C','A','F','E','K','R') then RECODE_Q17_2='Z'; **if combine;
	if RECODE_Q17_1="&var." or RECODE_Q17_2="&var." then y=1;else y=0;
	proc sort;
	by descending &group. descending y;
run;

proc means data=temp;
	weight wt;
	var y;
	output out=all&var. mean=percent;
run;
data all&var.;
	set all&var.;
	RECODE_Q17="&var.";
	keep RECODE_Q17 percent;
run;

proc means data=temp;
	weight wt;
	class &group.;
	var y;
	output out=bygroup&var. mean=percent;
run;
data bygroup&var.;
	set bygroup&var.;
	keep &group. percent;
run;

proc transpose data=bygroup&var. out=bygroup&var.t;
	var percent;
	id &group.;
run;
data bygroup&var.t;
	length RECODE_Q17 $8.;
	set bygroup&var.t;
	drop _name_;
	RECODE_Q17="&var.";
run;

proc genmod data=temp order=data;
	class &group. y;
	weight wt;
	model y=&group. / dist = bin link = logit  ; 
	contrast "MSH vs non-MSH" &group. 1 -1;
	ods output    contrasts=p&var.;
run;

data p&var.;
	set p&var.;
	RECODE_Q17="&var.";
	keep ProbChiSq RECODE_Q17;
run;

data q&var.;
    length RECODE_Q17 $8.;
	merge all&var. bygroup&var.t p&var.;
run;

%mend bin;
%bin(var=12A);
%bin(var=12B);
%bin(var=12C);
%bin(var=12D);
%bin(var=12E);
%bin(var=12F);
%bin(var=12G);
%bin(var=12H);
%bin(var=13A);
%bin(var=13B);
%bin(var=14A);
%bin(var=14B);
%bin(var=14C);
%bin(var=14D);
%bin(var=15A);
%bin(var=15B);
%bin(var=15C);
%bin(var=15D);
%bin(var=A);
%bin(var=B);
%bin(var=C);
%bin(var=D);
%bin(var=E);
%bin(var=F);
%bin(var=G);
%bin(var=H);
%bin(var=I);
%bin(var=J);
%bin(var=K);
%bin(var=L);
%bin(var=M);
%bin(var=N);
%bin(var=O);
%bin(var=P);
%bin(var=R);
 
data Q17;
set q12A q12B q12C q12D q12E q12F q12G q12H q13A q13B q14A q14B q14C q14D q15A q15B q15C q15D 
qA qB qC qD qE qF qG qH qI qJ qK qL qM qN qO qP qR  ;
proc sort;by descending percent;
run;
proc print;format RECODE_Q17 $Q17_.;
run;

**if combine;
%bin(var=C);
%bin(var=A);
%bin(var=F);
%bin(var=E);
%bin(var=K);
%bin(var=R);
 %bin(var=Z);
data Q17;
set qA qC qE qF  qK qR qZ;
 
proc print;format RECODE_Q17 $Q17_.;
run;
