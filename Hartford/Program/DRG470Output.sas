****************************************
DRG 470 Volume , Mortality, Readmission
Xiner Zhou
12/9/2015
*****************************************;

libname data 'C:\data\Projects\Jha_Requests\Data';

proc sort data=data.VolDRG4692008;by provider;run;
proc sort data=data.VolDRG4692009;by provider;run;
proc sort data=data.VolDRG4692010;by provider;run;
proc sort data=data.VolDRG4692011;by provider;run;
proc sort data=data.VolDRG4692012;by provider;run;
proc sort data=data.VolDRG4692013;by provider;run;

data Vol;
merge data.VolDRG4692008(in=in2008) data.VolDRG4692009(in=in2009) data.VolDRG4692010(in=in2010) 
data.VolDRG4692011(in=in2011) data.VolDRG4692012(in=in2012) data.VolDRG4692013(in=in2013);
if in2008 or in2009 or in2010 or in2011 or in2012 or in2013;

i=substr(provider,3,2) ; 
	if i in ('00','01','02','03','04','05','06','07','08') then type=0; 
	if i in ('13') then type=1; drop i;
run;
proc means data=vol ;
class type;
var vol2008 ;
output out=vol2008 mean=meanvol2008 sum=sumvol2008;
run;

proc means  data=vol ;
class type;
var vol2009 ;
output out=vol2009 mean=meanvol2009 sum=sumvol2009;
run;
proc means   data=vol;
class type;
var vol2010 ;
output out=vol2010 mean=meanvol2010 sum=sumvol2010;
run;
proc means  data=vol ;
class type;
var vol2011;
output out=vol2011 mean=meanvol2011 sum=sumvol2011;
run;
proc means  data=vol ;
class type;
var vol2012 ;
output out=vol2012 mean=meanvol2012 sum=sumvol2012;
run;
proc means  data=vol ;
class type;
var vol2013 ;
output out=vol2013 mean=meanvol2013 sum=sumvol2013;
run;

proc sort data=vol2008;by type;run;
proc sort data=vol2009;by type;run;
proc sort data=vol2010;by type;run;
proc sort data=vol2011;by type;run;
proc sort data=vol2012;by type;run;
proc sort data=vol2013;by type;run;

data Vol;
merge vol2008 vol2009 vol2010 vol2011 vol2012 vol2013;
by type;
where type ne .;
keep type meanvol2008 meanvol2009 meanvol2010 meanvol2011 meanvol2012 meanvol2013 
Sumvol2008 Sumvol2009 Sumvol2010 Sumvol2011 Sumvol2012 Sumvol2013 ;
proc print;var type meanvol2008 meanvol2009 meanvol2010 meanvol2011 meanvol2012 meanvol2013 Sumvol2008 Sumvol2009 Sumvol2010 Sumvol2011 Sumvol2012 Sumvol2013 ;
run;


 *Raw Mortality ;

proc sort data=data.MortDRG469302008;by provider;run;
proc sort data=data.MortDRG469302009;by provider;run;
proc sort data=data.MortDRG469302010;by provider;run;
proc sort data=data.MortDRG469302011;by provider;run;
proc sort data=data.MortDRG469302012;by provider;run;
proc sort data=data.MortDRG469302013;by provider;run;

data Mort;
merge data.MortDRG469302008(in=in2008) data.MortDRG469302009(in=in2009) data.MortDRG469302010(in=in2010) 
data.MOrtDRG469302011(in=in2011) data.MortDRG469302012(in=in2012) data.MortDRG469302013(in=in2013);
if in2008 or in2009 or in2010 or in2011 or in2012 or in2013;

i=substr(provider,3,2) ; 
	if i in ('00','01','02','03','04','05','06','07','08') then type=0; 
	if i in ('13') then type=1; drop i;
run;
proc means data=Mort ;
class type;
var Rawmort302010 ;
output out=mort2008 mean=meanmort2008  ;
run;

proc means  data=Mort ;
class type;
var RawMort302009 ;
output out=Mort2009 mean=meanMort2009 ;
run;
proc means   data=Mort;
class type;
var RawMort302010 ;
output out=Mort2010 mean=meanMort2010 ;
run;
proc means  data=Mort ;
class type;
var RawMort302011;
output out=Mort2011 mean=meanMort2011 ;
run;
proc means  data=Mort ;
class type;
var RawMort302012 ;
output out=Mort2012 mean=meanMort2012  ;
run;
proc means  data=Mort ;
class type;
var RawMort302013 ;
output out=Mort2013 mean=meanMort2013  ;
run;

proc sort data=Mort2008;by type;run;
proc sort data=Mort2009;by type;run;
proc sort data=Mort2010;by type;run;
proc sort data=Mort2011;by type;run;
proc sort data=Mort2012;by type;run;
proc sort data=Mort2013;by type;run;

data Mort;
merge Mort2008 Mort2009 Mort2010 Mort2011 Mort2012 Mort2013;
by type;
where type ne .;
keep type meanMort2008 meanMort2009 meanMort2010 meanMort2011 meanMort2012 meanMort2013  ;
proc print;
var type meanMort2008 meanMort2009 meanMort2010 meanMort2011 meanMort2012 meanMort2013  ;
run;



*Adjusted Mortality ;

proc sort data=data.MortDRG469302008;by provider;run;
proc sort data=data.MortDRG469302009;by provider;run;
proc sort data=data.MortDRG469302010;by provider;run;
proc sort data=data.MortDRG469302011;by provider;run;
proc sort data=data.MortDRG469302012;by provider;run;
proc sort data=data.MortDRG469302013;by provider;run;

data Mort;
merge data.MortDRG469302008(in=in2008) data.MortDRG469302009(in=in2009) data.MortDRG469302010(in=in2010) 
data.MOrtDRG469302011(in=in2011) data.MortDRG469302012(in=in2012) data.MortDRG469302013(in=in2013);
if in2008 or in2009 or in2010 or in2011 or in2012 or in2013;

i=substr(provider,3,2) ; 
	if i in ('00','01','02','03','04','05','06','07','08') then type=0; 
	if i in ('13') then type=1; drop i;
run;
proc means data=Mort ;
class type;
var Adjmort302010 ;
output out=mort2008 mean=meanmort2008  ;
run;

proc means  data=Mort ;
class type;
var AdjMort302009 ;
output out=Mort2009 mean=meanMort2009 ;
run;
proc means   data=Mort;
class type;
var AdjMort302010 ;
output out=Mort2010 mean=meanMort2010 ;
run;
proc means  data=Mort ;
class type;
var AdjMort302011;
output out=Mort2011 mean=meanMort2011 ;
run;
proc means  data=Mort ;
class type;
var AdjMort302012 ;
output out=Mort2012 mean=meanMort2012  ;
run;
proc means  data=Mort ;
class type;
var AdjMort302013 ;
output out=Mort2013 mean=meanMort2013  ;
run;

proc sort data=Mort2008;by type;run;
proc sort data=Mort2009;by type;run;
proc sort data=Mort2010;by type;run;
proc sort data=Mort2011;by type;run;
proc sort data=Mort2012;by type;run;
proc sort data=Mort2013;by type;run;

data Mort;
merge Mort2008 Mort2009 Mort2010 Mort2011 Mort2012 Mort2013;
by type;
where type ne .;
keep type meanMort2008 meanMort2009 meanMort2010 meanMort2011 meanMort2012 meanMort2013  ;
proc print;
var type meanMort2008 meanMort2009 meanMort2010 meanMort2011 meanMort2012 meanMort2013  ;
run;




*Raw Readmission ;

proc sort data=data.ReadmDRG469302008;by provider;run;
proc sort data=data.ReadmDRG469302009;by provider;run;
proc sort data=data.ReadmDRG469302010;by provider;run;
proc sort data=data.ReadmDRG469302011;by provider;run;
proc sort data=data.ReadmDRG469302012;by provider;run;
proc sort data=data.ReadmDRG469302013;by provider;run;

data Readm;
merge data.ReadmDRG469302008(in=in2008) data.ReadmDRG469302009(in=in2009) data.ReadmDRG469302010(in=in2010) 
data.ReadmDRG469302011(in=in2011) data.ReadmDRG469302012(in=in2012) data.ReadmDRG469302013(in=in2013);
if in2008 or in2009 or in2010 or in2011 or in2012 or in2013;

i=substr(provider,3,2) ; 
	if i in ('00','01','02','03','04','05','06','07','08') then type=0; 
	if i in ('13') then type=1; drop i;
run;
proc means data=Readm ;
class type;
var RawReadm302010 ;
output out=Readm2008 mean=meanReadm2008  ;
run;

proc means  data=Readm ;
class type;
var RawReadm302009 ;
output out=Readm2009 mean=meanReadm2009 ;
run;
proc means   data=Readm;
class type;
var RawReadm302010 ;
output out=Readm2010 mean=meanReadm2010 ;
run;
proc means  data=Readm ;
class type;
var RawReadm302011;
output out=Readm2011 mean=meanReadm2011 ;
run;
proc means  data=Readm;
class type;
var RawReadm302012 ;
output out=Readm2012 mean=meanReadm2012  ;
run;
proc means  data=Readm ;
class type;
var RawReadm302013 ;
output out=Readm2013 mean=meanReadm2013  ;
run;

proc sort data=Readm2008;by type;run;
proc sort data=Readm2009;by type;run;
proc sort data=Readm2010;by type;run;
proc sort data=Readm2011;by type;run;
proc sort data=Readm2012;by type;run;
proc sort data=Readm2013;by type;run;

data Readm;
merge Readm2008 Readm2009 Readm2010 Readm2011 Readm2012 Readm2013;
by type;
where type ne .;
keep type meanReadm2008 meanReadm2009 meanReadm2010 meanReadm2011 meanReadm2012 meanReadm2013  ;
proc print;
var type meanReadm2008 meanReadm2009 meanReadm2010 meanReadm2011 meanReadm2012 meanReadm2013  ;
run;



*Adjusted Mortality ;

proc sort data=data.ReadmDRG469302008;by provider;run;
proc sort data=data.ReadmDRG469302009;by provider;run;
proc sort data=data.ReadmDRG469302010;by provider;run;
proc sort data=data.ReadmDRG469302011;by provider;run;
proc sort data=data.ReadmDRG469302012;by provider;run;
proc sort data=data.ReadmDRG469302013;by provider;run;

data Readm;
merge data.ReadmDRG469302008(in=in2008) data.ReadmDRG469302009(in=in2009) data.ReadmDRG469302010(in=in2010) 
data.ReadmDRG469302011(in=in2011) data.ReadmDRG469302012(in=in2012) data.ReadmDRG469302013(in=in2013);
if in2008 or in2009 or in2010 or in2011 or in2012 or in2013;

i=substr(provider,3,2) ; 
	if i in ('00','01','02','03','04','05','06','07','08') then type=0; 
	if i in ('13') then type=1; drop i;
run;
proc means data=Readm;
class type;
var AdjReadm302010 ;
output out=Readm2008 mean=meanReadm2008  ;
run;

proc means  data=Readm ;
class type;
var AdjReadm302009 ;
output out=Readm2009 mean=meanReadm2009 ;
run;
proc means   data=Readm;
class type;
var AdjReadm302010 ;
output out=Readm2010 mean=meanReadm2010 ;
run;
proc means  data=Readm ;
class type;
var AdjReadm302011;
output out=Readm2011 mean=meanReadm2011 ;
run;
proc means  data=Readm ;
class type;
var AdjReadm302012 ;
output out=Readm2012 mean=meanReadm2012  ;
run;
proc means  data=Readm ;
class type;
var AdjReadm302013 ;
output out=Readm2013 mean=meanReadm2013  ;
run;

proc sort data=Readm2008;by type;run;
proc sort data=Readm2009;by type;run;
proc sort data=Readm2010;by type;run;
proc sort data=Readm2011;by type;run;
proc sort data=Readm2012;by type;run;
proc sort data=Readm2013;by type;run;

data Readm;
merge Readm2008 Readm2009 Readm2010 Readm2011 Readm2012 Readm2013;
by type;
where type ne .;
keep type meanReadm2008 meanReadm2009 meanReadm2010 meanReadm2011 meanReadm2012 meanReadm2013  ;
proc print;
var type meanReadm2008 meanReadm2009 meanReadm2010 meanReadm2011 meanReadm2012 meanReadm2013  ;
run;
