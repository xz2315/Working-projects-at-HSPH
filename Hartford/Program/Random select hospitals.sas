libname AHA 'D:\data\Hospital\AHA\Annual_Survey\Data';

proc sort data=AHA.AHA14 out=aha14;where SERV='10' and profit2 in (1,2,3);by HRRCode ;run;
proc sql;
create table temp as 
select HRRCODE, HRRNAME, count(*) as Nhosp
from aha14
group by HRRCode;
quit;
proc sort data=temp nodupkey ;where HRRcode ne '' and Nhosp>=9;by HRRcode;run;


proc surveyselect data=temp
   method=srs n=90 out=SampleHRR;
run;

proc sql;
create table temp1 as
select a.*,b.*
from sampleHRR a left join aha14 b
on a.HRRCODE=b.HRRCODE;
quit;

proc surveyselect data=temp1
   method=srs n=9  seed=1953 out=SampleHosp;
   strata HRRCODE;
run;

ODS Listing CLOSE;
ODS html file="D:\Projects\Hartford\Sample HRR hosp 051117.xls" style=minimal;
proc print data=samplehosp;
var HRRCode HRRName NHosp provider MNAME 
MADMIN MLOCADDR  MLOCCITY MLOCSTCD MLOCZIP MSTATE 
profit2 teaching p_medicare p_medicaid hospsize hosp_reg4 urban CAH micu cicu ;
run;

 ODS html close;
ODS Listing; 
