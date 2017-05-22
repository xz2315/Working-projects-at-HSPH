********************************
Adjusted Analyses --Method 3: Predicted Means
Xiner Zhou
4/2/2015
*******************************;

libname data 'C:\data\Projects\Minority_Readmissions\Data';

%macro effectplot(y=);
proc sort data=data.survey_analytic ;by descending &y.;run;
proc genmod data=data.survey_analytic order=data ;
class group_num &y.  ;
		model &y.=group_num  / dist = bin link = logit  ; 
		weight wt; 
effectplot / at(group_num=all)  ;
*effectplot slicefit(sliceby=g  ) / noobs; 
run;
%mend effectplot;


%effectplot(y=y2A); 
%effectplot(y=y2B); 
%effectplot(y=y2C); 
 
%effectplot(y=y3A); 
%effectplot(y=y3B); 
%effectplot(y=y3C); 
%effectplot(y=y3D); 
%effectplot(y=y3E); 
 
%effectplot(y=y4A); 
%effectplot(y=y4B); 
%effectplot(y=y4C); 
%effectplot(y=y4D);

%effectplot(y=y5);
 
%effectplot(y=y6); 

%effectplot(y=y7A); 
%effectplot(y=y7b); 
%effectplot(y=y7c); 
%effectplot(y=y7d); 
%effectplot(y=y7e); 
%effectplot(y=y7f); 
%effectplot(y=y7g); 
%effectplot(y=y7h); 
%effectplot(y=y7i); 
%effectplot(y=y7j); 
%effectplot(y=y7k); 
%effectplot(y=y7l); 
%effectplot(y=y7m); 

%effectplot(y=y8A); 
%effectplot(y=y8b); 
%effectplot(y=y8c); 
%effectplot(y=y8d); 
%effectplot(y=y8e); 
%effectplot(y=y8f); 
%effectplot(y=y8g); 
%effectplot(y=y8h); 
%effectplot(y=y8i); 
%effectplot(y=y8j); 
%effectplot(y=y8k); 
%effectplot(y=y8l); 
%effectplot(y=y8m); 

%effectplot(y=y10);  
  
%effectplot(y=y11A); ****Based on Q10;
%effectplot(y=y11b); 
%effectplot(y=y11c); 
%effectplot(y=y11d); 

%effectplot(y=y12A); 
%effectplot(y=y12b); 
%effectplot(y=y12c); 
%effectplot(y=y12d); 
%effectplot(y=y12e); 
%effectplot(y=y12f); 
%effectplot(y=y12g); 
%effectplot(y=y12h); 

%effectplot(y=y13A); 
%effectplot(y=y13b); 

%effectplot(y=y14A); 
%effectplot(y=y14b); 
%effectplot(y=y14c); 
%effectplot(y=y14d); 
  
%effectplot(y=y15A); 
%effectplot(y=y15b); 
%effectplot(y=y15c); 
%effectplot(y=y15d); 

%effectplot(y=y16);
 
%effectplot(y=y18A); 
%effectplot(y=y18b); 
%effectplot(y=y18c); 
 
%effectplot(y=y19A); 
%effectplot(y=y19b); 

%effectplot(y=y20); 

%effectplot(y=y21); 

%effectplot(y=y22A); 
%effectplot(y=y22b); 
%effectplot(y=y22c); 
%effectplot(y=y22d); 
%effectplot(y=y22e); 
%effectplot(y=y22f); 

%effectplot(y=y23a); 
%effectplot(y=y23b); 
%effectplot(y=y23c); 
%effectplot(y=y23d); 
%effectplot(y=y23e); 
%effectplot(y=y23f); 

%effectplot(y=y24a1);
%effectplot(y=y24b1);
%effectplot(y=y24a2);
%effectplot(y=y24b2);
%effectplot(y=y24c2);
 
%effectplot(y=y25A1);
%effectplot(y=y25A2);
%effectplot(y=y25B1);
%effectplot(y=y25B2);
%effectplot(y=y25C1);
%effectplot(y=y25C2);
%effectplot(y=y25D1);
%effectplot(y=y25D2);
 
