map_suid_count_per_tract <- function(suid_sf) {
    
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
        leaflet::leaflet(suid_sf) |>
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
                fillColor = ~ suid_palette(suid_count_factor),
                # Group polygons by number of deaths for use in the layer control
                group = ~ suid_count_factor,
                # Make slightly transparent
                fillOpacity = 0.6,
                label = "Click for more details!",
                # Click on the polygon to get its ID
                popup = 
                    ~ paste0(
                        "<b>FIPS ID</b>: ", as.character(fips), "</br>",
                        "<b>SUID Count</b>: ", as.character(suid_count), " case(s)</br>",
                        "<b>Total Population</b>: ", as.character(ec_total_pop), " people</br>",
                        "<b>Population Under 5 Years Old</b>: ", as.character(ec_under_5), " children</br>",
                        "<b>Rough Incidence</b>: ", as.character(round(suid_count / ec_under_5 * 1E5), 0), " cases per 100,000 births"
                    )
            ) |>
            #Add legend
            leaflet::addLegend(
                title = "SUID Case Counts, 2015-2019,</br>Census Tracts of Cook County, IL",
                values = ~ suid_count_factor,
                pal = suid_palette,
                position = "topright"
            ) |>
            # Add ability to toggle each factor grouping on or off the map
            leaflet::addLayersControl(
                overlayGroups = c(
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