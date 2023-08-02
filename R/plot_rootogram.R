plot_rootogram <- function(model_obj, new_data_sf = NULL, x_lab = "Count Value") {
    
    observed_df <-
        model_obj |> 
        insight::get_response() |> 
        janitor::tabyl()
    
    predicted_df <-
        model_obj |> 
        insight::get_predicted(newdata = new_data_sf) |>
        tibble::as_tibble() |> 
        dplyr::mutate(
            binned_pred = 
                dplyr::case_when(
                    Predicted < 0.5 ~ 0,
                    Predicted >= 0.5 & Predicted < 1.5 ~ 1,
                    Predicted >= 1.5 & Predicted < 2.5 ~ 2,
                    Predicted >= 2.5 & Predicted < 3.5 ~ 3,
                    Predicted >= 3.5 & Predicted < 4.5 ~ 4,
                    Predicted >= 4.5 & Predicted < 5.5 ~ 5,
                    Predicted >= 5.5 ~ 6
                )
        ) |> 
        janitor::tabyl(binned_pred) |> 
        filter(!is.na(binned_pred))
    
    diff <- nrow(observed_df) - nrow(predicted_df)
    
    if(diff != 0) {
        predicted_vct <- c(predicted_df$n, rep(0, diff))
    } else {
        predicted_vct <- predicted_df$n
    }
    
    rootogram_tbl <-
        tibble::tibble(
            count_value = observed_df[,1],
            observed_freq = observed_df[,2],
            predicted_freq = predicted_vct
        )
    
    plot1 <-
        rootogram_tbl |> 
        ggplot2::ggplot(
            ggplot2::aes(
                x = count_value,
                y = sqrt(predicted_freq)
            )
        ) +
        ggplot2::geom_hline(
            yintercept = 0,
            linewidth = 0.35
        ) +
        ggplot2::geom_rect(
            ggplot2::aes(
                xmin = count_value - 0.35,
                xmax = count_value + 0.35,
                ymin = sqrt(predicted_freq) - sqrt(observed_freq),
                ymax = sqrt(predicted_freq)
            ),
            fill = "gray60"
        ) +
        ggplot2::geom_line(
            #color = "red"
        ) +
        ggplot2::geom_point(
            #color = "red"
        ) +
        ggplot2::labs(
            title = NULL,
                # paste0(
                #     "Family: ",
                #     insight::model_info(model_obj)$family,
                #     ", Zero-Inflated: ",
                #     as.character(insight::model_info(model_obj)$is_zero_inflated)
                # ),
            x = x_lab,
            y = "sqrt(Frequency)"
        ) +
        ggplot2::theme_bw()
    
    return(
        plot1
        # list(observed_df, predicted_df, rootogram_tbl)
    )
    
}