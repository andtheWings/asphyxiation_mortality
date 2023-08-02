tabulate_logistic_performance <- function(...) {
    
    compare_performance(..., metrics = c("AIC", "BIC", "RMSE")) |> 
    select(-Model) |> 
    mutate(
        Name = 
            case_when(
                row_number() == 1 ~ "Intercept-Only Model",
                row_number() == 2 ~ "One-Predictor Model",
                row_number() == 3 ~ "Two-Predictor Model",
                row_number() == 4 ~ "Three-Predictor Model"
            )
    ) |> 
    mutate(
        AUC = c("52.7%", "74.8%", "76.6%", "76.8%"),
        .after = 4
    ) |> 
    print_html(caption = NULL)

}