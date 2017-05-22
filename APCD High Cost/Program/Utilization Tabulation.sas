*******************************************
	APCD Utilization Tabulation
******************************************;
libname APCD 'C:\data\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';


%let bymoney=Cost;
%let bymoney=Spending;

	****************high cost****************************;
proc tabulate data=APCD.AnalyticData&bymoney. noseps  ;
class highcost  type; 
var  T_CLM_IP T_CLM_IP_OTH T_CLM_PAC_OTH T_CLM_HH T_CLM_Hospice T_CLM_SNF
T_CLM_OPD T_CLM_ESRD T_CLM_FQHC T_CLM_RHC T_CLM_THRPY T_CLM_CMHC T_CLM_OTH40
T_CLM_ASC T_CLM_PTB_DRUG T_CLM_EM T_CLM_PROC T_CLM_IMG T_CLM_TESTS T_CLM_OTH T_CLM_DME
CLM_DRUG

 T_LOS_IP T_LOS_IP_OTH T_LOS_PAC_OTH T_LOS_HH T_LOS_Hospice T_LOS_SNF 
;


table 
	 
			T_CLM_IP="N.of Claims:Inpatient Acute Care Hospital (include CAH)" 
			T_LOS_IP="LOS:Inpatient Acute Care Hospital (include CAH)" 
            T_CLM_IP_OTH="N.of Claims:Other Inpatient (Psych, other hospital)"
			T_LOS_IP_OTH="LOS:Other Inpatient (Psych, other hospital)"
			T_CLM_PAC_OTH="N.of Claims:Other post-acute care (Inpatient Rehab, long-term hospital)"
			T_LOS_PAC_OTH="LOS:Other post-acute care (Inpatient Rehab, long-term hospital)"
			T_CLM_HH="N.of Claims:Home Health (HH)" 
			T_LOS_HH="LOS:Home Health (HH)" 
			T_CLM_Hospice="N.of Claims:Hospice"
			T_LOS_Hospice="LOS:Hospice"
			T_CLM_SNF="N.of Claims:Skilled Nursing Facility (SNF)"
			T_LOS_SNF="LOS:Skilled Nursing Facility (SNF)"
	  
	  		T_CLM_OPD="N.of Claims:Outpatient Department Services"
			T_CLM_ESRD="N.of Claims:End Stage Renal Disease (ESRD) Facility"
			T_CLM_FQHC="N.of Claims:Federally Qualified Health Center (FQHC)" 
			T_CLM_RHC="N.of Claims:Rural Health Center (Clinic)" 
			T_CLM_THRPY="N.of Claims:Outpatient Therapy (outpatient rehab and community outpatient rehab)"  
			T_CLM_CMHC="N.of Claims:Community Mental Health Center (CMHC)"  
			T_CLM_OTH40="N.of Claims:Other" 
      
			T_CLM_ASC="N.of Claims:Ambulatory Surgical Center (ASC)" 
			T_CLM_PTB_DRUG="N.of Claims:Part B Drug" 
			T_CLM_EM="N.of Claims:Physician Evaluation and Management" 
			T_CLM_PROC="N.of Claims:Procedures" 
			T_CLM_IMG="N.of Claims:Imaging" 
			T_CLM_TESTS="N.of Claims:Tests" 
			T_CLM_OTH="N.of Claims:Other Part B" 
			T_CLM_DME="N.of Claims:Durable Medical Equipment (DME)"
      CLM_Drug="N.of Claims:Equivalent to Medicare Part D Drugs"

 
      ,highcost="10% High Cost Patients"*(mean*f=15.5 median*f=7. sum*f=20.  )  highcost="10% High Cost Patients"*type*(mean*f=15.5 median*f=7. sum*f=20.  )  type*(mean*f=15.5 median*f=7. sum*f=20.  )  
     /* seg2011="Segments"*(mean*f=15.5 median*f=7. sum*f=20.  ) 
      seg2011="Segments"*type*(mean*f=15.5 median*f=7. sum*f=20.  )
	  seg2011="Segments"*highcost="10% High Cost Patients"*(mean*f=15.5 median*f=7. sum*f=20.  )*/
      All*(mean*f=15.5 median*f=7. sum*f=20.  ) ;
 
 
Keylabel all="All Beneficiary" 
         ;
run;





/*	****************Segments****************************;
	****************high cost****************************;
proc tabulate data=APCD.AnalyticData&bymoney. noseps  ;
class highcost Seg2011 type; 
var  T_CLM_IP T_CLM_IP_OTH T_CLM_PAC_OTH T_CLM_HH T_CLM_Hospice T_CLM_SNF
T_CLM_OPD T_CLM_ESRD T_CLM_FQHC T_CLM_RHC T_CLM_THRPY T_CLM_CMHC T_CLM_OTH40
T_CLM_ASC T_CLM_PTB_DRUG T_CLM_EM T_CLM_PROC T_CLM_IMG T_CLM_TESTS T_CLM_OTH T_CLM_DME
CLM_DRUG

 T_LOS_IP T_LOS_IP_OTH T_LOS_PAC_OTH T_LOS_HH T_LOS_Hospice T_LOS_SNF 
;


table 
	 
			T_CLM_IP="N.of Claims:Inpatient Acute Care Hospital (include CAH)" 
			T_LOS_IP="LOS:Inpatient Acute Care Hospital (include CAH)" 
            T_CLM_IP_OTH="N.of Claims:Other Inpatient (Psych, other hospital)"
			T_LOS_IP_OTH="LOS:Other Inpatient (Psych, other hospital)"
			T_CLM_PAC_OTH="N.of Claims:Other post-acute care (Inpatient Rehab, long-term hospital)"
			T_LOS_PAC_OTH="LOS:Other post-acute care (Inpatient Rehab, long-term hospital)"
			T_CLM_HH="N.of Claims:Home Health (HH)" 
			T_LOS_HH="LOS:Home Health (HH)" 
			T_CLM_Hospice="N.of Claims:Hospice"
			T_LOS_Hospice="LOS:Hospice"
			T_CLM_SNF="N.of Claims:Skilled Nursing Facility (SNF)"
			T_LOS_SNF="LOS:Skilled Nursing Facility (SNF)"
	  
	  		T_CLM_OPD="N.of Claims:Outpatient Department Services"
			T_CLM_ESRD="N.of Claims:End Stage Renal Disease (ESRD) Facility"
			T_CLM_FQHC="N.of Claims:Federally Qualified Health Center (FQHC)" 
			T_CLM_RHC="N.of Claims:Rural Health Center (Clinic)" 
			T_CLM_THRPY="N.of Claims:Outpatient Therapy (outpatient rehab and community outpatient rehab)"  
			T_CLM_CMHC="N.of Claims:Community Mental Health Center (CMHC)"  
			T_CLM_OTH40="N.of Claims:Other" 
      
			T_CLM_ASC="N.of Claims:Ambulatory Surgical Center (ASC)" 
			T_CLM_PTB_DRUG="N.of Claims:Part B Drug" 
			T_CLM_EM="N.of Claims:Physician Evaluation and Management" 
			T_CLM_PROC="N.of Claims:Procedures" 
			T_CLM_IMG="N.of Claims:Imaging" 
			T_CLM_TESTS="N.of Claims:Tests" 
			T_CLM_OTH="N.of Claims:Other Part B" 
			T_CLM_DME="N.of Claims:Durable Medical Equipment (DME)"
      CLM_Drug="N.of Claims:Equivalent to Medicare Part D Drugs"

 
      ,seg2011="Segments"*(mean*f=15.5 median*f=7. sum*f=20.  ) 
      seg2011="Segments"*type*(mean*f=15.5 median*f=7. sum*f=20.  )
	  seg2011="Segments"*highcost="10% High Cost Patients"*(mean*f=15.5 median*f=7. sum*f=20.  )
      All*(mean*f=15.5 median*f=7. sum*f=20.  ) ;
 
 
Keylabel all="All Beneficiary" 
         ;
run;
*/
