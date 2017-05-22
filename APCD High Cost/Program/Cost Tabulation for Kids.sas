*******************************************
	APCD Cost Tabulation
******************************************;
libname APCD 'C:\data\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';


%let bymoney=Cost;
%let bymoney=Spending;

data temp;
set APCD.AnalyticDataKid&bymoney.;
length AgeKid $15.;
if Age<18;
if Age<=1 then AgeKid="Infancy";
else if Age<=2 then AgeKid="Toddler";
else if Age<=5 then AgeKid="Early childhood";
else if Age<=11 then AgeKid="Middle childhood";
else if Age<18 then AgeKid="Early adolescence";
run;


	****************high cost****************************;
proc tabulate data=temp noseps  ;
class highcost type; 
var  T_&bymoney._IP T_&bymoney._IP_OTH T_&bymoney._PAC_OTH T_&bymoney._HH T_&bymoney._Hospice T_&bymoney._SNF
T_&bymoney._OPD T_&bymoney._ESRD T_&bymoney._FQHC T_&bymoney._RHC T_&bymoney._THRPY T_&bymoney._CMHC T_&bymoney._OTH40
T_&bymoney._ASC T_&bymoney._PTB_DRUG T_&bymoney._EM T_&bymoney._PROC T_&bymoney._IMG T_&bymoney._TESTS T_&bymoney._OTH T_&bymoney._DME

T_PTA_&bymoney. T_PTBI_&bymoney. T_PTBNI_&bymoney. &bymoney._Drug &bymoney.woDrug &bymoney.wDrug
;


table &bymoney.wDrug="Total Annual Medical+Drug &bymoney."
      &bymoney.woDrug="Total Annual Medical &bymoney., without Drug"
	  T_PTA_&bymoney.="Equivalent to Medicare Part A "
			T_&bymoney._IP="Inpatient Acute Care Hospital (include CAH)" 
            T_&bymoney._IP_OTH="Other Inpatient (Psych, other hospital)"
			T_&bymoney._PAC_OTH="Other post-acute care (Inpatient Rehab, long-term hospital)"
			T_&bymoney._HH="Home Health (HH)" 
			T_&bymoney._Hospice="Hospice"
			T_&bymoney._SNF="Skilled Nursing Facility (SNF)"
	  T_PTBI_&bymoney.="Equivalent to Medicare Part B institutional ?hospital outpatient "
	  		T_&bymoney._OPD="Outpatient Department Services"
			T_&bymoney._ESRD="End Stage Renal Disease (ESRD) Facility"
			T_&bymoney._FQHC="Federally Qualified Health Center (FQHC)" 
			T_&bymoney._RHC="Rural Health Center (Clinic)" 
			T_&bymoney._THRPY="Outpatient Therapy (outpatient rehab and community outpatient rehab)"  
			T_&bymoney._CMHC="Community Mental Health Center (CMHC)"  
			T_&bymoney._OTH40="Other" 
      T_PTBNI_&bymoney.="Equivalent to Medicare Part B Non-institutional- Carrier/DME"
			T_&bymoney._ASC="Ambulatory Surgical Center (ASC)" 
			T_&bymoney._PTB_DRUG="Part B Drug" 
			T_&bymoney._EM="Physician Evaluation and Management" 
			T_&bymoney._PROC="Procedures" 
			T_&bymoney._IMG="Imaging" 
			T_&bymoney._TESTS="Tests" 
			T_&bymoney._OTH="Other Part B" 
			T_&bymoney._DME="Durable Medical Equipment (DME)"
     &bymoney._Drug="Equivalent to Medicare Part D Drugs"

 
      ,highcost="10% High Cost Patients"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12. ) 
highcost="10% High Cost Patients"*type*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.) 
type*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.) 
All*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.  )  ;
 
 
Keylabel all="All Beneficiary" 
         ;
run;



 
