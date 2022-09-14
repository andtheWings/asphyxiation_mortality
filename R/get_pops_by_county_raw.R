get_pops_by_county_raw <- function(year_num) {
    
    tidycensus::get_acs(
        geography = "county",
        variables = c(
            "B01003_001", # TOTAL POPULATION
            "B06001_002"  # Total Under 5 years
        ),
        survey = "acs5", # Get five-year estimate rather than one-year estimate
        year = year_num, # Get population for year specified to function
        state = "IL", # Illinois
    ) |> 
    mutate(year = year_num)
    
}