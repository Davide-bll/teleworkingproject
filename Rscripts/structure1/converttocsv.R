remove(list = ls())

# packages
require(tibble)
require(tidyr)
require(dplyr)
require(stringr)

# set paths-----
path_input <- "C:/Users/Utente/Desktop/gamsathome/data"
path_scripts <- "C:/Users/Utente/Desktop/gamsathome/rscripts" 
path_out <- "C:/Users/Utente/Desktop/gamsathome/data/parameters"
path_out_italy <- "C:/Users/Utente/Desktop/gamsathome/data/parameters_italy"

# ext scripts-----
source(paste(path_scripts, "param_mapping.R", sep = "/"))
source(paste(path_scripts, "user_function.R", sep = "/"))

# data preparation----
# read data
allparams <- read_osemosys(paste(path_input, "allparams2.txt", sep = "/"))

# find first countries
allparams <- allparams %>% separate(code, into = "country", sep = c(2), remove = FALSE) %>% 
  left_join(mapping_country, by = "country")

# drop "CO2" emission limit, it doesn't make sense since we're only studyng Italy
allparams <- allparams %>% filter(!is.na(ID))

# all params
allparams <- allparams %>% mutate(start_new = detect_first_true(ID))

# drop some columns 
allparams <- allparams %>% select(-country, -ID)

# split by par
allparams <- split(allparams, allparams[["start_new"]])

names(allparams) <- namesparams
names(into)      <- namesparams
names(sep)       <- namesparams

# drop "start_new" column
allparams <- allparams %>% purrr::map(~select(., -start_new))

# data conversion-----
# create list of input
args <- list(into = into, sep = sep, x = allparams)

# convert list of dataframes
allparams <- purrr::pmap(args, convert_tb)

# write csv-----
purrr::imap(allparams, ~write.csv(x = .x, file = paste0(path_out, "/",  .y, ".csv")))

# save list of data
saveRDS(allparams, paste(path_out, "allparams.R", sep = "/"))

# save only italt data----
params_italy <- purrr::map(allparams, ~filter(., country == "IT"))

purrr::imap(params_italy, ~write.csv(x = .x, file = paste0(path_out_italy, "/",  .y, ".csv")))

saveRDS(params_italy, paste(path_out_italy, "allparams_italy.R", sep = "/"))