**********************************
Medicare Advantage Data Preparation 
Xiner Zhou
4/29/2015
**********************************;
libname MAP 'C:\data\Projects\Medicare Utilization vs MA Rate\data';
 
%macro import(yr=);
proc import datafile="C:\data\Projects\Medicare Utilization vs MA Rate\data\State_County_All_February_2015.xlsx" 
dbms=xlsx out=year&yr. replace;
sheet="State_county &yr.";
getnames=yes;
run;

data year&yr.;
set year&yr.;
if county not in ('NATIONAL TOTAL','STATE TOTAL');
if MA_Participation_Rate in ('*','.') then MA_Participation_Rate='';
if Average_HCC_Score in ('*','.') then Average_HCC_Score='';
if Standardized_Risk_Adjusted_Per_C in ('*','.') then Standardized_Risk_Adjusted_Per_C='';

FIPS=State_and_County_FIPS_Code*1;

MAP&yr.=MA_Participation_Rate*1;
hcc&yr.=Average_HCC_Score*1;
cost&yr.=Standardized_Risk_Adjusted_Per_C*1;
DMEcost&yr.=DME_Per_Capita_Standardized_Cost*1;
HHcost&yr.=PAC__HH_Per_Capita_Standardized*1;
CMSFFS&yr.=FFS_Beneficiaries*1;
CMSAge&yr.=Average_Age*1;
CMSWhite&yr.=Percent_Non_Hispanic_White*1;
CMSBlack&yr.=Percent_African_American*1;
CMSHisp&yr.=Percent_Hispanic*1;
CMSOther&yr.=Percent_Other_Unknown*1;

keep County FIPS map&yr. hcc&yr. cost&yr. DMEcost&yr. HHcost&yr. CMSFFS&yr. CMSAge&yr.  CMSWhite&yr. CMSBlack&yr. CMSHisp&yr. CMSOther&yr. ;
proc sort;by FIPS;
run;
%mend import;
%import(yr=2007);
%import(yr=2008);
%import(yr=2009);
%import(yr=2010);
%import(yr=2011);
%import(yr=2012);
%import(yr=2013);

data data0;
merge year2007 year2008 year2009 year2010 year2011 year2012 year2013;
by FIPS;
run;


/*
proc import datafile="C:\data\Projects\Medicare Utilization vs MA Rate\data\add " dbms=xls out=add replace;
getnames=yes;
run;

%macro miss(var=);
if &var.2007 in ('*','.') then &var.2007='';
if &var.2008 in ('*','.') then &var.2008='';
if &var.2009 in ('*','.') then &var.2009='';
if &var.2010 in ('*','.') then &var.2010='';
if &var.2011 in ('*','.') then &var.2011='';
if &var.2012 in ('*','.') then &var.2012='';
if &var.2013 in ('*','.') then &var.2013='';

&var.07 =&var.2007 *1;
&var.08 =&var.2008 *1;
&var.09 =&var.2009 *1;
&var.10 =&var.2010 *1;
&var.11 =&var.2011 *1;
&var.12 =&var.2012 *1;
&var.13 =&var.2013 *1;

drop &var.2007 &var.2008 &var.2009 &var.2010 &var.2011 &var.2012 &var.2013;
%mend miss;



data add;
set add;
%miss(var=stdcost);
%miss(var=IP);
%miss(var=LTCH);
%miss(var=IRF);
%miss(var=SNF);
%miss(var=HH);
%miss(var=Hospice);
%miss(var=OP);
%miss(var=FQHC);
%miss(var=Dialysis);
%miss(var=ASC);
%miss(var=EM);
%miss(var=Procedures);
%miss(var=Imaging);
%miss(var=DME);
%miss(var=Tests);
%miss(var=PartBDrugs);
%miss(var=Ambulance);
run;

%macro rename(var=);
rename &var.07 =&var.2007 &var.08 =&var.2008 &var.09 =&var.2009 &var.10 =&var.2010 &var.11 =&var.2011 &var.12 =&var.2012 &var.13 =&var.2013;
%mend rename;


data add;
set add;
%rename(var=stdcost);
%rename(var=IP);
%rename(var=LTCH);
%rename(var=IRF);
%rename(var=SNF);
%rename(var=HH);
%rename(var=Hospice);
%rename(var=OP);
%rename(var=FQHC);
%rename(var=Dialysis);
%rename(var=ASC);
%rename(var=EM);
%rename(var=Procedures);
%rename(var=Imaging);
%rename(var=DME);
%rename(var=Tests);
%rename(var=PartBDrugs);
%rename(var=Ambulance);
run;


proc sql;
create table data as
select a.*,b.*
from data0 a left join add b
on a.fips=b.fips;
quit;


*/


















/*
From Area Health Resource File:
*/

data arf;
set AHRF;
keep state county fips fipscd 
pop2007 pop2008 pop2009 pop2010 pop2011 pop2012 pop2013 
pov2007 pov2008 pov2009 pov2010 pov2011 pov2012 pov2013 
MHI2007 MHI2008 MHI2009 MHI2010 MHI2011 MHI2012 MHI2013
;

fipscd=trim(f00011)||trim(f00012);fips=fipscd*1;
state=f00008;county=f00010;

* County Population 2007 2008 2009 2010 2011 2012 2013;
pop2007=f1198407;pop2008=f1198408;pop2009=f1198409;pop2010=f0453010;pop2011=f1198411;pop2012=f1198412;pop2013=f1198413;
 
*% Persons Below Poverty Level 2006-10 % Persons Below Poverty Level 2008-12;
pov2007=f1440806;pov2008=f1440806;pov2009=f1440806;pov2010=f1440806;pov2011=f1440808;pov2012=f1440808;pov2013=f1440808; 

* Median household income 2007 2008 2009 2010 2011 2012 ;
MHI2007=f1322607; MHI2008=f1322608;MHI2009=f1322609;MHI2010=f1322610;MHI2011=f1322611;MHI2012=f1322612;MHI2013=f1322612;
run;



*HRR market char: Physician PCP Specialty Hospitalbeds;
/*
Dartmouth Atlantas Data: HRR level
*/
proc import datafile="C:\data\Projects\Medicare Utilization vs MA Rate\data\Dartmouth" dbms=xls out=Dartmouth replace;
getnames=yes;
run;
data Dartmouth;
set Dartmouth;

Physician2007=Physician2006/100;Physician2008=Physician2006/100;Physician2009=Physician2006/100;
Physician2010=Physician2011/100;Physician2012=Physician2011/100;Physician2013=Physician2011/100;Physician2011=Physician2011/100;
PrimaryCare2007=PrimaryCare2006/100;PrimaryCare2008=PrimaryCare2006/100;PrimaryCare2009=PrimaryCare2006/100;
PrimaryCare2010=PrimaryCare2011/100;PrimaryCare2012=PrimaryCare2011/100;PrimaryCare2013=PrimaryCare2011/100;PrimaryCare2011=PrimaryCare2011/100;
Specialty2007=Specialty2006/100;Specialty2008=Specialty2006/100;Specialty2009=Specialty2006/100;
Specialty2010=Specialty2011/100;Specialty2012=Specialty2011/100;Specialty2013=Specialty2011/100;Specialty2011=Specialty2011/100;
run;

/* 
From AHA : HRR level
Total Hospital Beds 2007-2012
*/
libname AHA 'C:\data\Data\Hospital\AHA\Annual_Survey\Data';

%macro aha(yr=);
data aha&yr.;
	set aha.aha&yr.(keep=provider hrrcode hospbd serv );
	temp=substr(provider,3,2)*1;
    if temp in (0,1,2,3,4,5,6,7,8,9,13) and serv=10;
	hrrnum=hrrcode*1;
	rename hospbd=hospbd&yr.;
	keep provider hrrnum hospbd ;
proc sort;by provider;run;
%mend aha;
%aha(yr=07);
%aha(yr=09);
%aha(yr=10);
%aha(yr=11);
%aha(yr=12);
data AHA;
merge aha07 aha09 aha10 aha11 aha12 ;
by provider;
hospbd08=hospbd09;
hospbd13=hospbd12;
run;

proc sort data=aha;by hrrnum;run;
proc sql;
create table AHAbed as
select hrrnum, sum(hospbd07) as hospbd2007,sum(hospbd08) as hospbd2008,sum(hospbd09) as hospbd2009,
sum(hospbd10) as hospbd2010,sum(hospbd11) as hospbd2011,sum(hospbd12) as hospbd2012,sum(hospbd13) as hospbd2013
from aha
group by hrrnum;
quit;
data AHAbed;set AHAbed;where hrrnum ne .;run;


********************************HRR Aggregation;
* county to HRR crosswalk and population ratio;
proc import datafile='C:\data\Projects\High_Cost\Data\county_to_zip_census2010.xlsx' out=FIPSzip dbms=xlsx replace;getnames=yes;run;
 
proc sql;
create table temp1 as
select a.fipscd,b.pop10,b.*,b.pop10/a.pop2010 as ratio
from arf a left join fipszip b
on a.FIPScd =b.county;
quit;
  
data temp1;set temp1;zipnum=zcta5*1;run;
libname dart 'C:\data\Data\Dartmouth_Atlas\ZIP_HSA_HRR_XWalk';
proc sql;
create table temp2 as
select a.*,b.hrrnum,b.hrrcity,b.hrrstate
from temp1 a left join dart.Ziphsahrr12 b
on a.zipnum=b.zipcode12;
quit;

data temp2;set temp2;where hrrnum ne .;run;

* market characteristics from HRR/per 100,000 residents to county/per 100,000 residents;
proc sql;
create table phy_hosp as
select a.*,b.*
from dartmouth a left join ahabed b
on a.hrrnum =b.hrrnum;
quit;

data phy_hosp ;
set phy_hosp ;
hospbd07=hospbd2007*1000/pop2006;hospbd08=hospbd2008*1000/pop2006;hospbd09=hospbd2009*1000/pop2006;
hospbd10=hospbd2010*1000/pop2011;hospbd11=hospbd2011*1000/pop2011;hospbd12=hospbd2012*1000/pop2011;hospbd13=hospbd2013*1000/pop2011;
drop hospbd2007 hospbd2008 hospbd2009 hospbd2010 hospbd2011 hospbd2012 hospbd2013;
run;


* Merge county-HRR crosswalk to HRR market ;
proc sql;
create table temp3 as
select a.*,b.*
from temp2 a left join phy_hosp b
on a.hrrnum=b.hrrnum;
quit;

%macro mean(var=);
proc means data=temp3 noprint;
class fipscd;weight ratio;
var &var.;
output out=&var.(drop=_freq_ _type_) mean=&var.;
run;
data &var.;set &var.;if fipscd ne '';run;
%mend mean;
%mean(var=Physician2007);
%mean(var=Physician2008);
%mean(var=Physician2009);
%mean(var=Physician2010);
%mean(var=Physician2011);
%mean(var=Physician2012);
%mean(var=Physician2013);

%mean(var=PrimaryCare2007);
%mean(var=PrimaryCare2008);
%mean(var=PrimaryCare2009);
%mean(var=PrimaryCare2010);
%mean(var=PrimaryCare2011);
%mean(var=PrimaryCare2012);
%mean(var=PrimaryCare2013);

%mean(var=Specialty2007);
%mean(var=Specialty2008);
%mean(var=Specialty2009);
%mean(var=Specialty2010);
%mean(var=Specialty2011);
%mean(var=Specialty2012);
%mean(var=Specialty2013);

%mean(var=hospbd07);
%mean(var=hospbd08);
%mean(var=hospbd09);
%mean(var=hospbd10);
%mean(var=hospbd11);
%mean(var=hospbd12);
%mean(var=hospbd13);

data market;
merge Physician2007 Physician2008 Physician2009 Physician2010 Physician2011 Physician2012 Physician2013
PrimaryCare2007 PrimaryCare2008 PrimaryCare2009 PrimaryCare2010 PrimaryCare2011 PrimaryCare2012 PrimaryCare2013
Specialty2007 Specialty2008 Specialty2009 Specialty2010 Specialty2011 Specialty2012 Specialty2013
hospbd07 hospbd08 hospbd09 hospbd10 hospbd11 hospbd12 hospbd13;
by fipscd;
fips=fipscd*1;
rename hospbd07 =hospbd2007;rename hospbd08 =hospbd2008;rename hospbd09 =hospbd2009;
rename hospbd10 =hospbd2010;rename hospbd11 =hospbd2011;rename hospbd12 =hospbd2012;rename hospbd13 =hospbd2013;
run;


proc means data=market mean std min max;
var Physician2007 Physician2008 Physician2009 Physician2010 Physician2011 Physician2012 Physician2013
PrimaryCare2007 PrimaryCare2008 PrimaryCare2009 PrimaryCare2010 PrimaryCare2011 PrimaryCare2012 PrimaryCare2013
Specialty2007 Specialty2008 Specialty2009 Specialty2010 Specialty2011 Specialty2012 Specialty2013
hospbd2007 hospbd2008 hospbd2009 hospbd2010 hospbd2011 hospbd2012 hospbd2013 ;
run;
 





































/*
From CMS Medicare Beneficiary Data:  
	Race 2007-2012
*/
libname denom 'C:\data\Data\Medicare\Denominator';

  proc import datafile='C:\data\Projects\Medicare Utilization vs MA Rate\data\SSAtoFIPS.xls' out=SSAtoFIPS dbms=xls replace;getnames=yes;run;
proc format ;
value $race_ 
1='White'
2='Black'
5='Hispanic'
0='Others'
;
run;

%macro bene(yr=);
data temp1&yr.;
set denom.Dnmntr&yr.;

	*1. Age >=65 ;
	*if age >=65; 
	*2. only Fee-For-Service;
	if HMOIND01 in ('0','4') and HMOIND02 in ('0','4') and HMOIND03 in ('0','4') and HMOIND04 in ('0','4') and HMOIND05 in ('0','4')
    and HMOIND06 in ('0','4') and HMOIND07 in ('0','4') and HMOIND08 in ('0','4') and HMOIND09 in ('0','4') and HMOIND10 in ('0','4')
    and HMOIND11 in ('0','4') and HMOIND12 in ('0','4')   ;
	*3. ENROLLMENT ;	 
	death_month = month(death_dt);
	   * test enrollment for enrollees who died during year ;
	    if death_dt^=' ' then do ;
		     CON_ENR = (A_MO_CNT >= death_month and B_MO_CNT >= death_month) ;
	    end;

		* test enrollment for those who aged in during year ;
		else if age <=65 then do ;
			aged_in_month = min((12 - month(BENE_DOB)), 1) ;
		    CON_ENR = (A_MO_CNT >= aged_in_month and B_MO_CNT >= aged_in_month) ;
		end;

		* all else ;
		else do ;
			CON_ENR = (A_MO_CNT = 12 and B_MO_CNT = 12) ;
		end;

    	label CON_ENR = "enrolled in A & B for eligible months during 2011" ;

	if CON_ENR = 1;
     SSA=trim(state_cd)||trim(cnty_cd);
	 if race not in ('1','2','5') then race='0';
	 format race $race_.;
keep bene_id SSA state_cd cnty_cd sex race age;
run;

proc sql;
create table temp2&yr. as
select a.*,b.*
from temp1&yr. a left join SSAtoFIPS b
on a.SSA=b.SSA;
quit;

* FFS Bene by county;
proc sort data=temp2&yr. ;by fips;run;
proc sql;
create table FFS&yr. as
select fips,count(bene_id) as county_bene,mean(age) as county_age, count(case when race='1' then bene_id else '' end ) as county_white,
count(case when race='2' then bene_id else '' end ) as county_black,count(case when race='5' then bene_id else '' end ) as county_hispanic,
count(case when race not in ('1','2','5') then bene_id else '' end ) as county_others 
from temp2&yr.  
group by fips;
quit;

data ffs&yr.;
set ffs&yr.;
if fips ne '';
age&yr.=county_age;
whitepct&yr.=county_white/county_bene;
blackpct&yr.=county_black/county_bene;
hisppct&yr.=county_hispanic/county_bene;
otherpct&yr.=county_others/county_bene;
FFS&yr.=county_bene;
keep fips age&yr.  FFS&yr. whitepct&yr. blackpct&yr. hisppct&yr. otherpct&yr.;
run;

%mend bene;
%bene(yr=2007);
%bene(yr=2008);
%bene(yr=2009);
%bene(yr=2010);
/*
Race:
0 UNKNOWN
1 WHITE
2 BLACK
3 OTHER
4 ASIAN
5 HISPANIC
6 NORTH AMERICAN NATIVE

Research Triangle Institute (RTI) Race Code:
0 UNKNOWN
1 NON-HISPANIC WHITE
2 BLACK (OR AFRICAN-AMERICAN)
3 OTHER
4 ASIAN/PACIFIC ISLANDER
5 HISPANIC
6 AMERICAN INDIAN / ALASKA NATIVE
*/
%macro bene1(yr=);
data temp1&yr.;
set denom.Dnmntr&yr.;

	*1. Age >=65 ;
	*if age >=65; 
	*2. only Fee-For-Service;
	if HMOIND01 in ('0','4') and HMOIND02 in ('0','4') and HMOIND03 in ('0','4') and HMOIND04 in ('0','4') and HMOIND05 in ('0','4')
    and HMOIND06 in ('0','4') and HMOIND07 in ('0','4') and HMOIND08 in ('0','4') and HMOIND09 in ('0','4') and HMOIND10 in ('0','4')
    and HMOIND11 in ('0','4') and HMOIND12 in ('0','4')   ;
	*3. ENROLLMENT ;	 
	death_month = month(death_dt);
	   * test enrollment for enrollees who died during year ;
	    if death_dt^=' ' then do ;
		     CON_ENR = (A_MO_CNT >= death_month and B_MO_CNT >= death_month) ;
	    end;

		* test enrollment for those who aged in during year ;
		else if age <=65 then do ;
			aged_in_month = min((12 - month(BENE_DOB)), 1) ;
		    CON_ENR = (A_MO_CNT >= aged_in_month and B_MO_CNT >= aged_in_month) ;
		end;

		* all else ;
		else do ;
			CON_ENR = (A_MO_CNT = 12 and B_MO_CNT = 12) ;
		end;

    	label CON_ENR = "enrolled in A & B for eligible months during 2011" ;

	if CON_ENR = 1;
     SSA=trim(state_cd)||trim(cnty_cd);
	 if race not in ('1','2','5') then race='0';
	 format race $race_.;
keep bene_id SSA state_cd cnty_cd sex race RTI_RACE_CD age;
run;

proc sql;
create table temp2&yr. as
select a.*,b.*
from temp1&yr. a left join SSAtoFIPS b
on a.SSA=b.SSA;
quit;

* FFS Bene by county;
proc sort data=temp2&yr. ;by fips;run;
proc sql;
create table FFS&yr. as
select fips,count(bene_id) as county_bene,mean(age) as county_age, count(case when race='1' then bene_id else '' end ) as county_white,
count(case when race='2' then bene_id else '' end ) as county_black,count(case when race='5' then bene_id else '' end ) as county_hispanic,
count(case when race not in ('1','2','5') then bene_id else '' end ) as county_others,

count(case when RTI_RACE_CD='1' then bene_id else '' end ) as county_white1,
count(case when RTI_RACE_CD='2' then bene_id else '' end ) as county_black1,
count(case when RTI_RACE_CD='5' then bene_id else '' end ) as county_hispanic1,
count(case when RTI_RACE_CD not in ('1','2','5') then bene_id else '' end ) as county_others1 

from temp2&yr.  
group by fips;
quit;

data ffs&yr.;
set ffs&yr.;
if fips ne '';
age&yr.=county_age;
whitepct&yr.=county_white/county_bene;
blackpct&yr.=county_black/county_bene;
hisppct&yr.=county_hispanic/county_bene;
otherpct&yr.=county_others/county_bene;

whitepct1&yr.=county_white1/county_bene;
blackpct1&yr.=county_black1/county_bene;
hisppct1&yr.=county_hispanic1/county_bene;
otherpct1&yr.=county_others1/county_bene;

FFS&yr.=county_bene;
keep fips age&yr.  FFS&yr. whitepct&yr. blackpct&yr. hisppct&yr. otherpct&yr. whitepct1&yr. blackpct1&yr. hisppct1&yr. otherpct1&yr.;
run;

%mend bene1;
%bene1(yr=2011);
%bene1(yr=2012);
%bene1(yr=2013);
data race;
merge ffs2007  ffs2008 ffs2009 ffs2010 ffs2011 ffs2012 ffs2013;
by fips;
fips1=fips*1;
drop fips;
rename fips1=fips;
run;




******************************Employment Rate;
proc import datafile="C:\data\Projects\Medicare Utilization vs MA Rate\Data\Employment.xlsx" 
dbms=xlsx out=Employ2007 replace;sheet="2007";getnames=yes;
run;
proc import datafile="C:\data\Projects\Medicare Utilization vs MA Rate\Data\Employment.xlsx" 
dbms=xlsx out=Employ2008 replace;sheet="2008";getnames=yes;
run;
proc import datafile="C:\data\Projects\Medicare Utilization vs MA Rate\Data\Employment.xlsx" 
dbms=xlsx out=Employ2009 replace;sheet="2009";getnames=yes;
run;
proc import datafile="C:\data\Projects\Medicare Utilization vs MA Rate\Data\Employment.xlsx" 
dbms=xlsx out=Employ2010 replace;sheet="2010";getnames=yes;
run;
proc import datafile="C:\data\Projects\Medicare Utilization vs MA Rate\Data\Employment.xlsx" 
dbms=xlsx out=Employ2011 replace;sheet="2011";getnames=yes;
run;
proc import datafile="C:\data\Projects\Medicare Utilization vs MA Rate\Data\Employment.xlsx" 
dbms=xlsx out=Employ2012 replace;sheet="2012";getnames=yes;
run;
proc import datafile="C:\data\Projects\Medicare Utilization vs MA Rate\Data\Employment.xlsx" 
dbms=xlsx out=Employ2013 replace;sheet="2013";getnames=yes;
run;
proc sort data=Employ2007;by FIPS;run;
proc sort data=Employ2008;by FIPS;run;
proc sort data=Employ2009;by FIPS;run;
proc sort data=Employ2010;by FIPS;run;
proc sort data=Employ2011;by FIPS;run;
proc sort data=Employ2012;by FIPS;run;
proc sort data=Employ2013;by FIPS;run;
data Employ;
merge Employ2007 Employ2008 Employ2009 Employ2010 Employ2011 Employ2012 Employ2013;
by FIPS;
fipsnum=fips*1;drop fips;rename fipsnum=fips;
run;


 

* New HMO Penetration File;
proc import datafile="C:\data\Projects\Medicare Utilization vs MA Rate\Data\Medicare Advantage HMO penetration by county" dbms=xls out=Penetration replace;
getnames=yes;
run;




*************************************************Final Analytic Dataset;
proc sort data=data0;by fips;run;*numeric;
proc sort data=arf;by fips;run;*nunmeric;
proc sort data=market;by fips;run;*numeric;
proc sort data=race;by fips;run;*numeric;
proc sort data=Employ;by fips;run;*numeric;
proc sort data=Penetration;by fips;run;*numeric;
 

data data1;
length state $19.;
merge data0 arf market race Employ Penetration;
by fips;

if state not in ('Puerto Rico','US Virgin Islands','Guam','');
if state in ('Connecticut','Maine','Massachusetts','New Hampshire','Rhode Island','Vermont','New Jersey','New York','Pennsylvania') then region=0;
if state in ('Illinois','Indiana','Michigan','Ohio','Wisconsin','Iowa','Kansas','Minnesota','Missouri','Nebraska','North Dakota','South Dakota') then region=1;
if state in ('Delaware','Florida','Georgia','Maryland','North Carolina','South Carolina','Virginia','Dist. of Columbia','West Virginia',
'Alabama','Kentucky','Mississippi','Tennessee','Arkansas','Louisiana','Oklahoma','Texas') then region=2;
if state in ('Arizona','Colorado','Idaho','Montana','Nevada','New Mexico','Utah','Wyoming','Alaska','California','Hawaii','Oregon','Washington') then region=3;

EmployRate2007=Employed2007/Pop2007;
EmployRate2008=Employed2008/Pop2008;
EmployRate2009=Employed2009/Pop2009;
EmployRate2010=Employed2010/Pop2010;
EmployRate2011=Employed2011/Pop2011;
EmployRate2012=Employed2012/Pop2012;
EmployRate2013=Employed2013/Pop2013;
run;

  
proc rank data=data1 out=data2 group=4;
var 
map2007  
hmo_penetration_07 hmo_penetration_08 hmo_penetration_09 hmo_penetration_10
hmo_penetration_11 hmo_penetration_12 hmo_penetration_13 
physician2007 physician2008 physician2009 physician2010 physician2011 physician2012 physician2013
PrimaryCare2007 PrimaryCare2008 PrimaryCare2009 PrimaryCare2010 PrimaryCare2011 PrimaryCare2012 PrimaryCare2013
Specialty2007 Specialty2008 Specialty2009 Specialty2010 Specialty2011 Specialty2012 Specialty2013
hospbd2007 hospbd2008 hospbd2009 hospbd2010 hospbd2011 hospbd2012 hospbd2013
mhi2007 mhi2008 mhi2009 mhi2010 mhi2011 mhi2012 mhi2013;
ranks
map2007rank
hmo_penetration_07rank hmo_penetration_08rank hmo_penetration_09rank hmo_penetration_10rank
hmo_penetration_11rank hmo_penetration_12rank hmo_penetration_13rank 
physician2007rank physician2008rank physician2009rank physician2010rank physician2011rank physician2012rank physician2013rank
PrimaryCare2007rank PrimaryCare2008rank PrimaryCare2009rank PrimaryCare2010rank PrimaryCare2011rank PrimaryCare2012rank PrimaryCare2013rank
Specialty2007rank Specialty2008rank Specialty2009rank Specialty2010rank Specialty2011rank Specialty2012rank Specialty2013rank
hospbd2007rank hospbd2008rank hospbd2009rank hospbd2010rank hospbd2011rank hospbd2012rank hospbd2013rank
mhi2007Rank mhi2008Rank mhi2009Rank mhi2010Rank mhi2011Rank mhi2012Rank mhi2013Rank ;
run;


proc rank data=data1 out=data3 group=4;
where state not in ('Minnesota');
var 
map2007 
hmo_penetration_07 hmo_penetration_08 hmo_penetration_09 hmo_penetration_10
hmo_penetration_11 hmo_penetration_12 hmo_penetration_13;
ranks
map2007rank1 
hmo_penetration_07rank1  hmo_penetration_08rank1  hmo_penetration_09rank1  hmo_penetration_10rank1 
hmo_penetration_11rank1  hmo_penetration_12rank1  hmo_penetration_13rank1 ;
run;
 
proc sql;
create table data4 as
select a.*,b.map2007rank1,b.hmo_penetration_07rank1,b.hmo_penetration_08rank1,b.hmo_penetration_09rank1,
b.hmo_penetration_10rank1,b.hmo_penetration_11rank1,b.hmo_penetration_12rank1,b.hmo_penetration_13rank1
from data2 a left join data3 b
on a.fips=b.fips;
quit;




%macro import(yr=);
proc import datafile="C:\data\Projects\Medicare Utilization vs MA Rate\Data\Medicare Advantage Payment Rate.xlsx" 
dbms=xlsx out=Pay&yr. replace;
sheet="Sheet&yr.";
getnames=yes;
run;
proc sort data=Pay&yr.;by county;run;
%mend import;
%import(yr=2007);
%import(yr=2008);
%import(yr=2009);
%import(yr=2010);
%import(yr=2011);
%import(yr=2012);
%import(yr=2013);

data temp1;
merge Pay2007 Pay2008 Pay2009 Pay2010 Pay2011 Pay2012 Pay2013;
by county;
run;

proc import datafile="C:\data\Projects\Medicare Utilization vs MA Rate\Data\SSAtoFIPS.xls" 
dbms=xls out=SSAtoFIPS replace;
getnames=yes;
run;
 

data SSAtoFIPS;
set SSAtoFIPS;
county=ssa*1;
fipsCD=fips*1;drop fips;rename fipsCD=fips;
keep county fipsCD;
run;


proc sql;
create table temp2 as
select a.*,b.fips 
from temp1 a left join SSAtoFIPS b
on a.county=b.county;
quit;

proc sql;
create table temp3 as
select a.*,b.Payrate2007,b.Payrate2008,b.Payrate2009,b.Payrate2010,b.Payrate2011,b.Payrate2012,b.Payrate2013
from data4 a left join temp2 b
on a.fips=b.fips ;
quit;

data map.data;
set temp3;
run;
