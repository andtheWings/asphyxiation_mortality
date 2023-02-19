library(targets)

sapply(
    paste0("R/", list.files("R/")),
    source
)

# Set target-specific options such as packages.
tar_option_set(
    packages = c(
        "sf", "leaflet", # geospatial
        "dplyr", "janitor", "lubridate", "magrittr", "readr", "purrr", "stringr", "tidyr", # wrangling
        "ggplot2", "ggdist", "gt", # tables and plots
        "performance" # modeling
    )
)

list(
    
    # Outcome Source

    # Source: Internally generated file
    # Received in email from HZ on 01/21/22
    tar_target(
        name = suid_from_internal_file, 
        "data/finaldataforanalysis3_220121.xlsx",
        format = "file"
    ),
    tar_target(
        name = suid_from_internal_raw,
        command = readxl::read_xlsx(suid_from_internal_file)
    ),
    tar_target(
        name = suid_from_internal,
        command = wrangle_suid_from_internal(suid_from_internal_raw)
    ),
    
    # Geospatial Sources
    
    # Tigris Census Tract Geometries
    tar_target(
        name = cook_county_tracts_2019,
        command = tigris::tracts(state = "IL", county = 031, year = 2019) |> mutate(GEOID = as.numeric(GEOID))
    ),
    tar_target(
        name = cook_county_tracts_2020,
        command = tigris::tracts(state = "IL", county = 031, year = 2020) |> mutate(GEOID = as.numeric(GEOID))
    ),
    
    # Reverse Geocoding Tracts
    tar_target(
        name = tract_rev_geocodes_2019,
        command = reverse_geocode_tigris(cook_county_tracts_2019)
    ),
    tar_target(
        name = tract_rev_geocodes_2020,
        command = reverse_geocode_tigris(
            anti_join(
                as_tibble(cook_county_tracts_2020), 
                as_tibble(cook_county_tracts_2019), 
                by = "GEOID"
            )
        )
    ),
    tar_target(
        name = tract_rev_geocodes_all,
        command = compile_geocoded_tracts(tract_rev_geocodes_2019, tract_rev_geocodes_2020)
    ),
    
    
    # Model Training Source
    
    # Source: CDC/ATSDR SVI Data, 2014, United States, Census Tracts
    # URL: https://www.atsdr.cdc.gov/placeandhealth/svi/data_documentation_download.html
    # Downloaded: 2022-12-07
    tar_target(
        name = svi_2014_file,
        "data/SVI2014_US.csv",
        format = "file"    
    ),
    tar_target(
        name = svi_2014_raw,
        command = read_csv(svi_2014_file) |> filter(STCNTY == 17031)
    ),
    tar_target(
        name = svi_2014,
        command = wrangle_svi_2014(svi_2014_raw)
    ),
    
    # Model Prediction Source
    
    # Source: CDC/ATSDR SVI Data, 2020, United States, Census Tracts
    # URL: https://www.atsdr.cdc.gov/placeandhealth/svi/data_documentation_download.html
    # Downloaded: 2022-12-10
    tar_target(
        name = svi_2020_file,
        "data/SVI2020_US.csv",
        format = "file"    
    ),
    tar_target(
        name = svi_2020_raw,
        command = read_csv(svi_2020_file) |> filter(STCNTY == 17031)
    ),
    tar_target(
        name = svi_2020,
        command = wrangle_svi_2020(svi_2020_raw)
    ),
    
    # Descriptive Sources
    
    # Source: CDC/ATSDR SVI Data, 2018, United States, Census Tracts
    # URL: https://www.atsdr.cdc.gov/placeandhealth/svi/data_documentation_download.html
    # Downloaded: 2022-12-07
    tar_target(
        name = svi_2018_file,
        "data/SVI2018_US.csv",
        format = "file"    
    ),
    tar_target(
        name = svi_2018_raw,
        command = read_csv(svi_2018_file) |> filter(STCNTY == 17031)
    ),
    tar_target(
        name = svi_2018,
        command = wrangle_svi_2018(svi_2018_raw)
    ),
    
    # Source: U.S. Census Bureau, S0101, ACS-5 2019 Age/Sex Demographics for Cook County Census Tracts
    # Downloaded on 2022-11-29
    tar_target(
        name = acs_s0101_file,
        "data/ACSST5Y2019.S0101-Data.csv",
        format = "file"
    ),
    tar_target(
        name = acs_s0101_raw,
        command = read_csv(acs_s0101_file) |>  slice(-1)
    ),
    tar_target(
        name = acs_s0101,
        command = wrangle_acs_s0101(acs_s0101_raw)
    ),
    
    # Source: U.S. Census Bureau, DP05, ACS-5 2019 Race/Ethnicity Demographics for Cook County Census Tracts
    # Downloaded on 2022-11-18
    tar_target(
        name = acs_dp05_file,
        "data/ACSDP5Y2019.DP05-Data.csv",
        format = "file"
    ),
    tar_target(
        name = acs_dp05_raw,
        command = read_csv(acs_dp05_file) |> slice(-1)
    ),
    tar_target(
        name = acs_dp05,
        command = wrangle_acs_dp05(acs_dp05_raw)
    ),
    
    # Source: PLACES: Local Data for Better Health, Census Tract Data 2021 release
    # URL: https://chronicdata.cdc.gov/500-Cities-Places/PLACES-Local-Data-for-Better-Health-Census-Tract-D/373s-ayzu
    tar_target(
        name = places_raw,
        command = RSocrata::read.socrata("https://chronicdata.cdc.gov/resource/373s-ayzu.csv?countyfips=17031&year=2019")
    ),
    tar_target(
        name = places,
        command = wrangle_places(places_raw)
    ),
    
    # Combined descriptive data sources
    tar_target(
        name = suid_descriptive_data,
        command = 
            assemble_suid(cook_county_tracts_2019, suid_from_internal, places, acs_dp05, acs_s0101, svi_2018) |> 
            filter(!is.na(suid_present))
    ),
    
    # Description Results
    tar_target(
        name = table_suid_counts,
        command = tabulate_suid_counts(suid_from_internal)
    ),
    tar_target(
        name = table_by_suid_present,
        command = tabulate_by_suid_present(suid_descriptive_data)
    ),
    tar_target(
        name = plot_of_white_by_suid_present,
        command = plot_by_suid_present(suid_descriptive_data, "ep_non_hisp_white_alone", "Non-Hispanic White Racial Composition (%)")
    ),
    tar_target(
        name = plot_of_black_by_suid_present,
        command = plot_by_suid_present(suid_descriptive_data, "ep_non_hisp_black_alone", "Non-Hispanic Black Racial Composition (%)")
    ),
    
    # Model Training
    tar_target(
        name = suid_training_data,
        command = assemble_suid(cook_county_tracts_2019, suid_from_internal, svi_2014) |> filter(!is.na(suid_count))
    ),
    tar_target(
        name = negbinomial_full_model,
        command = 
            MASS::glm.nb(
                suid_count ~ ep_unemp + ep_minrty, 
                data = suid_training_data
            )
    ),
    tar_target(
        name = negbinomial_intercept_model,
        command = 
            MASS::glm.nb(
                suid_count ~ 1, 
                data = suid_training_data
            )
    ),
    tar_target(
        name = linear_full_model,
        command = 
            lm(
                suid_count ~ ep_unemp + ep_minrty, 
                data = suid_training_data
            )
    ),
    tar_target(
        name = logistic_full_model,
        glm(
            suid_present ~ ep_unemp + ep_minrty,
            data = suid_training_data,
            family = binomial(link = "logit") 
        )
    ),
    tar_target(
        name = logistic_intercept_model,
        glm(
            suid_present ~ 1,
            data = suid_training_data,
            family = binomial(link = "logit") 
        )
    ),
    
    # Model Prediction
    tar_target(
        name = suid_prediction_data,
        command = 
            assemble_suid(cook_county_tracts_2020, suid_from_internal, svi_2020) |> 
            wrangle_suid_prediction_data(
                logistic_full_model, 
                threshold = 0.19
            )
    ),
    
    # Model Results
    tar_target(
        name = table_logistic_performance,
        command = tabulate_logistic_performance(logistic_full_model, logistic_intercept_model)
    ),
    tar_target(
        name = plot_of_rocs,
        command = plot_rocs(logistic_full_model, logistic_intercept_model)
    ),
    tar_target(
        name = table_2_by_2,
        command = tabulate_2_by_2(suid_prediction_data)
    )
    
)
