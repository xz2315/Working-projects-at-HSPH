************************************************************************************
Persistent Medicare HC 2012-2014 -Jose
Predictive Modeling 
Xiner Zhou
3/21/2017
************************************************************************************;
libname data 'D:\Projects\High Cost Segmentation Phase II\Data';
libname denom 'D:\Data\Medicare\Denominator';
libname stdcost 'D:\Data\Medicare\StdCost\Data';
libname frail 'D:\data\Medicare\Frailty Indicator';
libname CCW 'D:\data\Medicare\MBSF CC';


* Demographics: Dual status ;
proc sql;
create table temp1 as
select a.*,case when b.BUYIN_MO>0 then 1 else 0 end as Dual 
from data.PlanABene a left join denom.dnmntr2012 b
on a.bene_id=b.bene_id;
quit;

* segment;
proc sql;
create table temp2 as
select a.*,b.seg as seg2012
from  temp1 a left join data.segment2012  b
on a.bene_id=b.bene_id;
quit;
proc sql;
create table temp3 as
select a.*,b.seg as seg2013
from  temp2 a left join data.segment2013  b
on a.bene_id=b.bene_id;
quit;
proc sql;
create table temp4 as
select a.*,b.seg as seg2014
from  temp3 a left join data.segment2014  b
on a.bene_id=b.bene_id;
quit;
 
 
* Frailty;
proc sql;
create table temp5 as
select a.*,
b.Frailty1 as Frailty12012, b.Frailty2 as Frailty22012, b.Frailty3 as Frailty32012, b.Frailty4 as Frailty42012,
b.Frailty5 as Frailty52012, b.Frailty6 as Frailty62012, b.Frailty7 as Frailty72012, b.Frailty8 as Frailty82012,
b.Frailty9 as Frailty92012, b.Frailty10 as Frailty102012, b.Frailty11 as Frailty112012, b.Frailty12 as Frailty122012 
from temp4 a left join Frail.Frailty2012 b
on a.bene_id=b.bene_id;
quit;
 
proc sql;
create table temp6 as
select a.*,
b.Frailty1 as Frailty12013, b.Frailty2 as Frailty22013, b.Frailty3 as Frailty32013, b.Frailty4 as Frailty42013,
b.Frailty5 as Frailty52013, b.Frailty6 as Frailty62013, b.Frailty7 as Frailty72013, b.Frailty8 as Frailty82013,
b.Frailty9 as Frailty92013, b.Frailty10 as Frailty102013, b.Frailty11 as Frailty112013, b.Frailty12 as Frailty122013
from temp5 a left join Frail.Frailty2013 b
on a.bene_id=b.bene_id;
quit;

proc sql;
create table temp7 as
select a.*,
b.Frailty1 as Frailty12014, b.Frailty2 as Frailty22014, b.Frailty3 as Frailty32014, b.Frailty4 as Frailty42014,
b.Frailty5 as Frailty52014, b.Frailty6 as Frailty62014, b.Frailty7 as Frailty72014, b.Frailty8 as Frailty82014,
b.Frailty9 as Frailty92014, b.Frailty10 as Frailty102014, b.Frailty11 as Frailty112014, b.Frailty12 as Frailty122014 
from temp6 a left join Frail.Frailty2014 b
on a.bene_id=b.bene_id;
quit;


data temp8;
set temp7;
 
array temp {36} 
Frailty12012 Frailty22012 Frailty32012 Frailty42012 Frailty52012 Frailty62012 Frailty72012 Frailty82012 Frailty92012 Frailty102012 Frailty112012 Frailty122012 
Frailty12013 Frailty22013 Frailty32013 Frailty42013 Frailty52013 Frailty62013 Frailty72013 Frailty82013 Frailty92013 Frailty102013 Frailty112013 Frailty122013 
Frailty12014 Frailty22014 Frailty32014 Frailty42014 Frailty52014 Frailty62014 Frailty72014 Frailty82014 Frailty92014 Frailty102014 Frailty112014 Frailty122014;


do i=1 to 36;
	if temp{i}=. then temp{i}=0;
end;drop i;
 

N_Frailty2012=Frailty12012+Frailty22012+Frailty32012+Frailty42012+Frailty52012+Frailty62012+Frailty72012+Frailty82012+Frailty92012+Frailty102012+Frailty112012+Frailty122012;
N_Frailty2013=Frailty12013+Frailty22013+Frailty32013+Frailty42013+Frailty52013+Frailty62013+Frailty72013+Frailty82013+Frailty92013+Frailty102013+Frailty112013+Frailty122013;
N_Frailty2014=Frailty12014+Frailty22014+Frailty32014+Frailty42014+Frailty52014+Frailty62014+Frailty72014+Frailty82014+Frailty92014+Frailty102014+Frailty112014+Frailty122014;
zip=substr(BENE_ZIP,1,5);
run;
 
 
* City health outcome measure;
proc sql;
create table temp9 as
select a.*,b.*
from temp8 a left join data.CityMeasure b
on a.zip=b.zip;
quit;
proc freq data=temp9;tables flag/missing;run;

* CCW;
proc sql;
create table temp10 as
select a.*,b.AMI,b.ALZH,b.ALZHDMTA,b.ATRIALFB,b.CATARACT,b.CHRNKIDN,b.COPD,b.CHF,b.DIABETES,b.GLAUCOMA,b.HIPFRAC,
b.ISCHMCHT,b.DEPRESSN,b.OSTEOPRS,b.RA_OA,b.STRKETIA,b.CNCRBRST,b.CNCRCLRC,b.CNCRPRST,b.CNCRLUNG,b.CNCRENDM,
b.ANEMIA,b.ASTHMA,b.HYPERL,b.HYPERP,b.HYPERT,b.HYPOTH
from temp9 a left join CCW.Mbsf_cc2012 b
on a.bene_id=b.bene_id;
quit;

data temp11;
set temp10;
array cond{27} 
 AMI ALZH ALZHDMTA ATRIALFB CATARACT CHRNKIDN COPD CHF DIABETES GLAUCOMA HIPFRAC 
 ISCHMCHT DEPRESSN OSTEOPRS RA_OA STRKETIA CNCRBRST CNCRCLRC CNCRPRST CNCRLUNG CNCRENDM 
 ANEMIA ASTHMA HYPERL HYPERP HYPERT HYPOTH;
do j=1 to 27;
if cond{j} in (1,3) then cond{j}=1;
else cond{j}=0;
end;
drop j;
run;

/*
Question: How much additional spending, given a certain mental health condition, adjusting for other factors?
*/

ODS Listing CLOSE;
ODS html file="D:\Projects\High Cost Segmentation Phase II\Predict Cost 2012.xls" style=minimal;
 
proc glm data=temp11;
class AgeGroup Sex RaceGroup Dual
ADHD2012 ADHD2013 ADHD2014
Anxiety2012 Anxiety2013 Anxiety2014
Autism2012 Autism2013 Autism2014
Bipolar2012 Bipolar2013 Bipolar2014 
Cerebral2012 Cerebral2013 Cerebral2014 
Depression2012 Depression2013 Depression2014
Fibromyalgia2012 Fibromyalgia2013 Fibromyalgia2014
Intellectual2012 Intellectual2013 Intellectual2014
Personality2012 Personality2013 Personality2014
PTSD2012 PTSD2013 PTSD2014
Schizophrenia2012 Schizophrenia2013 Schizophrenia2014
OtherPsychotic2012 OtherPsychotic2013 OtherPsychotic2014
Frailty12012 Frailty22012 Frailty32012 Frailty42012 Frailty52012 Frailty62012 Frailty72012 Frailty82012 Frailty92012 Frailty102012 Frailty112012 Frailty122012 
AMI ALZH ALZHDMTA ATRIALFB CATARACT CHRNKIDN COPD CHF DIABETES GLAUCOMA HIPFRAC 
 ISCHMCHT DEPRESSN OSTEOPRS RA_OA STRKETIA CNCRBRST CNCRCLRC CNCRPRST CNCRLUNG CNCRENDM 
 ANEMIA ASTHMA HYPERL HYPERP HYPERT HYPOTH;

model stdcost2012=Age Sex RaceGroup Dual
ADHD2012  Anxiety2012 Autism2012  Bipolar2012  Cerebral2012  Depression2012  
Fibromyalgia2012  Intellectual2012  Personality2012  PTSD2012  Schizophrenia2012  OtherPsychotic2012

AMI ALZH ALZHDMTA ATRIALFB CATARACT CHRNKIDN COPD CHF DIABETES GLAUCOMA HIPFRAC 
 ISCHMCHT DEPRESSN OSTEOPRS RA_OA STRKETIA CNCRBRST CNCRCLRC CNCRPRST CNCRLUNG CNCRENDM 
 ANEMIA ASTHMA HYPERL HYPERP HYPERT HYPOTH
/solution p clm ;
run;
   ODS html close;
ODS Listing;  
 


Frailty12012 Frailty22012 Frailty32012 Frailty42012 Frailty52012 Frailty62012 Frailty72012 Frailty82012 Frailty92012 Frailty102012 Frailty112012 Frailty122012 
