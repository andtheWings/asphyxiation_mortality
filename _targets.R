library(targets)

sapply(
    paste0("R/", list.files("R/")),
    source
)

# Set target-specific options such as packages.
tar_option_set(
    packages = c(
        "sf", # geospatial
        "dplyr", "janitor", # wrangling
        "ggplot2", "ggdist" # plotting
    )
)

# End this file with a list of target objects.
list(
  tar_target(
      name = suid_from_internal_raw_file, 
      "data/finaldataforanalysis3_220121.xlsx",
      format = "file"
  ),
  tar_target(
      name = suid_from_internal_raw,
      command = readxl::read_xlsx(suid_from_internal_raw_file)
  ),
  tar_target(
      name = suid_from_tidycensus,
      command = get_suid_from_tidycensus()
  ),
  tar_target(
      name = suid,
      command = assemble_suid(suid_from_internal_raw, suid_from_tidycensus)
  )#,
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
  #     name = table_of_vars_by_suid_present,
  #     command = make_table_of_vars_by_suid_present(suid),
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
