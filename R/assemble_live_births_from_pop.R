assemble_live_births_from_pop <- function(pops_by_county_df, live_births_il_mothers_df) {
    
    full_join(
        pops_by_county_df, live_births_il_mothers_df,
        by = c(
            "county" = "residence_county_of_mother",
            "year" = "year_of_delivery"
        )
    ) |> 
    rename(
        live_births = count
    ) |>
    filter(!is.na(pop_under_five)) |> 
    mutate(
        log_pop_under_five = log10(pop_under_five),
        log_live_births = log10(live_births)
    )
    
}