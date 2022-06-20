assemble_suid <- function(suid_from_internal_raw_df, suid_from_tidycensus_sf) {
    
    df1 <- 
        left_join(
            suid_from_internal_raw_df,
            suid_from_tidycensus_sf,
            by = c("FIPS" = "fips")
        ) |>
        clean_names() |> 
        # Rename variables for consistency
        rename(
            suid_count = count_asphyxia,
            foreign_born = pe_foreignborn,
            married_males = pe_marriedmales,
            married_females = pe_marriedfemales,
            divorced_widowed_males = pedivorcewidowedmale,
            divorced_widowed_females = pedivorcewidowedfemale,
            lt_high_school = pelessthanhighschool,
            high_school_diploma = highschooldiploma,
            some_college = somecollege,
            college_diploma = collegediploma,
            employed = percent_enployed,
            income_lt_10 = incomelt10,
            income_lt_25 = incomelt25,
            income_lt_50 = incomelt50,
            income_lt_75 = incomelt75,
            income_gt_75 = incomegt75,
            private_insurance = privateinsurance,
            public_insurance = publicinsurance,
            no_insurance = noinsurance
        ) |> 
        # Add new variables
        mutate(
            # Binary variable on whether suid is present in a tract
            suid_present = case_when(
                suid_count > 0 ~ TRUE,
                TRUE ~ FALSE
            ),
            across(
                .cols = starts_with("svi_"),
                .fns = ~ round((.x * 100), digits = 1)
            )
        )
    
    return(df1)
}