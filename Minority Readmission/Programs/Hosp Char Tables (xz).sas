****************************
Hospital Characteristics Table
Xiner Zhou
3/5/2015
*****************************;
libname data 'C:\data\Projects\Minority_Readmissions\Data';

proc format;
value teaching_
1='Major teaching'
2='Minor teaching'
3='Non-Teaching'
;
run;
proc format;
value profit2_
1='Investor Owned, For-Profit'
2='Non-Government, Not-For-Profit'
3='Government, Non-Federal'
4='Government, Federal'
;
run;
proc format ;
value hospsize_
1='Small [1-99 beds]'
2='Medium [100-399 beds]'
3='Large [400+ beds]'
;
run;
proc format;
value hosp_reg4_
1='North East'
2='Midwest'
3='South'
4='West'
;
run;
*Rural-Urban Commuting Area (RUCA) ;
proc format;
value ruca_level_
1='Urban'
2='Suburban'
3='Large Rural Town'
4='Small Town/Isolated Rural'
;
run;
proc format ;
value $CICU_
1='Hospital has CICU'
0='Hospital has NO CICU'
;
run;
proc format ;
value SNH_
1='Safety Net Hospital'
0='Not'
;
run;
proc format ;
value quality_
1='Q1(Lowest Readmission)'
2='Q2-4'
3='Q5(Highest Readmission)';
run;

title "Table0: Respondents vs non-Respondents";
data temp;
set data.denominator;
if q1_1 ne . then respond=1;else respond=0;
run;
proc freq data=temp;
format teaching teaching_.;format profit2 profit2_.;format hospsize hospsize_.;format hosp_reg4 hosp_reg4_.;format ruca_level ruca_level_.;
format CICU $CICU_.;format SNH SNH_.;format quality quality_.;
table teaching*respond profit2*respond hospsize*respond hosp_reg4*respond ruca_level*respond cicu*respond /nocum norow nopercent  chisq  ;
run;
 
%macro anova(var=);
proc means data=temp mean std median min max;
class respond ;
var &var. ;
run;
proc anova data=temp;
class  respond;
model &var.= respond;
run;
%mend anova;
%anova(var=propblk);
%anova(var=prophisp);
%anova(var=p_medicare);
%anova(var=p_medicaid);
%anova(var=dshpct);
%anova(var=total_margin);
%anova(var=readm);




title "Table1: MSH";
proc freq data=data.survey_analytic  ;
format teaching teaching_.;format profit2 profit2_.;format hospsize hospsize_.;format hosp_reg4 hosp_reg4_.;format ruca_level ruca_level_.;
format CICU $CICU_.;format SNH SNH_.;format quality quality_.;
table teaching*group profit2*group hospsize*group hosp_reg4*group ruca_level*group cicu*group /nocum norow nopercent  chisq ;
run;
 
%macro anova(var=);
proc means data=data.survey_analytic mean std median min max;
class group;
var &var. ;
run;
proc anova data=data.survey_analytic;
class group;
model &var.=group;
run;
%mend anova;
%anova(var=propblk);
%anova(var=prophisp);
%anova(var=p_medicare);
%anova(var=p_medicaid);
%anova(var=dshpct);
%anova(var=total_margin);
%anova(var=readm);


title "Table1.1: 2-group MSH";
proc freq data=data.survey_analytic  ;
format teaching teaching_.;format profit2 profit2_.;format hospsize hospsize_.;format hosp_reg4 hosp_reg4_.;format ruca_level ruca_level_.;
format CICU $CICU_.;format SNH SNH_.;format quality quality_.;
table teaching*group_num0 profit2*group_num0  hospsize*group_num0  hosp_reg4*group_num0  ruca_level*group_num0  cicu*group_num0  / nocum norow nopercent  chisq ;
run;
 
%macro anova(var=);
proc means data=data.survey_analytic mean std median min max;
class group_num0 ;
var &var. ;
run;
proc anova data=data.survey_analytic;
class group_num0;
model &var.=group_num0;
run;
%mend anova;
%anova(var=propblk);
%anova(var=prophisp);
%anova(var=p_medicare);
%anova(var=p_medicaid);
%anova(var=dshpct);
%anova(var=total_margin);
%anova(var=readm);




title "Table2: SNH";
proc freq data=data.survey_analytic  ;
format teaching teaching_.;format profit2 profit2_.;format hospsize hospsize_.;format hosp_reg4 hosp_reg4_.;format ruca_level ruca_level_.;
format CICU $CICU_.;format SNH SNH_.;format quality quality_.;
table teaching*SNH profit2*SNH hospsize*SNH hosp_reg4*SNH ruca_level*SNH cicu*SNH /nocum norow nopercent  chisq ;
run;
 
%macro anova(var=);
proc means data=data.survey_analytic mean std median min max;
class SNH;
var &var. ;
run;
proc anova data=data.survey_analytic;
class SNH;
model &var.=SNH;
run;
%mend anova;
%anova(var=propblk);
%anova(var=prophisp);
%anova(var=p_medicare);
%anova(var=p_medicaid);
%anova(var=dshpct);
%anova(var=total_margin);
%anova(var=readm);
 
 


title "Table3: Readmission";
proc freq data=data.survey_analytic  ;
format teaching teaching_.;format profit2 profit2_.;format hospsize hospsize_.;format hosp_reg4 hosp_reg4_.;format ruca_level ruca_level_.;
format CICU $CICU_.;format SNH SNH_.;format quality quality_.;
table teaching*quality profit2*quality hospsize*quality hosp_reg4*quality ruca_level*quality cicu*quality /nocum norow nopercent  chisq ;
run;
 
%macro anova(var=);
proc means data=data.survey_analytic mean std median min max;
class quality;
var &var. ;
run;
proc anova data=data.survey_analytic;
class quality;
model &var.=quality;
run;
%mend anova;
%anova(var=propblk);
%anova(var=prophisp);
%anova(var=p_medicare);
%anova(var=p_medicaid);
%anova(var=dshpct);
%anova(var=total_margin);
%anova(var=readm);
 
 
title "Table3.1: Readmission";
proc freq data=data.survey_analytic  ;
where group_num in(1,2);
format teaching teaching_.;format profit2 profit2_.;format hospsize hospsize_.;format hosp_reg4 hosp_reg4_.;format ruca_level ruca_level_.;
format CICU $CICU_.;format SNH SNH_.;format quality quality_.;
table teaching*quality profit2*quality hospsize*quality hosp_reg4*quality ruca_level*quality cicu*quality /nocum norow nopercent  chisq  ;
run;
 
%macro anova(var=);
proc means data=data.survey_analytic mean std median min max;
where group_num in(1,2);
class quality;
var &var. ;
run;
proc anova data=data.survey_analytic;
where group_num in(1,2);
class quality;
model &var.=quality;
run;
%mend anova;
%anova(var=propblk);
%anova(var=prophisp);
%anova(var=p_medicare);
%anova(var=p_medicaid);
%anova(var=dshpct);
%anova(var=total_margin);
%anova(var=readm);




title "Table4: Readmission Penalty";
proc freq data=data.survey_analytic  ;
format teaching teaching_.;format profit2 profit2_.;format hospsize hospsize_.;format hosp_reg4 hosp_reg4_.;format ruca_level ruca_level_.;
format CICU $CICU_.;format SNH SNH_.;format quality quality_.;
table teaching*penaltygroup profit2*penaltygroup hospsize*penaltygroup hosp_reg4*penaltygroup ruca_level*penaltygroup cicu*penaltygroup / nocum norow nopercent  chisq ;
run;
 
%macro anova(var=);
proc means data=data.survey_analytic mean std median min max;
class penaltygroup;
var &var. ;
run;
proc anova data=data.survey_analytic;
class penaltygroup;
model &var.=penaltygroup;
run;
%mend anova;
%anova(var=propblk);
%anova(var=prophisp);
%anova(var=p_medicare);
%anova(var=p_medicaid);
%anova(var=dshpct);
%anova(var=total_margin);
%anova(var=readm);
%anova(var=penalty);

 
