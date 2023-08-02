map_suid_prediction_obs_sums <- function(suid_prediction_data_sf) {
    

    # Configure color palette
    palette1 <- 
        leaflet::colorNumeric(
            palette = "magma",
            domain = 0:1,
            reverse = TRUE
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
            color = "gray",
            weight = 0.25,
            opacity = 1,
            # Color according to palette above
            fillColor = ~ palette1(.predicted_observed_sum),
            # Group polygons by number of deaths for use in the layer control
            group = ~ jurisdiction,
            # Make slightly transparent
            fillOpacity = 0.5,
            label = "Click for more details!",
            # Click on the polygon to get its ID
            popup = 
                ~ paste0(
                    "<b>FIPS ID</b>: ", as.character(fips), "</br>",
                    "<b>Sum of Predicted and Observed</b>: ", as.character(.predicted_observed_sum), "</br>",
                    "<b>Predicted (2021-2025)</b>: ", as.character(.predicted), "</br>",
                    "<b>Observed (2015-2019)</b>: ", as.character(suid_count), "</br>",
                    "<b>Population with Disabilities</b>: ", as.character(e_disabl), "</br>",
                    "<b>Percentage Minority People</b>: ", as.character(ep_minrty), "</br>",
                    "<b>Percentage Single-Parent Households</b>: ", as.character(ep_sngpnt), "</br>",
                    "<b>Percentage Unemployed Civilians</b>: ", as.character(ep_unemp)
                )
        ) |>
        #Add legend
        leaflet::addLegend(
            title = "Sum of SUID Predictions (2021-2025)</br> and Observations (2015-2019),</br>Cook County, IL",
            values = ~.predicted_observed_sum,
            pal = palette1,
            position = "topright"
        ) |>
        # Add ability to toggle each factor grouping on or off the map
        leaflet::addLayersControl(
            overlayGroups = c("Chicago", "Evanston", "Oak Park", "Skokie", "Stickney", "Suburban Cook County"),
            position = "topright",
            options = leaflet::layersControlOptions(collapsed = FALSE)
        )
    
    return(obj1)
    
}