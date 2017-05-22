*******************************************
Extract APCD kids claims for 2012
Xiner Zhou
4/12/2017
*******************************************;

libname APCD 'D:\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';
libname data 'D:\Projects\APCD Kids\Data';

proc sql;
create table temp1 as
select MemberLinkEID, DateofServiceTo,
AdmittingDiagnosisCleaned as AdmissionDx, DischargeDiagnosisCleaned as DischargeDx, 
PrincipalDiagnosisCleaned as Dx1, 
OtherDiagnosis1Cleaned as Dx2, OtherDiagnosis2Cleaned as Dx3, OtherDiagnosis3Cleaned as Dx4, 
OtherDiagnosis4Cleaned as Dx5, OtherDiagnosis5Cleaned as Dx6, OtherDiagnosis6Cleaned as Dx7, 
OtherDiagnosis7Cleaned as Dx8, OtherDiagnosis8Cleaned as Dx9, OtherDiagnosis9Cleaned as Dx10, 
OtherDiagnosis10Cleaned as Dx11, OtherDiagnosis11Cleaned as Dx12, OtherDiagnosis12Cleaned as Dx13,


ICD9CMProcedureCodeCleaned as pc1, 
OtherICD9CMProcedureCode1Cleaned as pc2, OtherICD9CMProcedureCode2Cleaned as pc3,
OtherICD9CMProcedureCode3Cleaned as pc4, OtherICD9CMProcedureCode4Cleaned as pc5,
OtherICD9CMProcedureCode5Cleaned as pc6, OtherICD9CMProcedureCode6Cleaned as pc7

from APCD.Medical 
where memberlinkeid in (select memberlinkeid from APCD.Analyticdatakidcost) ;
quit;
 
data data.KidClm2012;
set temp1;
year=year(datepart(DateofServiceTo));
if year=2012;
keep MemberLinkEID year Dx1-Dx13 pc1-pc7;
proc freq;tables year/missing;
run;
 


 

