********************
Prepare AHA HIT Suppliment
Xiner Zhou
8/6/2015
********************;
libname data 'C:\data\Projects\Hartford\Data';
libname HIT "C:\data\Data\Hospital\AHA\HIT\data";
  


proc import datafile="C:\data\Data\Hospital\AHA\HIT\Data\origdata\2013 IT DATA" dbms=xls out=HIT13 replace;
getnames=yes;
run;

%let yr=2013;

data hit&yr.;
set hit13;

keep id respond&yr. 
a1_&yr. b1_&yr. c1_&yr. d1_&yr. e1_&yr. f1_&yr. a2_&yr. b2_&yr. d2_&yr. c3_&yr.
g1_&yr. c2_&yr. e2_&yr. f2_&yr. a3_&yr. b3_&yr. d3_&yr. e3_&yr. a4_&yr. b4_&yr. c4_&yr. d4_&yr. e4_&yr. f4_&yr. 
Q12_&yr.
Q3Aa1_&yr. Q3Ab1_&yr. Q3Ac1_&yr. Q3Ad1_&yr. Q3Ae1_&yr. 
Q3Aa2_&yr. Q3Ab2_&yr. Q3Ac2_&yr. Q3Ad2_&yr. Q3Ae2_&yr.
Q3Aa3_&yr. Q3Ab3_&yr. Q3Ac3_&yr. Q3Ad3_&yr. Q3Ae3_&yr.
Q3Aa4_&yr. Q3Ab4_&yr. Q3Ac4_&yr. Q3Ad4_&yr. Q3Ae4_&yr.
Q4b_&yr. 
q18a_&yr. q18b_&yr. q18c_&yr. HIEoutSystem_&yr. PerfMeas_&yr.;



*Adoption of a Basic EHR (focal measure);
a1_&yr.=q1a1*1;b1_&yr.=q1b1*1;c1_&yr.=q1c1*1;d1_&yr.=q1d1*1;e1_&yr.=q1e1*1;f1_&yr.=q1f1*1;
a2_&yr.=q1a2*1;b2_&yr.=q1b2*1;d2_&yr.=q1d2*1;c3_&yr.=q1c3*1;
label a1_&yr.="Adoption of a Basic EHR:Patient Demographics &yr.";
label b1_&yr.="Adoption of a Basic EHR:Physician Notes &yr.";
label c1_&yr.="Adoption of a Basic EHR:Nursing Notes &yr.";
label d1_&yr.="Adoption of a Basic EHR:Problem Lists &yr.";
label e1_&yr.="Adoption of a Basic EHR:Medication Lists &yr.";
label f1_&yr.="Adoption of a Basic EHR:Discharge Summaries &yr.";
label a2_&yr.="Adoption of a Basic EHR:View Laboratory Reports &yr.";
label b2_&yr.="Adoption of a Basic EHR:View Radiology Reports &yr.";
label d2_&yr.="Adoption of a Basic EHR:View Diagnostic Test Results &yr.";
label c3_&yr.="Adoption of a Basic EHR:CPOE Medication &yr.";

*Adoption of a Comprehensive EHR (additional functions beyond basic);
g1_&yr.=q1g1*1;c2_&yr.=q1c2*1;e2_&yr.=q1e2*1;f2_&yr.=q1f2*1;a3_&yr.=q1a3*1;b3_&yr.=q1b3*1;
d3_&yr.=q1d3*1;e3_&yr.=q1e3*1;a4_&yr.=q1a4*1;b4_&yr.=q1b4*1;c4_&yr.=q1c4*1;d4_&yr.=q1d4*1;e4_&yr.=q1e4*1;f4_&yr.=q1f4*1;
label g1_&yr.="Adoption of a Comprehensive EHR:Advanced Directives &yr.";
label c2_&yr.="Adoption of a Comprehensive EHR:View Radiology Images &yr.";
label e2_&yr.="Adoption of a Comprehensive EHR:View Diagnostic Test Images &yr.";
label f2_&yr.="Adoption of a Comprehensive EHR:View Consultant Reports &yr.";
label a3_&yr.="Adoption of a Comprehensive EHR:CPOE Laboratory Tests &yr.";
label b3_&yr.="Adoption of a Comprehensive EHR:CPOE Radiology Tests &yr.";
label d3_&yr.="Adoption of a Comprehensive EHR:CPOE Consultation Requests &yr.";
label e3_&yr.="Adoption of a Comprehensive EHR:CPOE Nursing Orders &yr.";
label a4_&yr.="Adoption of a Comprehensive EHR:DS Clinical Guidelines &yr.";
label b4_&yr.="Adoption of a Comprehensive EHR:DS Clinical Reminders &yr.";
label c4_&yr.="Adoption of a Comprehensive EHR:DS Drug Allergy Alerts &yr.";
label d4_&yr.="Adoption of a Comprehensive EHR:DS Drug-Drug Interaction Alerts &yr.";
label e4_&yr.="Adoption of a Comprehensive EHR:DS Drug-Lab Interaction Alerts &yr.";
label f4_&yr.="Adoption of a Comprehensive EHR:DS Drug Dosing Support &yr.";

*Meaningful use attestation status;
Q12_&yr.=Q12;
label Q12_&yr.="Meaningful use attestation status:Certified EHR for Meaningful Use &yr.";

*Health information exchange with Hospitals inside system;
Q3Aa1_&yr.=Q3A_A_With_Hospitals_In_Your_Sys*1;
Q3Ab1_&yr.=Q3A_B_With_Hospitals_In_Your_Sys*1;
Q3Ac1_&yr.=Q3A_C_With_Hospitals_In_Your_Sys*1;
Q3Ad1_&yr.=Q3A_D_With_Hospitals_In_Your_Sys*1;
Q3Ae1_&yr.=Q3A_E_With_Hospitals_In_Your_Sys*1;

Q3Aa2_&yr.=Q3A_A_With_Hospitals_Outside_Of*1;
Q3Ab2_&yr.=Q3A_B_With_Hospitals_Outside_Of*1;
Q3Ac2_&yr.=Q3A_C_With_Hospitals_Outside_Of*1;
Q3Ad2_&yr.=Q3A_D_With_Hospitals_Outside_Of*1;
Q3Ae2_&yr.=Q3A_E_With_Hospitals_Outside_Of*1;

Q3Aa3_&yr.=Q3A_A_With_Ambulatory_Providers*1;
Q3Ab3_&yr.=Q3A_B_With_Ambulatory_Providers*1;
Q3Ac3_&yr.=Q3A_C_With_Ambulatory_Providers*1;
Q3Ad3_&yr.=Q3A_D_With_Ambulatory_Providers*1;
Q3Ae3_&yr.=Q3A_E_With_Ambulatory_Providers*1;

Q3Aa4_&yr.=Q3A_A_With_Ambulatory_Providers1*1; 
Q3Ab4_&yr.=Q3A_B_With_Ambulatory_Providers1*1;
Q3Ac4_&yr.=Q3A_C_With_Ambulatory_Providers1*1;
Q3Ad4_&yr.=Q3A_D_With_Ambulatory_Providers1*1;
Q3Ae4_&yr.=Q3A_E_With_Ambulatory_Providers1*1;
 
label Q3Aa1_&yr.="Health information exchange with Hospitals inside system:Patient demographics &yr.";
label Q3Ab1_&yr.="Health information exchange with Hospitals inside system:Laboratory results &yr.";
label Q3Ac1_&yr.="Health information exchange with Hospitals inside system:Medication history &yr.";
label Q3Ad1_&yr.="Health information exchange with Hospitals inside system:Radiology reports &yr.";
label Q3Ae1_&yr.="Health information exchange with Hospitals inside system:Clinical/Summary care record &yr.";

label Q3Aa2_&yr.="Health information exchange with Hospitals oustide system:Patient demographics &yr.";
label Q3Ab2_&yr.="Health information exchange with Hospitals oustide system:Laboratory results &yr.";
label Q3Ac2_&yr.="Health information exchange with Hospitals oustide system:Medication history &yr.";
label Q3Ad2_&yr.="Health information exchange with Hospitals oustide system:Radiology reports &yr.";
label Q3Ae2_&yr.="Health information exchange with Hospitals oustide system:Clinical/Summary care record &yr.";

label Q3Aa3_&yr.="Health information exchange with Ambulatory providers inside system:Patient demographics &yr.";
label Q3Ab3_&yr.="Health information exchange with Ambulatory providers inside system:Laboratory results &yr.";
label Q3Ac3_&yr.="Health information exchange with Ambulatory providers inside system:Medication history &yr.";
label Q3Ad3_&yr.="Health information exchange with Ambulatory providers inside system:Radiology reports &yr.";
label Q3Ae3_&yr.="Health information exchange with Ambulatory providers inside system:Clinical/Summary care record &yr.";
 
label Q3Aa4_&yr.="Health information exchange with Ambulatory Providers oustide system:Patient demographics &yr.";
label Q3Ab4_&yr.="Health information exchange with Ambulatory providers oustide system:Laboratory results &yr.";
label Q3Ac4_&yr.="Health information exchange with Ambulatory providers oustide system:Medication history &yr.";
label Q3Ad4_&yr.="Health information exchange with Ambulatory providers oustide system:Radiology reports &yr.";
label Q3Ae4_&yr.="Health information exchange with Ambulatory providers oustide system:Clinical/Summary care record &yr.";

if Q3A_A_With_Hospitals_Outside_Of='1' or Q3A_B_With_Hospitals_Outside_Of='1' or Q3A_C_With_Hospitals_Outside_Of='1' or Q3A_D_With_Hospitals_Outside_Of='1'
or Q3A_E_With_Hospitals_Outside_Of='1' or Q3A_F_With_Hospitals_Outside_Of='1'   
or Q3A_A_With_Ambulatory_Providers1='1' or Q3A_B_With_Ambulatory_Providers1='1' or Q3A_C_With_Ambulatory_Providers1='1' or Q3A_D_With_Ambulatory_Providers1='1'
or Q3A_E_With_Ambulatory_Providers1='1' or Q3A_F_With_Ambulatory_Providers1='1'   
then HIEoutSystem_&yr.=1;else  
HIEoutSystem_&yr.=0;

label HIEoutSystem_&yr.="HIE outside of System";

*Participate in RHIO;
Q4b_&yr.=Q4b;
label Q4b_&yr.="Participate in RHIO:Level of participation in Regional HIO &yr.";


*Use of EHR data for performance measurement;
q18a_&yr.=q18_Create_a_dashboard_with_meas*1;
q18b_&yr.=q18_Create_a_dashboard_with_mea1*1;
q18c_&yr.=q18_Create_individual_provider_p*1;
label q18a_&yr.="Use of EHR data for performance measurement:Create a dashboard with measures of organizational performance &yr.";
label q18b_&yr.="Use of EHR data for performance measurement:Create a dashboard with measures of unit-level performance &yr.";
label q18c_&yr.="Use of EHR data for performance measurement:Create individual provider performance profiles &yr.";

if q18a_&yr.=1 or q18b_&yr.=1 or q18c_&yr.=1 then PerfMeas_&yr.=1;else 
 PerfMeas_&yr.=0;
 
label PerfMeas_&yr.="Use of EHR data for performance measurement";


if a1_&yr. ne . then respond&yr. =1;
if respond&yr. =1;

proc sort;by id;
proc contents order=varnum;
proc freq ;tables HIEoutSystem_&yr. PerfMeas_&yr./missing;
run;










 
%let yr=2012;

data hit&yr.;
set hit.hit1112;

keep id respond&yr. 
a1_&yr. b1_&yr. c1_&yr. d1_&yr. e1_&yr. f1_&yr. a2_&yr. b2_&yr. d2_&yr. c3_&yr.
g1_&yr. c2_&yr. e2_&yr. f2_&yr. a3_&yr. b3_&yr. d3_&yr. e3_&yr. a4_&yr. b4_&yr. c4_&yr. d4_&yr. e4_&yr. f4_&yr. 
Q12_&yr.
Q3Aa1_&yr. Q3Ab1_&yr. Q3Ac1_&yr. Q3Ad1_&yr. Q3Ae1_&yr. 
Q3Aa2_&yr. Q3Ab2_&yr. Q3Ac2_&yr. Q3Ad2_&yr. Q3Ae2_&yr.
Q3Aa3_&yr. Q3Ab3_&yr. Q3Ac3_&yr. Q3Ad3_&yr. Q3Ae3_&yr.
Q3Aa4_&yr. Q3Ab4_&yr. Q3Ac4_&yr. Q3Ad4_&yr. Q3Ae4_&yr.
Q4b_&yr. HIEoutSystem_&yr.;
 

*Adoption of a Basic EHR (focal measure);
a1_&yr.=q1a1*1;b1_&yr.=q1b1*1;c1_&yr.=q1c1*1;d1_&yr.=q1d1*1;e1_&yr.=q1e1*1;f1_&yr.=q1f1*1;
a2_&yr.=q1a2*1;b2_&yr.=q1b2*1;d2_&yr.=q1d2*1;c3_&yr.=q1c3*1;
label a1_&yr.="Adoption of a Basic EHR:Patient Demographics &yr.";
label b1_&yr.="Adoption of a Basic EHR:Physician Notes &yr.";
label c1_&yr.="Adoption of a Basic EHR:Nursing Notes &yr.";
label d1_&yr.="Adoption of a Basic EHR:Problem Lists &yr.";
label e1_&yr.="Adoption of a Basic EHR:Medication Lists &yr.";
label f1_&yr.="Adoption of a Basic EHR:Discharge Summaries &yr.";
label a2_&yr.="Adoption of a Basic EHR:View Laboratory Reports &yr.";
label b2_&yr.="Adoption of a Basic EHR:View Radiology Reports &yr.";
label d2_&yr.="Adoption of a Basic EHR:View Diagnostic Test Results &yr.";
label c3_&yr.="Adoption of a Basic EHR:CPOE Medication &yr.";

*Adoption of a Comprehensive EHR (additional functions beyond basic);
g1_&yr.=q1g1*1;c2_&yr.=q1c2*1;e2_&yr.=q1e2*1;f2_&yr.=q1f2*1;a3_&yr.=q1a3*1;b3_&yr.=q1b3*1;
d3_&yr.=q1d3*1;e3_&yr.=q1e3*1;a4_&yr.=q1a4*1;b4_&yr.=q1b4*1;c4_&yr.=q1c4*1;d4_&yr.=q1d4*1;e4_&yr.=q1e4*1;f4_&yr.=q1f4*1;
label g1_&yr.="Adoption of a Comprehensive EHR:Advanced Directives &yr.";
label c2_&yr.="Adoption of a Comprehensive EHR:View Radiology Images &yr.";
label e2_&yr.="Adoption of a Comprehensive EHR:View Diagnostic Test Images &yr.";
label f2_&yr.="Adoption of a Comprehensive EHR:View Consultant Reports &yr.";
label a3_&yr.="Adoption of a Comprehensive EHR:CPOE Laboratory Tests &yr.";
label b3_&yr.="Adoption of a Comprehensive EHR:CPOE Radiology Tests &yr.";
label d3_&yr.="Adoption of a Comprehensive EHR:CPOE Consultation Requests &yr.";
label e3_&yr.="Adoption of a Comprehensive EHR:CPOE Nursing Orders &yr.";
label a4_&yr.="Adoption of a Comprehensive EHR:DS Clinical Guidelines &yr.";
label b4_&yr.="Adoption of a Comprehensive EHR:DS Clinical Reminders &yr.";
label c4_&yr.="Adoption of a Comprehensive EHR:DS Drug Allergy Alerts &yr.";
label d4_&yr.="Adoption of a Comprehensive EHR:DS Drug-Drug Interaction Alerts &yr.";
label e4_&yr.="Adoption of a Comprehensive EHR:DS Drug-Lab Interaction Alerts &yr.";
label f4_&yr.="Adoption of a Comprehensive EHR:DS Drug Dosing Support &yr.";

*Meaningful use attestation status;
Q12_&yr.=Q12;
label Q12_&yr.="Meaningful use attestation status:Certified EHR for Meaningful Use &yr.";


*Health information exchange with Hospitals inside system;
Q3Aa1_&yr.=Q3A_A_With_Hospital_In_Your_Syst*1;
Q3Ab1_&yr.=Q3A_B_With_Hospital_In_Your_Syst*1;
Q3Ac1_&yr.=Q3A_C_With_Hospital_In_Your_Syst*1;
Q3Ad1_&yr.=Q3A_D_With_Hospital_In_Your_Syst*1;
Q3Ae1_&yr.=Q3A_E_With_Hospital_In_Your_Syst*1;

Q3Aa2_&yr.=Q3A_A_With_hospital_outside_of_y*1;
Q3Ab2_&yr.=Q3A_B_With_hospital_outside_of_y*1;
Q3Ac2_&yr.=Q3A_C_With_hospital_outside_of_y*1;
Q3Ad2_&yr.=Q3A_D_With_hospital_outside_of_y*1;
Q3Ae2_&yr.=Q3A_E_With_hospital_outside_of_y*1;

Q3Aa3_&yr.=Q3A_A_With_Ambulatory_Providers*1;
Q3Ab3_&yr.=Q3A_B_With_Ambulatory_Providers*1;
Q3Ac3_&yr.=Q3A_C_With_Ambulatory_Providers*1;
Q3Ad3_&yr.=Q3A_D_With_Ambulatory_Providers*1;
Q3Ae3_&yr.=Q3A_E_With_Ambulatory_Providers*1;

Q3Aa4_&yr.=Q3A_A_With_Ambulatory_Providers1*1; 
Q3Ab4_&yr.=Q3A_B_With_Ambulatory_Providers1*1;
Q3Ac4_&yr.=Q3A_C_With_Ambulatory_Providers1*1;
Q3Ad4_&yr.=Q3A_D_With_Ambulatory_Providers1*1;
Q3Ae4_&yr.=Q3A_E_With_Ambulatory_Providers1*1;
 
label Q3Aa1_&yr.="Health information exchange with Hospitals inside system:Patient demographics &yr.";
label Q3Ab1_&yr.="Health information exchange with Hospitals inside system:Laboratory results &yr.";
label Q3Ac1_&yr.="Health information exchange with Hospitals inside system:Medication history &yr.";
label Q3Ad1_&yr.="Health information exchange with Hospitals inside system:Radiology reports &yr.";
label Q3Ae1_&yr.="Health information exchange with Hospitals inside system:Clinical/Summary care record &yr.";
label Q3Aa2_&yr.="Health information exchange with Hospitals oustide system:Patient demographics &yr.";
label Q3Ab2_&yr.="Health information exchange with Hospitals oustide system:Laboratory results &yr.";
label Q3Ac2_&yr.="Health information exchange with Hospitals oustide system:Medication history &yr.";
label Q3Ad2_&yr.="Health information exchange with Hospitals oustide system:Radiology reports &yr.";
label Q3Ae2_&yr.="Health information exchange with Hospitals oustide system:Clinical/Summary care record &yr.";

label Q3Aa3_&yr.="Health information exchange with Ambulatory providers inside system:Patient demographics &yr.";
label Q3Ab3_&yr.="Health information exchange with Ambulatory providers inside system:Laboratory results &yr.";
label Q3Ac3_&yr.="Health information exchange with Ambulatory providers inside system:Medication history &yr.";
label Q3Ad3_&yr.="Health information exchange with Ambulatory providers inside system:Radiology reports &yr.";
label Q3Ae3_&yr.="Health information exchange with Ambulatory providers inside system:Clinical/Summary care record &yr.";
 
label Q3Aa4_&yr.="Health information exchange with Ambulatory Providers oustide system:Patient demographics &yr.";
label Q3Ab4_&yr.="Health information exchange with Ambulatory providers oustide system:Laboratory results &yr.";
label Q3Ac4_&yr.="Health information exchange with Ambulatory providers oustide system:Medication history &yr.";
label Q3Ad4_&yr.="Health information exchange with Ambulatory providers oustide system:Radiology reports &yr.";
label Q3Ae4_&yr.="Health information exchange with Ambulatory providers oustide system:Clinical/Summary care record &yr.";

if Q3A_A_With_hospital_outside_of_y='1' or Q3A_B_With_hospital_outside_of_y='1' or Q3A_C_With_hospital_outside_of_y='1' or Q3A_D_With_hospital_outside_of_y='1'
or Q3A_E_With_hospital_outside_of_y='1' or Q3A_F_With_hospital_outside_of_y='1'  
or Q3A_A_With_Ambulatory_Providers1='1' or Q3A_B_With_Ambulatory_Providers1='1' or Q3A_C_With_Ambulatory_Providers1='1' or Q3A_D_With_Ambulatory_Providers1='1'
or Q3A_E_With_Ambulatory_Providers1='1' or Q3A_F_With_Ambulatory_Providers1='1'   
then HIEoutSystem_&yr.=1;else 
HIEoutSystem_&yr.=0;

label HIEoutSystem_&yr.="HIE outside of System";

*Participate in RHIO;
Q4b_&yr.=Q4b;
label Q4b_&yr.="Participate in RHIO:Level of participation in Regional HIO &yr.";

/*
*Use of EHR data for performance measurement;
q18a_&yr.=q18_Create_a_dashboard_with_meas;
q18b_&yr.=q18_Create_a_dashboard_with_mea0;
q18c_&yr.=q18_Create_individual_provider_p;
label q18a_&yr.='Use of EHR data for performance measurement:Create a dashboard with measures of organizational performance';
label q18b_&yr.='Use of EHR data for performance measurement:Create a dashboard with measures of unit-level performance';
label q18c_&yr.='Use of EHR data for performance measurement:Create individual provider performance profiles';

if q18a_&yr.=1 or q18b_&yr.=1 or q18c_&yr.=1 then PerfMeas_&yr.=1;else PerfMeas_&yr.=0;
label PerfMeas_&yr.="Use of EHR data for performance measurement";
*/

if a1_&yr. ne . then respond&yr. =1;
if respond&yr. =1;
proc sort;by id;
proc contents order=varnum;
proc freq ;tables HIEoutSystem_&yr./missing;
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
a1_&yr. b1_&yr. c1_&yr. d1_&yr. e1_&yr. f1_&yr. a2_&yr. b2_&yr. d2_&yr. c3_&yr.
g1_&yr. c2_&yr. e2_&yr. f2_&yr. a3_&yr. b3_&yr. d3_&yr. e3_&yr. a4_&yr. b4_&yr. c4_&yr. d4_&yr. e4_&yr. f4_&yr. 
Q12_&yr.
Q3Aa1_&yr. Q3Ab1_&yr. Q3Ac1_&yr. Q3Ad1_&yr. Q3Ae1_&yr. 
Q3Aa2_&yr. Q3Ab2_&yr. Q3Ac2_&yr. Q3Ad2_&yr. Q3Ae2_&yr.
Q3Aa3_&yr. Q3Ab3_&yr. Q3Ac3_&yr. Q3Ad3_&yr. Q3Ae3_&yr.
Q3Aa4_&yr. Q3Ab4_&yr. Q3Ac4_&yr. Q3Ad4_&yr. Q3Ae4_&yr.
Q4b_&yr. HIEoutSystem_&yr.;


*Adoption of a Basic EHR (focal measure);
a1_&yr.=q1_a1*1;b1_&yr.=q1_b1*1;c1_&yr.=q1_c1*1;d1_&yr.=q1_d1*1;e1_&yr.=q1_e1*1;f1_&yr.=q1_f1*1;
a2_&yr.=q1_a2*1;b2_&yr.=q1_b2*1;d2_&yr.=q1_d2*1;c3_&yr.=q1_c3*1;
label a1_&yr.="Adoption of a Basic EHR:Patient Demographics &yr.";
label b1_&yr.="Adoption of a Basic EHR:Physician Notes &yr.";
label c1_&yr.="Adoption of a Basic EHR:Nursing Notes &yr.";
label d1_&yr.="Adoption of a Basic EHR:Problem Lists &yr.";
label e1_&yr.="Adoption of a Basic EHR:Medication Lists &yr.";
label f1_&yr.="Adoption of a Basic EHR:Discharge Summaries &yr.";
label a2_&yr.="Adoption of a Basic EHR:View Laboratory Reports &yr.";
label b2_&yr.="Adoption of a Basic EHR:View Radiology Reports &yr.";
label d2_&yr.="Adoption of a Basic EHR:View Diagnostic Test Results &yr.";
label c3_&yr.="Adoption of a Basic EHR:CPOE Medication &yr.";

*Adoption of a Comprehensive EHR (additional functions beyond basic);
g1_&yr.=q1_g1*1;c2_&yr.=q1_c2*1;e2_&yr.=q1_e2*1;f2_&yr.=q1_f2*1;a3_&yr.=q1_a3*1;b3_&yr.=q1_b3*1;
d3_&yr.=q1_d3*1;e3_&yr.=q1_e3*1;a4_&yr.=q1_a4*1;b4_&yr.=q1_b4*1;c4_&yr.=q1_c4*1;d4_&yr.=q1_d4*1;e4_&yr.=q1_e4*1;f4_&yr.=q1_f4*1;
label g1_&yr.="Adoption of a Comprehensive EHR:Advanced Directives &yr.";
label c2_&yr.="Adoption of a Comprehensive EHR:View Radiology Images &yr.";
label e2_&yr.="Adoption of a Comprehensive EHR:View Diagnostic Test Images &yr.";
label f2_&yr.="Adoption of a Comprehensive EHR:View Consultant Reports &yr.";
label a3_&yr.="Adoption of a Comprehensive EHR:CPOE Laboratory Tests &yr.";
label b3_&yr.="Adoption of a Comprehensive EHR:CPOE Radiology Tests &yr.";
label d3_&yr.="Adoption of a Comprehensive EHR:CPOE Consultation Requests &yr.";
label e3_&yr.="Adoption of a Comprehensive EHR:CPOE Nursing Orders &yr.";
label a4_&yr.="Adoption of a Comprehensive EHR:DS Clinical Guidelines &yr.";
label b4_&yr.="Adoption of a Comprehensive EHR:DS Clinical Reminders &yr.";
label c4_&yr.="Adoption of a Comprehensive EHR:DS Drug Allergy Alerts &yr.";
label d4_&yr.="Adoption of a Comprehensive EHR:DS Drug-Drug Interaction Alerts &yr.";
label e4_&yr.="Adoption of a Comprehensive EHR:DS Drug-Lab Interaction Alerts &yr.";
label f4_&yr.="Adoption of a Comprehensive EHR:DS Drug Dosing Support &yr.";

*Meaningful use attestation status;
Q12_&yr.=Q13;
label Q12_&yr.="Meaningful use attestation status:Certified EHR for Meaningful Use &yr.";

*Health information exchange with Hospitals inside system;
Q3Aa1_&yr.=q4a_whis*1; 
Q3Ab1_&yr.=q4d_whis*1;
Q3Ac1_&yr.=q4e_whis*1;
Q3Ad1_&yr.=q4f_whis*1;
Q3Ae1_&yr.=q4b_whis*1;

Q3Aa2_&yr.=q4a_whos*1;
Q3Ab2_&yr.=q4d_whos*1;
Q3Ac2_&yr.=q4e_whos*1;
Q3Ad2_&yr.=q4f_whos*1;
Q3Ae2_&yr.=q4b_whos*1;

Q3Aa3_&yr.=q4a_wapis*1;
Q3Ab3_&yr.=q4d_wapis*1;
Q3Ac3_&yr.=q4e_wapis*1;
Q3Ad3_&yr.=q4f_wapis*1;
Q3Ae3_&yr.=q4b_wapis*1;

Q3Aa4_&yr.=q4a_wapos*1; 
Q3Ab4_&yr.=q4d_wapos*1;
Q3Ac4_&yr.=q4e_wapos*1;
Q3Ad4_&yr.=q4f_wapos*1;
Q3Ae4_&yr.=q4b_wapos*1;
 
label Q3Aa1_&yr.="Health information exchange with Hospitals inside system:Patient demographics &yr.";
label Q3Ab1_&yr.="Health information exchange with Hospitals inside system:Laboratory results &yr.";
label Q3Ac1_&yr.="Health information exchange with Hospitals inside system:Medication history &yr.";
label Q3Ad1_&yr.="Health information exchange with Hospitals inside system:Radiology reports &yr.";
label Q3Ae1_&yr.="Health information exchange with Hospitals inside system:Clinical/Summary care record &yr.";

label Q3Aa2_&yr.="Health information exchange with Hospitals oustide system:Patient demographics &yr.";
label Q3Ab2_&yr.="Health information exchange with Hospitals oustide system:Laboratory results &yr.";
label Q3Ac2_&yr.="Health information exchange with Hospitals oustide system:Medication history &yr.";
label Q3Ad2_&yr.="Health information exchange with Hospitals oustide system:Radiology reports &yr.";
label Q3Ae2_&yr.="Health information exchange with Hospitals oustide system:Clinical/Summary care record &yr.";

label Q3Aa3_&yr.="Health information exchange with Ambulatory providers inside system:Patient demographics &yr.";
label Q3Ab3_&yr.="Health information exchange with Ambulatory providers inside system:Laboratory results &yr.";
label Q3Ac3_&yr.="Health information exchange with Ambulatory providers inside system:Medication history &yr.";
label Q3Ad3_&yr.="Health information exchange with Ambulatory providers inside system:Radiology reports &yr.";
label Q3Ae3_&yr.="Health information exchange with Ambulatory providers inside system:Clinical/Summary care record &yr.";
 
label Q3Aa4_&yr.="Health information exchange with Ambulatory Providers oustide system:Patient demographics &yr.";
label Q3Ab4_&yr.="Health information exchange with Ambulatory providers oustide system:Laboratory results &yr.";
label Q3Ac4_&yr.="Health information exchange with Ambulatory providers oustide system:Medication history &yr.";
label Q3Ad4_&yr.="Health information exchange with Ambulatory providers oustide system:Radiology reports &yr.";
label Q3Ae4_&yr.="Health information exchange with Ambulatory providers oustide system:Clinical/Summary care record &yr.";

if q4a_whos=1 or q4b_whos=1 or q4c_whos=1 or q4d_whos=1
or q4e_whos=1 or q4f_whos=1 
or q4a_wapos=1 or q4b_wapos=1 or q4c_wapos=1 or q4d_wapos=1
or q4e_wapos=1 or q4f_wapos=1  
then HIEoutSystem_&yr.=1;else 
HIEoutSystem_&yr.=0;

label HIEoutSystem_&yr.="HIE outside of System";

*Participate in RHIO;
if q_3a=1 then Q4b_&yr.="Participating and actively exchanging data in at least one HIE/RHIO";
else if q_3a=2 then Q4b_&yr.="Have the electronic framework to participate but not participating in any HIE/RHIO at this time";
else if q_3a=3 then Q4b_&yr.="Do not have the electronic framework to participate and not participating in any HIE/RHIO at this time";
else Q4b_&yr.="";
label Q4b_&yr.="Participate in RHIO:Level of participation in Regional HIO  &yr.";


 if a1_&yr. ne . then respond&yr. =1;
if respond&yr. =1;

proc sort;by id;
proc contents order=varnum;
proc freq ;tables HIEoutSystem_&yr./missing;
run;








%let yr=2010;

data hit&yr.;
set hit.hit09;

keep id respond&yr. 
a1_&yr. b1_&yr. c1_&yr. d1_&yr. e1_&yr. f1_&yr. a2_&yr. b2_&yr. d2_&yr. c3_&yr.
g1_&yr. c2_&yr. e2_&yr. f2_&yr. a3_&yr. b3_&yr. d3_&yr. e3_&yr. a4_&yr. b4_&yr. c4_&yr. d4_&yr. e4_&yr. f4_&yr. 

Q3Aa1_&yr. Q3Ab1_&yr. Q3Ac1_&yr. Q3Ad1_&yr. Q3Ae1_&yr. 
Q3Aa2_&yr. Q3Ab2_&yr. Q3Ac2_&yr. Q3Ad2_&yr. Q3Ae2_&yr.
Q3Aa3_&yr. Q3Ab3_&yr. Q3Ac3_&yr. Q3Ad3_&yr. Q3Ae3_&yr.
Q3Aa4_&yr. Q3Ab4_&yr. Q3Ac4_&yr. Q3Ad4_&yr. Q3Ae4_&yr.
Q4b_&yr. HIEoutSystem_&yr.;

*Adoption of a Basic EHR (focal measure);
a1_&yr.=q1a1*1;b1_&yr.=q1b1*1;c1_&yr.=q1c1*1;d1_&yr.=q1d1*1;e1_&yr.=q1e1*1;f1_&yr.=q1f1*1;
a2_&yr.=q1a2*1;b2_&yr.=q1b2*1;d2_&yr.=q1d2*1;c3_&yr.=q1c3*1;
label a1_&yr.="Adoption of a Basic EHR:Patient Demographics &yr.";
label b1_&yr.="Adoption of a Basic EHR:Physician Notes &yr.";
label c1_&yr.="Adoption of a Basic EHR:Nursing Notes &yr.";
label d1_&yr.="Adoption of a Basic EHR:Problem Lists &yr.";
label e1_&yr.="Adoption of a Basic EHR:Medication Lists &yr.";
label f1_&yr.="Adoption of a Basic EHR:Discharge Summaries &yr.";
label a2_&yr.="Adoption of a Basic EHR:View Laboratory Reports &yr.";
label b2_&yr.="Adoption of a Basic EHR:View Radiology Reports &yr.";
label d2_&yr.="Adoption of a Basic EHR:View Diagnostic Test Results &yr.";
label c3_&yr.="Adoption of a Basic EHR:CPOE Medication &yr.";

*Adoption of a Comprehensive EHR (additional functions beyond basic);
g1_&yr.=q1g1*1;c2_&yr.=q1c2*1;e2_&yr.=q1e2*1;f2_&yr.=q1f2*1;a3_&yr.=q1a3*1;b3_&yr.=q1b3*1;
d3_&yr.=q1d3*1;e3_&yr.=q1e3*1;a4_&yr.=q1a4*1;b4_&yr.=q1b4*1;c4_&yr.=q1c4*1;d4_&yr.=q1d4*1;e4_&yr.=q1e4*1;f4_&yr.=q1f4*1;
label g1_&yr.="Adoption of a Comprehensive EHR:Advanced Directives &yr.";
label c2_&yr.="Adoption of a Comprehensive EHR:View Radiology Images &yr.";
label e2_&yr.="Adoption of a Comprehensive EHR:View Diagnostic Test Images &yr.";
label f2_&yr.="Adoption of a Comprehensive EHR:View Consultant Reports &yr.";
label a3_&yr.="Adoption of a Comprehensive EHR:CPOE Laboratory Tests &yr.";
label b3_&yr.="Adoption of a Comprehensive EHR:CPOE Radiology Tests &yr.";
label d3_&yr.="Adoption of a Comprehensive EHR:CPOE Consultation Requests &yr.";
label e3_&yr.="Adoption of a Comprehensive EHR:CPOE Nursing Orders &yr.";
label a4_&yr.="Adoption of a Comprehensive EHR:DS Clinical Guidelines &yr.";
label b4_&yr.="Adoption of a Comprehensive EHR:DS Clinical Reminders &yr.";
label c4_&yr.="Adoption of a Comprehensive EHR:DS Drug Allergy Alerts &yr.";
label d4_&yr.="Adoption of a Comprehensive EHR:DS Drug-Drug Interaction Alerts &yr.";
label e4_&yr.="Adoption of a Comprehensive EHR:DS Drug-Lab Interaction Alerts &yr.";
label f4_&yr.="Adoption of a Comprehensive EHR:DS Drug Dosing Support &yr.";


*Health information exchange with Hospitals inside system;
Q3Aa1_&yr.=q4a_1*1;
Q3Ab1_&yr.=q4c_1*1;
Q3Ac1_&yr.=q4d_1*1;
Q3Ad1_&yr.=q4e_1*1;
Q3Ae1_&yr.=q4b_1*1;

Q3Aa2_&yr.=q4a_2*1;
Q3Ab2_&yr.=q4c_2*1;
Q3Ac2_&yr.=q4d_2*1;
Q3Ad2_&yr.=q4e_2*1;
Q3Ae2_&yr.=q4b_2*1;

Q3Aa3_&yr.=q4a_3*1;
Q3Ab3_&yr.=q4c_3*1;
Q3Ac3_&yr.=q4d_3*1;
Q3Ad3_&yr.=q4e_3*1;
Q3Ae3_&yr.=q4b_3*1;

Q3Aa4_&yr.=q4a_4*1; 
Q3Ab4_&yr.=q4c_4*1;
Q3Ac4_&yr.=q4d_4*1;
Q3Ad4_&yr.=q4e_4*1;
Q3Ae4_&yr.=q4b_4*1;
 
 
label Q3Aa1_&yr.="Health information exchange with Hospitals inside system:Patient demographics &yr."; 
label Q3Ab1_&yr.="Health information exchange with Hospitals inside system:Laboratory results &yr.";
label Q3Ac1_&yr.="Health information exchange with Hospitals inside system:Medication history &yr.";
label Q3Ad1_&yr.="Health information exchange with Hospitals inside system:Radiology reports &yr.";
label Q3Ae1_&yr.="Health information exchange with Hospitals inside system:Clinical/Summary care record &yr.";

label Q3Aa2_&yr.="Health information exchange with Hospitals oustide system:Patient demographics &yr.";
label Q3Ab2_&yr.="Health information exchange with Hospitals oustide system:Laboratory results &yr.";
label Q3Ac2_&yr.="Health information exchange with Hospitals oustide system:Medication history &yr.";
label Q3Ad2_&yr.="Health information exchange with Hospitals oustide system:Radiology reports &yr.";
label Q3Ae2_&yr.="Health information exchange with Hospitals oustide system:Clinical/Summary care record &yr.";

label Q3Aa3_&yr.="Health information exchange with Ambulatory providers inside system:Patient demographics &yr.";
label Q3Ab3_&yr.="Health information exchange with Ambulatory providers inside system:Laboratory results &yr.";
label Q3Ac3_&yr.="Health information exchange with Ambulatory providers inside system:Medication history &yr.";
label Q3Ad3_&yr.="Health information exchange with Ambulatory providers inside system:Radiology reports &yr.";
label Q3Ae3_&yr.="Health information exchange with Ambulatory providers inside system:Clinical/Summary care record &yr.";
 
label Q3Aa4_&yr.="Health information exchange with Ambulatory Providers oustide system:Patient demographics &yr.";
label Q3Ab4_&yr.="Health information exchange with Ambulatory providers oustide system:Laboratory results &yr.";
label Q3Ac4_&yr.="Health information exchange with Ambulatory providers oustide system:Medication history &yr.";
label Q3Ad4_&yr.="Health information exchange with Ambulatory providers oustide system:Radiology reports &yr.";
label Q3Ae4_&yr.="Health information exchange with Ambulatory providers oustide system:Clinical/Summary care record &yr.";


if q4a_2='1' or q4b_2='1' or q4c_2='1' or q4d_2='1'
or q4e_2='1' or q4f_2='1'  
or q4a_4='1' or q4b_4='1' or q4c_4='1' or q4d_4='1'
or q4e_4='1' or q4f_4='1'  
then HIEoutSystem_&yr.=1;else  
HIEoutSystem_&yr.=0;

label HIEoutSystem_&yr.="HIE outside of System";


 if a1_&yr. ne . then respond&yr. =1;
if respond&yr. =1;


*Participate in RHIO;
Q4b_&yr.=Q3A;
label Q4b_&yr.="Participate in RHIO:Level of participation in Regional HIO &yr.";

proc sort;by id;
proc contents order=varnum;
proc freq ;tables HIEoutSystem_&yr./missing;
run;















%let yr=2009;

data hit&yr.;
set hit.hit08;

keep id respond&yr. 
a1_&yr. b1_&yr. c1_&yr. d1_&yr. e1_&yr. f1_&yr. a2_&yr. b2_&yr. d2_&yr. c3_&yr.
g1_&yr. c2_&yr. e2_&yr. f2_&yr. a3_&yr. b3_&yr. d3_&yr. e3_&yr. a4_&yr. b4_&yr. c4_&yr. d4_&yr. e4_&yr. f4_&yr. 

Q3Aa1_&yr. Q3Ab1_&yr. Q3Ac1_&yr. Q3Ad1_&yr. Q3Ae1_&yr. 
Q3Aa2_&yr. Q3Ab2_&yr. Q3Ac2_&yr. Q3Ad2_&yr. Q3Ae2_&yr.
Q3Aa4_&yr. Q3Ab4_&yr. Q3Ac4_&yr. Q3Ad4_&yr. Q3Ae4_&yr.
Q4b_&yr. HIEoutSystem_&yr.;


*Adoption of a Basic EHR (focal measure);
a1_&yr.=q1_a1*1;b1_&yr.=q1_b1*1;c1_&yr.=q1_c1*1;d1_&yr.=q1_d1*1;e1_&yr.=q1_e1*1;f1_&yr.=q1_f1*1;
a2_&yr.=q1_a2*1;b2_&yr.=q1_b2*1;d2_&yr.=q1_d2*1;c3_&yr.=q1_c3*1;
label a1_&yr.="Adoption of a Basic EHR:Patient Demographics &yr. ";
label b1_&yr.="Adoption of a Basic EHR:Physician Notes &yr. ";
label c1_&yr.="Adoption of a Basic EHR:Nursing Notes &yr. ";
label d1_&yr.="Adoption of a Basic EHR:Problem Lists &yr. ";
label e1_&yr.="Adoption of a Basic EHR:Medication Lists &yr. ";
label f1_&yr.="Adoption of a Basic EHR:Discharge Summaries &yr. ";
label a2_&yr.="Adoption of a Basic EHR:View Laboratory Reports &yr. ";
label b2_&yr.="Adoption of a Basic EHR:View Radiology Reports &yr. ";
label d2_&yr.="Adoption of a Basic EHR:View Diagnostic Test Results &yr. ";
label c3_&yr.="Adoption of a Basic EHR:CPOE Medication &yr. ";

*Adoption of a Comprehensive EHR (additional functions beyond basic);
g1_&yr.=q1_g1*1;c2_&yr.=q1_c2*1;e2_&yr.=q1_e2*1;f2_&yr.=q1_f2*1;a3_&yr.=q1_a3*1;b3_&yr.=q1_b3*1;
d3_&yr.=q1_d3*1;e3_&yr.=q1_e3*1;a4_&yr.=q1_a4*1;b4_&yr.=q1_b4*1;c4_&yr.=q1_c4*1;d4_&yr.=q1_d4*1;e4_&yr.=q1_e4*1;f4_&yr.=q1_f4*1;
label g1_&yr.="Adoption of a Comprehensive EHR:Advanced Directives &yr. ";
label c2_&yr.="Adoption of a Comprehensive EHR:View Radiology Images &yr. ";
label e2_&yr.="Adoption of a Comprehensive EHR:View Diagnostic Test Images &yr. ";
label f2_&yr.="Adoption of a Comprehensive EHR:View Consultant Reportsv &yr.";
label a3_&yr.="Adoption of a Comprehensive EHR:CPOE Laboratory Tests &yr. ";
label b3_&yr.="Adoption of a Comprehensive EHR:CPOE Radiology Tests &yr. ";
label d3_&yr.="Adoption of a Comprehensive EHR:CPOE Consultation Requests &yr. ";
label e3_&yr.="Adoption of a Comprehensive EHR:CPOE Nursing Orders &yr. ";
label a4_&yr.="Adoption of a Comprehensive EHR:DS Clinical Guidelines &yr. ";
label b4_&yr.="Adoption of a Comprehensive EHR:DS Clinical Reminders &yr. ";
label c4_&yr.="Adoption of a Comprehensive EHR:DS Drug Allergy Alerts &yr. ";
label d4_&yr.="Adoption of a Comprehensive EHR:DS Drug-Drug Interaction Alerts &yr. ";
label e4_&yr.="Adoption of a Comprehensive EHR:DS Drug-Lab Interaction Alerts &yr. ";
label f4_&yr.="Adoption of a Comprehensive EHR:DS Drug Dosing Support &yr. ";

*Health information exchange with Hospitals inside system;
Q3Aa1_&yr.=q5a_1*1;
Q3Ab1_&yr.=q5c_1*1;
Q3Ac1_&yr.=q5d_1*1;
Q3Ad1_&yr.=q5e_1*1;
Q3Ae1_&yr.=q5b_1*1;

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
 
label Q3Aa1_&yr.="Health information exchange with Hospitals inside system:Patient demographics &yr. "; 
label Q3Ab1_&yr.="Health information exchange with Hospitals inside system:Laboratory results &yr. ";
label Q3Ac1_&yr.="Health information exchange with Hospitals inside system:Medication history &yr. ";
label Q3Ad1_&yr.="Health information exchange with Hospitals inside system:Radiology reports &yr. ";
label Q3Ae1_&yr.="Health information exchange with Hospitals inside system:Clinical/Summary care record &yr. ";

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



if q5a_2='1' or q5b_2='1' or q5c_2='1' or q5d_2='1'
or q5e_2='1'  
or q5a_3='1' or q5b_3='1' or q5c_3='1' or q5d_3='1'
or q5e_3='1'  
then HIEoutSystem_&yr.=1;else
 HIEoutSystem_&yr.=0;

label HIEoutSystem_&yr.="HIE outside of System";


if a1_&yr. ne . then respond&yr. =1;
if respond&yr. =1;

*Participate in RHIO;
Q4b_&yr.=Q4;
label Q4b_&yr.="Participate in RHIO:Level of participation in Regional HIO &yr. ";

proc sort;by id;
proc contents order=varnum;
proc freq ;tables HIEoutSystem_&yr./missing;
run;












%let yr=2008;

data hit&yr.;
set hit.hit07;

keep id respond&yr. 
a1_&yr. b1_&yr. c1_&yr. d1_&yr. e1_&yr. f1_&yr. a2_&yr. b2_&yr. d2_&yr. c3_&yr.
g1_&yr. c2_&yr. e2_&yr. f2_&yr. a3_&yr. b3_&yr. d3_&yr. e3_&yr. a4_&yr. b4_&yr. c4_&yr. d4_&yr. e4_&yr. f4_&yr. 

Q3Aa1_&yr. Q3Ab1_&yr. Q3Ac1_&yr. Q3Ad1_&yr. Q3Ae1_&yr. 
Q3Aa2_&yr. Q3Ab2_&yr. Q3Ac2_&yr. Q3Ad2_&yr. Q3Ae2_&yr.
Q3Aa4_&yr. Q3Ab4_&yr. Q3Ac4_&yr. Q3Ad4_&yr. Q3Ae4_&yr.
Q4b_&yr. HIEoutSystem_&yr.;


*Adoption of a Basic EHR (focal measure);
a1_&yr.=q1a1*1;b1_&yr.=q1b1*1;c1_&yr.=q1c1*1;d1_&yr.=q1d1*1;e1_&yr.=q1e1*1;f1_&yr.=q1f1*1;
a2_&yr.=q1a2*1;b2_&yr.=q1b2*1;d2_&yr.=q1d2*1;c3_&yr.=q1c3*1;
label a1_&yr.="Adoption of a Basic EHR:Patient Demographics &yr.";
label b1_&yr.="Adoption of a Basic EHR:Physician Notes &yr.";
label c1_&yr.="Adoption of a Basic EHR:Nursing Notes &yr.";
label d1_&yr.="Adoption of a Basic EHR:Problem Lists &yr.";
label e1_&yr.="Adoption of a Basic EHR:Medication Lists &yr.";
label f1_&yr.="Adoption of a Basic EHR:Discharge Summaries &yr.";
label a2_&yr.="Adoption of a Basic EHR:View Laboratory Reports &yr.";
label b2_&yr.="Adoption of a Basic EHR:View Radiology Reports &yr.";
label d2_&yr.="Adoption of a Basic EHR:View Diagnostic Test Results &yr.";
label c3_&yr.="Adoption of a Basic EHR:CPOE Medication &yr.";

*Adoption of a Comprehensive EHR (additional functions beyond basic);
g1_&yr.=q1g1*1;c2_&yr.=q1c2*1;e2_&yr.=q1e2*1;f2_&yr.=q1f2*1;a3_&yr.=q1a3*1;b3_&yr.=q1b3*1;
d3_&yr.=q1d3*1;e3_&yr.=q1e3*1;a4_&yr.=q1a4*1;b4_&yr.=q1b4*1;c4_&yr.=q1c4*1;d4_&yr.=q1d4*1;e4_&yr.=q1e4*1;f4_&yr.=q1f4*1;
label g1_&yr.="Adoption of a Comprehensive EHR:Advanced Directives &yr.";
label c2_&yr.="Adoption of a Comprehensive EHR:View Radiology Images &yr.";
label e2_&yr.="Adoption of a Comprehensive EHR:View Diagnostic Test Images &yr.";
label f2_&yr.="Adoption of a Comprehensive EHR:View Consultant Reports &yr.";
label a3_&yr.="Adoption of a Comprehensive EHR:CPOE Laboratory Tests &yr.";
label b3_&yr.="Adoption of a Comprehensive EHR:CPOE Radiology Tests &yr.";
label d3_&yr.="Adoption of a Comprehensive EHR:CPOE Consultation Requests &yr.";
label e3_&yr.="Adoption of a Comprehensive EHR:CPOE Nursing Orders &yr.";
label a4_&yr.="Adoption of a Comprehensive EHR:DS Clinical Guidelines &yr.";
label b4_&yr.="Adoption of a Comprehensive EHR:DS Clinical Reminders &yr.";
label c4_&yr.="Adoption of a Comprehensive EHR:DS Drug Allergy Alerts &yr.";
label d4_&yr.="Adoption of a Comprehensive EHR:DS Drug-Drug Interaction Alerts &yr.";
label e4_&yr.="Adoption of a Comprehensive EHR:DS Drug-Lab Interaction Alerts &yr.";
label f4_&yr.="Adoption of a Comprehensive EHR:DS Drug Dosing Support &yr.";

*Health information exchange with Hospitals inside system;
Q3Aa1_&yr.=q10a_1*1;
Q3Ab1_&yr.=q10c_1*1;
Q3Ac1_&yr.=q10d_1*1;
Q3Ad1_&yr.=q10e_1*1;
Q3Ae1_&yr.=q10b_1*1;

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
 
label Q3Aa1_&yr.="Health information exchange with Hospitals inside system:Patient demographics &yr."; 
label Q3Ab1_&yr.="Health information exchange with Hospitals inside system:Laboratory results &yr.";
label Q3Ac1_&yr.="Health information exchange with Hospitals inside system:Medication history &yr.";
label Q3Ad1_&yr.="Health information exchange with Hospitals inside system:Radiology reports &yr.";
label Q3Ae1_&yr.="Health information exchange with Hospitals inside system:Clinical/Summary care record &yr.";

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


if q10a_2='1' or q10b_2='1' or q10c_2='1' or q10d_2='1'
or q10e_2='1' or q10f_2='1'   
or q10a_3='1' or q10b_3='1' or q10c_3='1' or q10d_3='1'
or q10e_3='1' or q10f_3='1'  
then HIEoutSystem_&yr.=1;else 
HIEoutSystem_&yr.=0;

label HIEoutSystem_&yr.="HIE outside of System";

 if a1_&yr. ne . then respond&yr. =1;
if respond&yr. =1;

*Participate in RHIO;
Q4b_&yr.=Q9;
label Q4b_&yr.="Participate in RHIO:Level of participation in Regional HIO &yr.";

proc sort;by id;
proc contents order=varnum;
proc freq ;tables HIEoutSystem_&yr./missing;
run;




data data.HIT;
merge HIT2008(in=in2008) HIT2009(in=in2009) HIT2010(in=in2010) HIT2011(in=in2011) HIT2012(in=in2012) HIT2013(in=in2013);
by id;
if in2008=1 or in2009=1 or in2010=1 or in2011=1 or in2012=1 or in2013=1;
 
proc contents order=varnum;
proc freq;tables Respond2008 Respond2009 Respond2010 Respond2011 Respond2012 Respond2013 ;
run;
