libname aha "C:\data\Data\Hospital\AHA";

proc import datafile='C:\data\Projects\Minority_Readmissions\Data\Single CMO Contact List - 7.24.13.xlsx'
            out=mshin dbms=xlsx replace;
  sheet='Single contact list';
  datarow=2;
  getnames=yes ;
run;

proc freq data=mshin;
  tables hospital_Phone;
run;

data aha11;
  length phone $ 10.;
  set aha.aha11;
  phone=area||telno;
  if phone ne ' ';
run;

data msh;
  length phone $ 10.;
  set mshin;
  phone=compress(Hospital_Phone,'-');
run;

proc sort data=aha11 nodupkey;
  by phone;
proc sort data=msh;
  by phone;
data mshids11 nonmatches11;
  length ahahospaddress $ 50;
  length ahahospcontact $ 150;
  merge aha11(in=in1 keep=mcrnum id phone mname mlocaddr madmin mloccity mstate
              rename=(mname=ahahospname mlocaddr=ahahospaddress madmin=ahahospcontact mloccity=ahacity
                      mstate=ahastate))
        msh(in=in2);
  by phone;
  *inaha=in1;
  *inmsh=in2;
  if in1 and in2 then match=1; else match=0;
  if in2;
  if match=1 then output mshids11; else output nonmatches11;
  label ahahospname='Hospital Name from AHA' ahahospaddress='Hospital Address from AHA'
        id='AHA ID' mcrnum='Medicare Number' ahahospcontact='Hospital Contact from AHA'
        ahacity='Hospital City from AHA' ahastate='Hospital State from AHA';
run;
/*1458 matches, 40 non-matches (35 have a missing phone #)*/

data aha10;
  length phone $ 10.;
  set aha.aha10;
  phone=area||telno;
  if phone ne ' ';
run;

proc sort data=aha10 nodupkey;
  by phone;
proc sort data=nonmatches11;
  by phone;
data mshids10 nonmatches10;
  length ahahospaddress $ 50;
  length ahahospcontact $ 150;
  merge nonmatches11(in=in2)
        aha10(in=in1 keep=mcrnum id phone mname mlocaddr madmin mloccity mstate
              rename=(mname=ahahospname mlocaddr=ahahospaddress madmin=ahahospcontact mloccity=ahacity
                      mstate=ahastate));
  by phone;
  *inaha=in1;
  *inmsh=in2;
  if in1 and in2 then match=1; else match=0;
  if in2;
  if match=1 then output mshids10; else output nonmatches10;
  label ahahospname='Hospital Name from AHA' ahahospaddress='Hospital Address from AHA'
        id='AHA ID' mcrnum='Medicare Number' ahahospcontact='Hospital Contact from AHA'
        ahacity='Hospital City from AHA' ahastate='Hospital State from AHA';
run;
*3 matches;

data aha09;
  length phone $ 10.;
  set aha.aha09;
  phone=area||telno;
  if phone ne ' ';
run;

proc sort data=aha09 nodupkey;
  by phone;
proc sort data=nonmatches10;
  by phone;
data mshids09 nonmatches09;
  length ahahospaddress $ 50;
  length ahahospcontact $ 150;
  merge nonmatches10(in=in2)
        aha09(in=in1 keep=mcrnum id phone mname mlocaddr madmin mloccity mstate
              rename=(mname=ahahospname mlocaddr=ahahospaddress madmin=ahahospcontact mloccity=ahacity
                      mstate=ahastate));
  by phone;
  *inaha=in1;
  *inmsh=in2;
  if in1 and in2 then match=1; else match=0;
  if in2;
  if match=1 then output mshids09; else output nonmatches09;
  label ahahospname='Hospital Name from AHA' ahahospaddress='Hospital Address from AHA'
        id='AHA ID' mcrnum='Medicare Number' ahahospcontact='Hospital Contact from AHA'
        ahacity='Hospital City from AHA' ahastate='Hospital State from AHA';
run;

data aha07;
  length phone $ 10.;
  set aha.aha07;
  phone=area||telno;
  if phone ne ' ';
run;

proc sort data=aha07 nodupkey;
  by phone;
proc sort data=nonmatches09;
  by phone;
data mshids07 nonmatches07;
  length ahahospaddress $ 50;
  length ahahospcontact $ 150;
  merge nonmatches09(in=in2)
        aha07(in=in1 keep=mcrnum id phone mname mlocaddr madmin mloccity mstate
              rename=(mname=ahahospname mlocaddr=ahahospaddress madmin=ahahospcontact mloccity=ahacity
                      mstate=ahastate));
  by phone;
  *inaha=in1;
  *inmsh=in2;
  if in1 and in2 then match=1; else match=0;
  if in2;
  if match=1 then output mshids07; else output nonmatches07;
  label ahahospname='Hospital Name from AHA' ahahospaddress='Hospital Address from AHA'
        id='AHA ID' mcrnum='Medicare Number' ahahospcontact='Hospital Contact from AHA'
        ahacity='Hospital City from AHA' ahastate='Hospital State from AHA';
run;

data missingphone;
  set nonmatches07;
  matchname=substr(propcase(name),1,15);
run;

data aha07names;
  set aha07;
  matchname=substr(propcase(mname),1,15);
run;

proc sort data=missingphone;
  by matchname;
proc sort data=aha07names;
  by matchname;
data missings;
  length ahahospaddress $ 50;
  length ahahospcontact $ 150;
  merge missingphone(in=in2)
        aha07names(in=in1 keep=matchname mcrnum id phone mname mlocaddr madmin mloccity mstate
                   rename=(mname=ahahospname mlocaddr=ahahospaddress madmin=ahahospcontact
                   mloccity=ahacity mstate=ahastate));
  by matchname;
  if in1 and in2 then match=1; else match=0;
  if in2;
  if match=1;
  if ahastate=state;
  if ahacity=city;
  label ahahospname='Hospital Name from AHA' ahahospaddress='Hospital Address from AHA'
        id='AHA ID' mcrnum='Medicare Number' ahahospcontact='Hospital Contact from AHA'
        ahacity='Hospital City from AHA' ahastate='Hospital State from AHA';
  drop match matchname;
run;

data hospids;
  set mshids11 mshids10 mshids09 mshids07 missings;
  drop phone match;
run;

/*
proc export data=hospids outfile="C:\data\Projects\Jha_Requests\Tables\CMOContactListWithIDs.csv" dbms=csv replace;
run;
*/




proc sort data=aha10;
  by mname;
run;

data mello;
  set aha10;
  if mcrnum in ('330194', '330059', '330101', '330024', '330169');
run;

/*
proc export data=mello outfile="C:\data\Projects\Jha_Requests\Tables\AHA105Hosps.csv" dbms=csv replace;
run;
*/
