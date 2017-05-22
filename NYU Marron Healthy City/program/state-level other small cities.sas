*****************************************
State-Level Health care quality ranking-- Small cities
Xiner Zhou
7/28/2014
*****************************************;

proc sort data=statelist out=temp1(keep=state name);by state;run;
proc sort data=citybyzip out=temp2(keep=state) nodupkey;by state;run;
proc sql;
create table temp3 as
select *
from temp1 
where state not in (select state from temp2);
quit;

