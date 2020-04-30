$offlisting
* UTOPIA_DATA.GMS - specify Utopia Model data in format required by GAMS
*
* OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble.Noble-Soft Systems - August 2012
* OSEMOSYS 2016.08.01 update by Thorsten Burandt, Konstantin Löffler and Karlo Hainsch, TU Berlin (Workgroup for Infrastructure Policy) - October 2017
* OSEMOSYS 2020.04.13 reformatting by Giacomo Marangoni
* OSEMOSYS 2020.04.15 change yearsplit by Giacomo Marangoni

$offlisting

* OSEMOSYS 2016.08.01
* Open Source energy Modeling SYStem
*
*#      Based on UTOPIA version 5: BASE - Utopia Base Model
*#      Energy and demands in PJ/a
*#      Power plants in GW
*#      Investment and Fixed O&M Costs: Power plant: Million $ / GW (//$/kW)
*#      Investment  and Fixed O&M Costs Costs: Other plant costs: Million $/PJ/a
*#      Variable O&M (& Import) Costs: Million $ / PJ (//$/GJ)
*#
*#****************************************

*------------------------------------------------------------------------	
* Sets       
*------------------------------------------------------------------------


$offlisting
set YEAR    / 2015*2060 /;
set technology       / HPBF,CCBM,CHBM,CSBM,STBM,CHCO,CSCO,STCO,CVGO,CCHF,CHHF,GCHF,HPHF,STHF,DMHY,
                       DSHY,CCNG,CHNG,CSNG,FCNG,GCNG,HPNG,STNG,WVOC,CHWS,STWS,SODI,SOUT,WIOF,WION,
                       DISO,UTSO,OFWI,ONWI,00CO,00HF,00NG,00OI,00EL,MTEL,RFOI,SIEL,00BF,00BM,00GO,00WS
                       /;
                       
set TIMESLICE       /  S01B1,S01B2,S01B3,S02B1,S02B2,S02B3,S03B1,S03B2,S03B3,S04B1,S04B2,S04B3,S05B1,S05B2,S05B3 /;
set fuel              / DI,UT,OF,ON,CO,HF,NG,OI,BM,EL,WS,GO,BF,SO,HY,WI,OC,E2,HO/ ;
set EMISSION        / CO2 /;
set MODE_OF_OPERATION       / 1, 2 /;
set COUNTRY   / IT /;
set SEASON / S01,S02,S03,S04,S05/;
set DAYTYPE / 1 /;
*per ora!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
set BRACKET / B1,B2,B3 /   ;
set STORAGE / DAM /;

*------------------------------------------------------------------------	
* Parameters - Global
*------------------------------------------------------------------------

$gdxin params.gdx
$load annualemissionlimit availabilityfactor  CapitalCost EmissionActivityRatio FixedCost InputActivityRatio OutputActivityRatio residualcapacity
$load SpecifiedAnnualDemand TotalAnnualMaxCapacity capacityfactor
$load TotalAnnualMaxCapacityInvestment TotalAnnualMinCapacity TotalTechnologyAnnualActivityLowerLimit TotalTechnologyAnnualActivityUpperLimit VariableCost
$gdxin
* manca availabilityfactor perchè bho!!!!

parameter Conversionls(l,ls) /
S01B1.S01 1
S01B2.S01 1
S01B3.S01 1
S02B1.S02 1
S02B2.S02 1
S02B3.S02 1
S03B1.S03 1
S03B2.S03 1
S03B3.S03 1
S04B1.S04 1
S04B2.S04 1
S04B3.S04 1
S05B1.S05 1
S05B2.S05 1
S05B3.S05 1
 

            /;

parameter Conversionld(l,ld) /
S01B1.1 1
S01B2.1 1
S01B3.1 1
S02B1.1 1
S02B2.1 1
S02B3.1 1
S03B1.1 1
S03B2.1 1
S03B3.1 1
S04B1.1 1
S04B2.1 1
S04B3.1 1
S05B1.1 1
S05B2.1 1
S05B3.1 1
/;

parameter Conversionlh(l,lh) /
S01B1.B1  1    
S01B2.B2  1    
S01B3.B3  1    
S02B1.B1  1    
S02B2.B2  1    
S02B3.B3  1    
S03B1.B1  1    
S03B2.B2  1    
S03B3.B3  1    
S04B1.B1  1    
S04B2.B2  1    
S04B3.B3  1    
S05B1.B1  1    
S05B2.B2  1    
S05B3.B3  1
/;




DiscountRate(r) = 0.05;

DaySplit(y,lh) = 8/(24*365);



DaysInDayType(y,ls,ld) = 7;
*per ora!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

TradeRoute(r,rr,f,y) = 0;

DepreciationMethod(r) = 1;
*check that!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!111

*------------------------------------------------------------------------	
* Parameters - Demands       
*------------------------------------------------------------------------



*------------------------------------------------------------------------	
* Parameters - Performance       
*------------------------------------------------------------------------
*ADD values!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
CapacityToActivityUnit(r,t)=1;


CapacityFactor(r,t,l,y)$(CapacityFactor(r,t,l,y)=0)   = 1;

*the dependence on l (TIMESLICE) might be useful for instance solar PV have a 0 capacity factor during night

AvailabilityFactor(r,t,y) = 1;
*no l dependence is yearly planned outage


OperationalLife(r,t)=1;

*------------------------------------------------------------------------	
* Parameters - Technology costs       
*------------------------------------------------------------------------
*	Capital investment cost of a technology, per unit of capacity.Tipically decreasing when time passes

VariableCost(r,t,m,y)$(VariableCost(r,t,m,y)=0)   = 1e-5;
*variable cost per unity of activity (for instance for power plants activity is electricity)
*99999 to say that the cost of unmet demand is crazy high so pleas meet the demand



*------------------------------------------------------------------------	
* Parameters - Storage       
*------------------------------------------------------------------------


*we need to define the set of storages first
$ontext
parameter TechnologyToStorage(r,m,t,s) /
  UTOPIA.2.E51.DAM  1
/;

parameter TechnologyFromStorage(r,m,t,s) /
  UTOPIA.1.E51.DAM  1
/;



StorageLevelStart(r,s) = 999;

StorageMaxChargeRate(r,s) = 99;

StorageMaxDischargeRate(r,s) = 99;

MinStorageCharge(r,s,y) = 0;

OperationalLifeStorage(r,s) = 99;

CapitalCostStorage(r,s,y) = 0;

ResidualStorageCapacity(r,s,y) = 999;

$offtext

*------------------------------------------------------------------------	
* Parameters - Capacity and investment constraints       
*------------------------------------------------------------------------

CapacityOfOneTechnologyUnit(r,t,y) = 0;

TotalAnnualMaxCapacity(r,t,y)$(TotalAnnualMaxCapacity(r,t,y)=0)   = 99999999;
TotalAnnualMinCapacity(r,t,y)$(TotalAnnualMinCapacity(r,t,y)=0)   = 0;

TotalAnnualMaxCapacityInvestment(r,t,y)$(TotalAnnualMaxCapacityInvestment(r,t,y)=0)   = 99999;

TotalAnnualMinCapacityInvestment(r,t,y)=0;


*------------------------------------------------------------------------	
* Parameters - Activity constraints       
*------------------------------------------------------------------------

TotalTechnologyAnnualActivityUpperLimit(r,t,y)$(TotalTechnologyAnnualActivityUpperLimit(r,t,y)=0)   = 999999;

TotalTechnologyAnnualActivityLowerLimit(r,t,y)$(TotalTechnologyAnnualActivityLowerLimit(r,t,y)=0)   = 0;

TotalTechnologyModelPeriodActivityUpperLimit(r,t) = 999999;

TotalTechnologyModelPeriodActivityLowerLimit(r,t) = 0;


*------------------------------------------------------------------------	
* Parameters - Reserve margin
*-----------------------------------------------------------------------


ReserveMargin(r,y)=1.2;


*------------------------------------------------------------------------	
* Parameters - RE Generation Target       
*------------------------------------------------------------------------

RETagTechnology(r,t,y) = 0;

RETagFuel(r,f,y) = 0;


REMinProductionTarget(r,y) = 0;


*------------------------------------------------------------------------	
* Parameters - Emissions       
*------------------------------------------------------------------------

EmissionsPenalty(r,e,y) = 0;

AnnualExogenousEmission(r,e,y) = 0;

AnnualEmissionLimit(r,e,y) = 9999;

ModelPeriodExogenousEmission(r,e) = 0;

ModelPeriodEmissionLimit(r,e) = 9999;
*cumulated amount like CARBON BUDGET
*we are fixing the integral of emissions


