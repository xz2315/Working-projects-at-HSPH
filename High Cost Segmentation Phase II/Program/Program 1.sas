****************************************
High Cost/High Need Segmentation Phase II
Program 1: Prepare Analytic Dataset
11/1/2016
****************************************;
libname denom 'C:\data\Data\Medicare\Denominator';
libname stdcost 'C:\data\Data\Medicare\StdCost\Data';
libname frail 'I:\Data\Medicare\Frailty Indicator';
libname cc 'C:\data\Data\Medicare\MBSF CC';

/* Select Patients in FFS for entire 3 years, and keep Patient Demographic info:
Age, Race, Sex, ZIP
Note: This will automatically drop those who died, and newly became eligible for Medicare
*/

* Select 20% Sample;
data Patienttotalcost2012;
set stdcost.Patienttotalcost2012;
if STRCTFLG ne '' and keep=1; *if fullAB =1 and HMO =0 and DEATH_DT=. and State_CD*1 ne 40 and State_CD*1>=1 and State_CD*1<=53 ;
run;
data Patienttotalcost2013;
set stdcost.Patienttotalcost2013;
if STRCTFLG ne '' and keep=1;
run;
data Patienttotalcost2014;
set stdcost.Patienttotalcost2014;
if STRCTFLG ne '' and keep=1;
run;

data temp;
set Patienttotalcost2012(in=in1) Patienttotalcost2013(in=in2) Patienttotalcost2014(in=in3) ;
if in1 then year=2012;
if in2 then year=2013;
if in3 then year=2014;

keep bene_id year STRCTFLG keep;proc sort nodupkey;by bene_id year; 
run;

proc sql;
create table temp1 as
select bene_id, case when count(*)=3 then 1 else 0 end as in3Yr 
from temp
group by bene_id;
quit;

data in3Yr20pct;
set temp1;
if in3Yr=1;
proc sort nodupkey;by bene_id;
run;

/* Patient Cost info:
IP, OP, Carrier, SNF, HHA, Hospice, DME, and Total
*/
%macro merge(yr=,left=, out=);

proc sql;
create table &out. as
select a.*, b.STATE_CD as STATE_CD&yr.,b.CNTY_CD as CNTY_CD&yr.,  b.BENE_ZIP  as BENE_ZIP&yr., b.AGE  as AGE&yr., b.SEX  as SEX&yr.,b.RACE as RACE&yr.,  
b.stdcostIP1 as stdcostIP1&yr.,  b.actualIP1 as actualIP1&yr.,  b.stdcostIP2 as stdcostIP2&yr., b.actualIP2 as actualIP2&yr.,  
b.stdcostIP3 as stdcostIP3&yr.,  b.actualIP3 as actualIP3&yr., b.stdcostIP4 as stdcostIP4&yr.,  b.actualIP4  as actualIP4&yr.,  
b.stdcostIP5 as stdcostIP5&yr.,  b.actualIP5  as actualIP5&yr., b.stdcostIP6 as stdcostIP6&yr., b.actualIP6 as actualIP6&yr.,  
b.stdcostOP as stdcostOP&yr.,  b.actualOP as actualOP&yr., b.stdcostcar1 as stdcostcar1&yr.,  b.actualcar1  as actualcar1&yr.,  
b.stdcostcar2 as stdcostcar2&yr.,  b.actualcar2 as actualcar2&yr.,  b.stdcostcar3 as stdcostcar3&yr.,  b.actualcar3   as actualcar3&yr.,
b.stdcostcar4  as stdcostcar4&yr., b.actualcar4 as actualcar4&yr.,  b.stdcostcar5 as stdcostcar5&yr., b.actualcar5 as actualcar5&yr.,  
b.stdcostcar6 as stdcostcar6&yr.,  b.actualcar6  as actualcar6&yr.,  b.stdcostcar7 as stdcostcar7&yr.,  b.actualcar7  as actualcar7&yr.,
b.stdcostHHA as stdcostHHA&yr.,  b.actualHHA as actualHHA&yr.,  b.stdcostSNF as stdcostSNF&yr.,  b.actualSNF  as actualSNF&yr.,
b.stdcostHospice as stdcostHospice&yr., b.actualHospice as actualHospice&yr.,  b.stdcostDME as stdcostDME&yr.,  b.actualDME as actualDME&yr.,  
b.stdcostIP as stdcostIP&yr.,b.stdcostcar as stdcostcar&yr.,  b.actualIP as actualIP&yr., b.actualcar as actualcar&yr., 
b.stdcost as stdcost&yr.,  b.actual as actual&yr.
from &left. a left join  Patienttotalcost&yr.  b
on a.bene_id=b.bene_id;
quit;
%mend merge;
%merge(yr=2012,left=in3Yr20pct, out=temp1);
%merge(yr=2013,left=temp1, out=temp2);
%merge(yr=2014,left=temp2, out=temp3);

proc rank data=temp3 out=temp4  percent;
var actual2012 stdcost2012 actual2013 stdcost2013 actual2014 stdcost2014;
ranks actual2012r stdcost2012r actual2013r stdcost2013r actual2014r stdcost2014r ;
run;

data temp5;
set temp4;
if  actual2012r>=95 then HC5_actual2012=1;else HC5_actual2012=0;
if  actual2012r>=90 then HC10_actual2012=1;else HC10_actual2012=0;
if  actual2012r>=75 then HC25_actual2012=1;else HC25_actual2012=0;

if  stdcost2012r>=95 then HC5_stdcost2012=1;else HC5_stdcost2012=0;
if  stdcost2012r>=90 then HC10_stdcost2012=1;else HC10_stdcost2012=0;
if  stdcost2012r>=75 then HC25_stdcost2012=1;else HC25_stdcost2012=0; 

if  actual2013r>=95 then HC5_actual2013=1;else HC5_actual2013=0;
if  actual2013r>=90 then HC10_actual2013=1;else HC10_actual2013=0;
if  actual2013r>=75 then HC25_actual2013=1;else HC25_actual2013=0;

if  stdcost2013r>=95 then HC5_stdcost2013=1;else HC5_stdcost2013=0;
if  stdcost2013r>=90 then HC10_stdcost2013=1;else HC10_stdcost2013=0;
if  stdcost2013r>=75 then HC25_stdcost2013=1;else HC25_stdcost2013=0;

if  actual2014r>=95 then HC5_actual2014=1;else HC5_actual2014=0;
if  actual2014r>=90 then HC10_actual2014=1;else HC10_actual2014=0;
if  actual2014r>=75 then HC25_actual2014=1;else HC25_actual2014=0;

if  stdcost2014r>=95 then HC5_stdcost2014=1;else HC5_stdcost2014=0;
if  stdcost2014r>=90 then HC10_stdcost2014=1;else HC10_stdcost2014=0;
if  stdcost2014r>=75 then HC25_stdcost2014=1;else HC25_stdcost2014=0;
proc freq;  
tables HC5_actual2012 HC10_actual2012 HC25_actual2012 HC5_stdcost2012 HC10_stdcost2012 HC25_stdcost2012
HC5_actual2013 HC10_actual2013 HC25_actual2013 HC5_stdcost2013 HC10_stdcost2013 HC25_stdcost2013
HC5_actual2014 HC10_actual2014 HC25_actual2014 HC5_stdcost2014 HC10_stdcost2014 HC25_stdcost2014
HC10_actual2012*HC10_actual2013 HC10_actual2013*HC10_actual2014/missing;
run;

/* Segment(Rob defined), CC and Frailty*/
libname seg 'C:\data\Projects\High_Cost_Segmentation\Data';
proc sql;
create table temp6 as
select a.*,floor(b.segsumm_hc) as seg
from  temp5 a left join seg.segmentsendbenehc2012_2  b
on a.bene_id=b.bene_id;
quit;

*  Dual status ;
proc sql;
create table temp7 as
select a.*,case when b.BUYIN_MO>1 then 1 else 0 end as Dual2012
from temp6 a left join denom.dnmntr2012 b
on a.bene_id=b.bene_id;
quit;
proc sql;
create table temp8 as
select a.*,case when b.BUYIN_MO>1 then 1 else 0 end as Dual2013
from temp7 a left join denom.dnmntr2013 b
on a.bene_id=b.bene_id;
quit;
proc sql;
create table temp9 as
select a.*,case when b.BUYIN_MO>1 then 1 else 0 end as Dual2014
from temp8 a left join denom.dnmntr2014 b
on a.bene_id=b.bene_id;
quit;
proc sql;
create table temp10 as
select a.*,b.AMI as AMI2012,b.ALZH as ALZH2012,b.ALZHDMTA as ALZHDMTA2012,b.ATRIALFB as ATRIALFB2012,
b.CATARACT as CATARACT2012, b.CHRNKIDN as CHRNKIDN2012, b.COPD as COPD2012,b.CHF as CHF2012,b.DIABETES as DIABETES2012,
b.GLAUCOMA as GLAUCOMA2012, b.HIPFRAC as HIPFRAC2012 ,b.ISCHMCHT as ISCHMCHT2012 ,b.DEPRESSN as DEPRESSN2012, 
b.OSTEOPRS as OSTEOPRS2012, b.RA_OA as RA_OA2012, b.STRKETIA as STRKETIA2012, b.CNCRBRST as CNCRBRST2012,
b.CNCRCLRC as CNCRCLRC2012,b.CNCRPRST as CNCRPRST2012, b.CNCRLUNG as CNCRLUNG2012,b.CNCRENDM as CNCRENDM2012,
b.ANEMIA as ANEMIA2012, b.ASTHMA as ASTHMA2012, b.HYPERL as HYPERL2012, b.HYPERP as HYPERP2012, b.HYPERT as HYPERT2012, b.HYPOTH as HYPOTH2012
from temp9 a left join cc.Mbsf_cc2012 b
on a.bene_id=b.bene_id;
quit;
proc sql;
create table temp11 as
select a.*,b.AMI as AMI2013,b.ALZH as ALZH2013,b.ALZHDMTA as ALZHDMTA2013,b.ATRIALFB as ATRIALFB2013,
b.CATARACT as CATARACT2013, b.CHRNKIDN as CHRNKIDN2013, b.COPD as COPD2013,b.CHF as CHF2013,b.DIABETES as DIABETES2013,
b.GLAUCOMA as GLAUCOMA2013, b.HIPFRAC as HIPFRAC2013 ,b.ISCHMCHT as ISCHMCHT2013 ,b.DEPRESSN as DEPRESSN2013, 
b.OSTEOPRS as OSTEOPRS2013, b.RA_OA as RA_OA2013, b.STRKETIA as STRKETIA2013, b.CNCRBRST as CNCRBRST2013,
b.CNCRCLRC as CNCRCLRC2013,b.CNCRPRST as CNCRPRST2013, b.CNCRLUNG as CNCRLUNG2013,b.CNCRENDM as CNCRENDM2013,
b.ANEMIA as ANEMIA2013, b.ASTHMA as ASTHMA2013, b.HYPERL as HYPERL2013, b.HYPERP as HYPERP2013, b.HYPERT as HYPERT2013, b.HYPOTH as HYPOTH2013
from temp10 a left join cc.Mbsf_cc2013 b
on a.bene_id=b.bene_id;
quit;
proc sql;
create table temp12 as
select a.*,b.AMI as AMI2014,b.ALZH as ALZH2014,b.ALZHDMTA as ALZHDMTA2014,b.ATRIALFB as ATRIALFB2014,
b.CATARACT as CATARACT2014, b.CHRNKIDN as CHRNKIDN2014, b.COPD as COPD2014,b.CHF as CHF2014,b.DIABETES as DIABETES2014,
b.GLAUCOMA as GLAUCOMA2014, b.HIPFRAC as HIPFRAC2014 ,b.ISCHMCHT as ISCHMCHT2014 ,b.DEPRESSN as DEPRESSN2014, 
b.OSTEOPRS as OSTEOPRS2014, b.RA_OA as RA_OA2014, b.STRKETIA as STRKETIA2014, b.CNCRBRST as CNCRBRST2014,
b.CNCRCLRC as CNCRCLRC2014,b.CNCRPRST as CNCRPRST2014, b.CNCRLUNG as CNCRLUNG2014,b.CNCRENDM as CNCRENDM2014,
b.ANEMIA as ANEMIA2014, b.ASTHMA as ASTHMA2014, b.HYPERL as HYPERL2014, b.HYPERP as HYPERP2014, b.HYPERT as HYPERT2014, b.HYPOTH as HYPOTH2014
from temp11 a left join cc.Mbsf_cc2014 b
on a.bene_id=b.bene_id;
quit;

 
proc sql;
create table temp13 as
select a.*,b.frailty1 as frailty12012,b.frailty2 as frailty22012,b.frailty3 as frailty32012,b.frailty4 as frailty42012,
b.frailty5 as frailty52012,b.frailty6 as frailty62012,b.frailty7 as frailty72012,b.frailty8 as frailty82012,b.frailty9 as frailty92012,
b.frailty10 as frailty102012,b.frailty11 as frailty112012,b.frailty12 as frailty122012 
from temp12 a left join Frail.Frailty2012 b
on a.bene_id=b.bene_id;
quit;
proc sql;
create table temp14 as
select a.*,b.frailty1 as frailty12013,b.frailty2 as frailty22013,b.frailty3 as frailty32013,b.frailty4 as frailty42013,
b.frailty5 as frailty52013,b.frailty6 as frailty62013,b.frailty7 as frailty72013,b.frailty8 as frailty82013,b.frailty9 as frailty92013,
b.frailty10 as frailty102013,b.frailty11 as frailty112013,b.frailty12 as frailty122013 
from temp13 a left join Frail.Frailty2013 b
on a.bene_id=b.bene_id;
quit;
proc sql;
create table temp15 as
select a.*,b.frailty1 as frailty12014,b.frailty2 as frailty22014,b.frailty3 as frailty32014,b.frailty4 as frailty42014,
b.frailty5 as frailty52014,b.frailty6 as frailty62014,b.frailty7 as frailty72014,b.frailty8 as frailty82014,b.frailty9 as frailty92014,
b.frailty10 as frailty102014,b.frailty11 as frailty112014,b.frailty12 as frailty122014 
from temp14 a left join Frail.Frailty2014 b
on a.bene_id=b.bene_id;
quit;

data temp16;
set temp15;
array temp1 {81} 
AMI2012 ALZH2012 ALZHDMTA2012 ATRIALFB2012 CATARACT2012 CHRNKIDN2012 COPD2012 CHF2012 DIABETES2012
GLAUCOMA2012 HIPFRAC2012 ISCHMCHT2012 DEPRESSN2012 OSTEOPRS2012 RA_OA2012 STRKETIA2012 CNCRBRST2012 
CNCRCLRC2012 CNCRPRST2012 CNCRLUNG2012 CNCRENDM2012 ANEMIA2012 ASTHMA2012 HYPERL2012 HYPERP2012 HYPERT2012 HYPOTH2012
AMI2013 ALZH2013 ALZHDMTA2013 ATRIALFB2013 CATARACT2013 CHRNKIDN2013 COPD2013 CHF2013 DIABETES2013
GLAUCOMA2013 HIPFRAC2013 ISCHMCHT2013 DEPRESSN2013 OSTEOPRS2013 RA_OA2013 STRKETIA2013 CNCRBRST2013 
CNCRCLRC2013 CNCRPRST2013 CNCRLUNG2013 CNCRENDM2013 ANEMIA2013 ASTHMA2013 HYPERL2013 HYPERP2013 HYPERT2013 HYPOTH2013
AMI2014 ALZH2014 ALZHDMTA2014 ATRIALFB2014 CATARACT2014 CHRNKIDN2014 COPD2014 CHF2014 DIABETES2014
GLAUCOMA2014 HIPFRAC2014 ISCHMCHT2014 DEPRESSN2014 OSTEOPRS2014 RA_OA2014 STRKETIA2014 CNCRBRST2014 
CNCRCLRC2014 CNCRPRST2014 CNCRLUNG2014 CNCRENDM2014 ANEMIA2014 ASTHMA2014 HYPERL2014 HYPERP2014 HYPERT2014 HYPOTH2014;

do i=1 to 81;
if temp1{i}=. then temp1{i}=0;
end;
array temp2{36} 
frailty12012 frailty22012 frailty32012 frailty42012 frailty52012 frailty62012 frailty72012 frailty82012 frailty92012 frailty102012 frailty112012 frailty122012 
frailty12013 frailty22013 frailty32013 frailty42013 frailty52013 frailty62013 frailty72013 frailty82013 frailty92013 frailty102013 frailty112013 frailty122013 
frailty12014 frailty22014 frailty32014 frailty42014 frailty52014 frailty62014 frailty72014 frailty82014 frailty92014 frailty102014 frailty112014 frailty122014 ;
do j=1 to 36;
if temp2{j}=. then temp2{j}=0;
end;
drop i j;

* Persistent HC over time;
if HC10_stdcost2012=1 and HC10_stdcost2013=1  and  HC10_stdcost2014=1  then HCtime=1;
else if HC10_stdcost2012=0 and HC10_stdcost2013=0  and  HC10_stdcost2014=0  then HCtime=2;
else if HC10_stdcost2012=1 and HC10_stdcost2013=1  and  HC10_stdcost2014=0  then HCtime=3;
else if HC10_stdcost2012=1 and HC10_stdcost2013=0  and  HC10_stdcost2014=1  then HCtime=4;
else if HC10_stdcost2012=0 and HC10_stdcost2013=1  and  HC10_stdcost2014=1  then HCtime=5;
else if HC10_stdcost2012=1 and HC10_stdcost2013=0  and  HC10_stdcost2014=0  then HCtime=6;
else if HC10_stdcost2012=0 and HC10_stdcost2013=1  and  HC10_stdcost2014=0  then HCtime=7;
else if HC10_stdcost2012=0 and HC10_stdcost2013=0  and  HC10_stdcost2014=1  then HCtime=8;
proc freq ;tables HCtime/missing;
run;

/* Medicare Impact File:
Local Medicare Wage Index, Disproportionate Sghare Index payments, teaching intensity, charge-to-cost ratios
*/
libname impact 'C:\data\Data\Hospital\Impact';
proc sql;
create table impact as
select provider_Number as Provider, 
operating_CCR+capital_CCR as CCR label="charge-to-cost ratios",
FY_2013__Wage_Index as WI label="Local Medicare Wage Index",
Resident_to_Bed_Ratio as IRB label="teaching intensity",
DSHPCT label="Disproportionate Share Ratio"
from impact.Impact2013;
quit;

/* Hosital Consumer Assessment of Healthcare Providers and Syatems (HCAHPS) Survey:
Hospital ratings, communication with clinical staff, pain control, hospital enrironment, receiot of dischrage instructions
*/
libname compare 'C:\data\Data\Hospital\Hospital Compare\data';


* communication with doctor: always well;
* communication with nurse: always well;
* communication with med: always well;
* nurse service: always received;
* pain control: always well;
* room quite: always well;
* discharge info: yes;
* hospital rating: low;
* hospital rating: medium;
* hospital rating: high;

hosprate1 hosprate2 hosprate3
 commphy1 commnrs1 commmed1 nrssrv1 painctrl1 rmquiet1 dschrg2



/* Hospital Compare:
Concordance with recommendaed processes of care for AMI, CHF, PN
*/
 
/* Area Resource File (ARF):
Population characteristics(age, racial makeup), poverty, income, physicna and hospital supply
*/

/* Behavioral Risk-Factor Surveillance System (BRFSS):
http://www.cdc.gov/brfss/annual_data/annual_2012.html
*/
