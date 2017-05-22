**********************************
Analytic Draft
Xiner Zhou
7/13/2016
**********************************;
libname MMleads 'C:\data\Data\MMLEADS\Data';

/*Analytical Plan in Dual Population:

1.	HC Duals by Age group:
•	<18		#Total Patients	#HC Patients	%HC Patients	
•	18-25
•	26-35
•	36-45
•	46-55
•	56-64
•	65-75
•	75-85
•	>86

2.	HC Duals by Income 
•	Stratify by Zip Code Median Income in Quartiles
•	Stratify by Zip Code Median Income in Quintiles

#Total Patients	#HC Patients	%HC Patients	

3.	HC Duals by Education-Level 
•	Stratify by Zip Code Median Income in Quartiles
•	Stratify by Zip Code Median Income in Quintiles

4.	Segments: 
a.	Under 65 by Median Income Quartiles
b.	Over 65 by Median Income Quartlies
c.	Under 65 by Median Income Quintiles
d.	Over 65 by Median Income Quintiles


5.	Persistent vs. Transience in HC duals

•	Number and proportion of each of the following [no segments; use all patients available]:
•	HC Duals in 2008, 2009 and 2010  
•	Non HC Duals in 2008, 2009, 2010

•	HC Duals in 2008, 2009 but not 2010
•	HC Duals in 2008, but not 2009 or 2010

•	Non HC Duals in 2008, but HC in 2009, 2010
•	Non HC Duals in 2008, 2009 but HC in 2010

Characteristics of each of the groups above
Cost and Utilization in 2010

6.	Preventable spending in Duals
•	Segment preventable spending by PQIs + 30day spending after PQI admission  [similar to Medicare study] for:
o	Segments
o	For the persistent vs. transcient duals in point #5


7.	Proportion of Patients who are HC( 5% 10% 25%) in Medicare and HC in Medicaid as well  in year 2010 only
*/

* Define HC in two ways, before that, make population base constant, that is, no new enrollee counts: 
* HC vs non-HC ;
* HC Medicare & HC Medicaid, non-HC Medicare & non-HC Medicaid, non-HC Medicare & HC Medicaid, HC Medicare & non-HC Medicaid ;
data temp;
set mmleads.data2008(in=in1) mmleads.data2009(in=in2) mmleads.data2010(in=in3) ;
if in1 then year=2008;
if in2 then year=2009;
if in3 then year=2010;
keep bene_id year;proc sort nodupkey;by bene_id year; 
run;

proc sql;
create table temp1 as
select bene_id, case when count(*)=3 then 1 else 0 end as in3Yr
from temp
group by bene_id;
quit;
