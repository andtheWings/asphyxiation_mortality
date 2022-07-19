fit_nb_model_of_suid <- function(suid_df) {
    
    model1 <- 
        MASS::glm.nb(
            suid_count ~ pop_under_five + public_insurance + count_opioid_death + white + count_opioid_death:white,
            data = suid_df
        )
    
    return(model1)
}

fit_lm_model_of_suid <- function(suid_df) {
    
    model1 <- 
        lm(
            sids_count ~ pop_under_five + public_insurance + count_opioid_death + white + count_opioid_death:white,
            data = sids_df
        )
    
    return(model1)
}