********************
Prevention Quality Indicator-PQI
Xiner Zhou
8/18/2015
********************;
 
libname PQI 'C:\data\Projects\Scorecard\data';
 libname data 'C:\data\Projects\Hartford\Data';
libname AHA 'C:\data\Data\Hospital\AHA\Annual_Survey\Data';

 
/*
common practice reports the measure as per 1,000 discharges. The user must multiply the rate obtained from the
software by 1,000 to report in-hospital deaths per 1,000 hospital discharges
*/

proc import datafile='C:\data\Projects\Hartford\Data\ZipHsaHrr13.xls' out=ZIPtoHRR dbms=xls replace;
getnames=yes;
run;

proc sql;
	create table PQI2013 as
	select a.provider, case when TAPQ90=. then 0 else 1 end as PQI2013, a.KEY as clm_id, b.*
	from  pqi.Pqi_medpar2013v45  a left join ZIPtoHRR b
	on input(a.BENE_ZIP, 9.)=b.ZIPcode13;
quit;

* Attribute HRR-level to hospitals;
proc sort data=PQI2013;by hrrnum;run;
proc sql;
	create table hrrPQI2013  as 
	select hrrnum, hrrcity, hrrstate, count(clm_id) as Discharge, sum(PQI2013)*1000/(calculated Discharge) as hrrPQI2013 
	from PQI2013 
	group by hrrnum;
quit;
proc sort data=hrrPQI2013  nodupkey;by hrrnum;run;


* Attribute Bene to hospital directly;
proc sort data=PQI2013;by provider;run;
proc sql;
	create table hospPQI2013  as 
	select provider, count(clm_id) as Discharge, sum(PQI2013)*1000/(calculated Discharge) as hospPQI2013 
	from PQI2013 
	group by provider;
quit;
proc sort data=hospPQI2013  nodupkey;by provider;run;
 
* Assign HRR to Hosp;
proc sql;
	create table hrrtohospPQI2013 as 
	select a.*,b.hrrPQI2013
	from 
	(select a.*,b.HRRname, b.hrrcode 
	from hospPQI2013 a left join AHA.AHA13 b 
	on a.provider=b.provider) a left join hrrPQI2013 b
    on a.hrrcode=b.hrrnum
    where substr(provider,3,2) in ('00','01','02','03','04','05','06','07','08','09','13');
quit;

 
