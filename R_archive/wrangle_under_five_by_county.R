wrangle_under_five_by_county <- function(under_five_by_county_raw_df) {
    
    under_five_by_county_raw_df |> 
        filter(AGEGROUP == 0) |> 
        select(GEOID, pop_under_five_est = value)
}