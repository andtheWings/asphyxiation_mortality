compile_geocoded_tracts <- function(tract_rev_geocodes_2019_df, tract_rev_geocodes_2020_df) {
    
    bind_rows(tract_rev_geocodes_2019_df, tract_rev_geocodes_2020_df) |> 
        mutate(
            jurisdiction = 
            case_when(
                oc_city == "Chicago" ~ "Chicago",
                oc_municipality == "Evanston Township" ~ "Evanston",
                oc_town == "Oak Park" ~ "Oak Park",
                oc_town == "Skokie" ~ "Skokie",
                oc_municipality == "Stickney Township" ~ "Stickney",
                TRUE ~ "Suburban Cook County"
            )
        )
    
}