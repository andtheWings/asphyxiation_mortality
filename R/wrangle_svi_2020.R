wrangle_svi_2020 <- function(svi_2020_raw_df) {
    
    svi_2020_raw_df |> 
        #filter(STCNTY == 17031) |> 
        janitor::clean_names() |> 
        select(
            fips,
            e_totpop, e_crowd, e_pov = e_pov150,
            ep_unemp, ep_sngpnt, ep_minrty, e_disabl
        ) |> 
        mutate(
            fips = as.numeric(fips)
        )
    
}