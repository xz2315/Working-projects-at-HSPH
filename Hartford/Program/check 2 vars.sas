libname data 'C:\data\Projects\Hartford\Data';
libname HIT "C:\data\Data\Hospital\AHA\HIT\data";
  


proc import datafile="C:\data\Data\Hospital\AHA\HIT\Data\origdata\2013 IT DATA" dbms=xls out=HIT13 replace;
getnames=yes;
run;

%let yr=2013;

data hit&yr.;
set hit13;

keep id respond&yr. 
Q3Aa2_&yr. Q3Ab2_&yr. Q3Ac2_&yr. Q3Ad2_&yr. Q3Ae2_&yr. Q3Af2_&yr. Q3Ag2_&yr. 
Q3Aa4_&yr. Q3Ab4_&yr. Q3Ac4_&yr. Q3Ad4_&yr. Q3Ae4_&yr. Q3Af4_&yr. Q3Ag4_&yr. ;
a1_&yr.=q1a1*1;
if a1_&yr. ne . then respond&yr. =1;
if respond&yr. =1;
 

Q3Aa2_&yr.=Q3A_A_With_Hospitals_Outside_Of*1;
Q3Ab2_&yr.=Q3A_B_With_Hospitals_Outside_Of*1;
Q3Ac2_&yr.=Q3A_C_With_Hospitals_Outside_Of*1;
Q3Ad2_&yr.=Q3A_D_With_Hospitals_Outside_Of*1;
Q3Ae2_&yr.=Q3A_E_With_Hospitals_Outside_Of*1;
Q3Af2_&yr.=Q3A_F_With_Hospitals_Outside_Of*1;
Q3Ag2_&yr.=Q3A_G_With_Hospitals_Outside_Of*1;

Q3Aa4_&yr.=Q3A_A_With_Ambulatory_Providers1*1; 
Q3Ab4_&yr.=Q3A_B_With_Ambulatory_Providers1*1;
Q3Ac4_&yr.=Q3A_C_With_Ambulatory_Providers1*1;
Q3Ad4_&yr.=Q3A_D_With_Ambulatory_Providers1*1;
Q3Ae4_&yr.=Q3A_E_With_Ambulatory_Providers1*1;
Q3Af4_&yr.=Q3A_F_With_Ambulatory_Providers1*1;
Q3Ag4_&yr.=Q3A_G_With_Ambulatory_Providers1*1;

label Q3Aa2_&yr.="Health information exchange with Hospitals oustide system:Patient demographics &yr.";
label Q3Ab2_&yr.="Health information exchange with Hospitals oustide system:Laboratory results &yr.";
label Q3Ac2_&yr.="Health information exchange with Hospitals oustide system:Medication history &yr.";
label Q3Ad2_&yr.="Health information exchange with Hospitals oustide system:Radiology reports &yr.";
label Q3Ae2_&yr.="Health information exchange with Hospitals oustide system:Clinical/Summary care record &yr.";
label Q3Af2_&yr.="Health information exchange with Hospitals oustide system:Other types of patient data &yr.";
label Q3Ag2_&yr.="Health information exchange with Hospitals oustide system:We do not exchange any patient data &yr.";
 
label Q3Aa4_&yr.="Health information exchange with Ambulatory Providers oustide system:Patient demographics &yr.";
label Q3Ab4_&yr.="Health information exchange with Ambulatory providers oustide system:Laboratory results &yr.";
label Q3Ac4_&yr.="Health information exchange with Ambulatory providers oustide system:Medication history &yr.";
label Q3Ad4_&yr.="Health information exchange with Ambulatory providers oustide system:Radiology reports &yr.";
label Q3Ae4_&yr.="Health information exchange with Ambulatory providers oustide system:Clinical/Summary care record &yr.";
label Q3Af4_&yr.="Health information exchange with Hospitals oustide system:Other types of patient data &yr.";
 label Q3Ag4_&yr.="Health information exchange with Hospitals oustide system:We do not exchange any patient data &yr.";
  proc sort;by id;
run;












 
%let yr=2012;

data hit&yr.;
set hit.hit1112;

keep id respond&yr. 
Q3Aa2_&yr. Q3Ab2_&yr. Q3Ac2_&yr. Q3Ad2_&yr. Q3Ae2_&yr. Q3Af2_&yr. Q3Ag2_&yr. 
Q3Aa4_&yr. Q3Ab4_&yr. Q3Ac4_&yr. Q3Ad4_&yr. Q3Ae4_&yr. Q3Af4_&yr. Q3Ag4_&yr. ;
 
a1_&yr.=q1a1*1; 
 

Q3Aa2_&yr.=Q3A_A_With_hospital_outside_of_y*1;
Q3Ab2_&yr.=Q3A_B_With_hospital_outside_of_y*1;
Q3Ac2_&yr.=Q3A_C_With_hospital_outside_of_y*1;
Q3Ad2_&yr.=Q3A_D_With_hospital_outside_of_y*1;
Q3Ae2_&yr.=Q3A_E_With_hospital_outside_of_y*1;
Q3Af2_&yr.=Q3A_F_With_hospital_outside_of_y*1;
Q3Ag2_&yr.=Q3A_G_With_hospital_outside_of_y*1;
 
Q3Aa4_&yr.=Q3A_A_With_Ambulatory_Providers1*1; 
Q3Ab4_&yr.=Q3A_B_With_Ambulatory_Providers1*1;
Q3Ac4_&yr.=Q3A_C_With_Ambulatory_Providers1*1;
Q3Ad4_&yr.=Q3A_D_With_Ambulatory_Providers1*1;
Q3Ae4_&yr.=Q3A_E_With_Ambulatory_Providers1*1;
Q3Af4_&yr.=Q3A_F_With_Ambulatory_Providers1*1;
Q3Ag4_&yr.=Q3A_G_With_Ambulatory_Providers1*1;
  
label Q3Aa2_&yr.="Health information exchange with Hospitals oustide system:Patient demographics &yr.";
label Q3Ab2_&yr.="Health information exchange with Hospitals oustide system:Laboratory results &yr.";
label Q3Ac2_&yr.="Health information exchange with Hospitals oustide system:Medication history &yr.";
label Q3Ad2_&yr.="Health information exchange with Hospitals oustide system:Radiology reports &yr.";
label Q3Ae2_&yr.="Health information exchange with Hospitals oustide system:Clinical/Summary care record &yr.";
 label Q3Af2_&yr.="Health information exchange with Hospitals oustide system:Other types of patient data &yr.";
label Q3Ag2_&yr.="Health information exchange with Hospitals oustide system:We do not exchange any patient data &yr.";
 
label Q3Aa4_&yr.="Health information exchange with Ambulatory Providers oustide system:Patient demographics &yr.";
label Q3Ab4_&yr.="Health information exchange with Ambulatory providers oustide system:Laboratory results &yr.";
label Q3Ac4_&yr.="Health information exchange with Ambulatory providers oustide system:Medication history &yr.";
label Q3Ad4_&yr.="Health information exchange with Ambulatory providers oustide system:Radiology reports &yr.";
label Q3Ae4_&yr.="Health information exchange with Ambulatory providers oustide system:Clinical/Summary care record &yr.";
 label Q3Af4_&yr.="Health information exchange with Hospitals oustide system:Other types of patient data &yr.";
 label Q3Ag4_&yr.="Health information exchange with Hospitals oustide system:We do not exchange any patient data &yr.";

if a1_&yr. ne . then respond&yr. =1;
if respond&yr. =1;
  proc sort;by id;
run;








%let yr=2011;

data hit&yr.;
set data.hit10(keep=id q1_a1 q1_b1 q1_c1 q1_d1 q1_e1 q1_f1 q1_a2 q1_b2 q1_d2 q1_c3
q1_g1 q1_c2 q1_e2 q1_f2 q1_a3 q1_b3 q1_d3 q1_e3 q1_a4 q1_b4 q1_c4 q1_d4 q1_e4 q1_f4
Q13
q4a_whis q4d_whis q4e_whis q4f_whis q4b_whis
q4a_whos q4d_whos q4e_whos q4f_whos q4b_whos
q4a_wapis q4d_wapis q4e_wapis q4f_wapis q4b_wapis
q4a_wapos q4d_wapos q4e_wapos q4f_wapos q4b_wapos
q_3a
);

keep id respond&yr. 
Q3Aa2_&yr. Q3Ab2_&yr. Q3Ac2_&yr. Q3Ad2_&yr. Q3Ae2_&yr. Q3Af2_&yr. Q3Ag2_&yr. 
Q3Aa4_&yr. Q3Ab4_&yr. Q3Ac4_&yr. Q3Ad4_&yr. Q3Ae4_&yr. Q3Af4_&yr. Q3Ag4_&yr. ;

 
a1_&yr.=q1_a1*1; 

Q3Aa2_&yr.=q4a_whos*1;
Q3Ab2_&yr.=q4d_whos*1;
Q3Ac2_&yr.=q4e_whos*1;
Q3Ad2_&yr.=q4f_whos*1;
Q3Ae2_&yr.=q4b_whos*1;
Q3Af2_&yr.=q4f_whos*1;
Q3Ag2_&yr.=q4g_whos*1;
 

Q3Aa4_&yr.=q4a_wapos*1; 
Q3Ab4_&yr.=q4d_wapos*1;
Q3Ac4_&yr.=q4e_wapos*1;
Q3Ad4_&yr.=q4f_wapos*1;
Q3Ae4_&yr.=q4b_wapos*1;
Q3Af4_&yr.=q4f_wapos*1;
Q3Ag4_&yr.=q4g_wapos*1;

label Q3Aa2_&yr.="Health information exchange with Hospitals oustide system:Patient demographics &yr.";
label Q3Ab2_&yr.="Health information exchange with Hospitals oustide system:Laboratory results &yr.";
label Q3Ac2_&yr.="Health information exchange with Hospitals oustide system:Medication history &yr.";
label Q3Ad2_&yr.="Health information exchange with Hospitals oustide system:Radiology reports &yr.";
label Q3Ae2_&yr.="Health information exchange with Hospitals oustide system:Clinical/Summary care record &yr.";
  label Q3Af2_&yr.="Health information exchange with Hospitals oustide system:Other types of patient data &yr.";
label Q3Ag2_&yr.="Health information exchange with Hospitals oustide system:We do not exchange any patient data &yr.";
 
label Q3Aa4_&yr.="Health information exchange with Ambulatory Providers oustide system:Patient demographics &yr.";
label Q3Ab4_&yr.="Health information exchange with Ambulatory providers oustide system:Laboratory results &yr.";
label Q3Ac4_&yr.="Health information exchange with Ambulatory providers oustide system:Medication history &yr.";
label Q3Ad4_&yr.="Health information exchange with Ambulatory providers oustide system:Radiology reports &yr.";
label Q3Ae4_&yr.="Health information exchange with Ambulatory providers oustide system:Clinical/Summary care record &yr.";
 label Q3Af4_&yr.="Health information exchange with Hospitals oustide system:Other types of patient data &yr.";
 label Q3Ag4_&yr.="Health information exchange with Hospitals oustide system:We do not exchange any patient data &yr."; 

 if a1_&yr. ne . then respond&yr. =1;
if respond&yr. =1;
 proc sort;by id;
run;





%let yr=2010;

data hit&yr.;
set hit.hit09;

keep id respond&yr. 
Q3Aa2_&yr. Q3Ab2_&yr. Q3Ac2_&yr. Q3Ad2_&yr. Q3Ae2_&yr. Q3Af2_&yr. Q3Ag2_&yr. 
Q3Aa4_&yr. Q3Ab4_&yr. Q3Ac4_&yr. Q3Ad4_&yr. Q3Ae4_&yr. Q3Af4_&yr. Q3Ag4_&yr. ;
 
a1_&yr.=q1a1*1; 
Q3Aa2_&yr.=q4a_2*1;
Q3Ab2_&yr.=q4c_2*1;
Q3Ac2_&yr.=q4d_2*1;
Q3Ad2_&yr.=q4e_2*1;
Q3Ae2_&yr.=q4b_2*1;
 

Q3Aa4_&yr.=q4a_4*1; 
Q3Ab4_&yr.=q4c_4*1;
Q3Ac4_&yr.=q4d_4*1;
Q3Ad4_&yr.=q4e_4*1;
Q3Ae4_&yr.=q4b_4*1;
 
  
label Q3Aa2_&yr.="Health information exchange with Hospitals oustide system:Patient demographics &yr.";
label Q3Ab2_&yr.="Health information exchange with Hospitals oustide system:Laboratory results &yr.";
label Q3Ac2_&yr.="Health information exchange with Hospitals oustide system:Medication history &yr.";
label Q3Ad2_&yr.="Health information exchange with Hospitals oustide system:Radiology reports &yr.";
label Q3Ae2_&yr.="Health information exchange with Hospitals oustide system:Clinical/Summary care record &yr.";
 
 
label Q3Aa4_&yr.="Health information exchange with Ambulatory Providers oustide system:Patient demographics &yr.";
label Q3Ab4_&yr.="Health information exchange with Ambulatory providers oustide system:Laboratory results &yr.";
label Q3Ac4_&yr.="Health information exchange with Ambulatory providers oustide system:Medication history &yr.";
label Q3Ad4_&yr.="Health information exchange with Ambulatory providers oustide system:Radiology reports &yr.";
label Q3Ae4_&yr.="Health information exchange with Ambulatory providers oustide system:Clinical/Summary care record &yr.";

 
 if a1_&yr. ne . then respond&yr. =1;
if respond&yr. =1;
 proc sort;by id;
 
run;





%let yr=2009;

data hit&yr.;
set hit.hit08;

keep id respond&yr. 
Q3Aa2_&yr. Q3Ab2_&yr. Q3Ac2_&yr. Q3Ad2_&yr. Q3Ae2_&yr. Q3Af2_&yr. Q3Ag2_&yr. 
Q3Aa4_&yr. Q3Ab4_&yr. Q3Ac4_&yr. Q3Ad4_&yr. Q3Ae4_&yr. Q3Af4_&yr. Q3Ag4_&yr. ;
 
a1_&yr.=q1_a1*1; 
 

Q3Aa2_&yr.=q5a_2*1;
Q3Ab2_&yr.=q5c_2*1;
Q3Ac2_&yr.=q5d_2*1;
Q3Ad2_&yr.=q5e_2*1;
Q3Ae2_&yr.=q5b_2*1;

Q3Aa4_&yr.=q5a_3*1; 
Q3Ab4_&yr.=q5c_3*1;
Q3Ac4_&yr.=q5d_3*1;
Q3Ad4_&yr.=q5e_3*1;
Q3Ae4_&yr.=q5b_3*1;
 

label Q3Aa2_&yr.="Health information exchange with Hospitals oustide system:Patient demographics &yr. ";
label Q3Ab2_&yr.="Health information exchange with Hospitals oustide system:Laboratory results &yr. ";
label Q3Ac2_&yr.="Health information exchange with Hospitals oustide system:Medication history &yr. ";
label Q3Ad2_&yr.="Health information exchange with Hospitals oustide system:Radiology reports &yr. ";
label Q3Ae2_&yr.="Health information exchange with Hospitals oustide system:Clinical/Summary care record &yr. ";

label Q3Aa4_&yr.="Health information exchange with Ambulatory Providers oustide system:Patient demographics &yr. ";
label Q3Ab4_&yr.="Health information exchange with Ambulatory providers oustide system:Laboratory results &yr. ";
label Q3Ac4_&yr.="Health information exchange with Ambulatory providers oustide system:Medication history &yr. ";
label Q3Ad4_&yr.="Health information exchange with Ambulatory providers oustide system:Radiology reports &yr. ";
label Q3Ae4_&yr.="Health information exchange with Ambulatory providers oustide system:Clinical/Summary care record &yr. ";

 
if a1_&yr. ne . then respond&yr. =1;
if respond&yr. =1;
  proc sort;by id;
run;






%let yr=2008;

data hit&yr.;
set hit.hit07;

keep id respond&yr. 
Q3Aa2_&yr. Q3Ab2_&yr. Q3Ac2_&yr. Q3Ad2_&yr. Q3Ae2_&yr. Q3Af2_&yr. Q3Ag2_&yr. 
Q3Aa4_&yr. Q3Ab4_&yr. Q3Ac4_&yr. Q3Ad4_&yr. Q3Ae4_&yr. Q3Af4_&yr. Q3Ag4_&yr. ;
 
a1_&yr.=q1a1*1;  

Q3Aa2_&yr.=q10a_2*1;
Q3Ab2_&yr.=q10c_2*1;
Q3Ac2_&yr.=q10d_2*1;
Q3Ad2_&yr.=q10e_2*1;
Q3Ae2_&yr.=q10b_2*1;

Q3Aa4_&yr.=q10a_3*1; 
Q3Ab4_&yr.=q10c_3*1;
Q3Ac4_&yr.=q10d_3*1;
Q3Ad4_&yr.=q10e_3*1;
Q3Ae4_&yr.=q10b_3*1;
  

label Q3Aa2_&yr.="Health information exchange with Hospitals oustide system:Patient demographics &yr.";
label Q3Ab2_&yr.="Health information exchange with Hospitals oustide system:Laboratory results &yr.";
label Q3Ac2_&yr.="Health information exchange with Hospitals oustide system:Medication history &yr.";
label Q3Ad2_&yr.="Health information exchange with Hospitals oustide system:Radiology reports &yr.";
label Q3Ae2_&yr.="Health information exchange with Hospitals oustide system:Clinical/Summary care record &yr.";

label Q3Aa4_&yr.="Health information exchange with Ambulatory Providers oustide system:Patient demographics &yr.";
label Q3Ab4_&yr.="Health information exchange with Ambulatory providers oustide system:Laboratory results &yr.";
label Q3Ac4_&yr.="Health information exchange with Ambulatory providers oustide system:Medication history &yr.";
label Q3Ad4_&yr.="Health information exchange with Ambulatory providers oustide system:Radiology reports &yr.";
label Q3Ae4_&yr.="Health information exchange with Ambulatory providers oustide system:Clinical/Summary care record &yr.";

 
 if a1_&yr. ne . then respond&yr. =1;
if respond&yr. =1;
 proc sort;by id;
run;




data all;
merge HIT2008(in=in2008) HIT2009(in=in2009) HIT2010(in=in2010) HIT2011(in=in2011) HIT2012(in=in2012) HIT2013(in=in2013);
by id;
if in2008=1 or in2009=1 or in2010=1 or in2011=1 or in2012=1 or in2013=1;
proc print label ;
run;
