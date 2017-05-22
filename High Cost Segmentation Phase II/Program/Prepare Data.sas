*******************************
Phase II of High-Need, High Cost Patient Segmentation: 
Understanding Who Becomes and Remains High-Cost/High Need Over Time 
and the Association with Mental Health Conditions
9/12/2016
*******************************;
libname denom 'C:\data\Data\Medicare\Denominator';
libname stdcost 'C:\data\Data\Medicare\StdCost\Data';
libname frail 'I:\Data\Medicare\Frailty Indicator';
libname cc 'C:\data\Data\Medicare\MBSF CC';

 

* Select 20% Sample;
data Patienttotalcost2012;
set stdcost.Patienttotalcost2012;
if STRCTFLG ne '' and keep=1;
run;
data Patienttotalcost2013;
set stdcost.Patienttotalcost2013;
if STRCTFLG ne '' and keep=1;
run;
data Patienttotalcost2014;
set stdcost.Patienttotalcost2014;
if STRCTFLG ne '' and keep=1;
run;

*Two Definitions of Transient-Persistent HC;

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
 
* Define HC (5% 10% 25%);
proc rank data=Patienttotalcost2012 out=Patienttotalcost2012_r  percent;
var actual stdcost;
ranks pct_actual pct_stdcost ;
run;

data Patienttotalcost2012_r;
set Patienttotalcost2012_r;
if pct_actual>=95 then HC5_actual=1;else HC5_actual=0;
if pct_actual>=90 then HC10_actual=1;else HC10_actual=0;
if pct_actual>=75 then HC25_actual=1;else HC25_actual=0;

if pct_stdcost>=95 then HC5_stdcost=1;else HC5_stdcost=0;
if pct_stdcost>=90 then HC10_stdcost=1;else HC10_stdcost=0;
if pct_stdcost>=75 then HC25_stdcost=1;else HC25_stdcost=0; 
proc freq;tables HC5_actual HC10_actual HC25_actual HC5_stdcost HC10_stdcost HC25_stdcost/missing;
run;

proc rank data=Patienttotalcost2013 out=Patienttotalcost2013_r  percent;
var actual stdcost;
ranks pct_actual pct_stdcost ;
run;

data Patienttotalcost2013_r;
set Patienttotalcost2013_r;
if pct_actual>=95 then HC5_actual=1;else HC5_actual=0;
if pct_actual>=90 then HC10_actual=1;else HC10_actual=0;
if pct_actual>=75 then HC25_actual=1;else HC25_actual=0;

if pct_stdcost>=95 then HC5_stdcost=1;else HC5_stdcost=0;
if pct_stdcost>=90 then HC10_stdcost=1;else HC10_stdcost=0;
if pct_stdcost>=75 then HC25_stdcost=1;else HC25_stdcost=0; 
proc freq;tables HC5_actual HC10_actual HC25_actual HC5_stdcost HC10_stdcost HC25_stdcost/missing;
run;

proc rank data= Patienttotalcost2014 out=Patienttotalcost2014_r  percent;
var actual stdcost;
ranks pct_actual pct_stdcost ;
run;

data Patienttotalcost2014_r;
set Patienttotalcost2014_r;
if pct_actual>=95 then HC5_actual=1;else HC5_actual=0;
if pct_actual>=90 then HC10_actual=1;else HC10_actual=0;
if pct_actual>=75 then HC25_actual=1;else HC25_actual=0;

if pct_stdcost>=95 then HC5_stdcost=1;else HC5_stdcost=0;
if pct_stdcost>=90 then HC10_stdcost=1;else HC10_stdcost=0;
if pct_stdcost>=75 then HC25_stdcost=1;else HC25_stdcost=0; 
proc freq;tables HC5_actual HC10_actual HC25_actual HC5_stdcost HC10_stdcost HC25_stdcost/missing;
run;



* Way 1: start 2012 everyong and project the path;
proc sql;
create table temp as
select a.*,b.in3Yr as in3Yr20pct
from Patienttotalcost2012_r a left join in3Yr20pct b
on a.bene_id=b.bene_id;
quit;

proc sql;
create table temp1 as
select a.*,
b.HC5_actual as HC5_actual2013,
b.HC10_actual as HC10_actual2013,
b.HC25_actual as HC25_actual2013,

b.HC5_stdcost as HC5_stdcost2013,
b.HC10_stdcost as HC10_stdcost2013,
b.HC25_stdcost as HC25_stdcost2013 

from temp a left join Patienttotalcost2013_r b
on a.bene_id=b.bene_id;
quit;

proc sql;
create table temp2 as
select a.*,
b.HC5_actual as HC5_actual2014,
b.HC10_actual as HC10_actual2014,
b.HC25_actual as HC25_actual2014,

b.HC5_stdcost as HC5_stdcost2014,
b.HC10_stdcost as HC10_stdcost2014,
b.HC25_stdcost as HC25_stdcost2014 

from temp1 a left join Patienttotalcost2014_r b
on a.bene_id=b.bene_id;
quit;




proc sql;
create table temp3 as
select *, 

case when in3Yr20pct=1 and HC5_actual=1 and HC5_actual2013=1  and  HC5_actual2014=1   
     then "(All Bene in 2012 20% Sample) Actual Cost Top 5%: HC,HC,HC"
	 when in3Yr20pct=1 and HC5_actual=1 and HC5_actual2013=1  and  HC5_actual2014 ne 1 
     then "(All Bene in 2012 20% Sample) Actual Cost Top 5%: HC,HC,Non-HC"
	 when in3Yr20pct=1 and HC5_actual=1 and HC5_actual2013 ne 1 and HC5_actual2014=1 
     then "(All Bene in 2012 20% Sample) Actual Cost Top 5%: HC,Non-HC,HC"
     when in3Yr20pct=1 and HC5_actual=1 and HC5_actual2013 ne 1 and HC5_actual2014 ne 1 
     then "(All Bene in 2012 20% Sample) Actual Cost Top 5%: HC,Non-HC,Non-HC"

     when in3Yr20pct=1 and HC5_actual=0 and HC5_actual2013=1 and HC5_actual2014=1 
     then "(All Bene in 2012 20% Sample) Actual Cost Top 5%: Non-HC,HC,HC"
	 when in3Yr20pct=1 and HC5_actual=0 and HC5_actual2013=1 and HC5_actual2014 ne 1 
     then "(All Bene in 2012 20% Sample) Actual Cost Top 5%: Non-HC,HC,Non-HC"
	 when in3Yr20pct=1 and HC5_actual=0 and HC5_actual2013 ne 1 and HC5_actual2014=1 
     then "(All Bene in 2012 20% Sample) Actual Cost Top 5%: Non-HC,Non-HC,HC"
     when in3Yr20pct=1 and HC5_actual=0 and HC5_actual2013 ne 1 and HC5_actual2014 ne 1
     then "(All Bene in 2012 20% Sample) Actual Cost Top 5%: Non-HC,Non-HC,Non-HC"
     
	 when in3Yr20pct=. and HC5_actual=1 then "(All Bene in 2012 20% Sample) Actual Cost Top 5%: HC 2008, but bene Not in 2009 and 2010"
	 when in3Yr20pct=.  and HC5_actual=0 then "(All Bene in 2012 20% Sample) Actual Cost Top 5%: NOn-HC 2008, but bene Not in 2009 and 2010"

end as actual5pct format = $100. label='(All Bene in 2012 20% Sample) Actual Cost Top 5%',
 

case when in3Yr20pct=1 and HC5_stdcost=1 and HC5_stdcost2013=1 and HC5_stdcost2014=1 
     then "(All Bene in 2012 20% Sample) Standard Cost Top 5%: HC,HC,HC"
	 when in3Yr20pct=1 and HC5_stdcost=1 and HC5_stdcost2013=1 and HC5_stdcost2014 ne 1 
     then "(All Bene in 2012 20% Sample) Standard Cost Top 5%: HC,HC,Non-HC"
	 when in3Yr20pct=1 and HC5_stdcost=1 and HC5_stdcost2013 ne 1 and HC5_stdcost2014=1 
     then "(All Bene in 2012 20% Sample) Standard Cost Top 5%: HC,Non-HC,HC"
     when in3Yr20pct=1 and HC5_stdcost=1 and HC5_stdcost2013 ne 1 and HC5_stdcost2014 ne 1
     then "(All Bene in 2012 20% Sample) Standard Cost Top 5%: HC,Non-HC,Non-HC"

     when in3Yr20pct=1 and HC5_stdcost=0 and HC5_stdcost2013=1 and HC5_stdcost2014=1
     then "(All Bene in 2012 20% Sample) Standard Cost Top 5%: Non-HC,HC,HC"
	 when in3Yr20pct=1 and HC5_stdcost=0 and HC5_stdcost2013=1 and HC5_stdcost2014 ne 1 
     then "(All Bene in 2012 20% Sample) Standard Cost Top 5%: Non-HC,HC,Non-HC"
	 when in3Yr20pct=1 and HC5_stdcost=0 and HC5_stdcost2013 ne 1 and HC5_stdcost2014=1  
     then "(All Bene in 2012 20% Sample) Standard Cost Top 5%: Non-HC,Non-HC,HC"
     when in3Yr20pct=1 and HC5_stdcost=0 and HC5_stdcost2013 ne 1 and HC5_stdcost2014 ne 1  
     then "(All Bene in 2012 20% Sample) Standard Cost Top 5%: Non-HC,Non-HC,Non-HC"
     
	 when in3Yr20pct=. and HC5_stdcost=1 then "(All Bene in 2012 20% Sample) Standard Cost Top 5%: HC 2008, but bene Not in 2009 and 2010"
	 when in3Yr20pct=. and HC5_stdcost=0 then "(All Bene in 2012 20% Sample) Standard Cost Top 5%: NOn-HC 2008, but bene Not in 2009 and 2010"

end as stdcost5pct format = $100. label='(All Bene in 2012 20% Sample) Standard Cost Top 5%',

case when in3Yr20pct=1 and HC10_actual=1 and HC10_actual2013=1 and HC10_actual2014=1
     then "(All Bene in 2012 20% Sample) Actual Cost Top 10%: HC,HC,HC"
	 when in3Yr20pct=1 and HC10_actual=1 and HC10_actual2013=1 and HC10_actual2014 ne 1
     then "(All Bene in 2012 20% Sample) Actual Cost Top 10%: HC,HC,Non-HC"
	 when in3Yr20pct=1 and HC10_actual=1 and HC10_actual2013 ne 1 and HC10_actual2014=1 
     then "(All Bene in 2012 20% Sample) Actual Cost Top 10%: HC,Non-HC,HC"
     when in3Yr20pct=1 and HC10_actual=1 and HC10_actual2013 ne 1 and HC10_actual2014 ne 1 
     then "(All Bene in 2012 20% Sample) Actual Cost Top 10%: HC,Non-HC,Non-HC"

     when in3Yr20pct=1 and HC10_actual=0 and HC10_actual2013=1 and HC10_actual2014=1  
     then "(All Bene in 2012 20% Sample) Actual Cost Top 10%: Non-HC,HC,HC"
	 when in3Yr20pct=1 and HC10_actual=0 and HC10_actual2013=1 and HC10_actual2014 ne 1
     then "(All Bene in 2012 20% Sample) Actual Cost Top 10%: Non-HC,HC,Non-HC"
	 when in3Yr20pct=1 and HC10_actual=0 and HC10_actual2013 ne 1 and HC10_actual2014=1
     then "(All Bene in 2012 20% Sample) Actual Cost Top 10%: Non-HC,Non-HC,HC"
     when in3Yr20pct=1 and HC10_actual=0 and HC10_actual2013 ne 1 and HC10_actual2014 ne 1  
     then "(All Bene in 2012 20% Sample) Actual Cost Top 10%: Non-HC,Non-HC,Non-HC"
     
	 when in3Yr20pct=. and HC10_actual=1 then "(All Bene in 2012 20% Sample) Actual Cost Top 10%: HC 2008, but bene Not in 2009 and 2010"
	 when in3Yr20pct=. and HC10_actual=0 then "(All Bene in 2012 20% Sample) Actual Cost Top 10%: NOn-HC 2008, but bene Not in 2009 and 2010"

end as actual10pct format = $100. label='(All Bene in 2012 20% Sample) Actual Cost Top 10%',

case when in3Yr20pct=1 and HC10_stdcost=1 and HC10_stdcost2013=1 and HC10_stdcost2014=1 
     then "(All Bene in 2012 20% Sample) Standard Cost Top 10%: HC,HC,HC"
	 when in3Yr20pct=1 and HC10_stdcost=1 and HC10_stdcost2013=1 and HC10_stdcost2014 ne 1 
     then "(All Bene in 2012 20% Sample) Standard Cost Top 10%: HC,HC,Non-HC"
	 when in3Yr20pct=1 and HC10_stdcost=1 and HC10_stdcost2013 ne 1 and HC10_stdcost2014=1  
     then "(All Bene in 2012 20% Sample) Standard Cost Top 10%: HC,Non-HC,HC"
     when in3Yr20pct=1 and HC10_stdcost=1 and HC10_stdcost2013 ne 1 and HC10_stdcost2014 ne 1
     then "(All Bene in 2012 20% Sample) Standard Cost Top 10%: HC,Non-HC,Non-HC"

     when in3Yr20pct=1 and HC10_stdcost=0 and HC10_stdcost2013=1 and HC10_stdcost2014=1
     then "(All Bene in 2012 20% Sample) Standard Cost Top 10%: Non-HC,HC,HC"
	 when in3Yr20pct=1 and HC10_stdcost=0 and HC10_stdcost2013=1 and HC10_stdcost2014 ne 1  
     then "(All Bene in 2012 20% Sample) Standard Cost Top 10%: Non-HC,HC,Non-HC"
	 when in3Yr20pct=1 and HC10_stdcost=0 and HC10_stdcost2013 ne 1 and HC10_stdcost2014=1
     then "(All Bene in 2012 20% Sample) Standard Cost Top 10%: Non-HC,Non-HC,HC"
     when in3Yr20pct=1 and HC10_stdcost=0 and HC10_stdcost2013 ne 1 and HC10_stdcost2014 ne 1
     then "(All Bene in 2012 20% Sample) Standard Cost Top 10%: Non-HC,Non-HC,Non-HC"
     
	 when in3Yr20pct=. and HC10_stdcost=1 then "(All Bene in 2012 20% Sample) Standard Cost Top 10%: HC 2008, but bene Not in 2009 and 2010"
	 when in3Yr20pct=. and HC10_stdcost=0 then "(All Bene in 2012 20% Sample) Standard Cost Top 10%: NOn-HC 2008, but bene Not in 2009 and 2010"

end as stdcost10pct format = $100. label='(All Bene in 2012 20% Sample) Standard Cost Top 10%',

case when in3Yr20pct=1 and HC25_actual=1 and HC25_actual2013=1 and HC25_actual2014=1
     then "(All Bene in 2012 20% Sample) Actual Cost Top 25%: HC,HC,HC"
	 when in3Yr20pct=1 and HC25_actual=1 and HC25_actual2013=1 and HC25_actual2014 ne 1  
     then "(All Bene in 2012 20% Sample) Actual Cost Top 25%: HC,HC,Non-HC"
	 when in3Yr20pct=1 and HC25_actual=1 and HC25_actual2013 ne 1 and HC25_actual2014=1
     then "(All Bene in 2012 20% Sample) Actual Cost Top 25%: HC,Non-HC,HC"
     when in3Yr20pct=1 and HC25_actual=1 and HC25_actual2013 ne 1 and HC25_actual2014 ne 1 
     then "(All Bene in 2012 20% Sample) Actual Cost Top 25%: HC,Non-HC,Non-HC"

     when in3Yr20pct=1 and HC25_actual=0 and HC25_actual2013=1 and HC25_actual2014=1 
     then "(All Bene in 2012 20% Sample) Actual Cost Top 25%: Non-HC,HC,HC"
	 when in3Yr20pct=1 and HC25_actual=0 and HC25_actual2013=1 and HC25_actual2014 ne 1  
     then "(All Bene in 2012 20% Sample) Actual Cost Top 25%: Non-HC,HC,Non-HC"
	 when in3Yr20pct=1 and HC25_actual=0 and HC25_actual2013 ne 1 and HC25_actual2014=1
     then "(All Bene in 2012 20% Sample) Actual Cost Top 25%: Non-HC,Non-HC,HC"
     when in3Yr20pct=1 and HC25_actual=0 and HC25_actual2013 ne 1 and HC25_actual2014 ne 1 
     then "(All Bene in 2012 20% Sample) Actual Cost Top 25%: Non-HC,Non-HC,Non-HC"
     
	 when in3Yr20pct=. and HC25_actual=1 then "(All Bene in 2012 20% Sample) Actual Cost Top 25%: HC 2008, but bene Not in 2009 and 2010"
	 when in3Yr20pct=. and HC25_actual=0 then "(All Bene in 2012 20% Sample) Actual Cost Top 25%: NOn-HC 2008, but bene Not in 2009 and 2010"

end as actual25pct format = $100. label='(All Bene in 2012 20% Sample) Actual Cost Top 25%',

case when in3Yr20pct=1 and HC25_stdcost=1 and HC25_stdcost2013=1 and HC25_stdcost2014=1  
     then "(All Bene in 2012 20% Sample) Standard Cost Top 25%: HC,HC,HC"
	 when in3Yr20pct=1 and HC25_stdcost=1 and HC25_stdcost2013=1 and HC25_stdcost2014 ne 1 
     then "(All Bene in 2012 20% Sample) Standard Cost Top 25%: HC,HC,Non-HC"
	 when in3Yr20pct=1 and HC25_stdcost=1 and HC25_stdcost2013 ne 1 and HC25_stdcost2014=1
     then "(All Bene in 2012 20% Sample) Standard Cost Top 25%: HC,Non-HC,HC"
     when in3Yr20pct=1 and HC25_stdcost=1 and HC25_stdcost2013 ne 1 and HC25_stdcost2014 ne 1
     then "(All Bene in 2012 20% Sample) Standard Cost Top 25%: HC,Non-HC,Non-HC"

     when in3Yr20pct=1 and HC25_stdcost=0 and HC25_stdcost2013=1 and HC25_stdcost2014=1 
     then "(All Bene in 2012 20% Sample) Standard Cost Top 25%: Non-HC,HC,HC"
	 when in3Yr20pct=1 and HC25_stdcost=0 and HC25_stdcost2013=1 and HC25_stdcost2014 ne 1  
     then "(All Bene in 2012 20% Sample) Standard Cost Top 25%: Non-HC,HC,Non-HC"
	 when in3Yr20pct=1 and HC25_stdcost=0 and HC25_stdcost2013 ne 1 and HC25_stdcost2014=1 
     then "(All Bene in 2012 20% Sample) Standard Cost Top 25%: Non-HC,Non-HC,HC"
     when in3Yr20pct=1 and HC25_stdcost=0 and HC25_stdcost2013 ne 1 and HC25_stdcost2014 ne 1
     then "(All Bene in 2012 20% Sample) Standard Cost Top 25%: Non-HC,Non-HC,Non-HC"
     
	 when in3Yr20pct=. and HC25_stdcost=1 then "(All Bene in 2012 20% Sample) Standard Cost Top 25%: HC 2008, but bene Not in 2009 and 2010"
	 when in3Yr20pct=. and HC25_stdcost=0 then "(All Bene in 2012 20% Sample) Standard Cost Top 25%: NOn-HC 2008, but bene Not in 2009 and 2010"

end as stdcost25pct format = $100. label='(All Bene in 2012 20% Sample) Standard Cost Top 25%' 
from temp2;
quit;
 

* Tabulate Sample 1 ;
proc freq data=temp3;tables actual5pct actual10pct actual25pct  stdcost5pct stdcost10pct stdcost25pct/missing;run;



libname seg 'C:\data\Projects\High_Cost_Segmentation\Data';
proc sql;
create table temp4 as
select a.*,floor(b.segsumm_hc) as seg
from  temp3 a left join seg.segmentsendbenehc2012_2  b
on a.bene_id=b.bene_id;
quit;

* persistence by seg;
proc freq data=temp4;
tables seg  stdcost5pct*seg stdcost10pct*seg stdcost25pct*seg/missing;
run;

* Demographics: Age, Race, Sex, Dual status (not time-varying), Chronic Condition, Frailty;
libname denom 'C:\data\Data\Medicare\Denominator';
proc sql;
create table temp5 as
select a.*,b.BUYIN_MO as Dual2012
from temp4 a left join denom.dnmntr2012 b
on a.bene_id=b.bene_id;
quit;
proc sql;
create table temp6 as
select a.*,b.BUYIN_MO as Dual2013
from temp5 a left join denom.dnmntr2013 b
on a.bene_id=b.bene_id;
quit;
proc sql;
create table temp7 as
select a.*,b.BUYIN_MO as Dual2014
from temp6 a left join denom.dnmntr2014 b
on a.bene_id=b.bene_id;
quit;
proc sql;
create table temp8 as
select a.*,b.AMI as AMI2012,b.ALZH as ALZH2012,b.ALZHDMTA as ALZHDMTA2012,b.ATRIALFB as ATRIALFB2012,
b.CATARACT as CATARACT2012, b.CHRNKIDN as CHRNKIDN2012, b.COPD as COPD2012,b.CHF as CHF2012,b.DIABETES as DIABETES2012,
b.GLAUCOMA as GLAUCOMA2012, b.HIPFRAC as HIPFRAC2012 ,b.ISCHMCHT as ISCHMCHT2012 ,b.DEPRESSN as DEPRESSN2012, 
b.OSTEOPRS as OSTEOPRS2012, b.RA_OA as RA_OA2012, b.STRKETIA as STRKETIA2012, b.CNCRBRST as CNCRBRST2012,
b.CNCRCLRC as CNCRCLRC2012,b.CNCRPRST as CNCRPRST2012, b.CNCRLUNG as CNCRLUNG2012,b.CNCRENDM as CNCRENDM2012,
b.ANEMIA as ANEMIA2012, b.ASTHMA as ASTHMA2012, b.HYPERL as HYPERL2012, b.HYPERP as HYPERP2012, b.HYPERT as HYPERT2012, b.HYPOTH as HYPOTH2012
from temp7 a left join cc.Mbsf_cc2012 b
on a.bene_id=b.bene_id;
quit;
proc sql;
create table temp9 as
select a.*,b.AMI as AMI2014,b.ALZH as ALZH2014,b.ALZHDMTA as ALZHDMTA2014,b.ATRIALFB as ATRIALFB2014,
b.CATARACT as CATARACT2014, b.CHRNKIDN as CHRNKIDN2014, b.COPD as COPD2014,b.CHF as CHF2014,b.DIABETES as DIABETES2014,
b.GLAUCOMA as GLAUCOMA2014, b.HIPFRAC as HIPFRAC2014 ,b.ISCHMCHT as ISCHMCHT2014 ,b.DEPRESSN as DEPRESSN2014, 
b.OSTEOPRS as OSTEOPRS2014, b.RA_OA as RA_OA2014, b.STRKETIA as STRKETIA2014, b.CNCRBRST as CNCRBRST2014,
b.CNCRCLRC as CNCRCLRC2014,b.CNCRPRST as CNCRPRST2014, b.CNCRLUNG as CNCRLUNG2014,b.CNCRENDM as CNCRENDM2014,
b.ANEMIA as ANEMIA2014, b.ASTHMA as ASTHMA2014, b.HYPERL as HYPERL2014, b.HYPERP as HYPERP2014, b.HYPERT as HYPERT2014, b.HYPOTH as HYPOTH2014
from temp8 a left join cc.Mbsf_cc2014 b
on a.bene_id=b.bene_id;
quit;

 
proc sql;
create table temp10 as
select a.*,b.frailty1 as frailty12012,b.frailty2 as frailty22012,b.frailty3 as frailty32012,b.frailty4 as frailty42012,
b.frailty5 as frailty52012,b.frailty6 as frailty62012,b.frailty7 as frailty72012,b.frailty8 as frailty82012,b.frailty9 as frailty92012,
b.frailty10 as frailty102012,b.frailty11 as frailty112012,b.frailty12 as frailty122012 
from temp9 a left join Frail.Frailty2012 b
on a.bene_id=b.bene_id;
quit;
proc sql;
create table temp11 as
select a.*,b.frailty1 as frailty12014,b.frailty2 as frailty22014,b.frailty3 as frailty32014,b.frailty4 as frailty42014,
b.frailty5 as frailty52014,b.frailty6 as frailty62014,b.frailty7 as frailty72014,b.frailty8 as frailty82014,b.frailty9 as frailty92014,
b.frailty10 as frailty102014,b.frailty11 as frailty112014,b.frailty12 as frailty122014 
from temp10 a left join Frail.Frailty2014 b
on a.bene_id=b.bene_id;
quit;

data temp12;
length ageC $15.;
set temp11;
if Dual2012>0 or Dual2013>0 or Dual2014>0 then dual=1;else dual=0;

if age<18 then ageC="<18";
else if age>=18 and age<65 then ageC="18-65";
else if age>=65 and age<75 then ageC="65-75";
else if age>=75 and age<85 then ageC="75-85";
else if age>=85  then ageC=">=85";

run;



proc tabulate data=temp12 noseps  ;
class stdcost5pct stdcost10pct stdcost25pct seg dual;  
table (dual),(stdcost10pct*(n colpctn) all*(n colpctn))/RTS=25;
table (dual),( seg*(n colpctn)  all*(n colpctn))/RTS=25;
table (dual),( seg*stdcost10pct*(n colpctn) all*(n colpctn))/RTS=25;
Keylabel all="All Dual Eligible"
         N="Number of Beneficiary"
		 colpctn="Column Percent";
 
run;



* Way 2: Only patients in all 3 years;
proc sql;
create table temp as
select a.bene_id, a.actual as actual2012, a.stdcost as stdcost as stdcost2012
from Patienttotalcost2012_r a inner join in3Yr20pct b
on a.bene_id=b.bene_id;
quit;

proc sql;
create table temp1 as
select a.*, b.actual as actual2013, b.stdcost as stdcost as stdcost2013
from temp a left join Patienttotalcost2013_r b
on a.bene_id=b.bene_id;
quit;

proc sql;
create table temp2 as
select a.*, b.actual as actual2014, b.stdcost as stdcost as stdcost2014
from temp1 a inner join Patienttotalcost2014_r b
on a.bene_id=b.bene_id;
quit;


proc rank data=temp2 out=temp3 percent;
var actual2012 stdcost2012 actual2013 stdcost2013 actual2014 stdcost2014;
ranks pct_actual2012 pct_stdcost2012 pct_actual2013 pct_stdcost2013 pct_actual2014 pct_stdcost2014;
run;

data temp4;
set temp3;
if pct_actual2012>=95 then HC5_actual2012=1;else HC5_actual2012=0;
if pct_actual2012>=90 then HC10_actual2012=1;else HC10_actual2012=0;
if pct_actual2012>=75 then HC25_actual2012=1;else HC25_actual2012=0;

if pct_stdcost2012>=95 then HC5_stdcost2012=1;else HC5_stdcost2012=0;
if pct_stdcost2012>=90 then HC10_stdcost2012=1;else HC10_stdcost2012=0;
if pct_stdcost2012>=75 then HC25_stdcost2012=1;else HC25_stdcost2012=0; 

if pct_actual2013>=95 then HC5_actual2013=1;else HC5_actual2013=0;
if pct_actual2013>=90 then HC10_actual2013=1;else HC10_actual2013=0;
if pct_actual2013>=75 then HC25_actual2013=1;else HC25_actual2013=0;

if pct_stdcost2013>=95 then HC5_stdcost2013=1;else HC5_stdcost2013=0;
if pct_stdcost2013>=90 then HC10_stdcost2013=1;else HC10_stdcost2013=0;
if pct_stdcost2013>=75 then HC25_stdcost2013=1;else HC25_stdcost2013=0;

if pct_actual2014>=95 then HC5_actual2014=1;else HC5_actual2014=0;
if pct_actual2014>=90 then HC10_actual2014=1;else HC10_actual2014=0;
if pct_actual2014>=75 then HC25_actual2014=1;else HC25_actual2014=0;

if pct_stdcost2014>=95 then HC5_stdcost2014=1;else HC5_stdcost2014=0;
if pct_stdcost2014>=90 then HC10_stdcost2014=1;else HC10_stdcost2014=0;
if pct_stdcost2014>=75 then HC25_stdcost2014=1;else HC25_stdcost2014=0;
proc freq;tables 
HC5_actual2012 HC10_actual2012 HC25_actual2012 HC5_stdcost2012 HC10_stdcost2012 HC25_stdcost2012
HC5_actual2013 HC10_actual2013 HC25_actual2013 HC5_stdcost2013 HC10_stdcost2013 HC25_stdcost2013
HC5_actual2014 HC10_actual2014 HC25_actual2014 HC5_stdcost2014 HC10_stdcost2014 HC25_stdcost2014/missing;
run;



proc sql;
create table temp5 as
select *, 

case when HC5_actual2012=1 and HC5_actual2013=1  and  HC5_actual2014=1   
     then "(Bene in all 3 yrs 20% Sample) Actual Cost Top 5%: HC,HC,HC"
	 when HC5_actual2012=1 and HC5_actual2013=1  and  HC5_actual2014 ne 1 
     then "(Bene in all 3 yrs 20% Sample) Actual Cost Top 5%: HC,HC,Non-HC"
	 when HC5_actual2012=1 and HC5_actual2013 ne 1 and HC5_actual2014=1 
     then "(Bene in all 3 yrs 20% Sample) Actual Cost Top 5%: HC,Non-HC,HC"
     when HC5_actual2012=1 and HC5_actual2013 ne 1 and HC5_actual2014 ne 1 
     then "(Bene in all 3 yrs 20% Sample) Actual Cost Top 5%: HC,Non-HC,Non-HC"

     when HC5_actual2012=0 and HC5_actual2013=1 and HC5_actual2014=1 
     then "(Bene in all 3 yrs 20% Sample) Actual Cost Top 5%: Non-HC,HC,HC"
	 when HC5_actual2012=0 and HC5_actual2013=1 and HC5_actual2014 ne 1 
     then "(Bene in all 3 yrs 20% Sample) Actual Cost Top 5%: Non-HC,HC,Non-HC"
	 when HC5_actual2012=0 and HC5_actual2013 ne 1 and HC5_actual2014=1 
     then "(Bene in all 3 yrs 20% Sample) Actual Cost Top 5%: Non-HC,Non-HC,HC"
     when HC5_actual2012=0 and HC5_actual2013 ne 1 and HC5_actual2014 ne 1
     then "(Bene in all 3 yrs 20% Sample) Actual Cost Top 5%: Non-HC,Non-HC,Non-HC"
   
end as actual5pct format = $100. label='(Bene in all 3 yrs 20% Sample) Actual Cost Top 5%',
 

case when HC5_stdcost2012=1 and HC5_stdcost2013=1 and HC5_stdcost2014=1 
     then "(Bene in all 3 yrs 20% Sample) Standard Cost Top 5%: HC,HC,HC"
	 when HC5_stdcost2012=1 and HC5_stdcost2013=1 and HC5_stdcost2014 ne 1 
     then "(Bene in all 3 yrs 20% Sample) Standard Cost Top 5%: HC,HC,Non-HC"
	 when HC5_stdcost2012=1 and HC5_stdcost2013 ne 1 and HC5_stdcost2014=1 
     then "(Bene in all 3 yrs 20% Sample) Standard Cost Top 5%: HC,Non-HC,HC"
     when HC5_stdcost2012=1 and HC5_stdcost2013 ne 1 and HC5_stdcost2014 ne 1
     then "(Bene in all 3 yrs 20% Sample) Standard Cost Top 5%: HC,Non-HC,Non-HC"

     when HC5_stdcost2012=0 and HC5_stdcost2013=1 and HC5_stdcost2014=1
     then "(Bene in all 3 yrs 20% Sample) Standard Cost Top 5%: Non-HC,HC,HC"
	 when HC5_stdcost2012=0 and HC5_stdcost2013=1 and HC5_stdcost2014 ne 1 
     then "(Bene in all 3 yrs 20% Sample) Standard Cost Top 5%: Non-HC,HC,Non-HC"
	 when HC5_stdcost2012=0 and HC5_stdcost2013 ne 1 and HC5_stdcost2014=1  
     then "(Bene in all 3 yrs 20% Sample) Standard Cost Top 5%: Non-HC,Non-HC,HC"
     when HC5_stdcost2012=0 and HC5_stdcost2013 ne 1 and HC5_stdcost2014 ne 1  
     then "(Bene in all 3 yrs 20% Sample) Standard Cost Top 5%: Non-HC,Non-HC,Non-HC"
  
end as stdcost5pct format = $100. label='(Bene in all 3 yrs 20% Sample) Standard Cost Top 5%',

case when HC10_actual2012=1 and HC10_actual2013=1 and HC10_actual2014=1
     then "(Bene in all 3 yrs 20% Sample) Actual Cost Top 10%: HC,HC,HC"
	 when HC10_actual2012=1 and HC10_actual2013=1 and HC10_actual2014 ne 1
     then "(Bene in all 3 yrs 20% Sample) Actual Cost Top 10%: HC,HC,Non-HC"
	 when HC10_actual2012=1 and HC10_actual2013 ne 1 and HC10_actual2014=1 
     then "(Bene in all 3 yrs 20% Sample) Actual Cost Top 10%: HC,Non-HC,HC"
     when HC10_actual2012=1 and HC10_actual2013 ne 1 and HC10_actual2014 ne 1 
     then "(Bene in all 3 yrs 20% Sample) Actual Cost Top 10%: HC,Non-HC,Non-HC"

     when HC10_actual2012=0 and HC10_actual2013=1 and HC10_actual2014=1  
     then "(Bene in all 3 yrs 20% Sample) Actual Cost Top 10%: Non-HC,HC,HC"
	 when HC10_actual2012=0 and HC10_actual2013=1 and HC10_actual2014 ne 1
     then "(Bene in all 3 yrs 20% Sample) Actual Cost Top 10%: Non-HC,HC,Non-HC"
	 when HC10_actual2012=0 and HC10_actual2013 ne 1 and HC10_actual2014=1
     then "(Bene in all 3 yrs 20% Sample) Actual Cost Top 10%: Non-HC,Non-HC,HC"
     when HC10_actual2012=0 and HC10_actual2013 ne 1 and HC10_actual2014 ne 1  
     then "(Bene in all 3 yrs 20% Sample) Actual Cost Top 10%: Non-HC,Non-HC,Non-HC"
  
end as actual10pct format = $100. label='(Bene in all 3 yrs 20% Sample) Actual Cost Top 10%',

case when HC10_stdcost2012=1 and HC10_stdcost2013=1 and HC10_stdcost2014=1 
     then "(Bene in all 3 yrs 20% Sample) Standard Cost Top 10%: HC,HC,HC"
	 when HC10_stdcost2012=1 and HC10_stdcost2013=1 and HC10_stdcost2014 ne 1 
     then "(Bene in all 3 yrs 20% Sample) Standard Cost Top 10%: HC,HC,Non-HC"
	 when HC10_stdcost2012=1 and HC10_stdcost2013 ne 1 and HC10_stdcost2014=1  
     then "(Bene in all 3 yrs 20% Sample) Standard Cost Top 10%: HC,Non-HC,HC"
     when HC10_stdcost2012=1 and HC10_stdcost2013 ne 1 and HC10_stdcost2014 ne 1
     then "(Bene in all 3 yrs 20% Sample) Standard Cost Top 10%: HC,Non-HC,Non-HC"

     when HC10_stdcost2012=0 and HC10_stdcost2013=1 and HC10_stdcost2014=1
     then "(Bene in all 3 yrs 20% Sample) Standard Cost Top 10%: Non-HC,HC,HC"
	 when HC10_stdcost2012=0 and HC10_stdcost2013=1 and HC10_stdcost2014 ne 1  
     then "(Bene in all 3 yrs 20% Sample) Standard Cost Top 10%: Non-HC,HC,Non-HC"
	 when HC10_stdcost2012=0 and HC10_stdcost2013 ne 1 and HC10_stdcost2014=1
     then "(Bene in all 3 yrs 20% Sample) Standard Cost Top 10%: Non-HC,Non-HC,HC"
     when HC10_stdcost2012=0 and HC10_stdcost2013 ne 1 and HC10_stdcost2014 ne 1
     then "(Bene in all 3 yrs 20% Sample) Standard Cost Top 10%: Non-HC,Non-HC,Non-HC"
     
end as stdcost10pct format = $100. label='(Bene in all 3 yrs 20% Sample) Standard Cost Top 10%',

case when HC25_actual2012=1 and HC25_actual2013=1 and HC25_actual2014=1
     then "(Bene in all 3 yrs 20% Sample) Actual Cost Top 25%: HC,HC,HC"
	 when HC25_actual2012=1 and HC25_actual2013=1 and HC25_actual2014 ne 1  
     then "(Bene in all 3 yrs 20% Sample) Actual Cost Top 25%: HC,HC,Non-HC"
	 when HC25_actual2012=1 and HC25_actual2013 ne 1 and HC25_actual2014=1
     then "(Bene in all 3 yrs 20% Sample) Actual Cost Top 25%: HC,Non-HC,HC"
     when HC25_actual2012=1 and HC25_actual2013 ne 1 and HC25_actual2014 ne 1 
     then "(Bene in all 3 yrs 20% Sample) Actual Cost Top 25%: HC,Non-HC,Non-HC"

     when HC25_actual2012=0 and HC25_actual2013=1 and HC25_actual2014=1 
     then "(Bene in all 3 yrs 20% Sample) Actual Cost Top 25%: Non-HC,HC,HC"
	 when HC25_actual2012=0 and HC25_actual2013=1 and HC25_actual2014 ne 1  
     then "(Bene in all 3 yrs 20% Sample) Actual Cost Top 25%: Non-HC,HC,Non-HC"
	 when HC25_actual2012=0 and HC25_actual2013 ne 1 and HC25_actual2014=1
     then "(Bene in all 3 yrs 20% Sample) Actual Cost Top 25%: Non-HC,Non-HC,HC"
     when HC25_actual2012=0 and HC25_actual2013 ne 1 and HC25_actual2014 ne 1 
     then "(Bene in all 3 yrs 20% Sample) Actual Cost Top 25%: Non-HC,Non-HC,Non-HC"
  
end as actual25pct format = $100. label='(Bene in all 3 yrs 20% Sample) Actual Cost Top 25%',

case when HC25_stdcost2012=1 and HC25_stdcost2013=1 and HC25_stdcost2014=1  
     then "(Bene in all 3 yrs 20% Sample) Standard Cost Top 25%: HC,HC,HC"
	 when HC25_stdcost2012=1 and HC25_stdcost2013=1 and HC25_stdcost2014 ne 1 
     then "(Bene in all 3 yrs 20% Sample) Standard Cost Top 25%: HC,HC,Non-HC"
	 when HC25_stdcost2012=1 and HC25_stdcost2013 ne 1 and HC25_stdcost2014=1
     then "(Bene in all 3 yrs 20% Sample) Standard Cost Top 25%: HC,Non-HC,HC"
     when HC25_stdcost2012=1 and HC25_stdcost2013 ne 1 and HC25_stdcost2014 ne 1
     then "(Bene in all 3 yrs 20% Sample) Standard Cost Top 25%: HC,Non-HC,Non-HC"

     when HC25_stdcost2012=0 and HC25_stdcost2013=1 and HC25_stdcost2014=1 
     then "(Bene in all 3 yrs 20% Sample) Standard Cost Top 25%: Non-HC,HC,HC"
	 when HC25_stdcost2012=0 and HC25_stdcost2013=1 and HC25_stdcost2014 ne 1  
     then "(Bene in all 3 yrs 20% Sample) Standard Cost Top 25%: Non-HC,HC,Non-HC"
	 when HC25_stdcost2012=0 and HC25_stdcost2013 ne 1 and HC25_stdcost2014=1 
     then "(Bene in all 3 yrs 20% Sample) Standard Cost Top 25%: Non-HC,Non-HC,HC"
     when HC25_stdcost2012=0 and HC25_stdcost2013 ne 1 and HC25_stdcost2014 ne 1
     then "(Bene in all 3 yrs 20% Sample) Standard Cost Top 25%: Non-HC,Non-HC,Non-HC"
 
end as stdcost25pct format = $100. label='(Bene in all 3 yrs 20% Sample) Standard Cost Top 25%' 
from temp4;
quit;
 

* Tabulate Sample 2 ;
proc freq data=temp5;tables actual5pct actual10pct actual25pct  stdcost5pct stdcost10pct stdcost25pct/missing;run;

libname seg 'C:\data\Projects\High_Cost_Segmentation\Data';
proc sql;
create table temp4 as
select a.*,floor(b.segsumm_hc) as seg
from  temp5 a left join seg.segmentsendbenehc2012_2  b
on a.bene_id=b.bene_id;
quit;

* persistence by seg;
proc freq data=temp4;
tables seg  stdcost5pct*seg stdcost10pct*seg stdcost25pct*seg/missing;
run;

* Demographics: Age, Race, Sex, Dual status (not time-varying), Chronic Condition, Frailty;
libname denom 'C:\data\Data\Medicare\Denominator';
proc sql;
create table temp5 as
select a.*,b.BUYIN_MO as Dual2012
from temp4 a left join denom.dnmntr2012 b
on a.bene_id=b.bene_id;
quit;
proc sql;
create table temp6 as
select a.*,b.BUYIN_MO as Dual2013
from temp5 a left join denom.dnmntr2013 b
on a.bene_id=b.bene_id;
quit;
proc sql;
create table temp7 as
select a.*,b.BUYIN_MO as Dual2014
from temp6 a left join denom.dnmntr2014 b
on a.bene_id=b.bene_id;
quit;
proc sql;
create table temp8 as
select a.*,b.AMI as AMI2012,b.ALZH as ALZH2012,b.ALZHDMTA as ALZHDMTA2012,b.ATRIALFB as ATRIALFB2012,
b.CATARACT as CATARACT2012, b.CHRNKIDN as CHRNKIDN2012, b.COPD as COPD2012,b.CHF as CHF2012,b.DIABETES as DIABETES2012,
b.GLAUCOMA as GLAUCOMA2012, b.HIPFRAC as HIPFRAC2012 ,b.ISCHMCHT as ISCHMCHT2012 ,b.DEPRESSN as DEPRESSN2012, 
b.OSTEOPRS as OSTEOPRS2012, b.RA_OA as RA_OA2012, b.STRKETIA as STRKETIA2012, b.CNCRBRST as CNCRBRST2012,
b.CNCRCLRC as CNCRCLRC2012,b.CNCRPRST as CNCRPRST2012, b.CNCRLUNG as CNCRLUNG2012,b.CNCRENDM as CNCRENDM2012,
b.ANEMIA as ANEMIA2012, b.ASTHMA as ASTHMA2012, b.HYPERL as HYPERL2012, b.HYPERP as HYPERP2012, b.HYPERT as HYPERT2012, b.HYPOTH as HYPOTH2012
from temp7 a left join cc.Mbsf_cc2012 b
on a.bene_id=b.bene_id;
quit;
proc sql;
create table temp9 as
select a.*,b.AMI as AMI2014,b.ALZH as ALZH2014,b.ALZHDMTA as ALZHDMTA2014,b.ATRIALFB as ATRIALFB2014,
b.CATARACT as CATARACT2014, b.CHRNKIDN as CHRNKIDN2014, b.COPD as COPD2014,b.CHF as CHF2014,b.DIABETES as DIABETES2014,
b.GLAUCOMA as GLAUCOMA2014, b.HIPFRAC as HIPFRAC2014 ,b.ISCHMCHT as ISCHMCHT2014 ,b.DEPRESSN as DEPRESSN2014, 
b.OSTEOPRS as OSTEOPRS2014, b.RA_OA as RA_OA2014, b.STRKETIA as STRKETIA2014, b.CNCRBRST as CNCRBRST2014,
b.CNCRCLRC as CNCRCLRC2014,b.CNCRPRST as CNCRPRST2014, b.CNCRLUNG as CNCRLUNG2014,b.CNCRENDM as CNCRENDM2014,
b.ANEMIA as ANEMIA2014, b.ASTHMA as ASTHMA2014, b.HYPERL as HYPERL2014, b.HYPERP as HYPERP2014, b.HYPERT as HYPERT2014, b.HYPOTH as HYPOTH2014
from temp8 a left join cc.Mbsf_cc2014 b
on a.bene_id=b.bene_id;
quit;

 
proc sql;
create table temp10 as
select a.*,b.frailty1 as frailty12012,b.frailty2 as frailty22012,b.frailty3 as frailty32012,b.frailty4 as frailty42012,
b.frailty5 as frailty52012,b.frailty6 as frailty62012,b.frailty7 as frailty72012,b.frailty8 as frailty82012,b.frailty9 as frailty92012,
b.frailty10 as frailty102012,b.frailty11 as frailty112012,b.frailty12 as frailty122012 
from temp9 a left join Frail.Frailty2012 b
on a.bene_id=b.bene_id;
quit;
proc sql;
create table temp11 as
select a.*,b.frailty1 as frailty12014,b.frailty2 as frailty22014,b.frailty3 as frailty32014,b.frailty4 as frailty42014,
b.frailty5 as frailty52014,b.frailty6 as frailty62014,b.frailty7 as frailty72014,b.frailty8 as frailty82014,b.frailty9 as frailty92014,
b.frailty10 as frailty102014,b.frailty11 as frailty112014,b.frailty12 as frailty122014 
from temp10 a left join Frail.Frailty2014 b
on a.bene_id=b.bene_id;
quit;

data temp12;
length ageC $15.;
set temp11;
if Dual2012>0 or Dual2013>0 or Dual2014>0 then dual=1;else dual=0;

if age<18 then ageC="<18";
else if age>=18 and age<65 then ageC="18-65";
else if age>=65 and age<75 then ageC="65-75";
else if age>=75 and age<85 then ageC="75-85";
else if age>=85  then ageC=">=85";

run;



proc tabulate data=temp12 noseps  ;
class stdcost5pct stdcost10pct stdcost25pct seg dual;  
table (dual),(stdcost10pct*(n colpctn) all*(n colpctn))/RTS=25;
table (dual),( seg*(n colpctn)  all*(n colpctn))/RTS=25;
table (dual),( seg*stdcost10pct*(n colpctn) all*(n colpctn))/RTS=25;
Keylabel all="All Dual Eligible"
         N="Number of Beneficiary"
		 colpctn="Column Percent";
 
run;

