remove(list = ls())
# aggregation of OSEMBE DATA
# structure 2

# require packages----
require(dplyr)
require(stringr)
require(purrr)
require(tidyr)

# require function
# setwd("C:/Users/Utente/Desktop/gamsathome/rscripts/")
source("fromtxttocsv/user_function.R")

# read data----
capacityfactor <- read_osemosys("C:/Users/Utente/Desktop/gamsathome/data/Structure2.txt")

# DATA preparation -----
# very BAD coding: reconstruct names
technology <- c(rep("ITSODIFH1", 15),
                rep("ITSOUTPH2", 15),
                rep("ITWIOFPN2", 15),
                rep("ITWIOFPN3", 15),
                rep("ITWIONPH3", 15),
                rep("ITWIONPN3", 15))

# remove fake raws
capacityfactor <- capacityfactor %>% 
  filter(str_detect(code, "S0")) %>% 
  rename(yearsplit = code)

# add technologu id column
capacityfactor <- mutate(capacityfactor, technology = technology)
# fix 2060
capacityfactor$`2060` <- as.numeric(capacityfactor$`2060`)

# split technology into technology e fuels
capacityfactor <- capacityfactor %>% 
  separate(col = "technology", 
           into = c("country", "technology", "fuel", "altro"), 
           sep = c(2,4,6))
# arrange order column
chc <- capacityfactor %>% select_if(is.character)
num <- capacityfactor %>% select_if(is.numeric)
capacityfactor <- cbind(chc, num) %>% as_tibble()


# longer version
capacityfactor <- capacityfactor %>% pivot_longer(cols = c(6:ncol(.)), names_to = "year", values_to = "value")

# group by country, technlogy, fuel, yearsplit
capacityfactor <- capacityfactor %>% 
  group_by(country, technology, fuel, yearsplit, year) %>% 
  summarise(value = mean(value)) %>% 
  ungroup()

# separate year split
capacityfactor <- capacityfactor %>% separate("yearsplit" , into = c("season", "bracket"), sep = 3)

# write CSV----
# write.csv(capacityfactor,
#            "C:/Users/Utente/Desktop/gamsathome/data/params_gams/capacityfactor.csv")

