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


# remove 0 rows df
param <- map(list_param, nrow) %>%
  map_df(as_tibble,.id = "param") %>% 
  filter(value > 0) %>% 
  pull(param)
  
list_param <- list_param[param]

# fix "00" in totalactivitylowerlimit
# check duplicates: if EVERY thing is right, this sum is zero
map(list_param, ~select(., -value) %>% 
      group_by_all(.) %>% count() %>% filter(n>1)) %>% 
  map_dbl(nrow) %>% sum()

# subset tibbls containing fuel, and change col
predicates <- map_lgl(list_param, function(x) "fuel" %in% names(x))
list_param[predicates] <- map(list_param[predicates], ~mutate(., fuel = change_code(fuel)))

# subset tibble containnig technology, and change "0" in "00"
predicates <- map_lgl(list_param, function(x) "technology" %in% names(x))

list_param[predicates] <- map(list_param[predicates], 
                              ~mutate(., technology = change_code(as.character(technology), old = "0", new = "00")))

# OPTION2----
# aggregate fuel and technology, and "duplicate the fuel col when is necessary"
duplicates_fuel <- c("InputActivityRatio", "OutputActivityRatio")

predicates <- list_param %>% 
  map_lgl(., ~(any(str_detect(names(.), "fuel")) & any(str_detect(names(.), "technology"))))

duplicate_fuel <- !names(list_param)[predicates] %in% duplicates_fuel

list_param[predicates] <- map2(.x = list_param[predicates], .y = duplicate_fuel,
               ~unite(.x, "technology", c("technology", "fuel"), 
                      sep = "", 
                      remove = .y))


# write gdx
# write.gdx("C:/Users/Utente/Desktop/gamsathome/gamsscript/params",
#          params = list_param)
