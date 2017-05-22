********************************************
Risk-adjusted Mortality 
Xiner Zhou
2015/10/07
*******************************************;
libname ip 'C:\data\Data\Medicare\Inpatient';
libname medpar 'C:\data\Data\Medicare\HCUP_Elixhauser\data';
libname denom 'C:\data\Data\Medicare\Denominator';
libname hartford 'C:\data\Projects\Hartford\Data';
libname HCC 'C:\data\Data\Medicare\HCC\Clean\Data';
 

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

%macro mort(yr=,day=);

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

  
  if CON_ENR=1 and agecat ne 1 and BENE_STATE ne 'xx' and hmo_mo=0 and esrd_ind ne 'Y';
  
  if bene_id ne '';
  keep BENE_ID SEXcat RACEcat age agecat; 
 
run;  

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

i=substr(provider,3,4)*1; 
	if i>=1 and i<=879 then type='Acute Care Hospitals';
	if i>=1300 and i<=1399 then type='Critical Access Hospitals'; 
    drop i; 
if type in ('Acute Care Hospitals','Critical Access Hospitals');
 
keep bene_id  clm_id  ADMSN_DT death_dt DSCHRGDT PRNCPAL_DGNS_CD  provider  type ;
run;
 
proc sql;
	create table temp&yr._1 as
	select a.*,b.*
	from temp&yr._0 a inner join bene&yr. b
on a.bene_id=b.bene_id;
quit;

*Match CCS;
proc import datafile="C:\data\Projects\Hartford\Data\CCSICD9" dbms=xlsx out=CCSICD9 replace;getnames=yes;run;
data ccsICD9;
set ccsICD9;
icd9_1=scan(icd9,1,"'");
ccs_1=scan(ccs,1,"'");
description_1=scan(description,1,"'");
drop icd9 ccs description;
rename icd9_1=dx ccs_1=dxccs description_1=dxnote;
run;
*Link dx;
proc sql;
create table temp&yr._2 as
select a.*,b.dxccs
from temp&yr._1 a left join ccsICD9 b
on a.PRNCPAL_DGNS_CD=b.dx;
quit;


data Mort&yr.;
set temp&yr._2;

	if 0<=death_DT - ADMSN_DT<=&day. then death=1; else death=0;

	*exclude december;
	if month(ADMSN_DT) ne 12;
run;

* Construct Risk Factors;
data HCC&yr.;
set hcc.Hcc_iponly_100pct_&yr.;
keep bene_id hcc1--hcc177;
run;

proc sql;
create table Risk&yr. as
select a.*,b.*
from Mort&yr. a left join HCC&yr. b
on a.bene_id=b.bene_id;
quit;

*Risk-Adjustment Model;
proc genmod data=Risk&yr. descending;
Title "Hierarchical Logistic Regression: Predicted Probability of &day. -day Readmission,Adjusting for HCC,CCS,Age,Race,Sex";
	class death racecat sexcat provider hcc1--hcc177 dxCCS;
	model death=age racecat sexcat hcc1--hcc177 dxCCS/dist=bin link=logit type3;
	output out=predMort&day.&yr. pred=pMort&day.&yr.;	
run;


 
*Predicted/Obs * Overall;
proc means data=predMort&day.&yr. noprint;
var death;
output out=overallMort&day.&yr. mean=overallMort&day.&yr.;
run;
data _null_;set overallMort&day.&yr.;call symput("overallMort&day.&yr.",overallMort&day.&yr.);run;

proc sort data=pMort&day.&yr.;by provider;run;
proc sql;
create table Mort&day.&yr. as
select *,mean(death) as RawMort&day.&yr., sum(death) as obs&day.&yr.,sum(pMort&day.&yr.) as pred&day.&yr., count(clm_id) as N_Admission&day.&yr.
from pMort&day.&yr.
group by provider;
quit;
proc sort data=Mort&day.&yr.  nodupkey;by provider;run;

data hartford.Mort&day.&yr. ;
set Mort&day.&yr. ;
overallMort&day.&yr.=symget("overallMort&day.&yr.")*1;
AdjMort&day.&yr.=(obs&day.&yr./pred&day.&yr. )*overallMort&day.&yr.;
    
    label RawMort&day.&yr.="&yr. hospital-wide Unadjusted all-cause &day. day Motality";
	label overallMort&day.&yr.="National Overall &day.-day Motality Rate";
	label N_Admission&day.&yr.="Number of Index Admissions for this hospital";
	label obs&day.&yr.="Number of Observed &day.-day Motality for this hospital";
	label pred&day.&yr.="Number of Predicted &day.-day Motality for this hostpial ";
	label AdjMort&day.&yr.="&yr. hospital-wide risk-adjusted all-cause &day. day Motality";

keep provider RawMort&day.&yr. overallMort&day.&yr. N_Admission&day.&yr. obs&day.&yr. pred&day.&yr. AdjMort&day.&yr.;
proc sort;by provider;
proc means min median max mean std;
title "&yr. hospital-wide risk-adjusted all-cause &day. day Mortality Rate";
var AdjMort&day.&yr.;
run;

%mend mort;
%mort(yr=2013,day=30);
%mort(yr=2012,day=30);
%mort(yr=2011,day=30);
%mort(yr=2010,day=30);
%mort(yr=2009,day=30);
%mort(yr=2008,day=30);

  
