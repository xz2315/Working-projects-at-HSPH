/***************************************************************************************************
Macro Name: peds_chronic_sas

Function: 
This program will be used to create pediatric chronic condition indicators based on the article: 

XXX

Author: Matt Hall

Date: 2014-11-18

Call statement:

%peds_chronic_sas(dt_in,dt_out,id,dx,n_dxs);


Parameter definitions:

	dt_in  SAS input data set containing ids and all ICD-9-CM codes
	dt_out_lib SAS output library
	dt_out SAS output data set containing the id and new created 
	id can either be a unique encounter id or a patient id (e.g. MRN) if assessing chronic conditions across encounters   
	dx prefix for ICD-9-CM diagnosis codes  
	n_dxs number of ICD-9-CM diagnosis code (assume diagnosis variables as dx1 - dxn)

For example, if you use KID2012, just call:

%INCLUDE "D:\path\peds_chronic_sas.sas";
%peds_chronic_sas(dt_in=hcup.kid_2012_core, dt_out_lib=hcup, dt_out=kid_2012_core_results, id=RECNUM, dx=dx, n_dxs=25)
***************************************************************************************************/

/*Path were reference table is stored locally - USER MUST CHANGE*/
%LET pth=D:\Projects\APCD Kids\Document from Marit\AHRQ CCI Pediatric;
libname data 'D:\Projects\APCD Kids\Data';


/*Import Reference Table*/
PROC IMPORT FILE="&pth.\BerryHall_AHRQ_CCICCS_PedsAdaptation.csv" DBMS=csv OUT=ccs_cci REPLACE;
RUN;

%MACRO peds_chronic_sas(dt_in,dt_out_lib,dt_out,id,dx,n_dxs);
	DATA dxs;
   		ARRAY dxc(&n_dxs.) $ &dx.1 - &dx.&n_dxs.;
		SET &dt_in.(KEEP=&id. &dx.1-&dx.&n_dxs.);
		DO I = 1 TO &n_dxs.;
			IF dxc(I)~='' THEN DO;
				dx=dxc(I);
				OUTPUT;
			END;
		END;
		KEEP &id. I dx;
	RUN;
	PROC SORT DATA=dxs;
		BY dx;
	RUN;
	PROC SORT DATA=ccs_cci;
		BY dx;
	RUN;
	DATA dxs;
		MERGE dxs(IN=var1) ccs_cci;
		BY dx;
		IF var1=1;
	RUN;
	/****************************************************************************************************/
	/************************************Final Processing************************************************/
	/****************************************************************************************************/
	PROC SQL;
		CREATE TABLE &dt_out_lib..&dt_out. AS
		SELECT DISTINCT &id.
		FROM dxs
		ORDER BY &id.;
	QUIT;

	DATA chronic_dxs;
		SET dxs(WHERE=(CATEGORY_DESCRIPTION2='1'));
	RUN;
	/*Chronic Organ System Flags*/
	PROC SQL;
		CREATE TABLE chronic_organs AS
		SELECT DISTINCT &id., organ_system2, 1 AS flag
		FROM chronic_dxs
		ORDER BY &id.;
	QUIT;
	PROC TRANSPOSE DATA=chronic_organs OUT=t_chronic_organs PREFIX=chronic_organ_sys_;
		VAR flag;
		BY &id.;
		ID organ_system2;
	RUN;
	DATA &dt_out_lib..&dt_out.;
		MERGE &dt_out_lib..&dt_out. t_chronic_organs;
		BY &id.;
		DROP _NAME_ _LABEL_;
	RUN;
	DATA &dt_out_lib..&dt_out.;
		ARRAY x(*) &id. chronic_organ_sys_1-chronic_organ_sys_26;
		SET &dt_out_lib..&dt_out.;
		DO I = 1 TO DIM(x);
			IF x(I)=. THEN x(I)=0;
		END;
		chronic_organ_sys_count=SUM(OF chronic_organ_sys_1-chronic_organ_sys_26);
		DROP I;
	RUN;
		/*Label Organ Systems*/
	PROC IMPORT FILE="&pth.\BerryHall_AHRQ_CCICCS_organSYSrevision.csv" DBMS=csv OUT=organ_labels REPLACE;
		GUESSINGROWS=10000;
	RUN;
	FILENAME gencode TEMP; 
	DATA _NULL_;
		SET organ_labels END=eof;
		FILE gencode;
		IF _N_=1 THEN DO;
			PUT "PROC DATASETS LIB=&dt_out_lib. NOLIST;" /
			" MODIFY &dt_out.;";
		END;
		IF INDEXC(label,"'")=0 THEN PUT " LABEL " variable " = '" label "';";
			ELSE IF INDEXC(label,'"')=0 THEN PUT " LABEL " variable ' = "' label '";';
		IF eof THEN PUT "QUIT;";
	run;
	%INCLUDE gencode;
	FILENAME gencode CLEAR;

	/*Lowest Level of CCS*/
	PROC SQL;
		CREATE TABLE chronic_ccs AS
		SELECT DISTINCT &id., lowest_ccs2, 1 AS flag
		FROM chronic_dxs
		ORDER BY &id.;
	QUIT;
	PROC TRANSPOSE DATA=chronic_ccs OUT=t_chronic_ccs PREFIX=chronic_ccs_;
		VAR flag;
		BY &id.;
		ID lowest_ccs2;
	RUN;
	DATA &dt_out_lib..&dt_out.;
		MERGE &dt_out_lib..&dt_out. t_chronic_ccs;
		BY &id.;
		DROP _NAME_ _LABEL_;
	RUN;
	DATA &dt_out_lib..&dt_out.;
		SET &dt_out_lib..&dt_out.;
		ARRAY x(*) _NUMERIC_;
		DO I = 1 TO DIM(x);
			IF x(I)=. THEN x(I)=0;
		END;
		DROP I;
	RUN;
		/*Label CCS*/
	DATA ccs_dx_labels;
		SET ccs_cci(KEEP=lowest_ccs2 MULTI_LEVEL_CCS_DIAGNOSIS_LABEL2);
	RUN;
	DATA ccs_labels;
		FORMAT variable $99.;
		SET Ccs_dx_labels;
		variable=COMPRESS("chronic_ccs_"||TRANWRD(lowest_ccs2,".","_"));
		RENAME MULTI_LEVEL_CCS_DIAGNOSIS_LABEL2=label;
	RUN;
	FILENAME gencode TEMP; 
	DATA _NULL_;
		SET ccs_labels END=eof;
		FILE gencode;
		IF _N_=1 THEN DO;
			PUT "PROC DATASETS LIB=&dt_out_lib. NOLIST;" /
			" MODIFY &dt_out.;";
		END;
		IF INDEXC(label,"'")=0 THEN PUT " LABEL " variable " = '" label "';";
			ELSE IF INDEXC(label,'"')=0 THEN PUT " LABEL " variable ' = "' label '";';
		IF eof THEN PUT "QUIT;";
	run;
	%INCLUDE gencode;
	FILENAME gencode CLEAR;
		/*Lowest Level of CCS Text*/
	PROC SQL;
		CREATE TABLE chronic_ccs_text AS
		SELECT DISTINCT &id., MULTI_LEVEL_CCS_DIAGNOSIS_LABEL2
		FROM chronic_dxs
		ORDER BY &id., MULTI_LEVEL_CCS_DIAGNOSIS_LABEL2;
	QUIT;
	PROC TRANSPOSE DATA=chronic_ccs_text OUT=t_chronic_ccs_text;
		VAR MULTI_LEVEL_CCS_DIAGNOSIS_LABEL2;
		BY &id.;
	RUN;
	DATA t_chronic_ccs_text;
		SET t_chronic_ccs_text;
		DROP _NAME_ _LABEL_;
	RUN;
	PROC SQL;
		CREATE TABLE n_records AS
		SELECT &id., COUNT(&id.) AS n
		FROM chronic_ccs_text
		GROUP BY &id.;
	QUIT;
	PROC SQL NOPRINT;
		SELECT MAX(n)
		INTO :nvar
		FROM n_records;
	QUIT;
	DATA t_chronic_ccs_text;
		LENGTH ccs_text $999.;
		SET t_chronic_ccs_text;
		ccs_text=CATX(" || ", OF COL1-COL%CMPRES(&nvar.));
		KEEP &id. ccs_text;
	RUN;
	DATA &dt_out_lib..&dt_out.;
		MERGE &dt_out_lib..&dt_out. t_chronic_ccs_text;
		BY &id.;
	RUN;
%MEND;



%peds_chronic_sas(dt_in=data.Kidclm2012,dt_out_lib=data ,dt_out=CCI,id=MemberLinkEID,dx=dx,n_dxs=13);
