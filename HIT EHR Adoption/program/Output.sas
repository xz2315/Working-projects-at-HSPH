*************************
Output
*************************;


libname output 'C:\data\Projects\Marron\output';

proc sort data=citypop;by city;run;
proc sort data=pqi;by city;run;
proc sort data=hcahps;by city;run;
proc sort data=mortality;by city;run;
data top10city;
merge citypop pqi hcahps mortality;
by city;
run;



