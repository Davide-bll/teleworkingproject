# emission activity ration
remove(list = ls())
# aggregation of OSEMBE DATA
# structure 2

# require packages----
require(dplyr)
require(stringr)
require(purrr)
require(tidyr)

# require function----
# setwd("C:/Users/Utente/Desktop/gamsathome/rscripts/")
source("fromtxttocsv/user_function.R")

# load data -----
# read data----
# find files
path <- "C:/Users/Utente/Desktop/gamsathome/data/structure3/"
s3names <- list.files(path)

s3list <- map(s3names, ~read_osemosys(paste(path, .x, sep = "/"))) %>% 
  setNames(nm = str_remove(s3names, ".txt"))

# fix 2060 column
# convert to standard table from this (very shi--y format)
s3list <- map(s3list, convert_struct3)
s3list <- map(s3list, ~mutate_at(., vars('2060'), as.numeric))

# convert to std mode
s3list <- map(s3list , ~convert_tb(., col = "technology", 
                          into = c("country", "fuel", "technology", "altro"), 
                          sep = c(2,4,6)))
# aggregate----
actions <- list(mean,
                mean,
                mean,
                sum
                )

grps <- list(
  c("country", "technology", "fuel", "mode", "year"),
  c("country", "technology", "fuel", "mode", "year"),
  c("country", "technology", "fuel", "mode", "year"),
  c("country", "technology", "fuel", "mode", "year")
)

# arguments
args <- list(x   = s3list, 
             grp = grps, 
             f   = actions)

# s3list
s3list <- pmap(args, my_group_by)

# add emission in emissionactivityratio
s3list$EmissionActivityRatio <- s3list$EmissionActivityRatio %>% 
  mutate(emission = "CO2") %>% 
  select(country, emission, technology, fuel, mode, year, value)

# # write csv
# imap(s3list, ~write.csv(.x, 
#                         paste("C:/Users/Utente/Desktop/gamsathome/data/params_gams/", paste0(.y, ".csv"),  sep = "/"), 
#               row.names = FALSE))
