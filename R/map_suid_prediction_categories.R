map_suid_prediction_categories <- function(suid_prediction_data_sf) {
    
    
    labels_chr <- c(
        "Persistently Present",
        "Present (no previous comparison)",
        "Newly Present", 
        "Newly Absent", 
        "Absent (no previous comparison)",
        "Persistently Absent"
    )
    
    colors_chr <- c(
        "#b2182b",
        "#ef8a62",
        "#fddbc7",
        "#d1e5f0",
        "#67a9cf",
        "#2166ac"
    )
    
    # Configure color palette
    palette1 <- 
        leaflet::colorFactor(
            palette = colors_chr,
            levels = labels_chr,
            ordered = FALSE
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
            fillColor = ~ palette1(.predicted_category),
            # Group polygons by number of deaths for use in the layer control
            group = ~ jurisdiction,
            # Make slightly transparent
            fillOpacity = 0.5,
            label = "Click for more details!",
            # Click on the polygon to get its ID
            popup = 
                ~ paste0(
                    "<b>FIPS ID</b>: ", as.character(fips), "</br>",
                    "<b>Prediction Category</b>: ", .predicted_category, "</br>",
                    "<b>Raw Prediction</b>: ", .predicted, "</br>",
                    "<b>SUID Count (2015-2019)</b>: ", as.character(suid_count), "</br>",
                    "<b>Minority Residents</b>: ", as.character(ep_minrty), "%</br>",
                    "<b>Unemployment</b>: ", as.character(ep_unemp), "%"
                )
        ) |>
        #Add legend
        leaflet::addLegend(
            title = "SUID Prediction Categories in</br>Cook County Census Tracts during </br> 2021-2025 compared to 2015-2019",
            colors = colors_chr,
            labels = labels_chr,
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