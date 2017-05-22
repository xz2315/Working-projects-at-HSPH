*************************
Mental Health
Xiner Zhou
4/17/2017
************************;
libname data 'D:\Projects\APCD Kids\Data';

proc import datafile="D:\Projects\APCD Kids\Document from Marit\MENTAL HEALTH" dbms=xlsx out=MH replace;getnames=yes;run;
proc sort data=MH nodupkey;by MULTI_LEVEL_CCS_DIAGNOSIS_LABEL2;run;
data MH;set MH;keep MULTI_LEVEL_CCS_DIAGNOSIS_LABEL2 Pure_psychiatry Developmental__broad_ Developmental__small_ ADHD;
proc print;run;

proc contents data=data.cci order=varnum;run;
/*
Obs MULTI_LEVEL_CCS_DIAGNOSIS_LABEL2 Pure_psychiatry Developmental__broad_ Developmental__small_ ADHD 
1 ''Delirium' 1 0 0 0 chronic_ccs_5_4
2 'Adjustment disorders [650]' 1 0 0 0 chronic_ccs_5_1
3 'Alcohol-related disorders [660]' 1 0 0 0 chronic_ccs_5_11
4 'Anxiety disorders [651]' 1 0 0 0 chronic_ccs_5_2
5 'Attention deficit disorder and Attention deficit hyperactivity disorder [6523]' 0 1 0 1 chronic_ccs_5_3_3
6 'Bipolar disorders [6571]' 1 0 0 0 chronic_ccs_5_8_1
7 'Codes related to mental health disorders [6631]' 1 0 0 0 chronic_ccs_5_14_1
8 'Codes related to substance-related disorders [6632]' 1 0 0 0  chronic_ccs_5_14_2
9 'Communication disorders [6541]' 0 1 1 0 chronic_ccs_5_5_1
10 'Conduct disorder [6521]' 1 0 0 0 chronic_ccs_5_3_1
11 'Depressive disorders [6572]' 1 0 0 0 chronic_ccs_5_8_2
12 'Developmental disabilities [6542]' 0 1 1 0 chronic_ccs_5_5_2
13 'Dissociative disorders [6701]' 1 0 0 0 chronic_ccs_5_15_1
14 'Eating disorders [6702]' 1 0 0 0 chronic_ccs_5_15_2
15 'Elimination disorders [6551]' 1 0 0 0 chronic_ccs_5_6_1
16 'Factitious disorders [6703]' 1 0 0 0 chronic_ccs_5_15_3
17 'Impulse control disorders not elsewhere classified [656]' 1 0 0 0 chronic_ccs_5_7
18 'Intellectual disabilities [6543]' 0 1 1 0 chronic_ccs_5_5_3
19 'Learning disorders [6544]' 0 1 1 0 chronic_ccs_5_5_4
20 'Mental disorders due to general medical conditions not elsewhere classified [6708]' 1 0 0 0 chronic_ccs_5_15_8
21 'Motor skill disorders [6545]' 0 1 1 0 chronic_ccs_5_5_5
22 'Oppositional defiant disorder [6522]' 1 0 0 0 chronic_ccs_5_3_2
23 'Other disorders of infancy childhood or adolescence [6552]' 0 1 1 0 chronic_ccs_5_6_2
24 'Other miscellaneous mental conditions [6709]' 1 0 0 0 chronic_ccs_5_15_9
25 'Personality disorders [658]' 1 0 0 0 chronic_ccs_5_9
26 'Pervasive developmental disorders [6553]' 0 1 1 0 chronic_ccs_5_6_3
27 'Psychogenic disorders [6704]' 1 0 0 0 chronic_ccs_5_15_4
28 'Schizophrenia and other psychotic disorders [659]' 1 0 0 0 chronic_ccs_5_10
29 'Sexual and gender identity disorders [6705]' 1 0 0 0 chronic_ccs_5_15_5
30 'Sleep disorders [6706]' 1 0 0 0 chronic_ccs_5_15_6
31 'Somatoform disorders [6707]' 1 0 0 0 chronic_ccs_5_15_7
32 'Substance-related disorders [661]' 1 0 0 0 chronic_ccs_5_12
33 'Suicide and intentional self-inflicted injury [662]' 1 0 0 0 
34 'Tic disorders [6554]' 0 1 1 0 chronic_ccs_5_6_4
*/
data data.cci_MH;
set data.cci;
Pure_psychiatry=0;Developmental_small=0;Developmental_broad=0; ADHD=0;
if chronic_ccs_5_4=1 then Pure_psychiatry=1;
if chronic_ccs_5_1=1 then Pure_psychiatry=1;
if chronic_ccs_5_11=1 then Pure_psychiatry=1;
if chronic_ccs_5_2=1 then Pure_psychiatry=1;

if chronic_ccs_5_3_3=1 then do;Developmental_broad=1; ADHD=1; end;
if chronic_ccs_5_8_1=1 then Pure_psychiatry=1;
if chronic_ccs_5_14_1=1 then Pure_psychiatry=1;
if chronic_ccs_5_14_2=1 then Pure_psychiatry=1;

if chronic_ccs_5_5_1=1 then do;Developmental_broad=1;Developmental_small=1; end;
if chronic_ccs_5_3_1=1 then Pure_psychiatry=1;
if chronic_ccs_5_8_2=1 then Pure_psychiatry=1;
if chronic_ccs_5_5_2=1 then do;Developmental_broad=1;Developmental_small=1; end;


if chronic_ccs_5_15_1=1 then Pure_psychiatry=1;
if chronic_ccs_5_15_2=1 then Pure_psychiatry=1;
if chronic_ccs_5_6_1=1 then Pure_psychiatry=1;
if chronic_ccs_5_15_3=1 then Pure_psychiatry=1;
if chronic_ccs_5_7=1 then Pure_psychiatry=1;


if chronic_ccs_5_5_3=1 then do;Developmental_broad=1;Developmental_small=1; end;
if chronic_ccs_5_5_4=1 then do;Developmental_broad=1;Developmental_small=1; end;
if chronic_ccs_5_15_8=1 then Pure_psychiatry=1;
if chronic_ccs_5_5_5=1 then do;Developmental_broad=1;Developmental_small=1; end;
if chronic_ccs_5_3_2=1 then Pure_psychiatry=1;
if chronic_ccs_5_6_2=1 then do;Developmental_broad=1;Developmental_small=1; end;
if chronic_ccs_5_15_9=1 then Pure_psychiatry=1;
if chronic_ccs_5_9=1 then Pure_psychiatry=1;
if chronic_ccs_5_6_3=1 then do;Developmental_broad=1;Developmental_small=1; end;
if chronic_ccs_5_15_4=1 then Pure_psychiatry=1;
if chronic_ccs_5_10=1 then Pure_psychiatry=1;
if chronic_ccs_5_15_5=1 then Pure_psychiatry=1;
if chronic_ccs_5_15_6=1 then Pure_psychiatry=1;
if chronic_ccs_5_15_7=1 then Pure_psychiatry=1;
if chronic_ccs_5_12=1 then Pure_psychiatry=1;
if chronic_ccs_5_6_4=1 then do;Developmental_broad=1;Developmental_small=1; end;
run;
