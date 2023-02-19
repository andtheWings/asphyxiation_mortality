wrangle_acs_5_insurance <- function(acs_5_insurance_raw_df) {
    
    acs_5_insurance_raw_df |> 
    select(
        fips = GEO_ID, 
        public_insur_prop = S2704_C03_026E, 
        public_insur_prop.me = S2704_C03_026M
    ) |> 
    mutate(
        across(
            .cols = 2:3,
            .fns = ~as.numeric(.x) / 100
        ),
        fips = as.numeric(str_sub(fips, start = 10L))
    )
    
}