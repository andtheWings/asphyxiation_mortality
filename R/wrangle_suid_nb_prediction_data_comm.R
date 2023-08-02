wrangle_suid_nb_prediction_data_comm <- function(suid_sf, negbinomial_full_model_comm_obj) {
    
    sf1 <-
        suid_sf |> 
        group_by(community) |> 
        summarise(
            suid_count = sum(suid_count, na.rm = TRUE),
            across(
                .cols = starts_with("e_"),
                .fns = ~sum(.x, na.rm = TRUE)
            )
        ) |> 
        ungroup() |>
        filter(!is.na(community)) |> 
        mutate(
            log_e_totpop =
                case_when(
                    e_totpop == 0 ~ 0,
                    TRUE ~ log(e_totpop)
                ),
            log_e_pov =
                case_when(
                    e_pov == 0 ~ 0,
                    TRUE ~ log(e_pov)
                ),
            log_e_crowd =
                case_when(
                    e_crowd == 0 ~ 0,
                    TRUE ~ log(e_crowd)
                )
        )
        
    sf2 <-
        sf1 |> 
        mutate(
            .predicted = as.numeric(insight::get_predicted(negbinomial_full_model_comm_obj, newdata = sf1)),
            .predicted_obs_diff = .predicted - suid_count
        )
    
    return(sf2)
    
}