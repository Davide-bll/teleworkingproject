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

# disaggregate the 9 letters tag.. treat diffeent outputactivityratio
prds <- names(s3list)[c(1,2,4)]
# convert to std mode_of_operation
s3list[prds] <- map(s3list[prds] , ~convert_tb(., col = "technology", 
                                               into = c("country", "fuel", "technology", "altro"), 
                                               sep = c(2,4,6)))
# aggregate----
actions <- list(mean,
                mean,
                sum)

grps <- list(
  c("country", "technology", "fuel", "mode_of_operation", "year"),
  c("country", "technology", "fuel", "mode_of_operation", "year"),
  c("country", "technology", "fuel", "mode_of_operation", "year")
)

# arguments
args <- list(x   = s3list[prds], 
             grp = grps, 
             f   = actions)

# s3list
s3list[prds] <- pmap(args, my_group_by)

# add emission in emissionactivityratio
s3list$EmissionActivityRatio <- s3list$EmissionActivityRatio %>% 
  mutate(emission = "CO2") %>% 
  select(country, emission, technology, fuel, mode_of_operation, year, value)

# outputactivityratio-----
# this is a structure 4 btw
s3list$OutputActivityRatio <- s3list$OutputActivityRatio %>% 
  convert_tb(col = "technology", into = c("country", "technology", "altro", "fuel"), sep = c(2,6,12)) %>%
  filter(!endsWith(technology, "00")) %>% 
  group_by(country, technology, fuel, mode_of_operation, year) %>% 
  summarise(value = mean(value, na.rm = TRUE)) %>% 
  ungroup()

# ABCDE -> DEABC 
revert_string <- function(x, l = 2) {
  purrr::map_chr(x, ~c(substring(., l + 1, nchar(.)), substring(., 1, l)) %>% 
                   paste(collapse = ""))
}


s3list$OutputActivityRatio <- s3list$OutputActivityRatio %>% 
  mutate(technology = revert_string(technology))

# # write csv
# imap(s3list, ~write.csv(.x,
#                         paste("C:/Users/Utente/Desktop/gamsathome/data/params_gams/", paste0(.y, ".csv"),  sep = "/"),
#               row.names = FALSE))
