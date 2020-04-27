remove(list = ls())

# data aggregation script: 
# the main of the script is to aggregate the OSEMBE parameters in two main categories:
# FUELS and TECHNOLOGY

# require packages----
require(dplyr)
require(stringr)
require(purrr)

# load data
l_params <- readRDS("C:/Users/Utente/Desktop/shiny_modules/exploratoryData/data/allparams_italy.R")

# define the list of action to do for every group
actions <- list(
  sum, 
  mean, 
  sum, 
  sum, 
  sum, # sum, not mean
  sum,
  sum, 
  sum, 
  sum, 
  sum, 
  sum, 
  sum
)

names(actions) <- names(l_params)

# define list of group
type2 <- c("country","commodity", "technology", "year")
type1 <- c("country", "commodity", "year")

groups <- list(
  type1, 
  type2,
  type2,
  type2,
  type2,
  type1, 
  type2,
  type2,
  type2,
  type2,
  type2,
  type2
  )

# apply group by
my_group_by <- function(x, grp, f) {

  x %>% group_by_at(.vars = grp) %>% 
    summarise(value = f(value)) %>% 
    ungroup()
  }

# create arguments
args <- list(x = l_params, grp = groups, f = actions)
l_param_gams <- purrr::pmap(args, my_group_by)

# write csv
path_out <- "C:/Users/Utente/Desktop/gamsathome/data/params_gams/"

# imap(l_param_gams, ~write.csv(.x, paste0(path_out, "/", .y, ".csv")))

# SAVE R file
# fix "commodity name
rename_commodity <- function(x, old = "commodity", new = "fuel") {
  if(old %in% names(x)) {
    
    x <- x %>% rename(!!sym(new) := old)
  }
  x
} 

l_param_gams <- map(l_param_gams, rename_commodity)

# check for duplicates
map(l_param_gams, ~group_by_all(.) %>% count(.) %>% 
      filter(n > 1))

# save file
saveRDS(l_param_gams, paste(path_out, "l_param_gams.R", sep = "/"))
