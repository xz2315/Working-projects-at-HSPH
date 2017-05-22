*****************************************
Frailty Indicator & Chronic Condition 30's for Medicare 5% sample
Xiner Zhou
2/15/2017
*****************************************;
 
libname MedPar 'D:\Data\Medicare\MedPAR';
libname OP 'D:\Data\Medicare\Outpatient';
libname Carrier 'D:\Data\Medicare\Carrier';
libname HHA 'D:\Data\Medicare\HHA';
libname HOSPICE 'D:\Data\Medicare\Hospice';
libname SNF 'D:\Data\Medicare\SNF';
libname DME 'D:\Data\Medicare\DME';
libname IP 'D:\Data\Medicare\Inpatient';
 
libname data 'D:\Projects\Peterson\Data';

data Inptclms2010;
set IP.Inptclms2010 ;
PRNCPAL_DGNS_CD=DGNSCD1;
ICD_DGNS_CD1=DGNSCD2;
ICD_DGNS_CD2=DGNSCD3;
ICD_DGNS_CD3=DGNSCD4;
ICD_DGNS_CD4=DGNSCD5;
ICD_DGNS_CD5=DGNSCD6;
ICD_DGNS_CD6=DGNSCD7;
ICD_DGNS_CD7=DGNSCD8;
ICD_DGNS_CD8=DGNSCD9;
ICD_DGNS_CD9=DGNSCD10;
run;

data clm;
 length PRNCPAL_DGNS_CD 
ICD_DGNS_CD1 ICD_DGNS_CD2 ICD_DGNS_CD3 ICD_DGNS_CD4 ICD_DGNS_CD5
ICD_DGNS_CD6 ICD_DGNS_CD7 ICD_DGNS_CD8 ICD_DGNS_CD9 ICD_DGNS_CD10 ICD_DGNS_CD11 ICD_DGNS_CD12 ICD_DGNS_CD13 ICD_DGNS_CD14
ICD_DGNS_CD15 ICD_DGNS_CD16 ICD_DGNS_CD17 ICD_DGNS_CD18 ICD_DGNS_CD19 ICD_DGNS_CD20 ICD_DGNS_CD21 ICD_DGNS_CD22 ICD_DGNS_CD23
ICD_DGNS_CD24 ICD_DGNS_CD25 $20.;
set  Inptclms2010(keep=bene_id PRNCPAL_DGNS_CD 
ICD_DGNS_CD1 ICD_DGNS_CD2 ICD_DGNS_CD3 ICD_DGNS_CD4 ICD_DGNS_CD5
ICD_DGNS_CD6 ICD_DGNS_CD7 ICD_DGNS_CD8 ICD_DGNS_CD9 )

OP.Otptclms2010(keep=bene_id PRNCPAL_DGNS_CD 
ICD_DGNS_CD1 ICD_DGNS_CD2 ICD_DGNS_CD3 ICD_DGNS_CD4 ICD_DGNS_CD5
ICD_DGNS_CD6 ICD_DGNS_CD7 ICD_DGNS_CD8 ICD_DGNS_CD9 ICD_DGNS_CD10 ICD_DGNS_CD11 ICD_DGNS_CD12 ICD_DGNS_CD13 ICD_DGNS_CD14
ICD_DGNS_CD15 ICD_DGNS_CD16 ICD_DGNS_CD17 ICD_DGNS_CD18 ICD_DGNS_CD19 ICD_DGNS_CD20 ICD_DGNS_CD21 ICD_DGNS_CD22 ICD_DGNS_CD23
ICD_DGNS_CD24 ICD_DGNS_CD25  )

Carrier.Bcarclms2010(keep=bene_id PRNCPAL_DGNS_CD 
ICD_DGNS_CD1 ICD_DGNS_CD2 ICD_DGNS_CD3 ICD_DGNS_CD4 ICD_DGNS_CD5
ICD_DGNS_CD6 ICD_DGNS_CD7 ICD_DGNS_CD8 ICD_DGNS_CD9 ICD_DGNS_CD10 ICD_DGNS_CD11 ICD_DGNS_CD12)

HHA.Hhaclms2010(keep=bene_id PRNCPAL_DGNS_CD 
ICD_DGNS_CD1 ICD_DGNS_CD2 ICD_DGNS_CD3 ICD_DGNS_CD4 ICD_DGNS_CD5
ICD_DGNS_CD6 ICD_DGNS_CD7 ICD_DGNS_CD8 ICD_DGNS_CD9 ICD_DGNS_CD10 ICD_DGNS_CD11 ICD_DGNS_CD12 ICD_DGNS_CD13 ICD_DGNS_CD14
ICD_DGNS_CD15 ICD_DGNS_CD16 ICD_DGNS_CD17 ICD_DGNS_CD18 ICD_DGNS_CD19 ICD_DGNS_CD20 ICD_DGNS_CD21 ICD_DGNS_CD22 ICD_DGNS_CD23
ICD_DGNS_CD24 ICD_DGNS_CD25  )

Hospice.Hspcclms2010(keep=bene_id PRNCPAL_DGNS_CD 
ICD_DGNS_CD1 ICD_DGNS_CD2 ICD_DGNS_CD3 ICD_DGNS_CD4 ICD_DGNS_CD5
ICD_DGNS_CD6 ICD_DGNS_CD7 ICD_DGNS_CD8 ICD_DGNS_CD9 ICD_DGNS_CD10 ICD_DGNS_CD11 ICD_DGNS_CD12 ICD_DGNS_CD13 ICD_DGNS_CD14
ICD_DGNS_CD15 ICD_DGNS_CD16 ICD_DGNS_CD17 ICD_DGNS_CD18 ICD_DGNS_CD19 ICD_DGNS_CD20 ICD_DGNS_CD21 ICD_DGNS_CD22 ICD_DGNS_CD23
ICD_DGNS_CD24 ICD_DGNS_CD25  )

SNF.SNFclms2010(keep=bene_id PRNCPAL_DGNS_CD 
ICD_DGNS_CD1 ICD_DGNS_CD2 ICD_DGNS_CD3 ICD_DGNS_CD4 ICD_DGNS_CD5
ICD_DGNS_CD6 ICD_DGNS_CD7 ICD_DGNS_CD8 ICD_DGNS_CD9 ICD_DGNS_CD10 ICD_DGNS_CD11 ICD_DGNS_CD12 ICD_DGNS_CD13 ICD_DGNS_CD14
ICD_DGNS_CD15 ICD_DGNS_CD16 ICD_DGNS_CD17 ICD_DGNS_CD18 ICD_DGNS_CD19 ICD_DGNS_CD20 ICD_DGNS_CD21 ICD_DGNS_CD22 ICD_DGNS_CD23
ICD_DGNS_CD24 ICD_DGNS_CD25  )


DME.DMEclms2010(keep=bene_id PRNCPAL_DGNS_CD 
ICD_DGNS_CD1 ICD_DGNS_CD2 ICD_DGNS_CD3 ICD_DGNS_CD4 ICD_DGNS_CD5
ICD_DGNS_CD6 ICD_DGNS_CD7 ICD_DGNS_CD8 ICD_DGNS_CD9 ICD_DGNS_CD10 ICD_DGNS_CD11 ICD_DGNS_CD12);
 
dx1=PRNCPAL_DGNS_CD; 
dx2=ICD_DGNS_CD1; 
dx3=ICD_DGNS_CD2; 
dx4=ICD_DGNS_CD3; 
dx5=ICD_DGNS_CD4;
dx6=ICD_DGNS_CD5;
dx7=ICD_DGNS_CD6;
dx8=ICD_DGNS_CD7;
dx9=ICD_DGNS_CD8;
dx10=ICD_DGNS_CD9;
dx11=ICD_DGNS_CD10;
dx12=ICD_DGNS_CD11;
dx13=ICD_DGNS_CD12;
dx14=ICD_DGNS_CD13;
dx15=ICD_DGNS_CD14;
dx16=ICD_DGNS_CD15;
dx17=ICD_DGNS_CD16;
dx18=ICD_DGNS_CD17;
dx19=ICD_DGNS_CD18;
dx20=ICD_DGNS_CD19;
dx21=ICD_DGNS_CD20;
dx22=ICD_DGNS_CD21;
dx23=ICD_DGNS_CD22;
dx24=ICD_DGNS_CD23;
dx25=ICD_DGNS_CD24;
dx26=ICD_DGNS_CD25;
keep bene_id dx1-dx26;
run;

 

data rev;
set OP.Otptrev2010(keep=bene_id HCPCS_CD)  Carrier.Bcarline2010(keep=bene_id HCPCS_CD) 
HHA.Hharev2010(keep=bene_id HCPCS_CD) Hospice.Hspcrev2010(keep=bene_id HCPCS_CD) SNF.SNFrev2010(keep=bene_id HCPCS_CD) DME.DMEline2010(keep=bene_id HCPCS_CD);
proc sort nodupkey;by bene_id HCPCS_CD;
run;


libname HCC 'D:\Projects\Peterson';
 

 

proc sql;
create table clm1 as
select bene_id, 
case when  (dx1 in ("7812") or dx2 in ("7812") or dx3 in ("7812") or dx4 in ("7812") or dx5 in ("7812") or dx6  in ("7812") or dx7  in ("7812") or dx8  in ("7812") or dx9  in ("7812") or dx10  in ("7812") 
or dx11  in ("7812") or dx12  in ("7812") or dx13  in ("7812") or dx14  in ("7812") or dx15  in ("7812") or dx16  in ("7812") or dx17  in ("7812") 
or dx18  in ("7812") or dx19  in ("7812") or dx20  in ("7812") or dx21  in ("7812") or dx22  in ("7812") or dx23  in ("7812") or dx24  in ("7812") or dx25  in ("7812") or dx26  in ("7812") )
then 1 else 0 end as Frail1 , 
case when  (dx1 in (select ICD from HCC.Icd2hccxw2013 where HCC=21) or dx2 in (select ICD from HCC.Icd2hccxw2014 where HCC=21) or dx3 in (select ICD from HCC.Icd2hccxw2014 where HCC=21)  
or dx4 in (select ICD from HCC.Icd2hccxw2013 where HCC=21)  or dx5 in (select ICD from HCC.Icd2hccxw2013 where HCC=21)  or dx6 in (select ICD from HCC.Icd2hccxw2013 where HCC=21)  or dx7 in (select ICD from HCC.Icd2hccxw2013 where HCC=21)  
or dx8 in (select ICD from HCC.Icd2hccxw2013 where HCC=21)  or dx9 in (select ICD from HCC.Icd2hccxw2013 where HCC=21)  or dx10 in (select ICD from HCC.Icd2hccxw2013 where HCC=21)  or dx11  in (select ICD from HCC.Icd2hccxw2013 where HCC=21) 
or dx12 in (select ICD from HCC.Icd2hccxw2013 where HCC=21)  or dx13 in (select ICD from HCC.Icd2hccxw2013 where HCC=21) or dx14 in (select ICD from HCC.Icd2hccxw2013 where HCC=21)  or dx15  in (select ICD from HCC.Icd2hccxw2013 where HCC=21) 
or dx16 in (select ICD from HCC.Icd2hccxw2013 where HCC=21)  or dx17 in (select ICD from HCC.Icd2hccxw2013 where HCC=21)  or dx18 in (select ICD from HCC.Icd2hccxw2013 where HCC=21)  or dx19 in (select ICD from HCC.Icd2hccxw2013 where HCC=21) 
or dx20 in (select ICD from HCC.Icd2hccxw2013 where HCC=21)  or dx21 in (select ICD from HCC.Icd2hccxw2013 where HCC=21)  or dx22 in (select ICD from HCC.Icd2hccxw2013 where HCC=21)  or dx23 in (select ICD from HCC.Icd2hccxw2013 where HCC=21) 
or dx24 in (select ICD from HCC.Icd2hccxw2013 where HCC=21)  or dx25 in (select ICD from HCC.Icd2hccxw2013 where HCC=21)  or dx26 in (select ICD from HCC.Icd2hccxw2013 where HCC=21) )
then 1 else 0 end as Frail2, 
case when  (dx1  in ("7837") or dx2 in ("7837") or dx3 in ("7837") or dx4 in ("7837") or dx5 in ("7837") or dx6 in ("7837") or dx7 in ("7837") or dx8 in ("7837") 
or dx9  in ("7837") or dx10 in ("7837") or dx11 in ("7837") or dx12 in ("7837") or dx13 in ("7837") or dx14 in ("7837") or dx15 in ("7837") or dx16 in ("7837") 
or dx17  in ("7837") or dx18 in ("7837") or dx19 in ("7837") or dx20 in ("7837") or dx21 in ("7837") or dx22 in ("7837") or dx23 in ("7837") or dx24 in ("7837") 
or dx25 in ("7837") or dx26 in ("7837") 
) then 1 else 0 end as Frail3, 
case when  (dx1 in ("7994") or dx2 in ("7994") or dx3 in ("7994") or dx4 in ("7994") or dx5 in ("7994") or dx6 in ("7994") 
or dx7 in ("7994") or dx8 in ("7994") or dx9 in ("7994") or dx10 in ("7994") or dx11 in ("7994") or dx12 in ("7994") 
or dx13 in ("7994") or dx14 in ("7994") or dx15 in ("7994") or dx16 in ("7994") or dx17 in ("7994") or dx18 in ("7994") 
or dx19 in ("7994") or dx20 in ("7994") or dx21 in ("7994") or dx22 in ("7994") or dx23 in ("7994") or dx24 in ("7994") or dx25 in ("7994") or dx26 in ("7994") 
) then 1 else 0 end as Frail4, 
case when  (dx1 in ("7993") or dx2 in ("7993") or dx3 in ("7993") or dx4 in ("7993") or dx5 in ("7993") or dx6 in ("7993") or dx7 in ("7993") or dx8 in ("7993") 
or dx9 in ("7993") or dx10 in ("7993") or dx11 in ("7993") or dx12 in ("7993") or dx13 in ("7993") or dx14 in ("7993") or dx15 in ("7993") or dx16 in ("7993")
or dx17 in ("7993") or dx18 in ("7993") or dx19 in ("7993") or dx20 in ("7993") or dx21 in ("7993") or dx22 in ("7993") or dx23 in ("7993") or dx24 in ("7993")
or dx25 in ("7993") or dx26 in ("7993")  )
then 1 else 0 end as Frail5, 
case when  (dx1 in ("7197") or dx2 in ("7197") or dx3 in ("7197") or dx4 in ("7197") or dx5 in ("7197") or dx6 in ("7197") or dx7 in ("7197") or dx8 in ("7197")
or dx9 in ("7197") or dx10 in ("7197") or dx11 in ("7197") or dx12 in ("7197") or dx13 in ("7197") or dx14 in ("7197") or dx15 in ("7197") or dx16 in ("7197")
or dx17 in ("7197") or dx18 in ("7197") or dx19 in ("7197") or dx20 in ("7197") or dx21 in ("7197") or dx22 in ("7197") or dx23 in ("7197") or dx24 in ("7197")
 or dx25 in ("7197")  or dx26 in ("7197")) then 1 else 0 end as Frail6, 
case when  (dx1 in ("V1588") or dx2 in ("V1588") or dx3 in ("V1588") or dx4 in ("V1588") or dx5 in ("V1588") or dx6 in ("V1588") or dx7 in ("V1588") or dx8 in ("V1588") 
or dx9 in ("V1588") or dx10 in ("V1588") or dx11 in ("V1588") or dx12 in ("V1588") or dx13 in ("V1588") or dx14 in ("V1588") or dx15 in ("V1588")
or dx16 in ("V1588") or dx17 in ("V1588") or dx18 in ("V1588") or dx19 in ("V1588") or dx20 in ("V1588") or dx21 in ("V1588") or dx22 in ("V1588")
or dx23 in ("V1588") or dx24 in ("V1588") or dx25 in ("V1588") or dx26 in ("V1588")  )
then 1 else 0 end as Frail7, 
case when  (dx1 in ("7282") or dx2 in ("7282") or dx3 in ("7282") or dx4 in ("7282") or dx5 in ("7282") or dx6 in ("7282") or dx7 in ("7282") or dx8 in ("7282") 
or dx9 in ("7282") or dx10 in ("7282") or dx11 in ("7282") or dx12 in ("7282") or dx13 in ("7282") or dx14 in ("7282") or dx15 in ("7282")
or dx16 in ("7282") or dx17 in ("7282") or dx18 in ("7282") or dx19 in ("7282") or dx20 in ("7282") or dx21 in ("7282") or dx22 in ("7282")
or dx23 in ("7282") or dx24 in ("7282") or dx25 in ("7282") or dx26 in ("7282")) 
then 1 else 0 end as Frail8, 
case when  (dx1 in ("72887") or dx2 in ("72887") or dx3 in ("72887") or dx4 in ("72887") or dx5 in ("72887") or dx6 in ("72887") or dx7 in ("72887") 
or dx8 in ("72887") or dx9 in ("72887") or dx10 in ("72887") or dx11 in ("72887") or dx12 in ("72887") or dx13 in ("72887") or dx14 in ("72887") 
or dx15 in ("72887") or dx16 in ("72887") or dx17 in ("72887") or dx18 in ("72887") or dx19 in ("72887") or dx20 in ("72887") or dx21 in ("72887") 
or dx22 in ("72887") or dx23 in ("72887") or dx24 in ("72887") or dx25 in ("72887") or dx26 in ("72887")) 
then 1 else 0 end as Frail9, 
case when  (dx1 in (select ICD from HCC.Icd2hccxw2013 where HCC=148) or dx2 in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or dx3 in (select ICD from HCC.Icd2hccxw2014 where HCC=148) 
or dx4 in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or dx5 in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or dx6 in (select ICD from HCC.Icd2hccxw2014 where HCC=148) 
or dx7 in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or dx8 in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or dx9 in (select ICD from HCC.Icd2hccxw2014 where HCC=148) 
or dx10 in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or dx11 in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or dx12 in (select ICD from HCC.Icd2hccxw2014 where HCC=148)
or dx13 in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or dx14 in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or dx15 in (select ICD from HCC.Icd2hccxw2014 where HCC=148)
or dx16 in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or dx17 in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or dx18 in (select ICD from HCC.Icd2hccxw2014 where HCC=148)
or dx19 in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or dx20 in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or dx21 in (select ICD from HCC.Icd2hccxw2014 where HCC=148)
or dx22 in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or dx23 in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or dx24 in (select ICD from HCC.Icd2hccxw2014 where HCC=148)
or dx25 in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or dx26 in (select ICD from HCC.Icd2hccxw2014 where HCC=148)  
)
then 1 else 0 end as Frail10, 
case when  (dx1 in ("797") or dx2 in ("797") or dx3 in ("797") or dx4 in ("797") or dx5 in ("797") or dx6 in ("797") or dx7 in ("797") or dx8 in ("797") or dx9 in ("797") or dx10 in ("797")
or dx11 in ("797") or dx12 in ("797") or dx13 in ("797") or dx14 in ("797") or dx15 in ("797") or dx16 in ("797") or dx17 in ("797") or dx18 in ("797") or dx19 in ("797") or dx20 in ("797")
or dx21 in ("797") or dx22 in ("797") or dx23 in ("797") or dx24 in ("797") or dx25 in ("797") or dx26 in ("797")
) then 1 else 0 end as Frail11  
from clm;
quit;

proc sql;
create table rev1 as
select bene_id, 
case when  HCPCS_CD in ('E0100', 'E0105', 'E0130', 'E0135', 'E0140', 'E0141', 'E0143', 'E0144', 'E0147', 'E0148', 'E0149', 'E0160', 'E0161','E0162','E0163','E0164','E0165','E0166','E0167','E0168','E0169','E0170','E0171') 
then 1 else 0 end as frail12 
from rev;
quit;
  

data temp; 
set clm1 rev1;
proc sort;by bene_id;
run;

proc sql;
create table temp1 as
select bene_id, sum(frail1) as f1, sum(frail2) as f2, sum(frail3) as f3, sum(frail4) as f4, sum(frail5) as f5, sum(frail6) as f6,
sum(frail7) as f7, sum(frail8) as f8, sum(frail9) as f9, sum(frail10) as f10, sum(frail11) as f11, sum(frail12) as f12
from temp
group by bene_id;
quit;

data data.Frailty2010;
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
