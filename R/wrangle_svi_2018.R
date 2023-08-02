wrangle_svi_2018 <- function(svi_2018_raw_df) {
    
    svi_2018_raw_df |> 
        janitor::clean_names() |> 
        select(
            fips,
            e_totpop,
            matches("^rpl_theme"),
            ep_unemp, ep_sngpnt, ep_minrty, ep_noveh,
            e_pov, e_crowd
        ) |> 
        mutate(
            fips = as.numeric(fips),
            across(
                matches("^rpl_"),
                ~ .x * 100
            )
        )
    
}