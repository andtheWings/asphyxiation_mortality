wrangle_model_roc <- function(suid_training_data_df, logistic_model_obj) {
    
    total <- nrow(suid_training_data_df)
    observed_present <- sum(suid_training_data_df$suid_present)
    observed_absent <- total - observed_present
    
    df1 <-
        suid_training_data_df |> 
        as_tibble() |> 
        mutate(
            suid_present = 
                factor(
                    if_else(
                        suid_present, 
                        "Observed", "Not Observed"
                    ),
                    levels = c("Observed", "Not Observed"),
                    ordered = TRUE
                ),
            .predicted = predict(logistic_model_obj, type = "response"),
        ) |> 
        select(fips, suid_present, .predicted)
    
    df2 <- tibble(threshold = seq(from = 0, to = 1, by = 0.01)) 
    
    tabylate_from_threshold <- function(observed_prediction_df, threshold) {
        
        observed_prediction_df |> 
            mutate(
                .predicted_present = 
                    factor(
                        if_else(
                            .predicted > threshold,
                            "Predicted", "Not Predicted"
                        ),
                        levels = c("Predicted", "Not Predicted"),
                        ordered = TRUE
                    )
            ) |> 
            tabyl(.predicted_present, suid_present)
    }
    
    
    df3 <-
        df2 |> 
        mutate(
            tabyl = 
                map(
                    .x = threshold,
                    .f = ~tabylate_from_threshold(df1, .x)
                ),
            sensitivity = 
                map_dbl(
                    .x = tabyl,
                    .f = ~ (.x[1,2] / observed_present)
                ),
            specificity = 
                map_dbl(
                    .x = tabyl,
                    .f = ~ .x[2,3] / observed_absent
                ),
            accuracy = 
                map_dbl(
                    .x = tabyl,
                    .f = ~ (.x[1,2] + .x[2,3]) / total
                ),
            balance = (sensitivity + specificity)/2
        )
    
    
    return(df3)
    
}