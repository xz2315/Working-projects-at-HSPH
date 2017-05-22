**********************************
Transient and Persistent HC
Xiner Zhou
7/13/2016
**********************************;
libname MMleads 'C:\data\Data\MMLEADS\Data';

 
/*

5.	Persistent vs. Transience in HC duals

　	Number and proportion of each of the following [no segments; use all patients available]:
　	HC Duals in 2008, 2009 and 2010  
　	Non HC Duals in 2008, 2009, 2010

　	HC Duals in 2008, 2009 but not 2010
　	HC Duals in 2008, but not 2009 or 2010

　	Non HC Duals in 2008, but HC in 2009, 2010
　	Non HC Duals in 2008, 2009 but HC in 2010

Characteristics of each of the groups above
Cost and Utilization in 2010
Preventable spending in Duals
*/
  
data temp;
set mmleads.data2008(in=in1) mmleads.data2009(in=in2) mmleads.data2010(in=in3) ;
if in1 then year=2008;
if in2 then year=2009;
if in3 then year=2010;
keep bene_id year;proc sort nodupkey;by bene_id year; 
run;

proc sql;
create table temp1 as
select bene_id, case when count(*)=3 then 1 else 0 end as in3Yr
from temp
group by bene_id;
quit;

proc sql;
create table data2008 as
select *, case when bene_id in (select bene_id from temp1 where in3yr=1) then 1 else 0 end as in3yr
from mmleads.data2008;
quit;
proc sql;
create table data2009 as
select *, case when bene_id in (select bene_id from temp1 where in3yr=1) then 1 else 0 end as in3yr
from mmleads.data2009;
quit;
proc sql;
create table data2010 as
select *, case when bene_id in (select bene_id from temp1 where in3yr=1) then 1 else 0 end as in3yr
from mmleads.data2010;
quit;

 
proc sql;
create table data2008_1 as
select *, 
case when in3yr=1 and HC10_PMT=1 and bene_id in (select bene_id from data2009 where in3yr=1 and HC10_PMT=1) and bene_id in (select bene_id from data2010 where in3yr=1 and HC10_PMT=1)  
     then "HC,HC,HC"
	 when in3yr=1 and HC10_PMT=1 and bene_id in (select bene_id from data2009 where in3yr=1 and HC10_PMT=1) and bene_id in (select bene_id from data2010 where in3yr=1 and HC10_PMT=0)  
     then "HC,HC,Non-HC"
	 when in3yr=1 and HC10_PMT=1 and bene_id in (select bene_id from data2009 where in3yr=1 and HC10_PMT=0) and bene_id in (select bene_id from data2010 where in3yr=1 and HC10_PMT=1)  
     then "HC,Non-HC,HC"
     when in3yr=1 and HC10_PMT=1 and bene_id in (select bene_id from data2009 where in3yr=1 and HC10_PMT=0) and bene_id in (select bene_id from data2010 where in3yr=1 and HC10_PMT=0)  
     then "HC,Non-HC,Non-HC"

     when in3yr=1 and HC10_PMT=0 and bene_id in (select bene_id from data2009 where in3yr=1 and HC10_PMT=1) and bene_id in (select bene_id from data2010 where in3yr=1 and HC10_PMT=1)  
     then "Non-HC,HC,HC"
	 when in3yr=1 and HC10_PMT=0 and bene_id in (select bene_id from data2009 where in3yr=1 and HC10_PMT=1) and bene_id in (select bene_id from data2010 where in3yr=1 and HC10_PMT=0)  
     then "Non-HC,HC,Non-HC"
	 when in3yr=1 and HC10_PMT=0 and bene_id in (select bene_id from data2009 where in3yr=1 and HC10_PMT=0) and bene_id in (select bene_id from data2010 where in3yr=1 and HC10_PMT=1)  
     then "Non-HC,Non-HC,HC"
     when in3yr=1 and HC10_PMT=0 and bene_id in (select bene_id from data2009 where in3yr=1 and HC10_PMT=0) and bene_id in (select bene_id from data2010 where in3yr=1 and HC10_PMT=0)  
     then "Non-HC,Non-HC,Non-HC"
     
	 when in3yr=0 and HC10_PMT=1 then "HC 2008, but Not in 2009 and 2010"
	 when in3yr=0 and HC10_PMT=0 then "Non-HC 2008, but Not in 2009 and 2010"
end as trt
from data2008;
quit;
 

* Tabulate Sample 1 ;
proc freq data=data2008_1 ;tables trt /missing;run;

proc sql;
create table data2010_2 as
select *, 
case when HC10_PMT=1 and bene_id in (select bene_id from data2009 where HC10_PMT=1) and bene_id in (select bene_id from data2010 where HC10_PMT=1)  
     then "2008 HC, 2009 HC, 2010 HC"
	 when HC10_PMT=1 and bene_id in (select bene_id from data2009 where HC10_PMT=1) and bene_id in (select bene_id from data2010 where HC10_PMT=0)  
     then "2008 HC, 2009 HC, 2010 non-HC"
	 when HC10_PMT=1 and bene_id in (select bene_id from data2009 where HC10_PMT=1) and bene_id not in (select bene_id from data2010 )  
     then "2008 HC, 2009 HC, Died or not Dual 2010"

     when HC10_PMT=1 and bene_id in (select bene_id from data2009 where HC10_PMT=0) and bene_id in (select bene_id from data2010 where HC10_PMT=1)  
     then "2008 HC, 2009 non-HC, 2010 HC"
	 when HC10_PMT=1 and bene_id in (select bene_id from data2009 where HC10_PMT=0) and bene_id in (select bene_id from data2010 where HC10_PMT=0)  
     then "2008 HC, 2009 non-HC, 2010 non-HC"
	 when HC10_PMT=1 and bene_id in (select bene_id from data2009 where HC10_PMT=0) and bene_id not in (select bene_id from data2010 )  
     then "2008 HC, 2009 non-HC, Died or not Dual 2010"

	 when HC10_PMT=1 and bene_id not in (select bene_id from data2009 ) and bene_id in (select bene_id from data2010 where HC10_PMT=1)  
     then "2008 HC, 2009 Died or not Dual, 2010 HC"
	 when HC10_PMT=1 and bene_id not in (select bene_id from data2009 ) and bene_id in (select bene_id from data2010 where HC10_PMT=0)  
     then "2008 HC, 2009 Died or not Dual, 2010 non-HC"
	 when HC10_PMT=1 and bene_id not in (select bene_id from data2009 ) and bene_id not in (select bene_id from data2010 )  
     then "2008 HC, 2009 Died or not Dual, Died or not Dual 2010"

     when HC10_PMT=0 and bene_id in (select bene_id from data2009 where HC10_PMT=1) and bene_id in (select bene_id from data2010 where HC10_PMT=1)  
     then "2008 non-HC, 2009 HC, 2010 HC"
	 when HC10_PMT=0 and bene_id in (select bene_id from data2009 where HC10_PMT=1) and bene_id in (select bene_id from data2010 where HC10_PMT=0)  
     then "2008 non-HC, 2009 HC, 2010 non-HC"
	 when HC10_PMT=0 and bene_id in (select bene_id from data2009 where HC10_PMT=1) and bene_id not in (select bene_id from data2010 )  
     then "2008 non-HC, 2009 HC, Died or not Dual 2010"

     when HC10_PMT=0 and bene_id in (select bene_id from data2009 where HC10_PMT=0) and bene_id in (select bene_id from data2010 where HC10_PMT=1)  
     then "2008 non-HC, 2009 non-HC, 2010 HC"
	 when HC10_PMT=0 and bene_id in (select bene_id from data2009 where HC10_PMT=0) and bene_id in (select bene_id from data2010 where HC10_PMT=0)  
     then "2008 non-HC, 2009 non-HC, 2010 non-HC"
	 when HC10_PMT=0 and bene_id in (select bene_id from data2009 where HC10_PMT=0) and bene_id not in (select bene_id from data2010 )  
     then "2008 non-HC, 2009 non-HC, Died or not Dual 2010"

	 when HC10_PMT=0 and bene_id not in (select bene_id from data2009 ) and bene_id in (select bene_id from data2010 where HC10_PMT=1)  
     then "2008 non-HC, 2009 Died or not Dual, 2010 HC"
	 when HC10_PMT=0 and bene_id not in (select bene_id from data2009 ) and bene_id in (select bene_id from data2010 where HC10_PMT=0)  
     then "2008 non-HC, 2009 Died or not Dual, 2010 non-HC"
	 when HC10_PMT=0 and bene_id not in (select bene_id from data2009 ) and bene_id not in (select bene_id from data2010 )  
     then "2008 non-HC, 2009 Died or not Dual, Died or not Dual 2010"
end as trt
from data2008;
quit;
 
* Tabulate Sample 2 ;
proc freq data=data2010_2 ;tables trt /missing;run;
 

* Demographics Tabulation;

proc tabulate data=data2010_1  noseps  ;
class trt  edu mhi; 

table (
edu="Stratify by Zip Code Prop. College Education Degree in Quartiles" mhi="Stratify by Zip Code Median Income in Quartiles"
),(trt="Persistent vs. Transience in HC duals"*(n colpctn)  all*(n colpctn))/RTS=25;

run;


proc tabulate data=data2010_1  noseps  ;
class trt D_sex D_MEDICARE_RACE AgeGroup E_MS_CD E_BOE ; 
var 
HYPTHY_COMBINED AMI_COMBINED ALZ_COMBINED ANEMIA_COMBINED ASTHMA_COMBINED AFIB_COMBINED HYPPLA_COMBINED 
CAT_COMBINED CKD_COMBINED COPD_COMBINED CHF_COMBINED DEPR_COMBINED DIAB_COMBINED GLCM_COMBINED HFRAC_COMBINED 
HYPLIP_COMBINED HYPTEN_COMBINED IHD_COMBINED OST_COMBINED RAOA_COMBINED STRK_COMBINED BRC_COMBINED CRC_COMBINED 
LNGC_COMBINED PRC_COMBINED ENDC_COMBINED ACP_COMBINED ANXI_COMBINED BIPL_COMBINED DEPSN_COMBINED PSDS_COMBINED 
PTRA_COMBINED SCHI_COMBINED SCHIOT_COMBINED TOBA_COMBINED AUTISM_COMBINED BRAINJ_COMBINED CERPAL_COMBINED 
CYSFIB_COMBINED EPILEP_COMBINED HEARIM_COMBINED INTDIS_COMBINED LEADIS_COMBINED MOBIMP_COMBINED MULSCL_COMBINED 
MUSDYS_COMBINED SPIBIF_COMBINED SPIINJ_COMBINED VISUAL_COMBINED ALCO_COMBINED DRUG_COMBINED FIBRO_COMBINED 
HEPVIRAL_COMBINED HEPB_ACT_COMBINED HEPB_CHR_COMBINED HEPC_ACT_COMBINED HEPC_CHR_COMBINED HEPC_UNS_COMBINED 
HEPD_COMBINED HEPE_COMBINED HIVAIDS_1YR_COMBINED HIVAIDS_COMBINED HIVARV_COMBINED 
LEUKLYMPH_COMBINED LIVER_COMBINED MIGRAINE_COMBINED 
OBESITY_COMBINED OTHDEL_COMBINED PVD_COMBINED ULCERS_COMBINED;
   
table (D_sex="Gender" D_MEDICARE_RACE="Race"  AgeGroup="Age" E_MS_CD="Medicare status code" E_BOE="Medicaid Basis of Eligibility"
),(trt="Persistent vs. Transience in HC duals"*(n colpctn)  all*(n colpctn))/RTS=25;

table (
HYPTHY_COMBINED AMI_COMBINED ALZ_COMBINED ANEMIA_COMBINED ASTHMA_COMBINED AFIB_COMBINED HYPPLA_COMBINED 
CAT_COMBINED CKD_COMBINED COPD_COMBINED CHF_COMBINED DEPR_COMBINED DIAB_COMBINED GLCM_COMBINED HFRAC_COMBINED 
HYPLIP_COMBINED HYPTEN_COMBINED IHD_COMBINED OST_COMBINED RAOA_COMBINED STRK_COMBINED BRC_COMBINED CRC_COMBINED 
LNGC_COMBINED PRC_COMBINED ENDC_COMBINED ACP_COMBINED ANXI_COMBINED BIPL_COMBINED DEPSN_COMBINED PSDS_COMBINED 
PTRA_COMBINED SCHI_COMBINED SCHIOT_COMBINED TOBA_COMBINED AUTISM_COMBINED BRAINJ_COMBINED CERPAL_COMBINED 
CYSFIB_COMBINED EPILEP_COMBINED HEARIM_COMBINED INTDIS_COMBINED LEADIS_COMBINED MOBIMP_COMBINED MULSCL_COMBINED 
MUSDYS_COMBINED SPIBIF_COMBINED SPIINJ_COMBINED VISUAL_COMBINED ALCO_COMBINED DRUG_COMBINED FIBRO_COMBINED 
HEPVIRAL_COMBINED HEPB_ACT_COMBINED HEPB_CHR_COMBINED HEPC_ACT_COMBINED HEPC_CHR_COMBINED HEPC_UNS_COMBINED 
HEPD_COMBINED HEPE_COMBINED HIVAIDS_COMBINED 
LEUKLYMPH_COMBINED LIVER_COMBINED MIGRAINE_COMBINED 
OBESITY_COMBINED OTHDEL_COMBINED PVD_COMBINED ULCERS_COMBINED),
(trt="HC Groups"*(mean*f=7.4  sum*f=7.4)  all*(mean*f=7.4  sum*f=7.4))/RTS=25;
 
 Keylabel all="All Dual Eligible"
         N="Number of Beneficiary"
		 colpctn="Column Percent";
 
format  D_MEDICARE_RACE $race_. E_MS_CD $E_MS_CD_. E_BOE $E_BOE_.; 


run;

*Preventable spending in Duals;
libname PQI 'C:\data\Projects\Peterson\Data';
proc sql;
create table temp1 as
select a.*,
b.N_TAPQ01 as N_TAPQ012008, b.TAPQ01Spending as TAPQ01Spending2008, 
b.N_TAPQ02 as N_TAPQ022008, b.TAPQ02Spending as TAPQ02Spending2008, 
b.N_TAPQ03 as N_TAPQ032008, b.TAPQ03Spending as TAPQ03Spending2008, 
b.N_TAPQ05 as N_TAPQ052008, b.TAPQ05Spending as TAPQ05Spending2008, 
b.N_TAPQ07 as N_TAPQ072008, b.TAPQ07Spending as TAPQ07Spending2008, 
b.N_TAPQ08 as N_TAPQ082008, b.TAPQ08Spending as TAPQ08Spending2008, 
b.N_TAPQ10 as N_TAPQ102008, b.TAPQ10Spending as TAPQ10Spending2008, 
b.N_TAPQ11 as N_TAPQ112008, b.TAPQ11Spending as TAPQ11Spending2008, 
b.N_TAPQ12 as N_TAPQ122008, b.TAPQ12Spending as TAPQ12Spending2008,
b.N_TAPQ13 as N_TAPQ132008, b.TAPQ13Spending as TAPQ13Spending2008, 
b.N_TAPQ14 as N_TAPQ142008, b.TAPQ14Spending as TAPQ14Spending2008, 
b.N_TAPQ15 as N_TAPQ152008, b.TAPQ15Spending as TAPQ15Spending2008, 
b.N_TAPQ16 as N_TAPQ162008, b.TAPQ16Spending as TAPQ16Spending2008, 
b.N_TAPQ90 as N_TAPQ902008, b.TAPQ90Spending as TAPQ90Spending2008, 
b.N_TAPQ91 as N_TAPQ912008, b.TAPQ91Spending as TAPQ91Spending2008,
b.N_TAPQ92 as N_TAPQ922008, b.TAPQ92Spending as TAPQ92Spending2008
from data2008_1 a left join PQI.PQI2008  b
on a.bene_id=b.bene_id;
quit;
proc sql;
create table temp2 as
select a.*,
b.N_TAPQ01 as N_TAPQ012009, b.TAPQ01Spending as TAPQ01Spending2009, 
b.N_TAPQ02 as N_TAPQ022009, b.TAPQ02Spending as TAPQ02Spending2009, 
b.N_TAPQ03 as N_TAPQ032009, b.TAPQ03Spending as TAPQ03Spending2009, 
b.N_TAPQ05 as N_TAPQ052009, b.TAPQ05Spending as TAPQ05Spending2009, 
b.N_TAPQ07 as N_TAPQ072009, b.TAPQ07Spending as TAPQ07Spending2009, 
b.N_TAPQ08 as N_TAPQ082009, b.TAPQ08Spending as TAPQ08Spending2009, 
b.N_TAPQ10 as N_TAPQ102009, b.TAPQ10Spending as TAPQ10Spending2009, 
b.N_TAPQ11 as N_TAPQ112009, b.TAPQ11Spending as TAPQ11Spending2009, 
b.N_TAPQ12 as N_TAPQ122009, b.TAPQ12Spending as TAPQ12Spending2009,
b.N_TAPQ13 as N_TAPQ132009, b.TAPQ13Spending as TAPQ13Spending2009, 
b.N_TAPQ14 as N_TAPQ142009, b.TAPQ14Spending as TAPQ14Spending2009, 
b.N_TAPQ15 as N_TAPQ152009, b.TAPQ15Spending as TAPQ15Spending2009, 
b.N_TAPQ16 as N_TAPQ162009, b.TAPQ16Spending as TAPQ16Spending2009, 
b.N_TAPQ90 as N_TAPQ902009, b.TAPQ90Spending as TAPQ90Spending2009, 
b.N_TAPQ91 as N_TAPQ912009, b.TAPQ91Spending as TAPQ91Spending2009,
b.N_TAPQ92 as N_TAPQ922009, b.TAPQ92Spending as TAPQ92Spending2009
from temp1 a left join PQI.PQI2009  b
on a.bene_id=b.bene_id;
quit;
proc sql;
create table temp  as
select a.*,
b.N_TAPQ01 as N_TAPQ012010, b.TAPQ01Spending as TAPQ01Spending2010, 
b.N_TAPQ02 as N_TAPQ022010, b.TAPQ02Spending as TAPQ02Spending2010, 
b.N_TAPQ03 as N_TAPQ032010, b.TAPQ03Spending as TAPQ03Spending2010, 
b.N_TAPQ05 as N_TAPQ052010, b.TAPQ05Spending as TAPQ05Spending2010, 
b.N_TAPQ07 as N_TAPQ072010, b.TAPQ07Spending as TAPQ07Spending2010, 
b.N_TAPQ08 as N_TAPQ082010, b.TAPQ08Spending as TAPQ08Spending2010, 
b.N_TAPQ10 as N_TAPQ102010, b.TAPQ10Spending as TAPQ10Spending2010, 
b.N_TAPQ11 as N_TAPQ112010, b.TAPQ11Spending as TAPQ11Spending2010, 
b.N_TAPQ12 as N_TAPQ122010, b.TAPQ12Spending as TAPQ12Spending2010,
b.N_TAPQ13 as N_TAPQ132010, b.TAPQ13Spending as TAPQ13Spending2010, 
b.N_TAPQ14 as N_TAPQ142010, b.TAPQ14Spending as TAPQ14Spending2010, 
b.N_TAPQ15 as N_TAPQ152010, b.TAPQ15Spending as TAPQ15Spending2010, 
b.N_TAPQ16 as N_TAPQ162010, b.TAPQ16Spending as TAPQ16Spending2010, 
b.N_TAPQ90 as N_TAPQ902010, b.TAPQ90Spending as TAPQ90Spending2010, 
b.N_TAPQ91 as N_TAPQ912010, b.TAPQ91Spending as TAPQ91Spending2010,
b.N_TAPQ92 as N_TAPQ922010, b.TAPQ92Spending as TAPQ92Spending2010
from temp2 a left join PQI.PQI2010  b
on a.bene_id=b.bene_id;
quit;

data temp;
set temp;
array try {96} N_TAPQ012008 TAPQ01Spending2008 
               N_TAPQ022008 TAPQ02Spending2008 
               N_TAPQ032008 TAPQ03Spending2008 
			   N_TAPQ052008 TAPQ05Spending2008 
			   N_TAPQ072008 TAPQ07Spending2008 
			   N_TAPQ082008 TAPQ08Spending2008 
			   N_TAPQ102008 TAPQ10Spending2008 
			   N_TAPQ112008 TAPQ11Spending2008 
               N_TAPQ122008 TAPQ12Spending2008
               N_TAPQ132008 TAPQ13Spending2008 
               N_TAPQ142008 TAPQ14Spending2008 
               N_TAPQ152008 TAPQ15Spending2008 
               N_TAPQ162008 TAPQ16Spending2008 
               N_TAPQ902008 TAPQ90Spending2008 
               N_TAPQ912008 TAPQ91Spending2008
               N_TAPQ922008 TAPQ92Spending2008 
			   N_TAPQ012009 TAPQ01Spending2009 
               N_TAPQ022009 TAPQ02Spending2009 
               N_TAPQ032009 TAPQ03Spending2009 
			   N_TAPQ052009 TAPQ05Spending2009 
			   N_TAPQ072009 TAPQ07Spending2009 
			   N_TAPQ082009 TAPQ08Spending2009 
			   N_TAPQ102009 TAPQ10Spending2009 
			   N_TAPQ112009 TAPQ11Spending2009 
               N_TAPQ122009 TAPQ12Spending2009
               N_TAPQ132009 TAPQ13Spending2009 
               N_TAPQ142009 TAPQ14Spending2009 
               N_TAPQ152009 TAPQ15Spending2009 
               N_TAPQ162009 TAPQ16Spending2009 
               N_TAPQ902009 TAPQ90Spending2009 
               N_TAPQ912009 TAPQ91Spending2009
               N_TAPQ922009 TAPQ92Spending2009 
			   N_TAPQ012010 TAPQ01Spending2010 
               N_TAPQ022010 TAPQ02Spending2010 
               N_TAPQ032010 TAPQ03Spending2010 
			   N_TAPQ052010 TAPQ05Spending2010 
			   N_TAPQ072010 TAPQ07Spending2010 
			   N_TAPQ082010 TAPQ08Spending2010 
			   N_TAPQ102010 TAPQ10Spending2010 
			   N_TAPQ112010 TAPQ11Spending2010 
               N_TAPQ122010 TAPQ12Spending2010
               N_TAPQ132010 TAPQ13Spending2010 
               N_TAPQ142010 TAPQ14Spending2010 
               N_TAPQ152010 TAPQ15Spending2010 
               N_TAPQ162010 TAPQ16Spending2010 
               N_TAPQ902010 TAPQ90Spending2010 
               N_TAPQ912010 TAPQ91Spending2010
               N_TAPQ922010 TAPQ92Spending2010 
			   
;
do i=1 to 96;
if try{i}<0 then try{i}=0;
end;
drop i;

N_TAPQ01=(N_TAPQ012008+N_TAPQ012009+N_TAPQ012010)/3;
TAPQ01Spending=(TAPQ01Spending2008+TAPQ01Spending2009+TAPQ01Spending2010)/3;
N_TAPQ02=(N_TAPQ022008+N_TAPQ022009+N_TAPQ022010)/3;
TAPQ02Spending=(TAPQ02Spending2008+TAPQ02Spending2009+TAPQ02Spending2010)/3;
N_TAPQ03=(N_TAPQ032008+N_TAPQ032009+N_TAPQ032010)/3;
TAPQ03Spending=(TAPQ03Spending2008+TAPQ03Spending2009+TAPQ03Spending2010)/3;
N_TAPQ05=(N_TAPQ052008+N_TAPQ052009+N_TAPQ052010)/3;
TAPQ05Spending=(TAPQ05Spending2008+TAPQ05Spending2009+TAPQ05Spending2010)/3;
N_TAPQ07=(N_TAPQ072008+N_TAPQ072009+N_TAPQ072010)/3;
TAPQ07Spending=(TAPQ07Spending2008+TAPQ07Spending2009+TAPQ07Spending2010)/3;
N_TAPQ08=(N_TAPQ082008+N_TAPQ082009+N_TAPQ082010)/3;
TAPQ08Spending=(TAPQ08Spending2008+TAPQ08Spending2009+TAPQ08Spending2010)/3;
N_TAPQ10=(N_TAPQ102008+N_TAPQ102009+N_TAPQ102010)/3;
TAPQ10Spending=(TAPQ10Spending2008+TAPQ10Spending2009+TAPQ10Spending2010)/3;
N_TAPQ11=(N_TAPQ112008+N_TAPQ112009+N_TAPQ112010)/3;
TAPQ11Spending=(TAPQ11Spending2008+TAPQ11Spending2009+TAPQ11Spending2010)/3;
N_TAPQ12=(N_TAPQ122008+N_TAPQ122009+N_TAPQ122010)/3;
TAPQ12Spending=(TAPQ12Spending2008+TAPQ12Spending2009+TAPQ12Spending2010)/3;
N_TAPQ13=(N_TAPQ132008+N_TAPQ132009+N_TAPQ132010)/3;
TAPQ13Spending=(TAPQ13Spending2008+TAPQ13Spending2009+TAPQ13Spending2010)/3;
N_TAPQ14=(N_TAPQ142008+N_TAPQ142009+N_TAPQ142010)/3;
TAPQ14Spending=(TAPQ14Spending2008+TAPQ14Spending2009+TAPQ14Spending2010)/3;
N_TAPQ15=(N_TAPQ152008+N_TAPQ152009+N_TAPQ152010)/3;
TAPQ15Spending=(TAPQ15Spending2008+TAPQ15Spending2009+TAPQ15Spending2010)/3;
N_TAPQ16=(N_TAPQ162008+N_TAPQ162009+N_TAPQ162010)/3;
TAPQ16Spending=(TAPQ16Spending2008+TAPQ16Spending2009+TAPQ16Spending2010)/3;
N_TAPQ90=(N_TAPQ902008+N_TAPQ902009+N_TAPQ902010)/3;
TAPQ90Spending=(TAPQ90Spending2008+TAPQ90Spending2009+TAPQ90Spending2010)/3;
N_TAPQ91=(N_TAPQ912008+N_TAPQ912009+N_TAPQ912010)/3;
TAPQ91Spending=(TAPQ91Spending2008+TAPQ91Spending2009+TAPQ91Spending2010)/3;
N_TAPQ92=(N_TAPQ922008+N_TAPQ922009+N_TAPQ922010)/3;
TAPQ92Spending=(TAPQ92Spending2008+TAPQ92Spending2009+TAPQ92Spending2010)/3;



run;

proc tabulate data=temp noseps  ;
where trt not in ("HC 2008, but Not in 2009 and 2010","Non-HC 2008, but Not in 2009 and 2010");
class trt;
var 
N_TAPQ012008 TAPQ01Spending2008 
               N_TAPQ022008 TAPQ02Spending2008 
               N_TAPQ032008 TAPQ03Spending2008 
			   N_TAPQ052008 TAPQ05Spending2008 
			   N_TAPQ072008 TAPQ07Spending2008 
			   N_TAPQ082008 TAPQ08Spending2008 
			   N_TAPQ102008 TAPQ10Spending2008 
			   N_TAPQ112008 TAPQ11Spending2008 
               N_TAPQ122008 TAPQ12Spending2008
               N_TAPQ132008 TAPQ13Spending2008 
               N_TAPQ142008 TAPQ14Spending2008 
               N_TAPQ152008 TAPQ15Spending2008 
               N_TAPQ162008 TAPQ16Spending2008 
               N_TAPQ902008 TAPQ90Spending2008 
               N_TAPQ912008 TAPQ91Spending2008
               N_TAPQ922008 TAPQ92Spending2008 
			   N_TAPQ012009 TAPQ01Spending2009 
               N_TAPQ022009 TAPQ02Spending2009 
               N_TAPQ032009 TAPQ03Spending2009 
			   N_TAPQ052009 TAPQ05Spending2009 
			   N_TAPQ072009 TAPQ07Spending2009 
			   N_TAPQ082009 TAPQ08Spending2009 
			   N_TAPQ102009 TAPQ10Spending2009 
			   N_TAPQ112009 TAPQ11Spending2009 
               N_TAPQ122009 TAPQ12Spending2009
               N_TAPQ132009 TAPQ13Spending2009 
               N_TAPQ142009 TAPQ14Spending2009 
               N_TAPQ152009 TAPQ15Spending2009 
               N_TAPQ162009 TAPQ16Spending2009 
               N_TAPQ902009 TAPQ90Spending2009 
               N_TAPQ912009 TAPQ91Spending2009
               N_TAPQ922009 TAPQ92Spending2009 
			   N_TAPQ012010 TAPQ01Spending2010 
               N_TAPQ022010 TAPQ02Spending2010 
               N_TAPQ032010 TAPQ03Spending2010 
			   N_TAPQ052010 TAPQ05Spending2010 
			   N_TAPQ072010 TAPQ07Spending2010 
			   N_TAPQ082010 TAPQ08Spending2010 
			   N_TAPQ102010 TAPQ10Spending2010 
			   N_TAPQ112010 TAPQ11Spending2010 
               N_TAPQ122010 TAPQ12Spending2010
               N_TAPQ132010 TAPQ13Spending2010 
               N_TAPQ142010 TAPQ14Spending2010 
               N_TAPQ152010 TAPQ15Spending2010 
               N_TAPQ162010 TAPQ16Spending2010 
               N_TAPQ902010 TAPQ90Spending2010 
               N_TAPQ912010 TAPQ91Spending2010
               N_TAPQ922010 TAPQ92Spending2010 

			   N_TAPQ01 TAPQ01Spending 
               N_TAPQ02 TAPQ02Spending  
               N_TAPQ03 TAPQ03Spending 
			   N_TAPQ05 TAPQ05Spending 
			   N_TAPQ07 TAPQ07Spending 
			   N_TAPQ08 TAPQ08Spending 
			   N_TAPQ10 TAPQ10Spending 
			   N_TAPQ11 TAPQ11Spending 
               N_TAPQ12 TAPQ12Spending 
               N_TAPQ13 TAPQ13Spending 
               N_TAPQ14 TAPQ14Spending 
               N_TAPQ15 TAPQ15Spending 
               N_TAPQ16 TAPQ16Spending 
               N_TAPQ90 TAPQ90Spending 
               N_TAPQ91 TAPQ91Spending 
               N_TAPQ92 TAPQ92Spending ;

table 
(N_TAPQ01 
N_TAPQ02 
N_TAPQ03 
N_TAPQ05 
N_TAPQ07 
N_TAPQ08 
N_TAPQ10 
N_TAPQ11  
N_TAPQ12  
N_TAPQ13 
N_TAPQ14  
N_TAPQ15 
N_TAPQ16 
N_TAPQ90  
N_TAPQ91  
N_TAPQ92  ),
trt="Persistent vs. Transience in HC duals"*(mean*f=7.4  sum*f=7.4 ) All*(mean*f=7.4  sum*f=7.4  )  ;
table 
TAPQ01spending 
TAPQ02spending 
TAPQ03spending 
TAPQ05spending 
TAPQ07spending 
TAPQ08spending 
TAPQ10spending 
TAPQ11spending 
TAPQ12spending 
TAPQ13spending 
TAPQ14spending 
TAPQ15spending 
TAPQ16spending 
TAPQ90spending 
TAPQ91spending 
TAPQ92spending
,trt="Persistent vs. Transience in HC duals"*(mean*f=dollar12. sum*f=dollar12. ) 
All*(mean*f=7.4  sum*f=7.4  );

*2008;
table 
(N_TAPQ012008
N_TAPQ022008 
N_TAPQ032008
N_TAPQ052008 
N_TAPQ072008 
N_TAPQ082008 
N_TAPQ102008 
N_TAPQ112008  
N_TAPQ122008  
N_TAPQ132008 
N_TAPQ142008  
N_TAPQ152008 
N_TAPQ162008 
N_TAPQ902008  
N_TAPQ912008  
N_TAPQ922008  ),
trt="Persistent vs. Transience in HC duals"*(mean*f=7.4  sum*f=7.4 ) All*(mean*f=7.4  sum*f=7.4  )  ;
table 
TAPQ01spending2008 
TAPQ02spending2008 
TAPQ03spending2008 
TAPQ05spending2008 
TAPQ07spending2008 
TAPQ08spending2008 
TAPQ10spending2008 
TAPQ11spending2008 
TAPQ12spending2008 
TAPQ13spending2008 
TAPQ14spending2008 
TAPQ15spending2008 
TAPQ16spending2008 
TAPQ90spending2008 
TAPQ91spending2008 
TAPQ92spending2008
,trt="Persistent vs. Transience in HC duals"*(mean*f=dollar12. sum*f=dollar12. ) 
All*(mean*f=7.4  sum*f=7.4  );

*2009;
table 
(N_TAPQ012009
N_TAPQ022009 
N_TAPQ032009
N_TAPQ052009 
N_TAPQ072009 
N_TAPQ082009 
N_TAPQ102009 
N_TAPQ112009  
N_TAPQ122009  
N_TAPQ132009 
N_TAPQ142009  
N_TAPQ152009
N_TAPQ162009 
N_TAPQ902009  
N_TAPQ912009  
N_TAPQ922009  ),
trt="Persistent vs. Transience in HC duals"*(mean*f=7.4  sum*f=7.4 ) All*(mean*f=7.4  sum*f=7.4  )  ;
table 
TAPQ01spending2009
TAPQ02spending2009
TAPQ03spending2009 
TAPQ05spending2009 
TAPQ07spending2009
TAPQ08spending2009
TAPQ10spending2009 
TAPQ11spending2009 
TAPQ12spending2009 
TAPQ13spending2009 
TAPQ14spending2009
TAPQ15spending2009 
TAPQ16spending2009 
TAPQ90spending2009 
TAPQ91spending2009 
TAPQ92spending2009
,trt="Persistent vs. Transience in HC duals"*(mean*f=dollar12. sum*f=dollar12. ) 
All*(mean*f=7.4  sum*f=7.4  );

*2010;
table 
(N_TAPQ012010
N_TAPQ022010
N_TAPQ032010
N_TAPQ052010
N_TAPQ072010
N_TAPQ082010 
N_TAPQ102010
N_TAPQ112010  
N_TAPQ122010 
N_TAPQ132010 
N_TAPQ142010  
N_TAPQ152010
N_TAPQ162010 
N_TAPQ902010 
N_TAPQ912010
N_TAPQ922010 ),
trt="Persistent vs. Transience in HC duals"*(mean*f=7.4  sum*f=7.4 ) All*(mean*f=7.4  sum*f=7.4  )  ;
table 
TAPQ01spending2010
TAPQ02spending2010
TAPQ03spending2010
TAPQ05spending2010
TAPQ07spending2010
TAPQ08spending2010
TAPQ10spending2010 
TAPQ11spending2010
TAPQ12spending2010
TAPQ13spending2010
TAPQ14spending2010
TAPQ15spending2010
TAPQ16spending2010
TAPQ90spending2010 
TAPQ91spending2010
TAPQ92spending2010
,trt="Persistent vs. Transience in HC duals"*(mean*f=dollar12. sum*f=dollar12. ) 
All*(mean*f=7.4  sum*f=7.4  );


/*
table 
TotSpending="Total Within 30-day Post PQI  Spending"
IPSpending="Within 30-day Post PQI Actual Spending:Inpatient"
OPSpending="Within 30-day Post PQI Actual Spending:Outpatient"
CarSpending="Within 30-day Post PQI Actual Spending:Carrier/Physician" 
HHASpending="Within 30-day Post PQI Actual Spending:Home Health Agency" 
SNFSpending="Within 30-day Post PQI Actual Spending:Skilled Nursing Facility" 
HspcSpending="Within 30-day Post PQI Actual Spending:Hospice"  
DMESpending="Within 30-day Post PQI Actual Spending:DME" 
,trt="Persistent vs. Transience in HC duals"*(mean*f=dollar12.  sum*f=dollar12. ) 
All*(mean*f=7.4  sum*f=7.4  );
*/
 
Keylabel all="All Beneficiary" 
         ;
run;

*Cost and Utilization in 2010;

*******************************Medicare Service-level file;

proc import datafile="C:\data\Projects\Peterson\Program-XZ\Medicare Service Level" dbms=xlsx out=level replace;getnames=yes;run;
data level;
set level;
level=_n_; 
run;
data temp2010_1 temp2010_2 temp2010_3 temp2010_4 temp2010_5 temp2010_6;
set data2010_1;
do i=1 to 55;
 level=i; 
if level<=10 then output temp2010_1;
else if level<=20 then output temp2010_2;
else if level<=30 then output temp2010_3;
else if level<=40 then output temp2010_4;
else if level<=50 then output temp2010_5;
else  output temp2010_6;
end;
drop i;

run;

proc sql;
create table sample2010_1 as
select a.*,b.SRVC_1 as SRVC_1_1,b.SRVC_2 as SRVC_2_1
from temp2010_1 a left join level b
on a.level=b.level;
quit;
proc sql;
create table sample2010_2 as
select a.*,b.SRVC_1 as SRVC_1_1,b.SRVC_2 as SRVC_2_1
from temp2010_2 a left join level b
on a.level=b.level;
quit;
proc sql;
create table sample2010_3 as
select a.*,b.SRVC_1 as SRVC_1_1,b.SRVC_2 as SRVC_2_1
from temp2010_3 a left join level b
on a.level=b.level;
quit;
proc sql;
create table sample2010_4 as
select a.*,b.SRVC_1 as SRVC_1_1,b.SRVC_2 as SRVC_2_1
from temp2010_4 a left join level b
on a.level=b.level;
quit;
proc sql;
create table sample2010_5 as
select a.*,b.SRVC_1 as SRVC_1_1,b.SRVC_2 as SRVC_2_1
from temp2010_5 a left join level b
on a.level=b.level;
quit;
proc sql;
create table sample2010_6 as
select a.*,b.SRVC_1 as SRVC_1_1,b.SRVC_2 as SRVC_2_1
from temp2010_6 a left join level b
on a.level=b.level;
quit;
 

proc sql;
create table temp1_1 as
select a.*,
b.Bene_CNT,b.USER1_CNT,b.USER2_CNT,b.SRVC_1,b.SRVC_2,b.Medicare_PMT,b.Medicare_Bene_PMT,
b.Medicare_CLM_CNT_01,b.Medicare_CLM_CNT_02,b.Medicare_CLM_CNT_03,b.Medicare_CLM_CNT_04,b.Medicare_CLM_CNT_05,b.Medicare_CLM_CNT_06,b.Medicare_CLM_CNT_07,b.Medicare_CLM_CNT_08,b.Medicare_CLM_CNT_09,b.Medicare_CLM_CNT_10,b.Medicare_CLM_CNT_11,b.Medicare_CLM_CNT_12,
b.Medicare_Day_CNT_01,b.Medicare_Day_CNT_02,b.Medicare_Day_CNT_03,b.Medicare_Day_CNT_04,b.Medicare_Day_CNT_05,b.Medicare_Day_CNT_06,b.Medicare_Day_CNT_07,b.Medicare_Day_CNT_08,b.Medicare_Day_CNT_09,b.Medicare_Day_CNT_10,b.Medicare_Day_CNT_11,b.Medicare_Day_CNT_12,
b.Medicare_Cov_Day_CNT_01,b.Medicare_Cov_Day_CNT_02,b.Medicare_Cov_Day_CNT_03,b.Medicare_Cov_Day_CNT_04,b.Medicare_Cov_Day_CNT_05,b.Medicare_Cov_Day_CNT_06,b.Medicare_Cov_Day_CNT_07,b.Medicare_Cov_Day_CNT_08,b.Medicare_Cov_Day_CNT_09,b.Medicare_Cov_Day_CNT_10,b.Medicare_Cov_Day_CNT_11,b.Medicare_Cov_Day_CNT_12

from sample2010_1 a left join MMLEADS.Mml_mrse2010 b
on a.bene_id=b.bene_id and a.SRVC_1_1=b.SRVC_1 and a.SRVC_2_1=b.SRVC_2;
quit;
proc sql;
create table temp1_2 as
select a.*,
b.Bene_CNT,b.USER1_CNT,b.USER2_CNT,b.SRVC_1,b.SRVC_2,b.Medicare_PMT,b.Medicare_Bene_PMT,
b.Medicare_CLM_CNT_01,b.Medicare_CLM_CNT_02,b.Medicare_CLM_CNT_03,b.Medicare_CLM_CNT_04,b.Medicare_CLM_CNT_05,b.Medicare_CLM_CNT_06,b.Medicare_CLM_CNT_07,b.Medicare_CLM_CNT_08,b.Medicare_CLM_CNT_09,b.Medicare_CLM_CNT_10,b.Medicare_CLM_CNT_11,b.Medicare_CLM_CNT_12,
b.Medicare_Day_CNT_01,b.Medicare_Day_CNT_02,b.Medicare_Day_CNT_03,b.Medicare_Day_CNT_04,b.Medicare_Day_CNT_05,b.Medicare_Day_CNT_06,b.Medicare_Day_CNT_07,b.Medicare_Day_CNT_08,b.Medicare_Day_CNT_09,b.Medicare_Day_CNT_10,b.Medicare_Day_CNT_11,b.Medicare_Day_CNT_12,
b.Medicare_Cov_Day_CNT_01,b.Medicare_Cov_Day_CNT_02,b.Medicare_Cov_Day_CNT_03,b.Medicare_Cov_Day_CNT_04,b.Medicare_Cov_Day_CNT_05,b.Medicare_Cov_Day_CNT_06,b.Medicare_Cov_Day_CNT_07,b.Medicare_Cov_Day_CNT_08,b.Medicare_Cov_Day_CNT_09,b.Medicare_Cov_Day_CNT_10,b.Medicare_Cov_Day_CNT_11,b.Medicare_Cov_Day_CNT_12

from sample2010_2 a left join MMLEADS.Mml_mrse2010 b
on a.bene_id=b.bene_id and a.SRVC_1_1=b.SRVC_1 and a.SRVC_2_1=b.SRVC_2;
quit;
proc sql;
create table temp1_3 as
select a.*,
b.Bene_CNT,b.USER1_CNT,b.USER2_CNT,b.SRVC_1,b.SRVC_2,b.Medicare_PMT,b.Medicare_Bene_PMT,
b.Medicare_CLM_CNT_01,b.Medicare_CLM_CNT_02,b.Medicare_CLM_CNT_03,b.Medicare_CLM_CNT_04,b.Medicare_CLM_CNT_05,b.Medicare_CLM_CNT_06,b.Medicare_CLM_CNT_07,b.Medicare_CLM_CNT_08,b.Medicare_CLM_CNT_09,b.Medicare_CLM_CNT_10,b.Medicare_CLM_CNT_11,b.Medicare_CLM_CNT_12,
b.Medicare_Day_CNT_01,b.Medicare_Day_CNT_02,b.Medicare_Day_CNT_03,b.Medicare_Day_CNT_04,b.Medicare_Day_CNT_05,b.Medicare_Day_CNT_06,b.Medicare_Day_CNT_07,b.Medicare_Day_CNT_08,b.Medicare_Day_CNT_09,b.Medicare_Day_CNT_10,b.Medicare_Day_CNT_11,b.Medicare_Day_CNT_12,
b.Medicare_Cov_Day_CNT_01,b.Medicare_Cov_Day_CNT_02,b.Medicare_Cov_Day_CNT_03,b.Medicare_Cov_Day_CNT_04,b.Medicare_Cov_Day_CNT_05,b.Medicare_Cov_Day_CNT_06,b.Medicare_Cov_Day_CNT_07,b.Medicare_Cov_Day_CNT_08,b.Medicare_Cov_Day_CNT_09,b.Medicare_Cov_Day_CNT_10,b.Medicare_Cov_Day_CNT_11,b.Medicare_Cov_Day_CNT_12

from sample2010_3 a left join MMLEADS.Mml_mrse2010 b
on a.bene_id=b.bene_id and a.SRVC_1_1=b.SRVC_1 and a.SRVC_2_1=b.SRVC_2;
quit;
proc sql;
create table temp1_4 as
select a.*,
b.Bene_CNT,b.USER1_CNT,b.USER2_CNT,b.SRVC_1,b.SRVC_2,b.Medicare_PMT,b.Medicare_Bene_PMT,
b.Medicare_CLM_CNT_01,b.Medicare_CLM_CNT_02,b.Medicare_CLM_CNT_03,b.Medicare_CLM_CNT_04,b.Medicare_CLM_CNT_05,b.Medicare_CLM_CNT_06,b.Medicare_CLM_CNT_07,b.Medicare_CLM_CNT_08,b.Medicare_CLM_CNT_09,b.Medicare_CLM_CNT_10,b.Medicare_CLM_CNT_11,b.Medicare_CLM_CNT_12,
b.Medicare_Day_CNT_01,b.Medicare_Day_CNT_02,b.Medicare_Day_CNT_03,b.Medicare_Day_CNT_04,b.Medicare_Day_CNT_05,b.Medicare_Day_CNT_06,b.Medicare_Day_CNT_07,b.Medicare_Day_CNT_08,b.Medicare_Day_CNT_09,b.Medicare_Day_CNT_10,b.Medicare_Day_CNT_11,b.Medicare_Day_CNT_12,
b.Medicare_Cov_Day_CNT_01,b.Medicare_Cov_Day_CNT_02,b.Medicare_Cov_Day_CNT_03,b.Medicare_Cov_Day_CNT_04,b.Medicare_Cov_Day_CNT_05,b.Medicare_Cov_Day_CNT_06,b.Medicare_Cov_Day_CNT_07,b.Medicare_Cov_Day_CNT_08,b.Medicare_Cov_Day_CNT_09,b.Medicare_Cov_Day_CNT_10,b.Medicare_Cov_Day_CNT_11,b.Medicare_Cov_Day_CNT_12

from sample2010_4 a left join MMLEADS.Mml_mrse2010 b
on a.bene_id=b.bene_id and a.SRVC_1_1=b.SRVC_1 and a.SRVC_2_1=b.SRVC_2;
quit;
proc sql;
create table temp1_5 as
select a.*,
b.Bene_CNT,b.USER1_CNT,b.USER2_CNT,b.SRVC_1,b.SRVC_2,b.Medicare_PMT,b.Medicare_Bene_PMT,
b.Medicare_CLM_CNT_01,b.Medicare_CLM_CNT_02,b.Medicare_CLM_CNT_03,b.Medicare_CLM_CNT_04,b.Medicare_CLM_CNT_05,b.Medicare_CLM_CNT_06,b.Medicare_CLM_CNT_07,b.Medicare_CLM_CNT_08,b.Medicare_CLM_CNT_09,b.Medicare_CLM_CNT_10,b.Medicare_CLM_CNT_11,b.Medicare_CLM_CNT_12,
b.Medicare_Day_CNT_01,b.Medicare_Day_CNT_02,b.Medicare_Day_CNT_03,b.Medicare_Day_CNT_04,b.Medicare_Day_CNT_05,b.Medicare_Day_CNT_06,b.Medicare_Day_CNT_07,b.Medicare_Day_CNT_08,b.Medicare_Day_CNT_09,b.Medicare_Day_CNT_10,b.Medicare_Day_CNT_11,b.Medicare_Day_CNT_12,
b.Medicare_Cov_Day_CNT_01,b.Medicare_Cov_Day_CNT_02,b.Medicare_Cov_Day_CNT_03,b.Medicare_Cov_Day_CNT_04,b.Medicare_Cov_Day_CNT_05,b.Medicare_Cov_Day_CNT_06,b.Medicare_Cov_Day_CNT_07,b.Medicare_Cov_Day_CNT_08,b.Medicare_Cov_Day_CNT_09,b.Medicare_Cov_Day_CNT_10,b.Medicare_Cov_Day_CNT_11,b.Medicare_Cov_Day_CNT_12

from sample2010_5 a left join MMLEADS.Mml_mrse2010 b
on a.bene_id=b.bene_id and a.SRVC_1_1=b.SRVC_1 and a.SRVC_2_1=b.SRVC_2;
quit;
proc sql;
create table temp1_6 as
select a.*,
b.Bene_CNT,b.USER1_CNT,b.USER2_CNT,b.SRVC_1,b.SRVC_2,b.Medicare_PMT,b.Medicare_Bene_PMT,
b.Medicare_CLM_CNT_01,b.Medicare_CLM_CNT_02,b.Medicare_CLM_CNT_03,b.Medicare_CLM_CNT_04,b.Medicare_CLM_CNT_05,b.Medicare_CLM_CNT_06,b.Medicare_CLM_CNT_07,b.Medicare_CLM_CNT_08,b.Medicare_CLM_CNT_09,b.Medicare_CLM_CNT_10,b.Medicare_CLM_CNT_11,b.Medicare_CLM_CNT_12,
b.Medicare_Day_CNT_01,b.Medicare_Day_CNT_02,b.Medicare_Day_CNT_03,b.Medicare_Day_CNT_04,b.Medicare_Day_CNT_05,b.Medicare_Day_CNT_06,b.Medicare_Day_CNT_07,b.Medicare_Day_CNT_08,b.Medicare_Day_CNT_09,b.Medicare_Day_CNT_10,b.Medicare_Day_CNT_11,b.Medicare_Day_CNT_12,
b.Medicare_Cov_Day_CNT_01,b.Medicare_Cov_Day_CNT_02,b.Medicare_Cov_Day_CNT_03,b.Medicare_Cov_Day_CNT_04,b.Medicare_Cov_Day_CNT_05,b.Medicare_Cov_Day_CNT_06,b.Medicare_Cov_Day_CNT_07,b.Medicare_Cov_Day_CNT_08,b.Medicare_Cov_Day_CNT_09,b.Medicare_Cov_Day_CNT_10,b.Medicare_Cov_Day_CNT_11,b.Medicare_Cov_Day_CNT_12

from sample2010_6 a left join MMLEADS.Mml_mrse2010 b
on a.bene_id=b.bene_id and a.SRVC_1_1=b.SRVC_1 and a.SRVC_2_1=b.SRVC_2;
quit;



data  mmleads.AllDualMR2010;
set temp1_1 temp1_2 temp1_3 temp1_4 temp1_5 temp1_6;
if SRVC_1='' then SRVC_1=SRVC_1_1;
if SRVC_2='' then SRVC_2=SRVC_2_1;

drop SRVC_1_1 SRVC_2_1;

array temp {38}
Medicare_PMT Medicare_Bene_PMT 
Medicare_CLM_CNT_01 Medicare_CLM_CNT_02 Medicare_CLM_CNT_03 Medicare_CLM_CNT_04 Medicare_CLM_CNT_05 Medicare_CLM_CNT_06 Medicare_CLM_CNT_07 Medicare_CLM_CNT_08 Medicare_CLM_CNT_09 Medicare_CLM_CNT_10 Medicare_CLM_CNT_11 Medicare_CLM_CNT_12 
Medicare_Day_CNT_01 Medicare_Day_CNT_02 Medicare_Day_CNT_03 Medicare_Day_CNT_04 Medicare_Day_CNT_05 Medicare_Day_CNT_06 Medicare_Day_CNT_07 Medicare_Day_CNT_08 Medicare_Day_CNT_09 Medicare_Day_CNT_10 Medicare_Day_CNT_11 Medicare_Day_CNT_12 
Medicare_Cov_Day_CNT_01 Medicare_Cov_Day_CNT_02 Medicare_Cov_Day_CNT_03 Medicare_Cov_Day_CNT_04 Medicare_Cov_Day_CNT_05 Medicare_Cov_Day_CNT_06 Medicare_Cov_Day_CNT_07 Medicare_Cov_Day_CNT_08 Medicare_Cov_Day_CNT_09 Medicare_Cov_Day_CNT_10 Medicare_Cov_Day_CNT_11 Medicare_Cov_Day_CNT_12
;
do i=1 to 38;
if temp{i}=. then temp{i}=0;
end;
Medicare_CLM_CNT=Medicare_CLM_CNT_01+ Medicare_CLM_CNT_02+  Medicare_CLM_CNT_03+  Medicare_CLM_CNT_04+  Medicare_CLM_CNT_05+  Medicare_CLM_CNT_06
+ Medicare_CLM_CNT_07+  Medicare_CLM_CNT_08+  Medicare_CLM_CNT_09+  Medicare_CLM_CNT_10+  Medicare_CLM_CNT_11+  Medicare_CLM_CNT_12 ;

Medicare_Day_CNT=Medicare_Day_CNT_01+ Medicare_Day_CNT_02+ Medicare_Day_CNT_03+ Medicare_Day_CNT_04+ Medicare_Day_CNT_05+ Medicare_Day_CNT_06 
+Medicare_Day_CNT_07+ Medicare_Day_CNT_08+ Medicare_Day_CNT_09+ Medicare_Day_CNT_10+ Medicare_Day_CNT_11+ Medicare_Day_CNT_12;
 
Medicare_Cov_Day_CNT=Medicare_Cov_Day_CNT_01+ Medicare_Cov_Day_CNT_02+ Medicare_Cov_Day_CNT_03+ Medicare_Cov_Day_CNT_04+ Medicare_Cov_Day_CNT_05
+ Medicare_Cov_Day_CNT_06+ Medicare_Cov_Day_CNT_07+ Medicare_Cov_Day_CNT_08+ Medicare_Cov_Day_CNT_09+ Medicare_Cov_Day_CNT_10+ Medicare_Cov_Day_CNT_11+ Medicare_Cov_Day_CNT_12;
 
drop i;
run;
 

********************************Medicaid Service-level file;

proc import datafile="C:\data\Projects\Peterson\Program-XZ\Medicaid Service Level" dbms=xlsx out=level replace;getnames=yes;run;
data level;
set level;
level=_n_; 
run;
data temp2010;
set data2010_1;
do i=1 to 74;
 level=i;output;
end;
drop i;
run;
proc sql;
create table sample2010 as
select a.*,b.SRVC_1 as SRVC_1_1,b.SRVC_2 as SRVC_2_1,b.SRVC_3 as SRVC_3_1
from temp2010 a left join level b
on a.level=b.level;
quit;
 

proc sql;
create table temp2 as
select a.*,
b.Bene_CNT,b.USER1_CNT,b.USER2_CNT,b.USER3_CNT,b.SRVC_1,b.SRVC_2,b.SRVC_3,b.Medicaid_PMT,b.Medicaid_coin_PMT,b.Medicaid_DED_PMT,
b.Medicaid_CLM_CNT_01,b.Medicaid_CLM_CNT_02,b.Medicaid_CLM_CNT_03,b.Medicaid_CLM_CNT_04,b.Medicaid_CLM_CNT_05,b.Medicaid_CLM_CNT_06,b.Medicaid_CLM_CNT_07,b.Medicaid_CLM_CNT_08,b.Medicaid_CLM_CNT_09,b.Medicaid_CLM_CNT_10,b.Medicaid_CLM_CNT_11,b.Medicaid_CLM_CNT_12,
b.Medicaid_Day_CNT_01,b.Medicaid_Day_CNT_02,b.Medicaid_Day_CNT_03,b.Medicaid_Day_CNT_04,b.Medicaid_Day_CNT_05,b.Medicaid_Day_CNT_06,b.Medicaid_Day_CNT_07,b.Medicaid_Day_CNT_08,b.Medicaid_Day_CNT_09,b.Medicaid_Day_CNT_10,b.Medicaid_Day_CNT_11,b.Medicaid_Day_CNT_12,
b.Medicaid_Cov_Day_CNT_01,b.Medicaid_Cov_Day_CNT_02,b.Medicaid_Cov_Day_CNT_03,b.Medicaid_Cov_Day_CNT_04,b.Medicaid_Cov_Day_CNT_05,b.Medicaid_Cov_Day_CNT_06,b.Medicaid_Cov_Day_CNT_07,b.Medicaid_Cov_Day_CNT_08,b.Medicaid_Cov_Day_CNT_09,b.Medicaid_Cov_Day_CNT_10,b.Medicaid_Cov_Day_CNT_11,b.Medicaid_Cov_Day_CNT_12

from sample2010 a left join MMLEADS.Mml_mdse2010 b
on a.bene_id=b.bene_id and a.SRVC_1_1=b.SRVC_1 and a.SRVC_2_1=b.SRVC_2 and a.SRVC_3_1=b.SRVC_3 ;
quit;

data  MC2010;
set temp2;
if SRVC_1='' then SRVC_1=SRVC_1_1;
if SRVC_2='' then SRVC_2=SRVC_2_1;
if SRVC_3='' then SRVC_3=SRVC_3_1;
drop SRVC_1_1 SRVC_2_1 SRVC_3_1;

array temp {39}
Medicaid_PMT Medicaid_coin_PMT Medicaid_DED_PMT 
Medicaid_CLM_CNT_01 Medicaid_CLM_CNT_02 Medicaid_CLM_CNT_03 Medicaid_CLM_CNT_04 Medicaid_CLM_CNT_05 Medicaid_CLM_CNT_06 Medicaid_CLM_CNT_07 Medicaid_CLM_CNT_08 Medicaid_CLM_CNT_09 Medicaid_CLM_CNT_10 Medicaid_CLM_CNT_11 Medicaid_CLM_CNT_12 
Medicaid_Day_CNT_01 Medicaid_Day_CNT_02 Medicaid_Day_CNT_03 Medicaid_Day_CNT_04 Medicaid_Day_CNT_05 Medicaid_Day_CNT_06 Medicaid_Day_CNT_07 Medicaid_Day_CNT_08 Medicaid_Day_CNT_09 Medicaid_Day_CNT_10 Medicaid_Day_CNT_11 Medicaid_Day_CNT_12 
Medicaid_Cov_Day_CNT_01 Medicaid_Cov_Day_CNT_02 Medicaid_Cov_Day_CNT_03 Medicaid_Cov_Day_CNT_04 Medicaid_Cov_Day_CNT_05 Medicaid_Cov_Day_CNT_06 Medicaid_Cov_Day_CNT_07 Medicaid_Cov_Day_CNT_08 Medicaid_Cov_Day_CNT_09 Medicaid_Cov_Day_CNT_10 Medicaid_Cov_Day_CNT_11 Medicaid_Cov_Day_CNT_12
;
do i=1 to 39;
if temp{i}=. then temp{i}=0;
end;
Medicaid_CLM_CNT=Medicaid_CLM_CNT_01+ Medicaid_CLM_CNT_02+  Medicaid_CLM_CNT_03+  Medicaid_CLM_CNT_04+  Medicaid_CLM_CNT_05+  Medicaid_CLM_CNT_06
+ Medicaid_CLM_CNT_07+  Medicaid_CLM_CNT_08+  Medicaid_CLM_CNT_09+ Medicaid_CLM_CNT_10+  Medicaid_CLM_CNT_11+  Medicaid_CLM_CNT_12 ;

Medicaid_Day_CNT=Medicaid_Day_CNT_01+ Medicaid_Day_CNT_02+ Medicaid_Day_CNT_03+ Medicaid_Day_CNT_04+ Medicaid_Day_CNT_05+ Medicaid_Day_CNT_06 
+Medicaid_Day_CNT_07+ Medicaid_Day_CNT_08+ Medicaid_Day_CNT_09+ Medicaid_Day_CNT_10+ Medicaid_Day_CNT_11+ Medicaid_Day_CNT_12;
 
Medicaid_Cov_Day_CNT=Medicaid_Cov_Day_CNT_01+ Medicaid_Cov_Day_CNT_02+ Medicaid_Cov_Day_CNT_03+ Medicaid_Cov_Day_CNT_04+ Medicaid_Cov_Day_CNT_05
+ Medicaid_Cov_Day_CNT_06+ Medicaid_Cov_Day_CNT_07+ Medicaid_Cov_Day_CNT_08+ Medicaid_Cov_Day_CNT_09+ Medicaid_Cov_Day_CNT_10+ Medicaid_Cov_Day_CNT_11+ Medicaid_Cov_Day_CNT_12;

Medicaid_Bene_PMT=Medicaid_coin_PMT+Medicaid_DED_PMT ;
 
drop i;
run;
 
