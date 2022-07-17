library(targets)

sapply(
    paste0("R/", list.files("R/")),
    source
)

# Set target-specific options such as packages.
tar_option_set(
    packages = c(
        "sf", "leaflet", # geospatial
        "dplyr", "janitor", "lubridate", "stringr", # wrangling
        "ggplot2", "ggdist", "gt" # tables and plots
    )
)

list(
    # Source: Cook County Medical Examiner's Office Case Archive
    # https://hub-cookcountyil.opendata.arcgis.com/datasets/4f7cc9f13542463c89b2055afd4a6dc1_0/explore
    # Last pulled May 24th
    tar_target(
        ccme_archive_raw_file,
        "data/Medical_Examiner_Case_Archive.csv",
        format = "file",
    ),
    tar_target(
        ccme_archive_raw,
        read_ccme_archive_csv(ccme_archive_raw_file)
    ),
    tar_target(
        ccme_archive_suid_cases,
        wrangle_ccme_archive_suid_cases(ccme_archive_raw)
    ),
    # Source: Internally generated file
    # Received in email from HZ on 01/21/22
    tar_target(
        name = suid_from_internal_raw_file, 
        "data/finaldataforanalysis3_220121.xlsx",
        format = "file"
    ),
    tar_target(
        name = suid_from_internal_raw,
        command = readxl::read_xlsx(suid_from_internal_raw_file)
    ),
    # Source: Tidycensus to Census API
    tar_target(
        name = suid_from_tidycensus_raw,
        command = get_suid_from_tidycensus_raw()
    ),
    tar_target(
        name = suid,
        command = assemble_suid(suid_from_internal_raw, suid_from_tidycensus_raw)
    ),
    tar_target(
        name = table_by_suid_present,
        command = make_table_by_suid_present(suid)
    )
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
    # tar_target(
    #     name = nb_model_of_suid,
    #     command = fit_nb_model_of_suid(suid)
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
