wrangle_places <- function(places_raw_df) {
    
    places_raw_df |> 
        filter(measureid %in% c("CSMOKING", "BINGE")) |> 
        select(fips = locationname, measureid, data_value) |> 
        pivot_wider(names_from = measureid, values_from = data_value) |> 
        rename(
            ep_binge = BINGE, 
            ep_smoking = CSMOKING
        )
    
}