map_suid_nb_predictions_per_comm <- function(suid_prediction_data_sf, suid_training_data_assess_comm_sf, years_char = "2021-2025") {
    
    increasing <- c("Chicago Lawn", "South Deering", "Auburn Gresham", "Dolton", "Douglas", "Rogers Park", "Washington Heights")
    decreasing <- c("Near North Side", "West Pullman", "West Englewood", "Roseland", "Calumet Heights", "Englewood", "Maywood")
    top_pred <- c("Austin", "Englewood", "Auburn Gresham", "Chicago Lawn", "South Shore", "Humboldt Park", "North Lawndale", "South Lawndale", "New City", "West Englewood")
    
    sf1 <-
        suid_prediction_data_sf |> 
        dplyr::mutate(
            suid_prediction_cat =
                factor(
                    dplyr::case_when(
                        .predicted < 3 ~ "0-2",
                        .predicted >= 3 & .predicted < 6 ~ "3-5",
                        .predicted >= 6 & .predicted < 9 ~ "6-8",
                        .predicted >= 9 & .predicted < 12 ~ "9-11",
                        .predicted >= 12 & .predicted < 15 ~ "12-14",
                        .predicted >= 15 & .predicted < 18 ~ "15-17",
                    ),
                    levels = c("0-2", "3-5", "6-8", "9-11", "12-14", "15-17"),
                    ordered = TRUE
                )
        ) |> 
        sf::st_transform(4326) |> 
        select(-suid_count) |> 
        filter(
            # community %in% decreasing | 
            # community %in% increasing |
            community %in% top_pred
        ) |> 
        left_join(
            suid_training_data_assess_comm_sf |> 
                as_tibble() |> 
                select(-geometry), 
            by = "community",
            suffix = c("_2020_2025", "_2014_2019")
        )
    
    obj1 <-
        tmap::tmap_leaflet(
            sf1 |> 
                tmap::tm_shape() +
                tmap::tm_polygons(
                    "suid_prediction_cat",
                    title = glue::glue("SUID Case Count Predictions, {years_char},</br>Communities of Cook County, IL"),
                    alpha = 0.6,
                    popup.vars = c(
                        "Prediction, 2021-2025" = ".predicted_2020_2025",
                        "Case Count, 2015-2019" = "suid_count",
                        "Total Population, 2020" = "e_totpop_2020_2025",
                        "Total Population, 2014" = "e_totpop_2014_2019",
                        "Total Below Poverty Line, 2020" = "e_pov_2020_2025",
                        "Total Below Poverty Line, 2014" = "e_pov_2014_2019",
                        "Total Crowded Households, 2020" = "e_crowd_2020_2025",
                        "Total Crowded Households, 2014" = "e_crowd_2014_2019"
                    )
                )
        ) |> 
        leaflet.extras::addFullscreenControl()
 
    return(obj1)   
}