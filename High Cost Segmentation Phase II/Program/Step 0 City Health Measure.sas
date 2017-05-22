************************************************************************************
Geo level socioeconomics 
Demographics  
Xiner Zhou
3/22/2017
************************************************************************************;
 
libname data 'D:\Projects\High Cost Segmentation Phase II\Data';
 
proc import datafile="D:\Projects\High Cost Segmentation Phase II\500_Cities__Local_Data_for_Better_Health.csv" 
out=city dbms=csv replace; 
getnames=yes; guessingrows=32767; 
run;
 
%macro sep(meas, i);
data measure&i.;
set city;
where measure=&meas. and Data_Value_Type="Age-adjusted prevalence";
measure&i.=Data_Value;
label measure&i.=&meas.;
rename StateDesc=state;
rename cityname=city;
keep year StateDesc CityName  Measure&i.   CityFIPS ;

proc sort;by CityFIPS descending year;
proc sort nodupkey;by CityFIPS;
run;
%mend sep;
%sep(meas="Current lack of health insurance among adults aged 18–64 Years", i=1);
%sep(meas="Binge drinking among adults aged >=18 Years", i=2);
%sep(meas="Cholesterol screening among adults aged >=18 Years", i=3);
%sep(meas="Current smoking among adults aged >=18 Years", i=4);
%sep(meas="Mental health not good for >=14 days among adults aged >=18 Years", i=5);
%sep(meas="No leisure-time physical activity among adults aged >=18 Years", i=6);
%sep(meas="Older adult men aged >=65 Years who are up to date on a core set of clinical preventive services: Flu shot past Year, PPV shot ever, Colorectal cancer screening", i=7);
%sep(meas="Older adult women aged >=65 Years who are up to date on a core set of clinical preventive services: Flu shot past Year, PPV shot ever, Colorectal cancer screening, and Mammogram past 2 Years", i=8);
%sep(meas="Physical health not good for >=14 days among adults aged >=18 Years", i=9);
%sep(meas="Sleeping less than 7 hours among adults aged >=18 Years", i=10);
%sep(meas="Visits to doctor for routine checkup within the past Year among adults aged >=18 Years", i=11);                                         
 
data measure;
merge measure1 measure2  measure3 measure4 measure5 measure6 measure7 measure8 measure9 measure10 measure11;
by  CityFIPS;
run;

* rank each measure into qurtiles;
proc rank data=measure out=measure_temp group=4;
var measure1 measure2  measure3 measure4 measure5 measure6 measure7 measure8 measure9 measure10 measure11;
ranks r_measure1 r_measure2 r_measure3 r_measure4 r_measure5 r_measure6 r_measure7 r_measure8 r_measure9 r_measure10 r_measure11;
run;

data measure ;
set measure_temp;
label r_measure1="Current lack of health insurance among adults aged 18–64 Years";
label r_measure2="Binge drinking among adults aged >=18 Years";
label r_measure3="Cholesterol screening among adults aged >=18 Years";
label r_measure4="Current smoking among adults aged >=18 Years"; 
label r_measure5="Mental health not good for >=14 days among adults aged >=18 Years"; 
label r_measure6="No leisure-time physical activity among adults aged >=18 Years";
label r_measure7="Older adult men aged >=65 Years who are up to date on a core set of clinical preventive services: Flu shot past Year, PPV shot ever, Colorectal cancer screening"; 
label r_measure8="Older adult women aged >=65 Years who are up to date on a core set of clinical preventive services: Flu shot past Year, PPV shot ever, Colorectal cancer screening, and Mammogram past 2 Years"; 
label r_measure9="Physical health not good for >=14 days among adults aged >=18 Years"; 
label r_measure10="Sleeping less than 7 hours among adults aged >=18 Years"; 
label r_measure11="Visits to doctor for routine checkup within the past Year among adults aged >=18 Years";
run;
 
* SAShelp built-in zipcode database;
proc sql;
create table data.CityMeasure as
select a.zip,a.city,b.*,case when a.city in (select city from measure) then 1 else 0 end as flag
from sashelp.zipcode a left join measure b
on a.city=b.city;
quit;
 
