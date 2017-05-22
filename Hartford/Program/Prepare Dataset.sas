****************************************
Prepare Final Analytic Dataset
Xiner Zhou
8/18/2015
***************************************;
libname data 'C:\data\Projects\Hartford\Data\Data';
libname aha 'C:\data\Data\Hospital\AHA\Annual_Survey\Data';
 


/*
https://www.cms.gov/Regulations-and-Guidance/Legislation/EHRIncentivePrograms/index.html?redirect=/EHRIncentivePrograms

http://mehi.masstech.org/programs/medicaid-ehr-incentive-program/eligible-hospitals

=> Acute Care (including Critical Access) Hospitals
-  Last four digits of the CMS Certification Number (CCN) falls within 0001-0879 or 1300-1399. 
*/

*cross walk id to provider number;
data AHA12;set AHA.AHA12(keep=provider id Mname Mstate HRRname  HRRcode hosp_reg4 serv);t=HRRcode*1;HRR=put(t,z3.); serv1=serv*1;run;
data AHA11;set AHA.AHA11(keep=provider id Mname Mstate HRRname HRRcode hosp_reg4 serv);t=HRRcode*1;HRR=put(t,z3.); serv1=serv*1;run;
data AHA10;set AHA.AHA10(keep=provider id Mname Mstate HRRname HRRcode hosp_reg4 serv);t=HRRcode*1;HRR=put(t,z3.); serv1=serv*1;run;
data AHA09;set AHA.AHA09(keep=provider id Mname Mstate HRRname HRRcode hosp_reg4 serv);t=HRRcode*1;HRR=put(t,z3.); serv1=serv*1;run;
data AHA08;set AHA.AHA08(keep=provider id Mname Mstate HRRname HRRcode hosp_reg4 serv);t=HRRcode*1;HRR=put(t,z3.); serv1=serv*1;run;
data AHA07;set AHA.AHA07(keep=provider id Mname Mstate HRRname HRRcode hosp_reg4 serv);t=HRRcode*1;HRR=put(t,z3.); serv1=serv*1;run;
data AHA06;set AHA.AHA06(keep=provider id Mname Mstate HRRname HRRcode hosp_reg4 serv);t=HRRcode*1;HRR=put(t,z3.); serv1=serv*1;run;
data AHA05;set AHA.AHA05(keep=provider id Mname Mstate HRRname HRRcode hosp_reg4 serv);t=HRRcode*1;HRR=put(t,z3.); serv1=serv*1;run;
data AHA04;set AHA.AHA04(keep=provider id Mname Mstate HRRname HRRcode hosp_reg4 serv);t=HRRcode*1;HRR=put(t,z3.); serv1=serv*1;run;
data AHA03;set AHA.AHA03(keep=provider id Mname Mstate HRRname HRRcode hosp_reg4 serv);t=HRRcode*1;HRR=put(t,z3.); serv1=serv*1;run;

data AHA;
set AHA12(keep=provider id Mname Mstate HRRname HRR hosp_reg4 serv1 in=in1) AHA11(keep=provider id Mname Mstate HRRname HRR hosp_reg4 serv1 in=in2) AHA10(keep=provider id Mname Mstate HRRname HRR hosp_reg4 serv1 in=in3)
    AHA09(keep=provider id Mname Mstate HRRname HRR hosp_reg4 serv1 in=in4) AHA08(keep=provider id Mname Mstate HRRname HRR hosp_reg4 serv1 in=in5) AHA07(keep=provider id Mname Mstate HRRname HRR hosp_reg4 serv1 in=in6) 
	AHA06(keep=provider id Mname Mstate HRRname HRR hosp_reg4 serv1 in=in7) AHA05(keep=provider id Mname Mstate HRRname HRR hosp_reg4 serv1 in=in8) AHA04(keep=provider id Mname Mstate HRRname HRR hosp_reg4 serv1 in=in9) AHA03(keep=provider id Mname Mstate HRRname HRR hosp_reg4 serv1 in=in10);
	if in1 then year=2012;
	else if in2 then year=2011;
	else if in3 then year=2010;
	else if in4 then year=2009;
	else if in5 then year=2008;
	else if in6 then year=2007;
	else if in7 then year=2006;
	else if in8 then year=2005;
	else if in9 then year=2004;
	else if in10 then year=2003;
	proc sort ;by id descending year;
run;

proc sort data=AHA nodupkey;by id;run;
proc sort data=AHA  ;by descending year;run;
proc sort data=AHA nodupkey;by provider;run;

data AHA;set AHA;where hosp_reg4 ne . and hosp_reg4 ne 5;run;

data temp;
set AHA;
keep provider Mname Mstate serv1;
run;



* First part HIT data;
proc sql;
create table temp1 as
select a.*,b.*
from data.HIT a inner join AHA b
on a.id=b.id;
quit;
 

data Part1;
retain type provider id Mname Mstate Hrr HrrName;
set temp1;
	i=substr(provider,3,2) ; 
	if i in ('00','01','02','03','04','05','06','07','08','09') then type='Acute Care Hospitals';*3398;
	if i in ('13') then type='Critical Access Hospitals'; *1235;
     
    if i in ('00','01','02','03','04','05','06','07','08','09','13');
	label Mname='Hospital Name';
	label Mstate="Hospital State";
	 drop i;
	 proc sort nodupkey;by provider;
	proc freq ;tables type*serv1/nopercent norow nocol;
run;

* second part Hosptial Structureal Characteristics;
proc sql;
create table temp3 as
select a.*,b.*
from Part1 a left join data.HospChar b
on a.provider=b.provider;
quit;

proc rank data=temp3 out=temp4 group=4;
var  dshpct2012 ;
ranks  rank2012 ;
run;

data Part2;
set temp4;  
SNH2012=rank2012+1;label SNH2012="Safety-Net Hospital:1=DSH Quartile 1(Lowest) 4=DSH Quartile 4(Highest) 2012";
 
HSAnum=HSAcode*1;
drop rank2012  ;
run;
 
*Third part External IT Ecosystem Characteristics;
proc sql;
create table Part3 as
select a.*,b.hie_nostatewide,b.ltc_nostatewide,b.hie_yesstatewide,b.ltc_yesstatewide 
from Part2 a left join data.HIE b
on a.HSAnum=b.HSAnum;
quit;
 


*Fourth part External Market Characteristics;
proc sql;
create table temp7 as
select a.*,b.*
from Part3 a left join data.Market b
on a.HSAnum=b.HSAnum;
quit;

proc rank data=temp7 out=temp8 percent;var MCRspendpp_priceadj;ranks spendingRank;run;
proc sort data=temp8;by spendingRank;run;
data Part4;
set temp8;
if spendingRank ne . and spendingRank>=50 then SpendingAboveAve=1;else if spendingRank ne . then SpendingAboveAve=0;
label SpendingAboveAve="Above/Below Median average medicare spending in HSA";
drop spendingRank HSAnum HSAcity state;
run;

*Fifth part Outcome variables: readmission and mortality;
proc sort data=Part4;by provider;run;

%macro sortby(cond=,day=);
data &cond.Mort&day.2008;set data.&cond.Mort&day.2008; obs&cond.mort&day.2008=obs&cond.&day.2008; exp&cond.mort&day.2008=pred&cond.&day.2008; N&cond.mort&day.2008=N_Admission&cond.&day.2008;drop obs&cond.&day.2008 pred&cond.&day.2008 N_Admission&cond.&day.2008;run;
data &cond.Mort&day.2009;set data.&cond.Mort&day.2009; obs&cond.mort&day.2009=obs&cond.&day.2009; exp&cond.mort&day.2009=pred&cond.&day.2009; N&cond.mort&day.2009=N_Admission&cond.&day.2009;drop obs&cond.&day.2009 pred&cond.&day.2009 N_Admission&cond.&day.2009;run;
data &cond.Mort&day.2010;set data.&cond.Mort&day.2010; obs&cond.mort&day.2010=obs&cond.&day.2010; exp&cond.mort&day.2010=pred&cond.&day.2010; N&cond.mort&day.2010=N_Admission&cond.&day.2010;drop obs&cond.&day.2010 pred&cond.&day.2010 N_Admission&cond.&day.2010;run;
data &cond.Mort&day.2011;set data.&cond.Mort&day.2011; obs&cond.mort&day.2011=obs&cond.&day.2011; exp&cond.mort&day.2011=pred&cond.&day.2011; N&cond.mort&day.2011=N_Admission&cond.&day.2011;drop obs&cond.&day.2011 pred&cond.&day.2011 N_Admission&cond.&day.2011;run;
data &cond.Mort&day.2012;set data.&cond.Mort&day.2012; obs&cond.mort&day.2012=obs&cond.&day.2012; exp&cond.mort&day.2012=pred&cond.&day.2012; N&cond.mort&day.2012=N_Admission&cond.&day.2012;drop obs&cond.&day.2012 pred&cond.&day.2012 N_Admission&cond.&day.2012;run;
data &cond.Mort&day.2013;set data.&cond.Mort&day.2013; obs&cond.mort&day.2013=obs&cond.&day.2013; exp&cond.mort&day.2013=pred&cond.&day.2013; N&cond.mort&day.2013=N_Admission&cond.&day.2013;drop obs&cond.&day.2013 pred&cond.&day.2013 N_Admission&cond.&day.2013;run;

proc sort data=&cond.Mort&day.2008;by provider;run;
proc sort data=&cond.Mort&day.2009;by provider;run;
proc sort data=&cond.Mort&day.2010;by provider;run;
proc sort data=&cond.Mort&day.2011;by provider;run;
proc sort data=&cond.Mort&day.2012;by provider;run;
proc sort data=&cond.Mort&day.2013;by provider;run;

data &cond.Readm&day.2008;set data.&cond.Readm&day.2008; obs&cond.Readm&day.2008=obs&cond.&day.2008; exp&cond.Readm&day.2008=exp&cond.&day.2008; N&cond.Readm&day.2008=N&cond.&day.2008;drop obs&cond.&day.2008 exp&cond.&day.2008 N&cond.&day.2008;run;
data &cond.Readm&day.2009;set data.&cond.Readm&day.2009; obs&cond.Readm&day.2009=obs&cond.&day.2009; exp&cond.Readm&day.2009=exp&cond.&day.2009; N&cond.Readm&day.2009=N&cond.&day.2009;drop obs&cond.&day.2009 exp&cond.&day.2009 N&cond.&day.2009;run;
data &cond.Readm&day.2010;set data.&cond.Readm&day.2010; obs&cond.Readm&day.2010=obs&cond.&day.2010; exp&cond.Readm&day.2010=exp&cond.&day.2010; N&cond.Readm&day.2010=N&cond.&day.2010;drop obs&cond.&day.2010 exp&cond.&day.2010 N&cond.&day.2010;run;
data &cond.Readm&day.2011;set data.&cond.Readm&day.2011; obs&cond.Readm&day.2011=obs&cond.&day.2011; exp&cond.Readm&day.2011=exp&cond.&day.2011; N&cond.Readm&day.2011=N&cond.&day.2011;drop obs&cond.&day.2011 exp&cond.&day.2011 N&cond.&day.2011;run;
data &cond.Readm&day.2012;set data.&cond.Readm&day.2012; obs&cond.Readm&day.2012=obs&cond.&day.2012; exp&cond.Readm&day.2012=exp&cond.&day.2012; N&cond.Readm&day.2012=N&cond.&day.2012;drop obs&cond.&day.2012 exp&cond.&day.2012 N&cond.&day.2012;run;
data &cond.Readm&day.2013;set data.&cond.Readm&day.2013; obs&cond.Readm&day.2013=obs&cond.&day.2013; exp&cond.Readm&day.2013=exp&cond.&day.2013; N&cond.Readm&day.2013=N&cond.&day.2013;drop obs&cond.&day.2013 exp&cond.&day.2013 N&cond.&day.2013;run;

proc sort data=&cond.readm&day.2008;by provider;run;
proc sort data=&cond.readm&day.2009;by provider;run;
proc sort data=&cond.readm&day.2010;by provider;run;
proc sort data=&cond.readm&day.2011;by provider;run;
proc sort data=&cond.readm&day.2012;by provider;run;
proc sort data=&cond.readm&day.2013;by provider;run;
%mend sortby;
%sortby(cond=AMI,day=30);
%sortby(cond=AMI,day=90);
%sortby(cond=CHF,day=30);
%sortby(cond=CHF,day=90);
%sortby(cond=PN,day=30);
%sortby(cond=PN,day=90);
%sortby(cond=COPD,day=30);
%sortby(cond=COPD,day=90);
%sortby(cond=stroke,day=30);
%sortby(cond=stroke,day=90);
%sortby(cond=sepsis,day=30);
%sortby(cond=sepsis,day=90);
%sortby(cond=esggas,day=30);
%sortby(cond=esggas,day=90);
%sortby(cond=gib,day=30);
%sortby(cond=gib,day=90);
%sortby(cond=uti,day=30);
%sortby(cond=uti,day=90);
%sortby(cond=metdis,day=30);
%sortby(cond=metdis,day=90);
%sortby(cond=arrhy,day=30);
%sortby(cond=arrhy,day=90);
%sortby(cond=chest,day=30);
%sortby(cond=chest,day=90);
%sortby(cond=renalf,day=30);
%sortby(cond=renalf,day=90);
%sortby(cond=resp,day=30);
%sortby(cond=resp,day=90);
%sortby(cond=hipfx,day=30);
%sortby(cond=hipfx,day=90);

%macro link(cond=,day=,meas=);
&cond.&meas.&day.2008 &cond.&meas.&day.2009 &cond.&meas.&day.2010
&cond.&meas.&day.2011 &cond.&meas.&day.2012 &cond.&meas.&day.2013
%mend link;


data Part5;
merge Part4(in=in1) 
%link(cond=AMI,day=30,meas=readm) 
%link(cond=CHF,day=30,meas=readm) 
%link(cond=PN,day=30,meas=readm) 
%link(cond=copd,day=30,meas=readm) 
%link(cond=stroke,day=30,meas=readm) 
%link(cond=sepsis,day=30,meas=readm) 
%link(cond=esggas,day=30,meas=readm) 
%link(cond=gib,day=30,meas=readm) 
%link(cond=uti,day=30,meas=readm) 
%link(cond=metdis,day=30,meas=readm) 
%link(cond=arrhy,day=30,meas=readm) 
%link(cond=chest,day=30,meas=readm) 
%link(cond=renalf,day=30,meas=readm) 
%link(cond=resp,day=30,meas=readm) 
%link(cond=hipfx,day=30,meas=readm) 

%link(cond=AMI,day=30,meas=mort) 
%link(cond=CHF,day=30,meas=mort) 
%link(cond=PN,day=30,meas=mort) 
%link(cond=copd,day=30,meas=mort) 
%link(cond=stroke,day=30,meas=mort) 
%link(cond=sepsis,day=30,meas=mort) 
%link(cond=esggas,day=30,meas=mort) 
%link(cond=gib,day=30,meas=mort) 
%link(cond=uti,day=30,meas=mort) 
%link(cond=metdis,day=30,meas=mort) 
%link(cond=arrhy,day=30,meas=mort) 
%link(cond=chest,day=30,meas=mort) 
%link(cond=renalf,day=30,meas=mort) 
%link(cond=resp,day=30,meas=mort) 
%link(cond=hipfx,day=30,meas=mort) 

%link(cond=AMI,day=90,meas=readm) 
%link(cond=CHF,day=90,meas=readm) 
%link(cond=PN,day=90,meas=readm) 
%link(cond=copd,day=90,meas=readm) 
%link(cond=stroke,day=90,meas=readm) 
%link(cond=sepsis,day=90,meas=readm) 
%link(cond=esggas,day=90,meas=readm) 
%link(cond=gib,day=90,meas=readm) 
%link(cond=uti,day=90,meas=readm) 
%link(cond=metdis,day=90,meas=readm) 
%link(cond=arrhy,day=90,meas=readm) 
%link(cond=chest,day=90,meas=readm) 
%link(cond=renalf,day=90,meas=readm) 
%link(cond=resp,day=90,meas=readm) 
%link(cond=hipfx,day=90,meas=readm) 

%link(cond=AMI,day=90,meas=mort) 
%link(cond=CHF,day=90,meas=mort) 
%link(cond=PN,day=90,meas=mort) 
%link(cond=copd,day=90,meas=mort) 
%link(cond=stroke,day=90,meas=mort) 
%link(cond=sepsis,day=90,meas=mort) 
%link(cond=esggas,day=90,meas=mort) 
%link(cond=gib,day=90,meas=mort) 
%link(cond=uti,day=90,meas=mort) 
%link(cond=metdis,day=90,meas=mort) 
%link(cond=arrhy,day=90,meas=mort) 
%link(cond=chest,day=90,meas=mort) 
%link(cond=renalf,day=90,meas=mort) 
%link(cond=resp,day=90,meas=mort) 
%link(cond=hipfx,day=90,meas=mort)
;
by provider;
if in1=1;

run;

*Six part PQI;
proc sort data=data.PQI2008;by provider;run;
proc sort data=data.PQI2009;by provider;run;
proc sort data=data.PQI2010;by provider;run;
proc sort data=data.PQI2011;by provider;run;
proc sort data=data.PQI2012;by provider;run;
proc sort data=data.PQI2013;by provider;run;
proc sort data=Part5;by provider;run;

data Part6;
merge Part5(in=in1) data.PQI2008 data.PQI2009 data.PQI2010 data.PQI2011 data.PQI2012 data.PQI2013;
by provider;
if in1=1;
rename PQI2008=adjPQIadm1yr2008;
rename PQI2009=adjPQIadm1yr2009;
rename PQI2010=adjPQIadm1yr2010;
rename PQI2011=adjPQIadm1yr2011;
rename PQI2012=adjPQIadm1yr2012;
rename PQI2013=adjPQIadm1yr2013;
run;

* Add LOS;
%macro sortby(cond= );
data LOS&cond.2008;set data.LOS&cond.2008; NLOS&cond.2008=N&cond.2008;keep obsLOS&cond.2008 expLOS&cond.2008 NLOS&cond.2008 provider;run;
data LOS&cond.2009;set data.LOS&cond.2009; NLOS&cond.2009=N&cond.2009;keep obsLOS&cond.2009 expLOS&cond.2009 NLOS&cond.2009 provider;run;
data LOS&cond.2010;set data.LOS&cond.2010; NLOS&cond.2010=N&cond.2010;keep obsLOS&cond.2010 expLOS&cond.2010 NLOS&cond.2010 provider;run;
data LOS&cond.2011;set data.LOS&cond.2011; NLOS&cond.2011=N&cond.2011;keep obsLOS&cond.2011 expLOS&cond.2011 NLOS&cond.2011 provider;run;
data LOS&cond.2012;set data.LOS&cond.2012; NLOS&cond.2012=N&cond.2012;keep obsLOS&cond.2012 expLOS&cond.2012 NLOS&cond.2012 provider;run;
data LOS&cond.2013;set data.LOS&cond.2013; NLOS&cond.2013=N&cond.2013;keep obsLOS&cond.2013 expLOS&cond.2013 NLOS&cond.2013 provider;run;

proc sort data=LOS&cond.2008;by provider;run;
proc sort data=LOS&cond.2009;by provider;run;
proc sort data=LOS&cond.2010;by provider;run;
proc sort data=LOS&cond.2011;by provider;run;
proc sort data=LOS&cond.2012;by provider;run;
proc sort data=LOS&cond.2013;by provider;run;
 
%mend sortby;
%sortby(cond=AMI );
%sortby(cond=CHF);
%sortby(cond=PN);
%sortby(cond=COPD);
%sortby(cond=stroke);
%sortby(cond=sepsis);
%sortby(cond=esggas);
%sortby(cond=gib);
%sortby(cond=uti);
%sortby(cond=metdis);
%sortby(cond=arrhy);
%sortby(cond=chest);
%sortby(cond=renalf);
%sortby(cond=resp);
%sortby(cond=hipfx);
%sortby(cond=hipfx);


%macro link(cond=,day=,meas=);
LOS&cond.2008 LOS&cond.2009 LOS&cond.2010 LOS&cond.2011 LOS&cond.2012 LOS&cond.2013 
%mend link;

proc sort data=part6;by provider;run;
data Part7;
merge Part6(in=in1) 
%link(cond=AMI) 
%link(cond=CHF) 
%link(cond=PN) 
%link(cond=COPD) 
%link(cond=stroke) 
%link(cond=sepsis) 
%link(cond=esggas) 
%link(cond=gib) 
%link(cond=uti) 
%link(cond=metdis) 
%link(cond=arrhy) 
%link(cond=chest) 
%link(cond=renalf) 
%link(cond=resp) 
%link(cond=hipfx) 
%link(cond=hipfx) 
;
by provider;
if in1=1;

run;

*************************************Create Variables;

data temp27;
set Part7;

/*
 
Basic EHR Adoption	Binary, 0/1 if all measures met	Patient Demographics
		Physician Notes
		Nursing Assessment
		Problem Lists
		Medication Lists
		Discharge Summaries
		CPOE Medications
		View Lab Reports
		View Radiology Reports
		View Diagnostic Test Results
*/
 
array meas2008 {10}  a1_2008 b1_2008 c1_2008 d1_2008 e1_2008 f1_2008 a2_2008 b2_2008 d2_2008 c3_2008;
t=0;
do i= 1 to 10;
	if meas2008(i) in (1,2) then t=t+1;
end;
NBasicEHR2008=t;
BasicEHR2008=(t=10);
BasicEHRpct2008=t/10;
label NBasicEHR2008="N. of Basic EHR Adoption 2008,0-10";
label BasicEHR2008="Basic EHR Adoption 2008, Binary, 0/1 if all measures met";
label BasicEHRpct2008="% Basic EHR Adoption 2008,Percent of measures met";
 
 
array meas2009 {10}  a1_2009 b1_2009 c1_2009 d1_2009 e1_2009 f1_2009 a2_2009 b2_2009 d2_2009 c3_2009;
t=0;
do i= 1 to 10;
	if meas2009(i) in (1,2) then t=t+1;
end;
NBasicEHR2009=t;
BasicEHR2009=(t=10);
BasicEHRpct2009=t/10;
label NBasicEHR2009="N. of Basic EHR Adoption 2009,0-10";
label BasicEHR2009="Basic EHR Adoption 2009, Binary, 0/1 if all measures met";
label BasicEHRpct2009="% Basic EHR Adoption 2009,Percent of measures met";

 
array meas2010 {10}  a1_2010 b1_2010 c1_2010 d1_2010 e1_2010 f1_2010 a2_2010 b2_2010 d2_2010 c3_2010;
t=0;
do i= 1 to 10;
	if meas2010(i) in (1,2) then t=t+1;
end;
NBasicEHR2010=t;
BasicEHR2010=(t=10);
BasicEHRpct2010=t/10;
label NBasicEHR2010="N. of Basic EHR Adoption 2010,0-10";
label BasicEHR2010="Basic EHR Adoption 2010, Binary, 0/1 if all measures met";
label BasicEHRpct2010="% Basic EHR Adoption 2010,Percent of measures met";

array meas2011 {10}  a1_2011 b1_2011 c1_2011 d1_2011 e1_2011 f1_2011 a2_2011 b2_2011 d2_2011 c3_2011;
t=0;
do i= 1 to 10;
	if meas2011(i) in (1,2) then t=t+1;
end;
NBasicEHR2011=t;
BasicEHR2011=(t=10);
BasicEHRpct2011=t/10;
label NBasicEHR2011="N. of Basic EHR Adoption 2011,0-10";
label BasicEHR2011="Basic EHR Adoption 2011, Binary, 0/1 if all measures met";
label BasicEHRpct2011="% Basic EHR Adoption 2011,Percent of measures met";

array meas2012 {10}  a1_2012 b1_2012 c1_2012 d1_2012 e1_2012 f1_2012 a2_2012 b2_2012 d2_2012 c3_2012;
t=0;
do i= 1 to 10;
	if meas2012(i) in (1,2) then t=t+1;
end;
NBasicEHR2012=t;
BasicEHR2012=(t=10);
BasicEHRpct2012=t/10;
label NBasicEHR2012="N. of Basic EHR Adoption 2012,0-10";
label BasicEHR2012="Basic EHR Adoption 2012, Binary, 0/1 if all measures met";
label BasicEHRpct2012="% Basic EHR Adoption 2012,Percent of measures met";

array meas2013 {10}  a1_2013 b1_2013 c1_2013 d1_2013 e1_2013 f1_2013 a2_2013 b2_2013 d2_2013 c3_2013;
t=0;
do i= 1 to 10;
	if meas2013(i) in (1,2) then t=t+1;
end;
NBasicEHR2013=t;
BasicEHR2013=(t=10);
BasicEHRpct2013=t/10;
label NBasicEHR2013="N. of Basic EHR Adoption 2013,0-10";
label BasicEHR2013="Basic EHR Adoption 2013, Binary, 0/1 if all measures met";
label BasicEHRpct2013="% Basic EHR Adoption 2013,Percent of measures met";

/*
Comprehensive EHR Adoption	Binary, 0/1 if all measures met	All Basic EHR Adoption Measures
		Advanced Directives
		CPOE Lab Reports
		CPOE Rad Tests
		CPOE Consultation Requests
		CPOE Nursing Orders
		View Radiology Images
		View Diagnostic Test Images
		View Consultant Report
		Decision Support (DS) Clinical Guidelines
		DS Clinical Reminders
		DS Drug Allergy Results
		DS drug-drug interactions
		DS drug lab interactions
		DS drug dosing support
*/


array comp2008 {24}  a1_2008 b1_2008 c1_2008 d1_2008 e1_2008 f1_2008 a2_2008 b2_2008 d2_2008 c3_2008
g1_2008 c2_2008 e2_2008 f2_2008 a3_2008 b3_2008 d3_2008 e3_2008 a4_2008 b4_2008 c4_2008 d4_2008 e4_2008 f4_2008;
t=0;
do i= 1 to 24;
	if comp2008(i) in (1,2) then t=t+1;
end;
NComprehensiveEHR2008=t;
ComprehensiveEHR2008=(t=24);
ComprehensiveEHRpct2008=t/24;
label NComprehensiveEHR2008="N. of Comprehensive EHR Adoption 2008,0-24";
label ComprehensiveEHR2008="Comprehensive EHR Adoption 2008, Binary, 0/1 if all measures met";
label ComprehensiveEHRpct2008="% Comprehensive EHR Adoption 2008,Percent of measures met";
 

array comp2009 {24}  a1_2009 b1_2009 c1_2009 d1_2009 e1_2009 f1_2009 a2_2009 b2_2009 d2_2009 c3_2009
g1_2009 c2_2009 e2_2009 f2_2009 a3_2009 b3_2009 d3_2009 e3_2009 a4_2009 b4_2009 c4_2009 d4_2009 e4_2009 f4_2009;
t=0;
do i= 1 to 24;
	if comp2009(i) in (1,2) then t=t+1;
end;
NComprehensiveEHR2009=t;
ComprehensiveEHR2009=(t=24);
ComprehensiveEHRpct2009=t/24;
label NComprehensiveEHR2009="N. of Comprehensive EHR Adoption 2009,0-24";
label ComprehensiveEHR2009="Comprehensive EHR Adoption 2009, Binary, 0/1 if all measures met";
label ComprehensiveEHRpct2009="% Comprehensive EHR Adoption 2009,Percent of measures met";


array comp2010 {24}  a1_2010 b1_2010 c1_2010 d1_2010 e1_2010 f1_2010 a2_2010 b2_2010 d2_2010 c3_2010
g1_2010 c2_2010 e2_2010 f2_2010 a3_2010 b3_2010 d3_2010 e3_2010 a4_2010 b4_2010 c4_2010 d4_2010 e4_2010 f4_2010;
t=0;
do i= 1 to 24;
	if comp2010(i) in (1,2) then t=t+1;
end;
NComprehensiveEHR2010=t;
ComprehensiveEHR2010=(t=24);
ComprehensiveEHRpct2010=t/24;
label NComprehensiveEHR2010="N. of Comprehensive EHR Adoption 2010,0-24";
label ComprehensiveEHR2010="Comprehensive EHR Adoption 2010, Binary, 0/1 if all measures met";
label ComprehensiveEHRpct2010="% Comprehensive EHR Adoption 2010,Percent of measures met";


array comp2011 {24}  a1_2011 b1_2011 c1_2011 d1_2011 e1_2011 f1_2011 a2_2011 b2_2011 d2_2011 c3_2011
g1_2011 c2_2011 e2_2011 f2_2011 a3_2011 b3_2011 d3_2011 e3_2011 a4_2011 b4_2011 c4_2011 d4_2011 e4_2011 f4_2011;
t=0;
do i= 1 to 24;
	if comp2011(i) in (1,2) then t=t+1;
end;
NComprehensiveEHR2011=t;
ComprehensiveEHR2011=(t=24);
ComprehensiveEHRpct2011=t/24;
label NComprehensiveEHR2011="N. of Comprehensive EHR Adoption 2011,0-24";
label ComprehensiveEHR2011="Comprehensive EHR Adoption 2011, Binary, 0/1 if all measures met";
label ComprehensiveEHRpct2011="% Comprehensive EHR Adoption 2011,Percent of measures met";

array comp2012 {24}  a1_2012 b1_2012 c1_2012 d1_2012 e1_2012 f1_2012 a2_2012 b2_2012 d2_2012 c3_2012
g1_2012 c2_2012 e2_2012 f2_2012 a3_2012 b3_2012 d3_2012 e3_2012 a4_2012 b4_2012 c4_2012 d4_2012 e4_2012 f4_2012;
t=0;
do i= 1 to 24;
	if comp2012(i) in (1,2) then t=t+1;
end;
NComprehensiveEHR2012=t;
ComprehensiveEHR2012=(t=24);
ComprehensiveEHRpct2012=t/24;
label NComprehensiveEHR2012="N. of Comprehensive EHR Adoption 2012,0-24";
label ComprehensiveEHR2012="Comprehensive EHR Adoption 2012, Binary, 0/1 if all measures met";
label ComprehensiveEHRpct2012="% Comprehensive EHR Adoption 2012,Percent of measures met";

array comp2013 {24}  a1_2013 b1_2013 c1_2013 d1_2013 e1_2013 f1_2013 a2_2013 b2_2013 d2_2013 c3_2013
g1_2013 c2_2013 e2_2013 f2_2013 a3_2013 b3_2013 d3_2013 e3_2013 a4_2013 b4_2013 c4_2013 d4_2013 e4_2013 f4_2013;
t=0;
do i= 1 to 24;
	if comp2013(i) in (1,2) then t=t+1;
end;
NComprehensiveEHR2013=t;
ComprehensiveEHR2013=(t=24);
ComprehensiveEHRpct2013=t/24;
label NComprehensiveEHR2013="N. of Comprehensive EHR Adoption 2013,0-24";
label ComprehensiveEHR2013="Comprehensive EHR Adoption 2013, Binary, 0/1 if all measures met";
label ComprehensiveEHRpct2013="% Comprehensive EHR Adoption 2013,Percent of measures met";

if respond2008=. then do;NBasicEHR2008=.;BasicEHR2008=.;BasicEHRpct2008=.;NComprehensiveEHR2008=.;ComprehensiveEHR2008=.;ComprehensiveEHRpct2008=.;end;
if respond2009=. then do;NBasicEHR2009=.;BasicEHR2009=.;BasicEHRpct2009=.;NComprehensiveEHR2009=.;ComprehensiveEHR2009=.;ComprehensiveEHRpct2009=.;end;
if respond2010=. then do;NBasicEHR2010=.;BasicEHR2010=.;BasicEHRpct2010=.;NComprehensiveEHR2010=.;ComprehensiveEHR2010=.;ComprehensiveEHRpct2010=.;end;
if respond2011=. then do;NBasicEHR2011=.;BasicEHR2011=.;BasicEHRpct2011=.;NComprehensiveEHR2011=.;ComprehensiveEHR2011=.;ComprehensiveEHRpct2011=.;end;
if respond2012=. then do;NBasicEHR2012=.;BasicEHR2012=.;BasicEHRpct2012=.;NComprehensiveEHR2012=.;ComprehensiveEHR2012=.;ComprehensiveEHRpct2012=.;end;
if respond2013=. then do;NBasicEHR2013=.;BasicEHR2013=.;BasicEHRpct2013=.;NComprehensiveEHR2013=.;ComprehensiveEHR2013=.;ComprehensiveEHRpct2013=.;end;

drop t i;
proc sort;by hrr;run;

* Define Biggest Jump;
data temp28;
set temp27;
 
array temp(6) NBasicEHR2008 NBasicEHR2009 NBasicEHR2010 NBasicEHR2011 NBasicEHR2012 NBasicEHR2013;
jump5=temp{6}-temp{6-5};
jump4=max(temp{6}-temp{6-4},temp{5}-temp{5-4});
jump3=max(temp{6}-temp{6-3},temp{5}-temp{5-3},temp{4}-temp{4-3});
jump2=max(temp{6}-temp{6-2},temp{5}-temp{5-2},temp{4}-temp{4-2},temp{3}-temp{3-2});
jump1=max(temp{6}-temp{6-1},temp{5}-temp{5-1},temp{4}-temp{4-1},temp{3}-temp{3-1},temp{2}-temp{2-1});

maxjump=jump1;yeartake=1;
if jump2>maxjump then do;maxjump=jump2;yeartake=2;end;
if jump3>maxjump then do;maxjump=jump3;yeartake=3;end;
if jump4>maxjump then do;maxjump=jump4;yeartake=4;end;
if jump5>maxjump then do;maxjump=jump5;yeartake=5;end;

if NBasicEHR2008=. or NBasicEHR2009=. or NBasicEHR2010=. or NBasicEHR2011=. or NBasicEHR2012=. or NBasicEHR2013=. then do;maxjump=.; yeartake=.;end;
 

if maxjump>5 then do;
	if yeartake=1 then speed=1;
	else if yeartake in (2,3) then speed=2;
	else if yeartake in (4,5) then speed=3;
end;
/*
Basically, we want to look at the largest jump between adoption in the data and run the model only for hospitals 
that had a max jump of 6 or more. 
 
Then stratify based on how long it took for them to do it. 3 groups: 1 year (fast), 2-3 years (neither fast nor slow), 
and 4+ years (slow). The same way wefve been doing it before both with individual models and then again in one model 
with a dummy variable. 
*/
 
array temp1(4) NBasicEHR2008 NBasicEHR2009 NBasicEHR2010 NBasicEHR2011 ;
jump3=temp1{4}-temp1{4-3};
jump2=max(temp1{4}-temp1{4-2},temp1{3}-temp1{3-2});
jump1=max(temp1{4}-temp1{4-1},temp1{3}-temp1{3-1},temp1{2}-temp1{2-1});
 
maxjump=jump1;yeartake=1;
if jump2>maxjump then do;maxjump=jump2;yeartake=2;end;
if jump3>maxjump then do;maxjump=jump3;yeartake=3;end;

if NBasicEHR2008=. or NBasicEHR2009=. or NBasicEHR2010=. or NBasicEHR2011=.   then do;maxjump=.; yeartake=.;end; 
if speed=1 and maxjump>5 and yeartake=1 then speed=1;else if speed=1 then speed=.;
 


*/
drop i  jump5 jump4 jump3 jump2 jump1 ;
proc freq;tables speed/missing;
run;




proc sql;
create table HRR2008 as
select HRR, mean(BasicEHR2008) as BasicHRRrate2008,  mean(ComprehensiveEHR2008) as ComprehensiveHRRrate2008
from temp27
where respond2008=1
group by HRR
;
quit;


proc sql;
create table HRR2009 as
select HRR, mean(BasicEHR2009) as BasicHRRrate2009,  mean(ComprehensiveEHR2009) as ComprehensiveHRRrate2009
from temp27
where respond2009=1
group by HRR
;
quit;


proc sql;
create table HRR2010 as
select HRR, mean(BasicEHR2010) as BasicHRRrate2010 ,  mean(ComprehensiveEHR2010) as ComprehensiveHRRrate2010 
from temp27
where respond2010=1
group by HRR
;
quit;


proc sql;
create table HRR2011 as
select HRR, mean(BasicEHR2011) as BasicHRRrate2011,  mean(ComprehensiveEHR2011) as ComprehensiveHRRrate2011
from temp27
where respond2011=1
group by HRR
;
quit;


proc sql;
create table HRR2012 as
select HRR, mean(BasicEHR2012) as BasicHRRrate2012,  mean(ComprehensiveEHR2012) as ComprehensiveHRRrate2012
from temp27
where respond2012=1
group by HRR
;
quit;


proc sql;
create table HRR2013 as
select HRR, mean(BasicEHR2013) as BasicHRRrate2013,  mean(ComprehensiveEHR2013) as ComprehensiveHRRrate2013
from temp27
where respond2013=1
group by HRR
;
quit;

data HRR;
merge HRR2008 HRR2009 HRR2010 HRR2011 HRR2012 HRR2013;
by hrr;
run;


proc sql;
create table Part8 as
select a.*,b.*
from temp28 a left join HRR b
on a.HRR=b.HRR;
quit;

data data.Hartford;
set Part8;
label BasicHRRrate2008="Basic EHR adoption rate in the HRR 2008(only Hospitals responded to AHA IT Survey)";
label ComprehensiveHRRrate2008="Comprehensive EHR adoption rate in the HRR 2008(only Hospitals responded to AHA IT Survey)";
label BasicHRRrate2009="Basic EHR adoption rate in the HRR 2009(only Hospitals responded to AHA IT Survey)";
label ComprehensiveHRRrate2009="Comprehensive EHR adoption rate in the HRR 2009(only Hospitals responded to AHA IT Survey)";
label BasicHRRrate2010="Basic EHR adoption rate in the HRR 2010(only Hospitals responded to AHA IT Survey)";
label ComprehensiveHRRrate2010="Comprehensive EHR adoption rate in the HRR 2010(only Hospitals responded to AHA IT Survey)";
label BasicHRRrate2011="Basic EHR adoption rate in the HRR 2011(only Hospitals responded to AHA IT Survey)";
label ComprehensiveHRRrate2011="Comprehensive EHR adoption rate in the HRR 2011(only Hospitals responded to AHA IT Survey)";
label BasicHRRrate2012="Basic EHR adoption rate in the HRR 2012(only Hospitals responded to AHA IT Survey)";
label ComprehensiveHRRrate2012="Comprehensive EHR adoption rate in the HRR 2012(only Hospitals responded to AHA IT Survey)";
label BasicHRRrate2013="Basic EHR adoption rate in the HRR 2013(only Hospitals responded to AHA IT Survey)";
label ComprehensiveHRRrate2013="Comprehensive EHR adoption rate in the HRR 2013(only Hospitals responded to AHA IT Survey)";
proc contents order=varnum;
run;
 
