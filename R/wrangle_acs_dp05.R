wrangle_acs_dp05 <- function(acs_dp05_raw_df) {
    
    acs_dp05_raw_df |> 
    select(
        # Total Population _0001
        # One Race _0034
        # Non-Hispanic White Alone _0077
        fips = GEO_ID,
        ec_total_pop = DP05_0001E,
        mc_total_pop = DP05_0001M, 
        ep_non_hisp_white_alone = DP05_0077PE, 
        mp_non_hisp_white_alone = DP05_0077PM,
        ep_non_hisp_black_alone = DP05_0078PE,
        mp_non_hisp_black_alone = DP05_0078PM,
        ep_asian_any = DP05_0067PE,
        mp_asian_any = DP05_0067PM,
        ep_hispanic_any = DP05_0071PE,
        mp_hispanic_any = DP05_0071PM,
        ep_aian_any = DP05_0066PE,
        mp_aian_any = DP05_0066PM
    ) |> 
    mutate(
        fips = as.numeric(str_sub(fips, start = 10L)),
        across(
            .cols = 2:13,
            .fns = ~as.numeric(.x)
        )
    )
    
}