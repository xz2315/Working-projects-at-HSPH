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

%macro Adm(yr= );

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
	ICD_DGNS_CD1=DGNSCD2;ICD_DGNS_CD2=DGNSCD3;ICD_DGNS_CD3=DGNSCD4;ICD_DGNS_CD4=DGNSCD5;ICD_DGNS_CD5=DGNSCD6;
	ICD_DGNS_CD6=DGNSCD7;ICD_DGNS_CD7=DGNSCD8;ICD_DGNS_CD8=DGNSCD9;ICD_DGNS_CD9=DGNSCD10;ICD_DGNS_CD10='';
	ICD_DGNS_CD11='';ICD_DGNS_CD12='';ICD_DGNS_CD13='';ICD_DGNS_CD14='';ICD_DGNS_CD15='';ICD_DGNS_CD16='';
	ICD_DGNS_CD17='';ICD_DGNS_CD18='';ICD_DGNS_CD19='';ICD_DGNS_CD20='';ICD_DGNS_CD21='';ICD_DGNS_CD22='';
	ICD_DGNS_CD23='';ICD_DGNS_CD24='';ICD_DGNS_CD25='';
%end;
%if &yr.=2009 %then %do;
	PRNCPAL_DGNS_CD=DGNSCD1;
	ICD_DGNS_CD1=DGNSCD2;ICD_DGNS_CD2=DGNSCD3;ICD_DGNS_CD3=DGNSCD4;ICD_DGNS_CD4=DGNSCD5;ICD_DGNS_CD5=DGNSCD6;
	ICD_DGNS_CD6=DGNSCD7;ICD_DGNS_CD7=DGNSCD8;ICD_DGNS_CD8=DGNSCD9;ICD_DGNS_CD9=DGNSCD10;ICD_DGNS_CD10='';
	ICD_DGNS_CD11='';ICD_DGNS_CD12='';ICD_DGNS_CD13='';ICD_DGNS_CD14='';ICD_DGNS_CD15='';ICD_DGNS_CD16='';
	ICD_DGNS_CD17='';ICD_DGNS_CD18='';ICD_DGNS_CD19='';ICD_DGNS_CD20='';ICD_DGNS_CD21='';ICD_DGNS_CD22='';
	ICD_DGNS_CD23='';ICD_DGNS_CD24='';ICD_DGNS_CD25='';
%end;
%if &yr.=2008 %then %do;
	ADMSN_DT=ADMSNDT; 
    clm_id=MEDPARID;
	provider=PRVDRNUM;
	STUS_CD=DSTNTNCD;
	PRNCPAL_DGNS_CD=DGNSCD1;
	ICD_DGNS_CD1=DGNSCD2;ICD_DGNS_CD2=DGNSCD3;ICD_DGNS_CD3=DGNSCD4;ICD_DGNS_CD4=DGNSCD5;ICD_DGNS_CD5=DGNSCD6;
	ICD_DGNS_CD6=DGNSCD7;ICD_DGNS_CD7=DGNSCD8;ICD_DGNS_CD8=DGNSCD9;ICD_DGNS_CD9=DGNSCD10;ICD_DGNS_CD10='';
	ICD_DGNS_CD11='';ICD_DGNS_CD12='';ICD_DGNS_CD13='';ICD_DGNS_CD14='';ICD_DGNS_CD15='';ICD_DGNS_CD16='';
	ICD_DGNS_CD17='';ICD_DGNS_CD18='';ICD_DGNS_CD19='';ICD_DGNS_CD20='';ICD_DGNS_CD21='';ICD_DGNS_CD22='';
	ICD_DGNS_CD23='';ICD_DGNS_CD24='';ICD_DGNS_CD25='';
%end;
 
array icd {25} $ ICD_DGNS_CD1 ICD_DGNS_CD2 ICD_DGNS_CD3 ICD_DGNS_CD4 ICD_DGNS_CD5
                 ICD_DGNS_CD6 ICD_DGNS_CD7 ICD_DGNS_CD8 ICD_DGNS_CD9 ICD_DGNS_CD10
				 ICD_DGNS_CD11 ICD_DGNS_CD12 ICD_DGNS_CD13 ICD_DGNS_CD14 ICD_DGNS_CD15
	             ICD_DGNS_CD16 ICD_DGNS_CD17 ICD_DGNS_CD18 ICD_DGNS_CD19 ICD_DGNS_CD20
                 ICD_DGNS_CD21 ICD_DGNS_CD22 ICD_DGNS_CD23 ICD_DGNS_CD24 ICD_DGNS_CD25;

i=substr(provider,3,2) ; 
	if i in ('00','01','02','03','04','05','06','07','08') then type='Acute Care Hospitals'; 
	 
     
if i in ('00','01','02','03','04','05','06','07','08');
  
ami_1=0;chf_1=0;pn_1=0;copd_1=0; 

if PRNCPAL_DGNS_CD in ('41000','41001',  '41011',  '41020',  '41021',  '41030', '41031',  '41040',  '41041',  '41050',  '41051',  '41060',  '41061',  '41070',  '41071',  '41080',  '41081',  '41090',  '41091', '4110')
then AMI_1=1; 

if PRNCPAL_DGNS_CD in ('40201', '40211', '40291', '40401', '40403', '40411', '40413', '40491', '40493', '4280', '4281', '42820', '42821', '42822', '42823', '42830', '42831', '42832', '42833', '42840', '42841', '42842', '42843', '4289','48283')
then  chf_1=1; 

if PRNCPAL_DGNS_CD in ('4800', '4801', '4802', '4803', '4808', '4809', 
						'481', '4820', '4821', 
						'4822', '48230', '48231', '48232', '48239', '48240', '48241', '48242', '48249', '48281', '48282', '48284', '48289', '4829', 
						'4830', '4831', '4838', '485', '486', '4870', '48811'  )
then pn_1=1; 
 
if PRNCPAL_DGNS_CD in ("49121","49122","4918", "4919",  "4928", "49320","49321","49322",  "496","51881", "51882", "51884", "7991")
then copd_1=1;



ami_2=0;chf_2=0;pn_2=0;copd_2=0; 

do j=1 to 25;

if icd{j} in ('41000','41001',  '41011',  '41020',  '41021',  '41030', '41031',  '41040',  '41041',  '41050',  '41051',  '41060',  '41061',  '41070',  '41071',  '41080',  '41081',  '41090',  '41091', '4110')
then AMI_2=1; 

if icd{j} in ('40201', '40211', '40291', '40401', '40403', '40411', '40413', '40491', '40493', '4280', '4281', '42820', '42821', '42822', '42823', '42830', '42831', '42832', '42833', '42840', '42841', '42842', '42843', '4289','48283')
then  chf_2=1; 

if icd{j} in ('4800', '4801', '4802', '4803', '4808', '4809', 
						'481', '4820', '4821', 
						'4822', '48230', '48231', '48232', '48239', '48240', '48241', '48242', '48249', '48281', '48282', '48284', '48289', '4829', 
						'4830', '4831', '4838', '485', '486', '4870', '48811'  )
then pn_2=1; 
 
if icd{j} in ("49121","49122","4918", "4919",  "4928", "49320","49321","49322",  "496","51881", "51882", "51884", "7991")
then copd_2=1;

end;


keep bene_id  clm_id  ADMSN_DT DSCHRGDT provider  type  ami_1 chf_1 pn_1 copd_1  ami_2 chf_2 pn_2 copd_2 ;
proc sort nodupkey;by bene_id  ADMSN_DT DSCHRGDT;
run;
  
proc sql;
	create table temp&yr._1  as
	select *
	from temp&yr._0 
	where bene_id in (select bene_id from  bene&yr.);
quit;

proc sort data=temp&yr._1 ;by provider;run;

proc sql;
create table Adm&yr. as
select provider, sum(AMI_1) as AMI1_&yr.,sum(AMI_2) as AMI2_&yr.,
sum(CHF_1) as CHF1_&yr.,sum(CHF_2) as CHF2_&yr.,
sum(PN_1) as PN1_&yr.,sum(PN_2) as PN2_&yr.,
sum(COPD_1) as COPD1_&yr.,sum(COPD_2) as COPD2_&yr. 
from temp&yr._1
group by provider;
quit;

proc sort data=Adm&yr. ;by provider;run;
%mend Adm;
%Adm(yr=2008);
%Adm(yr=2009);
%Adm(yr=2010);
%Adm(yr=2011);
%Adm(yr=2012);
%Adm(yr=2013);

libname irene 'I:\Projects\Irene';
data irene.Admission;
merge Adm2008(in=in2008) Adm2009(in=in2009) Adm2010(in=in2010)  Adm2011(in=in2011) Adm2012(in=in2012) Adm2013(in=in2013);
by provider;
if in2008=1 or in2009=1 or in2010=1 or in2011=1 or in2012=1 or in2013=1;
proc means sum;
var AMI1_2008 AMI1_2009 AMI1_2010 AMI1_2011 AMI1_2012 AMI1_2013
    AMI2_2008 AMI2_2009 AMI2_2010 AMI2_2011 AMI2_2012 AMI2_2013
    CHF1_2008 CHF1_2009 CHF1_2010 CHF1_2011 CHF1_2012 CHF1_2013
    CHF2_2008 CHF2_2009 CHF2_2010 CHF2_2011 CHF2_2012 CHF2_2013
    PN1_2008 PN1_2009 PN1_2010 PN1_2011 PN1_2012 PN1_2013
    PN2_2008 PN2_2009 PN2_2010 PN2_2011 PN2_2012 PN2_2013
    copd1_2008 copd1_2009 copd1_2010 copd1_2011 copd1_2012 copd1_2013
    copd2_2008 copd2_2009 copd2_2010 copd2_2011 copd2_2012 copd2_2013;
run;
 




 
