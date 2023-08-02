tabulate_logistic_parameters <- function(logistic_full_model_obj) {
    
    df1 <-
        logistic_full_model_obj |> 
        parameters::parameters(exponentiate = TRUE) |>
        dplyr::rename(`Odds Ratio` = Coefficient)
    
    df1[1,1] <- "Intercept"
    df1[2,1] <- "Unemployed (%)"
    df1[3,1] <- "Minority (%)"
    
    return(parameters::print_html(df1))
    
}