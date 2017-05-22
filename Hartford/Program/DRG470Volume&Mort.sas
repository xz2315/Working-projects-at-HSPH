********************************************
CMS: Risk-adjusted Mortality 
Xiner Zhou
2015/10/11
*******************************************;
libname ip 'C:\data\Data\Medicare\Inpatient';
libname medpar 'C:\data\Data\Medicare\MedPAR';
libname denom 'C:\data\Data\Medicare\Denominator';
libname hartford 'C:\data\Projects\Hartford\Data';
libname HCC 'C:\data\Data\Medicare\HCC\Clean\Data';
libname data 'C:\data\Projects\Jha_Requests\Data';
 


%macro clm(yr=);

%if &yr.=2008 %then %do;
data temp&yr.;
set MedPar.Medparsl&yr.;
    clm_id=MEDPARID;
    
	ADMSN_DT=ADMSNDT; 
	provider=PRVDRNUM;
	STUS_CD=DSTNTNCD;
 
if SPCLUNIT='';
 
i=substr(provider,3,2) ; 
	if i in ('00','01','02','03','04','05','06','07','08','09') then AcuteCare=1; else AcuteCare=0;
	if i in ('13') then CAH=1; else CAH=0; 
     
if i in ('00','01','02','03','04','05','06','07','08','09','13');

if SSLSSNF in ('S','L');
if SSLSSNF in ('L') and AcuteCare=1 then delete;
 
 
if DRG_CD='470';

year=year(DSCHRGDT);
keep bene_id clm_id year SPCLUNIT FACLMCNT  ADMSN_DT DSCHRGDT SRC_ADMS STUS_CD provider AcuteCare CAH;
proc sort nodupkey;by bene_id provider DSCHRGDT  ;
proc freq;tables CAH SPCLUNIT;
run; 
%end;

%else %if &yr.=2010 %then %do;
data temp&yr.;
set ip.Inptclms&yr.;
    clm_id=MEDPARID;
   
	STUS_CD=DSTNTNCD;
 if SPCLUNIT='';
 
i=substr(provider,3,2) ; 
	if i in ('00','01','02','03','04','05','06','07','08','09') then AcuteCare=1; else AcuteCare=0;
	if i in ('13') then CAH=1; else CAH=0; 
     
if i in ('00','01','02','03','04','05','06','07','08','09','13');

if SSLSSNF in ('S','L');
if SSLSSNF in ('L') and AcuteCare=1 then delete;
 
if DRG_CD='470';
year=year(DSCHRGDT);

keep bene_id clm_id year SPCLUNIT FACLMCNT  ADMSN_DT DSCHRGDT SRC_ADMS STUS_CD provider AcuteCare CAH;
proc sort nodupkey;by bene_id provider DSCHRGDT  ;
proc freq;tables CAH SPCLUNIT;
run; 

%end;


%else  %do;
data temp&yr.;
set ip.Inptclms&yr.;
    
i=substr(provider,3,2) ; 
	if i in ('00','01','02','03','04','05','06','07','08','09') then AcuteCare=1; else AcuteCare=0;
	if i in ('13') then CAH=1; else CAH=0; 
     
if i in ('00','01','02','03','04','05','06','07','08','09','13');
 
*if DRG_CD='470';

keep bene_id clm_id  PRNCPAL_DGNS_CD ADMSN_DT DSCHRGDT SRC_ADMS STUS_CD provider AcuteCare CAH;
proc sort nodupkey;by bene_id provider DSCHRGDT  ;
proc freq;tables CAH;
run; 

%end;
%mend clm;
%clm(yr=2008);
%clm(yr=2009);
%clm(yr=2010);
%clm(yr=2011);
%clm(yr=2012);
%clm(yr=2013);
 
libname data 'C:\data\Projects';
proc sql;
create table data.Claim as
select bene_id as Patient_ID, provider as Hospital_ID, ADMSN_DT as Admission_Date, DSCHRGDT as Discharge_Date, PRNCPAL_DGNS_CD as PrimaryDiagnosis
from temp2013 
where bene_id in (select bene_id from denom.Dnmntr2013 where FIVEPCT='Y' and hmo_mo=0);
quit;

proc sql;
create table data.Patient as
select a.bene_id as Patient_ID, a.State_cd as State, a.BENE_DOB as Birth_Date, a.Sex,
b.HCC1 as ChronicCondition1,b.HCC2  as ChronicCondition2,b.HCC5 as ChronicCondition3,b.HCC7 as ChronicCondition4,b.HCC8 as ChronicCondition5,
b.HCC9 as ChronicCondition6,b.HCC10 as ChronicCondition7
from denom.Dnmntr2013 a left join HCC.Hcc_iponly_100pct_2013 b
on a.bene_id=b.bene_id
where FIVEPCT='Y' and hmo_mo=0;
quit;
libname AHA 'C:\data\Data\Hospital\AHA\Annual_Survey\Data';
 
proc sql;
create table data.Hospital as
select provider as Hospital_ID label='Hospital ID',hospsize as  Size, hosp_reg4 as Region, Teaching, profit2 as Profit, urban
from AHA.aha12;
quit;



*HMO;
proc sql;
create table HMO2008 as
select *,case when bene_id in (select bene_id from denom.Dnmntr2008 where HMO_mo  ne '00') then 1 else 0 end as HMO
from temp2008
;
quit;

proc sql;
create table HMO2009 as
select  *,case when bene_id in (select bene_id from denom.Dnmntr2009 where HMO_mo  ne 0) then 1 else 0 end as HMO
from temp2009
;
quit;


proc sql;
create table HMO2010 as
select  *,case when bene_id in (select bene_id from denom.Dnmntr2010 where HMO_mo  ne 0) then 1 else 0 end as HMO
from temp2010
;
quit;


proc sql;
create table HMO2011 as
select  *,case when bene_id in (select bene_id from denom.Dnmntr2011 where HMO_mo  ne 0) then 1 else 0 end as HMO
from temp2011
;
quit;

proc sql;
create table HMO2012 as
select  *,case when bene_id in (select bene_id from denom.Dnmntr2012 where HMO_mo  ne 0) then 1 else 0 end as HMO
from temp2012
;
quit;


proc sql;
create table HMO2013 as
select  *,case when bene_id in (select bene_id from denom.Dnmntr2013 where HMO_mo ne 0) then 1 else 0 end as HMO
from temp2013
;
quit;








%macro link(yr=);

data Dnmntr&yr.;
set denom.Dnmntr&yr.;
keep bene_id DEATH_DT Age Sex race;
proc sort nodupkey;by bene_id;
run;

proc sql;
create table temp&yr._1 as
select a.*,b.*
from HMO&yr. a left join Dnmntr&yr. b
on a.bene_id=b.bene_id
where a.HMO=0;
quit;

proc sql;
create table temp&yr._2 as
select a.*,b.*
from temp&yr._1 a left join HCC.Hcc_iponly_100pct_&yr. b
on a.bene_id=b.bene_id;
quit;

%mend link;
%link(yr=2008);
%link(yr=2009);
%link(yr=2010);
%link(yr=2011);
%link(yr=2012);
%link(yr=2013);

data data.temp2008_2;set  temp2008_2;run;
data data.temp2009_2;set  temp2009_2;run;
data data.temp2010_2;set  temp2010_2;run;
data data.temp2011_2;set  temp2011_2;run;
data data.temp2012_2;set  temp2012_2;run;
data data.temp2013_2;set  temp2013_2;run;

%macro mort(yr= );

data temp&yr._3;
set data.temp&yr._2;

    if  SRC_ADMS  not in ('4') ;

	 
	if month(ADMSN_DT) ne 12 ;
  
	 
	if 0<=death_DT - ADMSN_DT<=30 then death=1; else death=0;
drop HCC161 HCC154 HCC150 HCC132 HCC119 HCC107 HCC72 HCC70 HCC68 HCC51 HCC52 HCC132 HCC154 HCC1;
	 
run;

 
*Risk-Adjustment Model;
proc genmod data=temp&yr._3  descending;
Title "Logistic Regression: Predicted Probability of 30-day Mortality, Adjusting for HCC,Age,Race,Sex";
	class death  sex race  provider 
          HCC2--HCC177;
	model death=age  race  sex 
                HCC2--HCC177/dist=bin link=logit type3;
	*repeated subject=provider/type=exch;
	output out=predmort&yr. pred=pmort&yr.;	
run;

*Predicted/Obs * Overall;
proc means data=predmort&yr. noprint;
var death;
output out=overallmort&yr. mean=overallmort&yr.;
run;
data _null_;set overallmort&yr.;call symput("overall",overallmort&yr.);run;

proc sort data=predmort&yr. ;by provider;run;
proc sql;
create table mort&yr. as
select *,mean(death) as Rawmort&yr.,sum(death) as obs&yr.,sum(pmort&yr.) as pred&yr., count(clm_id) as N&yr.
from predmort&yr. 
group by provider;
quit;
proc sort data=mort&yr.  nodupkey;by provider;run;

data data.mortDRG470&yr. ;
set  mort&yr. ;
overallmort&yr.=symget('overall')*1;
Adjmort&yr.=(obs&yr./pred&yr. )*overallmort&yr.;
    label Rawmort&yr.="&yr. Unadjusted all-cause 30-day Mortality";
	label overallmort&yr.="National Overall 30-day Mortality Rate";
	label N&yr.="Number of Index Admissions for this hospital";
	label obs&yr.="Number of Observed 30-day Mortality for this hospital";
	label pred&yr.="Number of Predicted 30-day Mortality for this hostpial ";
	label Adjmort&yr.="&yr. risk-adjusted all-cause 30-day Mortality";

keep provider overallmort&yr. N&yr. obs&yr. pred&yr. Adjmort&yr. Rawmort&yr. CAH AcuteCare;
proc sort;by provider;
run;


%mend mort;
%mort(yr=2013);
%mort(yr=2012);
%mort(yr=2011);
%mort(yr=2010);
%mort(yr=2009);
%mort(yr=2008);




%let yr=2008;
%let yr=2009;
%let yr=2010;
%let yr=2011;
%let yr=2012;
%let yr=2013;
 
proc means data= data.mortDRG470&yr. min mean median max N;
class CAH;weight N&yr.;
var Rawmort&yr. Adjmort&yr. overallmort&yr.;
run;



 
