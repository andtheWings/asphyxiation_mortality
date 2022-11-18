wrangle_live_births_il_mothers <- function(live_births_il_mothers_raw_df) {
    
    df1 <-
        live_births_il_mothers_raw_df |> 
        janitor::clean_names() |> 
        group_by(year_of_delivery, residence_county_of_mother) |> 
        summarise(count = sum(count), .groups = "keep") |> 
        ungroup() |> 
        arrange(residence_county_of_mother, year_of_delivery)
    
    return(df1)
    
}