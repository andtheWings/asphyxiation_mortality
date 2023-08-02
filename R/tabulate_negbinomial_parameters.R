tabulate_negbinomial_parameters <- function(negbinomial_full_model_obj) {
    
    df1 <-
        negbinomial_full_model_obj |> 
        parameters::parameters(
            exponentiate = TRUE,
            digits = 4,
            ci_digits = 3
        ) |>
        dplyr::rename(
            IRR = Coefficient
        )
    
    df1[1,1] <- "Intercept"
    df1[2,1] <- "Unemployed (%)"
    df1[3,1] <- "Minority (%)"
    df1[4,1] <- "Disabled (count)"
    df1[5,1] <- "Single-Parent (%)"
    
    df2 <- 
        df1 |> 
        filter(Parameter == "Intercept")
    
    df3 <- 
        df1 |> 
        filter(Parameter != "Intercept") |> 
        arrange(Parameter)
    
    obj1 <-
        bind_rows(df2, df3) |> 
        parameters::print_html()
        
    return(obj1)
    
}