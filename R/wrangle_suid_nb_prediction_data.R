wrangle_suid_nb_prediction_data <- function(prelim_suid_prediction_data_sf, negbinomial_full_model_obj) {
    
    df1 <- 
        prelim_suid_prediction_data_sf |> 
        mutate(
            .predicted = as.numeric(insight::get_predicted(negbinomial_full_model_obj, newdata = prelim_suid_prediction_data_sf)),
            .predicted_percentile = percent_rank(.predicted) * 100
        ) |> 
        filter(!is.na(.predicted) | !is.na(suid_count)) |> 
        mutate(
            .predicted_factor =
                case_when(
                    .predicted >=0 & .predicted < 0.5 ~ "No Cases",
                    .predicted >= 0.5 & .predicted < 1.5 ~ "One Case",
                    .predicted >= 1.5 & .predicted < 2.5 ~ "Two Cases",
                    .predicted >= 2.5 & .predicted < 3.5 ~ "Three Cases",
                    .predicted >= 3.5 & .predicted < 4.5 ~ "Four Cases",
                    .predicted >= 4.5 & .predicted < 5.5 ~ "Five Cases",
                    .predicted >= 5.5 ~ "Six+ Cases"
                ),
            .predicted_observed_label =
                case_when(
                    is.na(suid_count) & .predicted_factor == "No Cases" ~ "NA Observed; 0 Predicted", 
                    is.na(suid_count) & .predicted_factor == "One Case" ~ "NA Observed; 1 Predicted",
                    suid_count == 0 & is.na(.predicted)                 ~ "0 Observed, NA Predicted",
                    suid_count == 0 & .predicted_factor == "No Cases"   ~ "0 Observed, 0 Predicted",
                    suid_count == 0 & .predicted_factor == "One Case"   ~ "0 Observed, 1 Predicted",
                    suid_count == 1 & is.na(.predicted)                 ~ "1 Observed, NA Predicted",
                    suid_count == 1 & .predicted_factor == "No Cases"   ~ "1 Observed, 0 Predicted",
                    suid_count == 1 & .predicted_factor == "One Case"   ~ "1 Observed, 1 Predicted",
                    suid_count == 2 & is.na(.predicted)                 ~ "2 Observed, NA Predicted",
                    suid_count == 2 & .predicted_factor == "No Cases"   ~ "2 Observed, 0 Predicted",
                    suid_count == 2 & .predicted_factor == "One Case"   ~ "2 Observed, 1 Predicted",
                    suid_count == 3 & is.na(.predicted)                 ~ "3 Observed, NA Predicted",
                    suid_count == 3 & .predicted_factor == "No Cases"   ~ "3 Observed, 0 Predicted",
                    suid_count == 3 & .predicted_factor == "One Case"   ~ "3 Observed, 1 Predicted",
                    suid_count == 4 & is.na(.predicted)                 ~ "4 Observed, NA Predicted",
                    suid_count == 4 & .predicted_factor == "No Cases"   ~ "4 Observed, 0 Predicted",
                    suid_count == 4 & .predicted_factor == "One Case"   ~ "4 Observed, 1 Predicted",
                    suid_count == 5 & is.na(.predicted)                 ~ "5 Observed, NA Predicted",
                    suid_count == 5 & .predicted_factor == "No Cases"   ~ "5 Observed, 0 Predicted",
                    suid_count == 5 & .predicted_factor == "One Case"   ~ "5 Observed, 1 Predicted",
                    suid_count == 6 & is.na(.predicted)                 ~ "6 Observed, NA Predicted",
                    suid_count == 6 & .predicted_factor == "No Cases"   ~ "6 Observed, 0 Predicted",
                    suid_count == 6 & .predicted_factor == "One Case"   ~ "6 Observed, 1 Predicted",
                ),
            .predicted_observed_color =
                case_when(
                    .predicted_observed_label %in% c("0 Observed, 0 Predicted") ~ "Combined Zero",
                    .predicted_observed_label %in% c("NA Observed; 0 Predicted", "0 Observed, NA Predicted") ~ "Solo Zero",
                    .predicted_observed_label %in% c("0 Observed, 1 Predicted", "1 Observed, 0 Predicted") ~ "Mixed One",
                    .predicted_observed_label %in% c("2 Observed, 0 Predicted") ~ "Mixed Two",
                    .predicted_observed_label %in% c("3 Observed, 0 Predicted") ~ "Mixed Three",
                    .predicted_observed_label %in% c("4 Observed, 0 Predicted") ~ "Mixed Four",
                    .predicted_observed_label %in% c("5 Observed, 0 Predicted") ~ "Mixed Five",
                    .predicted_observed_label %in% c("6 Observed, 0 Predicted") ~ "Mixed Six",
                    .predicted_observed_label %in% c("NA Observed; 1 Predicted", "1 Observed, NA Predicted") ~ "Solo One",
                    .predicted_observed_label %in% c("1 Observed, 1 Predicted") ~ "Combined Two",
                    .predicted_observed_label %in% c("2 Observed, NA Predicted") ~ "Solo Two",
                    .predicted_observed_label %in% c("2 Observed, 1 Predicted") ~ "Combined Three",
                    .predicted_observed_label %in% c("3 Observed, NA Predicted") ~ "Solo Three",
                    .predicted_observed_label %in% c("3 Observed, 1 Predicted") ~ "Combined Four",
                    .predicted_observed_label %in% c("4 Observed, NA Predicted") ~ "Solo Four",
                    .predicted_observed_label %in% c("4 Observed, 1 Predicted") ~ "Combined Five",
                    .predicted_observed_label %in% c("5 Observed, NA Predicted") ~ "Solo Five",
                    .predicted_observed_label %in% c("5 Observed, 1 Predicted") ~ "Combined Six",
                    .predicted_observed_label %in% c("6 Observed, NA Predicted") ~ "Solo Six",
                    .predicted_observed_label %in% c("6 Observed, 1 Predicted") ~ "Combined Seven"
                )
        ) 
    
    df2 <-
        df1 |>
        as_tibble() |>
        filter(!is.na(.predicted) & !is.na(suid_count)) |>
        mutate(
            .predicted_observed_no_na =
                case_when(
                    .predicted < 0.5 & suid_count == 0 ~ "Not Predicted; 0 Observed",
                    .predicted < 0.5 & suid_count == 1 ~ "Not Predicted; 1 Observed",
                    .predicted < 0.5 & suid_count > 1 ~ "Not Predicted; 2+ Observed",
                    .predicted > 0.5 & suid_count == 0 ~ "Predicted; 0 Observed",
                    .predicted > 0.5 & suid_count == 1 ~ "Predicted; 1 Observed",
                    .predicted > 0.5 & suid_count > 1 ~ "Predicted; 2+ Observed"
                ),
            .predicted_observed_sum = percent_rank(percent_rank(.predicted) + percent_rank(suid_count)) * 100,
            .predicted_observed_sum_cat = 
                case_when(
                    .predicted_observed_sum < 20 ~ "1st Quintile",
                    .predicted_observed_sum >= 20 & .predicted_observed_sum < 40 ~ "2nd Quintile",
                    .predicted_observed_sum >= 40 & .predicted_observed_sum < 60 ~ "3rd Quintile",
                    .predicted_observed_sum >= 60 & .predicted_observed_sum < 80 ~ "4th Quintile",
                    .predicted_observed_sum >= 80 ~ "5th Quintile"
                )
        ) |> 
        select(fips, .predicted_observed_sum, .predicted_observed_sum_cat, .predicted_observed_no_na)
    
    return(
        # df1
        full_join(df1, df2, by = "fips")
    )
    
}