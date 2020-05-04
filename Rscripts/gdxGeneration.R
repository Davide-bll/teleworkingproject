remove(list = ls())

# gdx paraeters generation 
require(gdxtools)
require(purrr)
require(tidyr)
require(dplyr)
require(stringr)

# set path data
path <- "C:/Users/Utente/Desktop/gamsathome/data/params_gams/"

# functions ----
# fix names
rename_commodity <- function(x, old = "commodity", new = "fuel") {
  if(old %in% names(x)) {
    
    x <- x %>% rename(!!sym(new) := old)
  }
  x
} 

# change HO with HY
.change_code <-function(x, old = "HO", new = "HY") {
  if(x == old) x <- new
  x
}

change_code <- function(x, old = "HO", new = "HY") {
  map_chr(x, .change_code, old = old, new = new)
}

# load data
paramlist <- list.files(path = path, pattern = ".csv")

# readdata
list_param <- map(paramlist, ~read.csv(file = paste(path, ., sep = "/"),
                                       header = TRUE, stringsAsFactors = FALSE) %>% 
                    as_tibble) %>% 
  setNames(nm = str_remove(paramlist, ".csv")) 

# Data preparation ----------
# rename commodity in fuel
list_param <- map(list_param, rename_commodity)

# this could have been avoided using row.names = FALSE in write.csv
list_param <- list_param %>% map(~.[which(!(str_detect(names(.), "X")))])

map(list_param, ~select(., -value) %>% 
      group_by_all(.) %>% count() %>% filter(n>1)) %>% 
  map_dbl(nrow) %>% sum()

# fix "00" -------
# check duplicates: if EVERY thing is right, this sum is zero

# subset tibbls containing fuel, and change "HO" in "HY"
predicates <- map_lgl(list_param, function(x) "fuel" %in% names(x))
list_param[predicates] <- map(list_param[predicates], ~mutate(., fuel = change_code(fuel)))

#drop raws with "00" in technology
predicates <- map_lgl(list_param, function(x) "technology" %in% names(x))

# remove 0 or 00 from technology
list_param[predicates] <- list_param[predicates] %>% 
  map(~filter(., !(technology == "0" |technology == "00")))

# remove 0 rows df
param <- map(list_param, nrow) %>%
  map_df(as_tibble,.id = "param") %>% 
  filter(value > 0) %>% 
  pull(param)

list_param <- list_param[param]

# OPTION2----
# aggregate fuel and technology, and "duplicate the fuel col when is necessary, and fix manually the values"
duplicates_fuel <- c("InputActivityRatio")

predicates <- list_param %>% 
  map_lgl(., ~(any(str_detect(names(.), "fuel")) & any(str_detect(names(.), "technology"))))

predicates <- setdiff(names(list_param)[predicates], "OutputActivityRatio")
duplicate_fuel <- !(predicates %in% duplicates_fuel)

list_param[predicates] <- map2(.x = list_param[predicates], .y = duplicate_fuel,
               ~unite(.x, "technology", c("technology", "fuel"), 
                      sep = "", 
                      remove = .y))

names(list_param)[[2]] <- "availabilityfactor"

# fix input activity ratio fuel column
# EL -> E1
list_param$InputActivityRatio <- list_param$InputActivityRatio %>%
mutate(fuel = ifelse(endsWith(technology, "EL") & fuel == "EL", "E1", fuel)) 
  


#### change order of columns (this is done to preserv the equations strcture in gams) ------

list_param$EmissionActivityRatio <- list_param$EmissionActivityRatio %>% 
  #arrange
  select(country, emission, technology, mode_of_operation, year, value)

# add emission column
list_param$annualemissionlimit <- list_param$annualemissionlimit %>% 
  mutate(emission = "CO2") %>% 
  select(country, emission, fuel, year, value)
 

# exclude NA technologies (by combination)
techs_na<- readRDS("C:/Users/Utente/Desktop/gamsathome/data/Techs_na.R") %>% 
  pull(code)

#drop raws with "00" in technology
predicates <- map_lgl(list_param, function(x) "technology" %in% names(x))

# remove 0 or 00 from technology
list_param[predicates] <- list_param[predicates] %>% 
  map(~filter(., !(technology %in% techs_na)))

# write R files in dataexploration App folder
saveRDS(list_param,"C:/Users/Utente/Desktop/shiny_modules/DataExploration_2/data/list_param.R")
# write gdx
write.gdx("C:/Users/Utente/Desktop/gamsathome/gamsscript/params",
params = list_param)
# write gdx
write.csv(techs_na, file = "C:/Users/Utente/Desktop/gamsathome/data/techs_na.csv", 
          row.names = FALSE)
