*************************
Output
7/28/2014
Xiner Zhou
*************************;


libname output 'C:\data\Projects\Marron\output';

 
proc sort data=pqi_rank;by state;run;
proc sort data=hcahps_rank;by state;run;
proc sort data=mortality_rank;by state;run;

data state_measures;
merge  pqi_rank hcahps_rank mortality_rank;
by state;
run;

 
* incorporate number and ranking intp one column;
data state_measures;
set state_measures;
length overall $15.;
overall=put(overall_pqi,10.)||' ('||put(overall_rank,2.)||')';
acute=put(acute_pqi,10.)||' ('||put(acute_rank,2.)||')';
chronic=put(chronic_pqi,10.)||' ('||put(chronic_rank,2.)||')';
hcahps=put(hospital_overall_rating,percent9.0)||' ('||put(hcahps_rank,2.)||')';
ami=put(ami_mortality_rate,percent9.2)||' ('||put(ami_rank,2.)||')';
stroke=put(stroke_mortality_rate,percent9.2)||' ('||put(stroke_rank,2.)||')';
run;


* Descriptive Stat;
%macro stat(var);
%do i=1 %to 6;
proc means data=state_measures ;
var %scan(&var.,&i.,' ') ;
output out=temp_&i. mean=mean  min=min max=max Q1=Q1 Median=Median Q3=Q3;
run;
data temp_&i.;set temp_&i.;name="%scan(&var.,&i.,' ')";keep name mean min max Q1 Median Q3;run;
%end;

%mend stat;

%stat(overall_pqi acute_pqi chronic_pqi hospital_overall_rating AMI_mortality_rate Stroke_mortality_rate);



* Excel output;

ods Tagsets.ExcelxP body='C:\data\Projects\Marron\output\state_report.xml';
proc print data=out_rank;run;
proc print data=ami_rank;run;
proc print data=stroke_rank;run;
proc print data=overall_PQI_rank;run;
proc print data=acute_PQI_rank;run;
proc print data=chronic_PQI_rank;run;

ods Tagsets.ExcelxP close;
