tabulate_by_suid_present_comm <- function(suid_sf) {
    
    library(gt)
    
    table1 <- 
        suid_sf |>
        as_tibble() |> 
        select(
            suid_present,
            "Median Age (years)" = e_median_age,
            #"Dependency Ratio (per 100)" = dependency_ratio,
            #"Under 5 Years Old (%)" = under_5_perc,
            "Sex Ratio (males per 100 females)" = e_sex_ratio,
            #"Females Completing At Least High School (%)" = female_high_school_perc,
            #"Females, 15-44 Years Old (%)" = female_15_to_44,
            "Non-Hispanic White, Alone (%)" = ep_non_hisp_white_alone,
            "Non-Hispanic Black, Alone (%)" = ep_non_hisp_black_alone,
            "Asian, Any (%)" = ep_asian_any,
            "American Indian and Alaska Native, Any (%)" = ep_aian_any,
            "Hispanic, Any (%)" = ep_hispanic_any,
            "Total Population" = e_totpop,
            "Total People Living Below Poverty" = e_pov,
            "Total Crowded Households" = e_crowd
            # "Overall SVI" = rpl_themes,
            # "Socioeconomic SVI" = rpl_theme1,
            # "Household Composition SVI" = rpl_theme2,
            # "Minority Status/Language SVI" = rpl_theme3,
            # "Housing Type/Transportation SVI" = rpl_theme4,
            # "Unemployed Residents" = ep_unemp,
            # "Single-Parent Households" = ep_sngpnt,
            # "Minority Residents" = ep_minrty,
            # "No-Vehicle Households" = ep_noveh,
            # "Currently Smoking" = ep_smoking,
            # "Binge Drinking" = ep_binge
            # "Black (%)" = black,
            # "White (%)" = white,
            # "Hispanic (%)" = hispanic,
            # "Less than high school (%)" = lt_high_school,
            # "High school diploma (%)" = high_school_diploma,
            # "Some college (%)" = some_college,
            # "College diploma (%)" = college_diploma,
            # "Divorced, widowed females (%)" = divorced_widowed_females,
            # "Divorced, widowed males (%)" = divorced_widowed_males,
            # "Married females (%)" = married_females,
            # "Married males (%)" = married_males,
            # #"Average number of people per household" = avg_peop_per_household,
            # "Earning < national 10th percentile (%)" = income_lt_10,
            # "Earning < national 25th percentile (%)" = income_lt_25,
            # "Earning < national 50th percentile (%)" = income_lt_50,
            # "Earning < national 75th percentile (%)" = income_lt_75,
            # "Earning > national 75th percentile (%)" = income_gt_75,
            # "Private insurance (%)" = private_insurance,
            # "Public insurance (%)" = public_insurance,
            # "No insurance (%)" = no_insurance,
            # "SVI household composition & disability (national %ile)" = svi_household_composition_disability,
            # "SVI socioeconomic status (national %ile)" = svi_socioeconomic,
            # "SVI minority status & language (national %ile)" = svi_minority_language,
            # "SVI housing type & transportation (national %ile)" = svi_housing_transportation,
            # "SVI summary (national %ile)" = svi_summary_ranking,
            # "Population under 5 years old (%)" = under_5_perc,
            # "Foreign-born (%)" = foreign_born,
            # "Male (%)" = male,
            # "Employed (%)" = employed,
            # "Spanish-speaking (%)" = spanish_language
        ) |> 
        #select(-fips, -suid_count, -suid_count_factor, -pop_total_est, -pop_under_five_est, -pop_under_five, -pop_total_moe, -pop_under_five_moe,  -geometry, -neighbors, -weights) |>
        gtsummary::tbl_summary(
            by = suid_present,
            missing = "no",
            digits = list(gtsummary::all_continuous() ~  c(0,0,0))
        ) |>
        gtsummary::as_gt(rowname_col = "variable") |>
        cols_hide(columns = label) |> 
        cols_label(
            stat_1 = md("**No SUID**, n = 102"),
            stat_2 = md("**SUID Present**, n = 97"),
        ) |>
        # tab_header(
        #     md(
        #         "Comparing Census Tracts of Cook County, IL <br>
        #         by Presence of SUID from 2015-2019"
        #     )
        # ) |>
        rm_header(
        ) |> 
        tab_row_group(
            md("**Modeling Variables**"),
            c(
                "Total Population",
                "Total People Living Below Poverty",
                "Total Crowded Households"
            )
        ) |> 
        # tab_row_group(
        #     md("**Substance Use (%)**"),
        #     c(
        #         "Binge Drinking",
        #         "Currently Smoking"
        #     )
        # ) |>
        # tab_row_group(
        #     md("**Selected SVI Sub-Metrics (%)**"),
        #     c(
        #         "No-Vehicle Households",
        #         "Minority Residents",
        #         "Single-Parent Households",
        #         "Unemployed Residents"
        #     )
        # ) |> 
        # tab_row_group(
        #     md("**Socioecononomic Vulnerability Index (national percentile)**"),
        #     matches("SVI")
        # ) |>
        # tab_row_group(
        #     md("**Health Insurance Status**"),
        #     matches("insurance")
        # ) |>
        # #tab_row_group(md("**Household Density**"), "Average number of people per household") |> 
        # tab_row_group(
        #     md("**Marital Status**"),
        #     matches("^Married|^Divorced")
        # ) |>
        # tab_row_group(
        #     md("**Income**"),
        #     c(
        #         "Earning < national 10th percentile (%)",
        #         "Earning < national 25th percentile (%)",
        #         "Earning < national 50th percentile (%)",
        #         "Earning < national 75th percentile (%)",
        #         "Earning > national 75th percentile (%)"
        #     )
        # ) |>
        # tab_row_group(md("**Employment**"), "Employed (%)") |> 
        # tab_row_group(
        #     md("**Education**"), 
        #     c(
        #         "Less than high school (%)",
        #         "High school diploma (%)",
        #         "Some college (%)",
        #         "College diploma (%)"
        #     )
        # ) |> 
        # tab_row_group(
        #     md("**Culture**"), 
        #     c(
        #         "Spanish-speaking (%)",
        #         "Foreign-born (%)"
        #     )
        # ) |>
        tab_row_group(
            md("**Race/Ethnicity**"),
            c(
                "Non-Hispanic White, Alone (%)",
                "Non-Hispanic Black, Alone (%)",
                "Asian, Any (%)",
                "American Indian and Alaska Native, Any (%)",
                "Hispanic, Any (%)"
            )
        ) |>
        tab_row_group(md("**Sex**"), "Sex Ratio (males per 100 females)") |> 
        tab_row_group(md("**Age**"), "Median Age (years)") |> 
        tab_style(
            style = cell_text(align = "left"),
            locations = cells_stub()
        )
    
    return(table1)
    
}