compile_geocoded_tracts <- function(tract_rev_geocodes_2019_df, tract_rev_geocodes_2020_df) {
    
    bind_rows(tract_rev_geocodes_2019_df, tract_rev_geocodes_2020_df) |> 
        rename(
            fips = GEOID
        ) |> 
        mutate(
            jurisdiction = 
                case_when(
                    oc_city == "Chicago" ~ "Chicago",
                    oc_municipality == "Evanston Township" ~ "Evanston",
                    oc_town == "Oak Park" ~ "Oak Park",
                    oc_town == "Skokie" ~ "Skokie",
                    oc_municipality == "Stickney Township" ~ "Stickney",
                    TRUE ~ "Suburban Cook County"
                ),
            community =
                case_when(
                    fips == 17031170900 ~ "Dunning",
                    oc_city == "Chicago" & !is.na(oc_suburb) ~ oc_suburb,
                    oc_city == "Chicago" & is.na(oc_suburb) ~ oc_neighbourhood,
                    oc_city != "Chicago" & !is.na(oc_city) ~ oc_city,
                    is.na(oc_city) & !is.na(oc_town) ~ oc_town,
                    is.na(oc_city) & is.na(oc_town) & !is.na(oc_suburb) ~ oc_suburb,
                    is.na(oc_city) & is.na(oc_town) & is.na(oc_suburb) & !is.na(oc_village) ~ oc_village,
                    fips == 17031803612 ~ "Arlington Heights",
                    fips == 17031806001 ~ "Des Plaines",
                    fips == 17031804109 ~ "Rolling Meadows",
                    fips == 17031824006 ~ "Lemont",
                    fips == 17031829402 ~ "Park Forest",
                    fips == 17031829904 ~ "Tinley Park",
                    fips == 17031829901 ~ "Tinley Park",
                    fips == 17031804204 ~ "Barrington Hills",
                    fips == 17031804201 ~ "Barrington Hills",
                    fips == 17031806006 ~ "Niles",
                    fips == 17031824128 ~ "Orland Park",
                    fips %in% c(17031804312, 17031804105) ~ "Hoffman Estates",
                    fips == 17031804512 ~ "Streamwood",
                    fips %in% c(17031770201, 17031804606) ~ "Elk Grove Village",
                    fips == 17031804607 ~ "Roselle",
                    fips == 17031811301 ~ "Melrose Park",
                    fips %in% c(17031770202, 17031804803) ~ "Schaumburg",
                    fips == 17031825302 ~ "Oak Forest",
                    fips == 17031828505 ~ "Lansing",
                    fips == 17031826201 ~ "Calumet City",
                    fips == 17031801500 ~ "Northbrook",
                    fips == 17031824503 ~ "Bremen Township",
                    fips == 17031823801 ~ "Palos Park",
                    fips == 17031806001 ~ NA
                )
        ) |> 
        filter(
            fips != 17031990000
        ) |> 
        select(
            fips,
            community, jurisdiction, 
            oc_city, oc_municipality, oc_town, oc_municipality, oc_suburb, oc_village, oc_neighbourhood
        )
    
}