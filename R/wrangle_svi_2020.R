wrangle_svi_2020 <- function(svi_2020_raw_df) {
    
    svi_2020_raw_df |> 
        #filter(STCNTY == 17031) |> 
        janitor::clean_names() |> 
        select(
            fips,
            ep_unemp, ep_sngpnt, ep_minrty, ep_noveh
        ) |> 
        mutate(
            fips = as.numeric(fips)
        )
    
}