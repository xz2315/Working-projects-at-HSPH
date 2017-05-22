%macro rename(cond=);
rename &cond.&yr1.01=&cond.1 &cond.&yr1.02=&cond.2 &cond.&yr1.03=&cond.3 &cond.&yr1.04=&cond.4 &cond.&yr1.05=&cond.5 &cond.&yr1.06=&cond.6 
       &cond.&yr1.07=&cond.7 &cond.&yr1.08=&cond.8 &cond.&yr1.09=&cond.9 &cond.&yr1.10=&cond.10 &cond.&yr1.11=&cond.11 &cond.&yr1.12=&cond.12  
       &cond.&yr2.01=&cond.13 &cond.&yr2.02=&cond.14 &cond.&yr2.03=&cond.15 &cond.&yr2.04=&cond.16 &cond.&yr2.05=&cond.17 &cond.&yr2.06=&cond.18 
       &cond.&yr2.07=&cond.19 &cond.&yr2.08=&cond.20 &cond.&yr2.09=&cond.21 &cond.&yr2.10=&cond.22 &cond.&yr2.11=&cond.23 &cond.&yr2.12=&cond.24  ;
%mend rename;

*the macro "Elix" results in a ip claim dataset with each claim have indicators tracing back 12 months;
%macro Elix(yr1,yr2=);
proc sort data=ip.ip&yr2.;by bene_id;run;
proc sort data=elix&yr1.;by bene_id;run;
proc sort data=elix&yr2.;by bene_id;run;

data ip&yr2.;
merge ip.ip&yr2.(in=in1)  elix&yr1.  elix&yr2. ;
by bene_id;
if in1=1;
 
%rename(cond=AMI);

run;

data ip&yr2.;
set ip&yr2.;
c=month(AdmissionDate);
%let start=c;
%let end=%eval(&start.+11);
AMI=sum(of AMI&start. - AMI&end. )>0;
%mend Elix;
 


  
