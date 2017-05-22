****************************************
Create typical Characteristics Table
Xiner Zhou
9/11/2014
***************************************;

 
data hospital;
set hospital;
if type in (2,3,4) then eligibility=0;else eligibility=1;
run;

 
* Hospsize;
proc freq data=hospital ;
table hospsize * eligibility/nocum norow chisq out=temp outpct ;
run;
data temp;
set temp;
num=count||' ('||trim(put(pct_col,5.2))||'%)';
drop count percent pct_row pct_col;
run;
proc transpose data=temp out=hospsize;
by hospsize;
var num;
run;
 

* region;
proc freq data=hospital ;
table hosp_reg4 * eligibility/nocum norow chisq out=temp outpct ;
run;
data temp;
set temp;
num=count||' ('||trim(put(pct_col,5.2))||'%)';
drop count percent pct_row pct_col;
run;
proc transpose data=temp out=hosp_reg4 ;
by hosp_reg4 ;
var num;
run;
 
* Teaching;
proc freq data=hospital ;
table Teaching * eligibility/nocum norow chisq out=temp outpct ;
run;
data temp;
set temp;
num=count||' ('||trim(put(pct_col,5.2))||'%)';
drop count percent pct_row pct_col;
run;
proc transpose data=temp out=Teaching ;
by Teaching ;
var num;
run;

* Profit;
proc freq data=hospital ;
table profit2 * eligibility/nocum norow chisq out=temp outpct ;
run;
data temp;
set temp;
num=count||' ('||trim(put(pct_col,5.2))||'%)';
drop count percent pct_row pct_col;
run;
proc transpose data=temp out=profit2;
by profit2;
var num;
run;

* Ruca_level;
proc freq data=hospital ;
table Ruca_level * eligibility/nocum norow chisq out=temp outpct ;
run;
data temp;
set temp;
num=count||' ('||trim(put(pct_col,5.2))||'%)';
drop count percent pct_row pct_col;
run;
proc transpose data=temp out=Ruca_level;
by Ruca_level;
var num;
run;

* System;
proc freq data=hospital ;
table System* eligibility/nocum norow chisq out=temp outpct ;
run;
data temp;
set temp;
num=count||' ('||trim(put(pct_col,5.2))||'%)';
drop count percent pct_row pct_col;
run;
proc transpose data=temp out=System;
by System;
var num;
run;


*p-medicaid;
proc means data=hospital;
class eligibility;
var p_medicaid;
run;

proc glm data=hospital;
class eligibility;
model p_medicaid=eligibility;
run;

******output;

ods _all_ close;
ods tagsets.ExcelXP path='C:\data\Projects\HIT EHR Adoption' file='table1.xml' style=Printer;
proc print data=hospsize;run;
proc print data=hosp_reg4;run;
proc print data=teaching;run;
proc print data=profit2;run;
proc print data=Ruca_level;run;
proc print data=System;run;
ods tagsets.ExcelXP close;
 
