***********************************
Revision for Health Affair
Xiner Zhou
9/22/2016
***********************************;
libname map 'C:\data\Projects\Medicare Utilization vs MA Rate\data';

/* Look 14 2007-2014 Cost, Utilization, Quality */

data data0;
set map.data;
ave1=(mhi2007rank+mhi2008rank+mhi2009rank+ mhi2010rank+ mhi2011rank+ mhi2012rank+ mhi2013rank+mhi2014rank)/7;
if ave1-int(ave1)<0.5 then  MHIrank=int(ave1);
else if ave1-int(ave1)>=0.5 then  MHIrank=int(ave1)+1;

ave2=(physician2007rank+physician2008rank+physician2009rank+ physician2010rank+ physician2011rank+ physician2012rank+ physician2013rank+ physician2014rank)/7;
if ave2-int(ave2)<0.5 then  physicianrank=int(ave2);
else if ave2-int(ave2)>=0.5 then  physicianrank=int(ave2)+1;
 

ave3=(PrimaryCare2007rank+PrimaryCare2008rank+PrimaryCare2009rank+PrimaryCare2010rank+PrimaryCare2011rank+PrimaryCare2012rank+PrimaryCare2013rank+PrimaryCare2014rank)/7;
if ave3-int(ave3)<0.5 then  PCPrank=int(ave3);
else if ave3-int(ave3)>=0.5 then  PCPrank=int(ave3)+1;

ave4=(hospbd2007rank+hospbd2008rank+hospbd2009rank+hospbd2010rank+hospbd2011rank+hospbd2012rank+hospbd2013rank+hospbd2014rank)/7;
if ave4-int(ave4)<0.5 then  hospbdrank=int(ave4);
else if ave4-int(ave4)>=0.5 then  hospbdrank=int(ave4)+1;

ave4=(specialty2007rank+specialty2008rank+specialty2009rank+specialty2010rank+specialty2011rank+specialty2012rank+specialty2013rank+specialty2014rank)/7;
if ave4-int(ave4)<0.5 then  specialtyrank=int(ave4);
else if ave4-int(ave4)>=0.5 then  specialtyrank=int(ave4)+1;

drop ave1 ave2 ave3 ave4 ave5;

map2007rank=map2007rank+1;
MHIrank=MHIrank+1;
PhysicianRank=PhysicianRank+1;
PCPrank=PCPrank+1;
hospbdrank=hospbdrank+1;
specialtyrank=specialtyrank+1;

 
proc freq ;tables map2007rank mhirank physicianrank PCPrank hospbdrank  /missing;
run;

proc freq data=map.data;tables state/out=state;run;
data state;
set state;
stateflag=_n_;
run;

proc sql;
create table data as
select a.*,b.stateflag
from data0 a left join state b
on a.state=b.state;
quit;


**********************************************************************************
Model 1 : County-level Random Effect Model
**********************************************************************************;
%macro model1(dvar);


data ldata;
set data;
 
&dvar.=&dvar.2007;map=map2007/10;Year=2007;HCC=HCC2007;PCP=PrimaryCare2007;specialty=specialty2007;hospbd=hospbd2007;pov=pov2007;mhi=mhi2007;blackpct=blackpct2007;hisppct=hisppct2007;otherpct=otherpct2007;hcc=hcc2007; age=age2007;payrate=payrate2007; ffs=ffs2007;output;
&dvar.=&dvar.2008;map=map2008/10;Year=2008;HCC=HCC2008;PCP=PrimaryCare2008;specialty=specialty2008;hospbd=hospbd2008;pov=pov2008;mhi=mhi2008;blackpct=blackpct2008;hisppct=hisppct2008;otherpct=otherpct2008;hcc=hcc2008; age=age2008;payrate=payrate2008; ffs=ffs2008;output;
&dvar.=&dvar.2009;map=map2009/10;Year=2009;HCC=HCC2009;PCP=PrimaryCare2009;specialty=specialty2009;hospbd=hospbd2009;pov=pov2009;mhi=mhi2009;blackpct=blackpct2009;hisppct=hisppct2009;otherpct=otherpct2009;hcc=hcc2009; age=age2009;payrate=payrate2009; ffs=ffs2009;output;
&dvar.=&dvar.2010;map=map2010/10;Year=2010;HCC=HCC2010;PCP=PrimaryCare2010;specialty=specialty2010;hospbd=hospbd2010;pov=pov2010;mhi=mhi2010;blackpct=blackpct2010;hisppct=hisppct2010;otherpct=otherpct2010;hcc=hcc2010; age=age2010;payrate=payrate2010; ffs=ffs2010;output;
&dvar.=&dvar.2011;map=map2011/10;Year=2011;HCC=HCC2011;PCP=PrimaryCare2011;specialty=specialty2011;hospbd=hospbd2011;pov=pov2011;mhi=mhi2011;blackpct=blackpct2011;hisppct=hisppct2011;otherpct=otherpct2011;hcc=hcc2011; age=age2011;payrate=payrate2011; ffs=ffs2011;output;
&dvar.=&dvar.2012;map=map2012/10;Year=2012;HCC=HCC2012;PCP=PrimaryCare2012;specialty=specialty2012;hospbd=hospbd2012;pov=pov2012;mhi=mhi2012;blackpct=blackpct2012;hisppct=hisppct2012;otherpct=otherpct2012;hcc=hcc2012; age=age2012;payrate=payrate2012; ffs=ffs2012;output;
&dvar.=&dvar.2013;map=map2013/10;Year=2013;HCC=HCC2013;PCP=PrimaryCare2013;specialty=specialty2013;hospbd=hospbd2013;pov=pov2013;mhi=mhi2013;blackpct=blackpct2013;hisppct=hisppct2013;otherpct=otherpct2013;hcc=hcc2013; age=age2013;payrate=payrate2013; ffs=ffs2013;output;
&dvar.=&dvar.2014;map=map2014/10;Year=2014;HCC=HCC2014;PCP=PrimaryCare2014;specialty=specialty2014;hospbd=hospbd2014;pov=pov2014;mhi=mhi2014;blackpct=blackpct2014;hisppct=hisppct2014;otherpct=otherpct2014;hcc=hcc2014; age=age2014;payrate=payrate2014; ffs=ffs2014;output;

keep fips stateflag &dvar. map  map2007 Year PCP  specialty hospbd pov mhi blackpct hisppct otherpct hcc age payrate ffs ;
run;
 


*Un-adjusted;
proc mixed data=ldata empirical  ;
	class fips stateflag;  
	model &dvar.=  map year stateflag/solution cl;
	random intercept  /subject=fips type=un s;
	ods output solutionF=unadj;
run;
*Adjusted only for market characteristics (hospital beds, primary care doctors, specialists);
proc mixed data=ldata empirical  ;
	class fips stateflag;   
	model &dvar.=  map year PCP specialty hospbd stateflag/solution cl;
	random intercept  /subject=fips  type=un s;
	ods output solutionF=market;
run;
*Adjusted for demographics (% below federal poverty line, median household income, percent black, percent Hispanic, other percent, HCC, population, FFS, age);
proc mixed data=ldata empirical ;
	class fips stateflag;   
	model &dvar.=  map year hcc pov mhi blackpct hisppct otherpct age payrate stateflag/solution cl;
	random intercept  /subject=fips  type=un s;
	ods output solutionF=demog;
run;
* Fully adjusted;
proc mixed data=ldata empirical ;
	class fips stateflag;  
	model &dvar.=  map year PCP  specialty hospbd hcc pov mhi blackpct hisppct otherpct age payrate stateflag /solution cl;
	random intercept   /subject=fips  type=un s;
	ods output solutionF=full;
run;

data Unadj;
	length model $80.;
	set Unadj;
	model='Unadjusted';drop DF tValue Alpha  ;
run;
data market;
	length model $80.;
	set market;
	model='Adjusted only for market characteristics';drop DF tValue Alpha ;
run;
data demog;
	length model $80.;
	set demog;
	model='Adjusted for demographics';drop DF tValue Alpha  ;
run;
data full;
	length model $80.;
	set full;
	model='Fully adjusted';drop DF tValue Alpha  ;
run;

data all&dvar.;
length outcome $30.;
set Unadj market demog full;
outcome="&dvar.";
where effect='map';
proc print;
run;
 
%mend model1;
%model1(dvar=cost);
%model1(dvar=ip_cost);
%model1(dvar=pac_ltch_cost);
%model1(dvar=pac_irf_cost);
%model1(dvar=pac_snf_cost); 
%model1(dvar=pac_hh_cost);
%model1(dvar=Hospice_cost);
%model1(dvar=op_cost);
%model1(dvar=FQHC_RHC_cost); 
%model1(dvar=Outpatient_Dialysis_cost);
%model1(dvar=ASC_cost);
%model1(dvar=EM_cost);
%model1(dvar=Procedures_cost); 
%model1(dvar=Imaging_cost);
%model1(dvar=DME_cost);
%model1(dvar=Tests_cost);
%model1(dvar=PartB_Drugs_cost);
%model1(dvar=Ambulance_cost);

%model1(dvar=IP_day);
%model1(dvar=pac_ltch_day);
%model1(dvar=pac_irf_day); 
%model1(dvar=pac_snf_day);
%model1(dvar=pac_hh_visit);
%model1(dvar=Hospice_day);
%model1(dvar=OP_Visit);
%model1(dvar=FQHC_RHC_Visit);
%model1(dvar=Outpatient_Dialysis_Event);
%model1(dvar=ASC_Event); 
%model1(dvar=EM_Event);
%model1(dvar=Procedure_Event);
%model1(dvar=Imaging_Event);
%model1(dvar=DME_Event);
%model1(dvar=Test_Event);
%model1(dvar=Ambulance_Event);
%model1(dvar=ED_Visit);

%model1(dvar=readm);
 
data all;
set allcost allip_cost allpac_ltch_cost allpac_irf_cost allpac_snf_cost allpac_hh_cost allHospice_cost allop_cost allFQHC_RHC_cost 
allOutpatient_Dialysis_cost allASC_cost allEM_cost allProcedures_cost allImaging_cost allDME_cost allTests_cost allPartB_Drugs_cost 
allAmbulance_cost allIP_day allpac_ltch_day allpac_irf_day allpac_snf_day allpac_hh_visit allHospice_day allOP_Visit allFQHC_RHC_Visit 
allOutpatient_Dialysis_Event allASC_Event allEM_Event allProcedure_Event allImaging_Event allDME_Event allTest_Event allAmbulance_Event 
allED_Visit allreadm;
 proc print;
	run;



*********************************************
Model 2: 1-Year Lag 
********************************************;

%macro model1yr(dvar);
data ldata;
set  data;

&dvar.=&dvar.2009-&dvar.2008;  map=(map2008-map2007)/10;  
PCP=(PrimaryCare2007+PrimaryCare2008+PrimaryCare2009)/3;
Specialty=(Specialty2007+Specialty2008+Specialty2009)/3;
hospbd=(hospbd2007+hospbd2008+hospbd2009)/3;
pov=(pov2007+pov2008+pov2009)/3; 
MHI=(MHI2007+MHI2008+MHI2009)/3;
blackpct=(blackpct2007+blackpct2008+blackpct2009)/3;
hisppct=(hisppct2007+hisppct2008+hisppct2009)/3;
otherpct=(otherpct2007+otherpct2008+otherpct2009)/3;
HCC=(HCC2007+HCC2008+HCC2009)/3; 
age=(age2007+age2008+age2009)/3;
PayRate=(PayRate2007+PayRate2008+PayRate2009)/3; 
time=1;year=1;output;

&dvar.=&dvar.2010-&dvar.2009;  map=(map2009-map2008)/10;  
PCP=(PrimaryCare2008+PrimaryCare2009+PrimaryCare2010)/3;
Specialty=(Specialty2008+Specialty2009+Specialty2010)/3;
hospbd=(hospbd2008+hospbd2009+hospbd2010)/3;
pov=(pov2008+pov2009+pov2010)/3; 
MHI=(MHI2008+MHI2009+MHI2010)/3;
blackpct=(blackpct2008+blackpct2009+blackpct2010)/3;
hisppct=(hisppct2008+hisppct2009+hisppct2010)/3;
otherpct=(otherpct2008+otherpct2009+otherpct2010)/3;
HCC=(HCC2008+HCC2009+HCC2010)/3; 
age=(age2008+age2009+age2010)/3;
PayRate=(PayRate2008+PayRate2009+PayRate2010)/3; 
time=2;year=2;output;

&dvar.=&dvar.2011-&dvar.2010;  map=(map2010-map2009)/10;  
PCP=(PrimaryCare2009+PrimaryCare2010+PrimaryCare2011)/3;
Specialty=(Specialty2009+Specialty2010+Specialty2011)/3;
hospbd=(hospbd2009+hospbd2010+hospbd2011)/3;
pov=(pov2009+pov2010+pov2011)/3; 
MHI=(MHI2009+MHI2010+MHI2011)/3;
blackpct=(blackpct2009+blackpct2010+blackpct2011)/3;
hisppct=(hisppct2009+hisppct2010+hisppct2011)/3;
otherpct=(otherpct2009+otherpct2010+otherpct2011)/3;
HCC=(HCC2009+HCC2010+HCC2011)/3; 
age=(age2009+age2010+age2011)/3;
PayRate=(PayRate2009+PayRate2010+PayRate2011)/3; 
time=3;year=3;output;

&dvar.=&dvar.2012-&dvar.2011;  map=(map2011-map2010)/10;  
PCP=(PrimaryCare2010+PrimaryCare2011+PrimaryCare2012)/3;
Specialty=(Specialty2010+Specialty2011+Specialty2012)/3;
hospbd=(hospbd2010+hospbd2011+hospbd2012)/3;
pov=(pov2010+pov2011+pov2012)/3; 
MHI=(MHI2010+MHI2011+MHI2012)/3;
blackpct=(blackpct2010+blackpct2011+blackpct2012)/3;
hisppct=(hisppct2010+hisppct2011+hisppct2012)/3;
otherpct=(otherpct2010+otherpct2011+otherpct2012)/3;
HCC=(HCC2010+HCC2011+HCC2012)/3; 
age=(age2010+age2011+age2012)/3;
PayRate=(PayRate2010+PayRate2011+PayRate2012)/3; 
time=4;year=4;output;

&dvar.=&dvar.2013-&dvar.2012;  map=(map2012-map2011)/10;  
PCP=(PrimaryCare2011+PrimaryCare2012+PrimaryCare2013)/3;
Specialty=(Specialty2011+Specialty2012+Specialty2013)/3;
hospbd=(hospbd2011+hospbd2012+hospbd2013)/3;
pov=(pov2011+pov2012+pov2013)/3; 
MHI=(MHI2011+MHI2012+MHI2013)/3;
blackpct=(blackpct2011+blackpct2012+blackpct2013)/3;
hisppct=(hisppct2011+hisppct2012+hisppct2013)/3;
otherpct=(otherpct2011+otherpct2012+otherpct2013)/3;
HCC=(HCC2011+HCC2012+HCC2013)/3; 
age=(age2011+age2012+age2013)/3;
PayRate=(PayRate2011+PayRate2012+PayRate2013)/3; 
time=5;year=5;output;

&dvar.=&dvar.2014-&dvar.2013;  map=(map2013-map2012)/10;  
PCP=(PrimaryCare2012+PrimaryCare2013+PrimaryCare2014)/3;
Specialty=(Specialty2012+Specialty2013+Specialty2014)/3;
hospbd=(hospbd2012+hospbd2013+hospbd2014)/3;
pov=(pov2012+pov2013+pov2014)/3; 
MHI=(MHI2012+MHI2013+MHI2014)/3;
blackpct=(blackpct2012+blackpct2013+blackpct2014)/3;
hisppct=(hisppct2012+hisppct2013+hisppct2014)/3;
otherpct=(otherpct2012+otherpct2013+otherpct2014)/3;
HCC=(HCC2012+HCC2013+HCC2014)/3; 
age=(age2012+age2013+age2014)/3;
PayRate=(PayRate2012+PayRate2013+PayRate2014)/3; 
time=6;year=6;output;
run;

*Un-adjusted;
proc mixed data=ldata empirical  ;
	class fips ;  
	model &dvar.=  map year /solution cl;
	random intercept  /subject=fips type=un s;
	ods output solutionF=unadj;
run;
*Adjusted only for market characteristics (hospital beds, primary care doctors, specialists);
proc mixed data=ldata empirical  ;
	class fips ;   
	model &dvar.=  map year PCP specialty hospbd /solution cl;
	random intercept  /subject=fips  type=un s;
	ods output solutionF=market;
run;
*Adjusted for demographics (% below federal poverty line, median household income, percent black, percent Hispanic, other percent, HCC, population, FFS, age);
proc mixed data=ldata empirical ;
	class fips ;  
	model &dvar.=  map year hcc pov mhi blackpct hisppct otherpct age payrate /solution cl;
	random intercept  /subject=fips  type=un s;
	ods output solutionF=demog;
run;
* Fully adjusted;
proc mixed data=ldata empirical ;
	class fips ;  
	model &dvar.=  map year PCP  specialty hospbd hcc pov mhi blackpct hisppct otherpct age payrate /solution cl;
	random intercept   /subject=fips  type=un s;
	ods output solutionF=full;
run;

data Unadj;
	length model $80.;
	set Unadj;
	model='Unadjusted';drop DF tValue Alpha  ;
run;
data market;
	length model $80.;
	set market;
	model='Adjusted only for market characteristics';drop DF tValue Alpha ;
run;
data demog;
	length model $80.;
	set demog;
	model='Adjusted for demographics';drop DF tValue Alpha  ;
run;
data full;
	length model $80.;
	set full;
	model='Fully adjusted';drop DF tValue Alpha  ;
run;

data all&dvar.;
length outcome $30.;
set Unadj market demog full;
outcome="&dvar.";
where effect='map';
proc print;
run;
 
%mend model1Yr;
%model1Yr(dvar=cost);
%model1Yr(dvar=ip_cost);
%model1Yr(dvar=pac_ltch_cost);
%model1Yr(dvar=pac_irf_cost);
%model1Yr(dvar=pac_snf_cost); 
%model1Yr(dvar=pac_hh_cost);
%model1Yr(dvar=Hospice_cost);
%model1Yr(dvar=op_cost);
%model1Yr(dvar=FQHC_RHC_cost); 
%model1Yr(dvar=Outpatient_Dialysis_cost);
%model1Yr(dvar=ASC_cost);
%model1Yr(dvar=EM_cost);
%model1Yr(dvar=Procedures_cost); 
%model1Yr(dvar=Imaging_cost);
%model1Yr(dvar=DME_cost);
%model1Yr(dvar=Tests_cost);
%model1Yr(dvar=PartB_Drugs_cost);
%model1Yr(dvar=Ambulance_cost);

%model1Yr(dvar=IP_day);
%model1Yr(dvar=pac_ltch_day);
%model1Yr(dvar=pac_irf_day); 
%model1Yr(dvar=pac_snf_day);
%model1Yr(dvar=pac_hh_visit);
%model1Yr(dvar=Hospice_day);
%model1Yr(dvar=OP_Visit);
%model1Yr(dvar=FQHC_RHC_Visit);
%model1Yr(dvar=Outpatient_Dialysis_Event);
%model1Yr(dvar=ASC_Event); 
%model1Yr(dvar=EM_Event);
%model1Yr(dvar=Procedure_Event);
%model1Yr(dvar=Imaging_Event);
%model1Yr(dvar=DME_Event);
%model1Yr(dvar=Test_Event);
%model1Yr(dvar=Ambulance_Event);
%model1Yr(dvar=ED_Visit);

%model1Yr(dvar=readm);

 
data all;
set allcost allip_cost allpac_ltch_cost allpac_irf_cost allpac_snf_cost allpac_hh_cost allHospice_cost allop_cost allFQHC_RHC_cost 
allOutpatient_Dialysis_cost allASC_cost allEM_cost allProcedures_cost allImaging_cost allDME_cost allTests_cost allPartB_Drugs_cost 
allAmbulance_cost allIP_day allpac_ltch_day allpac_irf_day allpac_snf_day allpac_hh_visit allHospice_day allOP_Visit allFQHC_RHC_Visit 
allOutpatient_Dialysis_Event allASC_Event allEM_Event allProcedure_Event allImaging_Event allDME_Event allTest_Event allAmbulance_Event 
allED_Visit allreadm;
 proc print;
	run;

	proc contents data=data;run;

*********************************************
Model 3: 2-Year Lag 
********************************************;

%macro model2yr(dvar);
data ldata;
set  data;
 
if map2007rank=4;
&dvar.=&dvar.2011-&dvar.2009;  map=(map2009-map2007)/10;  
PCP=(PrimaryCare2007+PrimaryCare2008+PrimaryCare2009+PrimaryCare2010+PrimaryCare2011)/5;
Specialty=(Specialty2007+Specialty2008+Specialty2009+Specialty2010+Specialty2011)/5;
hospbd=(hospbd2007+hospbd2008+hospbd2009+hospbd2010+hospbd2011)/5;
pov=(pov2007+pov2008+pov2009+pov2010+pov2011)/5; 
MHI=(MHI2007+MHI2008+MHI2009+MHI2010+MHI2011)/5;
blackpct=(blackpct2007+blackpct2008+blackpct2009+blackpct2010+blackpct2011)/5;
hisppct=(hisppct2007+hisppct2008+hisppct2009+hisppct2010+hisppct2011)/3;
otherpct=(otherpct2007+otherpct2008+otherpct2009+otherpct2010+otherpct2011)/5;
HCC=(HCC2007+HCC2008+HCC2009+HCC2010+HCC2011)/5; 
age=(age2007+age2008+age2009+age2010+age2011)/5;
PayRate=(PayRate2007+PayRate2008+PayRate2009+PayRate2010+PayRate2011)/5; 
FFS=(ffs2007+ffs2008+ffs2009+ffs2010+ffs2011)/5;
HMO=(hmo_penetration_07+hmo_penetration_08+hmo_penetration_09+hmo_penetration_10+hmo_penetration_11)/5;
*hmo=(hmo_penetration_09-hmo_penetration_07)/10; 
time=1;year=1;output;

&dvar.=&dvar.2012-&dvar.2010;  map=(map2010-map2008)/10;  
PCP=(PrimaryCare2008+PrimaryCare2009+PrimaryCare2010+PrimaryCare2011+PrimaryCare2012)/5;
Specialty=(Specialty2008+Specialty2009+Specialty2010+Specialty2011+Specialty2012)/5;
hospbd=(hospbd2008+hospbd2009+hospbd2010+hospbd2011+hospbd2012)/5;
pov=(pov2008+pov2009+pov2010+pov2011+pov2012)/5; 
MHI=(MHI2008+MHI2009+MHI2010+MHI2011+MHI2012)/5;
blackpct=(blackpct2008+blackpct2009+blackpct2010+blackpct2011+blackpct2012)/5;
hisppct=(hisppct2008+hisppct2009+hisppct2010+hisppct2011+hisppct2012)/3;
otherpct=(otherpct2008+otherpct2009+otherpct2010+otherpct2011+otherpct2012)/5;
HCC=(HCC2008+HCC2009+HCC2010+HCC2011+HCC2012)/5; 
age=(age2008+age2009+age2010+age2011+age2012)/5;
PayRate=(PayRate2008+PayRate2009+PayRate2010+PayRate2011+PayRate2012)/5; 
FFS=(ffs2008+ffs2009+ffs2010+ffs2011+ffs2012)/5;
HMO=(hmo_penetration_08+hmo_penetration_09+hmo_penetration_10+hmo_penetration_11+hmo_penetration_12)/5;
*hmo=(hmo_penetration_10-hmo_penetration_08)/10; 
time=2;year=2;output;
 
&dvar.=&dvar.2013-&dvar.2011;  map=(map2011-map2009)/10;  
PCP=(PrimaryCare2009+PrimaryCare2010+PrimaryCare2011+PrimaryCare2012+PrimaryCare2013)/5;
Specialty=(Specialty2009+Specialty2010+Specialty2011+Specialty2012+Specialty2013)/5;
hospbd=(hospbd2009+hospbd2010+hospbd2011+hospbd2012+hospbd2013)/5;
pov=(pov2009+pov2010+pov2011+pov2012+pov2013)/5; 
MHI=(MHI2009+MHI2010+MHI2011+MHI2012+MHI2013)/5;
blackpct=(blackpct2009+blackpct2010+blackpct2011+blackpct2012+blackpct2013)/5;
hisppct=(hisppct2009+hisppct2010+hisppct2011+hisppct2012+hisppct2013)/3;
otherpct=(otherpct2009+otherpct2010+otherpct2011+otherpct2012+otherpct2013)/5;
HCC=(HCC2009+HCC2010+HCC2011+HCC2012+HCC2013)/5; 
age=(age2009+age2010+age2011+age2012+age2013)/5;
PayRate=(PayRate2009+PayRate2010+PayRate2011+PayRate2012+PayRate2013)/5;
FFS=(ffs2009+ffs2010+ffs2011+ffs2012+ffs2013)/5; 
HMO=(hmo_penetration_09+hmo_penetration_10+hmo_penetration_11+hmo_penetration_12+hmo_penetration_13)/5;
*hmo=(hmo_penetration_11-hmo_penetration_09)/10; 
time=3;year=3;output;

&dvar.=&dvar.2014-&dvar.2012;  map=(map2012-map2010)/10;  
PCP=(PrimaryCare2010+PrimaryCare2011+PrimaryCare2012+PrimaryCare2013+PrimaryCare2014)/5;
Specialty=(Specialty2010+Specialty2011+Specialty2012+Specialty2013+Specialty2014)/5;
hospbd=(hospbd2010+hospbd2011+hospbd2012+hospbd2013+hospbd2014)/5;
pov=(pov2010+pov2011+pov2012+pov2013+pov2014)/5; 
MHI=(MHI2010+MHI2011+MHI2012+MHI2013+MHI2014)/5;
blackpct=(blackpct2010+blackpct2011+blackpct2012+blackpct2013+blackpct2014)/5;
hisppct=(hisppct2010+hisppct2011+hisppct2012+hisppct2013+hisppct2014)/3;
otherpct=(otherpct2010+otherpct2011+otherpct2012+otherpct2013+otherpct2014)/5;
HCC=(HCC2010+HCC2011+HCC2012+HCC2013+HCC2014)/5; 
age=(age2010+age2011+age2012+age2013+age2014)/5;
PayRate=(PayRate2010+PayRate2011+PayRate2012+PayRate2013+PayRate2014)/5; 
FFS=(ffs2010+ffs2011+ffs2012+ffs2013+ffs2014)/5; 
HMO=(hmo_penetration_10+hmo_penetration_11+hmo_penetration_12+hmo_penetration_13+hmo_penetration_14)/5;
*hmo=(hmo_penetration_12-hmo_penetration_10)/10; 
time=4;year=4;output;
 
run;

*Un-adjusted;
proc mixed data=ldata empirical  ;
	class fips stateflag;  
	model &dvar.=  map map2007 year  /solution cl;
	random intercept  /subject=fips type=un s;
	ods output solutionF=unadj;
run;
*Adjusted only for market characteristics (hospital beds, primary care doctors, specialists);
proc mixed data=ldata empirical  ;
	class fips stateflag;  
	model &dvar.=  map map2007 year PCP specialty hospbd  /solution cl;
	random intercept  /subject=fips  type=un s;
	ods output solutionF=market;
run;
*Adjusted for demographics (% below federal poverty line, median household income, percent black, percent Hispanic, other percent, HCC, population, FFS, age);
proc mixed data=ldata empirical ;
	class fips stateflag;  
	model &dvar.=  map map2007 year hcc pov mhi blackpct hisppct otherpct age payrate  /solution cl;
	random intercept  /subject=fips  type=un s;
	ods output solutionF=demog;
run;
* Fully adjusted;
proc mixed data=ldata empirical ;
	class fips stateflag;   
	model &dvar.=  map map2007 year PCP  specialty hospbd hcc pov mhi blackpct hisppct otherpct age payrate  /solution cl;
	random intercept   /subject=fips  type=un s;
	ods output solutionF=full;
run;

data Unadj;
	length model $80.;
	set Unadj;
	model='Unadjusted';drop DF tValue Alpha  ;
run;
data market;
	length model $80.;
	set market;
	model='Adjusted only for market characteristics';drop DF tValue Alpha ;
run;
data demog;
	length model $80.;
	set demog;
	model='Adjusted for demographics';drop DF tValue Alpha  ;
run;
data full;
	length model $80.;
	set full;
	model='Fully adjusted';drop DF tValue Alpha  ;
run;

data all&dvar.;
length outcome $30.;
set Unadj market demog full;
outcome="&dvar.";
where effect='map';
proc print;
run;
 
%mend model2Yr;
%model2Yr(dvar=cost);
%model2Yr(dvar=ip_cost);
%model2Yr(dvar=pac_ltch_cost);
%model2Yr(dvar=pac_irf_cost);
%model2Yr(dvar=pac_snf_cost); 
%model2Yr(dvar=pac_hh_cost);
%model2Yr(dvar=Hospice_cost);
%model2Yr(dvar=op_cost);
%model2Yr(dvar=FQHC_RHC_cost); 
%model2Yr(dvar=Outpatient_Dialysis_cost);
%model2Yr(dvar=ASC_cost);
%model2Yr(dvar=EM_cost);
%model2Yr(dvar=Procedures_cost); 
%model2Yr(dvar=Imaging_cost);
%model2Yr(dvar=DME_cost);
%model2Yr(dvar=Tests_cost);
%model2Yr(dvar=PartB_Drugs_cost);
%model2Yr(dvar=Ambulance_cost);

%model2Yr(dvar=IP_day);
%model2Yr(dvar=pac_ltch_day);
%model2Yr(dvar=pac_irf_day); 
%model2Yr(dvar=pac_snf_day);
%model2Yr(dvar=pac_hh_visit);
%model2Yr(dvar=Hospice_day);
%model2Yr(dvar=OP_Visit);
%model2Yr(dvar=FQHC_RHC_Visit);
%model2Yr(dvar=Outpatient_Dialysis_Event);
%model2Yr(dvar=ASC_Event); 
%model2Yr(dvar=EM_Event);
%model2Yr(dvar=Procedure_Event);
%model2Yr(dvar=Imaging_Event);
%model2Yr(dvar=DME_Event);
%model2Yr(dvar=Test_Event);
%model2Yr(dvar=Ambulance_Event);
%model2Yr(dvar=ED_Visit);

%model2Yr(dvar=readm);
data all;
set allcost allip_cost allpac_ltch_cost allpac_irf_cost allpac_snf_cost allpac_hh_cost allHospice_cost allop_cost allFQHC_RHC_cost 
allOutpatient_Dialysis_cost allASC_cost allEM_cost allProcedures_cost allImaging_cost allDME_cost allTests_cost allPartB_Drugs_cost 
allAmbulance_cost allIP_day allpac_ltch_day allpac_irf_day allpac_snf_day allpac_hh_visit allHospice_day allOP_Visit allFQHC_RHC_Visit 
allOutpatient_Dialysis_Event allASC_Event allEM_Event allProcedure_Event allImaging_Event allDME_Event allTest_Event allAmbulance_Event 
allED_Visit allreadm;
 proc print;
	run;











 	
**********************************************************************************
Model 4 : State Fixed Effect Model
**********************************************************************************;
%macro Fixed1(dvar);


data ldata;
set data;
&dvar.=&dvar.2007;map=map2007/10;Year=2007;HCC=HCC2007;PCP=PrimaryCare2007;specialty=specialty2007;hospbd=hospbd2007;pov=pov2007;mhi=mhi2007;blackpct=blackpct2007;hisppct=hisppct2007;otherpct=otherpct2007;hcc=hcc2007; age=age2007;payrate=payrate2007; ffs=ffs2007;output;
&dvar.=&dvar.2008;map=map2008/10;Year=2008;HCC=HCC2008;PCP=PrimaryCare2008;specialty=specialty2008;hospbd=hospbd2008;pov=pov2008;mhi=mhi2008;blackpct=blackpct2008;hisppct=hisppct2008;otherpct=otherpct2008;hcc=hcc2008; age=age2008;payrate=payrate2008; ffs=ffs2008;output;
&dvar.=&dvar.2009;map=map2009/10;Year=2009;HCC=HCC2009;PCP=PrimaryCare2009;specialty=specialty2009;hospbd=hospbd2009;pov=pov2009;mhi=mhi2009;blackpct=blackpct2009;hisppct=hisppct2009;otherpct=otherpct2009;hcc=hcc2009; age=age2009;payrate=payrate2009; ffs=ffs2009;output;
&dvar.=&dvar.2010;map=map2010/10;Year=2010;HCC=HCC2010;PCP=PrimaryCare2010;specialty=specialty2010;hospbd=hospbd2010;pov=pov2010;mhi=mhi2010;blackpct=blackpct2010;hisppct=hisppct2010;otherpct=otherpct2010;hcc=hcc2010; age=age2010;payrate=payrate2010; ffs=ffs2010;output;
&dvar.=&dvar.2011;map=map2011/10;Year=2011;HCC=HCC2011;PCP=PrimaryCare2011;specialty=specialty2011;hospbd=hospbd2011;pov=pov2011;mhi=mhi2011;blackpct=blackpct2011;hisppct=hisppct2011;otherpct=otherpct2011;hcc=hcc2011; age=age2011;payrate=payrate2011; ffs=ffs2011;output;
&dvar.=&dvar.2012;map=map2012/10;Year=2012;HCC=HCC2012;PCP=PrimaryCare2012;specialty=specialty2012;hospbd=hospbd2012;pov=pov2012;mhi=mhi2012;blackpct=blackpct2012;hisppct=hisppct2012;otherpct=otherpct2012;hcc=hcc2012; age=age2012;payrate=payrate2012; ffs=ffs2012;output;
&dvar.=&dvar.2013;map=map2013/10;Year=2013;HCC=HCC2013;PCP=PrimaryCare2013;specialty=specialty2013;hospbd=hospbd2013;pov=pov2013;mhi=mhi2013;blackpct=blackpct2013;hisppct=hisppct2013;otherpct=otherpct2013;hcc=hcc2013; age=age2013;payrate=payrate2013; ffs=ffs2013;output;
&dvar.=&dvar.2014;map=map2014/10;Year=2014;HCC=HCC2014;PCP=PrimaryCare2014;specialty=specialty2014;hospbd=hospbd2014;pov=pov2014;mhi=mhi2014;blackpct=blackpct2014;hisppct=hisppct2014;otherpct=otherpct2014;hcc=hcc2014; age=age2014;payrate=payrate2014; ffs=ffs2014;output;
keep fips stateflag &dvar. map  map2007 Year PCP  specialty hospbd pov mhi blackpct hisppct otherpct hcc age payrate ffs;
run;
 


*Un-adjusted;
proc genmod data=ldata;
class stateflag fips;
model &dvar.=map year fips/dist=normal cl;
ods output ParameterEstimates=unadj;
run;
*Adjusted only for market characteristics (hospital beds, primary care doctors, specialists);
proc genmod data=ldata;
class stateflag fips;
model &dvar.=map year PCP specialty hospbd fips/dist=normal cl;
ods output ParameterEstimates=market;
run;
*Adjusted for demographics (% below federal poverty line, median household income, percent black, percent Hispanic, other percent, HCC, population, FFS, age);
proc genmod data=ldata;
class stateflag fips;
model &dvar.=map year hcc pov mhi blackpct hisppct otherpct age payrate fips/dist=normal cl;
ods output ParameterEstimates=demog;
run;
* Fully adjusted;
proc genmod data=ldata;
class stateflag fips;
model &dvar.=map year PCP  specialty hospbd hcc pov mhi blackpct hisppct otherpct age payrate fips/dist=normal cl;
ods output ParameterEstimates=full;
run;

data Unadj;
	length model $80.;
	set Unadj;
	model='Unadjusted';drop level1  ;
run;
data market;
	length model $80.;
	set market;
	model='Adjusted only for market characteristics';drop level1  ;
run;
data demog;
	length model $80.;
	set demog;
	model='Adjusted for demographics';drop level1  ;
run;
data full;
	length model $80.;
	set full;
	model='Fully adjusted';drop level1  ;
run;

data all&dvar.;
length outcome $30.;
set Unadj market demog full;
outcome="&dvar.";
where parameter='map';
proc print;
run;
 
%mend Fixed1;
%Fixed1(dvar=cost);
%Fixed1(dvar=ip_cost);
%Fixed1(dvar=pac_ltch_cost);
%Fixed1(dvar=pac_irf_cost);
%Fixed1(dvar=pac_snf_cost); 
%Fixed1(dvar=pac_hh_cost);
%Fixed1(dvar=Hospice_cost);
%Fixed1(dvar=op_cost);
%Fixed1(dvar=FQHC_RHC_cost); 
%Fixed1(dvar=Outpatient_Dialysis_cost);
%Fixed1(dvar=ASC_cost);
%Fixed1(dvar=EM_cost);
%Fixed1(dvar=Procedures_cost); 
%Fixed1(dvar=Imaging_cost);
%Fixed1(dvar=DME_cost);
%Fixed1(dvar=Tests_cost);
%Fixed1(dvar=PartB_Drugs_cost);
%Fixed1(dvar=Ambulance_cost);

%Fixed1(dvar=IP_day);
%Fixed1(dvar=pac_ltch_day);
%Fixed1(dvar=pac_irf_day); 
%Fixed1(dvar=pac_snf_day);
%Fixed1(dvar=pac_hh_visit);
%Fixed1(dvar=Hospice_day);
%Fixed1(dvar=OP_Visit);
%Fixed1(dvar=FQHC_RHC_Visit);
%Fixed1(dvar=Outpatient_Dialysis_Event);
%Fixed1(dvar=ASC_Event); 
%Fixed1(dvar=EM_Event);
%Fixed1(dvar=Procedure_Event);
%Fixed1(dvar=Imaging_Event);
%Fixed1(dvar=DME_Event);
%Fixed1(dvar=Test_Event);
%Fixed1(dvar=Ambulance_Event);
%Fixed1(dvar=ED_Visit);

%Fixed1(dvar=readm);
 
data all;
set allcost allip_cost allpac_ltch_cost allpac_irf_cost allpac_snf_cost allpac_hh_cost allHospice_cost allop_cost allFQHC_RHC_cost 
allOutpatient_Dialysis_cost allASC_cost allEM_cost allProcedures_cost allImaging_cost allDME_cost allTests_cost allPartB_Drugs_cost 
allAmbulance_cost allIP_day allpac_ltch_day allpac_irf_day allpac_snf_day allpac_hh_visit allHospice_day allOP_Visit allFQHC_RHC_Visit 
allOutpatient_Dialysis_Event allASC_Event allEM_Event allProcedure_Event allImaging_Event allDME_Event allTest_Event allAmbulance_Event 
allED_Visit allreadm;
 proc print;
	run;

*********************************************
Model 5: State Fixed 2-Year Lag 
********************************************;

%macro Fixed2yr(dvar);
data ldata;
set  data;
*if Map2007rank=4;
&dvar.=&dvar.2011-&dvar.2009;  map=(map2009-map2007)/10;  
PCP=(PrimaryCare2007+PrimaryCare2008+PrimaryCare2009+PrimaryCare2010+PrimaryCare2011)/5;
Specialty=(Specialty2007+Specialty2008+Specialty2009+Specialty2010+Specialty2011)/5;
hospbd=(hospbd2007+hospbd2008+hospbd2009+hospbd2010+hospbd2011)/5;
pov=(pov2007+pov2008+pov2009+pov2010+pov2011)/5; 
MHI=(MHI2007+MHI2008+MHI2009+MHI2010+MHI2011)/5;
blackpct=(blackpct2007+blackpct2008+blackpct2009+blackpct2010+blackpct2011)/5;
hisppct=(hisppct2007+hisppct2008+hisppct2009+hisppct2010+hisppct2011)/3;
otherpct=(otherpct2007+otherpct2008+otherpct2009+otherpct2010+otherpct2011)/5;
HCC=(HCC2007+HCC2008+HCC2009+HCC2010+HCC2011)/5; 
age=(age2007+age2008+age2009+age2010+age2011)/5;
PayRate=(PayRate2007+PayRate2008+PayRate2009+PayRate2010+PayRate2011)/5; 
FFS=(ffs2007+ffs2008+ffs2009+ffs2010+ffs2011)/5;
hmo=(hmo_penetration_09-hmo_penetration_07)/10; 
time=1;year=1;output;

&dvar.=&dvar.2012-&dvar.2010;  map=(map2010-map2008)/10;  
PCP=(PrimaryCare2008+PrimaryCare2009+PrimaryCare2010+PrimaryCare2011+PrimaryCare2012)/5;
Specialty=(Specialty2008+Specialty2009+Specialty2010+Specialty2011+Specialty2012)/5;
hospbd=(hospbd2008+hospbd2009+hospbd2010+hospbd2011+hospbd2012)/5;
pov=(pov2008+pov2009+pov2010+pov2011+pov2012)/5; 
MHI=(MHI2008+MHI2009+MHI2010+MHI2011+MHI2012)/5;
blackpct=(blackpct2008+blackpct2009+blackpct2010+blackpct2011+blackpct2012)/5;
hisppct=(hisppct2008+hisppct2009+hisppct2010+hisppct2011+hisppct2012)/3;
otherpct=(otherpct2008+otherpct2009+otherpct2010+otherpct2011+otherpct2012)/5;
HCC=(HCC2008+HCC2009+HCC2010+HCC2011+HCC2012)/5; 
age=(age2008+age2009+age2010+age2011+age2012)/5;
PayRate=(PayRate2008+PayRate2009+PayRate2010+PayRate2011+PayRate2012)/5; 
FFS=(ffs2008+ffs2009+ffs2010+ffs2011+ffs2012)/5;
hmo=(hmo_penetration_10-hmo_penetration_08)/10; 
time=2;year=2;output;
 
&dvar.=&dvar.2013-&dvar.2011;  map=(map2011-map2009)/10;  
PCP=(PrimaryCare2009+PrimaryCare2010+PrimaryCare2011+PrimaryCare2012+PrimaryCare2013)/5;
Specialty=(Specialty2009+Specialty2010+Specialty2011+Specialty2012+Specialty2013)/5;
hospbd=(hospbd2009+hospbd2010+hospbd2011+hospbd2012+hospbd2013)/5;
pov=(pov2009+pov2010+pov2011+pov2012+pov2013)/5; 
MHI=(MHI2009+MHI2010+MHI2011+MHI2012+MHI2013)/5;
blackpct=(blackpct2009+blackpct2010+blackpct2011+blackpct2012+blackpct2013)/5;
hisppct=(hisppct2009+hisppct2010+hisppct2011+hisppct2012+hisppct2013)/3;
otherpct=(otherpct2009+otherpct2010+otherpct2011+otherpct2012+otherpct2013)/5;
HCC=(HCC2009+HCC2010+HCC2011+HCC2012+HCC2013)/5; 
age=(age2009+age2010+age2011+age2012+age2013)/5;
PayRate=(PayRate2009+PayRate2010+PayRate2011+PayRate2012+PayRate2013)/5;
FFS=(ffs2009+ffs2010+ffs2011+ffs2012+ffs2013)/5; 
hmo=(hmo_penetration_11-hmo_penetration_09)/10; 
time=3;year=3;output;

&dvar.=&dvar.2014-&dvar.2012;  map=(map2012-map2010)/10;  
PCP=(PrimaryCare2010+PrimaryCare2011+PrimaryCare2012+PrimaryCare2013+PrimaryCare2014)/5;
Specialty=(Specialty2010+Specialty2011+Specialty2012+Specialty2013+Specialty2014)/5;
hospbd=(hospbd2010+hospbd2011+hospbd2012+hospbd2013+hospbd2014)/5;
pov=(pov2010+pov2011+pov2012+pov2013+pov2014)/5; 
MHI=(MHI2010+MHI2011+MHI2012+MHI2013+MHI2014)/5;
blackpct=(blackpct2010+blackpct2011+blackpct2012+blackpct2013+blackpct2014)/5;
hisppct=(hisppct2010+hisppct2011+hisppct2012+hisppct2013+hisppct2014)/3;
otherpct=(otherpct2010+otherpct2011+otherpct2012+otherpct2013+otherpct2014)/5;
HCC=(HCC2010+HCC2011+HCC2012+HCC2013+HCC2014)/5; 
age=(age2010+age2011+age2012+age2013+age2014)/5;
PayRate=(PayRate2010+PayRate2011+PayRate2012+PayRate2013+PayRate2014)/5; 
FFS=(ffs2010+ffs2011+ffs2012+ffs2013+ffs2014)/5; 
hmo=(hmo_penetration_12-hmo_penetration_10)/10; 
time=4;year=4;output;
 
run;


*Un-adjusted;
proc genmod data=ldata;
class stateflag fips;
model &dvar.=map year  fips/dist=normal cl;
ods output ParameterEstimates=unadj;
run;
*Adjusted only for market characteristics (hospital beds, primary care doctors, specialists);
proc genmod data=ldata;
class stateflag fips;
model &dvar.=map year PCP specialty hospbd hmo fips/dist=normal cl;
ods output ParameterEstimates=market;
run;
*Adjusted for demographics (% below federal poverty line, median household income, percent black, percent Hispanic, other percent, HCC, population, FFS, age);
proc genmod data=ldata;
class stateflag fips;
model &dvar.=map year hcc pov mhi blackpct hisppct otherpct age payrate fips/dist=normal cl;
ods output ParameterEstimates=demog;
run;
* Fully adjusted;
proc genmod data=ldata;
class stateflag fips;
model &dvar.=map year PCP  specialty hospbd hcc pov mhi blackpct hisppct otherpct age payrate hmo fips/dist=normal cl;
ods output ParameterEstimates=full;
run;

data Unadj;
	length model $80.;
	set Unadj;
	model='Unadjusted';drop level1  ;
run;
data market;
	length model $80.;
	set market;
	model='Adjusted only for market characteristics';drop level1  ;
run;
data demog;
	length model $80.;
	set demog;
	model='Adjusted for demographics';drop level1  ;
run;
data full;
	length model $80.;
	set full;
	model='Fully adjusted';drop level1  ;
run;

data all&dvar.;
length outcome $30.;
set Unadj market demog full;
outcome="&dvar.";
where parameter='map';
proc print;
run;
 
%mend Fixed2Yr;
%Fixed2Yr(dvar=cost);
%Fixed2Yr(dvar=ip_cost);
%Fixed2Yr(dvar=pac_ltch_cost);
%Fixed2Yr(dvar=pac_irf_cost);
%Fixed2Yr(dvar=pac_snf_cost); 
%Fixed2Yr(dvar=pac_hh_cost);
%Fixed2Yr(dvar=Hospice_cost);
%Fixed2Yr(dvar=op_cost);
%Fixed2Yr(dvar=FQHC_RHC_cost); 
%Fixed2Yr(dvar=Outpatient_Dialysis_cost);
%Fixed2Yr(dvar=ASC_cost);
%Fixed2Yr(dvar=EM_cost);
%Fixed2Yr(dvar=Procedures_cost); 
%Fixed2Yr(dvar=Imaging_cost);
%Fixed2Yr(dvar=DME_cost);
%Fixed2Yr(dvar=Tests_cost);
%Fixed2Yr(dvar=PartB_Drugs_cost);
%Fixed2Yr(dvar=Ambulance_cost);

%Fixed2Yr(dvar=IP_day);
%Fixed2Yr(dvar=pac_ltch_day);
%Fixed2Yr(dvar=pac_irf_day); 
%Fixed2Yr(dvar=pac_snf_day);
%Fixed2Yr(dvar=pac_hh_visit);
%Fixed2Yr(dvar=Hospice_day);
%Fixed2Yr(dvar=OP_Visit);
%Fixed2Yr(dvar=FQHC_RHC_Visit);
%Fixed2Yr(dvar=Outpatient_Dialysis_Event);
%Fixed2Yr(dvar=ASC_Event); 
%Fixed2Yr(dvar=EM_Event);
%Fixed2Yr(dvar=Procedure_Event);
%Fixed2Yr(dvar=Imaging_Event);
%Fixed2Yr(dvar=DME_Event);
%Fixed2Yr(dvar=Test_Event);
%Fixed2Yr(dvar=Ambulance_Event);
%Fixed2Yr(dvar=ED_Visit);

%Fixed2Yr(dvar=readm);
data all;
set allcost allip_cost allpac_ltch_cost allpac_irf_cost allpac_snf_cost allpac_hh_cost allHospice_cost allop_cost allFQHC_RHC_cost 
allOutpatient_Dialysis_cost allASC_cost allEM_cost allProcedures_cost allImaging_cost allDME_cost allTests_cost allPartB_Drugs_cost 
allAmbulance_cost allIP_day allpac_ltch_day allpac_irf_day allpac_snf_day allpac_hh_visit allHospice_day allOP_Visit allFQHC_RHC_Visit 
allOutpatient_Dialysis_Event allASC_Event allEM_Event allProcedure_Event allImaging_Event allDME_Event allTest_Event allAmbulance_Event 
allED_Visit allreadm;
 proc print;
	run;



 
