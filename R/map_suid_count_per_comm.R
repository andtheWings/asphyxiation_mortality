map_suid_count_per_comm <- function(suid_sf) {
    
    obj1 <-
        tmap::tmap_leaflet(
            suid_sf |> 
            sf::st_transform(4326) |> 
            tmap::tm_shape() +
            tmap::tm_polygons(
                "suid_count_cat",
                title = "SUID Case Counts, 2015-2019,</br>Communities of Cook County, IL",
                alpha = 0.6,
                popup.vars = c(
                    "Case Count" = "suid_count",
                    "Total Population" = "e_totpop",
                    "Population <5 years old" = "e_under_5",
                    "Rough Incidence (per 100,000 births)" = "suid_rough_incidence",
                    "Median Age" = "e_median_age",
                    "Sex Ratio (males per 100 females)" = "e_sex_ratio",
                    "Non-Hispanic White, Alone (%)" = "ep_non_hisp_white_alone",
                    "Non-Hispanic Black, Alone (%)" = "ep_non_hisp_black_alone",
                    "Asian, Any (%)" = "ep_asian_any",
                    "American Indian and Alaska Native, Any (%)" = "ep_aian_any",
                    "Hispanic, Any (%)" = "ep_hispanic_any"
                ),
                popup.format = list(
                    digits = 2
                )
            )
        ) |> 
        leaflet.extras::addFullscreenControl()
    
    return(obj1)
    
}