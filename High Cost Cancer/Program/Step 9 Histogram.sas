************************************************************************************
Persistent Medicare HC 2012-2014 -Jose

histogram of spending for the entire population, divided into deciles. Within each decile,
what is the % of cancer diagnoses? He thinks this might be a good Figure 1 for the paper.
 
Xiner Zhou
3/24/2017
************************************************************************************;
libname data 'D:\Projects\High Cost Segmentation Phase II\Data';
libname denom 'D:\Data\Medicare\Denominator';
libname stdcost 'D:\Data\Medicare\StdCost\Data';
libname frail 'D:\Projects\Medicare\Frailty Indicator';
libname cc 'D:\Data\Medicare\MBSF CC';
libname seg 'D:\Projects\High_Cost_Segmentation\Data';
libname icc 'D:\Data\Medicare\Chronic Condition';

proc rank data=data.Cancerhcsample2014 out= Cancerhcsample2014 group=10;
var
stdcost;
ranks
g_stdcost;
run;

data Cancerhcsample2014;
set Cancerhcsample2014;
g_stdcost=1+g_stdcost;
logstdcost=log(stdcost);
*keep stdcost g_stdcost HC10 ;
proc freq;tables g_stdcost/missing;
run;

proc sgplot data=Cancerhcsample2014;
density  stdcost/ type=kernal lineattrs=(color=red);
 
run;
proc sgplot data=Cancerhcsample2014;
 
histogram  stdcost  ;
run;

data anno;
    set temp3;
    length function color text $8;
    
      function = 'label';
      color    = 'blue';
      size     =  1;
      xsys     = '2';
      ysys     = '2';
      when     = 'a';
      x=ind;
      y=percent-.5;
	  text=left(put(cumpercent, 4.2));
run;

ods graphics off;

proc univariate data=Cancerhcsample2014 noprint;
histogram logstdcost /anno=anno cfill=pink  ;
run;


