plot_ethn_race_of_sids <- function() {
    sids_race_ethn <-
        tibble::tribble(
            ~race_ethn,              ~sids, ~all_children,
            "Non-Hispanic White",       14,         37.7,
            "Non-Hispanic Black",     69.9,         24.8,
            "Non-Hispanic Asian",      0.6,          8.3,
            "Hispanic/Latinx",     13.5,         32.9
        ) |> 
        tidyr::pivot_longer(
            cols = c(all_children, sids),
            names_to = "population"
        )
    
    sids_race_ethn |> 
        ggplot(
            aes(
                x = 
                    factor(
                        race_ethn,
                        levels = c("Non-Hispanic Asian", "Non-Hispanic Black", "Non-Hispanic White", "Hispanic/Latinx")
                    ),
                y = value,
                fill = 
                    factor(
                        population,
                        levels = c("sids", "all_children"),
                        labels = c("All Children Affected by SIDS", "Reference: All Children Under 5")
                    )
            )
        ) +
        scale_fill_discrete(        
            name = "Population",
            type = c("red2", "steelblue3")
        ) +
        geom_bar(
            stat = "identity",
            position = "dodge",
            color = "gray35"
        ) +
        labs(
            title = "Ethnicity/Race Distribution in Babies Affected by SIDS",
            subtitle = "",
            x = "Ethnicity/Race",
            y = "% of Population"
        ) +
        coord_cartesian(
            ylim = c(0, 100) 
        ) +
        theme_minimal()
    
    ggsave(
        "tables_and_figures/ethn_race_of_sids.svg",
        width = 10,
        height = 4.5,
        units = "in"
    )
}

plot_metro_of_sids <- function() {
    sids_race_ethn <-
        tibble::tribble(
            ~metro,              ~sids, ~all_children,
            "City of Chicago",       70.2,         55.2,
            "Suburban Cook County",  29.8,         44.8
        ) |> 
        tidyr::pivot_longer(
            cols = c(all_children, sids),
            names_to = "population"
        )
    
    sids_race_ethn |> 
        ggplot(
            aes(
                x = 
                    factor(
                        metro,
                        levels = c("City of Chicago", "Suburban Cook County")
                    ),
                y = value,
                fill = 
                    factor(
                        population,
                        levels = c("sids", "all_children"),
                        labels = c("All Babies Affected by SIDS", "Reference: All Children Under 5")
                    )
            )
        ) +
        scale_fill_discrete(        
            name = "Population",
            type = c("red2", "steelblue3")
        ) +
        geom_bar(
            stat = "identity",
            position = "dodge",
            color = "gray35"
        ) +
        labs(
            title = "Regional Distribution of Babies Affected by SIDS",
            subtitle = "",
            x = "Region",
            y = "% of Population"
        ) +
        coord_cartesian(
            ylim = c(0, 100) 
        ) +
        theme_minimal()
    
    ggsave(
        "tables_and_figures/metro_of_sids.svg",
        width = 8,
        height = 5,
        units = "in"
    )
}