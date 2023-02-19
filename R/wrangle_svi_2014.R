wrangle_svi_2014 <- function(svi_2014_raw_df) {
    
    svi_2014_raw_df |> 
        #filter(STCNTY == 17031) |> 
        janitor::clean_names() |> 
        select(
            fips,
            matches("^ep_|^mp_"),
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