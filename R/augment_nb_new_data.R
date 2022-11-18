augment_nb_new_data <- function(new_data_df, model_obj, response_int = "suid_count") {
    
    null_model1 <- 
        MASS::glm.nb(
            as.formula(
                paste0(response_int," ~ 1")
            ), 
            data = new_data_df
        )
    
    # df1 <-
    #     new_data_df |>
    #     as_tibble() |>
    #     mutate(
    #         .predicted_model = predict(model_obj, newdata = new_data_df, type = "response"),
    #         .deviance_resid_model =
    #             if_else(
    #                 condition = .data[[response_int]] == 0,
    #                 true = -(.data[[response_int]] - .predicted_model),
    #                 false = .data[[response_int]]*log(.data[[response_int]]/.predicted_model) - (.data[[response_int]] - .predicted_model)
    #             ),
    #         .predicted_null = predict(null_model1, newdata = new_data_df, type = "response"),
    #         .deviance_resid_null =
    #             if_else(
    #                 condition = .data[[response_int]] == 0,
    #                 true = -(.data[[response_int]] - .predicted_null),
    #                 false = .data[[response_int]]*log(.data[[response_int]]/.predicted_null) - (.data[[response_int]] - .predicted_null)
    #             )
    #         )
    
    df1 <-
        new_data_df |>
        as_tibble() |>
        mutate(
            .predicted_model = predict(model_obj, newdata = new_data_df, type = "response"),
            .predicted_null = predict(null_model1, newdata = new_data_df, type = "response")
        )
    
    calc_deviance_resid <- function(predicted_var) {
        ifelse(
            test = df1[[response_int]] == 0,
            yes = -(df1[[response_int]] - df1[[predicted_var]]),
            no = df1[[response_int]] * log(df1[[response_int]]/df1[[predicted_var]]) - (df1[[response_int]] - df1[[predicted_var]])
        )
    }
    
    df2 <- 
        df1 |> 
        mutate(
            .deviance_resid_model = calc_deviance_resid(".predicted_model"),
            .deviance_resid_null = calc_deviance_resid(".predicted_null")
        )
    
    return(df2)  
    
}
