****************************************
External Market Characteristics
Xiner Zhou
8/18/2015
***************************************;
 libname data 'C:\data\Projects\Hartford\Data';


/*
Income_avg: average income
NumMCRenr: number of medicare enrollees
MCRspendpp: medicare spending per enrollee, age, sex and race adjusted
MCRspendpp_priceadj: medicare spending per enrollee, price, age, sex and race adjusted
*/

proc import datafile="C:\data\Projects\Hartford\Data\market.xlsx" dbms=xlsx out=market replace;
run;

data data.market;
set market;
HSAnum=HSAcode*1;if HSAnum<=53026;
label Income_avg='Per Capita Income(HSA)';
label NumMCRenr='Number of Medicare Enrollees(HSA)';
label MCRspendpp='Medicare spending per enrollee, age, sex and race adjusted(HSA)';
label MCRspendpp_priceadj='Medicare spending per enrollee, price, age, sex and race adjusted(HSA)';
drop HSAcode County CountyName;
proc sort;by HSAnum;
run;
