*****************************************
Frailty Indicator & Chronic Condition 30's for Medicare 5% sample
Xiner Zhou
2/15/2017
*****************************************;
libname MedPar 'D:\Data\Medicare\MedPAR';
libname OP 'D:\Data\Medicare\Outpatient';
libname Carrier 'D:\Data\Medicare\Carrier';
libname HHA 'D:\Data\Medicare\HHA';
libname HOSPICE 'D:\Data\Medicare\Hospice';
libname SNF 'D:\Data\Medicare\SNF';
libname DME 'D:\Data\Medicare\DME';
libname IP 'D:\Data\Medicare\Inpatient';
 
libname data 'D:\Projects\Peterson\Data';

data Inptclms2010;
set IP.Inptclms2010 ;
PRNCPAL_DGNS_CD=DGNSCD1;
ICD_DGNS_CD1=DGNSCD2;
ICD_DGNS_CD2=DGNSCD3;
ICD_DGNS_CD3=DGNSCD4;
ICD_DGNS_CD4=DGNSCD5;
ICD_DGNS_CD5=DGNSCD6;
ICD_DGNS_CD6=DGNSCD7;
ICD_DGNS_CD7=DGNSCD8;
ICD_DGNS_CD8=DGNSCD9;
ICD_DGNS_CD9=DGNSCD10;
run;

data temp;
 length PRNCPAL_DGNS_CD 
ICD_DGNS_CD1 ICD_DGNS_CD2 ICD_DGNS_CD3 ICD_DGNS_CD4 ICD_DGNS_CD5
ICD_DGNS_CD6 ICD_DGNS_CD7 ICD_DGNS_CD8 ICD_DGNS_CD9 ICD_DGNS_CD10 ICD_DGNS_CD11 ICD_DGNS_CD12 ICD_DGNS_CD13 ICD_DGNS_CD14
ICD_DGNS_CD15 ICD_DGNS_CD16 ICD_DGNS_CD17 ICD_DGNS_CD18 ICD_DGNS_CD19 ICD_DGNS_CD20 ICD_DGNS_CD21 ICD_DGNS_CD22 ICD_DGNS_CD23
ICD_DGNS_CD24 ICD_DGNS_CD25 $20.;
set  Inptclms2010(keep=bene_id PRNCPAL_DGNS_CD 
ICD_DGNS_CD1 ICD_DGNS_CD2 ICD_DGNS_CD3 ICD_DGNS_CD4 ICD_DGNS_CD5
ICD_DGNS_CD6 ICD_DGNS_CD7 ICD_DGNS_CD8 ICD_DGNS_CD9 )

OP.Otptclms2010(keep=bene_id PRNCPAL_DGNS_CD 
ICD_DGNS_CD1 ICD_DGNS_CD2 ICD_DGNS_CD3 ICD_DGNS_CD4 ICD_DGNS_CD5
ICD_DGNS_CD6 ICD_DGNS_CD7 ICD_DGNS_CD8 ICD_DGNS_CD9 ICD_DGNS_CD10 ICD_DGNS_CD11 ICD_DGNS_CD12 ICD_DGNS_CD13 ICD_DGNS_CD14
ICD_DGNS_CD15 ICD_DGNS_CD16 ICD_DGNS_CD17 ICD_DGNS_CD18 ICD_DGNS_CD19 ICD_DGNS_CD20 ICD_DGNS_CD21 ICD_DGNS_CD22 ICD_DGNS_CD23
ICD_DGNS_CD24 ICD_DGNS_CD25  )

Carrier.Bcarclms2010(keep=bene_id PRNCPAL_DGNS_CD 
ICD_DGNS_CD1 ICD_DGNS_CD2 ICD_DGNS_CD3 ICD_DGNS_CD4 ICD_DGNS_CD5
ICD_DGNS_CD6 ICD_DGNS_CD7 ICD_DGNS_CD8 ICD_DGNS_CD9 ICD_DGNS_CD10 ICD_DGNS_CD11 ICD_DGNS_CD12)

HHA.Hhaclms2010(keep=bene_id PRNCPAL_DGNS_CD 
ICD_DGNS_CD1 ICD_DGNS_CD2 ICD_DGNS_CD3 ICD_DGNS_CD4 ICD_DGNS_CD5
ICD_DGNS_CD6 ICD_DGNS_CD7 ICD_DGNS_CD8 ICD_DGNS_CD9 ICD_DGNS_CD10 ICD_DGNS_CD11 ICD_DGNS_CD12 ICD_DGNS_CD13 ICD_DGNS_CD14
ICD_DGNS_CD15 ICD_DGNS_CD16 ICD_DGNS_CD17 ICD_DGNS_CD18 ICD_DGNS_CD19 ICD_DGNS_CD20 ICD_DGNS_CD21 ICD_DGNS_CD22 ICD_DGNS_CD23
ICD_DGNS_CD24 ICD_DGNS_CD25  )

Hospice.Hspcclms2010(keep=bene_id PRNCPAL_DGNS_CD 
ICD_DGNS_CD1 ICD_DGNS_CD2 ICD_DGNS_CD3 ICD_DGNS_CD4 ICD_DGNS_CD5
ICD_DGNS_CD6 ICD_DGNS_CD7 ICD_DGNS_CD8 ICD_DGNS_CD9 ICD_DGNS_CD10 ICD_DGNS_CD11 ICD_DGNS_CD12 ICD_DGNS_CD13 ICD_DGNS_CD14
ICD_DGNS_CD15 ICD_DGNS_CD16 ICD_DGNS_CD17 ICD_DGNS_CD18 ICD_DGNS_CD19 ICD_DGNS_CD20 ICD_DGNS_CD21 ICD_DGNS_CD22 ICD_DGNS_CD23
ICD_DGNS_CD24 ICD_DGNS_CD25  )

SNF.SNFclms2010(keep=bene_id PRNCPAL_DGNS_CD 
ICD_DGNS_CD1 ICD_DGNS_CD2 ICD_DGNS_CD3 ICD_DGNS_CD4 ICD_DGNS_CD5
ICD_DGNS_CD6 ICD_DGNS_CD7 ICD_DGNS_CD8 ICD_DGNS_CD9 ICD_DGNS_CD10 ICD_DGNS_CD11 ICD_DGNS_CD12 ICD_DGNS_CD13 ICD_DGNS_CD14
ICD_DGNS_CD15 ICD_DGNS_CD16 ICD_DGNS_CD17 ICD_DGNS_CD18 ICD_DGNS_CD19 ICD_DGNS_CD20 ICD_DGNS_CD21 ICD_DGNS_CD22 ICD_DGNS_CD23
ICD_DGNS_CD24 ICD_DGNS_CD25  )


DME.DMEclms2010(keep=bene_id PRNCPAL_DGNS_CD 
ICD_DGNS_CD1 ICD_DGNS_CD2 ICD_DGNS_CD3 ICD_DGNS_CD4 ICD_DGNS_CD5
ICD_DGNS_CD6 ICD_DGNS_CD7 ICD_DGNS_CD8 ICD_DGNS_CD9 ICD_DGNS_CD10 ICD_DGNS_CD11 ICD_DGNS_CD12);
run;







 

data temp1;
set temp ;
array dx {26} PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25;
array flg_amiihd{26}    flg_amiihd1   -flg_amiihd26  ;
array flg_amputat{26}   flg_amputat1  -flg_amputat26  ;
array flg_arthrit{26}   flg_arthrit1  -flg_arthrit26  ;
array flg_artopen{26}   flg_artopen1  -flg_artopen26  ;
array flg_bph{26}       flg_bph1      -flg_bph26  ;
array flg_cancer{26}    flg_cancer1   -flg_cancer26  ;
array flg_chrkid{26}    flg_chrkid1   -flg_chrkid26  ;
array flg_chf{26}       flg_chf1      -flg_chf26  ;
array flg_cystfib{26}   flg_cystfib1  -flg_cystfib26  ;
array flg_dementia{26}  flg_dementia1 -flg_dementia26  ;
array flg_diabetes{26}  flg_diabetes1 -flg_diabetes26 ;
array flg_endo{26}      flg_endo1     -flg_endo26  ;
array flg_eyedis{26}    flg_eyedis1   -flg_eyedis26 ;
array flg_hemadis{26}   flg_hemadis1  -flg_hemadis26  ;
array flg_hyperlip{26}  flg_hyperlip1 -flg_hyperlip26  ;
array flg_hyperten{26}  flg_hyperten1 -flg_hyperten26  ;
array flg_immunedis{26} flg_immunedis1-flg_immunedis26  ;
array flg_ibd{26}       flg_ibd1      -flg_ibd26  ;
array flg_liver{26}     flg_liver1    -flg_liver26  ;
array flg_lung{26}      flg_lung1     -flg_lung26  ;
array flg_neuromusc{26} flg_neuromusc1-flg_neuromusc26 ;
array flg_osteo{26}     flg_osteo1    -flg_osteo26  ;
array flg_paralyt{26}   flg_paralyt1  -flg_paralyt26  ;
array flg_psydis{26}    flg_psydis1   -flg_psydis26  ;
array flg_sknulc{26}    flg_sknulc1   -flg_sknulc26  ;
array flg_spchrtarr{26} flg_spchrtarr1-flg_spchrtarr26  ;
array flg_strk{26}      flg_strk1     -flg_strk26  ;
array flg_sa{26}        flg_sa1       -flg_sa26  ;
array flg_thyroid{26}   flg_thyroid1  -flg_thyroid26  ;
array flg_vascdis{26}   flg_vascdis1  -flg_vascdis26  ;

do i=1 to 26;
	if dx{i} in ("41000","41001","41002","41010","41011","41012","41020","41021","41022","41030","41031",
	"41032","41040","41041","41042","41050","41051","41052","41060","41061","41062","41070",
	"41071","41072","41080","41081","41082","41090","41091","41092","4110","4111","41181",
	"41189","412","4130","4131","4139","41400","41401","41402","41403","41404","41405","41406",
	"41407","41412","4142","4143","4144","4148","4149","4295","4296") then flg_amiihd{i}=1; 

	if dx{i} in ("3536","9059","99760","99761","99762","99769","V4970","V4971","V4972","V4973","V4974","V4975",
	"V4976","V4977","V521") then flg_amputat{i}=1; 

	if dx{i} in ("1361","4460","4461","44620","44621","44629","4463","4464","4465","4466","4467","6960","7100",
	"7101","7102","7103","7104","7105","7108","7109","71110","71111","71112","71113","71114",
	"71115","71116","71117","71118","71119","71120","71121","71122","71123","71124","71125",
	"71126","71127","71128","71129","7140","7141","7142","71430","71431","71432","71433","7144",
	"71481","71489","7149","71500","71504","71509","71510","71511","71512","71513","71514","71515",
	"71516","71517","71518","71520","71521","71522","71523","71524","71525","71526","71527",
	"71528","71530","71531","71532","71533","71534","71535","71536","71537","71538","71580",
	"71589","71590","71591","71592","71593","71594","71595","71596","71597","71598","7200","7201",
	"7202","72081","72089","7209","7210","7211","7212","7213","72190","72191","725","993") then flg_arthrit{i}=1; 

	if dx{i} in ("53086","53087","53640","53641","53642","53649","56960","56961","56962","56969","56971",
	"56979","V441","V442","V443","V444","V4450","V4451","V4452","V4459","V446","V448","V449",
	"V551","V552","V553","V554","V555","V556","V558","V559") then flg_artopen{i}=1; 

    if dx{i} in ("60000","60001","60010","60011","60020","60021","6003","60090","60091") then flg_bph{i}=1; 

    if dx{i} in ("1410","1411","1412","1413","1414","1415","1416","1418","1419","1420","1421","1422","1428",
	"1429","1430","1431","1438","1439","1440","1441","1448","1449","1450","1451","1452","1453",
	"1454","1455","1456","1458","1459","1460","1461","1462","1463","1464","1465","1466","1467",
	"1468","1469","1470","1471","1472","1473","1478","1479","1480","1481","1482","1483","1488",
	"1489","1490","1491","1498","1499","1500","1501","1502","1503","1504","1505","1508","1509",
	"1510","1511","1512","1513","1514","1515","1516","1518","1519","1520","1521","1522","1523",
	"1528","1529","1530","1531","1532","1533","1534","1535","1536","1537","1538","1539","1540",
	"1541","1542","1543","1548","1550","1551","1552","1560","1561","1562","1568","1569","1570",
	"1571","1572","1573","1574","1578","1579","1580","1588","1589","1590","1591","1598","1599",
	"1600","1601","1602","1603","1604","1605","1608","1609","1610","1611","1612","1613","1618",
	"1619","1620","1622","1623","1624","1625","1628","1629","1630","1631","1638","1639","1640",
	"1641","1642","1643","1648","1649","1650","1658","1659","1700","1701","1702","1703","1704",
	"1705","1706","1707","1708","1709","1710","1712","1713","1714","1715","1716","1717","1718",
	"1719","1720","1721","1722","1723","1724","1725","1726","1727","1728","1729","1740","1741",
	"1742","1743","1744","1745","1746","1748","1749","1750","1759","1760","1761","1762","1763",
	"1764","1765","1768","1769","179","1800","1801","1808","1809","181","1820","1821","1828",
	"1830","1832","1833","1834","1835","1838","1839","1840","1841","1842","1843","1844","1848",
	"1849","185","1860","1869","1871","1872","1873","1874","1875","1876","1877","1878","1879",	
	"1880","1881","1882","1883","1884","1885","1886","1887","1888","1889","1890","1891","1892",
	"1893","1894","1898","1899","1900","1901","1902","1903","1904","1905","1906","1907","1908",
	"1909","1910","1911","1912","1913","1914","1915","1916","1917","1918","1919","1920","1921",
	"1922","1923","1928","1929","193","1940","1941","1943","1944","1945","1946","1948","1949",
	"1950","1951","1952","1953","1954","1955","1958","1960","1961","1962","1963","1965","1966",
	"1968","1969","1970","1971","1972","1973","1974","1975","1976","1977","1978","1980","1981",
	"1982","1983","1984","1985","1986","1987","19881","19882","19889","1990","1991","1992","20000",
	"20001","20002","20003","20004","20005","20006","20007","20008","20010","20011","20012",
	"20013","20014","20015","20016","20017","20018","20020","20021","20022","20023","20024",
	"20025","20026","20027","20028","20030","20031","20032","20033","20034","20035","20036",
	"20037","20038","20040","20041","20042","20043","20044","20045","20046","20047","20048",
	"20050","20051","20052","20053","20054","20055","20056","20057","20058","20060","20061",
	"20062","20063","20064","20065","20066","20067","20068","20070","20071","20072","20073",
	"20074","20075","20076","20077","20078","20080","20081","20082","20083","20084","20085",
	"20086","20087","20088","20100","20101","20102","20103","20104","20105","20106","20107",
	"20108","20110","20111","20112","20113","20114","20115","20116","20117","20118","20120",
	"20121","20122","20123","20124","20125","20126","20127","20128","20140","20141","20142",
	"20143","20144","20145","20146","20147","20148","20150","20151","20152","20153","20154",
	"20155","20156","20157","20158","20160","20161","20162","20163","20164","20165","20166",
	"20167","20168","20170","20171","20172","20173","20174","20175","20176","20177","20178",
	"20190","20191","20192","20193","20194","20195","20196","20197","20198","20200","20201",
	"20202","20203","20204","20205","20206","20207","20208","20210","20211","20212","20213",
	"20214","20215","20216","20217","20218","20220","20221","20222","20223","20224","20225",
	"20226","20227","20228","20230","20231","20232","20233","20234","20235","20236","20237",
	"20238","20240","20241","20242","20243","20244","20245","20246","20247","20248","20250",
	"20251","20252","20253","20254","20255","20256","20257","20258","20260","20261","20262",
	"20263","20264","20265","20266","20267","20268","20270","20271","20272","20273","20274",
	"20275","20276","20277","20278","20280","20281","20282","20283","20284","20285","20286",
	"20287","20288","20290","20291","20292","20293","20294","20295","20296","20297","20298",
	"20300","20301","20302","20310","20311","20312","20380","20381","20382","20400","20401",
	"20402","20410","20411","20412","20420","20421","20422","20480","20481","20482","20490",
	"20491","20492","20500","20501","20502","20510","20511","20512","20520","20521","20522",
	"20530","20531","20532","20580","20581","20582","20590","20591","20592","20600","20601",
	"20602","20610","20611","20612","20620","20621","20622","20680","20681","20682","20690",
	"20691","20692","20700","20701","20702","20710","20711","20712","20720","20721","20722",
	"20780","20781","20782","20800","20801","20802","20810","20811","20812","20820","20821",
	"20822","20880","20881","20882","20890","20891","20892","20900","20901","20902","20903",
	"20910","20911","20912","20913","20914","20915","20916","20917","20920","20921","20922",
	"20923","20924","20925","20926","20927","20929","20930","20931","20932","20933","20934",
	"20935","20936","20970","20971","20972","20973","20974","20975","20979","2250","2251",
	"2252","2253","2254","2258","2259","2273","2274","22802","2303","2304","2312","2330",
	"2332","2334","2370","2371","2373","2375","2376","23770","23771","23772","23773","23779",
	"2379","2396","2592","7595","7596","V1005","V1006","V1011","V103","V1042","V1046") then flg_cancer{i}=1; 

	if dx{i} in ("01600","01601","01602","01603","01604","01605","01606","2230","23691","27410","40300","40301",
	"40310","40311","40390","40391","40400","40401","40402","40403","40410","40411","40412",
	"40413","40490","40491","40492","40493","5810","5811","5812","5813","58181","58189","5819",
	"5820","5821","5822","5824","58281","58289","5829","5830","5831","5832","5834","5836","5837",
	"58381","58389","5839","585","5851","5852","5853","5854","5855","5856","5859","586","587",
	"5880","5881","58889","591","75312","75313","75314","75315","75316","75317","75319","75320",
	"75321","75322","75323","75329","786","7944","0954","99656","99668","99673","V4511","V4512",
	"V560","V561","V562","V5631","V5632","V568") then flg_chrkid{i}=1; 

	if dx{i} in ("39891","40201","40211","40291","4150","4160","4161","4168","4169","4170","4171","4178","4179",
	"4250","4251","42511","42518","4252","4253","4254","4255","4257","4258","4259","4280","4281",
	"42820","42821","42822","42823","42830","42831","42832","42833","42840","42841","42842",
	"42843","4289","4290","4291") then flg_chf{i}=1; 

	if dx{i} in ("27700","27701","27702","27703","27709") then flg_cystfib{i}=1; 

	if dx{i} in ("2900","29010","29011","29012","29013","29020","29021","2903","29040","29041","29042","29043",
	"2908","2909","2940","29410","29411","29420","29421","2948","2949","3300","3301","3302","3303",
	"3308","3309","3310","33111","33119","3312","3313","3314","3315","3316","3317","33181","33182",
	"33189","3319","460","4611","4619","462","463","4671","4672","4679","468","469","797") then flg_dementia{i}=1; 

	if dx{i} in ("24900","24901","24910","24911","24920","24921","24930","24931","24940","24941","24950",
	"24951","24960","24961","24970","24971","24980","24981","24990","24991","25000","25001",
	"25002","25003","25010","25011","25012","25013","25020","25021","25022","25023","25030",
	"25031","25032","25033","25040","25041","25042","25043","25050","25051","25052","25053",
	"25060","25061","25062","25063","25070","25071","25072","25073","25080","25081","25082",
	"25083","25090","25091","25092","25093","3572","36201","36202","36203","36204","36205",
	"36206","36207","36641","37923","V5867") then flg_diabetes{i}=1; 

	if dx{i} in ("2510","25200","25201","25202","25208","2521","2528","2529","2530","2531","2532","2533","2534",
	"2535","2536","2537","2538","2539","2540","2541","2548","2549","2550","25510","25511","25512",
	"25513","25514","2552","2553","25541","25542","2555","2556","2558","2559","25801","25802",
	"25803","2581","2588","2589","260","261","262","2630","2631","2632","2638","2639","2700",
	"2701","2702","2703","2704","2705","2706","2707","2708","2709","2710","2711","2714","2718",
	"2719","2727","2732","2733","2734","27501","2771","2772","27730","27731","27739","2775","2776",
	"27781","27782","27783","27784","27785","27786","27787","27789","27801","27803","363","58881",
	"7994","V8541","V8542","V8543","V8544","V8545") then flg_endo{i}=1; 

	if dx{i} in ("36252","36285","36500","36501","36502","36503","36504","36510","36511","36512","36513",
	"36515","36520","36521","36522","36523","36524","36531","36532","36541","36542","36543",
	"36551","36552","36559","36560","36561","36562","36563","36564","36565","36581","36582",
	"36583","36589","3659","36601","36602","36603","36604","36609","36610","36612","36613","36614",
	"36615","36616","36617","36618","36619","36620","36621","36622","36623","36630","36645",
	"36646","36650","36651","36652","36653","3668","3669","37714","37926","37931","37939","74330",
	"74331","74332","74333","V431") then flg_eyedis{i}=1; 

	if dx{i} in ("2384","23871","23872","23873","23874","23875","23876","23877","23879","2800","2801","2808",
	"2809","2810","2811","2812","2813","2814","2818","2819","2820","2821","2822","2823","28240",
	"28241","28242","28243","28244","28245","28246","28247","28249","2825","28260","28261","28262",
	"28263","28264","28268","28269","2827","2828","2829","2830","28310","28311","28319","2832",
	"2839","28401","28409","2841","28411","28412","28419","2842","28481","28489","2849","2850",
	"2851","28521","28522","28529","2853","2858","2859","2860","2861","2862","2863","2864","2865",
	"28652","28653","28659","2866","2867","2869","2870","2871","2872","28730","28731","28732",
	"28733","28739","2875","2878","2879","28952","28981","28982","28983","28984","5173") then flg_hemadis{i}=1; 

	if dx{i} in ("2720","2721","2722","2723","2724") then flg_hyperlip{i}=1; 

	if dx{i} in ("36211","4010","4011","4019","40200","40210","40290","40501","40509","40511","40519","40591",
	"40599","4372") then flg_hyperten{i}=1; 

	if dx{i} in ("27900","27901","27902","27903","27904","27905","27906","27909","27910","27911","27912",
	"27913","27919","2792","2793","27941","27949","27950","27951","27952","27953","2798","2799",
	"28800","28801","28802","28803","28804","28809","2881","2882","2884","42","7953","V08") then flg_immunedis{i}=1; 

	if dx{i} in ("5550","5551","5552","5559","5560","5561","5562","5563","5564","5565","5566","5568","5569") then flg_ibd{i}=1; 

	if dx{i} in ("4560","4561","45620","45621","5712","5713","57140","57141","57142","57149","5715","5716",
	"5722","5723","5724","5728","5735","5771","7022","7023","7032","7033","7044","7054") then flg_liver{i}=1; 

	if dx{i} in ("135","490","4910","4911","49120","49121","49122","4918","4919","4920","4928","49300","49301",
	"49302","49310","49311","49312","49320","49321","49322","49381","49382","49390","49391",
	"49392","4940","4941","4950","4951","4952","4953","4954","4955","4956","4957","4958","4959",
	"496","500","501","502","503","504","505","5060","5061","5062","5063","5064","5069","5080",
	"5081","5082","5088","5089","515","5160","5161","5162","5163","51630","51631","51632","51633",
	"51634","51635","51636","51637","5164","5165","51661","51662","51663","51664","51669","5168",
	"5169","5171","5172","5178","5181","5182","5183","5186") then flg_lung{i}=1; 

	if dx{i} in ("3320","3321","3330","3334","33371","33520","33521","33522","33523","33524","33529","33700",
	"33701","33709","3371","33720","33721","33722","33729","3373","3379","340","3410","3411",
	"3418","3419","3430","3431","3432","3433","3434","3438","3439","34500","34501","34510","34511",
	"3452","3453","34540","34541","34550","34551","34560","34561","34570","34571","34580","34581",
	"34590","34591","3560","3561","3562","3563","3564","3568","3569","3570","3571","3573","3574",
	"3575","3576","3577","35781","35782","35789","3579","35800","35801","3581","3582","35830",
	"35831","35839","3588","3589","3590","3591","35921","35922","35923","35924","35929","3593",
	"3594","3595","3596","35971","35979","35981","35989","3599","78031","78032","78033","78039") then flg_neuromusc{i}=1; 

	if dx{i} in ("73300","73301","73302","73303","73309") then  flg_osteo{i}=1; 

	if dx{i} in ("34200","34201","34202","34210","34211","34212","34280","34281","34282","34290","34291",
	"34292","34400","34401","34402","34403","34404","34409","3441","3442","34430","34431","34432",
	"34440","34441","34442","3445","34481","34489","3449","43820","43821","43822","43830","43831",
	"43832","43840","43841","43842","43850","43851","43852","43853","78072","80601","80606",
	"80611","80616","80621","80626","80631","80636","95201","95206","95211","95216") then  flg_paralyt{i}=1; 

	if dx{i} in ("29500","29501","29502","29503","29504","29505","29510","29511","29512","29513","29514",
	"29515","29520","29521","29522","29523","29524","29525","29530","29531","29532","29533",
	"29534","29535","29540","29541","29542","29543","29544","29545","29550","29551","29552",
	"29553","29554","29555","29560","29561","29562","29563","29564","29565","29570","29571",
	"29572","29573","29574","29575","29580","29581","29582","29583","29584","29585","29590",
	"29591","29592","29593","29594","29595","29600","29601","29602","29603","29604","29605",
	"29606","29610","29611","29612","29613","29614","29615","29616","29620","29621","29622",
	"29623","29624","29625","29626","29630","29631","29632","29633","29634","29635","29636",
	"29640","29641","29642","29643","29644","29645","29646","29650","29651","29652","29653",
	"29654","29655","29656","29660","29661","29662","29663","29664","29665","29666","2967","29680",
	"29681","29682","29689","29690","29699","2970","2971","2972","2973","2978","2979","2980",
	"3004","3091","311","E9500","E9501","E9502","E9503","E9504","E9505","E9506","E9507","E9508",
	"E9509","E9510","E9511","E9518","E9520","E9521","E9528","E9529","E9530","E9531","E9538",
	"E9539","E954","E9550","E9551","E9552","E9553","E9554","E9555","E9556","E9557","E9559","E956",
	"E9570","E9571","E9572","E9579","E9580","E9581","E9582","E9583","E9584","E9585","E9586",
	"E9587","E9588","E9589","E959") then  flg_psydis{i}=1; 

	if dx{i} in ("70700","70701","70702","70703","70704","70705","70706","70707","70709","70720","70721",
	"70722","70723","70724","70725","70710","70711","70712","70713","70714","70715","70719","7078",
	"7079") then  flg_sknulc{i}=1; 

	if dx{i} in ("4260","4270","4271","4272","42731","42732","42781") then  flg_spchrtarr{i}=1;

	if dx{i} in ("430","431","4320","4321","4329","43301","43311","43321","43331","43381","43391","43400",
	"43401","43410","43411","43490","43491","4350","4351","4353","4358","4359","436","9487","99702") then  flg_strk{i}=1; 

	if dx{i} in ("2910","2911","2912","2913","2914","2915","29181","29182","29189","2919","2920","29211",
	"29212","2922","29281","29282","29283","29284","29285","29289","2929","30300","30301","30302",
	"30303","30390","30391","30392","30393","30400","30401","30402","30403","30410","30411",
	"30412","30413","30420","30421","30422","30423","30430","30431","30432","30433","30440",
	"30441","30442","30443","30450","30451","30452","30453","30460","30461","30462","30463",
	"30470","30471","30472","30473","30480","30481","30482","30483","30490","30491","30492","30493") then  flg_sa{i}=1; 

	if dx{i} in ("2440","2441","2442","2443","2448","2449") then  flg_thyroid{i}=1; 

	if dx{i} in ("41511","41512","41513","41519","4162","4400","4401","44020","44021","44022","44029","44030",
	"44031","44032","4404","44100","44101","44102","44103","4411","4412","4413","4414","4415",
	"4416","4417","4419","4420","4421","4422","4423","44281","44282","44283","44284","44289",
	"4429","4431","44321","44322","44323","44324","44329","44381","44382","44389","4439","4440",
	"44401","44409","4441","44421","44422","44481","44489","4449","44501","44502","44581","44589",
	"4470","4471","4472","4473","4474","4475","4476","44770","44771","44772","44773","4478","4479",
	"4480","449","45111","45119","45181","45183","4530","4532","4533","45340","45341","45342",
	"45350","45351","45352","45372","45374","45375","45376","45377","45382","45384","45385",
	"45386","45387","4540","4542","45911","45913","45931","45933","5570","5571","5579","59381") then  flg_vascdis{i}=1; 

	 

end;
run;
 

data temp2;
set temp1 ;
 
array flg_amiihd{26}    flg_amiihd1   -flg_amiihd26  ;
array flg_amputat{26}   flg_amputat1  -flg_amputat26  ;
array flg_arthrit{26}   flg_arthrit1  -flg_arthrit26  ;
array flg_artopen{26}   flg_artopen1  -flg_artopen26  ;
array flg_bph{26}       flg_bph1      -flg_bph26  ;

array flg_cancer{26}    flg_cancer1   -flg_cancer26  ;
array flg_chrkid{26}    flg_chrkid1   -flg_chrkid26  ;
array flg_chf{26}       flg_chf1      -flg_chf26  ;
array flg_cystfib{26}   flg_cystfib1  -flg_cystfib26  ;
array flg_dementia{26}  flg_dementia1 -flg_dementia26  ;

array flg_diabetes{26}  flg_diabetes1 -flg_diabetes26 ;
array flg_endo{26}      flg_endo1     -flg_endo26  ;
array flg_eyedis{26}    flg_eyedis1   -flg_eyedis26 ;
array flg_hemadis{26}   flg_hemadis1  -flg_hemadis26  ;
array flg_hyperlip{26}  flg_hyperlip1 -flg_hyperlip26  ;

array flg_hyperten{26}  flg_hyperten1 -flg_hyperten26  ;
array flg_immunedis{26} flg_immunedis1-flg_immunedis26  ;
array flg_ibd{26}       flg_ibd1      -flg_ibd26  ;
array flg_liver{26}     flg_liver1    -flg_liver26  ;
array flg_lung{26}      flg_lung1     -flg_lung26  ;

array flg_neuromusc{26} flg_neuromusc1-flg_neuromusc26 ;
array flg_osteo{26}     flg_osteo1    -flg_osteo26  ;
array flg_paralyt{26}   flg_paralyt1  -flg_paralyt26  ;
array flg_psydis{26}    flg_psydis1   -flg_psydis26  ;
array flg_sknulc{26}    flg_sknulc1   -flg_sknulc26  ;

array flg_spchrtarr{26} flg_spchrtarr1-flg_spchrtarr26  ;
array flg_strk{26}      flg_strk1     -flg_strk26  ;
array flg_sa{26}        flg_sa1       -flg_sa26  ;
array flg_thyroid{26}   flg_thyroid1  -flg_thyroid26  ;
array flg_vascdis{26}   flg_vascdis1  -flg_vascdis26  ;

do i=1 to 26;
if flg_amiihd{i}=. then flg_amiihd{i}=0;
if flg_amputat{i}=. then flg_amputat{i}=0;
if flg_arthrit{i}=. then flg_arthrit{i}=0;
if flg_artopen{i}=. then flg_artopen{i}=0;
if flg_bph{i}=. then flg_bph{i}=0;

if flg_cancer{i}=. then flg_cancer{i}=0;
if flg_chrkid{i}=. then flg_chrkid{i}=0;
if flg_chf{i}=. then flg_chf{i}=0;
if flg_cystfib{i}=. then flg_cystfib{i}=0;
if flg_dementia{i}=. then flg_dementia{i}=0;

if flg_diabetes{i}=. then flg_diabetes{i}=0;
if flg_endo{i}=. then flg_endo{i}=0;
if flg_eyedis{i}=. then flg_eyedis{i}=0;
if flg_hemadis{i}=. then flg_hemadis{i}=0;
if flg_hyperlip{i}=. then flg_hyperlip{i}=0;

if flg_hyperten{i}=. then flg_hyperten{i}=0;
if flg_immunedis{i}=. then flg_immunedis{i}=0;
if flg_ibd{i}=. then flg_ibd{i}=0;
if flg_liver{i}=. then flg_liver{i}=0;
if flg_lung{i}=. then flg_lung{i}=0;

if flg_neuromusc{i}=. then flg_neuromusc{i}=0;
if flg_osteo{i}=. then flg_osteo{i}=0;
if flg_paralyt{i}=. then flg_paralyt{i}=0;
if flg_psydis{i}=. then flg_psydis{i}=0;
if flg_sknulc{i}=. then flg_sknulc{i}=0;

if flg_spchrtarr{i}=. then flg_spchrtarr{i}=0;
if flg_strk{i}=. then flg_strk{i}=0;
if flg_sa{i}=. then flg_sa{i}=0;
if flg_thyroid{i}=. then flg_thyroid{i}=0;
if flg_vascdis{i}=. then flg_vascdis{i}=0;
end;

amiihd=0;
amputat =0;
arthrit =0;
artopen =0;
bph =0;
cancer =0;
chrkid =0;
chf =0;
cystfib =0;
dementia =0;
diabetes =0;
endo =0;
eyedis =0;
hemadis =0;
hyperlip =0;
hyperten =0;
immunedis =0;
ibd =0;
liver =0;
lung  =0;
neuromusc =0;
osteo =0;
paralyt =0;
psydis =0;
sknulc =0;
spchrtarr =0;
strk =0;
sa =0;
thyroid =0;
vascdis =0;
do i=1 to 26;

amiihd=amiihd+flg_amiihd{i};
amputat =amputat + flg_amputat{i};
arthrit =arthrit + flg_arthrit{i};
artopen =artopen + flg_artopen{i};
bph =bph + flg_bph{i};
cancer =cancer + flg_cancer{i};
chrkid =chrkid + flg_chrkid{i};
chf =chf + flg_chf{i};
cystfib =cystfib + flg_cystfib{i};
dementia =dementia + flg_dementia{i};
diabetes  =diabetes + flg_diabetes{i};
endo =endo + flg_endo{i};
eyedis =eyedis + flg_eyedis{i};
hemadis =hemadis + flg_hemadis{i};
hyperlip =hyperlip + flg_hyperlip{i};
hyperten =hyperten + flg_hyperten{i};
immunedis =immunedis + flg_immunedis{i};
ibd =ibd + flg_ibd{i};
liver =liver + flg_liver{i};
lung  =lung + flg_lung{i};
neuromusc =neuromusc + flg_neuromusc{i};
osteo =osteo + flg_osteo{i};
paralyt =paralyt + flg_paralyt{i};
psydis =psydis + flg_psydis{i};
sknulc =sknulc + flg_sknulc{i};
spchrtarr =spchrtarr + flg_spchrtarr{i};
strk =strk + flg_strk{i};
sa =sa + flg_sa{i};
thyroid =thyroid + flg_thyroid{i};
vascdis =vascdis + flg_vascdis{i};

end;

drop i PRNCPAL_DGNS_CD 
ICD_DGNS_CD1 ICD_DGNS_CD2 ICD_DGNS_CD3 ICD_DGNS_CD4 ICD_DGNS_CD5
ICD_DGNS_CD6 ICD_DGNS_CD7 ICD_DGNS_CD8 ICD_DGNS_CD9 ICD_DGNS_CD10 ICD_DGNS_CD11 ICD_DGNS_CD12 ICD_DGNS_CD13 ICD_DGNS_CD14
ICD_DGNS_CD15 ICD_DGNS_CD16 ICD_DGNS_CD17 ICD_DGNS_CD18 ICD_DGNS_CD19 ICD_DGNS_CD20 ICD_DGNS_CD21 ICD_DGNS_CD22 ICD_DGNS_CD23
ICD_DGNS_CD24 ICD_DGNS_CD25  
	flg_amiihd1-flg_amiihd26 flg_amputat1-flg_amputat26 flg_arthrit1-flg_arthrit26
     flg_artopen1-flg_artopen26  flg_bph1-flg_bph26 flg_cancer1-flg_cancer26  flg_chrkid1-flg_chrkid26 
	flg_chf1-flg_chf26 flg_cystfib1-flg_cystfib26 flg_dementia1-flg_dementia26 flg_diabetes1-flg_diabetes26 
	flg_endo1-flg_endo26 flg_eyedis1-flg_eyedis26 flg_hemadis1-flg_hemadis26 flg_hyperlip1-flg_hyperlip26 
	flg_hyperten1-flg_hyperten26 flg_immunedis1-flg_immunedis26 flg_ibd1-flg_ibd26 flg_liver1-flg_liver26 
	flg_lung1-flg_lung26 flg_neuromusc1-flg_neuromusc26 flg_osteo1-flg_osteo26 flg_paralyt1-flg_paralyt26 
	flg_psydis1-flg_psydis26 flg_sknulc1-flg_sknulc26 flg_spchrtarr1-flg_spchrtarr26 flg_strk1-flg_strk26 
	flg_sa1-flg_sa26 flg_thyroid1-flg_thyroid26 flg_vascdis1-flg_vascdis26 ;
run;

proc sort data=temp2;by bene_id;run;

proc sql;
create table temp3 as
select bene_id, sum(amiihd) as t_amiihd,sum(amputat) as t_amputat,sum(arthrit) as t_arthrit,sum(artopen) as t_artopen,sum(bph) as t_bph,sum(cancer) as t_cancer,
sum(chrkid) as t_chrkid,sum(chf) as t_chf,sum(cystfib) as t_cystfib,sum(dementia) as t_dementia,sum(diabetes) as t_diabetes,sum(endo) as t_endo,sum(eyedis) as t_eyedis,
sum(hemadis) as t_hemadis,sum(hyperlip) as t_hyperlip,sum(hyperten) as t_hyperten, sum(immunedis) as t_immunedis,
sum(ibd) as t_ibd,sum(liver) as t_liver,sum(lung) as t_lung,sum(neuromusc) as t_neuromusc,sum(osteo) as t_osteo,sum(paralyt) as t_paralyt,sum(psydis) as t_psydis,
sum(sknulc) as t_sknulc,sum(spchrtarr) as t_spchrtarr,sum(strk) as t_strk,sum(sa) as t_sa,sum(thyroid) as t_thyroid,sum(vascdis) as t_vascdis
from temp2
group by bene_id;
quit;

proc sort data=temp3  nodupkey;by bene_id;run;

data data.CC2010;
set temp3;
amiihd=(t_amiihd>0);label amiihd='Acute MI / Ischemic Heart Disease';  
amputat=(t_amputat>0);label amputat='Amputation Status';
arthrit=(t_arthrit>0); label arthrit='Arthritis and Other Inflammatory Tissue Disease';
artopen=(t_artopen>0);label artopen='Artificial Openings';
bph=(t_bph>0); label bph='Benign Prostatic Hyperplasia';
cancer=(t_cancer>0);label cancer='Cancer';
chrkid=(t_chrkid>0);label chrkid='Chronic Kidney Disease';
chf=(t_chf>0);  label chf='Congestive Heart Failure';
cystfib=(t_cystfib>0); label cystfib='Cystic Fibrosis';
dementia=(t_dementia>0); label dementia='Dementia';
diabetes=(t_diabetes>0); label diabetes='Diabetes'; 
endo=(t_endo>0); label endo='Endocrine And Metabolic Disorders'; 
eyedis=(t_eyedis>0); label eyedis='Eye Disease'; 
hemadis=(t_hemadis>0); label hemadis='Hematological Disease'; 
hyperlip=(t_hyperlip>0);label hyperlip='Hyperlipidemia';  
hyperten=(t_hyperten>0);label hyperten='Hypertension';  
immunedis=(t_immunedis>0);label immunedis ='Immune Disorders'; 
ibd=(t_ibd>0);label ibd='Inflammatory Bowel Disease'; 
liver=(t_liver>0); label liver='Liver & Biliary Disease'; 
lung=(t_lung>0);  label lung='Lung Disease';
neuromusc=(t_neuromusc>0);  label neuromusc='Neuromuscular Disease';
osteo=(t_osteo>0); label osteo ='Osteporosis';
paralyt=(t_paralyt>0);label paralyt='Paralytic Diseases / Conditions';  
psydis=(t_psydis>0);label psydis='Psychiatric Disease';
sknulc=(t_sknulc>0); label sknulc='Skin Ulcer';
spchrtarr=(t_spchrtarr>0); label spchrtarr='Specified Heart Arrhythmias';
strk=(t_strk>0);label  strk='Stroke';
sa=(t_sa>0); label sa='Substance Abuse';
thyroid=(t_thyroid>0); label thyroid='Thyroid Disease';
vascdis=(t_vascdis>0);  label vascdis='Vascular Disease';
keep bene_id 
amiihd amputat arthrit  artopen  bph  
cancer  chrkid  chf  cystfib  dementia  
diabetes  endo  eyedis hemadis  hyperlip  
hyperten  immunedis  ibd liver  lung   
neuromusc  osteo  paralyt  psydis  sknulc 
spchrtarr  strk sa  thyroid  vascdis  ;
run;
 
