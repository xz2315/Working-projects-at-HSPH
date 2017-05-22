*******************************************
Assign patinets to ACO vs non-ACO practice
Xiner Zhou
5/9/2017
*******************************************;
%put Run on %sysfunc (date(), worddatx15. ) at  %sysfunc (time(), time9. ) ;

TITLE2 "Filename:	E:\ACO\step1_create_ACOdata.sas";
TITLE3 "Project:	ACO and High Cost";
TITLE4 "Purpose:	Assign patinets to ACO vs non-ACO practice";

options nocenter ls=132 ps=1000 pageno=1;

libname CMSaco 'D:\data\Medicare\ACO';
libname car 'D:\Data\Medicare\Carrier';
libname op 'D:\Data\Medicare\Outpatient';
libname aco 'D:\Projects\ACO Xiner\data';
libname denom 'D:\Data\Medicare\Denominator';
libname AHA 'D:\data\Hospital\AHA\Annual_Survey\Data';
 
%let yr=2011;
%let cmsyr=2013; 

%let yr=2012;
%let cmsyr=2013; 

%let yr=2013;
%let cmsyr=2013; 

%let yr=2014;
%let cmsyr=2014; 
%macro CAH();
if HCPCS_CD in("99201", "99202", "99203", "99204", "99205", "99211", "99212", "99213", "99214", "99215",
               "99304", "99305", "99306", 
				"99307", "99308", "99309", "99310", 
				"99315", "99316", 
				"99318",
                "99324", "99325", "99326", "99327", "99328", "99334", "99335", "99336", "99337", 
                "99339", "99340", 
                "99341", "99342", "99343", "99344", "99345", "99347", "99348","99349", "99350", "99490","99495","99496",
               "G0402", "G0438", "G0439"  ) 
and
REV_CNTR in ('0960','0961','0962','0963','0964','0969','0971','0972','0973','0974','0975','0976','0977','0978','0979','0981','0982','0983','0984','0985','0986','0987','0988','0989') 

			   			   then PCS=1;else PCS=0;
%mend CAH;
 
/*
For FQHC services furnished prior to 1/1/2011, primary care services include services
identified by HCPCS code G0402 (effective 1/1/2009) or the following revenue center
codes:
*/
%macro FQHC();
if HCPCS_CD in("99201", "99202", "99203", "99204", "99205", "99211", "99212", "99213", "99214", "99215",
               "99304", "99305", "99306", 
				"99307", "99308", "99309", "99310", 
				"99315", "99316", 
				"99318",
                "99324", "99325", "99326", "99327", "99328", "99334", "99335", "99336", "99337", 
                "99339", "99340", 
                "99341", "99342", "99343", "99344", "99345", "99347", "99348","99349", "99350", "99490","99495","99496",
               "G0402", "G0438", "G0439" ) 
			   or 
REV_CNTR in ("0521","0522","0524","0525")
 then PCS=1;else PCS=0;
%mend FQHC;
/*
For RHC services, primary care services include services identified by HCPCS code
G0402 (effective 1/1/2009) or G0438 (effective 1/1/2011), G0439 (effective 1/1/2011) or
the following revenue center codes:
*/
%macro RHC();
if HCPCS_CD in("99201", "99202", "99203", "99204", "99205", "99211", "99212", "99213", "99214", "99215",
               "99304", "99305", "99306", 
				"99307", "99308", "99309", "99310", 
				"99315", "99316", 
				"99318",
                "99324", "99325", "99326", "99327", "99328", "99334", "99335", "99336", "99337", 
                "99339", "99340", 
                "99341", "99342", "99343", "99344", "99345", "99347", "99348","99349", "99350", "99490","99495","99496",
               "G0402", "G0438", "G0439") 
			   or 
REV_CNTR in ("0521","0522","0524","0525")
 then PCS=1;else PCS=0;
%mend RHC;
 
%macro ETA();
if HCPCS_CD in("99201", "99202", "99203", "99204", "99205", "99211", "99212", "99213", "99214", "99215",
               "99304", "99305", "99306", 
				"99307", "99308", "99309", "99310", 
				"99315", "99316", 
				"99318",
                "99324", "99325", "99326", "99327", "99328", "99334", "99335", "99336", "99337", 
                "99339", "99340", 
                "99341", "99342", "99343", "99344", "99345", "99347", "99348","99349", "99350", "99490","99495","99496",
               "G0402", "G0438", "G0439", "G0463") 
 
 then PCS=1;else PCS=0;
%mend ETA;

%macro Carrier();
if (HCPCS_CD in("99201", "99202", "99203", "99204", "99205", "99211", "99212", "99213", "99214", "99215",
               "99304", "99305", "99306", 
				"99307", "99308", "99309", "99310", 
				"99315", "99316", 
				"99318",
                "99324", "99325", "99326", "99327", "99328", "99334", "99335", "99336", "99337", 
                "99339", "99340", 
                "99341", "99342", "99343", "99344", "99345", "99347", "99348","99349", "99350", "99490","99495","99496",
               "G0402", "G0438", "G0439") and PLCSRVC ne '31')
	or (HCPCS_CD in("99201", "99202", "99203", "99204", "99205", "99211", "99212", "99213", "99214", "99215",
                "99324", "99325", "99326", "99327", "99328", "99334", "99335", "99336", "99337", 
                "99339", "99340", 
                "99341", "99342", "99343", "99344", "99345", "99347", "99348","99349", "99350", "99490","99495","99496",
               "G0402", "G0438", "G0439") and PLCSRVC='31')
			   then PCS=1;else PCS=0;
%mend Carrier;


%macro PCP();
if HCFASPCL in ("01","08","11","37","38","50","89","97" ) then PCP=1;else PCP=0;
if HCFASPCL in ("06","12","13","16","23","25","26","27","29","39","46","70","79","82","83","84","86","90","98") then Specialist=1;else Specialist=0;
  
%mend PCP;


proc import datafile="D:\Projects\ACO Xiner\data\NPI" dbms=xlsx out=NPI0 replace;getnames=yes;run;
data NPI0;
set NPI0;
if Primary_specialty="SLEEP LABORATORY/MEDICINE" then  Primary_specialty="SLEEP MEDICINE";
if Primary_specialty="ORAL SURGERY (DENTIST ONLY)" then  Primary_specialty="ORAL SURGERY";
run;
proc import datafile="D:\Projects\ACO Xiner\data\Physician Compare Specialties" dbms=xlsx out=Specialties replace;getnames=yes;run; 
proc sql;create table NPI as select a.*,b.* from NPI0 a left join Specialties b on a.Primary_specialty=b.primaryspecialty;quit;
proc sort data=NPI nodupkey;by NPI  ;run;
  
 
data NPI;
set NPI;
if credential in ("MD","DO");
if physician=1 and Primary_specialty in ('GENERAL PRACTICE', 'FAMILY PRACTICE', 'INTERNAL MEDICINE', 'PEDIATRIC MEDICINE','GERIATRIC MEDICINE')
then  PCP=1;else PCP=0;
if (physician=1 and Primary_specialty in ('CARDIOVASCULAR DISEASE (CARDIOLOGY)','OSTEOPATHIC MANIPULATIVE MEDICINE','NEUROLOGY',
'OBSTETRICS/GYNECOLOGY','SPORTS MEDICINE','PHYSICAL MEDICINE AND REHABILITATION','PSYCHIATRY','GERIATRIC PSYCHIATRY','PULMONARY DISEASE',
'NEPHROLOGY', 'ENDOCRINOLOGY',  'Addiction medicine','HEMATOLOGY','HEMATOLOGY/ONCOLOGY',
'PREVENTATIVE MEDICINE','NEUROPSYCHIATRY','MEDICAL ONCOLOGY','GYNECOLOGICAL ONCOLOGY')) or 
(physician ne 1 and Primary_specialty='SINGLE OR MULTISPECIALTY CLINIC OR GROUP PRACTICE') then Specialist=1;else Specialist=0;
if  PCP=1 or  Specialist=1;
*NPIchar=put(NPI,$12.);
proc freq;title "Number of Physicians";tables  PCP Specialist/missing;
run;


 

data denom&yr.;
	set denom.dnmntr&yr.(where=(strctflg="05" or strctflg='15'));

	
	if (A_MO_CNT =12 and B_MO_CNT=12) then abcover=1; else abcover=0;
	if death_dt=. then death=0; else death=1; 
	if age=>65 then age65=1; else age65=0;

	deathyr=year(death_dt); 
    if hmo_mo=0 and abcover=1 and death=0;
	proc freq; title "How many beneficiary during &yr.";tables age65 abcover death deathyr/missing; 
	proc sort; by bene_id;
run;

/*
For services billed under the physician fee schedule (including method II CAHs), and
for FQHC services furnished after 1/1/2011, primary care services include services
identified by the following HCPCS/CPT©16 codes:
*/


/*
Note that the definition of a physician for purposes of the Shared Savings
Program includes only MD/DO physicians.
*/
data Carrier;
set car.Bcarline&yr.;
%Carrier;
%PCP;
if PCS=1;
Allowed=LALOWCHG;
TIN=TAX_NUM;
NPI=PRF_NPI*1;
keep bene_id PCS PCP Specialist TIN NPI Allowed  PLCSRVC;
proc freq;tables PCP Specialist;
run;


/*
Method II CAH professional services are billed on institutional claim form 1450, bill type
85X, with the presence of one or more of the following revenue center codes: 096x,
097x, and/or 098x.
*/



proc sql;
create table op as
select a.*, b.FAC_TYPE,b.TYPESRVC, b.provider as CCN, b.OT_NPI, b.OP_NPI, b.AT_NPI
from op.Otptrev&yr. a left join op.Otptclms&yr. b
on a.clm_id=b.clm_id and a.bene_id=b.bene_id;
quit;
 

data CAH0 RHC0 FQHC0 ETA0;
set op ;
if FAC_TYPE='8' and  TYPESRVC='5' then output CAH0;
if FAC_TYPE='7' and  TYPESRVC='1' then output RHC0;
if FAC_TYPE='7' and  TYPESRVC in ('3','7') then output FQHC0;
if FAC_TYPE='1' and  TYPESRVC='3' then output ETA0;
run;
 
/*
To obtain the rendering physician/practitioner for method II CAH claims, CMS will
use the “rendering NPI” field. In the event the rendering NPI field is blank, CMS will
use the “other provider” NPI field. If the other provider NPI field is also blank on a
claim, CMS will use the attending NPI field.*/
data CAH1;
set CAH0;
%CAH;
if PCS=1;
Allowed=REVPMT+PTNTRESP ;
if RNDRNG_PHYSN_NPI ne '' then NPI=RNDRNG_PHYSN_NPI*1;
else if OT_NPI ne '' then NPI=OT_NPI*1;
else if AT_NPI ne '' then NPI=AT_NPI*1;
keep bene_id PCS  CCN NPI Allowed HCPCS_CD REV_CNTR  ;
run;

proc sql;
create table CAH2 as
select a.*,b.PCP, b.Specialist
from CAH1 a left join NPI b
on a.NPI=b.NPI;
quit;
 
/*
For claims for services provided by an ACO’s FQHC/RHC
participants, beneficiaries are identified if they had at least one primary care service at
the ACO from a physician NPI (Doctor of Medicine (MD)/Doctor of Osteopathic
Medicine (DO)) listed on an attestation as part of the ACO Participant List. 
*/


data FQHC2;
set FQHC0;
%FQHC;
if PCS=1;
Allowed=REVPMT+PTNTRESP ;
if RNDRNG_PHYSN_NPI ne '' then NPI=RNDRNG_PHYSN_NPI*1;
else if OT_NPI ne '' then NPI=OT_NPI*1;
else if AT_NPI ne '' then NPI=AT_NPI*1;
PCP=1; Specialist=0;
keep bene_id PCS  PCP  Specialist  CCN NPI Allowed HCPCS_CD REV_CNTR  ;
run;
 

data RHC2;
set RHC0;
%FQHC;
if PCS=1;
Allowed=REVPMT+PTNTRESP ;
if RNDRNG_PHYSN_NPI ne '' then NPI=RNDRNG_PHYSN_NPI*1;
else if OT_NPI ne '' then NPI=OT_NPI*1;
else if AT_NPI ne '' then NPI=AT_NPI*1;
PCP=1; Specialist=0;
keep bene_id PCS  PCP  Specialist CCN NPI Allowed HCPCS_CD REV_CNTR ;
run;

/*
The line item HCPCS codes on the ETA institutional claims are used to identify whether
a primary care service was provided. The reason for this is that physician services
provided at ETA hospitals do not otherwise appear in either outpatient or physician
claims.15 ETA hospitals, however, do bill CMS to recover facility costs incurred when
ETA hospital physicians provide services. The HCPCS code, thus, will provide
identification that a primary care service was rendered to a beneficiary. However, CMS
will not scan revenue center codes. Table 2 lists the HCPCS codes that will be used to
identify primary care services for ETA institutional claims, except for two: G0438 and
G0439 are not included in the list of HCPCS codes for ETA hospitals in 2009 and 2010.
*/
data ETA1;
set ETA0;
%ETA;
 
if PCS=1;
Allowed=REVPMT+PTNTRESP ;
if OT_NPI ne '' then NPI=OT_NPI*1;
else if AT_NPI ne '' then NPI=AT_NPI*1;
keep bene_id PCS CCN NPI Allowed HCPCS_CD REV_CNTR  ;
run; 
 
proc sql;
create table ETA2 as
select a.*,b.PCP, b.Specialist
from ETA1 a left join NPI b
on a.NPI=b.NPI;
quit;

proc sql;
create table ETA3 as
select *
from ETA2
where ccn in (select provider from aha.aha13 where teaching in (1,2));
quit;
 
/*
Allowed charges for ETA claims are imputed using the formula used by Medicare’s
Physician Fee Schedule for calculating allowed charges for each HCPCS code.
*/





* Match ACO by TIN;
* First, use CMS patient level data to calculate how many patients under each ACO, keeo the biggest ACO for the 44 duplicated TIN+ACO combination;
 
proc sort data=CMSACO.Bene_aco&cmsyr. out=temp1 ;by ACO_Num;run;
proc sql;
create table temp2 as
select ACO_Num, count(*) as Nbene
from  temp1 
group by ACO_Num;
quit;
proc sort data=temp2 nodupkey ;by ACO_NUM;run;

proc sql;
create table temp3 as
select a.*,b.*
from CMSAco.Prvdraco&cmsyr. a left join temp2 b
on a.ACO_NUM=b.ACO_NUM;
quit;

proc sort data=temp3 out=temp4 nodupkey ;where TIN ne ''; by TIN ACO_NUM;run;
proc sort data=temp4 out=temp5 ; by TIN descending Nbene;run;
proc sort data=temp5 nodupkey ; by TIN  ;run;

proc sql;
create table carrier1 as
select a.*,b.*
from carrier  a left join temp5  b
on a.TIN=b.TIN;
quit;
 








* Match ACO by CCN; 
proc sort data=CMSAco.Prvdraco&cmsyr. out=temp1 nodupkey ;where CCN ne ''; by CCN ACO_NUM;run;
proc sort data=temp1 out=temp2 nodupkey; by CCN;run;
 
data op ;
set CAH2  RHC2 FQHC2  ;
run;


proc sql;
create table op1 as
select a.*,b.*
from op  a left join temp2  b
on a.CCN=b.CCN;
quit;


* Stack all Primary care claims together, see if any PCP;
data All;
length CCN $10.  ;
set carrier1 op1;
proc sort;by bene_id ;
run;

proc sql;create table ANYPCP as select bene_id, sum(PCP) as NPCP from ALL group by bene_id;quit;
proc sort data=AnyPCP nodupkey;by bene_id;run;

proc sql;
create table All1 as
select a.*,b.*
from All a left join AnyPCP b
on a.bene_id=b.bene_id;
quit;

* split into PCP yes or no;
data PCPYes PCPNo;
length practice $20.;
set All1;
if TIN ne '' then do;practice=TIN;by="By TIN";end;
else if CCN ne ''  then do;practice=CCN;by="By CCN";end; * CCN is equivalent to TIN, but we don't have TIN in op, so will use CCN as TIN;
else do;practice=NPI;by="By NPI";end;

if NPCP>0 then output PCPYes;
else output PCPNo;
run;
proc freq data=PCPYes;tables by/missing;
proc freq data=PCPNo;tables by/missing;
run;

********************* Practice TIN/CCN/NPI level; 

proc sort data=PCPYes out=temp1 ;
where PCP=1;by bene_id practice;
run;
proc sql;
create table temp2 as
select bene_id, practice, by, sum(Allowed) as practice_Allowed, NPI, ACO_NUM  
from temp1 
group by bene_id, practice;
quit;
proc sort data=temp2 out=PCPYes_practice nodupkey; by  bene_id practice;run;

* For PCPNo;
proc sort data=PCPNo out=temp1 ;where Specialist=1;by bene_id practice;run;
proc sql;
create table temp2 as
select bene_id, practice, by, sum(Allowed) as practice_Allowed, NPI, ACO_NUM
from temp1 
group by bene_id, practice;
quit;
proc sort data=temp2 out=PCPNo_practice nodupkey; by  bene_id practice;run;



******* ACO or individual physician level;
* For PCPYes ;
data temp1;
set PCPYes_practice;
if ACO_NUM ne '' then do;group=ACO_NUM;by_group="By ACO";end;
else do;group=practice;by_group=by;end;
proc sort  ; by bene_id group;run;
proc sql;
create table temp2 as
select bene_id, group, by_group, sum(practice_Allowed) as group_Allowed, NPI, ACO_NUM
from temp1 
group by bene_id, group;
quit;
proc sort data=temp2 out=PCPYes_group nodupkey; by  bene_id group;run;
proc freq data=PCPYes_group;tables by_group/missing;run;


* For PCPNo ;
data temp1;
set PCPNo_practice;
if ACO_NUM ne '' then do;group=ACO_NUM;by_group="By ACO";end;
else do;group=practice;by_group=by;end;
proc sort  ; by bene_id group;run;
proc sql;
create table temp2 as
select bene_id, group, by_group, sum(practice_Allowed) as group_Allowed, NPI, ACO_NUM
from temp1 
group by bene_id, group;
quit;
proc sort data=temp2 out=PCPNo_group nodupkey; by  bene_id group;run;
proc freq data=PCPNo_group;tables by_group/missing;run;

************Assign Plurality ACO;
* for PCPYes;
proc sort data=PCPYes_group ;by bene_id descending group_Allowed;run;
proc sort data=PCPYes_group nodupkey;by bene_id;run;

* link back to practice level, assign practice and ACO;
proc sql;
create table PCPYes_ACO as
select a.bene_id, a.practice, a.by, a.practice_Allowed, b.group, b.by_group, b.group_Allowed, b.ACO_NUm
from PCPYes_practice a left join PCPYes_group b 
on a.bene_id=b.bene_id;
quit;
proc sort data=PCPYes_ACO ;by bene_id descending practice_Allowed;run;
proc sort data=PCPYes_ACO nodupkey;by bene_id ;run;


* for PCPNo;
proc sort data=PCPNo_group ;by bene_id descending group_Allowed;run;
proc sort data=PCPNo_group nodupkey;by bene_id;run;

* link back to practice level, assign practice and ACO;
proc sql;
create table PCPNo_ACO as
select a.bene_id, a.practice, a.by, a.practice_Allowed, b.group, b.by_group, b.group_Allowed, b.ACO_NUm
from PCPNo_practice a left join PCPNo_group b 
on a.bene_id=b.bene_id;
quit;
proc sort data=PCPNo_ACO ;by bene_id descending practice_Allowed;run;
proc sort data=PCPNo_ACO nodupkey;by bene_id ;run;


*******Stack all people together, Make final bene level file indicating ACO and practice assignmtn;
data Allbene;
set PCPYes_ACO PCPNo_ACO;
if ACO_NUm ne '' then ACO=1;else ACO=0;
proc freq;tables ACO;
run;

proc sql;
create table ACO.Bene_ACO&yr. as
select *
from Allbene
where bene_id in (select bene_id from denom&yr.);
quit;

*********************************
*Only chekc this for 2013 and 2014;
***********************************;
* COnfusion Matrix;
proc sql;
create table temp as
select a.*,b.ACO_NUM as ACO_NUM1 
from ACO.Bene_ACO&yr. a left join CMSACO.Bene_aco&yr.  b
on a.bene_id=b.bene_id;
quit;
data temp1;
set temp;
if ACO_NUM1 ne '' then TrueACO=1;else TRueACO=0;
if ACO_NUM  ne '' then AlgACO=1;else AlgACO=0;
proc freq;tables TrueACO*AlgACO/missing ;run;
run;
 
 






