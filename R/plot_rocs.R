plot_rocs <- function(logistic_intercept_model_obj, logistic_one_var_model_obj, logistic_full_model_obj, logistic_three_var_model_obj) {
    
    df1 <- 
        performance::performance_roc(
            logistic_intercept_model_obj, 
            logistic_one_var_model_obj, 
            logistic_full_model_obj, 
            logistic_three_var_model_obj
        ) |> 
        # as_tibble() |> 
        mutate(
            model_factor =
                factor(
                    Model,
                    levels = c("logistic_intercept_model_obj", "logistic_one_var_model_obj", "logistic_full_model_obj", "logistic_three_var_model_obj"),
                    labels = c("Intercept-Only", "One-Predictor", "Two-Predictor", "Three-Predictor")
                )
        )
    
    df1 |>
        ggplot(aes(x = Specificity, y = Sensitivity, color = model_factor)) +
        geom_line(alpha = 0.9) +
        geom_point(
            aes(x, y),
            color = "#CC3311",
            shape = 19,
            size = 3,
            data = tibble(x = 0.29, y = 0.71)
        ) +
        scale_color_manual(values = c("#EE7733", "#0077BB", "#CC3311", "#009988")) +
        labs(
            x = "1 - Specificity",
            color = "Model Composition"
        ) +
        theme_bw()
    
}
