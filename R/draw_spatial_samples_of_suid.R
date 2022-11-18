draw_spatial_samples_of_suid <- function(suid_sf) {
    
    sf1 <- select(.data = suid_sf, suid_count, count_opioid_death, white, public_insurance)
    
    spatial_clustering_cv1 <-
        map(
            1:3,
            ~repeat_spatial_clustering_cv(sf1, .x)
        ) #|> 
        #reduce(bind_rows)
    
    return(spatial_clustering_cv1)
    
}