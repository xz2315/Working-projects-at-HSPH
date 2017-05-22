*****************************************
Generalizability Table
****************************************;
libname data 'D:\Projects\Hartford\Data\data';
proc format;
value ruca_
1="Urban or Suburban"
2="Rural"
;
run;
proc format;
value hospsize_
1="Small"
2="Medium"
3="Large"
;
run;
proc format;
value SNH_
1="Safety-Net Hospital (Top Quartile DSH%)"
2="Non-Safety-Net Hospital"
;
run;
proc format;
value profit_
1="Investor Owned, For-Profit"
2="Non-Government, Not-For-Profit"
3="Government, Non-Federal"
4="Government, Federal"
;
run;
proc format;
value teaching_
1="Major Teaching Hospital"
2="Minor Teaching Hospital"
3="Non-Teaching Hospital"
;
run;

data temp;
set data.Hartford;
if respond2008=. then respond2008=0;if respond2009=. then respond2009=0;if respond2010=. then respond2010=0;
if respond2011=. then respond2011=0;if respond2012=. then respond2012=0;if respond2013=. then respond2013=0;
Nrespond=respond2008+respond2009+respond2010+respond2011+respond2012+respond2013;
*teaching;
if teaching=3 then teaching1=2;else if teaching in (1,2) then teaching1=1;else if teaching=. then teaching1=.;
label teaching1="1=Teaching Hospital 2=Non-Teaching Hospital";

if profit2 not in (.,4);
if Nrespond>=3 then sample=1;else sample=0;
*Urban;
if ruca_level in (3,4) then ruca=2;  else if ruca_level in (1,2) then Ruca=1;
*SNH;
if SNH2012=4 then SNH=1;else if SNH2012 ne . then SNH=2;else if SNH2012=. then SNH=.;
proc freq;tables sample SNH/missing;
run;
 
ODS Listing CLOSE;
ODS html file="D:\Projects\Hartford\Table 1.xls" style=minimal;
proc tabulate data=temp  noseps  ;
class sample ruca teaching1 hospsize profit2   ;
format ruca ruca_.  hospsize hospsize_.  teaching1 teaching_. profit2 profit_.  ;
table (ruca="Urban/Rural"  teaching1="Teaching Status"  hospsize="Size" profit2="Ownership" ),(sample all)*(N colpctn);
Keylabel all="All Hospital"
         N="Number of Hospital"
		 colpctn="Column Percent";
run;
ODS html close;
ODS Listing; 

 
proc freq data=temp;
tables sample*ruca sample*teaching sample*hospsize sample*profit2/nopercent norow  chisq;
run;
