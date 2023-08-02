wrangle_top_ranked_predictions <- function(suid_nb_prediction_data_sf) {
    
    suid_nb_prediction_data_sf |> 
        as_tibble() |> 
        arrange(desc(.predicted_percentile)) |> 
        head(61) |> 
        select(fips, suid_count, .predicted, oc_city, oc_town, oc_suburb, oc_neighbourhood)
    
}