wrangle_births_by_county <- function(births_by_county_raw_list) {
    
    births_by_county_raw_list |> 
        reduce(bind_rows) |> 
        group_by(GEOID) |> 
        summarise(births_est = sum(value))
        
}