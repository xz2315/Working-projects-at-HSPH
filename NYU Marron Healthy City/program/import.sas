
****************************
Import External Files
****************************;


* xls Excel Files;

%macro imp_xls(file=,out=);
proc import datafile="&file." dbms=xls out=&out. replace;
getnames=yes;
run;
%mend imp_xls;

%imp_xls(file=C:\data\Projects\Marron\Archive\ua_list_ua.xls,out=UA)
%imp_xls(file=C:\data\Projects\Marron\Archive\zip_code_database.xls,out=zip)
%imp_xls(file=C:\data\Projects\Marron\Archive\CITIES_BY_ZIP.xls,out=citybyzip)

%imp_xls(file=C:\data\Projects\Marron\Archive\City Population.xls,out=citypop)

%imp_xls(file=C:\data\Projects\Marron\Archive\statelist.xls,out=statelist)
%imp_xls(file=C:\data\Projects\Marron\Archive\other primary cities.xls,out=smallcity)

%imp_xls(file=C:\data\Projects\Marron\Archive\territory.xls,out=state50)
 
* txt File;
%macro imp_txt(file=,out=);
proc import datafile="&file."  dbms=dlm out=&out. replace;
delimiter=',';
getnames=yes;
run;
%mend imp_txt;

%imp_txt(file=C:\data\Projects\Marron\Archive\ua_zcta_rel_10.txt,out=ua_zip)
%imp_txt(file=C:\data\Projects\Marron\Archive\ua_county_rel_10.txt,out=ua_county)
%imp_txt(file=C:\data\Projects\Marron\Archive\ua_cousub_rel_10.txt,out=ua_cousub)
%imp_txt(file=C:\data\Projects\Marron\Archive\ua_place_rel_10.txt,out=ua_place)
%imp_txt(file=C:\data\Projects\Marron\Archive\ua_cbsa_rel_10.txt,out=ua_cbsa)
%imp_txt(file=C:\data\Projects\Marron\Archive\zcta_county_rel_10.txt,out=zcta_county)
%imp_txt(file=C:\data\Projects\Marron\Archive\zcta_cousub_rel_10.txt,out=zcta_cousub)
%imp_txt(file=C:\data\Projects\Marron\Archive\zcta_place_rel_10.txt,out=zcta_place)
  
 
* csv file ;

%macro imp_csv(file=,out=);
proc import datafile="&file." dbms=csv out=&out. replace;
getnames=yes;
run;
%mend imp_csv;

%imp_csv(file=C:\data\Data\APCD\Massachusetts\Data\Sample DataSet\ccs.csv,out=apcd.ccs)
