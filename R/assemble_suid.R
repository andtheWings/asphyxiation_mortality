assemble_suid <- function(cook_county_tracts_sf, suid_from_internal_df, ...) {
    
    sf1 <- 
        cook_county_tracts_sf |> 
        select(fips = GEOID)
    
    df1 <- 
        suid_from_internal_df |> 
        select(
            fips, 
            suid_count, suid_count_factor, suid_present
        )
    
    df2 <-
        list(sf1, df1, ...) |> 
        reduce(full_join, by = "fips")
    
     
    
        # left_join(
        #     y = as_tibble(select(cook_county_tracts_sf, GEOID, geometry)),
        #     by = c("fips" = "GEOID")
        # ) |> 
        # mutate(
        #     under_5_count_adjusted =
        #         case_when(
        #             under_5_count < suid_count ~ suid_count * 5,
        #             under_5_count == 0 ~ 1,
        #             TRUE ~ under_5_count
        #         ),
        #     .after = under_5_count.me
        # ) |> 
        # mutate(
        #     suid_rough_incidence = round(suid_count / (under_5_count_adjusted / 5) * 1E5),
        #     .after = suid_count_factor
        # ) |> 
        # st_as_sf() |> 
        # st_transform(crs = 4326)
    
    return(df2)
    
}