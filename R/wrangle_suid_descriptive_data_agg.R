wrangle_suid_descriptive_data_agg <- function(suid_descriptive_data_sf) {
    
    suid_descriptive_data_sf |> 
        group_by(community) |> 
        summarize(
            suid_count = sum(suid_count, na.rm = TRUE),
            e_median_age = median(e_median_age),
            e_sex_ratio = sum(e_male, na.rm = TRUE) / sum(e_female, na.rm = TRUE) * 100,
            ep_non_hisp_white_alone = sum(e_non_hisp_white_alone, na.rm = TRUE) / sum(e_totpop, na.rm = TRUE) * 100,
            ep_non_hisp_black_alone = sum(e_non_hisp_black_alone, na.rm = TRUE) / sum(e_totpop, na.rm = TRUE) * 100,
            ep_asian_any = sum(e_asian_any, na.rm = TRUE) / sum(e_totpop, na.rm = TRUE) * 100,
            ep_aian_any = sum(e_aian_any, na.rm = TRUE) / sum(e_totpop, na.rm = TRUE) * 100,
            ep_hispanic_any = sum(e_hispanic_any, na.rm = TRUE) / sum(e_totpop, na.rm = TRUE) * 100,
            e_totpop = sum(e_totpop, na.rm = TRUE),
            e_under_5 = sum(e_under_5, na.rm = TRUE),
            e_crowd = sum(e_crowd, na.rm = TRUE),
            e_pov = sum(e_pov, na.rm = TRUE),
            in_chicago =
                if_else(
                    any(oc_city == "Chicago"),
                    TRUE, FALSE
                )
        ) |> 
        mutate(
            suid_present = 
                if_else(
                    suid_count > 0,
                    TRUE, FALSE
                ),
            suid_count_cat =
                factor(
                    case_when(
                        suid_count < 3 ~ "0-2",
                        suid_count >= 3 & suid_count < 6 ~ "3-5",
                        suid_count >= 6 & suid_count < 9 ~ "6-8",
                        suid_count >= 9 & suid_count < 12 ~ "9-11",
                        suid_count >= 12 & suid_count < 15 ~ "12-14",
                        suid_count >= 15 & suid_count < 18 ~ "15-17",
                    ),
                    levels = c("0-2", "3-5", "6-8", "9-11", "12-14", "15-17"),
                    ordered = TRUE
                ),
            suid_rough_incidence = round(suid_count / e_under_5 * 1E5, digits = 0)
        )
    
}