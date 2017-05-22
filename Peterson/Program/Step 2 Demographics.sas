*****************************************
Demographics Tabulation
Xiner Zhou
2/16/2017
*****************************************;
libname MMleads 'D:\Data\MMLEADS\Data';
libname denom 'D:\Data\Medicare\Denominator';
libname data 'D:\Projects\Peterson\Data';
 

**********************************
Plan A
**********************************;
* Bene demog info from data.bene2008 , restrict to data.PlanABene only;
proc sql;
create table temp1 as
select a.*,case when a.bene_id in (select a.bene_id from denom.dnmntr2010 where EFIVEPCT='Y') then 1 else 0 end as pct5, b.*
from data.bene2008 a inner join data.PlanABene b
on a.bene_id=b.bene_id;
quit;

proc sql;
create table temp2 as
select a.*,  b.*
from temp1 a left join data.CC2010 b
on a.bene_id=b.bene_id;
quit;

proc sql;
create table temp3 as
select a.*,  b.*
from temp2 a left join data.Frailty2010 b
on a.bene_id=b.bene_id;
quit;

data PlanA ;
set temp3 ;
N_ICC=amiihd+amputat+arthrit+artopen+bph+cancer+chrkid+chf+cystfib+dementia+diabetes+endo+eyedis+hemadis+hyperlip+hyperten+immunedis+ibd+liver+lung+
neuromusc+osteo+paralyt+psydis+sknulc+spchrtarr+strk+sa+thyroid+vascdis  ;

N_CCW=HYPTHY2008+AMI2008+ALZ2008+ANEMIA2008+ASTHMA2008+AFIB2008+HYPPLA2008+CAT2008+CKD2008+COPD2008+ 
CHF2008+DEPR2008+DIAB2008+GLCM2008+HFRAC2008+HYPLIP2008+HYPTEN2008+IHD2008+OST2008+RAOA2008+
STRK2008+BRC2008+CRC2008+LNGC2008+PRC2008+ ENDC2008+ ACP2008+ ANXI2008+ BIPL2008+DEPSN2008+
PSDS2008+PTRA2008+ SCHI2008+SCHIOT2008+TOBA2008+AUTISM2008+BRAINJ2008+CERPAL2008+CYSFIB2008+ EPILEP2008+
HEARIM2008+INTDIS2008+LEADIS2008+MOBIMP2008+ MULSCL2008+MUSDYS2008+SPIBIF2008+SPIINJ2008+VISUAL2008+ALCO2008+
DRUG2008+FIBRO2008+HEPVIRAL2008+HEPB_ACT2008+HEPB_CHR2008+ HEPC_ACT2008+HEPC_CHR2008+HEPC_UNS2008+HEPD2008+HEPE2008+
HIVAIDS_1YR2008+HIVAIDS2008+HIVARV2008+LEUKLYMPH2008+LIVER2008+ MIGRAINE2008+OBESITY2008+ OTHDEL2008+PVD2008+ULCERS2008;
 
N_Frailty=Frailty1+Frailty2+Frailty3+Frailty4+Frailty5+Frailty6+Frailty7+Frailty8+Frailty9+Frailty10+Frailty11+Frailty12;

array temp{115}
N_ICC 
amiihd amputat arthrit artopen bph cancer chrkid chf cystfib dementia 
diabetes endo eyedis hemadis hyperlip hyperten immunedis ibd liver lung 
neuromusc osteo paralyt psydis sknulc spchrtarr strk sa thyroid vascdis  

N_CCW 
HYPTHY2008 AMI2008 ALZ2008 ANEMIA2008 ASTHMA2008 AFIB2008 HYPPLA2008 CAT2008 CKD2008 COPD2008  
CHF2008 DEPR2008 DIAB2008 GLCM2008 HFRAC2008 HYPLIP2008 HYPTEN2008 IHD2008 OST2008 RAOA2008 
STRK2008 BRC2008 CRC2008 LNGC2008 PRC2008  ENDC2008  ACP2008  ANXI2008  BIPL2008 DEPSN2008 
PSDS2008 PTRA2008  SCHI2008 SCHIOT2008 TOBA2008 AUTISM2008 BRAINJ2008 CERPAL2008 CYSFIB2008  EPILEP2008 
HEARIM2008 INTDIS2008 LEADIS2008 MOBIMP2008  MULSCL2008 MUSDYS2008 SPIBIF2008 SPIINJ2008 VISUAL2008 ALCO2008 
DRUG2008 FIBRO2008 HEPVIRAL2008 HEPB_ACT2008 HEPB_CHR2008  HEPC_ACT2008 HEPC_CHR2008 HEPC_UNS2008 HEPD2008 HEPE2008 
HIVAIDS_1YR2008 HIVAIDS2008 HIVARV2008 LEUKLYMPH2008 LIVER2008  MIGRAINE2008 OBESITY2008  OTHDEL2008 PVD2008 ULCERS2008 
 
N_Frailty 
Frailty1 Frailty2 Frailty3 Frailty4 Frailty5 Frailty6 Frailty7 Frailty8 Frailty9 Frailty10 Frailty11 Frailty12;
do i=1 to 115;
if temp{i}=. then temp{i}=0;
end;
drop i;
run;


proc tabulate data=PlanA noseps  missing;
class D_sex RaceGroup AgeGroup group region   N_CCW E_MME_Type E_MS_CD E_BOE MHI2008 Edu2008  N_CCW D_STATE_CD ; 
var 
HYPTHY2008 AMI2008 ALZ2008 ANEMIA2008 ASTHMA2008 AFIB2008 HYPPLA2008 CAT2008 CKD2008 COPD2008  
CHF2008 DEPR2008 DIAB2008 GLCM2008 HFRAC2008 HYPLIP2008 HYPTEN2008 IHD2008 OST2008 RAOA2008 
STRK2008 BRC2008 CRC2008 LNGC2008 PRC2008  ENDC2008  ACP2008  ANXI2008  BIPL2008 DEPSN2008 
PSDS2008 PTRA2008  SCHI2008 SCHIOT2008 TOBA2008 AUTISM2008 BRAINJ2008 CERPAL2008 CYSFIB2008  EPILEP2008 
HEARIM2008 INTDIS2008 LEADIS2008 MOBIMP2008  MULSCL2008 MUSDYS2008 SPIBIF2008 SPIINJ2008 VISUAL2008 ALCO2008 
DRUG2008 FIBRO2008 HEPVIRAL2008 HEPB_ACT2008 HEPB_CHR2008  HEPC_ACT2008 HEPC_CHR2008 HEPC_UNS2008 HEPD2008 HEPE2008 
HIVAIDS_1YR2008 HIVAIDS2008 HIVARV2008 LEUKLYMPH2008 LIVER2008  MIGRAINE2008 OBESITY2008  OTHDEL2008 PVD2008 ULCERS2008 
 ;
table (	D_sex="Gender" 
		RaceGroup="Race" 
		AgeGroup="Age" 
		region="HRSA regions" 
		D_STATE_CD="State"
		E_MME_Type="Dual Status" 
		E_MS_CD="Medicare status code" 
		E_BOE="Medicaid Basis of Eligibility"
		MHI2008="Stratify by Zip Code Median Income in Quartiles"
		Edu2008="Stratify by Zip Code Proportion of College Education Degree in Quartiles"
		
        N_CCW='N. of CMS CCW' 
		
),(group="10% High Cost Patients"*(n colpctn)   all*(n colpctn))/RTS=25;

table (
HYPTHY2008 AMI2008 ALZ2008 ANEMIA2008 ASTHMA2008 AFIB2008 HYPPLA2008 CAT2008 CKD2008 COPD2008  
CHF2008 DEPR2008 DIAB2008 GLCM2008 HFRAC2008 HYPLIP2008 HYPTEN2008 IHD2008 OST2008 RAOA2008 
STRK2008 BRC2008 CRC2008 LNGC2008 PRC2008  ENDC2008  ACP2008  ANXI2008  BIPL2008 DEPSN2008 
PSDS2008 PTRA2008  SCHI2008 SCHIOT2008 TOBA2008 AUTISM2008 BRAINJ2008 CERPAL2008 CYSFIB2008  EPILEP2008 
HEARIM2008 INTDIS2008 LEADIS2008 MOBIMP2008  MULSCL2008 MUSDYS2008 SPIBIF2008 SPIINJ2008 VISUAL2008 ALCO2008 
DRUG2008 FIBRO2008 HEPVIRAL2008 HEPB_ACT2008 HEPB_CHR2008  HEPC_ACT2008 HEPC_CHR2008 HEPC_UNS2008 HEPD2008 HEPE2008 
HIVAIDS_1YR2008 HIVAIDS2008 HIVARV2008 LEUKLYMPH2008 LIVER2008  MIGRAINE2008 OBESITY2008  OTHDEL2008 PVD2008 ULCERS2008 
),(group="10% High Cost Patients"*(mean*f=15.5)   all*(mean*f=15.5))/RTS=25;
Keylabel all="All Dual Eligible"
         N="Number of Beneficiary"
		 colpctn="Column Percent";

format   E_MS_CD $E_MS_CD_. E_BOE $E_BOE_.; 
run;

* 5% sample 2010 frailty and Icc;

proc tabulate data=PlanA noseps  missing;
where pct5=1;
class group N_Frailty N_ICC;
var 
amiihd amputat arthrit artopen bph cancer chrkid chf cystfib dementia 
diabetes endo eyedis hemadis hyperlip hyperten immunedis ibd liver lung 
neuromusc osteo paralyt psydis sknulc spchrtarr strk sa thyroid vascdis  
Frailty1 Frailty2 Frailty3 Frailty4 Frailty5 Frailty6 Frailty7 Frailty8 Frailty9 Frailty10 Frailty11 Frailty12
;  

table ( N_ICC='N. of ICC'
		N_Frailty='N.of Frailty Indicators' 
		),(group="10% High Cost Patients"*(n colpctn)   all*(n colpctn))/RTS=25;

table (
amiihd amputat arthrit artopen bph cancer chrkid chf cystfib dementia 
diabetes endo eyedis hemadis hyperlip hyperten immunedis ibd liver lung 
neuromusc osteo paralyt psydis sknulc spchrtarr strk sa thyroid vascdis  
 
),(group="10% High Cost Patients"*(mean*f=15.5)   all*(mean*f=15.5))/RTS=25;

table (
Frailty1 Frailty2 Frailty3 Frailty4 Frailty5 Frailty6 Frailty7 Frailty8 Frailty9 Frailty10 Frailty11 Frailty12
),(group="10% High Cost Patients"*(mean*f=15.5)   all*(mean*f=15.5))/RTS=25;
run;
 
 





**********************************
Plan B
**********************************;
 proc sql;
create table temp1 as
select a.*,case when a.bene_id in (select a.bene_id from denom.dnmntr2010 where EFIVEPCT='Y') then 1 else 0 end as pct5, b.*
from data.bene2008 a inner join data.PlanBBene b
on a.bene_id=b.bene_id;
quit;

proc sql;
create table temp2 as
select a.*,  b.*
from temp1 a left join data.CC2010 b
on a.bene_id=b.bene_id;
quit;

proc sql;
create table temp3 as
select a.*,  b.*
from temp2 a left join data.Frailty2010 b
on a.bene_id=b.bene_id;
quit;

data PlanB ;
set temp3 ;
N_ICC=amiihd+amputat+arthrit+artopen+bph+cancer+chrkid+chf+cystfib+dementia+diabetes+endo+eyedis+hemadis+hyperlip+hyperten+immunedis+ibd+liver+lung+
neuromusc+osteo+paralyt+psydis+sknulc+spchrtarr+strk+sa+thyroid+vascdis  ;

N_CCW=HYPTHY2008+AMI2008+ALZ2008+ANEMIA2008+ASTHMA2008+AFIB2008+HYPPLA2008+CAT2008+CKD2008+COPD2008+ 
CHF2008+DEPR2008+DIAB2008+GLCM2008+HFRAC2008+HYPLIP2008+HYPTEN2008+IHD2008+OST2008+RAOA2008+
STRK2008+BRC2008+CRC2008+LNGC2008+PRC2008+ ENDC2008+ ACP2008+ ANXI2008+ BIPL2008+DEPSN2008+
PSDS2008+PTRA2008+ SCHI2008+SCHIOT2008+TOBA2008+AUTISM2008+BRAINJ2008+CERPAL2008+CYSFIB2008+ EPILEP2008+
HEARIM2008+INTDIS2008+LEADIS2008+MOBIMP2008+ MULSCL2008+MUSDYS2008+SPIBIF2008+SPIINJ2008+VISUAL2008+ALCO2008+
DRUG2008+FIBRO2008+HEPVIRAL2008+HEPB_ACT2008+HEPB_CHR2008+ HEPC_ACT2008+HEPC_CHR2008+HEPC_UNS2008+HEPD2008+HEPE2008+
HIVAIDS_1YR2008+HIVAIDS2008+HIVARV2008+LEUKLYMPH2008+LIVER2008+ MIGRAINE2008+OBESITY2008+ OTHDEL2008+PVD2008+ULCERS2008;
 
N_Frailty=Frailty1+Frailty2+Frailty3+Frailty4+Frailty5+Frailty6+Frailty7+Frailty8+Frailty9+Frailty10+Frailty11+Frailty12;

array temp{115}
N_ICC 
amiihd amputat arthrit artopen bph cancer chrkid chf cystfib dementia 
diabetes endo eyedis hemadis hyperlip hyperten immunedis ibd liver lung 
neuromusc osteo paralyt psydis sknulc spchrtarr strk sa thyroid vascdis  

N_CCW 
HYPTHY2008 AMI2008 ALZ2008 ANEMIA2008 ASTHMA2008 AFIB2008 HYPPLA2008 CAT2008 CKD2008 COPD2008  
CHF2008 DEPR2008 DIAB2008 GLCM2008 HFRAC2008 HYPLIP2008 HYPTEN2008 IHD2008 OST2008 RAOA2008 
STRK2008 BRC2008 CRC2008 LNGC2008 PRC2008  ENDC2008  ACP2008  ANXI2008  BIPL2008 DEPSN2008 
PSDS2008 PTRA2008  SCHI2008 SCHIOT2008 TOBA2008 AUTISM2008 BRAINJ2008 CERPAL2008 CYSFIB2008  EPILEP2008 
HEARIM2008 INTDIS2008 LEADIS2008 MOBIMP2008  MULSCL2008 MUSDYS2008 SPIBIF2008 SPIINJ2008 VISUAL2008 ALCO2008 
DRUG2008 FIBRO2008 HEPVIRAL2008 HEPB_ACT2008 HEPB_CHR2008  HEPC_ACT2008 HEPC_CHR2008 HEPC_UNS2008 HEPD2008 HEPE2008 
HIVAIDS_1YR2008 HIVAIDS2008 HIVARV2008 LEUKLYMPH2008 LIVER2008  MIGRAINE2008 OBESITY2008  OTHDEL2008 PVD2008 ULCERS2008 
 
N_Frailty 
Frailty1 Frailty2 Frailty3 Frailty4 Frailty5 Frailty6 Frailty7 Frailty8 Frailty9 Frailty10 Frailty11 Frailty12;
do i=1 to 115;
if temp{i}=. then temp{i}=0;
end;
drop i;
run;


proc tabulate data=PlanB noseps  missing;
class D_sex RaceGroup AgeGroup group region N_Frailty N_ICC N_CCW E_MME_Type E_MS_CD E_BOE MHI2008 Edu2008  N_CCW  ; 
var 
HYPTHY2008 AMI2008 ALZ2008 ANEMIA2008 ASTHMA2008 AFIB2008 HYPPLA2008 CAT2008 CKD2008 COPD2008  
CHF2008 DEPR2008 DIAB2008 GLCM2008 HFRAC2008 HYPLIP2008 HYPTEN2008 IHD2008 OST2008 RAOA2008 
STRK2008 BRC2008 CRC2008 LNGC2008 PRC2008  ENDC2008  ACP2008  ANXI2008  BIPL2008 DEPSN2008 
PSDS2008 PTRA2008  SCHI2008 SCHIOT2008 TOBA2008 AUTISM2008 BRAINJ2008 CERPAL2008 CYSFIB2008  EPILEP2008 
HEARIM2008 INTDIS2008 LEADIS2008 MOBIMP2008  MULSCL2008 MUSDYS2008 SPIBIF2008 SPIINJ2008 VISUAL2008 ALCO2008 
DRUG2008 FIBRO2008 HEPVIRAL2008 HEPB_ACT2008 HEPB_CHR2008  HEPC_ACT2008 HEPC_CHR2008 HEPC_UNS2008 HEPD2008 HEPE2008 
HIVAIDS_1YR2008 HIVAIDS2008 HIVARV2008 LEUKLYMPH2008 LIVER2008  MIGRAINE2008 OBESITY2008  OTHDEL2008 PVD2008 ULCERS2008 
 ;
table (	D_sex="Gender" 
		RaceGroup="Race" 
		AgeGroup="Age" 
		region="HRSA regions" 
		E_MME_Type="Dual Status" 
		E_MS_CD="Medicare status code" 
		E_BOE="Medicaid Basis of Eligibility"
		MHI2008="Stratify by Zip Code Median Income in Quartiles"
		Edu2008="Stratify by Zip Code Proportion of College Education Degree in Quartiles"
		N_ICC='N. of ICC'
        N_CCW='N. of CMS CCW' 
		N_Frailty='N.of Frailty Indicators' 
),(group="10% High Cost Patients"*(n colpctn)   all*(n colpctn))/RTS=25;

table (
HYPTHY2008 AMI2008 ALZ2008 ANEMIA2008 ASTHMA2008 AFIB2008 HYPPLA2008 CAT2008 CKD2008 COPD2008  
CHF2008 DEPR2008 DIAB2008 GLCM2008 HFRAC2008 HYPLIP2008 HYPTEN2008 IHD2008 OST2008 RAOA2008 
STRK2008 BRC2008 CRC2008 LNGC2008 PRC2008  ENDC2008  ACP2008  ANXI2008  BIPL2008 DEPSN2008 
PSDS2008 PTRA2008  SCHI2008 SCHIOT2008 TOBA2008 AUTISM2008 BRAINJ2008 CERPAL2008 CYSFIB2008  EPILEP2008 
HEARIM2008 INTDIS2008 LEADIS2008 MOBIMP2008  MULSCL2008 MUSDYS2008 SPIBIF2008 SPIINJ2008 VISUAL2008 ALCO2008 
DRUG2008 FIBRO2008 HEPVIRAL2008 HEPB_ACT2008 HEPB_CHR2008  HEPC_ACT2008 HEPC_CHR2008 HEPC_UNS2008 HEPD2008 HEPE2008 
HIVAIDS_1YR2008 HIVAIDS2008 HIVARV2008 LEUKLYMPH2008 LIVER2008  MIGRAINE2008 OBESITY2008  OTHDEL2008 PVD2008 ULCERS2008 
),(group="10% High Cost Patients"*(mean*f=15.5)   all*(mean*f=15.5))/RTS=25;
Keylabel all="All Dual Eligible"
         N="Number of Beneficiary"
		 colpctn="Column Percent";

format   E_MS_CD $E_MS_CD_. E_BOE $E_BOE_.; 
run;

* 5% sample 2010 frailty and Icc;

proc tabulate data=PlanB noseps  missing;
where pct5=1;
class group;
var 
amiihd amputat arthrit artopen bph cancer chrkid chf cystfib dementia 
diabetes endo eyedis hemadis hyperlip hyperten immunedis ibd liver lung 
neuromusc osteo paralyt psydis sknulc spchrtarr strk sa thyroid vascdis  
 
;  
table (
amiihd amputat arthrit artopen bph cancer chrkid chf cystfib dementia 
diabetes endo eyedis hemadis hyperlip hyperten immunedis ibd liver lung 
neuromusc osteo paralyt psydis sknulc spchrtarr strk sa thyroid vascdis  
 
),(group="10% High Cost Patients"*(mean*f=15.5)   all*(mean*f=15.5))/RTS=25;
run;
 

proc tabulate data=PlanB noseps  missing;
where pct5=1;
class group;
var 
 
Frailty1 Frailty2 Frailty3 Frailty4 Frailty5 Frailty6 Frailty7 Frailty8 Frailty9 Frailty10 Frailty11 Frailty12
;  
table (
Frailty1 Frailty2 Frailty3 Frailty4 Frailty5 Frailty6 Frailty7 Frailty8 Frailty9 Frailty10 Frailty11 Frailty12
),(group="10% High Cost Patients"*(mean*f=15.5)   all*(mean*f=15.5))/RTS=25;
run;
 
