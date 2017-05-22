******************************************************************************
Filename:		BasicEHR.sas
Purpose:        at least Basic EHR adoption rate
Date:           06/30/2014
******************************************************************************;
%put Run on %sysfunc (date(), worddatx15. ) at  %sysfunc (time(), time9. ) ;

TITLE2 "Filename:	C:\data\Projects\EHR_cost\program\check_dataset.sas";
TITLE3 "Project:	EHR cost";
TITLE4 "Purpose:	Check dataset";

options nocenter ls=132 ps=1000 pageno=1;
