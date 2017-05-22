************************************************
CMS: Risk-adjusted Readmission
Xiner Zhou
10/10/2015
************************************************;
libname ip 'C:\data\Data\Medicare\Inpatient';
libname medpar 'C:\data\Data\Medicare\HCUP_Elixhauser\data';
libname denom 'C:\data\Data\Medicare\Denominator';
libname hartford 'C:\data\Projects\Hartford\Data';
libname HCC 'C:\data\Data\Medicare\HCC\Clean\Data';
libname backup 'C:\data\Projects\APCD High Cost\My Files';
  /*
proc contents data=medpar.Elixall2011 out=temp;run;
data temp;set temp;where VARNUM >=7 and VARNUM<=35;keep Name VARNUM label;proc print;run;

%macro loop(var=,yr=);
data Elixall&yr.;set medpar.Elixall&yr.;run;
%do i=1 %to 29;
proc freq data=Elixall&yr. ; 
tables %scan(&var.,&i.)/out=%scan(&var.,&i.)  ;
run;

data %scan(&var.,&i.) ;length condition $30.;
set %scan(&var.,&i.) ;
where %scan(&var.,&i.)=1;
condition="%scan(&var.,&i.)";rename percent=p&yr.;keep condition percent;
run;
%end;

data all&yr.;
set &var. ;
proc print;
run;
%mend loop;
%loop(var=CHF VALVE PULMCIRC PERIVASC PARA NEURO CHRNLUNG DM DMCX HYPOTHY RENLFAIL LIVER ULCER AIDS LYMPH METS TUMOR ARTH COAG OBESE WGHTLOSS LYTES BLDLOSS ANEMDEF ALCOHOL DRUG PSYCH DEPRESS HTN_C,yr=2010);

*/
proc format;  
value st
1='AL'
2='AK'
3='AZ'
4='AR'
5='CA'
6='CO'
7='CT'
8='DE'
9='DC'
10='FL'
11='GA'
12='HI'
13='ID'
14='IL'
15='IN'
16='IA'
17='KS'
18='KY'
19='LA'
20='ME'
21='MD'
22='MA'
23='MI'
24='MN'
25='MS'
26='MO'
27='MT'
28='NE'
29='NV'
30='NH'
31='NJ'
32='NM'
33='NY'
34='NC'
35='ND'
36='OH'
37='OK'
38='OR'
39='PA'
40='xx'
41='RI'
42='SC'
43='SD'
44='TN'
45='TX'
46='UT'
47='VT'
48='xx'
49='VA'
50='WA'
51='WV'
52='WI'
53='WY'
54='xx'
55='xx'
56='xx'
57='xx'
58='xx'
59='xx'
60='xx'
61='xx'
62='xx'
63='xx'
64='xx'
65='xx'
66='xx'
68='xx'
75='xx'
0 ='xx'
. ='xx'
71='xx'
73='xx'
77='xx'
78='xx'
79='xx'
85='xx'
88='xx'
90='xx'
92='xx'
94='xx'
95='xx'
96='xx'
97='xx'
98='xx'
99='xx'
; 
run; 
 
%macro Readm(yr=,day=,risk=);

data bene&yr.; 
	set denom.dnmntr&yr.;   
* ENROLLMENT ;
               * test enrollment for enrollees who died during year ;
	            death_month=month(death_DT);
                if death_dt^=' ' then do ;
                 CON_ENR = (A_MO_CNT >= death_month and B_MO_CNT >= death_month) ;
                end;

               * test enrollment for those who aged in during year ;
                else if age <=65 then do ;
                 aged_in_month = min((12 - month(BENE_DOB)), 1) ;
                 CON_ENR = (A_MO_CNT >= aged_in_month and B_MO_CNT >= aged_in_month) ;
                end;

               * all else ;
                else do ;
                 CON_ENR = (A_MO_CNT = 12 and B_MO_CNT = 12) ;
                end;

      label CON_ENR = "enrolled in A & B for eligible months during &yr." ;
  
  BENE_STATE = put(State_CD*1,st.);
  BENE_SSA_COUNTY =cats(STATE_CD, cnty_cd);

  if age<65 then agecat=1;
  else if 65<=age<70 then agecat=2;
  else if 70<=age<75 then agecat=3;
  else if 75<=age<80 then agecat=4;
  else if age>=80 then agecat=5;
  
  if SEX ne '0';
	sexcat=sex*1;*1=Male 2=Female;

    if race ne '0';
	if race = 1 then racecat=1;*white;
	else if race=2 then racecat=2;*black;
	else if race=5 then racecat=3;*hispanic;
	else racecat=4;*others;

  
  if CON_ENR=1 and agecat ne 1 and BENE_STATE ne 'xx' and hmo_mo=0 and esrd_ind ne 'Y';
  
  if bene_id ne '';
  keep BENE_ID BENE_STATE BENE_SSA_COUNTY BENE_ZIP SEXcat RACEcat age agecat; 
 
run;  

*Discharged from non-federal acute care hospitals;
data temp&yr._0;
set medpar.elixall&yr.;


%if &yr.=2010 %then %do;
	ADMSN_DT=ADMSNDT; 
	provider=PRVDRNUM;
	clm_id=MEDPARID;
	PRNCPAL_DGNS_CD=DGNSCD1;
%end;
%if &yr.=2009 %then %do;
	PRNCPAL_DGNS_CD=DGNSCD1;
%end;
%if &yr.=2008 %then %do;
	ADMSN_DT=ADMSNDT; 
    clm_id=MEDPARID;
	provider=PRVDRNUM;
	STUS_CD=DSTNTNCD;
	PRNCPAL_DGNS_CD=DGNSCD1;
%end;
 

i=substr(provider,3,2) ; 
	if i in ('00','01','02','03','04','05','06','07','08') then type='Acute Care Hospitals';*3398;
	if i in ('13') then type='Critical Access Hospitals'; *1235;
     
if i in ('00','01','02','03','04','05','06','07','08','13');
  
ami=0;chf=0;pn=0;copd=0;stroke=0; sepsis=0;esggas=0; gib=0;uti=0; metdis=0;arrhy=0;chest=0;renalf=0;resp=0;hipfx=0;

*Condition-Specific;

if PRNCPAL_DGNS_CD in ('41000','41001',  '41011',  '41020',  '41021',  '41030', '41031',  '41040',  '41041',  '41050',  '41051',  '41060',  '41061',  '41070',  '41071',  '41080',  '41081',  '41090',  '41091')
then AMI=1; 

if PRNCPAL_DGNS_CD in ('40201', '40211', '40291', '40401', '40403', '40411', '40413', '40491', '40493', '4280', '4281', '42820', '42821', '42822', '42823', '42830', '42831', '42832', '42833', '42840', '42841', '42842', '42843', '4289' )
then  chf=1; 

if PRNCPAL_DGNS_CD in ('4800', '4801', '4802', '4803', '4808', '4809', 
						'481', '4820', '4821', 
						'4822', '48230', '48231', '48232', '48239', '48240', '48241', '48242', '48249', '48281', '48282', '48284', '48289', '4829', 
						'4830', '4831', '4838', '485', '486', '4870', '48811'  )
then pn=1; 



if PRNCPAL_DGNS_CD in ("430", "431",  "4320",   "4321", "4329", "43301", "43311", "43321", "43331", "43381", "43391", "43401", "43411", "43491") 
then stroke=1;

if PRNCPAL_DGNS_CD in (	"00322",  "01004","01010", "01084", "01090", "01100", "01103", "01104", "01106", "01110", 
			    	"01114", "01116", "01120", "01121", "01122", "01123", "01124", "01125", "01126", "01133",
			    	"01134", "01135", "01136", "01140", "01142", "01143", "01150", "01151", "01153", "01154",
			    	"01155", "01160", "01162", "01163", "01164", "01165", "01166", "01180", "01182", "01183",
			    	"01184", "01185", "01186", "01190", "01191", "01192", "01193", "01194", "01195", "01196", 
			    	"01200", "01202", "01204", "01206", "0212",   "0221", "0310",  "0391",  "0521",  "0730",  
			    	"1124",  "1140",  "1144",  "1145",  "11505", "11595", "1363",  "27702", "4820",  "4821", "48240","48241",
			    	"48249", "48281", "48282", "48283", "48284", "48289", "5070",  "5071",  "5078",  "5100", "5109", "5111", 
			    	"5130",  "5131",  "5192",  "7955",  "V712") 
then resp=1;

if PRNCPAL_DGNS_CD in (	"4911", "49120","49121","49122","4918", "4919", "4920", "4928", "49320","49321","49322","4940","4941", "496",  "5064", "5069", "74861")
then copd=1;

if PRNCPAL_DGNS_CD in (	"4260", "42610","42611","42612","42613","4262","4263","4264","42650","42651","42652","42653",
			    	"42654","4266", "4267", "42681","42682","42689","4269", "4270", "4271","4272","42731","42732",
			    	"42741","42742","42760","42761","42769","42781","42789","4279","7850","7851","99601","99604") 
then arrhy=1;

if PRNCPAL_DGNS_CD in (	"78650","78651","78659","V717") 
then chest=1;

if PRNCPAL_DGNS_CD in (	"4560","5307","53082","53100","53101","53120","53121","53140","53141","53160","53161","53200",
			    	"53201","53220","53221","53240","53241","53260","53261","53300","53301","53320","53340","53341",
			    	"53360","53400","53401","53420","53440","53441","53460","53501","53511","53521","53531","53541",
			    	"53551","53561","53783","53784","56202","56203","56212","56213","5693","56985","5780","5781",
			    	"5789") 
then gib=1;

if PRNCPAL_DGNS_CD in (	"0030","0040","0041","0042","0043","0048","0049","0050","0053","0054","581","589","0059","0060",
			    	"0061","062","0071","0074","0078","00800","00801","00802","00804","00809","0082","0083","00841",
			    	"00842","00843","00844","00845","00846","00847","00849","0085","00861","00862","00863","00867",
			    	"00869","0088","0090","0091","0092","0093","11284","11285","1231","1269","1271","1272","1273",
			    	"1279","129","22804","2712","2713","3064","4474","5300","53010","53011",
			    	"53012","53019","5303","5304","5305","5306","53081","53083","53084","53089","5309","53500",
		           	"53510","53520","53530","53540","53550","53560","5360","5361","5362","5363","5368","5369",
			    	"5371","5372","5374","5375","5376","53781","53782","53789",  "5379", "5523", "5533","5583",
			    	"5589","56200","56201","56210","56211","56400","56401","56402","56409","5641","5642",   
			    	"5643", "5644", "5645","5646","56481","56489","5649","5790","5791","5792","5793", "5794","5798",
			    	"5799","78701","78702", "78703","7871", "7872","7873","7874", "7876", "7877","78791","78799",
			    	"78900","78901","78902","78903","78904","78905","78906","78907","78909","78930","78931","78932",
			    	"78933","78934","78935","78936","78937","78939","78960","78961","78962","78964","78966","78967",
			    	"78969","7899","7921","7934","7936") 
then esggas=1;

if PRNCPAL_DGNS_CD in (	"82000","82001","82002","82003","82009","82010", "82011", "82012", "82013","82019","82020","82021","82022","82030",
			    	"82031","82032","8208","8209") 
then hipfx=1;

if PRNCPAL_DGNS_CD in  ("2510","2512","2513","260","261","262","2630","2631","2638","2639","2651","2661","2662","2669",
			   		"267", "2689","2690","2691","2692","2693","2698","2699","2752","27540","27541","27542","27549",
		           	"2760","2761","2762","2763","2764","2765","27650","27651","27652","2766","2767","2768","2769",
                    "27700","27800","27801","27802","2781","2783","2784","2788","7817","7830","7831","78321","78322",
                    "7833","78340","78341","7835","7836","7837","7839","79021","79029") 
then metdis=1;

if PRNCPAL_DGNS_CD in (	"40301","40311","40391","40402","40412","40492","5845","5846","5847","5848","5849","585","5851",
			    	"5852","5853","5854", "5855","5856","5859","586","7885","9585") 
then  renalf=1;

if PRNCPAL_DGNS_CD in (	"01600","01634","03284","1200","59000","59010","59011","5902","5903","59080","5909","5933","5950",
			    	"5951","5952","5953","59581","59589","5959","5970","59780","59781","59789","5990") 
then  uti=1; 

if PRNCPAL_DGNS_CD in (	"0031","0362","0363","03689","0369","0380","03810","03811","03819","0382","0383","03840","03841",
			    	"03842","03843","03844","03849","0388","0389","0545","78552","78559","7907","99590","99591",
			    	"99592","99593","99594") 
then sepsis=1;

label 

		     ami		= "Primary Diagosis of AMI"
			 chf		= "Primary Diagosis of CHF"
			 pn			= "Primary Diagosis of PN"
			 copd		= "Primary Diagosis of COPD"
			 stroke		= "Primary Diagosis of STROKE"
			 sepsis		= "Primary Diagosis of Sepsis"
			 esggas		= "Primary Diagosis of Esophageal/Gastric Disease "
			 gib		= "Primary Diagosis of GI Bleeding"
			 uti		= "Primary Diagosis of Urinary Tract Infection"
			 metdis		= "Primary Diagosis of Metabolic Disorder"
			 arrhy		= "Primary Diagosis of Arrhythmia"
			 chest		= "Primary Diagosis of Chest Pain"
			 renalf		= "Primary Diagosis of Renal Failure"
			 resp		= "Primary Diagosis of Respiratory Disease"
			 hipfx		= "Primary Diagosis of Hip Fracture"
			 ;

keep bene_id  clm_id  ADMSN_DT DSCHRGDT PRNCPAL_DGNS_CD SRC_ADMS  STUS_CD provider  type  
ami chf pn copd stroke sepsis esggas gib uti metdis arrhy chest renalf resp hipfx 
CHF VALVE PULMCIRC PERIVASC PARA NEURO CHRNLUNG DM DMCX HYPOTHY RENLFAIL LIVER ULCER 
AIDS LYMPH METS TUMOR ARTH COAG OBESE WGHTLOSS LYTES BLDLOSS ANEMDEF ALCOHOL DRUG PSYCH DEPRESS HTN_C;

run;
*Enrolled in Medicare fee-for-service (FFS) ;
*Aged 65 or over; 
*Enrolled in Part A Medicare for the 12 months prior to the date of the index admission;
proc sql;
	create table temp&yr._1 as
	select a.*,b.*
	from temp&yr._0 a inner join bene&yr. b
on a.bene_id=b.bene_id;
quit;

proc sql;drop table temp&yr._0;quit;

*********************************************************************************************
Exclusions, define index admission, readmission
********************************************************************************************;
proc sort data=temp&yr._1 nodupkey;by bene_id ADMSN_DT DSCHRGDT;run;

%macro condition(cond=);

data temp&yr.&cond._2;
set temp&yr._1;

*Without an in-hospital death;
if STUS_CD in ('20') then indeath=1; else indeath=0;

*Not transferred to another acute care facility; 
if STUS_CD in('02','05') then transferout=1; else transferout=0;

* Not Admissions with <30 or <90 days of post-discharge follow-up;

	if month(DSCHRGDT)=12 then lostfollowup=1; else lostfollowup=0;


*Not Admissions discharged against medical advices;
if STUS_CD in ('07') then Against=1;else Against=0;

if  SRC_ADMS in ('4') then transferin=1;else transferin=0;
if indeath=0 and transferout=0 and lostfollowup=0 and Against=0  then Index=1;else Index=0;

if index=1 and &cond.=1;
proc sort;by bene_id ADMSN_DT DSCHRGDT;
run;

data index&yr.&cond.;
set temp&yr.&cond._2;

retain index_date;
format index_date mmddyy10.;
by bene_id ADMSN_DT DSCHRGDT;

if first.bene_id=1 then do;
	index_date=DSCHRGDT;	 
End; 

else  do;
	Gap=ADMSN_DT-index_date;  
	if gap>30 then index_date=DSCHRGDT;
End;

if 0<=gap<=30 then within30=1;else within30=0;

if within30=1;
keep bene_id clm_id within30;
run;

proc sql;
create table temp&yr.&cond._3 as
select a.*,b.*
from temp&yr._1 a left join index&yr.&cond. b
on a.bene_id=b.bene_id and a.clm_id=b.clm_id;
quit;

proc sort data=temp&yr.&cond._3;by bene_id ADMSN_DT DSCHRGDT;run;

data temp&yr.&cond._3;
set temp&yr.&cond._3;

by bene_id ADMSN_DT DSCHRGDT;
Ref_date=lag(DSCHRGDT); 
 
Format Ref_Date YYMMDD10.;

if first.bene_id then do;
	Ref_date=.;
End;

Gap=ADMSN_DT-Ref_Date;  

*Without an in-hospital death;
if STUS_CD in ('20') then indeath=1; else indeath=0;

*Not transferred to another acute care facility; 
if STUS_CD in('02','05') then transferout=1; else transferout=0;

* Not Admissions with <30 or <90 days of post-discharge follow-up;
if &day.=30 then do;
	if month(DSCHRGDT)=12 then lostfollowup=1; else lostfollowup=0;
end;
else if &day.=90 then do;
	if month(DSCHRGDT) in (10,11,12) then lostfollowup=1; else lostfollowup=0;
end;

*Not Admissions discharged against medical advices;
if STUS_CD in ('07') then Against=1;else Against=0;

if  SRC_ADMS in ('4') then transferin=1;else transferin=0;
if transferin=0 and 0<=gap<=&day. then Readm=1;else Readm=0;
 
run;

proc sort data=temp&yr.&cond._3;by bene_id descending ADMSN_DT descending DSCHRGDT;run;

data Readm&yr.&cond.;
set temp&yr.&cond._3;

by bene_id descending ADMSN_DT descending DSCHRGDT;
leadtoReadm=lag(Readm);

if first.bene_id then do;
	leadtoReadm=0;
end;
*Index Admission Exclusions;
if within30 ne 1 and indeath=0 and transferout=0 and lostfollowup=0 and Against=0  then Index=1;else Index=0;
if Index=1 and &cond.=1;;
run;
 

* Construct Risk Factors;
data HCC&yr.;
set hcc.Hcc_iponly_100pct_&yr.(drop=hcc51 hcc52);
keep bene_id hcc1--hcc177;
run;
 

proc sql;
create table Risk&yr.&cond. as
select a.*,b.*
from Readm&yr.&cond. a left join HCC&yr. b
on a.bene_id=b.bene_id;
quit;
  

/*
CHF VALVE PULMCIRC PERIVASC PARA NEURO CHRNLUNG DM DMCX HYPOTHY RENLFAIL LIVER ULCER 
AIDS LYMPH METS TUMOR ARTH COAG OBESE WGHTLOSS LYTES BLDLOSS ANEMDEF ALCOHOL DRUG PSYCH DEPRESS HTN_C
*/

/*
HCC1--HCC177
*/
*Risk-Adjustment Model;
proc genmod data=Risk&yr.&cond.  descending;
Title "Logistic Regression: Predicted Probability of &day. -day Readmission,Adjusting for HCC,Age,Race,Sex";
	class leadtoReadm agecat racecat sexcat provider 
         CHF VALVE PULMCIRC PERIVASC PARA NEURO CHRNLUNG DM DMCX HYPOTHY RENLFAIL LIVER ULCER 
         AIDS LYMPH METS TUMOR ARTH COAG OBESE WGHTLOSS LYTES BLDLOSS ANEMDEF ALCOHOL DRUG PSYCH DEPRESS HTN_C;
	model leadtoReadm=agecat  racecat sexcat 
                     CHF VALVE PULMCIRC PERIVASC PARA NEURO CHRNLUNG DM DMCX HYPOTHY RENLFAIL LIVER ULCER 
                      AIDS LYMPH METS TUMOR ARTH COAG OBESE WGHTLOSS LYTES BLDLOSS ANEMDEF ALCOHOL DRUG PSYCH DEPRESS HTN_C/dist=bin link=logit type3;
	*repeated subject=provider/type=exch;
	output out=exp&cond.Readm&day.&yr. pred=exp&cond.Readm&day.&yr.;	
run;


*Predicted/Obs * Overall;
proc means data=exp&cond.Readm&day.&yr. noprint;
var leadtoReadm;
output out=overall&cond.Readm&day.&yr. mean=overall&cond.Readm&day.&yr.;
run;
data _null_;set overall&cond.Readm&day.&yr.;call symput("overall",overall&cond.Readm&day.&yr.);run;

proc sort data=exp&cond.Readm&day.&yr. ;by provider;run;
proc sql;
create table &cond.Readm&day.&yr. as
select *,mean(leadtoReadm) as Raw&cond.Readm&day.&yr.,sum(leadtoReadm) as obs&cond.&day.&yr.,sum(exp&cond.Readm&day.&yr.) as exp&cond.&day.&yr., count(clm_id) as N&cond.&day.&yr.
from exp&cond.Readm&day.&yr. 
group by provider;
quit;
proc sort data=&cond.Readm&day.&yr.  nodupkey;by provider;run;

data hartford.&cond.Readm&day.&yr.&risk. ;
set &cond.Readm&day.&yr. ;
overall&cond.Readm&day.&yr.=symget('overall')*1;
Adj&cond.Readm&day.&yr.=(obs&cond.&day.&yr./exp&cond.&day.&yr. )*overall&cond.Readm&day.&yr.;
    label Raw&cond.Readm&day.&yr.="&yr. &cond. Unadjusted All-Cause &day.-day Readmission Rate";
	label overall&cond.Readm&day.&yr.="National Overall &cond. &day.-day Readmission Rate";
	label N&cond.&day.&yr.="N. of &cond. Index Admissions";
	label obs&cond.&day.&yr.="N. of &cond. Observed &day.-day Readmission";
	label exp&cond.&day.&yr.="N. of &cond. Expected &day.-day Readmission";
	label Adj&cond.Readm&day.&yr.="&yr. &cond. Risk-Adjusted All-Cause &day.-day Readmission";

keep provider overall&cond.Readm&day.&yr. N&cond.&day.&yr. obs&cond.&day.&yr. exp&cond&day.&yr. Adj&cond.Readm&day.&yr. Raw&cond.Readm&day.&yr.;
proc sort;by provider;
run;

proc sql;drop table temp&yr.&cond._2;quit;
proc sql;drop table temp&yr.&cond._3;quit;
proc sql;drop table index&yr.&cond.;quit;
proc sql;drop table readm&yr.&cond.;quit;
proc sql;drop table Risk&yr.&cond.;quit;
proc sql;drop table HCC&yr.;quit;
proc sql;drop table exp&cond.Readm&day.&yr.;quit;
proc sql;drop table overall&cond.Readm&day.&yr.; quit;
proc sql;drop table &cond.Readm&day.&yr.  ; quit;
%mend condition;
%condition(cond=AMI);
/*%condition(cond=chf);
%condition(cond=pn);
%condition(cond=copd );
%condition(cond=stroke );
%condition(cond=sepsis );
%condition(cond=esggas );
%condition(cond=gib );
%condition(cond=uti); 
%condition(cond=metdis);
%condition(cond=arrhy);
%condition(cond=chest);
%condition(cond=renalf);
%condition(cond=resp);
%condition(cond=hipfx); */

%mend Readm;


%Readm(yr=2013,day=30,risk=elix);
%Readm(yr=2012,day=30,risk=elix);
%Readm(yr=2011,day=30,risk=elix);
%Readm(yr=2010,day=30,risk=elix);
%Readm(yr=2009,day=30,risk=elix);
%Readm(yr=2008,day=30,risk=elix);
/*
%Readm(yr=2013,day=90);
%Readm(yr=2012,day=90);
%Readm(yr=2011,day=90);
%Readm(yr=2010,day=90);
%Readm(yr=2009,day=90);
%Readm(yr=2008,day=90);
*/


/*
1. Cohort ICD-9-CM Codes by Measure
AMI Cohort Codes
410.00 AMI (anterolateral wall) ・episode of care unspecified
410.01 AMI (anterolateral wall) ・initial episode of care
410.10 AMI (other anterior wall) ・episode of care unspecified
410.11 AMI (other anterior wall) ・initial episode of care
410.20 AMI (inferolateral wall) ・episode of care unspecified
410.21 AMI (inferolateral wall) ・initial episode of care
410.30 AMI (inferoposterior wall) ・episode of care unspecified
410.31 AMI (inferoposterior wall) ・initial episode of care
410.40 AMI (other inferior wall) ・episode of care unspecified
410.41 AMI (other inferior wall) ・initial episode of care
410.50 AMI (other lateral wall) ・episode of care unspecified
410.51 AMI (other lateral wall) ・initial episode of care
410.60 AMI (true posterior wall) ・episode of care unspecified
410.61 AMI (true posterior wall) ・initial episode of care
410.70 AMI (subendocardial) ・episode of care unspecified
410.71 AMI (subendocardial) ・initial episode of care
410.80 AMI (other specified site) ・episode of care unspecified
410.81 AMI (other specified site) ・initial episode of care
410.90 AMI (unspecified site) ・episode of care unspecified
410.91 AMI (unspecified site) ・initial episode of care

Heart Failure Cohort Codes
402.01 Malignant hypertensive heart disease with congestive heart failure (CHF)
402.11 Benign hypertensive heart disease with CHF
402.91 Hypertensive heart disease with CHF
404.01 Malignant hypertensive heart and renal disease with CHF
404.03 Malignant hypertensive heart and renal disease with CHF & renal failure (RF)
404.11 Benign hypertensive heart and renal disease with CHF
404.13 Benign hypertensive heart and renal disease with CHF & RF
404.91 Unspecified hypertensive heart and renal disease with CHF
404.93 Hypertension and non-specified heart and renal disease with CHF & RF
428.0 Congestive heart failure, unspecified
428.1 Left heart failure
428.20 Systolic heart failure, unspecified
428.21 Systolic heart failure, acute
428.22 Systolic heart failure, chronic
428.23 Systolic heart failure, acute or chronic
428.30 Diastolic heart failure, unspecified
428.31 Diastolic heart failure, acute
428.32 Diastolic heart failure, chronic
428.33 Diastolic heart failure, acute or chronic
428.40 Combined systolic and diastolic heart failure, unspecified
428.41 Combined systolic and diastolic heart failure, acute
428.42 Combined systolic and diastolic heart failure, chronic
428.43 Combined systolic and diastolic heart failure, acute or chronic
428.9 Heart failure, unspecified

Pneumonia Cohort Codes
480.0 Pneumonia due to adenovirus
480.1 Pneumonia due to respiratory syncytial virus
480.2 Pneumonia due to parainfluenza virus
480.3 Pneumonia due to SARS-associated coronavirus
480.8 Viral pneumonia: pneumonia due to other virus not elsewhere classified
480.9 Viral pneumonia unspecified
481 Pneumococcal pneumonia [streptococcus pneumoniae pneumonia]
482.0 Pneumonia due to klebsiella pneumoniae
482.1 Pneumonia due to pseudomonas
482.2 Pneumonia due to hemophilus influenzae (h. influenzae)
482.30 Pneumonia due to streptococcus unspecified
482.31 Pneumonia due to streptococcus group a
482.32 Pneumonia due to streptococcus group b
482.39 Pneumonia due to other streptococcus
482.40 Pneumonia due to staphylococcus unspecified
482.41 Pneumonia due to staphylococcus aureus
482.42 Methicillin resistant pneumonia due to Staphylococcus aureus
482.49 Other staphylococcus pneumonia
482.81 Pneumonia due to anaerobes
482.82 Pneumonia due to escherichia coli [e.coli]
482.83 Pneumonia due to other gram-negative bacteria
482.84 Pneumonia due to legionnaires' disease
482.89 Pneumonia due to other specified bacteria
482.9 Bacterial pneumonia unspecified
483.0 Pneumonia due to mycoplasma pneumoniae
483.1 Pneumonia due to chlamydia
483.8 Pneumonia due to other specified organism
485 Bronchopneumonia organism unspecified
486 Pneumonia organism unspecified
487.0 Influenza with pneumonia
488.11 Influenza due to identified novel H1N1 influenza virus with pneumonia
*/
 


***************************************************************
Check Trends and Risk-adjustment with Raw
**************************************************************;
%macro trend(cond=,label=);

%do i=2008 %to 2013;
	data &cond.readm30&i.;
		set Hartford.&cond.readm30&i. ;
		if _n_=1;
		year=&i.;
		day=30;
		overall&cond.readm=overall&cond.readm30&i.;
keep year day overall&cond.readm ;
run;
%end;

data &cond.readm30;
set &cond.readm302008 &cond.readm302009 &cond.readm302010 &cond.readm302011 &cond.readm302012 &cond.readm302013;
run;

%do i=2008 %to 2013;
	data &cond.readm90&i.;
		set Hartford.&cond.readm90&i. ;
		if _n_=1;
		year=&i.;
		day=90;
		overall&cond.readm=overall&cond.readm90&i.;
keep year day overall&cond.readm ;
run;
%end;

data &cond.readm90;
set &cond.readm902008 &cond.readm902009 &cond.readm902010 &cond.readm902011 &cond.readm902012 &cond.readm902013;
run;

data &cond.readm;
set &cond.readm30 &cond.readm90;
run;

proc sgplot data=&cond.readm;
title "National &label. Readmission Rate 2008 to 2013";format overall&cond.readm percent7.4 ;
series x=year y=overall&cond.readm /group=day markerattrs=(color=black symbol=STARFILLED) datalabel=overall&cond.readm;
yaxis label='Percent' values=(0.1000 to 0.4500 by 0.0100);
run;
%mend trend;
%trend(cond=AMI,label=Acute Myocardial Infarction);
%trend(cond=chf,label=Congestive Heart Failure);
%trend(cond=pn,label=Pneumonia);
%trend(cond=copd,label=Chronic obstructive pulmonary disease );
%trend(cond=stroke,label=Stroke );
%trend(cond=sepsis,label=Sepsis );
%trend(cond=esggas,label=Esophageal/Gastric Disease );
%trend(cond=gib,label=GI Bleeding );
%trend(cond=uti,label=Urinary Tract Infection); 
%trend(cond=metdis,label=Metabolic Disorder);
%trend(cond=arrhy,label=Arrhythmia);
%trend(cond=chest,label=Chest Pain);
%trend(cond=renalf,label=Renal Failure);
%trend(cond=resp,label=Respiratory Disease);
%trend(cond=hipfx,label=Hip Fracture);
  
