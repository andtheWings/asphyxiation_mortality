get_under_five_by_county_raw <- function(year_num) {
    
    tidycensus::get_estimates(
        geography = "county",
        product = "characteristics",
        breakdown = "AGEGROUP",
        year = year_num, # Get population for year specified to function # Illinois
    ) |> 
    mutate(year = year_num)
    
}