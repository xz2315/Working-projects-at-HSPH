***************************************
Identify Cancer Patient for Miranda Lam
Xiner Zhou
12/5/2016
***************************************;


libname denom 'D:\Data\Medicare\Denominator';
libname OP 'D:\Data\Medicare\Outpatient';
libname Carrier 'D:\Data\Medicare\Carrier';
libname HHA 'D:\Data\Medicare\HHA';
libname HOSPICE 'D:\Data\Medicare\Hospice';
libname SNF 'D:\Data\Medicare\SNF';
libname DME 'D:\Data\Medicare\DME';
libname IP 'D:\Data\Medicare\Inpatient';
libname frail 'D:\Data\Medicare\Frailty Indicator';
libname HCC 'D:\Projects\Peterson';
libname cancer 'D:\Projects\High Cost Segmentation Phase II\Data';

data clm;
set IP.Inptclms2014(keep=bene_id PRNCPAL_DGNS_CD ICD_DGNS_CD1 ICD_DGNS_CD2 ICD_DGNS_CD3 ICD_DGNS_CD4 ICD_DGNS_CD5 
                                                 ICD_DGNS_CD6 ICD_DGNS_CD7 ICD_DGNS_CD8 ICD_DGNS_CD9 ICD_DGNS_CD10
												 ICD_DGNS_CD11 ICD_DGNS_CD12 ICD_DGNS_CD13 ICD_DGNS_CD14 ICD_DGNS_CD15
												 ICD_DGNS_CD16 ICD_DGNS_CD17 ICD_DGNS_CD18 ICD_DGNS_CD19 ICD_DGNS_CD20
												 ICD_DGNS_CD21 ICD_DGNS_CD22 ICD_DGNS_CD23 ICD_DGNS_CD24 ICD_DGNS_CD25)
	OP.Otptclms2014(keep=bene_id PRNCPAL_DGNS_CD ICD_DGNS_CD1 ICD_DGNS_CD2 ICD_DGNS_CD3 ICD_DGNS_CD4 ICD_DGNS_CD5 
                                                 ICD_DGNS_CD6 ICD_DGNS_CD7 ICD_DGNS_CD8 ICD_DGNS_CD9 ICD_DGNS_CD10
												 ICD_DGNS_CD11 ICD_DGNS_CD12 ICD_DGNS_CD13 ICD_DGNS_CD14 ICD_DGNS_CD15
												 ICD_DGNS_CD16 ICD_DGNS_CD17 ICD_DGNS_CD18 ICD_DGNS_CD19 ICD_DGNS_CD20
												 ICD_DGNS_CD21 ICD_DGNS_CD22 ICD_DGNS_CD23 ICD_DGNS_CD24 ICD_DGNS_CD25)
	Carrier.Bcarclms2014(keep=bene_id PRNCPAL_DGNS_CD ICD_DGNS_CD1 ICD_DGNS_CD2 ICD_DGNS_CD3 ICD_DGNS_CD4 ICD_DGNS_CD5 
                                                 ICD_DGNS_CD6 ICD_DGNS_CD7 ICD_DGNS_CD8 ICD_DGNS_CD9 ICD_DGNS_CD10
												 ICD_DGNS_CD11 ICD_DGNS_CD12  )
	HHA.Hhaclms2014(keep=bene_id PRNCPAL_DGNS_CD ICD_DGNS_CD1 ICD_DGNS_CD2 ICD_DGNS_CD3 ICD_DGNS_CD4 ICD_DGNS_CD5 
                                                 ICD_DGNS_CD6 ICD_DGNS_CD7 ICD_DGNS_CD8 ICD_DGNS_CD9 ICD_DGNS_CD10
												 ICD_DGNS_CD11 ICD_DGNS_CD12 ICD_DGNS_CD13 ICD_DGNS_CD14 ICD_DGNS_CD15
												 ICD_DGNS_CD16 ICD_DGNS_CD17 ICD_DGNS_CD18 ICD_DGNS_CD19 ICD_DGNS_CD20
												 ICD_DGNS_CD21 ICD_DGNS_CD22 ICD_DGNS_CD23 ICD_DGNS_CD24 ICD_DGNS_CD25)
	Hospice.Hspcclms2014(keep=bene_id PRNCPAL_DGNS_CD ICD_DGNS_CD1 ICD_DGNS_CD2 ICD_DGNS_CD3 ICD_DGNS_CD4 ICD_DGNS_CD5 
                                                 ICD_DGNS_CD6 ICD_DGNS_CD7 ICD_DGNS_CD8 ICD_DGNS_CD9 ICD_DGNS_CD10
												 ICD_DGNS_CD11 ICD_DGNS_CD12 ICD_DGNS_CD13 ICD_DGNS_CD14 ICD_DGNS_CD15
												 ICD_DGNS_CD16 ICD_DGNS_CD17 ICD_DGNS_CD18 ICD_DGNS_CD19 ICD_DGNS_CD20
												 ICD_DGNS_CD21 ICD_DGNS_CD22 ICD_DGNS_CD23 ICD_DGNS_CD24 ICD_DGNS_CD25)
	SNF.Snfclms2014(keep=bene_id PRNCPAL_DGNS_CD ICD_DGNS_CD1 ICD_DGNS_CD2 ICD_DGNS_CD3 ICD_DGNS_CD4 ICD_DGNS_CD5 
                                                 ICD_DGNS_CD6 ICD_DGNS_CD7 ICD_DGNS_CD8 ICD_DGNS_CD9 ICD_DGNS_CD10
												 ICD_DGNS_CD11 ICD_DGNS_CD12 ICD_DGNS_CD13 ICD_DGNS_CD14 ICD_DGNS_CD15
												 ICD_DGNS_CD16 ICD_DGNS_CD17 ICD_DGNS_CD18 ICD_DGNS_CD19 ICD_DGNS_CD20
												 ICD_DGNS_CD21 ICD_DGNS_CD22 ICD_DGNS_CD23 ICD_DGNS_CD24 ICD_DGNS_CD25)
	DME.Dmeclms2014(keep=bene_id PRNCPAL_DGNS_CD ICD_DGNS_CD1 ICD_DGNS_CD2 ICD_DGNS_CD3 ICD_DGNS_CD4 ICD_DGNS_CD5 
                                                 ICD_DGNS_CD6 ICD_DGNS_CD7 ICD_DGNS_CD8 ICD_DGNS_CD9 ICD_DGNS_CD10
												 ICD_DGNS_CD11 ICD_DGNS_CD12  );
icd=PRNCPAL_DGNS_CD;output;
icd=ICD_DGNS_CD1;output;
icd=ICD_DGNS_CD2;output;
icd=ICD_DGNS_CD3;output;
icd=ICD_DGNS_CD4;output;
icd=ICD_DGNS_CD5;output;
icd=ICD_DGNS_CD6;output;
icd=ICD_DGNS_CD7;output;
icd=ICD_DGNS_CD8;output;
icd=ICD_DGNS_CD9;output;
icd=ICD_DGNS_CD10;output;
icd=ICD_DGNS_CD11;output;
icd=ICD_DGNS_CD12;output;
icd=ICD_DGNS_CD13;output;
icd=ICD_DGNS_CD14;output;
icd=ICD_DGNS_CD15;output;
icd=ICD_DGNS_CD16;output;
icd=ICD_DGNS_CD17;output;
icd=ICD_DGNS_CD18;output;
icd=ICD_DGNS_CD19;output;
icd=ICD_DGNS_CD20;output;
icd=ICD_DGNS_CD21;output;
icd=ICD_DGNS_CD22;output;
icd=ICD_DGNS_CD23;output;
icd=ICD_DGNS_CD24;output;
icd=ICD_DGNS_CD25;output;
keep bene_id icd;
run;

proc sort data=clm nodupkey;where icd ne '';by bene_id icd;run;

proc import datafile="D:\Projects\High Cost Segmentation Phase II\20161204_ICD9_AllCancers_Solid.xlsx" 
dbms=xlsx out=cancer replace;
sheet="20161202 All Cancer";
getnames=yes;
run;
 /*
filename ICC 'D:\Projects\High Cost Cancer\Document\ICC cancer.txt'; 
data ICC; 
  infile ICC ; 
  input icd9; 
run;

data cancer;
set cancer;
icd9num=icd9*1;
run;

proc sql;
create table temp as
select *
from ICC 
where icd9 not in (select icd9num from cancer);
quit;
proc print data=temp noobs;
run;
*/

proc sql;
create table temp as
select a.*,b.icd9desc,b.Site_Specific ,b.Cancer_Category, b.inccw, b.CCW_description, b.inhcc, b.hccno, b.HCC_description 
from clm a left join cancer b
on a.icd=b.icd9;
quit;

proc sort data=temp out=cancerbene2014;where Site_Specific ne .;by bene_id Site_Specific;run;
 
proc sort data=cancerbene2014 nodupkey;by bene_id Site_Specific;run;
proc transpose data= cancerbene2014 out=temp prefix=Site;
by bene_id;
var Site_Specific;
id Site_Specific;
run;

 
data  cancer.cancerbene2014;
set temp;

drop _name_ _label_;

if Site1 ne . then Site_Specific_1=1;else Site_Specific_1=0;
if Site2 ne . then Site_Specific_2=1;else Site_Specific_2=0;
if Site3_1 ne . then Site_Specific_3_1=1;else Site_Specific_3_1=0;
if Site3_2 ne . then Site_Specific_3_2=1;else Site_Specific_3_2=0;
if Site3_3 ne . then Site_Specific_3_3=1;else Site_Specific_3_3=0;
if Site3_4 ne . then Site_Specific_3_4=1;else Site_Specific_3_4=0;
if Site3_5 ne . then Site_Specific_3_5=1;else Site_Specific_3_5=0;
if Site3_6 ne . then Site_Specific_3_6=1;else Site_Specific_3_6=0;
if Site3_7 ne . then Site_Specific_3_7=1;else Site_Specific_3_7=0;
if Site3_8 ne . then Site_Specific_3_8=1;else Site_Specific_3_8=0;

if Site_Specific_3_1+Site_Specific_3_2+Site_Specific_3_3+Site_Specific_3_4+Site_Specific_3_5+Site_Specific_3_6+Site_Specific_3_7+Site_Specific_3_8>0 
then Site_Specific_3=1;else Site_Specific_3=0;

if Site4_1 ne . then Site_Specific_4_1=1;else Site_Specific_4_1=0;
if Site4_2 ne . then Site_Specific_4_2=1;else Site_Specific_4_2=0;
if Site4_3 ne . then Site_Specific_4_3=1;else Site_Specific_4_3=0;
if Site4_4 ne . then Site_Specific_4_4=1;else Site_Specific_4_4=0;
if Site4_5 ne . then Site_Specific_4_5=1;else Site_Specific_4_5=0;
if Site4_6 ne . then Site_Specific_4_6=1;else Site_Specific_4_6=0;
if Site4_7 ne . then Site_Specific_4_7=1;else Site_Specific_4_7=0;

if Site_Specific_4_1+Site_Specific_4_2+Site_Specific_4_3+Site_Specific_4_4+Site_Specific_4_5+Site_Specific_4_6+Site_Specific_4_7>0 
then Site_Specific_4=1;else Site_Specific_4=0;


if Site5_1 ne . then Site_Specific_5_1=1;else Site_Specific_5_1=0;
if Site5_2 ne . then Site_Specific_5_2=1;else Site_Specific_5_2=0;
if Site5_3 ne . then Site_Specific_5_3=1;else Site_Specific_5_3=0;
if Site5_4 ne . then Site_Specific_5_4=1;else Site_Specific_5_4=0;

if Site_Specific_5_1+Site_Specific_5_2+Site_Specific_5_3+Site_Specific_5_4>0 
then Site_Specific_5=1;else Site_Specific_5=0;


if Site6 ne . then Site_Specific_6=1;else Site_Specific_6=0;
if Site7 ne . then Site_Specific_7=1;else Site_Specific_7=0;
if Site8 ne . then Site_Specific_8=1;else Site_Specific_8=0;

if Site9_1 ne . then Site_Specific_9_1=1;else Site_Specific_9_1=0;
if Site9_2 ne . then Site_Specific_9_2=1;else Site_Specific_9_2=0;

if Site_Specific_9_1+Site_Specific_9_2>0 
then Site_Specific_9=1;else Site_Specific_9=0;

if Site10 ne . then Site_Specific_10=1;else Site_Specific_10=0;
if Site11 ne . then Site_Specific_11=1;else Site_Specific_11=0;
if Site12 ne . then Site_Specific_12=1;else Site_Specific_12=0;
if Site13 ne . then Site_Specific_13=1;else Site_Specific_13=0;
if Site14 ne . then Site_Specific_14=1;else Site_Specific_14=0;
if Site15 ne . then Site_Specific_15=1;else Site_Specific_15=0;

N_Cancer=Site_Specific_1+Site_Specific_2+Site_Specific_3+Site_Specific_4+Site_Specific_5+Site_Specific_6+Site_Specific_7
+Site_Specific_8+Site_Specific_9+Site_Specific_10+Site_Specific_11+Site_Specific_12+Site_Specific_13+Site_Specific_14+Site_Specific_15;

label  Site_Specific_1="Breast";
label  Site_Specific_2="CNS";
label  Site_Specific_3_1="GI - Esophagus";
label  Site_Specific_3_2="GI - stomach";
label  Site_Specific_3_3="GI - small bowel";
label  Site_Specific_3_4="GI - CRC";
label  Site_Specific_3_5="GI - Anal";
label  Site_Specific_3_6="GI - Liver, Biliary";
label  Site_Specific_3_7="GI - Panc";
label  Site_Specific_3_8="GI";
label  Site_Specific_3="GI";

label  Site_Specific_4_1="GU - Prostate";
label  Site_Specific_4_2="GU - bladder";
label  Site_Specific_4_3="GU - penile";
label  Site_Specific_4_4="GU - renal";
label  Site_Specific_4_5="GU - testes";
label  Site_Specific_4_6="GU - urethral";
label  Site_Specific_4_7="GU";
label  Site_Specific_4="GU";


label  Site_Specific_5_1="Gyn - Ovarian";
label  Site_Specific_5_2="Gyn - Uterine";
label  Site_Specific_5_3="Gyn - Vagina";
label  Site_Specific_5_4="Gyn";
label  Site_Specific_5="Gyn";

label  Site_Specific_6="H and N";
label  Site_Specific_7="Lung";
label  Site_Specific_8="Lymphoma";

label  Site_Specific_9_1="Sarcoma - ST";
label  Site_Specific_9_2="Sarcoma - Bone";
 label  Site_Specific_9="Sarcoma";

label  Site_Specific_10="Other";
label  Site_Specific_11="Mets";
label  Site_Specific_12="Leukemia";
label  Site_Specific_13="Melanoma";
label  Site_Specific_14="Skin";
label  Site_Specific_15="Multiple Myeloma";

keep bene_id Site_Specific_1--Site_Specific_15 N_Cancer;
proc contents order=varnum;
run;

