libname aha 'C:\data\Data\Hospital\AHA\Annual_Survey\Data';
libname readm 'C:\data\Data\Hospital\Medicare_Inpt\Readmission\data';

data aha10;
  set aha.aha10;
  if serv=10;
  if hosp_reg4^=5;
  if profit2^=4;
run;

data readm10in;
  length provider $ 6;
  set readm.adjreadm36meas30day2010(keep=provider NDmeas_amiall rawreadmmeas_amiall30day
                                         preadmmeas_amiall30day adjreadmmeas_amiall30day
                                         allreadmmeas_amiall30day NDmeas_chfall
                                         rawreadmmeas_chfall30day preadmmeas_chfall30day
                                         adjreadmmeas_chfall30day allreadmmeas_chfall30day
                                         NDmeas_pnall rawreadmmeas_pnall30day
                                         preadmmeas_pnall30day adjreadmmeas_pnall30day
                                         allreadmmeas_pnall30day
                                    rename=(provider=providerin));
  provider=providerin;
  obsamireadm10=rawreadmmeas_amiall30day * NDmeas_amiall;
  obschfreadm10=rawreadmmeas_chfall30day * NDmeas_chfall;
  obspnreadm10=rawreadmmeas_pnall30day * NDmeas_pnall;
  obsadjamireadm10=adjreadmmeas_amiall30day * NDmeas_amiall;
  obsadjchfreadm10=adjreadmmeas_chfall30day * NDmeas_chfall;
  obsadjpnreadm10=adjreadmmeas_pnall30day * NDmeas_pnall;
  nallreadm10=sum(NDmeas_amiall,NDmeas_chfall,NDmeas_pnall);
  drop providerin;
run;

proc sort data=readm10in;
  by provider;
run;

proc means data=readm10in noprint nway sum;
  var NDmeas_amiall obsamireadm10 obsadjamireadm10 NDmeas_chfall obschfreadm10 obsadjchfreadm10
      NDmeas_pnall obspnreadm10 obsadjpnreadm10;
  output out=prepoverallreadm10(drop=_FREQ_ _TYPE_) sum=;
run;

data overallreadm10;
  set prepoverallreadm10;
  overallamireadm10    = obsamireadm10 / NDmeas_amiall;
  overallchfreadm10    = obschfreadm10 / NDmeas_chfall;
  overallpnreadm10     = obspnreadm10  / NDmeas_pnall;
  overalladjamireadm10 = obsadjamireadm10 / NDmeas_amiall;
  overalladjchfreadm10 = obsadjchfreadm10 / NDmeas_chfall;
  overalladjpnreadm10  = obsadjpnreadm10  / NDmeas_pnall;

  overallallreadm10    = (sum(obsamireadm10, obschfreadm10, obspnreadm10))/(sum(NDmeas_amiall,
                              NDmeas_chfall, NDmeas_pnall));
  overalladjallreadm10 = (sum(obsadjamireadm10, obsadjchfreadm10, obsadjpnreadm10))/
                         (sum(NDmeas_amiall, NDmeas_chfall, NDmeas_pnall));
run;

data readm10;
  if _N_=1 then set overallreadm10(keep=overallamireadm10 overallchfreadm10 overallpnreadm10
                                   overalladjamireadm10 overalladjchfreadm10 overalladjpnreadm10
                                   overallallreadm10 overalladjallreadm10);

  set readm10in;

  allreadm10=( sum(obsamireadm10, obschfreadm10, obspnreadm10) /
               sum(overallallreadm10*NDmeas_amiall, overallchfreadm10*NDmeas_chfall,
                   overalladjpnreadm10*NDmeas_pnall) ) * overallallreadm10;

  adjallreadm10=( sum(obsadjamireadm10, obsadjchfreadm10, obsadjpnreadm10) /
                  sum(overalladjamireadm10*NDmeas_amiall, overalladjchfreadm10*NDmeas_chfall,
                      overalladjpnreadm10*NDmeas_pnall) ) * overalladjallreadm10;
  keep provider allreadm10 adjallreadm10;
run;

proc sort data=aha10;
  by provider;
proc sort data=readm10;
  by provider;
data ahareadm10;
  merge aha10(in=in1) readm10;
  by provider;
  if in1;
  if adjallreadm10 not in (1, .);
run;

/*
proc freq data=nonmshpotentialq1s;
  tables adjallreadm10quints;
run;

proc freq data=nonmshpotentialq1thru4s;
  tables adjallreadm10quints;
run;

proc freq data=nonmshpotentialq5s;
  tables adjallreadm10quints;
run;
*/

data mshexcludes;
  length provider $ 6;
  input provider; /*the first 11 were manually added from Lena's current list 3-6-14*/
  datalines; 
100086
330234
010032
050137
050723
140155
190160
230070
360035
450675
450851
190034
190078
140208
140182
140250
140048
420082
360027
340070
050320
340109
390142
450488
190133
250012
050043
050305
190044
420027
210023
340084
050056
110071
050245
110074
110115
450615
310064
100131
190099
420056
040114
440133
100093
100088
010149
010023
250141
250034
250100
440048
440131
260032
420016
110045
100121
190065
100032
080004
452017
450021
250049
340186
420067
230089
230130
190050
050531
330169
340071
010058
250007
440181
250093
210013
490136
490059
490011
490094
420065
220031
230151
390076
070010
160101
330009
330233
330056
010139
050752
100039
010112
010110
110113
190164
050149
332006
210039
111334
340028
310092
310092
100254
490089
220017
420010
420091
340098
340166
340113
340130
050625
440161
050740
050739
490021
340020
100161
250072
450770
490120
420019
210030
420062
390026
310016
360163
260180
080001
450034
450573
190041
450832
190019
450801
190027
010101
210035
490112
310009
420069
150056
010073
360180
340021
050771
420101
110027
110089
110164
110201
450299
420030
110105
100234
520051
340068
050089
010034
150074
490098
050060
050276
420049
010137
310014
010164
452032
340131
010008
110104
040042
250096
192050
390180
450597
490019
010099
010021
050122
490075
190003
340144
010092
190118
360038
110226
112006
110076
440159
250082
060011
230273
210051
110177
450803
110186
050079
100106
110092
110194
110073
040051
340073
340030
340120
340155
440072
190011
190122
010029
190208
420089
110075
310083
450210
450580
450658
450188
450749
450083
450884
450194
450694
010027
110026
110109
110078
110010
110183
330219
440104
360082
110142
010148
060028
110125
450348
490023
340115
110190
330193
330353
260021
040019
250078
210060
330372
190140
340036
520177
250123
440035
170074
090001
420020
010047
250025
100130
050471
210056
360134
360052
450032
450037
140008
110121
110079
360133
360017
340127
040069
190257
010051
420078
250099
250015
010091
450214
192046
390290
010095
490013
340151
420072
210034
210006
330240
230104
450289
040080
440174
100030
040085
450475
240004
490118
230135
230053
230204
110191
340107
340004
250117
010138
450101
370001
050135
210004
140133
190114
100125
390111
110069
450638
210048
090003
040076
190009
110200
440115
050438
230132
360101
190054
010152
140191
490040
490122
330397
340039
110130
010102
010168
100022
100142
010024
010128
140177
440002
330127
330014
250104
250060
110100
040071
180051
190053
180040
360016
110038
140124
490020
210029
210009
340090
450039
050411
050138
050561
050076
050075
050512
050710
050531
050541
050070
050073
050140
050674
050686
330005
230297
310086
420048
250051
102010
452023
052032
052037
052034
330202
250057
340037
330201
010150
050373
050376
190002
190060
420066
010052
230021
670011
050581
050204
190020
010025
390195
190145
210055
420038
100246
222006
340027
330119
190183
310074
330080
140179
050485
330152
330195
450702
140083
420064
050663
050644
140082
192035
310061
140276
190098
192029
360087
250038
250124
040067
450530
340132
030022
420055
250085
420054
340133
490041
490022
210038
360143
490017
450465
210045
110111
230141
420051
420005
110128
010069
010049
110107
190005
450518
110034
040088
040091
010114
090004
450211
450346
450005
450184
450848
110036
450610
450684
210037
100179
310091
490079
140185
110132
250019
100285
110101
050468
100230
100281
490069
390156
140158
210008
330259
390116
450723
450051
442013
440168
050590
450358
140197
150002
450820
440049
450844
360059
450152
330199
100277
360051
140100
190144
252003
260113
010113
010120
190245
330059
250059
390108
340060
190116
340091
330024
140018
330086
310054
420004
450656
450508
080006
340147
440111
330027
250122
250084
190007
100139
450447
010078
250043
340141
330055
330236
330101
310002
420053
110018
251332
330065
340047
330385
330390
250004
250067
250020
250126
230013
190015
390132
100029
290005
050367
440065
190086
010145
190204
210040
140281
140206
250042
330316
140301
190106
230142
230020
190135
190202
190036
190274
110150
360085
370057
250050
050742
340042
190017
100006
370093
040050
190064
310029
190102
050018
050277
450747
420018
420086
100269
110163
050024
450659
450015
440156
450400
010054
180117
260070
330002
210019
390226
110153
340159
110007
010109
110215
110083
420002
340040
100167
450672
230207
050231
490113
390223
340053
060014
210003
010103
252008
230019
090006
170146
140300
100232
330231
142010
190026
490123
252009
440189
440152
420068
450123
450795
670002
450683
260027
190151
330028
250081
250138
190175
250031
050292
490052
490084
490130
010046
340099
310024
110091
420087
060032
140068
340015
390304
250069
140063
140119
010065
190218
100025
140151
140095
310076
070002
440228
140080
440183
140224
260105
260138
150004
310096
330290
340024
050228
050167
340106
110003
190025
340008
312019
102017
420071
490119
490093
490046
490007
490044
490066
100113
100001
100102
250079
450839
490037
090005
140213
210012
230024
250040
330078
110122
450143
330184
250058
110219
110122
230085
310032
360144
140181
250095
490092
010001
110025
110146
340050
440197
210054
110165
490097
490090
490067
010015
190205
250097
110031
420007
102012
372012
092002
450630
190088
010144
420036
420026
260104
260091
210011
260210
360262
370037
100067
330399
140103
050129
150008
190079
450431
250048
360064
190242
140118
080003
110129
050104
190125
310021
192016
140172
230165
330395
330208
150047
450035
230029
450011
100075
330006
310019
110043
110024
450193
050047
330046
140180
050191
110006
210028
100288
050002
360037
040007
360112
010056
100307
010038
040072
360020
110044
330350
050101
100135
110015
110135
190014
050111
390027
190008
450135
452043
110064
360068
190004
390174
140115
110095
250010
450080
140077
190046
250017
050575
420079
250128
310027
450187
110039
452074
010126
260048
260102
190176
420070
010167
040016
360115
210024
090008
450124
050599
140088
140150
180141
210002
340061
010087
450690
450018
670019
110028
360003
310119
250001
360137
360075
190006
290007
010033
060024
170040
100009
360048
490009
212007
390128
390028
390164
110002
420043
290021
010118
490032
050517
190167
490050
310057
140084
190161
450200
340173
340069
420039
110046
210016
110086
090011
250077
110124
340010
510086
110143
250094
110203
190081
110016
450644
190039
140049
390090
360141
140240
150129
520136
330304
190111
340126
190090
250027
150024
190201
330396
450484
330221
070022
250061
;

proc sort data=ahareadm10;
  by provider;
proc sort data=mshexcludes;
  by provider;
data mshpotentials;
  merge ahareadm10(in=in1) mshexcludes(in=in2);
  by provider;
  if not in2;
run;

proc sort data=mshpotentials;
  by descending propblk10;
run;

data mshadds;
  retain provider id MSHDesignation mname MLOCCITY MLOCADDR MSTATE zip AREA TELNO note;
  length MSHDesignation $ 15 note $ 50;
  set mshpotentials;
  if _N_ <= 75;
  retain i 1;
  if _N_ <= 59 then note="MSH Replacement"; else do;
    note="Alternate MSH Replacement "||compress(put(i,2.))||" if needed";
    i=i+1;
  end;
  MSHDesignation='MSH';
  keep provider id MSHDesignation mname MLOCCITY MLOCADDR MSTATE zip AREA TELNO note;
run;

/*
*added 11-5-14;
proc export data=mshadds outfile='C:\data\Projects\Minority_Readmissions\Output\additionalmshhosps_11-5-14.xlsx' dbms=xlsx replace;
run;
*/

data excludenonmsh;
  length provider $ 6;
  input provider;
  datalines;
010089
500001
200025
200034
200041
131328
130013
130049
050464
450697
450678
240052
240100
150006
230066
230277
010090
010100
450451
450351
150091
230040
180038
060114
060027
060100
060034
530011
530014
050078
260162
330157
330058
170122
170123
150158
150001
150005
160045
450073
450229
360185
360131
360161
100023
452092
100118
280130
370054
372019
270049
270012
270014
270057
270017
270051
050380
050038
520136
520138
360032
442016
450133
460019
460014
210044
040137
180025
180016
380004
380082
190146
321308
500049
500002
500016
500058
050211
450718
450272
230005
330047
030011
030085
030010
052047
050254
050225
050498
490005
490018
380002
380040
380020
380075
380018
380052
100168
390006
390013
390001
260186
150018
150076
320018
330226
520100
520087
230072
230059
230003
140002
030094
050238
140242
050308
340171
340129
340032
340119
110001
050417
050174
050090
160153
450610
050609
050069
520002
520019
520202
390100
390138
100043
100063
100055
150038
150007
110030
290002
460042
460006
460005
460010
050159
050357
450231
450755
150112
390009
390199
140161
260085
450087
450203
340017
340041
450108
450092
450007
050194
670024
140258
100081
070040
420023
420009
442012
020017
020001
310005
450024
450002
370089
520193
520075
520198
520097
520160
520076
050496
050180
030007
360079
360197
360092
450827
100267
100070
053306
050054
060013
060076
450280
230121
420033
450851
470001
230034
060015
070017
070031
070034
010011
200063
200021
200037
200024
390035
390070
360212
140148
140135
150034
100012
010083
450754
010157
010019
010012
150045
520170
520189
230217
180087
180017
180027
180056
490111
450709
210022
510039
100181
100187
140064
140120
330215
150157
150059
240036
450340
360078
100212
100071
500041
500003
410012
280013
370032
100007
050125
210043
390114
220051
050457
260065
360107
440017
440064
030088
030103
030036
030119
040036
040014
380009
380089
320001
320074
240117
220019
050195
360056
330182
230069
230092
050280
390119
390192
390079
260017
260011
260015
370023
370002
370020
370139
330053
230047
030037
300001
300011
180011
330090
520083
520095
520109
310047
390162
390197
360035
440227
140059
170039
030061
050723
330286
330107
260200
240038
240050
050455
050295
350070
290041
490107
110023
140054
050348
050226
050570
050168
520011
390058
390004
390046
330194
390032
100127
310038
310052
230146
360039
360014
050243
050045
240001
150030
100217
220100
170142
100008
460047
050232
050082
120014
120028
100132
390268
390086
140007
140186
140155
140228
260190
450675
050677
340002
340051
340184
340087
450235
330104
140051
070035
100109
440015
440173
440056
440031
440011
310060
170104
170009
330267
370091
370078
370025
370114
360174
360013
360044
450241
450271
240053
100276
100228
100224
100200
100086
450841
060075
450379
220095
220063
230070
230133
100191
150012
180035
310118
070039
010130
010086
450878
330064
140032
140019
240084
250162
010129
450270
010032
010146
150075
180149
180105
490012
490053
490002
510048
101312
531316
530032
330177
330211
330245
190160
160122
160008
450306
010036
010007
010097
340097
450163
280111
271347
390037
390157
050510
260147
260024
360058
440025
450653
450144
460035
460017
040011
040134
180138
320003
320033
320038
240166
240006
240022
240014
500148
500037
050434
050359
050397
100275
390003
390031
260209
150102
320067
320085
320030
370138
370030
370103
370007
330238
330073
330037
430014
431321
180069
180020
180115
180080
180043
180002
180128
180139
180019
180018
330151
330085
390220
360242
440194
440200
220002
220162
220116
220110
220088
220119
140034
140137
140184
050025
170010
170075
170110
170166
050205
330246
160147
260074
260050
260142
250044
110205
050690
050028
160005
050744
330111
060043
390219
390184
390016
390008
440060
440070
440130
440109
360203
050279
050423
240076
290020
450578
230216
150163
150164
390112
390056
390052
140234
140012
140116
140143
260057
450872
050040
050137
450177
050296
420080
330273
330004
330224
140252
180079
180064
040027
450283
100117
230108
020026
020024
050588
330234
370099
370041
370228
370072
520116
050689
030062
030117
440040
440010
440192
440151
360175
450746
450369
450654
060119
060118
060049
220029
220098
030102
330128
120010
040142
450008
390095
320069
050704
222002
450306
;
/*450306 added on 11-5-17*/

proc sort data=ahareadm10;
  by provider;
proc sort data=mshexcludes;
  by provider;
proc sort data=mshadds;
  by provider;
data nonmshpotentials;
  merge ahareadm10(in=in1) mshexcludes(in=in2) mshadds(in=in3 keep=provider);
  by provider;
  if not in2;
  if not in3;
  if adjallreadm10 not in (.,0);
run;

proc sort data=nonmshpotentials;
  by adjallreadm10;
proc rank data=nonmshpotentials groups=5 out=nonmshpotentialsranked;
  var adjallreadm10;
  ranks adjallreadm10quints;
run;

/*
ods rtf;
proc freq data=nonmshpotentialsranked;
  tables adjallreadm10quints;
run;
ods rtf close;
*/

proc sort data=nonmshpotentialsranked;
  by provider;
proc sort data=excludenonmsh;
  by provider;
data nonmshleftover;
  merge nonmshpotentialsranked excludenonmsh(in=in1);
  by provider;
  if not in1;
run;

data nonmshpotentialq1s nonmshpotentialq1thru4s nonmshpotentialq5s;
  length MSHDesignation $ 15;
  set nonmshleftover;
  if adjallreadm10quints=0 then do;
    MSHDesignation='Non-MSH Q1';
    output nonmshpotentialq1s;
  end; else if adjallreadm10quints in (1,2,3) then do;
    MSHDesignation='Non-MSH Q2-4';
    output nonmshpotentialq1thru4s;
  end; else if adjallreadm10quints=4 then do;
    MSHDesignation='Non-MSH Q5';
    output nonmshpotentialq5s;
  end;
run;

proc surveyselect data=nonmshpotentialq1s out=nonmshq1s method=srs n=91 seed=098234;                /*previously n=17*/
run;

proc surveyselect data=nonmshpotentialq1thru4s out=nonmshq1thru4s method=srs n=87 seed=0982309483;  /*previously n=13*/
run;

proc surveyselect data=nonmshpotentialq5s out=nonmshq5s method=srs n=90 seed=098126334;             /*previously n=16*/
run;

data nonmshhosps;
  retain provider id MSHDesignation mname MLOCCITY MLOCADDR MSTATE zip AREA TELNO note;
  length note $ 50;
  set nonmshq1s nonmshq1thru4s nonmshq5s;
  retain i j k 1;
  if MSHDesignation='Non-MSH Q1' and _N_<=7 then note="Non-MSH Q1 Replacement";
  if MSHDesignation='Non-MSH Q1' and 7<_N_<18 then do;
    note="Non-MSH Q1 Replacement Alternative "||compress(put(i,2.))||" if needed";
    i=i+1;
  end;
  if MSHDesignation='Non-MSH Q2-4' and 18<=_N_<=20 then note="Non-MSH Q2-4 Replacement";
  if MSHDesignation='Non-MSH Q2-4' and 20<_N_<31 then do;
    note="Non-MSH Q2-4 Replacement Alternative "||compress(put(j,2.))||" if needed";
    j=j+1;
  end;
  if MSHDesignation='Non-MSH Q5' and 31<=_N_<=36 then note="Non-MSH Q5 Replacement";
  if MSHDesignation='Non-MSH Q5' and _N_>36 then do;
    note="Non-MSH Q5 Replacement Alternative "||compress(put(k,2.))||" if needed";
    k=k+1;
  end;
  keep provider id MSHDesignation mname MLOCCITY MLOCADDR MSTATE zip AREA TELNO note;
run;

proc sort data=mshadds;
  by MSHDesignation note;
proc sort data=nonmshhosps;
  by MSHDesignation note;
data additionalsamplehosps;
  set mshadds nonmshhosps;
run;

proc export data=additionalsamplehosps outfile='C:\data\Projects\Minority_Readmissions\Output\additionalhospitals_raw.xlsx'
            dbms=xlsx replace;
run;






data uptodateids;
  input provider $;
  datalines;
050277
110122
190116
190064
390111
340030
110031
110132
370093
190099
110016
010099
420079
190015
340042
100030
010145
110153
010021
520051
010164
050292
100135
110125
050111
250034
010008
340061
340020
490041
420036
110089
250085
110135
420082
040007
190025
110026
110083
420101
490079
050076
222006
340131
440133
450200
250104
190026
340113
180141
040051
010167
040016
330027
330221
140281
420038
250061
050191
190019
110010
332006
190027
110092
450124
050024
360143
440048
050047
340091
140224
490059
440228
230089
250043
450400
340186
360112
450508
140084
110091
490112
360180
440189
010065
010001
290007
390180
010144
160101
110003
490123
310076
102010
250020
110069
210048
340073
310091
190257
110128
310064
100102
450034
420002
110191
340098
490130
360163
670019
360016
220017
450184
290005
330195
250138
010149
010137
010095
010110
010118
010102
010112
010087
010148
010091
010015
010109
010069
010024
010120
010150
010052
010103
010029
010168
010023
010114
040085
040019
040042
040071
040091
040050
040067
040088
050138
050739
050468
050075
050149
050320
052032
050104
050411
050742
050752
050644
050079
050043
050305
050376
050089
052034
050135
050373
050674
050101
050228
090008
090003
092002
090006
090011
090001
090004
080003
100130
100001
100167
100039
100022
100288
110079
110226
110219
110115
110078
112006
110076
192046
212007
260021
260048
260105
260210
260091
260032
260104
260070
250060
250038
250042
250093
250082
250099
250122
250051
250079
250012
251332
250031
250084
250072
250001
250049
250097
250067
250069
250081
250048
250015
250050
250077
250100
250017
250058
250027
250141
340099
340127
340106
340151
340133
330390
330002
360038
420056
440111
340069
310083
310002
310119
310092
310074
310096
310061
310027
310014
330240
330202
330350
330056
330233
330086
330231
330009
330152
330385
450659
452043
450035
450015
450803
452074
330199
330396
330399
330127
330395
330080
330219
330046
330014
330059
330236
330078
330006
330372
330259
330184
490093
490067
490032
490098
490017
490044
490092
490037
490007
220031
210013
210003
210060
210054
210051
210040
210012
000000
312019
190205
050531
190167
420039
190078
102012
210034
450644
450530
050561
252003
420026
110101
490046
050140
310016
450210
100142
310019
250078
450573
050245
450615
100093
420071
230135
110002
140208
110025
050531
050686
450770
450021
180051
490052
110146
490040
100009
100139
010033
390128
110183
050167
100307
250124
490119
490021
190044
050073
450214
340090
050590
390226
190004
210028
250096
330024
050512
140180
210037
040080
010152
490113
210019
340037
450518
010051
010138
010113
010047
010128
010092
010101
010126
010025
010034
040072
040069
100029
100254
110190
110064
110113
110034
110100
110165
110186
110043
110007
110150
110111
110122
110044
110163
110104
110086
110038
110107
110130
110073
110194
110075
110164
110203
110201
110121
111334
110039
110028
110036
110177
110129
110109
140103
140068
140177
140300
140181
140077
140083
140124
140048
140018
140151
140158
140301
140088
140049
140095
140133
140179
140150
140118
140250
140191
140206
140115
140240
140197
140119
140172
140063
140182
150002
150024
150008
150004
150056
150129
170146
190005
190122
190208
190098
190011
190065
190176
190046
190006
190009
192035
192029
190144
190017
192016
190007
190161
190245
190118
190114
190020
190003
190086
190274
190079
190274
190242
190125
190151
190039
190036
190054
190140
190102
190081
190183
190041
190090
190111
192050
190088
210038
210008
210056
210016
210024
210002
210011
210004
210009
210055
210035
210045
230024
230273
230104
230053
230132
230019
230297
230165
230151
230142
230013
260180
260027
252008
250095
250126
250128
252009
250059
250057
340084
340132
340107
340147
340120
340036
340166
340027
340024
340040
340028
340010
340008
340068
340126
340155
340109
340159
340050
340071
340053
310092
330397
330201
330316
360101
360144
360037
360137
360003
360115
360052
360017
360075
360059
360082
390132
390142
390027
390156
390026
390223
390304
390290
390090
390195
420069
420054
420068
420055
420030
420070
420072
420091
420016
420020
420005
420018
420066
420062
420010
420067
420051
420004
420087
420019
420065
420048
420053
420086
440152
442013
440159
440174
440049
440181
440131
440183
440168
440115
450289
670002
452074
450749
450051
450039
450795
450348
450723
450032
450610
452023
450839
450346
450018
450848
452032
450431
490094
490097
490090
490013
490084
490011
490020
490120
490069
490075
520136
490118
050002
050367
450747
450194
250010
490009
340047
050575
450447
100125
170040
050056
040114
090005
110143
180040
190053
450101
360051
010054
010078
450801
250025
210030
110046
490022
140100
142010
450638
190201
450630
290021
490019
100179
450684
050204
110006
050581
450005
010049
330193
180117
140080
190106
190034
670011
100106
210029
370057
420105
100232
050517
340115
060032
450884
370001
450299
030022
340070
100006
110027
100281
080001
330005
440065
140276
050070
440161
050771
060028
440072
010058
250094
050276
310054
100131
110124
360087
010073
190014
210023
110074
450844
310024
100285
150074
190164
510086
450656
330101
110142
140213
250040
450488
050485
230130
050018
330208
230029
420027
340021
100277
330304
440035
052037
450702
070002
450011
310057
370037
340004
450083
340060
100121
050060
490023
100067
330169
310009
340173
450080
250117
420007
210006
450484
490089
390116
330028
490122
420078
330353
450135
010139
010027
010038
010046
010056
040076
050122
050129
050231
050438
050541
050599
050625
050663
050710
050740
060011
060014
060024
070010
070022
080004
080006
100025
100032
100075
100088
100113
100161
100230
100234
100246
100269
102017
110015
110018
110024
110045
110071
110095
110105
110200
110215
140008
140082
140185
150047
170074
190002
190008
190050
190133
190135
190145
190202
190204
190218
210039
230020
230021
230085
230141
230204
230207
240004
250004
250007
250019
250123
260102
260113
260138
310029
310032
310086
330055
330065
330119
330290
340015
340039
340130
340141
340144
360020
360027
360048
360064
360068
360085
360133
360134
360141
360262
372012
390028
390076
390329
390164
390174
420043
420049
420089
440002
440104
440156
440197
450037
450123
450143
450152
450187
450188
450193
450211
450358
450465
450475
450580
450597
450658
450672
450683
450690
450694
450820
450832
452017
490050
490066
490113
490136
520177
010007
010011
010012
010019
010032
010036
010083
010086
010089
010090
010097
010100
010129
010130
010146
010157
020001
020017
020024
020026
030007
030010
030011
030036
030037
030061
030062
030085
030088
030094
030102
030103
030117
030119
040011
040014
040027
040036
040134
040137
040026
050025
050028
050038
050040
050045
050054
050069
050078
050082
050090
050125
050137
050159
050168
050174
050180
050194
050195
050205
050211
050225
050226
050232
050238
050243
050254
050279
050280
050295
050296
050308
050348
050357
050359
050380
050397
050417
050423
050434
050455
050457
050464
050496
050498
050510
050570
050588
050609
050677
050689
050690
050704
050723
050744
052047
053306
060013
060015
060027
060034
060043
060049
060075
060076
060100
060114
060118
060119
070017
070031
070034
070035
070039
070040
100007
100008
100012
100023
100043
100055
100063
100070
100071
100081
100086
100109
100117
100118
100127
100132
100168
100181
100187
100191
100200
100212
100217
100224
100228
100267
100275
100276
101312
110001
110023
110030
110205
120010
120014
120028
130013
130049
131328
140002
140007
140012
140019
140032
140034
140051
140054
140059
140064
140116
140120
140135
140137
140143
140148
140155
140161
140184
140186
140228
140234
140242
140252
140258
150001
150005
150006
150007
150012
150018
150030
150034
150038
150045
150059
150075
150076
150091
150102
150112
150157
150158
150163
150164
160005
160008
160045
160122
160147
160153
170009
170010
170039
170075
170104
170110
170122
170123
170142
170166
180002
180011
180016
180017
180018
180019
180020
180025
180027
180035
180038
180043
180056
180064
180069
180079
180080
180087
180105
180115
180128
180138
180139
180149
190146
190160
200021
200024
200025
200034
200037
200041
200041
200063
210022
210043
210044
220002
220019
220029
220051
220063
220088
220095
220098
220100
220110
220116
220119
220162
222002
230003
230005
230034
230040
230047
230059
230066
230069
230070
230072
230092
230108
230121
230133
230146
230216
230217
230277
240001
240006
240014
240022
240036
240038
240050
240052
240053
240076
240084
240100
240117
240166
250044
250162
260011
260015
260017
260024
260050
260057
260065
260074
260085
260142
260147
260162
260186
260190
260200
260209
270012
270014
270017
270049
270051
270057
271347
280013
280111
280130
290002
290020
290041
300001
300011
310005
310038
310047
310052
310060
310118
320001
320003
320018
320030
320033
320038
320067
320069
320074
320085
321308
330004
330037
330047
330053
330058
330064
330073
330085
330090
330104
330107
330111
330128
330151
330157
330177
330182
330194
330211
330215
330224
330226
330234
330238
330245
330246
330267
330273
330286
340002
340017
340032
340041
340051
340087
340097
340119
340129
340171
340184
350070
360013
360014
360032
360035
360039
360044
360056
360058
360078
360079
360092
360107
360131
360161
360174
360175
360185
360197
360203
360212
360242
370002
370007
370020
370023
370025
370030
370032
370041
370054
370072
370078
370089
370091
370099
370103
370114
370138
370139
370228
372019
380002
380004
380009
380018
380020
380040
380052
380075
380082
380089
390001
390003
390004
390006
390008
390009
390013
390016
390031
390032
390035
390037
390046
390052
390056
390058
390070
390079
390086
390095
390100
390112
390114
390119
390138
390157
390162
390184
390192
390197
390199
390219
390220
390268
410012
420009
420023
420033
420080
430014
431321
440010
440011
440015
440017
440025
440031
440040
440056
440060
440064
440070
440109
440130
440151
440173
440192
440194
440200
440227
442012
442016
450002
450007
450008
450024
450073
450087
450092
450108
450133
450144
450163
450177
450203
450229
450231
450235
450241
450270
450271
450272
450280
450283
450306
450340
450351
450369
450379
450451
450578
450610
450653
450654
450675
450678
450697
450709
450718
450746
450754
450755
450827
450841
450851
450872
450878
452092
460005
460006
460010
460014
460017
460019
460035
460042
460047
470001
490002
490005
490012
490018
490053
490107
490111
500001
500002
500003
500016
500037
500041
500049
500058
500148
510039
510048
520002
520011
520019
520075
520076
520083
520087
520095
520097
520100
520109
520116
520136
520138
520160
520170
520198
520193
520189
520202
530011
530014
530032
531316
670024
;

proc sort data=uptodateids;
  by provider;
proc sort data=additionalsamplehosps;
  by provider;
data check;
  merge uptodateids(in=in1) additionalsamplehosps(in=in2);
  by provider;
  if in1 and in2;
run;
