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
    # Model Results
    
    tar_target(
        name = rootogram,
        command = plot_rootogram(negbinomial_full_model)
    ),
    tar_target(
        name = tbl_negbinomial_performance,
        command = 
            compare_performance(
                negbinomial_full_model, negbinomial_intercept_model, linear_full_model,
                metrics = "common"
            )
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
    
    
    
    
    
    
    
    # DEPRECATED
    # Source: Cook County Medical Examiner's Office Case Archive
    # https://hub-cookcountyil.opendata.arcgis.com/datasets/4f7cc9f13542463c89b2055afd4a6dc1_0/explore
    # Last pulled May 24th
    # tar_target(
    #     ccme_archive_file,
    #     "data/Medical_Examiner_Case_Archive.csv",
    #     format = "file",
    # ),
    # tar_target(
    #     ccme_archive_raw,
    #     read_ccme_archive_raw(ccme_archive_file)
    # ),
    # tar_target(
    #     ccme_archive_suid_cases,
    #     wrangle_ccme_archive_suid_cases(ccme_archive_raw)
    # ),
    # # Source: U.S. Census Bureau, S2704, ACS-5 2019 Public Insurance Coverage for Cook County Census Tracts
    # # Downloaded on 2022-11-18
    # tar_target(
    #     name = acs_5_insurance_file,
    #     "data/ACSST5Y2019.S2704-Data.csv",
    #     format = "file"
    # ),
    # tar_target(
    #     name = acs_5_insurance_raw,
    #     slice(readr::read_csv(acs_5_insurance_file), -1)
    # ),
    # tar_target(
    #     name = acs_5_insurance,
    #     command = wrangle_acs_5_insurance(acs_5_insurance_raw)
    # ),
    
    # # Source: U.S. Census Bureau, B15002, ACS-5 2019 Educational Attainment for Cook County Census Tracts
    # tar_target(
    #     name = acs_B15002_raw,
    #     command = 
    #         tidycensus::get_acs(
    #             geography = "tract",
    #             year = 2019,
    #             state = "IL",
    #             county = 031,
    #             survey = "acs5",
    #             variables = c("B15002_019", "B15002_028")
    #         )
    # ),
    # tar_target(
    #     name = acs_B15002,
    #     command = wrangle_acs_B15002(acs_B15002_raw)
    # ),
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
)