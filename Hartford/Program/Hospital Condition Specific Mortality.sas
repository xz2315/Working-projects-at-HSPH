********************************************
CMS: Risk-adjusted Mortality 
Xiner Zhou
2015/10/11
*******************************************;
libname ip 'C:\data\Data\Medicare\Inpatient';
libname medpar 'C:\data\Data\Medicare\HCUP_Elixhauser\data';
libname denom 'C:\data\Data\Medicare\Denominator';
libname hartford 'C:\data\Projects\Hartford\Data';
libname HCC 'C:\data\Data\Medicare\HCC\Clean\Data';


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

proc contents data=denom.dnmntr2005;run;



%macro mort(yr=,day=);

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
 %if   &yr.=2008  %then %do;if hmo_mo='00' ;%end;
  %if &yr.=2005 or &yr.=2009 or &yr.=2010 or &yr.=2011 or &yr.=2012 or &yr.=2013  %then %do;if hmo_mo=0;%end;

  
  if CON_ENR=1 and agecat ne 1 and BENE_STATE ne 'xx'  and esrd_ind ne 'Y';
  
  if bene_id ne '';
  keep BENE_ID SEXcat RACEcat age agecat; 
 
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
	if i in ('00','01','02','03','04','05','06','07','08','09') then type='Acute Care Hospitals';*3398;
	if i in ('13') then type='Critical Access Hospitals'; *1235;
     
if i in ('00','01','02','03','04','05','06','07','08','09','13');
  
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

keep bene_id  clm_id  death_dt ADMSN_DT DSCHRGDT PRNCPAL_DGNS_CD SRC_ADMS  STUS_CD provider  type  
ami chf pn copd stroke sepsis esggas gib uti metdis arrhy chest renalf resp hipfx ;

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



data Mort&yr.;
set temp&yr._1;

    if  SRC_ADMS in ('4') then transferin=1;else transferin=0;
    if transferin=0;

	if &day.=30 then do;
	if month(ADMSN_DT)=12 then lostfollowup=1; else lostfollowup=0;
end;
else if &day.=90 then do;
	if month(ADMSN_DT) in (10,11,12) then lostfollowup=1; else lostfollowup=0;
end;
	 
	if 0<=death_DT - ADMSN_DT<=&day. then death=1; else death=0;

	if lostfollowup=0 ;
run;

proc sql;drop table temp&yr._1;quit;


* Construct Risk Factors;
data HCC&yr.;
set hcc.Hcc_iponly_100pct_&yr.;
keep bene_id hcc1--hcc177;
run;

proc sql;
create table Risk&yr. as
select a.*,b.*
from Mort&yr. a left join HCC&yr. b
on a.bene_id=b.bene_id;
quit;

proc sql;drop table Mort&yr.;quit;
proc sql;drop table HCC&yr.;quit;

%macro condition(cond=);

*Risk-Adjustment Model;
proc genmod data=Risk&yr.  descending;
where &cond.=1;
Title "Logistic Regression: Predicted Probability of &day. -day Mortality, Adjusting for HCC,Age,Race,Sex";
	class death agecat racecat sexcat provider hcc1--hcc177 ;
	model death=agecat racecat sexcat hcc1--hcc177 /dist=bin link=logit type3;
	*repeated subject=provider/type=exch;
	output out=pred&cond.mort&day.&yr. pred=p&cond.mort&day.&yr.;	
run;

*Predicted/Obs * Overall;
proc means data=pred&cond.mort&day.&yr. noprint;
var death;
output out=overall&cond.mort&day.&yr. mean=overall&cond.mort&day.&yr.;
run;
data _null_;set overall&cond.mort&day.&yr.;call symput("overall",overall&cond.mort&day.&yr.);run;

proc sort data=pred&cond.mort&day.&yr. ;by provider;run;
proc sql;
create table &cond.mort&day.&yr. as
select *,mean(death) as Raw&cond.mort&day.&yr.,sum(death) as obs&cond.&day.&yr.,sum(p&cond.mort&day.&yr.) as pred&cond.&day.&yr., count(clm_id) as N_Admission&cond.&day.&yr.
from pred&cond.mort&day.&yr. 
group by provider;
quit;
proc sort data=&cond.mort&day.&yr.  nodupkey;by provider;run;

data Hartford.&cond.mort&day.&yr. ;
set &cond.mort&day.&yr. ;
overall&cond.mort&day.&yr.=symget('overall')*1;
Adj&cond.mort&day.&yr.=(obs&cond.&day.&yr./pred&cond.&day.&yr. )*overall&cond.mort&day.&yr.;
    label Raw&cond.mort&day.&yr.="&yr. &cond. Unadjusted all-cause &day. day Mortality";
	label overall&cond.mort&day.&yr.="National Overall &cond. &day.-day Mortality Rate";
	label N_Admission&cond.&day.&yr.="Number of Index &cond. Admissions for this hospital";
	label obs&cond.&day.&yr.="Number of Observed &cond. &day.-day Mortality for this hospital";
	label pred&cond.&day.&yr.="Number of Predicted &cond. &day.-day Mortality for this hostpial ";
	label Adj&cond.mort&day.&yr.="&yr. &cond. risk-adjusted all-cause &day. day Mortality";

keep provider overall&cond.mort&day.&yr. N_Admission&cond.&day.&yr. obs&cond.&day.&yr. pred&cond&day.&yr. Adj&cond.mort&day.&yr. Raw&cond.mort&day.&yr.;
proc sort;by provider;
run;

%mend condition;
%condition(cond=AMI);
%condition(cond=chf);
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
%condition(cond=hipfx);

%mend mort;
%mort(yr=2013,day=30);
%mort(yr=2012,day=30);
%mort(yr=2011,day=30);
%mort(yr=2010,day=30);
%mort(yr=2009,day=30);
%mort(yr=2008,day=30);
%mort(yr=2013,day=90);
%mort(yr=2012,day=90);
%mort(yr=2011,day=90);
%mort(yr=2010,day=90);
%mort(yr=2009,day=90);
%mort(yr=2008,day=90);




***************************************************************
Check Trends and Risk-adjustment with Raw
**************************************************************;

%macro trend(cond=,label=);

%do i=2008 %to 2013;
	data &cond.mort30&i.;
		set Hartford.&cond.mort30&i. ;
		if _n_=1;
		year=&i.;
		day=30;
		overall&cond.mort=overall&cond.mort30&i.;
keep year day overall&cond.mort   ;
run;
%end;

data &cond.mort30;
set &cond.mort302008 &cond.mort302009 &cond.mort302010 &cond.mort302011 &cond.mort302012 &cond.mort302013;
run;

%do i=2008 %to 2013;
	data &cond.mort90&i.;
		set Hartford.&cond.mort90&i. ;
		if _n_=1;
		year=&i.;
		day=90;
		overall&cond.mort=overall&cond.mort90&i.;
keep year day overall&cond.mort  ;
run;
%end;

data &cond.mort90;
set &cond.mort902008 &cond.mort902009 &cond.mort902010 &cond.mort902011 &cond.mort902012 &cond.mort902013;
run;

data &cond.mort;
set &cond.mort30 &cond.mort90;
run;

proc sgplot data=&cond.mort ;
title "National &label. Mortality Rate 2008 to 2013";format overall&cond.mort percent7.4 ;
series x=year y=overall&cond.mort /group=day markerattrs=(color=black symbol=STARFILLED) datalabel=overall&cond.mort ;
yaxis label='Percent' values=(0.0000 to 0.4000 by 0.0100);
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
 
