make_table_by_suid_present <- function(suid_sf) {
    
    table1 <- 
        suid_sf |>
        as_tibble() |> 
        mutate(
            pop_under_five = 
                round(
                    pop_under_five / pop_total * 100, 
                    digits = 1
                )
        ) |> 
        rename(
            "Black (%)" = black,
            "White (%)" = white,
            "Hispanic (%)" = hispanic,
            "Less than high school (%)" = lt_high_school,
            "High school diploma (%)" = high_school_diploma,
            "Some college (%)" = some_college,
            "College diploma (%)" = college_diploma,
            "Divorced, widowed females (%)" = divorced_widowed_females,
            "Divorced, widowed males (%)" = divorced_widowed_males,
            "Married females (%)" = married_females,
            "Married males (%)" = married_males,
            "Average number of people per household" = avg_peop_per_household,
            "Earning > national 75th percentile (%)" = income_gt_75,
            "Earning < national 10th percentile (%)" = income_lt_10,
            "Earning < national 25th percentile (%)" = income_lt_25,
            "Earning < national 50th percentile (%)" = income_lt_50,
            "Earning < national 75th percentile (%)" = income_lt_75,
            "Private insurance (%)" = private_insurance,
            "Public insurance (%)" = public_insurance,
            "No insurance (%)" = no_insurance,
            "SVI household composition & disability (national %ile)" = svi_household_composition_disability,
            "SVI socioeconomic status (national %ile)" = svi_socioeconomic,
            "SVI minority status & language (national %ile)" = svi_minority_language,
            "SVI housing type & transportation (national %ile)" = svi_housing_transportation,
            "SVI summary (national %ile)" = svi_summary_ranking,
            "Population under 5 years old (%)" = pop_under_five,
            "Opioid-related deaths (count)" = count_opioid_death,
            "Foreign-born (%)" = foreign_born,
            "Male (%)" = male,
            "Employed (%)" = employed,
            "Spanish-speaking (%)" = spanish_language
        ) |> 
        select(-fips, -suid_count, -suid_count_factor, -pop_total, -geometry) |>
        gtsummary::tbl_summary(
            by = suid_present,
            missing = "no"
        ) |>
        gtsummary::as_gt(rowname_col = "variable") |>
        cols_hide(columns = label) |> 
        cols_label(
            stat_1 = md("**No SUID**, n = 1,078"),
            stat_2 = md("**SUID Present**, n = 237"),
        ) |> 
        tab_row_group(md("**Drug Use**"), "Opioid-related deaths (count)") |>
        tab_header(
            md(
                "Comparing Cook County, IL, Census Tracts <br>
                by Presence of SUID from 2015-2019"
            )
        ) |> 
        tab_row_group(
            md("**Social Vulnerability Index**"),
            matches("^SVI")
        ) |>
        tab_row_group(
            md("**Health Insurance Status**"),
            matches("insurance")
        ) |>
        tab_row_group(md("**Household Density**"), "Average number of people per household") |> 
        tab_row_group(
            md("**Marital Status**"),
            matches("^Married|^Divorced")
        ) |>
        tab_row_group(
            md("**Income**"),
            starts_with("Earning")
        ) |>
        tab_row_group(md("**Employment**"), "Employed (%)") |> 
        tab_row_group(
            md("**Education**"), 
            c(
                "Less than high school (%)",
                "High school diploma (%)",
                "Some college (%)",
                "College diploma (%)"
            )
        ) |> 
        tab_row_group(
            md("**Culture**"), 
            c(
                "Spanish-speaking (%)",
                "Foreign-born (%)"
            )
        ) |> 
        tab_row_group(
            md("**Race/Ethnicity**"), 
            c(
                "Black (%)",
                "White (%)",
                "Hispanic (%)"
            )
        ) |> 
        tab_row_group(md("**Gender**"), "Male (%)") |> 
        tab_row_group(md("**Age**"), "Population under 5 years old (%)") |> 
        tab_style(
            style = cell_text(align = "center"),
            locations = cells_stub()
        ) 
    
    return(table1)
    
}