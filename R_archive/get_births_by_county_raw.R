get_births_by_county_raw <- function(year_num) {
    
    tidycensus::get_estimates(
        geography = "county",
        variables = "BIRTHS",
        year = year_num
    )
    
}