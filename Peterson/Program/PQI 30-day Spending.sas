***************************************************
Preventable StdCost/Spending for Medicare FFS Beneficiaries
Xiner Zhou
7/7/2016
***************************************************;
libname PQI 'C:\data\Projects\Scorecard\data';
libname std 'C:\data\Data\Medicare\StdCost\Data';


 
* Post 30-day Acute Care and Post Acute Care Hospitalization Spending;
proc sql;
create table ip as
select a.bene_id, a.key, a.TAPQ90 as PQI, a.ADMSN_DT as PQIdate1, a.DSCHRGDT as PQIdate2, b.clm_id,
	   case when ('3025'<= substr(b.provider,3,4) <= '3099' or substr(b.provider,3,1) in ('R','T')) 
            then 'Inpatient Rehabilitation Facility(IRF)'
            when substr(b.provider,3,2) in ('00','01','02','03','04','05','06','07','08','09','13' )
            then  'Acute Care Hospital (include CAH)'
			when (substr(b.provider,3,2) in ('40','41','42','43','44') or substr(b.provider,3,1) in ('M','S'))
            then 'Inpatient Psychiatric Facility (IPF)'
			when substr(b.provider,3,2) in ('20','21','22')
            then 'Long-Term Care Hospital (LTCH)'	
        else 'Other inpatient'	
		end as Type,
		"IP" as clm,
    b.FROM_DT,b.THRU_DT, b.stdcost,b.actual 

    from pqi.Pqi_medpar2012v45 a 
     left join 
    (select  bene_id, clm_id, FROM_DT, THRU_DT, provider, stdcost, actual from std.Ipclmsstdcost2012 
                                   outer union corr
     select bene_id, clm_id, FROM_DT, THRU_DT, provider, stdcost, actual from std.Ipclmsstdcost2013) b

on a.bene_id=b.bene_id
where a.TAPQ90=1 and a.ADMSN_DT<=b.FROM_DT and a.DSCHRGDT+30>=b.FROM_DT ;
quit;

proc sort data=ip ;by bene_id clm_id descending PQIdate2;run;
proc sort data=ip nodupkey;by bene_id  clm_id;run;
    
* Post 30-day Outpatient Hospital Spending;
proc sql;
create table op as
select a.bene_id, a.key,a.TAPQ90 as PQI, a.ADMSN_DT as PQIdate1,a.DSCHRGDT as PQIdate2, b.clm_id, 
	   case when  b.FAC_TYPE ='1'
            then  'Hospital Outpatient'
            when  b.FAC_TYPE ='2'
            then  'Skilled nursing facility (SNF)'
			when  b.FAC_TYPE ='3'
            then  'Home health agency (HHA)'
			when  b.FAC_TYPE ='7'
            then  'Clinic or hospital-based renal dialysis facility'
			when  b.FAC_TYPE ='8'
			then  'Special facility or ASC surgery'
		end as Type,
		"OP" as clm,
    b.FROM_DT,b.THRU_DT,b.stdcost,b.actual 

    from pqi.Pqi_medpar2012v45 a 
     left join 
    (select  bene_id, clm_id,FROM_DT, THRU_DT, FAC_TYPE, stdcost, actual from std.Opclmsstdcost2012
                                   outer union corr
     select bene_id, clm_id,FROM_DT, THRU_DT, FAC_TYPE, stdcost, actual from std.Opclmsstdcost2013) b

on a.bene_id=b.bene_id
where a.TAPQ90=1 and a.ADMSN_DT<=b.FROM_DT and a.DSCHRGDT+30>=b.FROM_DT ;
quit;

proc sort data=op ;by bene_id  clm_id descending PQIdate2;run;
proc sort data=op nodupkey;by bene_id  clm_id;run;












* Post 30-day Carrier Spending;
proc sql;
create table carrier as
select a.bene_id, a.key, a.TAPQ90 as PQI, a.ADMSN_DT as PQIdate1,a.DSCHRGDT as PQIdate2, 
       b.*, "Carrier" as clm
    from pqi.Pqi_medpar2012v45 a 
     left join 
    (select  bene_id,clm_id,LINE_NUM, FROM_DT, HCPCS_CD,THRU_DT,  stdcost, actual from std.Carrclmslinesstdcost2012
                                   outer union corr
     select bene_id,clm_id,LINE_NUM,  FROM_DT, HCPCS_CD,THRU_DT,  stdcost, actual from std.Carrclmslinesstdcost2013) b

on a.bene_id=b.bene_id
where a.TAPQ90=1 and a.ADMSN_DT<=b.FROM_DT and a.DSCHRGDT+30>=b.FROM_DT ;
quit;
proc sort data=carrier ;by bene_id clm_id LINE_NUM descending PQIdate2;run;
proc sort data=carrier  nodupkey;by bene_id  clm_id LINE_NUM;run;
 


* Post 30-day HHA Spending;
proc sql;
create table HHA as
select a.bene_id, a.key, a.TAPQ90 as PQI, a.ADMSN_DT as PQIdate1,a.DSCHRGDT as PQIdate2, 
	   b.Type,
       b.*, "HHA" as clm
    from pqi.Pqi_medpar2012v45 a 
     left join 
    (select  bene_id, clm_id,FROM_DT, THRU_DT, clm as Type, stdcost, actual from std.Hhaclmsstdcost2012
                                   outer union corr
     select bene_id, clm_id,FROM_DT, THRU_DT, clm as Type, stdcost, actual from std.Hhaclmsstdcost2013) b

on a.bene_id=b.bene_id
where a.TAPQ90=1 and a.ADMSN_DT<=b.FROM_DT and a.DSCHRGDT+30>=b.FROM_DT ;
quit;
proc sort data=hha ;by bene_id  clm_id descending PQIdate2;run;
proc sort data=hha nodupkey;by bene_id  clm_id;run;


* Post 30-day Hospice Spending;
proc sql;
create table hospice as
select a.bene_id, a.key, a.TAPQ90 as PQI, a.ADMSN_DT as PQIdate1,a.DSCHRGDT as PQIdate2, 
	   b.Type,
       b.*, "Hospice" as clm
    from pqi.Pqi_medpar2012v45 a 
     left join 
    (select  bene_id, clm_id,FROM_DT, THRU_DT, clm as Type, stdcost, actual from std.Hspclmsstdcost2012
                                   outer union corr
     select bene_id, clm_id,FROM_DT, THRU_DT, clm as Type, stdcost, actual from std.Hspclmsstdcost2013) b

on a.bene_id=b.bene_id
where a.TAPQ90=1 and a.ADMSN_DT<=b.FROM_DT and a.DSCHRGDT+30>=b.FROM_DT ;
quit;

proc sort data=hospice;by bene_id  clm_id descending PQIdate2;run;
proc sort data=hospice nodupkey;by bene_id  clm_id;run;
 


* Post 30-day SNF Spending;
proc sql;
create table SNF as
select a.bene_id, a.key, a.TAPQ90 as PQI, a.ADMSN_DT as PQIdate1,a.DSCHRGDT as PQIdate2, 
	   b.Type,
       b.*, "SNF" as clm
    from pqi.Pqi_medpar2012v45 a 
     left join 
    (select  bene_id, clm_id,FROM_DT, THRU_DT, clm as Type, stdcost, actual from std.Snfclmsstdcost2012
                                   outer union corr
     select bene_id, clm_id,FROM_DT, THRU_DT, clm as Type, stdcost, actual from std.Snfclmsstdcost2013) b

on a.bene_id=b.bene_id
where a.TAPQ90=1 and a.ADMSN_DT<=b.FROM_DT and a.DSCHRGDT+30>=b.FROM_DT ;
quit;
 proc sort data=SNF ;by bene_id  clm_id descending PQIdate2;run;
proc sort data=SNF nodupkey;by bene_id  clm_id;run;


* Post 30-day DME Spending;
proc sql;
create table DME as
select a.bene_id, a.key, a.TAPQ90 as PQI, a.ADMSN_DT as PQIdate1,a.DSCHRGDT as PQIdate2, 
	  "Durable Medical Equipment(DME)" as Type,
       b.*, "DME" as clm
    from pqi.Pqi_medpar2012v45 a 
     left join 
    (select  bene_id, clm_id,FROM_DT, THRU_DT,  stdcost, actual from std.Dmeclmsstdcost2012
                                   outer union corr
     select bene_id, clm_id,FROM_DT, THRU_DT,   stdcost, actual from std.Dmeclmsstdcost2013) b

on a.bene_id=b.bene_id
where a.TAPQ90=1 and a.ADMSN_DT<=b.FROM_DT and a.DSCHRGDT+30>=b.FROM_DT ;
quit;
 
 proc sort data=DME;by bene_id  clm_id descending PQIdate2;run;
proc sort data=DME nodupkey;by bene_id  clm_id;run;

data all;
length type $100. clm $20.;
set ip(in=in1) op(in=in2) carrier(in=in3) hha(in=in4) snf(in=in5) hospice(in=in6) dme(in=in7);
if in1=1 then clm="Inpatient";
else if in2=1 then clm="Outpatient";
else if in3=1 then clm="Carrier";
else if in4=1 then clm="HHA";
else if in5=1 then clm="SNF";
else if in6=1 then clm="Hospice";
else if in7=1 then clm="DME";
proc sort;by bene_id clm ;
run;

* bene level cost;
proc sort data=all;by bene_id;run;
proc sql;
create table bene as
select bene_id, sum(stdcost) as stdcost, sum(actual) as actual
from all
group by bene_id;
quit;
proc sort data=temp nodupkey;by bene_id;run;
 

* bene clm level;
proc sort data=all ;by bene_id clm;run;
proc sql;
create table all1 as
select bene_id, clm, sum(stdcost) as stdcost, sum(actual) as actual
from all
group by bene_id, clm;
quit;
proc sort data=all1 nodupkey;by bene_id  clm;run;
proc transpose data=all1 out=clmstdcost ;
by bene_id;
id  clm;
var stdcost  ;
run;
proc sort data=clmstdcost(drop=_name_);by bene_id;run;
proc transpose data=all1 out=clmActual;
by bene_id;
id clm;
var Actual;
run;
proc sort data=clmActual(drop=_name_);by bene_id;run;

data clmstdcost;set clmstdcost;
rename inpatient=stdcostinpatient;rename Outpatient=stdcostOutpatient;rename carrier=stdcostcarrier; rename hha=stdcosthha;rename hospice=stdcostHospice;rename SNF=stdcostSNF;rename dme=stdcostDME;
run;
data clmActual;set clmActual;
rename inpatient=Actualinpatient;rename Outpatient=ActualOutpatient;rename carrier=Actualcarrier; rename hha=Actualhha;rename hospice=ActualHospice;rename SNF=ActualSNF;rename dme=ActualDME;
run;
 
* level 3 type;
%macro level2(file=);
proc sort data=&file.(keep=bene_id stdcost actual type);by bene_id type;run;
proc sql;
create table &file.1 as
select bene_id,  type, sum(stdcost) as stdcost, sum(actual) as actual
from &file.
group by bene_id, type;
quit;
proc sort data=&file.1 nodupkey;by bene_id  type;run;
proc transpose data=&file.1 out=stdcost&file.2 prefix=&file.;
by bene_id;
id  type;
var stdcost;
run;
proc transpose data=&file.1 out=actual&file.2 prefix=&file.;
by bene_id;
id  type;
var actual;
run;
%mend level2;
%level2(file=ip);
%level2(file=carrier);

data Actualip2;
set Actualip2;
Actualip1=ipAcute_Care_Hospital__include_C;
Actualip2=ipLong_Term_Care_Hospital__LTCH_;
Actualip3=ipInpatient_Psychiatric_Facility;
Actualip4=ipInpatient_Rehabilitation_Facil;
Actualip5=ipOther_inpatient;
 
label Actualip1="Acute Care Hospital Spending";
label Actualip2="Long Term Care Hospital Spending (PAC)";
label Actualip3="Inpatient Psychiatric Facility Spending (PAC)";
label Actualip4="Inpatient_Rehabilitation_Facility Spending (PAC)";
label Actualip5="Other inpatient Spending";
keep bene_id Actualip1 Actualip2 Actualip3 Actualip4 Actualip5;
proc sort;by bene_id;
run;

data Stdcostip2;
set Stdcostip2;
Stdip1=ipAcute_Care_Hospital__include_C;
Stdip2=ipLong_Term_Care_Hospital__LTCH_;
Stdip3=ipInpatient_Psychiatric_Facility;
Stdip4=ipInpatient_Rehabilitation_Facil;
Stdip5=ipOther_inpatient;

 
label Stdip1="Acute Care Hospital Stdcost";
label Stdip2="Long Term Care Hospital Stdcost (PAC)";
label Stdip3="Inpatient Psychiatric Facility Stdcost (PAC)";
label Stdip4="Inpatient_Rehabilitation_Facility Stdcost (PAC)";
label Stdip5="Other inpatient Stdcost";
keep bene_id Stdip1 Stdip2 Stdip3 Stdip4 Stdip5;
proc sort;by bene_id;
run;


data ActualCarrier2;
set ActualCarrier2;
Actualcarrier1=carrierPhysician_Services;
Actualcarrier2=carrierClinical_Lab_Services;
Actualcarrier3=carrierAll_Other_Carrier_Claims;
Actualcarrier4=carrierPart_B_Drugs;
Actualcarrier5=carrierAmbulance;

Actualcarrier6=carrierAmbulatory_Surgical_Cente;
Actualcarrier7=carrierDurable_Medical_Equipment;
Actualcarrier8=carrierProsthetics__Orthotics_an;
Actualcarrier9=carrierParenteral_and_Enteral_Nu;
 
 
label Actualcarrier1="Physician Services Spending ";
label Actualcarrier2="Clinical Lab Services Spending ";
label Actualcarrier3="All Other Carrier Claims Spending ";
label Actualcarrier4="Part B Drugs Spending ";
label Actualcarrier5="Ambulance Spending ";
label Actualcarrier6="Ambulatory Surgical Center Spending ";
label Actualcarrier7="Durable Medical Equipment (DME) Spending ";
label Actualcarrier8="Prosthetics, Orthotics and Surgical Supplies Spending ";
label Actualcarrier9="Parenteral and Enteral Nutrition (PEN) Spending ";
keep bene_id Actualcarrier1 Actualcarrier2 Actualcarrier3 Actualcarrier4 Actualcarrier5 Actualcarrier6 Actualcarrier7 Actualcarrier8 Actualcarrier9;
proc sort;by bene_id;
run;

 
data stdcostCarrier2;
set stdcostCarrier2;
stdcostcarrier1=carrierPhysician_Services;
stdcostcarrier2=carrierClinical_Lab_Services;
stdcostcarrier3=carrierAll_Other_Carrier_Claims;
stdcostcarrier4=carrierPart_B_Drugs;
stdcostcarrier5=carrierAmbulance;

stdcostcarrier6=carrierAmbulatory_Surgical_Cente;
stdcostcarrier7=carrierDurable_Medical_Equipment;
stdcostcarrier8=carrierProsthetics__Orthotics_an;
stdcostcarrier9=carrierParenteral_and_Enteral_Nu;
 
 
label stdcostcarrier1="Physician Services Stdcost";
label stdcostcarrier2="Clinical Lab Services Stdcost";
label stdcostcarrier3="All Other Carrier Claims Stdcost";
label stdcostcarrier4="Part B Drugs Stdcost";
label stdcostcarrier5="Ambulance Stdcost";
label stdcostcarrier6="Ambulatory Surgical Center Stdcost";
label stdcostcarrier7="Durable Medical Equipment (DME) Stdcost";
label stdcostcarrier8="Prosthetics, Orthotics and Surgical Supplies Stdcost";
label stdcostcarrier9="Parenteral and Enteral Nutrition (PEN) Stdcost";
keep bene_id stdcostcarrier1 stdcostcarrier2 stdcostcarrier3 stdcostcarrier4 stdcostcarrier5 stdcostcarrier6 stdcostcarrier7 stdcostcarrier8 stdcostcarrier9;
proc sort;by bene_id;
run;











* calculate number of PQI;
proc sort data=pqi.Pqi_medpar2012v45 out=PQI;where TAPQ90=1;by bene_id;run;
proc sql;
create table NPQI as
select bene_id, count(*) as N
from PQI
group by bene_id;
quit;
proc sort data=NPQI nodupkey;by bene_id;run;

 
* Mege all;
data allcost;
merge NPQI (in=in1) bene clmstdcost clmActual stdcostip2 Actualip2 stdcostcarrier2 Actualcarrier2 ;
by bene_id;
if in1;
run;

 









libname seg 'C:\data\Projects\High_Cost_Segmentation\Data';
 

proc sql;
create table temp as
select a.bene_id, a.segment, a.highcost,b.*
from seg.segmentsendbenehc2012 a left join allcost b
on a.bene_id=b.bene_id;
quit;


* Per user and Per Bene;
data peruser;
set temp;
run;

data perbene;
set temp;
array t {45} N--Actualcarrier9;
do i=1 to 45;
if t{i}=. then t{i}=0;
end;
drop i;
run;

 

proc tabulate data=temp;
title "Numbe of Medicare FFS bene 2012";
class segment;
tables N, segment;
keylabel N="N. of Bene";
run;
proc tabulate data=temp;
title "Numbe of Medicare FFS bene 2012";
class highcost;
tables N, highcost;
keylabel N="N. of Bene";
run;
* Per bene;
proc tabulate data=perbene;
title "Per bene:Standard Cost within 30-day post PQI admissions";
class segment highcost;
var N stdcost
stdcostInpatient Stdip1 Stdip2 Stdip3 Stdip4 Stdip5 
stdcostOutpatient 
stdcostCarrier stdcostcarrier1 stdcostcarrier2 stdcostcarrier3 stdcostcarrier4 stdcostcarrier5 stdcostcarrier6 stdcostcarrier7 stdcostcarrier8 stdcostcarrier9 
stdcostHHA stdcostSNF stdcostHospice stdcostDME;
tables ( N  stdcost
stdcostInpatient Stdip1 Stdip2 Stdip3 Stdip4 Stdip5 
stdcostOutpatient 
stdcostCarrier stdcostcarrier1 stdcostcarrier2 stdcostcarrier3 stdcostcarrier4 stdcostcarrier5 stdcostcarrier6 stdcostcarrier7 stdcostcarrier8 stdcostcarrier9 
stdcostHHA stdcostSNF stdcostHospice stdcostDME), (all highcost segment segment*highcost)*( mean median  sum);
run;
proc tabulate data=perbene;
title "Per bene:Actual Spending within 30-day post PQI admissions";
class segment highcost;
var N Actual
ActualInpatient Stdip1 Stdip2 Stdip3 Stdip4 Stdip5 
ActualOutpatient 
ActualCarrier Actualcarrier1 Actualcarrier2 Actualcarrier3 Actualcarrier4 Actualcarrier5 Actualcarrier6 Actualcarrier7 Actualcarrier8 Actualcarrier9 
ActualHHA ActualSNF ActualHospice ActualDME;
tables ( N  Actual
ActualInpatient Stdip1 Stdip2 Stdip3 Stdip4 Stdip5 
ActualOutpatient 
ActualCarrier Actualcarrier1 Actualcarrier2 Actualcarrier3 Actualcarrier4 Actualcarrier5 Actualcarrier6 Actualcarrier7 Actualcarrier8 Actualcarrier9 
ActualHHA ActualSNF ActualHospice ActualDME), (all highcost segment segment*highcost)*( mean median  sum);
run;


* per user;
 proc tabulate data=peruser;
title "Per User:Standard Cost within 30-day post PQI admissions";
class segment highcost;
var N stdcost
stdcostInpatient Stdip1 Stdip2 Stdip3 Stdip4 Stdip5 
stdcostOutpatient 
stdcostCarrier stdcostcarrier1 stdcostcarrier2 stdcostcarrier3 stdcostcarrier4 stdcostcarrier5 stdcostcarrier6 stdcostcarrier7 stdcostcarrier8 stdcostcarrier9 
stdcostHHA stdcostSNF stdcostHospice stdcostDME;
tables ( N  stdcost
stdcostInpatient Stdip1 Stdip2 Stdip3 Stdip4 Stdip5 
stdcostOutpatient 
stdcostCarrier stdcostcarrier1 stdcostcarrier2 stdcostcarrier3 stdcostcarrier4 stdcostcarrier5 stdcostcarrier6 stdcostcarrier7 stdcostcarrier8 stdcostcarrier9 
stdcostHHA stdcostSNF stdcostHospice stdcostDME), (all highcost segment segment*highcost)*(  mean median  sum);
run;
proc tabulate data=peruser missing;
title "Per User:Actual Spending within 30-day post PQI admissions";
class segment highcost;
var N Actual
ActualInpatient Stdip1 Stdip2 Stdip3 Stdip4 Stdip5 
ActualOutpatient 
ActualCarrier Actualcarrier1 Actualcarrier2 Actualcarrier3 Actualcarrier4 Actualcarrier5 Actualcarrier6 Actualcarrier7 Actualcarrier8 Actualcarrier9 
ActualHHA ActualSNF ActualHospice ActualDME;
tables ( N  Actual
ActualInpatient Stdip1 Stdip2 Stdip3 Stdip4 Stdip5 
ActualOutpatient 
ActualCarrier Actualcarrier1 Actualcarrier2 Actualcarrier3 Actualcarrier4 Actualcarrier5 Actualcarrier6 Actualcarrier7 Actualcarrier8 Actualcarrier9 
ActualHHA ActualSNF ActualHospice ActualDME), (all highcost segment segment*highcost)*(  mean median sum);
run;
