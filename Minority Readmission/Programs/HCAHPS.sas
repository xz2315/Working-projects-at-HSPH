************************* 
Import HCAPS 2014 Data
Xiner Zhou
6/9/2015
*************************;
libname data 'C:\data\Data\Hospital\Hospital Compare\data';

proc import datafile="C:\data\Data\Hospital\Hospital Compare\origdata\Year2014\HCAHPS.csv"
dbms=csv out=HCAHPS replace;getnames=yes;run;

data temp1 temp2;
set HCAHPS;
if HCAHPS_Answer_Description='' then output temp1;
else output temp2;
run;

proc sort data=temp2;by provider_id;run;

proc transpose data=temp2 out=temp3;
by provider_id ;
id HCAHPS_Measure_ID;
var HCAHPS_Answer_Percent;
run;

data temp3;
set temp3;
if H_CLEAN_HSP_A_P='Not Available' then H_CLEAN_HSP_A_P='';
if H_CLEAN_HSP_SN_P='Not Available' then H_CLEAN_HSP_SN_P='';
if H_CLEAN_HSP_U_P='Not Available' then H_CLEAN_HSP_U_P='';
if H_COMP_1_A_P='Not Available' then H_COMP_1_A_P='';
if H_COMP_1_SN_P='Not Available' then H_COMP_1_SN_P='';
if H_COMP_1_U_P='Not Available' then H_COMP_1_U_P='';
if H_COMP_2_A_P='Not Available' then H_COMP_2_A_P='';
if H_COMP_2_SN_P='Not Available' then H_COMP_2_SN_P='';
if H_COMP_2_U_P='Not Available' then H_COMP_2_U_P='';
if H_COMP_3_A_P='Not Available' then H_COMP_3_A_P='';
if H_COMP_3_SN_P='Not Available' then H_COMP_3_SN_P='';
if H_COMP_3_U_P='Not Available' then H_COMP_3_U_P='';
if H_COMP_4_A_P='Not Available' then H_COMP_4_A_P='';
if H_COMP_4_SN_P='Not Available' then H_COMP_4_SN_P='';
if H_COMP_4_U_P='Not Available' then H_COMP_4_U_P='';
if H_COMP_5_A_P='Not Available' then H_COMP_5_A_P='';
if H_COMP_5_SN_P='Not Available' then H_COMP_5_SN_P='';
if H_COMP_5_U_P='Not Available' then H_COMP_5_U_P='';
if H_COMP_6_N_P='Not Available' then H_COMP_6_N_P='';
if H_COMP_6_Y_P='Not Available' then H_COMP_6_Y_P='';
if H_COMP_7_A='Not Available' then H_COMP_7_A='';
if H_COMP_7_D_SD='Not Available' then H_COMP_7_D_SD='';
if H_COMP_7_SA='Not Available' then H_COMP_7_SA='';
if H_HSP_RATING_0_6='Not Available' then H_HSP_RATING_0_6='';
if H_HSP_RATING_7_8='Not Available' then H_HSP_RATING_7_8='';

if  H_HSP_RATING_9_10='Not Available' then  H_HSP_RATING_9_10='';
if  H_QUIET_HSP_A_P='Not Available' then  H_QUIET_HSP_A_P='';
if  H_QUIET_HSP_SN_P='Not Available' then  H_QUIET_HSP_SN_P='';
if  H_QUIET_HSP_U_P='Not Available' then  H_QUIET_HSP_U_P='';
if  H_RECMND_DN='Not Available' then  H_RECMND_DN='';
if  H_RECMND_DY='Not Available' then  H_RECMND_DY='';
if  H_RECMND_PY='Not Available' then  H_RECMND_PY='';
 

label H_CLEAN_HSP_A_P='Patients who reported that their room and bathroom were "Always" clean'; 
label H_CLEAN_HSP_SN_P='Patients who reported that their room and bathroom were "Sometimes" or "Never" clean';   
label H_CLEAN_HSP_U_P='Patients who reported that their room and bathroom were "Usually" clean';
label H_COMP_1_A_P='Patients who reported that their nurses "Always" communicated well';
label H_COMP_1_SN_P='Patients who reported that their nurses "Sometimes" or "Never" communicated well';
label H_COMP_1_U_P='Patients who reported that their nurses "Usually" communicated well';
label H_COMP_2_A_P='Patients who reported that their doctors "Always" communicated well';  
label H_COMP_2_SN_P='Patients who reported that their doctors "Sometimes" or "Never" communicated well';  
label H_COMP_2_U_P='Patients who reported that their doctors "Usually" communicated well'; 
label H_COMP_3_A_P='Patients who reported that they "Always" received help as soon as they wanted';  
label H_COMP_3_SN_P='Patients who reported that they "Sometimes" or "Never" received help as soon as they wanted';  
label H_COMP_3_U_P='Patients who reported that they "Usually" received help as soon as they wanted'; 
label H_COMP_4_A_P='Patients who reported that their pain was "Always" well controlled';  
label H_COMP_4_SN_P='Patients who reported that their pain was "Sometimes" or "Never" well controlled';  
label H_COMP_4_U_P='Patients who reported that their pain was "Usually" well controlled';
label H_COMP_5_A_P='Patients who reported that staff "Always" explained about medicines before giving it to them';
label H_COMP_5_SN_P='Patients who reported that staff "Sometimes" or "Never" explained about medicines before giving it to them';
label H_COMP_5_U_P='Patients who reported that staff "Usually" explained about medicines before giving it to them';
label H_COMP_6_N_P='Patients who reported that NO, they were not given information about what to do during their recovery'; 
label H_COMP_6_Y_P='Patients who reported that YES, they were given information about what to do during their recovery'; 
label H_COMP_7_A='Patients who “Agree” they understood their care when they left the hospital';
label H_COMP_7_D_SD='Patients who “Disagree” or “Strongly Disagree” they understood their care when they left the hospital'; 
label H_COMP_7_SA='Patients who "Strongly Agree" they understood their care when they left the hospital'; 
label H_HSP_RATING_0_6='Patients who gave their hospital a rating of 6 or lower on a scale from 0 (lowest) to 10 (highest)';   
label H_HSP_RATING_7_8='Patients who gave their hospital a rating of 7 or 8 on a scale from 0 (lowest) to 10 (highest)'; 
label H_HSP_RATING_9_10='Patients who gave their hospital a rating of 9 or 10 on a scale from 0 (lowest) to 10 (highest)';  
label H_QUIET_HSP_A_P='Patients who reported that the area around their room was "Always" quiet at night';
label H_QUIET_HSP_SN_P='Patients who reported that the area around their room was "Sometimes" or "Never" quiet at night';  
label H_QUIET_HSP_U_P='Patients who reported that the area around their room was "Usually" quiet at night';
label H_RECMND_DN='Patients who reported NO, they would probably not or definitely not recommend the hospital'; 
label H_RECMND_DY='Patients who reported YES, they would definitely recommend the hospital';
label H_RECMND_PY='Patients who reported YES, they would probably recommend the hospital';

drop _NAME_;
run;

proc sort data=temp1;by provider_id;run;
proc transpose data=temp1 out=temp4;
by provider_id ;
id HCAHPS_Measure_ID;
var Patient_Survey_Star_Rating;
run;
 
data temp4;
set temp4;
if  H_CLEAN_STAR_RATING='Not Available' then  H_CLEAN_STAR_RATING='';
if  H_COMP_1_STAR_RATING='Not Available' then  H_COMP_1_STAR_RATING='';
if  H_COMP_2_STAR_RATING='Not Available' then  H_COMP_2_STAR_RATING='';
if  H_COMP_3_STAR_RATING='Not Available' then  H_COMP_3_STAR_RATING='';
if  H_COMP_4_STAR_RATING='Not Available' then H_COMP_4_STAR_RATING='';
if H_COMP_5_STAR_RATING='Not Available' then H_COMP_5_STAR_RATING='';
if H_COMP_6_STAR_RATING='Not Available' then  H_COMP_6_STAR_RATING='';

if  H_COMP_7_STAR_RATING='Not Available' then H_COMP_7_STAR_RATING='';
if  H_HSP_RATING_STAR_RATI='Not Available' then H_HSP_RATING_STAR_RATI='';
if H_QUIET_STAR_RATING='Not Available' then H_QUIET_STAR_RATING='';
if  H_RECMND_STAR_RATING='Not Available' then  H_RECMND_STAR_RATING='';
if H_STAR_RATING='Not Available' then  H_STAR_RATING='';

label H_CLEAN_STAR_RATING='Room and Bathroom clean Star Rating';
label H_COMP_1_STAR_RATING='Nurse Communication Star Rating'; 
label H_COMP_2_STAR_RATING='Doctors Communication Star Rating';   
label H_COMP_3_STAR_RATING='Receive Help Star Rating';  
label H_COMP_4_STAR_RATING='Control Pain Star Rating';    
label H_COMP_5_STAR_RATING='Staff Explained About Medicines Star Rating';  
label H_COMP_6_STAR_RATING='Recovery Star Rating'; 
label H_COMP_7_STAR_RATING='Discharge Star Rating';   
label H_HSP_RATING_STAR_RATI='Hospital Rating Star Rating';     
label H_QUIET_STAR_RATING='Quiet Star Rating';
label H_RECMND_STAR_RATING='Recommend Star Rating';
label H_STAR_RATING='Summary Star Rating';

drop _NAME_;
run;

proc sql;
create table temp as 
select a.*,b.*
from temp3 a join temp4 b
on a.provider_id=b.provider_id;
quit;
 
proc sort data=HCAHPS nodupkey;by provider_id;run;

proc sql;
create table data.hcahps2014 as 
select a.Provider_id, a.Hospital_name, a.Address, a.City, a.State, a.ZIP_Code, a.County_Name, a.Measure_Start_Date,
b.H_STAR_RATING, 
b.H_CLEAN_HSP_A_P, b.H_CLEAN_HSP_U_P, b.H_CLEAN_HSP_SN_P, b.H_CLEAN_STAR_RATING,
b.H_COMP_1_A_P, b.H_COMP_1_U_P, b.H_COMP_1_SN_P, b.H_COMP_1_STAR_RATING,
b.H_COMP_2_A_P, b.H_COMP_2_U_P, b.H_COMP_2_SN_P, b.H_COMP_2_STAR_RATING,
b.H_COMP_3_A_P, b.H_COMP_3_U_P, b.H_COMP_3_SN_P, b.H_COMP_3_STAR_RATING,
b.H_COMP_4_A_P, b.H_COMP_4_U_P, b.H_COMP_4_SN_P, b.H_COMP_4_STAR_RATING,
b.H_COMP_5_A_P, b.H_COMP_5_U_P, b.H_COMP_5_SN_P, b.H_COMP_5_STAR_RATING,
b.H_COMP_6_Y_P, b.H_COMP_6_N_P, b.H_COMP_6_STAR_RATING,
b.H_COMP_7_SA, b.H_COMP_7_A, b.H_COMP_7_D_SD, b.H_COMP_7_STAR_RATING,
b.H_QUIET_HSP_A_P, b.H_QUIET_HSP_U_P, b.H_QUIET_HSP_SN_P, b.H_QUIET_STAR_RATING,
b.H_RECMND_DY, b.H_RECMND_PY, b.H_RECMND_DN, b.H_RECMND_STAR_RATING,
b.H_HSP_RATING_0_6, b.H_HSP_RATING_7_8, b.H_HSP_RATING_9_10, b.H_HSP_RATING_STAR_RATI

from HCAHPS a left join temp b
on a.provider_id=b.provider_id;
quit;
