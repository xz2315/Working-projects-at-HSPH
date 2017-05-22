*******************************************
	APCD Demographics Tabulation
******************************************;
libname APCD 'C:\data\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';


%let bymoney=Cost;
%let bymoney=Spending;

data temp;
set APCD.AnalyticDataKid&bymoney.;
length AgeKid $15.;
if incomerank=. then incomerank=0;
if Age<=1 then AgeKid="Infancy";
else if Age<=2 then AgeKid="Toddler";
else if Age<=5 then AgeKid="Early childhood";
else if Age<=11 then AgeKid="Middle childhood";
else if Age<18 then AgeKid="Early adolescence";
run;


 *******************High Cost**************************;

proc tabulate data=temp noseps  ;
class highcost  gender race ethnicity hispanic Type OrgID AgeKid IncomeRank; 
var Age;
table (gender="Gender" Race="Race" Ethnicity="Ethnicity" Hispanic="Hispanic" Type="Medicaid/Medicaid Managed Care/Private" OrgID="Payer" AgeKid="Age Group" 
IncomeRank="Income Rank based on 2012 County Median House Income"
),(highcost="10% High Cost Patients"*(n colpctn)  highcost="10% High Cost Patients"*Type*(n colpctn) 
Type*(n colpctn) 
   all*(n colpctn))/RTS=25;

table (Age="Age" 
),(highcost="10% High Cost Patients"*(mean*f=15.5 median)  highcost="10% High Cost Patients"*Type*(mean*f=15.5 median) 
   Type*(mean*f=15.5 median) 
   all*(mean*f=15.5 median))/RTS=25;

Keylabel all="All Beneficiary"
         N="Number of Beneficiary"
		 colpctn="Column Percent";

format IncomeRank IncomeRank_. OrgID OrgID_.  ; 
run;


 
 
