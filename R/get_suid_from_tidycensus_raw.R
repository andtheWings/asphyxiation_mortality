## How to determine available variables
# tidycensus::load_variables(2019, "acs5", cache = TRUE) |> view()
# "B01003_001" : Total Population
# "B01001_003" : All Males Under 5 yrs
# "B01001_027" : All Females Under 5 yrs
# "B06001_002" : All Under 5 yrs
# "B25010_001" : AVERAGE HOUSEHOLD SIZE OF OCCUPIED HOUSING UNITS

get_suid_from_tidycensus_raw <- function() {
    
    df1 <-
        # Call the census API
        tidycensus::get_acs(
            geography = "tract",
            variables = c(
                "B01003_001", # TOTAL POPULATION
                "B06001_002",  # Total Under 5 years
                "B25010_001" # AVERAGE HOUSEHOLD SIZE OF OCCUPIED HOUSING UNITS
            ),
            state = "IL", # Illinois
            county = 031, # Cook County
            geometry = FALSE # Import census tract polygons too
        ) |> 
        # st_transform(crs = 4326) |> 
        # Drop margin of estimate and name variables
        select(-moe, -NAME) |>
        # Convert GEOID to numeric type
        mutate(
            GEOID = as.numeric(GEOID)
        ) |>
        # Reshape variable estimates into separate columns
        tidyr::pivot_wider(
            names_from = variable,
            values_from = estimate
        ) |>
        # Clean names for consistency
        rename(
            fips = GEOID,
            pop_total = B01003_001,
            pop_under_five = B06001_002,
            avg_peop_per_household = B25010_001
        ) 
        # Put geometry column at the end of the table
        # relocate(
        #     geometry,
        #     .after = avg_peop_per_household
        # ) |> 
        # st_as_sf()
    
    return(df1)
}