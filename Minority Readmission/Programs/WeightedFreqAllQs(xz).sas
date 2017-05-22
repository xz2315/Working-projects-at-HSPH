*****************************************
Simple frequency table for each question
1/28/2015
Xiner Zhou
*******************************************;

libname data 'C:\data\Projects\Minority_Readmissions\Data';
libname aha 'C:\data\Data\Hospital\AHA\Annual_Survey\Data';


**************************************Import final survey and denominator file;
%macro imp_xls(file=,out=);
proc import datafile="&file." dbms=xls out=&out. replace;
getnames=yes;
run;
%mend imp_xls;

%imp_xls(file=C:\data\Projects\Minority_Readmissions\Data\MRsurvey.xls,out=survey)
%imp_xls(file=C:\data\Projects\Minority_Readmissions\Data\denominator.xls,out=denominator)

data denominator;
set denominator;
if length(trim(medicare_id))=5 then medicare_id='0'||medicare_id;
run;

 




/*
1. Assigning sampling weight:
Group 1: MSHs-sampled all 900 (top 25.3% of 3556 hospitals), so sample weight of 1
Group 2: (Q1: poor performers) 233 of 533 (sample weight 2.29)
Group 3: (Q2-Q4: medium performers) 233 of 1594 (sample weight 6.84)
Group 4: (Q5: high performers) 233 of 533 (sample weight 2.29)
 
2. Assigning nonresponse weight:
For this step, Karen mentioned that they had already created a logistic regression model with all of the sampled hospitals 
(they did it with 1500 but we need to adjust it for 1600).  The outcome of the model is response, and the predictors are hospital characteristics.  
Each hospital then gets a predicted probability of response.  Their nonresponse weight is 1/p(response).

3. Multiply the two weights together to create their final weight.  All the survey results then get adjusted by this weight.
*/


***************************************** Clean ;
data survey;
set survey;
if var3='Non-MSH Q1' then var3='Q1';
if var3='Non-MSH Q2-4' then var3='Q2-4';
if var3='Non-MSH Q5' then var3='Q5';

if q16=. then q16=9;
if q18a=. then q18a=9;
rename var3=designation;
drop a AHA_ID var5 DSID__Datastat_only_ MAIL_STAT__Datastat_only_;
run;
 

**************************************Sampling weight;
 
/*
MSH             899 
Non-MSH Q1      39  
Non-MSH Q2-4    36  
Non-MSH Q5      44  
Q1              194  
Q2-4            198  
Q5              190  

--> MSH: sampled 899 out of top 25% of 3556 (899), so sample weight=1
--> non-MSH Q1: sampled 233 out of 531, so sample weight=2.27897
--> non-MSH Q2-Q4: sampled 234 out of 1594, so sample weight=6.811966
--> non-MSH Q5: sampled 234 out of 531, so sample weight=2.27897
*/
data survey;
set survey;
if designation='MSH' then swt=1;
if designation ='Q1' then swt=531/233;
if designation='Q2-4' then swt=1595/234;
if designation='Q5' then swt=531/234;
run;
 
*********************************** Non-response weight;
proc sql;
create table temp as
select a.medicare_id, a.Hospital_Name,a.urban,a.profit2,a.teaching, a.hospsize, a.hosp_reg4, a.CICU, a.mhsmemb, b.*
from denominator a full join survey  b
on a.hsph_id=b.hsph_id;
quit;

data temp;
set temp;
if Q1_1=. then respond=0;else respond=1;
if mhsmemb=. then mhsmemb=3;
if cicu=. then cicu=3;
run;

 
 
proc logistic data=temp noprint ;
title 'Response Rate Model';
	class respond(ref="0") urban(ref="1")  profit2(ref="1") teaching(ref="3") hosp_reg4(ref="1") CICU(ref="1") mhsmemb(ref="1")  /param=ref ;
	model respond  = urban profit2 teaching hosp_reg4 CICU mhsmemb ; 
	output  out=temp1 p=prob;  
run;
data temp2;
set temp1;
if prob=. then prob=0.6247655;
wt=swt/prob;
if respond=1;
run;
 

****************************Weighted Simple frequency for each question;
proc format ;
value question1_
0=NO
1=YES
9=MISSING
;
run;
proc format ;
value question2_
1=YES
2=NO
3=DON NOT KNOW
8=MULTIPLE MARKS
9=MISSING
;
run;
proc format ;
value question3_
1=LOWER THAN AVERAGE
2=ABOUT AVERAGE
3=HIGHER THAN AVERAGE
4=DON NOT KNOW
8=MULTIPLE MARKS
9=MISSING
;
run;
proc format ;
value question4_
1=IMPROVED SIGNIFICANTLY
2=IMPROVED SOMEWHAT
3=STAYED THE SAME
4=WORSENED SOMEWHAT
5=WORSENED SIGNIFICANTLY
6=DON NOT KNOW
8=MULTIPLE MARKS
9=MISSING
;
run;
proc format ;
value question7_
1=ALWAYS
2=USUALLY
3=SOMETIMES
4=NEVER/NOT IN USE
8=MULTIPLE MARKS
9=MISSING
;
run;
proc format ;
value question8_
1=YES
2=NO
8=MULTIPLE MARKS
9=MISSING
;
run;
proc format ;
value question12_
1=NOT A CHALLENGE
2=2
3=MODERATE CHALLENGE
4=4
5=GREAT CHALLENGE
6=DON NOT KNOW
8=MULTIPLE MARKS
9=MISSING;
run;
proc format ;
value question18_
1=NO IMPACT
2=2
3=MODERATE IMPACT
4=4
5=GREAT IMPACT
6=N/A
8=MULTIPLE MARKS
9=MISSING
;
run;
proc format ;
value question19_
1=NOT AT ALL LIKELY
2=2
3=MODERATELY LIKELY
4=4
5=EXTREMELY LIKELY
8=MULTIPLE MARKS
9=MISSING
;
run;
proc format ;
value question20_
1=MUCH TOO SMALL
2=TOO SMALL
3=ABOUT RIGHT
4=TOO LARGE
5=MUCH TOO LARGE
8=MULTIPLE MARKS
9=MISSING;
run;
proc format ;
value question21_
1=CARE WILL GET MUCH WORSE
2=CARE WILL GET SOMEWHAT WORSE
3=CARE WILL NOT CHANGE
4=CARE WILL IMPROVE SOMEWHAT
5=CARE WILL IMPROVE A GREAT DEAL
8=MULTIPLE MARKS
9=MISSING;
run;
proc format ;
value question22_
1=DISAGREE STRONGLY
2=DISAGREE
3=NEUTRAL
4=AGREE
5=AGREE STRONGLY
8=MULTIPLE MARKS
9=MISSING;
run;
proc format ;
value question23_
0=NOT A PRIORITY
1=01
2=02
3=03
4=04
5=MODERATE PRIORITY
6=06
7=07
8=08
9=09
10=HIGHEST PRIORITY
88=MULTIPLE MARKS
99=MISSING;
run;


%macro loop(title=,q=,n=);
proc freq data=temp2;
title "&title.";
format &q. question&n._.;
weight wt;
tables &q. /missing  ;
run;
%mend loop;
%loop(title=What is your official hospital title? Response: Chief Medical Officer,q=Q1_1,n=1);
%loop(title=What is your official hospital title? Response: Chief Quality Officer,q=Q1_2,n=1);
%loop(title=What is your official hospital title? Response: Chief Nursing Officer,q=Q1_3,n=1);
%loop(title=What is your official hospital title? Response: Director of Case Management (or equivalent),q=Q1_4,n=1);
%loop(title=What is your official hospital title? Response: Other,q=Q1_5,n=1);

%loop(title=Does your hospital use any of the following? An internal system for tracking patients discharged from and readmitted to your hospital,q=Q2A,n=2);
%loop(title=Does your hospital use any of the following? A system for tracking readmissions by patient race and/or ethnicity,q=Q2B,n=2);
%loop(title=Does your hospital use any of the following? Information about readmissions to your hospital or to other hospitals provided by one or more private insurers (Blue Cross, Aetna, etc.) or from Medicaid,q=Q2C,n=2);

%loop(title=Do any of the following individuals within your hospital receive regular reports or feedback on performance for 30-day readmissions? Hospital Board,q=Q3A,n=2);
%loop(title=Do any of the following individuals within your hospital receive regular reports or feedback on performance for 30-day readmissions? Chief Executive Officer,q=Q3B,n=2);
%loop(title=Do any of the following individuals within your hospital receive regular reports or feedback on performance for 30-day readmissions? Chief Medical Officer or Chief Quality Officer,q=Q3C,n=2);
%loop(title=Do any of the following individuals within your hospital receive regular reports or feedback on performance for 30-day readmissions? Department Chairs / Division Chiefs,q=Q3D,n=2);
%loop(title=Do any of the following individuals within your hospital receive regular reports or feedback on performance for 30-day readmissions? Individual physicians,q=Q3E,n=2);

%loop(title=Do any of the following individuals within your hospital receive financial incentives from the hospital to reduce readmissions (i.e. bonuses for low readmission rates, etc.)? Chief Executive Officer,q=Q4a,n=2);
%loop(title=Do any of the following individuals within your hospital receive financial incentives from the hospital to reduce readmissions (i.e. bonuses for low readmission rates, etc.)? Chief Medical Officer or Chief Quality Officer,q=Q4B,n=2);
%loop(title=Do any of the following individuals within your hospital receive financial incentives from the hospital to reduce readmissions (i.e. bonuses for low readmission rates, etc.)? Department Chairs / Division Chiefs,q=Q4C,n=2);
%loop(title=Do any of the following individuals within your hospital receive financial incentives from the hospital to reduce readmissions (i.e. bonuses for low readmission rates, etc.)? Individual physicians,q=Q4D,n=2);

%loop(title=Compared to other hospitals in the US Do you think your hospital 30day readmission rates for AMI/CHF/pneumonia in 2012 were ,q=Q5,n=3);

%loop(title=Over the past three years- how has your hospital performance changed on 30-day readmissions for AMI/CHF/pneumonia? ,q=Q6,n=4);

%loop(title=How often is each strategy used in your hospital for the specified patient population? Use a dedicated discharge planner or discharge coordinator,q=Q7A,n=7);
%loop(title=How often is each strategy used in your hospital for the specified patient population? Create a discharge summary prior to discharge and share this with the patient outpatient provider,q=Q7B,n=7);
%loop(title=How often is each strategy used in your hospital for the specified patient population? Communicate discharge plan verbally to primary care physician or next care provider at discharge,q=Q7C,n=7);
%loop(title=How often is each strategy used in your hospital for the specified patient population? Use electronic tools to share discharge summaries or other care plans with outpatient providers,q=Q7D,n=7);
%loop(title=How often is each strategy used in your hospital for the specified patient population? Schedule follow-up appointments for all patients prior to discharge,q=Q7E,n=7);
%loop(title=How often is each strategy used in your hospital for the specified patient population? Use pharmacists to reconcile discharge medications with prior outpatient medications,q=Q7F,n=7);
%loop(title=How often is each strategy used in your hospital for the specified patient population? Use electronic tools to reconcile discharge medications with prior outpatient medications,q=Q7G,n=7);
%loop(title=How often is each strategy used in your hospital for the specified patient population? Use a formal discharge checklist to document when all components of discharge protocol are complete,q=Q7H,n=7);
%loop(title=How often is each strategy used in your hospital for the specified patient population? Contact patients by phone within 48 hours after discharge to monitor their progress,q=Q7I,n=7);
%loop(title=How often is each strategy used in your hospital for the specified patient population? Use a transition coach to help patients manage medications and other self-care issues,q=Q7J,n=7);
%loop(title=How often is each strategy used in your hospital for the specified patient population? Enroll patients in a 30-day post-discharge care coordination or disease management program,q=Q7K,n=7);
%loop(title=How often is each strategy used in your hospital for the specified patient population? Enroll patients in a post-discharge patient activation and engagement program,q=Q7L,n=7);
%loop(title=How often is each strategy used in your hospital for the specified patient population? Use mobile or web-based applications to support patients and families in carrying out post-discharge care plans,q=Q7M,n=7);
 
%loop(title=In the past two years-has your hospital started new programs or significantly augmented existing programs in these areas? Use a dedicated discharge planner or discharge coordinator,q=Q8A,n=8);
%loop(title=In the past two years- has your hospital started new programs or significantly augmented existing programs in these areas? Create a discharge summary prior to discharge and share this with the patient outpatient provider,q=Q8b,n=8);
%loop(title=In the past two years- has your hospital started new programs or significantly augmented existing programs in these areas? Communicate discharge plan verbally to primary care physician or next care provider at discharge,q=Q8c,n=8);
%loop(title=In the past two years- has your hospital started new programs or significantly augmented existing programs in these areas? Use electronic tools to share discharge summaries or other care plans with outpatient providers,q=Q8d,n=8);
%loop(title=In the past two years- has your hospital started new programs or significantly augmented existing programs in these areas? Schedule follow-up appointments for all patients prior to discharge,q=Q8e,n=8);
%loop(title=In the past two years- has your hospital started new programs or significantly augmented existing programs in these areas? Use pharmacists to reconcile discharge medications with prior outpatient medications,q=Q8f,n=8);
%loop(title=In the past two years- has your hospital started new programs or significantly augmented existing programs in these areas? Use electronic tools to reconcile discharge medications with prior outpatient medications,q=Q8g,n=8);
%loop(title=In the past two years- has your hospital started new programs or significantly augmented existing programs in these areas? Use a formal discharge checklist to document when all components of discharge protocol are complete,q=Q8h,n=8);
%loop(title=In the past two years- has your hospital started new programs or significantly augmented existing programs in these areas? Contact patients by phone within 48 hours after discharge to monitor their progress,q=Q8i,n=8);
%loop(title=In the past two years- has your hospital started new programs or significantly augmented existing programs in these areas? Use a transition coach to help patients manage medications and other self-care issues,q=Q8j,n=8);
%loop(title=In the past two years- has your hospital started new programs or significantly augmented existing programs in these areas? Enroll patients in a 30-day post-discharge care coordination or disease management program,q=Q8k,n=8);
%loop(title=In the past two years- has your hospital started new programs or significantly augmented existing programs in these areas? Enroll patients in a post-discharge patient activation and engagement program,q=Q8l,n=8);
%loop(title=In the past two years- has your hospital started new programs or significantly augmented existing programs in these areas? Use mobile or web-based applications to support patients and families in carrying out post-discharge care plans,q=Q8m,n=8);
 proc freq data=temp2;
title "Q9.1";
weight wt;
tables recode_Q9_1 /missing  ;
run;
 proc freq data=temp2;
title "Q9.2";
weight wt;
tables recode_Q9_2 /missing  ;
run;


%loop(title=Does your hospital participate in any formal programs to reduce 30day readmissions such as STAAR /Project BOOST / CMS CCTP/Project Re-Engineered Discharge (RED)/ The Care Transitions Program? ,q=Q10,n=2);


%macro loop1(title=,q=,n=);
proc freq data=temp2;
where Q10=2;
title "&title.";
format &q. question&n._.;
weight wt;
tables &q. /missing  ;
run;
%mend loop1;
%loop1(title=If no- did any of the following factors contribute to the decision not to participate? The programs are too resource-intense to implement (costs/time/staffing),q=Q11A,n=2);
%loop1(title=If no- did any of the following factors contribute to the decision not to participate? The programs are unlikely to have an impact for my patients,q=Q11b,n=2);
%loop1(title=If no- did any of the following factors contribute to the decision not to participate? Our hospital was not aware of any of these programs,q=Q11c,n=2);
%loop1(title=If no- did any of the following factors contribute to the decision not to participate? Our hospital developed our own program internally to better meet our patients specific needs,q=Q11d,n=2);

%loop(title=How much of a challenge are each of the following hospital factors in your hospital efforts to reduce readmissions? Obtaining sufficient staffing to implement programs to reduce readmissions,q=q12a,n=12);
%loop(title=How much of a challenge are each of the following hospital factors in your hospital efforts to reduce readmissions? Ensuring adequacy of discharge processes,q=q12b,n=12);
%loop(title=How much of a challenge are each of the following hospital factors in your hospital efforts to reduce readmissions? Ensuring adequacy of handoffs of care when patients transition from the inpatient to the outpatient setting,q=q12c,n=12);
%loop(title=How much of a challenge are each of the following hospital factors in your hospital efforts to reduce readmissions? Obtaining evidence on what works to reduce readmissions,q=q12d,n=12);
%loop(title=How much of a challenge are each of the following hospital factors in your hospital efforts to reduce readmissions? Obtaining buy-in from inpatient clinicians,q=q12e,n=12);
%loop(title=How much of a challenge are each of the following hospital factors in your hospital efforts to reduce readmissions? Obtaining buy-in from outpatient clinicians,q=q12f,n=12);
%loop(title=How much of a challenge are each of the following hospital factors in your hospital efforts to reduce readmissions? Obtaining buy-in from emergency department clinicians,q=q12g,n=12);
%loop(title=How much of a challenge are each of the following hospital factors in your hospital efforts to reduce readmissions? Obtaining sufficient prioritization from hospital leadership,q=q12h,n=12);


%loop(title=How much of a challenge are each of the following financial factors in your hospital efforts to reduce readmissions? Availability of financial resources to implement new programs,q=q13a,n=12);
%loop(title=How much of a challenge are each of the following financial factors in your hospital efforts to reduce readmissions? Reducing readmissions may negatively impact hospital finances,q=q13b,n=12);

%loop(title=How much of a challenge are each of the following community factors in your hospital efforts to reduce readmissions? Availability of primary care in the community,q=q14a,n=12);
%loop(title=How much of a challenge are each of the following community factors in your hospital efforts to reduce readmissions? Availability of mental health and substance abuse services in the community,q=q14b,n=12);
%loop(title=How much of a challenge are each of the following community factors in your hospital efforts to reduce readmissions? Availability of nursing home or rehabilitation care in the community,q=q14c,n=12);
%loop(title=How much of a challenge are each of the following community factors in your hospital efforts to reduce readmissions? Availability of home health and visiting nurse services in the community,q=q14d,n=12);

%loop(title=How much of a challenge are each of the following patient factors in your hospital efforts to reduce readmissions? Homelessness,q=q15a,n=12);
%loop(title=How much of a challenge are each of the following patient factors in your hospital efforts to reduce readmissions? Language barriers,q=q15b,n=12);
%loop(title=How much of a challenge are each of the following patient factors in your hospital efforts to reduce readmissions? Lack of transportation (to or from clinical appointments),q=q15c,n=12);
%loop(title=How much of a challenge are each of the following patient factors in your hospital efforts to reduce readmissions? Mental health or substance abuse issues,q=q15d,n=12);

%loop(title=Can you think of other important challenges to reducing readmissions not mentioned above?,q=q16,n=2);
 proc freq data=temp2;
title "Q17.1";
weight wt;
tables recode_Q17_1 /missing  ;
run;
 proc freq data=temp2;
title "Q17.2";
weight wt;
tables recode_Q17_2 /missing  ;
run;
%loop(title=How great of an impact did the following federal policies have on your hospital focus on reducing readmissions? Public reporting of discharge planning on Hospital Compare (2004),q=q18a,n=18);
%loop(title=How great of an impact did the following federal policies have on your hospital focus on reducing readmissions? Public reporting of readmission rates on Hospital Compare (2010),q=q18b,n=18);
%loop(title=How great of an impact did the following federal policies have on your hospital focus on reducing readmissions? CMS penalties for hospitals with high readmission rates (2012),q=q18c,n=18);

%loop(title=How likely are hospitals to have the following responses to federal readmissions policies? Hospitals will increase their use of observation status to make it appear as if they are reducing readmissions,q=q19a,n=19);
%loop(title=How likely are hospitals to have the following responses to federal readmissions policies? Hospitals will avoid accepting high-risk patients in transfer because these patients will contribute to a higher readmission rate,q=q19b,n=19);

%loop(title=Do you think the magnitude of federal financial penalties for hospitals with excess readmissions is,q=q20,n=20);

%loop(title=How do you think the readmission penalties will impact the overall quality of healthcare that hospitals provide? ,q=q21,n=21);

%loop(title=How much do you agree with the following concerns regarding readmission penalties? Risk-adjusted readmission rates are not an accurate metric of the quality of care hospitals deliver,q=q22a,n=22);
%loop(title=How much do you agree with the following concerns regarding readmission penalties? Hospitals have no ability or a limited ability to impact ambulatory care delivered outside the hospital,q=q22b,n=22);
%loop(title=How much do you agree with the following concerns regarding readmission penalties? Hospitals have no ability or a limited ability to impact care delivered at nursing homes and rehabilitation facilities,q=q22c,n=22);
%loop(title=How much do you agree with the following concerns regarding readmission penalties? Hospitals have no ability or a limited ability to impact patients adherence to treatments,q=q22d,n=22);
%loop(title=How much do you agree with the following concerns regarding readmission penalties? The methods used to calculate the penalties don not account for differences in patients socioeconomic status,q=q22e,n=22);
%loop(title=How much do you agree with the following concerns regarding readmission penalties? The methods used to calculate the penalties don not adequately account for differences in patients medical complexity,q=q22f,n=22);

%loop(title=In your hospital- how great a priority are the following goals? Reducing 30day readmission rates,q=q23a,n=23);
%loop(title=In your hospital- how great a priority are the following goals? Improving compliance with guideline-based care,q=q23b,n=23);
%loop(title=In your hospital- how great a priority are the following goals? Reducing medical errors and improving patient safety,q=q23c,n=23);
%loop(title=In your hospital- how great a priority are the following goals? Reducing hospital-acquired infections,q=q23d,n=23);
%loop(title=In your hospital- how great a priority are the following goals? Improving patient experience,q=q23e,n=23);
%loop(title=In your hospital- how great a priority are the following goals? Meeting Meaningful Use requirements,q=q23f,n=23);

%loop(title=Is your hospital participating in the following initiatives for each type of payer? Medicare: Bundled Payment program,q=q24a1,n=8);
%loop(title=Is your hospital participating in the following initiatives for each type of payer? Medicare: Pioneer Accountable Care Organization or Shared Savings Program,q=q24b1,n=8);
%loop(title=Is your hospital participating in the following initiatives for each type of payer? Private Payers: Pay-for-Performance program,q=q24a2,n=8);
%loop(title=Is your hospital participating in the following initiatives for each type of payer? Private Payers: Bundled Payment program,q=q24b2,n=8);
%loop(title=Is your hospital participating in the following initiatives for each type of payer? Private Payers: Accountable Care Organization or Shared Savings Program or risk-based contract,q=q24c2,n=8);

%loop(title=Whether or not you are currently participating- do you feel that the following initiatives are likely to improve care or reduce costs? Federal Readmissions Penalty: Likely to improve care,q=Q25A1,n=8);
%loop(title=Whether or not you are currently participating- do you feel that the following initiatives are likely to improve care or reduce costs? Federal Readmissions Penalty: Likely to reduce costs,q=Q25A2,n=8);
%loop(title=Whether or not you are currently participating- do you feel that the following initiatives are likely to improve care or reduce costs? Pay-for-Performance programs: Likely to improve care,q=Q25B1,n=8);
%loop(title=Whether or not you are currently participating- do you feel that the following initiatives are likely to improve care or reduce costs? Pay-for-Performance programs: Likely to reduce costs,q=Q25B2,n=8);
%loop(title=Whether or not you are currently participating- do you feel that the following initiatives are likely to improve care or reduce costs? Bundled Payment programs: Likely to improve care,q=Q25C1,n=8);
%loop(title=Whether or not you are currently participating- do you feel that the following initiatives are likely to improve care or reduce costs? Bundled Payment programs: Likely to reduce costs,q=Q25C2,n=8);
%loop(title=Whether or not you are currently participating- do you feel that the following initiatives are likely to improve care or reduce costs? Accountable Care Organizations/Shared Savings Programs/risk-based contracts: Likely to improve care,q=Q25D1,n=8);
%loop(title=Whether or not you are currently participating- do you feel that the following initiatives are likely to improve care or reduce costs? Accountable Care Organizations/Shared Savings Programs/risk-based contracts: Likely to reduce costs,q=Q25D2,n=8);
 



