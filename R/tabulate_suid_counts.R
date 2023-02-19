tabulate_suid_counts <- function(suid_from_internal_df) {
    
    suid_from_internal_df |> 
        tabyl(suid_count) |> 
        adorn_pct_formatting() |> 
        rename(
            `SUID Case Count` = suid_count,
            Frequency = n,
            Percent = percent
        )
    
}