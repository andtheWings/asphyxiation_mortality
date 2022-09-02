wrangle_suid_from_tidycensus <- function(suid_from_tidycensus_raw_sf) {    

    sf1 <-
        suid_from_tidycensus_raw_sf |> 
        # Drop name variable
        select(-NAME) |>
        # Convert GEOID to numeric type and align naming convention for table joins
        mutate(
            GEOID = as.numeric(GEOID)
        ) |>
        as_tibble() |> 
        # Reshape variable estimates into separate columns
        tidyr::pivot_wider(
            names_from = variable,
            values_from = c(estimate, moe)
        ) |> 
        relocate(geometry, .after = everything()) |> 
        # Clean names for consistency
        rename(
            fips = GEOID,
            pop_total_est = estimate_B01003_001,
            pop_total_moe = moe_B01003_001,
            pop_under_five_est = estimate_B06001_002,
            pop_under_five_moe = moe_B06001_002
            #avg_peop_per_household = B25010_001
        ) |> 
        st_as_sf() |> 
        # Change coordinate reference system for use with interactive mapping
        st_transform(crs = 4326)
    
    return(sf1)
}