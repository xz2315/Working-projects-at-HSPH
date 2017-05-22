****************************************
External IT “Ecosystem” Characteristics
Xiner Zhou
8/18/2015
***************************************;
 libname data 'C:\data\Projects\Hartford\Data';

/*
For the HIE coverage variables, I used data from 2012 as per Julia's request. 

HIE_nostatewide means that the HSA is covered by HIOs (not taking into account HIOs who claim to be statewide)

HIE_yesstatewide means that the HSA is covered by HIOs taking into account HIOs who claim to be statewide

LTC_nostatewide means the HSA is covered by HIOs who have at least one participating LTC facility (not taking into account HIOs who claim to be statewide)


LTC_yesstatewide means the HSA is covered by HIO's who have at least one participating LTC facility, taking into account HIOs who claim to be statewide

*/
proc import datafile="C:\data\Projects\Hartford\Data\HIE.xlsx" dbms=xlsx out=HIE replace;
run;

data data.HIE;
set HIE;
where HSAnum ne .;
hsastate=upcase(hsastate);
hsacity=propcase(hsacity);
label HIE_nostatewide='HSA is covered by HIOs(not taking into account HIOs who claim to be statewide)';
label HIE_yesstatewide='HSA is covered by HIOs(taking into account HIOs who claim to be statewide)';
label LTC_nostatewide='HSA is covered by HIOs who have at least one participating LTC facility(not taking into account HIOs who claim to be statewide)';
label LTC_yesstatewide='HSA is covered by HIOs who have at least one participating LTC facility(taking into account HIOs who claim to be statewide)';
proc sort;by HSAnum;
proc freq;tables HIE_nostatewide HIE_yesstatewide LTC_nostatewide LTC_yesstatewide;
run;
