calc_r2_nb <- function(augmented_nb_df) {
    
    deviance_null <- calc_deviance_nb(augmented_nb_df$.deviance_resid_null)
    deviance_model <- calc_deviance_nb(augmented_nb_df$.deviance_resid_model)
    
    r2 <- (deviance_null - deviance_model) / deviance_null
    
    return(r2)
}