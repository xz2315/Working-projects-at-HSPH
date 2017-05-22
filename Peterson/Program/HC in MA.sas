******************************************************************
Summarize all medical cost for Medicare FFS Bene  20% Sample
Xiner Zhou
4/19/2016
******************************************************************;
libname bene 'C:\data\Data\Medicare\Denominator';
libname IP 'C:\data\Data\Medicare\Inpatient';
libname OP 'C:\data\Data\Medicare\Outpatient';
libname Carrier 'C:\data\Data\Medicare\Carrier';
libname HHA 'C:\data\Data\Medicare\HHA';
libname HOSPICE 'C:\data\Data\Medicare\Hospice';
libname SNF 'C:\data\Data\Medicare\SNF';
libname DME 'C:\data\Data\Medicare\DME';
libname HCC 'C:\data\Data\Medicare\HCC\2012';
libname data 'C:\data\Projects\Peterson\Data-XZ';

* Step 1: Get 20% Sample Medicare FFS in MA; 
proc sql;
create table bene as
select bene_id, BENE_ZIP, STATE_CD, STATE_CD||CNTY_CD as State_County_CD,  AGE,  SEX,  RTI_RACE_CD 
from bene.dnmntr2012   
where STRCTFLG in ("05","15") and A_MO_CNT=B_MO_CNT=12 and HMO_MO=0 
and bene_id in (select bene_id from bene.dnmntr2013 where STRCTFLG in ("05","15") and A_MO_CNT=B_MO_CNT=12 and HMO_MO=0 );
quit;
 
proc import datafile="C:\data\Projects\Peterson\Program-XZ\State Code.xlsx" out=State dbms=xlsx replace;getnames=yes;run;
proc import datafile="C:\data\Projects\Peterson\Program-XZ\County Code.xlsx" out=County dbms=xlsx replace;getnames=yes;run;

proc sql;
create table bene1 as
select a.*,b.*
from bene a left join state b
on input(a.state_cd,2.)= b.state_cd ;
quit;
proc sql;
create table bene2 as
select a.*,propcase(b.county) as County
from bene1 a left join county b
on a.State_County_CD= b.SSA_State_county_code;
quit;

data data.Patient;
set bene2;
length race $40.;
if sex='2' then gender="Female";
else if sex='1' then gender="Male";
if gender ne '';

if RTI_RACE_CD='1' then race="White"; 
else if RTI_RACE_CD='2' then race="Black"; 
else if RTI_RACE_CD='5' then race="Hispanic"; 
else race="Other";
drop RTI_RACE_CD;
if state ne '' and county ne '';
proc freq ;tables race gender state/missing;
run;



* Step 2: Get Cost for each setting and then summarize as total annual cost;
data ip;
length Type $10.;
set ip.Inptclms2012;
if PMT_AMT<0 then PMT_AMT=0; if DED_AMT<0 then DED_AMT=0; if COIN_AMT<0 then COIN_AMT=0; if BLDDEDAM<0 then BLDDEDAM=0;
Spending=PMT_AMT +DED_AMT+COIN_AMT+BLDDEDAM;
Type="IP"; 
keep bene_id Type Spending;
run;

data op;
length Type $20.;
set op.Otptclms2012;
if PMT_AMT<0 then PMT_AMT=0; if PTB_DED<0 then PTB_DED=0; if PTB_COIN<0 then  PTB_COIN=0; if BLDDEDAM<0 then BLDDEDAM=0; 
Spending=PMT_AMT +PTB_DED+PTB_COIN+BLDDEDAM;
Type="OP"; 
keep bene_id Type Spending;
run;

data carrier;
length Type $20.;
set carrier.Bcarclms2012;
if PROV_PMT<0 then PROV_PMT=0; if BENE_PMT<0 then BENE_PMT=0;  
Spending=PROV_PMT+BENE_PMT;
Type="Carrier"; 
keep bene_id Type Spending;
run;

data HHA;
length Type $20.;
set HHA.Hhaclms2012;
if PMT_AMT<0 then PMT_AMT=0; 
Spending=PMT_AMT;
Type="HHA";
keep bene_id Type Spending;
run;

data Hospice;
length Type $20.;
set Hospice.Hspcclms2012;
if PMT_AMT<0 then PMT_AMT=0; 
Spending=PMT_AMT;
Type="Hospice";
keep bene_id Type Spending;
run;
 

data SNF;
length Type $20.;
set SNF.Snfclms2012;
if PMT_AMT<0 then PMT_AMT=0; if DED_AMT<0 then DED_AMT=0; if COIN_AMT<0 then COIN_AMT=0; if BLDDEDAM<0 then BLDDEDAM=0;
Spending=PMT_AMT +DED_AMT+COIN_AMT+BLDDEDAM;
Type="SNF"; 
keep bene_id Type Spending;
run;


data DME;
length Type $20.;
set DME.Dmeclms2012;
if PROV_PMT<0 then PROV_PMT=0; if BENE_PMT<0 then BENE_PMT=0;  
Spending=PROV_PMT+BENE_PMT;
Type="DME"; 
keep bene_id Type Spending;
run;

proc sql;
create table temp2012 as
select *
from (select * from ip 
      outer union corr
      select * from op 
	  outer union corr
      select * from carrier 
	  outer union corr
      select * from hospice 
	  outer union corr
      select * from hha 
	  outer union corr
      select * from snf 
	  outer union corr
      select * from dme
      )
where bene_id in (select bene_id from data.patient);
quit;

proc sort data=temp2012;by bene_id Type;run;
proc sql;
create table temp2012_1 as
select bene_id, Type, sum(Spending) as tot_Spending
from temp2012
group by bene_id, Type;
quit;

proc transpose data=temp2012_1 out=temp2012_2;
by bene_id;
id Type;
var tot_Spending;
run;

proc sql;
create table data.Spending2012 as
select bene_id, ip, op, carrier, hha, hospice, snf, dme
from temp2012_2
where bene_id in (select bene_id from data.patient);
quit;


*2013;
data ip;
length Type $10.;
set ip.Inptclms2013;
if PMT_AMT<0 then PMT_AMT=0; if DED_AMT<0 then DED_AMT=0; if COIN_AMT<0 then COIN_AMT=0; if BLDDEDAM<0 then BLDDEDAM=0;
Spending=PMT_AMT +DED_AMT+COIN_AMT+BLDDEDAM;
Type="IP"; 
keep bene_id Type Spending;
run;

data op;
length Type $20.;
set op.Otptclms2013;
if PMT_AMT<0 then PMT_AMT=0; if PTB_DED<0 then PTB_DED=0; if PTB_COIN<0 then  PTB_COIN=0; if BLDDEDAM<0 then BLDDEDAM=0; 
Spending=PMT_AMT +PTB_DED+PTB_COIN+BLDDEDAM;
Type="OP"; 
keep bene_id Type Spending;
run;

data carrier;
length Type $20.;
set carrier.Bcarclms2013;
if PROV_PMT<0 then PROV_PMT=0; if BENE_PMT<0 then BENE_PMT=0;  
Spending=PROV_PMT+BENE_PMT;
Type="Carrier"; 
keep bene_id Type Spending;
run;

data HHA;
length Type $20.;
set HHA.Hhaclms2013;
if PMT_AMT<0 then PMT_AMT=0; 
Spending=PMT_AMT;
Type="HHA";
keep bene_id Type Spending;
run;

data Hospice;
length Type $20.;
set Hospice.Hspcclms2013;
if PMT_AMT<0 then PMT_AMT=0; 
Spending=PMT_AMT;
Type="Hospice";
keep bene_id Type Spending;
run;
 

data SNF;
length Type $20.;
set SNF.Snfclms2013;
if PMT_AMT<0 then PMT_AMT=0; if DED_AMT<0 then DED_AMT=0; if COIN_AMT<0 then COIN_AMT=0; if BLDDEDAM<0 then BLDDEDAM=0;
Spending=PMT_AMT +DED_AMT+COIN_AMT+BLDDEDAM;
Type="SNF"; 
keep bene_id Type Spending;
run;


data DME;
length Type $20.;
set DME.Dmeclms2013;
if PROV_PMT<0 then PROV_PMT=0; if BENE_PMT<0 then BENE_PMT=0;  
Spending=PROV_PMT+BENE_PMT;
Type="DME"; 
keep bene_id Type Spending;
run;

proc sql;
create table temp2013 as
select *
from (select * from ip 
      outer union corr
      select * from op 
	  outer union corr
      select * from carrier 
	  outer union corr
      select * from hospice 
	  outer union corr
      select * from hha 
	  outer union corr
      select * from snf 
	  outer union corr
      select * from dme
      )
where bene_id in (select bene_id from data.patient);
quit;

proc sort data=temp2013;by bene_id Type;run;
proc sql;
create table temp2013_1 as
select bene_id, Type, sum(Spending) as tot_Spending
from temp2013
group by bene_id, Type;
quit;

proc transpose data=temp2013_1 out=temp2013_2;
by bene_id;
id Type;
var tot_Spending;
run;

proc sql;
create table data.Spending2013 as
select a.bene_id, case when a.ip=. then 0 else a.ip end as ip, 
                case when a.op=. then 0 else a.op end as op,
				case when a.carrier=. then 0 else a.carrier end as carrier,
				case when a.hha=. then 0 else a.hha end as hha,
				case when a.snf=. then 0 else a.snf end as snf,
				case when a.hospice=. then 0 else a.hospice end as hospice,
				case when a.DME=. then 0 else a.DME end as DME,
				calculated ip + calculated op + calculated carrier + calculated hha + calculated snf + calculated hospice + calculated DME as Spending2013
from temp2013_2 a
where bene_id in (select bene_id from data.patient);
quit;





* Step 3: Get CCS Diagnosis and Procedure at patient level;
proc import datafile="C:\data\Projects\Peterson\Program-XZ\dxCCS_variable_list.csv" out=dxCCS dbms=csv replace;getnames=yes;run;
proc import datafile="C:\data\Projects\Peterson\Program-XZ\prCCS.csv" out=prCCS dbms=csv replace;getnames=yes;run;

data temp;
set ip.Inptclms2012(keep=bene_id PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25)
    op.Otptclms2012(keep=bene_id PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25)
    carrier.Bcarclms2012(keep=bene_id PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD12)
    DME.Dmeclms2012(keep=bene_id PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD12)
	HHA.Hhaclms2012(keep=bene_id PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25)
    Hospice.Hspcclms2012(keep=bene_id PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25)
	SNF.Snfclms2012(keep=bene_id PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25)
;
dx=PRNCPAL_DGNS_CD;output;dx=ICD_DGNS_CD1;output;dx=ICD_DGNS_CD2;output;dx=ICD_DGNS_CD3;output;dx=ICD_DGNS_CD4;output;dx=ICD_DGNS_CD5;output;
dx=ICD_DGNS_CD6;output;dx=ICD_DGNS_CD7;output;dx=ICD_DGNS_CD8;output;dx=ICD_DGNS_CD9;output;dx=ICD_DGNS_CD10;output;dx=ICD_DGNS_CD11;output;
dx=ICD_DGNS_CD12;output;dx=ICD_DGNS_CD13;output;dx=ICD_DGNS_CD14;output;dx=ICD_DGNS_CD15;output;dx=ICD_DGNS_CD16;output;dx=ICD_DGNS_CD17;output;
dx=ICD_DGNS_CD18;output;dx=ICD_DGNS_CD19;output;dx=ICD_DGNS_CD20;output;dx=ICD_DGNS_CD21;output;dx=ICD_DGNS_CD22;output;dx=ICD_DGNS_CD23;output;
dx=ICD_DGNS_CD24;output;dx=ICD_DGNS_CD25;output;

keep bene_id dx;
run;

proc sql;
create table temp1 as
select a.*,b.CCS_Category 
from temp a left join dxCCS b
on a.dx=b.ICD9dx
where dx ne '';
quit;

proc sort data=temp1 ;by bene_id CCS_Category;run;
proc sql;
create table temp2 as
select  *,count(*) as N
from temp1 
group by bene_id, CCS_Category;
quit;

proc sort data=temp2 nodupkey;by bene_id CCS_Category;run;
proc transpose data=temp2 out=temp3 prefix=CCS;
by bene_id;
id CCS_Category;
var N;
run;

data temp4;
set temp3;
drop _NAME_ ;
run;

proc sql;
create table data.dxCCS as
select *
from temp4 
where bene_id in (select bene_id from data.Patient);
quit;




* Step 4: Get HCC at patient level;
proc sql;
create table data.HCC as
select a.bene_id, HCC1, HCC2, HCC5, HCC7,HCC8, HCC9, 
HCC10, HCC15, HCC16, HCC17,  HCC18, HCC19,
HCC21, HCC25, HCC26, HCC27,
HCC31, HCC32, HCC33, HCC37, HCC38, 
HCC44, HCC45,
HCC51, HCC52, HCC54, HCC55,
HCC67, HCC68, HCC69,
HCC70, HCC71, HCC72, HCC73, HCC74, HCC75, HCC77, HCC78, HCC79,
HCC80, HCC81, HCC82, HCC83, 
HCC92, HCC95, HCC96,
HCC100, HCC101, HCC104, HCC105, HCC107, HCC108,
HCC111, HCC112, HCC119, 
HCC130, HCC131, HCC132, 
HCC148, HCC149, 
HCC150, HCC154, HCC155, HCC157, HCC158, 
HCC161, HCC164,
HCC174, HCC176, HCC177 
from hcc.Hcc_allclms_20pct_2012 a
where a.bene_id in (select bene_id from data.Patient);
quit;
 

* Step 5: Get Procedure Events;
libname betos 'C:\data\Projects\APCD High Cost\Archieve';

data temp;
set op.Otptrev2012(keep=bene_id HCPCS_CD)
    carrier.Bcarline2012(keep=bene_id HCPCS_CD)
    DME.Dmeline2012(keep=bene_id HCPCS_CD)
	HHA.Hharev2012(keep=bene_id HCPCS_CD)
    Hospice.Hspcrev2012(keep=bene_id HCPCS_CD)
	SNF.Snfrev2012(keep=bene_id HCPCS_CD)
;
run;

proc sql;
create table temp1 as
select a.*,substr(b.betos,1,3) as betos
from temp a left join betos.betos b
on a.HCPCS_CD=b.HCPCS;
quit;
 
 
proc sort data=temp1;by bene_id betos;run;

proc sql;
create table temp2 as
select bene_id, betos, count(*) as N
from temp1 
where betos ne ''  
group by bene_id, betos;
quit;

proc sort data=temp2 nodupkey;by bene_id betos;run;

proc transpose data=temp2 out=temp3 ;
by bene_id;
id betos;
var N;
run;

data temp3;set temp3;drop _name_;run;
proc sql;
create table data.ProcedureEvent as
select *
from temp3
where bene_id in (select bene_id from data.Patient);
quit;

data data.Betos_Variable_list;
set betos.betosbyclass;
keep betos description;
run;



* output;
data patient;
set data.patient;
where state_cd='22';
run;

proc sql;
create table spending2012 as
select *
from data.spending2012
where bene_id in (select bene_id from patient);
quit;
proc sql;
create table spending2013 as
select *
from data.spending2013
where bene_id in (select bene_id from patient);
quit;

proc sql;
create table HCC as
select *
from data.HCC
where bene_id in (select bene_id from patient);
quit;

proc sql;
create table dxccs as
select *
from data.dxccs
where bene_id in (select bene_id from patient);
quit;

proc sql;
create table Procedure as
select *
from data.Procedureevent
where bene_id in (select bene_id from patient);
quit;
