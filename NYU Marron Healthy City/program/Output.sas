*************************
Output
*************************;


libname output 'C:\data\Projects\Marron\output';

proc sort data=citybyzip(keep=city state var4 rename=(var4=pop)) out=citylist nodupkey;by city;run;
proc sort data=pqi;by city;run;
proc sort data=hcahps;by city;run;
proc sort data=mortality;by city;run;
data top100city;
merge citylist  pqi hcahps mortality;
by city;
pop_num=input(pop,comma14.);
run;
proc sort data=top100city;by descending pop_num;run;
 


* Descriptive Stat;
%macro stat(var);
%do i=1 %to 6;
proc means data=top100city  ;
var %scan(&var.,&i.,' ') ;
output out=temp_&i. mean=mean  min=min max=max Q1=Q1 Median=Median Q3=Q3;
run;
data temp_&i.;set temp_&i.;name="%scan(&var.,&i.,' ')";keep name mean min max Q1 Median Q3;run;
%end;

%mend stat;

%stat(overall_pqi acute_pqi chronic_pqi hospital_overall_rating AMI_mortality_rate Stroke_mortality_rate);


* Histogram;
proc univariate data=top100city;
histogram overall_pqi ;
run;
proc univariate data=top100city;
histogram acute_pqi;
run;
proc univariate data=top100city;
histogram chronic_pqi ;
run;
proc univariate data=top100city;
histogram hospital_overall_rating;
run;
proc univariate data=top100city;
histogram AMI_mortality_rate;
run;
proc univariate data=top100city;
histogram Stroke_mortality_rate ;
run;
 
ods Tagsets.ExcelxP body='C:\data\Projects\Marron\output\Top100City.xml';
proc print data=top100city;
var city state pop_num Medicare_population overall_pqi acute_pqi chronic_pqi hospital_overall_rating AMI_mortality_rate Stroke_mortality_rate;
format pop_num comma10.0 ;run;
proc print data=temp_1;run;
proc print data=temp_2;run;
proc print data=temp_3;run;
proc print data=temp_4;run;
proc print data=temp_5;run;
proc print data=temp_6;run;

ods Tagsets.ExcelxP close;
