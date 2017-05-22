********************************
Overall Frequency
Xiner Zhou
4/8/2015
*******************************;

libname data 'C:\data\Projects\Minority_Readmissions\Data';
 


%macro freq(y=);
 
proc freq data=data.survey_analytic;weight wt;tables &y./out=&y.;run;
data &y.;
length label $20.;
set &y.;
where &y.=1;
label="&y.";
percent=percent/100;
rename &y.=Question;
keep  percent label;
run;
%mend freq;
%freq(y=y2a);
%freq(y=y2b);
%freq(y=y2c);
%freq(y=y3a);
%freq(y=y3b);
%freq(y=y3c);
%freq(y=y3d);
%freq(y=y3e);
%freq(y=y4a);
%freq(y=y4b);
%freq(y=y4c);
%freq(y=y4d);
%freq(y=y5);
%freq(y=y6);
%freq(y=y7a);
%freq(y=y7b);
%freq(y=y7c);
%freq(y=y7d);
%freq(y=y7e);
%freq(y=y7f);
%freq(y=y7g);
%freq(y=y7h);
%freq(y=y7i);
%freq(y=y7j);
%freq(y=y7k);
%freq(y=y7l);
%freq(y=y7m);
%freq(y=y8a);
%freq(y=y8b);
%freq(y=y8c);
%freq(y=y8d);
%freq(y=y8e);
%freq(y=y8f);
%freq(y=y8g);
%freq(y=y8h);
%freq(y=y8i);
%freq(y=y8j);
%freq(y=y8k);
%freq(y=y8l);
%freq(y=y8m);
%freq(y=y10);
%freq(y=y11a);
%freq(y=y11b);
%freq(y=y11c);
%freq(y=y11d);
%freq(y=y12a);
%freq(y=y12b);
%freq(y=y12c);
%freq(y=y12d);
%freq(y=y12e);
%freq(y=y12f);
%freq(y=y12g);
%freq(y=y12h);
%freq(y=y13a);
%freq(y=y13b);
%freq(y=y14a);
%freq(y=y14b);
%freq(y=y14c);
%freq(y=y14d);
%freq(y=y15a);
%freq(y=y15b);
%freq(y=y15c);
%freq(y=y15d);
%freq(y=y16);
%freq(y=y18a);
%freq(y=y18b);
%freq(y=y18c);
%freq(y=y19a);
%freq(y=y19b);
%freq(y=y20);
%freq(y=y21);
%freq(y=y22a);
%freq(y=y22b);
%freq(y=y22c);
%freq(y=y22d);
%freq(y=y22e);
%freq(y=y22f);
%freq(y=y23a);
%freq(y=y23b);
%freq(y=y23c);
%freq(y=y23d);
%freq(y=y23e);
%freq(y=y23f);
%freq(y=y24a1);
%freq(y=y24b1);
%freq(y=y24a2);
%freq(y=y24b2);
%freq(y=y24c2);
%freq(y=y25a1);
%freq(y=y25a2);
%freq(y=y25b1);
%freq(y=y25b2);
%freq(y=y25c1);
%freq(y=y25c2);
%freq(y=y25d1);
%freq(y=y25d2);


data overall;
length q $30.;
set y2A y2B y2C
y3A y3B y3C y3D y3E 
y4a y4b y4c y4d
y5
y6
y7a y7b y7c y7d y7e y7f y7g y7h y7i y7j y7k y7l y7m
y8a y8b y8c y8d y8e y8f y8g y8h y8i y8j y8k y8l y8m
y10
y11A y11b y11c y11d 
y12a y12b y12c y12d y12e y12f y12g y12h
y13a y13b
y14a y14b y14c y14d
y15a y15b y15c y15d
y16
y18a y18b y18c
y19a y19b
y20
y21
y22a y22b y22c y22d y22e y22f
y23a y23b y23c y23d y23e y23f
y24a1 y24b1 y24a2 y24b2 y24c2
y25A1 y25A2 y25B1 y25B2 y25C1 y25C2 y25D1 y25D2;

proc print; 
run;
