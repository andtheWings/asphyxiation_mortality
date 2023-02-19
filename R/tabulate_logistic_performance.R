tabulate_logistic_performance <- function(...) {
    
    compare_performance(..., metrics = c("AIC", "BIC", "RMSE")) |> 
    select(-Model) |> 
    mutate(
        Name = 
            case_when(
                row_number() == 1 ~ "Two-Predictor Model",
                row_number() == 2 ~ "Intercept-Only Model"
            )
    ) |> 
    mutate(
        AUC = c("76.6%", "52.7%"),
        .after = 4
    ) |> 
    print_html(caption = NULL)

}