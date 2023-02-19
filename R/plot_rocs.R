plot_rocs <- function(logistic_full_model_obj, logistic_intercept_model_obj) {
    
    plot(
        performance::performance_roc(logistic_full_model_obj, logistic_intercept_model_obj) 
    ) + 
        theme_bw() +
        geom_point(
            aes(x, y),
            color = "#47912d",
            shape = 19, 
            size = 3,
            data = tibble(x = 0.29, y = 0.71)
        ) +
        # geom_text(
        #     aes(x, y), 
        #     color = "#47912d", 
        #     label = "(0.26, 0.71)", 
        #     size = 4, 
        #     data = tibble(x = 0.15, y = 0.71)
        # ) +
        scale_color_manual(
            values = c("#47912d", "#d3b411"),
            labels = c("Two-Predictor Model", "Intercept-Only Model")
        )
    
}