repeat_spatial_clustering_cv <- function(data_sf, replicate_id_int) {
    
    data_sf |> 
        spatialsample::spatial_clustering_cv() |> 
        rename(fold_id = id) |> 
        mutate(replicate_id = replicate_id_int)
    
}