********************************************
Laura's Abstract for SAEM
Xiner Zhou
11/10/2015
********************************************;

* Idea: ED admission rate and outcomes - Question: Do EDs with higher admission rates have lower mortality? ;

*reference: http://www.resdac.org/resconnect/articles/144  
*ICd 9 : https://www.cms.gov/Medicare/Quality-Initiatives-Patient-Assessment-Instruments/HospitalQualityInits/Measure-Methodology.html  ;

/*revenue center code: 
0450 = Emergency room-general classification
0451 = Emergency room-emtala emergency medical screening services (eff 10/96)
0452 = Emergency room-ER beyond emtala screening (eff 10/96)
0456 = Emergency room-urgent care (eff 10/96)
0459 = Emergency room-other
0981 = Professional fees-emergency room

0762 = observation room (eff 9/93)
*/
libname op 'C:\data\Data\Medicare\Outpatient';
libname ip 'C:\data\Data\Medicare\Inpatient';
libname elix 'C:\data\Data\Medicare\HCUP_Elixhauser\Data';
libname denom 'C:\data\Data\Medicare\Denominator';
 

***********************************Step1: Identify ED visits in Outpatient Claims;

data opED(keep=bene_id clm_id clm_ln ed HCPCS_CD REV_UNIT rename=(clm_ln = EDclm_ln)) opObs(keep=bene_id clm_id clm_ln obs HCPCS_CD REV_UNIT rename=(clm_ln = Obsclm_ln)) ;
set op.Otptrev2013;
ed=0;obs=0; 
if REV_CNTR in ('0450','0451','0452','0456','0459','0981') then do;ED=1;output opED;end;
if REV_CNTR in ('0762' ) then do;obs=1;output opObs;end;
run;


proc sort data=opED ;by clm_id EDclm_ln;run;
proc sort data=opED nodupkey;by clm_id;run;
proc sort data=opObs  ;by clm_id descending Obsclm_ln;run;
proc sort data=opObs nodupkey ;by clm_id;run;
proc sql;
create table temp1 as
select a.bene_id,a.clm_id,a.STUS_CD,a.FROM_DT as ADMSN_DT,a.THRU_DT as DSCHRGDT,a.PROVIDER,a.PRNCPAL_DGNS_CD,
a.ICD_DGNS_CD1,a.ICD_DGNS_CD2,a.ICD_DGNS_CD3,a.ICD_DGNS_CD4,a.ICD_DGNS_CD5,a.ICD_DGNS_CD6,a.ICD_DGNS_CD7,a.ICD_DGNS_CD8,a.ICD_DGNS_CD9,a.ICD_DGNS_CD10,
a.ICD_DGNS_CD11,a.ICD_DGNS_CD12,a.ICD_DGNS_CD13,a.ICD_DGNS_CD14,a.ICD_DGNS_CD15,a.ICD_DGNS_CD16,a.ICD_DGNS_CD17,a.ICD_DGNS_CD18,a.ICD_DGNS_CD19,a.ICD_DGNS_CD20,
a.ICD_DGNS_CD21,a.ICD_DGNS_CD22,a.ICD_DGNS_CD23,a.ICD_DGNS_CD24,a.ICD_DGNS_CD25, b.*
from op.Otptclms2013 a inner join opED b
on a.bene_id=b.bene_id and a.clm_id=b.clm_id;
quit;
proc sql;
create table temp2 as
select a.*,b.*
from temp1 a left join opObs b
on a.bene_id=b.bene_id and a.clm_id=b.clm_id;
quit;
 
data op2013;
set temp2;

i=substr(provider,3,2) ; 
	if i in ('00','01','02','03','04','05','06','07','08') then type='Acute Care Hospitals'; 
	 
     
if i in ('00','01','02','03','04','05','06','07','08');


if PRNCPAL_DGNS_CD in ('40201', '40211', '40291', '40401', '40403', '40411', '40413', '40491', '40493', '4280', '4281', '42820', '42821', '42822', '42823', '42830', '42831', '42832', '42833', '42840', '42841', '42842', '42843', '4289' )
then  chf=1; else chf=0; 
 
if PRNCPAL_DGNS_CD in ('4800', '4801', '4802', '4803', '4808', '4809', 
						'481', '4820', '4821', 
						'4822', '48230', '48231', '48232', '48239', '48240', '48241', '48242', '48249', '48281','48282','48283',  '48284', '48289', '4829', 
						'4830', '4831', '4838', '485', '486', '4870', '48811'  )
then pn=1; else pn=0; 
   
 
if PRNCPAL_DGNS_CD in (	"49121","49122","4918", "4919",  "4928", "49320","49321","49322",  "496") or 
PRNCPAL_DGNS_CD in ('51881','51882','51884','51884') and (
ICD_DGNS_CD1 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD2 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD3 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD4 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD5 in ('49121', '49122', '49321','49322')
or ICD_DGNS_CD6 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD7 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD8 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD9 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD10 in ('49121', '49122', '49321','49322')
or ICD_DGNS_CD11 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD12 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD13 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD14 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD15 in ('49121', '49122', '49321','49322')
or ICD_DGNS_CD16 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD17 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD18 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD19 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD20 in ('49121', '49122', '49321','49322')
or ICD_DGNS_CD21 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD22 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD23 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD24 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD25 in ('49121', '49122', '49321','49322'))
then copd=1;else copd=0;

if chf=1 or pn=1 or copd=1;

drop i ICD_DGNS_CD1-ICD_DGNS_CD25;
run;
 
 


***********************************Step2: Identify ED visits in Inpatient Claims (Be careful about Admission Source);
data ipED(keep=bene_id clm_id clm_ln ed rename=(clm_ln = EDclm_ln)) ipObs(keep=bene_id clm_id clm_ln obs rename=(clm_ln = Obsclm_ln)) ;
set ip.Inptrev2013;
ed=0;obs=0; 
if REV_CNTR in ('0450','0451','0452','0456','0459','0981') then do;ED=1;output ipED;end;
if REV_CNTR in ('0762' ) then do;obs=1;output ipObs;end;
run;
 
proc sort data=ipED ;by clm_id EDclm_ln;run;
proc sort data=ipED nodupkey;by clm_id;run;
proc sort data=ipObs  ;by clm_id descending Obsclm_ln;run;
proc sort data=ipObs nodupkey ;by clm_id;run;
proc sql;
create table temp1 as
select a.bene_id,a.clm_id,a.SRC_ADMS,a.ADMSN_DT,a.DSCHRGDT,a.PROVIDER,a.ADMTG_DGNS_CD,
a.ICD_DGNS_CD1,a.ICD_DGNS_CD2,a.ICD_DGNS_CD3,a.ICD_DGNS_CD4,a.ICD_DGNS_CD5,a.ICD_DGNS_CD6,a.ICD_DGNS_CD7,a.ICD_DGNS_CD8,a.ICD_DGNS_CD9,a.ICD_DGNS_CD10,
a.ICD_DGNS_CD11,a.ICD_DGNS_CD12,a.ICD_DGNS_CD13,a.ICD_DGNS_CD14,a.ICD_DGNS_CD15,a.ICD_DGNS_CD16,a.ICD_DGNS_CD17,a.ICD_DGNS_CD18,a.ICD_DGNS_CD19,a.ICD_DGNS_CD20,
a.ICD_DGNS_CD21,a.ICD_DGNS_CD22,a.ICD_DGNS_CD23,a.ICD_DGNS_CD24,a.ICD_DGNS_CD25, b.*
from elix.Elixall2013 a left join ipED b
on a.bene_id=b.bene_id and a.clm_id=b.clm_id;
quit;
proc sql;
create table temp2 as
select a.*,b.*
from temp1 a left join ipObs b
on a.bene_id=b.bene_id and a.clm_id=b.clm_id;
quit;
  
data ip2013;
set temp2;

i=substr(provider,3,2) ; 
	if i in ('00','01','02','03','04','05','06','07','08') then type='Acute Care Hospitals';  
     
if i in ('00','01','02','03','04','05','06','07','08');


if ADMTG_DGNS_CD in ('40201', '40211', '40291', '40401', '40403', '40411', '40413', '40491', '40493', '4280', '4281', '42820', '42821', '42822', '42823', '42830', '42831', '42832', '42833', '42840', '42841', '42842', '42843', '4289' )
then  chf=1; else chf=0; 
 
if ADMTG_DGNS_CD in ('4800', '4801', '4802', '4803', '4808', '4809', 
						'481', '4820', '4821', 
						'4822', '48230', '48231', '48232', '48239', '48240', '48241', '48242', '48249', '48281','48282','48283',  '48284', '48289', '4829', 
						'4830', '4831', '4838', '485', '486', '4870', '48811'  )
then pn=1; else pn=0; 
   
 
if ADMTG_DGNS_CD in (	"49121","49122","4918", "4919",  "4928", "49320","49321","49322",  "496") or 
ADMTG_DGNS_CD in ('51881','51882','51884','51884') and (
ICD_DGNS_CD1 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD2 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD3 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD4 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD5 in ('49121', '49122', '49321','49322')
or ICD_DGNS_CD6 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD7 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD8 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD9 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD10 in ('49121', '49122', '49321','49322')
or ICD_DGNS_CD11 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD12 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD13 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD14 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD15 in ('49121', '49122', '49321','49322')
or ICD_DGNS_CD16 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD17 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD18 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD19 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD20 in ('49121', '49122', '49321','49322')
or ICD_DGNS_CD21 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD22 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD23 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD24 in ('49121', '49122', '49321','49322') or ICD_DGNS_CD25 in ('49121', '49122', '49321','49322'))
then copd=1;else copd=0;

if chf=1 or pn=1 or copd=1;

drop i ICD_DGNS_CD1-ICD_DGNS_CD25;
run;

***********************************Step4: Exclusions;

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
data bene2013; 
	set denom.dnmntr2013;   
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

  if age>=65 ;

  if SEX ne '0';
	sexcat=sex*1;*1=Male 2=Female;

    if race ne '0';
	if race = 1 then racecat=1;*white;
	else if race=2 then racecat=2;*black;
	else if race=5 then racecat=3;*hispanic;
	else racecat=4;*others;

  
  if CON_ENR=1 and  BENE_STATE ne 'xx' and hmo_mo=0 and esrd_ind ne 'Y';
  
  if bene_id ne '' and STRCTFLG ne '';
  keep BENE_ID BENE_STATE BENE_SSA_COUNTY BENE_ZIP SEXcat RACEcat age STRCTFLG; 
   
run;  


proc sql;create table opbene2013 as select * from op2013 where bene_id in (select bene_id from bene2013);quit;
proc sql;create table ipbene2013 as select * from ip2013 where bene_id in (select bene_id from bene2013);quit;

proc sort data=opbene2013 nodupkey;by bene_id ADMSN_DT;run;
proc sort data=ipbene2013 nodupkey;by bene_id ADMSN_DT;run;
*Highest intensive care: inpatient with ED/Obs --Could be billed separately,certain for different providers;
*Median intensive care: ED w/Obs;
*Lowest intensive care: Ed only;
proc sql;
create table temp as 
select a.*,b.chf as chf1,b.pn as pn1,b.copd as copd1,b.ADMSN_DT as ADMSN_DT1,b.SRC_ADMS,b.ed as ed1 
from opbene2013 a left join ipbene2013 b
on a.bene_id=b.bene_id and a.DSCHRGDT=b.ADMSN_DT;
quit;

data EDobs2013;
set temp;
if ED=1 and Obs=. then EDonly=1;
else if ED=1 and obs=1 then EDObs=1;

if chf=chf1 and pn=pn1 and copd=copd1 and ed1=1 then delete=1;*because ip2013 already include admissions;
else if chf=chf1 and pn=pn1 and copd=copd1 and ed1=. then EDadmission=1;*transfer to another short term care hospital for inpatient care;

proc freq ;
tables EDonly Edobs delete Edadmission/missing;
run;

data all;
set  ipbene2013(in=ip) EDobs2013(drop=HCPCS_CD REV_UNIT chf1 pn1 copd1 ed1);
if delete ne 1;drop delete;
if ed=. then delete;
if ip=1 then do;Inpatient=1;Outpatient=0;EDadmission=1;end;
else do;Inpatient=0;Outpatient=1;end;
proc freq;tables Inpatient Outpatient EDadmission Edobs EDonly/missing;
proc sort;by bene_id;
run;

************************************Step5: Discriptive Stat;






















************************************Step3: ED admission rate;

/*
Although one can assume ER patients found in the inpatient data were admitted to the hospital, 
one cannot assume ER patients found in the outpatient data were not admitted to the hospital. 
Because some patients are transferred to a different hospital for admission and some hospitals bill ER 
and inpatient services separately, determining admission status for those ER visits found in the 
Outpatient file requires linking to the inpatient data to find evidence of an admission.
*/
