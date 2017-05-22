**********************
Prepare for PQI 
Xiner Zhou
4/17/2017
*********************;
libname APCD 'D:\data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';
libname score	"D:\Projects\Scorecard\data";

proc sql;
create table temp1 as
select MemberLinkEID, Admission,  Discharge ,Final_DRG as DRG, DRGVersion as DRGVER, gender, age,
AdmissionSource, DischargeStatus,
PrincipalDx as DX1, SecondaryDx1 as DX2,SecondaryDx2 as DX3,SecondaryDx3 as DX4,SecondaryDx4 as DX5,
SecondaryDx5 as DX6,SecondaryDx6 as DX7,SecondaryDx7 as DX8,SecondaryDx8 as DX9,SecondaryDx9 as DX10, 
SecondaryDx10 as DX11, SecondaryDx11 as DX12, SecondaryDx12 as DX13,

ICD9Procedure as PR1, OtherICD9Procedure1 as PR2,  OtherICD9Procedure2 as PR3,  
OtherICD9Procedure3  as PR4, OtherICD9Procedure4 as PR5, OtherICD9Procedure5  as PR6, OtherICD9Procedure6 as PR7 
from APCD.ipstdcost
where memberlinkeid in (select memberlinkeid from APCD.Analyticdatakidcost) ;
quit;

* Identify transfer;
proc sort data=temp1;by memberlinkeid Admission Discharge; run; 
data temp2;
set temp1;
L_memberlinkeid=lag(memberlinkeid);
L_Discharge=lag(Discharge);
if L_memberlinkeid=memberlinkeid and Admission=L_Discharge then xfer=1;else xfer=0;
run;


data temp3;
set temp2;

SEXCAT=.;
if gender="F" then SEXCAT=2;else if gender="M" then SEXCAT=1;

AGEDAY=.;
PSTCO=.;
RACE=.;

PAY1=3; 
PAY2=.;

year=year(Discharge);
if year(Discharge)=2012; 

DQTR = . ; 
if month(Discharge) in (1,2,3) then DQTR = 1; 
if month(Discharge) in (4,5,6) then DQTR = 2; 
if month(Discharge) in (7,8,9) then DQTR = 3; 
if month(Discharge) in (10,11,12) then DQTR = 4;  
DNR=.;


ATYPE = .; 
ASOURCE = .; 
if AdmissionSource = '7' then ASOURCE = 1; 
if AdmissionSource = '4' then ASOURCE = 2; 
if xfer = 1 then ASOURCE = 2; 
if AdmissionSource IN ('5','6') then ASOURCE = 3; 
if AdmissionSource = '8' then ASOURCE = 4; 
if AdmissionSource IN ('1','2','3') then ASOURCE = 5;


DISP=DischargeStatus;
POINTOFORIGINUB04 = " "; 
if AdmissionSource = '4' then POINTOFORIGINUB04 = '4'; 
if xfer = 1 then POINTOFORIGINUB04 = '4'; 
if AdmissionSource = '5' then POINTOFORIGINUB04 = '5'; 
if AdmissionSource = '6' then POINTOFORIGINUB04 = '6'; 

run;
KEY HOSPID DRG DRGVER MDC SEX AGE AGEDAY PSTCO 
            RACE YEAR DQTR PAY1 PAY2 DNR
            DISP LOS ASOURCE POINTOFORIGINUB04 ATYPE
            DX1-DX&NDX. PR1-PR&NPR. %ADDPRDAY 
            DXPOA1-DXPOA&NDX.
