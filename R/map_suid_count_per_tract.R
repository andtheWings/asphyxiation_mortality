map_suid_count_per_tract <- function(suid_sf) {
    
    # Configure color palette
    suid_palette <- 
        leaflet::colorFactor(
            palette = "magma",
            reverse = TRUE,
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
                # No borders to the polygons, just fill
                color = "gray",
                weight = 0.25,
                opacity = 1,
                # Color according to palette above
                fillColor = ~ suid_palette(suid_count_factor),
                # Group polygons by number of deaths for use in the layer control
                group = ~ suid_count_factor,
                # Make slightly transparent
                fillOpacity = 0.5,
                label = "Click for more details!",
                # Click on the polygon to get its ID
                popup = 
                    ~ paste0(
                        "<b>FIPS ID</b>: ", as.character(fips), "</br>",
                        "<b>SUID Count</b>: ", suid_count, " cases</br>",
                        "<b>Total Population</b>: ", pop_total_est, " people</br>",
                        "<b>Population Under 5 Years Old</b>: ", pop_under_five_est, " children</br>",
                        "<b>Modeled Births</b>: ", modeled_births_adj, " births</br>",
                        "<b>Rough Incidence</b>: ", rough_suid_incidence, " cases per 100,000 births"
                    )
            ) |>
            #Add legend
            leaflet::addLegend(
                title = "Legend",
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