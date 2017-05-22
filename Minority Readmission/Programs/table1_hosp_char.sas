******************************************************************************
Filename:		table1_hosp_char.sas
Data used:      AHA2010, RUCA_2006, hospvolume 2010 and readmrate02to10hccfixed
Purpose:        Create table 1
Date:           08/27/2013
******************************************************************************;
%put Run on %sysfunc (date(), worddatx15. ) at  %sysfunc (time(), time9. ) ;

TITLE2 "Filename:	C:\data\Projects\Specialty_Hospitals\Programs\table1_hospchar.sas";
TITLE3 "Project:	Specialty Hospital (Physiican owned Hospital";
TITLE4 "Purpose:	Calculating Market share for physician owned hospital";

options nocenter ls=132 ps=1000 pageno=1;

LIBNAME ruca   	"C:\data\Data\RUCA";
LIBNAME vol		"C:\data\Data\Hospital\Volume";
LIBNAME aha		"C:\data\Data\Hospital\AHA";
LIBNAME readm	"C:\data\Data\Hospital\Readmission\data";
LIBNAME pen		"C:\data\Projects\Jha_Requests\Data";
data penalty;
	set pen.Readm_penalty_2years (rename=(CMS_Certification_Number__CCN_=provider));

	Penalty13=compress(FY2013_Readmission_Penalty, "%") * 1 /100;
	Penalty14=compress(FY_2014_Readmission_Penalty, "%") * 1/100;

	proc means Mean N Nmiss Min Max;
	var penalty13 penalty14;
	run;
	proc sort; by provider;
run;
data aha2010;
	set aha.aha10 (rename=(MCRNUM=provno));
	zipa = substr (mloczip, 1, 5);

	if serv=10 or serv=13 or serv=41 or serv=42 or serv=44 or serv=45 
	or serv=47 or serv=48 or serv=49;

	if HOSP_REG4 not in (1,2,3,4) then delete;
	if PROFIT2=4 then delete;

	if provno in ("140077", "140124", "140151", "110078", "110226", "100001", "390156", "220011") then casehosp=1; else casehosp=0;

	provider = provno*1; 
	proc freq; tables casehosp; 
	proc sort; by zipa;
run;
data ruca;
	set ruca.SAS_2006_RUCA;
	proc sort; by zipa;
run;
data rucaaha;
	merge	aha2010 (in=in1)
			ruca (in=in2);
	by 		zipa;
	
	if in1 then aha=1; else aha=0;
	if in2 then ruca=1; else ruca=0;

	proc freq; tables aha*ruca;
	proc sort; by provider;
run;
proc sort data=vol.hospvolume10 out=vol2010; by provider; run;
data readm;
	set readm.readmrate02to10hccfixed;
	
	adjreadm30dayami = mean (adjamireadm08ALL, adjamireadm09ALL, adjamireadm10ALL);
	adjreadm30daychf = mean (adjchfreadm08ALL, adjchfreadm09ALL, adjchfreadm10ALL);
	adjreadm30daypn  = mean (adjpnreadm08ALL,  adjpnreadm09ALL,  adjpnreadm10ALL);

	rawreadm30dayami = mean (amireadm08ALL, amireadm09ALL, amireadm10ALL);
	rawreadm30daychf = mean (chfreadm08ALL, chfreadm09ALL, chfreadm10ALL);
	rawreadm30daypn  = mean (pnreadm08ALL,  pnreadm09ALL,  pnreadm10ALL);

	proc means data=readm N Nmiss Mean std;
		var adjamireadm08ALL adjamireadm09ALL adjamireadm10ALL adjchfreadm08ALL adjchfreadm09ALL adjchfreadm10ALL adjpnreadm08ALL  adjpnreadm09ALL  adjpnreadm10ALL; run;
	proc sort; by provider;
run;
data table1; 
	merge	rucaaha (where=(aha=1) in=in1)
			vol2010 (in=in2)
			readm   (in=in3)
			penalty;
	by 		provider; 
	if 		in1;
		
	if in2 then vol=1; else vol=0;
	if in3 then readm=1; else readm=0;

	if RUCA_Level=1 then RUCACAT=1;
	else if RUCA_Level in (2, 3) then RUCACAT=2;
	else if RUCA_Level = 4    then RUCACAT=3;
	
	proc freq data=table1; 
		tables ruca_level*casehosp;
run;
%MACRO strname (strvar, title);
	%MACRO HOSP (HVAR);
		%DO I = 1 %TO 5;
				proc surveyfreq data=table1; 
					ODS OUTPUT CrossTabs=freq&title&i;
					tables %scan(&hvar., &i)* &strvar /chisq col cl;
				run;
				data h&title.&i; 
					keep 	byvar variable value  P1  P2;
					retain	byvar variable value  P1  P2;
					merge freq&title&i (where=(%scan(&hvar., &i)^=. and &strvar=1)
												  keep=%scan(&hvar., &i) &strvar Frequency colPercent colLowerCL colUpperCL
												  rename=(Frequency=N1 colpercent=P1 colLowerCL=LCL1 colUpperCL=UCL1))
						  freq&title&i (where=(%scan(&hvar., &i)^=. and &strvar=0)
												  keep=%scan(&hvar., &i) &strvar Frequency colPercent colLowerCL colUpperCL
												  rename=(Frequency=N2 colpercent=P2 colLowerCL=LCL2 colUpperCL=UCL2))
				;
				variable="%scan(&hvar., &i)"; 
				value = %scan(&hvar., &i);
				byvar = "&strvar";

				*proc print data=h&title.&i;
				title5 "Table 1: Variable %scan(&hvar., &i) by &strvar";
				run;				
		%end; 
		%DO I = 6 %TO 12;
				proc summary data=table1; 
					class 	&strvar;
					var		%scan(&hvar., &i);
				output out=n&title&i mean=mean&i median=med&i;
				run;
				data h&title.&i; 
					keep 	byvar variable value  P1 Med1 P2 Med2;
					retain	byvar variable value  P1 Med1 P2 Med2;
					merge n&title&i (where=(&strvar=1)  keep=&strvar mean&i med&i	rename=(mean&i=P1 med&i=MED1))
						  n&title&i (where=(&strvar=0)  keep=&strvar mean&i med&i	rename=(mean&i=P2 med&i=MED2))
				;
				variable="%scan(&hvar., &i)"; 
				byvar = "&strvar";
				value=1;

				*proc print data=h&title.&i;
				title5 "Table 1: Variable %scan(&hvar., &i) by &strvar";
				run;				
		%end; 
	%mend; 
	%hosp (HOSPSIZE PROFIT2 HOSP_REG4 RUCAcat mapp8 propblk10 p_medicaid p_medicare adjreadm30dayami adjreadm30daychf adjreadm30daypn Penalty13);
	run;
data h&title;
	set h&title.1   h&title.2   h&title.3   h&title.4  h&title.5  h&title.6  h&title.7  h&title.8  h&title.9 
		h&title.10	h&title.11  h&title.12;

	proc print data=h&title;
	title5 "Table 1 - Hospital Characteristics";
run;
%mend;
%strname (casehosp, case);
run;
	proc print data=hcase;
	title5 "Table 1 - Hospital Characteristics";
run;
