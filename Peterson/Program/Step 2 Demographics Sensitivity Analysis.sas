*****************************************
Demographics Tabulation
Xiner Zhou
2/16/2017
*****************************************;
libname MMleads 'D:\Data\MMLEADS\Data';
libname denom 'D:\Data\Medicare\Denominator';
libname data 'D:\Projects\Peterson\Data';
 

**********************************
Plan A
**********************************;
* Bene demog info from data.bene2008 , restrict to data.PlanABene only;
proc sql;
create table temp1 as
select a.*,  b.*
from data.beneV22008 a inner join data.PlanABeneV2 b
on a.bene_id=b.bene_id;
quit;
 
 

proc tabulate data=temp1 noseps  missing;
class D_sex RaceGroup AgeGroup group region   E_MME_Type E_MS_CD E_BOE MHI2008 Edu2008   D_STATE_CD ; 
 
table (	D_sex="Gender" 
		RaceGroup="Race" 
		AgeGroup="Age" 
		region="HRSA regions" 
		D_STATE_CD="State"
		E_MME_Type="Dual Status" 
		E_MS_CD="Medicare status code" 
		E_BOE="Medicaid Basis of Eligibility"
		MHI2008="Stratify by Zip Code Median Income in Quartiles"
		Edu2008="Stratify by Zip Code Proportion of College Education Degree in Quartiles"
		 
		
),(group="10% High Cost Patients"*(n colpctn)   all*(n colpctn))/RTS=25;
 
Keylabel all="All Dual Eligible"
         N="Number of Beneficiary"
		 colpctn="Column Percent";

format   E_MS_CD $E_MS_CD_. E_BOE $E_BOE_.; 
run;
 

* Cost;
proc sql;
create table temp1 as
select a.*,  b.S_PMT as S_PMT2008, b.S_Medicare_PMT as S_Medicare_PMT2008, b.S_Medicaid_PMT as S_Medicaid_PMT2008  
from data.PlanABeneV2  a inner join data.Benev22008 b
on a.bene_id=b.bene_id;
quit;
proc sql;
create table temp2 as
select a.*,  b.S_PMT as S_PMT2009, b.S_Medicare_PMT as S_Medicare_PMT2009, b.S_Medicaid_PMT as S_Medicaid_PMT2009  
from temp1  a inner join data.Benev22009 b
on a.bene_id=b.bene_id;
quit;
proc sql;
create table temp3 as
select a.*,  b.S_PMT as S_PMT2010, b.S_Medicare_PMT as S_Medicare_PMT2010, b.S_Medicaid_PMT as S_Medicaid_PMT2010 
from temp2  a inner join data.Benev22010 b
on a.bene_id=b.bene_id;
quit;

data temp4;
set temp3;

ave_S_PMT=(S_PMT2008+S_PMT2009+S_PMT2010)/3;
ave_S_Medicare_PMT=(S_Medicare_PMT2008+S_Medicare_PMT2009+S_Medicare_PMT2010)/3;
ave_S_Medicaid_PMT=(S_Medicaid_PMT2008+S_Medicaid_PMT2009+S_Medicaid_PMT2010)/3;
run;

proc tabulate data=temp4 noseps   ;
class group   ; 
var  ave_S_PMT ave_S_Medicare_PMT ave_S_Medicaid_PMT;
table  
group*(ave_S_PMT="Medicare+Medicaid paid 3yr average" ave_S_Medicare_PMT="Medicare paid 3yr average" ave_S_Medicaid_PMT="Medicaid paid 3yr average")*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)   
All*(ave_S_PMT="Medicare+Medicaid paid 3yr average" ave_S_Medicare_PMT="Medicare paid 3yr average" ave_S_Medicaid_PMT="Medicaid paid 3yr average")*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.) ;
  
Keylabel all="All Dual Eligible";
run;
