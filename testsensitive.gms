$title Sensitivity analysis using LOOPS (SENSTRAN,SEQ=106)

$onText
This problem performs sensitivity analysis on the TRNSPORT
problem. The basic model is taken from the GAMS model
library. A separate model is solved for each variation of the
transport cost matrix. The transport cost on each link is raised
and lowered by 30 percent and the shipment patterns are either
saved in a GAMS data table or written to file for further analysis
by a statistical system.


Dantzig, G B, Chapter 3.3. In Linear Programming and Extensions.
Princeton University Press, Princeton, New Jersey, 1963.

Keywords: linear programming, sensitivity analysis, linear programming,
          transportation problem, scheduling
$offText

Set
   i 'type of transport' /CAR,MOTO,SCOO/
   en 'type of primary energy' /ELEC
                                DIESEL
                                GASO/
   y  'years' /2015*2060/
   ind 'indice describing the positive or negative value for sensitivity' /1,2/
   ind2 'indice for proportion or consumption for sensitivity' /p,c/
   k 'sensitivity discretisation' /0*10/;
   

Parameter e(en) 'efficiency'
        / ELEC    600
          DIESEL  600
          GASO    600/;

Table p(en,i) 'proportion ofeach type of transport'
              CAR       MOTO        SCOO
   ELEC         0.1        0.1         0.1
   DIESEL       0.1        0.1         0.1
   GASO         0.1        0.1         0.1;
   
Table    c(en,i) 'consumption ofeach type of transport'
               CAR       MOTO        SCOO
   ELEC         100         50          30
   DIESEL       6           5            4
   GASO         8           6            5;

;
   
scalar nb_home 'number of teleworking days' /1/
        employee 'number of employee'       /22705660/
        average_dist 'average distance home-work' /5.94/;

Alias (y,yp),(i,ip), (en,enp,enpp), (k,kp);;

Parameter red(en,y,ind2,ind,enp,ip,k) 'transport cost in thousands of dollars per case'
           telework(y) 'proportion of the people working from home';
loop(yp,
telework(yp) = 5;
);




$sTitle Sensitivity Part for trnsport
$eolCom //



Scalar
   max_k 'maximum sensitivity discretisation' /10/;
   
Parameter se(en) 'sensitivity on efficiency'
        / ELEC    600
          DIESEL  600
          GASO    600/
          count 'counter';

Table sp(en,i) 'sensitivity : proportion of each type of transport'
               CAR       MOTO        SCOO
   ELEC         0.1         0.1         0.1
   DIESEL       0.1         0.1         0.1
   GASO         0.1         0.1         0.1;
   
Table    sc(en,i) 'sensitivity : consumption of each type of transport'
               CAR       MOTO        SCOO
   ELEC         100         50          30
   DIESEL       6           5            4
   GASO         8           6            5;


count=1;
loop(kp,
    loop((enp,ip),
       p(enp,ip)=p(enp,ip)*(1-(count/max_k)*sp(enp,ip));
       loop((enpp,yp),
       red(enpp,yp,'p','1',enp,ip,kp) = employee*average_dist*2*telework(yp)*nb_home*sum((i),p(enpp,i)*c(enpp,i)*e(enpp));
       );
       p(enp,ip)=p(enp,ip)/(1-(count/max_k)*sp(enp,ip));
       p(enp,ip)=p(enp,ip)*(1+(count/max_k)*sp(enp,ip));
       loop((enpp,yp),
       red(enpp,yp,'p','2',enp,ip,kp) = employee*average_dist*2*telework(yp)*nb_home*sum((i),p(enpp,i)*c(enpp,i)*e(enpp));
       );
       p(enp,ip)=p(enp,ip)/(1+(count/max_k)*sp(enp,ip));
*       
       c(enp,ip)=c(enp,ip)*(1-(count/max_k)*sc(enp,ip));
       loop((enpp,yp),
       red(enpp,yp,'c','2',enp,ip,kp) = employee*average_dist*2*telework(yp)*nb_home*sum((i),p(enpp,i)*c(enpp,i)*e(enpp));
       );
       c(enp,ip)=c(enp,ip)/(1-(count/max_k)*sc(enp,ip));
       c(enp,ip)=c(enp,ip)*(1+(count/max_k)*sc(enp,ip));
       loop((enpp,yp),
       red(enpp,yp,'c','2',enp,ip,kp) = employee*average_dist*2*telework(yp)*nb_home*sum((i),p(enpp,i)*c(enpp,i)*e(enpp));
       );
       c(enp,ip)=c(enp,ip)/(1+(count/max_k)*sc(enp,ip));
        count=count+1;
       
    );
);

display red

