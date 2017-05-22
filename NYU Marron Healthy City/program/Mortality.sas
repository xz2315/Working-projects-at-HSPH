*************************
Marron Institute City Project
7/17/2014
City Level Quality Indicators--Mortality
******************************;

libname marron 'C:\data\Projects\Marron\Archive';
libname aha 'C:\data\Data\Hospital\AHA\Annual_Survey\Data';
libname hcahps 'C:\data\Data\Hospital\Archive\HQA';
libname hrr 'C:\data\Data\Dartmouth_Atlas\ZIP_HSA_HRR_XWalk';* ZIP_HSA_HRR has city and state names;
libname PQI 'C:\data\Projects\Scorecard\data';
libname medicare 'C:\data\Data\Medicare\Denominator';
libname mort  'C:\data\Data\Hospital\Medicare_Inpt\Mortality\data';
/*
Hospital Level: 30-day all-cause AMI mortality rate and Stroke mortality rate
*/

 
* ND: Number of Discharge;
proc sql;
create table temp1 as
select a.provider,b.zip, a.NDmortmeas_amiAll as Dis_AMI, a.NDmortmeas_strokeAll as Dis_Stroke,a.NDmortmeas_amiAll*a.rawmortmeas_amiAll30day as AMIdeath, a.NDmortmeas_strokeAll*a.rawmortmeas_strokeAll30day as Strokedeath
from (select provider, NDmortmeas_amiAll, rawmortmeas_amiAll30day, NDmortmeas_strokeAll, rawmortmeas_strokeAll30day from mort.adjmort40meas30day11) a inner join (select provider, zip  from aha.aha11) b
on a.provider=b.provider;
quit;

 

proc sql;
create table temp2 as
select *
from temp1 a inner join citybyzip b
on a.zip=b.zip;
quit;



proc sql;
create table mortality as
select distinct city, sum(AMIdeath)/sum(Dis_AMI) as AMI_mortality_rate format percent9.2, sum(Strokedeath)/sum(Dis_Stroke) as Stroke_mortality_rate format percent9.2
from temp2
group by city;
quit;
