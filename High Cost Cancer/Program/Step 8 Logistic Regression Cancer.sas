****************************************************************************
Logistic regression model: does cancer diagnosis drive high cost?
The model is :
HC(Yes/No)=Any Cancers(Yes/No)+ patients characteristics + inhouse CC, right?

Xiner Zhou
3/24/2017
****************************************************************************;

libname data 'D:\Projects\High Cost Segmentation Phase II\Data';
libname denom 'D:\Data\Medicare\Denominator';
libname stdcost 'D:\Data\Medicare\StdCost\Data';
libname frail 'D:\Data\Medicare\Frailty Indicator';
libname cc 'D:\Data\Medicare\MBSF CC';
libname seg 'D:\Projects\High_Cost_Segmentation\Data';
libname icc 'D:\Data\Medicare\Chronic Condition';
  
 
* Demographics: Dual status ;
proc sql;
create table temp1 as
select a.*,case when b.BUYIN_MO>0 then 1 else 0 end as Dual 
from data.CancerHCsample2014 a left join denom.dnmntr2014 b
on a.bene_id=b.bene_id;
quit;

* In-house Chronic Condition; 
proc sql;
create table temp2 as
select a.*,b.*
from temp1 a left join icc.CC2014 b
on a.bene_id=b.bene_id;
quit;


data temp3;
set temp2;
 * cancer indicator;
if CancerH="NO Cancer" then CancerI=0;
else CancerI=1;

array temp {30}  
amiihd amputat arthrit artopen bph 
cancer chrkid chf cystfib dementia 
diabetes endo eyedis hemadis hyperlip 
hyperten immunedis ibd liver lung 
neuromusc osteo paralyt psydis sknulc 
spchrtarr strk sa thyroid  vascdis  ;
do i=1 to 30;
if temp{i}=. then temp{i}=0;
end;
drop i ;

run;
ODS Listing CLOSE;
ODS html file="D:\Projects\High Cost Cancer\Document\Logistic Reg.xls" style=minimal;

proc genmod data=temp3 descending;
where race ne '0' and sex ne '0';
class HC10  CancerH(ref='NO Cancer') 
amiihd(ref='0') amputat(ref='0') arthrit(ref='0') artopen(ref='0') bph(ref='0') 
cancer(ref='0') chrkid(ref='0') chf(ref='0') cystfib(ref='0') dementia(ref='0') 
diabetes(ref='0') endo(ref='0') eyedis(ref='0') hemadis(ref='0') hyperlip(ref='0') 
hyperten(ref='0') immunedis(ref='0') ibd(ref='0') liver(ref='0') lung(ref='0') 
neuromusc(ref='0') osteo(ref='0') paralyt(ref='0') psydis(ref='0') sknulc(ref='0') 
spchrtarr(ref='0') strk(ref='0') sa(ref='0') thyroid(ref='0')  vascdis(ref='0')
sex(ref='1') race(ref='1') dual(ref='0')
;
model HC10 =CancerH /   dist = bin
                           link = logit
                           lrci;
/*age sex race dual
amiihd amputat arthrit artopen bph 
cancer chrkid chf cystfib dementia 
diabetes endo eyedis hemadis hyperlip 
hyperten immunedis ibd liver lung 
neuromusc osteo paralyt psydis sknulc 
spchrtarr strk sa thyroid  vascdis  */

estimate "O.R. Lung vs No Cancer" CancerH 1 0 0 0 0 0 0 0 0 0 0 -1 / exp;
estimate "O.R. Hematologic malignancies (Lymphoma, Leukemia, Multiple Myeloma) vs No Cancer" CancerH 0 1 0 0 0 0 0 0 0 0 0 -1 / exp;
estimate "O.R. GI vs No Cancer" CancerH 0 0 1 0 0 0 0 0 0 0 0 -1 / exp;
estimate "O.R. Breast vs No Cancer" CancerH 0 0 0 1 0 0 0 0 0 0 0 -1 / exp;
estimate "O.R. GU vs No Cancer" CancerH 0 0 0 0 1 0 0 0 0 0 0 -1 / exp;
estimate "O.R. Gyn vs No Cancer" CancerH 0 0 0 0 0 1 0 0 0 0 0 -1 / exp;
estimate "O.R. H and N vs No Cancer" CancerH 0 0 0 0 0 0 1 0 0 0 0 -1 / exp;
estimate "O.R. Sarcoma vs No Cancer" CancerH 0 0 0 0 0 0 0 1 0 0 0 -1 / exp;
estimate "O.R. Melanoma vs No Cancer" CancerH 0 0 0 0 0 0 0 0 1 0 0 -1 / exp;
estimate "O.R. CNS vs No Cancer" CancerH 0 0 0 0 0 0 0 0 0 1 0 -1 / exp;
estimate "O.R. Mets & Other vs No Cancer" CancerH 0 0 0 0 0 0 0 0 0 0 1 -1 / exp;
 
run;


proc genmod data=temp3 descending;
where race ne '0' and sex ne '0';
class HC10  CancerH(ref='NO Cancer') 
amiihd(ref='0') amputat(ref='0') arthrit(ref='0') artopen(ref='0') bph(ref='0') 
cancer(ref='0') chrkid(ref='0') chf(ref='0') cystfib(ref='0') dementia(ref='0') 
diabetes(ref='0') endo(ref='0') eyedis(ref='0') hemadis(ref='0') hyperlip(ref='0') 
hyperten(ref='0') immunedis(ref='0') ibd(ref='0') liver(ref='0') lung(ref='0') 
neuromusc(ref='0') osteo(ref='0') paralyt(ref='0') psydis(ref='0') sknulc(ref='0') 
spchrtarr(ref='0') strk(ref='0') sa(ref='0') thyroid(ref='0')  vascdis(ref='0')
sex(ref='1') race(ref='1') dual(ref='0')
;
model HC10 =CancerH age/   dist = bin
                           link = logit
                           lrci;
/*age sex race dual
amiihd amputat arthrit artopen bph 
cancer chrkid chf cystfib dementia 
diabetes endo eyedis hemadis hyperlip 
hyperten immunedis ibd liver lung 
neuromusc osteo paralyt psydis sknulc 
spchrtarr strk sa thyroid  vascdis  */

estimate "O.R. Lung vs No Cancer" CancerH 1 0 0 0 0 0 0 0 0 0 0 -1 / exp;
estimate "O.R. Hematologic malignancies (Lymphoma, Leukemia, Multiple Myeloma) vs No Cancer" CancerH 0 1 0 0 0 0 0 0 0 0 0 -1 / exp;
estimate "O.R. GI vs No Cancer" CancerH 0 0 1 0 0 0 0 0 0 0 0 -1 / exp;
estimate "O.R. Breast vs No Cancer" CancerH 0 0 0 1 0 0 0 0 0 0 0 -1 / exp;
estimate "O.R. GU vs No Cancer" CancerH 0 0 0 0 1 0 0 0 0 0 0 -1 / exp;
estimate "O.R. Gyn vs No Cancer" CancerH 0 0 0 0 0 1 0 0 0 0 0 -1 / exp;
estimate "O.R. H and N vs No Cancer" CancerH 0 0 0 0 0 0 1 0 0 0 0 -1 / exp;
estimate "O.R. Sarcoma vs No Cancer" CancerH 0 0 0 0 0 0 0 1 0 0 0 -1 / exp;
estimate "O.R. Melanoma vs No Cancer" CancerH 0 0 0 0 0 0 0 0 1 0 0 -1 / exp;
estimate "O.R. CNS vs No Cancer" CancerH 0 0 0 0 0 0 0 0 0 1 0 -1 / exp;
estimate "O.R. Mets & Other vs No Cancer" CancerH 0 0 0 0 0 0 0 0 0 0 1 -1 / exp;
 
run;


proc genmod data=temp3 descending;
where race ne '0' and sex ne '0';
class HC10  CancerH(ref='NO Cancer') 
amiihd(ref='0') amputat(ref='0') arthrit(ref='0') artopen(ref='0') bph(ref='0') 
cancer(ref='0') chrkid(ref='0') chf(ref='0') cystfib(ref='0') dementia(ref='0') 
diabetes(ref='0') endo(ref='0') eyedis(ref='0') hemadis(ref='0') hyperlip(ref='0') 
hyperten(ref='0') immunedis(ref='0') ibd(ref='0') liver(ref='0') lung(ref='0') 
neuromusc(ref='0') osteo(ref='0') paralyt(ref='0') psydis(ref='0') sknulc(ref='0') 
spchrtarr(ref='0') strk(ref='0') sa(ref='0') thyroid(ref='0')  vascdis(ref='0')
sex(ref='1') race(ref='1') dual(ref='0')
;
model HC10 =CancerH age sex race dual
amiihd amputat arthrit artopen bph  chrkid chf cystfib dementia 
diabetes endo eyedis hemadis hyperlip 
hyperten immunedis ibd liver lung 
neuromusc osteo paralyt psydis sknulc 
spchrtarr strk sa thyroid  vascdis/   dist = bin
                           link = logit
                           lrci;
/*age sex race dual
amiihd amputat arthrit artopen bph 
cancer chrkid chf cystfib dementia 
diabetes endo eyedis hemadis hyperlip 
hyperten immunedis ibd liver lung 
neuromusc osteo paralyt psydis sknulc 
spchrtarr strk sa thyroid  vascdis  */

estimate "O.R. Lung vs No Cancer" CancerH 1 0 0 0 0 0 0 0 0 0 0 -1 / exp;
estimate "O.R. Hematologic malignancies (Lymphoma, Leukemia, Multiple Myeloma) vs No Cancer" CancerH 0 1 0 0 0 0 0 0 0 0 0 -1 / exp;
estimate "O.R. GI vs No Cancer" CancerH 0 0 1 0 0 0 0 0 0 0 0 -1 / exp;
estimate "O.R. Breast vs No Cancer" CancerH 0 0 0 1 0 0 0 0 0 0 0 -1 / exp;
estimate "O.R. GU vs No Cancer" CancerH 0 0 0 0 1 0 0 0 0 0 0 -1 / exp;
estimate "O.R. Gyn vs No Cancer" CancerH 0 0 0 0 0 1 0 0 0 0 0 -1 / exp;
estimate "O.R. H and N vs No Cancer" CancerH 0 0 0 0 0 0 1 0 0 0 0 -1 / exp;
estimate "O.R. Sarcoma vs No Cancer" CancerH 0 0 0 0 0 0 0 1 0 0 0 -1 / exp;
estimate "O.R. Melanoma vs No Cancer" CancerH 0 0 0 0 0 0 0 0 1 0 0 -1 / exp;
estimate "O.R. CNS vs No Cancer" CancerH 0 0 0 0 0 0 0 0 0 1 0 -1 / exp;
estimate "O.R. Mets & Other vs No Cancer" CancerH 0 0 0 0 0 0 0 0 0 0 1 -1 / exp;
 
run;

proc genmod data=temp3 descending;
where race ne '0' and sex ne '0';
class HC10  CancerI(ref='0') 
amiihd(ref='0') amputat(ref='0') arthrit(ref='0') artopen(ref='0') bph(ref='0') 
cancer(ref='0') chrkid(ref='0') chf(ref='0') cystfib(ref='0') dementia(ref='0') 
diabetes(ref='0') endo(ref='0') eyedis(ref='0') hemadis(ref='0') hyperlip(ref='0') 
hyperten(ref='0') immunedis(ref='0') ibd(ref='0') liver(ref='0') lung(ref='0') 
neuromusc(ref='0') osteo(ref='0') paralyt(ref='0') psydis(ref='0') sknulc(ref='0') 
spchrtarr(ref='0') strk(ref='0') sa(ref='0') thyroid(ref='0')  vascdis(ref='0')
sex(ref='1') race(ref='1') dual(ref='0')
;
model HC10 =CancerI   /   dist = bin
                           link = logit
                           lrci;
estimate "O.R. Cancer1-10 vs No" CancerI 1 -1 / exp;
run;

proc genmod data=temp3 descending;
where race ne '0' and sex ne '0';
class HC10  CancerI(ref='0') 
amiihd(ref='0') amputat(ref='0') arthrit(ref='0') artopen(ref='0') bph(ref='0') 
cancer(ref='0') chrkid(ref='0') chf(ref='0') cystfib(ref='0') dementia(ref='0') 
diabetes(ref='0') endo(ref='0') eyedis(ref='0') hemadis(ref='0') hyperlip(ref='0') 
hyperten(ref='0') immunedis(ref='0') ibd(ref='0') liver(ref='0') lung(ref='0') 
neuromusc(ref='0') osteo(ref='0') paralyt(ref='0') psydis(ref='0') sknulc(ref='0') 
spchrtarr(ref='0') strk(ref='0') sa(ref='0') thyroid(ref='0')  vascdis(ref='0')
sex(ref='1') race(ref='1') dual(ref='0')
;
model HC10 =CancerI age   /   dist = bin
                           link = logit
                           lrci;
estimate "O.R. Cancer1-10 vs No" CancerI 1 -1 / exp;
run;

proc genmod data=temp3 descending;
where race ne '0' and sex ne '0';
class HC10  CancerI(ref='0') 
amiihd(ref='0') amputat(ref='0') arthrit(ref='0') artopen(ref='0') bph(ref='0') 
cancer(ref='0') chrkid(ref='0') chf(ref='0') cystfib(ref='0') dementia(ref='0') 
diabetes(ref='0') endo(ref='0') eyedis(ref='0') hemadis(ref='0') hyperlip(ref='0') 
hyperten(ref='0') immunedis(ref='0') ibd(ref='0') liver(ref='0') lung(ref='0') 
neuromusc(ref='0') osteo(ref='0') paralyt(ref='0') psydis(ref='0') sknulc(ref='0') 
spchrtarr(ref='0') strk(ref='0') sa(ref='0') thyroid(ref='0')  vascdis(ref='0')
sex(ref='1') race(ref='1') dual(ref='0')
;
model HC10 =CancerI age sex race dual
amiihd amputat arthrit artopen bph 
chrkid chf cystfib dementia 
diabetes endo eyedis hemadis hyperlip 
hyperten immunedis ibd liver lung 
neuromusc osteo paralyt psydis sknulc 
spchrtarr strk sa thyroid  vascdis  /   dist = bin
                           link = logit
                           lrci;
estimate "O.R. Cancer1-10 vs No" CancerI 1 -1 / exp;
run;
ODS html close;
ODS Listing; 
