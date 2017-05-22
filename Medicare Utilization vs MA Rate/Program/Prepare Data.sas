********************************
TM utilization vs MA penetration
Xiner ZHou
3/19/2015
*********************************;

libname MAP 'C:\data\Projects\Medicare Utilization vs MA Rate';
 


data arf;
set MAP.AHRF;
keep state county fips fipscd pop 
white black native hispanic
FFS2007 FFS2008 FFS2009 FFS2010 FFS2011 FFS2012 FFS2013
MHI2007 MHI2008 MHI2009 MHI2010 MHI2011 MHI2012 MHI2013
pov2007 pov2008 pov2009 pov2010 pov2011 pov2012 pov2013
MD2007 MD2008 MD2009 MD2010 MD2011 MD2012 MD2013
GP2007 GP2008 GP2009 GP2010 GP2011 GP2012 GP2013
Card2007 Card2008 Card2009 Card2010 Card2011 Card2012 Card2013
pulm2007 pulm2008 pulm2009 pulm2010 pulm2011 pulm2012 pulm2013
bed2007 bed2008 bed2009 bed2010 bed2011 bed2012 bed2013
intbed2007 intbed2008 intbed2009 intbed2010 intbed2011 intbed2012 intbed2013
;



fipscd=trim(f00011)||trim(f00012);fips=fipscd*1;
state=f00008;county=f00010;pop=f0453010;
 
* Percent White Population 2010;
white=f0453710;
* Percent Black/African Am Pop 2010;
black=f0453810;
*Percent Am Ind/Alaska Natve Pop 2010;
native=f0453910;
* Percent Hispanic/Latino Pop 2010;
hispanic=f0454210;

* % of total county population enrolled in Medicare 2007-2013;
FFS2007=f1528807;FFS2008=f1528808;FFS2009=f1528809;FFS2010=f1528810;FFS2011=f1528811;FFS2012=f1528811;FFS2013=f1528811; 

* Median household income 2007-2013;
MHI2007=f1322607; MHI2008=f1322608;MHI2009=f1322609;MHI2010=f1322610;MHI2011=f1322611;MHI2012=f1322612;MHI2013=f1322612;

* % population below poverty level;
pov2007=f1440806;pov2008=f1440806;pov2009=f1440806;pov2010=f1440806;pov2011=f1440808;pov2012=f1440808;pov2013=f1440808; 

* Total physicians/population: 2007-2010 using 2010 , use Census Population 2010 as estimate;
MD2007=f0885707;
MD2008=f0885708;
MD2009=f0885708;
MD2010=f0885710;
MD2011=f0885711;
MD2012=f0885712;
MD2013=f0885712;
 
*Total general practitioners/population: 2007-2010 using 2010 , 2011-2013 using 2012, use Census Population 2010 as estimate;
GP2007=f0994710;
GP2008=f0994710;
GP2009=f0994710;
GP2010=f0994710;
GP2011=f0994712;
GP2012=f0994712;
GP2013=f0994712;

*Total specialists/population: 2007-2010 using 2010 ,2011-2013 using 2012, use Census Population 2010 as estimate;
Card2007=f0463110;
Card2008=f0463110;
Card2009=f0463110;
Card2010=f0463110;
Card2011=f0463112;
Card2012=f0463112;
Card2013=f0463112;
pulm2007=f0466610;
pulm2008=f0466610;
pulm2009=f0466610;
pulm2010=f0466610;
pulm2011=f0466612;
pulm2012=f0466612;
pulm2013=f0466612;

*Total hospital beds/population: 2007-2010 using 2010 ,2011-2013 using 2011, use Census Population 2010 as estimate;
bed2007=f0892110;
bed2008=f0892110;
bed2009=f0892110;
bed2010=f0892110;
bed2011=f0892111;
bed2012=f0892111;
bed2013=f0892111;


* Intensive care beds/population: all 2011, use Census Population 2010 as estimate;;
intbed2007=f1330911+f0913311+f0913911+f0914511+f0916311;
intbed2008=f1330911+f0913311+f0913911+f0914511+f0916311;
intbed2009=f1330911+f0913311+f0913911+f0914511+f0916311;
intbed2010=f1330911+f0913311+f0913911+f0914511+f0916311;
intbed2011=f1330911+f0913311+f0913911+f0914511+f0916311;
intbed2012=f1330911+f0913311+f0913911+f0914511+f0916311;
intbed2013=f1330911+f0913311+f0913911+f0914511+f0916311;

run;
proc sort data=arf;by fips;run;

* ALL these highly correlated!;
proc corr data=arf;
var md2013 gp2013 pulm2013 card2013 bed2013 intbed2013;
run;

 



/* HRR level aggregation
Problem:
cnt_cost : county FIPS code
countytozip : FIPS to ZIP, 1 to multiple
ZIP_HSA_HRR_XWalk : zip to HSA and HRR, 1 to 1
*/

proc import datafile='C:\data\Projects\High_Cost\Data\county_to_zip_census2010.xlsx' out=FIPSzip dbms=xlsx replace;getnames=yes;run;
 
proc sql;
create table temp1 as
select a.*,b.*
from arf a left join fipszip b
on a.FIPScd =b.county;
quit;
 
data temp1;set temp1;zipnum=zcta5*1;run;

libname dart 'C:\data\Data\Dartmouth_Atlas\ZIP_HSA_HRR_XWalk';
proc sql;
create table temp2 as
select a.*,b.*
from temp1 a left join dart.Ziphsahrr12 b
on a.zipnum=b.zipcode12;
quit;

data temp2;set temp2;where hrrnum ne .;run;
 
*Get total county population;
proc sort data=temp2;by fips;run;
proc sql;
create table temp3 as
select *,sum(pop10) as countypop, pop10/calculated countypop as wt
from temp2
group by fips;
quit;

%macro HRR(var=);
* weighted HRR level characteristics;
proc means data=temp3 noprint;
weight wt;class hrrnum;
var &var.;
output out=&var. sum=&var._hrr;
run;
 
data &var.; set &var.;where hrrnum ne .;run;

proc sql;
create table temp4 as
select a.*,b.&var._hrr
from temp3 a inner join &var. b
on a.hrrnum=b.hrrnum;
quit;

* reverse weighted county level char;
proc means data=temp4 noprint;
weight wt;class fips;
var &var._hrr;
output out=&var._county mean=&var._county;
run;

data &var._county;set &var._county;where fips ne .;keep fips &var._county;run;

proc sort data=&var._county;by fips;run;

%mend HRR;
%HRR(var=MD2007);
%HRR(var=MD2008);
%HRR(var=MD2009);
%HRR(var=MD2010);
%HRR(var=MD2011);
%HRR(var=MD2012);
%HRR(var=MD2013);

%HRR(var=GP2007);
%HRR(var=GP2008);
%HRR(var=GP2009);
%HRR(var=GP2010);
%HRR(var=GP2011);
%HRR(var=GP2012);
%HRR(var=GP2013);

%HRR(var=Card2007);
%HRR(var=Card2008);
%HRR(var=Card2009);
%HRR(var=Card2010);
%HRR(var=Card2011);
%HRR(var=Card2012);
%HRR(var=Card2013);

%HRR(var=pulm2007);
%HRR(var=pulm2008);
%HRR(var=pulm2009);
%HRR(var=pulm2010);
%HRR(var=pulm2011);
%HRR(var=pulm2012);
%HRR(var=pulm2013);

%HRR(var=bed2007);
%HRR(var=bed2008);
%HRR(var=bed2009);
%HRR(var=bed2010);
%HRR(var=bed2011);
%HRR(var=bed2012);
%HRR(var=bed2013);

%HRR(var=intbed2007);
%HRR(var=intbed2008);
%HRR(var=intbed2009);
%HRR(var=intbed2010);
%HRR(var=intbed2011);
%HRR(var=intbed2012);
%HRR(var=intbed2013);





proc import datafile="C:\data\Projects\Medicare Utilization vs MA Rate\data " dbms=xls out=data replace;
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

rename &var.07 =&var.2007 &var.08 =&var.2008 &var.09 =&var.2009 &var.10 =&var.2010 &var.11 =&var.2011 &var.12 =&var.2012 &var.13 =&var.2013;
%mend miss;


data data ;
set data;
%miss(var=cost);
%miss(var=hcc);
%miss(var=MAP);
%miss(var=HMO);
%miss(var=nonHMO);


keep state county fips  cost07 cost08 cost09 cost10 cost11 cost12 cost13
hcc07 hcc08 hcc09 hcc10 hcc11 hcc12 hcc13 map07 map08 map09 map10 map11 map12 map13
hmo07 hmo08 hmo09 hmo10 hmo11 hmo12 hmo13 nonhmo07 nonhmo08 nonhmo09 nonhmo10 nonhmo11 nonhmo12 nonhmo13
;

run;
data data;
set data;
hmo2007=hmo2007*100;
hmo2008=hmo2008*100;
hmo2009=hmo2009*100;
hmo2010=hmo2010*100;
hmo2011=hmo2011*100;
hmo2012=hmo2012*100;
hmo2013=hmo2013*100;
nonhmo2007=nonhmo2007*100;
nonhmo2008=nonhmo2008*100;
nonhmo2009=nonhmo2009*100;
nonhmo2010=nonhmo2010*100;
nonhmo2011=nonhmo2011*100;
nonhmo2012=nonhmo2012*100;
nonhmo2013=nonhmo2013*100;
label fips='State and County FIPS Code';
label cost2007='Standardized Risk-Adjusted Per Capita Costs 2007';
label cost2008='Standardized Risk-Adjusted Per Capita Costs 2008';
label cost2009='Standardized Risk-Adjusted Per Capita Costs 2009';
label cost2010='Standardized Risk-Adjusted Per Capita Costs 2010';
label cost2011='Standardized Risk-Adjusted Per Capita Costs 2011';
label cost2012='Standardized Risk-Adjusted Per Capita Costs 2012';
label cost2013='Standardized Risk-Adjusted Per Capita Costs 2013';
label hcc2007='Average HCC Score 2007';
label hcc2008='Average HCC Score 2008';
label hcc2009='Average HCC Score 2009';
label hcc2010='Average HCC Score 2010';
label hcc2011='Average HCC Score 2011';
label hcc2012='Average HCC Score 2012';
label hcc2013='Average HCC Score 2013';
label map2007='MA Participation Rate 2007';
label map2008='MA Participation Rate 2008';
label map2009='MA Participation Rate 2009';
label map2010='MA Participation Rate 2010';
label map2011='MA Participation Rate 2011';
label map2012='MA Participation Rate 2012';
label map2013='MA Participation Rate 2013';
label hmo2007='MA-HMO percentage 2007 ';
label hmo2008='MA-HMO percentage 2008 ';
label hmo2009='MA-HMO percentage 2009 ';
label hmo2010='MA-HMO percentage 2010 ';
label hmo2011='MA-HMO percentage 2011 ';
label hmo2012='MA-HMO percentage 2012 ';
label hmo2013='MA-HMO percentage 2013 ';
label nonHMO2007='MA-non-HMO percentage 2007';
label nonHMO2008='MA-non-HMO percentage 2008';
label nonHMO2009='MA-non-HMO percentage 2009';
label nonHMO2010='MA-non-HMO percentage 2010';
label nonHMO2011='MA-non-HMO percentage 2011';
label nonHMO2012='MA-non-HMO percentage 2012';
label nonHMO2013='MA-non-HMO percentage 2013';
run;

proc sort data=data;by fips;run;

 

data datatemp;
merge data(in=indata) arf(in=inarf) 
/*MD2007_county(in=inMD2007) MD2008_county(in=inMD2008) MD2009_county(in=inMD2009) MD2010_county(in=inMD2010) MD2011_county(in=inMD2011) MD2012_county(in=inMD2012) MD2013_county(in=inMD2013)
GP2007_county(in=inGP2007) GP2008_county(in=inGP2008) GP2009_county(in=inGP2009) GP2010_county(in=inGP2010) GP2011_county(in=inGP2011) GP2012_county(in=inGP2012) GP2013_county(in=inGP2013)
card2007_county(in=incard2007) card2008_county(in=incard2008) card2009_county(in=incard2009) card2010_county(in=incard2010) card2011_county(in=incard2011) card2012_county(in=incard2012) card2013_county(in=incard2013)
pulm2007_county(in=inpulm2007) pulm2008_county(in=inpulm2008) pulm2009_county(in=inpulm2009) pulm2010_county(in=inpulm2010) pulm2011_county(in=inpulm2011) pulm2012_county(in=inpulm2012) pulm2013_county(in=inpulm2013)
bed2007_county(in=inbed2007) bed2008_county(in=inbed2008) bed2009_county(in=inbed2009) bed2010_county(in=inbed2010) bed2011_county(in=inbed2011) bed2012_county(in=inbed2012) bed2013_county(in=inbed2013)
intbed2007_county(in=inintbed2007) intbed2008_county(in=inintbed2008) intbed2009_county(in=inintbed2009) intbed2010_county(in=inintbed2010) intbed2011_county(in=inintbed2011) intbed2012_county(in=inintbed2012) intbed2013_county(in=inintbed2013)
*/
;
by fips;
/*
if inMD2007=1;
drop 
MD2007 MD2008 MD2009 MD2010 MD2011 MD2012 MD2013
GP2007 GP2008 GP2009 GP2010 GP2011 GP2012 GP2013
card2007 card2008 card2009 card2010 card2011 card2012 card2013
pulm2007 pulm2008 pulm2009 pulm2010 pulm2011 pulm2012 pulm2013
bed2007 bed2008 bed2009 bed2010 bed2011 bed2012 bed2013
intbed2007 intbed2008 intbed2009 intbed2010 intbed2011 intbed2012 intbed2013
MD2007_county MD2008_county MD2009_county MD2010_county MD2011_county MD2012_county MD2013_county
GP2007_county GP2008_county GP2009_county GP2010_county GP2011_county GP2012_county GP2013_county
card2007_county card2008_county card2009_county card2010_county card2011_county card2012_county card2013_county
pulm2007_county pulm2008_county pulm2009_county pulm2010_county pulm2011_county pulm2012_county pulm2013_county
bed2007_county bed2008_county bed2009_county bed2010_county bed2011_county bed2012_county bed2013_county
intbed2007_county intbed2008_county intbed2009_county intbed2010_county intbed2011_county intbed2012_county intbed2013_county;

 
label white='Percent White Population 2010';
label black='Percent Black/African Am Pop 2010';
label native='Percent Am Ind/Alaska Natve Pop 2010';
label hispanic='Percent Hispanic/Latino Pop 2010';

label MDr2007='HRR-level Total Active M.D.s Non-Federal(per 1000 population) 2007 ';
label MDr2008='HRR-level Total Active M.D.s Non-Federal(per 1000 population) 2008';
label MDr2009='HRR-level Total Active M.D.s Non-Federal(per 1000 population) 2009';
label MDr2010='HRR-level Total Active M.D.s Non-Federal(per 1000 population) 2010';
label MDr2011='HRR-level Total Active M.D.s Non-Federal(per 1000 population) 2011';
label MDr2012='HRR-level Total Active M.D.s Non-Federal(per 1000 population) 2012';
label MDr2013='HRR-level Total Active M.D.s Non-Federal(per 1000 population) 2013';

label GPr2007='HRR-level Total M.D.s General Proctice Non-Federal(per 1000 population) 2007';
label GPr2008='HRR-level Total M.D.s General Proctice Non-Federal(per 1000 population) 2008';
label GPr2009='HRR-level Total M.D.s General Proctice Non-Federal(per 1000 population) 2009';
label GPr2010='HRR-level Total M.D.s General Proctice Non-Federal(per 1000 population) 2010';
label GPr2011='HRR-level Total M.D.s General Proctice Non-Federal(per 1000 population) 2011';
label GPr2012='HRR-level Total M.D.s General Proctice Non-Federal(per 1000 population) 2012';
label GPr2013='HRR-level Total M.D.s General Proctice Non-Federal(per 1000 population) 2013';

label cardr2007='HRR-level Total Cadiovas Dis(Specialty) M.D.s Non-Federal(per 1000 population) 2007';
label cardr2008='HRR-level Total Cadiovas Dis(Specialty) M.D.s Non-Federal(per 1000 population) 2008';
label cardr2009='HRR-level Total Cadiovas Dis(Specialty) M.D.s Non-Federal(per 1000 population) 2009';
label cardr2010='HRR-level Total Cadiovas Dis(Specialty) M.D.s Non-Federal(per 1000 population) 2010';
label cardr2011='HRR-level Total Cadiovas Dis(Specialty) M.D.s Non-Federal(per 1000 population) 2011';
label cardr2012='HRR-level Total Cadiovas Dis(Specialty) M.D.s Non-Federal(per 1000 population) 2012';
label cardr2013='HRR-level Total Cadiovas Dis(Specialty) M.D.s Non-Federal(per 1000 population) 2013';

label pulmr2007='HRR-level Total Pulmonary Dis(Specialty) M.D.s Non-Federal(per 1000 population) 2007';
label pulmr2008='HRR-level Total Pulmonary Dis(Specialty) M.D.s Non-Federal(per 1000 population) 2008';
label pulmr2009='HRR-level Total Pulmonary Dis(Specialty) M.D.s Non-Federal(per 1000 population) 2009';
label pulmr2010='HRR-level Total Pulmonary Dis(Specialty) M.D.s Non-Federal(per 1000 population) 2010';
label pulmr2011='HRR-level Total Pulmonary Dis(Specialty) M.D.s Non-Federal(per 1000 population) 2011';
label pulmr2012='HRR-level Total Pulmonary Dis(Specialty) M.D.s Non-Federal(per 1000 population) 2012';
label pulmr2013='HRR-level Total Pulmonary Dis(Specialty) M.D.s Non-Federal(per 1000 population) 2013';

label bedr2007='HRR-level Total Hospital Beds (per 1000 population) 2007';
label bedr2008='HRR-level Total Hospital Beds (per 1000 population) 2008';
label bedr2009='HRR-level Total Hospital Beds (per 1000 population) 2009';
label bedr2010='HRR-level Total Hospital Beds (per 1000 population) 2010';
label bedr2011='HRR-level Total Hospital Beds (per 1000 population) 2011';
label bedr2012='HRR-level Total Hospital Beds (per 1000 population) 2012';
label bedr2013='HRR-level Total Hospital Beds (per 1000 population) 2013';

label intbedr2007='HRR-level Total Intensiven Care Beds (per 1000 population) 2007';
label intbedr2008='HRR-level Total Intensiven Care Beds (per 1000 population) 2008';
label intbedr2009='HRR-level Total Intensiven Care Beds (per 1000 population) 2009';
label intbedr2010='HRR-level Total Intensiven Care Beds (per 1000 population) 2010';
label intbedr2011='HRR-level Total Intensiven Care Beds (per 1000 population) 2011';
label intbedr2012='HRR-level Total Intensiven Care Beds (per 1000 population) 2012';
label intbedr2013='HRR-level Total Intensiven Care Beds (per 1000 population) 2013';

label pop='Census Population 2010';

label FFS2007='Medicare FFS Beneficiaries 2007';
label FFS2008='Medicare FFS Beneficiaries 2008';
label FFS2009='Medicare FFS Beneficiaries 2009';
label FFS2010='Medicare FFS Beneficiaries 2010';
label FFS2011='Medicare FFS Beneficiaries 2011';
label FFS2012='Medicare FFS Beneficiaries 2012';
label FFS2013='Medicare FFS Beneficiaries 2013';

label MHI2007='Median Household Income 2007';
label MHI2008='Median Household Income 2008';
label MHI2009='Median Household Income 2009';
label MHI2010='Median Household Income 2010';
label MHI2011='Median Household Income 2011';
label MHI2012='Median Household Income 2012';
label MHI2013='Median Household Income 2013';

label pov2007='% Persons Below Poverty Level 2007';
label pov2008='% Persons Below Poverty Level 2008';
label pov2009='% Persons Below Poverty Level 2009';
label pov2010='% Persons Below Poverty Level 2010';
label pov2011='% Persons Below Poverty Level 2011';
label pov2012='% Persons Below Poverty Level 2012';
label pov2013='% Persons Below Poverty Level 2013';



MDr2007=(MD2007_county/pop)*1000;
MDr2008=(MD2008_county/pop)*1000;
MDr2009=(MD2009_county/pop)*1000;
MDr2010=(MD2010_county/pop)*1000;
MDr2011=(MD2011_county/pop)*1000;
MDr2012=(MD2012_county/pop)*1000;
MDr2013=(MD2013_county/pop)*1000;

GPr2007=(GP2007_county/pop)*1000;
GPr2008=(GP2008_county/pop)*1000;
GPr2009=(GP2009_county/pop)*1000;
GPr2010=(GP2010_county/pop)*1000;
GPr2011=(GP2011_county/pop)*1000;
GPr2012=(GP2012_county/pop)*1000;
GPr2013=(GP2013_county/pop)*1000;

cardr2007=(card2007_county/pop)*1000;
cardr2008=(card2008_county/pop)*1000;
cardr2009=(card2009_county/pop)*1000;
cardr2010=(card2010_county/pop)*1000;
cardr2011=(card2011_county/pop)*1000;
cardr2012=(card2012_county/pop)*1000;
cardr2013=(card2013_county/pop)*1000;

pulmr2007=(pulm2007_county/pop)*1000;
pulmr2008=(pulm2008_county/pop)*1000;
pulmr2009=(pulm2009_county/pop)*1000;
pulmr2010=(pulm2010_county/pop)*1000;
pulmr2011=(pulm2011_county/pop)*1000;
pulmr2012=(pulm2012_county/pop)*1000;
pulmr2013=(pulm2013_county/pop)*1000;

bedr2007=(bed2007_county/pop)*1000;
bedr2008=(bed2008_county/pop)*1000;
bedr2009=(bed2009_county/pop)*1000;
bedr2010=(bed2010_county/pop)*1000;
bedr2011=(bed2011_county/pop)*1000;
bedr2012=(bed2012_county/pop)*1000;
bedr2013=(bed2013_county/pop)*1000;

intbedr2007=(intbed2007_county/pop)*1000;
intbedr2008=(intbed2008_county/pop)*1000;
intbedr2009=(intbed2009_county/pop)*1000;
intbedr2010=(intbed2010_county/pop)*1000;
intbedr2011=(intbed2011_county/pop)*1000;
intbedr2012=(intbed2012_county/pop)*1000;
intbedr2013=(intbed2013_county/pop)*1000;

if state in ('Connecticut','Maine','Massachusett','New Hampshir','Rhode Island','Vermont','New Jersey','New York','Pennsylvania') then region='Northeast';
if state in ('Illinois','Indiana','Michigan','Ohio','Wisconsin','Iowa','Kansas','Minnesota','Missouri','Nebraska','North Dakota','South Dakota') then region='Midwest';
if state in ('Delaware','Florida','Georgia','Maryland','North Caroli','South Caroli','Virginia','Dist. of Col','West Virgini',
'Alabama','Kentucky','Mississippi','Tennessee','Arkansas','Louisiana','Oklahoma','Texas') then region='South';
if state in ('Arizona','Colorado','Idaho','Montana','Nevada','New Mexico','Utah','Wyoming','Alaska','California','Hawaii','Oregon','Washington') then region='West';
*/
run;
 
 



***Rank County's wealth by Median House Income Quintiles or Quartile;

proc rank data=datatemp out=map.data group=5;
var mhi2007 mhi2008 mhi2009 mhi2010 mhi2011 mhi2012 mhi2013;
ranks mhi2007Rank mhi2008Rank mhi2009Rank mhi2010Rank mhi2011Rank mhi2012Rank mhi2013Rank;
 
run;






 













