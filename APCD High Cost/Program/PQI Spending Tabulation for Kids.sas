*******************************************
	APCD 30-day Preventative Spending Tabulation
******************************************;
libname APCD 'C:\data\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';

 

	****************high cost (Stdcost)****************************;

data AnalyticDataCost;
set APCD.AnalyticDataKidCost;

if N=. then N=0;
if PQIstdcostIP=. then PQIstdcostIP=0;
if PQIstdcostOP=. then PQIstdcostOP=0;
if PQIstdcostCarrier=. then PQIstdcostCarrier=0;
if PQIstdcostHospice=. then PQIstdcostHospice=0;
if PQIstdcostSNF=. then PQIstdcostSNF=0;
if PQIstdcostHHA=. then PQIstdcostHHA=0;

if PQIspendingIP=. then PQIspendingIP=0;
if PQIspendingOP=. then PQIspendingOP=0;
if PQIspendingCarrier=. then PQIspendingCarrier=0;
if PQIspendingHospice=. then PQIspendingHospice=0;
if PQIspendingSNF=. then PQIspendingSNF=0;
if PQIspendingHHA=. then PQIspendingHHA=0;

if PQIstdcost30=. then PQIstdcost30=0;
if PQISpending30=. then PQISpending30=0;
 


run;



proc tabulate data=AnalyticDataCost noseps  ;
class highcost  type; 
var N 
    PQIstdcostIP PQIstdcostOP PQIstdcostCarrier PQIstdcostHospice PQIstdcostSNF PQIstdcostHHA
    PQIspendingIP  PQIspendingOP PQIspendingCarrier PQIspendingHospice PQIspendingSNF PQIspendingHHA
	PQIstdcost30 PQISpending30
	N_TAPQ01 N_TAPQ02 N_TAPQ03 N_TAPQ05 N_TAPQ07 N_TAPQ08 N_TAPQ10 N_TAPQ11 N_TAPQ12 N_TAPQ13 N_TAPQ14 N_TAPQ15 N_TAPQ16 N_TAPQ90 N_TAPQ91 N_TAPQ92
	TAPQ01stdcost TAPQ02stdcost TAPQ03stdcost TAPQ05stdcost TAPQ07stdcost TAPQ08stdcost TAPQ10stdcost TAPQ11stdcost TAPQ12stdcost TAPQ13stdcost TAPQ14stdcost TAPQ15stdcost TAPQ16stdcost TAPQ90stdcost TAPQ91stdcost TAPQ92stdcost
	TAPQ01spending TAPQ02spending TAPQ03spending TAPQ05spending TAPQ07spending TAPQ08spending TAPQ10spending TAPQ11spending TAPQ12spending TAPQ13spending TAPQ14spending TAPQ15spending TAPQ16spending TAPQ90spending TAPQ91spending TAPQ92spending
;


table N ="Number of PQI during 2012",highcost="10% High Cost Patients"*(mean*f=7.4 median*f=7.4 sum*f=7.4 ) 
highcost="10% High Cost Patients"*type*(mean*f=7.4 median*f=7.4 sum*f=7.4) 
type*(mean*f=7.4 median*f=7.4 sum*f=7.4) 

All*(mean*f=7.4 median*f=7.4 sum*f=7.4 )  ;

table
      PQIstdcost30="Total Within 30-day Post PQI Standard Cost"
      PQIstdcostIP="Within 30-day Post PQI Standard Cost:Inpatient"
      PQIstdcostOP="Within 30-day Post PQI Standard Cost:Outpatient"
      PQIstdcostCarrier="Within 30-day Post PQI Standard Cost:Carrier/Physician"
      PQIstdcostHospice="Within 30-day Post PQI Standard Cost:Hospice"
      PQIstdcostSNF="Within 30-day Post PQI Standard Cost:Skilled Nursing Facility" 
      PQIstdcostHHA="Within 30-day Post PQI Standard Cost:Home Health Agency"
 ,highcost="10% High Cost Patients"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12. ) 
highcost="10% High Cost Patients"*type*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.) 
type*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.) 

All*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.  )  ;
 
table N_TAPQ01 N_TAPQ02 N_TAPQ03 N_TAPQ05 N_TAPQ07 N_TAPQ08 N_TAPQ10 N_TAPQ11 N_TAPQ12 N_TAPQ13 N_TAPQ14 N_TAPQ15 N_TAPQ16 N_TAPQ90 N_TAPQ91 N_TAPQ92,
highcost="10% High Cost Patients"*(mean*f=7.4 median*f=7.4 sum*f=7.4 ) 
highcost="10% High Cost Patients"*type*(mean*f=7.4 median*f=7.4 sum*f=7.4) 
type*(mean*f=7.4 median*f=7.4 sum*f=7.4) 

All*(mean*f=7.4 median*f=7.4 sum*f=7.4 )  ; 


table 
TAPQ01stdcost TAPQ02stdcost TAPQ03stdcost TAPQ05stdcost TAPQ07stdcost TAPQ08stdcost TAPQ10stdcost TAPQ11stdcost TAPQ12stdcost TAPQ13stdcost TAPQ14stdcost TAPQ15stdcost TAPQ16stdcost TAPQ90stdcost TAPQ91stdcost TAPQ92stdcost
,highcost="10% High Cost Patients"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12. ) 
highcost="10% High Cost Patients"*type*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.) 
type*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.) 

All*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.  )  ;
Keylabel all="All Beneficiary" 
         ;
run;

	****************high cost (Spending)****************************;

data AnalyticDataSpending;
set APCD.AnalyticDataKidSpending;

if N=. then N=0;
if PQIstdcostIP=. then PQIstdcostIP=0;
if PQIstdcostOP=. then PQIstdcostOP=0;
if PQIstdcostCarrier=. then PQIstdcostCarrier=0;
if PQIstdcostHospice=. then PQIstdcostHospice=0;
if PQIstdcostSNF=. then PQIstdcostSNF=0;
if PQIstdcostHHA=. then PQIstdcostHHA=0;

if PQIspendingIP=. then PQIspendingIP=0;
if PQIspendingOP=. then PQIspendingOP=0;
if PQIspendingCarrier=. then PQIspendingCarrier=0;
if PQIspendingHospice=. then PQIspendingHospice=0;
if PQIspendingSNF=. then PQIspendingSNF=0;
if PQIspendingHHA=. then PQIspendingHHA=0;

if PQIstdcost30=. then PQIstdcost30=0;
if PQISpending30=. then PQISpending30=0;

run;


proc tabulate data=AnalyticDataSpending noseps  ;
class highcost  type; 
var N 
    PQIstdcostIP PQIstdcostOP PQIstdcostCarrier PQIstdcostHospice PQIstdcostSNF PQIstdcostHHA
    PQIspendingIP  PQIspendingOP PQIspendingCarrier PQIspendingHospice PQIspendingSNF PQIspendingHHA
	PQIstdcost30 PQISpending30
	N_TAPQ01 N_TAPQ02 N_TAPQ03 N_TAPQ05 N_TAPQ07 N_TAPQ08 N_TAPQ10 N_TAPQ11 N_TAPQ12 N_TAPQ13 N_TAPQ14 N_TAPQ15 N_TAPQ16 N_TAPQ90 N_TAPQ91 N_TAPQ92
	TAPQ01stdcost TAPQ02stdcost TAPQ03stdcost TAPQ05stdcost TAPQ07stdcost TAPQ08stdcost TAPQ10stdcost TAPQ11stdcost TAPQ12stdcost TAPQ13stdcost TAPQ14stdcost TAPQ15stdcost TAPQ16stdcost TAPQ90stdcost TAPQ91stdcost TAPQ92stdcost
	TAPQ01spending TAPQ02spending TAPQ03spending TAPQ05spending TAPQ07spending TAPQ08spending TAPQ10spending TAPQ11spending TAPQ12spending TAPQ13spending TAPQ14spending TAPQ15spending TAPQ16spending TAPQ90spending TAPQ91spending TAPQ92spending
;


table N ="Number of PQI during 2012",highcost="10% High Cost Patients"*(mean*f=7.4 median*f=7.4 sum*f=7.4 ) 
highcost="10% High Cost Patients"*type*(mean*f=7.4 median*f=7.4 sum*f=7.4) 
type*(mean*f=7.4 median*f=7.4 sum*f=7.4)
All*(mean*f=7.4 median*f=7.4 sum*f=7.4  )  ;
 
 table     PQISpending30="Total Within 30-day Post PQI Actual Spending"
      PQISpendingIP="Within 30-day Post PQI Actual Spending:Inpatient"
      PQISpendingOP="Within 30-day Post PQI Actual Spending:Outpatient"
      PQISpendingCarrier="Within 30-day Post PQI Actual Spending:Carrier/Physician"
      PQISpendingHospice="Within 30-day Post PQI Actual Spending:Hospice"
      PQISpendingSNF="Within 30-day Post PQI Actual Spending:Skilled Nursing Facility" 
      PQISpendingHHA="Within 30-day Post PQI Actual Spending:Home Health Agency"
 ,highcost="10% High Cost Patients"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12. ) 
highcost="10% High Cost Patients"*type*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.) 
type*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.) 

All*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.  )  ;
 
 table N_TAPQ01 N_TAPQ02 N_TAPQ03 N_TAPQ05 N_TAPQ07 N_TAPQ08 N_TAPQ10 N_TAPQ11 N_TAPQ12 N_TAPQ13 N_TAPQ14 N_TAPQ15 N_TAPQ16 N_TAPQ90 N_TAPQ91 N_TAPQ92,
highcost="10% High Cost Patients"*(mean*f=7.4 median*f=7.4 sum*f=7.4 ) 
highcost="10% High Cost Patients"*type*(mean*f=7.4 median*f=7.4 sum*f=7.4) 
type*(mean*f=7.4 median*f=7.4 sum*f=7.4) 

All*(mean*f=7.4 median*f=7.4 sum*f=7.4 )  ; 


table 
TAPQ01spending TAPQ02spending TAPQ03spending TAPQ05spending TAPQ07spending TAPQ08spending TAPQ10spending TAPQ11spending TAPQ12spending TAPQ13spending TAPQ14spending TAPQ15spending TAPQ16spending TAPQ90spending TAPQ91spending TAPQ92spending
,highcost="10% High Cost Patients"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12. ) 
highcost="10% High Cost Patients"*type*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.) 
type*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.) 

All*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.  )  ;
 
Keylabel all="All Beneficiary" 
         ;
run;
