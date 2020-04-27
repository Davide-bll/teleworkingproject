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
specifieddemandprofile <- read_osemosys("C:/Users/Utente/Desktop/gamsathome/data/specifieddemandprofile.txt")
# years splitting logic from OSEMBE data
yearsplit <- read_osemosys("C:/Users/Utente/Desktop/gamsathome/data/yearsplit.txt")

# DATA preparation -----
# very BAD coding: reconstruct names
technology <- c(rep("ITE2", 15))

# # remove fake raws
# specifieddemandprofile <- specifieddemandprofile %>% 
#   filter(str_detect(code, "S0"))

# add technologu id column
specifieddemandprofile <- mutate(specifieddemandprofile, technology = technology)

# arrange order column
chc <- specifieddemandprofile %>% select_if(is.character)
num <- specifieddemandprofile %>% select_if(is.numeric)
specifieddemandprofile <- cbind(chc, num) %>% as_tibble()

# separate column
specifieddemandprofile <- separate(specifieddemandprofile, col = "technology", into = c("country", "fuel"), sep = 2)
help("pivot_longer")

# pivot to wider
specifieddemandprofile <- pivot_longer(specifieddemandprofile, cols = c(4:ncol(specifieddemandprofile)), names_to = "year", values_to = "value")
# write CSV----
# write.csv(specifieddemandprofile,
#          "C:/Users/Utente/Desktop/gamsathome/data/params_gams/specifieddemandprofile.csv")

