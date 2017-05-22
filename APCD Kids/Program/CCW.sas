********************************
Chronic Condition for Segment
Xiner Zhou
12/23/2015
********************************;

libname APCD 'C:\data\Data\APCD\Massachusetts\Data\Version 2.0 for High Cost Project';
 

data temp1;
set APCD.kid2012;
dx=dx1;output;dx=dx2;output;dx=dx3;output;dx=dx4;output;dx=dx5;output;dx=dx6;output;dx=dx7;output;
dx=dx8;output;dx=dx9;output;dx=dx10;output;dx=dx11;output;dx=dx12;output;dx=dx13;output;

keep MemberLinkEID dx;
proc sort nodupkey;by MemberLinkEID dx;
run;

data temp2;
set temp1;
ccw1=0;ccw2=0;ccw3=0;ccw4=0;ccw5=0;ccw6=0;ccw7=0;
if dx in ( '41001', '41011', '41021','41031', '41041', '41051','41061', '41071', '41081','41091') then ccw1=1;label ccw1='Acute Myocardial Infarction';

if dx in ( '41000', '41001', '41002','41010', '41011', '41012','41020', '41021', '41022','41030', '41031', '41032','41040', '41041', '41042','41050', '41051', '41052',
'41060', '41061', '41062','41070', '41071', '41072','41080', '41081', '41082','41090', '41091', '41092','4110', '4111', '41181','41189', '412', '4130', '4131',
'4139', '41400', '41401','41402', '41403', '41404','41405', '41406', '41407','41412', '4142', '4143','4144', '4148', '4149') then ccw2=1;label ccw2="Ischemic Heart Disease";

if dx in ( '60000', '60001', '60010','60011', '60020', '60021','6003', '60090', '60091') then ccw3=1;label ccw3="Benign Prostatic Hyperplasia";
  
if dx in ( '39891', '40201', '40211','40291', '40401', '40403','40411', '40413', '40491','40493', '4280', '4281','42820', '42821', '42822',
'42823', '42830', '42831','42832', '42833', '42840','42841', '42842', '42843','4289' ) then ccw4=1;label ccw4="Heart Failure";

if dx in ("2900","29010","29011","29012","29013","29020","29021","2903","29040","29041","29042","29043",
            "2940","29410","29411","29420","29421","2948",
           "3310","33111","33119","3312","3317","797") then ccw5=1;label ccw5="Alzheimer's Disease and Related Disorders or Senile Dementia";

		 


if dx in ( '2720', '2721', '2722','2723', '2724') then ccw6=1;label ccw6="Hyperlipidemia";

if dx in ( '36211', '4010', '4011','4019', '40200', '40201','40210', '40211', '40290','40291', '40300', '40301',
'40310', '40311', '40390','40391', '40400', '40401','40402', '40403', '40410','40411', '40412', '40413','40490', '40491', '40492','40493', '40501', '40509',
'40511', '40519', '40591','40599', '4372') then ccw7=1;label ccw7="Hypertension";
proc sort;by MemberLinkEID;
run;

proc sql;
create table temp3 as
select MemberLinkEID, sum(ccw1) as ccw1,sum(ccw2) as ccw2,sum(ccw3) as ccw3,sum(ccw4) as ccw4,sum(ccw5) as ccw5,
sum(ccw6) as ccw6,sum(ccw7) as ccw7
from temp2
group by MemberLinkEID;
quit;

data APCD.kidCCW2012;
set temp3;
if ccw1>0 then ccw1=1;label ccw1='Acute Myocardial Infarction';
if ccw2>0 then ccw2=1;label ccw2="Ischemic Heart Disease";
if ccw3>0 then ccw3=1;label ccw3="Benign Prostatic Hyperplasia";
if ccw4>0 then ccw4=1;label ccw4="Heart Failure";
if ccw5>0 then ccw5=1;label ccw5="Alzheimer's Disease and Related Disorders or Senile Dementia";
if ccw6>0 then ccw6=1;label ccw6="Hyperlipidemia";
if ccw7>0 then ccw7=1;label ccw7="Hypertension";
proc sort nodupkey;by MemberLinkEID;
run;


