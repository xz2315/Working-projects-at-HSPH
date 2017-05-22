*******************************
Phase II of High-Need, High Cost Patient Segmentation: 
Understanding Who Becomes and Remains High-Cost/High Need Over Time 
and the Association with Mental Health Conditions
3/20/2017
*******************************;
libname denom 'D:\Data\Medicare\Denominator';
libname stdcost 'D:\data\Medicare\StdCost\Data';
libname data 'D:\Projects\High Cost Segmentation Phase II\Data';
libname frail 'D:\data\Medicare\Frailty Indicator';

%let yr=2012;
%let yr=2013;
%let yr=2014;

* Select 20% Sample,fullAB coverage, FFS, don't include people who died  ;
data temp1&yr.;
set stdcost.Patienttotalcost&yr.;
if STRCTFLG ne '' and fullAB =1 and HMO =0 and State_CD*1 not in (40,48) and State_CD*1>=1 and State_CD*1<=53;
proc means ;  
var stdcost stdcostIP stdcostOP stdcostCar stdcostHHA stdcostSNF stdcostHospice stdcostDME stdcostPartD;
run;



* CCW; 
proc sql;
create table temp2&yr. as
select a.*, b.*
from temp1&yr. a left join data.CCW&yr. b
on a.bene_id=b.bene_id;
quit;
    

data temp3&yr.;
set temp2&yr.;
 
length AgeGroup $10.;
 
if  Age<18 then AgeGroup="<18";
else if  Age<25 then AgeGroup="18-24";
else if  Age<35 then AgeGroup="25-34";
else if  Age<45 then AgeGroup="35-44";
else if  Age<55 then AgeGroup="45-54";
else if  Age<65 then AgeGroup="55-64";
else if  Age<75 then AgeGroup="65-74";
else if  Age<85 then AgeGroup="75-85";
else if  Age>=85 then AgeGroup=">=85";


length RaceGroup $10.;
if  RACE='1' then RaceGroup="White";
else if RACE='2' then RaceGroup="Black";
else if  RACE='5' then RaceGroup="Hispanic";
else  RaceGroup="Other";

* HRSA regions: 
* https://mchdata.hrsa.gov/dgisreports/Abstract/HrsaRegionMap.htm ;
length Region $100.;
 
STATE = put(State_CD*1,st.);
 
if  STATE  in ('ME','NH','VT','MA','RI','CT') then region="HRSA Region 1:Maine, New Hampshire, Vermont, Massachusetts, Rhode Island, and Connecticut";
else if  STATE  in ('NY','NJ') then region="HRSA Region 2:New York and New Jersey";
else if  STATE  in ('PA','DC','MD','DE','VA','WV') then region="HRSA Region 3:Pennsylvania, District of Columbia, Maryland, Delaware, Virginia, and West Virginia";
else if  STATE  in ('KY','TN','NC','SC','GA','FL','AL','MS') then region="HRSA Region 4:Kentucky, Tennessee, North Carolina, South Carolina, Georgia, Florida, Alabama, and Mississippi";
else if  STATE  in ('MN','WI','IL','IN','MI','OH') then region="HRSA Region 5:Minnesota, Wisconsin, Illinois, Indiana, Michigan, and Ohio";
else if  STATE  in ('NM','TX','OK','AR','LA') then region="HRSA Region 6:New Mexico, Texas, Oklahoma, Arkansas, and Louisiana";
else if  STATE  in ('NE','KS','IA','MO') then region="HRSA Region 7:Nebraska, Kansas, Iowa, and Missouri";
else if  STATE  in ('MT','ND','SD','WY','CO','UT') then region="HRSA Region 8:Montana, North Dakota, South Dakota, Wyoming, Colorado, and Utah";
else if  STATE  in ('NV','CA','AZ','HI') then region="HRSA Region 9:Nevada, California, Arizona, and Hawaii";
else if  STATE  in ('WA','OR','ID','AK')  then region="HRSA Region 10:Washington, Oregon, Idaho, and Alaska";

zip=substr(BENE_ZIP,1,5)*1;
 
array cond {12} 
ADHD&yr. 
Anxiety&yr. 
Autism&yr. 
Bipolar&yr. 
Cerebral&yr. 
Depression&yr. 
Fibromyalgia&yr. 
Intellectual&yr. 
Personality&yr. 
PTSD&yr. 
Schizophrenia&yr. 
OtherPsychotic&yr.;
do j=1 to 12;
if cond{j}=. then cond{j}=0;
end;
drop j;
 
/* New segments:
Serious mental illness (SMI): 
Anyone with the conditions: 
major depressive disorder, schizophrenia + psychotic dz, bipolar disease

Intellectual disability (intellectual conditions): (ok to have non-SMI)
Intellectual Disabilities and Related Conditions
Cerebral Palsy
Autism Spectrum Disorders

Non-serious mental illness (non-SMI): (no presence of SMI or intellectual disability)
Anyone with the following conditions:
Anxiety disorders
Personality disorders
PTSD


*/
length segment&yr. $100.;
if Depression&yr.=1 or Schizophrenia&yr.=1 or  OtherPsychotic&yr.=1 or  Bipolar&yr.=1 then segment&yr.= "Level 1:Serious mental illness (SMI)";
else if Intellectual&yr.=1 or  Cerebral&yr.=1 or  Autism&yr.=1 then  segment&yr.="Level 2:Intellectual disability (intellectual conditions): (ok to have non-SMI)";
else if Anxiety&yr.=1 or  Personality&yr.=1 or PTSD&yr.=1  then segment&yr.="Level 3:Non-serious mental illness (non-SMI): (no presence of SMI or intellectual disability)";
else segment&yr.="Level 4:None";

rename stdcost=stdcost&yr.; 
rename stdcostIP=stdcostIP&yr.;   
rename stdcostOP=stdcostOP&yr.;  
rename stdcostCar=stdcostCar&yr.;  
rename stdcostHHA=stdcostHHA&yr.;  
rename stdcostSNF=stdcostSNF&yr.;   
rename stdcostHospice=stdcostHospice&yr.;  
rename stdcostDME=stdcostDME&yr.;  
rename stdcostPartD=stdcostPartD&yr.; 

proc freq;tables AgeGroup RaceGroup region segment&yr./missing;
proc means;
var ADHD&yr. 
Anxiety&yr. 
Autism&yr. 
Bipolar&yr. 
Cerebral&yr. 
Depression&yr. 
Fibromyalgia&yr. 
Intellectual&yr. 
Personality&yr. 
PTSD&yr. 
Schizophrenia&yr. 
OtherPsychotic&yr.;
run;

*Stratify by Zip Code Median Income in Quartiles;
*Stratify by Zip Code Education-Level in Quartiles;
libname zipdata 'D:\Data\Census';
proc rank data=zipdata.National_zcta_extract out=temp1 groups=4;
var edu_college ;
ranks edu&yr.;
run;
proc rank data=temp1 out=temp2 groups=4;
var inchh_median ;
ranks mhi&yr. ;
run;
data Zip ;
set temp2 ;
MHI&yr. =MHI&yr. +1;
Edu&yr. =Edu&yr. +1; 
edu_college&yr. =edu_college;
inchh_median&yr.=inchh_median;
zip=zip5*1;
keep zip  edu_college&yr.  inchh_median&yr. mhi&yr. edu&yr.;
label MHI&yr. ="Quartiles:Medium House Income ";
label Edu&yr. ="Quartiles:% Persons with College";
proc freq ;tables MHI&yr. Edu&yr. /missing;
proc means;var edu_college&yr. inchh_median&yr.;
run;
proc sql;
create table data.Bene&yr. as
select a.*,b.*
from temp3&yr. a left join Zip  b
on a.zIP =b.zip  ;
quit;



****************************************
Plan A: Alive 3 years
***************************************;
proc sql;
create table bene1 as
select  a.*,b.*
from data.bene2012 a inner join data.bene2013 b
on a.bene_id=b.bene_id;
quit;
proc sql;
create table bene2 as
select  a.*, b.*
from bene1 a inner join data.bene2014 b
on a.bene_id=b.bene_id;
quit;
proc rank data=bene2 out=bene3 percent;
var stdcost2012 stdcost2013 stdcost2014 ;
ranks pct_stdcost2012 pct_stdcost2013 pct_stdcost2014 ;
run;

data data.PlanABene;
set bene3;
length group $30.;
if pct_stdcost2012>=90 then HC2012 =1;else HC2012=0;
if pct_stdcost2013>=90 then HC2013 =1;else HC2013=0;
if pct_stdcost2014>=90 then HC2014 =1;else HC2014=0;

if HC2012=1 and HC2013=1 and HC2014=1 then group="HC HC HC";
else if HC2012=1 and HC2013=1 and HC2014=0 then group="HC HC nonHC";
else if HC2012=1 and HC2013=0 and HC2014=1 then group="HC nonHC HC";
else if HC2012=1 and HC2013=0 and HC2014=0 then group="HC nonHC nonHC";
else if HC2012=0 and HC2013=1 and HC2014=1 then group="nonHC HC HC";
else if HC2012=0 and HC2013=1 and HC2014=0 then group="nonHC HC nonHC";
else if HC2012=0 and HC2013=0 and HC2014=1 then group="nonHC nonHC HC";
else if HC2012=0 and HC2013=0 and HC2014=0 then group="nonHC nonHC nonHC";

length segment3yr $100.;
if segment2012="Level 1:Serious mental illness (SMI)" or segment2013="Level 1:Serious mental illness (SMI)" or segment2014="Level 1:Serious mental illness (SMI)"
then segment3yr="Level 1:Serious mental illness (SMI)";

else if segment2012="Level 2:Intellectual disability (intellectual conditions): (ok to have non-SMI)" or 
segment2013="Level 2:Intellectual disability (intellectual conditions): (ok to have non-SMI)" or 
segment2014="Level 2:Intellectual disability (intellectual conditions): (ok to have non-SMI)" 
then segment3yr="Level 2:Intellectual disability (intellectual conditions): (ok to have non-SMI)" ;

else if segment2012="Level 3:Non-serious mental illness (non-SMI): (no presence of SMI or intellectual disability)" or 
segment2013="Level 3:Non-serious mental illness (non-SMI): (no presence of SMI or intellectual disability)" or 
segment2014="Level 3:Non-serious mental illness (non-SMI): (no presence of SMI or intellectual disability)" 
then segment3yr="Level 3:Non-serious mental illness (non-SMI): (no presence of SMI or intellectual disability)" ;
else segment3yr="Level 4:None" ;
proc freq;tables HC2012 HC2013 HC2014 group
segment2012 segment2013 segment2014 segment3yr
group*segment2012 group*segment3yr/ nopercent   missing;
run;
 



** Sample ;

ODS Listing CLOSE;
ODS html file="D:\Projects\High Cost Segmentation Phase II\Sample Info.xls" style=minimal;
 
proc tabulate data=data.PlanABene noseps  missing;
class  group  segment2012  segment2013 segment2014 segment3yr;

table (Group all), 
(segment2012*(n colpctn rowpctn)  segment2013*(n colpctn rowpctn)  segment2014*(n colpctn rowpctn)  segment3yr*(n colpctn rowpctn) all*(n colpctn rowpctn) )/RTS=25;
 

 Keylabel all="All Bene"
 mean="Percent of Bene"
         N="Number of Bene"
		 colpctn="Column Percent"
rowpctn="Row Percent";
run;
 ODS html close;
ODS Listing;  
 


   
