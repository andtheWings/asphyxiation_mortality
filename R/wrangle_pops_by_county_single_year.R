wrangle_pops_by_county_single_year <- function(pops_by_county_single_year_raw_df) {
    
    pops_by_county_single_year_raw_df |> 
        mutate(county = word(NAME, 1)) |>
        mutate(
            county = 
                case_when(
                    county == "De" ~ "Dewitt",
                    county == "DeKalb" ~ "Dekalb",
                    county == "DuPage" ~ "Dupage",
                    county == "Jo" ~ "Jo Daviess",
                    county == "McDonough" ~ "Mcdonough",
                    county == "McHenry" ~ "Mchenry",
                    county == "McLean" ~ "Mclean",
                    county == "Rock" ~ "Rock Island",
                    county == "St." ~ "St. Clair",
                    TRUE ~ county
                )
        ) |> 
        select(fips = GEOID, county, year, variable, estimate) |> 
        tidyr::pivot_wider(
            names_from = variable,
            values_from = estimate
        ) |> 
        rename(
            total_pop = B01003_001,
            pop_under_five = B06001_002
        )
    
}