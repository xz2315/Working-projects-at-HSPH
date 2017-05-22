******************************
Create CMS CCW
Xiner Zhou
https://www.ccwdata.org/web/guest/condition-categories
*****************************;

libname ip 'D:\Data\Medicare\Inpatient';
libname op 'D:\Data\Medicare\Outpatient';
libname hha 'D:\Data\Medicare\HHA';
libname snf 'D:\Data\Medicare\SNF';
libname hospice 'D:\Data\Medicare\Hospice';
libname carrier 'D:\Data\Medicare\Carrier';
libname dme 'D:\Data\Medicare\DME';
libname data 'D:\Projects\High Cost Segmentation Phase II\Data';
%let yr=2012;
%let yr=2013;
%let yr=2014;

proc contents data=ip.Inptclms&yr. order=varnum;run;
proc contents data=op.Otptclms&yr. order=varnum;run;
proc contents data=carrier.Bcarclms&yr. order=varnum;run;
proc contents data=hha.Hhaclms&yr. order=varnum;run;
proc contents data=snf.Snfclms&yr. order=varnum;run;
proc contents data=hospice.Hspcclms&yr. order=varnum;run;
proc contents data=DME.Dmeclms&yr. order=varnum;run;

data temp1&yr.;
set ip.Inptclms&yr.(keep=bene_id ICD_DGNS_CD1-ICD_DGNS_CD25 PRNCPAL_DGNS_CD)
    op.Otptclms&yr.(keep=bene_id ICD_DGNS_CD1-ICD_DGNS_CD25 PRNCPAL_DGNS_CD)
    carrier.Bcarclms&yr.(keep=bene_id ICD_DGNS_CD1-ICD_DGNS_CD12 PRNCPAL_DGNS_CD)
    hha.Hhaclms&yr.(keep=bene_id ICD_DGNS_CD1-ICD_DGNS_CD25 PRNCPAL_DGNS_CD)
    snf.Snfclms&yr.(keep=bene_id ICD_DGNS_CD1-ICD_DGNS_CD25 PRNCPAL_DGNS_CD)
    hospice.Hspcclms&yr.(keep=bene_id ICD_DGNS_CD1-ICD_DGNS_CD25 PRNCPAL_DGNS_CD)
    DME.Dmeclms&yr.(keep=bene_id ICD_DGNS_CD1-ICD_DGNS_CD12 PRNCPAL_DGNS_CD);
    
	array dx{26} $ ICD_DGNS_CD1-ICD_DGNS_CD25 PRNCPAL_DGNS_CD;

	ADHD=0;
    Anxiety=0;
	Autism=0;
	Bipolar=0;
	Cerebral=0;
	Depression=0;
    Fibromyalgia=0;
    Intellectual=0;
    Personality=0;
    PTSD=0;
    Schizophrenia=0;
	OtherPsychotic=0;
  
	do i=1 to 26;
		if dx{i} in ('31200', '31201', '31202', '31203', '31210', '31211', '31212', '31213', '31220', '31221', '31222', 
                     '31223', '31230', '31231', '31232', '31233', '31234', '31235', '31239', '3124', '31281', '31282', 
                     '31289', '3129', '31400', '31401', '3141', '3142', '3148', '3149') 
        then ADHD=1; label ADHD="ADHD, Conduct Disorders, and Hyperkinetic Syndrome";
		
		if dx{i} in ('29384', '30000', '30001', '30002', '30009', '30010', '30020', '30021', '30022', '30023', 
                     '30029', '3003', '3005', '30089', '3009', '3080', '3081', '3082', '3083', '3084', '3089', 
                     '30981', '3130', '3131', '31321', '31322', '3133', '31382', '31383')
		then Anxiety=1;label Anxiety="Anxiety Disorders";

		if dx{i} in ('2990', '29900', '29901', '2991', '29911', '2998', '29980', '29981', '2999', '29990', '29991')
		then Autism=1;label Autism="Autism Spectrum Disorders";
        
		if dx{i} in ('29600', '29601', '29602', '29603', '29604', '29605', '29606', '29610', '29611', '29612', '29613', '29614', 
                     '29615', '29616', '29640', '29641', '29642', '29643', '29644', '29645', '29646', '29650', '29651', '29652', 
                     '29653', '29654', '29655', '29656', '29660', '29661', '29662', '29663', '29664', '29665', '29666', '2967', 
                     '29680', '29681', '29682', '29689', '29690', '29699')
		then Bipolar=1;label Bipolar="Bipolar Disorder";
        
		if dx{i} in ('33371', '343', '3430', '3431', '3432', '3433', '3434', '3438', '3439')
		then Cerebral=1;label Cerebral="Cerebral Palsy";

		if dx{i} in ('29620', '29621', '29622',
					'29623', '29624', '29625',
					'29626', '29630', '29631',
					'29632', '29633', '29634',
					'29635', '29636', '29650',
					'29651', '29652', '29653',
					'29654', '29655', '29656',
					'29660', '29661', '29662',
					'29663', '29664', '29665',
					'29666', '29689', '2980',
					'3004', '3091', '311')
		then Depression=1;label Depression="Depression";


        if dx{i} in ('3382','33821', '33822', '33823', '33829', '3383', '3384', '7807', '78071', '7291', '7292')
		then Fibromyalgia=1;label Fibromyalgia="Fibromyalgia, Chronic Pain and Fatigue";
        

		if dx{i} in ('317', '318', '3180', '3181', '3182', '319', '758', '7580', '7581', '7582', '7583', '75831', 
                     '75832', '75833', '75839', '7585', '7597', '75981', '75983', '75989', '76071')
		then Intellectual=1;label Intellectual="Intellectual Disabilities and Related Conditions";

        if dx{i} in ('3010', '30110', '30111', '30112', '30113', '30120', '30121', '30122', '3013', '3014', 
                '30150', '30151', '30159', '3016', '3017', '30181', '30182', '30183', '30184', '30189', '3019')
				then Personality=1;label Personality="Personality Disorders";

        if dx{i} in ('30981') then PTSD=1;label PTSD="Post-Traumatic Stress Disorder (PTSD)";

		if dx{i} in ('29500', '29501', '29502', '29503', '29504', '29505', '29510', '29511', '29512', 
                     '29513', '29514', '29515', '29520', '29521', '29522', '29523', '29524', '29525', 
                     '29530', '29531', '29532', '29533', '29534', '29535', '29540', '29541', '29542', 
                     '29543', '29544', '29545', '29550', '29551', '29552', '29553', '29554', '29555', 
                    '29560', '29561', '29562', '29563', '29564', '29565', '29570', '29571', '29572', 
                    '29573', '29574', '29575', '29580', '29581', '29582', '29583', '29584', '29585', 
                    '29590', '29591', '29592', '29593', '29594', '29595')
		then Schizophrenia=1;label Schizophrenia="Schizophrenia";

		if dx{i} in ('29381', '29382', '29500','29501', '29502', '29503', '29504', '29505', '29510', '29511', 
		'29512', '29513', '29514', '29515', '29520', '29521', '29522', '29523', '29524', '29525', '29530', '29531', '29532', 
		'29533', '29534', '29535', '29540', '29541', '29542', '29543', '29544', '29545', '29550', '29551', '29552', '29553', 
		'29554', '29555', '29560', '29561', '29562', '29563', '29564', '29565', '29570', '29571', '29572', '29573', '29574',
		'29575', '29580', '29581', '29582', '29583', '29584', '29585', '29590', '29591', '29592', '29593', '29594', '29595',
		'2970', '2971', '2972', '2973', '2978', '2979', '2980', '2981', '2982', '2983', '2984', '2988', '2989')
		then OtherPsychotic=1;label OtherPsychotic="Schizophrenia and Other Psychotic Disorders";

	end;
run;
 

proc sort data=temp1&yr.;by bene_id;run;

	
proc sql;
create table temp2&yr. as
select bene_id, sum(ADHD) as ADHD_1, sum(Anxiety) as Anxiety_1, sum(Autism) as Autism_1, sum(Bipolar) as Bipolar_1,
       sum(Cerebral) as  Cerebral_1, sum(Depression) as  Depression_1,sum(Fibromyalgia) as  Fibromyalgia_1,sum(Intellectual) as  Intellectual_1,
	   sum(Personality) as  Personality_1,sum(PTSD) as  PTSD_1,sum(Schizophrenia) as  Schizophrenia_1,sum(OtherPsychotic) as  OtherPsychotic_1 
from temp1&yr.
group by bene_id;
quit;

proc sort data=temp2&yr.  nodupkey;by bene_id;run;

data data.CCW&yr.;
set temp2&yr.;
    ADHD&yr.=0;label ADHD="ADHD, Conduct Disorders, and Hyperkinetic Syndrome";
    Anxiety&yr.=0;label Anxiety="Anxiety Disorders";
	Autism&yr.=0;label Autism="Autism Spectrum Disorders";
	Bipolar&yr.=0;label Bipolar="Bipolar Disorder";
	Cerebral&yr.=0;label Cerebral="Cerebral Palsy";
	Depression&yr.=0;label Depression="Depression";
    Fibromyalgia&yr.=0;label Fibromyalgia="Fibromyalgia, Chronic Pain and Fatigue";
    Intellectual&yr.=0;label Intellectual="Intellectual Disabilities and Related Conditions";
    Personality&yr.=0;label Personality="Personality Disorders";
    PTSD&yr.=0;label PTSD="Post-Traumatic Stress Disorder (PTSD)";
    Schizophrenia&yr.=0;label Schizophrenia="Schizophrenia";
	OtherPsychotic&yr.=0;label OtherPsychotic="Schizophrenia and Other Psychotic Disorders";

	if ADHD_1>0 then ADHD&yr.=1;
    if Anxiety_1>0 then Anxiety&yr.=1;
	if Autism_1>0 then Autism&yr.=1;
	if Bipolar_1>0 then Bipolar&yr.=1;
	if Cerebral_1>0 then Cerebral&yr.=1;
	if Depression_1>0 then Depression&yr.=1;
	if Fibromyalgia_1>0 then Fibromyalgia&yr.=1;
	if Intellectual_1>0 then Intellectual&yr.=1;
	if Personality_1>0 then Personality&yr.=1;
	if PTSD_1>0 then PTSD&yr.=1;
	if Schizophrenia_1>0 then Schizophrenia&yr.=1;
	if OtherPsychotic_1>0 then OtherPsychotic&yr.=1;

keep bene_id  
	ADHD&yr. 
    Anxiety&yr. 
	Autism&yr. 
	Bipolar&yr. 
	Cerebral&yr. 
	Depression&yr. 
    Fibromyalgia&yr. 
    Intellectual&yr. 
    Personality&yr. 
    PTSD&yr. 
    Schizophrenia&yr. 
	OtherPsychotic&yr. ;

	proc means;
	var 
		ADHD&yr. 
    Anxiety&yr. 
	Autism&yr. 
	Bipolar&yr. 
	Cerebral&yr. 
	Depression&yr. 
    Fibromyalgia&yr. 
    Intellectual&yr. 
    Personality&yr. 
    PTSD&yr. 
    Schizophrenia&yr. 
	OtherPsychotic&yr. ;
run;
 
