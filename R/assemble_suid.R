assemble_suid <- function(suid_from_tidycensus_sf, suid_from_internal_df) {
    
    # https://dph.illinois.gov/topics-services/life-stages-populations/infant-mortality/sids/sleep-related-death-statistics.html
    overall_incidence <- 88.3 / 1E5 # per live birth for Cook County in 2014
    
    # https://dph.illinois.gov/data-statistics/vital-statistics/birth-statistics.html
    total_live_births <- 139398 # for Cook County from 2015-2019
    
    overall_cases_extrapolated <- overall_incidence * total_live_births
    overall_survivals_extrapolated <- total_live_births - overall_cases_extrapolated
    global_prior_scaling <- median(suid_from_tidycensus_sf$pop_under_five_est) / total_live_births
    global_prior_alpha <- overall_cases_extrapolated * global_prior_scaling
    global_prior_beta <- overall_survivals_extrapolated * global_prior_scaling
    
    sf1 <- 
        suid_from_tidycensus_sf |> 
        right_join(suid_from_internal_df, by = "fips") |> 
        mutate(
            # Calculate approximate SUID incidence per 1E5 live births
            approx_suid_incidence = round(suid_count / pop_under_five_est * 1E5, 2),
            # Account for pop_under_five_est's that are 0
            approx_suid_incidence =
                case_when(
                    # If incidence is NaN, change to 0
                    is.nan(approx_suid_incidence) ~ 0,
                    # If it's Inf, change to 100,000
                    is.infinite(approx_suid_incidence) ~ 1E5,
                    # Otherwise, keep as is
                    TRUE ~ approx_suid_incidence
                ),
            global_posterior_alpha = global_prior_alpha + suid_count,
            global_posterior_beta = global_prior_beta + pop_under_five_est - suid_count,
            global_posterior_risk = global_posterior_alpha / (global_posterior_alpha + global_posterior_beta) * 1E5,
            # Use the Beta Distribution Quantile function to also get 95% credible intervals
            global_posterior_risk_low = qbeta(0.025, global_posterior_alpha, global_posterior_beta) * 1E5,
            global_posterior_risk_high = qbeta(0.975, global_posterior_alpha, global_posterior_beta) * 1E5,
            .after = suid_count_factor
        ) |>
        mutate(
            neighbors = sfdep::st_contiguity(geometry),
            weights = sfdep::st_weights(neighbors),
            .after = geometry
        )
    
    return(sf1)
}