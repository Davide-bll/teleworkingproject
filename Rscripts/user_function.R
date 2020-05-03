# user function used in the converttocsv.R script  (OSemosys model)
# USER FUNCTIONS----
read_osemosys <- function(path, rownames = "code", pattern = "X", replacement = "", header = TRUE) {
  x <- read.table(path, header = header, stringsAsFactors = FALSE) %>%
    as_tibble()
  
  names(x) <- str_replace(names(x), pattern = pattern, replacement = replacement)
  x 
}


read_osemosys_2 <- function(path, header = TRUE, pattern = "X", replacement = "", sep = ",") {
  x <- read.csv(path, header = header, sep = sep, dec = ".", stringsAsFactors = FALSE)  %>% 
    as_tibble()
  
  names(x) <- str_replace(names(x), pattern = pattern, replacement = replacement)
  x
  
}

convert_tb <- function(x, into = c("country", "commodity", "technology", "energy_level", "age", "size"), 
                       sep = c(2,4,6,7,8), col = "code", from = NULL) {
  
  # separate col
  x <- separate(x, col = col, into = into, sep = sep)
  
  # re-arrange cols
  chr <- select_if(x, ~(!is.numeric(.)))
  num <- select_if(x, is.numeric)
  x <- cbind(chr, num) %>% as_tibble
  
  if(is.null(from)) {
    from <- dim(chr)[[2]] + 1}
  
  pivot_longer(x, cols = c((from): dim(x)[[2]]), names_to = "year", values_to = "value")
}

# detect the first TRUE-- very specific for this data
detect_first_true <- function(x) {
  x <- as.numeric(x)
  y <- c()
  
  for (i in 2:length(x)) {
    y[[i-1]] <- isTRUE((x[[i]] - x[[i-1]]) < 0)  
  }
  y <- c(1, y)
  cumsum(y)
}

# aggregation -----
my_group_by <- function(x, grp, f) {
  
  x %>% group_by_at(.vars = grp) %>% 
    summarise(value = f(value)) %>% 
    ungroup()
}

# str 2 3 -------
# make the function to convert the value
fromOSEtoGAM <- function(A, x) {
  A %*% x
}

# find technology
find_tech <- function(x, code = "IT", col = 1) {
  res <- c()
  res <- c(res, names(x)[[col]])
  res <- c(res, x[[col]][which(str_detect(x[[col]], code))])
  res
}

# remove_fake 
remove_fake <- function(x, code = "IT") {
  col <- names(x)[[1]]
  x <- filter(x, !str_detect(x[[col]], code)) 
  x
}

# add col
add_col <- function(x, old, new) {
  x[[old]]  <- new
  rename_at(x, .vars = vars(old), function(x) "technology")
} 

# structure 3 strategy
convert_struct3 <- function(x) {
  techs <- find_tech(x)
  x <- add_col(remove_fake(x), old = techs[[1]], new = techs)
  
  # deal with different modes: this works only if the first observation is mode 1, and mode 2 
  mode <- x %>% select(technology) %>% 
    mutate(mode = 1) %>% 
    group_by(technology) %>% 
    mutate(mode_of_operation = as.character(cumsum(mode))) %>% 
    select(-mode) %>%
    ungroup
  
  x %>% left_join(mode, by = "technology")
  
}

# arrange cols
arrange_cols <- function(x) {
  
  cbind(select_if(x, ~(!is.numeric(.))), select_if(x, is.numeric)) %>% 
    as_tibble()
}

find_mapping <- function(input, output) {
  nrow <- length(output)
  ncol <- length(input)
  A <- matrix(0, nrow = nrow, ncol = ncol)
  
  # define residual input
  res_input <- input
  
  for(i in 1:nrow) {
    res <- 0
    
    for(j in 1:ncol) {
      bound <- 1 - colSums(A[1:i,j,drop = FALSE])
      
      if(res + input[[j]] <= output[[i]]) {
        A[i,j] <- ifelse(input[[j]] == 0, 0, min(res_input[[j]]/input[[j]], bound))
      }
      if(res + input[[j]] > output[[i]] & res < output[[i]]) {
        #        A[i,j]*res_input[[j]] + res = output[[j]]  this must be satiafied
        A[i,j] <- ifelse(res_input[[j]] == 0, 0, min(bound, (output[[i]] - res)/input[[j]]))
      }
      if(res > output[[i]]) A[i,j] <- 0
      
      # update the result  
      res <- res + (A[i,j]*input[j])
      
    }
    # update residual input
    
    res_input  <- positive_part((1 - colSums(A[1:i,,drop = FALSE]))*input)
  }
  A  
}

