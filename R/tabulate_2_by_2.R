tabulate_2_by_2 <- function(suid_prediction_data_sf) {
    
    suid_prediction_data_sf |> 
        as_tibble() |> 
        filter(!is.na(suid_present_label)) |> 
        tabyl(.predicted_present_label, suid_present_label) |> 
        adorn_totals() |> 
        adorn_percentages(denominator = "col") |>
        adorn_pct_formatting(digits = 0) |> 
        adorn_ns() |>
        rename(` ` = .predicted_present_label) |> 
        gt::gt()
    
}