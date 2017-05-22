***********************************
Adjust for Hospital Characteristics
Xiner Zhou
2/11/2015
************************************;

libname data 'C:\data\Projects\Minority_Readmissions\Data';
libname aha 'C:\data\Data\Hospital\AHA\Annual_Survey\Data';

 
 
%macro Adjusted(q=,way=1);

data temp3;
set data.denominator;
where respond=1;
if hisp_group='Top Hispanic' then hisp_g=1;else hisp_g=0; 
if group='Top 10%' then black_g=1;else if group='Top 10-25%' then black_g=2;else black_g=3; 
if &way. =1 then do;*Always or Usual;
	if &q. in (1,2) then temp=1;else temp=0;
end;
else if &way. =2 then do;
	if &q. in (4,5) then temp=1;else temp=0;
end;
else if &way. =3 then do;*YES;
	if &q. in (1) then temp=1;else temp=0;
end;
else if &way. =4 then do; *Higher than average;
	if &q. in (3) then temp=1;else temp=0;
end;
else if &way. =5 then do; *IMPROVED SIGNIFICANTLY;
	if &q. in (1) then temp=1;else temp=0;
end;
else if &way. =6 then do; *4+Extremely Likely; 
	if &q. in (4,5) then temp=1;else temp=0;
end;
else if &way. =7 then do; *Too Large+Much Too Large; 
	if &q. in (4,5) then temp=1;else temp=0;
end; 
else if &way. =8 then do; *care will improve somewhat + care will improve a great deal;
	if &q. in (4,5) then temp=1;else temp=0;
end; 
else if &way. =9 then do; *Agree or Agree Stronly;
	if &q. in (4,5) then temp=1;else temp=0;
end; 
 else if &way. =10 then do; *9+Highest Priority;
	if &q. in (9,10) then temp=1;else temp=0;
end; 
 

run;
 

proc freq data=temp3;
title "&q. Simple Freq Stratified by Percent of Hispanic";
weight wt; 
tables temp*hisp_group/chisq norow nopercent;run;


proc freq data=temp3;
title "&q. Simple Freq Stratified by Percent of Black(MSH)";
weight wt; 
tables temp*group/chisq norow nopercent;run;


proc logistic data=temp3;
title "&q. p-value from logistic regression for Hispanic";
	class temp(ref="0") hisp_g(ref="0") ruca_level(ref="1")  profit2(ref="1") teaching(ref="3") hosp_reg4(ref="1") CICU(ref="1") mhsmemb(ref="1")  /param=ref ;
	weight wt;
    model temp  = hisp_g  ; 
	contrast 'Top Hispanic vs Others' hisp_g 1 ;	
run;



proc logistic data=temp3;
title "&q. Percent of Hispanic Adjust for hospital characteristics ";
	class temp(ref="0") hisp_g(ref="0") ruca_level(ref="1")  profit2(ref="1") teaching(ref="3") hosp_reg4(ref="1") CICU(ref="1") mhsmemb(ref="1")  /param=ref ;
	weight wt;
    model temp  = hisp_g  ruca_level profit2 teaching hosp_reg4 CICU mhsmemb ; 
contrast 'Top Hispanic vs Others' hisp_g 1  ;	 
run;

proc logistic data=temp3;
title "&q. p-value from logistic regression for MSH";
	class temp(ref="0")  black_g(ref="3") ruca_level(ref="1")  profit2(ref="1") teaching(ref="3") hosp_reg4(ref="1") CICU(ref="1") mhsmemb(ref="1")  /param=ref ;
	weight wt;
model temp  = black_g  ; 
contrast 'Major MSH vs non-MSH' black_g 1 0 ;	
contrast 'Minor MSH vs non-MSH' black_g 0 1 ;	 
contrast 'Major MSH vs Minor MSH' black_g 1 -1  ;	  
run;

proc logistic data=temp3;
title "&q. Percent of Black Adjust for hospital characteristics ";
	class temp(ref="0") black_g(ref="3") ruca_level(ref="1")  profit2(ref="1") teaching(ref="3") hosp_reg4(ref="1") CICU(ref="1") mhsmemb(ref="1")  /param=ref ;
	weight wt;
model temp  = black_g ruca_level profit2 teaching hosp_reg4 CICU mhsmemb ; 
contrast 'Major MSH vs non-MSH' black_g 1 0  ;	
contrast 'Minor MSH vs non-MSH' black_g 0 1  ;	 
contrast 'Major MSH vs Minor MSH' black_g 1 -1 ;
run;

proc logistic data=temp3;
title "&q. Both Percent of Black and Hispanic Adjust for hospital characteristics Model";
	class temp(ref="0") hisp_g(ref="0") black_g(ref="3") ruca_level(ref="1")  profit2(ref="1") teaching(ref="3") hosp_reg4(ref="1") CICU(ref="1") mhsmemb(ref="1")  /param=ref ;
	weight wt;
model temp  = hisp_g black_g ruca_level profit2 teaching hosp_reg4 CICU mhsmemb ; 
contrast 'Top Hispanic vs Others' hisp_g 1; 	 
contrast 'Major MSH vs non-MSH' black_g 1 0 ;	
contrast 'Minor MSH vs non-MSH' black_g 0 1  ;	 
contrast 'Major MSH vs Minor MSH' black_g 1 -1;
run;
 
%mend Adjusted;
%Adjusted(q=q2a,way=3);
%Adjusted(q=q2b,way=3);
%Adjusted(q=q2c,way=3);

%Adjusted(q=q2a,way=3);
%Adjusted(q=q2b,way=3);
%Adjusted(q=q2c,way=3);

%Adjusted(q=q3a,way=3);
%Adjusted(q=q3b,way=3);
%Adjusted(q=q3c,way=3);
%Adjusted(q=q3d,way=3);
%Adjusted(q=q3e,way=3);

%Adjusted(q=q4a,way=3);
%Adjusted(q=q4b,way=3);
%Adjusted(q=q4c,way=3);
%Adjusted(q=q4d,way=3);

%Adjusted(q=q5,way=4);

%Adjusted(q=q6,way=5);

%Adjusted(q=Q7A,way=1);
%Adjusted(q=q7b,way=1);
%Adjusted(q=q7c,way=1);
%Adjusted(q=q7d,way=1);
%Adjusted(q=q7e,way=1);
%Adjusted(q=q7f,way=1);
%Adjusted(q=q7g,way=1);
%Adjusted(q=q7h,way=1);
%Adjusted(q=q7i,way=1);
%Adjusted(q=q7j,way=1);
%Adjusted(q=q7k,way=1);
%Adjusted(q=q7l,way=1);
%Adjusted(q=q7m,way=1);

%Adjusted(q=q8a,way=3);
%Adjusted(q=q8b,way=3);
%Adjusted(q=q8c,way=3);
%Adjusted(q=q8d,way=3);
%Adjusted(q=q8e,way=3);
%Adjusted(q=q8f,way=3);
%Adjusted(q=q8g,way=3);
%Adjusted(q=q8h,way=3);
%Adjusted(q=q8i,way=3);
%Adjusted(q=q8j,way=3);
%Adjusted(q=q8k,way=3);
%Adjusted(q=q8l,way=3);
%Adjusted(q=q8m,way=3);

%Adjusted(q=q10,way=3);

%Adjusted(q=q11a,way=3);
%Adjusted(q=q11b,way=3);
%Adjusted(q=q11c,way=3);
%Adjusted(q=q11d,way=3);
 
%Adjusted(q=q12a,way=2);
%Adjusted(q=q12b,way=2);
%Adjusted(q=q12c,way=2);
%Adjusted(q=q12d,way=2);
%Adjusted(q=q12e,way=2);
%Adjusted(q=q12f,way=2);
%Adjusted(q=q12g,way=2);
%Adjusted(q=q12h,way=2);

%Adjusted(q=q13a,way=2);
%Adjusted(q=q13b,way=2);

%Adjusted(q=q14a,way=2);
%Adjusted(q=q14b,way=2);
%Adjusted(q=q14c,way=2);
%Adjusted(q=q14d,way=2);

%Adjusted(q=q15a,way=2);
%Adjusted(q=q15b,way=2);
%Adjusted(q=q15c,way=2);
%Adjusted(q=q15d,way=2);

%Adjusted(q=q16,way=3);

%Adjusted(q=q18a,way=2);
%Adjusted(q=q18b,way=2);
%Adjusted(q=q18c,way=2);

%Adjusted(q=q19a,way=6);
%Adjusted(q=q19b,way=6);

%Adjusted(q=q20,way=7);

%Adjusted(q=q21,way=8);

%Adjusted(q=q22a,way=9);
%Adjusted(q=q22b,way=9);
%Adjusted(q=q22c,way=9);
%Adjusted(q=q22d,way=9);
%Adjusted(q=q22e,way=9);
%Adjusted(q=q22f,way=9);

%Adjusted(q=q23a,way=10);
%Adjusted(q=q23b,way=10);
%Adjusted(q=q23c,way=10);
%Adjusted(q=q23d,way=10);
%Adjusted(q=q23e,way=10);
%Adjusted(q=q23f,way=10);

%Adjusted(q=q24a1,way=3);
%Adjusted(q=q24b1,way=3);
%Adjusted(q=q24a2,way=3);
%Adjusted(q=q24c2,way=3);

%Adjusted(q=q25a1,way=3);
%Adjusted(q=q25a2,way=3);
%Adjusted(q=q25b1,way=3);
%Adjusted(q=q25b2,way=3);
%Adjusted(q=q25c1,way=3);
%Adjusted(q=q25c2,way=3);
%Adjusted(q=q25d1,way=3);
%Adjusted(q=q25d2,way=3);
