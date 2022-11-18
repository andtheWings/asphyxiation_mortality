## How to determine available variables
# tidycensus::load_variables(2019, "acs5", cache = TRUE) |> view()
# "B01003_001" : Total Population
# "B01001_003" : All Males Under 5 yrs
# "B01001_027" : All Females Under 5 yrs
# "B06001_002" : All Under 5 yrs
# "B25010_001" : Average Household Size Of Occupied Housing Units
# "B01001H_001": Total for sex by age (white alone, not hispanic or latino)
# "B27003_004", "B27003_007", "B27003_010", "B27003_013", "B27003_016", "B27003_019", "B27003_022", "B27003_025", "B27003_028", "B27003_032", "B27003_035", "B27003_038", "B27003_041", "B27003_044", "B27003_047", "B27003_050", "B27003_053",  "B27003_056"


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
                "B06001_002",  # Total Under 5 years
                "B01001H_001", # Non-Hispanic White
                "B27003_004", "B27003_007", "B27003_010", "B27003_013", "B27003_016", "B27003_019", "B27003_022", "B27003_025", "B27003_028", "B27003_032", "B27003_035", "B27003_038", "B27003_041", "B27003_044", "B27003_047", "B27003_050", "B27003_053",  "B27003_056" # Public Health Insurance
                
                #"B25010_001" # Average Household Size Of Occupied Housing Units
            )
        ) 
    
    return(df1)
}