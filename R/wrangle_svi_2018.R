wrangle_svi_2018 <- function(svi_2018_raw_df) {
    
    svi_2018_raw_df |> 
        janitor::clean_names() |> 
        select(
            fips,
            matches("^rpl_theme")
        ) |> 
        mutate(
            fips = as.numeric(fips),
            across(
                matches("^rpl_"),
                ~ .x * 100
            )
        )
    
}