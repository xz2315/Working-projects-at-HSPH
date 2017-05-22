**************************************
Forest Plot
Xiner Zhou
12/8/2014
***************************************;
 

proc format ;
value value_
1='Overall'
2='Hospital Size (Small)'
3='Hospital Size (Medium)'
4='Hospital Size (Large)'
5='Ownership (Investor Owned)'
6='Ownership (Non-Government, Not-For-Profit)'
7='Ownership (Government,Non-Federal)'
8='System-Affiliation (No)'
9='System-Affiliation (Yes)'
;
run;


data forest;                                                                                                                            
   input var  $1-42 value1 43-44 value2 45-46 diffindiff 47-53 lowerCL 54-61 UpperCL 62-67;                                                                                                                                                     
     value=_n_;                                                                                                                         
   DD='Diff-in-Diff'; LCL='LCL'; UCL='UCL';                                                                                          
   x1=0.3;x2=0.4;x3=0.5;  
format value value_.; format value1 value_.;format value2 value_.;  
datalines;                                                                                                                              
Overall                                   1 . 0.0978 0.0669  0.1288 
Hospital Size (Small)                     . 2 0.1101 0.0722  0.1481
Hospital Size (Median)                    . 3 0.083  0.0254  0.1405
Hosptial Size (Large)                     . 4 0.0244 -0.1488 0.1976
Ownership (Investor Owned)                . 5 0.1405 0.0865  0.1945
Ownership (Non-Government,Not-For-Profit) . 6 0.0041 -0.0637 0.072
Ownership (Government,Non-Federal)        . 7 0.0712 0.0083  0.134
System-Affiliation (No)                   . 8 0.0854  0.0424  0.1285
System-Affiliation (Yes)                  . 9 0.0992 0.0591  0.1393
;                                                                                                                                       
run;

 

ods listing close;                                                                                                                      
ods html image_dpi=100 path="C:\data\Projects" file='sgplotforest.html';                                                                               
ods graphics / reset width=600px height=400px imagename="Forest_Plot" imagefmt=gif;                                              
                                                                                                                                        
title "Impact of HITECH on EHR adoption";                                                                                      
title2 h=8pt 'Diff-in-Diff and 95% CL';                                                                                                   
                                                                                                                                        
proc sgplot data=forest  noautolegend;   
 
   *scatter y=value1 x=diffindiff / markerattrs=graphdata2(symbol=diamondfilled size=10);  * plot Overall;                                          
   scatter y=value x=diffindiff / xerrorupper=upperCL xerrorlower=lowerCL markerattrs=graphdata1(symbol=squarefilled size=8 color=red);  * plot all other ;           
   *vector x=upperCL y=value2 / xorigin=lowerCL yorigin=value lineattrs=graphdata1(thickness=1) noarrowheads;   * plot boxes in the middle;                           
   scatter y=value x=DD / markerchar=diffindiff x2axis; * in the second (right panel), plot OR column;                                                                            
   scatter y=value x=LCL / markerchar=lowercl x2axis;                                                                              
   scatter y=value x=UCL / markerchar=uppercl x2axis;                                                                              
                                                                                
   *refline 0.0978  / axis=x;                                                                                                             
   refline 0 / axis=x lineattrs=(pattern=shortdash) transparency=0.5;                                                              
   *inset '        Less than overall'  / position=bottomleft;                                                                             
   *inset 'Larger than overall'  / position=bottom;                                                                                           
   xaxis   offsetmin=0 offsetmax=0.35 min=-0.2 max=0.2 minor display=(nolabel) ;                                                 
   x2axis offsetmin=0.7 display=(noticks nolabel);                                                                                      
   yaxis display=(noticks nolabel) offsetmin=0.1 offsetmax=0.05 values=(1 to 9 by 1);                                              
run;                                                                                                                                    
                                                                                                                                        
ods html close;                                                                                                                         
ods listing;



 
    
