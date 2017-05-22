*****************************************************************************
Create and Save HC Cancer sample (NO Demog/Cost/Util included in this step)
Xiner Zhou
1/31/2017
*****************************************************************************;

libname data 'I:\Projects\High Cost Segmentation Phase II\Data';
libname denom 'C:\data\Data\Medicare\Denominator';
libname stdcost 'C:\data\Data\Medicare\StdCost\Data';



* Select 20% Sample;
data temp1;
set stdcost.Patienttotalcost2014;

/*
All patients

>=65
Exclude if part of HMO
Must be enrolled in Part A&B all 12 months or until DOD
*/
if age<65 then delete1=1;
if HMO=1 then delete2=1;
if fullAB=0 then delete3=1;

/* 20% Sample */
if STRCTFLG='' then delete4=1;

run;
 

* Link cancer identifiers;
proc sql;
create table temp2 as
select a.*,b.*
from temp1 a left join data.Cancerbene2014 b
on a.bene_id =b.bene_id  ;
quit;

proc contents data=temp2;run;

data temp3;
set temp2;
array temp {37} Site_Specific_1 Site_Specific_2 Site_Specific_3 Site_Specific_4 Site_Specific_5 Site_Specific_6 Site_Specific_7
Site_Specific_8 Site_Specific_9 Site_Specific_10 Site_Specific_11 Site_Specific_12 Site_Specific_13 Site_Specific_14 Site_Specific_15
Site_Specific_3_1 Site_Specific_3_2 Site_Specific_3_3 Site_Specific_3_4 Site_Specific_3_5 Site_Specific_3_6 Site_Specific_3_7 Site_Specific_3_8
Site_Specific_4_1 Site_Specific_4_2 Site_Specific_4_3 Site_Specific_4_4 Site_Specific_4_5 Site_Specific_4_6 Site_Specific_4_7
Site_Specific_5_1 Site_Specific_5_2 Site_Specific_5_3 Site_Specific_5_4
Site_Specific_9_1 Site_Specific_9_2 N_Cancer;

do i=1 to 37;
if temp{i}=. then temp{i}=0;
end;drop i;

* Exclude those with non-melanoma skin cancer diagnosis ONLY (if with another diagnosis below, will be listed under that cancer type);
if Site_Specific_14=1 and N_Cancer=1 then delete5=1;
run;


*****************************************
Make a flow-chart for sample decreasing
*****************************************;
*>=65;
data temp4;
set temp3;
if delete1=.;
run;
*Exclude if part of HMO;
data temp5;
set temp4;
if delete2=.;
run;
*Must be enrolled in Part A&B all 12 months or until DOD;
data temp6;
set temp5;
if delete3=.;
run;
*20% sample;
data temp7;
set temp6;
if delete4=.;
run;
*Exclude those with non-melanoma skin cancer diagnosis ONLY (if with another diagnosis below, will be listed under that cancer type);
data temp8;
set temp7;
if delete5=.;
run;


/*
Patients with multiple cancers were classified into mutually exclusive primary cancer diagnoses according to a hierarchy below

1.Lung
2.Hematologic malignancies (Lymphoma, Leukemia, Multiple Myeloma)
3.GI
4.Breast
5.GU
6.Gyn
7.H and N
8.Sarcoma
9.Melanoma
10.CNS
11.Mets & Other

*/
data temp9;
length cancerH $30. moreCancer $30.;
set temp8;

cancer1=0;cancer2=0;cancer3=0;cancer4=0;cancer5=0;cancer6=0;cancer7=0;cancer8=0;cancer9=0;cancer10=0;cancer11=0;
if Site_Specific_7=1 then do;CancerH="Hierarchy 1 : Lung";Cancer1=1;end;
else if Site_Specific_8=1 or Site_Specific_12=1 or Site_Specific_15=1 then do;CancerH="Hierarchy 2 : Hematologic malignancies (Lymphoma, Leukemia, Multiple Myeloma)";Cancer2=1;end;
else if Site_Specific_3=1 then do;CancerH="Hierarchy 3 : GI";Cancer3=1;end;
else if Site_Specific_1=1 then do;CancerH="Hierarchy 4 : Breast";Cancer4=1;end;
else if Site_Specific_4=1 then do;CancerH="Hierarchy 5 : GU";Cancer5=1;end;
else if Site_Specific_5=1 then do;CancerH="Hierarchy 6 : Gyn";Cancer6=1;end;
else if Site_Specific_6=1 then do;CancerH="Hierarchy 7 : H and N";Cancer7=1;end;
else if Site_Specific_9=1 then do;CancerH="Hierarchy 8 : Sarcoma";Cancer8=1;end;
else if Site_Specific_13=1 then do;CancerH="Hierarchy 9 : Melanoma";Cancer9=1;end;
else if Site_Specific_2=1 then do;CancerH="Hierarchy 10: CNS";Cancer10=1;end;
else if Site_Specific_11=1 or Site_Specific_10=1 then do;CancerH="Hierarchy 11: Mets & Other";Cancer11=1;end;
else CancerH="NO Cancer";

/*
How many people were shifted?
If people had more than one dx of cancer (1-10 overlapping). Okay if they have 11 with any of the others (1-10)
*/
if Site_Specific_7+Site_Specific_8+Site_Specific_12+Site_Specific_15+Site_Specific_3
+Site_Specific_1+Site_Specific_4+Site_Specific_5+Site_Specific_6+Site_Specific_9+Site_Specific_13+Site_Specific_2>1 then moreCancer="had more than one dx of cancer (1-10 overlapping)";
else if (Site_Specific_7=1 or Site_Specific_8=1 or Site_Specific_12=1 or Site_Specific_15=1 or Site_Specific_3=1 or 
Site_Specific_1=1 or Site_Specific_4=1 or Site_Specific_5=1 or Site_Specific_6=1 or Site_Specific_9=1 or Site_Specific_13=1 or Site_Specific_2=1) and (Site_Specific_11=1 or Site_Specific_10=1)
then moreCancer='have 11 with any of the others (1-10)';
else moreCancer="No shift";

proc freq;tables cancer1-cancer11 CancerH morecancer/missing;
run;
 


* Define HC  ;
proc rank data=temp9 out=temp10 percent;
var   stdcost;
ranks  pct_stdcost;
run;

data data.CancerHCsample2014;
set temp10;
 if pct_stdcost>=90  then HC10 =1;else HC10 =0;
proc freq;
tables HC10 /missing;
run;
 



