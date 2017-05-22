*********************************************
Minority Readmission-Academy Health Abstract
Xiner Zhou
1/13/2015
***********************************************;

libname data 'C:\data\Projects\Minority_Readmissions\Data';

%macro imp_xls(file=,out=);
proc import datafile="&file." dbms=xls out=&out. replace;
getnames=yes;
run;
%mend imp_xls;

%imp_xls(file=C:\data\Projects\Minority_Readmissions\Data\MR.xls,out=data)

data data;
set data;
if _7d =2 then _7d=1; 
if _22E =2 then _22E=1;if _22E=4 then _22E=5;
run;


%macro q7(var=);
proc freq data=data;tables &var.*designation/missing norow  nopercent chisq ;run;
proc glm data=data;
where &var. in (1,3,4) ;
class designation &var.;
model &var.=designation;
run;
%mend q7;
%q7(var=_7d);


%macro q6(var=);
proc freq data=data;tables &var.*designation /missing norow  nopercent chisq ;run;
proc glm data=data;
where &var. in (1,3,5) ;
class designation &var.;
model &var.=designation ;
run;
%mend q6;
%q6(var=_22E);






%macro imp_xls(file=,out=);
proc import datafile="&file." dbms=xls out=&out. replace;
getnames=yes;
run;
%mend imp_xls;

%imp_xls(file=C:\data\Projects\Minority_Readmissions\Data\Minority_Readmission.xls,out=data)
 


data temp;
set data;
 if var3 ne '';
if VAR3='MSH' then MSH=1;else MSH=0;

if Q2B=0 then Q2B=9;
if Q11D=5 then Q11D=9;
if q16=. then q16=9;
if Q18A=. then Q18A=9;
* Group;
if q6 =2 then q6=1;if q6=4 then q6=5;
if q7A =2 then q7a=1; 
if Q7B =2 then Q7B=1; 
if q7c =2 then q7c=1; 
if q7d =2 then q7d=1; 
if q7e =2 then q7e=1; 
if q7f =2 then q7f=1; 
if q7g =2 then q7g=1; 
if q7h =2 then q7h=1; 
if q7i =2 then q7i=1; 
if q7j =2 then q7j=1; 
if q7k =2 then q7k=1; 
if q7l =2 then q7l=1; 
if q7m =2 then q7m=1; 

if Q12A =2 then Q12A=1;if Q12A=4 then Q12A=5;
if Q12B =2 then Q12B=1;if Q12B=4 then Q12B=5;
if Q12C =2 then Q12C=1;if Q12C=4 then Q12C=5;
if Q12D =2 then Q12D=1;if Q12D=4 then Q12D=5;
if Q12E =2 then Q12E=1;if Q12E=4 then Q12E=5;
if Q12F =2 then Q12F=1;if Q12F=4 then Q12F=5;
if Q12G =2 then Q12G=1;if Q12G=4 then Q12G=5;
if Q12H =2 then Q12H=1;if Q12H=4 then Q12H=5;
if Q13A =2 then Q13A=1;if Q13A=4 then Q13A=5;
if Q13B =2 then Q13B=1;if Q13B=4 then Q13B=5;
if Q14A =2 then Q14A=1;if Q14A=4 then Q14A=5;
if Q14B =2 then Q14B=1;if Q14B=4 then Q14B=5;
if Q14C =2 then Q14C=1;if Q14C=4 then Q14C=5;
if Q14D =2 then Q14D=1;if Q14D=4 then Q14D=5;
if Q15A =2 then Q15A=1;if Q15A=4 then Q15A=5;
if Q15B =2 then Q15B=1;if Q15B=4 then Q15B=5;
if Q15C =2 then Q15C=1;if Q15C=4 then Q15C=5;
if Q15D =2 then Q15D=1;if Q15D=4 then Q15D=5;


if Q18A =2 then Q18A=1;if Q18A=4 then Q18A=5;
if Q18B =2 then Q18B=1;if Q18B=4 then Q18B=5;
if Q18C =2 then Q18C=1;if Q18C=4 then Q18C=5;
if Q19A =2 then Q19A=1;if Q19A=4 then Q19A=5;
if Q19B =2 then Q19B=1;if Q19B=4 then Q19B=5;
if Q20 =2 then Q20=1;if Q20=4 then Q20=5;
if Q21 =2 then Q21=1;if Q21=4 then Q21=5;
if Q22A =2 then Q22A=1;if Q22A=4 then Q22A=5;
if Q22B =2 then Q22B=1;if Q22B=4 then Q22B=5;
if Q22C =2 then Q22C=1;if Q22C=4 then Q22C=5;
if Q22D =2 then Q22D=1;if Q22D=4 then Q22D=5;
if Q22E =2 then Q22E=1;if Q22E=4 then Q22E=5;
if Q22F =2 then Q22F=1;if Q22F=4 then Q22F=5;
if Q14D =2 then Q14D=1;if Q14D=4 then Q14D=5;
if Q15A =2 then Q15A=1;if Q15A=4 then Q15A=5;
if Q15B =2 then Q15B=1;if Q15B=4 then Q15B=5;
if Q15C =2 then Q15C=1;if Q15C=4 then Q15C=5;
if Q15D =2 then Q15D=1;if Q15D=4 then Q15D=5;



keep MSH Q1_1 Q1_2 Q1_3 Q1_4 Q1_5 
Q2A Q2B Q2C Q3A Q3B Q3C Q3D Q3E Q4A Q4B Q4C Q4D 
Q5 Q6 Q7A Q7B Q7C Q7D Q7E Q7F
Q7G Q7H Q7I Q7J Q7K Q7L Q7M Q8A Q8B Q8C Q8D Q8E Q8F Q8G Q8H Q8I Q8J Q8K Q8L Q8M Q9_1 Q9_2 Q10 Q11A Q11B Q11C Q11D
Q12A Q12B Q12C Q12D Q12E Q12F Q12G Q12H Q13A Q13B Q14A Q14B Q14C Q14D Q15A Q15B Q15C Q15D 
Q16 Q17_1 Q17_2 
Q18A Q18B Q18C Q19A Q19B Q20 Q21 Q22A Q22B Q22C Q22D Q22E Q22F 
Q23A Q23B Q23C Q23D Q23E Q23F 
Q24A1 Q24B1 Q24A2 Q24B2 Q24C2 Q25A1 Q25A2 Q25B1 Q25B2 Q25C1 Q25C2 Q25D1 Q25D2 ;
*Q1_OTH Q26A Q26A_1 Q26B Q26B_1 Q26B_2 Q26B_3 Q26B_4 Q26B_5 Q26B_6 Q26C;
run;

%macro q1(var=);
proc freq data=temp;tables &var.*MSH /missing norow  nopercent chisq ;run;
proc glm data=temp;
where &var. in (0,1) ;
class MSH &var.;
model &var.=MSH;
run;
%mend q1;
%q1(var=Q1_1);
%q1(var=Q1_2);
%q1(var=Q1_3);
%q1(var=Q1_4);
%q1(var=Q1_5);
%macro q2(var=);
proc freq data=temp;tables &var.*MSH /missing norow  nopercent chisq ;run;
proc glm data=temp;
where &var. in (1,2) ;
class MSH &var.;
model &var.=MSH;
run;
%mend q2;
%q2(var=Q2A);
%q2(var=Q2B);
%q2(var=Q2C);
 
%q2(var=Q3A);
%q2(var=Q3B);
%q2(var=Q3C);
%q2(var=Q3D);
%q2(var=Q3E);

%q2(var=Q4A);
%q2(var=Q4B);
%q2(var=Q4C);
%q2(var=Q4D);


 
%macro q5(var=);
proc freq data=temp;tables &var.*MSH /missing norow  nopercent chisq ;run;
proc glm data=temp;
where &var. in (1,2,3) ;
class MSH &var.;
model &var.=MSH;
run;
%mend q5;
%q5(var=Q5);
 
%macro q6(var=);
proc freq data=temp;tables &var.*MSH /missing norow  nopercent chisq ;run;
proc glm data=temp;
where &var. in (1,3,5) ;
class MSH &var.;
model &var.=MSH;
run;
%mend q6;
%q6(var=Q6);

%macro q7(var=);
proc freq data=temp;tables &var.*MSH /missing norow  nopercent chisq ;run;
proc glm data=temp;
where &var. in (1,3,4) ;
class MSH &var.;
model &var.=MSH;
run;
%mend q7;
%q7(var=Q7a);
%q7(var=Q7b);
%q7(var=Q7c);
%q7(var=Q7d);
%q7(var=Q7e);
%q7(var=Q7f);
%q7(var=Q7g);
%q7(var=Q7h);
%q7(var=Q7i);
%q7(var=Q7j);
%q7(var=Q7k);
%q7(var=Q7l);
%q7(var=Q7m);



 
%macro q2(var=);
proc freq data=temp;tables &var.*MSH /missing norow  nopercent chisq ;run;
proc glm data=temp;
where &var. in (1,2) ;
class MSH &var.;
model &var.=MSH;
run;
%mend q2;
%q2(var=Q8A);
%q2(var=Q8B);
%q2(var=Q8C);
%q2(var=Q8D);
%q2(var=Q8E);
%q2(var=Q8F);
%q2(var=Q8G);
%q2(var=Q8H);
%q2(var=Q8I);
%q2(var=Q8J);
%q2(var=Q8K);
%q2(var=Q8L);
%q2(var=Q8M);

%q2(var=Q10);

 
proc freq data=temp;
where Q10=2;
tables Q11A*MSH /missing norow  nopercent chisq ;run;
proc glm data=temp;
where Q10=2 and Q11A in (1,2) ;
class MSH Q11A;
model Q11A=MSH;
run;

proc freq data=temp;
where Q10=2;
tables Q11B*MSH /missing norow  nopercent chisq ;run;
proc glm data=temp;
where Q10=2 and Q11B in (1,2) ;
class MSH Q11B;
model Q11B=MSH;
run;

proc freq data=temp;
where Q10=2;
tables Q11C*MSH /missing norow  nopercent chisq ;run;
proc glm data=temp;
where Q10=2 and Q11C in (1,2) ;
class MSH Q11C;
model Q11C=MSH;
run;

proc freq data=temp;
where Q10=2;
tables Q11D*MSH /missing norow  nopercent chisq ;run;
proc glm data=temp;
where Q10=2 and Q11D in (1,2) ;
class MSH Q11D;
model Q11D=MSH;
run;

 

%macro q6(var=);
proc freq data=temp;tables &var.*MSH /missing norow  nopercent chisq ;run;
proc glm data=temp;
where &var. in (1,3,5) ;
class MSH &var.;
model &var.=MSH;
run;
%mend q6;
%q6(var=Q12A);
%q6(var=Q12B);
%q6(var=Q12C);
%q6(var=Q12D);
%q6(var=Q12E);
%q6(var=Q12F);
%q6(var=Q12G);
%q6(var=Q12H);
%q6(var=Q13A);
%q6(var=Q13B);
%q6(var=Q14A);
%q6(var=Q14B);
%q6(var=Q14C);
%q6(var=Q14D);
%q6(var=Q15A);
%q6(var=Q15B);
%q6(var=Q15C);
%q6(var=Q15D);

 

%q6(var=Q18A);
%q6(var=Q18B);
%q6(var=Q18C);
%q6(var=Q19A);
%q6(var=Q19B);
 
%q6(var=Q20);
%q6(var=Q21);

%q6(var=Q22A);
%q6(var=Q22B);
%q6(var=Q22C);
%q6(var=Q22D);
%q6(var=Q22E);
%q6(var=Q22F);



%macro q23(var=);
proc freq data=temp;tables &var.*MSH /missing norow  nopercent chisq ;run;
proc glm data=temp;
where &var. in (9,10) ;
class MSH &var.;
model &var.=MSH;
run;
%mend q23;
%q23(var=Q23A);
%q23(var=Q23B);
%q23(var=Q23C);
%q23(var=Q23D);
%q23(var=Q23E);
%q23(var=Q23F);




%q2(var=Q24A1);
%q2(var=Q24B1);
%q2(var=Q24A2);
%q2(var=Q24B2);
%q2(var=Q24C2);

%q2(var=Q25A1);
%q2(var=Q25A2);
%q2(var=Q25B1);
%q2(var=Q25B2);
%q2(var=Q25C1);
%q2(var=Q25C2);
%q2(var=Q25D1);
%q2(var=Q25D2);

 

%macro imp_xls(file=,out=);
proc import datafile="&file." dbms=xls out=&out. replace;
getnames=yes;
run;
%mend imp_xls;

%imp_xls(file=C:\data\Projects\Minority_Readmissions\Data\Denominator.xls,out=hospital)

libname aha 'C:\data\Data\Hospital\AHA\Annual_Survey\Data';

data aha06;
set aha.aha06 ;
medicareid=provider*1;id1=id*1;
keep medicareid propblk06 id1;
run;
data aha07;
set aha.aha07 ;
medicareid=provider*1;id1=id*1;
keep medicareid propblk07 id1;
run;
data aha12;
set aha.aha12 ;
medicareid=provider*1;id1=id*1;
keep medicareid propblk12 id1;
run;
 
 

data hospital;
set hospital;
medicareid=medicare_id*1;
run;

%macro merge(yr=);

proc sql;
create table temp1 as
select a.*,b.propblk&yr.
from hospital a left join aha&yr. b
on a.medicareid=b.medicareid;
quit;

data temp2 temp3;
set temp1;
if propblk&yr.=. then output temp3;else output temp2;
run;

proc sql;
create table temp4 as
select a.*,b.propblk&yr.,b.id1
from temp3 a left join aha&yr. b
on a.medicareid=b.id1;
quit;

data temp5;
set temp2 temp4(drop=id1);
run;

proc rank data=temp5 out=all&yr. percent  ;
var propblk&yr.;
ranks propblk&yr.Rank;
run;

proc sort data=all&yr.;by descending propblk&yr.Rank;run;

%mend merge;
%merge(yr=06);
%merge(yr=07);
%merge(yr=12);

proc sql;
create table temp6 as
select a.*,b.propblk07,b.propblk07Rank
from all06 a full join all07 b
on a.medicare_id=b.medicare_id;
quit;

proc sql;
create table temp7 as
select a.*,b.propblk12,b.propblk12Rank
from temp6 a full join all12 b
on a.medicare_id=b.medicare_id;
quit;


ods Tagsets.ExcelxP body='C:\data\Projects\Minority_Readmissions\Output\rank.xml';

proc print data=temp7;run;

ods Tagsets.ExcelxP close;


