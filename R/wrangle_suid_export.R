wrangle_suid_export <- function(suid_nb_prediction_data_comm_sf, suid_descriptive_data_agg_sf, suid_training_data_assess_comm_sf) {
    
    df1 <-
        suid_descriptive_data_agg_sf |>
        as_tibble() |> 
        select(-geometry) |> 
        rename_with(
            ~ glue::glue("{.x}_2015_2019"),
            c(
                suid_count,
                suid_present,
                suid_count_cat,
                suid_rough_incidence
            )
        ) |>
        rename_with(
            ~ glue::glue("{.x}_2018"),
            c(
                e_totpop,
                e_crowd,
                e_pov,
            )
        ) |> 
        rename_with(
            ~ glue::glue("{.x}_2019"),
            c(
                e_median_age,
                e_sex_ratio,
                ep_non_hisp_white_alone,
                ep_non_hisp_black_alone,
                ep_asian_any,
                ep_aian_any,
                ep_hispanic_any,
                e_under_5
            )
        )
    
    df2 <-
        suid_training_data_assess_comm_sf |>
        as_tibble() |> 
        select(-suid_count, -geometry) |> 
        rename_with(
            ~ glue::glue("{.x}_2014"),
            c(
                starts_with("e_"),
                starts_with("log_e_")
            ),
        ) |> 
        rename_with(
            ~ glue::glue("{.x}_2015_2019"),
            starts_with(".pred")
        )
    
    sf1 <-
        suid_nb_prediction_data_comm_sf |> 
        select(-suid_count) |> 
        rename_with(
            ~ glue::glue("{.x}_2020"),
            c(
                starts_with("e_"),
                starts_with("log_e_")
            )
        ) |>
        rename_with(
            ~glue::glue("{.x}_2021_2025"),
            starts_with(".pred")
        )
    
    sf2 <- 
        full_join(sf1, df1, by = "community") |> 
        full_join(df2, by = "community") |> 
        relocate(
            in_chicago,
            .after = community
        ) |>
        relocate(
            ends_with("2015_2019"),
            .after = in_chicago
        ) |>
        relocate(
            ends_with("2014"),
            .after = .predicted_obs_diff_2015_2019
        ) |> 
        relocate(
            ends_with("_2018"),
            .after = log_e_crowd_2014
        ) |> 
        relocate(
            c(
                e_under_5_2019,
                matches("[a-z]_2019")
            ),
            .after = e_pov_2018
        ) |> 
        relocate(
            geometry,
            .after = .predicted_obs_diff_2021_2025
        )
    
    return(sf2)
    
}