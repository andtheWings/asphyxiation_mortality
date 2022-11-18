assemble_suid <- function(suid_from_internal_df, acs_5_demographics_df, acs_5_insurance_df, cook_county_tracts_sf) {
    
    suid_from_internal_df |> 
        select(fips, suid_count, suid_present, suid_count_factor, count_opioid_death) |> 
        left_join(
            y = acs_5_demographics_df,
            by = "fips"
        ) |> 
        left_join(
            y = acs_5_insurance_df, 
            by = "fips"
        ) |> 
        left_join(
            y = select(cook_county_tracts_sf, GEOID),
            by = c("fips" = "GEOID")
        ) |> 
        st_as_sf() |> 
        st_transform(crs = 4326)
    
    
}