library(targets)

sapply(
    paste0("R/", list.files("R/")),
    source
)

# Set target-specific options such as packages.
tar_option_set(
    packages = c(
        "sf", "leaflet", # geospatial
        "dplyr", "janitor", "lubridate", "magrittr", "purrr", "stringr", "tidyr", # wrangling
        "ggplot2", "ggdist", "gt", # tables and plots
        "performance" # modeling
    )
)

list(
    
    ## Data Wrangling

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
    
    # Source: U.S. Census Bureau, DP05, ACS-5 2019 Demographics for Cook County Census Tracts
    # Downloaded on 2022-11-18
    tar_target(
        name = acs_5_demographics_file,
        "data/ACSDP5Y2019.DP05-Data.csv",
        format = "file"
    ),
    tar_target(
        name = acs_5_demographics_raw,
        command = slice(readr::read_csv(acs_5_demographics_file), -1)
    ),
    tar_target(
        name = acs_5_demographics,
        command = wrangle_acs_5_demographics(acs_5_demographics_raw)
    ),
    
    # Source: U.S. Census Bureau, S2704, ACS-5 2019 Public Insurance Coverage for Cook County Census Tracts
    # Downloaded on 2022-11-18
    tar_target(
        name = acs_5_insurance_file,
        "data/ACSST5Y2019.S2704-Data.csv",
        format = "file"
    ),
    tar_target(
        name = acs_5_insurance_raw,
        slice(readr::read_csv(acs_5_insurance_file), -1)
    ),
    tar_target(
        name = acs_5_insurance,
        command = wrangle_acs_5_insurance(acs_5_insurance_raw)
    ),
    
    # Source Tigris Tract Geometries
    tar_target(
        name = cook_county_tracts,
        command = tigris::tracts(state = "IL", county = 031, year = 2019) |> mutate(GEOID = as.numeric(GEOID))
    ),
    
    #Combining
    tar_target(
        name = suid,
        command = assemble_suid(suid_from_internal, acs_5_demographics, acs_5_insurance, cook_county_tracts)
    )
    # tar_target(
    #     name = spatial_resampling_suid_raw,
    #     command = #rsample::vfold_cv(suid, v = 5, repeats = 3)
    #         map(
    #             .x = 1:100,
    #             .f =
    #                 ~spatialsample::spatial_block_cv(suid, v = 5, method = "random") |>
    #                 rename(fold_id = id) |>
    #                 mutate(repeat_id = paste0("Repeat", as.character(.x)))
    #         ) |>
    #         reduce(bind_rows)
    # ),
    
    
    
    # 
    # ## Results
    # tar_target(
    #     name = table_by_suid_present,
    #     command = make_table_by_suid_present(suid)
    # ),
    # tar_target(
    #     name = nb_model_suid_count_per_tract,
    #     command =
    #         MASS::glm.nb(
    #             suid_count ~ public_insurance + count_opioid_death + white + count_opioid_death:white,
    #             data = suid
    #         )
    # )
    
    
    
    
    
    
    # DEPRECATED
    # # Source: Tidycensus to Census API
    # # Pops for Census Tracts
    # tar_target(
    #     name = suid_from_tidycensus_raw,
    #     command = get_suid_from_tidycensus_raw()
    # )
    # tar_target(
    #     name = suid_from_tidycensus,
    #     command = wrangle_suid_from_tidycensus(suid_from_tidycensus_raw)
    # )
    # # Children Under 5 Population by County
    # tar_target(
    #     name = under_five_by_county_raw,
    #     command = get_under_five_by_county_raw(2019)
    # ),
    # tar_target(
    #     name = under_five_by_county,
    #     command = wrangle_under_five_by_county(under_five_by_county_raw)
    # ),
    # # Source: Cook County Medical Examiner's Office Case Archive
    # # https://hub-cookcountyil.opendata.arcgis.com/datasets/4f7cc9f13542463c89b2055afd4a6dc1_0/explore
    # # Last pulled May 24th
    # tar_target(
    #     ccme_archive_raw_file,
    #     "data/Medical_Examiner_Case_Archive.csv",
    #     format = "file",
    # ),
    # tar_target(
    #     ccme_archive_raw,
    #     read_ccme_archive_csv(ccme_archive_raw_file)
    # ),
    # tar_target(
    #     ccme_archive_suid_cases,
    #     wrangle_ccme_archive_suid_cases(ccme_archive_raw)
    # ),
    # Name: Live Births from Illinois Resident Mothers
    # Source: IDPH
    # URL: https://www.data.illinois.gov/dataset/live-births-from-illinois-resident-mothers
    # Date Accessed: 2022-09-14
    # tar_target(
    #     name = live_births_il_mothers_raw_file,
    #     "data/pidphdata-briefbirthdatatableslivebirth_year_county_eth_race.xlsx",
    #     format = "file"
    # ),
    # tar_target(
    #     name = live_births_il_mothers_raw,
    #     command = readxl::read_xlsx(live_births_il_mothers_raw_file)
    # ),
    # tar_target(
    #     name = live_births_il_mothers,
    #     command = wrangle_live_births_il_mothers(live_births_il_mothers_raw)
    # ),
    # # Live births by county
    # tar_target(
    #     name = births_by_county_raw,
    #     command = 
    #         purrr::map(
    #             .x = 2015:2019,
    #             .f = ~get_births_by_county_raw(.x)
    #         )
    # ),
    # tar_target(
    #     name = births_by_county,
    #     command = wrangle_births_by_county(births_by_county_raw)
    # ),
    # tar_target(
    #     name = births_and_under_five_by_county,
    #     command = inner_join(under_five_by_county, births_by_county, by = "GEOID")
    # ),
    # tar_target(
    #     name = model_births_from_under_five_by_county,
    #     command = 
    #         MASS::glm.nb(
    #             births_est ~ log(pop_under_five_est), 
    #             data = births_and_under_five_by_county
    #         )
    # ),
    # tar_target(
    #     name = dists_for_global_prior_comparison,
    #     command = generate_dists_for_global_prior_comparison(suid)
    # ),
    # tar_target(
    #     name = figure_global_prior_comparison,
    #     command = visualize_global_prior_comparison(dists_for_global_prior_comparison)
    # ),
    # tar_target(
    #     name = table_global_prior_comparison,
    #     command = tabulate_global_prior_comparison(dists_for_global_prior_comparison)
    # )
    
    # tar_target(
    #     name = global_moran,
    #     command = 
    #         sfdep::global_moran_perm(
    #             x = suid$suid_count,
    #             nb = suid$neighbors,
    #             wt = suid$weights
    #         )
    # ),
    # # Markdown Files
    # tar_target(
    #     name = supplement_2_input,
    #     command = "53-model_selection.Rmd",
    #     format = "file"
    # ),
    # tar_target(
    #     name = supplement_2_output,
    #     command = rmarkdown::render(supplement_2_input, output_format = "md_document", output_dir = "markdown_output"),
    #     format = "file"
    # )
    # tar_target(
    #     name = ethn_race_of_suid,
    #     command = plot_ethn_race_of_suid(),
    #     format = "file"
    # ),
    # tar_target(
    #     name = metro_of_suid,
    #     command = plot_metro_of_suid(),
    #     format = "file"
    # ),
    
    # tar_target(
    #     name = raincloud_of_black_by_suid_present,
    #     command = plot_raincloud_by_suid_present(suid, "black", "Black Composition of"),
    #     format = "file"
    # ),
    # tar_target(
    #     name = raincloud_of_white_by_suid_present,
    #     command = plot_raincloud_by_suid_present(suid, "white", "% White Residents"),
    #     format = "file"
    # ),
    # tar_target(
    #     name = raincloud_of_svi_socioeconomic_by_suid_present,
    #     command = plot_raincloud_by_suid_present(suid, "svi_socioeconomic", "Socioeconomic Percentile of"),
    #     format = "file"
    # ),

    # ),
    # tar_target(
    #     name = lm_model_of_suid,
    #     command = fit_lm_model_of_suid(suid)
    # ),
    # tar_target(
    #     name = rootogram_table,
    #     command = summarize_rootogram_table(suid, lm_model_of_suid, nb_model_of_suid)
    # )
)
