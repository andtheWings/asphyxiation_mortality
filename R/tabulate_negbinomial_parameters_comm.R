tabulate_negbinomial_parameters_comm <- function(negbinomial_full_model_comm_obj) {
    
    df1 <-
        negbinomial_full_model_comm_obj |> 
        parameters::parameters(
            exponentiate = TRUE,
            digits = 5,
            ci_digits = 2
        ) |>
        dplyr::rename(
            IRR = Coefficient
        )
    
    df1[1,1] <- "Intercept"
    df1[2,1] <- "log(Total Population)"
    df1[3,1] <- "log(Total Crowded Households)"
    df1[4,1] <- "log(Total People Living Below Poverty)"
    
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