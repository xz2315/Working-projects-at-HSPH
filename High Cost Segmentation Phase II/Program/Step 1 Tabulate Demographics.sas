************************************************************************************
Persistent Medicare HC 2012-2014 -Jose
Demographics  
Xiner Zhou
3/21/2017
************************************************************************************;
libname denom 'D:\Data\Medicare\Denominator';
libname data 'D:\Projects\High Cost Segmentation Phase II\Data';
libname seg 'D:\Projects\High_Cost_Segmentation\Data'; 
libname frail 'D:\data\Medicare\Frailty Indicator';


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



ODS Listing CLOSE;
ODS html file="D:\Projects\High Cost Segmentation Phase II\Demographics.xls" style=minimal;
 
proc tabulate data=temp9 noseps  missing;
title "Demographics";
class  group region state seg2012 seg2013 seg2014 segment2012 AgeGroup Sex RaceGroup  N_Frailty2012 N_Frailty2013 N_Frailty2014 MHI2012 Edu2012
r_Measure1 r_Measure2 r_Measure3 r_Measure4 r_Measure5 r_Measure6 r_Measure7 r_Measure8 r_Measure9 r_Measure10 r_Measure11;
var age Dual
ADHD2012 Anxiety2012  Autism2012 Bipolar2012 Cerebral2012 Depression2012 Fibromyalgia2012 Intellectual2012 Personality2012 PTSD2012 Schizophrenia2012 OtherPsychotic2012
ADHD2013 Anxiety2013  Autism2013 Bipolar2013 Cerebral2013 Depression2013 Fibromyalgia2013 Intellectual2013 Personality2013 PTSD2013 Schizophrenia2013 OtherPsychotic2013
ADHD2014 Anxiety2014  Autism2014 Bipolar2014 Cerebral2014 Depression2014 Fibromyalgia2014 Intellectual2014 Personality2014 PTSD2014 Schizophrenia2014 OtherPsychotic2014
Frailty12012 Frailty22012 Frailty32012 Frailty42012 Frailty52012 Frailty62012 Frailty72012 Frailty82012 Frailty92012 Frailty102012 Frailty112012 Frailty122012 
Frailty12013 Frailty22013 Frailty32013 Frailty42013 Frailty52013 Frailty62013 Frailty72013 Frailty82013 Frailty92013 Frailty102013 Frailty112013 Frailty122013 
Frailty12014 Frailty22014 Frailty32014 Frailty42014 Frailty52014 Frailty62014 Frailty72014 Frailty82014 Frailty92014 Frailty102014 Frailty112014 Frailty122014
;  
 
format Sex $Sex_.;
format MHI2012 Q_.;
format Edu2012 Q_.;
format r_Measure1 measureQ_.;format r_Measure2 measureQ_.;format r_Measure3 measureQ_.;format r_Measure4 measureQ_.;format r_Measure5 measureQ_.;format r_Measure6 measureQ_.;
format r_Measure7 measureQ_.;format r_Measure8 measureQ_.;format r_Measure9 measureQ_.;format r_Measure10 measureQ_.;format r_Measure11 measureQ_.;

table (AgeGroup Sex RaceGroup region state  MHI2012 Edu2012 seg2012="Segmentation 2012" seg2013="Segmentation 2013" seg2014="Segmentation 2014"), 
(group*(n colpctn) segment2012*(n colpctn) group*segment2012*(n colpctn) segment2012*group*(n colpctn) all*(n colpctn) )/RTS=25;
table dual, (group*(mean*f=15.5)  segment2012*(mean*f=15.5) group*segment2012*(mean*f=15.5)  segment2012*group*(mean*f=15.5) all*(mean*f=15.5))/RTS=25;

table ( 
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
 
),
(group*(mean*f=15.5)  segment2012*(mean*f=15.5) group*segment2012*(mean*f=15.5)  segment2012*group*(mean*f=15.5) all*(mean*f=15.5))/RTS=25;
 
table (
Frailty12012 Frailty12013 Frailty12014 
Frailty22012 Frailty22013 Frailty22014
Frailty32012 Frailty32013 Frailty32014
Frailty42012 Frailty42013 Frailty42014
Frailty52012 Frailty52013 Frailty52014
Frailty62012 Frailty62013 Frailty62014
Frailty72012 Frailty72013 Frailty72014
Frailty82012 Frailty82013 Frailty82014
Frailty92012 Frailty92013 Frailty92014
Frailty102012 Frailty102013 Frailty102014
Frailty112012 Frailty112013 Frailty112014
Frailty122012 Frailty122013 Frailty122014
), 
(group*(mean*f=15.5) segment2012*(mean*f=15.5) group*segment2012*(mean*f=15.5) segment2012*group*(mean*f=15.5) all*(mean*f=15.5) )/RTS=25;

table (
N_Frailty2012 N_Frailty2013 N_Frailty2014),
(group*(n colpctn) segment2012*(n colpctn) group*segment2012*(n colpctn) segment2012*group*(n colpctn) all*(n colpctn) )/RTS=25;

table ( r_Measure1 r_Measure2 r_Measure3 r_Measure4 r_Measure5 r_Measure6 r_Measure7 r_Measure8 r_Measure9 r_Measure10 r_Measure11),
(group*(n colpctn) segment2012*(n colpctn) group*segment2012*(n colpctn) segment2012*group*(n colpctn) all*(n colpctn) )/RTS=25;

 Keylabel all="All Bene"
 mean="Percent of Bene"
         N="Number of Bene"
		 colpctn="Column Percent"
;
run;
 ODS html close;
ODS Listing;  
 


   
