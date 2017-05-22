*************************************
Final re-vision R&R
Xiner Zhou
3/27/2017
************************************;
libname data 'D:\Projects\Hartford\Data\data';
libname cr 'D:\Data\Hospital\Cost Reports';
  

* Add Operating Margin;
%macro Margin(yr=);
data margin&yr.;
set cr.Cost_reports_&yr. ;
keep totmargin&yr. opmargin&yr.  provider ; 
totmargin&yr. =  net_income/sum(net_pat_rev,tot_oth_inc); 
opmargin&yr.  =  (sum(net_pat_rev,tot_oth_inc)-tot_op_exps)/sum(net_pat_rev,tot_oth_inc); 
provider=prvdr_num ;
proc sort nodupkey;by provider;
run;
%mend Margin;
%Margin(yr=2008);
%Margin(yr=2009);
%Margin(yr=2010);
%Margin(yr=2011);
%Margin(yr=2012);
%Margin(yr=2013);
*%Margin(yr=2014);
*%Margin(yr=2015);

proc sort data=data.Hartford;by provider;run;
data Hartford;
merge data.Hartford(in=in1) margin2008 margin2009 margin2010 margin2011 margin2012 margin2013;
by provider;
if in1=1;
proc sort nodupkey;by provider;
run;
 
 
  
data hartford;
set hartford;
if respond2008=. then respond2008=0;if respond2009=. then respond2009=0;if respond2010=. then respond2010=0;
if respond2011=. then respond2011=0;if respond2012=. then respond2012=0;if respond2013=. then respond2013=0;
Nrespond=respond2008+respond2009+respond2010+respond2011+respond2012+respond2013;

* if condition-specific mortality/readmission/los is missing, then set to 0;
array temp {2436} RawAMIReadm302008--NLOShipfx2013;
do i=1 to 2436;
 if temp{i}=. then temp{i}=0;
end;

proc freq;tables Nrespond;
proc sort;by provider;
run;
  


****************************************************************
Create Composite Score
****************************************************************;

%macro comp(meas=,day=,yr=);
proc sql;
create table &meas.&day.&yr. as
select provider, 
sum(obsAMI&meas.&day.&yr.) as sumobsAMI&meas.&day.&yr., sum(obsCHF&meas.&day.&yr.) as sumobsCHF&meas.&day.&yr., sum(obsPN&meas.&day.&yr.) as sumobsPN&meas.&day.&yr., 

       sum(NAMI&meas.&day.&yr.) as sumNAMI&meas.&day.&yr., sum(NCHF&meas.&day.&yr.) as sumNCHF&meas.&day.&yr., sum(NPN&meas.&day.&yr.) as sumNPN&meas.&day.&yr.,

	   (calculated sumobsAMI&meas.&day.&yr. + calculated sumobsCHF&meas.&day.&yr. + calculated sumobsPN&meas.&day.&yr.)
       /(calculated sumNAMI&meas.&day.&yr. + calculated sumNCHF&meas.&day.&yr. + calculated sumNPN&meas.&day.&yr.) as overall3cond&meas.&day.&yr.,

       (obsAMI&meas.&day.&yr.+obsCHF&meas.&day.&yr.+obsPN&meas.&day.&yr.)/(expAMI&meas.&day.&yr.+expCHF&meas.&day.&yr.+expPN&meas.&day.&yr.) as ratio3cond,
      (calculated overall3cond&meas.&day.&yr.)*(calculated ratio3cond) as adj3cond&meas.&day.&yr.,

	    sum(obsAMI&meas.&day.&yr.) as sumobsAMI&meas.&day.&yr., sum(obsCHF&meas.&day.&yr.) as sumobsCHF&meas.&day.&yr., sum(obsPN&meas.&day.&yr.) as sumobsPN&meas.&day.&yr., 
		sum(obscopd&meas.&day.&yr.) as sumobsCOPD&meas.&day.&yr., sum(obsstroke&meas.&day.&yr.) as sumobsstroke&meas.&day.&yr., sum(obssepsis&meas.&day.&yr.) as sumobssepsis&meas.&day.&yr., 
		sum(obsesggas&meas.&day.&yr.) as sumobsesggas&meas.&day.&yr., sum(obsgib&meas.&day.&yr.) as sumobsgib&meas.&day.&yr., sum(obsuti&meas.&day.&yr.) as sumobsuti&meas.&day.&yr., 
		sum(obsmetdis&meas.&day.&yr.) as sumobsmetdis&meas.&day.&yr., sum(obsarrhy&meas.&day.&yr.) as sumobsarrhy&meas.&day.&yr., sum(obschest&meas.&day.&yr.) as sumobschest&meas.&day.&yr., 
		sum(obsrenalf&meas.&day.&yr.) as sumobsrenalf&meas.&day.&yr., sum(obsresp&meas.&day.&yr.) as sumobsresp&meas.&day.&yr., sum(obshipfx&meas.&day.&yr.) as sumobshipfx&meas.&day.&yr., 

       sum(NAMI&meas.&day.&yr.) as sumNAMI&meas.&day.&yr., sum(NCHF&meas.&day.&yr.) as sumNCHF&meas.&day.&yr., sum(NPN&meas.&day.&yr.) as sumNPN&meas.&day.&yr.,
	   sum(Ncopd&meas.&day.&yr.) as sumNcopd&meas.&day.&yr., sum(Nstroke&meas.&day.&yr.) as sumNstroke&meas.&day.&yr., sum(Nsepsis&meas.&day.&yr.) as sumNsepsis&meas.&day.&yr.,
	   sum(Nesggas&meas.&day.&yr.) as sumNesggas&meas.&day.&yr., sum(Ngib&meas.&day.&yr.) as sumNgib&meas.&day.&yr., sum(Nuti&meas.&day.&yr.) as sumNuti&meas.&day.&yr.,
	   sum(Nmetdis&meas.&day.&yr.) as sumNmetdis&meas.&day.&yr., sum(Narrhy&meas.&day.&yr.) as sumNarrhy&meas.&day.&yr., sum(Nchest&meas.&day.&yr.) as sumNchest&meas.&day.&yr.,
	   sum(Nrenalf&meas.&day.&yr.) as sumNrenalf&meas.&day.&yr., sum(Nresp&meas.&day.&yr.) as sumNresp&meas.&day.&yr., sum(Nhipfx&meas.&day.&yr.) as sumNhipfx&meas.&day.&yr.,

	   (calculated sumobsAMI&meas.&day.&yr. + calculated sumobsCHF&meas.&day.&yr. + calculated sumobsPN&meas.&day.&yr.
       +calculated sumobscopd&meas.&day.&yr. + calculated sumobsstroke&meas.&day.&yr. + calculated sumobssepsis&meas.&day.&yr.
       +calculated sumobsesggas&meas.&day.&yr. + calculated sumobsgib&meas.&day.&yr. + calculated sumobsuti&meas.&day.&yr.
       +calculated sumobsmetdis&meas.&day.&yr. + calculated sumobsarrhy&meas.&day.&yr. + calculated sumobschest&meas.&day.&yr.
       +calculated sumobsrenalf&meas.&day.&yr. + calculated sumobsresp&meas.&day.&yr. + calculated sumobshipfx&meas.&day.&yr.)
       /(calculated sumNAMI&meas.&day.&yr. + calculated sumNstroke&meas.&day.&yr. + calculated sumNPN&meas.&day.&yr.
        +calculated sumNcopd&meas.&day.&yr. + calculated sumNstroke&meas.&day.&yr. + calculated sumNsepsis&meas.&day.&yr.
		+calculated sumNesggas&meas.&day.&yr. + calculated sumNgib&meas.&day.&yr. + calculated sumNuti&meas.&day.&yr.
		+calculated sumNmetdis&meas.&day.&yr. + calculated sumNarrhy&meas.&day.&yr. + calculated sumNchest&meas.&day.&yr.
		+calculated sumNrenalf&meas.&day.&yr. + calculated sumNresp&meas.&day.&yr. + calculated sumNhipfx&meas.&day.&yr.) as overall15cond&meas.&day.&yr.,

       (obsAMI&meas.&day.&yr.+obsCHF&meas.&day.&yr.+obsPN&meas.&day.&yr.
        +obscopd&meas.&day.&yr.+obsstroke&meas.&day.&yr.+obssepsis&meas.&day.&yr.
        +obsesggas&meas.&day.&yr.+obsgib&meas.&day.&yr.+obsUTI&meas.&day.&yr.
        +obsmetdis&meas.&day.&yr.+obsarrhy&meas.&day.&yr.+obschest&meas.&day.&yr.
        +obsrenalf&meas.&day.&yr.+obsresp&meas.&day.&yr.+obshipfx&meas.&day.&yr.)
       /(expAMI&meas.&day.&yr.+expCHF&meas.&day.&yr.+expPN&meas.&day.&yr.
        +expcopd&meas.&day.&yr.+expstroke&meas.&day.&yr.+expsepsis&meas.&day.&yr.
        +expesggas&meas.&day.&yr.+expgib&meas.&day.&yr.+exputi&meas.&day.&yr.
        +expmetdis&meas.&day.&yr.+exparrhy&meas.&day.&yr.+expchest&meas.&day.&yr.
        +exprenalf&meas.&day.&yr.+expresp&meas.&day.&yr.+exphipfx&meas.&day.&yr.) as ratio15cond,
      (calculated overall15cond&meas.&day.&yr.)*(calculated ratio15cond) as adj15cond&meas.&day.&yr.  

from Hartford;
quit;

proc sort data=&meas.&day.&yr. nodupkey ;by provider;run;
%mend comp;
%comp(meas=readm,day=30,yr=2008);
%comp(meas=readm,day=30,yr=2009);
%comp(meas=readm,day=30,yr=2010);
%comp(meas=readm,day=30,yr=2011);
%comp(meas=readm,day=30,yr=2012);
%comp(meas=readm,day=30,yr=2013);
 

%comp(meas=mort,day=30,yr=2008);
%comp(meas=mort,day=30,yr=2009);
%comp(meas=mort,day=30,yr=2010);
%comp(meas=mort,day=30,yr=2011);
%comp(meas=mort,day=30,yr=2012);
%comp(meas=mort,day=30,yr=2013);
 

%macro comp(meas=,yr=);
proc sql;
create table &meas.&yr. as
select provider, 
sum(obs&meas.AMI&yr.) as sumobs&meas.AMI&yr., sum(obs&meas.CHF&yr.) as sumobs&meas.CHF&yr., sum(obs&meas.PN&yr.) as sumobs&meas.PN&yr., 

       sum(N&meas.AMI&yr.) as sumN&meas.AMI&yr., sum(N&meas.CHF&yr.) as sumN&meas.CHF&yr., sum(N&meas.PN&yr.) as sumN&meas.PN&yr.,

	   (calculated sumobs&meas.AMI&yr. + calculated sumobs&meas.CHF&yr. + calculated sumobs&meas.PN&yr.)
       /(calculated sumN&meas.AMI&yr. + calculated sumN&meas.CHF&yr. + calculated sumN&meas.PN&yr.) as overall&meas.3cond&yr.,

       (obs&meas.AMI&yr.+obs&meas.CHF&yr.+obs&meas.PN&yr.)/(exp&meas.AMI&yr.+exp&meas.CHF&yr.+exp&meas.PN&yr.) as ratio&meas.3cond,
      (calculated overall&meas.3cond&yr.)*(calculated ratio&meas.3cond) as adj&meas.3cond&yr.,

	    sum(obs&meas.AMI&yr.) as sumobs&meas.AMI&yr., sum(obs&meas.CHF&yr.) as sumobs&meas.CHF&yr., sum(obs&meas.PN&yr.) as sumobs&meas.PN&yr., 
		sum(obs&meas.copd&yr.) as sumobs&meas.COPD&yr., sum(obs&meas.stroke&yr.) as sumobs&meas.stroke&yr., sum(obs&meas.sepsis&yr.) as sumobs&meas.sepsis&yr., 
		sum(obs&meas.esggas&yr.) as sumobs&meas.esggas&yr., sum(obs&meas.gib&yr.) as sumobs&meas.gib&yr., sum(obs&meas.uti&yr.) as sumobs&meas.uti&yr., 
		sum(obs&meas.metdis&yr.) as sumobs&meas.metdis&yr., sum(obs&meas.arrhy&yr.) as sumobs&meas.arrhy&yr., sum(obs&meas.chest&yr.) as sumobs&meas.chest&yr., 
		sum(obs&meas.renalf&yr.) as sumobs&meas.renalf&yr., sum(obs&meas.resp&yr.) as sumobs&meas.resp&yr., sum(obs&meas.hipfx&yr.) as sumobs&meas.hipfx&yr., 

       sum(N&meas.AMI&yr.) as sumN&meas.AMI&yr., sum(N&meas.CHF&yr.) as sumN&meas.CHF&yr., sum(N&meas.PN&yr.) as sumN&meas.PN&yr.,
	   sum(N&meas.copd&yr.) as sumN&meas.copd&yr., sum(N&meas.stroke&yr.) as sumN&meas.stroke&yr., sum(N&meas.sepsis&yr.) as sumN&meas.sepsis&yr.,
	   sum(N&meas.esggas&yr.) as sumN&meas.esggas&yr., sum(N&meas.gib&yr.) as sumN&meas.gib&yr., sum(N&meas.uti&yr.) as sumN&meas.uti&yr.,
	   sum(N&meas.metdis&yr.) as sumN&meas.metdis&yr., sum(N&meas.arrhy&yr.) as sumN&meas.arrhy&yr., sum(N&meas.chest&yr.) as sumN&meas.chest&yr.,
	   sum(N&meas.renalf&yr.) as sumN&meas.renalf&yr., sum(N&meas.resp&yr.) as sumN&meas.resp&yr., sum(N&meas.hipfx&yr.) as sumN&meas.hipfx&yr.,

	   (calculated sumobs&meas.AMI&yr. + calculated sumobs&meas.CHF&yr. + calculated sumobs&meas.PN&yr.
       +calculated sumobs&meas.copd&yr. + calculated sumobs&meas.stroke&yr. + calculated sumobs&meas.sepsis&yr.
       +calculated sumobs&meas.esggas&yr. + calculated sumobs&meas.gib&yr. + calculated sumobs&meas.uti&yr.
       +calculated sumobs&meas.metdis&yr. + calculated sumobs&meas.arrhy&yr. + calculated sumobs&meas.chest&yr.
       +calculated sumobs&meas.renalf&yr. + calculated sumobs&meas.resp&yr. + calculated sumobs&meas.hipfx&yr.)
       /(calculated sumN&meas.AMI&yr. + calculated sumN&meas.CHF&yr. + calculated sumN&meas.PN&yr.
        +calculated sumN&meas.copd&yr. + calculated sumN&meas.stroke&yr. + calculated sumN&meas.sepsis&yr.
		+calculated sumN&meas.esggas&yr. + calculated sumN&meas.gib&yr. + calculated sumN&meas.uti&yr.
		+calculated sumN&meas.metdis&yr. + calculated sumN&meas.arrhy&yr. + calculated sumN&meas.chest&yr.
		+calculated sumN&meas.renalf&yr. + calculated sumN&meas.resp&yr. + calculated sumN&meas.hipfx&yr.) as overall&meas.15cond&yr.,

       (obs&meas.AMI&yr.+obs&meas.CHF&yr.+obs&meas.PN&yr.
        +obs&meas.copd&yr.+obs&meas.stroke&yr.+obs&meas.sepsis&yr.
        +obs&meas.esggas&yr.+obs&meas.gib&yr.+obs&meas.UTI&yr.
        +obs&meas.metdis&yr.+obs&meas.arrhy&yr.+obs&meas.chest&yr.
        +obs&meas.renalf&yr.+obs&meas.resp&yr.+obs&meas.hipfx&yr.)
       /(exp&meas.AMI&yr.+exp&meas.CHF&yr.+exp&meas.PN&yr.
        +exp&meas.copd&yr.+exp&meas.stroke&yr.+exp&meas.sepsis&yr.
        +exp&meas.esggas&yr.+exp&meas.gib&yr.+exp&meas.uti&yr.
        +exp&meas.metdis&yr.+exp&meas.arrhy&yr.+exp&meas.chest&yr.
        +exp&meas.renalf&yr.+exp&meas.resp&yr.+exp&meas.hipfx&yr.) as ratio&meas.15cond,
      (calculated overall&meas.15cond&yr.)*(calculated ratio&meas.15cond) as adj&meas.15cond&yr.  

from Hartford;
quit;

proc sort data=&meas.&yr. nodupkey;by provider;run;
%mend comp;
%comp(meas=LOS, yr=2008);
%comp(meas=LOS, yr=2009);
%comp(meas=LOS, yr=2010);
%comp(meas=LOS, yr=2011);
%comp(meas=LOS, yr=2012);
%comp(meas=LOS, yr=2013);


 
data data;
merge hartford(in=in1) 
readm302008(keep=provider adj3condreadm302008 adj15condreadm302008) readm302009(keep=provider adj3condreadm302009 adj15condreadm302009) readm302010(keep=provider adj3condreadm302010 adj15condreadm302010)
readm302011(keep=provider adj3condreadm302011 adj15condreadm302011) readm302012(keep=provider adj3condreadm302012 adj15condreadm302012) readm302013(keep=provider adj3condreadm302013 adj15condreadm302013) 

mort302008(keep=provider adj3condmort302008 adj15condmort302008) mort302009(keep=provider adj3condmort302009 adj15condmort302009) mort302010(keep=provider adj3condmort302010 adj15condmort302010)
mort302011(keep=provider adj3condmort302011 adj15condmort302011) mort302012(keep=provider adj3condmort302012 adj15condmort302012) mort302013(keep=provider adj3condmort302013 adj15condmort302013) 

LOS2008(keep=provider adjLOS15cond2008) LOS2009(keep=provider adjLOS15cond2009) LOS2010(keep=provider adjLOS15cond2010)
LOS2011(keep=provider adjLOS15cond2011) LOS2012(keep=provider adjLOS15cond2012) LOS2013(keep=provider adjLOS15cond2013);
by provider;
if in1=1;
proc sort nodupkey;by provider;
run;
 
 
************************************************************************
Add stratefication variables
************************************************************************;
/*  Stratified Analyses: 
1. Size
2. Urban/Rural
3. Teaching/Non-Teaching
4. Safety Net/ Non Safety Net
5. Early/Mid/Late Adopters (< 4, 4-7, >8 Functionalities at Baseline)
5b.Stratified-Stratified Analysis: Of hospitals with < 4 Baseline functionalities, compare adopters of none, 
   documentation and results viewing, documentation only, results only 
*/
* Vendor for ip and op;
proc import datafile="D:\Data\Hospital\AHA\HIT\Data\origdata\2013 IT DATA" dbms=xls out=HIT13 replace;
getnames=yes;
run;
data HIT13;set HIT13;if q14a_other ne '' then q14a=q14a_other;if q14b_other ne '' then q14b=q14b_other;run;

libname AHA 'D:\Data\Hospital\AHA\Annual_Survey\Data';
proc sql;create table temp as select a.id,a.q14a,a.q14b,b.provider from HIT13 a left join AHA.AHA13 b on a.id=b.id;quit;
proc sql;create table temp0 as select a.*,b.q14a,b.q14b from data a left join temp b on a.provider=b.provider;quit;

 


data data;
set temp0;
if Nrespond>=3 and profit2 not in (.,4);
 
 
* Had Medication CPOE c3 & Physician Note b1 / Medication CPOE only / Physician Note only / neither--were those functions ever adopted over the entire time period ;
if (c3_2008 in (1,2) or c3_2009 in (1,2) or c3_2010 in (1,2) or c3_2011 in (1,2) or c3_2012 in (1,2) or c3_2013 in (1,2)) 
and (b1_2008 in (1,2) or b1_2009 in (1,2) or b1_2010 in (1,2) or b1_2011 in (1,2) or b1_2012 in (1,2) or b1_2013 in (1,2))  then CPOE_PN=1;
else if 
((c3_2008 in (1,2) or c3_2009 in (1,2) or c3_2010 in (1,2) or c3_2011 in (1,2) or c3_2012 in (1,2) or c3_2013 in (1,2)) 
and (b1_2008 not in (1,2) and  b1_2009 not in (1,2) and b1_2010 not in (1,2) and b1_2011 not in (1,2) and b1_2012 not in (1,2) and b1_2013 not in (1,2)) ) then CPOE_PN=2;
else if 
((c3_2008 not in (1,2) and c3_2009 not in (1,2) and c3_2010 not in (1,2) and c3_2011 not in (1,2) and c3_2012 not in (1,2) and c3_2013 not in (1,2)) 
and (b1_2008 in (1,2) or b1_2009 in (1,2) or b1_2010 in (1,2) or b1_2011 in (1,2) or b1_2012 in (1,2) or b1_2013 in (1,2)) ) then CPOE_PN=3;
else if 
((c3_2008 not in (1,2) and c3_2009 not in (1,2) and c3_2010 not in (1,2) and c3_2011 not in (1,2) and c3_2012 not in (1,2) and c3_2013 not in (1,2)) 
and (b1_2008  not in (1,2)  and  b1_2009 not in (1,2)  and  b1_2010 not in (1,2)  and  b1_2011 not in (1,2)  and  b1_2012 not in (1,2)  and  b1_2013 not in (1,2)) ) then CPOE_PN=4;


* Had CPOE and PN during any point 2008-2010 / Adopted CPOE and PN during any point 2011-2013 / everyone else;
if (c3_2008 in (1,2) or c3_2009 in (1,2) or c3_2010 in (1,2)) and (b1_2008 in (1,2) or b1_2009 in (1,2) or b1_2010 in (1,2))  then CPOE_PN2=1;
else if (c3_2011 in (1,2) or c3_2012 in (1,2) or c3_2013 in (1,2)) and (b1_2011 in (1,2) or b1_2012 in (1,2) or b1_2013 in (1,2))  then CPOE_PN2=2;
else CPOE_PN2=3;

* same vendor;
if q14a ne '' and q14b ne '' then do;
   if q14a=q14b then SameVendor=1;
   else SameVendor=2;
end;

 
*Urban;
if ruca_level in (3,4) then ruca=2;  else if ruca_level in (1,2) then Ruca=1;


*teaching;
if teaching=3 then teaching1=2;else if teaching in (1,2) then teaching1=1;else if teaching=. then teaching1=.;
label teaching1="1=Teaching Hospital 2=Non-Teaching Hospital";
*SNH;
if SNH2012=4 then SNH=1;else if SNH2012 ne . then SNH=2;else if SNH2012=. then SNH=.;

*Late/Mid/Early Adopters (< 4, 4-7, >8 Functionalities at Baseline);
if NBasicEHR2008 in (0,1,2,3) then Adopter=3;
else if NBasicEHR2008 in (4,5,6,7) then Adopter=2;
else if NBasicEHR2008 >=8 then Adopter=1;

*5b.Stratified-Stratified Analysis: Of hospitals with < 4 Baseline functionalities, compare adopters of none,  documentation and results viewing, documentation only, results only ;
*documentation a1-f1 result reviewing a2-c3;
if Adopter=3 then do;
  if a1_2008 not in (1,2) and b1_2008 not in (1,2) and c1_2008 not in (1,2) and d1_2008 not in (1,2) and e1_2008 not in (1,2) and f1_2008 not in (1,2) 
     and a2_2008 not in (1,2) and b2_2008 not in (1,2) and d2_2008 not in (1,2) and c3_2008 not in (1,2) then subgroup=4;
  else if (a1_2008 in (1,2) or b1_2008 in (1,2) or c1_2008 in (1,2) or d1_2008 in (1,2) or e1_2008 in (1,2) or f1_2008 in (1,2)) 
     and (a2_2008 not in (1,2) and b2_2008 not in (1,2) and d2_2008 not in (1,2)) then subgroup=3;
  else if (a1_2008 not in (1,2) and b1_2008 not in (1,2) and c1_2008 not in (1,2) and d1_2008 not in (1,2) and e1_2008 not in (1,2) and f1_2008 not in (1,2)) 
     and (a2_2008 in (1,2) or b2_2008 in (1,2) or d2_2008 in (1,2) ) then subgroup=2;
  else if a1_2008 in (1,2) or  b1_2008 in (1,2) or c1_2008 in (1,2) or d1_2008 in (1,2) or e1_2008 in (1,2) or f1_2008 in (1,2) or
     a2_2008 in (1,2) or b2_2008 in (1,2) or d2_2008 in (1,2)  then subgroup=1;

end;

DSHpct=DSHpct2012;label DSHpct="DSH Percent (Adjusting for SES)";
rename adjLOS15cond2008=adj15condLOS2008 adjLOS15cond2009=adj15condLOS2009 adjLOS15cond2010=adj15condLOS2010 
       adjLOS15cond2011=adj15condLOS2011 adjLOS15cond2012=adj15condLOS2012 adjLOS15cond2013=adj15condLOS2013 ;
/*
We decided to add two control variables to supplement the DSH variable, that should help eliminate the missing data problem. 
The first is a binary variable for whether or not we have the DSH data (setting the DSH percentage data = 0 if t�fs missing). 
The other control would be percent Medicaid, which we should have for all hospitals. John said there should be no harm in adding 
both as long as we are not trying to interpret the coefficients, which we are not. 
*/
if Dshpct=. then do;Dshpct=0;missingDSH=1;end;
else missingDSH=0;

if NBasicEHR2008 ne . then Impute=0;else Impute=1;
proc freq;tables NBasicEHR2008*Impute/missing;
run;

proc freq data=data; 
title "SubGroup Frequency";tables  
CPOE_PN CPOE_PN2 SameVendor ruca teaching1 Adopter subgroup hospsize SNH profit2/missing;
proc means data=data N mean;
var opmargin ruca teaching hospsize Dshpct missingDSH p_medicaid;
run;

proc sort data=data nodupkey;by provider;run;
  
 
proc format;
value CPOE_PN_
1="Had Medication CPOE & Physician Note anytime during 2008-2013"
2="Medication CPOE only, no Physician Note anytime during 2008-2013"
3="Physician Note only, no Medication CPOE anytime during 2008-2013"
4="Neither anytime during 2008-2013"
;
run;
proc format;
value CPOE_PN2_
1="Had Medication CPOE and PN during any point 2008-2010 "
2="Had Medication CPOE and PN during any point 2011-2013 "
3="Neither"
;
run;
proc format;
value SameVendor_
1="Same inpatient and outpatient vendor"
2="Not the same vendor"
;
run;
proc format;
value ruca_
1="Urban or Suburban"
2="Rural"
;
run;
proc format;
value hospsize_
1="Small"
2="Medium"
3="Large"
;
run;
proc format;
value teaching1_
1="Teaching Hospital"
2="Non-Teaching Hospital"
;
run;
proc format;
value SNH_
1="Safety-Net Hospital (Top Quartile DSH%)"
2="Non-Safety-Net Hospital"
;
run;
proc format;
value Adopter_
1="Early Adopters:>8 Functionalities at Baseline"
2="Mid Adopters:4-7 Functionalities at Baseline"
3="Late Adopters:<4 Functionalities at Baseline"
;
run;
proc format;
value subgroup_
1="Had Documentation and Results viewing at Baseline"
2="Had Results Viewing at Baseline, no Documentation"
3="Had Documentation at Baseline, no Results Viewing"
4="Neither"
;
run;
proc format;
value profit_
1="Investor Owned, For-Profit"
2="Non-Government, Not-For-Profit"
3="Government, Non-Federal"
4="Government, Federal"
;
run;

 




****************************************************************************
Overall Model:
Regression model, using 30/90-day risk-adjusted readmission and mortality, Preventive Quality Indicator, and Medicare Spending (need decision), as outcome measures, 
look at how do the starting point and growth trajectory of number of E-H-R functionalities relate to performance measures over time, 
and weight by the inverse of standard errors from model 1 (giving less credibility to less stable hospitals). 

              Outcome = starting point + growth trajectory (drop if not meaningful) 
                     + Time + starting point* Time + growth trajectory * Time

Ideas: higher starting point might have better performance measure at the baseline,
       greater growth trajectory might have better performance measure improvement over time.

****************************************************************************;
ODS Listing CLOSE;
ODS html file="D:\Projects\Hartford\Main Model.xls" style=minimal;
%macro model2(cond=,meas=,day=,title=);

 
proc sql;
create table intercept as
select a.*, 
b.Estimate as startpoint
from data a left join data.model1 b
on a.provider=b.provider
where a.Nrespond>=3 and b.parameter="Intercept";
quit;

proc sql;
create table slope as
select a.*,
b.Estimate as slope,b.StdErr as slopeStdErr
from intercept a left join data.model1 b
on a.provider=b.provider
where b.parameter="year";
quit;


data ldata;
set slope;
if NBasicEHR2008 ne . then startpoint=NBasicEHR2008;
if slopeStdErr=0 or slopeStdErr=. then wt=1/0.04;else wt=1/slopeStdErr;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2008;opmargin=opmargin2008;year=0;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2009;opmargin=opmargin2009;year=1;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2010;opmargin=opmargin2010;year=2;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2011;opmargin=opmargin2011;year=3;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2012;opmargin=opmargin2012;year=4;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2013;opmargin=opmargin2013;year=5;output;
/*proc means;var adj&cond.&meas.&day.;
output out=outcome&cond.&meas.&day. mean=mean  min=min q1=q1  median=median  q3=q3  max=max  ;
*/
run;


/* Predicted Margin or G-Formula;
data newdata;
set ldata;
*startpoint=5;
*slope=1;
run;
*/
proc glimmix data=ldata NOCLPRINT ;
	title  &title. ;
	class provider ruca teaching hospsize missingDSH;
	weight wt; 
	format ruca ruca_. teaching1 teaching1_. hospsize hospsize_. profit2 profit_.;
	model adj&cond.&meas.&day.=startpoint  year startpoint*year slope*year opmargin ruca teaching1 hospsize profit2 Dshpct missingDSH p_medicaid/s dist=normal  ;
	random int  / subject=provider ;
	ods output ModelInfo=ModelInfo&cond.&meas.&day.6
	           NObs=NObs&cond.&meas.&day.6
			   Dimensions=Dimensions&cond.&meas.&day.6
               FitStatistics= FitStatistics&cond.&meas.&day.6
			   CovParms=CovParms&cond.&meas.&day.6
               ParameterEstimates= ParameterEstimates&cond.&meas.&day.6
               Tests3=Test3&cond.&meas.&day.6
               Estimates= Estimates&cond.&meas.&day.6;

	estimate "Change (0-5 Year) Non Adopter" year 5 /cl;
	estimate "Change (0-5 Year) Average Adopter" year 5 startpoint*year 25 slope*year 5/cl;
	estimate "Diff-in-Diff" startpoint*year 25 slope*year 5/cl;
store sasuser.betaoverall;
	run;
/*
proc plm source=sasuser.betaoverall;
   score data=newdata out=newdataoverall predicted / ilink;
run;
proc means data=newdataoverall N mean std;
		class year;
		var predicted;
	run;  
*/
%mend model2;
%model2(cond=15cond,meas=readm,day=30,title="All hosp (Main Model):Readmission Rate");
%model2(cond=15cond,meas=mort,day=30,title="All hosp (Main Model):Mortality Rate");
%model2(cond=15cond,meas=LOS, title="All hosp (Main Model):Length of Stay");

* strategied analysis;
%macro strat(by=, stratum=, add1=, cond=,meas=,day=,title=,extra=);
proc sql;
create table intercept as
select a.*, 
b.Estimate as startpoint
from data a left join data.model1 b
on a.provider=b.provider
where a.Nrespond>=3 and b.parameter="Intercept";
quit;

proc sql;
create table slope as
select a.*,
b.Estimate as slope,b.StdErr as slopeStdErr
from intercept a left join data.model1 b
on a.provider=b.provider
where b.parameter="year";
quit;


data ldata;
set slope;
if NBasicEHR2008 ne . then startpoint=NBasicEHR2008;
if slopeStdErr=0 or slopeStdErr=. then wt=1/0.04;else wt=1/slopeStdErr;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2008;opmargin=opmargin2008;year=0;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2009;opmargin=opmargin2009;year=1;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2010;opmargin=opmargin2010;year=2;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2011;opmargin=opmargin2011;year=3;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2012;opmargin=opmargin2012;year=4;output;
adj&cond.&meas.&day.=adj&cond.&meas.&day.2013;opmargin=opmargin2013;year=5;output;
/*proc means;var adj&cond.&meas.&day.;
output out=outcome&cond.&meas.&day. mean=mean  min=min q1=q1  median=median  q3=q3  max=max  ;
*/
run;
 
proc sql;
create table temp as
select mean(startpoint)*5 as temp1, mean(slope)*5 as temp2 
from slope
where &by.=&stratum.; 
quit;
data _null_;
set temp;
call symput("start",temp1);call symput("slope",temp2);
run;

 
proc glimmix data=ldata NOCLPRINT;
title &title.;
class provider &add1.;
weight wt;  
where &by.=&stratum.; * change this!!!!!;
model adj&cond.&meas.&day.=startpoint year startpoint*year slope*year opmargin Dshpct missingDSH p_medicaid &add1. /s dist=normal  ;
random int  / subject=provider ;
     
%if &extra.=1 %then %do;
	estimate "Change (0-5 Year) Non Adopter" year 5 /cl;
	estimate "Change (0-5 Year) Average Adopter" year 5 startpoint*year &start. slope*year &slope./cl;
	estimate "Diff-in-Diff" startpoint*year &start. slope*year &slope. /cl;
%end;
%else %do;
	estimate "Change (0-5 Year) Non Adopter" year 5 /cl;
	estimate "Change (0-5 Year) Average Adopter" year 5 startpoint*year 25 slope*year 5/cl;
	estimate "Diff-in-Diff" startpoint*year 25 slope*year 5/cl;
%end; 

	ods output ModelInfo=ModelInfo&meas.&by.&stratum. 
	           NObs=NObs&meas.&by.&stratum. 
			   Dimensions=Dimensions&meas.&by.&stratum. 
               FitStatistics= FitStatistics&meas.&by.&stratum. 
			   CovParms=CovParms&meas.&by.&stratum. 
               ParameterEstimates= ParameterEstimates&meas.&by.&stratum. 
               Tests3=Test3&meas.&by.&stratum. 
               Estimates= Estimates&meas.&by.&stratum.;

store sasuser.beta&meas.&by.&stratum.;
	run;


%mend strat;
%strat(by=ruca,stratum=1,add1=teaching1 hospsize profit2 ,  cond=15cond,meas=readm,day=30,title="Urban or Suburban (Stratefied): Readmission Rate");
%strat(by=ruca,stratum=1,add1=teaching1 hospsize profit2 ,  cond=15cond,meas=mort,day=30,title="Urban or Suburban (Stratefied): Mortality Rate");
%strat(by=ruca,stratum=1,add1=teaching1 hospsize profit2 ,  cond=15cond,meas=LOS, title="Urban or Suburban (Stratefied): Length of Stay");

%strat(by=ruca,stratum=2,add1=teaching1 hospsize profit2 ,  cond=15cond,meas=readm,day=30,title="Rural (Stratefied):Readmission Rate");
%strat(by=ruca,stratum=2,add1=teaching1 hospsize profit2 ,  cond=15cond,meas=mort,day=30,title="Rural (Stratefied):Mortality Rate");
%strat(by=ruca,stratum=2,add1=teaching1 hospsize profit2 ,  cond=15cond,meas=LOS, title="Rural (Stratefied):Length of Stay");
 

%strat(by=hospsize,stratum=1,add1=ruca teaching1 profit2 , cond=15cond,meas=readm,day=30,title="Size Small (Stratefied):Readmission Rate");
%strat(by=hospsize,stratum=1,add1=ruca teaching1 profit2 , cond=15cond,meas=mort,day=30,title="Size Small (Stratefied):Mortality Rate");
%strat(by=hospsize,stratum=1,add1=ruca teaching1 profit2 , cond=15cond,meas=LOS, title="Size Small (Stratefied):Length of Stay");

%strat(by=hospsize,stratum=2,add1=ruca teaching1 profit2 , cond=15cond,meas=readm,day=30,title="Size Medium (Stratefied):Readmission Rate");
%strat(by=hospsize,stratum=2,add1=ruca teaching1 profit2 , cond=15cond,meas=mort,day=30,title="RSize Medium (Stratefied):Mortality Rate");
%strat(by=hospsize,stratum=2,add1=ruca teaching1 profit2 , cond=15cond,meas=LOS, title="Size Medium (Stratefied):Length of Stay");

%strat(by=hospsize,stratum=3,add1=ruca teaching1 profit2 , cond=15cond,meas=readm,day=30,title="Size Large (Stratefied):Readmission Rate");
%strat(by=hospsize,stratum=3,add1=ruca teaching1 profit2 , cond=15cond,meas=mort,day=30,title="Size Large (Stratefied):Mortality Rate");
%strat(by=hospsize,stratum=3,add1=ruca teaching1 profit2 , cond=15cond,meas=LOS, title="Size Large (Stratefied):Length of Stay");

 

%strat(by=teaching1,stratum=1,add1=ruca hospsize profit2 , cond=15cond,meas=readm,day=30,title="Teaching (Stratefied):Readmission Rate");
%strat(by=teaching1,stratum=1,add1=rruca hospsize profit2 , cond=15cond,meas=mort,day=30,title="Teaching (Stratefied):Mortality Rate");
%strat(by=teaching1,stratum=1,add1=ruca hospsize profit2 , cond=15cond,meas=LOS, title="Teaching (Stratefied):Length of Stay");

%strat(by=teaching1,stratum=2,add1=ruca hospsize profit2 ,cond=15cond,meas=readm,day=30,title="Non-Teaching (Stratefied):Readmission Rate");
%strat(by=teaching1,stratum=2,add1=ruca hospsize profit2 ,cond=15cond,meas=mort,day=30,title="Non-Teaching (Stratefied):Mortality Rate");
%strat(by=teaching1,stratum=2,add1=ruca hospsize profit2 ,cond=15cond,meas=LOS, title="Non-Teaching (Stratefied):Length of Stay");
 


%strat(by=SNH,stratum=1,add1=ruca teaching1 hospsize profit2 , cond=15cond,meas=readm,day=30,title="Safety Net (Stratefied):Readmission Rate");
%strat(by=SNH,stratum=1,add1=ruca teaching1 hospsize profit2 ,cond=15cond,meas=mort,day=30,title="Safety Net (Stratefied):Mortality Rate");
%strat(by=SNH,stratum=1,add1=ruca teaching1 hospsize profit2 , cond=15cond,meas=LOS, title="Safety Net (Stratefied):Length of Stay");

%strat(by=SNH,stratum=2,add1=ruca teaching1 hospsize profit2 , cond=15cond,meas=readm,day=30,title="Non-Safety Net (Stratefied):Readmission Rate");
%strat(by=SNH,stratum=2,add1=ruca teaching1 hospsize profit2 ,cond=15cond,meas=mort,day=30,title="Non-Safety Net (Stratefied):Mortality Rate");
%strat(by=SNH,stratum=2,add1=ruca teaching1 hospsize profit2 ,cond=15cond,meas=LOS, title="Non-Safety Net (Stratefied):Length of Stay");
 
%strat(by=profit2,stratum=1,add1=ruca teaching1 hospsize,cond=15cond,meas=readm,day=30,title="For-Profit (Stratefied):Readmission Rate");
%strat(by=profit2,stratum=1,add1=ruca teaching1 hospsize,cond=15cond,meas=mort,day=30,title="For-Profit (Stratefied):Mortality Rate");
%strat(by=profit2,stratum=1,add1=ruca teaching1 hospsize,cond=15cond,meas=LOS, title="For-Profit (Stratefied):Length of Stay");

%strat(by=profit2,stratum=2,add1=ruca teaching1 hospsize,cond=15cond,meas=readm,day=30,title="Non-profit (Stratefied):Readmission Rate");
%strat(by=profit2,stratum=2,add1=ruca teaching1 hospsize,cond=15cond,meas=mort,day=30,title="Non-profit (Stratefied):Mortality Rate");
%strat(by=profit2,stratum=2,add1=ruca teaching1 hospsize,cond=15cond,meas=LOS, title="Non-profit (Stratefied):Length of Stay");

%strat(by=profit2,stratum=3,add1=ruca teaching1 hospsize,cond=15cond,meas=readm,day=30,title="Government (Stratefied):Readmission Rate");
%strat(by=profit2,stratum=3,add1=ruca teaching1 hospsize,cond=15cond,meas=mort,day=30,title="Government (Stratefied):Mortality Rate");
%strat(by=profit2,stratum=3,add1=ruca teaching1 hospsize,cond=15cond,meas=LOS, title="Government (Stratefied):Length of Stay");
  
%strat(by=SameVendor,stratum=1,add1=ruca teaching1 hospsize profit2 ,cond=15cond,meas=readm,day=30,title="Same Vendor (Stratefied):Readmission Rate",extra=1);
%strat(by=SameVendor,stratum=1,add1=ruca teaching1 hospsize profit2 ,cond=15cond,meas=mort,day=30,title="Same Vendor (Stratefied):Mortality Rate",extra=1);
%strat(by=SameVendor,stratum=1,add1=ruca teaching1 hospsize profit2 ,cond=15cond,meas=LOS, title="Same Vendor (Stratefied):Length of Stay",extra=1);

%strat(by=SameVendor,stratum=2,add1=ruca teaching1 hospsize profit2 ,cond=15cond,meas=readm,day=30,title="Different Vendor (Stratefied):Readmission Rate",extra=1);
%strat(by=SameVendor,stratum=2,add1=ruca teaching1 hospsize profit2 ,cond=15cond,meas=mort,day=30,title="Different Vendor (Stratefied):Mortality Rate",extra=1);
%strat(by=SameVendor,stratum=2,add1=ruca teaching1 hospsize profit2 ,cond=15cond,meas=LOS, title="Different Vendor (Stratefied):Length of Stay",extra=1);
 


%strat(by=Adopter,stratum=1,add1=ruca teaching1 hospsize profit2 ,cond=15cond,meas=readm,day=30,title="Early Adopters (Stratefied):Readmission Rate",extra=1);
%strat(by=Adopter,stratum=1,add1=ruca teaching1 hospsize profit2 ,cond=15cond,meas=mort,day=30,title="Early Adopters (Stratefied):Mortality Rate",extra=1);
%strat(by=Adopter,stratum=1,add1=ruca teaching1 hospsize profit2 ,cond=15cond,meas=LOS, title="Early Adopters (Stratefied):Length of Stay",extra=1);
 
%strat(by=Adopter,stratum=2,add1=ruca teaching1 hospsize profit2 ,cond=15cond,meas=readm,day=30,title="Mid Adopters (Stratefied):Readmission Rate",extra=1);
%strat(by=Adopter,stratum=2,add1=ruca teaching1 hospsize profit2 ,cond=15cond,meas=mort,day=30,title="Mid Adopters (Stratefied):Mortality Rate",extra=1);
%strat(by=Adopter,stratum=2,add1=ruca teaching1 hospsize profit2 ,cond=15cond,meas=LOS, title="Mid Adopters (Stratefied):Length of Stay",extra=1);

%strat(by=Adopter,stratum=3,add1=ruca teaching1 hospsize profit2 ,cond=15cond,meas=readm,day=30,title="Late Adopters (Stratefied):Readmission Rate",extra=1);
%strat(by=Adopter,stratum=3,add1=ruca teaching1 hospsize profit2 ,cond=15cond,meas=mort,day=30,title="Late Adopters (Stratefied):Mortality Rate",extra=1);
%strat(by=Adopter,stratum=3,add1=ruca teaching1 hospsize profit2 ,cond=15cond,meas=LOS, title="Late Adopters (Stratefied):Length of Stay",extra=1);
  
ODS html close;
ODS Listing;  





***************************************************************************
Table 0: Number and % of hospitals missing first year EHR data
Table 1: Starting number of functions in 2008
***************************************************************************;
data temp;
set slope;
if NBasicEHR2008=. then NBasicEHR2008=startpoint;
run;

ODS Listing CLOSE;
ODS html file="D:\Projects\Hartford\Table0.xls" style=minimal;

proc tabulate data=temp  noseps  missing;
title "Table 0";
class impute;
table impute="Missing first year EHR data",(n colpctn)  /RTS=25;
 Keylabel   N="Number of Hospitals" colpctn="Percent of Hospitals"
;
run;

proc tabulate data=temp  noseps  missing;
title "Table 1.Descriptive Statistics";
class ruca hospsize teaching1 SNH profit2 adopter samevendor speed;
var NBasicEHR2008 slope;
format ruca ruca_. hospsize hospsize_. teaching1 teaching1_. SNH SNH_. profit2 profit_.;

table (all ruca hospsize teaching1 SNH profit2  adopter samevendor speed), NBasicEHR2008="Avg. Starting Number of EHR Functions"*( n mean STD) slope="Avg. New Functions Added per Year"*( n mean STD)/RTS=25;
 Keylabel   N="Number of Hospitals" colpctn="Percent of Hospitals"
;
run;

*p-value;
proc genmod data=slope ;
class ruca hospsize teaching1 SNH profit2;
model NBasicEHR2008=ruca/type3 ;
run;
proc genmod data=slope ;
class ruca hospsize teaching1 SNH profit2;
model NBasicEHR2008=hospsize/type3 ;
run;
proc genmod data=slope ;
class ruca hospsize teaching1 SNH profit2;
model NBasicEHR2008=teaching1/type3;
run;
proc genmod data=slope ;
class ruca hospsize teaching1 SNH profit2;
model NBasicEHR2008=SNH/type3;
run;
proc genmod data=slope ;
class ruca hospsize teaching1 SNH profit2;
model NBasicEHR2008=profit2/type3 ;
run;
proc genmod data=slope ;
class ruca hospsize teaching1 SNH profit2 adopter samevendor speed;
model NBasicEHR2008=adopter/type3 ;
run;
proc genmod data=slope ;
class ruca hospsize teaching1 SNH profit2 adopter samevendor speed;
model NBasicEHR2008=samevendor/type3 ;
run;
proc genmod data=slope ;
class ruca hospsize teaching1 SNH profit2 adopter samevendor speed;
model NBasicEHR2008=speed/type3 ;
run;

proc genmod data=slope ;
class ruca hospsize teaching1 SNH profit2;
model slope=ruca/type3 ;
run;
proc genmod data=slope ;
class ruca hospsize teaching1 SNH profit2;
model slope=hospsize/type3 ;
run;
proc genmod data=slope ;
class ruca hospsize teaching1 SNH profit2;
model slope=teaching1/type3;
run;
proc genmod data=slope ;
class ruca hospsize teaching1 SNH profit2;
model slope=SNH/type3;
run;
proc genmod data=slope ;
class ruca hospsize teaching1 SNH profit2;
model slope=profit2/type3 ;
run;
proc genmod data=slope ;
class ruca hospsize teaching1 SNH profit2 adopter samevendor speed;
model slope=adopter/type3 ;
run;
proc genmod data=slope ;
class ruca hospsize teaching1 SNH profit2 adopter samevendor speed;
model slope=samevendor/type3 ;
run;
proc genmod data=slope ;
class ruca hospsize teaching1 SNH profit2 adopter samevendor speed;
model slope=speed/type3 ;
run;
ODS html close;
ODS Listing;  

 
   
 
************************************************************************
Appendix 2. Difference in Differences Table in Predicted Outcomes 
After 5 years for Average Hospitals with Different Implementation Decisions
************************************************************************;

%strat(by=speed,stratum=1,add1=ruca teaching1 hospsize profit2 , cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate",extra=1);
%strat(by=speed,stratum=1,add1=ruca teaching1 hospsize profit2 , cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate",extra=1);
%strat(by=speed,stratum=1,add1=ruca teaching1 hospsize profit2 , cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay",extra=1);

%strat(by=speed,stratum=2,add1=ruca teaching1 hospsize profit2 , cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate",extra=1);
%strat(by=speed,stratum=2,add1=ruca teaching1 hospsize profit2 , cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate",extra=1);
%strat(by=speed,stratum=2,add1=ruca teaching1 hospsize profit2 , cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay",extra=1);

%strat(by=speed,stratum=3,add1=ruca teaching1 hospsize profit2 , cond=15cond,meas=readm,day=30,title="Risk-adjusted 15-Composite 30-day Readmission Rate",extra=1);
%strat(by=speed,stratum=3,add1=ruca teaching1 hospsize profit2 , cond=15cond,meas=mort,day=30,title="Risk-adjusted 15-Composite 30-day Mortality Rate",extra=1);
%strat(by=speed,stratum=3,add1=ruca teaching1 hospsize profit2 , cond=15cond,meas=LOS, title="Risk-adjusted 15-Composite Length of Stay",extra=1);

ODS Listing CLOSE;
ODS html file="D:\Projects\Hartford\Appendix 2.xls" style=minimal;
 

%macro pvalue(by,meas);
data Estimates&meas.&by.1;
set Estimates&meas.&by.1;
if statement=2;
rename estimate=estimate1;rename stderr=stderr1;
keep estimate  stderr ;
run;
data Estimates&meas.&by.2;
set Estimates&meas.&by.2;
if statement=2;
rename estimate=estimate2;rename stderr=stderr2;
keep estimate  stderr ;
run;
data Estimates&meas.&by.3;
set Estimates&meas.&by.3;
if statement=2;
rename estimate=estimate3;rename stderr=stderr3;
keep estimate  stderr ;
run;
data &meas.&by.;
merge Estimates&meas.&by.1 Estimates&meas.&by.2 Estimates&meas.&by.3;
t1vs2=(estimate1-estimate2)/sqrt(stderr1*stderr1+stderr2*stderr2);
p1vs2=(1-probt(abs(t1vs2),2517))*2;
t1vs3=(estimate1-estimate3)/sqrt(stderr1*stderr1+stderr3*stderr3);
p1vs3=(1-probt(abs(t1vs3),2517))*2;
keep estimate1 estimate2 estimate3 t1vs2 p1vs2  t1vs3 p1vs3;
proc print;
title "&by. &meas.";
run;
%mend pvalue;
%pvalue(by=adopter,meas=readm);
%pvalue(by=adopter,meas=mort);
%pvalue(by=adopter,meas=los);


%macro pvalue(by,meas);
data Estimates&meas.&by.1;
set Estimates&meas.&by.1;
if statement=2;
rename estimate=estimate1;rename stderr=stderr1;
keep estimate  stderr ;
run;
data Estimates&meas.&by.2;
set Estimates&meas.&by.2;
if statement=2;
rename estimate=estimate2;rename stderr=stderr2;
keep estimate  stderr ;
run;
 
data &meas.&by.;
merge Estimates&meas.&by.1 Estimates&meas.&by.2 ;
t1vs2=(estimate1-estimate2)/sqrt(stderr1*stderr1+stderr2*stderr2);
p1vs2=(1-probt(abs(t1vs2),774))*2;
keep estimate1 estimate2  t1vs2 p1vs2  ; 
proc print;
title "&by. &meas.";
run;
%mend pvalue;
%pvalue(by=SameVendor,meas=readm);
%pvalue(by=SameVendor,meas=mort);
%pvalue(by=SameVendor,meas=los);

%pvalue(by=Speed,meas=readm);
%pvalue(by=Speed,meas=mort);
%pvalue(by=Speed,meas=los);
 ODS html close;
ODS Listing;  



* Observed average;
ODS Listing CLOSE;
ODS html file="D:\Projects\Hartford\Appendix 3.xls" style=minimal;
proc tabulate data=slope  ;
class  ruca hospsize teaching1 SNH profit2    ; 
format ruca ruca_. hospsize hospsize_. teaching1 teaching1_. SNH SNH_. profit2 profit_.;
title "average readmission/mortalty/length of stay ";
var  
adj15condreadm302008  adj15condreadm302009 adj15condreadm302010 adj15condreadm302011 adj15condreadm302012 adj15condreadm302013
adj15condmort302008  adj15condmort302009 adj15condmort302010 adj15condmort302011 adj15condmort302012 adj15condmort302013
adj15condLOS2008  adj15condLOS2009 adj15condLOS2010 adj15condLOS2011 adj15condLOS2012 adj15condLOS2013;

tables (all ruca hospsize teaching1 SNH profit2  ), 
(adj15condreadm302008="Readm 2008"*mean*f=7.4  adj15condreadm302009="Readm 2009"*mean*f=7.4 adj15condreadm302010="Readm 2010"*mean*f=7.4 
adj15condreadm302011="Readm 2011"*mean*f=7.4 adj15condreadm302012="Readm 2012"*mean*f=7.4 adj15condreadm302013="Readm 2013"*mean*f=7.4
adj15condmort302008="Mort 2008"*mean*f=7.4  adj15condmort302009="Mort 2009"*mean*f=7.4 adj15condmort302010="Mort 2010"*mean*f=7.4
adj15condmort302011="Mort 2011"*mean*f=7.4 adj15condmort302012="Mort 2012"*mean*f=7.4 adj15condmort302013="Mort 2013"*mean*f=7.4
adj15condLOS2008="LOS 2008"*mean*f=7.4 adj15condLOS2009="LOS 2009"*mean*f=7.4 adj15condLOS2010="LOS 2010"*mean*f=7.4
adj15condLOS2011="LOS 2011"*mean*f=7.4 adj15condLOS2012="LOS 2012"*mean*f=7.4 adj15condLOS2013="LOS 2013"*mean*f=7.4);
run;

proc tabulate data=slope  ;
class  ruca hospsize teaching1 SNH profit2  adopter samevendor speed ; 
format ruca ruca_. hospsize hospsize_. teaching1 teaching1_. SNH SNH_. profit2 profit_.;
title "average readmission/mortalty/length of stay ";
var  
adj15condreadm302008  adj15condreadm302009 adj15condreadm302010 adj15condreadm302011 adj15condreadm302012 adj15condreadm302013
adj15condmort302008  adj15condmort302009 adj15condmort302010 adj15condmort302011 adj15condmort302012 adj15condmort302013
adj15condLOS2008  adj15condLOS2009 adj15condLOS2010 adj15condLOS2011 adj15condLOS2012 adj15condLOS2013;

tables ( adopter samevendor speed), 
(adj15condreadm302008="Readm 2008"*(mean*f=7.4 StD*f=7.4) adj15condreadm302009="Readm 2009"*mean*f=7.4 adj15condreadm302010="Readm 2010"*mean*f=7.4 
adj15condreadm302011="Readm 2011"*mean*f=7.4 adj15condreadm302012="Readm 2012"*mean*f=7.4 adj15condreadm302013="Readm 2013"*mean*f=7.4
adj15condmort302008="Mort 2008"*(mean*f=7.4 StD*f=7.4)  adj15condmort302009="Mort 2009"*mean*f=7.4 adj15condmort302010="Mort 2010"*mean*f=7.4
adj15condmort302011="Mort 2011"*mean*f=7.4 adj15condmort302012="Mort 2012"*mean*f=7.4 adj15condmort302013="Mort 2013"*mean*f=7.4
adj15condLOS2008="LOS 2008"*(mean*f=7.4 StD*f=7.4) adj15condLOS2009="LOS 2009"*mean*f=7.4 adj15condLOS2010="LOS 2010"*mean*f=7.4
adj15condLOS2011="LOS 2011"*mean*f=7.4 adj15condLOS2012="LOS 2012"*mean*f=7.4 adj15condLOS2013="LOS 2013"*mean*f=7.4);
run;

 ODS html close;
ODS Listing;  

proc glm data=slope;
class samevendor  ;
model adj15condreadm302008=samevendor ;
run;
proc glm data=slope;
class samevendor  ;
model adj15condmort302008=samevendor ;
run;
proc glm data=slope;
class samevendor  ;
model adj15condLOS2008=samevendor ;
run;

proc glm data=slope;
class adopter  ;
model adj15condreadm302008=adopter;
run;
proc glm data=slope;
class adopter ;
model adj15condmort302008=adopter;
run;
proc glm data=slope;
class adopter ;
model adj15condLOS2008=adopter;
run;
