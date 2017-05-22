********************************
Predictive Model
Xiner Zhou
9/2/2015
*********************************;
libname APCD 'C:\data\Data\APCD\Massachusetts\Data';

%let byyear=2012;
%let bymoney=cost;

proc sort data=APCD.data out=data&byyear.;
where SubmissionYear=&byyear. ;
by  MemberLinkEID descending total_&bymoney.;
run;

*Create total cost and utilization for patients having multiple insurances;
proc sql;
create table temp1 as
select *,sum(IPstay1) as total_IPstay1,sum(IPstay2) as total_IPstay2,sum(IPstay3) as total_IPstay3,sum(IPstay4) as total_IPstay4,sum(IPstay5) as total_IPstay5,sum(IPstay6) as total_IPstay6,
sum(ipLOS1) as total_ipLOS1,sum(ipLOS2) as total_ipLOS2,sum(ipLOS3) as total_ipLOS3,sum(ipLOS4) as total_ipLOS4,sum(ipLOS5) as total_ipLOS5,sum(ipLOS6) as total_ipLOS6,
sum(ipcost1) as total_ipcost1,sum(ipcost2) as total_ipcost2, sum(ipcost3) as total_ipcost3, sum(ipcost4) as total_ipcost4, sum(ipcost5) as total_ipcost5, sum(ipcost6) as total_ipcost6, 
sum(ipspending1) as total_ipspending1,sum(ipspending2) as total_ipspending2,sum(ipspending3) as total_ipspending3,sum(ipspending4) as total_ipspending4,sum(ipspending5) as total_ipspending5,sum(ipspending6) as total_ipspending6,

sum(opvisit) as total_opvisit, sum(opcost) as total_opcost, sum(opspending) as total_opspending, 

sum(PhysicianEvent1) as total_PhysicianEvent1,sum(PhysicianEvent2) as total_PhysicianEvent2,sum(PhysicianEvent3) as total_PhysicianEvent3,sum(PhysicianEvent4) as total_PhysicianEvent4,
sum(PhysicianEvent5) as total_PhysicianEvent5,sum(PhysicianEvent6) as total_PhysicianEvent6,sum(PhysicianEvent7) as total_PhysicianEvent7,sum(PhysicianEvent8) as total_PhysicianEvent8,
sum(PhysicianEvent9) as total_PhysicianEvent9,sum(PhysicianEvent10) as total_PhysicianEvent10,sum(PhysicianEvent11) as total_PhysicianEvent11,sum(PhysicianEvent12) as total_PhysicianEvent12,
sum(PhysicianEvent13) as total_PhysicianEvent13,sum(PhysicianEvent14) as total_PhysicianEvent14, 

sum(PhysicianCost1) as total_PhysicianCost1,sum(PhysicianCost2) as total_PhysicianCost2,sum(PhysicianCost3) as total_PhysicianCost3,sum(PhysicianCost4) as total_PhysicianCost4,
sum(PhysicianCost5) as total_PhysicianCost5,sum(PhysicianCost6) as total_PhysicianCost6,sum(PhysicianCost7) as total_PhysicianCost7,sum(PhysicianCost8) as total_PhysicianCost8,
sum(PhysicianCost9) as total_PhysicianCost9,sum(PhysicianCost10) as total_PhysicianCost10,sum(PhysicianCost11) as total_PhysicianCost11,sum(PhysicianCost12) as total_PhysicianCost12,
sum(PhysicianCost13) as total_PhysicianCost13,sum(PhysicianCost14) as total_PhysicianCost14,
 
sum(PhysicianSpending1) as total_PhysicianSpending1,sum(PhysicianSpending2) as total_PhysicianSpending2,sum(PhysicianSpending3) as total_PhysicianSpending3,sum(PhysicianSpending4) as total_PhysicianSpending4,
sum(PhysicianSpending5) as total_PhysicianSpending5,sum(PhysicianSpending6) as total_PhysicianSpending6,sum(PhysicianSpending7) as total_PhysicianSpending7,sum(PhysicianSpending8) as total_PhysicianSpending8,
sum(PhysicianSpending9) as total_PhysicianSpending9,sum(PhysicianSpending10) as total_PhysicianSpending10,sum(PhysicianSpending11) as total_PhysicianSpending11,sum(PhysicianSpending12) as total_PhysicianSpending12,
sum(PhysicianSpending13) as total_PhysicianSpending13,sum(PhysicianSpending14) as total_PhysicianSpending14,
 
sum(PhysicianEvent) as total_PhysicianEvent, sum(PhysicianCost) as total_PhysicianCost, sum(PhysicianSpending) as total_PhysicianSpending,

sum(HHAEvent) as total_HHAEvent, sum(HHALOS) as total_HHALOS,sum(HHAcost) as total_HHAcost, sum(HHAspending) as total_HHAspending,

sum(HospiceEvent) as total_HospiceEvent, sum(HospiceLOS) as total_HospiceLOS,sum(Hospicecost) as total_Hospicecost, sum(Hospicespending) as total_Hospicespending,

sum(SNFEvent) as total_SNFEvent, sum(SNFLOS) as total_SNFLOS,sum(SNFcost) as total_SNFcost, sum(SNFspending) as total_SNFspending,

sum(total_cost) as total_total_cost, sum(total_spending) as total_total_spending

from data&byyear.
group by MemberLinkEID;
quit;

*Keep 1-record per beneficiary with the largest proportion of money;
proc sort data=temp1;by MemberLinkEID descending total_&bymoney.;run;
proc sort data=temp1 nodupkey;by MemberLinkEID;run;

data temp1;set temp1;where orgid not in (10943,11259);run;

*Identity 10% High Cost in a year;
*reverses the order of the ranks so that the highest value receives the rank of 1;
* ties assigns the best possible rank to tied values;
proc rank data=temp1 out=temp2 percent descending ;
var total_&bymoney.;
ranks rank_total_&bymoney.;
run;

proc sort data=temp2;by rank_total_&bymoney.;run;

data HighCost&byyear.;
set temp2;
if rank_total_&bymoney.<=10 then highCost=1;
else  highCost=0;
*age group;
if age<18 then AgeGroup=1;
else if age>=18 and age<=64 then AgeGroup=2;
else if Age>65 then AgeGroup=3;
*Payer;

if type2='' then payer=type1;
else if MedicaidIndicator='True' then do;
	if type1='Medicaid' or type2='Medicaid' then payer='Medicaid';
	else if type1='Medicaid Managed Care' or type2='Medicaid Managed Care' then payer='Medicaid Managed Care';
end;
else if type1='Medicare Advantage' or type2='Medicare Advantage' then payer='Medicare Advantage';
else payer='Other Private Plans';

*Gender;
if gender='F' then sex=1;else if gender='M' then sex=0;

* IP sum;
total_IPStay=total_IPStay1+total_IPStay2+total_IPStay3+total_IPStay4+total_IPStay5+total_IPStay6;
total_IPLOS=total_IPLOS1+total_IPLOS2+total_IPLOS3+total_IPLOS4+total_IPLOS5+total_IPLOS6;
total_IPCost=total_IPCost1+total_IPCost2+total_IPCost3+total_IPCost4+total_IPCost5+total_IPCost6;
total_IPSpending=total_IPSpending1+total_IPSpending2+total_IPSpending3+total_IPSpending4+total_IPSpending5+total_IPSpending6;
run;

data temp;
set highcost2011 highcost2012;
run;

proc logistic data=temp;
class sex(ref='0')
amiihd(ref='0') 
amputat(ref='0')
arthrit(ref='0') 
artopen(ref='0')
bph(ref='0') 
cancer(ref='0')
chrkid(ref='0')
chf(ref='0')
cystfib(ref='0')
dementia(ref='0')
diabetes(ref='0')
endo(ref='0')
eyedis(ref='0')
hemadis(ref='0')
hyperlip(ref='0')
hyperten(ref='0')
immunedis(ref='0')
ibd(ref='0')
liver(ref='0')
lung(ref='0')
neuromusc(ref='0')
osteo(ref='0')
paralyt(ref='0')
psydis(ref='0')
sknulc(ref='0')
spchrtarr(ref='0')
strk(ref='0')
sa(ref='0')
thyroid(ref='0')
vascdis(ref='0');
model highcost(event='1')=age sex 
amiihd 
amputat 
arthrit 
artopen 
bph 
cancer 
chrkid 
chf 
cystfib 
dementia 
diabetes 
endo 
eyedis 
hemadis 
hyperlip 
hyperten 
immunedis 
ibd 
liver 
lung 
neuromusc 
osteo 
paralyt 
psydis 
sknulc 
spchrtarr 
strk 
sa 
thyroid 
vascdis 
frailty_Num 
Mental 
;
run;
