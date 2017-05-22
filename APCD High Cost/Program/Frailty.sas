********************************
Frailty Indicators for Segment
Xiner Zhou
12/23/2015
********************************;
libname data 'C:\data\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';
libname HCC 'C:\data\Projects\Peterson';
proc sql;
create table temp1 as
select MemberLinkEID, DateOfServiceTo,
case when  (AdmittingDiagnosisCleaned in ("7812") or DischargeDiagnosisCleaned in ("7812") or PrincipalDiagnosisCleaned in ("7812") or OtherDiagnosis1Cleaned in ("7812") or OtherDiagnosis2Cleaned in ("7812") or OtherDiagnosis3Cleaned in ("7812") or OtherDiagnosis4Cleaned in ("7812") or OtherDiagnosis5Cleaned in ("7812") or OtherDiagnosis6Cleaned in ("7812") or OtherDiagnosis7Cleaned in ("7812")  or OtherDiagnosis8Cleaned  in ("7812") or OtherDiagnosis9Cleaned  in ("7812") or OtherDiagnosis10Cleaned  in ("7812") or OtherDiagnosis11Cleaned  in ("7812") or OtherDiagnosis12Cleaned  in ("7812")) then 1 else 0 end as Frail1 , 
case when  (AdmittingDiagnosisCleaned in (select ICD from HCC.Icd2hccxw2013 where HCC=21) or DischargeDiagnosisCleaned in (select ICD from HCC.Icd2hccxw2014 where HCC=21) or PrincipalDiagnosisCleaned in (select ICD from HCC.Icd2hccxw2014 where HCC=21) or OtherDiagnosis1Cleaned in (select ICD from HCC.Icd2hccxw2014 where HCC=21) or OtherDiagnosis2Cleaned in (select ICD from HCC.Icd2hccxw2014 where HCC=21) or OtherDiagnosis3Cleaned in (select ICD from HCC.Icd2hccxw2014 where HCC=21) or OtherDiagnosis4Cleaned in (select ICD from HCC.Icd2hccxw2014 where HCC=21)
           or OtherDiagnosis5Cleaned in (select ICD from HCC.Icd2hccxw2014 where HCC=21) or OtherDiagnosis6Cleaned in (select ICD from HCC.Icd2hccxw2014 where HCC=21) or OtherDiagnosis7Cleaned in (select ICD from HCC.Icd2hccxw2014 where HCC=21) or OtherDiagnosis8Cleaned in (select ICD from HCC.Icd2hccxw2014 where HCC=21) or OtherDiagnosis9Cleaned in (select ICD from HCC.Icd2hccxw2014 where HCC=21) or OtherDiagnosis10Cleaned in (select ICD from HCC.Icd2hccxw2014 where HCC=21) or OtherDiagnosis11Cleaned  in (select ICD from HCC.Icd2hccxw2014 where HCC=21) or OtherDiagnosis12Cleaned in (select ICD from HCC.Icd2hccxw2014 where HCC=21)) then 1 else 0 end as Frail2, 
case when  (AdmittingDiagnosisCleaned in ("7837") or DischargeDiagnosisCleaned in ("7837") or PrincipalDiagnosisCleaned in ("7837") or OtherDiagnosis1Cleaned in ("7837") or OtherDiagnosis2Cleaned in ("7837") or OtherDiagnosis3Cleaned in ("7837") or OtherDiagnosis4Cleaned in ("7837") or OtherDiagnosis5Cleaned in ("7837") or OtherDiagnosis6Cleaned in ("7837") or OtherDiagnosis7Cleaned in ("7837") or OtherDiagnosis8Cleaned in ("7837") or OtherDiagnosis9Cleaned in ("7837") or OtherDiagnosis10Cleaned in  ("7837") or OtherDiagnosis11Cleaned in  ("7837") or  OtherDiagnosis12Cleaned in ("7837") ) then 1 else 0 end as Frail3, 
case when  (AdmittingDiagnosisCleaned in ("7994") or DischargeDiagnosisCleaned in ("7994") or PrincipalDiagnosisCleaned in ("7994") or OtherDiagnosis1Cleaned in ("7994") or OtherDiagnosis2Cleaned in ("7994") or OtherDiagnosis3Cleaned in ("7994") or OtherDiagnosis4Cleaned in ("7994") or OtherDiagnosis5Cleaned in ("7994") or OtherDiagnosis6Cleaned in ("7994") or OtherDiagnosis7Cleaned in ("7994") or OtherDiagnosis8Cleaned in ("7994") or OtherDiagnosis9Cleaned in ("7994") or OtherDiagnosis10Cleaned in ("7994") or OtherDiagnosis11Cleaned  in ("7994") or OtherDiagnosis12Cleaned in ("7994")) then 1 else 0 end as Frail4, 
case when  (AdmittingDiagnosisCleaned in ("7993") or DischargeDiagnosisCleaned in ("7993") or PrincipalDiagnosisCleaned in ("7993") or OtherDiagnosis1Cleaned in ("7993") or OtherDiagnosis2Cleaned in ("7993") or OtherDiagnosis3Cleaned in ("7993") or OtherDiagnosis4Cleaned in ("7993") or OtherDiagnosis5Cleaned in ("7993") or OtherDiagnosis6Cleaned in ("7993") or OtherDiagnosis7Cleaned in ("7993") or OtherDiagnosis8Cleaned in ("7993") or OtherDiagnosis9Cleaned in ("7993") or OtherDiagnosis10Cleaned in ("7993") or OtherDiagnosis11Cleaned  in ("7993") or OtherDiagnosis12Cleaned in ("7993")) then 1 else 0 end as Frail5, 
case when  (AdmittingDiagnosisCleaned in ("7197") or DischargeDiagnosisCleaned in ("7197") or PrincipalDiagnosisCleaned in ("7197") or OtherDiagnosis1Cleaned in ("7197") or OtherDiagnosis2Cleaned in ("7197") or OtherDiagnosis3Cleaned in ("7197") or OtherDiagnosis4Cleaned in ("7197") or OtherDiagnosis5Cleaned in ("7197") or OtherDiagnosis6Cleaned in ("7197") or OtherDiagnosis7Cleaned in ("7197") or OtherDiagnosis8Cleaned in ("7197") or OtherDiagnosis9Cleaned in ("7197") or OtherDiagnosis10Cleaned in ("7197") or OtherDiagnosis11Cleaned  in ("7197") or OtherDiagnosis12Cleaned in ("7197")) then 1 else 0 end as Frail6, 
case when  (AdmittingDiagnosisCleaned in ("V1588") or DischargeDiagnosisCleaned in ("V1588") or PrincipalDiagnosisCleaned in ("V1588") or OtherDiagnosis1Cleaned in ("V1588") or OtherDiagnosis2Cleaned in ("V1588") or OtherDiagnosis3Cleaned in ("V1588") or OtherDiagnosis4Cleaned in ("V1588") or OtherDiagnosis5Cleaned in ("V1588") or OtherDiagnosis6Cleaned in ("V1588") or OtherDiagnosis7Cleaned in ("V1588") or OtherDiagnosis8Cleaned in ("V1588") or OtherDiagnosis9Cleaned in ("V1588") or OtherDiagnosis10Cleaned in ("V1588") or OtherDiagnosis11Cleaned  in ("V1588") or OtherDiagnosis12Cleaned in ("V1588")) then 1 else 0 end as Frail7, 
case when  (AdmittingDiagnosisCleaned in ("7282") or DischargeDiagnosisCleaned in ("7282") or PrincipalDiagnosisCleaned in ("7282") or OtherDiagnosis1Cleaned in ("7282") or OtherDiagnosis2Cleaned in ("7282") or OtherDiagnosis3Cleaned in ("7282") or OtherDiagnosis4Cleaned in ("7282") or OtherDiagnosis5Cleaned in ("7282") or OtherDiagnosis6Cleaned in ("7282") or OtherDiagnosis7Cleaned in ("7282") or OtherDiagnosis8Cleaned  in ("7282") or OtherDiagnosis9Cleaned  in ("7282") or OtherDiagnosis10Cleaned  in ("7282") or OtherDiagnosis11Cleaned   in ("7282") or OtherDiagnosis12Cleaned  in ("7282")) then 1 else 0 end as Frail8, 
case when  (AdmittingDiagnosisCleaned in ("72887") or DischargeDiagnosisCleaned in ("72887") or PrincipalDiagnosisCleaned in ("72887") or OtherDiagnosis1Cleaned in ("72887") or OtherDiagnosis2Cleaned in ("72887") or OtherDiagnosis3Cleaned in ("72887") or OtherDiagnosis4Cleaned in ("72887") or OtherDiagnosis5Cleaned in ("72887") or OtherDiagnosis6Cleaned in ("72887") or OtherDiagnosis7Cleaned in ("72887") or OtherDiagnosis8Cleaned in ("72887") or OtherDiagnosis9Cleaned in ("72887") or OtherDiagnosis10Cleaned in ("72887") or OtherDiagnosis11Cleaned  in ("72887") or OtherDiagnosis12Cleaned in ("72887")) then 1 else 0 end as Frail9, 
case when  (AdmittingDiagnosisCleaned in (select ICD from HCC.Icd2hccxw2013 where HCC=148) or DischargeDiagnosisCleaned in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or PrincipalDiagnosisCleaned in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or OtherDiagnosis1Cleaned in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or OtherDiagnosis2Cleaned in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or OtherDiagnosis3Cleaned in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or OtherDiagnosis4Cleaned in (select ICD from HCC.Icd2hccxw2014 where HCC=148) 
            or OtherDiagnosis5Cleaned in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or OtherDiagnosis6Cleaned in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or OtherDiagnosis7Cleaned in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or OtherDiagnosis8Cleaned  in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or OtherDiagnosis9Cleaned  in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or OtherDiagnosis10Cleaned  in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or OtherDiagnosis11Cleaned   in (select ICD from HCC.Icd2hccxw2014 where HCC=148) or OtherDiagnosis12Cleaned  in (select ICD from HCC.Icd2hccxw2014 where HCC=148) ) then 1 else 0 end as Frail10, 
case when  (AdmittingDiagnosisCleaned in ("797") or DischargeDiagnosisCleaned in ("797") or PrincipalDiagnosisCleaned in ("797") or OtherDiagnosis1Cleaned in ("797") or OtherDiagnosis2Cleaned in ("797") or OtherDiagnosis3Cleaned in ("797") or OtherDiagnosis4Cleaned in ("797") or OtherDiagnosis5Cleaned in ("797") or OtherDiagnosis6Cleaned in ("797") or OtherDiagnosis7Cleaned in ("797") or OtherDiagnosis8Cleaned in ("797") or OtherDiagnosis9Cleaned in ("797") or OtherDiagnosis10Cleaned in ("797") or OtherDiagnosis11Cleaned  in ("797") or OtherDiagnosis12Cleaned in ("797")) then 1 else 0 end as Frail11,
case when  ProcedureCodeCleaned in ('E0100', 'E0105', 'E0130', 'E0135', 'E0140', 'E0141', 'E0143', 'E0144', 'E0147', 'E0148', 'E0149', 'E0160', 'E0161','E0162','E0163','E0164','E0165','E0166','E0167','E0168','E0169','E0170','E0171') 
then 1 else 0 end as frail12  
from data.Medical;
quit;


data temp2;
set temp1;

date=datepart(DateofServiceTo);year=year(date);
if year=2011;
 
proc sort data=temp2 ;by MemberLinkEID;
run;

proc sql;
create table temp3 as
select MemberLinkEID, sum(frail1) as f1, sum(frail2) as f2, sum(frail3) as f3, sum(frail4) as f4, sum(frail5) as f5, sum(frail6) as f6,
sum(frail7) as f7, sum(frail8) as f8, sum(frail9) as f9, sum(frail10) as f10, sum(frail11) as f11, sum(frail12) as f12
from temp2
group by MemberLinkEID;
quit;

data data.Frailty2009;
set temp3;
Frailty1=0;Frailty2=0;Frailty3=0;Frailty4=0;Frailty5=0;Frailty6=0;Frailty7=0;Frailty8=0;Frailty9=0;Frailty10=0;Frailty11=0;Frailty12=0;
if f1>0 then Frailty1=1; label Frailty1="Abnormality of gait";
if f2>0 then Frailty2=1; label Frailty2="Abnormal loss of weight and underweight";
if f3>0 then Frailty3=1; label Frailty3="Adult failure to thrive";
if f4>0 then Frailty4=1; label Frailty4="Cachexia";
if f5>0 then Frailty5=1; label Frailty5="Debility ";
if f6>0 then Frailty6=1; label Frailty6="Difficulty in walking ";
if f7>0 then Frailty7=1; label Frailty7="Fall ";
if f8>0 then Frailty8=1; label Frailty8="Muscular wasting and disuse atrophy";
if f9>0 then Frailty9=1; label Frailty9="Muscle weakness";
if f10>0 then Frailty10=1; label Frailty10="Pressure Ulcer";
if f11>0 then Frailty11=1; label Frailty11="Senility without mention of psychosis";
if f12>0 then Frailty12=1; label Frailty12="Durable medical equipment";

keep MemberLinkEID Frailty1 Frailty2 Frailty3 Frailty4 Frailty5 Frailty6 Frailty7 Frailty8 Frailty9 Frailty10 Frailty11 Frailty12;
proc sort nodupkey;by MemberLinkEID;
proc freq;tables Frailty1 Frailty2 Frailty3 Frailty4 Frailty5 Frailty6 Frailty7 Frailty8 Frailty9 Frailty10 Frailty11 Frailty12;
run;
