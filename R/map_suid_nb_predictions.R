map_suid_nb_predictions <- function(suid_prediction_data_sf) {
    

    # Configure color palette
    suid_palette <- 
        leaflet::colorFactor(
            palette = c(
                "#9ecae1",
                "#fcbba1",
                "#fc9272",
                "#fb6a4a",
                "#ef3b2c",
                "#cb181d",
                "#99000d"
            ),
            #reverse = TRUE,
            levels = c(
                "No Cases", 
                "One Case", 
                "Two Cases", 
                "Three Cases", 
                "Four Cases", 
                "Five Cases", 
                "Six+ Cases"
            )
        )
    
    obj1 <-
        # Assign map to a widget object
        leaflet::leaflet(suid_prediction_data_sf) |>
        # Use CartoDB's background tiles
        leaflet::addProviderTiles("CartoDB.Positron") |>
        # Center and zoom the map to Cook County
        leaflet::setView(lat = 41.816544, lng = -87.749500, zoom = 9) |>
        # Add button to enable fullscreen map
        leaflet.extras::addFullscreenControl() |>
        # Add census tract polygons colored to reflect the number of deaths
        leaflet::addPolygons(
            color = "black",
            weight = 0.75,
            opacity = 0.5,
            # Color according to palette above
            fillColor = ~ suid_palette(.predicted_factor),
            # Group polygons by number of deaths for use in the layer control
            group = ~ .predicted_factor,
            # Make slightly transparent
            fillOpacity = 0.5,
            label = "Click for more details!",
            # Click on the polygon to get its ID
            popup = 
                ~ paste0(
                    "<b>FIPS ID</b>: ", as.character(fips), "</br>",
                    "<b>Predicted (2021-2025)</b>: ", as.character(round(.predicted, 2)), "</br>",
                    "<b>Observed (2015-2019)</b>: ", as.character(suid_count), "</br>",
                    "<b>Population with Disabilities</b>: ", as.character(e_disabl), "</br>",
                    "<b>Percentage Minority People</b>: ", as.character(ep_minrty), "</br>",
                    "<b>Percentage Single-Parent Households</b>: ", as.character(ep_sngpnt), "</br>",
                    "<b>Percentage Unemployed Civilians</b>: ", as.character(ep_unemp)
                )
        ) |>
        #Add legend
        leaflet::addLegend(
            title = "Predicted SUID Case Counts, 2021-2015,</br>Census Tracts of Cook County, IL",
            values = ~.predicted_factor,
            pal = suid_palette,
            position = "topright"
        ) |>
        # Add ability to toggle each factor grouping on or off the map
        # leaflet::addLayersControl(
        #     overlayGroups = c("Chicago", "Evanston", "Oak Park", "Skokie", "Stickney", "Suburban Cook County"),
        #     position = "topright",
        #     options = leaflet::layersControlOptions(collapsed = FALSE)
        # )
        leaflet::addLayersControl(
            overlayGroups = c(
                NA,
                "No Cases", 
                "One Case", 
                "Two Cases", 
                "Three Cases", 
                "Four Cases", 
                "Five Cases", 
                "Six+ Cases"
            ),
            position = "topleft"
        )
    
    return(obj1)
    
}