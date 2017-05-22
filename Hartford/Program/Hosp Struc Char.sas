**********************************
Hospital Structural Characteristics
Xiner Zhou
8/17/2015
************************************;
libname aha 'C:\data\Data\Hospital\AHA\Annual_Survey\Data';
libname data 'C:\data\Projects\Hartford\Data';

 


* hospsize is derived from Bed Size Code (BSC) ;

* Rural/Urban is derived from CBSATYPE : Metro, Micro, Division, Rural ;

* MHSMEMB is System Affliation;

* NETWRK is Network Affliation;

* p_medicare p_medicaid is Proportion of Medicare/Medicaid Discharges=Facility Medicare/medicaid Discharge/Admission Total;

* Critical Access MAPP18 ;

* Teaching status is derived from MAPP3 and MAPP8;
* Major teaching hospital: MAPP8=1, Membership in Council of Teaching Hospitals of the AAMC ;
* Minor teaching hospital: MAPP3=1 or MAPP5=1, Residency training approved by ACGME or Med School affiliation reported to AMA ;
* None teaching hospital: none of the above;

* profit2 is derived from CNTRL, Ownership (Type of authority responsible for establishing policies ;

* Safety-Net Hosptial : from Medicare Impact File, DSH index into quartiles ;


data data.aha12;
retain provider id;
set aha.aha12(keep=provider id hospsize BSC hosp_reg4 CBSATYPE RUCA_level MHSMEMB NETWRK p_medicare p_medicaid MAPP18 profit2 teaching HSAcode HSAName MAPP8 MAPP3);
label CBSATYPE='Rural/Urban';
if MHSMEMB='' then MHSMEMB='0';
if NETWRK='' then NETWRK='0';
BSC1=BSC*1;rename BSC1=BSC;
keep provider id hospsize BSC1 hosp_reg4 CBSATYPE RUCA_level MHSMEMB NETWRK p_medicare p_medicaid MAPP18 profit2 teaching HSAcode HSAName MAPP8 MAPP3 ;
run;

data data.aha11;
retain provider id;
set aha.aha11(keep=provider id hospsize BSC hosp_reg4 CBSATYPE RUCA_level  MHSMEMB NETWRK p_medicare p_medicaid MAPP18 profit2 teaching HSAcode HSAName MAPP8 MAPP3);
label CBSATYPE='Rural/Urban';
if MHSMEMB='' then MHSMEMB='0';
if NETWRK='' then NETWRK='0';
keep provider id hospsize BSC hosp_reg4 CBSATYPE RUCA_level  MHSMEMB NETWRK p_medicare p_medicaid MAPP18 profit2 teaching  HSAcode HSAName MAPP8 MAPP3;
run;

data data.aha10;
retain provider id;
set aha.aha10(keep=provider id hospsize BSC hosp_reg4 CBSATYPE RUCA_level  MHSMEMB NETWRK p_medicare p_medicaid MAPP18 profit2 teaching HSAcode HSAName MAPP8 MAPP3);
label CBSATYPE='Rural/Urban';
if MHSMEMB='' then MHSMEMB='0';
if NETWRK='' then NETWRK='0';
keep provider id hospsize BSC hosp_reg4 CBSATYPE RUCA_level  MHSMEMB NETWRK p_medicare p_medicaid MAPP18 profit2 teaching  HSAcode HSAName MAPP8 MAPP3;
run;

data data.aha09;
retain provider id;
set aha.aha09(keep=provider id hospsize BSC hosp_reg4 CBSATYPE RUCA_level  MHSMEMB NETWRK p_medicare p_medicaid MAPP18 profit2 teaching HSAcode HSAName MAPP8 MAPP3);
label CBSATYPE='Rural/Urban';
if MHSMEMB='' then MHSMEMB='0';
if NETWRK='' then NETWRK='0';
keep provider id hospsize BSC hosp_reg4 CBSATYPE RUCA_level  MHSMEMB NETWRK p_medicare p_medicaid MAPP18 profit2 teaching  HSAcode HSAName MAPP8 MAPP3;
run;

data AHA;
set data.AHA12(in=in1) data.AHA11(in=in2) data.AHA10(in=in3)
    data.AHA09(in=in4) ;
	if in1 then year=2012;
	else if in2 then year=2011;
	else if in3 then year=2010;
	else if in4 then year=2009;
	provider_num=provider*1;
	proc sort ;by provider descending year;
run;

proc sort data=AHA nodupkey;by provider;run;

 


libname impact 'C:\data\Data\Hospital\Impact';
data impact2012;
set impact.impact2012;
keep provider  dshpct2012;
proc sort;by provider ;
run;

data impact2011;
set impact.impact2011;
keep provider  dshpct2011;
proc sort;by provider ;
run;

data impact2010;
set impact.impact2010;
keep provider  dshpct2010 ;
proc sort;by provider ;
run;

data impact2009;
set impact.impact2009;
keep provider  dshpct2009;
proc sort;by provider ;
run;

data impact2008;
set impact.impact2008;
keep provider  dshpct2008 ;
proc sort;by provider ;
run;

proc sql;
create table temp2008 as
select a.*,b.dshpct2008 
from AHA a left join impact2008 b
on a.provider_num=b.provider;
quit;

proc sql;
create table temp2009 as
select a.*,b.dshpct2009 
from temp2008 a left join impact2009 b
on a.provider_num=b.provider;
quit;

proc sql;
create table temp2010 as
select a.*,b.dshpct2010 
from temp2009 a left join impact2010 b
on a.provider_num=b.provider;
quit;

proc sql;
create table temp2011 as
select a.*,b.dshpct2011 
from temp2010 a left join impact2011 b
on a.provider_num=b.provider;
quit;

proc sql;
create table temp2012 as
select a.*,b.dshpct2012 
from temp2011 a left join impact2012 b
on a.provider_num=b.provider;
quit;
 

data data.HospChar;
set temp2012;
drop year provider_num;
label dshpct2008 ='Disproportionate Share Hospital(DSH) 2008';
label dshpct2009 ='Disproportionate Share Hospital(DSH) 2009';
label dshpct2010 ='Disproportionate Share Hospital(DSH) 2010';
label dshpct2011 ='Disproportionate Share Hospital(DSH) 2011';
label dshpct2012 ='Disproportionate Share Hospital(DSH) 2012';
 
run;
/*
proc rank data=temp out=temp1 group=4;
var dshpct2008 dshpct2009 dshpct2010 dshpct2011 dshpct2012 dshpct2013;
ranks rank2008 rank2009 rank2010 rank2011 rank2012 rank2013;
run;

data data.HospChar;
set temp1;
SNH2008=rank2008+1;label SNH2008="Safety-Net Hospital:1=DSH Quartile 1(Lowest) 4=DSH Quartile 4(Highest) 2008";
SNH2009=rank2009+1;label SNH2009="Safety-Net Hospital:1=DSH Quartile 1(Lowest) 4=DSH Quartile 4(Highest) 2009";
SNH2010=rank2010+1;label SNH2010="Safety-Net Hospital:1=DSH Quartile 1(Lowest) 4=DSH Quartile 4(Highest) 2010";
SNH2011=rank2011+1;label SNH2011="Safety-Net Hospital:1=DSH Quartile 1(Lowest) 4=DSH Quartile 4(Highest) 2011";
SNH2012=rank2012+1;label SNH2012="Safety-Net Hospital:1=DSH Quartile 1(Lowest) 4=DSH Quartile 4(Highest) 2012";
SNH2013=rank2013+1;label SNH2013="Safety-Net Hospital:1=DSH Quartile 1(Lowest) 4=DSH Quartile 4(Highest) 2013";
drop rank2008 rank2009 rank2010 rank2011 rank2012 rank2013;
run;
*/


 
