## How to determine available variables
# tidycensus::load_variables(2019, "acs5", cache = TRUE) |> view()
# "B01003_001" : Total Population
# "B01001_003" : All Males Under 5 yrs
# "B01001_027" : All Females Under 5 yrs
# "B06001_002" : All Under 5 yrs
# "B25010_001" : Average Household Size Of Occupied Housing Units

get_suid_from_tidycensus_raw <- function() {
    
    df1 <-
        # Call the census API
        tidycensus::get_acs(
            geography = "tract",
            survey = "acs5", # Get five-year estimate rather than one-year estimate
            year = 2019, # Get estimate for time period 2015-2019
            state = "IL", # Illinois
            county = 031, # Cook County
            geometry = TRUE, # Import census tract polygons too
            variables = c(
                "B01003_001", # TOTAL POPULATION
                "B06001_002"  # Total Under 5 years
                #"B25010_001" # Average Household Size Of Occupied Housing Units
            )
        ) 
    
    return(df1)
}