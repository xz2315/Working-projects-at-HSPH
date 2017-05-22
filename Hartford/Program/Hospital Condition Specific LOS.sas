********************
Risk-standardized LOS
Xiner Zhou
2/16/2016
********************;
libname data 'C:\data\Projects\BSH EHR Adoption\Data';
libname ip 'C:\data\Data\Medicare\Inpatient';
libname medpar 'C:\data\Data\Medicare\MedPAR';
libname denom 'C:\data\Data\Medicare\Denominator';
libname hartford 'C:\data\Projects\Hartford\Data';
libname HCC 'C:\data\Data\Medicare\HCC\Clean\Data';
 
proc format ;
value $st_
'01'='Alabama'
'02'='Alaska'
'03'='Arizona'
'04'='Arkansas'
'05'='California'
'06'='Colorado'
'07'='Connecticut'
'08'='Delaware'
'09'='District of Columbia'
'10'='Florida'
'11'='Georgia'
'12'='Hawaii'
'13'='Idaho'
'14'='Illinois'
'15'='Indiana'
'16'='Iowa'
'17'='Kansas'
'18'='Kentucky'
'19'='Louisiana'
'20'='Maine'
'21'='Maryland'
'22'='Massachusetts'
'23'='Michigan'
'24'='Minnesota'
'25'='Mississippi'
'26'='Missouri'
'27'='Montana'
'28'='Nebraska'
'29'='Nevada'
'30'='New Hampshire'
'31'='New Jersey'
'32'='New Mexico'
'33'='New York'
'34'='North Carolina'
'35'='North Dakota'
'36'='Ohio'
'37'='Oklahoma'
'38'='Oregon'
'39'='Pennsylvania'
'40'='Puerto Rico'
'41'='Rhode Island'
'42'='South Carolina'
'43'='South Dakota'
'44'='Tennessee'
'45'='Texas'
'46'='Utah'
'47'='Vermont'
'48'='Virgin Islands'
'49'='Virginia'
'50'='Washington'
'51'='West Virginia'
'52'='Wisconsin'
'53'='Wyoming'
'54'='Africa'
'55'='Asia'
'56'='Canada'
'57'='Central America and West Indies'
'58'='Europe'
'59'='Mexico'
'60'='Oceania'
'61'='Philippines'
'62'='South America'
'63'='U.S. Possessions'
'97'='Saipan - MP'
'98'='Guam'
'99'='American Samoa'
;
run;

%macro bene(yr= );

data bene&yr.; 
	set denom.dnmntr&yr.;   

               * test enrollment for enrollees who died during year ;
	            death_month=month(death_DT);
                if death_dt^=' ' then do ;
                 enrollC = (A_MO_CNT >= death_month and B_MO_CNT >= death_month) ;
                end;

               * test enrollment for those who aged in during year ;
                else if age <=65 then do ;
                 aged_in_month = min((12 - month(BENE_DOB)), 1) ;
                 enrollC  = (A_MO_CNT >= aged_in_month and B_MO_CNT >= aged_in_month) ;
                end;

               * all else ;
                else do ;
                  enrollC  = (A_MO_CNT = 12 and B_MO_CNT = 12) ;
                end;

      label enrollC = "enrolled in A & B for eligible months during &yr." ;
  
  BENE_STATE = put(State_CD,$st_.);
  BENE_SSA_COUNTY =cats(STATE_CD, cnty_cd);

  if age>=65 then AgeC=1;else AgeC=0;
  if esrd_ind='Y' then ESRDC=1;else ESRDC=0;
  if State_CD*1>=1 and State_CD*1<=53 then StateC=1;else StateC=0;
  
  %if &yr.=2007 or &yr.=2008  %then %do;if hmo_mo='00' then HMOC=0;else HMOC=1;%end;
  %if &yr.=2006 or &yr.=2009 or &yr.=2010 or &yr.=2011 or &yr.=2012 or &yr.=2013  %then %do;if hmo_mo=0 then HMOC=0;else HMOC=1;%end;
  
  if enrollC=1 and HMOC=0 and ESRDC=0 and StateC=1 and AgeC=1;
    
  if bene_id ne ''; 
  keep BENE_ID  Age Race Sex ;
 
run;  
 
%mend bene;
%bene(yr=2008);
%bene(yr=2009);
%bene(yr=2010);
%bene(yr=2011);
%bene(yr=2012);
%bene(yr=2013);

 
%macro Medpar06to10(yr=);
data temp&yr._0;
set  medpar.Medparsl&yr.;

ami=0;chf=0;pn=0;copd=0;stroke=0; sepsis=0;esggas=0; gib=0;uti=0; metdis=0;arrhy=0;chest=0;renalf=0;resp=0;hipfx=0;

*Condition-Specific;
if DGNSCD1 in ('41000','41001',  '41011',  '41020',  '41021',  '41030', '41031',  '41040',  '41041',  '41050',  '41051',  '41060',  '41061',  '41070',  '41071',  '41080',  '41081',  '41090',  '41091')
then AMI=1; 

if DGNSCD1 in ('40201', '40211', '40291', '40401', '40403', '40411', '40413', '40491', '40493', '4280', '4281', '42820', '42821', '42822', '42823', '42830', '42831', '42832', '42833', '42840', '42841', '42842', '42843', '4289' )
then  chf=1; 

if DGNSCD1 in ('4800', '4801', '4802', '4803', '4808', '4809', 
						'481', '4820', '4821', 
						'4822', '48230', '48231', '48232', '48239', '48240', '48241', '48242', '48249', '48281', '48282', '48284', '48289', '4829', 
						'4830', '4831', '4838', '485', '486', '4870', '48811'  )
then pn=1; 


if DGNSCD1 in ("430", "431",  "4320",   "4321", "4329", "43301", "43311", "43321", "43331", "43381", "43391", "43401", "43411", "43491") 
then stroke=1;

if DGNSCD1 in (	"00322",  "01004","01010", "01084", "01090", "01100", "01103", "01104", "01106", "01110", 
			    	"01114", "01116", "01120", "01121", "01122", "01123", "01124", "01125", "01126", "01133",
			    	"01134", "01135", "01136", "01140", "01142", "01143", "01150", "01151", "01153", "01154",
			    	"01155", "01160", "01162", "01163", "01164", "01165", "01166", "01180", "01182", "01183",
			    	"01184", "01185", "01186", "01190", "01191", "01192", "01193", "01194", "01195", "01196", 
			    	"01200", "01202", "01204", "01206", "0212",   "0221", "0310",  "0391",  "0521",  "0730",  
			    	"1124",  "1140",  "1144",  "1145",  "11505", "11595", "1363",  "27702", "4820",  "4821", "48240","48241",
			    	"48249", "48281", "48282", "48283", "48284", "48289", "5070",  "5071",  "5078",  "5100", "5109", "5111", 
			    	"5130",  "5131",  "5192",  "7955",  "V712") 
then resp=1;

if DGNSCD1 in (	"4911", "49120","49121","49122","4918", "4919", "4920", "4928", "49320","49321","49322","4940","4941", "496",  "5064", "5069", "74861")
then copd=1;

if DGNSCD1 in (	"4260", "42610","42611","42612","42613","4262","4263","4264","42650","42651","42652","42653",
			    	"42654","4266", "4267", "42681","42682","42689","4269", "4270", "4271","4272","42731","42732",
			    	"42741","42742","42760","42761","42769","42781","42789","4279","7850","7851","99601","99604") 
then arrhy=1;

if DGNSCD1 in (	"78650","78651","78659","V717") 
then chest=1;

if DGNSCD1 in (	"4560","5307","53082","53100","53101","53120","53121","53140","53141","53160","53161","53200",
			    	"53201","53220","53221","53240","53241","53260","53261","53300","53301","53320","53340","53341",
			    	"53360","53400","53401","53420","53440","53441","53460","53501","53511","53521","53531","53541",
			    	"53551","53561","53783","53784","56202","56203","56212","56213","5693","56985","5780","5781",
			    	"5789") 
then gib=1;

if DGNSCD1 in (	"0030","0040","0041","0042","0043","0048","0049","0050","0053","0054","581","589","0059","0060",
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

if DGNSCD1 in (	"82000","82001","82002","82003","82009","82010", "82011", "82012", "82013","82019","82020","82021","82022","82030",
			    	"82031","82032","8208","8209") 
then hipfx=1;

if DGNSCD1 in  ("2510","2512","2513","260","261","262","2630","2631","2638","2639","2651","2661","2662","2669",
			   		"267", "2689","2690","2691","2692","2693","2698","2699","2752","27540","27541","27542","27549",
		           	"2760","2761","2762","2763","2764","2765","27650","27651","27652","2766","2767","2768","2769",
                    "27700","27800","27801","27802","2781","2783","2784","2788","7817","7830","7831","78321","78322",
                    "7833","78340","78341","7835","7836","7837","7839","79021","79029") 
then metdis=1;

if DGNSCD1 in (	"40301","40311","40391","40402","40412","40492","5845","5846","5847","5848","5849","585","5851",
			    	"5852","5853","5854", "5855","5856","5859","586","7885","9585") 
then  renalf=1;

if DGNSCD1 in (	"01600","01634","03284","1200","59000","59010","59011","5902","5903","59080","5909","5933","5950",
			    	"5951","5952","5953","59581","59589","5959","5970","59780","59781","59789","5990") 
then  uti=1; 

if DGNSCD1 in (	"0031","0362","0363","03689","0369","0380","03810","03811","03819","0382","0383","03840","03841",
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


AdmissionDate=ADMSNDT;
DischargeDate=DSCHRGDT;
LOS=max(1,DischargeDate-AdmissionDate);
Provider=PRVDRNUM;

if SSLSSNF in ('S','L');

i=substr(provider,3,2) ; 
	if i in ('00','01','02','03','04','05','06','07','08','09') then type='Acute Care Hospitals';
	if i in ('13') then type='Critical Access Hospitals';  
     
if i in ('00','01','02','03','04','05','06','07','08','09','13');
keep provider type bene_id LOS ami chf pn copd stroke sepsis esggas gib uti metdis arrhy chest renalf resp hipfx ;
run;

*Bene;
proc sql;
create table temp&yr._1 as
select a.*,b.*
from temp&yr._0 a inner join bene&yr. b
on a.bene_id=b.bene_id;
quit;

%mend Medpar06to10;
%MedPar06to10(yr=2008);
%MedPar06to10(yr=2009);
%MedPar06to10(yr=2010);
 
 

%macro IP11to13(yr=);
data temp&yr._0;
set  IP.Inptclms&yr.;
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
 

AdmissionDate=ADMSN_DT;
DischargeDate=DSCHRGDT;
LOS=max(1,DischargeDate-AdmissionDate);
 
i=substr(provider,3,2) ; 
	if i in ('00','01','02','03','04','05','06','07','08','09') then type='Acute Care Hospitals';
	if i in ('13') then type='Critical Access Hospitals';  
     
if i in ('00','01','02','03','04','05','06','07','08','09','13');
keep provider type bene_id LOS ami chf pn copd stroke sepsis esggas gib uti metdis arrhy chest renalf resp hipfx ;
run;

*Bene;
proc sql;
create table temp&yr._1 as
select a.*,b.*
from temp&yr._0 a inner join bene&yr. b
on a.bene_id=b.bene_id;
quit;
 
%mend IP11to13;
%IP11to13(yr=2011);
%IP11to13(yr=2012);
%IP11to13(yr=2013);
 


%macro HCC(yr=);
* Construct Risk Factors;
data HCC&yr.;
set hcc.Hcc_iponly_100pct_&yr.;
keep bene_id hcc1--hcc177;
run;

proc sql;
create table temp&yr._2 as
select a.*,b.*
from temp&yr._1 a left join HCC&yr. b
on a.bene_id=b.bene_id;
quit;
%mend HCC;
%HCC(yr=2008);
%HCC(yr=2009);
%HCC(yr=2010);
%HCC(yr=2011);
%HCC(yr=2012);
%HCC(yr=2013);

 
* https://support.sas.com/documentation/cdl/en/statug/63033/HTML/default/viewer.htm#statug_glimmix_a0000001413.htm ;

%macro risk(cond=,yr=);
proc genmod data=temp&yr._2  ;
Title "Linear Regression Adjusting for HCC,Age,Race,Sex";
where &cond.=1;
	class provider bene_id hcc1--hcc177 sex race;
	model LOS=age race sex hcc1--hcc177/dist=normal type3;
    output out=expLOS&cond.&yr. pred=exp0LOS&cond.&yr.;	
run;

proc sgplot data=expLOS&cond.&yr. ;
title "&cond. &yr.";
scatter x=los y=exp0LOS&cond.&yr.;
run;

*Predicted/Obs * Overall;
proc means data=expLOS&cond.&yr. noprint;
var LOS;
output out=overallLOS&cond.&yr. mean=overallLOS&cond.&yr.;
run;
data _null_;set overallLOS&cond.&yr.;call symput("overall",overallLOS&cond.&yr.);run;

proc sort data=expLOS&cond.&yr.;by provider;run;
proc sql;
create table LOS&cond.&yr. as
select *,mean(LOS) as RawLOS&cond.&yr.,
         sum(LOS) as obsLOS&cond.&yr.,
         sum(exp0LOS&cond.&yr.) as expLOS&cond.&yr., 
         count(*) as N&cond.&yr.
from expLOS&cond.&yr.
group by provider;
quit;
proc sort data=LOS&cond.&yr.  nodupkey;by provider;run;

data hartford.LOS&cond.&yr.;
set LOS&cond.&yr.;
overallLOS&cond.&yr.=symget('overall')*1;
    AdjLOS&cond.&yr.=(obsLOS&cond.&yr./expLOS&cond.&yr. )*overallLOS&cond.&yr.;

    label RawLOS&cond.&yr.="&yr. &cond. Unadjusted Hospital-level Average LOS";
	label overallLOS&cond.&yr.="&yr. &cond.  National Hospital-level Average LOS";
	label N&cond.&yr.="N. of &cond. Admissions";
	label obsLOS&cond.&yr.="&yr. &cond. Hospital-level Total Observed  LOS";
	label expLOS&cond.&yr.="&yr. &cond. Hospital-level Total Expected  LOS";
	label AdjLOS&cond.&yr.="&yr. &cond. Hospital-level Risk-Standardized LOS";

keep provider overallLOS&cond.&yr. N&cond.&yr. obsLOS&cond.&yr. expLOS&cond.&yr. AdjLOS&cond.&yr. RawLOS&cond.&yr.;
proc sort;by provider;
run;

%mend risk;
%risk(cond=AMI,yr=2008);
%risk(cond=CHF,yr=2008);
%risk(cond=PN,yr=2008);
%risk(cond=copd,yr=2008);
%risk(cond=stroke,yr=2008);
%risk(cond=sepsis,yr=2008);
%risk(cond=esggas,yr=2008);
%risk(cond=gib,yr=2008);
%risk(cond=uti,yr=2008);
%risk(cond=metdis,yr=2008);
%risk(cond=arrhy,yr=2008);
%risk(cond=chest,yr=2008);
%risk(cond=renalf,yr=2008);
%risk(cond=resp,yr=2008);
%risk(cond=hipfx,yr=2008);
 
%risk(cond=AMI,yr=2009);
%risk(cond=CHF,yr=2009);
%risk(cond=PN,yr=2009);
%risk(cond=copd,yr=2009);
%risk(cond=stroke,yr=2009);
%risk(cond=sepsis,yr=2009);
%risk(cond=esggas,yr=2009);
%risk(cond=gib,yr=2009);
%risk(cond=uti,yr=2009);
%risk(cond=metdis,yr=2009);
%risk(cond=arrhy,yr=2009);
%risk(cond=chest,yr=2009);
%risk(cond=renalf,yr=2009);
%risk(cond=resp,yr=2009);
%risk(cond=hipfx,yr=2009);

%risk(cond=AMI,yr=2010);
%risk(cond=CHF,yr=2010);
%risk(cond=PN,yr=2010);
%risk(cond=copd,yr=2010);
%risk(cond=stroke,yr=2010);
%risk(cond=sepsis,yr=2010);
%risk(cond=esggas,yr=2010);
%risk(cond=gib,yr=2010);
%risk(cond=uti,yr=2010);
%risk(cond=metdis,yr=2010);
%risk(cond=arrhy,yr=2010);
%risk(cond=chest,yr=2010);
%risk(cond=renalf,yr=2010);
%risk(cond=resp,yr=2010);
%risk(cond=hipfx,yr=2010);

%risk(cond=AMI,yr=2011);
%risk(cond=CHF,yr=2011);
%risk(cond=PN,yr=2011);
%risk(cond=copd,yr=2011);
%risk(cond=stroke,yr=2011);
%risk(cond=sepsis,yr=2011);
%risk(cond=esggas,yr=2011);
%risk(cond=gib,yr=2011);
%risk(cond=uti,yr=2011);
%risk(cond=metdis,yr=2011);
%risk(cond=arrhy,yr=2011);
%risk(cond=chest,yr=2011);
%risk(cond=renalf,yr=2011);
%risk(cond=resp,yr=2011);
%risk(cond=hipfx,yr=2011);

%risk(cond=AMI,yr=2012);
%risk(cond=CHF,yr=2012);
%risk(cond=PN,yr=2012);
%risk(cond=copd,yr=2012);
%risk(cond=stroke,yr=2012);
%risk(cond=sepsis,yr=2012);
%risk(cond=esggas,yr=2012);
%risk(cond=gib,yr=2012);
%risk(cond=uti,yr=2012);
%risk(cond=metdis,yr=2012);
%risk(cond=arrhy,yr=2012);
%risk(cond=chest,yr=2012);
%risk(cond=renalf,yr=2012);
%risk(cond=resp,yr=2012);
%risk(cond=hipfx,yr=2012);

%risk(cond=AMI,yr=2013);
%risk(cond=CHF,yr=2013);
%risk(cond=PN,yr=2013);
%risk(cond=copd,yr=2013);
%risk(cond=stroke,yr=2013);
%risk(cond=sepsis,yr=2013);
%risk(cond=esggas,yr=2013);
%risk(cond=gib,yr=2013);
%risk(cond=uti,yr=2013);
%risk(cond=metdis,yr=2013);
%risk(cond=arrhy,yr=2013);
%risk(cond=chest,yr=2013);
%risk(cond=renalf,yr=2013);
%risk(cond=resp,yr=2013);
%risk(cond=hipfx,yr=2013);

