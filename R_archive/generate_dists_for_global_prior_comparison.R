generate_dists_for_global_prior_comparison <- function(suid_sf) {
    
    df1 <-
        suid_sf |> 
        as_tibble() |> 
        select(
            `Incidence Calculation` = approx_suid_incidence,
            `Posterior Estimation` = global_posterior_risk
        ) |> 
        mutate("Prior Simulation" = rbeta(n = 1315, shape1 = 1, shape2 = 1135) * 1E5) |> 
        pivot_longer(
            cols = everything(),
            names_to = "Risk Type",
            values_to = "risk_est"
            
        ) |> 
        mutate(
            `Risk Type` = 
                factor(
                    `Risk Type`,
                    levels = c("Posterior Estimation", "Prior Simulation", "Incidence Calculation"),
                    ordered = TRUE
                )
        )
    
    return(df1)
    
}