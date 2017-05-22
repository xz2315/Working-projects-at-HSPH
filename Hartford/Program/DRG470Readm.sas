************************************************
CMS: Risk-adjusted Readmission
Xiner Zhou
10/10/2015
************************************************;
libname ip 'C:\data\Data\Medicare\Inpatient';
libname medpar 'C:\data\Data\Medicare\HCUP_Elixhauser\data';
libname denom 'C:\data\Data\Medicare\Denominator';
libname hartford 'C:\data\Projects\Hartford\Data';
libname HCC 'C:\data\Data\Medicare\HCC\Clean\Data';
libname backup 'C:\data\Projects\APCD High Cost\My Files';
libname data 'C:\data\Projects\Jha_Requests\Data';
 
proc format;  
value st
1='AL'
2='AK'
3='AZ'
4='AR'
5='CA'
6='CO'
7='CT'
8='DE'
9='DC'
10='FL'
11='GA'
12='HI'
13='ID'
14='IL'
15='IN'
16='IA'
17='KS'
18='KY'
19='LA'
20='ME'
21='MD'
22='MA'
23='MI'
24='MN'
25='MS'
26='MO'
27='MT'
28='NE'
29='NV'
30='NH'
31='NJ'
32='NM'
33='NY'
34='NC'
35='ND'
36='OH'
37='OK'
38='OR'
39='PA'
40='xx'
41='RI'
42='SC'
43='SD'
44='TN'
45='TX'
46='UT'
47='VT'
48='xx'
49='VA'
50='WA'
51='WV'
52='WI'
53='WY'
54='xx'
55='xx'
56='xx'
57='xx'
58='xx'
59='xx'
60='xx'
61='xx'
62='xx'
63='xx'
64='xx'
65='xx'
66='xx'
68='xx'
75='xx'
0 ='xx'
. ='xx'
71='xx'
73='xx'
77='xx'
78='xx'
79='xx'
85='xx'
88='xx'
90='xx'
92='xx'
94='xx'
95='xx'
96='xx'
97='xx'
98='xx'
99='xx'
; 
run; 
 
%macro Readm(yr=,day=);

data bene&yr.; 
	set denom.dnmntr&yr.;   
* ENROLLMENT ;
               * test enrollment for enrollees who died during year ;
	            death_month=month(death_DT);
                if death_dt^=' ' then do ;
                 CON_ENR = (A_MO_CNT >= death_month and B_MO_CNT >= death_month) ;
                end;

               * test enrollment for those who aged in during year ;
                else if age <=65 then do ;
                 aged_in_month = min((12 - month(BENE_DOB)), 1) ;
                 CON_ENR = (A_MO_CNT >= aged_in_month and B_MO_CNT >= aged_in_month) ;
                end;

               * all else ;
                else do ;
                 CON_ENR = (A_MO_CNT = 12 and B_MO_CNT = 12) ;
                end;

      label CON_ENR = "enrolled in A & B for eligible months during &yr." ;
  
  BENE_STATE = put(State_CD*1,st.);
  BENE_SSA_COUNTY =cats(STATE_CD, cnty_cd);

  if age<65 then agecat=1;
  else if 65<=age<70 then agecat=2;
  else if 70<=age<75 then agecat=3;
  else if 75<=age<80 then agecat=4;
  else if age>=80 then agecat=5;
  
  if SEX ne '0';
	sexcat=sex*1;*1=Male 2=Female;

    if race ne '0';
	if race = 1 then racecat=1;*white;
	else if race=2 then racecat=2;*black;
	else if race=5 then racecat=3;*hispanic;
	else racecat=4;*others;

  
  if CON_ENR=1 and agecat ne 1 and BENE_STATE ne 'xx'  and esrd_ind ne 'Y';
  %if   &yr.=2008  %then %do;if hmo_mo='00' ;%end;
  %if &yr.=2009 or &yr.=2010 or &yr.=2011 or &yr.=2012 or &yr.=2013  %then %do;if hmo_mo=0;%end;

  if bene_id ne '';
  keep BENE_ID BENE_STATE BENE_SSA_COUNTY BENE_ZIP SEXcat RACEcat age agecat; 
 
run;  
*Discharged from non-federal acute care hospitals;
data temp&yr._0;
set medpar.elixall&yr.;


%if &yr.=2010 %then %do;
 
	ADMSN_DT=ADMSNDT; 
	provider=PRVDRNUM;
	clm_id=MEDPARID;
	PRNCPAL_DGNS_CD=DGNSCD1;
%end;
%if &yr.=2009 %then %do;
 
	PRNCPAL_DGNS_CD=DGNSCD1;
%end;
%if &yr.=2008 %then %do;
 
	ADMSN_DT=ADMSNDT; 
    clm_id=MEDPARID;
	provider=PRVDRNUM;
	STUS_CD=DSTNTNCD;
	PRNCPAL_DGNS_CD=DGNSCD1;
%end;
 

i=substr(provider,3,2) ; 
	if i in ('00','01','02','03','04','05','06','07','08') then type=0; 
	if i in ('13') then type=1;  
     
if i in ('00','01','02','03','04','05','06','07','08','13');
   

%if &yr.=2008 %then %do;
if SSLSSNF='S' or type=1;
%end;
 
%if &yr.=2010 %then %do;
if SSLSSNF='S' or type=1;
%end;

keep bene_id  clm_id  DRG_CD death_dt ADMSN_DT DSCHRGDT PRNCPAL_DGNS_CD SRC_ADMS  STUS_CD provider  type  
CHF VALVE PULMCIRC PERIVASC PARA NEURO CHRNLUNG DM DMCX HYPOTHY RENLFAIL LIVER ULCER AIDS LYMPH
METS TUMOR ARTH COAG OBESE WGHTLOSS LYTES BLDLOSS ANEMDEF ALCOHOL DRUG PSYCH DEPRESS HTN_C;

proc sort nodupkey;by bene_id ADMSN_DT DSCHRGDT provider ;
run;
 
proc sql;
	create table temp&yr._1 as
	select a.*,b.*
	from temp&yr._0 a inner join bene&yr. b
on a.bene_id=b.bene_id;
quit;

proc sql;drop table temp&yr._0;quit;

*********************************************************************************************
Exclusions, define index admission, readmission
********************************************************************************************;


data temp&yr._2;
set temp&yr._1;

*Without an in-hospital death;
if STUS_CD in ('20') then indeath=1; else indeath=0;

*Not transferred to another acute care facility; 
if STUS_CD in('02','05') then transferout=1; else transferout=0;

* Not Admissions with <30 or <90 days of post-discharge follow-up;

	if month(DSCHRGDT)=12 then lostfollowup=1; else lostfollowup=0;


*Not Admissions discharged against medical advices;
if STUS_CD in ('07') then Against=1;else Against=0;

if  SRC_ADMS in ('4') then transferin=1;else transferin=0;
if indeath=0 and transferout=0 and lostfollowup=0 and Against=0  then Index=1;else Index=0;

if index=1 and DRG_CD='469';
proc sort;by bene_id ADMSN_DT DSCHRGDT;
run;

data index&yr.;
set temp&yr._2;

retain index_date;
format index_date mmddyy10.;
by bene_id ADMSN_DT DSCHRGDT;

if first.bene_id=1 then do;
	index_date=DSCHRGDT;	 
End; 

else  do;
	Gap=ADMSN_DT-index_date;  
	if gap>30 then index_date=DSCHRGDT;
End;

if 0<=gap<=30 then within30=1;else within30=0;

if within30=1;
keep bene_id clm_id within30;
run;

proc sql;
create table temp&yr._3 as
select a.*,b.*
from temp&yr._1 a left join index&yr. b
on a.bene_id=b.bene_id and a.clm_id=b.clm_id;
quit;

proc sort data=temp&yr._3;by bene_id ADMSN_DT DSCHRGDT;run;

data temp&yr._3;
set temp&yr._3;

by bene_id ADMSN_DT DSCHRGDT;
Ref_date=lag(DSCHRGDT); 
 
Format Ref_Date YYMMDD10.;

if first.bene_id then do;
	Ref_date=.;
End;

Gap=ADMSN_DT-Ref_Date;  

*Without an in-hospital death;
if STUS_CD in ('20') then indeath=1; else indeath=0;

*Not transferred to another acute care facility; 
if STUS_CD in('02','05') then transferout=1; else transferout=0;

* Not Admissions with <30 or <90 days of post-discharge follow-up;
if &day.=30 then do;
	if month(DSCHRGDT)=12 then lostfollowup=1; else lostfollowup=0;
end;
else if &day.=90 then do;
	if month(DSCHRGDT) in (10,11,12) then lostfollowup=1; else lostfollowup=0;
end;

*Not Admissions discharged against medical advices;
if STUS_CD in ('07') then Against=1;else Against=0;

if  SRC_ADMS in ('4') then transferin=1;else transferin=0;
if transferin=0 and 0<=gap<=&day. then Readm=1;else Readm=0;
 
run;

proc sort data=temp&yr._3;by bene_id descending ADMSN_DT descending DSCHRGDT;run;

data Readm&yr.;
set temp&yr._3;

by bene_id descending ADMSN_DT descending DSCHRGDT;
leadtoReadm=lag(Readm);

if first.bene_id then do;
	leadtoReadm=0;
end;
*Index Admission Exclusions;
if within30 ne 1 and indeath=0 and transferout=0 and lostfollowup=0 and Against=0  then Index=1;else Index=0;
if Index=1 and DRG_CD='469';
run;
 

*Risk-Adjustment Model;
proc genmod data=Readm&yr. descending;
Title "Logistic Regression: Predicted Probability of &day. -day Readmission,Adjusting for HCC,Age,Race,Sex";
	class leadtoReadm agecat racecat sexcat provider 
         CHF VALVE PULMCIRC PERIVASC PARA NEURO CHRNLUNG DM DMCX HYPOTHY RENLFAIL LIVER ULCER AIDS LYMPH
METS TUMOR ARTH COAG OBESE WGHTLOSS LYTES BLDLOSS ANEMDEF ALCOHOL DRUG PSYCH DEPRESS HTN_C;
	model leadtoReadm=agecat  racecat sexcat 
                     CHF VALVE PULMCIRC PERIVASC PARA NEURO CHRNLUNG DM DMCX HYPOTHY RENLFAIL LIVER ULCER AIDS LYMPH
METS TUMOR ARTH COAG OBESE WGHTLOSS LYTES BLDLOSS ANEMDEF ALCOHOL DRUG PSYCH DEPRESS HTN_C/dist=bin link=logit type3;
	*repeated subject=provider/type=exch;
	output out=expReadm&day.&yr. pred=expReadm&day.&yr.;	
run;


*Predicted/Obs * Overall;
proc means data=expReadm&day.&yr. noprint;
var leadtoReadm;
output out=overallReadm&day.&yr. mean=overallReadm&day.&yr.;
run;
data _null_;set overallReadm&day.&yr.;call symput("overall",overallReadm&day.&yr.);run;

proc sort data=expReadm&day.&yr. ;by provider;run;
proc sql;
create table Readm&day.&yr. as
select *,mean(leadtoReadm) as RawReadm&day.&yr.,sum(leadtoReadm) as obs&day.&yr.,sum(expReadm&day.&yr.) as exp&day.&yr., count(clm_id) as N&day.&yr.
from expReadm&day.&yr. 
group by provider;
quit;
proc sort data=Readm&day.&yr.  nodupkey;by provider;run;

data data.ReadmDRG469&day.&yr.;
set Readm&day.&yr. ;
overallReadm&day.&yr.=symget('overall')*1;
AdjReadm&day.&yr.=(obs&day.&yr./exp&day.&yr. )*overallReadm&day.&yr.;
    label RawReadm&day.&yr.="&yr. Unadjusted All-Cause &day.-day Readmission Rate";
	label overallReadm&day.&yr.="National Overall &day.-day Readmission Rate";
	label N&day.&yr.="N. of Index Admissions";
	label obs&day.&yr.="N. of Observed &day.-day Readmission";
	label exp&day.&yr.="N. of Expected &day.-day Readmission";
	label AdjReadm&day.&yr.="&yr. Risk-Adjusted All-Cause &day.-day Readmission";

keep provider overallReadm&day.&yr. N&day.&yr. obs&day.&yr. exp&day.&yr. AdjReadm&day.&yr. RawReadm&day.&yr.;
proc sort;by provider;
run;

%mend Readm;


%Readm(yr=2013,day=30);
%Readm(yr=2012,day=30);
%Readm(yr=2011,day=30);
%Readm(yr=2010,day=30);
%Readm(yr=2009,day=30);
%Readm(yr=2008,day=30);
 

***************************************************************
Check Trends and Risk-adjustment with Raw
**************************************************************;
%macro trend(cond=,label=);

%do i=2008 %to 2013;
	data &cond.readm30&i.;
		set Hartford.&cond.readm30&i. ;
		if _n_=1;
		year=&i.;
		day=30;
		overall&cond.readm=overall&cond.readm30&i.;
keep year day overall&cond.readm ;
run;
%end;

data &cond.readm30;
set &cond.readm302008 &cond.readm302009 &cond.readm302010 &cond.readm302011 &cond.readm302012 &cond.readm302013;
run;

%do i=2008 %to 2013;
	data &cond.readm90&i.;
		set Hartford.&cond.readm90&i. ;
		if _n_=1;
		year=&i.;
		day=90;
		overall&cond.readm=overall&cond.readm90&i.;
keep year day overall&cond.readm ;
run;
%end;

data &cond.readm90;
set &cond.readm902008 &cond.readm902009 &cond.readm902010 &cond.readm902011 &cond.readm902012 &cond.readm902013;
run;

data &cond.readm;
set &cond.readm30 &cond.readm90;
run;

proc sgplot data=&cond.readm;
title "National &label. Readmission Rate 2008 to 2013";format overall&cond.readm percent7.4 ;
series x=year y=overall&cond.readm /group=day markerattrs=(color=black symbol=STARFILLED) datalabel=overall&cond.readm;
yaxis label='Percent' values=(0.1000 to 0.4500 by 0.0100);
run;
%mend trend;
%trend(cond=AMI,label=Acute Myocardial Infarction);
%trend(cond=chf,label=Congestive Heart Failure);
%trend(cond=pn,label=Pneumonia);
%trend(cond=copd,label=Chronic obstructive pulmonary disease );
%trend(cond=stroke,label=Stroke );
%trend(cond=sepsis,label=Sepsis );
%trend(cond=esggas,label=Esophageal/Gastric Disease );
%trend(cond=gib,label=GI Bleeding );
%trend(cond=uti,label=Urinary Tract Infection); 
%trend(cond=metdis,label=Metabolic Disorder);
%trend(cond=arrhy,label=Arrhythmia);
%trend(cond=chest,label=Chest Pain);
%trend(cond=renalf,label=Renal Failure);
%trend(cond=resp,label=Respiratory Disease);
%trend(cond=hipfx,label=Hip Fracture);
  
