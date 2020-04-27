# parameters mapping of OSEMOSYS data txt file
# EU  ISO code----
# define mapping with countries
isocode <- list( 
  Austria = "AT", 
  Belgium = "BE", 
  Bulgaria = "BG", 
  Switzerland = "CH", 
  Cyprus = "CY", 
  "Czech Republic" = "CZ", 
  Germany = "DE", 
  Denmark = "DK", 
  Estonia = "EE", 
  Spain = "ES", 
  Finland = "FI", 
  France = "FR", 
  Greece = "GR", 
  Croatia = "HR", 
  Hungary = "HU", 
  Ireland = "IE", 
  Italy = "IT", 
  Lithuania = "LT", 
  Luxembourg = "LU", 
  Latvia = "LV", Malta = "MT", Netherlands = "NL", Norway = "NO", Poland = "PL", 
  Portugal = "PT", Romania = "RO", Sweden = "SE", Slovenia = "SI", 
  Slovakia = "SK", "United Kingdom" = "UK"
)
# numerical ID CODE
ID <-1:length(isocode)

# create mapping code
mapping_country <- data.frame(ID = ID, country = unlist(isocode), stringsAsFactors = FALSE) %>% as_tibble()

# parameters time independent----
# set names accordingly to the tables--> Be careful of the order
namesparams      <- c("annualemissionlimit", "avaibilityfactor", "CapitalCost", 
                      "FixedCost", "residualcapacity","SpecifiedAnnualDemand", "TotalAnnualMaxCapacity", 
                      "TotalAnnualMaxCapacityInvestment", "TotalAnnualMinCapacity", 
                      "TotalAnnualMinCapacityInvestment", "TotalTechnologyAnnualActivityLowerLimit", 
                      "TotalTechnologyAnnualActivityUpperLimit")

# this is the aggregation in the OSEmBE model
technology <- c("country", "commodity", "technology", "energy_level", "age", "size")
emission   <- c("country", "commodity")
fuel       <- c("country", "commodity")
# in "specifiedannualdemand" the country + commodity means FUELS!!!!!!!!!!!!!!!

# create list of rules: how to split the aggregated technoligy, emission, fuel?
into <- list(A  = c("country", "commodity"), 
             B  = c("country", "commodity", "technology", "energy_level", "age", "size"), 
             c  = c("country", "commodity", "technology", "energy_level", "age", "size"), 
             d  = c("country", "commodity", "technology", "energy_level", "age", "size"),
             d2 = c("country", "commodity", "technology", "energy_level", "age", "size"),
             e  = c("country", "commodity"), 
             f  = c("country", "commodity", "technology", "energy_level", "age", "size"), 
             g  = c("country", "commodity", "technology", "energy_level", "age", "size"), 
             h  = c("country", "commodity", "technology", "energy_level", "age", "size"),
             i  = c("country", "commodity", "technology", "energy_level", "age", "size"), 
             j  = c("country", "commodity", "technology", "energy_level", "age", "size"),
             k  = c("country", "commodity", "technology", "energy_level", "age", "size"))

sep  <- list(A  = c(2), 
             B  = c(2,4,6,7,8), 
             C  = c(2,4,6,7,8),
             d  = c(2,4,6,7,8),
             d2 =c(2,4,6,7,8),
             e  = c(2), 
             f  = c(2,4,6,7,8), 
             g  = c(2,4,6,7,8),
             h  = c(2,4,6,7,8),
             i  = c(2,4,6,7,8),
             j  = c(2,4,6,7,8),
             k  = c(2,4,6,7,8)
)

