wrangle_acs_5_demographics <- function(acs_5_demographics_df) {
    
    acs_5_demographics_df |> 
    select(
        fips = GEO_ID,
        total_pop_count = DP05_0001E,
        total_pop_count.me = DP05_0001M, 
        under_5_count = DP05_0005E, 
        under_5_count.me = DP05_0005M, 
        non_hisp_white_prop = DP05_0077PE, 
        non_hisp_white_prop.me = DP05_0077PM) |> 
    mutate(
        across(
            .cols = 2:7,
            .fns = ~as.numeric(.x)
        ),
        across(
            .cols = 6:7,
            .fns = ~.x/100
        ),
        fips = as.numeric(str_sub(fips, start = 10L))
    )
    
}