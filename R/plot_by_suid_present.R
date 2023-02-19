

plot_by_suid_present <- function(suid_df, y_param_char, y_label_char) {
    
    suid_df$suid_present_factor <-
        factor(
            suid_df$suid_present,
            levels = c(FALSE, TRUE),
            labels = c("SUID Absent", "SUID Present")
        )
    
    suid_df |>
        ggplot(
            aes(
                y = suid_present_factor,
                x = .data[[y_param_char]], 
                #color = suid_present_factor
            ),
        ) +
        #geom_quasirandom(alpha = 0.15) +
        geom_boxplot(width = 0.25, outlier.alpha = 0.25) +
        # scale_color_discrete(        
        #     name = "",
        #     type = c("steelblue3", "red2")
        # ) +
        # stat_halfeye(show.legend = FALSE) +
        # stat_dotsinterval(show.legend = FALSE) +
        labs(
            # title = 
            #     paste0(
            #         "Comparing ", 
            #         label_param_char, 
            #         "\n of Census Tracts in Cook County \n With and Without Presence of SUID Cases from 2015-2019"
            #         
            #     ),
            y = "",
            x = y_label_char
        ) +
        theme_bw() 
    
    # ggsave(
    #     paste0("tables_and_figures/raincloud_of_", x_text_param, "_by_suid_present.svg"),
    #     width = 9,
    #     height = 6,
    #     units = "in"
    # )
}
