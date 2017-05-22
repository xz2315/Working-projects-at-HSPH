****************************************************
CommonWealth Sub P4P
Xiner Zhou
2/9/2016
*****************************************************;
libname data 'C:\data\Projects\P4P\Data';

************************************** 
Hey Xiner, 

So sorry for the delay in getting this to you, but thank you so much for agreeing to run these models this week. 

The models are similar to what you ran for the first part of this project, in that we want to estimate 2 outcomes 
simultaneously- a binary outcome (was there any cost/utilization) and a continuous or count outcome 
(how much cost/utilization, given that the value is >0). For medsurgcost, outpatient costs and PCP visits, 
we do not want to include the binary outcome, because the % of patients incurring NO utilization in these buckets is near 0. 

Other key points:
1. I made a few key data cleaning modifications- I removed practices with <100 patients/pcp, and also cut off the top 5% of practices 
with the highest percent of sick patients in their panel (data was very right-skewed). See Do-file for other clean-ups, 
and please reference the descriptive tables I've attached to make sure the final analytic sample you arrive at is the same as me!

2. For all models, we want to include a year fixed effect and random effects at the patient level. We are ONLY looking at outcomes 
for patients with >1 comorbidity (at least for the main models. See #3)

3. All of the DVs are skewed, which made me think about logging them, but I wasn't sure if that was appropriate given the 2-piece 
model we are now using. Let me know!

4. As you will see in the attached do-file, after running the main models, I also ran a set of supplemental models where we 
restrict the patients we are looking at to those with only 0 or 1 comorbidity. We want to know how their health outcomes fare 
relative to patients in their same practice that are more high-needs. I wasn't sure if this meant we would need to include 
a practice-level random effect as well (and if this is even computationally possible?)

I am attaching the initial data file I started with, and a (hopefully) pretty clean do-file, in case that is helpful. 
Please give me a call or email with any questions you might have. Obviously, the models in my do-file are not correct/don't match 
what I have asked for above. But, that way you can see what IVs and DVs I included!

Thanks so much,
Dori

**************************************;
 
**************************************
STATA Command:

xtmixed medsurgcost i.pgip i.gender_cd ageinyears meanage pcpmembers_perpcp i.PCPsize2 i.Quartile_sickptprop year if comorbcount>=2 || patient_ID:, var
outreg2 using C:\Users\dacross\Documents\OrgScaleOutput_quartilesNEW.doc, replace ctitle(MedSurgCost)

global Outcomes ipcost edcost opcost drugcost

foreach x in $Outcomes {
xtmixed `x' i.pgip i.gender_cd ageinyears meanage pcpmembers_perpcp i.PCPsize2 i.Quartile_sickptprop year if comorbcount>=2 || patient_ID:, var
outreg2 using C:\Users\dacross\Documents\OrgScaleOutput_quartilesNEW.doc, append ctitle(`x')
}

global Outcomes2 totaledvisits_enc  totalipdischarges_enc readmission30  pcpvisits specvisits

foreach x in $Outcomes2 {
xtnbreg `x' i.pgip i.gender_cd ageinyears meanage pcpmembers_perpcp i.PCPsize2 i.Quartile_sickptprop year if comorbcount>=2, re
outreg2 using C:\Users\dacross\Documents\OrgScaleOutput_quartilesNEW.doc, append ctitle(`x')
}

global Outcomes3 AdultQual MedMgmt

foreach x in $Outcomes3 {
xtreg `x' i.pgip i.gender_cd ageinyears meanage pcpmembers_perpcp i.PCPsize2 i.Quartile_sickptprop year if comorbcount>=2, re
outreg2 using C:\Users\dacross\Documents\OrgScaleOutput_quartilesNEW.doc, append ctitle(`x')
}
******************************************;

******************************************
Hey Xiner-
 
This is great..thank you! For the revised models, instead of using quartiles of sick patients, can we now run a model that splits 
practices for this variable in to 2 categories: below 10% and above 10%? In terms of data cleaning, Let's still remove practices 
with values fewer than 100 for the "'members per pcp" variable, but no longer cut off the top 5% of practices. 
 
Let me know if you have any questions..thank you! We may ultimately run another set of models with cut points at 5, 10 and 20%, 
but we can start with just what I laid out above (over or under 10%)
 
Thanks so much!
Dori

******************************************;
********************************************************************************************
Evaluate Effect of PropSick(Quartile) from panel data:
********************************************************************************************;
data data;
set data.data;
if Unhealthy=1;
Adultquality=Adultquality_numer/Adultquality_denom;
Adultpreventive=Adultpreventive_numer/Adultpreventive_denom;
med_mgmt=med_mgmt_pers_mednumer/med_mgmt_pers_meddenom;
year=datapoint;
rename Adultquality_numer=quality1;
rename Adultquality_denom=quality2;
rename Adultpreventive_numer=preventive1;
rename Adultpreventive_denom=preventive2;
rename med_mgmt_pers_mednumer=mgmt1;
rename med_mgmt_pers_meddenom=mgmt2;
rename totalipdischarges_enc=ipdischarge;
rename totaledvisits_enc=edvisit;
run;
 
%macro propsick(y=,ydist=, out=,offset=);

%if &out.=1 %then %do;
data data&y.;
	set data; 
	outcome=&y.;
run;
proc glimmix data=data&y.  ;
	class pgip  patient_id practice_id gender_cd practicesize propsickQ;
	title "y=&y.,ydist=&ydist.,out=&out.";
	model outcome=pgip gender_cd ageinyears meanage pcpmembers_perpcp practicesize propsickQ year &offset./s dist=&ydist.  ;
	random int/subject=patient_id  type=cs;*repeated equivalent to random intercept model;
	* reference: http://support.sas.com/resources/papers/proceedings12/332-2012.pdf;
	ods output ParameterEstimates=propsickModel&y.;
run;
data propsickModel&y.;
set propsickModel&y.;
	exp=exp(Estimate);
	drop DF tValue ;
proc print;format exp percent7.2;
run;
%end;

%else %if &out.=2 %then %do;
data data&y.;
	length dist $30.;
	set data;
	outcome=(&y.>0);dist="Binary";output;
	outcome=&y.;dist="&ydist.";output;
run;
proc glimmix data=data&y.  method=quad(Qpoints=100)   inititer=200 ;
	class pgip dist patient_id practice_id gender_cd practicesize propsickQ;
	title "y=&y.,ydist=&ydist., out=&out.";
	model outcome(event='1')=dist dist*pgip dist*gender_cd dist*ageinyears dist*meanage dist*pcpmembers_perpcp dist*practicesize dist*propsickQ dist*year/s dist=byobs(dist) noint;
	random int  /subject=patient_id  ;
	ods output ParameterEstimates=propsickModel&y.;
run;
data propsickModel&y.;
set propsickModel&y.;
	exp=exp(Estimate);
	drop DF tValue ;
proc sort;by dist;
proc print;format exp percent7.2;
run;
%end;


%mend propsick;
%propsick(y=MedSurgCost,ydist=Lognormal, out=1);
%propsick(y=MedSurgCost,ydist=Normal, out=1);

%propsick(y=IPCost,ydist=Lognormal, out=2);
%propsick(y=IPCost,ydist=Normal, out=2);

%propsick(y=OPCost,ydist=Lognormal, out=1);
%propsick(y=OPCost,ydist=Normal, out=1);

%propsick(y=EDCost,ydist=Lognormal, out=2);
%propsick(y=EDCost,ydist=Normal, out=2);

%propsick(y=DrugCost,ydist=Lognormal, out=2);
%propsick(y=DrugCost,ydist=Normal, out=2);

%propsick(y=ipdischarge,ydist=Poisson, out=2);
%propsick(y=ipdischarge,ydist=Normal, out=2);

%propsick(y=edvisit,ydist=Poisson, out=2);
%propsick(y=edvisit,ydist=Normal, out=2);

%propsick(y=readmission30,ydist=Poisson, out=2);
%propsick(y=readmission30,ydist=Normal, out=2);
 
%propsick(y=pcpvisits,ydist=Poisson, out=1);
%propsick(y=pcpvisits,ydist=Normal, out=1);

%propsick(y=specvisits,ydist=Poisson, out=2);
%propsick(y=specvisits,ydist=Normal, out=2);

%propsick(y=quality1,ydist=Poisson,out=2);
%propsick(y=quality1,ydist=Normal,out=2);
 
%propsick(y=mgmt1,ydist=Poisson, out=2);
%propsick(y=mgmt1,ydist=Normal, out=2);

 
