*
* OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012
* OSEMOSYS 2017.11.08 update by Thorsten Burandt, Konstantin Löffler and Karlo Hainsch, TU Berlin (Workgroup for Infrastructure Policy) - October 2017
* OSEMOSYS 2020.04.15 scenario execute unload by Giacomo Marangoni
*
* Files required are:
* osemosys.gms (this file)
* osemosys_dec.gms
* utopia_data.gms
* osemosys_equ.gms
*
* To run this GAMS version of OSeMOSYS on your PC:
* 1. YOU MUST HAVE GAMS VERSION 22.7 OR HIGHER INSTALLED.
* This is because OSeMOSYS has some parameter, variable and equation names
* that exceed 31 characters in length, and GAMS versions prior to 22.7 have
* a limit of 31 characters on the length of such names.
* 2. Ensure that your PATH contains the GAMS Home Folder.
* 3. Place all 4 of the above files in a convenient folder,
* open a Command Prompt window in this folder, and enter:
* gams osemosys.gms
* 4. You should find that you get an optimal value of 29446.861.
* 5. Some results are created in file SelResults.CSV that you can view in Excel.
*
* declarations for sets, parameters, variables
$setglobal scen base 1 
$offlisting
$include osemosys_dec.gms
* specify Utopia Model data
*set SCENARIO / '0', '0.05' , '0.10','0.15','0.20','0.25','0.30','0.35','0.40','0.45','0.50'/ ;
set SCENARIO / '0', '0.05'/;
parameter accumulatedannualdemands(REGION, FUEL, YEAR, SCENARIO);
parameter names(SCENARIO);
names(SCENARIO) = ord(SCENARIO);

$include utopia_data.gms
* define model equations
$include osemosys_equ.gms
model osemosys /all/;
option limrow=0, limcol=0, solprint=on;

* load scenario dependent parameters
$gdxin accumulatedannualdemands
$load accumulatedannualdemands
$gdxin

* prepare file for reporting
FILE ANT /SelResults.CSV/;
PUT ANT; ANT.ND=6; ANT.PW=400; ANT.PC=5;

loop(SCENARIO,
*assign accuulated annual demand
AccumulatedAnnualDemand(r,f,y) = AccumulatedAnnualDemands(r,f,y,SCENARIO);
$onlisting
* solve the model
solve osemosys minimizing z using MIP;
* create results in file SelResults.CSV

$include osemosys_res.gms
execute_unload 'results_%names%.gdx';
)
PUTCLOSE ANT;
