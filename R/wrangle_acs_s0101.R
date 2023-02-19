wrangle_acs_s0101 <- function(acs_s0101_raw_df) {
    
    acs_s0101_raw_df |> 
        select(
            fips = GEO_ID,
            ec_under_5 = S0101_C01_002E,
            mc_under_5 = S0101_C01_002M,
            ep_under_5 = S0101_C02_002E,
            mp_under_5 = S0101_C02_002M,
            e_median_age = S0101_C01_032E,
            m_median_age = S0101_C01_032M,
            e_sex_ratio = S0101_C01_033E,
            m_sex_ratio = S0101_C01_033M,
            e_dependency_ratio = S0101_C01_034E,
            m_dependency_ratio = S0101_C01_034M,
            e_female_15_to_44 = S0101_C06_024E,
            m_female_15_to_44 = S0101_C06_024M
        ) |> 
        mutate(
            fips = as.numeric(str_sub(fips, start = 10L)),
            across(
                .cols = 2:13,
                .fns = ~as.numeric(.x)
            )
        )
    
}