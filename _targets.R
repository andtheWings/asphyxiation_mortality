library(targets)

source("R/wrangling_sids.R")
source("R/make_sids_table_2.R")

# Set target-specific options such as packages.
tar_option_set(packages = c("dplyr", "janitor"))

# End this file with a list of target objects.
list(
  tar_target(
      name = sids_file, 
      "data/finaldataforanalysis3_220121.xlsx",
      format = "file"
  ),
  tar_target(
      name = sids_without_pop_est_raw,
      command = readxl::read_xlsx(sids_file)
  ),
  tar_target(
      name = sids_pop_est_and_polygons,
      command = get_sids_pop_est_and_polygons(sids_without_pop_est_raw)
  ),
  tar_target(
      name = sids,
      command = assemble_sids(sids_pop_est_and_polygons, sids_without_pop_est_raw)
  ),
  tar_target(
      name = sids_table_2,
      command = make_sids_table_2(sids)
  )
)
