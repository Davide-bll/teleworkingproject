$title Set and Parameters declaration
set country /IT/ ;
set technology /HP,CC,CH,CV,CS,ST,DM,DS,FC,GC,WV,SO,WI,DI,UT,OF,ON,ZERO,MT,RF,SI, OO/;
set year/2015*2060/;
set fuel / DI,UT,OF,ON,CO,HF,NG,OI,BM,EL,WS,GO,BF,SO,HY,WI,OC,E2,HO/ ;
*set yearsplit; this is a parameter! i must load it in gams
set season /S01,S02,S03,S04,S05/;
set bracket /B1,B2,B3/;
    

* define params
parameter annualemissionlimit    (country, fuel, year);                    
parameter avaibilityfactor       (country, fuel, technology, year);                      
parameter capacityfactor         (country, fuel, technology, season, bracket, year);
parameter CapitalCost            (country, fuel, technology, year);
parameter EmissionActivityRatio  (country, fuel, technology, year);
parameter FixedCost              (country, fuel, technology, year);
parameter InputActivityRatio     (country, fuel, technology, year);
parameter OutputActivityRatio    (country, fuel, technology, year);
parameter residualcapacity       (country, fuel, technology, year);
parameter SpecifiedAnnualDemand  (country, fuel, year);
*parameter specifieddemandprofile (yearsplit, country, fuel, technology, year); this should be a function od season and bracket
parameter TotalAnnualMaxCapacity (country, fuel, technology, year);
parameter TotalAnnualMaxCapacityInvestment        (country, fuel, technology, year);
parameter TotalAnnualMinCapacity                  (country, fuel, technology, year);
parameter TotalTechnologyAnnualActivityLowerLimit (country, fuel, technology, year);
parameter TotalTechnologyAnnualActivityUpperLimit (country, fuel, technology, year);
parameter VariableCost            (country, fuel, technology, year);

* load csv file and transform them into gdx file
* "params.gdx" must be in the same folder of this script
$gdxin params.gdx
$load annualemissionlimit avaibilityfactor CapitalCost EmissionActivityRatio FixedCost InputActivityRatio OutputActivityRatio residualcapacity
$load SpecifiedAnnualDemand TotalAnnualMaxCapacity capacityfactor
$load TotalAnnualMaxCapacityInvestment TotalAnnualMinCapacity TotalTechnologyAnnualActivityLowerLimit TotalTechnologyAnnualActivityUpperLimit VariableCost
$gdxin

* display some of the loaded parameters
display annualemissionlimit, avaibilityfactor, capacityfactor;