************************************************************************************
Persistent Medicare HC 2012-2014 -Jose
Cost and Util  
Xiner Zhou
3/21/2017
************************************************************************************;
libname data 'D:\Projects\High Cost Segmentation Phase II\Data';
libname denom 'D:\Data\Medicare\Denominator';
libname stdcost 'D:\Data\Medicare\StdCost\Data';
 
%macro bene(yr);
 
* IP;
proc sql;
create table temp1&yr. as
select a.*,b.stdcost  as stdcostIP1&yr., b.LOS as LOSIP1&yr., b.numclm as numclmIP1&yr.
from data.PlanABene a left join (select * from data.Utilip&yr. where  clm1='Inpatient Hospital (Acute Hospital)') b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp2&yr. as
select a.*,b.stdcost  as stdcostIP2&yr., b.LOS as LOSIP2&yr., b.numclm as numclmIP2&yr.
from temp1&yr. a left join (select * from data.Utilip&yr. where clm1="Critical Access Hospital (CAH) - Inpatient Services") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp3&yr. as
select a.*,b.stdcost  as stdcostIP3&yr., b.LOS as LOSIP3&yr., b.numclm as numclmIP3&yr.
from temp2&yr. a left join (select * from data.Utilip&yr. where  clm1='Inpatient Psychiatric Facility (IPF)') b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp4&yr. as
select a.*, b.stdcost  as stdcostIP4&yr., b.LOS as LOSIP4&yr., b.numclm as numclmIP4&yr.
from temp3&yr. a left join (select * from data.Utilip&yr. where clm1='Long-Term Care Hospital (LTCH)') b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp5&yr. as
select a.*,b.stdcost  as stdcostIP5&yr., b.LOS as LOSIP5&yr., b.numclm as numclmIP5&yr.
from temp4&yr. a left join (select * from data.Utilip&yr. where clm1='Inpatient Rehabilitation Facility (IRF)') b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp6&yr. as
select a.*,b.stdcost  as stdcostIP6&yr., b.LOS as LOSIP6&yr., b.numclm as numclmIP6&yr.
from temp5&yr. a left join (select * from data.Utilip&yr. where clm1="Other Inpatient") b
on a.bene_id=b.bene_id
;
quit;

* OP;
proc sql;
create table temp7&yr. as
select a.*,b.stdcost  as stdcostOP&yr., b.numclm as numclmOP&yr.
from temp6&yr. a left join  data.Utilop&yr.  b
on a.bene_id=b.bene_id
;
quit;

* carrier;
proc sql;
create table temp8&yr. as
select a.*,b.stdcost  as stdcostcar1&yr., b.numclm as numclmcar1&yr.
from temp7&yr. a left join (select * from data.Utilcarrier&yr. where clm1="Evaluation AND Management") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp9&yr. as
select a.*,b.stdcost  as stdcostcar2&yr.,b.numclm as numclmcar2&yr.
from temp8&yr. a left join (select * from data.Utilcarrier&yr. where clm1="Procedures") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp10&yr. as
select a.*,b.stdcost  as stdcostcar3&yr., b.numclm as numclmcar3&yr.
from temp9&yr. a left join (select * from data.Utilcarrier&yr. where clm1="Imaging") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp11&yr. as
select a.*,b.stdcost  as stdcostcar4&yr., b.numclm as numclmcar4&yr.
from temp10&yr. a left join (select * from data.Utilcarrier&yr. where clm1="Tests") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp12&yr. as
select a.*,b.stdcost  as stdcostcar5&yr., b.numclm as numclmcar5&yr.
from temp11&yr. a left join (select * from data.Utilcarrier&yr. where clm1="Durable Medical Equipment") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp13&yr. as
select a.*,b.stdcost  as stdcostcar6&yr., b.numclm as numclmcar6&yr.
from temp12&yr. a left join (select * from data.Utilcarrier&yr. where clm1="Other Services") b
on a.bene_id=b.bene_id
;
quit;

proc sql;
create table temp14&yr. as
select a.*,b.stdcost as stdcostcar7&yr., b.numclm as numclmcar7&yr.
from temp13&yr. a left join (select * from data.Utilcarrier&yr. where clm1="Unclassified") b
on a.bene_id=b.bene_id
;
quit;
 
* HHA;
proc sql;
create table temp15&yr. as
select a.*,b.stdcost  as stdcostHHA&yr., b.LOS as LOSHHA&yr., b.numclm as numclmHHA&yr., b.HHAvisit as HHAvisit&yr.
from temp14&yr. a left join  data.UtilHHA&yr.  b
on a.bene_id=b.bene_id;
quit;
 
* SNF;
proc sql;
create table temp16&yr. as
select a.*,b.stdcost  as stdcostSNF&yr., b.LOS as LOSSNF&yr., b.numclm as numclmSNF&yr.
from temp15&yr. a left join  data.UtilSNF&yr.  b
on a.bene_id=b.bene_id
;
quit;


* Hospice;
proc sql;
create table temp17&yr. as
select a.*,b.stdcost  as stdcostHospice&yr.,  b.LOS as LOSHospice&yr., b.numclm as numclmHospice&yr.
from temp16&yr. a left join  data.UtilHospice&yr.  b
on a.bene_id=b.bene_id
;
quit;

* DME;
proc sql;
create table temp18&yr. as
select a.*,b.stdcost  as stdcostDME&yr.,b.numclm as numclmDME&yr.
from temp17&yr. a left join  data.UtilDME&yr.  b
on a.bene_id=b.bene_id
;
quit;
 
data temp19&yr. ;
set temp18&yr. ;

array temp {46} 
LOSIP1&yr. LOSIP2&yr. LOSIP3&yr. LOSIP4&yr. LOSIP5&yr. LOSIP6&yr. LOSHHA&yr. LOSSNF&yr. LOSHospice&yr. 
HHAvisit&yr.
numclmIP1&yr. numclmIP2&yr. numclmIP3&yr. numclmIP4&yr. numclmIP5&yr. numclmIP6&yr. 
numclmOp&yr. numclmCar1&yr. numclmCar2&yr. numclmCar3&yr. numclmCar4&yr. numclmCar5&yr. numclmCar6&yr. numclmCar7&yr.  
numclmHHA&yr. numclmSNF&yr. numclmHospice&yr. numclmDME&yr. 

stdcostIP1&yr. stdcostIP2&yr. stdcostIP3&yr. stdcostIP4&yr. stdcostIP5&yr. stdcostIP6&yr. 
stdcostOp&yr. stdcostCar1&yr. stdcostCar2&yr. stdcostCar3&yr. stdcostCar4&yr. stdcostCar5&yr. stdcostCar6&yr. stdcostCar7&yr.  
stdcostHHA&yr. stdcostSNF&yr. stdcostHospice&yr. stdcostDME&yr.
;

do i=1 to 46;
 if temp{i}=. then temp{i}=0;
end;drop i;
 

stdcostIP&yr.=stdcostIP1&yr.+stdcostIP2&yr.+stdcostIP3&yr.+stdcostIP4&yr.+stdcostIP5&yr.+stdcostIP6&yr.;

stdcostCar&yr.=stdcostCar1&yr.+stdcostCar2&yr.+stdcostCar3&yr.+stdcostCar4&yr.+stdcostCar5&yr.+stdcostCar6&yr.+stdcostCar7&yr.;

LOSIP&yr.=LOSIP1&yr.+LOSIP2&yr.+LOSIP3&yr.+LOSIP4&yr.+LOSIP5&yr.+LOSIP6&yr.;

numclmIP&yr.=numclmIP1&yr.+numclmIP2&yr.+numclmIP3&yr.+numclmIP4&yr.+numclmIP5&yr.+numclmIP6&yr.;

numclmCar&yr.=numclmCar1&yr.+numclmCar2&yr.+numclmCar3&yr.+numclmCar4&yr.+numclmCar5&yr.+numclmCar6&yr.+numclmCar7&yr.;
 

 

label stdcost&yr.="Total cost &yr. ";
label stdcostIP&yr.="Cost: Total Inpatient &yr.";
label stdcostIP1&yr.="Cost: Inpatient Hospital (Acute Hospital) &yr."; 
label stdcostIP2&yr.="Cost: Critical Access Hospital (CAH) - Inpatient Services &yr.";
label stdcostIP3&yr.="Cost: Inpatient Psychiatric Facility (IPF) &yr.";
label stdcostIP4&yr.="Cost: Long-Term Care Hospital (LTCH) &yr.";
label stdcostIP5&yr.="Cost: Inpatient Rehabilitation Facility (IRF) &yr.";
label stdcostIP6&yr.="Cost: Other Inpatient &yr."; 
label stdcostOp&yr.="Cost: Total Outpatient &yr."; 
label stdcostCar&yr.="Cost: Total Carrier &yr."; 
label stdcostCar1&yr.="Cost: Evaluation AND Management &yr."; 
label stdcostCar2&yr.="Cost: Procedures &yr.";  
label stdcostCar3&yr.="Cost: Imaging &yr.";  
label stdcostCar4&yr.="Cost: Tests &yr.";  
label stdcostCar5&yr.="Cost: Durable Medical Equipment &yr.";  
label stdcostCar6&yr.="Cost: Other Services &yr.";  
label stdcostCar7&yr.="Cost: Unclassified &yr.";   
label stdcostHHA&yr.="Cost: Home Health Agency &yr.";  
label stdcostSNF&yr.="Cost: Skilled Nursing Facility &yr."; 
label stdcostHospice&yr.="Cost: Hospice &yr.";  
label stdcostDME&yr.="Cost: Durable Medical Equipment &yr.";  
label stdcostPartD&yr.="Cost: Part D &yr."; 


label LOSIp&yr.="LOS: Total Inpatient &yr.";
label LOSIP1&yr.="LOS: Inpatient Hospital (Acute Hospital) &yr."; 
label LOSIP2&yr.="LOS: Critical Access Hospital (CAH) - Inpatient Services &yr.";   
label LOSIP3&yr.="LOS: Inpatient Psychiatric Facility (IPF) &yr.";  
label LOSIP4&yr.="LOS: Long-Term Care Hospital (LTCH) &yr.";  
label LOSIP5&yr.="LOS: Inpatient Rehabilitation Facility (IRF) &yr."; 
label LOSIP6&yr.="LOS: Other Inpatient &yr.";  
label LOSHHA&yr.="LOS: Home Health Agency &yr.";  
label LOSSNF&yr.="LOS: Skilled Nursing Facility &yr.";   
label LOSHospice&yr.="LOS: Hospice &yr."; 

label HHAvisit&yr.="Number of HHA Visits &yr.";

label numclmIP&yr.="Num of Claims: Total Inpatient &yr.";
label numclmIP1&yr.="Num of Claims: Inpatient Hospital (Acute Hospital) &yr.";  
label numclmIP2&yr.="Num of Claims: Critical Access Hospital (CAH) - Inpatient Services &yr.";  
label numclmIP3&yr.='Num of Claims: Inpatient Psychiatric Facility (IPF) &yr.';  
label numclmIP4&yr.='Num of Claims: Long-Term Care Hospital (LTCH) &yr.';   
label numclmIP5&yr.='Num of Claims: Inpatient Rehabilitation Facility (IRF) &yr.';  
label numclmIP6&yr.="Num of Claims: Other Inpatient &yr.";   
label numclmOp&yr.="Num of Claims: Total Outpatient &yr.";   
label numclmCar&yr.="Num of Claims: Total Carrier &yr."; 
label numclmCar1&yr.="Num of Claims: Evaluation AND Management &yr.";  
label numclmCar2&yr.="Num of Claims: Procedures &yr.";   
label numclmCar3&yr.="Num of Claims: Imaging &yr.";   
label numclmCar4&yr.="Num of Claims: Tests &yr.";   
label numclmCar5&yr.="Num of Claims: Durable Medical Equipment &yr.";  
label numclmCar6&yr.="Num of Claims: Other Services &yr.";  
label numclmCar7&yr.="Num of Claims: Unclassified &yr.";    
label numclmHHA&yr.="Num of Claims: Home Health Agency &yr.";  
label numclmSNF&yr.="Num of Claims: Skilled Nursing Facility &yr.";   
label numclmHospice&yr.="Num of Claims: Hospice &yr.";   
label numclmDME&yr.="Num of Claims: Durable Medical Equipment &yr."; 
*label numclmPartD&yr.="Num of Claims: Part D &yr."; 

 keep bene_id group segment2012 segment2013 segment2014 segment3yr  
 stdcost&yr.
stdcostIP&yr. stdcostIP1&yr. stdcostIP2&yr. stdcostIP3&yr. stdcostIP4&yr. stdcostIP5&yr. stdcostIP6&yr. 
stdcostOp&yr.
stdcostCar&yr. stdcostCar1&yr. stdcostCar2&yr. stdcostCar3&yr. stdcostCar4&yr. stdcostCar5&yr. stdcostCar6&yr. stdcostCar7&yr.  
stdcostHHA&yr. stdcostSNF&yr. stdcostHospice&yr. stdcostDME&yr. stdcostPartD&yr.



LOSIP&yr. LOSIP1&yr. LOSIP2&yr. LOSIP3&yr. LOSIP4&yr. LOSIP5&yr. LOSIP6&yr. LOSHHA&yr. LOSSNF&yr. LOSHospice&yr.
HHAvisit&yr.
numclmIP&yr. numclmIP1&yr. numclmIP2&yr. numclmIP3&yr. numclmIP4&yr. numclmIP5&yr. numclmIP6&yr.
numclmOp&yr. 
numclmCar&yr. numclmCar1&yr. numclmCar2&yr. numclmCar3&yr. numclmCar4&yr. numclmCar5&yr. numclmCar6&yr. numclmCar7&yr.  
numclmHHA&yr. numclmSNF&yr. numclmHospice&yr. numclmDME&yr.

;


run;


%mend bene;
%bene(yr=2012);
%bene(yr=2013);
%bene(yr=2014);



proc sql;
create table temp1 as
select a.*,b.*
from Temp192012 a left join Temp192013 b
on a.bene_id=b.bene_id;
quit;
proc sql;
create table temp2 as
select a.*,b.*
from Temp1  a left join Temp192014 b
on a.bene_id=b.bene_id;
quit;

 
ODS Listing CLOSE;
ODS html file="D:\Projects\High Cost Segmentation Phase II\Cost and Util.xls" style=minimal;
 
proc tabulate data=temp2 noseps  missing;
title "Cost and Utilization";
class  group  segment2012;
var  
stdcost2012
stdcostIP2012 stdcostIP12012 stdcostIP22012 stdcostIP32012 stdcostIP42012 stdcostIP52012 stdcostIP62012 
stdcostOp2012 
stdcostCar2012 stdcostCar12012 stdcostCar22012 stdcostCar32012 stdcostCar42012 stdcostCar52012 stdcostCar62012 stdcostCar72012  
stdcostHHA2012 stdcostSNF2012 stdcostHospice2012 stdcostDME2012 stdcostPartD2012
 

LOSIP2012 LOSIP12012 LOSIP22012 LOSIP32012 LOSIP42012 LOSIP52012 LOSIP62012 LOSHHA2012 LOSSNF2012 LOSHospice2012 
HHAvisit2012
numclmIP2012 numclmIP12012 numclmIP22012 numclmIP32012 numclmIP42012 numclmIP52012 numclmIP62012
numclmOp2012 
numclmCar2012 numclmCar12012 numclmCar22012 numclmCar32012 numclmCar42012 numclmCar52012 numclmCar62012 numclmCar72012  
numclmHHA2012 numclmSNF2012 numclmHospice2012 numclmDME2012 

stdcost2013
stdcostIP2013 stdcostIP12013 stdcostIP22013 stdcostIP32013 stdcostIP42013 stdcostIP52013 stdcostIP62013 
stdcostOp2013 
stdcostCar2013 stdcostCar12013 stdcostCar22013 stdcostCar32013 stdcostCar42013 stdcostCar52013 stdcostCar62013 stdcostCar72013  
stdcostHHA2013 stdcostSNF2013 stdcostHospice2013 stdcostDME2013 stdcostPartD2013
 

LOSIP2013 LOSIP12013 LOSIP22013 LOSIP32013 LOSIP42013 LOSIP52013 LOSIP62013 LOSHHA2013 LOSSNF2013 LOSHospice2013 
HHAvisit2013
numclmIP2013 numclmIP12013 numclmIP22013 numclmIP32013 numclmIP42013 numclmIP52013 numclmIP62013
numclmOp2013 
numclmCar2013 numclmCar12013 numclmCar22013 numclmCar32013 numclmCar42013 numclmCar52013 numclmCar62013 numclmCar72013  
numclmHHA2013 numclmSNF2013 numclmHospice2013 numclmDME2013


stdcost2014
stdcostIP2014 stdcostIP12014 stdcostIP22014 stdcostIP32014 stdcostIP42014 stdcostIP52014 stdcostIP62014 
stdcostOp2014 
stdcostCar2014 stdcostCar12014 stdcostCar22014 stdcostCar32014 stdcostCar42014 stdcostCar52014 stdcostCar62014 stdcostCar72014  
stdcostHHA2014 stdcostSNF2014 stdcostHospice2014 stdcostDME2014 stdcostPartD2014
 

LOSIP2014 LOSIP12014 LOSIP22014 LOSIP32014 LOSIP42014 LOSIP52014 LOSIP62014 LOSHHA2014 LOSSNF2014 LOSHospice2014 
HHAvisit2014
numclmIP2014 numclmIP12014 numclmIP22014 numclmIP32014 numclmIP42014 numclmIP52014 numclmIP62014
numclmOp2014 
numclmCar2014 numclmCar12014 numclmCar22014 numclmCar32014 numclmCar42014 numclmCar52014 numclmCar62014 numclmCar72014  
numclmHHA2014 numclmSNF2014 numclmHospice2014 numclmDME2014
;

table (
stdcost2012 stdcost2013 stdcost2014
stdcostIP2012 stdcostIP2013 stdcostIP2014 
stdcostIP12012 stdcostIP12013 stdcostIP12014
stdcostIP22012 stdcostIP22013  stdcostIP22014 
stdcostIP32012 stdcostIP32013 stdcostIP32014
stdcostIP42012  stdcostIP42013 stdcostIP42014
stdcostIP52012 stdcostIP52013 stdcostIP52014
stdcostIP62012  stdcostIP62013 stdcostIP62014
stdcostOp2012  stdcostOp2013  stdcostOp2014 
stdcostCar2012 stdcostCar2013 stdcostCar2014
stdcostCar12012 stdcostCar12013 stdcostCar12014
stdcostCar22012 stdcostCar22013 stdcostCar22014 
stdcostCar32012 stdcostCar32013 stdcostCar32014 
stdcostCar42012 stdcostCar42013 stdcostCar42014 
stdcostCar52012 stdcostCar52013 stdcostCar52014 
stdcostCar62012 stdcostCar62013 stdcostCar62014 
stdcostCar72012 stdcostCar72013 stdcostCar72014 
stdcostHHA2012 stdcostHHA2013 stdcostHHA2014 
stdcostSNF2012 stdcostSNF2013 stdcostSNF2014 
stdcostHospice2012 stdcostHospice2013 stdcostHospice2014 
stdcostDME2012 stdcostDME2013 stdcostDME2014 
stdcostPartD2012 stdcostPartD2013 stdcostPartD2014 ), 
(group*(mean*f=dollar12.2  sum*f=dollar15.2)  segment2012*(mean*f=dollar12.2  sum*f=dollar15.2)  all*(mean*f=dollar12.2  sum*f=dollar15.2))/RTS=25;
 
table (
LOSIP2012 LOSIP2013 LOSIP2014
LOSIP12012 LOSIP12013 LOSIP12014 
LOSIP22012 LOSIP22013 LOSIP22014 
LOSIP32012 LOSIP32013 LOSIP32014 
LOSIP42012 LOSIP42013 LOSIP42014 
LOSIP52012 LOSIP52013 LOSIP52014
LOSIP62012 LOSIP62013 LOSIP62014 
LOSHHA2012 LOSHHA2013 LOSHHA2014 
LOSSNF2012 LOSSNF2013 LOSSNF2014 
LOSHospice2012 LOSHospice2013 LOSHospice2014 ), 
(group*(mean*f=15.4  sum*f=15.4) segment2012*(mean*f=15.4  sum*f=15.4) all*(mean*f=15.4  sum*f=15.4))/RTS=25;

table ( 
numclmIP2012 numclmIP2013  numclmIP2014   
numclmIP12012  numclmIP12013  numclmIP12014  
numclmIP22012  numclmIP22013 numclmIP22014 
numclmIP32012 numclmIP32013 numclmIP32014  
numclmIP42012 numclmIP42013 numclmIP42014 
numclmIP52012 numclmIP52013 numclmIP52014 
numclmIP62012  numclmIP62013 numclmIP62014 
numclmOp2012 numclmOp2013 numclmOp2014
numclmCar2012 numclmCar2013 numclmCar2014
numclmCar12012 numclmCar12013 numclmCar12014 
numclmCar22012 numclmCar22013 numclmCar22014 
numclmCar32012 numclmCar32013 numclmCar32014 
numclmCar42012 numclmCar42013 numclmCar42014 
numclmCar52012 numclmCar52013 numclmCar52014 
numclmCar62012 numclmCar62013 numclmCar62014 
numclmCar72012  numclmCar72013  numclmCar72014 
numclmHHA2012  numclmHHA2013  numclmHHA2014  
HHAvisit2012 HHAvisit2013 HHAvisit2014
numclmSNF2012  numclmSNF2013  numclmSNF2014  
numclmHospice2012 numclmHospice2013 numclmHospice2014
numclmDME2012 numclmDME2013 numclmDME2014 ), 
(group*(mean*f=15.4  sum*f=15.4) segment2012*(mean*f=15.4  sum*f=15.4) all*(mean*f=15.4  sum*f=15.4))/RTS=25;
Keylabel all="All Bene";
 
run;
 
  ODS html close;
ODS Listing;  
 
 
