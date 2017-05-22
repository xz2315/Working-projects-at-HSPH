**********************
QCOR--Compareison
Xiner Zhou
2/3/2015
**********************;

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

* Delete critical, LTAC, children's;
data deletethem;
set denominator;
if substr(medicare_id,3,2) in ('13','20','21','22','33');
run;
proc sql;
create table survey1 as
select *
from survey
where hsph_id not in (select hsph_id from deletethem);
quit;


* Link with 2010 AHA, rank MSHs by %black, let 360(I think should be 356) be top 10%;
data MSH nonMSH;
set denominator;
if designation='MSH' then output MSH;else output nonMSH;
run;

proc sql;
create table MSHAHA10 as
select a.*,b.propblk10 
from MSH a left join aha.aha10 b
on a.medicare_id=b.provider;
quit;
data try MSHAHA;
set mshaha10;
if propblk10 =. then output try;else output MSHAHA;
run;

proc sql;
create table try1 as
select a.*,b.propblk12
from try a left join aha.aha12 b
on a.medicare_id=b.provider;
quit;
proc sql;
create table try2 as
select a.*,b.propblk11
from try1 a left join aha.aha11 b
on a.medicare_id=b.provider;
quit;
proc sql;
create table try3 as
select a.*,b.propblk10
from try2 a left join aha.aha10 b
on a.medicare_id=b.provider;
quit;
proc sql;
create table try4 as
select a.*,b.propblk09
from try3 a left join aha.aha09 b
on a.medicare_id=b.provider;
quit;
 
data try;
set try4;
if propblk11 ne . then propblk10=propblk11;
else if propblk12 ne . then propblk10=propblk12;
else if propblk09 ne . then propblk10=propblk09;
run;

data MSH;
set MSHAHA try;
drop propblk11 propblk12 propblk09;
run;

proc sort data=MSH;by descending propblk10;run;

data MSH;
length group $30.;
set MSH;
if _n_<=356 then group='Top 10%';
else group='Top 10-25%';
run;

data nonMSH;
length group $30.;
set nonMSH;
group='non-MSH';
run;

data denominator;
set MSH nonMSH;
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
set survey1;
if var3='Non-MSH Q1' then var3='Q1';
if var3='Non-MSH Q2-4' then var3='Q2-4';
if var3='Non-MSH Q5' then var3='Q5';

if q16=. then q16=9;
if q18a=. then q18a=9;

if medid='140234' then hsph_id='R00211a';
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
select a.medicare_id, a.group,a.Hospital_Name,a.urban,a.profit2,a.teaching, a.hospsize, a.hosp_reg4, a.CICU, a.mhsmemb, b.*
from denominator a full join survey  b
on a.hsph_id=b.hsph_id;
quit;

data temp;
set temp;
if Q1_1=. then respond=0;else respond=1;
if mhsmemb=. then mhsmemb=3;
if cicu=. then cicu=3;
run;

 
 
proc logistic data=temp  noprint ;
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
* iMPROVED SIGNIFICANTLY;

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
*always;

proc format ;
value question8_
1=YES
2=NO
8=MULTIPLE MARKS
9=MISSING
;
run;
*yes;
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
*GREAT CHALLENGE;

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
*GREAT IMPACT;

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
*EXTREMELY LIKELY;

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
*MUCH TOO LARGE;

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
/*
CARE WILL IMPROVE SOMEWHAT
5=CARE WILL IMPROVE A GREAT DEAL
*/

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
*AGREE STRONGLY;

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




ods listing gpath="C:\data\Projects\APCD Readmission\Output";
%macro Q2(q=);

data temp3;
set temp2;
if &q. =1 then temp='YES';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','Top 10-25%');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','non-MSH');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10-25%','non-MSH');
tables temp*group/chisq norow nopercent;run;
%mend Q2;
%Q2(q=q2a);
%Q2(q=q2b);
%Q2(q=q2c);

%macro Q3(q=);

data temp3;
set temp2;
if &q. =1 then temp='YES';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','Top 10-25%');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','non-MSH');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10-25%','non-MSH');
tables temp*group/chisq norow nopercent;run;
%mend Q3;
%Q3(q=q3a);
%Q3(q=q3b);
%Q3(q=q3c);
%Q3(q=q3d);
%Q3(q=q3e);

%macro Q4(q=);

data temp3;
set temp2;
if &q. =1 then temp='YES';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','Top 10-25%');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','non-MSH');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10-25%','non-MSH');
tables temp*group/chisq norow nopercent;run;
%mend Q4;
%Q4(q=q4a);
%Q4(q=q4b);
%Q4(q=q4c);
%Q4(q=q4d);


%macro Q5(q=);

data temp3;
set temp2;
if &q. =3 then temp='Higher than average';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','Top 10-25%');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','non-MSH');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10-25%','non-MSH');
tables temp*group/chisq norow nopercent;run;
%mend Q5;
%Q5(q=q5);


%macro Q6(q=);

data temp3;
set temp2;
if &q. =1 then temp='IMPROVED SIGNIFICANTLY';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','Top 10-25%');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','non-MSH');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10-25%','non-MSH');
tables temp*group/chisq norow nopercent;run;
%mend Q6;
%Q6(q=q6);

%macro Q7(q=);

data temp3;
set temp2;
if &q. in (1,2) then temp='Always or Usual';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','Top 10-25%');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','non-MSH');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10-25%','non-MSH');
tables temp*group/chisq norow nopercent;run;
%mend Q7;
%Q7(q=q7a);
%Q7(q=q7b);
%Q7(q=q7c);
%Q7(q=q7d);
%Q7(q=q7e);
%Q7(q=q7f);
%Q7(q=q7g);
%Q7(q=q7h);
%Q7(q=q7i);
%Q7(q=q7j);
%Q7(q=q7k);
%Q7(q=q7l);
%Q7(q=q7m);


%macro Q8(q=);

data temp3;
set temp2;
if &q. =1 then temp='YES';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','Top 10-25%');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','non-MSH');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10-25%','non-MSH');
tables temp*group/chisq norow nopercent;run;
%mend Q8;
%Q8(q=q8a);
%Q8(q=q8b);
%Q8(q=q8c);
%Q8(q=q8d);
%Q8(q=q8e);
%Q8(q=q8f);
%Q8(q=q8g);
%Q8(q=q8h);
%Q8(q=q8i);
%Q8(q=q8j);
%Q8(q=q8k);
%Q8(q=q8l);
%Q8(q=q8m);


%macro Q10(q=);

data temp3;
set temp2;
if &q. =1 then temp='YES';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','Top 10-25%');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','non-MSH');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10-25%','non-MSH');
tables temp*group/chisq norow nopercent;run;
%mend Q10;
%Q10(q=q10);


%macro Q11(q=);

data temp3;
set temp2;
if &q. =1 then temp='YES';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','Top 10-25%');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','non-MSH');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10-25%','non-MSH');
tables temp*group/chisq norow nopercent;run;
%mend Q11;
%Q11(q=q11a);
%Q11(q=q11b);
%Q11(q=q11c);
%Q11(q=q11d);


%macro Q12(q=);

data temp3;
set temp2;
if &q. in (4,5) then temp='4+Great challenge';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','Top 10-25%');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','non-MSH');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10-25%','non-MSH');
tables temp*group/chisq norow nopercent;run;
%mend Q12;
%Q12(q=q12a);
%Q12(q=q12b);
%Q12(q=q12c);
%Q12(q=q12d);
%Q12(q=q12e);
%Q12(q=q12f);
%Q12(q=q12g);
%Q12(q=q12h);

%macro Q13(q=);

data temp3;
set temp2;
if &q. in (4,5) then temp='4+Great challenge';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','Top 10-25%');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','non-MSH');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10-25%','non-MSH');
tables temp*group/chisq norow nopercent;run;
%mend Q13;
%Q13(q=q13a);
%Q13(q=q13b);

%macro Q14(q=);

data temp3;
set temp2;
if &q. in (4,5) then temp='4+Great challenge';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','Top 10-25%');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','non-MSH');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10-25%','non-MSH');
tables temp*group/chisq norow nopercent;run;
%mend Q14;
%Q14(q=q14a);
%Q14(q=q14b);
%Q14(q=q14c);
%Q14(q=q14d);

%macro Q15(q=);

data temp3;
set temp2;
if &q. in (4,5) then temp='4+Great challenge';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','Top 10-25%');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','non-MSH');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10-25%','non-MSH');
tables temp*group/chisq norow nopercent;run;
%mend Q15;
%Q15(q=q15a);
%Q15(q=q15b);
%Q15(q=q15c);
%Q15(q=q15d);


%macro Q16(q=);

data temp3;
set temp2;
if &q. =1 then temp='YES';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','Top 10-25%');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','non-MSH');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10-25%','non-MSH');
tables temp*group/chisq norow nopercent;run;
%mend Q16;
%Q16(q=q16);


%macro Q18(q=);

data temp3;
set temp2;
if &q. in (4,5) then temp='4+Great Impact';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','Top 10-25%');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','non-MSH');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10-25%','non-MSH');
tables temp*group/chisq norow nopercent;run;
%mend Q18;
%Q18(q=q18a);
%Q18(q=q18b);
%Q18(q=q18c);

%macro Q19(q=);

data temp3;
set temp2;
if &q. in (4,5) then temp='4+Extremely Likely';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','Top 10-25%');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','non-MSH');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10-25%','non-MSH');
tables temp*group/chisq norow nopercent;run;
%mend Q19;

%Q19(q=q19a);
%Q19(q=q19b);


%macro Q20(q=);

data temp3;
set temp2;
if &q. in (4,5) then temp='Too Large+Much Too Large';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','Top 10-25%');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','non-MSH');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10-25%','non-MSH');
tables temp*group/chisq norow nopercent;run;
%mend Q20;
%Q20(q=q20);


%macro Q21(q=);

data temp3;
set temp2;
if &q. in (4,5) then temp='care will improve somewhat + care will improve a great deal';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','Top 10-25%');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','non-MSH');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10-25%','non-MSH');
tables temp*group/chisq norow nopercent;run;
%mend Q21;
%Q21(q=q21);
 

%macro Q22(q=);

data temp3;
set temp2;
if &q. in (4,5) then temp='Agree or Agree Stronly';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','Top 10-25%');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','non-MSH');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10-25%','non-MSH');
tables temp*group/chisq norow nopercent;run;
%mend Q22;
%Q22(q=q22a);
%Q22(q=q22b);
%Q22(q=q22c);
%Q22(q=q22d);
%Q22(q=q22e);
%Q22(q=q22f);

%macro Q23(q=);

data temp3;
set temp2;
if &q. in (9,10) then temp='9+Highest Priority';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','Top 10-25%');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','non-MSH');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10-25%','non-MSH');
tables temp*group/chisq norow nopercent;run;
%mend Q23;

%Q23(q=q23a);
%Q23(q=q23b);
%Q23(q=q23c);
%Q23(q=q23d);
%Q23(q=q23e);
%Q23(q=q23f);


%macro Q24(q=);

data temp3;
set temp2;
if &q. =1 then temp='YES';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','Top 10-25%');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','non-MSH');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10-25%','non-MSH');
tables temp*group/chisq norow nopercent;run;
%mend Q24;
%Q24(q=q24a1);
%Q24(q=q24b1);
%Q24(q=q24a2);
%Q24(q=q24c2);


%macro Q25(q=);

data temp3;
set temp2;
if &q. =1 then temp='YES';else temp='Others';
run;
proc freq data=temp3;
title "&q.";
weight wt;
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','Top 10-25%');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10%','non-MSH');
tables temp*group/chisq norow nopercent;run;
proc freq data=temp3;
title "&q.";
weight wt;
where group in ('Top 10-25%','non-MSH');
tables temp*group/chisq norow nopercent;run;
%mend Q25;
%Q25(q=q25a1);
%Q25(q=q25a2);
%Q25(q=q25b1);
%Q25(q=q25b2);
%Q25(q=q25c1);
%Q25(q=q25c2);
%Q25(q=q25d1);
%Q25(q=q25d2);
