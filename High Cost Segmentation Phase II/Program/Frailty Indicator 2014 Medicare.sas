*****************************************
Frailty Indicator  for Medicare 2014 (include everyone even not 20% sample)
Xiner Zhou
9/12/2016
*****************************************;

libname denom 'I:\Data\Medicare\Denominator';
libname OP 'C:\data\Data\Medicare\Outpatient';
libname Carrier 'C:\data\Data\Medicare\Carrier';
libname HHA 'C:\data\Data\Medicare\HHA';
libname HOSPICE 'C:\data\Data\Medicare\Hospice';
libname SNF 'C:\data\Data\Medicare\SNF';
libname DME 'C:\data\Data\Medicare\DME';
libname IP 'C:\data\Data\Medicare\Inpatient';
libname frail 'I:\Data\Medicare\Frailty Indicator';
libname HCC 'C:\data\Projects\Peterson';

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

proc sql;
create table clm1 as
select bene_id, 
case when  icd  in ("7812")  then 1 else 0 end as Frail1, 
case when  icd in (select ICD from HCC.Icd2hccxw2013 where HCC=21) then 1 else 0 end as Frail2, 
case when  icd in ("7837")  then 1 else 0 end as Frail3, 
case when  icd in ("7994")  then 1 else 0 end as Frail4, 
case when  icd in ("7993")  then 1 else 0 end as Frail5, 
case when  icd in ("7197")  then 1 else 0 end as Frail6, 
case when  icd in ("V1588") then 1 else 0 end as Frail7, 
case when  icd in ("7282")  then 1 else 0 end as Frail8, 
case when  icd in ("72887") then 1 else 0 end as Frail9, 
case when  icd in (select ICD from HCC.Icd2hccxw2013 where HCC=148)  then 1 else 0 end as Frail10, 
case when  icd in ("797")  then 1 else 0 end as Frail11  
from clm;
quit;

data rev;
set IP.Inptrevj2014(keep=bene_id HCPCS_CD) 
    OP.Otptrevj2014(keep=bene_id HCPCS_CD) 
    Carrier.Bcarline2014(keep=bene_id HCPCS_CD) 
    Hospice.Hspcrevj2014(keep=bene_id HCPCS_CD) 
    SNF.Snfrevj2014(keep=bene_id HCPCS_CD) 
    HHA.Hharevj2014(keep=bene_id HCPCS_CD) 
    DME.Dmelinej2014(keep=bene_id HCPCS_CD);
if HCPCS_CD in 
('E0100', 'E0105', 'E0130', 'E0135', 'E0140', 'E0141', 'E0143', 'E0144', 'E0147', 'E0148', 'E0149', 'E0160', 'E0161','E0162','E0163','E0164','E0165','E0166','E0167','E0168','E0169','E0170','E0171') 
then  frail12=1;else frail12=0;
run;


 
* Summarize at patient-level for 12 frailty indicators;
data temp; 
set clm1 rev;
array f{12} frail1 frail2 frail3 frail4  frail5 frail6 frail7 frail8  frail9 frail10 frail11 frail12;
do i=1 to 12;
if f{i}=. then f{i}=0;
end; 
drop i;
if frail1=1 or frail2=1 or  frail3=1 or  frail4=1 or   frail5=1 or  frail6=1 or  frail7=1 or  frail8=1 or   frail9=1 or  frail10=1 or  frail11=1 or  frail12=1  ;
proc sort;by bene_id;
run;

proc sql;
create table temp1 as
select bene_id, sum(frail1) as f1, sum(frail2) as f2, sum(frail3) as f3, sum(frail4) as f4, sum(frail5) as f5, sum(frail6) as f6,
sum(frail7) as f7, sum(frail8) as f8, sum(frail9) as f9, sum(frail10) as f10, sum(frail11) as f11, sum(frail12) as f12
from temp
group by bene_id;
quit;


data frail.Frailty2014;
set temp1;
Frailty1=0;Frailty2=0;Frailty3=0;Frailty4=0;Frailty5=0;Frailty6=0;Frailty7=0;Frailty8=0;Frailty9=0;Frailty10=0;Frailty11=0;Frailty12=0;
if f1>0 then Frailty1=1; label Frailty1="Abnormality of gait";
if f2>0 then Frailty2=1; label Frailty2="Abnormal loss of weight and underweight";
if f3>0 then Frailty3=1; label Frailty3="Adult failure to thrive";
if f4>0 then Frailty4=1; label Frailty4="Cachexia";
if f5>0 then Frailty5=1; label Frailty5="Debility ";
if f6>0 then Frailty6=1; label Frailty6="Difficulty in walking ";
if f7>0 then Frailty7=1; label Frailty7="Fall ";
if f8>0 then Frailty8=1; label Frailty8="Muscular wasting and disuse atrophy";
if f9>0 then Frailty9=1; label Frailty9="Muscle weakness";
if f10>0 then Frailty10=1; label Frailty10="Pressure Ulcer";
if f11>0 then Frailty11=1; label Frailty11="Senility without mention of psychosis";
if f12>0 then Frailty12=1; label Frailty12="Durable medical equipment";

keep bene_id Frailty1 Frailty2 Frailty3 Frailty4 Frailty5 Frailty6 Frailty7 Frailty8 Frailty9 Frailty10 Frailty11 Frailty12;
proc sort nodupkey;by bene_id;
proc freq;tables Frailty1 Frailty2 Frailty3 Frailty4 Frailty5 Frailty6 Frailty7 Frailty8 Frailty9 Frailty10 Frailty11 Frailty12;
run;
