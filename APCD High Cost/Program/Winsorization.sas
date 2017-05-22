*********************************
Winsorization Medical Cost data
Xiner Zhou
8/22/2015
********************************;
libname APCD 'C:\data\Data\APCD\Massachusetts\Data';

proc means data=APCD.OPstdcostCY2011 p1 p99 p5 p95 max;
var spending stdcost;
run;


%let L=1;%let H=99;
proc univariate data=APCD.OPstdcostCY2011 noprint;
   var spending stdcost;
   output out=winsor   pctlpts=&H  pctlpre=spending stdcost;
run;
