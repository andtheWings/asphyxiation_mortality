

plot_raincloud_by_suid_present <- function(suid_df, x_text_param, label_param) {
    
    suid_df$suid_present_factor <-
        factor(
            suid_df$suid_present,
            levels = c(FALSE, TRUE),
            labels = c("SUID Absent", "SUID Present")
        )
    
    suid_df |>
        ggplot(
            aes(
                x = .data[[x_text_param]], 
                y = suid_present_factor,
                color = suid_present_factor
            ),
        ) +
        scale_color_discrete(        
            name = "",
            type = c("steelblue3", "red2")
        ) +
        stat_halfeye(show.legend = FALSE) +
        stat_dotsinterval(side = "bottom", show.legend = FALSE) +
        labs(
            title = 
                paste0(
                    "Comparing ", 
                    label_param, 
                    "Cook County Census Tracts \n With and Without Presence of SUID Cases from 2015-2019"
                    
                ),
            x = paste0(label_param, " Census Tract"),
            y = ""
        ) +
        theme_minimal() 
    
    ggsave(
        paste0("tables_and_figures/raincloud_of_", x_text_param, "_by_suid_present.svg"),
        width = 9,
        height = 6,
        units = "in"
    )
}
