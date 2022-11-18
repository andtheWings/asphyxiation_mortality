wrangle_ccme_archive_suid_cases <- function(ccme_archive_raw_df) {
    
    other_cases <- c('ME2015-00661','ME2015-00978','ME2015-04542','ME2015-05167','ME2015-05204','ME2016-00123','ME2016-01635','ME2016-02889', 'ME2017-00449','ME2017-00532','ME2017-02115','ME2017-05868','ME2018-00484','ME2018-01642','ME2018-05292','ME2019-02450')
    
    df1 <-
        ccme_archive_raw_df |> 
        # Standardize variable names
        clean_names() |> 
        # Filter only for infants below age 1 year
        filter(age == 0) |>
        mutate(
            # Convert manner and cause descriptions to all lower-case for consistency
            manner_of_death = str_to_lower(manner_of_death),
            primary_cause = str_to_lower(primary_cause)
        ) |> 
        # Filter just for SUID cases
        filter(
            # Manner and Cause of Death were both undetermined 
            (str_detect(manner_of_death, "undetermined") & str_detect(primary_cause, "undetermined")) |
                # -OR- Cause of death was asphyxia
                str_detect(primary_cause, "asphyxia") |
                # -OR- Cause of death was suffocation
                str_detect(primary_cause, "suffoc") |
                # -OR- Case was defined as SUID in independent review but isn't capture by auto-definitions
                case_number %in% other_cases
        ) |> 
        mutate(
            # Add variable for year of death
            year_of_death = 
                year(
                    mdy_hms(date_of_death)
                ),
            # Add variable on whether the case was captured by auto-definition
            auto_captured =
                case_when(
                    case_number %in% other_cases ~ FALSE,
                    TRUE ~ TRUE
                ),
            # Add variable aggregating race and ethnicity together
            race_ethn =
                case_when(
                    latino == TRUE ~ "Hispanic/Latino",
                    race == "White" ~ "Non-Hispanic White",
                    race == "Black" ~ "Non-Hispanic Black",
                    is.na(race) ~ "Other",
                    TRUE ~ "Other"
                )
        )
    
    return(df1)
    
}