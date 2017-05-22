***************************************
Mental Health Indicators  
Xiner Zhou
1/3/2017
***************************************;

libname APCD 'C:\data\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';

data temp;
set APCD.temp2012;
DX=dx1;output;DX=dx2;output;DX=dx3;output;DX=dx4;output;DX=dx5;output;DX=dx6;output;
DX=dx7;output;DX=dx8;output;DX=dx9;output;DX=dx10;output;DX=dx11;output;DX=dx12;output;DX=dx13;output;
keep MemberLinkEID DX;
run;

proc sort data=temp nodupkey;by MemberLinkEID DX;run;

data temp;
set temp;
mental=0; mental1=0; mental2=0; mental3=0; 
if substr(DX,1,3) in ('290','291','292','293','294','295','296','297','298','299') then mental1=1;label mental1="Psychosis";
if substr(DX,1,3) in ('300','301','302','303','304','305','306','307','308','309','310','311','312','313','314','315','316' ) then mental2=1;label mental2="Neurotic disorders, personality disorders, and other nonpsychotic mental disorders";
if substr(DX,1,3) in ('317','318','319') then mental3=1;label mental3="Mental retardation";

if mental1=1 or mental2=1 or mental3=1 then mental=1;
proc sort;by MemberlinkEID;
run;

proc sql;
create table temp1 as
select MemberLinkEID, sum(mental1) as mental1,sum(mental2) as mental2,sum(mental3) as mental3,sum(mental) as mental 
from temp
group by MemberLinkEID;
quit;

data APCD.Mental2012;
set temp1;
if mental1>0 then mental1=1;label mental1="Psychosis";
if mental2>0 then mental2=1;label mental2="Neurotic disorders, personality disorders, and other nonpsychotic mental disorders";
if mental3>0 then mental3=1;label mental3="Mental retardation";

if mental>0 then mental=1;label mental="Mental Health";
keep MemberLinkEID mental1 mental2 mental3 mental;
proc sort nodupkey;by MemberLinkEID;
run;


