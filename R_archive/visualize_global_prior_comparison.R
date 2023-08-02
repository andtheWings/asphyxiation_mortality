visualize_global_prior_comparison <- function(dists_for_global_prior_comparison_df) {
    
    ggplot1 <-
        dists_for_global_prior_comparison_df |> 
        ggplot(
            aes(
                x = risk_est, 
                y = `Risk Type`
            )
        ) +
        stat_slabinterval(slab_alpha = 0.9) +
        coord_cartesian(xlim = c(0, 500)) +
        scale_x_sqrt() +
        labs(
            x = "SUID Risk (cases per 100,000)",
            y = ""
        ) +
        theme_light()
    
    return(ggplot1)
}