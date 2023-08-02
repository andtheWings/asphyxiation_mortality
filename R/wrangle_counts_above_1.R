wrangle_counts_above_1 <- function(suid_nb_prediction_data_sf) {
    
    suid_nb_prediction_data_sf |> 
        dplyr::as_tibble() |>
        dplyr::arrange(desc(suid_count)) |> 
        dplyr::filter(suid_count >= 2) |> 
        dplyr::select(fips, suid_count, oc_city, oc_town, oc_suburb, oc_neighbourhood)
    
}