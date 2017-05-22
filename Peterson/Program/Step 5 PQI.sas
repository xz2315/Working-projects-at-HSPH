*****************************************
PQI Per Bene and Per User Tabulation
Xiner Zhou
2/21/2017
*****************************************;
libname MMleads 'D:\Data\MMLEADS\Data';
libname denom 'D:\Data\Medicare\Denominator';
libname data 'D:\Projects\Peterson\Data';
 
%let yr=2008;
%let yr=2009;
%let yr=2010;

proc sql;
create table temp&yr.1 as
select a.*,b.*
from data.PlanAbene a left join data.PQI&yr. b
on a.bene_id=b.bene_id;
quit;

data temp&yr.2;
set temp&yr.1;

array temp {32}
N_TAPQ90 TAPQ90spending  
N_TAPQ91 TAPQ91spending 
N_TAPQ92 TAPQ92spending  
N_TAPQ01 TAPQ01spending 
N_TAPQ02 TAPQ02spending 
N_TAPQ03 TAPQ03spending 
N_TAPQ05 TAPQ05spending  
N_TAPQ07 TAPQ07spending   
N_TAPQ08 TAPQ08spending  
N_TAPQ10 TAPQ10spending 
N_TAPQ11 TAPQ11spending  
N_TAPQ12 TAPQ12spending   
N_TAPQ13 TAPQ13spending    
N_TAPQ14 TAPQ14spending    
N_TAPQ15 TAPQ15spending   
N_TAPQ16 TAPQ16spending;
/*
IPSpending OPSpending CarSpending HHASpending SNFSpending HspcSpending DMESpending TotSpending  ;
*/
do i=1 to 32;
if temp{i}=. then temp{i}=0;
end;drop i;



run;

* 100% if only PQI spending 5% sample otherwsise;
%macro maketable(yr );
ods excel file="D:\Projects\Peterson\PQI&yr..xlsx" style=minimal;

proc tabulate data= temp&yr.2 noseps   ;
*where pct5=1;
class group  ; 
var  
N_TAPQ90 TAPQ90spending  
N_TAPQ91 TAPQ91spending 
N_TAPQ92 TAPQ92spending  
N_TAPQ01 TAPQ01spending 
N_TAPQ02 TAPQ02spending 
N_TAPQ03 TAPQ03spending 
N_TAPQ05 TAPQ05spending  
N_TAPQ07 TAPQ07spending   
N_TAPQ08 TAPQ08spending  
N_TAPQ10 TAPQ10spending 
N_TAPQ11 TAPQ11spending  
N_TAPQ12 TAPQ12spending   
N_TAPQ13 TAPQ13spending    
N_TAPQ14 TAPQ14spending    
N_TAPQ15 TAPQ15spending   
N_TAPQ16 TAPQ16spending;
*IPSpending OPSpending CarSpending HHASpending SNFSpending HspcSpending DMESpending TotSpending ;


table (
N_TAPQ90 N_TAPQ91 N_TAPQ92 N_TAPQ01 N_TAPQ02 N_TAPQ03 N_TAPQ05 N_TAPQ07 N_TAPQ08 N_TAPQ10 N_TAPQ11 N_TAPQ12 N_TAPQ13 N_TAPQ14   N_TAPQ15 N_TAPQ16 
),group*(mean*f=7.4)  
All*(mean*f=7.4)  ;
 
table (
TAPQ90spending  TAPQ91spending TAPQ92spending  TAPQ01spending TAPQ02spending TAPQ03spending TAPQ05spending  TAPQ07spending   TAPQ08spending  TAPQ10spending 
TAPQ11spending  TAPQ12spending   TAPQ13spending    TAPQ14spending    TAPQ15spending   TAPQ16spending
),group*(mean*f=dollar12.)  
All*(mean*f=dollar12.)  ;

/*
table (
IPSpending OPSpending CarSpending HHASpending SNFSpending HspcSpending DMESpending TotSpending
),group*(mean*f=dollar12.)  
All*(mean*f=dollar12.)  ;
*/
Keylabel all="All Dual Eligible";
 format SRVC_1 $MR_SRVC_1_. SRVC_2 $MR_SRVC_2_. ;
run;
ods excel close;
%mend maketable;
%maketable(yr=2008);
%maketable(yr=2009);
%maketable(yr=2010);


* 3yr ave;
proc sql;
create table temp3 as
select a.bene_id, a.group, 
a.N_TAPQ90 as N2008, a.TAPQ90spending as spending2008, b.N_TAPQ90 as N2009, b.TAPQ90spending as spending2009
from temp20082 a left join temp20092 b
on a.bene_id=b.bene_id;
quit;

proc sql;
create table temp4 as
select a.*, b.N_TAPQ90 as N2010, b.TAPQ90spending as spending2010
from temp3 a left join temp20102 b
on a.bene_id=b.bene_id;
quit;

data temp5;
set temp4;
N=(N2008+N2009+N2010)/3;
spending=(spending2008+spending2009+spending2010)/3;
run;


proc tabulate data= temp5 noseps   ;
 
class group  ; 
var   spending ;

table ( spending ),group*(mean*f=dollar12.)  
All*(mean*f=dollar12.)  ;

Keylabel all="All Dual Eligible";
 
run;
