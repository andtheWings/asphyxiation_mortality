map_suid_prediction_categories <- function(suid_prediction_data_sf) {

    labels_chr <- c(
        "Not Predicted; 0 Observed",
        "Not Predicted; 1 Observed",
        "Not Predicted; 2+ Observed",
        "Predicted; 0 Observed",
        "Predicted; 1 Observed",
        "Predicted; 2+ Observed"
    )
    
    colors_chr <- c(
        "#2171b5",
        "#6baed6",
        "#bdd7e7",
        "#fcae91",
        "#fb6a4a",
        "#cb181d"
    )
        
    # labels_chr <- c(
    #     "1st Quintile",
    #     "2nd Quintile",
    #     "3rd Quintile",
    #     "4th Quintile",
    #     "5th Quintile"
    # )
    # 
    # colors_chr <- c(
    #     "#f2f0f7",
    #     "#cbc9e2",
    #     "#9e9ac8",
    #     "#756bb1",
    #     "#54278f"
    # )
    
    # labels_chr <- c(
    #     "Predicted; > 1 Case",
    #     "Predicted; 1 Case",
    #     "Predicted; NA Cases",
    #     "Predicted; 0 Cases",
    #     "Not Predicted; > 1 Case",
    #     "Not Predicted; 1 Case",
    #     "Not Predicted; NA Cases",
    #     "Not Predicted; 0 Cases"
    # )
    
    # labels_chr <- c(
    #     "Combined Zero",
    #     "Solo Zero",
    #     "Mixed One",
    #     "Mixed Two",
    #     "Mixed Three",
    #     "Mixed Four",
    #     "Mixed Five",
    #     "Solo One",
    #     "Combined Two",
    #     "Solo Two",
    #     "Combined Three",
    #     "Solo Three",
    #     "Combined Four",
    #     "Solo Four",
    #     "Combined Five",
    #     "Solo Five",
    #     "Combined Six",
    #     "Solo Six",
    #     "Combined Seven"
    # )

    # colors_chr <- c(
    #     "#b2182b",
    #     "#d6604d",
    #     "#f4a582",
    #     "#fddbc7",
    #     "#d1e5f0",
    #     "#92c5de",
    #     "#4393c3",
    #     "#2166ac"
    # )
    
    # colors_chr <- c(
    #     "#9ecae1",
    #     "#9ecae1",
    #     "#9e9ac8",
    #     "#807dba",
    #     "#6a51a3",
    #     "#54278f",
    #     "#3f007d",
    #     "#fcbba1",
    #     "#fc9272",
    #     "#fc9272",
    #     "#fb6a4a",
    #     "#fb6a4a",
    #     "#ef3b2c",
    #     "#ef3b2c",
    #     "#cb181d",
    #     "#cb181d",
    #     "#a50f15",
    #     "#a50f15",
    #     "#67000d"
    # )
    
    # colors_chr <- c(
    #     "#9ecae1",
    #     "#9ecae1",
    #     "#fcbba1",
    #     "#fc9272",
    #     "#fb6a4a",
    #     "#ef3b2c",
    #     "#cb181d",
    #     "#fcbba1",
    #     "#fc9272",
    #     "#fc9272",
    #     "#fb6a4a",
    #     "#fb6a4a",
    #     "#ef3b2c",
    #     "#ef3b2c",
    #     "#cb181d",
    #     "#cb181d",
    #     "#a50f15",
    #     "#a50f15",
    #     "#67000d"
    # )
    
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
            color = "black",
            weight = 0.75,
            opacity = 0.5,
            # Color according to palette above
            fillColor = ~ palette1(.predicted_observed_no_na),
            # Group polygons by number of deaths for use in the layer control
            group = ~ .predicted_observed_no_na,
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
            title = "SUID Case Count</br>Predictions (2021-2025)</br> and Observations (2015-2019),</br>Census Tracts of Cook County, IL",
            colors = colors_chr,
            labels = labels_chr,
            position = "topright"
        ) |> 
        # Add ability to toggle each factor grouping on or off the map
        leaflet::addLayersControl(
            overlayGroups = c(
                "Not Predicted; 0 Observed",
                "Not Predicted; 1 Observed",
                "Not Predicted; 2+ Observed",
                "Predicted; 0 Observed",
                "Predicted; 1 Observed",
                "Predicted; 2+ Observed"
            ),
            position = "topleft"
        )
    
    return(obj1)
    
}