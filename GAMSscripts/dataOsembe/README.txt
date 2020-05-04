	====================================================================
Open Source energy Model Base for the European Union (OSeMBE)
====================================================================

Energy model base for the European Union developed using the OSeMOSYS Modelling Framework.
The model provides country-detailed representation of the 28 European Union (EU) Member States + Switzerland and Norway. The model aims at being used as a multi-regional stakeholders engagement model at the European level.


Features
++++++++++++++++++

Time representation
--------------------------------
Modelling period: from 2015 to 2050
Year split: 3 seasons, 1 typical day per season, 3 time slices per day. For the definition of the timely resolution typical daily load curves were identified and used to define the time slices, taking into consideration also the variability of Renewable Energy Sources (vRES).

Regional representation
---------------------------
Regional definition: each of the countries represented in the model (EU 28 Member States + Switzerland and Norway) corresponds to a region in the model.

Countries
------------
Austria (AT), Belgium (BE), Bulgaria (BG), Switzerland (CH), Cyprus (CY), Czech Republic (CZ), Germany (DE), Denmark (DK), Estonia (EE), Spain (ES), Finland (FI), France (FR), Greece (GR), Croatia (HR), Hungary (HU), Ireland (IE), Italy (IT), Lithuania (LT), Luxembourg (LU), Latvia (LV), Malta (MT), Netherlands (NL), Norway (NO), Poland (PL), Portugal (PT), Romania (RO), Sweden (SE), Slovenia (SI), Slovakia (SK), United Kingdom (UK).

Technologies representation 
-------------------------------
The model takes into account up to 50 technology-fuel combinations per country.

Commodities
--------------
The energy commodities available in the model are the following: 
Bio fuel (BF), Biomass (BM), Coal (CO), Electricity (EL), Electricity 1 (E1), Electricity 2 (E2), Geothermal (GO), Heavy fuel oil (HF), Hydro (HY), Natural gas (NG), Nuclear (NU), Ocean (OC), Oil (OI), Sun (SO), Uranium (UR), Waste (WS), and Wind (WI).

Emissions
------------
Carbon dioxide (CO2), Particle matter 2.5 (PM25)

Technology types
--------------------
The types of energy technologies available in the model are the following: 
Combined cycle (CC), Combined Heat and power (CH), Carbon Capture and Storage (CS), Conventional (CV), Distributed PV (DI), Dam (DM), Pumped Storage (storage not modeled, considering the capacity with identical characteristics as hydro dam)(DS), Fuel cell (FC), Gas cycle (GC), Generation 2 (G2), Generation 3 (G3), Internal combustion engine with heat recovery (HP), Offshore (OF), Onshore (ON), Refinery (RF), Steam cycle (ST), Transmission&Distribution (TD), Utility PV (UT), Wave (WV).

Technology naming in OSeMBE
------------------------------
AA 			BB			CC 								D 				E 		F		--> AABBCCDEF 
Country		Commodity	Technology/connected country	Energy level	Age		Size

Country: 		see above in "Countries" for country codes
Commodity: 		see above in "Commodities" for commodity codes
Technology: 	see above in "Technology types" for technology codes
Energy level: 	either "P" if primary energy commodity as output, or "F" if final electricity as output, "I" for import technology, "X" for extraction or generation technology
Age: 			"H" if existing/old technology, "N" if new or upcoming technology
Size: 			"0", "1", "2", or "3"'

Note: Age and size are rather indicative and only of real relevance if several similar technologies are considered.


Commodity naming in OSeMBE
-----------------------------
AA 			BB			--> AABB
Country		Commodity

Country: 		see above in "Countries" for country codes
Commodity: 		see above in "Commodities" for commodity codes


Requirements
++++++++++++++++++++
Model file: 2019-07-31_OSeMOSYS_EU-28.txt
Data file: OSeMBE_data_V1R1.txt
Optimization software: CPLEX Optimizer

The model can run using the CPLEX solver, through the Windows command (cmd) prompt (for instructions on how to run and OSeMOSYS Model through cmd, please see the documentation available at: http://osemosys.readthedocs.io)


Support
+++++++++++++
For support, please go to the Q&A Forum webpage of the OSeMOSYS Community (https://groups.google.com/forum/#!forum/osemosys) or send an email to the following email addresses:
- OSeMOSYS Community: osemosys@gmail.com
- Hauke Henke: haukeh@kth.se


Authors and acknowledgment
++++++++++++++++++++++++++++++++

Author: Hauke T.J. Henke, PhD candidate at the division of Energy Systems Analysis, Department of Energy Technologies (KTH Royal Institute of Technology, Sweden).
Acknowledgment: the model has been developed as part of the REEEM project, funded by the European Union's Horizon 2020 Research and Innovation Programme under grant agreement No Number EU-691739.


License
+++++++++++
The OSeMOSYS modelling framework is licensed under the Apache License, Version 2.0 (the "License").
The OSeMBE model data file is licensed under the Creative Commons Attribution 4.0 International License, Version 4.0 (CC-BY-4.0).
For more information on how to correctly reference this model, pleas see the following websites: 
- Apache License: http://www.apache.org/licenses/LICENSE-2.0
- Creative Commons Attribution License; https://spdx.org/licenses/CC-BY-4.0.html


Project Status
++++++++++++++++++++++++

31 July 2019
--------------------
A thorough calibration has been carried out in spring 2019.
The funding project REEEM ended in July 2019.
The model development and updates will continue, but less continous.



