********************************************
Laura's Abstract for SAEM
Xiner Zhou
11/10/2015
********************************************;

* Idea: ED admission rate and outcomes - Question: Do EDs with higher admission rates have lower mortality? ;
 
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
 
libname data 'C:\data\Projects\ED Xiner';
***********************************Step1: Identify ED visits in Outpatient Claims;

data opED ;
set op.Otptrev2013;
ed=0;if REV_CNTR in ('0450','0451','0452','0456','0459','0981') then  ED=1; if ED=1;
keep bene_id clm_id  ed ;
run;
proc sort data=opED nodupkey;by clm_id;run;
 
proc sql;
create table temp1 as
select a.bene_id,a.clm_id,a.STUS_CD,a.FROM_DT as ADMSN_DT,a.THRU_DT as DSCHRGDT,a.PROVIDER,a.PRNCPAL_DGNS_CD,
a.ICD_DGNS_CD1,a.ICD_DGNS_CD2,a.ICD_DGNS_CD3,a.ICD_DGNS_CD4,a.ICD_DGNS_CD5,a.ICD_DGNS_CD6,a.ICD_DGNS_CD7,a.ICD_DGNS_CD8,a.ICD_DGNS_CD9,a.ICD_DGNS_CD10,
a.ICD_DGNS_CD11,a.ICD_DGNS_CD12,a.ICD_DGNS_CD13,a.ICD_DGNS_CD14,a.ICD_DGNS_CD15,a.ICD_DGNS_CD16,a.ICD_DGNS_CD17,a.ICD_DGNS_CD18,a.ICD_DGNS_CD19,a.ICD_DGNS_CD20,
a.ICD_DGNS_CD21,a.ICD_DGNS_CD22,a.ICD_DGNS_CD23,a.ICD_DGNS_CD24,a.ICD_DGNS_CD25, b.*
from op.Otptclms2013 a inner join opED b
on a.bene_id=b.bene_id and a.clm_id=b.clm_id;
quit;

 
data op2013;
set temp1;

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

data ipED ;
set ip.Inptrev2013;
ed=0;if REV_CNTR in ('0450','0451','0452','0456','0459','0981') then  ED=1; if ED=1;
keep bene_id clm_id  ed ;
run;
proc sort data=ipED nodupkey;by clm_id;run;

proc sql;
create table temp1 as
select a.bene_id,a.clm_id,a.TYPE_ADM,a.stus_cd,a.ADMSN_DT,a.DSCHRGDT,a.PROVIDER,a.ADMTG_DGNS_CD,
a.ICD_DGNS_CD1,a.ICD_DGNS_CD2,a.ICD_DGNS_CD3,a.ICD_DGNS_CD4,a.ICD_DGNS_CD5,a.ICD_DGNS_CD6,a.ICD_DGNS_CD7,a.ICD_DGNS_CD8,a.ICD_DGNS_CD9,a.ICD_DGNS_CD10,
a.ICD_DGNS_CD11,a.ICD_DGNS_CD12,a.ICD_DGNS_CD13,a.ICD_DGNS_CD14,a.ICD_DGNS_CD15,a.ICD_DGNS_CD16,a.ICD_DGNS_CD17,a.ICD_DGNS_CD18,a.ICD_DGNS_CD19,a.ICD_DGNS_CD20,
a.ICD_DGNS_CD21,a.ICD_DGNS_CD22,a.ICD_DGNS_CD23,a.ICD_DGNS_CD24,a.ICD_DGNS_CD25, b.*
from ip.Inptclms2013 a inner join ipED b
on a.bene_id=b.bene_id and a.clm_id=b.clm_id;
quit;
 
  
data ip2013;
set temp1;

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

if chf=1 or pn=1 or copd=1 ;

drop i ICD_DGNS_CD1-ICD_DGNS_CD25;
run;
 
 

***********************************Step4: Exclusions;
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

  if BUYIN_MO=0 then DUA=0;else DUA=1;
  keep BENE_ID BENE_STATE BENE_SSA_COUNTY BENE_ZIP SEXcat RACEcat age STRCTFLG DEATH_DT 
  Buyin01 Buyin02 Buyin03 Buyin04 Buyin05 Buyin06 Buyin07 Buyin08 Buyin09 Buyin10 Buyin11 Buyin12 BUYIN_MO DUA; 
   
run; 
 


*20% sample;
proc sql;create table opbene2013 as select a.*,b.* from op2013 a inner join bene2013 b on a.bene_id=b.bene_id;quit;
proc sql;create table ipbene2013 as select a.*,b.* from ip2013 a inner join bene2013 b on a.bene_id=b.bene_id;quit;
*transfers or duplicate;
proc sort data=opbene2013 ;by bene_id ADMSN_DT descending DSCHRGDT descending stus_cd;run;
proc sort data=opbene2013 nodupkey;by bene_id ADMSN_DT  ;run;

proc sort data=ipbene2013 ;by bene_id ADMSN_DT descending DSCHRGDT stus_cd ;run;
proc sort data=ipbene2013 nodupkey;by bene_id ADMSN_DT  ;run;
 
*Put ip and op together;
data ED2013;
set ipbene2013(in=ip) opbene2013(in=op);
if ip=1 then Inpatient=1;else inpatient=0;
if op=1 then Outpatient=1;else Outpatient=0;
if ip=1 or (op=1 and stus_cd='02') then EDlevel=1;
else EDlevel=0;
proc sort;by bene_id ADMSN_DT;run;
*proc freq ;where COPD=1;tables EDlevel Inpatient outpatient /missing ;
run;

* some claims with ordinary discharge code actually was admitted;
proc sort data=ED2013;by bene_id ADMSN_DT descending edlevel ;run;
proc sort data=ED2013 nodupkey;by bene_id ADMSN_DT ;run;



*********************************************************************************
Data Analysis: 
	Step 1: We adopted a multistep approach where we first used logistic regression to estimate the probability of each patientÅfs admission as a function of patient characteristics
    and selected hospital characteristics that might indirectly reflect patient differences. 

    Then, as we would have done in the hypothetical experiment, we calculated an expected admission rate for each of the 2,219 hospitals visited by sample patients using the predicted
	admission probabilities from the logistic regression. We defined the adjusted admission rate as the difference between the observed and expected admission rates 
    and scaled the result to make the overall level of the rates easily comparable (the overall means of the adjusted and observed rates were equated). 

    Step2: This adjusted admission rate was intended to be a marker for the ÅgintensityÅh of care the hospital provided Medicare chest pain patients, as higher-intensity hospitals
    would have a greater chance of admitting higher proportions of patients rather than discharging them home. We ordered patients by adjusted admission rate and
    defined quintile groups for the purpose of displaying and testing differences in patient and hospital characteristics using chi-square and analysis of variance tests.
    Ratios of observed and expected events are commonly used to ÅgstandardizeÅh rates, but adjusted rates based on differences are also used.18 Both measures yield identical
    rank orderings of hospitals, which is how our quintiles were defined.
    
    Step3: The third step used logistic regression to estimate the probability of each patientÅfs outcomes for AMI and death as a function of the continuous adjusted admission
    rate, together with patient and hospital covariates. Rather than the quintiles used for descriptive purposes, the continuous admission rate variable was included in
    the outcome equation because, after exploring alternative specifications, we decided that it provided more complete information about admission rate variation.

    Step4: The final step in our analysis was to calculate outcome probabilities (expressed as rates per 1,000 persons) and treatment effects
    ?first, by admission rate quintile from a bivariate analysis, and second, from multivariable logistic regression estimates.
    For the latter, outcome probabilities were calculated for each sample member, as if each person had been treated in hypothetical hospitals with admission rates ranging from
    36% to 83%. The mean probability was calculated for each admission rate, and treatment effect estimates  associated with specific admission rate differences were
    calculated as differences in these means. Using two estimation methods provided a useful check on the consistency and robustness of our results. 

    Note: All equations were estimated using SAS proc surveylogistic, with standard errors adjusted for patient clustering within hospitals.
    The outcome regressions were weighted by the number of each hospitalÅfs sample cases used to calculate the adjusted admission rate.
    
*********************************************************************************************************************;

LIBNAME hcc 'C:\data\Data\Medicare\HCC\2013';
libname aha 'C:\data\Data\Hospital\AHA\Annual_Survey\Data';

data temp;set HCC.Hcc_20pct_2013;keep bene_id  HCC1--HCC189;run;
proc sql;create table temp1 as select a.*,b.* from ED2013 a left join temp b on a.bene_id=b.bene_id;quit;

*Hosp Stru Char;
 
data aha12;
retain provider id;
set aha.aha12(keep=provider id hospsize hosp_reg4 RUCA_level CBSATYPE p_medicare p_medicaid profit2 teaching  );
if CBSATYPE='Rural' then Rural=1;else Rural=0;
run;
data aha11;
retain provider id;
set aha.aha11(keep=provider id hospsize hosp_reg4 RUCA_level CBSATYPE p_medicare p_medicaid profit2 teaching  );
if CBSATYPE='Rural' then Rural=1;else Rural=0;
run;
data aha10;
retain provider id;
set aha.aha10(keep=provider id hospsize hosp_reg4 RUCA_level CBSATYPE p_medicare p_medicaid profit2 teaching  );
if CBSATYPE='Rural' then Rural=1;else Rural=0;
run;
data aha09;
retain provider id;
set aha.aha09(keep=provider id hospsize hosp_reg4 RUCA_level CBSATYPE p_medicare p_medicaid profit2 teaching  );
if CBSATYPE='Rural' then Rural=1;else Rural=0;
run;

data AHA;
set AHA12(in=in1)  AHA11(in=in2)  AHA10(in=in3) AHA09(in=in4) ;
	if in1 then year=2012;
	else if in2 then year=2011;
	else if in3 then year=2010;
	else if in4 then year=2009;
 
	proc sort ;by provider descending year;
run;

proc sort data=AHA nodupkey;by provider;run;

proc sql;create table data as select a.*,b.* from temp1 a left join aha b on a.provider=b.provider;quit;

data data;set data;drop year;where hosp_reg4 not in (5) and profit2 not in (4);proc freq;tables hosp_reg4 profit2 Rural teaching  /missing;run;*don't drop hospital because they don't have survey;
 
*Death Status;
data data.data;
set data;
if 0<=death_DT - ADMSN_DT<=30 then death=1; else death=0;drop HCC54 HCC55;
run;






















%let cond=CHF;
%let cond=pn;
%let cond=COPD;



************************************** Step1: Logistic regression for risk-adjusted admission rate;

*Risk-Adjustment Model;
proc genmod data=data.data  descending;
where &cond.=1;
Title "Logistic Regression: Predicted Probability of &cond. ED Admission, Adjusting for HCC,Age,Race,Sex ";
	class EDlevel   racecat sexcat provider HCC1--HCC189 ;
	model EDlevel=age  racecat sexcat DUA HCC1--HCC189/dist=bin link=logit type3;	 
	output out=pred&cond. pred=p&cond. ;
run;
 
*Predicted/Obs * Overall;
proc means data=pred&cond.  noprint;
var EDlevel;
output out=overall  mean=overall ;
run;
data _null_;set overall ;call symput("overall",overall );run;

proc sort data=pred&cond. ;by provider;run;
proc sql;
create table &cond. as
select *,mean(EDlevel) as RawEDadmRate&cond. ,sum(EDlevel) as obsEDadm&cond. ,sum(p&cond. ) as predEDadm&cond. , count(clm_id) as N_ED&cond. 
from pred&cond. 
group by provider;
quit;
proc sort data=&cond. nodupkey;by provider;run;

data data.AdjEDadmRate&cond. ;
set &cond.;
overall =symget('overall')*1;
AdjEDadmRate&cond. =(obsEDadm&cond. /predEDadm&cond. )*overall ;
AdjEDadmRate10&cond. =AdjEDadmRate&cond.*10;
keep provider overall N_ED&cond. obsEDadm&cond.  predEDadm&cond. AdjEDadmRate&cond. AdjEDadmRate10&cond. RawEDadmRate&cond. ;
run;


*Model1 : no patient ED admission Status;
proc sql;create table model&cond. as select a.*,b.* from data.data a left join data.AdjEDadmRate&cond. b on a.provider=b.provider where &cond.=1;quit;
data model&cond. ;set model&cond. ;drop HCC110 HCC112 HCC76;run;

proc genmod data=model&cond.  descending ;
weight N_ED&cond. ;
	class death EDlevel racecat sexcat provider HCC1--HCC189   ;
	model death= AdjEDadmRate10&cond.  /dist=bin link=logit type3;
	repeated subject=provider/type=exch;
	estimate "OR" AdjEDadmRate10&cond. 1/ exp;
	 
	ods output  GEEEmpPEst=&cond.Model1nocov;	
run;
 
proc genmod data=model&cond.   descending ;
weight N_ED&cond. ;
	class death EDlevel racecat sexcat provider HCC1--HCC189 DUA hospsize hosp_reg4 RUCA_level profit2 teaching;
	model death= AdjEDadmRate10&cond.  age racecat sexcat DUA hospsize hosp_reg4 RUCA_level  p_medicare p_medicaid profit2 teaching HCC1--HCC189/dist=bin link=logit type3;
	repeated subject=provider/type=exch;
	estimate "OR" AdjEDadmRate10&cond. 1/ exp;
	ods output  GEEEmpPEst=&cond.Model1;
	*ods output  ParameterEstimates=&cond.Model1;
	store sasuser.beta1;	
run;
%macro loop;
%do i=0 %to 100; *try i%;
data try&i.;set model&cond. ;AdjEDadmRate10&cond.  =&i./10;run;
proc plm source=sasuser.beta1;score data=try&i. out=try&i.out predicted / ilink;run;
proc means data=try&i.out;var Predicted;output out=try&i.pred mean=pred;run;

%if &i=0 %then %do;
	data plot;
	set try&i.pred;
	AdjEDadmRate=&i. *1;
	keep AdjEDadmRate pred ;
	run;
%end;
%else  %do;
	data try&i.pred;
	set try&i.pred;
	AdjEDadmRate=&i. *1;
	keep AdjEDadmRate pred ;
	run;
	data plot;
	set plot try&i.pred;
	run;
%end;

%end;
 
%mend loop;
 %loop;
 
 proc sgplot data=plot;
 title "&cond. : Relationship between Mortality vs Hospital-level Risk-adjusted ED Admission Rate";
 series x=AdjEDadmRate y=pred/lineattrs=(pattern=42);
 xaxis label="Hospital-level Risk-adjusted ED Admission Rate";
 yaxis label="Mortality";
 run;
proc print data=&cond.Model1nocov;run;
 proc print data=&cond.Model1;run;

 
 

*Model2 : stratify by patient ED admission Status;
 proc genmod data=model&cond.  descending ;
weight N_ED&cond.;
	class death EDlevel racecat sexcat provider HCC1--HCC189;
	model death=EDlevel AdjEDadmRate10&cond. EDlevel*AdjEDadmRate10&cond. /dist=bin link=logit type3;
	repeated subject=provider/type=exch;
	estimate "OR adm/dis"   EDlevel  1 -1/ exp;
	estimate "OR discharged" AdjEDadmRate10&cond. 1 EDlevel*AdjEDadmRate10&cond. 1 0/ exp;
	estimate "OR admitted" AdjEDadmRate10&cond. 1 EDlevel*AdjEDadmRate10&cond. 0 1/ exp;
	ods output  GEEEmpPEst=&cond.Model2nocov; 
run;

proc genmod data=model&cond.  descending ;
weight N_ED&cond.;
	class death EDlevel racecat sexcat provider HCC1--HCC189 DUA hospsize hosp_reg4 RUCA_level profit2 teaching;
	model death=EDlevel AdjEDadmRate10&cond. EDlevel*AdjEDadmRate10&cond. age racecat sexcat DUA hospsize hosp_reg4 RUCA_level  p_medicare p_medicaid profit2 teaching  HCC1--HCC189/dist=bin link=logit type3;
	repeated subject=provider/type=exch;
	estimate "OR adm/dis"   EDlevel  1 -1/ exp;
    estimate "OR discharged" AdjEDadmRate10&cond. 1 EDlevel*AdjEDadmRate10&cond. 1 0/ exp;
	estimate "OR admitted" AdjEDadmRate10&cond. 1 EDlevel*AdjEDadmRate10&cond. 0 1/ exp;
	ods output GEEEmpPEst=&cond.Model2;
	*ods output ParameterEstimates=&cond.Model2;
	store sasuser.beta2;	
run;
 
%macro loop;
*assume counterfactually, everyone admitted through ED;
%do i=0 %to 100; *try i%;
data try&i.ED1;set model&cond.;EDlevel=1;AdjEDadmRate10&cond.=&i./10;run;
proc plm source=sasuser.beta2;score data=try&i.ED1 out=try&i.ED1out  predicted / ilink;run;
proc means data=try&i.ED1out;var Predicted;output out=try&i.ED1pred mean=pred;run;

%if &i=0 %then %do;
	data plotED1;
	set try&i.ED1pred;
	EDlevel=1;
	AdjEDadmRate=&i. *1;	 
	keep EDlevel AdjEDadmRate pred ;
	run;
%end;
%else  %do;
	data try&i.ED1pred;
	set try&i.ED1pred;
	EDlevel=1;
	AdjEDadmRate=&i. *1;
	keep EDlevel AdjEDadmRate pred ;
	run;
	data plotED1;
	set plotED1 try&i.ED1pred;
	run;
%end;

%end;
*assume counterfactually, everyone discharge through ED;
%do i=0 %to 100; *try i%;
data try&i.ED0;set model&cond.;EDlevel=0;AdjEDadmRate10&cond.=&i./10;run;
proc plm source=sasuser.beta2;score data=try&i.ED0 out=try&i.ED0out  predicted / ilink;run;
proc means data=try&i.ED0out;var Predicted;output out=try&i.ED0pred mean=pred;run;

%if &i=0 %then %do;
	data plotED0;
	set try&i.ED0pred;
	EDlevel=0;
	AdjEDadmRate=&i. *1;	 
	keep EDlevel AdjEDadmRate pred ;
	run;
%end;
%else  %do;
	data try&i.ED0pred;
	set try&i.ED0pred;
	EDlevel=0;
	AdjEDadmRate=&i. *1;
	keep EDlevel AdjEDadmRate pred ;
	run;
	data plotED0;
	set plotED0 try&i.ED0pred;
	run;
%end;

%end;
 
data plotED;
set plotED0 plotED1;
run;
%mend loop;
 %loop;
 
 proc sgplot data=plotED;
 title "&cond.: Relationship between Mortality vs Hospital-level Risk-adjusted ED Admission Rate";
 series x=AdjEDadmRate y=pred/group=EDlevel lineattrs=(pattern=42);
 xaxis label='Hospital-level Risk-adjusted ED Admission Rate'  ;
 yaxis label="Mortality";
 run;
  proc print data=&cond.Model2nocov;run;
 proc print data=&cond.Model2;run;



 
*********************************Table 1 : Patient Char by Quintiles of Admission Rate;
%let cond=CHF;
%let cond=pn;
%let cond=COPD;
proc rank data=data.AdjEDadmRate&cond. out=AdjEDadmRate&cond. group=5;
var AdjEDadmRate&cond.;
ranks AdjEDadmRate&cond._r;
run;

data AdjEDadmRate&cond.;
set AdjEDadmRate&cond.;
Q=AdjEDadmRate&cond._r+1;
proc means mean std;class Q;var AdjEDadmRate&cond.;
proc anova;class Q;model AdjEDadmRate&cond.=Q;
quit;

proc sql;create table model&cond. as select a.*,b.* from data.data a left join AdjEDadmRate&cond. b on a.provider=b.provider where &cond.=1;quit;
data model&cond. ;set model&cond. ;drop HCC110 HCC112 HCC76;run;

*Paitent Characterisitcs;
proc sort data=model&cond. out=bene nodupkey;by provider bene_id;run;
 

%macro Continuous(y=);
proc means data=bene mean std;
	class Q;
	var &y. ;
run;
proc anova data=bene;
class Q;
model &y.=Q;
quit;

%mend Continuoustable;
%Continuous(y=Age);
 

%macro Category(y=);
proc freq data=bene;
	tables &y. *Q/nofreq   norow nopercent nocum chisq;
run;
%mend Category;
%Category(y=racecat);
%Category(y=sexcat);
%Category(y=dua);


%macro HCCs(y=,t=);

ods output "Estimates"=mean&y. "Type 3 Tests of Fixed Effects"=p&y.;
	proc mixed data=bene;
		class Q;
		model &y.=Q /solution;
		estimate " Q1" intercept 1 Q 1 0 0 0 0;
		estimate " Q2" intercept 1 Q 0 1 0 0 0;
		estimate " Q3" intercept 1 Q 0 0 1 0 0;
		estimate " Q4" intercept 1 Q 0 0 0 1 0;
		estimate " Q5" intercept 1 Q 0 0 0 0 1;
	run;
ods output close;

proc transpose data=mean&y. out=outmean&y.(drop=_name_);
	var estimate;
	id label;
run;

data &y.;
length Effect $100.;
	merge outmean&y. p&y.(keep=ProbF);
	Effect=&t.;Q1=Q1*100;Q2=Q2*100;Q3=Q3*100;Q4=Q4*100;Q5=Q5*100;
run;

%mend HCCs;
%HCCs(y=HCC1,t="HIV/AIDS" );
%HCCs(y=HCC2,t="Septicemia, Sepsis, Systemic Inflammatory Response Syndrome/Shock" );
%HCCs(y=HCC6,t="Opportunistic Infections " );
%HCCs(y=HCC8,t="Metastatic Cancer and Acute Leukemia" );
%HCCs(y=HCC9,t="Lung and Other Severe Cancers " );
%HCCs(y=HCC10,t="Lymphoma and Other Cancers" );
%HCCs(y=HCC11,t="Colorectal, Bladder, and Other Cancers" );
%HCCs(y=HCC12,t="Breast, Prostate, and Other Cancers and Tumors " );
%HCCs(y=HCC17,t="Diabetes with Acute Complications" );
%HCCs(y=HCC18,t="Diabetes with Chronic Complications " );
%HCCs(y=HCC19,t="Diabetes without Complication" );
%HCCs(y=HCC21,t="Protein-Calorie Malnutrition" );
%HCCs(y=HCC22,t="Morbid Obesity" );
%HCCs(y=HCC23,t="Other Significant Endocrine and Metabolic Disorders" );
%HCCs(y=HCC27,t="End-Stage Liver Disease" );
%HCCs(y=HCC28,t="Cirrhosis of Liver" );
%HCCs(y=HCC29,t="Chronic Hepatitis" );
%HCCs(y=HCC33,t="Intestinal Obstruction/Perforation" );
%HCCs(y=HCC34,t="Chronic Pancreatitis" );
%HCCs(y=HCC35,t="Inflammatory Bowel Disease" );
%HCCs(y=HCC39,t="Bone/Joint/Muscle Infections/Necrosis" );
%HCCs(y=HCC40,t="Rheumatoid Arthritis and Inflammatory Connective Tissue Disease" );
%HCCs(y=HCC46,t="Severe Hematological Disorders" );
%HCCs(y=HCC47 ,t="Disorders of Immunity" );
%HCCs(y=HCC48 ,t="Coagulation Defects and Other Specified Hematological Disorders" );
%HCCs(y=HCC51 ,t="Dementia With Complications" );
%HCCs(y=HCC52 ,t="Dementia Without Complication" );
%HCCs(y=HCC57 ,t="Schizophrenia" );
%HCCs(y=HCC58 ,t="Major Depressive, Bipolar, and Paranoid Disorders" );
%HCCs(y=HCC70 ,t="Quadriplegia" );
%HCCs(y=HCC71 ,t="Paraplegia" );
%HCCs(y=HCC72 ,t="Spinal Cord Disorders/Injuries" );
%HCCs(y=HCC73 ,t="Amyotrophic Lateral Sclerosis and Other Motor Neuron Disease" );
%HCCs(y=HCC74 ,t="Cerebral Palsy " );
%HCCs(y=HCC75 ,t="Polyneuropathy" );
%HCCs(y=HCC76 ,t="Muscular Dystrophy" );
%HCCs(y=HCC77 ,t="Multiple Sclerosis" );
%HCCs(y=HCC78 ,t="Parkinson's and Huntington's Diseases" );
%HCCs(y=HCC79 ,t="Seizure Disorders and Convulsions" );
%HCCs(y=HCC80 ,t="Coma, Brain Compression/Anoxic Damage" );
%HCCs(y=HCC82 ,t="Respirator Dependence/Tracheostomy Status" );
%HCCs(y=HCC83 ,t="Respiratory Arrest" );
%HCCs(y=HCC84 ,t="Cardio-Respiratory Failure and Shock" );
%HCCs(y=HCC85 ,t="Congestive Heart Failure" );
%HCCs(y=HCC86 ,t="Acute Myocardial Infarction" );
%HCCs(y=HCC87 ,t="Unstable Angina and Other Acute Ischemic Heart Disease" );
%HCCs(y=HCC88 ,t="Angina Pectoris" );
%HCCs(y=HCC96 ,t="Specified Heart Arrhythmias" );
%HCCs(y=HCC99 ,t="Cerebral Hemorrhage" );
%HCCs(y=HCC100 ,t="Ischemic or Unspecified Stroke" );
%HCCs(y=HCC103 ,t="Hemiplegia/Hemiparesis" );
%HCCs(y=HCC104 ,t="Monoplegia, Other Paralytic Syndromes" );
%HCCs(y=HCC106 ,t="Atherosclerosis of the Extremities with Ulceration or Gangrene" );
%HCCs(y=HCC107 ,t="Vascular Disease with Complications" ); 
%HCCs(y=HCC108 ,t="Vascular Disease" );
%HCCs(y=HCC110 ,t="Cystic Fibrosis" );
%HCCs(y=HCC111 ,t="Chronic Obstructive Pulmonary Disease" );
%HCCs(y=HCC112 ,t="Fibrosis of Lung and Other Chronic Lung Disorders" );
%HCCs(y=HCC114 ,t="Aspiration and Specified Bacterial Pneumonias" );
%HCCs(y=HCC115 ,t="Pneumococcal Pneumonia, Empyema, Lung Abscess" );
%HCCs(y=HCC122 ,t="Proliferative Diabetic Retinopathy and Vitreous Hemorrhage" );
%HCCs(y=HCC124 ,t="Exudative Macular Degeneration" );
%HCCs(y=HCC134 ,t="Dialysis Status" );
%HCCs(y=HCC135 ,t="Acute Renal Failure" );
%HCCs(y=HCC136 ,t="Chronic Kidney Disease, Stage 5 " );
%HCCs(y=HCC137 ,t="Chronic Kidney Disease, Severe (Stage 4) " );  
%HCCs(y=HCC138 ,t="Chronic Kidney Disease, Moderate (Stage 3)" );
%HCCs(y=HCC139 ,t="Chronic Kidney Disease, Mild or Unspecified (Stages 1-2 or Unspecified)" );
%HCCs(y=HCC140 ,t="Unspecified Renal Failure" );
%HCCs(y=HCC141 ,t="Nephritis" );
%HCCs(y=HCC157 ,t="Pressure Ulcer of Skin with Necrosis Through to Muscle, Tendon, or Bone" );
%HCCs(y=HCC158 ,t="Pressure Ulcer of Skin with Full Thickness Skin Loss" );
%HCCs(y=HCC159 ,t="Pressure Ulcer of Skin with Partial Thickness Skin Loss" );
%HCCs(y=HCC160 ,t="Pressure Pre-Ulcer Skin Changes or Unspecified Stage" );
%HCCs(y=HCC161 ,t="Chronic Ulcer of Skin, Except Pressure " );
%HCCs(y=HCC162 ,t="Severe Skin Burn or Condition" );
%HCCs(y=HCC166 ,t="Severe Head Injury" );
%HCCs(y=HCC167 ,t="Major Head Injury" );
%HCCs(y=HCC169 ,t="Vertebral Fractures without Spinal Cord Injury" );
%HCCs(y=HCC170 ,t="Hip Fracture/Dislocation" );
%HCCs(y=HCC173 ,t="Traumatic Amputations and Complications" );
%HCCs(y=HCC176 ,t="Complications of Specified Implanted Device or Graft" );
%HCCs(y=HCC186 ,t="Major Organ Transplant or Replacement Status" );
%HCCs(y=HCC188 ,t="Artificial Openings for Feeding or Elimination" );
%HCCs(y=HCC189 ,t="Amputation Status, Lower Limb/Amputation Complications" );

data HCC;
set HCC1 HCC2 HCC6 HCC8 HCC9 HCC10 HCC11 HCC12 HCC17 HCC18 HCC19 
HCC21 HCC22 HCC23 HCC27 HCC28 HCC29
HCC33 HCC34 HCC35 HCC39
HCC40 HCC46 HCC47 HCC48
HCC51 HCC52 HCC57 HCC58
HCC70 HCC71 HCC72 HCC73 HCC74 HCC75 HCC76 HCC77 HCC78 HCC79
HCC80 HCC82 HCC83 HCC84 HCC85 HCC86 HCC87 HCC88 
HCC96 HCC99
HCC100 HCC103 HCC104 HCC106 HCC107 HCC108 
HCC110 HCC111 HCC112 HCC114 HCC115 
HCC122 HCC124 
HCC134 HCC135 HCC136 HCC137 HCC138 HCC139
HCC140 HCC141 
HCC157 HCC158 HCC159
HCC160 HCC161 HCC162 HCC166 HCC167 HCC169 
HCC170 HCC173 HCC176 
HCC186 HCC188 HCC189
;
proc sort;by descending Q3;
proc print;
run;
  




*********************************Table 2: Hospital Char by Quintiles of Admission Rate;
libname aha 'C:\data\Data\Hospital\AHA\Annual_Survey\Data';
%let cond=CHF;
%let cond=pn;
%let cond=COPD;
proc rank data=data.AdjEDadmRate&cond. out=AdjEDadmRate&cond. group=5;
var AdjEDadmRate&cond.;
ranks AdjEDadmRate&cond._r;
run;

data AdjEDadmRate&cond.;
set AdjEDadmRate&cond.;
Q=AdjEDadmRate&cond._r+1;
proc means median QRANGE ;class Q;var AdjEDadmRate&cond.;
proc anova;class Q;model AdjEDadmRate&cond.=Q;
quit;


proc sql;create table model&cond. as select a.*,b.* from data.data a left join AdjEDadmRate&cond. b on a.provider=b.provider where &cond.=1;quit;
proc sort data=model&cond. nodupkey;by provider bene_id;run;
proc sql;
create table temp1 as
select provider,count(bene_id) as N_bene
from model&cond. 
group by provider;
quit;*total number of patient per provier;




data aha12;
set aha.aha12(keep=provider  hospsize hosp_reg4 profit2 teaching RUCA_level p_medicare p_medicaid  );
run;


proc sql;
create table temp2 as
select a.*,b.*
from AdjEDadmRate&cond.   a left join temp1 b
on a.provider=b.provider;
quit;
proc sql;
create table Hosp&cond. as
select a.*,b.*
from temp2 a left join aha12 b
on a.provider=b.provider;
quit;
%macro Continuous(y=);
proc means data=Hosp&cond. mean std;
	class Q;
	var &y. ;
run;
proc anova data=Hosp&cond.;
class Q;
model &y.=Q;
quit;

%mend Continuoustable;
%Continuous(y=N_ED&cond. );
%Continuous(y=N_bene);
%macro Category(y=);
proc freq data=Hosp&cond.;
	tables &y. *Q/nofreq   norow nopercent nocum chisq;
run;
%mend Category;
%Category(y=hospsize );
%Category(y=hosp_reg4 );
%Category(y=profit2 );
%Category(y=teaching);
%Category(y=RUCA_level);
 
%macro Continuous(y=);
proc means data=Hosp&cond. mean std;
	class Q;
	var &y. ;
run;
proc anova data=Hosp&cond.;
class Q;
model &y.=Q;
quit;

%mend Continuoustable;
%Continuous(y=p_medicare );
%Continuous(y=p_medicaid  );
 
 
