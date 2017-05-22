************************************************
Risk-adjusted Readmission
Xiner Zhou
10/6/2015
************************************************;
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
 
%macro HospWide(yr=,day=);

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
	ICD_PRCDR_CD1=PRCDRCD1;
	ICD_PRCDR_CD2=PRCDRCD2;
	ICD_PRCDR_CD3=PRCDRCD3;
	ICD_PRCDR_CD4=PRCDRCD4;
	ICD_PRCDR_CD5=PRCDRCD5;
	ICD_PRCDR_CD6=PRCDRCD6;
    ICD_PRCDR_CD7='';ICD_PRCDR_CD8='';ICD_PRCDR_CD9='';ICD_PRCDR_CD10='';ICD_PRCDR_CD11='';ICD_PRCDR_CD12='';ICD_PRCDR_CD13='';
	ICD_PRCDR_CD14='';ICD_PRCDR_CD15='';ICD_PRCDR_CD16='';ICD_PRCDR_CD17='';ICD_PRCDR_CD18='';ICD_PRCDR_CD19='';ICD_PRCDR_CD20='';
	ICD_PRCDR_CD21='';ICD_PRCDR_CD22='';ICD_PRCDR_CD23='';ICD_PRCDR_CD24='';ICD_PRCDR_CD25='';
%end;
%if &yr.=2009 %then %do;
	PRNCPAL_DGNS_CD=DGNSCD1;
	ICD_PRCDR_CD1=PRCDRCD1;
	ICD_PRCDR_CD2=PRCDRCD2;
	ICD_PRCDR_CD3=PRCDRCD3;
	ICD_PRCDR_CD4=PRCDRCD4;
	ICD_PRCDR_CD5=PRCDRCD5;
	ICD_PRCDR_CD6=PRCDRCD6;
    ICD_PRCDR_CD7='';ICD_PRCDR_CD8='';ICD_PRCDR_CD9='';ICD_PRCDR_CD10='';ICD_PRCDR_CD11='';ICD_PRCDR_CD12='';ICD_PRCDR_CD13='';
	ICD_PRCDR_CD14='';ICD_PRCDR_CD15='';ICD_PRCDR_CD16='';ICD_PRCDR_CD17='';ICD_PRCDR_CD18='';ICD_PRCDR_CD19='';ICD_PRCDR_CD20='';
	ICD_PRCDR_CD21='';ICD_PRCDR_CD22='';ICD_PRCDR_CD23='';ICD_PRCDR_CD24='';ICD_PRCDR_CD25='';
%end;
%if &yr.=2008 %then %do;
	ADMSN_DT=ADMSNDT; 
    clm_id=MEDPARID;
	provider=PRVDRNUM;
	STUS_CD=DSTNTNCD;
	PRNCPAL_DGNS_CD=DGNSCD1;
	ICD_PRCDR_CD1=PRCDRCD1;
	ICD_PRCDR_CD2=PRCDRCD2;
	ICD_PRCDR_CD3=PRCDRCD3;
	ICD_PRCDR_CD4=PRCDRCD4;
	ICD_PRCDR_CD5=PRCDRCD5;
	ICD_PRCDR_CD6=PRCDRCD6;
    ICD_PRCDR_CD7='';ICD_PRCDR_CD8='';ICD_PRCDR_CD9='';ICD_PRCDR_CD10='';ICD_PRCDR_CD11='';ICD_PRCDR_CD12='';ICD_PRCDR_CD13='';
	ICD_PRCDR_CD14='';ICD_PRCDR_CD15='';ICD_PRCDR_CD16='';ICD_PRCDR_CD17='';ICD_PRCDR_CD18='';ICD_PRCDR_CD19='';ICD_PRCDR_CD20='';
	ICD_PRCDR_CD21='';ICD_PRCDR_CD22='';ICD_PRCDR_CD23='';ICD_PRCDR_CD24='';ICD_PRCDR_CD25='';
%end;
 

i=substr(provider,3,2) ; 
	if i in ('00','01','02','03','04','05','06','07','08') then type='Acute Care Hospitals';*3398;
	if i in ('13') then type='Critical Access Hospitals'; *1235;
     
if i in ('00','01','02','03','04','05','06','07','08','13');
 
*Condition-Specific;
if PRNCPAL_DGNS_CD in ('41000','41001',  '41011',  '41020',  '41021',  '41030', '41031',  '41040',  '41041',  '41050',  '41051',  '41060',  '41061',  '41070',  '41071',  '41080',  '41081',  '41090',  '41091')
then AMI=1;else AMI=0;
if PRNCPAL_DGNS_CD in ('40201', '40211', '40291', '40401', '40403', '40411', '40413', '40491', '40493', '4280', '4281', '42820', '42821', '42822', '42823', '42830', '42831', '42832', '42833', '42840', '42841', '42842', '42843', '4289' )
then  HeartFailure=1;else HeartFailure=0;
if PRNCPAL_DGNS_CD in ('4800', '4801', '4802', '4803', '4808', '4809', '481', '4820', '4821', '4822', '48230', '48231', '48232', '48239', '48240', '48241', '48242', '48249', '48281', '48282', '48284', '48289', '4829', '4830', '4831', '4838', '485', '486', '4870', '48811'  )
then Pneumonia=1;else Pneumonia=0;


keep bene_id  clm_id  ADMSN_DT DSCHRGDT PRNCPAL_DGNS_CD SRC_ADMS  STUS_CD provider  type ICD_PRCDR_CD1-ICD_PRCDR_CD25 AMI HeartFailure Pneumonia;
run;
*Enrolled in Medicare fee-for-service (FFS) ;
*Aged 65 or over; 
*Enrolled in Part A Medicare for the 12 months prior to the date of the index admission;
proc sql;
	create table temp&yr._1 as
	select a.*,b.*
	from temp&yr._0 a inner join bene&yr. b
on a.bene_id=b.bene_id;
quit;

proc sql;drop table temp&yr._0;quit;

***************************************************************************************
Link with CCS
****************************************************************************************;
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
proc import datafile="C:\data\Projects\Hartford\Data\CCSHCPCS" dbms=xlsx out=ccsProc replace;getnames=yes;run;
data ccsProc;
set ccsProc;
Proc=scan(HCPCS,1,"'");
ccs_1=scan(ccs,1,"'");
description_1=scan(description,1,"'");
drop HCPCS ccs description;
rename ccs_1=procCCS description_1=ProcNote;
run;

*Link dx;
proc sql;
create table temp&yr._2 as
select a.*,b.dxccs
from temp&yr._1 a left join ccsICD9 b
on a.PRNCPAL_DGNS_CD=b.dx;
quit;

proc sql;drop table temp&yr._1;quit;

*Link procedure;
%macro procccs(i=,j=);
 
%if &i.=1 %then %do;
proc sql;
	create table temp&yr._2&i. as
	select a.*,b.ProcCCS as ProcCCS&i.
	from temp&yr._2 a left join ccsProc b
	on a.ICD_PRCDR_CD&i.=b.proc;
quit;
proc sql;drop table temp&yr._2;quit;
%end;

%else %if &i. ne 1 %then %do;
proc sql;
	create table temp&yr._2&i. as
	select a.*,b.ProcCCS as ProcCCS&i.
	from temp&yr._2&j. a left join ccsProc b
	on a.ICD_PRCDR_CD&i.=b.proc;
quit;
proc sql;drop table temp&yr._2&j.;quit;
%end;

%mend procccs;
%procccs(i=1);
%procccs(i=2,j=1);
%procccs(i=3,j=2);
%procccs(i=4,j=3);
%procccs(i=5,j=4);
%procccs(i=6,j=5);
%procccs(i=7,j=6);
%procccs(i=8,j=7);
%procccs(i=9,j=8);
%procccs(i=10,j=9);
%procccs(i=11,j=10);
%procccs(i=12,j=11);
%procccs(i=13,j=12);
%procccs(i=14,j=13);
%procccs(i=15,j=14);
%procccs(i=16,j=15);
%procccs(i=17,j=16);
%procccs(i=18,j=17);
%procccs(i=19,j=18);
%procccs(i=20,j=19);
%procccs(i=21,j=20);
%procccs(i=22,j=21);
%procccs(i=23,j=22);
%procccs(i=24,j=23);
%procccs(i=25,j=24);



*********************************************************************************************
Exclusions, define index admission, readmission
********************************************************************************************;
proc sort data=temp&yr._225;by bene_id ADMSN_DT DSCHRGDT;run;

data temp&yr._3;
set temp&yr._225;

by bene_id ADMSN_DT DSCHRGDT;
Ref_date=lag(DSCHRGDT); 

label Ref_date="Reference Date";

Format Ref_Date YYMMDD10.;

Gap=ADMSN_DT-Ref_Date;  

if first.bene_id then do;
	Ref_date=.;
End;

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

*Not Admission for primary psychiatric diagnoses;
if  dxccs in ('650','651','652','654','655','656','657','658','659','662','670') then psychiatric=1; else psychiatric=0;
*Not Admissions for Rehab;
if  dxccs in ('254') then rehab=1; else rehab=0;
*Not Admissions for medical treatment of cancer;
if dxccs in ('11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45')
and ProcCCS1 not in ('1','2','3','9','10','12','13','14','15','16','17','20','21','22','23','24','26','28','30','33','36','42','43','44','49','51','52',
'53','55','56','59','60','66','67','72','73','74','75','78','79','80','84','85','86','89','90','94','96','99','101','103','104','105','106','112','113','114','118','119',
'120','121','123','124','125','126','127','129','131','132','133','134','135','136','137','139','140','141','142','143','144','145','146','147','148','150','151','152',
'153','154','157','158','160','161','162','164','166','167','172','175','176') then cancermedical=1; else  cancermedical=0;

if  SRC_ADMS in ('4') then transferin=1;else transferin=0;
if transferin=0 and 0<=gap<=&day. then Readm=1;else Readm=0;
 
run;

proc sql;drop table temp&yr._225;quit;

proc sort data=temp&yr._3;by bene_id descending ADMSN_DT descending DSCHRGDT;run;

data Readm&yr.;
set temp&yr._3;

by bene_id descending ADMSN_DT descending DSCHRGDT;
leadtoReadm=lag(Readm);

if first.bene_id then do;
	leadtoReadm=0;
end;
*Index Admission Exclusions;
if indeath=0 and transferout=0 and lostfollowup=0 and Against=0 and psychiatric=0 and rehab=0 and cancermedical=0 then Index=1;else Index=0;
if Index=1;
proc sort;
by bene_id  ADMSN_DT  DSCHRGDT;
run;
proc sql;drop table temp&yr._3;quit;

* Construct Risk Factors;
data HCC&yr.;
set hcc.Hcc_iponly_100pct_&yr.(drop=hcc51 hcc52);
keep bene_id hcc1--hcc177;
run;
 

proc sql;
create table Risk&yr. as
select a.*,b.*
from Readm&yr. a left join HCC&yr. b
on a.bene_id=b.bene_id;
quit;

proc sql;drop table Readm&yr.;quit;
proc sql;drop table HCC&yr.;quit;

%macro condition(cond=);

%if &cond.=All %then %do;
*Risk-Adjustment Model;
proc genmod data=Risk&yr.  descending;
Title "Hierarchical Logistic Regression: Predicted Probability of &day. -day Readmission,Adjusting for HCC,CCS,Age,Race,Sex";
	class leadtoReadm racecat sexcat provider hcc1--hcc177 dxCCS;
	model leadtoReadm=age racecat sexcat hcc1--hcc177 dxCCS/dist=bin link=logit type3;
	*repeated subject=provider/type=exch;
	output out=pred&cond.Readm&day.&yr. pred=p&cond.Readm&day.&yr.;	
run;
%end;
%else  %do;
*Risk-Adjustment Model;
proc genmod data=Risk&yr.  descending;
where &cond.=1;
Title "Hierarchical Logistic Regression: Predicted Probability of &day. -day Readmission,Adjusting for HCC,CCS,Age,Race,Sex";
	class leadtoReadm racecat sexcat provider hcc1--hcc177 dxCCS;
	model leadtoReadm=age racecat sexcat hcc1--hcc177 /dist=bin link=logit type3;
	*repeated subject=provider/type=exch;
	output out=pred&cond.Readm&day.&yr. pred=p&cond.Readm&day.&yr.;	
run;
%end;

*Predicted/Obs * Overall;
proc means data=pred&cond.Readm&day.&yr. noprint;
var leadtoReadm;
output out=overall&cond.Readm&day.&yr. mean=overall&cond.Readm&day.&yr.;
run;
data _null_;set overall&cond.Readm&day.&yr.;call symput("overall",overall&cond.Readm&day.&yr.);run;

proc sort data=pred&cond.Readm&day.&yr. ;by provider;run;
proc sql;
create table &cond.Readm&day.&yr. as
select *,mean(leadtoReadm) as Raw&cond.Readm&day.&yr.,sum(leadtoReadm) as obs&cond.&day.&yr.,sum(p&cond.Readm&day.&yr.) as pred&cond.&day.&yr., count(clm_id) as N_Admission&cond.&day.&yr.
from pred&cond.Readm&day.&yr. 
group by provider;
quit;
proc sort data=&cond.Readm&day.&yr.  nodupkey;by provider;run;

data hartford.&cond.Readm&day.&yr. ;
set &cond.Readm&day.&yr. ;
overall&cond.Readm&day.&yr.=symget('overall')*1;
Adj&cond.Readm&day.&yr.=(obs&cond.&day.&yr./pred&cond.&day.&yr. )*overall&cond.Readm&day.&yr.;
    label Raw&cond.Readm&day.&yr.="&yr. &cond. Unadjusted all-cause &day. day Readmission";
	label overall&cond.Readm&day.&yr.="National Overall &cond. &day.-day Readmission Rate";
	label N_Admission&cond.&day.&yr.="Number of Index &cond. Admissions for this hospital";
	label obs&cond.&day.&yr.="Number of Observed &cond. &day.-day Readmission for this hospital";
	label pred&cond.&day.&yr.="Number of Predicted &cond. &day.-day Readmission for this hostpial ";
	label Adj&cond.Readm&day.&yr.="&yr. &cond. risk-adjusted all-cause &day. day Readmission";

keep provider overall&cond.Readm&day.&yr. N_Admission&cond.&day.&yr. obs&cond.&day.&yr. pred&cond&day.&yr. Adj&cond.Readm&day.&yr.;
proc sort;by provider;
run;

%mend condition;
%condition(cond=AMI);
%condition(cond=HeartFailure);
%condition(cond=Pneumonia);
%condition(cond=All);

	
%mend HospWide;

%HospWide(yr=2013,day=30);

*%HospWide(yr=2012,day=30);
   
*%HospWide(yr=2011,day=30);

*%HospWide(yr=2010,day=30);

*%HospWide(yr=2009,day=30);
   
*%HospWide(yr=2008,day=30);

*%HospWide(yr=2013,day=90);
*%HospWide(yr=2012,day=90);
   
*%HospWide(yr=2011,day=90);

*%HospWide(yr=2010,day=90);

*%HospWide(yr=2009,day=90);
   
*%HospWide(yr=2008,day=90);

/*
1. Cohort ICD-9-CM Codes by Measure
AMI Cohort Codes
410.00 AMI (anterolateral wall) – episode of care unspecified
410.01 AMI (anterolateral wall) – initial episode of care
410.10 AMI (other anterior wall) – episode of care unspecified
410.11 AMI (other anterior wall) – initial episode of care
410.20 AMI (inferolateral wall) – episode of care unspecified
410.21 AMI (inferolateral wall) – initial episode of care
410.30 AMI (inferoposterior wall) – episode of care unspecified
410.31 AMI (inferoposterior wall) – initial episode of care
410.40 AMI (other inferior wall) – episode of care unspecified
410.41 AMI (other inferior wall) – initial episode of care
410.50 AMI (other lateral wall) – episode of care unspecified
410.51 AMI (other lateral wall) – initial episode of care
410.60 AMI (true posterior wall) – episode of care unspecified
410.61 AMI (true posterior wall) – initial episode of care
410.70 AMI (subendocardial) – episode of care unspecified
410.71 AMI (subendocardial) – initial episode of care
410.80 AMI (other specified site) – episode of care unspecified
410.81 AMI (other specified site) – initial episode of care
410.90 AMI (unspecified site) – episode of care unspecified
410.91 AMI (unspecified site) – initial episode of care

Heart Failure Cohort Codes
402.01 Malignant hypertensive heart disease with congestive heart failure (CHF)
402.11 Benign hypertensive heart disease with CHF
402.91 Hypertensive heart disease with CHF
404.01 Malignant hypertensive heart and renal disease with CHF
404.03 Malignant hypertensive heart and renal disease with CHF & renal failure (RF)
404.11 Benign hypertensive heart and renal disease with CHF
404.13 Benign hypertensive heart and renal disease with CHF & RF
404.91 Unspecified hypertensive heart and renal disease with CHF
404.93 Hypertension and non-specified heart and renal disease with CHF & RF
428.0 Congestive heart failure, unspecified
428.1 Left heart failure
428.20 Systolic heart failure, unspecified
428.21 Systolic heart failure, acute
428.22 Systolic heart failure, chronic
428.23 Systolic heart failure, acute or chronic
428.30 Diastolic heart failure, unspecified
428.31 Diastolic heart failure, acute
428.32 Diastolic heart failure, chronic
428.33 Diastolic heart failure, acute or chronic
428.40 Combined systolic and diastolic heart failure, unspecified
428.41 Combined systolic and diastolic heart failure, acute
428.42 Combined systolic and diastolic heart failure, chronic
428.43 Combined systolic and diastolic heart failure, acute or chronic
428.9 Heart failure, unspecified

Pneumonia Cohort Codes
480.0 Pneumonia due to adenovirus
480.1 Pneumonia due to respiratory syncytial virus
480.2 Pneumonia due to parainfluenza virus
480.3 Pneumonia due to SARS-associated coronavirus
480.8 Viral pneumonia: pneumonia due to other virus not elsewhere classified
480.9 Viral pneumonia unspecified
481 Pneumococcal pneumonia [streptococcus pneumoniae pneumonia]
482.0 Pneumonia due to klebsiella pneumoniae
482.1 Pneumonia due to pseudomonas
482.2 Pneumonia due to hemophilus influenzae (h. influenzae)
482.30 Pneumonia due to streptococcus unspecified
482.31 Pneumonia due to streptococcus group a
482.32 Pneumonia due to streptococcus group b
482.39 Pneumonia due to other streptococcus
482.40 Pneumonia due to staphylococcus unspecified
482.41 Pneumonia due to staphylococcus aureus
482.42 Methicillin resistant pneumonia due to Staphylococcus aureus
482.49 Other staphylococcus pneumonia
482.81 Pneumonia due to anaerobes
482.82 Pneumonia due to escherichia coli [e.coli]
482.83 Pneumonia due to other gram-negative bacteria
482.84 Pneumonia due to legionnaires' disease
482.89 Pneumonia due to other specified bacteria
482.9 Bacterial pneumonia unspecified
483.0 Pneumonia due to mycoplasma pneumoniae
483.1 Pneumonia due to chlamydia
483.8 Pneumonia due to other specified organism
485 Bronchopneumonia organism unspecified
486 Pneumonia organism unspecified
487.0 Influenza with pneumonia
488.11 Influenza due to identified novel H1N1 influenza virus with pneumonia
*/
 
