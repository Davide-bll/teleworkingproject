remove(list = ls())

# gdx paraeters generation 
require(gdxtools)
require(purrr)
require(tidyr)
require(dplyr)
require(stringr)

# set path data
path <- "C:/Users/Utente/Desktop/gamsathome/data/params_gams/"

# load data
paramlist <- list.files(path = path, pattern = ".csv")

# readdata
list_param <- map(paramlist, ~read.csv(file = paste(path, ., sep = "/"),
                         header = TRUE, stringsAsFactors = FALSE) %>% 
                    as_tibble) %>% 
  setNames(nm = str_remove(paramlist, ".csv")) 

# fix names
rename_commodity <- function(x, old = "commodity", new = "fuel") {
  if(old %in% names(x)) {
    
    x <- x %>% rename(!!sym(new) := old)
  }
  x
} 

# this could have been avoided using row.names = FALSE in write.csv
list_param <- list_param %>% map(~.[which(!(str_detect(names(.), "X")))])

# remove 0 rows df
param <- map(list_param, nrow) %>%
  map_df(as_tibble,.id = "param") %>% 
  filter(value > 0) %>% 
  pull(param)
  
list_param <- list_param[param]

# check duplicates: if EVERY thing is right, this sum is zero
map(list_param, ~select(., -value) %>% 
      group_by_all(.) %>% count() %>% filter(n>1)) %>% 
  map_dbl(nrow) %>% sum()

# write gdx
# write.gdx("C:/Users/Utente/Desktop/gamsathome/gamsscript/params", 
#           params = list_param)