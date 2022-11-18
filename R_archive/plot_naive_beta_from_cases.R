plot_naive_beta_from_cases <- function(cases = NULL, trials = NULL,  lower_bound = 0.025, upper_bound = 0.975, xlab = "Rate") {
    
    shape1 <- cases
    shape2 <- trials - cases
    mean_expected <- cases / trials
    sigma_expected <- sqrt(shape1*shape2/((shape1+shape2)^2*(shape1+shape2+1)))
    percent_interval <- (upper_bound - lower_bound) * 100
    
    full_beta <-
        tibble(x = seq(0, 1, 0.001)) |> 
        mutate(
            density = dbeta(x, shape1, shape2),
            cumulative = pbeta(x, shape1, shape2)
        ) 
    
    credible_beta <- filter(full_beta, cumulative > lower_bound & cumulative < upper_bound)
    cred_low <- qbeta(lower_bound, shape1, shape2)
    cred_up <- qbeta(upper_bound, shape1, shape2)
    
    ggplot() +
        geom_line(aes(x, density), data = full_beta) +
        geom_area(aes(x, density), data = credible_beta, fill = "red", alpha = 0.25) +
        geom_errorbarh(aes(xmin = cred_low, xmax = cred_up, y = 0), color = "red", height = 0.25) +
        geom_vline(xintercept = mean_expected, linetype = "dashed") +
        coord_cartesian(xlim = c(0,1)) +
        labs(
            title = paste0(
                "Beta Distribution for ", 
                as.character(cases), " hits(s) out of ", 
                as.character(trials), " at-bats"
            ),
            subtitle = paste0(
                "shape1 = ", as.character(shape1), ", shape2 = ", as.character(shape2), "\n",
                "Mean expected rate = ", as.character(round(mean_expected * 1E5)), " cases per 100,000 births\n", 
                #"Standard deviation = ", as.character(round(sigma_expected, 4)), "\n",
                as.character(percent_interval), "% credible interval = ", as.character(round(cred_low * 1E5)), " to ", as.character(round(cred_up * 1E5)), " cases per 100,000 births"
            ),
            x = xlab, 
            y = "Probability Density"
        ) +
        theme_light()
    
}