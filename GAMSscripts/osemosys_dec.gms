* OSEMOSYS_DEC.GMS - declarations for sets, parameters, variables (but not equations)
*
* OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012
* OSEMOSYS 2017.11.08 update by Thorsten Burandt, Konstantin Löffler and Karlo Hainsch, TU Berlin (Workgroup for Infrastructure Policy) - October 2017
*
* OSEMOSYS 2017.11.08
* Open Source energy Modeling SYStem
*
* ============================================================================
*
* #########################################
* ######################## Model Definition #############
* #########################################
*
* ##############
* # Sets #
* ##############
*
set YEAR;
alias (y,yy,YEAR);
* miss transportation
set TECHNOLOGY; 
alias (t,TECHNOLOGY)
* modify structure 2 parameters
set TIMESLICE;
alias (l,TIMESLICE);
set FUEL;
alias (f,FUEL);
* add set??????????????????????????????????????????????????????????
set EMISSION;
alias (e,EMISSION);
set MODE_OF_OPERATION;
alias (m,MODE_OF_OPERATION);
set COUNTRY;
alias (r,COUNTRY,rr);
set SEASON;
alias (ls,SEASON,lsls);
set DAYTYPE;
alias (ld,DAYTYPE,ldld);
set BRACKET;
alias (lh,BRACKET,lhlh);
set STORAGE;
alias (s,STORAGE);

*
* ####################
* # Parameters #
* ####################
*
* ####### Global #############
*
parameter YearSplit(SEASON, BRACKET,YEAR);
parameter DiscountRate(COUNTRY);
parameter DaySplit(YEAR,BRACKET);
parameter Conversionls(TIMESLICE,SEASON);
parameter Conversionld(TIMESLICE,DAYTYPE);
parameter Conversionlh(TIMESLICE,BRACKET);
parameter DaysInDayType(YEAR,SEASON,DAYTYPE);
parameter TradeRoute(COUNTRY,rr,FUEL,YEAR);
parameter DepreciationMethod(COUNTRY);
*
* ####### Demands #############
*we'll need values for technology
parameter SpecifiedAnnualDemand(COUNTRY,FUEL,YEAR);
parameter SpecifiedDemandProfile(COUNTRY,FUEL,TIMESLICE,YEAR);
* used if the demand does not depend on the timeslice
parameter AccumulatedAnnualDemand(COUNTRY,FUEL,YEAR);

* ######## Performance #############
*
parameter CapacityToActivityUnit(COUNTRY,TECHNOLOGY);
parameter CapacityFactor(COUNTRY,TECHNOLOGY,TIMESLICE,YEAR);
parameter AvailabilityFactor(COUNTRY,TECHNOLOGY,YEAR);
parameter OperationalLife(COUNTRY,TECHNOLOGY);
parameter ResidualCapacity(COUNTRY,TECHNOLOGY,YEAR);
parameter InputActivityRatio(COUNTRY,TECHNOLOGY,FUEL,MODE_OF_OPERATION,YEAR);
parameter OutputActivityRatio(COUNTRY,TECHNOLOGY,FUEL,MODE_OF_OPERATION,YEAR);
*
* ######## Technology Costs #############
*
parameter CapitalCost(COUNTRY,TECHNOLOGY,YEAR);
parameter VariableCost(COUNTRY,TECHNOLOGY,MODE_OF_OPERATION,YEAR);
parameter FixedCost(COUNTRY,TECHNOLOGY,YEAR);
*
* ######## Storage Parameters #############
*??? may be 0 ??? 
parameter TechnologyToStorage(COUNTRY,MODE_OF_OPERATION,TECHNOLOGY,STORAGE);
parameter TechnologyFromStorage(COUNTRY,MODE_OF_OPERATION,TECHNOLOGY,STORAGE);
parameter StorageLevelStart(COUNTRY,STORAGE);
parameter StorageMaxChargeRate(COUNTRY,STORAGE);
parameter StorageMaxDischargeRate(COUNTRY,STORAGE);
parameter MinStorageCharge(COUNTRY,STORAGE,YEAR);
parameter OperationalLifeStorage(COUNTRY,STORAGE);
parameter CapitalCostStorage(COUNTRY,STORAGE,YEAR);
parameter ResidualStorageCapacity(COUNTRY,STORAGE,YEAR);
*
* ######## Capacity Constraints #############
*
parameter CapacityOfOneTechnologyUnit(COUNTRY,TECHNOLOGY,YEAR);
parameter TotalAnnualMaxCapacity(COUNTRY,TECHNOLOGY,YEAR);
parameter TotalAnnualMinCapacity(COUNTRY,TECHNOLOGY,YEAR);
*
* ######## Investment Constraints #############
*
parameter TotalAnnualMaxCapacityInvestment(COUNTRY,TECHNOLOGY,YEAR);
parameter TotalAnnualMinCapacityInvestment(COUNTRY,TECHNOLOGY,YEAR);
*
* ######## Activity Constraints #############
*
parameter TotalTechnologyAnnualActivityUpperLimit(COUNTRY,TECHNOLOGY,YEAR);
parameter TotalTechnologyAnnualActivityLowerLimit(COUNTRY,TECHNOLOGY,YEAR);
parameter TotalTechnologyModelPeriodActivityUpperLimit(COUNTRY,TECHNOLOGY);
parameter TotalTechnologyModelPeriodActivityLowerLimit(COUNTRY,TECHNOLOGY);
*
* ######## Reserve Margin ############
*
parameter ReserveMarginTagTechnology(COUNTRY,TECHNOLOGY,YEAR);
parameter ReserveMarginTagFuel(COUNTRY,FUEL,YEAR);
parameter ReserveMargin(COUNTRY,YEAR);
*
* ######## RE Generation Target ############
*
parameter RETagTechnology(COUNTRY,TECHNOLOGY,YEAR);
parameter RETagFuel(COUNTRY,FUEL,YEAR);
parameter REMinProductionTarget(COUNTRY,YEAR);
*
* ######### Emissions & Penalties #############
*check what we have
parameter EmissionActivityRatio(COUNTRY,TECHNOLOGY,EMISSION,MODE_OF_OPERATION,YEAR);
parameter EmissionsPenalty(COUNTRY,EMISSION,YEAR);
parameter AnnualExogenousEmission(COUNTRY,EMISSION,YEAR);
parameter AnnualEmissionLimit(COUNTRY,EMISSION,YEAR);
*emission unit of measurement!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! EMISSION O FUEL? probably (COUNTRY,EMISSION,fuel,YEAR);
parameter ModelPeriodExogenousEmission(COUNTRY,EMISSION);
parameter ModelPeriodEmissionLimit(COUNTRY,EMISSION);

*

* #####################
* # Model Variables #
* #####################
*
* ############### Demands ############
*
positive variable RateOfDemand(COUNTRY,TIMESLICE,FUEL,YEAR);
positive variable Demand(COUNTRY,TIMESLICE,FUEL,YEAR);
*
* ############### Storage ###########
*
free variable  RateOfStorageCharge(COUNTRY,STORAGE,SEASON,DAYTYPE,BRACKET,YEAR);
free variable  RateOfStorageDischarge(COUNTRY,STORAGE,SEASON,DAYTYPE,BRACKET,YEAR);
free variable  NetChargeWithinYear(COUNTRY,STORAGE,SEASON,DAYTYPE,BRACKET,YEAR);
free variable  NetChargeWithinDay(COUNTRY,STORAGE,SEASON,DAYTYPE,BRACKET,YEAR);
positive variable StorageLevelYearStart(COUNTRY,STORAGE,YEAR);
positive variable StorageLevelYearFinish(COUNTRY,STORAGE,YEAR);
positive variable StorageLevelSeasonStart(COUNTRY,STORAGE,SEASON,YEAR);
positive variable StorageLevelDayTypeStart(COUNTRY,STORAGE,SEASON,DAYTYPE,YEAR);
positive variable StorageLevelDayTypeFinish(COUNTRY,STORAGE,SEASON,DAYTYPE,YEAR);
positive variable StorageLowerLimit(COUNTRY,STORAGE,YEAR);
positive variable StorageUpperLimit(COUNTRY,STORAGE,YEAR);
positive variable AccumulatedNewStorageCapacity(COUNTRY,STORAGE,YEAR);
positive variable NewStorageCapacity(COUNTRY,STORAGE,YEAR);
positive variable CapitalInvestmentStorage(COUNTRY,STORAGE,YEAR);
positive variable DiscountedCapitalInvestmentStorage(COUNTRY,STORAGE,YEAR);
positive variable SalvageValueStorage(COUNTRY,STORAGE,YEAR);
positive variable DiscountedSalvageValueStorage(COUNTRY,STORAGE,YEAR);
positive variable TotalDiscountedStorageCost(COUNTRY,STORAGE,YEAR);
*
* ############### Capacity Variables ############
*
integer variable NumberOfNewTechnologyUnits(COUNTRY,TECHNOLOGY,YEAR);
positive variable NewCapacity(COUNTRY,TECHNOLOGY,YEAR);
positive variable AccumulatedNewCapacity(COUNTRY,TECHNOLOGY,YEAR);
positive variable TotalCapacityAnnual(COUNTRY,TECHNOLOGY,YEAR);
*
* ############### Activity Variables #############
*
positive variable RateOfActivity(COUNTRY,TIMESLICE,TECHNOLOGY,MODE_OF_OPERATION,YEAR);
positive variable RateOfTotalActivity(COUNTRY,TIMESLICE,TECHNOLOGY,YEAR);
positive variable TotalTechnologyAnnualActivity(COUNTRY,TECHNOLOGY,YEAR);
positive variable TotalAnnualTechnologyActivityByMode(COUNTRY,TECHNOLOGY,MODE_OF_OPERATION,YEAR);
positive variable RateOfProductionByTechnologyByMode(COUNTRY,TIMESLICE,TECHNOLOGY,MODE_OF_OPERATION,FUEL,YEAR);
positive variable RateOfProductionByTechnology(COUNTRY,TIMESLICE,TECHNOLOGY,FUEL,YEAR);
positive variable ProductionByTechnology(COUNTRY,TIMESLICE,TECHNOLOGY,FUEL,YEAR);
positive variable ProductionByTechnologyAnnual(COUNTRY,TECHNOLOGY,FUEL,YEAR);
positive variable RateOfProduction(COUNTRY,TIMESLICE,FUEL,YEAR);
positive variable Production(COUNTRY,TIMESLICE,FUEL,YEAR);
positive variable RateOfUseByTechnologyByMode(COUNTRY,TIMESLICE,TECHNOLOGY,MODE_OF_OPERATION,FUEL,YEAR);
positive variable RateOfUseByTechnology(COUNTRY,TIMESLICE,TECHNOLOGY,FUEL,YEAR);
positive variable UseByTechnologyAnnual(COUNTRY,TECHNOLOGY,FUEL,YEAR);
positive variable RateOfUse(COUNTRY,TIMESLICE,FUEL,YEAR);
positive variable UseByTechnology(COUNTRY,TIMESLICE,TECHNOLOGY,FUEL,YEAR);
positive variable Use(COUNTRY,TIMESLICE,FUEL,YEAR);
positive variable Trade(COUNTRY,rr,TIMESLICE,FUEL,YEAR);
positive variable TradeAnnual(COUNTRY,rr,FUEL,YEAR);
*
positive variable ProductionAnnual(COUNTRY,FUEL,YEAR);
positive variable UseAnnual(COUNTRY,FUEL,YEAR);
*
* ############### Costing Variables #############
*
positive variable CapitalInvestment(COUNTRY,TECHNOLOGY,YEAR);
positive variable DiscountedCapitalInvestment(COUNTRY,TECHNOLOGY,YEAR);
*
positive variable SalvageValue(COUNTRY,TECHNOLOGY,YEAR);
positive variable DiscountedSalvageValue(COUNTRY,TECHNOLOGY,YEAR);
positive variable OperatingCost(COUNTRY,TECHNOLOGY,YEAR);
positive variable DiscountedOperatingCost(COUNTRY,TECHNOLOGY,YEAR);
*
positive variable AnnualVariableOperatingCost(COUNTRY,TECHNOLOGY,YEAR);
positive variable AnnualFixedOperatingCost(COUNTRY,TECHNOLOGY,YEAR);
positive variable VariableOperatingCost(COUNTRY,TIMESLICE,TECHNOLOGY,YEAR);
*
positive variable TotalDiscountedCostByTechnology(COUNTRY,TECHNOLOGY,YEAR);
positive variable TotalDiscountedCost(COUNTRY,YEAR);
*
positive variable ModelPeriodCostByRegion(COUNTRY);
*
* ######## Reserve Margin #############
*
positive variable TotalCapacityInReserveMargin(COUNTRY,YEAR);
positive variable DemandNeedingReserveMargin(COUNTRY,TIMESLICE,YEAR);
*
* ######## RE Gen Target #############
*
free variable TotalREProductionAnnual(COUNTRY,YEAR);
free variable RETotalProductionOfTargetFuelAnnual(COUNTRY,YEAR);
*
free variable TotalTechnologyModelPeriodActivity(COUNTRY,TECHNOLOGY);
*
* ######## Emissions #############
*
positive variable AnnualTechnologyEmissionByMode(COUNTRY,TECHNOLOGY,EMISSION,MODE_OF_OPERATION,YEAR);
positive variable AnnualTechnologyEmission(COUNTRY,TECHNOLOGY,EMISSION,YEAR);
positive variable AnnualTechnologyEmissionPenaltyByEmission(COUNTRY,TECHNOLOGY,EMISSION,YEAR);
positive variable AnnualTechnologyEmissionsPenalty(COUNTRY,TECHNOLOGY,YEAR);
positive variable DiscountedTechnologyEmissionsPenalty(COUNTRY,TECHNOLOGY,YEAR);
positive variable AnnualEmissions(COUNTRY,EMISSION,YEAR);
positive variable ModelPeriodEmissions(EMISSION,COUNTRY);