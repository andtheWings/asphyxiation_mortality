wrangle_suid_training_data_comm <- function(suid_training_data_sf) {
    
    suid_training_data_sf |> 
        group_by(community) |> 
        summarise(
            suid_count = sum(suid_count, na.rm = TRUE),
            across(
                .cols = starts_with("e_"),
                .fns = ~sum(.x, na.rm = TRUE)
            )
        ) |> 
        ungroup() |> 
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
    
}