wrangle_acs_dp05 <- function(acs_dp05_raw_df) {
    
    acs_dp05_raw_df |> 
    select(
        # Total Population _0001
        # One Race _0034
        # Non-Hispanic White Alone _0077
        fips = GEO_ID,
        e_total_pop_dp05 = DP05_0001E,
        # mc_total_pop = DP05_0001M, 
        e_male = DP05_0002E,
        e_female = DP05_0003E,
        e_median_age_dp05 = DP05_0018E,
        e_non_hisp_white_alone = DP05_0077E,
        ep_non_hisp_white_alone = DP05_0077PE, 
        mp_non_hisp_white_alone = DP05_0077PM,
        e_non_hisp_black_alone = DP05_0078E,
        ep_non_hisp_black_alone = DP05_0078PE,
        mp_non_hisp_black_alone = DP05_0078PM,
        e_asian_any = DP05_0067E,
        ep_asian_any = DP05_0067PE,
        mp_asian_any = DP05_0067PM,
        e_hispanic_any = DP05_0071E,
        ep_hispanic_any = DP05_0071PE,
        mp_hispanic_any = DP05_0071PM,
        e_aian_any = DP05_0066E,
        ep_aian_any = DP05_0066PE,
        mp_aian_any = DP05_0066PM
    ) |> 
    mutate(
        fips = as.numeric(str_sub(fips, start = 10L)),
        across(
            .cols = 2:18,
            .fns = ~as.numeric(.x)
        )
    )
    
}