*****************************************
Sample Selection and Data Prep
Xiner Zhou
3/21/2016
*****************************************;
libname MMleads 'C:\data\Data\MMLEADS\Data';
libname data 'C:\data\Projects\Peterson\Data-XZ';
libname denom 'C:\data\Data\Medicare\Denominator';

 

******************************************
	Beneficiary Sample Selection
******************************************;
proc sql;
create table Bene2010 as
select bene_id, 
case when bene_id in (select bene_id from denom.dnmntr2009 where FIVEPCT='Y') then 1 else 0 end as FIVEPCT2009,
case when bene_id in (select bene_id from MMleads.Mml_bene2009 where E_MedicareFFS=1) then 1 else 0 end as E_MedicareFFS2009,

D_Died, D_Age, D_Sex, D_Medicare_Race, D_Medicaid_Race, D_ZIP, D_State_CD, D_COUNTY, D_Disability_CD, D_Disability_Primary_CD, D_Disability_Secondary_CD,
E_MME_Type, E_MedicaidFFS,	E_MedicaidPHP, E_MedicareFFS, E_MS_CD,  E_BOE,  
S_Medicare_PMT, S_Medicare_Bene_PMT, S_Medicaid_PMT, S_Medicaid_Bene_PMT, S_Medicaid_FFS_PMT,

U_Medicare_Admits, U_Medicare_Readmits, 
U_Acute_Cov_Day_CNT_01,U_Acute_Cov_Day_CNT_02,U_Acute_Cov_Day_CNT_03,U_Acute_Cov_Day_CNT_04,U_Acute_Cov_Day_CNT_05,U_Acute_Cov_Day_CNT_06,U_Acute_Cov_Day_CNT_07,U_Acute_Cov_Day_CNT_08,U_Acute_Cov_Day_CNT_09,U_Acute_Cov_Day_CNT_10,U_Acute_Cov_Day_CNT_11,U_Acute_Cov_Day_CNT_12,
U_SNF_Day_CNT_01,U_SNF_Day_CNT_02,U_SNF_Day_CNT_03,U_SNF_Day_CNT_04,U_SNF_Day_CNT_05,U_SNF_Day_CNT_06,U_SNF_Day_CNT_07,U_SNF_Day_CNT_08,U_SNF_Day_CNT_09,U_SNF_Day_CNT_10,U_SNF_Day_CNT_11,U_SNF_Day_CNT_12,
U_PAC_OTH_Day_CNT_01,U_PAC_OTH_Day_CNT_02,U_PAC_OTH_Day_CNT_03,U_PAC_OTH_Day_CNT_04,U_PAC_OTH_Day_CNT_05,U_PAC_OTH_Day_CNT_06,U_PAC_OTH_Day_CNT_07,U_PAC_OTH_Day_CNT_08,U_PAC_OTH_Day_CNT_09,U_PAC_OTH_Day_CNT_10,U_PAC_OTH_Day_CNT_11,U_PAC_OTH_Day_CNT_12,
U_Hospice_Day_CNT_01,U_Hospice_Day_CNT_02,U_Hospice_Day_CNT_03,U_Hospice_Day_CNT_04,U_Hospice_Day_CNT_05,U_Hospice_Day_CNT_06,U_Hospice_Day_CNT_07,U_Hospice_Day_CNT_08,U_Hospice_Day_CNT_09,U_Hospice_Day_CNT_10,U_Hospice_Day_CNT_11,U_Hospice_Day_CNT_12,
U_Medicare_HH_VST_CNT_01,U_Medicare_HH_VST_CNT_02,U_Medicare_HH_VST_CNT_03,U_Medicare_HH_VST_CNT_04,U_Medicare_HH_VST_CNT_05,U_Medicare_HH_VST_CNT_06,U_Medicare_HH_VST_CNT_07,U_Medicare_HH_VST_CNT_08,U_Medicare_HH_VST_CNT_09,U_Medicare_HH_VST_CNT_10,U_Medicare_HH_VST_CNT_11,U_Medicare_HH_VST_CNT_12,
U_Medicare_IER_CNT_01,U_Medicare_IER_CNT_02,U_Medicare_IER_CNT_03,U_Medicare_IER_CNT_04,U_Medicare_IER_CNT_05,U_Medicare_IER_CNT_06,U_Medicare_IER_CNT_07,U_Medicare_IER_CNT_08,U_Medicare_IER_CNT_09,U_Medicare_IER_CNT_10,U_Medicare_IER_CNT_11,U_Medicare_IER_CNT_12,
U_Medicare_OER_CNT_01,U_Medicare_OER_CNT_02,U_Medicare_OER_CNT_03,U_Medicare_OER_CNT_04,U_Medicare_OER_CNT_05,U_Medicare_OER_CNT_06,U_Medicare_OER_CNT_07,U_Medicare_OER_CNT_08,U_Medicare_OER_CNT_09,U_Medicare_OER_CNT_10,U_Medicare_OER_CNT_11,U_Medicare_OER_CNT_12,
U_Phys_Vst_01,U_Phys_Vst_02,U_Phys_Vst_03,U_Phys_Vst_04,U_Phys_Vst_05,U_Phys_Vst_06,U_Phys_Vst_07,U_Phys_Vst_08,U_Phys_Vst_09,U_Phys_Vst_10,U_Phys_Vst_11,U_Phys_Vst_12,
U_DME_Vst_01,U_DME_Vst_02,U_DME_Vst_03,U_DME_Vst_04,U_DME_Vst_05,U_DME_Vst_06,U_DME_Vst_07,U_DME_Vst_08,U_DME_Vst_09,U_DME_Vst_10,U_DME_Vst_11,U_DME_Vst_12,
U_Drug_PTD_01,U_Drug_PTD_02,U_Drug_PTD_03,U_Drug_PTD_04,U_Drug_PTD_05,U_Drug_PTD_06,U_Drug_PTD_07,U_Drug_PTD_08,U_Drug_PTD_09,U_Drug_PTD_10,U_Drug_PTD_11,U_Drug_PTD_12,

U_Medicaid_Admits,U_Medicaid_Readmits,
U_Medicaid_IP_Days_FFS_01,U_Medicaid_IP_Days_FFS_02,U_Medicaid_IP_Days_FFS_03,U_Medicaid_IP_Days_FFS_04,U_Medicaid_IP_Days_FFS_05,U_Medicaid_IP_Days_FFS_06,U_Medicaid_IP_Days_FFS_07,U_Medicaid_IP_Days_FFS_08,U_Medicaid_IP_Days_FFS_09,U_Medicaid_IP_Days_FFS_10,U_Medicaid_IP_Days_FFS_11,U_Medicaid_IP_Days_FFS_12,
U_Medicaid_Nurs_FAC_FFS_01,U_Medicaid_Nurs_FAC_FFS_02,U_Medicaid_Nurs_FAC_FFS_03,U_Medicaid_Nurs_FAC_FFS_04,U_Medicaid_Nurs_FAC_FFS_05,U_Medicaid_Nurs_FAC_FFS_06,U_Medicaid_Nurs_FAC_FFS_07,U_Medicaid_Nurs_FAC_FFS_08,U_Medicaid_Nurs_FAC_FFS_09,U_Medicaid_Nurs_FAC_FFS_10,U_Medicaid_Nurs_FAC_FFS_11,U_Medicaid_Nurs_FAC_FFS_12,
U_Medicaid_HH_Vst_FFS_01,U_Medicaid_HH_Vst_FFS_02,U_Medicaid_HH_Vst_FFS_03,U_Medicaid_HH_Vst_FFS_04,U_Medicaid_HH_Vst_FFS_05,U_Medicaid_HH_Vst_FFS_06,U_Medicaid_HH_Vst_FFS_07,U_Medicaid_HH_Vst_FFS_08,U_Medicaid_HH_Vst_FFS_09,U_Medicaid_HH_Vst_FFS_10,U_Medicaid_HH_Vst_FFS_11,U_Medicaid_HH_Vst_FFS_12,
U_Medicaid_IER_Vst_01,U_Medicaid_IER_Vst_02,U_Medicaid_IER_Vst_03,U_Medicaid_IER_Vst_04,U_Medicaid_IER_Vst_05,U_Medicaid_IER_Vst_06,U_Medicaid_IER_Vst_07,U_Medicaid_IER_Vst_08,U_Medicaid_IER_Vst_09,U_Medicaid_IER_Vst_10,U_Medicaid_IER_Vst_11,U_Medicaid_IER_Vst_12,
U_Medicaid_OER_Vst_01,U_Medicaid_OER_Vst_02,U_Medicaid_OER_Vst_03,U_Medicaid_OER_Vst_04,U_Medicaid_OER_Vst_05,U_Medicaid_OER_Vst_06,U_Medicaid_OER_Vst_07,U_Medicaid_OER_Vst_08,U_Medicaid_OER_Vst_09,U_Medicaid_OER_Vst_10,U_Medicaid_OER_Vst_11,U_Medicaid_OER_Vst_12,
U_Medicaid_Drug_RX_FFS_01,U_Medicaid_Drug_RX_FFS_02,U_Medicaid_Drug_RX_FFS_03,U_Medicaid_Drug_RX_FFS_04,U_Medicaid_Drug_RX_FFS_05,U_Medicaid_Drug_RX_FFS_06,U_Medicaid_Drug_RX_FFS_07,U_Medicaid_Drug_RX_FFS_08,U_Medicaid_Drug_RX_FFS_09,U_Medicaid_Drug_RX_FFS_10,U_Medicaid_Drug_RX_FFS_11,U_Medicaid_Drug_RX_FFS_12,

U_Res_MH_CNT,U_Comm_MH_CNT

from MMleads.Mml_bene2010
where  E_MME_Type in (3,4,5) ;
quit;
/*
proc tabulate data=step noseps format=comma9.2 ;
class step D_sex FIVEPCT2009 ;var D_age ;
 
table  (step="Selection" D_sex="Gender"),(n colpctn) /RTS=25;*row, col; * var1 * var2: var2 nested in var1;
table step*FIVEPCT2009,D_Age*(mean*f=7.2 min*f=7.2 max);

keylabel all="total"
mean="average"
std="Standard Deviation";

run;
*/
data step;
set Bene2010;step1=0;step2=0;step3=0;step4=0;step5=0;step6=0; 
if E_MME_Type in (3,4,5) and D_Died ne 1 and E_MedicareFFS=1 and E_MedicaidFFS=1 and E_MEDICAIDPHP=0 and E_MedicareFFS2009=1 and FIVEPCT2009=1 then step1=1;
if E_MME_Type in (3,4,5) and D_Died ne 1 and E_MedicareFFS=1 and E_MedicaidFFS=1 and E_MEDICAIDPHP=0 and E_MedicareFFS2009=1 then step2=1;
if E_MME_Type in (3,4,5) and D_Died ne 1 and E_MedicareFFS=1 and E_MedicaidFFS=1 and E_MEDICAIDPHP=0 then step3=1;
if E_MME_Type in (3,4,5) and D_Died ne 1 and E_MedicareFFS=1 and E_MedicaidFFS=1 then step4=1;
if E_MME_Type in (3,4,5) and D_Died ne 1 then step5=1;
if E_MME_Type in (3,4,5) then step6=1;
proc freq;
table step1 step2 step3 step4 step5 step6  ;
run;
 




proc sql;
create table temp1 as
select a.*,b.*
from step a left join data.Frailty2009 b
on a.bene_id=b.bene_id 
where a.step1=1;
quit;
 
proc sql;
create table temp2 as
select a.*,b.*
from temp1 a left join data.CC2009 b
on a.bene_id=b.bene_id ;
quit;


 
*****************Segmentation Definition:
Seg 1: Age <65 
Seg 2: Frailty Indicator total 12 >=2 
Seg 3: Major CC >=3
Seg 4: Major CC 1 or 2 (>0 & <3)
Seg 5: Major CC=0 and Minor CC >0
Seg 6: Major CC=0 and Minor CC=0

Major CC: amiihd chrkid chf dementia lung psydis strk spchrtarr
Minior CC: amputat arthrit artopen bph cancer diabetes endo eyedis 
                 hemadis hyperlip hyperten immunedis ibd liver neuromusc osteo 
                 paralyt sknulc sa thyroid vascdis 
*************************************************************************************************;
%macro sum(var=);
array a&var. {12} &var._01 &var._02 &var._03 &var._04 &var._05 &var._06 &var._07 &var._08 &var._09 &var._10 &var._11 &var._12;
do i=1 to 12;
if a&var.{i}=. then a&var.{i}=0;
end;
drop i &var._01 &var._02 &var._03 &var._04 &var._05 &var._06 &var._07 &var._08 &var._09 &var._10 &var._11 &var._12 ;
&var.=&var._01+&var._02+ &var._03+ &var._04+ &var._05+ &var._06+ &var._07+ &var._08+ &var._09+ &var._10+ &var._11+ &var._12;
%mend sum;

data temp3;
length seg seg1 seg2 seg3 seg4 $50.;
set temp2;

%sum(var=U_Acute_Cov_Day_CNT);
%sum(var=U_SNF_Day_CNT );
%sum(var=U_PAC_OTH_Day_CNT );
%sum(var=U_Hospice_Day_CNT );
%sum(var=U_Medicare_HH_VST_CNT );
%sum(var=U_Medicare_IER_CNT );
%sum(var=U_Medicare_OER_CNT );
%sum(var=U_Phys_Vst );
%sum(var=U_DME_Vst );
%sum(var=U_Drug_PTD );
%sum(var=U_Medicaid_IP_Days_FFS );
%sum(var=U_Medicaid_Nurs_FAC_FFS );
%sum(var=U_Medicaid_HH_Vst_FFS );
%sum(var=U_Medicaid_IER_Vst );
%sum(var=U_Medicaid_OER_Vst );
%sum(var=U_Medicaid_Drug_RX_FFS );
 
if U_Res_MH_CNT=. then U_Res_MH_CNT=0;
if U_Comm_MH_CNT=. then  U_Comm_MH_CNT=0;
if U_Medicare_Admits=. then U_Medicare_Admits=0;
if U_Medicare_Readmits=. then U_Medicare_Readmits=0;
if U_Medicaid_Admits=. then U_Medicaid_Admits=0;
if U_Medicaid_Readmits=. then U_Medicaid_Readmits=0;




array f{12} frailty1 frailty2 frailty3 frailty4 frailty5 frailty6 frailty7 frailty8 frailty9 frailty10 frailty11 frailty12;
array CC{30} 
amiihd amputat arthrit  artopen  bph  
cancer  chrkid  chf  cystfib  dementia  
diabetes  endo  eyedis hemadis  hyperlip  
hyperten  immunedis  ibd liver  lung   
neuromusc  osteo  paralyt  psydis  sknulc 
spchrtarr  strk sa  thyroid  vascdis;
do i=1 to 12 ;
if f{i}=. then f{i}=0;
end;
do j=1 to 30;
if CC{j}=. then CC{j}=0;
end;
drop i j;

N_Frailty=frailty1+ frailty2+ frailty3+ frailty4+ frailty5+ frailty6+ frailty7+ frailty8+ frailty9+ frailty10+ frailty11+ frailty12;
N_MajorCC=amiihd+ chrkid+ chf+ dementia+ lung+ psydis+ strk+ spchrtarr;
N_MinorCC=amputat+ arthrit+ artopen+ bph+ cancer+ diabetes+ endo+ eyedis +
                 hemadis+ hyperlip+ hyperten+ immunedis+ ibd+ liver+ neuromusc+ osteo+ 
                 paralyt+ sknulc+ sa+ thyroid+ vascdis;

* Segmentation (Original for all <65 and >65);
if D_Age<65 then seg="1.Under 65";
else if N_Frailty>=2 then seg="2.Over 65,2 or more frailty";
else if N_MajorCC>=3 then seg="3.Over 65,less than 2 frailty,3 or more major CC";
else if N_MajorCC=1 or N_MajorCC=2 then seg="4.Over 65,less than 2 frailty,1 or 2 major CC";
else if N_MinorCC>0 then seg="5.Over 65,less than 2 frailty,no major CC,some minor CC";
else if N_MinorCC=0 then seg="6.Over 65,less than 2 frailty,no major CC,no minor CC";

label seg="Segmentation (Original for all <65 and >65)";


* Segmentation for <65 only;
if D_Age<65 then do;
	if N_Frailty>=2 then seg1="1.Under 65,2 or more frailty";
	else if N_MajorCC>=3 then seg1="2.Under 65,less than 2 frailty,3 or more major CC";
	else if N_MajorCC=1 or N_MajorCC=2 then seg1="3.Under 65,less than 2 frailty,1 or 2 major CC";
	else if N_MajorCC=0 and N_MinorCC>0 then seg1="4.Under 65,less than 2 frailty,no major CC,some minor CC";
	else if N_MinorCC=0 then seg1="5.Under 65,less than 2 frailty,no major CC,no minor CC";
end;

label seg1="Segmentation for <65 only";

* Impact of Mental Health Disease in Duals ;
N_MajorCC1=amiihd+ chrkid+ chf+ dementia+ lung+ strk+ spchrtarr;

if psydis=1 and N_MajorCC1>=3 then seg2="A1.MHD + 3 or more major CC";
else if psydis=1 and N_MajorCC1 in (1,2) then seg2="A2.MHD + 1 or 2 major CC";
else if psydis=1 and N_MajorCC1=0 and N_MinorCC>0 then seg2="A3.MHD + 0 major CC + Some minor CC";
else if psydis=1 and N_MajorCC1=0 and N_MinorCC=0 then seg2="A4.MHD + 0 major + 0 minor";
else if psydis=0 and N_MajorCC1>=3 then seg2="B1.No MHD + 3 or more major CC";
else if psydis=0 and N_MajorCC1 in (1,2) then seg2="B2.No MHD + 1 or 2 major CC";
else if psydis=0 and N_MajorCC1=0 and N_MinorCC>0 then seg2="B3.No MHD + 0 major CC + Some minor CC";
else if psydis=0 and N_MajorCC1=0 and N_MinorCC=0 then seg2="B4.No MHD + 0 major + 0 minor";

label seg2="Segmentation for Mental Health Disease";

* Impact of Frailty in Duals: comparing patients with Frailty and those without Frailty;
if N_Frailty>=2 and N_MajorCC>=3 then seg3="A1.Frail + 3 or more major CC";
else if N_Frailty>=2 and N_MajorCC in (1,2) then seg3="A2:Frail + 1 or 2 major CC";
else if N_Frailty>=2 and N_MajorCC=0 and N_MinorCC>0 then seg3="A3.Frail + 0 major CC + Some minor CC";
else if N_Frailty>=2 and N_MajorCC=0 and N_MinorCC=0 then seg3="A4.Frail + 0 major and 0 minor";
else if N_Frailty<2 and N_MajorCC>=3 then seg3="B1.Non-Frail + 3 or more major CC";
else if N_Frailty<2 and N_MajorCC in (1,2) then seg3="B2.Non-Frail + 1 or 2 major CC";
else if N_Frailty<2 and N_MajorCC=0 and N_MinorCC>0 then seg3="B3.Non-Frail + 0 major CC + Some minor CC";
else if N_Frailty<2 and N_MajorCC=0 and N_MinorCC=0 then seg3="B4.Non-Frail + 0 major and 0 minor";

label seg3="Segmentation for Frailty";

* Interaction between Mental Health Disease and Frailty;
if psydis=1 and N_Frailty>=2 then seg4="1.Mental Health Disease + Frail";
else if psydis=1 and N_Frailty<2 then seg4="2.Mental Health Disease + Non-Frail";
else if psydis=0 and N_Frailty>=2 then seg4="3.No Mental Health Disease + Frail";
else if psydis=0 and N_Frailty<2 then seg4="4.No Mental Health Disease + Non-Frail";

label seg4="Segmentation for Mental Health Disease and Frailty";

if E_MME_Type in (3,4) then DUAL="Partial DUAL";
else if E_MME_Type in (5) then DUAL="Full DUAL";

if S_Medicare_PMT=. then S_Medicare_PMT=0;
if S_Medicare_Bene_PMT=. then S_Medicare_Bene_PMT=0;
if S_Medicaid_Bene_PMT=. then S_Medicaid_Bene_PMT=0;
if S_Medicaid_FFS_PMT=. then S_Medicaid_FFS_PMT=0;
S_FFS_MRMCBene =S_Medicare_PMT+S_Medicare_Bene_PMT+S_Medicaid_Bene_PMT+S_Medicaid_FFS_PMT;
proc freq;table DUAL;
proc freq; 
table seg seg1 seg2 seg3 seg4/missing;
run;
 
proc rank data=temp3 out=temp4 percent  ;
var S_FFS_MRMCBene;
ranks r;
run;

proc sql;
create table temp5 as
select a.*,b.STATE_CD  
from temp4 a left join  denom.dnmntr2009 b
on a.bene_id=b.bene_id;
quit;

 

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

/*
Region 1: Maine, New Hampshire, Vermont, Massachusetts, Rhode Island, and Connecticut
Region 2: New York and New Jersey
Region 3: Pennsylvania, Maryland, Delaware, Virginia, and West Virginia
Region 4: Kentucky, Tennessee, North Carolina, South Carolina, Georgia, Florida, Alabama, and Mississippi
Region 5: Minnesota, Wisconsin, Illinois, Indiana, Michigan, and Ohio
Region 6: New Mexico, Texas, Oklahoma, Arkansas, and Louisiana
Region 7: Nebraska, Kansas, Iowa, and Missouri
Region 8: Montana, North Dakota, South Dakota, Wyoming, Colorado, and Utah
Region 9: Nevada, California, Arizona, and Hawaii
Region 10: Washington, Oregon, Idaho, and Alaska

    if STATE_CD in ('20','30','47','22','41','07') then region=1;
    if STATE_CD in ('33','31') then region=2;
    if STATE_CD in ('39','21','08','49','51') then region=3;
    if STATE_CD in ('18','44','34','42','11','10','01','25') then region=4;
    if STATE_CD in ('24','52','14','15','23','36') then region=5;
    if STATE_CD in ('32','45','37','04','19') then region=6;
    if STATE_CD in ('28','17','16','26') then region=7;
    if STATE_CD in ('27','35','43','53','06','46') then region=8;
    if STATE_CD in ('29','05','03','12') then region=9;
    if STATE_CD in ('50','38','13','02') then region=10;
*/
data temp6;
set temp5;

D_STATE=D_STATE_CD;
if D_STATE_CD='' then D_STATE=put(STATE_CD*1,st.); 
 

 
if r>=90 then HC=1;else HC=0;
 

    if D_STATE  in ('ME','NH','VT','MA','RI','CT') then region=1;
    if D_STATE  in ('NY','NJ') then region=2;
    if D_STATE  in ('PA','MD','DE','VA','WV') then region=3;
    if D_STATE  in ('KY','TN','NC','SC','GA','FL','AL','MS') then region=4;
    if D_STATE  in ('MN','WI','IL','IN','MI','OH') then region=5;
    if D_STATE  in ('NM','TX','OK','AR','LA') then region=6;
    if D_STATE  in ('NE','KS','IA','MO') then region=7;
    if D_STATE  in ('MT','ND','SD','WY','CO','UT') then region=8;
    if D_STATE  in ('NV','CA','AZ','HI') then region=9;
    if D_STATE  in ('WA','OR','ID','AK') then region=10;
	if D_STATE  in ('DC') then region=11;
proc freq;tables D_State/missing;

run;

/*
Analytical Plan in Dual Population:

1.	HC Duals by Age group:
•	<18		#Total Patients	#HC Patients	%HC Patients	
•	18-25
•	26-35
•	36-45
•	46-55
•	56-64
•	65-75
•	75-85
•	>86
*/
data temp7;
set temp6;
length AgeGroup $10.;
if D_Age<18 then AgeGroup="<18";
else if D_Age<=25 then AgeGroup="18-25";
else if D_Age<=35 then AgeGroup="26-35";
else if D_Age<=45 then AgeGroup="36-45";
else if D_Age<=55 then AgeGroup="46-55";
else if D_Age<=65 then AgeGroup="56-65";
else if D_Age<=75 then AgeGroup="66-75";
else if D_Age<=85 then AgeGroup="76-85";
else if D_Age>86 then AgeGroup=">86";
run;


/*
2.	HC Duals by Income 
•	Stratify by Zip Code Median Income in Quartiles
•	Stratify by Zip Code Median Income in Quintiles

#Total Patients	#HC Patients	%HC Patients	
*/
 
/*
3.	HC Duals by Education-Level 
•	Stratify by Zip Code Education-Level in Quartiles
•	Stratify by Zip Code Education-Level in Quintiles
*/
libname zipdata 'C:\data\Data\Census';


data zip;
set zipdata.National_zcta_extract;
MHI=f1434508;Education=f1448208;
keep edu_college inchh_median zip5 ;
run;

proc rank data=zip out=zipout groups=4;
var edu_college inchh_median;
ranks  Educationr MHIr;
run;

data Zipout;
set Zipout;
MHIR=MHIR+1;
EducationR=EducationR+1;
label MHIR="Quartiles:Medium House Income";
label EducationR="Quartiles:% Persons with College";
proc freq ;tables MHIR EducationR/missing;
run;


proc sql;
create table temp8 as
select a.*,b.*
from temp7 a left join Zipout  b
on a.D_ZIP=b.zip5 ;
quit;

 
/*
6.	Preventable spending in Duals
•	Segment preventable spending by PQIs + 30day spending after PQI admission  [similar to Medicare study] for:
o	Segments
o	For the persistent vs. transcient duals in point #5
*/


*******************************Medicare Service-level file;

proc import datafile="C:\data\Projects\Peterson\Program-XZ\Medicare Service Level" dbms=xlsx out=level replace;getnames=yes;run;
data level;
set level;
level=_n_; 
run;
data temp2010;
set data.Sample2010;
do i=1 to 55;
 level=i;output;
end;
drop i;
run;
proc sql;
create table sample2010 as
select a.*,b.SRVC_1 as SRVC_1_1,b.SRVC_2 as SRVC_2_1
from temp2010 a left join level b
on a.level=b.level;
quit;



proc sql;
create table temp1 as
select a.*,
b.Bene_CNT,b.USER1_CNT,b.USER2_CNT,b.SRVC_1,b.SRVC_2,b.Medicare_PMT,b.Medicare_Bene_PMT,
b.Medicare_CLM_CNT_01,b.Medicare_CLM_CNT_02,b.Medicare_CLM_CNT_03,b.Medicare_CLM_CNT_04,b.Medicare_CLM_CNT_05,b.Medicare_CLM_CNT_06,b.Medicare_CLM_CNT_07,b.Medicare_CLM_CNT_08,b.Medicare_CLM_CNT_09,b.Medicare_CLM_CNT_10,b.Medicare_CLM_CNT_11,b.Medicare_CLM_CNT_12,
b.Medicare_Day_CNT_01,b.Medicare_Day_CNT_02,b.Medicare_Day_CNT_03,b.Medicare_Day_CNT_04,b.Medicare_Day_CNT_05,b.Medicare_Day_CNT_06,b.Medicare_Day_CNT_07,b.Medicare_Day_CNT_08,b.Medicare_Day_CNT_09,b.Medicare_Day_CNT_10,b.Medicare_Day_CNT_11,b.Medicare_Day_CNT_12,
b.Medicare_Cov_Day_CNT_01,b.Medicare_Cov_Day_CNT_02,b.Medicare_Cov_Day_CNT_03,b.Medicare_Cov_Day_CNT_04,b.Medicare_Cov_Day_CNT_05,b.Medicare_Cov_Day_CNT_06,b.Medicare_Cov_Day_CNT_07,b.Medicare_Cov_Day_CNT_08,b.Medicare_Cov_Day_CNT_09,b.Medicare_Cov_Day_CNT_10,b.Medicare_Cov_Day_CNT_11,b.Medicare_Cov_Day_CNT_12

from sample2010 a left join MMLEADS.Mml_mrse2010 b
on a.bene_id=b.bene_id and a.SRVC_1_1=b.SRVC_1 and a.SRVC_2_1=b.SRVC_2;
quit;


data data.MR2010;
set temp1;
if SRVC_1='' then SRVC_1=SRVC_1_1;
if SRVC_2='' then SRVC_2=SRVC_2_1;

drop SRVC_1_1 SRVC_2_1;

array temp {38}
Medicare_PMT Medicare_Bene_PMT 
Medicare_CLM_CNT_01 Medicare_CLM_CNT_02 Medicare_CLM_CNT_03 Medicare_CLM_CNT_04 Medicare_CLM_CNT_05 Medicare_CLM_CNT_06 Medicare_CLM_CNT_07 Medicare_CLM_CNT_08 Medicare_CLM_CNT_09 Medicare_CLM_CNT_10 Medicare_CLM_CNT_11 Medicare_CLM_CNT_12 
Medicare_Day_CNT_01 Medicare_Day_CNT_02 Medicare_Day_CNT_03 Medicare_Day_CNT_04 Medicare_Day_CNT_05 Medicare_Day_CNT_06 Medicare_Day_CNT_07 Medicare_Day_CNT_08 Medicare_Day_CNT_09 Medicare_Day_CNT_10 Medicare_Day_CNT_11 Medicare_Day_CNT_12 
Medicare_Cov_Day_CNT_01 Medicare_Cov_Day_CNT_02 Medicare_Cov_Day_CNT_03 Medicare_Cov_Day_CNT_04 Medicare_Cov_Day_CNT_05 Medicare_Cov_Day_CNT_06 Medicare_Cov_Day_CNT_07 Medicare_Cov_Day_CNT_08 Medicare_Cov_Day_CNT_09 Medicare_Cov_Day_CNT_10 Medicare_Cov_Day_CNT_11 Medicare_Cov_Day_CNT_12
;
do i=1 to 38;
if temp{i}=. then temp{i}=0;
end;
Medicare_CLM_CNT=Medicare_CLM_CNT_01+ Medicare_CLM_CNT_02+  Medicare_CLM_CNT_03+  Medicare_CLM_CNT_04+  Medicare_CLM_CNT_05+  Medicare_CLM_CNT_06
+ Medicare_CLM_CNT_07+  Medicare_CLM_CNT_08+  Medicare_CLM_CNT_09+  Medicare_CLM_CNT_10+  Medicare_CLM_CNT_11+  Medicare_CLM_CNT_12 ;

Medicare_Day_CNT=Medicare_Day_CNT_01+ Medicare_Day_CNT_02+ Medicare_Day_CNT_03+ Medicare_Day_CNT_04+ Medicare_Day_CNT_05+ Medicare_Day_CNT_06 
+Medicare_Day_CNT_07+ Medicare_Day_CNT_08+ Medicare_Day_CNT_09+ Medicare_Day_CNT_10+ Medicare_Day_CNT_11+ Medicare_Day_CNT_12;
 
Medicare_Cov_Day_CNT=Medicare_Cov_Day_CNT_01+ Medicare_Cov_Day_CNT_02+ Medicare_Cov_Day_CNT_03+ Medicare_Cov_Day_CNT_04+ Medicare_Cov_Day_CNT_05
+ Medicare_Cov_Day_CNT_06+ Medicare_Cov_Day_CNT_07+ Medicare_Cov_Day_CNT_08+ Medicare_Cov_Day_CNT_09+ Medicare_Cov_Day_CNT_10+ Medicare_Cov_Day_CNT_11+ Medicare_Cov_Day_CNT_12;
 
drop i;
run;
 

********************************Medicaid Service-level file;

proc import datafile="C:\data\Projects\Peterson\Program-XZ\Medicaid Service Level" dbms=xlsx out=level replace;getnames=yes;run;
data level;
set level;
level=_n_; 
run;
data temp2010;
set data.Sample2010;
do i=1 to 74;
 level=i;output;
end;
drop i;
run;
proc sql;
create table sample2010 as
select a.*,b.SRVC_1 as SRVC_1_1,b.SRVC_2 as SRVC_2_1,b.SRVC_3 as SRVC_3_1
from temp2010 a left join level b
on a.level=b.level;
quit;
 

proc sql;
create table temp2 as
select a.*,
b.Bene_CNT,b.USER1_CNT,b.USER2_CNT,b.USER3_CNT,b.SRVC_1,b.SRVC_2,b.SRVC_3,b.Medicaid_PMT,b.Medicaid_coin_PMT,b.Medicaid_DED_PMT,
b.Medicaid_CLM_CNT_01,b.Medicaid_CLM_CNT_02,b.Medicaid_CLM_CNT_03,b.Medicaid_CLM_CNT_04,b.Medicaid_CLM_CNT_05,b.Medicaid_CLM_CNT_06,b.Medicaid_CLM_CNT_07,b.Medicaid_CLM_CNT_08,b.Medicaid_CLM_CNT_09,b.Medicaid_CLM_CNT_10,b.Medicaid_CLM_CNT_11,b.Medicaid_CLM_CNT_12,
b.Medicaid_Day_CNT_01,b.Medicaid_Day_CNT_02,b.Medicaid_Day_CNT_03,b.Medicaid_Day_CNT_04,b.Medicaid_Day_CNT_05,b.Medicaid_Day_CNT_06,b.Medicaid_Day_CNT_07,b.Medicaid_Day_CNT_08,b.Medicaid_Day_CNT_09,b.Medicaid_Day_CNT_10,b.Medicaid_Day_CNT_11,b.Medicaid_Day_CNT_12,
b.Medicaid_Cov_Day_CNT_01,b.Medicaid_Cov_Day_CNT_02,b.Medicaid_Cov_Day_CNT_03,b.Medicaid_Cov_Day_CNT_04,b.Medicaid_Cov_Day_CNT_05,b.Medicaid_Cov_Day_CNT_06,b.Medicaid_Cov_Day_CNT_07,b.Medicaid_Cov_Day_CNT_08,b.Medicaid_Cov_Day_CNT_09,b.Medicaid_Cov_Day_CNT_10,b.Medicaid_Cov_Day_CNT_11,b.Medicaid_Cov_Day_CNT_12

from sample2010 a left join MMLEADS.Mml_mdse2010 b
on a.bene_id=b.bene_id and a.SRVC_1_1=b.SRVC_1 and a.SRVC_2_1=b.SRVC_2 and a.SRVC_3_1=b.SRVC_3 ;
quit;

data data.MC2010;
set temp2;
if SRVC_1='' then SRVC_1=SRVC_1_1;
if SRVC_2='' then SRVC_2=SRVC_2_1;
if SRVC_3='' then SRVC_3=SRVC_3_1;
drop SRVC_1_1 SRVC_2_1 SRVC_3_1;

array temp {39}
Medicaid_PMT Medicaid_coin_PMT Medicaid_DED_PMT 
Medicaid_CLM_CNT_01 Medicaid_CLM_CNT_02 Medicaid_CLM_CNT_03 Medicaid_CLM_CNT_04 Medicaid_CLM_CNT_05 Medicaid_CLM_CNT_06 Medicaid_CLM_CNT_07 Medicaid_CLM_CNT_08 Medicaid_CLM_CNT_09 Medicaid_CLM_CNT_10 Medicaid_CLM_CNT_11 Medicaid_CLM_CNT_12 
Medicaid_Day_CNT_01 Medicaid_Day_CNT_02 Medicaid_Day_CNT_03 Medicaid_Day_CNT_04 Medicaid_Day_CNT_05 Medicaid_Day_CNT_06 Medicaid_Day_CNT_07 Medicaid_Day_CNT_08 Medicaid_Day_CNT_09 Medicaid_Day_CNT_10 Medicaid_Day_CNT_11 Medicaid_Day_CNT_12 
Medicaid_Cov_Day_CNT_01 Medicaid_Cov_Day_CNT_02 Medicaid_Cov_Day_CNT_03 Medicaid_Cov_Day_CNT_04 Medicaid_Cov_Day_CNT_05 Medicaid_Cov_Day_CNT_06 Medicaid_Cov_Day_CNT_07 Medicaid_Cov_Day_CNT_08 Medicaid_Cov_Day_CNT_09 Medicaid_Cov_Day_CNT_10 Medicaid_Cov_Day_CNT_11 Medicaid_Cov_Day_CNT_12
;
do i=1 to 39;
if temp{i}=. then temp{i}=0;
end;
Medicaid_CLM_CNT=Medicaid_CLM_CNT_01+ Medicaid_CLM_CNT_02+  Medicaid_CLM_CNT_03+  Medicaid_CLM_CNT_04+  Medicaid_CLM_CNT_05+  Medicaid_CLM_CNT_06
+ Medicaid_CLM_CNT_07+  Medicaid_CLM_CNT_08+  Medicaid_CLM_CNT_09+ Medicaid_CLM_CNT_10+  Medicaid_CLM_CNT_11+  Medicaid_CLM_CNT_12 ;

Medicaid_Day_CNT=Medicaid_Day_CNT_01+ Medicaid_Day_CNT_02+ Medicaid_Day_CNT_03+ Medicaid_Day_CNT_04+ Medicaid_Day_CNT_05+ Medicaid_Day_CNT_06 
+Medicaid_Day_CNT_07+ Medicaid_Day_CNT_08+ Medicaid_Day_CNT_09+ Medicaid_Day_CNT_10+ Medicaid_Day_CNT_11+ Medicaid_Day_CNT_12;
 
Medicaid_Cov_Day_CNT=Medicaid_Cov_Day_CNT_01+ Medicaid_Cov_Day_CNT_02+ Medicaid_Cov_Day_CNT_03+ Medicaid_Cov_Day_CNT_04+ Medicaid_Cov_Day_CNT_05
+ Medicaid_Cov_Day_CNT_06+ Medicaid_Cov_Day_CNT_07+ Medicaid_Cov_Day_CNT_08+ Medicaid_Cov_Day_CNT_09+ Medicaid_Cov_Day_CNT_10+ Medicaid_Cov_Day_CNT_11+ Medicaid_Cov_Day_CNT_12;

Medicaid_Bene_PMT=Medicaid_coin_PMT+Medicaid_DED_PMT ;
 
drop i;
run;
 
