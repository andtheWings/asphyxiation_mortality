tabulate_suid_counts <- function(suid_sf) {
    
    suid_sf |>
        as_tibble() |> 
        tabyl(suid_count) |> 
        adorn_pct_formatting() |> 
        rename(
            `SUID Case Count` = suid_count,
            Frequency = n,
            Percent = percent
        )
    
}