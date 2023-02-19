wrangle_acs_B15002 <- function(acs_B15002_raw_df) {
    
    acs_B15002_raw_df |> 
        pivot_wider(
            names_from = variable,
            values_from = c(estimate, moe)
        ) |> 
        mutate(
            fips = as.numeric(GEOID),
            female_high_school_perc = estimate_B15002_028 / estimate_B15002_019 * 100,
            female_high_school_perc.me = 
                tidycensus::moe_prop(
                    num = estimate_B15002_028, 
                    denom = estimate_B15002_019,
                    moe_num = moe_B15002_028,
                    moe_denom = moe_B15002_019
                ) * 100
        ) |> 
        select(fips, female_high_school_perc, female_high_school_perc.me)
    
}