*****************************************
Cost Per Bene and Per User Tabulation Yearly
Xiner Zhou
2/21/2017
*****************************************;
libname MMleads 'D:\Data\MMLEADS\Data';
libname denom 'D:\Data\Medicare\Denominator';
libname data 'D:\Projects\Peterson\Data';

*********Medicare + Medicaid 3yr ave cost;
data temp;
set data.PlanAbeneV3;
ave_S_PMT=(S_PMT2008+S_PMT2009+S_PMT2010)/3;
ave_S_Medicare_PMT=(S_Medicare_PMT2008+S_Medicare_PMT2009+S_Medicare_PMT2010)/3;
ave_S_Medicaid_PMT=(S_Medicaid_PMT2008+S_Medicaid_PMT2009+S_Medicaid_PMT2010)/3;
run;

proc sql;create table temp1 as select a.*,b.D_STATE_CD, b.region from temp a left join data.Benev32008 b on a.bene_id=b.bene_id;quit;

proc tabulate data=temp1 noseps   QMETHOD=P2 ;
class group1 group  D_STATE_CD region ; 
var  ave_S_PMT ave_S_Medicare_PMT ave_S_Medicaid_PMT
S_PMT2008 S_PMT2009 S_PMT2010
S_Medicare_PMT2008 S_Medicare_PMT2009 S_Medicare_PMT2010
S_Medicaid_PMT2008 S_Medicaid_PMT2009 S_Medicaid_PMT2010;
table  (all D_STATE_CD region),
group1*(ave_S_PMT="Medicare+Medicaid 3yr average"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)
	   S_PMT2008="Medicare+Medicaid 2008"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)
	   S_PMT2009="Medicare+Medicaid 2009"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)
	   S_PMT2010="Medicare+Medicaid 2010"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)

	   ave_S_Medicare_PMT="Medicare 3yr average"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)
	   S_Medicare_PMT2008="Medicare 2008"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)
	   S_Medicare_PMT2009="Medicare 2009"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)
	   S_Medicare_PMT2010="Medicare 2010"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)

	   ave_S_Medicaid_PMT="Medicaid 3yr average"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)
	   S_Medicaid_PMT2008="Medicaid 2008"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)
	   S_Medicaid_PMT2009="Medicaid 2009"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)
	   S_Medicaid_PMT2010="Medicaid 2010"*(mean*f=dollar12. median*f=dollar12. sum*f=dollar12.)
        )
 ;
  
Keylabel all="All Dual Eligible";
run;

* How many % of HC in each region;
data temp2;
length group2 $30.;
set temp1;
if group not in ("HC HC HC","nonHC nonHC nonHC") then group2="Others";
else group2=group;
proc freq;tables group2/missing;
run;
proc tabulate data=temp2 noseps  missing;
class group1 group group2 D_STATE_CD region HC2008 HC2009 HC2010; 
table (all D_STATE_CD region),
(HC2008*(n rowpctn) HC2009*(n rowpctn) HC2010*(n rowpctn)
group="10% High Cost Patients"*(n rowpctn)
group1*(n rowpctn)
group1*group2*(n rowpctn)
)/RTS=25;
 
Keylabel all="All Dual Eligible"
         N="Number of Beneficiary"
		 colpctn="Column Percent";
 
run;

 
