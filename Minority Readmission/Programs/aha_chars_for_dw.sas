libname aha 'C:\data\Data\Hospital\AHA\Annual_Survey\Data';
libname dt 'C:\data\Users\rwild\Desktop';

/*
proc logistic data=msh_hit07 desc;
  class hospsize hosp_reg4 profit2 urban teaching mhsmemb cicu / param=ref desc;
  model it_response=hospsize hosp_reg4 profit2 urban teaching mhsmemb cicu;
  output out=nrpred p=p_resp;
run;
*/

data aha12;
  set aha.aha12;
  keep provider STCD HSANAME--BSC mhsmemb urban SYSID--AHAMBR profit2--cmi2012;
  if provider in ('050771','251332','321308','340186','420105','520051');
run;

data aha09;
  set aha.aha09;
  keep provider STCD HSANAME--BSC mhsmemb urban SYSID--AHAMBR profit2--cmi2009;
  if provider in ('010167','450530');
run;

data aha_missings;
  set aha09(drop=bsc) aha12(drop=bsc);
run;




data aha11;
  set aha.aha11;
  keep provider STCD HSANAME--BSC mhsmemb urban SYSID--AHAMBR profit2--cmi2011;
  if provider in ('390329','390329','450530');
run;





data aha10;
  set aha.aha10;
  keep provider STCD HSANAME--BSC mhsmemb urban SYSID--AHAMBR profit2--cmi2010;
  if provider in ('010167','390329','450530');
run;



'390329',

data aha03;
  set aha.aha03;
  if provider in ('');
run;

data aha11;
  set aha.aha11;
  *keep provider STCD HSANAME--BSC mhsmemb urban SYSID--AHAMBR profit2--cmi2007;
  if provider in ('390329');
run;

data.ahamissing;
  set 


proc contents data=aha12;
run;

data dt.aha12;
  set aha12;
run;

data dt.aha11;
  set aha11;
run;

data dt.aha10;
  set aha10;
run;

data dt.aha_missings;
  set aha_missings;
run;
