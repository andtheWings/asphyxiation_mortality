assemble_suid_legacy <- function(suid_from_tidycensus_sf, suid_from_internal_df, model_births_from_under_five_by_county_obj) {
    
    global_prior_alpha <- 1
    global_prior_beta <- 1135
    
    sf1 <- 
        suid_from_tidycensus_sf |> 
        right_join(suid_from_internal_df, by = "fips")
    
    sf2 <-
        sf1 |> 
        mutate(
            modeled_births = 
                as.numeric(
                    round(
                        insight::get_predicted(
                            model_births_from_under_five_by_county_obj,
                            newdata = sf1
                        )
                    )
                ),
            # Adjust births given SUID case counts
            modeled_births_adj =
                case_when(
                    modeled_births < suid_count ~ suid_count,
                    TRUE ~ modeled_births
                ),
            # Calculate approximate SUID incidence per 1E5 live births
            rough_suid_incidence = round(suid_count / modeled_births_adj * 1E5),
            # Account for pop_under_five_est's that are 0
            rough_suid_incidence =
                case_when(
                    # If incidence is NaN, change to 0
                    is.nan(rough_suid_incidence) ~ 0,
                    # If it's Inf, change to 100,000
                    is.infinite(rough_suid_incidence) ~ 1E5,
                    # Otherwise, keep as is
                    TRUE ~ rough_suid_incidence
                ),
            .after = suid_count_factor
            # global_posterior_alpha = global_prior_alpha + suid_count,
            # global_posterior_beta = global_prior_beta + pop_under_five_est - suid_count,
            # global_posterior_risk = global_posterior_alpha / (global_posterior_alpha + global_posterior_beta) * 1E5,
            # # Use the Beta Distribution Quantile function to also get 95% credible intervals
            # global_posterior_risk_low = qbeta(0.025, global_posterior_alpha, global_posterior_beta) * 1E5,
            # global_posterior_risk_high = qbeta(0.975, global_posterior_alpha, global_posterior_beta) * 1E5,
            # .after = suid_count_factor
        )
        # mutate(
        #     neighbors = sfdep::st_contiguity(geometry),
        #     weights = sfdep::st_weights(neighbors),
        #     .after = geometry
        # ) 
    
    
        
    
    return(sf2)
}