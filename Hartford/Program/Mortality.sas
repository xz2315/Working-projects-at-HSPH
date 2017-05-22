****************************************
Outcome Measures
Xiner Zhou
8/18/2015
***************************************;
libname data 'C:\data\Projects\Hartford\Data';
libname mort 'C:\data\Data\Hospital\Medicare_Inpt\Mortality\data';

%macro mort(yr=);
data temp20&yr.;
set mort.adjmort37meas30day&yr.;
/*
if rawmortmeas_amiALL30day=. then rawmortmeas_amiALL30day=0;
if rawmortmeas_chfALL30day=. then rawmortmeas_chfALL30day=0;
if rawmortmeas_PnALL30day=. then rawmortmeas_PnALL30day=0;

if pmortmeas_amiALL30day=. then pmortmeas_amiALL30day=0;
if pmortmeas_chfALL30day=. then pmortmeas_chfALL30day=0;
if pmortmeas_PNALL30day=. then pmortmeas_PNALL30day=0;

if NDmortmeas_amiALL=. then NDmortmeas_amiALL=0;
if NDmortmeas_chfALL=. then NDmortmeas_chfALL=0;
if NDmortmeas_PNALL=. then NDmortmeas_PNALL=0;
*/

n1=NDmortmeas_amiALL*rawmortmeas_amiALL30day
+NDmortmeas_chfALL*rawmortmeas_chfALL30day
+NDmortmeas_pnALL*rawmortmeas_pnALL30day;
n2=NDmortmeas_amiALL+NDmortmeas_chfALL+NDmortmeas_pnALL;
obs=NDmortmeas_amiALL*rawmortmeas_amiALL30day
+NDmortmeas_chfALL*rawmortmeas_chfALL30day
+NDmortmeas_pnALL*rawmortmeas_pnALL30day;
pred=NDmortmeas_amiALL*pmortmeas_amiALL30day
+NDmortmeas_chfALL*pmortmeas_chfALL30day
+NDmortmeas_pnALL*pmortmeas_pnALL30day;

keep        PROVIDER n1 n2 obs pred
			adjmortmeas_amiALL30day
			overallmortmeas_amiALL30day 
			NDmortmeas_amiALL
			rawmortmeas_amiALL30day
		    pmortmeas_amiALL30day
			 
			adjmortmeas_chfALL30day
			overallmortmeas_chfALL30day
			NDmortmeas_chfALL
			rawmortmeas_chfALL30day
			pmortmeas_chfALL30day
			 
			adjmortmeas_pnALL30day
			overallmortmeas_pnALL30day
			NDmortmeas_pnALL
			rawmortmeas_pnALL30day
			pmortmeas_pnALL30day ;

run;

proc sql;
create table temp120&yr. as 
select *,sum(n1)/sum(n2) as rate,calculated rate*obs/pred as mortality20&yr.
from temp20&yr.;
quit;

data data.mort20&yr.;
set temp120&yr.;
label mortality20&yr.="Composite 30-Day Mortality (AMI CHF PN) 20&yr.";
keep provider mortality20&yr.;
run;
%mend mort;
%mort(yr=13);
%mort(yr=12);
%mort(yr=11);
%mort(yr=10);
%mort(yr=09);
%mort(yr=08);



 

















































/* Composite Score:
http://pareonline.net/getvn.asp?v=14&n=20


data temp;
set mort.adjmort37meas30day12;
n1=NDmortmeas_amiALL*rawmortmeas_amiALL30day
+NDmortmeas_chfALL*rawmortmeas_chfALL30day
+NDmortmeas_pnALL*rawmortmeas_pnALL30day;
n2=NDmortmeas_amiALL+NDmortmeas_chfALL+NDmortmeas_pnALL;
obs=NDmortmeas_amiALL*rawmortmeas_amiALL30day
+NDmortmeas_chfALL*rawmortmeas_chfALL30day
+NDmortmeas_pnALL*rawmortmeas_pnALL30day;
pred=NDmortmeas_amiALL*pmortmeas_amiALL30day
+NDmortmeas_chfALL*pmortmeas_chfALL30day
+NDmortmeas_pnALL*pmortmeas_pnALL30day;

keep        PROVIDER n1 n2 obs pred
			adjmortmeas_amiALL30day
			overallmortmeas_amiALL30day 
			NDmortmeas_amiALL
			rawmortmeas_amiALL30day
		    pmortmeas_amiALL30day
			 
			adjmortmeas_chfALL30day
			overallmortmeas_chfALL30day
			NDmortmeas_chfALL
			rawmortmeas_chfALL30day
			pmortmeas_chfALL30day
			 
			adjmortmeas_pnALL30day
			overallmortmeas_pnALL30day
			NDmortmeas_pnALL
			rawmortmeas_pnALL30day
			pmortmeas_pnALL30day ;

run;
 
PROC FACTOR  DATA=temp score  n=3 OUTSTAT=fact;
var adjmortmeas_amiALL30day  adjmortmeas_CHFALL30day  adjmortmeas_PNALL30day ;
run;

PROC SCORE  DATA=temp   SCORE=fact   OUT=new;  
var adjmortmeas_amiALL30day  adjmortmeas_CHFALL30day  adjmortmeas_PNALL30day ;
run;

proc sql;
create table temp1 as 
select *,sum(n1)/sum(n2) as rate,calculated rate*obs/pred as obsoverexp, calculated rate+factor1 as factoranalysis
from new;
quit;



*/
