make_table_of_vars_by_sids_present <- function(sids_df) {
    
    box::use(
        gt[
            cols_hide,
            gtsave,
            md,
            tab_header
        ]
    )
    
    table1 <- 
        sids_df |>
        mutate(
            pop_under_five = 
                round(
                    pop_under_five / pop_total * 100, 
                    digits = 1
                )
        ) |> 
        relocate(
            pop_under_five, 
            male, 
            black, white, hispanic, spanish_language, foreign_born,
            lt_high_school, high_school_diploma, some_college, college_diploma,
            employed,
            income_lt_10, income_lt_25, income_lt_50, income_lt_75, income_gt_75,
            married_males, married_females, divorced_widowed_males, divorced_widowed_females,
            private_insurance, public_insurance, no_insurance,
            svi_socioeconomic, svi_household_composition_disability, svi_minority_language, svi_housing_transportation, svi_summary_ranking
        ) |> 
        rename(
            "Black (%)" = black,
            "White (%)" = white,
            "Hispanic (%)" = hispanic,
            "Less than high school (%)" = lt_high_school,
            "High school diploma (%)" = high_school_diploma,
            "Some college (%)" = some_college,
            "College Diploma (%)" = college_diploma,
            "Divorced, widowed females (%)" = divorced_widowed_females,
            "Divorced, widowed males (%)" = divorced_widowed_males,
            "Married females (%)" = married_females,
            "Married males (%)" = married_males,
            "Income greater than the 75th percentile (%)" = income_gt_75,
            "Income less than the 10th percentile (%)" = income_lt_10,
            "Income less than the 25th percentile (%)" = income_lt_25,
            "Income less than the 50th percentile (%)" = income_lt_50,
            "Income less than the 75th percentile (%)" = income_lt_75,
            "Private insurance (%)" = private_insurance,
            "Public insurance (%)" = public_insurance,
            "No insurance (%)" = no_insurance,
            "SVI household composition & disability (National %ile)" = svi_household_composition_disability,
            "SVI socioeconomic status (National %ile)" = svi_socioeconomic,
            "SVI minority status & language (National %ile)" = svi_minority_language,
            "SVI housing type & transportation (National %ile)" = svi_housing_transportation,
            "SVI summary (National %ile)" = svi_summary_ranking,
            "Population under 5 years old (%)" = pop_under_five,
            "Opioid-related deaths (count)" = count_opioid_death,
            "Foreign-born (%)" = foreign_born,
            "Male (%)" = male,
            "Employed (%)" = employed,
            "Spanish-speaking (%)" = spanish_language
        ) |> 
        select(-fips, -sids_count, -pop_total) |>
        gtsummary::tbl_summary(
            by = sids_present,
            missing = "no"
        ) |>
        gtsummary::as_gt(rowname_col = "variable") |>
        cols_hide(columns = label) |> 
        tab_header(
            md(
                "Comparing Cook County, IL, Census Tracts <br>
                With and Without Incidence of SUID from 2015-2019"
            )
        ) |> 
        gtsave(
            "tables_and_figures/table_of_vars_by_sids_present.png"
        )

}

plot_raincloud_by_sids_present <- function(sids_df, x_text_param, label_param) {
    
    sids_df$sids_present_factor <-
        factor(
            sids_df$sids_present,
            levels = c(FALSE, TRUE),
            labels = c("SIDS Absent", "SIDS Present")
        )
    
    sids_df |>
        ggplot(
            aes(
                x = .data[[x_text_param]], 
                y = sids_present_factor,
                color = sids_present_factor
            ),
        ) +
        scale_color_discrete(        
            name = "",
            type = c("steelblue3", "red2")
        ) +
        stat_halfeye(show.legend = FALSE) +
        stat_dotsinterval(side = "bottom", show.legend = FALSE) +
        labs(
            title = 
                paste0(
                    "Comparing ", 
                    label_param, 
                    " Cook County Census Tracts \n With and Without Presence of SIDS Cases from 2015-2019"
                    
                ),
            x = paste0(label_param, " Census Tract"),
            y = ""
        ) +
        theme_minimal() 
    
    ggsave(
        paste0("tables_and_figures/raincloud_of_", x_text_param, "_by_sids_present.svg"),
        width = 9,
        height = 6,
        units = "in"
    )
}
