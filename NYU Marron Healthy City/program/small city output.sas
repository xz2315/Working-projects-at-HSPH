*************************
Output
*************************;


libname output 'C:\data\Projects\Marron\output';

proc sort data=smallcity(keep=city state name) out=smallcity nodupkey;by city;run;
proc sort data=pqi;by city;run;
proc sort data=hcahps;by city;run;
proc sort data=mortality;by city;run;
data othercity;
merge smallcity pqi hcahps mortality;
by city;
run;
 
  
 
 
ods Tagsets.ExcelxP body='C:\data\Projects\Marron\output\OtherCity.xml';
proc print data=othercity;run;
 
ods Tagsets.ExcelxP close;
