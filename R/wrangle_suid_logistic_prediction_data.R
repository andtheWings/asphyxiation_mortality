wrangle_suid_logistic_prediction_data <- function(prelim_suid_prediction_data_sf, logistic_full_model_obj, threshold) {
    
    prelim_suid_prediction_data_sf |> 
        mutate(
            .predicted = as.numeric(insight::get_predicted(logistic_full_model_obj, newdata = prelim_suid_prediction_data_sf))
        ) |> 
        filter(!is.na(.predicted)) |> 
        mutate(
            suid_present_label = 
                factor(
                    case_match(
                        suid_present,
                        TRUE ~ "Observed",
                        FALSE ~ "Not Observed",
                        NA ~ NA
                    ),
                    levels = c("Observed", "Not Observed", NA),
                    ordered = TRUE
                ),
            .predicted_present = if_else(.predicted > threshold, TRUE, FALSE),
            .predicted_present_label = 
                factor(
                    if_else(.predicted_present == TRUE, "Predicted", "Not Predicted"),
                    levels = c("Predicted", "Not Predicted"),
                    ordered = TRUE
                ),
            .predicted_category = case_when(
                suid_present == TRUE & .predicted_present == TRUE ~ "Persistently Present",
                suid_present == TRUE & .predicted_present == FALSE ~ "Newly Absent",
                suid_present == FALSE & .predicted_present == TRUE ~ "Newly Present",
                suid_present == FALSE & .predicted_present == FALSE ~ "Persistently Absent",
                is.na(suid_present) & .predicted_present == TRUE ~ "Present (no previous comparison)",
                is.na(suid_present) & .predicted_present == FALSE ~ "Absent (no previous comparison)",
            ),
            .predicted_category_revised = case_when(
                suid_count == 0 & .predicted_present == FALSE ~ "Not Predicted; 0 Cases",
                is.na(suid_count) & .predicted_present == FALSE ~ "Not Predicted; NA Cases",
                suid_count == 1 & .predicted_present == FALSE ~ "Not Predicted; 1 Case",
                suid_count > 1 & .predicted_present == FALSE ~ "Not Predicted; > 1 Case",
                suid_count == 0 & .predicted_present == TRUE ~ "Predicted; 0 Cases",
                is.na(suid_count) & .predicted_present == TRUE ~ "Predicted; NA Cases",
                suid_count == 1 & .predicted_present == TRUE ~ "Predicted; 1 Case",
                suid_count > 1 & .predicted_present == TRUE ~ "Predicted; > 1 Case",
            )
        )
    
}