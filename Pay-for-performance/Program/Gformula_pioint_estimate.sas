

/*******************************************************************/
/* Standardization by multiple confounders using an outcome model
/********************************************************************/


/* create a dataset with 3 copies of each subject */  
data onesample ;
  set nhefs ;
  label interv= "Intervention"; 
  interv = -1 ;    /* 1st copy: equal to original one */
  	output ; 
  interv = 0 ;     /* 2nd copy: treatment set to 0, outcome to missing */
  	qsmk = 0 ;
  	wt82_71 = . ;
  	output ;  
  interv = 1 ;     /* 3rd copy: treatment set to 1, outcome to missing*/
  	qsmk = 1 ;
  	wt82_71 = . ;
  	output ;    
run;


* linear model to estimate mean outcome conditional on treatment and confounders;
* parameters are estimated using original observations only (interv= -1) ;
* parameter estimates are used to predict mean outcome for observations with 
  treatment set to 0 (interv=0) and to 1 (innterv=1);
proc genmod data = onesample;
	class exercise active education;
	model wt82_71 = qsmk sex race age age*age education
				smokeintensity smokeintensity*smokeintensity smokeyrs smokeyrs*smokeyrs
				exercise active wt71 wt71*wt71;
    output out = predicted_mean p = meanY ;
run;

* estimate mean outcome in each of the groups interv=0, and interv=1;
* this mean outcome is a weighted average of the mean outcomes in each combination 
	of values of treatment and confounders, that is, the standardized outcome;
proc means data = predicted_mean mean noprint;
  class interv ;
  var meanY ;
  types interv ;
  output out = results (keep = interv mean ) mean = mean ;
run;

proc print data = results noobs label ;
  title "Parametric g-formula";
  var interv mean ;
run;

