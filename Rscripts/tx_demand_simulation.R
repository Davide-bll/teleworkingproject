# generating fake scenarios for Utopia data

# require packs
require(dplyr)
require(purrr)
require(tidyr)
# parameters settings
years <- c(1990:2010)

# decrease of the annual demand of TX
scen <- seq(from = 0, to = 0.5, by = 0.05) %>% setNames(nm = .)

# TRANSPORTATION DEMAND (base scenario)
accumulatedannualdemand <- c(5.2,5.46,5.72,
5.98,6.24,6.5,6.76,7.02,7.28,7.54,7.8,8.189,
8.578,8.967,9.356,9.745,10.134,10.523,10.912,
11.301,11.69)

# simulate data
accumulatedannualdemand <- map_df(scen, ~accumulatedannualdemand*(1-.)) %>% 
  mutate(year = as.character(years)) %>% 
  pivot_longer(cols = 1:length(scen), names_to = "scenario", values_to = "value")

# add region column
accumulatedannualdemand <- accumulatedannualdemand %>% 
  mutate(region = "UTOPIA", fuel = "TX") %>% 
  select(region, fuel, year,  scenario, value)

# write gdx
require(gdxtools)
# set path
path <- "C:/Users/Utente/Documents/UNI-applied_statistic/1.II/climate change/GAMDS_sessions/osemosys-gams-v2/osemosys-gams/"

write.gdx(paste(path, "accumulatedannualdemands.gdx", sep = "/"),
          params = list(accumulatedannualdemands = accumulatedannualdemand))
