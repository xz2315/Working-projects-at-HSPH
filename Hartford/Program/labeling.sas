proc format;
value CPOE_PN_
1="Had Medication CPOE & Physician Note anytime during 2008-2013"
2="Medication CPOE only, no Physician Note anytime during 2008-2013"
3="Physician Note only, no Medication CPOE anytime during 2008-2013"
4="Neither anytime during 2008-2013"
;
run;

proc format;
value CPOE_PN2_
1="Had Medication CPOE and PN during any point 2008-2010 "
2="Had Medication CPOE and PN during any point 2011-2013 "
3="Neither"
;
run;

proc format;
value SameVendor_
1="Same inpatient and outpatient vendor"
2="Not the same vendor"
;
run;

proc format;
value ruca_
3="Urban (RUCA code 1)"
2="Suburban (RUCA codes 2 through 6)"
1="Rural (RUCA codes 7 through 10)"
;
run;
 
proc format;
value hospsize_
1="Small"
2="Medium"
3="Large"
;
run;

proc format;
value teaching1_
1="Teaching Hospital"
2="Non-Teaching Hospital"

;
run;

proc format;
value SNH_
1="Safety-Net Hospital (Top Quartile DSH%)"
2="Non-Safety-Net Hospital"
;
run;

proc format;
value Adopter_
1="Early Adopters:>8 Functionalities at Baseline"
2="Mid Adopters:4-7 Functionalities at Baseline"
3="Late Adopters:<4 Functionalities at Baseline"
;
run;

proc format;
value subgroup_
1="Had Documentation and Results viewing at Baseline"
2="Had Results Viewing at Baseline, no Documentation"
3="Had Documentation at Baseline, no Results Viewing"
4="Neither"
;
run;
 
