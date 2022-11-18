tabulate_global_prior_comparison <- function(dists_for_global_prior_comparison_df) {
    
    table1 <-
        dists_for_global_prior_comparison_df |> 
        group_by(`Risk Type`) |> 
        summarize(
            Min = min(risk_est),
            Lower = quantile(risk_est, 0.025),
            Median = median(risk_est),
            Mean = mean(risk_est),
            Upper = quantile(risk_est, 0.975),
            Max = max(risk_est),
            SD = sd(risk_est)
        ) |> 
        mutate(
            across(
                .cols = where(is.numeric),
                .fns = ~round(.x, digits = 2)
            )
        ) |> 
        arrange(desc(`Risk Type`)) |> 
        knitr::kable()
    
    return(table1)
    
}