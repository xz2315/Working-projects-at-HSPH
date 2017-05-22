******************************************
- Major inpatient procedures (Winta’s previous list): 
gastrectomy, esophagectomy, nephrectomy, cystectomy, 
pancreatectomy, liver resection, pneumonectomy, lung lobectomy, 
aortic or mitral valve replacement, coronary artery bypass, 
abdominal aortic aneurysm repair, 
carotid endarterectomy(3812 HEAD & NECK ENDARTER NEC
Exclude cases:
• MDC 14 (pregnancy, childbirth, and puerperium) ), 
lower extremity bypass, above-knee amputation, colon or rectal resection, 
exploratory laparotomy, or small bowel resection.

- Solid organ transplant (ICD-9 diagnosis codes for Kidney V42.0, Heart V42.1, Lung V42.6, Liver V42.7, Pancreas V42.83)

- Low risk inpatient procedures (Winta’s readmission and mortality) – 
total hip replacement, total knee replacement, cholecystectomy, appendectomy.

******************************************;

libname ip 'I:\Data\Medicare\Inpatient';
libname denom 'C:\data\Data\Medicare\Denominator';
libname op 'C:\data\Data\Medicare\Outpatient';
 
*Population: 65+ FFS Medicare benes, 20% op;
data bene2014  ; 
set denom.dnmntr2014;   
if age>=65;

if DEATH_DT ne . then
fullAB  = (A_MO_CNT =month(DEATH_DT) and B_MO_CNT =month(DEATH_DT)) ;
else if year(COVSTART)=2014 then 
fullAB  = (A_MO_CNT >=(13-month(COVSTART)) and B_MO_CNT >=(13-month(COVSTART))) ;
else 
fullAB  = (A_MO_CNT = 12 and B_MO_CNT = 12) ;

if hmo_mo=0 ;

if STRCTFLG in ('15','05');  

if fullAB =1 and State_CD*1 ne 40 and State_CD*1>=1 and State_CD*1<=53  ;
 
run;  
 
 


data ip2014;
set ip.Inptclms2014; 

srg_Gastr=0; 
srg_esophag=0;    
srg_nephr=0;          
srg_cyst=0;     
srg_pancreat=0; 
srg_liver=0; 
srg_pneum=0; 
srg_lob=0;              
srg_AMVR=0; 
srg_cabg=0; 
srg_AAArepair=0; 
srg_carend=0;
srg_leb=0;
srg_aboveknee=0;
srg_ColonRectal=0; 
srg_explap=0; 
srg_bowel=0; 

srg_hip=0;    
srg_knee=0;
srg_chole=0;
srg_app=0;

trans_Kidney=0;
trans_Heart=0;
trans_Lung=0;
trans_Liver=0; 
trans_Pancreas=0; 

label srg_Gastr='gastrectomy';  
label srg_esophag='esophagectomy';
label srg_nephr='nephrectomy';   
label srg_cyst='cystectomy';    
label srg_pancreat='pancreatectomy';
label srg_liver='liver resection';  
label srg_pneum='pneumonectomy';    
label srg_lob='lung lobectomy';       
label srg_AMVR=='aortic or mitral valve replacement';
label srg_cabg='coronary artery bypass';
label srg_AAArepair="abdominal aortic aneurysm repair";
label  srg_carend='carotid endarterectomy';
label  srg_leb='lower extremity bypass';
label srg_aboveknee='above-knee amputation';
label srg_ColonRectal='colon or rectal resection';
label srg_explap='exploratory laparotomy';
label srg_bowel='small bowel resection';



label srg_hip='hip replacement';    
label srg_knee='knee replacement';
label srg_chole='cholecystectomy';
label srg_app='appendectomy';

label trans_Kidney='Kidney transplant';
label trans_Heart='Heart transplant';
label trans_Lung='Lung transplant';
label trans_Liver='Liver transplant'; 
label trans_Pancreas='Pancreas transplant';
 
                                                                                                                                                                     
if ICD_PRCDR_CD1 in ("435", "436", "437", "437", "4381", "4389", "4391", "4399") then srg_Gastr=1;
if ICD_PRCDR_CD1 in ("4240", "4241", "4242") then srg_esophag=1;
if ICD_PRCDR_CD1 in ("554", "5552", "5554") then srg_nephr=1;
if ICD_PRCDR_CD1 in ("5779", "576", "5771") then srg_cyst=1;
if ICD_PRCDR_CD1 in ("5251", "5252", "5253", "5259", "526", "527") then srg_pancreat=1;
if ICD_PRCDR_CD1 in ("5022", "503", "504") then srg_liver=1;
if ICD_PRCDR_CD1 in ("325", "3250", "3259") then srg_pneum=1;
if ICD_PRCDR_CD1 in ("3241", "3249", "3230", "3239") then srg_lob=1;
if ICD_PRCDR_CD1 in ("3521", "3522","3523", "3524") then srg_AMVR=1;
if ICD_PRCDR_CD1 in ("3610", "3611", "3612", "3613", "3614", "3615", "3616", "3617", "3619") then srg_cabg=1;
if ICD_PRCDR_CD1 in ("3864", "3834", "3844","3971", "3973") then srg_AAArepair=1;
if ICD_PRCDR_CD1 in ("3812") then srg_carend=1;
if ICD_PRCDR_CD1 in ("3925", "3929") then srg_LEB=1;
if ICD_PRCDR_CD1 in ("8417") then srg_aboveknee=1;                                                         
if ICD_PRCDR_CD1 in ("1731", "1732", "1733", "1734", "1735", "1736", "1739", "4503", "4526", "4541", "4549", "4552",
"4571", "4572", "4573", "4574", "4575", "4576", "4579", "4572", "4581", "4582", "4583",
"4852", "4859", "4861", "4862", "4863", "4864", "4869") then srg_ColonRectal=1;
if ICD_PRCDR_CD1 in ("5411", "5412", "5419") then srg_explap=1;                                                          
if ICD_PRCDR_CD1 in ("4531", "4532", "4533", "4534", "4551", "4561", "4562", "4563", "4591", "4602") then srg_bowel=1;  

if ICD_PRCDR_CD1 in ("8151", "8152") then srg_hip=1;
if ICD_PRCDR_CD1 in ("8154") then srg_knee=1; 
if ICD_PRCDR_CD1 in ("512", "5122", "5121", "5103", "5104", "5123", "5124") then srg_chole=1;
if ICD_PRCDR_CD1 in ("4701", "4709", "472", "4791") then srg_app=1;
 
if PRNCPAL_DGNS_CD='V420' then trans_Kidney=1;
if PRNCPAL_DGNS_CD='V421' then trans_Heart=1;
if PRNCPAL_DGNS_CD='V426' then trans_Lung=1;
if PRNCPAL_DGNS_CD='V427' then trans_Liver=1;
if PRNCPAL_DGNS_CD='V4283' then trans_Pancreas=1;
 
if srg_Gastr=1 or srg_esophag=1 or srg_nephr=1 or srg_cyst=1 or srg_pancreat=1 or srg_liver=1 or srg_pneum=1 or  srg_lob=1 or             
srg_AMVR=1 or  srg_cabg=1 or srg_AAArepair=1 or srg_carend=1 or srg_leb=1 or srg_aboveknee=1 or srg_ColonRectal=1 or srg_explap=1 or 
srg_bowel=1 or srg_hip=1 or srg_knee=1 or srg_chole=1 or srg_app=1 or trans_Kidney=1 or trans_Heart=1 or trans_Lung=1 or trans_Liver=1 or trans_Pancreas=1; 

keep bene_id clm_id PRNCPAL_DGNS_CD ICD_PRCDR_CD1 PRCDR_DT1 FROM_DT thru_dt ADMSN_DT DSCHRGDT
srg_Gastr srg_esophag  srg_nephr srg_cyst srg_pancreat srg_liver srg_pneum srg_lob             
srg_AMVR srg_cabg srg_AAArepair srg_carend srg_leb srg_aboveknee srg_ColonRectal
srg_explap srg_bowel srg_hip   srg_knee srg_chole srg_app
trans_Kidney trans_Heart trans_Lung trans_Liver trans_Pancreas; 
 
proc freq;tables
srg_Gastr srg_esophag  srg_nephr srg_cyst srg_pancreat srg_liver srg_pneum srg_lob             
srg_AMVR srg_cabg srg_AAArepair srg_carend srg_leb srg_aboveknee srg_ColonRectal
srg_explap srg_bowel srg_hip   srg_knee srg_chole srg_app
trans_Kidney trans_Heart trans_Lung trans_Liver trans_Pancreas/missing;
run;

proc sql;
create table Surg2014 as
select a.*,b.death_dt
from ip2014 a inner join bene2014 b
on a.bene_id=b.bene_id;
quit;





** Identify ED visits;
proc sql;
create table IPed as
select bene_id, clm_id,  ADMSN_DT as Date,  PRNCPAL_DGNS_CD as Dx
from ip.Inptclms2014
where clm_id in (select clm_id from ip.Inptrev2014 where REV_CNTR in ('0450','0451','0452','0456','0459','0981'))
and bene_id in (select bene_id from bene2014);
quit;

proc sql;
create table OPtemp1 as
select bene_id, clm_id, FROM_DT as Date,  PRNCPAL_DGNS_CD as Dx
from op.Otptclms2014
where clm_id in (select clm_id from op.Otptrev2014 where REV_CNTR in ('0450','0451','0452','0456','0459','0981'))
and bene_id in (select bene_id from bene2014);
quit;
* Observation room indicator;
proc sql;
create table OPtemp2 as
select *, case when clm_id in (select clm_id from op.Otptrev2014 where REV_CNTR in ('0762')) then 1 else 0 end as Obs
from OPtemp1 ;
quit;
* cost;
proc sort data=op.Otptrev2014 out=Otptrev2014;where REV_CNTR in ('0450','0451','0452','0456','0459','0981');
by clm_id;
run;
data Otptrev2014;set Otptrev2014;PMT=RPRVDPMT+PTNTRESP;run;
proc sql;
create table cost as
select clm_id, sum(PMT) as cost
from Otptrev2014
group by clm_id;
quit;
proc sort data=cost nodupkey;by clm_id;run;

proc sql;
create table OPed as
select a.*,b.*
from OPtemp2 a left join cost b
on a.clm_id=b.clm_id;
quit;

data ED2014;
set IPed(in=in1) OPed(in=in2);
if in1 then type="IP";
else if in2 then type="OP";
run;
 
* CCS;
libname ccs 'I:\Data\Medicare\CCS\Data';
proc sql;
create table ED2014CCS as
select a.*,b.*
from ED2014 a left join ccs.Ccsicd92015 b
on a.Dx=b.icd9;
quit;


** 30-day Episode;
proc sql;
create table temp1 as
select a.*,b.*
from Surg2014 a left join ED2014CCS b
on a.bene_id=b.bene_id;
quit;

data temp2;
set temp1;
if death_dt-PRCDR_DT1>=0 and death_dt-PRCDR_DT1<=30 then died=1;else died=0;
if  died=0; 
if Date-PRCDR_DT1>=0 and Date-PRCDR_DT1<=30 then within30=1;else within30=0;
proc sort;by clm_id;
run;

* total ED;
proc sql;
create table temp3 as
select *,sum(within30) as t_within30
from temp2
group by clm_id;
quit;
proc sort data=temp3 nodupkey;by clm_id;
run;
* IP;
proc sql;
create table temp4 as
select clm_id,sum(within30) as ip_within30
from temp2
where type='IP'
group by clm_id
;
quit;
proc sort data=temp4 nodupkey;by clm_id;
run;
*OP;
proc sql;
create table temp5 as
select clm_id,sum(within30) as op_within30,sum(cost) as totalcost, sum(obs) as totalobs
from temp2
where type='OP'
group by clm_id
;
quit;
proc sort data=temp5 nodupkey;by clm_id;
run;

data temp6;
merge temp3(in=in1) temp4 temp5;
by clm_id;if in1=1;
run;

data temp7;
set temp6;
if ip_within30=. then ip_within30=0;
if op_within30=. then op_within30=0;
if totalcost=. then totalcost=0;
if totalobs=. then totalobs=0;
if op_within30=0 then totalcost=0;
drop within30;
run;

* Number of surgical procedure and 0 ED visits ;
proc tabulate data=temp7 noseps;
class srg_cabg srg_ColonRectal srg_hip   srg_knee t_within30;

table (srg_cabg srg_ColonRectal srg_hip   srg_knee), N t_within30/RTS=25;
 run;
 * OP ED resulting in observation;
proc tabulate data=temp7 noseps;
class srg_cabg srg_ColonRectal srg_hip   srg_knee  ;
var t_within30 totalobs;
table (srg_cabg srg_ColonRectal srg_hip   srg_knee),t_within30*(mean sum) totalobs*(mean sum)/RTS=25;
 run;
* Distribution of OP ED visits n and %;
proc tabulate data=temp7 noseps;
class srg_cabg srg_ColonRectal srg_hip   srg_knee  op_within30;
table (srg_cabg srg_ColonRectal srg_hip   srg_knee),op_within30*(n rowpctn)  /RTS=25;
 run;
* Mean and Total OP ED visitsi cost per procedure;
proc tabulate data=temp7 noseps;
class srg_cabg srg_ColonRectal srg_hip   srg_knee  op_within30;
var totalcost;
table (srg_cabg srg_ColonRectal srg_hip   srg_knee),totalcost*(mean sum)  /RTS=25;
 run;

proc tabulate data=temp7 noseps;
where op_within30>0;
class srg_cabg srg_ColonRectal srg_hip   srg_knee  op_within30;
var totalcost;
table (srg_cabg srg_ColonRectal srg_hip   srg_knee),totalcost*(mean sum)  /RTS=25;
 run;


* c) Mean number of ED visits (inpatient plus outpatient) per procedure type;
proc tabulate data=temp7 noseps;
class  srg_Gastr srg_esophag  srg_nephr srg_cyst srg_pancreat srg_liver srg_pneum srg_lob             
srg_AMVR srg_cabg srg_AAArepair srg_carend srg_leb srg_aboveknee srg_ColonRectal
srg_explap srg_bowel srg_hip   srg_knee srg_chole srg_app ;
var  t_within30 ip_within30 op_within30 ;

table (
srg_Gastr srg_esophag  srg_nephr srg_cyst srg_pancreat srg_liver srg_pneum srg_lob             
srg_AMVR srg_cabg srg_AAArepair srg_carend srg_leb srg_aboveknee srg_ColonRectal
srg_explap srg_bowel srg_hip   srg_knee srg_chole srg_app), N
 t_within30*(mean*f=15.5 sum) ip_within30*(mean*f=15.5 sum) op_within30*(mean*f=15.5 sum)  /RTS=25;
 run;


* d) Look at patterns of ED visits. Proportion of patients with 0, 1, 2, 3… etc for each procedure;
proc tabulate data=temp7 noseps;
class  srg_Gastr srg_esophag  srg_nephr srg_cyst srg_pancreat srg_liver srg_pneum srg_lob             
srg_AMVR srg_cabg srg_AAArepair srg_carend srg_leb srg_aboveknee srg_ColonRectal
srg_explap srg_bowel srg_hip   srg_knee srg_chole srg_app  
 t_within30 ip_within30 op_within30 ;

table (
srg_Gastr srg_esophag  srg_nephr srg_cyst srg_pancreat srg_liver srg_pneum srg_lob             
srg_AMVR srg_cabg srg_AAArepair srg_carend srg_leb srg_aboveknee srg_ColonRectal
srg_explap srg_bowel srg_hip   srg_knee srg_chole srg_app), 
 t_within30*(N rowpctn)   /RTS=25;
 run;



* f)	Take top 5 procedures with highest average ED utilization ;
* g)	Top 5 diagnoses at time of presentation to ED associated with those procedures – HCUP CCS scores (Laura says you have this) ;
proc freq data=temp7;
where type ne '' and  (srg_cyst=1 or srg_explap=1 or  srg_bowel=1 or   srg_chole=1 or  srg_app=1);
tables dxdescription/missing out =temp8;
run;
proc sort data=temp8 ;by descending percent ;run;
proc print data=temp8;run;


%macro pervar(var,label);
proc freq data=clm;
title &label.;
where &var.=1;
tables t_ipop_within30;
run;
%mend pervar;
%pervar(var=srg_Gastr,label='gastrectomy');
%pervar(var=srg_esophag,label='esophagectomy');
%pervar(var=srg_nephr,label='nephrectomy');
%pervar(var=srg_cyst,label='cystectomy');
%pervar(var=srg_pancreat,label='pancreatectomy');
%pervar(var=srg_liver,label='liver resection');
%pervar(var=srg_pneum,label='pneumonectomy');
%pervar(var=srg_lob,label='lung lobectomy');
%pervar(var=srg_AMVR,label='aortic or mitral valve replacement');
%pervar(var=srg_cabg,label='coronary artery bypass');
%pervar(var=srg_AAArepair,label='abdominal aortic aneurysm repair');    
%pervar(var=srg_carend,label='carotid endarterectomy');
%pervar(var=srg_leb,label='lower extremity bypass');  
%pervar(var=srg_aboveknee,label='above-knee amputation');
%pervar(var=srg_ColonRectal,label='colon or rectal resection');    
%pervar(var=srg_explap,label='exploratory laparotomy');
%pervar(var=srg_bowel,label='small bowel resection'); 
%pervar(var=srg_hip,label='hip replacement');
%pervar(var=srg_knee,label='knee replacement');
%pervar(var=srg_chole,label='cholecystectomy');
%pervar(var=srg_app,label='appendectomy');
 
*/
