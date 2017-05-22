******************* 
Define Segmentation 
*******************;
libname denom 'D:\Data\Medicare\Denominator';
libname stdcost 'D:\data\Medicare\StdCost\Data';
libname data 'D:\Projects\High Cost Segmentation Phase II\Data';
libname frail 'D:\data\Medicare\Frailty Indicator';
libname icc 'D:\data\Medicare\Chronic Condition';
%let yr=2012;
%let yr=2013;
%let yr=2014;

 
*****************Segmentation Definition:
Seg 1: Age <65 
Seg 2: Frailty Indicator total 12 >=2 
Seg 3: Major CC >=3
Seg 4: Major CC 1 or 2 (>0 & <3)
Seg 5: Major CC=0 and Minor CC >0
Seg 6: Major CC=0 and Minor CC=0

Major CC: amiihd chrkid chf dementia lung psydis strk spchrtarr
Minior CC: amputat arthrit artopen bph cancer diabetes endo eyedis 
                 hemadis hyperlip hyperten immunedis ibd liver neuromusc osteo 
                 paralyt sknulc sa thyroid vascdis 
*************************************************************************************************;
 
proc sql;
create table temp1 as
select a.bene_id,a.age, b.*
from denom.dnmntr&yr. a left join icc.CC&yr. b
on a.bene_id=b.bene_id;
quit;

proc sql;
create table temp2 as
select a.*,b.*
from temp1 a left join frail.frailty&yr. b
on a.bene_id=b.bene_id;
quit;

data data.Segment&yr.;
length seg  $50.;
set temp2;
 

array f{12} frailty1 frailty2 frailty3 frailty4 frailty5 frailty6 frailty7 frailty8 frailty9 frailty10 frailty11 frailty12;
array CC{30} 
amiihd amputat arthrit  artopen  bph  
cancer  chrkid  chf  cystfib  dementia  
diabetes  endo  eyedis hemadis  hyperlip  
hyperten  immunedis  ibd liver  lung   
neuromusc  osteo  paralyt  psydis  sknulc 
spchrtarr  strk sa  thyroid  vascdis;
do i=1 to 12 ;
if f{i}=. then f{i}=0;
end;
do j=1 to 30;
if CC{j}=. then CC{j}=0;
end;
drop i j;

N_Frailty=frailty1+ frailty2+ frailty3+ frailty4+ frailty5+ frailty6+ frailty7+ frailty8+ frailty9+ frailty10+ frailty11+ frailty12;
N_MajorCC=amiihd+ chrkid+ chf+ dementia+ lung+ psydis+ strk+ spchrtarr;
N_MinorCC=amputat+ arthrit+ artopen+ bph+ cancer+ diabetes+ endo+ eyedis +
                 hemadis+ hyperlip+ hyperten+ immunedis+ ibd+ liver+ neuromusc+ osteo+ 
                 paralyt+ sknulc+ sa+ thyroid+ vascdis;

* Segmentation (Original for all <65 and >65);
if  Age<65 then seg="1.Under 65";
else if Age>=65 and N_Frailty>=2 then seg="2.Over 65,2 or more frailty";
else if Age>=65 and N_Frailty<2 and N_MajorCC>=3 then seg="3.Over 65,less than 2 frailty,3 or more major CC";
else if Age>=65 and N_Frailty<2 and N_MajorCC in (1,2) then seg="4.Over 65,less than 2 frailty,1 or 2 major CC";
else if Age>=65 and N_Frailty<2 and N_MajorCC=0 and N_MinorCC>0 then seg="5.Over 65,less than 2 frailty,no major CC,some minor CC";
else if Age>=65 and N_Frailty<2 and N_MajorCC=0 and N_MinorCC=0 then seg="6.Over 65,less than 2 frailty,no major CC,no minor CC";

label seg="Segmentation (Original for all <65 and >65)";
 
keep bene_id seg;
proc freq;tables   seg/missing;
 
run;
