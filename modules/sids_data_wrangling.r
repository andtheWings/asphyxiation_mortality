## (How the population count variable was identified)
# tidycensus::load_variables(2019, "acs5", cache = TRUE) %>% view()
# "B01003_001" : Total Population
# "B01001_003" : All Males Under 5 yrs
# "B01001_027" : All Females Under 5 yrs
# "B06001_002" : All Under 5 yrs

#' Take a tibble with a FIPS variable listing census tracts and return a df of population counts for people under age 5 and the simples features for each census tract.
#' @export
get_coords_and_pop_est <- function(df) {
    # Load needed modules
    box::use(
        dplyr[filter, mutate, select],
        janitor[clean_names],
        magrittr[`%>%`],
        tidycensus[get_acs]
    )
    
    # Call the census API
    acs_payload <- 
        get_acs(
            geography = "tract",
            variables = "B06001_002",
            state = "IL",
            geometry = TRUE,
            cache_table = TRUE
        ) %>%
        # Filter for the just the census tracts in the function's input
        filter(.data[["GEOID"]] %in% df[["FIPS"]]) 
    
    # Wrangle for return
    final <-
        acs_payload %>%
        mutate(
            # Change name of census tract variable and convert to numeric
            FIPS = as.numeric(.data[["GEOID"]]),
            # Change name of population count
            pop_under_five = estimate
        ) %>%
        # Limit scope of returned variables
        select(
            FIPS,
            pop_under_five
        ) %>%
        # Clean up variable names
        clean_names()
    
    print("Import of census data is complete.")
    return(final)
}